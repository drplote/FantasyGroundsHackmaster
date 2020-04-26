-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  local node = getDatabaseNode();
--Debug.console("cta_combatants_host.lua","onInit","node",node);

  --DB.addHandler(DB.getPath(node, ".*.hp.wounds"), "onChildUpdate", updateHPBars);

  DB.addHandler(DB.getPath(node, ".*.effects"), "onChildUpdate", updateForEffectChanges);
  DB.addHandler(DB.getPath(node, ".*.targets"), "onChildUpdate", toggleSelectedTargets);
  DB.addHandler(DB.getPath(node, ".*.targets"), "onChildDeleted", toggleSelectedTargets);
  DB.addHandler(DB.getPath(node, ".*.targets"), "onChildAdded", toggleSelectedTargets);

  local nCount = DB.getChildCount(node.getParent(),"list");
  -- we dont run this unless we actually have nodes otherwise it'll
  -- add filler nodes into combattracker.*
  if nCount > 0 then
    clearCombatantsSelectedTargetIcon();
    
    -- first time start of CT, clear selected
    --clearSelect();
    --onListChanged();
  end
  
end

function onClose()
  local node = getDatabaseNode();
  DB.removeHandler(DB.getPath(node, ".*.effects"), "onChildUpdate", updateForEffectChanges);
  DB.removeHandler(DB.getPath(node, ".*.targets"), "onChildUpdate", toggleSelectedTargets);
  DB.removeHandler(DB.getPath(node, ".*.targets"), "onChildDeleted", toggleSelectedTargets);
  DB.removeHandler(DB.getPath(node, ".*.targets"), "onChildAdded", toggleSelectedTargets);
end

-- this makes sure that any effect that adjusts ability scores is updated
-- when an effect is modified.
function updateForEffectChanges(nodeEntry)
  local nodeCT = nodeEntry.getParent();
--  Debug.console("cta_combatants_host.lua","updateForEffectChanges","nodeCT",nodeCT);
  local nodeChar = CombatManagerADND.getNodeFromCT(nodeCT);
  AbilityScoreADND.detailsUpdate(nodeChar);
  AbilityScoreADND.detailsPercentUpdate(nodeChar);
  AbilityScoreADND.updateForEffects(nodeChar);
  CharManager.updateHealthScore(nodeChar);
end

-- toggle selected targets for entry selected/target changes
function toggleSelectedTargets(nodeTargets)
--Debug.console("cta_combatants_host.lua","toggleSelectedTargets","nodeTargets",nodeTargets);
  local nodeCT = nodeTargets.getParent();
  clearCombatantsSelectedTargetIcon();
  markCombatantsSelected(nodeCT);
end

-- update the hpbar in the combatants list.
function updateHPBars()
--Debug.console("cta_combatants_host.lua","updateHPBars");
  for _,v in pairs(getWindows()) do
    if v.hpbar then
      v.hpbar.update();
    end
  end
end

function onListChanged()
  updateHPBars();
end

-- find the window in the windowlist for a specific nodeCT
function findWindowByNode(nodeCT)
  local win = nil;
  for _,v in pairs(getWindows()) do
    local node = v.getDatabaseNode();
    if node == nodeCT then
      win = v;
      break;
    end
  end
  
  return win;
end

function onDrop(x, y, draginfo)
--Debug.console("cta_combatants_host.lua","onDrop","draginfo",draginfo);      
  -- dropping char,npc,encounter
  if draginfo.isType("shortcut") then
    if not User.isHost() then
      return;
    end
    
    local sClass, sRecord = draginfo.getShortcutData();
    if sClass == "charsheet" then
      CombatManagerADND.addPC(draginfo.getDatabaseNode());
      return true;
    elseif sClass == "npc" then
      CombatManagerADND.addCTANPC(sClass, draginfo.getDatabaseNode());
      return true;
    elseif sClass == "battle" then
      CombatManagerADND.addBattle(draginfo.getDatabaseNode());
      return true;
    end
  end

  -- if moving a CT entry, set it to target init -1
  if draginfo.isType("reorder") then
    local sClass, sRecord = draginfo.getShortcutData();
    if sClass == "reorder_cta_initiative" and sRecord ~= "" then
      local win = getWindowAt(x,y);
      if win then
        local nodeInitTarget = win.getDatabaseNode();
        local nodeInitSource = DB.findNode(sRecord);
        if nodeInitTarget ~= nodeInitSource then
          --local nOrderSource = DB.getValue(nodeInitSource,"initresult",0);
          local nOrderTarget = (DB.getValue(nodeInitTarget,"initresult",0));
          local nLastInit = getLastInitiative();
          -- if the very last entry we want to put them below that one
          if nOrderTarget >= nLastInit then
            nOrderTarget = nLastInit + 1;
          else
          -- otherwise we put them above the entry we selected
            nOrderTarget = nOrderTarget - 1;
          end
          DB.setValue(nodeInitSource,"initresult","number",nOrderTarget);
          --DB.setValue(nodeInitTarget,"order","number",nOrderSource);
        end
        return true;
      end
    end
  end

  -- otherwise we assume it's an attack/damage/spell/effect
  local win = getWindowAt(x,y);
  if win then
    local nodeCT = win.getDatabaseNode();
    if nodeCT then
      return CombatManager.onDrop("ct", nodeCT.getNodeName(), draginfo);
    end
  end
  return true;
end

-- return the initiative value of the last entry with initiative.
function getLastInitiative()
  local nLastInit = -100;
  for _,nodeCT in pairs(CombatManager.getCombatantNodes()) do
    local nInit = DB.getValue(nodeCT,"initresult",0);
    if nInit > nLastInit then
      nLastInit = nInit;
    end
  end
  return nLastInit;
