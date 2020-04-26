---
---
---
---

function onInit()
  local nodeCT = getDatabaseNode();
  
  DB.addHandler(DB.getPath(nodeCT, "weaponlist_json"), "onUpdate", buildWeaponsListForCTView);
  
  buildWeaponsListForCTView();
end

function onClose()
  DB.removeHandler(DB.getPath(nodeCT, "weaponlist_json"), "onUpdate", buildWeaponsListForCTView);
end

-- return the ID for this weapon entry
-- name_id-00001
function getMyID(sThisControl)
  return sThisControl:match("_(id%-%d+)$");
end
-- return the ID for this damage entry
-- dmg_id-00004_id-00001
-- returns sDamageID, sWeaponID
function getMyDamageID(sThisControl)
  return sThisControl:match("^dmg_(id%-%d+)_(id%-%d+)$");
end

-- populate rWeapon using the passed weapon id's record.
function getWeaponRecord(sWeaponID)
  local rWeapon = {};
  local nodeCT = getDatabaseNode();
  local sWeaponsList = DB.getValue(nodeCT,"weaponlist_json","");
  if sWeaponsList and sWeaponsList ~= '' then
    -- decode the json style string weaponlist entry for this npc
    local rWeaponList = JSON.decode(sWeaponsList);
    for _,rWeaponSource in pairs(rWeaponList) do 
      if rWeaponSource.sID == sWeaponID then
        rWeapon = rWeaponSource;
        break;
      end
    end
  end -- no weaponlist
  return rWeapon;
end
-- get damage record from weapon
-- id-00001, id-00004
function getDamageRecord(sWeaponID,sDamageID)
  local rDamage = {};
  local rWeapon = getWeaponRecord(sWeaponID);
  for _,rDMGSource in pairs(rWeapon.aDamageList) do 
    if rDMGSource.sID == sDamageID then
      rDamage = rDMGSource;
      break;
    end
  end
  
  return rDamage;
end

-- set a new value to the JSON array stored on nodeCT, sWeaponID, sTag, sValue, sType
-- setWeaponRecordValue(nodeCT, id-00001,"nAmmo",3,"number")
function setWeaponRecordValue(nodeCT,sWeaponID,sTag,sValue,sType)
  local sWeaponsList = DB.getValue(nodeCT,"weaponlist_json","");
  if sWeaponsList and sWeaponsList ~= '' then
    -- decode the json style string weaponlist entry for this npc
    local aWeaponList = JSON.decode(sWeaponsList);
    for nID,rWeaponSource in pairs(aWeaponList) do 
      if rWeaponSource.sID == sWeaponID then
        if sType == "string" then
          aWeaponList[nID][sTag] = tostring(sValue) or "";
        elseif sType == "number" then
          aWeaponList[nID][sTag] = tonumber(sValue) or 0;
        else
          aWeaponList[nID][sTag] = sValue;
        end
        local sWeaponListChanged = JSON.encode(aWeaponList);
        DB.setValue(nodeCT,"weaponlist_json","string",sWeaponListChanged);
        break;
      end
    end
  end -- no weaponlist

end

