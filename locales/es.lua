local Translations = {
    info = {
        no_variants = "No hay variantes disponibles..",
        already_wearing = "Ya estás usando este artículo..",
        NoNearPlayer = 'No hay ningún jugador cercano..',
        NoAction = 'No hay ninguna acción disponible..',
    },
    --- Inventario
    progress = {
        snowballs = 'Recogiendo bolas de nieve..',
    },
    notify = {
        ['failed'] = 'Fallido',
        ['canceled'] = 'Cancelado',
        ['vlocked'] = 'Vehículo bloqueado',
        ['notowned'] = '¡No eres dueño de este artículo!',
        ['missitem'] = '¡No tienes este artículo!',
        ['nonb'] = '¡No hay nadie cerca!',
        ['noaccess'] = 'No accesible',
        ['nosell'] = 'No puedes vender este artículo..',
        ['itemexist'] = 'El artículo no existe',
        ['notencash'] = 'No tienes suficiente dinero..',
        ['noitem'] = 'No tienes los artículos correctos..',
        ['gsitem'] = '¿No puedes darte a ti mismo un artículo?',
        ['tftgitem'] = '¡Estás demasiado lejos para dar artículos!',
        ['infound'] = 'El artículo que intentaste dar no fue encontrado!',
        ['iifound'] = '¡Se encontró el artículo incorrecto, intenta de nuevo!',
        ['gitemrec'] = 'Has recibido ',
        ['gitemfrom'] = ' De ',
        ['gitemyg'] = 'Diste ',
        ['gitinvfull'] = '¡El inventario del otro jugador está lleno!',
        ['giymif'] = '¡Tu inventario está lleno!',
        ['gitydhei'] = 'No tienes suficiente del artículo',
        ['gitydhitt'] = 'No tienes suficientes artículos para transferir',
        ['navt'] = 'Tipo no válido..',
        ['anfoc'] = 'Argumentos no completados correctamente..',
        ['yhg'] = 'Has dado ',
        ['cgitem'] = '¡No puedes dar el artículo!',
        ['idne'] = 'El artículo no existe',
        ['pdne'] = 'El jugador no está en línea',
    },
    inf_mapping = {
        ['opn_inv'] = 'Abrir Inventario',
        ['tog_slots'] = 'Alternar ranuras de teclas rápidas',
        ['use_item'] = 'Usa el artículo en la ranura ',
    },
    menu = {
        ['vending'] = 'Máquina expendedora',
        ['bin'] = 'Abrir Basurero',
        ['craft'] = 'Fabricar',
        ['o_bag'] = 'Abrir Bolsa',
    },
    interaction = {
        ['craft'] = '~g~E~w~ - Fabricar',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
