local Players = game:GetService("Players")

local function getLocalPlayer()
    return Players.LocalPlayer
end

local function notify(title, text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5
        })
    end)
end

return {
    getPlayer = getLocalPlayer,
    notify = notify
}
