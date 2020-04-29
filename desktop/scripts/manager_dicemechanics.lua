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

function needsPenetrationRoll(rSides, rResult, penPlus)
	if rSides <= 2 then
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

