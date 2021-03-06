-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
--Debug.console("npc_import.lua","onInit","getDatabaseNode",getDatabaseNode());
end


function processImportText()
    local sText = importtext.getValue() or "";
    if (sText ~= "") then
      local aNPCText = {};
      local sTextClean = sText:gsub("[\r\n]+"," "); -- remove all new lines
      sTextClean = sTextClean:gsub("  "," "); -- remove all double spaces
      --sTextClean = sTextClean:gsub("^([^:]+)([:]+)","%1%2;",1); -- make sure "Name:" has ";" after it. cause it's random
Debug.console("npc_statblock_import.lua","processImportText","sTextClean",sTextClean);                
      for sLine in string.gmatch(sTextClean, '([^;]+)') do
        local sCleanLine = StringManager.trim(sLine);
        table.insert(aNPCText, sCleanLine);
      end
      local nodeNPC = ManagerImportADND.createBlankNPC();

      -- find the first value in the text line and take it's value
      -- and put it in the second value of the nodeNPC
      local text_matches = {
                        {"^sz ","size"},
                        {"^mv ","speed"},
                        {"^move ","speed"},
                        {"^ac ","actext"},
                        {"^level ","hitDice","([%d%-+]+)"},
                        {"^hd ","hitDice","([%d%-+]+)"},
                        {"^level ","hdtext"},
                        {"^hd ","hdtext"},
                        {"^#at ","numberattacks"},
                        {"^dmg ","damage"},
                        {"^d ","damage"},
                        {"^sa ","specialAttacks"},
                        {"^sd ","specialDefense"},
                        {"^mr ","magicresistance"},
                        {"^int ","intelligence_text"},
                        {"^al ","alignment"},
                        {"^alignment ","alignment"},
                        {"^morale ","morale"},
                        {"^ml ","morale"},
                        };
      local number_matches = {
                        {"thaco ","thaco"},
                        {"thac0 ","thaco"},
                        -- {"^exp ","xp","(%d+)"},
                        -- {"^xpv ","xp","(%d+)"},
                        -- {"^xp ","xp","(%d+)"},
                        {"^hp ","hp","(%d+)"},
                        };
      local sDescription = "";
      local sParagraph = "";
      local sName = sTextClean:match("^([^:;]+)");
Debug.console("npc_statblock_import.lua","processImportText","sName",sName);          
      for _,sLine in ipairs(aNPCText) do
Debug.console("npc_statblock_import.lua","processImportText","sLine",sLine);    
        -- each line is flipped through
        local bProcessed = false;
        
        -- get text values
        for _, sFind in ipairs(text_matches) do
          local sMatch = sFind[1];
          local sValue = sFind[2];
          local sFilter = sFind[3];
          if (string.match(sLine:lower(),sMatch)) then
            bProcessed = true;
            ManagerImportADND.setTextValue(nodeNPC,sLine,sMatch,sValue,sFilter);
          end
        end
        -- get number values
        for _, sFind in ipairs(number_matches) do
          local sMatch = sFind[1];
          local sValue = sFind[2];
          local sFilter = sFind[3];
          if (string.match(sLine:lower(),sMatch)) then
            bProcessed = true;
            ManagerImportADND.setNumberValue(nodeNPC,sLine,sMatch,sValue,sFilter);
          end
        end
        
        sLine = ManagerImportADND.kludgeForSaveVersusWithPeriods(sLine);
        
        if not bProcessed and string.match(sLine:lower(),"xp.? (.*)$") then
          local sEXP = string.match(sLine:lower(),"xp.? (.*)$");
          sEXP = string.match(sEXP,"([%d,]+)");
Debug.console("npc_statblock_import.lua","processImportText","sEXP1",sEXP);              
          sEXP = sEXP:gsub("[,]+","");
Debug.console("npc_statblock_import.lua","processImportText","sEXP2",sEXP);              
          local nEXP = tonumber(sEXP) or 0;
Debug.console("npc_statblock_import.lua","processImportText","nEXP",nEXP);              
          DB.setValue(nodeNPC,"xp","number",nEXP);
          bProcessed = true;
        end
      end -- for sLine
      
      ManagerImportADND.setName(nodeNPC,sName)
      ManagerImportADND.setDescription(nodeNPC,sTextClean,"text");
      --getClassLevelAsHD(nodeNPC,sTextClean);
      ManagerImportADND.setHD(nodeNPC);
      ManagerImportADND.setAC(nodeNPC);
      ManagerImportADND.setActionWeapon(nodeNPC,true);
      ManagerImportADND.setSomeDefaults(nodeNPC);
      
      setAbilityScores(nodeNPC,sTextClean);
      importSpells(nodeNPC,sTextClean);
    end -- if sText
