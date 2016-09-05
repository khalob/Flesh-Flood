local M = {}  -- Create the local module table (this will hold our functions and data)
M.HP = 0

--local group = display.newGroup()
M.one = nil
M.two = nil
M.three = nil
M.four = nil
M.five = nil
M.six = nil

M.list = {}
M.curSlide = 1
M.highlight = display.newImage("Art/PowerUps/highlight.png", (display.contentWidth / 2) - (display.contentWidth * (3/20)), display.contentHeight / 10)
M.highlight.isVisible = false


local highlightTimer = nil

function M.start(moveTime)
	if(moveTime == nil)then
		moveTime = 400
	end
	highlightTimer = timer.performWithDelay(moveTime, M.move, 0)
	
	for i=0, 6 do
		table.insert(M.list, "startingEffects")
	end
end

function M.pause()
	timer.pause(highlightTimer)
end

function M.resume()
	timer.resume(highlightTimer)
end

function M.stop()
	M.wipeHealth()
	timer.cancel(highlightTimer)
end

function M.getCurSlide()
	return M.curSlide
end

function M.getHP()
	return M.HP
end

function M.getList()
	return M.list
end

function M.add(imageLoc, effect, descriptor)
	local image = display.newImage(imageLoc, 500, 300)
	image.effect = effect
	image.descriptor = descriptor
	if(image.descriptor == "Great" or image.descriptor == "Good")then
		if(M.one == nil or M.two ~= nil and image.descriptor == "Great" and M.one.descriptor == "Good")then
			if(M.one ~= nil) then
				display.remove(M.one)
				M.one = nil
			end
			M.one = image
			M.one.effect = image.effect
			M.one.descriptor = image.descriptor
			table.remove(M.list, 1, index)
			table.insert(M.list, 1, image.effect)
		elseif(M.two == nil or M.one ~= nil and image.descriptor == "Great" and M.two.descriptor == "Good") then
			if(M.two ~= nil)then
				display.remove(M.two)
				M.two = nil
			end
			M.two = image
			M.two.effect = image.effect
			M.two.descriptor = image.descriptor
			table.remove(M.list, 2, index)
			table.insert(M.list, 2, image.effect)
		end
	elseif (image.descriptor == "Neutral")then
		if(M.three == nil)then
			if(M.three ~= nil)then
				display.remove(M.three)
				M.three = nil
			end
			M.three = image
			M.three.effect = image.effect
			M.three.descriptor = image.descriptor
			table.remove(M.list, 3, index)
			table.insert(M.list, 3, image.effect)
		elseif(M.four == nil) then
			if(M.four ~= nil)then
				display.remove(M.four)
				M.four = nil
			end
			M.four = image
			M.four.effect = image.effect
			M.four.descriptor = image.descriptor
			table.remove(M.list, 4, index)
			table.insert(M.list, 4, image.effect)
		end
	elseif (image.descriptor == "Bad" or image.descriptor == "Terrible")then
		if(M.five == nil or M.six ~= nil and image.descriptor == "Bad" and M.five.descriptor == "Terrible")then
			if(M.five ~= nil)then
				display.remove(M.five)
				M.five = nil
			end
			M.five = image
			M.five.effect = image.effect
			M.five.descriptor = image.descriptor
			table.remove(M.list, 5, index)
			table.insert(M.list, 5, image.effect)
		elseif(M.six == nil or M.five ~= nil and image.descriptor == "Bad" and M.six.descriptor == "Terrible") then
			if(M.six ~= nil)then
				display.remove(M.six)
				M.six = nil
			end
			M.six = image
			M.six.effect = image.effect
			M.six.descriptor = image.descriptor
			table.remove(M.list, 6, index)
			table.insert(M.list, 6, image.effect)
		end
	end
	updateDisplay()
	if(image.x == 500 and image.y == 300)then
		display.remove(image)
		image = nil
	end
end

