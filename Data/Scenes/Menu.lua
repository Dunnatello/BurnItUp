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

-- Values
local currentDate
local currentDayLog
local scaleRatio = 1

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

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

	elseif ( button.myName == "leftActionButton" ) then
		
		if ( ui_Objects[ "Add Menu" ].isVisible == false ) then
			
			ui_Objects[ "NavMenu" ]:setMenuVisibility( true )
			modules[ "createMenuSections" ].setScrollViewVisibility( false )

		end
	
	elseif ( button.myName == "Add" or button.myName == "Close" ) then
		
		local isVisible = button.myName == "Close"
		modules[ "createMenuSections" ].setScrollViewVisibility( isVisible )
		
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
	ui_Objects[ "Topbar" ] = modules[ "topbarManager" ]:new( { [ "Groups" ] = ui_Groups, [ "Title" ] = "Burn it Up!" } )
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
