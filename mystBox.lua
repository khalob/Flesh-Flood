--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:28edeb2d895b6a8d8471cdf0664a0632:2383e9fbd458a3b63a458939abe5817e:f1bced9571060f1d11600fe6b7434e80$
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
            y=1,
            width=104,
            height=104,

        },
        {
            -- 2
            x=107,
            y=1,
            width=104,
            height=104,

        },
        {
            -- 3
            x=213,
            y=1,
            width=104,
            height=104,

        },
        {
            -- 4
            x=319,
            y=1,
            width=104,
            height=104,

        },
    },
    
    sheetContentWidth = 424,
    sheetContentHeight = 106
}

SheetInfo.frameIndex =
{

    ["1"] = 1,
    ["2"] = 2,
    ["3"] = 3,
    ["4"] = 4,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
