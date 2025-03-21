---@example expired = {days = 1, hours = 0, minutes = 0}

function addExpiredDate(item, expired,date) 
    if not item.info then item.info = {} end
    local current = os.date("*t")
    local expire = os.time{year=current.year, month=current.month, day=current.day, hour=current.hour, min=current.min, sec=current.sec} + expired.day*24*60*60 + expired.hours*60*60 + expired.minutes*60
    local date = os.date("*t", expire)
    item.info.decay.expireat = date
    return item
end

function checkExpired(item, date)
    local current = os.time{year=date.year, month=date.month, day=date.day, hour=date.hour, min=date.min, sec=date.sec}
    local expire = os.time{year=item.info.decay.expireat.year, month=item.info.decay.expireat.month, day=item.info.decay.expireat.day, hour=item.info.decay.expireat.hour, min=item.info.decay.expireat.min, sec=item.info.decay.expireat.sec}
    if current >= expire then
        local removetiem = os.difftime(current, expire)
        local qbItem = QBCore.Shared.Items[item.name:lower()].decay
        if not qbItem then return item end
        remove =  removetiem / ((qbItem.day or 0)*24*60*60 + (qbItem.hours or 0)*60*60 + (qbItem.minutes or 0)*60)
        remove = math.floor(remove)
        item.amount = item.amount - remove or 1
        if item.amount <= 0 then
            item = nil
        end
        local date = os.date("*t")
        if not item then return item end
        item.info.decay.createat = date
         item = addExpiredDate(item, qbItem, date)    
    end
    return item
end

function CheckDecay(item)
    for k, v in pairs(item) do
        local qbItem = QBCore.Shared.Items[v.name:lower()]
        if not qbItem.decay  then goto continue end
        local date = os.date("*t")
        if not v.info or not v.info.decay or not v.info.decay.createat or not v.info.decay.expireat then 
            if type(v.info) ~= "table" then v.info = {} end
            v.info.decay = {}
            v.info.decay.createat = date
            v = addExpiredDate(v, qbItem.decay, date)
        else
            item[k] = checkExpired(v, date)
        end
        ::continue::
    end
    return item
end
--[[
RegisterCommand("checkItem", function(source, args, rawCommand)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local item = xPlayer.PlayerData.items[tonumber(args[1])]
    print(json.encode(item, { indent = true }))
end)]]