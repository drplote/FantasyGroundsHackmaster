-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local node = window.getDatabaseNode();
  
  DB.addHandler(DB.getPath(node, ".ac"), "onUpdate", onCombatStatsChanged);
  DB.addHandler(DB.getPath(node, ".thaco"), "onUpdate", onCombatStatsChanged);
  DB.addHandler(DB.getPath(node, ".speed"), "onUpdate", onCombatStatsChanged);

  DB.addHandler(DB.getPath(node, ".morale"), "onUpdate", onCombatStatsChanged);
  DB.addHandler(DB.getPath(node, ".alignment"), "onUpdate", onCombatStatsChanged);
  DB.addHandler(DB.getPath(node, ".hdtext"), "onUpdate", onCombatStatsChanged);
  DB.addHandler(DB.getPath(node, ".numberattacks"), "onUpdate", onCombatStatsChanged);
  DB.addHandler(DB.getPath(node, ".size"), "onUpdate", onCombatStatsChanged);
  DB.addHandler(DB.getPath(node, ".specialDefense"), "onUpdate", onCombatStatsChanged);
  DB.addHandler(DB.getPath(node, ".specialAttacks"), "onUpdate", onCombatStatsChanged);

  onCombatStatsChanged();
end

function onClose()
	local node = window.getDatabaseNode();
  
  DB.removeHandler(DB.getPath(node, ".ac"), "onUpdate", onCombatStatsChanged);
  DB.removeHandler(DB.getPath(node, ".speed"), "onUpdate", onCombatStatsChanged);
  DB.removeHandler(DB.getPath(node, ".thaco"), "onUpdate", onCombatStatsChanged);

  DB.removeHandler(DB.getPath(node, ".morale"), "onUpdate", onCombatStatsChanged);
  DB.removeHandler(DB.getPath(node, ".alignment"), "onUpdate", onCombatStatsChanged);
  DB.removeHandler(DB.getPath(node, ".hdtext"), "onUpdate", onCombatStatsChanged);
  DB.removeHandler(DB.getPath(node, ".numberattacks"), "onUpdate", onCombatStatsChanged);
  DB.removeHandler(DB.getPath(node, ".size"), "onUpdate", onCombatStatsChanged);
  DB.removeHandler(DB.getPath(node, ".specialDefense"), "onUpdate", onCombatStatsChanged);
  DB.removeHandler(DB.getPath(node, ".specialAttacks"), "onUpdate", onCombatStatsChanged);
end


function onCombatStatsChanged()
	local nodeCT = window.getDatabaseNode();
  local bisPC = (CombatManagerADND.isCTNodePC(nodeCT));
  
  local aStatsList = {
    {'ac','AC'},
    {'thaco','THACO'},
    {'speed','MV'},
    {'size','SIZE'},
    {'hitDice','HD'},
    {'morale','MORALE'},
    {'alignment','AL'},
    {'numberattacks','#ATK'},
    {'specialDefense','SD'},
    {'specialAttacks','SA'},
  };
  
  local aCombatStats = {};
  for _, sEntry in ipairs(aStatsList) do
    local sTag = sEntry[1]
    local sName = sEntry[2];
    local sValue = DB.getValue(nodeCT,sTag);
    if sValue and sValue ~= "" then
      table.insert(aCombatStats, sName .. ":" .. sValue);
    end
  end
  
  -- insert class/level lists for PCs
  if bisPC then
    local nodeChar = CombatManagerADND.getNodeFromCT(nodeCT);
    local sClassString = "";
    for _,nodeClass in pairs(DB.getChildren(nodeChar, "classes")) do
      local sName = DB.getValue(nodeClass,"name","");
      local nLevel = DB.getValue(nodeClass,"level",0);
      if (sName ~= "") then
        local sDiv = "";
        if sClassString ~= "" then
          sDiv = " / ";
        end
        sClassString = sClassString .. sDiv .. sName .. " " .. nLevel;
      end
    end
    if sClassString ~= "" then
      table.insert(aCombatStats, "Class : " .. sClassString);
    end
  end
  
  -- Set the targeting summary string and tooltip
  if #aCombatStats > 0 then
    setValue(Interface.getString("cta_combatstats_label") .. " " .. table.concat(aCombatStats, ", "));
    setTooltipText(table.concat(aCombatStats, "\r"));
  else
    setValue(nil);
    setTooltipText(nil);
  end
  
  -- Update visibility
  if #aCombatStats == 0 then
    setVisible(false);
  else
    setVisible(true);
  end
end

