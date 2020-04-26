---
--
--
--
---

function onInit()
  -- override this
  CombatManager.handleFactionDropOnImage = handleFactionDropOnImage;
  
  -- capture hover/click/target updates and tweak the CT/tokens.
  Token.onHover = onHoverADND
  Token.onClickDown = onClickDownADND;
  Token.onTargetUpdate = onTargetUpdateADND
  
  ---
  OptionsManager.registerOption2("COMBAT_SHOW_RIP", false, "option_header_combat", "option_label_RIP", "option_entry_cycler", 
      { labels = "option_val_on", values = "on", baselabel = "option_val_off", baseval = "off", default = "off" });
  OptionsManager.registerOption2("COMBAT_SHOW_RIP_DM", false, "option_header_combat", "option_label_RIP_DM", "option_entry_cycler", 
      { labels = "option_val_on", values = "on", baselabel = "option_val_off", baseval = "off", default = "off" });
  
  CombatManager.addCombatantFieldChangeHandler("wounds", "onUpdate", updateHealth);
  CombatManager.addCombatantFieldChangeHandler("tokenrefid", "onUpdate", updateHealth);
  
  DB.addHandler("options.COMBAT_SHOW_RIP", "onUpdate", TokenManager.onOptionChanged);
  DB.addHandler("options.COMBAT_SHOW_RIP_DM", "onUpdate", TokenManager.onOptionChanged);
  
  -- for when options are toggled in settings.
  DB.addHandler("options.COMBAT_SHOW_RIP", "onUpdate", updateCTEntries);
  DB.addHandler("options.COMBAT_SHOW_RIP_DM", "onUpdate", updateCTEntries);  
  
  Interface.onDesktopInit = onDesktopInit
end

-- we do this to delay it till things are loaded
-- otherwise cold start map tokens come back nil, for death indicators
function onDesktopInit()
  updateCTEntries();
end

-- this will mark the clicked on token in the CT with arrows/selection.
function onClickDownADND( target, button, image ) 
-- Debug.console("manager_token_adnd.lua","onClickDownADND","target",target);
-- Debug.console("manager_token_adnd.lua","onClickDownADND","button",button);
-- Debug.console("manager_token_adnd.lua","onClickDownADND","image",image);
  
  -- if host and not pressing control (targeting)
  if not Input.isControlPressed() then
    -- click left mouse on token
    if button == 1 then
      local ctwnd = nil;
      local windowPath = nil
      local bOldKludge = false;
      if User.isHost() then
        ctwnd = Interface.findWindow("combattracker_host", "combattracker");
        if ctwnd then windowPath = ctwnd.combatants.subwindow.list; end;
      else
        ctwnd = Interface.findWindow("combattracker_client", "combattracker");
        if ctwnd then windowPath = ctwnd.list; bOldKludge = true; end;
      end
      if ctwnd then
        local nodeCT = CombatManager.getCTFromToken(target);
        if nodeCT then
          local sNodeID = nodeCT.getPath();
          for k,v in pairs(windowPath.getWindows()) do
            local node = v.getDatabaseNode();
            local sFaction = v.friendfoe.getStringValue();
            if node.getPath() == sNodeID then 
              windowPath.scrollToWindow(v);
              if bOldKludge then
                v.ct_select_right.setVisible(true);
                v.ct_select_left.setVisible(true);
              else
                v.cta_select_right.setVisible(true);
              end
              --v.ct_select_left.setVisible(true);
            else
              if bOldKludge then
                v.ct_select_right.setVisible(false);
                v.ct_select_left.setVisible(false);
              else
              -- the sNodeID did not match, clean up select indicator.
              v.cta_select_right.setVisible(false);
              --v.ct_select_left.setVisible(false);
              end
            end
          end
        end -- nodeCT entry didn't exist for token on map
      end
    end
  end
end