-- this builds all the controls into the viewspace for weapons
function buildWeaponsListForCTView()
-- Debug.console("npc_weapons_ct.lua","buildWeaponsListForCTView","aControls[i].getName()",aControls[i].getName());
  -- we remove existing controls and re-build from scratch
  -- this is incase we eventually allow editing (add/delete items)
  local aControls = getControls();
  if #aControls > 0 then
    for i=1 , #aControls do
      local sControlName = aControls[i].getName();
      if sControlName ~= 'contentanchor' then
        aControls[i].destroy(); 
      end
    end
  end
  
  local nodeCT = getDatabaseNode();
  local sWeaponsList = DB.getValue(nodeCT,"weaponlist_json","");
  if sWeaponsList and sWeaponsList ~= '' then
    -- decode the json style string weaponlist entry for this npc
    local rWeaponList = JSON.decode(sWeaponsList);

    local bRowShade = false;
    for _,rWeapon in pairs(rWeaponList) do 
      local sFrame = nil;
      if bRowShade then
        sFrame = "rowshade";
      end
      --- VARS
      local sControlInit           = "init_" .. rWeapon.sID;
      local sControlAttack         = "attack_" .. rWeapon.sID;
      local sControlName           = "name_" .. rWeapon.sID;
      local sControlType           = "type_" .. rWeapon.sID;

      --- CONTROLS
      -- initiative roll
      local controlInit = createControl("initiative_weapon_ct", sControlInit);
      controlInit.setFrame(sFrame);
      controlInit.setValue("[INIT:" .. rWeapon.nSpeedFactor .. "]");
      controlInit.setReadOnly(true);
      controlInit.setTooltipText("INITIATIVE");

      -- attack name    
      local controlName = createControl("name_weapon_ct", sControlName);
      controlName.setFrame(sFrame);
      controlName.setValue(rWeapon.sName);
      controlName.setReadOnly(true);
      -- this sets height
      controlName.setAnchor("top", sControlInit,"top","absolute",0);
      -- this sets width
      controlName.setAnchor("left", sControlInit,"right","absolute", 0);
      controlName.setAnchor("right", 'contentanchor',"center","absolute",-100);

      -- type of weapon
      local controlType = createControl("type_weapon_ct", sControlType);
      controlType.setFrame(sFrame);
      controlType.setValue(rWeapon.nType);
      controlType.setReadOnly(true);
      controlType.setTooltipText("WEAPON TYPE");
      -- this sets height
      controlType.setAnchor("top", sControlName,"top","absolute",0);
      controlType.setAnchor("bottom", sControlName,"bottom","absolute",0);
      -- this sets width
      controlType.setAnchor("left", sControlName,"right","absolute", 0);
      controlType.setAnchor("right", sControlName,"right","absolute",20);

      -- attack roll
      local controlAttack = createControl("attack_weapon_ct", sControlAttack);
      controlAttack.setFrame(sFrame);
      -- make the attack label concise.
      local sAttackString = "[ATK";
      if rWeapon.nAttackCurrent ~= 0 then
        sAttackString = sAttackString .. ":" .. rWeapon.nAttackCurrent .. "]";
      else
        sAttackString = sAttackString .. "]";
      end
      --
      controlAttack.setValue(sAttackString);
      controlAttack.setReadOnly(true);
      controlAttack.setTooltipText("ATK");
      -- this sets height
      controlAttack.setAnchor("top", sControlType,"top","absolute",0);
      -- this sets width
      controlAttack.setAnchor("left", sControlType,"right","absolute", 0);
      controlAttack.setAnchor("right", sControlType,"right","absolute",50);

      -- add damage rolls
      for nID, rDamage in pairs(rWeapon.aDamageList) do
        local sControlDMG = "dmg_" .. rDamage.sID .. "_" .. rWeapon.sID;
        local sDiceAsString = StringManager.convertDiceToString(rDamage.dDice, rDamage.nBonus);
        
        -- take first letter of each type in the damage type string and uppercase it for compact view.
        local aTypes = StringManager.split(rDamage.sType,",",true);
        local sTypeLetters = "";
        if #aTypes > 0 then
          sTypeLetters = " ";
        end
        for nCount, sAType in pairs(aTypes) do
          local sSep = ",";
          if nCount >= #aTypes then
            sSep = "";
          end
          sTypeLetters = sTypeLetters .. string.upper(sAType:sub(1,1)) .. sSep;
        end
        --
        
        -- Damage control
        local controlDMG = createControl("damage_weapon_ct", sControlDMG);
        controlDMG.setFrame(sFrame);
        local sDamageStringFinal = "[" .. sDiceAsString .. sTypeLetters .. "]";
        local nSizeOfString = string.len(sDamageStringFinal);
        controlDMG.setValue(sDamageStringFinal);
        controlDMG.setReadOnly(true);
        controlDMG.setTooltipText("Damage:" .. rDamage.sDamageAsString);
        -- this sets height
        controlDMG.setAnchor("top", sControlAttack,"top","absolute",0);
        -- this sets width
        controlDMG.setAnchor("left", sControlAttack,"right","relative", 0);
        controlDMG.setAnchor("right", sControlAttack,"right","relative",(nSizeOfString*6));
      end
      
      -- add spacer to end so that it will shade entire line on frame
      local controlSpacer = createControl("spacer_weapon_ct", 'spacer');
      controlSpacer.setFrame(sFrame);
      controlSpacer.setAnchor("top", sControlAttack,"top","absolute",0);
      -- this sets width
      controlSpacer.setAnchor("left", sControlAttack,"right","relative", 0);
      controlSpacer.setAnchor("right", 'contentanchor',"right","absolute",0);
      
      -- done ... NEXT!
      bRowShade = not bRowShade;
    end
  end -- no sWeaponsList
end


