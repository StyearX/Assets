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
	ExtensionId = "HUDManager.Elements",
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
	FormatVersion = 2,
	LegacyFolder = "PerfectUIManager_Configs",
	NudgeSteps = { 1, 5, 10, 25 },
	Icons = {
		Edit = "tabler:pencil",
		Undo = "tabler:arrow-back-up",
		Redo = "tabler:arrow-forward-up",
		Save = "tabler:device-floppy",
		Panel = "tabler:layout-dashboard",
		Power = "tabler:power",
		Lock = "tabler:lock",
		Unlock = "tabler:lock-open",
		Plus = "tabler:plus",
		Minus = "tabler:minus",
		Reset = "tabler:refresh",
		Delete = "tabler:eye-off",
		Up = "tabler:arrow-up",
		Down = "tabler:arrow-down",
		Left = "tabler:arrow-left",
		Right = "tabler:arrow-right",
		Launcher = "tabler:adjustments-horizontal",
		Focus = "tabler:focus-2",
	},
	Glyphs = {
		Edit = "E",
		Undo = "<",
		Redo = ">",
		Save = "S",
		Panel = "P",
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
	return if Camera then Camera.ViewportSize else Vector2.new(1280, 720)
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

local RuleBook = {}
RuleBook.__index = RuleBook

function RuleBook.new()
	return setmetatable({
		Rules = {},
		Originals = {},
		Tracked = setmetatable({}, { __mode = "k" }),
		Hidden = setmetatable({}, { __mode = "k" }),
		Baked = setmetatable({}, { __mode = "k" }),
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

function RuleBook:Apply(Object, Key, Dragging)
	local Rule = self.Rules[Key]
	if not Rule or not Object.Parent then
		return
	end

	if Rule.IsDeleted then
		if Object.Visible then
			self.Hidden[Object] = true
			Object.Visible = false
		end
		return
	end

	if self.Hidden[Object] then
		self.Hidden[Object] = nil
		Object.Visible = true
	end

	if Dragging then
		return
	end

	if Object.Position ~= Rule.Position then
		Object.Position = Rule.Position
	end

	if Rule.SizeModified and Object.Size ~= Rule.Size then
		Object.Size = Rule.Size
	end
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

local ButtonStyles = {
	Subtle = { Background = "DropdownFrame", Transparency = 0.93, Text = "Text" },
	Tonal = { Background = "Accent", Transparency = 0.84, Text = "Text" },
	Primary = { Background = "FillButton", Transparency = 0, Text = "FillButtonText" },
	Active = { Background = "Accent", Transparency = 0, Text = "AccentText" },
	Danger = { Background = "Danger", Transparency = 0.82, Text = "Danger" },
	Success = { Background = "Success", Transparency = 0.82, Text = "Success" },
	Ghost = { Background = "DropdownFrame", Transparency = 1, Text = "SubText" },
}

local IconObject = {}
IconObject.__index = IconObject

local ButtonObject = {}
ButtonObject.__index = ButtonObject

function Kit.Bind(Library)
	Kit.Library = Library
	Kit.Creator = Library.Internals.Creator
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

function Kit.Panel(Config)
	return Kit.New("Frame", {
		Size = Config.Size,
		Position = Config.Position or UDim2.new(),
		AnchorPoint = Config.AnchorPoint or Vector2.zero,
		Visible = Config.Visible ~= false,
		Active = true,
		BackgroundTransparency = Config.Transparency or 0.04,
		ThemeTag = { BackgroundColor3 = Config.Background or "AcrylicMain" },
		Parent = Config.Parent,
	}, {
		Kit.Corner(Config.Radius or 14),
		Kit.New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Thickness = 1,
			Transparency = 0.35,
			ThemeTag = { Color = "AcrylicBorder" },
		}),
	})
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

	local Root = Kit.New("TextButton", {
		Text = "",
		AutoButtonColor = false,
		Size = Config.Size or UDim2.fromOffset(34, 34),
		Position = Config.Position or UDim2.new(),
		AnchorPoint = Config.AnchorPoint or Vector2.zero,
		LayoutOrder = Config.LayoutOrder or 0,
		BackgroundTransparency = Style.Transparency,
		ThemeTag = { BackgroundColor3 = Style.Background },
		Parent = Config.Parent,
	}, {
		Kit.Corner(Config.Radius or 8),
	})

	local Content = Kit.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = Root,
	}, {
		Kit.New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
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
		Label = Label,
		Icon = Icon,
		Style = Style,
		Enabled = true,
	}, ButtonObject)

	Root.MouseEnter:Connect(function()
		if Object.Enabled then
			local Goal = if Object.Style.Transparency >= 1 then 0.93 else math.max(Object.Style.Transparency - 0.05, 0)
			Kit.Creator.Tween(Root, 0.12, { BackgroundTransparency = Goal })
		end
	end)

	Root.MouseLeave:Connect(function()
		Kit.Creator.Tween(Root, 0.12, { BackgroundTransparency = Object.Style.Transparency })
	end)

	return Object
end

function ButtonObject:OnActivated(Callback)
	return self.Root.Activated:Connect(function()
		if self.Enabled then
			Callback()
		end
	end)
end

function ButtonObject:SetVariant(Name)
	local Style = ButtonStyles[Name] or ButtonStyles.Subtle
	self.Style = Style

	Kit.Retag(self.Root, { BackgroundColor3 = Style.Background })
	self.Root.BackgroundTransparency = Style.Transparency

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

function ButtonObject:SetEnabled(Enabled)
	self.Enabled = Enabled
	local Fade = if Enabled then 0 else 0.6

	if self.Label then
		self.Label.TextTransparency = Fade
	end

	if self.Icon then
		self.Icon.Image.ImageTransparency = Fade
		self.Icon.Glyph.TextTransparency = Fade
	end
end

