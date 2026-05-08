VestigeMirror = VestigeMirror or {}
VestigeMirror.UI = {}

local LEFT_ARMOR_SLOTS =
{
    Head = true,
    Chest = true,
    Hands = true,
    Waist = true,
}

local RIGHT_ARMOR_SLOTS =
{
    Shoulders = true,
    Legs = true,
    Feet = true,
}

local TEXTURES =
{
    { name = "None" },
    { name = "Rourken Steamguards", path = "/art/fx/texture/rourkensteamguards_overlay.dds" },
    { name = "Arcanist Ring 01", path = "/art/fx/texture/arcanist_textring_01.dds" },
    { name = "Arcanist Ring 02", path = "/art/fx/texture/arcanist_textring_02.dds" },
    { name = "Arcanist Ring 03", path = "/art/fx/texture/arcanist_textring_03.dds" },
    { name = "Conversation Text Background", path = "/esoui/art/interaction/conversation_textbg.dds" },
    { name = "Empty Vortex", path = "/art/fx/texture/emptyvortex.dds" },
    { name = "Daedric Text", path = "/esoui/art/pregameanimatedbackground/onetamriel/daedrictext.dds" },
    { name = "Blood Bib", path = "/art/fx/texture/fxmaterial/bloodbib.dds" },
    { name = "Blood Splatters 4x4", path = "/art/fx/texture/bloodsplatters4x4.dds" },
    { name = "Cherry Blossom Ground", path = "/art/fx/texture/cherryblossomground_01.dds" },
    { name = "Ouroboros Loading Bloom", path = "/esoui/art/pregameanimatedbackground/ouroboros_loading_bloom.dds" },
    { name = "Wood Station Rune", path = "/art/fx/texture/wood_station_rune01.dds" },
    { name = "Avatar Activation Rune Glow", path = "/art/fx/texture/fxmaterial/skr_duc_avataractivationrune01_glow.dds" },
    { name = "Holy Rune Sigil", path = "/art/fx/texture/sigilholyrunes.dds" },
    { name = "Rune Circle Sigil", path = "/art/fx/texture/sigil_runecircle_01.dds" },
    { name = "Magic Rune Sigil", path = "/art/fx/texture/sigil_magicrune.dds" },
    { name = "Julianos Dwarven Spider Sigil", path = "/art/fx/texture/sigil_julianos_runed_dwarvenspider_whole.dds" },
    { name = "Daedric Rune Half 2", path = "/art/fx/texture/sigil_daedricrune_half2.dds" },
    { name = "Daedric Rune Half 1", path = "/art/fx/texture/sigil_daedricrune_half1.dds" },
    { name = "Daedric Rune 03", path = "/art/fx/texture/sigil_daedricrune_03.dds" },
    { name = "Daedric Rune 02", path = "/art/fx/texture/sigil_daedricrune_02.dds" },
    { name = "Daedric Rune 01", path = "/art/fx/texture/sigil_daedricrune_01.dds" },
    { name = "Ancestor Moth Rune Ring", path = "/art/fx/texture/sigil_ancestormothrunering.dds" },
    { name = "Enchanting Lines 1", path = "/art/fx/texture/runes_enchanting_lines1.dds" },
    { name = "Enchanting Lines", path = "/art/fx/texture/runes_enchanting_lines.dds" },
    { name = "Runic Armor Rune", path = "/art/fx/texture/arcanist_tank4_runicarmor_rune.dds" },
    { name = "Portal Ground Rune", path = "/art/fx/texture/arcanist_support_portalgroundrune_02.dds" },
    { name = "Battleground Green Loss Banner", path = "/esoui/art/battlegrounds/battleground_banner_green_loss.dds" },
    { name = "Battleground Orange Loss Banner", path = "/esoui/art/battlegrounds/battleground_banner_orange_loss.dds" },
    { name = "Battleground Banner Header", path = "/esoui/art/battlegrounds/battleground_banner_header.dds" },
    { name = "Tribute Leaderboard Top 10", path = "/esoui/art/tribute/tributeendofgameleaderboardbackdrop_top10.dds" },
    { name = "Tribute Leaderboard Top 2", path = "/esoui/art/tribute/tributeendofgameleaderboardbackdrop_top2.dds" },
    { name = "Tribute Leaderboard Standard", path = "/esoui/art/tribute/tributeendofgameleaderboardbackdrop_standard.dds" },
    { name = "Tribute Victory Banner", path = "/esoui/art/tribute/tributeendofgamebanner_victory.dds" },
    { name = "Tribute Defeat Banner", path = "/esoui/art/tribute/tributeendofgamebanner_defeat.dds" },
    { name = "Tribute Targeted Card Overlay", path = "/esoui/art/tribute/overlays/tributecardoverlay_targeted.dds" },
    { name = "Tribute Contract Banner", path = "/esoui/art/tribute/tributecardcontractbanner.dds" },
    { name = "Tribute Card Back Highlight", path = "/esoui/art/tribute/tributecardback_highlight.dds" },
    { name = "Vampire Sigil", path = "/art/fx/texture/sigil_vampire.dds" },
    { name = "Vampire Door Sigil", path = "/art/fx/texture/sigil_vampire_door.dds" },
}

