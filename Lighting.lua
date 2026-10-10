local LightingService = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Lighting = {}
Lighting.Library = nil
Lighting.Config = nil
Lighting.Building = false
Lighting.Time = nil
Lighting.TimeEdited = false
Lighting.TimeLocked = false
Lighting.TimeConnection = nil

Lighting.Effects = {
    {
        Key = "Atmosphere",
        Title = "Atmosphere",
        Class = "Atmosphere",
        Parent = function() return LightingService end,
        Props = {
            { Name = "Density", Title = "Density", Min = 0, Max = 1, Rounding = 2 },
            { Name = "Offset", Title = "Offset", Min = 0, Max = 1, Rounding = 2 },
            { Name = "Haze", Title = "Haze", Min = 0, Max = 10, Rounding = 1 },
            { Name = "Glare", Title = "Glare", Min = 0, Max = 1, Rounding = 2 },
            { Name = "Color", Title = "Color", Color = true },
            { Name = "Decay", Title = "Decay", Color = true },
        },
    },
    {
        Key = "SunRays",
        Title = "Sun Rays",
        Class = "SunRaysEffect",
        Parent = function() return LightingService end,
        Props = {
            { Name = "Intensity", Title = "Intensity", Min = 0, Max = 1, Rounding = 2 },
            { Name = "Spread", Title = "Spread", Min = 0, Max = 1, Rounding = 2 },
        },
    },
    {
        Key = "ColorCorrection",
        Title = "Color Correction",
        Class = "ColorCorrectionEffect",
        Parent = function() return LightingService end,
        Props = {
            { Name = "Brightness", Title = "Brightness", Min = -1, Max = 1, Rounding = 2 },
            { Name = "Contrast", Title = "Contrast", Min = -1, Max = 1, Rounding = 2 },
            { Name = "Saturation", Title = "Saturation", Min = -1, Max = 1, Rounding = 2 },
            { Name = "TintColor", Title = "Tint Color", Color = true },
        },
    },
    {
        Key = "Bloom",
        Title = "Bloom",
        Class = "BloomEffect",
        Parent = function() return LightingService end,
        Props = {
            { Name = "Intensity", Title = "Intensity", Min = 0, Max = 1, Rounding = 2 },
            { Name = "Size", Title = "Size", Min = 0, Max = 56, Rounding = 0 },
            { Name = "Threshold", Title = "Threshold", Min = 0, Max = 1, Rounding = 2 },
        },
    },
    {
        Key = "Clouds",
        Title = "Clouds",
        Class = "Clouds",
        Parent = function() return Workspace:FindFirstChildOfClass("Terrain") end,
        Props = {
            { Name = "Density", Title = "Density", Min = 0, Max = 1, Rounding = 2 },
            { Name = "Cover", Title = "Cover", Min = 0, Max = 1, Rounding = 2 },
            { Name = "Color", Title = "Color", Color = true },
        },
    },
    {
        Key = "Blur",
        Title = "Blur",
        Class = "BlurEffect",
        Parent = function() return LightingService end,
        Props = {
            { Name = "Size", Title = "Size", Min = 0, Max = 56, Rounding = 0 },
        },
    },
    {
        Key = "DepthOfField",
        Title = "Depth Of Field",
        Class = "DepthOfFieldEffect",
        Parent = function() return Workspace.CurrentCamera end,
        Props = {
            { Name = "FocusDistance", Title = "Focus Distance", Min = 0, Max = 150, Rounding = 0 },
            { Name = "InFocusRadius", Title = "In-Focus Radius", Min = 0, Max = 50, Rounding = 0 },
            { Name = "NearIntensity", Title = "Near Intensity", Min = 0, Max = 1, Rounding = 2 },
            { Name = "FarIntensity", Title = "Far Intensity", Min = 0, Max = 1, Rounding = 2 },
        },
    },
}

function Lighting:SetLibrary(Library)
    self.Library = Library
end

function Lighting:FitMax(Max, Value)
    if type(Value) ~= "number" then return Max end
    return math.max(Max, math.ceil(Value))
end

function Lighting:Notify(Content)
    if not self.Library then return end
    self.Library:Notify({
        Title = "Lighting",
        Content = Content,
        Duration = 3,
    })
end

function Lighting:GetSky(Create)
    local Sky = LightingService:FindFirstChildOfClass("Sky")
    if not Sky and Create then
        Sky = Instance.new("Sky")
        Sky.Name = "Sky"
        Sky.Parent = LightingService
    end
    return Sky
end

function Lighting:SetSkyProperty(Name, Value)
    self:GetSky(true)[Name] = Value
end

function Lighting:ResolveAsset(Value)
    Value = (tostring(Value or ""):gsub("^%s*(.-)%s*$", "%1"))
    if Value == "" then return nil end
    if Value:match("^%d+$") then return "rbxassetid://" .. Value end
    if Value:find("://", 1, true) then return Value end
    return "rbxassetid://" .. Value
end

function Lighting:FindEffect(Spec)
    local Parent = Spec.Parent()
    if not Parent then return nil end
    return Parent:FindFirstChildOfClass(Spec.Class)
