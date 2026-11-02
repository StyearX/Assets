local CloneRef = cloneref or function(Service)
    return Service
end

local TweenService = CloneRef(game:GetService("TweenService"))
local UserInputService = CloneRef(game:GetService("UserInputService"))
local RunService = CloneRef(game:GetService("RunService"))

local MinScale = 0.03
local MaxScale = 0.6
local HoldTime = 0.6
local SwitcherLife = 3
local DefaultScale = Vector2.new(0.12, 0.07) -- fraction of screen, like Size1/Size2 in the old script
local DefaultRadius = 15
local DefaultStroke = 2
local BackgroundSpin = 33 -- degrees per second
local StrokeSpin = 30
local NeutralThemes = { Dark = true, Light = true }
local DragThreshold = 6
local StackSpacing = 56
local FallbackViewport = Vector2.new(1280, 720)
local HoverTweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local FloatingButton = {}
FloatingButton.Library = nil
FloatingButton.Buttons = {}
FloatingButton.Created = 0

local Button = {}
Button.__index = Button

local function ClampScale(Value)
    return math.clamp(Value, MinScale, MaxScale)
end

-- "0.12x0.07" = fraction of the screen (same as Size1 / Size2). "12x7" is read as percent.
local function ParseSize(Value)
    local Normalized = string.lower(tostring(Value or "")):gsub("×", "x")
    local Width, Height = Normalized:match("^%s*(%d+%.?%d*)%s*x%s*(%d+%.?%d*)%s*$")
    Width, Height = tonumber(Width), tonumber(Height)

    if not Width or not Height then
        return nil
    end

    if Width > 1 or Height > 1 then
        Width, Height = Width / 100, Height / 100
    end

    return ClampScale(Width), ClampScale(Height)
end

local function FormatSize(Width, Height)
    return string.format("%.3gx%.3g", Width, Height)
end

local function ParseRounded(Value)
    local Number = tonumber(string.match(tostring(Value or ""), "^%s*(%d+%.?%d*)%s*%%?%s*$"))
    return Number and math.clamp(Number, 0, 100) or nil
end

local function IsPointer(Input)
    return Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch
end

local function Create(ClassName, Properties, Children)
    local Object = Instance.new(ClassName)
    local Parent = Properties.Parent
    Properties.Parent = nil

    if Object:IsA("GuiObject") then
        Object.BorderSizePixel = 0
    end

    if Object:IsA("GuiButton") then
        Object.Text = ""
        Object.AutoButtonColor = false
    end

    for Name, Value in next, Properties do
        if Name ~= "Name" then
            Object[Name] = Value
        end
    end

    for _, Child in ipairs(Children or {}) do
        Child.Parent = Object
    end

    Object.Parent = Parent
    return Object
end

function FloatingButton:SetLibrary(Library)
    self.Library = Library
end

function FloatingButton:Get(Idx)
    return self.Buttons[Idx]
end

function FloatingButton:Remove(Idx)
    local Existing = self.Buttons[Idx]

    if Existing then
        Existing:Destroy()
    end
end

function FloatingButton:Add(Host, Idx, Config)
    assert(self.Library, "FloatingButton - Library is not set")
    assert(type(Idx) == "string", "FloatingButton - Missing Idx")
    assert(type(Config) == "table" and Config.Title, "FloatingButton - Missing Title")

    self:Remove(Idx)
    self.Created = self.Created + 1

    local Created = Button.new(self, Host, Idx, Config)
    self.Buttons[Idx] = Created
    return Created
end

