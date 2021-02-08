-- Missile Interceptor by Saldor010
-- Patch #1
-- See the forum post below for more details
-- http://www.computercraft.info/forums2/index.php?/topic/28897-missile-interceptor/

local GAMEOVER = false
local GAMESTARTED = false
local args = {...}
local difficulty = tonumber(args[1])
if not difficulty then difficulty = 1 end
if difficulty < 1 or difficulty > 2 then difficulty = 1 end

if not fs.exists("cobalt") and not args[2] then
	term.setTextColor(colors.red)
	print("Cobalt could not be found on this machine. Cobalt is required to run this game.")
	term.setTextColor(colors.lime)
	print("To download cobalt, please press the Y key now.")
	term.setTextColor(colors.blue)
	print("If you already have cobalt, and we just can't find it, please supply the path as the second argument.")
	local ev,p1,p2,p3,p4,p5 = os.pullEvent("char")
	if string.lower(p1) == "y" then
		shell.run("pastebin","run","h5h4fm3t")
	else
		term.setTextColor(colors.red)
		print("Cancelled installation of Cobalt.")
	end
	error()
end

local cobalt = nil
if fs.exists("cobalt") then
	cobalt = dofile("cobalt")
elseif args[2] then
	cobalt = dofile(args[2])
end

local smokeGrid = {}
local smokeColors = {
	[4] = colors.yellow,
	[3] = colors.orange,
	[2] = colors.red,
	[1] = colors.gray,
}
local missileGrid = {}
local missileTimer = 1
local tick = 0

local points = 0

local function spawnMissile()
	local x = math.random(3,49)
	table.insert(missileGrid,{
		["x"] = x,
		["y"] = 1,
		["speed"] = math.random(1)
	})
end

function cobalt.update( dt )
	if GAMESTARTED then
		if GAMEOVER then 
			GAMEOVER = GAMEOVER - dt
			if GAMEOVER <= 0 then
				cobalt.exit()
			end
			return 
		end
		missileTimer = missileTimer - dt
		tick = tick - dt
		
		if missileTimer <= 0 then
			spawnMissile()
			missileTimer = math.random(1,3)
		end
		
		if tick <= 0 then
			local toRemove = {}
			for k,v in pairs(smokeGrid) do
				v["ct"] = v["ct"] - 1
				if v["ct"] <= 0 then
					toRemove[k] = true
				end
			end
			for k,v in pairs(toRemove) do
				table.remove(smokeGrid,k)
			end
			
			for k,v in pairs(missileGrid) do
				v["y"] = v["y"] + v["speed"]
				
				for i=1,v["speed"] do
					table.insert(smokeGrid,{
						["x"] = v["x"],
						["y"] = v["y"]-i,
						["ct"] = 4
					})
				end
				
				if v["y"] >= 19 then
					GAMEOVER = 2
					return
				end
			end
			
			tick = 0.2
		end
	end
end

function cobalt.draw()
	if GAMESTARTED then
		for k,v in pairs(missileGrid) do
			if v["speed"] == 2 then
				cobalt.graphics.print("V",v["x"],v["y"],colors.black,colors.red)
			else
				cobalt.graphics.print("V",v["x"],v["y"],colors.black,colors.white)
			end
		end

		for k,v in pairs(smokeGrid) do
			cobalt.graphics.print("@",v["x"],v["y"],colors.black,smokeColors[v["ct"]] or colors.gray)
		end
		
		if GAMEOVER then
			cobalt.graphics.center("GAME OVER",9,0,20,colors.black,colors.red)
			cobalt.graphics.center("Missiles Intercepted: "..points,11,0,50,colors.black,colors.gray)
			if difficulty == 1 then
				cobalt.graphics.center("On Easy Difficulty",12,0,50,colors.black,colors.yellow)
			else
				cobalt.graphics.center("On Hard Difficulty",12,0,50,colors.black,colors.red)
			end
		end
		
		local scoreDigit = 0
		if points and points > 0 then
		scoreDigit = tostring(points)
		scoreDigit = #scoreDigit-1
		end
		--cobalt.graphics.print(math.log(points),1,1,colors.black,colors.white)
		cobalt.graphics.print(points,51-scoreDigit,1,colors.black,colors.gray)
	else
		cobalt.graphics.center("MISSILE INTERCEPTOR",9,0,50,colors.black,colors.orange)
		if difficulty == 2 then
			cobalt.graphics.center("- = HARDCORE = -",10,0,50,colors.black,colors.red)
		end
		cobalt.graphics.center("Press any key to start",10+difficulty,0,50,colors.black,colors.gray)
	end
end

local function check(x,y,vx,vy)
	if difficulty == 1 then
		for i=-1,1 do
			for j=-1,1 do
				if vx == x+i and vy == y+j then return true end
			end
		end
		return false
	elseif difficulty == 2 then
		if vx == x and vy == y then return true else return false end
	end
end

function cobalt.mousepressed( x, y, button )
	if not GAMEOVER then
		local toRemove = {}
		for k,v in pairs(missileGrid) do
			if check(v["x"],v["y"],x,y) then
				points = points + 1
				toRemove[k] = true
				for i=-1,1 do
					if true then --v["x"]+i >= 1 and v["x"]+i <= 51 then
						for j=-1,1 do
							if true then --v["y"]+j >= 1 and v["y"]+j <= 19 then
								table.insert(smokeGrid,{
									["x"] = v["x"]+i,
									["y"] = v["y"]+j,
									["ct"] = math.random(3,4)
								})
							end
						end
					end
				end
			end
		end
		for k,v in pairs(toRemove) do
			table.remove(missileGrid,k)
		end
	end
end

function cobalt.mousereleased( x, y, button )

end

function cobalt.keypressed( keycode, key )
	if not GAMESTARTED then GAMESTARTED = true end
end

function cobalt.keyreleased( keycode, key )

end

function cobalt.textinput( t )

end

cobalt.initLoop()