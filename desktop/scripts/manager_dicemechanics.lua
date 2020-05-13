function onInit()
	registerDiceMechanic("penDice", processPenetratingDice, processDefaultResults)
	registerDiceMechanic("penDicePlus", processPenetratingDicePlus, processDefaultResults)
	Comm.registerSlashHandler("pdie", onPenetratingDiceSlashCommand)
	Comm.registerSlashHandler("pdiep", onPenetratingDicePlusSlashCommand)
	Comm.registerSlashHandler("pen", onPenetratingDiceSlashCommand)
	Comm.registerSlashHandler("penplus", onPenetratingDicePlusSlashCommand)
end

function handlePenetration(rRoll, penPlus)
  DiceMechanicsManager.checkForPenetration(rRoll, penPlus);  
  DiceMechanicsManager.createPenetrationDice(rRoll);
end

function createPenetrationDice(rRoll)
  for _,vDie in ipairs(rRoll.aDice) do
	local sSign, sColor, sDieSides = vDie.type:match("^([%-%+]?)([dDrRgGbBpP])([%dF]+)");
	if vDie.penetrationRolls then
		vDie.type = "b" .. sDieSides;
		for _, rPenRoll in ipairs(vDie.penetrationRolls) do
			local newDie = {}
			newDie.type = "r" .. sDieSides
			newDie.result = rPenRoll - 1
			table.insert(rRoll.aDice, newDie);
		end		
	end
  end
end

function checkForPenetration(rRoll, penPlus)
  for _,vDie in ipairs(rRoll.aDice) do
    local sSign, sColor, sDieSides = vDie.type:match("^([%-%+]?)([dDrRgGbBpP])([%dF]+)");
	local nSides = tonumber(sDieSides) or 0;
	if DiceMechanicsManager.needsPenetrationRoll(nSides, vDie.result, penPlus) then	
		local lRolls = {};
	  	DiceMechanicsManager.getPenetrationRolls(lRolls, nSides, penPlus);
		vDie.penetrationRolls = lRolls;
    end
  end
end

function getDamageRoll(nNumDice, nNumSides, nBonus) -- Rolls with penetration, minimum of 1
	local nTotal = getDiceResult(nNumDice, nNumSides, 1, nBonus);
	return math.max(nTotal, 1);
end

function getDiceResult(nNumDice, nNumSides, nPenetration, nBonus) -- nPenetration 0 = normal roll, 1 = penetration, 2 = penetration plus
	if not nBonus then nBonus = 0; end
	local nTotal = 0;
	for i = 1, nNumDice, 1 do
		nTotal = nTotal + getDieResult(nNumDice, nPenetration);
	end
	if nBonus then
		nTotal = nTotal + nBonus;
	end
	return nTotal;
end

function getDieResult(nNumSides, nPenetration) -- nPenetration 0 = normal roll, 1 = penetration, 2 = penetration plus
	if not nPenetration or nNumSides <= 3 then nPenetration = 0; end
	
	local nDieResult = math.random(1, nNumSides);
	if (nPenetration ~= 0 and nDieResult == nNumSides) or (nPenetration == 2 and nDieResult == nNumSides - 1) then
		nDieResult = nDieResult + getDiceResult(nNumSides, nPenetration) - 1;
	end
	return nDieResult;
end

function needsPenetrationRoll(rSides, rResult, penPlus)
	if rSides <= 3 then
		return false
	elseif rResult == rSides  then
		return true
	elseif penPlus and rResult == rSides - 1 then
		return true
	else
		return false
	end
end

function getPenetrationRolls(rRolls, rSides, penPlus)
	
	local lDamage = math.random(1, rSides);
	table.insert(rRolls, lDamage);
	
	if needsPenetrationRoll(rSides, lDamage, penPlus) then	
		getPenetrationRolls(rRolls, rSides, penPlus)
	end	
end

function toCommaSepartedString(tt)
	local s = "";
	for _, p in ipairs(tt) do
		s = s .. "," .. p
	end
	return string.sub(s, 2);
end

function totalPenetrationDamage(rRolls)
	local lDamage = 0;
	for _, rRoll in ipairs(rRolls) do
		lDamage = lDamage + rRoll - 1;
	end
	return lDamage;
end


function onPenetratingDiceSlashCommand(sCmd, sParam)
	if sParam then
		local sDieString = sParam
		local sDescription1 = sParam
		local nSeparationStart, nSeparationEnd = sParam:find("%s+")
		if nSeparationStart then
			sDieString = sParam:sub(1, nSeparationStart-1)
			sDescription1 = sParam:sub(nSeparationEnd+1)
		end
		
		local aDices, nMod = StringManager.convertStringToDice(sDieString)
	
		local rThrow = {}
		rThrow.type = "penDice"
		rThrow.description = sDescription1
		rThrow.secret = false
	
		local rSlot = {}
		rSlot.dice = aDices
		rSlot.number = nMod
		rSlot.custom = {}
		rThrow.slots = { rSlot }
	
		Comm.throwDice(rThrow)
	end