end

function Lighting:ReadSky()
    local Source = self:GetSky(false)
    local Temp = nil
    if not Source then
        Temp = Instance.new("Sky")
        Source = Temp
    end

    local Values = {
        Celestial = Source.CelestialBodiesShown,
        SunSize = Source.SunAngularSize,
        MoonSize = Source.MoonAngularSize,
        StarCount = Source.StarCount,
        SunTexture = Source.SunTextureId,
        MoonTexture = Source.MoonTextureId,
    }

    if Temp then Temp:Destroy() end
    return Values
end

function Lighting:ReadEffect(Spec)
    local Source = self:FindEffect(Spec)
    local Temp = nil
    local Exists = Source ~= nil
    if not Source then
        Temp = Instance.new(Spec.Class)
        Source = Temp
    end

    local Values = { Enabled = Exists }
    for _, Prop in ipairs(Spec.Props) do
        Values[Prop.Name] = Source[Prop.Name]
    end

    if Temp then Temp:Destroy() end
    return Values
end

function Lighting:ReadConfig()
    local Config = {}
    Config.Time = LightingService.TimeOfDay:match("^(%d+:%d+)") or "12:00"
    Config.Brightness = LightingService.Brightness
    Config.OutdoorAmbient = LightingService.OutdoorAmbient
    Config.Sky = self:ReadSky()

    for _, Spec in ipairs(self.Effects) do
        Config[Spec.Key] = self:ReadEffect(Spec)
    end

    return Config
end

function Lighting:SetEffect(Spec, State)
    local Values = self.Config[Spec.Key]
    Values.Enabled = State

    local Parent = Spec.Parent()
    if not Parent then return end

    local Effect = Parent:FindFirstChildOfClass(Spec.Class)
    if State then
        if not Effect then
            Effect = Instance.new(Spec.Class)
            Effect.Name = Spec.Class
            Effect.Parent = Parent
        end
        for _, Prop in ipairs(Spec.Props) do
            Effect[Prop.Name] = Values[Prop.Name]
        end
    elseif Effect then
        for _, Prop in ipairs(Spec.Props) do
            Values[Prop.Name] = Effect[Prop.Name]
        end
        Effect:Destroy()
    end
end

function Lighting:SetEffectProperty(Spec, Name, Value)
    self.Config[Spec.Key][Name] = Value
    local Effect = self:FindEffect(Spec)
    if Effect then
        Effect[Name] = Value
    end
end

function Lighting:GetTime()
    if self.TimeEdited and self.Time then
        return self.Time
    end
    return LightingService.TimeOfDay:match("^(%d+:%d+)") or "12:00"
end

function Lighting:ApplyTime(TimeStr)
    local Hour, Minute = tostring(TimeStr):match("^(%d+):(%d+)$")
    Hour, Minute = tonumber(Hour), tonumber(Minute)
    if not Hour or not Minute or Hour > 23 or Minute > 59 then
        self:Notify("Invalid format! Use HH:MM (e.g. 14:30)")
        return false
    end
    LightingService.TimeOfDay = string.format("%02d:%02d:00", Hour, Minute)
    return true
end

function Lighting:SetTimeLock(State)
    self.TimeLocked = State
    if self.TimeConnection then
        self.TimeConnection:Disconnect()
        self.TimeConnection = nil
    end
    if not State then return end

    local Target = self:GetTime()
    if not self:ApplyTime(Target) then
        self.TimeLocked = false
        local Option = self.Library and self.Library.Options and self.Library.Options.Lighting_TimeLock
        if Option then Option:SetValue(false) end
        return
    end

    local Hour, Minute = Target:match("^(%d+):(%d+)$")
    local Formatted = string.format("%02d:%02d:00", tonumber(Hour), tonumber(Minute))
    self.TimeConnection = RunService.Heartbeat:Connect(function()
        if not self.TimeLocked then return end
        LightingService.TimeOfDay = Formatted
    end)
end

function Lighting:BuildEffectSection(Tab, Spec)
    local Section = Tab:AddSection(Spec.Title)
    local Values = self.Config[Spec.Key]

    Section:AddToggle("Lighting_" .. Spec.Key .. "Enabled", {
        Title = "Enable " .. Spec.Title,
        Default = Values.Enabled,
        Callback = function(State)
            if self.Building then return end
            self:SetEffect(Spec, State)
        end
    })

    for _, Prop in ipairs(Spec.Props) do
        local Idx = "Lighting_" .. Spec.Key .. Prop.Name
        if Prop.Color then
            Section:AddColorpicker(Idx, {
                Title = Prop.Title,
                Default = Values[Prop.Name],
                Callback = function(Value)
                    if self.Building then return end
                    self:SetEffectProperty(Spec, Prop.Name, Value)
                end
            })
        else
            Section:AddSlider(Idx, {
                Title = Prop.Title,
                Min = Prop.Min,
                Max = self:FitMax(Prop.Max, Values[Prop.Name]),
                Default = math.clamp(Values[Prop.Name], Prop.Min, self:FitMax(Prop.Max, Values[Prop.Name])),
                Rounding = Prop.Rounding,
                Callback = function(Value)
                    if self.Building then return end
                    self:SetEffectProperty(Spec, Prop.Name, Value)
                end
            })
        end
    end
