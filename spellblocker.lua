local addonName, _ = ...
SpellBlockerDB = SpellBlockerDB or {}
SpellBlockerBlockAllPos = SpellBlockerBlockAllPos or {}
SpellBlockerLastActiveTab = SpellBlockerLastActiveTab or nil
SpellBlockerMinimapPos = SpellBlockerMinimapPos or 45  -- Standard-Position bei 45 Grad

local SPELLS = {
    WARRIOR = {
        { id = 12292, name = "Death Wish", tooltip = "Blocks Death Wish" },
        { id = 1719,  name = "Recklessness", tooltip = "Blocks Recklessness" },
        { id = 12975, name = "Last Stand", tooltip = "Blocks Last Stand" },
        { id = 23920, name = "Spell Reflection", tooltip = "Blocks Spell Reflection" },
        { id = 46924, name = "Bladestorm", tooltip = "Blocks Bladestorm" },
        { id = 2565,  name = "Shield Block", tooltip = "Blocks Shield Block" },
        { id = 12809, name = "Concussion Blow", tooltip = "Blocks Concussion Blow" },
        { id = 6552,  name = "Pummel", tooltip = "Blocks Pummel" },
        { id = 5246,  name = "Intimidating Shout", tooltip = "Blocks Intimidating Shout" },
        { id = 676,   name = "Disarm", tooltip = "Blocks Disarm" },
        { id = 20230, name = "Retaliation", tooltip = "Blocks Retaliation" },
        { id = 871,   name = "Shield Wall", tooltip = "Blocks Shield Wall" },
        { id = 1161,  name = "Challenging Shout", tooltip = "Blocks Challenging Shout" },
        { id = 18499, name = "Berserker Rage", tooltip = "Blocks Berserker Rage" },
    },
PALADIN = {
    -- Healing/Support abilities first
    { id = 31842, name = "Divine Illumination", tooltip = "Blocks Divine Illumination" },
    { id = 20473, name = "Holy Shock", tooltip = "Blocks Holy Shock" },
    { id = 6940,  name = "Hand of Sacrifice", tooltip = "Blocks Hand of Sacrifice" },
    { id = 1022,  name = "Hand of Protection", tooltip = "Blocks Hand of Protection" },
    { id = 1044,  name = "Hand of Freedom", tooltip = "Blocks Hand of Freedom" },
    { id = 498,   name = "Divine Protection", tooltip = "Blocks Divine Protection" },
    { id = 54428, name = "Divine Plea", tooltip = "Blocks Divine Plea" },
    { id = 31821, name = "Aura Mastery", tooltip = "Blocks Aura Mastery" },
    -- Heal/Damage Separator
    { id = 0, name = "HEALER_SEPARATOR", tooltip = "Healing/Damage Separator" },
    -- Damage/offensive abilities
    { id = 31884, name = "Avenging Wrath", tooltip = "Blocks Avenging Wrath" },
    { id = 642,   name = "Divine Shield", tooltip = "Blocks Divine Shield" },
    { id = 20066, name = "Repentance", tooltip = "Blocks Repentance" },
    { id = 10308, name = "Hammer of Justice", tooltip = "Blocks Hammer of Justice" },
    { id = 31935, name = "Avenger's Shield", tooltip = "Blocks Avenger's Shield" },
    { id = 20925, name = "Holy Shield", tooltip = "Blocks Holy Shield" },
    -- Blessings Separator
    { id = 0, name = "BLESSING_SEPARATOR", tooltip = "Blessings Separator" },
    -- Blessings
    { id = 20217, name = "Blessing of Kings", tooltip = "Blocks Blessing of Kings" },
    { id = 25898, name = "Greater Blessing of Kings", tooltip = "Blocks Greater Blessing of Kings" },
    { id = 48932, name = "Blessing of Might", tooltip = "Blocks Blessing of Might" },
    { id = 48934, name = "Greater Blessing of Might", tooltip = "Blocks Greater Blessing of Might" },
    { id = 48936, name = "Blessing of Wisdom", tooltip = "Blocks Blessing of Wisdom" },
    { id = 48938, name = "Greater Blessing of Wisdom", tooltip = "Blocks Greater Blessing of Wisdom" },
    { id = 20911, name = "Blessing of Sanctuary", tooltip = "Blocks Blessing of Sanctuary" },
    { id = 25899, name = "Greater Blessing of Sanctuary", tooltip = "Blocks Greater Blessing of Sanctuary" },
    { id = 1038,  name = "Blessing of Salvation", tooltip = "Blocks Blessing of Salvation" },
    { id = 25895, name = "Greater Blessing of Salvation", tooltip = "Blocks Greater Blessing of Salvation" },
},
    DEATHKNIGHT = {
        { id = 48792, name = "Icebound Fortitude", tooltip = "Blocks Icebound Fortitude" },
        { id = 48707, name = "Anti-Magic Shell", tooltip = "Blocks Anti-Magic Shell" },
        { id = 49028, name = "Dancing Rune Weapon", tooltip = "Blocks Dancing Rune Weapon" },
        { id = 49222, name = "Bone Shield", tooltip = "Blocks Bone Shield" },
        { id = 55233, name = "Vampiric Blood", tooltip = "Blocks Vampiric Blood" },
        { id = 51052, name = "Anti-Magic Zone", tooltip = "Blocks Anti-Magic Zone" },
        { id = 48743, name = "Death Pact", tooltip = "Blocks Death Pact" },
        { id = 47476, name = "Strangulate", tooltip = "Blocks Strangulate" },
        { id = 47568, name = "Empower Rune Weapon", tooltip = "Blocks Empower Rune Weapon" },
        { id = 49016, name = "Hysteria", tooltip = "Blocks Hysteria" },
        { id = 49005, name = "Mark of Blood", tooltip = "Blocks Mark of Blood" },
        { id = 47481, name = "Gnaw (Ghoul)", tooltip = "Blocks Ghoul's Gnaw" },
        { id = 51271, name = "Unbreakable Armor", tooltip = "Blocks Unbreakable Armor" },
        { id = 49206, name = "Summon Gargoyle", tooltip = "Blocks Summon Gargoyle" },
        { id = 49039, name = "Lichborne", tooltip = "Blocks Lichborne" },
    },
    PRIEST = {
    { id = 10060, name = "Power Infusion", tooltip = "Blocks Power Infusion" },
    { id = 33206, name = "Pain Suppression", tooltip = "Blocks Pain Suppression" },
    { id = 47788, name = "Guardian Spirit", tooltip = "Blocks Guardian Spirit" },
    { id = 64843, name = "Divine Hymn", tooltip = "Blocks Divine Hymn" },
    { id = 64901, name = "Hymn of Hope", tooltip = "Blocks Hymn of Hope" },
    { id = 6346,  name = "Fear Ward", tooltip = "Blocks Fear Ward" },
    { id = 14751, name = "Inner Focus", tooltip = "Blocks Inner Focus" },
    { id = 47750, name = "Penance", tooltip = "Blocks Penance" },
    -- Separator hinzufügen
    { id = 0, name = "HEALER_SEPARATOR", tooltip = "Healing/Damage Separator" },
    -- Damage spells below
    { id = 47585, name = "Dispersion", tooltip = "Blocks Dispersion" },
    { id = 15487, name = "Silence", tooltip = "Blocks Silence" },
    { id = 10890, name = "Psychic Scream", tooltip = "Blocks Psychic Scream" },
    { id = 34433, name = "Shadowfiend", tooltip = "Blocks Shadowfiend" },
    { id = 15286, name = "Vampiric Embrace", tooltip = "Blocks Vampiric Embrace" },
    { id = 53023, name = "Mind Sear", tooltip = "Blocks Mind Sear" },
    { id = 48123, name = "Smite", tooltip = "Blocks Smite" },
    { id = 48135, name = "Holy Fire", tooltip = "Blocks Holy Fire" },
    { id = 48125, name = "Shadow Word: Pain", tooltip = "Blocks Shadow Word: Pain" },
    { id = 48158, name = "Shadow Word: Death", tooltip = "Blocks Shadow Word: Death" },
    { id = 48160, name = "Vampiric Touch", tooltip = "Blocks Vampiric Touch" },
    { id = 48127, name = "Mind Blast", tooltip = "Blocks Mind Blast" },
},
    MAGE = {
        { id = 45438, name = "Ice Block", tooltip = "Blocks Ice Block" },
        { id = 12042, name = "Arcane Power", tooltip = "Blocks Arcane Power" },
        { id = 12472, name = "Icy Veins", tooltip = "Blocks Icy Veins" },
        { id = 11958, name = "Cold Snap", tooltip = "Blocks Cold Snap" },
        { id = 31687, name = "Summon Water Elemental", tooltip = "Blocks Water Elemental" },
        { id = 55342, name = "Mirror Image", tooltip = "Blocks Mirror Image" },
        { id = 2139,  name = "Counterspell", tooltip = "Blocks Counterspell" },
        { id = 44572, name = "Deep Freeze", tooltip = "Blocks Deep Freeze" },
        { id = 44445, name = "Hot Streak", tooltip = "Blocks Hot Streak" },
        { id = 12051, name = "Evocation", tooltip = "Blocks Evocation" },
        { id = 12043, name = "Presence of Mind", tooltip = "Blocks Presence of Mind" },
        { id = 11129, name = "Combustion", tooltip = "Blocks Combustion" },
        { id = 43010, name = "Fire Ward", tooltip = "Blocks Fire Ward" },
        { id = 43012, name = "Frost Ward", tooltip = "Blocks Frost Ward" },
        { id = 1463,  name = "Mana Shield", tooltip = "Blocks Mana Shield" },
    },
    WARLOCK = {
        { id = 47241, name = "Metamorphosis", tooltip = "Blocks Metamorphosis" },
        { id = 18708, name = "Fel Domination", tooltip = "Blocks Fel Domination" },
        { id = 29858, name = "Soulshatter", tooltip = "Blocks Soulshatter" },
        { id = 47193, name = "Demonic Empowerment", tooltip = "Blocks Demonic Empowerment" },
        { id = 27243, name = "Seed of Corruption", tooltip = "Blocks Seed of Corruption" },
        { id = 19647, name = "Spell Lock", tooltip = "Blocks Felhunter's Spell Lock" },
        { id = 47847, name = "Shadowfury", tooltip = "Blocks Shadowfury" },
        { id = 48020, name = "Demonic Circle: Teleport", tooltip = "Blocks Demonic Circle: Teleport" },
        { id = 59671, name = "Challenging Howl", tooltip = "Blocks Voidwalker's Challenging Howl" },
        { id = 47860, name = "Death Coil", tooltip = "Blocks Death Coil" },
        { id = 47891, name = "Shadow Ward", tooltip = "Blocks Shadow Ward" },
        { id = 47883, name = "Soulshatter", tooltip = "Blocks Soulshatter" },
        { id = 47193, name = "Demonic Empowerment", tooltip = "Blocks Demonic Empowerment" },
        { id = 47996, name = "Intercept (Felguard)", tooltip = "Blocks Felguard's Intercept" },
    },
    ROGUE = {
        { id = 31224, name = "Cloak of Shadows", tooltip = "Blocks Cloak of Shadows" },
        { id = 5277,  name = "Evasion", tooltip = "Blocks Evasion" },
        { id = 11327, name = "Vanish", tooltip = "Blocks Vanish" },
        { id = 14177, name = "Cold Blood", tooltip = "Blocks Cold Blood" },
        { id = 14185, name = "Preparation", tooltip = "Blocks Preparation" },
        { id = 51690, name = "Killing Spree", tooltip = "Blocks Killing Spree" },
        { id = 51713, name = "Shadow Dance", tooltip = "Blocks Shadow Dance" },
        { id = 1766,  name = "Kick", tooltip = "Blocks Kick" },
        { id = 2094,  name = "Blind", tooltip = "Blocks Blind" },
        { id = 408,   name = "Kidney Shot", tooltip = "Blocks Kidney Shot" },
        { id = 51722, name = "Dismantle", tooltip = "Blocks Dismantle" },
        { id = 57934, name = "Tricks of the Trade", tooltip = "Blocks Tricks of the Trade" },
        { id = 13750, name = "Adrenaline Rush", tooltip = "Blocks Adrenaline Rush" },
        { id = 13877, name = "Blade Flurry", tooltip = "Blocks Blade Flurry" },
        { id = 36554, name = "Shadowstep", tooltip = "Blocks Shadowstep" },
    },
    HUNTER = {
        { id = 19263, name = "Deterrence", tooltip = "Blocks Deterrence" },
        { id = 3045,  name = "Rapid Fire", tooltip = "Blocks Rapid Fire" },
        { id = 34477, name = "Misdirection", tooltip = "Blocks Misdirection" },
        { id = 19574, name = "Bestial Wrath", tooltip = "Blocks Bestial Wrath" },
        { id = 23989, name = "Readiness", tooltip = "Blocks Readiness" },
        { id = 19503, name = "Scatter Shot", tooltip = "Blocks Scatter Shot" },
        { id = 19386, name = "Wyvern Sting", tooltip = "Blocks Wyvern Sting" },
        { id = 34490, name = "Silencing Shot", tooltip = "Blocks Silencing Shot" },
        { id = 53271, name = "Master's Call", tooltip = "Blocks Master's Call" },
        { id = 49012, name = "Wyvern Sting", tooltip = "Blocks Wyvern Sting" },
        { id = 53209, name = "Chimera Shot", tooltip = "Blocks Chimera Shot" },
        { id = 19577, name = "Intimidation", tooltip = "Blocks Intimidation" },
        { id = 34600, name = "Snake Trap", tooltip = "Blocks Snake Trap" },
        { id = 60192, name = "Freezing Arrow", tooltip = "Blocks Freezing Arrow" },
        { id = 49050, name = "Aimed Shot", tooltip = "Blocks Aimed Shot" },
    },
  SHAMAN = {
    { id = 16188, name = "Nature's Swiftness", tooltip = "Blocks Nature's Swiftness" },
    { id = 30823, name = "Shamanistic Rage", tooltip = "Blocks Shamanistic Rage" },
    { id = 16191, name = "Mana Tide Totem", tooltip = "Blocks Mana Tide Totem" },
    { id = 8143,  name = "Tremor Totem", tooltip = "Blocks Tremor Totem" },
    { id = 8177,  name = "Grounding Totem", tooltip = "Blocks Grounding Totem" },
    { id = 526,   name = "Cure Poison", tooltip = "Blocks Cure Poison" },
    { id = 49273, name = "Healing Wave", tooltip = "Blocks Healing Wave" },
    { id = 49276, name = "Lesser Healing Wave", tooltip = "Blocks Lesser Healing Wave" },
    { id = 51886, name = "Cleanse Spirit", tooltip = "Blocks Cleanse Spirit" },
    -- Separator hinzufügen
    { id = 0, name = "HEALER_SEPARATOR", tooltip = "Healing/Damage Separator" },
    -- Damage spells below
    { id = 16166, name = "Elemental Mastery", tooltip = "Blocks Elemental Mastery" },
    { id = 2825,  name = "Bloodlust", tooltip = "Blocks Bloodlust" },
    { id = 32182, name = "Heroism", tooltip = "Blocks Heroism" },
    { id = 51533, name = "Feral Spirit", tooltip = "Blocks Feral Spirit" },
    { id = 57994, name = "Wind Shear", tooltip = "Blocks Wind Shear" },
    { id = 51514, name = "Hex", tooltip = "Blocks Hex" },
    { id = 59159, name = "Thunderstorm", tooltip = "Blocks Thunderstorm" },
    { id = 49271, name = "Chain Lightning", tooltip = "Blocks Chain Lightning" },
    { id = 2062,  name = "Earth Elemental Totem", tooltip = "Blocks Earth Elemental Totem" },
    { id = 2894,  name = "Fire Elemental Totem", tooltip = "Blocks Fire Elemental Totem" },
    { id = 49238, name = "Lightning Bolt", tooltip = "Blocks Lightning Bolt" },
    { id = 49230, name = "Earth Shock", tooltip = "Blocks Earth Shock" },
    { id = 49233, name = "Flame Shock", tooltip = "Blocks Flame Shock" },
    { id = 49236, name = "Frost Shock", tooltip = "Blocks Frost Shock" },
    { id = 60043, name = "Lava Burst", tooltip = "Blocks Lava Burst" },
},
    -- Für Druide
DRUID = {
    { id = 22812, name = "Barkskin", tooltip = "Blocks Barkskin" },
    { id = 17116, name = "Nature's Swiftness", tooltip = "Blocks Nature's Swiftness" },
    { id = 18562, name = "Swiftmend", tooltip = "Blocks Swiftmend" },
    { id = 29166, name = "Innervate", tooltip = "Blocks Innervate" },
    { id = 9863,  name = "Tranquility", tooltip = "Blocks Tranquility" },
    { id = 48438, name = "Wild Growth", tooltip = "Blocks Wild Growth" },
    -- Separator hinzufügen
    { id = 0, name = "HEALER_SEPARATOR", tooltip = "Healing/Damage Separator" },
    -- Damage spells below
    { id = 50334, name = "Berserk", tooltip = "Blocks Berserk" },
    { id = 61336, name = "Survival Instincts", tooltip = "Blocks Survival Instincts" },
    { id = 33357, name = "Dash", tooltip = "Blocks Dash" },
    { id = 5211,  name = "Bash", tooltip = "Blocks Bash" },
    { id = 22570, name = "Maim", tooltip = "Blocks Maim" },
    { id = 48463, name = "Moonfire", tooltip = "Blocks Moonfire" },
    { id = 48465, name = "Starfire", tooltip = "Blocks Starfire" },
    { id = 48461, name = "Wrath", tooltip = "Blocks Wrath" },
    { id = 53307, name = "Thorns", tooltip = "Blocks Thorns" },
    { id = 48468, name = "Insect Swarm", tooltip = "Blocks Insect Swarm" },
    { id = 48564, name = "Mangle (Cat)", tooltip = "Blocks Mangle (Cat)" },
    { id = 48566, name = "Mangle (Bear)", tooltip = "Blocks Mangle (Bear)" },
    { id = 53201, name = "Starfall", tooltip = "Blocks Starfall" },
    { id = 5211,  name = "Bash", tooltip = "Blocks Bash" },
    { id = 22570, name = "Maim", tooltip = "Blocks Maim" },
},
}

