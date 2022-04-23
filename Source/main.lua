-- import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import 'CoreLibs/ui/gridview.lua'
import 'files'
import 'draw'

gfx = playdate.graphics

gfx.setColor(gfx.kColorWhite)
local font = gfx.font.new('fonts/Roobert/Roobert-11-Medium-table-22-22.png')
--gfx.setFont(font)

files = getFiles()

local filename = nil
local fileContent = {}

local readingFile = false
local readingIndex = 0


function playdate.upButtonUp()
    if not readingFile then
        filesGrid:selectPreviousRow(false)
    -- else 
    --     readingIndex -= 1
    end
    
    needRefresh = true
end

function playdate.downButtonUp()
    if not readingFile then
        filesGrid:selectNextRow(false)
        readingIndex += 1
    -- else
    --     readingIndex += 1
    end
    
    needRefresh = true
end

function playdate.AButtonDown()
    if not readingFile then
        readingFile = true
        filename = files[filesGrid:getSelectedRow()]
        fileContent = readFileContent(filename)
        
        needRefresh = true
        readingIndex = getReadingIndex(filename)
    end
end

function playdate.BButtonDown()
    if readingFile then
        readingFile = false
        files = getFiles()
        
        needRefresh = true
    end
end

function getReadingIndex(filename)
    return 0 -- TODO: add support for reading position per file
end

function handleContiniousInput(index)
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
   
   if index > #fileContent - linesPerScreen + extraScrollLines then
       index = #fileContent - linesPerScreen + extraScrollLines
   end
   if index < 0 then
       index = 0
   end	 
   
   return index
end

function playdate.update()
    playdate.timer.updateTimers()
    -- playdate.drawFPS(385, 0) 

    if not readingFile then
        drawFilesList(files)
    else
        readingIndex = handleContiniousInput(readingIndex)
        readingIndex = handleTextDrawing(fileContent, readingIndex)
    end
    
    -- gfx.sprite.update()
end
