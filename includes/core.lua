local adBuffBar = {
	version = 2.21,
}
_G.adBuffBar = adBuffBar
adBuffBarDB = {}
adBBSet = {}

SLASH_adBuffBar1 = "/adbuffbar"
SLASH_adBuffBar2 = "/adbb"
SlashCmdList["adBuffBar"] = function ()
	if XBARVERSION and XBARVERSION>=1.51 then
		XAddon_ShowPage("adBuffBarGUI")
	else
		ToggleUIFrame(adBuffBarGUI)
	end
end

local skins = {"barfill", "bantobar", "gloss", "round", "round2", "smooth", "statusbar", "steel"}
local def = {
	["WarningTime"] = 45,
	["BarScale"] = 1,
	["BarWidth"] = 180,
	["Flash"] = true,
	["WarningRed"] = false,
	["Fills"] = true,
	["InvertFilling"] = false,
	["BuffsAmount"] = 24,
	["DebuffsAmount"] = 24,
	["Icons"] = true,
	["Shrink"] = false,
	["Locked"] = false,
	["Mirror"] = false,
	["Snap"] = "LEFT",
	["ShortTime"] = false,
	["PlayerBuffs"] = true,
	["PlayerDebuffs"] = true,
	["TargetBuffs"] = true,
	["TargetDebuffs"] = true,
	["OrigPlayer"] = false,
	["OrigTarget"] = false,
	["DebuffBorder"] = true,
	["value"] = 1,
	["ColorsPlayerBuffs"] = {
		r = .2,
		g = .8,
		b = .8,
	},
	["ColorsPlayerDebuffs"] = {
		r = 1,
		g = .7,
		b = .7,
	},
	["ColorsTargetBuffs"] = {
		r = 1,
		g = .9,
		b = .7,
	},
	["ColorsTargetDebuffs"] = {
		r = .4,
		g = .8,
		b = 1,
	},
	["PlayerBuff_X"] = 500,
	["PlayerBuff_Y"] = 200,
	["PlayerDebuff_X"] = -18,
	["PlayerDebuff_Y"] = 0,
	["TargetBuff_X"] = 500,
	["TargetBuff_Y"] = 300,
	["TargetDebuff_X"] = -18,
	["TargetDebuff_Y"] = 0,
}

local function Print(str, ...)
	DEFAULT_CHAT_FRAME:AddMessage(str:format(...), 1, 1, 1)
end

local function SetSkin(skin)
	for i=1,40 do
		_G["adBuffBarPlayerBuff"..i.."BarTexture"]:SetTexture(skin)
		_G["adBuffBarTargetBuff"..i.."BarTexture"]:SetTexture(skin)
		_G["adBuffBarPlayerDebuff"..i.."BarTexture"]:SetTexture(skin)
		_G["adBuffBarTargetDebuff"..i.."BarTexture"]:SetTexture(skin)
	end
end

local function DefineSkin(t)
	if t.value==1 then
		SetSkin("Interface/Common/barfill")
	else
		SetSkin("Interface/Common/Bar/"..skins[t.value])
	end
	adBBSet["value"] = t.value
	UIDropDownMenu_SetSelectedID(adBuffBarGUISkinMenu, t.value)
end

function adBuffBar.GUI_Reset()
	for k, v in pairs(def) do
		adBBSet[k] = v
	end
	adBuffBar.GUI_Show()
	adBuffBar.GUI_Event()
end

function adBuffBar.GUI_Save()
	adBBSet["WarningTime"] = tonumber(string.format("%.2f", adBuffBarGUIFlashTimeSlider:GetValue()))
	adBBSet["BarScale"] = tonumber(string.format("%.2f", adBuffBarGUIBarScaleSlider:GetValue()))
	adBBSet["BarWidth"] = adBuffBarGUIBarWidthSlider:GetValue()
	adBBSet["Flash"] = adBuffBarGUIFlashCheck:IsChecked()
	adBBSet["WarningRed"] = adBuffBarGUIFlashToRedCheck:IsChecked()
	adBBSet["Fills"] = adBuffBarGUIFillsCheck:IsChecked()
	adBBSet["InvertFilling"] = adBuffBarGUIInvertFillingCheck:IsChecked()
	adBBSet["BuffsAmount"] = adBuffBarGUIBuffsAmountSlider:GetValue()
	adBBSet["DebuffsAmount"] = adBuffBarGUIDebuffsAmountSlider:GetValue()
	adBBSet["Icons"] = adBuffBarGUIIconsCheck:IsChecked()
	adBBSet["Shrink"] = adBuffBarGUIShrinkCheck:IsChecked()
	if adBuffBarGUIShrinkCheck:IsChecked() then
		adBBSet["BarWidth"] = 40
	end
	adBBSet["Locked"] = adBuffBarGUILockedCheck:IsChecked()
	adBBSet["Mirror"] = adBuffBarGUIMirrorCheck:IsChecked()
	adBBSet["ShortTime"] = adBuffBarGUIShortTimeCheck:IsChecked()
	adBBSet["PlayerBuffs"] = adBuffBarGUIPlayerBuffsCheck:IsChecked()
	adBBSet["PlayerDebuffs"] = adBuffBarGUIPlayerDebuffsCheck:IsChecked()
	adBBSet["TargetBuffs"] = adBuffBarGUITargetBuffsCheck:IsChecked()
	adBBSet["TargetDebuffs"] = adBuffBarGUITargetDebuffsCheck:IsChecked()
	adBBSet["OrigPlayer"] = adBuffBarGUIOrigPlayerCheck:IsChecked()
	adBBSet["OrigTarget"] = adBuffBarGUIOrigTargetCheck:IsChecked()
	adBBSet["DebuffBorder"] = adBuffBarGUIDebuffBorderCheck:IsChecked()
	adBuffBar.GUI_Event()
