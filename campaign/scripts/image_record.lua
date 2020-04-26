--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onInit()
--
  if Interface.getVersion() >= 4 then
    if User.isHost() then
      local node = getDatabaseNode().getParent();
      DB.addHandler(DB.getPath(node, "scale"), "onUpdate", onUnitSizeUpdates);
      onUnitSizeUpdates(node);
    end
  end

  -- when the map is loaded setup these.
  TokenManagerADND.updateCTEntries();
end

function onClose()
  if Interface.getVersion() >= 4 then
    if User.isHost() then
      local node = getDatabaseNode().getParent();
      DB.removeHandler(DB.getPath(node, "scale"), "onUpdate", onUnitSizeUpdates);
    end
  end
end

-- update size/suffix on the map when they are reconfigured.
-- this isn't run unless the handler is setup and since we don't set it up unless
-- we are in FGU we don't again check to see if we're in FGU
function onUnitSizeUpdates(node)
  setDistanceBaseUnits(tostring(getUnitControlValue()));
  setDistanceSuffix(getUnitControlLabel());
end

-- get the unit scale and measurement
function getUnitControlSetting()
  local sValue = '5ft';
  local node = getDatabaseNode().getChild("..");
  sValue = DB.getValue(node,"scale","10ft"); -- default to 10ft here but we should never see this.
  return sValue;
end

-- is the scale value VALID?
function getUnitControlisValid()
  local bValid = false;
  bValid = getUnitControlSetting():find("^[%d%.]+") ~= nil
  return bValid;
end

-- get the size of each unit
function getUnitControlValue()
  local nScaleValue = 0;
  if getUnitControlisValid() then
    nScaleValue = tonumber(getUnitControlSetting():match("^([%d%.]+)")) or 0
  end
  return nScaleValue;
end

-- get the scale measurement name/string
function getUnitControlLabel()
  local sValue = "ft";
  sValue = StringManager.trim(getUnitControlSetting():gsub("^[%d%.]+%s*", ""))
  return sValue;
end

-- measureVector
function measureVector(nVectorX, nVectorY, sGridType, nGridSize, nGridHexWidth, nGridHexHeight)
  local nDiag = 1;
    if OptionsManager.isOption("HRDD", "variant") then
    nDiag = 1.5;
  end
  local nDistance = 0

  if sGridType == "hexrow" or sGridType == "hexcolumn" then
    local nCol, nRow = 0, 0
    if sGridType == "hexcolumn" then
      nCol = nVectorX / (nGridHexWidth*3)
      nRow = (nVectorY / (nGridHexHeight*2)) - (nCol * 0.5)
    else
      nRow = nVectorY / (nGridHexWidth*3)
      nCol = (nVectorX / (nGridHexHeight*2)) - (nRow * 0.5)
    end

    if  ((nRow >= 0 and nCol >= 0) or (nRow < 0 and nCol < 0)) then
      nDistance = math.abs(nCol) + math.abs(nRow)
    else
      nDistance = math.max(math.abs(nCol), math.abs(nRow))
    end

  else -- if sGridType == "square" then
    local nDiagonals = 0
    local nStraights = 0

    local nGridX = math.abs(nVectorX / nGridSize)
    local nGridY = math.abs(nVectorY / nGridSize)

    if nGridX > nGridY then
      nDiagonals = nDiagonals + nGridY
      nStraights = nStraights + nGridX - nGridY
    else
      nDiagonals = nDiagonals + nGridX
      nStraights = nStraights + nGridY - nGridX
    end

    nDistance = nDiagonals * nDiag + nStraights
  end

  return nDistance
end

-- when measuring a vector distance
function onMeasureVector(token, aVector)
  if hasGrid() then
    local sGridType = getGridType()
    local nGridSize = getGridSize()

    local nDistance = 0
    if sGridType == "hexrow" or sGridType == "hexcolumn" then
      local nGridHexWidth, nGridHexHeight = getGridHexElementDimensions()
      for i = 1, #aVector do
        local nVector = measureVector(aVector[i].x, aVector[i].y, sGridType, nGridSize, nGridHexWidth, nGridHexHeight)
        nDistance = nDistance + nVector
      end
    else -- if sGridType == "square" then
      for i = 1, #aVector do
        local nVector = measureVector(aVector[i].x, aVector[i].y, sGridType, nGridSize)
        nDistance = nDistance + nVector
      end
    end

    if getUnitControlisValid() then
      local sResult = string.format("%.1f %s",(nDistance * getUnitControlValue()),getUnitControlLabel());
      --return (nDistance * getUnitControlValue()) .. getUnitControlLabel()
      return sResult;
    else
      return ""
    end
  else
    return ""
  end
end

-- when measuring a pointer distance
function onMeasurePointer(nLength, sPointerType, nStartX, nStartY, nEndX, nEndY)
  if hasGrid() then
    local sGridType = getGridType()
    local nGridSize = getGridSize()

    if sGridType == "hexrow" or sGridType == "hexcolumn" then
      local nGridHexWidth, nGridHexHeight = getGridHexElementDimensions()
      nDistance = measureVector(nEndX - nStartX, nEndY - nStartY, sGridType, nGridSize, nGridHexWidth, nGridHexHeight)
    else -- if sGridType == "square" then
      nDistance = measureVector(nEndX - nStartX, nEndY - nStartY, sGridType, nGridSize)
    end

    if getUnitControlisValid() then
      local sResult = string.format("%.1f %s",(nDistance * getUnitControlValue()),getUnitControlLabel());
      --return (nDistance * getUnitControlValue()) .. getUnitControlLabel()
      return sResult;
    else
      return ""
    end
  else
    return ""
  end
end
