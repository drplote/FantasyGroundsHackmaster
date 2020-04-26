---
---
---
---

controlDamageEntry = nil;

function onInit()
  local nodeWeapon = getDatabaseNode();
  
  --DB.addHandler(DB.getPath(nodeCT, "weaponlist_json"), "onUpdate", buildWeaponsListForCTView);
  
  local nodeDamage = getDatabaseNode();
  local nodeWeapon = nodeDamage.getChild("...");
  local nodeChar = nodeWeapon.getChild("...");

  DB.addHandler(DB.getPath(nodeWeapon, "type"), "onUpdate", onDamageChanged);
  DB.addHandler(DB.getPath(nodeWeapon, "proflist"), "onChildUpdate", onDamageChanged);
  DB.addHandler(nodeDamage.getPath(), "onChildUpdate", onDamageChanged);
  DB.addHandler(DB.getPath(nodeChar, "abilities.*.dmgadj"), "onUpdate", onDamageChanged);

  buildDamageEntry();
  onDamageChanged();
end

function onClose()
  --DB.removeHandler(DB.getPath(nodeCT, "weaponlist_json"), "onUpdate", buildWeaponsListForCTView);
  local nodeDamage = getDatabaseNode();
  local nodeWeapon = nodeDamage.getChild("...");
  local nodeChar = nodeWeapon.getChild("...");

  DB.removeHandler(DB.getPath(nodeWeapon, "type"), "onUpdate", onDamageChanged);
  DB.removeHandler(DB.getPath(nodeWeapon, "proflist"), "onChildUpdate", onDamageChanged);
  DB.removeHandler(nodeDamage.getPath(), "onChildUpdate", onDamageChanged);
  DB.removeHandler(DB.getPath(nodeChar, "abilities.*.dmgadj"), "onUpdate", onDamageChanged);
  
  if controlDamageEntry then 
    controlDamageEntry.destroy();
    controlDamageEntry = nil;
  end
end

-- this builds all the controls into the viewspace for weapons
function buildDamageEntry()
  local nodeWeapon = getDatabaseNode();
--Debug.console("char_damagelist_item.lua","buildDamageEntry","nodeWeapon",nodeWeapon);  
  -- initiative roll
  local controlDMG = createControl("string_damage_list_item", "dmg_" .. nodeWeapon.getPath());
  --controlDMG.setFrame(sFrame);
  controlDMG.setReadOnly(true);
  controlDamageEntry = controlDMG;
end

-- when damage related values are changed, update the label
function onDamageChanged()
  local nodeDamage = getDatabaseNode();
  local nodeWeapon = nodeDamage.getChild("...");
  local nodeChar = nodeWeapon.getChild("...");
  local rActor = ActorManager.getActor("", nodeChar);
  local nMod = DB.getValue(nodeDamage, "bonus", 0);

  local nType = DB.getValue(nodeWeapon,"type",0);
  local sBaseAbility = "strength";
  if nType == 1 then
    sBaseAbility = "dexterity";
  end

  local sAbility = DB.getValue(nodeDamage, "stat", "");
  if sAbility == "base" or sAbility == "" then
    sAbility = sBaseAbility;
  end

  if sAbility ~= "none" and rActor then
    nMod = nMod + ActorManager2.getAbilityBonus(rActor, sAbility, "damageadj");
  end
  
  nMod = nMod + CombatManagerADND.getToDamageProfs(nodeWeapon);
  local aDice = DB.getValue(nodeDamage, "dice", {});
  local sDamage = StringManager.convertDiceToString(DB.getValue(nodeDamage, "dice", {}), nMod);
  local sDMG = sDamage;
  local sType = DB.getValue(nodeDamage, "type", "");
  if sType ~= "" then
    sDamage = sDamage .. " " .. sType;
  end

  -- take first letter of each type in the damage type string and uppercase it for compact view.
  local aTypes = StringManager.split(sType,",",true);
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
  -- set label to sDamage
  controlDamageEntry.setValue("" .. sDMG .. sTypeLetters .. "");
  controlDamageEntry.setTooltipText("Damage from attack: " .. sDamage);
end

