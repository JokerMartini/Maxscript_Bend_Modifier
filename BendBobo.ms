   plugin simpleMod Bend1D
   	name:"Bend1D"
   	classID:#(0x00001967, 0x001182ab)
   (
   	parameters main rollout:main 
   	(
   		angle type:#float ui:ui_angle default:0
   		axis type:#integer ui:ui_axis default:3
   		direction type:#float ui:ui_direction default:0
   	)
   	
   	rollout main "Parameters"
   	(
   		group "Bend: "
   		(
   			spinner ui_angle "Angle: " range:[-1e9,1e9,0] type:#float fieldwidth:64 align:#rigth offset:[4,0]
   			spinner ui_direction "Direction: " range:[-1e9,1e9,0] type:#float scale:0.1 fieldwidth:64 align:#rigth offset:[4,-1]
   		)
   		group "Bend Axis: "
   		(
   			radiobuttons ui_axis labels:#("X   ", "Y", "Z") columns:3 align:#left offset:[20,0]
   		)
   	)
   	local last, value, dirMatrix, factor, rotateMatrix
   	on map i p do if angle == 0 then p else
   	(
   		if value == undefined or last != [angle,direction,axis] do 
   		(
   			factor = angle/extent
   			radius = (180.0/pi/factor)[axis]
   			
   			case axis of
   			(
   				1: 
   				(
   					dirMatrix = rotateXMatrix -direction
   					value = [0,0,-radius]*dirMatrix 
   					rotateMatrix = rotateYMatrix
   				)
   				2: 
   				(
   					dirMatrix = rotateYMatrix -direction
   					value = [radius,0,0] * dirMatrix 				
   					rotateMatrix = rotateZMatrix
   					factor = -factor
   				)
   				default: 
   				(
   					dirMatrix = rotateZMatrix -direction
   					value = [radius,0,0]* dirMatrix 				
   					rotateMatrix = rotateYMatrix
   				)				
   			)
   			last = [angle,direction,axis]
   		)
   		tm = translate ((rotateMatrix (factor*p)[axis]) * dirMatrix) value
   		p[axis] = 0
   		(p - value)*(inverse dirMatrix)*tm
   	)
   )
   
