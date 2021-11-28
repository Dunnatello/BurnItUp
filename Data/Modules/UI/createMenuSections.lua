--[[ 

-------------------------

Burn it Up! Project

-------------------------

Group: Shark Bait Group 4
Team Members: Chase Balmes, Timothy Bennett, Michael Dunn, Talha Khan, Jonathan Nguyen
Class: CSC 331-101: Software Engineering Principles

-------------------------

Current Module: Create Menu Sections
Purpose: This module is used to create the menu section list for the different categories such as: "Breakfast", "Lunch", and "Dinner" sections.

-------------------------

]]

local sectionCreator = { }

-- Modules
local widget = require( "widget" )
local itemHandler = require( "Data.Modules.Backend.itemHandler" )
local dayOverview = require( "Data.Modules.UI.dayOverview" )
local storage = require( "Data.Modules.Backend.Storage.storageHandler" )

-- Tables/Values
local ui_Groups, ui_Objects, dayLog, scaleRatio = nil, nil, nil, 1
local selectedItem = { [ "Item" ] = nil, [ "Category" ] = nil, [ "Section" ] = nil, [ "ShouldUpdateOverview" ] = true }

local Sections = { { [ "Name" ] = "Breakfast", [ "Category" ] = "Meals" }, { [ "Name" ] = "Lunch", [ "Category" ] = "Meals" }, { [ "Name" ] = "Dinner", [ "Category" ] = "Meals" }, { [ "Name" ] = "Exercises", [ "Category" ] = "Exercises" } }

local function createContentView( ) -- Create ScrollView

	ui_Objects[ "Content View" ] = widget.newScrollView( { x = display.contentCenterX, y = display.contentCenterY, width = display.contentWidth * 0.95, height = display.contentHeight * 0.55, horizontalScrollDisabled = true, hideBackground = true } )
	ui_Objects[ "Content View" ].y = ( ui_Objects[ "Day Overview" ][ "Background" ].y + ui_Objects[ "Day Overview" ][ "Background" ].height / 2 ) + ui_Objects[ "Content View" ].height / 2 + ( 20 * scaleRatio )
	
end

function sectionCreator.setScrollViewVisibility( newStatus ) -- Set ScrollView Visibility State

	ui_Objects[ "Content View" ].isVisible = newStatus
	
end

function sectionCreator.removeSections( ) -- Remove UI and Replace ScrollView

	display.remove( ui_Objects[ "Content View" ] )
	ui_Objects[ "Content View" ] = nil
	
	createContentView( )
	
	ui_Objects[ "Calorie Log" ] = nil
	
end

local function onPromptEnd( event ) -- Native Prompt Ended

	if ( event.action == "clicked"  ) then
	
		local i = event.index
		
		if ( i == 1 ) then -- Delete Item
					
			local isSuccessful = itemHandler.deleteItem( dayLog, selectedItem )
			
			if ( isSuccessful == true ) then
				
				print( "Delete Successful" )
				storage.saveData( )
				sectionCreator.createSections( )
				dayOverview.update( )
				
			end
			
		
		elseif ( i == 2 ) then -- Do nothing. User cancelled the action.
		
		end
		
	end
	
end

local function showPrompt( messageInfo ) -- Prompt User with Choices

	native.showAlert( messageInfo[ "Title" ], messageInfo[ "Message" ], { "Delete", "Cancel" }, onPromptEnd )
	
end

local function listingButtonPress( event ) -- Listing Button Pressed

	local button = event.target
	
	if ( button.buttonType == "ItemListing" ) then -- Item Listing
	
		print( button.myName[ "Name" ], button.category )
		
		-- Set Selected Item Values
		selectedItem[ "Item" ] = button.myName
		selectedItem[ "Category" ] = button.category[ "Category" ]
		selectedItem[ "Section" ] = button.category[ "Name" ]
		
		-- Prompt Option Menu
		showPrompt( { [ "Title" ] = "Delete Item", [ "Message" ] = "Delete " .. button.myName[ "Name" ] .. " from " .. button.category[ "Name" ] .. "?" } )
		
	end
	
end

