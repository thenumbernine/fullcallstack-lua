#!/usr/bin/env lua
require 'fullcallstack'(function()

	local function b()
		callNothing()
	end

	function c()
		print'here'
	end

	local function a()
		b()
		c()
	end

	a()
end)
