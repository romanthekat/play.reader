-- import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/timer"
import 'CoreLibs/ui/gridview.lua'
import 'files'
import 'draw'

local gfx <const> = playdate.graphics

gfx.setColor(gfx.kColorWhite)
local font = gfx.font.new('fonts/Roobert/Roobert-11-Medium-table-22-22.png')
--gfx.setFont(font)

local files = getFiles()

local filename = nil
local fileContent = {}

local readingFile = false
local readingIndex = 0

local filesListHeight = 240
local filesList = playdate.ui.gridview.new(0, lineHeight)
filesList:setNumberOfRows(#files)
filesList:setCellPadding(0, 0, 0, 0)

function filesList:drawCell(section, row, column, selected, x, y, width, height)
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
        filesList:selectPreviousRow(false)
    end
end

function playdate.downButtonUp()
    if not readingFile then
        filesList:selectNextRow(false)
    end
end

function playdate.AButtonDown()
    if not readingFile then
        readingFile = true
        filename = files[filesList:getSelectedRow()]
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

function playdate.update()
    playdate.timer.updateTimers()
    -- playdate.drawFPS(385, 0) 

    if not readingFile then
        gfx.clear()
        filesList:drawInRect(0, 0, 400, filesListHeight)
    else
        readingIndex = handleTextDrawing(fileContent, readingIndex)
    end
    
    -- gfx.sprite.update()
end