end

function onClickRelease(nButton, x, y)
--Debug.console("cta_combatants_host.lua","onClickRelease","nButton",nButton);
  local win = getWindowAt(x,y);
  if win then
    --return win.token.onClickRelease(nButton);
    if nButton == 1 then
      if Input.isControlPressed() then
        local nodeActive = getSelectedNode()
        if nodeActive then
          local nodeTarget = win.getDatabaseNode();
          if nodeTarget then
            TargetingManager.toggleCTTarget(nodeActive, nodeTarget);
          end
        end
      else
        local tokeninstance = CombatManager.getTokenFromCT(win.getDatabaseNode());
        if tokeninstance and tokeninstance.isActivable() then
          tokeninstance.setActive(not tokeninstance.isActive());
        end
      end
    
    else
      local tokeninstance = CombatManager.getTokenFromCT(win.getDatabaseNode());
      if tokeninstance then
        tokeninstance.setScale(1.0);
      end
    end
    return true;
  end
end

-- find the selected node
function getSelectedNode()
  local node = nil;
  for _,nodeCT in pairs(CombatManager.getCombatantNodes()) do
    if DB.getValue(nodeCT,"selected",0) == 1 then
      node = nodeCT;
      break;
    end
  end
  return node;
end

function onClickDown(nButton, x, y)
--  local selectedSubwindow =  window.parentcontrol.window.selected;
  if nButton == 1 then
    if not Input.isControlPressed() then
      local win = getWindowAt(x,y);
      if win then
        local nodeCT = win.getDatabaseNode();
        selectEntryCTA(nodeCT);
        return true;
      else
        -- clicked empty space, unselect any entry
        clearSelect();
      end
    end
  end
  return true;
end

-- select entry and perform tasks related to first time viewing
function selectEntryCTA(nodeCT)
  if not nodeCT then
    return;
  end
  local isNPC = CombatManagerADND.isCTNodeNPC(nodeCT);
  local selectedSubwindow =  window.parentcontrol.window.selected;
--Debug.console("cta_combatants_host.lua","selectEntry","selectedSubwindow",selectedSubwindow);            
  -- clear selected
  clearSelect();

  -- check if this has been source copied before...
  local bSourceCopied = (DB.getValue(nodeCT,"sourceloaded",0) == 1); 

  --local sClassLink, sRecordLink = DB.getValue(nodeCT,"link","","");
  --if sClassLink ~= 'charsheet' then
  if isNPC then
    -- copy source npc into this nodeCT so we can show all it's ui controls
    if not bSourceCopied then
      local sClass,sRecord = DB.getValue(nodeCT,"sourcelink","","");
      if sClass == 'npc' and sRecord ~= "" then
        local nodeSource = DB.findNode(sRecord);
        if nodeSource then
--Debug.console("cta_combatants_host.lua","selectEntry","Firsttime copy",nodeCT);            
          CombatManagerADND.copySourceToNodeCT(nodeSource, nodeCT);
        else
          return; -- could not find sRecord node
        end
      else -- wasn't npc or have sRecord
        return;
      end
    end
  else
    -- class == charsheet
  end
  
  
--Debug.console("cta_combatants_host.lua","selectEntry","Selecting: nodeCT",nodeCT);    
  DB.setValue(nodeCT,"selected","number",1);
  selectedSubwindow.setValue('cta_main_selected_host',nodeCT);
  -- this allows us to see the PC's action/powers in the CT
  if not isNPC then
   local nodeChar = CombatManagerADND.getNodeFromCT(nodeCT);
   selectedSubwindow.subwindow.actions.setValue('cta_actions_host',nodeChar);
   selectedSubwindow.subwindow.skills.setValue('cta_skills_host',nodeChar);
  end
  --
  selectedSubwindow.setVisible(true);
  toggleCombatantsTargetIcons(nodeCT);
end

-- clear existing targeted combatants icons
-- set targeted combatants icons for nodeCT
function toggleCombatantsTargetIcons(nodeCT)
  clearCombatantsSelectedTargetIcon();
  markCombatantsSelected(nodeCT);
end

-- mark all combatant entries with red target if the "selected" entry has them targeted.
function markCombatantsSelected(nodeCT)
--Debug.console("cta_combatants_host.lua","markCombatantsSelected","nodeCT",nodeCT); 
  for _, nodeTarget in pairs(DB.getChildren(nodeCT,"targets")) do
    local sNodeToken = DB.getValue(nodeTarget,"noderef");
    if sNodeToken then
      local nodeTarget = DB.findNode(sNodeToken);
      if nodeTarget then
      local win = findWindowByNode(nodeTarget);
        if win then
          win.targetsSelected.setVisible(true);
        end
      end
    end
  end -- for
end

-- clear the "combatant selected" icons.
function clearCombatantsSelectedTargetIcon()
  for _,win in pairs(getWindows()) do
    local node = win.getDatabaseNode();
      win.targetsSelected.setVisible(false);
    end
end

-- remove selected from any node in right windowlist
function clearSelect()
  local selectedSubwindow =  window.parentcontrol.window.selected;
  selectedSubwindow.setVisible(false);
  for _,win in ipairs(getWindows()) do
    local nodeThis = win.getDatabaseNode();
    DB.setValue(nodeThis,"selected","number",0);
  end
end

-- apply sort to combatants list based on initiative 
function onSortCompare(w1, w2)
	return CombatManager.onSortCompare(w1.getDatabaseNode(), w2.getDatabaseNode());
end