-- SavedVariables initialisieren
local function InitDB()
    -- Prüfe, ob SpellBlockerDB existiert - wenn nicht, erstelle es
    if not SpellBlockerDB then 
        SpellBlockerDB = {} 
    end
    
    -- Für jede Klasse die DB initialisieren
    for className, spells in pairs(SPELLS) do
        if not SpellBlockerDB[className] then 
            SpellBlockerDB[className] = {} 
        end
        for _, spell in ipairs(spells) do
            if SpellBlockerDB[className][spell.id] == nil then
                -- Standardeinstellung: Zauber NICHT blockieren
                SpellBlockerDB[className][spell.id] = false
            end
        end
    end
end

-- Optionsfenster
local optionsFrame = CreateFrame("Frame", "SpellBlockerOptions", UIParent)
optionsFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
optionsFrame:SetBackdropColor(0,0,0,1)
optionsFrame:SetSize(650, 450)  -- Etwas größer für mehr Übersicht
optionsFrame:SetPoint("CENTER")
optionsFrame:SetMovable(true)
optionsFrame:EnableMouse(true)
optionsFrame:RegisterForDrag("LeftButton")
optionsFrame:SetScript("OnDragStart", optionsFrame.StartMoving)
optionsFrame:SetScript("OnDragStop", optionsFrame.StopMovingOrSizing)
optionsFrame:Hide()
optionsFrame.title = optionsFrame:CreateFontString(nil, "OVERLAY")
optionsFrame.title:SetFontObject("GameFontHighlight")
optionsFrame.title:SetPoint("TOP", optionsFrame, "TOP", 0, -10)
optionsFrame.title:SetText("SpellBlocker Options")


