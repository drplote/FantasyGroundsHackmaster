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
	sResult = getFumbleResult(nRollValue);

	local sText = "[Fumble(d1000=" .. nRollValue .. ")] " .. sResult;
	deliverChatMessage(sText);
end

function getFumbleResult(nRollValue)
	local sResult = "";
	if nRollValue < 1 then sResult = "Drop weapon at feet"  
	elseif nRollValue < 86 then sResult = "Drop weapon 2 feet away"  
	elseif nRollValue < 111 then sResult = "Drop weapon 3 feet away"  
	elseif nRollValue < 131 then sResult = "Drop weapon 4 feet away"  
	elseif nRollValue < 145 then sResult = "Drop weapon 5 feet away"  
	elseif nRollValue < 155 then sResult = "Drop weapon 6 feet away"  
	elseif nRollValue < 162 then sResult = "Drop weapon 7 feet away"  
	elseif nRollValue < 168 then sResult = "Drop weapon 8 feet away"  
	elseif nRollValue < 173 then sResult = "Drop weapon 9 feet away"  
	elseif nRollValue < 177 then sResult = "Drop weapon 10 feet away"  
	elseif nRollValue < 181 then sResult = "Drop weapon 11 feet away"  
	elseif nRollValue < 184 then sResult = "Drop weapon 12 feet away"  
	elseif nRollValue < 187 then sResult = "Drop weapon 13 feet away"  
	elseif nRollValue < 190 then sResult = "Drop weapon 14 feet away"  
	elseif nRollValue < 192 then sResult = "Drop weapon 15 feet away"  
	elseif nRollValue < 194 then sResult = "Drop weapon 16 feet away"  
	elseif nRollValue < 196 then sResult = "Drop weapon 17 feet away"  
	elseif nRollValue < 198 then sResult = "Drop weapon 18 feet away"  
	elseif nRollValue < 199 then sResult = "Drop weapon 19 feet away"  
	elseif nRollValue < 200 then sResult = "Drop weapon 20 feet away"  
	elseif nRollValue < 201 then sResult = "Dmg to self, roll dmg as normal, make Dex check to suffer half dmg"  
	elseif nRollValue < 263 then sResult = "Non-wpn injury to self; bad twist right foot,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 265 then sResult = "Non-wpn injury to self; bad twist right ankle,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 268 then sResult = "Non-wpn injury to self; bad twist right knee,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 271 then sResult = "Non-wpn injury to self; bad twist right hip,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 272 then sResult = "Non-wpn injury to self; bad twist right wrist,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 274 then sResult = "Non-wpn injury to self; bad twist right shoulder,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 277 then sResult = "Non-wpn injury to self; bad twist right elbow,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 280 then sResult = "Non-wpn injury to self; bad twist left foot,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 282 then sResult = "Non-wpn injury to self; bad twist left ankle,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 285 then sResult = "Non-wpn injury to self; bad twist left knee,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 288 then sResult = "Non-wpn injury to self; bad twist left hip,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 289 then sResult = "Non-wpn injury to self; bad twist left wrist,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 291 then sResult = "Non-wpn injury to self; bad twist left shoulder,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 294 then sResult = "Non-wpn injury to self; bad twist left elbow,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 297 then sResult = "Non-wpn injury to self; bad twist to neck,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 301 then sResult = "Non-wpn injury to self; bad twist to back,50% movement reduction for 1 round then 10% for {2d4} rounds"  
	elseif nRollValue < 303 then sResult = "Non-wpn injury to self; sprain right foot,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns"  
	elseif nRollValue < 304 then sResult = "Non-wpn injury to self; sprain right ankle,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns"  
	elseif nRollValue < 305 then sResult = "Non-wpn injury to self; sprain right knee,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns"  
	elseif nRollValue < 306 then sResult = "Non-wpn injury to self; sprain right hip,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns"  
	elseif nRollValue < 307 then sResult = "Non-wpn injury to self; sprain right wrist,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns"  
	elseif nRollValue < 308 then sResult = "Non-wpn injury to self; sprain right shoulder,minus {1d4} to hit for {1d4} days unless magically cured"  
	elseif nRollValue < 309 then sResult = "Non-wpn injury to self; sprain right elbow,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns"  
	elseif nRollValue < 310 then sResult = "Non-wpn injury to self; sprain left foot,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns"  
	elseif nRollValue < 311 then sResult = "Non-wpn injury to self; sprain left ankle,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns"  
	elseif nRollValue < 312 then sResult = "Non-wpn injury to self; sprain left knee,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns"  
	elseif nRollValue < 313 then sResult = "Non-wpn injury to self; sprain left hip,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns"  
	elseif nRollValue < 314 then sResult = "Non-wpn injury to self; sprain left wrist,minus {1d4} to hit for {1d4} days unless magically cured"  
	elseif nRollValue < 315 then sResult = "Non-wpn injury to self; sprain left shoulder,minus {1d4} to hit for {1d4} days unless magically cured"  
	elseif nRollValue < 316 then sResult = "Non-wpn injury to self; sprain left elbow,minus {1d4} to hit for {1d4} days unless magically cured"  
	elseif nRollValue < 317 then sResult = "Non-wpn injury to self; sprain neck,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns"  
	elseif nRollValue < 318 then sResult = "Non-wpn injury to self; sprain back,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns"  
	elseif nRollValue < 319 then sResult = "Non-wpn injury to self, pulled muscle, Roll on crit (puncture) chart until reasonable result attained"  
	elseif nRollValue < 337 then sResult = "Non-wpn injury to self; hyperextention right foot,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue < 338 then sResult = "Non-wpn injury to self; hyperextention right ankle,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue < 340 then sResult = "Non-wpn injury to self; hyperextention right knee,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue < 341 then sResult = "Non-wpn injury to self; hyperextention right hip,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue < 342 then sResult = "Non-wpn injury to self; hyperextention right wrist,minus {1d4} to hit for {1d4} days unless magically cured, {1d20}% temporal honor reduction."  
	elseif nRollValue < 343 then sResult = "Non-wpn injury to self; hyperextention right shoulder,minus {1d4} to hit for {1d4} days unless magically cured, {1d20}% temporal honor reduction."  
	elseif nRollValue < 345 then sResult = "Non-wpn injury to self; hyperextention right elbow,minus {1d4} to hit for {1d4} days unless magically cured, {1d20}% temporal honor reduction."  
	elseif nRollValue < 346 then sResult = "Non-wpn injury to self; hyperextention left foot,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue < 347 then sResult = "Non-wpn injury to self; hyperextention left ankle,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue < 349 then sResult = "Non-wpn injury to self; hyperextention left knee,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue < 351 then sResult = "Non-wpn injury to self; hyperextention left hip,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue < 352 then sResult = "Non-wpn injury to self; hyperextention left wrist,minus {1d4} to hit for {1d4} days unless magically cured, {1d20}% temporal honor reduction."  
	elseif nRollValue < 353 then sResult = "Non-wpn injury to self; hyperextention left shoulder,minus {1d4} to hit for {1d4} days unless magically cured, {1d20}% temporal honor reduction."  
	elseif nRollValue < 354 then sResult = "Non-wpn injury to self; hyperextention left elbow,minus {1d4} to hit for {1d4} days unless magically cured, {1d20}% temporal honor reduction."  
	elseif nRollValue < 355 then sResult = "Non-wpn injury to self; hyperexted neck,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue < 358 then sResult = "Non-wpn injury to self; hyperexted back,50% movement reduction for 1 round then 10% for {2d4} rounds, then 25% for {1d6} turns, {1d20}% temporal honor reduction."  
	elseif nRollValue < 359 then sResult = "Damage own armor for {1d3} points"  
	elseif nRollValue < 401 then sResult = "Damage to ally, make Dex check to deliver only half damage"  
	elseif nRollValue < 501 then sResult = "Weapon damaged/broken; handle broken -1 to hit"  
	elseif nRollValue < 541 then sResult = "Weapon damaged/broken; blade/head broken -1 to damage"  
	elseif nRollValue < 581 then sResult = "Weapon damaged/broken; blade shattered (useless)"  
	elseif nRollValue < 591 then sResult = "Weapon damaged/broken; handle/haft sheared (useless)"  
	elseif nRollValue < 601 then sResult = "Weapon damaged/broken; sheared (useless)"  
	elseif nRollValue < 611 then sResult = "Weapon damaged/broken; handle badly broken -2 to hit"  
	elseif nRollValue < 631 then sResult = "Weapon damaged/broken; blade/head badly broken -2 dmg"  
	elseif nRollValue < 651 then sResult = "Weapon damaged/broken; blade/head sheared/cracked -50% to dmg"  
	elseif nRollValue < 661 then sResult = "Weapon damaged/broken; edge dulled, nicked and/or cracked (-1 to hit & damage)"  
	elseif nRollValue < 701 then sResult = "Equipment Mishap; boot/footgear breaks, -1 to hit until repaired or discarded"  
	elseif nRollValue < 716 then sResult = "Equipment Mishap; backpack, pouch or other container strap breaks, -1 to hit until item repaired or discarded"  
	elseif nRollValue < 761 then sResult = "Equipment Mishap; belt, girdle, etc. breaks"  
	elseif nRollValue < 791 then sResult = "Equipment Mishap; armor loosened, -1 to hit until readjusted (by redonning or by another person helping for 1 round)"  
	elseif nRollValue < 814 then sResult = "Equipment Mishap; armor strap breaks, +1 AC penalty and -1 to hit until repaired"  
	elseif nRollValue < 821 then sResult = "Equipment Mishap; shield strap breaks, -3 to hit until repaired or discarded"  
	elseif nRollValue < 851 then sResult = "Hinderance; sweat in eyes -1 to hit for 1 round"  
	elseif nRollValue < 869 then sResult = "Hinderance; blood in eyes -3 to hit for 1 turn"  
	elseif nRollValue < 886 then sResult = "Hinderance; nearby ally is automatically hit"  
	elseif nRollValue < 904 then sResult = "Hinderance; distracted, -4 to hit and no Dex bonus to AC for 1 round"  
	elseif nRollValue < 921 then sResult = "Clumsiness; overexted +d4 penalty to next initiative, opponent gains +2 to next attack roll"  
	elseif nRollValue < 937 then sResult = "Clumsiness; hinder ally - takes +{1d6} initiative penalty, suffers -{1d4+1} to hit penalty on next attack or have 25% chance of hitting you"  
	elseif nRollValue < 953 then sResult = "Clumsiness; off balance +{1d4} penalty to next initiative"  
	elseif nRollValue < 969 then sResult = "Clumsiness; overexted, opponent gains +2 to next to-hit"  
	elseif nRollValue < 985 then sResult = "Clumsiness; Slip, opponent gains +2 to next to hit roll, -4 Dex for one round and make check vs. 1/2 Dex or fall prone"
	end
	
	sResult = replaceRolls(sResult);
	return sResult;
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