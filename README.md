# api-stausi
Dette er et api system som gør folk ka bruge eyetarget til at oprette folk i stausi databasen uden at skulle bruge klein osv

Det er meget vigtigt af api.php er i samme folder som config.php og at api.lua lægger i serversided på det policejob


Made whit love by James ;)



her har i et exsempel på hvordan jeres qtarget kan se ud 


exports.qtarget:Player({
    options = {
        {
            icon = "fas fa-handcuffs",
            label = "Sæt i håndjern (Blidt)",
            job = 'police',
            action = function(entity)
                TriggerEvent('crp-police:handcuffPeacefully')
            end,
            canInteract = function()
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
                    return true
                else
                    return false
                end
            end,
        },
        {
            icon = "fas fa-handcuffs",
            label = "Sæt i håndjern (Hårdt)",
            job = 'police',
            action = function(entity)
                TriggerEvent('crp-police:handcuffHard')
            end,
            canInteract = function()
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
                    return true
                else
                    return false
                end
            end,
        },
        {
            icon = "fas fa-id-card",
            label = "ID Kort",
            job = 'police',
            action = function(entity)
                OpenIdentityCardMenu(NetworkGetPlayerIndexFromPed(entity))
            end,
            canInteract = function()
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
                    return true
                else
                    return false
                end
            end,
        },
        {
            icon = "fa-solid fa-ticket",
            label = "Giv en bøde",
            job = 'police',
            action = function(entity)
                OpenFineMenu(NetworkGetPlayerIndexFromPed(entity))
            end,
            canInteract = function()
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
                    return true
                else
                    return false
                end
            end,
        },
        {
            icon = "fa-solid fa-person",
            label = "Eskorter",
            job = 'police',
            action = function(entity)
                local closestPlayer = NetworkGetPlayerIndexFromPed(entity)
                TriggerServerEvent('3dme:executeMe', Lang['eskortere_personen'])
                TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
                TriggerServerEvent('esx_policejob:startdragStatus', GetPlayerServerId(closestPlayer))
            end,
            canInteract = function()
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
                    return true
                else
                    return false
                end
            end,
        },
        {
            icon = "fa-solid fa-person",
            label = "Visiter",
            job = 'police',
            action = function(entity)
                TriggerServerEvent('esx_policejob:send', 'visiter', GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)))
                exports.ox_inventory:openInventory('player', GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)))
            end,
            canInteract = function()
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
                    return true
                else
                    return false
                end
            end,
        },
        {
            icon = "fas fa-clipboard-list",
            label = "Tjek Ubetalte bøder",
            job = 'police',
            action = function(entity)
                OpenUnpaidBillsMenu(GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)))
            end,
            canInteract = function()
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
                    return true
                else
                    return false
                end
            end,
        },
        {
            icon = "fa-solid fa-gun",
            label = "Tag GSR Test",
            job = 'police',
            action = function(entity)
                TriggerServerEvent("esx_gsr:Check", GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)))
            end,
            canInteract = function()
                if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
                    return true
                else
                    return false
                end
            end,
        },
        {
            icon = "fas fa-user",
            label = "Opret i databasen",
            job = 'police',
            action = function(entity)
                local playerEntity = NetworkGetPlayerIndexFromPed(entity)
                TriggerServerEvent("esx_policejob:RegisterPlayerInDatabase", GetPlayerServerId(playerEntity))
            end,
            canInteract = function()
                local data = {
                    serviceByPass = {"statsadvokat"},
                    rangBlacklist = {"prison_elev", "prison_officer", "prison_director"},  
                    isServiceRequired = true, 
                }

                return CheckActionCredentials(data)
            end,
        },
    },
    distance = 2
})
****