-- Schließen-Button (X) mit eindeutigem Namen und höherem Frame Level
local closeBtn = CreateFrame("Button", "SpellBlockerCloseButton", optionsFrame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", optionsFrame, "TOPRIGHT", -5, -5)
closeBtn:SetFrameLevel(optionsFrame:GetFrameLevel() + 10) -- Höheres Frame Level
closeBtn:SetScript("OnClick", function()
    optionsFrame:Hide()
end)

-- OK-Button unten rechts
local okBtn = CreateFrame("Button", "SpellBlockerOkButton", optionsFrame, "UIPanelButtonTemplate")
okBtn:SetSize(80, 22)
okBtn:SetPoint("BOTTOMRIGHT", optionsFrame, "BOTTOMRIGHT", -20, 20)
okBtn:SetFrameLevel(optionsFrame:GetFrameLevel() + 10) -- Höheres Frame Level
okBtn:SetText("OK")
okBtn:SetScript("OnClick", function()
    optionsFrame:Hide()
end)

-- Klassen-Tabs im Optionsfenster hinzufügen
local playerClass = select(2, UnitClass("player"))
local currentClass = playerClass  -- Nutze die Spielerklasse als Standard
local tabs = {}
local tabHeight = 24

-- Alle Tabs erstellen und am oberen Rand des Fensters platzieren
local function CreateClassTabs()
    local tabWidth = 40
    local tabHeight = 40
    local x = 20
    
    -- Klassen und ihre Icon-Koordinaten
    local classes = {
        {name = "WARRIOR",     coords = {0, 0.25, 0, 0.25}},
        {name = "PALADIN",     coords = {0, 0.25, 0.5, 0.75}},  -- Korrigiert
        {name = "DEATHKNIGHT", coords = {0.25, 0.5, 0.5, 0.75}},  -- Korrigiert für DK
        {name = "PRIEST",      coords = {0.5, 0.75, 0.25, 0.5}},
        {name = "MAGE",        coords = {0.25, 0.5, 0, 0.25}},
        {name = "WARLOCK",     coords = {0.75, 1, 0.25, 0.5}},
        {name = "ROGUE",       coords = {0.5, 0.75, 0, 0.25}},
        {name = "HUNTER",      coords = {0, 0.25, 0.25, 0.5}},  -- Korrigiert
        {name = "SHAMAN",      coords = {0.25, 0.5, 0.25, 0.5}},  -- Korrigiert für Shaman
        {name = "DRUID",       coords = {0.75, 1, 0, 0.25}}
    }

    for i, classData in ipairs(classes) do
        local tab = CreateFrame("Button", "SpellBlockerTab_"..classData.name, optionsFrame)
        tab:SetSize(tabWidth, tabHeight)
        tab:SetPoint("TOPLEFT", optionsFrame, "TOPLEFT", x, -35)
        tab.class = classData.name
        
        -- Klassen-Icon setzen
        local texture = tab:CreateTexture(nil, "ARTWORK")
        texture:SetTexture("Interface\\TargetingFrame\\UI-CLASSES-CIRCLES")
        texture:SetTexCoord(unpack(classData.coords))
        texture:SetAllPoints(tab)
        tab.texture = texture
        
        -- Highlight-Textur für Mouseover
        tab:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")
        
        -- Auswahlanzeige (Rahmen)
        local border = tab:CreateTexture(nil, "OVERLAY")
        border:SetTexture("Interface\\Buttons\\CheckButtonHilight")
        border:SetBlendMode("ADD")
        border:SetAllPoints(tab)
        border:Hide()
        tab.border = border
        
        -- Klick-Handler
        tab:SetScript("OnClick", function(self)
            currentClass = self.class
            SpellBlockerLastActiveTab = currentClass  -- Speichere die letzte Tab-Auswahl
            for _, t in ipairs(tabs) do
                t.border:Hide()
            end
            self.border:Show()
            RefreshClassSpellDisplay()
        end)
    
        -- Tooltip mit Klassennamen
        tab:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText(self.class, 1, 1, 1)
            GameTooltip:Show()
        end)
        tab:SetScript("OnLeave", function() 
            GameTooltip:Hide() 
        end)
        
        -- Initialisierung des Erscheinungsbildes
        if classData.name == currentClass then
            tab.border:Show()
        end
        
        table.insert(tabs, tab)
        x = x + tabWidth + 5
    end
