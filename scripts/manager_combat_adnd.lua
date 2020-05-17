--
-- AD&D Specific combat needs
--
--

PC_LASTINIT = 0;

function onInit()
  -- replace default roll with adnd_roll to allow
  -- control-dice click to prompt for manual roll
  ActionsManager.roll = adnd_roll;
  --

  -- replace this with ours
  CombatManager.nextActor = nextActor;
  CombatManager.addBattle = addBattle;
  CombatManager.addNPCHelper = addNPCHelper_ADND;
  
  CombatManager2.rollEntryInit = rollEntryInit;
  CombatManager2.rollRandomInit = rollRandomInit;
  CombatManager2.clearExpiringEffects = clearExpiringEffects;
  ----
  CombatManager.setCustomSort(sortfuncADnD);
  CombatManager.setCustomAddNPC(addNPC);
  CombatManager.setCustomAddPC(addPC);
  
  CombatManager.setCustomCombatReset(resetInit);
  
  CombatManager.setCustomRoundStart(onRoundStart);
  
  CombatManager.setCustomTurnStart(onTurnStart);
  
  CombatManager.rollTypeInit = rollTypeInit;

  --if User.isHost() then
  DB.addHandler("combattracker.list.*.active", "onUpdate", updateInititiativeIndicator);
  OptionsManager.registerCallback("TOKEN_OPTION_INIT", initiativeTokenChanged);
  updateAllInititiativeIndicators();
  --end
end

function rollTypeInit(sType, fRollCombatantEntryInit, ...)
	for _,v in pairs(CombatManager.getCombatantNodes()) do
		local bRoll = true;
		if sType then
			local sClass,_ = DB.getValue(v, "link", "", "");
			if sType == "npc" and sClass == "charsheet" then
				bRoll = false;
			elseif sType == "pc" and sClass ~= "charsheet" then
				bRoll = false;
			end
		end
		
		if bRoll then
			DB.setValue(v, "previnitresult", "number", DB.getValue(v, "initresult", 0));
			DB.setValue(v, "initresult", "number", -10000);
		end
	end

	for _,v in pairs(CombatManager.getCombatantNodes()) do
		local bRoll = true;
		if sType then
			local sClass,_ = DB.getValue(v, "link", "", "");
			if sType == "npc" and sClass == "charsheet" then
				bRoll = false;
			elseif sType == "pc" and sClass ~= "charsheet" then
				bRoll = false;
			end
		end
		
		if bRoll then
			fRollCombatantEntryInit(v, ...);
		end
	end
end

-- In AD&D we don't remove effects unless shorter than 10 rounds (Turn) 
function clearExpiringEffects()
	function checkEffectExpire(nodeEffect)
		local sLabel = DB.getValue(nodeEffect, "label", "");
		local nDuration = DB.getValue(nodeEffect, "duration", 0);
		local sApply = DB.getValue(nodeEffect, "apply", "");
		--local bLongTerm = (nDuration ~= 0);
    local bExpiringSoon = (nDuration <= 10 and nDuration ~= 0);
    
		if bExpiringSoon or sApply ~= "" or sLabel == "" then
			nodeEffect.delete();
		end
	end
	CombatManager.callForEachCombatantEffect(checkEffectExpire);
end

-- clear initiative values
function resetInit()
  function resetCombatantInit(nodeCT)
    DB.setValue(nodeCT, "initresult", "number", 0);
    DB.setValue(nodeCT, "reaction", "number", 0);
	DB.setValue(nodeCT, "extrainitresult", "string", "");
    
    --set not rolled initiative portrait icon to active on new round
    CharlistManagerADND.turnOffInitRolled(nodeCT);
  end
  CombatManager.callForEachCombatant(resetCombatantInit);
end

function rollRandomInit(nMod, bADV)
  local nInitResult = math.random(DataCommonADND.nDefaultInitiativeDice);
  if bADV then
    nInitResult = math.max(nInitResult, math.random(DataCommonADND.nDefaultInitiativeDice));
  end
  nInitResult = nInitResult + nMod;
  return nInitResult;
end

-- TODO: move this to a util file
function toCsv(tt)
	local s = "";
	for _, p in ipairs(tt) do
		s = s .. "," .. p;
	end
	return string.sub(s, 2);
end

-- TODO: move this to a util file
function fromCsv(s)
	local tt = {};
	for m in s:gmatch("([^,]+)") do
		table.insert(tt, tonumber(m))
	end
	return tt;
end

function getExtraInits(node)
	local sExtraInits = DB.getValue(node, "extrainitresult", "");
	return fromCsv(sExtraInits);	
end

function addExtraInit(node, nInit)
	local aExtraInits = getExtraInits(node);
	table.insert(aExtraInits, nInit);
	table.sort(aExtraInits);
	DB.setValue(node, "extrainitresult", "string", toCsv(aExtraInits));
end

function addAnotherInit(node, nInit)
	
end


function rollEntryInit(nodeEntry)
	if not nodeEntry then
		return;
	end
	
	-- Start with the base initiative bonus
	local nInit = DB.getValue(nodeEntry, "init", 0);
--Debug.console("manager_combat_adnd","rollEntryInit","nInit",nInit);      	
	-- Get any effect modifiers
	local rActor = ActorManager.getActorFromCT(nodeEntry);
	local aEffectDice, nEffectBonus = EffectManager5E.getEffectsBonus(rActor, "INIT");
	local nInitMOD = StringManager.evalDice(aEffectDice, nEffectBonus);
	
	-- Check for the ADVINIT effect
	local bADV = EffectManager5E.hasEffectCondition(rActor, "ADVINIT");

	-- For PCs, we always roll unique initiative
	local sClass, sRecord = DB.getValue(nodeEntry, "link", "", "");
	if sClass == "charsheet" then
		local nodeChar = DB.findNode(sRecord);
		local nInitPC = DB.getValue(nodeChar,"initiative.total",0);
		local nInitResult = 0;
		local sOptPCINIT = OptionsManager.getOption("PCINIT");
		if sOptPCINIT == "group" then
		  if PC_LASTINIT == 0 then
			nInitResult = rollRandomInit(0, bADV);
			PC_LASTINIT = nInitResult;
		  else
			nInitResult = PC_LASTINIT;
		  end
		else
		  local nPreviousInitResult = DB.getValue(nodeEntry, "previnitresult", 0);
		  if nPreviousInitResult > 10 then
			-- If their init was > 10 last round then we subtract 10 to give them their new init.
			nInitResult = nPreviousInitResult - 10;
			
			-- Also need to update any "extra" inits as well, such as from multiple attacks
			local aExtraInits = getExtraInits(nodeEntry);
			if aExtraInits and #aExtraInits > 0 then
				for _,nExtraInit in aExtraInits do
					addExtraInit(nodeEntry, nExtraInit - 10);
				end
			end
		  else
			-- I don't like it autorolling, then just having people roll manually anyway. Set to 99 to make it clearer who hasn't rolled for themselves yet
			nInitResult = 99; 
			DB.setValue(nodeChar, "extrainitresult", "string", ""); -- probably unnecessary but clearing it anyway
		  --nInitResult = rollRandomInit(nInitPC + nInitMOD, bADV);
		  end
		end
		
		DB.setValue(nodeEntry, "initresult", "number", nInitResult);
		return;
	else -- it's an npc
    -- for npcs we allow them to have custom initiative. Check for it 
    -- and set nInit.
    local nTotal = DB.getValue(nodeEntry,"initiative.total",0);
    -- flip through weaponlist, get the largest speedfactor as default
    local nSpeedFactor = 0;
    for _,nodeWeapon in pairs(DB.getChildren(nodeEntry, "weaponlist")) do
      local nSpeed = DB.getValue(nodeWeapon,"speedfactor",0);
      if nSpeed > nSpeedFactor then
        nSpeedFactor = nSpeed;
      end
    end
	
    if nSpeedFactor ~= 0 then
      nInit = nSpeedFactor + nInitMOD ;
    elseif (nTotal ~= 0) then 
      nInit = nTotal + nInitMOD ;
    end


    -- For NPCs, if NPC init option is not group, then roll unique initiative
    local sOptINIT = OptionsManager.getOption("INIT");
    if sOptINIT ~= "group" then
      -- if they have custom init then we use it.
	  local nPreviousInit = DB.getValue(nodeEntry, "previnitresult", 0);
	  if nPreviousInit > 10 then -- If > 10, they didn't go last round and subtract 10 this round to get a new init
		DB.setValue(nodeEntry, "initresult", "number", nPreviousInit - 10);
		local aExtraInit = DB.getValue(nodeEntry, "extrainitresults", "");
		for _,nExtraInit in 
	  else
		local nInitResult = rollRandomInit(nInit, bADV);
		DB.setValue(nodeEntry, "initresult", "number", nInitResult);
	  end
      return;
    end

    -- For NPCs with group option enabled
    
    -- Get the entry's database node name and creature name
    local sStripName = CombatManager.stripCreatureNumber(DB.getValue(nodeEntry, "name", ""));
    if sStripName == "" then
      local nInitResult = rollRandomInit(nInit, bADV);
      DB.setValue(nodeEntry, "initresult", "number", nInitResult);
      return;
    end
      
    -- Iterate through list looking for other creature's with same name and faction
    local nLastInit = nil;
    local sEntryFaction = DB.getValue(nodeEntry, "friendfoe", "");
    for _,v in pairs(CombatManager.getCombatantNodes()) do
      if v.getName() ~= nodeEntry.getName() then
        if DB.getValue(v, "friendfoe", "") == sEntryFaction then
          local sTemp = CombatManager.stripCreatureNumber(DB.getValue(v, "name", ""));
          if sTemp == sStripName then
            local nChildInit = DB.getValue(v, "initresult", 0);
            if nChildInit ~= -10000 then
              nLastInit = nChildInit;
            end
          end
        end
      end
    end
    -- If we found similar creatures, then match the initiative of the last one found
    if nLastInit then
      DB.setValue(nodeEntry, "initresult", "number", nLastInit);
    else
      local nInitResult = rollRandomInit(nInit, bADV);
      DB.setValue(nodeEntry, "initresult", "number", nInitResult);
    end
  end
	
