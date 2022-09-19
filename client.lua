ESX = exports["es_extended"]:getSharedObject()

local Debug = ESX.GetConfig().EnableDebug
local ATMS = Config.ATM
local ATM
local InterActRadius = Config.Radius
local menu = nil
local TextUISend = false

_menuPool = NativeUI.CreatePool()

if Config.SinglePosition == true then
    function nearATM()
        for _,value in pairs(ATMS) do
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local atmCoords = vector3(value)
            local distance = #(playerCoords - atmCoords)
            if distance <= InterActRadius then
                return true
            end
        end
    end
end
if Config.AutoDetection == true then
    function nearATM()
        for _,value in pairs(Config.ATMModels) do
            local model = GetHashKey(value)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            entity = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, InterActRadius, model, false, false, false)
            if entity ~= 0 then
                return true
            end
        end
    end
end


CreateThread(function()
    while true do
        _menuPool:ProcessMenus()
        if nearATM() then
            print('NEAR')
            if not TextUISend then
                ESX.TextUI("Press ~g~E~s~, to open the atm", "info")
                TextUISend = true
            end
            if IsControlJustPressed(0,38) then
                openMenu()
            end
        else
            if menu ~= nil then
                menu:Visible(false)
                menu = nil
            end
            if TextUISend then
                ESX.HideUI()
                TextUISend = false
            end
        end
        Wait(1)
    end
end)



function openMenu()
    local mainMenu = NativeUI.CreateMenu("ATM", "Select an option")
    _menuPool:Add(mainMenu)

    local cashItem = NativeUI.CreateItem("Balance:", "Your account balance")
    mainMenu:AddItem(cashItem)

    local depositItem = NativeUI.CreateItem("Deposit:", "Deposit money into your account")
    mainMenu:AddItem(depositItem)


    local withdrawItem = NativeUI.CreateItem("Withdraw:", "Withdraw money from your account")
    mainMenu:AddItem(withdrawItem)




    depositItem:RightLabel("~b~>>>")
    withdrawItem:RightLabel("~b~>>>")
    ESX.TriggerServerCallback('atm:getAccountBalance', function(PlayerBank) 
        cashItem:RightLabel("~b~"..PlayerBank.. "$")

        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled(false)
        mainMenu:Visible(true)
        menu = mainMenu
    end)

    mainMenu.OnItemSelect = function(sender, item, index)
        if item == depositItem then
            mainMenu:Visible(false)
            local retval = KeyboardInput("Deposit Amount", "", 7)
            if retval ~= nil and retval ~= "" then
                if tonumber(retval) ~= nil then
                    if tonumber(retval) > 0 then
                        ESX.TriggerServerCallback('atm:deposit', function(PlayerBank)
                            cashItem:RightLabel("~b~"..PlayerBank.. "$")
                            _menuPool:RefreshIndex()
                            _menuPool:MouseControlsEnabled(false)
                            mainMenu:Visible(true)
                            menu = mainMenu
                        end, tonumber(retval))
                    else
                        ESX.TextUI("You can't deposit ~r~negative~s~ money.", "error")
                        Wait(3500)
                        ESX.HideUI()
                    end
                else
                    ESX.TextUI("You can't deposit ~r~letters~s~.", "error")
                    Wait(3500)
                    ESX.HideUI()
                end
            else 
                openMenu()
            end
        elseif item == withdrawItem then
            mainMenu:Visible(false)
            local retval = KeyboardInput("Withdraw Amount", "", 7)
            if retval ~= nil then
                if tonumber(retval) ~= nil then
                    if tonumber(retval) > 0 then
                        ESX.TriggerServerCallback('atm:withdraw', function(PlayerBank)
                            cashItem:RightLabel("~b~"..PlayerBank.. "$")
                            _menuPool:RefreshIndex()
                            _menuPool:MouseControlsEnabled(false)
                            mainMenu:Visible(true)
                            menu = mainMenu
                        end, tonumber(retval))
                    else
                        ESX.TextUI("You can't withdraw ~r~negative~s~ money.", "error")
                        Wait(3500)
                        ESX.HideUI()
                    end
                else
                    ESX.TextUI("You can't withdraw ~r~letters~s~.", "error")
                    Wait(3500)
                    ESX.HideUI()
                end
            else 
                openMenu()
            end
        end
    end


end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

	-- TextEntry		-->	The Text above the typing field in the black square
	-- ExampleText		-->	An Example Text, what it should say in the typing field
	-- MaxStringLenght	-->	Maximum String Lenght

	AddTextEntry('FMMC_KEY_TIP1', TextEntry) --Sets the Text above the typing field in the black square
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) --Actually calls the Keyboard Input
	blockinput = true --Blocks new input while typing if **blockinput** is used

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() --Gets the result of the typing
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return result --Returns the result
	else
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return nil --Returns nil if the typing got aborted
	end
end