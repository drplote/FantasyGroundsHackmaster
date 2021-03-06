-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

OOB_MSGTYPE_APPLYINIT = "applyinit";
OOB_MSGTYPE_EFFECTADD = "applyaddeffect";

function onInit()
  OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYINIT, handleApplyInit);
  OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_EFFECTADD, handleEffectAdd);

  ActionsManager.registerModHandler("init", modRoll);
  ActionsManager.registerResultHandler("init", onResolve);
end

function handleApplyInit(msgOOB)
  local rSource = ActorManager.getActor(msgOOB.sSourceType, msgOOB.sSourceNode);
  local nTotal = tonumber(msgOOB.nTotal) or 0;

  DB.setValue(ActorManager.getCTNode(rSource), "initresult", "number", nTotal);
  DB.setValue(ActorManager.getCTNode(rSource), "initrolled", "number", 1);
end

function notifyApplyInit(rSource, nTotal)
  if not rSource then
    return;
  end
  
  local msgOOB = {};
  msgOOB.type = OOB_MSGTYPE_APPLYINIT;
  
  msgOOB.nTotal = nTotal;

  local sSourceType, sSourceNode = ActorManager.getTypeAndNodeName(rSource);
  msgOOB.sSourceType = sSourceType;
  msgOOB.sSourceNode = sSourceNode;

  Comm.deliverOOBMessage(msgOOB, "");
end

-- notify oob to deal with this 
function notifyEffectAdd(nodePath, rEffect) 
  local msgOOB = {}; 
  msgOOB.type = OOB_MSGTYPE_EFFECTADD; 
  msgOOB.nodeEntry = nodePath; 
 
  msgOOB.effectDuration = rEffect.nDuration; 
  msgOOB.effectName     = rEffect.sName; 
  msgOOB.effectLabel    = rEffect.sLabel; 
  msgOOB.effectUnit     = rEffect.sUnits; 
  msgOOB.effectInit     = rEffect.nInit; 
  msgOOB.effectSource   = rEffect.sSource or nil; 
  msgOOB.effectDMOnly   = rEffect.nGMOnly; 
  msgOOB.effectApply    = rEffect.sApply or nil; 
 
  Comm.deliverOOBMessage(msgOOB, ""); 
end 
 
-- oob takes control and makes change (sends to apply) 
function handleEffectAdd(msgOOB) 
  local nodeEntry = DB.findNode(msgOOB.nodeEntry); 
  local rEffect     = {}; 
  rEffect.nDuration = msgOOB.effectDuration; 
  rEffect.sName     = msgOOB.effectName; 
  rEffect.sLabel    = msgOOB.effectLabel;  
  rEffect.sUnits    = msgOOB.effectUnit; 
  rEffect.nInit     = msgOOB.effectInit; 
  rEffect.sSource   = msgOOB.effectSource; 
  rEffect.nGMOnly   = msgOOB.effectDMOnly; 
  rEffect.sApply    = msgOOB.effectApply; 
 
  local bFound = false; 
  for _,nodeEffect in pairs(DB.getChildren(nodeEntry, "effects")) do 
    local sEffSource = DB.getValue(nodeEffect, "source_name", ""); 
    local sLabel = DB.getValue(nodeEffect,"label","");
    if (sLabel == rEffect.sName and sEffSource == rEffect.sSource) then 
      bFound = true; 
      break;
    end -- was active 
  end -- nodeEffect for 
  if not bFound then 
    EffectManager.addEffect("", "", nodeEntry, rEffect, false); 
  end 
end 

