local Players = game:GetService("Players")
local Http = game:GetService("HttpService")
local rs = game:GetService("RunService")

local web = "https://discord.com/api/webhooks/actual wh url omitted for the sake of the application"
local uptime = os.time()
local hostPlayer
local joinedPlayers = {}

Players.PlayerAdded:Connect(function(plr)
	if not hostPlayer then hostPlayer = plr end
	table.insert(joinedPlayers, plr)
end)

local function formattime(unix, fmt)
	fmt = fmt or "f"
	return string.format("<t:%d:%s>", unix, fmt)
end

local function srdm()
	local endTime = os.time()
	local hostTxt = hostPlayer and string.format("%s (%s) | UserId: %d", hostPlayer.DisplayName, hostPlayer.Name, hostPlayer.UserId)
		or "null"

	local playerTxt = ""
	for _, plr in ipairs(joinedPlayers) do
		playerTxt = playerTxt .. string.format("- %s (%s) | UserId: %d\n", plr.DisplayName, plr.Name, plr.UserId)
	end
	if playerTxt == "" then playerTxt = "null" end

	local payload = {
		embeds = {{
			title = "URTM_SRDM",
			description = string.format(
				"**Job ID:** %s\n**Place ID:** %s\n**Game ID:** %s\n**Time Began:** %s\n**Time Ended:** %s\n**Host:** %s\n**Players Joined:** %d\n\n**Player List:**\n%s\n**Studio:** %s\n**Memory (KB):** %d",
				game.JobId or "n/a",
				game.PlaceId,
				game.GameId,
				formattime(uptime),
				formattime(endTime),
				hostTxt,
				#joinedPlayers,
				playerTxt,
				tostring(rs:IsStudio()),
				collectgarbage("count")
			),
			color = 5814783
		}}
	}

	pcall(function()
		Http:PostAsync(web, Http:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
	end)
end

game:BindToClose(srdm)
