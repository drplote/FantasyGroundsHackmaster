function onInit()
	Comm.registerSlashHandler("crit", onCritSlashCommand);
end

function deliverChatMessage(sText)
	local rMessage = ChatManager.createBaseMessage();
	rMessage.type = "crit";
	rMessage.text = sText;
	Comm.deliverChatMessage(rMessage);
end

function onCritSlashCommand(sCmd, sParam)
	local sRollName = "Critical Hit Result";
	
	local sText = "[" .. sRollName .. "] " .. " Sure would be cool if this feature were implemented yet.";
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
	
	if bIsRightSide then
		sLocation = sLocation .. "(right) "
	else	
		sLocation = sLocation .. "(left) "
	end
	
	return sLocation, nMaxDamagePercentage;
end

function getCritEffect(nHitLocationRoll, nSeverity, sWeaponType)
	return "Some sort of " .. sWeaponType .. " hit not yet implemented";
end


function handleCrit(nAttackerThaco, nTargetAc, nAttackBonus, rSource, sWeaponType)
	local nBaseSeverity = calculateBaseSeverity(nAttackerThaco, nTargetAc, nAttackBonus);
	local nSeverity = math.min(nBaseSeverity + DiceMechanicsManager.rollPenetrateInBothDirection(8), 24);

	local sResult = "[Critical Hit]\r[Severity: " .. nSeverity .. "(Base " .. nBaseSeverity .. ")]"
	if nSeverity < 0 then	
		sResult = sResult .. "\rNo extra effect";
	else
		local nHitLocationRoll = math.random(1, 10000);
		local sLocation, nMaxDamagePercentage = getHitLocation(nHitLocationRoll);
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
		
		sResult = sResult .. "\r[Location (d10000=)" .. nHitLocationRoll .. "): " .. sLocation .. "]";
		sResult = sResult .. "\r[Effect: " .. getCritEffect(nHitLocationRoll, nSeverity, sWeaponType) .. "]";

	end

	deliverChatMessage(sResult);
end

function calculateBaseSeverity(nAttackerThaco, nTargetAc, nAttackBonus)
	local nToHitAc15 = nAttackerThaco - 15;
	return nTargetAc - nToHitAc15 + nAttackBonus;
end