function sectionCreator.createSections( currentGroups, currentObjects, newScaleRatio, currentDayLog ) -- Create Menu Sections

	print( "Create Sections" )
	
	-- Set New Table Values or Keep Current Values
	ui_Groups = currentGroups or ui_Groups
	ui_Objects = currentObjects or ui_Objects
	scaleRatio = newScaleRatio or scaleRatio
	
	dayLog = currentDayLog or dayLog

	-- If UI Exists Already, Remove It
	if ( ui_Objects[ "Calorie Log" ] ~= nil ) then
		
		sectionCreator.removeSections( )
		
	end
	
	-- If ScrollView Doesn't Exist, Add It
	if ( ui_Objects[ "Content View" ] == nil ) then
		
		createContentView( )
		
	end
	
	local scrollView = ui_Objects[ "Content View" ]
	
	-- If Day Log Doesn't Exist, Add Blank State.
	if ( dayLog == nil ) then
		
		dayLog = { 
		
            [ "Done" ] = false,
            [ "Meals" ] = { 
                
                [ "Breakfast" ] = { },
                [ "Lunch" ] = { },
                [ "Dinner" ] = { },
                
            },
            
            [ "Exercises" ] = { },
			
		}
		
	end
	
	ui_Objects[ "Calorie Log" ] = { }
	
	local calorieLog = ui_Objects[ "Calorie Log" ]
	
	calorieLog[ "Sections" ] = { }
	
	-- Create Sections
	local previousVerticalPosition = 0
	for i = 1, #Sections do

		local newSection = { }
		
		-- Background
		newSection[ "Background" ] = display.newRoundedRect( ui_Groups[ 2 ], scrollView.width / 2, previousVerticalPosition + ( ( display.contentHeight / 8 ) / 2 ) + 20, display.contentWidth * 0.9, display.contentHeight / 8, 30 )
		
		-- Drop Shadow
		newSection[ "DropShadow" ] = display.newRoundedRect( ui_Groups[ 1 ], newSection[ "Background" ].x + ( 4 * scaleRatio ), newSection[ "Background" ].y + ( 4 * scaleRatio ), newSection[ "Background" ].width, newSection[ "Background" ].height, 30 )
		newSection[ "DropShadow" ]:setFillColor( 0, 0, 0, 0.25 )
	
		-- Title
		newSection[ "Title" ] = display.newText( { parent = ui_Groups[ 3 ], text = Sections[ i ][ "Name" ], font = "Data/Fonts/Roboto-Bold", fontSize = 36 * scaleRatio, align = "left" } )
		newSection[ "Title" ].x = ( newSection[ "Background" ].x - newSection[ "Background" ].width / 2 ) + newSection[ "Title" ].width / 2 + ( 20 * scaleRatio )
		newSection[ "Title" ].y = ( newSection[ "Background" ].y - newSection[ "Background" ].height / 2 ) + newSection[ "Title" ].height / 2 + ( 10 * scaleRatio )
		newSection[ "Title" ]:setFillColor( 0, 0, 0 )
		
		-- Add Objects to ScrollView
		scrollView:insert( newSection[ "DropShadow" ] )
		scrollView:insert( newSection[ "Background" ] )
		scrollView:insert( newSection[ "Title" ] )
		
		-- Generate Item List --
		newSection[ "Items" ] = { }

		-- Current Items in Section
		local itemList = dayLog[ Sections[ i ][ "Category" ] ]
		
		-- Handle Nested Lists
		if ( Sections[ i ][ "Name" ] ~= "Exercises" ) then
			
			itemList = itemList[ Sections[ i ][ "Name" ] ]
		
		end
		
		-- Set Section Background Default Size
		local lastItemPosition = newSection[ "Background" ].y + newSection[ "Background" ].height / 2
		
		-- Modify Last Item Position (if this section actually has items)
		if ( #itemList > 0 ) then
		
			lastItemPosition = ( newSection[ "Title" ].y + newSection[ "Title" ].height / 2 )
			
		end
				
		-- Cycle Through Item List
		for e = 1, #itemList do
		
			print( itemList[ e ][ "Name" ], itemList[ e ][ "Category" ] )
			-- Get Item Info
			local itemInfo = itemHandler.getFoodInfo( itemList[ e ][ "Name" ], itemList[ e ][ "Category" ] )
			
		
			-- Create Listing
			local newListing = { }
			
			-- Get Default Values for Item Information
			local subText = itemInfo[ "Serving Type" ]
			local totalCalories = itemList[ e ][ "Calories" ]
			
			-- Modify the text based on the section's context.
			if ( Sections[ i ][ "Name" ] == "Exercises" ) then -- Convert Exercise Information
			
				itemInfo = { [ "Display Name" ] = itemList[ e ][ "Name" ], [ "Amount" ] = itemList[ e ][ "Amount" ], [ "Calories" ] = itemList[ e ][ "Calories" ] }
				
				subText = "Minute(s)"
			
			else -- Get Calories
				
				totalCalories = itemHandler.getServingCalories( itemInfo, itemList[ e ][ "Amount" ] )
				
			end
			
			local listingName = itemInfo[ "Display Name" ]
			
			if ( Sections[ i ][ "Name" ] ~= "Exercises" ) then
			
				listingName = itemInfo[ "Brand" ] .. " | " .. listingName
				
			end
			
			-- Title (Text)
			newListing[ "Title" ] = display.newText( { parent = ui_Groups[ 3 ], text = listingName, font = "Data/Fonts/Roboto-Bold.ttf", fontSize = 28 * scaleRatio, align = "left" } )
			newListing[ "Title" ]:setFillColor( 0, 0, 0 )
			
			newListing[ "Title" ].x = ( newSection[ "Background" ].x - newSection[ "Background" ].width / 2 ) + newListing[ "Title" ].width / 2 + ( 20 * scaleRatio )
			newListing[ "Title" ].y = lastItemPosition + newListing[ "Title" ].height
			
			-- Serving Size (Text)
			newListing[ "Serving" ] = display.newText( { parent = ui_Groups[ 3 ], text = itemList[ e ][ "Amount" ] .. " " .. subText, font = "Data/Fonts/Roboto.ttf", fontSize = 24 * scaleRatio, align = "left" } )
			newListing[ "Serving" ]:setFillColor( 0, 0, 0 )

			newListing[ "Serving" ].x = ( newListing[ "Title" ].x - newListing[ "Title" ].width / 2 ) + newListing[ "Serving" ].width / 2
			newListing[ "Serving" ].y = ( newListing[ "Title" ].y + newListing[ "Title" ].height / 2 ) + newListing[ "Serving" ].height
			
			-- Calories (Text)
			newListing[ "Calories" ] = display.newText( { parent = ui_Groups[ 3 ], text = totalCalories, font = "Data/Fonts/Roboto.ttf", fontSize = 26 * scaleRatio, align = "left" } )
			newListing[ "Calories" ]:setFillColor( 0, 0, 0 )
			
			newListing[ "Calories" ].x = ( newSection[ "Background" ].x + newSection[ "Background" ].width / 2 ) - newListing[ "Calories" ].width / 2 - ( 20 * scaleRatio )
			newListing[ "Calories" ].y = newListing[ "Title" ].y
			
			-- Invisible Button
			newListing[ "Button" ] = display.newRect( ui_Groups[ 2 ], newSection[ "Background" ].x, ( newListing[ "Title" ].y + newListing[ "Serving" ].y ) / 2, newSection[ "Background" ].width * 0.9, ( newListing[ "Serving" ].y + newListing[ "Serving" ].height / 2 ) - ( newListing[ "Title" ].y - newListing[ "Title" ].height / 2 ) )
			newListing[ "Button" ].myName = itemList[ e ]
			newListing[ "Button" ].buttonType = "ItemListing"
			newListing[ "Button" ].category = Sections[ i ]
		
			newListing[ "Button" ]:addEventListener( "tap", listingButtonPress )
		
			-- Add Listing to ScrollView
			scrollView:insert( newListing[ "Button" ] )
			scrollView:insert( newListing[ "Title" ] )
			scrollView:insert( newListing[ "Serving" ] )
			scrollView:insert( newListing[ "Calories" ] )
			
			-- Add Item to Tracked Table
			table.insert( newSection[ "Items" ], newListing )
			
			-- Update Last Item Position
			lastItemPosition = newListing[ "Serving" ].y + newListing[ "Serving" ].height
			
		end
		
		-- Update Section Background & Drop Shadow to Reflect Number of Listings
		
		-- Width, Height
		newSection[ "Background" ].height = ( lastItemPosition - ( newSection[ "Background" ].y - newSection[ "Background" ].height / 2 ) )
		newSection[ "DropShadow" ].height = newSection[ "Background" ].height

		-- X, Y
		newSection[ "Background" ].x, newSection[ "Background" ].y = scrollView.width / 2, previousVerticalPosition + ( newSection[ "Background" ].height / 2 ) + 20
		newSection[ "DropShadow" ].x, newSection[ "DropShadow" ].y = newSection[ "Background" ].x + ( 4 * scaleRatio ), newSection[ "Background" ].y + ( 4 * scaleRatio )

		 -- Generate Blank State
		if ( #itemList == 0 ) then
			
			-- Create Message
			local newBlankStateMessage = display.newText( { parent = ui_Groups[ 3 ], text = "No " .. Sections[ i ][ "Name" ] .. " Added.", y = newSection[ "Background" ].y, font = "Data/Fonts/Roboto", fontSize = 28 * scaleRatio, align = "left" } )
			newBlankStateMessage.x = ( newSection[ "Background" ].x - newSection[ "Background" ].width / 2 ) + newBlankStateMessage.width / 2 + ( 20 * scaleRatio )
			newBlankStateMessage:setFillColor( 0, 0, 0 )
			
			-- Add Message to Section Items List
			table.insert( newSection[ "Items" ], newBlankStateMessage )
			
			-- Add to ScrollView
			scrollView:insert( newBlankStateMessage )
			
		end
	
		-- Add Section to Table
		table.insert( calorieLog[ "Sections" ], newSection )
		
		-- Update Vertical Position
		previousVerticalPosition = newSection[ "Background" ].y + newSection[ "Background" ].height / 2
		
	end
	
end

return sectionCreator