local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards');

local join = string.join

local GetContainerNumFreeSlots = GetContainerNumFreeSlots or (C_Container and C_Container.GetContainerNumFreeSlots)
local GetContainerNumSlots = GetContainerNumSlots or (C_Container and C_Container.GetContainerNumSlots)
local ToggleAllBags = ToggleAllBags
local NUM_BAG_SLOTS = NUM_BAG_SLOTS

local statusColors = {
	'|cff0CD809',	-- green
	'|cffE8DA0F',	-- yellow
	'|cffD80909'	-- red
}

local function OnEvent(self)
	local bar = _G['BUI_Bags']

	local free, total = 0, 0
	local textColor = 1
	for i = 0, NUM_BAG_SLOTS do
		free, total = free + GetContainerNumFreeSlots(i), total + GetContainerNumSlots(i)
	end

	local percentage = ((total - free) * 100) / total

	if percentage >= 80 then
		textColor = 3
	elseif percentage >= 60 and percentage < 80 then
		textColor = 2
	else
		textColor = 1
	end

	local displayFormat = join("", "%s", statusColors[textColor], "%d/%d|r")
	bar.Text:SetFormattedText(displayFormat, L["Bags"]..': ', total - free, total)
	bar.Status:SetMinMaxValues(0, total)
	bar.Status:SetValue(total - free)
end

local function OnClick()
	ToggleAllBags()
end

function mod:CreateBags()
	local bar = _G['BUI_Bags']

	bar.Status:SetScript('OnEvent', OnEvent)
	bar:SetScript('OnMouseDown', OnClick)

	bar.Status:RegisterEvent('BAG_UPDATE')
	bar.Status:RegisterEvent('PLAYER_ENTERING_WORLD')
end