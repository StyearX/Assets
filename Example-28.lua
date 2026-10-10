local cloneref = (cloneref or clonereference or function(instance: any)
	return instance
end)
local Players: Players = cloneref(game:GetService("Players"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))

local Library, SaveManager, InterfaceManager, MediaCache = loadstring(readfile("FluentReimagined/main.lua"))()
local Options = Library.Options

local LocalPlayer = Players.LocalPlayer

MediaCache:SetFolder("FluentReimagined/Cache")

local Window = Library:CreateWindow({
	Title = "Unknown Hub",
	SubTitle = "UI Example",
	TabWidth = 150,
	Size = UDim2.fromOffset(560, 560),
	Acrylic = true,
	Theme = "Dark",
	Search = true,
   NewVisual = true,
	MinimizeKey = Enum.KeyCode.LeftControl,
   UserInfo = {
		Position = "Bottom",
		Icon = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420",
		Title = LocalPlayer.DisplayName,
	},
})

local Tabs = {
	Main = Window:AddTab({ Title = "Main", Icon = "home" }),
	Visual = Window:AddTab({ Title = "Visual", Icon = "palette" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local ButtonSection = Tabs.Main:AddSection("Button")

ButtonSection:AddParagraph({
	Title = "Paragraph",
	Content = "Static text block with a title and content.",
})

ButtonSection:AddButton({
	Title = "Button",
	Callback = function()
		print("Button clicked")
	end,
})

ButtonSection:AddButton({
	Title = "Button With Description",
	Description = "Shows a description under the title",
	Callback = function()
		print("Button with description clicked")
	end,
})

ButtonSection:AddButton({
	Title = "Button With Icon",
	Description = "Uses a lucide icon",
	Icon = "rocket",
	Callback = function()
		print("Button with icon clicked")
	end,
})

ButtonSection:AddButton({
	Title = "Dialog",
	Description = "Opens a confirmation dialog",
	Icon = "message-square",
	Callback = function()
		Window:Dialog({
			Title = "Confirm",
			Content = "Do you want to continue?",
			Buttons = {
				{
					Title = "Confirm",
					Callback = function()
						print("Confirmed")
					end,
				},
				{
					Title = "Cancel",
					Callback = function()
						print("Cancelled")
					end,
				},
			},
		})
	end,
})

local LockedSection = Tabs.Main:AddSection("Locked")

local LockedToggle = LockedSection:AddToggle("LockedToggle", {
	Title = "Locked Toggle",
	Description = "Starts locked",
	Default = false,
	Locked = true,
})

local LockedSlider = LockedSection:AddSlider("LockedSlider", {
	Title = "Locked Slider",
	Default = 50,
	Min = 0,
	Max = 100,
	Rounding = 0,
	Locked = true,
})

LockedSection:AddButton({
	Title = "Unlock Elements",
	Callback = function()
		LockedToggle:Unlock()
		LockedSlider:OpenLocked()
	end,
})

LockedSection:AddButton({
	Title = "Lock Elements",
	Callback = function()
		LockedToggle:Lock()
		LockedSlider:SetLocked(true)
	end,
})

local TitleButton = ButtonSection:AddButton({
	Title = "Dynamic Title",
	Description = "Click to change this title and description",
	Callback = function()
		print("Dynamic button clicked")
	end,
})

ButtonSection:AddButton({
	Title = "Change Title",
	Callback = function()
		TitleButton:SetTitle("Title Changed " .. os.date("%X"))
		TitleButton:SetDesc("Description changed too")
	end,
})

local ToggleSection = Tabs.Main:AddSection("Toggle")

local BasicToggle = ToggleSection:AddToggle("BasicToggle", {
	Title = "Basic Toggle",
	Default = false,
})

BasicToggle:OnChanged(function(Value)
	print("Basic toggle:", Value)
end)

ToggleSection:AddToggle("DescriptionToggle", {
	Title = "Toggle With Description",
	Description = "Default enabled",
	Default = true,
	Callback = function(Value)
		print("Description toggle:", Value)
	end,
})

ToggleSection:AddToggle("IconToggle", {
	Title = "Toggle With Icon",
	Icon = "zap",
	Default = false,
})

local HeartbeatConnection
local LoopToggle = ToggleSection:AddToggle("LoopToggle", {
	Title = "Heartbeat Loop",
	Description = "Connects and disconnects a RunService event",
	Default = false,
})

LoopToggle:OnChanged(function(Value)
	if Value then
		HeartbeatConnection = RunService.Heartbeat:Connect(function(DeltaTime)
		end)
	elseif HeartbeatConnection then
		HeartbeatConnection:Disconnect()
		HeartbeatConnection = nil
	end
end)

ToggleSection:AddButton({
	Title = "Force Enable Basic Toggle",
	Callback = function()
		Options.BasicToggle:SetValue(true)
	end,
})

local SliderSection = Tabs.Main:AddSection("Slider")

local WalkSpeedSlider = SliderSection:AddSlider("WalkSpeedSlider", {
	Title = "Walk Speed",
	Description = "Integer slider",
	Default = 16,
	Min = 16,
	Max = 100,
	Rounding = 0,
	Callback = function(Value)
		local Character = LocalPlayer.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			Humanoid.WalkSpeed = Value
		end
	end,
})

WalkSpeedSlider:OnChanged(function(Value)
	print("Walk speed:", Value)
end)

SliderSection:AddSlider("DecimalSlider", {
	Title = "Decimal Slider",
	Description = "Rounding set to 2",
	Default = 0.5,
	Min = 0,
	Max = 1,
	Rounding = 2,
})

SliderSection:AddSlider("StepSlider", {
	Title = "Slider With Step Buttons",
	Default = 50,
	Min = 0,
	Max = 100,
	Rounding = 0,
	StepButtons = true,
})

SliderSection:AddSlider("IconSlider", {
	Title = "Slider With Icons",
	Default = 30,
	Min = 0,
	Max = 100,
	Rounding = 0,
	LeftIcon = "volume-1",
	RightIcon = "volume-2",
})

SliderSection:AddButton({
	Title = "Reset Walk Speed",
	Callback = function()
		Options.WalkSpeedSlider:SetValue(16)
	end,
})

local DropdownSection = Tabs.Main:AddSection("Dropdown")

DropdownSection:AddDropdown("SingleDropdown", {
	Title = "Single Dropdown",
	Values = { "Legit", "Rage", "Blatant" },
	Multi = false,
	Default = 1,
	Callback = function(Value)
		print("Single:", Value)
	end,
})

DropdownSection:AddDropdown("StringDefaultDropdown", {
	Title = "Default By Name",
	Description = "Default is set with a string",
	Values = { "Head", "Torso", "Legs" },
	Default = "Torso",
})

DropdownSection:AddDropdown("NullDropdown", {
	Title = "Allow Null",
	Description = "Can be cleared back to nothing",
	Values = { "1", "2", "3" },
	AllowNull = true,
	Icon = "circle-off",
})

local SortTestValues = { "Zebra", "apple", "Mango", "10", "2", "Banana", "Éclair", "あいう" }

DropdownSection:AddDropdown("SortLoadDropdown", {
	Title = "Sort: Load",
	Description = "Follows the order of Values",
	Values = SortTestValues,
	SortMode = "Load",
	Default = 1,
})

DropdownSection:AddDropdown("SortAlphaDropdown", {
	Title = "Sort: Alphabetical",
	Description = "A-Z, numbers at the end",
	Values = SortTestValues,
	SortMode = "Alphabetical",
	Default = 1,
})

DropdownSection:AddDropdown("SortDescDropdown", {
	Title = "Sort: AlphabeticalDesc",
	Description = "Z-A, numbers at the end",
	Values = SortTestValues,
	SortMode = "AlphabeticalDesc",
	Default = 1,
})

local SortSwitchDropdown = DropdownSection:AddDropdown("SortSwitchDropdown", {
	Title = "Sort: Runtime Switch",
	Description = "Change the mode with the buttons below",
	Values = SortTestValues,
	SortMode = "Load",
	Default = 1,
})

for _, Mode in next, { "Load", "Alphabetical", "AlphabeticalDesc" } do
	DropdownSection:AddButton({
		Title = "Switch To " .. Mode,
		Callback = function()
			SortSwitchDropdown:SetSortMode(Mode)
		end,
	})
end

local ManyValues = {}
for Index = 1, 100 do
	table.insert(ManyValues, tostring(Index))
end

local ManySection = Tabs.Main:AddSection("Many Options")

ManySection:AddDropdown("ManyDropdown", {
	Title = "Dropdown With 100 Options",
	Description = "Scrolls inside the list",
	Values = ManyValues,
	Multi = false,
	Default = 1,
})

ManySection:AddDropdown("ManySearchDropdown", {
	Title = "Dropdown With 100 Options And Search",
	Description = "Type to filter the list",
	Values = ManyValues,
	Search = true,
	Multi = false,
	Default = 1,
})

local PlayerNames = {}
for _, Player in next, Players:GetPlayers() do
	table.insert(PlayerNames, Player.Name)
end

local SearchSection = Tabs.Main:AddSection("Search")

SearchSection:AddDropdown("SearchDropdown", {
	Title = "Dropdown With Search",
	Values = { "Apple", "Banana", "Cherry", "Grape", "Lemon", "Mango", "Orange", "Peach", "Pear", "Strawberry" },
	Search = true,
	Multi = false,
	Default = 1,
})

local PlayerDropdown = SearchSection:AddDropdown("PlayerDropdown", {
	Title = "Player List",
	Description = "Values are refreshed from the server",
	Values = PlayerNames,
	Search = true,
	Multi = false,
	AllowNull = true,
})

SearchSection:AddButton({
	Title = "Refresh Player List",
	Callback = function()
		local Names = {}
		for _, Player in next, Players:GetPlayers() do
			table.insert(Names, Player.Name)
		end
		PlayerDropdown:SetValues(Names)
	end,
})

local MultiSection = Tabs.Main:AddSection("Multi")

local MultiDropdown = MultiSection:AddDropdown("MultiDropdown", {
	Title = "Multi Dropdown",
	Description = "Select more than one value",
	Values = { "ESP", "Aimbot", "Fly", "Noclip", "Speed", "Infinite Jump" },
	Multi = true,
	Default = { "ESP", "Fly" },
})

MultiDropdown:OnChanged(function(Value)
	local Selected = {}
	for Name, State in next, Value do
		if State then
			table.insert(Selected, Name)
		end
	end
	print("Multi:", table.concat(Selected, ", "))
end)

MultiSection:AddDropdown("MultiSearchDropdown", {
	Title = "Multi Dropdown With Search",
	Values = ManyValues,
	Search = true,
	Multi = true,
	Default = { "1", "2" },
})

MultiSection:AddDropdown("MultiManyDropdown", {
	Title = "Multi Dropdown With 100 Options",
	Values = ManyValues,
	Multi = true,
})

MultiSection:AddButton({
	Title = "Select Aimbot And Speed",
	Callback = function()
		Options.MultiDropdown:SetValue({ Aimbot = true, Speed = true })
	end,
})

MultiSection:AddButton({
	Title = "Clear Multi Dropdown",
	Callback = function()
		Options.MultiDropdown:SetValue({})
	end,
})

local InputSection = Tabs.Main:AddSection("Input")

InputSection:AddInput("TextInput", {
	Title = "Text Input",
	Default = "",
	Placeholder = "Type something",
	Callback = function(Value)
		print("Text:", Value)
	end,
})

InputSection:AddInput("FinishedInput", {
	Title = "Finished Input",
	Description = "Callback only fires when Enter is pressed",
	Default = "Hello",
	Placeholder = "Press Enter",
	Finished = true,
	Callback = function(Value)
		print("Finished:", Value)
	end,
})

local NumericInput = InputSection:AddInput("NumericInput", {
	Title = "Numeric Input",
	Description = "Only accepts numbers",
	Default = "100",
	Placeholder = "Amount",
	Numeric = true,
	Finished = true,
})

NumericInput:OnChanged(function(Value)
	print("Number:", tonumber(Value))
end)

InputSection:AddButton({
	Title = "Set Text Input",
	Callback = function()
		Options.TextInput:SetValue("Set from button")
	end,
})

local KeybindSection = Tabs.Main:AddSection("Keybind")

local ToggleKeybind = KeybindSection:AddKeybind("ToggleKeybind", {
	Title = "Toggle Mode",
	Description = "Press once to turn on, press again to turn off",
	Mode = "Toggle",
	Default = "LeftAlt",
	Callback = function(Value)
		print("Toggle keybind state:", Value)
	end,
	ChangedCallback = function(NewKey)
		print("Toggle keybind changed:", NewKey)
	end,
})

KeybindSection:AddKeybind("HoldKeybind", {
	Title = "Hold Mode",
	Description = "Active only while the key is held",
	Mode = "Hold",
	Default = "E",
})

KeybindSection:AddKeybind("AlwaysKeybind", {
	Title = "Always Mode",
	Description = "State is always true",
	Mode = "Always",
	Default = "F",
})

KeybindSection:AddKeybind("MouseKeybind", {
	Title = "Mouse Keybind",
	Description = "Default is the left mouse button",
	Mode = "Toggle",
	Default = "MouseLeft",
})

local StateSection = Tabs.Main:AddSection("Keybind State")

local HoldKeybind = Options.HoldKeybind

StateSection:AddButton({
	Title = "Print Keybind States",
	Description = "Reads GetState from every keybind",
	Callback = function()
		print("Toggle:", Options.ToggleKeybind:GetState())
		print("Hold:", HoldKeybind:GetState())
		print("Always:", Options.AlwaysKeybind:GetState())
	end,
})

StateSection:AddButton({
	Title = "Rebind Toggle Keybind To Q",
	Callback = function()
		ToggleKeybind:SetValue("Q", "Toggle")
	end,
})

ToggleKeybind:OnClick(function()
	print("Toggle keybind clicked")
end)

ToggleKeybind:OnChanged(function(Value)
	print("Toggle keybind value:", Value)
end)

UserInputService.InputBegan:Connect(function(Input, Processed)
	if Processed then
		return
	end
	if Input.KeyCode == Enum.KeyCode.RightShift then
		Window:Minimize()
	end
end)

local DynamicSection = Tabs.Main:AddSection("Dynamic Add")

local DynamicCount = {
	Tab = 0,
	HeaderTab = 0,
	SidebarSection = 0,
	NestedTab = 0,
	Section = 0,
	Element = 0,
}

local DynamicSidebarSection
local DynamicTarget = Tabs.Main:AddSection("Dynamic Target")

local function NextCount(Name)
	DynamicCount[Name] = DynamicCount[Name] + 1
	return DynamicCount[Name]
end

local function NextOption(Prefix)
	return Prefix .. NextCount("Element")
end

DynamicSection:AddButton({
	Title = "Add Tab",
	Description = "Adds a new tab to the sidebar",
	Icon = "plus",
	Callback = function()
		local Index = NextCount("Tab")
		local NewTab = Window:AddTab({ Title = "Dynamic Tab " .. Index, Icon = "layers" })
		NewTab:AddSection("Dynamic"):AddParagraph({
			Title = "Dynamic Tab " .. Index,
			Content = "This tab was added while the window was open.",
		})
		Library:Toast({
			Title = "Tab Added",
			Content = "Dynamic Tab " .. Index,
			Type = "Success",
			Duration = 3,
		})
	end,
})

DynamicSection:AddButton({
	Title = "Add Header Tab",
	Description = "Adds a new tab to the window header",
	Icon = "plus",
	Callback = function()
		local Index = NextCount("HeaderTab")
		local NewTab = Window:AddTabInHeader({ Title = "Header " .. Index, Icon = "layout-panel-top" })
		NewTab:AddSection("Header"):AddParagraph({
			Title = "Header " .. Index,
			Content = "This header tab was added while the window was open.",
		})
	end,
})

DynamicSection:AddButton({
	Title = "Add Sidebar Section",
	Description = "Adds a new collapsible section to the sidebar",
	Icon = "plus",
	Callback = function()
		local Index = NextCount("SidebarSection")
		DynamicSidebarSection = Window:AddSection({
			Title = "Dynamic Section " .. Index,
			Collapsible = true,
		})
		Library:Toast({
			Title = "Sidebar Section Added",
			Content = "Use Add Nested Tab to fill it",
			Type = "Info",
			Duration = 3,
		})
	end,
})

DynamicSection:AddButton({
	Title = "Add Nested Tab",
	Description = "Adds a tab inside the latest sidebar section",
	Icon = "plus",
	Callback = function()
		if not DynamicSidebarSection then
			Library:Toast({
				Title = "No Sidebar Section",
				Content = "Add a sidebar section first",
				Type = "Warning",
				Duration = 3,
			})
			return
		end
		local Index = NextCount("NestedTab")
		local NewTab = DynamicSidebarSection:AddTab({ Title = "Nested " .. Index, Icon = "folder" })
		NewTab:AddSection("Nested"):AddParagraph({
			Title = "Nested " .. Index,
			Content = "This nested tab was added while the window was open.",
		})
	end,
})

DynamicSection:AddButton({
	Title = "Add Section",
	Description = "Adds a new section to the Main tab",
	Icon = "plus",
	Callback = function()
		local Index = NextCount("Section")
		local NewSection = Tabs.Main:AddSection("Dynamic Section " .. Index)
		NewSection:AddParagraph({
			Title = "Dynamic Section " .. Index,
			Content = "This section was added while the window was open.",
		})
	end,
})

DynamicSection:AddDivider("Elements")

DynamicSection:AddButton({
	Title = "Add Paragraph",
	Icon = "plus",
	Callback = function()
		DynamicTarget:AddParagraph({
			Title = "Paragraph " .. NextCount("Element"),
			Content = "Added from the Dynamic Add section.",
		})
	end,
})

DynamicSection:AddButton({
	Title = "Add Button",
	Icon = "plus",
	Callback = function()
		local Index = NextCount("Element")
		DynamicTarget:AddButton({
			Title = "Button " .. Index,
			Description = "Added from the Dynamic Add section",
			Callback = function()
				print("Dynamic button", Index)
			end,
		})
	end,
})

DynamicSection:AddButton({
	Title = "Add Toggle",
	Icon = "plus",
	Callback = function()
		local Index = NextCount("Element")
		DynamicTarget:AddToggle("DynamicToggle" .. Index, {
			Title = "Toggle " .. Index,
			Default = false,
			Callback = function(Value)
				print("Dynamic toggle", Index, Value)
			end,
		})
	end,
})

DynamicSection:AddButton({
	Title = "Add Slider",
	Icon = "plus",
	Callback = function()
		local Index = NextCount("Element")
		DynamicTarget:AddSlider("DynamicSlider" .. Index, {
			Title = "Slider " .. Index,
			Default = 50,
			Min = 0,
			Max = 100,
			Rounding = 0,
			Callback = function(Value)
				print("Dynamic slider", Index, Value)
			end,
		})
	end,
})

DynamicSection:AddButton({
	Title = "Add Input",
	Icon = "plus",
	Callback = function()
		local Index = NextCount("Element")
		DynamicTarget:AddInput("DynamicInput" .. Index, {
			Title = "Input " .. Index,
			Default = "",
			Placeholder = "Type something",
			Callback = function(Value)
				print("Dynamic input", Index, Value)
			end,
		})
	end,
})

DynamicSection:AddButton({
	Title = "Add Dropdown",
	Icon = "plus",
	Callback = function()
		local Index = NextCount("Element")
		DynamicTarget:AddDropdown("DynamicDropdown" .. Index, {
			Title = "Dropdown " .. Index,
			Values = { "One", "Two", "Three" },
			Multi = false,
			Default = 1,
			Callback = function(Value)
				print("Dynamic dropdown", Index, Value)
			end,
		})
	end,
})

DynamicSection:AddButton({
	Title = "Add Keybind",
	Icon = "plus",
	Callback = function()
		local Index = NextCount("Element")
		DynamicTarget:AddKeybind("DynamicKeybind" .. Index, {
			Title = "Keybind " .. Index,
			Mode = "Toggle",
			Default = "G",
		})
	end,
})

DynamicSection:AddButton({
	Title = "Add Colorpicker",
	Icon = "plus",
	Callback = function()
		local Index = NextCount("Element")
		DynamicTarget:AddColorpicker("DynamicColorpicker" .. Index, {
			Title = "Colorpicker " .. Index,
			Default = Color3.fromRGB(96, 205, 255),
			Callback = function(Value)
				print("Dynamic color", Index, Value)
			end,
		})
	end,
})

DynamicSection:AddButton({
	Title = "Add Divider",
	Icon = "plus",
	Callback = function()
		DynamicTarget:AddDivider("Divider " .. NextCount("Element"))
	end,
})

DynamicSection:AddButton({
	Title = "Add Space",
	Icon = "plus",
	Callback = function()
		DynamicTarget:AddSpace({ Height = 16 })
	end,
})

DynamicSection:AddButton({
	Title = "Add Group",
	Description = "Adds a two column group with a button in each",
	Icon = "plus",
	Callback = function()
		local Index = NextCount("Element")
		local NewGroup = DynamicTarget:AddGroup({ Columns = 2, Gap = 8 })
		for Column = 1, 2 do
			NewGroup:AddElement():AddButton({
				Title = "Group " .. Index .. " Column " .. Column,
				Callback = function()
					print("Dynamic group", Index, Column)
				end,
			})
		end
	end,
})

DynamicSection:AddButton({
	Title = "Add Many Elements",
	Description = "Adds ten buttons at once to test scrolling",
	Icon = "plus",
	Callback = function()
		for _ = 1, 10 do
			local Index = NextCount("Element")
			DynamicTarget:AddButton({
				Title = "Bulk Button " .. Index,
				Callback = function()
					print("Bulk button", Index)
				end,
			})
		end
	end,
})

local ColorSection = Tabs.Visual:AddSection("Colorpicker")

local AccentPicker = ColorSection:AddColorpicker("AccentColorpicker", {
	Title = "Colorpicker",
	Default = Color3.fromRGB(96, 205, 255),
	Callback = function(Value)
		print("Color:", Value)
	end,
})

AccentPicker:OnChanged(function()
	print("Accent:", AccentPicker.Value)
end)

ColorSection:AddColorpicker("TransparencyColorpicker", {
	Title = "Colorpicker With Transparency",
	Description = "Also exposes an alpha slider",
	Default = Color3.fromRGB(255, 120, 120),
	Transparency = 0,
	Callback = function(Value)
		print("Color:", Value)
	end,
})

ColorSection:AddButton({
	Title = "Set Accent To Green",
	Callback = function()
		Options.AccentColorpicker:SetValueRGB(Color3.fromRGB(80, 200, 120))
	end,
})

local GradientSection = Tabs.Visual:AddSection("GradientPicker")

local Gradient = GradientSection:AddGradientPicker("MainGradient", {
	Title = "Gradient Picker",
	Default = ColorSequence.new(Color3.fromRGB(96, 205, 255), Color3.fromRGB(180, 90, 255)),
	Rotation = 45,
	Callback = function(Sequence)
		print("Gradient keypoints:", #Sequence.Keypoints)
	end,
})

GradientSection:AddButton({
	Title = "Rotate Gradient To 90",
	Callback = function()
		Gradient:SetRotation(90)
	end,
})

local TransparencyGradient = GradientSection:AddGradientPicker("TransparencyGradient", {
	Title = "Gradient Picker With Transparency",
	Description = "Adds an opacity track for every stop",
	Default = ColorSequence.new(Color3.fromRGB(255, 120, 120), Color3.fromRGB(255, 200, 80)),
	Rotation = 90,
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 0.6),
	}),
	Callback = function(Sequence, Rotation, Transparency)
		print("Gradient stops:", #Sequence.Keypoints, "Opacity stops:", #Transparency.Keypoints)
	end,
})

GradientSection:AddButton({
	Title = "Set Transparency To 50%",
	Callback = function()
		TransparencyGradient:SetTransparency(NumberSequence.new(0.5))
	end,
})

local LayoutSection = Tabs.Visual:AddSection("Divider And Space")

LayoutSection:AddDivider()
LayoutSection:AddDivider("Divider With Text")
LayoutSection:AddDivider({
	Text = "Custom Divider",
	Thickness = 2,
	Transparency = 0.6,
	Gap = 14,
})
LayoutSection:AddSpace({ Height = 16 })

local GroupSection = Tabs.Visual:AddSection("Group")

local ColumnGroup = GroupSection:AddGroup({ Columns = 2, Gap = 8 })

local LeftColumn = ColumnGroup:AddElement()
LeftColumn:AddButton({
	Title = "Left Button",
	Callback = function()
		print("Left")
	end,
})
LeftColumn:AddToggle("LeftToggle", { Title = "Left Toggle", Default = false })

local RightColumn = ColumnGroup:AddElement()
RightColumn:AddButton({
	Title = "Right Button",
	Callback = function()
		print("Right")
	end,
})
RightColumn:AddToggle("RightToggle", { Title = "Right Toggle", Default = true })

local ThreeColumnGroup = GroupSection:AddGroup({ Columns = 3, Gap = 6 })
for Index = 1, 3 do
	ThreeColumnGroup:AddElement():AddButton({
		Title = "Column " .. Index,
		Callback = function()
			print("Column", Index)
		end,
	})
end

local StackSection = Tabs.Visual:AddSection("HStack And VStack")

local Row = StackSection:AddHStack({ Gap = 8 })

local FirstStack = Row:AddVStack()
FirstStack:AddButton({ Title = "Stack 1 Button" })
FirstStack:AddSlider("StackSliderOne", {
	Title = "Stack 1 Slider",
	Default = 10,
	Min = 0,
	Max = 20,
	Rounding = 0,
})

local SecondStack = Row:AddVStack()
SecondStack:AddDropdown("StackDropdown", {
	Title = "Stack 2 Dropdown",
	Values = { "One", "Two", "Three" },
	Default = 1,
})
SecondStack:AddInput("StackInput", {
	Title = "Stack 2 Input",
	Placeholder = "Type",
})

local TitledStack = StackSection:AddVStack({
	Title = "Titled VStack",
	Description = "Vertical stack with its own heading",
	Gap = 6,
})
TitledStack:AddToggle("StackToggleOne", { Title = "First", Default = false })
TitledStack:AddToggle("StackToggleTwo", { Title = "Second", Default = true })

local MediaSection = Tabs.Visual:AddSection("MediaCache")

local ImageUrl = "https://picsum.photos/640/360"

MediaSection:AddImage({
	Image = ImageUrl,
	AspectRatio = "16:9",
	Radius = 10,
})

MediaSection:AddButton({
	Title = "Cache Image To Disk",
	Description = "Downloads through MediaCache and returns the file path",
	Icon = "download",
	Callback = function()
		local Path = Library:CacheFile(ImageUrl, ".png")
		Library:Notify({
			Title = "MediaCache",
			Content = Path and "Saved" or "Failed",
			SubContent = Path or "Download failed",
			Duration = 5,
		})
	end,
})

MediaSection:AddButton({
	Title = "Download With MediaCache Directly",
	Callback = function()
		local Path = MediaCache:Download(ImageUrl, ".png")
		print("Cache folder:", MediaCache:GetFolder())
		print("File:", Path)
	end,
})

MediaSection:AddButton({
	Title = "Resolve Media",
	Description = "Turns a URL into a custom asset id",
	Callback = function()
		print(Library:ResolveMedia(ImageUrl))
	end,
})

local ViewportSection = Tabs.Visual:AddSection("Viewport")

local PreviewPart = Instance.new("Part")
PreviewPart.Size = Vector3.new(4, 4, 4)
PreviewPart.Color = Color3.fromRGB(96, 205, 255)
PreviewPart.Material = Enum.Material.SmoothPlastic
PreviewPart.Anchored = true

local PreviewViewport = ViewportSection:AddViewport({
	Height = 220,
	Interactive = true,
	Focused = true,
	ZoomMin = 4,
	ZoomMax = 30,
	BackgroundColor = Color3.fromRGB(15, 15, 20),
	Ambient = Color3.fromRGB(120, 120, 120),
	LightColor = Color3.fromRGB(255, 255, 255),
	LightDirection = Vector3.new(-1, -1, -1),
})

PreviewViewport:SetObject(PreviewPart, true)

ViewportSection:AddButton({
	Title = "Taller Viewport",
	Callback = function()
		PreviewViewport:SetHeight(300)
	end,
})

local FeedbackSection = Tabs.Visual:AddSection("Notify")

FeedbackSection:AddButton({
	Title = "Notify",
	Callback = function()
		Library:Notify({
			Title = "Notification",
			Content = "Main content",
			SubContent = "Sub content",
			Duration = 5,
		})
	end,
})

FeedbackSection:AddButton({
	Title = "Notify Without Duration",
	Description = "Stays until closed",
	Callback = function()
		Library:Notify({
			Title = "Persistent",
			Content = "Close me manually",
		})
	end,
})

local ToastSection = Tabs.Visual:AddSection("Toast")

for _, ToastType in next, { "Info", "Success", "Warning", "Error" } do
	ToastSection:AddButton({
		Title = ToastType .. " Toast",
		Callback = function()
			Library:Toast({
				Title = ToastType,
				Content = "This is a " .. ToastType:lower() .. " toast",
				Type = ToastType,
				Duration = 4,
			})
		end,
	})
end

ToastSection:AddButton({
	Title = "Custom Icon Toast",
	Description = "Custom icon, title and content",
	Callback = function()
		Library:Toast({
			Title = "Custom",
			Content = "Toast with a custom icon",
			Icon = "rbxassetid://134724289526879",
			Duration = 4,
		})
	end,
})

ToastSection:AddButton({
	Title = "Toast Without Progress",
	Callback = function()
		Library:Toast({
			Title = "No Progress",
			Content = "Progress bar hidden",
			Progress = false,
			Duration = 4,
		})
	end,
})

local PanelSection = Tabs.Visual:AddSection("Side Panel")

PanelSection:AddButton({
	Title = "Open Side Panel",
	Callback = function()
		local Panel = Window:SidePanel({
			Side = "Right",
			Width = 320,
		})

		Panel:AddToggle("PanelToggle", { Title = "Panel Toggle", Default = false })
		Panel:AddSlider("PanelSlider", {
			Title = "Panel Slider",
			Default = 50,
			Min = 0,
			Max = 100,
			Rounding = 0,
		})
		Panel:AddInput("PanelInput", { Title = "Panel Input", Placeholder = "Type" })
		Panel:AddDropdown("PanelDropdown", {
			Title = "Panel Dropdown",
			Values = { "One", "Two", "Three" },
			Default = 1,
		})
		Panel:Button("Close", function()
			Panel:Close()
		end)
	end,
})

local SidebarSection = Window:AddSection({
	Title = "Collapsible Section",
	Collapsible = true,
})

local NestedTab = SidebarSection:AddTab({ Title = "Nested Tab", Icon = "folder" })
NestedTab:AddSection("Nested"):AddParagraph({
	Title = "Nested Tab",
	Content = "Tabs can live inside a collapsible sidebar section.",
})

local HeaderTab = Window:AddTabInHeader({ Title = "Header Tab", Icon = "layout-panel-top" })
HeaderTab:AddSection("Header"):AddParagraph({
	Title = "Header Tab",
	Content = "This tab sits in the window header.",
})

SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

local LightKimono = [==[{"AcrylicBorder":{"value":"D0CFD3","__type":"Color3"},"DialogInput":{"value":"F4F3F5","__type":"Color3"},"SubText":{"value":"6E6D73","__type":"Color3"},"MenuBackgroundRotation":90,"ColorpickerInputFocused":{"value":"FFFFFF","__type":"Color3"},"MenuBackground":{"value":[{"c":"F2F2F2","t":0},{"c":"F2F2F2","t":1}],"__type":"ColorSequence"},"ColorpickerButtonBorder":{"value":"B5B5B7","__type":"Color3"},"DropdownFrame":{"value":"EEEDEE","__type":"Color3"},"ColorpickerHolder":{"value":"F9F8FA","__type":"Color3"},"MenuHolderLine":{"value":"E1DFE1","__type":"Color3"},"DropdownOption":{"value":"E1DFE1","__type":"Color3"},"AcrylicMain":{"value":"FFFDFF","__type":"Color3"},"ColorpickerInputLine":{"value":"5A5A5F","__type":"Color3"},"InElementBorder":{"value":"D0CFD3","__type":"Color3"},"ElementBorder":{"value":"E1DFE1","__type":"Color3"},"__meta":{"Author":{"Name":"NazRizlspy","UserId":5228379950},"Name":"Light","CardGradient":["FFFFFF","B5B5B7"]},"DialogButtonBorder":{"value":"B5B5B7","__type":"Color3"},"Element":{"value":"E1DFE1","__type":"Color3"},"Hover":{"value":"D0CFD3","__type":"Color3"},"DropdownBorder":{"value":"D0CFD3","__type":"Color3"},"Text":{"value":"1C1C1E","__type":"Color3"},"TitleBarLine":{"value":"E1DFE1","__type":"Color3"},"Input":{"value":"EEEDEE","__type":"Color3"},"DialogInputLine":{"value":"5A5A5F","__type":"Color3"},"MenuInputFocused":{"value":"FFFFFF","__type":"Color3"},"MenuHolder":{"value":"F9F8FA","__type":"Color3"},"DialogHolderLine":{"value":"E1DFE1","__type":"Color3"},"MenuInputLine":{"value":"B5B5B7","__type":"Color3"},"ColorpickerButton":{"value":"FFFFFF","__type":"Color3"},"AcrylicNoise":0.93,"MenuInput":{"value":"EEEDEE","__type":"Color3"},"MenuButtonBorder":{"value":"D0CFD3","__type":"Color3"},"AcrylicGradient":{"value":[{"c":"FFFFFF","t":0},{"c":"EEEDEE","t":1}],"__type":"ColorSequence"},"InputIndicator":{"value":"5A5A5F","__type":"Color3"},"SliderRail":{"value":"D0CFD3","__type":"Color3"},"Dialog":{"value":"F9F8FA","__type":"Color3"},"Tab":{"value":"E1DFE1","__type":"Color3"},"MenuButton":{"value":"EEEDEE","__type":"Color3"},"AcrylicGradientRotation":350,"Background":{"Source":"https://raw.githubusercontent.com/StyearX/Assets/refs/heads/main/girlinkimono.lua"},"ColorpickerHolderLine":{"value":"E1DFE1","__type":"Color3"},"DialogBorder":{"value":"D0CFD3","__type":"Color3"},"MenuBorder":{"value":"D0CFD3","__type":"Color3"},"ToggleToggled":{"value":"FFFFFF","__type":"Color3"},"ColorpickerDialog":{"value":"F9F8FA","__type":"Color3"},"Keybind":{"value":"E1DFE1","__type":"Color3"},"ColorpickerDialogBorder":{"value":"D0CFD3","__type":"Color3"},"ColorpickerInput":{"value":"F4F3F5","__type":"Color3"},"DialogButton":{"value":"FFFFFF","__type":"Color3"},"HoverChange":0.07,"ElementTransparency":0.87,"InputFocused":{"value":"FFFFFF","__type":"Color3"},"BackgroundTransparency":0,"DialogHolder":{"value":"F4F3F5","__type":"Color3"},"ColorpickerInputBorder":{"value":"B5B5B7","__type":"Color3"},"ToggleSlider":{"value":"B5B5B7","__type":"Color3"},"DropdownHolder":{"value":"FFFDFF","__type":"Color3"},"Accent":{"value":"5A5A5F","__type":"Color3"}}]==]

local SakuraMidnight = [==[{"AcrylicBorder":{"value":"2A1B4A","__type":"Color3"},"DialogInput":{"value":"0B0A1A","__type":"Color3"},"SubText":{"value":"C6A8D9","__type":"Color3"},"MenuBackgroundRotation":90,"ColorpickerInputFocused":{"value":"0B0A1A","__type":"Color3"},"MenuBackground":{"value":[{"c":"2D2D2D","t":0},{"c":"2D2D2D","t":1}],"__type":"ColorSequence"},"ColorpickerButtonBorder":{"value":"6B2C6E","__type":"Color3"},"DropdownFrame":{"value":"793680","__type":"Color3"},"ColorpickerHolder":{"value":"120C24","__type":"Color3"},"MenuHolderLine":{"value":"1E1E1E","__type":"Color3"},"DropdownOption":{"value":"6B2C6E","__type":"Color3"},"AcrylicMain":{"value":"06031A","__type":"Color3"},"ColorpickerInputLine":{"value":"F4A6D7","__type":"Color3"},"InElementBorder":{"value":"3D2258","__type":"Color3"},"ElementBorder":{"value":"140E2E","__type":"Color3"},"__meta":{"Author":{"Name":"NazRizlspy","UserId":5228379950},"Name":"Sakura Midnight","CardGradient":["F4A6D7","140C2E"]},"DialogButtonBorder":{"value":"5A2870","__type":"Color3"},"Element":{"value":"6B2C6E","__type":"Color3"},"Hover":{"value":"4E2E6E","__type":"Color3"},"DropdownBorder":{"value":"04040F","__type":"Color3"},"Text":{"value":"F5ECF7","__type":"Color3"},"TitleBarLine":{"value":"2E1B52","__type":"Color3"},"Input":{"value":"793680","__type":"Color3"},"DialogInputLine":{"value":"F4A6D7","__type":"Color3"},"MenuInputFocused":{"value":"232323","__type":"Color3"},"MenuHolder":{"value":"232323","__type":"Color3"},"DialogHolderLine":{"value":"0D0A1E","__type":"Color3"},"MenuInputLine":{"value":"A0A0A0","__type":"Color3"},"ColorpickerButton":{"value":"000000","__type":"Color3"},"AcrylicNoise":0.93,"MenuInput":{"value":"373737","__type":"Color3"},"MenuButtonBorder":{"value":"505050","__type":"Color3"},"AcrylicGradient":{"value":[{"c":"F4A6D7","t":0},{"c":"06031A","t":1}],"__type":"ColorSequence"},"InputIndicator":{"value":"F27FC0","__type":"Color3"},"SliderRail":{"value":"6B2C6E","__type":"Color3"},"Dialog":{"value":"140C2E","__type":"Color3"},"Tab":{"value":"4E2E6E","__type":"Color3"},"MenuButton":{"value":"2D2D2D","__type":"Color3"},"AcrylicGradientRotation":350,"Background":{"Source":"https://raw.githubusercontent.com/StyearX/Assets/refs/heads/main/Animated.lua"},"ColorpickerHolderLine":{"value":"0D0A1E","__type":"Color3"},"DialogBorder":{"value":"6B2C6E","__type":"Color3"},"MenuBorder":{"value":"464646","__type":"Color3"},"ToggleToggled":{"value":"06031A","__type":"Color3"},"ColorpickerDialog":{"value":"140C2E","__type":"Color3"},"Keybind":{"value":"6B2C6E","__type":"Color3"},"ColorpickerDialogBorder":{"value":"6B2C6E","__type":"Color3"},"ColorpickerInput":{"value":"0B0A1A","__type":"Color3"},"DialogButton":{"value":"000000","__type":"Color3"},"HoverChange":0.07,"ElementTransparency":0.87,"InputFocused":{"value":"04040F","__type":"Color3"},"BackgroundTransparency":0,"DialogHolder":{"value":"120C24","__type":"Color3"},"ColorpickerInputBorder":{"value":"6B2C6E","__type":"Color3"},"ToggleSlider":{"value":"6B2C6E","__type":"Color3"},"DropdownHolder":{"value":"06031A","__type":"Color3"},"Accent":{"value":"F4A6D7","__type":"Color3"}}]==]

local CrimsonEclipse = [==[{"AcrylicBorder":{"value":"2A2A30","__type":"Color3"},"DialogInput":{"value":"0A0A0C","__type":"Color3"},"SubText":{"value":"A8A8B0","__type":"Color3"},"MenuBackgroundRotation":90,"ColorpickerInputFocused":{"value":"0A0A0C","__type":"Color3"},"MenuBackground":{"value":[{"c":"121216","t":0},{"c":"121216","t":1}],"__type":"ColorSequence"},"ColorpickerButtonBorder":{"value":"7A1020","__type":"Color3"},"DropdownFrame":{"value":"5C0F1A","__type":"Color3"},"ColorpickerHolder":{"value":"0F0F12","__type":"Color3"},"MenuHolderLine":{"value":"1E1E24","__type":"Color3"},"DropdownOption":{"value":"7A1020","__type":"Color3"},"AcrylicMain":{"value":"060608","__type":"Color3"},"ColorpickerInputLine":{"value":"E0182D","__type":"Color3"},"InElementBorder":{"value":"3A1218","__type":"Color3"},"ElementBorder":{"value":"16161A","__type":"Color3"},"__meta":{"Author":{"Name":"NazRizlspy","UserId":5228379950},"Name":"Crimson Eclipse","CardGradient":["E0182D","060608"]},"DialogButtonBorder":{"value":"7A1020","__type":"Color3"},"Element":{"value":"7A1020","__type":"Color3"},"Hover":{"value":"4A1018","__type":"Color3"},"DropdownBorder":{"value":"060608","__type":"Color3"},"Text":{"value":"F2F2F2","__type":"Color3"},"TitleBarLine":{"value":"3A1218","__type":"Color3"},"Input":{"value":"5C0F1A","__type":"Color3"},"DialogInputLine":{"value":"E0182D","__type":"Color3"},"MenuInputFocused":{"value":"1E1E24","__type":"Color3"},"MenuHolder":{"value":"16161A","__type":"Color3"},"DialogHolderLine":{"value":"1E1E24","__type":"Color3"},"MenuInputLine":{"value":"8A8A94","__type":"Color3"},"ColorpickerButton":{"value":"000000","__type":"Color3"},"AcrylicNoise":0.93,"MenuInput":{"value":"26262C","__type":"Color3"},"MenuButtonBorder":{"value":"3A3A42","__type":"Color3"},"AcrylicGradient":{"value":[{"c":"E0182D","t":0},{"c":"060608","t":1}],"__type":"ColorSequence"},"InputIndicator":{"value":"FF3347","__type":"Color3"},"SliderRail":{"value":"7A1020","__type":"Color3"},"Dialog":{"value":"0F0F12","__type":"Color3"},"Tab":{"value":"4A1018","__type":"Color3"},"MenuButton":{"value":"1E1E24","__type":"Color3"},"AcrylicGradientRotation":350,"Background":{"Source":"https://raw.githubusercontent.com/StyearX/Assets/refs/heads/main/Acheron.lua"},"ColorpickerHolderLine":{"value":"1E1E24","__type":"Color3"},"DialogBorder":{"value":"7A1020","__type":"Color3"},"MenuBorder":{"value":"3A3A42","__type":"Color3"},"ToggleToggled":{"value":"060608","__type":"Color3"},"ColorpickerDialog":{"value":"0F0F12","__type":"Color3"},"Keybind":{"value":"7A1020","__type":"Color3"},"ColorpickerDialogBorder":{"value":"7A1020","__type":"Color3"},"ColorpickerInput":{"value":"0A0A0C","__type":"Color3"},"DialogButton":{"value":"000000","__type":"Color3"},"HoverChange":0.07,"ElementTransparency":0.87,"InputFocused":{"value":"060608","__type":"Color3"},"BackgroundTransparency":0,"DialogHolder":{"value":"0F0F12","__type":"Color3"},"ColorpickerInputBorder":{"value":"7A1020","__type":"Color3"},"ToggleSlider":{"value":"7A1020","__type":"Color3"},"DropdownHolder":{"value":"060608","__type":"Color3"},"Accent":{"value":"E0182D","__type":"Color3"}}]==]

local PixelSixFont = [==[{"Name":"PixelSix10","Weight":"Medium","Style":"Normal","AssetId":"https://raw.githubusercontent.com/StyearX/Assets/refs/heads/main/pixelsix10.ttf"}]==]

InterfaceManager:ImportTheme(LightKimono, "Light Kimono")
InterfaceManager:ImportTheme(SakuraMidnight, "Sakura Midnight")
InterfaceManager:ImportTheme(CrimsonEclipse, "Crimson Eclipse")
InterfaceManager:ImportFont(PixelSixFont)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentReimagined")
SaveManager:SetFolder("FluentReimagined/Configs")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Library:Notify({
	Title = "Unknown Hub",
	Content = "Loaded",
	Duration = 5,
})

SaveManager:LoadAutoloadConfig()

local Skybox = loadstring(readfile("Skybox.lua"))()

Skybox:SetLibrary(FluentReimagined)
Skybox:SetFolder("FluentReimaginedScriptHub/Skyboxes")
Skybox:BuildSkyboxSection(Tabs.Visual)

local Lighting = loadstring(readfile("Lighting.lua"))()

Lighting:SetLibrary(FluentReimagined)
Lighting:BuildLightingSection(Tabs.Visual)

-- ignore this
local OpenGui = Instance.new("ScreenGui")
OpenGui.Name = "openshit"
OpenGui.Parent = LocalPlayer.PlayerGui
OpenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
OpenGui.ResetOnSpawn = false

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "mainopen"
OpenButton.Parent = OpenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
OpenButton.BackgroundTransparency = 1
OpenButton.Position = UDim2.new(0.101969875, 0, 0.110441767, 0)
OpenButton.Size = UDim2.new(0, 64, 0, 42)
OpenButton.Text = ""
OpenButton.Visible = true

local OpenButtonCorner = Instance.new("UICorner")
OpenButtonCorner.Parent = OpenButton

local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "RotatingBackground"
BackgroundImage.Parent = OpenButton
BackgroundImage.Size = UDim2.new(2.2 + 0.1, 0, 2.2 + 0.1, 0)
BackgroundImage.Position = UDim2.new(0.5, 0, 0.5, 0)
BackgroundImage.AnchorPoint = Vector2.new(0.5, 0.5)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "rbxassetid://115629468950993"
BackgroundImage.SizeConstraint = Enum.SizeConstraint.RelativeXX
BackgroundImage.ZIndex = 0

local FrontImage = Instance.new("ImageLabel")
FrontImage.Name = "StaticIcon"
FrontImage.Parent = OpenButton
FrontImage.Size = UDim2.new(0.85, 0, 1, 0)
FrontImage.Position = UDim2.new(0.5, 0, 0.5, 0)
FrontImage.AnchorPoint = Vector2.new(0.5, 0.5)
FrontImage.BackgroundTransparency = 1
FrontImage.Image = "rbxassetid://80277179956565"
FrontImage.ZIndex = 1
FrontImage.ScaleType = Enum.ScaleType.Stretch 

local FrontImageCorner = Instance.new("UICorner")
FrontImageCorner.CornerRadius = UDim.new(1, 0)
FrontImageCorner.Parent = FrontImage

local Rotation = 0
local Speed = 90 
local LastTime = tick()

task.spawn(function()
	while true do
		local Now = tick()
		local Delta = Now - LastTime
		LastTime = Now
		
		Rotation = (Rotation + Speed * Delta) % 360
		BackgroundImage.Rotation = Rotation

		task.wait()
	end
end)

local function MakeDraggable(TopbarObject, Object, Locked)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition

    local Holding = false
    local HoldTime = 1.0
    local MoveCancelThreshold = 6
    local HoldToken = 0

    Object:SetAttribute("Locked", Locked or false)

    local function Update(Input)
        if Object:GetAttribute("Locked") then return end
        local Delta = Input.Position - DragStart
        Object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end

    local function ToggleLock()
        local NewState = not Object:GetAttribute("Locked")
        Object:SetAttribute("Locked", NewState)

        Library:Notify({
            Title = NewState and "Button Locked" or "Button Unlocked",
            Content = NewState and "This button is now locked in place." or "This button can now be moved.",
            Duration = 2
        })
    end

    TopbarObject.InputBegan:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1
        and Input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        Dragging = not Object:GetAttribute("Locked")
        Holding = true
        DragStart = Input.Position
        StartPosition = Object.Position

        HoldToken += 1
        local Token = HoldToken

        task.delay(HoldTime, function()
            if Holding and Token == HoldToken then
                ToggleLock()
            end
        end)

        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
                Holding = false
            end
        end)
    end)

    TopbarObject.InputChanged:Connect(function(Input)
        if not DragStart then return end

        if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then
            if (Input.Position - DragStart).Magnitude > MoveCancelThreshold then
                Holding = false
            end
            DragInput = Input
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            Update(Input)
        end
    end)
end

MakeDraggable(OpenButton, OpenButton, false)

local function PlaySound(SoundId)
    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://" .. SoundId
    Sound.Parent = game:GetService("SoundService")
    Sound:Play()
    Sound.Ended:Connect(function()
        Sound:Destroy()
    end)
end

OpenButton.MouseButton1Click:Connect(function()
local SoundIds = { "7127123605", "137566474343039", "438666542", "257001341", "257000833", "7127123554", "131607746976396", "97325669841459", "109312518223078" }
    PlaySound(SoundIds[math.random(#SoundIds)])
    Window:Minimize()

    local function SmoothSpeed(Target, Duration)
        local Start = Speed
        local Steps = 30
        for Index = 1, Steps do
            Speed = Start + (Target - Start) * (Index / Steps)
            task.wait(Duration / Steps)
        end
        Speed = Target
    end
    
    SmoothSpeed(360, 0.4)
    task.wait(0.5)
    SmoothSpeed(180, 0.4)
    task.wait(0.3)
    SmoothSpeed(90, 0.4)
end)
