-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function isArmor(vRecord)
--Debug.console("manager_item2.lua","isArmor","vRecord",vRecord);  
  local bIsArmor = false;

  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
  local sSubtypeLower = StringManager.trim(DB.getValue(nodeItem, "subtype", "")):lower();

  if StringManager.contains(DataCommonADND.itemArmorTypes, sTypeLower) then
    bIsArmor = true;
  end
  if StringManager.contains(DataCommonADND.itemArmorTypes, sSubtypeLower) then
    bIsArmor = true;
  end
  if isShield(vRecord) then
    bIsArmor = true;
  end
  if isProtectionOther(vRecord) then
    bIsArmor = true;
  end
  return bIsArmor, sTypeLower, sSubtypeLower;
end

function isShield(vRecord)
  local bIsArmor = false;

  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
  local sSubtypeLower = StringManager.trim(DB.getValue(nodeItem, "subtype", "")):lower();
  if StringManager.contains(DataCommonADND.itemShieldArmorTypes, sTypeLower) then
    bIsArmor = true;
  end
  if StringManager.contains(DataCommonADND.itemShieldArmorTypes, sSubtypeLower) then
    bIsArmor = true;
  end
  return bIsArmor, sTypeLower, sSubtypeLower;
end


function isProtectionOther(vRecord)
  local bIsArmor = false;

  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
  local sSubtypeLower = StringManager.trim(DB.getValue(nodeItem, "subtype", "")):lower();

  if StringManager.contains(DataCommonADND.itemOtherArmorTypes, sTypeLower) then
    bIsArmor = true;
  end
  if StringManager.contains(DataCommonADND.itemOtherArmorTypes, sSubtypeLower) then
    bIsArmor = true;
  end
  return bIsArmor, sTypeLower, sSubtypeLower;
end

function isWeapon(vRecord)
  local bIsWeapon = false;

  local nodeItem;
  if type(vRecord) == "string" then
    nodeItem = DB.findNode(vRecord);
  elseif type(vRecord) == "databasenode" then
    nodeItem = vRecord;
  end
  if not nodeItem then
    return false, "", "";
  end
  
  local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
  local sSubtypeLower = StringManager.trim(DB.getValue(nodeItem, "subtype", "")):lower();

  if (sTypeLower == "weapon") or (sSubtypeLower == "weapon") then
    bIsWeapon = true;
  end
  if sSubtypeLower == "ammunition" then
    bIsWeapon = false;
  end
  
  -- if it has objects in weaponlist node then it's a weapon
  if DB.getChildCount(nodeItem, "weaponlist") > 0 then
    bIsWeapon = true;
  end
  
  return bIsWeapon, sTypeLower, sSubtypeLower;
end

function isRefBaseItemClass(sClass)
	return StringManager.contains({"reference_armor", "reference_weapon", "reference_equipment", "reference_mountsandotheranimals", "reference_waterbornevehicles", "reference_vehicle"}, sClass);
end

function addItemToList2(sClass, nodeSource, nodeTarget, nodeTargetList)
--Debug.console("manager_item2.lua","addItemToList2","sClass",sClass);
  if LibraryData.isRecordDisplayClass("item", sClass) then
    --if sClass == "reference_equipment" and DB.getChildCount(nodeSource, "subitems") > 0 then
    if DB.getChildCount(nodeSource, "subitems") > 0 then
      local bFound = false;
      for _,v in pairs(DB.getChildren(nodeSource, "subitems")) do
        local sSubClass, sSubRecord = DB.getValue(v, "link", "", "");
        local nSubCount = DB.getValue(v, "count", 1);
        if LibraryData.isRecordDisplayClass("item", sSubClass) then
          local nodeNew = ItemManager.addItemToList(nodeTargetList, sSubClass, sSubRecord);
          if nodeNew then
            bFound = true;
            if nSubCount > 1 then
              DB.setValue(nodeNew, "count", "number", DB.getValue(nodeNew, "count", 1) + nSubCount - 1);
            end
          end
        end
      end
      if bFound then
        return false;
      end
    end
    
    DB.copyNode(nodeSource, nodeTarget);
    DB.setValue(nodeTarget, "locked", "number", 1);

    -- Set the identified field
    if ((sClass == "reference_magicitem") and (not User.isLocal())) then
      DB.setValue(nodeTarget, "isidentified", "number", 0);
    else
      DB.setValue(nodeTarget, "isidentified", "number", 1);
    end
      
    return true;
  end

  return false;
end

-- check to see if the armor worn by nodeChar is magic
function isWearingMagicArmor(nodeChar)
  local bMagic = false;
  for _,nodeItem in pairs(DB.getChildren(nodeChar, "inventorylist")) do
    if DB.getValue(nodeItem, "carried", 0) == 2 then
      local sTypeLower = StringManager.trim(DB.getValue(nodeItem, "type", "")):lower();
      local sSubtypeLower = StringManager.trim(DB.getValue(nodeItem, "subtype", "")):lower();
      local bIsArmor, _, _ = ItemManager2.isArmor(nodeItem);
      if bIsArmor and isItemAnyType("magic",sTypeLower,sSubtypeLower) then
        bMagic = true;
        break;
      end
    end
  end
  return bMagic;
end
-- check to see if the armor worn by nodeChar matches sArmorCheck="plate,chain,leather"
function isWearingArmorNamed(nodeChar, aArmorTypeList)
    local bMatch = false;
    local aArmorList = getArmorWorn(nodeChar);
     for _,sType in ipairs(aArmorTypeList) do
       if StringManager.contains(aArmorList, sType) then
        bMatch = true;
       end
    end

    return bMatch;
