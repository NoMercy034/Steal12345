local config = loadstring(game:HttpGet("https://raw.githubusercontent.com/NoMercy034/Steal12345/main/config.lua"))()
local utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/NoMercy034/Steal12345/main/utils.lua"))()
local features = loadstring(game:HttpGet("https://raw.githubusercontent.com/NoMercy034/Steal12345/main/features.lua"))()
local gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/NoMercy034/Steal12345/main/gui.lua"))()

-- تشغيل الواجهة وتمرير المتغيرات
gui.createGUI(config, features, utils)
