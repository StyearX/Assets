local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local Found, CoreGui = pcall(game.GetService, game, "CoreGui")

local Salt = 2718281828
local CacheTime = 5

local ChatRow = { "ExperienceChat", "appLayout", "chatInputRow" }
local ChatButton = { "fillArea", "enableChatButton", "EnableChatButton" }
local VoiceIcon = {
    "TopBarApp",
    "TopBarApp",
    "UnibarLeftFrame",
    "UnibarMenu",
    "2",
    "Unibar",
    "3",
    "join_voice",
    "IntegrationIconFrame",
    "IntegrationIcon",
}

local Required = {
    SFW = 0,
    Mature = 1,
    NSFW = 2,
}

local Statuses = {
    [0] = "Restricted",
    [1] = "Teen",
    [2] = "Adult",
}

local AgeGate = {}
AgeGate.Library = nil
AgeGate.Folder = "Roblox/Skyboxes"
AgeGate.Level = nil
AgeGate.Checked = 0
AgeGate.Chat = "Missing"
AgeGate.Voice = "Missing"

local function EnsureFolder(Folder)
    local Parts = Folder:split("/")

    for Index = 1, #Parts do
        local Path = table.concat(Parts, "/", 1, Index)

        if not isfolder(Path) then
            makefolder(Path)
        end
    end
end

local function Mix(Text, Seed)
    local Hash = Seed

    for Index = 1, #Text do
        Hash = (Hash * 33 + string.byte(Text, Index)) % 4294967296
        Hash = bit32.bxor(Hash, bit32.rshift(Hash, 15))
    end

    return Hash
end

local function MakeCode(UserId, Issued)
    local Text = UserId .. ":" .. Issued .. ":" .. Salt

    return string.format("%08x%08x", Mix(Text, 5381), Mix(Text, 52711))
end

local function Find(Root, Path)
    local Current = Root

    for _, Name in ipairs(Path) do
        Current = Current and Current:FindFirstChild(Name)
    end

    return Current
end

local function ReadLabel(Object)
    if Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox") then
        return Object.Text
    end

    if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
        return Object.Image
    end

    return ""
end

local function ReadChat()
    local Row = Find(CoreGui, ChatRow)

    if not Row then
        return "Missing"
    end

    local Button = Find(Row, ChatButton)

    if Button and ReadLabel(Button):lower():find("unlock chat", 1, true) then
        return "Locked"
    end

    return "Unlocked"
end

local function ReadVoice()
    local Icon = Find(CoreGui, VoiceIcon)

    if not Icon then
        return "Missing"
    end

    if ReadLabel(Icon):find("headphones-arrow-up", 1, true) then
        return "Locked"
    end

    return "Unlocked"
end

local function Detect(Reader)
    local Success, State = pcall(Reader)

    return Success and State or "Missing"
end

function AgeGate:SetLibrary(Library)
    self.Library = Library
end

function AgeGate:SetFolder(Folder)
    self.Folder = Folder
end

function AgeGate:Path()
    return self.Folder .. "/AgeGate.json"
end

function AgeGate:Notify(Content)
    if not self.Library then
        return
    end

    self.Library:Notify({
        Title = "Age Verification",
        Content = Content,
        Duration = 5,
    })
end

function AgeGate:Read()
    local Path = self:Path()

    if not isfile(Path) then
        return {}
    end

    local Decoded, Data = pcall(HttpService.JSONDecode, HttpService, readfile(Path))

    return Decoded and type(Data) == "table" and Data or {}
end

function AgeGate:IsConfirmed()
    local UserId = Players.LocalPlayer.UserId
    local Entry = self:Read()[tostring(UserId)]

    if type(Entry) ~= "table" or type(Entry.Issued) ~= "number" then
        return false
    end

    return Entry.Code == MakeCode(UserId, Entry.Issued)
end

function AgeGate:Write(Data)
    EnsureFolder(self.Folder)
    writefile(self:Path(), HttpService:JSONEncode(Data))
end

function AgeGate:Store()
    local UserId = Players.LocalPlayer.UserId
    local Data = self:Read()

    local Issued = os.time()

    Data[tostring(UserId)] = {
        Issued = Issued,
        Code = MakeCode(UserId, Issued),
    }
    self:Write(Data)
end

function AgeGate:Revoke()
    local Data = self:Read()

    Data[tostring(Players.LocalPlayer.UserId)] = nil
    self:Write(Data)
    self:Refresh()
end

function AgeGate:Refresh()
    self.Chat = Found and Detect(ReadChat) or "Missing"
    self.Voice = Found and Detect(ReadVoice) or "Missing"
    self.Checked = os.clock()

    if self:IsConfirmed() then
        self.Level = 2
    elseif self.Chat == "Unlocked" or self.Voice == "Unlocked" then
        self.Level = 1
    else
        self.Level = 0
    end

    return self.Level
end

function AgeGate:GetLevel()
    if not self.Level or os.clock() - self.Checked > CacheTime then
        return self:Refresh()
    end

    return self.Level
end

function AgeGate:GetStatus()
    return Statuses[self:GetLevel()]
end

function AgeGate:GetHint()
    if self.Chat == "Missing" and self.Voice == "Missing" then
        return "Roblox chat and voice chat were not found. Join an experience that has one of them."
    end

    if self.Chat == "Missing" then
        return "Enable Voice Chat in Roblox to verify your age."
    end

    return "Unlock Chat in Roblox or enable Voice Chat to verify your age."
end

function AgeGate:Allows(Tag)
    return self:GetLevel() >= (Required[Tag or "SFW"] or 2)
end

function AgeGate:Confirm(OnConfirmed)
    local Level = self:Refresh()

    if Level == 0 then
        return self:Notify(self:GetHint())
    end

    if Level == 2 then
        return OnConfirmed and OnConfirmed()
    end

    self.Library.Window:Dialog({
        Title = "Age Confirmation",
        Content = "NSFW skyboxes contain explicit adult artwork. Confirm that you are 18 years or older to unlock them.",
        Buttons = {
            {
                Title = "I am 18 or older",
                Variant = "Primary",
                Callback = function()
                    self:Store()
                    self:Refresh()

                    if OnConfirmed then
                        OnConfirmed()
                    end
                end,
            },
            { Title = "Cancel" },
        },
    })
end

return AgeGate
