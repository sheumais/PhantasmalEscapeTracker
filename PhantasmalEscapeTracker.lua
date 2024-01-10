PhantasmalEscapeTracker = {
    name = "PhantasmalEscapeTracker",
    version = "1.0",
    author = "TheMrPancake"
}


stacks = 0
stack_update_request = false
stack_update_request_amount = 0
addonName = PhantasmalEscapeTracker.name
characterName = GetUnitName("player") .. "^Mx" -- wtf is ^Mx? 

function PhantasmalEscapeTracker.PhantasmalCounter(event, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow)
    if abilityName ~= "Phantasmal Escape" then PhantasmalEscapeTracker.UpdateCounter(event, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow) return end
    if isError ~= false then return end
    d(hitValue)
    if hitValue == 4000 or hitValue == 2500 then return end
    if hitValue == 20000 then
         hitValue = 0
         PhantasmalEscapeTracker.UIUpdate(hitValue)
         stack_update_request = false
         stack_update_request_amount = 0
         return end
    stack_update_request = true
    stack_update_request_amount = hitValue
end


function PhantasmalEscapeTracker.UpdateCounter(event, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow)
    if isError ~= false then return end
    if abilityName == "" then return end
    if sourceName == "" then return end
    if sourceName == targetName then return end
    if targetName ~= characterName then return end
    if stack_update_request == true then
        if stack_update_request_amount ~= 0 and stack_update_request_amount < stacks then stack_updaterequest = false return end
        stacks = stack_update_request_amount
        PhantasmalEscapeTracker.UIUpdate(stacks)
        stack_update_request = false
    end
end

function PhantasmalEscapeTracker.UIUpdate(stackCount)
    stacks = stackCount
    PhantasmalEscapeTrackerCounterLabel:SetText(stacks .. " / 10")
end

-- ability start codes without buff
-- 1, 1, 20000, 4000
-- ability recast codes
-- 1, 1

-- finishes with 20000 always


--function PhantasmalEscapeTracker.OnIndicatorMoveStop()

local function Init(event, name)
    if name ~= addonName then return end
    EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_ADD_ON_LOADED)
    EVENT_MANAGER:RegisterForEvent(addonName, EVENT_COMBAT_EVENT, PhantasmalEscapeTracker.PhantasmalCounter)
end

EVENT_MANAGER:RegisterForEvent(addonName, EVENT_ADD_ON_LOADED, Init)






-- * EVENT_COMBAT_EVENT 
-- (*[ActionResult|#ActionResult]* _result_,
--  *bool* _isError_,
--  *string* _abilityName_,
--  *integer* _abilityGraphic_,
--  *[ActionSlotType|#ActionSlotType]* _abilityActionSlotType_,
--  *string* _sourceName_,
--  *[CombatUnitType|#CombatUnitType]* _sourceType_,
--  *string* _targetName_,
--  *[CombatUnitType|#CombatUnitType]* _targetType_,
--  *integer* _hitValue_,
--  *[CombatMechanicFlags|#CombatMechanicFlags]* _powerType_,
--  *[DamageType|#DamageType]* _damageType_,
--  *bool* _log_,
--  *integer* _sourceUnitId_,
--  *integer* _targetUnitId_,
--  *integer* _abilityId_,
--  *integer* _overflow_)

-- * EVENT_POWER_UPDATE (*string* _unitTag_,
--  *luaindex* _powerIndex_,
--  *[CombatMechanicFlags|#CombatMechanicFlags]* _powerType_,
--  *integer* _powerValue_,
--  *integer* _powerMax_,
--  *integer* _powerEffectiveMax_)