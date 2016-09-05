--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:833dada7b5612b63668ea311a6e3d802:eea0cfb691f8b9466ea2aa15e24bfa00:b08a273287f2401a32523d55313a1a13$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- Zombie B 1
            x=1,
            y=43,
            width=56,
            height=40,

            sourceX = 0,
            sourceY = 20,
            sourceWidth = 80,
            sourceHeight = 60
        },
        {
            -- Zombie B 2
            x=1,
            y=85,
            width=56,
            height=40,

            sourceX = 0,
            sourceY = 20,
            sourceWidth = 80,
            sourceHeight = 60
        },
        {
            -- Zombie B 3
            x=1,
            y=1,
            width=58,
            height=40,

            sourceX = 0,
            sourceY = 20,
            sourceWidth = 80,
            sourceHeight = 60
        },
    },
    
    sheetContentWidth = 60,
    sheetContentHeight = 126
}

SheetInfo.frameIndex =
{

    ["Zombie B 1"] = 1,
    ["Zombie B 2"] = 2,
    ["Zombie B 3"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
