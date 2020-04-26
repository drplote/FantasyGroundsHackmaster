-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local ctrlBar = nil;
local sBarFillColor = "006600";

local bAutomaticText = true;
local sTextPrefix = "";

local sCurrentNodePath = nil;
local sUsedNodePath = nil;
local sMaxNodePath = nil;

local bUsedMode = false;
local nCurrent = 0;
local nMax = 0;

function onInit()
	if fillcolor and fillcolor[1] then
		sBarFillColor = fillcolor[1];
	end
	if source and source[1] then
		local node = window.getDatabaseNode();
		if node and source[1].max and source[1].max[1] and source[1].max[1] ~= "" then
			sMaxNodePath = DB.getPath(node, source[1].max[1]);
		end
		if node and source[1].current and source[1].current[1] and source[1].current[1] ~= "" then
			sCurrentNodePath = DB.getPath(node, source[1].current[1]);
		elseif node and source[1].used and source[1].used[1] and source[1].used[1] ~= "" then
			sUsedNodePath = DB.getPath(node, source[1].used[1]);
		end
	end
	if noautotext then
		bAutomaticText = false;
	elseif textprefix and textprefix[1] then
		if textprefix[1].text and textprefix[1].text[1] then
			sTextPrefix = textprefix[1].text[1];
		elseif textprefix[1].textres and textprefix[1].textres[1] then
			sTextPrefix = Interface.getString(textprefix[1].textres[1]);
		end
	end
end
function onClose()
	if sMaxNodePath then
		DB.removeHandler(sMaxNodePath, "onUpdate", onMaxChanged);
	end
	if sCurrentNodePath then
		DB.removeHandler(sCurrentNodePath, "onUpdate", onCurrentChanged);
	end
	if sUsedNodePath then
		DB.removeHandler(sUsedNodePath, "onUpdate", onUsedChanged);
	end
end
function onFirstLayout()
	initialize();
end
function initialize()
	if sMaxNodePath then
		onMaxChanged();
		DB.addHandler(sMaxNodePath, "onUpdate", onMaxChanged);
	end
	if sCurrentNodePath then
		onCurrentChanged();
		DB.addHandler(sCurrentNodePath, "onUpdate", onCurrentChanged);
	end
	if sUsedNodePath then
		onUsedChanged();
		DB.addHandler(sUsedNodePath, "onUpdate", onUsedChanged);
	end
	
	ctrlBar = window.createControl("progressbarfill", getName() .. "_fill");
	update();
end

function setSourceMax(vMax)
	local sNewMaxNodePath = resolveSource(vMax);
	if sNewMaxNodePath == sMaxNodePath then return; end
	
	if sMaxNodePath then
		DB.removeHandler(sMaxNodePath, "onUpdate", onMaxChanged);
	end
	sMaxNodePath = sNewMaxNodePath;
	if sMaxNodePath then
		DB.addHandler(sMaxNodePath, "onUpdate", onMaxChanged);
	end
	onMaxChanged();
end
function setSourceCurrent(vCurrent)
	local sNewCurrentNodePath = resolveSource(vCurrent);
	if sNewCurrentNodePath == sCurrentNodePath then return; end
	
	if sCurrentNodePath then
		DB.removeHandler(sCurrentNodePath, "onUpdate", onCurrentChanged);
	end
	sCurrentNodePath = sNewCurrentNodePath;
	if sCurrentNodePath then
		DB.addHandler(sCurrentNodePath, "onUpdate", onCurrentChanged);
	end
	onCurrentChanged();
end
function setSourceUsed(vUsed)
	local sNewUsedNodePath = resolveSource(vUsed);
	if sNewUsedNodePath == sUsedNodePath then return; end
	
	if sUsedNodePath then
		DB.removeHandler(sUsedNodePath, "onUpdate", onUsedChanged);
	end
	sUsedNodePath = sNewUsedNodePath;
	if sUsedNodePath then
		DB.addHandler(sUsedNodePath, "onUpdate", onUsedChanged);
	end
	onUsedChanged();
end
function resolveSource(vSource)
	if type(vSource) == "string" then
		return vSource;
	elseif type(vSource) == "databasenode" then
		return vSource.getPath();
	end
	return nil;
end
function setFillColor(sNewBarFillColor)
	sBarFillColor = sNewBarFillColor;
	update();
end
function setText(sText)
	setTooltipText(sText);
	if ctrlBar then
		ctrlBar.setTooltipText(sText);
	end
end

function onCurrentChanged() setValue(DB.getValue(sCurrentNodePath, 0)); end
function onUsedChanged() setUsed(DB.getValue(sUsedNodePath, 0)); end
function onMaxChanged() setMax(DB.getValue(sMaxNodePath, 0)); end
function setValue(nValue)
	local nNewCurrent = math.max(math.min(nValue, nMax), 0);
	if nCurrent == nNewCurrent then return; end
	nCurrent = nNewCurrent;
	if self.onValueChanged then
		self.onValueChanged();
	end
	update();
end
function setUsed(nValue) 
	bUsedMode = true;
	setValue(nMax - nValue); 
end
function setMax(nValue)
	local nNewMax = math.max(nValue, 0);
	if nMax == nNewMax then return; end
	
	local nOriginalUsed = nMax - nCurrent;
	nMax = nNewMax;
	nCurrent = math.max(math.min(nCurrent, nMax), 0);
	if self.onValueChanged then
		self.onValueChanged();
	end
	if bUsedMode then
		setUsed(nOriginalUsed);
	end
	update();
end
function getValue() return nCurrent; end
function getUsed() return nMax - nCurrent; end
function getMax() return nMax; end
function getPercent() if nMax <= 0 then return 0; end return math.max(math.min(nCurrent / nMax, 1), 0); end

function update()
	if not ctrlBar then return; end
	
	local w,h = getSize();
	if (h < 2) or (w < 2) then
	    ctrlBar.setVisible(false);
	else
	    ctrlBar.setVisible(true);
		
		local bHorizontal = (h < w);
		local bOffset;
		if reverse and reverse[1] then
			bOffset = bHorizontal;
		else
			bOffset = not bHorizontal;
		end
		
		local nPercent = getPercent();

		local sName = getName();
		local x,y = getPosition();
		local nFrom, nLen;
		if bHorizontal then
			nLen = math.floor(((w - 2) * nPercent) + 0.5);
			if bOffset then
				nFrom = (w - nLen) - 1;
			else
				nFrom = 1;
			end
			ctrlBar.setAnchor("left", sName, "left", "absolute", nFrom);
			ctrlBar.setAnchor("top", sName, "top", "absolute", 1);
			ctrlBar.setAnchor("right", sName, "right", "absolute", nFrom - (w - nLen));
			ctrlBar.setAnchor("bottom", sName, "bottom", "absolute", -1);
		else
			nLen = math.floor(((h - 2) * nPercent) + 0.5);
			if bOffset then
				nFrom = (h - nLen) - 1;
			else
				nFrom = 1;
			end
			ctrlBar.setAnchor("left", sName, "left", "absolute", 1);
			ctrlBar.setAnchor("top", sName, "top", "absolute", nFrom);
			ctrlBar.setAnchor("right", sName, "right", "absolute", -1);
			ctrlBar.setAnchor("bottom", sName, "bottom", "absolute", nFrom - (h - nLen));
		end
		
		ctrlBar.setBackColor(sBarFillColor);
		
		if bAutomaticText then
			local sText = "" .. getValue() .. " / " .. getMax();
			if (sTextPrefix or "") ~= "" then
				sText = sTextPrefix .. ": " .. sText;
			end
			setText(sText);
		end
	end
end