function onAttackAction(draginfo, nodeCT, rWeapon)
  local rActor = ActorManager.getActor("", nodeCT);

  -- add itemPath to rActor so that when effects are checked we can 
  -- make compare against action only effects
  rActor.itemPath = rWeapon.sRecord;
  
  local rAction = {};
    
  --local rWeaponProps = StringManager.split(DB.getValue(nodeWeapon, "properties", ""):lower(), ",", true);
  
  rAction.label = rWeapon.sName;
  rAction.stat = rWeapon.sAttackStat;
  if rWeapon.nType == 2 then
    rAction.range = "R";
    if rAction.stat == "" then
      rAction.stat = "strength";
    end
  elseif rWeapon.nType == 1 then
    rAction.range = "R";
    if rAction.stat == "" then
      rAction.stat = "dexterity";
    end
  else
    rAction.range = "M";
    if rAction.stat == "" then
      rAction.stat = "strength";
    end
  end
  rAction.modifier = rWeapon.nAttackBonus + ActorManager2.getAbilityBonus(rActor, rAction.stat, "hitadj");
  
  --rAction.modifier = rAction.modifier + getToHitProfs(nodeWeapon);
    
  rAction.bWeapon = true;
  
  -- Decrement ammo
  local nMaxAmmo = rWeapon.nMaxAmmo;
  if nMaxAmmo > 0 then
    local nUsedAmmo = rWeapon.nAmmo;
    if nUsedAmmo >= nMaxAmmo then
      ChatManager.Message(Interface.getString("char_message_atkwithnoammo"), true, rActor);
    else
      setWeaponRecordValue(nodeCT,rWeapon.sID,"nAmmo",nUsedAmmo +1,"number");
    end
  end
  
  -- Determine crit range
  -- local nCritThreshold = 20;
  -- if rAction.range == "R" then
    -- nCritThreshold = DB.getValue(nodeChar, "weapon.critrange.ranged", 20);
  -- else
    -- nCritThreshold = DB.getValue(nodeChar, "weapon.critrange.melee", 20);
  -- end
  -- for _,vProperty in ipairs(rWeaponProps) do
    -- local nPropCritRange = tonumber(vProperty:match("crit range (%d+)")) or 20;
    -- if nPropCritRange < nCritThreshold then
      -- nCritThreshold = nPropCritRange;
    -- end
  -- end
  -- if nCritThreshold > 1 and nCritThreshold < 20 then
    -- rAction.nCritRange = nCritThreshold;
  -- end
  
  ActionAttack.performRoll(draginfo, rActor, rAction);
  
  return true;
end

function onDamageActionSingle(nodeCT,rWeapon,rDamage,draginfo)
--Debug.console("npc_weapons_ct.lua","onDamageActionSingle","nodeCT",nodeCT);    
  if not nodeCT then
    return false;
  end
    
  local rActor = ActorManager.getActor("", nodeCT);
  rActor.itemPath = rWeapon.sSource;
    
  --local aWeaponProps = StringManager.split(DB.getValue(nodeWeapon, "properties", ""):lower(), ",", true);
  
  local rAction = {};
  rAction.bWeapon = true;
  rAction.label = rWeapon.sName;
  if rWeapon.nType == 0 then
    rAction.range = "M";
  else
    rAction.range = "R";
  end

  local sBaseAbility = "strength";
  if rWeapon.nType == 1 then
    sBaseAbility = "dexterity";
  end
  
  rAction.clauses = {};
   
  local sDmgAbility = rDamage.sStat;
  local sDmgAbility = "base";
  if sDmgAbility == "base" then
    sDmgAbility = sBaseAbility;
  end
  local aDmgDice = rDamage.dDice;
  local nDmgMod = rDamage.nBonus + ActorManager2.getAbilityBonus(rActor, sDmgAbility, "damageadj");
  local sDmgType = rDamage.sType;
  
  --nDmgMod = nDmgMod + getToDamageProfs(nodeWeapon);

  table.insert(rAction.clauses, { dice = aDmgDice, stat = sDmgAbility, modifier = nDmgMod, dmgtype = sDmgType });

  -- check for attached weapon profs and special features like crit/rerolls? -- Celestian
  ---????
  
  -- Check for reroll tag in weapon's properties
  -- local nReroll = 0;
  -- for _,vProperty in ipairs(aWeaponProps) do
    -- local nPropReroll = tonumber(vProperty:match("reroll (%d+)")) or 0;
    -- if nPropReroll > nReroll then
      -- nReroll = nPropReroll;
    -- end
  -- end
  -- if nReroll > 0 then
    -- rAction.label = rAction.label .. " [REROLL " .. nReroll .. "]";
  -- end
  
  ActionDamage.performRoll(draginfo, rActor, rAction);
  return true;
end
