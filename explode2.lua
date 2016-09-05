--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:3f2491646c2e8d122d871e83d8bf8d54:a522484e0bc8872f919fd7c0a0fda439:bb8dc7acf2b8f60de025bed3ca510ab1$
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
            x=1,
            y=213,
            width=38,
            height=38,

            sourceX = 31,
            sourceY = 25,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 2
            x=161,
            y=197,
            width=46,
            height=44,

            sourceX = 28,
            sourceY = 21,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 3
            x=107,
            y=197,
            width=52,
            height=52,

            sourceX = 26,
            sourceY = 18,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 4
            x=209,
            y=187,
            width=64,
            height=60,

            sourceX = 19,
            sourceY = 16,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 5
            x=211,
            y=1,
            width=80,
            height=70,

            sourceX = 10,
            sourceY = 11,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 6
            x=207,
            y=103,
            width=88,
            height=82,

            sourceX = 6,
            sourceY = 5,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 7
            x=107,
            y=103,
            width=98,
            height=92,

            sourceX = 0,
            sourceY = 1,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 8
            x=107,
            y=1,
            width=102,
            height=100,

            sourceX = 0,
            sourceY = 0,
            sourceWidth = 104,
            sourceHeight = 104
        },
        {
            -- 9
            x=1,
            y=1,
            width=104,
            height=104,

        },
        {
            -- 9b
            x=1,
            y=107,
            width=104,
            height=104,

        },
    },
    
    sheetContentWidth = 296,
    sheetContentHeight = 252
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
    ["8"] = 8,
    ["9"] = 9,
    ["9b"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