end

-- Allgemeine Funktion, um zu prüfen, ob alle Spells einer Klasse blockiert sind
local function AreAllSpellsBlocked(class)
    for _, spell in ipairs(SPELLS[class]) do
        if not SpellBlockerDB[class][spell.id] then
            return false
        end
    end
    return true
end

-- Toggle-Button für die aktuelle Klasse aktualisieren
local function UpdateToggleButton()
    local toggleBtn = _G["SpellBlockerToggleAll_"..currentClass]
    if toggleBtn then
        if AreAllSpellsBlocked(currentClass) then
            toggleBtn:SetText("Alle " .. currentClass .. " Spells freigeben")
        else
            toggleBtn:SetText("Alle " .. currentClass .. " Spells blockieren")
        end
    end
end

-- Funktion zum Erstellen der Spell-Icons für jede Klasse
local function CreateSpellIcons(class)
    -- Zuerst alle vorhandenen Icons entfernen
    local existingIcons = {optionsFrame:GetChildren()}
    for _, child in ipairs(existingIcons) do
        if child.isSpellIcon and child:GetName() ~= "SpellBlockerHealOnlyBtn" and child:GetName() ~= "SpellBlockerToggleAll_"..class then
            child:Hide()
            child:SetParent(nil)
        end
    end

    -- Dann neue Icons für die aktuelle Klasse erstellen
    local y = -120  -- Startposition unter den Tabs
    local iconSize = 40
    local iconPadding = 10
    local iconsPerRow = 7
    
    -- Fortlaufende Icon-Position
    local currentRow = 0
    local currentCol = 0
    local regularIconCount = 0
    
    for i, spell in ipairs(SPELLS[class]) do
        -- Wenn es ein Separator ist
        if spell.id == 0 and (spell.name == "HEALER_SEPARATOR" or spell.name == "BLESSING_SEPARATOR") then
            -- Neue Zeile beginnen und moderaten Abstand einbauen
            currentCol = 0
            currentRow = currentRow + 0.8  -- Reduziert von 1.5 auf 0.8 für weniger Platz vor dem Separator
            
            -- Erstelle den Separator-Frame
            local separatorFrame = CreateFrame("Frame", nil, optionsFrame)
            separatorFrame.isSpellIcon = true
            separatorFrame:SetSize(iconSize*iconsPerRow + (iconsPerRow-1)*iconPadding, 20)
            separatorFrame:SetPoint("TOPLEFT", optionsFrame, "TOPLEFT", 20, y - currentRow*(iconSize+iconPadding))
            
            -- Füge eine Linie hinzu
            local line = separatorFrame:CreateTexture(nil, "BACKGROUND")
            line:SetTexture(0.5, 0.5, 0.5, 0.5)
            line:SetSize(iconSize*iconsPerRow + (iconsPerRow-1)*iconPadding, 1)
            line:SetPoint("CENTER", separatorFrame, "CENTER")
            
            -- Beschriftung des Separators
            local text = separatorFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            text:SetPoint("CENTER", separatorFrame, "CENTER")
            if spell.name == "BLESSING_SEPARATOR" then
                text:SetText("Blessings")
            else
                text:SetText("Damage Spells")
            end
            
            -- Nach dem Separator weniger Platz lassen
            currentRow = currentRow + 0.5  -- Reduziert von 1.0 auf 0.5 für weniger Platz nach dem Separator
        else
            -- Reguläres Spell-Icon
            local btn = CreateFrame("Button", nil, optionsFrame)
            btn:SetSize(iconSize, iconSize)
            btn:SetPoint("TOPLEFT", optionsFrame, "TOPLEFT", 
                20 + currentCol*(iconSize+iconPadding), 
                y - currentRow*(iconSize+iconPadding))
            btn.isSpellIcon = true
            
            -- Schöner Rahmen für die Icons
            btn:SetBackdrop({
                edgeFile = "Interface\\Buttons\\UI-ActionButton-Border",
                edgeSize = 16,
                insets = { left = 4, right = 4, top = 4, bottom = 4 }
            })
            btn:SetBackdropBorderColor(0.5, 0.5, 0.5, 0)  -- Unsichtbar standardmäßig
            
            local icon = btn:CreateTexture(nil, "ARTWORK")
            icon:SetAllPoints()
            local spellTexture = select(3, GetSpellInfo(spell.id))
            icon:SetTexture(spellTexture)
            btn.icon = icon
            btn.spellId = spell.id
            
            local function UpdateIcon()
                if SpellBlockerDB[class][spell.id] then
                    -- Blockierte Spells sind ausgegraut
                    icon:SetDesaturated(true)
                    btn:SetAlpha(0.5)
                else
                    -- Aktive Spells sind farbig
                    icon:SetDesaturated(false)
                    btn:SetAlpha(1)
                end
            end
            UpdateIcon()
            
            btn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                local spellLink = GetSpellLink(self.spellId)
                if spellLink then
                    GameTooltip:SetHyperlink(spellLink)
                else
                    local name = select(1, GetSpellInfo(self.spellId))
                    GameTooltip:SetText(name or "Unbekannter Zauber", 1, 1, 1)
                end
                GameTooltip:Show()
            end)
            btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
            btn:SetScript("OnClick", function(self)
                SpellBlockerDB[class][spell.id] = not SpellBlockerDB[class][spell.id]
                UpdateIcon()
                UpdateToggleButton()
            end)
            
            -- Position für nächstes Icon
            currentCol = currentCol + 1
            if currentCol >= iconsPerRow then
                currentCol = 0
                currentRow = currentRow + 1
            end
            
            regularIconCount = regularIconCount + 1
        end
    end
    
    -- Toggle-Button für alle Spells dieser Klasse
    local toggleBtn = CreateFrame("Button", "SpellBlockerToggleAll_"..class, optionsFrame)
    toggleBtn:SetSize(48, 48)
    -- Neue Position: Direkt über dem OK-Button
    toggleBtn:SetPoint("BOTTOMRIGHT", optionsFrame, "BOTTOMRIGHT", -20, 80)  -- 60 Pixel über dem OK-Button
    toggleBtn.isSpellIcon = true -- Markieren für späteres Erkennen

    -- Icon je nach Klasse setzen
    local classCoords = {
        WARRIOR     = {0, 0.25, 0, 0.25},
        PALADIN     = {0, 0.25, 0.5, 0.75},  -- Korrigiert
        DEATHKNIGHT = {0.25, 0.5, 0.5, 0.75},  -- Korrigiert für DK 
        PRIEST      = {0.5, 0.75, 0.25, 0.5},
        MAGE        = {0.25, 0.5, 0, 0.25},
        WARLOCK     = {0.75, 1, 0.25, 0.5},
        ROGUE       = {0.5, 0.75, 0, 0.25},
        HUNTER      = {0, 0.25, 0.25, 0.5},  -- Korrigiert
        SHAMAN      = {0.25, 0.5, 0.25, 0.5},  -- Korrigiert für Shaman
        DRUID       = {0.75, 1, 0, 0.25}
    }
    
    -- Klassenicon im Hintergrund
    local bgTexture = toggleBtn:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetTexture("Interface\\TargetingFrame\\UI-CLASSES-CIRCLES")
    bgTexture:SetTexCoord(unpack(classCoords[class]))
    bgTexture:SetAllPoints()

    -- Highlight für Mouseover
    toggleBtn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

    -- Text-Label für klarere Funktion - jetzt horizontal zentriert
    local label = toggleBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("BOTTOM", toggleBtn, "BOTTOM", 0, -15)
    label:SetText("Toggle All")  -- Geändert zu "Toggle All" (kürzer)
    
    toggleBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        if AreAllSpellsBlocked(class) then
            GameTooltip:SetText("Unblock All " .. class .. " Spells")
        else
            GameTooltip:SetText("Block All " .. class .. " Spells")
        end
        GameTooltip:Show()
    end)
    toggleBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

    -- Klick-Handler bleibt gleich
    toggleBtn:SetScript("OnClick", function()
        local shouldBlock = not AreAllSpellsBlocked(class)
        for _, spell in ipairs(SPELLS[class]) do
            SpellBlockerDB[class][spell.id] = shouldBlock
        end
        -- Icons aktualisieren durch Neuaufbau
        CreateSpellIcons(class)
    end)