function Kit.MakeDraggable(Handle, Target, Config)
	Config = Config or {}

	local State = { Input = nil, Origin = Vector3.zero, Start = UDim2.new(), Moved = false, Active = false }
	local Links = {}

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
			if not State.Moved and Vector2.new(Delta.X, Delta.Y).Magnitude < Constants.TapThreshold then
				return
			end

			State.Moved = true

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

local Overlay = {}
Overlay.__index = Overlay

function Overlay.new(Core)
	local Library = Core.Library

	pcall(Library.RemoveLayer, Library, Constants.OverlayLayer)
	pcall(Library.RemoveLayer, Library, Constants.ShieldLayer)

	local Self = setmetatable({
		Core = Core,
		Releases = {},
		ClusterBoxes = {},
		PendingConfirm = nil,
	}, Overlay)

	Self.ShieldLayer = Library:CreateLayer(Constants.ShieldLayer, Constants.ShieldOrder)
	Self.Layer = Library:CreateLayer(Constants.OverlayLayer, Constants.OverlayOrder)

	Self:BuildShield()
	Self:BuildSelection()
	Self:BuildLauncher()
	Self:BuildDock()
	Self:BuildActionBar()
	Self:BuildConfirm()

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
end

function Overlay:CreateBox(Primary)
	return Kit.New("Frame", {
		BackgroundTransparency = if Primary then 0.9 else 1,
		Active = false,
		Visible = false,
		ThemeTag = { BackgroundColor3 = "Info" },
		Parent = self.Layer,
	}, {
		Kit.New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Thickness = if Primary then 2 else 1,
			Transparency = if Primary then 0 else 0.4,
			ThemeTag = { Color = "Info" },
		}),
	})
end

function Overlay:BuildSelection()
	self.PrimaryBox = self:CreateBox(true)
end

function Overlay:PlaceBox(Box, Object)
	local Position = Object.AbsolutePosition
	local Size = Object.AbsoluteSize

	Box.Position = UDim2.fromOffset(Position.X, Position.Y)
	Box.Size = UDim2.fromOffset(Size.X, Size.Y)
	Box.Visible = true
end

function Overlay:Reflect(Session)
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

	self.Launcher = Kit.Panel({
		Size = UDim2.fromOffset(46, 46),
		Position = UDim2.new(1, -62, 0.5, -23),
		Radius = 23,
		Visible = Core.Settings.ShowLauncher,
		Parent = self.Layer,
	})

	local Icon = Kit.Icon({
		Parent = self.Launcher,
		Name = Constants.Icons.Launcher,
		Fallback = Constants.Glyphs.Launcher,
		Size = 20,
	})
	Icon.Root.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.Root.Position = UDim2.fromScale(0.5, 0.5)

	table.insert(
		self.Releases,
		Kit.MakeDraggable(self.Launcher, self.Launcher, {
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

	self.Dock = Kit.Panel({
		Size = UDim2.fromOffset(188, 0),
		Position = UDim2.new(0, 12, 0.5, -130),
		Visible = false,
		Parent = self.Layer,
	})
	self.Dock.AutomaticSize = Enum.AutomaticSize.Y

	Kit.New("UIPadding", {
		PaddingTop = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		Parent = self.Dock,
	})

	Kit.New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6),
		Parent = self.Dock,
	})

	local Header = Kit.New("Frame", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Parent = self.Dock,
	})

	Kit.Label({
		Parent = Header,
		Text = "HUD Manager",
		Size = UDim2.new(1, 0, 0, 18),
		Weight = "SemiBold",
		TextSize = 13,
	})

	self.DockStatus = Kit.Label({
		Parent = Header,
		Text = "Edit mode off",
		Position = UDim2.fromOffset(0, 18),
		Size = UDim2.new(1, 0, 0, 14),
		TextSize = 11,
		Tag = "SubText",
		Weight = "Regular",
	})

	table.insert(self.Releases, Kit.MakeDraggable(Header, self.Dock))

	self.EditButton = Kit.Button({
		Parent = self.Dock,
		Text = "Edit mode",
		Icon = Constants.Icons.Edit,
		Fallback = Constants.Glyphs.Edit,
		Size = UDim2.new(1, 0, 0, 34),
		LayoutOrder = 2,
	})
	self.EditButton:OnActivated(function()
		Core:SetEditMode(not Core.Session.EditMode)
	end)

	local HistoryRow = Kit.New("Frame", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Parent = self.Dock,
	}, {
		Kit.New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
		}),
	})

	self.UndoButton = Kit.Button({
		Parent = HistoryRow,
		Text = "Undo",
		Icon = Constants.Icons.Undo,
		Fallback = Constants.Glyphs.Undo,
		Size = UDim2.new(0.5, -3, 1, 0),
		LayoutOrder = 1,
	})
	self.UndoButton:OnActivated(function()
		Core:Undo()
	end)

	self.RedoButton = Kit.Button({
		Parent = HistoryRow,
		Text = "Redo",
		Icon = Constants.Icons.Redo,
		Fallback = Constants.Glyphs.Redo,
		Size = UDim2.new(0.5, -3, 1, 0),
		LayoutOrder = 2,
	})
	self.RedoButton:OnActivated(function()
		Core:Redo()
	end)

	local SaveButton = Kit.Button({
		Parent = self.Dock,
		Text = "Quick save",
		Icon = Constants.Icons.Save,
		Fallback = Constants.Glyphs.Save,
		Size = UDim2.new(1, 0, 0, 34),
		LayoutOrder = 4,
	})
	SaveButton:OnActivated(function()
		Core:QuickSave()
	end)

	local PanelButton = Kit.Button({
		Parent = self.Dock,
		Text = "Open panel",
		Icon = Constants.Icons.Panel,
		Fallback = Constants.Glyphs.Panel,
		Size = UDim2.new(1, 0, 0, 34),
		LayoutOrder = 5,
	})
	PanelButton:OnActivated(function()
		Core:ToggleWindow()
	end)

	local RemoveButton = Kit.Button({
		Parent = self.Dock,
		Text = "Remove HUD",
		Icon = Constants.Icons.Power,
		Fallback = Constants.Glyphs.Power,
		Variant = "Danger",
		Size = UDim2.new(1, 0, 0, 34),
		LayoutOrder = 6,
	})
	RemoveButton:OnActivated(function()
		self:Confirm({
			Title = "Remove HUD Manager",
			Content = "The overlay and editor will be removed. Your current layout stays until you rejoin.",
			ConfirmText = "Remove",
			Danger = true,
			OnConfirm = function()
				Core:Destroy(false)
			end,
		})
	end)

	self:SetHistoryState(false, false)
