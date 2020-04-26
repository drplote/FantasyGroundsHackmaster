-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
  self.onSizeChanged = sizeChanged;
  sizeChanged();
end

-- when the window sizes change update various settings
function sizeChanged(source)
--Debug.console("cta.lua","sizeChanged","source",source);

  -- this is so we can expand the left side as the window is stretched out but only so much
  if combatants.subwindow then
    local nX, nY = getSize();
    -- get 30% of the current screen size
    -- we use that as the window size for left
    local n30Percent = nX * 0.3;
    -- minimum size we'll go on side list
    local nMinWidth = 130;
    -- max size we'll go on side list
    local nMaxWidth = 200;
    if n30Percent > nMaxWidth then 
      n30Percent = nMaxWidth; 
    elseif n30Percent < nMinWidth then
      n30Percent = nMinWidth;
    end
    combatants.setAnchoredWidth(n30Percent);
    combatants.subwindow.list.onListChanged();
  end
end


function onClickRelease(nButton, x, y)
Debug.console("cta.lua","onClickRelease","nButton",nButton);
end

local enablevisibilitytoggle = true;
function toggleVisibility()
	if not enablevisibilitytoggle then
		return;
	end
	
	local visibilityon = button_global_visibility.getValue();
	for _,v in pairs(combatants.subwindow.list.getWindows()) do
		if v.friendfoe.getStringValue() ~= "friend" then
			if visibilityon ~= v.tokenvis.getValue() then
				v.tokenvis.setValue(visibilityon);
			end
		end
	end
end
