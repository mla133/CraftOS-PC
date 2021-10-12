rednet.open("right")
textutils.slowPrint("TurtleReceive Initiated.")
while true do
	local scrap, message = rednet.receive()
	if not turtle then
		if message == 200 then
			reply = "Forward"
		elseif message == 208 then
			reply = "Backward"
		elseif message == 203 then
			reply = "TurnLeft"
		elseif message == 205 then
			reply = "TurnRight"
		elseif message == 28 then
			reply = "Block Placed"
		else
			reply = "Unknown " .. message
		end
		print(reply)
	else
		print("Turtle...exiting")
	end
end

