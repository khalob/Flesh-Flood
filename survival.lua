local composer = require( "composer" )
local highscore = require( "Scripts.score" )
local health = require( "Scripts.health" )

health.start()
local physics = require( "physics" ) --Include Corona's "physics" library
local scene = composer.newScene()
local zombieASheetInfo = require( "Scripts.zombieA" )
local zombieBSheetInfo = require( "Scripts.zombieB" )
local mystBoxInfo = require( "Scripts.mystBox" )
local explodeInfo = require( "Scripts.explode" )
local explode2Info = require( "Scripts.explode2" )
local backgroundSheetInfo = require( "Scripts.beachBackground" )
system.activate( "multitouch" )

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------
	--timers
	local fireTimerTop
	local fireTimer
	local fireTimerBottom
	local spawnTimer
	local spawnTimer2
	local timer4
	local timer5
	
-- "scene:create()"
function scene:create( event )
    sceneGroup = self.view
	
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
	
	highscore.load()
	
	--Collision Filtering
	local playerCollisionFilter = {categoryBits=1, maskBits=8}
	local bulletCollisionFilter = {categoryBits=2, maskBits=16}
	local playerAreaCollisionFilter = {categoryBits=4, maskBits=16}
	local powerupCollisionFilterPhase2 = {categoryBits=8, maskBits=1}
	local zombieCollisionFilter = {categoryBits=16, maskBits=6}

	--Uses Corona's Physics 
	physics.start()
	physics.setGravity(0,0) --take away gravity
	
	--Image Layers
	local farBackground = display.newGroup()  
	local nearBackground = display.newGroup()  --this will overlay 'farBackground'  
	local foreground = display.newGroup()  --and this will overlay 'nearBackground'
	
	--Player Area
	local playerArea = display.newRect(display.contentWidth * (3/4), display.contentHeight/2, display.contentWidth /2, display.contentHeight)
	playerArea.isVisible = false
	playerArea.isHitTestable = true
	
	--Slow Zone
	--local slowZone = display.newRect(display.contentWidth * (11.75/16), display.contentHeight/2, display.contentWidth / 5, display.contentHeight)
	
	
	--Death timers for enemies (used for explode animation)
	local DTimers = {}  
	
	--Death timers for items (used for explode animation)
	local ITimers = {} 
	
	--Shake
	local shakeamount = 0
	local settings = display.newGroup() 
	settings.shakeeffect = true
	sceneGroup.originalX = sceneGroup.x
	sceneGroup.originalY = sceneGroup.y
	
	--Hitbox Area
	local hitboxArea = display.newRect(display.contentWidth + (display.contentWidth * (1/6)), display.contentHeight/2, display.contentWidth * (1/4), display.contentHeight)
	--hitboxArea.isVisible = false
	hitboxArea.name = "playerHitbox";
	physics.addBody(hitboxArea, "kinematic", {filter=bulletCollisionFilter})
	
	--Player
	local player = display.newImage("Art/Player/Ralph 1.png")
	player.name = "player"
	physics.addBody(player, "kinematic", {filter=playerCollisionFilter})
	player.x = display.contentWidth * .95
	player.y = display.contentHeight/2

	--Display score in top right
	local score = event.params.score
	local scoreText = display.newText(score, display.viewableContentWidth * .95, display.contentHeight/18, "octin.ttf", 50)
	scoreText:setTextColor(0, 0, 0)
	foreground:insert(scoreText)
	
	--Pause button
	local pause = display.newImage(foreground, "Art/Main Menu/Other Buttons/pause.png", display.contentWidth * .05, (display.contentHeight * .92))
	pause.xScale = 1.5
	pause.yScale = 1.5
	
	--Quit button
	local quitButton = display.newImage(foreground, "Art/Main Menu/Other Buttons/quit.png", display.contentWidth/3, display.contentHeight/2)
	quitButton.xScale = 1.5
	quitButton.yScale = 1.5
	quitButton.isVisible = false
	
	--Resume button
	local resume = display.newImage(foreground, "Art/Main Menu/Other Buttons/resume.png", (display.contentWidth/3) * 2, display.contentHeight/2)
	resume.xScale = 1.5
	resume.yScale = 1.5
	resume.isVisible = false
	
	--Display round in top left
	local displayRound
	local currentRound = 1

	local baseRateOfFire = 2
	local curRateOfFire = 2
	local projectiles = display.newGroup()
	local objectsToDie = display.newGroup()
	local objectsToRemoveBody = display.newGroup()
	local enemies = display.newGroup()
	local mystBoxes = display.newGroup()
	local zombiesSpawned = 0
	local waveIncrementor = 15 --Should be 15
	local waveMax = (currentRound * waveIncrementor) + 5
	
	local waitingOnNewRound = false
	local paused = false
	
	function Resume(event)
		if ( event.phase == "began" and paused) then
			local function resumeTouch()
				playerArea.isHitTestable = true
			end
			physics.start()
			health.resume()
			transition.resume()
			timer.resume(fireTimer)
			if(fireTimerTop ~= nil) then
				timer.resume(fireTimerTop)
			end
			if(fireTimerBottom ~= nil) then
				timer.resume(fireTimerBottom)
			end
			timer.resume(spawnTimer)
			if(spawnTimer2 ~= nil) then
				timer.resume(spawnTimer2)
			end
			timer.resume(timer4)
			if(timer5 ~= nil) then
				timer.resume(timer5)
			end
			for i=1, enemies.numChildren  do
				enemies[i]:play()
			end
			for i=1, mystBoxes.numChildren  do
				mystBoxes[i]:play()
			end
			resume.isVisible = false
			quitButton.isVisible = false
			
			for i, value in pairs(DTimers) do
				timer.resume(DTimers[i])
			end
			
			for i, value in pairs(ITimers) do
				timer.resume(ITimers[i])
			end
			timer.performWithDelay(100, resumeTouch)
			paused = false
		end
	end

	function checkHighscore()
		if(highscore.get() < score) then
			highscore.set(score)
			highscore.save()
		end
	end
	
	function Quit(event)
		checkHighscore()
		health.stop()
		transition.pause()
		local options = {effect = "crossFade", time = 1000, params = { level="Wave 1", score=0 }}
		for i=1,enemies.numChildren  do
			table.insert(objectsToDie, enemies[i])
		end
		for i=1,sceneGroup.numChildren  do
			table.insert(objectsToDie, sceneGroup[i])
		end
		composer.removeScene("Scripts.survival", false)
		composer.gotoScene("Scripts.main menu", options)
	end
	
	function Pause(event)
		if ( event.phase == "began" and not(paused)) then
			--audio.pause()
			physics.pause()
			health.pause()
			transition.pause()
			for i, value in pairs(DTimers) do
				timer.pause(DTimers[i])
			end
			for i, value in pairs(ITimers) do
				timer.pause(ITimers[i])
			end
			timer.pause(fireTimer)
			if(fireTimerTop ~= nil) then
				timer.pause(fireTimerTop)
			end
			if(fireTimerBottom ~= nil) then
				timer.pause(fireTimerBottom)
			end
			timer.pause(spawnTimer)
			if(spawnTimer2 ~= nil) then
				timer.pause(spawnTimer2)
			end
			timer.pause(timer4)
			if(timer5 ~= nil) then
				timer.pause(timer5)
			end
			for i=1, enemies.numChildren  do
				enemies[i]:pause()
			end
			for i=1, mystBoxes.numChildren  do
				mystBoxes[i]:pause()
			end
			resume.isVisible = true
			quitButton.isVisible = true
			playerArea.isHitTestable = false
			paused = true
		end
	end

	local function playerMovement(event)
		player.y = event.y
		--player.x = event.x --no clip mode
	end

	local function displayCurrentRound()
		display.remove(displayRound)
		displayRound = nil
		displayRound = display.newText("ROUND " .. currentRound, display.contentWidth * .10, display.contentHeight/18, "octin.ttf", 50)
		displayRound:setTextColor(0, 0, 0)
		foreground:insert(displayRound)
	end
	
	local function fire(...)
		local y = table.remove(arg)
		if(tonumber(y) == nil) then
			y = 0
		end
		y = y + 10

		local p = display.newImage("Art/Weapons/shot.png", player.x - 30, player.y - y)
		physics.addBody(p, {filter=bulletCollisionFilter})
		p.name = "bullet"
		p.collision = onCollision
		p:addEventListener("collision", p)
		projectiles:insert(p)
		local xPos
		xPos = p.x-2000
		transition.to(p, { time = 1000, x = xPos, y = p.y,
		onComplete = function(p)
			if (p.parent ~= nil) then --if it is not already dead, kill it
				p.parent:remove(p) 
				p = nil
			end
		end
	})
	end

	function resetFillEffect(event)
		event.other.fill.effect = nil
	end

	function onCollision(self, event)
		if self.name == "bullet" then
			table.insert(objectsToDie, self) --Kill the bullet
				
			local function killZombie()
				table.remove(DTimers, 1) --Remove timer entry
				table.insert(objectsToDie, event.other) --Kill the enemy
			end
				
			event.other.hp = event.other.hp - 1
			if event.other.hp <=0 then
				table.insert(objectsToRemoveBody, event.other)
				transition.cancel(event.other)
				event.other:setSequence("explode") --Death animation
				event.other:play()
				score = score + event.other.value
				scoreText.text = score 
				local deathTimer = timer.performWithDelay(200, killZombie, 1)
				table.insert(DTimers, deathTimer)
			else
				
				--Make the zombie blink
				local function killBlink()
					if event.other.setFillColor ~= nil then
						transition.cancel(event.other.trans)
						event.other:setFillColor(255,255,255) 
					end 
				end
				
				local obj = event.other
				event.other.trans = transition.blink(event.other, { time=300, obj:setFillColor(255,0,0), onCancel = 
					function(obj) 
						obj.alpha = 1 
					end
				})

				timer.performWithDelay(300, killBlink)
			end
		elseif self.name == "playerHitbox" then
			table.insert(objectsToDie, event.other) --Kill the enemy
			--Remove HP
			
			if(health.getHP() > 0)then
				shakeamount = clamped( shakeamount + 10, 0, 20 ) --Create shake effect
				
				local effectName = health.remove(health.getCurSlide()) --Lose 1 hp when hit and return powerupname
				
				if(effectName == "rapidFire")then
					curRateOfFire = baseRateOfFire
					timer.cancel(fireTimer)
					fireTimer = nil
					fireTimer = timer.performWithDelay(1000/baseRateOfFire, fire, 0) --Shoot everysecond/shots per a second
					
					--change speeds of multishot here (need to check if nil, if not, then recreate them with curRateOfFire)
					if(fireTimerTop ~= nil)then
						timer.cancel(fireTimerTop)
						fireTimerTop = timer.performWithDelay(1000/curRateOfFire, useTopShot, 0) --Shoot everysecond/shots per a second
					end
					if(fireTimerBottom ~= nil)then
						timer.cancel(fireTimerBottom)
						fireTimerBottom = timer.performWithDelay(1000/curRateOfFire, useBottomShot, 0) --Shoot everysecond/shots
					end
				end 
				
				if(effectName == "multiShot")then
					timer.cancel(fireTimerTop)
					timer.cancel(fireTimerBottom)
					fireTimerTop = nil
					fireTimerBottom = nil
				end 
				
				
				if(effectName == "temp2")then
					audio.stop()
					audio.play()
					local survivalBackgroundMusic = audio.loadStream( "Audio/pause.mp3" )
					local survivalBackgroundMusicChannel = audio.play(survivalBackgroundMusic, { channel=1, loops=-1, fadein=725})
				end
				
				
				--need to end other effects here.
				
				
			else 
				--Player dies
				Quit()
			end	
		elseif self.name == "powerup" then --Obtain powerup
			if self.effect == "rapidFire" then
				rapidFire(self)
			elseif self.effect == "multiShot" then
				multishot(self)
			elseif self.effect == "timeWarp" then
				timeWarp(self)
			elseif self.effect == "secondWind" then
				secondWind(self)
			elseif self.effect == "temp1" then
				temp1F(self)
			elseif self.effect == "temp2" then
				temp2F(self)
			elseif self.effect == "temp3" then
				temp3F(self)
			end
			table.insert(objectsToDie, self) --Kill the powerup
		end
	end
	
	function rapidFire(self)
		timer.cancel(fireTimer)
		curRateOfFire = baseRateOfFire * 2

		if(fireTimerTop ~= nil)then
			timer.cancel(fireTimerTop)
			fireTimerTop = timer.performWithDelay(1000/curRateOfFire, useTopShot, 0) --Shoot everysecond/shots per a second
		end

		fireTimer = timer.performWithDelay(1000/curRateOfFire, fire, 0) --Shoot everysecond/shots per a second

		if(fireTimerBottom ~= nil)then
			timer.cancel(fireTimerBottom)
			fireTimerBottom = timer.performWithDelay(1000/curRateOfFire, useBottomShot, 0) --Shoot everysecond/shots
		end

		--local img = display.newImage("Art/PowerUps/rapidFire.png", 0, 0)
		--img.effect = self.effect
		--img.descriptor = self.descriptor
		--foreground:insert(img)
		health.add("Art/PowerUps/rapidFire.png", self.effect, self.descriptor)
	end

	function multishot(self)
		fireTimerTop = timer.performWithDelay(1000/curRateOfFire, useTopShot, 0) --Shoot everysecond/shots
		timer.cancel(fireTimer)
		fireTimer = timer.performWithDelay(1000/curRateOfFire, fire, 0) --Shoot everysecond/shots per a second
		fireTimerBottom = timer.performWithDelay(1000/curRateOfFire, useBottomShot, 0) --Shoot everysecond/shots
		--local img = display.newImage("Art/PowerUps/multiShot.png", 0, 0)
		--img.effect = self.effect
		--img.descriptor = self.descriptor
		--print(self.descriptor)
		--foreground:insert(img)
		health.add("Art/PowerUps/multiShot.png", self.effect, self.descriptor)
	end

	function timeWarp(self)
		--local img = display.newImage("Art/PowerUps/timeWarp.png", 200, 200)
		--img.effect = self.effect
		--img.descriptor = self.descriptor
		--foreground:insert(img)
		health.add("Art/PowerUps/timeWarp.png", self.effect, self.descriptor)
	end

	function secondWind(self)
		--local img = display.newImage("Art/PowerUps/secondWind.png", 200, 200)
		--img.effect = self.effect
		--img.descriptor = self.descriptor
		--foreground:insert(img)
		health.add("Art/PowerUps/secondWind.png", self.effect, self.descriptor)
	end
	
	function temp1F(self)
		--local img = display.newImage("Art/PowerUps/temp1.png", 200, 200)
		--img.effect = self.effect
		--img.descriptor = self.descri
		health.add("Art/PowerUps/temp1.png", self.effect, self.descriptor)
	end
	
	function temp2F(self)
		--local img = display.newImage("Art/PowerUps/temp2.png", 200, 200)
		--img.effect = self.effect
		--img.descriptor = self.descriptor
		--foreground:insert(img)
		audio.stop()
		audio.play()
		local survivalBackgroundMusic = audio.loadStream( "Audio/Death scene.mp3" )
		local survivalBackgroundMusicChannel = audio.play(survivalBackgroundMusic, { channel=1, loops=-1, fadein=725})
		health.add("Art/PowerUps/temp2.png", self.effect, self.descriptor)
	end
	
	function temp3F(self)
		--local img = display.newImage("Art/PowerUps/temp3.png", 200, 200)
		--img.effect = self.effect
		--img.descriptor = self.descriptor
		--foreground:insert(img)
		health.add("Art/PowerUps/temp3.png", self.effect, self.descriptor)
	end
	
