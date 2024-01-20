-- ffi setup
local ffi = require("ffi")
local C = ffi.C

local Lib = require("extensions.sn_mod_support_apis.lua_library")
local menu = {}
local ic_menu = {
    propertySorterType = "name",
    showSimpleView = false,
    onlyDamagedShips = false
}
local config = {
    layers = {
        { name = ReadText(1001, 3252),  shortname = ReadText(1001, 11626),  icon = "mapst_fs_trade",        mode = "layer_trade",       helpOverlayID = "layer_trade",      helpOverlayText = ReadText(1028, 3214)  },
        { name = ReadText(1001, 8329),  shortname = ReadText(1001, 11629),  icon = "mapst_fs_mining",       mode = "layer_mining",      helpOverlayID = "layer_mining",     helpOverlayText = ReadText(1028, 3216)  },
        { name = ReadText(1001, 3254),  shortname = ReadText(1001, 11628),  icon = "mapst_fs_other",        mode = "layer_other",       helpOverlayID = "layer_other",      helpOverlayText = ReadText(1028, 3217)  },
        { name = ReadText(9814072, 3),  icon = "mapst_infocenter",      mode = "layer_infocenter" },
    },
    layersettings = {
        ["layer_trade"] = {
            callback = function (value) return C.SetMapRenderTradeOffers(menu.holomap, value) end,
            [1] = {
                caption = ReadText(1001, 46),
                info = ReadText(1001, 3279),
                overrideText = ReadText(1001, 8378),
                type = "multiselectlist",
                id = "trade_wares",
                callback = function (...) return menu.filterTradeWares(...) end,
                listOptions = function (...) return menu.getFilterTradeWaresOptions(...) end,
                displayOption = function (option) return "\27[maptr_supply] " .. GetWareData(option, "name") end,
            },
            [2] = {
                caption = ReadText(1001, 1400),
                type = "checkbox",
                callback = function (...) return menu.filterTradeStorage(...) end,
                [1] = {
                    id = "trade_storage_container",
                    name = ReadText(20205, 100),
                    info = ReadText(1001, 3280),
                    param = "container",
                },
                [2] = {
                    id = "trade_storage_solid",
                    name = ReadText(20205, 200),
                    info = ReadText(1001, 3281),
                    param = "solid",
                },
                [3] = {
                    id = "trade_storage_liquid",
                    name = ReadText(20205, 300),
                    info = ReadText(1001, 3282),
                    param = "liquid",
                },
                [4] = {
                    id = "trade_storage_condensate",
                    name = ReadText(20205, 1100),
                    info = ReadText(1001, 11614),
                    param = "condensate",
                },
            },
            [3] = {
                caption = ReadText(1001, 2808),
                type = "slidercell",
                callback = function (...) return menu.filterTradePrice(...) end,
                [1] = {
                    id = "trade_price_maxprice",
                    name = ReadText(1001, 3284),
                    info = ReadText(1001, 3283),
                    param = "maxprice",
                    scale = {
                        min       = 0,
                        max       = 10000,
                        step      = 1,
                        suffix    = ReadText(1001, 101),
                        exceedmax = true
                    }
                },
            },
            [4] = {
                caption = ReadText(1001, 8357),
                type = "dropdown",
                callback = function (...) return menu.filterTradeVolume(...) end,
                [1] = {
                    id = "trade_volume",
                    info = ReadText(1001, 8358),
                    listOptions = function (...) return menu.getFilterTradeVolumeOptions(...) end,
                    param = "volume"
                },
            },
            [5] = {
                caption = ReadText(1001, 11205),
                type = "dropdown",
                callback = function (...) return menu.filterTradePlayerOffer(...) end,
                [1] = {
                    id = "trade_playeroffer_buy",
                    info = ReadText(1001, 11209),
                    listOptions = function (...) return menu.getFilterTradePlayerOfferOptions(true) end,
                    param = "playeroffer_buy"
                },
                [2] = {
                    id = "trade_playeroffer_sell",
                    info = ReadText(1001, 11210),
                    listOptions = function (...) return menu.getFilterTradePlayerOfferOptions(false) end,
                    param = "playeroffer_sell"
                },
            },
            [6] = {
                caption = ReadText(1001, 11240),
                type = "checkbox",
                callback = function (...) return menu.filterTradeRelation(...) end,
                [1] = {
                    id = "trade_relation_enemy",
                    name = ReadText(1001, 11241),
                    info = ReadText(1001, 11242),
                    param = "enemy",
                },
            },
            [7] = {
                caption = ReadText(1001, 8343),
                type = "slidercell",
                callback = function (...) return menu.filterTradeOffer(...) end,
                [1] = {
                    id = "trade_offer_number",
                    name = ReadText(1001, 8344),
                    info = ReadText(1001, 8345),
                    param = "number",
                    scale = {
                        min       = 0,
                        minSelect = 1,
                        max       = 5,
                        step      = 1,
                        exceedmax = true,
                    }
                },
            },
        },
        ["layer_fight"] = {},
        ["layer_think"] = {},
        ["layer_build"] = {},
        ["layer_diplo"] = {},
        ["layer_mining"] = {
            callback = function (value) return menu.filterMining(value) end,
            [1] = {
                caption = ReadText(1001, 8330),
                type = "checkbox",
                callback = function (...) return menu.filterMiningResources(...) end,
                [1] = {
                    id = "mining_resource_display",
                    name = ReadText(1001, 8331),
                    info = ReadText(1001, 8332),
                    param = "display"
                },
            },
        },
        ["layer_other"] = {
            callback = function (value) return menu.filterOther(value) end,
            [1] = {
                caption = ReadText(1001, 3285),
                type = "dropdown",
                callback = function (...) return menu.filterThinkAlert(...) end,
                [1] = {
                    info = ReadText(1001, 3286),
                    id = "think_alert",
                    listOptions = function (...) return menu.getFilterThinkAlertOptions(...) end,
                    param = "alert"
                },
            },
            [2] = {
                caption = ReadText(1001, 11204),
                type = "checkbox",
                callback = function (...) return menu.filterThinkDiplomacy(...) end,
                [1] = {
                    id = "think_diplomacy_factioncolor",
                    name = ReadText(1001, 11203),
                    param = "factioncolor",
                },
                [2] = {
                    id = "think_diplomacy_highlightvisitor",
                    name = ReadText(1001, 11216),
                    info = ReadText(1001, 11217),
                    param = "highlightvisitors",
                },
            },
            [3] = {
                caption = ReadText(1001, 2664),
                type = "checkbox",
                callback = function (...) return menu.filterOtherMisc(...) end,
                [1] = {
                    id = "other_misc_ecliptic",
                    name = ReadText(1001, 3297),
                    info = ReadText(1001, 3298),
                    param = "ecliptic",
                },
                [2] = {
                    id = "other_misc_wrecks",
                    name = ReadText(1001, 8382),
                    info = ReadText(1001, 8383),
                    param = "wrecks",
                },
                [3] = {
                    id = "other_misc_selection_lines",
                    name = ReadText(1001, 11214),
                    info = ReadText(1001, 11215),
                    param = "selectionlines",
                },
                [4] = {
                    id = "other_misc_gate_connections",
                    name = ReadText(1001, 11243),
                    info = ReadText(1001, 11244),
                    param = "gateconnections",
                },
                [5] = {
                    id = "other_misc_opacity",
                    name = ReadText(1001, 11245),
                    info = ReadText(1001, 11246),
                    param = "opacity",
                },
                [6] = {
                    id = "other_misc_coveroverride",
                    name = ReadText(1001, 11604),
                    info = ReadText(1001, 11605),
                    param = "coveroverride",
                    active = Helper.isPlayerCovered,
                },
                [7] = {
                    id = "other_misc_rendersatelliteradarrange",
                    name = ReadText(1001, 11637),
                    info = ReadText(1001, 11638),
                    param = "rendersatelliteradarrange",
                },
            },
            [4] = {
                caption = ReadText(1001, 8336),
                type = "checkbox",
                callback = function (...) return menu.filterOtherShip(...) end,
                [1] = {
                    id = "other_misc_orderqueue",
                    name = ReadText(1001, 3287),
                    info = ReadText(1001, 8372),
                    param = "orderqueue",
                },
                [2] = {
                    id = "other_misc_allyorderqueue",
                    name = ReadText(1001, 8370),
                    info = ReadText(1001, 8371),
                    param = "allyorderqueue",
                },
            },
            [5] = {
                caption = ReadText(1001, 8335),
                type = "checkbox",
                callback = function (...) return menu.filterOtherStation(...) end,
                [1] = {
                    id = "other_misc_missions",
                    name = ReadText(1001, 3291),
                    info = ReadText(1001, 3292),
                    param = "missions",
                },
                [2] = {
                    id = "other_misc_civilian",
                    name = ReadText(1001, 8333),
                    info = ReadText(1001, 8334),
                    param = "civilian",
                },
            },
        },
        ["layer_infocenter"] = {
            callback = function (value) return ic_menu.filterInfoCenter(value) end,
            [1] = {
                caption = ReadText(9814072, 10),
                type = "checkbox",
                callback = function (...) return ic_menu.filterInfoCenterOptionsObjectTypes(...) end,
                [1] = {
                    id = "infocenter_stations",
                    name = ReadText(9814072, 11),
                    info = ReadText(9814072, 11),
                    param = "ic_stations",
                },
                [2] = {
                    id = "infocenter_wings",
                    name = ReadText(9814072, 12),
                    info = ReadText(9814072, 12),
                    param = "ic_wings",
                },
                [3] = {
                    id = "infocenter_ships",
                    name = ReadText(9814072, 13),
                    info = ReadText(9814072, 13),
                    param = "ic_ships",
                },
            },
            [2] = {
                caption = ReadText(9814072, 20),
                type = "checkbox",
                callback = function (...) return ic_menu.filterInfoCenterOptionsShipClasses(...) end,
                [1] = {
                    id = "infocenter_shipclassS",
                    name = ReadText(9814072, 21),
                    info = ReadText(9814072, 21),
                    param = "ic_shipclassS",
                },
                [2] = {
                    id = "infocenter_shipclassM",
                    name = ReadText(9814072, 22),
                    info = ReadText(9814072, 22),
                    param = "ic_shipclassM",
                },
                [3] = {
                    id = "infocenter_shipclassL",
                    name = ReadText(9814072, 23),
                    info = ReadText(9814072, 23),
                    param = "ic_shipclassL",
                },
                [4] = {
                    id = "infocenter_shipclassXL",
                    name = ReadText(9814072, 24),
                    info = ReadText(9814072, 24),
                    param = "ic_shipclassXL",
                },
            },
            [3] = {
                caption = ReadText(9814072, 30),
                type = "checkbox",
                callback = function (...) return ic_menu.filterInfoCenterOptionsDeployables(...) end,
                [1] = {
                    id = "infocenter_lasertowers",
                    name = ReadText(9814072, 31),
                    info = ReadText(9814072, 31),
                    param = "ic_lasertowers",
                },
                [2] = {
                    id = "infocenter_mines",
                    name = ReadText(9814072, 32),
                    info = ReadText(9814072, 32),
                    param = "ic_mines",
                },
                [3] = {
                    id = "infocenter_navbeacons",
                    name = ReadText(9814072, 33),
                    info = ReadText(9814072, 33),
                    param = "ic_navbeacons",
                },
                [4] = {
                    id = "infocenter_resourceprobes",
                    name = ReadText(9814072, 34),
                    info = ReadText(9814072, 34),
                    param = "ic_resourceprobes",
                },
                [5] = {
                    id = "infocenter_satellites",
                    name = ReadText(9814072, 35),
                    info = ReadText(9814072, 35),
                    param = "ic_satellites",
                },
                [6] = {
                    id = "infocenter_lockboxes",
                    name = ReadText(9814072, 36),
                    info = ReadText(9814072, 36),
                    param = "ic_lockboxes",
                },
            },
            [4] ={
                caption = ReadText(9814072, 40),
                type = "checkbox",
                callback = function (...) return ic_menu.filterInfoCenterOptionsShipTypes(...) end,
                [1] = {
                    id = "infocenter_fighters",
                    name = ReadText(9814072, 41),
                    info = ReadText(9814072, 41),
                    param = "ic_fighters",
                },
                [2] = {
                    id = "infocenter_traders",
                    name = ReadText(9814072, 42),
                    info = ReadText(9814072, 42),
                    param = "ic_traders",
                },
                [3] = {
                    id = "infocenter_miners",
                    name = ReadText(9814072, 43),
                    info = ReadText(9814072, 43),
                    param = "ic_miners",
                },
                [4] = {
                    id = "infocenter_builders",
                    name = ReadText(9814072, 44),
                    info = ReadText(9814072, 44),
                    param = "ic_builders",
                },
                [5] = {
                    id = "infocenter_shipresupply",
                    name = ReadText(9814072, 45),
                    info = ReadText(9814072, 45),
                    param = "ic_shipresupply",
                },
                [6] = {
                    id = "infocenter_shiptug",
                    name = ReadText(9814072, 46),
                    info = ReadText(9814072, 46),
                    param = "ic_shiptug",
                },
                [7] = {
                    id = "infocenter_shiprecycling",
                    name = ReadText(9814072, 47),
                    info = ReadText(9814072, 47),
                    param = "ic_shiprecycling",
                },
            },
            [5] = {
                caption = ReadText(9814072, 50),
                type = "checkbox",
                callback = function (...) return ic_menu.filterInfoCenterOptionsOther(...) end,
                [1] = {
                    id = "infocenter_shieldhull",
                    name = ReadText(9814072, 51),
                    info = ReadText(9814072, 51),
                    param = "ic_shieldhull",
                },
                [2] = {
                    id = "infocenter_tradeitem",
                    name = ReadText(9814072, 52),
                    info = ReadText(9814072, 52),
                    param = "ic_tradeitem",
                },
                [3] = {
                    id = "infocenter_minerstorage",
                    name = ReadText(9814072, 53),
                    info = ReadText(9814072, 53),
                    param = "ic_minerstorage",
                },
                [4] = {
                    id = "infocenter_stationbalance",
                    name = ReadText(9814072, 54),
                    info = ReadText(9814072, 54),
                    param = "ic_stationbalance",
                },
                [5] = {
                    id = "infocenter_sorterrow",
                    name = ReadText(9814072, 55),
                    info = ReadText(9814072, 55),
                    param = "ic_sorterrow",
                },
                [6] = {
                    id = "infocenter_showSimpleViewOptions",
                    name = ReadText(9814072, 56),
                    info = ReadText(9814072, 56),
                    param = "ic_showSimpleViewOptions",
                },
                [7] = {
                    id = "infocenter_altrowcolor",
                    name = ReadText(9814072, 57),
                    info = ReadText(9814072, 57),
                    param = "ic_altrowcolor",
                }
            },
        },
    },
	mapRowHeight = Helper.standardTextHeight,
	mapFontSize = Helper.standardFontSize,
	mainFrameLayer = 6,
	infoFrameLayer2 = 5,
	infoFrameLayer = 4,
	contextFrameLayer = 3,
	contextBorder = 5,
    assignments = {
        ["defence"]                 = { name = ReadText(20208, 40301) },
        ["attack"]                  = { name = ReadText(20208, 40901) },
        ["interception"]            = { name = ReadText(20208, 41001) },
        ["follow"]                  = { name = ReadText(20208, 41301) },
        ["supplyfleet"]             = { name = ReadText(20208, 40701) },
        ["mining"]                  = { name = ReadText(20208, 40201) },
        ["trade"]                   = { name = ReadText(20208, 40101) },
        ["tradeforbuildstorage"]    = { name = ReadText(20208, 40801) },
        ["assist"]                  = { name = ReadText(20208, 41201) }
    },
    classList_t = {
        ["station"] = "stationtypes",
        ["ship_xl"] = "shiptypes_xl",
        ["ship_l"] = "shiptypes_l",
        ["ship_m"] = "shiptypes_m",
        ["ship_s"] = "shiptypes_s",
        ["ship_xs"] = "shiptypes_xs"
    },
    purpose_t = {
        ["fight"] = "fight",
        ["trade"] = "trade", 
        ["mine"] = "mine",
        ["build"] = "build",
        ["auxiliary"] = "auxiliary",
        ["salvage"] = "salvage",
        ["dismantling"] = "dismantling"

    },
    filter_t = {
        ["fight"] = "infocenter_fighters",
        ["trade"] = "infocenter_traders",
        ["mine"] = "infocenter_miners",
        ["build"] = "infocenter_builders",
        ["auxiliary"] = "infocenter_shipresupply",
        ["salvage"] = "infocenter_shiptug",
        ["dismantling"] = "infocenter_shiprecycling"
    },
    ic_shipclass_t = {
        ["ship_s"] = "infocenter_shipclassS",
        ["ship_m"] = "infocenter_shipclassM",
        ["ship_l"] = "infocenter_shipclassL",
        ["ship_xl"] = "infocenter_shipclassXL",
        ["issupplyship"] = "infocenter_shipresupply",
        ["salvage"] = "infocenter_shiptug",
        ["dismantling"] = "infocenter_shiprecycling"
    },
    deployables_t = {
        ["station"] = "infocenter_stations",
        ["mine"] = "infocenter_mines",
        ["navbeacon"] = "infocenter_navbeacons",
        ["resourceprobe"] = "infocenter_resourceprobes",
        ["satellite"] = "infocenter_satellites",
        ["lockbox"] = "infocenter_lockboxes",
    },
}