end

function adBuffBar.GUI_Show()
	adBuffBarGUIBarWidthSlider:SetValue(adBBSet["BarWidth"])
	adBuffBarGUIBarScaleSlider:SetValue(adBBSet["BarScale"])
	adBuffBarGUIFlashTimeSlider:SetValue(adBBSet["WarningTime"])
	adBuffBarGUIFlashCheck:SetChecked(adBBSet["Flash"])
	adBuffBarGUIFlashToRedCheck:SetChecked(adBBSet["WarningRed"])
	adBuffBarGUIFillsCheck:SetChecked(adBBSet["Fills"])
	adBuffBarGUIInvertFillingCheck:SetChecked(adBBSet["InvertFilling"])
	adBuffBarGUIBuffsAmountSlider:SetValue(adBBSet["BuffsAmount"])
	adBuffBarGUIDebuffsAmountSlider:SetValue(adBBSet["DebuffsAmount"])
	adBuffBarGUIIconsCheck:SetChecked(adBBSet["Icons"])
	adBuffBarGUIShrinkCheck:SetChecked(adBBSet["Shrink"])
	adBuffBarGUILockedCheck:SetChecked(adBBSet["Locked"])
	adBuffBarGUIMirrorCheck:SetChecked(adBBSet["Mirror"])
	adBuffBarGUIColorsPlayerBuffsTexture:SetColor(adBBSet["ColorsPlayerBuffs"].r,adBBSet["ColorsPlayerBuffs"].g,adBBSet["ColorsPlayerBuffs"].b)
	adBuffBarGUIColorsPlayerDebuffsTexture:SetColor(adBBSet["ColorsPlayerDebuffs"].r,adBBSet["ColorsPlayerDebuffs"].g,adBBSet["ColorsPlayerDebuffs"].b)
	adBuffBarGUIColorsTargetBuffsTexture:SetColor(adBBSet["ColorsTargetBuffs"].r,adBBSet["ColorsTargetBuffs"].g,adBBSet["ColorsTargetBuffs"].b)
	adBuffBarGUIColorsTargetDebuffsTexture:SetColor(adBBSet["ColorsTargetDebuffs"].r,adBBSet["ColorsTargetDebuffs"].g,adBBSet["ColorsTargetDebuffs"].b)
	adBuffBarGUIShortTimeCheck:SetChecked(adBBSet["ShortTime"])
	adBuffBarGUIPlayerBuffsCheck:SetChecked(adBBSet["PlayerBuffs"])
	adBuffBarGUIPlayerDebuffsCheck:SetChecked(adBBSet["PlayerDebuffs"])
	adBuffBarGUITargetBuffsCheck:SetChecked(adBBSet["TargetBuffs"])
	adBuffBarGUITargetDebuffsCheck:SetChecked(adBBSet["TargetDebuffs"])
	adBuffBarGUIOrigPlayerCheck:SetChecked(adBBSet["OrigPlayer"])
	adBuffBarGUIOrigTargetCheck:SetChecked(adBBSet["OrigTarget"])
	adBuffBarGUIDebuffBorderCheck:SetChecked(adBBSet["DebuffBorder"])
	adBuffBarScrollFrame:UpdateScrollChildRect()
	adBuffBarGUIVersion:SetText(adBuffBar.version)
	adBuffBarGUITitle:SetText("adBuffBar")
	adBuffBarGUIBarWidthName:SetText(adBuffBar.Lang["BarWidth"])
	adBuffBarGUIBarScaleName:SetText(adBuffBar.Lang["BarScale"])
	adBuffBarGUIFlashTimeName:SetText(adBuffBar.Lang["FlashTime"])
	adBuffBarGUIFlashName:SetText(adBuffBar.Lang["Flash"])
	adBuffBarGUIFlashToRedName:SetText(adBuffBar.Lang["FlashToRed"])
	adBuffBarGUIFillsName:SetText(adBuffBar.Lang["Fills"])
	adBuffBarGUIInvertFillingName:SetText(adBuffBar.Lang["InvertFilling"])
	adBuffBarGUIBuffsAmountName:SetText(adBuffBar.Lang["BuffsAmount"])
	adBuffBarGUIDebuffsAmountName:SetText(adBuffBar.Lang["DebuffsAmount"])
	adBuffBarGUIIconsName:SetText(adBuffBar.Lang["Icons"])
	adBuffBarGUIShrinkName:SetText(adBuffBar.Lang["Shrink"])
	adBuffBarGUILockedName:SetText(adBuffBar.Lang["Locked"])
	adBuffBarGUIMirrorName:SetText(adBuffBar.Lang["Mirror"])
	adBuffBarGUIShortTimeName:SetText(adBuffBar.Lang["ShortTime"])
	adBuffBarGUISnapName:SetText(adBuffBar.Lang["Snap"])
	adBuffBarGUIColorsPlayerName:SetText(adBuffBar.Lang["ColorsPlayer"])
	adBuffBarGUIColorsTargetName:SetText(adBuffBar.Lang["ColorsTarget"])
	adBuffBarGUIPlayerBuffsName:SetText(adBuffBar.Lang["PlayerBuffs"])
	adBuffBarGUIPlayerDebuffsName:SetText(adBuffBar.Lang["PlayerDebuffs"])
	adBuffBarGUITargetBuffsName:SetText(adBuffBar.Lang["TargetBuffs"])
	adBuffBarGUITargetDebuffsName:SetText(adBuffBar.Lang["TargetDebuffs"])
	adBuffBarGUIOrigPlayerName:SetText(adBuffBar.Lang["OrigPlayer"])
	adBuffBarGUIOrigTargetName:SetText(adBuffBar.Lang["OrigTarget"])
	adBuffBarGUIDebuffBorderName:SetText(adBuffBar.Lang["DebuffBorder"])
	adBuffBarGUISkinMenuName:SetText(adBuffBar.Lang["Skin"])
