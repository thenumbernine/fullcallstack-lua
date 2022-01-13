#!/usr/bin/env luajit
local filename = ...
require 'fullcallstack'(function()
	loadfile(filename)(table.unpack(arg, 2))
end)