function Button.new(Owner, Host, Idx, Config)
    local Library = Owner.Library
    local Width, Height

    -- Size1 / Size2 style: fractions of the screen, like UDim2.new(Size1, 0, Size2, 0)
    local Given = typeof(Config.Scale) == "Vector2" and Config.Scale
        or typeof(Config.Size) == "Vector2" and Config.Size
        or (Config.Size1 and Config.Size2) and Vector2.new(Config.Size1, Config.Size2)

    if Given then
        Width, Height = ClampScale(Given.X), ClampScale(Given.Y)
    elseif Config.Size ~= nil then
        Width, Height = ParseSize(Config.Size)
    end

    Width = Width or DefaultScale.X
    Height = Height or DefaultScale.Y

    local self = setmetatable({
        Owner = Owner,
        Library = Library,
        Host = Host,
        Idx = Idx,
        Enabled = Config.Default == true,
        State = Config.State == true,
        Type = (Config.Type == "Button" or Config.Stateful == false) and "Button" or "Toggle",
        BaseText = Config.Text or Config.Title,
        Shape = Config.Shape == "Circle" and "Circle" or "Rectangle",
        Width = Width,
        Height = Height,
        Rounded = math.clamp(tonumber(Config.Rounded) or 100, 0, 100),
        Transparency = math.clamp(tonumber(Config.Transparency) or 0, 0, 100),
        Locked = Config.Locked == true,
        Title = Config.Title,
        Callback = Config.Callback or function() end,
        Connections = {},
        Options = {},
        Hovering = false,
        Pressing = false,
        Moved = false,
        Held = false,
        PressToken = 0,
        SwitcherToken = 0,
    }, Button)

    self.Stateful = self.Type == "Toggle"
    self.CurrentWidth, self.CurrentHeight = self:Pixels()

    self:BuildInstances(Config)
    self:BuildOptions(Config)
    self:BindInput()
    self:StartShine()

    self.ThemeConnection = Library.ThemeChanged:Connect(function()
        self:Paint()
    end)

    self:Layout()
    self:Paint()
    self:RefreshRows()

    return self
end

function Button:Pixels()
    local View = self.Library.GUI.AbsoluteSize
    local ViewX = View.X > 0 and View.X or FallbackViewport.X
    local ViewY = View.Y > 0 and View.Y or FallbackViewport.Y
    return math.floor(ViewX * self.Width + 0.5), math.floor(ViewY * self.Height + 0.5)
end

function Button:ResolveIcon(Icon)
    if Icon == nil or Icon == "" then
        return nil
    end

    if type(Icon) == "string" then
        local Data = self.Library:GetIconData(Icon, nil, nil, "Button")

        if Data then
            if Data.ImageRectSize == Vector2.zero then
                return Data.Image
            end
            return Data
        end
    end

    if type(Icon) == "number" then
        return "rbxassetid://" .. Icon
    end

    if type(Icon) == "string" and (Icon:find("rbxasset") or Icon:find("http")) then
        return Icon
    end

    return nil
end

