-- Listas de nombres falsos
local fakeFirstNames = {
    "Juan", "Lucas", "Carlos", "Pedro", "Santiago", "Martín", "Andrés", "Nicolás", "Matías", "Tomás",
    "Ana", "Lucía", "María", "Julieta", "Sofía", "Camila", "Valentina", "Agustina", "Micaela", "Florencia"
}

local fakeLastNames = {
    "Gómez", "Pérez", "Rodríguez", "López", "García", "Fernández", "Martínez", "Díaz",
    "Sánchez", "Romero", "Herrera", "Moreno", "Ramos", "Torres", "Vega", "Cruz", "Jiménez", "Navarro"
}

-- Función para generar nombre aleatorio
local function generateFakeName()
    local first = fakeFirstNames[math.random(#fakeFirstNames)]
    local last = fakeLastNames[math.random(#fakeLastNames)]
    return first .. " " .. last
end

RegisterServerEvent("custom_chat:policeAlert")
AddEventHandler("custom_chat:policeAlert", function(msg)
    local src = source
    local coords = GetEntityCoords(GetPlayerPed(src))
    local fakeName = generateFakeName()

    for _, playerId in pairs(GetPlayers()) do
        local xTarget = ESX.GetPlayerFromId(tonumber(playerId))
        if xTarget and xTarget.job.name == "police" then
            TriggerClientEvent("cc-chat:sendMessage", playerId, {
                type = "police",
                author = "📞 Llamada 911",
                text = msg,
                color = "#1E90FF"
            })

            TriggerClientEvent("custom_chat:incomingCall", playerId, {
                caller = fakeName,
                message = msg,
                coords = { x = coords.x, y = coords.y, z = coords.z }
            })
        end
    end
end)

RegisterServerEvent("custom_chat:emsAlert")
AddEventHandler("custom_chat:emsAlert", function(msg)
    local src = source
    local coords = GetEntityCoords(GetPlayerPed(src))
    local fakeName = generateFakeName()

    for _, playerId in pairs(GetPlayers()) do
        local xTarget = ESX.GetPlayerFromId(tonumber(playerId))
        if xTarget and xTarget.job.name == "ambulance" then
            TriggerClientEvent("cc-chat:sendMessage", playerId, {
                type = "ems",
                author = "📞 SAME",
                text = msg,
                color = "#FF69B4"
            })

            TriggerClientEvent("custom_chat:incomingCall", playerId, {
                caller = fakeName,
                message = msg,
                coords = { x = coords.x, y = coords.y, z = coords.z }
            })
        end
    end
end)
