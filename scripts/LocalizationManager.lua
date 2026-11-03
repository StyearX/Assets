--!optimize 2

type LanguageInfo = { Code: string, Name: string }
type TranslationMap = { [string]: string }
type MessageSet = { Title: string, Start: string, Done: string, Fail: string }
type TextRecord = {
	Object: any,
	Property: string,
	Source: string,
	Key: string?,
	Expected: string?,
	Produced: { [string]: boolean }?,
	NoTranslate: boolean?,
	Connections: { any },
}
type BatchItem = { Source: string, Text: string, Tags: { string } }
type Slicer = (number?) -> boolean


local HttpService: HttpService = game:GetService("HttpService")

local Languages: { LanguageInfo } = {
	{ Code = "en", Name = "English" }, { Code = "vi", Name = "Tiếng Việt" },
	{ Code = "zh-cn", Name = "简体中文" }, { Code = "zh-tw", Name = "繁體中文" },
	{ Code = "ja", Name = "日本語" }, { Code = "ko", Name = "한국어" },
	{ Code = "th", Name = "ไทย" }, { Code = "id", Name = "Bahasa Indonesia" },
	{ Code = "ms", Name = "Bahasa Melayu" }, { Code = "fil", Name = "Filipino" },
	{ Code = "fr", Name = "Français" }, { Code = "de", Name = "Deutsch" },
	{ Code = "es", Name = "Español" }, { Code = "pt", Name = "Português" },
	{ Code = "it", Name = "Italiano" }, { Code = "nl", Name = "Nederlands" },
	{ Code = "pl", Name = "Polski" }, { Code = "ru", Name = "Русский" },
	{ Code = "uk", Name = "Українська" }, { Code = "tr", Name = "Türkçe" },
	{ Code = "ar", Name = "العربية" }, { Code = "hi", Name = "हिन्दी" },
	{ Code = "bn", Name = "বাংলা" }, { Code = "ur", Name = "اردو" },
	{ Code = "fa", Name = "فارسی" }, { Code = "he", Name = "עברית" },
	{ Code = "el", Name = "Ελληνικά" }, { Code = "ro", Name = "Română" },
	{ Code = "sv", Name = "Svenska" }, { Code = "da", Name = "Dansk" },
}


local FlagColors: { [string]: Color3 } = {
	en = Color3.fromRGB(60, 100, 200),
	vi = Color3.fromRGB(218, 37, 29),
	["zh-cn"] = Color3.fromRGB(238, 28, 37),
	["zh-tw"] = Color3.fromRGB(30, 80, 180),
	ja = Color3.fromRGB(188, 0, 45),
	ko = Color3.fromRGB(30, 100, 200),
	th = Color3.fromRGB(165, 25, 49),
	id = Color3.fromRGB(206, 17, 38),
	ms = Color3.fromRGB(255, 204, 0),
	fil = Color3.fromRGB(0, 56, 168),
	fr = Color3.fromRGB(0, 85, 164),
	de = Color3.fromRGB(255, 204, 0),
	es = Color3.fromRGB(241, 191, 0),
	pt = Color3.fromRGB(0, 150, 70),
	it = Color3.fromRGB(0, 146, 70),
	nl = Color3.fromRGB(174, 28, 40),
	pl = Color3.fromRGB(220, 20, 60),
	ru = Color3.fromRGB(0, 57, 166),
	uk = Color3.fromRGB(255, 213, 0),
	tr = Color3.fromRGB(227, 10, 23),
	ar = Color3.fromRGB(0, 122, 61),
	hi = Color3.fromRGB(255, 153, 51),
	bn = Color3.fromRGB(0, 106, 78),
	ur = Color3.fromRGB(0, 128, 60),
	fa = Color3.fromRGB(35, 159, 64),
	he = Color3.fromRGB(0, 56, 184),
	el = Color3.fromRGB(13, 94, 175),
	ro = Color3.fromRGB(252, 209, 22),
	sv = Color3.fromRGB(0, 106, 167),
	da = Color3.fromRGB(198, 12, 48),
}

local GoogleLanguageCodes: { [string]: string } = { ["zh-cn"] = "zh-CN", ["zh-tw"] = "zh-TW" }

local DefaultMessages: { [string]: MessageSet } = {
	en = { Title = "Language", Start = "Translating to %s...", Done = "Translation complete (%s)", Fail = "Translation failed (%s), will retry shortly" },
	vi = { Title = "Ngôn ngữ", Start = "Đang dịch sang %s...", Done = "Dịch thành công (%s)", Fail = "Dịch thất bại (%s), sẽ thử lại sau" },
	zh = { Title = "语言", Start = "正在翻译为 %s...", Done = "翻译成功 (%s)", Fail = "翻译失败 (%s)，稍后重试" },
	ja = { Title = "言語", Start = "%s に翻訳中...", Done = "翻訳が完了しました (%s)", Fail = "翻訳に失敗しました (%s)。まもなく再試行します" },
	ko = { Title = "언어", Start = "%s(으)로 번역 중...", Done = "번역 완료 (%s)", Fail = "번역 실패 (%s), 곧 다시 시도합니다" },
	id = { Title = "Bahasa", Start = "Menerjemahkan ke %s...", Done = "Terjemahan selesai (%s)", Fail = "Terjemahan gagal (%s), akan dicoba lagi" },
	fr = { Title = "Langue", Start = "Traduction en %s...", Done = "Traduction terminée (%s)", Fail = "Échec de la traduction (%s), nouvel essai bientôt" },
	de = { Title = "Sprache", Start = "Übersetze nach %s...", Done = "Übersetzung abgeschlossen (%s)", Fail = "Übersetzung fehlgeschlagen (%s), neuer Versuch folgt" },
	es = { Title = "Idioma", Start = "Traduciendo a %s...", Done = "Traducción completada (%s)", Fail = "Error de traducción (%s), se reintentará" },
	pt = { Title = "Idioma", Start = "Traduzindo para %s...", Done = "Tradução concluída (%s)", Fail = "Falha na tradução (%s), tentando novamente" },
	ru = { Title = "Язык", Start = "Перевод на %s...", Done = "Перевод завершён (%s)", Fail = "Ошибка перевода (%s), повтор позже" },
}

local NoTranslateKeys: { [string]: boolean } = {
	notranslations = true,
	notranslation = true,
	notranslate = true,
	donottranslate = true,
}

local function CopyTable(Source: { [any]: any }?): { [any]: any }
	local Result = {}
	for Key, Value in pairs(Source or {}) do
		Result[Key] = Value
	end
	return Result
end

local function CreateSlicer(Budget: number): Slicer
	local StartedAt = os.clock()
	return function(Limit: number?): boolean
		if os.clock() - StartedAt >= (Limit or Budget) then
			task.wait()
			StartedAt = os.clock()
			return true
		end
		return false
	end
end

local function IsObjectShown(Node: any, Memo: { [any]: boolean }): boolean
	if Node == nil then
		return false
	end
	local Known = Memo[Node]
	if Known ~= nil then
		return Known
	end
	local Shown = true
	if Node:IsA("GuiObject") then
		Shown = Node.Visible
	elseif Node:IsA("LayerCollector") then
		Shown = Node.Enabled
	end
	if Shown then
		local Parent = Node.Parent
		if Parent == nil then
			Shown = false
		elseif Parent ~= game then
			Shown = IsObjectShown(Parent, Memo)
		end
	end
	Memo[Node] = Shown
	return Shown
end

local function IsTextObject(Object: any): boolean
	return Object:IsA("TextLabel") or Object:IsA("TextButton") or Object:IsA("TextBox")
end

