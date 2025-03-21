
LastEquipped = {}
Cooldown = false

local function PlayToggleEmote(e, cb)
	local Ped = PlayerPedId()
	while not HasAnimDictLoaded(e.Dict) do RequestAnimDict(e.Dict) Wait(100) end
	if IsPedInAnyVehicle(Ped) then e.Move = 51 end
	TaskPlayAnim(Ped, e.Dict, e.Anim, 3.0, 3.0, e.Dur, e.Move, 0, false, false, false)
	local Pause = e.Dur-500 if Pause < 500 then Pause = 500 end
	IncurCooldown(Pause)
	Wait(Pause) -- Lets wait for the emote to play for a bit then do the callback.
	cb()
end

function ResetClothing(anim)
	if type(anim) == "table" then
		anim = true
	end
	local Ped = PlayerPedId()
	local e = drawables.jacket.Emote
	if anim then TaskPlayAnim(Ped, e.Dict, e.Anim, 3.0, 3.0, 3000, e.Move, 0, false, false, false) end
	for _, v in pairs(LastEquipped) do
		if v then
			if v.Drawable then SetPedComponentVariation(Ped, v.Id, v.Drawable, v.Texture, 0)
			elseif v.Prop then ClearPedProp(Ped, v.Id) SetPedPropIndex(Ped, v.Id, v.Prop, v.Texture, true) end
		end
	end
	LastEquipped = {}
end
RegisterCommand('resetclothing', function() ResetClothing(true) end)

function Preselector(whic)
	if drawables[whic] then
		ToggleClothing(whic)
	elseif Extras[whic] then
		ToggleClothing(whic, true)
	elseif Props[whic] then
		ToggleProps(whic)
	elseif whic == "reset" then
		if not ResetClothing(true) then
			Notify('Nothing To Reset', 'error')
		end
	end
end

function ToggleClothing(whic, extra)
	local which = whic
	if type(whic) == "table" then
		which = tostring(whic.id)
	end
	Wait(50)

    if which == "shirt" or which == "pants" or which == "bag" then
        extra = true
    end
	if Cooldown then return end
	local Toggle = drawables[which] if extra then Toggle = Extras[which] end
	local Ped = PlayerPedId()
	local Cur = { -- Lets check what we are currently wearing.
		Drawable = GetPedDrawableVariation(Ped, Toggle.Drawable),
		Id = Toggle.Drawable,
		Ped = Ped,
		Texture = GetPedTextureVariation(Ped, Toggle.Drawable),
	}
	local Gender = IsMpPed(Ped)
	if which ~= "mask" then
		if not Gender then Notify(Lang:t("info.wrong_ped")) return false end -- We cancel the command here if the person is not using a multiplayer model.
	end
	local Table = Toggle.Table[Gender]
	if not Toggle.Table.Standalone then -- "Standalone" is for things that dont require a variant, like the shoes just need to be switched to a specific drawable. Looking back at this i should have planned ahead, but it all works so, meh!
		for k,v in pairs(Table) do
			if not Toggle.Remember then
				if k == Cur.Drawable then
					PlayToggleEmote(Toggle.Emote, function() SetPedComponentVariation(Ped, Toggle.Drawable, v, Cur.Texture, 0) end) return true
				end
			else
				if not LastEquipped[which] then
					if k == Cur.Drawable then
						PlayToggleEmote(Toggle.Emote, function() LastEquipped[which] = Cur SetPedComponentVariation(Ped, Toggle.Drawable, v, Cur.Texture, 0) end) return true
					end
				else
					local Last = LastEquipped[which]
					PlayToggleEmote(Toggle.Emote, function() SetPedComponentVariation(Ped, Toggle.Drawable, Last.Drawable, Last.Texture, 0) LastEquipped[which] = false end) return true
				end
			end
		end
		if Toggle.not_variation then 
			if Cur.Drawable == Toggle.not_variation[Gender] and LastEquipped[which] then 
				local Last = LastEquipped[which]
				PlayToggleEmote(Toggle.Emote, function() SetPedComponentVariation(Ped, Toggle.Drawable, Last.Drawable, Last.Texture, 0) LastEquipped[which] = false end) return true	
			end
			LastEquipped[which] = Cur
			PlayToggleEmote(Toggle.Emote, function() SetPedComponentVariation(Ped, Toggle.Drawable, Toggle.not_variation[Gender], Cur.Texture, 0) end) return true
		end
		Notify(Lang:t("info.no_variants")) return
	else
		if not LastEquipped[which] then
			if Cur.Drawable ~= Table then
				PlayToggleEmote(Toggle.Emote, function()
					LastEquipped[which] = Cur
					SetPedComponentVariation(Ped, Toggle.Drawable, Table, 0, 0)
					if Toggle.Table.Extra then
						local extraToggled = Toggle.Table.Extra
						for _, v in pairs(extraToggled) do
							local ExtraCur = {Drawable = GetPedDrawableVariation(Ped, v.Drawable),  Texture = GetPedTextureVariation(Ped, v.Drawable), Id = v.Drawable}
							SetPedComponentVariation(Ped, v.Drawable, v.Id, v.Tex, 0)
							LastEquipped[v.Name] = ExtraCur
						end
					end
				end)
				return true
			end
		else
			local Last = LastEquipped[which]
			PlayToggleEmote(Toggle.Emote, function()
				SetPedComponentVariation(Ped, Toggle.Drawable, Last.Drawable, Last.Texture, 0)
				LastEquipped[which] = false
				if Toggle.Table.Extra then
					local extraToggled = Toggle.Table.Extra
					for _, v in pairs(extraToggled) do
						if LastEquipped[v.Name] then
							Last = LastEquipped[v.Name]
							SetPedComponentVariation(Ped, Last.Id, Last.Drawable, Last.Texture, 0)
							LastEquipped[v.Name] = false
						end
					end
				end
			end)
			return true
		end
	end
	Notify(Lang:t("info.already_wearing")) return false
