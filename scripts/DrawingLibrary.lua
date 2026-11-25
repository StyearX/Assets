local cloneref = (cloneref or clonereference or function(Instance: any)
	return Instance
end)
local Players: Players = cloneref(game:GetService("Players"))
local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
local HttpService: HttpService = cloneref(game:GetService("HttpService"))
-- Rape A Femboy Simulator
export type DrawingType = "Line" | "Rectangle" | "Circle" | "Triangle" | "Text" | "Image"

export type Properties = { [string]: any }

export type Drawing = {
	Set: (Self: Drawing, Properties: Properties) -> Drawing,
	Remove: (Self: Drawing) -> (),
	Destroy: (Self: Drawing) -> (),
	[string]: any,
}

type Class = {
	Defaults: Properties,
	Create: () -> GuiObject,
	Render: (Element: any, Data: Properties) -> (),
}

local DrawingLibrary = {}
DrawingLibrary.Objects = {} :: { Drawing }
DrawingLibrary.Gui = nil :: ScreenGui?

local Pools = setmetatable({}, { __mode = "k" }) :: { [Instance]: { Frame } }

local function Mount(Gui: ScreenGui)
	if syn and syn.protect_gui then
		pcall(syn.protect_gui, Gui)
	elseif protect_gui then
		pcall(protect_gui, Gui)
	elseif protectgui then
		pcall(protectgui, Gui)
	end

	local Success = pcall(function()
		Gui.Parent = gethui and gethui() or CoreGui
	end)

	if not Success or not Gui.Parent then
		Gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end
end

local function GetGui(): ScreenGui
	local Existing = DrawingLibrary.Gui

	if Existing and Existing.Parent then
		return Existing
	end

	local Gui = Instance.new("ScreenGui")
	Gui.Name = HttpService:GenerateGUID(false)
	Gui.IgnoreGuiInset = true
	Gui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	Gui.ClipToDeviceSafeArea = false
	Gui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None
	Gui.ResetOnSpawn = false
	Gui.DisplayOrder = 2147483647
	Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Mount(Gui)

	DrawingLibrary.Gui = Gui
	return Gui
end

local function StyleLine(Element: Frame, From: Vector2, To: Vector2, Thickness: number, Color: Color3, Opacity: number)
	local Delta = To - From
	local Middle = (From + To) / 2

	Element.AnchorPoint = Vector2.new(0.5, 0.5)
	Element.Position = UDim2.fromOffset(Middle.X, Middle.Y)
	Element.Size = UDim2.fromOffset(Delta.Magnitude, Thickness)
	Element.Rotation = math.deg(math.atan2(Delta.Y, Delta.X))
	Element.BackgroundColor3 = Color
	Element.BackgroundTransparency = 1 - Opacity
end

local function CreateFrame(): Frame
	local Frame = Instance.new("Frame")
	Frame.BorderSizePixel = 0
	Frame.BackgroundTransparency = 1
	return Frame
end

local Classes: { [string]: Class } = {}

Classes.Line = {
	Defaults = {
		From = Vector2.zero,
		To = Vector2.zero,
		Thickness = 1,
		Color = Color3.new(1, 1, 1),
		Opacity = 1,
		Visible = true,
		ZIndex = 1,
	},
	Create = function()
		return CreateFrame()
	end,
	Render = function(Element: Frame, Data: Properties)
		StyleLine(Element, Data.From, Data.To, Data.Thickness, Data.Color, Data.Opacity)
		Element.Visible = Data.Visible
		Element.ZIndex = Data.ZIndex
	end,
}

Classes.Rectangle = {
	Defaults = {
		Position = Vector2.zero,
		Size = Vector2.new(100, 100),
		Thickness = 1,
		Rounding = 0,
		Filled = false,
		Color = Color3.new(1, 1, 1),
		Opacity = 1,
		Visible = true,
		ZIndex = 1,
	},
	Create = function()
		local Frame = CreateFrame()

		local Stroke = Instance.new("UIStroke")
		Stroke.Name = "Stroke"
		Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		Stroke.Parent = Frame

		local Corner = Instance.new("UICorner")
		Corner.Name = "Corner"
		Corner.Parent = Frame

		return Frame
	end,
	Render = function(Element: any, Data: Properties)
		Element.Position = UDim2.fromOffset(Data.Position.X, Data.Position.Y)
		Element.Size = UDim2.fromOffset(Data.Size.X, Data.Size.Y)
		Element.BackgroundColor3 = Data.Color
		Element.BackgroundTransparency = Data.Filled and (1 - Data.Opacity) or 1
		Element.Visible = Data.Visible
		Element.ZIndex = Data.ZIndex

		local Stroke = Element.Stroke
		Stroke.Enabled = not Data.Filled
		Stroke.Thickness = Data.Thickness
		Stroke.Color = Data.Color
		Stroke.Transparency = 1 - Data.Opacity

		Element.Corner.CornerRadius = UDim.new(0, Data.Rounding)
	end,
}

