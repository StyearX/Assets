local CloneRef = cloneref or function(Service)
	return Service
end

local Players = CloneRef(game:GetService("Players"))
local RunService = CloneRef(game:GetService("RunService"))
local UserInputService = CloneRef(game:GetService("UserInputService"))
local HttpService = CloneRef(game:GetService("HttpService"))
local MarketplaceService = CloneRef(game:GetService("MarketplaceService"))
local GuiService = CloneRef(game:GetService("GuiService"))
local Workspace = CloneRef(game:GetService("Workspace"))

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Constants = {
	Version = "2.0.0",
	RenderStepName = "HUDManagerEnforce",
	RenderPriority = 2000,
	OverlayLayer = "HUDManager",
	ShieldLayer = "HUDManagerShield",
	OverlayOrder = 99999,
	ShieldOrder = 998,
	HistoryLimit = 100,
	MergeWindow = 0.8,
	ViewportLimit = 0.8,
	ClusterDistance = 10,
	ClusterMaxSize = 350,
	ClusterParentRatio = 1.5,
	ParentSizeSlack = 30,
	TapThreshold = 10,
	DragSlop = 3,
	MinElementSize = 4,
	ScanBatch = 300,
	MapInterval = 0.2,
	RepeatDelay = 0.4,
	RepeatInterval = 0.06,
	ViewportMargin = 6,
	DockCollapsed = 44,
	DockExpanded = 156,
	DockHold = 2.5,
	DockLeave = 0.35,
	DockSpeed = 18,
	LockAttribute = "Locked",
	FormatVersion = 2,
	LegacyFolder = "PerfectUIManager_Configs",
	NudgeSteps = { 1, 5, 10, 25 },
	Icons = {
		Edit = "lucide:pencil",
		Undo = "lucide:undo-2",
		Redo = "lucide:redo-2",
		Save = "lucide:save",
		Panel = "lucide:layout-dashboard",
		Advanced = "lucide:sliders-horizontal",
		Close = "lucide:x",
		Settings = "lucide:settings",
		Power = "lucide:power",
		Lock = "lucide:lock",
		Unlock = "lucide:unlock",
		Plus = "lucide:plus",
		Minus = "lucide:minus",
		Reset = "lucide:rotate-ccw",
		Delete = "lucide:eye-off",
		Up = "lucide:arrow-up",
		Down = "lucide:arrow-down",
		Left = "lucide:arrow-left",
		Right = "lucide:arrow-right",
		Launcher = "lucide:layout-dashboard",
		Focus = "lucide:crosshair",
		Grip = "lucide:grip-horizontal",
	},
	Glyphs = {
		Edit = "E",
		Undo = "<",
		Redo = ">",
		Save = "S",
		Panel = "P",
		Advanced = "A",
		Close = "x",
		Settings = "S",
		Power = "X",
		Lock = "L",
		Unlock = "U",
		Plus = "+",
		Minus = "-",
		Reset = "R",
		Delete = "H",
		Up = "^",
		Down = "v",
		Left = "<",
		Right = ">",
		Launcher = "H",
		Focus = "O",
		Grip = "...",
	},
}

local Signal = {}
Signal.__index = Signal

local Connection = {}
Connection.__index = Connection

function Connection:Disconnect()
	if not self.Connected then
		return
	end

	self.Connected = false

	local Index = table.find(self.Owner.Handlers, self)
	if Index then
		table.remove(self.Owner.Handlers, Index)
	end
end

function Signal.new()
	return setmetatable({ Handlers = {} }, Signal)
end

function Signal:Connect(Handler)
	local Link = setmetatable({ Handler = Handler, Owner = self, Connected = true }, Connection)
	table.insert(self.Handlers, Link)
	return Link
end

function Signal:Fire(...)
	for _, Link in table.clone(self.Handlers) do
		if Link.Connected then
			task.spawn(Link.Handler, ...)
		end
	end
end

local Util = {}

function Util.IsPointer(Input)
	local InputType = Input.UserInputType
	return InputType == Enum.UserInputType.MouseButton1 or InputType == Enum.UserInputType.Touch
end

function Util.IsBlank(Value)
	return type(Value) ~= "string" or string.match(Value, "^%s*$") ~= nil
end

function Util.Trim(Value)
	return (string.gsub(tostring(Value or ""), "^%s*(.-)%s*$", "%1"))
end

function Util.SanitizeName(Value)
	return (string.gsub(Util.Trim(Value), '[\\/:*?"<>|]', ""))
end

function Util.HasFileSystem()
	return type(writefile) == "function"
		and type(readfile) == "function"
		and type(isfile) == "function"
		and type(isfolder) == "function"
		and type(makefolder) == "function"
		and type(listfiles) == "function"
end

function Util.EnsureFolder(Path)
	if type(isfolder) ~= "function" or type(makefolder) ~= "function" then
		return
	end

	local Built = ""
	for Part in string.gmatch(Path, "[^/\\]+") do
		Built = if Built == "" then Part else Built .. "/" .. Part
		if not isfolder(Built) then
			pcall(makefolder, Built)
		end
	end
end

function Util.ReadJson(Path)
	if type(isfile) ~= "function" or not isfile(Path) then
		return nil
	end

	local Success, Data = pcall(function()
		return HttpService:JSONDecode(readfile(Path))
	end)

	if Success and type(Data) == "table" then
		return Data
	end

	return nil
end

function Util.WriteJson(Path, Data)
	local Encoded, Text = pcall(HttpService.JSONEncode, HttpService, Data)
	if not Encoded then
		return false, "encode failed"
	end

	if not pcall(writefile, Path, Text) then
		return false, "write failed"
	end

	return true
end

function Util.UDim2ToArray(Value)
	return { Value.X.Scale, Value.X.Offset, Value.Y.Scale, Value.Y.Offset }
end

function Util.ArrayToUDim2(Array)
	if type(Array) ~= "table" then
		return nil
	end

	for Index = 1, 4 do
		if type(Array[Index]) ~= "number" then
			return nil
		end
	end

	return UDim2.new(Array[1], Array[2], Array[3], Array[4])
end

function Util.GetViewport()
	local Camera = Workspace.CurrentCamera
	return if Camera then Camera.ViewportSize else Vector2.new(1920, 1080)
end

function Util.WatchViewport(Callback)
	local CameraLink = nil

	local function Bind()
		if CameraLink then
			CameraLink:Disconnect()
			CameraLink = nil
		end

		local Camera = Workspace.CurrentCamera
		if Camera then
			CameraLink = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(Callback)
		end
	end

	local SwapLink = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		Bind()
		Callback()
	end)

	Bind()

	return function()
		SwapLink:Disconnect()

		if CameraLink then
			CameraLink:Disconnect()
			CameraLink = nil
		end
	end
end

function Util.PointInGui(Point, Gui)
	local Position = Gui.AbsolutePosition
	local Size = Gui.AbsoluteSize
	return Point.X >= Position.X
		and Point.X <= Position.X + Size.X
		and Point.Y >= Position.Y
		and Point.Y <= Position.Y + Size.Y
end

function Util.Snap(Value, Step)
	if Step <= 0 then
		return Value
	end

	return math.round(Value / Step) * Step
end

function Util.SortedKeys(Table)
	local Keys = {}
	for Key in Table do
		table.insert(Keys, Key)
	end
	table.sort(Keys)
	return Keys
end

local KeyResolver = {}

function KeyResolver.Resolve(Object)
	local Base = Object.Name
	local Trait = ""

	if Object.Name == "ContextActionButton" then
		local Title = Object:FindFirstChild("ActionTitle")
		if Title and Title:IsA("TextLabel") and Title.Text ~= "" then
			Base = "CAB_" .. Title.Text
		else
			local Icon = Object:FindFirstChild("ActionIcon")
			if Icon and Icon:IsA("ImageLabel") and Icon.Image ~= "" then
				Base = "CAB_IMG_" .. (string.match(Icon.Image, "%d+") or "ICO")
			end
		end
	elseif Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox") then
		if Object.Text ~= "" then
			Trait = Trait .. "_" .. string.sub(Object.Text, 1, 10)
		end
	elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
		if Object.Image ~= "" then
			local Id = string.match(Object.Image, "%d+")
			if Id then
				Trait = Trait .. "_IMG" .. Id
			end
		end
	end

	local Parent = Object.Parent
	if Parent then
		Base = Parent.Name .. "_" .. Base

		local Order = 1
		for _, Child in Parent:GetChildren() do
			if Child == Object then
				break
			end
			if Child.Name == Object.Name and Child.ClassName == Object.ClassName then
				Order += 1
			end
		end

		if Order > 1 then
			Trait = Trait .. "_IDX" .. Order
		end
	end

	return Base .. Trait
end

local Geometry = {}

function Geometry.FindLayout(Parent)
	if not Parent then
		return nil
	end

	local Found = nil
	pcall(function()
		Found = Parent:FindFirstChildWhichIsA("UILayout") or Parent:FindFirstChildWhichIsA("UIGridStyleLayout")
	end)
	return Found
end

function Geometry.VisualPosition(Gui)
	local Parent = Gui.Parent
	if not (Parent and Parent:IsA("GuiObject")) then
		return Gui.Position
	end

	local Origin = Parent.AbsolutePosition
	if Parent:IsA("ScrollingFrame") then
		Origin = Origin - Parent.CanvasPosition
	end

	local Anchor = Gui.AnchorPoint
	local Size = Gui.AbsoluteSize
	local Position = Gui.AbsolutePosition

	return UDim2.fromOffset(Position.X - Origin.X + Anchor.X * Size.X, Position.Y - Origin.Y + Anchor.Y * Size.Y)
end

function Geometry.VisualSize(Gui)
	if Gui.Size == UDim2.new() then
		return UDim2.fromOffset(Gui.AbsoluteSize.X, Gui.AbsoluteSize.Y)
	end

	return Gui.Size
end

function Geometry.OriginalPosition(Gui)
	if Geometry.FindLayout(Gui.Parent) then
		return Geometry.VisualPosition(Gui)
	end

	return Gui.Position
end

function Geometry.Center(Gui)
	return Gui.AbsolutePosition + Gui.AbsoluteSize / 2
end

function Geometry.Inset()
	local TopLeft = GuiService:GetGuiInset()
	return TopLeft
end

function Geometry.ScreenPosition(Gui)
	local Root = Gui:FindFirstAncestorOfClass("ScreenGui")

	if Root and not Root.IgnoreGuiInset then
		return Gui.AbsolutePosition + Geometry.Inset()
	end

	return Gui.AbsolutePosition
end

function Geometry.ContainsInput(Gui, Position)
	local Point = Vector2.new(Position.X, Position.Y) + Geometry.Inset()
	local Origin = Geometry.ScreenPosition(Gui)
	local Size = Gui.AbsoluteSize

	return Point.X >= Origin.X
		and Point.X <= Origin.X + Size.X
		and Point.Y >= Origin.Y
		and Point.Y <= Origin.Y + Size.Y
end

local RuleBook = {}
RuleBook.__index = RuleBook

function RuleBook.new()
	return setmetatable({
		Rules = {},
		Originals = {},
		Tracked = setmetatable({}, { __mode = "k" }),
		Hidden = setmetatable({}, { __mode = "k" }),
		Baked = setmetatable({}, { __mode = "k" }),
		External = setmetatable({}, { __mode = "k" }),
		Changed = Signal.new(),
	}, RuleBook)
end

function RuleBook:Snapshot(Key)
	local Rule = self.Rules[Key]
	return if Rule then table.clone(Rule) else nil
end

function RuleBook:Capture(Object, Key)
	if self.Originals[Key] then
		return
	end

	self.Originals[Key] = {
		Position = Geometry.OriginalPosition(Object),
		Size = Geometry.VisualSize(Object),
	}
end

function RuleBook:Ensure(Object, Key)
	local Rule = self.Rules[Key]
	if Rule then
		self.Tracked[Object] = Key
		return Rule
	end

	self:Capture(Object, Key)

	Rule = {
		Name = Object.Name,
		IsDeleted = false,
		Position = Geometry.VisualPosition(Object),
		Size = Geometry.VisualSize(Object),
		SizeModified = false,
	}

	self.Rules[Key] = Rule
	self.Tracked[Object] = Key
	return Rule
end

function RuleBook:Apply(Object, Key, Dragging, Yielding)
	local Rule = self.Rules[Key]
	if not Rule or not Object.Parent then
		return nil
	end

	if Rule.IsDeleted then
		self.External[Object] = nil

		if Object.Visible then
			self.Hidden[Object] = true
			Object.Visible = false
		end
		return nil
	end

	if self.Hidden[Object] then
		self.Hidden[Object] = nil
		Object.Visible = true
	end

	if Dragging then
		self.External[Object] = nil
		return nil
	end

	if Yielding then
		if Object.Position ~= Rule.Position then
			self.External[Object] = true
		end
		return nil
	end

	if self.External[Object] then
		self.External[Object] = nil

		if Object.Position ~= Rule.Position then
			return "Adopt"
		end
	end

	if Object.Position ~= Rule.Position then
		Object.Position = Rule.Position
	end

	if Rule.SizeModified and Object.Size ~= Rule.Size then
		Object.Size = Rule.Size
	end

	return nil
end

function RuleBook:Release(Key)
	local Rule = self.Rules[Key]
	local Original = self.Originals[Key]

	for Object, ObjectKey in self.Tracked do
		if ObjectKey == Key then
			if Object.Parent then
				if self.Hidden[Object] then
					Object.Visible = true
				end

				if Original then
					Object.Position = Original.Position
					if Rule and Rule.SizeModified then
						Object.Size = Original.Size
					end
				end
			end

			self.Hidden[Object] = nil
			self.External[Object] = nil
			self.Tracked[Object] = nil
		end
	end

	self.Rules[Key] = nil
	self.Originals[Key] = nil
end

function RuleBook:Clear()
	for Key in table.clone(self.Rules) do
		self:Release(Key)
	end
end

function RuleBook:FindObject(Key)
	for Object, ObjectKey in self.Tracked do
		if ObjectKey == Key and Object.Parent then
			return Object
		end
	end

	return nil
end

function RuleBook:Counts()
	local Counts = { Total = 0, Hidden = 0, Moved = 0, Resized = 0 }

	for _, Rule in self.Rules do
		Counts.Total += 1
		if Rule.IsDeleted then
			Counts.Hidden += 1
		else
			Counts.Moved += 1
		end
		if Rule.SizeModified then
			Counts.Resized += 1
		end
	end

	return Counts
end

local History = {}
History.__index = History

function History.new(Limit)
	return setmetatable({
		Undos = {},
		Redos = {},
		Limit = Limit,
		Changed = Signal.new(),
	}, History)
end