end

-- Funktion zum Aktivieren des Heal-Only-Modus für Heilerklassen
local function IsHealerClass(class)
    return class == "PRIEST" or class == "PALADIN" or class == "SHAMAN" or class == "DRUID"
end

local function EnableHealOnlyMode()
    if not IsHealerClass(currentClass) then
        print("|cFFFF0000SpellBlocker:|r Heal Only Mode ist nur für Heilerklassen verfügbar.")
        return
    end
    
    local count = 0
    local foundSeparator = false
    
    -- Nur für die aktuelle Klasse anwenden
    for _, spell in ipairs(SPELLS[currentClass]) do
        if spell.id == 0 and (spell.name == "HEALER_SEPARATOR" or (currentClass == "PALADIN" and spell.name == "BLESSING_SEPARATOR")) then
            foundSeparator = true
        else
            -- Spells vor dem Separator nicht blocken (Heilung)
            if not foundSeparator then
                SpellBlockerDB[currentClass][spell.id] = false
            -- Spells nach dem Separator blocken (Schaden)
            else
                SpellBlockerDB[currentClass][spell.id] = true
                count = count + 1
            end
        end
    end
    
    -- Interface aktualisieren
    RefreshClassSpellDisplay()
    
    print("|cFF00FF00SpellBlocker:|r Heal Only Mode für " .. currentClass .. " aktiviert. " .. count .. " Schadenszauber blockiert.")