end

-- check to see if a shield is equipped
function isWearingShield(nodeChar)
  local bShield = false;
  for _,nodeItem in pairs(DB.getChildren(nodeChar, "inventorylist")) do
    if DB.getValue(nodeItem, "carried", 0) == 2 then
      local bIsShield, _, _ = ItemManager2.isShield(nodeItem);
      if bIsShield then
        bShield = true;
        break;
      end
    end
  end
  return bShield;
end

-- get a list of all the armor worn by this node
function getArmorWorn(nodeChar)
  local aArmorList = {};
  for _,vNode in pairs(DB.getChildren(nodeChar, "inventorylist")) do
    if DB.getValue(vNode, "carried", 0) == 2 then
      local bIsArmor, _, sSubtypeLower = ItemManager2.isArmor(vNode);
      if bIsArmor then
        local sName = DB.getValue(vNode,"name",""):lower();
        table.insert(aArmorList, sName);    
      end
    end
  end

  -- we scan the inventorylist_node list of nodes on the source NPC for armor/equipped items.
  local aItemNodes = UtilityManagerADND.getItemNodeListFromNPCinCT(nodeChar);
  for _,sItemNode in pairs(aItemNodes) do 
    -- this is on the NPC source record if it exists and where we look. It wont exist on the npc entry in the CT
    local nodeCheck = DB.findNode(sItemNode);
    if nodeCheck then
      local bIsArmor, _, sSubtypeLower = ItemManager2.isArmor(nodeCheck);
      if bIsArmor then
        local sName = DB.getValue(nodeCheck,"name",""):lower();
        table.insert(aArmorList, sName);    
      end
    end
  end
  --
  return aArmorList;
end

-- get a list of all the items equipped worn by this node
function getItemsEquipped(nodeChar)
  local aItemsEquipped = {};
  for _,vNode in pairs(DB.getChildren(nodeChar, "inventorylist")) do
    if DB.getValue(vNode, "carried", 0) == 2 then
      local sName = DB.getValue(vNode,"name",""):lower();
      table.insert(aItemsEquipped, sName);    
    end
  end
  --
  return aItemsEquipped;
end

function isItemType(sCheckType,sType)
  return (sType == sCheckType);
end

function isItemSubType(sCheckType,sSubType)
  return (sSubType == sCheckType);
end

function isItemAnyType(sCheckType,sType,sSubType)
  return (sType == sCheckType or sSubType == sCheckType);
end

function getItemNameForPlayer(nodeItem)
	local bIsIdentified = DB.getValue(nodeItem, "isidentified", 1) == 1;
	local sDisplayName = DB.getValue(nodeItem, "name");
	if not bIsIdentified then
		local sNonIdName = DB.getValue(nodeItem, "nonid_name");
		if sNonIdName and sNonIdName ~= "" then
			sDisplayName = sNonIdName;
		end
	end
	return sDisplayName;
end

function getPcShieldWorn(nodeChar)
	-- Possible problem: If the character has more than one shield worn, this is only going to return the first it finds
	for _,vNode in pairs(DB.getChildren(nodeChar, "inventorylist")) do
		local sDamageSteps = DB.getValue(vNode, "damageSteps", "");
		if DB.getValue(vNode, "carried", 0) == 2 and ItemManager2.isShield(vNode) and sDamageSteps and sDamageSteps ~= "" then
			return vNode;
		end
	end
	return nil;
end

function getPcArmorWorn(nodeChar)
	-- Possible problem: If the character has more than one armor worn, this is only going to return the first it finds
	for _,vNode in pairs(DB.getChildren(nodeChar, "inventorylist")) do
		local sDamageSteps = DB.getValue(vNode, "damageSteps", "");
		if DB.getValue(vNode, "carried", 0) == 2 and ItemManager2.isArmor(vNode) and not ItemManager2.isShield(vNode) and sDamageSteps and sDamageSteps ~= "" then
			return vNode;
		end
	end
	return nil;
end

function getAcLossFromItemDamage(nodeItem)
	local nHpLost = DB.getValue(nodeItem, "hplost", 0);
	local nAcLost = 0;
	local aDamageSteps = getDamageStepsArray(nodeItem);
	
	if nHpLost > 0 and #aDamageSteps > 0 then
		for _, nStep in ipairs(aDamageSteps) do 
			nHpLost = nHpLost - nStep;
			if nHpLost >= 0 then
				nAcLost = nAcLost + 1;
			end
		end
	end
	return nAcLost;
end

function getDamageStepsArray(nodeItem)
	local aDamageSteps = {};
	local sDamageSteps = DB.getValue(nodeItem, "damageSteps", "");
	Debug.console("sDamageSteps", sDamageSteps);
	
	if sDamageSteps and sDamageSteps ~= "" then	
		for sStep in sDamageSteps:gmatch("([^,]+)") do
			table.insert(aDamageSteps, tonumber(sStep))
		end
		local nBonus = DB.getValue(nodeItem, "bonus", 0);
		if nBonus > 0 then
			local nFirstStep = aDamageSteps[1];
			for i = 1, nBonus, 1 do
				table.insert(aDamageSteps, 1, nFirstStep);
			end
		end
	end
	Debug.console("aDamageSteps", aDamageSteps);
	return aDamageSteps;
end


function getMaxArmorHp(nodeItem)
	local nMaxHp = 0;
	local aDamageSteps = getDamageStepsArray(nodeItem);
	if aDamageSteps and #aDamageSteps > 0 then
		for _, nStep in ipairs(aDamageSteps) do
			nMaxHp = nMaxHp + nStep;
		end
	end
	return nMaxHp;
end