function History:Push(Label, Changes, Merge)
	if #Changes == 0 then
		return
	end

	local Top = self.Undos[#self.Undos]

	if Merge and Top and Top.Label == Label and os.clock() - Top.Time <= Constants.MergeWindow and #Top.Changes == #Changes then
		local Same = true
		for Index, Change in Changes do
			if Top.Changes[Index].Key ~= Change.Key then
				Same = false
				break
			end
		end

		if Same then
			for Index, Change in Changes do
				Top.Changes[Index].After = Change.After
			end
			Top.Time = os.clock()
			table.clear(self.Redos)
			self.Changed:Fire()
			return
		end
	end

	table.insert(self.Undos, { Label = Label, Changes = Changes, Time = os.clock() })

	if #self.Undos > self.Limit then
		table.remove(self.Undos, 1)
	end

	table.clear(self.Redos)
	self.Changed:Fire()
end

function History:PopUndo()
	local Entry = table.remove(self.Undos)
	if Entry then
		table.insert(self.Redos, Entry)
		self.Changed:Fire()
	end
	return Entry
end

function History:PopRedo()
	local Entry = table.remove(self.Redos)
	if Entry then
		table.insert(self.Undos, Entry)
		self.Changed:Fire()
	end
	return Entry
end

function History:Clear()
	table.clear(self.Undos)
	table.clear(self.Redos)
	self.Changed:Fire()
end

local LayoutBaker = {}

function LayoutBaker.Bake(Book, Parent)
	if not Parent or Book.Baked[Parent] then
		return
	end

	local Layout = Geometry.FindLayout(Parent)
	if not Layout then
		Book.Baked[Parent] = true
		return
	end

	if Parent.AbsoluteSize.X <= 0 then
		return
	end

	local Snapshot = {}
	for _, Child in Parent:GetChildren() do
		if Child:IsA("GuiObject") and Child.Visible then
			if Child.AbsoluteSize.X == 0 then
				return
			end

			Snapshot[Child] = { Position = Child.AbsolutePosition, Size = Child.AbsoluteSize }
		end
	end

	Book.Baked[Parent] = true

	for Child, Data in Snapshot do
		Child.Size = UDim2.fromOffset(Data.Size.X, Data.Size.Y)
	end

	Layout:Destroy()

	local Origin = Parent.AbsolutePosition
	if Parent:IsA("ScrollingFrame") then
		Origin = Origin - Parent.CanvasPosition
	end

	for Child, Data in Snapshot do
		local Anchor = Child.AnchorPoint
		local Position = UDim2.fromOffset(
			Data.Position.X - Origin.X + Anchor.X * Data.Size.X,
			Data.Position.Y - Origin.Y + Anchor.Y * Data.Size.Y
		)

		Child.Position = Position
		Book.Originals[KeyResolver.Resolve(Child)] = {
			Position = Position,
			Size = UDim2.fromOffset(Data.Size.X, Data.Size.Y),
		}
	end
end

local Picker = {}

function Picker.IsJoystick(Gui)
	local Current = Gui

	while Current and Current:IsA("GuiObject") do
		local Name = string.lower(Current.Name)
		if string.find(Name, "thumbstick") or string.find(Name, "joystick") then
			return true
		end
		Current = Current.Parent
	end

	return false
end

function Picker.IsButtonLike(Gui)
	return Gui:IsA("GuiButton") or Gui:FindFirstChildWhichIsA("TouchTransmitter") ~= nil
end

function Picker.HasInteraction(Gui)
	return Gui:IsA("GuiButton")
		or Gui:FindFirstChildWhichIsA("TouchTransmitter") ~= nil
		or Gui:FindFirstChildWhichIsA("GuiButton", true) ~= nil
		or Gui:FindFirstChildWhichIsA("TouchTransmitter", true) ~= nil
end

function Picker.FindTop(Hits, Viewport, Accept)
	local MaxWidth = Viewport.X * Constants.ViewportLimit
	local MaxHeight = Viewport.Y * Constants.ViewportLimit

	local function Eligible(Gui)
		if not Accept(Gui) then
			return false
		end

		if Gui.AbsoluteSize.X >= MaxWidth or Gui.AbsoluteSize.Y >= MaxHeight then
			return false
		end

		return not Picker.IsJoystick(Gui)
	end

	for _, Gui in Hits do
		if Eligible(Gui) and Picker.IsButtonLike(Gui) then
			return Gui
		end
	end

	for _, Gui in Hits do
		if Eligible(Gui) and Gui.Visible then
			local Paints = Gui.BackgroundTransparency < 1
				or Gui:IsA("ImageLabel")
				or Gui:IsA("TextLabel")
				or Gui:IsA("TextBox")
				or Gui:IsA("Frame")

			if Paints then
				return Gui
			end
		end
	end

	return nil
end

function Picker.Climb(Top, Viewport)
	local MaxWidth = Viewport.X * Constants.ViewportLimit
	local MaxHeight = Viewport.Y * Constants.ViewportLimit
	local Current = Top.Parent
	local Highest = Top

	while Current and Current:IsA("GuiObject") do
		if Current.AbsoluteSize.X >= MaxWidth or Current.AbsoluteSize.Y >= MaxHeight then
			break
		end

		if Picker.IsJoystick(Current) then
			break
		end

		local HasSiblingControls = false
		for _, Child in Current:GetChildren() do
			if Child ~= Highest and Child:IsA("GuiObject") and Child.Visible and Picker.HasInteraction(Child) then
				HasSiblingControls = true
				break
			end
		end

		if HasSiblingControls then
			break
		end

		local Name = string.lower(Current.Name)
		local IsNamedButton = string.find(Name, "button")
			or string.find(Name, "btn")
			or string.find(Name, "shutter")
			or string.find(Name, "action")

		if Picker.IsButtonLike(Current) or IsNamedButton then
			Highest = Current
		elseif
			Current.AbsoluteSize.X <= Highest.AbsoluteSize.X + Constants.ParentSizeSlack
			and Current.AbsoluteSize.Y <= Highest.AbsoluteSize.Y + Constants.ParentSizeSlack
		then
			Highest = Current
		else
			break
		end

		Current = Current.Parent
	end

	return Highest
end

function Picker.Pick(Hits, Viewport, Mode, Accept)
	local Top = Picker.FindTop(Hits, Viewport, Accept)
	if not Top then
		return nil
	end

	if Mode == "Exact" then
		return Top
	end

	return Picker.Climb(Top, Viewport)
end

function Picker.BuildCluster(Target)
	local Cluster = { Target }
	local Added = { [Target] = true }
	local Parent = Target.Parent
	local TargetCenter = Geometry.Center(Target)

	if Parent then
		for _, Child in Parent:GetChildren() do
			if Child:IsA("GuiObject") and not Added[Child] then
				local Distance = (Geometry.Center(Child) - TargetCenter).Magnitude
				local Small = Child.AbsoluteSize.X < Constants.ClusterMaxSize and Child.AbsoluteSize.Y < Constants.ClusterMaxSize

				if Distance <= Constants.ClusterDistance and Small then
					table.insert(Cluster, Child)
					Added[Child] = true
				end
			end
		end
	end

	if Parent and Parent:IsA("GuiObject") and not Added[Parent] then
		local Distance = (Geometry.Center(Parent) - TargetCenter).Magnitude
		local Tight = Parent.AbsoluteSize.X <= Target.AbsoluteSize.X * Constants.ClusterParentRatio
			and Parent.AbsoluteSize.Y <= Target.AbsoluteSize.Y * Constants.ClusterParentRatio

		if Distance <= Constants.ClusterDistance and Tight then
			table.insert(Cluster, Parent)
			Added[Parent] = true
		end
	end

	local Pure = {}
	for _, Element in Cluster do
		local Nested = false
		for _, Other in Cluster do
			if Element ~= Other and Element:IsDescendantOf(Other) then
				Nested = true
				break
			end
		end

		if not Nested then
			table.insert(Pure, Element)
		end
	end

	return Pure
end

local Kit = {}

Kit.Tracked = setmetatable({}, { __mode = "k" })
Kit.Shadows = {}
Kit.Alpha = nil

local ShadowLayerCount = 8
local MonoFace = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

local ButtonStyles = {
	Menu = { Background = "Hover", Base = 1, Text = "Text" },
	MenuDanger = { Background = "Danger", Base = 1, HoverBase = 0.88, PressBase = 0.8, Text = "Danger" },
	Subtle = { Background = "DropdownFrame", Base = 0.93, Text = "Text", Stroke = true },
	Tonal = { Background = "Accent", Base = 0.84, Text = "Text", Stroke = true },
	Primary = { Background = "FillButton", Base = 0, Text = "FillButtonText" },
	Active = { Background = "Accent", Base = 0.82, Text = "Text", Stroke = true },
	Danger = { Background = "Danger", Base = 0.82, Text = "Danger" },
	Success = { Background = "Success", Base = 0.82, Text = "Success" },
	Ghost = { Background = "Hover", Base = 1, Text = "SubText" },
}

local IconObject = {}
IconObject.__index = IconObject

local ButtonObject = {}
ButtonObject.__index = ButtonObject

function Kit.Bind(Library)
	Kit.Library = Library
	Kit.Creator = Library.Internals.Creator
	Kit.Alpha = nil
end

function Kit.New(ClassName, Properties, Children)
	return Kit.Creator.New(ClassName, Properties, Children)
end

function Kit.Retag(Object, Tags)
	return Kit.Creator.OverrideTag(Object, Tags)
end

function Kit.Corner(Radius)
	return Kit.New("UICorner", { CornerRadius = UDim.new(0, Radius) })
end

function Kit.Visibility()
	local Library = Kit.Library
	local Window = Library.Window
	local Opacity = if Window and type(Window.Opacity) == "number" then Window.Opacity else 1
	return Opacity * (if Library.Transparency then 0.92 else 1)
end

function Kit.CurrentAlpha()
	return Kit.Library:GetPanelAlpha() * Kit.Visibility()
end

function Kit.Scale(Base)
	return 1 - (1 - Base) * Kit.CurrentAlpha()
end

function Kit.Track(Object, Property, Base)
	Kit.Tracked[Object] = { Property = Property, Base = Base }
	Object[Property] = Kit.Scale(Base)
end

function Kit.Rebase(Object, Base)
	local Entry = Kit.Tracked[Object]
	if Entry then
		Entry.Base = Base
	end

	return Kit.Scale(Base)
end

function Kit.Refresh()
	local Alpha = Kit.CurrentAlpha()
	if Kit.Alpha == Alpha then
		return
	end

	Kit.Alpha = Alpha

	for Object, Entry in Kit.Tracked do
		if Object.Parent then
			Object[Entry.Property] = 1 - (1 - Entry.Base) * Alpha
		end
	end
end

function Kit.Depth(Parent, Strength, Radius, Limit)
	local Library = Kit.Library

	local Container = Kit.New("Frame", {
		Name = "Shadow",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = 0,
		Parent = Parent,
	})

	local Layers = {}
	for Index = ShadowLayerCount, 1, -1 do
		local Corner = Kit.New("UICorner", {})
		local Frame = Kit.New("Frame", {
			Name = "Layer" .. Index,
			BackgroundColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			Active = false,
			Parent = Container,
		}, { Corner })
		Layers[Index] = { Frame = Frame, Corner = Corner }
	end

	local Entry = {
		Image = Container,
		Layers = Layers,
		Radius = Radius or 12,
		Strength = Strength or 1,
		Empty = false,
		VerticalLimit = Limit,
	}

	Library.Shadows[Container] = Entry
	table.insert(Kit.Shadows, Container)
	Library:SetPanelDepth(Library.PanelDepth)

	return Entry
end

function Kit.Release()
	local Library = Kit.Library

	for _, Container in Kit.Shadows do
		Library.Shadows[Container] = nil
	end

	table.clear(Kit.Shadows)
	table.clear(Kit.Tracked)
end

function Kit.Label(Properties)
	local Final = {
		BackgroundTransparency = 1,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		FontFace = Kit.Library:FontFor(Properties.Weight or "Medium"),
		ThemeTag = { TextColor3 = Properties.Tag or "Text" },
	}

	for Key, Value in Properties do
		if Key ~= "Weight" and Key ~= "Tag" then
			Final[Key] = Value
		end
	end

	return Kit.New("TextLabel", Final)
end

function Kit.Surface(Config)
	local Radius = Config.Radius or 10
	local AutoY = Config.AutoY == true

	local Shell = Kit.New("Frame", {
		Name = Config.Name or "Surface",
		BackgroundTransparency = 1,
		Size = Config.Size or UDim2.new(),
		Position = Config.Position or UDim2.new(),
		AnchorPoint = Config.AnchorPoint or Vector2.zero,
		LayoutOrder = Config.LayoutOrder or 0,
		ZIndex = Config.ZIndex or 1,
		Visible = Config.Visible ~= false,
		Parent = Config.Parent,
	})

	if Config.Strength and Config.Strength > 0 then
		Kit.Depth(Shell, Config.Strength, Radius, Config.Limit)
	end

	local Stroke = Kit.New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = 1,
		ThemeTag = { Color = Config.Border or "AcrylicBorder" },
	})
	Kit.Track(Stroke, "Transparency", Config.BorderBase or 0.35)

	local Fill = Kit.New("Frame", {
		Name = "Fill",
		Size = if AutoY then UDim2.new(1, 0, 0, 0) else UDim2.fromScale(1, 1),
		AutomaticSize = if AutoY then Enum.AutomaticSize.Y else Enum.AutomaticSize.None,
		Active = Config.Active ~= false,
		ThemeTag = { BackgroundColor3 = Config.Background or "AcrylicMain" },
		Parent = Shell,
	}, {
		Kit.Corner(Radius),
		Stroke,
	})
	Kit.Track(Fill, "BackgroundTransparency", Config.Base or 0)

	if AutoY then
		local function Sync()
			local Height = Fill.AbsoluteSize.Y
			if Shell.Size.Y.Offset ~= Height then
				Shell.Size = UDim2.new(Shell.Size.X.Scale, Shell.Size.X.Offset, 0, Height)
			end
		end

		Fill:GetPropertyChangedSignal("AbsoluteSize"):Connect(Sync)
		Shell:GetPropertyChangedSignal("Visible"):Connect(Sync)
		task.defer(Sync)
	end

	return Shell, Fill
end

function Kit.Divider(Parent, Order, Inset)
	local Holder = Kit.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 7),
		LayoutOrder = Order,
		Parent = Parent,
	})

	local Line = Kit.New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -(Inset or 0) * 2, 0, 1),
		BorderSizePixel = 0,
		ThemeTag = { BackgroundColor3 = "ElementBorder" },
		Parent = Holder,
	})
	Kit.Track(Line, "BackgroundTransparency", 0.88)

	return Holder
end

function Kit.Separator(Parent, Order)
	local Line = Kit.New("Frame", {
		Size = UDim2.fromOffset(1, 16),
		BorderSizePixel = 0,
		LayoutOrder = Order,
		ThemeTag = { BackgroundColor3 = "ElementBorder" },
		Parent = Parent,
	})
	Kit.Track(Line, "BackgroundTransparency", 0.85)

	return Line
end

function Kit.Icon(Config)
	local Size = Config.Size or 16
	local Tag = Config.Tag or "Text"

	local Root = Kit.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(Size, Size),
		LayoutOrder = Config.LayoutOrder or 0,
		Parent = Config.Parent,
	})

	local Image = Kit.New("ImageLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ThemeTag = { ImageColor3 = Tag },
		Parent = Root,
	})

	local Glyph = Kit.Label({
		Size = UDim2.fromScale(1, 1),
		TextSize = math.max(Size - 4, 8),
		TextXAlignment = Enum.TextXAlignment.Center,
		Weight = "Bold",
		Tag = Tag,
		Visible = false,
		Parent = Root,
	})

	local Object = setmetatable({ Root = Root, Image = Image, Glyph = Glyph }, IconObject)
	Object:Set(Config.Name, Config.Fallback)
	return Object
end

function IconObject:Set(Name, Fallback)
	local Applied = false

	if Name then
		local Success, Result = pcall(Kit.Library.ApplyIcon, Kit.Library, self.Image, Name, nil, nil, "Element")
		Applied = Success and Result == true
	end

	self.Image.Visible = Applied
	self.Glyph.Visible = not Applied and Fallback ~= nil
	self.Glyph.Text = Fallback or ""
end

function IconObject:SetTag(Tag)
	Kit.Retag(self.Image, { ImageColor3 = Tag })
	Kit.Retag(self.Glyph, { TextColor3 = Tag })
end