function Button:BuildInstances(Config)
    local Gui = self.Library.GUI
    local View = Gui.AbsoluteSize
    local ViewX = View.X > 0 and View.X or FallbackViewport.X
    local ViewY = View.Y > 0 and View.Y or FallbackViewport.Y
    local Index = self.Owner.Created - 1

    self.Gui = Gui

    self.Root = Create("Frame", {
        Name = "FloatingButton" .. self.Idx,
        Size = UDim2.fromOffset(self.CurrentWidth, self.CurrentHeight),
        Position = UDim2.fromOffset(
            math.floor((ViewX - self.CurrentWidth) / 2),
            math.floor((ViewY - self.CurrentHeight) / 2 + Index * StackSpacing)
        ),
        BackgroundTransparency = 1,
        Visible = self.Enabled,
        ZIndex = 5,
        Parent = Gui,
    })

    self.Corners = {}

    local function Round()
        local Corner = Create("UICorner", {})
        table.insert(self.Corners, Corner)
        return Corner
    end

    self.StrokeGradient = Create("UIGradient", {})
    self.Border = Create("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.new(1, 1, 1),
        Thickness = DefaultStroke,
    }, { self.StrokeGradient })

    self.Base = Create("Frame", {
        Name = "Base",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        ZIndex = 1,
        Parent = self.Root,
    }, { Round() })

    self.Main = Create("Frame", {
        Name = "Main",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 1,
        Parent = self.Root,
    }, { Round() })

    self.Gradient = Create("UIGradient", { Rotation = 90 })

    self.Fill = Create("Frame", {
        Name = "Fill",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0,
        ZIndex = 1,
        Parent = self.Root,
    }, { Round(), self.Gradient, self.Border })

    self.Grain = Create("ImageLabel", {
        Name = "Grain",
        Image = "rbxassetid://9968344105",
        ImageTransparency = 0.98,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.fromOffset(128, 128),
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 1,
        Parent = self.Root,
    }, { Round() })

    self.Noise = Create("ImageLabel", {
        Name = "Noise",
        Image = "rbxassetid://9968344227",
        ImageTransparency = 0.92,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.fromOffset(128, 128),
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 1,
        Parent = self.Root,
    }, { Round() })

    self.Tint = Create("Frame", {
        Name = "Tint",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        ZIndex = 1,
        Parent = self.Root,
    }, { Round() })

    self.Overlay = Create("Frame", {
        Name = "Overlay",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = self.Root,
    }, { Round() })

    local GlyphImage = self:ResolveIcon(Config.ButtonIcon)

    self.Glyph = Create("ImageLabel", {
        Image = type(GlyphImage) == "string" and GlyphImage or "",
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Visible = GlyphImage ~= nil,
    })

    if type(GlyphImage) == "table" then
        self.Library:SetImage(self.Glyph, GlyphImage)
    end

    self.Caption = Create("TextLabel", {
        Text = self:CaptionText(),
        FontFace = self.Library:FontFor("Bold"),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -8, 0, 16),
        LayoutOrder = 2,
    })

    Create("Frame", {
        Name = "Content",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Parent = self.Root,
    }, {
        Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 2),
        }),
        self.Glyph,
        self.Caption,
    })

    self.Hit = Create("TextButton", {
        Name = "Hit",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 4,
        Parent = self.Root,
    })

    self.SwitcherGlyph = Create("ImageLabel", {
        Size = UDim2.fromOffset(16, 16),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1,
    })

    self.SwitcherBorder = Create("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })

    self.Switcher = Create("TextButton", {
        Name = "Switcher",
        Size = UDim2.fromOffset(30, 30),
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(0, -8, 0.5, 0),
        Visible = false,
        ZIndex = 5,
        Parent = self.Root,
    }, {
        Create("UICorner", { CornerRadius = UDim.new(0, 9) }),
        self.SwitcherBorder,
        self.SwitcherGlyph,
    })
end

function Button:BuildOptions(Config)
    local Host = self.Host
    local Idx = self.Idx

    -- one tidy section per button, so every button has its own group of rows
    if type(Host.AddSection) == "function" then
        self.Section = Host:AddSection(Config.Title, {
            Icon = Config.Icon or (self.Stateful and "tabler:toggle-right" or "tabler:pointer"),
            IconColor = Config.IconColor,
        })
        Host = self.Section
    end

    self.Toggle = Host:AddToggle(Idx .. "Toggle", {
        Title = "Show " .. string.lower(self.Type == "Toggle" and "toggle button" or "button"),
        Description = Config.Description or "Float this button on the screen",
        Icon = Config.Icon or "tabler:eye",
        IconColor = Config.IconColor or Color3.fromRGB(10, 132, 255),
        Default = self.Enabled,
        Callback = function(Value)
            self:ApplyEnabled(Value)
        end,
    })

    if Config.Keybind then
        self.Keybind = Host:AddKeybind(Idx .. "Keybind", {
            Title = Config.KeybindTitle or "Keybind",
            Description = "Press to trigger the button without touching it",
            Icon = "tabler:keyboard",
            IconColor = Color3.fromRGB(191, 90, 242),
            Variant = Config.KeybindVariant,
            Default = Config.Keybind,
            Mode = "Toggle",
            Callback = function()
                self:Activate()
            end,
        })
    end

    self.LockOption = Host:AddToggle(Idx .. "Lock", {
        Title = "Lock position",
        Description = "Stop dragging. Hold the button to lock or unlock",
        Icon = "tabler:lock",
        IconColor = Color3.fromRGB(255, 159, 10),
        Default = self.Locked,
        Callback = function(Value)
            self:ApplyLocked(Value)
        end,
    })

    self.ShapeOption = Host:AddDropdown(Idx .. "Shape", {
        Title = "Shape",
        Description = "Rectangle or circle",
        Icon = "tabler:shapes",
        IconColor = Color3.fromRGB(50, 215, 75),
        Variant = "Segmented",
        Values = { "Rectangle", "Circle" },
        Default = self.Shape,
        Callback = function(Value)
            self:ApplyShape(Value)
        end,
    })

    self.SizeOption = Host:AddInput(Idx .. "Size", {
        Title = "Size",
        Description = "Screen fraction, e.g. 0.12x0.07 (or 12x7 in percent)",
        Icon = "tabler:arrows-maximize",
        IconColor = Color3.fromRGB(100, 210, 255),
        Variant = "Field",
        Width = 120,
        Default = FormatSize(self.Width, self.Height),
        Placeholder = "0.12x0.07",
        Finished = true,
        Callback = function(Value)
            self:ApplySize(Value)
        end,
    })
    self:CommitOnBlur(self.SizeOption)

    self.RoundedOption = Host:AddInput(Idx .. "Rounded", {
        Title = "Circle roundness",
        Description = "Corner roundness in percent",
        Icon = "tabler:circle",
        IconColor = Color3.fromRGB(255, 69, 58),
        Variant = "Field",
        Width = 120,
        Default = string.format("%g", self.Rounded),
        Placeholder = "100",
        Finished = true,
        Callback = function(Value)
            self:ApplyRounded(Value)
        end,
    })
    self:CommitOnBlur(self.RoundedOption)

    self.TransparencyOption = Host:AddSlider(Idx .. "Transparency", {
        Title = "Transparency",
        Description = "How see-through the button is",
        Icon = "tabler:droplet",
        IconColor = Color3.fromRGB(94, 92, 230),
        Min = 0,
        Max = 100,
        Default = self.Transparency,
        Rounding = 0,
        Suffix = "%",
        Callback = function(Value)
            self:ApplyTransparency(Value)
        end,
    })

    self.Options = {
        self.Toggle,
        self.LockOption,
        self.ShapeOption,
        self.SizeOption,
        self.RoundedOption,
        self.TransparencyOption,
    }

    if self.Keybind then
        table.insert(self.Options, self.Keybind)
    end
end

function Button:Connect(Signal, Handler)
    local Connection = Signal:Connect(Handler)
    table.insert(self.Connections, Connection)
    return Connection
end

function Button:CommitOnBlur(Option)
    local Box = Option.Textbox.Input

    self:Connect(Box.FocusLost, function(Enter)
        if not Enter then
            Option:SetValue(Box.Text)
        end
    end)
end

function Button:Theme()
    return self.Library:GetThemeData(self.Library.Theme)
end

function Button:CaptionText()
    if self.Stateful then
        return self.BaseText .. (self.State and ": ON" or ": OFF")
    end
    return self.BaseText
end

function Button:Visibility()
    -- same math as Window:ApplyPaint, driven by the Transparency slider
    local Opacity = 1 - self.Transparency / 100
    return Opacity * (self.Library.Transparency and 0.92 or 1)
end

function Button:ApplyLayers()
    local Active = self.Library.UseAcrylic and self.Library.Acrylic and true or false
    local Visibility = self:Visibility()

    local function Scale(Transparency)
        return 1 - (1 - Transparency) * Visibility
    end

    self.Base.BackgroundTransparency = Active and Scale(0.9) or 1
    self.Main.BackgroundTransparency = Active and Scale(0.45) or 1
    self.Fill.BackgroundTransparency = Scale(Active and 0.4 or 0)
    self.Grain.Visible = Active
    self.Noise.Visible = Active
    self.Grain.ImageTransparency = 0.98
    -- outline fades together with the Transparency slider
    self.Border.Transparency = 1 - (1 - (self.BorderAlpha or 0)) * Visibility
end

function Button:Paint()
    local Theme = self:Theme()
    local On = self.Stateful and self.State
    local Active = self.Library.UseAcrylic and self.Library.Acrylic and true or false

    -- Acrylic family tags (same ones the window uses)
    self.Main.BackgroundColor3 = Theme.AcrylicMain
    self.Gradient.Color = Theme.AcrylicGradient
    self.Noise.ImageTransparency = Theme.AcrylicNoise

    -- ON state: accent wash on top of the acrylic, like a selected item
    self.Tint.BackgroundColor3 = Theme.Accent
    self.Tint.BackgroundTransparency = On and 0.82 or 1

    local Tint = On and Theme.Accent or Theme.Text
    local Neutral = NeutralThemes[self.Library.Theme] == true

    if On and not Neutral then
        Tint = Theme.Text
    end

    -- stroke color comes from its gradient (stroke Color stays white)
    local Edge = Theme.AcrylicBorder
    local Glow = On and Theme.Accent or Theme.Accent:Lerp(Edge, 0.45)
    self.StrokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Edge:Lerp(Glow, On and 0.5 or 0.2)),
        ColorSequenceKeypoint.new(0.5, Glow),
        ColorSequenceKeypoint.new(1, Edge:Lerp(Glow, On and 0.5 or 0.2)),
    })
    self.BorderAlpha = On and 0.15 or (Active and 0.4 or 0.2)

    self.Border.Color = Color3.new(1, 1, 1)
    self.Border.Thickness = DefaultStroke

    self.Overlay.BackgroundColor3 = Theme.Hover
    self.Caption.TextColor3 = Tint
    self.Glyph.ImageColor3 = Tint

    self.Switcher.BackgroundColor3 = Theme.AcrylicMain
    self.SwitcherBorder.Color = Theme.AcrylicBorder
    self.SwitcherBorder.Transparency = 0
    self.SwitcherGlyph.ImageColor3 = Theme.Text

    self:ApplyLayers()
