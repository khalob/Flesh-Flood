-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------			
local composer = require("composer")

local options = {
    effect = "crossFade",
    time = 1000,
    params = { level=1, score=0 }
}

composer.gotoScene("Scripts.main menu", options )