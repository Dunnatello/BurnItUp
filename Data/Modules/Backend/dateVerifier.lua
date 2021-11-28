--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Module: Date Verifier
Purpose: [Purpose]

-------------------------

]]

local dateVerifier = { }
local dateLibrary = require( "Data.Modules.External Libraries.date" )

local function convertStringToNumberTable( stringText ) -- Separates the string into several numbers for use in creating date formats.
	
	local numbersFromString = { }
	
	repeat
	
		local foundNumber = string.match( stringText, "%d+" ) -- Find Next Number
		
		if ( foundNumber ~= nil ) then -- If number exists, remove it from the string.
			
			local currentNumberBegin, currentNumberEnd = string.find( stringText, "%d+" )
			stringText = string.sub( stringText, currentNumberEnd + 1, string.len( stringText ) )
			
			table.insert( numbersFromString, tonumber( foundNumber ) )

		end
		
	until foundNumber == nil or #numbersFromString > 3
	
	return numbersFromString
	
end

local function convertStringToDate( stringText ) -- Converts provided string to a date object (if possible).

	local convertedDate = nil
	
	local numberTable = convertStringToNumberTable( stringText )
	
	if ( #numberTable == 3 ) then -- Make sure that there are a maximum of 3 numbers for the date.
	
		local isCompatible = true
		
		for i = 1, #numberTable do
		
			if ( numberTable[ i ] == nil or numberTable[ i ] < 1 ) then
			
				isCompatible = false
				break
				
			end
			
		end
		
		if ( isCompatible == true ) then -- If the number table could be a date, then create a date object from the numbers.
		
			convertedDate = dateLibrary( numberTable[ 3 ], numberTable[ 1 ], numberTable[ 2 ] )
			
			print( "Converted Date: ", convertedDate:fmt( "%A, %B %d %Y" ) )
			
			local currentLuaDate = os.date( "*t", os.time( ) )

			local currentDate = dateLibrary( currentLuaDate.year, currentLuaDate.month, currentLuaDate.day )
			
			-- Make sure that the date is in the past.
			if ( convertedDate == nil or currentDate <= convertedDate ) then
				print( "Can't have a date of birth in the future." )
				isCompatible = false
				convertedDate = nil
				
			end
			
		end
		
	end
	
	return convertedDate
	
end

function dateVerifier.checkDateFromString( dateString ) -- Converts a string to a date format using the LuaDate library.

	return convertStringToDate( dateString )
	
end


return dateVerifier