function Kit.Button(Config)
	local Style = ButtonStyles[Config.Variant or "Subtle"] or ButtonStyles.Subtle
	local Radius = Config.Radius or 8
	local Aligned = Config.Align == "Left"

	local Root = Kit.New("Frame", {
		Name = "Button",
		BackgroundTransparency = 1,
		Size = Config.Size or UDim2.fromOffset(34, 34),
		Position = Config.Position or UDim2.new(),
		AnchorPoint = Config.AnchorPoint or Vector2.zero,
		LayoutOrder = Config.LayoutOrder or 0,
		Parent = Config.Parent,
	})

	if Config.Strength then
		Kit.Depth(Root, Config.Strength, Radius, 4)
	end

	local Stroke = Kit.New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = 1,
		Enabled = Style.Stroke == true,
		ThemeTag = { Color = "ElementBorder" },
	})
	Kit.Track(Stroke, "Transparency", 0.9)

	local Hit = Kit.New("TextButton", {
		Name = "Hit",
		Text = "",
		AutoButtonColor = false,
		ClipsDescendants = Config.Clip == true,
		Size = UDim2.fromScale(1, 1),
		ThemeTag = { BackgroundColor3 = Style.Background },
		Parent = Root,
	}, {
		Kit.Corner(Radius),
		Stroke,
	})
	Kit.Track(Hit, "BackgroundTransparency", Style.Base)

	local Content = Kit.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = Hit,
	}, {
		Kit.New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = if Aligned then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, Config.Gap or 8),
		}),
		Kit.New("UIPadding", {
			PaddingLeft = UDim.new(0, if Aligned then (Config.Inset or 10) else 0),
		}),
	})

	local Icon = nil
	if Config.Icon or Config.Fallback then
		Icon = Kit.Icon({
			Parent = Content,
			Name = Config.Icon,
			Fallback = Config.Fallback,
			Size = Config.IconSize or 16,
			Tag = Style.Text,
			LayoutOrder = 1,
		})
	end

	local Label = nil
	if Config.Text then
		Label = Kit.Label({
			Parent = Content,
			Text = Config.Text,
			Size = UDim2.fromOffset(0, 16),
			AutomaticSize = Enum.AutomaticSize.X,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextSize = Config.TextSize or 12,
			Weight = "SemiBold",
			Tag = Style.Text,
			LayoutOrder = 2,
		})
	end

	local Object = setmetatable({
		Root = Root,
		Hit = Hit,
		Stroke = Stroke,
		Label = Label,
		Icon = Icon,
		Style = Style,
		Enabled = true,
		Fade = 0,
		Reveal = if Config.Concealed then 0 else 1,
	}, ButtonObject)

	Object:Dim()

	Hit.MouseEnter:Connect(function()
		if Object.Enabled then
			Object:Paint(Object:HoverBase())
		end
	end)

	Hit.MouseLeave:Connect(function()
		Object:Paint(Object.Style.Base)
	end)

	Hit.MouseButton1Down:Connect(function()
		if Object.Enabled then
			Object:Paint(Object:PressBase())
		end
	end)

	Hit.MouseButton1Up:Connect(function()
		if Object.Enabled then
			Object:Paint(Object:HoverBase())
		end
	end)

	return Object
end

function ButtonObject:HoverBase()
	local Style = self.Style

	if Style.HoverBase then
		return Style.HoverBase
	end

	if Style.Base >= 0.99 then
		return Kit.Creator.GetThemeProperty("HoverTransparency") or 0.945
	end

	return math.max(Style.Base - 0.05, 0)
end

function ButtonObject:PressBase()
	local Style = self.Style

	if Style.PressBase then
		return Style.PressBase
	end

	if Style.Base >= 0.99 then
		return Kit.Creator.GetThemeProperty("PressedTransparency") or 0.906
	end

	return math.max(Style.Base - 0.1, 0)
end

function ButtonObject:Paint(Base)
	Kit.Creator.Tween(self.Hit, 0.12, { BackgroundTransparency = Kit.Rebase(self.Hit, Base) })
end

function ButtonObject:OnActivated(Callback)
	return self.Hit.Activated:Connect(function()
		if self.Enabled then
			Callback()
		end
	end)
end

function ButtonObject:SetVariant(Name)
	local Style = ButtonStyles[Name] or ButtonStyles.Subtle
	self.Style = Style

	Kit.Retag(self.Hit, { BackgroundColor3 = Style.Background })
	self.Hit.BackgroundTransparency = Kit.Rebase(self.Hit, Style.Base)
	self.Stroke.Enabled = Style.Stroke == true

	if self.Label then
		Kit.Retag(self.Label, { TextColor3 = Style.Text })
	end

	if self.Icon then
		self.Icon:SetTag(Style.Text)
	end
end

function ButtonObject:SetText(Text)
	if self.Label then
		self.Label.Text = Text
	end
end

function ButtonObject:SetIcon(Name, Fallback)
	if self.Icon then
		self.Icon:Set(Name, Fallback)
	end
end

function ButtonObject:Dim()
	if self.Label then
		self.Label.TextTransparency = 1 - (1 - self.Fade) * self.Reveal
	end
end

function ButtonObject:SetReveal(Alpha)
	if self.Reveal == Alpha then
		return
	end

	self.Reveal = Alpha
	self:Dim()
end

function ButtonObject:SetEnabled(Enabled)
	self.Enabled = Enabled
	self.Fade = if Enabled then 0 else 0.6
	self:Dim()

	if self.Icon then
		self.Icon.Image.ImageTransparency = self.Fade
		self.Icon.Glyph.TextTransparency = self.Fade
	end
end

function Kit.MakeDraggable(Handle, Target, Config)
	Config = Config or {}

	local State = { Input = nil, Origin = Vector3.zero, Start = UDim2.new(), Moved = false, Active = false }
	local Links = {}

	local function Mark(Value)
		if Config.Track then
			Config.Track.Moving = Value
		end
	end

	table.insert(
		Links,
		Handle.InputBegan:Connect(function(Input)
			if not Util.IsPointer(Input) then
				return
			end

			State.Input = Input
			State.Origin = Input.Position
			State.Start = Target.Position
			State.Moved = false
			State.Active = not (Config.IsLocked and Config.IsLocked())
			Mark(false)
		end)
	)

	table.insert(
		Links,
		UserInputService.InputChanged:Connect(function(Input)
			if not State.Input then
				return
			end

			local Tracking = if State.Input.UserInputType == Enum.UserInputType.Touch
				then Input == State.Input
				else Input.UserInputType == Enum.UserInputType.MouseMovement

			if not Tracking then
				return
			end

			local Delta = Input.Position - State.Origin
			if not State.Moved then
				if Vector2.new(Delta.X, Delta.Y).Magnitude < Constants.TapThreshold then
					return
				end

				State.Moved = true
				State.Start = Target.Position
				Mark(true)
			end

			if State.Active then
				Target.Position = UDim2.new(
					State.Start.X.Scale,
					State.Start.X.Offset + Delta.X,
					State.Start.Y.Scale,
					State.Start.Y.Offset + Delta.Y
				)
			end
		end)
	)

	table.insert(
		Links,
		UserInputService.InputEnded:Connect(function(Input)
			if not State.Input then
				return
			end

			local MouseRelease = State.Input.UserInputType == Enum.UserInputType.MouseButton1
				and Input.UserInputType == Enum.UserInputType.MouseButton1

			if Input ~= State.Input and not MouseRelease then
				return
			end

			local Moved = State.Moved
			State.Input = nil
			Mark(false)

			if Config.OnEnd then
				Config.OnEnd(Moved)
			end
		end)
	)

	return function()
		for _, Link in Links do
			Link:Disconnect()
		end
	end
end

function Kit.Contain(Shell, Viewport)
	local Size = Shell.AbsoluteSize
	if Size.X <= 0 or Size.Y <= 0 then
		return
	end

	local Margin = Constants.ViewportMargin
	local Position = Shell.AbsolutePosition
	local MaxX = math.max(Margin, Viewport.X - Size.X - Margin)
	local MaxY = math.max(Margin, Viewport.Y - Size.Y - Margin)
	local DeltaX = math.round(math.clamp(Position.X, Margin, MaxX) - Position.X)
	local DeltaY = math.round(math.clamp(Position.Y, Margin, MaxY) - Position.Y)

	if DeltaX == 0 and DeltaY == 0 then
		return
	end

	local Current = Shell.Position
	Shell.Position = UDim2.new(
		Current.X.Scale,
		Current.X.Offset + DeltaX,
		Current.Y.Scale,
		Current.Y.Offset + DeltaY
	)
end

function Kit.Host(Parent, Title, Order, Scroll)
	local Components = Kit.Library.Internals.Components

	local Holder = Components.Section(Title, Parent, {
		LayoutOrder = Order,
		InModal = true,
	})

	local Host = {
		Type = "Tab",
		Name = "HUDManager",
		Container = Holder.Container,
		Library = Kit.Library,
	}

	function Host:GetHolder()
		return Holder
	end

	function Host:NextOrder()
		return Holder:NextOrder()
	end

	return Components.SectionApi(Holder, Host, Scroll), Holder
end

local Overlay = {}
Overlay.__index = Overlay

function Overlay.Configure(Layer)
	Layer.IgnoreGuiInset = true
	Layer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	return Layer
end

function Overlay.new(Core)
	local Library = Core.Library

	pcall(Library.RemoveLayer, Library, Constants.OverlayLayer)
	pcall(Library.RemoveLayer, Library, Constants.ShieldLayer)

	local Self = setmetatable({
		Core = Core,
		Releases = {},
		ClusterBoxes = {},
		Controls = {},
		Hosts = {},
		OptionIds = {},
		DockButtons = {},
		DockProgress = 0,
		DockHold = 0,
		DockHover = false,
		DockPress = nil,
		DockLeft = false,
		DockTrack = { Moving = false },
	}, Overlay)

	Self.ShieldLayer = Overlay.Configure(Library:CreateLayer(Constants.ShieldLayer, Constants.ShieldOrder))
	Self.Layer = Overlay.Configure(Library:CreateLayer(Constants.OverlayLayer, Constants.OverlayOrder))

	Self:BuildShield()
	Self:BuildSelection()
	Self:BuildLauncher()
	Self:BuildDock()
	Self:BuildActionBar()
	Self:BuildAdvanced()
	Self.Panels = { Self.Launcher, Self.Dock, Self.ActionBar, Self.Advanced }
	Self:SetResizeStep(Core.Settings.ResizeStep)
	Self:SetSelection(nil)
	Self:WatchDock()

	table.insert(
		Self.Releases,
		Util.WatchViewport(function()
			Self:OnViewport()
		end)
	)

	return Self
end

function Overlay:BuildShield()
	self.Shield = Kit.New("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Active = false,
		Visible = false,
		Parent = self.ShieldLayer,
	})

	self.Shield.InputBegan:Connect(function(Input)
		self.Core:OnShieldPressed(Input)
	end)
end

function Overlay:CreateBox(Primary)
	local Stroke = Kit.New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = if Primary then 2 else 1,
		Transparency = if Primary then 0.05 else 0.55,
		ThemeTag = { Color = if Primary then "Accent" else "SubText" },
	})

	local Box = Kit.New("Frame", {
		BackgroundTransparency = if Primary then 0.9 else 1,
		Active = false,
		Visible = false,
		ZIndex = 1,
		ThemeTag = { BackgroundColor3 = "Accent" },
		Parent = self.Layer,
	}, {
		Kit.Corner(4),
		Stroke,
	})

	if Primary then
		self.TagText = ""
		self.TagFlipped = false
		self.Tag = Kit.New("TextLabel", {
			Name = "Tag",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 0, -5),
			Size = UDim2.fromOffset(0, 18),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Text = "",
			TextSize = 10,
			FontFace = MonoFace,
			ThemeTag = { BackgroundColor3 = "FillButton", TextColor3 = "FillButtonText" },
			Parent = Box,
		}, {
			Kit.Corner(5),
			Kit.New("UIPadding", {
				PaddingLeft = UDim.new(0, 7),
				PaddingRight = UDim.new(0, 7),
			}),
		})
	end

	return Box
end

function Overlay:BuildSelection()
	self.PrimaryBox = self:CreateBox(true)
end

function Overlay:PlaceTag(Position, Size)
	local Text = string.format("%d x %d", math.round(Size.X), math.round(Size.Y))
	if self.TagText ~= Text then
		self.TagText = Text
		self.Tag.Text = Text
	end

	local Flipped = Position.Y < 30
	if self.TagFlipped ~= Flipped then
		self.TagFlipped = Flipped
		self.Tag.AnchorPoint = if Flipped then Vector2.zero else Vector2.new(0, 1)
		self.Tag.Position = if Flipped then UDim2.new(0, 0, 1, 5) else UDim2.new(0, 0, 0, -5)
	end
end

function Overlay:PlaceBox(Box, Object)
	local Position = Geometry.ScreenPosition(Object)
	local Size = Object.AbsoluteSize

	Box.Position = UDim2.fromOffset(Position.X, Position.Y)
	Box.Size = UDim2.fromOffset(Size.X, Size.Y)
	Box.Visible = true

	if Box == self.PrimaryBox then
		self:PlaceTag(Position, Size)
	end
end

function Overlay:FitAdvanced(Viewport)
	if not self.Advanced.Visible then
		return
	end

	local Limit = math.max(120, Viewport.Y - 110)
	local Height = math.ceil(math.min(self.PagesBody.AbsoluteSize.Y, Limit))

	if Height > 0 and self.Scroll.Size.Y.Offset ~= Height then
		self.Scroll.Size = UDim2.new(1, 0, 0, Height)
	end
end

function Overlay:Contain()
	local Viewport = Util.GetViewport()
	self:FitAdvanced(Viewport)

	for _, Shell in self.Panels do
		if Shell.Visible then
			Kit.Contain(Shell, Viewport)
		end
	end
end

function Overlay:Reflect(Session)
	self:Contain()

	local Primary = Session.Selected
	local Show = Session.EditMode and Primary ~= nil and Primary.Parent ~= nil and Primary.Visible

	if not Show then
		self.PrimaryBox.Visible = false
		for _, Box in self.ClusterBoxes do
			Box.Visible = false
		end
		return
	end

	self:PlaceBox(self.PrimaryBox, Primary)
	self:Readout(Primary)

	local Used = 0
	for _, Member in Session.Cluster do
		if Member ~= Primary and Member.Parent and Member.Visible then
			Used += 1
			local Box = self.ClusterBoxes[Used]
			if not Box then
				Box = self:CreateBox(false)
				self.ClusterBoxes[Used] = Box
			end
			self:PlaceBox(Box, Member)
		end
	end

	for Index = Used + 1, #self.ClusterBoxes do
		self.ClusterBoxes[Index].Visible = false
	end
end

function Overlay:BuildLauncher()
	local Core = self.Core

	local Shell, Fill = Kit.Surface({
		Name = "Launcher",
		Parent = self.Layer,
		Size = UDim2.fromOffset(36, 36),
		Position = UDim2.new(1, -52, 0.5, -18),
		Radius = 8,
		Strength = 1,
		ZIndex = 10,
		Visible = Core.Settings.ShowLauncher,
	})
	self.Launcher = Shell

	local Icon = Kit.Icon({
		Parent = Fill,
		Name = Constants.Icons.Launcher,
		Fallback = Constants.Glyphs.Launcher,
		Size = 16,
	})
	Icon.Root.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.Root.Position = UDim2.fromScale(0.5, 0.5)

	table.insert(
		self.Releases,
		Kit.MakeDraggable(Fill, Shell, {
			OnEnd = function(Moved)
				if not Moved then
					self:ToggleDock()
				end
			end,
		})
	)
end

