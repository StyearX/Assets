--!nonstrict
--!optimize 2

local Players: Players = game:GetService("Players")
local RunService: RunService = game:GetService("RunService")
local UserInputService: UserInputService = game:GetService("UserInputService")
local HttpService: HttpService = game:GetService("HttpService")
local MarketplaceService: MarketplaceService = game:GetService("MarketplaceService")
local GuiService: GuiService = game:GetService("GuiService")
local Workspace: Workspace = game:GetService("Workspace")

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local LocalPlayer: Player = Players.LocalPlayer
local PlayerGui: PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// Types \\

export type Axis = "Free" | "Horizontal" | "Vertical"
export type SelectionMode = "Smart" | "Exact"
export type LoadMode = "Replace" | "Merge"
export type Variant = "Menu" | "MenuDanger" | "Subtle" | "Tonal" | "Primary" | "Active" | "Danger" | "Ghost"

export type Rule = {
	Name: string,
	IsDeleted: boolean,
	Position: UDim2,
	Size: UDim2,
	SizeModified: boolean,
}

export type Original = {
	Position: UDim2,
	Size: UDim2,
}

export type Change = {
	Key: string,
	Before: Rule?,
	After: Rule?,
}

export type Entry = {
	Label: string,
	Changes: { Change },
	Time: number,
}

export type Counts = {
	Total: number,
	Hidden: number,
	Moved: number,
	Resized: number,
}

export type Settings = {
	ResizeStep: number,
	NudgeStep: number,
	SnapSize: number,
	Axis: Axis,
	SelectionMode: SelectionMode,
	GroupCluster: boolean,
	ShowLauncher: boolean,
	RespectLocks: boolean,
	Shortcuts: boolean,
	LoadMode: LoadMode,
}

export type Press = {
	Origin: Vector2,
	Moved: boolean,
	Objects: { [GuiObject]: boolean },
}

export type Drag = {
	Input: InputObject,
	Origin: Vector3,
	Moved: boolean,
	Set: { [GuiObject]: boolean },
	Start: { [GuiObject]: UDim2 },
	Keys: { [GuiObject]: string },
	Before: { [string]: Rule? },
}

export type Session = {
	EditMode: boolean,
	Selected: GuiObject?,
	Cluster: { GuiObject },
	BarLocked: boolean,
	Drag: Drag?,
}

export type PackedRule = {
	Name: string,
	IsDeleted: boolean,
	Position: { number },
	Size: { number },
	SizeModified: boolean,
}

export type Profile = {
	Version: number,
	GameId: string,
	GameName: string,
	SavedAt: number,
	Rules: { [string]: PackedRule },
}

export type Connection = {
	Connected: boolean,
	Disconnect: (self: Connection) -> (),
}

export type Signal<T...> = {
	Connect: (self: Signal<T...>, Handler: (T...) -> ()) -> Connection,
	Fire: (self: Signal<T...>, T...) -> (),
}

--// Constants \\

local Constants = table.freeze({
	Version = "3.0.0",
	Id = "HUDManager",
	RenderStep = "HUDManagerEnforce",
	RenderPriority = 2000,
	OverlayLayer = "Overlay",
	ShieldLayer = "Shield",
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
	PanelBase = 0.08,
	LockAttribute = "Locked",
	FormatVersion = 2,
	LegacyFolder = "PerfectUIManager_Configs",
	NudgeSteps = { 1, 5, 10, 25 },
	Dock = { Collapsed = 44, Expanded = 156, Hold = 2.5, Leave = 0.35, Speed = 18 },
	Icons = {
		Edit = "lucide:pencil",
		Undo = "lucide:undo-2",
		Redo = "lucide:redo-2",
		Save = "lucide:save",
		Advanced = "lucide:sliders-horizontal",
		Close = "lucide:x",
		Settings = "lucide:settings",
		Lock = "lucide:lock",
		Unlock = "lucide:unlock",
		Plus = "lucide:plus",
		Minus = "lucide:minus",
		Reset = "lucide:rotate-ccw",
		Hide = "lucide:eye-off",
		Up = "lucide:arrow-up",
		Down = "lucide:arrow-down",
		Left = "lucide:arrow-left",
		Right = "lucide:arrow-right",
		Launcher = "lucide:layout-dashboard",
		Focus = "lucide:crosshair",
		Grip = "lucide:grip-horizontal",
		Search = "lucide:search",
		CenterX = "lucide:align-center-horizontal",
		CenterY = "lucide:align-center-vertical",
	},
})

local MonoFace: Font = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

--// Signal \\

local Link = {}
Link.__index = Link

function Link.Disconnect(self: any)
	if not self.Connected then
		return
	end

	self.Connected = false

	local Index = table.find(self.Owner.Handlers, self)
	if Index then
		table.remove(self.Owner.Handlers, Index)
	end
end

local Signal = {}
Signal.__index = Signal

function Signal.new<T...>(): Signal<T...>
	return setmetatable({ Handlers = {} }, Signal) :: any
end

function Signal.Connect(self: any, Handler: (...any) -> ()): Connection
	local Connected = setmetatable({ Handler = Handler, Owner = self, Connected = true }, Link)
	table.insert(self.Handlers, Connected)
	return Connected :: any
end

function Signal.Fire(self: any, ...: any)
	for _, Connected in table.clone(self.Handlers) do
		if Connected.Connected then
			task.spawn(Connected.Handler, ...)
		end
	end
end

--// Util \\

local Util = {}

function Util.IsPointer(Input: InputObject): boolean
	local InputType = Input.UserInputType
	return InputType == Enum.UserInputType.MouseButton1 or InputType == Enum.UserInputType.Touch
end

function Util.IsSameInput(Held: InputObject, Other: InputObject): boolean
	return Held == Other
		or (Held.UserInputType == Enum.UserInputType.MouseButton1 and Other.UserInputType == Enum.UserInputType.MouseButton1)
end

function Util.IsTracking(Held: InputObject, Moved: InputObject): boolean
	if Held.UserInputType == Enum.UserInputType.Touch then
		return Held == Moved
	end

	return Moved.UserInputType == Enum.UserInputType.MouseMovement
end

function Util.IsBlank(Value: any): boolean
	return type(Value) ~= "string" or string.match(Value, "^%s*$") ~= nil
end

function Util.Trim(Value: any): string
	return (string.gsub(tostring(Value or ""), "^%s*(.-)%s*$", "%1"))
end

function Util.SanitizeName(Value: any): string
	return (string.gsub(Util.Trim(Value), '[\\/:*?"<>|]', ""))
end

function Util.Quote(Value: string): string
	return string.format("%q", Value)
end

function Util.HasFileSystem(): boolean
	return type(writefile) == "function"
		and type(readfile) == "function"
		and type(isfile) == "function"
		and type(isfolder) == "function"
		and type(makefolder) == "function"
		and type(listfiles) == "function"
end

function Util.EnsureFolder(Path: string)
	if type(isfolder) ~= "function" or type(makefolder) ~= "function" then
		return
	end

	local Built = ""
	for Part in string.gmatch(Path, "[^/\\]+") do
		Built = if Built == "" then Part else `{Built}/{Part}`
		if not isfolder(Built) then
			pcall(makefolder, Built)
		end
	end
end

function Util.ReadJson(Path: string): { [any]: any }?
	if type(isfile) ~= "function" or not isfile(Path) then
		return nil
	end

	local Success, Data = pcall(function()
		return HttpService:JSONDecode(readfile(Path))
	end)

	return if Success and type(Data) == "table" then Data else nil
end

function Util.WriteJson(Path: string, Data: any): (boolean, string?)
	local Encoded, Text = pcall(HttpService.JSONEncode, HttpService, Data)
	if not Encoded then
		return false, "encode failed"
	end

	if not pcall(writefile, Path, Text) then
		return false, "write failed"
	end

	return true, nil
end

function Util.PackUDim2(Value: UDim2): { number }
	return { Value.X.Scale, Value.X.Offset, Value.Y.Scale, Value.Y.Offset }
end

function Util.UnpackUDim2(Array: any): UDim2?
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

function Util.Shift(Value: UDim2, X: number, Y: number): UDim2
	return UDim2.new(Value.X.Scale, Value.X.Offset + X, Value.Y.Scale, Value.Y.Offset + Y)
end

function Util.GetViewport(): Vector2
	local Camera = Workspace.CurrentCamera
	return if Camera then Camera.ViewportSize else Vector2.new(1920, 1080)
end

function Util.PointInGui(Point: Vector2, Gui: GuiObject): boolean
	local Position = Gui.AbsolutePosition
	local Size = Gui.AbsoluteSize
	return Point.X >= Position.X
		and Point.X <= Position.X + Size.X
		and Point.Y >= Position.Y
		and Point.Y <= Position.Y + Size.Y
end

function Util.Snap(Value: number, Step: number): number
	if Step <= 0 then
		return Value
	end

	return math.round(Value / Step) * Step
end

function Util.SortedKeys(Source: { [string]: any }): { string }
	local Keys = {}
	for Key in Source do
		table.insert(Keys, Key)
	end
	table.sort(Keys)
	return Keys
end

--// KeyResolver \\

local KeyResolver = {}

function KeyResolver.Resolve(Object: GuiObject): string
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
			Trait ..= "_" .. string.sub(Object.Text, 1, 10)
		end
	elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
		local Id = if Object.Image ~= "" then string.match(Object.Image, "%d+") else nil
		if Id then
			Trait ..= "_IMG" .. Id
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
			Trait ..= "_IDX" .. Order
		end
	end

	return Base .. Trait
end

--// Geometry \\

local Geometry = {}

function Geometry.FindLayout(Parent: Instance?): Instance?
	if not Parent then
		return nil
	end

	local Success, Found = pcall(function()
		return Parent:FindFirstChildWhichIsA("UILayout") or Parent:FindFirstChildWhichIsA("UIGridStyleLayout")
	end)

	return if Success then Found else nil
end

function Geometry.VisualPosition(Gui: GuiObject): UDim2
	local Parent = Gui.Parent
	if not (Parent and Parent:IsA("GuiObject")) then
		return Gui.Position
	end

	local Origin = Parent.AbsolutePosition
	if Parent:IsA("ScrollingFrame") then
		Origin -= Parent.CanvasPosition
	end

	local Anchor = Gui.AnchorPoint
	local Size = Gui.AbsoluteSize
	local Position = Gui.AbsolutePosition

	return UDim2.fromOffset(Position.X - Origin.X + Anchor.X * Size.X, Position.Y - Origin.Y + Anchor.Y * Size.Y)
end

function Geometry.VisualSize(Gui: GuiObject): UDim2
	if Gui.Size == UDim2.new() then
		return UDim2.fromOffset(Gui.AbsoluteSize.X, Gui.AbsoluteSize.Y)
	end

	return Gui.Size
end

function Geometry.OriginalPosition(Gui: GuiObject): UDim2
	return if Geometry.FindLayout(Gui.Parent) then Geometry.VisualPosition(Gui) else Gui.Position
end

function Geometry.Center(Gui: GuiObject): Vector2
	return Gui.AbsolutePosition + Gui.AbsoluteSize / 2
end

function Geometry.Inset(): Vector2
	local TopLeft = GuiService:GetGuiInset()
	return TopLeft
end

function Geometry.ScreenPosition(Gui: GuiObject): Vector2
	local Root = Gui:FindFirstAncestorOfClass("ScreenGui")

	if Root and not Root.IgnoreGuiInset then
		return Gui.AbsolutePosition + Geometry.Inset()
	end

	return Gui.AbsolutePosition
end

function Geometry.ContainsInput(Gui: GuiObject, Position: Vector3): boolean
	local Point = Vector2.new(Position.X, Position.Y) + Geometry.Inset()
	local Origin = Geometry.ScreenPosition(Gui)
	local Size = Gui.AbsoluteSize

	return Point.X >= Origin.X
		and Point.X <= Origin.X + Size.X
		and Point.Y >= Origin.Y
		and Point.Y <= Origin.Y + Size.Y
end

--// RuleBook \\

local RuleBook = {}
RuleBook.__index = RuleBook

type BookFields = {
	Rules: { [string]: Rule },
	Originals: { [string]: Original },
	Tracked: { [GuiObject]: string },
	Hidden: { [GuiObject]: boolean },
	Baked: { [Instance]: boolean },
	External: { [GuiObject]: boolean },
	Changed: Signal<>,
}

export type RuleBook = typeof(setmetatable({} :: BookFields, RuleBook))

function RuleBook.new(): RuleBook
	return setmetatable({
		Rules = {},
		Originals = {},
		Tracked = setmetatable({}, { __mode = "k" }),
		Hidden = setmetatable({}, { __mode = "k" }),
		Baked = setmetatable({}, { __mode = "k" }),
		External = setmetatable({}, { __mode = "k" }),
		Changed = Signal.new(),
	} :: BookFields, RuleBook)
end

function RuleBook.Snapshot(self: RuleBook, Key: string): Rule?
	local Rule = self.Rules[Key]
	return if Rule then table.clone(Rule) else nil
end

function RuleBook.Capture(self: RuleBook, Object: GuiObject, Key: string)
	if self.Originals[Key] then
		return
	end

	self.Originals[Key] = {
		Position = Geometry.OriginalPosition(Object),
		Size = Geometry.VisualSize(Object),
	}
end