Classes.Circle = {
	Defaults = {
		Position = Vector2.zero,
		Radius = 50,
		Thickness = 1,
		Filled = false,
		Color = Color3.new(1, 1, 1),
		Opacity = 1,
		Visible = true,
		ZIndex = 1,
	},
	Create = function()
		local Frame = CreateFrame()
		Frame.AnchorPoint = Vector2.new(0.5, 0.5)

		local Stroke = Instance.new("UIStroke")
		Stroke.Name = "Stroke"
		Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		Stroke.Parent = Frame

		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0.5, 0)
		Corner.Parent = Frame

		return Frame
	end,
	Render = function(Element: any, Data: Properties)
		Element.Position = UDim2.fromOffset(Data.Position.X, Data.Position.Y)
		Element.Size = UDim2.fromOffset(Data.Radius * 2, Data.Radius * 2)
		Element.BackgroundColor3 = Data.Color
		Element.BackgroundTransparency = Data.Filled and (1 - Data.Opacity) or 1
		Element.Visible = Data.Visible
		Element.ZIndex = Data.ZIndex

		local Stroke = Element.Stroke
		Stroke.Enabled = not Data.Filled
		Stroke.Thickness = Data.Thickness
		Stroke.Color = Data.Color
		Stroke.Transparency = 1 - Data.Opacity
	end,
}

Classes.Triangle = {
	Defaults = {
		PointA = Vector2.new(0, 0),
		PointB = Vector2.new(100, 0),
		PointC = Vector2.new(50, 100),
		Thickness = 1,
		Filled = false,
		Color = Color3.new(1, 1, 1),
		Opacity = 1,
		Visible = true,
		ZIndex = 1,
	},
	Create = function()
		local Holder = CreateFrame()
		Holder.Size = UDim2.fromScale(1, 1)

		for Index = 1, 3 do
			local Edge = CreateFrame()
			Edge.Name = "Edge" .. Index
			Edge.Parent = Holder
		end

		Pools[Holder] = {}
		return Holder
	end,
	Render = function(Element: Frame, Data: Properties)
		local Points: { Vector2 } = { Data.PointA, Data.PointB, Data.PointC }

		Element.Visible = Data.Visible
		Element.ZIndex = Data.ZIndex

		for Index = 1, 3 do
			local Edge = Element:FindFirstChild("Edge" .. Index) :: Frame
			local From = Points[Index]
			local To = Points[Index % 3 + 1]

			StyleLine(Edge, From, To, Data.Thickness, Data.Color, Data.Opacity)
			Edge.Visible = not Data.Filled
		end

		local Pool = Pools[Element]
		local Count = 0

		if Data.Filled then
			local MinY = math.floor(math.min(Points[1].Y, Points[2].Y, Points[3].Y))
			local MaxY = math.ceil(math.max(Points[1].Y, Points[2].Y, Points[3].Y))

			for Y = MinY, MaxY do
				local ScanY = Y + 0.5
				local MinX = math.huge
				local MaxX = -math.huge

				for Index = 1, 3 do
					local P = Points[Index]
					local Q = Points[Index % 3 + 1]

					if (P.Y <= ScanY and Q.Y > ScanY) or (Q.Y <= ScanY and P.Y > ScanY) then
						local Alpha = (ScanY - P.Y) / (Q.Y - P.Y)
						local X = P.X + (Q.X - P.X) * Alpha
						MinX = math.min(MinX, X)
						MaxX = math.max(MaxX, X)
					end
				end

				if MaxX > MinX then
					Count += 1

					local Strip = Pool[Count]
					if not Strip then
						Strip = CreateFrame()
						Strip.Name = "Strip"
						Strip.Parent = Element
						Pool[Count] = Strip
					end

					Strip.Position = UDim2.fromOffset(MinX, Y)
					Strip.Size = UDim2.fromOffset(MaxX - MinX, 1)
					Strip.BackgroundColor3 = Data.Color
					Strip.BackgroundTransparency = 1 - Data.Opacity
					Strip.Visible = true
				end
			end
		end

		for Index = Count + 1, #Pool do
			Pool[Index].Visible = false
		end
	end,
}

