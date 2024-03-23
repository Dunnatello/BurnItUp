--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Scene: Goals
Purpose: Allow the user to view their current goals.

-------------------------


]]
local composer = require( "composer" )

local scene = composer.newScene()

-- Modules
local moduleNames = { 

	-- UI
	{ Name = "navMenuManager", Location = "Data.Modules.UI.navMenuManager" },
	{ Name = "dayOverview", Location = "Data.Modules.UI.dayOverview" },
	{ Name = "topbarManager", Location = "Data.Modules.UI.topbarManager" },
	{ Name = "scaler", Location = "Data.Modules.UI.scaler" },

	-- Backend
	{ Name = "storage", Location = "Data.Modules.Backend.Storage.storageHandler" },
	
	-- Solar2D (Corona SDK) Built-In Libraries
	{ Name = "widget", Location = "widget" },

	-- External Libraries
	{ Name = "dateLibrary", Location = "Data.Modules.External Libraries.date" },
	
}

local modules = { }

for i = 1, #moduleNames do
	
	modules[ moduleNames[ i ].Name ] = require( moduleNames[ i ].Location )
	
end

-- Tables
local ui_Groups = { }
local ui_Objects = { }

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function createContentView( ) -- Create ScrollView

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
	
end

local function setScrollViewVisibility( newStatus ) -- Set ScrollView Visibility State

	ui_Objects[ "Content View" ].isVisible = newStatus
	
end

local function removeSections( ) -- Remove UI and Replace ScrollView

	display.remove( ui_Objects[ "Content View" ] )
	ui_Objects[ "Content View" ] = nil
	
	createContentView( )
	
	ui_Objects[ "Week Overview" ] = nil
	
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

local function createStats( newWeightOverview, Stats )

	local scrollView = ui_Objects[ "Content View" ]
	
	for i = 1, #Stats do
	
		newWeightOverview[ Stats[ i ][ "Name" ] ] = { }
		local newStat = newWeightOverview[ Stats[ i ][ "Name" ] ]
		
		-- Title
		newStat[ "Title" ] = display.newText( { parent = ui_Groups[ 3 ], text = Stats[ i ][ "Title" ], y = newWeightOverview[ "Background" ].y, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 36 * scaleRatio, align = "center" } )
		newStat[ "Title" ].x = newWeightOverview[ "Background" ].x + ( ( newWeightOverview[ "Background" ].width / 2 - newStat[ "Title" ].width / 2 - ( 40 * scaleRatio ) ) * Stats[ i ][ "Direction" ] )
		newStat[ "Title" ]:setFillColor( 0, 0, 0, 0.6 )
		
		-- Value
		newStat[ "Value" ] = display.newText( { parent = ui_Groups[ 3 ], text = Stats[ i ][ "Value" ], x = newStat[ "Title" ].x, font = "Data/Fonts/Roboto.ttf", fontSize = 36 * scaleRatio, align = "center" } )
		newStat[ "Value" ].y = ( newStat[ "Title" ].y + newStat[ "Title" ].height / 2 ) + newStat[ "Value" ].height * 0.7
		newStat[ "Value" ]:setFillColor( 8 / 255, 127 / 255, 35 / 255 )
		
		-- Add Stat Text to Scroll View
		scrollView:insert( newStat[ "Title" ] )
		scrollView:insert( newStat[ "Value" ] )
	
	end
	
end