function RuleBook.Ensure(self: RuleBook, Object: GuiObject, Key: string): Rule
	local Existing = self.Rules[Key]
	if Existing then
		self.Tracked[Object] = Key
		return Existing
	end

	self:Capture(Object, Key)

	local Rule: Rule = {
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

function RuleBook.Apply(self: RuleBook, Object: GuiObject, Key: string, Dragging: boolean, Yielding: boolean?): "Adopt"?
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

function RuleBook.Release(self: RuleBook, Key: string)
	local Rule = self.Rules[Key]
	local Original = self.Originals[Key]

	for Object, ObjectKey in self.Tracked do
		if ObjectKey ~= Key then
			continue
		end

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

	self.Rules[Key] = nil
	self.Originals[Key] = nil
end

function RuleBook.Clear(self: RuleBook)
	for Key in table.clone(self.Rules) do
		self:Release(Key)
	end
end

function RuleBook.FindObject(self: RuleBook, Key: string): GuiObject?
	for Object, ObjectKey in self.Tracked do
		if ObjectKey == Key and Object.Parent then
			return Object
		end
	end

	return nil
end

function RuleBook.Counts(self: RuleBook): Counts
	local Counts: Counts = { Total = 0, Hidden = 0, Moved = 0, Resized = 0 }

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

function RuleBook.IsEmpty(self: RuleBook): boolean
	return next(self.Rules) == nil
end

--// History \\

local History = {}
History.__index = History

type HistoryFields = {
	Undos: { Entry },
	Redos: { Entry },
	Limit: number,
	Changed: Signal<>,
}

export type History = typeof(setmetatable({} :: HistoryFields, History))

function History.new(Limit: number): History
	return setmetatable({
		Undos = {},
		Redos = {},
		Limit = Limit,
		Changed = Signal.new(),
	} :: HistoryFields, History)
end

function History.Push(self: History, Label: string, Changes: { Change }, Merge: boolean?)
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

function History.PopUndo(self: History): Entry?
	local Item = table.remove(self.Undos)
	if Item then
		table.insert(self.Redos, Item)
		self.Changed:Fire()
	end
	return Item
end

function History.PopRedo(self: History): Entry?
	local Item = table.remove(self.Redos)
	if Item then
		table.insert(self.Undos, Item)
		self.Changed:Fire()
	end
	return Item
end

function History.Clear(self: History)
	table.clear(self.Undos)
	table.clear(self.Redos)
	self.Changed:Fire()
end

--// LayoutBaker \\

local LayoutBaker = {}

function LayoutBaker.Bake(Book: RuleBook, Parent: Instance?)
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

	local Snapshot: { [GuiObject]: { Position: Vector2, Size: Vector2 } } = {}
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
		Origin -= Parent.CanvasPosition
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

--// Picker \\

local Picker = {}

function Picker.IsJoystick(Gui: Instance): boolean
	local Current: Instance? = Gui

	while Current and Current:IsA("GuiObject") do
		local Name = string.lower(Current.Name)
		if string.find(Name, "thumbstick") or string.find(Name, "joystick") then
			return true
		end
		Current = Current.Parent
	end

	return false
end

function Picker.IsButtonLike(Gui: GuiObject): boolean
	return Gui:IsA("GuiButton") or Gui:FindFirstChildWhichIsA("TouchTransmitter") ~= nil
end

function Picker.HasInteraction(Gui: GuiObject): boolean
	return Gui:IsA("GuiButton")
		or Gui:FindFirstChildWhichIsA("TouchTransmitter") ~= nil
		or Gui:FindFirstChildWhichIsA("GuiButton", true) ~= nil
		or Gui:FindFirstChildWhichIsA("TouchTransmitter", true) ~= nil
end

function Picker.FindTop(Hits: { GuiObject }, Viewport: Vector2, Accept: (GuiObject) -> boolean): GuiObject?
	local MaxWidth = Viewport.X * Constants.ViewportLimit
	local MaxHeight = Viewport.Y * Constants.ViewportLimit

	local function Eligible(Gui: GuiObject): boolean
		return Accept(Gui)
			and Gui.AbsoluteSize.X < MaxWidth
			and Gui.AbsoluteSize.Y < MaxHeight
			and not Picker.IsJoystick(Gui)
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

function Picker.Climb(Top: GuiObject, Viewport: Vector2): GuiObject
	local MaxWidth = Viewport.X * Constants.ViewportLimit
	local MaxHeight = Viewport.Y * Constants.ViewportLimit
	local Current = Top.Parent
	local Highest = Top

	while Current and Current:IsA("GuiObject") do
		if Current.AbsoluteSize.X >= MaxWidth or Current.AbsoluteSize.Y >= MaxHeight or Picker.IsJoystick(Current) then
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

function Picker.Pick(Hits: { GuiObject }, Viewport: Vector2, Mode: SelectionMode, Accept: (GuiObject) -> boolean): GuiObject?
	local Top = Picker.FindTop(Hits, Viewport, Accept)
	if not Top then
		return nil
	end

	return if Mode == "Exact" then Top else Picker.Climb(Top, Viewport)
end

function Picker.BuildCluster(Target: GuiObject): { GuiObject }
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

--// Widgets \\

type Style = {
	Background: string,
	Base: number,
	Text: string,
	Stroke: boolean?,
	HoverBase: number?,
	PressBase: number?,
}

export type Button = {
	Root: Frame,
	Hit: TextButton,
	Enabled: boolean,
	SetVariant: (Name: Variant) -> (),
	SetEnabled: (Value: boolean) -> (),
	SetText: (Text: string) -> (),
	SetIcon: (Name: string) -> (),
	SetReveal: (Alpha: number) -> (),
	OnActivated: (Callback: () -> ()) -> (),
}

export type ButtonConfig = {
	Parent: Instance?,
	Icon: string?,
	Text: string?,
	Variant: Variant?,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	LayoutOrder: number?,
	Radius: number?,
	IconSize: number?,
	TextSize: number?,
	Gap: number?,
	Align: "Left"?,
	Inset: number?,
	Clip: boolean?,
	Concealed: boolean?,
}

export type PanelConfig = {
	Name: string,
	Parent: Instance,
	Size: UDim2,
	Position: UDim2,
	AnchorPoint: Vector2?,
	Radius: number?,
	ZIndex: number?,
	AutoY: boolean?,
	Visible: boolean?,
}

local Styles: { [Variant]: Style } = {
	Menu = { Background = "Hover", Base = 1, Text = "Text" },
	MenuDanger = { Background = "Danger", Base = 1, HoverBase = 0.88, PressBase = 0.8, Text = "Danger" },
	Subtle = { Background = "Hover", Base = 0.93, Text = "Text", Stroke = true },
	Tonal = { Background = "Accent", Base = 0.84, Text = "Text", Stroke = true },
	Primary = { Background = "FillButton", Base = 0, Text = "FillButtonText" },
	Active = { Background = "Accent", Base = 0.82, Text = "Text", Stroke = true },
	Danger = { Background = "Danger", Base = 0.82, Text = "Danger" },
	Ghost = { Background = "Hover", Base = 1, Text = "SubText" },
}

local Widgets = {
	Api = nil :: any,
	Library = nil :: any,
}

function Widgets.Bind(Api: any)
	Widgets.Api = Api
	Widgets.Library = Api.Library
end

local function New(ClassName: string, Properties: { [string]: any }?, Children: { Instance }?): any
	return Widgets.Api.Creator.New(ClassName, Properties, Children)
end

local function GetThemeValue(Key: string): any
	return Widgets.Api.Creator.GetThemeProperty(Key)
end

function Widgets.Corner(Radius: number): UICorner
	return New("UICorner", { CornerRadius = UDim.new(0, Radius) })
end

function Widgets.Stroke(Key: string, Base: number): UIStroke
	local Stroke = New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = 1,
		ThemeTag = { Color = Key },
	})
	Widgets.Library:BindOpacity(Stroke, "Transparency", Base)
	return Stroke
end

function Widgets.Padding(Parent: Instance?, Top: number, Right: number, Bottom: number, Left: number): UIPadding
	return New("UIPadding", {
		PaddingTop = UDim.new(0, Top),
		PaddingRight = UDim.new(0, Right),
		PaddingBottom = UDim.new(0, Bottom),
		PaddingLeft = UDim.new(0, Left),
		Parent = Parent,
	})
end

function Widgets.List(Parent: Instance?, Padding: number, Horizontal: boolean?, Align: Enum.HorizontalAlignment?): UIListLayout
	return New("UIListLayout", {
		FillDirection = if Horizontal then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical,
		HorizontalAlignment = Align or Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, Padding),
		Parent = Parent,
	})
end

function Widgets.Label(Properties: { [string]: any }): TextLabel
	local Final = {
		BackgroundTransparency = 1,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		FontFace = Widgets.Library:FontFor(Properties.Weight or "Medium"),
		ThemeTag = { TextColor3 = Properties.Tag or "Text" },
	}

	for Key, Value in Properties do
		if Key ~= "Weight" and Key ~= "Tag" then
			Final[Key] = Value
		end
	end

	return New("TextLabel", Final)
end

function Widgets.Retag(Object: Instance, Tags: { [string]: string })
	Widgets.Api.Creator.OverrideTag(Object, Tags)
end

function Widgets.Paint(Object: Instance, Base: number, Duration: number?)
	local Library = Widgets.Library
	Library:BindOpacity(Object, "BackgroundTransparency", Base, true)

	local Goal = Library:ScaleOpacity(Base)
	if Duration then
		Widgets.Api.Creator.Tween(Object, Duration, { BackgroundTransparency = Goal })
	else
		(Object :: any).BackgroundTransparency = Goal
	end
end

function Widgets.Fill(Properties: { [string]: any }, Tag: string, Base: number, Children: { Instance }?): any
	local Props = table.clone(Properties)
	Props.ThemeTag = { BackgroundColor3 = Tag }
	Props.BorderSizePixel = 0

	local Object = New("Frame", Props, Children)
	Widgets.Library:BindOpacity(Object, "BackgroundTransparency", Base)
	return Object
end

function Widgets.Divider(Parent: Instance, Order: number, Inset: number?): Frame
	local Holder = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 7),
		LayoutOrder = Order,
		Parent = Parent,
	})

	Widgets.Fill({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -(Inset or 0) * 2, 0, 1),
		Parent = Holder,
	}, "ElementBorder", 0.88)

	return Holder
end

function Widgets.Separator(Parent: Instance, Order: number): Frame
	return Widgets.Fill({ Size = UDim2.fromOffset(1, 16), LayoutOrder = Order, Parent = Parent }, "ElementBorder", 0.85)
end

function Widgets.Panel(Config: PanelConfig): (Frame, Frame)
	local Radius = Config.Radius or 10
	local AutoY = Config.AutoY == true

	local Shell = New("Frame", {
		Name = Config.Name,
		BackgroundTransparency = 1,
		Size = Config.Size,
		Position = Config.Position,
		AnchorPoint = Config.AnchorPoint or Vector2.zero,
		ZIndex = Config.ZIndex or 1,
		Visible = Config.Visible ~= false,
		Parent = Config.Parent,
	})

	Widgets.Api:Shadow(Shell, 1, Radius)

	local Fill = Widgets.Fill({
		Name = "Fill",
		Size = if AutoY then UDim2.new(1, 0, 0, 0) else UDim2.fromScale(1, 1),
		AutomaticSize = if AutoY then Enum.AutomaticSize.Y else Enum.AutomaticSize.None,
		Active = true,
		Parent = Shell,
	}, "AcrylicMain", Constants.PanelBase, { Widgets.Corner(Radius), Widgets.Stroke("AcrylicBorder", 0.35) })

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

function Widgets.Icon(Parent: Instance, Name: string, Size: number, Tag: string?, Order: number?): { Root: Frame, Set: (Name: string) -> (), SetTag: (Tag: string) -> () }
	local Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(Size, Size),
		LayoutOrder = Order or 0,
		Parent = Parent,
	})

	local Image = New("ImageLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ThemeTag = { ImageColor3 = Tag or "Text" },
		Parent = Root,
	})

	Widgets.Api:Icon(Image, Name)

	return {
		Root = Root,
		Set = function(Next: string)
			Widgets.Api:Icon(Image, Next)
		end,
		SetTag = function(Next: string)
			Widgets.Retag(Image, { ImageColor3 = Next })
		end,
	}
end

