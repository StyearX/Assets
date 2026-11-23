type Properties = { [string]: any }

type Drawing = {
	Set: (Self: Drawing, Properties: Properties) -> Drawing,
	Remove: (Self: Drawing) -> (),
	[string]: any,
}

type Library = {
	New: (Type: string, Properties: Properties?) -> Drawing,
	Clear: () -> (),
	Destroy: () -> (),
}

type Settings = {
	Enabled: boolean,
	TeamCheck: boolean,
	UseTeamColor: boolean,
	MaxDistance: number,
	BoxStyle: "Full" | "Corner",
	BoxRatio: number,
	Rounding: number,
	Thickness: number,
	Color: Color3,
	OutlineColor: Color3,
	ShowOutline: boolean,
	FillBox: boolean,
	FillOpacity: number,
	CornerLength: number,
	ShowName: boolean,
	UseDisplayName: boolean,
	ShowDistance: boolean,
	ShowHealthBar: boolean,
	ShowHealthText: boolean,
	ShowTracer: boolean,
	TracerOrigin: "Bottom" | "Center" | "Top",
	TextSize: number,
	TextColor: Color3,
	Font: Enum.Font,
	HeadPadding: number,
	FootPadding: number,
	Smoothing: number,
	HealthSmoothing: number,
	CullMargin: number,
	Offset: Vector2,
	Debug: boolean,
}

type State = {
	Objects: { Drawing },
	Corners: { Drawing },
	CornerOutlines: { Drawing },
	Character: Model?,
	Root: BasePart?,
	Head: BasePart?,
	Humanoid: Humanoid?,
	TopOffset: number?,
	Health: number?,
	Fill: Drawing,
	Outline: Drawing,
	Inner: Drawing,
	Box: Drawing,
	HealthOutline: Drawing,
	HealthFill: Drawing,
	Name: Drawing,
	Info: Drawing,
	Tracer: Drawing,
}

local DrawingLibrary = loadstring(readfile("DrawingLibrary.lua"))() :: Library

local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local Workspace = cloneref(game:GetService("Workspace"))
local HttpService = cloneref(game:GetService("HttpService"))

if getgenv().Esp then
	getgenv().Esp.Unload()
end

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera :: Camera
local BindName = HttpService:GenerateGUID(false)
local Floor = math.floor

local Settings: Settings = {
	Enabled = true,
	TeamCheck = false,
	UseTeamColor = false,
	MaxDistance = 2500,
	BoxStyle = "Full",
	BoxRatio = 0.55,
	Rounding = 3,
	Thickness = 1,
	Color = Color3.fromRGB(255, 60, 60),
	OutlineColor = Color3.new(0, 0, 0),
	ShowOutline = true,
	FillBox = true,
	FillOpacity = 0.08,
	CornerLength = 0.25,
	ShowName = true,
	UseDisplayName = false,
	ShowDistance = true,
	ShowHealthBar = false,
	ShowHealthText = false,
	ShowTracer = true,
	TracerOrigin = "Top",
	TextSize = 13,
	TextColor = Color3.new(1, 1, 1),
	Font = Enum.Font.GothamMedium,
	HeadPadding = 0.35,
	FootPadding = 0.1,
	Smoothing = 25,
	HealthSmoothing = 12,
	CullMargin = 300,
	Offset = Vector2.zero,
	Debug = false,
}

local CornerDefinitions = {
	{ 0, 0, 1, 1 },
	{ 1, 0, -1, 1 },
	{ 0, 1, 1, -1 },
	{ 1, 1, -1, -1 },
}

local LowHealthColor = Color3.fromRGB(255, 60, 60)
local FullHealthColor = Color3.fromRGB(60, 255, 100)

local States: { [Player]: State } = {}

local function AddObject(Objects: { Drawing }, Type: string, Properties: Properties): Drawing
	Properties.Visible = false

	local Object = DrawingLibrary.New(Type, Properties)
	table.insert(Objects, Object)

	return Object
end

