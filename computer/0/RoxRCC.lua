local function RoxMaster()
  local run = 1
  while run == 1 do
    local sEvent, param = os.pullEvent("key")
    if sEvent == "key" then
      if param == 17 then
        rednet.broadcast("MoveForward")
      elseif param == 30 then
        rednet.broadcast("MoveLeft")
      elseif param == 31 then
        rednet.broadcast("MoveBack")
      elseif param == 32 then
        rednet.broadcast("MoveRight")
      elseif param == 18 then
        rednet.broadcast("MoveUp")
      elseif param == 16 then
        rednet.broadcast("MoveDown")
      elseif param == 33 then
        rednet.broadcast("DigForward")
      elseif param == 19 then
        rednet.broadcast("DigUp")
      elseif param == 46 then
        rednet.broadcast("DigDown")
      elseif param == 45 then
        rednet.broadcast("EndTurtle")
        textutils.slowPrint("Ended program on the")
        textutils.slowPrint("current Turtle and closed")
        textutils.slowPrint("it\'s Rednet connection.")
        print("--------------------------")
      elseif param == 44 then
        rednet.broadcast("EndBoth")
        run = 0
        rednet.close("back")
        textutils.slowPrint("Ended program on both")
        textutils.slowPrint("machines.")
        sleep(0.75)
        textutils.slowPrint("Closed rednet connection.")
      end
    end
  end
end
rednet.open("back")
term.clear()
textutils.slowPrint("Rox Remote Control Console \(RoxRCC\) sending signal.")
print("--------------------------")
textutils.slowPrint("WASD to move.")
textutils.slowPrint("E to rise.")
textutils.slowPrint("Q to fall.")
textutils.slowPrint("F to dig forward.")
textutils.slowPrint("R to dig up.")
textutils.slowPrint("C to dig down.")
textutils.slowPrint("X to stop current Turtle.")
textutils.slowPrint("Z to exit.")
print("--------------------------")
RoxMaster()