function Widgets.Button(Config: ButtonConfig): Button
	local Name: Variant = Config.Variant or "Subtle"
	local Style = Styles[Name]
	local Aligned = Config.Align == "Left"
	local Fade = 0
	local Reveal = if Config.Concealed then 0 else 1

	local Root = New("Frame", {
		Name = "Button",
		BackgroundTransparency = 1,
		Size = Config.Size or UDim2.fromOffset(34, 34),
		Position = Config.Position or UDim2.new(),
		AnchorPoint = Config.AnchorPoint or Vector2.zero,
		LayoutOrder = Config.LayoutOrder or 0,
		Parent = Config.Parent,
	})

	local Stroke = Widgets.Stroke("ElementBorder", 0.9)
	Stroke.Enabled = Style.Stroke == true

	local Hit = New("TextButton", {
		Name = "Hit",
		Text = "",
		AutoButtonColor = false,
		ClipsDescendants = Config.Clip == true,
		Size = UDim2.fromScale(1, 1),
		ThemeTag = { BackgroundColor3 = Style.Background },
		Parent = Root,
	}, { Widgets.Corner(Config.Radius or 8), Stroke })
	Widgets.Library:BindOpacity(Hit, "BackgroundTransparency", Style.Base)

	local Content = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = Hit,
	}, {
		Widgets.List(nil, Config.Gap or 8, true, if Aligned then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Center),
		Widgets.Padding(nil, 0, 0, 0, if Aligned then (Config.Inset or 10) else 0),
	})

	local Icon = if Config.Icon then Widgets.Icon(Content, Config.Icon, Config.IconSize or 16, Style.Text, 1) else nil
	local Label = nil

	if Config.Text then
		Label = Widgets.Label({
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

	local Object = { Root = Root, Hit = Hit, Enabled = true } :: Button

	local function Dim()
		if Label then
			Label.TextTransparency = 1 - (1 - Fade) * Reveal
		end
	end

	local function HoverBase(): number
		if Style.HoverBase then
			return Style.HoverBase
		end
		return if Style.Base >= 0.99 then (GetThemeValue("HoverTransparency") or 0.945) else math.max(Style.Base - 0.05, 0)
	end

	local function PressBase(): number
		if Style.PressBase then
			return Style.PressBase
		end
		return if Style.Base >= 0.99 then (GetThemeValue("PressedTransparency") or 0.906) else math.max(Style.Base - 0.1, 0)
	end

	Dim()

	Hit.MouseEnter:Connect(function()
		if Object.Enabled then
			Widgets.Paint(Hit, HoverBase(), 0.12)
		end
	end)

	Hit.MouseLeave:Connect(function()
		Widgets.Paint(Hit, Style.Base, 0.12)
	end)

	Hit.MouseButton1Down:Connect(function()
		if Object.Enabled then
			Widgets.Paint(Hit, PressBase(), 0.12)
		end
	end)

	Hit.MouseButton1Up:Connect(function()
		if Object.Enabled then
			Widgets.Paint(Hit, HoverBase(), 0.12)
		end
	end)

	function Object.SetVariant(Name: Variant)
		Style = Styles[Name] or Styles.Subtle
		Widgets.Retag(Hit, { BackgroundColor3 = Style.Background })
		Widgets.Paint(Hit, Style.Base)
		Stroke.Enabled = Style.Stroke == true

		if Label then
			Widgets.Retag(Label, { TextColor3 = Style.Text })
		end
		if Icon then
			Icon.SetTag(Style.Text)
		end
	end

	function Object.SetText(Text: string)
		if Label then
			Label.Text = Text
		end
	end

	function Object.SetIcon(Name: string)
		if Icon then
			Icon.Set(Name)
		end
	end

	function Object.SetReveal(Alpha: number)
		if Reveal ~= Alpha then
			Reveal = Alpha
			Dim()
		end
	end

	function Object.SetEnabled(Value: boolean)
		Object.Enabled = Value
		Fade = if Value then 0 else 0.6
		Dim()

		if Icon then
			(Icon.Root :: any):FindFirstChildOfClass("ImageLabel").ImageTransparency = Fade
		end
	end

	function Object.OnActivated(Callback: () -> ())
		Hit.Activated:Connect(function()
			if Object.Enabled then
				Callback()
			end
		end)
	end

	return Object
end

function Widgets.Hold(Target: Button, Action: () -> ())
	local Api = Widgets.Api
	local Token = 0

	Target.Hit.InputBegan:Connect(function(Input: InputObject)
		if not Util.IsPointer(Input) or not Target.Enabled then
			return
		end

		Token += 1
		local Current = Token

		Action()

		local Release: RBXScriptConnection
		Release = UserInputService.InputEnded:Connect(function(Ended: InputObject)
			if Util.IsSameInput(Input, Ended) then
				if Token == Current then
					Token += 1
				end
				Release:Disconnect()
			end
		end)

		task.delay(Constants.RepeatDelay, function()
			while Token == Current and Api.Alive and Target.Enabled do
				Action()
				task.wait(Constants.RepeatInterval)
			end
		end)
	end)
end

function Widgets.Draggable(Handle: GuiObject, Target: GuiObject, IsLocked: (() -> boolean)?, Moving: { Moving: boolean }?, OnEnd: ((Moved: boolean) -> ())?)
	local Api = Widgets.Api
	local Held: InputObject? = nil
	local Origin = Vector3.zero
	local Start = UDim2.new()
	local Moved = false
	local Active = false

	local function Mark(Value: boolean)
		if Moving then
			Moving.Moving = Value
		end
	end

	Handle.InputBegan:Connect(function(Input: InputObject)
		if not Util.IsPointer(Input) then
			return
		end

		Held = Input
		Origin = Input.Position
		Start = Target.Position
		Moved = false
		Active = not (IsLocked and IsLocked())
		Mark(false)
	end)

	Api:Connect(UserInputService.InputChanged, function(Input: InputObject)
		if not Held or not Util.IsTracking(Held, Input) then
			return
		end

		local Delta = Input.Position - Origin

		if not Moved then
			if Vector2.new(Delta.X, Delta.Y).Magnitude < Constants.TapThreshold then
				return
			end

			Moved = true
			Start = Target.Position
			Mark(true)
		end

		if Active then
			Target.Position = Util.Shift(Start, Delta.X, Delta.Y)
		end
	end)

	Api:Connect(UserInputService.InputEnded, function(Input: InputObject)
		if not Held or not Util.IsSameInput(Held, Input) then
			return
		end

		local Result = Moved
		Held = nil
		Mark(false)

		if OnEnd then
			OnEnd(Result)
		end
	end)
end

function Widgets.Contain(Shell: GuiObject, Viewport: Vector2)
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

	if DeltaX ~= 0 or DeltaY ~= 0 then
		Shell.Position = Util.Shift(Shell.Position, DeltaX, DeltaY)
	end
end

function Widgets.Capsule(Parent: Instance, Order: number, Height: number?): Frame
	return Widgets.Fill({
		Name = "Capsule",
		Size = UDim2.fromOffset(0, Height or 30),
		AutomaticSize = Enum.AutomaticSize.X,
		LayoutOrder = Order,
		Parent = Parent,
	}, "Hover", 0.93, {
		Widgets.Corner(8),
		Widgets.Stroke("ElementBorder", 0.9),
		Widgets.Padding(nil, 2, 2, 2, 2),
		Widgets.List(nil, 2, true),
	})
end

function Widgets.Group(Parent: Instance, Order: number, Items: { { Icon: string?, Text: string?, Width: number?, Variant: Variant? } }): { Button }
	local Root = Widgets.Capsule(Parent, Order)
	local Buttons = {}

	for Index, Item in Items do
		Buttons[Index] = Widgets.Button({
			Parent = Root,
			Icon = Item.Icon,
			Text = Item.Text,
			Variant = Item.Variant or "Menu",
			Size = UDim2.fromOffset(Item.Width or 28, 26),
			Radius = 6,
			IconSize = 14,
			TextSize = 11,
			LayoutOrder = Index,
		})
	end

	return Buttons
end

function Widgets.Row(Parent: Instance, Order: number, Title: string, Height: number?): (Frame, Frame)
	local Row = New("Frame", {
		Name = Title,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, Height or 36),
		LayoutOrder = Order,
		Parent = Parent,
	})

	Widgets.Label({
		Parent = Row,
		Text = Title,
		Position = UDim2.fromOffset(8, 0),
		Size = UDim2.new(0.35, 0, 1, 0),
	})

	local Right = New("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -2, 0, 0),
		Size = UDim2.new(0.65, 0, 1, 0),
		Parent = Row,
	}, { Widgets.List(nil, 6, true, Enum.HorizontalAlignment.Right) })

	return Row, Right
end

export type Segmented = {
	Root: Frame,
	Value: any,
	SetValue: (Value: any, Silent: boolean?) -> (),
}

function Widgets.Segmented(Parent: Instance, Order: number, Size: UDim2, Options: { any }, Default: any, Callback: ((Value: any) -> ())?): Segmented
	local Count = #Options
	local Root = Widgets.Fill({
		Name = "Segmented",
		Size = Size,
		LayoutOrder = Order,
		Parent = Parent,
	}, "Hover", 0.93, {
		Widgets.Corner(8),
		Widgets.Stroke("ElementBorder", 0.9),
		Widgets.Padding(nil, 2, 2, 2, 2),
		Widgets.List(nil, 2, true),
	})

	local Buttons: { [any]: Button } = {}
	local Object = { Root = Root, Value = Default } :: Segmented

	local function Refresh()
		for Option, Item in Buttons do
			Item.SetVariant(if Option == Object.Value then "Active" else "Menu")
		end
	end

	function Object.SetValue(Value: any, Silent: boolean?)
		if not Buttons[Value] then
			return
		end

		Object.Value = Value
		Refresh()

		if not Silent and Callback then
			Callback(Value)
		end
	end

	for Index, Option in Options do
		local Item = Widgets.Button({
			Parent = Root,
			Text = tostring(Option),
			Variant = "Menu",
			Radius = 6,
			TextSize = 11,
			Size = UDim2.new(1 / Count, -(2 * (Count - 1)) / Count, 1, 0),
			LayoutOrder = Index,
		})
		Item.OnActivated(function()
			Object.SetValue(Option)
		end)
		Buttons[Option] = Item
	end

	Refresh()
	return Object
end

export type Switch = {
	Value: boolean,
	SetValue: (Value: boolean, Silent: boolean?) -> (),
}

function Widgets.Switch(Parent: Instance, Default: boolean, Callback: ((Value: boolean) -> ())?): Switch
	local Hit = New("TextButton", {
		Text = "",
		AutoButtonColor = false,
		Size = UDim2.fromOffset(36, 20),
		ThemeTag = { BackgroundColor3 = "ToggleSlider" },
		Parent = Parent,
	}, { Widgets.Corner(10) })

	local Knob = Widgets.Fill({
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.new(0, 3, 0.5, 0),
		Parent = Hit,
	}, "FillButton", 0, { Widgets.Corner(7) })

	local Object = { Value = Default } :: Switch

	local function Refresh(Animated: boolean)
		local On = Object.Value
		Widgets.Retag(Hit, { BackgroundColor3 = if On then "ToggleToggled" else "ToggleSlider" })
		Widgets.Paint(Hit, if On then 0 else 0.72, if Animated then 0.15 else nil)

		local Goal = if On then UDim2.new(1, -17, 0.5, 0) else UDim2.new(0, 3, 0.5, 0)
		if Animated then
			Widgets.Api.Creator.Tween(Knob, 0.15, { Position = Goal })
		else
			Knob.Position = Goal
		end
	end

	function Object.SetValue(Value: boolean, Silent: boolean?)
		if Object.Value == Value then
			return
		end

		Object.Value = Value
		Refresh(true)

		if not Silent and Callback then
			Callback(Value)
		end
	end

	Hit.Activated:Connect(function()
		Object.SetValue(not Object.Value)
	end)

	Refresh(false)
	return Object
end

export type Stepper = {
	Value: number,
	SetValue: (Value: number, Silent: boolean?) -> (),
}

function Widgets.Stepper(Parent: Instance, Min: number, Max: number, Default: number, Suffix: string, Callback: ((Value: number) -> ())?): Stepper
	local Root = Widgets.Capsule(Parent, 1)
	local Object = { Value = Default } :: Stepper

	local Minus = Widgets.Button({ Parent = Root, Icon = Constants.Icons.Minus, Variant = "Menu", Size = UDim2.fromOffset(28, 26), Radius = 6, IconSize = 14, LayoutOrder = 1 })

	local Display = Widgets.Label({
		Parent = Root,
		Size = UDim2.fromOffset(52, 26),
		TextXAlignment = Enum.TextXAlignment.Center,
		FontFace = MonoFace,
		TextSize = 11,
		LayoutOrder = 2,
	})

	local Plus = Widgets.Button({ Parent = Root, Icon = Constants.Icons.Plus, Variant = "Menu", Size = UDim2.fromOffset(28, 26), Radius = 6, IconSize = 14, LayoutOrder = 3 })

	function Object.SetValue(Value: number, Silent: boolean?)
		Value = math.clamp(Value, Min, Max)
		Display.Text = Value .. Suffix

		if Object.Value == Value then
			return
		end

		Object.Value = Value

		if not Silent and Callback then
			Callback(Value)
		end
	end

	Widgets.Hold(Minus, function()
		Object.SetValue(Object.Value - 1)
	end)

	Widgets.Hold(Plus, function()
		Object.SetValue(Object.Value + 1)
	end)

	Display.Text = Default .. Suffix
	return Object
end

function Widgets.Scroll(Parent: Instance, Order: number, Height: number): ScrollingFrame
	return New("ScrollingFrame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, Height),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 2,
		LayoutOrder = Order,
		ThemeTag = { ScrollBarImageColor3 = "ScrollBar" },
		Parent = Parent,
	})
end

function Widgets.Field(Parent: Instance, Order: number, Placeholder: string, OnChanged: (Text: string) -> ()): TextBox
	local Frame = Widgets.Fill({
		Size = UDim2.new(1, 0, 0, 30),
		LayoutOrder = Order,
		Parent = Parent,
	}, "Hover", 0.93, {
		Widgets.Corner(8),
		Widgets.Stroke("ElementBorder", 0.9),
	})

	Widgets.Icon(Frame, Constants.Icons.Search, 14, "SubText").Root.Position = UDim2.fromOffset(9, 8)

	local Box = New("TextBox", {
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		Text = "",
		PlaceholderText = Placeholder,
		Position = UDim2.fromOffset(30, 0),
		Size = UDim2.new(1, -38, 1, 0),
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		FontFace = Widgets.Library:FontFor("Medium"),
		ThemeTag = { TextColor3 = "Text", PlaceholderColor3 = "SubText" },
		Parent = Frame,
	})

	Box:GetPropertyChangedSignal("Text"):Connect(function()
		OnChanged(Box.Text)
	end)

	return Box
end

--// Overlay \\

local Overlay = {}
Overlay.__index = Overlay

type OverlayFields = {
	Core: any,
	Api: any,
	Ready: boolean,
	Layer: ScreenGui,
	ShieldLayer: ScreenGui,
	Shield: TextButton,
	PrimaryBox: Frame,
	ClusterBoxes: { Frame },
	Tag: TextLabel,
	TagText: string,
	TagFlipped: boolean,
	Launcher: Frame,
	Dock: Frame,
	GripLabel: TextLabel,
	DockButtons: { Button },
	DockProgress: number,
	DockHold: number,
	DockHover: boolean,
	DockPress: InputObject?,
	DockLeft: boolean,
	DockTrack: { Moving: boolean },
	EditButton: Button,
	UndoButton: Button,
	RedoButton: Button,
	AdvancedButton: Button,
	ActionBar: Frame,
	SelectionName: TextLabel,
	SelectionSize: TextLabel,
	LockButton: Button,
	StepLabel: TextLabel,
	Advanced: Frame,
	Scroll: ScrollingFrame,
	PagesBody: Frame,
	Pages: { [string]: Frame },
	Tabs: Segmented,
	ActivePage: string,
	AdvancedSelection: TextLabel,
	Controls: { Button },
	Panels: { Frame },
	Syncs: { [string]: { (Value: any) -> () } },
	ReadoutText: string?,
	Viewport: Vector2,
	LastMap: number,
	Map: { Surface: Frame, Ratio: UIAspectRatioConstraint, Boxes: { [GuiObject]: TextButton }, Kinds: { [TextButton]: string } },
}

export type Overlay = typeof(setmetatable({} :: OverlayFields, Overlay))

local MapPalette = {
	Selected = { Tag = "Accent", Transparency = 0.35 },
	Moved = { Tag = "SubText", Transparency = 0.7 },
	Hidden = { Tag = "Danger", Transparency = 0.7 },
}

function Overlay.new(Core: any, Api: any): Overlay
	local function Configure(Layer: ScreenGui): ScreenGui
		Layer.IgnoreGuiInset = true
		Layer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		return Layer
	end

	local Self: Overlay = setmetatable({
		Core = Core,
		Api = Api,
		Ready = false,
		ClusterBoxes = {},
		DockButtons = {},
		DockProgress = 0,
		DockHold = 0,
		DockHover = false,
		DockLeft = false,
		DockTrack = { Moving = false },
		TagText = "",
		TagFlipped = false,
		Controls = {},
		Syncs = {},
		ActivePage = "Adjust",
		Viewport = Util.GetViewport(),
		LastMap = 0,
		ShieldLayer = Configure(Api:Layer(Constants.ShieldLayer, Constants.ShieldOrder)),
		Layer = Configure(Api:Layer(Constants.OverlayLayer, Constants.OverlayOrder)),
	} :: any, Overlay)

	Widgets.Bind(Api)

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

	return Self
