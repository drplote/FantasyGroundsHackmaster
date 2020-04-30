function onInit()
	Comm.registerSlashHandler("fumble", onFumbleSlashCommand);
end

function deliverChatMessage(sText)
	local rMessage = ChatManager.createBaseMessage();
	rMessage.type = "fumble";
	rMessage.text = sText;
	Comm.deliverChatMessage(rMessage);
end

function onFumbleSlashCommand(sCmd, sParam)
	local nRollValue = math.random(1, 1000);
	Debug.console("manager_fumble.lua", "onFumbleSlashCommand", "sParam", sParam);
	local sUpperParam = string.upper(sParam);
	local isUnarmed = sUpperParam == "UNARMED" or sUpperParam == "U" ;
		
	local sRollName = "Fumble";
	if isUnarmed then
		sRollName = "Unarmed" .. sRollName;
	end
	
	sResult = getFumbleResult(nRollValue, isUnarmed);
	local sText = "[" .. sRollName .. "(d1000=" .. nRollValue .. ")] " .. sResult;
	deliverChatMessage(sText);
end

function getFumbleResult(nRollValue, isUnarmed)
	if isUnarmed then
		return getUnarmedFumbleResult(nRollValue)
	else
		return getNormalFumbleResult(nRollValue) 
	end;
end

