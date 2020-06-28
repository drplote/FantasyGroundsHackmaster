---
--- Various utility functions
---
---

function onInit()
end

function onClose()
end

-- put timestamp in log output
function logDebug(...)
  --Debug.console("Time:" .. os.time(),...);
  Debug.console("Time:" .. os.clock(),...);
end

-- round the number off
function round(num)
  return math.floor(num + 0.5);
end

-- replace oldWindow with a new window of sClass type
function replaceWindow(oldWindow, sClass, sNodePath)
--Debug.console("manager_utilities_adnd.lua","replaceWindow","oldWindow",oldWindow);
  local x,y = oldWindow.getPosition();
  local w,h = oldWindow.getSize();
  -- Close here otherwise you just close the one you just made since paths are the same at times (drag/drop inline replace item/npc)
  oldWindow.close(); 
  --
  local wNew = Interface.openWindow(sClass, sNodePath);
  wNew.setPosition(x,y);
  wNew.setSize(w,h);
end 

-- check all modules loaded and local records
-- for skill with name of sSkillName 
function findSkillRecord(sSkillName)
  local nodeFound = nil;

  local vMappings = LibraryData.getMappings("skill");
  for _,sMap in ipairs(vMappings) do
    for _,nodeSkill in pairs(DB.getChildrenGlobal(sMap)) do
      local sName = DB.getValue(nodeSkill,"name");
      sName = sName:gsub("%[%d+%]",""); -- remove bracket cost 'Endurance[2]' and just get name clean.
      sName = StringManager.trim(sName);
      if (sName:lower() == sSkillName:lower()) then
        nodeFound = nodeSkill;
        break;
      end
    end
    if nodeFound then
      break
    end
  end
  return nodeFound;
end

-- check nodeChar to see if they have skill of sSKillname
-- this matches when the sSkillname appears ANYWHERE in the skill name
function hasSkill(nodeChar,sSkillName)
  local bHas = false;
  local sSkillNameLower = sSkillName:lower();
  for _,nodeChild in pairs(DB.getChildren(nodeChar, "skilllist")) do
    local sName = DB.getValue(nodeChild,"name",""):lower();
    if sName:find(sSkillNameLower) then
      bHas = true;
      break;
    end
  end

  return bHas;
end

--
-- Control+Drag/Drop story or ref-manual link, capture text and append that text
-- into the target record
--
function onDropStory(x, y, draginfo, nodeTarget, sTargetValueName)
  
  -- this is the value we're placing the text into on the target node
  if not sTargetValueName then
    sTargetValueName = 'text';
  end
  
  if not nodeTarget then
    return false;
  end
  
--Debug.console("manager_utilities_adnd.lua","onDropStory","nodeTarget",nodeTarget);
  
  if draginfo.isType("shortcut") then
    --local nodeTarget = getDatabaseNode();
    local bLocked = (DB.getValue(nodeTarget,"locked",0) == 1);
    
    -- if record not locked and control pressed
    if not bLocked and Input.isControlPressed() then
      local nodeSource = draginfo.getDatabaseNode();
      local sClass, sRecord = draginfo.getShortcutData();
