-- NoMercy034 | CONFIG SYSTEM

local HttpService = game:GetService("HttpService")
local configFile = "config.json"

local config = {
    autoload = false,
    selectedConfig = "default",
    configs = {
        default = {
            fly = false,
            speed = 16,
            superJump = false,
            esp = false,
            tpToSky = false
        }
    }
}

-- تحميل الإعدادات من ملف config.json إذا كان موجود
if readfile and isfile and isfile(configFile) then
    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(configFile))
    end)
    if success then
        config = result
    end
end

-- دالة لحفظ الإعدادات في ملف config.json
local function saveConfig()
    if writefile then
        local json = HttpService:JSONEncode(config)
        writefile(configFile, json)
    end
end

-- تطبيق الإعدادات المحملة تلقائيًا عند بدء السكربت لو autoload مفعل
local selected = config.configs[config.selectedConfig]
if config.autoload and selected then
    flyEnabled = selected.fly or false
    currentSpeed = selected.speed or 16
    superJump = selected.superJump or false
    espEnabled = selected.esp or false
    tpToSkyEnabled = selected.tpToSky or false
end

-- مثال: دالة لتغيير حالة الطيران وحفظ الإعدادات
local function setFly(enabled)
    flyEnabled = enabled
    config.configs[config.selectedConfig].fly = enabled
    saveConfig()
end

-- مثال: دالة لتغيير السرعة وحفظ الإعدادات
local function setSpeed(value)
    currentSpeed = value
    config.configs[config.selectedConfig].speed = value
    saveConfig()
end

-- يمكنك بناء دوال مماثلة لباقي الإعدادات

return {
    config = config,
    saveConfig = saveConfig,
    setFly = setFly,
    setSpeed = setSpeed
    -- أضف باقي الدوال حسب حاجتك
}
