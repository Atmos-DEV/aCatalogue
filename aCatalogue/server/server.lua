ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('cata:cat', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local keys = {}

    MySQL.Async.fetchAll('SELECT * FROM vehicle_categories', {}, 
        function(result)
        for category = 1, #result, 1 do
            table.insert(keys, {
                name = result[category].name,
                label = result[category].label,
            })
        end
        cb(keys)

    end)
end)

ESX.RegisterServerCallback('cata:voiture', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local keys2 = {}

    MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, 
        function(result)
        for voiture = 1, #result, 1 do
            table.insert(keys2, {
                name = result[voiture].name,
                model = result[voiture].model,
                price = result[voiture].price,
                category = result[voiture].category
            })
        end
        cb(keys2)

    end)
end)

RegisterServerEvent('atmos:AnnonceEntreprise')
AddEventHandler('atmos:AnnonceEntreprise', function(PriseOuFin)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'cardealer' then
			TriggerClientEvent('atmos:InfoService', xPlayers[i], _raison, name)
		end
	end
end)