local BASE_TEXTURE_WIDTH = 1024
local BASE_TEXTURE_HEIGHT = 1024
local MIN_TEXTURE_SCALE = 0.25
local MAX_TEXTURE_SCALE = 3

local function Clamp(value, minimum, maximum)
    if value < minimum then
        return minimum
    elseif value > maximum then
        return maximum
    end

    return value
end

local function SetDye(control, dye)
    local alpha = dye.empty and 0.55 or 1
    control:SetCenterColor(dye.r, dye.g, dye.b, alpha)
    control:SetEdgeColor(0, 0, 0, 1)
    control:SetMouseEnabled(true)
    control:SetHandler("OnMouseEnter", function()
        InitializeTooltip(InformationTooltip, control, BOTTOM, 0, -4)
        SetTooltipText(InformationTooltip, dye.name)
    end)
    control:SetHandler("OnMouseExit", function()
        ClearTooltip(InformationTooltip)
    end)
end

local function ConfigureCalloutSide(callout, side)
    local iconFrame = callout:GetNamedChild("IconFrame")
    local icon = callout:GetNamedChild("Icon")
    local slotLabel = callout:GetNamedChild("Slot")
    local name = callout:GetNamedChild("Name")
    local meta = callout:GetNamedChild("Meta")
    local dyeName1 = callout:GetNamedChild("DyeName1")
    local dyeName2 = callout:GetNamedChild("DyeName2")
    local dyeName3 = callout:GetNamedChild("DyeName3")
    local dye1 = callout:GetNamedChild("Dye1")
    local dye2 = callout:GetNamedChild("Dye2")
    local dye3 = callout:GetNamedChild("Dye3")
    local readability = callout:GetNamedChild("Readability")

    readability:ClearAnchors()
    iconFrame:ClearAnchors()
    icon:ClearAnchors()
    slotLabel:ClearAnchors()
    name:ClearAnchors()
    meta:ClearAnchors()
    dyeName1:ClearAnchors()
    dyeName2:ClearAnchors()
    dyeName3:ClearAnchors()
    dye1:ClearAnchors()
    dye2:ClearAnchors()
    dye3:ClearAnchors()

    if side == "right" then
        slotLabel:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
        name:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
        meta:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
        dyeName1:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
        dyeName2:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
        dyeName3:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)
        readability:SetAnchor(TOPRIGHT, callout, TOPRIGHT, -76, 12)
        iconFrame:SetAnchor(TOPRIGHT, callout, TOPRIGHT, -12, 36)
        icon:SetAnchor(CENTER, iconFrame, CENTER, 0, 0)
        slotLabel:SetAnchor(TOPRIGHT, readability, TOPRIGHT, -10, 8)
        name:SetAnchor(TOPRIGHT, slotLabel, BOTTOMRIGHT, 0, -1)
        meta:SetAnchor(TOPRIGHT, name, BOTTOMRIGHT, 0, -1)
        dye1:SetAnchor(TOPRIGHT, meta, BOTTOMRIGHT, 0, 8)
        dyeName1:SetAnchor(RIGHT, dye1, LEFT, -6, 0)
        dye2:SetAnchor(TOPRIGHT, dye1, BOTTOMRIGHT, 0, 3)
        dyeName2:SetAnchor(RIGHT, dye2, LEFT, -6, 0)
        dye3:SetAnchor(TOPRIGHT, dye2, BOTTOMRIGHT, 0, 3)
        dyeName3:SetAnchor(RIGHT, dye3, LEFT, -6, 0)
    else
        slotLabel:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
        name:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
        meta:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
        dyeName1:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
        dyeName2:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
        dyeName3:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
        readability:SetAnchor(TOPLEFT, callout, TOPLEFT, 76, 12)
        iconFrame:SetAnchor(TOPLEFT, callout, TOPLEFT, 12, 36)
        icon:SetAnchor(CENTER, iconFrame, CENTER, 0, 0)
        slotLabel:SetAnchor(TOPLEFT, readability, TOPLEFT, 10, 8)
        name:SetAnchor(TOPLEFT, slotLabel, BOTTOMLEFT, 0, -1)
        meta:SetAnchor(TOPLEFT, name, BOTTOMLEFT, 0, -1)
        dye1:SetAnchor(TOPLEFT, meta, BOTTOMLEFT, 0, 8)
        dyeName1:SetAnchor(LEFT, dye1, RIGHT, 6, 0)
        dye2:SetAnchor(TOPLEFT, dye1, BOTTOMLEFT, 0, 4)
        dyeName2:SetAnchor(LEFT, dye2, RIGHT, 6, 0)
        dye3:SetAnchor(TOPLEFT, dye2, BOTTOMLEFT, 0, 4)
        dyeName3:SetAnchor(LEFT, dye3, RIGHT, 6, 0)
    end
