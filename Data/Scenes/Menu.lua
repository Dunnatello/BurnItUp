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

-- Tables
local ui_Groups = { }
local ui_Objects = { }

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




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
	
	-- Create Topbar
	local topbarHeight = ( 72 * 2 )
	ui_Objects[ "Topbar" ] = { }
	
	-- Bar
	ui_Objects[ "Topbar" ].Bar = display.newRect( ui_Groups[ 2 ], display.contentCenterX, ( topbarHeight + display.topStatusBarContentHeight ) / 2, display.contentWidth, topbarHeight + display.topStatusBarContentHeight )
	ui_Objects[ "Topbar" ].Bar:setFillColor( 76 / 255, 175 / 255, 80 / 255 )

	-- Drop Shadow
	ui_Objects[ "Topbar" ].DropShadow = display.newRect( ui_Groups[ 1 ], ui_Objects[ "Topbar" ].Bar.x, ui_Objects[ "Topbar" ].Bar.y + ( ui_Objects[ "Topbar" ].Bar.height * 0.025 ), ui_Objects[ "Topbar" ].Bar.width, ui_Objects[ "Topbar" ].Bar.height )
	ui_Objects[ "Topbar" ].DropShadow:setFillColor( 0, 0, 0, 0.25 )
	
	-- Buttons
	
	-- Back Button
	ui_Objects[ "Topbar" ].BackButton = { }
	local backButton = ui_Objects[ "Topbar" ].BackButton
	
	backButton.Button = display.newCircle( ui_Groups[ 2 ], 60 * 1.5, display.topStatusBarContentHeight + 60, 60 )
	backButton.Button:setFillColor( 8 / 255, 127 / 255, 35 / 255 )
	
	backButton.Button.isVisible = false

	backButton.Text = display.newText( { parent = ui_Groups[ 3 ], text = "arrow_back", x = backButton.Button.x, y = backButton.Button.y, font = "Data/Fonts/MaterialIcons-Regular.ttf", fontSize = 72 } )

	-- Settings Button
	ui_Objects[ "Topbar" ].SettingsButton = { }
	local settingsButton = ui_Objects[ "Topbar" ].SettingsButton
	
	settingsButton.Button = display.newCircle( ui_Groups[ 2 ], display.contentWidth - 60 * 1.5, display.topStatusBarContentHeight + 60, 60 )
	settingsButton.Button:setFillColor( 8 / 255, 127 / 255, 35 / 255 )
	
	settingsButton.Button.isVisible = false
	
	settingsButton.Text = display.newText( { parent = ui_Groups[ 3 ], text = "settings", x = settingsButton.Button.x, y = settingsButton.Button.y, font = "Data/Fonts/MaterialIcons-Regular.ttf", fontSize = 72 } )	

	-- Topbar Title
	ui_Objects[ "Topbar" ].Title = display.newText( { parent = ui_Groups[ 3 ], text = "Burn it Up!", font = "Data/Fonts/Roboto.ttf", fontSize = 72 } )
	ui_Objects[ "Topbar" ].Title.x = ( backButton.Button.x + backButton.Button.width * 0.6 ) + ui_Objects[ "Topbar" ].Title.width / 2
	ui_Objects[ "Topbar" ].Title.y = backButton.Button.y
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
		display.setDefault( "background", 245 / 255, 245 / 255, 245 / 255 ) -- FIXME: Add Color Theme Support
	
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