Classes.Text = {
	Defaults = {
		Position = Vector2.zero,
		Text = "",
		Size = 16,
		Font = Enum.Font.Code,
		Center = false,
		Outline = false,
		OutlineColor = Color3.new(0, 0, 0),
		Color = Color3.new(1, 1, 1),
		Opacity = 1,
		Visible = true,
		ZIndex = 1,
	},
	Create = function()
		local Label = Instance.new("TextLabel")
		Label.BackgroundTransparency = 1
		Label.BorderSizePixel = 0
		Label.AutomaticSize = Enum.AutomaticSize.XY
		Label.Size = UDim2.fromOffset(0, 0)
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.TextYAlignment = Enum.TextYAlignment.Top
		return Label
	end,
	Render = function(Element: TextLabel, Data: Properties)
		Element.AnchorPoint = Data.Center and Vector2.new(0.5, 0.5) or Vector2.zero
		Element.Position = UDim2.fromOffset(Data.Position.X, Data.Position.Y)
		Element.Text = Data.Text
		Element.TextSize = Data.Size
		Element.Font = Data.Font
		Element.TextColor3 = Data.Color
		Element.TextTransparency = 1 - Data.Opacity
		Element.TextStrokeColor3 = Data.OutlineColor
		Element.TextStrokeTransparency = Data.Outline and 0 or 1
		Element.Visible = Data.Visible
		Element.ZIndex = Data.ZIndex
	end,
}

Classes.Image = {
	Defaults = {
		Position = Vector2.zero,
		Size = Vector2.new(100, 100),
		Image = "",
		Rounding = 0,
		Color = Color3.new(1, 1, 1),
		Opacity = 1,
		Visible = true,
		ZIndex = 1,
	},
	Create = function()
		local Label = Instance.new("ImageLabel")
		Label.BackgroundTransparency = 1
		Label.BorderSizePixel = 0

		local Corner = Instance.new("UICorner")
		Corner.Name = "Corner"
		Corner.Parent = Label

		return Label
	end,
	Render = function(Element: any, Data: Properties)
		Element.Position = UDim2.fromOffset(Data.Position.X, Data.Position.Y)
		Element.Size = UDim2.fromOffset(Data.Size.X, Data.Size.Y)
		Element.Image = Data.Image
		Element.ImageColor3 = Data.Color
		Element.ImageTransparency = 1 - Data.Opacity
		Element.Visible = Data.Visible
		Element.ZIndex = Data.ZIndex
		Element.Corner.CornerRadius = UDim.new(0, Data.Rounding)
	end,
}

local Object = {}

Object.__index = function(Self: Drawing, Key: string): any
	local Method = Object[Key]
	if Method ~= nil then
		return Method
	end
	return rawget(Self, "Data")[Key]
end

Object.__newindex = function(Self: Drawing, Key: string, Value: any)
	if rawget(Self, "Removed") then
		return
	end

	local Data: Properties = rawget(Self, "Data")
	assert(Data[Key] ~= nil, "Invalid property: " .. tostring(Key))

	if Data[Key] ~= Value then
		Data[Key] = Value
		Object.Refresh(Self)
	end
end

function Object.Refresh(Self: Drawing)
	if rawget(Self, "Removed") then
		return
	end
	rawget(Self, "Class").Render(rawget(Self, "Element"), rawget(Self, "Data"))
end

function Object.Set(Self: Drawing, Properties: Properties): Drawing
	if rawget(Self, "Removed") then
		return Self
	end

	local Data: Properties = rawget(Self, "Data")
	local Changed = false

	for Key, Value in Properties do
		assert(Data[Key] ~= nil, "Invalid property: " .. tostring(Key))

		if Data[Key] ~= Value then
			Data[Key] = Value
			Changed = true
		end
	end

	if Changed then
		Object.Refresh(Self)
	end

	return Self
end

function Object.Remove(Self: Drawing)
	if rawget(Self, "Removed") then
		return
	end

	rawset(Self, "Removed", true)
	rawget(Self, "Element"):Destroy()

	local Index = table.find(DrawingLibrary.Objects, Self)
	if Index then
		table.remove(DrawingLibrary.Objects, Index)
	end
end

Object.Destroy = Object.Remove

function DrawingLibrary.New(Type: DrawingType, Properties: Properties?): Drawing
	local Class = Classes[Type]
	assert(Class, "Invalid drawing type: " .. tostring(Type))

	local Data: Properties = {}
	for Key, Value in Class.Defaults do
		Data[Key] = Value
	end

	if Properties then
		for Key, Value in Properties do
			assert(Class.Defaults[Key] ~= nil, "Invalid property: " .. tostring(Key))
			Data[Key] = Value
		end
	end

	local Element = Class.Create()
	Element.Parent = GetGui()

	local Self: Drawing = setmetatable({
		Data = Data,
		Class = Class,
		Element = Element,
		Removed = false,
	}, Object) :: any

	table.insert(DrawingLibrary.Objects, Self)
	Class.Render(Element, Data)

	return Self
end

function DrawingLibrary.Configure(Properties: Properties)
	local Gui: any = GetGui()

	for Key, Value in Properties do
		Gui[Key] = Value
	end
end

function DrawingLibrary.Clear()
	for Index = #DrawingLibrary.Objects, 1, -1 do
		DrawingLibrary.Objects[Index]:Remove()
	end
end

function DrawingLibrary.Destroy()
	DrawingLibrary.Clear()

	local Gui = DrawingLibrary.Gui

	if Gui then
		Gui:Destroy()
		DrawingLibrary.Gui = nil
	end
end

return DrawingLibrary
