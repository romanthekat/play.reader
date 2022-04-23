import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import 'CoreLibs/ui/gridview.lua'
import 'files'

local gfx <const> = playdate.graphics

gfx.setColor(gfx.kColorWhite)
local font = gfx.font.new('fonts/Roobert/Roobert-11-Medium-table-22-22.png')
--gfx.setFont(font)

local crankStepPerLine = 7
local linesPerScreen = 11
local lineHeight = 20
local extraScrollLines = 4

local files = getFiles()
local readingFile = false
local index = 0
local needRefresh = true

local filename = nil
local linesCount = 0
local fileContent = {}



-------------
local listviewHeight = 240

local listview = playdate.ui.gridview.new(0, lineHeight)
listview:setNumberOfRows(#files)
listview:setCellPadding(0, 0, 0, 0)
-- listview:setContentInset(24, 24, 13, 11)


function listview:drawCell(section, row, column, selected, x, y, width, height)
    if selected then
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRect(x, y, width, 20, 4)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
    else
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
    end
    gfx.drawTextInRect(files[row], x, y, width, height+2, nil, "...", kTextAlignment.center)
    
end

function playdate.upButtonUp()
    if not readingFile then
        listview:selectPreviousRow(false)
    end
end

function playdate.downButtonUp()
    if not readingFile then
        listview:selectNextRow(false)
    end
end


function playdate.AButtonDown()
    if not readingFile then
        readingFile = true
        fileContent, linesCount = readFileContent(files[listview:getSelectedRow()])
        
        needRefresh = true
        index = 0
    end
end

function playdate.BButtonDown()
    if readingFile then
        readingFile = false
        files = getFiles()
        
        needRefresh = true
        index = 0
    end
end

function playdate.update()
    playdate.timer.updateTimers()
    playdate.drawFPS(385, 0) 

    if not readingFile then
        gfx.clear()
        listview:drawInRect(0, 0, 400, listviewHeight)
    else
        index = handleTextDrawing(fileContent, index)
    end
    
    -- gfx.sprite.update()
end


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
    if index > linesCount - linesPerScreen + extraScrollLines then
        index = linesCount - linesPerScreen + extraScrollLines
    end
    
    if needRefresh then
        gfx.clear()
        
        local printOffset = 0
        local i = 1
        while i < linesPerScreen do
            if index+i < linesCount then
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