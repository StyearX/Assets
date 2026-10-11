local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local ModelInserter = {}
ModelInserter.Folder = "Roblox/ModelInserter"
ModelInserter.Library = nil
ModelInserter.Cache = {}
ModelInserter.Entries = {}
ModelInserter.Loaded = {}
ModelInserter.Widgets = {}
ModelInserter.Selected = nil
ModelInserter.CurrentId = nil
ModelInserter.PendingId = nil
ModelInserter.Token = 0
ModelInserter.Busy = false
ModelInserter.Running = false

local function FormatNumber(Number)
    return tostring(math.floor(Number * 100 + 0.5) / 100)
end

local function FormatVector(Vector)
    return FormatNumber(Vector.X) .. ", " .. FormatNumber(Vector.Y) .. ", " .. FormatNumber(Vector.Z)
end

local function FormatSize(Size)
    return FormatNumber(Size.X) .. " x " .. FormatNumber(Size.Y) .. " x " .. FormatNumber(Size.Z) .. " studs"
end

local function FormatWidthHeight(Size)
    return FormatNumber(Size.X) .. " x " .. FormatNumber(Size.Y) .. " studs"
end

local function SetText(Paragraph, Text)
    if Paragraph.LastText ~= Text then
        Paragraph.LastText = Text
        Paragraph:SetDesc(Text)
    end
end

local function ExtractId(Text)
    return tostring(Text or ""):match("%d+")
end

local function ParseVector(Text)
    local Clean = tostring(Text or ""):gsub("[%(%)%[%]]", "")
    local X, Y, Z = Clean:match("^%s*([%+%-]?[%d%.]+)%s*,%s*([%+%-]?[%d%.]+)%s*,%s*([%+%-]?[%d%.]+)%s*$")
    X, Y, Z = tonumber(X), tonumber(Y), tonumber(Z)
    if X and Y and Z then
        return Vector3.new(X, Y, Z)
    end
    return nil
end

local function VectorToArray(Vector)
    return { Vector.X, Vector.Y, Vector.Z }
end

local function ArrayToVector(Array)
    if type(Array) == "table" and tonumber(Array[1]) and tonumber(Array[2]) and tonumber(Array[3]) then
        return Vector3.new(Array[1], Array[2], Array[3])
    end
    return nil
end

local function SanitizeName(Name)
    return (tostring(Name):gsub('[\\/:%*%?"<>|%c]', "_"))
end

local function GetParts(Container)
    local Parts = {}
    for _, Descendant in ipairs(Container:GetDescendants()) do
        if Descendant:IsA("BasePart") then
            table.insert(Parts, Descendant)
        end
    end
    return Parts
end

local function FindCenterPart(Model)
    local Parts = GetParts(Model)
    if #Parts == 0 then return nil end

    local Total = Vector3.zero
    for _, Part in ipairs(Parts) do
        Total += Part.Position
    end
    local Center = Total / #Parts

    local Closest = Parts[1]
    local Best = math.huge
    for _, Part in ipairs(Parts) do
        local Distance = (Part.Position - Center).Magnitude
        if Distance < Best then
            Closest = Part
            Best = Distance
        end
    end
    return Closest
end

local function FindSpawnPart(Model)
    for _, Descendant in ipairs(Model:GetDescendants()) do
        if Descendant:IsA("BasePart") and (Descendant:IsA("SpawnLocation") or string.find(string.lower(Descendant.Name), "spawn", 1, true)) then
            return Descendant
        end
    end
    return nil
end

local function Measure(Model)
    local Success, Cf, Size = pcall(function()
        return Model:GetBoundingBox()
    end)
    if not Success or not Size or Size.Magnitude == 0 then return nil end
    return Size, Cf.Position
end

local function GetOrientation(Model)
    local X, Y, Z = Model:GetPivot():ToOrientation()
    return Vector3.new(X, Y, Z)
end

local function MoveCenter(Model, Target)
    local Cf = Model:GetBoundingBox()
    Model:PivotTo(Model:GetPivot() + (Target - Cf.Position))
end

local function PrepareModel(Model)
    for _, Part in ipairs(GetParts(Model)) do
        Part.Anchored = true
        Part.CanCollide = true
    end
end

local function TeleportToPart(Part)
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (Root and Part) then return false end
    Root.AssemblyLinearVelocity = Vector3.zero
    Root.CFrame = CFrame.new(Part.Position + Vector3.new(0, Part.Size.Y / 2 + 5, 0))
    return true