end

function adBuffBar.GUI_Event(event)
	if event=="VARIABLES_LOADED" then
		local lang = GetLanguage():upper()
		local _, err = loadfile("Interface/Addons/adBuffBar/Locales/"..lang..".lua")
		if err then
			Print("|cff993333adBuffBar can't find translation, ENUS.lua loaded.|r")
			dofile("Interface/Addons/adBuffBar/Locales/ENUS.lua")
		else
			dofile("Interface/Addons/adBuffBar/Locales/"..lang..".lua")
		end
		SaveVariables("adBBSet")
		SaveVariables("adBuffBarDB")
		for k, v in pairs(def) do
			if adBBSet[k]==nil then
				adBBSet[k] = v
			end
		end
		Print("|cff80E800adBuffBar %s|r %s |cff80E800/adbb|r %s", adBuffBar.version, adBuffBar.Lang["Load"], adBuffBar.Lang["ToConfig"])
		if XBARVERSION and XBARVERSION>=1.51 then
			XAddon_Register(
			{gui={{
				name = "adBuffBar",
				version = adBuffBar.version,
				window = "adBuffBarGUI",
			}},
			popup={{
				GetText = function() return "adBuffBar" end,
				GetTooltip = function() return "/adbb, /adbuffbar" end,
				OnClick = function() XAddon_ShowPage("adBuffBarGUI") end,
			}}})
		end
		local tOrig = TargetBuffButton_Update
		TargetBuffButton_Update = function()
			if not adBBSet["OrigTarget"] then
				tOrig()
			end
		end
		local pOrig = PlayerBuffButton_Update
		PlayerBuffButton_Update = function(t)
			if not adBBSet["OrigPlayer"] then
				pOrig(t)
			end
		end
	end
	DefineSkin(adBBSet)
	adBuffBarPlayerBuff:SetScale(adBBSet["BarScale"])
	adBuffBarPlayerDebuff:SetScale(adBBSet["BarScale"])
	adBuffBarTargetBuff:SetScale(adBBSet["BarScale"])
	adBuffBarTargetDebuff:SetScale(adBBSet["BarScale"])
	if adBBSet["PlayerBuffs"] then
		adBuffBarPlayerBuff:Show()
	else
		adBuffBarPlayerBuff:Hide()
	end
	if adBBSet["PlayerDebuffs"] then
		adBuffBarPlayerDebuff:Show()
	else
		adBuffBarPlayerDebuff:Hide()
	end
	if adBBSet["TargetBuffs"] then
		adBuffBarTargetBuff:Show()
	else
		adBuffBarTargetBuff:Hide()
	end
	if adBBSet["TargetDebuffs"] then
		adBuffBarTargetDebuff:Show()
	else
		adBuffBarTargetDebuff:Hide()
	end
	if adBBSet["Locked"] then
		adBuffBarPlayerBuffAnchor:Hide()
		adBuffBarTargetBuffAnchor:Hide()
	else
		adBuffBarPlayerBuffAnchor:Show()
		adBuffBarTargetBuffAnchor:Show()
	end
	if adBBSet["Mirror"] or not adBBSet["Icons"] then
		adBuffBarPlayerBuffAnchor:ClearAllAnchors()
		adBuffBarTargetBuffAnchor:ClearAllAnchors()
		adBuffBarPlayerDebuffAnchor:ClearAllAnchors()
		adBuffBarTargetDebuffAnchor:ClearAllAnchors()
		adBuffBarPlayerBuffAnchor:SetAnchor("TOPLEFT", "TOPLEFT", "adBuffBarPlayerBuff1", -8, -8)
		adBuffBarTargetBuffAnchor:SetAnchor("TOPLEFT", "TOPLEFT", "adBuffBarTargetBuff1", -8, -8)
		adBuffBarPlayerDebuffAnchor:SetAnchor("TOPLEFT", "TOPLEFT", "adBuffBarPlayerDebuff1", -8, -8)
		adBuffBarTargetDebuffAnchor:SetAnchor("TOPLEFT", "TOPLEFT", "adBuffBarTargetDebuff1", -8, -8)
	else
		adBuffBarPlayerBuffAnchor:ClearAllAnchors()
		adBuffBarTargetBuffAnchor:ClearAllAnchors()
		adBuffBarPlayerDebuffAnchor:ClearAllAnchors()
		adBuffBarTargetDebuffAnchor:ClearAllAnchors()
		adBuffBarPlayerBuffAnchor:SetAnchor("TOPLEFT", "TOPLEFT", "adBuffBarPlayerBuff1", -26, -8)
		adBuffBarTargetBuffAnchor:SetAnchor("TOPLEFT", "TOPLEFT", "adBuffBarTargetBuff1", -26, -8)
		adBuffBarPlayerDebuffAnchor:SetAnchor("TOPLEFT", "TOPLEFT", "adBuffBarPlayerDebuff1", -26, -8)
		adBuffBarTargetDebuffAnchor:SetAnchor("TOPLEFT", "TOPLEFT", "adBuffBarTargetDebuff1", -26, -8)
	end
	adBuffBar.GUI_Snap(adBBSet["Snap"])
	for i=1,40 do
		if adBBSet["PlayerBuffs"] and i<=adBBSet["BuffsAmount"] then
			_G["adBuffBarPlayerBuff"..i]:RegisterEvent("UNIT_BUFF_CHANGED")
		else
			_G["adBuffBarPlayerBuff"..i]:UnregisterEvent("UNIT_BUFF_CHANGED")
		end
		if adBBSet["PlayerDebuffs"] and i<=adBBSet["DebuffsAmount"] then
			_G["adBuffBarPlayerDebuff"..i]:RegisterEvent("UNIT_BUFF_CHANGED")
		else
			_G["adBuffBarPlayerDebuff"..i]:UnregisterEvent("UNIT_BUFF_CHANGED")
		end
		if adBBSet["TargetBuffs"] and i<=adBBSet["BuffsAmount"] then
			_G["adBuffBarTargetBuff"..i]:RegisterEvent("UNIT_TARGET_CHANGED")
			_G["adBuffBarTargetBuff"..i]:RegisterEvent("UNIT_BUFF_CHANGED")
		else
			_G["adBuffBarTargetBuff"..i]:UnregisterEvent("UNIT_TARGET_CHANGED")
			_G["adBuffBarTargetBuff"..i]:UnregisterEvent("UNIT_BUFF_CHANGED")
		end
		if adBBSet["TargetDebuffs"] and i<=adBBSet["DebuffsAmount"] then
			_G["adBuffBarTargetDebuff"..i]:RegisterEvent("UNIT_TARGET_CHANGED")
			_G["adBuffBarTargetDebuff"..i]:RegisterEvent("UNIT_BUFF_CHANGED")
		else
			_G["adBuffBarTargetDebuff"..i]:UnregisterEvent("UNIT_TARGET_CHANGED")
			_G["adBuffBarTargetDebuff"..i]:UnregisterEvent("UNIT_BUFF_CHANGED")
		end
		if i>adBBSet["BuffsAmount"] then
			_G["adBuffBarPlayerBuff"..i]:Hide()
			_G["adBuffBarTargetBuff"..i]:Hide()
		end
		if i>adBBSet["DebuffsAmount"] then
			_G["adBuffBarPlayerDebuff"..i]:Hide()
			_G["adBuffBarTargetDebuff"..i]:Hide()
		end
		if adBBSet["Icons"] then
			_G["adBuffBarPlayerBuff"..i.."Icon"]:Show()
			_G["adBuffBarTargetBuff"..i.."Icon"]:Show()
			_G["adBuffBarPlayerDebuff"..i.."Icon"]:Show()
			_G["adBuffBarTargetDebuff"..i.."Icon"]:Show()
		else
			_G["adBuffBarPlayerBuff"..i.."Icon"]:Hide()
			_G["adBuffBarTargetBuff"..i.."Icon"]:Hide()
			_G["adBuffBarPlayerDebuff"..i.."Icon"]:Hide()
			_G["adBuffBarTargetDebuff"..i.."Icon"]:Hide()
		end
		if adBBSet["Shrink"] then
			_G["adBuffBarPlayerBuff"..i.."Name"]:Hide()
			_G["adBuffBarTargetBuff"..i.."Name"]:Hide()
			_G["adBuffBarPlayerDebuff"..i.."Name"]:Hide()
			_G["adBuffBarTargetDebuff"..i.."Name"]:Hide()
		else
			_G["adBuffBarPlayerBuff"..i.."Name"]:Show()
			_G["adBuffBarPlayerBuff"..i.."Name"]:SetWidth(adBBSet["BarWidth"]-25)
			_G["adBuffBarTargetBuff"..i.."Name"]:Show()
			_G["adBuffBarTargetBuff"..i.."Name"]:SetWidth(adBBSet["BarWidth"]-25)
			_G["adBuffBarPlayerDebuff"..i.."Name"]:Show()
			_G["adBuffBarPlayerDebuff"..i.."Name"]:SetWidth(adBBSet["BarWidth"]-25)
			_G["adBuffBarTargetDebuff"..i.."Name"]:Show()
			_G["adBuffBarTargetDebuff"..i.."Name"]:SetWidth(adBBSet["BarWidth"]-25)
		end
		_G["adBuffBarPlayerBuff"..i]:SetWidth(adBBSet["BarWidth"])
		_G["adBuffBarTargetBuff"..i]:SetWidth(adBBSet["BarWidth"])
		_G["adBuffBarPlayerDebuff"..i]:SetWidth(adBBSet["BarWidth"])
		_G["adBuffBarTargetDebuff"..i]:SetWidth(adBBSet["BarWidth"])
		local pb = _G["adBuffBarPlayerBuff"..i]:GetName()
		local ptb = _G["adBuffBarTargetBuff"..i]:GetName()
		local tb = _G["adBuffBarPlayerDebuff"..i]:GetName()
		local tdb = _G["adBuffBarTargetDebuff"..i]:GetName()
		_G["adBuffBarPlayerBuff"..i.."Icon"]:ClearAllAnchors()
		_G["adBuffBarTargetBuff"..i.."Icon"]:ClearAllAnchors()
		_G["adBuffBarPlayerDebuff"..i.."Icon"]:ClearAllAnchors()
		_G["adBuffBarTargetDebuff"..i.."Icon"]:ClearAllAnchors()
		if adBBSet["Mirror"] then
			_G["adBuffBarPlayerBuff"..i.."Icon"]:SetAnchor("LEFT", "RIGHT", pb, 0, 0)
			_G["adBuffBarTargetBuff"..i.."Icon"]:SetAnchor("LEFT", "RIGHT", ptb, 0, 0)
			_G["adBuffBarPlayerDebuff"..i.."Icon"]:SetAnchor("LEFT", "RIGHT", tb, 0, 0)
			_G["adBuffBarTargetDebuff"..i.."Icon"]:SetAnchor("LEFT", "RIGHT", tdb, 0, 0)
		else
			_G["adBuffBarPlayerBuff"..i.."Icon"]:SetAnchor("RIGHT", "LEFT", pb, 0, 0)
			_G["adBuffBarTargetBuff"..i.."Icon"]:SetAnchor("RIGHT", "LEFT", ptb, 0, 0)
			_G["adBuffBarPlayerDebuff"..i.."Icon"]:SetAnchor("RIGHT", "LEFT", tb, 0, 0)
			_G["adBuffBarTargetDebuff"..i.."Icon"]:SetAnchor("RIGHT", "LEFT", tdb, 0, 0)
		end
		if adBBSet["DebuffBorder"] and adBBSet["Icons"] then
			_G["adBuffBarPlayerDebuff"..i.."Border"]:Show()
			_G["adBuffBarTargetDebuff"..i.."Border"]:Show()
		else
			_G["adBuffBarPlayerDebuff"..i.."Border"]:Hide()
			_G["adBuffBarTargetDebuff"..i.."Border"]:Hide()
		end
		if i<=adBBSet["BuffsAmount"] then
			adBuffBar.UpdateBar(_G["adBuffBarPlayerBuff"..i], true)
			adBuffBar.UpdateBar(_G["adBuffBarTargetBuff"..i], true)
		end
		if i<=adBBSet["DebuffsAmount"] then
			adBuffBar.UpdateBar(_G["adBuffBarPlayerDebuff"..i], true)
			adBuffBar.UpdateBar(_G["adBuffBarTargetDebuff"..i], true)
		end
	end
	for i=1,MAX_BUFF_SIZE do
		if adBBSet["OrigPlayer"] then
			_G["PlayerBuffButton"..i]:Hide()
			_G["PlayerDebuffButton"..i]:Hide()
		end
		if adBBSet["OrigTarget"] then
			_G["TargetBuffButton"..i]:Hide()
			_G["TargetDebuffButton"..i]:Hide()
		end
	end
