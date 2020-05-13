function onInit()
	Comm.registerSlashHandler("crit", onCritSlashCommand);
end

function deliverChatMessage(sText)
	local rMessage = ChatManager.createBaseMessage();
	rMessage.type = "crit";
	rMessage.text = sText .. " Sure would be cool if this feature were implemented yet.";
	Comm.deliverChatMessage(rMessage);
end

function onCritSlashCommand(sCmd, sParam)
		
	local sRollName = "Critical Hit";
	
	local sText = "[" .. sRollName .. "] ";
	deliverChatMessage(sText);
end
