-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onDrop(x, y, draginfo)
	if draginfo.isType("token") then
		local prototype, dropref = draginfo.getTokenData();
		setPrototype(prototype);
		CombatManager.replaceCombatantToken(window.getDatabaseNode(), dropref);
		return true;
	end
end

function onDragStart(draginfo)
	local nSpace = DB.getValue(window.getDatabaseNode(), "space");
	TokenManager.setDragTokenUnits(nSpace);
end
function onDragEnd(draginfo)
	TokenManager.endDragTokenWithUnits();

	local prototype, dropref = draginfo.getTokenData();
	if dropref then
		CombatManager.replaceCombatantToken(window.getDatabaseNode(), dropref);
	end
	return true;
end

function onClickDown(button, x, y)
--Debug.console("cta_token.lua","onClickDown","button",button);
  --window.windowlist.onClickDown(button,window.getPosition());
	--return true;
  return false;
end
function onClickRelease(button, x, y)
--Debug.console("cta_token.lua","onClickRelease","button",button);
  --window.windowlist.onClickRelease(button, window.getPosition());
	--return true;
  return false;
end
function onDoubleClick(x, y)
	CombatManager.openMap(window.getDatabaseNode());
end

function onWheel(notches)
	TokenManager.onWheelCT(window.getDatabaseNode(), notches);
	return true;
end
