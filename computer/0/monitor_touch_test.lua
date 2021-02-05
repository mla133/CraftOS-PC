monitor = peripheral.wrap("top")
w,h = monitor.getSize()

while true do
    event, side, xPos, yPos = os.pullEvent("monitor_touch")
    
    monitor.clear()
    info = "x:"..xPos..", y:"..yPos
    monitor.setCursorPos(w/2-#info/2, h/2)
    monitor.write(info)
end    