end

function adBuffBar.GUI_ColorsClick(this)
	local func = function()
		_G[this:GetName().."Texture"]:SetColor(ColorPickerFrame.r, ColorPickerFrame.g, ColorPickerFrame.b)
		adBBSet[this:GetName():sub(13)] = {
			r = math.ceil(ColorPickerFrame.r * 100)/100,
			g = math.ceil(ColorPickerFrame.g * 100)/100,
			b = math.ceil(ColorPickerFrame.b * 100)/100,
		}
	end
	local info = {
		brightnessUp = 1,
		brightnessDown = 0,
		callbackFuncOkay = func,
		callbackFuncUpdate = func,
		callbackFuncCancel = func,
	}
	info.r, info.g, info.b = _G[this:GetName().."Texture"]:GetColor()
	OpenColorPickerFrameEx(info)
	ColorPickerFrame:ClearAllAnchors()
	ColorPickerFrame:SetAnchor("LEFT","RIGHT",adBuffBarGUI,0,0)
end

function adBuffBar.GUI_Snap(v)
	adBuffBar.GUI_SnapLR(v)
	if v=="TOP" then
		local PBuffs, TBuffs = 1, 1
		for i = 2, 40 do
			if not _G["adBuffBarPlayerDebuff"..i]:IsVisible() then
				PBuffs = i-1
				break
			end
		end
		adBuffBarPlayerBuff1:ClearAllAnchors()
		adBuffBarPlayerBuff1:SetAnchor("TOP","BOTTOM","adBuffBarPlayerDebuff"..PBuffs,0,0)
		for i = 2, 40 do
			if not _G["adBuffBarTargetDebuff"..i]:IsVisible() then
				TBuffs = i-1
				break
			end
		end
		adBuffBarTargetBuff1:ClearAllAnchors()
		adBuffBarTargetBuff1:SetAnchor("TOP","BOTTOM","adBuffBarTargetDebuff"..TBuffs,0,0)
	elseif v=="BOTTOM" then
		local PBuffs, TBuffs = 1, 1
		for i = 2, 40 do
			if not _G["adBuffBarPlayerBuff"..i]:IsVisible() then
				PBuffs = i-1
				break
			end
		end
		adBuffBarPlayerDebuff1:ClearAllAnchors()
		adBuffBarPlayerDebuff1:SetAnchor("TOP","BOTTOM","adBuffBarPlayerBuff"..PBuffs,0,0)
		for i = 2, 40 do
			if not _G["adBuffBarTargetBuff"..i]:IsVisible() then
				TBuffs = i-1
				break
			end
		end
		adBuffBarTargetDebuff1:ClearAllAnchors()
		adBuffBarTargetDebuff1:SetAnchor("TOP","BOTTOM","adBuffBarTargetBuff"..TBuffs,0,0)
	end