end
-- Erstelle den "Heal Only" Button
local healOnlyBtn = CreateFrame("Button", "SpellBlockerHealOnlyBtn", optionsFrame) -- Wichtig: an optionsFrame anhängen!
healOnlyBtn:SetSize(48, 48)
healOnlyBtn:SetFrameStrata("MEDIUM")
healOnlyBtn:EnableMouse(true)
healOnlyBtn:SetNormalTexture("Interface\\Icons\\spell_holy_holybolt") -- Heilungs-Icon
healOnlyBtn.isSpellIcon = true -- Wichtig damit er nicht gelöscht wird

-- Positioniere den Heal Only-Button über dem Toggle All-Button
healOnlyBtn:SetPoint("BOTTOMRIGHT", optionsFrame, "BOTTOMRIGHT", -20, 140) -- 60 Pixel über dem Toggle All Button

-- Schriftart für das Label
local healLabel = healOnlyBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
healLabel:SetPoint("BOTTOM", healOnlyBtn, "BOTTOM", 0, -15)
healLabel:SetText("Heal Only")

-- Tooltip
healOnlyBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("Heal Only Mode", 1, 1, 1)
    GameTooltip:AddLine("Blockiert Schadenszauber für " .. currentClass, 0, 1, 0)
    GameTooltip:AddLine("Heilzauber bleiben freigegeben", 0.7, 0.7, 1)
    GameTooltip:Show()