local function createGoalOverview( )

	if ( ui_Objects[ "Content View" ] ~= nil ) then
	
		removeSections( )
		
	end
	
	createContentView( )
	
	local scrollView = ui_Objects[ "Content View" ]
	
	local list = savedData[ "Weight Log" ]
	
	ui_Objects[ "Goal Overview" ] = { }
	
	local summary = { }
		
	-- Background
	summary[ "Background" ] = display.newRoundedRect( ui_Groups[ 2 ], scrollView.width / 2, 0, display.contentWidth * 0.85, 42 * 4.75 * scaleRatio, 30 )
	summary[ "Background" ].y = summary[ "Background" ].height * ( 1 - 0.5 ) + ( 30 * scaleRatio )
	
	-- Drop Shadow
	summary[ "DropShadow" ] = display.newRoundedRect( ui_Groups[ 1 ], summary[ "Background" ].x + 4 * scaleRatio, summary[ "Background" ].y + 4 * scaleRatio, summary[ "Background" ].width, summary[ "Background" ].height, 30 )
	summary[ "DropShadow" ]:setFillColor( 0, 0, 0, 0.25 )

	summary[ "Title" ] = display.newText( { parent = ui_Groups[ 3 ], text = "Weight Goal Overview", x = summary[ "Background" ].x, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 36 * scaleRatio, align = "center" } )
	summary[ "Title" ].y = ( summary[ "Background" ].y - summary[ "Background" ].height / 2 ) + summary[ "Title" ].height
	summary[ "Title" ]:setFillColor( 0, 0, 0 )
		
	scrollView:insert( summary[ "DropShadow" ] )
	scrollView:insert( summary[ "Background" ] )
	scrollView:insert( summary[ "Title" ] )
	
	local currentWeight = savedData[ "Info" ][ "Initial Weight" ]
	
	if ( #list > 0 ) then
	
		currentWeight = list[ #list ][ "Weight" ]
		
	end
	
	-- Calculate Weight Difference
	local weightDifference = currentWeight - savedData[ "Info" ][ "Weight Goal" ]
	local balanceState = ""
	local balanceColor = { R = 8 / 255, G = 127 / 255, B = 35 / 255 }
		
	if ( weightDifference > 3 ) then -- Over Weight Goal (With Buffer)
		
		balanceState = "Over"
		balanceColor = { R = 244 / 255, G = 67 / 255, B = 54 / 255 }

	elseif ( weightDifference < 0 ) then -- Under Weight Goal
		
		balanceState = "Under"
		
	end

	local Stats = { 
		
		{ 
			[ "Name" ] = "Current Weight", 
			[ "Title" ] = "Weight",
			[ "Value" ] = string.format( "%.1f", currentWeight ),
			[ "Direction" ] = -1,
		
		},
	
		{ 
			[ "Name" ] = "Weight Goal", 
			[ "Title" ] = "Goal",
			[ "Value" ] = string.format( "%.1f", savedData[ "Info" ][ "Weight Goal" ] ),
			[ "Direction" ] = 0,

		},
		
		{ 
			[ "Name" ] = "Weight Remaining", 
			[ "Title" ] = balanceState,
			[ "Value" ] = string.format( "%.1f", math.abs( weightDifference ) ),
			[ "Direction" ] = 1,

		},
		
	}
	
	createStats( summary, Stats )
	
	summary[ "Weight Remaining" ][ "Title" ].text = balanceState
	summary[ "Weight Remaining" ][ "Value" ]:setFillColor( balanceColor.R, balanceColor.G, balanceColor.B )
	
	local lastPosition = summary[ "Background" ].y + summary[ "Background" ].height / 2
	local previousWeight = savedData[ "Info" ][ "Initial Weight" ]

	for i = 1, #list do
			
		local currentDate = modules[ "dateLibrary" ]( list[ i ][ "Date" ][ "Year" ], list[ i ][ "Date" ][ "Month" ], list[ i ][ "Date" ][ "Day" ] )
		
		local newWeightOverview = { }
		
		local newVerticalIndex = #list - ( i - 1 ) + 1
		
		-- Background
		newWeightOverview[ "Background" ] = display.newRoundedRect( ui_Groups[ 2 ], scrollView.width / 2, 0, display.contentWidth * 0.85, 42 * 4.75 * scaleRatio, 30 )
		newWeightOverview[ "Background" ].y = newWeightOverview[ "Background" ].height * ( newVerticalIndex - 0.5 ) + ( 30 * scaleRatio * newVerticalIndex )
	
		if ( i == 1 ) then
			
			lastPosition = newWeightOverview[ "Background" ].y + newWeightOverview[ "Background" ].height / 2
		
		end
		
		-- Drop Shadow
		newWeightOverview[ "DropShadow" ] = display.newRoundedRect( ui_Groups[ 1 ], newWeightOverview[ "Background" ].x + 4 * scaleRatio, newWeightOverview[ "Background" ].y + 4 * scaleRatio, newWeightOverview[ "Background" ].width, newWeightOverview[ "Background" ].height, 30 )
		newWeightOverview[ "DropShadow" ]:setFillColor( 0, 0, 0, 0.25 )
	
		-- Date
		newWeightOverview[ "Date" ] = display.newText( { parent = ui_Groups[ 3 ], text = currentDate:fmt( "%a, %b %d %Y" ), x = newWeightOverview[ "Background" ].x, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 36 * scaleRatio, align = "center" } )
		newWeightOverview[ "Date" ].y = ( newWeightOverview[ "Background" ].y - newWeightOverview[ "Background" ].height / 2 ) + newWeightOverview[ "Date" ].height
		newWeightOverview[ "Date" ]:setFillColor( 0, 0, 0 )
	
		scrollView:insert( newWeightOverview[ "DropShadow" ] )
		scrollView:insert( newWeightOverview[ "Background" ] )
		scrollView:insert( newWeightOverview[ "Date" ] )


		--Display Weight Gain/Loss
		local weightDifference = previousWeight - list[ i ][ "Weight" ]
		local balanceState = "    "
		local balanceColor = { R = 8 / 255, G = 127 / 255, B = 35 / 255 }
		
		if ( weightDifference > 0 ) then -- Lost Weight
			
			balanceState = "Lost"
		
		elseif ( weightDifference < 0 ) then -- Gained Weight
			
			balanceState = "Gain"
			balanceColor = { R = 244 / 255, G = 67 / 255, B = 54 / 255 }
		
		end
		
		
		local Stats = { 
			
			{ 
				[ "Name" ] = "Weight", 
				[ "Title" ] = "Weight",
				[ "Value" ] = string.format( "%.1f", list[ i ][ "Weight" ] ),
				[ "Direction" ] = -1,
			
			},
		
			-- { 
				-- [ "Name" ] = "Exercise", 
				-- [ "Title" ] = "Exercise",
				-- [ "Value" ] = exerciseCalories,
				-- [ "Direction" ] = 0,

				
			-- },
			
			{ 
				[ "Name" ] = "Weight Change", 
				[ "Title" ] = balanceState,
				[ "Value" ] = string.format( "%.1f", math.abs( weightDifference ) ),
				[ "Direction" ] = 1,

			},
			
			
		}
		
	
		createStats( newWeightOverview, Stats )

		
		-- Update Color for Weight Change's Value
		newWeightOverview[ "Weight Change" ][ "Value" ]:setFillColor( balanceColor.R, balanceColor.G, balanceColor.B )
	
		table.insert( ui_Objects[ "Goal Overview" ], newWeightOverview )
	
		-- Update Previous Weight
		previousWeight = list[ i ][ "Weight" ]
		
	end
	
	local newGuideText = display.newText( { parent = ui_Groups[ 3 ], text = "End of Weight Log", x = scrollView.width / 2, font = "Data/Fonts/Roboto.ttf", fontSize = ( 32 * scaleRatio ), align = "center" } )
	newGuideText:setFillColor( 0, 0, 0, 0.6 )
	
	newGuideText.height = newGuideText.height * 3
	
	newGuideText.y = lastPosition + newGuideText.height / 2
	
	scrollView:insert( newGuideText )
	
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
	
	savedData = modules[ "storage" ].getData( )
	
	-- Create Topbar
	ui_Objects[ "Topbar" ] = modules[ "topbarManager" ]:new( { [ "Groups" ] = ui_Groups, [ "Title" ] = "Goals", [ "ScaleRatio" ] = scaleRatio } )
	ui_Objects[ "Topbar" ].ui_Objects[ "leftActionButton" ].Button:addEventListener( "tap", buttonPress )

	local sceneData = { 
		
		[ "SceneName" ] = "Goals",
		[ "SceneGroup" ] = sceneGroup,
		
		[ "Buttons" ] = {
		
			{ [ "Title" ] = "Week", [ "Icon" ] = "calendar_view_week", [ "Scene" ] = "Overview" },
			{ [ "Title" ] = "Log", [ "Icon" ] = "monitor_weight", [ "Scene" ] = "Menu" },
			{ [ "Title" ] = "Goals", [ "Icon" ] = "flag", [ "Scene" ] = "Goals" },
			{ [ "Title" ] = "Settings", [ "Icon" ] = "settings", [ "Scene" ] = "Settings" },
		
		},
	
	}

	-- Create Navigation Menu
	ui_Objects[ "NavMenu" ] = modules[ "navMenuManager" ]:new( sceneData )
	ui_Objects[ "NavMenu" ].menu[ "NavMenu" ][ "Close" ][ "Button" ]:addEventListener( "tap", buttonPress )
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
		createGoalOverview( )
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

		setScrollViewVisibility( true )

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
