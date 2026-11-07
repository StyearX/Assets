--!nonstrict
--!optimize 2
--!native

export type ColorData = { r: number, g: number, b: number }
export type VectorData = { X: number, Y: number, Z: number }
export type AvatarProperties = { [string]: any }
export type AvatarSource = "ava" | "legacy"

export type AvatarData = {
	Name: string,
	Username: string?,
	DisplayName: string?,
	UserId: number?,
	RigType: string,
	Properties: AvatarProperties,
	Signature: string?,
	Order: number?,
	Source: AvatarSource?,
	FilePath: string?,
	FileName: string?,
}

export type Options = {
	ReapplyOnRespawn: boolean,
	PlaceholderMode: boolean,
	AppearanceMode: boolean,
	ApplyToSimilar: boolean,
	SimilarThreshold: number,
	RigPath: string,
	Notifications: boolean,
	PreviewHeight: number,
	PreviewAutoRotate: boolean,
	PreviewCacheLimit: number,
	ToggleKey: string,
	EvadeMode: string,
	EvadeHideFirstPerson: boolean,
}

export type Connection = {
	Connected: boolean,
	Disconnect: (self: Connection) -> (),
}

export type Signal = {
	Connect: (self: Signal, Handler: (...any) -> ()) -> Connection,
	Once: (self: Signal, Handler: (...any) -> ()) -> Connection,
	Fire: (self: Signal, ...any) -> (),
	DisconnectAll: (self: Signal) -> (),
}

local CloneRef = cloneref or function(Object: any): any
	return Object
end

local function GetService(Name: string): any
	local Service = game:GetService(Name)
	local Success, Result = pcall(CloneRef, Service)
	return if Success then Result else Service
end

local Players: Players = GetService("Players")
local HttpService: HttpService = GetService("HttpService")
local UserInputService: UserInputService = GetService("UserInputService")
local RunService: RunService = GetService("RunService")
local ContentProvider: ContentProvider = GetService("ContentProvider")
local Workspace: Workspace = GetService("Workspace")
local CoreGui: CoreGui = GetService("CoreGui")
local InsertService: InsertService = GetService("InsertService")
local ReplicatedStorage: ReplicatedStorage = GetService("ReplicatedStorage")

local LocalPlayer: Player = Players.LocalPlayer

local Constants = table.freeze({
	CatalogPlaceId = 7041939546,
	LegacyFolder = "Avatar Saver v2",
	LegacyFile = "Avatar Saver v2/SavedAvatars.json",
	DefaultFolder = "Avatars",
	FileExtension = ".ava",
	ModelName = "LocalWearer_LocalTryOn",
	HostName = "FluentAvatarChanger",
	CleanupKey = "__FluentAvatarChangerCleanup",
	SeatedMessage = "Avatars cannot be worn while sitting. Stand up first, then wear the avatar again.",
	FadeTime = 0.16,
})

local AccessoryCategories = table.freeze({
	"HatAccessory",
	"HairAccessory",
	"FaceAccessory",
	"NeckAccessory",
	"ShouldersAccessory",
	"FrontAccessory",
	"BackAccessory",
	"WaistAccessory",
	"JacketAccessory",
	"ShortsAccessory",
	"SweaterAccessory",
	"TShirtAccessory",
	"PantsAccessory",
	"ShoesAccessory",
	"DressSkirtAccessory",
	"EyelashAccessory",
	"EyebrowAccessory",
	"MoodAccessory",
})

local AccessoryTypeCategory = table.freeze({
	Hat = "HatAccessory",
	Hair = "HairAccessory",
	Face = "FaceAccessory",
	Neck = "NeckAccessory",
	Shoulder = "ShouldersAccessory",
	Front = "FrontAccessory",
	Back = "BackAccessory",
	Waist = "WaistAccessory",
	TShirt = "TShirtAccessory",
	Shirt = "ShirtAccessory",
	Pants = "PantsAccessory",
	Jacket = "JacketAccessory",
	Sweater = "SweaterAccessory",
	Shorts = "ShortsAccessory",
	LeftShoe = "ShoesAccessory",
	RightShoe = "ShoesAccessory",
	DressSkirt = "DressSkirtAccessory",
	Eyebrow = "EyebrowAccessory",
	Eyelash = "EyelashAccessory",
})

local BodyPartNames = table.freeze({
	Head = true,
	HumanoidRootPart = true,
	Torso = true,
	UpperTorso = true,
	LowerTorso = true,
	["Left Arm"] = true,
	["Right Arm"] = true,
	["Left Leg"] = true,
	["Right Leg"] = true,
	LeftUpperArm = true,
	LeftLowerArm = true,
	LeftHand = true,
	RightUpperArm = true,
	RightLowerArm = true,
	RightHand = true,
	LeftUpperLeg = true,
	LeftLowerLeg = true,
	LeftFoot = true,
	RightUpperLeg = true,
	RightLowerLeg = true,
	RightFoot = true,
})

local R6BodyPartNames = table.freeze({ "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" })

local ClothingClasses = table.freeze({ "Accessory", "Shirt", "Pants", "ShirtGraphic", "BodyColors", "CharacterMesh" })

local AnimationKeys = table.freeze({ "Idle", "Walk", "Run", "Jump", "Fall", "Climb", "Swim", "SwimIdle", "Sit" })

local AnimationDefaults = table.freeze({
	R6 = table.freeze({
		Idle = "rbxassetid://180435571",
		Walk = "rbxassetid://180426354",
		Run = "rbxassetid://180426354",
		Jump = "rbxassetid://125750702",
		Fall = "rbxassetid://180436148",
		Climb = "rbxassetid://180436334",
		Swim = "rbxassetid://180426354",
		SwimIdle = "rbxassetid://180435571",
		Sit = "rbxassetid://178130996",
	}),
	R15 = table.freeze({
		Idle = "rbxassetid://507766388",
		Walk = "rbxassetid://913403211",
		Run = "rbxassetid://913384386",
		Jump = "rbxassetid://507765000",
		Fall = "rbxassetid://507767968",
		Climb = "rbxassetid://507765644",
		Swim = "rbxassetid://913389285",
		SwimIdle = "rbxassetid://507785072",
		Sit = "rbxassetid://507768133",
	}),
})

local R6Emotes = table.freeze({
	wave = { "rbxassetid://128777973" },
	point = { "rbxassetid://128853357" },
	dance = { "rbxassetid://182435998", "rbxassetid://182491037", "rbxassetid://182491065" },
	dance1 = { "rbxassetid://182435998", "rbxassetid://182491037", "rbxassetid://182491065" },
	dance2 = { "rbxassetid://182436842", "rbxassetid://182491248", "rbxassetid://182491277" },
	dance3 = { "rbxassetid://182436935", "rbxassetid://182491368", "rbxassetid://182491423" },
	laugh = { "rbxassetid://129423131" },
	cheer = { "rbxassetid://129423030" },
})

local R6EmoteLooped = table.freeze({
	wave = false,
	point = false,
	dance = true,
	dance1 = true,
	dance2 = true,
	dance3 = true,
	laugh = false,
	cheer = false,
})

local LegacyEmoteIds: { [string]: string } = {
	["507770239"] = "wave",
	["507770453"] = "point",
	["507771019"] = "dance",
	["507771955"] = "dance",
	["507772104"] = "dance",
	["507776043"] = "dance2",
	["507776720"] = "dance2",
	["507776879"] = "dance2",
	["507777268"] = "dance3",
	["507777451"] = "dance3",
	["507777623"] = "dance3",
	["507770818"] = "laugh",
	["507770677"] = "cheer",
}

local LocomotionNames = table.freeze({
	idle = true,
	walk = true,
	run = true,
	jump = true,
	fall = true,
	climb = true,
	swim = true,
	swimidle = true,
	sit = true,
	seated = true,
	tool = true,
	toolnone = true,
	toolnoneanim = true,
	toolslash = true,
	toollunge = true,
	slash = true,
	lunge = true,
})

local Util = {}

function Util.Trim(Value: any): string
	return (string.match(tostring(Value or ""), "^%s*(.-)%s*$")) or ""
end

function Util.ParseAssetId(Value: any): number?
	if not Value then
		return nil
	end
	if type(Value) == "number" then
		return if Value > 0 then Value else nil
	end
	local Digits = string.match(tostring(Value), "%d+")
	return if Digits then tonumber(Digits) else nil
end

function Util.ParseRigType(Value: any): Enum.HumanoidRigType
	if typeof(Value) == "EnumItem" then
		return Value
	end
	return if string.find(tostring(Value or ""), "R6") then Enum.HumanoidRigType.R6 else Enum.HumanoidRigType.R15
end

function Util.RigName(Value: any): string
	return if Util.ParseRigType(Value) == Enum.HumanoidRigType.R6 then "R6" else "R15"
end

function Util.Call(Function: any, ...: any): (boolean, any)
	return pcall(Function, ...)
end

function Util.Destroy(Object: any)
	if typeof(Object) == "Instance" then
		pcall(Object.Destroy, Object)
	end
end

function Util.Disconnect(Connection: any)
	if Connection then
		pcall(function()
			if Connection.Connected then
				Connection:Disconnect()
			end
		end)
	end
end

function Util.GetFileName(Path: string): string
	return string.match(Path, "([^/\\]+)$") or Path
end

function Util.Encode(Value: any): (boolean, any)
	return pcall(HttpService.JSONEncode, HttpService, Value)
end

function Util.Decode(Text: string): (boolean, any)
	return pcall(HttpService.JSONDecode, HttpService, Text)
end

function Util.CopyDictionary(Source: { [any]: any }): { [any]: any }
	local Copy = {}
	for Key, Value in Source do
		Copy[Key] = Value
	end
	return Copy
end

function Util.IsSeated(Humanoid: Humanoid?): boolean
	if not Humanoid then
		return false
	end
	return Humanoid.Sit or Humanoid.SeatPart ~= nil or Humanoid:GetState() == Enum.HumanoidStateType.Seated
end

function Util.IsR6Model(Model: Model, RigType: Enum.HumanoidRigType?): boolean
	if RigType == Enum.HumanoidRigType.R6 then
		return true
	end
	return Model:FindFirstChild("Torso") ~= nil and Model:FindFirstChild("UpperTorso") == nil
end

function Util.GetRoot(Character: Model?): BasePart?
	if not Character then
		return nil
	end
	return Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart
end

function Util.IsAlive(Object: any): boolean
	return Object ~= nil and Object.Parent ~= nil
end

for Name, Assets in R6Emotes do
	for _, Asset in Assets do
		local Parsed = Util.ParseAssetId(Asset)
		if Parsed then
			LegacyEmoteIds[tostring(Parsed)] = Name
		end
	end
end

local FileApi = {}

function FileApi.Available(): boolean
	return type(readfile) == "function" and type(writefile) == "function" and type(isfile) == "function"
end

function FileApi.EnsureFolder(Path: string): boolean
	if type(makefolder) ~= "function" or type(isfolder) ~= "function" then
		return false
	end
	local Success = pcall(function()
		if not isfolder(Path) then
			makefolder(Path)
		end
	end)
	return Success
end

function FileApi.Exists(Path: string): boolean
	if type(isfile) ~= "function" then
		return false
	end
	local Success, Result = pcall(isfile, Path)
	return Success and Result == true
end

function FileApi.Read(Path: string): (boolean, any)
	return pcall(readfile, Path)
end

function FileApi.Write(Path: string, Contents: string): (boolean, any)
	if type(writefile) ~= "function" then
		return false, "The executor does not provide writefile()."
	end
	return pcall(writefile, Path, Contents)
end

function FileApi.Delete(Path: string): (boolean, any)
	if type(delfile) ~= "function" then
		return false, "The executor does not provide delfile()."
	end
	return pcall(delfile, Path)
end