function getRoll(rActor, bSecretRoll, rItem)
  local rRoll = {};
  rRoll.sType = "init";
  rRoll.nMod = 0;
  
  rRoll.sDesc = "[INIT]";
  
  rRoll.bSecret = bSecretRoll;

  local bIsFixedInitiative = (rItem and (rItem.nType and rItem.nType ~= 0)) or Input.isAltPressed();
  local bIsSpell = false;
  if bIsFixedInitiative then -- ranged weapons go on a fixed initiative
	rRoll.aDice = { "d0" }; 
  elseif rItem and rItem.spellPath then
	bIsSpell = true;
	if DB.getValue(DB.findNode(rItem.spellPath), "components", ""):match("M") then -- Does it have material componenets?
		rRoll.aDice = { "d4" };
	else
		rRoll.aDice = { "d0" };
		bIsFixedInitiative = true;
	end
  else
    rRoll.aDice = { "d" .. DataCommonADND.nDefaultInitiativeDice };    
  end  
  
  -- Determine the modifier and ability to use for this roll
  local sAbility = nil;
  local sActorType, nodeActor = ActorManager.getTypeAndNode(rActor);
--Debug.console("manager_action_init.lua","getRoll","sActorType",sActorType);
    if nodeActor then
        if rItem then
			if not bIsFixedInitiative and not bIsSpell then
				local nReactionAdj = 0 - DB.getValue(nodeActor, "abilities.dexterity.reactionadj", 0);
				rRoll.sDesc = rRoll.sDesc .. "[Reaction Adj: " .. nReactionAdj .. "]";
				rRoll.nMod = rRoll.nMod + nReactionAdj;
			end
			rRoll.nMod = rRoll.nMod + rItem.nInit;
            rRoll.sDesc = rRoll.sDesc .. " [MOD:" .. rItem.sName .. "]";
            -- if (rItem.spellPath) then
                -- applySpellCastingConcentration(nodeActor,rItem.spellPath);
            -- end
        elseif sActorType == "pc" then
            rRoll.nMod = DB.getValue(nodeActor, "initiative.total", 0);
--      sAbility = "dexterity";
        else
            local nMod = DB.getValue(nodeActor, "initiative.total", 0);
            if nMod == 0 then 
                nMod = DB.getValue(nodeActor, "init", 0);
            end
            rRoll.nMod = nMod;
        end
    end
    
--  if sAbility and sAbility ~= "" and sAbility ~= "dexterity" then
--    local sAbilityEffect = DataCommon.ability_ltos[sAbility];
--    if sAbilityEffect then
--      rRoll.sDesc = rRoll.sDesc .. " [MOD:" .. sAbilityEffect .. "]";
--    end
--  end
  
  return rRoll;
end

function performRoll(draginfo, rActor, bSecretRoll, rItem)
  -- we do this to see if they've already rolled initiative, if they have we block it.
  local bAlreadyRolledThisRound = (DB.getValue(ActorManager.getCTNode(rActor),"initrolled",0) == 1);

  if User.isHost() or not bAlreadyRolledThisRound or Input.isAltPressed() then
    
    if bAlreadyRolledThisRound and not User.isHost() then
      UtilityManagerADND.outputBroadcastMessage(rActor,"char_initiative_message_forcedreroll", DB.getValue(ActorManager.getCTNode(rActor), "name", ""));
    end
    
    local rRoll = getRoll(rActor, bSecretRoll, rItem);

    if (draginfo and rActor.itemPath and rActor.itemPath ~= "") then
        draginfo.setMetaData("itemPath",rActor.itemPath);
    end
    if (draginfo and rItem and rItem.spellPath and rItem.spellPath ~= "") then
        draginfo.setMetaData("spellPath",rActor.spellPath);
        rActor.spellPath = rItem.spellPath;
    end
    -- dont like this but I need the spell path to for later and this
    -- is the easiest place to put it. We need to know the spellPath AFTER
    -- the initiative is set so the initiative for the effect is correct
    if (rItem and rItem.spellPath and rItem.spellPath ~= "") then
        rRoll.spellPath = rItem.spellPath;
    end
      
    ActionsManager.performAction(draginfo, rActor, rRoll);
  else
  -- they already rolled.
  function outputUserMessage(sResource, ...)
  local sFormat = Interface.getString(sResource);
  local sMsg = string.format(sFormat, ...);
  ChatManager.SystemMessage(sMsg);