end

local function SetupCallout(callout, slot, side)
    ConfigureCalloutSide(callout, side)

    callout:GetNamedChild("Icon"):SetTexture(slot.icon)
    callout:GetNamedChild("Slot"):SetText(slot.label)
    callout:GetNamedChild("Name"):SetText(slot.name)

    local meta = slot.source
    if slot.materialName and slot.materialName ~= "" then
        meta = string.format("%s - %s", meta, slot.materialName)
    end
    callout:GetNamedChild("Meta"):SetText(meta)

    local name = callout:GetNamedChild("Name")
    local icon = callout:GetNamedChild("Icon")
    if slot.isEmpty then
        name:SetColor(0.56, 0.59, 0.62, 1)
        icon:SetAlpha(0.55)
    else
        name:SetColor(0.95, 0.91, 0.82, 1)
        icon:SetAlpha(1)
    end

    for dyeIndex = 1, 3 do
        SetDye(callout:GetNamedChild("Dye" .. dyeIndex), slot.dyes[dyeIndex])
    end

    callout:GetNamedChild("DyeName1"):SetText(slot.dyes[1].name)
    callout:GetNamedChild("DyeName2"):SetText(slot.dyes[2].name)
    callout:GetNamedChild("DyeName3"):SetText(slot.dyes[3].name)
end

local function AnchorCallout(callout, parent, previousCallout, index, layout)
    callout:ClearAnchors()
    if layout == "horizontal" then
        if index == 1 then
            callout:SetAnchor(LEFT, parent, LEFT, 0, 0)
        else
            callout:SetAnchor(LEFT, previousCallout, RIGHT, 28, 0)
        end
    else
        if index == 1 then
            callout:SetAnchor(TOPLEFT, parent, TOPLEFT, 0, 0)
        else
            callout:SetAnchor(TOPLEFT, previousCallout, BOTTOMLEFT, 0, 26)
        end
    end
end

