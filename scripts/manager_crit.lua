

local aHackingCritMatrix = {};
local aCrushingCritMatrix = {};
local aPuncturingCritMatrix = {};
local aCritLocations = {};

function onInit()
	Comm.registerSlashHandler("crit", onCritSlashCommand);
	
	buildHackingCritMatrix();
	buildCrushingCritMatrix();
	buildPuncturingCritMatrix();
	buildCritLocationInfo();		
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
	local bIsRightSide = nHitLocationRoll % 2 == 0;
	local sLocation = "";
		
	if nHitLocationRoll < 101 then sLocation = "Foot, top";
	elseif nHitLocationRoll < 105 then sLocation = "Heel";
	elseif nHitLocationRoll < 137 then sLocation = "Toe(s)";
	elseif nHitLocationRoll < 141 then sLocation = "Foot, arch";
	elseif nHitLocationRoll < 171 then sLocation = "Ankle, inner";
	elseif nHitLocationRoll < 201 then sLocation = "Ankle, outer";
	elseif nHitLocationRoll < 221 then sLocation = "Ankle, upper/Achilles";
	elseif nHitLocationRoll < 965 then sLocation = "Shin";
	elseif nHitLocationRoll < 1007 then sLocation = "Calf";
	elseif nHitLocationRoll < 1119 then sLocation = "Knee";
	elseif nHitLocationRoll < 1133 then sLocation = "Knee, back";
	elseif nHitLocationRoll < 1217 then sLocation = "Hamstring";
	elseif nHitLocationRoll < 2001 then sLocation = "Thigh";
	elseif nHitLocationRoll < 2331 then sLocation = "Hip";
	elseif nHitLocationRoll < 2406 then sLocation = "Groin";
	elseif nHitLocationRoll < 2436 then sLocation = "Buttock";
	elseif nHitLocationRoll < 2571 then sLocation = "Abdomen, Lower";
	elseif nHitLocationRoll < 3021 then sLocation = "Side, lower";
	elseif nHitLocationRoll < 3111 then sLocation = "Abdomen, upper";
	elseif nHitLocationRoll < 3126 then sLocation = "Back, small of";
	elseif nHitLocationRoll < 3156 then sLocation = "Back, lower";
	elseif nHitLocationRoll < 3426 then sLocation = "Chest";
	elseif nHitLocationRoll < 3456 then sLocation = "Side, upper";
	elseif nHitLocationRoll < 3486 then sLocation = "Back, upper";
	elseif nHitLocationRoll < 3501 then sLocation = "Back, upper middle";
	elseif nHitLocationRoll < 3821 then sLocation = "Armpit";
	elseif nHitLocationRoll < 4301 then sLocation = "Arm, upper outer";
	elseif nHitLocationRoll < 4493 then sLocation = "Arm, upper inner";
	elseif nHitLocationRoll < 4589 then sLocation = "Elbow";
	elseif nHitLocationRoll < 4685 then sLocation = "Inner joint";
	elseif nHitLocationRoll < 5309 then sLocation = "Forearm, back";
	elseif nHitLocationRoll < 5837 then sLocation = "Forearm, inner";
	elseif nHitLocationRoll < 5909 then sLocation = "Wrist, back";
	elseif nHitLocationRoll < 5981 then sLocation = "Wrist, front";
	elseif nHitLocationRoll < 6053 then sLocation = "Hand, back";
	elseif nHitLocationRoll < 6077 then sLocation = "Palm";
	elseif nHitLocationRoll < 6221 then sLocation = "Finger(s)";
	elseif nHitLocationRoll < 7181 then sLocation = "Shoulder, side";
	elseif nHitLocationRoll < 9101 then sLocation = "Shoulder, top";
	elseif nHitLocationRoll < 9122 then sLocation = "Neck, back";
	elseif nHitLocationRoll < 9143 then sLocation = "Neck, back"; 
	elseif nHitLocationRoll < 9374 then sLocation = "Neck, side"; 
	elseif nHitLocationRoll < 9654 then sLocation = "Head, side"; 
	elseif nHitLocationRoll < 9689 then sLocation = "Head, back lower";
	elseif nHitLocationRoll < 9769 then sLocation = "Face, lower side";
	elseif nHitLocationRoll < 9789 then sLocation = "Face, lower center";
	elseif nHitLocationRoll < 9824 then sLocation = "Head, back upper";
	elseif nHitLocationRoll < 9904 then sLocation = "Face, upper side";
	elseif nHitLocationRoll < 9924 then sLocation = "Face, upper center";
	else sLocation = "Head, top";
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

function getCritEffects(sLocation, nSeverity, sDamageTypes)
	local sCritType = getCritType(sDamageTypes);
	if sCritType == "p" then
		return getPuncturingCrit(sLocation, nSeverity);
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
		local sLocation, sSide = getHitLocation(nHitLocationRoll);
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
		sResult = sResult .. "\r" .. getCritEffects(sLocation, nSeverity, sDamageTypes)";		

	end

	deliverChatMessage(sResult);
end

function calculateBaseSeverity(nAttackerThaco, nTargetAc, nAttackBonus)
	local nToHitAc15 = nAttackerThaco - 15;
	return nTargetAc - nToHitAc15 + nAttackBonus;
end

function getPuncturingCrit(sLocation, nSeverity)
	return decodeCritEffect(aPuncturingCritMatrix[sLocation][nSeverity], sLocation, nSeverity);
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
	
	table.insert(aEffects, sEffectName .. " Can be cured by magical means or through healing at " .. sHealRate .. "  the normal rate. Successfully setting a broken bone using first aid-related skills allows healing at one quarter the normal rate. Unless set properly prior to healing, even magical healing, fractures will heal incorrectly giving rise to lasting limps, obvious lumps, etc. In this case, half of any associated movement and/or ability score penalties will be permanent. A Cure Critical Wounds spell or better will eliminate all ill effects instantly.");
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
	
	table.insert("Torn ligament or tendon (" .. getMuscle(rLocation, nIndex) .. ")! Unless the appropriate body part is isolated prior to healing, even magical healing, will heal incorrectly or incompletely, giving rise to lasting limps, obvious lumps, etc. In this case, half of any associated movement and/or ability score penalties will become permanent. A Cure Critical Wounds spell or better will eliminate all ill effects instantly.");
	
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
	table.insert(aEffect, "Each hour lose 1d4 hit points and make a Constitution check, with failure indicating that the character goes into shock (see Trauma Damage). May live for many hours or days with this problem and not know it; will feel pains in the area, but will otherwise not know that he has been injured");
end

function decodeUnconscious(aEffects)
	table.insert(aEffects, "Falls to the ground, out cold. Remains in a coma until the hit points suffered from this wound are healed (naturally or magically)");
end

function decodeLimbSevered(aEffects, rLocation)
	table.insert("Limb severed! The stump can be cured by magical means or through natural healing at one third the normal rate. Regeneration, Reattach Limb, or the like needed to recover the limb.");
	
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
	else sMsg =  "Lose 75% move for 1 week, then 50% for " .. DiceMechanicsManager.getDiceResult(1, 6) .. " months";
	end
	table.insert(aEffects, sMsg);
end

function decodeMaxDamageBonus(rLocation)
	-- TODO: have it calculate this based on target
	return "Bonus damage may not exceed " .. rLocation.dam * 100 .. "% of health. If part takes max damage, it is severed or destroyed";
end

function decodeDamageBonus(aEffects, nDieType, rLocation)
	table.insert(aEffects, "Damage Bonus: (d" .. nDieType .. ") " .. decodeMaxDamageBonus(rLocation));
end

function decodeDamageMultiplier(aEffects, nMultiplier, rLocation)
	table.insert(aEffects, "Damage Multiplier: (x" .. nMultiplier .. ") " .. decodeMaxDamageBonus(rLocation));
end

function toCsv(tt)
	local s = "";
	for _, p in ipairs(tt) do
		s = s .. "/r[Effect: " .. p .. "]";
	end
	return string.sub(s, 3);
end