end

    --local sMessageText = string.format(Interface.getString("char_initiative_message_alreadyrolled"),DB.getValue(ActorManager.getCTNode(rActor), "name", ""));
    --ChatManager.Message(sMessageText, true, rActor)
    UtilityManagerADND.outputBroadcastMessage(rActor,"char_initiative_message_alreadyrolled", DB.getValue(ActorManager.getCTNode(rActor), "name", ""));
    --UtilityManagerADND.outputUserMessage("char_initiative_message_alreadyrolled", DB.getValue(ActorManager.getCTNode(rActor), "name", ""));
  end
end


function modRoll(rSource, rTarget, rRoll)
  local bADV = false;
  local bDIS = false;
  if rRoll.sDesc:match(" %[ADV%]") then
    bADV = true;
    rRoll.sDesc = rRoll.sDesc:gsub(" %[ADV%]", "");
  end
  if rRoll.sDesc:match(" %[DIS%]") then
    bDIS = true;
    rRoll.sDesc = rRoll.sDesc:gsub(" %[DIS%]", "");
  end

  if rSource then
    -- Determine ability used
    local sActionStat = nil;
    local sModStat = string.match(rRoll.sDesc, "%[MOD:(%w+)%]");
    if sModStat then	  
      sActionStat = DataCommon.ability_stol[sModStat];
    end
    if not sActionStat then
      sActionStat = "dexterity";
    end
    
    -- Determine general effect modifiers
    local bEffects = false;
    local aAddDice, nAddMod, nEffectCount = EffectManager5E.getEffectsBonus(rSource, {"INIT"});
        
    if nEffectCount > 0 then
      bEffects = true;
      for _,vDie in ipairs(aAddDice) do
        if vDie:sub(1,1) == "-" then
          table.insert(rRoll.aDice, "-p" .. vDie:sub(3));
        else
          table.insert(rRoll.aDice, "p" .. vDie:sub(2));
        end
      end
      rRoll.nMod = rRoll.nMod + nAddMod;
    end
	   
    -- -- Get ability effect modifiers
    -- local nBonusStat, nBonusEffects = ActorManager2.getAbilityEffectsBonus(rSource, sActionStat);
    -- if nBonusEffects > 0 and nBonusStat ~= 0 then
      -- bEffects = true;
      -- rRoll.nMod = rRoll.nMod + nBonusStat;
    -- end
    
    -- Get condition modifiers
    if EffectManager5E.hasEffectCondition(rSource, "ADVINIT") then
      bADV = true;
      bEffects = true;
    end
    if EffectManager5E.hasEffectCondition(rSource, "DISINIT") then
      bDIS = true;
      bEffects = true;
    end
    
    -- Not done in AD&D -celestian
    -- -- Since initiative is a Dexterity check, do all those checks as well
    -- --local aCheckFilter = { "dexterity" };
    -- -- Dexterity check modifiers
    -- local aDexCheckAddDice, nDexCheckAddMod, nDexCheckEffectCount = EffectManager5E.getEffectsBonus(rSource, {"CHECK"}, false, aCheckFilter);
    -- if (nDexCheckEffectCount > 0) then
      -- bEffects = true;
      -- for _,vDie in ipairs(aDexCheckAddDice) do
        -- if vDie:sub(1,1) == "-" then
          -- table.insert(rRoll.aDice, "-p" .. vDie:sub(3));
        -- else
          -- table.insert(rRoll.aDice, "p" .. vDie:sub(2));
        -- end
        -- table.insert(aAddDice, vDie)
      -- end
      -- rRoll.nMod = rRoll.nMod + nDexCheckAddMod;
      -- nAddMod = nAddMod + nDexCheckAddMod;
    -- end
    
    -- Dexterity check conditions
    -- if EffectManager5E.hasEffectCondition(rSource, "ADVCHK") then
      -- bADV = true;
      -- bEffects = true;
    -- elseif #(EffectManager5E.getEffectsByType(rSource, "ADVCHK", aCheckFilter)) > 0 then
      -- bADV = true;
      -- bEffects = true;
    -- end
    -- if EffectManager5E.hasEffectCondition(rSource, "DISCHK") then
      -- bDIS = true;
      -- bEffects = true;
    -- elseif #(EffectManager5E.getEffectsByType(rSource, "DISCHK", aCheckFilter)) > 0 then
      -- bDIS = true;
      -- bEffects = true;
    -- end
    -- if EffectManager5E.hasEffectCondition(rSource, "Frightened") then
      -- bDIS = true;
      -- bEffects = true;
    -- end
    -- if EffectManager5E.hasEffectCondition(rSource, "Intoxicated") then
      -- bDIS = true;
      -- bEffects = true;
    -- end
    -- if EffectManager5E.hasEffectCondition(rSource, "Poisoned") then
      -- bDIS = true;
      -- bEffects = true;
    -- end
    -- if EffectManager5E.hasEffectCondition(rSource, "Encumbered") then
      -- bEffects = true;
      -- bDIS = true;
    -- end

    -- Get exhaustion modifiers
    -- local nExhaustMod, nExhaustCount = EffectManager5E.getEffectsBonus(rSource, {"EXHAUSTION"}, true);
    -- if nExhaustCount > 0 then
      -- bEffects = true;
      -- if nExhaustMod >= 1 then
        -- bDIS = true;
      -- end
    -- end
    
    -- If effects happened, then add note
    if bEffects then
      local sEffects = "";
      local sMod = StringManager.convertDiceToString(aAddDice, nAddMod, true);
      if sMod ~= "" then
        sEffects = "[" .. Interface.getString("effects_tag") .. " " .. sMod .. "]";
      else
        sEffects = "[" .. Interface.getString("effects_tag") .. "]";
      end
      rRoll.sDesc = rRoll.sDesc .. " " .. sEffects;
    end
  end
  
  -- include desktop situation mods on initiative rolls
  ActionsManager2.encodeDesktopMods(rRoll);
  
  ActionsManager2.encodeAdvantage(rRoll, bADV, bDIS);