local function CreateState(): State
	local Objects: { Drawing } = {}

	return {
		Objects = Objects,
		Corners = {},
		CornerOutlines = {},
		Fill = AddObject(Objects, "Rectangle", { Filled = true, ZIndex = 1 }),
		Outline = AddObject(Objects, "Rectangle", { ZIndex = 2 }),
		Inner = AddObject(Objects, "Rectangle", { ZIndex = 3 }),
		Box = AddObject(Objects, "Rectangle", { ZIndex = 4 }),
		HealthOutline = AddObject(Objects, "Rectangle", {
			Filled = true,
			ZIndex = 5,
			Color = Color3.new(0, 0, 0),
			Opacity = 0.7,
		}),
		HealthFill = AddObject(Objects, "Rectangle", { Filled = true, ZIndex = 6 }),
		Name = AddObject(Objects, "Text", { Center = true, Outline = true, ZIndex = 7 }),
		Info = AddObject(Objects, "Text", { Center = true, Outline = true, ZIndex = 7 }),
		Tracer = AddObject(Objects, "Line", { ZIndex = 2 }),
	}
end

local function EnsureCorners(State: State)
	if #State.Corners > 0 then
		return
	end

	for Index = 1, 8 do
		State.CornerOutlines[Index] = AddObject(State.Objects, "Line", { ZIndex = 2 })
		State.Corners[Index] = AddObject(State.Objects, "Line", { ZIndex = 4 })
	end
end

local function HideCorners(State: State)
	for Index, Object in State.Corners do
		Object.Visible = false
		State.CornerOutlines[Index].Visible = false
	end
end

local function Hide(State: State)
	for Index, Object in State.Objects do
		Object.Visible = false
	end
end

local function RemoveState(State: State)
	for Index, Object in State.Objects do
		Object:Remove()
	end

	table.clear(State.Objects)
	table.clear(State.Corners)
	table.clear(State.CornerOutlines)
end

local function Track(Player: Player)
	if Player ~= LocalPlayer and not States[Player] then
		States[Player] = CreateState()
	end
end

local function GetColor(Player: Player): Color3
	if Settings.UseTeamColor and Player.Team then
		return Player.TeamColor.Color
	end

	return Settings.Color
end

local function RenderCorners(State: State, X: number, Y: number, Width: number, Height: number, Color: Color3)
	EnsureCorners(State)

	State.Outline.Visible = false
	State.Inner.Visible = false
	State.Box.Visible = false

	local Thickness = Settings.Thickness
	local Length = math.max(Floor(math.min(Width, Height) * Settings.CornerLength + 0.5), 2)

	for Index = 1, 4 do
		local Definition = CornerDefinitions[Index]
		local VertexX = X + Definition[1] * Width
		local VertexY = Y + Definition[2] * Height
		local SignX = Definition[3]
		local SignY = Definition[4]
		local CenterX = VertexX + SignX * Thickness / 2
		local CenterY = VertexY + SignY * Thickness / 2
		local HorizontalIndex = Index * 2 - 1
		local VerticalIndex = Index * 2

		local HorizontalFrom = Vector2.new(VertexX, CenterY)
		local HorizontalTo = Vector2.new(VertexX + SignX * Length, CenterY)
		local VerticalFrom = Vector2.new(CenterX, VertexY)
		local VerticalTo = Vector2.new(CenterX, VertexY + SignY * Length)

		State.CornerOutlines[HorizontalIndex]:Set({
			From = HorizontalFrom - Vector2.new(SignX, 0),
			To = HorizontalTo + Vector2.new(SignX, 0),
			Thickness = Thickness + 2,
			Color = Settings.OutlineColor,
			Visible = Settings.ShowOutline,
		})

		State.CornerOutlines[VerticalIndex]:Set({
			From = VerticalFrom - Vector2.new(0, SignY),
			To = VerticalTo + Vector2.new(0, SignY),
			Thickness = Thickness + 2,
			Color = Settings.OutlineColor,
			Visible = Settings.ShowOutline,
		})

		State.Corners[HorizontalIndex]:Set({
			From = HorizontalFrom,
			To = HorizontalTo,
			Thickness = Thickness,
			Color = Color,
			Visible = true,
		})

		State.Corners[VerticalIndex]:Set({
			From = VerticalFrom,
			To = VerticalTo,
			Thickness = Thickness,
			Color = Color,
			Visible = true,
		})
	end