function buildHackingCritMatrix()
	aHackingCritMatrix["Foot, top"][1] = {db=1};
	aHackingCritMatrix["Foot, top"][2] = {db=1};
	aHackingCritMatrix["Foot, top"][3] = {db=3};
	aHackingCritMatrix["Foot, top"][4] = {db=3};
	aHackingCritMatrix["Foot, top"][5] = {db=4,m=1};
	aHackingCritMatrix["Foot, top"][6] = {db=4,m=1};
	aHackingCritMatrix["Foot, top"][7] = {db=6,t=1,m=2};
	aHackingCritMatrix["Foot, top"][8] = {db=6,t=1,m=2};
	aHackingCritMatrix["Foot, top"][9] = {db=8,t=1,m=3};
	aHackingCritMatrix["Foot, top"][10] = {db=8,t=1,m=3};
	aHackingCritMatrix["Foot, top"][11] = {dm=2,t=1,m=4};
	aHackingCritMatrix["Foot, top"][12] = {dm=2,t=1,m=4};
	aHackingCritMatrix["Foot, top"][13] = {dm=2,t=1,m=5};
	aHackingCritMatrix["Foot, top"][14] = {dm=2,t=1,m=5};
	aHackingCritMatrix["Foot, top"][15] = {dm=2,t=1,m=6};
	aHackingCritMatrix["Foot, top"][16] = {dm=2,t=1,m=6};
	aHackingCritMatrix["Foot, top"][17] = {dm=2,t=1,m=7};
	aHackingCritMatrix["Foot, top"][18] = {dm=2,t=1,m=7};
	aHackingCritMatrix["Foot, top"][19] = {dm=2t=1,m=7,b=1};
	aHackingCritMatrix["Foot, top"][20] = {dm=2,t=1,m=8,bm=1};
	aHackingCritMatrix["Foot, top"][21] = {dm=2,t=1,bf=1,m=8};
	aHackingCritMatrix["Foot, top"][22] = {dm=2,t=1,bf=1,m=9};
	aHackingCritMatrix["Foot, top"][23] = {dm=2,ls=true,m=9};
	aHackingCritMatrix["Foot, top"][24] = {dm=2,ls=true,m=10};
	
	aHackingCritMatrix["Heel"][1] = {db=1};
	aHackingCritMatrix["Heel"][2] = {db=1};
	aHackingCritMatrix["Heel"][3] = {db=3};
	aHackingCritMatrix["Heel"][4] = {db=3};
	aHackingCritMatrix["Heel"][5] = {db=4,m=1};
	aHackingCritMatrix["Heel"][6] = {db=4,m=1};
	aHackingCritMatrix["Heel"][7] = {db=6,t=1,m=2};
	aHackingCritMatrix["Heel"][8] = {db=6,t=1,m=2,a=1};
	aHackingCritMatrix["Heel"][9] = {db=8,t=1,m=3,a=1};
	aHackingCritMatrix["Heel"][10] = {db=8,t=1,m=3,a=2};
	aHackingCritMatrix["Heel"][11] = {dm=2,t=1,m=4,a=2};
	aHackingCritMatrix["Heel"][12] = {dm=2,t=1,d=1,m=4};
	aHackingCritMatrix["Heel"][13] = {dm=2,t=1,a=2,d=2,m=5};
	aHackingCritMatrix["Heel"][14] = {dm=2,t=1,a=2,d=2,m=5};
	aHackingCritMatrix["Heel"][15] = {dm=2,t=1,a=2,d=2,m=6};
	aHackingCritMatrix["Heel"][16] = {dm=2,t=1,a=3,d=2,m=6};
	aHackingCritMatrix["Heel"][17] = {dm=2,t=1,a=3,d=2,m=7};
	aHackingCritMatrix["Heel"][18] = {dm=2,t=1,b=1,a=3,d=2,m=7};
	aHackingCritMatrix["Heel"][19] = {dm=2,t=1,bm=1,a=3,d=2,m=7};
	aHackingCritMatrix["Heel"][20] = {dm=2,t=1,bm=1,a=3,d=2,m=8};
	aHackingCritMatrix["Heel"][21] = {dm=2,t=1,bf=1,a=3,d=2,m=8};
	aHackingCritMatrix["Heel"][22] = {dm=2,t=1,bf=1,a=3,d=2,m=9};
	aHackingCritMatrix["Heel"][23] = {dm=2,t=1,bs=1,a=3,d=2,m=9};
	aHackingCritMatrix["Heel"][24] = {dm=2,t=1,bs=1,a=3,d=2,m=10};

	aHackingCritMatrix["Toe(s)"][1] = {db=1};
	aHackingCritMatrix["Toe(s)"][2] = {db=1};
	aHackingCritMatrix["Toe(s)"][3] = {db=3};
	aHackingCritMatrix["Toe(s)"][4] = {db=3};
	aHackingCritMatrix["Toe(s)"][5] = {db=4,m=1};
	aHackingCritMatrix["Toe(s)"][6] = {db=4,m=1};
	aHackingCritMatrix["Toe(s)"][7] = {db=6,t=1,m=2};
	aHackingCritMatrix["Toe(s)"][8] = {db=6,t=1,m=2};
	aHackingCritMatrix["Toe(s)"][9] = {db=8,t=1,m=3};
	aHackingCritMatrix["Toe(s)"][10] = {db=8,t=1,m=3};
	aHackingCritMatrix["Toe(s)"][11] = {dm=2,t=1,m=4};
	aHackingCritMatrix["Toe(s)"][12] = {dm=2,t=1,m=4};
	aHackingCritMatrix["Toe(s)"][13] = {dm=2,t=1,m=5};
	aHackingCritMatrix["Toe(s)"][14] = {dm=2,t=1,m=5};
	aHackingCritMatrix["Toe(s)"][15] = {dm=2,t=1,m=6};
	aHackingCritMatrix["Toe(s)"][16] = {dm=2,t=1,b=1,m=6};
	aHackingCritMatrix["Toe(s)"][17] = {dm=2,t=1,bm=1,m=7};
	aHackingCritMatrix["Toe(s)"][18] = {dm=2,t=1,bm=1,m=7};
	aHackingCritMatrix["Toe(s)"][19] = {dm=2,ls=true,m=7};
	aHackingCritMatrix["Toe(s)"][20] = {dm=2,ls=true,m=8};
	aHackingCritMatrix["Toe(s)"][21] = {dm=2,ls=true,m=8};
	aHackingCritMatrix["Toe(s)"][22] = {dm=2,ls=true,m=9};
	aHackingCritMatrix["Toe(s)"][23] = {dm=2,ls=true,m=9};
	aHackingCritMatrix["Toe(s)"][24] = {dm=2,ls=true,m=10};
	
	aHackingCritMatrix["Foot, arch"][1] = {db=1};
	aHackingCritMatrix["Foot, arch"][2] = {db=1};
	aHackingCritMatrix["Foot, arch"][3] = {db=3};
	aHackingCritMatrix["Foot, arch"][4] = {db=3};
	aHackingCritMatrix["Foot, arch"][5] = {db=4,m=1};
	aHackingCritMatrix["Foot, arch"][6] = {db=4,m=1};
	aHackingCritMatrix["Foot, arch"][7] = {db=6,t=1,m=2};
	aHackingCritMatrix["Foot, arch"][8] = {db=6,t=1,m=2,a=1};
	aHackingCritMatrix["Foot, arch"][9] = {db=8,t=1,m=3,a=1};
	aHackingCritMatrix["Foot, arch"][10] = {db=8,t=1,m=3,a=2};
	aHackingCritMatrix["Foot, arch"][11] = {dm=2,t=1,m=4,a=2};
	aHackingCritMatrix["Foot, arch"][12] = {dm=2,t=1,a=2,d=1,m=4};
	aHackingCritMatrix["Foot, arch"][13] = {dm=2,t=1,a=2,d=2,m=5};
	aHackingCritMatrix["Foot, arch"][14] = {dm=2,b=1,a=2,d=2,m=5};
	aHackingCritMatrix["Foot, arch"][15] = {dm=2,b=1,a=2,d=2,m=6};
	aHackingCritMatrix["Foot, arch"][16] = {dm=2,b=1,a=3,d=2,m=6};
	aHackingCritMatrix["Foot, arch"][17] = {dm=2,b=1,a=3,d=2,m=7};
	aHackingCritMatrix["Foot, arch"][18] = {dm=2,b=1,a=3,d=2,m=7};
	aHackingCritMatrix["Foot, arch"][19] = {dm=2,bm=1,a=3,d=2,m=7};
	aHackingCritMatrix["Foot, arch"][20] = {dm=2,bm=1,a=3,d=2,m=8};
	aHackingCritMatrix["Foot, arch"][21] = {dm=2,bf=1,a=3,d=2,m=8};
	aHackingCritMatrix["Foot, arch"][22] = {dm=2,t=1,bf=1,a=3,d=2,m=9};
	aHackingCritMatrix["Foot, arch"][23] = {dm=2,ls=true,a=3,d=2,m=9};
	aHackingCritMatrix["Foot, arch"][24] = {dm=2,ls=true,a=3,d=2,m=10};
	
	aHackingCritMatrix["Ankle, inner"][1] = {};
	aHackingCritMatrix["Ankle, inner"][2] = {};
	aHackingCritMatrix["Ankle, inner"][3] = {};
	aHackingCritMatrix["Ankle, inner"][4] = {};
	aHackingCritMatrix["Ankle, inner"][5] = {};
	aHackingCritMatrix["Ankle, inner"][6] = {};
	aHackingCritMatrix["Ankle, inner"][7] = {};
	aHackingCritMatrix["Ankle, inner"][8] = {};
	aHackingCritMatrix["Ankle, inner"][9] = {};
	aHackingCritMatrix["Ankle, inner"][10] = {};
	aHackingCritMatrix["Ankle, inner"][11] = {};
	aHackingCritMatrix["Ankle, inner"][12] = {};
	aHackingCritMatrix["Ankle, inner"][13] = {};
	aHackingCritMatrix["Ankle, inner"][14] = {};
	aHackingCritMatrix["Ankle, inner"][15] = {};
	aHackingCritMatrix["Ankle, inner"][16] = {};
	aHackingCritMatrix["Ankle, inner"][17] = {};
	aHackingCritMatrix["Ankle, inner"][18] = {};
	aHackingCritMatrix["Ankle, inner"][19] = {};
	aHackingCritMatrix["Ankle, inner"][20] = {};
	aHackingCritMatrix["Ankle, inner"][21] = {};
	aHackingCritMatrix["Ankle, inner"][22] = {};
	aHackingCritMatrix["Ankle, inner"][23] = {};
	aHackingCritMatrix["Ankle, inner"][24] = {};
	
	aHackingCritMatrix["Ankle, outer"][1] = {};
	aHackingCritMatrix["Ankle, outer"][2] = {};
	aHackingCritMatrix["Ankle, outer"][3] = {};
	aHackingCritMatrix["Ankle, outer"][4] = {};
	aHackingCritMatrix["Ankle, outer"][5] = {};
	aHackingCritMatrix["Ankle, outer"][6] = {};
	aHackingCritMatrix["Ankle, outer"][7] = {};
	aHackingCritMatrix["Ankle, outer"][8] = {};
	aHackingCritMatrix["Ankle, outer"][9] = {};
	aHackingCritMatrix["Ankle, outer"][10] = {};
	aHackingCritMatrix["Ankle, outer"][11] = {};
	aHackingCritMatrix["Ankle, outer"][12] = {};
	aHackingCritMatrix["Ankle, outer"][13] = {};
	aHackingCritMatrix["Ankle, outer"][14] = {};
	aHackingCritMatrix["Ankle, outer"][15] = {};
	aHackingCritMatrix["Ankle, outer"][16] = {};
	aHackingCritMatrix["Ankle, outer"][17] = {};
	aHackingCritMatrix["Ankle, outer"][18] = {};
	aHackingCritMatrix["Ankle, outer"][19] = {};
	aHackingCritMatrix["Ankle, outer"][20] = {};
	aHackingCritMatrix["Ankle, outer"][21] = {};
	aHackingCritMatrix["Ankle, outer"][22] = {};
	aHackingCritMatrix["Ankle, outer"][23] = {};
	aHackingCritMatrix["Ankle, outer"][24] = {};
	
	aHackingCritMatrix["Ankle, upper/Achilles"][1] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][2] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][3] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][4] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][5] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][6] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][7] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][8] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][9] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][10] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][11] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][12] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][13] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][14] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][15] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][16] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][17] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][18] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][19] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][20] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][21] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][22] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][23] = {};
	aHackingCritMatrix["Ankle, upper/Achilles"][24] = {};
	
	aHackingCritMatrix["Shin"][1] = {};
	aHackingCritMatrix["Shin"][2] = {};
	aHackingCritMatrix["Shin"][3] = {};
	aHackingCritMatrix["Shin"][4] = {};
	aHackingCritMatrix["Shin"][5] = {};
	aHackingCritMatrix["Shin"][6] = {};
	aHackingCritMatrix["Shin"][7] = {};
	aHackingCritMatrix["Shin"][8] = {};
	aHackingCritMatrix["Shin"][9] = {};
	aHackingCritMatrix["Shin"][10] = {};
	aHackingCritMatrix["Shin"][11] = {};
	aHackingCritMatrix["Shin"][12] = {};
	aHackingCritMatrix["Shin"][13] = {};
	aHackingCritMatrix["Shin"][14] = {};
	aHackingCritMatrix["Shin"][15] = {};
	aHackingCritMatrix["Shin"][16] = {};
	aHackingCritMatrix["Shin"][17] = {};
	aHackingCritMatrix["Shin"][18] = {};
	aHackingCritMatrix["Shin"][19] = {};
	aHackingCritMatrix["Shin"][20] = {};
	aHackingCritMatrix["Shin"][21] = {};
	aHackingCritMatrix["Shin"][22] = {};
	aHackingCritMatrix["Shin"][23] = {};
	aHackingCritMatrix["Shin"][24] = {};

	aHackingCritMatrix["Calf"][1] = {};
	aHackingCritMatrix["Calf"][2] = {};
	aHackingCritMatrix["Calf"][3] = {};
	aHackingCritMatrix["Calf"][4] = {};
	aHackingCritMatrix["Calf"][5] = {};
	aHackingCritMatrix["Calf"][6] = {};
	aHackingCritMatrix["Calf"][7] = {};
	aHackingCritMatrix["Calf"][8] = {};
	aHackingCritMatrix["Calf"][9] = {};
	aHackingCritMatrix["Calf"][10] = {};
	aHackingCritMatrix["Calf"][11] = {};
	aHackingCritMatrix["Calf"][12] = {};
	aHackingCritMatrix["Calf"][13] = {};
	aHackingCritMatrix["Calf"][14] = {};
	aHackingCritMatrix["Calf"][15] = {};
	aHackingCritMatrix["Calf"][16] = {};
	aHackingCritMatrix["Calf"][17] = {};
	aHackingCritMatrix["Calf"][18] = {};
	aHackingCritMatrix["Calf"][19] = {};
	aHackingCritMatrix["Calf"][20] = {};
	aHackingCritMatrix["Calf"][21] = {};
	aHackingCritMatrix["Calf"][22] = {};
	aHackingCritMatrix["Calf"][23] = {};
	aHackingCritMatrix["Calf"][24] = {};

	aHackingCritMatrix["Knee"][1] = {};
	aHackingCritMatrix["Knee"][2] = {};
	aHackingCritMatrix["Knee"][3] = {};
	aHackingCritMatrix["Knee"][4] = {};
	aHackingCritMatrix["Knee"][5] = {};
	aHackingCritMatrix["Knee"][6] = {};
	aHackingCritMatrix["Knee"][7] = {};
	aHackingCritMatrix["Knee"][8] = {};
	aHackingCritMatrix["Knee"][9] = {};
	aHackingCritMatrix["Knee"][10] = {};
	aHackingCritMatrix["Knee"][11] = {};
	aHackingCritMatrix["Knee"][12] = {};
	aHackingCritMatrix["Knee"][13] = {};
	aHackingCritMatrix["Knee"][14] = {};
	aHackingCritMatrix["Knee"][15] = {};
	aHackingCritMatrix["Knee"][16] = {};
	aHackingCritMatrix["Knee"][17] = {};
	aHackingCritMatrix["Knee"][18] = {};
	aHackingCritMatrix["Knee"][19] = {};
	aHackingCritMatrix["Knee"][20] = {};
	aHackingCritMatrix["Knee"][21] = {};
	aHackingCritMatrix["Knee"][22] = {};
	aHackingCritMatrix["Knee"][23] = {};
	aHackingCritMatrix["Knee"][24] = {};
		
	aHackingCritMatrix["Knee, back"][1] = {};
	aHackingCritMatrix["Knee, back"][2] = {};
	aHackingCritMatrix["Knee, back"][3] = {};
	aHackingCritMatrix["Knee, back"][4] = {};
	aHackingCritMatrix["Knee, back"][5] = {};
	aHackingCritMatrix["Knee, back"][6] = {};
	aHackingCritMatrix["Knee, back"][7] = {};
	aHackingCritMatrix["Knee, back"][8] = {};
	aHackingCritMatrix["Knee, back"][9] = {};
	aHackingCritMatrix["Knee, back"][10] = {};
	aHackingCritMatrix["Knee, back"][11] = {};
	aHackingCritMatrix["Knee, back"][12] = {};
	aHackingCritMatrix["Knee, back"][13] = {};
	aHackingCritMatrix["Knee, back"][14] = {};
	aHackingCritMatrix["Knee, back"][15] = {};
	aHackingCritMatrix["Knee, back"][16] = {};
	aHackingCritMatrix["Knee, back"][17] = {};
	aHackingCritMatrix["Knee, back"][18] = {};
	aHackingCritMatrix["Knee, back"][19] = {};
	aHackingCritMatrix["Knee, back"][20] = {};
	aHackingCritMatrix["Knee, back"][21] = {};
	aHackingCritMatrix["Knee, back"][22] = {};
	aHackingCritMatrix["Knee, back"][23] = {};
	aHackingCritMatrix["Knee, back"][24] = {};
	
	aHackingCritMatrix["Hamstring"][1] = {};
	aHackingCritMatrix["Hamstring"][2] = {};
	aHackingCritMatrix["Hamstring"][3] = {};
	aHackingCritMatrix["Hamstring"][4] = {};
	aHackingCritMatrix["Hamstring"][5] = {};
	aHackingCritMatrix["Hamstring"][6] = {};
	aHackingCritMatrix["Hamstring"][7] = {};
	aHackingCritMatrix["Hamstring"][8] = {};
	aHackingCritMatrix["Hamstring"][9] = {};
	aHackingCritMatrix["Hamstring"][10] = {};
	aHackingCritMatrix["Hamstring"][11] = {};
	aHackingCritMatrix["Hamstring"][12] = {};
	aHackingCritMatrix["Hamstring"][13] = {};
	aHackingCritMatrix["Hamstring"][14] = {};
	aHackingCritMatrix["Hamstring"][15] = {};
	aHackingCritMatrix["Hamstring"][16] = {};
	aHackingCritMatrix["Hamstring"][17] = {};
	aHackingCritMatrix["Hamstring"][18] = {};
	aHackingCritMatrix["Hamstring"][19] = {};
	aHackingCritMatrix["Hamstring"][20] = {};
	aHackingCritMatrix["Hamstring"][21] = {};
	aHackingCritMatrix["Hamstring"][22] = {};
	aHackingCritMatrix["Hamstring"][23] = {};
	aHackingCritMatrix["Hamstring"][24] = {};
	
	aHackingCritMatrix["Thigh"][1] = {};
	aHackingCritMatrix["Thigh"][2] = {};
	aHackingCritMatrix["Thigh"][3] = {};
	aHackingCritMatrix["Thigh"][4] = {};
	aHackingCritMatrix["Thigh"][5] = {};
	aHackingCritMatrix["Thigh"][6] = {};
	aHackingCritMatrix["Thigh"][7] = {};
	aHackingCritMatrix["Thigh"][8] = {};
	aHackingCritMatrix["Thigh"][9] = {};
	aHackingCritMatrix["Thigh"][10] = {};
	aHackingCritMatrix["Thigh"][11] = {};
	aHackingCritMatrix["Thigh"][12] = {};
	aHackingCritMatrix["Thigh"][13] = {};
	aHackingCritMatrix["Thigh"][14] = {};
	aHackingCritMatrix["Thigh"][15] = {};
	aHackingCritMatrix["Thigh"][16] = {};
	aHackingCritMatrix["Thigh"][17] = {};
	aHackingCritMatrix["Thigh"][18] = {};
	aHackingCritMatrix["Thigh"][19] = {};
	aHackingCritMatrix["Thigh"][20] = {};
	aHackingCritMatrix["Thigh"][21] = {};
	aHackingCritMatrix["Thigh"][22] = {};
	aHackingCritMatrix["Thigh"][23] = {};
	aHackingCritMatrix["Thigh"][24] = {};
	
	aHackingCritMatrix["Hip"][1] = {};
	aHackingCritMatrix["Hip"][2] = {};
	aHackingCritMatrix["Hip"][3] = {};
	aHackingCritMatrix["Hip"][4] = {};
	aHackingCritMatrix["Hip"][5] = {};
	aHackingCritMatrix["Hip"][6] = {};
	aHackingCritMatrix["Hip"][7] = {};
	aHackingCritMatrix["Hip"][8] = {};
	aHackingCritMatrix["Hip"][9] = {};
	aHackingCritMatrix["Hip"][10] = {};
	aHackingCritMatrix["Hip"][11] = {};
	aHackingCritMatrix["Hip"][12] = {};
	aHackingCritMatrix["Hip"][13] = {};
	aHackingCritMatrix["Hip"][14] = {};
	aHackingCritMatrix["Hip"][15] = {};
	aHackingCritMatrix["Hip"][16] = {};
	aHackingCritMatrix["Hip"][17] = {};
	aHackingCritMatrix["Hip"][18] = {};
	aHackingCritMatrix["Hip"][19] = {};
	aHackingCritMatrix["Hip"][20] = {};
	aHackingCritMatrix["Hip"][21] = {};
	aHackingCritMatrix["Hip"][22] = {};
	aHackingCritMatrix["Hip"][23] = {};
	aHackingCritMatrix["Hip"][24] = {};

	aHackingCritMatrix["Groin"][1] = {};
	aHackingCritMatrix["Groin"][2] = {};
	aHackingCritMatrix["Groin"][3] = {};
	aHackingCritMatrix["Groin"][4] = {};
	aHackingCritMatrix["Groin"][5] = {};
	aHackingCritMatrix["Groin"][6] = {};
	aHackingCritMatrix["Groin"][7] = {};
	aHackingCritMatrix["Groin"][8] = {};
	aHackingCritMatrix["Groin"][9] = {};
	aHackingCritMatrix["Groin"][10] = {};
	aHackingCritMatrix["Groin"][11] = {};
	aHackingCritMatrix["Groin"][12] = {};
	aHackingCritMatrix["Groin"][13] = {};
	aHackingCritMatrix["Groin"][14] = {};
	aHackingCritMatrix["Groin"][15] = {};
	aHackingCritMatrix["Groin"][16] = {};
	aHackingCritMatrix["Groin"][17] = {};
	aHackingCritMatrix["Groin"][18] = {};
	aHackingCritMatrix["Groin"][19] = {};
	aHackingCritMatrix["Groin"][20] = {};
	aHackingCritMatrix["Groin"][21] = {};
	aHackingCritMatrix["Groin"][22] = {};
	aHackingCritMatrix["Groin"][23] = {};
	aHackingCritMatrix["Groin"][24] = {};
	
	aHackingCritMatrix["Buttock"][1] = {};
	aHackingCritMatrix["Buttock"][2] = {};
	aHackingCritMatrix["Buttock"][3] = {};
	aHackingCritMatrix["Buttock"][4] = {};
	aHackingCritMatrix["Buttock"][5] = {};
	aHackingCritMatrix["Buttock"][6] = {};
	aHackingCritMatrix["Buttock"][7] = {};
	aHackingCritMatrix["Buttock"][8] = {};
	aHackingCritMatrix["Buttock"][9] = {};
	aHackingCritMatrix["Buttock"][10] = {};
	aHackingCritMatrix["Buttock"][11] = {};
	aHackingCritMatrix["Buttock"][12] = {};
	aHackingCritMatrix["Buttock"][13] = {};
	aHackingCritMatrix["Buttock"][14] = {};
	aHackingCritMatrix["Buttock"][15] = {};
	aHackingCritMatrix["Buttock"][16] = {};
	aHackingCritMatrix["Buttock"][17] = {};
	aHackingCritMatrix["Buttock"][18] = {};
	aHackingCritMatrix["Buttock"][19] = {};
	aHackingCritMatrix["Buttock"][20] = {};
	aHackingCritMatrix["Buttock"][21] = {};
	aHackingCritMatrix["Buttock"][22] = {};
	aHackingCritMatrix["Buttock"][23] = {};
	aHackingCritMatrix["Buttock"][24] = {};

	aHackingCritMatrix["Abdomen, Lower"][1] = {};
	aHackingCritMatrix["Abdomen, Lower"][2] = {};
	aHackingCritMatrix["Abdomen, Lower"][3] = {};
	aHackingCritMatrix["Abdomen, Lower"][4] = {};
	aHackingCritMatrix["Abdomen, Lower"][5] = {};
	aHackingCritMatrix["Abdomen, Lower"][6] = {};
	aHackingCritMatrix["Abdomen, Lower"][7] = {};
	aHackingCritMatrix["Abdomen, Lower"][8] = {};
	aHackingCritMatrix["Abdomen, Lower"][9] = {};
	aHackingCritMatrix["Abdomen, Lower"][10] = {};
	aHackingCritMatrix["Abdomen, Lower"][11] = {};
	aHackingCritMatrix["Abdomen, Lower"][12] = {};
	aHackingCritMatrix["Abdomen, Lower"][13] = {};
	aHackingCritMatrix["Abdomen, Lower"][14] = {};
	aHackingCritMatrix["Abdomen, Lower"][15] = {};
	aHackingCritMatrix["Abdomen, Lower"][16] = {};
	aHackingCritMatrix["Abdomen, Lower"][17] = {};
	aHackingCritMatrix["Abdomen, Lower"][18] = {};
	aHackingCritMatrix["Abdomen, Lower"][19] = {};
	aHackingCritMatrix["Abdomen, Lower"][20] = {};
	aHackingCritMatrix["Abdomen, Lower"][21] = {};
	aHackingCritMatrix["Abdomen, Lower"][22] = {};
	aHackingCritMatrix["Abdomen, Lower"][23] = {};
	aHackingCritMatrix["Abdomen, Lower"][24] = {};

	aHackingCritMatrix["Side, lower"][1] = {};
	aHackingCritMatrix["Side, lower"][2] = {};
	aHackingCritMatrix["Side, lower"][3] = {};
	aHackingCritMatrix["Side, lower"][4] = {};
	aHackingCritMatrix["Side, lower"][5] = {};
	aHackingCritMatrix["Side, lower"][6] = {};
	aHackingCritMatrix["Side, lower"][7] = {};
	aHackingCritMatrix["Side, lower"][8] = {};
	aHackingCritMatrix["Side, lower"][9] = {};
	aHackingCritMatrix["Side, lower"][10] = {};
	aHackingCritMatrix["Side, lower"][11] = {};
	aHackingCritMatrix["Side, lower"][12] = {};
	aHackingCritMatrix["Side, lower"][13] = {};
	aHackingCritMatrix["Side, lower"][14] = {};
	aHackingCritMatrix["Side, lower"][15] = {};
	aHackingCritMatrix["Side, lower"][16] = {};
	aHackingCritMatrix["Side, lower"][17] = {};
	aHackingCritMatrix["Side, lower"][18] = {};
	aHackingCritMatrix["Side, lower"][19] = {};
	aHackingCritMatrix["Side, lower"][20] = {};
	aHackingCritMatrix["Side, lower"][21] = {};
	aHackingCritMatrix["Side, lower"][22] = {};
	aHackingCritMatrix["Side, lower"][23] = {};
	aHackingCritMatrix["Side, lower"][24] = {};
	
	aHackingCritMatrix["Abdomen, upper"][1] = {};
	aHackingCritMatrix["Abdomen, upper"][2] = {};
	aHackingCritMatrix["Abdomen, upper"][3] = {};
	aHackingCritMatrix["Abdomen, upper"][4] = {};
	aHackingCritMatrix["Abdomen, upper"][5] = {};
	aHackingCritMatrix["Abdomen, upper"][6] = {};
	aHackingCritMatrix["Abdomen, upper"][7] = {};
	aHackingCritMatrix["Abdomen, upper"][8] = {};
	aHackingCritMatrix["Abdomen, upper"][9] = {};
	aHackingCritMatrix["Abdomen, upper"][10] = {};
	aHackingCritMatrix["Abdomen, upper"][11] = {};
	aHackingCritMatrix["Abdomen, upper"][12] = {};
	aHackingCritMatrix["Abdomen, upper"][13] = {};
	aHackingCritMatrix["Abdomen, upper"][14] = {};
	aHackingCritMatrix["Abdomen, upper"][15] = {};
	aHackingCritMatrix["Abdomen, upper"][16] = {};
	aHackingCritMatrix["Abdomen, upper"][17] = {};
	aHackingCritMatrix["Abdomen, upper"][18] = {};
	aHackingCritMatrix["Abdomen, upper"][19] = {};
	aHackingCritMatrix["Abdomen, upper"][20] = {};
	aHackingCritMatrix["Abdomen, upper"][21] = {};
	aHackingCritMatrix["Abdomen, upper"][22] = {};
	aHackingCritMatrix["Abdomen, upper"][23] = {};
	aHackingCritMatrix["Abdomen, upper"][24] = {};

	aHackingCritMatrix["Back, small of"][1] = {};
	aHackingCritMatrix["Back, small of"][2] = {};
	aHackingCritMatrix["Back, small of"][3] = {};
	aHackingCritMatrix["Back, small of"][4] = {};
	aHackingCritMatrix["Back, small of"][5] = {};
	aHackingCritMatrix["Back, small of"][6] = {};
	aHackingCritMatrix["Back, small of"][7] = {};
	aHackingCritMatrix["Back, small of"][8] = {};
	aHackingCritMatrix["Back, small of"][9] = {};
	aHackingCritMatrix["Back, small of"][10] = {};
	aHackingCritMatrix["Back, small of"][11] = {};
	aHackingCritMatrix["Back, small of"][12] = {};
	aHackingCritMatrix["Back, small of"][13] = {};
	aHackingCritMatrix["Back, small of"][14] = {};
	aHackingCritMatrix["Back, small of"][15] = {};
	aHackingCritMatrix["Back, small of"][16] = {};
	aHackingCritMatrix["Back, small of"][17] = {};
	aHackingCritMatrix["Back, small of"][18] = {};
	aHackingCritMatrix["Back, small of"][19] = {};
	aHackingCritMatrix["Back, small of"][20] = {};
	aHackingCritMatrix["Back, small of"][21] = {};
	aHackingCritMatrix["Back, small of"][22] = {};
	aHackingCritMatrix["Back, small of"][23] = {};
	aHackingCritMatrix["Back, small of"][24] = {};

	aHackingCritMatrix["Back, lower"][1] = {};
	aHackingCritMatrix["Back, lower"][2] = {};
	aHackingCritMatrix["Back, lower"][3] = {};
	aHackingCritMatrix["Back, lower"][4] = {};
	aHackingCritMatrix["Back, lower"][5] = {};
	aHackingCritMatrix["Back, lower"][6] = {};
	aHackingCritMatrix["Back, lower"][7] = {};
	aHackingCritMatrix["Back, lower"][8] = {};
	aHackingCritMatrix["Back, lower"][9] = {};
	aHackingCritMatrix["Back, lower"][10] = {};
	aHackingCritMatrix["Back, lower"][11] = {};
	aHackingCritMatrix["Back, lower"][12] = {};
	aHackingCritMatrix["Back, lower"][13] = {};
	aHackingCritMatrix["Back, lower"][14] = {};
	aHackingCritMatrix["Back, lower"][15] = {};
	aHackingCritMatrix["Back, lower"][16] = {};
	aHackingCritMatrix["Back, lower"][17] = {};
	aHackingCritMatrix["Back, lower"][18] = {};
	aHackingCritMatrix["Back, lower"][19] = {};
	aHackingCritMatrix["Back, lower"][20] = {};
	aHackingCritMatrix["Back, lower"][21] = {};
	aHackingCritMatrix["Back, lower"][22] = {};
	aHackingCritMatrix["Back, lower"][23] = {};
	aHackingCritMatrix["Back, lower"][24] = {};

	aHackingCritMatrix["Chest"][1] = {};
	aHackingCritMatrix["Chest"][2] = {};
	aHackingCritMatrix["Chest"][3] = {};
	aHackingCritMatrix["Chest"][4] = {};
	aHackingCritMatrix["Chest"][5] = {};
	aHackingCritMatrix["Chest"][6] = {};
	aHackingCritMatrix["Chest"][7] = {};
	aHackingCritMatrix["Chest"][8] = {};
	aHackingCritMatrix["Chest"][9] = {};
	aHackingCritMatrix["Chest"][10] = {};
	aHackingCritMatrix["Chest"][11] = {};
	aHackingCritMatrix["Chest"][12] = {};
	aHackingCritMatrix["Chest"][13] = {};
	aHackingCritMatrix["Chest"][14] = {};
	aHackingCritMatrix["Chest"][15] = {};
	aHackingCritMatrix["Chest"][16] = {};
	aHackingCritMatrix["Chest"][17] = {};
	aHackingCritMatrix["Chest"][18] = {};
	aHackingCritMatrix["Chest"][19] = {};
	aHackingCritMatrix["Chest"][20] = {};
	aHackingCritMatrix["Chest"][21] = {};
	aHackingCritMatrix["Chest"][22] = {};
	aHackingCritMatrix["Chest"][23] = {};
	aHackingCritMatrix["Chest"][24] = {};
	
	aHackingCritMatrix["Side, upper"][1] = {};
	aHackingCritMatrix["Side, upper"][2] = {};
	aHackingCritMatrix["Side, upper"][3] = {};
	aHackingCritMatrix["Side, upper"][4] = {};
	aHackingCritMatrix["Side, upper"][5] = {};
	aHackingCritMatrix["Side, upper"][6] = {};
	aHackingCritMatrix["Side, upper"][7] = {};
	aHackingCritMatrix["Side, upper"][8] = {};
	aHackingCritMatrix["Side, upper"][9] = {};
	aHackingCritMatrix["Side, upper"][10] = {};
	aHackingCritMatrix["Side, upper"][11] = {};
	aHackingCritMatrix["Side, upper"][12] = {};
	aHackingCritMatrix["Side, upper"][13] = {};
	aHackingCritMatrix["Side, upper"][14] = {};
	aHackingCritMatrix["Side, upper"][15] = {};
	aHackingCritMatrix["Side, upper"][16] = {};
	aHackingCritMatrix["Side, upper"][17] = {};
	aHackingCritMatrix["Side, upper"][18] = {};
	aHackingCritMatrix["Side, upper"][19] = {};
	aHackingCritMatrix["Side, upper"][20] = {};
	aHackingCritMatrix["Side, upper"][21] = {};
	aHackingCritMatrix["Side, upper"][22] = {};
	aHackingCritMatrix["Side, upper"][23] = {};
	aHackingCritMatrix["Side, upper"][24] = {};
	
	aHackingCritMatrix["Back, upper"][1] = {};
	aHackingCritMatrix["Back, upper"][2] = {};
	aHackingCritMatrix["Back, upper"][3] = {};
	aHackingCritMatrix["Back, upper"][4] = {};
	aHackingCritMatrix["Back, upper"][5] = {};
	aHackingCritMatrix["Back, upper"][6] = {};
	aHackingCritMatrix["Back, upper"][7] = {};
	aHackingCritMatrix["Back, upper"][8] = {};
	aHackingCritMatrix["Back, upper"][9] = {};
	aHackingCritMatrix["Back, upper"][10] = {};
	aHackingCritMatrix["Back, upper"][11] = {};
	aHackingCritMatrix["Back, upper"][12] = {};
	aHackingCritMatrix["Back, upper"][13] = {};
	aHackingCritMatrix["Back, upper"][14] = {};
	aHackingCritMatrix["Back, upper"][15] = {};
	aHackingCritMatrix["Back, upper"][16] = {};
	aHackingCritMatrix["Back, upper"][17] = {};
	aHackingCritMatrix["Back, upper"][18] = {};
	aHackingCritMatrix["Back, upper"][19] = {};
	aHackingCritMatrix["Back, upper"][20] = {};
	aHackingCritMatrix["Back, upper"][21] = {};
	aHackingCritMatrix["Back, upper"][22] = {};
	aHackingCritMatrix["Back, upper"][23] = {};
	aHackingCritMatrix["Back, upper"][24] = {};
	
	aHackingCritMatrix["Back, upper middle"][1] = {};
	aHackingCritMatrix["Back, upper middle"][2] = {};
	aHackingCritMatrix["Back, upper middle"][3] = {};
	aHackingCritMatrix["Back, upper middle"][4] = {};
	aHackingCritMatrix["Back, upper middle"][5] = {};
	aHackingCritMatrix["Back, upper middle"][6] = {};
	aHackingCritMatrix["Back, upper middle"][7] = {};
	aHackingCritMatrix["Back, upper middle"][8] = {};
	aHackingCritMatrix["Back, upper middle"][9] = {};
	aHackingCritMatrix["Back, upper middle"][10] = {};
	aHackingCritMatrix["Back, upper middle"][11] = {};
	aHackingCritMatrix["Back, upper middle"][12] = {};
	aHackingCritMatrix["Back, upper middle"][13] = {};
	aHackingCritMatrix["Back, upper middle"][14] = {};
	aHackingCritMatrix["Back, upper middle"][15] = {};
	aHackingCritMatrix["Back, upper middle"][16] = {};
	aHackingCritMatrix["Back, upper middle"][17] = {};
	aHackingCritMatrix["Back, upper middle"][18] = {};
	aHackingCritMatrix["Back, upper middle"][19] = {};
	aHackingCritMatrix["Back, upper middle"][20] = {};
	aHackingCritMatrix["Back, upper middle"][21] = {};
	aHackingCritMatrix["Back, upper middle"][22] = {};
	aHackingCritMatrix["Back, upper middle"][23] = {};
	aHackingCritMatrix["Back, upper middle"][24] = {};
	
	aHackingCritMatrix["Armpit"][1] = {};
	aHackingCritMatrix["Armpit"][2] = {};
	aHackingCritMatrix["Armpit"][3] = {};
	aHackingCritMatrix["Armpit"][4] = {};
	aHackingCritMatrix["Armpit"][5] = {};
	aHackingCritMatrix["Armpit"][6] = {};
	aHackingCritMatrix["Armpit"][7] = {};
	aHackingCritMatrix["Armpit"][8] = {};
	aHackingCritMatrix["Armpit"][9] = {};
	aHackingCritMatrix["Armpit"][10] = {};
	aHackingCritMatrix["Armpit"][11] = {};
	aHackingCritMatrix["Armpit"][12] = {};
	aHackingCritMatrix["Armpit"][13] = {};
	aHackingCritMatrix["Armpit"][14] = {};
	aHackingCritMatrix["Armpit"][15] = {};
	aHackingCritMatrix["Armpit"][16] = {};
	aHackingCritMatrix["Armpit"][17] = {};
	aHackingCritMatrix["Armpit"][18] = {};
	aHackingCritMatrix["Armpit"][19] = {};
	aHackingCritMatrix["Armpit"][20] = {};
	aHackingCritMatrix["Armpit"][21] = {};
	aHackingCritMatrix["Armpit"][22] = {};
	aHackingCritMatrix["Armpit"][23] = {};
	aHackingCritMatrix["Armpit"][24] = {};
	
	aHackingCritMatrix["Arm, upper outer"][1] = {};
	aHackingCritMatrix["Arm, upper outer"][2] = {};
	aHackingCritMatrix["Arm, upper outer"][3] = {};
	aHackingCritMatrix["Arm, upper outer"][4] = {};
	aHackingCritMatrix["Arm, upper outer"][5] = {};
	aHackingCritMatrix["Arm, upper outer"][6] = {};
	aHackingCritMatrix["Arm, upper outer"][7] = {};
	aHackingCritMatrix["Arm, upper outer"][8] = {};
	aHackingCritMatrix["Arm, upper outer"][9] = {};
	aHackingCritMatrix["Arm, upper outer"][10] = {};
	aHackingCritMatrix["Arm, upper outer"][11] = {};
	aHackingCritMatrix["Arm, upper outer"][12] = {};
	aHackingCritMatrix["Arm, upper outer"][13] = {};
	aHackingCritMatrix["Arm, upper outer"][14] = {};
	aHackingCritMatrix["Arm, upper outer"][15] = {};
	aHackingCritMatrix["Arm, upper outer"][16] = {};
	aHackingCritMatrix["Arm, upper outer"][17] = {};
	aHackingCritMatrix["Arm, upper outer"][18] = {};
	aHackingCritMatrix["Arm, upper outer"][19] = {};
	aHackingCritMatrix["Arm, upper outer"][20] = {};
	aHackingCritMatrix["Arm, upper outer"][21] = {};
	aHackingCritMatrix["Arm, upper outer"][22] = {};
	aHackingCritMatrix["Arm, upper outer"][23] = {};
	aHackingCritMatrix["Arm, upper outer"][24] = {};
	
	aHackingCritMatrix["Arm, upper inner"][1] = {};
	aHackingCritMatrix["Arm, upper inner"][2] = {};
	aHackingCritMatrix["Arm, upper inner"][3] = {};
	aHackingCritMatrix["Arm, upper inner"][4] = {};
	aHackingCritMatrix["Arm, upper inner"][5] = {};
	aHackingCritMatrix["Arm, upper inner"][6] = {};
	aHackingCritMatrix["Arm, upper inner"][7] = {};
	aHackingCritMatrix["Arm, upper inner"][8] = {};
	aHackingCritMatrix["Arm, upper inner"][9] = {};
	aHackingCritMatrix["Arm, upper inner"][10] = {};
	aHackingCritMatrix["Arm, upper inner"][11] = {};
	aHackingCritMatrix["Arm, upper inner"][12] = {};
	aHackingCritMatrix["Arm, upper inner"][13] = {};
	aHackingCritMatrix["Arm, upper inner"][14] = {};
	aHackingCritMatrix["Arm, upper inner"][15] = {};
	aHackingCritMatrix["Arm, upper inner"][16] = {};
	aHackingCritMatrix["Arm, upper inner"][17] = {};
	aHackingCritMatrix["Arm, upper inner"][18] = {};
	aHackingCritMatrix["Arm, upper inner"][19] = {};
	aHackingCritMatrix["Arm, upper inner"][20] = {};
	aHackingCritMatrix["Arm, upper inner"][21] = {};
	aHackingCritMatrix["Arm, upper inner"][22] = {};
	aHackingCritMatrix["Arm, upper inner"][23] = {};
	aHackingCritMatrix["Arm, upper inner"][24] = {};
	
	aHackingCritMatrix["Elbow"][1] = {};
	aHackingCritMatrix["Elbow"][2] = {};
	aHackingCritMatrix["Elbow"][3] = {};
	aHackingCritMatrix["Elbow"][4] = {};
	aHackingCritMatrix["Elbow"][5] = {};
	aHackingCritMatrix["Elbow"][6] = {};
	aHackingCritMatrix["Elbow"][7] = {};
	aHackingCritMatrix["Elbow"][8] = {};
	aHackingCritMatrix["Elbow"][9] = {};
	aHackingCritMatrix["Elbow"][10] = {};
	aHackingCritMatrix["Elbow"][11] = {};
	aHackingCritMatrix["Elbow"][12] = {};
	aHackingCritMatrix["Elbow"][13] = {};
	aHackingCritMatrix["Elbow"][14] = {};
	aHackingCritMatrix["Elbow"][15] = {};
	aHackingCritMatrix["Elbow"][16] = {};
	aHackingCritMatrix["Elbow"][17] = {};
	aHackingCritMatrix["Elbow"][18] = {};
	aHackingCritMatrix["Elbow"][19] = {};
	aHackingCritMatrix["Elbow"][20] = {};
	aHackingCritMatrix["Elbow"][21] = {};
	aHackingCritMatrix["Elbow"][22] = {};
	aHackingCritMatrix["Elbow"][23] = {};
	aHackingCritMatrix["Elbow"][24] = {};
	
	aHackingCritMatrix["Inner joint"][1] = {};
	aHackingCritMatrix["Inner joint"][2] = {};
	aHackingCritMatrix["Inner joint"][3] = {};
	aHackingCritMatrix["Inner joint"][4] = {};
	aHackingCritMatrix["Inner joint"][5] = {};
	aHackingCritMatrix["Inner joint"][6] = {};
	aHackingCritMatrix["Inner joint"][7] = {};
	aHackingCritMatrix["Inner joint"][8] = {};
	aHackingCritMatrix["Inner joint"][9] = {};
	aHackingCritMatrix["Inner joint"][10] = {};
	aHackingCritMatrix["Inner joint"][11] = {};
	aHackingCritMatrix["Inner joint"][12] = {};
	aHackingCritMatrix["Inner joint"][13] = {};
	aHackingCritMatrix["Inner joint"][14] = {};
	aHackingCritMatrix["Inner joint"][15] = {};
	aHackingCritMatrix["Inner joint"][16] = {};
	aHackingCritMatrix["Inner joint"][17] = {};
	aHackingCritMatrix["Inner joint"][18] = {};
	aHackingCritMatrix["Inner joint"][19] = {};
	aHackingCritMatrix["Inner joint"][20] = {};
	aHackingCritMatrix["Inner joint"][21] = {};
	aHackingCritMatrix["Inner joint"][22] = {};
	aHackingCritMatrix["Inner joint"][23] = {};
	aHackingCritMatrix["Inner joint"][24] = {};
	
	aHackingCritMatrix["Forearm, back"][1] = {};
	aHackingCritMatrix["Forearm, back"][2] = {};
	aHackingCritMatrix["Forearm, back"][3] = {};
	aHackingCritMatrix["Forearm, back"][4] = {};
	aHackingCritMatrix["Forearm, back"][5] = {};
	aHackingCritMatrix["Forearm, back"][6] = {};
	aHackingCritMatrix["Forearm, back"][7] = {};
	aHackingCritMatrix["Forearm, back"][8] = {};
	aHackingCritMatrix["Forearm, back"][9] = {};
	aHackingCritMatrix["Forearm, back"][10] = {};
	aHackingCritMatrix["Forearm, back"][11] = {};
	aHackingCritMatrix["Forearm, back"][12] = {};
	aHackingCritMatrix["Forearm, back"][13] = {};
	aHackingCritMatrix["Forearm, back"][14] = {};
	aHackingCritMatrix["Forearm, back"][15] = {};
	aHackingCritMatrix["Forearm, back"][16] = {};
	aHackingCritMatrix["Forearm, back"][17] = {};
	aHackingCritMatrix["Forearm, back"][18] = {};
	aHackingCritMatrix["Forearm, back"][19] = {};
	aHackingCritMatrix["Forearm, back"][20] = {};
	aHackingCritMatrix["Forearm, back"][21] = {};
	aHackingCritMatrix["Forearm, back"][22] = {};
	aHackingCritMatrix["Forearm, back"][23] = {};
	aHackingCritMatrix["Forearm, back"][24] = {};
	
	aHackingCritMatrix["Forearm, inner"][1] = {};
	aHackingCritMatrix["Forearm, inner"][2] = {};
	aHackingCritMatrix["Forearm, inner"][3] = {};
	aHackingCritMatrix["Forearm, inner"][4] = {};
	aHackingCritMatrix["Forearm, inner"][5] = {};
	aHackingCritMatrix["Forearm, inner"][6] = {};
	aHackingCritMatrix["Forearm, inner"][7] = {};
	aHackingCritMatrix["Forearm, inner"][8] = {};
	aHackingCritMatrix["Forearm, inner"][9] = {};
	aHackingCritMatrix["Forearm, inner"][10] = {};
	aHackingCritMatrix["Forearm, inner"][11] = {};
	aHackingCritMatrix["Forearm, inner"][12] = {};
	aHackingCritMatrix["Forearm, inner"][13] = {};
	aHackingCritMatrix["Forearm, inner"][14] = {};
	aHackingCritMatrix["Forearm, inner"][15] = {};
	aHackingCritMatrix["Forearm, inner"][16] = {};
	aHackingCritMatrix["Forearm, inner"][17] = {};
	aHackingCritMatrix["Forearm, inner"][18] = {};
	aHackingCritMatrix["Forearm, inner"][19] = {};
	aHackingCritMatrix["Forearm, inner"][20] = {};
	aHackingCritMatrix["Forearm, inner"][21] = {};
	aHackingCritMatrix["Forearm, inner"][22] = {};
	aHackingCritMatrix["Forearm, inner"][23] = {};
	aHackingCritMatrix["Forearm, inner"][24] = {};
	
	aHackingCritMatrix["Wrist, back"][1] = {};
	aHackingCritMatrix["Wrist, back"][2] = {};
	aHackingCritMatrix["Wrist, back"][3] = {};
	aHackingCritMatrix["Wrist, back"][4] = {};
	aHackingCritMatrix["Wrist, back"][5] = {};
	aHackingCritMatrix["Wrist, back"][6] = {};
	aHackingCritMatrix["Wrist, back"][7] = {};
	aHackingCritMatrix["Wrist, back"][8] = {};
	aHackingCritMatrix["Wrist, back"][9] = {};
	aHackingCritMatrix["Wrist, back"][10] = {};
	aHackingCritMatrix["Wrist, back"][11] = {};
	aHackingCritMatrix["Wrist, back"][12] = {};
	aHackingCritMatrix["Wrist, back"][13] = {};
	aHackingCritMatrix["Wrist, back"][14] = {};
	aHackingCritMatrix["Wrist, back"][15] = {};
	aHackingCritMatrix["Wrist, back"][16] = {};
	aHackingCritMatrix["Wrist, back"][17] = {};
	aHackingCritMatrix["Wrist, back"][18] = {};
	aHackingCritMatrix["Wrist, back"][19] = {};
	aHackingCritMatrix["Wrist, back"][20] = {};
	aHackingCritMatrix["Wrist, back"][21] = {};
	aHackingCritMatrix["Wrist, back"][22] = {};
	aHackingCritMatrix["Wrist, back"][23] = {};
	aHackingCritMatrix["Wrist, back"][24] = {};
	
	aHackingCritMatrix["Wrist, front"][1] = {};
	aHackingCritMatrix["Wrist, front"][2] = {};
	aHackingCritMatrix["Wrist, front"][3] = {};
	aHackingCritMatrix["Wrist, front"][4] = {};
	aHackingCritMatrix["Wrist, front"][5] = {};
	aHackingCritMatrix["Wrist, front"][6] = {};
	aHackingCritMatrix["Wrist, front"][7] = {};
	aHackingCritMatrix["Wrist, front"][8] = {};
	aHackingCritMatrix["Wrist, front"][9] = {};
	aHackingCritMatrix["Wrist, front"][10] = {};
	aHackingCritMatrix["Wrist, front"][11] = {};
	aHackingCritMatrix["Wrist, front"][12] = {};
	aHackingCritMatrix["Wrist, front"][13] = {};
	aHackingCritMatrix["Wrist, front"][14] = {};
	aHackingCritMatrix["Wrist, front"][15] = {};
	aHackingCritMatrix["Wrist, front"][16] = {};
	aHackingCritMatrix["Wrist, front"][17] = {};
	aHackingCritMatrix["Wrist, front"][18] = {};
	aHackingCritMatrix["Wrist, front"][19] = {};
	aHackingCritMatrix["Wrist, front"][20] = {};
	aHackingCritMatrix["Wrist, front"][21] = {};
	aHackingCritMatrix["Wrist, front"][22] = {};
	aHackingCritMatrix["Wrist, front"][23] = {};
	aHackingCritMatrix["Wrist, front"][24] = {};

	aHackingCritMatrix["Hand, back"][1] = {};
	aHackingCritMatrix["Hand, back"][2] = {};
	aHackingCritMatrix["Hand, back"][3] = {};
	aHackingCritMatrix["Hand, back"][4] = {};
	aHackingCritMatrix["Hand, back"][5] = {};
	aHackingCritMatrix["Hand, back"][6] = {};
	aHackingCritMatrix["Hand, back"][7] = {};
	aHackingCritMatrix["Hand, back"][8] = {};
	aHackingCritMatrix["Hand, back"][9] = {};
	aHackingCritMatrix["Hand, back"][10] = {};
	aHackingCritMatrix["Hand, back"][11] = {};
	aHackingCritMatrix["Hand, back"][12] = {};
	aHackingCritMatrix["Hand, back"][13] = {};
	aHackingCritMatrix["Hand, back"][14] = {};
	aHackingCritMatrix["Hand, back"][15] = {};
	aHackingCritMatrix["Hand, back"][16] = {};
	aHackingCritMatrix["Hand, back"][17] = {};
	aHackingCritMatrix["Hand, back"][18] = {};
	aHackingCritMatrix["Hand, back"][19] = {};
	aHackingCritMatrix["Hand, back"][20] = {};
	aHackingCritMatrix["Hand, back"][21] = {};
	aHackingCritMatrix["Hand, back"][22] = {};
	aHackingCritMatrix["Hand, back"][23] = {};
	aHackingCritMatrix["Hand, back"][24] = {};
	
	aHackingCritMatrix["Palm"][1] = {};
	aHackingCritMatrix["Palm"][2] = {};
	aHackingCritMatrix["Palm"][3] = {};
	aHackingCritMatrix["Palm"][4] = {};
	aHackingCritMatrix["Palm"][5] = {};
	aHackingCritMatrix["Palm"][6] = {};
	aHackingCritMatrix["Palm"][7] = {};
	aHackingCritMatrix["Palm"][8] = {};
	aHackingCritMatrix["Palm"][9] = {};
	aHackingCritMatrix["Palm"][10] = {};
	aHackingCritMatrix["Palm"][11] = {};
	aHackingCritMatrix["Palm"][12] = {};
	aHackingCritMatrix["Palm"][13] = {};
	aHackingCritMatrix["Palm"][14] = {};
	aHackingCritMatrix["Palm"][15] = {};
	aHackingCritMatrix["Palm"][16] = {};
	aHackingCritMatrix["Palm"][17] = {};
	aHackingCritMatrix["Palm"][18] = {};
	aHackingCritMatrix["Palm"][19] = {};
	aHackingCritMatrix["Palm"][20] = {};
	aHackingCritMatrix["Palm"][21] = {};
	aHackingCritMatrix["Palm"][22] = {};
	aHackingCritMatrix["Palm"][23] = {};
	aHackingCritMatrix["Palm"][24] = {};
	
	aHackingCritMatrix["Finger(s)"][1] = {};
	aHackingCritMatrix["Finger(s)"][2] = {};
	aHackingCritMatrix["Finger(s)"][3] = {};
	aHackingCritMatrix["Finger(s)"][4] = {};
	aHackingCritMatrix["Finger(s)"][5] = {};
	aHackingCritMatrix["Finger(s)"][6] = {};
	aHackingCritMatrix["Finger(s)"][7] = {};
	aHackingCritMatrix["Finger(s)"][8] = {};
	aHackingCritMatrix["Finger(s)"][9] = {};
	aHackingCritMatrix["Finger(s)"][10] = {};
	aHackingCritMatrix["Finger(s)"][11] = {};
	aHackingCritMatrix["Finger(s)"][12] = {};
	aHackingCritMatrix["Finger(s)"][13] = {};
	aHackingCritMatrix["Finger(s)"][14] = {};
	aHackingCritMatrix["Finger(s)"][15] = {};
	aHackingCritMatrix["Finger(s)"][16] = {};
	aHackingCritMatrix["Finger(s)"][17] = {};
	aHackingCritMatrix["Finger(s)"][18] = {};
	aHackingCritMatrix["Finger(s)"][19] = {};
	aHackingCritMatrix["Finger(s)"][20] = {};
	aHackingCritMatrix["Finger(s)"][21] = {};
	aHackingCritMatrix["Finger(s)"][22] = {};
	aHackingCritMatrix["Finger(s)"][23] = {};
	aHackingCritMatrix["Finger(s)"][24] = {};

	aHackingCritMatrix["Shoulder, side"][1] = {};
	aHackingCritMatrix["Shoulder, side"][2] = {};
	aHackingCritMatrix["Shoulder, side"][3] = {};
	aHackingCritMatrix["Shoulder, side"][4] = {};
	aHackingCritMatrix["Shoulder, side"][5] = {};
	aHackingCritMatrix["Shoulder, side"][6] = {};
	aHackingCritMatrix["Shoulder, side"][7] = {};
	aHackingCritMatrix["Shoulder, side"][8] = {};
	aHackingCritMatrix["Shoulder, side"][9] = {};
	aHackingCritMatrix["Shoulder, side"][10] = {};
	aHackingCritMatrix["Shoulder, side"][11] = {};
	aHackingCritMatrix["Shoulder, side"][12] = {};
	aHackingCritMatrix["Shoulder, side"][13] = {};
	aHackingCritMatrix["Shoulder, side"][14] = {};
	aHackingCritMatrix["Shoulder, side"][15] = {};
	aHackingCritMatrix["Shoulder, side"][16] = {};
	aHackingCritMatrix["Shoulder, side"][17] = {};
	aHackingCritMatrix["Shoulder, side"][18] = {};
	aHackingCritMatrix["Shoulder, side"][19] = {};
	aHackingCritMatrix["Shoulder, side"][20] = {};
	aHackingCritMatrix["Shoulder, side"][21] = {};
	aHackingCritMatrix["Shoulder, side"][22] = {};
	aHackingCritMatrix["Shoulder, side"][23] = {};
	aHackingCritMatrix["Shoulder, side"][24] = {};
	
	aHackingCritMatrix["Shoulder, top"][1] = {};
	aHackingCritMatrix["Shoulder, top"][2] = {};
	aHackingCritMatrix["Shoulder, top"][3] = {};
	aHackingCritMatrix["Shoulder, top"][4] = {};
	aHackingCritMatrix["Shoulder, top"][5] = {};
	aHackingCritMatrix["Shoulder, top"][6] = {};
	aHackingCritMatrix["Shoulder, top"][7] = {};
	aHackingCritMatrix["Shoulder, top"][8] = {};
	aHackingCritMatrix["Shoulder, top"][9] = {};
	aHackingCritMatrix["Shoulder, top"][10] = {};
	aHackingCritMatrix["Shoulder, top"][11] = {};
	aHackingCritMatrix["Shoulder, top"][12] = {};
	aHackingCritMatrix["Shoulder, top"][13] = {};
	aHackingCritMatrix["Shoulder, top"][14] = {};
	aHackingCritMatrix["Shoulder, top"][15] = {};
	aHackingCritMatrix["Shoulder, top"][16] = {};
	aHackingCritMatrix["Shoulder, top"][17] = {};
	aHackingCritMatrix["Shoulder, top"][18] = {};
	aHackingCritMatrix["Shoulder, top"][19] = {};
	aHackingCritMatrix["Shoulder, top"][20] = {};
	aHackingCritMatrix["Shoulder, top"][21] = {};
	aHackingCritMatrix["Shoulder, top"][22] = {};
	aHackingCritMatrix["Shoulder, top"][23] = {};
	aHackingCritMatrix["Shoulder, top"][24] = {};
	
	aHackingCritMatrix["Neck, back"][1] = {};
	aHackingCritMatrix["Neck, back"][2] = {};
	aHackingCritMatrix["Neck, back"][3] = {};
	aHackingCritMatrix["Neck, back"][4] = {};
	aHackingCritMatrix["Neck, back"][5] = {};
	aHackingCritMatrix["Neck, back"][6] = {};
	aHackingCritMatrix["Neck, back"][7] = {};
	aHackingCritMatrix["Neck, back"][8] = {};
	aHackingCritMatrix["Neck, back"][9] = {};
	aHackingCritMatrix["Neck, back"][10] = {};
	aHackingCritMatrix["Neck, back"][11] = {};
	aHackingCritMatrix["Neck, back"][12] = {};
	aHackingCritMatrix["Neck, back"][13] = {};
	aHackingCritMatrix["Neck, back"][14] = {};
	aHackingCritMatrix["Neck, back"][15] = {};
	aHackingCritMatrix["Neck, back"][16] = {};
	aHackingCritMatrix["Neck, back"][17] = {};
	aHackingCritMatrix["Neck, back"][18] = {};
	aHackingCritMatrix["Neck, back"][19] = {};
	aHackingCritMatrix["Neck, back"][20] = {};
	aHackingCritMatrix["Neck, back"][21] = {};
	aHackingCritMatrix["Neck, back"][22] = {};
	aHackingCritMatrix["Neck, back"][23] = {};
	aHackingCritMatrix["Neck, back"][24] = {};
	
	aHackingCritMatrix["Neck, back"][1] = {};
	aHackingCritMatrix["Neck, back"][2] = {};
	aHackingCritMatrix["Neck, back"][3] = {};
	aHackingCritMatrix["Neck, back"][4] = {};
	aHackingCritMatrix["Neck, back"][5] = {};
	aHackingCritMatrix["Neck, back"][6] = {};
	aHackingCritMatrix["Neck, back"][7] = {};
	aHackingCritMatrix["Neck, back"][8] = {};
	aHackingCritMatrix["Neck, back"][9] = {};
	aHackingCritMatrix["Neck, back"][10] = {};
	aHackingCritMatrix["Neck, back"][11] = {};
	aHackingCritMatrix["Neck, back"][12] = {};
	aHackingCritMatrix["Neck, back"][13] = {};
	aHackingCritMatrix["Neck, back"][14] = {};
	aHackingCritMatrix["Neck, back"][15] = {};
	aHackingCritMatrix["Neck, back"][16] = {};
	aHackingCritMatrix["Neck, back"][17] = {};
	aHackingCritMatrix["Neck, back"][18] = {};
	aHackingCritMatrix["Neck, back"][19] = {};
	aHackingCritMatrix["Neck, back"][20] = {};
	aHackingCritMatrix["Neck, back"][21] = {};
	aHackingCritMatrix["Neck, back"][22] = {};
	aHackingCritMatrix["Neck, back"][23] = {};
	aHackingCritMatrix["Neck, back"][24] = {};
	
	aHackingCritMatrix["Neck, side"][1] = {};
	aHackingCritMatrix["Neck, side"][2] = {};
	aHackingCritMatrix["Neck, side"][3] = {};
	aHackingCritMatrix["Neck, side"][4] = {};
	aHackingCritMatrix["Neck, side"][5] = {};
	aHackingCritMatrix["Neck, side"][6] = {};
	aHackingCritMatrix["Neck, side"][7] = {};
	aHackingCritMatrix["Neck, side"][8] = {};
	aHackingCritMatrix["Neck, side"][9] = {};
	aHackingCritMatrix["Neck, side"][10] = {};
	aHackingCritMatrix["Neck, side"][11] = {};
	aHackingCritMatrix["Neck, side"][12] = {};
	aHackingCritMatrix["Neck, side"][13] = {};
	aHackingCritMatrix["Neck, side"][14] = {};
	aHackingCritMatrix["Neck, side"][15] = {};
	aHackingCritMatrix["Neck, side"][16] = {};
	aHackingCritMatrix["Neck, side"][17] = {};
	aHackingCritMatrix["Neck, side"][18] = {};
	aHackingCritMatrix["Neck, side"][19] = {};
	aHackingCritMatrix["Neck, side"][20] = {};
	aHackingCritMatrix["Neck, side"][21] = {};
	aHackingCritMatrix["Neck, side"][22] = {};
	aHackingCritMatrix["Neck, side"][23] = {};
	aHackingCritMatrix["Neck, side"][24] = {};

	aHackingCritMatrix["Head, side"][1] = {};
	aHackingCritMatrix["Head, side"][2] = {};
	aHackingCritMatrix["Head, side"][3] = {};
	aHackingCritMatrix["Head, side"][4] = {};
	aHackingCritMatrix["Head, side"][5] = {};
	aHackingCritMatrix["Head, side"][6] = {};
	aHackingCritMatrix["Head, side"][7] = {};
	aHackingCritMatrix["Head, side"][8] = {};
	aHackingCritMatrix["Head, side"][9] = {};
	aHackingCritMatrix["Head, side"][10] = {};
	aHackingCritMatrix["Head, side"][11] = {};
	aHackingCritMatrix["Head, side"][12] = {};
	aHackingCritMatrix["Head, side"][13] = {};
	aHackingCritMatrix["Head, side"][14] = {};
	aHackingCritMatrix["Head, side"][15] = {};
	aHackingCritMatrix["Head, side"][16] = {};
	aHackingCritMatrix["Head, side"][17] = {};
	aHackingCritMatrix["Head, side"][18] = {};
	aHackingCritMatrix["Head, side"][19] = {};
	aHackingCritMatrix["Head, side"][20] = {};
	aHackingCritMatrix["Head, side"][21] = {};
	aHackingCritMatrix["Head, side"][22] = {};
	aHackingCritMatrix["Head, side"][23] = {};
	aHackingCritMatrix["Head, side"][24] = {};
	
	aHackingCritMatrix["Head, back lower"][1] = {};
	aHackingCritMatrix["Head, back lower"][2] = {};
	aHackingCritMatrix["Head, back lower"][3] = {};
	aHackingCritMatrix["Head, back lower"][4] = {};
	aHackingCritMatrix["Head, back lower"][5] = {};
	aHackingCritMatrix["Head, back lower"][6] = {};
	aHackingCritMatrix["Head, back lower"][7] = {};
	aHackingCritMatrix["Head, back lower"][8] = {};
	aHackingCritMatrix["Head, back lower"][9] = {};
	aHackingCritMatrix["Head, back lower"][10] = {};
	aHackingCritMatrix["Head, back lower"][11] = {};
	aHackingCritMatrix["Head, back lower"][12] = {};
	aHackingCritMatrix["Head, back lower"][13] = {};
	aHackingCritMatrix["Head, back lower"][14] = {};
	aHackingCritMatrix["Head, back lower"][15] = {};
	aHackingCritMatrix["Head, back lower"][16] = {};
	aHackingCritMatrix["Head, back lower"][17] = {};
	aHackingCritMatrix["Head, back lower"][18] = {};
	aHackingCritMatrix["Head, back lower"][19] = {};
	aHackingCritMatrix["Head, back lower"][20] = {};
	aHackingCritMatrix["Head, back lower"][21] = {};
	aHackingCritMatrix["Head, back lower"][22] = {};
	aHackingCritMatrix["Head, back lower"][23] = {};
	aHackingCritMatrix["Head, back lower"][24] = {};
	
	aHackingCritMatrix["Face, lower side"][1] = {};
	aHackingCritMatrix["Face, lower side"][2] = {};
	aHackingCritMatrix["Face, lower side"][3] = {};
	aHackingCritMatrix["Face, lower side"][4] = {};
	aHackingCritMatrix["Face, lower side"][5] = {};
	aHackingCritMatrix["Face, lower side"][6] = {};
	aHackingCritMatrix["Face, lower side"][7] = {};
	aHackingCritMatrix["Face, lower side"][8] = {};
	aHackingCritMatrix["Face, lower side"][9] = {};
	aHackingCritMatrix["Face, lower side"][10] = {};
	aHackingCritMatrix["Face, lower side"][11] = {};
	aHackingCritMatrix["Face, lower side"][12] = {};
	aHackingCritMatrix["Face, lower side"][13] = {};
	aHackingCritMatrix["Face, lower side"][14] = {};
	aHackingCritMatrix["Face, lower side"][15] = {};
	aHackingCritMatrix["Face, lower side"][16] = {};
	aHackingCritMatrix["Face, lower side"][17] = {};
	aHackingCritMatrix["Face, lower side"][18] = {};
	aHackingCritMatrix["Face, lower side"][19] = {};
	aHackingCritMatrix["Face, lower side"][20] = {};
	aHackingCritMatrix["Face, lower side"][21] = {};
	aHackingCritMatrix["Face, lower side"][22] = {};
	aHackingCritMatrix["Face, lower side"][23] = {};
	aHackingCritMatrix["Face, lower side"][24] = {};

	aHackingCritMatrix["Face, lower center"][1] = {};
	aHackingCritMatrix["Face, lower center"][2] = {};
	aHackingCritMatrix["Face, lower center"][3] = {};
	aHackingCritMatrix["Face, lower center"][4] = {};
	aHackingCritMatrix["Face, lower center"][5] = {};
	aHackingCritMatrix["Face, lower center"][6] = {};
	aHackingCritMatrix["Face, lower center"][7] = {};
	aHackingCritMatrix["Face, lower center"][8] = {};
	aHackingCritMatrix["Face, lower center"][9] = {};
	aHackingCritMatrix["Face, lower center"][10] = {};
	aHackingCritMatrix["Face, lower center"][11] = {};
	aHackingCritMatrix["Face, lower center"][12] = {};
	aHackingCritMatrix["Face, lower center"][13] = {};
	aHackingCritMatrix["Face, lower center"][14] = {};
	aHackingCritMatrix["Face, lower center"][15] = {};
	aHackingCritMatrix["Face, lower center"][16] = {};
	aHackingCritMatrix["Face, lower center"][17] = {};
	aHackingCritMatrix["Face, lower center"][18] = {};
	aHackingCritMatrix["Face, lower center"][19] = {};
	aHackingCritMatrix["Face, lower center"][20] = {};
	aHackingCritMatrix["Face, lower center"][21] = {};
	aHackingCritMatrix["Face, lower center"][22] = {};
	aHackingCritMatrix["Face, lower center"][23] = {};
	aHackingCritMatrix["Face, lower center"][24] = {};
	
	aHackingCritMatrix["Head, back upper"][1] = {};
	aHackingCritMatrix["Head, back upper"][2] = {};
	aHackingCritMatrix["Head, back upper"][3] = {};
	aHackingCritMatrix["Head, back upper"][4] = {};
	aHackingCritMatrix["Head, back upper"][5] = {};
	aHackingCritMatrix["Head, back upper"][6] = {};
	aHackingCritMatrix["Head, back upper"][7] = {};
	aHackingCritMatrix["Head, back upper"][8] = {};
	aHackingCritMatrix["Head, back upper"][9] = {};
	aHackingCritMatrix["Head, back upper"][10] = {};
	aHackingCritMatrix["Head, back upper"][11] = {};
	aHackingCritMatrix["Head, back upper"][12] = {};
	aHackingCritMatrix["Head, back upper"][13] = {};
	aHackingCritMatrix["Head, back upper"][14] = {};
	aHackingCritMatrix["Head, back upper"][15] = {};
	aHackingCritMatrix["Head, back upper"][16] = {};
	aHackingCritMatrix["Head, back upper"][17] = {};
	aHackingCritMatrix["Head, back upper"][18] = {};
	aHackingCritMatrix["Head, back upper"][19] = {};
	aHackingCritMatrix["Head, back upper"][20] = {};
	aHackingCritMatrix["Head, back upper"][21] = {};
	aHackingCritMatrix["Head, back upper"][22] = {};
	aHackingCritMatrix["Head, back upper"][23] = {};
	aHackingCritMatrix["Head, back upper"][24] = {};
	
	aHackingCritMatrix["Face, upper side"][1] = {};
	aHackingCritMatrix["Face, upper side"][2] = {};
	aHackingCritMatrix["Face, upper side"][3] = {};
	aHackingCritMatrix["Face, upper side"][4] = {};
	aHackingCritMatrix["Face, upper side"][5] = {};
	aHackingCritMatrix["Face, upper side"][6] = {};
	aHackingCritMatrix["Face, upper side"][7] = {};
	aHackingCritMatrix["Face, upper side"][8] = {};
	aHackingCritMatrix["Face, upper side"][9] = {};
	aHackingCritMatrix["Face, upper side"][10] = {};
	aHackingCritMatrix["Face, upper side"][11] = {};
	aHackingCritMatrix["Face, upper side"][12] = {};
	aHackingCritMatrix["Face, upper side"][13] = {};
	aHackingCritMatrix["Face, upper side"][14] = {};
	aHackingCritMatrix["Face, upper side"][15] = {};
	aHackingCritMatrix["Face, upper side"][16] = {};
	aHackingCritMatrix["Face, upper side"][17] = {};
	aHackingCritMatrix["Face, upper side"][18] = {};
	aHackingCritMatrix["Face, upper side"][19] = {};
	aHackingCritMatrix["Face, upper side"][20] = {};
	aHackingCritMatrix["Face, upper side"][21] = {};
	aHackingCritMatrix["Face, upper side"][22] = {};
	aHackingCritMatrix["Face, upper side"][23] = {};
	aHackingCritMatrix["Face, upper side"][24] = {};
	
	aHackingCritMatrix["Face, upper center"][1] = {};
	aHackingCritMatrix["Face, upper center"][2] = {};
	aHackingCritMatrix["Face, upper center"][3] = {};
	aHackingCritMatrix["Face, upper center"][4] = {};
	aHackingCritMatrix["Face, upper center"][5] = {};
	aHackingCritMatrix["Face, upper center"][6] = {};
	aHackingCritMatrix["Face, upper center"][7] = {};
	aHackingCritMatrix["Face, upper center"][8] = {};
	aHackingCritMatrix["Face, upper center"][9] = {};
	aHackingCritMatrix["Face, upper center"][10] = {};
	aHackingCritMatrix["Face, upper center"][11] = {};
	aHackingCritMatrix["Face, upper center"][12] = {};
	aHackingCritMatrix["Face, upper center"][13] = {};
	aHackingCritMatrix["Face, upper center"][14] = {};
	aHackingCritMatrix["Face, upper center"][15] = {};
	aHackingCritMatrix["Face, upper center"][16] = {};
	aHackingCritMatrix["Face, upper center"][17] = {};
	aHackingCritMatrix["Face, upper center"][18] = {};
	aHackingCritMatrix["Face, upper center"][19] = {};
	aHackingCritMatrix["Face, upper center"][20] = {};
	aHackingCritMatrix["Face, upper center"][21] = {};
	aHackingCritMatrix["Face, upper center"][22] = {};
	aHackingCritMatrix["Face, upper center"][23] = {};
	aHackingCritMatrix["Face, upper center"][24] = {};
	
	aHackingCritMatrix["Head, top"][1] = {};
	aHackingCritMatrix["Head, top"][2] = {};
	aHackingCritMatrix["Head, top"][3] = {};
	aHackingCritMatrix["Head, top"][4] = {};
	aHackingCritMatrix["Head, top"][5] = {};
	aHackingCritMatrix["Head, top"][6] = {};
	aHackingCritMatrix["Head, top"][7] = {};
	aHackingCritMatrix["Head, top"][8] = {};
	aHackingCritMatrix["Head, top"][9] = {};
	aHackingCritMatrix["Head, top"][10] = {};
	aHackingCritMatrix["Head, top"][11] = {};
	aHackingCritMatrix["Head, top"][12] = {};
	aHackingCritMatrix["Head, top"][13] = {};
	aHackingCritMatrix["Head, top"][14] = {};
	aHackingCritMatrix["Head, top"][15] = {};
	aHackingCritMatrix["Head, top"][16] = {};
	aHackingCritMatrix["Head, top"][17] = {};
	aHackingCritMatrix["Head, top"][18] = {};
	aHackingCritMatrix["Head, top"][19] = {};
	aHackingCritMatrix["Head, top"][20] = {};
	aHackingCritMatrix["Head, top"][21] = {};
	aHackingCritMatrix["Head, top"][22] = {};
	aHackingCritMatrix["Head, top"][23] = {};
	aHackingCritMatrix["Head, top"][24] = {};
