local gfx <const> = playdate.graphics

crankStepPerLine = 7
linesPerScreen = 11
lineHeight = 20
extraScrollLines = 4
needRefresh = true

function handleTextDrawing(content, index)
	local crankChange = playdate.getCrankChange() 
	local crankMoved = math.abs(crankChange) > crankStepPerLine
	
	if playdate.buttonIsPressed(playdate.kButtonUp) or (crankMoved and crankChange < 0) then
	   index -= 1
	   needRefresh = true
	end
	if playdate.buttonIsPressed(playdate.kButtonDown) or (crankMoved and crankChange > 0) then
		index += 1
		needRefresh = true
	end
	
	if index < 0 then
		index = 0
	end
	if index > #content - linesPerScreen + extraScrollLines then
		index = #content - linesPerScreen + extraScrollLines
	end
	
	if needRefresh then
		gfx.clear()
		
		local printOffset = 0
		local i = 1
		while i <= linesPerScreen do
			if index+i <= #content then
				printedLength, printedHeight = gfx.drawTextInRect(content[index+i], 2, (i-1+printOffset)*22, 400, 240) 
				
				if printedHeight > lineHeight then
					printOffset += printedHeight //= lineHeight - 1
				end 
			end
			i += 1
		end
		needRefresh = false  
	end 
	
	return index
end