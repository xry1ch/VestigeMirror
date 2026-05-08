VestigeMirror = VestigeMirror or {}
VestigeMirror.Preview = {}

function VestigeMirror.Preview:Initialize()
    self.active = false
    self.usingCurrentAppearance = false
end

local function GetActiveCostumeCollectible()
    if not GetActiveCollectibleByType or not COLLECTIBLE_CATEGORY_TYPE_COSTUME then
        return nil
    end

    local collectibleId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
    if collectibleId and collectibleId > 0 then
        return collectibleId
    end

    return nil
end

function VestigeMirror.Preview:ShowAppearance(appearance)
    if not ITEM_PREVIEW_KEYBOARD then
        return
    end

    self.usingCurrentAppearance = false

    if GetActiveCostumeCollectible() then
        if ITEM_PREVIEW_KEYBOARD.ClearPreviewCollection then
            ITEM_PREVIEW_KEYBOARD:ClearPreviewCollection()
        elseif ClearCurrentItemPreviewCollection then
            ClearCurrentItemPreviewCollection()
        end
        if ApplyChangesToPreviewCollectionShown then
            ApplyChangesToPreviewCollectionShown()
        end
        self.usingCurrentAppearance = true
    elseif appearance.outfitIndex then
        ITEM_PREVIEW_KEYBOARD:PreviewOutfit(appearance.actorCategory, appearance.outfitIndex)
    else
        ITEM_PREVIEW_KEYBOARD:PreviewUnequipOutfit(appearance.actorCategory)
    end

    self.active = true
end

function VestigeMirror.Preview:Hide()
    if not self.active then
        return
    end

    if ITEM_PREVIEW_KEYBOARD then
        if self.usingCurrentAppearance and ITEM_PREVIEW_KEYBOARD.ClearPreviewCollection then
            ITEM_PREVIEW_KEYBOARD:ClearPreviewCollection()
        else
            ITEM_PREVIEW_KEYBOARD:ResetOutfitPreview()
        end
    end

    self.active = false
    self.usingCurrentAppearance = false
end
