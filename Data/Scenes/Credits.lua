--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Scene: Credits
Purpose: Show an interactive credits section of all of the team members that worked on this project.

-------------------------

]]

local composer = require( "composer" )

local scene = composer.newScene( )

-- Modules
local moduleNames = { 

	-- UI
	{ Name = "navMenuManager", Location = "Data.Modules.UI.navMenuManager" },
	{ Name = "topbarManager", Location = "Data.Modules.UI.topbarManager" },
	{ Name = "scaler", Location = "Data.Modules.UI.scaler" },
	
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

-- Team Members List (Alphabetical Order, Modular)
local teamMembers = { 

	-- Chase Balmes
	{
	
		[ "Name" ] = "Chase Balmes",
		[ "Roles" ] = { "Backend Developer" },
		[ "Description" ] = "Computer science student interested in the intersection of healthcare and cybersecurity.  ",

	},
	
	-- Timothy Bennett
	{
	
		[ "Name" ] = "Timothy Bennett",
		[ "Roles" ] = { "Backend Developer", "Technical Scribe/Documentation Editor" },
		[ "Description" ] = "Dedicated Computer Science student interested in game development and AI.",
		
	},
	
	-- Michael Dunn
	{
	
		[ "Name" ] = "Michael Dunn",
		[ "Roles" ] = { "Team Lead", "UI/UX Designer", "UI Developer", "Database Storage", "Backend Developer", "Photographer" },
		[ "Description" ] = "Computer Science student interested in making games and applications for people to enjoy.",
		
	},

	-- Talha Khan
	{
	
		[ "Name" ] = "Talha Khan",
		[ "Roles" ] = { "Data Entry" },
		[ "Description" ] = "Cybersecurity student that is passionate about making the online world a safer place.",
		
	},

	-- Jonathan Nguyen
	{
	
		[ "Name" ] = "Jonathan Nguyen",
		[ "Roles" ] = { "Tester/Quality Assurance" },
		[ "Description" ] = "Pursuing a degree in Computer Science in order to work for the government.",
		
	},
	
}
-- Values
local scaleRatio = 1

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local function setScrollViewVisibility( newStatus ) -- Set ScrollView Visibility State

	ui_Objects[ "Content View" ].isVisible = newStatus
	
end



local function buttonPress( event ) -- Handle button interactions.

	local button = event.target
	
	if ( button.myName == "leftActionButton" ) then
	
		ui_Objects[ "NavMenu" ]:setMenuVisibility( true )
		setScrollViewVisibility( false )
	
	elseif ( button.myName == "Close" ) then
	
		setScrollViewVisibility( true )
		
	end
	
end

local function createCreditList( ) -- Create list of credits within the ScrollView.

	ui_Objects[ "Member List" ] = { }
	
	local lastPosition = 0
	for i = 1, #teamMembers do
	
		local newIcon = { }
		
		newIcon[ "Guide" ] = display.newText( { parent = ui_Groups[ 3 ], text = i .. " / " .. #teamMembers, x = ui_Objects[ "Content View" ].width / 2, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = ( 36 * scaleRatio ), align = "center" } )
		newIcon[ "Guide" ].y = lastPosition + newIcon[ "Guide" ].height / 2 + ( 10 * scaleRatio )
		newIcon[ "Guide" ]:setFillColor( 0, 0, 0, 0.6 )
		
		newIcon[ "Icon" ] = display.newImageRect( ui_Groups[ 3 ], "Data/Assets/Group Photos/" .. teamMembers[ i ][ "Name" ] .. ".png", 384 * scaleRatio, 384 * scaleRatio )
		newIcon[ "Icon" ]:translate( ui_Objects[ "Content View" ].width / 2, ( newIcon[ "Guide" ].y + newIcon[ "Guide" ].height / 2 ) + ( newIcon[ "Icon" ].height / 2 + 30 * scaleRatio ) )

		newIcon[ "Title" ] = display.newText( { parent = ui_Groups[ 3 ], text = teamMembers[ i ][ "Name" ], x = ui_Objects[ "Content View" ].width / 2, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = ( 65 * scaleRatio ), align = "center" } )
		newIcon[ "Title" ].y = ( newIcon[ "Icon" ].y + newIcon[ "Icon" ].height / 2 ) + newIcon[ "Title" ].height / 2 + ( 10 * scaleRatio )
		newIcon[ "Title" ]:setFillColor( 0, 0, 0 )
		
		newIcon[ "Profile" ] = display.newText( { parent = ui_Groups[ 3 ], text = "Roles:\n\n" .. table.concat( teamMembers[ i ][ "Roles" ], ", " ) .. "\n\nAbout Me:\n\n" .. teamMembers[ i ][ "Description" ], x = ui_Objects[ "Content View" ].width / 2, width = ui_Objects[ "Content View" ].width * 0.9, font = "Data/Fonts/Roboto.ttf", fontSize = ( 42 * scaleRatio ), align = "center" } )
		newIcon[ "Profile" ].y = ( newIcon[ "Title" ].y + newIcon[ "Title" ].height / 2 ) + newIcon[ "Profile" ].height / 2 + ( 20 * scaleRatio )
		newIcon[ "Profile" ]:setFillColor( 0, 0, 0, 0.65 )
		
		ui_Objects[ "Content View" ]:insert( newIcon[ "Guide" ] )
		ui_Objects[ "Content View" ]:insert( newIcon[ "Icon" ] )
		ui_Objects[ "Content View" ]:insert( newIcon[ "Title" ] )
		ui_Objects[ "Content View" ]:insert( newIcon[ "Profile" ] )
		
		table.insert( ui_Objects[ "Member List" ], newIcon )
		
		lastPosition = newIcon[ "Profile" ].y + newIcon[ "Profile" ].height / 2
		
	end

	local newGuideText = display.newText( { parent = ui_Groups[ 3 ], text = "End of Credits", x = ui_Objects[ "Content View" ].width / 2, font = "Data/Fonts/Roboto.ttf", fontSize = ( 32 * scaleRatio ), align = "center" } )
	newGuideText:setFillColor( 0, 0, 0, 0.6 )
	
	newGuideText.height = newGuideText.height * 3
	
	newGuideText.y = lastPosition + newGuideText.height / 2
	
	ui_Objects[ "Content View" ]:insert( newGuideText )
	
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
	ui_Objects[ "Topbar" ] = modules[ "topbarManager" ]:new( { [ "Groups" ] = ui_Groups, [ "Title" ] = "Credits", [ "ScaleRatio" ] = scaleRatio } )
	ui_Objects[ "Topbar" ].ui_Objects[ "leftActionButton" ].Button:addEventListener( "tap", buttonPress )

	local sceneData = { 
		
		[ "SceneName" ] = "Credits",
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
	
	createCreditList( )
	
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
