local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand('invoice', function(source, args, rawCommand)
    TriggerEvent('rv_invoices:client:OpenInvoiceMenu')
end, false)

RegisterNetEvent('rv_invoices:client:OpenInvoiceMenu', function()
    local input = lib.inputDialog('Invoice', {
        { type = 'number', label = 'Player ID', icon = 'hashtag' },
        { type = 'number', label = 'Amount', icon = 'cash-register' },
        { type = 'checkbox', label = 'Business?', icon= 'address-card'}
    })
    if input ~= nil  and input[1] ~= nil then
        TriggerServerEvent('rv_invoices:server:SendInvoice', input[1], input[2], input[3])
    end
end)

RegisterNetEvent('rv_invoices:client:ReceiveInvoice', function(id, amount, job)
    local input = lib.inputDialog('$' .. amount .. ' Invoice', {
        { type = 'checkbox', label = 'Pay this invoice?', icon= 'address-card'}
    })
    if input ~= nil  and input[1] ~= nil then
        TriggerServerEvent('rv_invoices:server:AcceptInvoice', id, amount, job, input[1])
    end
end)