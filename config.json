local HttpService = game:GetService("HttpService")

local config = {
    autoload = true,
    selected = "default",
    configs = {
        default = {
            fly = false,
            speed = 16,
            superJump = false,
            esp = false
        }
    }
}

local function save()
    if writefile then
        writefile("config.json", HttpService:JSONEncode(config))
    end
end

local function load()
    if readfile and isfile("config.json") then
        local data = HttpService:JSONDecode(readfile("config.json"))
        if data and data.configs then
            config = data
        end
    end
end

load()

return {
    data = config,
    save = save,
    load = load
}