end

function Button:StartShine()
    self:Connect(RunService.Heartbeat, function(Delta)
        if not self.Root.Parent then
            return
        end

        if self.Root.Visible then
            self.Gradient.Rotation = (self.Gradient.Rotation + BackgroundSpin * Delta) % 360
            self.StrokeGradient.Rotation = (self.StrokeGradient.Rotation + StrokeSpin * Delta) % 360
        elseif self.Gradient.Rotation ~= 90 or self.StrokeGradient.Rotation ~= 0 then
            self.Gradient.Rotation = 90
            self.StrokeGradient.Rotation = 0
        end
    end)
end

function Button:UpdateOverlay()
    local Theme = self:Theme()
    local Target = 1

    if self.Pressing then
        Target = Theme.PressedTransparency
    elseif self.Hovering then
        Target = Theme.HoverTransparency
    end

    TweenService:Create(self.Overlay, HoverTweenInfo, { BackgroundTransparency = Target }):Play()
end

function Button:Place(X, Y)
    local Bounds = self.Gui.AbsoluteSize

    self.Root.Position = UDim2.fromOffset(
        math.clamp(X, 0, math.max(Bounds.X - self.CurrentWidth, 0)),
        math.clamp(Y, 0, math.max(Bounds.Y - self.CurrentHeight, 0))
    )
