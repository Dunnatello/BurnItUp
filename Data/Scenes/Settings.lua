--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Scene: Settings
Purpose: Allow the user to edit app preferences and give the option to view the credits.

-------------------------


]]
local composer = require( "composer" )

local scene = composer.newScene( )

local moduleNames = { 

	-- UI
	{ Name = "navMenuManager", Location = "Data.Modules.UI.navMenuManager" },
	{ Name = "topbarManager", Location = "Data.Modules.UI.topbarManager" },
	{ Name = "scaler", Location = "Data.Modules.UI.scaler" },
	{ Name = "storage", Location = "Data.Modules.Backend.Storage.storageHandler" },
	
	-- Solar2D (Corona SDK) Built-In Library
	{ Name = "graphics", Location = "graphics" },
	{ Name = "widget", Location = "widget" },

	
}

local modules = { }

for i = 1, #moduleNames do
	
	modules[ moduleNames[ i ].Name ] = require( moduleNames[ i ].Location )
	
end

-- Tables
local ui_Groups = { }
local ui_Objects = { }

local settingsList = { 
	
	{ 
	
		[ "Name" ] = "Delete Saved Data",
		[ "Type" ] = "Button",
		[ "Text" ] = "Delete",
		[ "Button Info" ] = { [ "Name" ] = "Delete Save" }
		
	}


}

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------



local function setScrollViewVisibility( newStatus ) -- Set ScrollView Visibility State

	ui_Objects[ "Content View" ].isVisible = newStatus
	
end


local function onPromptEnd( event ) -- Native Prompt Ended

	if ( event.action == "clicked"  ) then
	
		local i = event.index
		
		if ( i == 1 ) then -- Delete Item
			
			local isSuccessful = modules[ "storage" ].deleteData( )
			
			if ( isSuccessful == true ) then
				
				print( "Delete Successful" )
				composer.removeHidden( )
				composer.gotoScene( "Data.Scenes.Splash", { effect = "crossFade", time = 400 } )
	
			end
			
		
		elseif ( i == 2 ) then -- Do nothing. User cancelled the action.
		
		end
		
	end
	
end

local function showPrompt( messageInfo ) -- Prompt User with Choices

	native.showAlert( messageInfo[ "Title" ], messageInfo[ "Message" ], { "Delete", "Cancel" }, onPromptEnd )
	
end

local function buttonPress( event )

	local button = event.target
	
	if ( button.myName == "leftActionButton" ) then
	
		ui_Objects[ "NavMenu" ]:setMenuVisibility( true )
		setScrollViewVisibility( false )
	
	elseif ( button.myName == "Close" ) then
	
		setScrollViewVisibility( true )
		
	end
	
end

local function settingButtonPress( event )

	local button = event.target
	
	if ( button.myName[ "Name" ] == "Delete Save" ) then
	
		showPrompt( { [ "Title" ] = "Delete All Data", [ "Message" ] = "Delete all data from this app? This cannot be undone." } )
		
	end
	
end

local function createSettings( )

	ui_Objects[ "Settings" ] = { }
	
	local lastPosition = 0
	for i = 1, #settingsList do
	
		local newSetting = { }
		
		newSetting[ "Title" ] = display.newText( { parent = ui_Groups[ 3 ], text = settingsList[ i ][ "Name" ], x = ui_Objects[ "Content View" ].width / 2, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = ( 36 * scaleRatio ), align = "center" } )
		newSetting[ "Title" ].y = lastPosition + newSetting[ "Title" ].height / 2 + ( 30 * scaleRatio )
		newSetting[ "Title" ]:setFillColor( 0, 0, 0, 0.75 )
		
		
		if ( settingsList[ i ][ "Type" ] == "Button" ) then
		
			newSetting[ "Button" ] = { }
			newSetting[ "Button" ][ "Text" ] = display.newText( { parent = ui_Groups[ 3 ], text = settingsList[ i ][ "Text" ], x = ui_Objects[ "Content View" ].width / 2, font = "Data/Fonts/Roboto.ttf", fontSize = ( 28 * scaleRatio ), align = "center" } )
			newSetting[ "Button" ][ "Text" ].y = ( newSetting[ "Title" ].y + newSetting[ "Title" ].height / 2 ) + newSetting[ "Button" ][ "Text" ].height * 1.5
			
			newSetting[ "Button" ][ "Background" ] = display.newRoundedRect( ui_Groups[ 2 ], newSetting[ "Button" ][ "Text" ].x, newSetting[ "Button" ][ "Text" ].y, newSetting[ "Button" ][ "Text" ].width + ( 70 * scaleRatio ), newSetting[ "Button" ][ "Text" ].height + ( 20 * scaleRatio ), 30 * scaleRatio )
			newSetting[ "Button" ][ "Background" ]:setFillColor( 8 / 255, 127 / 255, 35 / 255 )
			
			newSetting[ "Button" ][ "Background" ].myName = settingsList[ i ][ "Button Info" ]
			newSetting[ "Button" ][ "Background" ]:addEventListener( "tap", settingButtonPress )
			
			newSetting[ "Button" ][ "Drop Shadow" ] = display.newRoundedRect( ui_Groups[ 1 ], newSetting[ "Button" ][ "Background" ].x + ( 2 * scaleRatio ), newSetting[ "Button" ][ "Background" ].y + ( 2 * scaleRatio ), newSetting[ "Button" ][ "Background" ].width, newSetting[ "Button" ][ "Background" ].height, 30 * scaleRatio )
			newSetting[ "Button" ][ "Drop Shadow" ]:setFillColor( 0, 0, 0, 0.25 )
		
			ui_Objects[ "Content View" ]:insert( newSetting[ "Button" ][ "Drop Shadow" ] )
			ui_Objects[ "Content View" ]:insert( newSetting[ "Button" ][ "Background" ] )
			ui_Objects[ "Content View" ]:insert( newSetting[ "Button" ][ "Text" ] )
			
			lastPosition = newSetting[ "Button" ][ "Background" ].y + newSetting[ "Button" ][ "Background" ].height / 2
		
		else -- All other settings.
		
			lastPosition = newSetting[ "Title" ].y + newSetting[ "Title" ].height / 2
			
		end
		
		ui_Objects[ "Content View" ]:insert( newSetting[ "Title" ] )
		-- ui_Objects[ "Content View" ]:insert( newIcon[ "Icon" ] )
		-- ui_Objects[ "Content View" ]:insert( newIcon[ "Title" ] )
		-- ui_Objects[ "Content View" ]:insert( newIcon[ "Profile" ] )
		
		table.insert( ui_Objects[ "Settings" ], newSetting )
		
		
		
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

	-- Generate Scale Ratio for Additional Text/Content Scaling
	scaleRatio = modules[ "scaler" ].new( )
	
	-- Create Topbar
	ui_Objects[ "Topbar" ] = modules[ "topbarManager" ]:new( { [ "Groups" ] = ui_Groups, [ "Title" ] = "Settings", [ "ScaleRatio" ] = scaleRatio } )
	ui_Objects[ "Topbar" ].ui_Objects[ "leftActionButton" ].Button:addEventListener( "tap", buttonPress )

	local sceneData = { 
		
		[ "SceneName" ] = "Settings",
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

	ui_Objects[ "Circle Mask" ] = modules[ "graphics" ].newMask( "Data/Assets/CircleMask1024x.png" )
	
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
	
	createSettings( )
	

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

		setScrollViewVisibility( true )

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
