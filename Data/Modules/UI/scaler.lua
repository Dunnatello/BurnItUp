-- Scaler Module
-- Scales content based on the display aspect ratio compared to a 1080p display.

local Scaler = {}

function Scaler.new( )
	
	local divisor = 1080 -- The standard height of the display. Scaling is based on developing for a 1920x1080p display.
	
	local newScaleRatio
	
	local AspectRatio = display.contentWidth / display.contentHeight -- Get the current aspect ratio of the display.
	
	if ( AspectRatio < 1 ) then -- Portrait mode. The divisor should be changed to 1920 as that is the scale height.
		
		divisor = 1280 -- Would use 1920, but it is a bit jarring when moving from 1080 to 1920 on divisors.
		
	end
	
	local newDivisor = ( divisor * AspectRatio ) -- Get the base height based on the current aspect ratio.
	
	if ( newDivisor ~= math.floor( newDivisor ) ) then -- If the number is not rounded, round it to the next number.
		
		newDivisor = math.floor( newDivisor ) + 1
		
	end
	
	newScaleRatio = display.contentWidth / newDivisor -- Get the new scale value.
	
	print("Resolution: " .. display.contentWidth .. " x " .. display.contentHeight .. ", Aspect Ratio: " .. AspectRatio .. ", Ratio: " .. newScaleRatio ) 

	return newScaleRatio
	
end

return Scaler