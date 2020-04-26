-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
 --Debug.console("item_import.lua","onInit","getDatabaseNode",getDatabaseNode());
end

function createBlankNode(sRecordType)
    local node = DB.createChild(sRecordType); 
--Debug.console("item_import_adnd.lua","createBlankNode","node",node);    

  if node then
    local w = Interface.openWindow(sRecordType, node.getNodeName());
    if w and w.header and w.header.subwindow and w.header.subwindow.name then
      w.header.subwindow.name.setFocus();
    end
  end
    return node;
end


function processImportText()
  local sText = importtext.getValue() or "";
  local sDefaultType = parentcontrol.window.import_item_type_defaults_contents.subwindow.type.getValue() or "";
  local sDefaultSubType = parentcontrol.window.import_item_type_defaults_contents.subwindow.subtype.getValue() or "";
  local sDefaultRarity = parentcontrol.window.import_item_type_defaults_contents.subwindow.rarity.getValue() or "";
Debug.console("item_import_adnd.lua","processImportText","sDefaultType",sDefaultType);    
Debug.console("item_import_adnd.lua","processImportText","sDefaultSubType",sDefaultSubType);    
Debug.console("item_import_adnd.lua","processImportText","sDefaultRarity",sDefaultRarity);    
  
  if (sText ~= "") then
    -- if sText:match("\t") then
-- Debug.console("item_import_adnd.lua","processImportText","Has TABS! sText",sText);    
    -- else 
-- Debug.console("item_import_adnd.lua","processImportText","NOOOOO TABS! sText",sText);        
    -- end
    local aItemText = {};
    for sLine in string.gmatch(sText, '([^\r\n]+)') do
      table.insert(aItemText, sLine);
    end

    for _,sLine in ipairs(aItemText) do
Debug.console("item_import_adnd.lua","processImportText","sLine",sLine);    
      local aItemValues = UtilityManagerADND.split(sLine,"%s%s+");
Debug.console("item_import_adnd.lua","processImportText","aItemValues",aItemValues);   
      local sItemName = aItemValues[1];
      local sItemCost = aItemValues[2];
      local sItemWeight = aItemValues[3];
      
Debug.console("item_import_adnd.lua","processImportText","sItemName",sItemName);   
Debug.console("item_import_adnd.lua","processImportText","sItemCost",sItemCost);   
Debug.console("item_import_adnd.lua","processImportText","sItemWeight",sItemWeight);   
      if (sItemName) then
        local node = createBlankNode('item');
        DB.setValue(node,"name","string",sItemName);
        DB.setValue(node,"type","string",sDefaultType);
        DB.setValue(node,"subtype","string",sDefaultSubType);
        DB.setValue(node,"rarity","string",sDefaultRarity);
        
        if sItemCost then
          DB.setValue(node,"cost","string",sItemCost);
        end
        if sItemWeight then
          local sWeight = sItemWeight:match("%d+");
          local nWeight = tonumber(sWeight) or 0;
          DB.setValue(node,"weight","number",nWeight);
        end
      end
    end
  end
end
