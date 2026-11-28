local cloneref = (cloneref or clonereference or function(Instance: any)
	return Instance
end)

local function Service(Name)
    local Success, Result = pcall(function()
        return cloneref(game:GetService(Name))
    end)

    return Success and Result or nil
end

local Players = Service("Players")
local HttpService = Service("HttpService")
local TextChatService = Service("TextChatService")
local CoreGui = Service("CoreGui")
local VoiceChat = Service("VoiceChatInternal")

local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
    task.wait()
    LocalPlayer = Players.LocalPlayer
end

local Player = cloneref(LocalPlayer)

local Config = {
    Salt = 2718281828,
    Folder = "AgeGate",
    Interval = 5,
    Timeout = 5,
    Quorum = 2,
    HookCheck = true,
}

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

local Levels = {
    Restricted = 0,
    Teen = 1,
    Adult = 2,
}

local Statuses = {
    [0] = "Restricted",
    [1] = "Teen",
    [2] = "Adult",
}

local function EnsureFolder(Folder)
    local Parts = Folder:split("/")

    for Index = 1, #Parts do
        local Path = table.concat(Parts, "/", 1, Index)

        if not isfolder(Path) then
            makefolder(Path)
        end
    end
end

local Capabilities = {}

Capabilities.Files = pcall(function()
    assert(type(isfile) == "function", "isfile missing")
    assert(type(readfile) == "function", "readfile missing")
    assert(type(writefile) == "function", "writefile missing")
    assert(type(isfolder) == "function", "isfolder missing")
    assert(type(makefolder) == "function", "makefolder missing")

    EnsureFolder(Config.Folder)

    local Path = Config.Folder .. "/.probe"
    local Token = tostring(os.clock()) .. tostring(math.random(100000, 999999))

    writefile(Path, Token)
    assert(isfile(Path), "isfile mismatch")
    assert(readfile(Path) == Token, "readfile mismatch")

    if type(delfile) == "function" then
        pcall(delfile, Path)
    end
end)

Capabilities.Native = pcall(function()
    assert(type(debug) == "table" and type(debug.info) == "function", "debug.info missing")
    assert(debug.info(print, "s") == "[C]", "debug.info source mismatch")
end)

Capabilities.Clone = pcall(function()
    assert(type(cloneref) == "function", "cloneref missing")
    assert(typeof(cloneref(game)) == "Instance", "cloneref invalid")
end)

Capabilities.CoreGui = pcall(function()
    assert(typeof(CoreGui) == "Instance", "CoreGui missing")
    assert(CoreGui:IsA("CoreGui"), "CoreGui invalid")
    assert(CoreGui:GetChildren() ~= nil, "CoreGui inaccessible")
end)

Capabilities.Voice = pcall(function()
    assert(typeof(VoiceChat) == "Instance", "VoiceChatInternal missing")
    assert(type(VoiceChat.IsVoiceEnabledForUserIdAsync) == "function", "voice api missing")
end)

local Natives = {}

local function Capture(Name, Object, Member)
    if typeof(Object) ~= "Instance" then
        return
    end

    local Success, Value = pcall(function()
        return Object[Member]
    end)

    if Success and type(Value) == "function" then
        Natives[Name] = Value
    end
end

Capture("Identity", Player, "IsVerified")
Capture("Chat", TextChatService, "CanUserChatAsync")
Capture("Voice", VoiceChat, "IsVoiceEnabledForUserIdAsync")
Capture("Prompt", Player, "PromptAgeCheck")

local Targets = {
    { "Identity", Player, "IsVerified" },
    { "Chat", TextChatService, "CanUserChatAsync" },
    { "Voice", VoiceChat, "IsVoiceEnabledForUserIdAsync" },
    { "Prompt", Player, "PromptAgeCheck" },
}

local StrongAvailable = (Natives.Identity and 1 or 0) + (Natives.Chat and 1 or 0) + (Natives.Voice and 1 or 0)

local function IsNative(Function)
    if not Capabilities.Native then
        return true
    end

    local Success, Source = pcall(debug.info, Function, "s")

    if not Success then
        return true
    end

    return Source == "[C]"
end

local function CheckHooks()
    for _, Target in ipairs(Targets) do
        local Captured = Natives[Target[1]]

        if Captured then
            local Success, Current = pcall(function()
                return Target[2][Target[3]]
            end)

            if not Success or Current ~= Captured or not IsNative(Captured) then
                return true
            end
        end
    end

    return false
end

