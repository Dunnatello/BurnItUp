--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Module: Day Overview
Purpose: Display Current Day and Allow Day Navigation

-------------------------

]]

local dayOverview = { currentDate = nil, currentDayLog = nil }
local ui_Objects, ui_Groups, savedData, scaleRatio = nil, nil, nil, 1

local Meals = { "Breakfast", "Lunch", "Dinner" }

-- Modules
local moduleNames = { 

	-- UI
--	{ Name = "createMenuSections", Location = "Data.Modules.UI.createMenuSections" },

	-- Backend
	{ Name = "itemHandler", Location = "Data.Modules.Backend.itemHandler" },
	
	
}

local modules = { }

for i = 1, #moduleNames do
	
	modules[ moduleNames[ i ].Name ] = require( moduleNames[ i ].Location )
	
end


local function generateDefaultLog( ) -- FIXME: Remove Item Listings after creating Add Item Scene Functionality

	local defaultLog = { 
	
		[ "Done" ] = false,
		[ "Meals" ] = { 
			
			[ "Breakfast" ] = { 
				
				{ [ "Name" ] = "Fried Eggs", [ "Category" ] = "General", [ "Amount" ] = 3 },
				{ [ "Name" ] = "Bacon", [ "Category" ] = "General", [ "Amount" ] = 5 },

			},
			[ "Lunch" ] = { },
			[ "Dinner" ] = { },
			
		},
		
		[ "Exercises" ] = { 
		
			{ [ "Name" ] = "Walking", [ "Category" ] = "General", [ "Amount" ] = 15, [ "Calories" ] = 60 },
	
		},
		
	}
	
	return defaultLog
	
end

function dayOverview.update( )

	local overview = ui_Objects[ "Day Overview" ]
	
	overview[ "Date" ].text = dayOverview.currentDate:fmt( "%a, %b %d %Y" )
	
	local caloriesConsumed = 0
	local calorieBudgetStatus = "-"
			
	dayOverview.currentDayLog = savedData[ "Calorie Log" ][ dayOverview.currentDate:fmt( "%F" ) ] or generateDefaultLog( )

	if ( dayOverview.currentDayLog ~= nil ) then -- YYYY-MM-DD
		
		-- Add Food Calories
		for i = 1, #Meals do -- Cycle Through Food Categories
		
			local currentSection = dayOverview.currentDayLog[ "Meals" ][ Meals[ i ] ]
			
			for e = 1, #currentSection do -- Cycle Through Food Items in Section
				print( currentSection[ e ][ "Name" ] )
				local foodInfo = modules[ "itemHandler" ].getFoodInfo( currentSection[ e ][ "Name" ], currentSection[ e ][ "Category" ] )
				
				caloriesConsumed = caloriesConsumed + modules[ "itemHandler" ].getServingCalories( foodInfo, currentSection[ e ][ "Amount" ] )
				
			end
			
		end
		
		-- Remove Exercise Amounts
		for i = 1, #dayOverview.currentDayLog[ "Exercises" ] do
			
			caloriesConsumed = caloriesConsumed - dayOverview.currentDayLog[ "Exercises" ][ i ][ "Calories" ]
			
		end
	
	end
	
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
	
	-- Update Calorie Budget Text
	overview[ "Budget" ][ "Value" ].text = savedData[ "Info" ][ "Calorie Budget" ]

	overview[ "Calorie Offset" ][ "Title" ].text = balanceState
	overview[ "Calorie Offset" ][ "Value" ].text = math.abs( calorieBalance )
	overview[ "Calorie Offset" ][ "Value" ]:setFillColor( balanceColor.R, balanceColor.G, balanceColor.B )
	
end

