--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Scene: Track Weight
Purpose: Allow the user to track their current weight.

-------------------------


]]
local composer = require( "composer" )

local scene = composer.newScene()

-- Modules
local moduleNames = { 

	-- UI
	{ Name = "dayOverview", Location = "Data.Modules.UI.dayOverview" },
	{ Name = "topbarManager", Location = "Data.Modules.UI.topbarManager" },
	{ Name = "scaler", Location = "Data.Modules.UI.scaler" },

	-- Backend
	{ Name = "storage", Location = "Data.Modules.Backend.Storage.storageHandler" },
	
	-- External Libraries
	{ Name = "dateLibrary", Location = "Data.Modules.External Libraries.date" },
	
}

local modules = { }

for i = 1, #moduleNames do
	
	modules[ moduleNames[ i ].Name ] = require( moduleNames[ i ].Location )
	
end

-- Clear Memory of Unneeded Tables
moduleNames = nil

-- Tables
local ui_Groups = { }
local ui_Objects = { }

local savedData

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function showErrorMessage( newMessage ) -- Show Text Field Warning Message
	
	ui_Objects[ "Text Input" ].Warning.text = newMessage

end

local function gotoMenu( )

	composer.gotoScene( "Data.Scenes.Menu", { effect = "crossFade", time = 400 } )

end

local function findWeightListing( currentDate ) -- Find weight listing in Weight Log

	local listingIndex = nil
	
	local dateTable = { [ "Year" ] = currentDate:getyear( ), [ "Month" ] = currentDate:getmonth( ), [ "Day" ] = currentDate:getday( ) }
	
	for i = 1, #savedData[ "Weight Log" ] do
	
		local currentListing = savedData[ "Weight Log" ][ i ]
		if ( currentListing[ "Date" ][ "Year" ] == dateTable[ "Year" ] and currentListing[ "Date" ][ "Month" ] == dateTable[ "Month" ] and currentListing[ "Date" ][ "Day" ] == dateTable[ "Day" ] ) then
		
			listingIndex = i
			break
		
		end
		
	end
	
	return listingIndex
	
end

local function sortByOldest( a, b ) -- Sort list by oldest weight value first in order to avoid out-of-order sequences.

	local firstDate = modules[ "dateLibrary" ]( a[ "Date" ][ "Year" ], a[ "Date" ][ "Month" ], a[ "Date" ][ "Day" ] )
	local secondDate = modules[ "dateLibrary" ]( b[ "Date" ][ "Year" ], b[ "Date" ][ "Month" ], b[ "Date" ][ "Day" ] )
	return firstDate < secondDate
	
end

local function recordWeight( newWeight ) -- Record weight
	
	local weightListing = findWeightListing( modules[ "dayOverview" ].currentDate )
	
	if ( weightListing ~= nil ) then -- Listing already exists, update it.
	
		savedData[ "Weight Log" ][ weightListing ][ "Weight" ] = newWeight
	
	else -- Listing doesn't exist, add it and sort the table.
	
		local newListing = { 
		
			[ "Date" ] = { 
					
					[ "Year" ] = modules[ "dayOverview" ].currentDate:getyear( ), 
					[ "Month" ] = modules[ "dayOverview" ].currentDate:getmonth( ), 
					[ "Day" ] = modules[ "dayOverview" ].currentDate:getday( )
					
			},
			
			[ "Weight" ] = newWeight
			
		}
		
		table.insert( savedData[ "Weight Log" ], newListing )
		
		table.sort( savedData[ "Weight Log" ], sortByOldest )
		
	end
	
	-- Save Data
	modules[ "storage" ].saveData( )
	
	-- Go to Menu
	gotoMenu( )
	
end

