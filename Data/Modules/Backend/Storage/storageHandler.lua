--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Module: Storage
Purpose: Stores and retrieves data for use within the app.

-------------------------

]]

local storage = { }

local currentData

local filePath = system.pathForFile( "Settings.json", system.DocumentsDirectory )

local json = require( "json" )

local function generateInitialData( )

	currentData = { 

		[ "Info" ] = {
		
			[ "Name" ] = "N/A",
			[ "Date of Birth" ] = "N/A",
			[ "Height" ] = { [ "Feet" ] = "N/A", [ "Inches" ] = "N/A" }, -- Height in Feet/Inches
			[ "Initial Weight" ] = "N/A", -- Weight in Pounds
			[ "Weight Goal" ] = "N/A", -- Weight in Pounds
			[ "Current Age" ] = "N/A",

		},

		[ "Weight Log" ] = { }, -- Data entries for the user's weight over time.
		[ "Calorie Log" ] = { },
	
	}
	
end

local function saveDataToFile( ) -- Save Data to File
	
	local file = io.open( filePath, "w" )

	local TableToSave = currentData

	if file then
		
		file:write( json.encode( TableToSave ) )
		io.close( file )
	
		print( "Saved data successfully" )
		
	end
	
end

local function loadData( ) -- Load Data from File

	local file = io.open( filePath, "r" )
		
	if file then
	
		print( "Found File" )
		local contents = file:read( "*a" )
		io.close( file )
		currentData = json.decode( contents )
	
	
	else -- Generate Initial Data
	
		generateInitialData( )
		
		saveDataToFile( )
		
		print( "Generating initial data" )
		
	end
	
end


function storage.deleteData( ) -- Delete save file

	local result, reason = os.remove( system.pathForFile( "Settings.json", system.DocumentsDirectory ) )
	
	currentData = nil
	generateInitialData( )

	return result, reason
	
end

function storage.getData( ) -- Get data Table
	
	if ( currentData == nil ) then
	
		loadData( )
		
	end
	
	return currentData
	
end

function storage.saveData( ) -- Call Save Data to File Function
	
	saveDataToFile( )
	
end

return storage