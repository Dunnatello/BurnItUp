--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Object Module: Navigation Menu Manager
Purpose: Creates the navigation menu for the current scene so that the user can transition from scene to scene.

-------------------------

Inspired by this tutorial: https://www.tutorialspoint.com/lua/lua_object_oriented.htm

]]

local composer = require( "composer" )

navMenu = { 

	-- Object Public Variables
	
	currentScene = nil,
	menu = { },
	
}


function navMenu:setMenuVisibility( newVisibilityState ) -- Close Object Menu
	
	print( "SET MENU VISIBLITY", newVisibilityState, self.currentScene )
	
	for i = 1, #self.ui_Groups do
		
		self.ui_Groups[ i ].isVisible = newVisibilityState
		
	end
	
end

function navMenu:buttonPress( button )
	
	print( button.myName )
	
	if ( button.buttonType == "Scene" and button.myName ~= self.currentScene ) then
	
		composer.gotoScene( "Data.Scenes." .. button.myName, { effect = "crossFade", time = 300 } )
		
		self:setMenuVisibility( false )
		
	end
	
end


function navMenu:createMenu( sceneData )  -- Create Navigation Menu for Scene
		
	-- Create Additional UI Scene Groups
	self.ui_Groups = { }
	local ui_Groups = self.ui_Groups
	
	for i = 1, 6 do 
	
		ui_Groups[ i ] = display.newGroup( )
		sceneData[ "SceneGroup" ]:insert( ui_Groups[ i ] )
		
	end
	
	-- Create Menu Background
	self.menu[ "NavMenu" ] = { }
	
	self.currentScene = sceneData[ "SceneName" ]
	
	local navMenu = self.menu[ "NavMenu" ]
	
	-- Scrim
	navMenu[ "Scrim" ] = display.newRect( ui_Groups[ 1 ], display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	navMenu[ "Scrim" ]:setFillColor( 0, 0, 0, 0.5 )
	
	-- Background
	navMenu[ "Background" ] = display.newRoundedRect( ui_Groups[ 3 ], display.contentCenterX, display.contentCenterY, display.contentWidth * 0.85, display.contentWidth * 0.85, 30 )
	navMenu[ "Background" ]:setFillColor( 8 / 255, 127 / 255, 35 / 255 )

	-- Background Drop Shadow
	navMenu[ "DropShadow" ] = display.newRoundedRect( ui_Groups[ 2 ], navMenu[ "Background" ].x + 6, navMenu[ "Background" ].y + 6, navMenu[ "Background" ].width, navMenu[ "Background" ].height, 30 )
	navMenu[ "DropShadow" ]:setFillColor( 0, 0, 0, 0.25 )
	
	-- Navigation Menu Buttons
	local buttonNames = sceneData[ "Buttons" ]
	
	navMenu[ "Buttons" ] = { }
	
	-- If Buttons are Provided
	if ( buttonNames ~= nil ) then
		
		local buttonPosition = { x = 1, y = 1 }
		local buttonsPerRow = 3
		local gridListingSize = navMenu[ "Background" ].width / ( buttonsPerRow + 1 )
		
		for i = 1, #buttonNames do
		
			local newButton = { }
			
			local newListingPosition = { 
			
				x = ( navMenu[ "Background" ].x - navMenu[ "Background" ].width / 2 ) + ( buttonPosition.x * gridListingSize ), 
				y = ( navMenu[ "Background" ].y - navMenu[ "Background" ].height / 2 ) + ( buttonPosition.y * gridListingSize ) + ( 40 * ( buttonPosition.y - 1 ) ),
			
			}
			
			-- Set Button Background Transparency. Only show the background if the button's target scene is the current scene's name.
			local buttonOutlineTransparency = 0.01
			if ( buttonNames[ i ][ "Scene" ] == self.currentScene ) then
			
				buttonOutlineTransparency = 1
				
			end
			
			-- Button Icon
			newButton[ "Icon" ] = display.newText( { parent = ui_Groups[ 6 ], text = buttonNames[ i ][ "Icon" ], x = newListingPosition.x, y = newListingPosition.y - gridListingSize * 0.25, font = "Data/Fonts/MaterialIcons-Regular", fontSize = gridListingSize * 0.4 } )
			--newButton[ "Icon" ]:setFillColor( 0, 0, 0 )
			
			-- Button Drop Shadow (Same Icon Shifted)
			newButton[ "DropShadow" ] = display.newText( { parent = ui_Groups[ 5 ], text = buttonNames[ i ][ "Icon" ], x = newButton[ "Icon" ].x + 4, y = newButton[ "Icon" ].y + 4, font = "Data/Fonts/MaterialIcons-Regular", fontSize = gridListingSize * 0.4 } )
			newButton[ "DropShadow" ]:setFillColor( 0, 0, 0, 0.25 )
			
			-- Button Background
			newButton[ "Button" ] = display.newCircle( ui_Groups[ 4 ], newListingPosition.x, newListingPosition.y - gridListingSize * 0.25, ( gridListingSize * 0.6 ) / 2 )
			newButton[ "Button" ]:setFillColor( 76 / 255, 175 / 255, 80 / 255, buttonOutlineTransparency )
			
			newButton[ "Button" ].myName = buttonNames[ i ][ "Scene" ]
			newButton[ "Button" ].buttonType = "Scene"
			
			newButton[ "Button" ]:addEventListener( "tap", function( ) self:buttonPress( newButton[ "Button" ] ) end )
			-- Button Title
			newButton[ "Title" ] = display.newText( { parent = ui_Groups[ 6 ], text = buttonNames[ i ][ "Title" ], x = newListingPosition.x, y = newListingPosition.y + gridListingSize * 0.25, font = "Data/Fonts/Roboto", fontSize = gridListingSize * 0.25 } )
			
			-- Increment Grid Layout Horizontal Position
			buttonPosition.x = buttonPosition.x + 1
			
			-- Move to the next row if the button position exceeds the maximum buttons per row.
			if ( buttonPosition.x > buttonsPerRow ) then
			
				buttonPosition.x = 1
				buttonPosition.y = buttonPosition.y + 1
				
			end
	
			-- Add the button to the nav menu table so that it can be tracked.
			table.insert( navMenu[ "Buttons" ], newButton )
			
		end
		
		-- Create a close menu button to close the nav menu later on.
		local closeMenu = { }
		
		-- Close Menu Button Icon
		closeMenu[ "Icon" ] = display.newText( { parent = ui_Groups[ 6 ], text = "close", x = navMenu[ "Background" ].x, font = "Data/Fonts/MaterialIcons-Regular", fontSize = 72, align = "center" } )
		closeMenu[ "Icon" ]:setFillColor( 0, 0, 0 )
	
		-- Close Menu Button Background
		closeMenu[ "Button" ] = display.newCircle( ui_Groups[ 5 ], navMenu[ "Background" ].x, ( navMenu[ "Background" ].y + navMenu[ "Background" ].height / 2 ) + closeMenu[ "Icon" ].height * 1.5, 72 )
		closeMenu[ "Button" ]:setFillColor( 128 / 255, 226 / 255, 126 / 255 )
	
		-- Add Button Event Listener
		closeMenu[ "Button" ]:addEventListener( "tap", function( ) self:setMenuVisibility( false ) end )
		
		-- Center Icon on Button Background
		closeMenu[ "Icon" ].y = closeMenu[ "Button" ].y

		-- Add Drop Shadow to Button Background
		closeMenu[ "DropShadow" ] = display.newCircle( ui_Groups[ 4 ], closeMenu[ "Button" ].x + 4, closeMenu[ "Button" ].y + 4, 72 )
		closeMenu[ "DropShadow" ]:setFillColor( 0, 0, 0, 0.25 )
		
		-- Hide Menu
		self:setMenuVisibility( false )
	
	else -- Internal Developer Error Message
	
		print( "[Nav Menu Issue]: No buttons have been specified." )
		
	end
	
end

function navMenu:new( sceneData, object )

	--[[
	
		sceneData Contents:
		
		{
			[ "SceneName" ] = [Current Scene Name (string)],
			[ "SceneGroup" ] = [Scene Group (variable)],
			
			[ "Buttons" ] = { 
			
				{ [ "Title" ] = [Scene Display Name (string)], [ "Icon" ] = [Material Design Icon Name (string)], [ "Scene" ] = [Target Scene (string)] },
				
			}
		}
		
	]]
	
	-- Assign passed object or create a new one.
	object = object or { }
	
	setmetatable( object, self )
	self.__index = self
	
	object.currentScene = sceneData[ "SceneName" ]
	
	object:createMenu( sceneData )
	
	-- Return the object reference
	return object
	
end




return navMenu