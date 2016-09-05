local M = {}  -- Create the local module table (this will hold our functions and data)
M.HP = 0

--local group = display.newGroup()
M.one = nil
M.two = nil
M.three = nil
M.list = {}

function M.getHP()
	return M.HP
end

function M.getList()
	return M.list
end

function M.add(image)
	if (M.HP < 3) then
	print(image.effect)
	table.insert(M.list, image.effect)
		if (M.HP == 2) then
			M.one = image
			M.one.effect = image.effect
			M.one.x = (display.contentWidth / 2) - (display.contentWidth * (1/10)) --Left Image
			M.one.y = display.contentHeight / 10	
		elseif (M.HP == 1) then
			M.two = image
			M.two.effect = image.effect
			M.two.x = display.contentCenterX  --Middle Image
			M.two.y = display.contentHeight / 10
		elseif (M.HP == 0) then
			M.three = image
			M.three.effect = image.effect
			M.three.x = (display.contentWidth / 2) + (display.contentWidth * (1/10)) --Right Image
			M.three.y = display.contentHeight / 10
		end
		M.HP = M.HP + 1
	else
		print("You have too many power ups already!")
	end
end

function M.subtract()
	if (M.HP > 0) then
	local index
	local effectName = M.three.effect
		if (M.HP == 1) then
			display.remove(M.three)
			M.three = nil
			M.two = nil
			M.one = nil
		elseif (M.HP == 2) then
			display.remove(M.three)
			M.three = nil
			M.three = M.two
			M.three.effect = M.two.effect
			M.three.x = (display.contentWidth / 2) + (display.contentWidth * (1/10)) --Right Image
			M.two = nil
			display.remove(M.two)
		elseif (M.HP == 3) then
			display.remove(M.three)
			M.three = nil
			M.three = M.two
			M.three.effect = M.two.effect
			M.three.x = (display.contentWidth / 2) + (display.contentWidth * (1/10)) --Right Image
			M.two = M.one
			M.two.x = display.contentCenterX  --Middle Image
			M.one = nil
			display.remove(M.one)
		end
		M.HP = M.HP - 1
		print("Removing: " .. table.remove(M.list, 1))
		return effectName
	end
end

return M