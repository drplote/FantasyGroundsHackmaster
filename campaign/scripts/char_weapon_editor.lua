--
--
--
--

-- allows drag/drop of dice to damage and profs to apply
function onDrop(x, y, draginfo)
  local sDragType = draginfo.getType();
  local sClass = draginfo.getShortcutData();
  if sDragType == "dice" then
    local w = list.addEntry(true);
    for _, vDie in ipairs(draginfo.getDieList()) do
      w.dice.addDie(vDie.type);
    end
    return true;
  elseif sDragType == "number" then
    local w = list.addEntry(true);
    w.bonus.setValue(draginfo.getNumberData());
    return true;
  -- add prof to weapon
  elseif sDragType == "shortcut" and draginfo.getShortcutData() == "ref_proficiency_item" then
    local nodeWeapon = getDatabaseNode();
    local nodeProfDragged = draginfo.getDatabaseNode();
    local sProfSelected = DB.getValue(nodeProfDragged,"name","");
    if not CombatManagerADND.weaponProfExists(nodeWeapon,sProfSelected) then
      local nodeProfList = DB.createChild(nodeWeapon,"proflist");
      local nodeProf = nodeProfList.createChild();
      DB.setValue(nodeProf,"prof","string",DB.getValue(nodeProfDragged,"name"));
      return true;
    end
  end
end