end

function onRoundStart(nCurrent)
  PC_LASTINIT = 0;
  if OptionsManager.isOption("HouseRule_InitEachRound", "on") then
    CombatManager2.rollInit();
  end
  -- toggle portrait initiative icon
  CharlistManagerADND.turnOffAllInitRolled();
end

function onTurnStart(nodeEntry)
	if not nodeEntry then
		return;
	end
	
	-- Handle beginning of turn changes
	DB.setValue(nodeEntry, "reaction", "number", 0);
end

-- create the "has initiative" indicator widget
function createHasInitiativeWidget(tokenCT,nodeCT)
  -- this is 1-4
  local sOptHasInitToken = OptionsManager.getOption("TOKEN_OPTION_INIT");
  local sInitiativeIconName = "token_has_initiative";
  if sOptHasInitToken then
    sInitiativeIconName = sInitiativeIconName .. sOptHasInitToken;
  else
    sInitiativeIconName = sInitiativeIconName .. "1";
  end

  local nWidth, nHeight = tokenCT.getSize();
  --local nScale = tokenCT.getScale();
  local sName = DB.getValue(nodeCT,"name","Unknown");
  local sNONID_Name = DB.getValue(nodeCT,"nonid_name","NONID-NA");
  local bNPC_ID = LibraryData.getIDState("npc", nodeCT, true);
  -- make sure we only show the ID'd name if the creature is "ID'd". -- celestian
  if not ActorManager.isPC(nodeCT) then
    if not bNPC_ID then
      sName = sNONID_Name;
    end
  end

  local widgetInitIndicator = tokenCT.addBitmapWidget(sInitiativeIconName);
  widgetInitIndicator.setBitmap(sInitiativeIconName);
  widgetInitIndicator.setName("initiativeindicator");
  --widgetInitIndicator.setTooltipText(sName .. " has initiative.");
  --widgetInitIndicator.setPosition("top", 0, 0);
  widgetInitIndicator.setPosition("center", 0, 0);

  if UtilityManagerADND.isFGU() then
    widgetInitIndicator.setSize(110, 110);
  else
    widgetInitIndicator.setSize(nWidth*3, nHeight*3);
    -- this also needs to be set in FGU when they add it... if they do
    widgetInitIndicator.setEnabled(false);
  end
  --widgetInitIndicator.setSize(nWidth*3, nHeight*3);
  return widgetInitIndicator;
end

-- get widget-
function getHasInitiativeWidget(nodeCT)
--Debug.console("manager_combat_adnd","getHasInitiativeWidget","nodeField",nodeField);     
  local widgetInitIndicator = nil;
  local tokenCT = CombatManager.getTokenFromCT(nodeCT);
  if (tokenCT) then
    widgetInitIndicator = tokenCT.findWidget("initiativeindicator");
  end
  return widgetInitIndicator;
end

-- show/hide widget
function setHasInitiativeIndicator(nodeCT,bShowINIT)
  local tokenCT = CombatManager.getTokenFromCT(nodeCT);
  if tokenCT then
    local widgetInitIndicator = getHasInitiativeWidget(nodeCT);
    if widgetInitIndicator and bShowINIT then -- show existing widget
      widgetInitIndicator.setVisible(bShowINIT);
    elseif not widgetInitIndicator and bShowINIT then -- create widget, show
      widgetInitIndicator = createHasInitiativeWidget(tokenCT,nodeCT);
      widgetInitIndicator.setVisible(bShowINIT);
    elseif widgetInitIndicator and not bShowINIT then -- destroy widget, not needed
      widgetInitIndicator.destroy();
    end
  else
  --Debug.console("manager_combat_adnd.lua","setHasInitiativeIndicator","nodeCT",nodeCT);  
  --Debug.console("manager_combat_adnd.lua","setHasInitiativeIndicator","tokenCT",tokenCT);  
  end
end

-- update the display "token" for has initiative indicator
function initiativeTokenChanged()
  -- delete any initiative widgets.
  for _,nodeCT in pairs(CombatManager.getCombatantNodes()) do
    local tokenCT = CombatManager.getTokenFromCT(nodeCT);
    if tokenCT then
      local widgetInitIndicator = getHasInitiativeWidget(nodeCT);
      if widgetInitIndicator then
        widgetInitIndicator.destroy();
      end
    end
  end
  -- set widget for active token
  updateAllInititiativeIndicators();
end

-- update has initiative first time start up
function updateAllInititiativeIndicators()
  for _,vChild in pairs(CombatManager.getCombatantNodes()) do
    local bActive = (DB.getValue(vChild,"active",0) == 1);
    setHasInitiativeIndicator(vChild,bActive);
  end
end
-- update has initiative first time start up
function updateInititiativeIndicator(nodeField)
  local nodeCT = nodeField.getParent();
  local bActive = (DB.getValue(nodeCT,"active",0) == 1);
  setHasInitiativeIndicator(nodeCT,bActive);
end

--
--
-- AD&D Style ordering (low to high initiative)
--
function sortfuncADnD(node2, node1)
  local bHost = User.isHost();
  local sOptCTSI = OptionsManager.getOption("CTSI");
  
  local sFaction1 = DB.getValue(node1, "friendfoe", "");
  local sFaction2 = DB.getValue(node2, "friendfoe", "");
  
  local bShowInit1 = bHost or ((sOptCTSI == "friend") and (sFaction1 == "friend")) or (sOptCTSI == "on");
  local bShowInit2 = bHost or ((sOptCTSI == "friend") and (sFaction2 == "friend")) or (sOptCTSI == "on");
  
  if bShowInit1 ~= bShowInit2 then
    if bShowInit1 then
      return true;
    elseif bShowInit2 then
      return false;
    end
  else
    if bShowInit1 then
      local nValue1 = DB.getValue(node1, "initresult", 0);
      local nValue2 = DB.getValue(node2, "initresult", 0);
      if nValue1 ~= nValue2 then
        return nValue1 > nValue2;
      end
      
      nValue1 = DB.getValue(node1, "init", 0);
      nValue2 = DB.getValue(node2, "init", 0);
      if nValue1 ~= nValue2 then
        return nValue1 > nValue2;
      end
    else
      if sFaction1 ~= sFaction2 then
        if sFaction1 == "friend" then
          return true;
        elseif sFaction2 == "friend" then
          return false;
        end
      end
    end
  end
  
  local sValue1 = DB.getValue(node1, "name", "");
  local sValue2 = DB.getValue(node2, "name", "");
  if sValue1 ~= sValue2 then
    return sValue1 < sValue2;
  end

  return node1.getNodeName() < node2.getNodeName();
end

---
-- General functions
---

-- return boolean, is PC from CT node test
function isCTNodePC(nodeCT)
  local isPC = false;
  local sClassLink, sRecordLink = DB.getValue(nodeCT,"link","","");
  if sClassLink == 'charsheet' then
    isPC = true;
  end
  return isPC;
end
-- return boolean, is NPC from CT node test
function isCTNodeNPC(nodeCT)
  local isPC = false;
  local sClassLink, sRecordLink = DB.getValue(nodeCT,"link","","");
  if sClassLink == 'npc' then
    isPC = true;
  end
  return isPC;
end
-- return the full "sheet" node from a combattracker node.
function getNodeFromCT(nodeCT)
  local nodeChar = nil;
  local sClass, sRecord = DB.getValue(nodeCT,"link","","");
  if sClass and sRecord then
    if (sClass == 'charsheet' or sClass == 'npc') and DB.findNode(sRecord) then
      nodeChar = DB.findNode(sRecord);
    end
  end
  return nodeChar;
end

---
-- NPC functions
---
-- calculate npc level from HD and return it -celestian
-- move to manager_action_save.lua?
function getNPCLevelFromHitDice(nodeNPC) 
    local nLevel = 1;
    local nHitDice = 0;
    local sHitDice = DB.getValue(nodeNPC, "hitDice", "1");
    if (sHitDice) then
        -- Match #-#, #+# or just #
        -- (\d+)([\-\+])?(\d+)?
        -- Full match  0-4  `12+3`
        -- Group 1.  0-2  `12`
        -- Group 2.  2-3  `+`
        -- Group 3.  3-4  `3`
        local nAdjustment = 0;
        local match1, match2, match3 = sHitDice:match("(%d+)([%-+])(%d+)");
        if (match1 and not match2) then -- single digit
            nHitDice = tonumber(match1);
        elseif (match1 and match2 and match3) then -- match x-x or x+x
            nHitDice = tonumber(match1);
            -- minus
            if (match2 == "-") then
                nAdjustment = tonumber(match2 .. match3);
            else -- plus
                nAdjustment = tonumber(match3);
            end
            if (nAdjustment ~= 0) then
                local nFourCount = (nAdjustment/4);
                if (nFourCount < 0) then
                    nFourCount = math.ceil(nFourCount);
                else
                    nFourCount = math.floor(nFourCount);
                end
                nLevel = (nHitDice+nFourCount);
            else -- adjust = 0
                nLevel = nHitDice;
            end -- nAdjustment
        else -- didn't find X-X or X+x-x
            match1 = sHitDice:match("(%d+)");
            if (match1) then -- single digit
                nHitDice = tonumber(match1);
                nLevel = nHitDice;
            else
                -- pop up menu and ask them for a decent value? -celestian
                ChatManager.SystemMessage("Unable to find a working hitDice [" .. sHitDice .. "] for " .. DB.getValue(nodeNPC, "name", "") .." to calculate saves. It should be # or #+# or #-#."); 
                nAdjustment = 0;
                nHitDice = 0;
            end
        end
    end -- hitDice
    
    return nLevel;
