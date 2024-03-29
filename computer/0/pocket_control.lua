--[[
HPWebcamAble presents...
ControlMe

--=== Description ===--
This program lets you control a turtle from a pocket computer!

This version of the program is for the POCKET COMPUTER
Get the Turtle version here: pastebin.com/zjn3E5LS


--=== Installation ===--
Pastebin Code: mTGccYbM

To download a file from pastebin, run this command in a computer:
pastebin get <code> <file name>


--=== Update History ===--
The pastebin will always have the most recent version

|1.0|
-Release
]]

--=== Variables ===--
local args = {...}
local protocalName = "controlme"
local turtleID
local w,h = term.getSize()
local tools = {}
local knownTools = {
  ["modem"] = {text = "Modem", upAndDown = false},
  ["minecraft:diamond_pickaxe"] = {text = "Mine", upAndDown = true, action = "turtle.dig"},
  ["minecraft:diamond_sword"] = {text = "Attack", upAndDown = true, action = "turtle.attack"},
  ["minecraft:diamond_hoe"] = {text = "Hoe", upAndDown = true, action = "turtle.dig"},
  ["minecraft:diamond_axe"] = {text = "Chop", upAndDown = true, action = "turtle.dig"},
  ["minecraft:diamond_shovel"] = {text = "Dig", upAndDown = true, action = "turtle.dig"}
}
local turtleImage = [[ffffffffff
f77777777f
f77ffff77f
f77777777f
f88888888f
f88888888f
ffffffffff
]]
local inventoryImage = [[77777777777777777
78887888788878887
78887888788878887
77777777777777777
78887888788878887
78887888788878887
77777777777777777
78887888788878887
78887888788878887
77777777777777777
78887888788878887
78887888788878887
77777777777777777
]]

-- Load Images
do
  local f = fs.open("temp","w") f.write(turtleImage) f.close()
  turtleImage = paintutils.loadImage("temp")
  f = fs.open("temp","w") f.write(inventoryImage) f.close()
  inventoryImage = paintutils.loadImage("temp") fs.delete("temp")
end

--=== Functions ===--
local function color(text,back)
  local temp = text and term.setTextColor(text) or nil
  temp = back and term.setBackgroundColor(back) or nil
end

local function printC(text,y)
  if type(text) ~= "string" or type(y) ~= "number" then error("expected string,number, got "..type(text)..","..type(y),2) end
  local lenght = #text
  local start = math.floor((w-lenght)/2)+1
  term.setCursorPos(start,y)
  term.write(text)
  return start,start+lenght
end

-- These functions are from my Screen API
-- http://pastebin.com/4j4mJsWw
local default = {
  object = {
    text = nil,
    name = "default",
    minX = 1,minY = 1,
    maxX = 7,maxY = 3,
    states = {
      on = {text = colors.white, back = colors.lime},
      off = {text = colors.white, back = colors.red}
    },
    clickable = false,
    visible = true,
    state = "off",
    action = nil
  },
  clickArea = {
    name = "default", 
    minX = 1,minY = 1,
    maxX = 5,maxY = 3,
    clickable = true,
    action = nil
  }
}

local function fillTable(toFill,fillWith) --Used by the API
  if toFill == nil then toFill = {} end
  for a,b in pairs(fillWith) do
    if type(b) == "table" then
      toFill[a] = fillTable(toFill[a],b)
    else
      toFill[a] = toFill[a]==nil and b or toFill[a]
    end
  end
  return toFill
end

local function countIndexes(tbl) --Also used by API
  local total = 0
  for a,b in pairs(tbl) do total = total+1 end
  return total
end

local function assert(check,err,lvl)
  lvl = lvl or 2
  if not check then error(err,lvl+1) end
  return check
end