end

-- Returns effect existence, effect dice, effect mod, effect advantage, effect disadvantage
function getEffectAdjustments(rActor)
	if rActor == nil then
		return false, {}, 0, false, false;
	end
	
	-- Determine ability used - Only dexterity for this ruleset
	local sActionStat = "dexterity";
	
	-- Set up
	local bEffects = false;
	local aEffectDice = {};
	local nEffectMod = 0;
	local bEffectADV = false;
	local bEffectDIS = false;
	
	-- Determine general effect modifiers
	local aInitDice, nInitMod, nInitCount = EffectManager5E.getEffectsBonus(rActor, {"INIT"});
	if nInitCount > 0 then
		bEffects = true;
		for _,vDie in ipairs(aInitDice) do
			table.insert(aEffectDice, vDie);
		end
		nEffectMod = nEffectMod + nInitMod;
	end
	
	-- -- Get ability effect modifiers
	-- local nAbilityMod, nAbilityEffects = ActorManager2.getAbilityEffectsBonus(rActor, sActionStat);
	-- if nAbilityEffects > 0 then
		-- bEffects = true;
		-- nEffectMod = nEffectMod + nAbilityMod;
	-- end
	
	-- Get condition modifiers
	if EffectManager5E.hasEffectCondition(rActor, "ADVINIT") then
		bEffects = true;
		bEffectADV = true;
	end
	if EffectManager5E.hasEffectCondition(rActor, "DISINIT") then
		bEffects = true;
		bEffectDIS = true;
	end
	
	-- Ability check modifiers
	local aCheckFilter = { sActionStat };
	local aAbilityCheckDice, nAbilityCheckMod, nAbilityCheckCount = EffectManager5E.getEffectsBonus(rActor, {"CHECK"}, false, aCheckFilter);
	if (nAbilityCheckCount > 0) then
		bEffects = true;
		for _,vDie in ipairs(aAbilityCheckDice) do
			table.insert(aEffectDice, vDie);
		end
		nEffectMod = nEffectMod + nAbilityCheckMod;
	end
	
	-- -- Dexterity check conditions
	-- if EffectManager5E.hasEffectCondition(rActor, "ADVCHK") then
		-- bEffects = true;
		-- bEffectADV = true;
	-- elseif #(EffectManager5E.getEffectsByType(rActor, "ADVCHK", aCheckFilter)) > 0 then
		-- bEffects = true;
		-- bEffectADV = true;
	-- end
	-- if EffectManager5E.hasEffectCondition(rActor, "DISCHK") then
		-- bEffects = true;
		-- bEffectDIS = true;
	-- elseif #(EffectManager5E.getEffectsByType(rActor, "DISCHK", aCheckFilter)) > 0 then
		-- bEffects = true;
		-- bEffectDIS = true;
	-- end
	-- if EffectManager5E.hasEffectCondition(rActor, "Frightened") then
		-- bEffects = true;
		-- bEffectDIS = true;
	-- end
	-- if EffectManager5E.hasEffectCondition(rActor, "Intoxicated") then
		-- bEffects = true;
		-- bEffectDIS = true;
	-- end
	-- if EffectManager5E.hasEffectCondition(rActor, "Poisoned") then
		-- bEffects = true;
		-- bEffectDIS = true;
	-- end
	-- if EffectManager5E.hasEffectCondition(rActor, "Encumbered") then
		-- bEffects = true;
		-- bEffectDIS = true;
	-- end

	-- Get exhaustion modifiers
	local nExhaustMod, nExhaustCount = EffectManager5E.getEffectsBonus(rActor, {"EXHAUSTION"}, true);
	if nExhaustCount > 0 then
		bEffects = true;
		if nExhaustMod >= 1 then
			bEffectDIS = true;
		end
	end
	
	return bEffects, aEffectDice, nEffectMod, bEffectADV, bEffectDIS;