--Debug.console("manager_utilities_adnd.lua","onDropStory","sClass",sClass);      
      -- if ref-manual page
      if (sClass == 'referencemanualpage') then
        local nodeRefMan = DB.findNode(sRecord);
        local sText = '';
        -- flip through blocks
        -- we need to story the blocks so we get them in the right order
        local aNodeBlocks = UtilityManager.getSortedTable(DB.getChildren(nodeRefMan, "blocks"));
        for _,nodeBlock in ipairs(aNodeBlocks) do
          local sBlockType = DB.getValue(nodeBlock,"blocktype","");
          -- if the block is text append value in it to our text
          if sBlockType == 'singletext' then
            local sBlockText = DB.getValue(nodeBlock,"text","");
            sText = sText .. sBlockText;
          end
        end
        -- grab current text in target
        local sCurrentText = DB.getValue(nodeTarget,sTargetValueName);
        -- append target current text and source text together
        if sText then
          DB.setValue(nodeTarget,sTargetValueName,"formattedtext",sCurrentText .. sText);
        end
      -- if encounter/story entry
      elseif (sClass == "encounter") then
        -- grab text from source
        local sText = DB.getValue(nodeSource,"text");
        -- grab current text in target
        local sCurrentText = DB.getValue(nodeTarget,sTargetValueName);
        -- append target current text and source text together
        if sText then
          DB.setValue(nodeTarget,sTargetValueName,"formattedtext",sCurrentText .. sText);
        end
      -- if we can find "text" value on nodeSource then proceed
      elseif DB.getValue(nodeSource,"text") then
        local sText = DB.getValue(nodeSource,"text");
        local sCurrentText = DB.getValue(nodeTarget,sTargetValueName);
        if sCurrentText then
          DB.setValue(nodeTarget,sTargetValueName,"formattedtext",sCurrentText .. sText);
        end
      -- if we can find "description" value on nodeSource then proceed
      elseif DB.getValue(nodeSource,"description") then
        local sText = DB.getValue(nodeSource,"description");
        local sCurrentText = DB.getValue(nodeTarget,sTargetValueName);
        if sCurrentText then
          DB.setValue(nodeTarget,sTargetValueName,"formattedtext",sCurrentText .. sText);
        end
      end
    end
  end
end


-- get Identity of a char node or from the CT node that is a PC
function getIdentityFromCTNode(nodeCT)
  local rActor = ActorManager.getActorFromCT(nodeCT);
  local sActorType, nodeActor = ActorManager.getTypeAndNode(rActor);    
  return getIdentityFromCharNode(nodeActor);
end
function getIdentityFromCharNode(nodeChar)
  return nodeChar.getName();
end

-- output a message simple function
function outputUserMessage(sResource, ...)
  local sFormat = Interface.getString(sResource);
  local sMsg = string.format(sFormat, ...);
  ChatManager.SystemMessage(sMsg);
end

-- output message as broadcast to all.
function outputBroadcastMessage(rActor, sResource, ...)
  local sFormat = Interface.getString(sResource);
  local sMsg = string.format(sFormat, ...);
  ChatManager.Message(sMsg, true, rActor)
end

-- (this allows me to split on 2+spaces)
function split(str, pat)
  local t = {};
  local fpat = "(.-)" .. pat;
  local last_end = 1;
  local s, e, cap = str:find(fpat, 1);
  while s do
  if s ~= 1 or cap ~= "" then
   table.insert(t,cap);
  end
    last_end = e+1;
    s, e, cap = str:find(fpat, last_end);
  end
  if last_end <= #str then
    cap = str:sub(last_end);
    table.insert(t, cap);
  end
  return t
end

-- find first item that matches this item name and return it's node.
function getItemByName(sItemName)
  local nodeItem = nil;
  local sItemNameLower = sItemName:lower();
  local vMappings = LibraryData.getMappings("item");
  for _,sMap in ipairs(vMappings) do
    for _,node in pairs(DB.getChildrenGlobal(sMap)) do
      local sName = DB.getValue(node,"name","");
      if sName:lower() == sItemNameLower then
        nodeItem = node;
        break;
      end
    end
    if nodeItem then
      break
    end
  end
  return nodeItem;
end

-- pass inventory in string format, _text is the countXname of item;countXname of item2
-- pass inventory in string format, _node is the node.getPath();node.getPath()
-- return the node for sItemToFind
---
-- <inventorylist_node type="string">npc.id-00006.inventorylist.id-00013;npc.id-00006.inventorylist.id-00024;npc.id-00006.inventorylist.id-00016;</inventorylist_node>
-- <inventorylist_text type="string">2xBackpack;10xIron Spike;14xRations, Dry, 1 day;</inventorylist_text>
function getInventoryItemFromTextList(sItemToFind, sInventoryList_Text,sInventoryList_Node)
  local nodeItem = nil;
  local nItemCount = 0;
  local sItemToFindLower = sItemToFind:lower();
  
  local aItems = StringManager.split(sInventoryList_Text,";",true);
  local aItemNodes = StringManager.split(sInventoryList_Node,";",true);
  for nID,sItemEntry in pairs(aItems) do 
    local nCount, sItemName = sItemEntry:match("(%d+)x(.*)");
    if nCount and sItemName and sItemToFindLower == sItemName:lower() then
      local nodeFoundItem = DB.findNode(sItemNodes[nID]);
      if nodeFoundItem then
        nodeItem = nodeFoundItem;
        break;
      end
    end
  end
  
  return nodeItem;
