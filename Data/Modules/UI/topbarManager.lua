--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Object Module: Topbar Manager
Purpose: Handles the creation and modification of the UI topbar.

-------------------------

Inspired by this tutorial: https://www.tutorialspoint.com/lua/lua_object_oriented.htm

]]

topbar = { 

	-- Object Public Variables
	
	ui_Objects = { },
	
}

function topbar:create( sceneData )

	local ui_Groups = sceneData[ "Groups" ]
	
	-- Create Topbar
	local topbarHeight = ( 72 * 2 )
	self.ui_Objects[ "Topbar" ] = { }
	
	local topbar = self.ui_Objects[ "Topbar" ]
	
	-- Bar
	topbar.Bar = display.newRect( ui_Groups[ 2 ], display.contentCenterX, ( topbarHeight + display.topStatusBarContentHeight ) / 2, display.contentWidth, topbarHeight + display.topStatusBarContentHeight )
	topbar.Bar:setFillColor( 76 / 255, 175 / 255, 80 / 255 )

	-- Drop Shadow
	topbar.DropShadow = display.newRect( ui_Groups[ 1 ], topbar.Bar.x, topbar.Bar.y + ( topbar.Bar.height * 0.025 ), topbar.Bar.width, topbar.Bar.height )
	topbar.DropShadow:setFillColor( 0, 0, 0, 0.25 )
	
	-- Buttons
	
	-- Left Action Button
	self.ui_Objects[ "leftActionButton" ] = { }
	local leftActionButton = self.ui_Objects[ "leftActionButton" ]
	
	-- Button Background
	leftActionButton.Button = display.newCircle( ui_Groups[ 2 ], 60 * 1.5, display.topStatusBarContentHeight + 60, 60 )
	leftActionButton.Button:setFillColor( 8 / 255, 127 / 255, 35 / 255 )
	
	leftActionButton.Button.alpha = 0.01
	leftActionButton.Button.myName = "leftActionButton"
	
	--leftActionButton.Button:addEventListener( "tap", buttonPress )
	
	-- Button Icon
	leftActionButton.Text = display.newText( { parent = ui_Groups[ 3 ], text = "menu", x = leftActionButton.Button.x, y = leftActionButton.Button.y, font = "Data/Fonts/MaterialIcons-Regular.ttf", fontSize = 72 } ) 

	-- Topbar Title
	topbar.Title = display.newText( { parent = ui_Groups[ 3 ], text = sceneData[ "Title" ] or "", font = "Data/Fonts/Roboto.ttf", fontSize = 72 } )
	topbar.Title.x = ( leftActionButton.Button.x + leftActionButton.Button.width * 0.6 ) + topbar.Title.width / 2
	topbar.Title.y = leftActionButton.Button.y
	
end

function topbar:new( sceneData, object )

	-- Assign passed object or create a new one.
	object = object or { }
	
	setmetatable( object, self )
	self.__index = self
	
	topbar:create( sceneData )
	
	-- Return the object reference
	return object
	
end

function topbar:setTitle( newTitle )

	self.ui_Objects[ "Topbar" ].Title.text = newTitle or ""
	
end


return topbar