end

function Overlay:BuildActionBar()
	local Core = self.Core

	self.ActionBar = Kit.Panel({
		Size = UDim2.fromOffset(268, 82),
		Position = UDim2.new(0.5, -134, 0.12, 0),
		Radius = 16,
		Visible = false,
		Parent = self.Layer,
	})

	local Grip = Kit.New("Frame", {
		Size = UDim2.new(1, -16, 0, 24),
		Position = UDim2.fromOffset(8, 6),
		BackgroundTransparency = 1,
		Parent = self.ActionBar,
	})

	self.SelectionLabel = Kit.Label({
		Parent = Grip,
		Text = "Tap an element to select it",
		Size = UDim2.fromScale(1, 1),
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Center,
		Tag = "SubText",
	})

	table.insert(
		self.Releases,
		Kit.MakeDraggable(Grip, self.ActionBar, {
			IsLocked = function()
				return Core.Session.BarLocked
			end,
		})
	)

	local Row = Kit.New("Frame", {
		Size = UDim2.new(1, -16, 0, 38),
		Position = UDim2.fromOffset(8, 36),
		BackgroundTransparency = 1,
		Parent = self.ActionBar,
	}, {
		Kit.New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 6),
		}),
	})

	local function AddAction(Order, Icon, Fallback, Variant)
		return Kit.Button({
			Parent = Row,
			Icon = Icon,
			Fallback = Fallback,
			Variant = Variant,
			Size = UDim2.new(0.2, -4.8, 1, 0),
			LayoutOrder = Order,
		})
	end

	self.LockButton = AddAction(1, Constants.Icons.Unlock, Constants.Glyphs.Unlock)
	self.LockButton:OnActivated(function()
		Core:SetBarLocked(not Core.Session.BarLocked)
	end)

	AddAction(2, Constants.Icons.Minus, Constants.Glyphs.Minus):OnActivated(function()
		Core:Resize(-Core.Settings.ResizeStep)
	end)

	AddAction(3, Constants.Icons.Plus, Constants.Glyphs.Plus):OnActivated(function()
		Core:Resize(Core.Settings.ResizeStep)
	end)

	AddAction(4, Constants.Icons.Reset, Constants.Glyphs.Reset):OnActivated(function()
		Core:ResetSelected()
	end)

	AddAction(5, Constants.Icons.Delete, Constants.Glyphs.Delete, "Danger"):OnActivated(function()
		Core:DeleteSelected()
	end)
end

function Overlay:BuildConfirm()
	self.ConfirmDim = Kit.New("TextButton", {
		Size = UDim2.fromScale(1, 1),
		Text = "",
		AutoButtonColor = false,
		Active = true,
		Visible = false,
		ZIndex = 50,
		BackgroundTransparency = 0.46,
		ThemeTag = { BackgroundColor3 = "Overlay" },
		Parent = self.Layer,
	})

	local Panel = Kit.Panel({
		Size = UDim2.fromOffset(300, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Background = "DialogHolder",
		Transparency = 0,
		Parent = self.ConfirmDim,
	})
	Panel.AutomaticSize = Enum.AutomaticSize.Y

	Kit.New("UIPadding", {
		PaddingTop = UDim.new(0, 16),
		PaddingBottom = UDim.new(0, 16),
		PaddingLeft = UDim.new(0, 16),
		PaddingRight = UDim.new(0, 16),
		Parent = Panel,
	})

	Kit.New("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		Parent = Panel,
	})

	self.ConfirmTitle = Kit.Label({
		Parent = Panel,
		Text = "",
		Size = UDim2.new(1, 0, 0, 20),
		Weight = "SemiBold",
		TextSize = 15,
		LayoutOrder = 1,
	})

	self.ConfirmBody = Kit.Label({
		Parent = Panel,
		Text = "",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		Tag = "SubText",
		Weight = "Regular",
		LayoutOrder = 2,
	})

	local Row = Kit.New("Frame", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Parent = Panel,
	}, {
		Kit.New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
		}),
	})

	self.ConfirmAccept = Kit.Button({
		Parent = Row,
		Text = "Confirm",
		Variant = "Danger",
		Size = UDim2.new(0.5, -4, 1, 0),
		LayoutOrder = 1,
	})
	self.ConfirmAccept:OnActivated(function()
		self:ResolveConfirm(true)
	end)

	local Cancel = Kit.Button({
		Parent = Row,
		Text = "Cancel",
		Size = UDim2.new(0.5, -4, 1, 0),
		LayoutOrder = 2,
	})
	Cancel:OnActivated(function()
		self:ResolveConfirm(false)
	end)
end

function Overlay:Confirm(Config)
	self.ConfirmTitle.Text = Config.Title or "Confirm"
	self.ConfirmBody.Text = Config.Content or ""
	self.ConfirmAccept:SetText(Config.ConfirmText or "Confirm")
	self.ConfirmAccept:SetVariant(if Config.Danger then "Danger" else "Primary")
	self.PendingConfirm = Config.OnConfirm
	self.ConfirmDim.BackgroundTransparency = Kit.Creator.GetThemeProperty("OverlayTransparency") or 0.46
	self.ConfirmDim.Visible = true
