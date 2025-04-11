-- Define las teclas para aceptar y rechazar.
-- Estos códigos son ejemplos; si no corresponden a K y L en tu configuración, cámbialos.
local KEY_ACCEPT = 311  -- Se supone que esta tecla será "K"
local KEY_REJECT = 312  -- Se supone que esta tecla será "L"

local lastCallCoords = nil
local lastCallBlip = nil
local alertActive = false

-- Comando /911 para alertar a la policía
RegisterCommand("911", function(source, args, rawCommand)
    local msg = table.concat(args, " ")
    TriggerServerEvent("custom_chat:policeAlert", msg)
end, false)

-- Comando /911ems para alertar a SAME (médicos)
RegisterCommand("911ems", function(source, args, rawCommand)
    local msg = table.concat(args, " ")
    TriggerServerEvent("custom_chat:emsAlert", msg)
end, false)

-- Evento que recibe la llamada, crea el blip y muestra la alerta NUI
RegisterNetEvent("custom_chat:incomingCall")
AddEventHandler("custom_chat:incomingCall", function(data)
    local message = data.message
    local caller = data.caller
    lastCallCoords = data.coords  -- Ubicación de la llamada

    -- Si ya existe un blip de llamada, lo removemos
    if lastCallBlip then
        RemoveBlip(lastCallBlip)
        lastCallBlip = nil
    end

    -- Crear el blip en la ubicación de la llamada
    lastCallBlip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    SetBlipSprite(lastCallBlip, 280)  -- Sprite sugerido (puedes cambiarlo)
    SetBlipColour(lastCallBlip, 1)      -- Color rojo, por ejemplo
    SetBlipScale(lastCallBlip, 1.0)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Llamada 911")
    EndTextCommandSetBlipName(lastCallBlip)

    -- Mostrar la alerta en la interfaz NUI (sin bloquear el movimiento)
    SendNUIMessage({
        action = 'showAlert', 
        message = "Llamada de " .. caller .. ": " .. message,
        coords = data.coords
    })
    alertActive = true
    print("[DEBUG] Alerta mostrada: " .. caller .. " - " .. message)
end)

-- Hilo que detecta la pulsación de teclas para aceptar (K) o rechazar (L)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if alertActive then
            if IsControlJustPressed(0, KEY_ACCEPT) then  -- Presiona K para aceptar
                print("[DEBUG] Tecla K presionada: Aceptar llamada")
                if lastCallBlip then
                    RemoveBlip(lastCallBlip)
                    lastCallBlip = nil
                end
                SetNewWaypoint(lastCallCoords.x, lastCallCoords.y)
                TriggerEvent("chat:addMessage", {
                    color = {0, 255, 0},
                    args = {"Sistema", "Llamada aceptada. GPS marcado."}
                })
                SendNUIMessage({ action = 'hideAlert' })
                alertActive = false
            elseif IsControlJustPressed(0, KEY_REJECT) then  -- Presiona L para rechazar
                print("[DEBUG] Tecla L presionada: Rechazar llamada")
                if lastCallBlip then
                    RemoveBlip(lastCallBlip)
                    lastCallBlip = nil
                end
                TriggerEvent("chat:addMessage", {
                    color = {255, 0, 0},
                    args = {"Sistema", "Has rechazado la llamada."}
                })
                SendNUIMessage({ action = 'hideAlert' })
                alertActive = false
            end
        end
    end
end)