end

function Button:Layout()
    local Circle = self.Shape == "Circle"
    local PixelW, PixelH = self:Pixels()
    local Side = math.min(PixelW, PixelH)

    self.CurrentWidth = Circle and Side or PixelW
    self.CurrentHeight = Circle and Side or PixelH

    if Circle then
        self.Root.Size = UDim2.fromOffset(Side, Side)
    else
        -- scale size, same as UDim2.new(Size1, 0, Size2, 0)
        self.Root.Size = UDim2.new(self.Width, 0, self.Height, 0)
    end

    local Radius = Circle and Side / 2 * self.Rounded / 100 or math.min(DefaultRadius, Side / 2)
    for _, Corner in ipairs(self.Corners) do
        Corner.CornerRadius = UDim.new(0, Radius)
    end

    local HasText = self.Caption.Text ~= ""
    local TextSize

    if Circle then
        TextSize = math.clamp(math.floor(Side * 0.45), 9, 24)
    else
        TextSize = math.clamp(math.floor(PixelH * 0.5), 9, self.Glyph.Visible and 18 or 24)
    end

    local GlyphSize = math.clamp(math.floor(Side * (HasText and 0.36 or 0.5)), 12, 40)

    self.Caption.Visible = HasText
    self.Caption.TextWrapped = Circle
    self.Caption.TextSize = TextSize
    self.Caption.Size = UDim2.new(1, -8, 0, Circle and (TextSize * 2 + 2) or (TextSize + 2))
    self.Glyph.Size = UDim2.fromOffset(GlyphSize, GlyphSize)

    self:Place(self.Root.Position.X.Offset, self.Root.Position.Y.Offset)