local function AcquireCallouts(parent, callouts, slots, layout, side)
    parent:SetHidden(#slots == 0)

    for index, callout in ipairs(callouts) do
        callout:SetHidden(index > #slots)
    end

    for index, slot in ipairs(slots) do
        local callout = callouts[index]
        if not callout then
            callout = WINDOW_MANAGER:CreateControlFromVirtual(parent:GetName() .. "Callout" .. index, parent, "VestigeMirrorItemCallout")
            callouts[index] = callout
        end

        AnchorCallout(callout, parent, callouts[index - 1], index, layout)
        SetupCallout(callout, slot, side)
        callout:SetHidden(false)
    end
end

local function SplitArmorSlots(slots)
    local leftSlots = {}
    local rightSlots = {}

    for _, slot in ipairs(slots) do
        if LEFT_ARMOR_SLOTS[slot.label] then
            table.insert(leftSlots, slot)
        elseif RIGHT_ARMOR_SLOTS[slot.label] then
            table.insert(rightSlots, slot)
        end
    end

    return leftSlots, rightSlots
end

local function SetTextButtonHandler(control, callback)
    control:SetMouseEnabled(true)
    control:SetHandler("OnMouseDown", function(_, button)
        if button == MOUSE_BUTTON_INDEX_LEFT then
            callback()
        end
    end)
end

function VestigeMirror.UI:Initialize(control)
    self.control = control
    self.leftCallouts = {}
    self.rightCallouts = {}
    self.weaponCallouts = {}
    self.selectedTextureIndex = 1
    self.textureScale = 1
    self.textureOffsetX = 0
    self.textureOffsetY = 0
    self.textureDragging = false
    self.textureMoveMode = false
    self.texture = VestigeMirrorWindowTexture
    self.textureMoveLayer = VestigeMirrorTextureMoveLayer
    self.textureBar = VestigeMirrorTextureBar
    self.textureNext = self.textureBar:GetNamedChild("TextureNext")
    self.texturePrevious = self.textureBar:GetNamedChild("TexturePrevious")
    self.scaleDown = self.textureBar:GetNamedChild("ScaleDown")
    self.scaleUp = self.textureBar:GetNamedChild("ScaleUp")
    self.moveTexture = self.textureBar:GetNamedChild("MoveTexture")
    self.textureNextLabel = self.textureNext:GetNamedChild("Label")
    self.moveTextureLabel = self.moveTexture:GetNamedChild("Label")

    SetTextButtonHandler(self.textureNext, function()
        self:CycleTexture(1)
    end)
    SetTextButtonHandler(self.texturePrevious, function()
        self:CycleTexture(-1)
    end)
    SetTextButtonHandler(self.scaleDown, function()
        self:AdjustTextureScale(-0.1)
    end)
    SetTextButtonHandler(self.scaleUp, function()
        self:AdjustTextureScale(0.1)
    end)
    SetTextButtonHandler(self.moveTexture, function()
        self:ToggleTextureMoveMode()
    end)

    control:SetHandler("OnKeyDown", function(_, key)
        if key == KEY_ESCAPE then
            if self.textureMoveMode then
                self:SetTextureMoveMode(false)
                return
            end
            VestigeMirror:Hide()
        end
    end)

    self.textureMoveLayer:SetHandler("OnMouseDown", function(_, button)
        if button ~= MOUSE_BUTTON_INDEX_LEFT or not self.textureMoveMode or not self:IsTextureVisible() then
            return
        end

        local mouseX, mouseY = GetUIMousePosition()
        self.textureDragging = true
        self.textureDragStartMouseX = mouseX
        self.textureDragStartMouseY = mouseY
        self.textureDragStartOffsetX = self.textureOffsetX
        self.textureDragStartOffsetY = self.textureOffsetY
    end)

    self.textureMoveLayer:SetHandler("OnMouseUp", function()
        self.textureDragging = false
    end)

    self.textureMoveLayer:SetHandler("OnUpdate", function()
        if not self.textureDragging then
            return
        end

        if IsMouseButtonDown and not IsMouseButtonDown(MOUSE_BUTTON_INDEX_LEFT) then
            self.textureDragging = false
            return
        end

        local mouseX, mouseY = GetUIMousePosition()
        self.textureOffsetX = self.textureDragStartOffsetX + mouseX - self.textureDragStartMouseX
        self.textureOffsetY = self.textureDragStartOffsetY + mouseY - self.textureDragStartMouseY
        self:ApplyTextureState()
    end)

    self:ApplyTextureState()
end

function VestigeMirror.UI:IsShowing()
    return self.control and not self.control:IsHidden()
end

function VestigeMirror.UI:IsTextureVisible()
    local texture = TEXTURES[self.selectedTextureIndex]
    return texture and texture.path ~= nil
end

function VestigeMirror.UI:GetSelectedTextureName()
    local texture = TEXTURES[self.selectedTextureIndex] or TEXTURES[1]
    return texture.name
end

function VestigeMirror.UI:RefreshTextureControls()
    self.textureNextLabel:SetText(string.format("Texture: %s", self:GetSelectedTextureName()))
    self.moveTextureLabel:SetText(self.textureMoveMode and "Done Moving Texture" or "Move Texture")
    self.moveTexture:SetMouseEnabled(self:IsTextureVisible())
    self.moveTextureLabel:SetColor(0.96, 0.94, 0.87, self:IsTextureVisible() and 1 or 0.45)
end

function VestigeMirror.UI:ShowTextureKeybinds()
    self.textureBar:SetHidden(false)
    self:RefreshTextureControls()
end

function VestigeMirror.UI:HideTextureKeybinds()
    self:ResetTextureState()
    self.textureBar:SetHidden(true)
end

function VestigeMirror.UI:ResetTextureState()
    self.selectedTextureIndex = 1
    self.textureScale = 1
    self.textureOffsetX = 0
    self.textureOffsetY = 0
    self:SetTextureMoveMode(false)
    self:ApplyTextureState()
end

function VestigeMirror.UI:SetTextureMoveMode(enabled)
    self.textureMoveMode = enabled and self:IsTextureVisible() or false
    self.textureDragging = false
    self.textureMoveLayer:SetHidden(not self.textureMoveMode)
    self:RefreshTextureControls()
end

function VestigeMirror.UI:ToggleTextureMoveMode()
    self:SetTextureMoveMode(not self.textureMoveMode)
end

function VestigeMirror.UI:ApplyTextureState()
    local texture = TEXTURES[self.selectedTextureIndex] or TEXTURES[1]

    if not texture.path then
        self.texture:SetHidden(true)
        self:SetTextureMoveMode(false)
        self:RefreshTextureControls()
        return
    end

    local width = BASE_TEXTURE_WIDTH * self.textureScale
    local height = BASE_TEXTURE_HEIGHT * self.textureScale

    self.texture:SetTexture(texture.path)
    self.texture:SetDimensions(width, height)
    self.texture:ClearAnchors()
    self.texture:SetAnchor(CENTER, self.control, CENTER, self.textureOffsetX, self.textureOffsetY)
    self.texture:SetHidden(false)
    self:RefreshTextureControls()
end

function VestigeMirror.UI:CycleTexture(delta)
    self.selectedTextureIndex = ((self.selectedTextureIndex - 1 + delta) % #TEXTURES) + 1
    self:ApplyTextureState()
end

function VestigeMirror.UI:AdjustTextureScale(delta)
    self.textureScale = Clamp(self.textureScale + delta, MIN_TEXTURE_SCALE, MAX_TEXTURE_SCALE)
    self:ApplyTextureState()
end

function VestigeMirror_TexturePrevious()
    VestigeMirror.UI:CycleTexture(-1)
end

function VestigeMirror_TextureNext()
    VestigeMirror.UI:CycleTexture(1)
end

function VestigeMirror_TextureScaleDown()
    VestigeMirror.UI:AdjustTextureScale(-0.1)
end

function VestigeMirror_TextureScaleUp()
    VestigeMirror.UI:AdjustTextureScale(0.1)
end

function VestigeMirror.UI:Refresh(appearance)
    self.control:GetNamedChild("Subtitle"):SetText(appearance.outfitName)

    local leftArmorSlots, rightArmorSlots = SplitArmorSlots(appearance.armorSlots)
    AcquireCallouts(self.control:GetNamedChild("LeftCallouts"), self.leftCallouts, leftArmorSlots, nil, "left")
    AcquireCallouts(self.control:GetNamedChild("RightCallouts"), self.rightCallouts, rightArmorSlots, nil, "right")
    AcquireCallouts(self.control:GetNamedChild("BottomCallouts"), self.weaponCallouts, appearance.weaponSlots, "horizontal", "left")
end