local function CreateLocalizationEngine(Library: any)
	local Internals = Library.Internals
	local MarqueeEntries = Internals and Internals.Creator and Internals.Creator.Marquees

	local LocalizationEngine = {
		Records = {},
		Cache = {},
		Failed = {},
		Listeners = {},
		Dropdowns = {},
		Marquees = MarqueeEntries,
		Active = false,
		Dead = false,
		Scheduled = false,
		Busy = false,
		Pending = false,
		SaveScheduled = false,
		RetryScheduled = false,
		Held = false,
		Committing = false,
		CommitAgain = false,
		CommitQueued = false,
		Epoch = 0,
		HoldToken = 0,
		SaveDirtyAt = 0,
		NextSlot = 0,
		FailCount = 0,
		GoodHostIndex = 1,
		CurrentLanguage = "en",
		DisplayLanguage = "en",
		SourceLanguage = "en",
		Prefix = "loc:",
		SourceSignature = "",
		MissingSources = {},
	}

	function LocalizationEngine:NormalizeCode(Code: any): string?
		if type(Code) ~= "string" then
			return nil
		end
		local Normalized = Code:lower():gsub("_", "-")
		if #Normalized < 2 or #Normalized > 24 or not Normalized:match("^[a-z]+[a-z%-]*$") then
			return nil
		end
		return Normalized
	end

	function LocalizationEngine:ReportError(Message: any)
		self.LastError = tostring(Message)
		warn("[FluentLocalization] " .. self.LastError)
		local Config = self.Config
		if Config and type(Config.OnError) == "function" then
			local Callback, Detail = Config.OnError, self.LastError
			task.defer(function()
				pcall(Callback, Detail)
			end)
		end
	end

	function LocalizationEngine:IsMarqueeMirror(Object: any): boolean
		local Entries = self.Marquees
		if not Entries then
			return false
		end
		local Clip = Object.Parent
		local Label = Clip and Clip.Parent
		local Entry = Label and Entries[Label]
		return Entry ~= nil and Entry.Text == Object
	end

	function LocalizationEngine:IsIgnored(Record: TextRecord): boolean
		local Object = Record.Object
		return not self.Config.Enabled
			or Record.NoTranslate == true
			or Object:GetAttribute("ModulesNoTranslate") == true
			or self:IsMarqueeMirror(Object)
			or (Record.Property == "Text" and Object:IsA("TextBox"))
	end

	function LocalizationEngine:GetFallback(Source: string): string
		local Defaults = self.Config.Translations[self.Config.SourceLanguage]
		if type(Defaults) == "table" and type(Defaults[Source]) == "string" then
			return Defaults[Source]
		end
		return Source
	end

	function LocalizationEngine:SplitDictionary(Entries: { [any]: any }, ProtectedSet: { [string]: boolean }): { [any]: any }
		local Clean = {}
		for Key, Value in pairs(Entries) do
			if type(Key) == "string" and NoTranslateKeys[(Key:lower():gsub("[%s_%-]", ""))] then
				if type(Value) == "string" then
					ProtectedSet[Value] = true
				elseif type(Value) == "table" then
					for _, Item in pairs(Value) do
						if type(Item) == "string" then
							ProtectedSet[Item] = true
						end
					end
				end
			else
				Clean[Key] = Value
			end
		end
		return Clean
	end

	function LocalizationEngine:BuildTerms()
		local Terms: { string } = {}
		for Term in pairs(self.Config.NoTranslate) do
			if Term ~= "" then
				table.insert(Terms, Term)
			end
		end
		table.sort(Terms, function(Left: string, Right: string): boolean
			if #Left ~= #Right then
				return #Left > #Right
			end
			return Left < Right
		end)
		self.Config.NoTranslateList = Terms
	end

	function LocalizationEngine:GetNoTranslateKey(): string
		return table.concat(self.Config.NoTranslateList, "\n") .. "\n" .. self.SourceSignature
	end

	function LocalizationEngine:HasProtectedTerm(Text: string): boolean
		for _, Term in ipairs(self.Config.NoTranslateList) do
			if Text:find(Term, 1, true) then
				return true
			end
		end
		return false
	end

	function LocalizationEngine:MaskProtected(Text: string, Make: (string) -> string): string
		for _, Term in ipairs(self.Config.NoTranslateList) do
			local Pieces, Cursor = {}, 1
			while true do
				local First, Last = Text:find(Term, Cursor, true)
				if not First then
					break
				end
				table.insert(Pieces, Text:sub(Cursor, First - 1))
				table.insert(Pieces, Make(Term))
				Cursor = Last + 1
			end
			if Cursor > 1 then
				table.insert(Pieces, Text:sub(Cursor))
				Text = table.concat(Pieces)
			end
		end
		return Text
	end

	function LocalizationEngine:Templatize(Source: any): (any, { string }?)
		if type(Source) ~= "string" or not Source:find("%d") then
			return Source, nil
		end
		if Source:find("{n%d+}") or not Source:match("[%a\128-\255]") then
			return Source, nil
		end
		local Numbers: { string } = {}
		local Template = Source:gsub("%d[%d%.,]*", function(Match: string): string
			local Core = Match:match("^(.-)[%.,]*$")
			local Tail = Match:sub(#Core + 1)
			Numbers[#Numbers + 1] = Core
			return "{n" .. #Numbers .. "}" .. Tail
		end)
		return Template, Numbers
	end

	function LocalizationEngine:FillNumbers(Text: string, Numbers: { string }): string
		return (Text:gsub("{n(%d+)}", function(IndexText: string): string
			return Numbers[tonumber(IndexText)]
		end))
	end

	function LocalizationEngine:Lookup(Source: string, Language: string): (string, boolean)
		if self.Config.NoTranslate[Source] then
			return Source, true
		end
		local Entries = self.Config.Translations[Language]
		if type(Entries) == "table" and type(Entries[Source]) == "string" then
			return Entries[Source], true
		end
		if Language == self.Config.SourceLanguage or not Source:match("[%a\128-\255]") then
			return Source, true
		end
		if self.Config.AutoTranslate then
			local Cache = self.Cache[Language]
			local Key, Numbers = self:Templatize(Source)
			local Cached = Cache and Cache[Key]
			if type(Cached) == "string" then
				return Numbers and self:FillNumbers(Cached, Numbers) or Cached, true
			end
		end
		return self:GetFallback(Source), false
	end

	function LocalizationEngine:NeedsTranslation(Source: string, Language: string): boolean
		if not self.Active or not self.Config.AutoTranslate or Source == "" then
			return false
		end
		if self.MissingSources[Source] or not Source:match("[%a\128-\255]") then
			return false
		end
		local _, Found = self:Lookup(Source, Language)
		if Found then
			return false
		end
		local FailedSources = self.Failed[Language]
		return not (FailedSources and FailedSources[Source] and FailedSources[Source] > os.clock())
	end

	function LocalizationEngine:Resolve(Record: TextRecord, Language: string): string
		if not self.Active or self:IsIgnored(Record) then
			return Record.Source
		end
		if Record.Key then
			local Keyed = self.Config.Translations[Language]
			if type(Keyed) == "table" and type(Keyed[Record.Key]) == "string" then
				return Keyed[Record.Key]
			end
		end
		return (self:Lookup(Record.Source, Language))
	end

	function LocalizationEngine:WriteRecord(Record: TextRecord, Value: string)
		Record.Expected = Value
		if Value ~= Record.Source then
			Record.Produced = Record.Produced or {}
			Record.Produced[Value] = true
		end
		local Object = Record.Object
		if Object.Parent ~= nil and Object[Record.Property] ~= Value then
			Object[Record.Property] = Value
		end
	end

	function LocalizationEngine:ApplyRecord(Record: TextRecord)
		if self.Dead then
			return
		end
		self:WriteRecord(Record, self:Resolve(Record, self.DisplayLanguage))
	end

	function LocalizationEngine:CommitPass()
		local Language = self.DisplayLanguage
		local Slice = CreateSlicer(self.Config.FrameBudget)
		local function IsStale(): boolean
			return self.Dead or self.DisplayLanguage ~= Language
		end

		local List: { TextRecord } = {}
		for _, Properties in pairs(self.Records) do
			for _, Record in pairs(Properties) do
				table.insert(List, Record)
			end
		end

		local Memo = {}
		local Shown: { TextRecord }, Hidden: { TextRecord } = {}, {}
		for Index = 1, #List do
			local Record = List[Index]
			if IsObjectShown(Record.Object, Memo) then
				table.insert(Shown, Record)
			else
				table.insert(Hidden, Record)
			end
			if Slice() and IsStale() then
				return
			end
		end
		for _, Group in ipairs({ Shown, Hidden }) do
			for Index = 1, #Group do
				local Record = Group[Index]
				local Properties = self.Records[Record.Object]
				if Properties and Properties[Record.Property] == Record then
					self:ApplyRecord(Record)
				end
				if Slice() and IsStale() then
					return
				end
			end
		end
	end

	function LocalizationEngine:Commit()
		if self.Dead then
			return
		end
		if self.Committing then
			self.CommitAgain = true
			return
		end
		self.Committing = true
		task.spawn(function()
			local Success, Problem = pcall(function()
				repeat
					self.CommitAgain = false
					self:CommitPass()
				until not self.CommitAgain or self.Dead
			end)
			self.Committing = false
			if not Success then
				self:ReportError(Problem)
			end
		end)
	end

	function LocalizationEngine:CommitSoon()
		if self.CommitQueued or self.Dead then
			return
		end
		self.CommitQueued = true
		task.delay(0.1, function()
			self.CommitQueued = false
			self:Commit()
		end)
	end

	function LocalizationEngine:ReleaseHold()
		if not self.Held then
			return
		end
		self.Held = false
		self.HoldToken += 1
		self.DisplayLanguage = self.CurrentLanguage
		self:Commit()
	end

	function LocalizationEngine:Hold()
		self.Held = true
		self.HoldToken += 1
		local Token = self.HoldToken
		task.delay(self.Config.SwapTimeout, function()
			if self.HoldToken == Token and self.Held then
				self:ReleaseHold()
			end
		end)
		self:Schedule(0)
	end

	function LocalizationEngine:ParseSource(Raw: any): (string, string?)
		if type(Raw) ~= "string" then
			return tostring(Raw or ""), nil
		end
		local Prefix = self.Prefix
		if Raw:sub(1, #Prefix) == Prefix then
			local Key = Raw:sub(#Prefix + 1)
			local Defaults = self.Config.Translations[self.SourceLanguage] or {}
			if type(Defaults[Key]) ~= "string" then
				local Fallback = "[" .. Key .. "]"
				self.MissingSources[Fallback] = true
				return Fallback, Key
			end
			return Defaults[Key], Key
		end
		return Raw, nil
	end

	function LocalizationEngine:Untrack(Object: any)
		local Properties = self.Records[Object]
		if not Properties then
			return
		end
		self.Records[Object] = nil
		for _, Record in pairs(Properties) do
			for _, Connection in ipairs(Record.Connections) do
				Connection:Disconnect()
			end
		end
	end

	function LocalizationEngine:Track(Object: any)
		if self.Dead or self.Records[Object] or not self.Config then
			return
		end
		if not IsTextObject(Object) or self:IsMarqueeMirror(Object) then
			return
		end
		local Properties = {}
		self.Records[Object] = Properties
		local Property = Object:IsA("TextBox") and "PlaceholderText" or "Text"
		local Source, Key = self:ParseSource(Object[Property])
		local Record: TextRecord = {
			Object = Object,
			Property = Property,
			Source = Source,
			Key = Key,
			Connections = {},
		}
		Properties[Property] = Record
		self:ApplyRecord(Record)

		table.insert(Record.Connections, Object:GetPropertyChangedSignal(Property):Connect(function()
			local Current = Object[Property]
			if Current == Record.Expected then
				return
			end
			if Record.Produced and Record.Produced[Current] and Current ~= Record.Source then
				self:ApplyRecord(Record)
				return
			end
			Record.Source, Record.Key = self:ParseSource(Current)
			self:ApplyRecord(Record)
			self:Schedule()
			self:ScheduleSave()
		end))
		table.insert(Record.Connections, Object:GetAttributeChangedSignal("ModulesNoTranslate"):Connect(function()
			self:ApplyRecord(Record)
		end))
		table.insert(Record.Connections, Object.Destroying:Connect(function()
			self:Untrack(Object)
		end))
		self:Schedule()
	end

	function LocalizationEngine:CollectSources(Slice: Slicer?): ({ string }, { [string]: boolean })
		local Result: { string }, Seen: { [string]: boolean } = {}, {}
		for _, Properties in pairs(self.Records) do
			for _, Record in pairs(Properties) do
				if not self:IsIgnored(Record) then
					local Template = self:Templatize(Record.Source)
					if not Seen[Template] then
						Seen[Template] = true
						Result[#Result + 1] = Template
					end
				end
				if Slice then
					Slice()
				end
			end
		end
		table.sort(Result)
		return Result, Seen
	end

	function LocalizationEngine:ReadCacheFile(): string?
		if not self.Config.Cache or type(readfile) ~= "function" then
			return nil
		end
		local Success, Content = pcall(readfile, self.Config.CacheFile)
		if not Success then
			return nil
		end
		local Decoded, Data = pcall(function()
			return HttpService:JSONDecode(Content)
		end)
		if not Decoded or type(Data) ~= "table" or Data.Version ~= 1
			or Data.SourceLanguage ~= self.Config.SourceLanguage
			or Data.SourceSignature ~= self.SourceSignature then
			return nil
		end
		local StaleTerms = Data.NoTranslateKey ~= self:GetNoTranslateKey()
		if type(Data.Translations) == "table" then
			for Code, Entries in pairs(Data.Translations) do
				local Normalized = self:NormalizeCode(Code)
				if Normalized and Normalized ~= self.Config.SourceLanguage and type(Entries) == "table" then
					self.Cache[Normalized] = self.Cache[Normalized] or {}
					for Source, Value in pairs(Entries) do
						if type(Source) == "string" and type(Value) == "string" and not (StaleTerms and self:HasProtectedTerm(Source)) then
							self.Cache[Normalized][Source] = Value
						end
					end
				end
			end
		end
		return self:NormalizeCode(Data.SelectedLanguage)
	end

	function LocalizationEngine:SaveCache(): boolean
		if not self.Active or not self.Config.Cache or type(writefile) ~= "function" then
			return false
		end
		local Success, Problem = pcall(function()
			local Folder = self.Config.CacheFile:match("^(.*)/[^/]+$")
			if Folder and type(makefolder) == "function" then
				local Path = ""
				for Piece in Folder:gmatch("[^/]+") do
					Path = Path == "" and Piece or Path .. "/" .. Piece
					if type(isfolder) ~= "function" or not isfolder(Path) then
						pcall(makefolder, Path)
					end
				end
			end
			local _, Live = self:CollectSources()
			if self.Config.AutoPruneCache then
				for _, Entries in pairs(self.Cache) do
					for Source in pairs(Entries) do
						if not Live[Source] then
							Entries[Source] = nil
						end
					end
				end
			end
			writefile(self.Config.CacheFile, HttpService:JSONEncode({
				Version = 1,
				SourceLanguage = self.Config.SourceLanguage,
				SourceSignature = self.SourceSignature,
				NoTranslateKey = self:GetNoTranslateKey(),
				SelectedLanguage = self.Config.SaveSelection and self.CurrentLanguage or nil,
				Translations = self.Cache,
			}))
		end)
		if not Success then
			self:ReportError("Cannot save cache: " .. tostring(Problem))
		end
		return Success
	end

	function LocalizationEngine:ScheduleSave()
		if not self.Active or self.Dead then
			return
		end
		self.SaveDirtyAt = os.clock()
		if self.SaveScheduled then
			return
		end
		self.SaveScheduled = true
		local function Attempt()
			if self.Dead then
				self.SaveScheduled = false
				return
			end
			if self.Held or self.Committing or os.clock() - self.SaveDirtyAt < self.Config.SaveDelay then
				task.delay(0.5, Attempt)
				return
			end
			self.SaveScheduled = false
			self:SaveCache()
		end
		task.delay(self.Config.SaveDelay, Attempt)
	end

	function LocalizationEngine:SendHttpRequest(Url: string): any
		if type(self.Config.Request) == "function" then
			return self.Config.Request({ Url = Url, Method = "GET", Timeout = 15 })
		end
		local Hosts = {
			"https://translate.googleapis.com/translate_a/single",
			"https://clients5.google.com/translate_a/single",
			"https://translate.google.com/translate_a/single",
		}
		if self.GoodHostIndex > 1 then
			table.insert(Hosts, 1, table.remove(Hosts, self.GoodHostIndex))
		end
		local HostIndexes = { ["translate.googleapis.com"] = 1, ["clients5.google.com"] = 2, ["translate.google.com"] = 3 }
		local Query = Url:match("%?(.*)$") or ""
		local Sender = request or http_request or (syn and syn.request) or (http and http.request)
		local Problems: { string } = {}
		for _, Host in ipairs(Hosts) do
			local Target = Host .. "?" .. Query
			if Host:find("clients5", 1, true) then
				Target = Target:gsub("client=gtx", "client=dict-chrome-ex")
			end
			local HostName = Host:match("//([^/]+)") or Host
			local function ViaRequest(): (string?, string?)
				local Success, Response = pcall(Sender, { Url = Target, Method = "GET", Timeout = 15 })
				local Status = Success and type(Response) == "table" and tonumber(Response.StatusCode or Response.Status) or 0
				if Success and type(Response) == "table" and Status >= 200 and Status < 300 and type(Response.Body) == "string" and Response.Body:sub(1, 1) == "[" then
					return Response.Body
				end
				return nil, HostName .. " request: " .. (if Success then "HTTP " .. Status else tostring(Response):sub(1, 60))
			end
			local function ViaHttpGet(): (string?, string?)
				local Success, Body = pcall(function()
					return game:HttpGet(Target)
				end)
				if Success and type(Body) == "string" and Body:sub(1, 1) == "[" then
					return Body
				end
				return nil, HostName .. " HttpGet: " .. (if Success then "bad body" else tostring(Body):sub(1, 60))
			end
			local Attempts = if type(Sender) == "function" then { ViaRequest, ViaHttpGet } else { ViaHttpGet }
			for _, Attempt in ipairs(Attempts) do
				local Body, Problem = Attempt()
				if Body then
					self.GoodHostIndex = HostIndexes[HostName] or self.GoodHostIndex
					return Body
				end
				table.insert(Problems, Problem or "unknown")
			end
		end
		error("All endpoints failed -> " .. table.concat(Problems, " | "))
	end

	function LocalizationEngine:ProtectText(Source: string): (string?, { string }?)
		if Source:find("ZXQ", 1, true) then
			return nil, nil
		end
		local Tags: { string } = {}
		local function Hold(Term: string): string
			table.insert(Tags, Term)
			return string.format("ZXQT%04dQXZ", #Tags)
		end
		local Text = Source:gsub("<[^>]+>", Hold)
		for _, Pattern in ipairs({ "%%[%d%.%+%-]*[cdiouxXeEfgGqs]", "{[%w_%.]+}", "rbxassetid://%d+", "https?://[^%s<>]+" }) do
			Text = Text:gsub(Pattern, Hold)
		end
		Text = self:MaskProtected(Text, Hold)
		return Text, Tags
	end

	function LocalizationEngine:RestoreText(Value: string, Tags: { string }): string?
		local Seen, Invalid = {}, false
		Value = Value:gsub("ZXQT(%d+)QXZ", function(IndexText: string): string
			local Position = tonumber(IndexText)
			if not Tags[Position] or Seen[Position] then
				Invalid = true
				return ""
			end
			Seen[Position] = true
			return Tags[Position]
		end)
		for Position in ipairs(Tags) do
			if not Seen[Position] then
				return nil
			end
		end
		if Invalid or Value:find("ZXQ", 1, true) then
			return nil
		end
		return Value
	end

	function LocalizationEngine:BuildPayload(Items: { BatchItem }): string
		local Pieces: { string } = {}
		for Index, Item in ipairs(Items) do
			table.insert(Pieces, string.format("ZXQB%06dQXZ\n%s\n", Index, Item.Text))
		end
		table.insert(Pieces, "ZXQENDQXZ")
		return table.concat(Pieces)
	end

	function LocalizationEngine:BuildQueryUrl(Query: string, Language: string): string
		return "https://translate.googleapis.com/translate_a/single?client=gtx&dt=t&ie=UTF-8&oe=UTF-8&sl="
			.. HttpService:UrlEncode(GoogleLanguageCodes[self.Config.SourceLanguage] or self.Config.SourceLanguage)
			.. "&tl=" .. HttpService:UrlEncode(GoogleLanguageCodes[Language] or Language)
			.. "&q=" .. HttpService:UrlEncode(Query)
	end

	function LocalizationEngine:BuildUrl(Items: { BatchItem }, Language: string): string
		return self:BuildQueryUrl(self:BuildPayload(Items), Language)
	end

	function LocalizationEngine:DecodeResponse(Body: string, Items: { BatchItem }): { string }
		local Data = HttpService:JSONDecode(Body)
		if type(Data) ~= "table" or type(Data[1]) ~= "table" then
			error("Unexpected Google JSON response")
		end
		local Pieces: { string } = {}
		for _, Segment in ipairs(Data[1]) do
			if type(Segment) == "table" and type(Segment[1]) == "string" then
				table.insert(Pieces, Segment[1])
			end
		end
		local Output, Starts, Ends, Cursor = table.concat(Pieces), {}, {}, 1
		for Index in ipairs(Items) do
			local Marker = string.format("ZXQB%06dQXZ", Index)
			local First, Last = Output:find(Marker, Cursor, true)
			if not First or Output:find(Marker, Last + 1, true) then
				error("Batch marker missing or duplicated; source text retained")
			end
			if Index == 1 and Output:sub(1, First - 1):match("%S") then
				error("Unexpected batch prefix")
			end
			Starts[Index], Ends[Index], Cursor = First, Last, Last + 1
		end
		local Finish, FinishEnd = Output:find("ZXQENDQXZ", Cursor, true)
		if not Finish or Output:sub(FinishEnd + 1):match("%S") then
			error("Batch end marker missing or invalid")
		end
		local Translated: { string } = {}
		for Index, Item in ipairs(Items) do
			local Value = Output:sub(Ends[Index] + 1, (Starts[Index + 1] or Finish) - 1)
			Value = Value:match("^%s*(.-)%s*$")
			Value = self:RestoreText(Value, Item.Tags)
			if not Value or (Value == "" and Item.Source:match("%S")) then
				error("Invalid protected text; source text retained")
			end
			Translated[Index] = (Item.Source:match("^%s*") or "") .. Value .. (Item.Source:match("%s*$") or "")
		end
		return Translated
	end

	function LocalizationEngine:IsFormatError(Reason: any): boolean
		Reason = tostring(Reason)
		return Reason:find("Batch ", 1, true) ~= nil or Reason:find("Invalid protected", 1, true) ~= nil
			or Reason:find("Unexpected", 1, true) ~= nil or Reason:find("Empty translation", 1, true) ~= nil
	end

	function LocalizationEngine:PaceRequest()
		local Now = os.clock()
		local Slot = math.max(Now, self.NextSlot)
		self.NextSlot = Slot + self.Config.RequestInterval
		if Slot > Now then
			task.wait(Slot - Now)
		end
	end

	function LocalizationEngine:IsCancelled(Epoch: number, Language: string): boolean
		return self.Dead or self.Epoch ~= Epoch or self.CurrentLanguage ~= Language
	end

	function LocalizationEngine:SendBatchRequest(Items: { BatchItem }, Language: string, Epoch: number): ({ string }?, string?)
		local Url = self:BuildUrl(Items, Language)
		local Reason = "Translation failed"
		for Attempt = 0, self.Config.MaxRetries do
			if self:IsCancelled(Epoch, Language) then
				return nil, "cancelled"
			end
			self:PaceRequest()
			if self:IsCancelled(Epoch, Language) then
				return nil, "cancelled"
			end
			local RetryAfter
			local Success, Result = pcall(function()
				local Response = self:SendHttpRequest(Url)
				if type(Response) == "string" then
					return self:DecodeResponse(Response, Items)
				end
				if type(Response) ~= "table" then
					error("Invalid HTTP response")
				end
				local Status = tonumber(Response.StatusCode or Response.Status) or 0
				local Headers = Response.Headers or {}
				RetryAfter = tonumber(Headers["Retry-After"] or Headers["retry-after"])
				if Status < 200 or Status >= 300 or Response.Success == false then
					error("HTTP " .. tostring(Status))
				end
				return self:DecodeResponse(Response.Body or "", Items)
			end)
			if Success then
				return Result
			end
			Reason = tostring(Result)
			if self:IsFormatError(Reason) then
				return nil, Reason
			end
			if Attempt < self.Config.MaxRetries then
				task.wait(math.min(30, RetryAfter or (2 ^ (Attempt + 1))))
			end
		end
		return nil, Reason
	end

	function LocalizationEngine:SendSingleRequest(Item: BatchItem, Language: string, Epoch: number): (string?, string?)
		if #Item.Tags > 0 then
			return nil, "Protected tags; source retained"
		end
		if self:IsCancelled(Epoch, Language) then
			return nil, "cancelled"
		end
		self:PaceRequest()
		local Url = self:BuildQueryUrl(Item.Text, Language)
		local Success, Result = pcall(function()
			local Response = self:SendHttpRequest(Url)
			local Body = type(Response) == "string" and Response or (type(Response) == "table" and Response.Body) or ""
			local Data = HttpService:JSONDecode(Body)
			if type(Data) ~= "table" or type(Data[1]) ~= "table" then
				error("Unexpected Google JSON response")
			end
			local Pieces: { string } = {}
			for _, Segment in ipairs(Data[1]) do
				if type(Segment) == "table" and type(Segment[1]) == "string" then
					table.insert(Pieces, Segment[1])
				end
			end
			local Value = table.concat(Pieces):match("^%s*(.-)%s*$")
			if Value == "" or Value:find("ZXQ", 1, true) then
				error("Empty translation")
			end
			return (Item.Source:match("^%s*") or "") .. Value .. (Item.Source:match("%s*$") or "")
		end)
		if Success then
			return Result
		end
		return nil, tostring(Result)
	end

	function LocalizationEngine:SendBatchWithFallback(Items: { BatchItem }, Language: string, Epoch: number): ({ string }?, string?)
		local Result, Reason = self:SendBatchRequest(Items, Language, Epoch)
		if Result then
			return Result
		end
		if Reason == "cancelled" or not self:IsFormatError(Reason) then
			return nil, Reason
		end
		if #Items == 1 then
			local Value, Problem = self:SendSingleRequest(Items[1], Language, Epoch)
			if Value then
				return { Value }
			end
			return nil, Problem
		end
		local Middle = math.floor(#Items / 2)
		local Left: { BatchItem }, Right: { BatchItem } = {}, {}
		for Index, Item in ipairs(Items) do
			table.insert(Index <= Middle and Left or Right, Item)
		end
		local LeftResult, LeftReason = self:SendBatchWithFallback(Left, Language, Epoch)
		if LeftReason == "cancelled" then
			return nil, LeftReason
		end
		local RightResult, RightReason = self:SendBatchWithFallback(Right, Language, Epoch)
		if RightReason == "cancelled" then
			return nil, RightReason
		end
		if not LeftResult and not RightResult then
			return nil, LeftReason or RightReason
		end
		local Merged: { string } = {}
		for Index = 1, #Left do
			Merged[Index] = LeftResult and LeftResult[Index] or nil
		end
		for Index = 1, #Right do
			Merged[Middle + Index] = RightResult and RightResult[Index] or nil
		end
		return Merged, LeftReason or RightReason
	end

	function LocalizationEngine:ShowToast(Kind: string, Language: string)
		if self.Dead or not self.Config.Notifications then
			return
		end
		local Code = Language:match("^[a-z]+") or Language
		local CustomMessages = self.Config.Messages
		local function PickMessage(Field: string): string
			local Entry = type(CustomMessages) == "table" and (CustomMessages[Language] or CustomMessages[Code]) or nil
			if type(Entry) == "table" and type(Entry[Field]) == "string" then
				return Entry[Field]
			end
			local Defaults = DefaultMessages[Code] or DefaultMessages.en
			return Defaults[Field] or DefaultMessages.en[Field]
		end
		local ToastTypes = { Start = "Info", Done = "Success", Fail = "Warning" }
		local Success, Notification = pcall(function()
			return Library:Notify({
				Title = PickMessage("Title"),
				Content = string.format(PickMessage(Kind), Language:upper()),
				Duration = Kind == "Fail" and 6 or 4,
				Type = ToastTypes[Kind],
			})
		end)
		if Success and type(Notification) == "table" then
			for _, Field in ipairs({ "Title", "ContentLabel", "SubContentLabel" }) do
				local Object = Notification[Field]
				if typeof(Object) == "Instance" then
					pcall(Object.SetAttribute, Object, "ModulesNoTranslate", true)
				end
			end
		end
	end

	function LocalizationEngine:ScheduleRetry()
		if self.Dead or self.RetryScheduled then
			return
		end
		self.FailCount += 1
		if self.FailCount > 6 then
			return
		end
		self.RetryScheduled = true
		task.delay(self.Config.RetryCooldown + 1, function()
			self.RetryScheduled = false
			if not self.Dead then
				self:Schedule()
			end
		end)
	end

	function LocalizationEngine:BuildBatches(Sources: { string }, Language: string, Epoch: number): ({ { BatchItem } }, boolean)
		local Slice = CreateSlicer(self.Config.FrameBudget)
		local Batches: { { BatchItem } }, Batch: { BatchItem } = {}, {}
		local BaseLength = #self:BuildUrl({}, Language)
		local MarkerLength = #HttpService:UrlEncode(string.format("ZXQB%06dQXZ\n", 1)) + #HttpService:UrlEncode("\n")
		local Used = BaseLength
		local Limit, MaxItems = self.Config.MaxURLLength, self.Config.BatchSize
		self.Failed[Language] = self.Failed[Language] or {}
		for _, Source in ipairs(Sources) do
			if Slice() and self:IsCancelled(Epoch, Language) then
				return {}, true
			end
			if self:NeedsTranslation(Source, Language) then
				local Text, Tags = self:ProtectText(Source)
				if Text then
					local Size = MarkerLength + #HttpService:UrlEncode(Text)
					if BaseLength + Size > Limit then
						self.Failed[Language][Source] = os.clock() + self.Config.RetryCooldown
						self:ReportError("Text exceeds batch URL limit; supply a manual translation or shorten it")
					else
						if #Batch > 0 and (Used + Size > Limit or #Batch >= MaxItems) then
							table.insert(Batches, Batch)
							Batch, Used = {}, BaseLength
						end
						table.insert(Batch, { Source = Source, Text = Text, Tags = Tags })
						Used += Size
					end
				else
					self.Failed[Language][Source] = os.clock() + self.Config.RetryCooldown
					self:ReportError("Source contains reserved ZXQ markers; supply a manual translation")
				end
			end
		end
		if #Batch > 0 then
			table.insert(Batches, Batch)
		end
		return Batches, false
	end

	function LocalizationEngine:HandleResult(Batch: { BatchItem }, Result: { string }?, Reason: string?, Language: string, Epoch: number, Sources: { string }): string?
		if self.Dead or Epoch ~= self.Epoch then
			return nil
		end
		self.Failed[Language] = self.Failed[Language] or {}
		if Result then
			self.Cache[Language] = self.Cache[Language] or {}
			local Missing = false
			for Index, Item in ipairs(Batch) do
				if type(Result[Index]) == "string" then
					self.Cache[Language][Item.Source] = Result[Index]
				else
					Missing = true
					self.Failed[Language][Item.Source] = os.clock() + self.Config.RetryCooldown
				end
			end
			if not self.Held then
				self:CommitSoon()
			end
			self:ScheduleSave()
			if Missing then
				self:ScheduleRetry()
			else
				self.FailCount = 0
			end
		elseif Reason ~= "cancelled" and self.CurrentLanguage == Language then
			if self:IsFormatError(Reason) then
				for _, Item in ipairs(Batch) do
					self.Failed[Language][Item.Source] = os.clock() + self.Config.RetryCooldown
				end
				self:ReportError(Reason)
				self:ScheduleRetry()
			else
				for _, Source in ipairs(Sources) do
					self.Failed[Language][Source] = os.clock() + self.Config.RetryCooldown
				end
				self:ReportError(Reason)
				self:ScheduleRetry()
				if self.ToastFailLanguage ~= Language then
					self.ToastFailLanguage = Language
					self:ShowToast("Fail", Language)
				end
				return "net"
			end
		end
		return nil
	end

	function LocalizationEngine:RunBatches(Batches: { { BatchItem } }, Language: string, Epoch: number, Sources: { string }): boolean
		local NextIndex, Running, Stop = 1, 0, false
		local Workers = math.max(1, math.min(self.Config.Concurrency, #Batches))
		for _ = 1, Workers do
			Running += 1
			task.spawn(function()
				while not Stop and not self.Dead and Epoch == self.Epoch do
					local Index = NextIndex
					if Index > #Batches then
						break
					end
					NextIndex = Index + 1
					local Batch = Batches[Index]
					local Success, Result, Reason = pcall(function()
						return self:SendBatchWithFallback(Batch, Language, Epoch)
					end)
					if not Success then
						Result, Reason = nil, tostring(Result)
					end
					local Handled, Flag = pcall(self.HandleResult, self, Batch, Result, Reason, Language, Epoch, Sources)
					if not Handled then
						self:ReportError(Flag)
					end
					if Flag == "net" then
						Stop = true
					end
				end
				Running -= 1
			end)
		end
		while Running > 0 do
			task.wait()
		end
		return Stop
	end

	function LocalizationEngine:RunWorker()
		while self.Active and not self.Dead and self.Config.AutoTranslate do
			local Epoch, Language = self.Epoch, self.CurrentLanguage
			local Sources = self:CollectSources(CreateSlicer(self.Config.FrameBudget))
			local Batches, Stale = {}, true
			if not self:IsCancelled(Epoch, Language) then
				Batches, Stale = self:BuildBatches(Sources, Language, Epoch)
			end
			if not Stale then
				if #Batches == 0 then
					self:ReleaseHold()
					if self.ToastDoneLanguage ~= Language and not self.Pending and not self.Dead then
						self.ToastStartLanguage, self.ToastDoneLanguage, self.ToastFailLanguage = Language, Language, nil
						if Language ~= self.Config.SourceLanguage then
							self:ShowToast("Done", Language)
						end
					end
					break
				end
				if Language ~= self.Config.SourceLanguage and self.ToastStartLanguage ~= Language then
					self.ToastStartLanguage, self.ToastDoneLanguage, self.ToastFailLanguage = Language, nil, nil
					self:ShowToast("Start", Language)
				end
				local NetworkFailed = self:RunBatches(Batches, Language, Epoch, Sources)
				if self.Dead or NetworkFailed then
					self:ReleaseHold()
					break
				end
			end
		end
	end

	function LocalizationEngine:Schedule(Delay: number?)
		if self.Dead or not self.Active or not self.Config.AutoTranslate or self.Scheduled then
			return
		end
		self.Scheduled = true
		task.delay(Delay or self.Config.Debounce, function()
			self.Scheduled = false
			if self.Dead then
				return
			end
			if self.Busy then
				self.Pending = true
				return
			end
			self.Busy = true
			local Success, Problem = pcall(function()
				self:RunWorker()
			end)
			self.Busy = false
			if not Success then
				self:ReportError(Problem)
			end
			if self.Pending then
				self.Pending = false
				self:Schedule()
			else
				self:ReleaseHold()
			end
		end)
	end

	function LocalizationEngine:IsAvailable(Code: string): boolean
		if self.Config.AutoTranslate then
			return true
		end
		return Code == self.Config.DefaultLanguage or type(self.Config.Translations[Code]) == "table"
	end

	function LocalizationEngine:NotifyListeners(Previous: string)
		for Listener in pairs(self.Listeners) do
			local Success, Problem = pcall(Listener, self.CurrentLanguage, Previous)
			if not Success then
				self:ReportError(Problem)
			end
		end
		self:SyncDropdowns()
	end

	function LocalizationEngine:OnChanged(Callback: (string, string) -> ())
		assert(type(Callback) == "function", "OnChanged expects a function")
		self.Listeners[Callback] = true
		return {
			Disconnect = function()
				LocalizationEngine.Listeners[Callback] = nil
			end,
		}
	end

	function LocalizationEngine:SwitchDisplay(Code: string)
		local SourceLanguage = self.Config.SourceLanguage
		if self.Config.AutoTranslate and self.Config.SyncSwap and Code ~= SourceLanguage and Code ~= self.DisplayLanguage then
			self:Hold()
		else
			self.Held = false
			self.HoldToken += 1
			self.DisplayLanguage = Code
			self:Commit()
			self:Schedule()
		end
	end

	function LocalizationEngine:SetLanguage(Code: any): (boolean, string?)
		if self.Dead then
			return false, "Language manager was destroyed"
		end
		if not self.Active then
			return false, "Call Localization first"
		end
		local Normalized = self:NormalizeCode(Code)
		if not Normalized then
			return false, "Invalid language code"
		end
		if not self.Config.Enabled and Normalized ~= self.Config.DefaultLanguage then
			return false, "Language switching is disabled"
		end
		if not self:IsAvailable(Normalized) then
			return false, "No dictionary for this language"
		end
		local Previous = self.CurrentLanguage
		self.Epoch += 1
		self.CurrentLanguage = Normalized
		self.FailCount = 0
		self.ToastStartLanguage, self.ToastDoneLanguage, self.ToastFailLanguage = nil, nil, nil
		self:SwitchDisplay(Normalized)
		self:ScheduleSave()
		if Previous ~= Normalized then
			self:NotifyListeners(Previous)
		end
		return true
	end

	function LocalizationEngine:GetLanguage(): string
		return self.CurrentLanguage
	end

	function LocalizationEngine:Refresh(RetryFailed: boolean?): boolean
		if self.Dead then
			return false
		end
		if RetryFailed then
			self.Failed = {}
			self.FailCount = 0
		end
		self:Commit()
		self:SyncDropdowns()
		self:Schedule()
		self:ScheduleSave()
		return true
	end

	function LocalizationEngine:SetTranslations(Language: any, Entries: { [any]: any }, Replace: boolean?): boolean
		local Normalized = self:NormalizeCode(Language)
		assert(Normalized and type(Entries) == "table", "Expected language code and dictionary")
		local Target = Replace and {} or (self.Config.Translations[Normalized] or {})
		Entries = self:SplitDictionary(Entries, self.Config.NoTranslate)
		for Source, Value in pairs(Entries) do
			assert(type(Source) == "string" and (type(Value) == "string" or Value == false), "Translations map strings to strings (false removes)")
			Target[Source] = Value ~= false and Value or nil
		end
		self.Config.Translations[Normalized] = Target
		self:BuildTerms()
		return self:Refresh()
	end

	function LocalizationEngine:ClearCache(Language: any?)
		if Language then
			local Normalized = self:NormalizeCode(Language)
			assert(Normalized, "Invalid language code")
			self.Cache[Normalized], self.Failed[Normalized] = nil, nil
		else
			self.Cache, self.Failed = {}, {}
		end
		self.Epoch += 1
		self:Refresh()
	end

	function LocalizationEngine:GetOriginalText(Object: any, Property: string?): string
		local Properties = self.Records[Object]
		local Record = Properties and Properties[Property or "Text"]
		return Record and Record.Source or Object[Property or "Text"]
	end

	function LocalizationEngine:SetOriginalText(Object: any, Source: string)
		assert(type(Source) == "string", "Original text must be a string")
		local Properties = self.Records[Object]
		if not Properties then
			Object.Text = Source
			return
		end
		for _, Record in pairs(Properties) do
			Record.Source, Record.Key = self:ParseSource(Source)
			self:ApplyRecord(Record)
		end
		self:Schedule()
		self:ScheduleSave()
	end

	function LocalizationEngine:SyncDropdowns()
		for Dropdown, Entry in pairs(self.Dropdowns) do
			Entry.Syncing = true
			local Value = Entry.Labels[self.CurrentLanguage] or self.CurrentLanguage
			local Success, Problem = pcall(Dropdown.SetValue, Dropdown, Value)
			if not Success then
				self:ReportError("Dropdown synchronization: " .. tostring(Problem))
			end
			Entry.Syncing = false
		end
	end

	function LocalizationEngine:Configure(Options: any)
		assert(not self.Dead, "Language manager was destroyed")
		Options = Options or {}
		local DefaultLanguage = assert(self:NormalizeCode(Options.DefaultLanguage or "en"), "Invalid DefaultLanguage")
		local SourceLanguage = assert(self:NormalizeCode(Options.SourceLanguage or DefaultLanguage), "Invalid SourceLanguage")
		local Translations, NoTranslate = {}, {}
		for Code, Entries in pairs(Options.Translations or {}) do
			if type(Code) == "string" and NoTranslateKeys[(Code:lower():gsub("[%s_%-]", ""))] then
				if type(Entries) == "table" then
					for _, Item in pairs(Entries) do
						if type(Item) == "string" then
							NoTranslate[Item] = true
						end
					end
				end
			else
				local Normalized = self:NormalizeCode(Code)
				assert(Normalized and type(Entries) == "table", "Translations must contain language tables")
				Translations[Normalized] = self:SplitDictionary(Entries, NoTranslate)
			end
		end
		for _, Item in ipairs(type(Options.NoTranslations) == "table" and Options.NoTranslations or {}) do
			if type(Item) == "string" then
				NoTranslate[Item] = true
			end
		end

		local Signature: { string } = {}
		for Key, Value in pairs(Translations[SourceLanguage] or {}) do
			if type(Value) == "string" then
				Signature[#Signature + 1] = Key .. "=" .. Value
			end
		end
		table.sort(Signature)
		local NewSignature = table.concat(Signature, "\n")
		local FirstConfigure = self.Config == nil
		local OldSource = self.Config and self.Config.SourceLanguage
		local OldFile = self.Config and self.Config.CacheFile
		if not FirstConfigure and self.SourceSignature ~= NewSignature then
			self.Cache = {}
		end
		self.SourceSignature = NewSignature

		self.Config = {
			Enabled = Options.Enabled ~= false,
			AutoTranslate = Options.AutoTranslate == true or Options.AutoTranslations == true,
			DefaultLanguage = DefaultLanguage,
			SourceLanguage = SourceLanguage,
			Translations = Translations,
			NoTranslate = NoTranslate,
			Languages = Options.Languages,
			Cache = Options.Cache ~= false,
			CacheFile = assert(Options.CacheFile, "CacheFile is set by the Install adapter"),
			SaveSelection = Options.SaveSelection ~= false,
			AutoPruneCache = Options.AutoPruneCache == true,
			Debounce = math.max(0.05, tonumber(Options.Debounce) or 0.2),
			BatchSize = math.max(1, math.floor(tonumber(Options.BatchSize) or 40)),
			MaxURLLength = math.max(512, math.min(16000, tonumber(Options.MaxURLLength) or 8000)),
			Concurrency = math.max(1, math.min(8, math.floor(tonumber(Options.Concurrency) or 2))),
			RequestInterval = math.max(0.05, tonumber(Options.RequestInterval) or 0.3),
			MaxRetries = math.max(0, math.min(3, math.floor(tonumber(Options.MaxRetries) or 2))),
			RetryCooldown = math.max(5, tonumber(Options.RetryCooldown) or 60),
			Request = Options.Request,
			OnError = Options.OnError,
			Notifications = Options.Notifications ~= false,
			Messages = Options.Messages,
			SyncSwap = Options.SyncSwap ~= false,
			SwapTimeout = math.max(2, tonumber(Options.SwapTimeout) or 10),
			FrameBudget = math.max(0.0005, math.min(0.012, tonumber(Options.FrameBudget) or 0.003)),
			SaveDelay = math.max(0.5, tonumber(Options.SaveDelay) or 2),
		}
		if FirstConfigure then
			self.DisplayLanguage = SourceLanguage
		end
		self.SourceLanguage = SourceLanguage
		self.Prefix = Options.Prefix or "loc:"
		assert(type(self.Prefix) == "string" and self.Prefix ~= "", "Prefix must not be empty")
		self.MissingSources = {}
		for _, Entries in pairs(Translations) do
			for Key, Value in pairs(Entries) do
				if type(Value) == "string" and (Translations[SourceLanguage] or {})[Key] == nil and not Key:find("%s") and Key:find("[%.%_]") then
					self.MissingSources["[" .. Key .. "]"] = true
				end
			end
		end
		self:BuildTerms()
		if OldSource ~= SourceLanguage or OldFile ~= self.Config.CacheFile then
			self.Cache = {}
		end
		self.Epoch += 1
		self.Failed = {}
		self.Active = true

		local Previous = self.CurrentLanguage
		local Saved = self:ReadCacheFile()
		local Selected = self:NormalizeCode(Options.Language) or (self.Config.SaveSelection and Saved) or DefaultLanguage
		if not self.Config.Enabled or not self:IsAvailable(Selected) then
			Selected = DefaultLanguage
		end
		self.CurrentLanguage = Selected

		for _, Properties in pairs(self.Records) do
			for _, Record in pairs(Properties) do
				if Record.Key then
					Record.Source = self:ParseSource(self.Prefix .. Record.Key)
				end
			end
		end

		self:SwitchDisplay(Selected)
		self:NotifyListeners(Previous)
		self:ScheduleSave()
		return self
	end

	function LocalizationEngine:Destroy()
		if self.Dead then
			return
		end
		self:SaveCache()
		self.Dead = true
		self.Epoch += 1
		local Objects = {}
		for Object in pairs(self.Records) do
			table.insert(Objects, Object)
		end
		for _, Object in ipairs(Objects) do
			self:Untrack(Object)
		end
		self.Listeners, self.Dropdowns = {}, {}
	end

	return LocalizationEngine
end

local LocalizationManager = {
	Version = "0.3.0",
	Languages = Languages,
	Folder = "FluentSettings",
	Roots = {},
	Connections = {},
	Wrapped = {},
	TranslateUnkeyed = true,
	Configured = false,
	Dead = false,
}

local function NormalizeFolder(Folder: any): string
	assert(type(Folder) == "string" and Folder ~= "", "Folder is required for language storage")
	local Cleaned = Folder:gsub("\\", "/"):gsub("/+", "/"):gsub("/$", "")
	assert(Cleaned ~= "" and Cleaned:sub(1, 1) ~= "/" and not Cleaned:find(":", 1, true), "Folder must be a relative path")
	for Piece in Cleaned:gmatch("[^/]+") do
		assert(Piece ~= "." and Piece ~= "..", "Unsafe folder path")
	end
	return Cleaned
end

function LocalizationManager:ReportError(Message: any)
	if self.Engine then
		self.Engine:ReportError(Message)
	else
		warn("[LocalizationManager] " .. tostring(Message))
	end
end

function LocalizationManager:SetFolder(Folder: string)
	self.Folder = NormalizeFolder(Folder)
end

function LocalizationManager:GetCachePath(): string
	return self.Folder .. "/LanguageCache.json"
end

function LocalizationManager:SetSaveManager(SaveManager: any)
	self.SaveManager = SaveManager
	if SaveManager and type(SaveManager.SetIgnoreIndexes) == "function" then
		pcall(SaveManager.SetIgnoreIndexes, SaveManager, { "ModulesLanguage" })
	end
end

function LocalizationManager:Localization(Config: any)
	assert(not self.Dead, "LocalizationManager was destroyed")
	assert(self.Engine, "Call SetLibrary before Localization")
	assert(type(Config) == "table", "Localization expects a configuration table")
	local Options = CopyTable(Config)
	Options.AutoTranslate = Options.AutoTranslate == true or Options.AutoTranslations == true
	Options.CacheFile = self:GetCachePath()

	local Codes: { string }, Terms: { string } = {}, {}
	for _, Term in ipairs(Options.NoTranslations or {}) do
		table.insert(Terms, Term)
	end
	for _, Language in ipairs(self.Languages) do
		table.insert(Codes, Language.Code)
		table.insert(Terms, Language.Name)
		table.insert(Terms, Language.Code:upper())
	end
	Options.NoTranslations = Terms
	Options.Languages = Options.Languages or Codes
	self.Options = CopyTable(Options)
	self.TranslateUnkeyed = Config.TranslateUnkeyed ~= false

	if self.Configured and Options.Language == nil then
		Options.Language = self.Engine.CurrentLanguage
	end
	self.Configured = true
	self.Engine:Configure(Options)
	self.Engine:Refresh()
	self:RescanRoots()
	return Config
end

function LocalizationManager:TrackObject(Object: any)
	local Engine = self.Engine
	if self.Dead or not Engine or not Engine.Config then
		return
	end
	local IsBox = Object:IsA("TextBox")
	if not (IsBox or Object:IsA("TextLabel") or Object:IsA("TextButton")) then
		return
	end
	if not self.TranslateUnkeyed then
		local Value = if IsBox then Object.PlaceholderText else Object.Text
		if Value:sub(1, #Engine.Prefix) ~= Engine.Prefix then
			return
		end
	end
	local Success, Problem = pcall(Engine.Track, Engine, Object)
	if not Success then
		self:ReportError(Problem)
	end
end

function LocalizationManager:ScanRoot(Root: any)
	if not self.Roots[Root] then
		return
	end
	task.spawn(function()
		self:TrackObject(Root)
		local StartedAt = os.clock()
		for _, Object in ipairs(Root:GetDescendants()) do
			if self.Dead then
				return
			end
			self:TrackObject(Object)
			if os.clock() - StartedAt > 0.003 then
				task.wait()
				StartedAt = os.clock()
			end
		end
	end)
end

function LocalizationManager:RescanRoots()
	local Roots = {}
	for Root in pairs(self.Roots) do
		table.insert(Roots, Root)
	end
	for _, Root in ipairs(Roots) do
		self:ScanRoot(Root)
	end
end

function LocalizationManager:AttachRoot(Root: any)
	assert(typeof(Root) == "Instance", "AttachRoot expects a GUI Instance")
	if self.Dead or self.Roots[Root] then
		return self
	end
	self.Roots[Root] = true

	table.insert(self.Connections, Root.DescendantAdded:Connect(function(Object: any)
		if not IsTextObject(Object) then
			return
		end
		task.defer(function()
			if Object.Parent ~= nil then
				self:TrackObject(Object)
			end
		end)
	end))
	table.insert(self.Connections, Root.Destroying:Connect(function()
		self.Roots[Root] = nil
	end))

	self:ScanRoot(Root)
	return self
end

function LocalizationManager:GetKnownRoots(): { any }
	local Library = self.Library
	local Found: { any } = {}
	local function Add(Candidate: any)
		if typeof(Candidate) == "Instance" and Candidate.Parent ~= nil then
			table.insert(Found, Candidate)
		end
	end
	Add(Library.GUI)
	Add(Library.MenuGUI)
	local Internals = Library.Internals
	if type(Internals) == "table" then
		local Notification = Internals.Notification
		if type(Notification) == "table" then
			Add(Notification.Gui)
		end
		local Components = Internals.Components
		local Toast = type(Components) == "table" and Components.Toast
		if type(Toast) == "table" then
			Add(Toast.Gui)
		end
	end
	if type(Library.Layers) == "table" then
		for _, Layer in pairs(Library.Layers) do
			Add(Layer)
		end
	end
	return Found
end

function LocalizationManager:AttachKnownRoots()
	if self.Dead then
		return
	end
	for _, Root in ipairs(self:GetKnownRoots()) do
		self:AttachRoot(Root)
	end
end

function LocalizationManager:SetLanguage(Code: any): (boolean, string?)
	assert(self.Engine, "Call SetLibrary first")
	return self.Engine:SetLanguage(Code)
end

function LocalizationManager:GetLanguage(): string
	assert(self.Engine, "Call SetLibrary first")
	return self.Engine:GetLanguage()
end

function LocalizationManager:Refresh(RetryFailed: boolean?): boolean
	assert(self.Engine, "Call SetLibrary first")
	return self.Engine:Refresh(RetryFailed)
end

function LocalizationManager:OnChanged(Callback: (string, string) -> ())
	assert(self.Engine, "Call SetLibrary first")
	return self.Engine:OnChanged(Callback)
end

function LocalizationManager:SetTranslations(Language: any, Entries: { [any]: any }, Replace: boolean?): boolean
	assert(self.Engine, "Call SetLibrary first")
	return self.Engine:SetTranslations(Language, Entries, Replace)
end

function LocalizationManager:ClearCache(Language: any?)
	assert(self.Engine, "Call SetLibrary first")
	return self.Engine:ClearCache(Language)
end

function LocalizationManager:Ignore(Object: any, Ignored: boolean?)
	if typeof(Object) == "Instance" then
		Object:SetAttribute("ModulesNoTranslate", Ignored ~= false)
	end
end

function LocalizationManager:AddDropdown(Host: any, Options: any?)
	local Engine = self.Engine
	assert(Engine and Engine.Config, "Call Localization before AddDropdown")
	assert(type(Host) == "table" and type(Host.AddDropdown) == "function", "Host must be a Fluent Tab or Section")
	Options = CopyTable(Options)
	local Entry = { Syncing = true, Labels = {} }
	local Values: { string }, Reverse: { [string]: string } = {}, {}
	local Tags: { [string]: any }, ItemTags: { [string]: string } = {}, {}
	for _, Language in ipairs(self.Languages) do
		local Label = Language.Name
		table.insert(Values, Label)
		Reverse[Label], Entry.Labels[Language.Code] = Language.Code, Label
		Tags[Language.Code] = { Text = Language.Code:upper(), Color = Language.Color or FlagColors[Language.Code] }
		ItemTags[Label] = Language.Code
	end
	local Index = Options.Idx or "ModulesLanguage"
	local UserCallback = Options.Callback
	local Dropdown
	Dropdown = Host:AddDropdown(Index, {
		Title = Options.Title or "Language",
		Description = Options.Description or Options.Desc or "30 languages • Manual dictionaries + automatic translation",
		Icon = Options.Icon or "rbxassetid://10723417703",
		IconColor = Options.IconColor,
		Values = Values,
		Tags = Tags,
		ItemTags = ItemTags,
		Default = Entry.Labels[self:GetLanguage()] or Values[1],
		Searchable = Options.Searchable ~= false,
		Width = Options.Width or 190,
		Callback = function(Value: any)
			if Entry.Syncing then
				return
			end
			if type(Value) == "table" then
				Value = next(Value)
			end
			local Code = Reverse[Value]
			if not Code then
				return
			end
			local Success, Problem = self:SetLanguage(Code)
			if not Success then
				self:ReportError(Problem)
				Engine:SyncDropdowns()
			end
			if UserCallback then
				UserCallback(Code, Success, Problem)
			end
		end,
	})
	if self.SaveManager and type(self.SaveManager.SetIgnoreIndexes) == "function" then
		pcall(self.SaveManager.SetIgnoreIndexes, self.SaveManager, { Index })
	end
	Engine.Dropdowns[Dropdown] = Entry
	Entry.Syncing = false
	return Dropdown
end

function LocalizationManager:BuildSection(Tab: any, Options: any?)
	local Library = self.Library
	assert(Library, "Must set LocalizationManager.Library")
	assert(self.Engine and self.Engine.Config, "Call Localization before BuildSection")
	assert(type(Tab) == "table" and type(Tab.AddSection) == "function", "BuildSection expects a Fluent Tab")
	Options = CopyTable(Options)

	local Section = Tab:AddSection(Options.SectionTitle or "Language", {
		Icon = Options.SectionIcon or "rbxassetid://10723417703",
	})
	local Dropdown = self:AddDropdown(Section, Options)

	Section:AddButton({
		Title = "Retry translation",
		Description = "Try again for texts that failed to translate",
		Icon = "rbxassetid://10734933222",
		IconColor = Color3.fromRGB(10, 132, 255),
		ButtonText = "Retry",
		Callback = function()
			self:Refresh(true)
		end,
	})

	Section:AddButton({
		Title = "Clear cache",
		Description = "Delete saved automatic translations",
		Icon = "rbxassetid://10747362241",
		IconColor = Color3.fromRGB(255, 69, 58),
		Variant = "Danger",
		ButtonText = "Clear",
		Callback = function()
			Library.Window:Dialog({
				Title = "Clear cache",
				Content = "Delete all saved automatic translations? They will be translated again when needed.",
				Buttons = {
					{
						Title = "Clear",
						Variant = "Danger",
						Callback = function()
							self:ClearCache()
						end,
					},
					{ Title = "Cancel" },
				},
			})
		end,
	})

	return Section, Dropdown
end

function LocalizationManager:GetStatus()
	local Tracked = 0
	local Engine = self.Engine
	if Engine then
		for _ in pairs(Engine.Records) do
			Tracked += 1
		end
	end
	return {
		Version = self.Version,
		Language = Engine and Engine.CurrentLanguage or nil,
		DisplayLanguage = Engine and Engine.DisplayLanguage or nil,
		Busy = Engine and Engine.Busy or false,
		TrackedObjects = Tracked,
		CachePath = self:GetCachePath(),
		LastError = Engine and Engine.LastError or nil,
		Dead = self.Dead == true,
	}
end

function LocalizationManager:Destroy()
	if self.Dead then
		return
	end
	self.Dead = true
	if self.Engine then
		self.Engine:Destroy()
	end
	for _, Connection in ipairs(self.Connections) do
		Connection:Disconnect()
	end
	if self.Library then
		for Key, Original in pairs(self.Wrapped) do
			self.Library[Key] = Original or nil
		end
	end
	self.Roots, self.Connections, self.Wrapped = {}, {}, {}
end

function LocalizationManager:SetLibrary(Library: any)
	assert(type(Library) == "table" and type(Library.CreateWindow) == "function", "Expected the Fluent Library table")
	if self.Library == Library then
		return self
	end
	assert(self.Library == nil, "SetLibrary was already called with another Library")
	self.Library = Library
	self.Engine = CreateLocalizationEngine(Library)

	self:AttachKnownRoots()

	local MainGui = Library.GUI
	if typeof(MainGui) == "Instance" and MainGui.Parent then
		table.insert(self.Connections, MainGui.Parent.ChildAdded:Connect(function(Child: any)
			if not Child:IsA("ScreenGui") then
				return
			end
			task.defer(function()
				self:AttachKnownRoots()
			end)
		end))
	end

	local Events = Library.Events
	if Events and Events.ElementAdded then
		table.insert(self.Connections, Events.ElementAdded:Connect(function(Object: any, Kind: string)
			if Kind ~= "Keybind" or type(Object) ~= "table" or not Object.Row then
				return
			end
			local Content = Object.Row.Content
			if typeof(Content) ~= "Instance" then
				return
			end
			local DisplayText = tostring(Object.Value)
			for _, Descendant in ipairs(Content:GetDescendants()) do
				if Descendant:IsA("TextLabel") and Descendant.Text == DisplayText then
					Descendant:SetAttribute("ModulesNoTranslate", true)
				end
			end
		end))
	end

	local Wrappers = {
		Localization = function(_: any, Config: any)
			return self:Localization(Config)
		end,
		SetLanguage = function(_: any, Code: any)
			return self:SetLanguage(Code)
		end,
		GetLanguage = function()
			return self:GetLanguage()
		end,
	}
	for Key, Wrapper in pairs(Wrappers) do
		self.Wrapped[Key] = rawget(Library, Key) or false
		Library[Key] = Wrapper
	end

	if type(Library.OnUnload) == "function" then
		Library:OnUnload(function()
			self:Destroy()
		end)
	end

	return self
end

function LocalizationManager:Install(Library: any, Options: any?)
	Options = Options or {}
	if Options.Folder then
		self:SetFolder(Options.Folder)
	end
	self:SetLibrary(Library)
	if Options.SaveManager then
		self:SetSaveManager(Options.SaveManager)
	end
	return self
end

return LocalizationManager
