local __namespace, __module = ...

local Array = __module.Array --- @class Array
local Addon = __module.Addon --- @class Addon

local nextTick = Addon.nextTick
local useEvent = Addon.useEvent
local useHook = Addon.useHook

local module = {}

local combatLogReady = C_AddOns.IsAddOnLoaded("Blizzard_CombatLog")
local damageMeterReady = C_AddOns.IsAddOnLoaded("Blizzard_DamageMeter")

useEvent(
  function(context, evetName, addonName)
    combatLogReady = combatLogReady or addonName == "Blizzard_CombatLog"
    damageMeterReady = damageMeterReady or addonName == "Blizzard_DamageMeter"

    if not (combatLogReady and damageMeterReady) then
      return
    end

    module.disableFrame(CombatLogQuickButtonFrame_Custom)
    module.disableFrame(ChatFrame2.FontStringContainer)
    module.disableFrame(ChatFrame2.ScrollBar)
    module.disableFrame(ChatFrame2.ScrollToBottomButton)

    useHook(
      function()
        module.toggle(true)
      end, "OnShow", "secure-widget", ChatFrame2
    )

    useHook(
      function()
        module.toggle(false)
      end, "OnHide", "secure-widget", ChatFrame2
    )

    useHook(
      function()
        module.toggle(DamageMeter:IsEditing() or ChatFrame2:IsShown())
      end, "UpdateShownState", "secure-function", DamageMeter
    )

    nextTick(
      function()
        module.toggle(ChatFrame2:IsShown())
      end
    )

    context.unsub()
  end, { "ADDON_LOADED" }
)

function module.disableFrame(frame)
  useHook(
    function()
      frame:Hide()
    end, "OnShow", "secure-widget", frame
  )

  frame:Hide()
end

function module.toggle(value)
  DamageMeter:ClearAllPoints()
  DamageMeter:SetFrameStrata("MEDIUM")
  DamageMeter:SetPoint("BOTTOMLEFT", ChatFrame2Background, -14, -4)
  DamageMeter:SetPoint("TOPRIGHT", ChatFrame2Background, 14, 0)
  DamageMeter:SetShown(value)
end

__module.Main = module