end

function Overlay.Bind(self: Overlay, Key: string, Apply: (Value: any) -> ())
	local List = self.Syncs[Key]
	if not List then
		List = {}
		self.Syncs[Key] = List
	end

	table.insert(List, Apply)
end

function Overlay.Sync(self: Overlay, Key: string, Value: any)
	for _, Apply in self.Syncs[Key] or {} do
		Apply(Value)
	end
end

function Overlay.BuildShield(self: Overlay)
	self.Shield = New("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Active = false,
		Visible = false,
		Parent = self.ShieldLayer,
	})

	self.Shield.InputBegan:Connect(function(Input: InputObject)
		self.Core:OnShieldPressed(Input)
	end)
end

function Overlay.CreateBox(self: Overlay, Primary: boolean): Frame
	local Stroke = New("UIStroke", {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Thickness = if Primary then 2 else 1,
		Transparency = if Primary then 0.05 else 0.55,
		ThemeTag = { Color = if Primary then "Accent" else "SubText" },
	})

	local Box = New("Frame", {
		BackgroundTransparency = if Primary then 0.9 else 1,
		Active = false,
		Visible = false,
		ZIndex = 1,
		ThemeTag = { BackgroundColor3 = "Accent" },
		Parent = self.Layer,
	}, { Widgets.Corner(4), Stroke })

	if Primary then
		self.Tag = New("TextLabel", {
			Name = "Tag",
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 0, -5),
			Size = UDim2.fromOffset(0, 18),
			AutomaticSize = Enum.AutomaticSize.X,
			BorderSizePixel = 0,
			Text = "",
			TextSize = 10,
			FontFace = MonoFace,
			ThemeTag = { BackgroundColor3 = "FillButton", TextColor3 = "FillButtonText" },
			Parent = Box,
		}, { Widgets.Corner(5), Widgets.Padding(nil, 0, 7, 0, 7) })
	end

	return Box
end

function Overlay.BuildSelection(self: Overlay)
	self.PrimaryBox = self:CreateBox(true)
end

function Overlay.PlaceBox(self: Overlay, Box: Frame, Object: GuiObject)
	local Position = Geometry.ScreenPosition(Object)
	local Size = Object.AbsoluteSize

	Box.Position = UDim2.fromOffset(Position.X, Position.Y)
	Box.Size = UDim2.fromOffset(Size.X, Size.Y)
	Box.Visible = true

	if Box ~= self.PrimaryBox then
		return
	end

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

function Overlay.FitAdvanced(self: Overlay, Viewport: Vector2)
	if not self.Advanced.Visible then
		return
	end

	local Limit = math.max(120, Viewport.Y - 110)
	local Height = math.ceil(math.min(self.PagesBody.AbsoluteSize.Y, Limit))

	if Height > 0 and self.Scroll.Size.Y.Offset ~= Height then
		self.Scroll.Size = UDim2.new(1, 0, 0, Height)
	end
end

function Overlay.Contain(self: Overlay)
	local Viewport = Util.GetViewport()
	self:FitAdvanced(Viewport)

	for _, Shell in self.Panels do
		if Shell.Visible then
			Widgets.Contain(Shell, Viewport)
		end
	end
end

function Overlay.Reflect(self: Overlay, Session: Session)
	local Viewport = Util.GetViewport()
	if Viewport ~= self.Viewport then
		self.Viewport = Viewport
		self.Map.Ratio.AspectRatio = Viewport.X / math.max(Viewport.Y, 1)
	end

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

function Overlay.BuildLauncher(self: Overlay)
	local Shell, Fill = Widgets.Panel({
		Name = "Launcher",
		Parent = self.Layer,
		Size = UDim2.fromOffset(36, 36),
		Position = UDim2.new(1, -52, 0.5, -18),
		Radius = 8,
		ZIndex = 10,
		Visible = false,
	})
	self.Launcher = Shell

	local Icon = Widgets.Icon(Fill, Constants.Icons.Launcher, 16)
	Icon.Root.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.Root.Position = UDim2.fromScale(0.5, 0.5)

	Widgets.Draggable(Fill, Shell, nil, nil, function(Moved: boolean)
		if not Moved then
			self:ToggleDock()
		end
	end)
end

