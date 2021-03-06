aHonorDice = {};
aHonorThresholdsByLevel = {};
aDefaultArmorVsDamageTypeModifiers = {};
aDefaultWeaponSizes = {};

function onInit()
	-- index is honor index,values are levels 1-20
	aHonorDice[1] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1"}; 
	aHonorDice[2] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1"};
	aHonorDice[3] = {"d3","d3","d3","d3","d3","d3","d3","d3","d3","d3","d3","d3","d3","d3","d3","d3","d3","d3","d3","d3"}; 
	aHonorDice[4] = {"d4","d4","d4","d4","d4","d4","d4","d4","d4","d4","d4","d4","d4","d4","d4","d4","d4","d4","d4","d4"}; 
	aHonorDice[5] = {"d3","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1","d4+1"};
	aHonorDice[6] = {"d3","d6","d6","d6","d6","d6","d6","d6","d6","d6","d6","d6","d6","d6","d6","d6","d6","d6","d6","d6"}; 
	aHonorDice[7] = {"1","d4+1","d6","d6","d6+1","d6+1","d6+1","d6+1","d6+1","d6+1","d6+1","d6+1","d6+1","d6+1","d6+1","d6+1","d6+1","d6+1","d6+1","d6+1"};
	aHonorDice[8] = {"1","d4","d6+1","d6+1","d6+1","d8","d8","d8","d8","d8","d8","d8","d8","d8","d8","d8","d8","d8","d8","d8"};
	aHonorDice[9] = {"1","d3","d6","d6+1","d6+1","d8","d8+1","d8+1","d8+1","d8+1","d8+1","d8+1","d8+1","d8+1","d8+1","d8+1","d8+1","d8+1","d8+1","d8+1"};
	aHonorDice[10] = {"1","d3","d4+1","d8","d8+1","d8","d8+1","d10","d10","d10","d10","d10","d10","d10","d10","d10","d10","d10","d10","d10"}; 
	aHonorDice[11] = {"1","1","d4+1","d6+1","d8","d8+1","d8+1","d10","d10+1","d10+1","d10+1","d10+1","d10+1","d10+1","d10+1","d10+1","d10+1","d10+1","d10+1","d10+1"}; 
	aHonorDice[12] = {"1","1","d4","d6","d8+1","d8+1","d8+1","d10","d10+1","d12","d12","d12","d12","d12","d12","d12","d12","d12","d12","d12"}; 
	aHonorDice[13] = {"1","1","d4","d4+1","d8","d8+1","d10","d10","d10+1","d12","d12+1","d12+1","d12+1","d12+1","d12+1","d12+1","d12+1","d12+1","d12+1","d12+1"}; 
	aHonorDice[14] = {"1","1","d3","d4+1","d6+1","d10","d10","d10+1","d10+1","d12","d12+1","d12+1","d12+1","d12+1","d12+1","d12+1","d12+1","d12+1","d12+1","d12+2"}; 	
	aHonorDice[15] = {"1","1","d3","d4","d6+1","d8+1","d10","d10+1","d10+1","d12","d12+1","d12+1","d12+2","d12+2","d12+2","d12+2","d12+2","d12+2","d12+2","d20"}; 	
	aHonorDice[16] = {"1","1","d3","d4","d6","d8","d10+1","d10+1","d12","d12","d12+1","d12+1","d12+2","d12+2","d12+2","d12+2","d12+2","d12+2","d20","d20"}; 	
	aHonorDice[17] = {"1","1","1","d3","d6","d6+1","d10","d10+1","d12","d12+1","d12+1","d12+1","d12+2","d12+2","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[18] = {"1","1","1","d3","d4+1","d6+1","d8+1","d12","d12","d12+1","d12+1","d12+2","d12+2","d12+2","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[19] = {"1","1","1","d3","d4+1","d6","d8+1","d10+1","d12","d12+1","d12+2","d12+2","d12+2","d20","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[20] = {"1","1","1","1","d4+1","d6","d8","d10","d12+1","d12+1","d12+2","d12+2","d12+2","d20","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[21] = {"1","1","1","1","d4","d4+1","d8","d8+1","d12","d12+1","d12+2","d12+2","d12+2","d20","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[22] = {"1","1","1","1","d4","d4+1","d6+1","d8+1","d10+1","d12+2","d12+2","d12+2","d20","d20","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[23] = {"1","1","1","1","d4","d4+1","d6+1","d8","d10+1","d12+1","d12+2","d12+2","d20","d20","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[24] = {"1","1","1","1","d3","d4","d6+1","d8","d10","d12","d20","d20","d20","d20","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[25] = {"1","1","1","1","d3","d4","d6","d6+1","d10","d10+1","d12+2","d20","d20","d20","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[26] = {"1","1","1","1","d3","d4","d6","d6+1","d8+1","d10+1","d12+1","d20","d20","d20","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[27] = {"1","1","1","1","d3","d3","d6","d6+1","d8+1","d10","d12","d12+2","d20","d20","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[28] = {"1","1","1","1","1","d3","d4+1","d6","d8+1","d10","d10+1","d12+1","d20","d20","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[29] = {"1","1","1","1","1","d3","d4+1","d6","d8","d8+1","d10+1","d12","d12+2","d20","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[30] = {"1","1","1","1","1","d3","d4+1","d6","d8","d8+1","d10","d10+1","d12+1","d20","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[31] = {"1","1","1","1","1","1","d4+1","d4+1","d8","d8+1","d10","d10+1","d12","d12+2","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[32] = {"1","1","1","1","1","1","d4","d4+1","d6+1","d8","d8+1","d10","d10+1","d12+1","d20","d20","d20","d20","d20","d20"}; 	
	aHonorDice[33] = {"1","1","1","1","1","1","d4","d4+1","d6+1","d8","d8+1","d10","d10+1","d12","d12+2","d20","d20","d20","d20","d20"}; 	
	aHonorDice[34] = {"1","1","1","1","1","1","d4","d4+1","d6+1","d8","d8+1","d8+1","d10","d10+1","d12+1","d20","d20","d20","d20","d20"}; 	
	aHonorDice[35] = {"1","1","1","1","1","1","d4","d4","d6+1","d6+1","d8","d8+1","d10","d10+1","d12","d12+2","d20","d20","d20","d20"}; 	
	aHonorDice[36] = {"1","1","1","1","1","1","d3","d4","d6","d6+1","d8","d8+1","d8+1","d10","d10+1","d12+1","d20","d20","d20","d20"}; 	
	aHonorDice[37] = {"1","1","1","1","1","1","d3","d4","d6","d6+1","d8","d8","d8+1","d10","d10+1","d12","d12+2","d20","d20","d20"};
	aHonorDice[38] = {"1","1","1","1","1","1","d3","d4","d6","d6+1","d6+1","d8","d8+1","d8+1","d10","d10+1","d12+1","d20","d20","d20"};
	aHonorDice[39] = {"1","1","1","1","1","1","d3","d3","d6","d6","d6+1","d8","d8","d8+1","d10","d10+1","d12","d12+2","d20","d20"};
	aHonorDice[40] = {"1","1","1","1","1","1","d3","d3","d4+1","d6","d6+1","d6+1","d8","d8+1","d8+1","d10","d10+1","d12+1","d20","d20"};
	aHonorDice[41] = {"1","1","1","1","1","1","d3","d3","d4+1","d6","d6+1","d6+1","d8","d8","d8+1","d10","d10+1","d12","d12+2","d20"};
	aHonorDice[42] = {"1","1","1","1","1","1","d3","d3","d4+1","d6","d6","d6+1","d6+1","d8","d8+1","d8+1","d10","d10+1","d12+1","d20"};
	aHonorDice[43] = {"1","1","1","1","1","1","d3","d3","d4+1","d4+1","d6","d6+1","d6+1","d8","d8","d8+1","d10","d10+1","d12","d12+2"};
	aHonorDice[44] = {"1","1","1","1","1","1","1","1","d4+1","d4+1","d6","d6","d6+1","d6+1","d8","d8+1","d8+1","d10","d10+1","d12+1"};
	aHonorDice[45] = {"1","1","1","1","1","1","1","1","d4","d4+1","d6","d6","d6+1","d6+1","d8","d8","d8+1","d10","d10+1","d12"};
	aHonorDice[46] = {"1","1","1","1","1","1","1","1","d4","d4+1","d4+1","d6","d6","d6+1","d6+1","d8","d8+1","d8+1","d10","d10+1"};
	aHonorDice[47] = {"1","1","1","1","1","1","1","1","d4","d4+1","d4+1","d6","d6","d6+1","d6+1","d8","d8","d8+1","d10","d10+1"};
	aHonorDice[48] = {"1","1","1","1","1","1","1","1","d4","d4","d4+1","d4+1","d6","d6","d6+1","d6+1","d8","d8+1","d8+1","d10"};
	aHonorDice[49] = {"1","1","1","1","1","1","1","1","d4","d4","d4+1","d4+1","d6","d6","d6+1","d6+1","d8","d8","d8+1","d10"};
	aHonorDice[50] = {"1","1","1","1","1","1","1","1","d3","d4","d4+1","d4+1","d4+1","d6","d6","d6+1","d6+1","d8","d8+1","d8+1"};
	aHonorDice[51] = {"1","1","1","1","1","1","1","1","d3","d4","d4","d4+1","d4+1","d6","d6","d6+1","d6+1","d8","d8","d8+1"};
	aHonorDice[52] = {"1","1","1","1","1","1","1","1","d3","d4","d4","d4+1","d4+1","d4+1","d6","d6","d6+1","d6+1","d8","d8+1"};
	aHonorDice[53] = {"1","1","1","1","1","1","1","1","d3","d3","d4","d4","d4+1","d4+1","d6","d6","d6+1","d6+1","d8","d8"};
	aHonorDice[54] = {"1","1","1","1","1","1","1","1","d3","d3","d4","d4","d4+1","d4+1","d4+1","d6","d6","d6+1","d6+1","d8"};
	aHonorDice[55] = {"1","1","1","1","1","1","1","1","d3","d3","d4","d4","d4+1","d4+1","d4+1","d6","d6","d6+1","d6+1","d8"};
	aHonorDice[56] = {"1","1","1","1","1","1","1","1","1","d3","d4","d4","d4","d4+1","d4+1","d6","d6","d6+1","d6+1","d8"};
	aHonorDice[57] = {"1","1","1","1","1","1","1","1","1","d3","d4","d4","d4","d4+1","d4+1","d4+1","d6","d6","d6+1","d6+1"};
	aHonorDice[58] = {"1","1","1","1","1","1","1","1","1","1","d3","d4","d4","d4+1","d4+1","d4+1","d4+1","d6","d6","d6+1"};
	aHonorDice[59] = {"1","1","1","1","1","1","1","1","1","1","d3","d4","d4","d4","d4+1","d4+1","d4+1","d6","d6","d6+1"};
	aHonorDice[60] = {"1","1","1","1","1","1","1","1","1","1","d3","d3","d4","d4","d4","d4+1","d4+1","d4+1","d6","d6"};
	aHonorDice[61] = {"1","1","1","1","1","1","1","1","1","1","d3","d3","d4","d4","d4","d4","d4+1","d4+1","d6","d6"};
	aHonorDice[62] = {"1","1","1","1","1","1","1","1","1","1","d3","d3","d3","d4","d4","d4","d4+1","d4+1","d4+1","d6"};
	aHonorDice[63] = {"1","1","1","1","1","1","1","1","1","1","1","d3","d3","d4","d4","d4","d4","d4+1","d4+1","d6"};
	aHonorDice[64] = {"1","1","1","1","1","1","1","1","1","1","1","d3","d3","d3","d4","d4","d4","d4+1","d4+1","d4+1"};
	aHonorDice[65] = {"1","1","1","1","1","1","1","1","1","1","1","1","d3","d3","d4","d4","d4","d4","d4+1","d4+1"};
	aHonorDice[66] = {"1","1","1","1","1","1","1","1","1","1","1","1","d3","d3","d3","d4","d4","d4","d4+1","d4+1"};
	aHonorDice[67] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","d3","d3","d4","d4","d4","d4","d4+1"};
	aHonorDice[68] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","d3","d3","d3","d4","d4","d4","d4+1"};
	aHonorDice[69] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","d3","d3","d4","d4","d4","d4"};
	aHonorDice[70] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","d3","d3","d3","d4","d4","d4"};
	aHonorDice[71] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","d3","d3","d4","d4","d4"};
	aHonorDice[72] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","d3","d3","d3","d4","d4"};
	aHonorDice[73] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","d3","d3","d4","d4"};
	aHonorDice[74] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","d3","d3","d3","d4"};
	aHonorDice[75] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","d3","d3","d4"};
	aHonorDice[76] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","d3","d3","d3"};
	aHonorDice[77] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","d3","d3"};
	aHonorDice[78] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","d3","d3"};
	aHonorDice[79] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","d3"};
	aHonorDice[80] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","d3"};
	aHonorDice[81] = {"1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1","1"};
	
	aHonorThresholdsByLevel[1] = {6, 17, 20};
	aHonorThresholdsByLevel[2] = {9, 25, 30};
	aHonorThresholdsByLevel[3] = {12, 33, 40};
	aHonorThresholdsByLevel[4] = {15, 41, 50};
	aHonorThresholdsByLevel[5] = {18, 49, 60};
	aHonorThresholdsByLevel[6] = {21, 57, 70};
	aHonorThresholdsByLevel[7] = {24, 65, 80};
	aHonorThresholdsByLevel[8] = {27, 73, 90};
	aHonorThresholdsByLevel[9] = {30, 81, 100};
	aHonorThresholdsByLevel[10] = {33, 89, 110};
	aHonorThresholdsByLevel[11] = {36, 97, 120};
	aHonorThresholdsByLevel[12] = {39, 105, 130};
	aHonorThresholdsByLevel[13] = {42, 113, 140};
	aHonorThresholdsByLevel[14] = {45, 121, 150};
	aHonorThresholdsByLevel[15] = {48, 129, 160};
	aHonorThresholdsByLevel[16] = {51, 137, 170};
	aHonorThresholdsByLevel[17] = {54, 145, 180};
	aHonorThresholdsByLevel[18] = {57, 153, 190};
	aHonorThresholdsByLevel[19] = {60, 161, 200};
	aHonorThresholdsByLevel[20] = {63, 169, 210};
	
	
	aArmorDamageSteps = {};
	-- [lowest ac step, next ac step, ..., worst ac step]
	
	aArmorDamageSteps[1] = {1}; -- Robes
	aArmorDamageSteps[2] = {2, 1}; -- Leather
	aArmorDamageSteps[3] = {2, 1}; -- Padded
	aArmorDamageSteps[4] = {6, 2, 1}; -- Ring Mail
	aArmorDamageSteps[5] = {4, 2, 1}; -- Studded Leather
	aArmorDamageSteps[6] = {7, 4, 2, 1}; -- Scale Mail
	aArmorDamageSteps[7] = {5, 4, 2, 1}; -- Hide 
	aArmorDamageSteps[8] = {5, 4, 2, 1}; -- Hide 
	aArmorDamageSteps[9] = {6, 4, 2, 1}; -- Brigandine
	aArmorDamageSteps[10] = {8, 6, 4, 2, 1}; -- Chain mail
	aArmorDamageSteps[11] = {12, 8, 6, 4, 2, 1}; -- Bronze plate mail
	aArmorDamageSteps[12] = {9, 8, 6, 4, 2, 1}; -- Banded mail
	aArmorDamageSteps[13] = {8, 8, 6, 4, 2, 1}; -- Splint mail
	aArmorDamageSteps[14] = {12, 10, 8, 6, 4, 2, 1}; -- Plate mail
	aArmorDamageSteps[15] = {24, 12, 10, 8, 6, 4, 2, 1}; -- Field plate
	aArmorDamageSteps[16] = {36, 24, 12, 10, 8, 6, 4, 2, 1}; -- Full plate
	aArmorDamageSteps[17] = {3}; -- Buckler
	aArmorDamageSteps[18] = {4, 3}; -- Small Shield
	aArmorDamageSteps[19] = {5, 4, 3}; -- Medium Shield
	aArmorDamageSteps[20] = {6, 5, 4, 3}; -- Body Shield


    aDefaultArmorVsDamageTypeModifiers["banded mail"]      = {["slashing"] = -2, ["piercing"] = 0,  ["bludgeoning"] = -1};
    aDefaultArmorVsDamageTypeModifiers["brigandine"]       = {["slashing"] = -1, ["piercing"] = -1, ["bludgeoning"] = 0};
    aDefaultArmorVsDamageTypeModifiers["chain mail"]       = {["slashing"] = -2, ["piercing"] = 0,  ["bludgeoning"] = 2};
    aDefaultArmorVsDamageTypeModifiers["field plate"]      = {["slashing"] = -3, ["piercing"] = -1, ["bludgeoning"] = 0};
    aDefaultArmorVsDamageTypeModifiers["full plate"]       = {["slashing"] = -4, ["piercing"] = -3, ["bludgeoning"] = 0}; 
    aDefaultArmorVsDamageTypeModifiers["leather armor"]    = {["slashing"] = 0,  ["piercing"] = 2,  ["bludgeoning"] = 0};
    aDefaultArmorVsDamageTypeModifiers["padded armor"]     = {["slashing"] = 0,  ["piercing"] = 2,  ["bludgeoning"] = 0};
    aDefaultArmorVsDamageTypeModifiers["hide armor"]       = {["slashing"] = 0,  ["piercing"] = 2,  ["bludgeoning"] = 0};
    aDefaultArmorVsDamageTypeModifiers["plate mail"]       = {["slashing"] = -3, ["piercing"] = 0,  ["bludgeoning"] = 0};
    aDefaultArmorVsDamageTypeModifiers["ring mail"]        = {["slashing"] = -1, ["piercing"] = -1, ["bludgeoning"] = 0};
    aDefaultArmorVsDamageTypeModifiers["scale mail"]       = {["slashing"] = 0,  ["piercing"] = -1, ["bludgeoning"] = 0};
    aDefaultArmorVsDamageTypeModifiers["splint mail"]      = {["slashing"] = 0,  ["piercing"] = -1, ["bludgeoning"] = -2};
    aDefaultArmorVsDamageTypeModifiers["studded leather"]  = {["slashing"] = -2, ["piercing"] = -1, ["bludgeoning"] = 0};

    aDefaultWeaponSizes["arquebus"] = "M";
	aDefaultWeaponSizes["battle axe"] = "M";
	aDefaultWeaponSizes["blowgun"] = "S";
	aDefaultWeaponSizes["bow"] = "M";
	aDefaultWeaponSizes["club"] = "M";
	aDefaultWeaponSizes["dagger"] = "S";
	aDefaultWeaponSizes["dirk"] = "S";
	aDefaultWeaponSizes["dart"] = "S";
	aDefaultWeaponSizes["flail"] = "M";
	aDefaultWeaponSizes["mace"] = "M";
	aDefaultWeaponSizes["pick"] = "M";
	aDefaultWeaponSizes["hand axe"] = "M";
	aDefaultWeaponSizes["throwing axe"] = "M";
	aDefaultWeaponSizes["harpoon"] = "L";
	aDefaultWeaponSizes["javelin"] = "M";
	aDefaultWeaponSizes["knife"] = "S";
	aDefaultWeaponSizes["lance"] = "L";
	aDefaultWeaponSizes["mancatcher"] = "L";
	aDefaultWeaponSizes["morning star"] = "M";
	aDefaultWeaponSizes["morningstar"] = "M";
	aDefaultWeaponSizes["awl pike"] = "L";
	aDefaultWeaponSizes["bardiche"] = "L";
	aDefaultWeaponSizes["bec de corbin"] = "L";
	aDefaultWeaponSizes["bill-guisarme"] = "L";
	aDefaultWeaponSizes["fauchard"] = "L";
	aDefaultWeaponSizes["glaive"] = "L";
	aDefaultWeaponSizes["guisarme"] = "L";
	aDefaultWeaponSizes["voulge"] = "L";
	aDefaultWeaponSizes["lucern hammer"] = "L";
	aDefaultWeaponSizes["military fork"] = "L";
	aDefaultWeaponSizes["partisan"] = "L";
	aDefaultWeaponSizes["ranseur"] = "L";
	aDefaultWeaponSizes["spetum"] = "L";
	aDefaultWeaponSizes["scourge"] = "S";
	aDefaultWeaponSizes["sickle"] = "S";
	aDefaultWeaponSizes["sling"] = "S";
	aDefaultWeaponSizes["staff"] = "L"; -- we want this to come after "sling" so "staff sling" doesn't flag as large
	aDefaultWeaponSizes["bullet"] = "S";
	aDefaultWeaponSizes["stone"] = "S";
	aDefaultWeaponSizes["spear"] = "M";
	aDefaultWeaponSizes["bastard sword"] = "M";
	aDefaultWeaponSizes["broad sword"] = "M";
	aDefaultWeaponSizes["khopesh"] = "M";
	aDefaultWeaponSizes["long sword"] = "M";
	aDefaultWeaponSizes["longsword"] = "M";
	aDefaultWeaponSizes["short sword"] = "M";
	aDefaultWeaponSizes["shortsword"] = "S";
	aDefaultWeaponSizes["scimitar"] = "M";
	aDefaultWeaponSizes["two handed sword"] = "L";
	aDefaultWeaponSizes["two-handed sword"] = "L";
	aDefaultWeaponSizes["2 handed sword"] = "L";
	aDefaultWeaponSizes["2-handed sword"] = "L";
	aDefaultWeaponSizes["2-h sword"] = "L";
	aDefaultWeaponSizes["2h sword"] = "L";
	aDefaultWeaponSizes["trident"] = "L";
	aDefaultWeaponSizes["warhammer"] = "M";
	aDefaultWeaponSizes["whip"] = "M";	
		
end


