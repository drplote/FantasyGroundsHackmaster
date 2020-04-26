-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  if User.isHost() then
    registerMenuItem(Interface.getString("menu_init"), "turn", 7);
    registerMenuItem(Interface.getString("menu_initall"), "shuffle", 7, 8);
    registerMenuItem(Interface.getString("menu_initnpc"), "mask", 7, 7);
    registerMenuItem(Interface.getString("menu_initpc"), "portrait", 7, 6);
    registerMenuItem(Interface.getString("menu_initclear"), "pointer_circle", 7, 4);

    registerMenuItem(Interface.getString("menu_rest"), "lockvisibilityon", 8);
    registerMenuItem(Interface.getString("menu_restshort"), "pointer_cone", 8, 8);
    registerMenuItem(Interface.getString("menu_restlong"), "pointer_circle", 8, 6);

    registerMenuItem(Interface.getString("ct_menu_itemdelete"), "delete", 3);
    registerMenuItem(Interface.getString("ct_menu_itemdeletenonfriendly"), "delete", 3, 1);
    registerMenuItem(Interface.getString("ct_menu_itemdeletefoe"), "delete", 3, 3);

    registerMenuItem(Interface.getString("ct_menu_effectdelete"), "hand", 5);
    registerMenuItem(Interface.getString("ct_menu_effectdeleteall"), "pointer_circle", 5, 7);
    registerMenuItem(Interface.getString("ct_menu_effectdeleteexpiring"), "pointer_cone", 5, 5);
  end
end

function onClickDown(button, x, y)
  return true;
end

function onClickRelease(button, x, y)
  if button == 1 then
    Interface.openRadialMenu();
    return true;
  end
end

function onMenuSelection(selection, subselection, subsubselection)
--Debug.console("cta_menu.lua","onMenuSelection","selection",selection);     
--Debug.console("cta_menu.lua","onMenuSelection","subselection",subselection);     
--Debug.console("cta_menu.lua","onMenuSelection","subsubselection",subsubselection);     

  if User.isHost() then
    if selection == 7 then
      if subselection == 4 then
        CombatManager.resetInit();
      elseif subselection == 8 then
        CombatManagerADND.PC_LASTINIT = 0;
        CombatManager2.rollInit();
      elseif subselection == 7 then
        CombatManager2.rollInit("npc");
      elseif subselection == 6 then
        CombatManagerADND.PC_LASTINIT = 0;
        CombatManager2.rollInit("pc");
      end
    end
    if selection == 8 then
      if subselection == 8 then
        ChatManager.Message(Interface.getString("ct_message_rest"), true);
        CombatManager2.rest(false);
      elseif subselection == 6 then
        ChatManager.Message(Interface.getString("ct_message_restlong"), true);
        CombatManager2.rest(true);
      end
    end
    if selection == 5 then
      if subselection == 7 then
        CombatManager.resetCombatantEffects();
      elseif subselection == 5 then
        CombatManager2.clearExpiringEffects();
      end
    end
    if selection == 3 then
      if subselection == 1 then
        clearNPCs(true,true);
      elseif subselection == 3 then
        clearNPCs(false,true);
      end
    end
  end
end

function clearNPCs(bNonFriendly,bFoes)
  for _, vChild in pairs(window.combatants.subwindow.list.getWindows()) do
--Debug.console("cta_menu.lua","clearNPCs","vChild",window);     
    local nodeCT = vChild.getDatabaseNode();
    local sFaction = DB.getValue(nodeCT,"friendfoe","");
    if (bNonFriendly and sFaction ~= "friend") or (bFoes and sFaction == "foe") then      
      nodeCT.delete();  
    end
  end
end