end

-- get NPC HitDice for use on Matrix chart.
-- Smaller than 1-1 (-1)
-- 1-1
-- 1
-- 1+
-- ...
-- 16+
function getNPCHitDice(nodeNPC)
--Debug.console("manager_combat_adnd","getNPCHitDice","nodeNPC",nodeNPC);  
  local sSantizedHitDice = "-1";
  local sHitDice = DB.getValue(nodeNPC, "hitDice", "1");
  local s1, s2, s3 = sHitDice:match("(%d+)([%-+])(%d+)");
  if s1 and s2 and s3 then
    -- deal with 1+,1-2,1-1
    if s1 == "1" then
      if s2 == "+" then
        sSantizedHitDice = "1+";
      elseif (s2 == "-") and ((tonumber(s3) or 0) < 1) then -- if 1-X and X > 1
        sSantizedHitDice = "-1";
      else
        sSantizedHitDice = "1-1";
      end
    else
      local nHD = tonumber(s1) or 16;
      if nHD > 16 then
        sSantizedHitDice = "16";
      else
        sSantizedHitDice = s1;
      end
    end
  elseif s1 then
    sSantizedHitDice = s1;
  else -- no string matched
    sSantizedHitDice = sHitDice:match("(%d+)");
  end
  
--Debug.console("manager_combat_adnd","getNPCHitDice","sSantizedHitDice",sSantizedHitDice);  
  return sSantizedHitDice;
end

-- return the Best ac hit from a roll for this NPC
function getACHitFromMatrixForNPC(nodeNPC,nRoll)
  local nACHit = 20;
  local sHitDice = getNPCHitDice(nodeNPC);
--Debug.console("manager_combat_adnd","getACHitFromMatrixForNPC","DataCommonADND.aMatrix",DataCommonADND.aMatrix);         
  if DataCommonADND.aMatrix[sHitDice] then
    local aMatrixRolls = DataCommonADND.aMatrix[sHitDice];
