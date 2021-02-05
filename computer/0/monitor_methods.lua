monitor = peripheral.wrap("top")

monitor.setTextScale(1)

w,h = monitor.getSize()
isColor = monitor.isColor()
monitor.clear()

if isColor then
    monitor.setBackgroundColor(colors.gray)
    monitor.clear()
    
    monitor.write("You are using a ")
    
    monitor.setTextColor(colors.red)
    monitor.write("C")
    monitor.setTextColor(colors.yellow)
    monitor.write("o")
    monitor.setTextColor(colors.green)
    monitor.write("l")
    monitor.setTextColor(colors.cyan)
    monitor.write("o")
    monitor.setTextColor(colors.blue)
    monitor.write("r")
    
    monitor.setTextColor(colors.white)
    monitor.write(" monitor")

else
    monitor.write("You are using a normal monitor")
    
end

monitor.setCursorPos(1,h/2+1)
monitor.write("with size " ..w.."x"..h)
    
monitor.setBackgroundColor(colors.black)

sleep(1)
for i=1,4 do
    --monitor.scroll(1)
    sleep(1)
end

monitor.setCursorPos(1,h/2)
--monitor.setCursorBlink(true)
sleep(2)
--monitor.clearLine()

        
    