end

local function GUI_Anchor(v)
	local adj = adBBSet["BarScale"]
	if v=="TOP" then
		adBuffBarPlayerDebuff1:ClearAllAnchors()
		adBuffBarPlayerDebuff1:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", adBBSet["PlayerBuff_X"]/adj, adBBSet["PlayerBuff_Y"]/adj)
		adBuffBarTargetDebuff1:ClearAllAnchors()
		adBuffBarTargetDebuff1:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", adBBSet["TargetBuff_X"]/adj, adBBSet["TargetBuff_Y"]/adj)
	else
		adBuffBarPlayerBuff1:ClearAllAnchors()
		adBuffBarPlayerBuff1:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", adBBSet["PlayerBuff_X"]/adj, adBBSet["PlayerBuff_Y"]/adj)
		adBuffBarTargetBuff1:ClearAllAnchors()
		adBuffBarTargetBuff1:SetAnchor("TOPLEFT", "TOPLEFT", "UIParent", adBBSet["TargetBuff_X"]/adj, adBBSet["TargetBuff_Y"]/adj)
	end
end

function adBuffBar.GUI_SnapLR(v)
	GUI_Anchor(v)
	if adBBSet["Locked"] then
		adBuffBarPlayerBuffAnchor:Hide()
		adBuffBarTargetBuffAnchor:Hide()
		adBuffBarPlayerDebuffAnchor:Hide()
		adBuffBarTargetDebuffAnchor:Hide()
	else
		if v=="BOTTOM" then
			adBuffBarPlayerBuffAnchor:Show()
			adBuffBarTargetBuffAnchor:Show()
			adBuffBarPlayerDebuffAnchor:Hide()
			adBuffBarTargetDebuffAnchor:Hide()
		elseif v=="TOP" then
			adBuffBarPlayerBuffAnchor:Hide()
			adBuffBarTargetBuffAnchor:Hide()
			adBuffBarPlayerDebuffAnchor:Show()
			adBuffBarTargetDebuffAnchor:Show()
		else
			adBuffBarPlayerBuffAnchor:Show()
			adBuffBarTargetBuffAnchor:Show()
			adBuffBarPlayerDebuffAnchor:Show()
			adBuffBarTargetDebuffAnchor:Show()
		end
	end
	local adj = adBBSet["BarScale"]
	adBBSet["Snap"] = v
	if v=="LEFT" then
		adBuffBarPlayerDebuff1:ClearAllAnchors()
		adBuffBarTargetDebuff1:ClearAllAnchors()
		adBuffBarPlayerDebuff1:SetAnchor("RIGHT","LEFT","adBuffBarPlayerBuff1",adBBSet["PlayerDebuff_X"]/adj,adBBSet["PlayerDebuff_Y"]/adj)
		adBuffBarTargetDebuff1:SetAnchor("RIGHT","LEFT","adBuffBarTargetBuff1",adBBSet["TargetDebuff_X"]/adj,adBBSet["TargetDebuff_Y"]/adj)
	elseif v=="RIGHT" then
		adBuffBarPlayerDebuff1:ClearAllAnchors()
		adBuffBarTargetDebuff1:ClearAllAnchors()
		adBuffBarPlayerDebuff1:SetAnchor("LEFT","RIGHT","adBuffBarPlayerBuff1",adBBSet["PlayerDebuff_X"]/adj,adBBSet["PlayerDebuff_Y"]/adj)
		adBuffBarTargetDebuff1:SetAnchor("LEFT","RIGHT","adBuffBarTargetBuff1",adBBSet["TargetDebuff_X"]/adj,adBBSet["TargetDebuff_Y"]/adj)
	end