end

function buildCrushingCritMatrix()

	aCrushingCritMatrix["Foot, top"][1] = {};
	aCrushingCritMatrix["Foot, top"][2] = {};
	aCrushingCritMatrix["Foot, top"][3] = {};
	aCrushingCritMatrix["Foot, top"][4] = {};
	aCrushingCritMatrix["Foot, top"][5] = {};
	aCrushingCritMatrix["Foot, top"][6] = {};
	aCrushingCritMatrix["Foot, top"][7] = {};
	aCrushingCritMatrix["Foot, top"][8] = {};
	aCrushingCritMatrix["Foot, top"][9] = {};
	aCrushingCritMatrix["Foot, top"][10] = {};
	aCrushingCritMatrix["Foot, top"][11] = {};
	aCrushingCritMatrix["Foot, top"][12] = {};
	aCrushingCritMatrix["Foot, top"][13] = {};
	aCrushingCritMatrix["Foot, top"][14] = {};
	aCrushingCritMatrix["Foot, top"][15] = {};
	aCrushingCritMatrix["Foot, top"][16] = {};
	aCrushingCritMatrix["Foot, top"][17] = {};
	aCrushingCritMatrix["Foot, top"][18] = {};
	aCrushingCritMatrix["Foot, top"][19] = {};
	aCrushingCritMatrix["Foot, top"][20] = {};
	aCrushingCritMatrix["Foot, top"][21] = {};
	aCrushingCritMatrix["Foot, top"][22] = {};
	aCrushingCritMatrix["Foot, top"][23] = {};
	aCrushingCritMatrix["Foot, top"][24] = {};
	
	aCrushingCritMatrix["Heel"][1] = {};
	aCrushingCritMatrix["Heel"][2] = {};
	aCrushingCritMatrix["Heel"][3] = {};
	aCrushingCritMatrix["Heel"][4] = {};
	aCrushingCritMatrix["Heel"][5] = {};
	aCrushingCritMatrix["Heel"][6] = {};
	aCrushingCritMatrix["Heel"][7] = {};
	aCrushingCritMatrix["Heel"][8] = {};
	aCrushingCritMatrix["Heel"][9] = {};
	aCrushingCritMatrix["Heel"][10] = {};
	aCrushingCritMatrix["Heel"][11] = {};
	aCrushingCritMatrix["Heel"][12] = {};
	aCrushingCritMatrix["Heel"][13] = {};
	aCrushingCritMatrix["Heel"][14] = {};
	aCrushingCritMatrix["Heel"][15] = {};
	aCrushingCritMatrix["Heel"][16] = {};
	aCrushingCritMatrix["Heel"][17] = {};
	aCrushingCritMatrix["Heel"][18] = {};
	aCrushingCritMatrix["Heel"][19] = {};
	aCrushingCritMatrix["Heel"][20] = {};
	aCrushingCritMatrix["Heel"][21] = {};
	aCrushingCritMatrix["Heel"][22] = {};
	aCrushingCritMatrix["Heel"][23] = {};
	aCrushingCritMatrix["Heel"][24] = {};

	aCrushingCritMatrix["Toe(s)"][1] = {};
	aCrushingCritMatrix["Toe(s)"][2] = {};
	aCrushingCritMatrix["Toe(s)"][3] = {};
	aCrushingCritMatrix["Toe(s)"][4] = {};
	aCrushingCritMatrix["Toe(s)"][5] = {};
	aCrushingCritMatrix["Toe(s)"][6] = {};
	aCrushingCritMatrix["Toe(s)"][7] = {};
	aCrushingCritMatrix["Toe(s)"][8] = {};
	aCrushingCritMatrix["Toe(s)"][9] = {};
	aCrushingCritMatrix["Toe(s)"][10] = {};
	aCrushingCritMatrix["Toe(s)"][11] = {};
	aCrushingCritMatrix["Toe(s)"][12] = {};
	aCrushingCritMatrix["Toe(s)"][13] = {};
	aCrushingCritMatrix["Toe(s)"][14] = {};
	aCrushingCritMatrix["Toe(s)"][15] = {};
	aCrushingCritMatrix["Toe(s)"][16] = {};
	aCrushingCritMatrix["Toe(s)"][17] = {};
	aCrushingCritMatrix["Toe(s)"][18] = {};
	aCrushingCritMatrix["Toe(s)"][19] = {};
	aCrushingCritMatrix["Toe(s)"][20] = {};
	aCrushingCritMatrix["Toe(s)"][21] = {};
	aCrushingCritMatrix["Toe(s)"][22] = {};
	aCrushingCritMatrix["Toe(s)"][23] = {};
	aCrushingCritMatrix["Toe(s)"][24] = {};
	
	aCrushingCritMatrix["Foot, arch"][1] = {};
	aCrushingCritMatrix["Foot, arch"][2] = {};
	aCrushingCritMatrix["Foot, arch"][3] = {};
	aCrushingCritMatrix["Foot, arch"][4] = {};
	aCrushingCritMatrix["Foot, arch"][5] = {};
	aCrushingCritMatrix["Foot, arch"][6] = {};
	aCrushingCritMatrix["Foot, arch"][7] = {};
	aCrushingCritMatrix["Foot, arch"][8] = {};
	aCrushingCritMatrix["Foot, arch"][9] = {};
	aCrushingCritMatrix["Foot, arch"][10] = {};
	aCrushingCritMatrix["Foot, arch"][11] = {};
	aCrushingCritMatrix["Foot, arch"][12] = {};
	aCrushingCritMatrix["Foot, arch"][13] = {};
	aCrushingCritMatrix["Foot, arch"][14] = {};
	aCrushingCritMatrix["Foot, arch"][15] = {};
	aCrushingCritMatrix["Foot, arch"][16] = {};
	aCrushingCritMatrix["Foot, arch"][17] = {};
	aCrushingCritMatrix["Foot, arch"][18] = {};
	aCrushingCritMatrix["Foot, arch"][19] = {};
	aCrushingCritMatrix["Foot, arch"][20] = {};
	aCrushingCritMatrix["Foot, arch"][21] = {};
	aCrushingCritMatrix["Foot, arch"][22] = {};
	aCrushingCritMatrix["Foot, arch"][23] = {};
	aCrushingCritMatrix["Foot, arch"][24] = {};
	
	aCrushingCritMatrix["Ankle, inner"][1] = {};
	aCrushingCritMatrix["Ankle, inner"][2] = {};
	aCrushingCritMatrix["Ankle, inner"][3] = {};
	aCrushingCritMatrix["Ankle, inner"][4] = {};
	aCrushingCritMatrix["Ankle, inner"][5] = {};
	aCrushingCritMatrix["Ankle, inner"][6] = {};
	aCrushingCritMatrix["Ankle, inner"][7] = {};
	aCrushingCritMatrix["Ankle, inner"][8] = {};
	aCrushingCritMatrix["Ankle, inner"][9] = {};
	aCrushingCritMatrix["Ankle, inner"][10] = {};
	aCrushingCritMatrix["Ankle, inner"][11] = {};
	aCrushingCritMatrix["Ankle, inner"][12] = {};
	aCrushingCritMatrix["Ankle, inner"][13] = {};
	aCrushingCritMatrix["Ankle, inner"][14] = {};
	aCrushingCritMatrix["Ankle, inner"][15] = {};
	aCrushingCritMatrix["Ankle, inner"][16] = {};
	aCrushingCritMatrix["Ankle, inner"][17] = {};
	aCrushingCritMatrix["Ankle, inner"][18] = {};
	aCrushingCritMatrix["Ankle, inner"][19] = {};
	aCrushingCritMatrix["Ankle, inner"][20] = {};
	aCrushingCritMatrix["Ankle, inner"][21] = {};
	aCrushingCritMatrix["Ankle, inner"][22] = {};
	aCrushingCritMatrix["Ankle, inner"][23] = {};
	aCrushingCritMatrix["Ankle, inner"][24] = {};
	
	aCrushingCritMatrix["Ankle, outer"][1] = {};
	aCrushingCritMatrix["Ankle, outer"][2] = {};
	aCrushingCritMatrix["Ankle, outer"][3] = {};
	aCrushingCritMatrix["Ankle, outer"][4] = {};
	aCrushingCritMatrix["Ankle, outer"][5] = {};
	aCrushingCritMatrix["Ankle, outer"][6] = {};
	aCrushingCritMatrix["Ankle, outer"][7] = {};
	aCrushingCritMatrix["Ankle, outer"][8] = {};
	aCrushingCritMatrix["Ankle, outer"][9] = {};
	aCrushingCritMatrix["Ankle, outer"][10] = {};
	aCrushingCritMatrix["Ankle, outer"][11] = {};
	aCrushingCritMatrix["Ankle, outer"][12] = {};
	aCrushingCritMatrix["Ankle, outer"][13] = {};
	aCrushingCritMatrix["Ankle, outer"][14] = {};
	aCrushingCritMatrix["Ankle, outer"][15] = {};
	aCrushingCritMatrix["Ankle, outer"][16] = {};
	aCrushingCritMatrix["Ankle, outer"][17] = {};
	aCrushingCritMatrix["Ankle, outer"][18] = {};
	aCrushingCritMatrix["Ankle, outer"][19] = {};
	aCrushingCritMatrix["Ankle, outer"][20] = {};
	aCrushingCritMatrix["Ankle, outer"][21] = {};
	aCrushingCritMatrix["Ankle, outer"][22] = {};
	aCrushingCritMatrix["Ankle, outer"][23] = {};
	aCrushingCritMatrix["Ankle, outer"][24] = {};
	
	aCrushingCritMatrix["Ankle, upper/Achilles"][1] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][2] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][3] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][4] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][5] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][6] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][7] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][8] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][9] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][10] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][11] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][12] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][13] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][14] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][15] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][16] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][17] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][18] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][19] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][20] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][21] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][22] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][23] = {};
	aCrushingCritMatrix["Ankle, upper/Achilles"][24] = {};
	
	aCrushingCritMatrix["Shin"][1] = {};
	aCrushingCritMatrix["Shin"][2] = {};
	aCrushingCritMatrix["Shin"][3] = {};
	aCrushingCritMatrix["Shin"][4] = {};
	aCrushingCritMatrix["Shin"][5] = {};
	aCrushingCritMatrix["Shin"][6] = {};
	aCrushingCritMatrix["Shin"][7] = {};
	aCrushingCritMatrix["Shin"][8] = {};
	aCrushingCritMatrix["Shin"][9] = {};
	aCrushingCritMatrix["Shin"][10] = {};
	aCrushingCritMatrix["Shin"][11] = {};
	aCrushingCritMatrix["Shin"][12] = {};
	aCrushingCritMatrix["Shin"][13] = {};
	aCrushingCritMatrix["Shin"][14] = {};
	aCrushingCritMatrix["Shin"][15] = {};
	aCrushingCritMatrix["Shin"][16] = {};
	aCrushingCritMatrix["Shin"][17] = {};
	aCrushingCritMatrix["Shin"][18] = {};
	aCrushingCritMatrix["Shin"][19] = {};
	aCrushingCritMatrix["Shin"][20] = {};
	aCrushingCritMatrix["Shin"][21] = {};
	aCrushingCritMatrix["Shin"][22] = {};
	aCrushingCritMatrix["Shin"][23] = {};
	aCrushingCritMatrix["Shin"][24] = {};

	aCrushingCritMatrix["Calf"][1] = {};
	aCrushingCritMatrix["Calf"][2] = {};
	aCrushingCritMatrix["Calf"][3] = {};
	aCrushingCritMatrix["Calf"][4] = {};
	aCrushingCritMatrix["Calf"][5] = {};
	aCrushingCritMatrix["Calf"][6] = {};
	aCrushingCritMatrix["Calf"][7] = {};
	aCrushingCritMatrix["Calf"][8] = {};
	aCrushingCritMatrix["Calf"][9] = {};
	aCrushingCritMatrix["Calf"][10] = {};
	aCrushingCritMatrix["Calf"][11] = {};
	aCrushingCritMatrix["Calf"][12] = {};
	aCrushingCritMatrix["Calf"][13] = {};
	aCrushingCritMatrix["Calf"][14] = {};
	aCrushingCritMatrix["Calf"][15] = {};
	aCrushingCritMatrix["Calf"][16] = {};
	aCrushingCritMatrix["Calf"][17] = {};
	aCrushingCritMatrix["Calf"][18] = {};
	aCrushingCritMatrix["Calf"][19] = {};
	aCrushingCritMatrix["Calf"][20] = {};
	aCrushingCritMatrix["Calf"][21] = {};
	aCrushingCritMatrix["Calf"][22] = {};
	aCrushingCritMatrix["Calf"][23] = {};
	aCrushingCritMatrix["Calf"][24] = {};

	aCrushingCritMatrix["Knee"][1] = {};
	aCrushingCritMatrix["Knee"][2] = {};
	aCrushingCritMatrix["Knee"][3] = {};
	aCrushingCritMatrix["Knee"][4] = {};
	aCrushingCritMatrix["Knee"][5] = {};
	aCrushingCritMatrix["Knee"][6] = {};
	aCrushingCritMatrix["Knee"][7] = {};
	aCrushingCritMatrix["Knee"][8] = {};
	aCrushingCritMatrix["Knee"][9] = {};
	aCrushingCritMatrix["Knee"][10] = {};
	aCrushingCritMatrix["Knee"][11] = {};
	aCrushingCritMatrix["Knee"][12] = {};
	aCrushingCritMatrix["Knee"][13] = {};
	aCrushingCritMatrix["Knee"][14] = {};
	aCrushingCritMatrix["Knee"][15] = {};
	aCrushingCritMatrix["Knee"][16] = {};
	aCrushingCritMatrix["Knee"][17] = {};
	aCrushingCritMatrix["Knee"][18] = {};
	aCrushingCritMatrix["Knee"][19] = {};
	aCrushingCritMatrix["Knee"][20] = {};
	aCrushingCritMatrix["Knee"][21] = {};
	aCrushingCritMatrix["Knee"][22] = {};
	aCrushingCritMatrix["Knee"][23] = {};
	aCrushingCritMatrix["Knee"][24] = {};
		
	aCrushingCritMatrix["Knee, back"][1] = {};
	aCrushingCritMatrix["Knee, back"][2] = {};
	aCrushingCritMatrix["Knee, back"][3] = {};
	aCrushingCritMatrix["Knee, back"][4] = {};
	aCrushingCritMatrix["Knee, back"][5] = {};
	aCrushingCritMatrix["Knee, back"][6] = {};
	aCrushingCritMatrix["Knee, back"][7] = {};
	aCrushingCritMatrix["Knee, back"][8] = {};
	aCrushingCritMatrix["Knee, back"][9] = {};
	aCrushingCritMatrix["Knee, back"][10] = {};
	aCrushingCritMatrix["Knee, back"][11] = {};
	aCrushingCritMatrix["Knee, back"][12] = {};
	aCrushingCritMatrix["Knee, back"][13] = {};
	aCrushingCritMatrix["Knee, back"][14] = {};
	aCrushingCritMatrix["Knee, back"][15] = {};
	aCrushingCritMatrix["Knee, back"][16] = {};
	aCrushingCritMatrix["Knee, back"][17] = {};
	aCrushingCritMatrix["Knee, back"][18] = {};
	aCrushingCritMatrix["Knee, back"][19] = {};
	aCrushingCritMatrix["Knee, back"][20] = {};
	aCrushingCritMatrix["Knee, back"][21] = {};
	aCrushingCritMatrix["Knee, back"][22] = {};
	aCrushingCritMatrix["Knee, back"][23] = {};
	aCrushingCritMatrix["Knee, back"][24] = {};
	
	aCrushingCritMatrix["Hamstring"][1] = {};
	aCrushingCritMatrix["Hamstring"][2] = {};
	aCrushingCritMatrix["Hamstring"][3] = {};
	aCrushingCritMatrix["Hamstring"][4] = {};
	aCrushingCritMatrix["Hamstring"][5] = {};
	aCrushingCritMatrix["Hamstring"][6] = {};
	aCrushingCritMatrix["Hamstring"][7] = {};
	aCrushingCritMatrix["Hamstring"][8] = {};
	aCrushingCritMatrix["Hamstring"][9] = {};
	aCrushingCritMatrix["Hamstring"][10] = {};
	aCrushingCritMatrix["Hamstring"][11] = {};
	aCrushingCritMatrix["Hamstring"][12] = {};
	aCrushingCritMatrix["Hamstring"][13] = {};
	aCrushingCritMatrix["Hamstring"][14] = {};
	aCrushingCritMatrix["Hamstring"][15] = {};
	aCrushingCritMatrix["Hamstring"][16] = {};
	aCrushingCritMatrix["Hamstring"][17] = {};
	aCrushingCritMatrix["Hamstring"][18] = {};
	aCrushingCritMatrix["Hamstring"][19] = {};
	aCrushingCritMatrix["Hamstring"][20] = {};
	aCrushingCritMatrix["Hamstring"][21] = {};
	aCrushingCritMatrix["Hamstring"][22] = {};
	aCrushingCritMatrix["Hamstring"][23] = {};
	aCrushingCritMatrix["Hamstring"][24] = {};
	
	aCrushingCritMatrix["Thigh"][1] = {};
	aCrushingCritMatrix["Thigh"][2] = {};
	aCrushingCritMatrix["Thigh"][3] = {};
	aCrushingCritMatrix["Thigh"][4] = {};
	aCrushingCritMatrix["Thigh"][5] = {};
	aCrushingCritMatrix["Thigh"][6] = {};
	aCrushingCritMatrix["Thigh"][7] = {};
	aCrushingCritMatrix["Thigh"][8] = {};
	aCrushingCritMatrix["Thigh"][9] = {};
	aCrushingCritMatrix["Thigh"][10] = {};
	aCrushingCritMatrix["Thigh"][11] = {};
	aCrushingCritMatrix["Thigh"][12] = {};
	aCrushingCritMatrix["Thigh"][13] = {};
	aCrushingCritMatrix["Thigh"][14] = {};
	aCrushingCritMatrix["Thigh"][15] = {};
	aCrushingCritMatrix["Thigh"][16] = {};
	aCrushingCritMatrix["Thigh"][17] = {};
	aCrushingCritMatrix["Thigh"][18] = {};
	aCrushingCritMatrix["Thigh"][19] = {};
	aCrushingCritMatrix["Thigh"][20] = {};
	aCrushingCritMatrix["Thigh"][21] = {};
	aCrushingCritMatrix["Thigh"][22] = {};
	aCrushingCritMatrix["Thigh"][23] = {};
	aCrushingCritMatrix["Thigh"][24] = {};
	
	aCrushingCritMatrix["Hip"][1] = {};
	aCrushingCritMatrix["Hip"][2] = {};
	aCrushingCritMatrix["Hip"][3] = {};
	aCrushingCritMatrix["Hip"][4] = {};
	aCrushingCritMatrix["Hip"][5] = {};
	aCrushingCritMatrix["Hip"][6] = {};
	aCrushingCritMatrix["Hip"][7] = {};
	aCrushingCritMatrix["Hip"][8] = {};
	aCrushingCritMatrix["Hip"][9] = {};
	aCrushingCritMatrix["Hip"][10] = {};
	aCrushingCritMatrix["Hip"][11] = {};
	aCrushingCritMatrix["Hip"][12] = {};
	aCrushingCritMatrix["Hip"][13] = {};
	aCrushingCritMatrix["Hip"][14] = {};
	aCrushingCritMatrix["Hip"][15] = {};
	aCrushingCritMatrix["Hip"][16] = {};
	aCrushingCritMatrix["Hip"][17] = {};
	aCrushingCritMatrix["Hip"][18] = {};
	aCrushingCritMatrix["Hip"][19] = {};
	aCrushingCritMatrix["Hip"][20] = {};
	aCrushingCritMatrix["Hip"][21] = {};
	aCrushingCritMatrix["Hip"][22] = {};
	aCrushingCritMatrix["Hip"][23] = {};
	aCrushingCritMatrix["Hip"][24] = {};

	aCrushingCritMatrix["Groin"][1] = {};
	aCrushingCritMatrix["Groin"][2] = {};
	aCrushingCritMatrix["Groin"][3] = {};
	aCrushingCritMatrix["Groin"][4] = {};
	aCrushingCritMatrix["Groin"][5] = {};
	aCrushingCritMatrix["Groin"][6] = {};
	aCrushingCritMatrix["Groin"][7] = {};
	aCrushingCritMatrix["Groin"][8] = {};
	aCrushingCritMatrix["Groin"][9] = {};
	aCrushingCritMatrix["Groin"][10] = {};
	aCrushingCritMatrix["Groin"][11] = {};
	aCrushingCritMatrix["Groin"][12] = {};
	aCrushingCritMatrix["Groin"][13] = {};
	aCrushingCritMatrix["Groin"][14] = {};
	aCrushingCritMatrix["Groin"][15] = {};
	aCrushingCritMatrix["Groin"][16] = {};
	aCrushingCritMatrix["Groin"][17] = {};
	aCrushingCritMatrix["Groin"][18] = {};
	aCrushingCritMatrix["Groin"][19] = {};
	aCrushingCritMatrix["Groin"][20] = {};
	aCrushingCritMatrix["Groin"][21] = {};
	aCrushingCritMatrix["Groin"][22] = {};
	aCrushingCritMatrix["Groin"][23] = {};
	aCrushingCritMatrix["Groin"][24] = {};
	
	aCrushingCritMatrix["Buttock"][1] = {};
	aCrushingCritMatrix["Buttock"][2] = {};
	aCrushingCritMatrix["Buttock"][3] = {};
	aCrushingCritMatrix["Buttock"][4] = {};
	aCrushingCritMatrix["Buttock"][5] = {};
	aCrushingCritMatrix["Buttock"][6] = {};
	aCrushingCritMatrix["Buttock"][7] = {};
	aCrushingCritMatrix["Buttock"][8] = {};
	aCrushingCritMatrix["Buttock"][9] = {};
	aCrushingCritMatrix["Buttock"][10] = {};
	aCrushingCritMatrix["Buttock"][11] = {};
	aCrushingCritMatrix["Buttock"][12] = {};
	aCrushingCritMatrix["Buttock"][13] = {};
	aCrushingCritMatrix["Buttock"][14] = {};
	aCrushingCritMatrix["Buttock"][15] = {};
	aCrushingCritMatrix["Buttock"][16] = {};
	aCrushingCritMatrix["Buttock"][17] = {};
	aCrushingCritMatrix["Buttock"][18] = {};
	aCrushingCritMatrix["Buttock"][19] = {};
	aCrushingCritMatrix["Buttock"][20] = {};
	aCrushingCritMatrix["Buttock"][21] = {};
	aCrushingCritMatrix["Buttock"][22] = {};
	aCrushingCritMatrix["Buttock"][23] = {};
	aCrushingCritMatrix["Buttock"][24] = {};

	aCrushingCritMatrix["Abdomen, Lower"][1] = {};
	aCrushingCritMatrix["Abdomen, Lower"][2] = {};
	aCrushingCritMatrix["Abdomen, Lower"][3] = {};
	aCrushingCritMatrix["Abdomen, Lower"][4] = {};
	aCrushingCritMatrix["Abdomen, Lower"][5] = {};
	aCrushingCritMatrix["Abdomen, Lower"][6] = {};
	aCrushingCritMatrix["Abdomen, Lower"][7] = {};
	aCrushingCritMatrix["Abdomen, Lower"][8] = {};
	aCrushingCritMatrix["Abdomen, Lower"][9] = {};
	aCrushingCritMatrix["Abdomen, Lower"][10] = {};
	aCrushingCritMatrix["Abdomen, Lower"][11] = {};
	aCrushingCritMatrix["Abdomen, Lower"][12] = {};
	aCrushingCritMatrix["Abdomen, Lower"][13] = {};
	aCrushingCritMatrix["Abdomen, Lower"][14] = {};
	aCrushingCritMatrix["Abdomen, Lower"][15] = {};
	aCrushingCritMatrix["Abdomen, Lower"][16] = {};
	aCrushingCritMatrix["Abdomen, Lower"][17] = {};
	aCrushingCritMatrix["Abdomen, Lower"][18] = {};
	aCrushingCritMatrix["Abdomen, Lower"][19] = {};
	aCrushingCritMatrix["Abdomen, Lower"][20] = {};
	aCrushingCritMatrix["Abdomen, Lower"][21] = {};
	aCrushingCritMatrix["Abdomen, Lower"][22] = {};
	aCrushingCritMatrix["Abdomen, Lower"][23] = {};
	aCrushingCritMatrix["Abdomen, Lower"][24] = {};

	aCrushingCritMatrix["Side, lower"][1] = {};
	aCrushingCritMatrix["Side, lower"][2] = {};
	aCrushingCritMatrix["Side, lower"][3] = {};
	aCrushingCritMatrix["Side, lower"][4] = {};
	aCrushingCritMatrix["Side, lower"][5] = {};
	aCrushingCritMatrix["Side, lower"][6] = {};
	aCrushingCritMatrix["Side, lower"][7] = {};
	aCrushingCritMatrix["Side, lower"][8] = {};
	aCrushingCritMatrix["Side, lower"][9] = {};
	aCrushingCritMatrix["Side, lower"][10] = {};
	aCrushingCritMatrix["Side, lower"][11] = {};
	aCrushingCritMatrix["Side, lower"][12] = {};
	aCrushingCritMatrix["Side, lower"][13] = {};
	aCrushingCritMatrix["Side, lower"][14] = {};
	aCrushingCritMatrix["Side, lower"][15] = {};
	aCrushingCritMatrix["Side, lower"][16] = {};
	aCrushingCritMatrix["Side, lower"][17] = {};
	aCrushingCritMatrix["Side, lower"][18] = {};
	aCrushingCritMatrix["Side, lower"][19] = {};
	aCrushingCritMatrix["Side, lower"][20] = {};
	aCrushingCritMatrix["Side, lower"][21] = {};
	aCrushingCritMatrix["Side, lower"][22] = {};
	aCrushingCritMatrix["Side, lower"][23] = {};
	aCrushingCritMatrix["Side, lower"][24] = {};
	
	aCrushingCritMatrix["Abdomen, upper"][1] = {};
	aCrushingCritMatrix["Abdomen, upper"][2] = {};
	aCrushingCritMatrix["Abdomen, upper"][3] = {};
	aCrushingCritMatrix["Abdomen, upper"][4] = {};
	aCrushingCritMatrix["Abdomen, upper"][5] = {};
	aCrushingCritMatrix["Abdomen, upper"][6] = {};
	aCrushingCritMatrix["Abdomen, upper"][7] = {};
	aCrushingCritMatrix["Abdomen, upper"][8] = {};
	aCrushingCritMatrix["Abdomen, upper"][9] = {};
	aCrushingCritMatrix["Abdomen, upper"][10] = {};
	aCrushingCritMatrix["Abdomen, upper"][11] = {};
	aCrushingCritMatrix["Abdomen, upper"][12] = {};
	aCrushingCritMatrix["Abdomen, upper"][13] = {};
	aCrushingCritMatrix["Abdomen, upper"][14] = {};
	aCrushingCritMatrix["Abdomen, upper"][15] = {};
	aCrushingCritMatrix["Abdomen, upper"][16] = {};
	aCrushingCritMatrix["Abdomen, upper"][17] = {};
	aCrushingCritMatrix["Abdomen, upper"][18] = {};
	aCrushingCritMatrix["Abdomen, upper"][19] = {};
	aCrushingCritMatrix["Abdomen, upper"][20] = {};
	aCrushingCritMatrix["Abdomen, upper"][21] = {};
	aCrushingCritMatrix["Abdomen, upper"][22] = {};
	aCrushingCritMatrix["Abdomen, upper"][23] = {};
	aCrushingCritMatrix["Abdomen, upper"][24] = {};

	aCrushingCritMatrix["Back, small of"][1] = {};
	aCrushingCritMatrix["Back, small of"][2] = {};
	aCrushingCritMatrix["Back, small of"][3] = {};
	aCrushingCritMatrix["Back, small of"][4] = {};
	aCrushingCritMatrix["Back, small of"][5] = {};
	aCrushingCritMatrix["Back, small of"][6] = {};
	aCrushingCritMatrix["Back, small of"][7] = {};
	aCrushingCritMatrix["Back, small of"][8] = {};
	aCrushingCritMatrix["Back, small of"][9] = {};
	aCrushingCritMatrix["Back, small of"][10] = {};
	aCrushingCritMatrix["Back, small of"][11] = {};
	aCrushingCritMatrix["Back, small of"][12] = {};
	aCrushingCritMatrix["Back, small of"][13] = {};
	aCrushingCritMatrix["Back, small of"][14] = {};
	aCrushingCritMatrix["Back, small of"][15] = {};
	aCrushingCritMatrix["Back, small of"][16] = {};
	aCrushingCritMatrix["Back, small of"][17] = {};
	aCrushingCritMatrix["Back, small of"][18] = {};
	aCrushingCritMatrix["Back, small of"][19] = {};
	aCrushingCritMatrix["Back, small of"][20] = {};
	aCrushingCritMatrix["Back, small of"][21] = {};
	aCrushingCritMatrix["Back, small of"][22] = {};
	aCrushingCritMatrix["Back, small of"][23] = {};
	aCrushingCritMatrix["Back, small of"][24] = {};

	aCrushingCritMatrix["Back, lower"][1] = {};
	aCrushingCritMatrix["Back, lower"][2] = {};
	aCrushingCritMatrix["Back, lower"][3] = {};
	aCrushingCritMatrix["Back, lower"][4] = {};
	aCrushingCritMatrix["Back, lower"][5] = {};
	aCrushingCritMatrix["Back, lower"][6] = {};
	aCrushingCritMatrix["Back, lower"][7] = {};
	aCrushingCritMatrix["Back, lower"][8] = {};
	aCrushingCritMatrix["Back, lower"][9] = {};
	aCrushingCritMatrix["Back, lower"][10] = {};
	aCrushingCritMatrix["Back, lower"][11] = {};
	aCrushingCritMatrix["Back, lower"][12] = {};
	aCrushingCritMatrix["Back, lower"][13] = {};
	aCrushingCritMatrix["Back, lower"][14] = {};
	aCrushingCritMatrix["Back, lower"][15] = {};
	aCrushingCritMatrix["Back, lower"][16] = {};
	aCrushingCritMatrix["Back, lower"][17] = {};
	aCrushingCritMatrix["Back, lower"][18] = {};
	aCrushingCritMatrix["Back, lower"][19] = {};
	aCrushingCritMatrix["Back, lower"][20] = {};
	aCrushingCritMatrix["Back, lower"][21] = {};
	aCrushingCritMatrix["Back, lower"][22] = {};
	aCrushingCritMatrix["Back, lower"][23] = {};
	aCrushingCritMatrix["Back, lower"][24] = {};

	aCrushingCritMatrix["Chest"][1] = {};
	aCrushingCritMatrix["Chest"][2] = {};
	aCrushingCritMatrix["Chest"][3] = {};
	aCrushingCritMatrix["Chest"][4] = {};
	aCrushingCritMatrix["Chest"][5] = {};
	aCrushingCritMatrix["Chest"][6] = {};
	aCrushingCritMatrix["Chest"][7] = {};
	aCrushingCritMatrix["Chest"][8] = {};
	aCrushingCritMatrix["Chest"][9] = {};
	aCrushingCritMatrix["Chest"][10] = {};
	aCrushingCritMatrix["Chest"][11] = {};
	aCrushingCritMatrix["Chest"][12] = {};
	aCrushingCritMatrix["Chest"][13] = {};
	aCrushingCritMatrix["Chest"][14] = {};
	aCrushingCritMatrix["Chest"][15] = {};
	aCrushingCritMatrix["Chest"][16] = {};
	aCrushingCritMatrix["Chest"][17] = {};
	aCrushingCritMatrix["Chest"][18] = {};
	aCrushingCritMatrix["Chest"][19] = {};
	aCrushingCritMatrix["Chest"][20] = {};
	aCrushingCritMatrix["Chest"][21] = {};
	aCrushingCritMatrix["Chest"][22] = {};
	aCrushingCritMatrix["Chest"][23] = {};
	aCrushingCritMatrix["Chest"][24] = {};
	
	aCrushingCritMatrix["Side, upper"][1] = {};
	aCrushingCritMatrix["Side, upper"][2] = {};
	aCrushingCritMatrix["Side, upper"][3] = {};
	aCrushingCritMatrix["Side, upper"][4] = {};
	aCrushingCritMatrix["Side, upper"][5] = {};
	aCrushingCritMatrix["Side, upper"][6] = {};
	aCrushingCritMatrix["Side, upper"][7] = {};
	aCrushingCritMatrix["Side, upper"][8] = {};
	aCrushingCritMatrix["Side, upper"][9] = {};
	aCrushingCritMatrix["Side, upper"][10] = {};
	aCrushingCritMatrix["Side, upper"][11] = {};
	aCrushingCritMatrix["Side, upper"][12] = {};
	aCrushingCritMatrix["Side, upper"][13] = {};
	aCrushingCritMatrix["Side, upper"][14] = {};
	aCrushingCritMatrix["Side, upper"][15] = {};
	aCrushingCritMatrix["Side, upper"][16] = {};
	aCrushingCritMatrix["Side, upper"][17] = {};
	aCrushingCritMatrix["Side, upper"][18] = {};
	aCrushingCritMatrix["Side, upper"][19] = {};
	aCrushingCritMatrix["Side, upper"][20] = {};
	aCrushingCritMatrix["Side, upper"][21] = {};
	aCrushingCritMatrix["Side, upper"][22] = {};
	aCrushingCritMatrix["Side, upper"][23] = {};
	aCrushingCritMatrix["Side, upper"][24] = {};
	
	aCrushingCritMatrix["Back, upper"][1] = {};
	aCrushingCritMatrix["Back, upper"][2] = {};
	aCrushingCritMatrix["Back, upper"][3] = {};
	aCrushingCritMatrix["Back, upper"][4] = {};
	aCrushingCritMatrix["Back, upper"][5] = {};
	aCrushingCritMatrix["Back, upper"][6] = {};
	aCrushingCritMatrix["Back, upper"][7] = {};
	aCrushingCritMatrix["Back, upper"][8] = {};
	aCrushingCritMatrix["Back, upper"][9] = {};
	aCrushingCritMatrix["Back, upper"][10] = {};
	aCrushingCritMatrix["Back, upper"][11] = {};
	aCrushingCritMatrix["Back, upper"][12] = {};
	aCrushingCritMatrix["Back, upper"][13] = {};
	aCrushingCritMatrix["Back, upper"][14] = {};
	aCrushingCritMatrix["Back, upper"][15] = {};
	aCrushingCritMatrix["Back, upper"][16] = {};
	aCrushingCritMatrix["Back, upper"][17] = {};
	aCrushingCritMatrix["Back, upper"][18] = {};
	aCrushingCritMatrix["Back, upper"][19] = {};
	aCrushingCritMatrix["Back, upper"][20] = {};
	aCrushingCritMatrix["Back, upper"][21] = {};
	aCrushingCritMatrix["Back, upper"][22] = {};
	aCrushingCritMatrix["Back, upper"][23] = {};
	aCrushingCritMatrix["Back, upper"][24] = {};
	
	aCrushingCritMatrix["Back, upper middle"][1] = {};
	aCrushingCritMatrix["Back, upper middle"][2] = {};
	aCrushingCritMatrix["Back, upper middle"][3] = {};
	aCrushingCritMatrix["Back, upper middle"][4] = {};
	aCrushingCritMatrix["Back, upper middle"][5] = {};
	aCrushingCritMatrix["Back, upper middle"][6] = {};
	aCrushingCritMatrix["Back, upper middle"][7] = {};
	aCrushingCritMatrix["Back, upper middle"][8] = {};
	aCrushingCritMatrix["Back, upper middle"][9] = {};
	aCrushingCritMatrix["Back, upper middle"][10] = {};
	aCrushingCritMatrix["Back, upper middle"][11] = {};
	aCrushingCritMatrix["Back, upper middle"][12] = {};
	aCrushingCritMatrix["Back, upper middle"][13] = {};
	aCrushingCritMatrix["Back, upper middle"][14] = {};
	aCrushingCritMatrix["Back, upper middle"][15] = {};
	aCrushingCritMatrix["Back, upper middle"][16] = {};
	aCrushingCritMatrix["Back, upper middle"][17] = {};
	aCrushingCritMatrix["Back, upper middle"][18] = {};
	aCrushingCritMatrix["Back, upper middle"][19] = {};
	aCrushingCritMatrix["Back, upper middle"][20] = {};
	aCrushingCritMatrix["Back, upper middle"][21] = {};
	aCrushingCritMatrix["Back, upper middle"][22] = {};
	aCrushingCritMatrix["Back, upper middle"][23] = {};
	aCrushingCritMatrix["Back, upper middle"][24] = {};
	
	aCrushingCritMatrix["Armpit"][1] = {};
	aCrushingCritMatrix["Armpit"][2] = {};
	aCrushingCritMatrix["Armpit"][3] = {};
	aCrushingCritMatrix["Armpit"][4] = {};
	aCrushingCritMatrix["Armpit"][5] = {};
	aCrushingCritMatrix["Armpit"][6] = {};
	aCrushingCritMatrix["Armpit"][7] = {};
	aCrushingCritMatrix["Armpit"][8] = {};
	aCrushingCritMatrix["Armpit"][9] = {};
	aCrushingCritMatrix["Armpit"][10] = {};
	aCrushingCritMatrix["Armpit"][11] = {};
	aCrushingCritMatrix["Armpit"][12] = {};
	aCrushingCritMatrix["Armpit"][13] = {};
	aCrushingCritMatrix["Armpit"][14] = {};
	aCrushingCritMatrix["Armpit"][15] = {};
	aCrushingCritMatrix["Armpit"][16] = {};
	aCrushingCritMatrix["Armpit"][17] = {};
	aCrushingCritMatrix["Armpit"][18] = {};
	aCrushingCritMatrix["Armpit"][19] = {};
	aCrushingCritMatrix["Armpit"][20] = {};
	aCrushingCritMatrix["Armpit"][21] = {};
	aCrushingCritMatrix["Armpit"][22] = {};
	aCrushingCritMatrix["Armpit"][23] = {};
	aCrushingCritMatrix["Armpit"][24] = {};
	
	aCrushingCritMatrix["Arm, upper outer"][1] = {};
	aCrushingCritMatrix["Arm, upper outer"][2] = {};
	aCrushingCritMatrix["Arm, upper outer"][3] = {};
	aCrushingCritMatrix["Arm, upper outer"][4] = {};
	aCrushingCritMatrix["Arm, upper outer"][5] = {};
	aCrushingCritMatrix["Arm, upper outer"][6] = {};
	aCrushingCritMatrix["Arm, upper outer"][7] = {};
	aCrushingCritMatrix["Arm, upper outer"][8] = {};
	aCrushingCritMatrix["Arm, upper outer"][9] = {};
	aCrushingCritMatrix["Arm, upper outer"][10] = {};
	aCrushingCritMatrix["Arm, upper outer"][11] = {};
	aCrushingCritMatrix["Arm, upper outer"][12] = {};
	aCrushingCritMatrix["Arm, upper outer"][13] = {};
	aCrushingCritMatrix["Arm, upper outer"][14] = {};
	aCrushingCritMatrix["Arm, upper outer"][15] = {};
	aCrushingCritMatrix["Arm, upper outer"][16] = {};
	aCrushingCritMatrix["Arm, upper outer"][17] = {};
	aCrushingCritMatrix["Arm, upper outer"][18] = {};
	aCrushingCritMatrix["Arm, upper outer"][19] = {};
	aCrushingCritMatrix["Arm, upper outer"][20] = {};
	aCrushingCritMatrix["Arm, upper outer"][21] = {};
	aCrushingCritMatrix["Arm, upper outer"][22] = {};
	aCrushingCritMatrix["Arm, upper outer"][23] = {};
	aCrushingCritMatrix["Arm, upper outer"][24] = {};
	
	aCrushingCritMatrix["Arm, upper inner"][1] = {};
	aCrushingCritMatrix["Arm, upper inner"][2] = {};
	aCrushingCritMatrix["Arm, upper inner"][3] = {};
	aCrushingCritMatrix["Arm, upper inner"][4] = {};
	aCrushingCritMatrix["Arm, upper inner"][5] = {};
	aCrushingCritMatrix["Arm, upper inner"][6] = {};
	aCrushingCritMatrix["Arm, upper inner"][7] = {};
	aCrushingCritMatrix["Arm, upper inner"][8] = {};
	aCrushingCritMatrix["Arm, upper inner"][9] = {};
	aCrushingCritMatrix["Arm, upper inner"][10] = {};
	aCrushingCritMatrix["Arm, upper inner"][11] = {};
	aCrushingCritMatrix["Arm, upper inner"][12] = {};
	aCrushingCritMatrix["Arm, upper inner"][13] = {};
	aCrushingCritMatrix["Arm, upper inner"][14] = {};
	aCrushingCritMatrix["Arm, upper inner"][15] = {};
	aCrushingCritMatrix["Arm, upper inner"][16] = {};
	aCrushingCritMatrix["Arm, upper inner"][17] = {};
	aCrushingCritMatrix["Arm, upper inner"][18] = {};
	aCrushingCritMatrix["Arm, upper inner"][19] = {};
	aCrushingCritMatrix["Arm, upper inner"][20] = {};
	aCrushingCritMatrix["Arm, upper inner"][21] = {};
	aCrushingCritMatrix["Arm, upper inner"][22] = {};
	aCrushingCritMatrix["Arm, upper inner"][23] = {};
	aCrushingCritMatrix["Arm, upper inner"][24] = {};
	
	aCrushingCritMatrix["Elbow"][1] = {};
	aCrushingCritMatrix["Elbow"][2] = {};
	aCrushingCritMatrix["Elbow"][3] = {};
	aCrushingCritMatrix["Elbow"][4] = {};
	aCrushingCritMatrix["Elbow"][5] = {};
	aCrushingCritMatrix["Elbow"][6] = {};
	aCrushingCritMatrix["Elbow"][7] = {};
	aCrushingCritMatrix["Elbow"][8] = {};
	aCrushingCritMatrix["Elbow"][9] = {};
	aCrushingCritMatrix["Elbow"][10] = {};
	aCrushingCritMatrix["Elbow"][11] = {};
	aCrushingCritMatrix["Elbow"][12] = {};
	aCrushingCritMatrix["Elbow"][13] = {};
	aCrushingCritMatrix["Elbow"][14] = {};
	aCrushingCritMatrix["Elbow"][15] = {};
	aCrushingCritMatrix["Elbow"][16] = {};
	aCrushingCritMatrix["Elbow"][17] = {};
	aCrushingCritMatrix["Elbow"][18] = {};
	aCrushingCritMatrix["Elbow"][19] = {};
	aCrushingCritMatrix["Elbow"][20] = {};
	aCrushingCritMatrix["Elbow"][21] = {};
	aCrushingCritMatrix["Elbow"][22] = {};
	aCrushingCritMatrix["Elbow"][23] = {};
	aCrushingCritMatrix["Elbow"][24] = {};
	
	aCrushingCritMatrix["Inner joint"][1] = {};
	aCrushingCritMatrix["Inner joint"][2] = {};
	aCrushingCritMatrix["Inner joint"][3] = {};
	aCrushingCritMatrix["Inner joint"][4] = {};
	aCrushingCritMatrix["Inner joint"][5] = {};
	aCrushingCritMatrix["Inner joint"][6] = {};
	aCrushingCritMatrix["Inner joint"][7] = {};
	aCrushingCritMatrix["Inner joint"][8] = {};
	aCrushingCritMatrix["Inner joint"][9] = {};
	aCrushingCritMatrix["Inner joint"][10] = {};
	aCrushingCritMatrix["Inner joint"][11] = {};
	aCrushingCritMatrix["Inner joint"][12] = {};
	aCrushingCritMatrix["Inner joint"][13] = {};
	aCrushingCritMatrix["Inner joint"][14] = {};
	aCrushingCritMatrix["Inner joint"][15] = {};
	aCrushingCritMatrix["Inner joint"][16] = {};
	aCrushingCritMatrix["Inner joint"][17] = {};
	aCrushingCritMatrix["Inner joint"][18] = {};
	aCrushingCritMatrix["Inner joint"][19] = {};
	aCrushingCritMatrix["Inner joint"][20] = {};
	aCrushingCritMatrix["Inner joint"][21] = {};
	aCrushingCritMatrix["Inner joint"][22] = {};
	aCrushingCritMatrix["Inner joint"][23] = {};
	aCrushingCritMatrix["Inner joint"][24] = {};
	
	aCrushingCritMatrix["Forearm, back"][1] = {};
	aCrushingCritMatrix["Forearm, back"][2] = {};
	aCrushingCritMatrix["Forearm, back"][3] = {};
	aCrushingCritMatrix["Forearm, back"][4] = {};
	aCrushingCritMatrix["Forearm, back"][5] = {};
	aCrushingCritMatrix["Forearm, back"][6] = {};
	aCrushingCritMatrix["Forearm, back"][7] = {};
	aCrushingCritMatrix["Forearm, back"][8] = {};
	aCrushingCritMatrix["Forearm, back"][9] = {};
	aCrushingCritMatrix["Forearm, back"][10] = {};
	aCrushingCritMatrix["Forearm, back"][11] = {};
	aCrushingCritMatrix["Forearm, back"][12] = {};
	aCrushingCritMatrix["Forearm, back"][13] = {};
	aCrushingCritMatrix["Forearm, back"][14] = {};
	aCrushingCritMatrix["Forearm, back"][15] = {};
	aCrushingCritMatrix["Forearm, back"][16] = {};
	aCrushingCritMatrix["Forearm, back"][17] = {};
	aCrushingCritMatrix["Forearm, back"][18] = {};
	aCrushingCritMatrix["Forearm, back"][19] = {};
	aCrushingCritMatrix["Forearm, back"][20] = {};
	aCrushingCritMatrix["Forearm, back"][21] = {};
	aCrushingCritMatrix["Forearm, back"][22] = {};
	aCrushingCritMatrix["Forearm, back"][23] = {};
	aCrushingCritMatrix["Forearm, back"][24] = {};
	
	aCrushingCritMatrix["Forearm, inner"][1] = {};
	aCrushingCritMatrix["Forearm, inner"][2] = {};
	aCrushingCritMatrix["Forearm, inner"][3] = {};
	aCrushingCritMatrix["Forearm, inner"][4] = {};
	aCrushingCritMatrix["Forearm, inner"][5] = {};
	aCrushingCritMatrix["Forearm, inner"][6] = {};
	aCrushingCritMatrix["Forearm, inner"][7] = {};
	aCrushingCritMatrix["Forearm, inner"][8] = {};
	aCrushingCritMatrix["Forearm, inner"][9] = {};
	aCrushingCritMatrix["Forearm, inner"][10] = {};
	aCrushingCritMatrix["Forearm, inner"][11] = {};
	aCrushingCritMatrix["Forearm, inner"][12] = {};
	aCrushingCritMatrix["Forearm, inner"][13] = {};
	aCrushingCritMatrix["Forearm, inner"][14] = {};
	aCrushingCritMatrix["Forearm, inner"][15] = {};
	aCrushingCritMatrix["Forearm, inner"][16] = {};
	aCrushingCritMatrix["Forearm, inner"][17] = {};
	aCrushingCritMatrix["Forearm, inner"][18] = {};
	aCrushingCritMatrix["Forearm, inner"][19] = {};
	aCrushingCritMatrix["Forearm, inner"][20] = {};
	aCrushingCritMatrix["Forearm, inner"][21] = {};
	aCrushingCritMatrix["Forearm, inner"][22] = {};
	aCrushingCritMatrix["Forearm, inner"][23] = {};
	aCrushingCritMatrix["Forearm, inner"][24] = {};
	
	aCrushingCritMatrix["Wrist, back"][1] = {};
	aCrushingCritMatrix["Wrist, back"][2] = {};
	aCrushingCritMatrix["Wrist, back"][3] = {};
	aCrushingCritMatrix["Wrist, back"][4] = {};
	aCrushingCritMatrix["Wrist, back"][5] = {};
	aCrushingCritMatrix["Wrist, back"][6] = {};
	aCrushingCritMatrix["Wrist, back"][7] = {};
	aCrushingCritMatrix["Wrist, back"][8] = {};
	aCrushingCritMatrix["Wrist, back"][9] = {};
	aCrushingCritMatrix["Wrist, back"][10] = {};
	aCrushingCritMatrix["Wrist, back"][11] = {};
	aCrushingCritMatrix["Wrist, back"][12] = {};
	aCrushingCritMatrix["Wrist, back"][13] = {};
	aCrushingCritMatrix["Wrist, back"][14] = {};
	aCrushingCritMatrix["Wrist, back"][15] = {};
	aCrushingCritMatrix["Wrist, back"][16] = {};
	aCrushingCritMatrix["Wrist, back"][17] = {};
	aCrushingCritMatrix["Wrist, back"][18] = {};
	aCrushingCritMatrix["Wrist, back"][19] = {};
	aCrushingCritMatrix["Wrist, back"][20] = {};
	aCrushingCritMatrix["Wrist, back"][21] = {};
	aCrushingCritMatrix["Wrist, back"][22] = {};
	aCrushingCritMatrix["Wrist, back"][23] = {};
	aCrushingCritMatrix["Wrist, back"][24] = {};
	
	aCrushingCritMatrix["Wrist, front"][1] = {};
	aCrushingCritMatrix["Wrist, front"][2] = {};
	aCrushingCritMatrix["Wrist, front"][3] = {};
	aCrushingCritMatrix["Wrist, front"][4] = {};
	aCrushingCritMatrix["Wrist, front"][5] = {};
	aCrushingCritMatrix["Wrist, front"][6] = {};
	aCrushingCritMatrix["Wrist, front"][7] = {};
	aCrushingCritMatrix["Wrist, front"][8] = {};
	aCrushingCritMatrix["Wrist, front"][9] = {};
	aCrushingCritMatrix["Wrist, front"][10] = {};
	aCrushingCritMatrix["Wrist, front"][11] = {};
	aCrushingCritMatrix["Wrist, front"][12] = {};
	aCrushingCritMatrix["Wrist, front"][13] = {};
	aCrushingCritMatrix["Wrist, front"][14] = {};
	aCrushingCritMatrix["Wrist, front"][15] = {};
	aCrushingCritMatrix["Wrist, front"][16] = {};
	aCrushingCritMatrix["Wrist, front"][17] = {};
	aCrushingCritMatrix["Wrist, front"][18] = {};
	aCrushingCritMatrix["Wrist, front"][19] = {};
	aCrushingCritMatrix["Wrist, front"][20] = {};
	aCrushingCritMatrix["Wrist, front"][21] = {};
	aCrushingCritMatrix["Wrist, front"][22] = {};
	aCrushingCritMatrix["Wrist, front"][23] = {};
	aCrushingCritMatrix["Wrist, front"][24] = {};

	aCrushingCritMatrix["Hand, back"][1] = {};
	aCrushingCritMatrix["Hand, back"][2] = {};
	aCrushingCritMatrix["Hand, back"][3] = {};
	aCrushingCritMatrix["Hand, back"][4] = {};
	aCrushingCritMatrix["Hand, back"][5] = {};
	aCrushingCritMatrix["Hand, back"][6] = {};
	aCrushingCritMatrix["Hand, back"][7] = {};
	aCrushingCritMatrix["Hand, back"][8] = {};
	aCrushingCritMatrix["Hand, back"][9] = {};
	aCrushingCritMatrix["Hand, back"][10] = {};
	aCrushingCritMatrix["Hand, back"][11] = {};
	aCrushingCritMatrix["Hand, back"][12] = {};
	aCrushingCritMatrix["Hand, back"][13] = {};
	aCrushingCritMatrix["Hand, back"][14] = {};
	aCrushingCritMatrix["Hand, back"][15] = {};
	aCrushingCritMatrix["Hand, back"][16] = {};
	aCrushingCritMatrix["Hand, back"][17] = {};
	aCrushingCritMatrix["Hand, back"][18] = {};
	aCrushingCritMatrix["Hand, back"][19] = {};
	aCrushingCritMatrix["Hand, back"][20] = {};
	aCrushingCritMatrix["Hand, back"][21] = {};
	aCrushingCritMatrix["Hand, back"][22] = {};
	aCrushingCritMatrix["Hand, back"][23] = {};
	aCrushingCritMatrix["Hand, back"][24] = {};
	
	aCrushingCritMatrix["Palm"][1] = {};
	aCrushingCritMatrix["Palm"][2] = {};
	aCrushingCritMatrix["Palm"][3] = {};
	aCrushingCritMatrix["Palm"][4] = {};
	aCrushingCritMatrix["Palm"][5] = {};
	aCrushingCritMatrix["Palm"][6] = {};
	aCrushingCritMatrix["Palm"][7] = {};
	aCrushingCritMatrix["Palm"][8] = {};
	aCrushingCritMatrix["Palm"][9] = {};
	aCrushingCritMatrix["Palm"][10] = {};
	aCrushingCritMatrix["Palm"][11] = {};
	aCrushingCritMatrix["Palm"][12] = {};
	aCrushingCritMatrix["Palm"][13] = {};
	aCrushingCritMatrix["Palm"][14] = {};
	aCrushingCritMatrix["Palm"][15] = {};
	aCrushingCritMatrix["Palm"][16] = {};
	aCrushingCritMatrix["Palm"][17] = {};
	aCrushingCritMatrix["Palm"][18] = {};
	aCrushingCritMatrix["Palm"][19] = {};
	aCrushingCritMatrix["Palm"][20] = {};
	aCrushingCritMatrix["Palm"][21] = {};
	aCrushingCritMatrix["Palm"][22] = {};
	aCrushingCritMatrix["Palm"][23] = {};
	aCrushingCritMatrix["Palm"][24] = {};
	
	aCrushingCritMatrix["Finger(s)"][1] = {};
	aCrushingCritMatrix["Finger(s)"][2] = {};
	aCrushingCritMatrix["Finger(s)"][3] = {};
	aCrushingCritMatrix["Finger(s)"][4] = {};
	aCrushingCritMatrix["Finger(s)"][5] = {};
	aCrushingCritMatrix["Finger(s)"][6] = {};
	aCrushingCritMatrix["Finger(s)"][7] = {};
	aCrushingCritMatrix["Finger(s)"][8] = {};
	aCrushingCritMatrix["Finger(s)"][9] = {};
	aCrushingCritMatrix["Finger(s)"][10] = {};
	aCrushingCritMatrix["Finger(s)"][11] = {};
	aCrushingCritMatrix["Finger(s)"][12] = {};
	aCrushingCritMatrix["Finger(s)"][13] = {};
	aCrushingCritMatrix["Finger(s)"][14] = {};
	aCrushingCritMatrix["Finger(s)"][15] = {};
	aCrushingCritMatrix["Finger(s)"][16] = {};
	aCrushingCritMatrix["Finger(s)"][17] = {};
	aCrushingCritMatrix["Finger(s)"][18] = {};
	aCrushingCritMatrix["Finger(s)"][19] = {};
	aCrushingCritMatrix["Finger(s)"][20] = {};
	aCrushingCritMatrix["Finger(s)"][21] = {};
	aCrushingCritMatrix["Finger(s)"][22] = {};
	aCrushingCritMatrix["Finger(s)"][23] = {};
	aCrushingCritMatrix["Finger(s)"][24] = {};

	aCrushingCritMatrix["Shoulder, side"][1] = {};
	aCrushingCritMatrix["Shoulder, side"][2] = {};
	aCrushingCritMatrix["Shoulder, side"][3] = {};
	aCrushingCritMatrix["Shoulder, side"][4] = {};
	aCrushingCritMatrix["Shoulder, side"][5] = {};
	aCrushingCritMatrix["Shoulder, side"][6] = {};
	aCrushingCritMatrix["Shoulder, side"][7] = {};
	aCrushingCritMatrix["Shoulder, side"][8] = {};
	aCrushingCritMatrix["Shoulder, side"][9] = {};
	aCrushingCritMatrix["Shoulder, side"][10] = {};
	aCrushingCritMatrix["Shoulder, side"][11] = {};
	aCrushingCritMatrix["Shoulder, side"][12] = {};
	aCrushingCritMatrix["Shoulder, side"][13] = {};
	aCrushingCritMatrix["Shoulder, side"][14] = {};
	aCrushingCritMatrix["Shoulder, side"][15] = {};
	aCrushingCritMatrix["Shoulder, side"][16] = {};
	aCrushingCritMatrix["Shoulder, side"][17] = {};
	aCrushingCritMatrix["Shoulder, side"][18] = {};
	aCrushingCritMatrix["Shoulder, side"][19] = {};
	aCrushingCritMatrix["Shoulder, side"][20] = {};
	aCrushingCritMatrix["Shoulder, side"][21] = {};
	aCrushingCritMatrix["Shoulder, side"][22] = {};
	aCrushingCritMatrix["Shoulder, side"][23] = {};
	aCrushingCritMatrix["Shoulder, side"][24] = {};
	
	aCrushingCritMatrix["Shoulder, top"][1] = {};
	aCrushingCritMatrix["Shoulder, top"][2] = {};
	aCrushingCritMatrix["Shoulder, top"][3] = {};
	aCrushingCritMatrix["Shoulder, top"][4] = {};
	aCrushingCritMatrix["Shoulder, top"][5] = {};
	aCrushingCritMatrix["Shoulder, top"][6] = {};
	aCrushingCritMatrix["Shoulder, top"][7] = {};
	aCrushingCritMatrix["Shoulder, top"][8] = {};
	aCrushingCritMatrix["Shoulder, top"][9] = {};
	aCrushingCritMatrix["Shoulder, top"][10] = {};
	aCrushingCritMatrix["Shoulder, top"][11] = {};
	aCrushingCritMatrix["Shoulder, top"][12] = {};
	aCrushingCritMatrix["Shoulder, top"][13] = {};
	aCrushingCritMatrix["Shoulder, top"][14] = {};
	aCrushingCritMatrix["Shoulder, top"][15] = {};
	aCrushingCritMatrix["Shoulder, top"][16] = {};
	aCrushingCritMatrix["Shoulder, top"][17] = {};
	aCrushingCritMatrix["Shoulder, top"][18] = {};
	aCrushingCritMatrix["Shoulder, top"][19] = {};
	aCrushingCritMatrix["Shoulder, top"][20] = {};
	aCrushingCritMatrix["Shoulder, top"][21] = {};
	aCrushingCritMatrix["Shoulder, top"][22] = {};
	aCrushingCritMatrix["Shoulder, top"][23] = {};
	aCrushingCritMatrix["Shoulder, top"][24] = {};
	
	aCrushingCritMatrix["Neck, back"][1] = {};
	aCrushingCritMatrix["Neck, back"][2] = {};
	aCrushingCritMatrix["Neck, back"][3] = {};
	aCrushingCritMatrix["Neck, back"][4] = {};
	aCrushingCritMatrix["Neck, back"][5] = {};
	aCrushingCritMatrix["Neck, back"][6] = {};
	aCrushingCritMatrix["Neck, back"][7] = {};
	aCrushingCritMatrix["Neck, back"][8] = {};
	aCrushingCritMatrix["Neck, back"][9] = {};
	aCrushingCritMatrix["Neck, back"][10] = {};
	aCrushingCritMatrix["Neck, back"][11] = {};
	aCrushingCritMatrix["Neck, back"][12] = {};
	aCrushingCritMatrix["Neck, back"][13] = {};
	aCrushingCritMatrix["Neck, back"][14] = {};
	aCrushingCritMatrix["Neck, back"][15] = {};
	aCrushingCritMatrix["Neck, back"][16] = {};
	aCrushingCritMatrix["Neck, back"][17] = {};
	aCrushingCritMatrix["Neck, back"][18] = {};
	aCrushingCritMatrix["Neck, back"][19] = {};
	aCrushingCritMatrix["Neck, back"][20] = {};
	aCrushingCritMatrix["Neck, back"][21] = {};
	aCrushingCritMatrix["Neck, back"][22] = {};
	aCrushingCritMatrix["Neck, back"][23] = {};
	aCrushingCritMatrix["Neck, back"][24] = {};
	
	aCrushingCritMatrix["Neck, back"][1] = {};
	aCrushingCritMatrix["Neck, back"][2] = {};
	aCrushingCritMatrix["Neck, back"][3] = {};
	aCrushingCritMatrix["Neck, back"][4] = {};
	aCrushingCritMatrix["Neck, back"][5] = {};
	aCrushingCritMatrix["Neck, back"][6] = {};
	aCrushingCritMatrix["Neck, back"][7] = {};
	aCrushingCritMatrix["Neck, back"][8] = {};
	aCrushingCritMatrix["Neck, back"][9] = {};
	aCrushingCritMatrix["Neck, back"][10] = {};
	aCrushingCritMatrix["Neck, back"][11] = {};
	aCrushingCritMatrix["Neck, back"][12] = {};
	aCrushingCritMatrix["Neck, back"][13] = {};
	aCrushingCritMatrix["Neck, back"][14] = {};
	aCrushingCritMatrix["Neck, back"][15] = {};
	aCrushingCritMatrix["Neck, back"][16] = {};
	aCrushingCritMatrix["Neck, back"][17] = {};
	aCrushingCritMatrix["Neck, back"][18] = {};
	aCrushingCritMatrix["Neck, back"][19] = {};
	aCrushingCritMatrix["Neck, back"][20] = {};
	aCrushingCritMatrix["Neck, back"][21] = {};
	aCrushingCritMatrix["Neck, back"][22] = {};
	aCrushingCritMatrix["Neck, back"][23] = {};
	aCrushingCritMatrix["Neck, back"][24] = {};
	
	aCrushingCritMatrix["Neck, side"][1] = {};
	aCrushingCritMatrix["Neck, side"][2] = {};
	aCrushingCritMatrix["Neck, side"][3] = {};
	aCrushingCritMatrix["Neck, side"][4] = {};
	aCrushingCritMatrix["Neck, side"][5] = {};
	aCrushingCritMatrix["Neck, side"][6] = {};
	aCrushingCritMatrix["Neck, side"][7] = {};
	aCrushingCritMatrix["Neck, side"][8] = {};
	aCrushingCritMatrix["Neck, side"][9] = {};
	aCrushingCritMatrix["Neck, side"][10] = {};
	aCrushingCritMatrix["Neck, side"][11] = {};
	aCrushingCritMatrix["Neck, side"][12] = {};
	aCrushingCritMatrix["Neck, side"][13] = {};
	aCrushingCritMatrix["Neck, side"][14] = {};
	aCrushingCritMatrix["Neck, side"][15] = {};
	aCrushingCritMatrix["Neck, side"][16] = {};
	aCrushingCritMatrix["Neck, side"][17] = {};
	aCrushingCritMatrix["Neck, side"][18] = {};
	aCrushingCritMatrix["Neck, side"][19] = {};
	aCrushingCritMatrix["Neck, side"][20] = {};
	aCrushingCritMatrix["Neck, side"][21] = {};
	aCrushingCritMatrix["Neck, side"][22] = {};
	aCrushingCritMatrix["Neck, side"][23] = {};
	aCrushingCritMatrix["Neck, side"][24] = {};

	aCrushingCritMatrix["Head, side"][1] = {};
	aCrushingCritMatrix["Head, side"][2] = {};
	aCrushingCritMatrix["Head, side"][3] = {};
	aCrushingCritMatrix["Head, side"][4] = {};
	aCrushingCritMatrix["Head, side"][5] = {};
	aCrushingCritMatrix["Head, side"][6] = {};
	aCrushingCritMatrix["Head, side"][7] = {};
	aCrushingCritMatrix["Head, side"][8] = {};
	aCrushingCritMatrix["Head, side"][9] = {};
	aCrushingCritMatrix["Head, side"][10] = {};
	aCrushingCritMatrix["Head, side"][11] = {};
	aCrushingCritMatrix["Head, side"][12] = {};
	aCrushingCritMatrix["Head, side"][13] = {};
	aCrushingCritMatrix["Head, side"][14] = {};
	aCrushingCritMatrix["Head, side"][15] = {};
	aCrushingCritMatrix["Head, side"][16] = {};
	aCrushingCritMatrix["Head, side"][17] = {};
	aCrushingCritMatrix["Head, side"][18] = {};
	aCrushingCritMatrix["Head, side"][19] = {};
	aCrushingCritMatrix["Head, side"][20] = {};
	aCrushingCritMatrix["Head, side"][21] = {};
	aCrushingCritMatrix["Head, side"][22] = {};
	aCrushingCritMatrix["Head, side"][23] = {};
	aCrushingCritMatrix["Head, side"][24] = {};
	
	aCrushingCritMatrix["Head, back lower"][1] = {};
	aCrushingCritMatrix["Head, back lower"][2] = {};
	aCrushingCritMatrix["Head, back lower"][3] = {};
	aCrushingCritMatrix["Head, back lower"][4] = {};
	aCrushingCritMatrix["Head, back lower"][5] = {};
	aCrushingCritMatrix["Head, back lower"][6] = {};
	aCrushingCritMatrix["Head, back lower"][7] = {};
	aCrushingCritMatrix["Head, back lower"][8] = {};
	aCrushingCritMatrix["Head, back lower"][9] = {};
	aCrushingCritMatrix["Head, back lower"][10] = {};
	aCrushingCritMatrix["Head, back lower"][11] = {};
	aCrushingCritMatrix["Head, back lower"][12] = {};
	aCrushingCritMatrix["Head, back lower"][13] = {};
	aCrushingCritMatrix["Head, back lower"][14] = {};
	aCrushingCritMatrix["Head, back lower"][15] = {};
	aCrushingCritMatrix["Head, back lower"][16] = {};
	aCrushingCritMatrix["Head, back lower"][17] = {};
	aCrushingCritMatrix["Head, back lower"][18] = {};
	aCrushingCritMatrix["Head, back lower"][19] = {};
	aCrushingCritMatrix["Head, back lower"][20] = {};
	aCrushingCritMatrix["Head, back lower"][21] = {};
	aCrushingCritMatrix["Head, back lower"][22] = {};
	aCrushingCritMatrix["Head, back lower"][23] = {};
	aCrushingCritMatrix["Head, back lower"][24] = {};
	
	aCrushingCritMatrix["Face, lower side"][1] = {};
	aCrushingCritMatrix["Face, lower side"][2] = {};
	aCrushingCritMatrix["Face, lower side"][3] = {};
	aCrushingCritMatrix["Face, lower side"][4] = {};
	aCrushingCritMatrix["Face, lower side"][5] = {};
	aCrushingCritMatrix["Face, lower side"][6] = {};
	aCrushingCritMatrix["Face, lower side"][7] = {};
	aCrushingCritMatrix["Face, lower side"][8] = {};
	aCrushingCritMatrix["Face, lower side"][9] = {};
	aCrushingCritMatrix["Face, lower side"][10] = {};
	aCrushingCritMatrix["Face, lower side"][11] = {};
	aCrushingCritMatrix["Face, lower side"][12] = {};
	aCrushingCritMatrix["Face, lower side"][13] = {};
	aCrushingCritMatrix["Face, lower side"][14] = {};
	aCrushingCritMatrix["Face, lower side"][15] = {};
	aCrushingCritMatrix["Face, lower side"][16] = {};
	aCrushingCritMatrix["Face, lower side"][17] = {};
	aCrushingCritMatrix["Face, lower side"][18] = {};
	aCrushingCritMatrix["Face, lower side"][19] = {};
	aCrushingCritMatrix["Face, lower side"][20] = {};
	aCrushingCritMatrix["Face, lower side"][21] = {};
	aCrushingCritMatrix["Face, lower side"][22] = {};
	aCrushingCritMatrix["Face, lower side"][23] = {};
	aCrushingCritMatrix["Face, lower side"][24] = {};

	aCrushingCritMatrix["Face, lower center"][1] = {};
	aCrushingCritMatrix["Face, lower center"][2] = {};
	aCrushingCritMatrix["Face, lower center"][3] = {};
	aCrushingCritMatrix["Face, lower center"][4] = {};
	aCrushingCritMatrix["Face, lower center"][5] = {};
	aCrushingCritMatrix["Face, lower center"][6] = {};
	aCrushingCritMatrix["Face, lower center"][7] = {};
	aCrushingCritMatrix["Face, lower center"][8] = {};
	aCrushingCritMatrix["Face, lower center"][9] = {};
	aCrushingCritMatrix["Face, lower center"][10] = {};
	aCrushingCritMatrix["Face, lower center"][11] = {};
	aCrushingCritMatrix["Face, lower center"][12] = {};
	aCrushingCritMatrix["Face, lower center"][13] = {};
	aCrushingCritMatrix["Face, lower center"][14] = {};
	aCrushingCritMatrix["Face, lower center"][15] = {};
	aCrushingCritMatrix["Face, lower center"][16] = {};
	aCrushingCritMatrix["Face, lower center"][17] = {};
	aCrushingCritMatrix["Face, lower center"][18] = {};
	aCrushingCritMatrix["Face, lower center"][19] = {};
	aCrushingCritMatrix["Face, lower center"][20] = {};
	aCrushingCritMatrix["Face, lower center"][21] = {};
	aCrushingCritMatrix["Face, lower center"][22] = {};
	aCrushingCritMatrix["Face, lower center"][23] = {};
	aCrushingCritMatrix["Face, lower center"][24] = {};
	
	aCrushingCritMatrix["Head, back upper"][1] = {};
	aCrushingCritMatrix["Head, back upper"][2] = {};
	aCrushingCritMatrix["Head, back upper"][3] = {};
	aCrushingCritMatrix["Head, back upper"][4] = {};
	aCrushingCritMatrix["Head, back upper"][5] = {};
	aCrushingCritMatrix["Head, back upper"][6] = {};
	aCrushingCritMatrix["Head, back upper"][7] = {};
	aCrushingCritMatrix["Head, back upper"][8] = {};
	aCrushingCritMatrix["Head, back upper"][9] = {};
	aCrushingCritMatrix["Head, back upper"][10] = {};
	aCrushingCritMatrix["Head, back upper"][11] = {};
	aCrushingCritMatrix["Head, back upper"][12] = {};
	aCrushingCritMatrix["Head, back upper"][13] = {};
	aCrushingCritMatrix["Head, back upper"][14] = {};
	aCrushingCritMatrix["Head, back upper"][15] = {};
	aCrushingCritMatrix["Head, back upper"][16] = {};
	aCrushingCritMatrix["Head, back upper"][17] = {};
	aCrushingCritMatrix["Head, back upper"][18] = {};
	aCrushingCritMatrix["Head, back upper"][19] = {};
	aCrushingCritMatrix["Head, back upper"][20] = {};
	aCrushingCritMatrix["Head, back upper"][21] = {};
	aCrushingCritMatrix["Head, back upper"][22] = {};
	aCrushingCritMatrix["Head, back upper"][23] = {};
	aCrushingCritMatrix["Head, back upper"][24] = {};
	
	aCrushingCritMatrix["Face, upper side"][1] = {};
	aCrushingCritMatrix["Face, upper side"][2] = {};
	aCrushingCritMatrix["Face, upper side"][3] = {};
	aCrushingCritMatrix["Face, upper side"][4] = {};
	aCrushingCritMatrix["Face, upper side"][5] = {};
	aCrushingCritMatrix["Face, upper side"][6] = {};
	aCrushingCritMatrix["Face, upper side"][7] = {};
	aCrushingCritMatrix["Face, upper side"][8] = {};
	aCrushingCritMatrix["Face, upper side"][9] = {};
	aCrushingCritMatrix["Face, upper side"][10] = {};
	aCrushingCritMatrix["Face, upper side"][11] = {};
	aCrushingCritMatrix["Face, upper side"][12] = {};
	aCrushingCritMatrix["Face, upper side"][13] = {};
	aCrushingCritMatrix["Face, upper side"][14] = {};
	aCrushingCritMatrix["Face, upper side"][15] = {};
	aCrushingCritMatrix["Face, upper side"][16] = {};
	aCrushingCritMatrix["Face, upper side"][17] = {};
	aCrushingCritMatrix["Face, upper side"][18] = {};
	aCrushingCritMatrix["Face, upper side"][19] = {};
	aCrushingCritMatrix["Face, upper side"][20] = {};
	aCrushingCritMatrix["Face, upper side"][21] = {};
	aCrushingCritMatrix["Face, upper side"][22] = {};
	aCrushingCritMatrix["Face, upper side"][23] = {};
	aCrushingCritMatrix["Face, upper side"][24] = {};
	
	aCrushingCritMatrix["Face, upper center"][1] = {};
	aCrushingCritMatrix["Face, upper center"][2] = {};
	aCrushingCritMatrix["Face, upper center"][3] = {};
	aCrushingCritMatrix["Face, upper center"][4] = {};
	aCrushingCritMatrix["Face, upper center"][5] = {};
	aCrushingCritMatrix["Face, upper center"][6] = {};
	aCrushingCritMatrix["Face, upper center"][7] = {};
	aCrushingCritMatrix["Face, upper center"][8] = {};
	aCrushingCritMatrix["Face, upper center"][9] = {};
	aCrushingCritMatrix["Face, upper center"][10] = {};
	aCrushingCritMatrix["Face, upper center"][11] = {};
	aCrushingCritMatrix["Face, upper center"][12] = {};
	aCrushingCritMatrix["Face, upper center"][13] = {};
	aCrushingCritMatrix["Face, upper center"][14] = {};
	aCrushingCritMatrix["Face, upper center"][15] = {};
	aCrushingCritMatrix["Face, upper center"][16] = {};
	aCrushingCritMatrix["Face, upper center"][17] = {};
	aCrushingCritMatrix["Face, upper center"][18] = {};
	aCrushingCritMatrix["Face, upper center"][19] = {};
	aCrushingCritMatrix["Face, upper center"][20] = {};
	aCrushingCritMatrix["Face, upper center"][21] = {};
	aCrushingCritMatrix["Face, upper center"][22] = {};
	aCrushingCritMatrix["Face, upper center"][23] = {};
	aCrushingCritMatrix["Face, upper center"][24] = {};
	
	aCrushingCritMatrix["Head, top"][1] = {};
	aCrushingCritMatrix["Head, top"][2] = {};
	aCrushingCritMatrix["Head, top"][3] = {};
	aCrushingCritMatrix["Head, top"][4] = {};
	aCrushingCritMatrix["Head, top"][5] = {};
	aCrushingCritMatrix["Head, top"][6] = {};
	aCrushingCritMatrix["Head, top"][7] = {};
	aCrushingCritMatrix["Head, top"][8] = {};
	aCrushingCritMatrix["Head, top"][9] = {};
	aCrushingCritMatrix["Head, top"][10] = {};
	aCrushingCritMatrix["Head, top"][11] = {};
	aCrushingCritMatrix["Head, top"][12] = {};
	aCrushingCritMatrix["Head, top"][13] = {};
	aCrushingCritMatrix["Head, top"][14] = {};
	aCrushingCritMatrix["Head, top"][15] = {};
	aCrushingCritMatrix["Head, top"][16] = {};
	aCrushingCritMatrix["Head, top"][17] = {};
	aCrushingCritMatrix["Head, top"][18] = {};
	aCrushingCritMatrix["Head, top"][19] = {};
	aCrushingCritMatrix["Head, top"][20] = {};
	aCrushingCritMatrix["Head, top"][21] = {};
	aCrushingCritMatrix["Head, top"][22] = {};
	aCrushingCritMatrix["Head, top"][23] = {};
	aCrushingCritMatrix["Head, top"][24] = {};