local function init()
	DebugError("InfoCenter Init")

	menu = Lib.Get_Egosoft_Menu("MapMenu")
	
	menu.registerCallback("ic_onSelectElement", ic_menu.onSelectElement)
	menu.registerCallback("ic_onTableRightMouseClick", ic_menu.onTableRightMouseClick)
	menu.registerCallback("ic_onRowChanged", ic_menu.onRowChanged)
	menu.registerCallback("ic_createSideBar", ic_menu.createSideBar)
    menu.registerCallback("ic_createInfoFrame", ic_menu.createInfoFrame)
	menu.createFilterMode = ic_menu.createFilterMode

	-- RegisterEvent("infocenter.openInfoCenterWithHotkey", ic_menu.openInfoCenterWithHotkey)
end

function ic_menu.filterInfoCenter(value)
	for _, setting in ipairs(config.layersettings["layer_infocenter"]) do
		if value then
			setting.callback(setting)
		else
			setting.callback(setting, false)
		end
	end
end

function ic_menu.filterInfoCenterOptionsObjectTypes(setting, override)
	for _, option in ipairs(setting) do
		local value = override
		if value == nil then
			value = menu.getFilterOption(option.id) or false
		end
		if option.param == "ic_stations" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_stations"] = value
		elseif option.param == "ic_wings" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_wings"] = value
		elseif option.param == "ic_ships" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_ships"] = value
		end
	end
	menu.refreshInfoFrame()
end

function ic_menu.filterInfoCenterOptionsShipClasses(setting, override)
	for _, option in ipairs(setting) do
		local value = override
		if value == nil then
			value = menu.getFilterOption(option.id) or false
		end
		if option.param == "ic_shipclassS" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_shipclassS"] = value
		elseif option.param == "ic_shipclassM" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_shipclassM"] = value
		elseif option.param == "ic_shipclassL" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_shipclassL"] = value
		elseif option.param == "ic_shipclassXL" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_shipclassXL"] = value
		end
	end
	menu.refreshInfoFrame()
end

function ic_menu.filterInfoCenterOptionsDeployables(setting, override)
	for _, option in ipairs(setting) do
		local value = override
		if value == nil then
			value = menu.getFilterOption(option.id) or false
		end
        if option.param == "ic_lasertowers" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_lasertowers"] = value
		elseif option.param == "ic_mines" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_mines"] = value
		elseif option.param == "ic_resourceprobes" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_resourceprobes"] = value
		elseif option.param == "ic_navbeacons" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_navbeacons"] = value
		elseif option.param == "ic_satellites" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_satellites"] = value
		elseif option.param == "ic_lockboxes" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_lockboxes"] = value
		end
	end
	menu.refreshInfoFrame()
end


function ic_menu.filterInfoCenterOptionsShipTypes(setting, override)
	for _, option in ipairs(setting) do
		local value = override
		if value == nil then
			value = menu.getFilterOption(option.id) or false
		end
        if option.param == "ic_fighers" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_fighers"] = value
		elseif option.param == "ic_traders" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_traders"] = value
		elseif option.param == "ic_miners" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_miners"] = value
		elseif option.param == "ic_builders" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_builders"] = value
        elseif option.param == "ic_shipresupply" then
            __CORE_DETAILMONITOR_MAPFILTER["infocenter_shipresupply"] = value
        elseif option.param == "ic_shiptug" then
            __CORE_DETAILMONITOR_MAPFILTER["infocenter_shiptug"] = value
        elseif option.param == "ic_shiprecycling" then
            __CORE_DETAILMONITOR_MAPFILTER["infocenter_shiprecycling"] = value
		end
	end
	menu.refreshInfoFrame()
end

function ic_menu.filterInfoCenterOptionsOther(setting, override)
	for _, option in ipairs(setting) do
		local value = override
		if value == nil then
			value = menu.getFilterOption(option.id) or false
		end
		if option.param == "ic_shieldhull" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_shieldhull"] = value
		elseif option.param == "ic_tradeitem" then
			__CORE_DETAILMONITOR_MAPFILTER["infocenter_tradeitem"] = value
        elseif option.param == "ic_minerstorage" then
            __CORE_DETAILMONITOR_MAPFILTER["infocenter_minerstorage"] = value
        elseif option.param == "ic_stationbalance" then
            __CORE_DETAILMONITOR_MAPFILTER["infocenter_stationbalance"] = value
        elseif option.param == "ic_sorterrow" then
            __CORE_DETAILMONITOR_MAPFILTER["infocenter_sorterrow"] = value
        elseif option.param == "ic_showSimpleViewOptions" then
            __CORE_DETAILMONITOR_MAPFILTER["infocenter_showSimpleViewOptions"] = value
        elseif option.param == "ic_altrowcolor" then
            __CORE_DETAILMONITOR_MAPFILTER["infocenter_altrowcolor"] = value
		end
	end
	menu.refreshInfoFrame()
end

function ic_menu.createFilterMode(ftable, numCols)
    local title = ""
    local row = ftable:addRow("tabs", { fixed = true, bgColor = Helper.color.transparent })
    for i, entry in ipairs(config.layers) do
        local icon = entry.icon
        local bgcolor = Helper.defaultTitleBackgroundColor
        -- active filter groups get different colors
        if entry.mode == menu.displayedFilterLayer then
            title = entry.name
            bgcolor = Helper.defaultArrowRowBackgroundColor
        end
        -- if not menu.getFilterOption(entry.mode) then
        --     icon = icon .. "_disabled"
        -- end

        local colindex = i
        if i > 1 then
            colindex = colindex + 2
        end

        row[colindex]:setColSpan((i == 1) and 3 or 1):createButton({ height = menu.sideBarWidth, bgColor = bgcolor, mouseOverText = entry.name, scaling = false, helpOverlayID = entry.helpOverlayID, helpOverlayText = entry.helpOverlayText }):setIcon(icon, { })
        row[colindex].handlers.onClick = function () return menu.buttonFilterSwitch(entry.mode, row.index, colindex) end
    end

    local row = ftable:addRow(true, { fixed = true, bgColor = Helper.defaultTitleBackgroundColor })
    local color = Helper.color.white
    local onoffcolor = Helper.color.white
    local active = true
    if not __CORE_DETAILMONITOR_MAPFILTER[menu.displayedFilterLayer] then
        color = Helper.color.grey
        onoffcolor = Helper.color.red
        active = false
    end
    row[1]:setColSpan(2):createButton({ height = Helper.headerRow1Height, helpOverlayID = "toggle_trade_filter", helpOverlayText = " ", helpOverlayHighlightOnly = true}):setIcon("menu_on_off", { color = onoffcolor })
    row[1].handlers.onClick = function () return menu.buttonSetFilterLayer(menu.displayedFilterLayer, row.index, 1) end
    row[3]:setColSpan(numCols - 2):createText(title, Helper.headerRowCenteredProperties)

    local settings = config.layersettings[menu.displayedFilterLayer]
    for i, setting in ipairs(settings) do
        if i > 1 then
            ftable:addEmptyRow(config.mapRowHeight / 2)
        end

        local row = ftable:addRow(false, { bgColor = Helper.defaultTitleBackgroundColor })
        row[1]:setColSpan(numCols):createText(setting.caption, Helper.subHeaderTextProperties)
        row[1].properties.color = color

        if setting.type == "multiselectlist" then
            local list = menu.getFilterOption(setting.id) or {}
            for i, curOption in ipairs(list) do
                local index = i

                local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
                row[1]:setColSpan(numCols - 1):createText(setting.displayOption(curOption), { fontsize = config.mapFontSize })
                row[1].properties.color = color
                row[numCols]:createButton({ active = active }):setText("x", { halign = "center" })
                row[numCols].handlers.onClick = function () return menu.removeFilterOption(setting, setting.id, index) end
            end
            local row = ftable:addRow(true, {  })
            row[1]:setColSpan(numCols):createButton({ mouseOverText = setting.info, active = active }):setText(setting.overrideText, { halign = "center", fontsize = config.mapFontSize })
            row[1].handlers.onClick = function () return menu.setFilterOption(menu.displayedFilterLayer, setting, setting.id) end
        else
            for _, option in ipairs(setting) do
                local optionactive = true
                if option.active then
                    optionactive = option.active()
                end
                if setting.type == "checkbox" then
                    local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
                    row[1]:createCheckBox(menu.getFilterOption(option.id) or false, { scaling = false, width = Helper.scaleY(config.mapRowHeight), height = Helper.scaleY(config.mapRowHeight), active = active and optionactive })
                    row[1].handlers.onClick = function () return menu.setFilterOption(menu.displayedFilterLayer, setting, option.id) end
                    row[2]:setColSpan(numCols - 1):createText(option.name, { mouseOverText = option.info })
                    row[2].properties.color = color
                elseif setting.type == "slidercell" then
                    if option.scale.exceedmax then
                        option.scale.start = math.max(option.scale.min, menu.getFilterOption(option.id)) or option.scale.max
                    else
                        option.scale.start = math.max(option.scale.min, math.min(option.scale.max, menu.getFilterOption(option.id))) or option.scale.max
                    end
                    local row = ftable:addRow(true, { bgColor = Helper.color.transparent })
                    row[1]:setColSpan(numCols):createSliderCell({ height = config.mapRowHeight, min = option.scale.min, minSelect = option.scale.minSelect, max = option.scale.max, maxSelect = option.scale.maxSelect, start = option.scale.start, step = option.scale.step, suffix = option.scale.suffix, exceedMaxValue = option.scale.exceedmax, mouseOverText = option.info, readOnly = not active, bgColor = (not active) and Helper.color.transparent or nil, valueColor = (not active) and color or nil }):setText(option.name, {fontsize = config.mapFontSize})
                    row[1].handlers.onSliderCellChanged = function (_, value) menu.noupdate = true; return menu.setFilterOption(menu.displayedFilterLayer, setting, option.id, value) end
                    row[1].handlers.onSliderCellConfirm = function() menu.noupdate = false end
                elseif setting.type == "dropdown" then
                    local listOptions = option.listOptions()
                    local row = ftable:addRow(true, {  })
                    row[1]:setColSpan(numCols):createDropDown(listOptions, { height = config.mapRowHeight, startOption = menu.getFilterOption(option.id), mouseOverText = option.info, active = active }):setTextProperties({ fontsize = config.mapFontSize }):setText2Properties({ fontsize = config.mapFontSize, halign = "right" })
                    row[1].handlers.onDropDownConfirmed = function (_, id) return menu.setFilterOption(menu.displayedFilterLayer, setting, option.id, id) end
                    row[1].handlers.onDropDownActivated = function () menu.noupdate = true end
                end
            end
        end
    end
end

function ic_menu.getTargetTradeWare(ship)
	local ordertext = "None"

	local orders, defaultorder = {}, {}
	local n = C.GetNumOrders(ship)
	local buf = ffi.new("Order2[?]", n)
	n = C.GetOrders2(buf, n, ship)
	for i = 0, n - 1 do
		local order = {}
		order.state = ffi.string(buf[i].state)
		order.statename = ffi.string(buf[i].statename)
		order.orderdef = ffi.string(buf[i].orderdef)
		order.actualparams = tonumber(buf[i].actualparams)
		order.enabled = buf[i].enabled
		order.isinfinite = buf[i].isinfinite
		order.issyncpointreached = buf[i].issyncpointreached
		order.istemporder = buf[i].istemporder
		order.isoverride = buf[i].isoverride

		local orderdefinition = ffi.new("OrderDefinition")
		if order.orderdef ~= nil and C.GetOrderDefinition(orderdefinition, order.orderdef) then
			order.orderdef = {}
			order.orderdef.id = ffi.string(orderdefinition.id)
			order.orderdef.icon = ffi.string(orderdefinition.icon)
			order.orderdef.name = ffi.string(orderdefinition.name)
		else
			order.orderdef = { id = "", icon = "", name = "" }
		end

		table.insert(orders, order)
	end

	local params, paramvalue
	for i = 1, #orders do
		if orders[i].orderdef ~= nil then
			if orders[i].orderdef.id == "TradePerform" or orders[i].orderdef.id == "TradeExchange" then
				params = GetOrderParams(ship, i)

				paramvalue = menu.getParamValue(params[1].type, params[1].value)
				local tradeid = ConvertStringToLuaID(paramvalue)
				local tradedata = GetTradeData(tradeid)
				local warename = GetWareData(tradedata.ware, "name")
		
				ordertext = tradedata.amount .. " " .. warename
				break
			end
		end
	end

	return ordertext
end

function ic_menu.getOrderInfoText(ship)
	if not GetComponentData(ship, "isplayerowned") then
		return
	end

	local tradeitem
	if menu.getFilterOption("infocenter_tradeitem") and IsComponentClass(ship, "ship") then
		tradeitem = ic_menu.getTargetTradeWare(ship)
	end

	local ordertext, paramtext, actiontext = nil
	local entity = GetComponentData(ship, "controlentity")
	if entity == nil then
		return "-", "-"
	end
	local commandraw, command, commandparam, commandaction, commandactionparam = GetComponentData(entity, "aicommandraw", "aicommand", "aicommandparam", "aicommandaction", "aicommandactionparam")
	ordertext = command
	if commandparam ~= nil then
		if IsComponentClass(commandparam, "ship") or IsComponentClass(commandparam, "station") or IsComponentClass(commandparam, "sector") then
			local name, color = menu.getContainerNameAndColors(commandparam, 0, false, false)
			if IsComponentClass(commandparam, "sector") then
				name = name:gsub(" %(%)", "")
			end
            local white = Helper.color.white
			paramtext = string.format("\027#FF%02x%02x%02x#%s\027#FF%02x%02x%02x#", color.r, color.g, color.b, name, white.r, white.g, white.b)
		else
			paramtext = GetComponentData(commandparam, "name")
		end
		if menu.getFilterOption("infocenter_tradeitem") and tradeitem ~= "None" then
			command = command:gsub("%%s", "")
			ordertext = string.format("%s %s\n%s %s", command, paramtext, ReadText(9814072, 102), tradeitem)
		else
			ordertext = string.format(command, paramtext)
		end
	end

	actiontext = commandaction
	if commandactionparam ~= nil then
		if IsComponentClass(commandactionparam, "ship") or IsComponentClass(commandactionparam, "station") or IsComponentClass(commandactionparam, "sector") then
			local name, color = menu.getContainerNameAndColors(commandactionparam, 0, false, false)
			if IsComponentClass(commandactionparam, "sector") then
				name = name:gsub(" %(%)", "")
			end
            local white = Helper.color.white
			paramtext = string.format("\027#FF%02x%02x%02x#%s\027#FF%02x%02x%02x#", color.r, color.g, color.b, name, white.r, white.g, white.b)
		else
			paramtext = GetComponentData(commandactionparam, "name")
		end
		actiontext = string.format(commandaction, paramtext)
	end

	return ordertext, actiontext
end

function ic_menu.createSideBar(config)
	local isinfoCenterExists
	for _, leftBarEntry in ipairs (config.leftBar) do
		if leftBarEntry.mode == "infocenter" then
			isinfoCenterExists = true
		end
	end
	if not isinfoCenterExists then
		local entry = {
			name = ReadText(9814072, 2),
			icon = "mapst_infocenter",
			mode = "infocenter",
		}
        table.insert (config.leftBar, {spacing = true})
		table.insert (config.leftBar, entry)
	end
end

-- function ic_menu.openInfoCenterWithHotkey(_, params)
--     local event, mode = string.match(params, "(.+);(.+)")

--     if event == "onPress" then
--         if mode == "Open" then
--             menu.infoTableMode = "infocenter"
--             OpenMenu("MapMenu", { 0, 0 }, nil)
--         else
--             Helper.closeMenu(menu, "close")
--             menu.cleanup()
--         end
--     end
-- end

function ic_menu.createInfoFrame(infoFrame)
    if menu.infoTableMode == "infocenter" then
        ic_menu.createInfoCenter(menu.infoFrame, "left")
    end
end

function ic_menu.createSubordinateSection(instance, ftable, component, iteration, location, numdisplayed)
	local subordinates = menu.infoTableData[instance].subordinates[tostring(component)] or {}
	-- setup groups
	local groups = {}
	for _, subordinate in ipairs(subordinates) do
		local group = GetComponentData(subordinate, "subordinategroup")
		if group and group > 0 then
			if groups[group] then
				if (not groups[group].hasrendered) and (menu.infoTableMode == "objectlist") then
					groups[group].hasrendered = menu.renderedComponentsRef[ConvertIDTo64Bit(subordinate)]
				end
				table.insert(groups[group].subordinates, subordinate)
			else
				local isrendered = true
				if menu.infoTableMode == "objectlist" then
					isrendered = menu.renderedComponentsRef[ConvertIDTo64Bit(subordinate)]
				end
				groups[group] = { assignment = ffi.string(C.GetSubordinateGroupAssignment(ConvertIDTo64Bit(component), group)), subordinates = { subordinate }, hasrendered = isrendered }
			end
		end
	end

	for group = 1, 10 do
		if groups[group] and groups[group].hasrendered then
			local issubordinateextended = menu.isSubordinateExtended(tostring(component), group)
			if (not issubordinateextended) and menu.isCommander(component, group) then
				menu.extendedsubordinates[tostring(component) .. group] = true
				issubordinateextended = true
			end
			local row = ftable:addRow({"subordinates" .. tostring(component) .. group, component, group}, { bgColor = Helper.color.transparent })
			row[1]:createButton():setText(issubordinateextended and "-" or "+", { halign = "center" })
			row[1].handlers.onClick = function () return menu.buttonExtendSubordinate(tostring(component), group) end
			local text = string.format(ReadText(1001, 8398), ReadText(20401, group))
			for i = 1, iteration + 1 do
				text = "    " .. text
			end
			row[2]:setColSpan(12):createText(string.format("%s (%s)", text, config.assignments[groups[group].assignment] and config.assignments[groups[group].assignment].name or ""))
			if menu.highlightedborderstationcategory == "subordinates" .. tostring(component) .. group then
				menu.sethighlightborderrow = row.index
			end
			if issubordinateextended then
				for _, subordinate in ipairs(groups[group].subordinates) do
					if (menu.infoTableMode ~= "objectlist") or menu.renderedComponentsRef[ConvertIDTo64Bit(subordinate)] then
						numdisplayed = ic_menu.createInfoCenterRow(instance, ftable, subordinate, iteration + 2, location, numdisplayed)
					end
				end
			end
		end
	end

	return numdisplayed
end