end

function Overlay:ResolveConfirm(Accepted)
	local Callback = self.PendingConfirm
	self.PendingConfirm = nil
	self.ConfirmDim.Visible = false

	if Accepted and Callback then
		task.spawn(Callback)
	end
end

function Overlay:IsConfirmOpen()
	return self.ConfirmDim.Visible
end

function Overlay:ToggleDock()
	self.Dock.Visible = not self.Dock.Visible

	if not self.Dock.Visible then
		self.Core:SetEditMode(false)
	end
end

function Overlay:SetLauncherVisible(Visible)
	self.Launcher.Visible = Visible

	if not Visible and not self.Core.Session.EditMode then
		self.Dock.Visible = false
	end
end

function Overlay:SetEditState(Enabled)
	self.Shield.Visible = Enabled
	self.Shield.Active = Enabled
	self.ActionBar.Visible = Enabled
	self.EditButton:SetVariant(if Enabled then "Active" else "Subtle")
	self.EditButton:SetText(if Enabled then "Edit mode: on" else "Edit mode")
	self.DockStatus.Text = if Enabled then "Edit mode on" else "Edit mode off"

	if not Enabled then
		self:SetSelection(nil)
	end
end

function Overlay:SetBarLocked(Locked)
	self.LockButton:SetVariant(if Locked then "Active" else "Subtle")
	self.LockButton:SetIcon(
		if Locked then Constants.Icons.Lock else Constants.Icons.Unlock,
		if Locked then Constants.Glyphs.Lock else Constants.Glyphs.Unlock
	)
end

function Overlay:SetHistoryState(CanUndo, CanRedo)
	self.UndoButton:SetEnabled(CanUndo)
	self.RedoButton:SetEnabled(CanRedo)
end

function Overlay:SetSelection(Object)
	if Object and Object.Parent then
		self.SelectionLabel.Text = string.format(
			"%s  |  %.0f x %.0f",
			Object.Name,
			Object.AbsoluteSize.X,
			Object.AbsoluteSize.Y
		)
		Kit.Retag(self.SelectionLabel, { TextColor3 = "Text" })
	else
		self.SelectionLabel.Text = "Tap an element to select it"
		Kit.Retag(self.SelectionLabel, { TextColor3 = "SubText" })
	end
end

function Overlay:IsInterfaceHit(Position)
	if self.ConfirmDim.Visible then
		return true
	end

	local Raw = Vector2.new(Position.X, Position.Y)
	local Shifted = Raw + GuiService:GetGuiInset()
	local Targets = { self.Launcher, self.Dock, self.ActionBar }

	local Window = self.Core.Library.Window
	if Window and Window.Root and Window.Root.Visible then
		table.insert(Targets, Window.Root)
	end

	for _, Gui in Targets do
		if Gui.Visible and (Util.PointInGui(Shifted, Gui) or Util.PointInGui(Raw, Gui)) then
			return true
		end
	end

	return false
end

function Overlay:Destroy()
	for _, Release in self.Releases do
		Release()
	end
	table.clear(self.Releases)

	local Library = self.Core.Library
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

function Enforcer.Step(Core)
	local Session = Core.Session
	Core.Overlay:Reflect(Session)

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

			Book:Apply(Object, Key, Session.DragSet[Object] == true)
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

local Elements = {}

function Elements.Repeater(Context, Button, Action)
	local Token = 0

	Button.Root.InputBegan:Connect(function(Input)
		if not Util.IsPointer(Input) or not Button.Enabled then
			return
		end

		Token += 1
		local Current = Token

		Action()

		task.delay(Constants.RepeatDelay, function()
			while Token == Current and Context.Alive do
				Action()
				task.wait(Constants.RepeatInterval)
			end
		end)

		local Ended
		Ended = Input.Changed:Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then
				Token += 1
				Ended:Disconnect()
			end
		end)
	end)
end

