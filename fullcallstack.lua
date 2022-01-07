local tolua = require 'ext.tolua'

local function handleError(err)
	io.stderr:write('lua: ', tostring(err),'\n')
	local iskip = 2
	local i = iskip
	-- i == 0 = debug.getinfo()
	-- i == 1 = handleError()
	while true do
		local info = debug.getinfo(i)
		if not info then break end
		
		local source = info.source
		info.source = nil

		-- starts with = and it's [C]
		-- starts with @ and it's a filename
		-- otherwise ... it's code?
		local first = source:sub(1,1)
		if first == '@' 
		or first == '=' 
		then
			source = source:sub(2)
		else
			source = source:gsub('[\r\n]', ' ')
			local maxlen = 50
			if #source > maxlen then
				source = source:sub(1, maxlen) .. '...'
			end
		end
		
		-- info.what is C, Lua, or 'main' if it's loaded from the interpreter or from a load()

		local desc = source
			..(info.currentline ~= -1 and (':'..info.currentline) or '')
			..(info.name ~= nil and ' '..tostring(info.name)..'()' or '')
		info.short_src = nil
		info.currentline = nil
		info.func = nil
		info.name = nil
		-- currentline=-1, func=debug.getinfo, istailcall=false, isvararg=true, lastlinedefined=-1, linedefined=-1, name="getinfo", namewhat="field", nparams=0, nups=0, short_src="[C]", source="=[C]", what="C"}
		io.stderr:write('\t', '#', i-iskip+1, ' ', desc, ' ', tolua(info), '\n')
		i=i+1
	end
	io.stderr:flush()
end

return function(f, ...)
	return xpcall(f, handleError, ...)
end
