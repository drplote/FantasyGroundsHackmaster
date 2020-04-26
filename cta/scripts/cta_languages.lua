-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
--Debug.console("cta_languages.lua","onInit","window",window);  
  local node = window.getDatabaseNode();
  if node then
    DB.addHandler(DB.getPath(node, "languagelist"), "onChildUpdate", update);
    update();
  end
end

function onClose()
  local node = window.getDatabaseNode();
  if node then
    DB.removeHandler(DB.getPath(node, "languagelist"), "onChildUpdate", update);
  end
end

-- build alphabetical string list of the languages 
function update()
  local node = window.getDatabaseNode();
  if node then
    local sLanguages = "";
    local aLanguages = {};
    for _,nodeLanguage in pairs(DB.getChildren(node, "languagelist")) do
      local sName = DB.getValue(nodeLanguage,"name","");
      table.insert(aLanguages,sName);
    end
    table.sort(aLanguages);
    for nCount,sName in ipairs(aLanguages) do
      local sSep = ", ";
      if nCount >= #aLanguages then
        sSep = "";
      end
      sLanguages = sLanguages .. sName .. sSep;
    end
    if sLanguages ~= "" then
      setVisible(true);
      setValue("Languages: " .. sLanguages);
    else
     setVisible(false);
     setValue("");
    end
  end
end
