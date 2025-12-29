local MicroMenuRecolor = LibStub("AceAddon-3.0"):NewAddon("MicroMenuRecolor", "AceConsole-3.0", "AceEvent-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- Button definitions with default colors (based on old icon colors)
local buttonDefs = {
    { key = "PlayerSpells", button = "PlayerSpellsMicroButton", name = "Spellbook", r = 146/255, g = 113/255, b = 155/255 },
    { key = "Profession", button = "ProfessionMicroButton", name = "Professions", r = 180/255, g = 130/255, b = 70/255 },
    { key = "Achievement", button = "AchievementMicroButton", name = "Achievement", r = 220/255, g = 179/255, b = 24/255 },
    { key = "QuestLog", button = "QuestLogMicroButton", name = "Quest Log", r = 255/255, g = 227/255, b = 82/255 },
    { key = "Guild", button = "GuildMicroButton", name = "Guild", r = 177/255, g = 144/255, b = 80/255 },
    { key = "LFD", button = "LFDMicroButton", name = "Group Finder", r = 109/255, g = 162/255, b = 35/255 },
    { key = "Collections", button = "CollectionsMicroButton", name = "Collections", r = 156/255, g = 98/255, b = 77/255 },
    { key = "EJ", button = "EJMicroButton", name = "Adventure Guide", r = 206/255, g = 169/255, b = 184/255 },
    { key = "Store", button = "StoreMicroButton", name = "Shop", r = 235/255, g = 188/255, b = 42/255 },
    { key = "MainMenu", button = "MainMenuMicroButton", name = "Main Menu", r = 228/255, g = 47/255, b = 40/255 },
}

-- Build defaults table dynamically
local defaults = {
    profile = {}
}

for _, def in ipairs(buttonDefs) do
    defaults.profile[def.key .. "Enabled"] = true
    defaults.profile[def.key .. "Color"] = { r = def.r, g = def.g, b = def.b }
end

-- Build options table dynamically
local options = {
    name = "Micro Menu Recolor",
    handler = MicroMenuRecolor,
    type = "group",
    args = {
        description = {
            type = "description",
            name = "Customize the colors of micro menu buttons. Enable/disable each button and pick a custom color.",
            order = 0,
        },
        resetDefaults = {
            type = "execute",
            name = "Reset to Defaults",
            desc = "Reset all colors and settings to their default values.",
            order = 1,
            func = function()
                for _, def in ipairs(buttonDefs) do
                    MicroMenuRecolor.db.profile[def.key .. "Enabled"] = true
                    MicroMenuRecolor.db.profile[def.key .. "Color"] = { r = def.r, g = def.g, b = def.b }
                end
                MicroMenuRecolor:ApplySettings()
                MicroMenuRecolor:Print("Colors reset to defaults.")
            end,
        },
        spacer = {
            type = "description",
            name = " ",
            order = 2,
        },
    },
}

-- Add options for each button
for i, def in ipairs(buttonDefs) do
    local baseOrder = i * 10

    -- Toggle for enabling this button's recolor
    options.args[def.key .. "Enabled"] = {
        type = "toggle",
        name = def.name,
        desc = "Enable color change for " .. def.name,
        order = baseOrder,
        width = "normal",
        get = function(info) return MicroMenuRecolor.db.profile[def.key .. "Enabled"] end,
        set = function(info, value)
            MicroMenuRecolor.db.profile[def.key .. "Enabled"] = value
            MicroMenuRecolor:ApplySettings()
        end,
    }

    -- Color picker for this button
    options.args[def.key .. "Color"] = {
        type = "color",
        name = "",
        desc = "Choose color for " .. def.name,
        order = baseOrder + 1,
        width = 0.5,
        hasAlpha = false,
        get = function(info)
            local c = MicroMenuRecolor.db.profile[def.key .. "Color"]
            return c.r, c.g, c.b
        end,
        set = function(info, r, g, b)
            MicroMenuRecolor.db.profile[def.key .. "Color"] = { r = r, g = g, b = b }
            MicroMenuRecolor:ApplySettings()
        end,
    }
end

function MicroMenuRecolor:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("MicroMenuRecolorDB", defaults, true)
    AceConfig:RegisterOptionsTable("MicroMenuRecolor", options)
    self.optionsFrame = AceConfigDialog:AddToBlizOptions("MicroMenuRecolor", "Micro Menu Recolor")
end

function MicroMenuRecolor:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "ApplySettings")
end

function MicroMenuRecolor:ApplySettings()
    local settings = self.db.profile

    for _, def in ipairs(buttonDefs) do
        local button = _G[def.button]
        if button then
            local enabled = settings[def.key .. "Enabled"]
            local color = settings[def.key .. "Color"]

            local normalTexture = button:GetNormalTexture()
            local pushedTexture = button:GetPushedTexture()
            local highlightTexture = button:GetHighlightTexture()
            local disabledTexture = button:GetDisabledTexture()

            if enabled then
                -- Apply custom color
                if normalTexture then normalTexture:SetVertexColor(color.r, color.g, color.b) end
                if pushedTexture then pushedTexture:SetVertexColor(color.r, color.g, color.b) end
                if highlightTexture then highlightTexture:SetVertexColor(color.r, color.g, color.b) end
                if disabledTexture then disabledTexture:SetVertexColor(color.r, color.g, color.b) end
            else
                -- Reset to default white (no tint)
                if normalTexture then normalTexture:SetVertexColor(1, 1, 1) end
                if pushedTexture then pushedTexture:SetVertexColor(1, 1, 1) end
                if highlightTexture then highlightTexture:SetVertexColor(1, 1, 1) end
                if disabledTexture then disabledTexture:SetVertexColor(1, 1, 1) end
            end
        end
    end
end