function Elements.Status(Core)
	return {
		NoIdx = true,
		Defaults = {
			Title = "Overview",
			Description = "Live summary of the HUD layout",
		},
		Build = function(Context)
			local Strip = Context:Below(Context:Frame({ BackgroundTransparency = 1 }), 58, 8)
			Context:List(Strip, Enum.FillDirection.Horizontal, 6)

			local Values = {}
			local Captions = { "Total", "Hidden", "Moved", "History" }

			for Index, Caption in Captions do
				local Tile = Kit.New("Frame", {
					Size = UDim2.new(0.25, -4.5, 1, 0),
					BackgroundTransparency = 0.94,
					LayoutOrder = Index,
					ThemeTag = { BackgroundColor3 = "DropdownFrame" },
					Parent = Strip,
				}, {
					Kit.Corner(10),
				})

				Values[Caption] = Kit.Label({
					Parent = Tile,
					Text = "0",
					Position = UDim2.fromOffset(12, 8),
					Size = UDim2.new(1, -24, 0, 24),
					TextSize = 18,
					Weight = "Bold",
				})

				Kit.Label({
					Parent = Tile,
					Text = Caption,
					Position = UDim2.fromOffset(12, 33),
					Size = UDim2.new(1, -24, 0, 14),
					TextSize = 11,
					Tag = "SubText",
					Weight = "Regular",
				})
			end

			local function Refresh()
				if not Context.Alive then
					return
				end

				local Counts = Core.Book:Counts()
				Values.Total.Text = tostring(Counts.Total)
				Values.Hidden.Text = tostring(Counts.Hidden)
				Values.Moved.Text = tostring(Counts.Moved)
				Values.History.Text = tostring(#Core.History.Undos)

				local State = if Core.Session.EditMode then "Edit mode on" else "Edit mode off"
				Context.Row:SetDesc(State .. "  |  " .. Counts.Resized .. " resized")
			end

			Context:Signal(Core.Book.Changed, Refresh)
			Context:Signal(Core.History.Changed, Refresh)
			Context:Signal(Core.Signals.StateChanged, Refresh)
			Refresh()

			return { Refresh = Refresh }
		end,
	}
end

function Elements.NudgePad(Core)
	return {
		Save = true,
		Defaults = {
			Title = "Precision pad",
			Description = "Move, resize or hide the selected element",
			Default = 5,
		},
		Build = function(Context)
			local Body = Context:Below(Context:Frame({ BackgroundTransparency = 1 }), 104, 8)

			local Pad = {}
			Pad.Value = if table.find(Constants.NudgeSteps, Context.Config.Default) then Context.Config.Default else 5

			local StepButtons = {}

			local function PaintSteps()
				for Step, Button in StepButtons do
					Button:SetVariant(if Step == Pad.Value then "Active" else "Subtle")
				end
			end

			function Pad:SetValue(Step, Silent)
				if not table.find(Constants.NudgeSteps, Step) then
					return
				end

				Pad.Value = Step
				Core.Settings.NudgeStep = Step
				PaintSteps()

				if not Silent then
					Context:Fire(Step)
				end
			end

			local Directions = {
				{ Column = 1, Line = 0, Icon = "Up", X = 0, Y = -1 },
				{ Column = 0, Line = 1, Icon = "Left", X = -1, Y = 0 },
				{ Column = 2, Line = 1, Icon = "Right", X = 1, Y = 0 },
				{ Column = 1, Line = 2, Icon = "Down", X = 0, Y = 1 },
			}

			for _, Direction in Directions do
				local Button = Kit.Button({
					Parent = Body,
					Icon = Constants.Icons[Direction.Icon],
					Fallback = Constants.Glyphs[Direction.Icon],
					Size = UDim2.fromOffset(30, 30),
					Position = UDim2.fromOffset(Direction.Column * 34, Direction.Line * 34),
					IconSize = 14,
					Radius = 8,
				})

				Elements.Repeater(Context, Button, function()
					Core:Nudge(Direction.X * Pad.Value, Direction.Y * Pad.Value)
				end)
			end

			local Center = Kit.Button({
				Parent = Body,
				Icon = Constants.Icons.Reset,
				Fallback = Constants.Glyphs.Reset,
				Variant = "Tonal",
				Size = UDim2.fromOffset(30, 30),
				Position = UDim2.fromOffset(34, 34),
				IconSize = 14,
				Radius = 8,
			})
			Center:OnActivated(function()
				Core:ResetSelected()
			end)

			local Side = Kit.New("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(120, 0),
				Size = UDim2.new(1, -120, 1, 0),
				Parent = Body,
			})

			Kit.Label({
				Parent = Side,
				Text = "Step in pixels",
				Size = UDim2.new(1, 0, 0, 14),
				TextSize = 11,
				Tag = "SubText",
				Weight = "Regular",
			})

			local StepRow = Kit.New("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, 18),
				Size = UDim2.new(1, 0, 0, 28),
				Parent = Side,
			}, {
				Kit.New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 6),
				}),
			})

			for Index, Step in Constants.NudgeSteps do
				local Button = Kit.Button({
					Parent = StepRow,
					Text = tostring(Step),
					Size = UDim2.fromOffset(54, 28),
					LayoutOrder = Index,
				})
				Button:OnActivated(function()
					Pad:SetValue(Step)
				end)
				StepButtons[Step] = Button
			end

			Kit.Label({
				Parent = Side,
				Text = "Size and visibility",
				Position = UDim2.fromOffset(0, 54),
				Size = UDim2.new(1, 0, 0, 14),
				TextSize = 11,
				Tag = "SubText",
				Weight = "Regular",
			})

			local ActionRow = Kit.New("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, 72),
				Size = UDim2.new(1, 0, 0, 28),
				Parent = Side,
			}, {
				Kit.New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 6),
				}),
			})

			local Smaller = Kit.Button({
				Parent = ActionRow,
				Text = "Smaller",
				Icon = Constants.Icons.Minus,
				Fallback = Constants.Glyphs.Minus,
				Size = UDim2.fromOffset(84, 28),
				IconSize = 12,
				LayoutOrder = 1,
			})
			Elements.Repeater(Context, Smaller, function()
				Core:Resize(-Core.Settings.ResizeStep)
			end)

			local Larger = Kit.Button({
				Parent = ActionRow,
				Text = "Larger",
				Icon = Constants.Icons.Plus,
				Fallback = Constants.Glyphs.Plus,
				Size = UDim2.fromOffset(84, 28),
				IconSize = 12,
				LayoutOrder = 2,
			})
			Elements.Repeater(Context, Larger, function()
				Core:Resize(Core.Settings.ResizeStep)
			end)

			local Hide = Kit.Button({
				Parent = ActionRow,
				Text = "Hide",
				Icon = Constants.Icons.Delete,
				Fallback = Constants.Glyphs.Delete,
				Variant = "Danger",
				Size = UDim2.fromOffset(84, 28),
				IconSize = 12,
				LayoutOrder = 3,
			})
			Hide:OnActivated(function()
				Core:DeleteSelected()
			end)

			PaintSteps()
			Core.Settings.NudgeStep = Pad.Value

			return Pad
		end,
	}
end

