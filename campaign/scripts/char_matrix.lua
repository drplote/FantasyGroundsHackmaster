---
---
---
---


function onInit()
  createAttackMatrix();
end

function onClose()
end

function createAttackMatrix()
  -- default value is 1e.
  local nLowAC = -10;
  local nHighAC = 10;
  local nTotalACs = 11;
  
  if (DataCommonADND.coreVersion == "becmi") then
    nLowAC = -20;
    nHighAC = 19;
    nTotalACs = 20;
  end
  
  local node = getDatabaseNode();
  local bClassRecord = node.getPath():match("^class%.");
--Debug.console("char_matrix.lua","createAttackMatrix","node",node);    
  local sACLabelName = "matrix_ac_label";
  local sRollLabelName = "matrix_roll_label";

  -- 1e matrix
  local bUseMatrix = (DataCommonADND.coreVersion == "1e");
  local bisPC = (ActorManager.isPC(node)); 
  local aMatrixRolls = {};
  if not bClassRecord and bUseMatrix and not bisPC then 
    local sHitDice = CombatManagerADND.getNPCHitDice(node);
    if DataCommonADND.aMatrix[sHitDice] then
      aMatrixRolls = DataCommonADND.aMatrix[sHitDice];
--Debug.console("char_matrix.lua","createAttackMatrix","aMatrixRolls",aMatrixRolls);              
    end
  end
  --
  
  for i=nLowAC,nHighAC,1 do
    local nTHAC = DB.getValue(node,"combat.matrix.thac" .. i, 20);
    
    -- 1e matrix
    if bUseMatrix and not bisPC and #aMatrixRolls > 0 then
      -- math.abs(i-21), this table is reverse of how we display the matrix
      -- so we start at the end instead of at the front by taking I - 21 then get the absolute value of it.
     nTHAC = aMatrixRolls[math.abs(i-nTotalACs)];
    end
    --
    local sMatrixACName = "matrix_ac_" .. i;
    local sMatrixACValue = i;
    local sMatrixNumberName = "thac" .. i;
    local cntNum = createControl("number_matrix", sMatrixNumberName, "combat.matrix." .. sMatrixNumberName);
    cntNum.setValue(nTHAC);
    if not bClassRecord and bUseMatrix and not bisPC then
      cntNum.setReadOnly(true);
    end

    local cntAC = createControl("label_fieldtop_matrix", sMatrixACName);
    cntAC.setReadOnly(true);
    cntAC.setValue(sMatrixACValue);
    cntAC.setAnchor("left", sMatrixNumberName,"left","absolute",0);
  end
end