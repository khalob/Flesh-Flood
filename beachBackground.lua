--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:475d050891f121dd9b9ebec8bbf966c4:ad129f7007831d0196241e26c0804436:6aaf256c1e9290e3866b9729b63c7e76$
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
            -- 0
            x=1,
            y=1,
            width=640,
            height=480,

        },
        {
            -- 1
            x=643,
            y=1,
            width=640,
            height=480,

        },
        {
            -- 2
            x=1285,
            y=1,
            width=640,
            height=480,

        },
        {
            -- 3
            x=1927,
            y=1,
            width=640,
            height=480,

        },
        {
            -- 4
            x=2569,
            y=1,
            width=640,
            height=480,

        },
        {
            -- 5
            x=1,
            y=483,
            width=640,
            height=480,

        },
        {
            -- 6
            x=643,
            y=483,
            width=640,
            height=480,

        },
        {
            -- 7
            x=1285,
            y=483,
            width=640,
            height=480,

        },
        {
            -- 8
            x=1927,
            y=483,
            width=640,
            height=480,

        },
        {
            -- 9
            x=2569,
            y=483,
            width=640,
            height=480,

        },
        {
            -- 910
            x=1,
            y=965,
            width=640,
            height=480,

        },
        {
            -- 911
            x=643,
            y=965,
            width=640,
            height=480,

        },
        {
            -- 912
            x=1285,
            y=965,
            width=640,
            height=480,

        },
        {
            -- 913
            x=1927,
            y=965,
            width=640,
            height=480,

        },
    },
    
    sheetContentWidth = 3210,
    sheetContentHeight = 1446
}

SheetInfo.frameIndex =
{

    ["0"] = 1,
    ["1"] = 2,
    ["2"] = 3,
    ["3"] = 4,
    ["4"] = 5,
    ["5"] = 6,
    ["6"] = 7,
    ["7"] = 8,
    ["8"] = 9,
    ["9"] = 10,
    ["910"] = 11,
    ["911"] = 12,
    ["912"] = 13,
    ["913"] = 14,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