function Elements.RuleList(Core)
	return {
		NoIdx = true,
		Defaults = {
			Title = "Modified elements",
			Description = "Everything you moved, resized or hid",
			Height = 240,
		},
		Build = function(Context)
			local Body = Context:Below(Context:Frame({ BackgroundTransparency = 1 }), Context.Config.Height, 8)

			local Filter = "All"
			local Filters = { "All", "Hidden", "Moved", "Resized" }
			local FilterButtons = {}
			local Rows = {}

			local FilterRow = Kit.New("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 28),
				Parent = Body,
			}, {
				Kit.New("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 6),
				}),
			})

			local List = Kit.New("ScrollingFrame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(0, 36),
				Size = UDim2.new(1, 0, 1, -36),
				ScrollBarThickness = 3,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(),
				ThemeTag = { ScrollBarImageColor3 = "ScrollBar" },
				Parent = Body,
			}, {
				Kit.New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4),
				}),
			})

			local Empty = Kit.Label({
				Parent = List,
				Text = "No elements match this filter",
				Size = UDim2.new(1, 0, 0, 30),
				TextXAlignment = Enum.TextXAlignment.Center,
				Tag = "SubText",
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

			local function Clear()
				for _, Row in Rows do
					Row:Destroy()
				end
				table.clear(Rows)
			end

			local function CreateRow(Key, Rule, Order)
				local Row = Kit.New("Frame", {
					Size = UDim2.new(1, -6, 0, 40),
					BackgroundTransparency = 0.94,
					LayoutOrder = Order,
					ThemeTag = { BackgroundColor3 = "DropdownFrame" },
					Parent = List,
				}, {
					Kit.Corner(8),
				})

				Kit.Label({
					Parent = Row,
					Text = Rule.Name,
					Position = UDim2.fromOffset(10, 4),
					Size = UDim2.new(1, -84, 0, 16),
					TextTruncate = Enum.TextTruncate.AtEnd,
					Weight = "SemiBold",
				})

				Kit.Label({
					Parent = Row,
					Text = Describe(Rule),
					Position = UDim2.fromOffset(10, 21),
					Size = UDim2.new(1, -84, 0, 14),
					TextSize = 11,
					Tag = if Rule.IsDeleted then "Danger" else "SubText",
					Weight = "Regular",
				})

				local Restore = Kit.Button({
					Parent = Row,
					Icon = Constants.Icons.Reset,
					Fallback = Constants.Glyphs.Reset,
					Size = UDim2.fromOffset(28, 28),
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
						Variant = "Tonal",
						Size = UDim2.fromOffset(28, 28),
						AnchorPoint = Vector2.new(1, 0.5),
						Position = UDim2.new(1, -40, 0.5, 0),
						IconSize = 14,
						Radius = 7,
					})
					Focus:OnActivated(function()
						Core:FocusKey(Key)
					end)
				end

				table.insert(Rows, Row)
			end

			local function Rebuild()
				if not Context.Alive then
					return
				end

				Clear()

				local Order = 0
				for _, Key in Util.SortedKeys(Core.Book.Rules) do
					local Rule = Core.Book.Rules[Key]
					if Matches(Rule) then
						Order += 1
						CreateRow(Key, Rule, Order)
					end
				end

				Empty.Visible = Order == 0
			end

			local Pending = false
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

			for Index, Name in Filters do
				local Button = Kit.Button({
					Parent = FilterRow,
					Text = Name,
					Size = UDim2.fromOffset(74, 28),
					Variant = if Name == Filter then "Active" else "Subtle",
					LayoutOrder = Index,
				})
				Button:OnActivated(function()
					Filter = Name
					for Other, OtherButton in FilterButtons do
						OtherButton:SetVariant(if Other == Filter then "Active" else "Subtle")
					end
					Schedule()
				end)
				FilterButtons[Name] = Button
			end

			Context:Signal(Core.Book.Changed, Schedule)
			Rebuild()

			return { Refresh = Rebuild }
		end,
	}
end

function Elements.ScreenMap(Core)
	return {
		NoIdx = true,
		Defaults = {
			Title = "Screen map",
			Description = "Blue is selected, gray is moved, red is hidden. Tap a block to focus it",
			Height = 170,
		},
		Build = function(Context)
			local Body = Context:Below(Context:Frame({ BackgroundTransparency = 1 }), Context.Config.Height, 8)
			local Viewport = Util.GetViewport()

			local Surface = Kit.New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				ClipsDescendants = true,
				BackgroundTransparency = 0.2,
				ThemeTag = { BackgroundColor3 = "AcrylicMain" },
				Parent = Body,
			}, {
				Kit.Corner(8),
				Kit.New("UIAspectRatioConstraint", {
					AspectRatio = Viewport.X / math.max(Viewport.Y, 1),
					DominantAxis = Enum.DominantAxis.Height,
					AspectType = Enum.AspectType.FitWithinMaxSize,
				}),
				Kit.New("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Thickness = 1,
					Transparency = 0.7,
					ThemeTag = { Color = "ElementBorder" },
				}),
			})

			local Boxes = {}
			local Kinds = {}

			local Palette = {
				Selected = { Background = "Info", Transparency = 0.55 },
				Moved = { Background = "Accent", Transparency = 0.75 },
				Hidden = { Background = "Danger", Transparency = 0.7 },
			}

			local function Paint(Box, Kind)
				if Kinds[Box] == Kind then
					return
				end

				Kinds[Box] = Kind
				Kit.Retag(Box, { BackgroundColor3 = Palette[Kind].Background })
				Box.BackgroundTransparency = Palette[Kind].Transparency
			end

			local function Draw(Object, Kind, Screen, Seen)
				if not Object.Parent or Seen[Object] then
					return
				end

				Seen[Object] = true

				local Box = Boxes[Object]
				if not Box then
					Box = Kit.New("TextButton", {
						Text = "",
						AutoButtonColor = false,
						BorderSizePixel = 0,
						Parent = Surface,
						ThemeTag = { BackgroundColor3 = Palette[Kind].Background },
					})
					Box.Activated:Connect(function()
						Core:FocusObject(Object)
					end)
					Boxes[Object] = Box
				end

				Paint(Box, Kind)

				local Position = Object.AbsolutePosition
				local Size = Object.AbsoluteSize

				Box.Position = UDim2.fromScale(Position.X / Screen.X, Position.Y / Screen.Y)
				Box.Size = UDim2.fromScale(math.max(Size.X / Screen.X, 0.008), math.max(Size.Y / Screen.Y, 0.008))
			end

			local function Sync()
				local Screen = Core.Library.GUI.AbsoluteSize
				if Screen.X <= 0 or Screen.Y <= 0 then
					return
				end

				local Seen = {}
				local Session = Core.Session

				if Session.Selected then
					Draw(Session.Selected, "Selected", Screen, Seen)
				end

				for _, Member in Session.Cluster do
					Draw(Member, "Selected", Screen, Seen)
				end

				for Object, Key in Core.Book.Tracked do
					local Rule = Core.Book.Rules[Key]
					if Rule then
						Draw(Object, if Rule.IsDeleted then "Hidden" else "Moved", Screen, Seen)
					end
				end

				for Object, Box in Boxes do
					if not Seen[Object] then
						Box:Destroy()
						Boxes[Object] = nil
						Kinds[Box] = nil
					end
				end
			end

			local Elapsed = 0
			Context:Signal(RunService.Heartbeat, function(Delta)
				Elapsed += Delta
				if Elapsed < Constants.MapInterval then
					return
				end

				Elapsed = 0

				local Window = Core.Library.Window
				if not Surface:IsDescendantOf(game) or (Window and Window.Root and not Window.Root.Visible) then
					return
				end

				Sync()
			end)

			Sync()

			return { Refresh = Sync }
		end,
	}
