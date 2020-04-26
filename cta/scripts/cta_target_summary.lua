-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	onTargetsChanged();
	local node = window.getDatabaseNode();
	DB.addHandler(DB.getPath(node, "targets"), "onChildAdded", onTargetsChanged);
	DB.addHandler(DB.getPath(node, "targets.*"), "onChildUpdate", onTargetsChanged);
	DB.addHandler(DB.getPath(node, "targets"), "onChildDeleted", onTargetsChanged);
	DB.addHandler(DB.getPath(node, "friendfoe"), "onUpdate", onTargetsChanged);
end

function onClose()
	local node = window.getDatabaseNode();
	DB.removeHandler(DB.getPath(node, "targets"), "onChildAdded", onTargetsChanged);
	DB.removeHandler(DB.getPath(node, "targets.*"), "onChildUpdate", onTargetsChanged);
	DB.removeHandler(DB.getPath(node, "targets"), "onChildDeleted", onTargetsChanged);
	DB.removeHandler(DB.getPath(node, "friendfoe"), "onUpdate", onTargetsChanged);
end

function onTargetsChanged()
	local nodeCT = window.getDatabaseNode();
	if (window.getClass() == "client_ct_entry") and not User.isHost() and (DB.getValue(nodeCT, "friendfoe", "") ~= "friend") then
		setVisible(false);
		setValue(nil);
	else
		-- Get target names
		local aTargetNames = {};
		for _,vTarget in pairs(DB.getChildren(window.getDatabaseNode(), "targets")) do
			local sTargetName = "";
			local sCTNode = DB.getValue(vTarget, "noderef", "");
			if sCTNode ~= "" then
				local nodeCT = DB.findNode(sCTNode);
				if nodeCT then
					sTargetName = ActorManager.getDisplayName(nodeCT);
				end
			end
			if sTargetName == "" then
				sTargetName = "<Target>";
			end
			table.insert(aTargetNames, sTargetName);
		end

		-- Set the targeting summary string
		if #aTargetNames > 0 then
      if setValue then
        setValue(Interface.getString("ct_label_targets") .. " " .. table.concat(aTargetNames, "; "));
      end
      setTooltipText(Interface.getString("ct_label_targets") .. "\r" .. table.concat(aTargetNames, "\r"));
		else
      if setValue then
        setValue(nil);
      end
      setTooltipText(nil);
		end
		
		-- Update visibility
		if #aTargetNames == 0 then
			setVisible(false);
      if window and window.target_button_clear then
        window.target_button_clear.setVisible(false);
      end
		else
			setVisible(true);
      if window and window.target_button_clear then
        window.target_button_clear.setVisible(true);
      end
		end
	end
end

