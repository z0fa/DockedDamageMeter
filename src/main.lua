local __namespace, __module = ...
local Array = __module.Array --- @class Array
local Addon = __module.Addon --- @class Addon
local useHook = Addon.useHook
local onReady = Addon.onReady

local module = {}
local initialized = false

onReady(
  function(isLogin, isReload)
    module.init()
    module.toggle(ChatFrame2:IsShown())
  end
)

function module.init()
  if initialized then
    return
  end

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

  module.disableFrame(CombatLogQuickButtonFrame_Custom)
  module.disableFrame(ChatFrame2.FontStringContainer)
  module.disableFrame(ChatFrame2.ScrollBar)
  module.disableFrame(ChatFrame2.ScrollToBottomButton)

  initialized = true
end

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
