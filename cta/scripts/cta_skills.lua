-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--
function onInit()
  local node = window.getDatabaseNode();
  if node then
    DB.addHandler(DB.getPath(node, "skilllist"), "onChildAdded", update);
    DB.addHandler(DB.getPath(node, "skilllist"), "onChildDeleted", update);
  end
  update();
end

function onClose()
  local node = window.getDatabaseNode();
  if node then
    DB.removeHandler(DB.getPath(node, "skilllist"), "onChildAdded", update);
    DB.removeHandler(DB.getPath(node, "skilllist"), "onChildDeleted", update);
  end
end

-- hide the skills subwindow and it's label if there are not skills
function update()
  local node = window.getDatabaseNode();
--Debug.console("cta_skills.lua","update","node",node);  
  local bShow = false;
  if node then
    local nCount = DB.getChildCount(node,"skilllist");
    if nCount > 0 then
      bShow = true;
    end
  end
  setVisible(bShow);
  window.skills_label.setVisible(bShow);
end