function getUnarmedFumbleResult(nRollValue)
	local sResult = "";
	if nRollValue >= 1000 then sResult = "knocks self unconscious"
	elseif nRollValue >= 997 then sResult = "slams head into floor, must save vs breath weapon or fall unconscious for {2d6} minutes / if npc immediate morale check (if conscious)"
	elseif nRollValue >= 988 then sResult = "fall prone"
	elseif nRollValue >= 983 then sResult = "slip, opponent gains +2 to-hit next attack, must save vs breath weapon or fall prone"
	elseif nRollValue >= 974 then sResult = "hinder ally; ally at -2 to-hit for {1d4} rounds / allay at +{1d4} initiative next round"
	elseif nRollValue >= 968 then sResult = "compound leg fracture; move x1/4 for 1 week, suffers {1d4} points of damage / save at -1 / -2 to-hit / opponents gain +2 to-hit for {1d3} days / if npc immediate morale check"
	elseif nRollValue >= 964 then sResult = "tear muscle badly; move x1/4 for 1 day / suffers 1 point of damage / -4 to-hit / save at -2 for 1 day"
	elseif nRollValue >= 960 then sResult = "severe strain; move x1/3 for 1 turn / saves -3 / if npc immediate morale check"
	elseif nRollValue >= 956 then sResult = "simple bone fracture; move x1/3, for one month / suffers 1 point of damage / -1 to-hit for 1 week"
	elseif nRollValue >= 951 then sResult = "hairline bone fracture; move x1/2 for 1 month / sufferes 1 point of damage / save at -1 / opponents gain +2 t hit for 1d12 hours"
	elseif nRollValue >= 948 then sResult = "muscle tear; move x1/2 for 1 week / sufferes 1 point of damage /-2 to-hit / save at -1 for {1d3} days / if npc immediate morale check"
	elseif nRollValue >= 945 then sResult = "bad leg crap (or similar limb); movex2/3 for 1 day / saves at -3"
	elseif nRollValue >= 941 then sResult = "leg cramp (or similar limb); move x2/3 for 1 turn / saves at -3"
	elseif nRollValue >= 936 then sResult = "bad sprain; move -3 for 1 day / saves at -3 / if npc immediate morale check"
	elseif nRollValue >= 932 then sResult = "hyperextension;move -3 for 1 turn / saves at -3 "
	elseif nRollValue >= 926 then sResult = "sprain leg (or similar limb);move -2 for {1d3} days / saves at -2 / if npc immediate morale check"
	elseif nRollValue >= 922 then sResult = "pull leg (or similar limb);move -2 for 1 day / saves at -2"
	elseif nRollValue >= 916 then sResult = "internal bleeding;move -2 for 1 turn / saves at -2"
	elseif nRollValue >= 908 then sResult = "sprain leg (or similar limb);move -1 for 1 day / saves at -1"
	elseif nRollValue >= 903 then sResult = "pull leg (or similar limb);move -1 for 1 turn / saves at -1"
	elseif nRollValue >= 896 then sResult = "slip badly;opponent gains +4 to-hit for 1 round / initiative +{1d6} on next round"
	elseif nRollValue >= 889 then sResult = "falls towards opponent's weapon;opponent gains +4 to-hit for attack / initiative +{1d4} on next round"
	elseif nRollValue >= 884 then sResult = "severely off-balanced;opponent gains +3 to-hit for {1d6} rounds / initiative +{1d4} on next round"
	elseif nRollValue >= 879 then sResult = "severely off-balanced;opponent gains +3 to-hit for 2 rounds / initiative +{1d4} on next round"
	elseif nRollValue >= 872 then sResult = "off-balanced; opponent gains +3 to-hit for 1 round / initiative +{1d3} on next round"
	elseif nRollValue >= 865 then sResult = "off-balanced;opponent gains +3 to-hit next attack / initiative +{1d3} on next round"
	elseif nRollValue >= 858 then sResult = "severely off-balanced; opponent gains +2 to-hit for {1d6} rounds / initiative +{1d3} on next round"
	elseif nRollValue >= 850 then sResult = "severely off-balanced; opponent gains +2 to-hit for 2 rounds / initiative +!d3 on next round"
	elseif nRollValue >= 842 then sResult = "off-balanced; opponent gains +2 to-hit for 1 round / initiative +{1d3} on next round"
	elseif nRollValue >= 834 then sResult = "off-balanced; opponent gains +2 to-hit next attack / initiative +1 on next round"
	elseif nRollValue >= 826 then sResult = "severely off-balanced; opponent gains +1 to-hit for {1d6} rounds / initiative +{1d3} on next round"
	elseif nRollValue >= 807 then sResult = "off-balance; opponent gains +1 to-hit for 1 round / initiative +1 on next round"
	elseif nRollValue >= 796 then sResult = "off-balance; opponent gains +1 to-hit next attack / initiative +1 on next round"
	elseif nRollValue >= 782 then sResult = "bad muscle pull;move -1, 1 day / saves at -1 for 1 day / opponent gains +1 to-hit for {1d4} rounds"
	elseif nRollValue >= 772 then sResult = "hit ally, {2d6} points or hit self, 10% change of paralyzing self"
	elseif nRollValue >= 767 then sResult = "hit ally, 1d10 points or hit self, 10% change of paralyzing self"
	elseif nRollValue >= 759 then sResult = "hit ally, {1d8} points or hit self, 8% change of paralyzing self"
	elseif nRollValue >= 749 then sResult = "hit ally, normal damage or hit self, 5% change of paralyzing self"
	elseif nRollValue >= 731 then sResult = "hit ally, {1d6} points or hit self, 4% change of paralyzing self"
	elseif nRollValue >= 718 then sResult = "hit ally, {1d4} points or hit self, 3% change of paralyzing self"
	elseif nRollValue >= 704 then sResult = "hit ally, {1d4}-1 points or hit self, 2% chance of paralyzing self"
	elseif nRollValue >= 693 then sResult = "hit ally, {1d4}-2 points or hit self, 2% chance of paralyzing self"
	elseif nRollValue >= 679 then sResult = "hit ally, 1 point or hit self, 1% chance of paralyzing self"
	elseif nRollValue >= 664 then sResult = "may hit ally, roll attack normally"
	elseif nRollValue >= 645 then sResult = "damage to self, {2d6} points / if npc immediate morale check"
	elseif nRollValue >= 640 then sResult = "damage to self, 1d10 points"
	elseif nRollValue >= 632 then sResult = "damage to self, {1d8} points"
	elseif nRollValue >= 622 then sResult = "damage to self, normal damage"
	elseif nRollValue >= 604 then sResult = "damage to self, {1d6} points"
	elseif nRollValue >= 594 then sResult = "damage to self, {1d4} points"
	elseif nRollValue >= 580 then sResult = "damage to self, {1d4}-1 points"
	elseif nRollValue >= 570 then sResult = "damage to self, {1d4}-2 points"
	elseif nRollValue >= 558 then sResult = "damage to self, 1 point"
	elseif nRollValue >= 545 then sResult = "may hit self, roll attack normally"
	elseif nRollValue >= 531 then sResult = "back strain; saves at -3 for 1 turn / if npc immediate morale check"
	elseif nRollValue >= 526 then sResult = "severe dizziness; saves at -3 for {1d4} rounds / if npc immediate morale check"
	elseif nRollValue >= 521 then sResult = "whiplash; saves at -3 for 1 round"
	elseif nRollValue >= 516 then sResult = "overextended; saves at -2 for 1 turn"
	elseif nRollValue >= 510 then sResult = "overextended; saves at -2 for {1d4} rounds"
	elseif nRollValue >= 504 then sResult = "overextended; saves at -2 for 1 round"
	elseif nRollValue >= 498 then sResult = "overextended; saves at -1 for 1 turn"
	elseif nRollValue >= 490 then sResult = "accidentally swallowed dust, insect or tooth;saves at -1 for {1d4} rounds"
	elseif nRollValue >= 481 then sResult = "overextended; saves at -1 for 1 round"
	elseif nRollValue >= 471 then sResult = "slip badly; opponent gains +4 to-hit for 1 round"
	elseif nRollValue >= 466 then sResult = "falls towards opponent's weapon; opponent gains +4 to-hit next attack"
	elseif nRollValue >= 461 then sResult = "severely off-balanced; opponent gains +3 to-hit for {1d6} rounds"
	elseif nRollValue >= 455 then sResult = "severely off-balanced; opponent gains +3 to-hit for 2 rounds"
	elseif nRollValue >= 449 then sResult = "off-balanced; opponent gains +3 to-hit for 1 round"
	elseif nRollValue >= 442 then sResult = "off-balanced; opponent gains +3 to-hit next attack"
	elseif nRollValue >= 434 then sResult = "severely off-balanced; opponent at +2 to-hit for {1d6} rounds"
	elseif nRollValue >= 426 then sResult = "severely off-balanced; opponent gains +2 to-hit for 2 rounds"
	elseif nRollValue >= 409 then sResult = "off-balanced; opponent gains +2 to-hit for 1 round"
	elseif nRollValue >= 400 then sResult = "severely off-balanced; opponent gains +1 to-hit for {1d6} rounds"
	elseif nRollValue >= 392 then sResult = "severely off-balanced; opponent gains +1 to-hit for 2 rounds"
	elseif nRollValue >= 383 then sResult = "breaks tooth; opponent gains +1 to-hit for 1 round"
	elseif nRollValue >= 371 then sResult = "off-balance; opponent at +1 to-hit next attack"
	elseif nRollValue >= 356 then sResult = "bad pull; move x1/4, 1 day / saves t -3 for 1 day / immediate morale check if npc"
	elseif nRollValue >= 352 then sResult = "pull; move x1/4, 1 day / saves -3 for 1 day"
	elseif nRollValue >= 348 then sResult = "bad pull; move x1/4, 1 turn"
	elseif nRollValue >= 344 then sResult = "very bad pull; move x1/3, 1 day / saves at -3 for 1 day"
	elseif nRollValue >= 340 then sResult = "twisted ankle;move x1/3,1 day"
	elseif nRollValue >= 335 then sResult = "very bad pull; move x1/3, 1 turn"
	elseif nRollValue >= 330 then sResult = "severe strain; move x1/2, 1 day / saves at -3 for 1 day"
	elseif nRollValue >= 326 then sResult = "severe leg crap; move x1/2, 1 turn / saves at -3 for 1 turn"
	elseif nRollValue >= 322 then sResult = "severe strain; move x1/2, 1 day"
	elseif nRollValue >= 317 then sResult = "severe leg crap; move 1/2, 1 turn"
	elseif nRollValue >= 312 then sResult = "strain limb; move x2/3, 1 week"
	elseif nRollValue >= 308 then sResult = "bad leg(or similar limb) cramp; move x2/3, 1 day"
	elseif nRollValue >= 297 then sResult = "bad sprain; move -3, 1 week"
	elseif nRollValue >= 292 then sResult = "hyperextention; move -3, 1 day"
	elseif nRollValue >= 286 then sResult = "hyperextention; move -3, 1 turn"
	elseif nRollValue >= 280 then sResult = "sprain leg (or similar limb); move -2, 1 week"
	elseif nRollValue >= 275 then sResult = "pull leg (or similar limb); move -2, 1 day"
	elseif nRollValue >= 269 then sResult = "pull leg (or similar limb); move -2, 1 turn"
	elseif nRollValue >= 262 then sResult = "sprain leg (or similar limb); move -1, 1 week"
	elseif nRollValue >= 257 then sResult = "pull leg (or similar limb); move -1, 1 day"
	elseif nRollValue >= 251 then sResult = "pull leg (or similar limb); move -1, 1 turn"
	elseif nRollValue >= 244 then sResult = "broken finger(or similar limb); -5 to-hit, 1 turn"
	elseif nRollValue >= 240 then sResult = "broken pinky (or similar limb); -5 to hit, {1d4} rounds"
	elseif nRollValue >= 235 then sResult = "bad pull; -4 to-hit, {1d6} minutes"
	elseif nRollValue >= 229 then sResult = "pull muscle; -4 to-hit, 1 turn"
	elseif nRollValue >= 222 then sResult = "strain limb; -4 to-hit, {1d8} rounds"
	elseif nRollValue >= 215 then sResult = "overextended; -4 to-hit, {1d4} rounds"
	elseif nRollValue >= 205 then sResult = "off-balance; -4 to hit, 1 round"
	elseif nRollValue >= 198 then sResult = "bad pull; -3 to-hit, {1d6} minutes"
	elseif nRollValue >= 190 then sResult = "pull muscle; -3 to-hit, 1 turn"
	elseif nRollValue >= 182 then sResult = "strain limb; -3 to-hit, {1d8} rounds"
	elseif nRollValue >= 174 then sResult = "overextended; -3 to-hit, {1d4} rounds"
	elseif nRollValue >= 166 then sResult = "off-balance; -3 to hit, 1 round"
	elseif nRollValue >= 158 then sResult = "bad pull; -2 to-hit, {1d6} minutes"
	elseif nRollValue >= 151 then sResult = "pull muscle; -2 to-hit, 1 turn"
	elseif nRollValue >= 142 then sResult = "strain limb; -2 to-hit, {1d8} rounds"
	elseif nRollValue >= 133 then sResult = "overextended; -2 to-hit, {1d4} rounds"
	elseif nRollValue >= 124 then sResult = "off-balance; -2 to hit, 1 round"
	elseif nRollValue >= 114 then sResult = "bad pull; -1 to-hit, {1d6} minutes"
	elseif nRollValue >= 106 then sResult = "pull muscle; -1 to-hit, 1 turn"
	elseif nRollValue >= 96 then sResult = "strain limb; -1 to-hit, {1d8} rounds"
	elseif nRollValue >= 86 then sResult = "overextended; -1 to-hit, {1d4} rounds"
	elseif nRollValue >= 75 then sResult = "off-balance; -1 to-hit, 1 round"
	elseif nRollValue >= 62 then sResult = "Severly off-balanced; Lose next attack"
	elseif nRollValue >= 56 then sResult = "Overextended thrust; initiative +{1d6} on next round"
	elseif nRollValue >= 48 then sResult = "bites inside of cheek; initiative +{1d4} on next round"
	elseif nRollValue >= 37 then sResult = "off-balance;initiative +{1d3} on next round"
	elseif nRollValue >= 25 then sResult = "off-balance; initiative + 1 on next round"
	elseif nRollValue >= 12 then sResult = "Slaps/Claws/bites self - looks funny"
	else sResult = "Would have hit, but slips away at last moment"
	end
	
	return replaceRolls(sResult);