function Overlay:BuildDock()
	local Core = self.Core

	local Shell, Fill = Kit.Surface({
		Name = "Dock",
		Parent = self.Layer,
		Size = UDim2.fromOffset(Constants.DockCollapsed, 0),
		Position = UDim2.new(0, 12, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		AutoY = true,
		Radius = 8,
		Strength = 1,
		ZIndex = 12,
		Visible = false,
	})
	self.Dock = Shell

	Kit.New("UIPadding", {
		PaddingTop = UDim.new(0, 2),
		PaddingBottom = UDim.new(0, 6),
		PaddingLeft = UDim.new(0, 6),
		PaddingRight = UDim.new(0, 6),
		Parent = Fill,
	})

	Kit.New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = UDim.new(0, 3),
		Parent = Fill,
	})

	local Grip = Kit.New("Frame", {
		Name = "Grip",
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = 1,
		Parent = Fill,
	})

	local GripIcon = Kit.Icon({
		Parent = Grip,
		Name = Constants.Icons.Grip,
		Fallback = Constants.Glyphs.Grip,
		Size = 14,
		Tag = "SubText",
	})
	GripIcon.Root.AnchorPoint = Vector2.new(0, 0.5)
	GripIcon.Root.Position = UDim2.new(0, 9, 0.5, 0)

	self.GripLabel = Kit.Label({
		Parent = Grip,
		Text = "HUD Manager",
		Position = UDim2.fromOffset(32, 0),
		Size = UDim2.new(1, -32, 1, 0),
		TextSize = 11,
		TextTransparency = 1,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Tag = "SubText",
		Weight = "SemiBold",
	})

	table.insert(self.Releases, Kit.MakeDraggable(Grip, Shell, { Track = self.DockTrack }))

	local function AddItem(Order, Icon, Fallback, Text)
		local Button = Kit.Button({
			Parent = Fill,
			Icon = Icon,
			Fallback = Fallback,
			Text = Text,
			Variant = "Menu",
			Align = "Left",
			Inset = 8,
			Clip = true,
			Concealed = true,
			Size = UDim2.new(1, 0, 0, 32),
			LayoutOrder = Order,
		})

		table.insert(self.DockButtons, Button)
		return Button
	end

	self.EditButton = AddItem(2, Constants.Icons.Edit, Constants.Glyphs.Edit, "Edit")
	self.EditButton:OnActivated(function()
		Core:SetEditMode(not Core.Session.EditMode)
	end)

	Kit.Divider(Fill, 3, 4)

	self.UndoButton = AddItem(4, Constants.Icons.Undo, Constants.Glyphs.Undo, "Undo")
	self.UndoButton:OnActivated(function()
		Core:Undo()
	end)

	self.RedoButton = AddItem(5, Constants.Icons.Redo, Constants.Glyphs.Redo, "Redo")
	self.RedoButton:OnActivated(function()
		Core:Redo()
	end)

	Kit.Divider(Fill, 6, 4)

	AddItem(7, Constants.Icons.Save, Constants.Glyphs.Save, "Save"):OnActivated(function()
		Core:QuickSave()
	end)

	self.AdvancedButton = AddItem(8, Constants.Icons.Advanced, Constants.Glyphs.Advanced, "Advanced")
	self.AdvancedButton:OnActivated(function()
		self:ToggleAdvanced()
	end)

	AddItem(9, Constants.Icons.Settings, Constants.Glyphs.Settings, "Settings"):OnActivated(function()
		Core:OpenSettings()
	end)

	self:SetHistoryState(false, false)
end

function Overlay:BuildActionBar()
	local Core = self.Core

	local Shell, Fill = Kit.Surface({
		Name = "ActionBar",
		Parent = self.Layer,
		Size = UDim2.fromOffset(292, 0),
		Position = UDim2.new(0.5, 0, 0, 12),
		AnchorPoint = Vector2.new(0.5, 0),
		AutoY = true,
		Radius = 8,
		Strength = 1,
		ZIndex = 11,
		Visible = false,
	})
	self.ActionBar = Shell

	Kit.New("UIPadding", {
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 6),
		PaddingLeft = UDim.new(0, 6),
		PaddingRight = UDim.new(0, 6),
		Parent = Fill,
	})

	Kit.New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 2),
		Parent = Fill,
	})

	local Header = Kit.New("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Parent = Fill,
	})

	self.SelectionName = Kit.Label({
		Parent = Header,
		Text = "Tap an element to select",
		Position = UDim2.fromOffset(6, 0),
		Size = UDim2.new(1, -96, 1, 0),
		TextTruncate = Enum.TextTruncate.AtEnd,
		Tag = "TextSecondary",
		Weight = "SemiBold",
	})

	self.SelectionSize = Kit.Label({
		Parent = Header,
		Text = "",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -6, 0, 0),
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		TextXAlignment = Enum.TextXAlignment.Right,
		TextSize = 11,
		FontFace = MonoFace,
		Tag = "TextSecondary",
		Weight = "Regular",
	})

	table.insert(
		self.Releases,
		Kit.MakeDraggable(Header, Shell, {
			IsLocked = function()
				return Core.Session.BarLocked
			end,
		})
	)

	local Row = Kit.New("Frame", {
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Parent = Fill,
	}, {
		Kit.New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4),
		}),
	})

	local function AddAction(Order, Icon, Fallback, Variant, Dependent)
		local Button = Kit.Button({
			Parent = Row,
			Icon = Icon,
			Fallback = Fallback,
			Variant = Variant,
			Size = UDim2.fromOffset(38, 30),
			LayoutOrder = Order,
		})

		if Dependent then
			table.insert(self.Controls, Button)
		end

		return Button
	end

	self.LockButton = AddAction(1, Constants.Icons.Unlock, Constants.Glyphs.Unlock, "Menu", false)
	self.LockButton:OnActivated(function()
		Core:SetBarLocked(not Core.Session.BarLocked)
	end)

	Kit.Separator(Row, 2)

	self:Hold(AddAction(3, Constants.Icons.Minus, Constants.Glyphs.Minus, "Menu", true), function()
		Core:Resize(-Core.Settings.ResizeStep)
	end)

	self.StepLabel = Kit.Label({
		Parent = Row,
		Text = "",
		Size = UDim2.fromOffset(38, 30),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextSize = 11,
		FontFace = MonoFace,
		Tag = "TextSecondary",
		Weight = "Regular",
		LayoutOrder = 4,
	})

	self:Hold(AddAction(5, Constants.Icons.Plus, Constants.Glyphs.Plus, "Menu", true), function()
		Core:Resize(Core.Settings.ResizeStep)
	end)

	Kit.Separator(Row, 6)

	AddAction(7, Constants.Icons.Reset, Constants.Glyphs.Reset, "Menu", true):OnActivated(function()
		Core:ResetSelected()
	end)

	AddAction(8, Constants.Icons.Delete, Constants.Glyphs.Delete, "MenuDanger", true):OnActivated(function()
		Core:DeleteSelected()
	end)
end

function Overlay:ToggleDock()
	self.Dock.Visible = not self.Dock.Visible

	if not self.Dock.Visible then
		self.Core:SetEditMode(false)
	end
end

function Overlay:WatchDock()
	local function Extend()
		self.DockHold = math.max(self.DockHold, os.clock() + Constants.DockHold)
	end

	self:Listen(UserInputService.InputBegan, function(Input)
		if not Util.IsPointer(Input) or not self.Dock.Visible then
			return
		end

		if Geometry.ContainsInput(self.Dock, Input.Position) then
			self.DockPress = Input
			Extend()
		end
	end)

	self:Listen(UserInputService.InputEnded, function(Input)
		local Press = self.DockPress
		if not Press then
			return
		end

		local Same = Input == Press
			or (
				Press.UserInputType == Enum.UserInputType.MouseButton1
				and Input.UserInputType == Enum.UserInputType.MouseButton1
			)

		if Same then
			self.DockPress = nil
			Extend()
		end
	end)
end

function Overlay:IsDockActive()
	local Dock = self.Dock

	if not Dock.Visible then
		self.DockPress = nil
		self.DockHover = false
		return false
	end

	local Now = os.clock()
	local Hovering = UserInputService.MouseEnabled and Util.PointInGui(UserInputService:GetMouseLocation(), Dock)

	if self.DockHover and not Hovering then
		self.DockHold = math.max(self.DockHold, Now + Constants.DockLeave)
	end

	self.DockHover = Hovering

	return Hovering or self.DockPress ~= nil or Now < self.DockHold
end

function Overlay:ApplyDock(Progress)
	local Dock = self.Dock
	local Before = Dock.Size.X.Offset
	local Span = Constants.DockExpanded - Constants.DockCollapsed
	local Width = math.round(Constants.DockCollapsed + Span * Progress)

	if Before <= Constants.DockCollapsed then
		local Center = Dock.AbsolutePosition.X + Dock.AbsoluteSize.X / 2
		self.DockLeft = Center > Util.GetViewport().X / 2
	end

	self.DockProgress = Progress

	local Size = Dock.Size
	Dock.Size = UDim2.new(0, Width, Size.Y.Scale, Size.Y.Offset)

	if self.DockLeft and Width ~= Before and not self.DockTrack.Moving then
		local Position = Dock.Position
		Dock.Position = UDim2.new(Position.X.Scale, Position.X.Offset - (Width - Before), Position.Y.Scale, Position.Y.Offset)
	end

	local Alpha = math.clamp((Progress - 0.3) / 0.7, 0, 1)

	for _, Button in self.DockButtons do
		Button:SetReveal(Alpha)
	end

	self.GripLabel.TextTransparency = 1 - Alpha
end

function Overlay:StepDock(Delta)
	local Target = if self:IsDockActive() then 1 else 0
	local Progress = self.DockProgress

	if Progress == Target then
		return
	end

	local Config = self.Core.Library.Config
	local Speed = if type(Config.AnimationSpeed) == "number" then Config.AnimationSpeed else 1

	if Config.ReducedMotion or not self.Dock.Visible then
		Progress = Target
	else
		Progress += (Target - Progress) * (1 - math.exp(-Constants.DockSpeed * Speed * (Delta or 0.016)))

		if math.abs(Target - Progress) < 0.01 then
			Progress = Target
		end
	end

	self:ApplyDock(Progress)
end

function Overlay:OnViewport()
	self:Contain()

	local Map = self.Map
	if Map and Map.Ratio then
		local Viewport = Util.GetViewport()
		Map.Ratio.AspectRatio = Viewport.X / math.max(Viewport.Y, 1)
	end
end

function Overlay:SetLauncherVisible(Visible)
	self.Launcher.Visible = Visible

	if not Visible then
		self.Dock.Visible = false
	end
end

function Overlay:SetEditState(Enabled)
	self.Shield.Visible = Enabled
	self.Shield.Active = Enabled
	self.ActionBar.Visible = Enabled
	self.EditButton:SetVariant(if Enabled then "Active" else "Menu")

	if not Enabled then
		self:SetSelection(nil)
	end
end

function Overlay:SetBarLocked(Locked)
	self.LockButton:SetVariant(if Locked then "Active" else "Menu")
	self.LockButton:SetIcon(
		if Locked then Constants.Icons.Lock else Constants.Icons.Unlock,
		if Locked then Constants.Glyphs.Lock else Constants.Glyphs.Unlock
	)

	local Option = self.Core.Library.Options.HudDockBarLocked
	if Option and Option.Value ~= Locked then
		pcall(Option.SetValue, Option, Locked)
	end
end

function Overlay:SetHistoryState(CanUndo, CanRedo)
	self.UndoButton:SetEnabled(CanUndo)
	self.RedoButton:SetEnabled(CanRedo)
end

function Overlay:FormatSize(Object)
	local Size = Object.AbsoluteSize
	return string.format("%d x %d", math.round(Size.X), math.round(Size.Y))
end

function Overlay:SetResizeStep(Value)
	self.StepLabel.Text = tostring(Value) .. "px"
end

function Overlay:Readout(Object)
	local Size = self:FormatSize(Object)
	if self.ReadoutText == Size then
		return
	end

	self.ReadoutText = Size
	self.SelectionSize.Text = Size
	self.AdvancedSelection.Text = Object.Name .. "  " .. Size
end

function Overlay:SetSelection(Object)
	local Valid = Object ~= nil and Object.Parent ~= nil

	if Valid then
		local Size = self:FormatSize(Object)
		self.ReadoutText = Size
		self.SelectionName.Text = if self.Core:IsElementLocked(Object) then Object.Name .. " (locked)" else Object.Name
		self.SelectionSize.Text = Size
		self.AdvancedSelection.Text = Object.Name .. "  " .. Size
		Kit.Retag(self.SelectionName, { TextColor3 = "Text" })
	else
		self.ReadoutText = nil
		self.SelectionName.Text = "Tap an element to select"
		self.SelectionSize.Text = ""
		self.AdvancedSelection.Text = "None"
		Kit.Retag(self.SelectionName, { TextColor3 = "TextSecondary" })
	end

	for _, Control in self.Controls do
		Control:SetEnabled(Valid)
	end
end

function Overlay:Destroy()
	for _, Release in self.Releases do
		Release()
	end
	table.clear(self.Releases)

	for _, Holder in self.Hosts do
		pcall(Holder.Destroy, Holder)
	end
	table.clear(self.Hosts)

	local Library = self.Core.Library

	for _, Idx in self.OptionIds do
		Library.Options[Idx] = nil
	end
	table.clear(self.OptionIds)

	Kit.Release()

	pcall(Library.RemoveLayer, Library, Constants.OverlayLayer)
	pcall(Library.RemoveLayer, Library, Constants.ShieldLayer)
end

local Scanner = {}

function Scanner.Track(Core, Object)
	if not Object:IsA("GuiObject") then
		return
	end

	local Book = Core.Book
	if next(Book.Rules) == nil or Core:IsOwned(Object) then
		return
	end

	local Key = KeyResolver.Resolve(Object)
	if Book.Rules[Key] then
		Book:Capture(Object, Key)
		Book.Tracked[Object] = Key
	end
end

function Scanner.Rescan(Core)
	Core.ScanToken += 1
	local Token = Core.ScanToken

	task.spawn(function()
		local Success, Descendants = pcall(function()
			return PlayerGui:GetDescendants()
		end)

		if not Success then
			return
		end

		for Index, Object in Descendants do
			if Token ~= Core.ScanToken or not Core.Started then
				return
			end

			Scanner.Track(Core, Object)

			if Index % Constants.ScanBatch == 0 then
				task.wait()
			end
		end
	end)
end

local Enforcer = {}

function Enforcer.Step(Core, Delta)
	local Session = Core.Session
	Kit.Refresh()
	Core.Overlay:Reflect(Session)
	Core.Overlay:Tick(Delta)

	local Book = Core.Book
	if next(Book.Rules) == nil then
		return
	end

	for Object, Key in Book.Tracked do
		if not Object.Parent or not Book.Rules[Key] then
			Book.Tracked[Object] = nil
		else
			if not Book.Rules[Key].IsDeleted then
				LayoutBaker.Bake(Book, Object.Parent)
			end

			local Result = Book:Apply(Object, Key, Session.DragSet[Object] == true, Core:IsYielding(Object))

			if Result == "Adopt" then
				Core:AdoptPosition(Object, Key)
			end
		end
	end
end

local ProfileStore = {}

function ProfileStore.GameFolder(Core)
	return Core.Folder .. "/Profiles/" .. Core.GameId
end

function ProfileStore.Path(Core, Name)
	return ProfileStore.GameFolder(Core) .. "/" .. Name .. ".json"
end

function ProfileStore.AutoloadPath(Core)
	return ProfileStore.GameFolder(Core) .. "/autoload.txt"
end

function ProfileStore.Pack(Rules)
	local Packed = {}

	for Key, Rule in Rules do
		Packed[Key] = {
			Name = Rule.Name,
			IsDeleted = Rule.IsDeleted,
			Position = Util.UDim2ToArray(Rule.Position),
			Size = Util.UDim2ToArray(Rule.Size),
			SizeModified = Rule.SizeModified,
		}
	end

	return Packed
end

function ProfileStore.Wrap(Core, Rules)
	return {
		Version = Constants.FormatVersion,
		GameId = Core.GameId,
		GameName = Core.GameName,
		SavedAt = os.time(),
		Rules = ProfileStore.Pack(Rules),
	}
end

function ProfileStore.Decode(Data)
	local Source = if type(Data.Rules) == "table" then Data.Rules else Data
	local Rules = {}
	local Count = 0

	for Key, Entry in Source do
		if type(Key) == "string" and type(Entry) == "table" then
			local Position = Util.ArrayToUDim2(Entry.Position)
			local Size = Util.ArrayToUDim2(Entry.Size)

			if Position and Size then
				Rules[Key] = {
					Name = tostring(Entry.Name or Key),
					IsDeleted = Entry.IsDeleted == true,
					Position = Position,
					Size = Size,
					SizeModified = Entry.SizeModified == true,
				}
				Count += 1
			end
		end
	end

	return Rules, Count
end

