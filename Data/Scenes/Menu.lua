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

local navMenuManager = require( "Data.Modules.UI.navMenuManager" ) -- FIXME: Add Modular Module Loading Code
local topbarManager = require( "Data.Modules.UI.topbarManager" ) -- FIXME: Add Modular Module Loading Code

-- Tables
local ui_Groups = { }
local ui_Objects = { }

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function buttonPress( event )

	local button = event.target
	
	if ( button.myName == "leftActionButton" ) then
	
		ui_Objects[ "NavMenu" ]:setMenuVisibility( true )
	
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
	
	ui_Objects[ "Topbar" ] = topbarManager:new( { [ "Groups" ] = ui_Groups, [ "Title" ] = "Burn it Up!" } )
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
	ui_Objects[ "NavMenu" ] = navMenuManager:new( sceneData )
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
	
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
