--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Scene: Menu
Purpose: Scene that allows the user to interact with the app functions and can transition to other scenes when prompted.

-------------------------

]]

local composer = require( "composer" )

local scene = composer.newScene( )


local moduleNames = { 

	-- UI
	{ Name = "navMenuManager", Location = "Data.Modules.UI.navMenuManager" },
	{ Name = "createMenuSections", Location = "Data.Modules.UI.createMenuSections" },
	{ Name = "dayOverview", Location = "Data.Modules.UI.dayOverview" },
	{ Name = "topbarManager", Location = "Data.Modules.UI.topbarManager" },
	{ Name = "addMenuManager", Location = "Data.Modules.UI.addMenuManager" },
	{ Name = "scaler", Location = "Data.Modules.UI.scaler" },

	-- Backend
	{ Name = "storage", Location = "Data.Modules.Backend.Storage.storageHandler" },
	{ Name = "itemHandler", Location = "Data.Modules.Backend.itemHandler" },
	
	-- Solar2D (Corona SDK) Built-In Libraries
	{ Name = "widget", Location = "widget" },

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

local transitionDirections = { [ false ] = -1, [ true ] = 1 } -- -1: Left; 1: Right

-- Values
local currentDate
local currentDayLog
local scaleRatio = 1

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function clampValue( currentValue, minVal, maxVal )

	local newValue = currentValue
	
	if ( currentValue > maxVal ) then
		
		newValue = maxVal
	elseif ( currentValue < minVal ) then
	
		newValue = minVal
		
	end
	
	return newValue
	
end

local function getNewToggleButtonPosition( button, newState )

	local newHorizontalOffset = ( ( button[ "Bar" ].width / 2 + ( 2 * scaleRatio ) - button[ "Button" ].width / 2 ) * transitionDirections[ newState ] )

	local selectionTransitionOffsets = {
		
		[ false ] = { x = button[ "Bar" ].x - math.abs( newHorizontalOffset ) },
		[ true ] = { x = button[ "Bar" ].x },
		
	}
		
	return newHorizontalOffset, selectionTransitionOffsets
end

local function cancelToggleTransitions( button )

	if ( button[ "Transition" ] ~= nil ) then
		
		transition.cancel( button[ "Transition" ] )
		transition.cancel( button[ "Selection Transition" ] )
		
		button[ "Transition" ] = nil
		button[ "Selection Transition" ] = nil
		
	end
		
end

local function animateToggleButton( button, newState )
	
	if ( button[ "Debounce" ] ~= true ) then
		
		cancelToggleTransitions( button )
		
		local newHorizontalOffset, selectionTransitionOffsets = getNewToggleButtonPosition( button, newState )

		button[ "Debounce" ] = true 
		
		-- Button Transition
		button[ "Transition" ] = transition.to( button[ "Button" ], 
			{ 
				x = button[ "Bar" ].x + newHorizontalOffset, 
				time = 100, 
				transition = easing.linear, 
				onComplete = function( ) 
				
					button[ "Debounce" ] = false
					
				end
			}
			
		)
		
		-- Selection Bar Transition
		button[ "Selection Transition" ] = transition.to( button[ "Selection" ], 
			{ 
				x = selectionTransitionOffsets[ newState ].x,
				width = ( button[ "Bar" ].width * 0.45 ) + clampValue( ( button[ "Bar" ].width * 0.55 ) * transitionDirections[ newState ], 0, button[ "Bar" ].width * 0.55 ), -- Minimum Size: 45%; Maximum Size: 100% ( 0.45 + 0.55 )
				time = 100, 
				transition = easing.linear, 
			}
			
		)
		
		button[ "State" ] = newState
		
	end
	
	
end

local function setToggleButtonPosition( button, newState )
	
	cancelToggleTransitions( button )

	local newHorizontalOffset, selectionTransitionOffsets = getNewToggleButtonPosition( button, newState )
	
	-- Button
	button[ "Button" ].x = button[ "Bar" ].x + newHorizontalOffset
	
	-- Selection Bar
	button[ "Selection" ].x = selectionTransitionOffsets[ newState ].x
	button[ "Selection" ].width = ( button[ "Bar" ].width * 0.45 ) + clampValue( ( button[ "Bar" ].width * 0.55 ) * transitionDirections[ newState ], 0, button[ "Bar" ].width * 0.55 )
	
end

local function toggleButtonPress( button )

	
	if ( button[ "Debounce" ] ~= true and ui_Objects[ "NavMenu" ].isVisible == false and ui_Objects[ "Add Menu" ].isVisible == false ) then
		
		if ( button[ "Button" ].myName == "End Tracking" ) then
		
			modules[ "dayOverview" ].currentDayLog[ "Done" ] = not modules[ "dayOverview" ].currentDayLog[ "Done" ]
			
			if ( savedData[ "Calorie Log" ][ currentDate:fmt( "%F" ) ] == nil ) then -- Data hasn't been saved. Most likely a blank day.
			
				savedData[ "Calorie Log" ][ currentDate:fmt( "%F" ) ] = modules[ "dayOverview" ].currentDayLog
				
			end
			
			modules[ "storage" ].saveData( )
			
		end
		
		animateToggleButton( button, not button[ "State" ] )
	
	end
	
end

local function buttonPress( event )

	local button = event.target
	
	if ( button.type == "DayNavigation" ) then
	
		local dayIncrement = -1
		if ( button.myName == "chevron_right" ) then
		
			dayIncrement = dayIncrement * -1
			
		end
		
		print( "DAY INCREMENT: ", dayIncrement )
		modules[ "dayOverview" ].currentDate:adddays( dayIncrement )
		composer.setVariable( "CurrentDate", modules[ "dayOverview" ].currentDate )

		modules[ "dayOverview" ].update( )
		--modules[ "createMenuSections" ].createSections( ui_Groups, ui_Objects, scaleRatio, savedData[ "Calorie Log" ][ currentDate:fmt( "%F" ) ] )
		modules[ "createMenuSections" ].createSections( ui_Groups, ui_Objects, scaleRatio, modules[ "dayOverview" ].currentDayLog )
	
		ui_Objects[ "End Tracking" ][ "State" ] = modules[ "dayOverview" ].currentDayLog[ "Done" ]
		setToggleButtonPosition( ui_Objects[ "End Tracking" ], ui_Objects[ "End Tracking" ][ "State" ] )
		
	elseif ( button.myName == "leftActionButton" ) then
		
		if ( ui_Objects[ "Add Menu" ].isVisible == false ) then
			
			ui_Objects[ "NavMenu" ]:setMenuVisibility( true )
			modules[ "createMenuSections" ].setScrollViewVisibility( false )

		end
	
	elseif ( button.myName == "Add" or button.myName == "Close" ) then
		
		local isVisible = button.myName == "Close"
		modules[ "createMenuSections" ].setScrollViewVisibility( isVisible )
		
		ui_Objects[ "NavMenu" ]:setMenuVisibility( false )
		
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
	for i = 1, 4 do -- Creates a specified amount of UI group layers. Higher numbers are displayed on top of lower groups.
	
		ui_Groups[ i ] = display.newGroup( )
		sceneGroup:insert( ui_Groups[ i ] )
		
	end
	
	-- Get User Data
	savedData = modules[ "storage" ].getData( )

	-- Generate Scale Ratio for Additional Text/Content Scaling
	scaleRatio = modules[ "scaler" ].new( )
	
	-- Create Topbar
	ui_Objects[ "Topbar" ] = modules[ "topbarManager" ]:new( { [ "Groups" ] = ui_Groups, [ "Title" ] = "Burn it Up!", [ "ScaleRatio" ] = scaleRatio } )
	ui_Objects[ "Topbar" ].ui_Objects[ "leftActionButton" ].Button:addEventListener( "tap", buttonPress )

	local sceneData = { 
		
		[ "SceneName" ] = "Menu",
		[ "SceneGroup" ] = sceneGroup,
		
		[ "Buttons" ] = {
		
			{ [ "Title" ] = "Week", [ "Icon" ] = "calendar_view_week", [ "Scene" ] = "Overview" },
			{ [ "Title" ] = "Log", [ "Icon" ] = "monitor_weight", [ "Scene" ] = "Menu" },
			{ [ "Title" ] = "Goals", [ "Icon" ] = "flag", [ "Scene" ] = "Goals" },
			{ [ "Title" ] = "Settings", [ "Icon" ] = "settings", [ "Scene" ] = "Settings" },
			{ [ "Title" ] = "Info", [ "Icon" ] = "info", [ "Scene" ] = "Credits" },
		
		},
	
	}

	-- Create Navigation Menu
	ui_Objects[ "NavMenu" ] = modules[ "navMenuManager" ]:new( sceneData )
	ui_Objects[ "NavMenu" ].menu[ "NavMenu" ][ "Close" ][ "Button" ]:addEventListener( "tap", buttonPress )
	
	local addMenuData = { 
			
			[ "SceneName" ] = "Menu", 
			[ "SceneGroup" ] = sceneGroup, 
			[ "Scene UI Groups" ] = ui_Groups,
			
			[ "Buttons" ] = { 
			
				{ 
					[ "Category" ] = "Health",
					[ "Buttons" ] = { 
					
						{ [ "Title" ] = "Weight", [ "Icon" ] = "monitor_weight", [ "Icon Color" ] = { R = 66 / 255, G = 165 / 255, B = 245 / 255 }, [ "Section" ] = "Weight" }, -- #42a5f5
						{ [ "Title" ] = "Exercise", [ "Icon" ] = "fitness_center", [ "Icon Color" ] = { R = 112 / 255, G = 112 / 255, B = 112 / 255 }, [ "Section" ] = "Exercise" }, -- #ffc107

					},
				
				},
				
				{ 
					[ "Category" ] = "Food",
					[ "Buttons" ] = { 
					
						{ [ "Title" ] = "Breakfast", [ "Icon" ] = "breakfast_dining", [ "Icon Color" ] = { R = 169 / 255, G = 130 / 255, B = 116 / 255 }, [ "Section" ] = "Food" }, -- #a98274
						{ [ "Title" ] = "Lunch", [ "Icon" ] = "lunch_dining", [ "Icon Color" ] = { R = 255 / 255, G = 202 / 255, B = 40 / 255 }, [ "Section" ] = "Food" }, -- #ffca28
						{ [ "Title" ] = "Dinner", [ "Icon" ] = "dinner_dining", [ "Icon Color" ] = { R = 171 / 255, G = 71 / 255, B = 188 / 255 }, [ "Section" ] = "Food" }, -- #ab47bc

					},
				
				},
				
			
			},

		} 
		
	-- Create Add Menu
	ui_Objects[ "Add Menu" ] = modules[ "addMenuManager" ]:new( addMenuData )
	
	-- Add Button Listeners to Toggle the ScrollView Visibility
	ui_Objects[ "Add Menu" ].menu[ "Add Menu" ][ "Add Button" ].Button:addEventListener( "tap", buttonPress )
	ui_Objects[ "Add Menu" ].menu[ "Add Menu" ][ "Close Button" ].Button:addEventListener( "tap", buttonPress )
	
	-- Get Current Date
	currentDate = modules[ "dateLibrary" ]( false )
	composer.setVariable( "CurrentDate", currentDate )
	
	-- Create Day Overview
	modules[ "dayOverview" ].create( ui_Objects, ui_Groups, scaleRatio, savedData, currentDate )

	local overview = ui_Objects[ "Day Overview" ]
	
	for i = 1, #overview[ "Nav Arrows" ] do
		
		overview[ "Nav Arrows" ][ i ].Icon:addEventListener( "tap", buttonPress )
		
	end
	modules[ "dayOverview" ].update( )


	-- Create "End Day" Toggle
	
	ui_Objects[ "End Tracking" ] = { }

	local endToggle = ui_Objects[ "End Tracking" ]
	endToggle[ "State" ] = modules[ "dayOverview" ].currentDayLog[ "Done" ]
	
	-- Button
	endToggle[ "Button" ] = display.newCircle( ui_Groups[ 3 ], 0, 0, 25 * scaleRatio )
	endToggle[ "Button" ]:setFillColor( 76 / 255, 175 / 255, 80 / 255 )

	-- Button Stroke Properties
	endToggle[ "Button" ]:setStrokeColor( 0, 0, 0, 0.25 )
	endToggle[ "Button" ].strokeWidth = 2 * scaleRatio
	
	endToggle[ "Button" ].myName = "End Tracking"
	endToggle[ "Button" ]:addEventListener( "tap", function( ) toggleButtonPress( endToggle ) end )
	
	-- Bar
	endToggle[ "Bar" ] = display.newRoundedRect( ui_Groups[ 2 ], 0, 0, endToggle[ "Button" ].width * 2, endToggle[ "Button" ].width * 0.75, 50 * scaleRatio )
	endToggle[ "Bar" ]:setFillColor( 199 / 255, 199 / 255, 199 / 255 )
	endToggle[ "Bar" ]:addEventListener( "tap", function( ) toggleButtonPress( endToggle ) end )

	endToggle[ "Bar" ].x, endToggle[ "Bar" ].y = display.contentCenterX, display.contentHeight - endToggle[ "Bar" ].height * 1.5
	
	-- Bar Selection (For Animation On Position)
	endToggle[ "Selection" ] = display.newRoundedRect( ui_Groups[ 2 ], endToggle[ "Bar" ].x, endToggle[ "Bar" ].y, endToggle[ "Bar" ].width, endToggle[ "Bar" ].height, 50 * scaleRatio )
	
	endToggle[ "Selection" ]:setFillColor( 51 / 255, 138 / 255, 62 / 255 )

	-- Bar Drop Shadow
	endToggle[ "Bar Drop Shadow" ] = display.newRoundedRect( ui_Groups[ 1 ], endToggle[ "Bar" ].x + ( 2 * scaleRatio ), endToggle[ "Bar" ].y + ( 2 * scaleRatio ), endToggle[ "Bar" ].width, endToggle[ "Bar" ].height, 50 * scaleRatio )
	endToggle[ "Bar Drop Shadow" ]:setFillColor( 0, 0, 0, 0.25 )
	
	endToggle[ "Button" ].x, endToggle[ "Button" ].y = ( endToggle[ "Bar" ].x + endToggle[ "Bar" ].width / 2 ) - endToggle[ "Button" ].width / 2 + ( 2 * scaleRatio ), endToggle[ "Bar" ].y
	
	-- Title
	endToggle[ "Title" ] = display.newText( { parent = ui_Groups[ 3 ], text = "Done Logging", x = endToggle[ "Bar" ].x, font = "Data/Fonts/Roboto.ttf", fontSize = 32 * scaleRatio, align = "center" } )
	endToggle[ "Title" ]:setFillColor( 0, 0, 0, 0.75 )
	
	endToggle[ "Title" ].y = ( endToggle[ "Bar" ].y - endToggle[ "Bar" ].height / 2 ) - endToggle[ "Title" ].height
	
	setToggleButtonPosition( endToggle, endToggle[ "State" ] )
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
		modules[ "dayOverview" ].update( )
		--modules[ "createMenuSections" ].createSections( ui_Groups, ui_Objects, scaleRatio, savedData[ "Calorie Log" ][ currentDate:fmt( "%F" ) ] )
		modules[ "createMenuSections" ].createSections( ui_Groups, ui_Objects, scaleRatio, modules[ "dayOverview" ].currentDayLog )

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		
		modules[ "createMenuSections" ].setScrollViewVisibility( true )
		
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

		modules[ "createMenuSections" ].setScrollViewVisibility( false )
		
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