function ProfileStore.List(Core)
	local Names = {}

	if not Util.HasFileSystem() then
		return Names
	end

	local Folder = ProfileStore.GameFolder(Core)
	if not isfolder(Folder) then
		return Names
	end

	for _, File in listfiles(Folder) do
		local Name = string.match(File, "([^/\\]+)%.json$")
		if Name then
			table.insert(Names, Name)
		end
	end

	table.sort(Names)
	return Names
end

function ProfileStore.Save(Core, Name)
	Name = Util.SanitizeName(Name)

	if Name == "" then
		return false, "invalid profile name"
	end

	if not Util.HasFileSystem() then
		return false, "file system unavailable"
	end

	Core:BuildFolderTree()

	local Success, Problem = Util.WriteJson(ProfileStore.Path(Core, Name), ProfileStore.Wrap(Core, Core.Book.Rules))
	if not Success then
		return false, Problem
	end

	Core.ActiveProfile = Name
	return true
end

function ProfileStore.Load(Core, Name, Merge)
	if Util.IsBlank(Name) then
		return false, "no profile selected"
	end

	local Data = Util.ReadJson(ProfileStore.Path(Core, Name))
	if not Data then
		return false, "profile not found"
	end

	local Rules = ProfileStore.Decode(Data)
	Core:ReplaceRules(Rules, Merge, "Load " .. Name)
	Core.ActiveProfile = Name
	return true
end

function ProfileStore.Delete(Core, Name)
	local Path = ProfileStore.Path(Core, Name)

	if isfile(Path) then
		delfile(Path)
	end

	if ProfileStore.GetAutoload(Core) == Name then
		ProfileStore.SetAutoload(Core, nil)
	end

	if Core.ActiveProfile == Name then
		Core.ActiveProfile = nil
	end
end

function ProfileStore.GetAutoload(Core)
	local Path = ProfileStore.AutoloadPath(Core)

	if not Util.HasFileSystem() or not isfile(Path) then
		return nil
	end

	local Name = Util.Trim(readfile(Path))
	if Name ~= "" and isfile(ProfileStore.Path(Core, Name)) then
		return Name
	end

	return nil
end

function ProfileStore.SetAutoload(Core, Name)
	local Path = ProfileStore.AutoloadPath(Core)

	if Name == nil then
		if isfile(Path) then
			delfile(Path)
		end
		return true
	end

	Core:BuildFolderTree()
	return (pcall(writefile, Path, Name))
end

function ProfileStore.Export(Core, Name)
	local Path = ProfileStore.Path(Core, Name)

	if type(setclipboard) ~= "function" or not isfile(Path) then
		return false, "clipboard or profile unavailable"
	end

	setclipboard(readfile(Path))
	return true
end

function ProfileStore.ImportText(Core, Name, Text)
	Name = Util.SanitizeName(Name)

	if Name == "" then
		return false, "invalid profile name"
	end

	local Decoded, Data = pcall(function()
		return HttpService:JSONDecode(Text)
	end)

	if not Decoded or type(Data) ~= "table" then
		return false, "text is not valid JSON"
	end

	local Rules, Count = ProfileStore.Decode(Data)
	if Count == 0 then
		return false, "no valid rules found"
	end

	Core:BuildFolderTree()

	local Success, Problem = Util.WriteJson(ProfileStore.Path(Core, Name), ProfileStore.Wrap(Core, Rules))
	if not Success then
		return false, Problem
	end

	return true, Count
end

function ProfileStore.ImportLegacy(Core)
	if not Util.HasFileSystem() or not isfolder(Constants.LegacyFolder) then
		return 0
	end

	Core:BuildFolderTree()

	local Suffix = "_" .. Core.GameId .. ".json"
	local Imported = 0

	for _, File in listfiles(Constants.LegacyFolder) do
		local Normal = string.gsub(File, "\\", "/")
		local FileName = string.match(Normal, "([^/]+)$") or ""

		if string.sub(FileName, -#Suffix) == Suffix then
			local Name = Util.SanitizeName(string.sub(FileName, 1, #FileName - #Suffix))
			local Data = Util.ReadJson(File)

			if Name ~= "" and Data and not isfile(ProfileStore.Path(Core, Name)) then
				local Rules, Count = ProfileStore.Decode(Data)
				if Count > 0 and Util.WriteJson(ProfileStore.Path(Core, Name), ProfileStore.Wrap(Core, Rules)) then
					Imported += 1
				end
			end
		end
	end

	return Imported
end

function Kit.Group(Parent, Order, Items)
	local Stroke = Kit.New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = 1,
		ThemeTag = { Color = "ElementBorder" },
	})
	Kit.Track(Stroke, "Transparency", 0.9)

	local Root = Kit.New("Frame", {
		Name = "Group",
		Size = UDim2.fromOffset(0, 30),
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = Order,
		ThemeTag = { BackgroundColor3 = "DropdownFrame" },
		Parent = Parent,
	}, {
		Kit.Corner(8),
		Stroke,
		Kit.New("UIPadding", {
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 2),
			PaddingLeft = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 2),
		}),
		Kit.New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2),
		}),
	})
	Kit.Track(Root, "BackgroundTransparency", 0.93)

	local Buttons = {}

	for Index, Item in Items do
		Buttons[Index] = Kit.Button({
			Parent = Root,
			Icon = Item.Icon,
			Fallback = Item.Fallback,
			Text = Item.Text,
			Variant = Item.Variant or "Menu",
			Size = UDim2.fromOffset(Item.Width or 28, 26),
			Radius = 6,
			IconSize = 14,
			TextSize = 11,
			LayoutOrder = Index,
		})
	end

	return Root, Buttons
end

function Kit.Row(Parent, Order, Title)
	local Row = Kit.New("Frame", {
		Name = Title,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 36),
		LayoutOrder = Order,
		Parent = Parent,
	})

	Kit.Label({
		Parent = Row,
		Text = Title,
		Position = UDim2.fromOffset(8, 0),
		Size = UDim2.new(0.35, 0, 1, 0),
	})

	local Right = Kit.New("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -2, 0, 0),
		Size = UDim2.new(0.65, 0, 1, 0),
		Parent = Row,
	}, {
		Kit.New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
		}),
	})

	return Row, Right
end

function Kit.Segmented(Config)
	local Options = Config.Options
	local Count = #Options

	local Stroke = Kit.New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = 1,
		ThemeTag = { Color = "ElementBorder" },
	})
	Kit.Track(Stroke, "Transparency", 0.9)

	local Root = Kit.New("Frame", {
		Name = "Segmented",
		Size = Config.Size,
		LayoutOrder = Config.LayoutOrder or 0,
		ThemeTag = { BackgroundColor3 = "DropdownFrame" },
		Parent = Config.Parent,
	}, {
		Kit.Corner(8),
		Stroke,
		Kit.New("UIPadding", {
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 2),
			PaddingLeft = UDim.new(0, 2),
			PaddingRight = UDim.new(0, 2),
		}),
		Kit.New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2),
		}),
	})
	Kit.Track(Root, "BackgroundTransparency", 0.93)

	local Object = { Root = Root, Value = Config.Default, Buttons = {} }

	local function Paint()
		for Option, Button in Object.Buttons do
			Button:SetVariant(if Option == Object.Value then "Active" else "Menu")
		end
	end

	function Object:SetValue(Value, Silent)
		if not self.Buttons[Value] then
			return
		end

		self.Value = Value
		Paint()

		if not Silent and Config.Callback then
			Config.Callback(Value)
		end
	end

	for Index, Option in Options do
		local Button = Kit.Button({
			Parent = Root,
			Text = tostring(Option),
			Variant = "Menu",
			Radius = 6,
			TextSize = 11,
			Size = UDim2.new(1 / Count, -(2 * (Count - 1)) / Count, 1, 0),
			LayoutOrder = Index,
		})
		Button:OnActivated(function()
			Object:SetValue(Option)
		end)
		Object.Buttons[Option] = Button
	end

	Paint()
	return Object
end

function Overlay:Hold(Button, Action)
	local Token = 0

	Button.Hit.InputBegan:Connect(function(Input)
		if not Util.IsPointer(Input) or not Button.Enabled then
			return
		end

		Token += 1
		local Current = Token

		Action()

		local Release
		Release = UserInputService.InputEnded:Connect(function(Ended)
			local Same = Ended == Input
				or (Input.UserInputType == Enum.UserInputType.MouseButton1 and Ended.UserInputType == Enum.UserInputType.MouseButton1)

			if Same then
				if Token == Current then
					Token += 1
				end
				Release:Disconnect()
			end
		end)

		task.delay(Constants.RepeatDelay, function()
			while Token == Current and self.Core.Started and Button.Enabled do
				Action()
				task.wait(Constants.RepeatInterval)
			end
		end)
	end)
end

function Overlay:Listen(Signal, Handler)
	local Link = Signal:Connect(Handler)

	table.insert(self.Releases, function()
		Link:Disconnect()
	end)
end

function Overlay:NewPage(Parent, Name)
	return Kit.New("Frame", {
		Name = Name,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Visible = false,
		Parent = Parent,
	}, {
		Kit.New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2),
		}),
	})
end

function Overlay:BuildHost(Parent, Title, Order, Build)
	local Success, Problem = pcall(function()
		local Host, Holder = Kit.Host(Parent, Title, Order, self.Scroll)
		table.insert(self.Hosts, Holder)

		Kit.New("UIPadding", {
			PaddingBottom = UDim.new(0, 8),
			Parent = Holder.Root,
		})

		Build(Host)
	end)

	if not Success then
		warn("HUDManager - " .. tostring(Problem))
	end
end

function Overlay:AddOption(Host, Method, Idx, Key, Config)
	local Core = self.Core

	Config.Default = Core.Settings[Key]
	Config.Callback = function(Value)
		Core:SetSetting(Key, Value)
	end

	local Option = Host[Method](Host, Idx, Config)
	table.insert(self.OptionIds, Idx)
	Core:BindOption(Key, Idx)

	return Option
end

function Overlay:BuildAdvanced()
	local Core = self.Core

	local Shell, Fill = Kit.Surface({
		Name = "Advanced",
		Parent = self.Layer,
		Size = UDim2.fromOffset(340, 0),
		Position = UDim2.new(0, 68, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		AutoY = true,
		Radius = 8,
		Strength = 1,
		ZIndex = 10,
		Visible = false,
	})
	self.Advanced = Shell

	Kit.New("UIPadding", {
		PaddingTop = UDim.new(0, 6),
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		Parent = Fill,
	})

	Kit.New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6),
		Parent = Fill,
	})

	local Header = Kit.New("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Parent = Fill,
	})

	Kit.Label({
		Parent = Header,
		Text = "Advanced",
		Position = UDim2.fromOffset(8, 0),
		Size = UDim2.new(1, -72, 1, 0),
		Weight = "SemiBold",
		TextSize = 13,
	})

	local Close = Kit.Button({
		Parent = Header,
		Icon = Constants.Icons.Close,
		Fallback = Constants.Glyphs.Close,
		Variant = "Menu",
		Size = UDim2.fromOffset(26, 26),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		IconSize = 14,
		Radius = 7,
	})
	Close:OnActivated(function()
		self:SetAdvancedVisible(false)
	end)

	local Settings = Kit.Button({
		Parent = Header,
		Icon = Constants.Icons.Settings,
		Fallback = Constants.Glyphs.Settings,
		Variant = "Menu",
		Size = UDim2.fromOffset(26, 26),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -30, 0.5, 0),
		IconSize = 14,
		Radius = 7,
	})
	Settings:OnActivated(function()
		Core:OpenSettings()
	end)

	table.insert(self.Releases, Kit.MakeDraggable(Header, Shell))

	self.Tabs = Kit.Segmented({
		Parent = Fill,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 30),
		Options = { "Adjust", "Elements", "Map", "Options" },
		Default = "Adjust",
		Callback = function(Value)
			self:SetAdvancedPage(Value)
		end,
	})

	self.Scroll = Kit.New("ScrollingFrame", {
		Name = "Scroll",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 200),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 2,
		LayoutOrder = 3,
		ThemeTag = { ScrollBarImageColor3 = "ScrollBar" },
		Parent = Fill,
	})

	local Pages = Kit.New("Frame", {
		Name = "Pages",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = self.Scroll,
	}, {
		Kit.New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
	})
	self.PagesBody = Pages

	self.Pages = {
		Adjust = self:BuildAdjustPage(Pages),
		Elements = self:BuildElementsPage(Pages),
		Map = self:BuildMapPage(Pages),
		Options = self:BuildOptionsPage(Pages),
	}

	self:SetAdvancedPage("Adjust")
end

function Overlay:BuildAdjustPage(Parent)
	local Core = self.Core
	local Page = self:NewPage(Parent, "Adjust")

	local _, SelectionRight = Kit.Row(Page, 1, "Selection")
	self.AdvancedSelection = Kit.Label({
		Parent = SelectionRight,
		Text = "None",
		Size = UDim2.new(1, 0, 0, 16),
		TextXAlignment = Enum.TextXAlignment.Right,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Tag = "TextSecondary",
		Weight = "Regular",
	})

	Kit.Divider(Page, 2, 6)

	local MoveRow, MoveRight = Kit.Row(Page, 3, "Move")
	MoveRow.Size = UDim2.new(1, 0, 0, 74)

	local Pad = Kit.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(108, 63),
		Parent = MoveRight,
	})

	local Cells = {
		{ Icon = Constants.Icons.Up, Fallback = Constants.Glyphs.Up, Column = 1, Row = 0, X = 0, Y = -1 },
		{ Icon = Constants.Icons.Left, Fallback = Constants.Glyphs.Left, Column = 0, Row = 1, X = -1, Y = 0 },
		{ Icon = Constants.Icons.Down, Fallback = Constants.Glyphs.Down, Column = 1, Row = 1, X = 0, Y = 1 },
		{ Icon = Constants.Icons.Right, Fallback = Constants.Glyphs.Right, Column = 2, Row = 1, X = 1, Y = 0 },
	}

	for _, Cell in Cells do
		local Button = Kit.Button({
			Parent = Pad,
			Icon = Cell.Icon,
			Fallback = Cell.Fallback,
			Variant = "Subtle",
			Size = UDim2.fromOffset(34, 30),
			Position = UDim2.fromOffset(Cell.Column * 37, Cell.Row * 33),
			IconSize = 16,
		})

		table.insert(self.Controls, Button)

		self:Hold(Button, function()
			local Step = Core.Settings.NudgeStep
			Core:Nudge(Cell.X * Step, Cell.Y * Step)
		end)
	end

	self:BuildHost(Page, "", 4, function(Host)
		self:AddOption(Host, "AddSegmented", "HudDockNudgeStep", "NudgeStep", {
			Title = "Nudge step",
			Options = Constants.NudgeSteps,
		})
	end)

	Kit.Divider(Page, 5, 6)

	local _, ResizeRight = Kit.Row(Page, 6, "Resize")
	local _, ResizeButtons = Kit.Group(ResizeRight, 1, {
		{ Icon = Constants.Icons.Minus, Fallback = Constants.Glyphs.Minus, Width = 34 },
		{ Icon = Constants.Icons.Plus, Fallback = Constants.Glyphs.Plus, Width = 34 },
	})

	self:Hold(ResizeButtons[1], function()
		Core:Resize(-Core.Settings.ResizeStep)
	end)

	self:Hold(ResizeButtons[2], function()
		Core:Resize(Core.Settings.ResizeStep)
	end)

	local _, ElementRight = Kit.Row(Page, 7, "Element")
	local _, ElementButtons = Kit.Group(ElementRight, 1, {
		{ Text = "Reset", Width = 54 },
		{ Text = "Hide", Width = 48, Variant = "MenuDanger" },
	})

	ElementButtons[1]:OnActivated(function()
		Core:ResetSelected()
	end)

	ElementButtons[2]:OnActivated(function()
		Core:DeleteSelected()
	end)

	for _, Button in ResizeButtons do
		table.insert(self.Controls, Button)
	end

	for _, Button in ElementButtons do
		table.insert(self.Controls, Button)
	end

	return Page