end

function getClassLevelAsHD(nodeNPC,sText)
  local sLevel, sClass = string.match(sText:lower(),"level (%d+) ([%w]+)");
  
  if (not sLevel or not sClass) then
    sClass, sLevel = string.match(sText:lower(),"([%w]+) l(%d+)");
  end
  
  if (sLevel) then
    DB.setValue(nodeNPC,"hitdice","string", sLevel);
  end
Debug.console("npc_statblock_import.lua","getClassLevelAsHD","sLevel",sLevel);      
Debug.console("npc_statblock_import.lua","getClassLevelAsHD","sClass",sClass);      
end

--S 18 I 17 W 18 D 17 C 16 Ch 18
-- or 
--S 18, I 17, W 18, D 17, C 16, Ch 18
function setAbilityScores(nodeNPC,sText)
  local sAbilityScores = string.match(sText:lower(),"([%w]+ %d+[,]? [%w]+ %d+[,]? [%w]+ %d+[,]? [%w]+ %d+[,]? [%w]+ %d+[,]? [%w]+ %d+)");
  if (sAbilityScores) then
Debug.console("---->>npc_statblock_import.lua","setAbilityScores","sAbilityScores",sAbilityScores);       
    local sStrength     = sAbilityScores:match("str (%d+)") or sAbilityScores:match("[^i]?s (%d+)");
    local sIntelligence = sAbilityScores:match("i (%d+)") or sAbilityScores:match("int (%d+)");
    local sWisdom       = sAbilityScores:match("w (%d+)") or sAbilityScores:match("wis (%d+)");
    local sDexterity    = sAbilityScores:match("d (%d+)") or sAbilityScores:match("dex (%d+)");
    local sConstitution = sAbilityScores:match("c (%d+)") or sAbilityScores:match("con (%d+)") or sAbilityScores:match("co (%d+)");
    local sCharisma     = sAbilityScores:match("ch (%d+)") or sAbilityScores:match("cha (%d+)") or sAbilityScores:match("chr (%d+)");
    local nStr = tonumber(sStrength) or 9;
    local nInt = tonumber(sIntelligence) or 9;
    local nWis = tonumber(sWisdom) or 9;
    local nDex = tonumber(sDexterity) or 9;
    local nCon = tonumber(sConstitution) or 9;
    local nCha = tonumber(sCharisma) or 9;
    
    DB.setValue(nodeNPC,"abilities.strength.base","number",nStr);
    DB.setValue(nodeNPC,"abilities.strength.score","number",nStr);
    DB.setValue(nodeNPC,"abilities.intelligence.base","number",nInt);
    DB.setValue(nodeNPC,"abilities.intelligence.score","number",nInt);
    DB.setValue(nodeNPC,"abilities.wisdom.base","number",nWis);
    DB.setValue(nodeNPC,"abilities.wisdom.score","number",nWis);
    DB.setValue(nodeNPC,"abilities.dexterity.base","number",nDex);
    DB.setValue(nodeNPC,"abilities.dexterity.score","number",nDex);
    DB.setValue(nodeNPC,"abilities.constitution.base","number",nCon);
    DB.setValue(nodeNPC,"abilities.constitution.score","number",nCon);
    DB.setValue(nodeNPC,"abilities.charisma.base","number",nCha);
    DB.setValue(nodeNPC,"abilities.charisma.score","number",nCha);
  else
    -- sometimes they just show strength in the stat block
    local sStrength     = string.match(sText:lower(),"strength (%d+)");
    local nStr = tonumber(sStrength) or 0;
    if (nStr > 0) then
      DB.setValue(nodeNPC,"abilities.strength.base","number",nStr);
      DB.setValue(nodeNPC,"abilities.strength.score","number",nStr);
    end
  end
end

--
-- This will try and find all spells within the stat block and add them to the NPC
--
local sSpellFilter = "['’,%w%d%s%-%(%)]+";
local aLevelsAsName = { "first","second","third","fourth","fifth","sixth","seventh","eighth","ninth"};
function importSpells(nodeNPC,sText)
  local sTextLower = sText:lower();
  local bPriest = (sTextLower:match("cleric") or sTextLower:match("priest") or sTextLower:match("druid"));
  local bWizard = (sTextLower:match("mage") or sTextLower:match("wizard") or sTextLower:match("magic-user") or sTextLower:match("illusionist"));
  local sType = "arcane"; -- default to arcane
  if bPriest and not bWizard then
    sType = "divine";
  elseif bWizard and bPriest then
    sType = nil; -- we just look for both
  end
