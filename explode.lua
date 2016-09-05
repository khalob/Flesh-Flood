--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:65b024c4afff77dd116965c0002af2d8:684b9da14362ff215852eefb0e3b3e2c:ab75e8734710b0ef28fe41421e861e3f$
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
            -- 1
            x=165,
            y=67,
            width=36,
            height=40,

            sourceX = 32,
            sourceY = 21,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 2
            x=57,
            y=69,
            width=46,
            height=44,

            sourceX = 27,
            sourceY = 16,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 3
            x=1,
            y=69,
            width=54,
            height=52,

            sourceX = 22,
            sourceY = 12,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 4
            x=105,
            y=67,
            width=58,
            height=58,

            sourceX = 19,
            sourceY = 9,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 5
            x=161,
            y=1,
            width=66,
            height=64,

            sourceX = 15,
            sourceY = 5,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 6
            x=85,
            y=1,
            width=74,
            height=64,

            sourceX = 10,
            sourceY = 8,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 7
            x=1,
            y=1,
            width=82,
            height=66,

            sourceX = 5,
            sourceY = 12,
            sourceWidth = 104,
            sourceHeight = 104
        },
    },
    
    sheetContentWidth = 228,
    sheetContentHeight = 126
}

SheetInfo.frameIndex =
{

    ["1"] = 1,
    ["2"] = 2,
    ["3"] = 3,
    ["4"] = 4,
    ["5"] = 5,
    ["6"] = 6,
    ["7"] = 7,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
