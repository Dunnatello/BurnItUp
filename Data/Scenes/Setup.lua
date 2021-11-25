--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Scene: Setup
Purpose: Allow the user to set their initial data.

-------------------------


]]
-- Default Libraries
local composer = require( "composer" )
local widget = require( "widget" )

-- Custom Libraries
local storage = require( "Data.Modules.Backend.Storage.storageHandler" )
local dateVerifier = require( "Data.Modules.Backend.dateVerifier" )

local navMenuManager = require( "Data.Modules.UI.navMenuManager" ) -- FIXME: Add Modular Module Loading Code
local topbarManager = require( "Data.Modules.UI.topbarManager" ) -- FIXME: Add Modular Module Loading Code

local scene = composer.newScene( )

-- Tables
local ui_Groups = { }
local ui_Objects = { }

-- Current Section Data
local sectionData = { CurrentSection = "Welcome", SectionIndex = 1 }

-- Section Information
local sections = { 

	[ "Welcome" ] = { 
		DisplayName = "Welcome",
		ButtonText = "Begin",
		Prompt = "Your journey begins with:", 
		Type = "DisplayText", 
		RequiresTextInput = false,
	},
	
	[ "Name" ] = { 
		DisplayName = "Name",
		Setting = "Name",
		ButtonText = "Next",
		Prompt = "What is your name?", 
		Type = "StringInput", 
		RequiresTextInput = true, 
		TextFields = { { Title = "Name", Placeholder = "John", Setting = "Name" } }, 
		InputType = "no-emoji",
	},
	
	-- FIXME: Prompt Gender Input
	
	[ "Age" ] = { 
		DisplayName = "Date of Birth",
		Setting = "Date of Birth",
		ButtonText = "Next",
		Prompt = "What is your birth date? [MM.DD.YYYY]", 
		Type = "DateInput", 
		RequiresTextInput = true, 
		TextFields = { { Title = "Date of Birth", Placeholder = "MM.DD.YYYY", Setting = "Date of Birth" } }, 
		InputType = "number",
	},
	
	[ "Height" ] = { 
		DisplayName = "Height", 
		Setting = "Height",
		ButtonText = "Next",
		Prompt = "What is your height?", 
		Type = "HeightInput", 
		RequiresTextInput = true, 
		TextFields = { { Title = "Height (Feet)", Placeholder = "6", Setting = "Feet" }, { Title = "Height (Inches)", Placeholder = "0", Setting = "Inches" } }, 
		InputType = "number",
	}, 

	[ "Goal" ] = { 
		DisplayName = "Weight Goal",
		ButtonText = "Next",
		Prompt = "What is your weight target?", 
		Type = "WeightInput", 
		RequiresTextInput = true, 
		TextFields = { { Title = "Current Weight (Pounds)", Placeholder = "150.2", Setting = "Initial Weight" }, { Title = "Target Weight (Pounds)", Placeholder = "130", Setting = "Weight Goal" } }, 
		InputType = "number",
	},

	[ "Review" ] = { 
		DisplayName = "Profile Overview",
		InfoTextVisible = true,
		ButtonText = "Submit",
		Prompt = "Overview:\n\n", 
		Type = "DisplayText", 
		RequiresTextInput = false, 
	},
	
}

-- List of All Sections
local sectionList = { "Welcome", "Name", "Age", "Height", "Goal", "Review", "Menu" }

-- Inital Profile Data
local newProfileData = {

	[ "Name" ] = nil,
	[ "Date of Birth" ] = { [ "Month" ] = nil, [ "Day" ] = nil, [ "Year" ] = nil },
	[ "Height" ] = { [ "Feet" ] = nil, [ "Inches" ] = nil }, -- Height in Feet/Inches
	[ "Initial Weight" ] = nil, -- Weight in Pounds
	[ "Weight Goal" ] = nil, -- Weight in Pounds
	[ "Calorie Budget" ] = 2000,
	
}

local currentDate = nil

