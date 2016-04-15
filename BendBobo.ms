plugin simpleMod MyBend
name:"MyBend"
classID:#(0x2b215c83, 0x6d7189d3)
version:1
( 
	parameters main rollout:params
	(
		amount type:#float ui:spn_amount default:0
		direction type:#float ui:spn_direction default:0	
		axis type:#integer ui:rad_axis default:3
		LimitEnabled type:#boolean ui:uiLimitEnabled default:false
		LimitMax type:#worldUnits ui:uiLimitMax default:0
		LimitMin type:#worldUnits ui:uiLimitMin default:0
	)
 
	rollout params "MyBend Parameters"
	(
		group "Bend:"
		(
			spinner spn_amount "Angle: " range:[-100000,100000,0] scale:1
			spinner spn_direction "Direction: " range:[-100000,100000,0] scale:1
		)
		group "Bend Axis:"
		(
			radiobuttons rad_axis labels:#("X","Y","Z") offsets:#([-10,0],[0,0],[10,0])
		)
		group "Limits"
		(
			checkbox uiLimitEnabled "Limit Effect" align:#right
			spinner uiLimitMax "Upper Limit" range:[0,1e9,0] type:#worldUnits
			spinner uiLimitMin "Lower Limit" range:[-1e9,0,0] type:#worldUnits
		)
	)
 
	on map i p do
	(
		if amount != 0 then
		(
			case axis of
			(
				1: (
					theDirMatrix = rotateXMatrix -direction
					if LimitEnabled then 
					(
						theRadius = 180/amount*(LimitMax-LimitMin)/Pi
						theRadiusOffset = [0,0,-theRadius] * theDirMatrix 				
						if p.x > LimitMax then
						(
							TM = rotateYMatrix (amount*(LimitMax)/(LimitMax-LimitMin)) * theDirMatrix
							TM.row4 = theRadiusOffset
							newPoint = ((([0,p.y,p.z]-theRadiusOffset)*inverse theDirMatrix) * TM)
							TM.row4 = [0,0,0]			
							newPoint += [p.x-LimitMax,0,0] * TM							
						)
						else if p.x < LimitMin then
						(
							TM = rotateYMatrix (amount*(LimitMin)/(LimitMax-LimitMin)) * theDirMatrix
							TM.row4 = theRadiusOffset
							newPoint = ((([0,p.y,p.z]-theRadiusOffset)*inverse theDirMatrix) * TM)
							TM.row4 = [0,0,0]			
							newPoint += [p.x-LimitMin,0,0] * TM	
						)
						else
						(
							TM = rotateYMatrix (amount*p.x/(LimitMax-LimitMin)) * theDirMatrix
							TM.row4 = theRadiusOffset
							(([0,p.y,p.z]-theRadiusOffset)*inverse theDirMatrix) * TM 
						)
					)
					else
					(
						theRadius = 180/amount*extent.x/Pi
						theRadiusOffset = [0,0,-theRadius] * theDirMatrix 				
						TM = rotateYMatrix (amount*p.x/extent.x) * theDirMatrix
						TM.row4 = theRadiusOffset
						(([0,p.y,p.z]-theRadiusOffset)*inverse theDirMatrix) * TM 			
					)
				)
				
				2: (
						theDirMatrix = rotateYMatrix -direction
						if LimitEnabled then 
						(
							theRadius = 180/amount*(LimitMax-LimitMin)/Pi
							theRadiusOffset = [theRadius,0,0] * theDirMatrix 				
							if p.y > LimitMax then
							(
								TM = rotateZMatrix (-amount*(LimitMax)/(LimitMax-LimitMin)) * theDirMatrix
								TM.row4 = theRadiusOffset
								newPoint = ((([p.x,0,p.z]-theRadiusOffset)*inverse theDirMatrix) * TM)
								TM.row4 = [0,0,0]			
								newPoint += [0,p.y-LimitMax,0] * TM							
							)
							else if p.y < LimitMin then
							(
								TM = rotateZMatrix (-amount*(LimitMin)/(LimitMax-LimitMin)) * theDirMatrix
								TM.row4 = theRadiusOffset
								newPoint = ((([p.x,0,p.z]-theRadiusOffset)*inverse theDirMatrix) * TM)
								TM.row4 = [0,0,0]			
								newPoint += [0,p.y-LimitMin,0] * TM	
							)
							else
							(
								TM = rotateZMatrix (-amount*p.y/(LimitMax-LimitMin)) * theDirMatrix
								TM.row4 = theRadiusOffset
								(([p.x,0,p.z]-theRadiusOffset)*inverse theDirMatrix) * TM 
							)
						)
						else
						(
							theRadius = 180/amount*extent.y/Pi
							theRadiusOffset = [theRadius,0,0] * theDirMatrix 				
							TM = rotateZMatrix (-amount*p.y/extent.y) * theDirMatrix
							TM.row4 = theRadiusOffset
							(([p.x,0,p.z]-theRadiusOffset)*inverse theDirMatrix) * TM 
						)
					)
				
				default: (
					theDirMatrix = rotateZMatrix -direction
					if LimitEnabled then 
					(
						theRadius = 180/amount*(LimitMax-LimitMin)/Pi
						theRadiusOffset = [theRadius,0,0] * theDirMatrix 
						if p.z > LimitMax then
						(
							TM = rotateYMatrix (amount*LimitMax/(LimitMax-LimitMin)) * theDirMatrix
							TM.row4 = theRadiusOffset
							newPoint = ((([p.x,p.y,0]-theRadiusOffset)*inverse theDirMatrix) * TM)
							TM.row4 = [0,0,0]
							newPoint += [0,0,p.z-LimitMax] * TM
						)
						else if p.z < LimitMin then
						(
							TM = rotateYMatrix (amount*LimitMin/(LimitMax-LimitMin)) * theDirMatrix
							TM.row4 = theRadiusOffset
							newPoint = ((([p.x,p.y,0]-theRadiusOffset)*inverse theDirMatrix) * TM)
							TM.row4 = [0,0,0]
							newPoint += [0,0,p.z-LimitMin] * TM							
						)
						else						
						(
							TM = rotateYMatrix (amount*p.z/(LimitMax-LimitMin)) * theDirMatrix
							TM.row4 = theRadiusOffset
							(([p.x,p.y,0]-theRadiusOffset)*inverse theDirMatrix) * TM 
						)
					)
					else
					(
						theRadius = 180/amount*extent.z/Pi
						theRadiusOffset = [theRadius,0,0] * theDirMatrix 				
						TM = rotateYMatrix (amount*p.z/extent.z) * theDirMatrix
						TM.row4 = theRadiusOffset
						(([p.x,p.y,0]-theRadiusOffset)*inverse theDirMatrix) * TM 
					)
				)	
			)	
		)
		else p
	)
)
