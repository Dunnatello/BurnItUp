--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Object Module: [Module Name]
Purpose: [Purpose]

-------------------------

Inspired by this tutorial: https://www.tutorialspoint.com/lua/lua_object_oriented.htm

]]

newObject = { 

	-- Object Public Variables
	exampleValue = "Hello, World!",
	
}


function newObject:new( object, arguments )

	-- Assign passed object or create a new one.
	object = object or { }
	
	setmetatable( object, self )
	self.__index = self
	
	-- Return the object reference
	return object
	
end

function newObject:action( )

	print( "The object's example value is ", self.exampleValue )
	
end


return newObject