--[[
	 function onCollision(self, event)
		if self.name == "bullet" and event.other.name == "enemy" then
			if self ~= nil then
				self.name = "dead"
				table.insert(objectsToDie, self) --kill the bullet
			end
			
			if event.other.name ~= nil then
				event.other.hp = event.other.hp - 1
				if(event.other.hp <= 0) then
					event.other.name = "dead"
					table.insert(objectsToDie, event.other) --kill the enemy
				else

			
			score = score + event.other.value
			scoreText.text = score
		elseif self.name == "playerHitbox" and event.other.name == "enemy" then
			print("Lose 1 HP")
			if event ~= nil then
				event.other.name = "dead"
				table.insert(objectsToDie, event.other) --kill the enemy
			end
			if(health.getHP() > 0)then
				local effectName = health.subtract() --Lose 1 hp when hit and return powerupname
				
				if(effectName == "rapidFire")then
					curRateOfFire = baseRateOfFire
					timer.cancel(fireTimer)
					fireTimer = nil
					fireTimer = timer.performWithDelay(1000/baseRateOfFire, fire, 0) --Shoot everysecond/shots per a second
					
					--change speeds of multishot here (need to check if nil, if not, then recreate them with curRateOfFire)
					if(fireTimerTop ~= nil)then
						timer.cancel(fireTimerTop)
						fireTimerTop = timer.performWithDelay(1000/curRateOfFire, useTopShot, 0) --Shoot everysecond/shots per a second
					end
					if(fireTimerBottom ~= nil)then
						timer.cancel(fireTimerBottom)
						fireTimerBottom = timer.performWithDelay(1000/curRateOfFire, useBottomShot, 0) --Shoot everysecond/shots
					end
				end 
				
				if(effectName == "multiShot")then
					timer.cancel(fireTimerTop)
					timer.cancel(fireTimerBottom)
					fireTimerTop = nil
					fireTimerBottom = nil
				end --need to end other effects here.
			else 
				--Player dies
				Quit()
			end
		elseif self.name == "powerup" and event.other.name == "player" then
			if health.getHP() < 3 then
				if self.effect == "rapidFire" then
					timer.cancel(fireTimer)
					curRateOfFire = baseRateOfFire * 2
					if(fireTimerTop ~= nil)then
						timer.cancel(fireTimerTop)
						fireTimerTop = timer.performWithDelay(1000/curRateOfFire, useTopShot, 0) --Shoot everysecond/shots per a second
					end
					fireTimer = timer.performWithDelay(1000/curRateOfFire, fire, 0) --Shoot everysecond/shots per a second
					if(fireTimerBottom ~= nil)then
						timer.cancel(fireTimerBottom)
						fireTimerBottom = timer.performWithDelay(1000/curRateOfFire, useBottomShot, 0) --Shoot everysecond/shots
					end
					local img = display.newImage("Art/PowerUps/rapidFire.png", 0, 0)
					img.effect = self.effect
					foreground:insert(img)
					health.add(img)
				end
				
				if self.effect == "timeWarp" then
					local img = display.newImage("Art/PowerUps/timeWarp.png", 0, 0)
					img.effect = self.effect
					foreground:insert(img)
					health.add(img)
				end
				
				if self.effect == "secondWind" then
					local img = display.newImage("Art/PowerUps/secondWind.png", 0, 0)
					img.effect = self.effect
					foreground:insert(img)
					health.add(img)
				end
				
				if self.effect == "multiShot" then
					fireTimerTop = timer.performWithDelay(1000/curRateOfFire, useTopShot, 0) --Shoot everysecond/shots
					timer.cancel(fireTimer)
					fireTimer = timer.performWithDelay(1000/curRateOfFire, fire, 0) --Shoot everysecond/shots per a second
					fireTimerBottom = timer.performWithDelay(1000/curRateOfFire, useBottomShot, 0) --Shoot everysecond/shots
					local img = display.newImage("Art/PowerUps/multiShot.png", 0, 0)
					img.effect = self.effect
					foreground:insert(img)
					health.add(img)
				end
			end
			if self ~= nil then
				self.name = "dead"
				table.insert(objectsToDie, self) --kill the powerup
			end
			
		end
	end--]]
	
	function useTopShot()
		fire(nil, 100)
	end
	
	function useBottomShot()
		fire(nil, -100)
	end
	
	local function locationGiver()
		local x
		local y
		local ox
		local oy
		y = math.random(display.contentHeight/36, display.contentHeight * .97)
		oy = math.random(display.contentHeight/36, display.contentHeight * .97)
		x = -50
		ox = 2000
		return x, y, ox, oy
	end

	local function newRound()
		zombiesSpawned = 0
		waveMax = waveMax + waveIncrementor
		currentRound = currentRound + 1
		waitingOnNewRound = false
		displayCurrentRound()
	end
	
	function has_value (tab, val)
		for index, value in ipairs (tab) do
			if value == val then
				return true
			end
		end
		return false
	end
	
	local function checkIfEquipped(r)
		local effect
		if (r == 1) then --Rapid fire
			if(has_value(health.getList(), "rapidFire")) then
				return true
			end
		elseif (r == 2) then
			if(has_value(health.getList(), "timeWarp")) then
				return true
			end
		elseif (r == 3) then
			if(has_value(health.getList(), "secondWind")) then
				return true
			end
		elseif (r == 4) then
			if(has_value(health.getList(), "multiShot")) then
				return true
			end
		elseif (r == 5) then
			if(has_value(health.getList(), "temp1")) then
				return true
			end
		elseif (r == 6) then
			if(has_value(health.getList(), "temp2")) then
				return true
			end
		elseif (r == 7) then
			if(has_value(health.getList(), "temp3")) then
				return true
			end
		end
		return false
	end
	
	local function getValidRandomNumber()
		local r = math.random(7)  -- 1 to 4
		if(checkIfEquipped(r)) then
			return getValidRandomNumber()
		end
		return r
	end
	
	local function getRandomItem()
		local r = getValidRandomNumber()
		local powerup
		if (r == 1) then --Rapid fire
			powerup = display.newImage("Art/PowerUps/rapidFire.png", 0, 0)
			powerup.effect = "rapidFire"
			powerup.descriptor = "Great"
		elseif (r == 2) then
			powerup = display.newImage("Art/PowerUps/timeWarp.png", 0, 0)
			powerup.effect = "timeWarp"
			powerup.descriptor = "Good"
		elseif (r == 3) then
			powerup = display.newImage("Art/PowerUps/secondWind.png", 0, 0)
			powerup.effect = "secondWind"
			powerup.descriptor = "Bad"
		elseif (r == 4) then
			powerup = display.newImage("Art/PowerUps/multiShot.png", 0, 0)
			powerup.effect = "multiShot"
			powerup.descriptor = "Great"
		elseif (r == 5) then
			powerup = display.newImage("Art/PowerUps/temp1.png", 0, 0)
			powerup.effect = "temp1"
			powerup.descriptor = "Neutral"
		elseif (r == 6) then
			powerup = display.newImage("Art/PowerUps/temp2.png", 0, 0)
			powerup.effect = "temp2"
			powerup.descriptor = "Neutral"
		elseif (r == 7) then
			powerup = display.newImage("Art/PowerUps/temp3.png", 0, 0)
			powerup.effect = "temp3"
			powerup.descriptor = "Neutral"
		end
		powerup.name = "powerup"
		physics.addBody(powerup, {filter=powerupCollisionFilterPhase2})
		powerup.collision = onCollision
		powerup:addEventListener("collision", powerup)
		nearBackground:insert(powerup)
		return powerup
	end

	local function spawnItem()
    	--local item = display.newImage(nearBackground,"Art/Main Menu/Other Buttons/Placeholder.png")
		
		local item = display.newSprite(mysteryBox())
		item:setSequence("random")
		item.name = "mystBox"
		item:play()
		
		
		local function powerupPop(event)
			if (event.phase == "began" ) then
				if(not paused) then
					local powerupPhase2 = getRandomItem()
					powerupPhase2.x = item.x
					powerupPhase2.y = item.y
					transition.to(powerupPhase2, {time=2000, x=display.contentWidth, y=item.y,
						onComplete = function(powerupPhase2)
							display.remove(powerupPhase2)
							powerupPhase2 = nil
						end
					})
					
					
					local function killItem()
						table.remove(ITimers, 1) --Remove timer entry
						table.insert(objectsToDie, item) --Kill the item
					end
						
					transition.cancel(item)
					item:setSequence("explode") --Death animation
					item:play()
					local deathTimer = timer.performWithDelay(300, killItem, 1)
					table.insert(ITimers, deathTimer)

					
					
					--table.insert(objectsToDie, item) -- Kill the powerup
				end
			end
		end
		
		item:addEventListener("touch", powerupPop)
	    item.x = math.random( 20, 570 )
   		item.y = 0
    	transition.to(item, {time=5000, x=item.x, y=display.contentHeight + 100, 
        	onComplete = function(item)
            	display.remove(item)
				item = nil
        	end
        })
		mystBoxes:insert(item)
	end

	
	
	--Spawning Enemies
	function spawnE()
		if(zombiesSpawned < waveMax)then --Wavemax
			local x, y, ox, oy = locationGiver()
			
			local allZombies = {"zombieA", "zombieB"}
			random = math.random(#allZombies)

			if random == 1 then
				sprite = display.newSprite(zombieA())
				sprite:setSequence("surf")
				sprite.name = "enemy"
				sprite.value = 1
				sprite.hp = math.floor((currentRound/10) + 1)
			elseif random ==  2 then
				sprite = display.newSprite(zombieB())
				sprite:setSequence("swim")
				sprite.name = "enemy"
				sprite.value = 2
				sprite.hp = math.floor((currentRound/10) + 2)
			end
			
			-- I moved this stuff out of the functions, since you would do this everytime for each spawning of an enemy. The other stuff before this line will vary
			sprite.x = x
			sprite.y = y	
			sprite:play()
			
			zombiesSpawned = zombiesSpawned + 1
			physics.addBody(sprite, {bounce = 0, density=1.0, filter=zombieCollisionFilter})
			enemies:insert(sprite)
			transition.to(sprite, { time = 8000, x = ox, y = oy,
			onComplete = function(sprite)
				if (sprite.parent ~= nil) then --if it is not already dead, kill it
					sprite.parent:remove(sprite) 
					sprite = nil
				end
			end
			})
		elseif(not waitingOnNewRound)then
			timer5 = timer.performWithDelay(6500, newRound)
			waitingOnNewRound = true
		end
	end

	function zombieA()
		zombieAImageSheet = graphics.newImageSheet ( "Art/Enemies/Zombie A/spriteSheet.png", zombieASheetInfo:getSheet() ) 
		explodeImageSheet = graphics.newImageSheet ( "Art/Misc/Explode/explode.png", explodeInfo:getSheet() ) 
		sequenceData = {
			{
				name="surf",                                  -- name of the animation
				sheet=zombieAImageSheet,                           -- the image sheet
				start=zombieASheetInfo:getFrameIndex("Zombie A 1"), -- first frame
				count=5,                                      -- number of frames
				time=1000,                                    -- speed
				loopCount=0                                   -- repeat
			},
			{ name="explode", sheet=explodeImageSheet, start=explodeInfo:getFrameIndex("1"), count=7, time=200, loopCount=1 } 
		}

		return zombieAImageSheet, sequenceData
	end
	
	function zombieB()
		zombieBImageSheet = graphics.newImageSheet ( "Art/Enemies/Zombie B/spriteSheet.png", zombieBSheetInfo:getSheet() ) 
		explodeImageSheet = graphics.newImageSheet ( "Art/Misc/Explode/explode.png", explodeInfo:getSheet() ) 
		sequenceData = {
			{
				name="swim",                                  -- name of the animation
				sheet=zombieBImageSheet,                           -- the image sheet
				start=zombieBSheetInfo:getFrameIndex("Zombie B 1"), -- first frame
				count=3,                                      -- number of frames
				time=500,                                     -- speed
				loopCount=0                                   -- repeat
			},
			{ name="explode", sheet=explodeImageSheet, start=explodeInfo:getFrameIndex("1"), count=7, time=200, loopCount=1 } 
		}

		return zombieBImageSheet, sequenceData
	end
	
	function mysteryBox()
		mystImageSheet = graphics.newImageSheet ( "Art/PowerUps/mystBox/mystBox.png", mystBoxInfo:getSheet() ) 
		explode2ImageSheet = graphics.newImageSheet ( "Art/Misc/Explode2/explode2.png", explode2Info:getSheet() ) 
		sequenceData = {
			{
				name="random",                                -- name of the animation
				sheet=mystImageSheet,                         -- the image sheet
				start=mystBoxInfo:getFrameIndex("1"),         -- first frame
				count=4,                                      -- number of frames
				time=800,                                     -- speed
				loopCount=0                                   -- repeat
			},
			{ name="explode", sheet=explode2ImageSheet, start=explode2Info:getFrameIndex("1"), count=8, time=300, loopCount=1 } 
		}

		return mystImageSheet, sequenceData
	end
		
	function checkShake()
		if settings.shakeeffect and shakeamount > 0 then
			local shake = math.random( shakeamount )
			sceneGroup.x = sceneGroup.originalX + math.random( -shake, shake )
			sceneGroup.y = sceneGroup.originalY + math.random( -shake, shake )
			shakeamount = shakeamount - 1
		end
	end

	function clamped(value, lowest, highest)
		return math.max(lowest, math.min(highest, value))
	end

	local function removeLoop()
		if (#objectsToDie > 0) then
			for i = 1, #objectsToDie do
				if (objectsToDie[i] ~= nil and objectsToDie[i].parent ~= nil) then
					objectsToDie[i].parent:remove(objectsToDie[i])
					objectsToDie[i] = nil
				end
			end
		end
	end
	
	local function removeBodyLoop()
		if (#objectsToRemoveBody > 0) then
			for i = 1, #objectsToRemoveBody do
				if (objectsToRemoveBody[i] ~= nil and objectsToRemoveBody[i].parent ~= nil) then
					physics.removeBody(objectsToRemoveBody[i])
					objectsToRemoveBody[i] = nil  --removes from group
				end
			end
		end
	end
	
		displayCurrentRound()

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
		-- Resize to match screen size based on a ratio with the actual background pixel dimensions
		background:scale( display.actualContentWidth/640, display.actualContentHeight/480 )
		background:play()
		
		hitboxArea.collision = onCollision
		hitboxArea:addEventListener("collision", hitboxArea)
		
		--Listeners
		quitButton:addEventListener("touch", Quit)
		pause:addEventListener("touch", Pause)
		resume:addEventListener("touch", Resume)
		playerArea:addEventListener("touch", playerMovement)
		Runtime:addEventListener("system", onSystemEvent)
		Runtime:addEventListener("enterFrame", removeLoop) --killing objects
		Runtime:addEventListener("enterFrame", removeBodyLoop) --removing physics bodies
		Runtime:addEventListener("enterFrame", checkShake) --shaking
		
		--insert visual objects into sceneGroup ORDER = VISUAL LAYERING
		sceneGroup:insert(background) --Bottom Layer aka background
		sceneGroup:insert(hitboxArea)
		sceneGroup:insert(playerArea)
		sceneGroup:insert(player)
		sceneGroup:insert(farBackground)
		sceneGroup:insert(enemies)
		sceneGroup:insert(projectiles)
		sceneGroup:insert(mystBoxes)
		sceneGroup:insert(nearBackground)
		sceneGroup:insert(foreground) --Top Layer
		
		sceneGroup:insert(objectsToDie) 
		

		--Start shooting timer
		fireTimer = timer.performWithDelay(1000/baseRateOfFire, fire, 0) --Shoot everysecond/shots per a second
		--Start spawning zombies
		--spawnTimer = timer.performWithDelay(1500, spawnEnemiesV1, 0)
		--spawnTimer2 = timer.performWithDelay(3000, spawnEnemiesV2, 0)
		spawnTimer = timer.performWithDelay(1000, spawnE, 0)
		--Start spawning powerups
		timer4 = timer.performWithDelay(4000, spawnItem, 0)
end


-- "scene:show()"
function scene:show( event )
	
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
		physics.start()
		
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
		audio.play()
		local survivalBackgroundMusic = audio.loadStream( "Audio/pause.mp3" )
		local survivalBackgroundMusicChannel = audio.play(survivalBackgroundMusic, { channel=1, loops=-1, fadein=725})
    end
end

-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
		audio.stop()
		--physics.stop()
		timer.cancel(fireTimer)
		if(fireTimerTop ~= nil) then
			timer.cancel(fireTimerTop)
		end
		if(fireTimerBottom ~= nil) then
			timer.cancel(fireTimerBottom)
		end
		--timer.cancel(spawnTimer)
		timer.cancel(spawnTimer)
		if(spawnTimer2 ~= nil) then
			timer.cancel(spawnTimer2)
		end
		timer.cancel(timer4)
		if(timer5 ~= nil) then
			timer.cancel(timer5)
		end
		Runtime:removeEventListener("enterFrame", removeLoop)
		Runtime:removeEventListener("system", onSystemEvent)
end

function onSystemEvent( event )
    if event.type == "applicationSuspend" then
        Quit()
    end
end


-- -------------------------------------------------------------------------------

-- Listener setup


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
--scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene