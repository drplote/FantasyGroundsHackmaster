--
-- Code to manage combox box selection in record_char_weapon.xml
--
--
--
function onInit()
  super.onInit();
  local node = getDatabaseNode();
  local nodeChar = node.getChild("......");
  -- this should cause the values to update should the player tweak their profs.
  DB.addHandler(DB.getPath(nodeChar, "proficiencylist"),"onChildUpdate", updateAllAdjustments);
  
  updateAllAdjustments();
end

function onClose()
  local node = getDatabaseNode();
  local nodeChar = node.getChild("......");
  DB.removeHandler(DB.getPath(nodeChar,"proficiencylist"),"onChildUpdate", updateAllAdjustments);
end

-- when value changed, update hit/dmg
function onValueChanged()
  updateAdjustments();
end

-- update hit/damage adjustments from Proficiency in the abilities tab
function updateAdjustments()
  local node = getDatabaseNode();
  -- update hit/dmg modifiers for prof
  -- flip through proflist
  local nodeChar = node.getChild("......");
  local sSourceName = window.prof.getValue();
  local rProf = getProf(nodeChar,sSourceName);
  if rProf then
    window.hitadj.setValue(rProf.hitadj);
    window.dmgadj.setValue(rProf.dmgadj);
  else
    -- Debug.console("prof_select.lua","updateAdjustments","!rProf");
    -- window.getDatabaseNode().delete();
  end
end


-- update all adjustments for this weapon
-- we do this when a proficiency is updated in the abilities tab
function updateAllAdjustments()
  -- update hit/dmg modifiers
  -- flip through proflist
  local node = getDatabaseNode();
  --local nodeWeapon = node.getChild("....");
  local nodeChar = node.getChild("......");
  setProfList(nodeChar);
  for _,w in pairs(window.windowlist.getWindows()) do
    local sSourceName = w.prof.getValue();
    local rProf = getProf(nodeChar,sSourceName);
    if rProf then 
      w.hitadj.setValue(rProf.hitadj);
      w.dmgadj.setValue(rProf.dmgadj);
    else
      w.hitadj.setValue(0);
      w.dmgadj.setValue(0);
    end
  end
end

-- fill in the drop down list values
function setProfList(nodeChar)
  clear(); -- (removed existing items in list)
  -- sort through player's list of profs and add them
  -- proficiencylist
  for _,v in pairs(DB.getChildren(nodeChar, "proficiencylist")) do
    local sName = DB.getValue(v, "name", "");
    add(v.getPath(),sName);
  end
end

-- get prof hit/dmg adjustments by name of rProf
function getProf(nodeChar,sSourceName)
  local nodeProf = CombatManagerADND.getWeaponProfNodeByName(nodeChar,sSourceName);
  if (nodeProf) then 
    local rProf = {};
    rProf.hitadj = DB.getValue(nodeProf,"hitadj",0);
    rProf.dmgadj = DB.getValue(nodeProf,"dmgadj",0);
    return rProf;
  else
    return nil;
  end
end
