ESX = nil

local looted = {}
local models = Config.Models

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)

        if ESX ~= nil then
            PlayerData = ESX.GetPlayerData()
        else
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('SHELLDON:SEARCHBOX:Start')
AddEventHandler('SHELLDON:SEARCHBOX:Start',function()
    if not IsPedInAnyVehicle(PlayerPedId(), true) then
        local playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)
        local model

        for i = 1, #models do
            model = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, models[i], false, false, false)
            local alreadySearched = tableHasKey(looted, model)

            if not alreadySearched then
                if not model == 0 then
                    addToSet(looted, model)
                    FreezeEntityPosition(playerPed, true)
                    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)

                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "player_search",
                        duration = 5000,
                        label = "กำลังงัด ใจเย็นๆ. . .",
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                    }, function(status)
                        if not status then
                            FreezeEntityPosition(playerPed, false)
                            ClearPedTasksImmediately(playerPed)
                            TriggerServerEvent("SHELLDON:SEARCHBOX:Reward")
                        end
                    end)
                end
            else
                exports.Notify_Server:SendNotification({
                    text    = '<b><i class="fas fa-search"></i> กล่องนี้ </span></b></br><span style="color: #A9A29F;">ถูกงัดไปแล้ว <span style="color: #FFE5CC;">ลองหากล่องอื่นดูสิ',
                    type    = "info",
                    timeout = 5000,
                    layout  = "centerLeft"
                })
            end
        end
    end
end)

exports['qtarget']:AddTargetModel(models, {
    options = {
        {
            event = "SHELLDON:SEARCHBOX:Start",
            icon  = "fas fa-hand-paper",
            label = "งัดลัง",
        },
    },
    job = {"all"},
    distance = 2.5
})

addToSet = function(set, key)
    set[key] = true
end

tableHasKey = function(table, key)
    return table[key] ~= nil
end