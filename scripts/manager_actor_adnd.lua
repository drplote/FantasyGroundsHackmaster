--
--
--
--
--

function onInit()
end

-- check to see if the armor worn by rActor matches sArmorCheck
function isArmorType(rActor, sArmorCheck)
    local bMatch = false;
    local sType, nodeActor = ActorManager.getTypeAndNode(rActor);
    local aCheckSplit = StringManager.split(sArmorCheck:lower(), ",", true);
    local aArmorList = ItemManager2.getArmorWorn(nodeActor);
     for _,v in ipairs(aCheckSplit) do
      -- v==armor type
       if StringManager.contains(aArmorList, v) then
        bMatch = true;
       end
    end

    return bMatch;
end
-- return any targets a Combat Tracker node currently has.
function getTargetNodes(rActor)
    local nodeCT = DB.findNode(rActor.sCTNode);
    local aTargetRefs = {};
    if (nodeCT ~= nil) then
      local nodeTargets = DB.getChildren(nodeCT,"targets");
      for _,node in pairs(nodeTargets) do
        local sNodeRef = DB.getValue(node,"noderef","");
        local nodeRef = DB.findNode(sNodeRef);
        if nodeRef ~= nil then
          table.insert(aTargetRefs,nodeRef.getPath());
        end
      end
    end -- nodeCT != nil
    return aTargetRefs;
end

-- check to see if the rActor has sClassCheck
function isClassType(rActor, sClassCheck)
    local bMatch = false;
    local sType, nodeActor = ActorManager.getTypeAndNode(rActor);
    local aCheckSplit = StringManager.split(sClassCheck:lower(), ",", true);
     for _,v in ipairs(aCheckSplit) do
      -- v==class name
       if CharManager.hasClass(nodeActor,v) then
        bMatch = true;
       end
    end

    return bMatch;
end