end

function getNormalFumbleResult(nRollValue)
	local sResult = "";
	if nRollValue >= 985 then return "Clumsiness; Slip, opponent gains +2 to next to hit roll, -4 Dex for one round and make check vs. 1/2 Dex or fall prone"
	elseif nRollValue >= 969 then return "Clumsiness; overexted, opponent gains +2 to next to-hit"  
	elseif nRollValue >= 953 then return "Clumsiness; off balance +{1d4} penalty to next initiative"  
	elseif nRollValue >= 937 then return "Clumsiness; hinder ally - takes +{1d6} initiative penalty, suffers -{1d4+1} to hit penalty on next attack or have 25% chance of hitting you"  
	elseif nRollValue >= 921 then return "Clumsiness; overexted +d4 penalty to next initiative, opponent gains +2 to next attack roll"  
	elseif nRollValue >= 904 then return "Hinderance; distracted, -4 to hit and no Dex bonus to AC for 1 round"  
	elseif nRollValue >= 886 then return "Hinderance; nearby ally is automatically hit"  
	elseif nRollValue >= 869 then return "Hinderance; blood in eyes -3 to hit for 1 turn"  
	elseif nRollValue >= 851 then return "Hinderance; sweat in eyes -1 to hit for 1 round"  
	elseif nRollValue >= 821 then return "Equipment Mishap; shield strap breaks, -3 to hit until repaired or discarded"  
	elseif nRollValue >= 814 then return "Equipment Mishap; armor strap breaks, +1 AC penalty and -1 to hit until repaired"  
	elseif nRollValue >= 791 then return "Equipment Mishap; armor loosened, -1 to hit until readjusted (by redonning or by another person helping for 1 round)"  
	elseif nRollValue >= 761 then return "Equipment Mishap; belt, girdle, etc. breaks"  
	elseif nRollValue >= 716 then return "Equipment Mishap; backpack, pouch or other container strap breaks, -1 to hit until item repaired or discarded"  
	elseif nRollValue >= 701 then return "Equipment Mishap; boot/footgear breaks, -1 to hit until repaired or discarded"  
	elseif nRollValue >= 661 then return "Weapon damaged/broken; edge dulled, nicked and/or cracked (-1 to hit & damage)"  
	elseif nRollValue >= 651 then return "Weapon damaged/broken; blade/head sheared/cracked -50% to dmg"  
	elseif nRollValue >= 631 then return "Weapon damaged/broken; blade/head badly broken -2 dmg"  
	elseif nRollValue >= 611 then return "Weapon damaged/broken; handle badly broken -2 to hit"  
	elseif nRollValue >= 601 then return "Weapon damaged/broken; sheared (useless)"  
	elseif nRollValue >= 591 then return "Weapon damaged/broken; handle/haft sheared (useless)"  
	elseif nRollValue >= 581 then return "Weapon damaged/broken; blade shattered (useless)"  
	elseif nRollValue >= 541 then return "Weapon damaged/broken; blade/head broken -1 to damage"  
	elseif nRollValue >= 501 then return "Weapon damaged/broken; handle broken -1 to hit"  
	elseif nRollValue >= 401 then return "Damage to ally, make Dex check to deliver only half damage"  
	elseif nRollValue >= 359 then return "Damage own armor for {1d3} points"  
	elseif nRollValue >= 358 then return "Non-wpn injury to self; hyperexted back,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 355 then return "Non-wpn injury to self; hyperexted neck,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 354 then return "Non-wpn injury to self; hyperextention left elbow,minus {1d4} to hit for {1d4} days unless magically cured, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 353 then return "Non-wpn injury to self; hyperextention left shoulder,minus {1d4} to hit for {1d4} days unless magically cured, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 352 then return "Non-wpn injury to self; hyperextention left wrist,minus {1d4} to hit for {1d4} days unless magically cured, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 351 then return "Non-wpn injury to self; hyperextention left hip,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 349 then return "Non-wpn injury to self; hyperextention left knee,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 347 then return "Non-wpn injury to self; hyperextention left ankle,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 346 then return "Non-wpn injury to self; hyperextention left foot,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 345 then return "Non-wpn injury to self; hyperextention right elbow,minus {1d4} to hit for {1d4} days unless magically cured, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 343 then return "Non-wpn injury to self; hyperextention right shoulder,minus {1d4} to hit for {1d4} days unless magically cured, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 342 then return "Non-wpn injury to self; hyperextention right wrist,minus {1d4} to hit for {1d4} days unless magically cured, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 341 then return "Non-wpn injury to self; hyperextention right hip,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 340 then return "Non-wpn injury to self; hyperextention right knee,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 338 then return "Non-wpn injury to self; hyperextention right ankle,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 337 then return "Non-wpn injury to self; hyperextention right foot,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue >= 319 then return "Non-wpn injury to self, pulled muscle, Roll on crit (puncture) chart until reasonable result attained"  
	elseif nRollValue >= 318 then return "Non-wpn injury to self; sprain back,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns"  
	elseif nRollValue >= 317 then return "Non-wpn injury to self; sprain neck,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns"  
	elseif nRollValue >= 316 then return "Non-wpn injury to self; sprain left elbow,minus {1d4} to hit for {1d4} days unless magically cured"  
	elseif nRollValue >= 315 then return "Non-wpn injury to self; sprain left shoulder,minus {1d4} to hit for {1d4} days unless magically cured"  
	elseif nRollValue >= 314 then return "Non-wpn injury to self; sprain left wrist,minus {1d4} to hit for {1d4} days unless magically cured"  
	elseif nRollValue >= 313 then return "Non-wpn injury to self; sprain left hip,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns"  
	elseif nRollValue >= 312 then return "Non-wpn injury to self; sprain left knee,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns"  
	elseif nRollValue >= 311 then return "Non-wpn injury to self; sprain left ankle,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns"  
	elseif nRollValue >= 310 then return "Non-wpn injury to self; sprain left foot,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns"  
	elseif nRollValue >= 309 then return "Non-wpn injury to self; sprain right elbow,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns"  
	elseif nRollValue >= 308 then return "Non-wpn injury to self; sprain right shoulder,minus {1d4} to hit for {1d4} days unless magically cured"  
	elseif nRollValue >= 307 then return "Non-wpn injury to self; sprain right wrist,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns"  
	elseif nRollValue >= 306 then return "Non-wpn injury to self; sprain right hip,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns"  
	elseif nRollValue >= 305 then return "Non-wpn injury to self; sprain right knee,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns"  
	elseif nRollValue >= 304 then return "Non-wpn injury to self; sprain right ankle,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns"  
	elseif nRollValue >= 303 then return "Non-wpn injury to self; sprain right foot,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1{1d6}} turns"  
	elseif nRollValue >= 301 then return "Non-wpn injury to self; bad twist to back,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 297 then return "Non-wpn injury to self; bad twist to neck,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 294 then return "Non-wpn injury to self; bad twist left elbow,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 291 then return "Non-wpn injury to self; bad twist left shoulder,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 289 then return "Non-wpn injury to self; bad twist left wrist,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 288 then return "Non-wpn injury to self; bad twist left hip,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 285 then return "Non-wpn injury to self; bad twist left knee,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 282 then return "Non-wpn injury to self; bad twist left ankle,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 280 then return "Non-wpn injury to self; bad twist left foot,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 277 then return "Non-wpn injury to self; bad twist right elbow,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 274 then return "Non-wpn injury to self; bad twist right shoulder,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 272 then return "Non-wpn injury to self; bad twist right wrist,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 271 then return "Non-wpn injury to self; bad twist right hip,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 268 then return "Non-wpn injury to self; bad twist right knee,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 265 then return "Non-wpn injury to self; bad twist right ankle,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 263 then return "Non-wpn injury to self; bad twist right foot,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue >= 201 then return "Dmg to self, roll dmg as normal, make Dex check to suffer half dmg"  
	elseif nRollValue >= 200 then return "Drop weapon 20 feet away"  
	elseif nRollValue >= 199 then return "Drop weapon 19 feet away"  
	elseif nRollValue >= 198 then return "Drop weapon 18 feet away"  
	elseif nRollValue >= 196 then return "Drop weapon 17 feet away"  
	elseif nRollValue >= 194 then return "Drop weapon 16 feet away"  
	elseif nRollValue >= 192 then return "Drop weapon 15 feet away"  
	elseif nRollValue >= 190 then return "Drop weapon 14 feet away"  
	elseif nRollValue >= 187 then return "Drop weapon 13 feet away"  
	elseif nRollValue >= 184 then return "Drop weapon 12 feet away"  
	elseif nRollValue >= 181 then return "Drop weapon 11 feet away"  
	elseif nRollValue >= 177 then return "Drop weapon 10 feet away"  
	elseif nRollValue >= 173 then return "Drop weapon 9 feet away"  
	elseif nRollValue >= 168 then return "Drop weapon 8 feet away"  
	elseif nRollValue >= 162 then return "Drop weapon 7 feet away"  
	elseif nRollValue >= 155 then return "Drop weapon 6 feet away"  
	elseif nRollValue >= 145 then return "Drop weapon 5 feet away"  
	elseif nRollValue >= 131 then return "Drop weapon 4 feet away"  
	elseif nRollValue >= 111 then return "Drop weapon 3 feet away"  
	elseif nRollValue >= 86 then return "Drop weapon 2 feet away"  
	else return "Drop weapon at feet" 
	end
	
	return replaceRolls(sResult);
end

function replaceRolls(sText)
	local sNeededRoll = sText:match("{%d+d%d+}");
	
	if sNeededRoll then	
		local sDiceString = string.sub(sNeededRoll, 2, -2);
		local rDice = StringManager.convertStringToDice(sDiceString);
		local nTotal = getDiceTotal(rDice);
		local sReplaced = string.gsub(sText, sNeededRoll, nTotal, 1);
		return replaceRolls(sReplaced);
	end
	return sText;
end

function getDiceTotal(rDice)
	Debug.console("here", "here", "rDice", rDice);
	local nTotal = 0;
	for kDieType in ipairs(rDice) do
		local vDieType = rDice[kDieType];
		local nSides = tonumber(vDieType:match("^d(%d+)"));
		nTotal = nTotal + math.random(1, nSides);
	end
	return nTotal;
end