end

function adBuffBar.GUI_SkinMenuShow()
	for i, v in ipairs(skins) do
		UIDropDownMenu_AddButton({
			value = i,
			text = v,
			func = DefineSkin,
		})
	end
end

function adBuffBar.GUI_SwitchSkin()
	if adBBSet["value"]==8 then
		SetSkin("Interface/Common/barfill")
		adBBSet["value"] = 1
	else
		SetSkin("Interface/Common/Bar/"..skins[adBBSet.value + 1])
		adBBSet["value"] = adBBSet["value"] + 1
	end
	UIDropDownMenu_SetSelectedID(adBuffBarGUISkinMenu, adBBSet["value"])
end

local function TimeFormat(t)
	local m = math.floor(t/60)
	local h = math.floor(m/60)
	local d = math.floor(h/24)
	if d>=1 then
		return string.format("%d%s%d%s", d, UNIT_DAY, h-(d*24), UNIT_HOUR)
	elseif m>=60 then
		return string.format("%d%s%d%s", h, UNIT_HOUR, m-(h*60), UNIT_MINUTE)
	elseif m>=1 then
		return string.format("%d:%02d", m, t-(m*60))
	elseif m<1 then
		return string.format("%.1f%s", t, UNIT_SECOND)
	end
end

local function Snap(this, i)
	if i==0 then i = 1 end
	GUI_Anchor(adBBSet["Snap"])
	if adBBSet["Snap"]=="TOP" then
		if this.Buff=="debuff" then
			if this.Unit=="player" then
				adBuffBarPlayerBuff1:ClearAllAnchors()
				adBuffBarPlayerBuff1:SetAnchor("TOP","BOTTOM","adBuffBarPlayerDebuff"..i,0,0)
			else
				adBuffBarTargetBuff1:ClearAllAnchors()
				adBuffBarTargetBuff1:SetAnchor("TOP","BOTTOM","adBuffBarTargetDebuff"..i,0,0)
			end
		end
	elseif adBBSet["Snap"]=="BOTTOM" then
		if this.Buff=="buff" then
			if this.Unit=="player" then
				adBuffBarPlayerDebuff1:ClearAllAnchors()
				adBuffBarPlayerDebuff1:SetAnchor("TOP","BOTTOM","adBuffBarPlayerBuff"..i,0,0)
			else
				adBuffBarTargetDebuff1:ClearAllAnchors()
				adBuffBarTargetDebuff1:SetAnchor("TOP","BOTTOM","adBuffBarTargetBuff"..i,0,0)
			end
		end
	end