local function buttonPress( event )

	local button = event.target
	
	if ( button.myName == "leftActionButton" ) then
	
		gotoMenu( )
	
	elseif ( button.myName == "Submit" ) then
	
		local currentInput = tonumber( ui_Objects[ "Text Input" ].Field.text )
		
		if ( currentInput ~= nil ) then
		
			recordWeight( currentInput )
		
		else
			
			showErrorMessage( "Invalid input." )
			
		end
		
	end
	
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	-- Create UI Groups
	for i = 1, 3 do -- Creates a specified amount of UI group layers. Higher numbers are displayed on top of lower groups.
	
		ui_Groups[ i ] = display.newGroup( )
		sceneGroup:insert( ui_Groups[ i ] )
		
	end
	
	savedData = modules[ "storage" ].getData( )
	
	-- Create Topbar
	ui_Objects[ "Topbar" ] = modules[ "topbarManager" ]:new( { [ "Groups" ] = ui_Groups, [ "Title" ] = "Record Weight", [ "NavButtonEnabled" ] = true, [ "NavButtonIcon" ] = "arrow_back", [ "ScaleRatio" ] = scaleRatio } )
	ui_Objects[ "Topbar" ].ui_Objects[ "leftActionButton" ].Button:addEventListener( "tap", buttonPress )

	-- Prompt Text
	ui_Objects[ "Prompt" ] = display.newText( { parent = ui_Groups[ 3 ], text = modules[ "dayOverview" ].currentDate:fmt( "%a, %b %d %Y" ), x = display.contentCenterX, y = display.contentHeight * 0.3, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 42 * scaleRatio, align = "center" } )
	ui_Objects[ "Prompt" ]:setFillColor( 0, 0, 0, 1 )
	
	-- Submit Button
	ui_Objects[ "Submit" ] = { }
	local submitButton = ui_Objects[ "Submit" ]
	
	-- Title
	submitButton.Title = display.newText( { parent = ui_Groups[ 3 ], text = "Record", x = display.contentCenterX, y = display.contentHeight * 0.9, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 32 * scaleRatio, align = "center" } )
	
	-- Button
	submitButton.Button = display.newRoundedRect( ui_Groups[ 2 ], submitButton.Title.x, submitButton.Title.y, submitButton.Title.width, submitButton.Title.height + ( 30 * scaleRatio ), 50 * scaleRatio )
	submitButton.Button:setFillColor( 8 / 255, 127 / 255, 35 / 255 )
	submitButton.Button.myName = "Submit"
	submitButton.Button:addEventListener( "tap", buttonPress )
	
	-- Drop Shadow
	submitButton.DropShadow = display.newRoundedRect( ui_Groups[ 1 ], submitButton.Button.x + 4, submitButton.Button.y + 4, submitButton.Button.width, submitButton.Button.height, 50 * scaleRatio )
	submitButton.DropShadow:setFillColor( 0, 0, 0, 0.25 )	

	-- Create Listing
	ui_Objects[ "Text Input" ] = { }
	local currentInput = ui_Objects[ "Text Input" ]
	
	-- Text Field
	currentInput.Field = native.newTextField( display.contentCenterX, display.contentCenterY, display.contentWidth * 0.8, 60 * scaleRatio )
	currentInput.Field.type = "number"
	currentInput.Field.placeholder = "170.1"
	currentInput.Field.align = "center"
	currentInput.Field:resizeFontToFitHeight( )
	
	sceneGroup:insert( currentInput.Field )
	
	-- Title Text
	currentInput.Title = display.newText( { parent = ui_Groups[ 3 ], text = "Current Weight (Pounds)", x = display.contentCenterX, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 36 * scaleRatio, align = "center" } )
	currentInput.Title.y = ( currentInput.Field.y - currentInput.Field.height / 2 ) - currentInput.Title.height
	
	currentInput.Title:setFillColor( 0, 0, 0, 0.75 )

	-- Warning Text
	currentInput.Warning = display.newText( { parent = ui_Groups[ 3 ], text = "", x = display.contentCenterX, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 36 * scaleRatio, align = "center" } )
	currentInput.Warning.y = ( currentInput.Field.y + currentInput.Field.height * 0.75 ) + currentInput.Warning.height / 2
	currentInput.Warning:setFillColor( 186 / 255, 0 / 255, 13 / 255 )
		
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		
		ui_Objects[ "Text Input" ].Field.isVisible = true

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

		ui_Objects[ "Text Input" ].Field.isVisible = false

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