-- when token targeted, mark with widget (crosshairs)
function onTargetUpdateADND( source, target, targeted ) 
--Debug.console("manager_token_adnd.lua","onTargetUpdateADND","source",source);
--Debug.console("manager_token_adnd.lua","onTargetUpdateADND","target",target);
--Debug.console("manager_token_adnd.lua","onTargetUpdateADND","targeted",targeted);
  local ctwnd = nil;
  if User.isHost() then
    ctwnd = Interface.findWindow("combattracker_host", "combattracker");
  else
    ctwnd = Interface.findWindow("combattracker_client", "combattracker");
  end
  if ctwnd then
    --local nodeSource = CombatManager.getCTFromToken(source);
    local nodeCT = CombatManager.getCTFromToken(target);
    if nodeCT then
      setTokenTargetedIndicator(nodeCT,targeted);
    end
  end
end
-- set token targeted indicator
function setTokenTargetedIndicator(nodeCT,bState)
--Debug.console("ct_entry.lua","setTokenTargetedIndicator","nodeCT",nodeCT);
  local tokenCT = CombatManager.getTokenFromCT(nodeCT);
  if (tokenCT) then
    local widgetTargeted = tokenCT.findWidget("tokenTargetedIndicator");
    if not widgetTargeted and bState then
      local nWidth, nHeight = tokenCT.getSize();
      --local nScale = tokenCT.getScale();
      local sTokenName = "token_is_targeted";
      widgetTargeted = tokenCT.addBitmapWidget(sTokenName);
      widgetTargeted.setBitmap(sTokenName);
      widgetTargeted.setName("tokenTargetedIndicator");
      widgetTargeted.setSize(nWidth-10, nHeight-10);
      widgetTargeted.setPosition("center", 0, 0);
      widgetTargeted.setVisible(true);
    elseif widgetTargeted and bState then
      widgetTargeted.setVisible(true);
    elseif widgetTargeted and not bState then
      widgetTargeted.destroy();
    end
  end
end

-- when hovering over a token, highlight the entry in the CT
function onHoverADND(tokenMap,bState)
--Debug.console("manager_token_adnd.lua","onTargetUpdateADND","tokenMap",tokenMap);
  local ctwnd = nil;
  local windowPath = nil;
  local bHost = User.isHost();
  
  if bHost then
    ctwnd = Interface.findWindow("combattracker_host", "combattracker");
    if ctwnd then windowPath = ctwnd.combatants.subwindow.list; end;
  else
    ctwnd = Interface.findWindow("combattracker_client", "combattracker");
    if ctwnd then windowPath = ctwnd.list; end;
  end
  if ctwnd then
    local nodeCT = CombatManager.getCTFromToken(tokenMap);
    if nodeCT then
      local sNodeID = nodeCT.getPath();
       for k,v in pairs(windowPath.getWindows()) do
        local node = v.getDatabaseNode();
        local bActive = (DB.getValue(node, "active", 0) == 1)
        local sFaction = v.friendfoe.getStringValue();
        if node.getPath() == sNodeID then 
          windowPath.scrollToWindow(v);
          local sFrame, sColor;
          if bHost then
            sFrame, sColor = v.getBackground(node,bState);
          else
          -- kludge to deal with different CT on client for now
            sFrame = getCTFrameType(sFaction,bState,bActive); 
            if (bState and bActive) then
              sFrame = 'field-initiative';
            end
          end;
          v.setFrame(sFrame);
          v.setBackColor(sColor);
        end
      end
    end
  end
end
-- return frame for selected or unselected(bState=FALSE) and "active" if token has initiative currently
function getCTFrameType(sFaction,bState,bActive)
--Debug.console("manager_token_adnd.lua","getCTFrameType","sFaction",sFaction);
  local sFrame = 'field-initiative';
  
  if User.isHost() then
  else -- this is a kludge until I get the client CT, keep old one working
    sFrame = 'ctentrybox';
    if bState or bActive then
      if sFaction == "friend" then
        sFrame = "ctentrybox_friend_active";
      elseif sFaction == "neutral" then
        sFrame = "ctentrybox_neutral_active";
      elseif sFaction == "foe" then
        sFrame = "ctentrybox_foe_active";
      else
        sFrame = "ctentrybox_active";
      end
    else
      if sFaction == "friend" then
        sFrame = "ctentrybox_friend";
      elseif sFaction == "neutral" then
        sFrame = "ctentrybox_neutral";
      elseif sFaction == "foe" then
        sFrame = "ctentrybox_foe";
      else
        sFrame = "ctentrybox";
      end
    end
  end

  return sFrame;
