--[[ Function Module program
--	provides utility functions]]

function fuel()
	if turtle.getFuelLevel() < 10 then
		print('Refueling...')
		turtle.refuel()
	end
end

function selectItem(name)
	--check all inventory slots
	local item

	for slot = 1,16 do
		item = turtle.getItemDetail(slot)
		if item ~=nil and item['name'] == name then
			turtle.select(slot)
			return true
		end
	end
	return false
end

function selectEmptySlot()
	-- loop through all slots
	for slot = 1,16 do
		if turtle.getItemCount(slot) == 0 then
			turtle.select(slot)
			return true
		end
	end
	return false
end

function countInventory()
	local total = 0
	
	for slot = 1,16 do
		total = total + turtle.getItemCount(slot)
	end
	return total
end

function selectAndPlaceDown()
	for slot = 1,16 do
		if turtle.getItemCount(slot) > 0 then
			turtle.select(slot)
			turtle.placeDown()
			return
		end
	end
end


function buildWall(length, height)
	if hare.countInventory() < length * height then
		return false --not enough blocks
	end

	turtle.up()
	
	local movingForward = true

	for currentHeight =1, height do
		for currentLength = 1,length do
			selectAndPlaceDown() -- place a block
			if movingForward and currentLength ~= length then
				turtle.forward()
			elseif not movingForward and currentLength ~= length then
				turtle.back()
			end
		end
		if currentHeight ~= height then
			turtle.up()
		end
		movingForward = not movingForward
	end

	-- done building wall; move to end position
	if movingForward then
		--turtle is near starting position
		for currentLength = 1, length do
			turtle.forward()
		end
	else
		--turtle is near end position
		turtle.forward()
	end

	-- move down to the ground
	for currentHeight = 1, height do
		turtle.down()
	end

	return true
end	

function buildRoom(length, width, height)
	if hare.countInventory() < (((length-1)*height*2) + ((width-1)*height*2)) then
		return false -- not enough blocks
	end

	-- build the four walls
	buildWall(length-1, height)
	turtle.turnRight()
	buildWall(width-1, height)
	turtle.turnRight()
	buildWall(length-1, height)
	turtle.turnRight()
	buildWall(width-1, height)
	turtle.turnRight()

	return true
end


function sweepField(length, width, sweepFunc)
	local turnRightNext = true

	for x = 1, width do
		for y = 1, length do
			sweepFunc()

			-- dont move forward on the last row
			if y ~= length then
				turtle.forward()
			end
		end

		-- don't turn on the last column
		if x ~= width then
			--turn to the next column
			if turnRightNext then
				turtle.turnRight()
				turtle.forward()
				turtle.turnRight()
			else
				turtle.turnLeft()
				turtle.forward()
				turtle.turnLeft()
			end

			turnRightNext = not turnRightNext
		end
	end

	-- move back to the start position
	if width % 2 == 0 then
		turtle.turnRight()
	else
		for y =1, length-1 do
			turtle.back()
		end
		turtle.turnLeft()
	end		
	
	for x = 1, width -1 do
		turtle.forward()
	end
	turtle.turnRight()

	return true
end


function buildFloor(length,width)
	if countInventory() < length * width then
		return false -- not enough blocks
	end

	turtle.up()
	sweepField(length, width, selectAndPlaceDown)
end

function quarry(length,width,depth)
	local dig_depth = 0

	while dig_depth < depth do
		sweepField(length.width,turtle.digDown)
		turtle.down()
		dig_depth = dig_depth + 1
	end
end
