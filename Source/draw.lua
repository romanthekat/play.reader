width, height = playdate.display.getSize()

linesPerScreen = 11
lineHeight = 20
needRefresh = true

filesGrid = playdate.ui.gridview.new(0, lineHeight)
filesGrid:setCellPadding(0, 0, 0, 0)

crankStepPerLine = 7
extraScrollLines = 4
local filesGridHeight = 240

function drawFilesList(files)
	gfx.clear()
	
	filesGrid:setNumberOfRows(#files)
	filesGrid:drawInRect(0, 0, 400, filesGridHeight)
end

function filesGrid:drawCell(section, row, column, selected, x, y, width, height)
	if selected then
		gfx.setColor(gfx.kColorBlack)
		gfx.fillRect(x, y, width, 20, 4)
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	else
		gfx.setImageDrawMode(gfx.kDrawModeCopy)
	end
	gfx.drawTextInRect(files[row], x, y, width, height+2, nil, "...", kTextAlignment.center)
	
end

function handleTextDrawing(content, index)
	if needRefresh then
		gfx.clear()
		
		local printOffset = 0
		local i = 1
		while i <= linesPerScreen do
			if index+i <= #content then
				line = content[index+i]
				local x = 2
				local y = (i-1+printOffset)*lineHeight
				
				printedLength, printedHeight = gfx.drawTextInRect(line, x, y, 400, 240) 
				
				if printedHeight > lineHeight then
					printOffset += printedHeight //= lineHeight - 1
				end 
			end
			i += 1
		end
		needRefresh = false  
		playdate.display.flush()
	end 
	
	return index
end