end

function adBuffBar.Load(this)
	this.Unit = string.lower(this:GetName():sub(10, 15))
	this.Buff = string.match(this:GetName():lower(), "adbuffbar"..this.Unit.."(%a+)")
	if this.Unit=="player" and this.Buff=="buff" then
		this:RegisterForClicks("RightButton")
	end
end

function adBuffBar.Click(this)
	if this.Unit=="player" and this.Buff=="buff" then
		CancelPlayerBuff(this:GetID())
	end
end

function adBuffBar.Enter(this)
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT")
	if this.Buff=="debuff" then
		GameTooltip:SetUnitDebuff(this.Unit, this:GetID())
	else
		GameTooltip:SetUnitBuff(this.Unit, this:GetID())
	end
end

function adBuffBar.Down(this, key)
	if IsShiftKeyDown() and key=="RBUTTON" then
		_G[this:GetParent():GetName().."1"]:StartMoving()
	end
end

function adBuffBar.Up(this)
	local adj = adBBSet["BarScale"]
	_G[this:GetParent():GetName().."1"]:StopMovingOrSizing()
	local _, _, _, x, y = _G[this:GetParent():GetName().."1"]:GetAnchor()
	if adBBSet["Snap"]=="TOP" then
		adBBSet[this:GetParent():GetName():sub(10,15).."Buff_X"] = x * adj
		adBBSet[this:GetParent():GetName():sub(10,15).."Buff_Y"] = y * adj
	else
		adBBSet[this:GetParent():GetName():sub(10).."_X"] = x * adj
		adBBSet[this:GetParent():GetName():sub(10).."_Y"] = y * adj
	end
end

