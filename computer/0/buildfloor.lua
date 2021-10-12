--[[ Floor Building Program ]]

os.loadAPI('hare.lua')

--handle command line arguments
local cliArgs = {...}
local length = tonumber(cliArgs[1])
local width = tonumber(cliArgs[2])

if length == nil or width == nil or cliArgs[1] == '?' then
	print('Usage: buildfloor <length> <width>')
	return
end

hare.buildFloor(length, width)
