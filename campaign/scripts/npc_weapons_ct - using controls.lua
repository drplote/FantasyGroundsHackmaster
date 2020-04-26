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
function getMyID(sThisControl)
  return sThisControl:match("_(id%-%d+)$");
end

-- get a control by name
-- sControlNameToGet: name, init, type, attack, etc...
-- sWeaponID: need source control object to get namespace of the one you're looking for. "getMyID(getName())" from control calling
function getControl(sControlNameToGet,sWeaponID)
  local control = nil;
  if sWeaponID then
    local sFindThis = sControlNameToGet .. "_" .. sWeaponID;
    -- get a list of all the controls for this npc and find the one we want.
    local aControls = getControls();
    if #aControls > 0 then
      for i=1 , #aControls do
        local sControlName = aControls[i].getName();
        if sControlName == sFindThis then
          control = aControls[i];
        end
      end
    end
  end
  return control;
end

-- populate rWeapon.* using sWeaponID as source
function getWeaponRecord(sWeaponID)
  local rWeapon = {};
  
  -- this could also just point to sWeaponID
  rWeapon.sID   = getControl("weaponid",sWeaponID).getValue();
  
  rWeapon.sName   = getControl("name",sWeaponID).getValue();
  rWeapon.nInit   = getControl("init",sWeaponID).getValue();
  rWeapon.sAttack = getControl("attack",sWeaponID).getValue();
  rWeapon.nType   = tonumber(getControl("type",sWeaponID).getValue()) or 0;

  rWeapon.nMaxAmmo = tonumber(getControl("maxammo",sWeaponID).getValue()) or 0;
  rWeapon.nUsedAmmo = tonumber(getControl("usedammo",sWeaponID).getValue()) or 0;

  rWeapon.sSource      = getControl("source",sWeaponID).getValue();
  rWeapon.sAttackStat  = getControl("attackstat",sWeaponID).getValue();
  rWeapon.nAttackBonus = tonumber(getControl("attackbonus",sWeaponID).getValue() or 0);
  
  return rWeapon;
end