end

local function RenderFull(State: State, X: number, Y: number, Width: number, Height: number, Color: Color3)
	HideCorners(State)

	local Thickness = Settings.Thickness

	State.Outline:Set({
		Position = Vector2.new(X, Y),
		Size = Vector2.new(Width, Height),
		Thickness = Thickness + 1,
		Rounding = Settings.Rounding,
		Color = Settings.OutlineColor,
		Visible = Settings.ShowOutline,
	})

	State.Inner:Set({
		Position = Vector2.new(X + 1, Y + 1),
		Size = Vector2.new(math.max(Width - 2, 1), math.max(Height - 2, 1)),
		Thickness = 1,
		Rounding = math.max(Settings.Rounding - 1, 0),
		Color = Settings.OutlineColor,
		Visible = Settings.ShowOutline,
	})

	State.Box:Set({
		Position = Vector2.new(X, Y),
		Size = Vector2.new(Width, Height),
		Thickness = Thickness,
		Rounding = Settings.Rounding,
		Color = Color,
		Visible = true,
	})
end

local function UpdatePlayer(Player: Player, State: State, DeltaTime: number): boolean
	local Character = Player.Character

	if State.Character ~= Character or not (State.Root and State.Root.Parent and State.Head and State.Humanoid) then
		State.Character = Character
		State.Root = Character and Character:FindFirstChild("HumanoidRootPart") :: BasePart?
		State.Head = Character and Character:FindFirstChild("Head") :: BasePart?
		State.Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		State.TopOffset = nil
		State.Health = nil
	end

	local Root = State.Root
	local Head = State.Head
	local Humanoid = State.Humanoid

	if not (Root and Head and Humanoid) or Humanoid.Health <= 0 then
		return false
	end

	if Settings.TeamCheck and Player.Team ~= nil and Player.Team == LocalPlayer.Team then
		return false
	end

	local RootPosition = Root.Position
	local Distance = (Camera.CFrame.Position - RootPosition).Magnitude

	if Distance > Settings.MaxDistance then
		return false
	end

	local TargetTop = Head.Position.Y + Head.Size.Y / 2 + Settings.HeadPadding - RootPosition.Y
	local TopOffset = State.TopOffset

	if TopOffset == nil or Settings.Smoothing <= 0 then
		TopOffset = TargetTop
	else
		TopOffset += (TargetTop - TopOffset) * (1 - math.exp(-Settings.Smoothing * DeltaTime))
	end

	State.TopOffset = TopOffset

	local FootOffset = Root.Size.Y / 2 + 2

	if Humanoid.RigType == Enum.HumanoidRigType.R15 then
		FootOffset = Root.Size.Y / 2 + Humanoid.HipHeight
	end

	local TopPoint = Camera:WorldToViewportPoint(RootPosition + Vector3.new(0, TopOffset, 0))
	local BottomPoint = Camera:WorldToViewportPoint(RootPosition - Vector3.new(0, FootOffset + Settings.FootPadding, 0))

	if TopPoint.Z <= 0 or BottomPoint.Z <= 0 then
		return false
	end

	local Height = Floor(math.abs(BottomPoint.Y - TopPoint.Y) + 0.5)

	if Height < 4 then
		return false
	end

	local Width = Floor(Height * Settings.BoxRatio / 2 + 0.5) * 2
	local X = Floor((TopPoint.X + BottomPoint.X) / 2 - Width / 2 + 0.5 + Settings.Offset.X)
	local Y = Floor(math.min(TopPoint.Y, BottomPoint.Y) + 0.5 + Settings.Offset.Y)
	local ViewSize = Camera.ViewportSize
	local Margin = Settings.CullMargin

	if X + Width < -Margin or X > ViewSize.X + Margin or Y + Height < -Margin or Y > ViewSize.Y + Margin then
		return false
	end

	local Color = GetColor(Player)
	local Thickness = Settings.Thickness

	State.Fill:Set({
		Position = Vector2.new(X, Y),
		Size = Vector2.new(Width, Height),
		Rounding = Settings.Rounding,
		Color = Color,
		Opacity = Settings.FillOpacity,
		Visible = Settings.FillBox,
	})

	if Settings.BoxStyle == "Corner" then
		RenderCorners(State, X, Y, Width, Height, Color)
	else
		RenderFull(State, X, Y, Width, Height, Color)
	end

	local Ratio = math.clamp(Humanoid.Health / math.max(Humanoid.MaxHealth, 1), 0, 1)
	local Health = State.Health

	if Health == nil then
		Health = Ratio
	else
		Health += (Ratio - Health) * (1 - math.exp(-Settings.HealthSmoothing * DeltaTime))
	end

	State.Health = Health

	local BarX = X - Thickness - 6
	local BarHeight = math.max(Floor(Height * Health + 0.5), 1)

	State.HealthOutline:Set({
		Position = Vector2.new(BarX - 1, Y - 1),
		Size = Vector2.new(5, Height + 2),
		Visible = Settings.ShowHealthBar,
	})

	State.HealthFill:Set({
		Position = Vector2.new(BarX, Y + Height - BarHeight),
		Size = Vector2.new(3, BarHeight),
		Color = LowHealthColor:Lerp(FullHealthColor, Health),
		Visible = Settings.ShowHealthBar and Health > 0.01,
	})

	local CenterX = X + Width / 2

	State.Name:Set({
		Text = Settings.UseDisplayName and Player.DisplayName or Player.Name,
		Size = Settings.TextSize,
		Font = Settings.Font,
		Color = Settings.TextColor,
		Position = Vector2.new(CenterX, Floor(Y - Thickness - Settings.TextSize / 2 - 3)),
		Visible = Settings.ShowName,
	})

	local InfoText = ""

	if Settings.ShowDistance then
		InfoText = string.format("%dm", Floor(Distance + 0.5))
	end

	if Settings.ShowHealthText then
		local HealthText = string.format("%dhp", Floor(Humanoid.Health + 0.5))
		InfoText = InfoText == "" and HealthText or InfoText .. " | " .. HealthText
	end

	State.Info:Set({
		Text = InfoText,
		Size = Settings.TextSize,
		Font = Settings.Font,
		Color = Settings.TextColor,
		Position = Vector2.new(CenterX, Floor(Y + Height + Thickness + Settings.TextSize / 2 + 2)),
		Visible = InfoText ~= "",
	})

	if Settings.ShowTracer then
		local Origin = Vector2.new(ViewSize.X / 2, ViewSize.Y)

		if Settings.TracerOrigin == "Top" then
			Origin = Vector2.new(ViewSize.X / 2, 0)
		elseif Settings.TracerOrigin == "Center" then
			Origin = ViewSize / 2
		end

		State.Tracer:Set({
			From = Origin,
			To = Vector2.new(CenterX, Y + Height),
			Thickness = 1,
			Color = Color,
			Visible = true,
		})
	else
		State.Tracer.Visible = false
	end

	return true
end

local function Update(DeltaTime: number)
	local CurrentCamera = Workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	Camera = CurrentCamera

	for Player, State in States do
		if not Settings.Enabled then
			Hide(State)
			continue
		end

		local Success, Result = pcall(UpdatePlayer, Player, State, DeltaTime)

		if not Success and Settings.Debug then
			warn(Result)
		end

		if not (Success and Result) then
			Hide(State)
		end
	end
end

for Index, Player in Players:GetPlayers() do
	Track(Player)
end

local AddedConnection = Players.PlayerAdded:Connect(Track)

local RemovingConnection = Players.PlayerRemoving:Connect(function(Player: Player)
	local State = States[Player]

	if State then
		RemoveState(State)
		States[Player] = nil
	end
end)

RunService:BindToRenderStep(BindName, Enum.RenderPriority.Camera.Value + 1, Update)

local function Unload()
	RunService:UnbindFromRenderStep(BindName)
	AddedConnection:Disconnect()
	RemovingConnection:Disconnect()
	table.clear(States)
	DrawingLibrary.Destroy()
	getgenv().Esp = nil
end

getgenv().Esp = {
	Settings = Settings,
	Unload = Unload,
}
