--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Object Module: Add Menu Manager
Purpose: Creates the navigation menu for the current scene so that the user can transition from scene to scene.

-------------------------

Inspired by this tutorial: https://www.tutorialspoint.com/lua/lua_object_oriented.htm

]]

local composer = require( "composer" )
local scaler = require( "Data.Modules.UI.scaler" )

local newScaleRatio = 1

addMenu = { 

	-- Object Public Variables
	
	currentScene = nil,
	menu = { },
	
}


function addMenu:setMenuVisibility( newVisibilityState ) -- Close Object Menu
		
	for i = 1, #self.ui_Groups do
		
		self.ui_Groups[ i ].isVisible = newVisibilityState
		
	end
	
	self.isVisible = newVisibilityState
	
end

function addMenu:buttonPress( button )
		
	if ( button.buttonType == "Category" ) then
	
		local sceneParameters = { Category = button.categoryName, Title = button.myName }
		local newSceneName = "Data.Scenes.AddItems"
		
		if ( button.categoryName == "Weight" ) then
			
			sceneParameters = { }
			newSceneName = "Data.Scenes.TrackWeight"
			

		end
		
		self:setMenuVisibility( false )

		composer.gotoScene( newSceneName, { effect = "crossFade", time = 300, params = sceneParameters } )
		
	end
	
end