function updateDisplay()
	local health = 0
	if(M.one ~= nil)then
		M.one.x = (display.contentWidth / 2) - (display.contentWidth * (3/20)) --Left Most Image
		M.one.y = display.contentHeight / 10	
		health = health + 1
	end
	if(M.two ~= nil) then
		M.two.x = (display.contentWidth / 2) - (display.contentWidth * (2/20)) 
		M.two.y = display.contentHeight / 10
		health = health + 1
	end
	if(M.three ~= nil) then
		M.three.x = (display.contentWidth / 2) - (display.contentWidth * (1/40)) 
		M.three.y = display.contentHeight / 10	
		health = health + 1
	end
	if(M.four ~= nil) then
		M.four.x = (display.contentWidth / 2) + (display.contentWidth * (1/40)) 
		M.four.y = display.contentHeight / 10
		health = health + 1
	end
	if(M.five ~= nil) then
		M.five.x = (display.contentWidth / 2) + (display.contentWidth * (2/20)) 
		M.five.y = display.contentHeight / 10
		health = health + 1
	end
	if(M.six ~= nil) then
		M.six.x = (display.contentWidth / 2) + (display.contentWidth * (3/20)) 
		M.six.y = display.contentHeight / 10	
		health = health + 1
	end
	M.HP = health
end

function M.remove(index)
	if (M.HP > 0) then
		local effectName = "no effect name given"
		if (index == 1 and M.one ~= nil) then
			effectName = M.one.effect
			display.remove(M.one)
			M.one = nil
		elseif (index == 2 and M.two ~= nil) then
			effectName = M.two.effect
			display.remove(M.two)
			M.two = nil
		elseif (index == 3 and M.three ~= nil) then
			effectName = M.three.effect
			display.remove(M.three)
			M.three = nil
		elseif (index == 4 and M.four ~= nil) then
			effectName = M.four.effect
			display.remove(M.four)
			M.four = nil
		elseif (index == 5 and M.five ~= nil) then
			effectName = M.five.effect
			display.remove(M.five)
			M.five = nil
		elseif (index == 6 and M.six ~= nil) then
			effectName = M.six.effect
			display.remove(M.six)
			M.six = nil
		end
		updateDisplay()
		table.remove(M.list, index)
		table.insert(M.list, index, "replacedEffect")
		M.move()
		return effectName
	end
end

function M.wipeHealth()
	display.remove(M.one)
	display.remove(M.two)
	display.remove(M.three)
	display.remove(M.four)
	display.remove(M.five)
	display.remove(M.six)
	M.one = nil
	M.two = nil
	M.three = nil
	M.four = nil
	M.five = nil
	M.six = nil
	M.HP = 0
	M.highlight.isVisible = false
	for i=0, #M.list do
		table.remove(M.list, 1)
	end
end

local function getNextAvailableHP(num, incrementor)
	if (incrementor == 1 and M.one ~= nil) then
		M.curSlide = incrementor
		return 
	elseif (incrementor == 2 and M.two ~= nil) then
		M.curSlide = incrementor
		return 
	elseif (incrementor == 3 and M.three ~= nil) then
		M.curSlide = incrementor
		return
	elseif (incrementor == 4 and M.four ~= nil) then
		M.curSlide = incrementor
		return 
	elseif (incrementor == 5 and M.five ~= nil) then
		M.curSlide = incrementor
		return
	elseif (incrementor == 6 and M.six ~= nil) then
		M.curSlide = incrementor
		return 
	else
		if(incrementor<6)then
			incrementor = incrementor + 1
		else
			incrementor = 1
		end
		if(incrementor == num) then
			return false
		end
		getNextAvailableHP(num, incrementor)
	end
end

function M.move()
	if(M.HP>0)then
		local temp =0
		if(M.curSlide<6)then
			temp = M.curSlide + 1
		else
			temp = 1
		end
		if(getNextAvailableHP(M.curSlide, temp) == false) then
			return
		end
		M.highlight.isVisible = true
		if (M.curSlide == 2) then
			M.highlight.x = (display.contentWidth / 2) - (display.contentWidth * (2/20)) 
		elseif (M.curSlide-1 == 2) then
			M.highlight.x = (display.contentWidth / 2) - (display.contentWidth * (1/40)) 
		elseif (M.curSlide-1 == 3) then
			M.highlight.x = (display.contentWidth / 2) + (display.contentWidth * (1/40)) 
		elseif (M.curSlide-1 == 4) then
			M.highlight.x = (display.contentWidth / 2) + (display.contentWidth * (2/20)) 
		elseif (M.curSlide-1 == 5) then
			M.highlight.x = (display.contentWidth / 2) + (display.contentWidth * (3/20)) 
		elseif (M.curSlide == 1) then
			M.highlight.x = (display.contentWidth / 2) - (display.contentWidth * (3/20)) --Left Most Image
			M.curSlide = 1 
		end
	else
		M.highlight.isVisible = false
	end
end

return M