function ic_menu.createInfoCenterRow(instance, ftable, component, iteration, commanderlocation, numdisplayed)
    local purpose = GetComponentData(component, "primarypurpose")
    local convertedComponent = ConvertStringTo64Bit(tostring(component))
    local componentClassName = ffi.string(C.GetComponentClass(convertedComponent))

    local isLasertower = GetMacroData(GetComponentData(component, "macro"), "islasertower")

    if IsComponentClass(component, componentClassName) and not isLasertower then
    	if componentClassName == "station" or not config.purpose_t[purpose] then
    		if not menu.getFilterOption(config.deployables_t[componentClassName]) then
                return numdisplayed
            end
        else
            if not (menu.getFilterOption(config.ic_shipclass_t[componentClassName]) and menu.getFilterOption(config.filter_t[purpose])) then
                return numdisplayed
            end
        end
    end

    if isLasertower and not menu.getFilterOption("infocenter_lasertowers") then
        return numdisplayed
    end 

    if ic_menu.showSimpleView and ic_menu.onlyDamagedShips then
        local isOperational = IsComponentOperational(convertedComponent)
        local hullPercent = GetComponentData(convertedComponent, "hullpercent") or 0
        if isOperational and not (hullPercent > 0 and hullPercent < 100) then
            return numdisplayed
        end
    end

    local maxicons = 5

	local subordinates = menu.infoTableData[instance].subordinates[tostring(component)] or {}
	local dockedships = menu.infoTableData[instance].dockedships[tostring(component)] or {}

	if (#menu.searchtext == 0) or Helper.textArrayHelper(menu.searchtext, function (numtexts, texts) return C.FilterComponentByText(convertedComponent, numtexts, texts, true) end, "text") then
		numdisplayed = numdisplayed + 1

		if (not menu.isPropertyExtended(tostring(component))) and (menu.isCommander(component) or menu.isDockContext(convertedComponent)) then
			menu.extendedproperty[tostring(component)] = true
		end

		local isstation = IsComponentClass(component, "station")
		local iswing = iteration == 0 and #subordinates > 0
		local name, color, bgcolor, font, mouseover = menu.getContainerNameAndColors(component, iteration, iswing, false)
		local alertString = ""

        if menu.getFilterOption("layer_think") then
			local alertStatus = menu.getContainerAlertLevel(component)
			local minAlertLevel = menu.getFilterOption("think_alert")
			if (minAlertLevel ~= 0) and alertStatus >= minAlertLevel then
				local color = Helper.color.white
				if alertStatus == 1 then
					color = menu.holomapcolor.lowalertcolor
				elseif alertStatus == 2 then
					color = menu.holomapcolor.mediumalertcolor
				else
					color = menu.holomapcolor.highalertcolor
				end
				alertString = string.format("\027#FF%02x%02x%02x#", color.r, color.g, color.b) .. "\027[workshop_error]\027X"
			end
		end
	
		local row = nil

		if isstation then
			row = ftable:addRow({"property", component, nil, iteration}, { bgColor = Helper.defaultSimpleBackgroundColor, multiSelected = menu.isSelectedComponent(component) })
        elseif menu.getFilterOption("infocenter_altrowcolor") then
            if numdisplayed % 2 == 0 then
                row = ftable:addRow({"property", component, nil, iteration}, { bgColor = bgcolor, multiSelected = menu.isSelectedComponent(component) })
            else
                local altcolor = Helper.color.darkgrey
    			row = ftable:addRow({"property", component, nil, iteration}, { bgColor = altcolor, multiSelected = menu.isSelectedComponent(component) })
            end
        else
            row = ftable:addRow({"property", component, nil, iteration}, { bgColor = bgcolor, multiSelected = menu.isSelectedComponent(component) })
		end

		if (menu.getNumSelectedComponents() == 1) and menu.isSelectedComponent(component) then
			menu.setrow = row.index
		end

		if IsSameComponent(component, menu.highlightedbordercomponent) then
			menu.sethighlightborderrow = row.index
		end

		if subordinates.hasRendered or (#dockedships > 0) then
			row[1]:createButton():setText(menu.isPropertyExtended(tostring(component)) and "-" or "+", { halign = "center" })
			row[1].handlers.onClick = function () return menu.buttonExtendProperty(tostring(component)) end
		end

		local location, locationtext, isdocked, aipilot = GetComponentData(component, "sectorid", "sector", "isdocked", "assignedaipilot")

		local currentordertext, currentactiontext = nil
	    currentordertext, currentactiontext = ic_menu.getOrderInfoText(convertedComponent)
		
		local wingtypes = menu.getPropertyOwnedFleetData(instance, component, maxicons)

        if purpose == "mine" and menu.getFilterOption("infocenter_minerstorage") then
            local transporttype = ffi.new("StorageInfo[?]", 1)
            C.GetCargoTransportTypes(transporttype, 1, convertedComponent, true, false)
            currentordertext = string.format("%s\n%s %d/%d", currentordertext, ReadText(9814072, 103), transporttype[0].spaceused, transporttype[0].capacity)
        end

		if isstation then
			if IsComponentConstruction(component) then
				row[2]:createText(alertString .. name, { font = font, color = color, mouseOverText = mouseover })
				row[3]:setColSpan(2):createText(locationtext, { halign = "center" })
				row[5]:setColSpan(9):createText(ReadText(9814072, 100), { halign = "center" })
			else
                if menu.getFilterOption("infocenter_stationbalance") then
                    local money = GetComponentData(component, "money") or 0
                    row[2]:createText(alertString .. name .. "\n" .. ReadText(9814072, 101) .. ": " .. ConvertMoneyString(money, false, true, nil, true) .. " Cr", { font = font, color = color, mouseOverText = mouseover })
                else
				    row[2]:createText(alertString .. name, { font = font, color = color, mouseOverText = mouseover })
				end
                row[3]:setColSpan(2):createText(locationtext, { halign = "center" })
				row[9]:setColSpan(5)
				for i, wingdata in ipairs(wingtypes) do
					local colidx = 4 + i
					if wingdata.icon then
						row[colidx]:createText(string.format("\027[%s]%d", wingdata.icon, wingdata.count), { halign = "center" })
					else
						row[colidx]:createText(string.format("...%d", wingdata.count), { halign = "center" })
					end
				end
			end
		elseif iswing then
			row[2]:createText(string.format("%s: \027#FF%02x%02x%02x#%s", ffi.string(C.GetFleetName(convertedComponent)), color.r, color.g, color.b, alertString .. name), { font = font, mouseOverText = mouseover })
			row[3]:setColSpan(2):createText(locationtext, { halign = "center" })
			row[9]:setColSpan(5)
			for i, wingdata in ipairs(wingtypes) do
				local colidx = 4 + i
				if wingdata.icon then
					row[colidx]:createText(string.format("\027[%s]%d", wingdata.icon, wingdata.count), { halign = "center" })
				else
					row[colidx]:createText(string.format("...%d", wingdata.count), { halign = "center" })
				end
			end
		else
			row[2]:createText(alertString .. name, { font = font, color = color, mouseOverText = mouseover })
			row[3]:setColSpan(2):createText(locationtext, { halign = "center" })
			row[5]:setColSpan(3):createText(currentordertext, { halign = "center" })
			if menu.getFilterOption("infocenter_shieldhull") then
				row[8]:setColSpan(5):createText(currentactiontext, { halign = "center" })
				row[13]:createObjectShieldHullBar(component, { height = config.mapRowHeight / 2 })
			else
				row[8]:setColSpan(6):createText(currentactiontext, { halign = "center" })
			end
		end

		if row[1].type == "button" then
			row[1].properties.height = row[2]:getMinTextHeight(false)
		end

        local class_s = C.GetComponentClass(convertedComponent)
        
        if config.classList_t[C.GetComponentClass(convertedComponent)] then
            AddKnownItem(config.classList_t[class_s], GetComponentData(component, "macro"))
        end

		if menu.isPropertyExtended(tostring(component)) then
			-- subordinates
			if subordinates.hasRendered then
				-- Commander
				if not IsComponentClass(component, "station") then
					local row = ftable:addRow({"property", component, nil, iteration}, { bgColor = Helper.color.transparent, multiSelected = menu.isSelectedComponent(component) })
					row[1]:createText("\27[menu_star_04]", { halign = "center", color = Helper.color.brightyellow})
					row[2]:createText(alertString .. name, { font = font, color = color, mouseOverText = mouseover })
					row[3]:setColSpan(2):createText(locationtext, { halign = "center" })
					row[5]:setColSpan(3):createText(currentordertext, { halign = "center" })
					if menu.getFilterOption("infocenter_shieldhull") then
						row[8]:setColSpan(5):createText(currentactiontext, { halign = "center" })
						row[13]:createObjectShieldHullBar(component, { height = config.mapRowHeight / 2 })
					else
						row[8]:setColSpan(6):createText(currentactiontext, { halign = "center" })
					end
				end
				-- End Commander

				if subordinates.hasRendered then
					numdisplayed = ic_menu.createSubordinateSection(instance, ftable, component, iteration, location or commanderlocation, numdisplayed)
				end
			end
			-- dockedships
			if #dockedships > 0 then
				if (not menu.isDockedShipsExtended(tostring(component))) and menu.isDockContext(convertedComponent) then
					menu.extendeddockedships[tostring(component)] = true
				end

				local isdockedshipsextended = menu.isDockedShipsExtended(tostring(component))
				local row = ftable:addRow({"dockedships", component}, { bgColor = Helper.color.transparent })
				row[1]:createButton():setText(isdockedshipsextended and "-" or "+", { halign = "center" })
				row[1].handlers.onClick = function () return menu.buttonExtendDockedShips(tostring(component)) end
				local text = ReadText(1001, 3265)
				for i = 1, iteration + 1 do
					text = "    " .. text
				end
				row[2]:setColSpan(3):createText(text)
				if IsSameComponent(component, menu.highlightedbordercomponent) and (menu.highlightedborderstationcategory == "dockedships") then
					menu.sethighlightborderrow = row.index
				end
				if isdockedshipsextended then
					for _, dockedship in ipairs(dockedships) do
						numdisplayed = ic_menu.createInfoCenterRow(instance, ftable, dockedship, iteration + 2, location or commanderlocation, numdisplayed)
					end
				end
			end
		end
	end

	return numdisplayed
end

function ic_menu.createInfoCenterSection(instance, id, ftable, name, array, nonetext, numdisplayed)
	local maxicons = 5

	local row = ftable:addRow(false)
	row[1]:setColSpan(8 + maxicons):createText(name, Helper.headerRowCenteredProperties)

	if id == menu.highlightedbordersection then
		menu.sethighlightborderrow = row.index + 1
	end

	if #array > 0 then
		for _, component in ipairs(array) do
			numdisplayed = ic_menu.createInfoCenterRow(instance, ftable, component, 0, nil, numdisplayed)
		end
	else
		row = ftable:addRow(id, { bgColor = Helper.color.transparent })
		row[1]:setColSpan(8 + maxicons):createText(nonetext, { halign = center})
	end

	return numdisplayed
end

function ic_menu.isTableEmpty()
	return not menu.getFilterOption("infocenter_stations") and
		not menu.getFilterOption("infocenter_wings") and
		not menu.getFilterOption("infocenter_ships")
end

function ic_menu.createConstructionRow(ftable, component, construction, iteration)
    local name = ReadText(20109, 5101)
    if construction.component ~= 0 then
        name = ffi.string(C.GetComponentName(construction.component))
    elseif construction.macro ~= "" then
        name = GetMacroData(construction.macro, "name")
        if construction.amount then
            name = construction.amount .. ReadText(1001, 42) .. " " .. name
        end
    end
    for i = 1, iteration do
        name = "    " .. name
    end
    local color = (construction.factionid == "player") and menu.holomapcolor.playercolor or Helper.color.white
    local bgcolor = Helper.color.transparent
    if menu.mode == "orderparam_object" then
        bgcolor = menu.darkgrey
    end

    local row = ftable:addRow({ "construction", component, construction }, { bgColor = bgcolor, multiSelected = menu.isSelectedComponent(construction.component) })
    if menu.highlightedconstruction and (construction.id == menu.highlightedconstruction.id) then
        menu.sethighlightborderrow = row.index
    end
    if (construction.component ~= 0) and IsSameComponent(ConvertStringTo64Bit(tostring(construction.component)), menu.highlightedbordercomponent) then
        menu.sethighlightborderrow = row.index
    end

    if construction.inprogress then
        row[1]:setColSpan(4):createText(function () return menu.getShipBuildProgress(construction.component, name .. " (" .. ffi.string(C.GetObjectIDCode(construction.component)) .. ")") end, { color = color, mouseOverText = construction.ismissingresources and ReadText(1026, 3223) or "" })
        row[5]:setColSpan(9):createText(function () return (construction.ismissingresources and "\27Y\27[warning] " or "") .. Helper.formatTimeLeft(C.GetBuildProcessorEstimatedTimeLeft(construction.buildercomponent)) end, { halign = "right", color = color, mouseOverText = construction.ismissingresources and ReadText(1025, 3223) or "" })
    else
        local duration = C.GetBuildTaskDuration(construction.buildingcontainer, construction.id)
        row[1]:setColSpan(4):createText(name, { color = color })
        if construction.amount then
            row[5]:setColSpan(9):createText(string.format(ReadText(1001, 11608), Helper.formatTimeLeft(duration)), { halign = "right", color = color })
        else
            row[5]:setColSpan(9):createText("#" .. construction.queueposition .. " - " .. Helper.formatTimeLeft(duration), { halign = "right", color = color })
        end
    end
end

function ic_menu.createConstructionSection(instance, id, ftable, name, constructions)
    if #constructions > 0 then
        local row = ftable:addRow(false)
        row[1]:setColSpan(13):createText(name, Helper.headerRowCenteredProperties)

        if id == menu.highlightedbordersection then
            menu.sethighlightborderrow = row.index + 1
        end

        for i, construction in ipairs(constructions) do
            if construction.empty then
                ftable:addEmptyRow(config.mapRowHeight / 2)
            else
                local component = ConvertStringTo64Bit(tostring(construction.buildingcontainer))
                ic_menu.createConstructionRow(ftable, component, construction, 1)
            end
        end
    end
end

function ic_menu.createInfoCenter(frame, instance)
	local infoTableData = menu.infoTableData[instance]
	local maxicons = 5
	local infoTableHeight = Helper.viewHeight - menu.infoTableOffsetY - menu.borderOffset

	local infoTableWidth = menu.infoTableWidth * 2.3

	if infoTableWidth > 1611 then
		infoTableWidth = 1611
	end

	if Helper.viewWidth == 3840 then
		infoTableWidth = 2500
	end

	menu.infoFrame = Helper.createFrameHandle(menu, {
		x = menu.infoTableOffsetX,
		y = menu.infoTableOffsetY,
		width = infoTableWidth,
		height = infoTableHeight,
		layer = config.infoFrameLayer,
		backgroundID = "solid",
		backgroundColor = Helper.color.black,
		standardButtons = {},
		showBrackets = false,
		autoFrameHeight = true
	})

	local ftable = menu.infoFrame:addTable(8 + maxicons, { tabOrder = 1, multiSelect = true })
	ftable:setDefaultCellProperties("text", { minRowHeight = config.mapRowHeight, fontsize = config.mapFontSize })
	ftable:setDefaultCellProperties("button", { height = config.mapRowHeight })
	ftable:setDefaultComplexCellProperties("button", "text", { fontsize = config.mapFontSize })

	if ic_menu.isTableEmpty() then
		local row = ftable:addRow(false, {bgColor = Helper.color.defaultSimpleBackgroundColor })
		row[1]:setColSpan(13):createText(ReadText(9814072, 1), { halign = "center" })
		return
	end

	infoTableData.stations = {}
	infoTableData.fleetLeaderShips = {}
	infoTableData.unassignedShips = {}
	infoTableData.constructionShips = {}
	infoTableData.inventoryShips = {}
	infoTableData.deployables = {}
	infoTableData.subordinates = {}
	infoTableData.dockedships = {}
	infoTableData.constructions = {}
	infoTableData.moduledata = {}

	ftable:setColWidth(1, 30)
	ftable:setColWidth(2, 300)
	ftable:setColWidth(9, 26)
	ftable:setColWidth(10, 26)
	ftable:setColWidth(11, 26)
	ftable:setColWidth(12, 26)
	ftable:setColWidth(13, 26)

    local playerobjects = {}
    if Helper.isPlayerCovered() and (not C.IsUICoverOverridden()) then
        playerobjects[1] = ConvertStringTo64Bit(tostring(C.GetPlayerOccupiedShipID()))
    else
        playerobjects = GetContainedObjectsByOwner("player")
    end

    local simpleViewShips = {}

    for i = #playerobjects, 1, -1 do
        local object = playerobjects[i]
        local object64 = ConvertIDTo64Bit(object)
        if menu.isObjectValid(object64) then
            local hull, purpose, uirelation = GetComponentData(object, "hullpercent", "primarypurpose", "uirelation")
            playerobjects[i] = { id = object, name = ffi.string(C.GetComponentName(object64)), fleetname = menu.getFleetName(object64), objectid = ffi.string(C.GetObjectIDCode(object64)), class = ffi.string(C.GetComponentClass(object64)), hull = hull, purpose = purpose, relation = uirelation, sector = GetComponentData(object, "sector"), order = ic_menu.getOrderInfoText(object64) }
        else
            table.remove(playerobjects, i)
        end
    end

    table.sort(playerobjects, ic_menu.componentSorter(ic_menu.propertySorterType))

    local playerShipsOnly = {}

    if ic_menu.showSimpleView then
        for _, entry in ipairs(playerobjects) do
            local object = entry.id
            local object64 = ConvertIDTo64Bit(object)
            if menu.isObjectValid(object64) then
                if C.IsRealComponentClass(object64, "ship") then
                    table.insert(playerShipsOnly, object)
                end
            end
        end
    else
        for _, entry in ipairs(playerobjects) do
            local object = entry.id
            local object64 = ConvertIDTo64Bit(object)
            if menu.isObjectValid(object64) then
                -- Determine subordinates that may appear in the menu
                local subordinates = {}
                if C.IsComponentClass(object64, "controllable") then
                    subordinates = GetSubordinates(object)
                end
                for i = #subordinates, 1, -1 do
                    local subordinate = subordinates[i]
                    if not menu.isObjectValid(ConvertIDTo64Bit(subordinate)) then
                        table.remove(subordinates, i)
                    end
                end
                subordinates.hasRendered = #subordinates > 0
                infoTableData.subordinates[tostring(object)] = subordinates
                -- Find docked ships
                local dockedships = {}
                if C.IsComponentClass(object64, "container") then
                    Helper.ffiVLA(dockedships, "UniverseID", C.GetNumDockedShips, C.GetDockedShips, object64, nil)
                end
                for i = #dockedships, 1, -1 do
                    local convertedID = ConvertStringToLuaID(tostring(dockedships[i]))
                    local loccommander = GetCommander(convertedID)
                    -- if (not loccommander) or (not menu.renderedComponentsRef[ConvertIDTo64Bit(loccommander)]) then
                    if not loccommander then
                        dockedships[i] = convertedID
                    else
                        table.remove(dockedships, i)
                    end
                end
                infoTableData.dockedships[tostring(object)] = dockedships

                local commander
                if C.IsComponentClass(object64, "controllable") then
                    commander = GetCommander(object)
                end
                if not commander then
                    if C.IsRealComponentClass(object64, "station") then
                        table.insert(infoTableData.stations, object)
                    elseif #subordinates > 0 then
                        table.insert(infoTableData.fleetLeaderShips, object)
                    else
                        table.insert(infoTableData.unassignedShips, object)
                    end
                end
            end
        end
    end

    if menu.getFilterOption("infocenter_sorterrow") then
        local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
        row[1]:setColSpan(4):createText(ReadText(1001, 2906) .. ReadText(1001, 120), { halign = "right" })

        local buttonheight = Helper.scaleY(config.mapRowHeight)
        
        local button = row[5]:setColSpan(1):createButton({ scaling = false, height = buttonheight }):setText(ReadText(1001, 8026), { halign = "center", scaling = true })
        if ic_menu.propertySorterType == "class" then
            button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
        elseif ic_menu.propertySorterType == "classinverse" then
            button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
        end
        row[5].handlers.onClick = function () return ic_menu.buttonPropertySorter("class") end

        button = row[6]:setColSpan(1):createButton({ scaling = false, height = buttonheight }):setText(ReadText(1001, 2809), { halign = "center", scaling = true })
        if ic_menu.propertySorterType == "name" then
            button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
        elseif ic_menu.propertySorterType == "nameinverse" then
            button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
        end
        row[6].handlers.onClick = function () return ic_menu.buttonPropertySorter("name") end

        button = row[7]:setColSpan(1):createButton({ scaling = false, height = buttonheight }):setText(ReadText(1001, 1), { halign = "center", scaling = true })
        if ic_menu.propertySorterType == "hull" then
            button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
        elseif ic_menu.propertySorterType == "hullinverse" then
            button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
        end
        row[7].handlers.onClick = function () return ic_menu.buttonPropertySorter("hull") end

        button = row[8]:setColSpan(1):createButton({ scaling = false, height = buttonheight }):setText(ReadText(9814072, 104), { halign = "center", scaling = true })
        if ic_menu.propertySorterType == "sector" then
            button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
        elseif ic_menu.propertySorterType == "sectorinverse" then
            button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
        end
        row[8].handlers.onClick = function () return ic_menu.buttonPropertySorter("sector") end
        
        button = row[9]:setColSpan(5):createButton({ scaling = false, height = buttonheight }):setText(ReadText(9814072, 105), { halign = "center", scaling = true })
        if ic_menu.propertySorterType == "order" then
            button:setIcon("table_arrow_inv_down", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
        elseif ic_menu.propertySorterType == "orderinverse" then
            button:setIcon("table_arrow_inv_up", { width = buttonheight, height = buttonheight, x = button:getColSpanWidth() - buttonheight })
        end
        row[9].handlers.onClick = function () return ic_menu.buttonPropertySorter("order") end
    end

    if menu.getFilterOption("infocenter_showSimpleViewOptions") then
        local row = ftable:addRow(true, { fixed = true, bgColor = Helper.color.transparent })
        row[1]:setColSpan(5):createText(ReadText(9814072, 106) .. ReadText(1001, 120), { halign = "right" })

        local buttonheight = Helper.scaleY(config.mapRowHeight)
        
        local button = row[6]:setColSpan(2):createButton({ scaling = false, height = buttonheight })
        if not ic_menu.showSimpleView then
            button:setText(ReadText(9814072, 107), { halign = "center", scaling = true })
        elseif ic_menu.showSimpleView then
            button:setText(ReadText(9814072, 108), { halign = "center", scaling = true })
        end
        row[6].handlers.onClick = function () return ic_menu.buttonToggleSimpleView() end
        
        if not ic_menu.showSimpleView then
            button = row[8]:setColSpan(6):createButton({active = false, scaling = false, height = buttonheight })
        else
            button = row[8]:setColSpan(6):createButton({active = true, scaling = false, height = buttonheight })
        end
        if not ic_menu.onlyDamagedShips then
            button:setText(ReadText(9814072, 109), { halign = "center", scaling = true })
        elseif ic_menu.onlyDamagedShips then
            button:setText(ReadText(9814072, 110), { halign = "center", scaling = true })
        end
           row[8].handlers.onClick = function () return ic_menu.buttonToggleOnlyDamagedShips() end
    end
    local constructionshipsbymacro = {}
    local n = C.GetNumPlayerShipBuildTasks(true, false)
    local buf = ffi.new("BuildTaskInfo[?]", n)
    n = C.GetPlayerShipBuildTasks(buf, n, true, false)
    for i = 0, n - 1 do
        local factionid = ffi.string(buf[i].factionid)
        if factionid == "player" then
            table.insert(infoTableData.constructionShips, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = buf[i].component, macro = ffi.string(buf[i].macro), factionid = factionid, buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = true })
        end
    end
    if #infoTableData.constructionShips > 0 then
        table.insert(infoTableData.constructionShips, { empty = true })
    end
    local n = C.GetNumPlayerShipBuildTasks(false, false)
    local buf = ffi.new("BuildTaskInfo[?]", n)
    n = C.GetPlayerShipBuildTasks(buf, n, false, false)
    for i = 0, n - 1 do
        local factionid = ffi.string(buf[i].factionid)
        if factionid == "player" then
            local component = buf[i].component
            local macro = ffi.string(buf[i].macro)
            if (component == 0) and (macro ~= "") then
                if constructionshipsbymacro[macro] then
                    infoTableData.constructionShips[constructionshipsbymacro[macro]].amount = infoTableData.constructionShips[constructionshipsbymacro[macro]].amount + 1
                else
                    table.insert(infoTableData.constructionShips, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = component, macro = macro, factionid = factionid, buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = false, amount = 1 })
                    constructionshipsbymacro[macro] = #infoTableData.constructionShips
                end
            else
                table.insert(infoTableData.constructionShips, { id = buf[i].id, buildingcontainer = buf[i].buildingcontainer, component = component, macro = macro, factionid = factionid, buildercomponent = buf[i].buildercomponent, price = buf[i].price, ismissingresources = buf[i].ismissingresources, queueposition = buf[i].queueposition, inprogress = false })
            end
        end
    end

	local numdisplayed = 0
	local maxvisibleheight = ftable:getFullHeight()

    if ic_menu.showSimpleView then
        numdisplayed = ic_menu.createInfoCenterSection(instance, "ownedships", ftable, ReadText(1001, 8327), playerShipsOnly, "-- " .. ReadText(1001, 34) .. " --", numdisplayed) -- {1001,8327} = Unassigned Ships
    else
        if menu.mode ~= "selectCV" and menu.getFilterOption("infocenter_stations") then
            numdisplayed = ic_menu.createInfoCenterSection(instance, "ownedstations", ftable, ReadText(1001, 4), infoTableData.stations, "-- " .. ReadText(1001, 33) .. " --", numdisplayed)
        end
        if menu.getFilterOption("infocenter_wings") then
            numdisplayed = ic_menu.createInfoCenterSection(instance, "ownedfleets", ftable, ReadText(1001, 8326), infoTableData.fleetLeaderShips, "-- " .. ReadText(1001, 34) .. " --", numdisplayed) -- {1001,8326} = Fleets
        end
        if menu.getFilterOption("infocenter_ships") then
            numdisplayed = ic_menu.createInfoCenterSection(instance, "ownedships", ftable, ReadText(1001, 8327), infoTableData.unassignedShips, "-- " .. ReadText(1001, 34) .. " --", numdisplayed) -- {1001,8327} = Unassigned Ships
            ic_menu.createConstructionSection(instance, "constructionships", ftable, ReadText(1001, 8328), infoTableData.constructionShips)
        end
    end

	if numdisplayed > 50 then
		ftable.properties.maxVisibleHeight = maxvisibleheight + 50 * (Helper.scaleY(config.mapRowHeight) + Helper.borderSize)
	end

	menu.numFixedRows = ftable.numfixedrows

	ftable:setTopRow(menu.settoprow)
	if menu.infoTable then
		local result = GetShiftStartEndRow(menu.infoTable)
		if result then
			ftable:setShiftStartEnd(table.unpack(result))
		end
	end
	ftable:setSelectedRow(menu.sethighlightborderrow or menu.setrow)
	menu.setrow = nil
	menu.settoprow = nil
	menu.setcol = nil
	menu.sethighlightborderrow = nil

end

function ic_menu.onTableRightMouseClick(uitable, row, posx, posy)
	if (menu.mode == "orderparam_position") then
		menu.resetOrderParamMode()
	else
		if row > (menu.numFixedRows or 0) then
			local rowdata = menu.rowDataMap[uitable] and menu.rowDataMap[uitable][row]
			if menu.infoTableMode == "infocenter" then
				if uitable == menu.infoTable then
					if type(rowdata) == "table" then
						local convertedRowComponent = ConvertIDTo64Bit(rowdata[2])
						if convertedRowComponent and (convertedRowComponent ~= 0) then
							local x, y = GetLocalMousePosition()
							if menu.mode == "hire" then
								if GetComponentData(convertedRowComponent, "isplayerowned") and C.IsComponentClass(convertedRowComponent, "controllable") then
									menu.contextMenuData = { component = convertedRowComponent, xoffset = x + Helper.viewWidth / 2, yoffset = Helper.viewHeight / 2 - y }
									menu.contextMenuMode = "select"
									menu.createContextFrame(menu.selectWidth)
								end
							elseif menu.mode == "selectCV" then
								menu.contextMenuData = { component = convertedRowComponent, xoffset = x + Helper.viewWidth / 2, yoffset = Helper.viewHeight / 2 - y }
								menu.contextMenuMode = "select"
								menu.createContextFrame(menu.selectWidth)
							elseif menu.mode == "orderparam_object" then
								if menu.checkForOrderParamObject(convertedRowComponent) then
									menu.contextMenuData = { component = convertedRowComponent, xoffset = x + Helper.viewWidth / 2, yoffset = Helper.viewHeight / 2 - y }
									menu.contextMenuMode = "select"
									menu.createContextFrame(menu.selectWidth)
								end
							elseif menu.mode == "selectComponent" then
								if menu.checkForSelectComponent(convertedRowComponent) then
									menu.contextMenuData = { component = convertedRowComponent, xoffset = x + Helper.viewWidth / 2, yoffset = Helper.viewHeight / 2 - y }
									menu.contextMenuMode = "select"
									menu.createContextFrame(menu.selectWidth)
								end
							else
								local missions = {}
								Helper.ffiVLA(missions, "MissionID", C.GetNumMapComponentMissions, C.GetMapComponentMissions, menu.holomap, convertedRowComponent)
								
								local playerships, otherobjects, playerdeployables = menu.getSelectedComponentCategories()
								if rowdata[1] == "construction" then
									menu.interactMenuComponent = convertedRowComponent
									Helper.openInteractMenu(menu, { component = convertedRowComponent, playerships = playerships, otherobjects = otherobjects, playerdeployables = playerdeployables, mouseX = posx, mouseY = posy, construction = rowdata[3], componentmissions = missions })
								elseif string.find(rowdata[1], "subordinates") then
									menu.interactMenuComponent = convertedRowComponent
									Helper.openInteractMenu(menu, { component = convertedRowComponent, playerships = playerships, otherobjects = otherobjects, playerdeployables = playerdeployables, mouseX = posx, mouseY = posy, subordinategroup = rowdata[3], componentmissions = missions })
								else
									menu.interactMenuComponent = convertedRowComponent
									Helper.openInteractMenu(menu, { component = convertedRowComponent, playerships = playerships, otherobjects = otherobjects, playerdeployables = playerdeployables, mouseX = posx, mouseY = posy, componentmissions = missions })
								end
							end
						end
					end
				end
			end
		end
	end
end

function ic_menu.onSelectElement(uitable, modified, row, isdblclick, input)
	local rowdata = Helper.getCurrentRowData(menu, uitable)
	if menu.infoTableMode == "infocenter" then
		if uitable == menu.infoTable then
			if type(rowdata) == "table" then
				local convertedRowComponent = ConvertIDTo64Bit(rowdata[2])
				menu.setSelectedMapComponents()

				if convertedRowComponent and (convertedRowComponent ~= 0) then
					local isonlineobject, isplayerowned = GetComponentData(rowdata[2], "isonlineobject", "isplayerowned")
					if (isdblclick or (input ~= "mouse")) and (ffi.string(C.GetComponentClass(convertedRowComponent)) ~= "sector") then
						if string.find(rowdata[1], "subordinates") then
							local subordinates = menu.infoTableData.left.subordinates[tostring(rowdata[2])] or {}
							local groups = {}
							for _, subordinate in ipairs(subordinates) do
								local group = GetComponentData(subordinate, "subordinategroup")
								if group and group > 0 then
									if groups[group] then
										table.insert(groups[group].subordinates, subordinate)
									else
										groups[group] = { assignment = ffi.string(C.GetSubordinateGroupAssignment(convertedRowComponent, group)), subordinates = { subordinate } }
									end
								end
							end

							if groups[rowdata[3]] then
								C.SetFocusMapComponent(menu.holomap, ConvertIDTo64Bit(groups[rowdata[3]].subordinates[1]), true)
								menu.addSelectedComponents(groups[rowdata[3]].subordinates, modified ~= "shift")
							end
						elseif isplayerowned and isonlineobject then
							local assigneddock = ConvertIDTo64Bit(GetComponentData(convertedRowComponent, "assigneddock"))
							if assigneddock then
								local container = C.GetContextByClass(assigneddock, "container", false)
								if container then
									C.SetFocusMapComponent(menu.holomap, container, true)
								end
							end
						else
							C.SetFocusMapComponent(menu.holomap, convertedRowComponent, true)
						end
					end
				end
			end
		end
	end
end

function ic_menu.onRowChanged(row, rowdata, uitable, modified, input, source)
    if menu.infoTableMode == "infocenter" then
        if uitable == menu.infoTable then
            if type(rowdata) == "table" then
                local convertedComponent = ConvertIDTo64Bit(rowdata[2])
                if (source ~= "auto") and convertedComponent then
                    local convertedcomponentclass = ffi.string(C.GetComponentClass(convertedComponent))
                    if convertedcomponentclass  == "station" then
                        AddUITriggeredEvent(menu.name, "selection_station", convertedComponent)
                    end
                    if (convertedcomponentclass  == "ship_s") or (convertedcomponentclass  == "ship_m") or (convertedcomponentclass  == "ship_l") or (convertedcomponentclass  == "ship_xl") then
                        AddUITriggeredEvent(menu.name, "selection_ship", convertedComponent)
                    end
                    if (convertedcomponentclass == "resourceprobe") then
                        AddUITriggeredEvent(menu.name, "selection_resourceprobe", convertedComponent)
                    end

                    if (menu.mode ~= "orderparam_object") and (input ~= "rightmouse") then
                        menu.infoSubmenuObject = convertedComponent
                        if menu.infoTableMode == "info" then
                            menu.refreshInfoFrame(nil, 0)
                        elseif menu.searchTableMode == "info" then
                            menu.refreshInfoFrame2(nil, 0)
                        end
                    end
                end
                menu.updateSelectedComponents(modified, source == "auto", convertedComponent, row)
                menu.setSelectedMapComponents()
            end
        end
    end
end

function ic_menu.buttonPropertySorter(sorttype)
    if ic_menu.propertySorterType == sorttype then
        ic_menu.propertySorterType = sorttype .. "inverse"
    else
        ic_menu.propertySorterType = sorttype
    end
    menu.refreshInfoFrame()
end

function ic_menu.buttonToggleSimpleView()
    ic_menu.showSimpleView = not ic_menu.showSimpleView
    menu.refreshInfoFrame()
end

function ic_menu.buttonToggleOnlyDamagedShips()
    if ic_menu.showSimpleView then
        ic_menu.onlyDamagedShips = not ic_menu.onlyDamagedShips
        menu.refreshInfoFrame()
    end
end

function ic_menu.sortSectorAndName(a, b, invert)
    if a.sector == b.sector then
        return Helper.sortName(a, b)
    end
    if invert then
        return a.sector > b.sector
    else
        return a.sector < b.sector
    end
end

function ic_menu.sortOrderAndName(a, b, invert)
    if a.order == b.order then
        return Helper.sortName(a, b)
    end
    if invert then
        return a.order > b.order
    else
        return a.order < b.order
    end
end

function ic_menu.componentSorter(sorttype)
    local sorter = Helper.sortNameAndObjectID
    if sorttype == "nameinverse" then
        sorter = function (a, b) return Helper.sortNameAndObjectID(a, b, true) end
    elseif sorttype == "class" then
        sorter = Helper.sortShipsByClassAndPurpose
    elseif sorttype == "classinverse" then
        sorter = function (a, b) return Helper.sortShipsByClassAndPurpose(a, b, true) end
    elseif sorttype == "hull" then
        sorter = Helper.sortHullAndName
    elseif sorttype == "hullinverse" then
        sorter = function (a, b) return Helper.sortHullAndName(a, b, true) end
    elseif sorttype == "relation" then
        sorter = Helper.sortRelationAndName
    elseif sorttype == "relationinverse" then
        sorter = function (a, b) return Helper.sortRelationAndName(a, b, true) end
    elseif sorttype == "sector" then
        sorter = ic_menu.sortSectorAndName
    elseif sorttype == "sectorinverse" then
        sorter = function (a, b) return ic_menu.sortSectorAndName(a, b, true) end
    elseif sorttype == "order" then
        sorter = ic_menu.sortOrderAndName
    elseif sorttype == "orderinverse" then
        sorter = function (a, b) return ic_menu.sortOrderAndName(a, b, true) end
    end
    return sorter
end

init()