Debug.console("npc_statblock_import.lua","importSpells","nodeNPC",nodeNPC);    
Debug.console("npc_statblock_import.lua","importSpells","sTextLower",sTextLower);  
  local spells = {};
  -- 'spells memorized: first level: command, cure light wounds (x2), remove fear, sanctuary second level: hold person (x2), resist fire, silence 15' radius, slow poison third level: dispel magic, prayer, bestow curse fourth level: cure serious wounds'
  -- or 
  -- 'spells memorized: level 1: detect magic, magic missile (x2), unseen servant level 2: detect invisibility, invisibility, web level 3: dispel magic, haste, lightning bolt level 4: charm monster, polymorph self level 5: teleport '
  for i=1,9,1 do
    spells[i] = sTextLower:match(aLevelsAsName[i] .. " level: (".. sSpellFilter .. ") %w+ level:") 
             or sTextLower:match(aLevelsAsName[i] .. " level: (".. sSpellFilter .. ")")
             or sTextLower:match("level " .. i .. ": (".. sSpellFilter .. ") level %d+:")
             or sTextLower:match("level " .. i .. ": (".. sSpellFilter .. ")");
Debug.console("npc_statblock_import.lua","importSpells","spells[i]",spells[i]);                 
  end
  if #spells > 0 then
    for i=1,9,1 do
  Debug.console("npc_statblock_import.lua","importSpells","spells[".. i .. "]",spells[i]);    
      local aSpells = StringManager.split(spells[i],",",true);
  Debug.console("npc_statblock_import.lua","importSpells","aSpells",aSpells);        
      for _, sSpell in pairs(aSpells) do
        sSpell = sSpell:gsub("(%(.?%d+%))",""); -- remove (x2) from spell names
        sSpell = StringManager.trim(sSpell); -- clean up spaces
  Debug.console("npc_statblock_import.lua","importSpells","sSpell",sSpell);
        local nodeSpell = findSpell(sSpell,sType);
        if (nodeSpell) then
          addSpell(nodeNPC,nodeSpell)
        else
          ChatManager.SystemMessage("STATBLOCK IMPORT-1: Could not find spell [" .. sSpell .. "] in spell records to add to NPC.");
        end

      end -- aSpells
    end -- 1..9th level spells
  else -- found spells by level
    -- found no spells as above, trying a broader spectrum
    -- just doing blanket search "Spells *: list,of,spells,here"
    local sSpellsList = sTextLower:match("spells[%w%p%s]+:(".. sSpellFilter .. ")");
Debug.console("npc_statblock_import.lua","importSpells","sSpellsList",sSpellsList);
    local aSpells = StringManager.split(sSpellsList,",",true);
    for _, sSpell in pairs(aSpells) do
      sSpell = sSpell:gsub("(%(.?%d+%))",""); -- remove (x2) from spell names
      sSpell = StringManager.trim(sSpell); -- clean up spaces
      local nodeSpell = findSpell(sSpell,sType);
      if (nodeSpell) then
        addSpell(nodeNPC,nodeSpell)
      else
        ChatManager.SystemMessage("STATBLOCK IMPORT-2: Could not find spell [" .. sSpell .. "] in spell records to add to NPC.");
      end    
    end
  end
  
end

function addSpell(nodeTarget,nodeSpell)
Debug.console("npc_statblock_import.lua","addSpell","nodeSpell",nodeSpell);   
  local nodePowers = nodeTarget.createChild("powers");
  local nodeNewPower = nodePowers.createChild();
  DB.setValue(nodeNewPower, "group", "string", "Spells");
  DB.copyNode(nodeSpell,nodeNewPower);
end

-- find spell by name (and type)
function findSpell(sSpellName,sType)
Debug.console("npc_statblock_import.lua","findSpell","sSpellName",sSpellName);   
Debug.console("npc_statblock_import.lua","findSpell","sType",sType);   
  local nodeSpell = nil;
  local vMappings = LibraryData.getMappings("spell");
  for _,sMap in ipairs(vMappings) do
    for _,node in pairs(DB.getChildrenGlobal(sMap)) do
      local sName = DB.getValue(node,"name","");
      local sSpellType = DB.getValue(node, "type", ""):lower();
      if (sType ~= nil and sType == sSpellType and sName:lower() == sSpellName) or (sType == nil and sName:lower() ==  sSpellName) then
  Debug.console("npc_statblock_import.lua","findSpell","sSpellType",sSpellType);   
        nodeSpell = node;
        break;
      end
    end -- spell
    if nodeSpell then
      break
    end
  end
  return nodeSpell;
end
