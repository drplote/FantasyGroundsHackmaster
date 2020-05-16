local aHackingCritMatrix = {};
local aCrushingCritMatrix = {};
local aPiercingCritMatrix = {};
local aCritLocations = {};


function onInit()
	Comm.registerSlashHandler("crit", onCritSlashCommand);
	aHackingCritMatrix["Foot, top"] 			= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Heel"] 					= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Toe(s)"] 				= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Foot, arch"] 			= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Ankle, inner"] 			= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Ankle, outer"] 			= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Ankle, upper/Achilles"] = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Shin"] 				 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Calf"] 				 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Knee"] 				 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Knee, back"] 		 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Hamstring"] 		 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Thigh"] 			 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Hip"] 				 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Groin"] 			 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Buttock"] 			 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Abdomen, Lower"] 	 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Side, lower"] 	 	 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Abdomen, upper"] 	 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Back, small of"] 	 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Back, lower"] 		 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Chest"] 			 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Side, upper"] 		 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Back, upper"] 		 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Back, upper middle"] 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Armpit"] 			 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Arm, upper outer"]   	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Arm, upper inner"]   	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Elbow"] 		     	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Inner joint"] 	     	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Forearm, back"]      	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Forearm, inner"]     	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Wrist, back"]        	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Wrist, front"]       	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Hand, back"]         	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Palm"]               	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Finger(s)"]          	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Shoulder, side"]     	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Shoulder, top"]      	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Neck, front"]        	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Neck, back"]         	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Neck, side"]         	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Head, side"]         	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Head, back lower"]   	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Face, lower side"]   	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Face, lower center"] 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Head, back upper"]   	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Face, upper side"]   	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Face, upper center"] 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aHackingCritMatrix["Head, top"] 		 	= { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	
	-- TODO: matrix
	aCrushingCritMatrix["Foot, top"] 			 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Heel"] 				 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Toe(s)"] 				 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Foot, arch"] 			 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Ankle, inner"] 		 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Ankle, outer"] 		 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Ankle, upper/Achilles"] = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Shin"] 				 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Calf"] 				 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Knee"] 				 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Knee, back"] 		 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Hamstring"] 		 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Thigh"] 			 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Hip"] 				 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Groin"] 			 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Buttock"] 			 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Abdomen, Lower"] 	 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Side, lower"] 	 	 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Abdomen, upper"] 	 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Back, small of"] 	 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Back, lower"] 		 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Chest"] 			 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Side, upper"] 		 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Back, upper"] 		 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Back, upper middle"] 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Armpit"] 			 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Arm, upper outer"]   	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Arm, upper inner"]   	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Elbow"] 		     	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Inner joint"] 	     	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Forearm, back"]      	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Forearm, inner"]     	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Wrist, back"]        	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Wrist, front"]       	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Hand, back"]         	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Palm"]               	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Finger(s)"]          	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Shoulder, side"]     	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Shoulder, top"]      	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Neck, front"]        	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Neck, back"]         	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Neck, side"]         	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Head, side"]         	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Head, back lower"]   	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Face, lower side"]   	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Face, lower center"] 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Head, back upper"]   	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Face, upper side"]   	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Face, upper center"] 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aCrushingCritMatrix["Head, top"] 		 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	
	-- TODO: matrix
	aPiercingCritMatrix["Foot, top"] 			 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Heel"] 				 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Toe(s)"] 				 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Foot, arch"] 			 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Ankle, inner"] 		 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Ankle, outer"] 		 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Ankle, upper/Achilles"] = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Shin"] 			 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Calf"] 			 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Knee"] 			 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Knee, back"] 		 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Hamstring"] 		 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Thigh"] 			 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Hip"] 				 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Groin"] 			 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Buttock"] 			 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Abdomen, Lower"] 	 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Side, lower"] 	 	 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Abdomen, upper"] 	 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Back, small of"] 	 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Back, lower"] 		 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Chest"] 			 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Side, upper"] 		 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Back, upper"] 		 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Back, upper middle"] 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Armpit"] 			 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Arm, upper outer"]   	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Arm, upper inner"]   	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Elbow"] 		     	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Inner joint"] 	     	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Forearm, back"]      	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Forearm, inner"]     	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Wrist, back"]        	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Wrist, front"]       	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Hand, back"]         	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Palm"]               	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Finger(s)"]          	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Shoulder, side"]     	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Shoulder, top"]      	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Neck, front"]        	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Neck, back"]         	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Neck, side"]         	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Head, side"]         	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Head, back lower"]   	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Face, lower side"]   	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Face, lower center"] 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Head, back upper"]   	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Face, upper side"]   	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Face, upper center"] 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	aPiercingCritMatrix["Head, top"] 		 	 = { {db=1},{db=1},{db=3},{db=3},{db=4},{db=4},{db=6},{db=6},{db=8},{db=8},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2},{dm=2}};
	
	-- = { isSpine=false, 
	aCritLocations["Foot, top"] 			    = { isLeg=true, skeletal={"Tarsus"}, muscular={"1d5 Extensor Tendons of the Toes"}};
	aCritLocations["Heel"] 						= { isLeg=true, skeletal={"Os Calcis"}, muscular={"Achilles Tendon"}};
	aCritLocations["Toe(s)"] 					= { isLeg=true, isDigit=true, skeletal={"1d10 Metatarsus and Phalanges Bones"}, muscular={"1d5 Extensor Tendons of the Toes"}};
	aCritLocations["Foot, arch"] 				= { isLeg=true, skeletal={"Tarsus"}, muscular={"Extensor Brevis Hallucis"}};
	aCritLocations["Ankle, inner"] 				= { isLeg=true, skeletal={"Internal Malleolus"}, muscular={"Soleus"}};
	aCritLocations["Ankle, outer"] 				= { isLeg=true, skeletal={"External Malleolus"}, muscular={"Extensor Longus Digitorum", "Peroneous Longus et Brevis"}};
	aCritLocations["Ankle, upper/Achilles"] 	= { isLeg=true, skeletal={"Internal Malleolus", "External Malleolus"}, muscular={"Tibialis Anticus", "Extensor Longus Hallucis"}};
	aCritLocations["Shin"] 				 		= { isLeg=true, skeletal={"Fibula", "Tibia"}, muscular={"Tibialis Anticus", "Soleus"}};
	aCritLocations["Calf"] 				 		= { isLeg=true, skeletal={"Fibula", "Tibia"}, muscular={"Soleus", "Gastrocnemius"}};
	aCritLocations["Knee"] 				 		= { isLeg=true,skeletal={"Outer Tuberosity of the Femur", "Patella", "Inner Tuberosity of the Femur"}, muscular={"Patella Tendon"}};
	aCritLocations["Knee, back"] 		 		= { isLeg=true,skeletal={"Condyle of Femur"}, muscular={"Gastrocnemius"}};
	aCritLocations["Hamstring"] 		 		= { isLeg=true,skeletal={"Femur"}, muscular={"Biceps Femoris"}};
	aCritLocations["Thigh"] 			 		= { isLeg=true,skeletal={"Femur"}, muscular={"Tendon of the Extensors of the Leg", "Vastus Internus", "Vastus Externus", "Adductor Magnus", "Rectus Femoris"}};
	aCritLocations["Hip"] 				 		= { isLeg=true, skeletal={"Trochanter", "Neck of the Femur", "Head of the Femur", "Illium"}, muscular={"Gluteus Medius", "Tensor Vaginae Femoris"}, vital={"Large Intestine", "Small Intestine"}};
	aCritLocations["Groin"] 			 		= { isLeg=true, skeletal={"Os Pubis"}, muscular={"Adductor Magnus", "Extensor Longus Digitorum", "Pectineus", "Adductor Longus"}, vital={"Bladder", "Small Intestine"}};
	aCritLocations["Buttock"] 			 		= { isLeg=true, skeletal={"Ilium", "Sacrum", "Coccyx"}, muscular={"Gluteus Maximus"}, vital={} };
	aCritLocations["Abdomen, Lower"] 	 		= { isTorso=true, skeletal={"Ilium", "Os Pubis", "Sacrum"}, muscular={"Aponeurosis of Obliquus Externus Abdominis", "Rectus Abdominis"}, vital={"Pancreas", "Duodenum", "Kidney", "Small Intestine"} };
	aCritLocations["Side, lower"] 	 	 		= { isTorso=true, skeletal={"Crest of the Ilium", "1d2 Lumbar Vertebrae: 2nd to 3rd"}, muscular={"Crest of the Ilium", "Obliquus Internus Abdominis"}, vital={"Spleen or Liver", "Lung"} };
	aCritLocations["Abdomen, upper"] 	 		= { isTorso=true, skeletal={"1d2 Lumbar Vertebrae: 2nd to 3rd"}, muscular={"Aponeurosis of Obliquus Externus Abdominis", "Rectus Abdominis"}, vital={"Spleen", "Stomach", "Liver"} };
	aCritLocations["Back, small of"] 	 		= { isTorso=true, isSpine=true, skeletal={"1d3 Lumbar Vertebrae: 1st to 3rd"}, muscular={"External Oblique", "Erector Spinae"}, vital={"Kidney", "Spinal Cord"} };
	aCritLocations["Back, lower"] 		 		= { isTorso=true, isSpine=true, skeletal={"1d3 Lumbar Vertebrae: 1st to 3rd"}, muscular={"Latissimus Dorsi"}, vital={"1d2 Kidneys", "Spinal Cord"} };
	aCritLocations["Chest"] 			 		= { isTorso=true, isSpine=true, skeletal={"1d6 Lower Ribs", "1d6 Upper Ribs", "Sternum: Manubrium", "Sternum: Gladiolus"}, muscular={"Aponeurosis of Obliquus Externus Abdominis", "Obliquus Externus Abdominis", "Rectus Abdominis"}, vital={"Lung", "Heart", "Spinal Cord"} };
	aCritLocations["Side, upper"] 		 		= { isTorso=true, skeletal={"1d6 Lower Ribs", "1d6 Upper Ribs"}, muscular={"Serratus Magnus", "Obliquus Externus Abdominis"}, vital={"Lung"} };
	aCritLocations["Back, upper"] 		 		= { isTorso=true, isSpine=true, skeletal={"Scapula", "1d4 Upper Ribs", "1d4 Middle Ribs", "1d4 Lower Ribs"}, muscular={"Deltoid", "Teres Major"}, vital={"Spinal Cord"} };
	aCritLocations["Back, upper middle"] 	    = { isTorso=true, isSpine=true, skeletal={"1d4 Lower Dorsal Vertebrae: 9th to 12th", "1d4 Middle Dorsal Vertebrae: 5th to 8th", "1d4 Upper Dorsal Vertebrae: 1st to 4th"}, muscular={"Trapezius"}, vital={"Spinal Cord"} };
	aCritLocations["Armpit"] 			 	    = { isArm=true, skeletal={"Head of the Humerus", "Scapula", "1d3 Ribs"}, muscular={"Pectoralis Major", "Coraco-brachialis", "Deltoid"}, vital={} };
	aCritLocations["Arm, upper outer"]   	    = { isArm=true, skeletal={"Humerus"}, muscular={"Triceps Extensor Cubiti", "Biceps Flexor Cubiti"}, vital={} };
	aCritLocations["Arm, upper inner"]   	    = { isArm=true, skeletal={"Humerus"}, muscular={"Trcipes Extensor Cubiti", "Biceps Flexor Cubiti"}, vital={} };
	aCritLocations["Elbow"] 		     	    = { isArm=true, skeletal={"Olecranon Process of the Ulna"}, muscular={"Flexor Longus Pollicis"}, vital={} };
	aCritLocations["Inner joint"] 	     	    = { isArm=true, skeletal={"Trochlea", "Radial Head of the Humerus"}, muscular={"Pronator Radii Teres", "Supinator Longus"}, vital={} };
	aCritLocations["Forearm, back"]      	    = { isArm=true, skeletal={"Radius", "Ulna"}, muscular={"Extensor Carpi Radialis Brevior", "Extensor Carpi Radialis Longior"}, vital={} };
	aCritLocations["Forearm, inner"]     	    = { isArm=true, skeletal={"Ulna", "Radius"}, muscular={"Palmaris Longus", "Supinator Longus", "Flexor Carpi Radialis"}, vital={} };
	aCritLocations["Wrist, back"]        	    = { isArm=true, skeletal={"1d8 Carpus Bones"}, muscular={"Anterior Annular Ligament of the Wrist"}, vital={} };
	aCritLocations["Wrist, front"]       	    = { isArm=true, skeletal={"1d8 Carpus Bones"}, muscular={"Anterior Annular Ligament of the Wrist"}, vital={} };
	aCritLocations["Hand, back"]         	    = { isArm=true, skeletal={"1d5 Metacarpus Bones"}, muscular={"Extensor Communis Digitorum", "1d5 Flexor Tendons of the Fingers"}, vital={} };
	aCritLocations["Palm"]               	    = { isArm=true, isDigit=true, skeletal={"1d5 Metacarpus Bones"}, muscular={"Plamaris Brevis", "Abductor Pollicis"}, vital={} };
	aCritLocations["Finger(s)"]          	    = { isArm=true, skeletal={"1d4+1 Phalanges"}, muscular={"1d5 Flexor Tendons of the Fingers"}, vital={} };
	aCritLocations["Shoulder, side"]     	    = { isArm=true, skeletal={"Head of the Humerus"}, muscular={"Deltoid", "Long Tendon of the Biceps Flexor Cubiti", "Tendon of the Pectoralis Major", "Coraco-brachialis"}, vital={} };
	aCritLocations["Shoulder, top"]      	    = { isArm=true, skeletal={"Head of the Humerus", "Coracoid Process of the Scapula", "Clavicle"}, muscular={"Subclavius", "Deltoid"}, vital={} };
	aCritLocations["Neck, front"]        	    = { isHead=true, isSpine=true, skeletal={"1d4 Cervical Vertebrae from 7th to 4th", "1d4 Cervical Vertebrae from 2nd to 5th"}, muscular={"Sterno-hyoid Muscle", "Omo-Hyoid Muscle", "Thyro-hyoid Muscle"}, vital={"Trachea", "Spinal Cord"} };
	aCritLocations["Neck, back"]         	    = { isHead=true, isSpine=true, skeletal={"1d6 Cervical Vertebrae from 2nd to 7th"}, muscular={"Trapezius"}, vital={"Spinal Cord"} };
	aCritLocations["Neck, side"]         	    = { isHead=true, isSpine=true, skeletal={"1d4 Cervical Vertebrae from 7th to 4th", "1d4 Cervical Vertebrae from 2nd to 5th"}, muscular={"Platysma Moyides", "Scalenus Anticus, Medius and Posticus"}, vital={"Trachea", "Spinal Cord"} };
	aCritLocations["Head, side"]         	    = { isHead=true, skeletal={"Parietal Bone"}, muscular={"Masseter"}, vital={"Brain"} };
	aCritLocations["Head, back lower"]   	    = { isHead=true, isSpine=true, skeletal={"Basilar Process of the Occipital Bone", "First Cervical Vertebrae", "Occipital Bone"}, muscular={"Trapezius"}, vital={"Medulla Oblongata", "Spinal Cord"} };
	aCritLocations["Face, lower side"]   	    = { isHead=true, skeletal={"Inferior Maxillary Bone", "Mastoid Temporal Bone"}, muscular={"Zygomaticus Major and Minor", "Buccinator"}, vital={} };
	aCritLocations["Face, lower center"] 	    = { isHead=true, isSpine=true, skeletal={"Inferior Maxillary Bone", "Teeth", "Superior Maxillary Bones"}, muscular={"Quadratus Menti", "Quadratus Oris"}, vital={"Spinal Cord"} }; 
	aCritLocations["Head, back upper"]   	    = { isHead=true, skeletal={"Parietal Bones"}, muscular={"Occipito-frontalis"}, vital={"Brain"} };
	aCritLocations["Face, upper side"]   	    = { isHead=true, skeletal={"Temporal Bone", "Sphenoid Bone"}, muscular={"Temporalis"}, vital={"Brain"} };
	aCritLocations["Face, upper center"] 	    = { isHead=true, skeletal={"Nasal Bones", "Frontal Bone, Lower", "Frontal Bone, Upper"}, muscular={"Occipito-frontalis", "Orbicularis Palpebrarum", "Levator Labii Superioris"}, vital={"Brain"} };
	aCritLocations["Head, top"] 		 	    = { isHead=true, skeletal={"Frontal Bone"}, muscular={"Occipito-frontalis"}, vital={"Brain"} };

end

function deliverChatMessage(sText)
	local rMessage = ChatManager.createBaseMessage();
	rMessage.type = "crit";
	rMessage.text = sText;
	Comm.deliverChatMessage(rMessage);
	-- TODO: Maybe hide from players?
end

function onCritSlashCommand(sCmd, sParam)
	local sText = "[Critical Hit Result] " .. " Sure would be cool if this feature were implemented yet.";
	deliverChatMessage(sText);
end

function getHitLocation(nHitLocationRoll)
	if not nHitLocationRoll then nHitLocationRoll = math.random(1, 10000) end;
	local nMaxDamagePercentage = 1.0;
	local bIsRightSide = nHitLocationRoll % 2 == 0;
	local sLocation = "";
		
	if nHitLocationRoll < 101 then sLocation = "Foot, top"; nMaxDamagePercentage = .1;
	elseif nHitLocationRoll < 105 then sLocation = "Heel"; nMaxDamagePercentage = .1;
	elseif nHitLocationRoll < 137 then sLocation = "Toe(s)"; nMaxDamagePercentage = .01;
	elseif nHitLocationRoll < 141 then sLocation = "Foot, arch"; nMaxDamagePercentage = .1;
	elseif nHitLocationRoll < 171 then sLocation = "Ankle, inner"; nMaxDamagePercentage = .015;
	elseif nHitLocationRoll < 201 then sLocation = "Ankle, outer"; nMaxDamagePercentage = .015;
	elseif nHitLocationRoll < 221 then sLocation = "Ankle, upper/Achilles"; nMaxDamagePercentage = .015;
	elseif nHitLocationRoll < 965 then sLocation = "Shin"; nMaxDamagePercentage = .025;
	elseif nHitLocationRoll < 1007 then sLocation = "Calf"; nMaxDamagePercentage = .025;
	elseif nHitLocationRoll < 1119 then sLocation = "Knee"; nMaxDamagePercentage = .025;
	elseif nHitLocationRoll < 1133 then sLocation = "Knee, back"; nMaxDamagePercentage = .025;
	elseif nHitLocationRoll < 1217 then sLocation = "Hamstring"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 2001 then sLocation = "Thigh"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 2331 then sLocation = "Hip"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 2406 then sLocation = "Groin"; nMaxDamagePercentage = .2;
	elseif nHitLocationRoll < 2436 then sLocation = "Buttock"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 2571 then sLocation = "Abdomen, Lower"; nMaxDamagePercentage = .8;
	elseif nHitLocationRoll < 3021 then sLocation = "Side, lower"; nMaxDamagePercentage = .8;
	elseif nHitLocationRoll < 3111 then sLocation = "Abdomen, upper"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 3126 then sLocation = "Back, small of"; nMaxDamagePercentage = 1.0
	elseif nHitLocationRoll < 3156 then sLocation = "Back, lower"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 3426 then sLocation = "Chest"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 3456 then sLocation = "Side, upper"; nMaxDamagePercentage = .8;
	elseif nHitLocationRoll < 3486 then sLocation = "Back, upper"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 3501 then sLocation = "Back, upper middle"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 3821 then sLocation = "Armpit"; nMaxDamagePercentage = .3;
	elseif nHitLocationRoll < 4301 then sLocation = "Arm, upper outer"; nMaxDamagePercentage = .3;
	elseif nHitLocationRoll < 4493 then sLocation = "Arm, upper inner"; nMaxDamagePercentage = .3;
	elseif nHitLocationRoll < 4589 then sLocation = "Elbow"; nMaxDamagePercentage = .025;
	elseif nHitLocationRoll < 4685 then sLocation = "Inner joint"; nMaxDamagePercentage = .025;
	elseif nHitLocationRoll < 5309 then sLocation = "Forearm, back";  nMaxDamagePercentage = .3;
	elseif nHitLocationRoll < 5837 then sLocation = "Forearm, inner"; nMaxDamagePercentage = .3;
	elseif nHitLocationRoll < 5909 then sLocation = "Wrist, back"; nMaxDamagePercentage = .1;
	elseif nHitLocationRoll < 5981 then sLocation = "Wrist, front"; nMaxDamagePercentage = .1;
	elseif nHitLocationRoll < 6053 then sLocation = "Hand, back"; nMaxDamagePercentage = .1;
	elseif nHitLocationRoll < 6077 then sLocation = "Palm"; nMaxDamagePercentage = .1;
	elseif nHitLocationRoll < 6221 then sLocation = "Finger(s)"; nMaxDamagePercentage = .01;
	elseif nHitLocationRoll < 7181 then sLocation = "Shoulder, side"; nMaxDamagePercentage = .3;
	elseif nHitLocationRoll < 9101 then sLocation = "Shoulder, top"; nMaxDamagePercentage = .3;
	elseif nHitLocationRoll < 9122 then sLocation = "Neck, front"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 9143 then sLocation = "Neck, back"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 9374 then sLocation = "Neck, side"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 9654 then sLocation = "Head, side"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 9689 then sLocation = "Head, back lower"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 9769 then sLocation = "Face, lower side"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 9789 then sLocation = "Face, lower center"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 9824 then sLocation = "Head, back upper"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 9904 then sLocation = "Face, upper side"; nMaxDamagePercentage = 1.0;
	elseif nHitLocationRoll < 9924 then sLocation = "Face, upper center"; nMaxDamagePercentage = 1.0;
	else sLocation = "Head, top"; nMaxDamagePercentage = 1.0;
	end
	
	local sSide = "";
	if bIsRightSide then
		sSide = "right"
	else	
		sSide = "left"
	end
	
	return sLocation, sSide, rHitAreas, nMaxDamagePercentage;
end

function decodeDamageTypes(sDamageTypes)
	local aDamageTypes = {};
	for sDamageType in sDamageTypes:gmatch("([^,]+)") do
		aDamageTypes[#aDamageTypes+1] = sDamageType;
	end
	return aDamageTypes;
end

function getCritType(sDamageTypes)
	local aDamageTypes = decodeDamageTypes(sDamageTypes);
	local sCritType = "";
	if aDamageTypes and #aDamageTypes > 0 then
		local nRandomSelection = math.random(1, #aDamageTypes); -- Pick a random type if it has more than one.
		local sFormatted = string.gsub(string.lower(aDamageTypes[nRandomSelection]), "%s+", "");
		sCritType = sFormatted;
	end
	if not sCritType or sCritType == "" then
		sCritType = "h"; -- couldn't parse anything, so call it hacking.
	else
		local sFirstChar = string.sub(sCritType, 1, 1);
		if sFirstChar == "s" or sFirstChar == "h" then
			sCritType = "h";
		elseif sFirstChar == "b" or sFirstChar == "c" then
			sCritType = "c";
		elseif sFirstChar == "p" then
			sCritType = "p"
		else
			sCritType = "h"; -- couldn't parse anything, so call it hacking.
		end
	end
	
	return sCritType;
end

function getCritEffect(sLocation, nSeverity, sDamageTypes)
	local sCritType = getCritType(sDamageTypes);
	if sCritType == "p" then
		return getPiercingCrit(sLocation, nSeverity);
	elseif sCritType == "b" then
		return getCrushingCrit(sLocation, nSeverity);
	else	
		return getHackingCrit(sLocation, nSeverity);
	end
end


function handleCrit(nAttackerThaco, nTargetAc, nAttackBonus, rTarget, sDamageTypes)
	local nBaseSeverity = calculateBaseSeverity(nAttackerThaco, nTargetAc, nAttackBonus);
	local nSeverity = math.min(nBaseSeverity + DiceMechanicsManager.rollPenetrateInBothDirection(8), 24);

	local sResult = "[Critical Hit]\r[Severity: " .. nSeverity .. "(Base " .. nBaseSeverity .. ")]"
	if nSeverity < 0 then	
		sResult = sResult .. "\rNo extra effect";
	else
		local nHitLocationRoll = math.random(1, 10000);
		local sLocation, sSide, nMaxDamagePercentage = getHitLocation(nHitLocationRoll);
		local sEffect = "crit effect";
		local bHasScar = math.random(1, 100) <= 5 * nSeverity;
		local bPermanentDamage = nSeverity >= 13;
		if bHasScar then
			sResult = sResult .. "\r[Will Scar?: Yes]";
		else
			sResult = sResult .. "\r[Will Scar?: No]";
		end
		if bPermanentDamage then
			sResult = sResult .. "\r[Permanent Penalties: Will not heal normally. 50% of ability reductions, movement penalties, etc. will remain permanently if left to heal naturally. If cured by magic, 25% will remain permanently. A Cure Critical Wounds spell can cure one critical injury per application if the wound has not been healed by another method and one week has not transpired. See other Cleric spells for other healing possibilities.]"
		end
		sResult = sResult .. "\r[Bruised: 20 - Con days (minimum 1). If injured in same location again before healed, suffer +1 damage per injury.]"; 
		if nSeverity > 5 then
			sResult = sResult .. "\r[Unable to follow-through damage until wound healed]";
		end
		if nSeverity > 10 then	
			sResult = sResult .. "\r[Unable to crit until wound healed]";
		end
		if nSeverity > 15 then
			sResult = sResult .. "\r[Unable to penetrate damage until wound healed]";
		end
		
		sResult = sResult .. "\r[Location (d10000=" .. nHitLocationRoll .. "): " .. sLocation .. "(" .. sSide .. ")]";
		sResult = sResult .. "\r[Effect: " .. getCritEffect(sLocation, nSeverity, sDamageTypes) .. "]";
		
		-- TODO: need to talk about max damage possible

	end

	deliverChatMessage(sResult);
end

function calculateBaseSeverity(nAttackerThaco, nTargetAc, nAttackBonus)
	local nToHitAc15 = nAttackerThaco - 15;
	return nTargetAc - nToHitAc15 + nAttackBonus;
end

function getPiercingCrit(sLocation, nSeverity)
	return decodeCritEffect(aPiercingCritMatrix[sLocation][nSeverity], sLocation, nSeverity);
end

function getCrushingCrit(sLocation, nSeverity)
	return decodeCritEffect(aCrushingCritMatrix[sLocation][nSeverity], sLocation, nSeverity);
end

function getHackingCrit(sLocation, nSeverity)
	return decodeCritEffect(aHackingCritMatrix[sLocation][nSeverity], sLocation, nSeverity);
end

function decodeCritEffect(rCritEffect, sLocation, nSeverity)
	local rLocation = getLocation(sLocation);
	local aEffects = {};
	
	if rCritEffect.db then
		decodeDamageBonus(aEffects, rCritEffect.db);
	end
	if rCritEffect.dm then
		decodeDamageMultiplier(aEffects, rCritEffect.dm);
	end
	if rCritEffect.m then
		decodeMovement(aEffects, rCritEffect.m);
	end
	if rCritEffect.f then
		decodeFall(aEffects);
	end
	if rCritEffect.a then
		decodeToHitReduction(aEffects, rCritEffect.a);
	end
	if rCritEffect.s then
		decodeStrengthReduction(aEffects, rCritEffect.s);
	end
	if rCritEffect.d then
		decodeStrengthReduction(aEffects, rCritEffect.d);
	end
	if rCritEffect.w then
		decodeWeaponDrop(aEffects, rCritEffect.w);
	end
	if rCritEffect.mc then
		decodeMinorConcussion(aEffects, nSeverity);
	end
	if rCritEffect.sc then
		decodeSevereConcussion(aEffects, nSeverity);
	end
	if rCritEffect.p then
		decodeParalyzation(aEffects, nSeverity, rLocation);
	end
	if rCritEffect.pb then
		decodeProfuseBleeding(aEffects);
	end
	if rCritEffect.v then
		decodeVitalOrgan(aEffects, rCritEffect.v, nSeverity, rLocation);
	end
	if rCritEffect.h then
		decodeTemporalHonorLoss(aEffects, rCritEffect.h);
	end
	if rCritEffect.mt then
		decodeMuscleTear(aEffects, rCritEffect.mt, nSeverity, rLocation);
	end
	if rCritEffect.b then
		decodeBrokenBone(aEffects, 0, rCritEffect.b. nSeverity, rLocation);
	end
	if rCritEffect.tl then
		decodeTornLigaments(aEffects, rCritEffect.tl, nSeverity, rLocation);
	end
	if rCritEffect.bf then
		decodeBrokenBone(aEffects, 1, rCritEffect.bf. nSeverity, rLocation);
	end
	if rCritEffect.bm then
		decodeBrokenBone(aEffects, 2, rCritEffect.bm. nSeverity, rLocation);
	end
	if rCritEffect.bs then
		decodeBrokenBone(aEffects, 3, rCritEffect.bs. nSeverity, rLocation);
	end
	if rCritEffect.ib then
		decodeInternalBleeding(aEffects);
	end
	if rCritEffect.u then
		decodeUnconscious(aEffects);
	end
	if rCritEffect.ls then
		decodeLimbSevered(aEffects, rLocation);
	end
	
	return toCsv(aEffects);
end

function decodeFall(aEffects)
	table.insert(aEffects, "Falls to the ground prone and drops anything held");
end

function decodeToHitReduction(aEffects, nValue)
	table.insert(aEffects, "Receives a -" .. nValue .. " penalty to hit until wound completely healed");
end

function decodeStrengthReduction(aEffects, nValue)
	table.insert(aEffects, "Loses " .. nValue .. " points of Strength until wound completely healed");
end

function decodeDexterityReduction(aEffects, nValue)
	table.insert(aEffects, "Loses " .. nValue .. " points of Dexterity until wound completely healed");
end

function decodeWeaponDrop(aEffects, sValue)
	local sMsg =  "Drops any weapon and/or items carried";
	if sValue and sValue == "s" then
		sMsg = sMsg .. " unless a Strength check at half is passed";
	end
	table.insert(aEffects, sMsg);
end

function decodeMinorConcussion(aEffects, nSeverity)
	local nDuration = math.random(1, 12) + nSeverity;
	
	local sFlaws = "the migraine flaw (PHB 94)";
	if math.random(1, 100) <= 3 * nSeverity then
		sFlaws = sFlaws .. " and the seizure disorder character flaw (PHB 94)"
	end
	
	table.insert(aEffects, "Gains " .. sFlaws .. " with an immediate headache. Lasts " .. nDuration .. " hours or until healed.");
end

function decodeSevereConcussion(aEffects, nSeverity)
	local sFlaws = "the migraine flaw (PHB 94)";
	if math.random(1, 100) <= 5 * nSeverity then
		sFlaws = sFlaws .. " and the seizure disorder character flaw (PHB 94)"
	end
	
	table.insert(aEffects, "Gains " .. sFlaws .. " with an immediate headache. Lasts until healed.");
end

function getLocation(sLocation)
	local rLocation = aCritLocations[sLocation];
	if not rLocation then rLocation = {}; end
	return rLocation;
end

function getMuscle(rLocation, nIndex)
	local sMuscle = rLocation.muscular[nIndex];
	if not sMuscle then sMuscle = "Unknown"; end;
	return sMuscle;
end

function getBone(rLocation, nIndex)
	local sBone = rLocation.skeletal[nIndex];
	if not sBone then sBone = "Unknown"; end;
	return sBone;
end

function getOrgan(rLocation, nIndex)
	local sOrgan = rLocation.vital[nIndex];
	if not sOrgan then sOrgan = "Unknown"; end;
	return sOrgan;
end

function decodeParalyzation(aEffects, nSeverity, rLocation)
	local sCannotMove = "lower body";
	if rLocation.isHead or rLocation.isSpine then
		sCannotMove = "anything but their head";
	end
	local sMsg = "";
	if math.random(1, 100) <= nSeverity * 5 then
		sMsg = "Paralyzed. Cannot move " .. sCannotMove;
	else
		sMsg = "Avoided paralyzation.";
	end
	table.insert(aEffects, sMsg);
end

function decodeProfuseBleeding(aEffects)
	table.insert(aEffects, "Will bleed to death in half Constitution (rounded down) rounds unless the wound has been treated by a successful first aid-related skill check or any cure spell that heals half the wound's HPs in damage, or one Cure Critical Wounds or better spell. Severed limbs may be cauterized by applying open flame for one round (1d4 damage)");
end

function decodeVitalOrgan(aEffects, nIndex, nSeverity, rLocation)
	table.insert(aEffects, rollVitalOrganDamage(rLocation, nIndex));
	decodeWeaponDrop(aEffects);
	decodeInternalBleeding(aEffects);
	if math.random(1, 100) <= 3 * nSeverity then
		decodeProfuseBleeding(aEffects);
	end
	if rLocation.isHead or rLocation.isSpine then
		decodeParalyzation(aEffects, nSeverity, rLocation);
	end
end

function decodeTemporalHonorLoss(aEffects, nValue)
	local nLoss = nValue * 5;
	
	table.insert(aEffects, "Lose " .. nLoss .. "% of his temporal honor. Only affects males.");
end

function decodeMuscleTear(aEffects, nIndex, nSeverity, rLocation)

	table.insert(aEffects, "Muscle Tear (" .. getMuscle(rLocation, nIndex) .. ")! These wounds heal naturally at half normal rate. Any Dexterity and Strength reductions from this crit last for 20 - Constitution days, then are reduced by half for like periods until reduce to zero. This lasting effect occurs regardless of whether the wounds have been healed fully by spells. A Cure Critical Wounds spell or better will eliminate all ill effects instantly.");
	if rLocation.isArm then 
		decodeWeaponDrop(aEffects, "s");
	end
	if math.random(1, 100) <= 3 * nSeverity then
		decodeProfuseBleeding(aEffects);
	end
end

-- nFracture = 0 normal broken, 1 = compound fracture, 2 = multiple fracture, 3 = bone shatter
function decodeBrokenBone(aEffects, nFracture, nIndex, nSeverity, rLocation) 
	local sBone = getBone(rLocation, nIndex);

	local sHealRate = "onetenth";
	local sEffectName = "Broken bone (" .. getBone(rLocation, nIndex) .. ")!"
	local nExtraEffectChance = 15;
	if nFracture and nFracture == 1 then
		sEffectName = "Broken bone (" .. getBone(rLocation, nIndex) .. ") with compound fracture!";
		nExtraEffectChance = 30;
	elseif nFracture and nFracture == 2 then
		sEffectName = "Broken bone (" .. getBone(rLocation, nIndex) .. ") with multiple fractures!";
		nExtraEffectChance = 50;
		sHealRate = "one twelfth";
	elseif nFracture and nFracture == 3 then
		sEffectName = "Bone (" .. getBone(rLocation, nIndex) .. ") shattered!!";
		nExtraEffectChance = 65;
		sHealRate = "one twentieth";
	end
	
	table.insert(aEffects, sEffectName .. " Can be cured by magical means or through healing at " .. sHealRate .. "  the normal rate. Successfully setting a broken bone using first aid-related skills allows healing at one quarter the normal rate. Unless set properly prior to healing, even magical healing, fractures will heal incorrectly giving rise to lasting limps, obvious lumps, etc. In this case, half of any associated movement and/or ability score penalties will be permanent. A Cure Critical Wounds spell or better will eliminate all ill effects instantly.";
	if rLocation.isSpine then
		decodeParalyzation(aEffects, nSeverity, rLocation);
	end
	if rLocation.isArm then
		decodeWeaponDrop(aEffects, "s");
	end
	if rLocation.isTorso then
		if math.random(1, 100) <= nExtraEffectChance then
			decodeProfuseBleeding(aEffects);
		end
		if math.random(1, 100) <= nExtraEffectChance then
			decodeInternalBleeding(aEffects);
		end
	end
end

function decodeTornLigaments(aEffects, nIndex, nSeverity, rLocation)
	
	table.insert("Torn ligament or tendon (" .. getMuscle(rLocation, nIndex) .. ")! Unless the appropriate body part is isolated prior to healing, even magical healing, will heal incorrectly or incompletely, giving rise to lasting limps, obvious lumps, etc. In this case, half of any associated movement and/or ability score penalties will become permanent. A Cure Critical Wounds spell or better will eliminate all ill effects instantly.";
	
	if rLocation.isArm then
		decodeWeaponDrop(aEffects);
	else
		decodeWeaponDrop(aEffects, "s");
	end
	
	if rLocation.isLeg then
		decodeParalyzation(aEffects, nSeverity, rLocation);
	end
	
	if math.random(1, 100) <= 30 then
		decodeProfuseBleeding(aEffects);
	end
end

function decodeInternalBleeding(aEffects)
	table.insert(aEffect, "Each hour lose 1d4 hit points and make a Constitution check, with failure indicating that the character goes into shock (see Trauma Damage). May live for many hours or days with this problem and not know it; will feel pains in the area, but will otherwise not know that he has been injured";
end

function decodeUnconscious(aEffects)
	table.insert(aEffects, "Falls to the ground, out cold. Remains in a coma until the hit points suffered from this wound are healed (naturally or magically)";
end

function decodeLimbSevered(aEffects, rLocation)
	table.insert("Limb severed! The stump can be cured by magical means or through natural healing at one third the normal rate. Regeneration, Reattach Limb, or the like needed to recover the limb.";
	
	if not rLocation.isDigit then
		decodeProfuseBleeding(aEffects);
	end
end

function rollVitalOrganDamage(rLocation, nIndex, nRollValue)
	if not nRollValue then nRollValue = math.random(1, 100); end
	
	local sStatLost = "Constitution";
	if rLocation.isHead or rLocation.isSpine then
		if math.random(1, 100) <= 80 then
			sStatLost = "Intelligence";
		else
			sStatLost = "Dexterity";
		end
	end
	local sMsg = "";
	if nRollValue < 26 then sMsg = "";
	elseif nRollValue < 51 then sMsg = "Vital organ (" .. getOrgan(rLocation, nIndex) .. ")! Lose " .. DiceMechanicsManager.getDiceResult(2, 6) .. " points of " .. sStatLost .. ". 1 point returns per day for the next " .. math.random(1, 6) .. " day(s). Unreturned points are lost permanently.";
	elseif nRollValue < 71 then sMsg = "Vital organ (" .. getOrgan(rLocation, nIndex) .. ")! Death in " .. math.random(1, 12) .. " days";
	elseif nRollValue < 81 then sMsg = "Vital organ (" .. getOrgan(rLocation, nIndex) .. ")! Death in " .. math.random(1, 12) .. " hours";
	elseif nRollValue < 91 then sMsg = "Vital organ (" .. getOrgan(rLocation, nIndex) .. ")! Death in " .. math.random(1, 12) .. " rounds";
	else sMsg = "Vital organ(" .. getOrgan(rLocation, nIndex) .. ")! Death in " .. math.random(1, 12) .. " segments";
	end
	return sMsg;
end

function decodeMovement(aEffects, nValue)
	local sMsg = "";
	if nValue == 1 then sMsg = "Lose 50% move for 1 rd, then 10% for " .. DiceMechanicsManager.getDiceResult(2, 4) .. " rds";
	elseif nValue == 2 then sMsg =  "Lose 50% move for 2 rds, then 25% for " .. DiceMechanicsManager.getDiceResult(2, 10) .. " rds";
	elseif nValue == 3 then sMsg =  "Lose 50% move for 1 rd, 10% for " .. DiceMechanicsManager.getDiceResult(2, 4) .. " rds, then 25% for " .. DiceMechanicsManager.getDiceResult(1, 4) .. " turns";
	elseif nValue == 4 then sMsg =  "Lose 50% move for " .. DiceMechanicsManager.getDiceResult(1, 12) .. " hours";
	elseif nValue == 5 then sMsg =  "Lose 50% move for " .. DiceMechanicsManager.getDiceResult(1, 12) .. " hours, then 25% for " .. DiceMechanicsManager.getDiceResult(1, 12) .. " days";
	elseif nValue == 6 then sMsg =  "Lose 75% move for 6 hours, then 50% for " .. DiceMechanicsManager.getDiceResult(2, 12) .. " days";
	elseif nValue == 7 then sMsg =  "Lose 75% move for 6 hours, then 50% for " .. DiceMechanicsManager.getDiceResult(4, 12) .. " days";
	elseif nValue == 8 then sMsg =  "Lose 75% move for 6 hours, then 50% for " .. DiceMechanicsManager.getDiceResult(1, 3) .. " months";
	elseif nValue == 9 then sMsg =  "Lose 75% move for 1 day, then 50% for " .. DiceMechanicsManager.getDiceResult(1, 4) .. " months";
	else nValue == 10 then sMsg =  "Lose 75% move for 1 week, then 50% for " .. DiceMechanicsManager.getDiceResult(1, 6) .. " months";
	end
	table.insert(aEffects, sMsg);
end

function decodeDamageBonus(aEffects, nDieType)
	table.insert(aEffects, "Damage Bonus: d" .. nDieType);
end

function decodeDamageMultiplier(aEffects, nMultiplier)
	table.insert(aEffects, "Damage Multiplier: x" .. nMultiplier);
end

function toCsv(tt)
	local s = "";
	for _, p in ipairs(tt) do
		s = s .. "/r" .. p
	end
	return string.sub(s, 2);
end