end

function Overlay:BuildElementsPage(Parent)
	local Core = self.Core
	local Page = self:NewPage(Parent, "Elements")
	local Filter = "All"
	local Rows = {}
	local Pending = false
	local ArmedAt = 0

	local Summary = Kit.Label({
		Parent = Page,
		Text = "",
		Size = UDim2.new(1, 0, 0, 22),
		TextSize = 11,
		Tag = "TextSecondary",
		Weight = "Regular",
		LayoutOrder = 1,
	})
	Kit.New("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = Summary })

	local Rebuild

	local function Schedule()
		if Pending then
			return
		end

		Pending = true
		task.defer(function()
			Pending = false
			Rebuild()
		end)
	end

	Kit.Segmented({
		Parent = Page,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 30),
		Options = { "All", "Hidden", "Moved", "Resized" },
		Default = Filter,
		Callback = function(Value)
			Filter = Value
			Schedule()
		end,
	})

	local List = Kit.New("ScrollingFrame", {
		Name = "List",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 64),
		ScrollBarThickness = 2,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		LayoutOrder = 3,
		ThemeTag = { ScrollBarImageColor3 = "ScrollBar" },
		Parent = Page,
	}, {
		Kit.New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4),
		}),
	})

	local Empty = Kit.Label({
		Parent = List,
		Text = "Nothing modified yet",
		Size = UDim2.new(1, 0, 0, 56),
		TextXAlignment = Enum.TextXAlignment.Center,
		Tag = "TextSecondary",
		Weight = "Regular",
	})

	local function Matches(Rule)
		if Filter == "Hidden" then
			return Rule.IsDeleted
		elseif Filter == "Moved" then
			return not Rule.IsDeleted
		elseif Filter == "Resized" then
			return Rule.SizeModified
		end

		return true
	end

	local function Describe(Rule)
		if Rule.IsDeleted then
			return "Hidden"
		end

		return if Rule.SizeModified then "Moved and resized" else "Moved"
	end

	local function CreateRow(Key, Rule, Order)
		local Stroke = Kit.New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Thickness = 1,
			ThemeTag = { Color = "ElementBorder" },
		})
		Kit.Track(Stroke, "Transparency", 0.92)

		local Row = Kit.New("Frame", {
			Size = UDim2.new(1, -4, 0, 40),
			LayoutOrder = Order,
			ThemeTag = { BackgroundColor3 = "DropdownFrame" },
			Parent = List,
		}, {
			Kit.Corner(8),
			Stroke,
		})
		Kit.Track(Row, "BackgroundTransparency", 0.94)

		Kit.New("Frame", {
			Name = "Marker",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 7, 0.5, 0),
			Size = UDim2.fromOffset(3, 20),
			BorderSizePixel = 0,
			ThemeTag = { BackgroundColor3 = if Rule.IsDeleted then "Danger" else "Accent" },
			Parent = Row,
		}, { Kit.Corner(2) })

		Kit.Label({
			Parent = Row,
			Text = Rule.Name,
			Position = UDim2.fromOffset(18, 5),
			Size = UDim2.new(1, -86, 0, 16),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Weight = "SemiBold",
		})

		Kit.Label({
			Parent = Row,
			Text = Describe(Rule),
			Position = UDim2.fromOffset(18, 21),
			Size = UDim2.new(1, -86, 0, 14),
			TextSize = 11,
			Tag = if Rule.IsDeleted then "Danger" else "TextSecondary",
			Weight = "Regular",
		})

		local Restore = Kit.Button({
			Parent = Row,
			Icon = Constants.Icons.Reset,
			Fallback = Constants.Glyphs.Reset,
			Variant = "Menu",
			Size = UDim2.fromOffset(26, 26),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -6, 0.5, 0),
			IconSize = 14,
			Radius = 7,
		})
		Restore:OnActivated(function()
			Core:RestoreKey(Key)
		end)

		if not Rule.IsDeleted then
			local Focus = Kit.Button({
				Parent = Row,
				Icon = Constants.Icons.Focus,
				Fallback = Constants.Glyphs.Focus,
				Variant = "Menu",
				Size = UDim2.fromOffset(26, 26),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -36, 0.5, 0),
				IconSize = 14,
				Radius = 7,
			})
			Focus:OnActivated(function()
				Core:FocusKey(Key)
			end)
		end

		table.insert(Rows, Row)
	end

	Rebuild = function()
		if not Core.Started then
			return
		end

		for _, Row in Rows do
			Row:Destroy()
		end
		table.clear(Rows)

		local Order = 0
		for _, Key in Util.SortedKeys(Core.Book.Rules) do
			local Rule = Core.Book.Rules[Key]
			if Matches(Rule) then
				Order += 1
				CreateRow(Key, Rule, Order)
			end
		end

		Empty.Visible = Order == 0
		List.Size = UDim2.new(1, 0, 0, math.clamp(Order * 44, 64, 200))

		local Counts = Core.Book:Counts()
		Summary.Text = string.format(
			"%d modified  |  %d hidden  |  %d resized  |  %d in history",
			Counts.Total,
			Counts.Hidden,
			Counts.Resized,
			#Core.History.Undos
		)
	end

	local Reset = Kit.Button({
		Parent = Page,
		Text = "Reset all changes",
		Variant = "Danger",
		Size = UDim2.new(1, 0, 0, 30),
		LayoutOrder = 4,
	})

	Reset:OnActivated(function()
		if Core.Book:Counts().Total == 0 then
			return Core:Toast("There is nothing to reset")
		end

		if ArmedAt > 0 and os.clock() - ArmedAt < 3 then
			ArmedAt = 0
			Reset:SetText("Reset all changes")
			return Core:ResetAll()
		end

		local Stamp = os.clock()
		ArmedAt = Stamp
		Reset:SetText("Tap again to confirm")

		task.delay(3, function()
			if ArmedAt == Stamp then
				ArmedAt = 0
				Reset:SetText("Reset all changes")
			end
		end)
	end)

	self:Listen(Core.Book.Changed, Schedule)
	self:Listen(Core.History.Changed, Schedule)
	Rebuild()

	return Page
end

function Overlay:BuildOptionsPage(Parent)
	local Core = self.Core
	local Page = self:NewPage(Parent, "Options")

	self:BuildHost(Page, "Behavior", 1, function(Host)
		self:AddOption(Host, "AddToggle", "HudDockGroupCluster", "GroupCluster", {
			Title = "Move linked elements together",
			Description = "Elements sharing a center are edited as one",
		})

		self:AddOption(Host, "AddToggle", "HudDockRespectLocks", "RespectLocks", {
			Title = "Respect element locks",
			Description = "Skip elements that lock themselves",
		})

		Host:AddToggle("HudDockBarLocked", {
			Title = "Lock action bar",
			Description = "Keep the action bar from being dragged",
			Default = Core.Session.BarLocked,
			Callback = function(Value)
				Core:SetBarLocked(Value)
			end,
		})
		table.insert(self.OptionIds, "HudDockBarLocked")
	end)

	self:BuildHost(Page, "Selection", 2, function(Host)
		self:AddOption(Host, "AddSegmented", "HudDockSelectionMode", "SelectionMode", {
			Title = "Selection mode",
			Options = { "Smart", "Exact" },
		})

		self:AddOption(Host, "AddSegmented", "HudDockAxis", "Axis", {
			Title = "Drag axis",
			Options = { "Free", "Horizontal", "Vertical" },
		})
	end)

	self:BuildHost(Page, "Precision", 3, function(Host)
		self:AddOption(Host, "AddSlider", "HudDockResizeStep", "ResizeStep", {
			Title = "Resize step",
			Min = 1,
			Max = 50,
			Rounding = 0,
			Suffix = " px",
		})

		self:AddOption(Host, "AddSlider", "HudDockSnapSize", "SnapSize", {
			Title = "Snap to grid",
			Min = 0,
			Max = 50,
			Rounding = 0,
			Suffix = " px",
		})
	end)

	return Page
end

function Overlay:BuildMapPage(Parent)
	local Page = self:NewPage(Parent, "Map")
	local Viewport = Util.GetViewport()

	local Body = Kit.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 180),
		LayoutOrder = 1,
		Parent = Page,
	})

	local Stroke = Kit.New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = 1,
		ThemeTag = { Color = "ElementBorder" },
	})
	Kit.Track(Stroke, "Transparency", 0.85)

	local Ratio = Kit.New("UIAspectRatioConstraint", {
		AspectRatio = Viewport.X / math.max(Viewport.Y, 1),
		DominantAxis = Enum.DominantAxis.Height,
		AspectType = Enum.AspectType.FitWithinMaxSize,
	})

	local Surface = Kit.New("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = true,
		ThemeTag = { BackgroundColor3 = "DropdownFrame" },
		Parent = Body,
	}, {
		Kit.Corner(8),
		Stroke,
		Ratio,
	})
	Kit.Track(Surface, "BackgroundTransparency", 0.94)

	local Legend = Kit.Label({
		Parent = Page,
		Text = "Accent is selected, gray is moved, red is hidden. Tap a block to focus it.",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		TextSize = 11,
		Tag = "TextSecondary",
		Weight = "Regular",
		LayoutOrder = 2,
	})
	Kit.New("UIPadding", {
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		PaddingTop = UDim.new(0, 4),
		Parent = Legend,
	})

	self.Map = {
		Surface = Surface,
		Ratio = Ratio,
		Boxes = {},
		Kinds = {},
		Palette = {
			Selected = { Background = "Accent", Transparency = 0.35 },
			Moved = { Background = "SubText", Transparency = 0.7 },
			Hidden = { Background = "Danger", Transparency = 0.7 },
		},
	}

	return Page
end

function Overlay:DrawMap(Object, Kind, Screen, Seen)
	local Map = self.Map

	if not Object.Parent or Seen[Object] then
		return
	end

	Seen[Object] = true

	local Box = Map.Boxes[Object]
	if not Box then
		Box = Kit.New("TextButton", {
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			ThemeTag = { BackgroundColor3 = Map.Palette[Kind].Background },
			Parent = Map.Surface,
		})
		Box.Activated:Connect(function()
			self.Core:FocusObject(Object)
		end)
		Map.Boxes[Object] = Box
	end

	if Map.Kinds[Box] ~= Kind then
		Map.Kinds[Box] = Kind
		Kit.Retag(Box, { BackgroundColor3 = Map.Palette[Kind].Background })
		Box.BackgroundTransparency = Map.Palette[Kind].Transparency
	end

	local Position = Geometry.ScreenPosition(Object)
	local Size = Object.AbsoluteSize

	Box.Position = UDim2.fromScale(Position.X / Screen.X, Position.Y / Screen.Y)
	Box.Size = UDim2.fromScale(math.max(Size.X / Screen.X, 0.008), math.max(Size.Y / Screen.Y, 0.008))
end

function Overlay:SyncMap()
	local Map = self.Map
	local Screen = Util.GetViewport()

	if Screen.X <= 0 or Screen.Y <= 0 then
		return
	end

	local Seen = {}
	local Session = self.Core.Session

	if Session.Selected then
		self:DrawMap(Session.Selected, "Selected", Screen, Seen)
	end

	for _, Member in Session.Cluster do
		self:DrawMap(Member, "Selected", Screen, Seen)
	end

	for Object, Key in self.Core.Book.Tracked do
		local Rule = self.Core.Book.Rules[Key]
		if Rule then
			self:DrawMap(Object, if Rule.IsDeleted then "Hidden" else "Moved", Screen, Seen)
		end
	end

	for Object, Box in Map.Boxes do
		if not Seen[Object] then
			Box:Destroy()
			Map.Boxes[Object] = nil
			Map.Kinds[Box] = nil
		end
	end
end

function Overlay:Tick(Delta)
	self:StepDock(Delta)
	self:StepMap()
end

function Overlay:StepMap()
	if not self.Advanced.Visible or self.ActivePage ~= "Map" then
		return
	end

	local Now = os.clock()
	if Now - (self.LastMap or 0) < Constants.MapInterval then
		return
	end

	self.LastMap = Now
	self:SyncMap()
end

function Overlay:SetAdvancedPage(Name)
	self.ActivePage = Name

	for Key, Page in self.Pages do
		Page.Visible = Key == Name
	end

	if Name == "Map" then
		self:SyncMap()
	end
end

function Overlay:SetAdvancedVisible(Visible)
	self.Advanced.Visible = Visible
	self.AdvancedButton:SetVariant(if Visible then "Active" else "Menu")

	if Visible and self.ActivePage == "Map" then
		self:SyncMap()
	end
end

function Overlay:ToggleAdvanced()
	self:SetAdvancedVisible(not self.Advanced.Visible)
end

local function NewSession()
	return {
		EditMode = false,
		Selected = nil,
		Cluster = {},
		BarLocked = false,
		DragInput = nil,
		DragOrigin = Vector3.zero,
		DragMoved = false,
		DragSet = {},
		DragStart = {},
		DragKeys = {},
		DragBefore = {},
	}
end

local function NewSettings()
	return {
		ResizeStep = 15,
		SnapSize = 0,
		Axis = "Free",
		SelectionMode = "Smart",
		GroupCluster = true,
		ShowLauncher = true,
		RespectLocks = true,
		LoadMode = "Replace",
		NudgeStep = 5,
	}
end

local HUDManager = {}
HUDManager.Version = Constants.Version
HUDManager.Folder = "HUDManager"
HUDManager.Library = nil
HUDManager.Extension = nil
HUDManager.SaveManager = nil
HUDManager.Started = false
HUDManager.GameId = tostring(if game.GameId > 0 then game.GameId else game.PlaceId)
HUDManager.GameName = "UnknownGame"
HUDManager.ActiveProfile = nil
HUDManager.ScanToken = 0
HUDManager.Settings = NewSettings()
HUDManager.Session = NewSession()
HUDManager.Bindings = {}
HUDManager.Presses = {}
HUDManager.Signals = {
	StateChanged = Signal.new(),
	SelectionChanged = Signal.new(),
	SettingChanged = Signal.new(),
}

function HUDManager:SetLibrary(Library)
	self.Library = Library
end

function HUDManager:SetExtension(Extension)
	self.Extension = Extension
end

function HUDManager:SetSaveManager(SaveManager)
	self.SaveManager = SaveManager
end

function HUDManager:SetFolder(Folder)
	self.Folder = Folder
	self:BuildFolderTree()
end

function HUDManager:BuildFolderTree()
	Util.EnsureFolder(self.Folder)
	Util.EnsureFolder(self.Folder .. "/Profiles")
	Util.EnsureFolder(ProfileStore.GameFolder(self))
end

function HUDManager:Notify(Content, SubContent)
	if not self.Library then
		return
	end

	self.Library:Notify({
		Title = "HUD Manager",
		Content = Content,
		SubContent = SubContent,
		Duration = 4,
	})
end

function HUDManager:Toast(Text)
	if self.Library then
		self.Library:Toast(Text, 2)
	end
end

function HUDManager:IsOwned(Gui)
	local Library = self.Library
	local Root = if Gui:IsA("ScreenGui") then Gui else Gui:FindFirstAncestorOfClass("ScreenGui")

	if not Root then
		return false
	end

	if Root == Library.GUI or Root == Library.MenuGUI then
		return true
	end

	if self.Overlay and (Root == self.Overlay.Layer or Root == self.Overlay.ShieldLayer) then
		return true
	end

	return string.sub(Root.Name, 1, 11) == "FluentLayer"
end

