local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('rv_invoices:server:SendInvoice', function(id, amount, business)
    local src = source
    -- if src == id then
    --     TriggerClientEvent('QBCore:Notify', src, 'You cannot invoice yourself!', 'error')
    --     return
    -- end
    local Player = QBCore.Functions.GetPlayer(src)
    local job
    if business == true then
        job = Player.PlayerData.job.name
    else
        job = nil
    end
    TriggerClientEvent('rv_invoices:client:ReceiveInvoice', id, src, amount, job)
end)

RegisterNetEvent('rv_invoices:server:AcceptInvoice', function(id, amount, business, accepted)
    local src = source
    if not accepted then
        TriggerClientEvent('QBCore:Notify', src, 'You denied the invoice!', 'success')
        TriggerClientEvent('QBCore:Notify', id, 'The invoice has been declined.', 'error')
        return
    end
    local Player = QBCore.Functions.GetPlayer(src)
    local OtherPlayer = QBCore.Functions.GetPlayer(tonumber(id))
    if Player.Functions.GetMoney('bank') < amount then
        TriggerClientEvent('QBCore:Notify', src, 'You cannot afford to pay this.', 'error')
        TriggerClientEvent('QBCore:Notify', id, 'They could not afford the invoice.', 'error')
        return
    end
    Player.Functions.RemoveMoney('bank', amount)
    TriggerClientEvent('QBCore:Notify', src, 'You have paid the invoice for $' .. amount .. '!', 'success')
    TriggerClientEvent('QBCore:Notify', id, 'The invoice was paid for $' .. amount .. '!', 'success')
    if business == OtherPlayer.PlayerData.job.name then
        exports['qb-management']:AddMoney(business, amount)
        return
    end
    OtherPlayer.Functions.AddMoney('bank', amount)
end)