function new(nBackground)
  local api = {}
  local objects = {}
  local clickAreas = {}
  local background = nBackground
  
  function api.checkPos(x,y)
    x,y = tonumber(x),tonumber(y)
    assert(x and y,"expected number,number")
    for name,data in pairs(clickAreas) do
      if x >= data.minX and x <= data.maxX and y >= data.minY and y <= data.maxY and data.clickable then
        if type(data.action)=="function" then return true,true,data.action()
        else return true,false,"click_area",name end
      end
    end
    for name,data in pairs(objects) do
      if data.clickable and data.visible and x >= data.minX and x <= data.maxX and y >= data.minY and y <= data.maxY then
        if type(data.action)=="function" then return true,true,data.action()
        else return true,false,"object",name end
      end
    end
    return false
  end
  
  function api.handleEvents(bUseRaw)
    local pull = bUseRaw and os.pullEventRaw or os.pullEvent
    local event = {pull()}
    if event[1] == "mouse_click" then
      local wasElement,hadFunction,elementType,name = api.checkPos(event[3],event[4])
      if wasElement then
        if not hadFunction then
          return elementType,name,event[2]
        else return nil
        end
      end
    end
    return unpack(event)
  end
  
  function api.setDefaultObject(newDefaultObject)
    assert(type(newDefaultObject)=="table","expected table, got "..type(newDefaultObject))
    default.object = fillTable(newDefaultObject,default.object)
  end

  function api.setDefaultClickArea(newDefaultClickArea)
    assert(type(newDefaultClickArea)=="table","expected table, got "..type(newDefaultClickArea))
    default.clickArea = fillTable(newDefaultClickArea,default.clickArea)
  end
  
  function api.draw()
    if background then term.setBackgroundColor(background) term.clear() end
    for name,data in pairs(objects) do
      api.drawObject(name)
    end
  end
  
  function api.addClickArea(clickAreaInfo)
    assert(type(clickAreaInfo)=="table","expected table, got "..type(clickAreaInfo))
    fillTable(clickAreaInfo,default.clickArea)
    assert(clickAreas[clickAreaInfo.name]==nil,"an object with the name '"..clickAreaInfo.name.."' already exists")
    clickAreas[clickAreaInfo.name] = clickAreaInfo
  end
  
  function api.toggleClickArea(name)
    assert(clickAreas[name]~=nil,"Click Area '"..name.."' doesn't exist")
    clickAreas[name].clickable = not clickAreas[name].clickable
    return clickAreas[name].clickable
  end
  
  function api.getClickArea(name)
    assert(clickAreas[name]~=nil,"Click Area '"..name.."' doesn't exist")
    return clickAreas[name]
  end
  
  function api.addObject(objectInfo)
    assert(type(objectInfo)=="table","expected table, got "..type(objectInfo))
    objectInfo = fillTable(objectInfo,default.object)
    assert(objects[objectInfo.name]==nil,"an object with the name '"..objectInfo.name.."' already exists")
    objects[objectInfo.name] = objectInfo
  end
  
  function api.drawObject(name)
    assert(objects[name]~=nil,"Object '"..name.."' doesn't exsist")
    local objData = objects[name]
    if objData.visible == false then return end
    assert(objData.states~=nil,"Object '"..name.."' has no states!")
    assert(objData.states[objData.state],"Object '"..name.."' doesn't have state '"..objData.state.."'")
    term.setBackgroundColor(objData.states[objData.state].back)
    term.setTextColor(objData.states[objData.state].text)
    for i = 0, objData.maxY-objData.minY do
      term.setCursorPos(objData.minX,objData.minY+i)
      term.write(string.rep(" ",objData.maxX-objData.minX+1))
    end
    if objData.text then
      local xPos = objData.minX+math.floor(((objData.maxX-objData.minX+1)-#objData.text)/2)
      local yPos = objData.minY+(objData.maxY-objData.minY)/2
      term.setCursorPos(xPos,yPos) term.write(objData.text)
    end  
  end
  
  function api.toggleObjectState(name) -- Only works if an object has two states
    assert(objects[name]~=nil,"Object '"..name.."' doesn't exist")
    assert(countIndexes(objects[name].states)==2,"Object '"..name.."' can't be toggled, it doesn't have two states")
    curState = objects[name].state
    for a,b in pairs(objects[name].states) do
      if a ~= curState then
        objects[name].state = a
      end
    end
    return objects[name].state
  end

  function api.setObjectState(name,state)
    assert(objects[name] ~= nil,"Object '"..name.."' doesn't exist")
    assert(objects[name].states[state],"Object '"..name.."' doesn't have state '"..state.."'")
    objects[name].state = state
  end
  
  function api.getObject(name)
    assert(objects[name] ~= nil,"Object '"..name.."' doesn't exist")
    return objects[name]
  end
  
  function api.toggleObjectVisible(name)
    assert(objects[name] ~= nil,"Object '"..name.."' doesn't exist")
    objects[name].visible = not objects[name].visible
    return objects[name].visible
  end
  
  function api.toggleObjectClickable(name)
    assert(objects[name] ~= nil,"Object '"..name.."' doesn't exist")
    objects[name].clickable = not objects[name].clickable
    return objects[name].clickable
  end
  
  return api
end
-- End Screen API

local function checkMessage(event,skipTableCheck,skipIDCheck)
  return event[4] == protocalName and (skipTableCheck or type(event[3]) == "table") and (skipIDCheck or event[2] == turtleID)
end

local function message(message)
  rednet.send(turtleID,message,protocalName)
end

local function broadcast(message)
  rednet.broadcast(message,protocalName)
end

local function execute(func,waitTime)
  message({action="execute",func=func})
  local timer = waitTime and os.startTimer(waitTime) or "done" 
  local completed = false
  while true do
    local event = {os.pullEvent()}
    if event[1] == "rednet_message" and checkMessage(event) and event[3].action == "completed" then
      if timer == "done" then return event[3].result
      else completed = true end
    elseif event[1] == "timer" and timer == event[2] then
      if completed then break 
      else timer = "done" end
    end
  end
end

local function getModem()
  for a,b in pairs(rs.getSides()) do
    if peripheral.getType(b) == "modem" and peripheral.call(b,"isWireless") then
      return b
    end
  end
end

local function waitForMessage(skipTableCheck,skipIDCheck)
  while true do
    local event = {os.pullEvent("rednet_message")}
    if checkMessage(event,skipTableCheck,skipIDCheck) then
      return event[3]
    end
  end
end

-- Create the screen
local mainScreen = new()

local function action(buttonName,func,waitTime)
  mainScreen.getObject(buttonName).state = "active" mainScreen.drawObject(buttonName)
  execute(func,waitTime or 0.5)
  mainScreen.getObject(buttonName).state = "on" mainScreen.drawObject(buttonName)
end

local function forward()
  action("forward","turtle.forward()")
end

local function turnLeft()
  action("turnLeft","turtle.turnLeft()")
end

local function turnRight()
  action("turnRight","turtle.turnRight()")
end

local function back()
  action("back","turtle.back()")
end

local function up()
  action("up","turtle.up()")
end

local function down()
  action("down","turtle.down()")
end

local drawMainScreen

local function options()
  -- Silly animition that I love so please don't question it
  for i = 0, 12 do
    color(colors.white,colors.blue) term.clear()
    paintutils.drawImage(turtleImage,9,7-(i/2))
    color(colors.white,colors.green) term.setCursorPos(1,h-i) term.clearLine() printC("Options",h-i)
    color(colors.white,colors.brown)
    for a = 0, i-1 do
      term.setCursorPos(1,h-a) term.clearLine()
    end
    sleep(0.1)
  end
  
  color(colors.black,colors.lightGray)
  printC("              ",10)
  printC("  Disconnect  ",11)
  printC("   and Exit   ",12)
  printC("              ",13)
  printC("              ",15)
  printC("     Back     ",16)
  printC("              ",17)
  
  while true do
    local event = {os.pullEvent("mouse_click")}
    if event[4] == 10 or event[4] == 11 or event[4] == 12 or event[4] == 1 then
      error()
    elseif event[4] == 16 or event[4] == 15 or event[4] == 17 then
      break
    end
  end
  
  for i = 12, 0, -1 do
    color(colors.white,colors.blue) term.clear()
    paintutils.drawImage(turtleImage,9,7-(i/2))
    color(colors.white,colors.green) term.setCursorPos(1,h-i) term.clearLine() printC("Options",h-i)
    color(colors.white,colors.brown)
    for a = 0, i-1 do
      term.setCursorPos(1,h-a) term.clearLine()
    end
    sleep(0.1)
  end
  drawMainScreen()
end

-- Add buttons
--mainScreen.addObject({name="inventory", minX=10, maxY=12, state="default", maxX=17, clickable=false, visible=true, states={default={text=1,back=256,},}, minY=11, text="View Inv", })
mainScreen.addObject({name="turnRight", minX=20, maxY=18, state="on", maxX=25, clickable=true, visible=true, states={off={text=1,back=256,},on={text=32768,back=1,},active={text=1,back=32,},}, minY=16, text="Turn R", action=turnRight})
mainScreen.addObject({name="actionLeft", minX=20, maxY=11, state="on", maxX=26, clickable=false, visible=true, states={off={text=1,back=256,},on={text=32768,back=1,},active={text=1,back=32,},}, text="No Tool", minY=9, })
mainScreen.addObject({name="turnLeft", minX=2, maxY=18, state="on", maxX=7, clickable=true, visible=true, states={off={text=1,back=256,},on={text=32768,back=1,},active={text=1,back=32,},}, minY=16, text="Turn L", action=turnLeft})
mainScreen.addObject({name="actionRightDown", minX=3, maxY=13, state="on", maxX=7, clickable=false, visible=true, states={off={text=1,back=256,},on={text=32768,back=1,},active={text=1,back=32,},}, minY=13, text="v", })
mainScreen.addObject({name="actionRight", minX=1, maxY=11, state="on", maxX=7, clickable=false, visible=true, states={off={text=1,back=256,},on={text=32768,back=1,},active={text=1,back=32,},}, minY=9, text="No Tool", })
mainScreen.addObject({name="back", minX=9, maxY=17, state="on", maxX=18, clickable=true, visible=true, states={off={text=1,back=256,},on={text=32768,back=1,},active={text=1,back=32,},}, minY=15, text="Backward", action=back})
mainScreen.addObject({minY=20, minX=1, state="default", maxY=20, maxX=26, clickable=true, visible=true, states={default={text=1,back=8192,},}, name="options", text="Options", action = options})
mainScreen.addObject({name="actionRightUp", minX=3, maxY=7, state="on", maxX=7, clickable=true, visible=true, states={off={text=1,back=256,},on={text=32768,back=1,},active={text=1,back=32,},}, minY=7, text="^", })
mainScreen.addObject({name="actionLeftDown", minX=20, maxY=13, state="on", maxX=24, clickable=false, visible=true, states={off={text=1,back=256,},on={text=32768,back=1,},active={text=1,back=32,},}, text="v", minY=13, })
mainScreen.addObject({name="down", minX=20, maxY=4, state="on", maxX=25, clickable=true, visible=true, states={off={text=1,back=256,},on={text=32768,back=1,},active={text=1,back=32,},}, text="Down", minY=2, action=down})
mainScreen.addObject({name="up", minX=2, maxY=4, state="on", maxX=7, clickable=true, visible=true, states={off={text=1,back=256,},on={text=32768,back=1,},active={text=1,back=32,},}, text="Up", minY=2, action=up})
mainScreen.addObject({name="actionLeftUp", minX=20, maxY=7, state="on", maxX=24, clickable=false, visible=true, states={off={text=1,back=256,},on={text=32768,back=1,},active={text=1,back=32,},}, text="^", minY=7, })
mainScreen.addObject({name="forward", minX=9, maxY=5, state="on", maxX=18, clickable=true, visible=true, states={off={text=1,back=256,},on={text=32768,back=1,},active={text=1,back=32,},}, minY=3, text="Forward", action=forward})
-- Function to draw the screen
drawMainScreen = function()
  color(nil,colors.blue) term.clear()
  paintutils.drawImage(turtleImage,9,7)
  mainScreen.draw()
end

local function getFreeSlot()
  for i = 1, 16 do
    local result = execute("turtle.getItemCount("..i..")")
    if result == 0 then
      return i
    end
  end
  return false
end

local function showToolName(name,side)
  local obj = mainScreen.getObject("action"..side)
  local up = mainScreen.getObject("action"..side.."Up")
  local down = mainScreen.getObject("action"..side.."Down")
  if knownTools[name] then
    obj.text = knownTools[name].text
    obj.state = "on"
    obj.clickable = true
    if knownTools[name].action then
      obj.action = function() action("action"..side,knownTools[ tools.left ].action.."()",0.2) end
    end
    mainScreen.drawObject("action"..side)
    if knownTools[name].upAndDown then
      up.state = "on"
      up.clickable = true
      up.action = function() action("action"..side.."Up",knownTools[name].action.."Up()",0.2) end
      down.state = "on"
      down.clickable = true
      down.action = function() action("action"..side.."Down",knownTools[name].action.."Down()",0.2) end
      mainScreen.drawObject("action"..side.."Up")
      mainScreen.drawObject("action"..side.."Down")
    else
      up.state = "off"
      up.clickable = false
      down.state = "off"
      down.clickable = false
      mainScreen.drawObject("action"..side.."Up")
      mainScreen.drawObject("action"..side.."Down")
    end
  else
    obj.text = name=="none" and "No Tool"  or "?"
    obj.state ="off"
    obj.clickable = false
    mainScreen.drawObject("action"..side)
    up.state = "off"
    up.clickable = false
    down.state = "off"
    down.clickable = false
    mainScreen.drawObject("action"..side.."Up")
    mainScreen.drawObject("action"..side.."Down")
  end
end

local function getLeftTool()
  message({action="getLeftTool"})
  while true do
    local msg = waitForMessage()
    if msg.action == "getLeftTool" then
      tools.left = msg.result
      return msg.result
    end
  end
end

local function getRightTool()
  message({action="getRightTool"})
  while true do
    local msg = waitForMessage()
    if msg.action == "getRightTool" then
      tools.right = msg.result
      return msg.result
    end
  end
end

local function detectTools()
  showToolName(getRightTool(),"Right")
  showToolName(getLeftTool(),"Left")
end

--=== Program ===--
if not pocket then
  printError("This program requires a pocket computer!")
  return 
else if args[1] == "help" then
  print("ControlMe")
  print("By HPWebcamAble")
  print("")
  print("Use this program to remotly control your turtle!")
  print("Start this program on your pockect computer and the corresponding program on a turtle and control away!")
end

do
  local modemSide = getModem()
  if modemSide then
    rednet.open(modemSide)
  else
    printError("This program requires a wireless modem")
    return
  end
end

local continue = true
while continue do
  color(colors.white,colors.black) term.clear()
  printC("Enter your Turtle's ID:",5)
  term.setCursorPos(math.floor(w/2)-2,6)
  local input = tonumber(read())
  
  if input then
    color(colors.white,colors.black) term.clear()
    printC("Connecting to",5)
    printC("turtle ID "..input,6)
    printC("(*)",8)
    local state = 1
    
    turtleID = input
    message({action="connect",id=input})
    local timer = os.startTimer(1)
    while true do
      local event = {os.pullEventRaw()}
      if event[1] == "terminate" then
        term.clear() term.setCursorPos(1,1) print("Program terminated")
        return
      elseif event[1] == "rednet_message" and checkMessage(event,true) then
        if event[3] == "connected" then
          continue = false
          break
        end
      elseif event[1] == "timer" and event[2] == timer then
        state = (state == 4 and 1 or state+1)
        term.clearLine() printC(string.rep("(",state).."*"..string.rep(")",state),8)
        message({action="connect",id=input})
        timer = os.startTimer(1)
      end
    end
  end
end

local function heartbeat()
  
  message("ping")
  local timer = os.startTimer(2)
  while true do
    local event = {os.pullEvent()}
    if event[1] == "rednet_message" then
      if checkMessage(event,true) and event[3] == "pong" then
        sleep(3)
        message("ping")
        timer = os.startTimer(2)
      end
    elseif event[1] == "timer" and event[2] == timer then
      color(colors.white,colors.black) term.setCursorPos(1,1) term.clear() print("Lost contact with turtle!")
      error("FORCEQUIT")
    end
  end
  
end

local function main()
  
  drawMainScreen()
  detectTools()
  
  while true do
    local event = {mainScreen.handleEvents()}
    if event[1] == "rednet_message" and checkMessage(event) then
      local msg = event[3]
      if msg.action == "ping" then
        message("pong")
      end
    elseif event[1] == "key" then
      if event[2] == keys.up or event[2] == keys.w then
        forward()
      elseif event[2] == keys.down or event[2] == keys.s then
        back()
      elseif event[2] == keys.right or event[2] == keys.d then
        turnRight()
      elseif event[2] == keys.left or event[2] == keys.a then
        turnLeft()
      elseif event[2] == keys.space then
        up()
      elseif event[2] == keys.leftShift then
        down()
      elseif event[2] == keys.q then 
        
      end
    elseif event[1] == "object" then
      
    end
  end
  
end

local function run()
  parallel.waitForAny(main,heartbeat)
end

local state,err = pcall(run)

if err then
  if not err:find("Terminated") and not err:find("FORCEQUIT") then
    color(colors.white,colors.black)
    term.clear()
    printC("An error occured:",1)
    term.setCursorPos(1,3)
    print(err)
  elseif not err:find("FORCEQUIT") then
    color(colors.white,colors.black)
    term.clear()
    term.setCursorPos(1,1)
  end
else
  color(colors.white,colors.black)
  term.clear()
  term.setCursorPos(1,1)
end
