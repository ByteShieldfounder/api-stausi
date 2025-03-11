exports.qtarget:Player({
	options = {
		{
			icon = "fas fa-user",
			label = "Opret i databasen",
            job = 'police',
            action = function(entity)
                local playerEntity = NetworkGetPlayerIndexFromPed(entity)
                TriggerServerEvent("esx_policejob:RegisterPlayerInDatabase", GetPlayerServerId(playerEntity))
			end,
		},
	},
	distance = 2.0
})
