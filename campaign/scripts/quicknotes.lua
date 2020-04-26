--
--
--
--

function onInit()
  -- local nodeCT = getDatabaseNode();
  -- local bInCT = (nodeCT.getPath():match("^combattracker%.") ~= nil);
  -- if not abilitynotes_combattracker then 
    -- abilitynotes.setVisible(true);
  -- else
    -- abilitynotes.setVisible(not bInCT);
    -- abilitynotes_combattracker.setVisible(bInCT);
  -- end
end

-- drag/drop quicknote/notes entry onto a abilitynotes and create
function onDrop(x, y, draginfo)
--Debug.console("quicknotes.lua","onDrop","draginfo",draginfo);  
  if draginfo.isType("shortcut") then
    local node = getDatabaseNode();
    local sClass, sRecord = draginfo.getShortcutData();
    if (sClass == "quicknote") then
      local nodeEncounter = DB.findNode(sRecord);
      if (nodeEncounter) then
        local nodeNotes = node.createChild("abilitynoteslist");
        local nodeNote = nodeNotes.createChild();
        local sName = DB.getValue(nodeEncounter,"name","");
        local sText = DB.getValue(nodeEncounter,"text","");
        local nLocked = DB.getValue(nodeEncounter,"locked",0);
        DB.setValue(nodeNote,"name","string",sName);
        DB.setValue(nodeNote,"text","formattedtext",sText);
        DB.setValue(nodeNote,"locked","number",nLocked);
      end
    end
    return true;
  end
end