function FileApi.List(Path: string): { string }
	local Result = {}
	if type(listfiles) ~= "function" then
		return Result
	end
	pcall(function()
		for _, Entry in listfiles(Path) do
			Result[#Result + 1] = tostring(Entry)
		end
	end)
	return Result
end

local Maid = {}
Maid.__index = Maid

local function Dispose(Task: any)
	local Kind = typeof(Task)
	if Kind == "RBXScriptConnection" then
		Task:Disconnect()
	elseif Kind == "Instance" then
		Task:Destroy()
	elseif Kind == "function" then
		Task()
	elseif Kind == "thread" then
		pcall(task.cancel, Task)
	elseif Kind == "table" then
		if type(Task.Destroy) == "function" then
			Task:Destroy()
		elseif type(Task.Disconnect) == "function" then
			Task:Disconnect()
		end
	end
end

function Maid.new()
	return setmetatable({ Tasks = {}, Named = {} }, Maid)
end

function Maid:Give(Task: any): any
	table.insert(self.Tasks, Task)
	return Task
end

function Maid:Set(Name: string, Task: any): any
	local Previous = self.Named[Name]
	if Previous ~= nil then
		pcall(Dispose, Previous)
	end
	self.Named[Name] = Task
	return Task
end

function Maid:Remove(Name: string)
	self:Set(Name, nil)
end

function Maid:Clean()
	local Tasks, Named = self.Tasks, self.Named
	self.Tasks, self.Named = {}, {}
	for _, Task in Tasks do
		pcall(Dispose, Task)
	end
	for _, Task in Named do
		pcall(Dispose, Task)
	end
end

function Maid:Destroy()
	self:Clean()
end

local Connection = {}
Connection.__index = Connection

function Connection:Disconnect()
	if not self.Connected then
		return
	end
	self.Connected = false
	local Handlers = self.Owner.Handlers
	local Index = table.find(Handlers, self)
	if Index then
		table.remove(Handlers, Index)
	end
end

local Signal = {}
Signal.__index = Signal

function Signal.new(): Signal
	return setmetatable({ Handlers = {} }, Signal) :: any
end

function Signal:Connect(Handler: (...any) -> ()): Connection
	local Link = setmetatable({ Handler = Handler, Owner = self, Connected = true }, Connection)
	table.insert(self.Handlers, Link)
	return Link :: any
end

function Signal:Once(Handler: (...any) -> ()): Connection
	local Link
	Link = self:Connect(function(...)
		Link:Disconnect()
		Handler(...)
	end)
	return Link
end

function Signal:Fire(...: any)
	for _, Link in table.clone(self.Handlers) do
		if Link.Connected then
			task.spawn(Link.Handler, ...)
		end
	end
end

function Signal:DisconnectAll()
	for _, Link in table.clone(self.Handlers) do
		Link.Connected = false
	end
	table.clear(self.Handlers)
end

local Serializer = {}

function Serializer.ColorToTable(Color: Color3?): ColorData
	if not Color then
		return { r = 255, g = 255, b = 255 }
	end
	return {
		r = math.floor(Color.R * 255 + 0.5),
		g = math.floor(Color.G * 255 + 0.5),
		b = math.floor(Color.B * 255 + 0.5),
	}
end

function Serializer.TableToColor(Data: any): Color3?
	if type(Data) ~= "table" then
		return nil
	end
	return Color3.fromRGB(Data.r or Data.R or 255, Data.g or Data.G or 255, Data.b or Data.B or 255)
end

function Serializer.VectorToTable(Value: any, Fallback: Vector3?): VectorData
	local Default = Fallback or Vector3.zero
	if typeof(Value) == "Vector3" then
		return { X = Value.X, Y = Value.Y, Z = Value.Z }
	end
	if type(Value) == "table" then
		return {
			X = tonumber(Value.X or Value.x) or Default.X,
			Y = tonumber(Value.Y or Value.y) or Default.Y,
			Z = tonumber(Value.Z or Value.z) or Default.Z,
		}
	end
	return { X = Default.X, Y = Default.Y, Z = Default.Z }
end

function Serializer.TableToVector(Value: any, Fallback: Vector3): Vector3
	if typeof(Value) == "Vector3" then
		return Value
	end
	if type(Value) == "table" then
		return Vector3.new(
			tonumber(Value.X or Value.x) or Fallback.X,
			tonumber(Value.Y or Value.y) or Fallback.Y,
			tonumber(Value.Z or Value.z) or Fallback.Z
		)
	end
	return Fallback
end

function Serializer.GetHeadShape(Description: HumanoidDescription): string
	local Shape = ""
	pcall(function()
		for _, Child in Description:GetChildren() do
			if Child:IsA("BodyPartDescription") and Child.BodyPart == Enum.BodyPart.Head then
				local Value = tostring(Child.HeadShape or "")
				if Value ~= "" then
					Shape = Value
					break
				end
			end
		end
	end)
	return Shape
end

function Serializer.GetMakeups(Description: HumanoidDescription): { any }
	local Result, Seen = {}, {}

	local function Add(Makeup: any)
		if not Makeup then
			return
		end
		local AssetId = tonumber(Makeup.AssetId)
		if not AssetId or AssetId <= 0 then
			return
		end
		local MakeupType = Makeup.MakeupType
		local TypeName = if MakeupType then MakeupType.Name else ""
		local Order = tonumber(Makeup.Order) or 1
		local Key = `{AssetId}|{TypeName}|{Order}`
		if Seen[Key] then
			return
		end
		Seen[Key] = true
		table.insert(Result, { Order = Order, AssetId = AssetId, MakeupType = TypeName })
	end

	pcall(function()
		for _, Child in Description:GetChildren() do
			if Child:IsA("MakeupDescription") then
				Add(Child)
			end
		end
	end)
	pcall(function()
		if #Result == 0 and type(Description.GetMakeups) == "function" then
			for _, Makeup in Description:GetMakeups() do
				Add(Makeup)
			end
		end
	end)
	return Result
end

function Serializer.GetLayered(Description: HumanoidDescription): { any }
	local Result = {}
	pcall(function()
		if type(Description.GetAccessories) ~= "function" then
			return
		end
		for _, Accessory in Description:GetAccessories(true) do
			if Accessory.IsLayered then
				table.insert(Result, {
					Rotation = Serializer.VectorToTable(Accessory.Rotation),
					AssetId = Accessory.AssetId,
					AccessoryType = if Accessory.AccessoryType then Accessory.AccessoryType.Name else "Unknown",
					Position = Serializer.VectorToTable(Accessory.Position),
					Order = Accessory.Order or 1,
					IsLayered = true,
					Puffiness = Accessory.Puffiness or 0.5,
					Scale = Serializer.VectorToTable(Accessory.Scale, Vector3.one),
				})
			end
		end
	end)
	return Result
end

function Serializer.GetRefinements(Description: HumanoidDescription, Character: Model?): { [string]: any }
	local Refinements = {}

	pcall(function()
		if not Character then
			return
		end
		local Raw = Character:GetAttribute("AccessoryRefinements") or Description:GetAttribute("AccessoryRefinements")
		if not Raw then
			return
		end
		local Decoded = Raw
		if type(Raw) == "string" then
			Decoded = HttpService:JSONDecode(Raw)
		end
		if type(Decoded) == "table" then
			for Id, Value in Decoded do
				Refinements[tostring(Id)] = Value
			end
		end
	end)

	pcall(function()
		if type(Description.GetAccessories) ~= "function" then
			return
		end
		for _, Accessory in Description:GetAccessories(true) do
			local Id = tostring(Accessory.AssetId or 0)
			if Id == "0" then
				continue
			end
			local Position, Scale, Rotation = Accessory.Position, Accessory.Scale, Accessory.Rotation
			local HasPosition = Position and Position.Magnitude > 0.0001
			local HasScale = Scale
				and (math.abs(Scale.X - 1) > 0.0001 or math.abs(Scale.Y - 1) > 0.0001 or math.abs(Scale.Z - 1) > 0.0001)
			local HasRotation = Rotation and Rotation.Magnitude > 0.0001
			if HasPosition or HasScale or HasRotation then
				local Entry = if type(Refinements[Id]) == "table" then Refinements[Id] else {}
				if HasPosition then
					Entry.Position = Serializer.VectorToTable(Position)
				end
				if HasScale then
					Entry.Scale = Serializer.VectorToTable(Scale, Vector3.one)
				end
				if HasRotation then
					Entry.Rotation = Serializer.VectorToTable(Rotation)
				end
				Refinements[Id] = Entry
			end
		end
	end)
	return Refinements
end

function Serializer.Capture(Description: HumanoidDescription, Character: Model?): AvatarProperties?
	if not Description then
		return nil
	end

	local Lists = {}
	for _, Category in AccessoryCategories do
		Lists[Category] = {}
	end

	local function Add(Category: string, Id: any)
		local List = Lists[Category]
		if not List then
			return
		end
		local Text = tostring(Id or "")
		if Text ~= "" and Text ~= "0" and not table.find(List, Text) then
			table.insert(List, Text)
		end
	end

	for _, Category in AccessoryCategories do
		pcall(function()
			for Id in string.gmatch(tostring(Description[Category] or ""), "%d+") do
				Add(Category, Id)
			end
		end)
	end

	pcall(function()
		if type(Description.GetAccessories) ~= "function" then
			return
		end
		for _, Accessory in Description:GetAccessories(true) do
			if not Accessory.IsLayered then
				local Category = AccessoryTypeCategory[Accessory.AccessoryType.Name]
				if Category then
					Add(Category, Accessory.AssetId)
				end
			end
		end
	end)

	local Properties: AvatarProperties = {
		WalkAnimation = Description.WalkAnimation or 0,
		MoodAnimation = Description.MoodAnimation or 0,
		ClimbAnimation = Description.ClimbAnimation or 0,
		FallAnimation = Description.FallAnimation or 0,
		RunAnimation = Description.RunAnimation or 0,
		SwimAnimation = Description.SwimAnimation or 0,
		IdleAnimation = Description.IdleAnimation or 0,
		JumpAnimation = Description.JumpAnimation or 0,
		Face = Description.Face or 0,
		Shirt = Description.Shirt or 0,
		Pants = Description.Pants or 0,
		GraphicTShirt = Description.GraphicTShirt or 0,
		RightArmColor = Serializer.ColorToTable(Description.RightArmColor),
		TorsoColor = Serializer.ColorToTable(Description.TorsoColor),
		RightLegColor = Serializer.ColorToTable(Description.RightLegColor),
		LeftLegColor = Serializer.ColorToTable(Description.LeftLegColor),
		LeftArmColor = Serializer.ColorToTable(Description.LeftArmColor),
		HeadColor = Serializer.ColorToTable(Description.HeadColor),
		Head = Description.Head or 0,
		Torso = Description.Torso or 0,
		LeftArm = Description.LeftArm or 0,
		RightArm = Description.RightArm or 0,
		LeftLeg = Description.LeftLeg or 0,
		RightLeg = Description.RightLeg or 0,
		HeadShape = Serializer.GetHeadShape(Description),
		MakeupItems = Serializer.GetMakeups(Description),
		ProportionScale = Description.ProportionScale or 0,
		DepthScale = Description.DepthScale or 1,
		HeightScale = Description.HeightScale or 1,
		WidthScale = Description.WidthScale or 1,
		BodyTypeScale = Description.BodyTypeScale or 0,
		HeadScale = Description.HeadScale or 1,
		LayeredAccessories = Serializer.GetLayered(Description),
		AccessoryRefinements = Serializer.GetRefinements(Description, Character),
		StaticFacialAnimation = false,
	}

	for _, Category in AccessoryCategories do
		Properties[Category] = table.concat(Lists[Category], ",")
	end

	pcall(function()
		Properties.StaticFacialAnimation = Description.StaticFacialAnimation == true
	end)

	pcall(function()
		local Entries = {}
		for _, Accessory in Description:GetAccessories(true) do
			local Entry = {
				AssetId = Accessory.AssetId,
				AccessoryType = if Accessory.AccessoryType then Accessory.AccessoryType.Name else "Unknown",
				IsLayered = Accessory.IsLayered == true,
			}
			if Accessory.Order ~= nil then
				Entry.Order = Accessory.Order
			end
			if Accessory.Puffiness ~= nil then
				Entry.Puffiness = Accessory.Puffiness
			end
			table.insert(Entries, Entry)
		end
		Properties.AllAccessories = Entries
	end)

	pcall(function()
		if type(Description.GetEmotes) == "function" then
			Properties.Emotes = Description:GetEmotes()
		end
	end)
	pcall(function()
		if type(Description.GetEquippedEmotes) == "function" then
			Properties.EquippedEmotes = Description:GetEquippedEmotes()
		end
	end)
	return Properties
end

function Serializer.Signature(Properties: AvatarProperties, RigType: any): string
	local Success, Result = Util.Encode({ Properties = Properties, RigType = tostring(RigType) })
	return if Success then Result else tostring(Properties)
end

function Serializer.ResolveHeadAssetId(Properties: AvatarProperties): number?
	return Util.ParseAssetId(Properties.Head)
		or Util.ParseAssetId(Properties.HeadAssetId)
		or Util.ParseAssetId(Properties.HeadId)
		or (if type(Properties.BodyParts) == "table" then Util.ParseAssetId(Properties.BodyParts.Head) else nil)
		or (if type(Properties.EquippedAssets) == "table" then Util.ParseAssetId(Properties.EquippedAssets.Head) else nil)
end

function Serializer.ApplyHeadShapeToDescription(Description: HumanoidDescription, Properties: AvatarProperties): boolean
	if not Description or type(Properties) ~= "table" then
		return false
	end
	local Shape = Util.Trim(Properties.HeadShape)
	if Shape == "" then
		return false
	end
	local HeadAssetId = Serializer.ResolveHeadAssetId(Properties)
	if not HeadAssetId then
		return false
	end
	local Success = pcall(function()
		local Part = Instance.new("BodyPartDescription")
		Part.BodyPart = Enum.BodyPart.Head
		Part.AssetId = HeadAssetId
		Part.HeadShape = Shape
		Part.Parent = Description
	end)
	return Success
end

function Serializer.Reconstruct(Properties: AvatarProperties): HumanoidDescription
	local Description = Instance.new("HumanoidDescription")
	if type(Properties) ~= "table" then
		return Description
	end

	local HasHeadShape = Util.Trim(Properties.HeadShape) ~= ""
	local HeadShapeApplied = Serializer.ApplyHeadShapeToDescription(Description, Properties)

	local DirectProperties = {
		"Face",
		"Shirt",
		"Pants",
		"GraphicTShirt",
		"Head",
		"Torso",
		"LeftArm",
		"RightArm",
		"LeftLeg",
		"RightLeg",
		"WalkAnimation",
		"MoodAnimation",
		"ClimbAnimation",
		"FallAnimation",
		"RunAnimation",
		"SwimAnimation",
		"IdleAnimation",
		"JumpAnimation",
	}
	for _, Name in DirectProperties do
		local AssetId = Util.ParseAssetId(Properties[Name])
		if AssetId and not (Name == "Head" and HasHeadShape and HeadShapeApplied) then
			pcall(function()
				Description[Name] = AssetId
			end)
		end
	end

	if not HeadShapeApplied and (Description.Head == 0 or not Description.Head) then
		local Fallback = Serializer.ResolveHeadAssetId(Properties)
		if Fallback then
			pcall(function()
				Description.Head = Fallback
			end)
		end
	end

	if Properties.StaticFacialAnimation ~= nil then
		pcall(function()
			Description.StaticFacialAnimation = Properties.StaticFacialAnimation == true
		end)
	end
	if type(Properties.Emotes) == "table" then
		pcall(Description.SetEmotes, Description, Properties.Emotes)
	end
	if type(Properties.EquippedEmotes) == "table" then
		pcall(Description.SetEquippedEmotes, Description, Properties.EquippedEmotes)
	end

	if type(Properties.MakeupItems) == "table" then
		for _, Makeup in Properties.MakeupItems do
			pcall(function()
				local AssetId = Util.ParseAssetId(Makeup.AssetId)
				local MakeupType = Enum.MakeupType[tostring(Makeup.MakeupType)]
				if AssetId and MakeupType then
					local Item = Instance.new("MakeupDescription")
					Item.AssetId = AssetId
					Item.Order = tonumber(Makeup.Order) or 1
					Item.MakeupType = MakeupType
					Item.Parent = Description
				end
			end)
		end
	end

	local Refinements = Properties.AccessoryRefinements or {}
	if type(Properties.AllAccessories) == "table" then
		local Accessories = {}
		for _, Entry in Properties.AllAccessories do
			if type(Entry) ~= "table" or not Entry.AssetId or not Entry.AccessoryType then
				continue
			end
			local AssetId = Util.ParseAssetId(Entry.AssetId)
			local TypeSuccess, AccessoryType = pcall(function()
				return Enum.AccessoryType[Entry.AccessoryType]
			end)
			if not AssetId or not TypeSuccess or not AccessoryType then
				continue
			end
			local Accessory: any = { AssetId = AssetId, AccessoryType = AccessoryType }
			local Source = Refinements[tostring(AssetId)] or Entry
			if Source.Position then
				Accessory.Position = Serializer.TableToVector(Source.Position, Vector3.zero)
			end
			if Source.Rotation then
				Accessory.Rotation = Serializer.TableToVector(Source.Rotation, Vector3.zero)
			end
			if Source.Scale then
				Accessory.Scale = Serializer.TableToVector(Source.Scale, Vector3.one)
			end
			if Entry.IsLayered then
				Accessory.IsLayered = true
				Accessory.Order = tonumber(Entry.Order) or 0
				if Entry.Puffiness ~= nil then
					Accessory.Puffiness = tonumber(Entry.Puffiness) or 0
				end
			end
			table.insert(Accessories, Accessory)
		end
		pcall(Description.SetAccessories, Description, Accessories, true)
	else
		for _, Name in AccessoryCategories do
			if Properties[Name] ~= nil then
				pcall(function()
					Description[Name] = tostring(Properties[Name])
				end)
			end
		end
	end

	for _, Name in { "RightArmColor", "TorsoColor", "RightLegColor", "LeftLegColor", "LeftArmColor", "HeadColor" } do
		local Color = Serializer.TableToColor(Properties[Name])
		if Color then
			pcall(function()
				Description[Name] = Color
			end)
		end
	end

	for _, Name in { "ProportionScale", "DepthScale", "HeightScale", "WidthScale", "BodyTypeScale", "HeadScale" } do
		if Properties[Name] ~= nil then
			pcall(function()
				Description[Name] = tonumber(Properties[Name]) or 1
			end)
		end
	end

	return Description
end

function Serializer.ApplyBodyColors(Model: Model, Properties: AvatarProperties)
	if not Model or type(Properties) ~= "table" then
		return
	end
	local Colors = Model:FindFirstChildOfClass("BodyColors") or Instance.new("BodyColors")
	Colors.Parent = Model
	local Map = {
		HeadColor = "HeadColor3",
		TorsoColor = "TorsoColor3",
		LeftArmColor = "LeftArmColor3",
		RightArmColor = "RightArmColor3",
		LeftLegColor = "LeftLegColor3",
		RightLegColor = "RightLegColor3",
	}
	for Key, Target in Map do
		local Color = Serializer.TableToColor(Properties[Key])
		if Color then
			pcall(function()
				Colors[Target] = Color
			end)
		end
	end
end

function Serializer.ApplyHeadShape(Model: Model, Properties: AvatarProperties)
	if not Model or type(Properties) ~= "table" or Properties.HeadShape == nil then
		return
	end
	local Head = Model:FindFirstChild("Head")
	local Mesh = Head and Head:FindFirstChildOfClass("SpecialMesh")
	if not Mesh then
		return
	end
	local Shape = string.lower(tostring(Properties.HeadShape))
	if string.find(Shape, "block") then
		Mesh.MeshType = Enum.MeshType.Brick
	elseif string.find(Shape, "round") or string.find(Shape, "standard") then
		Mesh.MeshType = Enum.MeshType.Head
	end
end

local function ResolveAccessoryAssetId(Accessory: Accessory, Handle: BasePart): number?
	local AssetId
	pcall(function()
		AssetId = Util.ParseAssetId(Accessory:GetAttribute("AssetId"))
	end)
	if not AssetId then
		pcall(function()
			AssetId = Util.ParseAssetId(Handle:GetAttribute("AssetId"))
		end)
	end
	if not AssetId then
		local Mesh = Handle:FindFirstChildOfClass("SpecialMesh")
		if Mesh and Mesh.MeshId then
			AssetId = Util.ParseAssetId(Mesh.MeshId)
		end
	end
	if not AssetId and Handle:IsA("MeshPart") and Handle.MeshId then
		AssetId = Util.ParseAssetId(Handle.MeshId)
	end
	return AssetId
end

function Serializer.ApplyRigidRefinements(Model: Model, Properties: AvatarProperties?): number
	local Refinements = Properties and Properties.AccessoryRefinements
	if type(Refinements) ~= "table" then
		return 0
	end
	local Matched = 0
	local Used = {}

	for _, Accessory in Model:GetDescendants() do
		if not Accessory:IsA("Accessory") then
			continue
		end
		local Handle = Accessory:FindFirstChild("Handle")
		if not Handle then
			continue
		end
		local AssetId = ResolveAccessoryAssetId(Accessory, Handle)
		local Entry = (AssetId and Refinements[tostring(AssetId)]) or Refinements[Accessory.Name]
		if type(Entry) ~= "table" then
			continue
		end
		local Key = AssetId or Accessory.Name
		if Used[Key] then
			continue
		end

		local Position = Serializer.TableToVector(Entry.Position, Vector3.zero)
		local Rotation = Serializer.TableToVector(Entry.Rotation, Vector3.zero)
		local Scale = Serializer.TableToVector(Entry.Scale, Vector3.one)
		local Offset = CFrame.new(Position)
			* CFrame.Angles(math.rad(Rotation.X), math.rad(Rotation.Y), math.rad(Rotation.Z))

		local Attachment = Handle:FindFirstChildOfClass("Attachment")
		if Attachment then
			Attachment.CFrame = Attachment.CFrame * Offset
		else
			local Weld = Handle:FindFirstChildOfClass("Weld")
				or Handle:FindFirstChildOfClass("WeldConstraint")
				or Handle:FindFirstChildOfClass("ManualWeld")
			if Weld and Weld:IsA("Weld") then
				Weld.C0 = Weld.C0 * Offset
			end
		end

		if Scale ~= Vector3.one then
			Handle.Size = Handle.Size * Scale
			local Mesh = Handle:FindFirstChildOfClass("SpecialMesh")
			if Mesh then
				Mesh.Scale = Mesh.Scale * Scale
			end
		end
		Used[Key] = true
		Matched += 1
	end
	return Matched
end

function Serializer.CountAccessories(Data: AvatarData?): number
	local Properties = Data and Data.Properties
	if type(Properties) ~= "table" then
		return 0
	end
	local Count = 0
	if type(Properties.AllAccessories) == "table" then
		for _, Entry in Properties.AllAccessories do
			if type(Entry) == "table" and Util.ParseAssetId(Entry.AssetId) then
				Count += 1
			end
		end
		return Count
	end
	for _, Category in AccessoryCategories do
		local Value = Properties[Category]
		if Value ~= nil and tostring(Value) ~= "" and tostring(Value) ~= "0" then
			for _ in string.gmatch(tostring(Value), "%d+") do
				Count += 1
			end
		end
	end
	return Count
end

function Serializer.CaptureHumanoid(Humanoid: Humanoid, Character: Model?): (AvatarProperties?, string?)
	local Success, Description = pcall(Humanoid.GetAppliedDescription, Humanoid)
	if not Success or not Description then
		return nil, "Could not read the currently applied avatar."
	end
	local Properties = Serializer.Capture(Description, Character)
	pcall(Description.Destroy, Description)
	if type(Properties) ~= "table" then
		return nil, "Could not serialize the avatar."
	end
	return Properties
end

local Store = {}
Store.__index = Store

function Store.new(Folder: string)
	return setmetatable({ Folder = Folder, Avatars = {} :: { AvatarData } }, Store)
end

function Store:SetFolder(Folder: string)
	self.Folder = Folder
end

function Store:EnsureFolder(): boolean
	return FileApi.EnsureFolder(self.Folder)
end

function Store.SanitizeFileName(Name: any): string?
	local Clean = Util.Trim(Name)
	Clean = string.gsub(Clean, '[<>:"/\\|%?%*]', "-")
	Clean = string.gsub(Clean, "[%. ]+$", "")
	if string.lower(string.sub(Clean, -4)) == Constants.FileExtension then
		Clean = string.sub(Clean, 1, -5)
	end
	if Clean == "" then
		return nil
	end
	return Clean .. Constants.FileExtension
end

function Store:GetNextPath(DisplayName: string?): string?
	self:EnsureFolder()
	if type(isfile) ~= "function" then
		return nil
	end
	local FileName = Store.SanitizeFileName(DisplayName or "Avatar")
	if not FileName then
		return nil
	end
	local Base = string.sub(FileName, 1, -5)
	for Index = 1, 10000 do
		local Candidate = if Index > 1 then Base .. tostring(Index) else Base
		local Path = `{self.Folder}/{Candidate}{Constants.FileExtension}`
		if not FileApi.Exists(Path) then
			return Path
		end
	end
	return nil
end

function Store:ReadFiles(): { AvatarData }
	local Result = {}
	if type(readfile) ~= "function" then
		return Result
	end
	self:EnsureFolder()

	local Paths = {}
	for _, Path in FileApi.List(self.Folder) do
		if string.match(string.lower(Path), "%.ava$") then
			table.insert(Paths, Path)
		end
	end
	table.sort(Paths, function(Left, Right)
		return string.lower(Left) < string.lower(Right)
	end)

	for _, Path in Paths do
		local Read, Contents = FileApi.Read(Path)
		if not Read then
			continue
		end
		local Decoded, Data = Util.Decode(Contents)
		if Decoded and type(Data) == "table" and type(Data.Properties) == "table" then
			Data.FileName = Data.FileName or Util.GetFileName(Path)
			Data.FilePath = Data.FilePath or Path
			Data.Source = "ava"
			table.insert(Result, Data)
		end
	end
	return Result
end

function Store:ReadLegacy(Existing: { AvatarData }): { AvatarData }
	local Result = {}
	if not FileApi.Exists(Constants.LegacyFile) then
		return Result
	end
	local Read, Contents = FileApi.Read(Constants.LegacyFile)
	if not Read then
		return Result
	end
	local Decoded, List = Util.Decode(Contents)
	if not Decoded or type(List) ~= "table" then
		return Result
	end

	for _, Data in List do
		if type(Data) ~= "table" or type(Data.Properties) ~= "table" then
			continue
		end
		local Duplicate = false
		if Data.Signature then
			for _, Current in Existing do
				if Current.Signature == Data.Signature then
					Duplicate = true
					break
				end
			end
		end
		if not Duplicate then
			Data.Source = "legacy"
			Data.FileName = Data.FileName or "SavedAvatars.json"
			table.insert(Result, Data)
		end
	end
	return Result
end

function Store:Load(): number
	local Files = self:ReadFiles()
	local Legacy = self:ReadLegacy(Files)
	table.clear(self.Avatars)
	for _, Data in Files do
		table.insert(self.Avatars, Data)
	end
	for _, Data in Legacy do
		table.insert(self.Avatars, Data)
	end
	return #self.Avatars
end

function Store:Write(Data: AvatarData): (boolean, string)
	if type(writefile) ~= "function" then
		return false, "The executor does not provide writefile()."
	end
	self:EnsureFolder()
	local Path = Data.FilePath or self:GetNextPath(Data.DisplayName or Data.Name)
	if not Path then
		return false, "No free avatar filename was found."
	end
	Data.FilePath = Path
	Data.FileName = Util.GetFileName(Path)
	Data.Source = "ava"
	local Encoded, Contents = Util.Encode(Data)
	if not Encoded then
		return false, tostring(Contents)
	end
	local Success, Err = FileApi.Write(Path, Contents)
	if not Success then
		return false, tostring(Err)
	end
	return true, Path
end

function Store:WriteLegacy(): (boolean, any)
	FileApi.EnsureFolder(Constants.LegacyFolder)
	local Entries = {}
	for _, Entry in self.Avatars do
		if Entry.Source ~= "legacy" then
			continue
		end
		local Copy = {}
		for Key, Value in Entry do
			if Key ~= "Source" and Key ~= "FilePath" and not (Key == "FileName" and Value == "SavedAvatars.json") then
				Copy[Key] = Value
			end
		end
		table.insert(Entries, Copy)
	end
	local Encoded, Contents = Util.Encode(Entries)
	if not Encoded then
		return false, Contents
	end
	return FileApi.Write(Constants.LegacyFile, Contents)
end

function Store:Add(Data: AvatarData)
	table.insert(self.Avatars, 1, Data)
end

function Store:Remove(Data: AvatarData): boolean
	local Index = table.find(self.Avatars, Data)
	if Index then
		table.remove(self.Avatars, Index)
		return true
	end
	return false
end

function Store:Create(Data: AvatarData): (boolean, string)
	local Success, Result = self:Write(Data)
	if Success then
		self:Add(Data)
	end
	return Success, Result
end

function Store:Rename(Data: AvatarData, NewName: string): (boolean, string)
	local DisplayName = Util.Trim(NewName)

	if Data.Source == "legacy" then
		local Previous = Data.DisplayName
		Data.DisplayName = DisplayName
		local Success, Err = self:WriteLegacy()
		if not Success then
			Data.DisplayName = Previous
			return false, tostring(Err)
		end
		return true, DisplayName
	end

	if Data.Source ~= "ava" then
		return false, "This is not a .ava avatar file."
	end
	if type(writefile) ~= "function" or type(isfile) ~= "function" or type(delfile) ~= "function" then
		return false, "The executor must provide writefile(), isfile(), and delfile()."
	end
	local FileName = Store.SanitizeFileName(NewName)
	if not FileName then
		return false, "The filename is empty or invalid."
	end
	self:EnsureFolder()

	local OldPath = Data.FilePath or (Data.FileName and `{self.Folder}/{Data.FileName}`)
	if not OldPath then
		return false, "The avatar file path is unavailable."
	end
	local NewPath = `{self.Folder}/{FileName}`
	local SamePath = string.lower(OldPath) == string.lower(NewPath)
	if not SamePath and FileApi.Exists(NewPath) then
		return false, "An avatar with that filename already exists."
	end

	local Rewritten = Util.CopyDictionary(Data)
	Rewritten.FilePath = NewPath
	Rewritten.FileName = FileName
	Rewritten.DisplayName = DisplayName
	Rewritten.Source = "ava"

	local Encoded, Contents = Util.Encode(Rewritten)
	if not Encoded then
		return false, tostring(Contents)
	end
	local Wrote, WriteErr = FileApi.Write(NewPath, Contents)
	if not Wrote then
		return false, tostring(WriteErr)
	end
	if not SamePath then
		local Deleted, DeleteErr = FileApi.Delete(OldPath)
		if not Deleted then
			FileApi.Delete(NewPath)
			return false, tostring(DeleteErr)
		end
	end

	for Key, Value in Rewritten do
		Data[Key] = Value
	end
	return true, NewPath
end

function Store:Delete(Data: AvatarData): (boolean, string?)
	if Data.Source == "legacy" then
		if type(writefile) ~= "function" then
			return false, "The executor does not provide writefile()."
		end
		local Index = table.find(self.Avatars, Data)
		if not Index then
			return false, "Avatar is not in the list."
		end
		table.remove(self.Avatars, Index)
		local Success, Err = self:WriteLegacy()
		if not Success then
			table.insert(self.Avatars, Index, Data)
			return false, tostring(Err)
		end
		return true
	end

	local Path = Data.FilePath or (Data.FileName and `{self.Folder}/{Data.FileName}`)
	if not Path or type(delfile) ~= "function" then
		return false, "The executor does not provide delfile()."
	end
	local Success, Err = FileApi.Delete(Path)
	if not Success then
		return false, tostring(Err)
	end
	self:Remove(Data)
	return true
end

function Store:FindMatch(Data: AvatarData): AvatarData?
	if type(Data) ~= "table" then
		return nil
	end
	local Target = Data.Signature
	if not Target and Data.Properties then
		Target = Serializer.Signature(Data.Properties, Data.RigType or "R6")
	end
	if not Target then
		return nil
	end
	for _, Existing in self.Avatars do
		local Signature = Existing.Signature
		if not Signature and Existing.Properties then
			Signature = Serializer.Signature(Existing.Properties, Existing.RigType or "R6")
			Existing.Signature = Signature
		end
		if Signature == Target then
			return Existing
		end
	end
	return nil
end

function Store:Find(Query: any): AvatarData?
	if type(Query) == "table" then
		return if table.find(self.Avatars, Query) then Query else nil
	end
	if type(Query) == "number" then
		return self.Avatars[Query]
	end
	local Text = string.lower(Util.Trim(Query))
	if Text == "" then
		return nil
	end
	for _, Data in self.Avatars do
		local Names = { Data.DisplayName, Data.Name, Data.Username, Data.FileName }
		for _, Name in Names do
			if Name and string.lower(tostring(Name)) == Text then
				return Data
			end
		end
	end
	for _, Data in self.Avatars do
		local Names = { Data.DisplayName, Data.Name, Data.Username, Data.FileName }
		for _, Name in Names do
			if Name and string.find(string.lower(tostring(Name)), Text, 1, true) then
				return Data
			end
		end
	end
	return nil
end

local Catalog = {}
Catalog.IsActive = game.PlaceId == Constants.CatalogPlaceId

function Catalog.GetRemotes(): (any, any)
	if not Catalog.IsActive then
		return nil, nil
	end
	local Events = ReplicatedStorage:FindFirstChild("Events")
	if not Events then
		return nil, nil
	end
	return Events:FindFirstChild("CatalogGuiRemote"), Events:FindFirstChild("SavedOutfitsRemote")
end

function Catalog.Wear(Data: AvatarData): (boolean, any)
	if not Catalog.IsActive then
		return false, "Not in Catalog Avatar Creator."
	end
	if not Data or type(Data.Properties) ~= "table" then
		return false, "Avatar has no saved properties."
	end
	local GuiRemote = Catalog.GetRemotes()
	if not GuiRemote then
		return false, "CatalogGuiRemote was not found."
	end

	local Properties = {}
	for Key, Value in Data.Properties do
		if Key ~= "Emotes" and Key ~= "EquippedEmotes" and Key ~= "AllAccessories" then
			Properties[Key] = Value
		end
	end

	local Success, Result = pcall(function()
		return GuiRemote:InvokeServer({
			Properties = Properties,
			Action = "CreateAndWearHumanoidDescription",
			RigType = Util.ParseRigType(Data.RigType),
		})
	end)
	if not Success then
		return false, tostring(Result)
	end
	return true, Result
end

function Catalog.SaveOutfit(Data: AvatarData): (boolean, any, any)
	if not Catalog.IsActive then
		return false, "Not in Catalog Avatar Creator."
	end
	if not Data or not Data.Properties then
		return false, "Avatar has no saved properties."
	end
	local _, OutfitRemote = Catalog.GetRemotes()
	if not OutfitRemote then
		return false, "SavedOutfitsRemote was not found."
	end

	local Worn, WearError = Catalog.Wear(Data)
	if not Worn then
		return false, WearError
	end

	local OutfitName = "Avatar Saver: " .. tostring(Data.Name or Data.Username or "Unknown")
	local Success, Result = pcall(function()
		return OutfitRemote:InvokeServer({
			OutfitName = OutfitName,
			Configs = {},
			Action = "CreateNewOutfit",
		})
	end)
	if not Success then
		return false, tostring(Result)
	end
	return true, OutfitName, Result
end

local PreviewCache = {}
PreviewCache.__index = PreviewCache

function PreviewCache.new(Limit: number)
	return setmetatable({ Limit = Limit, Models = {}, Order = {} }, PreviewCache)
end

function PreviewCache.GetKey(Data: AvatarData): string?
	if not Data then
		return nil
	end
	local Stable = Data.Signature or Data.FileName or Data.UserId or Data.Name
	if Stable ~= nil then
		return `{Stable}|{Data.RigType}`
	end
	local Success, Encoded = Util.Encode({ Properties = Data.Properties, RigType = tostring(Data.RigType) })
	return if Success then Encoded else tostring(Data)
end

function PreviewCache:Touch(Key: string)
	local Index = table.find(self.Order, Key)
	if Index then
		table.remove(self.Order, Index)
	end
	table.insert(self.Order, Key)
	while #self.Order > self.Limit do
		local OldKey = table.remove(self.Order, 1)
		local Old = self.Models[OldKey]
		self.Models[OldKey] = nil
		Util.Destroy(Old)
	end
end

function PreviewCache:Get(Key: string?): Model?
	if not Key then
		return nil
	end
	local Model = self.Models[Key]
	if not Model then
		return nil
	end
	if Model.Parent ~= nil then
		self.Models[Key] = nil
		return nil
	end
	self:Touch(Key)
	return Model
end

function PreviewCache:Set(Key: string?, Model: Model)
	if not Key then
		return
	end
	self.Models[Key] = Model
	self:Touch(Key)
end

function PreviewCache:Clear()
	for Key, Model in self.Models do
		Util.Destroy(Model)
		self.Models[Key] = nil
	end
	table.clear(self.Order)
end

function PreviewCache:Build(Data: AvatarData): Model?
	if not Data or not Data.Properties then
		return nil
	end
	local Description = Serializer.Reconstruct(Data.Properties)
	local RigType = Util.ParseRigType(Data.RigType)
	local Success, Model = pcall(function()
		if type(Players.CreateHumanoidModelFromDescriptionAsync) == "function" then
			return Players:CreateHumanoidModelFromDescriptionAsync(Description, RigType)
		end
		return Players:CreateHumanoidModelFromDescription(Description, RigType)
	end)
	Util.Destroy(Description)

	if not Success or typeof(Model) ~= "Instance" or not Model:IsA("Model") then
		Util.Destroy(Model)
		return nil
	end

	Model.Parent = nil
	Model:PivotTo(CFrame.new(0, 0, 0))
	Serializer.ApplyBodyColors(Model, Data.Properties)
	Serializer.ApplyHeadShape(Model, Data.Properties)
	self:Set(PreviewCache.GetKey(Data), Model)
	return Model
end

function PreviewCache.Preload(Model: Model): boolean
	local Targets = {}
	for _, Descendant in Model:GetDescendants() do
		if
			Descendant:IsA("MeshPart")
			or Descendant:IsA("SpecialMesh")
			or Descendant:IsA("Decal")
			or Descendant:IsA("Texture")
		then
			table.insert(Targets, Descendant)
		end
	end
	if #Targets == 0 then
		return true
	end
	return (pcall(ContentProvider.PreloadAsync, ContentProvider, Targets))
end

local AnimationSync = {}
AnimationSync.EmoteCache = {} :: { [string]: string }

export type AnimationBinding = {
	Update: () -> (),
	Destroy: () -> (),
}

local function NormalizeEmoteName(Raw: any): string
	local Value = string.lower(Util.Trim(Raw))
	return (string.gsub(Value, "[^%w]+", ""))
end

local function ReadAnimationId(Target: Instance?): string?
	if not Target then
		return nil
	end
	if Target:IsA("Animation") and Target.AnimationId ~= "" then
		return Target.AnimationId
	end
	if Target:IsA("StringValue") and Target.Value ~= "" then
		return Target.Value
	end
	return nil
end

function AnimationSync.GetIdFromFolder(Container: Instance?, Name: string): string?
	if not Container then
		return nil
	end
	local Target = Container:FindFirstChild(Name) or Container:FindFirstChild(string.lower(Name))
	if not Target and Name == "SwimIdle" then
		Target = Container:FindFirstChild("swimidle")
	end
	if not Target and Name == "Swim" then
		Target = Container:FindFirstChild("swim")
	end
	if not Target then
		return nil
	end
	local Direct = ReadAnimationId(Target)
	if Direct then
		return Direct
	end
	for _, Child in Target:GetChildren() do
		local Found = ReadAnimationId(Child)
		if Found then
			return Found
		end
	end
	return nil
end

function AnimationSync.ResolveIds(Model: Model, SavedProps: AvatarProperties?, IsR6: boolean): { [string]: string }
	local Defaults = if IsR6 then AnimationDefaults.R6 else AnimationDefaults.R15
	local Folder = Model:FindFirstChild("Animate")
	local Ids = {}

	for _, Key in AnimationKeys do
		if Key == "Sit" then
			Ids[Key] = AnimationSync.GetIdFromFolder(Folder, "Sit") or Defaults[Key]
		elseif IsR6 then
			Ids[Key] = Defaults[Key]
		else
			local FromFolder = AnimationSync.GetIdFromFolder(Folder, Key)
			local Saved = Util.ParseAssetId(SavedProps and SavedProps[Key .. "Animation"])
			local Final = if FromFolder and FromFolder ~= "" then FromFolder else nil
			if not Final and Saved then
				Final = "rbxassetid://" .. tostring(Saved)
			end
			if not Final or Final == "" then
				Final = Defaults[Key]
			end
			Ids[Key] = Final
		end
	end
	return Ids
end

local function FindSitId(Model: Model, Humanoid: Humanoid): number?
	local IsR6 = Util.IsR6Model(Model, Humanoid.RigType)
	return Util.ParseAssetId(AnimationSync.ResolveIds(Model, nil, IsR6).Sit)
end

function AnimationSync.IsSitSettled(Model: Model?): boolean
	if not Model then
		return false
	end
	local Humanoid = Model:FindFirstChildOfClass("Humanoid")
	local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")
	if not Humanoid or not Animator then
		return false
	end
	local SitId = FindSitId(Model, Humanoid)
	if not SitId then
		return false
	end

	local SitTrack
	for _, Track in Animator:GetPlayingAnimationTracks() do
		if Track.Animation and Track.IsPlaying and Util.ParseAssetId(Track.Animation.AnimationId) == SitId then
			SitTrack = Track
			break
		end
	end
	if not SitTrack then
		return false
	end
	if SitTrack.WeightTarget < 0.95 or math.abs(SitTrack.WeightCurrent - SitTrack.WeightTarget) > 0.02 then
		return false
	end
	for _, Track in Animator:GetPlayingAnimationTracks() do
		if Track ~= SitTrack and Track.IsPlaying and Track.WeightCurrent > 0.05 then
			return false
		end
	end
	return true
end

function AnimationSync.IsSitCleared(Character: Model?): boolean
	if not Character then
		return true
	end
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")
	if not Humanoid or not Animator then
		return true
	end
	local SitId = FindSitId(Character, Humanoid)
	if not SitId then
		return true
	end
	for _, Track in Animator:GetPlayingAnimationTracks() do
		if Track.Animation and Util.ParseAssetId(Track.Animation.AnimationId) == SitId then
			if Track.IsPlaying or Track.WeightCurrent > 0.05 or Track.WeightTarget > 0.05 then
				return false
			end
		end
	end
	return true
end

function AnimationSync.GetPlayerEmotes(Humanoid: Humanoid?): ({ [string]: { number } }, { any })
	local Emotes, Equipped = {}, {}
	if not Humanoid then
		return Emotes, Equipped
	end
	local Success, Description = pcall(Humanoid.GetAppliedDescription, Humanoid)
	if not Success or not Description then
		return Emotes, Equipped
	end

	pcall(function()
		for Name, Ids in Description:GetEmotes() do
			if type(Name) ~= "string" or type(Ids) ~= "table" then
				continue
			end
			local List = {}
			for _, AssetId in Ids do
				local Parsed = Util.ParseAssetId(AssetId)
				if Parsed then
					table.insert(List, Parsed)
				end
			end
			if #List > 0 then
				Emotes[Name] = List
			end
		end
	end)
	pcall(function()
		local Value = Description:GetEquippedEmotes()
		if type(Value) ~= "table" then
			return
		end
		for _, Entry in Value do
			if type(Entry) == "table" and type(Entry.Name) == "string" and Entry.Name ~= "" then
				table.insert(Equipped, { Slot = tonumber(Entry.Slot) or (#Equipped + 1), Name = Entry.Name })
			end
		end
	end)
	Util.Destroy(Description)
	return Emotes, Equipped
end

function AnimationSync.MergePlayerEmotes(Description: HumanoidDescription, Humanoid: Humanoid?, RigType: any)
	if not Description or Util.ParseRigType(RigType) ~= Enum.HumanoidRigType.R15 then
		return
	end
	local PlayerEmotes, PlayerEquipped = AnimationSync.GetPlayerEmotes(Humanoid)
	local Merged = {}
	pcall(function()
		for Name, Ids in Description:GetEmotes() do
			Merged[Name] = Ids
		end
	end)
	for Name, Ids in PlayerEmotes do
		Merged[Name] = Ids
	end
	if next(Merged) ~= nil then
		pcall(Description.SetEmotes, Description, Merged)
	end
	if #PlayerEquipped > 0 then
		local Valid = {}
		for _, Entry in PlayerEquipped do
			if Merged[Entry.Name] then
				table.insert(Valid, Entry)
			end
		end
		if #Valid > 0 then
			pcall(Description.SetEquippedEmotes, Description, Valid)
		end
	end
end

local function FindAnimationInAsset(Root: Instance?): string?
	if not Root then
		return nil
	end
	if Root:IsA("Animation") and Root.AnimationId ~= "" then
		return Root.AnimationId
	end
	for _, Descendant in Root:GetDescendants() do
		if Descendant:IsA("Animation") and Descendant.AnimationId ~= "" then
			return Descendant.AnimationId
		end
	end
	return nil
end

local function ResolveEmoteAnimation(CatalogAssetId: any): string?
	local Parsed = Util.ParseAssetId(CatalogAssetId)
	if not Parsed then
		return nil
	end
	local Key = tostring(Parsed)
	local Cached = AnimationSync.EmoteCache[Key]
	if Cached ~= nil then
		return Cached
	end

	local AnimationId: string? = nil
	pcall(function()
		if type(game.GetObjects) ~= "function" then
			return
		end
		local Objects = game:GetObjects("rbxassetid://" .. Key)
		if type(Objects) ~= "table" then
			return
		end
		for _, Root in Objects do
			AnimationId = FindAnimationInAsset(Root)
			if AnimationId then
				Util.Destroy(Root)
				break
			end
		end
	end)

	if not AnimationId then
		pcall(function()
			local Root = InsertService:LoadAsset(Parsed)
			AnimationId = FindAnimationInAsset(Root)
			Util.Destroy(Root)
		end)
	end

	if AnimationId then
		AnimationSync.EmoteCache[Key] = AnimationId
	end
	return AnimationId
end

local TrackPriorities = table.freeze({
	Idle = Enum.AnimationPriority.Idle,
	Walk = Enum.AnimationPriority.Movement,
	Run = Enum.AnimationPriority.Movement,
	Climb = Enum.AnimationPriority.Movement,
	Swim = Enum.AnimationPriority.Movement,
	SwimIdle = Enum.AnimationPriority.Movement,
	Jump = Enum.AnimationPriority.Action,
	Fall = Enum.AnimationPriority.Action,
	Sit = Enum.AnimationPriority.Action,
})

function AnimationSync.Bind(
	PlayerCharacter: Model,
	CloneModel: Model,
	SavedProps: AvatarProperties?,
	RigType: any
): AnimationBinding
	local Binding: AnimationBinding = { Update = function() end, Destroy = function() end }

	local PlayerHumanoid = PlayerCharacter and PlayerCharacter:FindFirstChildOfClass("Humanoid")
	local CloneHumanoid = CloneModel and CloneModel:FindFirstChildOfClass("Humanoid")
	if not PlayerHumanoid or not CloneHumanoid then
		return Binding
	end

	local PlayerAnimator = PlayerHumanoid:FindFirstChildOfClass("Animator")
	local CloneAnimator = CloneHumanoid:FindFirstChildOfClass("Animator")
	if not CloneAnimator then
		CloneAnimator = Instance.new("Animator")
		CloneAnimator.Parent = CloneHumanoid
	end
	for _, Track in CloneAnimator:GetPlayingAnimationTracks() do
		pcall(Track.Stop, Track, 0)
	end

	local IsR6 = Util.IsR6Model(CloneModel, Util.ParseRigType(RigType))
	local Defaults = if IsR6 then AnimationDefaults.R6 else AnimationDefaults.R15
	local AnimationIds = AnimationSync.ResolveIds(CloneModel, SavedProps, IsR6)

	local Alive = true
	local ActiveTracks: { [AnimationTrack]: AnimationTrack } = {}
	local StopConnections: { [AnimationTrack]: RBXScriptConnection } = {}
	local EmoteAnimations: { [AnimationTrack]: Animation } = {}
	local ActiveEmoteTrack: AnimationTrack? = nil
	local PlayedConnection: RBXScriptConnection? = nil

	local EmoteByAssetId: { [string]: string } = {}
	local EmoteByAnimationId: { [string]: string } = {}
	local PlayNameByCanonical: { [string]: string } = {}
	local EquippedNames: { [string]: string } = {}
	local KnownNames: { [string]: string } = {}
	local PlayerAnimate = PlayerCharacter:FindFirstChild("Animate")

	local function StopAllTracks(FadeTime: number?)
		for _, Connection in StopConnections do
			Util.Disconnect(Connection)
		end
		table.clear(StopConnections)

		for PlayerTrack, CloneTrack in ActiveTracks do
			pcall(CloneTrack.Stop, CloneTrack, FadeTime or 0.05)
			Util.Destroy(EmoteAnimations[PlayerTrack])
			EmoteAnimations[PlayerTrack] = nil
		end
		table.clear(ActiveTracks)
		table.clear(EmoteAnimations)
		ActiveEmoteTrack = nil
	end

	local function Remember(Map: { [string]: string }, AssetId: any, EmoteName: any, PlayName: any?)
		local Parsed = Util.ParseAssetId(AssetId)
		if not Parsed then
			return
		end
		local Normalized = NormalizeEmoteName(EmoteName)
		if Normalized == "" then
			return
		end
		Map[tostring(Parsed)] = Normalized
		local Exact = PlayName or EmoteName
		if type(Exact) == "string" and Exact ~= "" then
			PlayNameByCanonical[Normalized] = Exact
		end
	end

	local Applied
	if pcall(function()
		Applied = PlayerHumanoid:GetAppliedDescription()
	end) and Applied then
		pcall(function()
			local Equipped = Applied:GetEquippedEmotes()
			if type(Equipped) == "table" then
				for _, Entry in Equipped do
					if type(Entry) == "table" and type(Entry.Name) == "string" then
						EquippedNames[NormalizeEmoteName(Entry.Name)] = Entry.Name
					end
				end
			end
		end)
		pcall(function()
			local Emotes = Applied:GetEmotes()
			if type(Emotes) ~= "table" then
				return
			end
			for Name, Ids in Emotes do
				if type(Ids) ~= "table" then
					continue
				end
				local Exact = if type(Name) == "string" then Name else tostring(Name)
				for _, AssetId in Ids do
					Remember(EmoteByAssetId, AssetId, Exact, Exact)
					local Resolved = ResolveEmoteAnimation(AssetId)
					if Resolved then
						Remember(EmoteByAnimationId, Resolved, Exact, Exact)
					end
				end
			end
		end)
		Util.Destroy(Applied)
	end

	for Name, Assets in R6Emotes do
		for _, AssetId in Assets do
			Remember(EmoteByAssetId, AssetId, Name)
		end
		KnownNames[NormalizeEmoteName(Name)] = Name
	end
	for Normalized, Exact in EquippedNames do
		KnownNames[Normalized] = Exact
	end

	local function NamedEmoteFromHierarchy(Animation: Instance?): string?
		if not Animation then
			return nil
		end
		local Direct = KnownNames[NormalizeEmoteName(Animation.Name)]
		if Direct then
			return Direct
		end
		local Parent = Animation.Parent
		while Parent and Parent ~= PlayerCharacter do
			local Named = KnownNames[NormalizeEmoteName(Parent.Name)]
			if Named then
				return Named
			end
			if Parent == PlayerAnimate then
				break
			end
			Parent = Parent.Parent
		end
		return nil
	end

	local function HasLocomotionAncestor(Animation: Instance?): boolean
		if not Animation then
			return false
		end
		if LocomotionNames[NormalizeEmoteName(Animation.Name)] then
			return true
		end
		local Parent = Animation.Parent
		while Parent and Parent ~= PlayerCharacter do
			if LocomotionNames[NormalizeEmoteName(Parent.Name)] then
				return true
			end
			Parent = Parent.Parent
		end
		return false
	end

	local function IsLikelyR15Emote(PlayerTrack: AnimationTrack): boolean
		if IsR6 or not PlayerTrack or not PlayerTrack.Animation then
			return false
		end
		if HasLocomotionAncestor(PlayerTrack.Animation) then
			return false
		end
		local Priority = PlayerTrack.Priority
		local Allowed = Priority == Enum.AnimationPriority.Core
			or Priority == Enum.AnimationPriority.Action
			or Priority == Enum.AnimationPriority.Action2
			or Priority == Enum.AnimationPriority.Action3
			or Priority == Enum.AnimationPriority.Action4
		if not Allowed or not Util.ParseAssetId(PlayerTrack.Animation.AnimationId) then
			return false
		end
		return next(EquippedNames) ~= nil or next(EmoteByAnimationId) ~= nil or next(EmoteByAssetId) ~= nil
	end

	if PlayerAnimate then
		for _, Descendant in PlayerAnimate:GetDescendants() do
			if Descendant:IsA("Animation") then
				local Name = NamedEmoteFromHierarchy(Descendant)
				if Name then
					Remember(EmoteByAssetId, Descendant.AnimationId, Name)
				end
			end
		end
	end

	local function ResolveEmoteName(PlayerTrack: AnimationTrack): (string?, boolean)
		if not PlayerTrack or not PlayerTrack.Animation then
			return nil, false
		end
		local AssetId = Util.ParseAssetId(PlayerTrack.Animation.AnimationId)
		if AssetId then
			local Key = tostring(AssetId)
			local Mapped = EmoteByAnimationId[Key] or LegacyEmoteIds[Key] or EmoteByAssetId[Key]
			if Mapped then
				return Mapped, true
			end
		end
		local Named = NamedEmoteFromHierarchy(PlayerTrack.Animation)
		if Named then
			return NormalizeEmoteName(Named), true
		end
		if IsLikelyR15Emote(PlayerTrack) then
			return "__direct_r15_emote_track__", false
		end
		return nil, false
	end

	local function ChooseR6Animation(EmoteName: string): string?
		local List = R6Emotes[EmoteName]
		if type(List) ~= "table" or #List == 0 then
			return nil
		end
		if #List == 1 then
			return List[1]
		end
		return List[(math.floor(os.clock() * 1000) % #List) + 1]
	end

	local function FindFreshTrack(Before: { [AnimationTrack]: boolean }, ExpectedAssetId: any): AnimationTrack?
		local Expected = Util.ParseAssetId(ExpectedAssetId)
		local ExpectedKey = if Expected then tostring(Expected) else nil
		local Fallback: AnimationTrack? = nil
		for _, Candidate in CloneAnimator:GetPlayingAnimationTracks() do
			if Candidate.IsPlaying and not Before[Candidate] then
				local CandidateId = Candidate.Animation and Util.ParseAssetId(Candidate.Animation.AnimationId)
				if ExpectedKey and CandidateId and tostring(CandidateId) == ExpectedKey then
					return Candidate
				end
				Fallback = Fallback or Candidate
			end
		end
		return Fallback
	end

	local function SyncPhase(PlayerTrack: AnimationTrack, CloneTrack: AnimationTrack)
		if not PlayerTrack or not CloneTrack or not PlayerTrack.IsPlaying or not CloneTrack.IsPlaying then
			return
		end
		local PlayerId = PlayerTrack.Animation and Util.ParseAssetId(PlayerTrack.Animation.AnimationId)
		local CloneId = CloneTrack.Animation and Util.ParseAssetId(CloneTrack.Animation.AnimationId)
		if not PlayerId or not CloneId or PlayerId ~= CloneId then
			return
		end

		local function Apply(): boolean
			if not PlayerTrack.IsPlaying or not CloneTrack.IsPlaying then
				return true
			end
			if PlayerTrack.Length <= 0 or CloneTrack.Length <= 0 then
				return false
			end
			local Phase = math.clamp(PlayerTrack.TimePosition / PlayerTrack.Length, 0, 0.999999)
			pcall(function()
				CloneTrack.TimePosition = Phase * CloneTrack.Length
			end)
			return true
		end

		if Apply() then
			return
		end
		task.spawn(function()
			for _ = 1, 4 do
				RunService.Heartbeat:Wait()
				if not Alive or Apply() then
					return
				end
			end
		end)
	end

	local function PlayRegisteredEmote(EmoteName: string, PlayerTrack: AnimationTrack): AnimationTrack?
		if IsR6 then
			return nil
		end
		local PlayName = PlayNameByCanonical[EmoteName]
		if not PlayName then
			return nil
		end

		local Before = {}
		for _, Track in CloneAnimator:GetPlayingAnimationTracks() do
			Before[Track] = true
		end

		local Success, Result = pcall(function()
			return CloneHumanoid:PlayEmoteAsync(PlayName)
		end)
		if not Success or Result ~= true then
			return nil
		end

		local ExpectedId = PlayerTrack and PlayerTrack.Animation and PlayerTrack.Animation.AnimationId
		local CloneTrack: AnimationTrack? = nil
		local Deadline = os.clock() + 0.35
		repeat
			CloneTrack = FindFreshTrack(Before, ExpectedId)
			if CloneTrack then
				break
			end
			RunService.Heartbeat:Wait()
		until os.clock() >= Deadline

		if not CloneTrack then
			local Expected = Util.ParseAssetId(ExpectedId)
			if Expected then
				pcall(function()
					CloneTrack = CloneAnimator:GetTrackByAnimationId("rbxassetid://" .. tostring(Expected))
				end)
			end
		end

		if CloneTrack then
			pcall(function()
				CloneTrack.Priority = Enum.AnimationPriority.Action
				CloneTrack.Looped = true
			end)
			SyncPhase(PlayerTrack, CloneTrack)
		end
		return CloneTrack
	end

	local function PlayDirectEmote(AnimationId: string?, EmoteName: string, PlayerTrack: AnimationTrack): (AnimationTrack?, Animation?)
		if not AnimationId or AnimationId == "" then
			return nil, nil
		end
		local Animation = Instance.new("Animation")
		Animation.AnimationId = AnimationId

		local Loaded, CloneTrack = pcall(function()
			return CloneAnimator:LoadAnimation(Animation)
		end)
		if not Loaded or not CloneTrack then
			Animation:Destroy()
			return nil, nil
		end

		CloneTrack.Priority = Enum.AnimationPriority.Action
		CloneTrack.Looped = if IsR6 then R6EmoteLooped[EmoteName] == true else PlayerTrack.Looped

		if not pcall(CloneTrack.Play, CloneTrack, 0.08, 1, 1) then
			pcall(CloneTrack.Stop, CloneTrack, 0)
			Animation:Destroy()
			return nil, nil
		end
		SyncPhase(PlayerTrack, CloneTrack)
		return CloneTrack, Animation
	end

	local CatchEmote: (PlayerTrack: AnimationTrack) -> boolean

	local function PlayEmote(PlayerTrack: AnimationTrack, EmoteName: string, IsDirect: boolean): boolean
		if not PlayerTrack or not EmoteName then
			return false
		end
		StopAllTracks(0.08)

		local CloneTrack: AnimationTrack? = nil
		local Animation: Animation? = nil

		if not IsR6 and not IsDirect then
			CloneTrack = PlayRegisteredEmote(EmoteName, PlayerTrack)
		end
		if not CloneTrack then
			local AnimationId = if IsR6 then ChooseR6Animation(EmoteName) else PlayerTrack.Animation.AnimationId
			CloneTrack, Animation = PlayDirectEmote(AnimationId, EmoteName, PlayerTrack)
		end
		if not CloneTrack then
			return false
		end

		ActiveTracks[PlayerTrack] = CloneTrack
		EmoteAnimations[PlayerTrack] = Animation
		ActiveEmoteTrack = PlayerTrack

		local StoppedConnection: RBXScriptConnection
		StoppedConnection = PlayerTrack.Stopped:Connect(function()
			task.delay(0.12, function()
				if not Alive or ActiveEmoteTrack ~= PlayerTrack then
					return
				end
				if PlayerAnimator then
					for _, Replacement in PlayerAnimator:GetPlayingAnimationTracks() do
						if Replacement.IsPlaying and ResolveEmoteName(Replacement) == EmoteName then
							CatchEmote(Replacement)
							return
						end
					end
				end

				local Active = ActiveTracks[PlayerTrack]
				ActiveTracks[PlayerTrack] = nil
				StopConnections[PlayerTrack] = nil
				Util.Destroy(EmoteAnimations[PlayerTrack])
				EmoteAnimations[PlayerTrack] = nil
				if Active then
					pcall(Active.Stop, Active, 0.08)
				end
				Util.Disconnect(StoppedConnection)
				if ActiveEmoteTrack == PlayerTrack then
					ActiveEmoteTrack = nil
				end
			end)
		end)
		StopConnections[PlayerTrack] = StoppedConnection
		return true
	end

	CatchEmote = function(PlayerTrack: AnimationTrack): boolean
		if not PlayerTrack or not PlayerTrack.IsPlaying then
			return false
		end
		if ActiveTracks[PlayerTrack] then
			return true
		end
		local EmoteName, IsKnown = ResolveEmoteName(PlayerTrack)
		if not EmoteName then
			return false
		end
		if next(ActiveTracks) ~= nil and ActiveEmoteTrack ~= PlayerTrack and not IsKnown then
			return false
		end
		return PlayEmote(PlayerTrack, EmoteName, EmoteName == "__direct_r15_emote_track__")
	end

	if PlayerAnimator then
		for _, Track in PlayerAnimator:GetPlayingAnimationTracks() do
			task.defer(CatchEmote, Track)
		end
		PlayedConnection = PlayerAnimator.AnimationPlayed:Connect(function(Track)
			task.defer(CatchEmote, Track)
		end)
	end

	local Loaded: { [string]: AnimationTrack } = {}
	for Key, AnimationId in AnimationIds do
		if not AnimationId or AnimationId == "" then
			continue
		end
		local Animation = Instance.new("Animation")
		Animation.AnimationId = AnimationId
		local Success, Track = pcall(function()
			return CloneAnimator:LoadAnimation(Animation)
		end)
		if (not Success or not Track) and IsR6 and Defaults[Key] then
			local Fallback = Instance.new("Animation")
			Fallback.AnimationId = Defaults[Key]
			Success, Track = pcall(function()
				return CloneAnimator:LoadAnimation(Fallback)
			end)
		end
		if Success and Track then
			Track.Priority = TrackPriorities[Key] or Enum.AnimationPriority.Core
			Track.Looped = Key ~= "Jump"
			Loaded[Key] = Track
		end
	end

	local ActiveKey: string? = nil

	local function PlayTrack(Key: string, Track: AnimationTrack, ClimbSpeed: number)
		if Key == "Climb" then
			pcall(Track.Play, Track, 0.15, 1, 0)
			if Track.Length > 0 then
				pcall(function()
					Track.TimePosition = if ClimbSpeed < 0 then math.max(Track.Length - 0.001, 0) else 0
				end)
			end
			pcall(Track.AdjustSpeed, Track, ClimbSpeed)
		else
			pcall(Track.Play, Track, 0.15)
		end
	end

	Binding.Update = function()
		if not Alive or not CloneModel or not CloneModel.Parent then
			return
		end

		local Root = PlayerCharacter:FindFirstChild("HumanoidRootPart") or PlayerCharacter.PrimaryPart
		local MoveSpeed, VerticalVelocity, TotalVelocity = 0, 0, 0
		if Root then
			local Velocity = Root.AssemblyLinearVelocity or Root.Velocity
			MoveSpeed = Vector3.new(Velocity.X, 0, Velocity.Z).Magnitude
			VerticalVelocity = Velocity.Y
			TotalVelocity = Velocity.Magnitude
		end

		local MoveMagnitude = PlayerHumanoid.MoveDirection.Magnitude
		local State = PlayerHumanoid:GetState()
		local Seated = Util.IsSeated(PlayerHumanoid)

		if not IsR6 and ActiveEmoteTrack then
			local CloneEmote = ActiveTracks[ActiveEmoteTrack]
			if ActiveEmoteTrack.IsPlaying and CloneEmote and CloneEmote.IsPlaying then
				pcall(function()
					CloneEmote.Looped = true
				end)
			end
		end

		local Intentional = MoveMagnitude > 0.05 and MoveSpeed > 1.2
		local ReleaseEmote = Seated
			or Intentional
			or State == Enum.HumanoidStateType.Jumping
			or State == Enum.HumanoidStateType.Freefall
			or State == Enum.HumanoidStateType.Climbing
			or State == Enum.HumanoidStateType.Swimming
		if ReleaseEmote and next(ActiveTracks) ~= nil then
			StopAllTracks(0.08)
		end

		local DesiredKey = "Idle"
		local ClimbSpeed = 0

		if Seated and IsR6 then
			local SitTrack = Loaded.Sit
			if SitTrack then
				for Key, Track in Loaded do
					if Key ~= "Sit" and Track.IsPlaying then
						pcall(Track.Stop, Track, 0.05)
					end
				end
				SitTrack.Priority = Enum.AnimationPriority.Action4
				SitTrack.Looped = true
				if not SitTrack.IsPlaying then
					pcall(SitTrack.Play, SitTrack, 0.08, 1, 1)
				else
					pcall(SitTrack.AdjustWeight, SitTrack, 1, 0.05)
				end
				ActiveKey = "Sit"
				return
			end
			DesiredKey = "Sit"
		elseif Seated then
			DesiredKey = "Sit"
		elseif State == Enum.HumanoidStateType.Climbing then
			DesiredKey = "Climb"
			if VerticalVelocity > 0.1 then
				ClimbSpeed = math.clamp(VerticalVelocity / 8, 0.4, 2)
			elseif VerticalVelocity < -0.1 then
				ClimbSpeed = -math.clamp(math.abs(VerticalVelocity) / 8, 0.4, 2)
			end
		elseif State == Enum.HumanoidStateType.Swimming then
			DesiredKey = if TotalVelocity > 0.75 then "Swim" else "SwimIdle"
		elseif State == Enum.HumanoidStateType.Jumping then
			DesiredKey = "Jump"
		elseif State == Enum.HumanoidStateType.Freefall then
			local JumpTrack = Loaded.Jump
			DesiredKey = if ActiveKey == "Jump" and JumpTrack and JumpTrack.IsPlaying and VerticalVelocity > 0.1
				then "Jump"
				else "Fall"
		elseif MoveSpeed > 1.2 then
			DesiredKey = if MoveSpeed > 12 and Loaded.Run then "Run" else "Walk"
		end

		if not Loaded[DesiredKey] then
			if DesiredKey == "SwimIdle" then
				DesiredKey = if Loaded.Swim then "Swim" elseif Loaded.Idle then "Idle" else "Walk"
			elseif DesiredKey == "Swim" then
				DesiredKey = if Loaded.SwimIdle then "SwimIdle" elseif Loaded.Walk then "Walk" else "Idle"
			elseif DesiredKey == "Run" then
				DesiredKey = "Walk"
			end
			if not Loaded[DesiredKey] then
				DesiredKey = "Idle"
			end
		end

		local ActiveTrack = ActiveKey and Loaded[ActiveKey]
		local DesiredTrack = Loaded[DesiredKey]
		local SameAsset = ActiveTrack
			and DesiredTrack
			and ActiveTrack.Animation
			and DesiredTrack.Animation
			and ActiveTrack.Animation.AnimationId == DesiredTrack.Animation.AnimationId

		if ActiveKey ~= DesiredKey and not SameAsset then
			if ActiveTrack then
				pcall(ActiveTrack.Stop, ActiveTrack, 0.15)
			end
			ActiveKey = DesiredKey
			ActiveTrack = Loaded[ActiveKey]
			if ActiveTrack then
				PlayTrack(ActiveKey, ActiveTrack, ClimbSpeed)
			end
		elseif ActiveTrack and not ActiveTrack.IsPlaying then
			PlayTrack(ActiveKey, ActiveTrack, ClimbSpeed)
		end

		local Current = ActiveKey and Loaded[ActiveKey]
		if not Current or not Current.IsPlaying then
			return
		end
		if ActiveKey == "Walk" or ActiveKey == "Run" then
			pcall(Current.AdjustSpeed, Current, math.clamp(MoveSpeed / 14, 0.6, 2))
		elseif ActiveKey == "Climb" then
			pcall(Current.AdjustSpeed, Current, ClimbSpeed)
		elseif ActiveKey == "Swim" or ActiveKey == "SwimIdle" then
			local Speed = if IsR6 then math.clamp(TotalVelocity / 12, 0.5, 1.8) else math.clamp(TotalVelocity / 10, 0.6, 2)
			if ActiveKey == "SwimIdle" and TotalVelocity < 0.5 then
				Speed = 1
			end
			pcall(Current.AdjustSpeed, Current, Speed)
		end
	end

	Binding.Destroy = function()
		Alive = false
		StopAllTracks()
		Util.Disconnect(PlayedConnection)
		PlayedConnection = nil
	end

	return Binding
end

local PlaceholderR6 = {}
PlaceholderR6.__index = PlaceholderR6

function PlaceholderR6.new()
	return setmetatable({ Active = false, Building = false, Backup = nil }, PlaceholderR6)
end

local function IsClothingInstance(Child: Instance): boolean
	for _, ClassName in ClothingClasses do
		if Child:IsA(ClassName) then
			return true
		end
	end
	return false
end

local function IsHeadVisual(Child: Instance): boolean
	return Child:IsA("SpecialMesh") or Child:IsA("Mesh") or Child:IsA("Decal")
end

local function CloneSafe(Object: Instance): Instance?
	local Success, Clone = pcall(Object.Clone, Object)
	return if Success then Clone else nil
end

function PlaceholderR6.Capture(Character: Model): any
	if not Character or not Character.Parent then
		return nil
	end
	local Backup = { Character = Character, Items = {}, PartAppearance = {}, HeadVisuals = {} }

	for _, Child in Character:GetChildren() do
		if IsClothingInstance(Child) then
			local Clone = CloneSafe(Child)
			if Clone then
				table.insert(Backup.Items, Clone)
			end
		end
	end
	for _, Name in R6BodyPartNames do
		local Part = Character:FindFirstChild(Name)
		if Part and Part:IsA("BasePart") then
			Backup.PartAppearance[Name] = { Color = Part.Color, Material = Part.Material }
		end
	end
	local Head = Character:FindFirstChild("Head")
	if Head then
		for _, Child in Head:GetChildren() do
			if IsHeadVisual(Child) then
				local Clone = CloneSafe(Child)
				if Clone then
					table.insert(Backup.HeadVisuals, Clone)
				end
			end
		end
	end
	return Backup
end

function PlaceholderR6.ClearAppearance(Character: Model)
	if not Character then
		return
	end
	for _, Child in Character:GetChildren() do
		if IsClothingInstance(Child) then
			Util.Destroy(Child)
		end
	end
	local Head = Character:FindFirstChild("Head")
	if Head then
		for _, Child in Head:GetChildren() do
			if IsHeadVisual(Child) then
				Util.Destroy(Child)
			end
		end
	end
end

function PlaceholderR6:Restore()
	local Backup = self.Backup
	self.Backup = nil
	self.Active = false
	self.Building = false
	if not Backup then
		return
	end

	local Character = Backup.Character
	if not Character or not Character.Parent then
		for _, Item in Backup.Items do
			Util.Destroy(Item)
		end
		for _, Item in Backup.HeadVisuals do
			Util.Destroy(Item)
		end
		return
	end

	PlaceholderR6.ClearAppearance(Character)
	for Name, Appearance in Backup.PartAppearance do
		local Part = Character:FindFirstChild(Name)
		if Part and Part:IsA("BasePart") then
			pcall(function()
				Part.Color = Appearance.Color
				Part.Material = Appearance.Material
			end)
		end
	end
	local Head = Character:FindFirstChild("Head")
	if Head then
		for _, Item in Backup.HeadVisuals do
			pcall(function()
				Item.Parent = Head
			end)
		end
	end
	for _, Item in Backup.Items do
		pcall(function()
			Item.Parent = Character
		end)
	end
end

local function AttachPlaceholderAccessory(Character: Model, Source: Accessory, Parts: { [string]: Instance? })
	local Accessory = Source:Clone()
	local Handle = Accessory:FindFirstChild("Handle")
	if not Handle then
		Accessory:Destroy()
		return
	end

	Handle.Anchored = false
	Handle.CanCollide = false
	Handle.CanTouch = false
	Handle.CanQuery = false
	Handle.Massless = true

	local Attachment = Handle:FindFirstChildWhichIsA("Attachment")
	local Target = Attachment and Character:FindFirstChild(Attachment.Name, true)
	local Part = if Target and Target.Parent:IsA("BasePart") then Target.Parent else (Parts.Head or Parts.Torso)

	if Target and Target.Parent:IsA("BasePart") then
		Handle.CFrame = Target.WorldCFrame * Attachment.CFrame:Inverse()
	elseif Attachment and Part then
		Handle.CFrame = Part.CFrame * CFrame.new(Attachment.Position)
	elseif Part then
		Handle.CFrame = Part.CFrame
	end

	if Part then
		local Weld = Instance.new("WeldConstraint")
		Weld.Part0 = Handle
		Weld.Part1 = Part
		Weld.Parent = Handle
	end

	for _, Descendant in Accessory:GetDescendants() do
		if Descendant:IsA("BasePart") and Descendant ~= Handle then
			Descendant.CanCollide = false
			Descendant.CanTouch = false
			Descendant.CanQuery = false
			Descendant.Massless = true
			if Part then
				local Weld = Instance.new("WeldConstraint")
				Weld.Part0 = Descendant
				Weld.Part1 = Handle
				Weld.Parent = Descendant
			end
		end
	end
	Accessory.Parent = Character
end

function PlaceholderR6:Apply(Data: AvatarData, Player: Player): (boolean, string?)
	if self.Building then
		return false, "Already applying placeholder mode."
	end
	if self.Active or self.Backup then
		self:Restore()
	end

	local Character = Player.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	if not Character or not Character.Parent or not Humanoid then
		return false, "Your character is not available."
	end
	if Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
		return false, "R15 uses the normal local try-on path."
	end
	if not Data or not Data.Properties then
		return false, "The selected avatar has no saved properties."
	end

	self.Building = true
	self.Backup = PlaceholderR6.Capture(Character)
	if not self.Backup then
		self.Building = false
		return false, "Could not back up your current R6 appearance."
	end

	local Description = Serializer.Reconstruct(Data.Properties)
	local Created, Result = pcall(function()
		return Players:CreateHumanoidModelFromDescriptionAsync(Description, Enum.HumanoidRigType.R6)
	end)
	Util.Destroy(Description)
	if not Created or typeof(Result) ~= "Instance" or not Result:IsA("Model") then
		self:Restore()
		return false, tostring(Result)
	end

	local Model: Model = Result
	local Success, Err = xpcall(function()
		PlaceholderR6.ClearAppearance(Character)
		local Parts = {}
		for _, Name in R6BodyPartNames do
			Parts[Name] = Character:FindFirstChild(Name)
		end

		for _, Child in Model:GetChildren() do
			if Child:IsA("Accessory") then
				AttachPlaceholderAccessory(Character, Child, Parts)
			elseif IsClothingInstance(Child) then
				Child:Clone().Parent = Character
			end
		end

		for _, Name in R6BodyPartNames do
			local Source, Target = Model:FindFirstChild(Name), Character:FindFirstChild(Name)
			if Source and Target and Source:IsA("BasePart") and Target:IsA("BasePart") then
				Target.Color = Source.Color
				Target.Material = Source.Material
			end
		end

		local SourceHead, TargetHead = Model:FindFirstChild("Head"), Character:FindFirstChild("Head")
		if SourceHead and TargetHead then
			for _, Child in SourceHead:GetChildren() do
				if IsHeadVisual(Child) then
					Child:Clone().Parent = TargetHead
				end
			end
		end
	end, debug.traceback)
	Util.Destroy(Model)

	if not Success then
		self:Restore()
		return false, tostring(Err)
	end
	self.Building = false
	self.Active = true
	return true
end

local PartGroups = table.freeze({
	Head = "Head",
	Torso = "Torso",
	UpperTorso = "Torso",
	LowerTorso = "Torso",
	["Left Arm"] = "LeftArm",
	LeftUpperArm = "LeftArm",
	LeftLowerArm = "LeftArm",
	LeftHand = "LeftArm",
	["Right Arm"] = "RightArm",
	RightUpperArm = "RightArm",
	RightLowerArm = "RightArm",
	RightHand = "RightArm",
	["Left Leg"] = "LeftLeg",
	LeftUpperLeg = "LeftLeg",
	LeftLowerLeg = "LeftLeg",
	LeftFoot = "LeftLeg",
	["Right Leg"] = "RightLeg",
	RightUpperLeg = "RightLeg",
	RightLowerLeg = "RightLeg",
	RightFoot = "RightLeg",
})

local GroupColorProperties = table.freeze({
	Head = "HeadColor3",
	Torso = "TorsoColor3",
	LeftArm = "LeftArmColor3",
	RightArm = "RightArmColor3",
	LeftLeg = "LeftLegColor3",
	RightLeg = "RightLegColor3",
})

local GamePresets = table.freeze({
	[9872472334] = table.freeze({ "Workspace.Rigs.{Name}" }),
})

local RigContainerNames = table.freeze({
	Rigs = true,
	Rig = true,
	Characters = true,
	Players = true,
	Entities = true,
	Avatars = true,
	Models = true,
	Bodies = true,
	Dummies = true,
	Game = true,
	Live = true,
	Alive = true,
})

local PlayerAttributeKeys = table.freeze({
	"Player",
	"Owner",
	"UserId",
	"PlayerName",
	"Username",
	"OwnerName",
	"OwnerId",
})

local ClothingProperties = table.freeze({
	Shirt = table.freeze({ "ShirtTemplate", "Color3" }),
	Pants = table.freeze({ "PantsTemplate", "Color3" }),
	ShirtGraphic = table.freeze({ "Graphic", "Color3" }),
})

local HeadMeshProperties = table.freeze({ "MeshType", "MeshId", "TextureId", "Scale", "Offset" })
local HeadMeshPartProperties = table.freeze({ "MeshId", "TextureID" })

local ManagedAttribute = "AvatarChangerManaged"

type RigProfile = {
	Model: Model,
	Humanoid: Humanoid?,
	Kind: string,
	Parts: { [string]: BasePart },
	Source: string,
	Score: number,
	Evade: boolean?,
	Bound: boolean?,
	Pending: boolean?,
	Tag: any?,
}

local RigResolver = {}
local EvadeRig = {}

local function IsGearDescendant(Object: Instance, Root: Instance): boolean
	local Current = Object.Parent
	while Current and Current ~= Root do
		if Current:IsA("Accoutrement") or Current:IsA("Tool") then
			return true
		end
		Current = Current.Parent
	end
	return false
end

function RigResolver.GetParts(Model: Model): { [string]: BasePart }
	local Parts: { [string]: BasePart } = {}
	for _, Child in Model:GetChildren() do
		if Child:IsA("BasePart") and BodyPartNames[Child.Name] and not Parts[Child.Name] then
			Parts[Child.Name] = Child
		end
	end
	for _, Descendant in Model:GetDescendants() do
		if
			Descendant:IsA("BasePart")
			and BodyPartNames[Descendant.Name]
			and not Parts[Descendant.Name]
			and not IsGearDescendant(Descendant, Model)
		then
			Parts[Descendant.Name] = Descendant
		end
	end
	return Parts
end

function RigResolver.NameMatches(Model: Instance, Player: Player): boolean
	local Name = Model.Name
	if Name == Player.Name or Name == Player.DisplayName or Name == tostring(Player.UserId) then
		return true
	end
	for _, Key in PlayerAttributeKeys do
		local Value = Model:GetAttribute(Key)
		if Value ~= nil then
			local Text = tostring(Value)
			if Text == Player.Name or Text == Player.DisplayName or Text == tostring(Player.UserId) then
				return true
			end
		end
	end
	return false
end

function RigResolver.IsVisible(Parts: { [string]: BasePart }): boolean
	for Name, Part in Parts do
		if Name ~= "HumanoidRootPart" and Part.Transparency < 0.99 and Part.LocalTransparencyModifier < 0.99 then
			return true
		end
	end
	return false
end

function RigResolver.Evaluate(Model: Model, Player: Player, Source: string, Base: number): RigProfile?
	local Parts = RigResolver.GetParts(Model)
	if not Parts.Head or not (Parts.Torso or Parts.UpperTorso) then
		return nil
	end
	local Humanoid = Model:FindFirstChildOfClass("Humanoid")
	local Score = Base
	if RigResolver.NameMatches(Model, Player) then
		Score += 20
	end
	if Humanoid then
		Score += 5
	end
	if RigResolver.IsVisible(Parts) then
		Score += 10
	else
		Score -= 40
	end
	return {
		Model = Model,
		Humanoid = Humanoid,
		Kind = if Parts.UpperTorso then "R15" else "R6",
		Parts = Parts,
		Source = Source,
		Score = Score,
	}
end

function RigResolver.ExpandToken(Token: string, Player: Player): string
	local Expanded = string.gsub(Token, "{(%w+)}", function(Key)
		if Key == "Name" then
			return Player.Name
		elseif Key == "DisplayName" then
			return Player.DisplayName
		elseif Key == "UserId" then
			return tostring(Player.UserId)
		end
		return nil
	end)
	return Expanded
end

function RigResolver.ResolvePath(Path: string, Player: Player): Instance?
	local Current: any = nil
	for Token in string.gmatch(Path, "[^%./\\]+") do
		local Expanded = RigResolver.ExpandToken(Token, Player)
		if Current == nil then
			local Lower = string.lower(Expanded)
			if Lower == "game" then
				Current = game
			elseif Lower == "workspace" then
				Current = Workspace
			else
				local Success, Service = pcall(GetService, Expanded)
				Current = if Success then Service else game:FindFirstChild(Expanded)
			end
		else
			Current = Current:FindFirstChild(Expanded)
		end
		if Current == nil then
			return nil
		end
	end
	return Current
end

function RigResolver.Collect(Player: Player, CustomPath: string?): { RigProfile }
	local Results: { RigProfile } = {}
	local Seen: { [Instance]: boolean } = {}

	local function Consider(Object: Instance?, Source: string, Base: number)
		if not Object or Seen[Object] or not Object:IsA("Model") then
			return
		end
		Seen[Object] = true
		local Profile = RigResolver.Evaluate(Object, Player, Source, Base)
		if Profile then
			table.insert(Results, Profile)
		end
	end

	local function ConsiderPath(Path: string, Source: string, Base: number)
		local Found = RigResolver.ResolvePath(Path, Player)
		if not Found then
			return
		end
		Consider(Found, Source, Base)
		if Found:IsA("Folder") or Found:IsA("Model") then
			Consider(Found:FindFirstChild(Player.Name), Source, Base)
		end
	end

	local Trimmed = Util.Trim(CustomPath)
	if Trimmed ~= "" then
		for Path in string.gmatch(Trimmed, "[^;]+") do
			ConsiderPath(Util.Trim(Path), "Custom", 100)
		end
	elseif EvadeRig.IsEnabled() then
		local Profile = EvadeRig.Profile(Player)
		if Profile and not Seen[Profile.Model] then
			Seen[Profile.Model] = true
			table.insert(Results, Profile)
		end
	end

	local Preset = GamePresets[game.PlaceId]
	if Preset then
		for _, Path in Preset do
			ConsiderPath(Path, "Preset", 80)
		end
	end

	Consider(Player.Character, "Character", 50)

	local Visited = 0
	local function Scan(Container: Instance, Depth: number)
		for _, Child in Container:GetChildren() do
			Visited += 1
			if Visited > 800 then
				return
			end
			if Child:IsA("Model") and RigResolver.NameMatches(Child, Player) then
				Consider(Child, "Scan", 40)
			end
			if Depth < 3 and RigContainerNames[Child.Name] and (Child:IsA("Folder") or Child:IsA("Model")) then
				Scan(Child, Depth + 1)
			end
		end
	end
	Scan(Workspace, 1)

	return Results
end

function RigResolver.Resolve(Player: Player, CustomPath: string?): (RigProfile?, string)
	local Candidates = RigResolver.Collect(Player, CustomPath)
	table.sort(Candidates, function(A, B)
		return A.Score > B.Score
	end)
	local Best = Candidates[1]
	if Best then
		return Best, "ok"
	end
	if EvadeRig.IsEnabled() and Util.Trim(CustomPath) == "" then
		return nil, "Your Evade rig is not in Workspace.Rigs yet. Wait until your character has spawned, then try again."
	end
	return nil,
		"No rig with a Head and Torso was found for your player. Set a rig path in Options, for example Workspace.Rigs.{Name}."
end

function RigResolver.WaitFor(
	Player: Player,
	CustomPath: string?,
	Timeout: number,
	Cancelled: () -> boolean
): (RigProfile?, string)
	local Started = os.clock()
	local Deadline = Started + Timeout
	local Profile, Reason = RigResolver.Resolve(Player, CustomPath)
	while os.clock() < Deadline and (not Profile or EvadeRig.IsPending(Profile, Started)) do
		if Cancelled() then
			return nil, "superseded"
		end
		task.wait(0.15)
		Profile, Reason = RigResolver.Resolve(Player, CustomPath)
	end
	return Profile, Reason
end

function RigResolver.Describe(Profile: RigProfile): string
	if Profile.Evade then
		return EvadeRig.Describe(Profile)
	end
	local Count = 0
	for _ in Profile.Parts do
		Count += 1
	end
	local HumanoidText = if Profile.Humanoid then "yes" else "no"
	return `{Profile.Model:GetFullName()} | {Profile.Kind} | {Profile.Source} | {Count} body parts | Humanoid: {HumanoidText}`
end

local EvadeSettings = table.freeze({
	RigFolder = "Rigs",
	CacheFolder = "PlayerCache",
	CharacterFolder = "Players",
	ParkedHeight = 40000,
	BindTimeout = 6,
	FirstPersonZoom = 1,
})

local EvadeModes = table.freeze({ "Auto", "Off" })

local EvadeGuardedProperties = table.freeze({
	"RigType",
	"EvaluateStateMachine",
	"RequiresNeck",
	"BreakJointsOnDeath",
	"DisplayDistanceType",
	"AutomaticScalingEnabled",
})

type EvadeGuard = {
	Humanoid: Humanoid?,
	Properties: { [string]: any },
	Children: { Instance },
	Joints: Instance?,
	JointChildren: { Instance },
}

EvadeRig.Modes = EvadeModes
EvadeRig.Mode = "Auto"
EvadeRig.HideFirstPerson = true

function EvadeRig.SetMode(Value: any)
	EvadeRig.Mode = if table.find(EvadeModes, Value) then Value else "Auto"
end

function EvadeRig.Detect(): boolean
	local Services = ReplicatedStorage:FindFirstChild("Services")
	local Asset = Services and Services:FindFirstChild("Asset")
	return Asset ~= nil
		and Asset:FindFirstChild("RigService") ~= nil
		and Workspace:FindFirstChild(EvadeSettings.RigFolder) ~= nil
		and Workspace:FindFirstChild(EvadeSettings.CacheFolder) ~= nil
end

function EvadeRig.IsEnabled(): boolean
	return EvadeRig.Mode ~= "Off" and EvadeRig.Detect()
end

function EvadeRig.GetFolder(): Instance?
	return Workspace:FindFirstChild(EvadeSettings.RigFolder)
end

function EvadeRig.FindCharacter(Player: Player): Model?
	local Character = Player.Character
	if Character and Character.Parent then
		return Character
	end
	local Folder = Workspace:FindFirstChild(EvadeSettings.CharacterFolder)
	local Found = Folder and Folder:FindFirstChild(Player.Name)
	if Found and Found:IsA("Model") then
		return Found
	end
	return nil
end

function EvadeRig.IsParked(Model: Model): boolean
	local Head = Model:FindFirstChild("Head")
	return Head ~= nil
		and Head:IsA("BasePart")
		and Head.Anchored
		and Head.Position.Y >= EvadeSettings.ParkedHeight
end

function EvadeRig.FindModel(Player: Player): (Model?, boolean)
	local Folder = EvadeRig.GetFolder()
	if not Folder then
		return nil, false
	end
	local Character = EvadeRig.FindCharacter(Player)
	local Tag = if Character then Character:GetAttribute("Tag") else nil
	local Fallback: Model? = nil
	local FallbackParked = false
	for _, Child in Folder:GetChildren() do
		if not Child:IsA("Model") or Child.Name ~= Player.Name then
			continue
		end
		local Parked = EvadeRig.IsParked(Child)
		if Tag ~= nil and not Parked and Child:GetAttribute("Tag") == Tag then
			return Child, true
		end
		if not Fallback or (Parked and not FallbackParked) then
			Fallback, FallbackParked = Child, Parked
		end
	end
	return Fallback, false
end

function EvadeRig.Profile(Player: Player): RigProfile?
	local Model, Bound = EvadeRig.FindModel(Player)
	if not Model then
		return nil
	end
	local Profile = RigResolver.Evaluate(Model, Player, "Evade", if Bound then 200 else 120)
	if not Profile then
		return nil
	end
	local Character = EvadeRig.FindCharacter(Player)
	local Expected = Character ~= nil and Character:GetAttribute("Tag") ~= nil
	Profile.Evade = true
	Profile.Bound = Bound
	Profile.Pending = Expected and not Bound
	Profile.Tag = Model:GetAttribute("Tag")
	return Profile
end

function EvadeRig.IsPending(Profile: RigProfile, Started: number): boolean
	return Profile.Evade == true
		and Profile.Pending == true
		and os.clock() - Started < EvadeSettings.BindTimeout
end

function EvadeRig.State(Profile: RigProfile): string
	if Profile.Bound then
		return "bound"
	end
	if EvadeRig.IsParked(Profile.Model) then
		return "parked"
	end
	return "waiting for bind"
end

function EvadeRig.Describe(Profile: RigProfile): string
	local Count = 0
	for _ in Profile.Parts do
		Count += 1
	end
	local Scale = Profile.Model:GetAttribute("Scale")
	local ScaleText = if type(Scale) == "number" then string.format(" | Scale %.2f", Scale) else ""
	local Humanoid = Profile.Humanoid
	local CustomText = if Humanoid and not Humanoid:FindFirstChildOfClass("HumanoidDescription")
		then " | Custom character rig"
		else ""
	local HumanoidText = if Humanoid then "yes" else "no"
	return `{Profile.Model:GetFullName()} | {Profile.Kind} | Evade {EvadeRig.State(Profile)} | Tag {tostring(Profile.Tag)}{ScaleText}{CustomText} | {Count} body parts | Humanoid: {HumanoidText}`
end

function EvadeRig.Summary(Player: Player): string
	if not EvadeRig.IsEnabled() then
		return "Evade mode is off."
	end
	local Profile = EvadeRig.Profile(Player)
	if not Profile then
		return "Your rig is not in Workspace.Rigs yet."
	end
	return EvadeRig.Describe(Profile)
end

function EvadeRig.Capture(Model: Model): EvadeGuard
	local Humanoid = Model:FindFirstChildOfClass("Humanoid")
	local Properties: { [string]: any } = {}
	local Children: { Instance } = {}
	if Humanoid then
		for _, Name in EvadeGuardedProperties do
			local Success, Value = pcall(function()
				return (Humanoid :: any)[Name]
			end)
			if Success then
				Properties[Name] = Value
			end
		end
		Children = Humanoid:GetChildren()
	end
	local Joints = Model:FindFirstChild("Joints")
	return {
		Humanoid = Humanoid,
		Properties = Properties,
		Children = Children,
		Joints = Joints,
		JointChildren = if Joints then Joints:GetChildren() else {},
	}
end

function EvadeRig.Compare(Guard: EvadeGuard, Model: Model): string?
	local Humanoid = Guard.Humanoid
	if Humanoid then
		if Humanoid.Parent ~= Model then
			return "the Evade Humanoid was moved or replaced"
		end
		for Name, Expected in Guard.Properties do
			local Success, Current = pcall(function()
				return (Humanoid :: any)[Name]
			end)
			if Success and Current ~= Expected then
				return `Humanoid.{Name} was changed`
			end
		end
		for _, Child in Guard.Children do
			if Child.Parent ~= Humanoid then
				return `Humanoid child {Child.Name} was removed`
			end
		end
	end
	local Joints = Guard.Joints
	if Joints then
		if Joints.Parent ~= Model then
			return "the Evade Joints folder was moved"
		end
		for _, Joint in Guard.JointChildren do
			if Joint.Parent ~= Joints then
				return `Evade joint {Joint.Name} was moved or removed`
			end
		end
	end
	return nil
end

function EvadeRig.HidesAccessories(): boolean
	return EvadeRig.HideFirstPerson and LocalPlayer.CameraMaxZoomDistance <= EvadeSettings.FirstPersonZoom
end

function EvadeRig.GetDescription(Player: Player): HumanoidDescription?
	local Cache = Workspace:FindFirstChild(EvadeSettings.CacheFolder)
	local Entry = Cache and Cache:FindFirstChild(Player.Name)
	if Entry and Entry:IsA("HumanoidDescription") then
		return Entry
	end
	local Model = EvadeRig.FindModel(Player)
	local Humanoid = Model and Model:FindFirstChildOfClass("Humanoid")
	return if Humanoid then Humanoid:FindFirstChildOfClass("HumanoidDescription") else nil
end

function EvadeRig.GetRigType(Player: Player): Enum.HumanoidRigType?
	local Model = EvadeRig.FindModel(Player)
	local Humanoid = Model and Model:FindFirstChildOfClass("Humanoid")
	if Humanoid then
		return Humanoid.RigType
	end
	local Attribute = Player:GetAttribute("RigType")
	if Attribute == "R15" then
		return Enum.HumanoidRigType.R15
	elseif Attribute == "R6" then
		return Enum.HumanoidRigType.R6
	end
	return nil
end

function EvadeRig.PlayerFromInstance(Object: Instance): Player?
	local Folder = EvadeRig.GetFolder()
	if not Folder then
		return nil
	end
	local Current: Instance? = Object
	while Current and Current.Parent ~= Folder do
		Current = Current.Parent
	end
	if not Current then
		return nil
	end
	local Found = Players:FindFirstChild(Current.Name)
	return if Found and Found:IsA("Player") then Found else nil
end

local Ledger = {}
Ledger.__index = Ledger

function Ledger.new()
	return setmetatable({
		Created = {} :: { Instance },
		Stashed = {} :: { { Object: Instance, Parent: Instance } },
		Original = {} :: { { Object: Instance, Property: string, Value: any } },
		Sticky = {} :: { { Object: Instance, Property: string, Value: any } },
		Mirrors = {} :: { { Part: BasePart, Source: BasePart } },
		Seen = {} :: { [Instance]: { [string]: boolean } },
	}, Ledger)
end

function Ledger:Set(Object: Instance, Property: string, Value: any, Sticky: boolean?): boolean
	local Target: any = Object
	local Read, Current = pcall(function()
		return Target[Property]
	end)
	if not Read then
		return false
	end
	local Known = self.Seen[Object]
	if not Known then
		Known = {}
		self.Seen[Object] = Known
	end
	if not Known[Property] then
		Known[Property] = true
		table.insert(self.Original, { Object = Object, Property = Property, Value = Current })
	end
	local Written = pcall(function()
		Target[Property] = Value
	end)
	if Written and Sticky then
		table.insert(self.Sticky, { Object = Object, Property = Property, Value = Value })
	end
	return Written
end

function Ledger:Create(Object: Instance)
	pcall(Object.SetAttribute, Object, ManagedAttribute, true)
	table.insert(self.Created, Object)
end

function Ledger:Stash(Object: Instance)
	local Parent = Object.Parent
	if not Parent then
		return
	end
	table.insert(self.Stashed, { Object = Object, Parent = Parent })
	pcall(function()
		Object.Parent = nil
	end)
end

function Ledger:Mirror(Part: BasePart, Source: BasePart)
	table.insert(self.Mirrors, { Part = Part, Source = Source })
end

function Ledger:Restore()
	for Index = #self.Created, 1, -1 do
		Util.Destroy(self.Created[Index])
	end
	for Index = #self.Original, 1, -1 do
		local Entry = self.Original[Index]
		local Target: any = Entry.Object
		pcall(function()
			Target[Entry.Property] = Entry.Value
		end)
	end
	for Index = #self.Stashed, 1, -1 do
		local Entry = self.Stashed[Index]
		pcall(function()
			if Entry.Parent:IsDescendantOf(game) then
				Entry.Object.Parent = Entry.Parent
			else
				Entry.Object:Destroy()
			end
		end)
	end
	table.clear(self.Created)
	table.clear(self.Original)
	table.clear(self.Stashed)
	table.clear(self.Sticky)
	table.clear(self.Mirrors)
	table.clear(self.Seen)
end

local InPlace = {}
InPlace.__index = InPlace

type Fingerprint = {
	Parts: { [Instance]: Instance? },
	Joints: { [Instance]: { Instance? } },
	Attachments: { [Instance]: Instance? },
	Humanoid: Humanoid?,
	HumanoidParent: Instance?,
}

function InPlace.Capture(Model: Model): Fingerprint
	local State: Fingerprint = {
		Parts = {},
		Joints = {},
		Attachments = {},
		Humanoid = Model:FindFirstChildOfClass("Humanoid"),
		HumanoidParent = nil,
	}
	if State.Humanoid then
		State.HumanoidParent = State.Humanoid.Parent
	end
	for _, Descendant in Model:GetDescendants() do
		if IsGearDescendant(Descendant, Model) then
			continue
		end
		if Descendant:IsA("BasePart") then
			State.Parts[Descendant] = Descendant.Parent
		elseif Descendant:IsA("JointInstance") then
			State.Joints[Descendant] = { Descendant.Part0, Descendant.Part1 }
		elseif Descendant:IsA("AnimationConstraint") then
			State.Joints[Descendant] = { Descendant.Attachment0, Descendant.Attachment1 }
		elseif Descendant:IsA("Attachment") then
			State.Attachments[Descendant] = Descendant.Parent
		end
	end
	return State
end

function InPlace.Compare(Before: Fingerprint, Model: Model): string?
	if Before.Humanoid and (Before.Humanoid.Parent ~= Before.HumanoidParent or not Before.Humanoid:IsDescendantOf(Model)) then
		return "Humanoid was changed"
	end
	for Object, Parent in Before.Parts do
		if Object.Parent ~= Parent then
			return `part {Object.Name} was moved or removed`
		end
	end
	for Object, Parent in Before.Attachments do
		if Object.Parent ~= Parent then
			return `attachment {Object.Name} was moved or removed`
		end
	end
	for Joint, Pair in Before.Joints do
		local First, Second
		if Joint:IsA("AnimationConstraint") then
			First, Second = Joint.Attachment0, Joint.Attachment1
		else
			First, Second = (Joint :: any).Part0, (Joint :: any).Part1
		end
		if Joint.Parent == nil or First ~= Pair[1] or Second ~= Pair[2] then
			return `joint {Joint.Name} was changed`
		end
	end
	return nil
end

function InPlace.new(Player: Player)
	return setmetatable({
		Player = Player,
		Active = false,
		Busy = false,
		Profile = nil :: RigProfile?,
		Ledger = nil :: any,
		Token = 0,
		Elapsed = 0,
		MissingSince = nil :: number?,
		Maid = Maid.new(),
		Lost = Signal.new(),
		Drifted = Signal.new(),
	}, InPlace)
end

function InPlace:BuildDonor(Data: AvatarData, Kind: string): (Model?, string?)
	local RigType = if Kind == "R6" then Enum.HumanoidRigType.R6 else Enum.HumanoidRigType.R15
	local Description = Serializer.Reconstruct(Data.Properties)
	local Created, Result = pcall(function()
		return Players:CreateHumanoidModelFromDescriptionAsync(Description, RigType)
	end)
	Util.Destroy(Description)
	if not Created or typeof(Result) ~= "Instance" or not Result:IsA("Model") then
		return nil, tostring(Result)
	end
	return Result, nil
end

local function BuildAttachmentIndex(Parts: { [string]: BasePart }): { [string]: Attachment }
	local Index: { [string]: Attachment } = {}
	for _, Part in Parts do
		for _, Child in Part:GetChildren() do
			if Child:IsA("Attachment") and not Index[Child.Name] then
				Index[Child.Name] = Child
			end
		end
	end
	return Index
end

local function FindPartForDonor(Profile: RigProfile, DonorPart: Instance): BasePart?
	local Direct = Profile.Parts[DonorPart.Name]
	if Direct then
		return Direct
	end
	local Group = PartGroups[DonorPart.Name]
	if Group then
		for Name, Part in Profile.Parts do
			if PartGroups[Name] == Group then
				return Part
			end
		end
	end
	return nil
end

local function IsDetachedFrom(Object: Instance?, Root: Instance): boolean
	return Object ~= nil and not Object:IsDescendantOf(Root)
end

function InPlace.ApplyColors(Profile: RigProfile, Donor: Model, Ledger: any)
	local Colors = Donor:FindFirstChildOfClass("BodyColors")
	if not Colors then
		return
	end
	local Values: { [string]: Color3 } = {}
	for Group, Property in GroupColorProperties do
		local Success, Value = pcall(function()
			return (Colors :: any)[Property]
		end)
		if Success and typeof(Value) == "Color3" then
			Values[Group] = Value
		end
	end
	for Name, Part in Profile.Parts do
		local Group = PartGroups[Name]
		local Color = Group and Values[Group]
		if Color then
			Ledger:Set(Part, "Color", Color)
		end
	end
	local Existing = Profile.Model:FindFirstChildOfClass("BodyColors")
	if Existing then
		for Group, Property in GroupColorProperties do
			if Values[Group] then
				Ledger:Set(Existing, Property, Values[Group], true)
			end
		end
	end
end

function InPlace.ApplyClothing(Profile: RigProfile, Donor: Model, Ledger: any)
	local Model = Profile.Model
	for ClassName, Properties in ClothingProperties do
		local Mine: Instance? = nil
		for _, Child in Model:GetChildren() do
			if Child.ClassName == ClassName then
				if Mine then
					Ledger:Stash(Child)
				else
					Mine = Child
				end
			end
		end
		local Theirs = Donor:FindFirstChildOfClass(ClassName)
		if Mine and Theirs then
			for _, Property in Properties do
				local Success, Value = pcall(function()
					return (Theirs :: any)[Property]
				end)
				if Success then
					Ledger:Set(Mine, Property, Value, true)
				end
			end
		elseif Theirs then
			local Clone = Theirs:Clone()
			Ledger:Create(Clone)
			Clone.Parent = Model
		elseif Mine then
			Ledger:Stash(Mine)
		end
	end

	for _, Child in Model:GetChildren() do
		if Child:IsA("CharacterMesh") then
			Ledger:Stash(Child)
		end
	end
	for _, Child in Donor:GetChildren() do
		if Child:IsA("CharacterMesh") then
			local Clone = Child:Clone()
			Ledger:Create(Clone)
			Clone.Parent = Model
		end
	end
end

function InPlace.ApplyFace(Profile: RigProfile, Donor: Model, Ledger: any)
	local TargetHead = Profile.Parts.Head
	local DonorHead = Donor:FindFirstChild("Head")
	if not TargetHead or not DonorHead then
		return
	end

	local TargetMesh = TargetHead:FindFirstChildOfClass("SpecialMesh")
	local DonorMesh = DonorHead:FindFirstChildOfClass("SpecialMesh")
	if TargetMesh and DonorMesh then
		for _, Property in HeadMeshProperties do
			local Success, Value = pcall(function()
				return (DonorMesh :: any)[Property]
			end)
			if Success then
				Ledger:Set(TargetMesh, Property, Value, true)
			end
		end
	elseif TargetHead:IsA("MeshPart") and DonorHead:IsA("MeshPart") then
		for _, Property in HeadMeshPartProperties do
			local Success, Value = pcall(function()
				return (DonorHead :: any)[Property]
			end)
			if Success then
				Ledger:Set(TargetHead, Property, Value, true)
			end
		end
	end

	local DonorFace = DonorHead:FindFirstChild("face")
	local TargetFace = TargetHead:FindFirstChild("face")
	if DonorFace and DonorFace:IsA("Decal") then
		if TargetFace and TargetFace:IsA("Decal") then
			Ledger:Set(TargetFace, "Texture", DonorFace.Texture, true)
		else
			local Clone = DonorFace:Clone()
			Ledger:Create(Clone)
			Clone.Parent = TargetHead
		end
	elseif TargetFace and TargetFace:IsA("Decal") then
		Ledger:Stash(TargetFace)
	end
end

local ScaleSamples = table.freeze({ "Head", "UpperTorso", "Torso", "LowerTorso", "HumanoidRootPart" })

local function ScaleTranslation(Value: CFrame, Factor: number): CFrame
	return Value.Rotation + Value.Position * Factor
end

function InPlace.GetRigScale(Profile: RigProfile, Donor: Model): number
	local DonorParts = RigResolver.GetParts(Donor)
	local Ratios: { number } = {}
	for _, Name in ScaleSamples do
		local Target, Source = Profile.Parts[Name], DonorParts[Name]
		if Target and Source and Target.Size.Y > 0.05 and Source.Size.Y > 0.05 then
			table.insert(Ratios, Target.Size.Y / Source.Size.Y)
		end
	end
	local Count = #Ratios
	if Count == 0 then
		return 1
	end
	table.sort(Ratios)
	local Median = (Ratios[(Count + 1) // 2] + Ratios[Count // 2 + 1]) / 2
	if math.abs(Median - 1) < 0.02 then
		return 1
	end
	return math.clamp(Median, 0.1, 10)
end

function InPlace.ScaleAccessory(Accessory: Instance, Factor: number)
	for _, Descendant in Accessory:GetDescendants() do
		if Descendant:IsA("BasePart") then
			Descendant.Size *= Factor
		elseif Descendant:IsA("SpecialMesh") then
			Descendant.Offset *= Factor
			if Descendant.MeshType == Enum.MeshType.FileMesh then
				Descendant.Scale *= Factor
			end
		elseif Descendant:IsA("Attachment") then
			Descendant.Position *= Factor
		elseif Descendant:IsA("JointInstance") then
			Descendant.C0 = ScaleTranslation(Descendant.C0, Factor)
			Descendant.C1 = ScaleTranslation(Descendant.C1, Factor)
		end
	end
end

function InPlace.AttachAccessory(
	Profile: RigProfile,
	Ledger: any,
	Source: Instance,
	Index: { [string]: Attachment },
	DonorIndex: { [string]: Attachment },
	Factor: number?
): boolean
	local Scale = Factor or 1
	local Accessory = Source:Clone()
	local Handle = Accessory:FindFirstChild("Handle")
	if not Handle or not Handle:IsA("BasePart") then
		Util.Destroy(Accessory)
		return false
	end

	for _, Descendant in Accessory:GetDescendants() do
		if Descendant:IsA("Weld") or Descendant:IsA("WeldConstraint") or Descendant:IsA("Motor6D") then
			local Joint: any = Descendant
			if
				Descendant.Name == "AccessoryWeld"
				or IsDetachedFrom(Joint.Part0, Accessory)
				or IsDetachedFrom(Joint.Part1, Accessory)
			then
				Util.Destroy(Descendant)
			end
		elseif Descendant:IsA("RigidConstraint") then
			if IsDetachedFrom(Descendant.Attachment0, Accessory) or IsDetachedFrom(Descendant.Attachment1, Accessory) then
				Util.Destroy(Descendant)
			end
		end
	end

	if Scale ~= 1 then
		InPlace.ScaleAccessory(Accessory, Scale)
	end

	local HandleAttachment: Attachment? = nil
	local BodyAttachment: Attachment? = nil
	for _, Child in Handle:GetChildren() do
		if not Child:IsA("Attachment") then
			continue
		end
		local Found = Index[Child.Name]
		if not Found then
			local DonorAttachment = DonorIndex[Child.Name]
			local DonorPart = DonorAttachment and DonorAttachment.Parent
			local Part = DonorPart and FindPartForDonor(Profile, DonorPart)
			if DonorAttachment and Part then
				Found = DonorAttachment:Clone()
				Ledger:Create(Found)
				Found.Parent = Part
				Index[Child.Name] = Found
			end
		end
		if Found then
			HandleAttachment = Child
			BodyAttachment = Found
			break
		end
	end

	local Weld = Instance.new("Weld")
	Weld.Name = "AccessoryWeld"
	local Anchor: BasePart? = nil
	if HandleAttachment and BodyAttachment and BodyAttachment.Parent and BodyAttachment.Parent:IsA("BasePart") then
		Anchor = BodyAttachment.Parent
		Weld.Part0 = Anchor
		Weld.Part1 = Handle
		Weld.C0 = BodyAttachment.CFrame
		Weld.C1 = HandleAttachment.CFrame
	else
		local Head = Profile.Parts.Head
		if not Head then
			Util.Destroy(Weld)
			Util.Destroy(Accessory)
			return false
		end
		Anchor = Head
		Weld.Part0 = Head
		Weld.Part1 = Handle
		Weld.C0 = CFrame.new(0, Head.Size.Y / 2, 0)
		Weld.C1 = ScaleTranslation((Accessory :: any).AttachmentPoint, Scale)
	end
	Weld.Parent = Handle

	for _, Descendant in Accessory:GetDescendants() do
		if Descendant:IsA("BasePart") then
			Descendant.Anchored = false
			Descendant.CanCollide = false
			Descendant.CanTouch = false
			Descendant.CanQuery = false
			Descendant.Massless = true
			pcall(function()
				Descendant.CollisionGroup = (Anchor :: BasePart).CollisionGroup
			end)
			Ledger:Mirror(Descendant, Anchor :: BasePart)
		end
	end

	Ledger:Create(Accessory)
	Accessory.Parent = Profile.Model
	return true
end

function InPlace.ApplyAccessories(Profile: RigProfile, Donor: Model, Ledger: any): number
	for _, Child in Profile.Model:GetChildren() do
		if Child:IsA("Accoutrement") and not Child:GetAttribute(ManagedAttribute) then
			Ledger:Stash(Child)
		end
	end

	local Index = BuildAttachmentIndex(Profile.Parts)
	local DonorIndex = BuildAttachmentIndex(RigResolver.GetParts(Donor))
	local Factor = InPlace.GetRigScale(Profile, Donor)
	local Attached = 0
	for _, Child in Donor:GetChildren() do
		if Child:IsA("Accoutrement") and InPlace.AttachAccessory(Profile, Ledger, Child, Index, DonorIndex, Factor) then
			Attached += 1
		end
	end
	return Attached
end

function InPlace:Commit(Data: AvatarData, Profile: RigProfile, Donor: Model): (boolean, string)
	local Changes = Ledger.new()
	local Before = InPlace.Capture(Profile.Model)
	local Guard = if Profile.Evade then EvadeRig.Capture(Profile.Model) else nil
	local Attached = 0

	local Success, Err = xpcall(function()
		Serializer.ApplyBodyColors(Donor, Data.Properties)
		Serializer.ApplyHeadShape(Donor, Data.Properties)
		Serializer.ApplyRigidRefinements(Donor, Data.Properties)
		InPlace.ApplyColors(Profile, Donor, Changes)
		InPlace.ApplyClothing(Profile, Donor, Changes)
		InPlace.ApplyFace(Profile, Donor, Changes)
		Attached = InPlace.ApplyAccessories(Profile, Donor, Changes)
	end, debug.traceback)

	local Problem = if Success then InPlace.Compare(Before, Profile.Model) else nil
	if Success and not Problem and Guard then
		Problem = EvadeRig.Compare(Guard, Profile.Model)
	end
	if not Success or Problem then
		Changes:Restore()
		if not Success then
			return false, tostring(Err)
		end
		return false, `Rig integrity check failed and every change was rolled back: {Problem}.`
	end

	self.Ledger = Changes
	self.Profile = Profile
	if Profile.Evade then
		return true,
			`Avatar applied to your Evade rig {Profile.Model:GetFullName()} ({Profile.Kind}, {EvadeRig.State(Profile)}), {Attached} accessories. Humanoid and joints untouched.`
	end
	return true, `Avatar applied to {Profile.Model:GetFullName()} ({Profile.Kind}, {Profile.Source}), {Attached} accessories.`
end

function InPlace:Undo()
	local Ledger = self.Ledger
	self.Ledger = nil
	if Ledger then
		Ledger:Restore()
	end
end

function InPlace:Run(
	Data: AvatarData,
	Options: { [string]: any },
	Cancelled: () -> boolean,
	Token: number
): (boolean, string)
	local LastError = "Unknown error."
	for Attempt = 1, 3 do
		if Cancelled() or Token ~= self.Token then
			return false, "superseded"
		end
		local Profile, Reason = RigResolver.WaitFor(
			self.Player,
			Options.RigPath,
			if Attempt == 1 then 8 else 3,
			function()
				return Cancelled() or Token ~= self.Token
			end
		)
		if not Profile then
			return false, Reason
		end

		local Donor, DonorError = self:BuildDonor(Data, Profile.Kind)
		if not Donor then
			LastError = tostring(DonorError)
			task.wait(0.1 * Attempt)
			continue
		end
		if Cancelled() or Token ~= self.Token then
			Util.Destroy(Donor)
			return false, "superseded"
		end

		local Fresh = RigResolver.Resolve(self.Player, Options.RigPath)
		if not Fresh or Fresh.Model ~= Profile.Model or Fresh.Kind ~= Profile.Kind then
			Util.Destroy(Donor)
			LastError = "Your rig changed while the avatar was being prepared."
			continue
		end

		self:Undo()
		if self.OnPristine then
			pcall(self.OnPristine, Fresh, Donor)
		end
		local Success, Message = self:Commit(Data, Fresh, Donor)
		Util.Destroy(Donor)
		if Success then
			return true, Message
		end
		LastError = Message
	end
	return false, LastError
end

function InPlace:Apply(Data: AvatarData, Options: { [string]: any }, Cancelled: () -> boolean): (boolean, string)
	if self.Busy then
		return false, "Another avatar change is still running."
	end
	self.Busy = true
	self.Token += 1
	local Token = self.Token
	self.Maid:Clean()

	local Success, Ok, Message = xpcall(function()
		return self:Run(Data, Options, Cancelled, Token)
	end, debug.traceback)
	self.Busy = false

	if not Success then
		self:Undo()
		self.Active = false
		return false, tostring(Ok)
	end
	if Ok then
		self.Active = true
	elseif not self.Ledger then
		self.Active = false
	end
	return Ok, Message
end

function InPlace:FindDrift(): string?
	local Profile, Ledger = self.Profile, self.Ledger
	if not Profile or not Ledger then
		return nil
	end
	local Model = Profile.Model
	for _, Object in Ledger.Created do
		if not Object:IsDescendantOf(Model) then
			return "An applied item was removed by the game."
		end
	end
	for _, Entry in Ledger.Sticky do
		local Target: any = Entry.Object
		local Success, Current = pcall(function()
			return Target[Entry.Property]
		end)
		if not Success or Entry.Object.Parent == nil or Current ~= Entry.Value then
			return `The game changed {Entry.Object.Name}.{Entry.Property}.`
		end
	end
	return nil
end

function InPlace:IsIntact(): boolean
	local Profile = self.Profile
	if not self.Active or self.Busy or not Profile or not self.Ledger then
		return false
	end
	local Model = Profile.Model
	if Model.Parent == nil or not Model:IsDescendantOf(game) then
		return false
	end
	return self:FindDrift() == nil
end

function InPlace:Check()
	if not self.Active or self.Busy or not self.Profile then
		return
	end
	local Model = self.Profile.Model
	if Model.Parent == nil or not Model:IsDescendantOf(game) then
		local Now = os.clock()
		self.MissingSince = self.MissingSince or Now
		if Now - self.MissingSince >= 0.3 then
			self.MissingSince = nil
			self.Lost:Fire("Your rig was replaced by the game.")
		end
		return
	end
	self.MissingSince = nil
	local Drift = self:FindDrift()
	if Drift then
		self.Drifted:Fire(Drift)
	end
end

function InPlace:SyncVisibility()
	local Ledger = self.Ledger
	if not Ledger then
		return
	end
	local Profile = self.Profile
	local HideAll = Profile ~= nil and Profile.Evade == true and EvadeRig.HidesAccessories()
	for _, Entry in Ledger.Mirrors do
		local Part, Source = Entry.Part, Entry.Source
		if Part.Parent and Source.Parent then
			local Modifier = if HideAll then 1 else Source.LocalTransparencyModifier
			if Part.LocalTransparencyModifier ~= Modifier then
				Part.LocalTransparencyModifier = Modifier
			end
		end
	end
end

function InPlace:Watch()
	self.Elapsed = 0
	self.MissingSince = nil
	self.Maid:Set(
		"Poll",
		RunService.Heartbeat:Connect(function(Delta)
			self.Elapsed += Delta
			local Profile = self.Profile
			local Interval = if Profile and Profile.Evade then 0.2 else 0.4
			if self.Elapsed >= Interval then
				self.Elapsed = 0
				self:Check()
			end
		end)
	)
	self.Maid:Set(
		"Visibility",
		RunService.RenderStepped:Connect(function()
			self:SyncVisibility()
		end)
	)
end

function InPlace:StopWatching()
	self.Maid:Clean()
end

function InPlace:Restore()
	self.Token += 1
	self.Maid:Clean()
	self:Undo()
	self.Active = false
	self.Profile = nil
	self.MissingSince = nil
end

function InPlace:Destroy()
	self:Restore()
	self.Lost:DisconnectAll()
	self.Drifted:DisconnectAll()
	self.Maid:Destroy()
end

type LookItem = { Mesh: number?, Asset: number?, Name: string }
type Look = { Items: { LookItem }, Tokens: { [string]: number }, Colors: { [string]: Color3 } }

local Similarity = {}

local TokenSources = table.freeze({
	{ Class = "Shirt", Property = "ShirtTemplate", Key = "Shirt" },
	{ Class = "Pants", Property = "PantsTemplate", Key = "Pants" },
	{ Class = "ShirtGraphic", Property = "Graphic", Key = "Graphic" },
})

local SimilarWeights = table.freeze({ Items = 0.55, Tokens = 0.30, Colors = 0.15 })
local SimilarLimit = 80
local SimilarSlice = 0.004
local SimilarRetryDelays = table.freeze({ 0.05, 0.25, 0.75, 2, 4 })
local SimilarMaintainInterval = 0.75
local RigKinds = table.freeze({ "R15", "R6" })

function Similarity.Describe(Model: Model, Parts: { [string]: BasePart }): Look
	local Look: Look = { Items = {}, Tokens = {}, Colors = {} }

	for _, Object in Model:GetDescendants() do
		if
			Object:IsA("Accoutrement")
			and not Object:GetAttribute(ManagedAttribute)
			and not IsGearDescendant(Object, Model)
		then
			local Handle = Object:FindFirstChild("Handle")
			local Mesh: number? = nil
			local Asset = Util.ParseAssetId(Object:GetAttribute("AssetId"))
			if Handle then
				local Special = Handle:FindFirstChildOfClass("SpecialMesh")
				if Special then
					Mesh = Util.ParseAssetId(Special.MeshId)
				end
				if not Mesh and Handle:IsA("MeshPart") then
					Mesh = Util.ParseAssetId(Handle.MeshId)
				end
				Asset = Asset or Util.ParseAssetId(Handle:GetAttribute("AssetId"))
			end
			table.insert(Look.Items, { Mesh = Mesh, Asset = Asset, Name = string.lower(Object.Name) })
		end
	end

	for _, Source in TokenSources do
		local Object = Model:FindFirstChildOfClass(Source.Class)
		if Object then
			local Success, Value = pcall(function()
				return (Object :: any)[Source.Property]
			end)
			local Id = if Success then Util.ParseAssetId(Value) else nil
			if Id then
				Look.Tokens[Source.Key] = Id
			end
		end
	end
	local Face = Parts.Head and Parts.Head:FindFirstChild("face")
	if Face and Face:IsA("Decal") then
		local Id = Util.ParseAssetId(Face.Texture)
		if Id then
			Look.Tokens.Face = Id
		end
	end

	for Name, Part in Parts do
		local Group = PartGroups[Name]
		if Group and not Look.Colors[Group] then
			Look.Colors[Group] = Part.Color
		end
	end
	return Look
end

function Similarity.IsDistinct(Look: Look?): boolean
	if not Look then
		return false
	end
	return #Look.Items > 0 or Look.Tokens.Shirt ~= nil or Look.Tokens.Pants ~= nil or Look.Tokens.Graphic ~= nil
end

local function ItemsMatch(A: LookItem, B: LookItem): boolean
	if A.Mesh and B.Mesh then
		return A.Mesh == B.Mesh
	end
	if A.Asset and B.Asset and A.Asset == B.Asset then
		return true
	end
	return A.Name == B.Name
end

local function ColorsClose(A: Color3, B: Color3): boolean
	local R, G, Bl = A.R - B.R, A.G - B.G, A.B - B.B
	return R * R + G * G + Bl * Bl < 0.01
end

function Similarity.Score(Reference: Look, Candidate: Look): number
	local Weighted, Total = 0, 0

	local RefCount = #Reference.Items
	if RefCount > 0 then
		local Used: { [number]: boolean } = {}
		local Matched = 0
		for _, A in Reference.Items do
			for Index, B in Candidate.Items do
				if not Used[Index] and ItemsMatch(A, B) then
					Used[Index] = true
					Matched += 1
					break
				end
			end
		end
		Weighted += SimilarWeights.Items * Matched / math.max(RefCount, #Candidate.Items)
		Total += SimilarWeights.Items
	end

	local TokenCount, TokenMatched = 0, 0
	for Key, Id in Reference.Tokens do
		TokenCount += 1
		if Candidate.Tokens[Key] == Id then
			TokenMatched += 1
		end
	end
	if TokenCount > 0 then
		Weighted += SimilarWeights.Tokens * TokenMatched / TokenCount
		Total += SimilarWeights.Tokens
	end

	local ColorCount, ColorMatched = 0, 0
	for Group, Color in Reference.Colors do
		local Other = Candidate.Colors[Group]
		if Other then
			ColorCount += 1
			if ColorsClose(Color, Other) then
				ColorMatched += 1
			end
		end
	end
	if ColorCount > 0 then
		Weighted += SimilarWeights.Colors * ColorMatched / ColorCount
		Total += SimilarWeights.Colors
	end

	return if Total > 0 then Weighted / Total else 0
end

local Similar = {}
Similar.__index = Similar

function Similar.new(Player: Player)
	return setmetatable({
		Player = Player,
		Enabled = true,
		Threshold = 0.85,
		Reference = nil :: Look?,
		Primary = nil :: Model?,
		Data = nil :: AvatarData?,
		Targets = {} :: { [Model]: any },
		Donors = {} :: { [string]: any },
		Pending = {} :: { [Instance]: boolean },
		Busy = {} :: { [Instance]: boolean },
		Ignored = {} :: { [Instance]: boolean },
		Running = false,
		Token = 0,
		Maid = Maid.new(),
		Changed = Signal.new(),
	}, Similar)
end

function Similar:SetReference(Model: Model)
	self.Reference = Similarity.Describe(Model, RigResolver.GetParts(Model))
end

function Similar:Ignore(Object: Instance?)
	if Object then
		self.Ignored[Object] = true
	end
end

function Similar:IsIgnored(Model: Instance): boolean
	local Gui = Model:FindFirstAncestorWhichIsA("LayerCollector")
	return Gui ~= nil and (self.Ignored[Gui] == true or Gui.Name == Constants.HostName)
end

function Similar:GetRoots(): { Instance }
	local Roots: { Instance } = { Workspace }
	local PlayerGui = self.Player:FindFirstChildOfClass("PlayerGui")
	if PlayerGui then
		table.insert(Roots, PlayerGui)
	end
	return Roots
end

function Similar.AsCandidate(Object: Instance, Interface: boolean): Model?
	if Object:IsA("Humanoid") then
		local Parent = Object.Parent
		return if Parent and Parent:IsA("Model") then Parent else nil
	end
	if
		Interface
		and Object:IsA("Model")
		and Object:FindFirstChild("Head")
		and (Object:FindFirstChild("UpperTorso") or Object:FindFirstChild("Torso"))
		and Object:FindFirstAncestorWhichIsA("ViewportFrame")
	then
		return Object
	end
	return nil
end

function Similar:Count(): number
	local Count = 0
	for _ in self.Targets do
		Count += 1
	end
	return Count
end

function Similar:Summary(): string
	if not self.Enabled then
		return "Off"
	end
	if self.Reference and not Similarity.IsDistinct(self.Reference) then
		return "Original avatar has nothing to compare"
	end
	local Names = {}
	for Model in self.Targets do
		table.insert(Names, Model:GetFullName())
	end
	table.sort(Names)
	if #Names == 0 then
		return if self.Running then "Scanning..." else "None"
	end
	local Shown = {}
	for Index = 1, math.min(#Names, 3) do
		Shown[Index] = Names[Index]
	end
	local Extra = if #Names > 3 then ` (+{#Names - 3} more)` else ""
	return `{#Names} rig(s): {table.concat(Shown, ", ")}{Extra}`
end

function Similar:_ClearDonors()
	for Kind, Donor in self.Donors do
		if typeof(Donor) == "Instance" then
			Util.Destroy(Donor)
		end
		self.Donors[Kind] = nil
	end
end

function Similar:_GetDonor(Kind: string, Token: number): Model?
	local Current = self.Donors[Kind]
	if Current == "building" then
		while self.Donors[Kind] == "building" and Token == self.Token do
			task.wait()
		end
		Current = self.Donors[Kind]
	end
	if typeof(Current) == "Instance" then
		return Current
	end
	local Data = self.Data
	if not Data or Token ~= self.Token then
		return nil
	end

	self.Donors[Kind] = "building"
	local Donor = InPlace.BuildDonor(self, Data, Kind)
	if Token ~= self.Token or not Donor then
		self.Donors[Kind] = nil
		if Donor then
			Util.Destroy(Donor)
		end
		return nil
	end
	self.Donors[Kind] = Donor
	return Donor
end

function Similar:_Seed(Seed: Model)
	local Kind = if RigResolver.GetParts(Seed).UpperTorso then "R15" else "R6"
	if self.Donors[Kind] == nil then
		self.Donors[Kind] = Seed:Clone()
	end
end

function Similar:_Warm(Token: number)
	for _, Kind in RigKinds do
		if self.Donors[Kind] == nil then
			task.spawn(self._GetDonor, self, Kind, Token)
		end
	end
end

function Similar:_Attach(Model: Model, Token: number): boolean
	local Data = self.Data
	if not Data or Token ~= self.Token then
		return false
	end
	local Profile = RigResolver.Evaluate(Model, self.Player, "Similar", 0)
	if not Profile then
		return false
	end
	local Donor = self:_GetDonor(Profile.Kind, Token)
	if not Donor or Token ~= self.Token then
		return false
	end

	local Runner = self.Targets[Model] or InPlace.new(self.Player)
	Runner:Undo()
	local Success = Runner:Commit(Data, Profile, Donor)
	if Success then
		Runner.Active = true
		self.Targets[Model] = Runner
	else
		self.Targets[Model] = nil
		pcall(Runner.Destroy, Runner)
	end
	return Success
end

function Similar:_Drop(Model: Model)
	local Runner = self.Targets[Model]
	self.Targets[Model] = nil
	if Runner then
		pcall(Runner.Destroy, Runner)
	end
	self.Changed:Fire()
end

function Similar:_Consider(Model: Model, Token: number): boolean
	local Reference = self.Reference
	if not Reference or self.Targets[Model] or self.Busy[Model] or Token ~= self.Token then
		return false
	end
	if Model == self.Primary or Model == self.Player.Character or Model.Name == Constants.ModelName then
		return false
	end
	if Players:GetPlayerFromCharacter(Model) or self:IsIgnored(Model) then
		return false
	end
	local Camera = Workspace.CurrentCamera
	if Camera and Model:IsDescendantOf(Camera) then
		return false
	end
	if self:Count() >= SimilarLimit then
		return false
	end
	self.Busy[Model] = true
	local Success, Result = pcall(self._Evaluate, self, Model, Reference, Token)
	self.Busy[Model] = nil
	return Success and Result == true
end

function Similar:_Evaluate(Model: Model, Reference: Look, Token: number): boolean
	local Parts = RigResolver.GetParts(Model)
	if not Parts.Head or not (Parts.Torso or Parts.UpperTorso) or not RigResolver.IsVisible(Parts) then
		return false
	end
	if Similarity.Score(Reference, Similarity.Describe(Model, Parts)) < self.Threshold then
		return false
	end
	if self:_Attach(Model, Token) then
		self.Changed:Fire()
		return true
	end
	return false
end

function Similar:_Queue(Object: Instance, Token: number)
	if self.Pending[Object] then
		return
	end
	self.Pending[Object] = true
	task.spawn(function()
		for _, Delay in SimilarRetryDelays do
			task.wait(Delay)
			if Token ~= self.Token or not Object:IsDescendantOf(game) then
				break
			end
			local Model = Similar.AsCandidate(Object, Object:FindFirstAncestorWhichIsA("PlayerGui") ~= nil)
			if Model and (self.Targets[Model] or self:_Consider(Model, Token)) then
				break
			end
		end
		self.Pending[Object] = nil
	end)
end

function Similar:_Scan(Token: number)
	local Visited = 0
	local Mark = os.clock()
	for _, Root in self:GetRoots() do
		local Interface = Root ~= Workspace
		for _, Object in Root:GetDescendants() do
			Visited += 1
			if Visited % 256 == 0 and os.clock() - Mark > SimilarSlice then
				task.wait()
				Mark = os.clock()
			end
			if Token ~= self.Token then
				return
			end
			local Model = Similar.AsCandidate(Object, Interface)
			if Model then
				task.spawn(self._Consider, self, Model, Token)
			end
		end
	end
	self.Changed:Fire()
end

function Similar:_Maintain(Token: number)
	while Token == self.Token do
		task.wait(SimilarMaintainInterval)
		for Model, Runner in table.clone(self.Targets) do
			if Token ~= self.Token then
				return
			end
			if not Model:IsDescendantOf(game) then
				self:_Drop(Model)
			elseif Runner:FindDrift() then
				Runner.Fixes = (Runner.Fixes or 0) + 1
				if Runner.Fixes > 5 or not self:_Attach(Model, Token) then
					self:_Drop(Model)
				end
			end
		end
	end
end

function Similar:Start(Data: AvatarData, Primary: Model, Seed: Model?)
	if not self.Enabled or not Similarity.IsDistinct(self.Reference) then
		self:Stop()
		return
	end
	local Switched = self.Data ~= Data
	self.Primary = Primary
	if self.Running and not Switched then
		return
	end

	self.Data = Data
	self.Token += 1
	local Token = self.Token
	self.Running = true
	if Switched then
		self:_ClearDonors()
	end
	if Seed then
		self:_Seed(Seed)
	end
	self:_Warm(Token)

	self.Maid:Set(
		"Added",
		Workspace.DescendantAdded:Connect(function(Object)
			if Object:IsA("Humanoid") then
				self:_Queue(Object, Token)
			end
		end)
	)
	local PlayerGui = self.Player:FindFirstChildOfClass("PlayerGui")
	if PlayerGui then
		self.Maid:Set(
			"GuiAdded",
			PlayerGui.DescendantAdded:Connect(function(Object)
				if
					Object:IsA("Humanoid")
					or (Object:IsA("Model") and Object:FindFirstAncestorWhichIsA("ViewportFrame") ~= nil)
				then
					self:_Queue(Object, Token)
				end
			end)
		)
	end

	task.spawn(function()
		if Switched then
			for Model in table.clone(self.Targets) do
				if Token ~= self.Token then
					return
				end
				if not self:_Attach(Model, Token) then
					self:_Drop(Model)
				end
			end
		end
		self:_Scan(Token)
		self:_Maintain(Token)
	end)
end

function Similar:Stop()
	self.Token += 1
	self.Running = false
	self.Maid:Clean()
	for _, Runner in self.Targets do
		pcall(Runner.Destroy, Runner)
	end
	table.clear(self.Targets)
	table.clear(self.Pending)
	table.clear(self.Busy)
	self:_ClearDonors()
	self.Data, self.Primary = nil, nil
	self.Changed:Fire()
end

function Similar:Destroy()
	self:Stop()
	self.Maid:Destroy()
	self.Changed:DisconnectAll()
end

local TryOn = {}
TryOn.__index = TryOn

local function SmoothStep(Alpha: number): number
	return Alpha * Alpha * (3 - 2 * Alpha)
end

local function NewPlacement(Token: number)
	return {
		RootPart = nil :: BasePart?,
		GroundOffset = Vector3.zero,
		GroundOffsetValid = false,
		NeutralFeetOffsetY = nil :: number?,
		SwimOffset = Vector3.zero,
		CurrentOffset = Vector3.zero,
		SeatOffsetLocal = Vector3.zero,
		SeatOffsetValid = false,
		SeatTransitionActive = false,
		SeatTransitionStart = Vector3.zero,
		SeatTransitionStartedAt = 0,
		SwimTransitionActive = false,
		SwimTransitionStart = Vector3.zero,
		SwimTransitionStartedAt = 0,
		LastSwimming = false,
		SeatPart = nil :: BasePart?,
		Mode = "Ground",
		CalibrationPending = false,
		CalibrationToken = Token,
		GroundCalibrationFrames = 0,
		HiddenInFirstPerson = false,
	}
end

function TryOn.new(Player: Player)
	local self = setmetatable({}, TryOn)
	self.Player = Player
	self.Alive = true
	self.Active = false
	self.Building = false
	self.BuildId = 0
	self.Model = nil :: Model?
	self.Data = nil :: AvatarData?
	self.Animation = nil :: AnimationBinding?
	self.PlaceholderMode = false
	self.AppearanceMode = true
	self.RigPath = ""
	self.DriftLog = {} :: { number }
	self.ReapplyOnRespawn = true
	self.MissingRecovery = false
	self.InPlace = InPlace.new(Player)
	self.Similar = Similar.new(Player)
	self.InPlace.OnPristine = function(Profile, Donor)
		self.Similar:SetReference(Profile.Model)
		local Data = self.Data
		if Data and self.Alive then
			task.spawn(self.Similar.Start, self.Similar, Data, Profile.Model, Donor)
		end
	end
	self.InPlace.Lost:Connect(function(Reason)
		self:HandleInPlaceLost(Reason)
	end)
	self.InPlace.Drifted:Connect(function(Reason)
		self:HandleInPlaceDrift(Reason)
	end)
	self.Placeholder = PlaceholderR6.new()
	self.Place = NewPlacement(0)
	self.Maid = Maid.new()
	self.HiddenParts = {} :: { [BasePart]: number }
	self.HiddenDecals = {} :: { [Instance]: number }
	self.CollisionParts = {} :: { [BasePart]: boolean }
	self.DeathConnection = nil :: RBXScriptConnection?
	self.CharacterConnection = nil :: RBXScriptConnection?
	self.StatusChanged = Signal.new()
	self.Failed = Signal.new()
	self.Cleared = Signal.new()
	self.StateChanged = Signal.new()
	self.Finished = Signal.new()
	return self
end

function TryOn:Report(Text: string)
	self.StatusChanged:Fire(Text)
end

function TryOn:Fail(Summary: string, Detail: any?)
	self.StatusChanged:Fire(Summary)
	self.Failed:Fire(Summary, tostring(Detail or "No additional error text was returned."))
end

function TryOn:ClearFailure()
	self.Cleared:Fire()
end

function TryOn:SetBuilding(Value: boolean)
	if self.Building ~= Value then
		self.Building = Value
		self.StateChanged:Fire()
	end
end

function TryOn:IsWearing(): boolean
	return self.Active or self.Model ~= nil or self.Placeholder.Active or self.InPlace.Active
end

function TryOn:IsBusy(): boolean
	return self.Building or self.Placeholder.Building
end

function TryOn:GetAppearanceOptions(): { [string]: any }
	return { RigPath = self.RigPath }
end

function TryOn:RestoreInPlace()
	self.InPlace:Restore()
	self.Similar:Stop()
end

function TryOn:RescanSimilar()
	local Profile = self.InPlace.Profile
	if not self.Alive or not self.InPlace.Active or not self.Data or not Profile then
		return
	end
	local Data, Model = self.Data, Profile.Model
	self.Similar:Stop()
	self.Similar:Start(Data, Model)
end

function TryOn:DetectRig(): (RigProfile?, string)
	return RigResolver.Resolve(self.Player, self.RigPath)
end

function TryOn:HandleInPlaceLost(Reason: string)
	if not self.Alive or not self.Active or self.Building or not self.Data then
		return
	end
	if not self.ReapplyOnRespawn then
		self:RestoreInPlace()
		self.Active = false
		self.StateChanged:Fire()
		return
	end
	self:Report(`{Reason} Reapplying avatar...`)
	task.spawn(self.WearInPlace, self, self.Data, true)
end

function TryOn:HandleInPlaceDrift(Reason: string)
	if not self.Alive or not self.Active or self.Building or not self.Data then
		return
	end
	local Now = os.clock()
	local Recent = {}
	for _, Time in self.DriftLog do
		if Now - Time < 8 then
			table.insert(Recent, Time)
		end
	end
	self.DriftLog = Recent
	if #Recent >= 4 then
		self.InPlace:StopWatching()
		self:Report("The game keeps resetting your avatar. Auto reapply is paused, press Wear to apply it again.")
		return
	end
	table.insert(Recent, Now)
	self:Report(`{Reason} Reapplying avatar...`)
	task.spawn(self.WearInPlace, self, self.Data, true)
end

function TryOn:ResetPlacement()
	self.Place = NewPlacement(self.Place.CalibrationToken + 1)
end

function TryOn:RestoreCharacter()
	for Part, Transparency in self.HiddenParts do
		pcall(function()
			if Part.Parent then
				Part.LocalTransparencyModifier = Transparency
			end
		end)
	end
	table.clear(self.HiddenParts)

	for Decal, Transparency in self.HiddenDecals do
		pcall(function()
			if Decal.Parent then
				Decal.Transparency = Transparency
			end
		end)
	end
	table.clear(self.HiddenDecals)
end

function TryOn.DestroyOrphans(Except: Model?)
	for _, Descendant in Workspace:GetDescendants() do
		if Descendant:IsA("Model") and Descendant.Name == Constants.ModelName and Descendant ~= Except then
			Util.Destroy(Descendant)
		end
	end
end

local function GetTopLevel(Object: Instance, Character: Model): Instance?
	local Current = Object
	while Current and Current.Parent and Current.Parent ~= Character do
		Current = Current.Parent
	end
	return if Current and Current.Parent == Character then Current else nil
end

local function IsExternalAttachment(Object: Instance, Character: Model): boolean
	if Object:FindFirstAncestorOfClass("Tool") or Object:FindFirstAncestorOfClass("VehicleSeat") then
		return true
	end
	local TopLevel = GetTopLevel(Object, Character)
	if not TopLevel then
		return true
	end
	if TopLevel:IsA("Accessory") then
		return false
	end
	local ModelAncestor = Object:FindFirstAncestorOfClass("Model")
	if ModelAncestor and ModelAncestor ~= Character then
		return true
	end
	if TopLevel:IsA("BasePart") and BodyPartNames[TopLevel.Name] then
		if Object:IsA("BasePart") and Object ~= TopLevel and Object.Parent == TopLevel and not BodyPartNames[Object.Name] then
			return true
		end
		return false
	end
	return true
end

function TryOn:HideInstance(Object: Instance)
	local Character = self.Player.Character
	if not Object or not Character or not Object:IsDescendantOf(Character) then
		return
	end
	if IsExternalAttachment(Object, Character) then
		return
	end
	if Object:IsA("BasePart") then
		if self.HiddenParts[Object] == nil then
			self.HiddenParts[Object] = Object.LocalTransparencyModifier
		end
		Object.LocalTransparencyModifier = 1
	elseif Object:IsA("Decal") or Object:IsA("Texture") then
		if self.HiddenDecals[Object] == nil then
			self.HiddenDecals[Object] = Object.Transparency
		end
		Object.Transparency = 1
	end
end

function TryOn:HideCharacter(Character: Model)
	for _, Descendant in Character:GetDescendants() do
		self:HideInstance(Descendant)
	end
	self.Maid:Set(
		"Visibility",
		Character.DescendantAdded:Connect(function(Descendant)
			self:HideInstance(Descendant)
		end)
	)
end

function TryOn:EnforceHidden()
	for Part in self.HiddenParts do
		if Part.Parent and Part.LocalTransparencyModifier ~= 1 then
			Part.LocalTransparencyModifier = 1
		end
	end
	for Decal in self.HiddenDecals do
		if Decal.Parent and Decal.Transparency ~= 1 then
			Decal.Transparency = 1
		end
	end
end

function TryOn.IsFirstPerson(Character: Model): boolean
	local Camera = Workspace.CurrentCamera
	local Head = Character and Character:FindFirstChild("Head", true)
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	if not Camera or not Head or not Humanoid then
		return false
	end
	local Distance = (Camera.CFrame.Position - Head.Position).Magnitude
	local Subject = Camera.CameraSubject
	local Follows = Subject == Humanoid or (Subject ~= nil and Subject:IsDescendantOf(Character))
	return Follows and Distance <= 1.65
end

function TryOn.SetModelVisibility(Model: Model?, Hidden: boolean)
	if not Model then
		return
	end
	local Value = if Hidden then 1 else 0
	for _, Descendant in Model:GetDescendants() do
		if Descendant:IsA("BasePart") then
			Descendant.LocalTransparencyModifier = Value
		elseif Descendant:IsA("Decal") or Descendant:IsA("Texture") then
			pcall(function()
				Descendant.LocalTransparencyModifier = Value
			end)
		end
	end
end

function TryOn:SetFirstPersonVisibility(Hidden: boolean)
	if not self.Model or self.Place.HiddenInFirstPerson == Hidden then
		return
	end
	self.Place.HiddenInFirstPerson = Hidden
	TryOn.SetModelVisibility(self.Model, Hidden)
end

function TryOn:DisableCollision(Object: Instance)
	if not Object or not Object:IsA("BasePart") then
		return
	end
	self.CollisionParts[Object] = true
	pcall(function()
		Object.CanCollide = false
		Object.CanTouch = false
		Object.CanQuery = false
		Object.Massless = true
	end)
end

function TryOn:EnforceNoCollision()
	for Part in self.CollisionParts do
		if Part.Parent then
			pcall(function()
				if Part.CanCollide then
					Part.CanCollide = false
				end
				if Part.CanTouch then
					Part.CanTouch = false
				end
				if Part.CanQuery then
					Part.CanQuery = false
				end
				if not Part.Massless then
					Part.Massless = true
				end
			end)
		else
			self.CollisionParts[Part] = nil
		end
	end
end

function TryOn.IsModelValid(Model: Model?): boolean
	if not Model or not Model:IsA("Model") or not Model:IsDescendantOf(Workspace) then
		return false
	end
	if not Model:FindFirstChildOfClass("Humanoid") then
		return false
	end
	local Root = Model:FindFirstChild("HumanoidRootPart", true) or Model.PrimaryPart or Model:FindFirstChild("Head", true)
	return Root ~= nil and Root:IsA("BasePart")
end

function TryOn.PrepareModel(Model: Model)
	local Humanoid = Model:FindFirstChildOfClass("Humanoid")
	if Humanoid then
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		Humanoid.RequiresNeck = false
		Humanoid.AutomaticScalingEnabled = false
		pcall(function()
			Humanoid.EvaluateStateMachine = false
		end)
		pcall(function()
			for _, State in Enum.HumanoidStateType:GetEnumItems() do
				if State ~= Enum.HumanoidStateType.None then
					Humanoid:SetStateEnabled(State, false)
				end
			end
			Humanoid:ChangeState(Enum.HumanoidStateType.None)
		end)
	end

	local Root = Model:FindFirstChild("HumanoidRootPart") or Model.PrimaryPart
	for _, Descendant in Model:GetDescendants() do
		if Descendant:IsA("BasePart") then
			Descendant.Anchored = Descendant == Root
			Descendant.CanCollide = false
			Descendant.CanTouch = false
			Descendant.CanQuery = false
			Descendant.Massless = true
			Descendant.LocalTransparencyModifier = 0
		elseif Descendant:IsA("Decal") or Descendant:IsA("Texture") then
			pcall(function()
				Descendant.LocalTransparencyModifier = 0
			end)
		elseif Descendant:IsA("Script") or Descendant:IsA("LocalScript") then
			pcall(function()
				Descendant.Disabled = true
			end)
		end
	end
end

local Geometry = {}

function Geometry.GetPartBottomY(Part: BasePart): number
	local Half = Part.Size / 2
	local Lowest = math.huge
	for X = -1, 1, 2 do
		for Y = -1, 1, 2 do
			for Z = -1, 1, 2 do
				local Corner = Part.CFrame:PointToWorldSpace(Vector3.new(Half.X * X, Half.Y * Y, Half.Z * Z))
				Lowest = math.min(Lowest, Corner.Y)
			end
		end
	end
	return Lowest
end

function Geometry.GetFeetBottomY(Model: Model): number?
	local Lowest = math.huge
	local Found = false
	local Seen = {}
	for _, Name in { "LeftFoot", "RightFoot", "Left Leg", "Right Leg" } do
		local Foot = Model:FindFirstChild(Name, true)
		if Foot and Foot:IsA("BasePart") and not Seen[Foot] then
			Seen[Foot] = true
			Found = true
			Lowest = math.min(Lowest, Geometry.GetPartBottomY(Foot))
		end
	end
	return if Found then Lowest else nil
end

function Geometry.SwimOffset(Character: Model, Model: Model, CharacterRoot: BasePart, GeneratedRoot: BasePart): Vector3
	local CharacterTorso = Character:FindFirstChild("UpperTorso") or Character:FindFirstChild("Torso") or CharacterRoot
	local ModelTorso = Model:FindFirstChild("UpperTorso") or Model:FindFirstChild("Torso") or GeneratedRoot
	local CharacterY = CharacterRoot.CFrame:ToObjectSpace(CharacterTorso.CFrame).Y
	local ModelY = GeneratedRoot.CFrame:ToObjectSpace(ModelTorso.CFrame).Y
	return Vector3.new(0, CharacterY - ModelY, 0)
end

function Geometry.GroundOffsetFromPlacement(Character: Model, Model: Model, Current: Vector3?): Vector3?
	if not Character or not Model then
		return nil
	end
	local CharacterFeet, ModelFeet = Geometry.GetFeetBottomY(Character), Geometry.GetFeetBottomY(Model)
	if not CharacterFeet or not ModelFeet then
		return nil
	end
	return Vector3.new(0, CharacterFeet - ModelFeet + (if Current then Current.Y else 0), 0)
end

function Geometry.GroundOffsetFromNeutral(Character: Model, CharacterRoot: BasePart, NeutralY: number?): Vector3?
	if not Character or not CharacterRoot or NeutralY == nil then
		return nil
	end
	local CharacterFeet = Geometry.GetFeetBottomY(Character)
	if not CharacterFeet then
		return nil
	end
	return Vector3.new(0, CharacterFeet - CharacterRoot.Position.Y - NeutralY, 0)
end

function Geometry.HipReference(Model: Model): Vector3?
	if not Model then
		return nil
	end

	local LowerTorso = Model:FindFirstChild("LowerTorso", true)
	if LowerTorso and LowerTorso:IsA("BasePart") then
		local Left = LowerTorso:FindFirstChild("LeftHipRigAttachment")
		local Right = LowerTorso:FindFirstChild("RightHipRigAttachment")
		if Left and Left:IsA("Attachment") and Right and Right:IsA("Attachment") then
			return (Left.WorldPosition + Right.WorldPosition) * 0.5
		end

		local LeftLeg = Model:FindFirstChild("LeftUpperLeg", true)
		local RightLeg = Model:FindFirstChild("RightUpperLeg", true)
		local LeftHip = LeftLeg and LeftLeg:FindFirstChild("LeftHipAttachment")
		local RightHip = RightLeg and RightLeg:FindFirstChild("RightHipAttachment")
		if LeftHip and LeftHip:IsA("Attachment") and RightHip and RightHip:IsA("Attachment") then
			return (LeftHip.WorldPosition + RightHip.WorldPosition) * 0.5
		end
	end

	local Torso = Model:FindFirstChild("Torso", true)
	if Torso and Torso:IsA("BasePart") then
		local Left = Torso:FindFirstChild("Left Hip")
		local Right = Torso:FindFirstChild("Right Hip")
		if Left and Left:IsA("Motor6D") and Right and Right:IsA("Motor6D") then
			local LeftWorld = (Left.Part0 or Torso).CFrame * Left.C0 * Left.Transform
			local RightWorld = (Right.Part0 or Torso).CFrame * Right.C0 * Right.Transform
			return (LeftWorld.Position + RightWorld.Position) * 0.5
		end
	end
	return nil
end

function Geometry.IsGroundState(State: Enum.HumanoidStateType): boolean
	return State == Enum.HumanoidStateType.Running
		or State == Enum.HumanoidStateType.Landed
		or State == Enum.HumanoidStateType.Standing
		or State == Enum.HumanoidStateType.PlatformStanding
end

function TryOn:SeatedHipOffset(Character: Model, Model: Model, Current: Vector3?): Vector3?
	if not self.Alive or not Model or Model ~= self.Model or not Model:IsDescendantOf(Workspace) then
		return nil
	end
	if not Character or not Character.Parent then
		return nil
	end
	local CharacterHip, ModelHip = Geometry.HipReference(Character), Geometry.HipReference(Model)
	if not CharacterHip or not ModelHip then
		return nil
	end
	return (Current or Vector3.zero) + (CharacterHip - ModelHip)
end

function TryOn:WaitForSitSettle(Character: Model, Model: Model, Humanoid: Humanoid, SeatPart: BasePart?, Timeout: number): boolean
	local Deadline = os.clock() + Timeout
	while self.Alive and os.clock() < Deadline do
		if not Character or not Character.Parent or not Humanoid then
			return false
		end
		if not Model or Model ~= self.Model or not Model:IsDescendantOf(Workspace) then
			return false
		end
		if not Util.IsSeated(Humanoid) or Humanoid.SeatPart ~= SeatPart then
			return false
		end
		if AnimationSync.IsSitSettled(Model) then
			return true
		end
		RunService.Heartbeat:Wait()
	end
	return false
end

function TryOn:ScheduleSeatCalibration(Character: Model, Model: Model, Humanoid: Humanoid, SeatPart: BasePart?, BaseOffset: Vector3)
	local Place = self.Place
	Place.CalibrationToken += 1
	local Token = Place.CalibrationToken
	Place.CalibrationPending = true

	task.spawn(function()
		local Settled = self:WaitForSitSettle(Character, Model, Humanoid, SeatPart, 0.6)
		local Current = self.Place
		if not self.Alive or Token ~= Current.CalibrationToken then
			return
		end

		local CharacterRoot = Util.GetRoot(Character)
		local Valid = Settled
			and Model == self.Model
			and Model:IsDescendantOf(Workspace)
			and Character.Parent ~= nil
			and Humanoid ~= nil
			and Util.IsSeated(Humanoid)
			and Humanoid.SeatPart == SeatPart
			and CharacterRoot ~= nil

		if Valid then
			local Offset = self:SeatedHipOffset(Character, Model, BaseOffset)
			if Offset then
				Current.SeatOffsetLocal = CharacterRoot.CFrame:VectorToObjectSpace(Offset)
				Current.SeatOffsetValid = true
				Current.Mode = "Seat"
			end
		end
		Current.CalibrationPending = false
	end)
end

function TryOn:StepPlacement(Character: Model, CharacterRoot: BasePart, Humanoid: Humanoid?)
	local Place = self.Place
	local State = if Humanoid then Humanoid:GetState() else nil
	local Swimming = State == Enum.HumanoidStateType.Swimming
	local Seated = Util.IsSeated(Humanoid)
	local SeatPart = if Humanoid then Humanoid.SeatPart else nil
	local Now = os.clock()

	if not Seated and Swimming ~= Place.LastSwimming then
		Place.LastSwimming = Swimming
		Place.SwimTransitionActive = Swimming or Place.GroundOffsetValid
		Place.SwimTransitionStart = Place.CurrentOffset
		Place.SwimTransitionStartedAt = Now
	elseif Seated then
		Place.LastSwimming = Swimming
		Place.SwimTransitionActive = false
	end

	if self.Animation then
		self.Animation.Update()
	end

	local Target = Place.CurrentOffset

	if Seated then
		if (Place.Mode ~= "Seat" and not Place.CalibrationPending) or Place.SeatPart ~= SeatPart then
			Place.Mode = "SeatCalibration"
			Place.GroundCalibrationFrames = 0
			Place.SeatPart = SeatPart
			Place.SeatOffsetValid = false
			Place.SeatTransitionActive = false
			if not Place.CalibrationPending then
				self:ScheduleSeatCalibration(Character, self.Model, Humanoid, SeatPart, Place.GroundOffset)
			end
		end

		if Place.SeatOffsetValid then
			if not Place.SeatTransitionActive then
				Place.SeatTransitionActive = true
				Place.SeatTransitionStart = CharacterRoot.CFrame:VectorToObjectSpace(Place.CurrentOffset)
				Place.SeatTransitionStartedAt = Now
			end
			local Alpha = math.clamp((Now - Place.SeatTransitionStartedAt) / Constants.FadeTime, 0, 1)
			local Blended = Place.SeatTransitionStart:Lerp(Place.SeatOffsetLocal, SmoothStep(Alpha))
			Target = CharacterRoot.CFrame:VectorToWorldSpace(Blended)
		end
	else
		if Place.Mode == "Seat" or Place.Mode == "SeatCalibration" then
			Place.CalibrationToken += 1
			Place.CalibrationPending = false
			Place.SeatPart = nil
			Place.SeatOffsetValid = false
			Place.SeatTransitionActive = false
			Place.SeatTransitionStart = Vector3.zero
			Place.SeatTransitionStartedAt = 0
			if Place.GroundOffsetValid then
				Place.Mode = "Ground"
				Place.GroundCalibrationFrames = 0
				Target = if Swimming then Place.SwimOffset else Place.GroundOffset
			else
				Place.Mode = "GroundCalibration"
				Place.GroundCalibrationFrames = 2
			end
		end

		if Place.Mode == "GroundCalibration" then
			if not Swimming and Geometry.IsGroundState(State) then
				local Cleared = AnimationSync.IsSitCleared(Character)
				if not Cleared then
					Place.GroundCalibrationFrames = 2
				elseif Place.GroundCalibrationFrames > 0 then
					Place.GroundCalibrationFrames -= 1
				end
				if Place.GroundCalibrationFrames == 0 and AnimationSync.IsSitCleared(Character) then
					local Offset = Geometry.GroundOffsetFromNeutral(Character, CharacterRoot, Place.NeutralFeetOffsetY)
					if Offset then
						Place.GroundOffset = Offset
						Place.GroundOffsetValid = true
						Place.Mode = "Ground"
						Target = Offset
					else
						Place.GroundCalibrationFrames = 1
					end
				end
			else
				Place.GroundCalibrationFrames = 2
			end
			if Place.Mode == "Ground" then
				Target = Place.GroundOffset
			end
		else
			local Desired = if Swimming then Place.SwimOffset else Place.GroundOffset
			if Place.SwimTransitionActive then
				local Alpha = math.clamp((Now - Place.SwimTransitionStartedAt) / Constants.FadeTime, 0, 1)
				Target = Place.SwimTransitionStart:Lerp(Desired, SmoothStep(Alpha))
				if Alpha >= 1 then
					Place.SwimTransitionActive = false
					Target = Desired
				end
			else
				Target = Desired
			end
		end
	end

	Place.CurrentOffset = Target
	Place.RootPart.CFrame = CharacterRoot.CFrame + Target
end

function TryOn:HandleMissingModel()
	if not self.Active or self.Building or self.MissingRecovery then
		return
	end
	self.MissingRecovery = true
	local BuildId = self.BuildId
	task.delay(0.15, function()
		self.MissingRecovery = false
		if not self.Alive or BuildId ~= self.BuildId or self.Building or not self.Active then
			return
		end
		if not self.Model or not self.Model:IsDescendantOf(Workspace) then
			self:Stop(false)
			self:Fail(
				"Local try-on unavailable in this experience.",
				"The generated avatar was removed after creation. Your real avatar has been restored. Try again; some games replace or restrict local Humanoid models."
			)
		end
	end)
end

function TryOn:Step(Character: Model)
	if not self.Alive then
		return
	end
	if not self.Model or not self.Model:IsDescendantOf(Workspace) then
		self:HandleMissingModel()
		return
	end
	self.MissingRecovery = false
	self:EnforceNoCollision()

	if not Character or not Character.Parent then
		local Preserve = self.Active
		self:Stop(Preserve)
		if Preserve then
			self:Report("Character respawning...")
		end
		return
	end

	local CharacterRoot = Util.GetRoot(Character)
	if not CharacterRoot or not self.Place.RootPart then
		local Preserve = self.Active
		self:Stop(Preserve)
		if Preserve then
			self:Report("Waiting for character...")
		end
		return
	end

	self:StepPlacement(Character, CharacterRoot, Character:FindFirstChildOfClass("Humanoid"))
	self:EnforceHidden()
	self:SetFirstPersonVisibility(TryOn.IsFirstPerson(Character))
end

function TryOn:Stop(PreserveActive: boolean?)
	self.BuildId += 1
	self:RestoreInPlace()
	if self.Placeholder.Active or self.Placeholder.Backup then
		self.Placeholder:Restore()
	end
	self.Building = false
	self.MissingRecovery = false
	if not PreserveActive then
		self.Active = false
	end

	if self.Animation then
		self.Animation.Destroy()
		self.Animation = nil
	end
	self.Maid:Clean()
	table.clear(self.CollisionParts)

	if self.Model then
		Util.Destroy(self.Model)
		self.Model = nil
	end
	TryOn.DestroyOrphans(nil)

	self:ResetPlacement()
	self:RestoreCharacter()
	self.StateChanged:Fire()
end

function TryOn:AbortForSeat()
	self:Stop(false)
	self:Fail("Cannot wear avatars while sitting.", Constants.SeatedMessage)
end

function TryOn:WearPlaceholder(Data: AvatarData)
	self.Active = true
	self:Report("Applying R6 placeholder...")
	self:ClearFailure()
	self.StateChanged:Fire()
	local Success, Err = self.Placeholder:Apply(Data, self.Player)
	self.StateChanged:Fire()
	if Success then
		self:Report("R6 placeholder active.")
		self.Finished:Fire(true)
		return
	end
	self.Active = false
	self:Fail("R6 placeholder failed.", Err)
	self.Finished:Fire(false)
end

function TryOn:Build(Data: AvatarData, Character: Model, Humanoid: Humanoid?, BuildId: number): (boolean, any)
	local RigType = Util.ParseRigType(Data.RigType)
	local LastError = "Unknown local avatar creation failure."
	local SeatDuringBuild = false

	if Humanoid then
		self.Maid:Set(
			"BuildSeat",
			Humanoid.Seated:Connect(function(Active)
				if Active then
					SeatDuringBuild = true
				end
			end)
		)
	end

	local function SeatBlocked(): boolean
		return SeatDuringBuild or Util.IsSeated(Humanoid)
	end

	local function Superseded(): boolean
		return not self.Alive or BuildId ~= self.BuildId
	end

	for Attempt = 1, 3 do
		if SeatBlocked() then
			return false, "seat"
		end
		if Superseded() then
			return false, "superseded"
		end

		if Attempt > 1 then
			self:Report(`Retrying local avatar... ({Attempt}/3)`)
			task.wait(0.1 * (Attempt - 1))
			if SeatBlocked() then
				return false, "seat"
			end
			if Superseded() then
				return false, "superseded"
			end
		end

		local Description = Serializer.Reconstruct(Data.Properties)
		AnimationSync.MergePlayerEmotes(Description, Humanoid, RigType)

		local Created, Result = pcall(function()
			return Players:CreateHumanoidModelFromDescriptionAsync(Description, RigType)
		end)
		Util.Destroy(Description)

		if SeatBlocked() then
			if typeof(Result) == "Instance" then
				Util.Destroy(Result)
			end
			return false, "seat"
		end

		if not Created or typeof(Result) ~= "Instance" or not Result:IsA("Model") then
			LastError = tostring(Result)
			if typeof(Result) == "Instance" then
				Util.Destroy(Result)
			end
			continue
		end

		local Model: Model = Result
		local Updater: AnimationBinding? = nil

		local Prepared, SetupError = pcall(function()
			Model.Name = Constants.ModelName
			Serializer.ApplyBodyColors(Model, Data.Properties)
			Serializer.ApplyHeadShape(Model, Data.Properties)
			Serializer.ApplyRigidRefinements(Model, Data.Properties)

			local GeneratedRoot = Model:FindFirstChild("HumanoidRootPart", true)
				or Model.PrimaryPart
				or Model:FindFirstChild("Head", true)
			local CharacterRoot = Util.GetRoot(Character)
			if not GeneratedRoot then
				error("Generated avatar missing root part.")
			end
			if not CharacterRoot then
				error("Your character missing root part.")
			end

			TryOn.PrepareModel(Model)
			for _, Descendant in Model:GetDescendants() do
				self:DisableCollision(Descendant)
			end
			self.Maid:Set(
				"Collision",
				Model.DescendantAdded:Connect(function(Descendant)
					self:DisableCollision(Descendant)
				end)
			)
			self.Maid:Set(
				"PreSimulation",
				RunService.PreSimulation:Connect(function()
					self:EnforceNoCollision()
				end)
			)
			self:EnforceNoCollision()

			TryOn.SetModelVisibility(Model, true)
			GeneratedRoot.CFrame = CharacterRoot.CFrame + Vector3.new(0, 100, 0)
			Model.Parent = Workspace
			if not TryOn.IsModelValid(Model) then
				error("Generated avatar was removed or invalid immediately after entering Workspace.")
			end
			self.Model = Model

			RunService.Heartbeat:Wait()
			if SeatBlocked() then
				error("Local try-on blocked: player became seated during avatar build.")
			end
			if not TryOn.IsModelValid(Model) then
				error("Generated avatar did not survive initial rig settling.")
			end

			GeneratedRoot = Model:FindFirstChild("HumanoidRootPart", true)
				or Model.PrimaryPart
				or Model:FindFirstChild("Head", true)
			if not GeneratedRoot then
				error("Generated avatar root disappeared after rig settling.")
			end
			GeneratedRoot.CFrame = CharacterRoot.CFrame

			local Swimming = Humanoid ~= nil and Humanoid:GetState() == Enum.HumanoidStateType.Swimming
			local Place = self.Place
			Place.CurrentOffset = Vector3.zero
			Place.RootPart = GeneratedRoot
			Place.SwimOffset = Geometry.SwimOffset(Character, Model, CharacterRoot, GeneratedRoot)
			local CloneFeet = Geometry.GetFeetBottomY(Model)
			Place.NeutralFeetOffsetY = if CloneFeet then CloneFeet - CharacterRoot.Position.Y else nil
			local Ground = Geometry.GroundOffsetFromPlacement(Character, Model, Vector3.zero)
			if not Ground then
				error("Could not establish initial feet-to-feet ground alignment.")
			end
			Place.GroundOffset = Ground
			Place.GroundOffsetValid = true
			Place.SeatOffsetValid = false
			Place.Mode = "Ground"
			Place.CalibrationPending = false
			Place.CalibrationToken += 1
			Place.GroundCalibrationFrames = 0
			Place.SwimTransitionActive = false
			Place.SwimTransitionStart = Vector3.zero
			Place.SwimTransitionStartedAt = 0
			Place.LastSwimming = Swimming
			Place.SeatPart = nil
			Place.CurrentOffset = if Swimming then Place.SwimOffset else Place.GroundOffset
			GeneratedRoot.CFrame = CharacterRoot.CFrame + Place.CurrentOffset

			self:EnforceNoCollision()
			TryOn.SetModelVisibility(Model, false)
			Place.HiddenInFirstPerson = false
			self:SetFirstPersonVisibility(TryOn.IsFirstPerson(Character))

			Updater = AnimationSync.Bind(Character, Model, Data.Properties, Data.RigType)
			self.Animation = Updater

			if SeatBlocked() then
				error("Local try-on blocked: player became seated during avatar build.")
			end
			if not TryOn.IsModelValid(Model) then
				error("Generated avatar did not survive animation setup.")
			end

			self:HideCharacter(Character)
			task.spawn(function()
				if self.Alive and Model.Parent and Model:IsDescendantOf(Workspace) then
					PreviewCache.Preload(Model)
				end
			end)
		end)

		local Valid = Prepared and not Superseded() and TryOn.IsModelValid(Model)
		if Valid then
			if SeatBlocked() then
				return false, "seat"
			end
			TryOn.DestroyOrphans(Model)
			self:EnforceNoCollision()
			self.Maid:Remove("BuildSeat")
			return true, Model
		end

		if not Prepared then
			LastError = tostring(SetupError)
		end
		if self.Model == Model then
			self.Model = nil
		end
		if self.Animation then
			self.Animation.Destroy()
			self.Animation = nil
		end
		Util.Destroy(Model)
		self.Maid:Remove("Collision")
		self.Maid:Remove("PreSimulation")
		self.Maid:Remove("Visibility")
		table.clear(self.CollisionParts)
		self:ResetPlacement()
		if not Prepared and SeatBlocked() then
			return false, "seat"
		end
	end

	self.Maid:Remove("BuildSeat")
	return false, LastError
end

function TryOn:WearInPlace(Data: AvatarData, Silent: boolean?)
	if self.Building or self.Placeholder.Building then
		return
	end
	self.Data = Data
	self.Active = true
	if self.Model or self.Placeholder.Active or self.Placeholder.Backup then
		self:Stop(true)
	end
	self.BuildId += 1
	local BuildId = self.BuildId
	self:SetBuilding(true)
	if not Silent then
		self:Report("Applying avatar to your original rig...")
		self:ClearFailure()
	end

	local Success, Result = self.InPlace:Apply(Data, self:GetAppearanceOptions(), function()
		return not self.Alive or BuildId ~= self.BuildId
	end)
	self:SetBuilding(false)

	if Success then
		self.InPlace:Watch()
		local Profile = self.InPlace.Profile
		if Profile then
			task.spawn(self.Similar.Start, self.Similar, Data, Profile.Model)
		end
		self.StateChanged:Fire()
		self:Report(Result)
		self:ClearFailure()
		self.Finished:Fire(true)
		return
	end
	if Result == "superseded" then
		return
	end
	self.Active = false
	self.Similar:Stop()
	self.StateChanged:Fire()
	self:Fail("Avatar change failed.", Result)
	self.Finished:Fire(false)
end

function TryOn:Wear(Data: AvatarData?)
	if self.Building or self.Placeholder.Building then
		return
	end
	if not Data or not Data.Properties then
		self:Report("Select an avatar first.")
		self:ClearFailure()
		return
	end
	self.Data = Data

	if Catalog.IsActive then
		local Success, Err = Catalog.Wear(Data)
		if Success then
			self.Active = true
			self:Report("Avatar worn through Catalog Avatar Creator.")
			self:ClearFailure()
			self.StateChanged:Fire()
			self.Finished:Fire(true)
			return
		end
		self.Active = false
		self:Fail("Catalog avatar wear failed.", Err)
		self.StateChanged:Fire()
		self.Finished:Fire(false)
		return
	end

	if self.AppearanceMode or EvadeRig.IsEnabled() then
		self:WearInPlace(Data, false)
		return
	end

	local Character = self.Player.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	if self.PlaceholderMode and Humanoid and Humanoid.RigType == Enum.HumanoidRigType.R6 then
		self:WearPlaceholder(Data)
		return
	end
	if not Character or not Character.Parent then
		self:Fail("Local try-on failed.", "Your character is not available yet. Waiting for spawn...")
		return
	end
	if Util.IsSeated(Humanoid) then
		self:AbortForSeat()
		return
	end

	self.Active = true
	self:Stop(true)
	self.BuildId += 1
	local BuildId = self.BuildId
	self:SetBuilding(true)
	self:Report("Building local avatar...")
	self:ClearFailure()

	local Success, Result = self:Build(Data, Character, Humanoid, BuildId)
	if Success then
		self:SetBuilding(false)
		self.Maid:Set(
			"Position",
			RunService.RenderStepped:Connect(function()
				self:Step(Character)
			end)
		)
		self.StateChanged:Fire()
		self:Report("Local try-on active.")
		self.Finished:Fire(true)
		return
	end

	if Result == "superseded" then
		self:SetBuilding(false)
		return
	end
	if Result == "seat" then
		self:AbortForSeat()
		self.Finished:Fire(false)
		return
	end
	self:SetBuilding(false)
	self:Fail("Local try-on failed.", Result)
	self.Finished:Fire(false)
end

function TryOn:Unwear()
	if self.Building or self.Placeholder.Building then
		return
	end
	self.Active = false
	self:Stop(false)
	self:Report("Local try-on cleared.")
	self:ClearFailure()
end

function TryOn:Toggle(Data: AvatarData?)
	if self.Building or self.Placeholder.Building then
		return
	end
	if self.Model or self.Active then
		self:Unwear()
	else
		self:Wear(Data or self.Data)
	end
end

function TryOn:Reapply(Character: Model)
	if not self.Alive or self.Player.Character ~= Character then
		return
	end
	if not self.Active or not self.Data then
		return
	end
	local Profile = self.InPlace.Profile
	if Profile and Profile.Evade and self.InPlace:IsIntact() then
		self:Report("Your Evade rig still wears the avatar.")
		return
	end
	self:Wear(self.Data)
end

function TryOn:BindCharacter(Character: Model?)
	Util.Disconnect(self.DeathConnection)
	self.DeathConnection = nil
	if not Character then
		return
	end

	task.spawn(function()
		local Humanoid = Character:WaitForChild("Humanoid", 10)
		local Root = Character:WaitForChild("HumanoidRootPart", 10)
		if not Humanoid or not Root or not self.Alive then
			return
		end

		self.DeathConnection = Humanoid.Died:Connect(function()
			if self.InPlace.Active then
				self:Report("Character died. Avatar stays on your rig.")
				return
			end
			if self.Active or self.Model or self.Building or self.Placeholder.Active or self.Placeholder.Backup then
				self:Stop(true)
				TryOn.DestroyOrphans(nil)
				self:Report("Character died. Reapplying avatar after respawn...")
			end
		end)

		if self.Active and self.Data and self.ReapplyOnRespawn then
			task.wait(0.15)
			self:Reapply(Character)

			if self.PlaceholderMode and Humanoid.RigType == Enum.HumanoidRigType.R6 then
				for _, Delay in { 0.45, 1, 2 } do
					task.delay(Delay, function()
						if not self.Alive or self.Player.Character ~= Character then
							return
						end
						if not self.PlaceholderMode or not self.Active or self.Placeholder.Building then
							return
						end
						self:Reapply(Character)
					end)
				end
			end
		elseif self.Active and not self.ReapplyOnRespawn then
			self:RestoreInPlace()
			self.Active = false
			self.StateChanged:Fire()
		else
			self.StateChanged:Fire()
		end
	end)
end

function TryOn:Start()
	self.CharacterConnection = self.Player.CharacterAdded:Connect(function(Character)
		self:BindCharacter(Character)
	end)
	if self.Player.Character then
		self:BindCharacter(self.Player.Character)
	end
end

function TryOn:Destroy()
	self.Alive = false
	self.BuildId += 1
	self.Building = false
	self.Active = false
	Util.Disconnect(self.DeathConnection)
	Util.Disconnect(self.CharacterConnection)
	self.DeathConnection, self.CharacterConnection = nil, nil
	pcall(self.Stop, self, false)
	pcall(self.InPlace.Destroy, self.InPlace)
	pcall(self.Similar.Destroy, self.Similar)
	self.Maid:Destroy()
	self:RestoreCharacter()
	for _, Signal in { self.StatusChanged, self.Failed, self.Cleared, self.StateChanged, self.Finished } do
		Signal:DisconnectAll()
	end
end

local Picker = {}
Picker.__index = Picker

function Picker.new(Host: Instance)
	local self = setmetatable({}, Picker)
	self.Host = Host
	self.Selecting = false
	self.Hovered = nil :: Player?
	self.Highlight = nil :: Highlight?
	self.Maid = Maid.new()
	self.Picked = Signal.new()
	self.Cancelled = Signal.new()
	self.Hint = Signal.new()
	return self
end

function Picker:IsActive(): boolean
	return self.Selecting
end

function Picker:ClearHighlight()
	Util.Destroy(self.Highlight)
	self.Highlight = nil
	self.Hovered = nil
end

function Picker:Highlighted(Target: Player?)
	local Adornee: Instance? = nil
	if Target and EvadeRig.IsEnabled() then
		Adornee = EvadeRig.FindModel(Target)
	end
	Adornee = Adornee or (if Target then Target.Character else nil)
	if not Target or Target == LocalPlayer or not Adornee then
		self:ClearHighlight()
		return
	end
	if self.Hovered == Target and self.Highlight and self.Highlight.Parent then
		return
	end
	Util.Destroy(self.Highlight)

	local Highlight = Instance.new("Highlight")
	Highlight.Name = "AvatarSelectionHighlight"
	Highlight.Adornee = Adornee
	Highlight.FillColor = Color3.fromRGB(205, 205, 210)
	Highlight.FillTransparency = 0.72
	Highlight.OutlineColor = Color3.fromRGB(190, 190, 190)
	Highlight.OutlineTransparency = 0.05
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.Parent = self.Host
	self.Highlight = Highlight
	self.Hovered = Target
end

function Picker.FromScreenPosition(Position: Vector2): Player?
	local Camera = Workspace.CurrentCamera
	if not Camera then
		return nil
	end
	local Ray = Camera:ScreenPointToRay(Position.X, Position.Y)
	local Params = RaycastParams.new()
	Params.FilterType = Enum.RaycastFilterType.Exclude
	local Evade = EvadeRig.IsEnabled()
	local Ignore: { Instance } = {}
	if LocalPlayer.Character then
		table.insert(Ignore, LocalPlayer.Character)
	end
	if Evade then
		local Own = EvadeRig.FindModel(LocalPlayer)
		if Own then
			table.insert(Ignore, Own)
		end
	end
	Params.FilterDescendantsInstances = Ignore
	local Result = Workspace:Raycast(Ray.Origin, Ray.Direction * 1000, Params)
	local Target = Result and Result.Instance
	if not Target then
		return nil
	end
	if Evade then
		local Found = EvadeRig.PlayerFromInstance(Target)
		if Found then
			return if Found ~= LocalPlayer then Found else nil
		end
	end
	local Model = Target:FindFirstAncestorOfClass("Model")
	if not Model or not Model:FindFirstChildOfClass("Humanoid") then
		return nil
	end
	local Found = Players:GetPlayerFromCharacter(Model)
	return if Found and Found ~= LocalPlayer then Found else nil
end

function Picker.FromMouse(): Player?
	local Mouse = LocalPlayer:GetMouse()
	if not Mouse then
		return nil
	end
	return Picker.FromScreenPosition(Vector2.new(Mouse.X, Mouse.Y))
end

function Picker:Start()
	if self.Selecting then
		return
	end
	self.Selecting = true
	self.Hovered = nil

	self.Maid:Give(UserInputService.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement then
			self:Highlighted(Picker.FromMouse())
		end
	end))

	self.Maid:Give(UserInputService.InputBegan:Connect(function(Input, Processed)
		local Kind = Input.UserInputType
		if Kind ~= Enum.UserInputType.MouseButton1 and Kind ~= Enum.UserInputType.Touch then
			return
		end
		if Processed and Kind == Enum.UserInputType.MouseButton1 then
			return
		end
		local Touch = Kind == Enum.UserInputType.Touch
		local Found = if Touch then Picker.FromScreenPosition(Input.Position) else Picker.FromMouse()
		if Found then
			self.Picked:Fire(Found)
		elseif Touch then
			self.Hint:Fire("No player found there. Tap a player to save them.")
		else
			self.Cancelled:Fire()
		end
	end))
end

function Picker:Stop()
	self.Selecting = false
	self.Maid:Clean()
	self:ClearHighlight()
end

function Picker:Destroy()
	self:Stop()
	self.Picked:DisconnectAll()
	self.Cancelled:DisconnectAll()
	self.Hint:DisconnectAll()
end

local DefaultOptions: Options = table.freeze({
	ReapplyOnRespawn = true,
	PlaceholderMode = false,
	AppearanceMode = true,
	ApplyToSimilar = true,
	SimilarThreshold = 0.85,
	RigPath = "",
	Notifications = true,
	PreviewHeight = 240,
	PreviewAutoRotate = false,
	PreviewCacheLimit = 24,
	ToggleKey = "None",
	EvadeMode = "Auto",
	EvadeHideFirstPerson = true,
})

local SortModes = table.freeze({ "Saved order", "Name (A-Z)", "Name (Z-A)", "Most accessories", "Rig type" })
local RigFilters = table.freeze({ "All", "R6", "R15" })

local FlagPrefix = "AvatarChanger"

local AvatarChanger = {}
AvatarChanger.Version = "2.5.0"
AvatarChanger.Library = nil
AvatarChanger.Folder = Constants.DefaultFolder
AvatarChanger.Options = table.clone(DefaultOptions) :: Options
AvatarChanger.Widgets = {} :: { [string]: any }
AvatarChanger.Rows = {} :: { [AvatarData]: any }
AvatarChanger.Booted = false
AvatarChanger.Selected = nil :: AvatarData?
AvatarChanger.SortMode = SortModes[1]
AvatarChanger.RigFilter = RigFilters[1]
AvatarChanger.SearchText = ""
AvatarChanger.StatusText = "Ready."
AvatarChanger.UsernameBusy = false
AvatarChanger.PreviewToken = 0
AvatarChanger.PreviewData = nil :: AvatarData?
AvatarChanger.IgnoredFlags = table.freeze({
	`{FlagPrefix}Rename`,
	`{FlagPrefix}Username`,
	`{FlagPrefix}Search`,
	`{FlagPrefix}Import`,
})
AvatarChanger.Events = {
	Selected = Signal.new(),
	Worn = Signal.new(),
	Unworn = Signal.new(),
	Saved = Signal.new(),
	Deleted = Signal.new(),
	Renamed = Signal.new(),
	Refreshed = Signal.new(),
	StatusChanged = Signal.new(),
	Failed = Signal.new(),
}

local function CallMethod(Object: any, Method: string, ...: any)
	if Object and Object[Method] then
		pcall(Object[Method], Object, ...)
	end
end

local function AddElement(Holder: any, Method: string, ...: any): any
	local Arguments = table.pack(...)
	local Success, Result = pcall(function()
		return Holder[Method](Holder, table.unpack(Arguments, 1, Arguments.n))
	end)
	if Success then
		return Result
	end
	for Index = 1, Arguments.n do
		local Argument = Arguments[Index]
		if type(Argument) == "table" and (Argument.Icon ~= nil or Argument.ButtonIcon ~= nil) then
			Argument.Icon = nil
			Argument.IconColor = nil
			Argument.ButtonIcon = nil
		end
	end
	return Holder[Method](Holder, table.unpack(Arguments, 1, Arguments.n))
end

local function AddStrip(Holder: any, Gap: number?): any
	local Success, Group = pcall(function()
		return Holder:AddGroup({ Direction = "Horizontal", Gap = Gap or 6, Spacing = 8 })
	end)
	if Success and Group then
		return Group
	end
	return Holder
end

local function AttachHost(Gui: ScreenGui)
	if type(gethui) == "function" then
		local Success = pcall(function()
			Gui.Parent = gethui()
		end)
		if Success and Gui.Parent then
			return
		end
	end
	local Success = pcall(function()
		Gui.Parent = CoreGui
	end)
	if Success and Gui.Parent then
		return
	end
	local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if PlayerGui then
		Gui.Parent = PlayerGui
	end
end

local function ReplacePrevious(Callback: () -> ())
	if type(getgenv) ~= "function" then
		return
	end
	pcall(function()
		local Environment = getgenv()
		local Previous = Environment[Constants.CleanupKey]
		if type(Previous) == "function" then
			pcall(Previous)
		end
		Environment[Constants.CleanupKey] = Callback
	end)
end

local function ClearReplacement(Callback: () -> ())
	if type(getgenv) ~= "function" then
		return
	end
	pcall(function()
		local Environment = getgenv()
		if Environment[Constants.CleanupKey] == Callback then
			Environment[Constants.CleanupKey] = nil
		end
	end)
end

function AvatarChanger:SetLibrary(Library: any)
	self.Library = Library
	if Library and Library.OnUnload and not self.UnloadHooked then
		self.UnloadHooked = true
		Library:OnUnload(function()
			self:Destroy()
		end)
	end
	return self
end

function AvatarChanger:SetFolder(Path: string)
	assert(type(Path) == "string" and Path ~= "", "AvatarChanger:SetFolder - Path must be a non-empty string")
	self.Folder = Path
	if self.Store then
		self.Store:SetFolder(Path)
	end
	return self
end

function AvatarChanger:GetIgnoredFlags(): { string }
	return table.clone(self.IgnoredFlags)
end

function AvatarChanger:Configure(Overrides: { [string]: any })
	assert(type(Overrides) == "table", "AvatarChanger:Configure - expected a table")
	for Key, Value in Overrides do
		local Default = DefaultOptions[Key]
		if Default ~= nil and type(Value) == type(Default) then
			self.Options[Key] = Value
		end
	end
	self:_ApplyOptions()
	return self
end

function AvatarChanger:_ApplyOptions()
	local Options = self.Options
	EvadeRig.SetMode(Options.EvadeMode)
	EvadeRig.HideFirstPerson = Options.EvadeHideFirstPerson
	if self.TryOn then
		self.TryOn.ReapplyOnRespawn = Options.ReapplyOnRespawn
		self.TryOn.PlaceholderMode = Options.PlaceholderMode
		self.TryOn.AppearanceMode = Options.AppearanceMode
		self.TryOn.Similar.Enabled = Options.ApplyToSimilar or EvadeRig.IsEnabled()
		self.TryOn.Similar.Threshold = math.clamp(Options.SimilarThreshold, 0.5, 1)
		self.TryOn.RigPath = Options.RigPath
	end
	if self.Cache then
		self.Cache.Limit = math.max(1, Options.PreviewCacheLimit)
	end

	local Widgets = self.Widgets
	local Viewport = Widgets.Viewport
	if Viewport then
		CallMethod(Viewport, "SetHeight", Options.PreviewHeight)
		CallMethod(Viewport, "SetAutoRotate", Options.PreviewAutoRotate, 0.6)
	end

	local Bindings = {
		ReapplyOnRespawn = Options.ReapplyOnRespawn,
		Placeholder = Options.PlaceholderMode,
		AppearanceMode = Options.AppearanceMode,
		ApplySimilar = Options.ApplyToSimilar,
		SimilarThreshold = Options.SimilarThreshold,
		RigPath = Options.RigPath,
		Notifications = Options.Notifications,
		AutoRotate = Options.PreviewAutoRotate,
		PreviewHeight = Options.PreviewHeight,
		EvadeMode = Options.EvadeMode,
		EvadeHideFirstPerson = Options.EvadeHideFirstPerson,
	}
	for Name, Value in Bindings do
		local Widget = Widgets[Name]
		if Widget and Widget.Value ~= Value then
			CallMethod(Widget, "SetValue", Value)
		end
	end
	self:_RefreshOptions()
end

function AvatarChanger:_RewearIfWorn(ModeChanged: boolean?)
	if not self.Booted or self.TryOn:IsBusy() then
		return
	end
	local Worn = self.TryOn.Data
	if not Worn then
		return
	end
	if not ModeChanged and self.TryOn.InPlace.Active then
		task.spawn(self.TryOn.WearInPlace, self.TryOn, Worn, false)
		return
	end
	if not (self.TryOn:IsWearing() or self.TryOn.Active) then
		return
	end
	self.TryOn.Active = false
	self.TryOn:Stop(false)
	task.defer(function()
		if self.Booted and self.TryOn and self.TryOn.Data == Worn then
			self:_Apply(Worn)
		end
	end)
end

function AvatarChanger:GetRigInfo(): (string?, string)
	self:_Boot()
	local Profile, Reason = self.TryOn:DetectRig()
	if not Profile then
		return nil, Reason
	end
	return RigResolver.Describe(Profile), "ok"
end

function AvatarChanger:DetectRig(): boolean
	local Info, Reason = self:GetRigInfo()
	if not Info then
		self:_Fail("Rig not found.", Reason)
		self:Notify(Reason, "Rig not found", 6, true)
		return false
	end
	self:_SetDiagnostics(nil)
	self:_SetStatus(`Rig: {Info}`)
	self:Notify(Info, "Rig detected", 8, true)
	return true
end

function AvatarChanger:Notify(Content: any, Title: string?, Duration: number?, Force: boolean?)
	local Library = self.Library
	if not Library or (not Force and not self.Options.Notifications) then
		return
	end
	pcall(function()
		Library:Notify({
			Title = Title or "Avatar Changer",
			Content = tostring(Content),
			Duration = Duration or 4,
		})
	end)
end

function AvatarChanger:Confirm(Title: string, Content: string, OnConfirm: () -> (), ConfirmText: string?): boolean
	local Window = self.Library and self.Library.Window
	if Window and Window.Dialog then
		Window:Dialog({
			Title = Title,
			Content = Content,
			Buttons = {
				{ Title = ConfirmText or "Yes", Variant = "Danger", Callback = OnConfirm },
				{ Title = "Cancel" },
			},
		})
		return true
	end
	self:_SetStatus("Confirmation dialog unavailable. Action cancelled.")
	return false
end

function AvatarChanger:_SetStatus(Text: any)
	self.StatusText = tostring(Text or "")
	CallMethod(self.Widgets.Status, "SetDesc", self.StatusText)
	self.Events.StatusChanged:Fire(self.StatusText)
end

function AvatarChanger:_SetDiagnostics(Summary: string?, Detail: string?)
	local Row = self.Widgets.Diagnostics
	if not Summary then
		CallMethod(Row, "SetVisible", false)
		return
	end
	if not Row then
		self:Notify(Detail or Summary, Summary, 6, true)
		return
	end
	CallMethod(Row, "SetTitle", Summary)
	CallMethod(Row, "SetDesc", Detail or "")
	CallMethod(Row, "SetVisible", true)
end

function AvatarChanger:_Fail(Summary: string, Detail: any?)
	local Message = tostring(Detail or "No additional error text was returned.")
	self:_SetStatus(Summary)
	self:_SetDiagnostics(Summary, Message)
	self.Events.Failed:Fire(Summary, Message)
end

function AvatarChanger:_Boot()
	if self.Booted then
		return self
	end
	assert(LocalPlayer, "AvatarChanger requires Players.LocalPlayer")

	self.CleanupCallback = function()
		self:Destroy()
	end
	ReplacePrevious(self.CleanupCallback)

	local Host = Instance.new("ScreenGui")
	Host.Name = Constants.HostName
	Host.ResetOnSpawn = false
	AttachHost(Host)

	self.Host = Host
	self.Maid = Maid.new()
	self.Store = Store.new(self.Folder)
	self.Cache = PreviewCache.new(self.Options.PreviewCacheLimit)
	self.TryOn = TryOn.new(LocalPlayer)
	self.Picker = Picker.new(Host)
	self.TryOn.Similar:Ignore(Host)
	self.TryOn.Similar:Ignore(self.Library and self.Library.GUI)
	self.Booted = true

	local Wearer = self.TryOn
	local Links = self.Maid
	Links:Give(Wearer.StatusChanged:Connect(function(Text)
		self:_SetStatus(Text)
	end))
	Links:Give(Wearer.Failed:Connect(function(Summary, Detail)
		self:_Fail(Summary, Detail)
		self:Notify(Detail, Summary, 6, true)
	end))
	Links:Give(Wearer.Cleared:Connect(function()
		self:_SetDiagnostics(nil)
	end))
	Links:Give(Wearer.StateChanged:Connect(function()
		self:_RefreshWear()
	end))
	Links:Give(Wearer.Similar.Changed:Connect(function()
		self:_RefreshSimilar()
	end))
	Links:Give(Wearer.Finished:Connect(function(Success)
		if Success and Wearer.Data then
			self.Events.Worn:Fire(Wearer.Data)
		end
	end))
	Links:Give(self.Picker.Picked:Connect(function(Player)
		self:_OnPlayerPicked(Player)
	end))
	Links:Give(self.Picker.Cancelled:Connect(function()
		self.Picker:Stop()
		self:_SetSelectText("Select player")
		self:_SetStatus("Player selection cancelled.")
	end))
	Links:Give(self.Picker.Hint:Connect(function(Text)
		self:_SetStatus(Text)
	end))

	self:_ApplyOptions()
	Wearer:Start()
	self:_Load()

	if Catalog.IsActive then
		self:Notify(
			"You are in Catalog Avatar Creator. Avatars are FE here and are saved to Saved Outfits.",
			"Avatar Changer",
			8,
			true
		)
	end
	return self
end

function AvatarChanger:_Load()
	if not FileApi.Available() then
		self:_SetStatus("File API unavailable.")
		return false
	end
	local PreviousSignature = self.Selected and self.Selected.Signature
	local PreviousName = self.Selected and self.Selected.Name

	local Count = self.Store:Load()

	if PreviousSignature or PreviousName then
		self.Selected = nil
		for _, Data in self.Store.Avatars do
			if
				(PreviousSignature and Data.Signature == PreviousSignature)
				or (not PreviousSignature and PreviousName and Data.Name == PreviousName)
			then
				self.Selected = Data
				break
			end
		end
	end
	self:_SetStatus(`{Count} avatar(s) loaded.`)
	self:_SetDiagnostics(nil)
	return true
end

function AvatarChanger:GetAvatars(): { AvatarData }
	self:_Boot()
	return table.clone(self.Store.Avatars)
end

function AvatarChanger:GetSelected(): AvatarData?
	return self.Selected
end

function AvatarChanger:Find(Query: any): AvatarData?
	self:_Boot()
	return self.Store:Find(Query)
end

function AvatarChanger:IsWearing(): boolean
	return self.TryOn ~= nil and self.TryOn:IsWearing()
end

function AvatarChanger:IsBusy(): boolean
	return (self.TryOn ~= nil and self.TryOn:IsBusy()) or self.UsernameBusy
end

function AvatarChanger.DisplayName(Data: AvatarData): string
	return tostring(Data.DisplayName or Data.Name or "Unnamed Avatar")
end

function AvatarChanger.Describe(Data: AvatarData): string
	local Parts = {}
	local Name = Data.Username or Data.Name
	if Name and Name ~= "" then
		table.insert(Parts, "@" .. tostring(Name))
	end
	table.insert(Parts, tostring(Data.RigType or "R15"))
	table.insert(Parts, `{Serializer.CountAccessories(Data)} accessories`)
	if Data.Source == "legacy" then
		table.insert(Parts, "legacy")
	end
	return table.concat(Parts, "  •  ")
end

function AvatarChanger:Select(Query: any?)
	self:_Boot()
	local Data = if Query == nil then nil else self.Store:Find(Query)
	self.Selected = Data
	self:_UpdateRows()
	self.Events.Selected:Fire(Data)
	return Data
end

function AvatarChanger:_Apply(Data: AvatarData)
	self:_SetDiagnostics(nil)
	self:_SetStatus(`Wearing: {AvatarChanger.DisplayName(Data)}`)
	task.spawn(self.TryOn.Wear, self.TryOn, Data)
end

function AvatarChanger:Wear(Query: any?): boolean
	self:_Boot()
	local Data = if Query ~= nil then self.Store:Find(Query) else self.Selected
	if not Data then
		self:_SetStatus("Select an avatar first.")
		return false
	end
	if self.TryOn:IsBusy() then
		self:_SetStatus("Please wait, an avatar is still being applied.")
		return false
	end
	if Data ~= self.Selected then
		self:Select(Data)
	end
	self:_Apply(Data)
	return true
end

function AvatarChanger:Preview(Query: any?): boolean
	self:_Boot()
	local Data = if Query ~= nil then self.Store:Find(Query) else self.Selected
	if not Data then
		self:_SetStatus("Select an avatar first.")
		return false
	end
	self.PreviewData = nil
	self:Select(Data)
	self:_SetStatus(`Previewing: {AvatarChanger.DisplayName(Data)}`)
	return true
end

function AvatarChanger:Unpreview()
	self:_Boot()
	self.Selected = nil
	self:_UpdateRows()
	self:_SetStatus("Preview cleared.")
	self.Events.Selected:Fire(nil)
end

function AvatarChanger:Unwear()
	self:_Boot()
	if self.TryOn:IsBusy() then
		return
	end
	local Data = self.TryOn.Data or self.Selected
	self.TryOn:Unwear()
	self:_UpdateRows()
	self.Events.Unworn:Fire(Data)
end

function AvatarChanger:Toggle()
	self:_Boot()
	if self.TryOn:IsBusy() then
		return
	end
	if self.TryOn:IsWearing() then
		self:Unwear()
	else
		self:Wear()
	end
end

function AvatarChanger:_IsWorn(Data: AvatarData?): boolean
	local Worn = self.TryOn and self.TryOn.Data
	if not Data or not Worn or not self.TryOn:IsWearing() then
		return false
	end
	if Worn == Data then
		return true
	end

	return Worn.Signature ~= nil and Worn.Signature == Data.Signature
end

function AvatarChanger:_RefreshSimilar()
	if self.Booted and self.TryOn then
		CallMethod(self.Widgets.SimilarInfo, "SetDesc", self.TryOn.Similar:Summary())
	end
end

function AvatarChanger:GetSimilarRigs(): { Model }
	self:_Boot()
	local List = {}
	for Model in self.TryOn.Similar.Targets do
		table.insert(List, Model)
	end
	return List
end

function AvatarChanger:RescanSimilar()
	self:_Boot()
	if not self.TryOn.InPlace.Active then
		self:_SetStatus("Wear an avatar first, then similar rigs are scanned.")
		return
	end
	self:_SetStatus("Scanning for similar rigs...")
	task.spawn(self.TryOn.RescanSimilar, self.TryOn)
end

function AvatarChanger:_RefreshWear()
	if not self.Booted then
		return
	end
	CallMethod(self.Widgets.Wear, "SetButtonText", if self.TryOn:IsBusy() then "Working..." else "Wear")
	if self.Widgets.EvadeInfo and EvadeRig.IsEnabled() then
		CallMethod(self.Widgets.EvadeInfo, "SetDesc", EvadeRig.Summary(LocalPlayer))
	end
	self:_UpdateRows()
end

function AvatarChanger:_UpdateRows()
	local Busy = self.TryOn ~= nil and self.TryOn:IsBusy()
	for Data, Row in self.Rows do
		local Marker = if self:_IsWorn(Data) then "● " elseif Data == self.Selected then "○ " else ""
		Row:SetTitle(Marker .. AvatarChanger.DisplayName(Data))
		Row:SetWearText(if Busy then "Working..." elseif self:_IsWorn(Data) then "Unwear" else "Wear")
		Row:SetPreviewText(if Data == self.Selected then "Unpreview" else "Preview")
	end
	self:_SyncSelected()
end

function AvatarChanger:_RequestDelete(Data: AvatarData)
	if not self.Booted then
		return
	end
	self:Confirm("Delete avatar", `Delete "{AvatarChanger.DisplayName(Data)}" from your saved avatars? This cannot be undone.`, function()
		if self.Booted then
			self:Delete(Data)
		end
	end, "Delete")
end

function AvatarChanger:_Matches(Data: AvatarData, Query: string): boolean
	if Query == "" then
		return true
	end
	local Fields = { Data.DisplayName, Data.Name, Data.Username, Data.FileName, Data.UserId, Data.RigType }
	for _, Field in Fields do
		if Field ~= nil and string.find(string.lower(tostring(Field)), Query, 1, true) then
			return true
		end
	end
	return false
end

function AvatarChanger:_FilterRows(Query: any)
	local Text = string.lower(Util.Trim(Query))
	local Shown, Total = 0, 0
	for Data, Row in self.Rows do
		Total += 1
		local Visible = self:_Matches(Data, Text)
		CallMethod(Row, "SetVisible", Visible)
		if Visible then
			Shown += 1
		end
	end
	self:_SetStatus(`{Shown}/{Total} avatar(s) shown`)
end

function AvatarChanger:_Ordered(): { AvatarData }
	local List = {}
	for _, Data in self.Store.Avatars do
		if self.RigFilter == "All" or Util.RigName(Data.RigType) == self.RigFilter then
			table.insert(List, Data)
		end
	end

	local Mode = self.SortMode
	local function Name(Data: AvatarData): string
		return string.lower(AvatarChanger.DisplayName(Data))
	end

	if Mode == "Name (A-Z)" then
		table.sort(List, function(Left, Right)
			return Name(Left) < Name(Right)
		end)
	elseif Mode == "Name (Z-A)" then
		table.sort(List, function(Left, Right)
			return Name(Left) > Name(Right)
		end)
	elseif Mode == "Most accessories" then
		table.sort(List, function(Left, Right)
			local LeftCount, RightCount = Serializer.CountAccessories(Left), Serializer.CountAccessories(Right)
			if LeftCount ~= RightCount then
				return LeftCount > RightCount
			end
			return Name(Left) < Name(Right)
		end)
	elseif Mode == "Rig type" then
		table.sort(List, function(Left, Right)
			local LeftRig, RightRig = Util.RigName(Left.RigType), Util.RigName(Right.RigType)
			if LeftRig ~= RightRig then
				return LeftRig < RightRig
			end
			return Name(Left) < Name(Right)
		end)
	end
	return List
end

local RowActions = table.freeze({
	{ Key = "Wear", Text = "Wear", Variant = "WideAccent", Icon = "gloam:lucide:shirt" },
	{ Key = "Preview", Text = "Preview", Variant = "WideTonal", Icon = "gloam:lucide:eye" },
	{ Key = "Delete", Text = "Delete", Variant = "WideDanger", Icon = "gloam:lucide:trash-2" },
})

function AvatarChanger:_CreateRow(Section: any, Data: AvatarData): any
	local Row = { Buttons = {}, Parts = {} }

	local function Run(Key: string)
		if not self.Booted then
			return
		end
		if Key == "Wear" then
			if self:_IsWorn(Data) then
				self:Unwear()
			else
				self:Wear(Data)
			end
		elseif Key == "Preview" then
			if self.Selected == Data then
				self:Unpreview()
			else
				self:Preview(Data)
			end
		else
			self:_RequestDelete(Data)
		end
	end

	local Info = {
		Title = AvatarChanger.DisplayName(Data),
		Content = AvatarChanger.Describe(Data),
	}

	local Grouped = pcall(function()
		local Card = Section:AddGroup({ Spacing = 6 })
		Row.Card = Card
		Row.Info = AddElement(Card, "AddParagraph", Info)
		local Strip = Card:AddGroup({ Direction = "Horizontal", Gap = 6, Spacing = 0 })
		for _, Action in RowActions do
			Row.Buttons[Action.Key] = AddElement(Strip, "AddButton", {
				Title = Action.Text,
				ButtonText = Action.Text,
				ButtonIcon = Action.Icon,
				Variant = Action.Variant,
				Callback = function()
					Run(Action.Key)
				end,
			})
		end
	end)

	if not Grouped then

		if Row.Card then
			pcall(Row.Card.Destroy, Row.Card)
		end
		Row.Card, Row.Info = nil, nil
		table.clear(Row.Buttons)
		Row.Info = AddElement(Section, "AddParagraph", Info)
		table.insert(Row.Parts, Row.Info)
		for _, Action in RowActions do
			local Button = AddElement(Section, "AddButton", {
				Title = `{Action.Text} - {AvatarChanger.DisplayName(Data)}`,
				ButtonText = Action.Text,
				Variant = if Action.Key == "Delete" then "Danger" elseif Action.Key == "Wear" then "Accent" else "Tonal",
				Callback = function()
					Run(Action.Key)
				end,
			})
			Row.Buttons[Action.Key] = Button
			table.insert(Row.Parts, Button)
		end
	end

	function Row:SetTitle(Text: string)
		CallMethod(self.Info, "SetTitle", Text)
	end

	function Row:SetWearText(Text: string)
		CallMethod(self.Buttons.Wear, "SetButtonText", Text)
	end

	function Row:SetPreviewText(Text: string)
		CallMethod(self.Buttons.Preview, "SetButtonText", Text)
	end

	function Row:SetVisible(Value: boolean)
		if self.Card then
			CallMethod(self.Card, "SetVisible", Value)
			return
		end
		for _, Part in self.Parts do
			CallMethod(Part, "SetVisible", Value)
		end
	end

	function Row:Destroy()
		if self.Card then
			pcall(self.Card.Destroy, self.Card)
		end
		for _, Part in self.Parts do
			pcall(Part.Destroy, Part)
		end
		self.Card, self.Info = nil, nil
		table.clear(self.Buttons)
		table.clear(self.Parts)
	end

	return Row
end

function AvatarChanger:_Populate()
	if not self.Booted then
		return
	end
	for _, Row in self.Rows do
		pcall(Row.Destroy, Row)
	end
	table.clear(self.Rows)

	if self.Selected and not table.find(self.Store.Avatars, self.Selected) then
		self.Selected = nil
	end

	local Section = self.Widgets.ListSection
	if Section then
		CallMethod(self.Widgets.Empty, "SetVisible", #self.Store.Avatars == 0)
		for _, Data in self:_Ordered() do
			self.Rows[Data] = self:_CreateRow(Section, Data)
		end
	end

	self:_UpdateRows()
	if Util.Trim(self.SearchText) ~= "" then
		self:_FilterRows(self.SearchText)
	end
end

function AvatarChanger:_SyncSelected()
	local Selected = self.Selected
	if Selected ~= self.PreviewData then
		self.PreviewData = Selected
		self:_ShowPreview(Selected)
	end
	local Info = self.Widgets.SelectedInfo
	if Selected then
		CallMethod(Info, "SetTitle", AvatarChanger.DisplayName(Selected))
		CallMethod(Info, "SetDesc", AvatarChanger.Describe(Selected))
	else
		CallMethod(Info, "SetTitle", "No avatar selected")
		CallMethod(Info, "SetDesc", "")
	end
end

function AvatarChanger:_ShowPreview(Data: AvatarData?)
	local Viewport = self.Widgets.Viewport
	if not Viewport or not self.Booted then
		return
	end
	self.PreviewToken += 1
	local Token = self.PreviewToken

	if not Data then
		pcall(Viewport.SetObject, Viewport, nil)
		return
	end

	task.spawn(function()
		local Key = PreviewCache.GetKey(Data)
		local Template = self.Cache:Get(Key) or self.Cache:Build(Data)
		if not self.Booted or Token ~= self.PreviewToken then
			return
		end
		if not Template then
			self:_SetStatus("Preview unavailable for this avatar.")
			return
		end
		pcall(PreviewCache.Preload, Template)
		if not self.Booted or Token ~= self.PreviewToken then
			return
		end
		local Success, Err = pcall(Viewport.SetModel, Viewport, Template)
		if not Success then
			self:_SetStatus(`Preview failed: {Err}`)
		end
	end)
end

function AvatarChanger:_CaptureEvade(Player: Player): (AvatarData?, string?)
	local Description = EvadeRig.GetDescription(Player)
	if not Description then
		return nil, "Evade has no stored appearance for that player yet."
	end
	local Properties = Serializer.Capture(Description, nil)
	if type(Properties) ~= "table" then
		return nil, "Could not serialize the Evade appearance."
	end
	local RigType = EvadeRig.GetRigType(Player) or Enum.HumanoidRigType.R15
	return {
		Name = Player.Name,
		UserId = Player.UserId,
		DisplayName = Player.DisplayName,
		Properties = Properties,
		RigType = Util.RigName(RigType),
		Signature = Serializer.Signature(Properties, RigType),
		Order = 1,
	}
end

function AvatarChanger:_Capture(Player: Player): (AvatarData?, string?)
	if Player and EvadeRig.IsEnabled() then
		local Data = self:_CaptureEvade(Player)
		if Data then
			return Data, nil
		end
	end
	if not Player or not Player.Character then
		return nil, "Player character is unavailable."
	end
	local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		return nil, "Humanoid is unavailable."
	end
	local Properties, Err = Serializer.CaptureHumanoid(Humanoid, Player.Character)
	if not Properties then
		return nil, Err
	end
	return {
		Name = Player.Name,
		UserId = Player.UserId,
		DisplayName = Player.DisplayName,
		Properties = Properties,
		RigType = Util.RigName(Humanoid.RigType),
		Signature = Serializer.Signature(Properties, Humanoid.RigType),
		Order = 1,
	}
end

function AvatarChanger:_CaptureUsername(Username: string): (AvatarData?, string?)
	local FoundId, UserId = pcall(Players.GetUserIdFromNameAsync, Players, Username)
	if not FoundId or not UserId then
		return nil, `Could not find Roblox user @{Username}.`
	end

	local Loaded, Description = pcall(function()
		if type(Players.GetHumanoidDescriptionFromUserIdAsync) == "function" then
			return Players:GetHumanoidDescriptionFromUserIdAsync(UserId)
		end
		return Players:GetHumanoidDescriptionFromUserId(UserId)
	end)
	if not Loaded or not Description then
		return nil, `Could not load the profile avatar for @{Username}.`
	end

	local Properties = Serializer.Capture(Description, nil)
	Util.Destroy(Description)
	if type(Properties) ~= "table" then
		return nil, `Could not serialize the profile avatar for @{Username}.`
	end

	local Character = LocalPlayer.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local RigType = if Humanoid then Humanoid.RigType else Enum.HumanoidRigType.R6
	if EvadeRig.IsEnabled() then
		RigType = EvadeRig.GetRigType(LocalPlayer) or RigType
	end

	local DisplayName = Username
	pcall(function()
		local Fetched = Players:GetPlayerByUserId(UserId)
		if Fetched then
			DisplayName = Fetched.DisplayName
		end
	end)

	return {
		Name = Username,
		Username = Username,
		UserId = UserId,
		DisplayName = DisplayName,
		Properties = Properties,
		RigType = Util.RigName(RigType),
		Signature = Serializer.Signature(Properties, RigType),
		Order = 1,
	}
end

function AvatarChanger:_PersistCatalog(Data: AvatarData, Label: string): boolean
	local Success, OutfitName, Err = Catalog.SaveOutfit(Data)
	if Success then
		self:_SetStatus(`Saved {Label} to Saved Outfits as {OutfitName}`)
		return true
	end
	self:_Fail("Catalog outfit save failed.", Err or OutfitName)
	return false
end

function AvatarChanger:SavePlayer(Player: Player): (boolean, any)
	self:_Boot()
	if self.Picker:IsActive() then
		self.Picker:Stop()
		self:_SetSelectText("Select player")
	end

	local Data, Err = self:_Capture(Player)
	if not Data then
		self:_Fail(`Failed to save {Player and Player.Name or "player"}.`, Err)
		return false, Err
	end
	if self.Store:FindMatch(Data) then
		local Message = "You already have that exact avatar."
		self:_Fail(`Failed to save {Player.Name}.`, Message)
		return false, Message
	end

	local Created, PathOrError = self.Store:Create(Data)
	if not Created then
		self:_Fail(`Failed to save {Player.Name}.`, PathOrError)
		return false, PathOrError
	end

	self.Selected = Data
	self:_Populate()
	self:_SetDiagnostics(nil)

	local Label = if Player == LocalPlayer then "your avatar" else `@{Player.Name}`
	if Catalog.IsActive then
		self:_PersistCatalog(Data, Label)
	else
		self:_SetStatus(`Saved {Label} as {Data.FileName}`)
	end
	self.Events.Saved:Fire(Data)
	self:Notify(if Player == LocalPlayer then "Your avatar was saved." else `Saved @{Player.Name}.`)
	return true, Data
end

function AvatarChanger:SaveSelf(): (boolean, any)
	return self:SavePlayer(LocalPlayer)
end

function AvatarChanger:_SaveUsername(Username: string): (boolean, any)
	if self.Picker:IsActive() then
		self.Picker:Stop()
		self:_SetSelectText("Select player")
	end
	if self.TryOn:IsWearing() or self.TryOn.Building then
		self.TryOn:Stop(false)
	end
	self:Select(nil)

	local Data, Err = self:_CaptureUsername(Username)
	if not Data then
		return false, Err
	end

	local Existing = self.Store:FindMatch(Data)
	if Existing then
		self.Selected = Existing
		self:_Populate()
		if Catalog.IsActive then
			local Worn, WearError = Catalog.Wear(Existing)
			if not Worn then
				return false, WearError
			end
			self:_SetStatus(`Already saved — equipped existing avatar: {Existing.Name}`)
			self.Events.Worn:Fire(Existing)
		else
			self:_SetStatus(`Already saved — equipped existing avatar: {Existing.Name}`)
			self:Wear(Existing)
		end
		self:_SetDiagnostics(nil)
		return true, Existing
	end

	local Created, PathOrError = self.Store:Create(Data)
	if not Created then
		return false, PathOrError
	end

	self.Selected = Data
	self:_Populate()
	self.Events.Saved:Fire(Data)

	if Catalog.IsActive then
		local Success, _, CatalogError = Catalog.SaveOutfit(Data)
		if not Success then
			return false, CatalogError
		end
		self:_SetStatus(`Wore @{Username} and saved to Saved Outfits`)
		self.Events.Worn:Fire(Data)
		self:_SetDiagnostics(nil)
		return true, Data
	end

	self:_SetStatus(`Wearing profile avatar: @{Username}`)
	self:_SetDiagnostics(nil)
	self:Wear(Data)
	return true, Data
end

function AvatarChanger:SaveUsername(Raw: any): (boolean, any)
	self:_Boot()
	local Username = Util.Trim(Raw)
	Username = string.gsub(Username, "^@", "")
	if Username == "" then
		return false, "Enter a Roblox username first."
	end
	if self.UsernameBusy then
		return false, "A profile avatar is already loading."
	end

	self.UsernameBusy = true
	self:_SetStatus(`Loading profile avatar: @{Username}`)
	self:_SetDiagnostics(nil)

	local Ran, Success, Result = pcall(self._SaveUsername, self, Username)
	self.UsernameBusy = false

	if not Ran then
		self:_Fail("Profile avatar failed.", Success)
		return false, Success
	end
	if not Success then
		self:_Fail("Profile avatar failed.", Result)
		self:Notify(Result, "Profile avatar failed.", 5, true)
		return false, Result
	end
	return true, Result
end

function AvatarChanger:Rename(NewName: any, Query: any?): (boolean, any)
	self:_Boot()
	local Name = Util.Trim(NewName)
	if Name == "" then
		return false, "Name is empty."
	end
	local Data = if Query ~= nil then self.Store:Find(Query) else self.Selected
	if not Data then
		self:_SetStatus("Select an avatar first.")
		return false, "No avatar selected."
	end

	local Success, Result = self.Store:Rename(Data, Name)
	if not Success then
		self:_Fail("Failed to rename avatar.", Result)
		return false, Result
	end
	self:_Populate()
	self:_SetStatus(`Renamed to: {AvatarChanger.DisplayName(Data)}`)
	self.Events.Renamed:Fire(Data)
	return true, Data
end

function AvatarChanger:Delete(Query: any?): (boolean, any)
	self:_Boot()
	local Data = if Query ~= nil then self.Store:Find(Query) else self.Selected
	if not Data then
		self:_SetStatus("Select an avatar first.")
		return false, "No avatar selected."
	end

	local WasWorn = self:_IsWorn(Data)
	if WasWorn and self.TryOn:IsBusy() then
		self:_SetStatus("Please wait, this avatar is still being applied.")
		return false, "Avatar is busy."
	end

	local Label = AvatarChanger.DisplayName(Data)
	local Success, Err = self.Store:Delete(Data)
	if not Success then
		self:_Fail("Failed to delete avatar.", Err)
		return false, Err
	end
	if self.Selected == Data then
		self.Selected = nil
	end
	if WasWorn then
		self.TryOn:Unwear()
		self.TryOn.Data = nil
		self.Events.Unworn:Fire(Data)
	end
	self:_SetStatus(`Deleted: {Label}`)
	self:_SetDiagnostics(nil)
	self:_Populate()
	self.Events.Deleted:Fire(Data)
	return true, Data
end

function AvatarChanger:Export(Query: any?): string?
	self:_Boot()
	local Data = if Query ~= nil then self.Store:Find(Query) else self.Selected
	if not Data then
		return nil
	end
	local Export = {
		Name = Data.Name,
		Username = Data.Username,
		DisplayName = Data.DisplayName,
		UserId = Data.UserId,
		RigType = Data.RigType,
		Properties = Data.Properties,
		Signature = Data.Signature,
		Order = Data.Order,
	}
	local Success, Encoded = Util.Encode(Export)
	return if Success then Encoded else nil
end

function AvatarChanger:Import(Json: string): (boolean, any)
	self:_Boot()
	local Decoded, Data = Util.Decode(tostring(Json or ""))
	if not Decoded or type(Data) ~= "table" or type(Data.Properties) ~= "table" then
		return false, "The data is not a valid avatar."
	end
	local Avatar: AvatarData = {
		Name = tostring(Data.Name or Data.Username or "Imported"),
		Username = Data.Username,
		DisplayName = Data.DisplayName,
		UserId = Data.UserId,
		RigType = Util.RigName(Data.RigType),
		Properties = Data.Properties,
		Signature = Data.Signature or Serializer.Signature(Data.Properties, Data.RigType),
		Order = 1,
	}
	local Existing = self.Store:FindMatch(Avatar)
	if Existing then
		self:Select(Existing)
		return false, "You already have that exact avatar."
	end
	local Created, PathOrError = self.Store:Create(Avatar)
	if not Created then
		return false, PathOrError
	end
	self.Selected = Avatar
	self:_Populate()
	self:_SetStatus(`Imported as {Avatar.FileName}`)
	self.Events.Saved:Fire(Avatar)
	return true, Avatar
end

function AvatarChanger:Refresh()
	self:_Boot()
	self.PreviewToken += 1
	self:_Load()
	self:_Populate()
	self.Events.Refreshed:Fire(#self.Store.Avatars)
end

function AvatarChanger:_SetSelectText(Text: string)
	CallMethod(self.Widgets.SaveOther, "SetButtonText", Text)
end

function AvatarChanger:ToggleSelectOther()
	self:_Boot()
	if self.Picker:IsActive() then
		self.Picker:Stop()
		self:_SetSelectText("Select player")
		self:_SetStatus("Player selection cancelled.")
		return
	end
	self.Picker:Start()
	self:_SetSelectText("Click a player...")
	self:_SetStatus("Select a player to save their current avatar.")
	self:_SetDiagnostics(nil)
end

function AvatarChanger:_OnPlayerPicked(Player: Player)
	self.Picker:Stop()
	self:_SetSelectText("Saving...")
	local Success = self:SavePlayer(Player)
	self:_SetSelectText(if Success then "Saved!" else "Failed")
	task.delay(1.1, function()
		if self.Booted and not self.Picker:IsActive() then
			self:_SetSelectText("Select player")
		end
	end)
end

function AvatarChanger:Destroy()
	local Callback = self.CleanupCallback
	self.CleanupCallback = nil
	self.Booted = false
	self.PreviewToken += 1
	if self.SimilarThread then
		pcall(task.cancel, self.SimilarThread)
		self.SimilarThread = nil
	end

	if self.Picker then
		self.Picker:Destroy()
	end
	if self.TryOn then
		self.TryOn:Destroy()
	end
	if self.Maid then
		self.Maid:Destroy()
	end
	if self.Cache then
		self.Cache:Clear()
	end

	for _, Row in self.Rows do
		pcall(Row.Destroy, Row)
	end
	table.clear(self.Rows)
	table.clear(self.Widgets)

	Util.Destroy(self.Host)
	self.Host, self.Picker, self.TryOn, self.Maid, self.Cache, self.Store = nil, nil, nil, nil, nil, nil
	self.Selected, self.PreviewData = nil, nil
	self.UsernameBusy = false

	for _, Event in self.Events do
		Event:DisconnectAll()
	end
	if Callback then
		ClearReplacement(Callback)
	end
end

local function AddSpace(Holder: any, Height: number)
	pcall(function()
		Holder:AddSpace({ Height = Height })
	end)
end

function AvatarChanger:_BuildMain(Tab: any)
	local Widgets = self.Widgets
	local Section = Tab:AddSection("Avatar Changer")

	Widgets.Status = AddElement(Section, "AddParagraph", {
		Title = "Status",
		Content = self.StatusText,
		Variant = "Info",
	})

	Widgets.Diagnostics = AddElement(Section, "AddParagraph", {
		Title = "Error",
		Content = "",
		Variant = "Danger",
	})
	CallMethod(Widgets.Diagnostics, "SetVisible", false)

	AddSpace(Section, 6)

	local Strip = AddStrip(Section)
	Widgets.Wear = AddElement(Strip, "AddButton", {
		Title = "Wear selected",
		ButtonText = "Wear",
		ButtonIcon = "gloam:lucide:shirt",
		Variant = "WideAccent",
		Callback = function()
			self:Wear()
		end,
	})
	AddElement(Strip, "AddButton", {
		Title = "Reset avatar",
		ButtonText = "Reset",
		ButtonIcon = "gloam:lucide:rotate-ccw",
		Variant = "WideTonal",
		Callback = function()
			self:Unwear()
		end,
	})
	AddElement(Strip, "AddButton", {
		Title = "Detect rig",
		ButtonText = "Detect rig",
		ButtonIcon = "gloam:lucide:scan-search",
		Variant = "WideTonal",
		Callback = function()
			task.spawn(self.DetectRig, self)
		end,
	})
	return Section
end

function AvatarChanger:_BuildPreview(Tab: any)
	local Widgets = self.Widgets
	local Options = self.Options
	local Section = Tab:AddSection("Preview")

	Widgets.SelectedInfo = AddElement(Section, "AddParagraph", {
		Title = "No avatar selected",
		Content = "",
	})

	Widgets.Viewport = AddElement(Section, "AddViewport", `{FlagPrefix}Preview`, {
		Title = "",
		Height = Options.PreviewHeight,
		Interactive = true,
		RawModel = true,
		ZoomingSlider = true,
		FieldOfView = 35,
		ZoomMin = 1,
		ZoomMax = 500,
		AutoRotate = Options.PreviewAutoRotate,
		AutoRotateSpeed = 0.6,
		Smooth = true,
		Inertia = true,
		KeepOrientation = true,
		Focused = true,
	})

	AddSpace(Section, 6)

	local Strip = AddStrip(Section)
	AddElement(Strip, "AddButton", {
		Title = "Reset camera",
		ButtonText = "Reset camera",
		ButtonIcon = "gloam:lucide:focus",
		Variant = "WideTonal",
		Callback = function()
			CallMethod(Widgets.Viewport, "Reset")
		end,
	})
	AddElement(Strip, "AddButton", {
		Title = "Copy data",
		ButtonText = "Copy data",
		ButtonIcon = "gloam:lucide:copy",
		Variant = "WideTonal",
		Callback = function()
			local Json = self:Export()
			local Copy = setclipboard or toclipboard
			if not Json then
				self:_SetStatus("Select an avatar first.")
			elseif type(Copy) ~= "function" then
				self:_Fail("Cannot copy avatar.", "The executor does not provide setclipboard().")
			else
				pcall(Copy, Json)
				self:Notify("Avatar data copied to the clipboard.", nil, nil, true)
			end
		end,
	})

	AddSpace(Section, 6)

	Widgets.AutoRotate = AddElement(Section, "AddToggle", `{FlagPrefix}AutoRotate`, {
		Title = "Auto rotate",
		Icon = "gloam:lucide:rotate-cw",
		Default = Options.PreviewAutoRotate,
		Callback = function(Value)
			self.Options.PreviewAutoRotate = Value == true
			CallMethod(Widgets.Viewport, "SetAutoRotate", Value == true, 0.6)
		end,
	})

	Widgets.PreviewHeight = AddElement(Section, "AddSlider", `{FlagPrefix}PreviewHeight`, {
		Title = "Height",
		Icon = "gloam:lucide:move-vertical",
		Min = 160,
		Max = 420,
		Default = Options.PreviewHeight,
		Rounding = 0,
		Callback = function(Value)
			self.Options.PreviewHeight = Value
			CallMethod(Widgets.Viewport, "SetHeight", Value)
		end,
	})

	AddSpace(Section, 6)

	Widgets.Rename = AddElement(Section, "AddInput", `{FlagPrefix}Rename`, {
		Title = "Rename",
		Icon = "gloam:lucide:pencil",
		Variant = "Field",
		Placeholder = "New name",
		Finished = true,
		Callback = function(Value)
			if Util.Trim(Value) ~= "" then
				self:Rename(Value)
			end
		end,
	})
	return Section
end

function AvatarChanger:_BuildList(Tab: any)
	local Widgets = self.Widgets
	local Section = Tab:AddSection("Saved Avatars")
	Widgets.ListSection = Section

	Widgets.Search = AddElement(Section, "AddInput", `{FlagPrefix}Search`, {
		Title = "Search",
		Variant = "Field",
		Icon = "search",
		Placeholder = "Search avatars...",
		Finished = false,
		Callback = function(Value)
			self.SearchText = Value
			if self.SearchThread then
				pcall(task.cancel, self.SearchThread)
			end
			self.SearchThread = task.delay(0.15, function()
				self.SearchThread = nil
				if self.Booted then
					self:_FilterRows(Value)
				end
			end)
		end,
	})

	Widgets.Sort = AddElement(Section, "AddDropdown", `{FlagPrefix}Sort`, {
		Title = "Sort by",
		Icon = "gloam:lucide:arrow-up-down",
		Values = table.clone(SortModes),
		Default = self.SortMode,
		Callback = function(Value)
			if type(Value) == "string" and Value ~= self.SortMode then
				self.SortMode = Value
				self:_Populate()
			end
		end,
	})

	Widgets.RigFilter = AddElement(Section, "AddSegmented", `{FlagPrefix}RigFilter`, {
		Title = "Rig type",
		Options = table.clone(RigFilters),
		Default = self.RigFilter,
		Callback = function(Value)
			if type(Value) == "string" and Value ~= self.RigFilter then
				self.RigFilter = Value
				self:_Populate()
			end
		end,
	})

	AddElement(Section, "AddButton", {
		Title = "Refresh list",
		Icon = "gloam:lucide:refresh-cw",
		Variant = "Tonal",
		ButtonText = "Refresh",
		Callback = function()
			self:Refresh()
		end,
	})

	AddSpace(Section, 8)

	Widgets.Empty = AddElement(Section, "AddParagraph", {
		Title = "No saved avatars",
		Content = "",
	})
	return Section
end

function AvatarChanger:_BuildSave(Tab: any)
	local Widgets = self.Widgets
	local Section = Tab:AddSection("Save Avatar")

	Widgets.Username = AddElement(Section, "AddInput", `{FlagPrefix}Username`, {
		Title = "Save by username",
		Icon = "gloam:lucide:user-plus",
		Variant = "Field",
		Placeholder = "Username",
		Finished = true,
		Callback = function(Value)
			if Util.Trim(Value) ~= "" then
				task.spawn(self.SaveUsername, self, Value)
			end
		end,
	})

	AddSpace(Section, 6)

	local Strip = AddStrip(Section)
	AddElement(Strip, "AddButton", {
		Title = "Save self",
		ButtonText = "Save self",
		ButtonIcon = "gloam:lucide:save",
		Variant = "WideTonal",
		Callback = function()
			task.spawn(self.SaveSelf, self)
		end,
	})
	Widgets.SaveOther = AddElement(Strip, "AddButton", {
		Title = "Save other player",
		ButtonText = "Select player",
		ButtonIcon = "gloam:lucide:users",
		Variant = "WideTonal",
		Callback = function()
			self:ToggleSelectOther()
		end,
	})

	AddSpace(Section, 6)

	Widgets.Import = AddElement(Section, "AddInput", `{FlagPrefix}Import`, {
		Title = "Import",
		Icon = "gloam:lucide:download",
		Variant = "Field",
		Placeholder = "Avatar JSON",
		Finished = true,
		Callback = function(Value)
			if Util.Trim(Value) == "" then
				return
			end
			local Success, Result = self:Import(Value)
			if not Success then
				self:_Fail("Import failed.", Result)
			end
		end,
	})
	return Section
end

function AvatarChanger:_BuildOptions(Tab: any)
	local Widgets = self.Widgets
	local Options = self.Options
	local Section = Tab:AddSection("Options")

	local Behavior = AddStrip(Section)
	Widgets.ReapplyOnRespawn = AddElement(Behavior, "AddToggle", `{FlagPrefix}ReapplyOnRespawn`, {
		Title = "Reapply on respawn",
		Icon = "gloam:lucide:refresh-cw",
		Default = Options.ReapplyOnRespawn,
		Callback = function(Value)
			self.Options.ReapplyOnRespawn = Value == true
			self.TryOn.ReapplyOnRespawn = Value == true
		end,
	})
	Widgets.Notifications = AddElement(Behavior, "AddToggle", `{FlagPrefix}Notifications`, {
		Title = "Notifications",
		Icon = "gloam:lucide:bell",
		Default = Options.Notifications,
		Callback = function(Value)
			self.Options.Notifications = Value == true
		end,
	})

	AddSpace(Section, 6)

	Widgets.AppearanceMode = AddElement(Section, "AddToggle", `{FlagPrefix}AppearanceMode`, {
		Title = "Modify original rig",
		Icon = "gloam:lucide:user-cog",
		Default = Options.AppearanceMode,
		Callback = function(Value)
			local Enabled = Value == true
			if not self.Booted or Enabled == self.Options.AppearanceMode then
				return
			end
			self.Options.AppearanceMode = Enabled
			self.TryOn.AppearanceMode = Enabled
			self:_RefreshOptions()
			if not Enabled then
				self.TryOn.Similar:Stop()
			end
			if self.TryOn:IsWearing() then
				self:_RewearIfWorn(true)
			else
				self:_SetStatus(if Enabled then "Modify original rig enabled." else "Clone overlay mode enabled.")
				self:_SetDiagnostics(nil)
			end
		end,
	})

	Widgets.RigPath = AddElement(Section, "AddInput", `{FlagPrefix}RigPath`, {
		Title = "Rig path",
		Icon = "gloam:lucide:route",
		Variant = "Field",
		Placeholder = "Auto",
		Default = Options.RigPath,
		Finished = true,
		Callback = function(Value)
			if not self.Booted then
				return
			end
			local Path = Util.Trim(Value)
			if Path == self.Options.RigPath then
				return
			end
			self.Options.RigPath = Path
			self.TryOn.RigPath = Path
			self:_RewearIfWorn()
		end,
	})

	Widgets.Placeholder = AddElement(Section, "AddToggle", `{FlagPrefix}Placeholder`, {
		Title = "R6 placeholder",
		Icon = "gloam:lucide:user",
		Default = Options.PlaceholderMode,
		Callback = function(Value)
			local Enabled = Value == true
			if not self.Booted or self.TryOn.Placeholder.Building or Enabled == self.Options.PlaceholderMode then
				return
			end
			self.Options.PlaceholderMode = Enabled
			self.TryOn.PlaceholderMode = Enabled
			if self.TryOn:IsWearing() or self.TryOn.Building then
				self:_RewearIfWorn(true)
			else
				self:_SetStatus(if Enabled then "Placeholder mode enabled." else "Placeholder mode disabled.")
				self:_SetDiagnostics(nil)
			end
		end,
	})

	AddSpace(Section, 6)

	Widgets.ToggleKey = AddElement(Section, "AddKeybind", `{FlagPrefix}ToggleKey`, {
		Title = "Toggle keybind",
		Icon = "gloam:lucide:keyboard",
		Default = Options.ToggleKey,
		Mode = "Toggle",
		Callback = function()
			if self.Booted and (self.Selected or self.TryOn:IsWearing()) then
				self:Toggle()
			end
		end,
		ChangedCallback = function(Key)
			self.Options.ToggleKey = if typeof(Key) == "EnumItem" then Key.Name else tostring(Key)
		end,
	})
	return Section
end

function AvatarChanger:_BuildSimilar(Tab: any)
	local Widgets = self.Widgets
	local Options = self.Options
	local Section = Tab:AddSection("Similar Rigs")
	Widgets.SimilarSection = Section

	Widgets.ApplySimilar = AddElement(Section, "AddToggle", `{FlagPrefix}ApplySimilar`, {
		Title = "Apply to similar rigs",
		Icon = "gloam:lucide:copy",
		Default = Options.ApplyToSimilar,
		Callback = function(Value)
			local Enabled = Value == true
			if not self.Booted or Enabled == self.Options.ApplyToSimilar then
				return
			end
			self.Options.ApplyToSimilar = Enabled
			self.TryOn.Similar.Enabled = Enabled
			self:_RefreshOptions()
			if Enabled then
				self:RescanSimilar()
			else
				self.TryOn.Similar:Stop()
			end
		end,
	})

	local Grouped, Panel = pcall(function()
		return Section:AddGroup({ Spacing = 0 })
	end)
	if Grouped and Panel then
		Widgets.SimilarPanel = Panel
	else
		Panel = Section
	end

	Widgets.SimilarThreshold = AddElement(Panel, "AddSlider", `{FlagPrefix}SimilarThreshold`, {
		Title = "Similarity",
		Icon = "gloam:lucide:percent",
		Min = 0.5,
		Max = 1,
		Default = Options.SimilarThreshold,
		Rounding = 2,
		Callback = function(Value)
			if type(Value) ~= "number" then
				return
			end
			self.Options.SimilarThreshold = Value
			if not self.Booted then
				return
			end
			self.TryOn.Similar.Threshold = math.clamp(Value, 0.5, 1)
			if self.SimilarThread then
				pcall(task.cancel, self.SimilarThread)
			end
			self.SimilarThread = task.delay(0.6, function()
				self.SimilarThread = nil
				if self.Booted and self.TryOn.Similar.Enabled and self.TryOn.InPlace.Active then
					self:RescanSimilar()
				end
			end)
		end,
	})

	Widgets.SimilarInfo = AddElement(Panel, "AddParagraph", {
		Title = "Applied to",
		Content = "None",
	})

	AddElement(Panel, "AddButton", {
		Title = "Rescan",
		ButtonText = "Rescan",
		Icon = "gloam:lucide:scan-search",
		Variant = "Tonal",
		Callback = function()
			self:RescanSimilar()
		end,
	})
	return Section
end

function AvatarChanger:_BuildEvade(Tab: any)
	local Widgets = self.Widgets
	local Options = self.Options
	local Section = Tab:AddSection("Evade")
	Widgets.EvadeSection = Section

	Widgets.EvadeInfo = AddElement(Section, "AddParagraph", {
		Title = "Rig",
		Content = EvadeRig.Summary(LocalPlayer),
	})

	local Strip = AddStrip(Section)
	Widgets.EvadeHideFirstPerson = AddElement(Strip, "AddToggle", `{FlagPrefix}EvadeHideFirstPerson`, {
		Title = "Hide accessories in first person",
		Default = Options.EvadeHideFirstPerson,
		Callback = function(Value)
			self.Options.EvadeHideFirstPerson = Value == true
			EvadeRig.HideFirstPerson = Value == true
		end,
	})
	AddElement(Strip, "AddButton", {
		Title = "Rig status",
		ButtonText = "Refresh",
		Variant = "Tonal",
		Callback = function()
			self:InspectEvade()
		end,
	})
	return Section
end

function AvatarChanger:IsEvade(): boolean
	return EvadeRig.IsEnabled()
end

function AvatarChanger:GetEvadeRig(): Model?
	local Model = EvadeRig.FindModel(LocalPlayer)
	return Model
end

function AvatarChanger:SetEvadeMode(Mode: string)
	assert(table.find(EvadeRig.Modes, Mode), "AvatarChanger:SetEvadeMode - expected Auto or Off")
	self.Options.EvadeMode = Mode
	self:_ApplyOptions()
	if self.Booted then
		self:_RewearIfWorn(true)
	end
end

function AvatarChanger:InspectEvade(): string
	local Summary = EvadeRig.Summary(LocalPlayer)
	CallMethod(self.Widgets.EvadeInfo, "SetDesc", Summary)
	self:_SetStatus(Summary)
	return Summary
end

function AvatarChanger:_RefreshOptions()
	local Widgets, Options = self.Widgets, self.Options
	local Evade = EvadeRig.IsEnabled()
	local Direct = Options.AppearanceMode or Evade
	CallMethod(Widgets.AppearanceMode, "SetVisible", not Evade)
	CallMethod(Widgets.RigPath, "SetVisible", Direct and not Evade)
	CallMethod(Widgets.Placeholder, "SetVisible", not Direct)
	CallMethod(Widgets.EvadeSection, "SetVisible", EvadeRig.Detect())
	CallMethod(Widgets.SimilarSection, "SetVisible", Direct and not Evade)
	CallMethod(Widgets.SimilarPanel, "SetVisible", Direct and not Evade and Options.ApplyToSimilar)
end

function AvatarChanger:BuildSection(Tab: any)
	assert(self.Library, "AvatarChanger: call AvatarChanger:SetLibrary(Fluent) before building")
	assert(Tab and Tab.AddSection, "AvatarChanger:BuildSection - Tab is required")
	self:_Boot()

	local Sections = {
		Main = self:_BuildMain(Tab),
		Preview = self:_BuildPreview(Tab),
		List = self:_BuildList(Tab),
		Save = self:_BuildSave(Tab),
		Options = self:_BuildOptions(Tab),
		Evade = self:_BuildEvade(Tab),
		Similar = self:_BuildSimilar(Tab),
	}

	self:_RefreshOptions()
	self:_Populate()
	self:_RefreshWear()
	return Sections
end

function AvatarChanger:BuildTab(Window: any, Config: { Title: string?, Icon: string? }?)
	assert(Window, "AvatarChanger:BuildTab - Window is required")
	local Settings = Config or {}
	local Title = Settings.Title or "Avatar"
	local Icon = Settings.Icon or "gloam:lucide:user"

	local Success, Tab = pcall(function()
		return Window:AddTab({ Title = Title, Icon = Icon })
	end)
	if not Success or not Tab then
		Tab = Window:AddTab({ Title = Title })
	end
	self:BuildSection(Tab)
	return Tab
end

return AvatarChanger
