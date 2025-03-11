local MySQL = exports.oxmysql 

RegisterServerEvent("esx_policejob:RegisterPlayerInDatabase")
AddEventHandler("esx_policejob:RegisterPlayerInDatabase", function(target)
    local src = source
    local targetPlayer = ESX.GetPlayerFromId(target)

    if not targetPlayer then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = 'Kunne ikke finde spilleren at registrere.',
            duration = 5000
        })
        return
    end

 
    local identifier = targetPlayer.getIdentifier() or "Ukendt"

 
    local firstName, lastName
    local result = exports.oxmysql:query_async(
        "SELECT firstname, lastname FROM users WHERE identifier = ?",
        { identifier }
    )

    if result and result[1] then
        firstName = result[1].firstname or "Skift"
        lastName = result[1].lastname or "Navn"
    else
        firstName, lastName = "Skift", "Navn" 
    end


    local dob = targetPlayer.get("dateofbirth") or "01/01/2000"
    local height = targetPlayer.get("height") or 0
    local sex = targetPlayer.get("sex") == "m" and "Male" or "Female"

 
    local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(targetPlayer.source)
    if not phoneNumber or phoneNumber == "" then
        phoneNumber = "Ukendt"
    end


    print("Registering Player:")
    print("Identifier: " .. identifier)
    print("Name: " .. firstName .. " " .. lastName)
    print("Date of Birth: " .. dob)
    print("Height: " .. height)
    print("Sex: " .. sex)
    print("Phone Number: " .. phoneNumber)


    local userData = {
        identifier = identifier,
        name = ("%s %s"):format(firstName, lastName),
        dob = dob,
        height = height,
        sex = sex,
        phone_number = phoneNumber,
        gang = nil,
        note = nil,
    }


    local apiUrl = "https://Jereshjemmeside/api.php"


    PerformHttpRequest(apiUrl, function(statusCode, responseText, headers)
        if statusCode == 200 then
            TriggerClientEvent('ox_lib:notify', src, {
                type = 'success',
                description = 'Personen blev registreret i systemet.',
                duration = 5000
            })
        elseif statusCode == 400 then
            TriggerClientEvent('ox_lib:notify', src, {
                type = 'error',
                description = 'Personen findes allerede i systemet.',
                duration = 5000
            })
        else
            TriggerClientEvent('ox_lib:notify', src, {
                type = 'error',
                description = 'Registreringen mislykkedes.',
                duration = 5000
            })
            print(("Error registering player: %s (HTTP Status: %d)"):format(responseText or "No response", statusCode or 0))
        end
    end, 'POST', json.encode(userData), { ['Content-Type'] = 'application/json' })
end)
