ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('SHELLDON:SEARCHBOX:Reward')
AddEventHandler('SHELLDON:SEARCHBOX:Reward', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)

	for item, random in pairs(Config.ItemReward or {}) do
		local amount = math.random(random.min, random.max)
		local chance = math.random(1, 100)

		if chance < random.chance then
			if xPlayer.canCarryItem(item, amount) then
				xPlayer.addInventoryItem(item, amount)
			else
				TriggerClientEvent("Notify_Server:SendNotification", source, {
					text    = '<b><i class="fas fa-suitcase-rolling"></i> กระเป๋าถึงขีดจำกัดแล้ว</span></b></br><span style="color: #FF0054;">ไม่สามารถ <span style="color: #A9A29F;">เก็บไอเทมเพิ่มได้อีก!',
					type    = "error",
					timeout = 5000,
					layout  = "centerLeft"
				})
			end
		end
	end
end)