end

function ToggleProps(whic)
	local which = whic
	if type(whic) == "table" then
		which = tostring(whic.id)
	end
	Wait(50)

	if Cooldown then return end
	local Prop = Props[which]
	local Ped = PlayerPedId()
	local Cur = { -- Lets get out currently equipped prop.
		Id = Prop.Prop,
		Ped = Ped,
		Prop = GetPedPropIndex(Ped, Prop.Prop),
		Texture = GetPedPropTextureIndex(Ped, Prop.Prop),
	}
	if not Prop.Variants then
		if Cur.Prop ~= -1 then -- If we currently are wearing this prop, remove it and save the one we were wearing into the LastEquipped table.
			PlayToggleEmote(Prop.Emote.Off, function() LastEquipped[which] = Cur ClearPedProp(Ped, Prop.Prop) end) return true
		else
			local Last = LastEquipped[which] -- Detect that we have already taken our prop off, lets put it back on.
			if Last then
				PlayToggleEmote(Prop.Emote.On, function() SetPedPropIndex(Ped, Prop.Prop, Last.Prop, Last.Texture, true) end) LastEquipped[which] = false return true
			end
		end
		Notify(Lang:t("info.nothing_to_remove")) return false
	else
		local Gender = IsMpPed(Ped)
		if not Gender then Notify(Lang:t("info.wrong_ped")) return false end -- We dont really allow for variants on ped models, Its possible, but im pretty sure 95% of ped models dont really have variants.
		variations = Prop.Variants[Gender]
		for k,v in pairs(variations) do
			if Cur.Prop == k then
				PlayToggleEmote(Prop.Emote.On, function() SetPedPropIndex(Ped, Prop.Prop, v, Cur.Texture, true) end) return true
			end
		end
		Notify(Lang:t("info.no_variants")) return false
	end
end

RegisterNetEvent('qb-radialmenu:ToggleProps', ToggleProps)

for k,v in pairs(Config.Commands) do
	RegisterCommand(k, v.Func)
	TriggerEvent("chat:addSuggestion", "/"..k, v.Desc)
end

if Config.ExtrasEnabled then
	for k,v in pairs(Config.ExtraCommands) do
		RegisterCommand(k, v.Func)
		TriggerEvent("chat:addSuggestion", "/"..k, v.Desc)
	end
end

AddEventHandler('onResourceStop', function(resource) -- Mostly for development, restart the resource and it will put all the clothes back on.
	if resource == GetCurrentResourceName() then
		ResetClothing()
	end
end)

function IncurCooldown(ms)
	CreateThread(function()
		Cooldown = true Wait(ms) Cooldown = false
	end)
end

function Notify(message, color) -- However you want your notifications to be shown, you can switch it up here.
	QBCore.Functions.Notify(message, color)
end

function IsMpPed(ped)
	local male = `mp_m_freemode_01` local female = `mp_f_freemode_01`
	local CurrentModel = GetEntityModel(ped)
	if CurrentModel == male then return "male" elseif CurrentModel == female then return "female" else return false end
end

RegisterNetEvent('dpc:EquipLast', function()
	local Ped = PlayerPedId()
	for _, v in pairs(LastEquipped) do
		if v then
			if v.Drawable then SetPedComponentVariation(Ped, v.ID, v.Drawable, v.Texture, 0)
			elseif v.Prop then ClearPedProp(Ped, v.ID) SetPedPropIndex(Ped, v.ID, v.Prop, v.Texture, true) end
		end
	end
	LastEquipped = {}
end)

RegisterNetEvent('dpc:ResetClothing', function()
	LastEquipped = {}
end)