end

function Button:RefreshRows()
    if not self.TransparencyOption then
        return
    end

    self.LockOption:SetVisible(self.Enabled)
    self.ShapeOption:SetVisible(self.Enabled)
    self.SizeOption:SetVisible(self.Enabled)
    self.RoundedOption:SetVisible(self.Enabled and self.Shape == "Circle")
    self.TransparencyOption:SetVisible(self.Enabled)
end

function Button:ApplyLocked(Value)
    Value = Value == true

    if Value == self.Locked then
        return
    end

    self.Locked = Value

    if Value then
        self.Switcher.Visible = false
    end

    if self.Silent then
        return
    end

    self.Library:Notify({
        Title = "Floating Button",
        Content = self.Title .. (Value and " locked" or " unlocked"),
        Duration = 3,
    })
end

function Button:ShowSwitcher()
    local Left = self.Root.AbsolutePosition.X - self.Gui.AbsolutePosition.X
    local HasRoom = Left >= 46

    self.Switcher.AnchorPoint = Vector2.new(HasRoom and 1 or 0, 0.5)
    self.Switcher.Position = HasRoom and UDim2.new(0, -8, 0.5, 0) or UDim2.new(1, 8, 0.5, 0)
    self.SwitcherGlyph.Image = self.Library:GetIcon(self.Shape == "Circle" and "square" or "circle") or ""
    self.Switcher.Visible = true

    self.SwitcherToken = self.SwitcherToken + 1
    local Token = self.SwitcherToken

    task.delay(SwitcherLife, function()
        if self.SwitcherToken == Token then
            self.Switcher.Visible = false
        end
    end)
end

function Button:ApplyEnabled(Value)
    self.Enabled = Value
    self.Root.Visible = Value

    if not Value then
        self.Switcher.Visible = false
    end

    self:RefreshRows()
end

function Button:ApplyShape(Value)
    self.Shape = Value == "Circle" and "Circle" or "Rectangle"

    if self.Switcher.Visible then
        self:ShowSwitcher()
    end

    self:Layout()
    self:RefreshRows()
end

function Button:ApplySize(Value)
    local Width, Height = ParseSize(Value)

    if not Width then
        if self.SizeOption then
            self.SizeOption:SetValue(FormatSize(self.Width, self.Height))
        end
        return
    end

    self.Width, self.Height = Width, Height
    self:Layout()
end

function Button:ApplyRounded(Value)
    local Percent = ParseRounded(Value)

    if not Percent then
        if self.RoundedOption then
            self.RoundedOption:SetValue(string.format("%g", self.Rounded))
        end
        return
    end

    self.Rounded = Percent
    self:Layout()
end

function Button:ApplyTransparency(Value)
    self.Transparency = Value
    self:ApplyLayers()
end

