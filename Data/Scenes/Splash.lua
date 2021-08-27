--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Sharkbait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Scene: Splash
Purpose: Show the group logo and then transition to the menu.

-------------------------

]]

local composer = require( "composer" )

local scene = composer.newScene( )

local ui_Groups = { }
local ui_Objects = { }

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local function gotoScene( sceneName ) -- Transition to a new scene.

	composer.gotoScene( sceneName, { time = 400, effect = "crossFade" } )
	
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	for i = 1, 2 do -- Creates a specified amount of UI group layers. Higher numbers are displayed on top of lower groups.
	
		ui_Groups[ i ] = display.newGroup( )
		sceneGroup:insert( ui_Groups[ i ] )
		
	end
	
	ui_Objects[ "Logo" ] = display.newImageRect( ui_Groups[ 2 ], "Data/Assets/GroupLogo.png", display.contentWidth * 0.75, display.contentWidth * 0.75 )
	ui_Objects[ "Logo" ].x, ui_Objects[ "Logo" ].y = display.contentCenterX, display.contentCenterY

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
			
		display.setDefault( "background", 243 / 255, 234 / 255, 225 / 255 )
		
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		
		timer.performWithDelay( 1000, function( ) gotoScene( "Data.Scenes.Menu" ) end ) -- Transition to a new scene after a certain amount of seconds have passed.
		
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