function addMenu:createMenu( sceneData )  -- Create Add Menu for Scene
	
	scaleRatio = scaler.new( )
	
	-- Create Additional UI Scene Groups
	self.ui_Groups = { }
	local ui_Groups = self.ui_Groups
	
	for i = 1, 6 do 
	
		ui_Groups[ i ] = display.newGroup( )
		sceneData[ "SceneGroup" ]:insert( ui_Groups[ i ] )
		
	end
	
	-- Create Menu Background
	self.menu[ "Add Menu" ] = { }
	
	self.currentScene = sceneData[ "SceneName" ]
	
	local addMenu = self.menu[ "Add Menu" ]
	
	-- Scrim
	addMenu[ "Scrim" ] = display.newRect( ui_Groups[ 1 ], display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	addMenu[ "Scrim" ]:setFillColor( 0, 0, 0, 0.5 )
	
	-- Background
	addMenu[ "Background" ] = display.newRoundedRect( ui_Groups[ 3 ], display.contentCenterX, display.contentCenterY, display.contentWidth * 0.9, display.contentHeight * 0.4, 30 )
	--addMenu[ "Background" ]:setFillColor( 8 / 255, 127 / 255, 35 / 255 )

	-- Background Drop Shadow
	addMenu[ "DropShadow" ] = display.newRoundedRect( ui_Groups[ 2 ], addMenu[ "Background" ].x + 6, addMenu[ "Background" ].y + 6, addMenu[ "Background" ].width, addMenu[ "Background" ].height, 30 )
	addMenu[ "DropShadow" ]:setFillColor( 0, 0, 0, 0.25 )
	
	-- Add Button
	addMenu[ "Add Button" ] = { }
	local addButton = addMenu[ "Add Button" ]
	
	-- Title
	addButton.Title = display.newText( { parent = sceneData[ "Scene UI Groups" ][ 3 ], text = "add", font = "Data/Fonts/MaterialIcons-Regular.ttf", fontSize = 60 * scaleRatio, align = "center" } )
	addButton.Title.x, addButton.Title.y = display.contentWidth - addButton.Title.width * 1.4, display.contentHeight - addButton.Title.width * 1.4
	
	-- Button
	addButton.Button = display.newCircle( sceneData[ "Scene UI Groups" ][ 2 ], addButton.Title.x, addButton.Title.y, addButton.Title.width * 0.75 )
	addButton.Button:setFillColor( 76 / 255, 175 / 255, 80 / 255 )
	
	addButton.Button.myName = "Add"
	addButton.Button:addEventListener( "tap", function( ) self:setMenuVisibility( true ) end )

	-- Drop Shadow
	addButton.DropShadow = display.newCircle( sceneData[ "Scene UI Groups" ][ 1 ], addButton.Button.x + 4, addButton.Button.y + 4, addButton.Title.width * 0.75 )
	addButton.DropShadow:setFillColor( 0, 0, 0, 0.25 )
		
	-- Close Button
	addMenu[ "Close Button" ] = { }
	local closeButton = addMenu[ "Close Button" ]
	
	-- Title
	closeButton.Title = display.newText( { parent = ui_Groups[ 6 ], text = "close", font = "Data/Fonts/MaterialIcons-Regular.ttf", fontSize = 72, align = "center" } )
	closeButton.Title.x, closeButton.Title.y = ( addMenu[ "Background" ].x + addMenu[ "Background" ].width / 2 ) - closeButton.Title.width / 2, ( addMenu[ "Background" ].y - addMenu[ "Background" ].height / 2 ) + closeButton.Title.width / 2
	
	-- Button
	closeButton.Button = display.newCircle( ui_Groups[ 5 ], closeButton.Title.x, closeButton.Title.y, closeButton.Title.width * 0.75 )
	closeButton.Button:setFillColor( 76 / 255, 175 / 255, 80 / 255 )
	
	closeButton.Button.myName = "Close"
	closeButton.Button:addEventListener( "tap", function( ) self:setMenuVisibility( false ) end )

	-- Drop Shadow
	closeButton.DropShadow = display.newCircle( ui_Groups[ 4 ], closeButton.Button.x + 4, closeButton.Button.y + 4, closeButton.Title.width * 0.75 )
	closeButton.DropShadow:setFillColor( 0, 0, 0, 0.25 )
	
	-- Navigation Menu Buttons
	local buttonCategories = sceneData[ "Buttons" ]
	
	addMenu[ "Buttons" ] = { }
	
	-- If Buttons are Provided
	if ( buttonCategories ~= nil ) then
		
		local buttonPosition = { x = 1, y = 1 }
		local buttonsPerRow = 3
		local gridListingSize = addMenu[ "Background" ].width / ( buttonsPerRow + 1 )
		for e = 1, #buttonCategories do
			
			print( buttonCategories[ e ][ "Category" ] )
			local buttonNames = buttonCategories[ e ][ "Buttons" ]
			
			local newCategoryName = display.newText( { parent = ui_Groups[ 6 ], text = buttonCategories[ e ][ "Category" ], x = ( addMenu[ "Background" ].x - addMenu[ "Background" ].width / 2 ) + gridListingSize, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = gridListingSize * 0.25 } )
			newCategoryName:setFillColor( 0, 0, 0, 0.6 )
			newCategoryName.y = ( addMenu[ "Background" ].y - addMenu[ "Background" ].height / 2 ) + ( ( buttonPosition.y * gridListingSize ) + ( 40 * ( buttonPosition.y - 1 ) ) ) - newCategoryName.height * 2.25
			
			for i = 1, #buttonNames do
			
				print( buttonNames[ i ][ "Title" ] )
				local newButton = { }
				
				local newListingPosition = { 
				
					x = ( addMenu[ "Background" ].x - addMenu[ "Background" ].width / 2 ) + ( buttonPosition.x * gridListingSize ), 
					y = ( addMenu[ "Background" ].y - addMenu[ "Background" ].height / 2 ) + ( buttonPosition.y * gridListingSize ) + ( 40 * ( buttonPosition.y - 1 ) ),
				
				}
				
				-- Set Button Background Transparency.
				local buttonOutlineTransparency = 0.01

				
				-- Button Icon
				newButton[ "Icon" ] = display.newText( { parent = ui_Groups[ 6 ], text = buttonNames[ i ][ "Icon" ], x = newListingPosition.x, y = newListingPosition.y - gridListingSize * 0.25, font = "Data/Fonts/MaterialIcons-Regular", fontSize = gridListingSize * 0.4 } )
				newButton[ "Icon" ]:setFillColor( buttonNames[ i ][ "Icon Color" ].R, buttonNames[ i ][ "Icon Color" ].G, buttonNames[ i ][ "Icon Color" ].B )
				
				
				-- Button Drop Shadow (Same Icon Shifted)
				newButton[ "DropShadow" ] = display.newText( { parent = ui_Groups[ 5 ], text = buttonNames[ i ][ "Icon" ], x = newButton[ "Icon" ].x + 4, y = newButton[ "Icon" ].y + 4, font = "Data/Fonts/MaterialIcons-Regular", fontSize = gridListingSize * 0.4 } )
				newButton[ "DropShadow" ]:setFillColor( 0, 0, 0, 0.25 )
				
				-- Button Background
				newButton[ "Button" ] = display.newCircle( ui_Groups[ 4 ], newListingPosition.x, newListingPosition.y - gridListingSize * 0.25, ( gridListingSize * 0.6 ) / 2 )
				newButton[ "Button" ]:setFillColor( 76 / 255, 175 / 255, 80 / 255, buttonOutlineTransparency )
				
				newButton[ "Button" ].myName = buttonNames[ i ][ "Title" ]
				newButton[ "Button" ].buttonType = "Category"
				newButton[ "Button" ].categoryName = buttonCategories[ e ][ "Section" ]
				
				newButton[ "Button" ]:addEventListener( "tap", function( ) self:buttonPress( newButton[ "Button" ] ) end )
				-- Button Title
				newButton[ "Title" ] = display.newText( { parent = ui_Groups[ 6 ], text = buttonNames[ i ][ "Title" ], x = newListingPosition.x, y = newListingPosition.y + gridListingSize * 0.25, font = "Data/Fonts/Roboto", fontSize = gridListingSize * 0.25 } )
				newButton[ "Title" ]:setFillColor( 0, 0, 0 )
				
				-- Increment Grid Layout Horizontal Position
				buttonPosition.x = buttonPosition.x + 1
				
				-- Move to the next row if the button position exceeds the maximum buttons per row.
				if ( buttonPosition.x > buttonsPerRow ) then
				
					buttonPosition.x = 1
					buttonPosition.y = buttonPosition.y + 1
					
				end
		
				-- Add the button to the nav menu table so that it can be tracked.
				table.insert( addMenu[ "Buttons" ], newButton )
				
			end
		
			buttonPosition.x = 1
			buttonPosition.y = buttonPosition.y + 1.25
			
		end
		
	else -- Internal Developer Error Message
	
		print( "ERROR: [Add Menu Issue]: No buttons have been specified." )
		
	end
	
	-- Hide Menu
	self:setMenuVisibility( false ) -- FIXME: Return value to false after testing.
		
end

function addMenu:new( sceneData, object )

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
	object.isVisible = false
	
	object:createMenu( sceneData )
	
	-- Return the object reference
	return object
	
end




return addMenu