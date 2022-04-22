import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

gfx.setColor(gfx.kColorWhite)
local font = gfx.font.new('fonts/Roobert/Roobert-11-Medium-table-22-22.png')

local linesPerScreen = 11
local lineHeight = 20
local extraScrollLines = 4

local filename = "test.txt"

file = playdate.file.open(filename, playdate.file.kFileRead)
local linesCount = 1
local content = {}
repeat
    l = file:readline()
    if l then
        content[linesCount] = l
        linesCount += 1
    end
until l == nil

local index = 0
local needRefresh = true

function playdate.update()
    playdate.drawFPS(380, 0)

    --gfx.setFont(font)

    if playdate.buttonIsPressed(playdate.kButtonUp) then
       index -= 1
       needRefresh = true
    end
    if playdate.buttonIsPressed(playdate.kButtonDown) then
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
    
    gfx.sprite.update()
    playdate.timer.updateTimers()
end