function Overlay.BuildDock(self: Overlay)
	local Core = self.Core

	local Shell, Fill = Widgets.Panel({
		Name = "Dock",
		Parent = self.Layer,
		Size = UDim2.fromOffset(Constants.Dock.Collapsed, 0),
		Position = UDim2.new(0, 12, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		AutoY = true,
		Radius = 8,
		ZIndex = 12,
		Visible = false,
	})
	self.Dock = Shell

	Widgets.Padding(Fill, 2, 6, 6, 6)
	Widgets.List(Fill, 3, false, Enum.HorizontalAlignment.Center)

	local Grip = New("Frame", {
		Name = "Grip",
		Size = UDim2.new(1, 0, 0, 16),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = 1,
		Parent = Fill,
	})

	local GripIcon = Widgets.Icon(Grip, Constants.Icons.Grip, 14, "SubText")
	GripIcon.Root.AnchorPoint = Vector2.new(0, 0.5)
	GripIcon.Root.Position = UDim2.new(0, 9, 0.5, 0)

	self.GripLabel = Widgets.Label({
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

	Widgets.Draggable(Grip, Shell, nil, self.DockTrack)

	local function AddItem(Order: number, Icon: string, Text: string, Callback: () -> ()): Button
		local Item = Widgets.Button({
			Parent = Fill,
			Icon = Icon,
			Text = Text,
			Variant = "Menu",
			Align = "Left",
			Inset = 8,
			Clip = true,
			Concealed = true,
			Size = UDim2.new(1, 0, 0, 32),
			LayoutOrder = Order,
		})

		Item.OnActivated(Callback)
		table.insert(self.DockButtons, Item)
		return Item
	end

	self.EditButton = AddItem(2, Constants.Icons.Edit, "Edit", function()
		Core:SetEditMode(not Core.Session.EditMode)
	end)

	Widgets.Divider(Fill, 3, 4)

	self.UndoButton = AddItem(4, Constants.Icons.Undo, "Undo", function()
		Core:Undo()
	end)

	self.RedoButton = AddItem(5, Constants.Icons.Redo, "Redo", function()
		Core:Redo()
	end)

	Widgets.Divider(Fill, 6, 4)

	AddItem(7, Constants.Icons.Save, "Save", function()
		Core:QuickSave()
	end)

	self.AdvancedButton = AddItem(8, Constants.Icons.Advanced, "Advanced", function()
		self:ToggleAdvanced()
	end)

	AddItem(9, Constants.Icons.Settings, "Settings", function()
		Core:OpenSettings()
	end)

	self:SetHistoryState(false, false)
end

function Overlay.BuildActionBar(self: Overlay)
	local Core = self.Core

	local Shell, Fill = Widgets.Panel({
		Name = "ActionBar",
		Parent = self.Layer,
		Size = UDim2.fromOffset(372, 0),
		Position = UDim2.new(0.5, 0, 0, 12),
		AnchorPoint = Vector2.new(0.5, 0),
		AutoY = true,
		Radius = 8,
		ZIndex = 11,
		Visible = false,
	})
	self.ActionBar = Shell

	Widgets.Padding(Fill, 4, 6, 6, 6)
	Widgets.List(Fill, 2)

	local Header = New("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Parent = Fill,
	})

	self.SelectionName = Widgets.Label({
		Parent = Header,
		Text = "",
		Position = UDim2.fromOffset(6, 0),
		Size = UDim2.new(1, -96, 1, 0),
		TextTruncate = Enum.TextTruncate.AtEnd,
		Tag = "TextSecondary",
		Weight = "SemiBold",
	})

	self.SelectionSize = Widgets.Label({
		Parent = Header,
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

	Widgets.Draggable(Header, Shell, function()
		return Core.Session.BarLocked
	end)

	local Row = New("Frame", {
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Parent = Fill,
	}, { Widgets.List(nil, 4, true, Enum.HorizontalAlignment.Center) })

	local function AddAction(Order: number, Icon: string, Variant: Variant, Dependent: boolean, Callback: (() -> ())?): Button
		local Item = Widgets.Button({
			Parent = Row,
			Icon = Icon,
			Variant = Variant,
			Size = UDim2.fromOffset(38, 30),
			LayoutOrder = Order,
		})

		if Dependent then
			table.insert(self.Controls, Item)
		end
		if Callback then
			Item.OnActivated(Callback)
		end

		return Item
	end

	self.LockButton = AddAction(1, Constants.Icons.Unlock, "Menu", false, function()
		Core:SetBarLocked(not Core.Session.BarLocked)
	end)

	Widgets.Separator(Row, 2)

	Widgets.Hold(AddAction(3, Constants.Icons.Minus, "Menu", true), function()
		Core:Resize(-Core.Settings.ResizeStep)
	end)

	self.StepLabel = Widgets.Label({
		Parent = Row,
		Size = UDim2.fromOffset(38, 30),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextSize = 11,
		FontFace = MonoFace,
		Tag = "TextSecondary",
		Weight = "Regular",
		LayoutOrder = 4,
	})

	Widgets.Hold(AddAction(5, Constants.Icons.Plus, "Menu", true), function()
		Core:Resize(Core.Settings.ResizeStep)
	end)

	Widgets.Separator(Row, 6)

	AddAction(7, Constants.Icons.CenterX, "Menu", true, function()
		Core:Align("X")
	end)

	AddAction(8, Constants.Icons.CenterY, "Menu", true, function()
		Core:Align("Y")
	end)

	Widgets.Separator(Row, 9)

	AddAction(10, Constants.Icons.Reset, "Menu", true, function()
		Core:ResetSelected()
	end)

	AddAction(11, Constants.Icons.Hide, "MenuDanger", true, function()
		Core:DeleteSelected()
	end)
end

function Overlay.ToggleDock(self: Overlay)
	self.Dock.Visible = not self.Dock.Visible

	if not self.Dock.Visible then
		self.Core:SetEditMode(false)
	end
end

function Overlay.WatchDock(self: Overlay)
	local Api = self.Api

	local function Extend()
		self.DockHold = math.max(self.DockHold, os.clock() + Constants.Dock.Hold)
	end

	Api:Connect(UserInputService.InputBegan, function(Input: InputObject)
		if Util.IsPointer(Input) and self.Dock.Visible and Geometry.ContainsInput(self.Dock, Input.Position) then
			self.DockPress = Input
			Extend()
		end
	end)

	Api:Connect(UserInputService.InputEnded, function(Input: InputObject)
		local Press = self.DockPress
		if Press and Util.IsSameInput(Press, Input) then
			self.DockPress = nil
			Extend()
		end
	end)
end

function Overlay.IsDockActive(self: Overlay): boolean
	local Dock = self.Dock

	if not Dock.Visible then
		self.DockPress = nil
		self.DockHover = false
		return false
	end

	local Now = os.clock()
	local Hovering = UserInputService.MouseEnabled and Util.PointInGui(UserInputService:GetMouseLocation(), Dock)

	if self.DockHover and not Hovering then
		self.DockHold = math.max(self.DockHold, Now + Constants.Dock.Leave)
	end

	self.DockHover = Hovering

	return Hovering or self.DockPress ~= nil or Now < self.DockHold
end

function Overlay.ApplyDock(self: Overlay, Progress: number)
	local Dock = self.Dock
	local Before = Dock.Size.X.Offset
	local Width = math.round(Constants.Dock.Collapsed + (Constants.Dock.Expanded - Constants.Dock.Collapsed) * Progress)

	if Before <= Constants.Dock.Collapsed then
		self.DockLeft = Dock.AbsolutePosition.X + Dock.AbsoluteSize.X / 2 > Util.GetViewport().X / 2
	end

	self.DockProgress = Progress
	Dock.Size = UDim2.new(0, Width, Dock.Size.Y.Scale, Dock.Size.Y.Offset)

	if self.DockLeft and Width ~= Before and not self.DockTrack.Moving then
		Dock.Position = Util.Shift(Dock.Position, -(Width - Before), 0)
	end

	local Alpha = math.clamp((Progress - 0.3) / 0.7, 0, 1)

	for _, Item in self.DockButtons do
		Item.SetReveal(Alpha)
	end

	self.GripLabel.TextTransparency = 1 - Alpha
end

function Overlay.StepDock(self: Overlay, Delta: number)
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
		Progress += (Target - Progress) * (1 - math.exp(-Constants.Dock.Speed * Speed * Delta))

		if math.abs(Target - Progress) < 0.01 then
			Progress = Target
		end
	end

	self:ApplyDock(Progress)
end

function Overlay.SetReady(self: Overlay, Value: boolean)
	self.Ready = Value
	self:ApplyLauncher()
end

function Overlay.ApplyLauncher(self: Overlay)
	local Visible = self.Ready and self.Core.Settings.ShowLauncher
	self.Launcher.Visible = Visible

	if not Visible then
		self.Dock.Visible = false
	end
end

function Overlay.SetEditState(self: Overlay, Enabled: boolean)
	self.Shield.Visible = Enabled
	self.Shield.Active = Enabled
	self.ActionBar.Visible = Enabled
	self.EditButton.SetVariant(if Enabled then "Active" else "Menu")

	if not Enabled then
		self:SetSelection(nil)
	end
end

function Overlay.SetBarLocked(self: Overlay, Locked: boolean)
	self.LockButton.SetVariant(if Locked then "Active" else "Menu")
	self.LockButton.SetIcon(if Locked then Constants.Icons.Lock else Constants.Icons.Unlock)
end

function Overlay.SetHistoryState(self: Overlay, CanUndo: boolean, CanRedo: boolean)
	self.UndoButton.SetEnabled(CanUndo)
	self.RedoButton.SetEnabled(CanRedo)
end

function Overlay.SetResizeStep(self: Overlay, Value: number)
	self.StepLabel.Text = `{Value}px`
end

function Overlay.Readout(self: Overlay, Object: GuiObject)
	local Size = Object.AbsoluteSize
	local Text = string.format("%d x %d", math.round(Size.X), math.round(Size.Y))

	if self.ReadoutText == Text then
		return
	end

	self.ReadoutText = Text
	self.SelectionSize.Text = Text
	self.AdvancedSelection.Text = `{Object.Name}  {Text}`
end

function Overlay.SetSelection(self: Overlay, Object: GuiObject?)
	local Valid = Object ~= nil and Object.Parent ~= nil

	if Object and Valid then
		self.ReadoutText = nil
		self.SelectionName.Text = if self.Core:IsElementLocked(Object) then `{Object.Name} (locked)` else Object.Name
		Widgets.Retag(self.SelectionName, { TextColor3 = "Text" })
		self:Readout(Object)
	else
		self.ReadoutText = nil
		self.SelectionName.Text = "Tap an element to select"
		self.SelectionSize.Text = ""
		self.AdvancedSelection.Text = "None"
		Widgets.Retag(self.SelectionName, { TextColor3 = "TextSecondary" })
	end

	for _, Control in self.Controls do
		Control.SetEnabled(Valid)
	end
end

function Overlay.NewPage(self: Overlay, Parent: Instance, Name: string): Frame
	return New("Frame", {
		Name = Name,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Visible = false,
		Parent = Parent,
	}, { Widgets.List(nil, 2) })
end

function Overlay.BuildAdvanced(self: Overlay)
	local Core = self.Core

	local Shell, Fill = Widgets.Panel({
		Name = "Advanced",
		Parent = self.Layer,
		Size = UDim2.fromOffset(340, 0),
		Position = UDim2.new(0, 68, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		AutoY = true,
		Radius = 8,
		ZIndex = 10,
		Visible = false,
	})
	self.Advanced = Shell

	Widgets.Padding(Fill, 6, 8, 8, 8)
	Widgets.List(Fill, 6)

	local Header = New("Frame", {
		Name = "Header",
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Parent = Fill,
	})

	Widgets.Label({
		Parent = Header,
		Text = "Advanced",
		Position = UDim2.fromOffset(8, 0),
		Size = UDim2.new(1, -72, 1, 0),
		Weight = "SemiBold",
		TextSize = 13,
	})

	local function HeaderButton(Icon: string, Offset: number, Callback: () -> ())
		Widgets.Button({
			Parent = Header,
			Icon = Icon,
			Variant = "Menu",
			Size = UDim2.fromOffset(26, 26),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, Offset, 0.5, 0),
			IconSize = 14,
			Radius = 7,
		}).OnActivated(Callback)
	end

	HeaderButton(Constants.Icons.Close, 0, function()
		self:SetAdvancedVisible(false)
	end)

	HeaderButton(Constants.Icons.Settings, -30, function()
		Core:OpenSettings()
	end)

	Widgets.Draggable(Header, Shell)

	self.Tabs = Widgets.Segmented(Fill, 2, UDim2.new(1, 0, 0, 30), { "Adjust", "Elements", "Map", "Options" }, "Adjust", function(Value: string)
		self:SetAdvancedPage(Value)
	end)

	self.Scroll = Widgets.Scroll(Fill, 3, 200)

	self.PagesBody = New("Frame", {
		Name = "Pages",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = self.Scroll,
	}, { New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }) })

	self.Pages = {
		Adjust = self:BuildAdjustPage(self.PagesBody),
		Elements = self:BuildElementsPage(self.PagesBody),
		Map = self:BuildMapPage(self.PagesBody),
		Options = self:BuildOptionsPage(self.PagesBody),
	}

	self:SetAdvancedPage("Adjust")
end

function Overlay.AddSegmentRow(self: Overlay, Parent: Instance, Order: number, Title: string, Key: string, Options: { any }, Width: number)
	local Core = self.Core
	local _, Right = Widgets.Row(Parent, Order, Title)

	local Item = Widgets.Segmented(Right, 1, UDim2.fromOffset(Width, 28), Options, Core.Settings[Key], function(Value: any)
		Core:SetSetting(Key, Value)
	end)

	self:Bind(Key, function(Value: any)
		Item.SetValue(Value, true)
	end)
end

function Overlay.BuildAdjustPage(self: Overlay, Parent: Instance): Frame
	local Core = self.Core
	local Page = self:NewPage(Parent, "Adjust")

	local _, SelectionRight = Widgets.Row(Page, 1, "Selection")
	self.AdvancedSelection = Widgets.Label({
		Parent = SelectionRight,
		Text = "None",
		Size = UDim2.new(1, 0, 0, 16),
		TextXAlignment = Enum.TextXAlignment.Right,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Tag = "TextSecondary",
		Weight = "Regular",
	})

	Widgets.Divider(Page, 2, 6)

	local _, MoveRight = Widgets.Row(Page, 3, "Move", 74)
	local Pad = New("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(108, 63), Parent = MoveRight })

	local Cells = {
		{ Icon = Constants.Icons.Up, Column = 1, Row = 0, X = 0, Y = -1 },
		{ Icon = Constants.Icons.Left, Column = 0, Row = 1, X = -1, Y = 0 },
		{ Icon = Constants.Icons.Down, Column = 1, Row = 1, X = 0, Y = 1 },
		{ Icon = Constants.Icons.Right, Column = 2, Row = 1, X = 1, Y = 0 },
	}

	for _, Cell in Cells do
		local Item = Widgets.Button({
			Parent = Pad,
			Icon = Cell.Icon,
			Variant = "Subtle",
			Size = UDim2.fromOffset(34, 30),
			Position = UDim2.fromOffset(Cell.Column * 37, Cell.Row * 33),
		})

		table.insert(self.Controls, Item)

		Widgets.Hold(Item, function()
			local Step = Core.Settings.NudgeStep
			Core:Nudge(Cell.X * Step, Cell.Y * Step)
		end)
	end

	self:AddSegmentRow(Page, 4, "Nudge step", "NudgeStep", Constants.NudgeSteps, 160)

	Widgets.Divider(Page, 5, 6)

	local function AddGroup(Order: number, Title: string, Items: { { Icon: string?, Text: string?, Width: number?, Variant: Variant? } }): { Button }
		local _, Right = Widgets.Row(Page, Order, Title)
		local Buttons = Widgets.Group(Right, 1, Items)

		for _, Item in Buttons do
			table.insert(self.Controls, Item)
		end

		return Buttons
	end

	local Resize = AddGroup(6, "Resize", {
		{ Icon = Constants.Icons.Minus, Width = 34 },
		{ Icon = Constants.Icons.Plus, Width = 34 },
	})

	Widgets.Hold(Resize[1], function()
		Core:Resize(-Core.Settings.ResizeStep)
	end)

	Widgets.Hold(Resize[2], function()
		Core:Resize(Core.Settings.ResizeStep)
	end)

	local Center = AddGroup(7, "Center", {
		{ Icon = Constants.Icons.CenterX, Width = 34 },
		{ Icon = Constants.Icons.CenterY, Width = 34 },
	})

	Center[1].OnActivated(function()
		Core:Align("X")
	end)

	Center[2].OnActivated(function()
		Core:Align("Y")
	end)

	local Element = AddGroup(8, "Element", {
		{ Text = "Reset", Width = 54 },
		{ Text = "Hide", Width = 48, Variant = "MenuDanger" },
	})

	Element[1].OnActivated(function()
		Core:ResetSelected()
	end)

	Element[2].OnActivated(function()
		Core:DeleteSelected()
	end)

	return Page
end

function Overlay.BuildElementsPage(self: Overlay, Parent: Instance): Frame
	local Core = self.Core
	local Page = self:NewPage(Parent, "Elements")
	local Filter = "All"
	local Query = ""
	local Rows: { Frame } = {}
	local Pending = false

	local Summary = Widgets.Label({
		Parent = Page,
		Size = UDim2.new(1, 0, 0, 22),
		TextSize = 11,
		Tag = "TextSecondary",
		Weight = "Regular",
		LayoutOrder = 1,
	})
	Widgets.Padding(Summary, 0, 0, 0, 8)

	local Rebuild: () -> ()

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

	Widgets.Field(Page, 2, "Search", function(Text: string)
		Query = string.lower(Util.Trim(Text))
		Schedule()
	end)

	Widgets.Segmented(Page, 3, UDim2.new(1, 0, 0, 30), { "All", "Hidden", "Moved", "Resized" }, Filter, function(Value: string)
		Filter = Value
		Schedule()
	end)

	local List = Widgets.Scroll(Page, 4, 64)
	New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = List })

	local Empty = Widgets.Label({
		Parent = List,
		Text = "Nothing to show",
		Size = UDim2.new(1, 0, 0, 56),
		TextXAlignment = Enum.TextXAlignment.Center,
		Tag = "TextSecondary",
		Weight = "Regular",
	})

	local function Matches(Key: string, Rule: Rule): boolean
		if Query ~= "" and not string.find(string.lower(Rule.Name .. " " .. Key), Query, 1, true) then
			return false
		end

		if Filter == "Hidden" then
			return Rule.IsDeleted
		elseif Filter == "Moved" then
			return not Rule.IsDeleted
		elseif Filter == "Resized" then
			return Rule.SizeModified
		end

		return true
	end

	local function Describe(Rule: Rule): string
		if Rule.IsDeleted then
			return "Hidden"
		end

		return if Rule.SizeModified then "Moved and resized" else "Moved"
	end

	local function CreateRow(Key: string, Rule: Rule, Order: number)
		local Row = Widgets.Fill({
			Size = UDim2.new(1, -4, 0, 40),
			LayoutOrder = Order,
			Parent = List,
		}, "Hover", 0.94, { Widgets.Corner(8), Widgets.Stroke("ElementBorder", 0.92) })

		New("Frame", {
			Name = "Marker",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 7, 0.5, 0),
			Size = UDim2.fromOffset(3, 20),
			BorderSizePixel = 0,
			ThemeTag = { BackgroundColor3 = if Rule.IsDeleted then "Danger" else "Accent" },
			Parent = Row,
		}, { Widgets.Corner(2) })

		Widgets.Label({
			Parent = Row,
			Text = Rule.Name,
			Position = UDim2.fromOffset(18, 5),
			Size = UDim2.new(1, -86, 0, 16),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Weight = "SemiBold",
		})

		Widgets.Label({
			Parent = Row,
			Text = Describe(Rule),
			Position = UDim2.fromOffset(18, 21),
			Size = UDim2.new(1, -86, 0, 14),
			TextSize = 11,
			Tag = if Rule.IsDeleted then "Danger" else "TextSecondary",
			Weight = "Regular",
		})

		local function RowButton(Icon: string, Offset: number, Callback: () -> ())
			Widgets.Button({
				Parent = Row,
				Icon = Icon,
				Variant = "Menu",
				Size = UDim2.fromOffset(26, 26),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, Offset, 0.5, 0),
				IconSize = 14,
				Radius = 7,
			}).OnActivated(Callback)
		end

		RowButton(Constants.Icons.Reset, -6, function()
			Core:RestoreKey(Key)
		end)

		if not Rule.IsDeleted then
			RowButton(Constants.Icons.Focus, -36, function()
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
			if Matches(Key, Rule) then
				Order += 1
				CreateRow(Key, Rule, Order)
			end
		end

		Empty.Visible = Order == 0
		List.Size = UDim2.new(1, 0, 0, math.clamp(Order * 44, 64, 200))

		local Counts: Counts = Core.Book:Counts()
		Summary.Text = string.format("%d modified  |  %d hidden  |  %d resized  |  %d in history", Counts.Total, Counts.Hidden, Counts.Resized, #Core.History.Undos)
	end

	local Armed = 0
	local ResetAll = Widgets.Button({
		Parent = Page,
		Text = "Reset all changes",
		Variant = "Danger",
		Size = UDim2.new(1, 0, 0, 30),
		LayoutOrder = 5,
	})

	ResetAll.OnActivated(function()
		if Core.Book:Counts().Total == 0 then
			return Core:Toast("Nothing to reset")
		end

		if Armed > 0 and os.clock() - Armed < 3 then
			Armed = 0
			ResetAll.SetText("Reset all changes")
			return Core:ResetAll()
		end

		local Stamp = os.clock()
		Armed = Stamp
		ResetAll.SetText("Tap again to confirm")

		task.delay(3, function()
			if Armed == Stamp then
				Armed = 0
				ResetAll.SetText("Reset all changes")
			end
		end)
	end)

	self.Api:Connect(Core.Book.Changed, Schedule)
	self.Api:Connect(Core.History.Changed, Schedule)
	Rebuild()

	return Page
end

function Overlay.BuildOptionsPage(self: Overlay, Parent: Instance): Frame
	local Core = self.Core
	local Page = self:NewPage(Parent, "Options")
	local Order = 0

	local function Next(): number
		Order += 1
		return Order
	end

	local function AddSwitch(Title: string, Key: string)
		local _, Right = Widgets.Row(Page, Next(), Title)

		local Item = Widgets.Switch(Right, Core.Settings[Key], function(Value: boolean)
			Core:SetSetting(Key, Value)
		end)

		self:Bind(Key, function(Value: boolean)
			Item.SetValue(Value, true)
		end)
	end

	local function AddStepper(Title: string, Key: string, Min: number, Max: number)
		local _, Right = Widgets.Row(Page, Next(), Title)

		local Item = Widgets.Stepper(Right, Min, Max, Core.Settings[Key], " px", function(Value: number)
			Core:SetSetting(Key, Value)
		end)

		self:Bind(Key, function(Value: number)
			Item.SetValue(Value, true)
		end)
	end

	AddSwitch("Group linked elements", "GroupCluster")
	AddSwitch("Respect locks", "RespectLocks")
	AddSwitch("Shortcuts", "Shortcuts")
	Widgets.Divider(Page, Next(), 6)
	self:AddSegmentRow(Page, Next(), "Selection", "SelectionMode", { "Smart", "Exact" }, 130)
	self:AddSegmentRow(Page, Next(), "Axis", "Axis", { "Free", "Horizontal", "Vertical" }, 190)
	Widgets.Divider(Page, Next(), 6)
	AddStepper("Resize step", "ResizeStep", 1, 50)
	AddStepper("Snap size", "SnapSize", 0, 50)

	return Page
end

function Overlay.BuildMapPage(self: Overlay, Parent: Instance): Frame
	local Page = self:NewPage(Parent, "Map")
	local Viewport = Util.GetViewport()

	local Body = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 180),
		LayoutOrder = 1,
		Parent = Page,
	})

	local Ratio = New("UIAspectRatioConstraint", {
		AspectRatio = Viewport.X / math.max(Viewport.Y, 1),
		DominantAxis = Enum.DominantAxis.Height,
		AspectType = Enum.AspectType.FitWithinMaxSize,
	})

	local Surface = Widgets.Fill({
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = true,
		Parent = Body,
	}, "Hover", 0.94, { Widgets.Corner(8), Widgets.Stroke("ElementBorder", 0.85), Ratio })

	local Legend = Widgets.Label({
		Parent = Page,
		Text = "Accent selected, gray moved, red hidden",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		TextSize = 11,
		Tag = "TextSecondary",
		Weight = "Regular",
		LayoutOrder = 2,
	})
	Widgets.Padding(Legend, 4, 8, 0, 8)

	self.Map = { Surface = Surface, Ratio = Ratio, Boxes = {}, Kinds = {} }

	return Page
