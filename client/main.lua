local Blips, busy, harvest = {}, false, false
print("^20harvest0 by sum00er. https://discord.gg/pjuPHPrHnx")
if Config.oldESX then
    ESX = exports["es_extended"]:getSharedObject()

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        ESX.PlayerData = xPlayer
        PlayerLoaded = true
    end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    for k, v in pairs(Blips) do
        RemoveBlip(v)
    end
    Blips = {}
    ESX.PlayerData.job = job
    for k, v in pairs(Config.Harvest) do
        if (not v.job or v.job == job.name) and v.blip then
            local blip = AddBlipForCoord(v.coords)

            SetBlipSprite (blip, v.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, 0.9)
            SetBlipColour (blip, v.blip.color)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.label)
            EndTextCommandSetBlipName(blip)
            table.insert(Blips, blip)
        end
    end
end)

Citizen.CreateThread(function()
    while not ESX.PlayerData do Citizen.Wait(100) end
    while not ESX.PlayerData.job do Citizen.Wait(100) end
    for k, v in pairs(Config.Harvest) do
        if (not v.job or v.job == ESX.PlayerData.job.name) and v.blip then
            local blip = AddBlipForCoord(v.coords)

            SetBlipSprite (blip, v.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, 0.9)
            SetBlipColour (blip, v.blip.color)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.blip.label)
            EndTextCommandSetBlipName(blip)
            table.insert(Blips, blip)
        end
    end
end)

Citizen.CreateThread(function()
    while not ESX.PlayerData do Citizen.Wait(100) end
    while not ESX.PlayerData.job do Citizen.Wait(100) end
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for k, v in pairs(Config.Harvest) do
            if not v.job or v.job == ESX.PlayerData.job.name then
                local dist = Vdist(v.coords, coords)
                if dist < Config.DrawDistance then
                    sleep = 0
                    DrawMarker(Config.Marker.type, v.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.Marker.x, Config.Marker.y, Config.Marker.z, Config.Marker.r, Config.Marker.g, Config.Marker.b, 100, false, true, 2, false, false, false, false)
                    if dist < (Config.Marker.x / 2) and not busy then
                        ESX.ShowHelpNotification(Config.Control.name..v.label)
                        if IsControlJustReleased(0, Config.Control.index) then
                            busy = true
                            StartHarvest(k)
                        end
                    end
                end
                if dist > (Config.Marker.x / 2) and harvest == k then
                    Citizen.CreateThread(function()
                        harvest = false
                        Citizen.Wait((v.time + Config.cd) * 1000)
                        busy = false
                    end)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function StartHarvest(id)
    harvest = id
    local time = Config.Harvest[id].time
    Citizen.CreateThread(function()
        while harvest == id do
            Citizen.Wait(time * 1000)
            local loading = true
            if harvest == id then
                ESX.TriggerServerCallback('0harvest0:harvestItem', function(cb)
                    if not cb then
                        harvest = false
                        loading = false
                        Citizen.Wait((time + Config.cd) * 1000)
                        busy = false
                    else
                        loading = false
                    end
                end, id)
                while loading do Citizen.Wait(0) end
            end
        end
    end)
end

