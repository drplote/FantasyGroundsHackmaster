-- data library for ad&d core ruleset
--
--
--

function onInit()
  DesktopManager.showDockTitleText(true);
  DesktopManager.setDockTitleFont("sidebar");
  DesktopManager.setDockTitleFrame("", 25, 2, 25, 5);
  if Interface.getVersion() < 4 then -- fgc, 
    DesktopManager.setDockTitlePosition("top", 0, 16);
  else -- fgu
    DesktopManager.setDockTitlePosition("top", 0, 19);
  end
  DesktopManager.setStackIconSizeAndSpacing(47, 27, 3, 3, 4, 0);
  DesktopManager.setDockIconSizeAndSpacing(100, 30, 0, 4);
  DesktopManager.setLowerDockOffset(2, 0, 2, 3);

  -- we don't use either of these types of records in AD&D, so hide them
  LibraryData.setRecordTypeInfo("feat", nil);
  LibraryData.setRecordTypeInfo("vehicle", nil);
  --

  if User.isHost()  then
    Comm.registerSlashHandler("readycheck", processReadyCheck);
  end
  
  --Debug.console("data_library.adnd.lua","onInit","Interface.getVersion",Interface.getVersion());
end

function processReadyCheck(sCommand, sParams)
  if User.isHost() then
    local wWindow = Interface.openWindow("readycheck","");
    if wWindow then
      local aList = ConnectionManagerADND.getUserLoggedInList();
      -- share this window with every person connected.
      for _,name in pairs(aList) do
        wWindow.share(name);
      end
    end
  end
end