end

function Elements.Register(Core)
	local Record = Core.Extension:Define({
		Id = Constants.ExtensionId,
		Name = "HUD Manager Elements",
		Version = Constants.Version,
		Author = "HUD Manager",
		Description = "Status, precision pad, rule list and screen map elements for the HUD editor",
		Tags = { "hud", "editor" },
		Load = function(Api)
			Api:Element("HudStatus", Elements.Status(Core))
			Api:Element("HudNudgePad", Elements.NudgePad(Core))
			Api:Element("HudRuleList", Elements.RuleList(Core))
			Api:Element("HudScreenMap", Elements.ScreenMap(Core))

			return { Version = Constants.Version }
		end,
	})

	assert(Record.State == "Enabled", "HUDManager - element extension failed: " .. tostring(Record.Error))
	return Record
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
HUDManager.Signals = {
	StateChanged = Signal.new(),
	SelectionChanged = Signal.new(),
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
	assert(self.Extension, "HUDManager - Extension is not set, call SetExtension first")

	Kit.Bind(self.Library)

	self.Book = RuleBook.new()
	self.History = History.new(Constants.HistoryLimit)
	self.Session = NewSession()
	self.Connections = {}
	self.Started = true

	self:BuildFolderTree()

	self.Overlay = Overlay.new(self)
	self.ExtensionRecord = Elements.Register(self)

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
	RunService:BindToRenderStep(Constants.RenderStepName, Constants.RenderPriority, function()
		Enforcer.Step(self)
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

	pcall(function()
		self.Extension:Remove(Constants.ExtensionId)
	end)

	self.Session = NewSession()
	self.Signals.StateChanged:Fire(false)
end

function HUDManager:OnInputBegan(Input)
	if not Util.IsPointer(Input) or not self.Session.EditMode then
		return
	end

	if self.Overlay:IsConfirmOpen() or self.Overlay:IsInterfaceHit(Input.Position) then
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

function HUDManager:OnInputChanged(Input)
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

	local Toggle = self.Library.Options.HudEditMode
	if Toggle and Toggle.Value ~= Enabled then
		Toggle:SetValue(Enabled)
	end
end

function HUDManager:SetBarLocked(Locked)
	self.Session.BarLocked = Locked
	self.Overlay:SetBarLocked(Locked)
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

	for _, Object in Session.Cluster do
		local Key = KeyResolver.Resolve(Object)
		Session.DragBefore[Key] = self.Book:Snapshot(Key)

		local Rule = self.Book:Ensure(Object, Key)
		Session.DragStart[Object] = Rule.Position
		Session.DragKeys[Object] = Key
		Session.DragSet[Object] = true
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

function HUDManager:Mutate(Label, Mutator, Merge)
	if not self:RequireSelection() or self.Session.DragInput then
		return false
	end

	local Changes = {}

	for _, Object in self.Session.Cluster do
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

	if #Changes == 0 then
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
		return true
	end, true)
end

function HUDManager:DeleteSelected()
	local Done = self:Mutate("Hide", function(Rule)
		Rule.IsDeleted = true
		return true
	end)

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

function HUDManager:ToggleWindow()
	local Window = self.Library.Window
	if Window then
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

function HUDManager:BuildEditorSection(Tab)
	self:Start()

	local Library = self.Library
	local Settings = self.Settings
	local Section = Tab:AddSection("HUD editor", { Icon = "tabler:pencil" })

	Section:AddToggle("HudEditMode", {
		Title = "Edit mode",
		Description = "Tap, drag, resize or hide any on-screen UI",
		Icon = "tabler:pencil",
		Default = false,
		Callback = function(Value)
			self:SetEditMode(Value)
		end,
	})

	Section:AddHudStatus({ Title = "Overview" })

	Section:AddButton({
		Title = "Undo",
		Description = "Revert the last change",
		Variant = "Tonal",
		ButtonText = "Undo",
		ButtonIcon = "tabler:arrow-back-up",
		Callback = function()
			self:Undo()
		end,
	})

	Section:AddButton({
		Title = "Redo",
		Description = "Re-apply the change you just undid",
		Variant = "Tonal",
		ButtonText = "Redo",
		ButtonIcon = "tabler:arrow-forward-up",
		Callback = function()
			self:Redo()
		end,
	})

	Section:AddHudNudgePad("HudNudgePad", {
		Title = "Precision pad",
		Description = "Move, resize or hide the selected element",
		Default = Settings.NudgeStep,
	})

	Section:AddButton({
		Title = "Reset everything",
		Description = "Put every modified element back where it was",
		Variant = "Danger",
		ButtonText = "Reset all",
		ButtonIcon = "tabler:trash",
		Callback = function()
			if self.Book:Counts().Total == 0 then
				return self:Toast("There is nothing to reset")
			end

			self:Confirm("Reset everything", "Every moved, resized or hidden element goes back to its original state.", "Reset", function()
				self:ResetAll()
			end)
		end,
	})

	local Behavior = Tab:AddSection("Behavior", { Icon = "tabler:adjustments" })

	Behavior:AddToggle("HudShowLauncher", {
		Title = "Floating launcher",
		Description = "Show the draggable button that opens the on-screen dock",
		Icon = "tabler:circle-dot",
		Default = Settings.ShowLauncher,
		Callback = function(Value)
			Settings.ShowLauncher = Value
			if self.Overlay then
				self.Overlay:SetLauncherVisible(Value)
			end
		end,
	})

	Behavior:AddToggle("HudGroupCluster", {
		Title = "Move linked elements together",
		Description = "Elements that share the same center are edited as one",
		Icon = "tabler:link",
		Default = Settings.GroupCluster,
		Callback = function(Value)
			Settings.GroupCluster = Value
		end,
	})

	Behavior:AddSegmented("HudSelectionMode", {
		Title = "Selection mode",
		Description = "Smart climbs to the whole button, Exact picks the layer you tapped",
		Options = { "Smart", "Exact" },
		Default = Settings.SelectionMode,
		Callback = function(Value)
			Settings.SelectionMode = Value
		end,
	})

	Behavior:AddSegmented("HudAxis", {
		Title = "Drag axis",
		Description = "Restrict dragging to a single direction",
		Options = { "Free", "Horizontal", "Vertical" },
		Default = Settings.Axis,
		Callback = function(Value)
			Settings.Axis = Value
		end,
	})

	Behavior:AddSlider("HudResizeStep", {
		Title = "Resize step",
		Description = "Pixels added or removed by the size buttons",
		Icon = "tabler:arrows-maximize",
		Min = 1,
		Max = 50,
		Default = Settings.ResizeStep,
		Rounding = 0,
		Suffix = " px",
		Callback = function(Value)
			Settings.ResizeStep = Value
		end,
	})

	Behavior:AddSlider("HudSnapSize", {
		Title = "Snap to grid",
		Description = "Round drag distance to this many pixels, 0 turns it off",
		Icon = "tabler:grid-dots",
		Min = 0,
		Max = 50,
		Default = Settings.SnapSize,
		Rounding = 0,
		Suffix = " px",
		Callback = function(Value)
			Settings.SnapSize = Value
		end,
	})

	Behavior:AddSegmented("HudLoadMode", {
		Title = "Profile loading",
		Description = "Replace restores everything first, Merge keeps current changes",
		Options = { "Replace", "Merge" },
		Default = Settings.LoadMode,
		Callback = function(Value)
			Settings.LoadMode = Value
		end,
	})

	self:IgnoreSaveIndexes({ "HudEditMode" })
	return Library.Options.HudEditMode
end

function HUDManager:BuildProfileSection(Tab)
	self:Start()

	local Library = self.Library
	local Section = Tab:AddSection("HUD profiles", { Icon = "tabler:folder" })
	local AutoloadButton

	Section:AddInput("HudProfileName", {
		Title = "Profile name",
		Description = "Name for a new profile",
		Variant = "Field",
		Icon = "feather:edit-2",
		Placeholder = "My HUD",
		Finished = false,
	})

	Section:AddDropdown("HudProfileList", {
		Title = "Saved profiles",
		Description = "Profiles stored for this game",
		Icon = "tabler:folder-open",
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
		ButtonIcon = "feather:save",
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
		ButtonIcon = "feather:download",
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
		ButtonIcon = "feather:refresh-cw",
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
		ButtonIcon = "tabler:trash",
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
		ButtonIcon = "feather:rotate-cw",
		Callback = Refresh,
	})

	AutoloadButton = Section:AddButton({
		Title = "Set as autoload",
		Description = "Current autoload profile: none",
		Variant = "Accent",
		ButtonText = "Toggle",
		ButtonIcon = "tabler:rocket",
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

	local Share = Tab:AddSection("Share and migrate", { Icon = "tabler:share" })

	Share:AddButton({
		Title = "Copy profile",
		Description = "Copy the selected profile as JSON to your clipboard",
		Variant = "Tonal",
		ButtonText = "Copy",
		ButtonIcon = "tabler:copy",
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
		Icon = "tabler:clipboard",
		Placeholder = "Paste JSON",
		Finished = false,
	})

	Share:AddButton({
		Title = "Import profile",
		Description = "Save the pasted JSON under the profile name above",
		Variant = "Primary",
		ButtonText = "Import",
		ButtonIcon = "tabler:file-import",
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
		ButtonIcon = "tabler:history",
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
	self:IgnoreSaveIndexes({ "HudProfileName", "HudProfileList", "HudProfileImport" })
end

function HUDManager:BuildInspectorSection(Tab)
	self:Start()

	local Section = Tab:AddSection("HUD inspector", { Icon = "tabler:list-details" })

	Section:AddHudScreenMap({
		Title = "Screen map",
		Description = "Blue is selected, gray is moved, red is hidden. Tap a block to focus it",
		Height = 170,
	})

	Section:AddHudRuleList({
		Title = "Modified elements",
		Description = "Everything you moved, resized or hid",
		Height = 240,
	})
end

function HUDManager:BuildSection(Tab)
	self:BuildEditorSection(Tab)
	self:BuildInspectorSection(Tab)
	self:BuildProfileSection(Tab)
end

return HUDManager