end

local function WrapObjects(Id, Objects)
    if #Objects == 1 and Objects[1]:IsA("Model") then
        return Objects[1]
    end
    local Model = Instance.new("Model")
    Model.Name = "Asset_" .. Id
    for _, Object in ipairs(Objects) do
        Object.Parent = Model
    end
    return Model
end

function ModelInserter:SetFolder(Folder)
    self.Folder = Folder
    self:BuildFolderTree()
end

function ModelInserter:SetLibrary(Library)
    self.Library = Library
end

function ModelInserter:GetModelsFolder()
    return self.Folder .. "/Models"
end

function ModelInserter:BuildFolderTree()
    local Paths = {}
    local Parts = self.Folder:split("/")
    for Index = 1, #Parts do
        Paths[#Paths + 1] = table.concat(Parts, "/", 1, Index)
    end
    table.insert(Paths, self:GetModelsFolder())

    for _, Path in ipairs(Paths) do
        if not isfolder(Path) then
            makefolder(Path)
        end
    end
end

function ModelInserter:GetIgnoreIndexes()
    return { "ModelInserter_AssetId", "ModelInserter_Saved", "ModelInserter_Position" }
end

function ModelInserter:Notify(Content)
    if not self.Library then return end
    self.Library:Notify({
        Title = "Model Inserter",
        Content = Content,
        Duration = 3,
    })
end

function ModelInserter:GetOption(Name)
    return self.Library.Options["ModelInserter_" .. Name]
end

function ModelInserter:SetStatus(Text)
    SetText(self.Widgets.Status, Text)
end

function ModelInserter:AutoPosition()
    local Base = Vector3.zero
    local Spawn = Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
    if Spawn then
        Base = Spawn.Position
    end
    return Base + Vector3.new(math.random(50000, 60000), math.random(20000, 30000), math.random(50000, 60000))
end

function ModelInserter:Fetch(Id)
    if self.Cache[Id] then
        return self.Cache[Id]
    end

    local Success, Objects = pcall(function()
        return game:GetObjects("rbxassetid://" .. Id)
    end)
    if not Success then
        return nil, (tostring(Objects):gsub("^.-:%d+:%s*", ""))
    end
    if type(Objects) ~= "table" or #Objects == 0 then
        return nil, "Asset returned nothing"
    end

    local Model = WrapObjects(Id, Objects)
    local PartCount = #GetParts(Model)
    if PartCount == 0 then
        Model:Destroy()
        return nil, "No parts found in this asset"
    end

    Model.Archivable = true
    local Asset = { Model = Model, Size = Measure(Model) or Vector3.zero, Parts = PartCount }
    self.Cache[Id] = Asset
    return Asset
end

function ModelInserter:SaveEntry(Entry)
    local Success, Err = pcall(function()
        self:BuildFolderTree()
        writefile(self:GetModelsFolder() .. "/" .. Entry.File, HttpService:JSONEncode({
            Version = 1,
            Label = Entry.Label,
            Id = Entry.Id,
            Name = Entry.Name,
            Parts = Entry.Parts,
            Size = VectorToArray(Entry.Size),
            Position = VectorToArray(Entry.Position),
            Orientation = VectorToArray(Entry.Orientation),
            SavedAt = Entry.SavedAt,
        }))
    end)
    if not Success then
        warn("[ModelInserter] Failed to save " .. tostring(Entry.Label) .. ": " .. tostring(Err))
    end
    return Success
end

function ModelInserter:DeleteEntryFile(Entry)
    pcall(function()
        local Path = self:GetModelsFolder() .. "/" .. Entry.File
        if isfile(Path) then
            delfile(Path)
        end
    end)
end

function ModelInserter:NewFileName(Label)
    local Base = SanitizeName(Label)
    local File = Base .. ".json"
    local Counter = 2
    while isfile(self:GetModelsFolder() .. "/" .. File) do
        File = Base .. "_" .. Counter .. ".json"
        Counter += 1
    end
    return File
end

function ModelInserter:LoadEntries()
    local Count = 0
    pcall(function()
        self:BuildFolderTree()
        for _, Path in ipairs(listfiles(self:GetModelsFolder())) do
            if Path:lower():sub(-5) == ".json" then
                local ReadOk, Raw = pcall(readfile, Path)
                local DecodeOk, Data = pcall(function()
                    return HttpService:JSONDecode(Raw)
                end)

                if ReadOk and DecodeOk and type(Data) == "table" and type(Data.Label) == "string" and Data.Label ~= "" and ExtractId(Data.Id) and not self.Entries[Data.Label] then
                    self.Entries[Data.Label] = {
                        Label = Data.Label,
                        Id = ExtractId(Data.Id),
                        Name = tostring(Data.Name or Data.Label),
                        Parts = tonumber(Data.Parts) or 0,
                        Size = ArrayToVector(Data.Size) or Vector3.zero,
                        Position = ArrayToVector(Data.Position) or Vector3.zero,
                        Orientation = ArrayToVector(Data.Orientation) or Vector3.zero,
                        SavedAt = tonumber(Data.SavedAt) or 0,
                        File = Path:match("[^/\\]+$"),
                    }
                    Count += 1
                end
            end
        end
    end)
    return Count
end

function ModelInserter:CreateEntry(Asset, Id)
    local Base = tostring(Asset.Model.Name):gsub("%c", ""):match("^%s*(.-)%s*$")
    if Base == "" then
        Base = "Asset_" .. Id
    end
    Base = Base:sub(1, 48)

    local Label = Base
    local Counter = 2
    while self.Entries[Label] do
        Label = string.format("%s (%d)", Base, Counter)
        Counter += 1
    end

    local Entry = {
        Label = Label,
        Id = Id,
        Name = Asset.Model.Name,
        Parts = Asset.Parts,
        Size = Asset.Size,
        Position = Vector3.zero,
        Orientation = Vector3.zero,
        SavedAt = os.time(),
        File = self:NewFileName(Label),
    }
    self.Entries[Label] = Entry
    return Entry
end

function ModelInserter:SyncEntry(Entry, Model, Force)
    local Size, Position = Measure(Model)
    if not Size then return end
    local Orientation = GetOrientation(Model)

    local Changed = Force
        or (Position - Entry.Position).Magnitude > 0.05
        or (Size - Entry.Size).Magnitude > 0.05
        or (Orientation - Entry.Orientation).Magnitude > 0.001

    if Changed then
        Entry.Size = Size
        Entry.Position = Position
        Entry.Orientation = Orientation
        Entry.SavedAt = os.time()
        self:SaveEntry(Entry)
    end
end

function ModelInserter:RefreshDropdown()
    local Labels = {}
    for Label in pairs(self.Entries) do
        table.insert(Labels, Label)
    end
    table.sort(Labels, function(A, B)
        return A:lower() < B:lower()
    end)
    self.Widgets.Saved:SetValues(Labels)
end

function ModelInserter:ClearPreview()
    self.CurrentId = nil
    self.Widgets.Preview:SetObject(nil)
    SetText(self.Widgets.PreviewSize, "-")
    SetText(self.Widgets.PreviewWidthHeight, "-")
end

function ModelInserter:ShowPreview(Asset)
    local Clone = Asset.Model:Clone()
    if not Clone then return end

    for _, Descendant in ipairs(Clone:GetDescendants()) do
        if Descendant:IsA("LuaSourceContainer") or Descendant:IsA("Sound") then
            Descendant:Destroy()
        end
    end

    Clone.PrimaryPart = nil
    Clone.WorldPivot = (Clone:GetBoundingBox())
    Clone:PivotTo(CFrame.new())
    self.Widgets.Preview:SetObject(Clone, false)
end

function ModelInserter:ShowReady(Id, Asset)
    if self.CurrentId ~= Id then
        self.CurrentId = Id
        self:ShowPreview(Asset)
    end
    SetText(self.Widgets.PreviewSize, FormatSize(Asset.Size))
    SetText(self.Widgets.PreviewWidthHeight, FormatWidthHeight(Asset.Size))
    self:SetStatus(string.format("Ready: %s (%d parts)", Asset.Model.Name, Asset.Parts))
end

function ModelInserter:BeginPreview(Id, Delay)
    if self.Cache[Id] then
        self.Token += 1
        self.PendingId = nil
        self:ShowReady(Id, self.Cache[Id])
        return
    end

    if self.PendingId == Id then return end

    self.Token += 1
    local Token = self.Token
    self.PendingId = Id
    self:SetStatus("Loading preview...")

    task.spawn(function()
        if Delay > 0 then
            task.wait(Delay)
        end
        if Token ~= self.Token then return end

        local Asset, Err = self:Fetch(Id)
        if Token ~= self.Token then return end
        self.PendingId = nil

        if not Asset then
            self:ClearPreview()
            self:SetStatus("Failed to load: " .. tostring(Err))
            return
        end

        self:ShowReady(Id, Asset)
    end)
end

function ModelInserter:OnAssetChanged(Value)
    local Id = ExtractId(Value)

    if self.Selected then
        local Entry = self.Entries[self.Selected]
        if not Entry or Entry.Id ~= Id then
            self.Widgets.Saved:SetValue(nil)
            self.Selected = nil
        end
    end

    if not Id then
        self.Token += 1
        self.PendingId = nil
        self:ClearPreview()
        if tostring(Value or "") == "" then
            self:SetStatus("Enter an asset ID to preview it.")
        else
            self:SetStatus("That doesn't look like a valid asset ID.")
        end
        return
    end

    self:BeginPreview(Id, 0.6)
end

function ModelInserter:OnEntrySelected(Label)
    local Entry = Label and self.Entries[Label]

    if not Entry then
        if self.Selected then
            self.Selected = nil
            self:GetOption("Position"):SetValue("")
        end
        return
    end

    self.Selected = Label
    self:BeginPreview(Entry.Id, 0)
    self:GetOption("AssetId"):SetValue(Entry.Id)
    self:GetOption("Position"):SetValue(FormatVector(Entry.Position))
end

function ModelInserter:Track(Label, Model)
    local Connection
    Connection = Model.AncestryChanged:Connect(function()
        local Item = self.Loaded[Label]
        if Item and Item.Model == Model and not Model:IsDescendantOf(Workspace) then
            Connection:Disconnect()
            self.Loaded[Label] = nil
        end
    end)
    self.Loaded[Label] = { Model = Model, Connection = Connection }
end

function ModelInserter:UnloadModel(Label)
    local Item = self.Loaded[Label]
    if not Item then return end
    self.Loaded[Label] = nil
    Item.Connection:Disconnect()
    Item.Model:Destroy()
end

function ModelInserter:GetActiveModel()
    if not (self.Selected and self.Entries[self.Selected]) then
        self:Notify("Select a model in the dropdown first.")
        return nil
    end

    local Item = self.Loaded[self.Selected]
    if Item and Item.Model.Parent then
        return Item.Model, self.Selected
    end

    self:Notify(self.Selected .. " isn't loaded. Press Load Model.")
    return nil
end

function ModelInserter:ResolvePosition()
    local Text = self:GetOption("Position").Value or ""
    if Text:match("%S") then
        local Position = ParseVector(Text)
        if Position then
            return Position
        end
        self:Notify("Invalid position, use X, Y, Z. Using an automatic position.")
    end
    return self:AutoPosition()
end

function ModelInserter:Load()
    if self.Busy then return end

    local Entry = self.Selected and self.Entries[self.Selected]
    local Id = Entry and Entry.Id or ExtractId(self:GetOption("AssetId").Value)
    if not Id then
        self:Notify("Enter an asset ID or pick a saved model first.")
        return
    end

    self.Busy = true
    local Success, Asset, Err = pcall(self.Fetch, self, Id)
    self.Busy = false

    if not Success then
        Err = Asset
        Asset = nil
    end
    if not Asset then
        self:Notify("Load failed: " .. tostring(Err))
        return
    end

    local Model = Asset.Model:Clone()
    if not Model then
        self:Notify("This model can't be cloned.")
        return
    end

    local Target = self:ResolvePosition()
    PrepareModel(Model)

    if Entry then
        local Pivot = Model:GetPivot()
        Model:PivotTo(CFrame.new(Pivot.Position) * CFrame.fromOrientation(Entry.Orientation.X, Entry.Orientation.Y, Entry.Orientation.Z))
        self:UnloadModel(Entry.Label)
    else
        Entry = self:CreateEntry(Asset, Id)
    end

    Model.Parent = Workspace
    MoveCenter(Model, Target)
    self:Track(Entry.Label, Model)

    Entry.Parts = Asset.Parts
    Entry.Name = Asset.Model.Name
    self:SyncEntry(Entry, Model, true)

    self:RefreshDropdown()
    self.Widgets.Saved:SetValue(Entry.Label)
    self:Notify(Entry.Label .. " loaded.")
end

function ModelInserter:TeleportSpawn()
    local Model = self:GetActiveModel()
    if not Model then return end

    local Part = FindSpawnPart(Model)
    if not Part then
        self:Notify("This model has no spawn part.")
        return
    end

    self:Notify(TeleportToPart(Part) and "Teleported to spawn." or "Your character isn't ready.")
end

function ModelInserter:TeleportCenter()
    local Model = self:GetActiveModel()
    if not Model then return end

    local Part = FindCenterPart(Model)
    if not Part then
        self:Notify("This model has no parts.")
        return
    end

    self:Notify(TeleportToPart(Part) and "Teleported to center." or "Your character isn't ready.")
end

function ModelInserter:DeleteEntry(Label)
    local Entry = self.Entries[Label]
    if not Entry then return end

    self:UnloadModel(Label)
    self:DeleteEntryFile(Entry)
    self.Entries[Label] = nil

    local InUse = false
    for _, Other in pairs(self.Entries) do
        if Other.Id == Entry.Id then
            InUse = true
            break
        end
    end
    if not InUse and self.Cache[Entry.Id] then
        self.Cache[Entry.Id].Model:Destroy()
        self.Cache[Entry.Id] = nil
    end

    self:RefreshDropdown()
    self.Widgets.Saved:SetValue(nil)
    self.Selected = nil
    self:GetOption("AssetId"):SetValue("")
    self:GetOption("Position"):SetValue("")
end

function ModelInserter:ConfirmDestroy()
    local Label = self.Selected
    if not (Label and self.Entries[Label]) then
        self:Notify("Select a model in the dropdown first.")
        return
    end

    self.Library.Window:Dialog({
        Title = "Destroy Model",
        Content = "Destroy " .. Label .. " and delete its saved data?",
        Buttons = {
            {
                Title = "Destroy",
                Callback = function()
                    self:DeleteEntry(Label)
                    self:Notify(Label .. " destroyed and its data deleted.")
                end,
            },
            {
                Title = "Cancel",
            },
        },
    })
end

function ModelInserter:ApplyPosition()
    local Model, Label = self:GetActiveModel()
    if not Model then return end

    local Text = self:GetOption("Position").Value
    local Target
    if Text:match("%S") then
        Target = ParseVector(Text)
        if not Target then
            self:Notify("Invalid position, use X, Y, Z.")
            return
        end
    else
        Target = self:AutoPosition()
    end

    MoveCenter(Model, Target)
    self:SyncEntry(self.Entries[Label], Model, true)
    self:Notify("Moved to " .. FormatVector(Target))
end

function ModelInserter:UseMyPosition()
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    if not Root then
        self:Notify("Your character isn't ready.")
        return
    end
    self:GetOption("Position"):SetValue(FormatVector(Root.Position))
end

function ModelInserter:RefreshData()
    for Label, Item in pairs(self.Loaded) do
        local Entry = self.Entries[Label]
        if Entry and Item.Model.Parent then
            self:SyncEntry(Entry, Item.Model, false)
        end
    end

    local Widgets = self.Widgets
    local Entry = self.Selected and self.Entries[self.Selected]
    if not Entry then
        SetText(Widgets.DataStatus, "No model selected")
        SetText(Widgets.DataPosition, "-")
        SetText(Widgets.DataSize, "-")
        SetText(Widgets.DataWidthHeight, "-")
        return
    end

    local State = self.Loaded[Entry.Label] and "Loaded" or "Not loaded"
    SetText(Widgets.DataStatus, string.format("%s\nID %s - %d parts - %s", Entry.Label, Entry.Id, Entry.Parts, State))
    SetText(Widgets.DataPosition, FormatVector(Entry.Position))
    SetText(Widgets.DataSize, FormatSize(Entry.Size))
    SetText(Widgets.DataWidthHeight, FormatWidthHeight(Entry.Size))
end

function ModelInserter:StartTracker()
    if self.Running then return end
    self.Running = true

    task.spawn(function()
        while self.Running and not self.Library.Unloaded do
            pcall(self.RefreshData, self)
            task.wait(0.5)
        end
        self.Running = false
    end)
end

function ModelInserter:Unload()
    self.Running = false
    self.Token += 1

    for Label in pairs(self.Loaded) do
        self:UnloadModel(Label)
    end
    for Id, Asset in pairs(self.Cache) do
        Asset.Model:Destroy()
        self.Cache[Id] = nil
    end
end

function ModelInserter:BuildModelSection(Tab)
    assert(self.Library, "Must set ModelInserter.Library")

    self:BuildFolderTree()

    local Asset = Tab:AddSection("Asset")

    Asset:AddInput("ModelInserter_AssetId", {
        Title = "Asset ID",
        Description = "Preview appears automatically after you stop typing",
        Placeholder = "1234567890",
        Default = "",
        Callback = function(Value) self:OnAssetChanged(Value) end
    })

    self.Widgets.Status = Asset:AddParagraph({
        Title = "Status",
        Content = "Enter an asset ID to preview it."
    })

    local Saved = Tab:AddSection("Saved Models")

    self.Widgets.Saved = Saved:AddDropdown("ModelInserter_Saved", {
        Title = "Saved Models",
        Description = "Select a saved model to preview it, then press Load Model",
        Values = {},
        Multi = false,
        AllowNull = true,
        Search = true,
        Callback = function(Value) self:OnEntrySelected(Value) end
    })

    local Preview = Tab:AddSection("Preview")

    self.Widgets.Preview = Preview:AddViewport({
        Height = 240,
        Interactive = true,
        Focused = true,
        ZoomMin = 0.5,
        BackgroundColor = Color3.fromRGB(15, 15, 20),
        Ambient = Color3.fromRGB(120, 120, 120),
        LightColor = Color3.fromRGB(255, 255, 255),
        LightDirection = Vector3.new(-1, -1, -1),
    })

    local PreviewInfo = Preview:AddGroup({ Columns = 2, Gap = 8 })
    self.Widgets.PreviewSize = PreviewInfo:AddElement():AddParagraph({ Title = "Size", Content = "-" })
    self.Widgets.PreviewWidthHeight = PreviewInfo:AddElement():AddParagraph({ Title = "Width x Height", Content = "-" })

    local Actions = Tab:AddSection("Model")

    Actions:AddButton({
        Title = "Load Model",
        Description = "Load the selected or previewed model into the workspace",
        Icon = "download",
        Callback = function() self:Load() end
    })

    local Teleport = Actions:AddGroup({ Columns = 2, Gap = 8 })

    Teleport:AddElement():AddButton({
        Title = "TP Spawn",
        Icon = "map-pin",
        Callback = function() self:TeleportSpawn() end
    })

    Teleport:AddElement():AddButton({
        Title = "TP Center",
        Icon = "crosshair",
        Callback = function() self:TeleportCenter() end
    })

    Actions:AddButton({
        Title = "Destroy Model",
        Description = "Destroy the selected model and delete its saved data",
        Icon = "trash-2",
        Callback = function() self:ConfirmDestroy() end
    })

    local Position = Tab:AddSection("Position")

    Position:AddInput("ModelInserter_Position", {
        Title = "Custom Position",
        Description = "Format: X, Y, Z (empty = far automatic position)",
        Placeholder = "0, 100, 0",
        Default = ""
    })

    local PositionButtons = Position:AddGroup({ Columns = 2, Gap = 8 })

    PositionButtons:AddElement():AddButton({
        Title = "Apply Position",
        Icon = "move",
        Callback = function() self:ApplyPosition() end
    })

    PositionButtons:AddElement():AddButton({
        Title = "Use My Position",
        Icon = "user",
        Callback = function() self:UseMyPosition() end
    })

    local Data = Tab:AddSection("Model Data")

    local DataTop = Data:AddGroup({ Columns = 2, Gap = 8 })
    self.Widgets.DataStatus = DataTop:AddElement():AddParagraph({ Title = "Model", Content = "No model selected" })
    self.Widgets.DataPosition = DataTop:AddElement():AddParagraph({ Title = "Position", Content = "-" })

    local DataBottom = Data:AddGroup({ Columns = 2, Gap = 8 })
    self.Widgets.DataSize = DataBottom:AddElement():AddParagraph({ Title = "Size", Content = "-" })
    self.Widgets.DataWidthHeight = DataBottom:AddElement():AddParagraph({ Title = "Width x Height", Content = "-" })

    local Count = self:LoadEntries()
    self:RefreshDropdown()
    self:StartTracker()

    if Count > 0 then
        self:Notify(Count .. " saved model(s) found.")
    end
end

ModelInserter:BuildFolderTree()

return ModelInserter
