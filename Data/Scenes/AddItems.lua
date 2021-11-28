--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Scene: Add Items
Purpose: Allow the user to add food/exercises.

-------------------------


]]
local composer = require( "composer" )

local scene = composer.newScene( )

local moduleNames = { 

	-- UI
	{ Name = "dayOverview", Location = "Data.Modules.UI.dayOverview" },
	{ Name = "topbarManager", Location = "Data.Modules.UI.topbarManager" },
	{ Name = "scaler", Location = "Data.Modules.UI.scaler" },

	-- Backend
	{ Name = "storage", Location = "Data.Modules.Backend.Storage.storageHandler" },
	{ Name = "foodRetriever", Location = "Data.Modules.Backend.foodRetriever" },
	{ Name = "itemHandler", Location = "Data.Modules.Backend.itemHandler" },
	{ Name = "metData", Location = "Data.Modules.Backend.metData" },
	{ Name = "Calculator", Location = "Data.Modules.Backend.Calculator" },
	
	-- Solar2D (Corona SDK) Built-In Libraries
	{ Name = "widget", Location = "widget" },
	
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
local itemLists = { [ "Food" ] = nil, [ "Exercise" ] = nil }

local currentParameters = { Category = nil, Title = nil }
local currentDate
local currentDayLog
local currentWeight

local sections = { "Menu", "List", "View Item", "Submit" }
local sectionIndex = 2

local selectedItem = { [ "Name" ] = nil, [ "Category" ] = nil, [ "Details" ] = nil }

local FoodInfoCategories = { 
	
	{ [ "Name" ] = "Total Fat", [ "Units" ] = "Grams" },
	{ [ "Name" ] = "Saturated Fat", [ "Units" ] = "Grams" },
	{ [ "Name" ] = "Trans Fat", [ "Units" ] = "Grams" },
	{ [ "Name" ] = "Cholesterol", [ "Units" ] = "Milligrams" },
	{ [ "Name" ] = "Sodium", [ "Units" ] = "Milligrams" },
	{ [ "Name" ] = "Total Carbohydrate", [ "Units" ] = "Grams" },
	{ [ "Name" ] = "Dietary Fiber", [ "Units" ] = "Grams" },
	{ [ "Name" ] = "Sugars", [ "Units" ] = "Grams" },
	{ [ "Name" ] = "Protein", [ "Units" ] = "Grams" },

}
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoMenu( )

	composer.gotoScene( "Data.Scenes.Menu", { effect = "crossFade", time = 400 } )

end
local function showErrorMessage( newMessage ) -- Show Text Field Warning Message
	
	ui_Objects[ "Selection Menu" ][ "Text Input" ].Warning.text = newMessage

end

local function addItem( currentInput )

	if ( savedData[ "Calorie Log" ][ currentDate:fmt( "%F" ) ] == nil ) then
	
		-- Save Current Log
		savedData[ "Calorie Log" ][ currentDate:fmt( "%F" ) ] = modules[ "dayOverview" ].currentDayLog
		
	end
	
	-- Save Item to Log
	if ( selectedItem[ "Name" ] ~= nil ) then
	
		local newSaveLocation = nil
		
		local newListing = { [ "Name" ] = selectedItem[ "Name" ], [ "Amount" ] = currentInput }

		if ( currentParameters.Category == "Exercise" ) then
		
			newSaveLocation = modules[ "dayOverview" ].currentDayLog[ "Exercises" ]
			newListing[ "Calories" ] = modules[ "Calculator" ].calcCaloriesBurned( string.lower( selectedItem[ "Name" ] ), currentInput, currentWeight )
			
		else
		
			newSaveLocation = modules[ "dayOverview" ].currentDayLog[ "Meals" ][ currentParameters.Title ]
			newListing[ "Category" ] = selectedItem[ "Category" ]
			
		end
		
		if ( newSaveLocation ~= nil ) then
			
			table.insert( newSaveLocation, newListing )
			modules[ "storage" ].saveData( )
			
			gotoMenu( )
			
		end
		
	end
	
end

local function createContentView( ) -- Create ScrollView

	ui_Objects[ "Content View" ] = modules[ "widget" ].newScrollView( 
		
		{
			x = display.contentCenterX, 
			y = display.contentCenterY, 
			width = display.contentWidth * 0.95, 
			height = display.contentHeight - ( ui_Objects[ "Topbar" ].ui_Objects[ "Topbar" ].Bar.y + ui_Objects[ "Topbar" ].ui_Objects[ "Topbar" ].Bar.height / 2 ), 
			horizontalScrollDisabled = true, 
			hideBackground = true 
		}
		
	)	
	
	ui_Objects[ "Content View" ].y = ( ui_Objects[ "Topbar" ].ui_Objects[ "Topbar" ].Bar.y + ui_Objects[ "Topbar" ].ui_Objects[ "Topbar" ].Bar.height / 2 ) + ui_Objects[ "Content View" ].height / 2 + ( 20 * scaleRatio )
	
end

local function setScrollViewVisibility( newStatus ) -- Set ScrollView Visibility State

	ui_Objects[ "Content View" ].isVisible = newStatus
	
end

local function updateViewer( )
		
	local currentInput = tonumber( ui_Objects[ "Selection Menu" ][ "Text Input" ].Field.text )
	
	local newTitleText = selectedItem[ "Category" ] .. " | " .. selectedItem[ "Name" ]
	local newInfoText = ""
	local totalCalories = 0
	if ( currentParameters.Category ~= "Exercise" ) then
		
		-- Fix Title Text to Reflect Brand Instead of Category
		newTitleText = selectedItem[ "Item" ][ "Brand" ] .. " | " .. selectedItem[ "Item" ][ "Display Name" ]
		
		-- Calculate Current Serving Amount
		local servingAmount = currentInput / selectedItem[ "Item" ][ "Serving Size" ]
		
		-- Cycle Through Food Analytics
		for i = 1, #FoodInfoCategories do
			
			newInfoText = newInfoText .. FoodInfoCategories[ i ][ "Name" ] .. ": " .. string.format( "%.1f", selectedItem[ "Item" ][ FoodInfoCategories[ i ][ "Name" ] ] * servingAmount ) .. " " .. FoodInfoCategories[ i ][ "Units" ] .. "\n"
			
		end
		
		-- Get Total Calories of Item Cal * currentInput
		totalCalories = modules[ "itemHandler" ].getServingCalories( selectedItem[ "Item" ], currentInput )
		
	else
		
		-- Get Exercise Calories
		totalCalories = modules[ "Calculator" ].calcCaloriesBurned( string.lower( selectedItem[ "Name" ] ), currentInput, currentWeight )
		
	end
	
	-- Update Text
	ui_Objects[ "Selection Menu" ][ "Title" ].text = newTitleText
	ui_Objects[ "Selection Menu" ][ "Text Input" ].Title.text = "Amount (" .. selectedItem[ "Item" ][ "Serving Type" ] .. "(s))"
	
	ui_Objects[ "Selection Menu" ][ "Calories" ].text = tostring( string.format( "%.1f", totalCalories ) ) .. " Calories"
	ui_Objects[ "Selection Menu" ][ "Info" ].text = newInfoText
	
end

local function loadSection( ) -- Load Sections
	
	-- Current Section Name (as String)
	local sectionName = sections[ sectionIndex ]
	
	local isScrollViewVisible = false
	local isViewMenuVisible = false
	
	-- Clear Error Message
	showErrorMessage( "" )
	
	if ( sectionName == "Menu" ) then -- Go to Menu
	
		gotoMenu( )
	
	elseif ( sectionName == "List" ) then -- Show List
	
		isScrollViewVisible = true
		
		
	elseif ( sectionName == "View Item" ) then -- View Item Stats
		
		isViewMenuVisible = true
		
		ui_Objects[ "Selection Menu" ][ "Text Input" ].Field.text = "0"
		if ( selectedItem[ "Category" ] ~= "Exercise" ) then -- Set Default Serving Size Values
			
			ui_Objects[ "Selection Menu" ][ "Text Input" ].Field.text = tostring( selectedItem[ "Item" ][ "Serving Size" ] )
		
		end
		
		updateViewer( )
		
	elseif ( sectionName == "Submit" ) then -- Add Item to Log
		
		local currentInput = tonumber( ui_Objects[ "Selection Menu" ][ "Text Input" ].Field.text )
		
		if ( currentInput ~= nil ) then
		
			addItem( currentInput )
			
		else
		
			sectionIndex = 3
			return loadSection( )
			
		end
		
	end
	
	-- Set UI Visibility
	setScrollViewVisibility( isScrollViewVisible )
	
	-- Selection Menu Visibility
	for i = 4, 6 do
	
		ui_Groups[ i ].isVisible = isViewMenuVisible
		
	end
	
	ui_Objects[ "Selection Menu" ][ "Text Input" ].Field.isVisible = isViewMenuVisible
	
end

local function removeSections( ) -- Remove UI and Replace ScrollView

	display.remove( ui_Objects[ "Content View" ] )
	ui_Objects[ "Content View" ] = nil
	
	createContentView( )
	
	ui_Objects[ "Items" ] = nil
	
end


local function createListing( listingInfo, i ) -- Create Listing using passed values.
	
	local scrollView = ui_Objects[ "Content View" ]
	
	local newListing = { }
	
	-- Background
	newListing[ "Background" ] = display.newRoundedRect( ui_Groups[ 2 ], scrollView.width / 2, 0, display.contentWidth * 0.85, 42 * 1.75 * scaleRatio, 30 )
	newListing[ "Background" ].y = newListing[ "Background" ].height * ( i - 0.5 ) + ( 10 * scaleRatio * i )
	
	newListing[ "Background" ].myName = listingInfo[ "Item" ][ "Name" ]
	newListing[ "Background" ].category = listingInfo[ "Item" ][ "Category" ]

	newListing[ "Background" ]:addEventListener( "tap", function( ) 
	
		sectionIndex = sectionIndex + 1
		
		selectedItem[ "Name" ] = newListing[ "Background" ].myName
		selectedItem[ "Category" ] = newListing[ "Background" ].category
		selectedItem[ "Item" ] = listingInfo[ "Details" ]
		
		loadSection( )
	
	end )
	
	-- Update Last Position
	lastPosition = newListing[ "Background" ].y + newListing[ "Background" ].height / 2
	
	-- Drop Shadow
	newListing[ "DropShadow" ] = display.newRoundedRect( ui_Groups[ 1 ], newListing[ "Background" ].x + 4 * scaleRatio, newListing[ "Background" ].y + 4 * scaleRatio, newListing[ "Background" ].width, newListing[ "Background" ].height, 30 )
	newListing[ "DropShadow" ]:setFillColor( 0, 0, 0, 0.25 )

	-- Title
	newListing[ "Title" ] = display.newText( { parent = ui_Groups[ 3 ], text = listingInfo[ "Display Name" ], width = newListing[ "Background" ].width * 0.6, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 20 * scaleRatio, align = "left" } )
	newListing[ "Title" ].x = ( newListing[ "Background" ].x - newListing[ "Background" ].width / 2 ) + newListing[ "Title" ].width / 2 + ( 10 * scaleRatio )
	newListing[ "Title" ].y = newListing[ "Background" ].y
	newListing[ "Title" ]:setFillColor( 0, 0, 0 )

	-- Info
	newListing[ "Info" ] = display.newText( { parent = ui_Groups[ 3 ], text = listingInfo[ "Info" ], font = "Data/Fonts/Roboto.ttf", fontSize = 18 * scaleRatio, align = "center" } )
	newListing[ "Info" ].x = ( newListing[ "Background" ].x + newListing[ "Background" ].width / 2 ) - newListing[ "Info" ].width / 2 - ( 10 * scaleRatio )
	newListing[ "Info" ].y = newListing[ "Background" ].y
	newListing[ "Info" ]:setFillColor( 0, 0, 0 )
	
	-- Add to ScrollView
	scrollView:insert( newListing[ "DropShadow" ] )
	scrollView:insert( newListing[ "Background" ] )
	scrollView:insert( newListing[ "Title" ] )
	scrollView:insert( newListing[ "Info" ] )
	
	return newListing
	
end

local function generateExerciseList( currentList ) -- Generate Exercise List
	
	local lastPosition = 0

	-- Get Current Weight
	currentWeight = savedData[ "Info" ][ "Initial Weight" ]
	
	if ( #savedData[ "Weight Log" ] > 0 ) then -- Get Current Weight (if data entries are available)
	
		currentWeight = savedData[ "Weight Log" ][ #savedData[ "Weight Log" ] ][ "Weight" ]
		
	end
	
	-- Cycle Through Exercises
	for i = 1, #currentList do
		
		-- Calculate Calories Per Hour
		local caloriesPerHour = modules[ "Calculator" ].calcCaloriesBurned( string.lower( currentList[ i ] ), 60, currentWeight )
		local newListingInfo = { 
			[ "Display Name" ] = currentList[ i ], 
			[ "Info" ] = string.format( "%.1f cal/hr", caloriesPerHour ), 
			[ "Item" ] = {
				
					[ "Name" ] = currentList[ i ],
					[ "Category" ] = "Exercise"
					
			},	
			[ "Details" ] = { [ "Serving Type" ] = "Minute" },
			
		}
	
		-- Create Listing
		local newListing = createListing( newListingInfo, i )
		
		lastPosition = newListing[ "Background" ].y + newListing[ "Background" ].height / 2
		
		-- Insert Listing into Table
		table.insert( ui_Objects[ "Items" ], newListing )
	
	end
	
	return lastPosition
	
end

local function generateFoodList( currentList ) -- Generate Food List

	local lastPosition = 0
	
	local itemNumber = 1
	
	-- Cycle Through Food Sections
	for i = 1, #currentList[ "Sections" ] do
		
		-- Get Current Section
		local currentSection = currentList[ currentList[ "Sections" ][ i ] ]
		
		-- Cycle Through Section Food
		for e = 1, #currentSection do
		
			local listingInfo = { 
			
				[ "Display Name" ] = currentSection[ e ][ "Brand" ] .. " | " .. currentSection[ e ][ "Display Name" ], 
				[ "Info" ] = currentSection[ e ][ "Calories" ] .. " cal per " .. string.lower( currentSection[ e ][ "Serving Type" ] ),
				[ "Item" ] = {
				
					[ "Name" ] = currentSection[ e ][ "Display Name" ],
					[ "Category" ] = currentList[ "Sections" ][ i ],
					
				},
				[ "Details" ] = currentSection[ e ],

			}
			
			local newListing = createListing( listingInfo, itemNumber )
			
			lastPosition = newListing[ "Background" ].y + newListing[ "Background" ].height / 2
			
			table.insert( ui_Objects[ "Items" ], newListing )
			
			itemNumber = itemNumber + 1
			
		end
		
	end
		
	return lastPosition
	
end


local function createItemList( ) -- Generate Item List

	-- Remove ScrollView
	if ( ui_Objects[ "Content View" ] ~= nil ) then
	
		removeSections( )
		
	end
	
	-- Create Scroll View
	createContentView( )
	
	local scrollView = ui_Objects[ "Content View" ]
	
	-- Clear Tables
	ui_Objects[ "Items" ] = { }
	
	-- Get Relevant List
	local currentList = itemLists[ currentParameters.Category ]
	
	local lastPosition = 0
	
	-- Select a Function to Generate List
	if ( currentParameters.Category == "Food" ) then
	
		lastPosition = generateFoodList( currentList )
		
	else
	
		lastPosition = generateExerciseList( currentList )
		
	end
	
	-- Create Guide Text
	local newGuideText = display.newText( { parent = ui_Groups[ 3 ], text = "End of " .. currentParameters.Category .. " Items", x = scrollView.width / 2, font = "Data/Fonts/Roboto.ttf", fontSize = ( 32 * scaleRatio ), align = "center" } )
	newGuideText:setFillColor( 0, 0, 0, 0.6 )
	
	newGuideText.height = newGuideText.height * 3
	
	newGuideText.y = lastPosition + newGuideText.height / 2
	
	scrollView:insert( newGuideText )
	
end


local function buttonPress( event ) -- Button Press event.

	local button = event.target
	
	if ( button.myName == "leftActionButton" ) then
	
		-- Lower sectionIndex by one in order to go back to a previous section.
		sectionIndex = sectionIndex - 1
		
		if ( sectionIndex < 1 ) then
		
			sectionIndex = 1
			
		end
		
		loadSection( )
		
	elseif ( button.myName == "Submit" ) then -- Submit Item to Add
		
		-- Check for bad values.
		if ( tonumber( ui_Objects[ "Selection Menu" ][ "Text Input" ].Field.text ) ~= nil ) then
			
			sectionIndex = sectionIndex + 1
			
			loadSection( )
		
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
	
	currentParameters = event.params
	--[[
		
		Parameters:
		Category: Type of Item
		Title: Name of Section

	]]
	
	currentDayLog = modules[ "dayOverview" ].currentDayLog
	
	-- Initialize Lists
	itemLists[ "Food" ] = modules[ "foodRetriever" ].getFoodList( )
	itemLists[ "Exercise" ] = modules[ "metData" ].getExercises( )
	
	
	-- Create UI Groups
	for i = 1, 6 do -- Creates a specified amount of UI group layers. Higher numbers are displayed on top of lower groups.
	
		ui_Groups[ i ] = display.newGroup( )
		sceneGroup:insert( ui_Groups[ i ] )
		
	end
	
	savedData = modules[ "storage" ].getData( )
	
	-- Create Topbar
	ui_Objects[ "Topbar" ] = modules[ "topbarManager" ]:new( { [ "Groups" ] = ui_Groups, [ "Title" ] = "Add " .. currentParameters.Title, [ "NavButtonEnabled" ] = true, [ "NavButtonIcon" ] = "arrow_back", [ "ScaleRatio" ] = scaleRatio } )
	ui_Objects[ "Topbar" ].ui_Objects[ "leftActionButton" ].Button:addEventListener( "tap", buttonPress )

	createItemList( )
	
	-- Selected Item Menu
	ui_Objects[ "Selection Menu" ] = { }
	
	local selectionMenu = ui_Objects[ "Selection Menu" ]
	
	-- Title Text
	selectionMenu[ "Title" ] = display.newText( { parent = ui_Groups[ 5 ], text = "", x = display.contentCenterX, y = display.contentHeight * 0.3, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 42 * scaleRatio, align = "center" } )
	selectionMenu[ "Title" ]:setFillColor( 0, 0, 0, 1 )

	-- Info Text
	selectionMenu[ "Info" ] = display.newText( { parent = ui_Groups[ 5 ], text = "", x = display.contentCenterX, y = display.contentCenterY, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 26 * scaleRatio, align = "left" } )
	selectionMenu[ "Info" ]:setFillColor( 0, 0, 0, 1 )
	
	-- Submit Button
	selectionMenu[ "Submit" ] = { }
	local submitButton = selectionMenu[ "Submit" ]
	
	-- Title
	submitButton.Title = display.newText( { parent = ui_Groups[ 6 ], text = "Record", x = display.contentCenterX, y = display.contentHeight * 0.9, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 32 * scaleRatio, align = "center" } )
	
	-- Button
	submitButton.Button = display.newRoundedRect( ui_Groups[ 5 ], submitButton.Title.x, submitButton.Title.y, submitButton.Title.width, submitButton.Title.height + ( 30 * scaleRatio ), 50 * scaleRatio )
	submitButton.Button:setFillColor( 8 / 255, 127 / 255, 35 / 255 )
	submitButton.Button.myName = "Submit"
	submitButton.Button:addEventListener( "tap", buttonPress )
	
	-- Drop Shadow
	submitButton.DropShadow = display.newRoundedRect( ui_Groups[ 4 ], submitButton.Button.x + 4, submitButton.Button.y + 4, submitButton.Button.width, submitButton.Button.height, 50 * scaleRatio )
	submitButton.DropShadow:setFillColor( 0, 0, 0, 0.25 )	

	-- Create Text Input
	selectionMenu[ "Text Input" ] = { }
	local currentInput = selectionMenu[ "Text Input" ]
	
	-- Text Field
	currentInput.Field = native.newTextField( display.contentCenterX, display.contentHeight * 0.7, display.contentWidth * 0.8, 60 * scaleRatio )
	currentInput.Field.type = "number"
	currentInput.Field.placeholder = "1"
	currentInput.Field.align = "center"
	currentInput.Field:resizeFontToFitHeight( )
	
	currentInput.Field:addEventListener( "userInput", function( event ) 
	
		if ( event.phase == "editing" ) then
			
			if ( tonumber( currentInput.Field.text ) ~= nil ) then

				updateViewer( )
				
			end
			
		end
		
	end )
	
	sceneGroup:insert( currentInput.Field )
	
	-- Title Text
	currentInput.Title = display.newText( { parent = ui_Groups[ 5 ], text = "Amount", x = display.contentCenterX, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 36 * scaleRatio, align = "center" } )
	currentInput.Title.y = ( currentInput.Field.y - currentInput.Field.height / 2 ) - currentInput.Title.height
	
	currentInput.Title:setFillColor( 0, 0, 0, 0.75 )

	-- Warning Text
	currentInput.Warning = display.newText( { parent = ui_Groups[ 5 ], text = "", x = display.contentCenterX, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 36 * scaleRatio, align = "center" } )
	currentInput.Warning.y = ( currentInput.Field.y + currentInput.Field.height * 0.75 ) + currentInput.Warning.height / 2
	currentInput.Warning:setFillColor( 186 / 255, 0 / 255, 13 / 255 )
	
	-- Calories Text
	selectionMenu[ "Calories" ] = display.newText( { parent = ui_Groups[ 5 ], text = "400 Calories", x = display.contentCenterX, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 42 * scaleRatio, align = "center" } )
	selectionMenu[ "Calories" ].y = currentInput.Warning.y + currentInput.Warning.height + selectionMenu[ "Calories" ].height / 2
	selectionMenu[ "Calories" ]:setFillColor( 0, 0, 0, 1 )

end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
		sectionIndex = 2
		loadSection( )
		
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

		setScrollViewVisibility( false )

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