end

-- -- alt click to highlight name in CT for this creature.
-- function onClickReleaseADND(tokenMap, vImage)
  -- if User.isHost() and Input.isAltPressed() then
    -- local ctwnd = Interface.findWindow("combattracker_host", "combattracker");
    -- if ctwnd then
      -- local nodeCT = CombatManager.getCTFromToken(tokenMap);
      -- local sNodeID = nodeCT.getPath();
       -- for k,v in pairs(ctwnd.list.getWindows()) do
        -- if v.getDatabaseNode().getPath() == sNodeID then 
          -- ctwnd.list.scrollToWindow(v);
          -- v.name.setFocus();
          -- v.setFrame("ctentrybox_foe_active");
        -- end
      -- end
    -- end
  -- else
   -- -- do nothing otherwise?
  -- end

-- end

function onDoubleClickADND(tokenMap, vImage)
--local tokenName = tokenMap.getName();
--local nodeNPC = DB.findNode(tokenName);
--    if (tokeName ~= "" and nodeNPC) then
        -- local sClass = "npc";
        -- local sName = DB.getValue(nodeNPC,"name","");
        -- CombatManager.addNPC(sClass, nodeNPC, sName);    
--        spawnNPC(nodeNPC,tokenMap);
--    else
        -- local nodeCT = CombatManager.getCTFromToken(tokenMap);
        -- if nodeCT then
            -- local sClass, sRecord = DB.getValue(nodeCT, "link", "", "");
            -- if sClass == "charsheet" then
                -- if DB.isOwner(sRecord) then
                    -- Interface.openWindow(sClass, sRecord);
                    -- vImage.clearSelectedTokens();
                -- end
            -- else
                -- if User.isHost() or (DB.getValue(nodeCT, "friendfoe", "") == "friend") then
                    -- Interface.openWindow("npc", nodeCT);
                    -- vImage.clearSelectedTokens();
                -- end
            -- end
        -- end
--    end    

  -- -- alt-double click to bring up sheet and highlight name in CT.
  -- if User.isHost() and Input.isAltPressed() then
    -- local ctwnd = Interface.findWindow("combattracker_host", "combattracker");
-- --Debug.console("manager_token_adnd.lua","onDoubleClickADND","ctwnd",ctwnd);
    -- if ctwnd then
      -- local nodeCT = CombatManager.getCTFromToken(tokenMap);
      -- local sNodeID = nodeCT.getPath();
       -- for k,v in pairs(ctwnd.list.getWindows()) do
        -- if v.getDatabaseNode().getPath() == sNodeID then 
          -- ctwnd.list.scrollToWindow(v);
          -- v.name.setFocus();
        -- end
      -- end
    -- end
  -- else
    -- TokenManager.onDoubleClick(tokenMap, vImage);
  -- end

end

-- spawn the npc passed using token as location
function spawnNPC(nodeNPC,tokenMap)
    if nodeNPC then
      local xpos, ypos = tokenMap.getPosition();
      local sName = DB.getValue(nodeNPC,"name","");
      local sClass = "npc";
      local sRecord = tokenMap.getContainerNode().getNodeName();
      
      -- local aPlacement = {};
      -- for _,vPlacement in pairs(DB.getChildren(vNPCItem, "maplink")) do
          -- local rPlacement = {};
          -- local _, sRecord = DB.getValue(vPlacement, "imageref", "", "");
          -- rPlacement.imagelink = sRecord;
          -- rPlacement.imagex = DB.getValue(vPlacement, "imagex", 0);
          -- rPlacement.imagey = DB.getValue(vPlacement, "imagey", 0);
          -- table.insert(aPlacement, rPlacement);
      -- end
        
      --local nCount = DB.getValue(vNPCItem, "count", 1);
      local nCount = 1;
      for i = 1, nCount do
        local nodeEntry = CombatManager.addNPC(sClass, nodeNPC, sName);
        if nodeEntry then
          -- local sFaction = DB.getValue(vNPCItem, "faction", "");
          -- if sFaction ~= "" then
          -- DB.setValue(nodeEntry, "friendfoe", "string", sFaction);
          -- end
          local sToken = tokenMap.getPrototype();
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
            
            TokenManager.setDragTokenUnits(DB.getValue(nodeEntry, "space"));
            local tokenAdded = Token.addToken(sRecord, sToken, xpos, ypos);
            TokenManager.endDragTokenWithUnits(nodeEntry);
            if tokenAdded then
              TokenManager.linkToken(nodeEntry, tokenAdded);
            end
          end
        else
          ChatManager.SystemMessage(Interface.getString("ct_error_addnpcfail") .. " (" .. sName .. ")");
        end
      end
    tokenMap.delete();
    else
      ChatManager.SystemMessage(Interface.getString("ct_error_addnpcfail2") .. " (" .. sName .. ")");
    end