-- (id-00001,"usedammo",3,"number")
function setWeaponRecordValue(sWeaponID,sTag,sValue,sType)
  if sType == "string" then
    getControl(sTag,sWeaponID).setValue(tostring(sValue) or "");
  elseif sType == "number" then
    getControl(sTag,sWeaponID).setValue(tonumber(sValue) or 0);
  else
    getControl(sTag,sWeaponID).setValue(sValue);
  end
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
      end
    end
  end
  
  local nodeCT = getDatabaseNode();
  local sWeaponsList = DB.getValue(nodeCT,"weaponlist_json","");
  if sWeaponsList and sWeaponsList ~= '' then
    -- decode the json style string weaponlist entry for this npc
    local aWeaponList = JSON.decode(sWeaponsList);

  --number_weapon_ct

    local nItemCount = 0;
    for _,aWeapon in pairs(aWeaponList) do 
      nItemCount = nItemCount + 1;
      --- VARS
      local sControlInit           = "init_" .. aWeapon.sID;
      local sControlAttack         = "attack_" .. aWeapon.sID;
      local sControlName           = "name_" .. aWeapon.sID;
      local sControlType           = "type_" .. aWeapon.sID;

      -- these are hidden controls
      local sControlWeaponID       = "weaponid_" .. aWeapon.sID;
      local sControlSource         = "source_" .. aWeapon.sID;
      local sControlAttackStat     = "attackstat_" .. aWeapon.sID;
      local sControlAttackBonus    = "attackbonus_" .. aWeapon.sID;
      local sControlMaxAmmo        = "maxammo_" .. aWeapon.sID;
      local sControlUsedAmmo       = "usedammo_" .. aWeapon.sID;
      ---

      --- CONTROLS
      -- initiative roll
      local controlInit = createControl("initiative_weapon_ct", sControlInit);
      controlInit.setValue(aWeapon.nSpeedFactor);
      controlInit.setReadOnly(true);
      controlInit.setTooltipText("INITIATIVE");
      
      -- attack name    
      local controlName = createControl("name_weapon_ct", sControlName);
      controlName.setValue(aWeapon.sName);
      controlName.setReadOnly(true);
      -- this sets height
      controlName.setAnchor("top", sControlInit,"top","absolute",0);
      --controlName.setAnchor("bottom", sControlInit,"bottom","absolute",0);
      -- this sets width
      controlName.setAnchor("left", sControlInit,"right","absolute", 5);
      controlName.setAnchor("right", 'contentanchor',"center","absolute",0);
      
      if nItemCount % 2 == 0 then
        controlName.setFrame("rowshade");
      else 
        controlName.setFrame(nil);
      end

      -- type of weapon
      local controlType = createControl("type_weapon_ct", sControlType);
      controlType.setValue(aWeapon.nType);
      controlType.setReadOnly(true);
      controlType.setTooltipText("WEAPON TYPE");
      -- this sets height
      controlType.setAnchor("top", sControlName,"top","absolute",0);
      --controlType.setAnchor("bottom", sControlName,"bottom","absolute",1);
      -- this sets width
      controlType.setAnchor("left", sControlName,"right","absolute", 5);
      controlType.setAnchor("right", sControlName,"right","absolute",25);

      -- attack roll
      local controlAttack = createControl("attack_weapon_ct", sControlAttack);
      controlAttack.setValue(aWeapon.sAttack);
      controlAttack.setReadOnly(true);
      controlAttack.setTooltipText("ATK");
      -- this sets height
      controlAttack.setAnchor("top", sControlType,"top","absolute",0);
      --controlAttack.setAnchor("bottom", sControlType,"bottom","absolute",1);
      -- this sets width
      controlAttack.setAnchor("left", sControlType,"right","absolute", 5);
      controlAttack.setAnchor("right", sControlType,"right","absolute",25);
      


      -- these are hidden items we need to get at but dont need to see in CT
      local controlWeaponID = createControl("hidden_string_weapon_ct", sControlWeaponID);
      controlWeaponID.setValue(aWeapon.sID);
      controlWeaponID.setReadOnly(true);
      controlWeaponID.setVisible(false);

      local controlSource = createControl("hidden_string_weapon_ct", sControlSource);
      controlSource.setValue(aWeapon.sSource);
      controlSource.setReadOnly(true);
      controlSource.setVisible(false);

      local controlAtkStat = createControl("hidden_string_weapon_ct", sControlAttackStat);
      controlAtkStat.setValue(aWeapon.sAttackStat);
      controlAtkStat.setReadOnly(true);
      controlAtkStat.setVisible(false);

      local controlAtkBonus = createControl("hidden_string_weapon_ct", sControlAttackBonus);
      controlAtkBonus.setValue(aWeapon.nAttackBonus);
      controlAtkBonus.setReadOnly(true);
      controlAtkBonus.setVisible(false);

      local controlMaxAmmo = createControl("hidden_string_weapon_ct", sControlMaxAmmo);
      controlMaxAmmo.setValue(aWeapon.nMaxAmmo);
      controlMaxAmmo.setReadOnly(true);
      controlMaxAmmo.setVisible(false);

      local controlUsedAmmo = createControl("hidden_string_weapon_ct", sControlUsedAmmo);
      controlUsedAmmo.setValue(aWeapon.nUsedAmmo);
      controlUsedAmmo.setReadOnly(true);
      controlUsedAmmo.setVisible(false);

      -- aWeapon.aDamageList = {};
      -- for _, nodeDamage in pairs(DB.getChildren(nodeWeapon,"damagelist")) do
        -- local aDamage = {};
        -- aDamage.sDamageAsString = DB.getValue(nodeDamage,"damageasstring","");
        -- aDamage.nBonus = DB.getValue(nodeDamage,"bonus",0);
        -- aDamage.dDice = DB.getValue(nodeDamage,"dice","");
        -- aDamage.sStat = DB.getValue(nodeDamage,"stat","");
        -- aDamage.sType = DB.getValue(nodeDamage,"type","");      
        -- table.insert(aWeapon.aDamageList,aDamage);
      -- end
    end
  end -- no sWeaponsList
end


function onAttackAction(draginfo, nodeCT, rWeapon)
  local rActor = ActorManager.getActor("", nodeCT);

  -- add itemPath to rActor so that when effects are checked we can 
  -- make compare against action only effects
  rActor.itemPath = rWeapon.sRecord;
  
Debug.console("npc_weapons_ct.lua","onAttackAction","rActor",rActor);    
    --
    
  local rAction = {};
    
  --local aWeaponProps = StringManager.split(DB.getValue(nodeWeapon, "properties", ""):lower(), ",", true);
  
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
    local nUsedAmmo = rWeapon.nUsedAmmo;
    if nUsedAmmo >= nMaxAmmo then
      ChatManager.Message(Interface.getString("char_message_atkwithnoammo"), true, rActor);
    else
      setWeaponRecordValue(rWeapon.sID,"usedammo",nUsedAmmo +1,"number");
    end
  end
  
  -- Determine crit range
  local nCritThreshold = 20;
  -- if rAction.range == "R" then
    -- nCritThreshold = DB.getValue(nodeChar, "weapon.critrange.ranged", 20);
  -- else
    -- nCritThreshold = DB.getValue(nodeChar, "weapon.critrange.melee", 20);
  -- end
  -- for _,vProperty in ipairs(aWeaponProps) do
    -- local nPropCritRange = tonumber(vProperty:match("crit range (%d+)")) or 20;
    -- if nPropCritRange < nCritThreshold then
      -- nCritThreshold = nPropCritRange;
    -- end
  -- end
  -- if nCritThreshold > 1 and nCritThreshold < 20 then
    -- rAction.nCritRange = nCritThreshold;
  -- end
  
  rAction.nCritRange = nCritThreshold;
  ActionAttack.performRoll(draginfo, rActor, rAction);
  
  return true;
end