end

function buildPuncturingCritMatrix()

	aPuncturingCritMatrix["Foot, top"][1] = {};
	aPuncturingCritMatrix["Foot, top"][2] = {};
	aPuncturingCritMatrix["Foot, top"][3] = {};
	aPuncturingCritMatrix["Foot, top"][4] = {};
	aPuncturingCritMatrix["Foot, top"][5] = {};
	aPuncturingCritMatrix["Foot, top"][6] = {};
	aPuncturingCritMatrix["Foot, top"][7] = {};
	aPuncturingCritMatrix["Foot, top"][8] = {};
	aPuncturingCritMatrix["Foot, top"][9] = {};
	aPuncturingCritMatrix["Foot, top"][10] = {};
	aPuncturingCritMatrix["Foot, top"][11] = {};
	aPuncturingCritMatrix["Foot, top"][12] = {};
	aPuncturingCritMatrix["Foot, top"][13] = {};
	aPuncturingCritMatrix["Foot, top"][14] = {};
	aPuncturingCritMatrix["Foot, top"][15] = {};
	aPuncturingCritMatrix["Foot, top"][16] = {};
	aPuncturingCritMatrix["Foot, top"][17] = {};
	aPuncturingCritMatrix["Foot, top"][18] = {};
	aPuncturingCritMatrix["Foot, top"][19] = {};
	aPuncturingCritMatrix["Foot, top"][20] = {};
	aPuncturingCritMatrix["Foot, top"][21] = {};
	aPuncturingCritMatrix["Foot, top"][22] = {};
	aPuncturingCritMatrix["Foot, top"][23] = {};
	aPuncturingCritMatrix["Foot, top"][24] = {};
	
	aPuncturingCritMatrix["Heel"][1] = {};
	aPuncturingCritMatrix["Heel"][2] = {};
	aPuncturingCritMatrix["Heel"][3] = {};
	aPuncturingCritMatrix["Heel"][4] = {};
	aPuncturingCritMatrix["Heel"][5] = {};
	aPuncturingCritMatrix["Heel"][6] = {};
	aPuncturingCritMatrix["Heel"][7] = {};
	aPuncturingCritMatrix["Heel"][8] = {};
	aPuncturingCritMatrix["Heel"][9] = {};
	aPuncturingCritMatrix["Heel"][10] = {};
	aPuncturingCritMatrix["Heel"][11] = {};
	aPuncturingCritMatrix["Heel"][12] = {};
	aPuncturingCritMatrix["Heel"][13] = {};
	aPuncturingCritMatrix["Heel"][14] = {};
	aPuncturingCritMatrix["Heel"][15] = {};
	aPuncturingCritMatrix["Heel"][16] = {};
	aPuncturingCritMatrix["Heel"][17] = {};
	aPuncturingCritMatrix["Heel"][18] = {};
	aPuncturingCritMatrix["Heel"][19] = {};
	aPuncturingCritMatrix["Heel"][20] = {};
	aPuncturingCritMatrix["Heel"][21] = {};
	aPuncturingCritMatrix["Heel"][22] = {};
	aPuncturingCritMatrix["Heel"][23] = {};
	aPuncturingCritMatrix["Heel"][24] = {};

	aPuncturingCritMatrix["Toe(s)"][1] = {};
	aPuncturingCritMatrix["Toe(s)"][2] = {};
	aPuncturingCritMatrix["Toe(s)"][3] = {};
	aPuncturingCritMatrix["Toe(s)"][4] = {};
	aPuncturingCritMatrix["Toe(s)"][5] = {};
	aPuncturingCritMatrix["Toe(s)"][6] = {};
	aPuncturingCritMatrix["Toe(s)"][7] = {};
	aPuncturingCritMatrix["Toe(s)"][8] = {};
	aPuncturingCritMatrix["Toe(s)"][9] = {};
	aPuncturingCritMatrix["Toe(s)"][10] = {};
	aPuncturingCritMatrix["Toe(s)"][11] = {};
	aPuncturingCritMatrix["Toe(s)"][12] = {};
	aPuncturingCritMatrix["Toe(s)"][13] = {};
	aPuncturingCritMatrix["Toe(s)"][14] = {};
	aPuncturingCritMatrix["Toe(s)"][15] = {};
	aPuncturingCritMatrix["Toe(s)"][16] = {};
	aPuncturingCritMatrix["Toe(s)"][17] = {};
	aPuncturingCritMatrix["Toe(s)"][18] = {};
	aPuncturingCritMatrix["Toe(s)"][19] = {};
	aPuncturingCritMatrix["Toe(s)"][20] = {};
	aPuncturingCritMatrix["Toe(s)"][21] = {};
	aPuncturingCritMatrix["Toe(s)"][22] = {};
	aPuncturingCritMatrix["Toe(s)"][23] = {};
	aPuncturingCritMatrix["Toe(s)"][24] = {};
	
	aPuncturingCritMatrix["Foot, arch"][1] = {};
	aPuncturingCritMatrix["Foot, arch"][2] = {};
	aPuncturingCritMatrix["Foot, arch"][3] = {};
	aPuncturingCritMatrix["Foot, arch"][4] = {};
	aPuncturingCritMatrix["Foot, arch"][5] = {};
	aPuncturingCritMatrix["Foot, arch"][6] = {};
	aPuncturingCritMatrix["Foot, arch"][7] = {};
	aPuncturingCritMatrix["Foot, arch"][8] = {};
	aPuncturingCritMatrix["Foot, arch"][9] = {};
	aPuncturingCritMatrix["Foot, arch"][10] = {};
	aPuncturingCritMatrix["Foot, arch"][11] = {};
	aPuncturingCritMatrix["Foot, arch"][12] = {};
	aPuncturingCritMatrix["Foot, arch"][13] = {};
	aPuncturingCritMatrix["Foot, arch"][14] = {};
	aPuncturingCritMatrix["Foot, arch"][15] = {};
	aPuncturingCritMatrix["Foot, arch"][16] = {};
	aPuncturingCritMatrix["Foot, arch"][17] = {};
	aPuncturingCritMatrix["Foot, arch"][18] = {};
	aPuncturingCritMatrix["Foot, arch"][19] = {};
	aPuncturingCritMatrix["Foot, arch"][20] = {};
	aPuncturingCritMatrix["Foot, arch"][21] = {};
	aPuncturingCritMatrix["Foot, arch"][22] = {};
	aPuncturingCritMatrix["Foot, arch"][23] = {};
	aPuncturingCritMatrix["Foot, arch"][24] = {};
	
	aPuncturingCritMatrix["Ankle, inner"][1] = {};
	aPuncturingCritMatrix["Ankle, inner"][2] = {};
	aPuncturingCritMatrix["Ankle, inner"][3] = {};
	aPuncturingCritMatrix["Ankle, inner"][4] = {};
	aPuncturingCritMatrix["Ankle, inner"][5] = {};
	aPuncturingCritMatrix["Ankle, inner"][6] = {};
	aPuncturingCritMatrix["Ankle, inner"][7] = {};
	aPuncturingCritMatrix["Ankle, inner"][8] = {};
	aPuncturingCritMatrix["Ankle, inner"][9] = {};
	aPuncturingCritMatrix["Ankle, inner"][10] = {};
	aPuncturingCritMatrix["Ankle, inner"][11] = {};
	aPuncturingCritMatrix["Ankle, inner"][12] = {};
	aPuncturingCritMatrix["Ankle, inner"][13] = {};
	aPuncturingCritMatrix["Ankle, inner"][14] = {};
	aPuncturingCritMatrix["Ankle, inner"][15] = {};
	aPuncturingCritMatrix["Ankle, inner"][16] = {};
	aPuncturingCritMatrix["Ankle, inner"][17] = {};
	aPuncturingCritMatrix["Ankle, inner"][18] = {};
	aPuncturingCritMatrix["Ankle, inner"][19] = {};
	aPuncturingCritMatrix["Ankle, inner"][20] = {};
	aPuncturingCritMatrix["Ankle, inner"][21] = {};
	aPuncturingCritMatrix["Ankle, inner"][22] = {};
	aPuncturingCritMatrix["Ankle, inner"][23] = {};
	aPuncturingCritMatrix["Ankle, inner"][24] = {};
	
	aPuncturingCritMatrix["Ankle, outer"][1] = {};
	aPuncturingCritMatrix["Ankle, outer"][2] = {};
	aPuncturingCritMatrix["Ankle, outer"][3] = {};
	aPuncturingCritMatrix["Ankle, outer"][4] = {};
	aPuncturingCritMatrix["Ankle, outer"][5] = {};
	aPuncturingCritMatrix["Ankle, outer"][6] = {};
	aPuncturingCritMatrix["Ankle, outer"][7] = {};
	aPuncturingCritMatrix["Ankle, outer"][8] = {};
	aPuncturingCritMatrix["Ankle, outer"][9] = {};
	aPuncturingCritMatrix["Ankle, outer"][10] = {};
	aPuncturingCritMatrix["Ankle, outer"][11] = {};
	aPuncturingCritMatrix["Ankle, outer"][12] = {};
	aPuncturingCritMatrix["Ankle, outer"][13] = {};
	aPuncturingCritMatrix["Ankle, outer"][14] = {};
	aPuncturingCritMatrix["Ankle, outer"][15] = {};
	aPuncturingCritMatrix["Ankle, outer"][16] = {};
	aPuncturingCritMatrix["Ankle, outer"][17] = {};
	aPuncturingCritMatrix["Ankle, outer"][18] = {};
	aPuncturingCritMatrix["Ankle, outer"][19] = {};
	aPuncturingCritMatrix["Ankle, outer"][20] = {};
	aPuncturingCritMatrix["Ankle, outer"][21] = {};
	aPuncturingCritMatrix["Ankle, outer"][22] = {};
	aPuncturingCritMatrix["Ankle, outer"][23] = {};
	aPuncturingCritMatrix["Ankle, outer"][24] = {};
	
	aPuncturingCritMatrix["Ankle, upper/Achilles"][1] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][2] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][3] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][4] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][5] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][6] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][7] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][8] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][9] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][10] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][11] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][12] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][13] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][14] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][15] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][16] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][17] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][18] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][19] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][20] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][21] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][22] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][23] = {};
	aPuncturingCritMatrix["Ankle, upper/Achilles"][24] = {};
	
	aPuncturingCritMatrix["Shin"][1] = {};
	aPuncturingCritMatrix["Shin"][2] = {};
	aPuncturingCritMatrix["Shin"][3] = {};
	aPuncturingCritMatrix["Shin"][4] = {};
	aPuncturingCritMatrix["Shin"][5] = {};
	aPuncturingCritMatrix["Shin"][6] = {};
	aPuncturingCritMatrix["Shin"][7] = {};
	aPuncturingCritMatrix["Shin"][8] = {};
	aPuncturingCritMatrix["Shin"][9] = {};
	aPuncturingCritMatrix["Shin"][10] = {};
	aPuncturingCritMatrix["Shin"][11] = {};
	aPuncturingCritMatrix["Shin"][12] = {};
	aPuncturingCritMatrix["Shin"][13] = {};
	aPuncturingCritMatrix["Shin"][14] = {};
	aPuncturingCritMatrix["Shin"][15] = {};
	aPuncturingCritMatrix["Shin"][16] = {};
	aPuncturingCritMatrix["Shin"][17] = {};
	aPuncturingCritMatrix["Shin"][18] = {};
	aPuncturingCritMatrix["Shin"][19] = {};
	aPuncturingCritMatrix["Shin"][20] = {};
	aPuncturingCritMatrix["Shin"][21] = {};
	aPuncturingCritMatrix["Shin"][22] = {};
	aPuncturingCritMatrix["Shin"][23] = {};
	aPuncturingCritMatrix["Shin"][24] = {};

	aPuncturingCritMatrix["Calf"][1] = {};
	aPuncturingCritMatrix["Calf"][2] = {};
	aPuncturingCritMatrix["Calf"][3] = {};
	aPuncturingCritMatrix["Calf"][4] = {};
	aPuncturingCritMatrix["Calf"][5] = {};
	aPuncturingCritMatrix["Calf"][6] = {};
	aPuncturingCritMatrix["Calf"][7] = {};
	aPuncturingCritMatrix["Calf"][8] = {};
	aPuncturingCritMatrix["Calf"][9] = {};
	aPuncturingCritMatrix["Calf"][10] = {};
	aPuncturingCritMatrix["Calf"][11] = {};
	aPuncturingCritMatrix["Calf"][12] = {};
	aPuncturingCritMatrix["Calf"][13] = {};
	aPuncturingCritMatrix["Calf"][14] = {};
	aPuncturingCritMatrix["Calf"][15] = {};
	aPuncturingCritMatrix["Calf"][16] = {};
	aPuncturingCritMatrix["Calf"][17] = {};
	aPuncturingCritMatrix["Calf"][18] = {};
	aPuncturingCritMatrix["Calf"][19] = {};
	aPuncturingCritMatrix["Calf"][20] = {};
	aPuncturingCritMatrix["Calf"][21] = {};
	aPuncturingCritMatrix["Calf"][22] = {};
	aPuncturingCritMatrix["Calf"][23] = {};
	aPuncturingCritMatrix["Calf"][24] = {};

	aPuncturingCritMatrix["Knee"][1] = {};
	aPuncturingCritMatrix["Knee"][2] = {};
	aPuncturingCritMatrix["Knee"][3] = {};
	aPuncturingCritMatrix["Knee"][4] = {};
	aPuncturingCritMatrix["Knee"][5] = {};
	aPuncturingCritMatrix["Knee"][6] = {};
	aPuncturingCritMatrix["Knee"][7] = {};
	aPuncturingCritMatrix["Knee"][8] = {};
	aPuncturingCritMatrix["Knee"][9] = {};
	aPuncturingCritMatrix["Knee"][10] = {};
	aPuncturingCritMatrix["Knee"][11] = {};
	aPuncturingCritMatrix["Knee"][12] = {};
	aPuncturingCritMatrix["Knee"][13] = {};
	aPuncturingCritMatrix["Knee"][14] = {};
	aPuncturingCritMatrix["Knee"][15] = {};
	aPuncturingCritMatrix["Knee"][16] = {};
	aPuncturingCritMatrix["Knee"][17] = {};
	aPuncturingCritMatrix["Knee"][18] = {};
	aPuncturingCritMatrix["Knee"][19] = {};
	aPuncturingCritMatrix["Knee"][20] = {};
	aPuncturingCritMatrix["Knee"][21] = {};
	aPuncturingCritMatrix["Knee"][22] = {};
	aPuncturingCritMatrix["Knee"][23] = {};
	aPuncturingCritMatrix["Knee"][24] = {};
		
	aPuncturingCritMatrix["Knee, back"][1] = {};
	aPuncturingCritMatrix["Knee, back"][2] = {};
	aPuncturingCritMatrix["Knee, back"][3] = {};
	aPuncturingCritMatrix["Knee, back"][4] = {};
	aPuncturingCritMatrix["Knee, back"][5] = {};
	aPuncturingCritMatrix["Knee, back"][6] = {};
	aPuncturingCritMatrix["Knee, back"][7] = {};
	aPuncturingCritMatrix["Knee, back"][8] = {};
	aPuncturingCritMatrix["Knee, back"][9] = {};
	aPuncturingCritMatrix["Knee, back"][10] = {};
	aPuncturingCritMatrix["Knee, back"][11] = {};
	aPuncturingCritMatrix["Knee, back"][12] = {};
	aPuncturingCritMatrix["Knee, back"][13] = {};
	aPuncturingCritMatrix["Knee, back"][14] = {};
	aPuncturingCritMatrix["Knee, back"][15] = {};
	aPuncturingCritMatrix["Knee, back"][16] = {};
	aPuncturingCritMatrix["Knee, back"][17] = {};
	aPuncturingCritMatrix["Knee, back"][18] = {};
	aPuncturingCritMatrix["Knee, back"][19] = {};
	aPuncturingCritMatrix["Knee, back"][20] = {};
	aPuncturingCritMatrix["Knee, back"][21] = {};
	aPuncturingCritMatrix["Knee, back"][22] = {};
	aPuncturingCritMatrix["Knee, back"][23] = {};
	aPuncturingCritMatrix["Knee, back"][24] = {};
	
	aPuncturingCritMatrix["Hamstring"][1] = {};
	aPuncturingCritMatrix["Hamstring"][2] = {};
	aPuncturingCritMatrix["Hamstring"][3] = {};
	aPuncturingCritMatrix["Hamstring"][4] = {};
	aPuncturingCritMatrix["Hamstring"][5] = {};
	aPuncturingCritMatrix["Hamstring"][6] = {};
	aPuncturingCritMatrix["Hamstring"][7] = {};
	aPuncturingCritMatrix["Hamstring"][8] = {};
	aPuncturingCritMatrix["Hamstring"][9] = {};
	aPuncturingCritMatrix["Hamstring"][10] = {};
	aPuncturingCritMatrix["Hamstring"][11] = {};
	aPuncturingCritMatrix["Hamstring"][12] = {};
	aPuncturingCritMatrix["Hamstring"][13] = {};
	aPuncturingCritMatrix["Hamstring"][14] = {};
	aPuncturingCritMatrix["Hamstring"][15] = {};
	aPuncturingCritMatrix["Hamstring"][16] = {};
	aPuncturingCritMatrix["Hamstring"][17] = {};
	aPuncturingCritMatrix["Hamstring"][18] = {};
	aPuncturingCritMatrix["Hamstring"][19] = {};
	aPuncturingCritMatrix["Hamstring"][20] = {};
	aPuncturingCritMatrix["Hamstring"][21] = {};
	aPuncturingCritMatrix["Hamstring"][22] = {};
	aPuncturingCritMatrix["Hamstring"][23] = {};
	aPuncturingCritMatrix["Hamstring"][24] = {};
	
	aPuncturingCritMatrix["Thigh"][1] = {};
	aPuncturingCritMatrix["Thigh"][2] = {};
	aPuncturingCritMatrix["Thigh"][3] = {};
	aPuncturingCritMatrix["Thigh"][4] = {};
	aPuncturingCritMatrix["Thigh"][5] = {};
	aPuncturingCritMatrix["Thigh"][6] = {};
	aPuncturingCritMatrix["Thigh"][7] = {};
	aPuncturingCritMatrix["Thigh"][8] = {};
	aPuncturingCritMatrix["Thigh"][9] = {};
	aPuncturingCritMatrix["Thigh"][10] = {};
	aPuncturingCritMatrix["Thigh"][11] = {};
	aPuncturingCritMatrix["Thigh"][12] = {};
	aPuncturingCritMatrix["Thigh"][13] = {};
	aPuncturingCritMatrix["Thigh"][14] = {};
	aPuncturingCritMatrix["Thigh"][15] = {};
	aPuncturingCritMatrix["Thigh"][16] = {};
	aPuncturingCritMatrix["Thigh"][17] = {};
	aPuncturingCritMatrix["Thigh"][18] = {};
	aPuncturingCritMatrix["Thigh"][19] = {};
	aPuncturingCritMatrix["Thigh"][20] = {};
	aPuncturingCritMatrix["Thigh"][21] = {};
	aPuncturingCritMatrix["Thigh"][22] = {};
	aPuncturingCritMatrix["Thigh"][23] = {};
	aPuncturingCritMatrix["Thigh"][24] = {};
	
	aPuncturingCritMatrix["Hip"][1] = {};
	aPuncturingCritMatrix["Hip"][2] = {};
	aPuncturingCritMatrix["Hip"][3] = {};
	aPuncturingCritMatrix["Hip"][4] = {};
	aPuncturingCritMatrix["Hip"][5] = {};
	aPuncturingCritMatrix["Hip"][6] = {};
	aPuncturingCritMatrix["Hip"][7] = {};
	aPuncturingCritMatrix["Hip"][8] = {};
	aPuncturingCritMatrix["Hip"][9] = {};
	aPuncturingCritMatrix["Hip"][10] = {};
	aPuncturingCritMatrix["Hip"][11] = {};
	aPuncturingCritMatrix["Hip"][12] = {};
	aPuncturingCritMatrix["Hip"][13] = {};
	aPuncturingCritMatrix["Hip"][14] = {};
	aPuncturingCritMatrix["Hip"][15] = {};
	aPuncturingCritMatrix["Hip"][16] = {};
	aPuncturingCritMatrix["Hip"][17] = {};
	aPuncturingCritMatrix["Hip"][18] = {};
	aPuncturingCritMatrix["Hip"][19] = {};
	aPuncturingCritMatrix["Hip"][20] = {};
	aPuncturingCritMatrix["Hip"][21] = {};
	aPuncturingCritMatrix["Hip"][22] = {};
	aPuncturingCritMatrix["Hip"][23] = {};
	aPuncturingCritMatrix["Hip"][24] = {};

	aPuncturingCritMatrix["Groin"][1] = {};
	aPuncturingCritMatrix["Groin"][2] = {};
	aPuncturingCritMatrix["Groin"][3] = {};
	aPuncturingCritMatrix["Groin"][4] = {};
	aPuncturingCritMatrix["Groin"][5] = {};
	aPuncturingCritMatrix["Groin"][6] = {};
	aPuncturingCritMatrix["Groin"][7] = {};
	aPuncturingCritMatrix["Groin"][8] = {};
	aPuncturingCritMatrix["Groin"][9] = {};
	aPuncturingCritMatrix["Groin"][10] = {};
	aPuncturingCritMatrix["Groin"][11] = {};
	aPuncturingCritMatrix["Groin"][12] = {};
	aPuncturingCritMatrix["Groin"][13] = {};
	aPuncturingCritMatrix["Groin"][14] = {};
	aPuncturingCritMatrix["Groin"][15] = {};
	aPuncturingCritMatrix["Groin"][16] = {};
	aPuncturingCritMatrix["Groin"][17] = {};
	aPuncturingCritMatrix["Groin"][18] = {};
	aPuncturingCritMatrix["Groin"][19] = {};
	aPuncturingCritMatrix["Groin"][20] = {};
	aPuncturingCritMatrix["Groin"][21] = {};
	aPuncturingCritMatrix["Groin"][22] = {};
	aPuncturingCritMatrix["Groin"][23] = {};
	aPuncturingCritMatrix["Groin"][24] = {};
	
	aPuncturingCritMatrix["Buttock"][1] = {};
	aPuncturingCritMatrix["Buttock"][2] = {};
	aPuncturingCritMatrix["Buttock"][3] = {};
	aPuncturingCritMatrix["Buttock"][4] = {};
	aPuncturingCritMatrix["Buttock"][5] = {};
	aPuncturingCritMatrix["Buttock"][6] = {};
	aPuncturingCritMatrix["Buttock"][7] = {};
	aPuncturingCritMatrix["Buttock"][8] = {};
	aPuncturingCritMatrix["Buttock"][9] = {};
	aPuncturingCritMatrix["Buttock"][10] = {};
	aPuncturingCritMatrix["Buttock"][11] = {};
	aPuncturingCritMatrix["Buttock"][12] = {};
	aPuncturingCritMatrix["Buttock"][13] = {};
	aPuncturingCritMatrix["Buttock"][14] = {};
	aPuncturingCritMatrix["Buttock"][15] = {};
	aPuncturingCritMatrix["Buttock"][16] = {};
	aPuncturingCritMatrix["Buttock"][17] = {};
	aPuncturingCritMatrix["Buttock"][18] = {};
	aPuncturingCritMatrix["Buttock"][19] = {};
	aPuncturingCritMatrix["Buttock"][20] = {};
	aPuncturingCritMatrix["Buttock"][21] = {};
	aPuncturingCritMatrix["Buttock"][22] = {};
	aPuncturingCritMatrix["Buttock"][23] = {};
	aPuncturingCritMatrix["Buttock"][24] = {};

	aPuncturingCritMatrix["Abdomen, Lower"][1] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][2] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][3] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][4] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][5] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][6] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][7] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][8] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][9] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][10] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][11] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][12] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][13] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][14] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][15] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][16] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][17] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][18] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][19] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][20] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][21] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][22] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][23] = {};
	aPuncturingCritMatrix["Abdomen, Lower"][24] = {};

	aPuncturingCritMatrix["Side, lower"][1] = {};
	aPuncturingCritMatrix["Side, lower"][2] = {};
	aPuncturingCritMatrix["Side, lower"][3] = {};
	aPuncturingCritMatrix["Side, lower"][4] = {};
	aPuncturingCritMatrix["Side, lower"][5] = {};
	aPuncturingCritMatrix["Side, lower"][6] = {};
	aPuncturingCritMatrix["Side, lower"][7] = {};
	aPuncturingCritMatrix["Side, lower"][8] = {};
	aPuncturingCritMatrix["Side, lower"][9] = {};
	aPuncturingCritMatrix["Side, lower"][10] = {};
	aPuncturingCritMatrix["Side, lower"][11] = {};
	aPuncturingCritMatrix["Side, lower"][12] = {};
	aPuncturingCritMatrix["Side, lower"][13] = {};
	aPuncturingCritMatrix["Side, lower"][14] = {};
	aPuncturingCritMatrix["Side, lower"][15] = {};
	aPuncturingCritMatrix["Side, lower"][16] = {};
	aPuncturingCritMatrix["Side, lower"][17] = {};
	aPuncturingCritMatrix["Side, lower"][18] = {};
	aPuncturingCritMatrix["Side, lower"][19] = {};
	aPuncturingCritMatrix["Side, lower"][20] = {};
	aPuncturingCritMatrix["Side, lower"][21] = {};
	aPuncturingCritMatrix["Side, lower"][22] = {};
	aPuncturingCritMatrix["Side, lower"][23] = {};
	aPuncturingCritMatrix["Side, lower"][24] = {};
	
	aPuncturingCritMatrix["Abdomen, upper"][1] = {};
	aPuncturingCritMatrix["Abdomen, upper"][2] = {};
	aPuncturingCritMatrix["Abdomen, upper"][3] = {};
	aPuncturingCritMatrix["Abdomen, upper"][4] = {};
	aPuncturingCritMatrix["Abdomen, upper"][5] = {};
	aPuncturingCritMatrix["Abdomen, upper"][6] = {};
	aPuncturingCritMatrix["Abdomen, upper"][7] = {};
	aPuncturingCritMatrix["Abdomen, upper"][8] = {};
	aPuncturingCritMatrix["Abdomen, upper"][9] = {};
	aPuncturingCritMatrix["Abdomen, upper"][10] = {};
	aPuncturingCritMatrix["Abdomen, upper"][11] = {};
	aPuncturingCritMatrix["Abdomen, upper"][12] = {};
	aPuncturingCritMatrix["Abdomen, upper"][13] = {};
	aPuncturingCritMatrix["Abdomen, upper"][14] = {};
	aPuncturingCritMatrix["Abdomen, upper"][15] = {};
	aPuncturingCritMatrix["Abdomen, upper"][16] = {};
	aPuncturingCritMatrix["Abdomen, upper"][17] = {};
	aPuncturingCritMatrix["Abdomen, upper"][18] = {};
	aPuncturingCritMatrix["Abdomen, upper"][19] = {};
	aPuncturingCritMatrix["Abdomen, upper"][20] = {};
	aPuncturingCritMatrix["Abdomen, upper"][21] = {};
	aPuncturingCritMatrix["Abdomen, upper"][22] = {};
	aPuncturingCritMatrix["Abdomen, upper"][23] = {};
	aPuncturingCritMatrix["Abdomen, upper"][24] = {};

	aPuncturingCritMatrix["Back, small of"][1] = {};
	aPuncturingCritMatrix["Back, small of"][2] = {};
	aPuncturingCritMatrix["Back, small of"][3] = {};
	aPuncturingCritMatrix["Back, small of"][4] = {};
	aPuncturingCritMatrix["Back, small of"][5] = {};
	aPuncturingCritMatrix["Back, small of"][6] = {};
	aPuncturingCritMatrix["Back, small of"][7] = {};
	aPuncturingCritMatrix["Back, small of"][8] = {};
	aPuncturingCritMatrix["Back, small of"][9] = {};
	aPuncturingCritMatrix["Back, small of"][10] = {};
	aPuncturingCritMatrix["Back, small of"][11] = {};
	aPuncturingCritMatrix["Back, small of"][12] = {};
	aPuncturingCritMatrix["Back, small of"][13] = {};
	aPuncturingCritMatrix["Back, small of"][14] = {};
	aPuncturingCritMatrix["Back, small of"][15] = {};
	aPuncturingCritMatrix["Back, small of"][16] = {};
	aPuncturingCritMatrix["Back, small of"][17] = {};
	aPuncturingCritMatrix["Back, small of"][18] = {};
	aPuncturingCritMatrix["Back, small of"][19] = {};
	aPuncturingCritMatrix["Back, small of"][20] = {};
	aPuncturingCritMatrix["Back, small of"][21] = {};
	aPuncturingCritMatrix["Back, small of"][22] = {};
	aPuncturingCritMatrix["Back, small of"][23] = {};
	aPuncturingCritMatrix["Back, small of"][24] = {};

	aPuncturingCritMatrix["Back, lower"][1] = {};
	aPuncturingCritMatrix["Back, lower"][2] = {};
	aPuncturingCritMatrix["Back, lower"][3] = {};
	aPuncturingCritMatrix["Back, lower"][4] = {};
	aPuncturingCritMatrix["Back, lower"][5] = {};
	aPuncturingCritMatrix["Back, lower"][6] = {};
	aPuncturingCritMatrix["Back, lower"][7] = {};
	aPuncturingCritMatrix["Back, lower"][8] = {};
	aPuncturingCritMatrix["Back, lower"][9] = {};
	aPuncturingCritMatrix["Back, lower"][10] = {};
	aPuncturingCritMatrix["Back, lower"][11] = {};
	aPuncturingCritMatrix["Back, lower"][12] = {};
	aPuncturingCritMatrix["Back, lower"][13] = {};
	aPuncturingCritMatrix["Back, lower"][14] = {};
	aPuncturingCritMatrix["Back, lower"][15] = {};
	aPuncturingCritMatrix["Back, lower"][16] = {};
	aPuncturingCritMatrix["Back, lower"][17] = {};
	aPuncturingCritMatrix["Back, lower"][18] = {};
	aPuncturingCritMatrix["Back, lower"][19] = {};
	aPuncturingCritMatrix["Back, lower"][20] = {};
	aPuncturingCritMatrix["Back, lower"][21] = {};
	aPuncturingCritMatrix["Back, lower"][22] = {};
	aPuncturingCritMatrix["Back, lower"][23] = {};
	aPuncturingCritMatrix["Back, lower"][24] = {};

	aPuncturingCritMatrix["Chest"][1] = {};
	aPuncturingCritMatrix["Chest"][2] = {};
	aPuncturingCritMatrix["Chest"][3] = {};
	aPuncturingCritMatrix["Chest"][4] = {};
	aPuncturingCritMatrix["Chest"][5] = {};
	aPuncturingCritMatrix["Chest"][6] = {};
	aPuncturingCritMatrix["Chest"][7] = {};
	aPuncturingCritMatrix["Chest"][8] = {};
	aPuncturingCritMatrix["Chest"][9] = {};
	aPuncturingCritMatrix["Chest"][10] = {};
	aPuncturingCritMatrix["Chest"][11] = {};
	aPuncturingCritMatrix["Chest"][12] = {};
	aPuncturingCritMatrix["Chest"][13] = {};
	aPuncturingCritMatrix["Chest"][14] = {};
	aPuncturingCritMatrix["Chest"][15] = {};
	aPuncturingCritMatrix["Chest"][16] = {};
	aPuncturingCritMatrix["Chest"][17] = {};
	aPuncturingCritMatrix["Chest"][18] = {};
	aPuncturingCritMatrix["Chest"][19] = {};
	aPuncturingCritMatrix["Chest"][20] = {};
	aPuncturingCritMatrix["Chest"][21] = {};
	aPuncturingCritMatrix["Chest"][22] = {};
	aPuncturingCritMatrix["Chest"][23] = {};
	aPuncturingCritMatrix["Chest"][24] = {};
	
	aPuncturingCritMatrix["Side, upper"][1] = {};
	aPuncturingCritMatrix["Side, upper"][2] = {};
	aPuncturingCritMatrix["Side, upper"][3] = {};
	aPuncturingCritMatrix["Side, upper"][4] = {};
	aPuncturingCritMatrix["Side, upper"][5] = {};
	aPuncturingCritMatrix["Side, upper"][6] = {};
	aPuncturingCritMatrix["Side, upper"][7] = {};
	aPuncturingCritMatrix["Side, upper"][8] = {};
	aPuncturingCritMatrix["Side, upper"][9] = {};
	aPuncturingCritMatrix["Side, upper"][10] = {};
	aPuncturingCritMatrix["Side, upper"][11] = {};
	aPuncturingCritMatrix["Side, upper"][12] = {};
	aPuncturingCritMatrix["Side, upper"][13] = {};
	aPuncturingCritMatrix["Side, upper"][14] = {};
	aPuncturingCritMatrix["Side, upper"][15] = {};
	aPuncturingCritMatrix["Side, upper"][16] = {};
	aPuncturingCritMatrix["Side, upper"][17] = {};
	aPuncturingCritMatrix["Side, upper"][18] = {};
	aPuncturingCritMatrix["Side, upper"][19] = {};
	aPuncturingCritMatrix["Side, upper"][20] = {};
	aPuncturingCritMatrix["Side, upper"][21] = {};
	aPuncturingCritMatrix["Side, upper"][22] = {};
	aPuncturingCritMatrix["Side, upper"][23] = {};
	aPuncturingCritMatrix["Side, upper"][24] = {};
	
	aPuncturingCritMatrix["Back, upper"][1] = {};
	aPuncturingCritMatrix["Back, upper"][2] = {};
	aPuncturingCritMatrix["Back, upper"][3] = {};
	aPuncturingCritMatrix["Back, upper"][4] = {};
	aPuncturingCritMatrix["Back, upper"][5] = {};
	aPuncturingCritMatrix["Back, upper"][6] = {};
	aPuncturingCritMatrix["Back, upper"][7] = {};
	aPuncturingCritMatrix["Back, upper"][8] = {};
	aPuncturingCritMatrix["Back, upper"][9] = {};
	aPuncturingCritMatrix["Back, upper"][10] = {};
	aPuncturingCritMatrix["Back, upper"][11] = {};
	aPuncturingCritMatrix["Back, upper"][12] = {};
	aPuncturingCritMatrix["Back, upper"][13] = {};
	aPuncturingCritMatrix["Back, upper"][14] = {};
	aPuncturingCritMatrix["Back, upper"][15] = {};
	aPuncturingCritMatrix["Back, upper"][16] = {};
	aPuncturingCritMatrix["Back, upper"][17] = {};
	aPuncturingCritMatrix["Back, upper"][18] = {};
	aPuncturingCritMatrix["Back, upper"][19] = {};
	aPuncturingCritMatrix["Back, upper"][20] = {};
	aPuncturingCritMatrix["Back, upper"][21] = {};
	aPuncturingCritMatrix["Back, upper"][22] = {};
	aPuncturingCritMatrix["Back, upper"][23] = {};
	aPuncturingCritMatrix["Back, upper"][24] = {};
	
	aPuncturingCritMatrix["Back, upper middle"][1] = {};
	aPuncturingCritMatrix["Back, upper middle"][2] = {};
	aPuncturingCritMatrix["Back, upper middle"][3] = {};
	aPuncturingCritMatrix["Back, upper middle"][4] = {};
	aPuncturingCritMatrix["Back, upper middle"][5] = {};
	aPuncturingCritMatrix["Back, upper middle"][6] = {};
	aPuncturingCritMatrix["Back, upper middle"][7] = {};
	aPuncturingCritMatrix["Back, upper middle"][8] = {};
	aPuncturingCritMatrix["Back, upper middle"][9] = {};
	aPuncturingCritMatrix["Back, upper middle"][10] = {};
	aPuncturingCritMatrix["Back, upper middle"][11] = {};
	aPuncturingCritMatrix["Back, upper middle"][12] = {};
	aPuncturingCritMatrix["Back, upper middle"][13] = {};
	aPuncturingCritMatrix["Back, upper middle"][14] = {};
	aPuncturingCritMatrix["Back, upper middle"][15] = {};
	aPuncturingCritMatrix["Back, upper middle"][16] = {};
	aPuncturingCritMatrix["Back, upper middle"][17] = {};
	aPuncturingCritMatrix["Back, upper middle"][18] = {};
	aPuncturingCritMatrix["Back, upper middle"][19] = {};
	aPuncturingCritMatrix["Back, upper middle"][20] = {};
	aPuncturingCritMatrix["Back, upper middle"][21] = {};
	aPuncturingCritMatrix["Back, upper middle"][22] = {};
	aPuncturingCritMatrix["Back, upper middle"][23] = {};
	aPuncturingCritMatrix["Back, upper middle"][24] = {};
	
	aPuncturingCritMatrix["Armpit"][1] = {};
	aPuncturingCritMatrix["Armpit"][2] = {};
	aPuncturingCritMatrix["Armpit"][3] = {};
	aPuncturingCritMatrix["Armpit"][4] = {};
	aPuncturingCritMatrix["Armpit"][5] = {};
	aPuncturingCritMatrix["Armpit"][6] = {};
	aPuncturingCritMatrix["Armpit"][7] = {};
	aPuncturingCritMatrix["Armpit"][8] = {};
	aPuncturingCritMatrix["Armpit"][9] = {};
	aPuncturingCritMatrix["Armpit"][10] = {};
	aPuncturingCritMatrix["Armpit"][11] = {};
	aPuncturingCritMatrix["Armpit"][12] = {};
	aPuncturingCritMatrix["Armpit"][13] = {};
	aPuncturingCritMatrix["Armpit"][14] = {};
	aPuncturingCritMatrix["Armpit"][15] = {};
	aPuncturingCritMatrix["Armpit"][16] = {};
	aPuncturingCritMatrix["Armpit"][17] = {};
	aPuncturingCritMatrix["Armpit"][18] = {};
	aPuncturingCritMatrix["Armpit"][19] = {};
	aPuncturingCritMatrix["Armpit"][20] = {};
	aPuncturingCritMatrix["Armpit"][21] = {};
	aPuncturingCritMatrix["Armpit"][22] = {};
	aPuncturingCritMatrix["Armpit"][23] = {};
	aPuncturingCritMatrix["Armpit"][24] = {};
	
	aPuncturingCritMatrix["Arm, upper outer"][1] = {};
	aPuncturingCritMatrix["Arm, upper outer"][2] = {};
	aPuncturingCritMatrix["Arm, upper outer"][3] = {};
	aPuncturingCritMatrix["Arm, upper outer"][4] = {};
	aPuncturingCritMatrix["Arm, upper outer"][5] = {};
	aPuncturingCritMatrix["Arm, upper outer"][6] = {};
	aPuncturingCritMatrix["Arm, upper outer"][7] = {};
	aPuncturingCritMatrix["Arm, upper outer"][8] = {};
	aPuncturingCritMatrix["Arm, upper outer"][9] = {};
	aPuncturingCritMatrix["Arm, upper outer"][10] = {};
	aPuncturingCritMatrix["Arm, upper outer"][11] = {};
	aPuncturingCritMatrix["Arm, upper outer"][12] = {};
	aPuncturingCritMatrix["Arm, upper outer"][13] = {};
	aPuncturingCritMatrix["Arm, upper outer"][14] = {};
	aPuncturingCritMatrix["Arm, upper outer"][15] = {};
	aPuncturingCritMatrix["Arm, upper outer"][16] = {};
	aPuncturingCritMatrix["Arm, upper outer"][17] = {};
	aPuncturingCritMatrix["Arm, upper outer"][18] = {};
	aPuncturingCritMatrix["Arm, upper outer"][19] = {};
	aPuncturingCritMatrix["Arm, upper outer"][20] = {};
	aPuncturingCritMatrix["Arm, upper outer"][21] = {};
	aPuncturingCritMatrix["Arm, upper outer"][22] = {};
	aPuncturingCritMatrix["Arm, upper outer"][23] = {};
	aPuncturingCritMatrix["Arm, upper outer"][24] = {};
	
	aPuncturingCritMatrix["Arm, upper inner"][1] = {};
	aPuncturingCritMatrix["Arm, upper inner"][2] = {};
	aPuncturingCritMatrix["Arm, upper inner"][3] = {};
	aPuncturingCritMatrix["Arm, upper inner"][4] = {};
	aPuncturingCritMatrix["Arm, upper inner"][5] = {};
	aPuncturingCritMatrix["Arm, upper inner"][6] = {};
	aPuncturingCritMatrix["Arm, upper inner"][7] = {};
	aPuncturingCritMatrix["Arm, upper inner"][8] = {};
	aPuncturingCritMatrix["Arm, upper inner"][9] = {};
	aPuncturingCritMatrix["Arm, upper inner"][10] = {};
	aPuncturingCritMatrix["Arm, upper inner"][11] = {};
	aPuncturingCritMatrix["Arm, upper inner"][12] = {};
	aPuncturingCritMatrix["Arm, upper inner"][13] = {};
	aPuncturingCritMatrix["Arm, upper inner"][14] = {};
	aPuncturingCritMatrix["Arm, upper inner"][15] = {};
	aPuncturingCritMatrix["Arm, upper inner"][16] = {};
	aPuncturingCritMatrix["Arm, upper inner"][17] = {};
	aPuncturingCritMatrix["Arm, upper inner"][18] = {};
	aPuncturingCritMatrix["Arm, upper inner"][19] = {};
	aPuncturingCritMatrix["Arm, upper inner"][20] = {};
	aPuncturingCritMatrix["Arm, upper inner"][21] = {};
	aPuncturingCritMatrix["Arm, upper inner"][22] = {};
	aPuncturingCritMatrix["Arm, upper inner"][23] = {};
	aPuncturingCritMatrix["Arm, upper inner"][24] = {};
	
	aPuncturingCritMatrix["Elbow"][1] = {};
	aPuncturingCritMatrix["Elbow"][2] = {};
	aPuncturingCritMatrix["Elbow"][3] = {};
	aPuncturingCritMatrix["Elbow"][4] = {};
	aPuncturingCritMatrix["Elbow"][5] = {};
	aPuncturingCritMatrix["Elbow"][6] = {};
	aPuncturingCritMatrix["Elbow"][7] = {};
	aPuncturingCritMatrix["Elbow"][8] = {};
	aPuncturingCritMatrix["Elbow"][9] = {};
	aPuncturingCritMatrix["Elbow"][10] = {};
	aPuncturingCritMatrix["Elbow"][11] = {};
	aPuncturingCritMatrix["Elbow"][12] = {};
	aPuncturingCritMatrix["Elbow"][13] = {};
	aPuncturingCritMatrix["Elbow"][14] = {};
	aPuncturingCritMatrix["Elbow"][15] = {};
	aPuncturingCritMatrix["Elbow"][16] = {};
	aPuncturingCritMatrix["Elbow"][17] = {};
	aPuncturingCritMatrix["Elbow"][18] = {};
	aPuncturingCritMatrix["Elbow"][19] = {};
	aPuncturingCritMatrix["Elbow"][20] = {};
	aPuncturingCritMatrix["Elbow"][21] = {};
	aPuncturingCritMatrix["Elbow"][22] = {};
	aPuncturingCritMatrix["Elbow"][23] = {};
	aPuncturingCritMatrix["Elbow"][24] = {};
	
	aPuncturingCritMatrix["Inner joint"][1] = {};
	aPuncturingCritMatrix["Inner joint"][2] = {};
	aPuncturingCritMatrix["Inner joint"][3] = {};
	aPuncturingCritMatrix["Inner joint"][4] = {};
	aPuncturingCritMatrix["Inner joint"][5] = {};
	aPuncturingCritMatrix["Inner joint"][6] = {};
	aPuncturingCritMatrix["Inner joint"][7] = {};
	aPuncturingCritMatrix["Inner joint"][8] = {};
	aPuncturingCritMatrix["Inner joint"][9] = {};
	aPuncturingCritMatrix["Inner joint"][10] = {};
	aPuncturingCritMatrix["Inner joint"][11] = {};
	aPuncturingCritMatrix["Inner joint"][12] = {};
	aPuncturingCritMatrix["Inner joint"][13] = {};
	aPuncturingCritMatrix["Inner joint"][14] = {};
	aPuncturingCritMatrix["Inner joint"][15] = {};
	aPuncturingCritMatrix["Inner joint"][16] = {};
	aPuncturingCritMatrix["Inner joint"][17] = {};
	aPuncturingCritMatrix["Inner joint"][18] = {};
	aPuncturingCritMatrix["Inner joint"][19] = {};
	aPuncturingCritMatrix["Inner joint"][20] = {};
	aPuncturingCritMatrix["Inner joint"][21] = {};
	aPuncturingCritMatrix["Inner joint"][22] = {};
	aPuncturingCritMatrix["Inner joint"][23] = {};
	aPuncturingCritMatrix["Inner joint"][24] = {};
	
	aPuncturingCritMatrix["Forearm, back"][1] = {};
	aPuncturingCritMatrix["Forearm, back"][2] = {};
	aPuncturingCritMatrix["Forearm, back"][3] = {};
	aPuncturingCritMatrix["Forearm, back"][4] = {};
	aPuncturingCritMatrix["Forearm, back"][5] = {};
	aPuncturingCritMatrix["Forearm, back"][6] = {};
	aPuncturingCritMatrix["Forearm, back"][7] = {};
	aPuncturingCritMatrix["Forearm, back"][8] = {};
	aPuncturingCritMatrix["Forearm, back"][9] = {};
	aPuncturingCritMatrix["Forearm, back"][10] = {};
	aPuncturingCritMatrix["Forearm, back"][11] = {};
	aPuncturingCritMatrix["Forearm, back"][12] = {};
	aPuncturingCritMatrix["Forearm, back"][13] = {};
	aPuncturingCritMatrix["Forearm, back"][14] = {};
	aPuncturingCritMatrix["Forearm, back"][15] = {};
	aPuncturingCritMatrix["Forearm, back"][16] = {};
	aPuncturingCritMatrix["Forearm, back"][17] = {};
	aPuncturingCritMatrix["Forearm, back"][18] = {};
	aPuncturingCritMatrix["Forearm, back"][19] = {};
	aPuncturingCritMatrix["Forearm, back"][20] = {};
	aPuncturingCritMatrix["Forearm, back"][21] = {};
	aPuncturingCritMatrix["Forearm, back"][22] = {};
	aPuncturingCritMatrix["Forearm, back"][23] = {};
	aPuncturingCritMatrix["Forearm, back"][24] = {};
	
	aPuncturingCritMatrix["Forearm, inner"][1] = {};
	aPuncturingCritMatrix["Forearm, inner"][2] = {};
	aPuncturingCritMatrix["Forearm, inner"][3] = {};
	aPuncturingCritMatrix["Forearm, inner"][4] = {};
	aPuncturingCritMatrix["Forearm, inner"][5] = {};
	aPuncturingCritMatrix["Forearm, inner"][6] = {};
	aPuncturingCritMatrix["Forearm, inner"][7] = {};
	aPuncturingCritMatrix["Forearm, inner"][8] = {};
	aPuncturingCritMatrix["Forearm, inner"][9] = {};
	aPuncturingCritMatrix["Forearm, inner"][10] = {};
	aPuncturingCritMatrix["Forearm, inner"][11] = {};
	aPuncturingCritMatrix["Forearm, inner"][12] = {};
	aPuncturingCritMatrix["Forearm, inner"][13] = {};
	aPuncturingCritMatrix["Forearm, inner"][14] = {};
	aPuncturingCritMatrix["Forearm, inner"][15] = {};
	aPuncturingCritMatrix["Forearm, inner"][16] = {};
	aPuncturingCritMatrix["Forearm, inner"][17] = {};
	aPuncturingCritMatrix["Forearm, inner"][18] = {};
	aPuncturingCritMatrix["Forearm, inner"][19] = {};
	aPuncturingCritMatrix["Forearm, inner"][20] = {};
	aPuncturingCritMatrix["Forearm, inner"][21] = {};
	aPuncturingCritMatrix["Forearm, inner"][22] = {};
	aPuncturingCritMatrix["Forearm, inner"][23] = {};
	aPuncturingCritMatrix["Forearm, inner"][24] = {};
	
	aPuncturingCritMatrix["Wrist, back"][1] = {};
	aPuncturingCritMatrix["Wrist, back"][2] = {};
	aPuncturingCritMatrix["Wrist, back"][3] = {};
	aPuncturingCritMatrix["Wrist, back"][4] = {};
	aPuncturingCritMatrix["Wrist, back"][5] = {};
	aPuncturingCritMatrix["Wrist, back"][6] = {};
	aPuncturingCritMatrix["Wrist, back"][7] = {};
	aPuncturingCritMatrix["Wrist, back"][8] = {};
	aPuncturingCritMatrix["Wrist, back"][9] = {};
	aPuncturingCritMatrix["Wrist, back"][10] = {};
	aPuncturingCritMatrix["Wrist, back"][11] = {};
	aPuncturingCritMatrix["Wrist, back"][12] = {};
	aPuncturingCritMatrix["Wrist, back"][13] = {};
	aPuncturingCritMatrix["Wrist, back"][14] = {};
	aPuncturingCritMatrix["Wrist, back"][15] = {};
	aPuncturingCritMatrix["Wrist, back"][16] = {};
	aPuncturingCritMatrix["Wrist, back"][17] = {};
	aPuncturingCritMatrix["Wrist, back"][18] = {};
	aPuncturingCritMatrix["Wrist, back"][19] = {};
	aPuncturingCritMatrix["Wrist, back"][20] = {};
	aPuncturingCritMatrix["Wrist, back"][21] = {};
	aPuncturingCritMatrix["Wrist, back"][22] = {};
	aPuncturingCritMatrix["Wrist, back"][23] = {};
	aPuncturingCritMatrix["Wrist, back"][24] = {};
	
	aPuncturingCritMatrix["Wrist, front"][1] = {};
	aPuncturingCritMatrix["Wrist, front"][2] = {};
	aPuncturingCritMatrix["Wrist, front"][3] = {};
	aPuncturingCritMatrix["Wrist, front"][4] = {};
	aPuncturingCritMatrix["Wrist, front"][5] = {};
	aPuncturingCritMatrix["Wrist, front"][6] = {};
	aPuncturingCritMatrix["Wrist, front"][7] = {};
	aPuncturingCritMatrix["Wrist, front"][8] = {};
	aPuncturingCritMatrix["Wrist, front"][9] = {};
	aPuncturingCritMatrix["Wrist, front"][10] = {};
	aPuncturingCritMatrix["Wrist, front"][11] = {};
	aPuncturingCritMatrix["Wrist, front"][12] = {};
	aPuncturingCritMatrix["Wrist, front"][13] = {};
	aPuncturingCritMatrix["Wrist, front"][14] = {};
	aPuncturingCritMatrix["Wrist, front"][15] = {};
	aPuncturingCritMatrix["Wrist, front"][16] = {};
	aPuncturingCritMatrix["Wrist, front"][17] = {};
	aPuncturingCritMatrix["Wrist, front"][18] = {};
	aPuncturingCritMatrix["Wrist, front"][19] = {};
	aPuncturingCritMatrix["Wrist, front"][20] = {};
	aPuncturingCritMatrix["Wrist, front"][21] = {};
	aPuncturingCritMatrix["Wrist, front"][22] = {};
	aPuncturingCritMatrix["Wrist, front"][23] = {};
	aPuncturingCritMatrix["Wrist, front"][24] = {};

	aPuncturingCritMatrix["Hand, back"][1] = {};
	aPuncturingCritMatrix["Hand, back"][2] = {};
	aPuncturingCritMatrix["Hand, back"][3] = {};
	aPuncturingCritMatrix["Hand, back"][4] = {};
	aPuncturingCritMatrix["Hand, back"][5] = {};
	aPuncturingCritMatrix["Hand, back"][6] = {};
	aPuncturingCritMatrix["Hand, back"][7] = {};
	aPuncturingCritMatrix["Hand, back"][8] = {};
	aPuncturingCritMatrix["Hand, back"][9] = {};
	aPuncturingCritMatrix["Hand, back"][10] = {};
	aPuncturingCritMatrix["Hand, back"][11] = {};
	aPuncturingCritMatrix["Hand, back"][12] = {};
	aPuncturingCritMatrix["Hand, back"][13] = {};
	aPuncturingCritMatrix["Hand, back"][14] = {};
	aPuncturingCritMatrix["Hand, back"][15] = {};
	aPuncturingCritMatrix["Hand, back"][16] = {};
	aPuncturingCritMatrix["Hand, back"][17] = {};
	aPuncturingCritMatrix["Hand, back"][18] = {};
	aPuncturingCritMatrix["Hand, back"][19] = {};
	aPuncturingCritMatrix["Hand, back"][20] = {};
	aPuncturingCritMatrix["Hand, back"][21] = {};
	aPuncturingCritMatrix["Hand, back"][22] = {};
	aPuncturingCritMatrix["Hand, back"][23] = {};
	aPuncturingCritMatrix["Hand, back"][24] = {};
	
	aPuncturingCritMatrix["Palm"][1] = {};
	aPuncturingCritMatrix["Palm"][2] = {};
	aPuncturingCritMatrix["Palm"][3] = {};
	aPuncturingCritMatrix["Palm"][4] = {};
	aPuncturingCritMatrix["Palm"][5] = {};
	aPuncturingCritMatrix["Palm"][6] = {};
	aPuncturingCritMatrix["Palm"][7] = {};
	aPuncturingCritMatrix["Palm"][8] = {};
	aPuncturingCritMatrix["Palm"][9] = {};
	aPuncturingCritMatrix["Palm"][10] = {};
	aPuncturingCritMatrix["Palm"][11] = {};
	aPuncturingCritMatrix["Palm"][12] = {};
	aPuncturingCritMatrix["Palm"][13] = {};
	aPuncturingCritMatrix["Palm"][14] = {};
	aPuncturingCritMatrix["Palm"][15] = {};
	aPuncturingCritMatrix["Palm"][16] = {};
	aPuncturingCritMatrix["Palm"][17] = {};
	aPuncturingCritMatrix["Palm"][18] = {};
	aPuncturingCritMatrix["Palm"][19] = {};
	aPuncturingCritMatrix["Palm"][20] = {};
	aPuncturingCritMatrix["Palm"][21] = {};
	aPuncturingCritMatrix["Palm"][22] = {};
	aPuncturingCritMatrix["Palm"][23] = {};
	aPuncturingCritMatrix["Palm"][24] = {};
	
	aPuncturingCritMatrix["Finger(s)"][1] = {};
	aPuncturingCritMatrix["Finger(s)"][2] = {};
	aPuncturingCritMatrix["Finger(s)"][3] = {};
	aPuncturingCritMatrix["Finger(s)"][4] = {};
	aPuncturingCritMatrix["Finger(s)"][5] = {};
	aPuncturingCritMatrix["Finger(s)"][6] = {};
	aPuncturingCritMatrix["Finger(s)"][7] = {};
	aPuncturingCritMatrix["Finger(s)"][8] = {};
	aPuncturingCritMatrix["Finger(s)"][9] = {};
	aPuncturingCritMatrix["Finger(s)"][10] = {};
	aPuncturingCritMatrix["Finger(s)"][11] = {};
	aPuncturingCritMatrix["Finger(s)"][12] = {};
	aPuncturingCritMatrix["Finger(s)"][13] = {};
	aPuncturingCritMatrix["Finger(s)"][14] = {};
	aPuncturingCritMatrix["Finger(s)"][15] = {};
	aPuncturingCritMatrix["Finger(s)"][16] = {};
	aPuncturingCritMatrix["Finger(s)"][17] = {};
	aPuncturingCritMatrix["Finger(s)"][18] = {};
	aPuncturingCritMatrix["Finger(s)"][19] = {};
	aPuncturingCritMatrix["Finger(s)"][20] = {};
	aPuncturingCritMatrix["Finger(s)"][21] = {};
	aPuncturingCritMatrix["Finger(s)"][22] = {};
	aPuncturingCritMatrix["Finger(s)"][23] = {};
	aPuncturingCritMatrix["Finger(s)"][24] = {};

	aPuncturingCritMatrix["Shoulder, side"][1] = {};
	aPuncturingCritMatrix["Shoulder, side"][2] = {};
	aPuncturingCritMatrix["Shoulder, side"][3] = {};
	aPuncturingCritMatrix["Shoulder, side"][4] = {};
	aPuncturingCritMatrix["Shoulder, side"][5] = {};
	aPuncturingCritMatrix["Shoulder, side"][6] = {};
	aPuncturingCritMatrix["Shoulder, side"][7] = {};
	aPuncturingCritMatrix["Shoulder, side"][8] = {};
	aPuncturingCritMatrix["Shoulder, side"][9] = {};
	aPuncturingCritMatrix["Shoulder, side"][10] = {};
	aPuncturingCritMatrix["Shoulder, side"][11] = {};
	aPuncturingCritMatrix["Shoulder, side"][12] = {};
	aPuncturingCritMatrix["Shoulder, side"][13] = {};
	aPuncturingCritMatrix["Shoulder, side"][14] = {};
	aPuncturingCritMatrix["Shoulder, side"][15] = {};
	aPuncturingCritMatrix["Shoulder, side"][16] = {};
	aPuncturingCritMatrix["Shoulder, side"][17] = {};
	aPuncturingCritMatrix["Shoulder, side"][18] = {};
	aPuncturingCritMatrix["Shoulder, side"][19] = {};
	aPuncturingCritMatrix["Shoulder, side"][20] = {};
	aPuncturingCritMatrix["Shoulder, side"][21] = {};
	aPuncturingCritMatrix["Shoulder, side"][22] = {};
	aPuncturingCritMatrix["Shoulder, side"][23] = {};
	aPuncturingCritMatrix["Shoulder, side"][24] = {};
	
	aPuncturingCritMatrix["Shoulder, top"][1] = {};
	aPuncturingCritMatrix["Shoulder, top"][2] = {};
	aPuncturingCritMatrix["Shoulder, top"][3] = {};
	aPuncturingCritMatrix["Shoulder, top"][4] = {};
	aPuncturingCritMatrix["Shoulder, top"][5] = {};
	aPuncturingCritMatrix["Shoulder, top"][6] = {};
	aPuncturingCritMatrix["Shoulder, top"][7] = {};
	aPuncturingCritMatrix["Shoulder, top"][8] = {};
	aPuncturingCritMatrix["Shoulder, top"][9] = {};
	aPuncturingCritMatrix["Shoulder, top"][10] = {};
	aPuncturingCritMatrix["Shoulder, top"][11] = {};
	aPuncturingCritMatrix["Shoulder, top"][12] = {};
	aPuncturingCritMatrix["Shoulder, top"][13] = {};
	aPuncturingCritMatrix["Shoulder, top"][14] = {};
	aPuncturingCritMatrix["Shoulder, top"][15] = {};
	aPuncturingCritMatrix["Shoulder, top"][16] = {};
	aPuncturingCritMatrix["Shoulder, top"][17] = {};
	aPuncturingCritMatrix["Shoulder, top"][18] = {};
	aPuncturingCritMatrix["Shoulder, top"][19] = {};
	aPuncturingCritMatrix["Shoulder, top"][20] = {};
	aPuncturingCritMatrix["Shoulder, top"][21] = {};
	aPuncturingCritMatrix["Shoulder, top"][22] = {};
	aPuncturingCritMatrix["Shoulder, top"][23] = {};
	aPuncturingCritMatrix["Shoulder, top"][24] = {};
	
	aPuncturingCritMatrix["Neck, back"][1] = {};
	aPuncturingCritMatrix["Neck, back"][2] = {};
	aPuncturingCritMatrix["Neck, back"][3] = {};
	aPuncturingCritMatrix["Neck, back"][4] = {};
	aPuncturingCritMatrix["Neck, back"][5] = {};
	aPuncturingCritMatrix["Neck, back"][6] = {};
	aPuncturingCritMatrix["Neck, back"][7] = {};
	aPuncturingCritMatrix["Neck, back"][8] = {};
	aPuncturingCritMatrix["Neck, back"][9] = {};
	aPuncturingCritMatrix["Neck, back"][10] = {};
	aPuncturingCritMatrix["Neck, back"][11] = {};
	aPuncturingCritMatrix["Neck, back"][12] = {};
	aPuncturingCritMatrix["Neck, back"][13] = {};
	aPuncturingCritMatrix["Neck, back"][14] = {};
	aPuncturingCritMatrix["Neck, back"][15] = {};
	aPuncturingCritMatrix["Neck, back"][16] = {};
	aPuncturingCritMatrix["Neck, back"][17] = {};
	aPuncturingCritMatrix["Neck, back"][18] = {};
	aPuncturingCritMatrix["Neck, back"][19] = {};
	aPuncturingCritMatrix["Neck, back"][20] = {};
	aPuncturingCritMatrix["Neck, back"][21] = {};
	aPuncturingCritMatrix["Neck, back"][22] = {};
	aPuncturingCritMatrix["Neck, back"][23] = {};
	aPuncturingCritMatrix["Neck, back"][24] = {};
	
	aPuncturingCritMatrix["Neck, back"][1] = {};
	aPuncturingCritMatrix["Neck, back"][2] = {};
	aPuncturingCritMatrix["Neck, back"][3] = {};
	aPuncturingCritMatrix["Neck, back"][4] = {};
	aPuncturingCritMatrix["Neck, back"][5] = {};
	aPuncturingCritMatrix["Neck, back"][6] = {};
	aPuncturingCritMatrix["Neck, back"][7] = {};
	aPuncturingCritMatrix["Neck, back"][8] = {};
	aPuncturingCritMatrix["Neck, back"][9] = {};
	aPuncturingCritMatrix["Neck, back"][10] = {};
	aPuncturingCritMatrix["Neck, back"][11] = {};
	aPuncturingCritMatrix["Neck, back"][12] = {};
	aPuncturingCritMatrix["Neck, back"][13] = {};
	aPuncturingCritMatrix["Neck, back"][14] = {};
	aPuncturingCritMatrix["Neck, back"][15] = {};
	aPuncturingCritMatrix["Neck, back"][16] = {};
	aPuncturingCritMatrix["Neck, back"][17] = {};
	aPuncturingCritMatrix["Neck, back"][18] = {};
	aPuncturingCritMatrix["Neck, back"][19] = {};
	aPuncturingCritMatrix["Neck, back"][20] = {};
	aPuncturingCritMatrix["Neck, back"][21] = {};
	aPuncturingCritMatrix["Neck, back"][22] = {};
	aPuncturingCritMatrix["Neck, back"][23] = {};
	aPuncturingCritMatrix["Neck, back"][24] = {};
	
	aPuncturingCritMatrix["Neck, side"][1] = {};
	aPuncturingCritMatrix["Neck, side"][2] = {};
	aPuncturingCritMatrix["Neck, side"][3] = {};
	aPuncturingCritMatrix["Neck, side"][4] = {};
	aPuncturingCritMatrix["Neck, side"][5] = {};
	aPuncturingCritMatrix["Neck, side"][6] = {};
	aPuncturingCritMatrix["Neck, side"][7] = {};
	aPuncturingCritMatrix["Neck, side"][8] = {};
	aPuncturingCritMatrix["Neck, side"][9] = {};
	aPuncturingCritMatrix["Neck, side"][10] = {};
	aPuncturingCritMatrix["Neck, side"][11] = {};
	aPuncturingCritMatrix["Neck, side"][12] = {};
	aPuncturingCritMatrix["Neck, side"][13] = {};
	aPuncturingCritMatrix["Neck, side"][14] = {};
	aPuncturingCritMatrix["Neck, side"][15] = {};
	aPuncturingCritMatrix["Neck, side"][16] = {};
	aPuncturingCritMatrix["Neck, side"][17] = {};
	aPuncturingCritMatrix["Neck, side"][18] = {};
	aPuncturingCritMatrix["Neck, side"][19] = {};
	aPuncturingCritMatrix["Neck, side"][20] = {};
	aPuncturingCritMatrix["Neck, side"][21] = {};
	aPuncturingCritMatrix["Neck, side"][22] = {};
	aPuncturingCritMatrix["Neck, side"][23] = {};
	aPuncturingCritMatrix["Neck, side"][24] = {};

	aPuncturingCritMatrix["Head, side"][1] = {};
	aPuncturingCritMatrix["Head, side"][2] = {};
	aPuncturingCritMatrix["Head, side"][3] = {};
	aPuncturingCritMatrix["Head, side"][4] = {};
	aPuncturingCritMatrix["Head, side"][5] = {};
	aPuncturingCritMatrix["Head, side"][6] = {};
	aPuncturingCritMatrix["Head, side"][7] = {};
	aPuncturingCritMatrix["Head, side"][8] = {};
	aPuncturingCritMatrix["Head, side"][9] = {};
	aPuncturingCritMatrix["Head, side"][10] = {};
	aPuncturingCritMatrix["Head, side"][11] = {};
	aPuncturingCritMatrix["Head, side"][12] = {};
	aPuncturingCritMatrix["Head, side"][13] = {};
	aPuncturingCritMatrix["Head, side"][14] = {};
	aPuncturingCritMatrix["Head, side"][15] = {};
	aPuncturingCritMatrix["Head, side"][16] = {};
	aPuncturingCritMatrix["Head, side"][17] = {};
	aPuncturingCritMatrix["Head, side"][18] = {};
	aPuncturingCritMatrix["Head, side"][19] = {};
	aPuncturingCritMatrix["Head, side"][20] = {};
	aPuncturingCritMatrix["Head, side"][21] = {};
	aPuncturingCritMatrix["Head, side"][22] = {};
	aPuncturingCritMatrix["Head, side"][23] = {};
	aPuncturingCritMatrix["Head, side"][24] = {};
	
	aPuncturingCritMatrix["Head, back lower"][1] = {};
	aPuncturingCritMatrix["Head, back lower"][2] = {};
	aPuncturingCritMatrix["Head, back lower"][3] = {};
	aPuncturingCritMatrix["Head, back lower"][4] = {};
	aPuncturingCritMatrix["Head, back lower"][5] = {};
	aPuncturingCritMatrix["Head, back lower"][6] = {};
	aPuncturingCritMatrix["Head, back lower"][7] = {};
	aPuncturingCritMatrix["Head, back lower"][8] = {};
	aPuncturingCritMatrix["Head, back lower"][9] = {};
	aPuncturingCritMatrix["Head, back lower"][10] = {};
	aPuncturingCritMatrix["Head, back lower"][11] = {};
	aPuncturingCritMatrix["Head, back lower"][12] = {};
	aPuncturingCritMatrix["Head, back lower"][13] = {};
	aPuncturingCritMatrix["Head, back lower"][14] = {};
	aPuncturingCritMatrix["Head, back lower"][15] = {};
	aPuncturingCritMatrix["Head, back lower"][16] = {};
	aPuncturingCritMatrix["Head, back lower"][17] = {};
	aPuncturingCritMatrix["Head, back lower"][18] = {};
	aPuncturingCritMatrix["Head, back lower"][19] = {};
	aPuncturingCritMatrix["Head, back lower"][20] = {};
	aPuncturingCritMatrix["Head, back lower"][21] = {};
	aPuncturingCritMatrix["Head, back lower"][22] = {};
	aPuncturingCritMatrix["Head, back lower"][23] = {};
	aPuncturingCritMatrix["Head, back lower"][24] = {};
	
	aPuncturingCritMatrix["Face, lower side"][1] = {};
	aPuncturingCritMatrix["Face, lower side"][2] = {};
	aPuncturingCritMatrix["Face, lower side"][3] = {};
	aPuncturingCritMatrix["Face, lower side"][4] = {};
	aPuncturingCritMatrix["Face, lower side"][5] = {};
	aPuncturingCritMatrix["Face, lower side"][6] = {};
	aPuncturingCritMatrix["Face, lower side"][7] = {};
	aPuncturingCritMatrix["Face, lower side"][8] = {};
	aPuncturingCritMatrix["Face, lower side"][9] = {};
	aPuncturingCritMatrix["Face, lower side"][10] = {};
	aPuncturingCritMatrix["Face, lower side"][11] = {};
	aPuncturingCritMatrix["Face, lower side"][12] = {};
	aPuncturingCritMatrix["Face, lower side"][13] = {};
	aPuncturingCritMatrix["Face, lower side"][14] = {};
	aPuncturingCritMatrix["Face, lower side"][15] = {};
	aPuncturingCritMatrix["Face, lower side"][16] = {};
	aPuncturingCritMatrix["Face, lower side"][17] = {};
	aPuncturingCritMatrix["Face, lower side"][18] = {};
	aPuncturingCritMatrix["Face, lower side"][19] = {};
	aPuncturingCritMatrix["Face, lower side"][20] = {};
	aPuncturingCritMatrix["Face, lower side"][21] = {};
	aPuncturingCritMatrix["Face, lower side"][22] = {};
	aPuncturingCritMatrix["Face, lower side"][23] = {};
	aPuncturingCritMatrix["Face, lower side"][24] = {};

	aPuncturingCritMatrix["Face, lower center"][1] = {};
	aPuncturingCritMatrix["Face, lower center"][2] = {};
	aPuncturingCritMatrix["Face, lower center"][3] = {};
	aPuncturingCritMatrix["Face, lower center"][4] = {};
	aPuncturingCritMatrix["Face, lower center"][5] = {};
	aPuncturingCritMatrix["Face, lower center"][6] = {};
	aPuncturingCritMatrix["Face, lower center"][7] = {};
	aPuncturingCritMatrix["Face, lower center"][8] = {};
	aPuncturingCritMatrix["Face, lower center"][9] = {};
	aPuncturingCritMatrix["Face, lower center"][10] = {};
	aPuncturingCritMatrix["Face, lower center"][11] = {};
	aPuncturingCritMatrix["Face, lower center"][12] = {};
	aPuncturingCritMatrix["Face, lower center"][13] = {};
	aPuncturingCritMatrix["Face, lower center"][14] = {};
	aPuncturingCritMatrix["Face, lower center"][15] = {};
	aPuncturingCritMatrix["Face, lower center"][16] = {};
	aPuncturingCritMatrix["Face, lower center"][17] = {};
	aPuncturingCritMatrix["Face, lower center"][18] = {};
	aPuncturingCritMatrix["Face, lower center"][19] = {};
	aPuncturingCritMatrix["Face, lower center"][20] = {};
	aPuncturingCritMatrix["Face, lower center"][21] = {};
	aPuncturingCritMatrix["Face, lower center"][22] = {};
	aPuncturingCritMatrix["Face, lower center"][23] = {};
	aPuncturingCritMatrix["Face, lower center"][24] = {};
	
	aPuncturingCritMatrix["Head, back upper"][1] = {};
	aPuncturingCritMatrix["Head, back upper"][2] = {};
	aPuncturingCritMatrix["Head, back upper"][3] = {};
	aPuncturingCritMatrix["Head, back upper"][4] = {};
	aPuncturingCritMatrix["Head, back upper"][5] = {};
	aPuncturingCritMatrix["Head, back upper"][6] = {};
	aPuncturingCritMatrix["Head, back upper"][7] = {};
	aPuncturingCritMatrix["Head, back upper"][8] = {};
	aPuncturingCritMatrix["Head, back upper"][9] = {};
	aPuncturingCritMatrix["Head, back upper"][10] = {};
	aPuncturingCritMatrix["Head, back upper"][11] = {};
	aPuncturingCritMatrix["Head, back upper"][12] = {};
	aPuncturingCritMatrix["Head, back upper"][13] = {};
	aPuncturingCritMatrix["Head, back upper"][14] = {};
	aPuncturingCritMatrix["Head, back upper"][15] = {};
	aPuncturingCritMatrix["Head, back upper"][16] = {};
	aPuncturingCritMatrix["Head, back upper"][17] = {};
	aPuncturingCritMatrix["Head, back upper"][18] = {};
	aPuncturingCritMatrix["Head, back upper"][19] = {};
	aPuncturingCritMatrix["Head, back upper"][20] = {};
	aPuncturingCritMatrix["Head, back upper"][21] = {};
	aPuncturingCritMatrix["Head, back upper"][22] = {};
	aPuncturingCritMatrix["Head, back upper"][23] = {};
	aPuncturingCritMatrix["Head, back upper"][24] = {};
	
	aPuncturingCritMatrix["Face, upper side"][1] = {};
	aPuncturingCritMatrix["Face, upper side"][2] = {};
	aPuncturingCritMatrix["Face, upper side"][3] = {};
	aPuncturingCritMatrix["Face, upper side"][4] = {};
	aPuncturingCritMatrix["Face, upper side"][5] = {};
	aPuncturingCritMatrix["Face, upper side"][6] = {};
	aPuncturingCritMatrix["Face, upper side"][7] = {};
	aPuncturingCritMatrix["Face, upper side"][8] = {};
	aPuncturingCritMatrix["Face, upper side"][9] = {};
	aPuncturingCritMatrix["Face, upper side"][10] = {};
	aPuncturingCritMatrix["Face, upper side"][11] = {};
	aPuncturingCritMatrix["Face, upper side"][12] = {};
	aPuncturingCritMatrix["Face, upper side"][13] = {};
	aPuncturingCritMatrix["Face, upper side"][14] = {};
	aPuncturingCritMatrix["Face, upper side"][15] = {};
	aPuncturingCritMatrix["Face, upper side"][16] = {};
	aPuncturingCritMatrix["Face, upper side"][17] = {};
	aPuncturingCritMatrix["Face, upper side"][18] = {};
	aPuncturingCritMatrix["Face, upper side"][19] = {};
	aPuncturingCritMatrix["Face, upper side"][20] = {};
	aPuncturingCritMatrix["Face, upper side"][21] = {};
	aPuncturingCritMatrix["Face, upper side"][22] = {};
	aPuncturingCritMatrix["Face, upper side"][23] = {};
	aPuncturingCritMatrix["Face, upper side"][24] = {};
	
	aPuncturingCritMatrix["Face, upper center"][1] = {};
	aPuncturingCritMatrix["Face, upper center"][2] = {};
	aPuncturingCritMatrix["Face, upper center"][3] = {};
	aPuncturingCritMatrix["Face, upper center"][4] = {};
	aPuncturingCritMatrix["Face, upper center"][5] = {};
	aPuncturingCritMatrix["Face, upper center"][6] = {};
	aPuncturingCritMatrix["Face, upper center"][7] = {};
	aPuncturingCritMatrix["Face, upper center"][8] = {};
	aPuncturingCritMatrix["Face, upper center"][9] = {};
	aPuncturingCritMatrix["Face, upper center"][10] = {};
	aPuncturingCritMatrix["Face, upper center"][11] = {};
	aPuncturingCritMatrix["Face, upper center"][12] = {};
	aPuncturingCritMatrix["Face, upper center"][13] = {};
	aPuncturingCritMatrix["Face, upper center"][14] = {};
	aPuncturingCritMatrix["Face, upper center"][15] = {};
	aPuncturingCritMatrix["Face, upper center"][16] = {};
	aPuncturingCritMatrix["Face, upper center"][17] = {};
	aPuncturingCritMatrix["Face, upper center"][18] = {};
	aPuncturingCritMatrix["Face, upper center"][19] = {};
	aPuncturingCritMatrix["Face, upper center"][20] = {};
	aPuncturingCritMatrix["Face, upper center"][21] = {};
	aPuncturingCritMatrix["Face, upper center"][22] = {};
	aPuncturingCritMatrix["Face, upper center"][23] = {};
	aPuncturingCritMatrix["Face, upper center"][24] = {};
	
	aPuncturingCritMatrix["Head, top"][1] = {};
	aPuncturingCritMatrix["Head, top"][2] = {};
	aPuncturingCritMatrix["Head, top"][3] = {};
	aPuncturingCritMatrix["Head, top"][4] = {};
	aPuncturingCritMatrix["Head, top"][5] = {};
	aPuncturingCritMatrix["Head, top"][6] = {};
	aPuncturingCritMatrix["Head, top"][7] = {};
	aPuncturingCritMatrix["Head, top"][8] = {};
	aPuncturingCritMatrix["Head, top"][9] = {};
	aPuncturingCritMatrix["Head, top"][10] = {};
	aPuncturingCritMatrix["Head, top"][11] = {};
	aPuncturingCritMatrix["Head, top"][12] = {};
	aPuncturingCritMatrix["Head, top"][13] = {};
	aPuncturingCritMatrix["Head, top"][14] = {};
	aPuncturingCritMatrix["Head, top"][15] = {};
	aPuncturingCritMatrix["Head, top"][16] = {};
	aPuncturingCritMatrix["Head, top"][17] = {};
	aPuncturingCritMatrix["Head, top"][18] = {};
	aPuncturingCritMatrix["Head, top"][19] = {};
	aPuncturingCritMatrix["Head, top"][20] = {};
	aPuncturingCritMatrix["Head, top"][21] = {};
	aPuncturingCritMatrix["Head, top"][22] = {};
	aPuncturingCritMatrix["Head, top"][23] = {};
	aPuncturingCritMatrix["Head, top"][24] = {};
