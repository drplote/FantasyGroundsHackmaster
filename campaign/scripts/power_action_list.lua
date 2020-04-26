
-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function reset()
  for _,v in pairs(getWindows()) do
    v.getDatabaseNode().delete();
  end
end

function setOrder(node)
  if DB.getValue(node, "order", 0) == 0 then
    local aOrder = {};
    for _,v in pairs(DB.getChildren(getDatabaseNode(), "")) do
      aOrder[DB.getValue(v, "order", 0)] = true;
    end
    
    local i = 1;
    while aOrder[i] do
      i = i + 1;
    end
    
    DB.setValue(node, "order", "number", i);
  end
end

function setNewOrder(node,nTarget,nSource)
  for _,v in pairs(DB.getChildren(getDatabaseNode(), "")) do
    local nCurrent = DB.getValue(v, "order", 0);
    if v.getPath() == node.getPath() then
      DB.setValue(v, "order", "number", nTarget)
    elseif nTarget > nSource and nCurrent > nSource and nCurrent <= nTarget then
      DB.setValue(v, "order", "number", nCurrent-1)
    elseif nTarget < nSource and nCurrent >= nTarget and nCurrent < nSource then
      DB.setValue(v, "order", "number", nCurrent+1)
    end
  end
end

function onDrop(x, y, draginfo)
  if draginfo.isType("reorder") then
    local sClass, sRecord = draginfo.getShortcutData();
    if sClass == "reorder_power" and sRecord ~= "" then
      local win = getWindowAt(x,y);
      if win then
        local nodeActionTarget = win.getDatabaseNode();
        local nodeActionSource = DB.findNode(sRecord);
        -- make sure the node is within the same power, we don't allow movement
        -- between one power to another at this time
        if nodeActionTarget.getChild("...") == nodeActionSource.getChild("...") then
          if nodeActionTarget ~= nodeActionSource then
            local nOrderSource = DB.getValue(nodeActionSource,"order",0);
            local nOrderTarget = DB.getValue(nodeActionTarget,"order",0);
            setNewOrder(nodeActionSource, nOrderTarget, nOrderSource);
          end
          --DB.setValue(nodeActionSource,"order","number",nOrderTarget);
          --DB.setValue(nodeActionTarget,"order","number",nOrderSource);
        end
        return true;
      end
    end
  end
end        
        