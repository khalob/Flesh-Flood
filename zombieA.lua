--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:fda4d6c07c0531caed2edce0850b810d:73d7d94c03fc9ba9f9baecabcc8423ac:aac85189c8dab4210d29bcf9df3d25f2$
--
--local sheetInfo = require("mysheet")
 --local myImageSheet = graphics.newImageSheet( "Art/Enemies/Zombie A/spriteSheet.png", sheetInfo:getSheet() )
 --local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--



local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
        {
            -- Zombie A 1
            x=1,
            y=1,
            width=74,
            height=114,

            sourceX = 1,
            sourceY = 6,
            sourceWidth = 80,
            sourceHeight = 120
        },
        {
            -- Zombie A 2
            x=77,
            y=1,
            width=74,
            height=114,

            sourceX = 1,
            sourceY = 6,
            sourceWidth = 80,
            sourceHeight = 120
        },
        {
            -- Zombie A 3
            x=153,
            y=1,
            width=74,
            height=114,

            sourceX = 1,
            sourceY = 6,
            sourceWidth = 80,
            sourceHeight = 120
        },
        {
            -- Zombie A 4
            x=229,
            y=1,
            width=74,
            height=114,

            sourceX = 1,
            sourceY = 6,
            sourceWidth = 80,
            sourceHeight = 120
        },
        {
            -- Zombie A 5
            x=305,
            y=1,
            width=74,
            height=114,

            sourceX = 1,
            sourceY = 6,
            sourceWidth = 80,
            sourceHeight = 120
        },
    },
    
    sheetContentWidth = 380,
    sheetContentHeight = 116
}

SheetInfo.frameIndex =
{

    ["Zombie A 1"] = 1,
    ["Zombie A 2"] = 2,
    ["Zombie A 3"] = 3,
    ["Zombie A 4"] = 4,
    ["Zombie A 5"] = 5,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
