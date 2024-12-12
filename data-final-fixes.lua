local replace_list = require("replace_list")
local utils = require("utils")

--prototypes without sounds (they don't support them even in theory), so we save time by not checking them
local blacklist_categories = {
    ["font"] = true,
    ["gui-style"] = true,
    ["utility-constants"] = true,
    ["sprite"] = true,
    ["utility-sprites"] = true,
    ["editor-controller"] = true,
    ["god-controller"] = true,
    ["spectator-controller"] = true,
    ["remote-controller"] = true,
    ["noise-function"] = true,
    ["noise-expression"] = true,
    ["mouse-cursor"] = true,
    ["virtual-signal"] = true,
    ["recipe"] = true,
    ["quality"] = true,
    ["fluid"] = true,
    ["space-location"] = true,
    ["asteroid-chunk"] = true,
    ["recipe-category"] = true,
    ["burner-usage"] = true,
    ["damage-type"] = true,
    ["collision-layer"] = true,
    ["optimized-particle"] = true,
    ["delayed-active-trigger"] = true,
    ["custom-input"] = true,
    ["legacy-straight-rail"] = true,
    ["legacy-curved-rail"] = true,
    ["trivial-smoke"] = true,
    ["item-group"] = true,
    ["item-subgroup"] = true,
    ["autoplace-control"] = true,
    ["map-settings"] = true,
    ["map-gen-presets"] = true,
    ["tile-effect"] = true,
    ["ammo-category"] = true,
    ["fuel-category"] = true,
    ["resource-category"] = true,
    ["module-category"] = true,
    ["equipment-grid"] = true,
    ["equipment-category"] = true,
    ["shortcut"] = true,
    ["trigger-target-type"] = true,
    ["technology"] = true,
    ["tips-and-tricks-item-category"] = true,
    ["tips-and-tricks-item"] = true,
    ["build-entity-achievement"] = true,
    ["research-achievement"] = true,
    ["use-entity-in-energy-production-achievement"] = true,
    ["produce-achievement"] = true,
    ["complete-objective-achievement"] = true,
    ["group-attack-achievement"] = true,
    ["construct-with-robots-achievement"] = true,
    ["deconstruct-with-robots-achievement"] = true,
    ["deliver-by-robots-achievement"] = true,
    ["train-path-achievement"] = true,
    ["player-damaged-achievement"] = true,
    ["deplete-resource-achievement"] = true,
    ["produce-per-hour-achievement"] = true,
    ["dont-use-entity-in-energy-production-achievement"] = true,
    ["research-with-science-pack-achievement"] = true,
    ["kill-achievement"] = true,
    ["destroy-cliff-achievement"] = true,
    ["shoot-achievement"] = true,
    ["combat-robot-count-achievement"] = true,
    ["dont-kill-manually-achievement"] = true,
    ["dont-craft-manually-achievement"] = true,
    ["dont-build-entity-achievement"] = true,
    ["achievement"] = true,
    ["airborne-pollutant"] = true,
    ["tutorial"] = true,
    ["energy-shield-equipment"] = true,
    ["battery-equipment"] = true,
    ["solar-panel-equipment"] = true,
    ["generator-equipment"] = true,
    ["active-defense-equipment"] = true,
    ["movement-bonus-equipment"] = true,
    ["roboport-equipment"] = true,
    ["belt-immunity-equipment"] = true,
    ["equipment-ghost"] = true,
    ["surface-property"] = true,
    ["procession-layer-inheritance-group"] = true,
    ["procession"] = true,
    ["impact-category"] = true,
    ["deliver-category"] = true,
    ["chain-active-trigger"] = true,
    ["create-platform-achievement"] = true,
    ["change-surface-achievement"] = true,
    ["space-connection-distance-traveled-achievement"] = true,
    ["dont-research-before-researching-achievement"] = true,
    ["module-transfer-achievement"] = true,
    ["equip-armor-achievement"] = true,
    ["use-item-achievement"] = true,
    ["place-equipment-achievement"] = true,
    ["inventory-bonus-equipment"] = true,
    ["space-connection"] = true,
    ["surface"] = true,
--except for the speaker, it already picks up all the sounds from the soundpad, no need to check it
    ["programmable-speaker"] = true,
}
--the search will only be on the last 3 letters, so leave only the last 3 letters in the dictionary below
local whitelist_file_suffixes = {
    ["ogg"] = true,
}

dbgLog = log

local function tree_search(search_keys, pos, base_table)
    pos = pos or 1
    base_table = base_table or replace_list
    local skey = search_keys[pos]
    if skey then
        local replace_list_record = base_table[skey]
        if type(replace_list_record) == "table" and not replace_list_record.end_of_search then
            return tree_search(search_keys, pos+1, replace_list_record), skey
        elseif type(replace_list_record) == "string" then
            return replace_list_record, skey
        elseif base_table.allow_regex then
            for key, value in pairs(base_table) do
                if string.find(skey, key) then
                    return value
                end
            end
        else
            return
        end
    else
        return
    end
end

local function depth_replace(tabl, stack_path)
    for key, value in pairs(tabl) do
        if type(value) == "table" then
            depth_replace(value, stack_path.."."..key)
        elseif type(value) == "string" then
            if whitelist_file_suffixes[string.sub(value, -3)] then
                --dbgLog("----found str `"..value.."` at "..stack_path)
                local params, search_key = tree_search(utils.split(value))
                if params then
                    dbgLog("----found str `"..value.."` at `"..stack_path.."` with replace params "..params)
                    tabl[key] = "__Half-Life-Sound-Pack-speacker__/soundpack/"..params
                end
            end
        end
    end
end

for catg_name, catg in pairs(data.raw) do
    if not blacklist_categories[catg_name] then
        --dbgLog("cat: "..catg_name)
        for proto_name, proto in pairs(catg) do
            --dbgLog("--proto: "..proto_name)
            depth_replace(proto, catg_name.."."..proto_name)
        end
    end
end