end

-- remove "selected" > Entry < indicator from combat tracker combatants list
function resetIndicators(nodeChar, bLong)
--Debug.console("manager_token_adnd.lua","resetIndicators","nodeChar",nodeChar);
  local ctwnd = nil;
  local windowPath = nil;
  local bOldKludge = false;
  if User.isHost() then
    ctwnd = Interface.findWindow("combattracker_host", "combattracker");
    if ctwnd then windowPath = ctwnd.combatants.subwindow.list; end;
  else
    ctwnd = Interface.findWindow("combattracker_client", "combattracker");
    if ctwnd then windowPath = ctwnd.list; bOldKludge = true; end;
  end
  if ctwnd then
    local nodeCT = CombatManager.getCTFromNode(nodeChar);
    if nodeCT then
      for k,v in pairs(windowPath.getWindows()) do
        local node = v.getDatabaseNode();
        if bOldKludge then
          v.ct_select_left.setVisible(false);
          v.ct_select_right.setVisible(false);
        else
          v.cta_select_right.setVisible(false);
        --v.ct_select_left.setVisible(false);
        end
      end
    end
  end
end

-- The first time the map is loaded after a previous session it's possible
-- that tokens will be unmarked "targeted" if multiple CT entries target the
-- same entry. This could be coded around but seems to edge case to bother with? 
-- Would need to check the "active node" targets and ignore clearing those while
-- looping through EVERYONE elses targets.
-- If someone complains I'll do it.
-- celestian
-- set targets tokens indicators if Active, or hides if not active
function setTargetsForActive(nodeCT,bForced)
  local bActive = (DB.getValue(nodeCT, "active", 0) == 1)
  if bForced then bActive = bForced; end;
  for _, nodeTarget in pairs(DB.getChildren(nodeCT,"targets")) do
    local sNodeToken = DB.getValue(nodeTarget,"noderef");
    if sNodeToken then 
      local nodeToken = DB.findNode(sNodeToken);
      setTokenTargetedIndicator(nodeToken,bActive)
    end
  end -- for
end
-- clear all widget targets on tokens
function clearAllTargetsWidgets()
  for _,node in pairs(CombatManager.getCombatantNodes()) do
    setTargetsForActive(node,false);
  end
end
--
-- Death indicator functions
--

-- Run when image is first loaded
-- flip through all the CT entries and update and then updateHealth() and set active persons targets
function updateCTEntries()
  for _,node in pairs(CombatManager.getCombatantNodes()) do
    updateHealth(node.getChild("wounds"));
    setTargetsForActive(node);
  end
end