-- Text Field Stored Inputs
local textFieldData = { 
	
	[ "Name" ] = nil,
	[ "Date of Birth" ] = nil,
	[ "Feet" ] = nil,
	[ "Inches" ] = nil,
	[ "Initial Weight" ] = nil,
	[ "Weight Goal" ] = nil,
	
}

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function submitData( ) -- Submit Data and Goto Menu

	local currentData = storage.getData( )
	
	currentData[ "Info" ] = newProfileData
	storage.saveData( )
	
	composer.gotoScene( "Data.Scenes.Menu", { effect = "crossFade", time = 400 } )
 
end

local function switchSections( ) -- Switch Setup Sections

	if ( sectionData.CurrentSection == "Menu" ) then -- Submit Data and Goto Main Menu
	
		return submitData( )
		
	end
	
	local currentSectionInfo = sections[ sectionData.CurrentSection ] -- Get Current Section Info
	
	-- Determine Whether Back Button Should Be Visible
	local isBackButtonVisible = false
	if ( sectionData.CurrentSection ~= "Welcome" ) then
	
		isBackButtonVisible = true
		
	end
	
	-- Determine Welcome Image and Info Text Visibility
	ui_Objects[ "Welcome Image" ].isVisible = not isBackButtonVisible
	ui_Objects[ "Info" ].isVisible = currentSectionInfo.InfoTextVisible or false
	
	-- Update Topbar Title
	ui_Objects[ "Topbar" ]:setTitle( currentSectionInfo.DisplayName )
	
	ui_Objects[ "Topbar" ]:setActionButtonState( isBackButtonVisible )

	-- Set Prompt & Submit Button Text
	ui_Objects[ "Prompt" ].text = currentSectionInfo.Prompt
	ui_Objects[ "Submit" ].Title.text = currentSectionInfo.ButtonText
	
	-- Display Profile Data Information
	if ( currentSectionInfo.DisplayName == "Profile Overview" ) then
	
		local newText = "Name: " .. textFieldData[ "Name" ] .. "\n\nDate of Birth: " .. currentDate:fmt( "%B %d %G" ) .. "\n\nHeight: " .. newProfileData[ "Height" ][ "Feet" ] .. "' " .. newProfileData[ "Height" ][ "Inches" ] .. "\"\n\nCurrent Weight: " .. newProfileData[ "Initial Weight" ] .. " pounds \n\nTarget Weight: " .. newProfileData[ "Weight Goal" ] .. " pounds"
		ui_Objects[ "Info" ].text = newText
	
	end
	
	-- Update Text Fields
	for i = 1, #ui_Objects[ "Text Inputs" ] do
		
		
		local isFieldVisible = false -- Determine Text Input Visibility
		local currentField = ui_Objects[ "Text Inputs" ][ i ]

		ui_Objects[ "Text Inputs" ][ i ].Warning.isVisible = false -- Reset Text Field Warning
		
		-- Set Text Field Properties
		if ( currentSectionInfo.RequiresTextInput == true and i <= #currentSectionInfo.TextFields ) then
			
			local newFieldText = ""
			if ( textFieldData[ currentSectionInfo.TextFields[ i ].Setting ] ~= nil ) then -- If stored temporary data is available, fill the text boxes text with it.
			
				newFieldText = textFieldData[ currentSectionInfo.TextFields[ i ].Setting ]
				
			end
			
			currentField.Field.text = newFieldText
			
			currentField.Title.text = currentSectionInfo.TextFields[ i ].Title
			currentField.Field.placeholder = currentSectionInfo.TextFields[ i ].Placeholder
			isFieldVisible = true
			
		end
		
		 -- Set Text Input Visibility
		currentField.Field.isVisible = isFieldVisible
		currentField.Title.isVisible = isFieldVisible
		
	end

end

local function generateInputError( errorData ) -- Show Text Field Warning Message

	print( "ERROR: ", errorData.TextField, errorData.Message )
	
	ui_Objects[ "Text Inputs" ][ errorData.TextField ].Warning.text = errorData.Message
	ui_Objects[ "Text Inputs" ][ errorData.TextField ].Warning.isVisible = true

end

local function storeProfileData( newData ) -- Store Profile Data
	
	local currentSectionInfo = sections[ sectionData.CurrentSection ]
	
	if ( newData ~= nil ) then -- Store Passed Data
		
		newProfileData[ currentSectionInfo.Setting ] = newData
	
	else -- Get Text Field Input
		
		for i = 1, #currentSectionInfo.TextFields do
		
			newProfileData[ currentSectionInfo.TextFields[ i ].Setting ] = ui_Objects[ "Text Inputs" ][ i ].Field.text
			
			if ( currentSectionInfo.InputType == "number" ) then -- Prevent Negative Numbers
			
				newProfileData[ currentSectionInfo.TextFields[ i ].Setting ] = math.abs( newProfileData[ currentSectionInfo.TextFields[ i ].Setting ] )
				
			end
			
		end
		
	end
	
	for i = 1, #currentSectionInfo.TextFields do -- Store Temporary Text Field Input
	
		textFieldData[ currentSectionInfo.TextFields[ i ].Setting ] = ui_Objects[ "Text Inputs" ][ i ].Field.text
	
	end
	
	print( "STORE: ", newProfileData[ currentSectionInfo.Setting or "Weight Goal" ] )
	
end

local function checkInput( ) -- Check User Input

	local gotoNextSection = false
	
	local currentSectionInfo = sections[ sectionData.CurrentSection ]
	
	if ( currentSectionInfo.RequiresTextInput == false ) then -- If section doesn't require text input, allow user to advance to the next section.
	
		gotoNextSection = true
		
	else
		
		-- Check for text input issues.
		for i = 1, #currentSectionInfo.TextFields do
			
			if ( string.len( ui_Objects[ "Text Inputs" ][ i ].Field.text ) == 0 ) then -- Text Input Blank
				
				gotoNextSection = false
				generateInputError( { TextField = i, Message = "Required input." } )
				
				return gotoNextSection
				
			end
			
		end
		
		if ( currentSectionInfo.Type == "DateInput" ) then -- Check Date Input
		
			local newDate = dateVerifier.checkDateFromString( ui_Objects[ "Text Inputs" ][ 1 ].Field.text )
			
			if ( newDate ~= nil ) then -- Date Input Correct
			
				gotoNextSection = true
				
				currentDate = newDate
				local newDateData = { [ "Month" ] = currentDate:getmonth( ), [ "Day" ] = currentDate:getday( ), [ "Year" ] = currentDate:getyear( ) }
				storeProfileData( newDateData )
				
			else
			
				generateInputError( { TextField = 1, Message = "Invalid date." } )
				
			end
			
		elseif ( currentSectionInfo.Type == "HeightInput" ) then -- Format height input.

			local newHeightData = { [ "Feet" ] = math.abs( tonumber( ui_Objects[ "Text Inputs" ][ 1 ].Field.text ) ), [ "Inches" ] = math.abs( tonumber( ui_Objects[ "Text Inputs" ][ 2 ].Field.text ) ) }
			storeProfileData( newHeightData )
			
			gotoNextSection = true
		
		else -- Every other input type.
			
			storeProfileData( )
			gotoNextSection = true
			
		end
		
	end
	
	return gotoNextSection
	
end

local function buttonPress( event ) -- Button Press

	local button = event.target
	
	if ( button.myName == "Submit" ) then -- Check Input
	
		local gotoNextSection = checkInput( )
				
		-- Advance to Next Section (If Allowed).
		if ( gotoNextSection == true ) then
			
			if ( sectionData.SectionIndex ~= #sectionList ) then
			
				sectionData.SectionIndex = sectionData.SectionIndex + 1
				sectionData.CurrentSection = sectionList[ sectionData.SectionIndex ]
				
				switchSections( )
				
			end
	
		end
		
	elseif ( button.myName == "leftActionButton" ) then -- Go Back
		
		if ( sectionData.SectionIndex > 1 ) then
		
			sectionData.SectionIndex = sectionData.SectionIndex - 1
			sectionData.CurrentSection = sectionList[ sectionData.SectionIndex ]

			switchSections( )
			
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
	
	-- Topbar
	ui_Objects[ "Topbar" ] = topbarManager:new( { [ "Groups" ] = ui_Groups, [ "Title" ] = "Test", [ "NavButtonEnabled" ] = true, [ "NavButtonIcon" ] = "arrow_back" } )
	ui_Objects[ "Topbar" ].ui_Objects[ "leftActionButton" ].Button:addEventListener( "tap", buttonPress )
	
	-- Prompt Text
	ui_Objects[ "Prompt" ] = display.newText( { parent = ui_Groups[ 3 ], text = "What is your birth date? [MM/DD/YYYY]", x = display.contentCenterX, y = display.contentHeight * 0.3, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 60, align = "center" } )
	ui_Objects[ "Prompt" ]:setFillColor( 0, 0, 0, 1 )

	-- Info Text
	ui_Objects[ "Info" ] = display.newText( { parent = ui_Groups[ 3 ], text = "", x = display.contentCenterX, y = display.contentCenterY, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 60, align = "left" } )
	ui_Objects[ "Info" ]:setFillColor( 0, 0, 0, 1 )
	
	-- Welcome Image
	ui_Objects[ "Welcome Image" ] = display.newImageRect( ui_Groups[ 3 ], "Data/Assets/Welcome.png", display.contentWidth * 0.5, ( 932 / 1020 ) * ( display.contentWidth * 0.5 ) )
	ui_Objects[ "Welcome Image" ].x, ui_Objects[ "Welcome Image" ].y = display.contentCenterX, display.contentCenterY

	
	-- Submit Button
	ui_Objects[ "Submit" ] = { }
	local submitButton = ui_Objects[ "Submit" ]
	
	-- Title
	submitButton.Title = display.newText( { parent = ui_Groups[ 3 ], text = "Next", x = display.contentCenterX, y = display.contentHeight * 0.9, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 60, align = "center" } )
	
	-- Button
	submitButton.Button = display.newRoundedRect( ui_Groups[ 2 ], submitButton.Title.x, submitButton.Title.y, submitButton.Title.width, submitButton.Title.height + 30, 50 )
	submitButton.Button:setFillColor( 8 / 255, 127 / 255, 35 / 255 )
	submitButton.Button.myName = "Submit"
	submitButton.Button:addEventListener( "tap", buttonPress )
	
	-- Drop Shadow
	submitButton.DropShadow = display.newRoundedRect( ui_Groups[ 1 ], submitButton.Button.x + 4, submitButton.Button.y + 4, submitButton.Button.width, submitButton.Button.height, 50 )
	submitButton.DropShadow:setFillColor( 0, 0, 0, 0.25 )	
	
	-- Text Input Creation
	ui_Objects[ "Text Inputs" ] = { }
	
	for i = 1, 2 do
	
		-- Create Listing
		ui_Objects[ "Text Inputs" ][ i ] = { }
		local currentInput = ui_Objects[ "Text Inputs" ][ i ]
		
		-- Text Field
		currentInput.Field = native.newTextField( display.contentCenterX, display.contentCenterY + ( 72 * 5 ) * ( i - 1 ), display.contentWidth * 0.8, 72 * 1.5 )
		currentInput.Field.align = "center"
		currentInput.Field:resizeFontToFitHeight( )
		
		sceneGroup:insert( currentInput.Field )
		
		-- Title Text
		currentInput.Title = display.newText( { parent = ui_Groups[ 3 ], text = "", x = display.contentCenterX, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 60, align = "center" } )
		currentInput.Title.y = ( currentInput.Field.y - currentInput.Field.height / 2 ) - currentInput.Title.height
		
		currentInput.Title:setFillColor( 0, 0, 0, 0.75 )
	
		-- Warning Text
		currentInput.Warning = display.newText( { parent = ui_Groups[ 3 ], text = "Missing text.", x = display.contentCenterX, width = display.contentWidth * 0.8, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 56, align = "center" } )
		currentInput.Warning.y = ( currentInput.Field.y + currentInput.Field.height * 0.75 ) + currentInput.Warning.height / 2
		currentInput.Warning:setFillColor( 186 / 255, 0 / 255, 13 / 255 )
		currentInput.Warning.isVisible = false
	
	end
	

	
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	
		switchSections( )
		
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

		for i = 1, #ui_Objects[ "Text Inputs" ] do
		
			ui_Objects[ "Text Inputs" ][ i ].Field.isVisible = false
			
		end
		
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

		for i = 1, #ui_Objects[ "Text Inputs" ] do
		
			display.remove( ui_Objects[ "Text Inputs" ][ i ].Field )
			
		end
		
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