-- Debug.console("manager_combat_adnd","getACHitFromMatrixForNPC","DataCommonADND.aMatrix[sHitDice]",DataCommonADND.aMatrix[sHitDice]);         
-- Debug.console("manager_combat_adnd","getACHitFromMatrixForNPC","aMatrixRolls",aMatrixRolls);         
--    for i=21,1,-1 do
-- use #aMatrixRolls for counter instead. This should get the number from the array instead of hardcoded
-- did this so that could use same code for 1e and becmi since becmi uses 19 to -10 and 1e uses 10 to -10
--Debug.console("manager_combat_adnd","getACHitFromMatrixForNPC","#aMatrixRolls",#aMatrixRolls);
    for i=#aMatrixRolls,1,-1 do
      local sCurrentTHAC = "thac" .. i;
      local nAC = 11 - i;
      local nCurrentTHAC = aMatrixRolls[i];
--Debug.console("manager_combat_adnd","getACHitFromMatrixForNPC","nCurrentTHAC",nCurrentTHAC);        
      --if nCurrentTHAC == nRoll then
      if nRoll >= nCurrentTHAC then
        -- find first AC that matches our roll
        nACHit = nAC;
        break;
      end
    end
    
  end
--Debug.console("manager_combat_adnd","getACHitFromMatrixForNPC","nACHit",nACHit);    
  return nACHit;
end

-- return the Best ac hit from a roll for PC
function getACHitFromMatrixForPC(nodePC,nRoll)
  local nACHit = 20;
  local nodeCombat = nodePC.createChild("combat"); -- make sure these exist
  local nodeMATRIX = nodeCombat.createChild("matrix"); -- make sure these exist
  
  -- default value is 1e.
  local nLowAC = -10;
  local nHighAC = 10;
  local nTotalACs = 11;
  
  if (DataCommonADND.coreVersion == "becmi") then
    nLowAC = -20;
    nHighAC = 19;
    nTotalACs = 20;
  end
  
  -- starting from AC -10 and work up till we find match to our nRoll
  for i=nLowAC,nHighAC,1 do
    local sCurrentTHAC = "thac" .. i;
    local nAC = i;
    local nCurrentTHAC = DB.getValue(nodeMATRIX,sCurrentTHAC, 100);
--Debug.console("manager_combat_adnd","getACHitFromMatrixForPC","nCurrentTHAC",nCurrentTHAC);      
    if nRoll >= nCurrentTHAC then
      -- find first AC that matches our roll
      nACHit = i;
      break;
    end
  end
--Debug.console("manager_combat_adnd","getACHitFromMatrixForPC","nACHit",nACHit);        
  return nACHit;
end

-- return best AC Hit for this node (pc/npc) from Matrix with this nRoll
function getACHitFromMatrix(node,nRoll)
  local nACHit = 20;
  -- get the link from the combattracker record to see what this is.
	local bisPC = (node.getPath():match("^charsheet%."));
  if (bisPC) then
    nACHit = getACHitFromMatrixForPC(node,nRoll);
  else
    -- NPCs get this from matrix for HD value
    nACHit = getACHitFromMatrixForNPC(node,nRoll);
  end
  
--Debug.console("manager_combat_adnd","getACHitFromMatrix","nACHit",nACHit);        
  return nACHit;
end

-- Set NPC Saves -celestian
-- move to manager_action_save.lua?
function updateNPCSaves(nodeEntry, nodeNPC, bForceUpdate)
--    Debug.console("manager_combat2.lua","updateNPCSaves","nodeNPC",nodeNPC);
    if  (bForceUpdate) or (DB.getChildCount(nodeNPC, "saves") <= 0) then
        for i=1,10,1 do
            local sSave = DataCommon.saves[i];
            local nSave = DB.getValue(nodeNPC, "saves." .. sSave .. ".score", -1);
            if (nSave <= 0 or bForceUpdate) then
                ActionSave.setNPCSave(nodeEntry, sSave, nodeNPC)
            end
        end
    end
end
-- set Level, Arcane/Divine levels based on HD "level"
function updateNPCLevels(nodeNPC, bForceUpdate) 
    if  (bForceUpdate) then
      local nLevel = getNPCLevelFromHitDice(nodeNPC);
      DB.setValue(nodeNPC, "arcane.totalLevel","number",nLevel);
      DB.setValue(nodeNPC, "divine.totalLevel","number",nLevel);
      DB.setValue(nodeNPC, "psionic.totalLevel","number",nLevel);
      DB.setValue(nodeNPC, "level","number",nLevel);
    end
end

-- remove everything in (*) because thats DM only "Orc (3HD)" and return "Orc"
function stripHiddenNameText(sStr)
  if sStr then
    return StringManager.trim(sStr:gsub("%(.*%)", "")); 
  end
  return nil;
end
-- get the hidden portion in "name" within ()'s and return it, "Orc (3HD)" and return "(3HD)"
function getHiddenNameText(sStr)
  if sStr then
    return string.match(sStr, "%(.*%)");
  end
  return nil;
end

function addNPC(sClass, nodeNPC, sName)
UtilityManagerADND.logDebug("manager_combat_adnd.lua","addNPC\START/");
--Debug.console("manager_combat2.lua","addNPC","sClass",sClass);
  local sNPCFullName = DB.getValue(nodeNPC,"name","");
  local sNPCName = stripHiddenNameText(sNPCFullName);
  local sNPCNameHidden = getHiddenNameText(sNPCFullName);
  
  if sName == nil then 
    sName = sNPCName; -- set name to non-hidden part
  else
    sNPCNameHidden = getHiddenNameText(sName);
    sName = stripHiddenNameText(sName);
  end
  
  -- various bits from CoreRPG that are run, this is where DB.copyNode() is run...
  local nodeEntry, nodeLastMatch = CombatManager.addNPCHelper(nodeNPC, sName);
  
  -- save DM only "hiddten text" if necessary to display in host CT
  if sNPCNameHidden ~= nil and sNPCNameHidden ~= "" then
    DB.setValue(nodeEntry,"name_hidden","string",sNPCNameHidden);
  end

  -- update NPC Saves for HD
  updateNPCSaves(nodeEntry, nodeNPC);

  -- Fill in spells
  -- not necessary for AD&D --celestian
  --CampaignDataManager2.updateNPCSpells(nodeEntry);

  -- Set initiative from Dexterity modifier
--  local nDex = DB.getValue(nodeNPC, "abilities.dexterity.score", 10);
--  local nDexMod = math.floor((nDex - 10) / 2);
--  DB.setValue(nodeEntry, "init", "number", nDexMod);

  -- base modifier for initiative
  -- we set modifiers based on size per DMG for AD&D -celestian
  DB.setValue(nodeEntry, "init", "number", 0);
  
  -- Determine size
  local sSize = StringManager.trim(DB.getValue(nodeEntry, "size", ""):lower());
  local sSizeNoLower = StringManager.trim(DB.getValue(nodeEntry, "size", ""));
  if sSize == "tiny" or string.find(sSizeNoLower,"T") then
    -- tokenscale doesn't work, guessing it's "reset" when
    -- the token is actually dropped on the map
    -- need to figure out a work around -celestian
    DB.setValue(nodeEntry, "tokenscale", "number", 0.5);
    DB.setValue(nodeEntry, "init", "number", -5);
  elseif sSize == "small" or string.find(sSizeNoLower,"S") then
    -- tokenscale doesn't work, guessing it's "reset" when
    -- the token is actually dropped on the map
    DB.setValue(nodeEntry, "tokenscale", "number", 0.75);
    DB.setValue(nodeEntry, "init", "number", -2);
  elseif sSize == "medium" or string.find(sSizeNoLower,"M") then
    DB.setValue(nodeEntry, "init", "number", 0);
  elseif sSize == "large" or string.find(sSizeNoLower,"L") then
    DB.setValue(nodeEntry, "space", "number", 10);
    DB.setValue(nodeEntry, "init", "number", 1);
  elseif sSize == "huge" or string.find(sSizeNoLower,"H") then
    DB.setValue(nodeEntry, "space", "number", 15);
    DB.setValue(nodeEntry, "init", "number", 4);
  elseif sSize == "gargantuan" or string.find(sSizeNoLower,"G") then
    DB.setValue(nodeEntry, "space", "number", 20);
    DB.setValue(nodeEntry, "init", "number", 7);
  end
  -- if the combat window initiative is set to something, use it instead --celestian
  local nInitMod = DB.getValue(nodeNPC, "initiative.total", 0);
  if nInitMod ~= 0 then
    DB.setValue(nodeEntry, "init", "number", nInitMod);
  end

  local nHP = rollNPCHitPoints(nodeNPC);
  DB.setValue(nodeEntry, "hptotal", "number", nHP);
  -- we store "base" here also using current total.
  DB.setValue(nodeEntry, "hpbase", "number", nHP);
  -- these are 5e style methods
  -- Track additional damage types and intrinsic effects
  -- local aEffects = {};
  
  -- -- Vulnerabilities
  -- local aVulnTypes = CombatManager2.parseResistances(DB.getValue(nodeEntry, "damagevulnerabilities", ""));
  -- if #aVulnTypes > 0 then
    -- for _,v in ipairs(aVulnTypes) do
      -- if v ~= "" then
        -- table.insert(aEffects, "VULN: " .. v);
      -- end
    -- end
  -- end
      
  -- -- Damage Resistances
  -- local aResistTypes = CombatManager2.parseResistances(DB.getValue(nodeEntry, "damageresistances", ""));
  -- if #aResistTypes > 0 then
    -- for _,v in ipairs(aResistTypes) do
      -- if v ~= "" then
        -- table.insert(aEffects, "RESIST: " .. v);
      -- end
    -- end
  -- end
  
  -- -- Damage immunities
  -- local aImmuneTypes = CombatManager2.parseResistances(DB.getValue(nodeEntry, "damageimmunities", ""));
  -- if #aImmuneTypes > 0 then
    -- for _,v in ipairs(aImmuneTypes) do
      -- if v ~= "" then
        -- table.insert(aEffects, "IMMUNE: " .. v);
      -- end
    -- end
  -- end

  -- -- Condition immunities
  -- local aImmuneCondTypes = {};
  -- local sCondImmune = DB.getValue(nodeEntry, "conditionimmunities", ""):lower();
  -- for _,v in ipairs(StringManager.split(sCondImmune, ",;\r", true)) do
    -- if StringManager.isWord(v, DataCommon.conditions) then
      -- table.insert(aImmuneCondTypes, v);
    -- end
  -- end
  -- if #aImmuneCondTypes > 0 then
    -- table.insert(aEffects, "IMMUNE: " .. table.concat(aImmuneCondTypes, ", "));
  -- end
  
  -- -- Decode traits and actions
    -- -- if it has no actions... 
    -- if DB.getChildCount(nodeEntry, "actions") == 0 then
        -- -- add a single default entry that has at least a melee attack, ranged attack, simple damage and saves for each type. -celestian
        -- --Debug.console("manager_combat2.lua","addNPC","!Actions",DB.getChildren(nodeEntry, "actions"));
        -- local nodeDefaultActions = nodeEntry.createChild("actions");
      -- if nodeDefaultActions then
        -- local nodeDefaultAction = nodeDefaultActions.createChild();
        -- if nodeDefaultAction then
          -- DB.setValue(nodeDefaultAction, "name", "string", "Default:");
          -- DB.setValue(nodeDefaultAction, "desc", "string", "Melee Weapon Attack: +0 to hit. Ranged Weapon Attack: +0 to hit. Hit: 1d6 slashing damage.\rVictims must make a saving throw versus spell. Victims must make a saving throw versus poison. Victims must make a saving throw versus rod.\rVictims must make a saving throw versus polymorph. Victims must make a saving throw versus breath.");
        -- end
      -- end
    -- end

  -- -- -- Add special effects
  -- if #aEffects > 0 then
    -- EffectManager.addEffect("", "", nodeEntry, { sName = table.concat(aEffects, "; "), nDuration = 0, nGMOnly = 1 }, false);
  -- end

    -- check to see if npc effects exists and if so apply --celestian
    EffectManagerADND.updateCharEffects(nodeNPC,nodeEntry);
    
    -- now flip through inventory and pass each to updateEffects()
    -- so that if they have a combat_effect it will be applied.
    for _,nodeItem in pairs(DB.getChildren(nodeEntry, "inventorylist")) do
      EffectManagerADND.updateItemEffects(nodeItem,nodeEntry);
    end
    -- if in CT we use the "linked back to source npc" list of inventory items
    if nodeEntry.getPath():match("^combattracker%.") then
      for _,nodeItem in pairs(DB.getChildren(nodeNPC, "inventorylist")) do
        EffectManagerADND.updateItemEffects(nodeItem,nodeEntry);
      end
      -- local aItemNodes = UtilityManagerADND.getItemNodeListFromNPCinCT(nodeEntry);
      -- for _,sItemNode in pairs(aItemNodes) do 
        -- local nodeItem = DB.findNode(sItemNode);
        -- if nodeItem then
          -- EffectManagerADND.updateItemEffects(nodeItem,nodeEntry);
        -- end
      -- end
    end
    -- end
    
  -- Roll initiative and sort
  local sOptINIT = OptionsManager.getOption("INIT");
    if (nInitMod == 0) then
      nInitMod = DB.getValue(nodeEntry, "init", 0);
    end
    local nInitiativeRoll = math.random(DataCommonADND.nDefaultInitiativeDice) + nInitMod;
  if sOptINIT == "group" then
    if nodeLastMatch then
      local nLastInit = DB.getValue(nodeLastMatch, "initresult", 0);
      DB.setValue(nodeEntry, "initresult", "number", nLastInit);
    else
      DB.setValue(nodeEntry, "initresult", "number", nInitiativeRoll);
    end
  elseif sOptINIT == "on" then
    DB.setValue(nodeEntry, "initresult", "number", nInitiativeRoll);
  end

  -- set mode/display default to standard/actions
  DB.setValue(nodeEntry,"powermode","string", "standard");
  DB.setValue(nodeEntry,"powerdisplaymode","string","action");
  
  -- sanitize special defense/attack string
  setSpecialDefenseAttack(nodeEntry);

UtilityManagerADND.logDebug("manager_combat_adnd.lua","addNPC\END/");

  return nodeEntry;
end

function addNPCHelper_ADND(nodeNPC, sName)

UtilityManagerADND.logDebug("manager_combat_adnd.lua","addNPCHelper_ADND\START/");

	-- Parameter validation
	if not nodeNPC then
		return nil;
	end

	-- Setup
	local aCurrentCombatants = CombatManager.getCombatantNodes();
	
	-- Get the name to use for this addition
	local bIsCTNPC = (UtilityManager.getRootNodeName(nodeNPC) == CT_MAIN_PATH);
	local sNameLocal = sName;
	if not sNameLocal then
		sNameLocal = DB.getValue(nodeNPC, "name", "");
		if bIsCTNPC then
			sNameLocal = CombatManager.stripCreatureNumber(sNameLocal);
		end
	end
	local sNonIDLocal = DB.getValue(nodeNPC, "nonid_name", "");
	if sNonIDLocal == "" then
		sNonIDLocal = Interface.getString("library_recordtype_empty_nonid_npc");
	elseif bIsCTNPC then
		sNonIDLocal = CombatManager.stripCreatureNumber(sNonIDLocal);
	end
	
	local nLocalID = DB.getValue(nodeNPC, "isidentified", 1);
	if not bIsCTNPC then
		local sSourcePath = nodeNPC.getPath()
		local aMatches = {};
		for _,v in pairs(aCurrentCombatants) do
			local _,sRecord = DB.getValue(v, "sourcelink", "", "");
			if sRecord == sSourcePath then
				table.insert(aMatches, v);
			end
		end
		if #aMatches > 0 then
			nLocalID = 0;
			for _,v in ipairs(aMatches) do
				if DB.getValue(v, "isidentified", 1) == 1 then
					nLocalID = 1;
				end
			end
		end
	end
	
	local nodeLastMatch = nil;
	if sNameLocal:len() > 0 then
		-- Determine the number of NPCs with the same name
		local nNameHigh = 0;
		local aMatchesWithNumber = {};
		local aMatchesToNumber = {};
		for _,v in pairs(aCurrentCombatants) do
			local sEntryName = DB.getValue(v, "name", "");
			local sTemp, sNumber = CombatManager.stripCreatureNumber(sEntryName);
			if sTemp == sNameLocal then
				nodeLastMatch = v;
				
				local nNumber = tonumber(sNumber) or 0;
				if nNumber > 0 then
					nNameHigh = math.max(nNameHigh, nNumber);
					table.insert(aMatchesWithNumber, v);
				else
					table.insert(aMatchesToNumber, v);
				end
			end
		end
	
		-- If multiple NPCs of same name, then figure out whether we need to adjust the name based on options
		local sOptNNPC = OptionsManager.getOption("NNPC");
		if sOptNNPC ~= "off" then
			local nNameCount = #aMatchesWithNumber + #aMatchesToNumber;
			
			for _,v in ipairs(aMatchesToNumber) do
				local sEntryName = DB.getValue(v, "name", "");
				local sEntryNonIDName = DB.getValue(v, "nonid_name", "");
				if sEntryNonIDName == "" then
					sEntryNonIDName = Interface.getString("library_recordtype_empty_nonid_npc");
				end
				if sOptNNPC == "append" then
					nNameHigh = nNameHigh + 1;
					DB.setValue(v, "name", "string", sEntryName .. " " .. nNameHigh);
					DB.setValue(v, "nonid_name", "string", sEntryNonIDName .. " " .. nNameHigh);
				elseif sOptNNPC == "random" then
					local sNewName, nSuffix = CombatManager.randomName(sEntryName);
					DB.setValue(v, "name", "string", sNewName);
					DB.setValue(v, "nonid_name", "string", sEntryNonIDName .. " " .. nSuffix);
				end
			end
			
			if nNameCount > 0 then
				if sOptNNPC == "append" then
					nNameHigh = nNameHigh + 1;
					sNameLocal = sNameLocal .. " " .. nNameHigh;
					sNonIDLocal = sNonIDLocal .. " " .. nNameHigh;
				elseif sOptNNPC == "random" then
					local sNewName, nSuffix = CombatManager.randomName(sNameLocal);
					sNameLocal = sNewName;
					sNonIDLocal = sNonIDLocal .. " " .. nSuffix;
				end
			end
		end
	end
	
	DB.createNode(CombatManager.CT_LIST);
	local nodeEntry = DB.createChild(CombatManager.CT_LIST);
	if not nodeEntry then
		return nil;
	end
  -- instead of copy lets make sure we only pass in nodes we NEED
  -- celestian
  UtilityManagerADND.logDebug("manager_combat_adnd.lua","addNPCHelper_ADND-COPY->","Start nodeNPC to nodeEntry Copy");
	DB.copyNode(nodeNPC, nodeEntry);
  UtilityManagerADND.logDebug("manager_combat_adnd.lua","addNPCHelper_ADND=COPY==","END nodeNPC to nodeEntry Copy");
  --dbCleanCopyNPCtoCTNode(nodeNPC, nodeEntry);
  --

	-- Remove any combatant specific information
	DB.setValue(nodeEntry, "active", "number", 0);
	DB.setValue(nodeEntry, "tokenrefid", "string", "");
	DB.setValue(nodeEntry, "tokenrefnode", "string", "");
	DB.deleteChildren(nodeEntry, "effects");
	
	-- Set the final name value
	DB.setValue(nodeEntry, "name", "string", sNameLocal);
	DB.setValue(nodeEntry, "nonid_name", "string", sNonIDLocal);
	DB.setValue(nodeEntry, "isidentified", "number", nLocalID);
	
	-- Lock NPC record view by default when copying to CT
	DB.setValue(nodeEntry, "locked", "number", 1);

	-- Set up the CT specific information
	DB.setValue(nodeEntry, "link", "windowreference", "", ""); -- Workaround to force field update on client; client does not pass network update to other clients if setValue creates value node with default value
	DB.setValue(nodeEntry, "link", "windowreference", "npc", "");
	DB.setValue(nodeEntry, "friendfoe", "string", "foe");
	if not bIsCTNPC then
		DB.setValue(nodeEntry, "sourcelink", "windowreference", "npc", nodeNPC.getPath());
	end
	
	-- Calculate space/reach
	local nSpace, nReach = CombatManager.getNPCSpaceReach(nodeNPC);
	DB.setValue(nodeEntry, "space", "number", nSpace);
	DB.setValue(nodeEntry, "reach", "number", nReach);

	-- Set default letter token, if no token defined
	local sToken = DB.getValue(nodeNPC, "token", "");
	if sToken == "" or not Interface.isToken(sToken) then
		local sLetter = StringManager.trim(sNameLocal):match("^([a-zA-Z])");
		if sLetter then
			sToken = "tokens/Medium/" .. sLetter:lower() .. ".png@Letter Tokens";
		else
			sToken = "tokens/Medium/z.png@Letter Tokens";
		end
		DB.setValue(nodeEntry, "token", "token", sToken);
	end
	
UtilityManagerADND.logDebug("manager_combat_adnd.lua","addNPCHelper_ADND\END/");

	return nodeEntry, nodeLastMatch;
end


-- generate hitpoint value for NPC and return it
function rollNPCHitPoints(nodeNPC)
  -- Set current hit points
  local sOptHRNH = OptionsManager.getOption("HRNH");
  local nHP = DB.getValue(nodeNPC, "hp", 0);
  if (nHP == 0) then -- if HP value not set, we roll'm
    local sHD = StringManager.trim(DB.getValue(nodeNPC, "hd", ""));
    if sOptHRNH == "max" and sHD ~= "" then
      -- max hp
      nHP = StringManager.evalDiceString(sHD, true, true);
    elseif sOptHRNH == "random" and sHD ~= "" then
      nHP = math.max(StringManager.evalDiceString(sHD, true), 1);
      elseif sOptHRNH == "80plus" and sHD ~= "" then        
          -- roll hp, if it's less than 80% of what max then set to 80% of max
          -- i.e. if hp max is 100, 80% of that is 80. If the random is less than
          -- that the value will be set to 80.
          local nMaxHP = StringManager.evalDiceString(sHD, true, true);
          local n80 = math.floor(nMaxHP * 0.8);
          nHP = math.max(StringManager.evalDiceString(sHD, true), 1);
          if (nHP < n80) then
              nHP = n80;
          end
    end
	nHP = nHP + 20; -- HM4 mod: add kicker
  end
  return nHP;
end


-- this copies specific nodes under source to destination
-- copySourceToNodeCTHelper(nodeSource,nodeDest,"powers")
function copySourceToNodeCTHelper(nodeSource,nodeDest,sNode)
--Debug.console("manager_combat_adnd.lua","copySourceToNodeCTHelper","sNode",sNode);  
--Debug.console("manager_combat_adnd.lua","copySourceToNodeCTHelper","nodeSource",nodeSource);  
  --if DB.getChild(nodeSource, sNode) ~= nil and (DB.getChildCount(nodeSource, sNode) > 0 )then
  if DB.getChild(nodeSource, sNode) ~= nil then
    local nChildCount = DB.getChildCount(nodeSource,sNode);
    -- we do this so if we copy to a node that already has children
    -- it will create new ids for the incoming copies so it doesn't replace existing.
    if nChildCount > 0 and isIDListedChildren(nodeSource,sNode) then
      local nodeDestAdded = nodeDest.createChild(sNode);
      for _,nodeSourceFound in pairs(DB.getChildren(nodeSource,sNode)) do
        local nodeCopy = nodeDestAdded.createChild();
        DB.copyNode(nodeSourceFound,nodeCopy);
      end
    else
  --Debug.console("manager_combat_adnd.lua","copySourceToNodeCTHelper","DB.getChildCount(nodeSource, sNode)",DB.getChildCount(nodeSource, sNode));  
      DB.copyNode(DB.getPath(nodeSource, sNode),DB.getPath(nodeDest, sNode));
    end
  end
end

-- see if children are id listed nodes, id-00000 type.
function isIDListedChildren(node,sTag)
  local bID = false;
  for _,nodeChecked in pairs(DB.getChildren(node,sTag)) do
    local sPath, sModule = nodeChecked.getPath():match("([^@]*)@(.*)");
    if not sPath then sPath = nodeChecked.getPath(); end;
    if sPath:match("%.id%-%d+$") then
      bID = true;
      break;
    end
  end
  return bID;
end

-- this takes data from nodeNPC and places the important data needed into nodeCT.
function copySourceToNodeCT(nodeSource, nodeCT)
  -- nested variables (multi-node levels)
  local alistNodes = {
    "abilities",
    "abilitynoteslist",
    "combat",
    "coins",
    "arcane",
    "divine",
    "effectlist",
    "encumbrance",
    --"initiative", -- we dont need this, the npcAdd populates the fields from the source NPC
    "inventorylist",
    "languagelist",
    "powermeta",
    "powergroup",
    "powers",
    "proficiencies",
    "proficiencylist",
    "psionic",
    --"saves",      -- we get this in the initial drag/drop
    "surprise",
    "skilllist",
    "text",
    "turn",
    "weaponlist",
    --"ac",          -- single nodes
    "actext",
    --"alignment",  -- we get this in the initial drag/drop
    "climate",
    "damage",
    "diet",
    "frequency",
    --"hd",
    --"hdtext",
    "hitDice",
    --"hp",
    "intelligence_text",
    "level",
    "magicresistance",
    "morale",
    --"name",  copyCTANPC does this
    --"nonid_name",
    "numberappearing",
    "numberattacks",
    "organization",
    --"powerdisplaymode", -- set in pre-ct add
    "size",
--    "source",
    --"specialAttacks", -- set in pre-ct add
    --"specialDefense", -- set in pre-ct add
    "speed",
    "thaco",
    --"token", -- set in pre-ct add
    "treasure",
    --"type",  -- set in pre-ct add
    "xp",
  }; -- everything else we skip
  
  for _,sNodeName in pairs(alistNodes) do 
    copySourceToNodeCTHelper(nodeSource,nodeCT,sNodeName);
  end

--Debug.console("manager_combat_adnd.lua","copySourceToNodeCT","nodeCT",nodeCT);  

  -- clear out effects that came from the SOURCE when dropped
  -- we added them incase they were useful before loading into selected
 for _,nodeEffect in pairs(DB.getChildren(nodeCT, "effects")) do
  local sEffectSource = DB.getValue(nodeEffect,"source_name","");
  if sEffectSource:match('inventorylist%.') then
    nodeEffect.delete();
  end
 end
 
 -- add effects to the target from anything in inventory
 for _,nodeItem in pairs(DB.getChildren(nodeCT, "inventorylist")) do
  EffectManagerADND.updateItemEffects(nodeItem,nodeCT);
 end

 -- flag it as source loaded now that we did
 DB.setValue(nodeCT,"sourceloaded","number",1);
 
 -- lock it.
  DB.setValue(nodeCT,"locked","number",1); 
end

-- clean up and create special attack and defense strings.
function setSpecialDefenseAttack(node)
    local sSD = DB.getValue(node,"specialDefense",""):lower();
    local sSA = DB.getValue(node,"specialAttacks",""):lower();

    local sDefense = "";
    local sAttacks = "";
    if (not string.match(sSD,"nil") and not string.match(sSD,"see desc") and sSD ~= "") then
        sDefense = DB.getValue(node,"specialDefense","");
    end
    if (not string.match(sSA,"nil") and not string.match(sSA,"see desc") and sSA ~= "") then
        sAttacks = DB.getValue(node,"specialAttacks","");
    end
    
    DB.setValue(node,"specialDefense","string",sDefense);
    DB.setValue(node,"specialAttacks","string",sAttacks);
end


---
-- PC functions
---
-- custom version of the one in CoreRPG to deal with adding new 
-- pcs to the combat tracker to deal with item effects. --celestian
function addPC(nodePC)
  -- Parameter validation
  if not nodePC then
    return;
  end

  -- Create a new combat tracker window
  local nodeEntry = DB.createChild("combattracker.list");
  if not nodeEntry then
    return;
  end
  
  -- Set up the CT specific information
  DB.setValue(nodeEntry, "link", "windowreference", "charsheet", nodePC.getNodeName());
  DB.setValue(nodeEntry, "friendfoe", "string", "friend");

  local sToken = DB.getValue(nodePC, "token", nil);
  if not sToken or sToken == "" then
    sToken = "portrait_" .. nodePC.getName() .. "_token"
  end
  DB.setValue(nodeEntry, "token", "token", sToken);
  
  -- now flip through inventory and pass each to updateEffects()
  -- so that if they have a combat_effect it will be applied.
  for _,nodeItem in pairs(DB.getChildren(nodePC, "inventorylist")) do
      EffectManagerADND.updateItemEffects(nodeItem,nodePC);
  end
  -- end

  -- check to see if npc effects exists and if so apply --celestian
  EffectManagerADND.updateCharEffects(nodePC,nodeEntry);

  -- make sure active users get ownership of their CT nodes
  -- otherwise effects applied by items/etc won't work.
  -- AccessManagerADND.manageCTOwners(nodeEntry);
end

--
-- CoreRPG Replaced functions for customizations
--
--
function nextActor(bSkipBell, bNoRoundAdvance)
	if not User.isHost() then
		return;
	end

	local nodeActive = CombatManager.getActiveCT();
	local nIndexActive = 0;
	
	-- Check the skip hidden NPC option
	local bSkipHidden = OptionsManager.isOption("CTSH", "on");
  local bSkipDeadNPC = OptionsManager.isOption("CT_SKIP_DEAD_NPC", "on");
	
	-- Determine the next actor
	local nodeNext = nil;
	local aEntries = CombatManager.getSortedCombatantList();
	if #aEntries > 0 then
		if nodeActive then
			for i = 1,#aEntries do
				if aEntries[i] == nodeActive then
					nIndexActive = i;
					break;
				end
			end
		end
		if bSkipHidden or bSkipDeadNPC then
			local nIndexNext = 0;
			for i = nIndexActive + 1, #aEntries do
				if DB.getValue(aEntries[i], "friendfoe", "") == "friend" then
					nIndexNext = i;
					break;
				else
          local nPercentWounded = ActorManager2.getPercentWounded(aEntries[i]);
          local bisNPC = (not ActorManager.isPC(aEntries[i]));
          -- is the actor dead?
          local bSkipDead = (bSkipDeadNPC and bisNPC and nPercentWounded >= 1);
          -- is the actor hidden?
          local bSkipHiddenActor = (bSkipHidden and CombatManager.isCTHidden(aEntries[i]));
          
          if (not bSkipDead and not bSkipHiddenActor) then
						nIndexNext = i;
						break;
          end
        end
			end
			if nIndexNext > nIndexActive then
				nodeNext = aEntries[nIndexNext];
				for i = nIndexActive + 1, nIndexNext - 1 do
					CombatManager.showTurnMessage(aEntries[i], false);
				end
			end
		else
			nodeNext = aEntries[nIndexActive + 1];
		end
	end

	-- If next actor available, advance effects, activate and start turn
	if nodeNext then
		-- End turn for current actor
		CombatManager.onTurnEndEvent(nodeActive);
	
		-- Process effects in between current and next actors
		if nodeActive then
			CombatManager.onInitChangeEvent(nodeActive, nodeNext);
		else
			CombatManager.onInitChangeEvent(nil, nodeNext);
		end
		
		-- Start turn for next actor
		CombatManager.requestActivation(nodeNext, bSkipBell);
		CombatManager.onTurnStartEvent(nodeNext);
	elseif not bNoRoundAdvance then
		if bSkipHidden or bSkipDeadNPC then
			for i = nIndexActive + 1, #aEntries do
				CombatManager.showTurnMessage(aEntries[i], false);
			end
		end
		CombatManager.nextRound(1);
	end
end

-- replace default roll with adnd_roll to allow
-- control-dice click to prompt for manual roll
function adnd_roll(rSource, vTargets, rRoll, bMultiTarget)
  if #(rRoll.aDice) > 0 then
    if not rRoll.bTower and (OptionsManager.isOption("MANUALROLL", "on") or (User.isHost() and Input.isControlPressed())) then
      local wManualRoll = Interface.openWindow("manualrolls", "");
      wManualRoll.addRoll(rRoll, rSource, vTargets);
    else
      local rThrow = ActionsManager.buildThrow(rSource, vTargets, rRoll, bMultiTarget);
      Comm.throwDice(rThrow);
    end
  else
    if bMultiTarget then
      ActionsManager.handleResolution(rRoll, rSource, vTargets);
    else
      ActionsManager.handleResolution(rRoll, rSource, { vTargets });
    end
  end
end 

--
-- Replaced CoreRPG version of "addBattle()" so we can tweak hp/ac/weapon list
-- --celestian
--
function addBattle(nodeBattle)
	local aModulesToLoad = {};
	local sTargetNPCList = LibraryData.getCustomData("battle", "npclist") or "npclist";
	for _, vNPCItem in pairs(DB.getChildren(nodeBattle, sTargetNPCList)) do
		local sClass, sRecord = DB.getValue(vNPCItem, "link", "", "");
		if sRecord ~= "" then
			local nodeNPC = DB.findNode(sRecord);
			if not nodeNPC then
				local sModule = sRecord:match("@(.*)$");
				if sModule and sModule ~= "" and sModule ~= "*" then
					if not StringManager.contains(aModulesToLoad, sModule) then
						table.insert(aModulesToLoad, sModule);
					end
				end
			end
		end
		for _,vPlacement in pairs(DB.getChildren(vNPCItem, "maplink")) do
			local sClass, sRecord = DB.getValue(vPlacement, "imageref", "", "");
			if sRecord ~= "" then
				local nodeImage = DB.findNode(sRecord);
				if not nodeImage then
					local sModule = sRecord:match("@(.*)$");
					if sModule and sModule ~= "" and sModule ~= "*" then
						if not StringManager.contains(aModulesToLoad, sModule) then
							table.insert(aModulesToLoad, sModule);
						end
					end
				end
			end
		end
	end
	if #aModulesToLoad > 0 then
		local wSelect = Interface.openWindow("module_dialog_missinglink", "");
		wSelect.initialize(aModulesToLoad, onBattleNPCLoadCallback, { nodeBattle = nodeBattle });
		return;
	end
	
	if CombatManager.fCustomAddBattle then
		return CombatManager.fCustomAddBattle(nodeBattle);
	end
	
	-- Cycle through the NPC list, and add them to the tracker
	for _, vNPCItem in pairs(DB.getChildren(nodeBattle, sTargetNPCList)) do
		-- Get link database node
		local nodeNPC = nil;
		local sClass, sRecord = DB.getValue(vNPCItem, "link", "", "");
		if sRecord ~= "" then
			nodeNPC = DB.findNode(sRecord);
		end
		local sName = DB.getValue(vNPCItem, "name", "");

--Debug.console("manager_combat_adnd.lua","addBattle","sName",sName);  		

		if nodeNPC then
			local aPlacement = {};
			for _,vPlacement in pairs(DB.getChildren(vNPCItem, "maplink")) do
				local rPlacement = {};
				local _, sRecord = DB.getValue(vPlacement, "imageref", "", "");
				rPlacement.imagelink = sRecord;
				rPlacement.imagex = DB.getValue(vPlacement, "imagex", 0);
				rPlacement.imagey = DB.getValue(vPlacement, "imagey", 0);
				table.insert(aPlacement, rPlacement);
			end
			
			local nCount = DB.getValue(vNPCItem, "count", 0);
			for i = 1, nCount do
				--local nodeEntry = CombatManager.addNPC(sClass, nodeNPC, sName);
        local nodeEntry = addCTANPC(sClass, nodeNPC, sName);
				if nodeEntry then
					local sFaction = DB.getValue(vNPCItem, "faction", "");
					if sFaction ~= "" then
						DB.setValue(nodeEntry, "friendfoe", "string", sFaction);
					end
					local sToken = DB.getValue(vNPCItem, "token", "");
					if sToken == "" or not Interface.isToken(sToken) then
						local sLetter = StringManager.trim(sName):match("^([a-zA-Z])");
						if sLetter then
							sToken = "tokens/Medium/" .. sLetter:lower() .. ".png@Letter Tokens";
						else
							sToken = "tokens/Medium/z.png@Letter Tokens";
						end
					end
					if sToken ~= "" then
						DB.setValue(nodeEntry, "token", "token", sToken);
						
						if aPlacement[i] and aPlacement[i].imagelink ~= "" then
							TokenManager.setDragTokenUnits(DB.getValue(nodeEntry, "space"));
							local tokenAdded = Token.addToken(aPlacement[i].imagelink, sToken, aPlacement[i].imagex, aPlacement[i].imagey);
							TokenManager.endDragTokenWithUnits(nodeEntry);
							if tokenAdded then
								TokenManager.linkToken(nodeEntry, tokenAdded);
							end
						end
					end
					
					-- Set identification state from encounter record, and disable source link to prevent overriding ID for existing CT entries when identification state changes
					local sSourceClass,sSourceRecord = DB.getValue(nodeEntry, "sourcelink", "", "");
					DB.setValue(nodeEntry, "sourcelink", "windowreference", "", "");
					DB.setValue(nodeEntry, "isidentified", "number", DB.getValue(vNPCItem, "isidentified", 1));
					DB.setValue(nodeEntry, "sourcelink", "windowreference", sSourceClass, sSourceRecord);
				else
					ChatManager.SystemMessage(Interface.getString("ct_error_addnpcfail") .. " (" .. sName .. ")");
				end
        
        -- add custom features for 2E ruleset hp/ac/weapon
        local nHP = DB.getValue(vNPCItem,"hp",0);
        local nAC = DB.getValue(vNPCItem,"ac",11);
        local sWeaponList = DB.getValue(vNPCItem,"weapons","");
        if (nHP ~= 0) then
          DB.setValue(nodeEntry, "hp", "number", nHP);
          DB.setValue(nodeEntry, "hpbase", "number", nHP);
          DB.setValue(nodeEntry, "hptotal", "number", nHP);
        end
        if (nAC <= 10) then
          DB.setValue(nodeEntry, "ac", "number", nAC);
        end
        if (sWeaponList ~= "") then
          for _,sWeapon in ipairs(StringManager.split(sWeaponList, ";", true)) do
            if not UtilityManagerADND.hasWeaponNamed(nodeEntry,sWeapon) then 
              local nodeSourceWeapon = UtilityManagerADND.getWeaponNodeByName(sWeapon);
              if nodeSourceWeapon then
                local nodeWeapons = nodeEntry.createChild("weaponlist");
                for _,v in pairs(DB.getChildren(nodeSourceWeapon, "weaponlist")) do
                  local nodeWeapon = nodeWeapons.createChild();
                  DB.copyNode(v,nodeWeapon);
                  local sName = DB.getValue(v,"name","");
                  local sText = DB.getValue(v,"text","");
                  DB.setValue(nodeWeapon,"itemnote.name","string",sName);
                  DB.setValue(nodeWeapon,"itemnote.text","formattedtext",sText);
                  DB.setValue(nodeWeapon,"itemnote.locked","number",1);
                end
              else
                ChatManager.SystemMessage("Encounter [" .. DB.getValue(nodeBattle,"name","") .. "], unable to find weapon [" .. sWeapon .. "] for NPC [" .. DB.getValue(nodeEntry,"name","") .."].");
              end
            end
          end -- for weapons
        end -- end weaponlist
        ---- end custom stuff for 2E ruleset encounter spawns
        
			end -- end for
		else
			ChatManager.SystemMessage(Interface.getString("ct_error_addnpcfail2") .. " (" .. sName .. ")");
		end
	end
	
	Interface.openWindow("combattracker_host", "combattracker");
end

-- return dmgadj values for all profs attached to weapon
function getToDamageProfs(nodeWeapon)
  local nMod = 0;
  for _,v in pairs(DB.getChildren(nodeWeapon, "proflist")) do
    nMod = nMod + DB.getValue(v, "dmgadj", 0)
  end
  return nMod;
end

---
--- New CTA functions 
--- 
-- slash command to load the new Call to Arms Combat Tracker

-- add single NPC to the combat tracker
function addCTANPC(sClass, nodeNPC, sNamedInBattle)
	-- Parameter validation
	if not nodeNPC then
		return nil;
	end

  local sNPCFullName = DB.getValue(nodeNPC,"name","");
  if sNamedInBattle then sNPCFullName = sNamedInBattle; end;
  local sName = stripHiddenNameText(sNPCFullName);
  local sNPCNameHidden = getHiddenNameText(sNPCFullName);
  
   -- various bits from CoreRPG that are run, this is where DB.copyNode() is run...
  --local nodeEntry, nodeLastMatch = CombatManager.addNPCHelper(nodeNPC, sName);
  
 --- Start CoreRPG addNPCHelper section
	-- Setup
	local aCurrentCombatants = CombatManager.getCombatantNodes();
	
	-- Get the name to use for this addition
	local bIsCTNPC = (UtilityManager.getRootNodeName(nodeNPC) == CT_MAIN_PATH);
	local sNameLocal = sName;
  if bIsCTNPC then
    sNameLocal = CombatManager.stripCreatureNumber(sNameLocal);
  end
	local sNonIDLocal = DB.getValue(nodeNPC, "nonid_name", "");
	if sNonIDLocal == "" then
		sNonIDLocal = Interface.getString("library_recordtype_empty_nonid_npc");
	elseif bIsCTNPC then
		sNonIDLocal = CombatManager.stripCreatureNumber(sNonIDLocal);
	end
	
	local nLocalID = DB.getValue(nodeNPC, "isidentified", 1);
	if not bIsCTNPC then
		local sSourcePath = nodeNPC.getPath()
		local aMatches = {};
		for _,v in pairs(aCurrentCombatants) do
			local _,sRecord = DB.getValue(v, "sourcelink", "", "");
			if sRecord == sSourcePath then
				table.insert(aMatches, v);
			end
		end
		if #aMatches > 0 then
			nLocalID = 0;
			for _,v in ipairs(aMatches) do
				if DB.getValue(v, "isidentified", 1) == 1 then
					nLocalID = 1;
				end
			end
		end
	end
	
	local nodeLastMatch = nil;
	if sNameLocal:len() > 0 then
		-- Determine the number of NPCs with the same name
		local nNameHigh = 0;
		local aMatchesWithNumber = {};
		local aMatchesToNumber = {};
		for _,v in pairs(aCurrentCombatants) do
			local sEntryName = DB.getValue(v, "name", "");
			local sTemp, sNumber = CombatManager.stripCreatureNumber(sEntryName);
			if sTemp == sNameLocal then
				nodeLastMatch = v;
				
				local nNumber = tonumber(sNumber) or 0;
				if nNumber > 0 then
					nNameHigh = math.max(nNameHigh, nNumber);
					table.insert(aMatchesWithNumber, v);
				else
					table.insert(aMatchesToNumber, v);
				end
			end
		end
	
		-- If multiple NPCs of same name, then figure out whether we need to adjust the name based on options
		local sOptNNPC = OptionsManager.getOption("NNPC");
		if sOptNNPC ~= "off" then
			local nNameCount = #aMatchesWithNumber + #aMatchesToNumber;
			
			for _,v in ipairs(aMatchesToNumber) do
				local sEntryName = DB.getValue(v, "name", "");
				local sEntryNonIDName = DB.getValue(v, "nonid_name", "");
				if sEntryNonIDName == "" then
					sEntryNonIDName = Interface.getString("library_recordtype_empty_nonid_npc");
				end
				if sOptNNPC == "append" then
					nNameHigh = nNameHigh + 1;
					DB.setValue(v, "name", "string", sEntryName .. " " .. nNameHigh);
					DB.setValue(v, "nonid_name", "string", sEntryNonIDName .. " " .. nNameHigh);
				elseif sOptNNPC == "random" then
					local sNewName, nSuffix = CombatManager.randomName(sEntryName);
					DB.setValue(v, "name", "string", sNewName);
					DB.setValue(v, "nonid_name", "string", sEntryNonIDName .. " " .. nSuffix);
				end
			end
			
			if nNameCount > 0 then
				if sOptNNPC == "append" then
					nNameHigh = nNameHigh + 1;
					sNameLocal = sNameLocal .. " " .. nNameHigh;
					sNonIDLocal = sNonIDLocal .. " " .. nNameHigh;
				elseif sOptNNPC == "random" then
					local sNewName, nSuffix = CombatManager.randomName(sNameLocal);
					sNameLocal = sNewName;
					sNonIDLocal = sNonIDLocal .. " " .. nSuffix;
				end
			end
		end
	end
	
	DB.createNode(CombatManager.CT_LIST);
	local nodeEntry = DB.createChild(CombatManager.CT_LIST);
	if not nodeEntry then
		return nil;
	end

  -- make sure saves are added
  copySourceToNodeCTHelper(nodeNPC,nodeEntry,'saves');
  
  --DB.copyNode(nodeNPC, nodeEntry);
  
	-- Remove any combatant specific information
	DB.setValue(nodeEntry, "active", "number", 0);
	DB.setValue(nodeEntry, "tokenrefid", "string", "");
	DB.setValue(nodeEntry, "tokenrefnode", "string", "");
	DB.deleteChildren(nodeEntry, "effects");
	
	-- Set the final name value
	DB.setValue(nodeEntry, "name", "string", sNameLocal);
	DB.setValue(nodeEntry, "nonid_name", "string", sNonIDLocal);
	DB.setValue(nodeEntry, "isidentified", "number", nLocalID);
	
	-- Lock NPC record view by default when copying to CT
	DB.setValue(nodeEntry, "locked", "number", 1);

	-- Set up the CT specific information
	DB.setValue(nodeEntry, "link", "windowreference", "", ""); -- Workaround to force field update on client; client does not pass network update to other clients if setValue creates value node with default value
	DB.setValue(nodeEntry, "link", "windowreference", "npc", nodeEntry.getPath());
	DB.setValue(nodeEntry, "friendfoe", "string", "foe");
  
  DB.setValue(nodeEntry, "sourcelink", "windowreference", "npc", nodeNPC.getPath());
	
	-- Calculate space/reach
	local nSpace, nReach = CombatManager.getNPCSpaceReach(nodeNPC);
	DB.setValue(nodeEntry, "space", "number", nSpace);
	DB.setValue(nodeEntry, "reach", "number", nReach);

	-- Set default letter token, if no token defined
	local sToken = DB.getValue(nodeNPC, "token", "");
	if sToken == "" or not Interface.isToken(sToken) then
		local sLetter = StringManager.trim(sNameLocal):match("^([a-zA-Z])");
		if sLetter then
			sToken = "tokens/Medium/" .. sLetter:lower() .. ".png@Letter Tokens";
		else
			sToken = "tokens/Medium/z.png@Letter Tokens";
		end
		DB.setValue(nodeEntry, "token", "token", sToken);
	elseif sToken ~= "" and Interface.isToken(sToken) then
    DB.setValue(nodeEntry, "token", "token", sToken);
  end
	
 --- end CoreRPG addNPCHelper section
 
  -- save DM only "hiddten text" if necessary to display in host CT
  if sNPCNameHidden ~= nil and sNPCNameHidden ~= "" then
    DB.setValue(nodeEntry,"name_hidden","string",sNPCNameHidden);
  end

  -- base modifier for initiative
  -- we set modifiers based on size per DMG for AD&D -celestian
  DB.setValue(nodeEntry, "init", "number", 0);
    
  if false then -- We don't do this for Hackmaster
	  -- Determine size
	  DB.setValue(nodeEntry,"size","string",DB.getValue(nodeNPC,"size",""));
	  local sSize = StringManager.trim(DB.getValue(nodeEntry, "size", ""):lower());
	  local sSizeNoLower = StringManager.trim(DB.getValue(nodeEntry, "size", ""));
	  if sSize == "tiny" or string.find(sSizeNoLower,"T") then
		-- tokenscale doesn't work, guessing it's "reset" when
		-- the token is actually dropped on the map
		-- need to figure out a work around -celestian
		DB.setValue(nodeEntry, "tokenscale", "number", 0.5);
		DB.setValue(nodeEntry, "init", "number", 0);
	  elseif sSize == "small" or string.find(sSizeNoLower,"S") then
		-- tokenscale doesn't work, guessing it's "reset" when
		-- the token is actually dropped on the map
		DB.setValue(nodeEntry, "tokenscale", "number", 0.75);
		DB.setValue(nodeEntry, "init", "number", 3);
	  elseif sSize == "medium" or string.find(sSizeNoLower,"M") then
		DB.setValue(nodeEntry, "init", "number", 3);
	  elseif sSize == "large" or string.find(sSizeNoLower,"L") then
		DB.setValue(nodeEntry, "space", "number", 10);
		DB.setValue(nodeEntry, "init", "number", 6);
	  elseif sSize == "huge" or string.find(sSizeNoLower,"H") then
		DB.setValue(nodeEntry, "space", "number", 15);
		DB.setValue(nodeEntry, "init", "number", 9);
	  elseif sSize == "gargantuan" or string.find(sSizeNoLower,"G") then
		DB.setValue(nodeEntry, "space", "number", 20);
		DB.setValue(nodeEntry, "init", "number", 12);
	  end
  end

--Debug.console("manager_combat_adnd","addCTANPC","DB.getValue(nodeEntry, init,0)",DB.getValue(nodeEntry, "init", 0));       

  -- if the combat window initiative is set to something, use it instead --celestian
  local nInitMod = DB.getValue(nodeNPC, "initiative.total", 0);
--Debug.console("manager_combat_adnd","addCTANPC","nInitMod",nInitMod);       
  if nInitMod ~= 0 then
    DB.setValue(nodeEntry, "init", "number", nInitMod);
  end

  -- set AC
  DB.setValue(nodeEntry,"ac","number",DB.getValue(nodeNPC,"ac"));

  local nHP = rollNPCHitPoints(nodeNPC);
  DB.setValue(nodeEntry, "wounds", "number", 0);
  DB.setValue(nodeEntry, "hptotal", "number", nHP);
  -- we store "base" here also using current total.
  DB.setValue(nodeEntry, "hpbase", "number", nHP);
    
  -- Roll initiative and sort
  local sOptINIT = OptionsManager.getOption("INIT");
  if (nInitMod == 0) then
    nInitMod = DB.getValue(nodeEntry, "init", 0);
  end
  local nInitiativeRoll = math.random(DataCommonADND.nDefaultInitiativeDice) + nInitMod;
  if sOptINIT == "group" then
    if nodeLastMatch then
      local nLastInit = DB.getValue(nodeLastMatch, "initresult", 0);
      DB.setValue(nodeEntry, "initresult", "number", nLastInit);
    else
      DB.setValue(nodeEntry, "initresult", "number", nInitiativeRoll);
    end
  elseif sOptINIT == "on" then
    DB.setValue(nodeEntry, "initresult", "number", nInitiativeRoll);
  end

  -- set mode/display default to standard/actions
  DB.setValue(nodeEntry,"powermode","string", "standard");
  DB.setValue(nodeEntry,"powerdisplaymode","string","action");
  
  -- sanitize special defense/attack string
  DB.setValue(nodeEntry,"specialAttacks","string",DB.getValue(nodeNPC,"specialAttacks"));
  DB.setValue(nodeEntry,"specialDefense","string",DB.getValue(nodeNPC,"specialDefense"));
  setSpecialDefenseAttack(nodeEntry);

  -- make sure they have type 
  DB.setValue(nodeEntry,"type","string",DB.getValue(nodeNPC,"type"));

  -- make sure they have alignment
  DB.setValue(nodeEntry,"alignment","string",DB.getValue(nodeNPC,"alignment"));
  

  -- check to see if npc effects exists and if so apply --celestian
  EffectManagerADND.updateCharEffects(nodeNPC,nodeEntry);
  
  -- now flip through inventory and pass each to updateEffects()
  -- so that if they have a combat_effect it will be applied.
  -- * since effects for items are set to their source... 
  -- we clear these and replace when the npc is actually source copied
  for _,nodeItem in pairs(DB.getChildren(nodeNPC, "inventorylist")) do
    EffectManagerADND.updateItemEffects(nodeItem,nodeEntry);
  end

  return nodeEntry;
end
function isWeaponProfApplied(nodeWeapon,sProfName)
  local bSelected = false;
  for _,nodeAppliedProf in pairs(DB.getChildren(nodeWeapon, "proflist")) do
    local sName = DB.getValue(nodeAppliedProf,"prof","");
    if sName == sProfName then
      bSelected = true;
      break;
    end
  end
  return bSelected;
end
-- find a weapon prof by name on nodeChar
function getWeaponProfNodeByName(nodeChar,sProfName)
  local nodeProf = nil;
  for _,node in pairs(DB.getChildren(nodeChar, "proficiencylist")) do
    local sName = DB.getValue(node,"name","");
    if sName == sProfName then
      nodeProf = node;
      break;
    end
  end
  return nodeProf;
end

-- apply/remove weapon prof from a weapon
function setWeaponProfApplication(nodeWeapon, sProfName, bApplied)
  if not sProfName or sProfName == '' then
    return nil;
  end
  local nodeRemove = nil;
  for _,nodeAppliedProf in pairs(DB.getChildren(nodeWeapon, "proflist")) do
    local sName = DB.getValue(nodeAppliedProf,"prof","");
    if sName == sProfName then
      nodeRemove = nodeAppliedProf;
      break;
    end
  end
  if nodeRemove and not bApplied then
    nodeRemove.delete();
  end
  if not nodeRemove and bApplied then
    local nodeProfList = DB.createChild(nodeWeapon,"proflist");
    local nodeNewProf = nodeProfList.createChild();
    DB.setValue(nodeNewProf,"prof","string",sProfName);
  end
end

-- make sure that we do not already have a prof selected for this 
function weaponProfExists(nodeWeapon,sProf)
  local bExists = false;
  
  for _,nodeProfs in pairs(DB.getChildren(nodeWeapon, "proflist")) do
    local sProfSelected = DB.getValue(nodeProfs,"prof","");
    if (sProf == sProfSelected) then
      bExists = true;
      break;
    end
  end
  
  return bExists;
end    