function dayOverview.create( currentObjects, currentGroups, newScaleRatio, currentSavedData, newDate )
	
	scaleRatio = newScaleRatio or scaleRatio
	
	ui_Objects = currentObjects or ui_Objects
	ui_Groups = currentGroups or ui_Groups
	dayOverview.currentDate = newDate or dayOverview.currentDate
	savedData = currentSavedData or savedData
	

	-- Day Overview
	ui_Objects[ "Day Overview" ] = { }
	local overview = ui_Objects[ "Day Overview" ]
	
	-- Background
	overview[ "Background" ] = display.newRoundedRect( ui_Groups[ 2 ], display.contentCenterX, 0, display.contentWidth * 0.9, 42 * 4.75 * scaleRatio, 30 )
	overview[ "Background" ].y = ( ui_Objects[ "Topbar" ].ui_Objects[ "Topbar" ].Bar.y + ui_Objects[ "Topbar" ].ui_Objects[ "Topbar" ].Bar.height / 2 ) + overview[ "Background" ].height * 0.75
	
	-- Drop Shadow
	overview[ "DropShadow" ] = display.newRoundedRect( ui_Groups[ 1 ], overview[ "Background" ].x + 4 * scaleRatio, overview[ "Background" ].y + 4 * scaleRatio, overview[ "Background" ].width, overview[ "Background" ].height, 30 )
	overview[ "DropShadow" ]:setFillColor( 0, 0, 0, 0.25 )
	
	-- Date
	overview[ "Date" ] = display.newText( { parent = ui_Groups[ 3 ], text = dayOverview.currentDate:fmt( "%a, %b %d %Y" ), x = overview[ "Background" ].x, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 36 * scaleRatio, align = "center" } )
	overview[ "Date" ].y = ( overview[ "Background" ].y - overview[ "Background" ].height / 2 ) + overview[ "Date" ].height
	overview[ "Date" ]:setFillColor( 0, 0, 0 )
	
	-- Nav Arrows
	overview[ "Nav Arrows" ] = { }
	local navArrowNames = { "chevron_left", "chevron_right" }
	local direction = 1
	
	for i = 1, #navArrowNames do
		
		overview[ "Nav Arrows" ][ i ] = { }
		local currentArrow = overview[ "Nav Arrows" ][ i ]
		
		
		currentArrow.Icon = display.newText( { parent = ui_Groups[ 3 ], text = navArrowNames[ i ], x = overview[ "Date" ].x - ( overview[ "Date" ].width * 0.65 ) * direction, y = overview[ "Date" ].y, font = "Data/Fonts/MaterialIcons-Regular.ttf", fontSize = 42 * 2 * scaleRatio, align = "center" } )
		currentArrow.Icon:setFillColor( 0, 0, 0 )
		
		currentArrow.Icon.type = "DayNavigation"
		currentArrow.Icon.myName = navArrowNames[ i ]
		
		direction = direction * -1
		
	end
	
	-- Calorie Budget Stat
	overview[ "Budget" ] = { }
	
	-- Title
	overview[ "Budget" ][ "Title" ] = display.newText( { parent = ui_Groups[ 3 ], text = "Budget", y = overview[ "Background" ].y, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 36 * scaleRatio, align = "center" } )
	overview[ "Budget" ][ "Title" ].x = ( overview[ "Background" ].x - overview[ "Background" ].width / 2 ) + overview[ "Budget" ][ "Title" ].width
	overview[ "Budget" ][ "Title" ]:setFillColor( 0, 0, 0, 0.6 )
	
	-- Value
	overview[ "Budget" ][ "Value" ] = display.newText( { parent = ui_Groups[ 3 ], text = "1560", x = overview[ "Budget" ][ "Title" ].x, font = "Data/Fonts/Roboto.ttf", fontSize = 36 * scaleRatio, align = "center" } )
	overview[ "Budget" ][ "Value" ].y = ( overview[ "Budget" ][ "Title" ].y + overview[ "Budget" ][ "Title" ].height / 2 ) + overview[ "Budget" ][ "Value" ].height * 0.7
	overview[ "Budget" ][ "Value" ]:setFillColor( 8 / 255, 127 / 255, 35 / 255 )

	-- Calorie Budget Stat
	overview[ "Calorie Offset" ] = { }
	
	-- Title
	overview[ "Calorie Offset" ][ "Title" ] = display.newText( { parent = ui_Groups[ 3 ], text = "Under", y = overview[ "Background" ].y, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 36 * scaleRatio, align = "center" } )
	overview[ "Calorie Offset" ][ "Title" ].x = ( overview[ "Background" ].x + overview[ "Background" ].width / 2 ) - overview[ "Budget" ][ "Title" ].width
	overview[ "Calorie Offset" ][ "Title" ]:setFillColor( 0, 0, 0, 0.6 )
	
	-- Value
	overview[ "Calorie Offset" ][ "Value" ] = display.newText( { parent = ui_Groups[ 3 ], text = "300", x = overview[ "Calorie Offset" ][ "Title" ].x, font = "Data/Fonts/Roboto.ttf", fontSize = 36 * scaleRatio, align = "center" } )
	overview[ "Calorie Offset" ][ "Value" ].y = ( overview[ "Calorie Offset" ][ "Title" ].y + overview[ "Calorie Offset" ][ "Title" ].height / 2 ) + overview[ "Calorie Offset" ][ "Value" ].height * 0.7
	overview[ "Calorie Offset" ][ "Value" ]:setFillColor( 8 / 255, 127 / 255, 35 / 255 )
	
end

return dayOverview