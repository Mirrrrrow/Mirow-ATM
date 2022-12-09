ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('atm:getAccountBalance', function(source,cb)
    cb(ESX.GetPlayerFromId(source).getAccount('bank').money)
end)

ESX.RegisterServerCallback('bank:targetExists', function(source,cb, TargetName)

end)

ESX.RegisterServerCallback('atm:deposit', function(source,cb,money)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= money then
        xPlayer.removeMoney(money)
        xPlayer.addAccountMoney('bank', money)
        cb(xPlayer.getAccount('bank').money)
        TriggerClientEvent('ESX:TextUI', source, "You have deposited ~g~$"..money.."~s~ into your account", "success")
        Wait(3500)
        TriggerClientEvent('ESX:HideUI', source)
    else
        cb(xPlayer.getAccount('bank').money)
        TriggerClientEvent('ESX:TextUI', source, 'You do not have enough money', 'error')
        Wait(3500)
        TriggerClientEvent('ESX:HideUI', source)
    end
end)

ESX.RegisterServerCallback('atm:withdraw', function(source,cb,money)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getAccount('bank').money >= money then
        xPlayer.removeAccountMoney('bank', money)
        xPlayer.addMoney(money)
        cb(xPlayer.getAccount('bank').money)
        TriggerClientEvent('ESX:TextUI', source, "You have withdrawn ~g~$"..money.."~s~ from your account", "success")
        Wait(3500)
        TriggerClientEvent('ESX:HideUI', source)
    else
        cb(xPlayer.getAccount('bank').money)
        TriggerClientEvent('ESX:TextUI', source, 'You do not have enough money', 'error')
        Wait(3500)
        TriggerClientEvent('ESX:HideUI', source)
    end
end)