end

function Overlay.DrawMap(self: Overlay, Object: GuiObject, Kind: string, Screen: Vector2, Seen: { [GuiObject]: boolean })
	local Map = self.Map

	if not Object.Parent or Seen[Object] then
		return
	end

	Seen[Object] = true

	local Palette = MapPalette[Kind]
	local Box = Map.Boxes[Object]

	if not Box then
		Box = New("TextButton", {
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			ThemeTag = { BackgroundColor3 = Palette.Tag },
			Parent = Map.Surface,
		})

		Box.Activated:Connect(function()
			self.Core:FocusObject(Object)
		end)

		Map.Boxes[Object] = Box
	end

	if Map.Kinds[Box] ~= Kind then
		Map.Kinds[Box] = Kind
		Widgets.Retag(Box, { BackgroundColor3 = Palette.Tag })
		Box.BackgroundTransparency = Palette.Transparency
	end

	local Position = Geometry.ScreenPosition(Object)
	local Size = Object.AbsoluteSize

	Box.Position = UDim2.fromScale(Position.X / Screen.X, Position.Y / Screen.Y)
	Box.Size = UDim2.fromScale(math.max(Size.X / Screen.X, 0.008), math.max(Size.Y / Screen.Y, 0.008))
end

function Overlay.SyncMap(self: Overlay)
	local Map = self.Map
	local Screen = Util.GetViewport()

	if Screen.X <= 0 or Screen.Y <= 0 then
		return
	end

	local Seen: { [GuiObject]: boolean } = {}
	local Core = self.Core
	local Session: Session = Core.Session

	if Session.Selected then
		self:DrawMap(Session.Selected, "Selected", Screen, Seen)
	end

	for _, Member in Session.Cluster do
		self:DrawMap(Member, "Selected", Screen, Seen)
	end

	for Object, Key in Core.Book.Tracked do
		local Rule = Core.Book.Rules[Key]
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

function Overlay.Tick(self: Overlay, Delta: number)
	self:StepDock(Delta)

	if not self.Advanced.Visible or self.ActivePage ~= "Map" then
		return
	end

	local Now = os.clock()
	if Now - self.LastMap >= Constants.MapInterval then
		self.LastMap = Now
		self:SyncMap()
	end
end

function Overlay.SetAdvancedPage(self: Overlay, Name: string)
	self.ActivePage = Name

	for Key, Page in self.Pages do
		Page.Visible = Key == Name
	end

	if Name == "Map" then
		self:SyncMap()
	end
end

function Overlay.SetAdvancedVisible(self: Overlay, Visible: boolean)
	self.Advanced.Visible = Visible
	self.AdvancedButton.SetVariant(if Visible then "Active" else "Menu")

	if Visible and self.ActivePage == "Map" then
		self:SyncMap()
	end
end

function Overlay.ToggleAdvanced(self: Overlay)
	self:SetAdvancedVisible(not self.Advanced.Visible)
end

--// ProfileStore \\

local ProfileStore = {}

function ProfileStore.GameFolder(Core: any): string
	return `{Core.Folder}/Profiles/{Core.GameId}`
end

function ProfileStore.Path(Core: any, Name: string): string
	return `{ProfileStore.GameFolder(Core)}/{Name}.json`
end

function ProfileStore.AutoloadPath(Core: any): string
	return `{ProfileStore.GameFolder(Core)}/autoload.txt`
end

function ProfileStore.Pack(Rules: { [string]: Rule }): { [string]: PackedRule }
	local Packed = {}

	for Key, Rule in Rules do
		Packed[Key] = {
			Name = Rule.Name,
			IsDeleted = Rule.IsDeleted,
			Position = Util.PackUDim2(Rule.Position),
			Size = Util.PackUDim2(Rule.Size),
			SizeModified = Rule.SizeModified,
		}
	end

	return Packed
end

function ProfileStore.Wrap(Core: any, Rules: { [string]: Rule }): Profile
	return {
		Version = Constants.FormatVersion,
		GameId = Core.GameId,
		GameName = Core.GameName,
		SavedAt = os.time(),
		Rules = ProfileStore.Pack(Rules),
	}
end

function ProfileStore.Decode(Data: { [any]: any }): ({ [string]: Rule }, number)
	local Source = if type(Data.Rules) == "table" then Data.Rules else Data
	local Rules: { [string]: Rule } = {}
	local Count = 0

	for Key, Item in Source do
		if type(Key) ~= "string" or type(Item) ~= "table" then
			continue
		end

		local Position = Util.UnpackUDim2(Item.Position)
		local Size = Util.UnpackUDim2(Item.Size)

		if Position and Size then
			Rules[Key] = {
				Name = tostring(Item.Name or Key),
				IsDeleted = Item.IsDeleted == true,
				Position = Position,
				Size = Size,
				SizeModified = Item.SizeModified == true,
			}
			Count += 1
		end
	end

	return Rules, Count
end

function ProfileStore.List(Core: any): { string }
	local Names = {}
	local Folder = ProfileStore.GameFolder(Core)

	if not Util.HasFileSystem() or not isfolder(Folder) then
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

function ProfileStore.Write(Core: any, Name: string, Rules: { [string]: Rule }): (boolean, string?)
	if Name == "" then
		return false, "invalid profile name"
	end

	if not Util.HasFileSystem() then
		return false, "file system unavailable"
	end

	Core:BuildFolderTree()
	return Util.WriteJson(ProfileStore.Path(Core, Name), ProfileStore.Wrap(Core, Rules))
end

function ProfileStore.Save(Core: any, Name: string): (boolean, string?)
	Name = Util.SanitizeName(Name)

	local Success, Problem = ProfileStore.Write(Core, Name, Core.Book.Rules)
	if Success then
		Core.ActiveProfile = Name
	end

	return Success, Problem
end

function ProfileStore.Load(Core: any, Name: string?, Merge: boolean): (boolean, string?)
	if Util.IsBlank(Name) then
		return false, "no profile selected"
	end

	local Data = Util.ReadJson(ProfileStore.Path(Core, Name :: string))
	if not Data then
		return false, "profile not found"
	end

	local Rules = ProfileStore.Decode(Data)
	Core:ReplaceRules(Rules, Merge, `Load {Name}`)
	Core.ActiveProfile = Name
	return true, nil
end

function ProfileStore.GetAutoload(Core: any): string?
	local Path = ProfileStore.AutoloadPath(Core)

	if not Util.HasFileSystem() or not isfile(Path) then
		return nil
	end

	local Name = Util.Trim(readfile(Path))
	return if Name ~= "" and isfile(ProfileStore.Path(Core, Name)) then Name else nil
end

function ProfileStore.SetAutoload(Core: any, Name: string?): boolean
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

function ProfileStore.Delete(Core: any, Name: string)
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

function ProfileStore.Export(Core: any, Name: string): (boolean, string?)
	local Path = ProfileStore.Path(Core, Name)

	if type(setclipboard) ~= "function" or not isfile(Path) then
		return false, "clipboard or profile unavailable"
	end

	setclipboard(readfile(Path))
	return true, nil
end

function ProfileStore.ImportText(Core: any, Name: string, Text: string): (boolean, any)
	local Decoded, Data = pcall(HttpService.JSONDecode, HttpService, Text)
	if not Decoded or type(Data) ~= "table" then
		return false, "text is not valid JSON"
	end

	local Rules, Count = ProfileStore.Decode(Data)
	if Count == 0 then
		return false, "no valid rules found"
	end

	local Success, Problem = ProfileStore.Write(Core, Util.SanitizeName(Name), Rules)
	if not Success then
		return false, Problem
	end

	return true, Count
end

