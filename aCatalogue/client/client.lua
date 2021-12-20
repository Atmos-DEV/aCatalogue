ESX = nil

local isMenuOpened = false
local array = {    
        '15',
        '30',
        '45',
        '60',
        '75',
        '90',
        '105',
        '120'
}
local arrayIndex = 1
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)
cate = {}
voitureliste = {}




RMenu.Add("atmos", "cata", RageUI.CreateMenu("Catalogue", "Option :", nil, nil, "aLib", "black"))
RMenu:Get("atmos", "cata").Closed = function()
	FreezeEntityPosition(PlayerPedId(), false)
	isMenuOpened = false
end


RMenu.Add("atmos", "voiture", RageUI.CreateSubMenu(RMenu:Get("atmos", "cata"), "Choix voiture", nil))
RMenu:Get("atmos", "voiture").Closed = function()end

RMenu.Add("atmos", "info", RageUI.CreateSubMenu(RMenu:Get("atmos", "cata"), "Choix voiture", nil))
RMenu:Get("atmos", "info").Closed = function()end

local function openMenu()
	
	FreezeEntityPosition(PlayerPedId(), false)

    if isMenuOpened then return end
    isMenuOpened = true

	RageUI.Visible(RMenu:Get("atmos","cata"), true)

	Citizen.CreateThread(function()
        while isMenuOpened do 
         
       
            RageUI.IsVisible(RMenu:Get("atmos","cata"),true,true,true,function()
                for category = 1, #cate, 1 do
                    RageUI.ButtonWithStyle(""..cate[category].label, nil, {}, true,function(h,a,s)
                        if (s) then
                            label = cate[category].label
                            name = cate[category].name
                        end
                    end, RMenu:Get("atmos", "voiture"))
                end
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos","voiture"),true,true,true,function()
                ESX.TriggerServerCallback('cata:voiture', function(keys2)
                    voitureliste = keys2
                end)
                for voiture = 1, #voitureliste, 1 do
                    if voitureliste[voiture].category == name then
                        RageUI.ButtonWithStyle(""..voitureliste[voiture].name, nil, {}, true,function(h,a,s)
                            if s then
                                name = voitureliste[voiture].name
                                model2 = voitureliste[voiture].model
                                price = voitureliste[voiture].price
                            end
                        end, RMenu:Get("atmos", "info"))
                    end
                end
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos","info"),true,true,true,function()
                RageUI.List("Tester Le Véhicule", array, arrayIndex, array[arrayIndex].." Secondes" , {}, true, function(h, a, s, i) arrayIndex = i 
                    if s then
                        if array[arrayIndex] == "15" then
                            exports['progressBars']:startUI(15000, "Test")
                        elseif array[arrayIndex] == "30" then
                            exports['progressBars']:startUI(30000, "Test")
                        elseif  array[arrayIndex] == "45" then
                            exports['progressBars']:startUI(45000, "Test")
                        elseif  array[arrayIndex] == "60" then
                            exports['progressBars']:startUI(60000, "Test")
                        elseif  array[arrayIndex] == "75" then
                            exports['progressBars']:startUI(75000, "Test")
                        elseif  array[arrayIndex] == "90" then
                            exports['progressBars']:startUI(90000, "Test")
                        elseif  array[arrayIndex] == "105" then
                            exports['progressBars']:startUI(105000, "Test")
                        elseif  array[arrayIndex] == "120" then
                            exports['progressBars']:startUI(120000, "Test")
                        end

                        ESX.ShowNotification('~g~Vous avez '..array[arrayIndex]..' secondes pour tester ce véhicules !')
                        local model = GetHashKey(model2)
                        RequestModel(model)
                        while not HasModelLoaded(model) do Citizen.Wait(10) end
                        local vehicle = CreateVehicle(model, -37.3196144104,-1088.1246337891,26.422348022461, 250.00, true, false)
                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                        
                        
                        Citizen.Wait(array[arrayIndex] * 1000)
                        DeleteEntity(vehicle)
                        isMenuOpened = false
                        SetEntityCoords(GetPlayerPed(-1),-54.487567901611,-1088.4897460938,26.422336578369, false, false, false, true)
                        
                    end

                end)
                RageUI.ButtonWithStyle("Prix du véhicule : ~r~"..price.. " $", nil, {}, true,function(a,h,s)
                end)
                RageUI.ButtonWithStyle("Contacter un vendeur", nil, {}, true,function(a,h,s)
                    
                    if s then
                        ESX.ShowNotification('~g~Vous venez de contacter un vendeur !')
                        local info = 'contact'
                        TriggerServerEvent('atmos:AnnonceEntreprise', info)

                        local info =
                            RegisterNetEvent('atmos:InfoService')
                            AddEventHandler('atmos:InfoService', function(service, nom)
                            if service == 'contact' then
                                PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
                                ESX.ShowAdvancedNotification('Catalogue', '~g~Contact Vendeur', 'Client: ~m~ '..nom..'~m~\n~w~Souhaite acheter un(e) '..name..'', 'CHAR_CHAT_CALL', 8)
                                Wait(1000)
                                PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
                            end
                        end)
                    end
                end)
            end, function()end, 1)
            Wait(0)
        end
    end)
end



local position = {
    {x = -50.09 , y = -1089.01, z = 26.42 }  
}
Citizen.CreateThread(function()
    while true do
        interval = 750
        for k in pairs(position) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
            if dist <= 10 and not isMenuOpened then
                interval = 1
                DrawMarker(20,position[k].x, position[k].y, position[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, 0, 1, 2, 0, nil, nil, 0)
                if dist <= 1.2 and not isMenuOpened then
                    if IsControlJustPressed(1,51) then
                        openMenu()
                        ESX.TriggerServerCallback('cata:cat', function(keys)
                            cate = keys
                        end)
                    end
                end
               
                
            end
        end
    Citizen.Wait(interval)
    end
end)