function Button:BindInput()
    local ActiveInput, Origin, Start

    self:Connect(self.Hit.MouseEnter, function()
        self.Hovering = true
        self:UpdateOverlay()
    end)

    self:Connect(self.Hit.MouseLeave, function()
        self.Hovering = false
        self:UpdateOverlay()
    end)

    self:Connect(self.Hit.InputBegan, function(Input)
        if not IsPointer(Input) then
            return
        end

        self.Pressing, self.Moved, self.Held = true, false, false
        ActiveInput = Input
        Origin = Input.Position
        Start = self.Root.AbsolutePosition - self.Gui.AbsolutePosition
        self.PressToken = self.PressToken + 1
        self:UpdateOverlay()

        local Token = self.PressToken

        task.delay(HoldTime, function()
            if self.Pressing and not self.Moved and self.PressToken == Token then
                self.Held = true
                self:ToggleLock()

                if not self.Locked then
                    self:ShowSwitcher()
                end
            end
        end)
    end)

    self:Connect(UserInputService.InputChanged, function(Input)
        if not self.Pressing then
            return
        end

        local IsMouse = Input.UserInputType == Enum.UserInputType.MouseMovement

        if not IsMouse and Input ~= ActiveInput then
            return
        end

        local Delta = Input.Position - Origin

        if not self.Moved and Delta.Magnitude < DragThreshold then
            return
        end

        self.Moved = true

        if self.Locked then
            return
        end

        self:Place(Start.X + Delta.X, Start.Y + Delta.Y)
    end)

    self:Connect(UserInputService.InputEnded, function(Input)
        if not self.Pressing or not IsPointer(Input) then
            return
        end

        if Input.UserInputType == Enum.UserInputType.Touch and Input ~= ActiveInput then
            return
        end

        self.Pressing = false
        ActiveInput = nil
        self:UpdateOverlay()

        if not self.Moved and not self.Held then
            self:Activate()
        end
    end)

    self:Connect(self.Switcher.MouseButton1Click, function()
        self:SetShape(self.Shape == "Circle" and "Rectangle" or "Circle")
        self:ShowSwitcher()
    end)

    self:Connect(self.Gui:GetPropertyChangedSignal("AbsoluteSize"), function()
        self:Layout()
    end)

    self:Connect(self.Gui.Destroying, function()
        self:Disconnect()
    end)
end

function Button:Activate()
    if self.Stateful then
        self.State = not self.State
        self.Caption.Text = self:CaptionText()
        self:Paint()
    end

    self.Library:SafeCallback(self.Callback, self.State)
    self.Library:SafeCallback(self.Changed, self.State)
end

function Button:OnChanged(Callback)
    self.Changed = Callback
end

function Button:SetCallback(Callback)
    self.Callback = Callback or function() end
end

function Button:GetType()
    return self.Type
end

function Button:GetState()
    return self.State
end

function Button:SetState(Value)
    self.State = Value == true
    self.Caption.Text = self:CaptionText()
    self:Paint()
end

function Button:SetText(Text)
    self.BaseText = tostring(Text or "")
    self.Caption.Text = self:CaptionText()
    self:Layout()
end

function Button:SetEnabled(Value)
    self.Toggle:SetValue(Value)
end

function Button:SetShape(Value)
    self.ShapeOption:SetValue(Value)
end

function Button:SetSize(Width, Height)
    self.SizeOption:SetValue(FormatSize(Width, Height))
end

function Button:SetRounded(Value)
    self.RoundedOption:SetValue(tostring(Value))
end

function Button:SetTransparency(Value)
    self.TransparencyOption:SetValue(Value)
end

function Button:ToggleLock()
    self.LockOption:SetValue(not self.Locked)
end

function Button:GetLocked()
    return self.Locked
end

function Button:SetLocked(Value, Silent)
    self.Silent = Silent == true
    self.LockOption:SetValue(Value == true)
    self.Silent = false
end

function Button:GetPosition()
    return self.Root.Position
end

function Button:SetPosition(Position)
    self:Place(Position.X.Offset, Position.Y.Offset)
end

function Button:Disconnect()
    for _, Connection in next, self.Connections do
        Connection:Disconnect()
    end

    table.clear(self.Connections)

    if self.ThemeConnection then
        self.ThemeConnection:disconnect()
        self.ThemeConnection = nil
    end
end

function Button:Destroy()
    self:Disconnect()

    if self.Owner.Buttons[self.Idx] == self then
        self.Owner.Buttons[self.Idx] = nil
    end

    self.Root:Destroy()

    for _, Option in next, self.Options do
        Option:Destroy()
    end

    if self.Section then
        self.Section:Destroy()
    end
end

return FloatingButton