function adBuffBar.UpdateBar(this, vload)
	local name, texture, count, ID, leftTime
	if this.Buff=="debuff" then
		name, texture, count, ID = UnitDebuff(this.Unit, this:GetID())
	else
		name, texture, count, ID = UnitBuff(this.Unit, this:GetID())
	end
	if not name and this:IsVisible() then
		this:Hide()
		_G[this:GetName().."Name"]:SetText(NONE)
		Snap(this, this:GetID()-1)
	elseif name and (name~=_G[this:GetName().."Name"]:GetText() or vload) then
		if this.Buff=="debuff" then
			leftTime = UnitDebuffLeftTime(this.Unit, this:GetID())
		else
			leftTime = UnitBuffLeftTime(this.Unit, this:GetID())
		end
		if leftTime then
			if not adBuffBarDB[ID] or leftTime>adBuffBarDB[ID] then
				adBuffBarDB[ID] = math.ceil(leftTime*10)/10
			end
		end
		local spark = _G[this:GetName().."Spark"]
		if this.Unit=="target" then
			if this.Buff=="debuff" then
				this:SetBarColor(adBBSet["ColorsTargetDebuffs"].r, adBBSet["ColorsTargetDebuffs"].g, adBBSet["ColorsTargetDebuffs"].b)
				spark:SetColor(adBBSet["ColorsTargetDebuffs"].r, adBBSet["ColorsTargetDebuffs"].g, adBBSet["ColorsTargetDebuffs"].b)
			else
				this:SetBarColor(adBBSet["ColorsTargetBuffs"].r, adBBSet["ColorsTargetBuffs"].g, adBBSet["ColorsTargetBuffs"].b)
				spark:SetColor(adBBSet["ColorsTargetBuffs"].r, adBBSet["ColorsTargetBuffs"].g, adBBSet["ColorsTargetBuffs"].b)
			end
		else
			if this.Buff=="debuff" then
				this:SetBarColor(adBBSet["ColorsPlayerDebuffs"].r, adBBSet["ColorsPlayerDebuffs"].g, adBBSet["ColorsPlayerDebuffs"].b)
				spark:SetColor(adBBSet["ColorsPlayerDebuffs"].r, adBBSet["ColorsPlayerDebuffs"].g, adBBSet["ColorsPlayerDebuffs"].b)
			else
				this:SetBarColor(adBBSet["ColorsPlayerBuffs"].r, adBBSet["ColorsPlayerBuffs"].g, adBBSet["ColorsPlayerBuffs"].b)
				spark:SetColor(adBBSet["ColorsPlayerBuffs"].r, adBBSet["ColorsPlayerBuffs"].g, adBBSet["ColorsPlayerBuffs"].b)
			end
		end
		if count<1 then
			count = ""
		end
		_G[this:GetName().."Icon"]:SetTexture(texture)
		_G[this:GetName().."Name"]:SetText(name)
		_G[this:GetName().."Count"]:SetText(count)
		local duration = _G[this:GetName().."Duration"]
		duration:Hide()
		duration:SetColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		spark:Hide()
		this:Show()
		this:SetValue(100)
		this:SetAlpha(1)
		Snap(this, this:GetID())
	end
end

function adBuffBar.OnBarEvent(this)
	if (this.Buff=="buff" and this:GetID()<=adBBSet["BuffsAmount"])
	or (this.Buff=="debuff" and this:GetID()<=adBBSet["DebuffsAmount"]) then
		if arg1=="player" or arg1=="target" then
			adBuffBar.UpdateBar(this)
		end
	elseif this:IsVisible() then
		this:Hide()
	end
end

function adBuffBar.OnBarUpdate(this)
	local ID, leftTime, sparkPosition
	
	if this.Buff=="debuff" then
		leftTime = UnitDebuffLeftTime(this.Unit, this:GetID())
		_, _, _, ID = UnitDebuff(this.Unit, this:GetID())
	else
		leftTime = UnitBuffLeftTime(this.Unit, this:GetID())
		_, _, _, ID = UnitBuff(this.Unit, this:GetID())
	end
	
	if leftTime then
		local spark = _G[this:GetName().."Spark"]
		local duration = _G[this:GetName().."Duration"]
		duration:Show()
		if adBBSet["ShortTime"] then
			duration:SetText(SecondsToTimeAbbrev(leftTime))
		else
			duration:SetText(TimeFormat(leftTime))
		end
		if adBBSet["WarningTime"] then
			if leftTime<adBBSet["WarningTime"] then
				duration:SetColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
				if adBBSet["Flash"] and not adBBSet["WarningRed"] then
					this:SetAlpha(BUFF_ALPHA_VALUE)
				elseif adBBSet["Flash"] and adBBSet["WarningRed"] then
					this:SetBarColor(BUFF_ALPHA_VALUE, 0.5, 0.5)
					spark:SetColor(BUFF_ALPHA_VALUE, 0.5, 0.5)
				elseif adBBSet["WarningRed"] then
					this:SetAlpha(1)
					this:SetBarColor(1, 0, 0)
					spark:SetColor(1, 0, 0)
				end
			end
		end
		if adBBSet["Fills"] then
			local leftPer = (adBuffBarDB[ID]~=nil and leftTime/adBuffBarDB[ID]) or 1
			local barWidth = adBBSet["BarWidth"]
			if adBBSet["InvertFilling"] then
				this:SetValue(100-leftPer*100)
				sparkPosition = (1-leftPer) * barWidth
			else
				this:SetValue(leftPer*100)
				sparkPosition = leftPer * barWidth
			end
			spark:Show()
			spark:ClearAllAnchors()
			spark:SetAnchor("CENTER", "LEFT", _G[this:GetName()], sparkPosition, 0)
		end
	end
end
