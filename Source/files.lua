function readFileContent(filename)
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
	
	return content, linesCount
end

function getFiles()
	local result = {}
	
	local files = playdate.file.listFiles()
	for i = 1, #files do
		local file = files[i]
		
		if file:sub(-4) == ".txt" then
			table.insert(result, file)
		elseif file:sub(-3) == ".md" then
			table.insert(result, file)
		elseif file:sub(-4) == ".doc" then
			table.insert(result, file)
		elseif file:sub(-4) == ".rst" then
			table.insert(result, file)
		end
	end
	
	return result
end