-- update tokens for health changes
function updateHealth(nodeField)
--Debug.console("manager_token_adnd.lua","updateHealth","nodeField",nodeField);
  if not nodeField then
    return;
  end
  
  local nodeCT = nodeField.getParent();
  local tokenCT = CombatManager.getTokenFromCT(nodeCT);
  if (tokenCT) then
    -- Percent Damage, Status String, Wound Color
    local pDmg, pStatus, sColor = TokenManager2.getHealthInfo(nodeCT);
    
    -- show rip on tokens
    local bOptionShowRIP = OptionsManager.isOption("COMBAT_SHOW_RIP", "on");
    local bOptionShowRIP_DM = OptionsManager.isOption("COMBAT_SHOW_RIP_DM", "on");
    -- display if health 0 or lower and option on
    local bPlayDead = ((pDmg >= 1) and (bOptionShowRIP));
    if User.isHost() then
      bPlayDead = ((pDmg >= 1) and (bOptionShowRIP_DM));
    end
    local widgetDeathIndicator = tokenCT.findWidget("deathindicator");
    if bPlayDead then
      if not widgetDeathIndicator then
        local nWidth, nHeight = tokenCT.getSize();
        local nScale = tokenCT.getScale();
        local sName = DB.getValue(nodeCT,"name","Unknown");
        -- new stuff, adds indicator for "DEAD" on the token. -celestian
        local sDeathTokenName = "token_dead";
        -- sDeathTokenName = sDeathTokenName .. tostring(math.random(5)); -- creates token_dead0,token_dead1,token_dead2,token_dead3,token_dead4,token_dead5 string
        -- figure out if this is a pc token
        local rActor = ActorManager.getActorFromCT(nodeCT);
        local sActorType, nodeActor = ActorManager.getTypeAndNode(rActor);    
        if sActorType == "pc" then
          sDeathTokenName = "token_dead_pc";
        end
        widgetDeathIndicator = tokenCT.addBitmapWidget(sDeathTokenName);
        widgetDeathIndicator.setBitmap(sDeathTokenName);
        widgetDeathIndicator.setName("deathindicator");
        widgetDeathIndicator.setTooltipText(ActorManager.getDisplayName(ActorManager.getActorFromCT(nodeCT)) .. " has fallen, as if dead.");
        widgetDeathIndicator.setSize(nWidth-20, nHeight-20);
        --widgetDeathIndicator.setFrame(sDeathTokenName, 5, 5, 5, 5);
      end
      widgetDeathIndicator.setVisible(bPlayDead);
    else
      if widgetDeathIndicator then
        widgetDeathIndicator.destroy();
      end
    end
  end
end

-- this CombatManager override is so we can only drag/drop tokens if they
-- do not already exist. If you press control while drag/drop it will add them even if they do. --celestian
function handleFactionDropOnImage(draginfo, imagecontrol, x, y)
	if not User.isHost() then return; end
--Debug.console("manager_token_adnd.lua","handleFactionDropOnImage","draginfo",draginfo);
	
	if Interface.getVersion() < 4 then
		-- Determine image viewpoint
		-- Handle zoom factor (>100% or <100%) and offset drop coordinates
		local vpx, vpy, vpz = imagecontrol.getViewpoint();
		x = x / vpz;
		y = y / vpz;
	end
	
	-- If grid, then snap drop point and adjust drop spread
	local nDropSpread = 15;
	if imagecontrol.hasGrid() then
		x, y = imagecontrol.snapToGrid(x, y);
		nDropSpread = imagecontrol.getGridSize();
	end

	-- Grab faction data from drag object, and apply to each combatant node
	local sFaction = draginfo.getStringData();
	for _,v in pairs(CombatManager.getCombatantNodes()) do
    local bTokenExists = false;
    local existingToken = CombatManager.getTokenFromCT(v);
    if existingToken then
      local existingTokenContainer = existingToken.getContainerNode();
      local imageNode = imagecontrol.getDatabaseNode();
      bTokenExists = (existingTokenContainer == imageNode);
    end
    -- check if token exists before adding to map unless control is pressed --celestian
    if not bTokenExists or Input.isControlPressed() then
      if DB.getValue(v, "friendfoe", "") == sFaction then
        local sToken = DB.getValue(v, "token", "");
        if sToken ~= "" then
          -- Add it to the image at the drop coordinates
          TokenManager.setDragTokenUnits(DB.getValue(v, "space"));
          local tokenMap = imagecontrol.addToken(sToken, x, y);
          TokenManager.endDragTokenWithUnits();

          -- Update token references
          CombatManager.replaceCombatantToken(v, tokenMap);
          
          -- Offset drop coordinates for next token
          if (Interface.getVersion() < 4) then
            if x >= (nDropSpread * 1.5) then
              x = x - nDropSpread;
            end
            if y >= (nDropSpread * 1.5) then
              y = y - nDropSpread;
            end
          else
            x = x - nDropSpread;
            y = y - nDropSpread;
          end
        end
      end
    end
	end
	
	return true;
end
