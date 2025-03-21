Config = Config or {}
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'

Config.MaxWeight = 120000
Config.MaxSlots = 40

Config.StashSize = {
    maxweight = 2000000,
    slots = 100
}

Config.DropSize = {
    maxweight = 1000000,
    slots = 50
}

Config.Keybinds = {
    Open = 'F2',
    Hotbar = 'Z',
}

Config.CleanupDropTime = 15    -- in minutes
Config.CleanupDropInterval = 1 -- in minutes

Config.ItemDropObject = `bkr_prop_duffel_bag_01a`
Config.ItemDropObjectBone = 28422
Config.ItemDropObjectOffset = {
    vector3(0.260000, 0.040000, 0.000000),
    vector3(90.000000, 0.000000, -78.989998),
}

Config.VendingObjects = {
    'prop_vend_soda_01',
    'prop_vend_soda_02',
    'prop_vend_water_01',
    'prop_vend_coffe_01',
}

Config.VendingItems = {
    { name = 'kurkakola',    price = 4, amount = 50 },
    { name = 'water_bottle', price = 4, amount = 50 },
}

Config.CanStealAnims = {
    ['random@mugging3'] = 'handsup_standing_base',
    ['missminuteman_1ig_2'] = 'handsup_base',
    ['mp_arresting'] = 'idle',
    ['combat@damage@writhe'] = 'writhe_loop',
    ['veh@low@front_ps@idle_duck'] = 'sit',
    ['move_injured_ground'] = 'front_loop',
    ['dead'] = 'dead_a',
}
