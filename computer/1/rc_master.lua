function RCmaster()
	while true do
		local sEvent, param = os.pullEvent("key")
		
		if(sEvent == "key") then
			if(param == 200) then
				rednet.broadcast("TS Forward")
			elseif (param == 208) then
				rednet.broadcast("TS Backward")
			elseif (param == 203) then
				rednet.broadcast("TS TurnLeft")
			elseif (param == 205) then
				rednet.broadcast("TS TurnRight")
			elseif (param == 28) then
				rednet.broadcast("TS PlaceBlock")
			end
		end
	end
end

print("What side is your modem on?")
local modem = read()
rednet.open(modem)
term.clear()
textutils.slowPrint("TurtleControl Initiated")
print("Use arrow keys to move and Enter to place blocks.")
RCMaster()
