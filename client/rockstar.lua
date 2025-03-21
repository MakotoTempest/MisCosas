function Editor()
    exports['qb-menu']:openMenu({
        {
            header = 'Rockstar Editor',
            isMenuHeader = true,
        },
        {
            header = 'Iniciar Grabación',
            txt = '',
            icon = "fas fa-video",
            params = {
                event = 'qb-inventory:client:rockstareditor',
                args = "start"
            }
        },
        {
            header = 'Guardar Grabación',
            txt = '',
            icon = "fas fa-save",
            params = {
                event = 'qb-inventory:client:rockstareditor',
                args = "save"
            }
        },
        {
            header = 'Cancelar Grabación',
            txt = '',
            icon = "fas fa-save",
                params = {
                    event = 'qb-inventory:client:rockstareditor',
                    args = "cancel"
                }
            },
        {
            header = 'Iniciar Rockstar Editor',
            txt = '',
            icon = "fas fa-edit",
            params = {
                event = 'qb-inventory:client:rockstareditor',
                args = "editor"
            }
        }
    })
end

RegisterCommand('rockstar_editor', Editor)

RegisterNetEvent('qb-inventory:client:rockstareditor')
AddEventHandler('qb-inventory:client:rockstareditor', function(args)
    if args == "start" then
        StartRecording(1)
        TriggerEvent('QBCore:Notify', '¡Inicio de Grabación!', 'success')
    elseif args == "save" then
        StopRecordingAndSaveClip()
        TriggerEvent('QBCore:Notify', '¡Grabación guardada correctamente!', 'success')
    elseif args == "cancel" then
        StopRecordingAndDiscardClip()
        TriggerEvent('QBCore:Notify', '¡Grabación eliminada correctamente!', 'error')
    elseif args == "editor" then
        NetworkSessionLeaveSinglePlayer()
        ActivateRockstarEditor()
    end
end)
