--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Module: Calculator
Purpose: Calculates Calories Burned and Other Calculations Needed for Calorie Tracking

-------------------------

]]

local Calculator = { } 

-- Modules
local storageAccess = require( "Data.Modules.Backend.Storage.storageHandler" )
local metDataModule = require( "Data.Modules.Backend.metData" )
local dateAccess = require( "Data.Modules.External Libraries.date" )

local savedData = storageAccess.getData( )

-- Testing a function call from metData.lua
-- metDataModule.printMetValues()

--This will be needed if we take user input as hours, minutes.
function calculator.hoursToMinutes( hours, minutes ) 

	local minutes = 60 * hours + minutes
	return minutes
	
end

function Calculator.calcCaloriesBurned( exercise, minutes, weightLbs )
	
	-- Floor + 0.5 rounds to the nearest integer
	-- Converts lbs input to kg
	-- Duration needs to be in minutes (subject to change)
	
	local roundedCalories = math.floor( ( ( ( metDataModule.getMetValue( exercise ) * 3.5 * ( weightLbs * 0.453592 )  / 200 ) * minutes ) + 0.5) )
	
	print( "Calories burned: " .. roundedCalories )

	return roundedCalories
	
end

--Calculator.calcCaloriesBurned( "jump rope", 80, 143.3 ) -- FIXME: Remove After Testing

function Calculator.calculateAge( )

	local storedDOB = savedData[ "Info" ][ "Date of Birth" ]

	local convertedDOB = dateAccess( storedDOB[ "Year" ], storedDOB[ "Month" ], storedDOB[ "Day" ] )
	local currentDate = dateAccess( false ) -- Returns Current Date

	-- Calculate Date Difference
	local difference = dateAccess.diff( currentDate, convertedDOB )

	-- Convert Days to Years
	local userAge = math.floor( difference:spandays( ) / 365 )

	return userAge

end

return Calculator