end

function onResolve(rSource, rTarget, rRoll)
  ActionsManager2.decodeAdvantage(rRoll);

  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  Comm.deliverChatMessage(rMessage);
  
  local nTotal = ActionsManager.total(rRoll);
  notifyApplyInit(rSource, nTotal);
    -- now we apply effect if this was a spell cast initiative
    if (rRoll and rRoll.spellPath) then
        applySpellCastingConcentration(rSource,rRoll);
    end
end

function applySpellCastingConcentration(rSource,rRoll)
    local nTotal = ActionsManager.total(rRoll);
    local sActorType, nodeActor = ActorManager.getTypeAndNode(rSource);
--Debug.console("manager_action_init.lua","applySpellCastingConcentration","rSource",rSource);            
    local nodeSpell = DB.findNode(rRoll.spellPath);
    local nodeChar = nodeActor;
    local nDMOnly = 0;
    if not string.match(nodeActor.getPath(),"^combattracker") then
        -- this is a PC
        nodeChar = CharManager.getCTNodeByNodeChar(nodeActor);
    else
        -- hide if NPC
        nDMOnly = 1;
    end
    -- if not in the combat tracker bail
    if not nodeChar or not nodeSpell then
        return;
    end
    -- build effect fields
    local sSpellName = DB.getValue(nodeSpell,"name","");
    local rEffect = {};
    local sEffectString = "(C)";
    local sEffectFullName = "Casting " .. sSpellName .. "; " .. sEffectString;
    rEffect.nDuration = 1;
    rEffect.sName = sEffectFullName;
    rEffect.sLabel = sEffectString;
    rEffect.sUnits = "rnd";
    rEffect.nInit = nTotal;
--    rEffect.sSource = nodeChar.getPath();
    rEffect.sSource = rSource.sCTNode;
    rEffect.nGMOnly = nDMOnly;
    rEffect.sApply = "action";
    -- lastly add effect
    local sUser = User.getUsername();
    local sIdentity = User.getCurrentIdentity(sUser);
    --EffectManager.addEffect(sUser, sIdentity, nodeChar, rEffect, true);
    notifyEffectAdd(rSource.sCTNode, rEffect)
end

