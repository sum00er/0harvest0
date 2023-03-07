local cd, canCarry, getItem, giveItem, removeItem = {}

if Config.oldESX then
    ESX = exports["es_extended"]:getSharedObject()
end

--compatability of different inventory system
if Config.oxinv then
    canCarry = function(source, item, count)
        return exports.ox_inventory:CanCarryItem(source, item, count)
    end

    getItem = function(source, name)
        return exports.ox_inventory:GetItem(source, name, nil, false)
    end

    giveItem = function(source, name, count)
        return exports.ox_inventory:AddItem(source, name, count)
    end

    removeItem = function(source, name, count)
        return exports.ox_inventory:RemoveItem(source, name, count)
    end
    
else
    if Config.weight then
        canCarry = function(source, item, count)
            local xPlayer = ESX.GetPlayerFromId(source)
            return xPlayer.canCarryItem(item, count)
        end
    else
        canCarry = function(source, item, count)
            local xPlayer = ESX.GetPlayerFromId(source)
            local xItem = xPlayer.getInventoryItem(name)
            return xItem.count + count <= xItem.limit
        end
    end

    getItem = function(source, name)
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getInventoryItem(name)
    end

    giveItem = function(source, name, count)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addInventoryItem(name, count)
    end

    removeItem = function(source, name, count)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem(name, count)
    end
end

ESX.RegisterServerCallback('0harvest0:harvestItem', function(source, cb, id)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = Config.Harvest[id]
    local coords = xPlayer.getCoords(true)
    if cd[source] or #(coords - data.coords) > ((Config.Marker.x / 2) + Config.Safezone) then --make sure action is valid
        local reason = _U('far_reason_log')
        if cd[source] then
            reason = _U('repeat_reason_log')
        end
        toDiscord(source, _U('suspect_log', reason))
        cb(false)
        return
    end
    cd[source] = true
    local invalid1
    for k, v in pairs(data.product) do
        local canCarry = canCarry(source, v.name, v.count)
        if not canCarry then
            local xItem = getItem(source, v.name)
            invalid1 = xItem.label
            break
        end
    end
    if not invalid1 then
        if data.material then
            local invalid2
            for k, v in pairs(data.material) do
                local xItem = getItem(source, v.name)
                if xItem.count < v.count then
                    invalid2 = xItem.label
                    break
                end
            end
            if not invalid2 then
                for k, v in pairs(data.material) do
                    removeItem(source, v.name, v.count)
                end
            else
                cb(false)
                TriggerClientEvent('esx:showNotification', source, _U('no_material', invalid2))
                Citizen.Wait((data.time * 1000) - 500)
                cd[source] = false
                return
            end
        end
        local chance = math.random(0, 100)
        for k, v in pairs(data.product) do
            if chance >= v.chance.x and chance <= v.chance.y then
                giveItem(source, v.name, v.count)
                toDiscord(source, _U('getitem_log', v.name, v.count))
            end
        end
        cb(true)
    else
        cb(false)
        TriggerClientEvent('esx:showNotification', source, _U('cannot_carry', invalid1))
    end
    Citizen.Wait((data.time * 1000) - 500)
    cd[source] = false
end)

function toDiscord(source, message)
    local identifiers, id = GetPlayerIdentifiers(source)
    if FetchDiscord(identifiers) ~= nil then
        id = '<@' ..FetchDiscord(identifiers).. '> \n'..table.concat(identifiers, '\n')
    else
        id = table.concat(identifiers, '\n')
    end
    local connect = {
        {
            ["color"] = 3066993,
            ["title"] = message,
            ["description"] = id,
            ["footer"] = {
                ["text"] = os.date("%x %X %p"),
            },
        }
    }
    PerformHttpRequest(Config.Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = "server-log", embeds = connect}), {['Content-Type'] = 'application/json'})
end

function FetchDiscord(identifiers)
    for _, v in pairs(identifiers) do
        if string.find(v, 'discord:') then
            return v:sub(9)
        end
    end
end