end

function buildCritLocationInfo()
	aCritLocations["Foot, top"] 			    = { dam=0.1, isLeg=true, skeletal={"Tarsus"}, muscular={"1d5 Extensor Tendons of the Toes"}};
	aCritLocations["Heel"] 						= { dam=0.1, isLeg=true, skeletal={"Os Calcis"}, muscular={"Achilles Tendon"}};
	aCritLocations["Toe(s)"] 					= { dam=0.01, isLeg=true, isDigit=true, skeletal={"1d10 Metatarsus and Phalanges Bones"}, muscular={"1d5 Extensor Tendons of the Toes"}};
	aCritLocations["Foot, arch"] 				= { dam=0.1, isLeg=true, skeletal={"Tarsus"}, muscular={"Extensor Brevis Hallucis"}};
	aCritLocations["Ankle, inner"] 				= { dam=0.15, isLeg=true, skeletal={"Internal Malleolus"}, muscular={"Soleus"}};
	aCritLocations["Ankle, outer"] 				= { dam=0.15, isLeg=true, skeletal={"External Malleolus"}, muscular={"Extensor Longus Digitorum", "Peroneous Longus et Brevis"}};
	aCritLocations["Ankle, upper/Achilles"] 	= { dam=0.15, isLeg=true, skeletal={"Internal Malleolus", "External Malleolus"}, muscular={"Tibialis Anticus", "Extensor Longus Hallucis"}};
	aCritLocations["Shin"] 				 		= { dam=0.25, isLeg=true, skeletal={"Fibula", "Tibia"}, muscular={"Tibialis Anticus", "Soleus"}};
	aCritLocations["Calf"] 				 		= { dam=0.25, isLeg=true, skeletal={"Fibula", "Tibia"}, muscular={"Soleus", "Gastrocnemius"}};
	aCritLocations["Knee"] 				 		= { dam=0.25, isLeg=true, skeletal={"Outer Tuberosity of the Femur", "Patella", "Inner Tuberosity of the Femur"}, muscular={"Patella Tendon"}};
	aCritLocations["Knee, back"] 		 		= { dam=0.25, isLeg=true, skeletal={"Condyle of Femur"}, muscular={"Gastrocnemius"}};
	aCritLocations["Hamstring"] 		 		= { dam=1.0, isLeg=true, skeletal={"Femur"}, muscular={"Biceps Femoris"}};
	aCritLocations["Thigh"] 			 		= { dam=1.0, isLeg=true, skeletal={"Femur"}, muscular={"Tendon of the Extensors of the Leg", "Vastus Internus", "Vastus Externus", "Adductor Magnus", "Rectus Femoris"}};
	aCritLocations["Hip"] 				 		= { dam=1.0, isLeg=true, skeletal={"Trochanter", "Neck of the Femur", "Head of the Femur", "Illium"}, muscular={"Gluteus Medius", "Tensor Vaginae Femoris"}, vital={"Large Intestine", "Small Intestine"}};
	aCritLocations["Groin"] 			 		= { dam=0.2, isLeg=true, skeletal={"Os Pubis"}, muscular={"Adductor Magnus", "Extensor Longus Digitorum", "Pectineus", "Adductor Longus"}, vital={"Bladder", "Small Intestine"}};
	aCritLocations["Buttock"] 			 		= { dam=1.0, isLeg=true, skeletal={"Ilium", "Sacrum", "Coccyx"}, muscular={"Gluteus Maximus"}, vital={} };
	aCritLocations["Abdomen, Lower"] 	 		= { dam=1.0, isTorso=true, skeletal={"Ilium", "Os Pubis", "Sacrum"}, muscular={"Aponeurosis of Obliquus Externus Abdominis", "Rectus Abdominis"}, vital={"Pancreas", "Duodenum", "Kidney", "Small Intestine"} };
	aCritLocations["Side, lower"] 	 	 		= { dam=0.8, isTorso=true, skeletal={"Crest of the Ilium", "1d2 Lumbar Vertebrae: 2nd to 3rd"}, muscular={"Crest of the Ilium", "Obliquus Internus Abdominis"}, vital={"Spleen or Liver", "Lung"} };
	aCritLocations["Abdomen, upper"] 	 		= { dam=1.0, isTorso=true, skeletal={"1d2 Lumbar Vertebrae: 2nd to 3rd"}, muscular={"Aponeurosis of Obliquus Externus Abdominis", "Rectus Abdominis"}, vital={"Spleen", "Stomach", "Liver"} };
	aCritLocations["Back, small of"] 	 		= { dam=1.0, isTorso=true, isSpine=true, skeletal={"1d3 Lumbar Vertebrae: 1st to 3rd"}, muscular={"External Oblique", "Erector Spinae"}, vital={"Kidney", "Spinal Cord"} };
	aCritLocations["Back, lower"] 		 		= { dam=1.0, isTorso=true, isSpine=true, skeletal={"1d3 Lumbar Vertebrae: 1st to 3rd"}, muscular={"Latissimus Dorsi"}, vital={"1d2 Kidneys", "Spinal Cord"} };
	aCritLocations["Chest"] 			 		= { dam=1.0, isTorso=true, isSpine=true, skeletal={"1d6 Lower Ribs", "1d6 Upper Ribs", "Sternum: Manubrium", "Sternum: Gladiolus"}, muscular={"Aponeurosis of Obliquus Externus Abdominis", "Obliquus Externus Abdominis", "Rectus Abdominis"}, vital={"Lung", "Heart", "Spinal Cord"} };
	aCritLocations["Side, upper"] 		 		= { dam=0.8, isTorso=true, skeletal={"1d6 Lower Ribs", "1d6 Upper Ribs"}, muscular={"Serratus Magnus", "Obliquus Externus Abdominis"}, vital={"Lung"} };
	aCritLocations["Back, upper"] 		 		= { dam=1.0, isTorso=true, isSpine=true, skeletal={"Scapula", "1d4 Upper Ribs", "1d4 Middle Ribs", "1d4 Lower Ribs"}, muscular={"Deltoid", "Teres Major"}, vital={"Spinal Cord"} };
	aCritLocations["Back, upper middle"] 	    = { dam=1.0, isTorso=true, isSpine=true, skeletal={"1d4 Lower Dorsal Vertebrae: 9th to 12th", "1d4 Middle Dorsal Vertebrae: 5th to 8th", "1d4 Upper Dorsal Vertebrae: 1st to 4th"}, muscular={"Trapezius"}, vital={"Spinal Cord"} };
	aCritLocations["Armpit"] 			 	    = { dam=0.3, isArm=true, skeletal={"Head of the Humerus", "Scapula", "1d3 Ribs"}, muscular={"Pectoralis Major", "Coraco-brachialis", "Deltoid"}, vital={} };
	aCritLocations["Arm, upper outer"]   	    = { dam=0.3, isArm=true, skeletal={"Humerus"}, muscular={"Triceps Extensor Cubiti", "Biceps Flexor Cubiti"}, vital={} };
	aCritLocations["Arm, upper inner"]   	    = { dam=0.3, isArm=true, skeletal={"Humerus"}, muscular={"Trcipes Extensor Cubiti", "Biceps Flexor Cubiti"}, vital={} };
	aCritLocations["Elbow"] 		     	    = { dam=0.25, isArm=true, skeletal={"Olecranon Process of the Ulna"}, muscular={"Flexor Longus Pollicis"}, vital={} };
	aCritLocations["Inner joint"] 	     	    = { dam=0.25, isArm=true, skeletal={"Trochlea", "Radial Head of the Humerus"}, muscular={"Pronator Radii Teres", "Supinator Longus"}, vital={} };
	aCritLocations["Forearm, back"]      	    = { dam=0.25, isArm=true, skeletal={"Radius", "Ulna"}, muscular={"Extensor Carpi Radialis Brevior", "Extensor Carpi Radialis Longior"}, vital={} };
	aCritLocations["Forearm, inner"]     	    = { dam=0.25, isArm=true, skeletal={"Ulna", "Radius"}, muscular={"Palmaris Longus", "Supinator Longus", "Flexor Carpi Radialis"}, vital={} };
	aCritLocations["Wrist, back"]        	    = { dam=0.25, isArm=true, skeletal={"1d8 Carpus Bones"}, muscular={"Anterior Annular Ligament of the Wrist"}, vital={} };
	aCritLocations["Wrist, front"]       	    = { dam=0.25, isArm=true, skeletal={"1d8 Carpus Bones"}, muscular={"Anterior Annular Ligament of the Wrist"}, vital={} };
	aCritLocations["Hand, back"]         	    = { dam=0.1, isArm=true, skeletal={"1d5 Metacarpus Bones"}, muscular={"Extensor Communis Digitorum", "1d5 Flexor Tendons of the Fingers"}, vital={} };
	aCritLocations["Palm"]               	    = { dam=0.1, isArm=true, skeletal={"1d5 Metacarpus Bones"}, muscular={"Plamaris Brevis", "Abductor Pollicis"}, vital={} };
	aCritLocations["Finger(s)"]          	    = { dam=0.01, isArm=true, isDigit=true, skeletal={"1d4+1 Phalanges"}, muscular={"1d5 Flexor Tendons of the Fingers"}, vital={} };
	aCritLocations["Shoulder, side"]     	    = { dam=0.3, isArm=true, skeletal={"Head of the Humerus"}, muscular={"Deltoid", "Long Tendon of the Biceps Flexor Cubiti", "Tendon of the Pectoralis Major", "Coraco-brachialis"}, vital={} };
	aCritLocations["Shoulder, top"]      	    = { dam=0.3, isArm=true, skeletal={"Head of the Humerus", "Coracoid Process of the Scapula", "Clavicle"}, muscular={"Subclavius", "Deltoid"}, vital={} };
	aCritLocations["Neck, back"]        	    = { dam=1.0, isHead=true, isSpine=true, skeletal={"1d4 Cervical Vertebrae from 7th to 4th", "1d4 Cervical Vertebrae from 2nd to 5th"}, muscular={"Sterno-hyoid Muscle", "Omo-Hyoid Muscle", "Thyro-hyoid Muscle"}, vital={"Trachea", "Spinal Cord"} };
	aCritLocations["Neck, back"]         	    = { dam=1.0, isHead=true, isSpine=true, skeletal={"1d6 Cervical Vertebrae from 2nd to 7th"}, muscular={"Trapezius"}, vital={"Spinal Cord"} };
	aCritLocations["Neck, side"]         	    = { dam=1.0, isHead=true, isSpine=true, skeletal={"1d4 Cervical Vertebrae from 7th to 4th", "1d4 Cervical Vertebrae from 2nd to 5th"}, muscular={"Platysma Moyides", "Scalenus Anticus, Medius and Posticus"}, vital={"Trachea", "Spinal Cord"} };
	aCritLocations["Head, side"]         	    = { dam=1.0, isHead=true, skeletal={"Parietal Bone"}, muscular={"Masseter"}, vital={"Brain"} };
	aCritLocations["Head, back lower"]   	    = { dam=1.0, isHead=true, isSpine=true, skeletal={"Basilar Process of the Occipital Bone", "First Cervical Vertebrae", "Occipital Bone"}, muscular={"Trapezius"}, vital={"Medulla Oblongata", "Spinal Cord"} };
	aCritLocations["Face, lower side"]   	    = { dam=1.0, isHead=true, skeletal={"Inferior Maxillary Bone", "Mastoid Temporal Bone"}, muscular={"Zygomaticus Major and Minor", "Buccinator"}, vital={} };
	aCritLocations["Face, lower center"] 	    = { dam=1.0, isHead=true, isSpine=true, skeletal={"Inferior Maxillary Bone", "Teeth", "Superior Maxillary Bones"}, muscular={"Quadratus Menti", "Quadratus Oris"}, vital={"Spinal Cord"} }; 
	aCritLocations["Head, back upper"]   	    = { dam=1.0, isHead=true, skeletal={"Parietal Bones"}, muscular={"Occipito-frontalis"}, vital={"Brain"} };
	aCritLocations["Face, upper side"]   	    = { dam=1.0, isHead=true, skeletal={"Temporal Bone", "Sphenoid Bone"}, muscular={"Temporalis"}, vital={"Brain"} };
	aCritLocations["Face, upper center"] 	    = { dam=1.0, isHead=true, skeletal={"Nasal Bones", "Frontal Bone, Lower", "Frontal Bone, Upper"}, muscular={"Occipito-frontalis", "Orbicularis Palpebrarum", "Levator Labii Superioris"}, vital={"Brain"} };
	aCritLocations["Head, top"] 		 	    = { dam=1.0, isHead=true, skeletal={"Frontal Bone"}, muscular={"Occipito-frontalis"}, vital={"Brain"} };
end