function ProfileStore.ImportLegacy(Core: any): number
	if not Util.HasFileSystem() or not isfolder(Constants.LegacyFolder) then
		return 0
	end

	local Suffix = `_{Core.GameId}.json`
	local Imported = 0

	for _, File in listfiles(Constants.LegacyFolder) do
		local FileName = string.match(string.gsub(File, "\\", "/"), "([^/]+)$") or ""

		if string.sub(FileName, -#Suffix) ~= Suffix then
			continue
		end

		local Name = Util.SanitizeName(string.sub(FileName, 1, #FileName - #Suffix))
		local Data = Util.ReadJson(File)

		if Name ~= "" and Data and not isfile(ProfileStore.Path(Core, Name)) then
			local Rules, Count = ProfileStore.Decode(Data)
			if Count > 0 and ProfileStore.Write(Core, Name, Rules) then
				Imported += 1
			end
		end
	end

	return Imported
end

--// Controller \\

local Directions: { [Enum.KeyCode]: Vector2 } = {
	[Enum.KeyCode.Left] = Vector2.new(-1, 0),
	[Enum.KeyCode.Right] = Vector2.new(1, 0),
	[Enum.KeyCode.Up] = Vector2.new(0, -1),
	[Enum.KeyCode.Down] = Vector2.new(0, 1),
}

local function NewSession(): Session
	return { EditMode = false, Selected = nil, Cluster = {}, BarLocked = false, Drag = nil }
end

local function NewSettings(): Settings
	return {
		ResizeStep = 15,
		NudgeStep = 5,
		SnapSize = 0,
		Axis = "Free",
		SelectionMode = "Smart",
		GroupCluster = true,
		ShowLauncher = true,
		RespectLocks = true,
		Shortcuts = true,
		LoadMode = "Replace",
	}
end

local HUDManager = {}
HUDManager.__index = HUDManager

type ManagerFields = {
	Version: string,
	Folder: string,
	Library: any,
	Extension: any,
	SaveManager: any,
	Api: any,
	Overlay: Overlay,
	Book: RuleBook,
	History: History,
	Tab: any,
	ControlSection: any,
	Started: boolean,
	GameId: string,
	GameName: string,
	ActiveProfile: string?,
	ScanToken: number,
	Settings: Settings,
	Session: Session,
	Bindings: { [string]: { string } },
	Presses: { [InputObject]: Press },
	Signals: {
		StateChanged: Signal<boolean>,
		SelectionChanged: Signal<GuiObject?>,
		SettingChanged: Signal<string, any>,
	},
}

export type Manager = typeof(setmetatable({} :: ManagerFields, HUDManager))

function HUDManager.SetLibrary(self: Manager, Library: any)
	self.Library = Library
end

function HUDManager.SetExtension(self: Manager, Extension: any)
	self.Extension = Extension
end

function HUDManager.SetSaveManager(self: Manager, SaveManager: any)
	self.SaveManager = SaveManager
end

function HUDManager.SetFolder(self: Manager, Folder: string)
	self.Folder = Folder
	self:BuildFolderTree()
end

function HUDManager.BuildFolderTree(self: Manager)
	Util.EnsureFolder(`{self.Folder}/Profiles`)
	Util.EnsureFolder(ProfileStore.GameFolder(self))
end

function HUDManager.Notify(self: Manager, Content: string, SubContent: string?)
	self.Library:Notify({ Title = "HUD Manager", Content = Content, SubContent = SubContent, Duration = 4 })
end

function HUDManager.Toast(self: Manager, Text: string)
	self.Library:Toast(Text, 2)
end

function HUDManager.IsOwned(self: Manager, Gui: GuiObject): boolean
	local Library = self.Library
	local Root = if Gui:IsA("ScreenGui") then Gui else Gui:FindFirstAncestorOfClass("ScreenGui")

	if not Root then
		return false
	end

	return Root == Library.GUI or Root == Library.MenuGUI or string.sub(Root.Name, 1, 11) == "FluentLayer"
end

function HUDManager.Start(self: Manager): Manager
	if self.Started then
		return self
	end

	assert(self.Library and self.Extension, "HUDManager - call SetLibrary and SetExtension first")

	self.Extension:Define({
		Id = Constants.Id,
		Name = "HUD Manager",
		Version = Constants.Version,
		Load = function(Api: any)
			self:Mount(Api)
		end,
		Unload = function()
			self:Unmount()
		end,
	})

	assert(self.Started, "HUDManager - extension failed to load")
	return self
end

function HUDManager.Mount(self: Manager, Api: any)
	self.Api = Api
	self.Book = RuleBook.new()
	self.History = History.new(Constants.HistoryLimit)
	self.Session = NewSession()
	self.Presses = {}
	self.Started = true

	self:BuildFolderTree()

	local Interface = Overlay.new(self, Api)
	self.Overlay = Interface

	Api:Connect(UserInputService.InputBegan, function(Input: InputObject)
		self:OnInputBegan(Input)
	end)

	Api:Connect(UserInputService.InputChanged, function(Input: InputObject)
		self:OnInputChanged(Input)
	end)

	Api:Connect(UserInputService.InputEnded, function(Input: InputObject)
		self:OnInputEnded(Input)
	end)

	Api:Connect(PlayerGui.DescendantAdded, function(Object: Instance)
		if not self.Book:IsEmpty() then
			task.defer(self.Track, self, Object)
		end
	end)

	Api:Connect(self.History.Changed, function()
		Interface:SetHistoryState(#self.History.Undos > 0, #self.History.Redos > 0)
	end)

	pcall(RunService.UnbindFromRenderStep, RunService, Constants.RenderStep)
	RunService:BindToRenderStep(Constants.RenderStep, Constants.RenderPriority, function(Delta: number)
		self:Enforce(Delta)
	end)

	Api:Track(function()
		pcall(RunService.UnbindFromRenderStep, RunService, Constants.RenderStep)
	end, "render-step")

	Api:Spawn(function()
		local Success, Info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, game.PlaceId)
		if Success and type(Info) == "table" and Info.Name then
			self.GameName = Util.SanitizeName(Info.Name)
		end
	end)

	Api:OnIntroFinished(function()
		Interface:SetReady(true)
	end)

	self:IgnoreSaveIndexes({ "HudEditMode", "HudProfileName", "HudProfileList", "HudProfileImport" })
end

function HUDManager.Unmount(self: Manager)
	self.Started = false
	self.ScanToken += 1
	self.Overlay = nil :: any
	self.Session = NewSession()
	self.Signals.StateChanged:Fire(false)
end

function HUDManager.Destroy(self: Manager, Restore: boolean?)
	if not self.Started then
		return
	end

	if Restore then
		self.Book:Clear()
	end

	self.Extension:Disable(Constants.Id)
end

--// Scanner \\

function HUDManager.Track(self: Manager, Object: Instance)
	if not Object:IsA("GuiObject") or self.Book:IsEmpty() or self:IsOwned(Object) then
		return
	end

	local Key = KeyResolver.Resolve(Object)
	if self.Book.Rules[Key] then
		self.Book:Capture(Object, Key)
		self.Book.Tracked[Object] = Key
	end
end

function HUDManager.Rescan(self: Manager)
	self.ScanToken += 1
	local Token = self.ScanToken

	task.spawn(function()
		local Success, Descendants = pcall(PlayerGui.GetDescendants, PlayerGui)
		if not Success then
			return
		end

		for Index, Object in Descendants do
			if Token ~= self.ScanToken or not self.Started then
				return
			end

			self:Track(Object)

			if Index % Constants.ScanBatch == 0 then
				task.wait()
			end
		end
	end)
end

function HUDManager.Enforce(self: Manager, Delta: number)
	local Overlay = self.Overlay
	if not Overlay then
		return
	end

	Overlay:Reflect(self.Session)
	Overlay:Tick(Delta)

	local Book = self.Book
	if Book:IsEmpty() then
		return
	end

	local Dragged = if self.Session.Drag then self.Session.Drag.Set else nil

	for Object, Key in Book.Tracked do
		local Rule = Book.Rules[Key]

		if not Object.Parent or not Rule then
			Book.Tracked[Object] = nil
			continue
		end

		if not Rule.IsDeleted then
			LayoutBaker.Bake(Book, Object.Parent)
		end

		local Result = Book:Apply(Object, Key, Dragged ~= nil and Dragged[Object] == true, self:IsYielding(Object))
		if Result == "Adopt" then
			self:AdoptPosition(Object, Key)
		end
	end
end

--// Input \\

function HUDManager.OnShieldPressed(self: Manager, Input: InputObject)
	if not Util.IsPointer(Input) or not self.Session.EditMode or self:IsOverWindow() then
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

function HUDManager.IsOverWindow(self: Manager): boolean
	local Window = self.Library.Window
	if not (Window and Window.Root and Window.Root.Visible) then
		return false
	end

	return Util.PointInGui(UserInputService:GetMouseLocation(), Window.Root)
end

function HUDManager.OnInputBegan(self: Manager, Input: InputObject)
	if Input.UserInputType == Enum.UserInputType.Keyboard then
		return self:OnKey(Input)
	end

	if not Util.IsPointer(Input) or self.Session.EditMode or self.Book:IsEmpty() then
		return
	end

	local Objects: { [GuiObject]: boolean } = {}
	local Found = false

	for Object, Key in self.Book.Tracked do
		local Rule = self.Book.Rules[Key]

		if Rule and not Rule.IsDeleted and Object.Parent and Object.Visible and Geometry.ContainsInput(Object, Input.Position) then
			Objects[Object] = true
			Found = true
		end
	end

	if Found then
		self.Presses[Input] = { Origin = Vector2.new(Input.Position.X, Input.Position.Y), Moved = false, Objects = Objects }
	end
end

function HUDManager.OnKey(self: Manager, Input: InputObject)
	if not (self.Settings.Shortcuts and self.Session.EditMode) or UserInputService:GetFocusedTextBox() then
		return
	end

	local Code = Input.KeyCode
	local Shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
	local Direction = Directions[Code]

	if Direction then
		local Step = self.Settings.NudgeStep * (if Shift then 5 else 1)
		self:Nudge(Direction.X * Step, Direction.Y * Step)
	elseif Code == Enum.KeyCode.Z then
		if Shift then
			self:Redo()
		else
			self:Undo()
		end
	elseif Code == Enum.KeyCode.Y then
		self:Redo()
	elseif Code == Enum.KeyCode.Delete or Code == Enum.KeyCode.Backspace then
		self:DeleteSelected()
	elseif Code == Enum.KeyCode.Escape then
		if self:HasSelection() then
			self:ClearSelection()
		else
			self:SetEditMode(false)
		end
	end
end

function HUDManager.OnInputChanged(self: Manager, Input: InputObject)
	for Key, Press in self.Presses do
		if not Press.Moved and Util.IsTracking(Key, Input) then
			local Travel = Vector2.new(Input.Position.X, Input.Position.Y) - Press.Origin
			Press.Moved = Travel.Magnitude >= Constants.TapThreshold
		end
	end

	local Drag = self.Session.Drag
	if Drag and Util.IsTracking(Drag.Input, Input) then
		self:UpdateDrag(Input)
	end
end

function HUDManager.OnInputEnded(self: Manager, Input: InputObject)
	for Key in self.Presses do
		if Util.IsSameInput(Key, Input) then
			self.Presses[Key] = nil
		end
	end

	local Drag = self.Session.Drag
	if Drag and Util.IsSameInput(Drag.Input, Input) then
		self:EndDrag()
	end
end

function HUDManager.IsYielding(self: Manager, Object: GuiObject): boolean
	for _, Press in self.Presses do
		if Press.Moved and Press.Objects[Object] then
			return true
		end
	end

	return false
end

function HUDManager.AdoptPosition(self: Manager, Object: GuiObject, Key: string)
	local Rule = self.Book.Rules[Key]
	if not Rule then
		return
	end

	local Before = self.Book:Snapshot(Key)
	Rule.Position = Object.Position

	self.History:Push("Move", { { Key = Key, Before = Before, After = self.Book:Snapshot(Key) } })
	self.Book.Changed:Fire()
end

function HUDManager.IsElementLocked(self: Manager, Object: GuiObject): boolean
	if not self.Settings.RespectLocks then
		return false
	end

	local Current: Instance? = Object

	while Current and Current ~= PlayerGui do
		if Current:GetAttribute(Constants.LockAttribute) == true then
			return true
		end

		Current = Current.Parent
	end

	return false
end

function HUDManager.PickAt(self: Manager, Position: Vector3): GuiObject?
	local Success, Hits = pcall(PlayerGui.GetGuiObjectsAtPosition, PlayerGui, Position.X, Position.Y)
	if not Success or type(Hits) ~= "table" then
		return nil
	end

	return Picker.Pick(Hits, Util.GetViewport(), self.Settings.SelectionMode, function(Gui: GuiObject)
		return not self:IsOwned(Gui)
	end)
end

--// Selection \\

function HUDManager.PrepareElement(self: Manager, Object: GuiObject)
	self.Book:Capture(Object, KeyResolver.Resolve(Object))
	LayoutBaker.Bake(self.Book, Object.Parent)
end

function HUDManager.SelectObject(self: Manager, Object: GuiObject)
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

function HUDManager.ClearSelection(self: Manager)
	self.Session.Selected = nil
	self.Session.Cluster = {}

	if self.Overlay then
		self.Overlay:SetSelection(nil)
	end

	self.Signals.SelectionChanged:Fire(nil)
end

function HUDManager.HasSelection(self: Manager): boolean
	return self.Session.Selected ~= nil and #self.Session.Cluster > 0
end

function HUDManager.RequireSelection(self: Manager): boolean
	if self:HasSelection() then
		return true
	end

	self:Toast("Select an element first")
	return false
end

function HUDManager.SetEditMode(self: Manager, Enabled: boolean)
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

function HUDManager.SetBarLocked(self: Manager, Locked: boolean)
	if self.Session.BarLocked ~= Locked then
		self.Session.BarLocked = Locked
		self.Overlay:SetBarLocked(Locked)
	end
end

--// Settings \\

function HUDManager.SetSetting(self: Manager, Key: string, Value: any)
	local Settings = self.Settings :: any
	if Settings[Key] == Value then
		return
	end

	Settings[Key] = Value
	self:SyncOptions(Key)
	self.Signals.SettingChanged:Fire(Key, Value)

	local Overlay = self.Overlay
	if not Overlay then
		return
	end

	Overlay:Sync(Key, Value)

	if Key == "ShowLauncher" then
		self:ApplyLauncherState()
	elseif Key == "ResizeStep" then
		Overlay:SetResizeStep(Value)
	elseif Key == "RespectLocks" then
		Overlay:SetSelection(self.Session.Selected)
	end
end

function HUDManager.BindOption(self: Manager, Key: string, Idx: string)
	local List = self.Bindings[Key]

	if not List then
		List = {}
		self.Bindings[Key] = List
	end

	if not table.find(List, Idx) then
		table.insert(List, Idx)
	end
end

function HUDManager.SyncOptions(self: Manager, Key: string)
	local Settings = self.Settings :: any

	for _, Idx in self.Bindings[Key] or {} do
		local Option = self.Library.Options[Idx]

		if Option and Option.Value ~= Settings[Key] then
			pcall(Option.SetValue, Option, Settings[Key])
		end
	end
end

function HUDManager.ApplyLauncherState(self: Manager)
	if self.Overlay then
		self.Overlay:ApplyLauncher()
	end

	if self.ControlSection then
		self.ControlSection:SetVisible(not self.Settings.ShowLauncher)
	end
end

--// Drag \\

function HUDManager.BeginDrag(self: Manager, Input: InputObject)
	self.Session.Drag = {
		Input = Input,
		Origin = Input.Position,
		Moved = false,
		Set = {},
		Start = {},
		Keys = {},
		Before = {},
	}
end

function HUDManager.BeginDragMutation(self: Manager, Drag: Drag)
	local Skipped = 0

	for _, Object in self.Session.Cluster do
		if self:IsElementLocked(Object) then
			Skipped += 1
			continue
		end

		local Key = KeyResolver.Resolve(Object)
		Drag.Before[Key] = self.Book:Snapshot(Key)

		local Rule = self.Book:Ensure(Object, Key)
		Drag.Start[Object] = Rule.Position
		Drag.Keys[Object] = Key
		Drag.Set[Object] = true
	end

	if Skipped > 0 and next(Drag.Start) == nil then
		self:Toast("Element is locked, unlock it first")
	end
end

function HUDManager.UpdateDrag(self: Manager, Input: InputObject)
	local Drag = self.Session.Drag
	if not Drag then
		return
	end

	local Raw = Input.Position - Drag.Origin
	local Delta = Vector2.new(Raw.X, Raw.Y)

	if not Drag.Moved then
		if Delta.Magnitude < Constants.DragSlop then
			return
		end

		self:BeginDragMutation(Drag)
		Drag.Moved = true
	end

	local Settings = self.Settings
	local X = if Settings.Axis == "Vertical" then 0 else Util.Snap(Delta.X, Settings.SnapSize)
	local Y = if Settings.Axis == "Horizontal" then 0 else Util.Snap(Delta.Y, Settings.SnapSize)

	for Object, Start in Drag.Start do
		local Rule = self.Book.Rules[Drag.Keys[Object]]
		if Rule then
			Rule.Position = Util.Shift(Start, X, Y)
			Object.Position = Rule.Position
		end
	end
end

function HUDManager.EndDrag(self: Manager)
	local Drag = self.Session.Drag
	if not Drag then
		return
	end

	self.Session.Drag = nil

	if not Drag.Moved then
		return
	end

	local Changes: { Change } = {}

	for _, Key in Drag.Keys do
		table.insert(Changes, { Key = Key, Before = Drag.Before[Key], After = self.Book:Snapshot(Key) })
	end

	self.History:Push("Move", Changes)
	self.Book.Changed:Fire()
end

function HUDManager.IsDragging(self: Manager): boolean
	local Drag = self.Session.Drag
	if not Drag then
		return false
	end

	local State = Drag.Input.UserInputState
	if State == Enum.UserInputState.End or State == Enum.UserInputState.Cancel then
		self:EndDrag()
		return false
	end

	return true
end

--// Mutation \\

function HUDManager.Mutate(self: Manager, Label: string, Mutator: (Rule: Rule, Object: GuiObject) -> boolean?, Merge: boolean?, IgnoreLock: boolean?): boolean
	if not self:RequireSelection() or self:IsDragging() then
		return false
	end

	local Changes: { Change } = {}
	local Skipped = 0

	for _, Object in self.Session.Cluster do
		if not IgnoreLock and self:IsElementLocked(Object) then
			Skipped += 1
			continue
		end

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

function HUDManager.Nudge(self: Manager, DeltaX: number, DeltaY: number): boolean
	return self:Mutate("Nudge", function(Rule)
		Rule.Position = Util.Shift(Rule.Position, DeltaX, DeltaY)
		return true
	end, true)
end

function HUDManager.Resize(self: Manager, Delta: number): boolean
	return self:Mutate("Resize", function(Rule, Object)
		local Current = Object.AbsoluteSize
		if Current.X + Delta < Constants.MinElementSize or Current.Y + Delta < Constants.MinElementSize then
			return false
		end

		Rule.Size = Util.Shift(Rule.Size, Delta, Delta)
		Rule.SizeModified = true

		local Anchor = Object.AnchorPoint
		Rule.Position = Util.Shift(Rule.Position, math.round((Anchor.X - 0.5) * Delta), math.round((Anchor.Y - 0.5) * Delta))

		return true
	end, true)
end

function HUDManager.Align(self: Manager, Axis: "X" | "Y"): boolean
	local Primary = self.Session.Selected
	if not Primary then
		return self:RequireSelection()
	end

	local Center = Geometry.ScreenPosition(Primary) + Primary.AbsoluteSize / 2
	local Target = Util.GetViewport() / 2
	local Offset = math.round(if Axis == "X" then Target.X - Center.X else Target.Y - Center.Y)

	if Offset == 0 then
		return false
	end

	return self:Mutate("Align", function(Rule)
		Rule.Position = if Axis == "X" then Util.Shift(Rule.Position, Offset, 0) else Util.Shift(Rule.Position, 0, Offset)
		return true
	end)
end

function HUDManager.DeleteSelected(self: Manager): boolean
	local Done = self:Mutate("Hide", function(Rule)
		Rule.IsDeleted = true
		return true
	end, nil, true)

	if Done then
		self:ClearSelection()
	end

	return Done
end

function HUDManager.ResetSelected(self: Manager): boolean
	if not self:RequireSelection() then
		return false
	end

	local Changes: { Change } = {}

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

function HUDManager.RestoreKey(self: Manager, Key: string): boolean
	local Before = self.Book:Snapshot(Key)
	if not Before then
		return false
	end

	self.Book:Release(Key)
	self.History:Push("Restore", { { Key = Key, Before = Before, After = nil } })
	self.Book.Changed:Fire()
	return true
end

function HUDManager.FocusObject(self: Manager, Object: GuiObject)
	self:SetEditMode(true)
	self:SelectObject(Object)
end

function HUDManager.FocusKey(self: Manager, Key: string): boolean
	local Object = self.Book:FindObject(Key)

	if Object and Object.Visible then
		self:FocusObject(Object)
		return true
	end

	self:Toast("Element is not on screen right now")
	return false
end

function HUDManager.ApplyChanges(self: Manager, Changes: { Change }, Field: "Before" | "After")
	for _, Change in Changes do
		local State = if Field == "Before" then Change.Before else Change.After

		if State == nil then
			self.Book:Release(Change.Key)
		else
			self.Book.Rules[Change.Key] = table.clone(State)
		end
	end

	self:Rescan()
	self.Book.Changed:Fire()
end

function HUDManager.Undo(self: Manager): boolean
	local Item = self.History:PopUndo()
	if not Item then
		self:Toast("Nothing to undo")
		return false
	end

	self:ApplyChanges(Item.Changes, "Before")
	return true
end

function HUDManager.Redo(self: Manager): boolean
	local Item = self.History:PopRedo()
	if not Item then
		self:Toast("Nothing to redo")
		return false
	end

	self:ApplyChanges(Item.Changes, "After")
	return true
end

function HUDManager.ReplaceRules(self: Manager, Incoming: { [string]: Rule }, Merge: boolean?, Label: string)
	local Keys: { [string]: boolean } = {}

	for Key in Incoming do
		Keys[Key] = true
	end

	if not Merge then
		for Key in self.Book.Rules do
			Keys[Key] = true
		end
	end

	local Changes: { Change } = {}
	for Key in Keys do
		local Next = Incoming[Key]
		table.insert(Changes, { Key = Key, Before = self.Book:Snapshot(Key), After = if Next then table.clone(Next) else nil })
	end

	self.History:Push(Label, Changes)
	self:ApplyChanges(Changes, "After")
	self:ClearSelection()
end

function HUDManager.ResetAll(self: Manager)
	self:ReplaceRules({}, false, "Reset all")
end

--// Window \\

function HUDManager.OpenSettings(self: Manager)
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

function HUDManager.HideWindow(self: Manager)
	local Window = self.Library.Window
	if Window and not Window.Minimized then
		Window:Minimize()
	end
end

function HUDManager.Confirm(self: Manager, Title: string, Content: string, Label: string, Action: () -> ())
	self.Library.Window:Dialog({
		Title = Title,
		Content = Content,
		Buttons = {
			{ Title = Label, Variant = "Danger", Callback = Action },
			{ Title = "Cancel" },
		},
	})
end

function HUDManager.IgnoreSaveIndexes(self: Manager, List: { string })
	local Manager = self.SaveManager or (self.Extension and self.Extension.SaveManager)

	if Manager then
		pcall(Manager.SetIgnoreIndexes, Manager, List)
	end
end

--// Profiles \\

function HUDManager.QuickSave(self: Manager)
	local Name = self.ActiveProfile or "Quick"
	local Success, Problem = ProfileStore.Save(self, Name)

	if not Success then
		return self:Notify("Failed to save", tostring(Problem))
	end

	self:Notify("Profile saved", Util.Quote(Name))
end

function HUDManager.LoadProfile(self: Manager, Name: string?): (boolean, string?)
	return ProfileStore.Load(self, Name, self.Settings.LoadMode == "Merge")
end

function HUDManager.LoadAutoloadConfig(self: Manager)
	self:Start()

	local Name = ProfileStore.GetAutoload(self)
	if not Name then
		return
	end

	local Success, Problem = self:LoadProfile(Name)
	if not Success then
		return self:Notify("Autoload failed", tostring(Problem))
	end

	self:Notify("HUD profile auto loaded", Util.Quote(Name))
end

--// Sections \\

function HUDManager.AddSetting(self: Manager, Section: any, Method: string, Key: string, Config: { [string]: any }): any
	local Idx = `Hud{Key}`

	Config.Default = (self.Settings :: any)[Key]
	Config.Callback = function(Value: any)
		self:SetSetting(Key, Value)
	end

	local Option = Section[Method](Section, Idx, Config)
	self:BindOption(Key, Idx)
	return Option
end

function HUDManager.BuildControlSection(self: Manager, Tab: any)
	local Section = Tab:AddSection("Controls", { Icon = "lucide:mouse-pointer-2" })
	self.ControlSection = Section

	Section:AddToggle("HudEditMode", {
		Title = "Edit mode",
		Icon = "lucide:pencil",
		Default = self.Session.EditMode,
		Callback = function(Value: boolean)
			self:SetEditMode(Value)
			if Value then
				self:HideWindow()
			end
		end,
	})

	local function AddAction(Title: string, Icon: string, Variant: string, Callback: () -> ())
		Section:AddButton({ Title = Title, Variant = Variant, ButtonText = Title, ButtonIcon = Icon, Callback = Callback })
	end

	AddAction("Undo", "lucide:undo-2", "Tonal", function()
		self:Undo()
	end)

	AddAction("Redo", "lucide:redo-2", "Tonal", function()
		self:Redo()
	end)

	AddAction("Save", "lucide:save", "Primary", function()
		self:QuickSave()
	end)

	AddAction("Advanced", "lucide:sliders-horizontal", "Outline", function()
		self.Overlay:ToggleAdvanced()
	end)

	self.Api:Connect(self.Signals.StateChanged, function(Enabled: boolean)
		local Option = self.Library.Options.HudEditMode
		if Option and Option.Value ~= Enabled then
			pcall(Option.SetValue, Option, Enabled)
		end
	end)

	self:ApplyLauncherState()
end

function HUDManager.BuildConfigSection(self: Manager, Tab: any)
	local Section = Tab:AddSection("Configuration", { Icon = "lucide:sliders-horizontal" })

	self:AddSetting(Section, "AddToggle", "ShowLauncher", { Title = "Launcher", Icon = "lucide:circle-dot" })
	self:AddSetting(Section, "AddToggle", "GroupCluster", { Title = "Group linked elements", Icon = "lucide:link" })
	self:AddSetting(Section, "AddToggle", "RespectLocks", { Title = "Respect locks", Icon = "lucide:lock" })
	self:AddSetting(Section, "AddToggle", "Shortcuts", {
		Title = "Shortcuts",
		Description = "Arrows, Z, Y, Delete and Esc while editing",
		Icon = "lucide:keyboard",
	})
	self:AddSetting(Section, "AddSegmented", "SelectionMode", { Title = "Selection", Options = { "Smart", "Exact" } })
	self:AddSetting(Section, "AddSegmented", "Axis", { Title = "Drag axis", Options = { "Free", "Horizontal", "Vertical" } })
	self:AddSetting(Section, "AddSegmented", "NudgeStep", { Title = "Nudge step", Options = Constants.NudgeSteps })
	self:AddSetting(Section, "AddSlider", "ResizeStep", {
		Title = "Resize step",
		Icon = "lucide:maximize-2",
		Min = 1,
		Max = 50,
		Rounding = 0,
		Suffix = " px",
	})
	self:AddSetting(Section, "AddSlider", "SnapSize", {
		Title = "Snap size",
		Description = "0 turns snapping off",
		Icon = "lucide:grid",
		Min = 0,
		Max = 50,
		Rounding = 0,
		Suffix = " px",
	})
end

function HUDManager.BuildProfileSection(self: Manager, Tab: any)
	local Library = self.Library
	local Section = Tab:AddSection("Profiles", { Icon = "lucide:save" })
	local AutoloadButton: any

	Section:AddSegmented("HudLoadMode", {
		Title = "Load mode",
		Options = { "Replace", "Merge" },
		Default = self.Settings.LoadMode,
		Callback = function(Value: LoadMode)
			self.Settings.LoadMode = Value
		end,
	})

	Section:AddInput("HudProfileName", {
		Title = "Name",
		Variant = "Field",
		Icon = "lucide:pencil",
		Placeholder = "My HUD",
		Finished = false,
	})

	Section:AddDropdown("HudProfileList", {
		Title = "Profiles",
		Icon = "lucide:folder-open",
		Variant = "Compact",
		Values = ProfileStore.List(self),
		AllowNull = true,
	})

	local function Selected(): string?
		return Library.Options.HudProfileList.Value
	end

	local function DescribeAutoload()
		AutoloadButton:SetDesc(`Autoload: {ProfileStore.GetAutoload(self) or "none"}`)
	end

	local function Refresh()
		Library.Options.HudProfileList:SetValues(ProfileStore.List(self))
		Library.Options.HudProfileList:SetValue(nil)
		DescribeAutoload()
	end

	local function RequireProfile(Failure: string, Action: (Name: string) -> ())
		local Name = Selected()

		if Util.IsBlank(Name) then
			return self:Notify(Failure, "no profile selected")
		end

		Action(Name :: string)
	end

	local function Create(Name: string)
		local Success, Problem = ProfileStore.Save(self, Name)
		if not Success then
			return self:Notify("Failed to save", tostring(Problem))
		end

		self:Notify("Profile saved", Util.Quote(Util.SanitizeName(Name)))
		Refresh()
	end

	local function AddButton(Container: any, Config: { [string]: any }): any
		Config.ButtonText = Config.ButtonText or Config.Title
		return Container:AddButton(Config)
	end

	AddButton(Section, {
		Title = "Create",
		Variant = "Primary",
		ButtonIcon = "lucide:save",
		Callback = function()
			local Name = Util.SanitizeName(Library.Options.HudProfileName.Value)

			if Name == "" then
				return self:Notify("Failed to save", "invalid profile name")
			end

			if Util.HasFileSystem() and isfile(ProfileStore.Path(self, Name)) then
				return self:Confirm("Overwrite profile", `{Util.Quote(Name)} already exists. Overwrite it?`, "Overwrite", function()
					Create(Name)
				end)
			end

			Create(Name)
		end,
	})

	AddButton(Section, {
		Title = "Load",
		Variant = "Tonal",
		ButtonIcon = "lucide:download",
		Callback = function()
			local Name = Selected()
			local Success, Problem = self:LoadProfile(Name)

			if not Success then
				return self:Notify("Failed to load", tostring(Problem))
			end

			self:Notify("Profile loaded", Util.Quote(Name :: string))
		end,
	})

	AddButton(Section, {
		Title = "Overwrite",
		Variant = "Outline",
		ButtonIcon = "lucide:refresh-cw",
		Callback = function()
			RequireProfile("Failed to overwrite", function(Name)
				self:Confirm("Overwrite profile", `Replace {Util.Quote(Name)} with the current layout?`, "Overwrite", function()
					local Success, Problem = ProfileStore.Save(self, Name)
					if not Success then
						return self:Notify("Failed to overwrite", tostring(Problem))
					end

					self:Notify("Profile overwritten", Util.Quote(Name))
				end)
			end)
		end,
	})

	AddButton(Section, {
		Title = "Delete",
		Variant = "Danger",
		ButtonIcon = "lucide:trash",
		Callback = function()
			RequireProfile("Failed to delete", function(Name)
				self:Confirm("Delete profile", `Delete {Util.Quote(Name)}? This cannot be undone.`, "Delete", function()
					ProfileStore.Delete(self, Name)
					self:Notify("Profile deleted", Util.Quote(Name))
					Refresh()
				end)
			end)
		end,
	})

	AddButton(Section, { Title = "Refresh", Variant = "Ghost", ButtonIcon = "lucide:rotate-cw", Callback = Refresh })

	AutoloadButton = AddButton(Section, {
		Title = "Autoload",
		Description = "Autoload: none",
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
			self:Notify("Autoload set", Util.Quote(Name :: string))
		end,
	})

	local Share = Tab:AddSection("Share", { Icon = "lucide:share" })

	AddButton(Share, {
		Title = "Copy",
		Variant = "Tonal",
		ButtonIcon = "lucide:copy",
		Callback = function()
			RequireProfile("Failed to copy", function(Name)
				local Success, Problem = ProfileStore.Export(self, Name)
				if not Success then
					return self:Notify("Failed to copy", tostring(Problem))
				end

				self:Notify("Profile copied", Util.Quote(Name))
			end)
		end,
	})

	Share:AddInput("HudProfileImport", {
		Title = "JSON",
		Variant = "Field",
		Icon = "lucide:clipboard",
		Placeholder = "Paste a copied profile",
		Finished = false,
	})

	AddButton(Share, {
		Title = "Import",
		Description = "Saved under the profile name above",
		Variant = "Primary",
		ButtonIcon = "lucide:file-input",
		Callback = function()
			local Success, Result = ProfileStore.ImportText(self, Library.Options.HudProfileName.Value, Library.Options.HudProfileImport.Value)

			if not Success then
				return self:Notify("Failed to import", tostring(Result))
			end

			self:Notify("Profile imported", `{Result} rules`)
			Refresh()
		end,
	})

	AddButton(Share, {
		Title = "Import legacy",
		Description = "Saves from the old Perfect UI Manager",
		Variant = "Outline",
		ButtonIcon = "lucide:history",
		Callback = function()
			local Count = ProfileStore.ImportLegacy(self)

			if Count == 0 then
				return self:Notify("Nothing imported", "no new legacy saves for this game")
			end

			self:Notify("Legacy configs imported", `{Count} profiles`)
			Refresh()
		end,
	})

	DescribeAutoload()
end

function HUDManager.BuildSection(self: Manager, Tab: any)
	self:Start()
	self.Tab = Tab
	self:BuildControlSection(Tab)
	self:BuildConfigSection(Tab)
	self:BuildProfileSection(Tab)
end

local Singleton: Manager = setmetatable({
	Version = Constants.Version,
	Folder = "HUDManager",
	Library = nil,
	Extension = nil,
	SaveManager = nil,
	Api = nil,
	Overlay = nil :: any,
	Book = nil :: any,
	History = nil :: any,
	Tab = nil,
	ControlSection = nil,
	Started = false,
	GameId = tostring(if game.GameId > 0 then game.GameId else game.PlaceId),
	GameName = "UnknownGame",
	ActiveProfile = nil,
	ScanToken = 0,
	Settings = NewSettings(),
	Session = NewSession(),
	Bindings = {},
	Presses = {},
	Signals = {
		StateChanged = Signal.new(),
		SelectionChanged = Signal.new(),
		SettingChanged = Signal.new(),
	},
} :: ManagerFields, HUDManager)

return Singleton
