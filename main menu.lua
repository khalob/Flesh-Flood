local composer = require( "composer" )
local scene = composer.newScene()
local score = require( "Scripts.score" )
local backgroundSheetInfo = require("Scripts.beachBackground")

display.setStatusBar(display.HiddenStatusBar) --Hide status bar in ios
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

	
	local function Story()
		local options = {
			effect = "crossFade",
			time = 1000,
			params = { level="Level 1", score=0 }
		}
		composer.gotoScene( "Scripts.story", options )
	end

	local function Survival()
		local options = {
			effect = "crossFade",
			time = 1000,
			params = { round= 1, score=0 }
		}

		composer.gotoScene( "Scripts.survival", options )
	end


-- local forward references should go here

-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
	
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.

		---background animation--
		local myImageSheet = graphics.newImageSheet( "Art/Background/spriteSheet.png", backgroundSheetInfo:getSheet() )
		
		local sequenceData = {
			{
			name="tide",                                  -- name of the animation
			sheet=myImageSheet,                           -- the image sheet
			start=backgroundSheetInfo:getFrameIndex("0"), -- first frame
			count=14,                                      -- number of frames
			time=2000,                                    -- speed
			loopCount=0                                   -- repeat
			}
		}

		-- create sprite, set animation, play
		background = display.newSprite( myImageSheet, sequenceData )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
		background:setSequence("tide")
		-- 6. Resize to match screen size based on a ratio with the actual background pixel dimensions
		background:scale( display.actualContentWidth/640, display.actualContentHeight/480 )
		background:play()
		sceneGroup:insert(background)

		--main menu buttons---
		--Menu Button Images
		local menuGroup = display.newGroup()
		
		local story = display.newImage(menuGroup, "Art/Main Menu/Main Buttons/Story Text 1.png", display.contentCenterX, display.contentCenterY - 200)
		local storySoon = display.newImage(menuGroup, "Art/Main Menu/Other Buttons/comingsoon.png", display.contentCenterX, display.contentCenterY - 200)
		
		local survival = display.newImage(menuGroup, "Art/Main Menu/Main Buttons/Survival Text 1.png", display.contentCenterX, display.contentCenterY)
		local curHighscore = display.newImage(menuGroup, "Art/Main Menu/Main Buttons/highscore.png", display.contentCenterX - 20, display.contentCenterY + 40)
		
		local scoreText = score.init({
		   fontSize = 32,
		   font = "octin.ttf",
		   x = display.contentCenterX + 180,
		   y = display.contentCenterY + 40,
		   maxDigits = 5,
		   leadingZeros = true,
		   filename = "scorefile.txt",
		})
		
		scoreText:setTextColor(0, 0, 0)
		if(score.load() ~= nil) then
			score.set(score.load())
		end
		menuGroup:insert(scoreText)
		local controls = display.newImage(menuGroup, "Art/Main Menu/Main Buttons/Controls Text 1.png", display.contentCenterX, display.contentCenterY + 200)
		local controlsSoon = display.newImage(menuGroup,"Art/Main Menu/Other Buttons/comingsoon.png", display.contentCenterX, display.contentCenterY + 200)
		
		--Menu Listeners
		--story:addEventListener("tap", Story)
		survival:addEventListener("tap", Survival)
		--controls:addEventListener("tap", Story)
		sceneGroup:insert(menuGroup)
		
		
		--[[
	local function onOrientationChange(e)
		if(e.type ~= "faceUp" or e.type ~= "faceDown") then
			if(e.type == "landscapeLeft" or e.type == "landscapeRight") then
				for i=1, sceneGroup.numChildren do
					if(sceneGroup[i].numChildren ~= nil) then
						for x=1, sceneGroup[i].numChildren do
							local newAngle = sceneGroup[i][x].rotation - e.delta*2
							local newY = sceneGroup[i][x].y - display.contentCenterY
							transition.to (sceneGroup[i][x], {time=150, rotation = newAngle, x = sceneGroup[i][x].x - (sceneGroup[i][x].x - display.contentCenterX)*2 ,y = sceneGroup[i][x].y - (sceneGroup[i][x].y - display.contentCenterY) * 2})
							--sceneGroup[i][x].rotation = sceneGroup[i][x].rotation - (e.delta*2)
						end
					else
						local newAngle = sceneGroup[i].rotation - e.delta*2
						transition.to (sceneGroup[i], {time=150, rotation = newAngle, x = sceneGroup[i].x - (sceneGroup[i].x - display.contentCenterX)*2 ,y = sceneGroup[i].y - (sceneGroup[i].y - display.contentCenterY) * 2})
					end
				end
				
			end
		end
	end
		
	
	
	
	Runtime:addEventListener("orientation", onOrientationChange)]]--

end



-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
		
		--Audio
		local mainBackgroundMusic = audio.loadStream( "Audio/main menu.mp3" ) 
		local mainBackgroundMusicChannel = audio.play(mainBackgroundMusic, {channel=1, loops=-1, fadein=725} )
		
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
		
    end
end

-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
		
		audio.stop()
		
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )

-- -------------------------------------------------------------------------------

return scene