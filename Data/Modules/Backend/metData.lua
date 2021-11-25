--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Module: MET Data
Purpose: Stores a list of common exercises to be used in calculating calories burned.

-------------------------

]]

local metData = { }

metData.metTable = {
	
	[ "bicycling" ] = 7.5,   
	[ "jump rope" ] = 12.3,  
	[ "running" ] = 8.0,   
	[ "walking" ] = 3.5,   
	[ "tennis" ] = 7.3,  
	[ "swimming" ] = 6.0,   
	[ "soccer" ] = 7.0,  
	[ "bowling" ] = 3.0,
	[ "boxing" ] = 13.4,
	[ "basketball" ] = 11.1,
	[ "car driving" ] = 2.0,
	[ "cricket" ] = 6.1,
	[ "croquet" ] = 2.5,
	[ "curling" ] = 7.4,
	[ "equestrianism" ] = 7.0,
	[ "fencing" ] = 8.0,
	[ "figure skating" ] = 8.0
}

function metData.getMetValue( exercise )

	return metData.metTable[ string.lower( exercise ) ]
	
end

function metData.printMetValues( )
 
	for key, value in pairs( metData.metTable ) do
		
		print( key, value )
		
	end
	
end

return metData
