PhantasmalEscapeTracker = {
    name = "PhantasmalEscapeTracker",
    version = "1.0",
    author = "TheMrPancake",
    defaults = {
        offsetX = 500,
        offsetY = 500,
    },
}

local stacks = 0
local stack_update_request = false
local stack_update_request_amount = 0
local addonName = PhantasmalEscapeTracker.name
local characterName = GetUnitName("player") .. "^Mx" -- wtf is ^Mx? 

local function UIUpdate(stackCount)
    stacks = stackCount
    PhantasmalEscapeTrackerXMLLabel:SetText(stacks .. " / 10")
    if stacks == 10 then
        PhantasmalEscapeTrackerXMLBackgroundNormal:SetHidden(true)
        PhantasmalEscapeTrackerXMLBackgroundHighlight:SetHidden(false)
    else 
        PhantasmalEscapeTrackerXMLBackgroundNormal:SetHidden(false)
        PhantasmalEscapeTrackerXMLBackgroundHighlight:SetHidden(true)
    end
end

local function UpdateCounter(event, _, isError, abilityName, _, _, sourceName, _, targetName, _, hitValue, _, _, _, _, _, _, _)
    if isError ~= false then return end
    if abilityName == "" then return end
    if sourceName == "" then return end
    if sourceName == targetName then return end
    if targetName ~= characterName then return end
    if stack_update_request == true then
        if stack_update_request_amount ~= 0 and stack_update_request_amount < stacks then stack_update_request = false return end
        stacks = stack_update_request_amount
        UIUpdate(stacks)
        stack_update_request = false
    end
end


local function PhantasmalCounter(event, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow)
    if abilityName ~= "Phantasmal Escape" then UpdateCounter(event, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow) return end
    if isError ~= false then return end
    d(hitValue)
    if hitValue == 4000 or hitValue == 2500 then return end
    if hitValue == 20000 then
         hitValue = 0
         UIUpdate(hitValue)
         stack_update_request = false
         stack_update_request_amount = 0
         return end
    stack_update_request = true
    stack_update_request_amount = hitValue
end

function PhantasmalEscapeTracker.OnLabelMoveStop()
    PhantasmalEscapeTracker.savedVariables.offsetX = PhantasmalEscapeTrackerXML:GetLeft()
    PhantasmalEscapeTracker.savedVariables.offsetY = PhantasmalEscapeTrackerXML:GetTop()
end

local function RestorePosition()
    local left = PhantasmalEscapeTracker.savedVariables.offsetX
    local top = PhantasmalEscapeTracker.savedVariables.offsetY
    PhantasmalEscapeTrackerXML:ClearAnchors()
    PhantasmalEscapeTrackerXML:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
    local alphaFragment = ZO_HUDFadeSceneFragment:New(PhantasmalEscapeTrackerXML, 250, 0)
    HUD_SCENE:AddFragment(alphaFragment)
    HUD_UI_SCENE:AddFragment(alphaFragment)
end

local function Init(event, name)
    if name ~= addonName then return end
    EVENT_MANAGER:UnregisterForEvent(addonName, EVENT_ADD_ON_LOADED)

    PhantasmalEscapeTracker.savedVariables = ZO_SavedVars:NewCharacterIdSettings("PhantasmalEscapeTrackerSavedVariables", 1, nil, PhantasmalEscapeTracker.defaults)
    RestorePosition()
    EVENT_MANAGER:RegisterForEvent(addonName, EVENT_COMBAT_EVENT, PhantasmalCounter)
end

EVENT_MANAGER:RegisterForEvent(addonName, EVENT_ADD_ON_LOADED, Init)