local function Mix(Text, Seed)
    local Hash = Seed

    for Index = 1, #Text do
        Hash = (Hash * 33 + string.byte(Text, Index)) % 4294967296
        Hash = bit32.bxor(Hash, bit32.rshift(Hash, 15))
    end

    return Hash
end

local function MakeNonce()
    return (HttpService:GenerateGUID(false):gsub("-", ""))
end

local function MakeCode(UserId, Issued, Nonce, Install)
    local Text = UserId .. ":" .. Issued .. ":" .. Nonce .. ":" .. Install .. ":" .. Config.Salt

    return string.format("%08x%08x%08x", Mix(Text, 5381), Mix(Text, 52711), Mix(Text, 7919))
end

local function Find(Root, Path)
    local Current = Root

    for _, Name in ipairs(Path) do
        if typeof(Current) ~= "Instance" then
            return nil
        end

        local Parent = Current
        local Success, Child = pcall(function()
            return Parent:FindFirstChild(Name) or Parent:FindFirstChild(Name, true)
        end)

        Current = Success and Child or nil
    end

    return typeof(Current) == "Instance" and Current or nil
end

local function ReadLabel(Object)
    local Success, Text = pcall(function()
        if Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox") then
            return Object.Text
        end

        if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return Object.Image
        end

        return ""
    end)

    return Success and type(Text) == "string" and Text or ""
end

local function ReadChat()
    if not Capabilities.CoreGui then
        return "Missing"
    end

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
    if not Capabilities.CoreGui then
        return "Missing"
    end

    local Icon = Find(CoreGui, VoiceIcon)

    if not Icon then
        return "Missing"
    end

    if ReadLabel(Icon):find("headphones-arrow-up", 1, true) then
        return "Locked"
    end

    return "Unlocked"
end

local function ReadProperty()
    return Player.AgeChecked == Enum.AgeCheckStatus.Checked
end

local function ReadIdentity()
    return Natives.Identity(Player) == true
end

local function ReadChatBackend()
    return Natives.Chat(TextChatService, Player.UserId) == true
end

local function ReadVoiceBackend()
    return Natives.Voice(VoiceChat, Player.UserId) == true
end

local function Detect(Reader)
    local Success, State = pcall(Reader)

    return Success and State or "Missing"
end

local function Probe(Reader)
    local Success, State = pcall(Reader)

    return Success and State == true
end

local function FilePath()
    return Config.Folder .. "/AgeGate.json"
end

local function ReadFile()
    if not Capabilities.Files then
        return {}
    end

    local Path = FilePath()

    local Exists, Present = pcall(isfile, Path)

    if not Exists or not Present then
        return {}
    end

    local Read, Content = pcall(readfile, Path)

    if not Read then
        return {}
    end

    local Decoded, Data = pcall(HttpService.JSONDecode, HttpService, Content)

    return Decoded and type(Data) == "table" and Data or {}
end

local function WriteFile(Data)
    if not Capabilities.Files then
        return false
    end

    return (pcall(function()
        EnsureFolder(Config.Folder)
        writefile(FilePath(), HttpService:JSONEncode(Data))
    end))
end

local function GetInstall(Data)
    if type(Data._Install) ~= "string" or #Data._Install < 16 then
        Data._Install = MakeNonce() .. MakeNonce()
        WriteFile(Data)
    end

    return Data._Install
end

local function IsConfirmed()
    local UserId = Player.UserId
    local Data = ReadFile()
    local Entry = Data[tostring(UserId)]

    if type(Entry) ~= "table" or type(Data._Install) ~= "string" then
        return false
    end

    if type(Entry.Issued) ~= "number" or type(Entry.Nonce) ~= "string" or type(Entry.Code) ~= "string" then
        return false
    end

    if Entry.Issued > os.time() + 86400 then
        return false
    end

    return Entry.Code == MakeCode(UserId, Entry.Issued, Entry.Nonce, Data._Install)
end

local function Store()
    local UserId = Player.UserId
    local Data = ReadFile()
    local Install = GetInstall(Data)

    local Issued = os.time()
    local Nonce = MakeNonce()

    Data[tostring(UserId)] = {
        Issued = Issued,
        Nonce = Nonce,
        Code = MakeCode(UserId, Issued, Nonce, Install),
    }

    return WriteFile(Data)
end

local State = {
    Level = 0,
    Ready = false,
    Tampered = false,
    Degraded = StrongAvailable == 0,
    Reason = "Unverified",
    Signals = {},
}

local Initial = Probe(ReadProperty)
local Busy = false
local Dirty = false
local Changed = Instance.new("BindableEvent")

