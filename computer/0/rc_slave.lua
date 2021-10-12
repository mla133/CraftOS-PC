function RCslave()
	while true do
		local scrap, message = rednet.receive()
		if message == "TS Forward" then
			print("Forward")
			if turtle.detect() == true then
				turtle.dig()
				print("Digging")
			end
			turtle.forward()

		elseif message == "TS Backward" then
			print("Backward")
			turtle.back()
		elseif message == "TS TurnLeft" then
			print("TurnLeft")
			turtle.turnLeft()
		elseif message == "TS TurnRight" then
			print("TurnRight")
			turtle.turnRight()
		elseif message == "TS PlaceBlock" then
			if turtle.detect() == true then
				print("Block Present")
			else
				print("PlaceBlock")
				turtle.place()
			end
		end
	end
end

rednet.open("right")
textutils.slowPrint("TurtleReceive Initiated.")
RCslave()
