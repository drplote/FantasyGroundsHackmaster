-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  super.onInit();
  onHealthChanged();
  
  local node = getDatabaseNode();
  DB.addHandler(node.getPath() .. ".active", "onUpdate", toggleActiveUpdateFeatures);
  -- make sure first time load of map has proper indicator
  toggleActiveUpdateFeatures()
end

function onClose()
  local node = getDatabaseNode();
  DB.removeHandler(node.getPath() .. ".active", "onUpdate", toggleActiveUpdateFeatures);
end

-- go through what needs done for active changing.
function toggleActiveUpdateFeatures()
  TokenManagerADND.clearAllTargetsWidgets();
  toggleTargetTokenIndicators();
  clearSelectionToken();
end
-- clean any selected token
function clearSelectionToken()
  local nodeCT = getDatabaseNode();
  local tokenMap = CombatManager.getTokenFromCT(nodeCT);
  local imageControl = ImageManager.getImageControl(tokenMap, true);
  if imageControl then
    imageControl.clearSelectedTokens();
    imageControl.selectToken( tokenMap, true ) ;
  end
  TokenManagerADND.resetIndicators(nodeCT, false);
end

function toggleTargetTokenIndicators()
  local nodeCT = getDatabaseNode();
  TokenManagerADND.setTargetsForActive(nodeCT)
end

function onFactionChanged()
  super.onInit();
  updateHealthDisplay();
end

function onHealthChanged()
  local sColor = ActorManager2.getWoundColor("ct", getDatabaseNode());
  
  wounds.setColor(sColor);
  status.setColor(sColor);
end

function updateHealthDisplay()
  local sOption;
  if friendfoe.getStringValue() == "friend" then
    sOption = OptionsManager.getOption("SHPC");
  else
    sOption = OptionsManager.getOption("SHNPC");
  end
  
  if sOption == "detailed" then
    hptotal.setVisible(true);
    hptemp.setVisible(true);
    wounds.setVisible(true);

    status.setVisible(false);
  elseif sOption == "status" then
    hptotal.setVisible(false);
    hptemp.setVisible(false);
    wounds.setVisible(false);

    status.setVisible(true);
  else
    hptotal.setVisible(false);
    hptemp.setVisible(false);
    wounds.setVisible(false);

    status.setVisible(false);
  end
end