end

function onPenetratingDicePlusSlashCommand(sCmd, sParam)
	if sParam then
		local sDieString = sParam
		local sDescription1 = sParam
		local nSeparationStart, nSeparationEnd = sParam:find("%s+")
		if nSeparationStart then
			sDieString = sParam:sub(1, nSeparationStart-1)
			sDescription1 = sParam:sub(nSeparationEnd+1)
		end
		
		local aDices, nMod = StringManager.convertStringToDice(sDieString)
	
		local rThrow = {}
		rThrow.type = "penDicePlus"
		rThrow.description = sDescription1
		rThrow.secret = false
	
		local rSlot = {}
		rSlot.dice = aDices
		rSlot.number = nMod
		rSlot.custom = {}
		rThrow.slots = { rSlot }
	
		Comm.throwDice(rThrow)
	end
end

local aDiceMechanicHandlers = {}
local aDiceMechanicResultHandlers = {}
function registerDiceMechanic(sDiceMechanicType, callback, callbackResults)
	aDiceMechanicHandlers[sDiceMechanicType] = callback
	if callbackResults then
		aDiceMechanicResultHandlers[sDiceMechanicType] = callbackResults
	end
end
function unregisterDiceMechanic(sDiceMechanicType)
	if aDiceMechanicHandlers then
		aDiceMechanicHandlers[sDiceMechanicType] = nil
		aDiceMechanicResultHandlers[sDiceMechanicType] = nil
	end
end

function onDiceLanded(draginfo)
	local sDragType = draginfo.getType()
	local bProcessed = false
	local bPreventProcess = false
	
	local rCustomData = draginfo.getCustomData() or {}
	
	-- dice handling
	for sType, fCallback in pairs(aDiceMechanicHandlers) do
		if sType == sDragType then
			bProcessed, bPreventProcess = fCallback(draginfo)
		end
	end
	
	-- results
	if not bPreventProcess then
		for sType, fCallback in pairs(aDiceMechanicResultHandlers) do
			if sType == sDragType then
				fCallback(draginfo)
			end
		end
	end
	
	return bProcessed
end

-- penetrate on max
function processPenetratingDice(draginfo)
	return processPenetration(draginfo, false)
end

-- Penetrate on max and max -1
function processPenetratingDicePlus(draginfo)
	return processPenetration(draginfo, true)
end

function getNumOriginalDice(aDice)
	local nNumDice = #aDice;
	for _, vDie in ipairs(aDice) do
		if vDie.penetrationRolls then
			nNumDice = nNumDice - #vDie.penetrationRolls;
		end
	end
	return nNumDice;
end

-- penetration means if you roll max on the die (or also max -1 for penPlus), you roll again and subtract 1
function processPenetration(draginfo, penPlus)

	local rSource, rRolls, aTargets = ActionsManager.decodeActionFromDrag(draginfo, true);
	
	for _,vRoll in ipairs(rRolls) do
		if (#(vRoll.aDice) > 0) or ((vRoll.aDice.expr or "") ~= "") then
			handlePenetration(vRoll, penPlus);
			ActionsManager.resolveAction(rSource, nil, vRoll);
		end
	end
end

function getHonorModifier(nHonorState)
	if nHonorState == 1 then
		return 1;
	elseif nHonorState == -1 then
		return -1;
	else
		return 0;
	end
end

function modifyRollForHonor(rRoll, nHonorState)
	if nHonorState == 1 then
		rRoll.sDesc = rRoll.sDesc .. "[Great Honor]";
		rRoll.nMod = rRoll.nMod + #rRoll.aDice
	elseif nHonorState == -1 then
		rRoll.sDesc = rRoll.sDesc .. "[Dishonor]";
		rRoll.nMod = rRoll.nMod - #rRoll.aDice
	end
--	if nHonorState == 1 then
--		-- Great honor. Add 1 to every die
--		rRoll.sDesc = rRoll.sDesc .. "[Great Honor]";
--		for _, vDie in ipairs(rRoll.aDice) do
--			vDie.result = vDie.result + 1;
--		end
--	elseif nHonorState == -1 then
--		-- Dishonor. Subtract 1 from every die. Minimum 0 on a die
--		rRoll.sDesc = rRoll.sDesc .. "[Dishonor]";
--		for _, vDie in ipairs(rRoll.aDice) do
--			if vDie.result > 0 then
--				vDie.result = vDie.result -1;
--			end
--		end
--	end
end