end)
healOnlyBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- Klick-Funktion
healOnlyBtn:SetScript("OnClick", function()
    EnableHealOnlyMode()
end)
-- Funktion zum Sammeln der blockierten Spell-IDs für eine Klasse
local function GetBlockedSpellsForClass(class)
    local blockedSpells = {}
    for _, spell in ipairs(SPELLS[class]) do
        if SpellBlockerDB[class][spell.id] then
            table.insert(blockedSpells, spell.id)
        end
    end
    return blockedSpells
end
-- Funktion zum Erstellen des SS-Befehls für eine Klasse korrigieren
local function CreateSpellBlockCommand(class)
    local blockedSpells = GetBlockedSpellsForClass(class)
    if #blockedSpells == 0 then
        return nil -- Keine blockierten Spells
    end
    
    -- Beachte das Leerzeichen nach dem ss
    local command = "ss +"  -- Kein Doppelpunkt, mit Leerzeichen
    for i, spellId in ipairs(blockedSpells) do
        command = command .. spellId
        if i < #blockedSpells then
            command = command .. ","
        end
    end
    
    return command
end

-- Funktion zum Senden der Befehle an alle Spieler im Raid/Gruppe
local function SendBlockCommandsToGroup()
    -- Prüfe, ob wir in einer Gruppe oder Raid sind
    local numMembers = GetNumRaidMembers()
    local isRaid = (numMembers > 0)
    
    if not isRaid then
        numMembers = GetNumPartyMembers()
        if numMembers == 0 then
            print("|cFFFF0000SpellBlocker:|r You are not in a group/raid.")
            return
        end
    end
    
    -- Sammele Spieler nach Klasse
    local playersByClass = {}
    
    -- Verarbeite alle Gruppenmitglieder
    for i = 1, numMembers do
        local unit = isRaid and "raid"..i or "party"..i
        local name = UnitName(unit)
        local _, class = UnitClass(unit)
        
        if name and class then
            if not playersByClass[class] then
                playersByClass[class] = {}
            end
            table.insert(playersByClass[class], name)
        end
    end
    
    -- Füge den eigenen Spieler hinzu, falls er nicht bereits hinzugefügt wurde
    local playerName = UnitName("player")
    local _, playerClass = UnitClass("player")
    if not (isRaid or numMembers == 0) then  -- In einer Party, aber nicht in einem Raid
        if not playersByClass[playerClass] then
            playersByClass[playerClass] = {}
        end
        table.insert(playersByClass[playerClass], playerName)
    end
    
    -- Sende Befehle an alle Spieler
    local totalMessages = 0
    for class, players in pairs(playersByClass) do
        local command = CreateSpellBlockCommand(class)
        if command then
            for _, playerName in ipairs(players) do
                SendChatMessage(command, "WHISPER", nil, playerName)
                totalMessages = totalMessages + 1
            end
        end
    end
    
    print("|cFF00FF00SpellBlocker:|r " .. totalMessages .. " blocking commands sent.")
end