end

-- return a array of node paths that are in sTextList_Nodes of this npc
-- format is "node.getPath();node.getPath();"
function getNodeTableFromTextListInCT(nodeCT,sTextList_Nodes)
  local sTextListNodes = DB.getValue(nodeCT,sTextList_Nodes,"");
  local aNodeList = StringManager.split(sTextListNodes,";",true);
  return aNodeList;
end

-- return a array of item node paths that are in intenvory of this npc
function getItemNodeListFromNPCinCT(nodeCT)
  return getNodeTableFromTextListInCT(nodeCT,"inventorylist_node");
end


-- pass a nodeNPC node and return the "weaponlist" children as a json string to be stored into a node as one single entry.
-- Once we have it in json style text we can use it like:
-- local aWeaponList = JSON.decode(DB.getValue(nodeCT,'weaponlist_json',"");
-- DB.setValue(nodeCT,'weaponlist_json',"string",JSON.encode(aWeaponList));
function getWeaponListAsJSONText(node)
  local aWeaponsList = {};

  for sID, nodeWeapon in pairs(DB.getChildren(node,"weaponlist")) do
    local aWeapon = {};
    aWeapon.sSource = nodeWeapon.getPath();
    aWeapon.sID = sID; 
    aWeapon.sName = DB.getValue(nodeWeapon,"name","");
    aWeapon.nAttackCurrent = DB.getValue(nodeWeapon,"attackview_weapon",0);
    aWeapon.sAttackStat = DB.getValue(nodeWeapon,"attackstat","");
    aWeapon.nAttackBonus = DB.getValue(nodeWeapon,"attackbonus",0);
    aWeapon.nSpeedFactor = DB.getValue(nodeWeapon,"speedfactor",0);
    aWeapon.nType = DB.getValue(nodeWeapon,"type",0);
    aWeapon.nCarried = DB.getValue(nodeWeapon,"carried",0);
    aWeapon.nMaxAmmo = DB.getValue(nodeWeapon,"maxammo",0);
    aWeapon.nAmmo = DB.getValue(nodeWeapon,"ammo",0);
    aWeapon.nLocked = DB.getValue(nodeWeapon,"locked",1);
--    aWeapon.sShortcutClass, aWeapon.sShortcutRecord = DB.getValue(nodeWeapon,"shortcut","","");
    aWeapon.ItemNoteLocked = DB.getValue(nodeWeapon,"itemnote.locked",1);
    aWeapon.ItemNoteName = DB.getValue(nodeWeapon,"itemnote.name","");
    aWeapon.ItemNoteText = DB.getValue(nodeWeapon,"itemnote.text","");
    aWeapon.aDamageList = {};
    for sDMGid, nodeDamage in pairs(DB.getChildren(nodeWeapon,"damagelist")) do
      local aDamage = {};
      aDamage.sID = sDMGid;
      aDamage.sDamageAsString = DB.getValue(nodeDamage,"damageasstring","");
      aDamage.nBonus = DB.getValue(nodeDamage,"bonus",0);
      aDamage.dDice = DB.getValue(nodeDamage,"dice","");
      aDamage.sStat = DB.getValue(nodeDamage,"stat","");
      aDamage.sType = DB.getValue(nodeDamage,"type","");      
      table.insert(aWeapon.aDamageList,aDamage);
    end

    -- sort damage by id so they appear as they do in weapons tab right now
    local sort_byID = function( a,b ) return a.sID < b.sID end
    table.sort(aWeapon.aDamageList, sort_byID);

    -- add this weapon to weaponslist
    table.insert(aWeaponsList,aWeapon);

    -- Sort the weapons by name like they appear in list currently
    local sort_byName = function( a,b ) return a.sName < b.sName end
    table.sort(aWeaponsList, sort_byName);
  end

  local sJson = JSON.encode(aWeaponsList);
  
  return sJson;  
end

-- this is to replace a string value at a specific location
-- why the heck doesn't lua have this natively? -- celestian
function replaceStringAt(sOriginal,sReplacement,nStart,nEnd)
  local sFinal = nil;
  if (nStart == 1) then
    sFinal = sReplacement .. sOriginal:sub(nEnd+1,sOriginal:len());
  else
    sFinal = sOriginal:sub(1,nStart-1) .. sReplacement .. sOriginal:sub(nEnd+1,sOriginal:len());
  end
  return sFinal;
end

-- find a weapon, by name, and return it as node
function getWeaponNodeByName(sWeapon)
  local nodeWeapon = nil;
--Debug.console("manager_utilities_adnd.lua","getWeaponNodeByName","sWeapon",sWeapon);  
  local vMappings = LibraryData.getMappings("item");
  for _,sMap in ipairs(vMappings) do
    for _,nodeItem in pairs(DB.getChildrenGlobal(sMap)) do
      local sItemName = DB.getValue(nodeItem,"name");
      if sItemName:lower() == sWeapon:lower() then 
        if ItemManager2.isWeapon(nodeItem) then
          nodeWeapon = nodeItem;
          break;
        end
      end
    end
    if nodeWeapon then
      break;
    end
  end
  return nodeWeapon;
end

-- check to see if the node has a weapon of same name
function hasWeaponNamed(nodeEntry,sWeapon)
  local bHasWeapon = false;
  for _, nodeWeapon in pairs(DB.getChildren(nodeEntry,"weaponlist")) do
    local sName = DB.getValue(nodeWeapon,"name"):lower();
    if sWeapon == sName then
      bHasWeapon = true;
      return bHasWeapon;
    end
  end
  
  return bHasWeapon;
end

-- strip out formattedtext from a string
function stripFormattedText(sText)
  local sTextOnly = sText;
  sTextOnly = sTextOnly:gsub("</p>","\n");
  sTextOnly = sTextOnly:gsub("<.?[ubiphUBIPH]>","");
  sTextOnly = sTextOnly:gsub("<.?table>","");
  sTextOnly = sTextOnly:gsub("<.?frame>","");
  sTextOnly = sTextOnly:gsub("<.?t.?>","");
  sTextOnly = sTextOnly:gsub("<.?list>","");
  sTextOnly = sTextOnly:gsub("<.?li>","");
  return sTextOnly;  
end

-- return only the alpha characters from sText
function alphaOnly(sText)
  return sText:gsub("[^a-zA-Z]+","");
end

-- find if the "set" array contains "item" string.
-- uses find within the string, not exact match
function containsAny(set, item)
	for i = 1, #set do
		if set[i]:find(item) then
			return true;
		end
	end
	return false;
end

function containsExact(set, item)
	for i = 1, #set do
		if set[i] == item then
			return true;
		end
	end
	return false;
end

function intersects(compareSet, actualSet)
	for i = 1, #actualSet do
		if containsExact(compareSet, actualSet[i]) then
			return true;
		end
	end
	return false
end

-- Are we running under FGU?
function isFGU()
  return (Interface.getVersion() >= 4);
end

-- clean up entries 
function sanitizeTraitText(s)
  local sSanitized = StringManager.trim(s:gsub("%s%(.*%)$", ""));
  sSanitized = sSanitized:gsub("[.,-():'’/?+–]", "_"):gsub("%s", ""):lower();
  return sSanitized
end

function toCSV (tt)
    if not (tt) then return ""; end
    local s = ""
    for _,p in ipairs(tt) do  
    s = s .. "," .. escapeCSV(p)
    end
    return string.sub(s, 2)      -- remove first comma
end

function addIfUnique(set, item)
    if not containsExact(set, item) then
        table.insert(set, item);
    end
end

function escapeCSV (s)
  if string.find(s, '[,"]') then
    s = '"' .. string.gsub(s, '"', '""') .. '"'
  end
  return s
end