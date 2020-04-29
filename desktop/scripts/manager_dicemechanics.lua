-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	registerDiceMechanic("penDice", processPenetratingDice, processDefaultResults)
	registerDiceMechanic("penDicePlus", processPenetratingDicePlus, processDefaultResults)
	Comm.registerSlashHandler("pdie", onPenetratingDiceSlashCommand)
	Comm.registerSlashHandler("pdiep", onPenetratingDicePlusSlashCommand)
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

function decodeDiceResults(sSource)
	if not sSource then
		return {}
	end
	local aDieResults = {}
	local nIndex = 0
	while nIndex do
		local nStartIndex, nNextIndex = sSource:find("^d%d+:%d+:%d;", nIndex)
		if nNextIndex then
			local sDieSource = sSource:sub(nStartIndex, nNextIndex-1)
			local sType, sResult, sExploded = sDieSource:match("^(d%d+):(%d+):(%d)")
			table.insert(aDieResults, { type = sType, result = tonumber(sResult), exploded = tonumber(sExploded) })
			nIndex = nNextIndex + 1
		else
			nIndex = nil 
		end
	end
	return aDieResults
end
	
function encodeDiceResults(aDieResults)
	local sDieResults = ""
	for _,rDie in pairs(aDieResults) do
		sDieResults = sDieResults .. rDie.type .. ":" .. rDie.result .. ":" .. rDie.exploded .. ";"
	end
	return sDieResults
end

-- penetrate on max
function processPenetratingDice(draginfo)
	return processPenetration(draginfo, false)
end

-- Penetrate on max and max -1
function processPenetratingDicePlus(draginfo)
	return processPenetration(draginfo, true)
end

function getNumSides(rDieType)
	return tonumber(rDieType:match("^d(%d+)"))
end

function isMaxResult(rDie)
	local rSides = getNumSides(rDie.type)
	if rSides <= 2 then
		return 0
	elseif rDie.result >= rSides  then
		return 1
	elseif penPlus and rDie.result == rSides - 1 then
		return 1
	else
		return 0
	end
end

-- penetration means if you roll max on the die (or also max -1 for penPlus), you roll again and subtract 1
function processPenetration(draginfo, penPlus)
	local newRoll = function(draginfo, aDieResults, rCustomData, aExplodedDices)		
		local rThrow = {}
		rThrow.type = draginfo.getType()
		rThrow.description = draginfo.getDescription()
		rThrow.secret = draginfo.getSecret()
		rThrow.shortcuts = {}
		--rThrow.shortcuts = lShortcuts

		local rSlot = {}
		rSlot.number = draginfo.getNumberData()
		rSlot.dice = aExplodedDices
		rSlot.custom = rCustomData
		rThrow.slots = { rSlot }
	
		Comm.throwDice(rThrow)
	end

	local rCustomData = draginfo.getCustomData() or {}	
	local nKeep = rCustomData.keep
	local aPreviousDieResults = decodeDiceResults(rCustomData.rollresults)
	local aNewDieResults = {}

	for _, rDie in pairs(draginfo.getDieList() or {}) do
		table.insert(aNewDieResults, {type = rDie.type, result = rDie.result, exploded = isMaxResult(rDie)})
	end
	
	local aDieResults = {}
	if #aPreviousDieResults < 1 then
		aDieResults = aNewDieResults
	else
		for _, rDie in pairs(aPreviousDieResults) do
			if rDie.exploded == 1 then
				for nIndex, rNewDie in pairs(aNewDieResults) do
					if rNewDie.type == rDie.type then
						rDie.result = rDie.result + rNewDie.result - 1
						rDie.exploded = rNewDie.exploded
						table.remove(aNewDieResults, nIndex)
						
						break
					end
				end
			end
			table.insert(aDieResults, rDie)
		end
	end
	
	local aExplodedDices = {}
	for _, rDie in pairs(aDieResults) do
		if rDie.exploded == 1 then
			table.insert(aExplodedDices, rDie.type)
		end
	end
	
	if #aExplodedDices > 0 then
		local rCustomData = { keep = nKeep, rollresults = encodeDiceResults(aDieResults) }
		newRoll(draginfo, aDieResults, rCustomData, aExplodedDices)
		return true, true
	end
	
	rCustomData.rollresults = encodeDiceResults(aDieResults)
	draginfo.setCustomData(rCustomData)
	return true
end


function processDefaultResults(draginfo)
	local rCustomData = draginfo.getCustomData() or {}
	local aDieResults = decodeDiceResults(rCustomData.rollresults)
	for _, vDie in pairs(aDieResults) do
		if isMaxResult(vDie) == 1 then
			vDie.type = "b" .. getNumSides(vDie.type)
		end
	end
	


	local rMessage = ChatManager.createBaseMessage()
    rMessage.dicedisplay = 1; --  display total
	rMessage.font = "systemfont"
	rMessage.text = draginfo.getDescription()
	rMessage.dice = aDieResults
	rMessage.diemodifier = draginfo.getNumberData()
	Debug.console("manager_dicemechanics.lua","processDefaultResults","rMessage.dice",rMessage.dice);
	Comm.deliverChatMessage(rMessage)

	return true
end