function HUDManager:Start()
	if self.Started then
		return self
	end

	assert(self.Library, "HUDManager - Library is not set, call SetLibrary first")

	Kit.Bind(self.Library)

	self.Book = RuleBook.new()
	self.History = History.new(Constants.HistoryLimit)
	self.Session = NewSession()
	self.Connections = {}
	self.Presses = {}
	self.Started = true

	self:BuildFolderTree()

	self.Overlay = Overlay.new(self)
	self:ApplyLauncherState()
	self:IgnoreSaveIndexes(self.Overlay.OptionIds)

	table.insert(
		self.Connections,
		UserInputService.InputBegan:Connect(function(Input)
			self:OnInputBegan(Input)
		end)
	)

	table.insert(
		self.Connections,
		UserInputService.InputChanged:Connect(function(Input)
			self:OnInputChanged(Input)
		end)
	)

	table.insert(
		self.Connections,
		UserInputService.InputEnded:Connect(function(Input)
			self:OnInputEnded(Input)
		end)
	)

	table.insert(
		self.Connections,
		PlayerGui.DescendantAdded:Connect(function(Object)
			if next(self.Book.Rules) ~= nil then
				task.defer(Scanner.Track, self, Object)
			end
		end)
	)

	table.insert(
		self.Connections,
		self.History.Changed:Connect(function()
			self.Overlay:SetHistoryState(#self.History.Undos > 0, #self.History.Redos > 0)
		end)
	)

	pcall(RunService.UnbindFromRenderStep, RunService, Constants.RenderStepName)
	RunService:BindToRenderStep(Constants.RenderStepName, Constants.RenderPriority, function(Delta)
		Enforcer.Step(self, Delta)
	end)

	if not self.UnloadHooked then
		self.UnloadHooked = true
		self.Library:OnUnload(function()
			self:Destroy(false)
		end)
	end

	task.spawn(function()
		local Success, Info = pcall(function()
			return MarketplaceService:GetProductInfo(game.PlaceId)
		end)

		if Success and type(Info) == "table" and Info.Name then
			self.GameName = Util.SanitizeName(Info.Name)
		end
	end)

	return self
end

function HUDManager:Destroy(Restore)
	if not self.Started then
		return
	end

	self.Started = false
	self.ScanToken += 1

	if Restore then
		pcall(function()
			self.Book:Clear()
		end)
	end

	pcall(RunService.UnbindFromRenderStep, RunService, Constants.RenderStepName)

	for _, Link in self.Connections do
		Link:Disconnect()
	end
	table.clear(self.Connections)

	if self.Overlay then
		self.Overlay:Destroy()
		self.Overlay = nil
	end

	self.Session = NewSession()
	self.Signals.StateChanged:Fire(false)
end

function HUDManager:OnShieldPressed(Input)
	if not Util.IsPointer(Input) or not self.Session.EditMode then
		return
	end

	if self:IsOverWindow() then
		return
	end

	local Target = self:PickAt(Input.Position)
	if Target then
		self:SelectObject(Target)
		self:BeginDrag(Input)
	else
		self:ClearSelection()
	end
end

function HUDManager:IsOverWindow()
	local Window = self.Library.Window
	if not (Window and Window.Root and Window.Root.Visible) then
		return false
	end

	return Util.PointInGui(UserInputService:GetMouseLocation(), Window.Root)
end

function HUDManager:OnInputBegan(Input)
	if not Util.IsPointer(Input) or self.Session.EditMode or next(self.Book.Rules) == nil then
		return
	end

	local Objects = {}
	local Found = false

	for Object, Key in self.Book.Tracked do
		local Rule = self.Book.Rules[Key]

		if
			Rule
			and not Rule.IsDeleted
			and Object.Parent
			and Object.Visible
			and Geometry.ContainsInput(Object, Input.Position)
		then
			Objects[Object] = true
			Found = true
		end
	end

	if Found then
		self.Presses[Input] = {
			Origin = Vector2.new(Input.Position.X, Input.Position.Y),
			Moved = false,
			Objects = Objects,
		}
	end
end

function HUDManager:TrackPresses(Input)
	for Key, Press in self.Presses do
		if not Press.Moved then
			local Tracking = if Key.UserInputType == Enum.UserInputType.Touch
				then Input == Key
				else Input.UserInputType == Enum.UserInputType.MouseMovement

			if Tracking then
				local Travel = Vector2.new(Input.Position.X, Input.Position.Y) - Press.Origin
				if Travel.Magnitude >= Constants.TapThreshold then
					Press.Moved = true
				end
			end
		end
	end
end

function HUDManager:IsYielding(Object)
	for _, Press in self.Presses do
		if Press.Moved and Press.Objects[Object] then
			return true
		end
	end

	return false
end

function HUDManager:AdoptPosition(Object, Key)
	local Rule = self.Book.Rules[Key]
	if not Rule then
		return
	end

	local Before = self.Book:Snapshot(Key)
	Rule.Position = Object.Position

	self.History:Push("Move", { { Key = Key, Before = Before, After = self.Book:Snapshot(Key) } })
	self.Book.Changed:Fire()
end

function HUDManager:IsElementLocked(Object)
	if not self.Settings.RespectLocks then
		return false
	end

	local Current = Object

	while Current and Current ~= PlayerGui do
		if Current:GetAttribute(Constants.LockAttribute) == true then
			return true
		end

		Current = Current.Parent
	end

	return false
end

function HUDManager:OnInputChanged(Input)
	self:TrackPresses(Input)

	local Dragging = self.Session.DragInput
	if not Dragging then
		return
	end

	local Tracking = if Dragging.UserInputType == Enum.UserInputType.Touch
		then Input == Dragging
		else Input.UserInputType == Enum.UserInputType.MouseMovement

	if Tracking then
		self:UpdateDrag(Input)
	end
end

function HUDManager:OnInputEnded(Input)
	for Key in self.Presses do
		local Same = Key == Input
			or (
				Key.UserInputType == Enum.UserInputType.MouseButton1
				and Input.UserInputType == Enum.UserInputType.MouseButton1
			)

		if Same then
			self.Presses[Key] = nil
		end
	end

	local Dragging = self.Session.DragInput
	if not Dragging then
		return
	end

	local MouseRelease = Dragging.UserInputType == Enum.UserInputType.MouseButton1
		and Input.UserInputType == Enum.UserInputType.MouseButton1

	if Input == Dragging or MouseRelease then
		self:EndDrag()
	end
end

function HUDManager:PickAt(Position)
	local Success, Hits = pcall(function()
		return PlayerGui:GetGuiObjectsAtPosition(Position.X, Position.Y)
	end)

	if not Success or type(Hits) ~= "table" then
		return nil
	end

	return Picker.Pick(Hits, Util.GetViewport(), self.Settings.SelectionMode, function(Gui)
		return not self:IsOwned(Gui)
	end)
end

function HUDManager:PrepareElement(Object)
	self.Book:Capture(Object, KeyResolver.Resolve(Object))
	LayoutBaker.Bake(self.Book, Object.Parent)
end

function HUDManager:SelectObject(Object)
	local Session = self.Session

	Session.Selected = Object
	Session.Cluster = if self.Settings.GroupCluster and self.Settings.SelectionMode == "Smart"
		then Picker.BuildCluster(Object)
		else { Object }

	for _, Member in Session.Cluster do
		self:PrepareElement(Member)
	end

	self.Overlay:SetSelection(Object)
	self.Signals.SelectionChanged:Fire(Object)
end

function HUDManager:ClearSelection()
	local Session = self.Session

	Session.Selected = nil
	Session.Cluster = {}

	if self.Overlay then
		self.Overlay:SetSelection(nil)
	end

	self.Signals.SelectionChanged:Fire(nil)
end

function HUDManager:HasSelection()
	return self.Session.Selected ~= nil and #self.Session.Cluster > 0
end

function HUDManager:RequireSelection()
	if self:HasSelection() then
		return true
	end

	self:Toast("Select an element first")
	return false
end

function HUDManager:SetEditMode(Enabled)
	Enabled = Enabled == true

	local Session = self.Session
	if not self.Started or Session.EditMode == Enabled then
		return
	end

	Session.EditMode = Enabled

	if not Enabled then
		self:EndDrag()
		self:ClearSelection()
	end

	self.Overlay:SetEditState(Enabled)
	self.Signals.StateChanged:Fire(Enabled)
end

function HUDManager:SetBarLocked(Locked)
	Locked = Locked == true

	if self.Session.BarLocked == Locked then
		return
	end

	self.Session.BarLocked = Locked
	self.Overlay:SetBarLocked(Locked)
end

function HUDManager:SetSetting(Key, Value)
	if self.Settings[Key] == Value then
		return
	end

	self.Settings[Key] = Value
	self:SyncSetting(Key)
	self.Signals.SettingChanged:Fire(Key, Value)

	if Key == "ShowLauncher" then
		self:ApplyLauncherState()
	elseif Key == "ResizeStep" and self.Overlay then
		self.Overlay:SetResizeStep(Value)
	elseif Key == "RespectLocks" and self.Overlay then
		self.Overlay:SetSelection(self.Session.Selected)
	end
end

function HUDManager:BindOption(Key, Idx)
	local List = self.Bindings[Key]

	if not List then
		List = {}
		self.Bindings[Key] = List
	end

	if not table.find(List, Idx) then
		table.insert(List, Idx)
	end
end

function HUDManager:SyncSetting(Key)
	local List = self.Bindings[Key]
	if not List then
		return
	end

	local Value = self.Settings[Key]

	for _, Idx in List do
		local Option = self.Library.Options[Idx]

		if Option and Option.Value ~= Value then
			pcall(Option.SetValue, Option, Value)
		end
	end
end

function HUDManager:ApplyLauncherState()
	local Show = self.Settings.ShowLauncher

	if self.Overlay then
		self.Overlay:SetLauncherVisible(Show)
	end

	if self.ControlSection then
		self.ControlSection:SetVisible(not Show)
	end
end

function HUDManager:BeginDrag(Input)
	local Session = self.Session

	Session.DragInput = Input
	Session.DragOrigin = Input.Position
	Session.DragMoved = false
	Session.DragSet = {}
	Session.DragStart = {}
	Session.DragKeys = {}
	Session.DragBefore = {}
end

function HUDManager:BeginDragMutation()
	local Session = self.Session
	local Skipped = 0

	for _, Object in Session.Cluster do
		if self:IsElementLocked(Object) then
			Skipped += 1
		else
			local Key = KeyResolver.Resolve(Object)
			Session.DragBefore[Key] = self.Book:Snapshot(Key)

			local Rule = self.Book:Ensure(Object, Key)
			Session.DragStart[Object] = Rule.Position
			Session.DragKeys[Object] = Key
			Session.DragSet[Object] = true
		end
	end

	if Skipped > 0 and next(Session.DragStart) == nil then
		self:Toast("Element is locked, unlock it first")
	end
end

function HUDManager:UpdateDrag(Input)
	local Session = self.Session
	local Raw = Input.Position - Session.DragOrigin
	local Delta = Vector2.new(Raw.X, Raw.Y)

	if not Session.DragMoved then
		if Delta.Magnitude < Constants.DragSlop then
			return
		end

		self:BeginDragMutation()
		Session.DragMoved = true
	end

	local Settings = self.Settings
	local X = if Settings.Axis == "Vertical" then 0 else Util.Snap(Delta.X, Settings.SnapSize)
	local Y = if Settings.Axis == "Horizontal" then 0 else Util.Snap(Delta.Y, Settings.SnapSize)

	for Object, Start in Session.DragStart do
		local Rule = self.Book.Rules[Session.DragKeys[Object]]
		if Rule then
			Rule.Position = UDim2.new(Start.X.Scale, Start.X.Offset + X, Start.Y.Scale, Start.Y.Offset + Y)
			Object.Position = Rule.Position
		end
	end
end

function HUDManager:EndDrag()
	local Session = self.Session
	if not Session.DragInput then
		return
	end

	if Session.DragMoved then
		local Changes = {}

		for _, Key in Session.DragKeys do
			table.insert(Changes, {
				Key = Key,
				Before = Session.DragBefore[Key],
				After = self.Book:Snapshot(Key),
			})
		end

		self.History:Push("Move", Changes)
		self.Book.Changed:Fire()
	end

	Session.DragInput = nil
	Session.DragMoved = false
	Session.DragSet = {}
	Session.DragStart = {}
	Session.DragKeys = {}
	Session.DragBefore = {}
end

function HUDManager:IsDragging()
	local Input = self.Session.DragInput
	if not Input then
		return false
	end

	local State = Input.UserInputState
	if State == Enum.UserInputState.End or State == Enum.UserInputState.Cancel then
		self:EndDrag()
		return false
	end

	return true
end

function HUDManager:Mutate(Label, Mutator, Merge, IgnoreLock)
	if not self:RequireSelection() or self:IsDragging() then
		return false
	end

	local Changes = {}
	local Skipped = 0

	for _, Object in self.Session.Cluster do
		if not IgnoreLock and self:IsElementLocked(Object) then
			Skipped += 1
		else
			local Key = KeyResolver.Resolve(Object)
			local Before = self.Book:Snapshot(Key)
			local Rule = self.Book:Ensure(Object, Key)

			if Mutator(Rule, Object) == false then
				if not Before then
					self.Book:Release(Key)
				end
			else
				self.Book:Apply(Object, Key, false)
				table.insert(Changes, { Key = Key, Before = Before, After = self.Book:Snapshot(Key) })
			end
		end
	end

	if #Changes == 0 then
		if Skipped > 0 then
			self:Toast("Element is locked, unlock it first")
		end

		return false
	end

	self.History:Push(Label, Changes, Merge)
	self.Book.Changed:Fire()
	self.Overlay:SetSelection(self.Session.Selected)
	return true
end

function HUDManager:Nudge(DeltaX, DeltaY)
	return self:Mutate("Nudge", function(Rule)
		local Position = Rule.Position
		Rule.Position = UDim2.new(
			Position.X.Scale,
			Position.X.Offset + DeltaX,
			Position.Y.Scale,
			Position.Y.Offset + DeltaY
		)
	end, true)
end

function HUDManager:Resize(Delta)
	return self:Mutate("Resize", function(Rule, Object)
		local Current = Object.AbsoluteSize
		if Current.X + Delta < Constants.MinElementSize or Current.Y + Delta < Constants.MinElementSize then
			return false
		end

		local Size = Rule.Size
		Rule.Size = UDim2.new(Size.X.Scale, Size.X.Offset + Delta, Size.Y.Scale, Size.Y.Offset + Delta)
		Rule.SizeModified = true

		local Anchor = Object.AnchorPoint
		local Position = Rule.Position
		Rule.Position = UDim2.new(
			Position.X.Scale,
			Position.X.Offset + math.round((Anchor.X - 0.5) * Delta),
			Position.Y.Scale,
			Position.Y.Offset + math.round((Anchor.Y - 0.5) * Delta)
		)

		return true
	end, true)
end

function HUDManager:DeleteSelected()
	local Done = self:Mutate("Hide", function(Rule)
		Rule.IsDeleted = true
		return true
	end, nil, true)

	if Done then
		self:ClearSelection()
	end

	return Done
end

function HUDManager:ResetSelected()
	if not self:RequireSelection() then
		return false
	end

	local Changes = {}

	for _, Object in self.Session.Cluster do
		local Key = KeyResolver.Resolve(Object)
		local Before = self.Book:Snapshot(Key)

		if Before then
			self.Book:Release(Key)
			table.insert(Changes, { Key = Key, Before = Before, After = nil })
		end
	end

	if #Changes == 0 then
		self:Toast("Nothing to reset on this element")
		return false
	end

	self.History:Push("Reset", Changes)
	self.Book.Changed:Fire()
	self.Overlay:SetSelection(self.Session.Selected)
	return true
end

function HUDManager:RestoreKey(Key)
	local Before = self.Book:Snapshot(Key)
	if not Before then
		return false
	end

	self.Book:Release(Key)
	self.History:Push("Restore", { { Key = Key, Before = Before, After = nil } })
	self.Book.Changed:Fire()
	return true
end

function HUDManager:FocusObject(Object)
	self:SetEditMode(true)
	self:SelectObject(Object)
end

function HUDManager:FocusKey(Key)
	local Object = self.Book:FindObject(Key)

	if Object and Object.Visible then
		self:FocusObject(Object)
		return true
	end

	self:Toast("Element is not on screen right now")
	return false
end

function HUDManager:ApplyChanges(Changes, Field)
	for _, Change in Changes do
		local State = Change[Field]

		if State == nil then
			self.Book:Release(Change.Key)
		else
			self.Book.Rules[Change.Key] = table.clone(State)
		end
	end

	Scanner.Rescan(self)
	self.Book.Changed:Fire()
end

function HUDManager:Undo()
	local Entry = self.History:PopUndo()
	if not Entry then
		self:Toast("Nothing to undo")
		return false
	end

	self:ApplyChanges(Entry.Changes, "Before")
	return true
end

function HUDManager:Redo()
	local Entry = self.History:PopRedo()
	if not Entry then
		self:Toast("Nothing to redo")
		return false
	end

	self:ApplyChanges(Entry.Changes, "After")
	return true
end

function HUDManager:ReplaceRules(Incoming, Merge, Label)
	local Keys = {}

	for Key in Incoming do
		Keys[Key] = true
	end

	if not Merge then
		for Key in self.Book.Rules do
			Keys[Key] = true
		end
	end

	local Changes = {}
	for Key in Keys do
		table.insert(Changes, {
			Key = Key,
			Before = self.Book:Snapshot(Key),
			After = if Incoming[Key] then table.clone(Incoming[Key]) else nil,
		})
	end

	self.History:Push(Label, Changes)
	self:ApplyChanges(Changes, "After")
	self:ClearSelection()
end

function HUDManager:ResetAll()
	self:ReplaceRules({}, false, "Reset all")
end

function HUDManager:OpenSettings()
	local Window = self.Library.Window
	if not Window then
		return
	end

	if Window.Minimized then
		Window:Minimize()
	end

	if self.Tab then
		Window:SelectTab(self.Tab)
	end
end

function HUDManager:HideWindow()
	local Window = self.Library.Window
	if Window and not Window.Minimized then
		Window:Minimize()
	end
end

function HUDManager:QuickSave()
	local Name = self.ActiveProfile or "Quick"
	local Success, Problem = ProfileStore.Save(self, Name)

	if not Success then
		return self:Notify("Failed to save", tostring(Problem))
	end

	self:Notify("Profile saved", string.format("%q", Name))
end

function HUDManager:SaveProfile(Name)
	return ProfileStore.Save(self, Name)
end

function HUDManager:LoadProfile(Name)
	return ProfileStore.Load(self, Name, self.Settings.LoadMode == "Merge")
end

function HUDManager:DeleteProfile(Name)
	return ProfileStore.Delete(self, Name)
end

function HUDManager:ListProfiles()
	return ProfileStore.List(self)
end

function HUDManager:LoadAutoloadConfig()
	self:Start()

	local Name = ProfileStore.GetAutoload(self)
	if not Name then
		return
	end

	local Success, Problem = self:LoadProfile(Name)
	if not Success then
		return self:Notify("Autoload failed", tostring(Problem))
	end

	self:Notify("HUD profile auto loaded", string.format("%q", Name))
end

function HUDManager:IgnoreSaveIndexes(List)
	local Manager = self.SaveManager or (self.Extension and self.Extension.SaveManager)

	if Manager then
		pcall(function()
			Manager:SetIgnoreIndexes(List)
		end)
	end
end

function HUDManager:Confirm(Title, Content, Label, Action)
	self.Library.Window:Dialog({
		Title = Title,
		Content = Content,
		Buttons = {
			{ Title = Label, Variant = "Danger", Callback = Action },
			{ Title = "Cancel" },
		},
	})
end

function HUDManager:BuildControlSection(Tab)
	self:Start()

	local Library = self.Library
	local Section = Tab:AddSection("Controls", { Icon = "lucide:mouse-pointer-2" })
	self.ControlSection = Section

	Section:AddToggle("HudEditMode", {
		Title = "Edit mode",
		Description = "Select, drag and resize elements on screen, the window hides while editing",
		Icon = "lucide:pencil",
		Default = self.Session.EditMode,
		Callback = function(Value)
			self:SetEditMode(Value)
			if Value then
				self:HideWindow()
			end
		end,
	})

	Section:AddButton({
		Title = "Undo",
		Description = "Revert the last change",
		Variant = "Tonal",
		ButtonText = "Undo",
		ButtonIcon = "lucide:undo-2",
		Callback = function()
			self:Undo()
		end,
	})

	Section:AddButton({
		Title = "Redo",
		Description = "Apply the change that was reverted",
		Variant = "Tonal",
		ButtonText = "Redo",
		ButtonIcon = "lucide:redo-2",
		Callback = function()
			self:Redo()
		end,
	})

	Section:AddButton({
		Title = "Quick save",
		Description = "Save the layout to the active profile",
		Variant = "Primary",
		ButtonText = "Save",
		ButtonIcon = "lucide:save",
		Callback = function()
			self:QuickSave()
		end,
	})

	Section:AddButton({
		Title = "Advanced panel",
		Description = "Nudge, resize and review modified elements",
		Variant = "Outline",
		ButtonText = "Toggle",
		ButtonIcon = "lucide:sliders-horizontal",
		Callback = function()
			self.Overlay:ToggleAdvanced()
		end,
	})

	table.insert(
		self.Connections,
		self.Signals.StateChanged:Connect(function(Enabled)
			local Option = Library.Options.HudEditMode
			if Option and Option.Value ~= Enabled then
				pcall(Option.SetValue, Option, Enabled)
			end
		end)
	)

	self:ApplyLauncherState()
end

function HUDManager:BuildConfigSection(Tab)
	self:Start()

	local Settings = self.Settings
	local Section = Tab:AddSection("Configuration", { Icon = "lucide:sliders-horizontal" })

	Section:AddToggle("HudShowLauncher", {
		Title = "Floating launcher",
		Description = "Draggable button that opens the dock, the Controls section only shows while it is off",
		Icon = "lucide:circle-dot",
		Default = Settings.ShowLauncher,
		Callback = function(Value)
			self:SetSetting("ShowLauncher", Value)
		end,
	})
	self:BindOption("ShowLauncher", "HudShowLauncher")

	Section:AddToggle("HudGroupCluster", {
		Title = "Move linked elements together",
		Description = "Elements that share the same center are edited as one",
		Icon = "lucide:link",
		Default = Settings.GroupCluster,
		Callback = function(Value)
			self:SetSetting("GroupCluster", Value)
		end,
	})
	self:BindOption("GroupCluster", "HudGroupCluster")

	Section:AddToggle("HudRespectLocks", {
		Title = "Respect element locks",
		Description = "Elements that lock themselves with the Locked attribute cannot be moved or resized here",
		Icon = "lucide:lock",
		Default = Settings.RespectLocks,
		Callback = function(Value)
			self:SetSetting("RespectLocks", Value)
		end,
	})
	self:BindOption("RespectLocks", "HudRespectLocks")

	Section:AddSegmented("HudSelectionMode", {
		Title = "Selection mode",
		Description = "Smart climbs to the whole button, Exact picks the layer you tapped",
		Options = { "Smart", "Exact" },
		Default = Settings.SelectionMode,
		Callback = function(Value)
			self:SetSetting("SelectionMode", Value)
		end,
	})
	self:BindOption("SelectionMode", "HudSelectionMode")

	Section:AddSegmented("HudAxis", {
		Title = "Drag axis",
		Description = "Restrict dragging to a single direction",
		Options = { "Free", "Horizontal", "Vertical" },
		Default = Settings.Axis,
		Callback = function(Value)
			self:SetSetting("Axis", Value)
		end,
	})
	self:BindOption("Axis", "HudAxis")

	Section:AddSlider("HudResizeStep", {
		Title = "Resize step",
		Description = "Pixels added or removed by the size buttons",
		Icon = "lucide:maximize-2",
		Min = 1,
		Max = 50,
		Default = Settings.ResizeStep,
		Rounding = 0,
		Suffix = " px",
		Callback = function(Value)
			self:SetSetting("ResizeStep", Value)
		end,
	})
	self:BindOption("ResizeStep", "HudResizeStep")

	Section:AddSlider("HudSnapSize", {
		Title = "Snap to grid",
		Description = "Round drag distance to this many pixels, 0 turns it off",
		Icon = "lucide:grid",
		Min = 0,
		Max = 50,
		Default = Settings.SnapSize,
		Rounding = 0,
		Suffix = " px",
		Callback = function(Value)
			self:SetSetting("SnapSize", Value)
		end,
	})
	self:BindOption("SnapSize", "HudSnapSize")
end

function HUDManager:BuildProfileSection(Tab)
	self:Start()

	local Library = self.Library
	local Section = Tab:AddSection("Saving", { Icon = "lucide:save" })
	local AutoloadButton

	Section:AddSegmented("HudLoadMode", {
		Title = "Profile loading",
		Description = "Replace restores everything first, Merge keeps current changes",
		Options = { "Replace", "Merge" },
		Default = self.Settings.LoadMode,
		Callback = function(Value)
			self.Settings.LoadMode = Value
		end,
	})

	Section:AddInput("HudProfileName", {
		Title = "Profile name",
		Description = "Name for a new profile",
		Variant = "Field",
		Icon = "lucide:pencil",
		Placeholder = "My HUD",
		Finished = false,
	})

	Section:AddDropdown("HudProfileList", {
		Title = "Saved profiles",
		Description = "Profiles stored for this game",
		Icon = "lucide:folder-open",
		Variant = "Compact",
		Values = ProfileStore.List(self),
		AllowNull = true,
	})

	local function Selected()
		return Library.Options.HudProfileList.Value
	end

	local function DescribeAutoload()
		AutoloadButton:SetDesc("Current autoload profile: " .. (ProfileStore.GetAutoload(self) or "none"))
	end

	local function Refresh()
		Library.Options.HudProfileList:SetValues(ProfileStore.List(self))
		Library.Options.HudProfileList:SetValue(nil)
		DescribeAutoload()
	end

	local function Create(Name)
		local Success, Problem = ProfileStore.Save(self, Name)
		if not Success then
			return self:Notify("Failed to save", tostring(Problem))
		end

		self:Notify("Profile saved", string.format("%q", Util.SanitizeName(Name)))
		Refresh()
	end

	Section:AddButton({
		Title = "Create profile",
		Description = "Save the current layout as a new profile",
		Variant = "Primary",
		ButtonText = "Create",
		ButtonIcon = "lucide:save",
		Callback = function()
			local Name = Util.SanitizeName(Library.Options.HudProfileName.Value)

			if Name == "" then
				return self:Notify("Failed to save", "invalid profile name")
			end

			if Util.HasFileSystem() and isfile(ProfileStore.Path(self, Name)) then
				return self:Confirm(
					"Overwrite profile",
					string.format("Profile %q already exists. Do you want to overwrite it?", Name),
					"Overwrite",
					function()
						Create(Name)
					end
				)
			end

			Create(Name)
		end,
	})

	Section:AddButton({
		Title = "Load profile",
		Description = "Apply the selected profile",
		Variant = "Tonal",
		ButtonText = "Load",
		ButtonIcon = "lucide:download",
		Callback = function()
			local Name = Selected()
			local Success, Problem = self:LoadProfile(Name)

			if not Success then
				return self:Notify("Failed to load", tostring(Problem))
			end

			self:Notify("Profile loaded", string.format("%q", Name))
		end,
	})

	Section:AddButton({
		Title = "Overwrite profile",
		Description = "Replace the selected profile with the current layout",
		Variant = "Outline",
		ButtonText = "Overwrite",
		ButtonIcon = "lucide:refresh-cw",
		Callback = function()
			local Name = Selected()

			if Util.IsBlank(Name) then
				return self:Notify("Failed to overwrite", "no profile selected")
			end

			self:Confirm(
				"Overwrite profile",
				string.format("Are you sure you want to overwrite %q with the current layout?", Name),
				"Overwrite",
				function()
					local Success, Problem = ProfileStore.Save(self, Name)
					if not Success then
						return self:Notify("Failed to overwrite", tostring(Problem))
					end

					self:Notify("Profile overwritten", string.format("%q", Name))
				end
			)
		end,
	})

	Section:AddButton({
		Title = "Delete profile",
		Description = "Delete the selected profile",
		Variant = "Danger",
		ButtonText = "Delete",
		ButtonIcon = "lucide:trash",
		Callback = function()
			local Name = Selected()

			if Util.IsBlank(Name) then
				return self:Notify("Failed to delete", "no profile selected")
			end

			self:Confirm(
				"Delete profile",
				string.format("Are you sure you want to delete %q? This cannot be undone.", Name),
				"Delete",
				function()
					ProfileStore.Delete(self, Name)
					self:Notify("Profile deleted", string.format("%q", Name))
					Refresh()
				end
			)
		end,
	})

	Section:AddButton({
		Title = "Refresh list",
		Variant = "Ghost",
		ButtonText = "Refresh",
		ButtonIcon = "lucide:rotate-cw",
		Callback = Refresh,
	})

	AutoloadButton = Section:AddButton({
		Title = "Set as autoload",
		Description = "Current autoload profile: none",
		Variant = "Accent",
		ButtonText = "Toggle",
		ButtonIcon = "lucide:rocket",
		Callback = function()
			local Name = Selected()
			local Current = ProfileStore.GetAutoload(self)

			if Current and (Util.IsBlank(Name) or Name == Current) then
				ProfileStore.SetAutoload(self, nil)
				DescribeAutoload()
				return self:Notify("Autoload disabled")
			end

			if Util.IsBlank(Name) then
				return self:Notify("Failed", "no profile selected")
			end

			if not ProfileStore.SetAutoload(self, Name) then
				return self:Notify("Failed", "could not write autoload file")
			end

			DescribeAutoload()
			self:Notify("Autoload set", string.format("%q", Name))
		end,
	})

	local Share = Tab:AddSection("Share and migrate", { Icon = "lucide:share" })

	Share:AddButton({
		Title = "Copy profile",
		Description = "Copy the selected profile as JSON to your clipboard",
		Variant = "Tonal",
		ButtonText = "Copy",
		ButtonIcon = "lucide:copy",
		Callback = function()
			local Name = Selected()

			if Util.IsBlank(Name) then
				return self:Notify("Failed to copy", "no profile selected")
			end

			local Success, Problem = ProfileStore.Export(self, Name)
			if not Success then
				return self:Notify("Failed to copy", tostring(Problem))
			end

			self:Notify("Profile copied", string.format("%q", Name))
		end,
	})

	Share:AddInput("HudProfileImport", {
		Title = "Profile JSON",
		Description = "Paste a copied profile, then press Import",
		Variant = "Field",
		Icon = "lucide:clipboard",
		Placeholder = "Paste JSON",
		Finished = false,
	})

	Share:AddButton({
		Title = "Import profile",
		Description = "Save the pasted JSON under the profile name above",
		Variant = "Primary",
		ButtonText = "Import",
		ButtonIcon = "lucide:file-input",
		Callback = function()
			local Success, Result = ProfileStore.ImportText(
				self,
				Library.Options.HudProfileName.Value,
				Library.Options.HudProfileImport.Value
			)

			if not Success then
				return self:Notify("Failed to import", tostring(Result))
			end

			self:Notify("Profile imported", Result .. " rules")
			Refresh()
		end,
	})

	Share:AddButton({
		Title = "Import legacy configs",
		Description = "Bring in saves made by the old Perfect UI Manager",
		Variant = "Outline",
		ButtonText = "Import",
		ButtonIcon = "lucide:history",
		Callback = function()
			local Count = ProfileStore.ImportLegacy(self)

			if Count == 0 then
				return self:Notify("Nothing imported", "no new legacy saves for this game")
			end

			self:Notify("Legacy configs imported", Count .. " profiles")
			Refresh()
		end,
	})

	DescribeAutoload()
	self:IgnoreSaveIndexes({ "HudEditMode", "HudProfileName", "HudProfileList", "HudProfileImport" })
end

function HUDManager:BuildSection(Tab)
	self.Tab = Tab
	self:BuildControlSection(Tab)
	self:BuildConfigSection(Tab)
	self:BuildProfileSection(Tab)
end

return HUDManager