-- Erstelle den großen Block All-Button
local blockAllBtn = CreateFrame("Button", "SpellBlockerBlockAllBtn", UIParent)
blockAllBtn:SetSize(48, 48)
blockAllBtn:SetClampedToScreen(true)
blockAllBtn:SetFrameStrata("MEDIUM")
blockAllBtn:SetMovable(true)
blockAllBtn:EnableMouse(true)
blockAllBtn:RegisterForDrag("LeftButton")
blockAllBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")  -- Diese Zeile hinzufügen
blockAllBtn:SetNormalTexture("Interface\\Icons\\ability_creature_cursed_03") -- Rotes durchgestrichenes Icon

-- Position laden oder Standard setzen
if SpellBlockerBlockAllPos then
    blockAllBtn:SetPoint("CENTER", UIParent, "BOTTOMLEFT", SpellBlockerBlockAllPos.x, SpellBlockerBlockAllPos.y)
else
    blockAllBtn:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

-- Tooltip aktualisieren
blockAllBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("SpellBlocker", 1, 1, 1)
    GameTooltip:AddLine("Left-click to send commands", 0, 1, 0) 
    GameTooltip:AddLine("Right-click to open options", 0, 1, 0)
    GameTooltip:AddLine("Hold Shift+Left-click to move", 0.7, 0.7, 1)
    GameTooltip:Show()
end)
blockAllBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- Verschieben nur mit Shift+Linker Maustaste ermöglichen
blockAllBtn:SetScript("OnDragStart", function(self)
    -- Nur bewegen, wenn Shift gedrückt ist
    if IsShiftKeyDown() then
        self:StartMoving()
    end
end)

-- Verschieben ermöglichen
blockAllBtn:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    -- Position speichern
    local left, bottom = self:GetLeft(), self:GetBottom()
    if not SpellBlockerBlockAllPos then SpellBlockerBlockAllPos = {} end
    SpellBlockerBlockAllPos.x = left
    SpellBlockerBlockAllPos.y = bottom
end)

-- Variable für Blockierung aktiv/inaktiv
local isBlockingActive = true

-- Click-Funktion: Sendet befiehlt direkt (ohne Shift)
blockAllBtn:SetScript("OnClick", function(self, button)
    if button == "RightButton" then
        -- Optionsfenster bei Rechtsklick öffnen
        optionsFrame:Show()
    else
        -- Befehle bei Linksklick senden (Standard)
        SendBlockCommandsToGroup()
    end
end)

-- OnEvent Handler für Initialisierung
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, arg1)
    if arg1 == addonName then
        InitDB()
        CreateClassTabs()
        RefreshClassSpellDisplay()
    end
end)

-- Öffne das Optionsfenster mit einem Slash-Befehl
SLASH_SPELLBLOCKER1 = "/spellblocker"
SLASH_SPELLBLOCKER2 = "/sb"
SlashCmdList["SPELLBLOCKER"] = function()
    optionsFrame:Show()
end

-- Minimap Button-Funktionalität korrigieren
local miniBtn = CreateFrame("Button", "SpellBlockerMiniMap", Minimap)
miniBtn:SetSize(32, 32)
miniBtn:SetFrameStrata("MEDIUM")
-- miniBtn:SetMovable(true) -- Diese Zeile entfernen, wir wollen keine freie Bewegung
miniBtn:EnableMouse(true)
miniBtn:RegisterForDrag("LeftButton")
miniBtn:SetNormalTexture("Interface\\Icons\\ability_warrior_shieldmastery")
miniBtn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

-- Funktion zum Aktualisieren der Minimap-Button Position
local function UpdateMinimapPosition()
    local angle = SpellBlockerMinimapPos or 45
    local radius = 78  -- Distanz vom Zentrum der Minimap
    local radian = math.rad(angle)
    
    local x = math.cos(radian) * radius
    local y = math.sin(radian) * radius
    
    miniBtn:ClearAllPoints() -- Wichtig, um alte Ankerpunkte zu entfernen
    miniBtn:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- Initialisiere Position
UpdateMinimapPosition()

-- Ersetzt den DragStart-Handler
miniBtn:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", function()
        local xpos, ypos = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        local xmin, ymin = Minimap:GetCenter()
        xpos = xpos / scale
        ypos = ypos / scale
        
        -- Berechne Winkel zwischen Cursor und Minimap-Zentrum
        local dx, dy = xpos - xmin, ypos - ymin
        local angle = math.deg(math.atan2(dy, dx))
        
        -- Speichere neuen Winkel
        SpellBlockerMinimapPos = angle
        
        -- Aktualisiere Position sofort
        UpdateMinimapPosition()
    end)
end)

-- Ersetzt den DragStop-Handler
miniBtn:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
end)

-- Klick-Funktion
miniBtn:SetScript("OnClick", function()
    if optionsFrame:IsShown() then
        optionsFrame:Hide()
    else
        optionsFrame:Show()
    end
end)

-- Tooltip
miniBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText("SpellBlocker", 1, 1, 1)
    GameTooltip:AddLine("Click to toggle options", 0, 1, 0)
    GameTooltip:AddLine("Drag to move around minimap", 0.7, 0.7, 1)
    GameTooltip:Show()
end)
miniBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)


-- Funktion zum Aktualisieren der Anzeige für die aktuelle Klasse
function RefreshClassSpellDisplay()
    -- Erstelle die Spell-Icons für die aktuelle Klasse
    CreateSpellIcons(currentClass)
    
    -- Aktualisiere den Toggle-Button Text
    UpdateToggleButton()
    
    -- Heal-Only Button nur für Heilerklassen anzeigen
    if IsHealerClass(currentClass) then
        healOnlyBtn:Show()
    else
        healOnlyBtn:Hide()
    end
end





