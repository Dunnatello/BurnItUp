--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Scene: Overview
Purpose: Allow the user to view their current week's calorie intake and progress.

-------------------------


]]
local composer = require( "composer" )

local scene = composer.newScene()

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

-- Clear Memory of Unneeded Tables
moduleNames = nil

-- Tables
local ui_Groups = { }
local ui_Objects = { }

local savedData

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

local function createWeekOverview( )

	if ( ui_Objects[ "Content View" ] ~= nil ) then
	
		removeSections( )
		
	end
	
	createContentView( )
	
	local scrollView = ui_Objects[ "Content View" ]
	
	local currentDate = modules[ "dateLibrary" ]( false )
	
	if ( currentDate:getweekday( ) ~= 1 ) then -- Set weekday to the first day of the week.
	
		currentDate:adddays( ( currentDate:getweekday( ) - 1 ) * -1 )
		
	end
	
	ui_Objects[ "Week Overview" ] = { }
	
	local lastPosition = 0
	
	-- Cycle through Current Week
	for i = 1, 7 do
	
		
		local caloriesConsumed = 0
		local exerciseCalories = 0
		
		local dayLog = savedData[ "Calorie Log" ][ currentDate:fmt( "%F" ) ]
		if ( dayLog ~= nil ) then
		
			caloriesConsumed = modules[ "dayOverview" ].calculateCaloriesConsumed( dayLog, false )
			exerciseCalories = modules[ "dayOverview" ].calculateExerciseCalories( dayLog )
					
		end
		
		local newDayOverview = { }
		
		-- Background
		newDayOverview[ "Background" ] = display.newRoundedRect( ui_Groups[ 2 ], scrollView.width / 2, 0, display.contentWidth * 0.85, 42 * 4.75 * scaleRatio, 30 )
		newDayOverview[ "Background" ].y = newDayOverview[ "Background" ].height * ( i - 0.5 ) + ( 30 * scaleRatio * i )
		
		lastPosition = newDayOverview[ "Background" ].y + newDayOverview[ "Background" ].height / 2
		
		-- Drop Shadow
		newDayOverview[ "DropShadow" ] = display.newRoundedRect( ui_Groups[ 1 ], newDayOverview[ "Background" ].x + 4 * scaleRatio, newDayOverview[ "Background" ].y + 4 * scaleRatio, newDayOverview[ "Background" ].width, newDayOverview[ "Background" ].height, 30 )
		newDayOverview[ "DropShadow" ]:setFillColor( 0, 0, 0, 0.25 )
	
		-- Date
		newDayOverview[ "Date" ] = display.newText( { parent = ui_Groups[ 3 ], text = currentDate:fmt( "%a, %b %d %Y" ), x = newDayOverview[ "Background" ].x, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 36 * scaleRatio, align = "center" } )
		newDayOverview[ "Date" ].y = ( newDayOverview[ "Background" ].y - newDayOverview[ "Background" ].height / 2 ) + newDayOverview[ "Date" ].height
		newDayOverview[ "Date" ]:setFillColor( 0, 0, 0 )
	
		scrollView:insert( newDayOverview[ "DropShadow" ] )
		scrollView:insert( newDayOverview[ "Background" ] )
		scrollView:insert( newDayOverview[ "Date" ] )


		-- Display Calorie Info
		local calorieBalance = savedData[ "Info" ][ "Calorie Budget" ] - caloriesConsumed
		local balanceState = ""
		local balanceColor = { R = 8 / 255, G = 127 / 255, B = 35 / 255 }
		
		if ( calorieBalance > 0 ) then -- Under Calorie Budget
			
			balanceState = "Under"
		
		elseif ( calorieBalance < 0 ) then -- Over Calorie Budget
			
			balanceState = "Over"
			balanceColor = { R = 244 / 255, G = 67 / 255, B = 54 / 255 }
			
		end
		
		local Stats = { 
			
			{ 
				[ "Name" ] = "Calories Consumed", 
				[ "Title" ] = "Food",
				[ "Value" ] = caloriesConsumed,
				[ "Direction" ] = -1,
				
			},
		
			{ 
				[ "Name" ] = "Exercise", 
				[ "Title" ] = "Exercise",
				[ "Value" ] = exerciseCalories,
				[ "Direction" ] = 0,

				
			},
			
			{ 
				[ "Name" ] = "Calorie Offset", 
				[ "Title" ] = balanceState,
				[ "Value" ] = math.abs( calorieBalance ),
				[ "Direction" ] = 1,

			},
			
			
		}
		
	
		for i = 1, #Stats do
		
			newDayOverview[ Stats[ i ][ "Name" ] ] = { }
			local newStat = newDayOverview[ Stats[ i ][ "Name" ] ]
			
			-- Title
			newStat[ "Title" ] = display.newText( { parent = ui_Groups[ 3 ], text = Stats[ i ][ "Title" ], y = newDayOverview[ "Background" ].y, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 36 * scaleRatio, align = "center" } )
			newStat[ "Title" ].x = newDayOverview[ "Background" ].x + ( ( newDayOverview[ "Background" ].width / 2 - newStat[ "Title" ].width / 2 - ( 40 * scaleRatio ) ) * Stats[ i ][ "Direction" ] )
			newStat[ "Title" ]:setFillColor( 0, 0, 0, 0.6 )
			
			-- Value
			newStat[ "Value" ] = display.newText( { parent = ui_Groups[ 3 ], text = Stats[ i ][ "Value" ], x = newStat[ "Title" ].x, font = "Data/Fonts/Roboto.ttf", fontSize = 36 * scaleRatio, align = "center" } )
			newStat[ "Value" ].y = ( newStat[ "Title" ].y + newStat[ "Title" ].height / 2 ) + newStat[ "Value" ].height * 0.7
			newStat[ "Value" ]:setFillColor( 8 / 255, 127 / 255, 35 / 255 )
			
			-- Add Stat Text to Scroll View
			scrollView:insert( newStat[ "Title" ] )
			scrollView:insert( newStat[ "Value" ] )
		
		end
		
		-- Update Color for Calorie Offset's Value
		newDayOverview[ "Calorie Offset" ][ "Value" ]:setFillColor( balanceColor.R, balanceColor.G, balanceColor.B )
	
		table.insert( ui_Objects[ "Week Overview" ], newDayOverview )
		
		currentDate:adddays( 1 )
		
	end
	
	local newGuideText = display.newText( { parent = ui_Groups[ 3 ], text = "End of Week Overview", x = scrollView.width / 2, font = "Data/Fonts/Roboto.ttf", fontSize = ( 32 * scaleRatio ), align = "center" } )
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
	ui_Objects[ "Topbar" ] = modules[ "topbarManager" ]:new( { [ "Groups" ] = ui_Groups, [ "Title" ] = "Current Week", [ "ScaleRatio" ] = scaleRatio } )
	ui_Objects[ "Topbar" ].ui_Objects[ "leftActionButton" ].Button:addEventListener( "tap", buttonPress )

	local sceneData = { 
		
		[ "SceneName" ] = "Overview",
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

		createWeekOverview( )

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
