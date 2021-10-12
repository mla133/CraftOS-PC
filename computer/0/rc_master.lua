print("What side is your modem on?")
local modem = read()
rednet.open(modem)
term.clear()
textutils.slowPrint("TurtleControl Initiated")
print("Use arrow keys to move and Enter to place blocks.")

while true do
	local sEvent, param = os.pullEvent("key")
	if(sEvent == "key") then
		rednet.broadcast(param)
	end
end

