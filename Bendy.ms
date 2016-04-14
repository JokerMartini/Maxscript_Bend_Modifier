plugin simpleMod MyBend
 name:"MyBend"
 classID:#(0x33635bb3, 0x5db238c1)
 version:1
 ( 
 parameters main rollout:params
 (
 amount type:#float ui:spn_amount default:0
 direction type:#float ui:spn_direction default:0	
 axis type:#integer ui:rad_axis default:3
 )
 
 rollout params "MyBend Parameters"
 (
 spinner spn_amount "Amount: " range:[-100000,100000,0] scale:1
 spinner spn_direction "Direction: " range:[-100000,100000,0] scale:1
 radiobuttons rad_axis "Axis:" labels:#("X","Y","Z")
 )
 
 on map i p do
 (
 if amount != 0 then
 (
 	case axis of
 	(
 		1: (
 				theDirMatrix = rotateXMatrix -direction
 				theRadius = 180/amount*extent.x/Pi
 				theRadiusOffset = [0,0,-theRadius] * theDirMatrix 				
 				TM = rotateYMatrix (amount*p.x/extent.x) * theDirMatrix
 				TM.row4 = theRadiusOffset
 				(([0,p.y,p.z]-theRadiusOffset)*inverse theDirMatrix) * TM 			
 			)
 		2: (
 				theDirMatrix = rotateYMatrix -direction
 				theRadius = 180/amount*extent.y/Pi
 				theRadiusOffset = [theRadius,0,0] * theDirMatrix 				
 				TM = rotateZMatrix (-amount*p.y/extent.y) * theDirMatrix
 				TM.row4 = theRadiusOffset
 				(([p.x,0,p.z]-theRadiusOffset)*inverse theDirMatrix) * TM 
 			)
 		default: (
 				theDirMatrix = rotateZMatrix -direction
 				theRadius = 180/amount*extent.z/Pi
 				theRadiusOffset = [theRadius,0,0] * theDirMatrix 				
 				TM = rotateYMatrix (amount*p.z/extent.z) * theDirMatrix
 				TM.row4 = theRadiusOffset
 				(([p.x,p.y,0]-theRadiusOffset)*inverse theDirMatrix) * TM 
 			)	
 	)	
 )
 else p
 )
 
 )