end

function Lighting:BuildSections(Tab)
    local Config = self.Config
    local Main = Tab:AddSection("Lighting Configuration")
    Main:AddSpace({ Height = 15 })

    Main:AddInput("Lighting_Time", {
        Title = "Time (HH:MM)",
        Placeholder = "e.g. 14:30",
        Default = Config.Time,
        Callback = function(Value)
            if self.Building then return end
            self.Time = Value
            self.TimeEdited = true
        end
    })

    Main:AddSpace({ Height = 5 })

    Main:AddButton({
        Title = "Apply Time",
        Callback = function()
            local Target = self:GetTime()
            if self:ApplyTime(Target) then
                self:Notify("Time set to " .. Target)
            end
        end
    })

    Main:AddToggle("Lighting_TimeLock", {
        Title = "Lock Time",
        Description = "Prevent the game from changing the time",
        Default = false,
        Callback = function(State)
            if self.Building then return end
            self:SetTimeLock(State)
        end
    })

    Main:AddToggle("Lighting_CelestialBodies", {
        Title = "Celestial Bodies",
        Description = "Show sun & moon in the sky",
        Default = Config.Sky.Celestial,
        Callback = function(State)
            if self.Building then return end
            self:SetSkyProperty("CelestialBodiesShown", State)
        end
    })

    Main:AddSlider("Lighting_SunAngularSize", {
        Title = "Sun Angular Size",
        Min = 0,
        Max = self:FitMax(60, Config.Sky.SunSize),
        Default = math.clamp(Config.Sky.SunSize, 0, self:FitMax(60, Config.Sky.SunSize)),
        Rounding = 0,
        Callback = function(Value)
            if self.Building then return end
            self:SetSkyProperty("SunAngularSize", Value)
        end
    })

    Main:AddSlider("Lighting_MoonAngularSize", {
        Title = "Moon Angular Size",
        Min = 0,
        Max = self:FitMax(60, Config.Sky.MoonSize),
        Default = math.clamp(Config.Sky.MoonSize, 0, self:FitMax(60, Config.Sky.MoonSize)),
        Rounding = 0,
        Callback = function(Value)
            if self.Building then return end
            self:SetSkyProperty("MoonAngularSize", Value)
        end
    })

    Main:AddInput("Lighting_SunTextureId", {
        Title = "Sun Texture ID",
        Placeholder = "rbxassetid://...",
        Default = Config.Sky.SunTexture,
        Finished = true,
        Callback = function(Value)
            if self.Building then return end
            local Asset = self:ResolveAsset(Value)
            if Asset then self:SetSkyProperty("SunTextureId", Asset) end
        end
    })

    Main:AddInput("Lighting_MoonTextureId", {
        Title = "Moon Texture ID",
        Placeholder = "rbxassetid://...",
        Default = Config.Sky.MoonTexture,
        Finished = true,
        Callback = function(Value)
            if self.Building then return end
            local Asset = self:ResolveAsset(Value)
            if Asset then self:SetSkyProperty("MoonTextureId", Asset) end
        end
    })

    Main:AddSlider("Lighting_StarCount", {
        Title = "Star Count",
        Min = 0,
        Max = self:FitMax(5000, Config.Sky.StarCount),
        Default = math.clamp(Config.Sky.StarCount, 0, self:FitMax(5000, Config.Sky.StarCount)),
        Rounding = 0,
        Callback = function(Value)
            if self.Building then return end
            self:SetSkyProperty("StarCount", Value)
        end
    })

    Main:AddSlider("Lighting_Brightness", {
        Title = "Ambient Brightness",
        Min = 0,
        Max = self:FitMax(2, Config.Brightness),
        Default = math.clamp(Config.Brightness, 0, self:FitMax(2, Config.Brightness)),
        Rounding = 2,
        Callback = function(Value)
            if self.Building then return end
            Config.Brightness = Value
            LightingService.Brightness = Value
        end
    })

    Main:AddColorpicker("Lighting_OutdoorAmbient", {
        Title = "Outdoor Ambient",
        Default = Config.OutdoorAmbient,
        Callback = function(Value)
            if self.Building then return end
            Config.OutdoorAmbient = Value
            LightingService.OutdoorAmbient = Value
        end
    })

    for _, Spec in ipairs(self.Effects) do
        self:BuildEffectSection(Tab, Spec)
    end
end

function Lighting:BuildLightingSection(Tab)
    assert(self.Library, "Must set Lighting.Library")

    self.Config = self:ReadConfig()
    self.Time = self.Config.Time
    self.TimeEdited = false

    self.Building = true
    local Ok, Err = pcall(self.BuildSections, self, Tab)
    self.Building = false

    if not Ok then
        error(Err, 0)
    end
end

function Lighting:Destroy()
    self:SetTimeLock(false)
end

return Lighting