local function Gather()
    local Result = {}
    local Pending = 0

    local Readers = {
        Property = ReadProperty,
        Identity = ReadIdentity,
        ChatBackend = ReadChatBackend,
        VoiceBackend = ReadVoiceBackend,
    }

    for Name, Reader in pairs(Readers) do
        Pending += 1

        task.spawn(function()
            Result[Name] = Probe(Reader)
            Pending -= 1
        end)
    end

    local Start = os.clock()

    while Pending > 0 and os.clock() - Start < Config.Timeout do
        task.wait()
    end

    return table.clone(Result)
end

local function Evaluate()
    local Signals = Gather()

    Signals.ChatUI = Detect(ReadChat)
    Signals.VoiceUI = Detect(ReadVoice)
    Signals.Interface = Signals.ChatUI == "Unlocked" or Signals.VoiceUI == "Unlocked"

    local Strong = (Signals.Identity and 1 or 0)
        + (Signals.ChatBackend and 1 or 0)
        + (Signals.VoiceBackend and 1 or 0)

    local Weak = (Signals.Property and 1 or 0) + (Signals.Interface and 1 or 0)

    local Hooked = Config.HookCheck and CheckHooks() or false
    local Degraded = StrongAvailable == 0
    local Spoofed = Signals.Property == true and not Initial and Strong == 0 and not Degraded

    local Verified

    if Degraded then
        Verified = Signals.Property == true and Initial and Weak >= Config.Quorum
    else
        Verified = Strong >= 1 and Strong + Weak >= Config.Quorum
    end

    local Level = 0
    local Reason = "Unverified"

    if Hooked then
        Reason = "HookDetected"
    elseif Spoofed then
        Reason = "Tampered"
    elseif Verified then
        Level = IsConfirmed() and 2 or 1
        Reason = "Verified"
    end

    local Tampered = Hooked or Spoofed
    local Previous = State.Level
    local Different = Previous ~= Level or State.Tampered ~= Tampered

    State = {
        Level = Level,
        Ready = true,
        Tampered = Tampered,
        Degraded = Degraded,
        Reason = Reason,
        Signals = Signals,
    }

    if Different then
        Changed:Fire(Level, Previous)
    end
end

local function Refresh()
    if Busy then
        Dirty = true

        while Busy do
            task.wait()
        end

        return State.Level
    end

    Busy = true

    repeat
        Dirty = false
        pcall(Evaluate)
    until not Dirty

    Busy = false

    return State.Level
end

local Api = {}

function Api:Wait(Limit)
    local Start = os.clock()

    while not State.Ready and (not Limit or os.clock() - Start < Limit) do
        task.wait()
    end

    return State.Ready
end

function Api:Refresh()
    return Refresh()
end

function Api:Allows(Required)
    local Needed = type(Required) == "number" and Required or Levels[Required] or 2

    return State.Level >= Needed
end

function Api:Prompt()
    if State.Signals.Property or not Natives.Prompt then
        return false
    end

    return (pcall(Natives.Prompt, Player))
end

function Api:Confirm()
    if not Capabilities.Files then
        return false, "NoStorage"
    end

    if Refresh() < 1 then
        return false, State.Reason
    end

    if not Store() then
        return false, "WriteFailed"
    end

    return Refresh() == 2, State.Reason
end

function Api:Revoke()
    local Data = ReadFile()

    Data[tostring(Player.UserId)] = nil
    WriteFile(Data)

    return Refresh()
end

local Fields = {
    Level = function()
        return State.Level
    end,
    Status = function()
        return Statuses[State.Level]
    end,
    Verified = function()
        return State.Level >= 1
    end,
    Adult = function()
        return State.Level >= 2
    end,
    Tampered = function()
        return State.Tampered
    end,
    Degraded = function()
        return State.Degraded
    end,
    Ready = function()
        return State.Ready
    end,
    Reason = function()
        return State.Reason
    end,
    Signals = function()
        return table.clone(State.Signals)
    end,
    Capabilities = function()
        return table.clone(Capabilities)
    end,
    Changed = function()
        return Changed.Event
    end,
}

task.spawn(function()
    while true do
        Refresh()
        task.wait(Config.Interval)
    end
end)

pcall(function()
    Player:GetPropertyChangedSignal("AgeChecked"):Connect(function()
        task.spawn(Refresh)
    end)
end)

return setmetatable({}, {
    __index = function(_, Key)
        local Method = Api[Key]

        if Method then
            return Method
        end

        local Field = Fields[Key]

        return Field and Field()
    end,
    __newindex = function()
        error("AgeGate is read-only", 2)
    end,
    __metatable = "locked",
})
