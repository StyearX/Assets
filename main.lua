local cloneref = (cloneref or clonereference or function(instance: any)
	return instance
end)
local AssetService: AssetService = cloneref(game:GetService("AssetService"))
local ContentProvider: ContentProvider = cloneref(game:GetService("ContentProvider"))
local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
local HttpService: HttpService = cloneref(game:GetService("HttpService"))
local Lighting: Lighting = cloneref(game:GetService("Lighting"))
local Players: Players = cloneref(game:GetService("Players"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local TextService: TextService = cloneref(game:GetService("TextService"))
local TweenService: TweenService = cloneref(game:GetService("TweenService"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local Workspace: Workspace = cloneref(game:GetService("Workspace"))

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local Themes = {
	Names = {
		"Dark",
		"Darker",
		"Light",
		"Aqua",
		"Amethyst",
		"Rose",
		"Crimson Noir",
		"Gold",
	},

	Dark = {
	Name = "Dark",
	Accent = Color3.fromRGB(96, 205, 255),

	AcrylicMain = Color3.fromRGB(60, 60, 60),
	AcrylicBorder = Color3.fromRGB(90, 90, 90),
	AcrylicBorderTransparency = 0.5,
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(40, 40, 40)),
	AcrylicGradientRotation = 90,
	AcrylicGradientTransparency = NumberSequence.new(0.4),
	AcrylicNoise = 0.9,
	Background = "",
	BackgroundTransparency = 0,

	TitleBarLine = Color3.fromRGB(75, 75, 75),
	TitleBarLineTransparency = 0.5,
	Tab = Color3.fromRGB(120, 120, 120),
	TabOverlay = Color3.fromRGB(120, 120, 120),
	ScrollBar = Color3.fromRGB(170, 170, 170),

	Element = Color3.fromRGB(120, 120, 120),
	ElementBorder = Color3.fromRGB(35, 35, 35),
	InElementBorder = Color3.fromRGB(90, 90, 90),
	ElementTransparency = 0.87,
	ElementBorderTransparency = 0.5,
	InElementBorderTransparency = 0.5,

	ToggleSlider = Color3.fromRGB(120, 120, 120),
	ToggleToggled = Color3.fromRGB(0, 0, 0),

	SliderRail = Color3.fromRGB(120, 120, 120),

	DropdownFrame = Color3.fromRGB(160, 160, 160),
	DropdownHolder = ColorSequence.new(Color3.fromRGB(56, 56, 56), Color3.fromRGB(36, 36, 36)),
	DropdownHolderRotation = 90,
	DropdownHolderTransparency = NumberSequence.new(0),
	DropdownBorder = Color3.fromRGB(35, 35, 35),
	DropdownBorderTransparency = 0,
	DropdownOption = Color3.fromRGB(120, 120, 120),

	Keybind = Color3.fromRGB(120, 120, 120),

	Input = Color3.fromRGB(160, 160, 160),
	InputFocused = Color3.fromRGB(10, 10, 10),
	InputIndicator = Color3.fromRGB(150, 150, 150),

	Dialog = Color3.fromRGB(45, 45, 45),
	DialogHolder = ColorSequence.new(Color3.fromRGB(45, 45, 45), Color3.fromRGB(27, 27, 27)),
	DialogHolderRotation = 90,
	DialogHolderTransparency = NumberSequence.new(0),
	DialogHolderLine = Color3.fromRGB(30, 30, 30),
	DialogButton = Color3.fromRGB(45, 45, 45),
	DialogButtonBorder = Color3.fromRGB(80, 80, 80),
	DialogBorder = Color3.fromRGB(70, 70, 70),
	DialogBorderTransparency = 0.3,
	DialogInput = Color3.fromRGB(55, 55, 55),
	DialogInputLine = Color3.fromRGB(160, 160, 160),
	DialogInputFocused = Color3.fromRGB(35, 35, 35),

	ColorpickerDialog = Color3.fromRGB(45, 45, 45),
	ColorpickerDialogBorder = Color3.fromRGB(70, 70, 70),
	ColorpickerHolder = ColorSequence.new(Color3.fromRGB(45, 45, 45), Color3.fromRGB(27, 27, 27)),
	ColorpickerHolderRotation = 90,
	ColorpickerHolderTransparency = NumberSequence.new(0),
	ColorpickerHolderLine = Color3.fromRGB(30, 30, 30),
	ColorpickerButton = Color3.fromRGB(45, 45, 45),
	ColorpickerButtonBorder = Color3.fromRGB(80, 80, 80),
	ColorpickerInput = Color3.fromRGB(55, 55, 55),
	ColorpickerInputLine = Color3.fromRGB(160, 160, 160),
	ColorpickerInputBorder = Color3.fromRGB(80, 80, 80),
	ColorpickerInputFocused = Color3.fromRGB(35, 35, 35),

	MenuBackground = ColorSequence.new(Color3.fromRGB(38, 38, 38), Color3.fromRGB(12, 12, 12)),
	MenuBackgroundRotation = 90,
	MenuBackgroundTransparency = NumberSequence.new(0),
	MenuBorder = Color3.fromRGB(72, 72, 72),
	MenuBorderTransparency = 0.5,
	MenuHolder = Color3.fromRGB(14, 14, 14),
	MenuHolderLine = Color3.fromRGB(40, 40, 40),
	MenuButton = Color3.fromRGB(30, 30, 30),
	MenuButtonBorder = Color3.fromRGB(66, 66, 66),
	MenuInput = Color3.fromRGB(24, 24, 24),
	MenuInputLine = Color3.fromRGB(160, 160, 160),
	MenuInputFocused = Color3.fromRGB(14, 14, 14),

	Text = Color3.fromRGB(240, 240, 240),
	SubText = Color3.fromRGB(170, 170, 170),
	Hover = Color3.fromRGB(120, 120, 120),
	HoverChange = 0.07,
},

	Darker = {
	Name = "Darker",
	Accent = Color3.fromRGB(72, 138, 182),

	AcrylicMain = Color3.fromRGB(30, 30, 30),
	AcrylicBorder = Color3.fromRGB(60, 60, 60),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(25, 25, 25), Color3.fromRGB(15, 15, 15)),
	AcrylicGradientRotation = 90,
	AcrylicGradientTransparency = NumberSequence.new(0.4),
	AcrylicNoise = 0.94,
	Background = "",
	BackgroundTransparency = 0,

	TitleBarLine = Color3.fromRGB(65, 65, 65),
	TitleBarLineTransparency = 0.5,
	Tab = Color3.fromRGB(100, 100, 100),
	TabOverlay = Color3.fromRGB(100, 100, 100),
	ScrollBar = Color3.fromRGB(170, 170, 170),

	Element = Color3.fromRGB(70, 70, 70),
	ElementBorder = Color3.fromRGB(25, 25, 25),
	InElementBorder = Color3.fromRGB(55, 55, 55),
	ElementTransparency = 0.82,

	DropdownFrame = Color3.fromRGB(120, 120, 120),
	DropdownHolder = ColorSequence.new(Color3.fromRGB(44, 44, 44), Color3.fromRGB(24, 24, 24)),
	DropdownHolderRotation = 90,
	DropdownHolderTransparency = NumberSequence.new(0),
	DropdownBorder = Color3.fromRGB(25, 25, 25),

	Dialog = Color3.fromRGB(35, 35, 35),
	DialogHolder = ColorSequence.new(Color3.fromRGB(32, 32, 32), Color3.fromRGB(20, 20, 20)),
	DialogHolderRotation = 90,
	DialogHolderTransparency = NumberSequence.new(0),
	DialogHolderLine = Color3.fromRGB(20, 20, 20),
	DialogButton = Color3.fromRGB(35, 35, 35),
	DialogButtonBorder = Color3.fromRGB(55, 55, 55),
	DialogBorder = Color3.fromRGB(50, 50, 50),
	DialogInput = Color3.fromRGB(45, 45, 45),
	DialogInputLine = Color3.fromRGB(120, 120, 120),
	DialogInputFocused = Color3.fromRGB(25, 25, 25),

	ColorpickerDialog = Color3.fromRGB(35, 35, 35),
	ColorpickerDialogBorder = Color3.fromRGB(50, 50, 50),
	ColorpickerHolder = ColorSequence.new(Color3.fromRGB(32, 32, 32), Color3.fromRGB(20, 20, 20)),
	ColorpickerHolderRotation = 90,
	ColorpickerHolderTransparency = NumberSequence.new(0),
	ColorpickerHolderLine = Color3.fromRGB(20, 20, 20),
	ColorpickerButton = Color3.fromRGB(35, 35, 35),
	ColorpickerButtonBorder = Color3.fromRGB(55, 55, 55),
	ColorpickerInput = Color3.fromRGB(45, 45, 45),
	ColorpickerInputLine = Color3.fromRGB(120, 120, 120),
	ColorpickerInputBorder = Color3.fromRGB(55, 55, 55),
	ColorpickerInputFocused = Color3.fromRGB(25, 25, 25),

	MenuBackground = ColorSequence.new(Color3.fromRGB(26, 26, 26), Color3.fromRGB(7, 7, 7)),
	MenuBackgroundRotation = 90,
	MenuBackgroundTransparency = NumberSequence.new(0),
	MenuBorder = Color3.fromRGB(58, 58, 58),
	MenuHolder = Color3.fromRGB(9, 9, 9),
	MenuHolderLine = Color3.fromRGB(30, 30, 30),
	MenuButton = Color3.fromRGB(22, 22, 22),
	MenuButtonBorder = Color3.fromRGB(52, 52, 52),
	MenuInput = Color3.fromRGB(17, 17, 17),
	MenuInputLine = Color3.fromRGB(130, 130, 130),
	MenuInputFocused = Color3.fromRGB(9, 9, 9),
},

	Light = {
	Name = "Light",
	Accent = Color3.fromRGB(90, 90, 95),

	AcrylicMain = Color3.fromRGB(255, 253, 255),
	AcrylicBorder = Color3.fromRGB(208, 207, 211),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(238, 237, 238)),
	AcrylicGradientRotation = 350,
	AcrylicGradientTransparency = NumberSequence.new(0.4),
	AcrylicNoise = 0.93,
	Background = "",
	BackgroundTransparency = 0,

	TitleBarLine = Color3.fromRGB(225, 223, 225),
	TitleBarLineTransparency = 0.5,
	Tab = Color3.fromRGB(225, 223, 225),
	TabOverlay = Color3.fromRGB(90, 90, 90),
	ScrollBar = Color3.fromRGB(110, 110, 110),

	Element = Color3.fromRGB(225, 223, 225),
	ElementBorder = Color3.fromRGB(225, 223, 225),
	InElementBorder = Color3.fromRGB(208, 207, 211),
	ElementTransparency = 0.87,

	ToggleSlider = Color3.fromRGB(181, 181, 183),
	ToggleToggled = Color3.fromRGB(255, 255, 255),

	SliderRail = Color3.fromRGB(208, 207, 211),

	DropdownFrame = Color3.fromRGB(238, 237, 238),
	DropdownHolder = ColorSequence.new(Color3.fromRGB(255, 253, 255), Color3.fromRGB(244, 243, 245)),
	DropdownHolderRotation = 90,
	DropdownHolderTransparency = NumberSequence.new(0),
	DropdownBorder = Color3.fromRGB(208, 207, 211),
	DropdownOption = Color3.fromRGB(225, 223, 225),

	Keybind = Color3.fromRGB(225, 223, 225),

	Input = Color3.fromRGB(238, 237, 238),
	InputFocused = Color3.fromRGB(255, 255, 255),
	InputIndicator = Color3.fromRGB(90, 90, 95),

	Dialog = Color3.fromRGB(249, 248, 250),
	DialogHolder = ColorSequence.new(Color3.fromRGB(254, 253, 255), Color3.fromRGB(229, 228, 230)),
	DialogHolderRotation = 90,
	DialogHolderTransparency = NumberSequence.new(0),
	DialogHolderLine = Color3.fromRGB(225, 223, 225),
	DialogButton = Color3.fromRGB(255, 255, 255),
	DialogButtonBorder = Color3.fromRGB(181, 181, 183),
	DialogBorder = Color3.fromRGB(208, 207, 211),
	DialogInput = Color3.fromRGB(244, 243, 245),
	DialogInputLine = Color3.fromRGB(90, 90, 95),
	DialogInputFocused = Color3.fromRGB(244, 243, 245),

	ColorpickerDialog = Color3.fromRGB(249, 248, 250),
	ColorpickerDialogBorder = Color3.fromRGB(208, 207, 211),
	ColorpickerHolder = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(234, 233, 235)),
	ColorpickerHolderRotation = 90,
	ColorpickerHolderTransparency = NumberSequence.new(0),
	ColorpickerHolderLine = Color3.fromRGB(225, 223, 225),
	ColorpickerButton = Color3.fromRGB(255, 255, 255),
	ColorpickerButtonBorder = Color3.fromRGB(181, 181, 183),
	ColorpickerInput = Color3.fromRGB(244, 243, 245),
	ColorpickerInputLine = Color3.fromRGB(90, 90, 95),
	ColorpickerInputBorder = Color3.fromRGB(181, 181, 183),
	ColorpickerInputFocused = Color3.fromRGB(255, 255, 255),

	MenuBackground = ColorSequence.new(Color3.fromRGB(242, 242, 242), Color3.fromRGB(242, 242, 242)),
	MenuBackgroundRotation = 90,
	MenuBackgroundTransparency = NumberSequence.new(0),
	MenuBorder = Color3.fromRGB(208, 207, 211),
	MenuHolder = Color3.fromRGB(249, 248, 250),
	MenuHolderLine = Color3.fromRGB(225, 223, 225),
	MenuButton = Color3.fromRGB(238, 237, 238),
	MenuButtonBorder = Color3.fromRGB(208, 207, 211),
	MenuInput = Color3.fromRGB(238, 237, 238),
	MenuInputLine = Color3.fromRGB(181, 181, 183),
	MenuInputFocused = Color3.fromRGB(255, 255, 255),

	Text = Color3.fromRGB(28, 28, 30),
	SubText = Color3.fromRGB(110, 109, 115),
	Hover = Color3.fromRGB(208, 207, 211),
	HoverChange = 0.07,
},

	Aqua = {
	Name = "Aqua",
	Accent = Color3.fromRGB(60, 165, 165),

	AcrylicMain = Color3.fromRGB(20, 20, 20),
	AcrylicBorder = Color3.fromRGB(50, 100, 100),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(60, 140, 140), Color3.fromRGB(40, 80, 80)),
	AcrylicGradientRotation = 90,
	AcrylicGradientTransparency = NumberSequence.new(0.4),
	AcrylicNoise = 0.92,
	Background = "",
	BackgroundTransparency = 0,

	TitleBarLine = Color3.fromRGB(60, 120, 120),
	TitleBarLineTransparency = 0.5,
	Tab = Color3.fromRGB(140, 180, 180),
	TabOverlay = Color3.fromRGB(140, 180, 180),
	ScrollBar = Color3.fromRGB(170, 170, 170),

	Element = Color3.fromRGB(110, 160, 160),
	ElementBorder = Color3.fromRGB(40, 70, 70),
	InElementBorder = Color3.fromRGB(80, 110, 110),
	ElementTransparency = 0.84,

	ToggleSlider = Color3.fromRGB(110, 160, 160),
	ToggleToggled = Color3.fromRGB(0, 0, 0),

	SliderRail = Color3.fromRGB(110, 160, 160),

	DropdownFrame = Color3.fromRGB(160, 200, 200),
	DropdownHolder = ColorSequence.new(Color3.fromRGB(54, 108, 108), Color3.fromRGB(28, 58, 58)),
	DropdownHolderRotation = 90,
	DropdownHolderTransparency = NumberSequence.new(0),
	DropdownBorder = Color3.fromRGB(40, 65, 65),
	DropdownOption = Color3.fromRGB(110, 160, 160),

	Keybind = Color3.fromRGB(110, 160, 160),

	Input = Color3.fromRGB(110, 160, 160),
	InputFocused = Color3.fromRGB(20, 10, 30),
	InputIndicator = Color3.fromRGB(130, 170, 170),

	Dialog = Color3.fromRGB(40, 80, 80),
	DialogHolder = ColorSequence.new(Color3.fromRGB(38, 77, 77), Color3.fromRGB(23, 47, 47)),
	DialogHolderRotation = 90,
	DialogHolderTransparency = NumberSequence.new(0),
	DialogHolderLine = Color3.fromRGB(25, 50, 50),
	DialogButton = Color3.fromRGB(40, 80, 80),
	DialogButtonBorder = Color3.fromRGB(80, 110, 110),
	DialogBorder = Color3.fromRGB(50, 100, 100),
	DialogInput = Color3.fromRGB(45, 90, 90),
	DialogInputLine = Color3.fromRGB(130, 170, 170),
	DialogInputFocused = Color3.fromRGB(30, 60, 60),

	ColorpickerDialog = Color3.fromRGB(40, 80, 80),
	ColorpickerDialogBorder = Color3.fromRGB(50, 100, 100),
	ColorpickerHolder = ColorSequence.new(Color3.fromRGB(38, 77, 77), Color3.fromRGB(23, 47, 47)),
	ColorpickerHolderRotation = 90,
	ColorpickerHolderTransparency = NumberSequence.new(0),
	ColorpickerHolderLine = Color3.fromRGB(25, 50, 50),
	ColorpickerButton = Color3.fromRGB(40, 80, 80),
	ColorpickerButtonBorder = Color3.fromRGB(80, 110, 110),
	ColorpickerInput = Color3.fromRGB(45, 90, 90),
	ColorpickerInputLine = Color3.fromRGB(130, 170, 170),
	ColorpickerInputBorder = Color3.fromRGB(80, 110, 110),
	ColorpickerInputFocused = Color3.fromRGB(30, 60, 60),

	MenuBackground = ColorSequence.new(Color3.fromRGB(42, 98, 98), Color3.fromRGB(8, 16, 16)),
	MenuBackgroundRotation = 90,
	MenuBackgroundTransparency = NumberSequence.new(0),
	MenuBorder = Color3.fromRGB(57, 133, 133),
	MenuHolder = Color3.fromRGB(13, 24, 24),
	MenuHolderLine = Color3.fromRGB(24, 56, 56),
	MenuButton = Color3.fromRGB(14, 26, 26),
	MenuButtonBorder = Color3.fromRGB(45, 105, 105),
	MenuInput = Color3.fromRGB(16, 28, 28),
	MenuInputLine = Color3.fromRGB(148, 206, 206),
	MenuInputFocused = Color3.fromRGB(8, 15, 15),

	Text = Color3.fromRGB(240, 240, 240),
	SubText = Color3.fromRGB(170, 170, 170),
	Hover = Color3.fromRGB(110, 160, 160),
	HoverChange = 0.04,
},

	Amethyst = {
	Name = "Amethyst",
	Accent = Color3.fromRGB(97, 62, 167),

	AcrylicMain = Color3.fromRGB(20, 20, 20),
	AcrylicBorder = Color3.fromRGB(110, 90, 130),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(85, 57, 139), Color3.fromRGB(40, 25, 65)),
	AcrylicGradientRotation = 90,
	AcrylicGradientTransparency = NumberSequence.new(0.4),
	AcrylicNoise = 0.92,
	Background = "",
	BackgroundTransparency = 0,

	TitleBarLine = Color3.fromRGB(95, 75, 110),
	TitleBarLineTransparency = 0.5,
	Tab = Color3.fromRGB(160, 140, 180),
	TabOverlay = Color3.fromRGB(160, 140, 180),
	ScrollBar = Color3.fromRGB(170, 170, 170),

	Element = Color3.fromRGB(140, 120, 160),
	ElementBorder = Color3.fromRGB(60, 50, 70),
	InElementBorder = Color3.fromRGB(100, 90, 110),
	ElementTransparency = 0.87,

	ToggleSlider = Color3.fromRGB(140, 120, 160),
	ToggleToggled = Color3.fromRGB(0, 0, 0),

	SliderRail = Color3.fromRGB(140, 120, 160),

	DropdownFrame = Color3.fromRGB(170, 160, 200),
	DropdownHolder = ColorSequence.new(Color3.fromRGB(78, 58, 106), Color3.fromRGB(42, 30, 60)),
	DropdownHolderRotation = 90,
	DropdownHolderTransparency = NumberSequence.new(0),
	DropdownBorder = Color3.fromRGB(50, 40, 65),
	DropdownOption = Color3.fromRGB(140, 120, 160),

	Keybind = Color3.fromRGB(140, 120, 160),

	Input = Color3.fromRGB(140, 120, 160),
	InputFocused = Color3.fromRGB(20, 10, 30),
	InputIndicator = Color3.fromRGB(170, 150, 190),

	Dialog = Color3.fromRGB(60, 45, 80),
	DialogHolder = ColorSequence.new(Color3.fromRGB(58, 38, 83), Color3.fromRGB(35, 23, 51)),
	DialogHolderRotation = 90,
	DialogHolderTransparency = NumberSequence.new(0),
	DialogHolderLine = Color3.fromRGB(40, 25, 60),
	DialogButton = Color3.fromRGB(60, 45, 80),
	DialogButtonBorder = Color3.fromRGB(95, 80, 110),
	DialogBorder = Color3.fromRGB(85, 70, 100),
	DialogInput = Color3.fromRGB(70, 55, 85),
	DialogInputLine = Color3.fromRGB(175, 160, 190),
	DialogInputFocused = Color3.fromRGB(45, 30, 65),

	ColorpickerDialog = Color3.fromRGB(60, 45, 80),
	ColorpickerDialogBorder = Color3.fromRGB(85, 70, 100),
	ColorpickerHolder = ColorSequence.new(Color3.fromRGB(58, 38, 83), Color3.fromRGB(35, 23, 51)),
	ColorpickerHolderRotation = 90,
	ColorpickerHolderTransparency = NumberSequence.new(0),
	ColorpickerHolderLine = Color3.fromRGB(40, 25, 60),
	ColorpickerButton = Color3.fromRGB(60, 45, 80),
	ColorpickerButtonBorder = Color3.fromRGB(95, 80, 110),
	ColorpickerInput = Color3.fromRGB(70, 55, 85),
	ColorpickerInputLine = Color3.fromRGB(175, 160, 190),
	ColorpickerInputBorder = Color3.fromRGB(95, 80, 110),
	ColorpickerInputFocused = Color3.fromRGB(45, 30, 65),

	MenuBackground = ColorSequence.new(Color3.fromRGB(59, 40, 97), Color3.fromRGB(8, 5, 13)),
	MenuBackgroundRotation = 90,
	MenuBackgroundTransparency = NumberSequence.new(0),
	MenuBorder = Color3.fromRGB(81, 54, 132),
	MenuHolder = Color3.fromRGB(13, 9, 20),
	MenuHolderLine = Color3.fromRGB(34, 23, 56),
	MenuButton = Color3.fromRGB(18, 14, 25),
	MenuButtonBorder = Color3.fromRGB(64, 43, 104),
	MenuInput = Color3.fromRGB(20, 15, 28),
	MenuInputLine = Color3.fromRGB(168, 149, 207),
	MenuInputFocused = Color3.fromRGB(8, 6, 12),

	Text = Color3.fromRGB(240, 240, 240),
	SubText = Color3.fromRGB(170, 170, 170),
	Hover = Color3.fromRGB(140, 120, 160),
	HoverChange = 0.04,
},

	Rose = {
	Name = "Rose",
	Accent = Color3.fromRGB(180, 55, 90),

	AcrylicMain = Color3.fromRGB(40, 40, 40),
	AcrylicBorder = Color3.fromRGB(130, 90, 110),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(190, 60, 135), Color3.fromRGB(165, 50, 70)),
	AcrylicGradientRotation = 90,
	AcrylicGradientTransparency = NumberSequence.new(0.4),
	AcrylicNoise = 0.92,
	Background = "",
	BackgroundTransparency = 0,

	TitleBarLine = Color3.fromRGB(140, 85, 105),
	TitleBarLineTransparency = 0.5,
	Tab = Color3.fromRGB(180, 140, 160),
	TabOverlay = Color3.fromRGB(180, 140, 160),
	ScrollBar = Color3.fromRGB(170, 170, 170),

	Element = Color3.fromRGB(200, 120, 170),
	ElementBorder = Color3.fromRGB(110, 70, 85),
	InElementBorder = Color3.fromRGB(120, 90, 90),
	ElementTransparency = 0.86,

	ToggleSlider = Color3.fromRGB(200, 120, 170),
	ToggleToggled = Color3.fromRGB(0, 0, 0),

	SliderRail = Color3.fromRGB(200, 120, 170),

	DropdownFrame = Color3.fromRGB(200, 160, 180),
	DropdownHolder = ColorSequence.new(Color3.fromRGB(150, 64, 95), Color3.fromRGB(92, 38, 58)),
	DropdownHolderRotation = 90,
	DropdownHolderTransparency = NumberSequence.new(0),
	DropdownBorder = Color3.fromRGB(90, 40, 55),
	DropdownOption = Color3.fromRGB(200, 120, 170),

	Keybind = Color3.fromRGB(200, 120, 170),

	Input = Color3.fromRGB(200, 120, 170),
	InputFocused = Color3.fromRGB(20, 10, 30),
	InputIndicator = Color3.fromRGB(170, 150, 190),

	Dialog = Color3.fromRGB(120, 50, 75),
	DialogHolder = ColorSequence.new(Color3.fromRGB(122, 51, 77), Color3.fromRGB(74, 31, 47)),
	DialogHolderRotation = 90,
	DialogHolderTransparency = NumberSequence.new(0),
	DialogHolderLine = Color3.fromRGB(90, 35, 55),
	DialogButton = Color3.fromRGB(120, 50, 75),
	DialogButtonBorder = Color3.fromRGB(155, 90, 115),
	DialogBorder = Color3.fromRGB(100, 70, 90),
	DialogInput = Color3.fromRGB(135, 55, 80),
	DialogInputLine = Color3.fromRGB(190, 160, 180),
	DialogInputFocused = Color3.fromRGB(95, 40, 60),

	ColorpickerDialog = Color3.fromRGB(120, 50, 75),
	ColorpickerDialogBorder = Color3.fromRGB(100, 70, 90),
	ColorpickerHolder = ColorSequence.new(Color3.fromRGB(122, 51, 77), Color3.fromRGB(74, 31, 47)),
	ColorpickerHolderRotation = 90,
	ColorpickerHolderTransparency = NumberSequence.new(0),
	ColorpickerHolderLine = Color3.fromRGB(90, 35, 55),
	ColorpickerButton = Color3.fromRGB(120, 50, 75),
	ColorpickerButtonBorder = Color3.fromRGB(155, 90, 115),
	ColorpickerInput = Color3.fromRGB(135, 55, 80),
	ColorpickerInputLine = Color3.fromRGB(190, 160, 180),
	ColorpickerInputBorder = Color3.fromRGB(155, 90, 115),
	ColorpickerInputFocused = Color3.fromRGB(95, 40, 60),

	MenuBackground = ColorSequence.new(Color3.fromRGB(133, 42, 94), Color3.fromRGB(18, 6, 9)),
	MenuBackgroundRotation = 90,
	MenuBackgroundTransparency = NumberSequence.new(0),
	MenuBorder = Color3.fromRGB(180, 57, 128),
	MenuHolder = Color3.fromRGB(24, 9, 13),
	MenuHolderLine = Color3.fromRGB(76, 24, 54),
	MenuButton = Color3.fromRGB(33, 14, 25),
	MenuButtonBorder = Color3.fromRGB(142, 45, 101),
	MenuInput = Color3.fromRGB(36, 16, 28),
	MenuInputLine = Color3.fromRGB(214, 145, 164),
	MenuInputFocused = Color3.fromRGB(16, 6, 9),

	Text = Color3.fromRGB(240, 240, 240),
	SubText = Color3.fromRGB(170, 170, 170),
	Hover = Color3.fromRGB(200, 120, 170),
	HoverChange = 0.04,
},

	["Crimson Noir"] = {
	Name = "Crimson Noir",
	Accent = Color3.fromRGB(197, 3, 55),

	AcrylicMain = Color3.fromRGB(10, 6, 10),
	AcrylicBorder = Color3.fromRGB(90, 12, 35),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(197, 3, 55), Color3.fromRGB(2, 6, 14)),
	AcrylicGradientRotation = 90,
	AcrylicGradientTransparency = NumberSequence.new(0.4),
	AcrylicNoise = 0.93,
	Background = "",
	BackgroundTransparency = 0,

	TitleBarLine = Color3.fromRGB(80, 12, 35),
	TitleBarLineTransparency = 0.5,
	Tab = Color3.fromRGB(110, 18, 45),
	TabOverlay = Color3.fromRGB(110, 18, 45),
	ScrollBar = Color3.fromRGB(170, 170, 170),

	Element = Color3.fromRGB(130, 12, 40),
	ElementBorder = Color3.fromRGB(35, 6, 15),
	InElementBorder = Color3.fromRGB(90, 15, 32),
	ElementTransparency = 0.87,

	ToggleSlider = Color3.fromRGB(130, 12, 40),
	ToggleToggled = Color3.fromRGB(2, 6, 14),

	SliderRail = Color3.fromRGB(130, 12, 40),

	DropdownFrame = Color3.fromRGB(150, 18, 48),
	DropdownHolder = ColorSequence.new(Color3.fromRGB(38, 10, 18), Color3.fromRGB(8, 4, 8)),
	DropdownHolderRotation = 90,
	DropdownHolderTransparency = NumberSequence.new(0),
	DropdownBorder = Color3.fromRGB(6, 4, 8),
	DropdownOption = Color3.fromRGB(130, 12, 40),

	Keybind = Color3.fromRGB(130, 12, 40),

	Input = Color3.fromRGB(150, 18, 48),
	InputFocused = Color3.fromRGB(6, 4, 9),
	InputIndicator = Color3.fromRGB(190, 25, 60),

	Dialog = Color3.fromRGB(40, 5, 14),
	DialogHolder = ColorSequence.new(Color3.fromRGB(36, 5, 13), Color3.fromRGB(22, 3, 8)),
	DialogHolderRotation = 90,
	DialogHolderTransparency = NumberSequence.new(0),
	DialogHolderLine = Color3.fromRGB(20, 3, 7),
	DialogButton = Color3.fromRGB(0, 0, 0),
	DialogButtonBorder = Color3.fromRGB(120, 3, 38),
	DialogBorder = Color3.fromRGB(110, 3, 35),
	DialogInput = Color3.fromRGB(20, 8, 13),
	DialogInputLine = Color3.fromRGB(230, 30, 70),
	DialogInputFocused = Color3.fromRGB(28, 4, 10),

	ColorpickerDialog = Color3.fromRGB(40, 5, 14),
	ColorpickerDialogBorder = Color3.fromRGB(110, 3, 35),
	ColorpickerHolder = ColorSequence.new(Color3.fromRGB(36, 5, 13), Color3.fromRGB(22, 3, 8)),
	ColorpickerHolderRotation = 90,
	ColorpickerHolderTransparency = NumberSequence.new(0),
	ColorpickerHolderLine = Color3.fromRGB(20, 3, 7),
	ColorpickerButton = Color3.fromRGB(0, 0, 0),
	ColorpickerButtonBorder = Color3.fromRGB(110, 3, 35),
	ColorpickerInput = Color3.fromRGB(20, 8, 13),
	ColorpickerInputLine = Color3.fromRGB(230, 30, 70),
	ColorpickerInputBorder = Color3.fromRGB(110, 3, 35),
	ColorpickerInputFocused = Color3.fromRGB(20, 8, 13),

	MenuBackground = ColorSequence.new(Color3.fromRGB(138, 14, 44), Color3.fromRGB(5, 3, 5)),
	MenuBackgroundRotation = 90,
	MenuBackgroundTransparency = NumberSequence.new(0),
	MenuBorder = Color3.fromRGB(170, 20, 60),
	MenuHolder = Color3.fromRGB(9, 5, 7),
	MenuHolderLine = Color3.fromRGB(60, 14, 26),
	MenuButton = Color3.fromRGB(20, 12, 15),
	MenuButtonBorder = Color3.fromRGB(96, 14, 36),
	MenuInput = Color3.fromRGB(30, 18, 22),
	MenuInputLine = Color3.fromRGB(255, 60, 100),
	MenuInputFocused = Color3.fromRGB(8, 6, 8),

	Text = Color3.fromRGB(245, 235, 237),
	SubText = Color3.fromRGB(190, 130, 145),
	Hover = Color3.fromRGB(110, 18, 45),
	HoverChange = 0.07,
},

	Gold = {
	Name = "Gold",
	Accent = Color3.fromRGB(255, 198, 41),

	AcrylicMain = Color3.fromRGB(58, 43, 8),
	AcrylicBorder = Color3.fromRGB(130, 98, 22),
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(120, 90, 18), Color3.fromRGB(55, 40, 8)),
	AcrylicGradientRotation = 90,
	AcrylicGradientTransparency = NumberSequence.new(0.4),
	AcrylicNoise = 0.93,
	Background = "",
	BackgroundTransparency = 0,

	TitleBarLine = Color3.fromRGB(125, 94, 20),
	TitleBarLineTransparency = 0.5,
	Tab = Color3.fromRGB(160, 122, 38),
	TabOverlay = Color3.fromRGB(160, 122, 38),
	ScrollBar = Color3.fromRGB(170, 170, 170),

	Element = Color3.fromRGB(140, 106, 28),
	ElementBorder = Color3.fromRGB(85, 63, 12),
	InElementBorder = Color3.fromRGB(115, 88, 20),
	ElementTransparency = 0.87,

	ToggleSlider = Color3.fromRGB(140, 106, 28),
	ToggleToggled = Color3.fromRGB(255, 255, 255),

	SliderRail = Color3.fromRGB(140, 106, 28),

	DropdownFrame = Color3.fromRGB(190, 148, 48),
	DropdownHolder = ColorSequence.new(Color3.fromRGB(86, 64, 16), Color3.fromRGB(44, 32, 7)),
	DropdownHolderRotation = 90,
	DropdownHolderTransparency = NumberSequence.new(0),
	DropdownBorder = Color3.fromRGB(52, 39, 8),
	DropdownOption = Color3.fromRGB(140, 106, 28),

	Keybind = Color3.fromRGB(140, 106, 28),

	Input = Color3.fromRGB(190, 148, 48),
	InputFocused = Color3.fromRGB(48, 35, 8),
	InputIndicator = Color3.fromRGB(215, 172, 55),

	Dialog = Color3.fromRGB(68, 51, 13),
	DialogHolder = ColorSequence.new(Color3.fromRGB(67, 50, 12), Color3.fromRGB(41, 30, 7)),
	DialogHolderRotation = 90,
	DialogHolderTransparency = NumberSequence.new(0),
	DialogHolderLine = Color3.fromRGB(42, 31, 7),
	DialogButton = Color3.fromRGB(68, 51, 13),
	DialogButtonBorder = Color3.fromRGB(105, 79, 19),
	DialogBorder = Color3.fromRGB(125, 94, 20),
	DialogInput = Color3.fromRGB(78, 58, 15),
	DialogInputLine = Color3.fromRGB(230, 188, 62),
	DialogInputFocused = Color3.fromRGB(52, 39, 9),

	ColorpickerDialog = Color3.fromRGB(68, 51, 13),
	ColorpickerDialogBorder = Color3.fromRGB(125, 94, 20),
	ColorpickerHolder = ColorSequence.new(Color3.fromRGB(67, 50, 12), Color3.fromRGB(41, 30, 7)),
	ColorpickerHolderRotation = 90,
	ColorpickerHolderTransparency = NumberSequence.new(0),
	ColorpickerHolderLine = Color3.fromRGB(42, 31, 7),
	ColorpickerButton = Color3.fromRGB(68, 51, 13),
	ColorpickerButtonBorder = Color3.fromRGB(105, 79, 19),
	ColorpickerInput = Color3.fromRGB(78, 58, 15),
	ColorpickerInputLine = Color3.fromRGB(230, 188, 62),
	ColorpickerInputBorder = Color3.fromRGB(105, 79, 19),
	ColorpickerInputFocused = Color3.fromRGB(52, 39, 9),

	MenuBackground = ColorSequence.new(Color3.fromRGB(84, 63, 13), Color3.fromRGB(11, 8, 2)),
	MenuBackgroundRotation = 90,
	MenuBackgroundTransparency = NumberSequence.new(0),
	MenuBorder = Color3.fromRGB(114, 86, 17),
	MenuHolder = Color3.fromRGB(17, 13, 4),
	MenuHolderLine = Color3.fromRGB(48, 36, 7),
	MenuButton = Color3.fromRGB(23, 19, 9),
	MenuButtonBorder = Color3.fromRGB(90, 68, 14),
	MenuInput = Color3.fromRGB(25, 20, 9),
	MenuInputLine = Color3.fromRGB(255, 224, 137),
	MenuInputFocused = Color3.fromRGB(11, 8, 3),

	Text = Color3.fromRGB(255, 248, 225),
	SubText = Color3.fromRGB(215, 185, 115),
	Hover = Color3.fromRGB(160, 122, 38),
	HoverChange = 0.07,
},
}

local Elements

local Library = {
	Version = "1.0.2",

	InternalIcons = {
		ChevronDown = "rbxassetid://134243273101015",
		Check = "rbxassetid://93898873302694",
		Plus = "rbxassetid://111774323017047",
		Minus = "rbxassetid://118026365011536",
		Info = "rbxassetid://124560466474914",
		CircleCheck = "rbxassetid://85262178816537",
		TriangleAlert = "rbxassetid://125920361880643",
		CircleX = "rbxassetid://76821953846248",
		Lock = "rbxassetid://134724289526879",
		Copy = "rbxassetid://78979572434545",
		Code = "rbxassetid://107380207681249",
		Trash = "rbxassetid://109843431391323",
		Save = "rbxassetid://126116963775616",
		SaveAll = "rbxassetid://116946975799440",
		Download = "rbxassetid://134814648082393",
		Refresh = "rbxassetid://138133190015277",
		Pin = "rbxassetid://120978111007514",
		FolderOpen = "rbxassetid://76018996254888",
		TextCursorInput = "rbxassetid://107551944047171",
	},

	OpenFrames = {},
	Options = {},
	Themes = Themes.Names,

	Window = nil,
	WindowFrame = nil,
	Unloaded = false,

	Theme = "Dark",
	Font = "rbxasset://fonts/families/GothamSSm.json",
	DialogOpen = false,
	UseAcrylic = false,
	Acrylic = false,
	Transparency = 0.35,
	MinimizeKeybind = nil,
	MinimizeKey = Enum.KeyCode.LeftControl,
	DisableBackground = false,
	KeepWindowInsideFrame = true,
	BoundaryMargin = 8,
	BoundaryInset = { Top = 0, Bottom = 0, Left = 0, Right = 0 },
	CustomThemeData = nil,
	PanelSizes = {},
	SeasonalHats = {
		Enabled = false,
		Force = nil,
	},
}

local function isMotor(value)
	local motorType = tostring(value):match("^Motor%((.+)%)$")

	if motorType then
		return true, motorType
	else
		return false
	end
end

local Connection = {}
Connection.__index = Connection

function Connection.new(signal, handler)
	return setmetatable({
		signal = signal,
		connected = true,
		_handler = handler,
	}, Connection)
end

function Connection:disconnect()
	if self.connected then
		self.connected = false

		for index, connection in pairs(self.signal._connections) do
			if connection == self then
				table.remove(self.signal._connections, index)
				return
			end
		end
	end
end

local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		_connections = {},
		_threads = {},
	}, Signal)
end

function Signal:fire(...)
	for _, connection in pairs(self._connections) do
		connection._handler(...)
	end

	for _, thread in pairs(self._threads) do
		coroutine.resume(thread, ...)
	end

	self._threads = {}
end

function Signal:connect(handler)
	local connection = Connection.new(self, handler)
	table.insert(self._connections, connection)
	return connection
end

function Signal:wait()
	table.insert(self._threads, coroutine.running())
	return coroutine.yield()
end

local Linear = {}
Linear.__index = Linear

function Linear.new(targetValue, options)
	assert(targetValue, "Missing argument #1: targetValue")

	options = options or {}

	return setmetatable({
		_targetValue = targetValue,
		_velocity = options.velocity or 1,
	}, Linear)
end

function Linear:step(state, dt)
	local position = state.value
	local velocity = self._velocity
	local goal = self._targetValue

	local dPos = dt * velocity

	local complete = dPos >= math.abs(goal - position)
	position = position + dPos * (goal > position and 1 or -1)
	if complete then
		position = self._targetValue
		velocity = 0
	end

	return {
		complete = complete,
		value = position,
		velocity = velocity,
	}
end

local Instant = {}
Instant.__index = Instant

function Instant.new(targetValue)
	return setmetatable({
		_targetValue = targetValue,
	}, Instant)
end

function Instant:step()
	return {
		complete = true,
		value = self._targetValue,
	}
end

local VELOCITY_THRESHOLD = 0.001
local POSITION_THRESHOLD = 0.001

local EPS = 0.0001

local Spring = {}
Spring.__index = Spring

function Spring.new(targetValue, options)
	assert(targetValue, "Missing argument #1: targetValue")
	options = options or {}

	return setmetatable({
		_targetValue = targetValue,
		_frequency = options.frequency or 4,
		_dampingRatio = options.dampingRatio or 1,
	}, Spring)
end

function Spring:step(state, dt)

	local d = self._dampingRatio
	local f = self._frequency * 2 * math.pi
	local g = self._targetValue
	local p0 = state.value
	local v0 = state.velocity or 0

	local offset = p0 - g
	local decay = math.exp(-d * f * dt)

	local p1, v1

	if d == 1 then
		p1 = (offset * (1 + f * dt) + v0 * dt) * decay + g
		v1 = (v0 * (1 - f * dt) - offset * (f * f * dt)) * decay
	elseif d < 1 then
		local c = math.sqrt(1 - d * d)

		local i = math.cos(f * c * dt)
		local j = math.sin(f * c * dt)

		local z
		if c > EPS then
			z = j / c
		else
			local a = dt * f
			z = a + ((a * a) * (c * c) * (c * c) / 20 - c * c) * (a * a * a) / 6
		end

		local y
		if f * c > EPS then
			y = j / (f * c)
		else
			local b = f * c
			y = dt + ((dt * dt) * (b * b) * (b * b) / 20 - b * b) * (dt * dt * dt) / 6
		end

		p1 = (offset * (i + d * z) + v0 * y) * decay + g
		v1 = (v0 * (i - z * d) - offset * (z * f)) * decay
	else
		local c = math.sqrt(d * d - 1)

		local r1 = -f * (d - c)
		local r2 = -f * (d + c)

		local co2 = (v0 - offset * r1) / (2 * f * c)
		local co1 = offset - co2

		local e1 = co1 * math.exp(r1 * dt)
		local e2 = co2 * math.exp(r2 * dt)

		p1 = e1 + e2 + g
		v1 = e1 * r1 + e2 * r2
	end

	local complete = math.abs(v1) < VELOCITY_THRESHOLD and math.abs(p1 - g) < POSITION_THRESHOLD

	return {
		complete = complete,
		value = complete and g or p1,
		velocity = v1,
	}
end


local noop = function() end

local BaseMotor = {}
BaseMotor.__index = BaseMotor

function BaseMotor.new()
	return setmetatable({
		_onStep = Signal.new(),
		_onStart = Signal.new(),
		_onComplete = Signal.new(),
	}, BaseMotor)
end

function BaseMotor:onStep(handler)
	return self._onStep:connect(handler)
end

function BaseMotor:onStart(handler)
	return self._onStart:connect(handler)
end

function BaseMotor:onComplete(handler)
	return self._onComplete:connect(handler)
end

function BaseMotor:start()
	if not self._connection then
		self._connection = RunService.RenderStepped:Connect(function(deltaTime)
			self:step(deltaTime)
		end)
	end
end

function BaseMotor:stop()
	if self._connection then
		self._connection:Disconnect()
		self._connection = nil
	end
end

BaseMotor.destroy = BaseMotor.stop

BaseMotor.step = noop
BaseMotor.getValue = noop
BaseMotor.setGoal = noop

function BaseMotor:__tostring()
	return "Motor"
end

local SingleMotor = setmetatable({}, BaseMotor)
SingleMotor.__index = SingleMotor

function SingleMotor.new(initialValue, useImplicitConnections)
	assert(initialValue, "Missing argument #1: initialValue")
	assert(typeof(initialValue) == "number", "initialValue must be a number!")

	local self = setmetatable(BaseMotor.new(), SingleMotor)

	if useImplicitConnections ~= nil then
		self._useImplicitConnections = useImplicitConnections
	else
		self._useImplicitConnections = true
	end

	self._goal = nil
	self._state = {
		complete = true,
		value = initialValue,
	}

	return self
end

function SingleMotor:step(deltaTime)
	if self._state.complete then
		return true
	end

	local newState = self._goal:step(self._state, deltaTime)

	self._state = newState
	self._onStep:fire(newState.value)

	if newState.complete then
		if self._useImplicitConnections then
			self:stop()
		end

		self._onComplete:fire()
	end

	return newState.complete
end

function SingleMotor:getValue()
	return self._state.value
end

function SingleMotor:setGoal(goal)
	self._state.complete = false
	self._goal = goal

	self._onStart:fire()

	if self._useImplicitConnections then
		self:start()
	end
end

function SingleMotor:__tostring()
	return "Motor(Single)"
end

local GroupMotor = setmetatable({}, BaseMotor)
GroupMotor.__index = GroupMotor

local function toMotor(value)
	if isMotor(value) then
		return value
	end

	local valueType = typeof(value)

	if valueType == "number" then
		return SingleMotor.new(value, false)
	elseif valueType == "table" then
		return GroupMotor.new(value, false)
	end

	error(("Unable to convert %q to motor; type %s is unsupported"):format(value, valueType), 2)
end

function GroupMotor.new(initialValues, useImplicitConnections)
	assert(initialValues, "Missing argument #1: initialValues")
	assert(typeof(initialValues) == "table", "initialValues must be a table!")
	assert(
		not initialValues.step,
		'initialValues contains disallowed property "step". Did you mean to put a table of values here?'
	)

	local self = setmetatable(BaseMotor.new(), GroupMotor)

	if useImplicitConnections ~= nil then
		self._useImplicitConnections = useImplicitConnections
	else
		self._useImplicitConnections = true
	end

	self._complete = true
	self._motors = {}

	for key, value in pairs(initialValues) do
		self._motors[key] = toMotor(value)
	end

	return self
end

function GroupMotor:step(deltaTime)
	if self._complete then
		return true
	end

	local allMotorsComplete = true

	for _, motor in pairs(self._motors) do
		local complete = motor:step(deltaTime)
		if not complete then

			allMotorsComplete = false
		end
	end

	self._onStep:fire(self:getValue())

	if allMotorsComplete then
		if self._useImplicitConnections then
			self:stop()
		end

		self._complete = true
		self._onComplete:fire()
	end

	return allMotorsComplete
end

function GroupMotor:setGoal(goals)
	assert(not goals.step, 'goals contains disallowed property "step". Did you mean to put a table of goals here?')

	self._complete = false
	self._onStart:fire()

	for key, goal in pairs(goals) do
		local motor = assert(self._motors[key], ("Unknown motor for key %s"):format(key))
		motor:setGoal(goal)
	end

	if self._useImplicitConnections then
		self:start()
	end
end

function GroupMotor:getValue()
	local values = {}

	for key, motor in pairs(self._motors) do
		values[key] = motor:getValue()
	end

	return values
end

function GroupMotor:__tostring()
	return "Motor(Group)"
end

local Flipper = {
	SingleMotor = SingleMotor,
	GroupMotor = GroupMotor,

	Instant = Instant,
	Linear = Linear,
	Spring = Spring,

	isMotor = isMotor,
}

local Creator = {
	Registry = {},
	FontRegistry = {},
	FontChangedCallbacks = {},
	Signals = {},
	TransparencyMotors = {},
	ThemeChangedCallbacks = {},
	DefaultProperties = {
		ScreenGui = {
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		},
		Frame = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		ScrollingFrame = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ScrollBarImageColor3 = Color3.new(0, 0, 0),
		},
		TextLabel = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			TextSize = 14,
		},
		TextButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
		},
		TextBox = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ClearTextOnFocus = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
		},
		ImageLabel = {
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		ImageButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false,
		},
		CanvasGroup = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
	},
}

local function ApplyCustomProps(Object, Props)
	if Props.ThemeTag then
		Creator.AddThemeObject(Object, Props.ThemeTag)
	end
	if Props.SeasonalHat then
		Creator.AttachHat(Object, Props.SeasonalHat)
	end
end

function Creator.AddSignal(Signal, Function)
	table.insert(Creator.Signals, Signal:Connect(Function))
end

function Creator.Disconnect()
	for Idx = #Creator.Signals, 1, -1 do
		local Connection = table.remove(Creator.Signals, Idx)
		Connection:Disconnect()
	end
end

local GradientTransparencyKeys = {
	AcrylicGradientTransparency = true,
	DropdownHolderTransparency = true,
	DialogHolderTransparency = true,
	ColorpickerHolderTransparency = true,
	MenuBackgroundTransparency = true,
}

local GradientThemeKeys = {
	DropdownHolder = true,
	DialogHolder = true,
	ColorpickerHolder = true,
}

local function ResolveThemeValue(Source, Property)
	if not Source then
		return nil
	end

	if Source[Property] ~= nil then
		return Source[Property]
	end

	if Property == "DialogInputFocused" and typeof(Source.DialogHolder) == "Color3" then
		return Source.DialogHolder
	end

	return nil
end

function Creator.GetThemeProperty(Property)
	local Value = ResolveThemeValue(Library.CustomThemeData, Property)

	if Value == nil then
		Value = ResolveThemeValue(Themes[Library.Theme], Property)
	end

	if Value == nil then
		Value = Themes["Dark"][Property]
	end

	if GradientThemeKeys[Property] and typeof(Value) == "Color3" then
		return ColorSequence.new(Value)
	end

	if GradientTransparencyKeys[Property] and type(Value) == "number" then
		return NumberSequence.new(Value)
	end

	return Value
end

function Creator.GetKnobColor()
	local Color = Creator.GetThemeProperty("ToggleToggled")
	return Color3.new(1 - Color.R, 1 - Color.G, 1 - Color.B)
end

function Creator.UpdateTheme()
	for Instance, Object in next, Creator.Registry do
		for Property, ColorIdx in next, Object.Properties do
			Instance[Property] = Creator.GetThemeProperty(ColorIdx)
		end
	end

	for _, Motor in next, Creator.TransparencyMotors do
		Motor:setGoal(Flipper.Instant.new(Creator.GetThemeProperty("ElementTransparency")))
	end

	for _, Callback in next, Creator.ThemeChangedCallbacks do
		Callback()
	end
end

function Creator.OnThemeChanged(Callback)
	table.insert(Creator.ThemeChangedCallbacks, Callback)
	return Callback
end

function Creator.AttachScrollBar(ScrollFrame, Options)
	Options = Options or {}

	local Thickness = Options.Thickness or 4
	local DotSize = Thickness
	local Cap = DotSize + 3
	local BarWidth = Thickness + 6
	local MinThumb = 16
	local SquashFactor = 2
	local ShownTransparency = 0.35
	local IdleDelay = 0.9
	local FadeInTime = 0.12
	local FadeOutTime = 0.35

	ScrollFrame.ScrollBarThickness = 0

	local Scrollable = false
	local Dragging = false
	local Hovering = false
	local Shown = false
	local RevealId = 0
	local DragStartY = 0
	local DragStartCanvas = 0
	local Fades = {}
	local ActiveTweens = {}

	local function NewFade(Object)
		table.insert(Fades, Object)
		return Object
	end

	local function NewDot(Name, Anchor)
		return NewFade(Creator.New("Frame", {
			Name = Name,
			AnchorPoint = Vector2.new(0.5, Anchor),
			Position = UDim2.fromScale(0.5, Anchor),
			Size = UDim2.fromOffset(DotSize, DotSize),
			BackgroundTransparency = 1,
			ThemeTag = {
				BackgroundColor3 = "ScrollBar",
			},
		}, {
			Creator.New("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
		}))
	end

	local ThumbVisual = NewFade(Creator.New("Frame", {
		Name = "ScrollBarVisual",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.new(0, Thickness, 1, 0),
		BackgroundTransparency = 1,
		ThemeTag = {
			BackgroundColor3 = "ScrollBar",
		},
	}, {
		Creator.New("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
	}))

	local Thumb = Creator.New("TextButton", {
		Name = "ScrollBarThumb",
		Text = "",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.new(1, 0, 0, MinThumb),
	}, {
		ThumbVisual,
	})

	local Track = Creator.New("Frame", {
		Name = "ScrollBarTrack",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, Cap),
		Size = UDim2.new(1, 0, 1, -Cap * 2),
	}, {
		Thumb,
	})

	local Bar = Creator.New("Frame", {
		Name = "ScrollBar",
		BackgroundTransparency = 1,
		ZIndex = ScrollFrame.ZIndex + 1,
		Visible = false,
	}, {
		NewDot("ScrollBarTopDot", 0),
		NewDot("ScrollBarBottomDot", 1),
		Track,
	})

	local function FadeTo(Transparency, Duration)
		for _, Tween in next, ActiveTweens do
			Tween:Cancel()
		end
		table.clear(ActiveTweens)

		for _, Object in next, Fades do
			local Tween = TweenService:Create(Object, TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = Transparency,
			})
			table.insert(ActiveTweens, Tween)
			Tween:Play()
		end
	end

	local function Reveal()
		if not Scrollable then
			return
		end

		RevealId = RevealId + 1
		local CurrentId = RevealId

		if not Shown then
			Shown = true
			FadeTo(ShownTransparency, FadeInTime)
		end

		task.delay(IdleDelay, function()
			if CurrentId == RevealId and not Dragging and not Hovering then
				Shown = false
				FadeTo(1, FadeOutTime)
			end
		end)
	end

	local function SyncLayout()
		local Position = ScrollFrame.Position
		local Size = ScrollFrame.Size
		local Anchor = ScrollFrame.AnchorPoint
		Bar.AnchorPoint = Vector2.new(1, Anchor.Y)
		Bar.Position = UDim2.new(
			Position.X.Scale + Size.X.Scale * (1 - Anchor.X),
			Position.X.Offset + Size.X.Offset * (1 - Anchor.X),
			Position.Y.Scale,
			Position.Y.Offset
		)
		Bar.Size = UDim2.new(0, BarWidth, Size.Y.Scale, Size.Y.Offset)
		Bar.ZIndex = ScrollFrame.ZIndex + 1
	end

	local function Update()
		local WindowHeight = ScrollFrame.AbsoluteWindowSize.Y
		local CanvasHeight = ScrollFrame.AbsoluteCanvasSize.Y
		local MaxScroll = CanvasHeight - WindowHeight
		Scrollable = MaxScroll > 1

		local TrackHeight = math.max(0, ScrollFrame.AbsoluteSize.Y - Cap * 2)
		local Ratio = Scrollable and math.clamp(WindowHeight / CanvasHeight, 0, 1) or 1
		local ThumbHeight = math.min(TrackHeight, math.max(MinThumb, TrackHeight * Ratio))
		local Offset = 0

		if Scrollable then
			local CanvasY = ScrollFrame.CanvasPosition.Y
			local Over = 0

			if CanvasY < 0 then
				Over = -CanvasY
			elseif CanvasY > MaxScroll then
				Over = CanvasY - MaxScroll
			end

			Offset = (TrackHeight - ThumbHeight) * math.clamp(CanvasY / MaxScroll, 0, 1)

			if Over > 0 then
				ThumbHeight = math.max(Thickness, ThumbHeight - Over * (TrackHeight / CanvasHeight) * SquashFactor)
				Offset = CanvasY < 0 and 0 or TrackHeight - ThumbHeight
			end
		end

		Thumb.Size = UDim2.new(1, 0, 0, ThumbHeight)
		Thumb.Position = UDim2.new(0.5, 0, 0, Offset)
		Bar.Visible = ScrollFrame.Visible and ScrollFrame.Parent ~= nil and Scrollable
	end

	local function Reparent()
		Bar.Parent = ScrollFrame.Parent
		SyncLayout()
		Update()
	end

	Creator.AddSignal(ScrollFrame:GetPropertyChangedSignal("Parent"), Reparent)
	Creator.AddSignal(ScrollFrame:GetPropertyChangedSignal("Position"), SyncLayout)
	Creator.AddSignal(ScrollFrame:GetPropertyChangedSignal("Size"), SyncLayout)
	Creator.AddSignal(ScrollFrame:GetPropertyChangedSignal("AnchorPoint"), SyncLayout)
	Creator.AddSignal(ScrollFrame:GetPropertyChangedSignal("ZIndex"), SyncLayout)
	Creator.AddSignal(ScrollFrame:GetPropertyChangedSignal("Visible"), Update)
	Creator.AddSignal(ScrollFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"), Update)
	Creator.AddSignal(ScrollFrame:GetPropertyChangedSignal("AbsoluteWindowSize"), Update)
	Creator.AddSignal(ScrollFrame:GetPropertyChangedSignal("AbsoluteSize"), Update)

	Creator.AddSignal(ScrollFrame:GetPropertyChangedSignal("CanvasPosition"), function()
		Update()
		Reveal()
	end)

	Creator.AddSignal(ScrollFrame.Destroying, function()
		RevealId = RevealId + 1
		Bar:Destroy()
	end)

	Creator.AddSignal(Thumb.MouseEnter, function()
		Hovering = true
		Reveal()
	end)

	Creator.AddSignal(Thumb.MouseLeave, function()
		Hovering = false
		Reveal()
	end)

	Creator.AddSignal(Thumb.InputBegan, function(Input)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		if not Scrollable then
			return
		end
		Dragging = true
		DragStartY = Input.Position.Y
		DragStartCanvas = ScrollFrame.CanvasPosition.Y
		Reveal()
	end)

	Creator.AddSignal(UserInputService.InputChanged, function(Input)
		if not Dragging then
			return
		end
		if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local MaxScroll = ScrollFrame.AbsoluteCanvasSize.Y - ScrollFrame.AbsoluteWindowSize.Y
		local TrackHeight = math.max(0, ScrollFrame.AbsoluteSize.Y - Cap * 2)
		local Travel = TrackHeight - Thumb.AbsoluteSize.Y
		if MaxScroll <= 0 or Travel <= 0 then
			return
		end
		local Delta = Input.Position.Y - DragStartY
		ScrollFrame.CanvasPosition = Vector2.new(0, math.clamp(DragStartCanvas + Delta * MaxScroll / Travel, 0, MaxScroll))
	end)

	Creator.AddSignal(UserInputService.InputEnded, function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			if Dragging then
				Dragging = false
				Reveal()
			end
		end
	end)

	Reparent()

	return Bar
end

function Creator.AddThemeObject(Object, Properties)
	Creator.RegistryCount = (Creator.RegistryCount or 0) + 1

	local Data = {
		Object = Object,
		Properties = Properties,
		Idx = Creator.RegistryCount,
	}

	Creator.Registry[Object] = Data

	for Property, ColorIdx in next, Properties do
		Object[Property] = Creator.GetThemeProperty(ColorIdx)
	end

	return Object
end

function Creator.OverrideTag(Object, Properties)
	Creator.Registry[Object].Properties = Properties

	for Property, ColorIdx in next, Properties do
		Object[Property] = Creator.GetThemeProperty(ColorIdx)
	end
end

function Creator.Release(Root)
	local Released = { [Root] = true }
	Creator.Registry[Root] = nil

	for _, Descendant in ipairs(Root:GetDescendants()) do
		Released[Descendant] = true
		Creator.Registry[Descendant] = nil
	end

	for Index = #Creator.FontRegistry, 1, -1 do
		if Released[Creator.FontRegistry[Index].object] then
			table.remove(Creator.FontRegistry, Index)
		end
	end
end

function Creator.RegisterFontObject(object, weight, style)
	table.insert(Creator.FontRegistry, {
		object = object,
		weight = weight or Enum.FontWeight.Regular,
		style = style  or Enum.FontStyle.Normal,
	})
end

function Creator.UpdateFont()
	for _, entry in ipairs(Creator.FontRegistry) do
		pcall(function()
			entry.object.FontFace = Font.new(Library.Font, entry.weight, entry.style)
		end)
	end
	for _, Callback in next, Creator.FontChangedCallbacks do
		Callback(Library.Font)
	end
end

Creator.Hats = setmetatable({}, { __mode = "k" })
Creator.ActiveHat = nil
Creator.HatClockRunning = false
Creator.HatOrder = { "Santa", "Witch" }

Creator.HatEvents = {
	Santa = {
		Texture = "rbxassetid://122021075307136",
		Months = { 12 },
		Aspect = 666 / 375,
		Width = 321 / 375,
		OriginX = 0.5,
		OriginY = 439 / 666,
		Rotation = -10,
		Scale = { Avatar = 1, Icon = 1 },
	},
	Witch = {
		Texture = "rbxassetid://83060455252227",
		Months = { 10 },
		Aspect = 1,
		Width = 325 / 500,
		OriginX = 249.5 / 500,
		OriginY = 375 / 500,
		Rotation = 0,
		Scale = { Avatar = 0.85, Icon = 0.85 },
	},
}

Creator.HatPlacement = {
	Avatar = { Width = 0.95, X = 0.5, Y = 0.3 },
	Icon = { Width = 1, X = 0.5, Y = 0.2 },
}

function Creator.GetActiveHat()
	local Settings = Library.SeasonalHats
	if Settings.Enabled ~= true then
		return nil
	end
	if Settings.Force then
		return Creator.HatEvents[Settings.Force] and Settings.Force or nil
	end
	local Month = os.date("*t").month
	for _, Name in ipairs(Creator.HatOrder) do
		if table.find(Creator.HatEvents[Name].Months, Month) then
			return Name
		end
	end
	return nil
end

local function StyleHat(Hat, Kind)
	local Event = Creator.ActiveHat and Creator.HatEvents[Creator.ActiveHat]
	if not Event then
		Hat.Visible = false
		return
	end
	local Place = Creator.HatPlacement[Kind] or Creator.HatPlacement.Icon
	local Width = Place.Width * (Event.Scale[Kind] or 1) / Event.Width
	Hat.Image = Event.Texture
	Hat.AnchorPoint = Vector2.new(Event.OriginX, Event.OriginY)
	Hat.Position = UDim2.fromScale(Place.X, Place.Y)
	Hat.Size = UDim2.fromScale(Width, Width * Event.Aspect)
	Hat.Rotation = Event.Rotation
	Hat.Visible = true
end

function Creator.RefreshHats()
	Creator.ActiveHat = Creator.GetActiveHat()
	for Hat, Kind in next, Creator.Hats do
		StyleHat(Hat, Kind)
	end
end

function Creator.AttachHat(Object, Kind)
	local Hat = Instance.new("ImageLabel")
	Hat.Name = "SeasonalHat"
	Hat.BackgroundTransparency = 1
	Hat.BorderSizePixel = 0
	Hat.ScaleType = Enum.ScaleType.Stretch
	Hat.ZIndex = 20
	Hat.Visible = false
	Hat.Parent = Object
	Creator.Hats[Hat] = Kind
	StyleHat(Hat, Kind)
	return Hat
end

function Creator.StartHatClock()
	if Creator.HatClockRunning then
		return
	end
	Creator.HatClockRunning = true
	task.spawn(function()
		local LastKey
		while not Library.Unloaded do
			local Now = os.date("*t")
			local Key = Now.year * 10000 + Now.month * 100 + Now.day
			if Key ~= LastKey then
				LastKey = Key
				Creator.RefreshHats()
			end
			task.wait(30)
		end
		Creator.HatClockRunning = false
	end)
end

Creator.ActiveHat = Creator.GetActiveHat()
Creator.StartHatClock()

task.spawn(function()
	pcall(function()
		ContentProvider:PreloadAsync({
			"rbxassetid://4155801252",
			"rbxassetid://4805639000",
			"rbxassetid://14204231522",
			"rbxassetid://12266946128",
			"rbxassetid://5554236805",
		})
	end)
end)

local fontTextTypes = { TextLabel = true, TextButton = true, TextBox = true }

function Creator.New(Name, Properties, Children)
	local Object = Instance.new(Name)

	for Name, Value in next, Creator.DefaultProperties[Name] or {} do
		Object[Name] = Value
	end

	local fontWeight = Enum.FontWeight.Regular
	local fontStyle = Enum.FontStyle.Normal

	for Name, Value in next, Properties or {} do
		if Name ~= "ThemeTag" and Name ~= "IgnoreFontUpdate" and Name ~= "SeasonalHat" then
			Object[Name] = Value
		end
		if Name == "FontFace" and typeof(Value) == "Font" then
			fontWeight = Value.Weight
			fontStyle = Value.Style
		end
	end

	if fontTextTypes[Name] and not (Properties and Properties.IgnoreFontUpdate) then
		Creator.RegisterFontObject(Object, fontWeight, fontStyle)
	end

	for _, Child in next, Children or {} do
		Child.Parent = Object
	end

	ApplyCustomProps(Object, Properties)
	return Object
end

function Creator.AttachTitleDesc(Target, TitleLabel, DescLabel)
	function Target:SetTitle(Set)
		Set = Set or ""
		TitleLabel.Text = Set
		TitleLabel.Visible = Set ~= ""
	end

	if DescLabel then
		function Target:SetDesc(Set)
			Set = Set or ""
			DescLabel.Text = Set
			DescLabel.Visible = Set ~= ""
		end
	end
end

function Creator.AttachLock(Frame, Locked, Options)
	Options = Options or {}

	local Lock = {
		Locked = false,
		Targets = {},
	}

	local Overlay = Creator.New("TextButton", {
		Name = "LockOverlay",
		Text = "",
		AutoButtonColor = false,
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 20,
		Visible = false,
		Parent = Frame,
		ThemeTag = {
			BackgroundColor3 = "Dialog",
		},
	}, {
		Creator.New("UICorner", {
			CornerRadius = UDim.new(0, Options.Radius or 4),
		}),
		Creator.New("Frame", {
			Name = "LockBadge",
			Size = UDim2.fromOffset(24, 24),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(45, 45, 45),
			BorderSizePixel = 0,
			ZIndex = 21,
			ThemeTag = {
				BackgroundColor3 = "Element",
			},
		}, {
			Creator.New("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
			Creator.New("UIStroke", {
				Transparency = 0.5,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "ElementBorder",
					Transparency = "ElementBorderTransparency",
				},
			}),
			Creator.New("ImageLabel", {
				Name = "LockIcon",
				Image = Library.InternalIcons.Lock,
				Size = UDim2.fromOffset(12, 12),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 22,
				ThemeTag = {
					ImageColor3 = "SubText",
				},
			}),
		}),
	})

	function Lock.Set(Value)
		Value = Value == true
		if Value == Lock.Locked then
			return
		end

		Lock.Locked = Value
		Overlay.Visible = Value

		for _, Target in ipairs(Lock.Targets) do
			Target.Locked = Value
		end

		if Value then
			for _, Descendant in ipairs(Frame:GetDescendants()) do
				if Descendant:IsA("TextBox") then
					Descendant:ReleaseFocus()
				end
			end
		end

		if Lock.OnChanged then
			Lock.OnChanged(Value)
		end
	end

	function Lock.Bind(Target)
		table.insert(Lock.Targets, Target)
		Target.Locked = Lock.Locked

		function Target:SetLocked(Value)
			Lock.Set(Value)
		end

		function Target:Lock()
			Lock.Set(true)
		end

		function Target:Unlock()
			Lock.Set(false)
		end

		Target.OpenLocked = Target.Unlock

		function Target:IsLocked()
			return Lock.Locked
		end
	end

	Lock.Set(Locked)

	return Lock
end

Creator.Marquees = {}

local MarqueePause = 1.2
local MarqueeSpeed = 40

local function UpdateMarquees(Delta)
	for Index = #Creator.Marquees, 1, -1 do
		local Entry = Creator.Marquees[Index]
		if not Entry.Label.Parent then
			table.remove(Creator.Marquees, Index)
		elseif Entry.Label.Visible and Entry.Label.AbsoluteSize.X > 0 then
			local Overflow = Entry.Child.TextBounds.X - Entry.Label.AbsoluteSize.X
			local Offset = 0

			if Overflow > 1 then
				Entry.Time = Entry.Time + Delta
				local Duration = Overflow / MarqueeSpeed
				local Cycle = MarqueePause * 2 + Duration * 2
				local Time = Entry.Time % Cycle

				if Time < MarqueePause then
					Offset = 0
				elseif Time < MarqueePause + Duration then
					Offset = -Overflow * (Time - MarqueePause) / Duration
				elseif Time < MarqueePause * 2 + Duration then
					Offset = -Overflow
				else
					Offset = -Overflow * (1 - (Time - MarqueePause * 2 - Duration) / Duration)
				end
			else
				Entry.Time = 0
			end

			Offset = math.floor(Offset + 0.5)
			if Offset ~= Entry.Offset then
				Entry.Offset = Offset
				Entry.Child.Position = UDim2.fromOffset(Offset, 0)
			end
		end
	end
end

function Creator.Marquee(Label, ColorTag)
	if not Creator.MarqueeStarted then
		Creator.MarqueeStarted = true
		Creator.AddSignal(RunService.Heartbeat, UpdateMarquees)
	end

	Label.ClipsDescendants = true
	Label.TextTransparency = 1
	Label.TextWrapped = false

	local Child = Creator.New("TextLabel", {
		Name = "MarqueeText",
		Text = Label.Text,
		FontFace = Label.FontFace,
		TextSize = Label.TextSize,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		Parent = Label,
		ThemeTag = {
			TextColor3 = ColorTag,
		},
	})

	Creator.AddSignal(Label:GetPropertyChangedSignal("Text"), function()
		Child.Text = Label.Text
	end)

	table.insert(Creator.Marquees, { Label = Label, Child = Child, Time = 0, Offset = 0 })
end

function Creator.Adaptive(ElementFrame, Slot, Threshold, StartInline, Apply)
	local Inline = StartInline

	local Holder = ElementFrame.Frame.Parent
	if Holder and Holder:GetAttribute("SidePanelRows") then
		Threshold = math.min(Threshold, Slot + 140)
	end

	local function Place(Value)
		Inline = Value
		local LabelSize = Inline and UDim2.new(1, -Slot, 0, 14) or UDim2.new(1, 0, 0, 14)
		ElementFrame.TitleLabel.Size = LabelSize
		ElementFrame.DescLabel.Size = LabelSize
		Apply(Inline)
	end

	local function Update()
		local Width = ElementFrame.Frame.AbsoluteSize.X
		if Width <= 0 then return end
		local Want
		if Inline then
			Want = Width >= Threshold - 20
		else
			Want = Width >= Threshold + 20
		end
		if Want ~= Inline then
			Place(Want)
		end
	end

	Place(Inline)
	if StartInline then return end
	Creator.AddSignal(ElementFrame.Frame:GetPropertyChangedSignal("AbsoluteSize"), Update)
	task.defer(Update)
end

function Creator.HoverShift(Rest, DefaultDelta)
	local Change = tonumber(Creator.GetThemeProperty("HoverChange")) or 0.07
	return math.clamp(Rest - DefaultDelta * (Change / 0.07), 0, 1)
end

function Creator.AttachCardHover(Card, HitBox, Config)
	Config = Config or {}

	local Overlay = Creator.New("Frame", {
		Name = "HoverOverlay",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = Config.ZIndex or 1,
		Parent = Card,
	}, {
		Creator.New("UICorner", {
			CornerRadius = UDim.new(0, Config.Corner or 8),
		}),
	})

	local Motor, SetTransparency = Creator.SpringMotor(1, Overlay, "BackgroundTransparency", true)

	local function Level(Multiplier)
		local Change = tonumber(Creator.GetThemeProperty("HoverChange")) or 0.07
		return 1 - math.clamp(Change * Multiplier, 0, 1)
	end

	Creator.AddSignal(HitBox.MouseEnter, function()
		SetTransparency(Level(2))
	end)
	Creator.AddSignal(HitBox.MouseLeave, function()
		SetTransparency(1)
	end)
	Creator.AddSignal(HitBox.MouseButton1Down, function()
		SetTransparency(Level(3))
	end)
	Creator.AddSignal(HitBox.MouseButton1Up, function()
		SetTransparency(Level(2))
	end)

	return Overlay
end

function Creator.SpringMotor(Initial, Instance, Prop, IgnoreDialogCheck, ResetOnThemeChange)
	IgnoreDialogCheck = IgnoreDialogCheck or false
	ResetOnThemeChange = ResetOnThemeChange or false
	local Motor = Flipper.SingleMotor.new(Initial)
	Motor:onStep(function(value)
		Instance[Prop] = value
	end)

	if ResetOnThemeChange then
		table.insert(Creator.TransparencyMotors, Motor)
	end

	local function SetValue(Value, Ignore)
		Ignore = Ignore or false
		if not IgnoreDialogCheck then
			if not Ignore then
				if Prop == "BackgroundTransparency" and Library.DialogOpen then
					return
				end
			end
		end
		Motor:setGoal(Flipper.Spring.new(Value, { frequency = 8 }))
	end

	return Motor, SetValue
end

local New = Creator.New

local GUI = New("ScreenGui", {
	Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui,
})
ProtectGui(GUI)
Library.GUI = GUI

function Library:SafeCallback(Function, ...)
	if not Function then
		return
	end

	local Success, Event = pcall(Function, ...)
	if not Success then
		local _, i = Event:find(":%d+: ")

		if not i then
			return Library:Notify({
				Title = "Interface",
				Content = "Callback error",
				SubContent = Event,
				Duration = 5,
			})
		end

		return Library:Notify({
			Title = "Interface",
			Content = "Callback error",
			SubContent = Event:sub(i + 1),
			Duration = 5,
		})
	end
end

function Library:Round(Number, Factor)
	if Factor == 0 then
		return math.floor(Number)
	end
	Number = tostring(Number)
	return Number:find("%.") and tonumber(Number:sub(1, Number:find("%.") + Factor)) or Number
end

local function viewportPointToWorld(location, distance)
	local unitRay = Workspace.CurrentCamera:ScreenPointToRay(location.X, location.Y)
	return unitRay.Origin + unitRay.Direction * distance
end

local function createAcrylic()
	local Part = Creator.New("Part", {
		Name = "Body",
		Color = Color3.new(0, 0, 0),
		Material = Enum.Material.Glass,
		Size = Vector3.new(1, 1, 0),
		Anchored = true,
      CanCollide = false,
      CanQuery = false,
      CanTouch = false,
      Locked = true,
      Transparency = 0.98,
	}, {
		Creator.New("SpecialMesh", {
			MeshType = Enum.MeshType.Brick,
			Offset = Vector3.new(0, 0, -0.000001),
		}),
	})

	return Part
end

local BlurFolder = Instance.new("Folder", Workspace.CurrentCamera)

local function createAcrylicBlur(distance)
	local cleanups = {}

	distance = distance or 0.001
	local positions = {
		topLeft = Vector2.new(),
		topRight = Vector2.new(),
		bottomRight = Vector2.new(),
	}
	local model = createAcrylic()
	model.Parent = BlurFolder

	local function updatePositions(size, position)
		positions.topLeft = position
		positions.topRight = position + Vector2.new(size.X, 0)
		positions.bottomRight = position + size
	end

	local function render()
		local res = Workspace.CurrentCamera
		if res then
			res = res.CFrame
		end
		local cond = res
		if not cond then
			cond = CFrame.new()
		end

		local camera = cond
		local topLeft = positions.topLeft
		local topRight = positions.topRight
		local bottomRight = positions.bottomRight

		local topLeft3D = viewportPointToWorld(topLeft, distance)
		local topRight3D = viewportPointToWorld(topRight, distance)
		local bottomRight3D = viewportPointToWorld(bottomRight, distance)

		local width = (topRight3D - topLeft3D).Magnitude
		local height = (topRight3D - bottomRight3D).Magnitude

		model.CFrame =
			CFrame.fromMatrix((topLeft3D + bottomRight3D) / 2, camera.XVector, camera.YVector, camera.ZVector)
		model.Mesh.Scale = Vector3.new(width, height, 0)
	end

	local function onChange(rbx)
		local size = rbx.AbsoluteSize
		local position = rbx.AbsolutePosition

		updatePositions(size, position)
		task.spawn(render)
	end

	local function renderOnChange()
		local camera = Workspace.CurrentCamera
		if not camera then
			return
		end

		table.insert(cleanups, camera:GetPropertyChangedSignal("CFrame"):Connect(render))
		table.insert(cleanups, camera:GetPropertyChangedSignal("ViewportSize"):Connect(render))
		table.insert(cleanups, camera:GetPropertyChangedSignal("FieldOfView"):Connect(render))
		task.spawn(render)
	end

	model.Destroying:Connect(function()
		for _, item in cleanups do
			pcall(function()
				item:Disconnect()
			end)
		end
	end)

	renderOnChange()

	return onChange, model
end

local AcrylicBlur = function(distance)
	local Blur = {}
	local onChange, model = createAcrylicBlur(distance)

	local comp = Creator.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	})

	Creator.AddSignal(comp:GetPropertyChangedSignal("AbsolutePosition"), function()
		onChange(comp)
	end)

	Creator.AddSignal(comp:GetPropertyChangedSignal("AbsoluteSize"), function()
		onChange(comp)
	end)

	Blur.AddParent = function(Parent)
		Creator.AddSignal(Parent:GetPropertyChangedSignal("Visible"), function()
			Blur.SetVisibility(Parent.Visible)
		end)
	end

	Blur.SetVisibility = function(Value)
		model.Transparency = Value and 0.98 or 1
	end

	Blur.Frame = comp
	Blur.Model = model

	return Blur
end

local New = Creator.New

local AcrylicPaint = function(props)
	local AcrylicPaint = {}

	AcrylicPaint.Frame = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 0.9,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
	}, {
		New("ImageLabel", {
			Image = "rbxassetid://8992230677",
			ScaleType = "Slice",
			SliceCenter = Rect.new(Vector2.new(99, 99), Vector2.new(99, 99)),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 120, 1, 116),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,
			ImageColor3 = Color3.fromRGB(0, 0, 0),
			ImageTransparency = 0.7,
		}),

		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),

		New("Frame", {
			BackgroundTransparency = 0.45,
			Size = UDim2.fromScale(1, 1),
			Name = "Background",
			ThemeTag = {
				BackgroundColor3 = "AcrylicMain",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		}),

		New("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.fromScale(1, 1),
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),

			New("UIGradient", {
				ThemeTag = {
					Color = "AcrylicGradient",
					Rotation = "AcrylicGradientRotation",
					Transparency = "AcrylicGradientTransparency",
				},
			}),
		}),

		New("ImageLabel", {
			Image = "rbxassetid://9968344105",
			ImageTransparency = 0.98,
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.new(0, 128, 0, 128),
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		}),

		New("ImageLabel", {
			Image = "rbxassetid://9968344227",
			ImageTransparency = 0.9,
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.new(0, 128, 0, 128),
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ThemeTag = {
				ImageTransparency = "AcrylicNoise",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		}),

		New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
			New("UIStroke", {
				Transparency = 0.5,
				Thickness = 1,
				ThemeTag = {
					Color = "AcrylicBorder",
					Transparency = "AcrylicBorderTransparency",
				},
			}),
		}),
	})

	local Blur

	if Library.UseAcrylic then
		Blur = AcrylicBlur()
		Blur.Frame.Parent = AcrylicPaint.Frame
		AcrylicPaint.Model = Blur.Model
		AcrylicPaint.AddParent = Blur.AddParent
		AcrylicPaint.SetVisibility = Blur.SetVisibility
	end

	return AcrylicPaint
end

local Acrylic = {
	AcrylicBlur = AcrylicBlur,
	CreateAcrylic = createAcrylic,
	AcrylicPaint = AcrylicPaint,
}

function Acrylic.init()
	local baseEffect = Instance.new("DepthOfFieldEffect")
	baseEffect.FarIntensity = 0
	baseEffect.InFocusRadius = 0.1
	baseEffect.NearIntensity = 1

	local depthOfFieldDefaults = {}

	function Acrylic.Enable()
		for _, effect in pairs(depthOfFieldDefaults) do
			effect.Enabled = false
		end
		baseEffect.Parent = Lighting
	end

	function Acrylic.Disable()
		for _, effect in pairs(depthOfFieldDefaults) do
			effect.Enabled = effect.enabled
		end
		baseEffect.Parent = nil
	end

	local function registerDefaults()
		local function register(object)
			if object:IsA("DepthOfFieldEffect") then
				depthOfFieldDefaults[object] = { enabled = object.Enabled }
			end
		end

		for _, child in pairs(Lighting:GetChildren()) do
			register(child)
		end

		if Workspace.CurrentCamera then
			for _, child in pairs(Workspace.CurrentCamera:GetChildren()) do
				register(child)
			end
		end
	end

	registerDefaults()
	Acrylic.Enable()
end

local Components = {
	Assets = {
	Close = "rbxassetid://9886659671",
	Min = "rbxassetid://9886659276",
	Max = "rbxassetid://9886659406",
	Restore = "rbxassetid://9886659001",
},
	AssetsNew = {
	Close = "rbxassetid://110786993356448",
	Min = "rbxassetid://118026365011536",
	Max = "rbxassetid://73085922906397",
	Restore = "rbxassetid://116269596042539",
},
}

Components.Element = (function()
	local New = Creator.New

	local Spring = Flipper.Spring.new

	return function(Title, Desc, Parent, Hover, ElementLayoutOrder, ElementIcon, Marquee, Locked)
		local Element = {}

		local ResolvedIcon = ElementIcon
		if type(ResolvedIcon) == "string" and ResolvedIcon ~= ""
			and not ResolvedIcon:match("^rbxassetid://")
			and not ResolvedIcon:match("^rbxasset://")
			and not ResolvedIcon:match("^http") then
			ResolvedIcon = Library:GetIcon(ResolvedIcon)
		end

		local IconImage, IconRectOffset, IconRectSize
		if type(ResolvedIcon) == "table" then
			IconImage = ResolvedIcon.Image
			IconRectOffset = ResolvedIcon.ImageRectOffset
			IconRectSize = ResolvedIcon.ImageRectSize
		elseif type(ResolvedIcon) == "string" and ResolvedIcon ~= "" then
			IconImage = ResolvedIcon
		end

		local iconOffset = IconImage and 26 or 0

		Element.TitleLabel = New("TextLabel", {
			Name = "ElementTitle",
			FontFace = Font.new(Library.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			Text = Title,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 14),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		Element.DescLabel = New("TextLabel", {
			FontFace = Font.new(Library.Font),
			Text = Desc,
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = 12,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
			ThemeTag = {
				TextColor3 = "SubText",
			},
		})

		if Marquee ~= false then
			Creator.Marquee(Element.TitleLabel, "Text")
			Creator.Marquee(Element.DescLabel, "SubText")
		else
			Element.TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
		end

		Element.LabelHolder = New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(10 + iconOffset, 0),
			Size = UDim2.new(1, -28 - iconOffset, 0, 0),
		}, {
			New("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			New("UIPadding", {
				PaddingBottom = UDim.new(0, 13),
				PaddingTop = UDim.new(0, 13),
			}),
			Element.TitleLabel,
			Element.DescLabel,
		})

		if IconImage then
			Element.IconLabel = New("ImageLabel", {
				Image = IconImage,
				ImageRectOffset = IconRectOffset,
				ImageRectSize = IconRectSize,
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new(0, 10, 0.5, -8),
				BackgroundTransparency = 1,
				ZIndex = 2,
				SeasonalHat = "Icon",
				ThemeTag = { ImageColor3 = "Text" },
			})
		end

		Element.Border = New("UIStroke", {
			Transparency = 0.5,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.fromRGB(0, 0, 0),
			ThemeTag = {
				Color = "ElementBorder",
				Transparency = "ElementBorderTransparency",
			},
		})

		local frameChildren = {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
			Element.Border,
			Element.LabelHolder,
		}
		if Element.IconLabel then
			table.insert(frameChildren, Element.IconLabel)
		end

		Element.Frame = New("TextButton", {
			Name = "ElementFrame",
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 0.89,
			BackgroundColor3 = Color3.fromRGB(130, 130, 130),
			Parent = Parent,
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = "",
			LayoutOrder = ElementLayoutOrder or 0,
			ThemeTag = {
				BackgroundColor3 = "Element",
				BackgroundTransparency = "ElementTransparency",
			},
		}, frameChildren)

		Creator.AttachTitleDesc(Element, Element.TitleLabel, Element.DescLabel)

		Element.LockHandle = Creator.AttachLock(Element.Frame, Locked)
		Element.LockHandle.Bind(Element)

		function Element:Destroy()
			Element.Frame:Destroy()
		end

		Element:SetTitle(Title)
		Element:SetDesc(Desc)

		if Hover then
			local PressEffect = Hover ~= "Hover"
			local Motor, SetTransparency = Creator.SpringMotor(
				Creator.GetThemeProperty("ElementTransparency"),
				Element.Frame,
				"BackgroundTransparency",
				false,
				true
			)

			Creator.AddSignal(Element.Frame.MouseEnter, function()
				if Element.Locked then
					return
				end
				SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
			end)
			Creator.AddSignal(Element.Frame.MouseLeave, function()
				SetTransparency(Creator.GetThemeProperty("ElementTransparency"))
			end)
			if PressEffect then
				Creator.AddSignal(Element.Frame.MouseButton1Down, function()
					if Element.Locked then
						return
					end
					SetTransparency(Creator.GetThemeProperty("ElementTransparency") + Creator.GetThemeProperty("HoverChange"))
				end)
				Creator.AddSignal(Element.Frame.MouseButton1Up, function()
					if Element.Locked then
						return
					end
					SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
				end)
			end
		end

		return Element
	end
end)()

Components.Button = (function()
	local New = Creator.New

	local Spring = Flipper.Spring.new

	return function(Theme, Parent, DialogCheck, TagSet)
		DialogCheck = DialogCheck or false
		TagSet = TagSet or { Background = "DialogButton", Border = "DialogButtonBorder" }
		local Button = {}

		Button.Title = New("TextLabel", {
			FontFace = Font.new(Library.Font),
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = 14,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		Button.HoverFrame = New("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ThemeTag = {
				BackgroundColor3 = "Hover",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
		})

		Button.Frame = New("TextButton", {
			Size = UDim2.new(0, 0, 0, 32),
			Parent = Parent,
			ThemeTag = {
				BackgroundColor3 = TagSet.Background,
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Transparency = 0.65,
				ThemeTag = {
					Color = TagSet.Border,
				},
			}),
			Button.HoverFrame,
			Button.Title,
		})

		local Motor, SetTransparency = Creator.SpringMotor(1, Button.HoverFrame, "BackgroundTransparency", DialogCheck)
		Creator.AddSignal(Button.Frame.MouseEnter, function()
			SetTransparency(Creator.HoverShift(1, 0.03))
		end)
		Creator.AddSignal(Button.Frame.MouseLeave, function()
			SetTransparency(1)
		end)
		Creator.AddSignal(Button.Frame.MouseButton1Down, function()
			SetTransparency(1)
		end)
		Creator.AddSignal(Button.Frame.MouseButton1Up, function()
			SetTransparency(Creator.HoverShift(1, 0.03))
		end)

		return Button
	end
end)()

Components.Textbox = (function()
	local New = Creator.New

	return function(Parent, Acrylic, TagSet)
		Acrylic = Acrylic or false
		TagSet = TagSet or {
			Input = "DialogInput",
			InputLine = "DialogInputLine",
			InputBorder = "DialogButtonBorder",
			InputFocused = "DialogInputFocused",
		}
		local Textbox = {}

		Textbox.Input = New("TextBox", {
			FontFace = Font.new(Library.Font),
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromOffset(10, 0),
			ThemeTag = {
				TextColor3 = "Text",
				PlaceholderColor3 = "SubText",
			},
		})

		Textbox.Container = New("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Position = UDim2.new(0, 6, 0, 0),
			Size = UDim2.new(1, -12, 1, 0),
		}, {
			Textbox.Input,
		})

		Textbox.Indicator = New("Frame", {
			Size = UDim2.new(1, -4, 0, 1),
			Position = UDim2.new(0, 2, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = Acrylic and 0.5 or 0,
			ThemeTag = {
				BackgroundColor3 = Acrylic and "InputIndicator" or TagSet.InputLine,
			},
		})

		Textbox.Frame = New("Frame", {
			Size = UDim2.new(0, 0, 0, 30),
			BackgroundTransparency = Acrylic and 0.9 or 0,
			Parent = Parent,
			ThemeTag = {
				BackgroundColor3 = Acrylic and "Input" or TagSet.Input,
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Transparency = Acrylic and 0.5 or 0.65,
				ThemeTag = {
					Color = Acrylic and "InElementBorder" or TagSet.InputBorder,
				},
			}),
			Textbox.Indicator,
			Textbox.Container,
		})

		local function Update()
			local PADDING = 2
			local Reveal = Textbox.Container.AbsoluteSize.X

			if not Textbox.Input:IsFocused() or Textbox.Input.TextBounds.X <= Reveal - 2 * PADDING then
				Textbox.Input.Position = UDim2.new(0, PADDING, 0, 0)
			else
				local Cursor = Textbox.Input.CursorPosition
				if Cursor ~= -1 then
					local subtext = string.sub(Textbox.Input.Text, 1, Cursor - 1)
					local width = TextService:GetTextSize(
						subtext,
						Textbox.Input.TextSize,
						Textbox.Input.Font,
						Vector2.new(math.huge, math.huge)
					).X

					local CurrentCursorPos = Textbox.Input.Position.X.Offset + width
					if CurrentCursorPos < PADDING then
						Textbox.Input.Position = UDim2.fromOffset(PADDING - width, 0)
					elseif CurrentCursorPos > Reveal - PADDING - 1 then
						Textbox.Input.Position = UDim2.fromOffset(Reveal - width - PADDING - 1, 0)
					end
				end
			end
		end

		task.spawn(Update)

		Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("Text"), Update)
		Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("CursorPosition"), Update)

		Creator.AddSignal(Textbox.Input.Focused, function()
			Update()
			Textbox.Indicator.Size = UDim2.new(1, -2, 0, 2)
			Textbox.Indicator.Position = UDim2.new(0, 1, 1, 0)
			Textbox.Indicator.BackgroundTransparency = 0
			Creator.OverrideTag(Textbox.Frame, { BackgroundColor3 = Acrylic and "InputFocused" or TagSet.InputFocused })
			Creator.OverrideTag(Textbox.Indicator, { BackgroundColor3 = "Accent" })
		end)

		Creator.AddSignal(Textbox.Input.FocusLost, function()
			Update()
			Textbox.Indicator.Size = UDim2.new(1, -4, 0, 1)
			Textbox.Indicator.Position = UDim2.new(0, 2, 1, 0)
			Textbox.Indicator.BackgroundTransparency = 0.5
			Creator.OverrideTag(Textbox.Frame, { BackgroundColor3 = Acrylic and "Input" or TagSet.Input })
			Creator.OverrideTag(Textbox.Indicator, { BackgroundColor3 = Acrylic and "InputIndicator" or TagSet.InputLine })
		end)

		return Textbox
	end
end)()

Components.Section = (function()
	local New = Creator.New

	return function(Title, Parent)
		local Section = {}

		Section.Layout = New("UIListLayout", {
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		Section.Container = New("Frame", {
			Size = UDim2.new(1, 0, 0, 26),
			Position = UDim2.fromOffset(0, 24),
			BackgroundTransparency = 1,
		}, {
			Section.Layout,
		})

		Section.TitleLabel = New("TextLabel", {
			RichText = true,
			Text = Title,
			TextTransparency = 0,
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			TextSize = 18,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(1, -16, 0, 18),
			Position = UDim2.fromOffset(0, 2),
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		Section.Root = New("Frame", {
			Name = "SectionRoot",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 26),
			LayoutOrder = 0,
			Parent = Parent,
		}, {
			Section.TitleLabel,
			Section.Container,
		})

		Creator.AttachTitleDesc(Section, Section.TitleLabel, nil)

		Creator.AddSignal(Section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			Section.Container.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y)
			Section.Root.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y + 25)
		end)
		return Section
	end
end)()

Components.TitleBar = (function()
	local New = Creator.New
	local AddSignal = Creator.AddSignal

	return function(Config)
		local Assets = Library.NewVisual and Components.AssetsNew or Components.Assets
		local TitleBar = {}

		local function BarButton(Icon, Pos, Parent, Callback)
			local Button = {
				Callback = Callback or function() end,
			}

			Button.Frame = New("TextButton", {
				Size = UDim2.new(0, 34, 1, -8),
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Parent = Parent,
				Position = Pos,
				Text = "",
				ThemeTag = {
					BackgroundColor3 = "Text",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 7),
				}),
				New("ImageLabel", {
					Image = Icon,
					Size = UDim2.fromOffset(16, 16),
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Name = "Icon",
					ThemeTag = {
						ImageColor3 = "Text",
					},
				}),
			})

			local Motor, SetTransparency = Creator.SpringMotor(1, Button.Frame, "BackgroundTransparency")

			AddSignal(Button.Frame.MouseEnter, function()
				SetTransparency(Creator.HoverShift(1, 0.06))
			end)
			AddSignal(Button.Frame.MouseLeave, function()
				SetTransparency(1, true)
			end)
			AddSignal(Button.Frame.MouseButton1Down, function()
				SetTransparency(Creator.HoverShift(1, 0.04))
			end)
			AddSignal(Button.Frame.MouseButton1Up, function()
				SetTransparency(Creator.HoverShift(1, 0.06))
			end)
			AddSignal(Button.Frame.MouseButton1Click, Button.Callback)

			Button.SetCallback = function(Func)
				Button.Callback = Func
			end

			return Button
		end

		local WindowTitleLabel = New("TextLabel", {
			RichText = true,
			Text = Config.Title,
			FontFace = Font.new(Library.Font, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			TextSize = 12,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(0, 0, 0, 14),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		local WindowSubTitleLabel = New("TextLabel", {
			RichText = true,
			Text = Config.SubTitle,
			TextTransparency = 0.4,
			FontFace = Font.new(Library.Font, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			TextSize = 12,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(0, 0, 0, 14),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		TitleBar.TitleLabel = WindowTitleLabel
		TitleBar.SubTitleLabel = WindowSubTitleLabel
		Creator.AttachTitleDesc(TitleBar, WindowTitleLabel, WindowSubTitleLabel)
		TitleBar.SetSubTitle = TitleBar.SetDesc

		TitleBar.Frame = New("Frame", {
			Size = UDim2.new(1, 0, 0, 42),
			BackgroundTransparency = 1,
			Parent = Config.Parent,
		}, {
			New("Frame", {
				Size = UDim2.new(1, -16, 1, 0),
				Position = UDim2.new(0, 16, 0, 0),
				BackgroundTransparency = 1,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 1),
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
				WindowTitleLabel,
				WindowSubTitleLabel,
			}),
			New("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				ThemeTag = {
					BackgroundColor3 = "TitleBarLine",
					BackgroundTransparency = "TitleBarLineTransparency",
				},
			}),
		})

		TitleBar.CloseButton = BarButton(Assets.Close, UDim2.new(1, -4, 0, 4), TitleBar.Frame, function()
			Library.Window:Dialog({
				Title = "Close",
				Content = "Are you sure you want to unload the interface?",
				Buttons = {
					{
						Title = "Yes",
						Callback = function()
							Library:Destroy()
						end,
					},
					{
						Title = "No",
					},
				},
			})
		end)
		TitleBar.MaxButton = BarButton(Assets.Max, UDim2.new(1, -40, 0, 4), TitleBar.Frame, function()
			Config.Window.Maximize(not Config.Window.Maximized)
		end)
		TitleBar.MinButton = BarButton(Assets.Min, UDim2.new(1, -80, 0, 4), TitleBar.Frame, function()
			Library.Window:Minimize()
		end)

		return TitleBar
	end
end)()

Components.Notification = (function()
	local Spring = Flipper.Spring.new
	local Instant = Flipper.Instant.new
	local New = Creator.New

	local Notification = {}

	function Notification:Init(GUI)
		Notification.Holder = New("Frame", {
			Position = UDim2.new(1, -30, 1, -30),
			Size = UDim2.new(0, 310, 1, -30),
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
			Parent = GUI,
		}, {
			New("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				Padding = UDim.new(0, 20),
			}),
		})
	end

	function Notification:New(Config)
		Config.Title = Config.Title or "Title"
		Config.Content = Config.Content or "Content"
		Config.SubContent = Config.SubContent or ""
		Config.Duration = Config.Duration or nil
		Config.Buttons = Config.Buttons or {}
		local NewNotification = {
			Closed = false,
		}

		NewNotification.AcrylicPaint = Acrylic.AcrylicPaint()

		local ResolvedIcon = Config.Icon
		if type(ResolvedIcon) == "string" and ResolvedIcon ~= ""
			and not ResolvedIcon:match("^rbxassetid://")
			and not ResolvedIcon:match("^rbxasset://")
			and not ResolvedIcon:match("^http") then
			ResolvedIcon = Library:GetIcon(ResolvedIcon)
		end

		local IconImage, IconRectOffset, IconRectSize
		if type(ResolvedIcon) == "table" then
			IconImage = ResolvedIcon.Image
			IconRectOffset = ResolvedIcon.ImageRectOffset
			IconRectSize = ResolvedIcon.ImageRectSize
		elseif type(ResolvedIcon) == "string" and ResolvedIcon ~= "" then
			IconImage = ResolvedIcon
		end

		local IconOffset = IconImage and 26 or 0

		NewNotification.Title = New("TextLabel", {
			Text = Config.Title,
			RichText = true,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextTransparency = 0,
			FontFace = Font.new(Library.Font),
			TextSize = 13,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(1, 0, 0, 12),
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		NewNotification.ContentLabel = New("TextLabel", {
			FontFace = Font.new(Library.Font),
			Text = Config.Content,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 14),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			TextWrapped = true,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		NewNotification.SubContentLabel = New("TextLabel", {
			FontFace = Font.new(Library.Font),
			Text = Config.SubContent,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 14),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			TextWrapped = true,
			ThemeTag = {
				TextColor3 = "SubText",
			},
		})

		NewNotification.LabelHolder = New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = 2,
		}, {
			New("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, 3),
			}),
			NewNotification.ContentLabel,
			NewNotification.SubContentLabel,
		})

		NewNotification.TextHolder = New("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(14 + IconOffset, 17),
			Size = UDim2.new(1, -28 - IconOffset, 0, 0),
		}, {
			New("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 11),
			}),
			NewNotification.Title,
			NewNotification.LabelHolder,
		})

		if IconImage then
			NewNotification.IconLabel = New("ImageLabel", {
				Image = IconImage,
				ImageRectOffset = IconRectOffset,
				ImageRectSize = IconRectSize,
				Size = UDim2.fromOffset(20, 20),
				Position = UDim2.fromOffset(14, 17),
				BackgroundTransparency = 1,
				ZIndex = 2,
				ThemeTag = {
					ImageColor3 = "Text",
				},
			})

			local function UpdateIconPosition()
				local TextHeight = NewNotification.TextHolder.AbsoluteSize.Y
				NewNotification.IconLabel.Position = UDim2.fromOffset(14, 17 + (TextHeight / 2) - 10)
			end

			Creator.AddSignal(NewNotification.TextHolder:GetPropertyChangedSignal("AbsoluteSize"), UpdateIconPosition)
			task.defer(UpdateIconPosition)
		end

		NewNotification.CloseButton = New("TextButton", {
			Text = "",
			Position = UDim2.new(1, -14, 0, 13),
			Size = UDim2.fromOffset(20, 20),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
		}, {
			New("ImageLabel", {
				Image = (Library.NewVisual and Components.AssetsNew or Components.Assets).Close,
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				ThemeTag = {
					ImageColor3 = "Text",
				},
			}),
		})

		local RootChildren = {
			NewNotification.AcrylicPaint.Frame,
			NewNotification.CloseButton,
			NewNotification.TextHolder,
		}
		if NewNotification.IconLabel then
			table.insert(RootChildren, NewNotification.IconLabel)
		end

		NewNotification.Root = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.fromScale(1, 0),
		}, RootChildren)

		if Config.Content == "" then
			NewNotification.ContentLabel.Visible = false
		end

		if Config.SubContent == "" then
			NewNotification.SubContentLabel.Visible = false
		end

		NewNotification.Holder = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 200),
			Parent = Notification.Holder,
		}, {
			NewNotification.Root,
		})

		local RootMotor = Flipper.GroupMotor.new({
			Scale = 1,
			Offset = 60,
		})

		RootMotor:onStep(function(Values)
			NewNotification.Root.Position = UDim2.new(Values.Scale, Values.Offset, 0, 0)
		end)

		Creator.AddSignal(NewNotification.CloseButton.MouseButton1Click, function()
			NewNotification:Close()
		end)

		function NewNotification:Open()
			local ContentSize = NewNotification.LabelHolder.AbsoluteSize.Y
			NewNotification.Holder.Size = UDim2.new(1, 0, 0, 58 + ContentSize)

			RootMotor:setGoal({
				Scale = Spring(0, { frequency = 5 }),
				Offset = Spring(0, { frequency = 5 }),
			})
		end

		function NewNotification:Close()
			if not NewNotification.Closed then
				NewNotification.Closed = true
				task.spawn(function()
					RootMotor:setGoal({
						Scale = Spring(1, { frequency = 5 }),
						Offset = Spring(60, { frequency = 5 }),
					})
					task.wait(0.4)
					if Library.UseAcrylic then
						NewNotification.AcrylicPaint.Model:Destroy()
					end
					NewNotification.Holder:Destroy()
				end)
			end
		end

		NewNotification:Open()
		if Config.Duration then
			task.delay(Config.Duration, function()
				NewNotification:Close()
			end)
		end
		return NewNotification
	end

	return Notification
end)()

Components.Toast = (function()
	local New = Creator.New

	local Toast = {
		Holders = {},
		Order = 0,
	}

	local TypeStyles = {
		Info = { Icon = Library.InternalIcons.Info, Color = nil },
		Success = { Icon = Library.InternalIcons.CircleCheck, Color = Color3.fromRGB(80, 200, 120) },
		Warning = { Icon = Library.InternalIcons.TriangleAlert, Color = Color3.fromRGB(255, 190, 70) },
		Error = { Icon = Library.InternalIcons.CircleX, Color = Color3.fromRGB(240, 85, 85) },
	}

	function Toast:Init(GUI)
		Toast.GUI = GUI
	end

	local function ResolveIcon(Source)
		if type(Source) == "number" then
			return { Image = "rbxassetid://" .. Source }
		end
		if type(Source) == "table" then
			if Source.Image then
				return Source
			end
			return nil
		end
		if type(Source) ~= "string" or Source == "" then
			return nil
		end
		if Source:match("^%d+$") then
			return { Image = "rbxassetid://" .. Source }
		end
		if Source:match("^rbxassetid://") or Source:match("^rbxasset://") or Source:match("^http") then
			return { Image = Source }
		end
		local Ok, Icon = pcall(function()
			return Library:GetIcon(Source)
		end)
		if Ok and type(Icon) == "table" and Icon.Image then
			return Icon
		end
		return nil
	end

	local function GetHolder(Position)
		local Key = Position == "Top" and "Top" or "Bottom"
		local Existing = Toast.Holders[Key]
		if Existing and Existing.Parent then
			return Existing, Key == "Top"
		end

		local IsTop = Key == "Top"
		local Holder = New("Frame", {
			Name = "ToastHolder" .. Key,
			AnchorPoint = Vector2.new(0.5, IsTop and 0 or 1),
			Position = UDim2.new(0.5, 0, IsTop and 0 or 1, IsTop and 30 or -30),
			Size = UDim2.new(0, 380, 1, -60),
			BackgroundTransparency = 1,
			Parent = Toast.GUI,
		}, {
			New("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = IsTop and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Bottom,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8),
			}),
		})

		Toast.Holders[Key] = Holder
		return Holder, IsTop
	end

	function Toast:New(Config)
		if type(Config) == "string" then
			Config = { Content = Config }
		end
		Config = Config or {}

		local Title = Config.Title and tostring(Config.Title) or ""
		local Content = Config.Content and tostring(Config.Content) or ""
		local Duration = Config.Duration
		if Duration == nil then
			Duration = 3
		end
		local ShowProgress = type(Duration) == "number" and Duration > 0 and Config.Progress ~= false
		local Style = TypeStyles[Config.Type or "Info"] or TypeStyles.Info
		local Holder, IsTop = GetHolder(Config.Position)
		local Offset = IsTop and -16 or 16

		local NewToast = {
			Closed = false,
			Ready = false,
		}

		local function AccentTag(Property)
			if Style.Color then
				return nil
			end
			return { [Property] = "Accent" }
		end

		local IconLabel = New("ImageLabel", {
			Name = "ToastIcon",
			ImageColor3 = Style.Color or Color3.fromRGB(255, 255, 255),
			Size = UDim2.fromOffset(18, 18),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Visible = false,
			ThemeTag = AccentTag("ImageColor3"),
		})

		local function ApplyIcon(Data)
			IconLabel.Visible = Data ~= nil
			if Data then
				IconLabel.Image = Data.Image
				IconLabel.ImageRectOffset = Data.ImageRectOffset or Vector2.zero
				IconLabel.ImageRectSize = Data.ImageRectSize or Vector2.zero
			end
		end

		if Config.Icon ~= false then
			ApplyIcon(ResolveIcon(Config.Icon) or ResolveIcon(Style.Icon))
		end

		local TitleLabel = New("TextLabel", {
			Name = "ToastTitle",
			FontFace = Font.new(Library.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			Text = Title,
			RichText = true,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.fromOffset(0, 14),
			BackgroundTransparency = 1,
			Visible = Title ~= "",
			LayoutOrder = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		}, {
			New("UISizeConstraint", {
				MaxSize = Vector2.new(290, math.huge),
			}),
		})

		local ContentLabel = New("TextLabel", {
			Name = "ToastContent",
			FontFace = Font.new(Library.Font),
			Text = Content,
			RichText = true,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.fromOffset(0, 14),
			BackgroundTransparency = 1,
			Visible = Content ~= "",
			LayoutOrder = 2,
			ThemeTag = {
				TextColor3 = Title ~= "" and "SubText" or "Text",
			},
		}, {
			New("UISizeConstraint", {
				MaxSize = Vector2.new(290, math.huge),
			}),
		})

		local ContentButton = New("TextButton", {
			Name = "ToastContentHolder",
			Text = "",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.fromOffset(0, 0),
			LayoutOrder = 1,
		}, {
			IconLabel,
			New("Frame", {
				Name = "ToastText",
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.fromOffset(0, 0),
				LayoutOrder = 2,
			}, {
				New("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 2),
				}),
				TitleLabel,
				ContentLabel,
			}),
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10),
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 14),
				PaddingRight = UDim.new(0, 14),
			}),
		})

		local ProgressFill = New("Frame", {
			Name = "ToastProgressFill",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Style.Color or Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			ThemeTag = AccentTag("BackgroundColor3"),
		})

		local PillChildren = {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
			New("UIStroke", {
				Transparency = 0.3,
				ThemeTag = {
					Color = "DialogBorder",
					Transparency = "DialogBorderTransparency",
				},
			}),
			New("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
			}),
			ContentButton,
		}

		if ShowProgress then
			table.insert(PillChildren, New("Frame", {
				Name = "ToastProgress",
				Size = UDim2.new(1, 0, 0, 2),
				BackgroundTransparency = 1,
				LayoutOrder = 2,
			}, {
				ProgressFill,
			}))
		end

		NewToast.Wrapper = New("Frame", {
			Name = "ToastWrapper",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = (function()
				Toast.Order = Toast.Order + 1
				return Toast.Order
			end)(),
			Parent = Holder,
		})

		NewToast.Pill = New("CanvasGroup", {
			Name = "Toast",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.fromOffset(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			GroupTransparency = 1,
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(30, 30, 30),
			Parent = NewToast.Wrapper,
			ThemeTag = {
				BackgroundColor3 = "Dialog",
			},
		}, PillChildren)

		function NewToast:SetTitle(Text)
			TitleLabel.Text = Text and tostring(Text) or ""
			TitleLabel.Visible = TitleLabel.Text ~= ""
		end

		function NewToast:SetContent(Text)
			ContentLabel.Text = Text and tostring(Text) or ""
			ContentLabel.Visible = ContentLabel.Text ~= ""
		end

		function NewToast:SetIcon(Source)
			ApplyIcon(ResolveIcon(Source))
		end

		function NewToast:Close()
			if NewToast.Closed then
				return
			end
			NewToast.Closed = true

			local Wrapper, Pill = NewToast.Wrapper, NewToast.Pill
			if not Wrapper or not Wrapper.Parent then
				return
			end

			if not NewToast.Ready then
				Wrapper:Destroy()
				return
			end

			TweenService:Create(Pill, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				GroupTransparency = 1,
				Position = UDim2.new(0.5, 0, 0, Offset),
			}):Play()

			task.delay(0.12, function()
				if not Wrapper.Parent then
					return
				end
				local Collapse = TweenService:Create(Wrapper, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
					Size = UDim2.new(1, 0, 0, 0),
				})
				Collapse:Play()
				task.delay(0.27, function()
					Wrapper:Destroy()
				end)
			end)

			if Config.OnClose then
				Library:SafeCallback(Config.OnClose)
			end
		end

		if Config.Closable ~= false then
			Creator.AddSignal(ContentButton.MouseButton1Click, function()
				NewToast:Close()
			end)
		end

		task.spawn(function()
			task.wait()
			local Wrapper, Pill = NewToast.Wrapper, NewToast.Pill
			if NewToast.Closed or not Wrapper.Parent then
				return
			end

			local Height = Pill.AbsoluteSize.Y
			Wrapper.AutomaticSize = Enum.AutomaticSize.None
			Wrapper.Size = UDim2.new(1, 0, 0, 0)
			Pill.Position = UDim2.new(0.5, 0, 0, Offset)
			NewToast.Ready = true

			TweenService:Create(Wrapper, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 0, Height),
			}):Play()
			TweenService:Create(Pill, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				GroupTransparency = 0,
				Position = UDim2.new(0.5, 0, 0, 0),
			}):Play()

			if type(Duration) == "number" and Duration > 0 then
				if ShowProgress then
					TweenService:Create(ProgressFill, TweenInfo.new(Duration, Enum.EasingStyle.Linear), {
						Size = UDim2.fromScale(0, 1),
					}):Play()
				end
				task.delay(Duration, function()
					NewToast:Close()
				end)
			end
		end)

		return NewToast
	end

	return Toast
end)()

Components.Dialog = (function()
	local Spring = Flipper.Spring.new
	local Instant = Flipper.Instant.new
	local New = Creator.New

	local Dialog = {
		Window = nil,
	}

	function Dialog:Init(Window)
		Dialog.Window = Window
		return Dialog
	end

	function Dialog:Create()
		local NewDialog = {
			Buttons = 0,
		}

		NewDialog.TintFrame = New("TextButton", {
			Text = "",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			Parent = Dialog.Window.Root,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		})

		local TintMotor, TintTransparency = Creator.SpringMotor(1, NewDialog.TintFrame, "BackgroundTransparency", true)

		NewDialog.ButtonHolder = New("Frame", {
			Size = UDim2.new(1, -40, 1, -40),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 10),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		})

		NewDialog.HolderLine = New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			ThemeTag = {
				BackgroundColor3 = "DialogHolderLine",
			},
		})

		NewDialog.HolderGradient = New("UIGradient", {
			ThemeTag = {
				Color = "DialogHolder",
				Rotation = "DialogHolderRotation",
				Transparency = "DialogHolderTransparency",
			},
		})

		NewDialog.ButtonHolderFrame = New("Frame", {
			Size = UDim2.new(1, 0, 0, 70),
			Position = UDim2.new(0, 0, 1, -70),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		}, {
			NewDialog.HolderGradient,
			NewDialog.HolderLine,
			NewDialog.ButtonHolder,
		})

		NewDialog.Title = New("TextLabel", {
			FontFace = Font.new(Library.Font, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			Text = "Dialog",
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 22,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 22),
			Position = UDim2.fromOffset(20, 25),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		NewDialog.Scale = New("UIScale", {
			Scale = 1,
		})

		local ScaleMotor, Scale = Creator.SpringMotor(1.1, NewDialog.Scale, "Scale")

		NewDialog.Root = New("CanvasGroup", {
			Size = UDim2.fromOffset(300, 165),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			GroupTransparency = 1,
			Parent = NewDialog.TintFrame,
			ThemeTag = {
				BackgroundColor3 = "Dialog",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
			New("UIStroke", {
				Transparency = 0.5,
				ThemeTag = {
					Color = "DialogBorder",
				},
			}),
			NewDialog.Scale,
			NewDialog.Title,
			NewDialog.ButtonHolderFrame,
		})

		local RootMotor, RootTransparency = Creator.SpringMotor(1, NewDialog.Root, "GroupTransparency")

		function NewDialog:Open()
			Library.DialogOpen = true
			NewDialog.Scale.Scale = 1.1
			TintTransparency(0.75)
			RootTransparency(0)
			Scale(1)
		end

		function NewDialog:Close()
			Library.DialogOpen = false
			TintTransparency(1)
			RootTransparency(1)
			Scale(1.1)
			NewDialog.Root.UIStroke:Destroy()
			task.wait(0.15)
			Creator.Release(NewDialog.TintFrame)
			NewDialog.TintFrame:Destroy()
		end

		function NewDialog:Button(Title, Callback)
			NewDialog.Buttons = NewDialog.Buttons + 1
			Title = Title or "Button"
			Callback = Callback or function() end

			local Button = Components.Button("", NewDialog.ButtonHolder, true)
			Button.Title.Text = Title

			for _, Btn in next, NewDialog.ButtonHolder:GetChildren() do
				if Btn:IsA("TextButton") then
					Btn.Size =
						UDim2.new(1 / NewDialog.Buttons, -(((NewDialog.Buttons - 1) * 10) / NewDialog.Buttons), 0, 32)
				end
			end

			Creator.AddSignal(Button.Frame.MouseButton1Click, function()
				Library:SafeCallback(Callback)
				pcall(function()
					NewDialog:Close()
				end)
			end)

			return Button
		end

		return NewDialog
	end

	return Dialog
end)()

Components.SidePanel = (function()
	local Spring = Flipper.Spring.new
	local New = Creator.New

	local SidePanel = {
		Window = nil,
	}

	function SidePanel:Init(Window)
		SidePanel.Window = Window
		return SidePanel
	end

	local MenuButtonTags = { Background = "MenuButton", Border = "MenuButtonBorder" }
	local MenuInputTags = {
		Input = "MenuInput",
		InputLine = "MenuInputLine",
		InputBorder = "MenuButtonBorder",
		InputFocused = "MenuInputFocused",
	}

	function SidePanel:Create(Config)
		Config = Config or {}
		local Side = Config.Side == "Left" and "Left" or "Right"
		local PanelId = Config.Id or Config.Title or "Panel"
		local SavedState = Library.PanelSizes[PanelId]
		local SizeConfig = typeof(Config.Size) == "UDim2" and Config.Size or nil
		local PanelWidth = (SavedState and tonumber(SavedState.Width)) or (SizeConfig and SizeConfig.X.Offset) or Config.Width or 300
		local PanelHeight = SizeConfig and SizeConfig.Y.Offset > 0 and SizeConfig.Y.Offset or nil
		local Dock = SavedState and (SavedState.Dock == "Left" or SavedState.Dock == "Right") and SavedState.Dock or Side
		local AnchorX = Dock == "Right" and 1 or 0

		local NewPanel = {
			Buttons = 0,
			Rows = 0,
			Side = Side,
		}

		setmetatable(NewPanel, Elements)

		NewPanel.TintFrame = New("TextButton", {
			Text = "",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1,
			Parent = SidePanel.Window.Root,
		})

		local TintMotor, TintTransparency = Creator.SpringMotor(1, NewPanel.TintFrame, "BackgroundTransparency", true)

		NewPanel.Title = New("TextLabel", {
			FontFace = Font.new(Library.Font, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			Text = Config.Title or "Panel",
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 18,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 0, 20),
			Position = UDim2.fromOffset(20, 18),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		NewPanel.Description = New("TextLabel", {
			FontFace = Font.new(Library.Font),
			Text = Config.Description or "",
			Visible = Config.Description ~= nil and Config.Description ~= "",
			TextColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = 13,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 0, 16),
			Position = UDim2.fromOffset(20, 42),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "SubText",
			},
		})

		NewPanel.RowHolder = New("ScrollingFrame", {
			Size = UDim2.new(1, -20, 1, -140),
			Position = UDim2.fromOffset(10, 68),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageTransparency = 0.4,
			CanvasSize = UDim2.fromScale(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ClipsDescendants = true,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4),
			}),
		})

		NewPanel.RowHolder:SetAttribute("SidePanelRows", true)
		NewPanel.Container = NewPanel.RowHolder
		NewPanel.Type = "Group"
		NewPanel.ScrollFrame = NewPanel.RowHolder
		NewPanel.Library = Library

		NewPanel.HolderLine = New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			ThemeTag = {
				BackgroundColor3 = "MenuHolderLine",
			},
		})

		NewPanel.ButtonHolder = New("Frame", {
			Size = UDim2.new(1, -20, 0, 32),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 10),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
		})

		NewPanel.ButtonHolderFrame = New("Frame", {
			Size = UDim2.new(1, 0, 0, 64),
			Position = UDim2.new(0, 0, 1, -64),
			ThemeTag = {
				BackgroundColor3 = "MenuHolder",
			},
		}, {
			NewPanel.HolderLine,
			NewPanel.ButtonHolder,
		})

		local MinPanelWidth = Config.MinWidth or 240

		local function GetMaxWidth()
			local WindowWidth = SidePanel.Window.Root.AbsoluteSize.X
			local Limit = WindowWidth > 0 and WindowWidth or math.huge
			if Config.MaxWidth then
				Limit = math.min(Limit, Config.MaxWidth)
			end
			return math.max(MinPanelWidth, Limit)
		end

		PanelWidth = math.floor(math.clamp(PanelWidth, MinPanelWidth, GetMaxWidth()))

		local function GetRootSize()
			if PanelHeight then
				return UDim2.fromOffset(PanelWidth, PanelHeight)
			end
			return UDim2.new(0, PanelWidth, 1, -20)
		end

		local function GetSlideOffset()
			return Dock == "Right" and (PanelWidth + 24) or -(PanelWidth + 24)
		end

		NewPanel.Dock = Dock
		NewPanel.Size = GetRootSize()
		NewPanel.SlideOffset = GetSlideOffset()
		local SlideMotor = Flipper.SingleMotor.new(NewPanel.SlideOffset)

		local ResizeActive = false
		local ResizeMoveConnection
		local ResizeEndConnection
		local LeftGrip
		local RightGrip

		local function CreateResizeHandle(OnLeft)
			local Grip = New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(3, 36),
				BackgroundTransparency = 0.6,
				ThemeTag = {
					BackgroundColor3 = "SubText",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			})

			local Handle = New("TextButton", {
				Name = OnLeft and "ResizeHandleLeft" or "ResizeHandleRight",
				Text = "",
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(OnLeft and 0 or 1, 0),
				Position = UDim2.fromScale(OnLeft and 0 or 1, 0),
				Size = UDim2.new(0, 10, 1, 0),
				ZIndex = 10,
			}, {
				Grip,
			})

			return Handle, Grip
		end

		NewPanel.ResizeLeft, LeftGrip = CreateResizeHandle(true)
		NewPanel.ResizeRight, RightGrip = CreateResizeHandle(false)

		NewPanel.Root = New("CanvasGroup", {
			Size = NewPanel.Size,
			AnchorPoint = Vector2.new(AnchorX, 0.5),
			Position = UDim2.new(AnchorX, NewPanel.SlideOffset, 0.5, 0),
			GroupTransparency = 1,
			BackgroundTransparency = 1,
			Parent = NewPanel.TintFrame,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
			New("UIStroke", {
				Transparency = 0.5,
				ThemeTag = {
					Color = "MenuBorder",
					Transparency = "MenuBorderTransparency",
				},
			}),
			New("Frame", {
				Name = "MenuBackground",
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 8),
				}),
				New("UIGradient", {
					ThemeTag = {
						Color = "MenuBackground",
						Rotation = "MenuBackgroundRotation",
						Transparency = "MenuBackgroundTransparency",
					},
				}),
			}),
			NewPanel.Title,
			NewPanel.Description,
			NewPanel.RowHolder,
			NewPanel.ButtonHolderFrame,
			NewPanel.ResizeLeft,
			NewPanel.ResizeRight,
		})

		local function UpdateHandles()
			local Full = PanelWidth >= GetMaxWidth()
			NewPanel.ResizeLeft.Visible = Full or Dock == "Right"
			NewPanel.ResizeRight.Visible = Full or Dock == "Left"
			NewPanel.RowHolder.VerticalScrollBarPosition = Dock == "Right" and Enum.VerticalScrollBarPosition.Right or Enum.VerticalScrollBarPosition.Left
		end

		local function SetDock(NewDock)
			if Dock == NewDock then
				return
			end

			Dock = NewDock
			NewPanel.Dock = Dock
			AnchorX = Dock == "Right" and 1 or 0
			NewPanel.SlideOffset = GetSlideOffset()
			NewPanel.Root.AnchorPoint = Vector2.new(AnchorX, 0.5)
			NewPanel.Root.Position = UDim2.new(AnchorX, 0, 0.5, 0)
			UpdateHandles()
		end

		function NewPanel:SetWidth(Width)
			PanelWidth = math.floor(math.clamp(Width, MinPanelWidth, GetMaxWidth()))
			NewPanel.SlideOffset = GetSlideOffset()
			NewPanel.Size = GetRootSize()
			NewPanel.Root.Size = NewPanel.Size
			UpdateHandles()
		end

		local function SaveState()
			Library.PanelSizes[PanelId] = { Width = PanelWidth, Dock = Dock }
			if Library.OnPanelSizeChanged then
				Library:SafeCallback(Library.OnPanelSizeChanged, PanelId, Library.PanelSizes[PanelId])
			end
		end

		function NewPanel:SetSize(Value)
			local Width = typeof(Value) == "UDim2" and Value.X.Offset or typeof(Value) == "Vector2" and Value.X or tonumber(Value)
			if Width then
				NewPanel:SetWidth(Width)
				SaveState()
			end
		end

		local function StopResize(Commit)
			local WasActive = ResizeActive
			ResizeActive = false
			LeftGrip.BackgroundTransparency = 0.6
			RightGrip.BackgroundTransparency = 0.6

			if ResizeMoveConnection then
				ResizeMoveConnection:Disconnect()
				ResizeMoveConnection = nil
			end
			if ResizeEndConnection then
				ResizeEndConnection:Disconnect()
				ResizeEndConnection = nil
			end

			if Commit and WasActive then
				SaveState()
			end
		end

		local function BeginResize(Input, FromLeft, Grip)
			if NewPanel.Closing then
				return
			end
			if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			StopResize(false)
			ResizeActive = true
			Grip.BackgroundTransparency = 0.1
			SetDock(FromLeft and "Right" or "Left")

			local StartX = Input.Position.X
			local StartWidth = PanelWidth
			local Direction = FromLeft and -1 or 1

			ResizeMoveConnection = UserInputService.InputChanged:Connect(function(MoveInput)
				if MoveInput.UserInputType == Enum.UserInputType.MouseMovement or MoveInput.UserInputType == Enum.UserInputType.Touch then
					NewPanel:SetWidth(StartWidth + (MoveInput.Position.X - StartX) * Direction)
				end
			end)

			ResizeEndConnection = UserInputService.InputEnded:Connect(function(EndInput)
				if EndInput.UserInputType == Enum.UserInputType.MouseButton1 or EndInput.UserInputType == Enum.UserInputType.Touch then
					StopResize(true)
				end
			end)
		end

		for _, Entry in ipairs({ { NewPanel.ResizeLeft, LeftGrip, true }, { NewPanel.ResizeRight, RightGrip, false } }) do
			local Handle = Entry[1]
			local Grip = Entry[2]
			local FromLeft = Entry[3]

			Creator.AddSignal(Handle.MouseEnter, function()
				if not ResizeActive then
					Grip.BackgroundTransparency = 0.3
				end
			end)

			Creator.AddSignal(Handle.MouseLeave, function()
				if not ResizeActive then
					Grip.BackgroundTransparency = 0.6
				end
			end)

			Creator.AddSignal(Handle.InputBegan, function(Input)
				BeginResize(Input, FromLeft, Grip)
			end)
		end

		UpdateHandles()

		SlideMotor:onStep(function(Value)
			NewPanel.Root.Position = UDim2.new(AnchorX, Value, 0.5, 0)
		end)

		local RootMotor, RootTransparency = Creator.SpringMotor(1, NewPanel.Root, "GroupTransparency")

		function NewPanel:Open()
			Library.DialogOpen = true
			TintTransparency(0.75)
			RootTransparency(0)
			SlideMotor:setGoal(Spring(0, { frequency = 5 }))
		end

		Creator.AddSignal(NewPanel.TintFrame.MouseButton1Click, function()
			pcall(function()
				NewPanel:Close()
			end)
		end)

		function NewPanel:Close()
			if NewPanel.Closing then
				return
			end
			NewPanel.Closing = true
			Library.DialogOpen = false
			StopResize(false)

			pcall(function()
				SlideMotor:stop()
				RootMotor:stop()
				TintMotor:stop()
			end)

			local SlideInfo = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

			TweenService:Create(NewPanel.TintFrame, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 1,
			}):Play()

			TweenService:Create(NewPanel.Root, SlideInfo, {
				Position = UDim2.new(AnchorX, NewPanel.SlideOffset, 0.5, 0),
				GroupTransparency = 1,
			}):Play()

			local Stroke = NewPanel.Root:FindFirstChildOfClass("UIStroke")
			if Stroke then
				TweenService:Create(Stroke, SlideInfo, { Transparency = 1 }):Play()
			end

			task.delay(0.34, function()
				pcall(function()
					Creator.Release(NewPanel.TintFrame)
					NewPanel.TintFrame:Destroy()
				end)
			end)
		end

		function NewPanel:Button(Title, Callback)
			NewPanel.Buttons = NewPanel.Buttons + 1
			Title = Title or "Button"
			Callback = Callback or function() end

			local Button = Components.Button("", NewPanel.ButtonHolder, true, MenuButtonTags)
			Button.Title.Text = Title
			Button.Frame.LayoutOrder = NewPanel.Buttons

			for _, Btn in next, NewPanel.ButtonHolder:GetChildren() do
				if Btn:IsA("TextButton") then
					Btn.Size = UDim2.new(1 / NewPanel.Buttons, -(((NewPanel.Buttons - 1) * 10) / NewPanel.Buttons), 0, 32)
				end
			end

			Creator.AddSignal(Button.Frame.MouseButton1Click, function()
				Library:SafeCallback(Callback)
			end)

			return Button
		end

		function NewPanel:AddInput(IdxOrConfig, RowConfig)
			local Idx
			if type(IdxOrConfig) == "table" then
				RowConfig = IdxOrConfig
			else
				Idx = IdxOrConfig
			end
			RowConfig = RowConfig or {}
			NewPanel.Rows = NewPanel.Rows + 1

			local Row = Components.Element(
				RowConfig.Title,
				RowConfig.Description,
				NewPanel.RowHolder,
				"Hover",
				NewPanel.Rows,
				RowConfig.Icon,
				RowConfig.Marquee ~= false
			)

			local Textbox = Components.Textbox(Row.Frame, true, MenuInputTags)
			Textbox.Frame.Position = UDim2.new(1, -10, 0.5, 0)
			Textbox.Frame.AnchorPoint = Vector2.new(1, 0.5)
			Textbox.Frame.Size = UDim2.fromOffset(140, 30)
			Textbox.Input.Text = RowConfig.Default or ""
			Textbox.Input.PlaceholderText = RowConfig.Placeholder or ""

			local RowInput = {
				Value = RowConfig.Default or "",
				Frame = Row.Frame,
				Type = "Input",
				SetTitle = Row.SetTitle,
				SetDesc = Row.SetDesc,
			}

			local function Commit()
				RowInput.Value = Textbox.Input.Text
				Library:SafeCallback(RowConfig.Callback, RowInput.Value)
			end

			if RowConfig.Finished then
				Creator.AddSignal(Textbox.Input.FocusLost, function(EnterPressed)
					Commit()
				end)
			else
				Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("Text"), Commit)
			end

			function RowInput:SetValue(Text)
				Textbox.Input.Text = Text
				RowInput.Value = Text
			end

			function RowInput:Destroy()
				if Idx then
					Library.Options[Idx] = nil
				end
			end

			if Idx then
				Library.Options[Idx] = RowInput
			end

			return RowInput
		end

		function NewPanel:AddButton(IdxOrConfig, RowConfig)
			if type(IdxOrConfig) == "table" then
				RowConfig = IdxOrConfig
			end
			RowConfig = RowConfig or {}
			NewPanel.Rows = NewPanel.Rows + 1

			local Row = Components.Element(
				RowConfig.Title,
				RowConfig.Description,
				NewPanel.RowHolder,
				true,
				NewPanel.Rows,
				RowConfig.Icon,
				RowConfig.Marquee ~= false
			)

			New("ImageLabel", {
				Image = "rbxassetid://10709791437",
				Size = UDim2.fromOffset(16, 16),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -10, 0.5, 0),
				BackgroundTransparency = 1,
				Parent = Row.Frame,
				ThemeTag = {
					ImageColor3 = "Text",
				},
			})

			Creator.AddSignal(Row.Frame.MouseButton1Click, function()
				Library:SafeCallback(RowConfig.Callback)
			end)

			return {
				Frame = Row.Frame,
				Type = "Button",
				SetTitle = Row.SetTitle,
				SetDesc = Row.SetDesc,
			}
		end

		function NewPanel:AddToggle(Idx, RowConfig)
			RowConfig = RowConfig or {}
			NewPanel.Rows = NewPanel.Rows + 1
			RowConfig.LayoutOrder = NewPanel.Rows
			return Elements.AddToggle(NewPanel, Idx, RowConfig)
		end

		function NewPanel:AddSlider(Idx, RowConfig)
			RowConfig = RowConfig or {}
			NewPanel.Rows = NewPanel.Rows + 1
			RowConfig.LayoutOrder = NewPanel.Rows
			return Elements.AddSlider(NewPanel, Idx, RowConfig)
		end

		function NewPanel:AddColorpicker(Idx, RowConfig)
			RowConfig = RowConfig or {}
			NewPanel.Rows = NewPanel.Rows + 1
			RowConfig.LayoutOrder = NewPanel.Rows
			return Elements.AddColorpicker(NewPanel, Idx, RowConfig)
		end

		function NewPanel:AddDropdown(Idx, RowConfig)
			RowConfig = RowConfig or {}
			NewPanel.Rows = NewPanel.Rows + 1
			RowConfig.LayoutOrder = NewPanel.Rows
			return Elements.AddDropdown(NewPanel, Idx, RowConfig)
		end

		function NewPanel:AddGradientPicker(Idx, RowConfig)
			RowConfig = RowConfig or {}
			NewPanel.Rows = NewPanel.Rows + 1
			RowConfig.LayoutOrder = NewPanel.Rows
			return Elements.AddGradientPicker(NewPanel, Idx, RowConfig)
		end

		function NewPanel:PromptImport(ImportConfig)
			ImportConfig = ImportConfig or {}

			local ImportDialog = Components.Dialog:Create()
			ImportDialog.Title.Text = ImportConfig.Title or "Import"
			ImportDialog.Root.Size = UDim2.fromOffset(320, 190)

			local ImportBox = Components.Textbox(nil, false)
			ImportBox.Frame.Parent = ImportDialog.Root
			ImportBox.Frame.Position = UDim2.fromOffset(20, 60)
			ImportBox.Frame.Size = UDim2.new(1, -40, 0, 32)
			ImportBox.Input.Text = ImportConfig.Default or ""
			ImportBox.Input.PlaceholderText = ImportConfig.Placeholder or "Paste import string here"

			ImportDialog:Button("Cancel", function()
				Library:SafeCallback(ImportConfig.OnCancel)
			end)

			ImportDialog:Button("Confirm", function()
				Library:SafeCallback(ImportConfig.Callback, ImportBox.Input.Text)
			end)

			ImportDialog:Open()
			return ImportDialog
		end

		if Config.Buttons and #Config.Buttons > 0 then
			for _, BtnCfg in ipairs(Config.Buttons) do
				NewPanel:Button(BtnCfg.Title or "Button", function()
					Library:SafeCallback(BtnCfg.Callback)
					if BtnCfg.CloseOnClick ~= false then
						pcall(function() NewPanel:Close() end)
					end
				end)
			end
		end

		return NewPanel
	end

	return SidePanel
end)()

Components.Tab = (function()
	local New = Creator.New
	local Spring = Flipper.Spring.new
	local Instant = Flipper.Instant.new

	local function GetHeaderTextWidth(Text)
		return TextService:GetTextSize(
			Text,
			12,
			Enum.Font.GothamMedium,
			Vector2.new(math.huge, math.huge)
		).X
	end

	local function CreateHeaderChip(TabModule, TabIndex, Title, IconImage, IconRectOffset, IconRectSize)
		local Window = TabModule.Window
		local HasIcon = IconImage ~= nil
		local CollapsedWidth = HasIcon and 36 or 26
		local ExpandedWidth = CollapsedWidth + GetHeaderTextWidth(Title) + (HasIcon and 10 or 8)

		local Chip = {
			Selected = false,
			Hovering = false,
		}

		Chip.Frame = New("Frame", {
			Size = UDim2.fromOffset(CollapsedWidth, 28),
			BackgroundTransparency = 1,
			LayoutOrder = TabIndex,
			ClipsDescendants = true,
			Parent = Window.NavigatorHolder,
			ThemeTag = {
				BackgroundColor3 = "Tab",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 6),
			}),
		})

		if HasIcon then
			Chip.Icon = New("ImageLabel", {
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new(0, 10, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Image = IconImage,
				ImageRectOffset = IconRectOffset,
				ImageRectSize = IconRectSize,
				Parent = Chip.Frame,
				SeasonalHat = "Icon",
				ThemeTag = {
					ImageColor3 = "Text",
				},
			})
		else
			Chip.Icon = New("TextLabel", {
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new(0, 5, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Text = string.upper(string.sub(Title, 1, 1)),
				RichText = true,
				FontFace = Font.new(Library.Font, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
				TextSize = 13,
				TextXAlignment = "Center",
				TextYAlignment = "Center",
				Parent = Chip.Frame,
				ThemeTag = {
					TextColor3 = "Text",
				},
			})
		end

		local LabelOffset = HasIcon and 32 or 24

		Chip.Label = New("TextLabel", {
			Text = Title,
			RichText = true,
			TextTransparency = 1,
			FontFace = Font.new(Library.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			TextSize = 12,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -(LabelOffset + 6), 1, 0),
			Position = UDim2.fromOffset(LabelOffset, 0),
			Parent = Chip.Frame,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		Chip.HitBox = New("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			Parent = Chip.Frame,
		})

		local WidthMotor = Flipper.SingleMotor.new(CollapsedWidth)
		WidthMotor:onStep(function(Value)
			Chip.Frame.Size = UDim2.fromOffset(Value, 28)
		end)

		local BackgroundMotor, SetBackgroundTransparency = Creator.SpringMotor(1, Chip.Frame, "BackgroundTransparency")
		if Library.NewVisual then
			SetBackgroundTransparency = function() end
		end
		local LabelMotor, SetLabelTransparency = Creator.SpringMotor(1, Chip.Label, "TextTransparency")

		local SetInitialTransparency
		local LabelPosMotor
		if not HasIcon then
			local InitialMotor
			InitialMotor, SetInitialTransparency = Creator.SpringMotor(0, Chip.Icon, "TextTransparency")
			LabelPosMotor = Flipper.SingleMotor.new(LabelOffset)
			LabelPosMotor:onStep(function(Value)
				Chip.Label.Position = UDim2.fromOffset(Value, 0)
				Chip.Label.Size = UDim2.new(1, -(Value + 6), 1, 0)
			end)
		end

		local function SetExpanded(Expanded)
			WidthMotor:setGoal(Spring(Expanded and ExpandedWidth or CollapsedWidth, { frequency = 7 }))
			SetLabelTransparency(Expanded and 0 or 1)
			if SetInitialTransparency then
				SetInitialTransparency(Expanded and 1 or 0)
				LabelPosMotor:setGoal(Spring(Expanded and 8 or LabelOffset, { frequency = 7 }))
			end
		end

		Creator.AddSignal(Chip.HitBox.MouseEnter, function()
			Chip.Hovering = true
			if not Chip.Selected then
				SetBackgroundTransparency(Creator.HoverShift(1, 0.06))
				SetExpanded(true)
			end
		end)

		Creator.AddSignal(Chip.HitBox.MouseLeave, function()
			Chip.Hovering = false
			if not Chip.Selected then
				SetBackgroundTransparency(1, true)
				SetExpanded(false)
			end
		end)

		Creator.AddSignal(Chip.HitBox.MouseButton1Click, function()
			TabModule:SelectTab(TabIndex)
		end)

		Creator.AddSignal(Chip.Frame:GetPropertyChangedSignal("AbsoluteSize"), function()
			if Chip.Selected then
				TabModule:UpdateNavigatorSelector(true)
			end
		end)

		Creator.AddSignal(Chip.Frame:GetPropertyChangedSignal("AbsolutePosition"), function()
			if Chip.Selected then
				TabModule:UpdateNavigatorSelector(true)
			end
		end)

		function Chip.SetTransparency(Value, Ignore)
			Chip.Selected = Value < 1
			SetBackgroundTransparency(Value, Ignore)
			if Chip.Selected then
				SetExpanded(true)
			elseif not Chip.Hovering then
				SetExpanded(false)
			end
		end

		function Chip.SetTitle(Set)
			Set = Set or ""
			Chip.Label.Text = Set
			if not HasIcon then
				Chip.Icon.Text = string.upper(string.sub(Set, 1, 1))
			end
			ExpandedWidth = CollapsedWidth + GetHeaderTextWidth(Set) + (HasIcon and 10 or 8)
			if Chip.Selected or Chip.Hovering then
				SetExpanded(true)
			end
		end

		return Chip
	end

	local TabModule = {
		Window = nil,
		Tabs = {},
		Containers = {},
		SelectedTab = 0,
		TabCount = 0,
		SearchQuery = "",
	}

	function TabModule:Init(Window)
		TabModule.Window = Window
		return TabModule
	end

	function TabModule:GetCurrentTabPos()
		local TabHolderPos = TabModule.Window.TabHolder.AbsolutePosition.Y
		local TabPos = TabModule.Tabs[TabModule.SelectedTab].Frame.AbsolutePosition.Y

		return TabPos - TabHolderPos
	end

	function TabModule:UpdateNavigatorSelector(UseInstant)
		local Window = TabModule.Window
		if not Window.NavigatorHolder then
			return
		end

		local Tab = TabModule.Tabs[TabModule.SelectedTab]
		if not (Tab and Tab.HeaderChip) then
			return
		end

		local WasVisible = Window.NavigatorSelector.Visible
		Window.NavigatorSelector.Visible = true

		local ChipFrame = Tab.HeaderChip.Frame
		local X = ChipFrame.AbsolutePosition.X - Window.NavigatorHolder.AbsolutePosition.X
		local Width = ChipFrame.AbsoluteSize.X

		local MotorType = (UseInstant or (Library.NewVisual and not WasVisible)) and Instant or Spring
		Window.NavigatorSelectorMotor:setGoal({
			X = MotorType(X, { frequency = 10 }),
			Width = MotorType(Width, { frequency = 10 }),
		})
	end

	function TabModule:UpdateTabHighlight(UseInstant)
		local Window = TabModule.Window
		local Highlight = Window.TabHighlight
		if not Highlight then
			return
		end

		local Tab = TabModule.Tabs[TabModule.SelectedTab]
		local TabFrame = Tab and not Tab.IsHeaderTab and Tab.Frame
		if not TabFrame or not TabFrame.Parent or not TabFrame.Parent.Visible then
			Highlight.Visible = false
			return
		end

		local WasVisible = Highlight.Visible
		Highlight.Visible = true

		local Origin = Window.TabHolder.AbsolutePosition
		local X = TabFrame.AbsolutePosition.X - Origin.X
		local Y = TabFrame.AbsolutePosition.Y - Origin.Y
		local Width = TabFrame.AbsoluteSize.X
		local Height = TabFrame.AbsoluteSize.Y

		local Goal = TabModule.HighlightGoal
		if WasVisible and Goal and Goal.X == X and Goal.Y == Y and Goal.Width == Width and Goal.Height == Height then
			return
		end
		TabModule.HighlightGoal = { X = X, Y = Y, Width = Width, Height = Height }

		local MotorType = (UseInstant or not WasVisible) and Instant or Spring
		Window.TabHighlightMotor:setGoal({
			X = MotorType(X, { frequency = 10 }),
			Y = MotorType(Y, { frequency = 10 }),
			Width = MotorType(Width, { frequency = 10 }),
			Height = MotorType(Height, { frequency = 10 }),
		})
	end

	function TabModule:ApplyFilter(Query)
		TabModule.SearchQuery = Query or ""
		local Container = TabModule.Containers[TabModule.SelectedTab]
		if not Container then return end

		local NormalizedQuery = TabModule.SearchQuery:lower()

		for _, Descendant in next, Container:GetDescendants() do
			if Descendant.Name == "ElementTitle" then
				local ElementFrame = Descendant.Parent and Descendant.Parent.Parent
				if ElementFrame then
					ElementFrame.Visible = NormalizedQuery == ""
						or string.find(Descendant.Text:lower(), NormalizedQuery, 1, true) ~= nil
				end
			end
		end

		for _, Descendant in next, Container:GetDescendants() do
			if Descendant.Name == "SectionRoot" then
				local Visible = NormalizedQuery == ""
				if not Visible then
					for _, Inner in next, Descendant:GetDescendants() do
						if Inner.Name == "ElementFrame" and Inner.Visible then
							Visible = true
							break
						end
					end
				end
				Descendant.Visible = Visible
			end
		end
	end

	function TabModule:New(Title, Icon, Parent, IsHeaderTab)
		local Window = TabModule.Window
		local Elements = Library.Elements

		TabModule.TabCount = TabModule.TabCount + 1
		local TabIndex = TabModule.TabCount

		local Tab = {
			Selected = false,
			Name = Title,
			Type = "Tab",
			IsHeaderTab = IsHeaderTab or false,
			_layoutOrder = 0,
		}

		if Icon == "" or Icon == nil then
			Icon = nil
		else
			Icon = Library:GetIcon(Icon)
		end

		local IconImage = Icon
		local IconRectOffset, IconRectSize
		if type(Icon) == "table" then
			IconImage = Icon.Image
			IconRectOffset = Icon.ImageRectOffset
			IconRectSize = Icon.ImageRectSize
		end

		if Tab.IsHeaderTab then
			Tab.HeaderChip = CreateHeaderChip(TabModule, TabIndex, Title, IconImage, IconRectOffset, IconRectSize)
			Tab.SetTransparency = Tab.HeaderChip.SetTransparency

			function Tab:SetTitle(Set)
				Set = Set or ""
				Tab.Name = Set
				Tab.HeaderChip.SetTitle(Set)
			end
		else
			Tab.TitleLabel = New("TextLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = Icon and UDim2.new(0, 30, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
				Text = Title,
				RichText = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextTransparency = 0,
				FontFace = Font.new(Library.Font, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextSize = 12,
				TextXAlignment = "Left",
				TextYAlignment = "Center",
				Size = UDim2.new(1, -12, 1, 0),
				BackgroundTransparency = 1,
				ThemeTag = {
					TextColor3 = "Text",
				},
			})

			Tab.Frame = New("TextButton", {
				Size = UDim2.new(1, 0, 0, 34),
				BackgroundTransparency = 1,
				Parent = Parent,
				LayoutOrder = TabIndex,
				ThemeTag = {
					BackgroundColor3 = "Tab",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
				Tab.TitleLabel,
				New("ImageLabel", {
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.fromOffset(16, 16),
					Position = UDim2.new(0, 8, 0.5, 0),
					BackgroundTransparency = 1,
					Image = IconImage,
					ImageRectOffset = IconRectOffset,
					ImageRectSize = IconRectSize,
					SeasonalHat = IconImage and "Icon" or nil,
					ThemeTag = {
						ImageColor3 = "Text",
					},
				}),
			})

			Creator.AttachTitleDesc(Tab, Tab.TitleLabel, nil)
			local BaseSetTitle = Tab.SetTitle
			function Tab:SetTitle(Set)
				Tab.Name = Set or ""
				BaseSetTitle(Tab, Set)
			end

			Tab.Motor, Tab.SetTransparency = Creator.SpringMotor(1, Tab.Frame, "BackgroundTransparency")

			if Library.NewVisual then
				Tab.SetTransparency = function() end

				local function RefreshHighlight()
					if Tab.Selected then
						TabModule:UpdateTabHighlight(true)
					end
				end
				Creator.AddSignal(Tab.Frame:GetPropertyChangedSignal("AbsolutePosition"), RefreshHighlight)
				Creator.AddSignal(Tab.Frame:GetPropertyChangedSignal("AbsoluteSize"), RefreshHighlight)
			else
				Creator.AddSignal(Tab.Frame.MouseEnter, function()
					Tab.SetTransparency(Tab.Selected and Creator.HoverShift(0.89, 0.04) or Creator.HoverShift(1, 0.11))
				end)
				Creator.AddSignal(Tab.Frame.MouseLeave, function()
					Tab.SetTransparency(Tab.Selected and 0.89 or 1)
				end)
				Creator.AddSignal(Tab.Frame.MouseButton1Down, function()
					Tab.SetTransparency(Creator.HoverShift(1, 0.08))
				end)
				Creator.AddSignal(Tab.Frame.MouseButton1Up, function()
					Tab.SetTransparency(Tab.Selected and Creator.HoverShift(0.89, 0.04) or Creator.HoverShift(1, 0.11))
				end)
			end
			Creator.AddSignal(Tab.Frame.MouseButton1Click, function()
				TabModule:SelectTab(TabIndex)
			end)
		end

		local ContainerLayout = New("UIListLayout", {
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		Tab.ContainerFrame = New("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Parent = Window.ContainerHolder,
			Visible = false,
			BottomImage = "rbxassetid://6889812791",
			MidImage = "rbxassetid://6889812721",
			TopImage = "rbxassetid://6276641225",
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
		}, {
			ContainerLayout,
			New("UIPadding", {
				PaddingRight = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 1),
				PaddingTop = UDim.new(0, 1),
				PaddingBottom = UDim.new(0, 1),
			}),
		})

		Creator.AttachScrollBar(Tab.ContainerFrame, { Thickness = 4 })

		Creator.AddSignal(ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			Tab.ContainerFrame.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 2)
		end)

		TabModule.Containers[TabIndex] = Tab.ContainerFrame
		TabModule.Tabs[TabIndex] = Tab

		Tab.Container = Tab.ContainerFrame
		Tab.ScrollFrame = Tab.Container

		function Tab:AddSection(SectionTitle)
			local Section = { Type = "Section", _layoutOrder = 0 }

			Tab._layoutOrder = (Tab._layoutOrder or 0) + 1
			local SectionFrame = Components.Section(SectionTitle, Tab.Container)
			SectionFrame.Root.LayoutOrder = Tab._layoutOrder

			Section.Container = SectionFrame.Container
			Section.ScrollFrame = Tab.Container
			Creator.AttachTitleDesc(Section, SectionFrame.TitleLabel, nil)

			setmetatable(Section, Elements)
			return Section
		end
		Tab.Section = Tab.AddSection

		setmetatable(Tab, Elements)
		return Tab
	end

	function TabModule:SelectTab(Tab)
		local Window = TabModule.Window

		TabModule.SelectedTab = Tab

		for _, TabObject in next, TabModule.Tabs do
			TabObject.SetTransparency(1)
			TabObject.Selected = false
		end
		TabModule.Tabs[Tab].SetTransparency(0.89)
		TabModule.Tabs[Tab].Selected = true

		Window.TabDisplay.Text = TabModule.Tabs[Tab].Name

		if TabModule.Tabs[Tab].IsHeaderTab then
			Window.Selector.Visible = false
			TabModule:UpdateNavigatorSelector()
		else
			Window.NavigatorSelector.Visible = false
			if not Library.NewVisual then
				Window.Selector.Visible = true
				Window.SelectorPosMotor:setGoal(Spring(TabModule:GetCurrentTabPos(), { frequency = 6 }))
			end
		end

		TabModule:UpdateTabHighlight()

		task.spawn(function()
			Window.ContainerHolder.Parent = Window.ContainerAnim

			Window.ContainerPosMotor:setGoal(Spring(15, { frequency = 10 }))
			Window.ContainerBackMotor:setGoal(Spring(1, { frequency = 10 }))
			task.wait(0.12)
			for _, Container in next, TabModule.Containers do
				Container.Visible = false
			end
			TabModule.Containers[Tab].Visible = true
			TabModule:ApplyFilter(TabModule.SearchQuery)
			Window.ContainerPosMotor:setGoal(Spring(0, { frequency = 5 }))
			Window.ContainerBackMotor:setGoal(Spring(0, { frequency = 8 }))
			task.wait(0.12)
			Window.ContainerHolder.Parent = Window.ContainerCanvas
		end)
	end

	return TabModule
end)()

Components.Window = (function()

	local Spring = Flipper.Spring.new
	local Instant = Flipper.Instant.new
	local New = Creator.New

	return function(Config)

		local Window = {
			Minimized = false,
			Maximized = false,
			Size = Config.Size,
			CurrentPos = 0,
			TabWidth = 0,
			Position = UDim2.fromOffset(
				Camera.ViewportSize.X / 2 - Config.Size.X.Offset / 2,
				Camera.ViewportSize.Y / 2 - Config.Size.Y.Offset / 2
			),
		}

		local Dragging, DragInput, MousePos, StartPos = false
		local Resizing, ResizePos = false
		local MinimizeNotif = false

		Window.AcrylicPaint = Acrylic.AcrylicPaint()
		Window.TabWidth = Config.TabWidth

		local UserInfoConfig = Config.UserInfo
		if UserInfoConfig == true then
			UserInfoConfig = {}
		elseif not UserInfoConfig then
			UserInfoConfig = nil
		end

		local UserInfoHeight = 58
		local UserInfoSpacing = 8
		local UserInfoPosition = UserInfoConfig and (UserInfoConfig.Position or "Bottom") or nil

		local TabHolderTopOffset = Config.Search and 36 or 0
		if UserInfoConfig and UserInfoPosition == "Top" then
			TabHolderTopOffset = TabHolderTopOffset + UserInfoHeight + UserInfoSpacing
		end

		local TabHolderBottomOffset = 0
		if UserInfoConfig and UserInfoPosition ~= "Top" then
			TabHolderBottomOffset = UserInfoHeight + UserInfoSpacing
		end

		local Selector = New("Frame", {
			Size = UDim2.fromOffset(4, 0),
			BackgroundColor3 = Color3.fromRGB(76, 194, 255),
			Position = UDim2.fromOffset(0, 17 + TabHolderTopOffset),
			AnchorPoint = Vector2.new(0, 0.5),
			ThemeTag = {
				BackgroundColor3 = "Accent",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 2),
			}),
		})
		Window.Selector = Selector

		if Library.NewVisual then
			Selector.Visible = false

			Window.TabHighlightMotor = Flipper.GroupMotor.new({ X = 0, Y = 0, Width = 0, Height = 0 })

			Window.TabHighlight = New("Frame", {
				Name = "TabHighlight",
				BackgroundTransparency = 0.89,
				BorderSizePixel = 0,
				Visible = false,
				ZIndex = 0,
				ThemeTag = {
					BackgroundColor3 = "TabOverlay",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
			})

			Window.TabHighlightClip = New("Frame", {
				Name = "TabHighlightClip",
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				ZIndex = 0,
				Size = UDim2.fromScale(1, 1),
			}, {
				Window.TabHighlight,
			})

			Window.TabHighlightMotor:onStep(function(Values)
				Window.TabHighlight.Position = UDim2.fromOffset(Values.X, Values.Y)
				Window.TabHighlight.Size = UDim2.fromOffset(Values.Width, Values.Height)
			end)
		end

		local ResizeStartFrame = New("Frame", {
			Size = UDim2.fromOffset(20, 20),
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -20, 1, -20),
		})

		Window.TabHolder = New("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			New("UIPadding", {
				PaddingRight = UDim.new(0, 12),
			}),
		})

		local TabSearchBox, TabSearchHolder
		if Config.Search then
			local TabSearchIcon = New("ImageLabel", {
				Image = "rbxassetid://10734943674",
				Size = UDim2.fromOffset(14, 14),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 8, 0.5, 0),
				BackgroundTransparency = 1,
				ThemeTag = {
					ImageColor3 = "SubText",
				},
			})

			TabSearchBox = New("TextBox", {
				FontFace = Font.new(Library.Font, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				PlaceholderText = "Search....",
				Text = "",
				ClearTextOnFocus = false,
				TextColor3 = Color3.fromRGB(240, 240, 240),
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, -32, 1, 0),
				Position = UDim2.new(0, 28, 0, 0),
				BackgroundTransparency = 1,
				ThemeTag = {
					TextColor3 = "Text",
					PlaceholderColor3 = "SubText",
				},
			})

			TabSearchHolder = New("Frame", {
				Size = UDim2.new(1, 0, 0, 30),
				Position = UDim2.fromOffset(0, 0),
				BackgroundTransparency = 0.9,
				ThemeTag = {
					BackgroundColor3 = "DropdownFrame",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 5),
				}),
				New("UIStroke", {
					Transparency = 0.5,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {
						Color = "InElementBorder",
						Transparency = "InElementBorderTransparency",
					},
				}),
				TabSearchIcon,
				TabSearchBox,
			})

		end

		Creator.AttachScrollBar(Window.TabHolder, { Thickness = 4 })

		Window.TabHolder.Position = UDim2.fromOffset(0, TabHolderTopOffset)
		Window.TabHolder.Size = UDim2.new(1, 0, 1, -TabHolderTopOffset - TabHolderBottomOffset)

		if Window.TabHighlightClip then
			Window.TabHighlightClip.Position = Window.TabHolder.Position
			Window.TabHighlightClip.Size = Window.TabHolder.Size
		end

		local UserInfoFrame
		if UserInfoConfig then
			local UserInfoIcon = UserInfoConfig.Icon
				or ("rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420")
			local UserInfoTitle = UserInfoConfig.Title or LocalPlayer.DisplayName
			local UserInfoSubtitle = UserInfoConfig.Subtitle
			local UserInfoLiveTime = UserInfoSubtitle == nil
			local UserInfoTimeFormat = UserInfoConfig.TimeFormat or "%H:%M:%S"
			local UserInfoSubtitleLabel

			if UserInfoLiveTime then
				UserInfoSubtitle = os.date(UserInfoTimeFormat)
			end

			local UserInfoIconSize = 38
			local UserInfoTitleHeight = 18
			local UserInfoSubtitleHeight = 14
			local UserInfoTextGap = 2
			local UserInfoCenterY = UserInfoHeight / 2

			local UserInfoTitleY
			local UserInfoSubtitleY

			if UserInfoSubtitle then
				local UserInfoBlockHeight = UserInfoTitleHeight + UserInfoTextGap + UserInfoSubtitleHeight
				local UserInfoBlockTop = UserInfoCenterY - UserInfoBlockHeight / 2
				UserInfoTitleY = UserInfoBlockTop
				UserInfoSubtitleY = UserInfoBlockTop + UserInfoTitleHeight + UserInfoTextGap
			else
				UserInfoTitleY = UserInfoCenterY - UserInfoTitleHeight / 2
			end

			local UserInfoIconImage = New("ImageLabel", {
				Name = "Icon",
				Size = UDim2.fromOffset(UserInfoIconSize, UserInfoIconSize),
				Position = UDim2.fromOffset(9, (UserInfoHeight - UserInfoIconSize) / 2),
				BackgroundTransparency = 1,
				Image = UserInfoIcon,
				ScaleType = Enum.ScaleType.Crop,
				SeasonalHat = "Avatar",
			}, {
				New("UICorner", { CornerRadius = UDim.new(1, 0) }),
			})

			local UserInfoTitleLabel = New("TextLabel", {
				Name = "Title",
				Text = UserInfoTitle,
				FontFace = Font.new(Library.Font, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
				TextSize = 14,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, -60, 0, UserInfoTitleHeight),
				Position = UDim2.fromOffset(9 + UserInfoIconSize + 9, UserInfoTitleY),
				BackgroundTransparency = 1,
				ThemeTag = {
					TextColor3 = "Text",
				},
			})

			local UserInfoChildren = { UserInfoIconImage, UserInfoTitleLabel }

			if UserInfoSubtitle then
				UserInfoSubtitleLabel = New("TextLabel", {
					Name = "Subtitle",
					Text = UserInfoSubtitle,
					FontFace = Font.new(Library.Font, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
					TextSize = 12,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Size = UDim2.new(1, -60, 0, UserInfoSubtitleHeight),
					Position = UDim2.fromOffset(9 + UserInfoIconSize + 9, UserInfoSubtitleY),
					BackgroundTransparency = 1,
					ThemeTag = {
						TextColor3 = "SubText",
					},
				})
				table.insert(UserInfoChildren, UserInfoSubtitleLabel)
			end

			UserInfoFrame = New("Frame", {
				Name = "UserInfo",
				Size = UDim2.new(1, 0, 0, UserInfoHeight),
				Position = UserInfoPosition == "Top"
					and UDim2.fromOffset(0, Config.Search and 36 or 0)
					or UDim2.new(0, 0, 1, -UserInfoHeight),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
			}, UserInfoChildren)

			if UserInfoLiveTime and UserInfoSubtitleLabel then
				task.spawn(function()
					local LastTime = os.time()
					while UserInfoSubtitleLabel.Parent do
						local Millis = DateTime.now().UnixTimestampMillis % 1000
						task.wait((1000 - Millis) / 1000)
						if UserInfoFrame.Visible and Window.Root and Window.Root.Visible then
							local Now = os.time()
							if Now ~= LastTime then
								LastTime = Now
								UserInfoSubtitleLabel.Text = os.date(UserInfoTimeFormat, Now)
							end
						end
					end
				end)
			end
		end

		local TabFrameChildren = { Window.TabHolder, Selector }
		if TabSearchHolder then
			table.insert(TabFrameChildren, 1, TabSearchHolder)
		end
		if UserInfoFrame then
			table.insert(TabFrameChildren, UserInfoFrame)
		end
		if Window.TabHighlightClip then
			table.insert(TabFrameChildren, Window.TabHighlightClip)
		end

		Window.UserInfoFrame = UserInfoFrame

		Window.BackgroundImage = New("ImageLabel", {
			Name = "Background",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Crop,
			ImageTransparency = 0,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		})

		local TabFrame = New("Frame", {
			Size = UDim2.new(0, Window.TabWidth, 1, -66),
			Position = UDim2.new(0, 12, 0, 54),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
		}, TabFrameChildren)

		Window.TabDisplay = New("TextLabel", {
			RichText = true,
			Text = "",
			TextTransparency = 0,
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			TextSize = 28,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(1, -16, 0, 28),
			Position = UDim2.fromOffset(Window.TabWidth + 26, 56),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		Window.ContainerHolder = New("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		})

		Window.ContainerAnim = New("CanvasGroup", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		})

		Window.ContainerCanvas = New("Frame", {
			Size = UDim2.new(1, -Window.TabWidth - 32, 1, -102),
			Position = UDim2.fromOffset(Window.TabWidth + 26, 90),
			BackgroundTransparency = 1,
		}, {
			Window.ContainerAnim,
			Window.ContainerHolder
		})

		Window.Boundary = New("Frame", {
			Name = "Boundary",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ClipsDescendants = false,
			Parent = Config.Parent,
		})

		Window.Root = New("Frame", {
			BackgroundTransparency = 1,
			Size = Window.Size,
			Position = Window.Position,
			Parent = Window.Boundary,
		}, {
			Window.BackgroundImage,
			Window.AcrylicPaint.Frame,
			Window.TabDisplay,
			Window.ContainerCanvas,
			TabFrame,
			ResizeStartFrame,
		})

		Window.TitleBar = Components.TitleBar({
			Title = Config.Title,
			SubTitle = Config.SubTitle,
			Parent = Window.Root,
			Window = Window,
		})

		function Window:SetTitle(Set)
			Window.TitleBar:SetTitle(Set)
		end

		function Window:SetSubTitle(Set)
			Window.TitleBar:SetSubTitle(Set)
		end
		Window.SetDesc = Window.SetSubTitle

		Window.NavigatorSelectorMotor = Flipper.GroupMotor.new({ X = 0, Width = 0 })

		local NavigatorHighlight = Library.NewVisual == true

		Window.NavigatorSelector = New("Frame", {
			Size = UDim2.fromOffset(0, NavigatorHighlight and 28 or 2),
			AnchorPoint = Vector2.new(0, NavigatorHighlight and 0.5 or 1),
			Position = UDim2.new(0, 0, NavigatorHighlight and 0.5 or 1, 0),
			BackgroundTransparency = NavigatorHighlight and 0.89 or 0,
			BorderSizePixel = 0,
			ZIndex = NavigatorHighlight and 0 or 1,
			Visible = false,
			ThemeTag = {
				BackgroundColor3 = NavigatorHighlight and "TabOverlay" or "Accent",
			},
		}, {
			New("UICorner", {
				CornerRadius = NavigatorHighlight and UDim.new(0, 6) or UDim.new(1, 0),
			}),
		})

		Window.NavigatorSelectorMotor:onStep(function(Values)
			if NavigatorHighlight then
				Window.NavigatorSelector.Position = UDim2.new(0, Values.X, 0.5, 0)
				Window.NavigatorSelector.Size = UDim2.fromOffset(Values.Width, 28)
			else
				Window.NavigatorSelector.Position = UDim2.new(0, Values.X, 1, 0)
				Window.NavigatorSelector.Size = UDim2.fromOffset(Values.Width, 2)
			end
		end)

		local NavigatorListLayout = New("UIListLayout", {
			Padding = UDim.new(0, 4),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		Window.NavigatorHolder = New("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			CanvasSize = UDim2.fromScale(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.X,
		}, {
			NavigatorListLayout,
		})

		local function UpdateNavigatorAlignment()
			local Fits = NavigatorListLayout.AbsoluteContentSize.X <= Window.NavigatorHolder.AbsoluteSize.X
			NavigatorListLayout.HorizontalAlignment = Fits and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Left
		end

		Creator.AddSignal(NavigatorListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), UpdateNavigatorAlignment)
		Creator.AddSignal(Window.NavigatorHolder:GetPropertyChangedSignal("AbsoluteSize"), UpdateNavigatorAlignment)

		Window.NavigatorFrame = New("Frame", {
			Size = UDim2.new(1, -280, 1, -10),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Parent = Window.TitleBar.Frame,
		}, {
			Window.NavigatorHolder,
			Window.NavigatorSelector,
		})

		if Library.UseAcrylic then
			Window.AcrylicPaint.AddParent(Window.Root)
		end

		local SizeMotor = Flipper.GroupMotor.new({
			X = Window.Size.X.Offset,
			Y = Window.Size.Y.Offset,
		})

		local PosMotor = Flipper.GroupMotor.new({
			X = Window.Position.X.Offset,
			Y = Window.Position.Y.Offset,
		})

		Window.SelectorPosMotor = Flipper.SingleMotor.new(17)
		Window.SelectorSizeMotor = Flipper.SingleMotor.new(0)
		Window.ContainerBackMotor = Flipper.SingleMotor.new(0)
		Window.ContainerPosMotor = Flipper.SingleMotor.new(94)

		SizeMotor:onStep(function(values)
			Window.Root.Size = UDim2.new(0, values.X, 0, values.Y)
		end)

		PosMotor:onStep(function(values)
			Window.Root.Position = UDim2.new(0, values.X, 0, values.Y)
		end)

		local LastValue = 0
		local LastTime = 0
		Window.SelectorPosMotor:onStep(function(Value)
			Selector.Position = UDim2.new(0, 0, 0, Value + 17 + TabHolderTopOffset)
			local Now = tick()
			local DeltaTime = Now - LastTime

			if LastValue ~= nil then
				Window.SelectorSizeMotor:setGoal(Spring((math.abs(Value - LastValue) / (DeltaTime * 60)) + 16))
				LastValue = Value
			end
			LastTime = Now
		end)

		Window.SelectorSizeMotor:onStep(function(Value)
			Selector.Size = UDim2.new(0, 4, 0, Value)
		end)

		Window.ContainerBackMotor:onStep(function(Value)
			Window.ContainerAnim.GroupTransparency = Value
		end)

		Window.ContainerPosMotor:onStep(function(Value)
			Window.ContainerAnim.Position = UDim2.fromOffset(0, Value)
		end)

		local OldSizeX
		local OldSizeY
		local OldPosX
		local OldPosY
		local function getBoundaryBounds()
			local inset = Library.BoundaryInset or {}
			local margin = Library.BoundaryMargin or 0
			local left = (inset.Left or 0) + margin
			local top = (inset.Top or 0) + margin
			local right = (inset.Right or 0) + margin
			local bottom = (inset.Bottom or 0) + margin
			local size = Window.Boundary.AbsoluteSize
			local usableX = math.max(0, size.X - left - right)
			local usableY = math.max(0, size.Y - top - bottom)
			return left, top, usableX, usableY
		end

		local function clampToBoundary(targetPosition, windowSize)
			if not Library.KeepWindowInsideFrame then
				return targetPosition
			end
			local left, top, usableX, usableY = getBoundaryBounds()
			local maxX = math.max(left, left + usableX - windowSize.X)
			local maxY = math.max(top, top + usableY - windowSize.Y)
			return Vector2.new(math.clamp(targetPosition.X, left, maxX), math.clamp(targetPosition.Y, top, maxY))
		end

		local function fitToBoundary(Instant)
			local left, top, usableX, usableY = getBoundaryBounds()
			SizeMotor:setGoal({
				X = Flipper[Instant and "Instant" or "Spring"].new(usableX, { frequency = 6 }),
				Y = Flipper[Instant and "Instant" or "Spring"].new(usableY, { frequency = 6 }),
			})
			Window.Size = UDim2.fromOffset(usableX, usableY)
			PosMotor:setGoal({
				X = Flipper[Instant and "Instant" or "Spring"].new(left, { frequency = 6 }),
				Y = Flipper[Instant and "Instant" or "Spring"].new(top, { frequency = 6 }),
			})
			Window.Position = UDim2.fromOffset(left, top)
		end

		Window.RefreshBoundary = function()
			if Window.Maximized then
				fitToBoundary(true)
			end
		end

		Window.Maximize = function(Value, NoPos, Instant)
			if Window.Maximized == Value then
				return
			end

			Window.Maximized = Value
			local WindowAssets = Library.NewVisual and Components.AssetsNew or Components.Assets
			Window.TitleBar.MaxButton.Frame.Icon.Image = Value and WindowAssets.Restore or WindowAssets.Max

			if Value then
				OldSizeX = Window.Size.X.Offset
				OldSizeY = Window.Size.Y.Offset
				OldPosX = Window.Position.X.Offset
				OldPosY = Window.Position.Y.Offset
			end

			if Value then
				fitToBoundary(Instant)
				return
			end

			SizeMotor:setGoal({
				X = Flipper[Instant and "Instant" or "Spring"].new(OldSizeX, { frequency = 6 }),
				Y = Flipper[Instant and "Instant" or "Spring"].new(OldSizeY, { frequency = 6 }),
			})
			Window.Size = UDim2.fromOffset(OldSizeX, OldSizeY)

			if not NoPos then
				PosMotor:setGoal({
					X = Spring(OldPosX, { frequency = 6 }),
					Y = Spring(OldPosY, { frequency = 6 }),
				})
				Window.Position = UDim2.fromOffset(OldPosX, OldPosY)
			end
		end

		function Window:SetSize(Value)
			local Width
			local Height
			if typeof(Value) == "UDim2" then
				Width, Height = Value.X.Offset, Value.Y.Offset
			elseif typeof(Value) == "Vector2" then
				Width, Height = Value.X, Value.Y
			else
				return
			end

			local MinSize = Library.MinWindowSize or Vector2.new(470, 380)
			Width = math.max(Width, MinSize.X)
			Height = math.max(Height, MinSize.Y)

			if Library.KeepWindowInsideFrame then
				local _, _, UsableX, UsableY = getBoundaryBounds()
				if UsableX > 0 then
					Width = math.min(Width, math.max(MinSize.X, UsableX))
				end
				if UsableY > 0 then
					Height = math.min(Height, math.max(MinSize.Y, UsableY))
				end
			end

			Window.Size = UDim2.fromOffset(Width, Height)

			if Window.Maximized then
				OldSizeX = Width
				OldSizeY = Height
				return
			end

			SizeMotor:setGoal({
				X = Flipper.Instant.new(Width),
				Y = Flipper.Instant.new(Height),
			})

			local Target = clampToBoundary(Vector2.new(Window.Position.X.Offset, Window.Position.Y.Offset), Vector2.new(Width, Height))
			Window.Position = UDim2.fromOffset(Target.X, Target.Y)
			PosMotor:setGoal({
				X = Flipper.Instant.new(Target.X),
				Y = Flipper.Instant.new(Target.Y),
			})
		end

		Creator.AddSignal(Window.Boundary:GetPropertyChangedSignal("AbsoluteSize"), function()
			Window.RefreshBoundary()
		end)

		Creator.AddSignal(Window.TitleBar.Frame.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = true
				MousePos = Input.Position
				StartPos = Window.Root.Position

				if Window.Maximized then
					local _, _, usableX, usableY = getBoundaryBounds()
					StartPos = UDim2.fromOffset(
						Mouse.X - (Mouse.X * ((OldSizeX - 100) / usableX)),
						Mouse.Y - (Mouse.Y * (OldSizeY / usableY))
					)
				end

				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)

		Creator.AddSignal(Window.TitleBar.Frame.InputChanged, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseMovement
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				DragInput = Input
			end
		end)

		Creator.AddSignal(ResizeStartFrame.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Resizing = true
				ResizePos = Input.Position
			end
		end)

		Creator.AddSignal(UserInputService.InputChanged, function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos
				local targetPosition =
					clampToBoundary(Vector2.new(StartPos.X.Offset + Delta.X, StartPos.Y.Offset + Delta.Y), Window.Root.AbsoluteSize)
				Window.Position = UDim2.fromOffset(targetPosition.X, targetPosition.Y)
				PosMotor:setGoal({
					X = Instant(Window.Position.X.Offset),
					Y = Instant(Window.Position.Y.Offset),
				})

				if Window.Maximized then
					Window.Maximize(false, true, true)
				end
			end

			if
				(Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
				and Resizing
			then
				local Delta = Input.Position - ResizePos
				local StartSize = Window.Size

				local TargetSize = Vector3.new(StartSize.X.Offset, StartSize.Y.Offset, 0) + Vector3.new(1, 1, 0) * Delta
				local TargetSizeClamped =
					Vector2.new(math.clamp(TargetSize.X, 470, 2048), math.clamp(TargetSize.Y, 380, 2048))

				if Library.KeepWindowInsideFrame then
					local left, top, usableX, usableY = getBoundaryBounds()
					local windowPosition = Window.Root.AbsolutePosition
					local boundaryPosition = Window.Boundary.AbsolutePosition
					local relativeX = (windowPosition.X - boundaryPosition.X) - left
					local relativeY = (windowPosition.Y - boundaryPosition.Y) - top
					local availableX = math.max(470, usableX - relativeX)
					local availableY = math.max(380, usableY - relativeY)
					TargetSizeClamped = Vector2.new(math.min(TargetSizeClamped.X, availableX), math.min(TargetSizeClamped.Y, availableY))
				end

				SizeMotor:setGoal({
					X = Flipper.Instant.new(TargetSizeClamped.X),
					Y = Flipper.Instant.new(TargetSizeClamped.Y),
				})
			end
		end)

		Creator.AddSignal(UserInputService.InputEnded, function(Input)
			if Resizing then
				Resizing = false
				Window.Size = UDim2.fromOffset(SizeMotor:getValue().X, SizeMotor:getValue().Y)
				if not Window.Maximized and Library.OnWindowSizeChanged then
					Library:SafeCallback(Library.OnWindowSizeChanged, Window.Size)
				end
			end
		end)

		Creator.AddSignal(Window.TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			Window.TabHolder.CanvasSize = UDim2.new(0, 0, 0, Window.TabHolder.UIListLayout.AbsoluteContentSize.Y)
		end)

		Creator.AddSignal(UserInputService.InputBegan, function(Input)
			if
				type(Library.MinimizeKeybind) == "table"
				and Library.MinimizeKeybind.Type == "Keybind"
				and not UserInputService:GetFocusedTextBox()
			then
				if Input.KeyCode.Name == Library.MinimizeKeybind.Value then
					Window:Minimize()
				end
			elseif Input.KeyCode == Library.MinimizeKey and not UserInputService:GetFocusedTextBox() then
				Window:Minimize()
			end
		end)

		function Window:Minimize()
			Window.Minimized = not Window.Minimized
			Window.Root.Visible = not Window.Minimized
			if not MinimizeNotif then
				MinimizeNotif = true
				local Key = Library.MinimizeKeybind and Library.MinimizeKeybind.Value or Library.MinimizeKey.Name
				Library:Notify({
					Title = "Interface",
					Content = "Press " .. Key .. " to toggle the interface.",
					Duration = 6
				})
			end
		end

		function Window:Destroy()
			if Library.UseAcrylic then
				Window.AcrylicPaint.Model:Destroy()
			end
			Window.Root:Destroy()
		end

		local DialogModule = Components.Dialog:Init(Window)
		function Window:Dialog(Config)
			local Dialog = DialogModule:Create()
			Dialog.Title.Text = Config.Title

			local Content = New("TextLabel", {
				FontFace = Font.new(Library.Font),
				Text = Config.Content,
				TextColor3 = Color3.fromRGB(240, 240, 240),
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				Size = UDim2.new(1, -40, 1, 0),
				Position = UDim2.fromOffset(20, 60),
				BackgroundTransparency = 1,
				Parent = Dialog.Root,
				ClipsDescendants = false,
				ThemeTag = {
					TextColor3 = "Text",
				},
			})

			New("UISizeConstraint", {
				MinSize = Vector2.new(300, 165),
				MaxSize = Vector2.new(620, math.huge),
				Parent = Dialog.Root,
			})

			Dialog.Root.Size = UDim2.fromOffset(Content.TextBounds.X + 40, 165)
			if Content.TextBounds.X + 40 > Window.Size.X.Offset - 120 then
				Dialog.Root.Size = UDim2.fromOffset(Window.Size.X.Offset - 120, 165)
				Content.TextWrapped = true
				Dialog.Root.Size = UDim2.fromOffset(Window.Size.X.Offset - 120, Content.TextBounds.Y + 150)
			end

			for _, Button in next, Config.Buttons do
				Dialog:Button(Button.Title, Button.Callback)
			end

			Dialog:Open()
		end

		local SidePanelModule = Components.SidePanel:Init(Window)
		function Window:SidePanel(Config)
			local Panel = SidePanelModule:Create(Config)
			Panel:Open()
			return Panel
		end
		Window.Menu = Window.SidePanel
		Window.SideMenu = Window.SidePanel

		local TabModule = Components.Tab:Init(Window)
		local TabHolderOrder = 0

		function Window:AddTab(TabConfig)
			TabHolderOrder = TabHolderOrder + 1
			local Tab = TabModule:New(TabConfig.Title, TabConfig.Icon, Window.TabHolder, false)
			Tab.Frame.LayoutOrder = TabHolderOrder
			return Tab
		end
		Window.Tab = Window.AddTab
		Window.Page = Window.AddTab
		Window.AddPage = Window.AddTab

		function Window:AddTabInHeader(TabConfig)
			return TabModule:New(TabConfig.Title, TabConfig.Icon, Window.NavigatorHolder, true)
		end
		Window.TabInHeader = Window.AddTabInHeader

		function Window:AddSection(SectionConfig)
			SectionConfig = SectionConfig or {}

			TabHolderOrder = TabHolderOrder + 1
			local Section = {
				Type = "TabSection",
				Title = SectionConfig.Title,
				Collapsible = SectionConfig.Collapsible or false,
				Opened = true,
				Tabs = {},
				_tabOrder = 0,
			}

			Section.Root = New("Frame", {
				Name = "SectionRoot",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = TabHolderOrder,
				Parent = Window.TabHolder,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
			})

			local SectionIcon = SectionConfig.Icon and Library:GetIcon(SectionConfig.Icon)
			local SectionTitleOffset = SectionIcon and 22 or 4

			local SectionTitleLabel = New("TextLabel", {
				Name = "SectionTitle",
				Text = Section.Title,
				RichText = true,
				FontFace = Font.new(Library.Font, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
				TextSize = 12,
				TextXAlignment = "Left",
				TextYAlignment = "Center",
				Size = UDim2.new(1, (Section.Collapsible and -24 or -8) - (SectionTitleOffset - 4), 1, 0),
				Position = UDim2.fromOffset(SectionTitleOffset, 0),
				BackgroundTransparency = 1,
				ThemeTag = {
					TextColor3 = "SubText",
				},
			})

			Section.Header = New("TextButton", {
				Name = "SectionHeader",
				Size = UDim2.new(1, 0, 0, 26),
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Text = "",
				LayoutOrder = 1,
				Parent = Section.Root,
			}, {
				SectionTitleLabel,
			})

			if SectionIcon then
				New("ImageLabel", {
					Name = "SectionIcon",
					Image = SectionIcon.Image,
					ImageRectOffset = SectionIcon.ImageRectOffset,
					ImageRectSize = SectionIcon.ImageRectSize,
					Size = UDim2.fromOffset(14, 14),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 4, 0.5, 0),
					BackgroundTransparency = 1,
					Parent = Section.Header,
					ThemeTag = {
						ImageColor3 = "SubText",
					},
				})
			end

			Creator.AttachTitleDesc(Section, SectionTitleLabel, nil)

			Section.Content = New("Frame", {
				Name = "SectionContent",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Parent = Section.Root,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
			})

			local Chevron
			if Section.Collapsible then
				Chevron = New("ImageLabel", {
					Name = "SectionChevron",
					Image = Library.InternalIcons.ChevronDown,
					Size = UDim2.fromOffset(14, 14),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -6, 0.5, 0),
					Rotation = 0,
					BackgroundTransparency = 1,
					Parent = Section.Header,
					ThemeTag = {
						ImageColor3 = "SubText",
					},
				})
			end

			local function SectionHasSelectedTab()
				local SelectedTab = TabModule.Tabs[TabModule.SelectedTab]
				if not SelectedTab then return false end
				for _, SectionTab in ipairs(Section.Tabs) do
					if SectionTab == SelectedTab then
						return true
					end
				end
				return false
			end

			function Section:Open()
				if not Section.Collapsible then return end
				Section.Opened = true
				Section.Content.Visible = true
				TweenService:Create(
					Chevron,
					TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Rotation = 0 }
				):Play()

				if SectionHasSelectedTab() then
					if Library.NewVisual then
						TabModule:UpdateTabHighlight(true)
					else
						Window.Selector.Visible = true
						Window.SelectorPosMotor:setGoal(Instant(TabModule:GetCurrentTabPos()))
					end
				end
			end

			function Section:Close()
				if not Section.Collapsible then return end
				Section.Opened = false
				Section.Content.Visible = false
				TweenService:Create(
					Chevron,
					TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{ Rotation = -90 }
				):Play()

				if SectionHasSelectedTab() then
					Window.Selector.Visible = false
					TabModule:UpdateTabHighlight(true)
				end
			end

			function Section:Toggle()
				if Section.Opened then
					Section:Close()
				else
					Section:Open()
				end
			end

			if Section.Collapsible then
				Creator.AddSignal(Section.Header.MouseButton1Click, function()
					Section:Toggle()
				end)
			end

			function Section:AddTab(TabConfig)
				Section._tabOrder = Section._tabOrder + 1
				local Tab = TabModule:New(TabConfig.Title, TabConfig.Icon, Section.Content, false)
				Tab.Frame.LayoutOrder = Section._tabOrder
				table.insert(Section.Tabs, Tab)
				return Tab
			end
			Section.Tab = Section.AddTab
			Section.Page = Section.AddTab
			Section.AddPage = Section.AddTab

			function Section:AddTabInHeader(TabConfig)
				warn("[Fluent Reimagined] TabInHeader cannot be added to a Section, tab moved to header instead.")
				return TabModule:New(TabConfig.Title, TabConfig.Icon, Window.NavigatorHolder, true)
			end
			Section.TabInHeader = Section.AddTabInHeader

			return Section
		end
		Window.Section = Window.AddSection

		function Window:SelectTab(Tab)
			TabModule:SelectTab(1)
		end

		Creator.AddSignal(Window.TabHolder:GetPropertyChangedSignal("CanvasPosition"), function()
			LastValue = TabModule:GetCurrentTabPos() + 16
			LastTime = 0
			Window.SelectorPosMotor:setGoal(Instant(TabModule:GetCurrentTabPos()))
		end)

		Creator.AddSignal(Window.NavigatorHolder:GetPropertyChangedSignal("CanvasPosition"), function()
			TabModule:UpdateNavigatorSelector(true)
		end)

		if TabSearchBox then
			Creator.AddSignal(TabSearchBox:GetPropertyChangedSignal("Text"), function()
				TabModule:ApplyFilter(TabSearchBox.Text)
			end)
		end

		return Window
	end
end)()

local ElementsTable = {}
local AddSignal = Creator.AddSignal

ElementsTable.Button = (function()
	local New = Creator.New

	local Element = {}
	Element.__index = Element
	Element.__type = "Button"

	function Element:New(Config)
		assert(Config.Title, "Button - Missing Title")
		Config.Callback = Config.Callback or function() end

		local IsGrouped = self.Type == "Group" or self.Type == "HStack" or self.Type == "VStack"

		local ButtonFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config.LayoutOrder, Config.Icon, Config.Marquee, Config.Locked)

		ButtonFrame.TitleLabel.Size = UDim2.new(1, -34, 0, 14)
		ButtonFrame.DescLabel.Size = UDim2.new(1, -34, 0, 14)

		local ButtonIco = New("ImageLabel", {
			Image = "rbxassetid://10709791437",
			Size = UDim2.fromOffset(16, 16),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			BackgroundTransparency = 1,
			Parent = ButtonFrame.Frame,
			ThemeTag = {
				ImageColor3 = "Text",
			},
		})

		Creator.AddSignal(ButtonFrame.Frame.MouseButton1Click, function()
			self.Library:SafeCallback(Config.Callback)
		end)

		local Button = ButtonFrame
		Button.SetTitle = ButtonFrame.SetTitle
		Button.SetDesc = ButtonFrame.SetDesc

		return Button
	end

	return Element
end)()

ElementsTable.Colorpicker = (function()

	local RenderStepped = RunService.RenderStepped
	local Mouse = LocalPlayer:GetMouse()

	local New = Creator.New

	local Element = {}
	Element.__index = Element
	Element.__type = "Colorpicker"

	function Element:New(Idx, Config)
		local Library = self.Library
		assert(Config.Title, "Colorpicker - Missing Title")
		assert(Config.Default, "AddColorPicker: Missing default value.")

		local Colorpicker = {
			Value = Config.Default,
			Transparency = Config.Transparency or 0,
			Type = "Colorpicker",
			Title = type(Config.Title) == "string" and Config.Title or "Colorpicker",
			Callback = Config.Callback or function(Color) end,
		}

		function Colorpicker:SetHSVFromRGB(Color)
			local H, S, V = Color3.toHSV(Color)
			Colorpicker.Hue = H
			Colorpicker.Sat = S
			Colorpicker.Vib = V
		end

		Colorpicker:SetHSVFromRGB(Colorpicker.Value)

		local IsGrouped = self.Type == "Group" or self.Type == "HStack" or self.Type == "VStack"

		local ColorpickerFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config.LayoutOrder, Config.Icon, Config.Marquee, Config.Locked)

		ColorpickerFrame.TitleLabel.Size = UDim2.new(1, -44, 0, 14)
		ColorpickerFrame.DescLabel.Size = UDim2.new(1, -44, 0, 14)

		Colorpicker.SetTitle = ColorpickerFrame.SetTitle
		Colorpicker.SetDesc = ColorpickerFrame.SetDesc
		ColorpickerFrame.LockHandle.Bind(Colorpicker)

		local DisplayFrameColor = New("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Colorpicker.Value,
			Parent = ColorpickerFrame.Frame,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
		})

		local DisplayFrame = New("ImageLabel", {
			Size = UDim2.fromOffset(26, 26),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			Parent = ColorpickerFrame.Frame,
			Image = "http://www.roblox.com/asset/?id=14204231522",
			ImageTransparency = 0.45,
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.fromOffset(40, 40),
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
			DisplayFrameColor,
		})

		local ColorpickerTextboxTags = {
			Input = "ColorpickerInput",
			InputLine = "ColorpickerInputLine",
			InputBorder = "ColorpickerInputBorder",
			InputFocused = "ColorpickerInputFocused",
		}

		local function CreateColorDialog()
			local HasTransparency = Config.Transparency ~= nil and Config.Transparency ~= false
			local Dialog = Components.Dialog:Create()
			Dialog.Title.Text = Colorpicker.Title
			Dialog.Root.Size = UDim2.fromOffset(460, 396)

			Creator.OverrideTag(Dialog.Root, { BackgroundColor3 = "ColorpickerDialog" })
			Creator.OverrideTag(Dialog.Root.UIStroke, { Color = "ColorpickerDialogBorder" })
			Creator.OverrideTag(Dialog.HolderGradient, { Color = "ColorpickerHolder", Rotation = "ColorpickerHolderRotation", Transparency = "ColorpickerHolderTransparency" })
			Creator.OverrideTag(Dialog.HolderLine, { BackgroundColor3 = "ColorpickerHolderLine" })

			local Hue, Sat, Vib = Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib
			local Transparency = Colorpicker.Transparency
			local Display

			local RightX = HasTransparency and 255 or 245
			local RightWidth = 435 - RightX
			local ChannelWidth = math.floor((RightWidth - 16) / 3)

			local function IsPointerDown(Input)
				return Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch
			end

			local function CreateInput(Position, Size)
				local Box = Components.Textbox(nil, false, ColorpickerTextboxTags)
				Box.Frame.Parent = Dialog.Root
				Box.Frame.Size = Size
				Box.Frame.Position = Position
				return Box
			end

			local function CreateCaption(Text, Position)
				return New("TextLabel", {
					FontFace = Font.new(Library.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
					Text = Text,
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.fromOffset(100, 12),
					Position = Position,
					BackgroundTransparency = 1,
					Parent = Dialog.Root,
					ThemeTag = {
						TextColor3 = "SubText",
					},
				})
			end

			local function CreateChecker(Corner)
				return New("ImageLabel", {
					Image = "http://www.roblox.com/asset/?id=14204231522",
					ImageTransparency = 0.45,
					ScaleType = Enum.ScaleType.Tile,
					TileSize = UDim2.fromOffset(40, 40),
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(0, Corner),
					}),
				})
			end

			local function CreateSwatch(Position, Color, SwatchTransparency)
				local Fill = New("Frame", {
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = Color,
					BackgroundTransparency = SwatchTransparency,
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(0, 8),
					}),
				})

				New("Frame", {
					Size = UDim2.fromOffset(200, 40),
					Position = Position,
					BackgroundTransparency = 1,
					Parent = Dialog.Root,
				}, {
					CreateChecker(8),
					Fill,
					New("UIStroke", {
						Thickness = 1,
						Transparency = 0.4,
						ThemeTag = {
							Color = "InElementBorder",
						},
					}),
					New("UICorner", {
						CornerRadius = UDim.new(0, 8),
					}),
				})

				return Fill
			end

			CreateCaption("CURRENT", UDim2.fromOffset(25, 48))
			CreateSwatch(UDim2.fromOffset(25, 62), Colorpicker.Value, Colorpicker.Transparency)
			CreateCaption("NEW", UDim2.fromOffset(235, 48))
			local NewSwatch = CreateSwatch(UDim2.fromOffset(235, 62), Colorpicker.Value, Colorpicker.Transparency)

			New("Frame", {
				Size = UDim2.fromOffset(430, 192),
				Position = UDim2.fromOffset(15, 116),
				BackgroundTransparency = 0.55,
				Parent = Dialog.Root,
				ThemeTag = {
					BackgroundColor3 = "ColorpickerInput",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 8),
				}),
				New("UIStroke", {
					Thickness = 1,
					Transparency = 0.6,
					ThemeTag = {
						Color = "ColorpickerInputBorder",
					},
				}),
			})

			local SatCursor = New("ImageLabel", {
				Size = UDim2.new(0, 18, 0, 18),
				ScaleType = Enum.ScaleType.Fit,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = "http://www.roblox.com/asset/?id=4805639000",
			})

			local SatVibMap = New("ImageLabel", {
				Size = UDim2.fromOffset(176, 176),
				Position = UDim2.fromOffset(25, 124),
				Image = "rbxassetid://4155801252",
				BackgroundColor3 = Colorpicker.Value,
				BackgroundTransparency = 0,
				Parent = Dialog.Root,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
				SatCursor,
			})

			local HueKeypoints = {}
			for Step = 0, 1, 0.1 do
				table.insert(HueKeypoints, ColorSequenceKeypoint.new(Step, Color3.fromHSV(Step, 1, 1)))
			end

			local HueDrag = New("ImageLabel", {
				Size = UDim2.fromOffset(14, 14),
				Image = "http://www.roblox.com/asset/?id=12266946128",
				ImageColor3 = Creator.GetKnobColor(),
			})

			local HueSlider = New("Frame", {
				Size = UDim2.fromOffset(12, 176),
				Position = UDim2.fromOffset(211, 124),
				Parent = Dialog.Root,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
				New("UIGradient", {
					Color = ColorSequence.new(HueKeypoints),
					Rotation = 90,
				}),
				New("Frame", {
					Size = UDim2.new(1, 0, 1, -10),
					Position = UDim2.fromOffset(0, 5),
					BackgroundTransparency = 1,
				}, {
					HueDrag,
				}),
			})

			local TransparencyDrag
			local TransparencySlider
			local TransparencyColor
			local AlphaInput

			if HasTransparency then
				TransparencyDrag = New("ImageLabel", {
					Size = UDim2.fromOffset(14, 14),
					Image = "http://www.roblox.com/asset/?id=12266946128",
					ImageColor3 = Creator.GetKnobColor(),
				})

				TransparencyColor = New("Frame", {
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = Colorpicker.Value,
				}, {
					New("UIGradient", {
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(1, 1),
						}),
						Rotation = 270,
					}),
					New("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				})

				TransparencySlider = New("Frame", {
					Size = UDim2.fromOffset(12, 176),
					Position = UDim2.fromOffset(229, 124),
					BackgroundTransparency = 1,
					Parent = Dialog.Root,
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
					CreateChecker(6),
					TransparencyColor,
					New("Frame", {
						Size = UDim2.new(1, 0, 1, -10),
						Position = UDim2.fromOffset(0, 5),
						BackgroundTransparency = 1,
					}, {
						TransparencyDrag,
					}),
				})
			end

			Creator.OnThemeChanged(function()
				HueDrag.ImageColor3 = Creator.GetKnobColor()
				if TransparencyDrag then
					TransparencyDrag.ImageColor3 = Creator.GetKnobColor()
				end
			end)

			CreateCaption("HEX", UDim2.fromOffset(RightX, 126))
			local HexInput = CreateInput(UDim2.fromOffset(RightX, 140), UDim2.fromOffset(RightWidth, 28))

			CreateCaption("RED", UDim2.fromOffset(RightX, 176))
			local RedInput = CreateInput(UDim2.fromOffset(RightX, 190), UDim2.fromOffset(ChannelWidth, 28))
			CreateCaption("GREEN", UDim2.fromOffset(RightX + ChannelWidth + 8, 176))
			local GreenInput = CreateInput(UDim2.fromOffset(RightX + ChannelWidth + 8, 190), UDim2.fromOffset(ChannelWidth, 28))
			CreateCaption("BLUE", UDim2.fromOffset(RightX + (ChannelWidth + 8) * 2, 176))
			local BlueInput = CreateInput(UDim2.fromOffset(RightX + (ChannelWidth + 8) * 2, 190), UDim2.fromOffset(ChannelWidth, 28))

			if HasTransparency then
				CreateCaption("OPACITY %", UDim2.fromOffset(RightX, 226))
				AlphaInput = CreateInput(UDim2.fromOffset(RightX, 240), UDim2.fromOffset(RightWidth, 28))
			end

			local function GetChannels()
				local Value = Color3.fromHSV(Hue, Sat, Vib)
				return { math.round(Value.R * 255), math.round(Value.G * 255), math.round(Value.B * 255) }
			end

			Display = function()
				local Color = Color3.fromHSV(Hue, Sat, Vib)
				local Channels = GetChannels()

				SatVibMap.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
				HueDrag.Position = UDim2.new(0, -1, Hue, -6)
				SatCursor.Position = UDim2.new(Sat, 0, 1 - Vib, 0)

				NewSwatch.BackgroundColor3 = Color
				NewSwatch.BackgroundTransparency = HasTransparency and Transparency or 0

				HexInput.Input.Text = "#" .. Color:ToHex()
				RedInput.Input.Text = tostring(Channels[1])
				GreenInput.Input.Text = tostring(Channels[2])
				BlueInput.Input.Text = tostring(Channels[3])

				if HasTransparency then
					TransparencyColor.BackgroundColor3 = Color
					TransparencyDrag.Position = UDim2.new(0, -1, 1 - Transparency, -6)
					AlphaInput.Input.Text = tostring(math.round((1 - Transparency) * 100))
				end
			end

			Creator.AddSignal(HexInput.Input.FocusLost, function(Enter)
				if Enter then
					local Success, Result = pcall(Color3.fromHex, HexInput.Input.Text)
					if Success and typeof(Result) == "Color3" then
						Hue, Sat, Vib = Color3.toHSV(Result)
					end
				end
				Display()
			end)

			for Channel, Box in ipairs({ RedInput, GreenInput, BlueInput }) do
				Creator.AddSignal(Box.Input.FocusLost, function(Enter)
					local Number = Enter and tonumber(Box.Input.Text)
					if Number then
						local Channels = GetChannels()
						Channels[Channel] = math.clamp(math.floor(Number), 0, 255)
						Hue, Sat, Vib = Color3.toHSV(Color3.fromRGB(Channels[1], Channels[2], Channels[3]))
					end
					Display()
				end)
			end

			if HasTransparency then
				Creator.AddSignal(AlphaInput.Input.FocusLost, function(Enter)
					local Number = Enter and tonumber(AlphaInput.Input.Text)
					if Number then
						Transparency = 1 - math.clamp(Number, 0, 100) * 0.01
					end
					Display()
				end)
			end

			Creator.AddSignal(SatVibMap.InputBegan, function(Input)
				if IsPointerDown(Input) then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local MinX = SatVibMap.AbsolutePosition.X
						local MouseX = math.clamp(Mouse.X, MinX, MinX + SatVibMap.AbsoluteSize.X)
						local MinY = SatVibMap.AbsolutePosition.Y
						local MouseY = math.clamp(Mouse.Y, MinY, MinY + SatVibMap.AbsoluteSize.Y)

						Sat = (MouseX - MinX) / SatVibMap.AbsoluteSize.X
						Vib = 1 - ((MouseY - MinY) / SatVibMap.AbsoluteSize.Y)
						Display()

						RenderStepped:Wait()
					end
				end
			end)

			Creator.AddSignal(HueSlider.InputBegan, function(Input)
				if IsPointerDown(Input) then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local MinY = HueSlider.AbsolutePosition.Y
						local MouseY = math.clamp(Mouse.Y, MinY, MinY + HueSlider.AbsoluteSize.Y)

						Hue = (MouseY - MinY) / HueSlider.AbsoluteSize.Y
						Display()

						RenderStepped:Wait()
					end
				end
			end)

			if HasTransparency then
				Creator.AddSignal(TransparencySlider.InputBegan, function(Input)
					if IsPointerDown(Input) then
						while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
							local MinY = TransparencySlider.AbsolutePosition.Y
							local MouseY = math.clamp(Mouse.Y, MinY, MinY + TransparencySlider.AbsoluteSize.Y)

							Transparency = 1 - ((MouseY - MinY) / TransparencySlider.AbsoluteSize.Y)
							Display()

							RenderStepped:Wait()
						end
					end
				end)
			end

			Display()

			local DoneButton = Dialog:Button("Done", function()
				Colorpicker:SetValue({ Hue, Sat, Vib }, Transparency)
			end, "check")
			local CancelButton = Dialog:Button("Cancel", nil, "x")

			for _, Btn in next, { DoneButton, CancelButton } do
				Creator.OverrideTag(Btn.Frame, { BackgroundColor3 = "ColorpickerButton" })
				Creator.OverrideTag(Btn.Frame.UIStroke, { Color = "ColorpickerButtonBorder" })
			end

			Dialog:Open()
		end

		function Colorpicker:Display()
			Colorpicker.Value = Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib)

			DisplayFrameColor.BackgroundColor3 = Colorpicker.Value
			DisplayFrameColor.BackgroundTransparency = Colorpicker.Transparency

			Element.Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value)
			Element.Library:SafeCallback(Colorpicker.Changed, Colorpicker.Value)
		end

		function Colorpicker:SetValue(HSV, Transparency)
			local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])

			Colorpicker.Transparency = Transparency or 0
			Colorpicker:SetHSVFromRGB(Color)
			Colorpicker:Display()
		end

		function Colorpicker:SetValueRGB(Color, Transparency)
			Colorpicker.Transparency = Transparency or 0
			Colorpicker:SetHSVFromRGB(Color)
			Colorpicker:Display()
		end

		function Colorpicker:OnChanged(Func)
			Colorpicker.Changed = Func
			Func(Colorpicker.Value)
		end

		function Colorpicker:Destroy()
			ColorpickerFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Creator.AddSignal(ColorpickerFrame.Frame.MouseButton1Click, function()
			CreateColorDialog()
		end)

		Colorpicker:Display()

		Library.Options[Idx] = Colorpicker
		return Colorpicker
	end

	return Element
end)()

ElementsTable.GradientPicker = (function()
	local RenderStepped = RunService.RenderStepped
	local Mouse = LocalPlayer:GetMouse()

	local New = Creator.New

	local Element = {}
	Element.__index = Element
	Element.__type = "GradientPicker"

	local MinGap = 0.001
	local HardMaxStops = 20

	local function HsvToColor3(Stop)
		return Color3.fromHSV(Stop.Hue, Stop.Sat, Stop.Vib)
	end

	local function ColorToStop(Color, Time)
		local H, S, V = Color3.toHSV(Color)
		return { Time = Time, Hue = H, Sat = S, Vib = V }
	end

	local function StopsFromSequence(Sequence)
		local Stops = {}
		for _, Keypoint in ipairs(Sequence.Keypoints) do
			table.insert(Stops, ColorToStop(Keypoint.Value, Keypoint.Time))
		end
		return Stops
	end

	local function AlphaStopsFromValue(Value)
		local Stops = {}
		if typeof(Value) == "NumberSequence" then
			for _, Keypoint in ipairs(Value.Keypoints) do
				table.insert(Stops, { Time = Keypoint.Time, Value = Keypoint.Value })
			end
		else
			local Number = math.clamp(tonumber(Value) or 0, 0, 1)
			Stops = { { Time = 0, Value = Number }, { Time = 1, Value = Number } }
		end
		return Stops
	end

	local function CopyStops(Stops)
		local Copy = {}
		for _, Stop in ipairs(Stops) do
			local Entry = {}
			for Key, Value in next, Stop do
				Entry[Key] = Value
			end
			table.insert(Copy, Entry)
		end
		return Copy
	end

	local function NormalizeTimes(Stops)
		local Count = #Stops
		Stops[1].Time = 0
		Stops[Count].Time = 1
		for Index = 2, Count - 1 do
			Stops[Index].Time = math.clamp(Stops[Index].Time, Stops[Index - 1].Time + MinGap, 1 - MinGap * (Count - Index))
		end
	end

	local function BuildColorSequence(Stops)
		NormalizeTimes(Stops)
		local Keypoints = {}
		for _, Stop in ipairs(Stops) do
			table.insert(Keypoints, ColorSequenceKeypoint.new(Stop.Time, HsvToColor3(Stop)))
		end
		return ColorSequence.new(Keypoints)
	end

	local function BuildNumberSequence(Stops)
		NormalizeTimes(Stops)
		local Keypoints = {}
		for _, Stop in ipairs(Stops) do
			table.insert(Keypoints, NumberSequenceKeypoint.new(Stop.Time, math.clamp(Stop.Value, 0, 1)))
		end
		return NumberSequence.new(Keypoints)
	end

	local function InsertIndex(Stops, Time)
		for Index = 2, #Stops do
			if Time < Stops[Index].Time then
				return Index
			end
		end
		return #Stops
	end

	local function SampleColorStop(Stops, Time)
		local Index = InsertIndex(Stops, Time)
		local Before = Stops[Index - 1]
		local After = Stops[Index]
		local Fraction = math.clamp((Time - Before.Time) / math.max(After.Time - Before.Time, MinGap), 0, 1)
		return ColorToStop(HsvToColor3(Before):Lerp(HsvToColor3(After), Fraction), Time), Index
	end

	local function SampleAlphaStop(Stops, Time)
		local Index = InsertIndex(Stops, Time)
		local Before = Stops[Index - 1]
		local After = Stops[Index]
		local Fraction = math.clamp((Time - Before.Time) / math.max(After.Time - Before.Time, MinGap), 0, 1)
		return { Time = Time, Value = Before.Value + (After.Value - Before.Value) * Fraction }, Index
	end

	function Element:New(Idx, Config)
		local Library = self.Library
		assert(Config.Title, "GradientPicker - Missing Title")
		assert(Config.Default, "AddGradientPicker: Missing default value.")

		local HasTransparency = Config.Transparency ~= nil
		local MaxStops = math.clamp(tonumber(Config.MaxKeypoints) or 8, 2, HardMaxStops)

		local GradientPicker = {
			Value = Config.Default,
			Rotation = tonumber(Config.Rotation) or 0,
			Transparency = NumberSequence.new(0),
			Type = "GradientPicker",
			Title = type(Config.Title) == "string" and Config.Title or "Gradient Picker",
			Callback = Config.Callback or function(Sequence) end,
		}

		GradientPicker.Stops = StopsFromSequence(GradientPicker.Value)
		GradientPicker.AlphaStops = AlphaStopsFromValue(Config.Transparency)

		local IsGrouped = self.Type == "Group" or self.Type == "HStack" or self.Type == "VStack"

		local GradientPickerFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config.LayoutOrder, Config.Icon, Config.Marquee, Config.Locked)

		GradientPickerFrame.TitleLabel.Size = UDim2.new(1, -44, 0, 14)
		GradientPickerFrame.DescLabel.Size = UDim2.new(1, -44, 0, 14)

		GradientPicker.SetTitle = GradientPickerFrame.SetTitle
		GradientPicker.SetDesc = GradientPickerFrame.SetDesc
		GradientPickerFrame.LockHandle.Bind(GradientPicker)

		local DisplayFrameGradient = New("UIGradient", {
			Color = GradientPicker.Value,
			Rotation = GradientPicker.Rotation,
		})

		local DisplayFrame = New("Frame", {
			Size = UDim2.fromOffset(26, 26),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			Parent = GradientPickerFrame.Frame,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
			New("UIStroke", {
				Thickness = 1,
				Transparency = 0.5,
				ThemeTag = {
					Color = "InElementBorder",
					Transparency = "InElementBorderTransparency",
				},
			}),
			DisplayFrameGradient,
		})

		local GradientPickerTextboxTags = {
			Input = "ColorpickerInput",
			InputLine = "ColorpickerInputLine",
			InputBorder = "ColorpickerInputBorder",
			InputFocused = "ColorpickerInputFocused",
		}

		local function CreateGradientDialog()
			local Dialog = Components.Dialog:Create()
			Dialog.Title.Text = GradientPicker.Title
			Dialog.Root.Size = UDim2.fromOffset(460, 440)

			Creator.OverrideTag(Dialog.Root, { BackgroundColor3 = "ColorpickerDialog" })
			Creator.OverrideTag(Dialog.Root.UIStroke, { Color = "ColorpickerDialogBorder" })
			Creator.OverrideTag(Dialog.HolderGradient, { Color = "ColorpickerHolder", Rotation = "ColorpickerHolderRotation", Transparency = "ColorpickerHolderTransparency" })
			Creator.OverrideTag(Dialog.HolderLine, { BackgroundColor3 = "ColorpickerHolderLine" })

			local ColorStops = CopyStops(GradientPicker.Stops)
			local AlphaStops = CopyStops(GradientPicker.AlphaStops)
			local Rotation = GradientPicker.Rotation
			local Mode = "Color"
			local SelectedColor = 1
			local SelectedAlpha = 1
			local ColorControls = {}
			local AlphaControls = {}
			local Markers = {}
			local Display
			local RebuildMarkers

			local FallbackIcons = {
				plus = Library.InternalIcons.Plus,
				minus = Library.InternalIcons.Minus,
				check = Library.InternalIcons.Check,
			}

			local function CreateIcon(IconName, IconSize, Position, Parent)
				local Icon = Library:GetIcon(IconName)
				local Image, RectOffset, RectSize
				if Icon then
					Image, RectOffset, RectSize = Icon.Image, Icon.ImageRectOffset, Icon.ImageRectSize
				elseif FallbackIcons[IconName] then
					Image = FallbackIcons[IconName]
				else
					return nil
				end

				return New("ImageLabel", {
					Size = UDim2.fromOffset(IconSize, IconSize),
					Position = Position,
					BackgroundTransparency = 1,
					Image = Image,
					ImageRectOffset = RectOffset or Vector2.zero,
					ImageRectSize = RectSize or Vector2.zero,
					Parent = Parent,
					ThemeTag = {
						ImageColor3 = "Text",
					},
				})
			end

			local function SetGroupVisible(Group, Visible)
				for _, Object in ipairs(Group) do
					Object.Visible = Visible
				end
			end

			local function IsPointerDown(Input)
				return Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch
			end

			local function CreateInput(Position, Size, Group)
				local Box = Components.Textbox(nil, false, GradientPickerTextboxTags)
				Box.Frame.Parent = Dialog.Root
				Box.Frame.Size = Size
				Box.Frame.Position = Position
				if Group then
					table.insert(Group, Box.Frame)
				end
				return Box
			end

			local function CreateCaption(Text, Position, Group)
				local Label = New("TextLabel", {
					FontFace = Font.new(Library.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
					Text = Text,
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.fromOffset(100, 12),
					Position = Position,
					BackgroundTransparency = 1,
					Parent = Dialog.Root,
					ThemeTag = {
						TextColor3 = "SubText",
					},
				})
				if Group then
					table.insert(Group, Label)
				end
				return Label
			end

			local function CreateSmallButton(Text, Position, Size, Callback, IconName)
				local Button = New("TextButton", {
					Text = Text,
					FontFace = Font.new(Library.Font, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
					TextSize = 15,
					Size = Size,
					Position = Position,
					Parent = Dialog.Root,
					ThemeTag = {
						BackgroundColor3 = "ColorpickerButton",
						TextColor3 = "Text",
					},
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(0, 6),
					}),
					New("UIStroke", {
						Thickness = 1,
						Transparency = 0.5,
						ThemeTag = {
							Color = "ColorpickerButtonBorder",
						},
					}),
				})

				Creator.AddSignal(Button.MouseButton1Click, Callback)

				if IconName and CreateIcon(IconName, 14, UDim2.new(0.5, -7, 0.5, -7), Button) then
					Button.Text = ""
				end

				return Button
			end

			local function CreateChecker(Corner)
				return New("ImageLabel", {
					Image = "http://www.roblox.com/asset/?id=14204231522",
					ImageTransparency = 0.45,
					ScaleType = Enum.ScaleType.Tile,
					TileSize = UDim2.fromOffset(40, 40),
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(0, Corner),
					}),
				})
			end

			local function ActiveStops()
				return Mode == "Color" and ColorStops or AlphaStops
			end

			local function ActiveIndex()
				return Mode == "Color" and SelectedColor or SelectedAlpha
			end

			local function SetMode(NewMode)
				if Mode == NewMode then
					return
				end

				Mode = NewMode
				SetGroupVisible(ColorControls, NewMode == "Color")
				SetGroupVisible(AlphaControls, NewMode == "Alpha")
				RebuildMarkers()
				Display()
			end

			local PreviewGradient = New("UIGradient", {})

			local PreviewHolder = New("TextButton", {
				Text = "",
				Size = UDim2.fromOffset(410, 40),
				Position = UDim2.fromOffset(25, 84),
				BackgroundTransparency = 1,
				Parent = Dialog.Root,
			}, {
				CreateChecker(8),
				New("Frame", {
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(0, 8),
					}),
					PreviewGradient,
				}),
				New("UIStroke", {
					Thickness = 1,
					Transparency = 0.4,
					ThemeTag = {
						Color = "InElementBorder",
					},
				}),
				New("UICorner", {
					CornerRadius = UDim.new(0, 8),
				}),
			})

			local MarkerHolder = New("Frame", {
				Size = UDim2.fromOffset(410, 24),
				Position = UDim2.fromOffset(25, 124),
				BackgroundTransparency = 1,
				Parent = Dialog.Root,
			})

			New("Frame", {
				Size = UDim2.fromOffset(430, 192),
				Position = UDim2.fromOffset(15, 152),
				BackgroundTransparency = 0.55,
				Parent = Dialog.Root,
				ThemeTag = {
					BackgroundColor3 = "ColorpickerInput",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 8),
				}),
				New("UIStroke", {
					Thickness = 1,
					Transparency = 0.6,
					ThemeTag = {
						Color = "ColorpickerInputBorder",
					},
				}),
			})

			local SegmentHighlight
			local CounterLabel = New("TextLabel", {
				FontFace = Font.new(Library.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
				Text = "",
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Right,
				Size = UDim2.fromOffset(85, 28),
				Position = UDim2.fromOffset(285, 48),
				BackgroundTransparency = 1,
				Parent = Dialog.Root,
				ThemeTag = {
					TextColor3 = "SubText",
				},
			})

			if HasTransparency then
				SegmentHighlight = New("Frame", {
					Size = UDim2.new(0.5, -4, 1, -4),
					Position = UDim2.fromOffset(2, 2),
					BackgroundTransparency = 0.78,
					ThemeTag = {
						BackgroundColor3 = "Accent",
					},
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(0, 5),
					}),
					New("UIStroke", {
						Thickness = 1,
						Transparency = 0.4,
						ThemeTag = {
							Color = "Accent",
						},
					}),
				})

				local Segment = New("Frame", {
					Size = UDim2.fromOffset(250, 28),
					Position = UDim2.fromOffset(25, 48),
					BackgroundTransparency = 0.4,
					Parent = Dialog.Root,
					ThemeTag = {
						BackgroundColor3 = "ColorpickerInput",
					},
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(0, 7),
					}),
					New("UIStroke", {
						Thickness = 1,
						Transparency = 0.6,
						ThemeTag = {
							Color = "ColorpickerInputBorder",
						},
					}),
					SegmentHighlight,
				})

				for Index, Entry in ipairs({ { "Color", "Color", "palette" }, { "Alpha", "Transparency", "droplet" } }) do
					local Button = New("TextButton", {
						Text = Entry[2],
						FontFace = Font.new(Library.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Center,
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(0.5, 1),
						Position = UDim2.fromScale((Index - 1) * 0.5, 0),
						ZIndex = 2,
						Parent = Segment,
						ThemeTag = {
							TextColor3 = "Text",
						},
					})
					local SegmentIcon = CreateIcon(Entry[3], 16, UDim2.fromScale(0.5, 0.5), Button)
					if SegmentIcon then
						SegmentIcon.AnchorPoint = Vector2.new(1, 0.5)
						local function PlaceSegmentIcon()
							SegmentIcon.Position = UDim2.new(0.5, -math.floor(Button.TextBounds.X / 2) - 8, 0.5, 0)
						end
						PlaceSegmentIcon()
						Creator.AddSignal(Button:GetPropertyChangedSignal("TextBounds"), PlaceSegmentIcon)
					end
					Creator.AddSignal(Button.MouseButton1Click, function()
						SetMode(Entry[1])
					end)
				end
			else
				CreateCaption("COLOR STOPS", UDim2.fromOffset(25, 56))
			end

			local SatCursor = New("ImageLabel", {
				Size = UDim2.new(0, 18, 0, 18),
				ScaleType = Enum.ScaleType.Fit,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = "http://www.roblox.com/asset/?id=4805639000",
			})

			local SatVibMap = New("ImageLabel", {
				Size = UDim2.fromOffset(176, 176),
				Position = UDim2.fromOffset(25, 160),
				Image = "rbxassetid://4155801252",
				BackgroundTransparency = 0,
				Parent = Dialog.Root,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
				SatCursor,
			})
			table.insert(ColorControls, SatVibMap)

			local HueKeypoints = {}
			for Step = 0, 1, 0.1 do
				table.insert(HueKeypoints, ColorSequenceKeypoint.new(Step, Color3.fromHSV(Step, 1, 1)))
			end

			local HueDrag = New("ImageLabel", {
				Size = UDim2.fromOffset(14, 14),
				Image = "http://www.roblox.com/asset/?id=12266946128",
				ImageColor3 = Creator.GetKnobColor(),
			})

			local HueSlider = New("Frame", {
				Size = UDim2.fromOffset(12, 176),
				Position = UDim2.fromOffset(211, 160),
				Parent = Dialog.Root,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
				New("UIGradient", {
					Color = ColorSequence.new(HueKeypoints),
					Rotation = 90,
				}),
				New("Frame", {
					Size = UDim2.new(1, 0, 1, -10),
					Position = UDim2.fromOffset(0, 5),
					BackgroundTransparency = 1,
				}, {
					HueDrag,
				}),
			})
			table.insert(ColorControls, HueSlider)

			local AlphaDrag = New("ImageLabel", {
				Size = UDim2.fromOffset(14, 14),
				Image = "http://www.roblox.com/asset/?id=12266946128",
				ImageColor3 = Creator.GetKnobColor(),
			})

			Creator.OnThemeChanged(function()
				HueDrag.ImageColor3 = Creator.GetKnobColor()
				AlphaDrag.ImageColor3 = Creator.GetKnobColor()
			end)

			local AlphaSlider = New("Frame", {
				Size = UDim2.fromOffset(12, 176),
				Position = UDim2.fromOffset(25, 160),
				BackgroundTransparency = 1,
				Visible = false,
				Parent = Dialog.Root,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
				CreateChecker(6),
				New("Frame", {
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				}, {
					New("UIGradient", {
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(1, 1),
						}),
						Rotation = 270,
					}),
					New("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),
				New("Frame", {
					Size = UDim2.new(1, 0, 1, -10),
					Position = UDim2.fromOffset(0, 5),
					BackgroundTransparency = 1,
				}, {
					AlphaDrag,
				}),
			})
			table.insert(AlphaControls, AlphaSlider)

			local AlphaSwatchColor = New("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
			})

			local AlphaSwatch = New("Frame", {
				Size = UDim2.fromOffset(176, 176),
				Position = UDim2.fromOffset(51, 160),
				BackgroundTransparency = 1,
				Visible = false,
				Parent = Dialog.Root,
			}, {
				CreateChecker(6),
				AlphaSwatchColor,
				New("UIStroke", {
					Thickness = 1,
					Transparency = 0.5,
					ThemeTag = {
						Color = "InElementBorder",
						Transparency = "InElementBorderTransparency",
					},
				}),
				New("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}),
			})
			table.insert(AlphaControls, AlphaSwatch)

			CreateCaption("HEX", UDim2.fromOffset(245, 162), ColorControls)
			local HexInput = CreateInput(UDim2.fromOffset(245, 176), UDim2.fromOffset(190, 28), ColorControls)

			CreateCaption("RED", UDim2.fromOffset(245, 210), ColorControls)
			local RedInput = CreateInput(UDim2.fromOffset(245, 224), UDim2.fromOffset(58, 28), ColorControls)
			CreateCaption("GREEN", UDim2.fromOffset(311, 210), ColorControls)
			local GreenInput = CreateInput(UDim2.fromOffset(311, 224), UDim2.fromOffset(58, 28), ColorControls)
			CreateCaption("BLUE", UDim2.fromOffset(377, 210), ColorControls)
			local BlueInput = CreateInput(UDim2.fromOffset(377, 224), UDim2.fromOffset(58, 28), ColorControls)

			CreateCaption("POSITION %", UDim2.fromOffset(245, 260), ColorControls)
			local ColorPosInput = CreateInput(UDim2.fromOffset(245, 274), UDim2.fromOffset(91, 28), ColorControls)

			CreateCaption("OPACITY %", UDim2.fromOffset(245, 162), AlphaControls)
			local AlphaInput = CreateInput(UDim2.fromOffset(245, 176), UDim2.fromOffset(190, 28), AlphaControls)

			CreateCaption("POSITION %", UDim2.fromOffset(245, 260), AlphaControls)
			local AlphaPosInput = CreateInput(UDim2.fromOffset(245, 274), UDim2.fromOffset(91, 28), AlphaControls)
			SetGroupVisible(AlphaControls, false)

			CreateCaption("ROTATION", UDim2.fromOffset(344, 260))
			local RotationInput = CreateInput(UDim2.fromOffset(344, 274), UDim2.fromOffset(91, 28))

			local function InsertStopAt(Time)
				local Stops = ActiveStops()
				if #Stops >= MaxStops then
					return
				end

				Time = math.clamp(Time, MinGap, 1 - MinGap)
				if Mode == "Color" then
					local Stop, Index = SampleColorStop(ColorStops, Time)
					table.insert(ColorStops, Index, Stop)
					SelectedColor = Index
				else
					local Stop, Index = SampleAlphaStop(AlphaStops, Time)
					table.insert(AlphaStops, Index, Stop)
					SelectedAlpha = Index
				end

				RebuildMarkers()
				Display()
			end

			local function RemoveStop()
				local Stops = ActiveStops()
				if #Stops <= 2 then
					return
				end

				if Mode == "Color" then
					table.remove(ColorStops, SelectedColor)
					SelectedColor = math.clamp(SelectedColor, 1, #ColorStops)
				else
					table.remove(AlphaStops, SelectedAlpha)
					SelectedAlpha = math.clamp(SelectedAlpha, 1, #AlphaStops)
				end

				RebuildMarkers()
				Display()
			end

			CreateSmallButton("+", UDim2.fromOffset(377, 48), UDim2.fromOffset(28, 28), function()
				local Stops = ActiveStops()
				local Index = ActiveIndex()
				local Neighbor = Index < #Stops and Stops[Index + 1] or Stops[Index - 1]
				InsertStopAt((Stops[Index].Time + Neighbor.Time) / 2)
			end, "plus")

			CreateSmallButton("-", UDim2.fromOffset(407, 48), UDim2.fromOffset(28, 28), RemoveStop, "minus")

			Creator.AddSignal(PreviewHolder.MouseButton1Click, function()
				local Fraction = (Mouse.X - PreviewHolder.AbsolutePosition.X) / math.max(PreviewHolder.AbsoluteSize.X, 1)
				InsertStopAt(Fraction)
			end)

			RebuildMarkers = function()
				for _, Marker in ipairs(Markers) do
					Marker.Button:Destroy()
				end
				table.clear(Markers)

				local Stops = ActiveStops()
				for Index = 1, #Stops do
					local Stroke = New("UIStroke", {
						Thickness = 2,
						ThemeTag = {
							Color = "Accent",
						},
					})

					local Fill = New("Frame", {
						Size = UDim2.fromOffset(14, 14),
						Position = UDim2.new(0.5, -7, 0, 8),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					}, {
						New("UICorner", {
							CornerRadius = UDim.new(1, 0),
						}),
						Stroke,
					})

					local Stem = New("Frame", {
						Size = UDim2.fromOffset(2, 9),
						Position = UDim2.new(0.5, -1, 0, 0),
						BackgroundTransparency = 0.5,
						ThemeTag = {
							BackgroundColor3 = "Text",
						},
					})

					local Button = New("TextButton", {
						Text = "",
						Size = UDim2.fromOffset(18, 24),
						BackgroundTransparency = 1,
						Parent = MarkerHolder,
					}, {
						Stem,
						Fill,
					})

					Creator.AddSignal(Button.InputBegan, function(Input)
						if not IsPointerDown(Input) then
							return
						end

						if Mode == "Color" then
							SelectedColor = Index
						else
							SelectedAlpha = Index
						end
						Display()

						if Index == 1 or Index == #Stops then
							return
						end

						while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
							local Fraction = (Mouse.X - MarkerHolder.AbsolutePosition.X) / math.max(MarkerHolder.AbsoluteSize.X, 1)
							Stops[Index].Time = math.clamp(Fraction, Stops[Index - 1].Time + MinGap, Stops[Index + 1].Time - MinGap)
							Display()
							RenderStepped:Wait()
						end
					end)

					table.insert(Markers, { Button = Button, Fill = Fill, Stroke = Stroke, Stem = Stem })
				end
			end

			local function UpdateMarkers()
				local Stops = ActiveStops()
				local Selected = ActiveIndex()
				for Index, Marker in ipairs(Markers) do
					local Stop = Stops[Index]
					if Stop then
						local IsSelected = Index == Selected
						Marker.Button.Position = UDim2.new(Stop.Time, -9, 0, 0)
						Marker.Button.ZIndex = IsSelected and 3 or 1
						Marker.Fill.BackgroundColor3 = Mode == "Color" and HsvToColor3(Stop) or Color3.fromHSV(0, 0, 1 - Stop.Value)
						Marker.Fill.Size = IsSelected and UDim2.fromOffset(16, 16) or UDim2.fromOffset(14, 14)
						Marker.Fill.Position = IsSelected and UDim2.new(0.5, -8, 0, 7) or UDim2.new(0.5, -7, 0, 8)
						Marker.Stroke.Transparency = IsSelected and 0 or 0.75
						Marker.Stem.BackgroundTransparency = IsSelected and 0.1 or 0.6
					end
				end
			end

			Display = function()
				PreviewGradient.Color = BuildColorSequence(ColorStops)
				PreviewGradient.Transparency = HasTransparency and BuildNumberSequence(AlphaStops) or NumberSequence.new(0)
				RotationInput.Input.Text = tostring(math.floor(Rotation))

				if SegmentHighlight then
					SegmentHighlight.Position = Mode == "Color" and UDim2.fromOffset(2, 2) or UDim2.new(0.5, 2, 0, 2)
				end

				CounterLabel.Text = string.format("Stop %d of %d", ActiveIndex(), #ActiveStops())

				UpdateMarkers()

				if Mode == "Color" then
					local Stop = ColorStops[SelectedColor]
					local Color = HsvToColor3(Stop)
					SatVibMap.BackgroundColor3 = Color3.fromHSV(Stop.Hue, 1, 1)
					HueDrag.Position = UDim2.new(0, -1, Stop.Hue, -6)
					SatCursor.Position = UDim2.new(Stop.Sat, 0, 1 - Stop.Vib, 0)
					HexInput.Input.Text = "#" .. Color:ToHex()
					RedInput.Input.Text = tostring(math.round(Color.R * 255))
					GreenInput.Input.Text = tostring(math.round(Color.G * 255))
					BlueInput.Input.Text = tostring(math.round(Color.B * 255))
					ColorPosInput.Input.Text = tostring(math.round(Stop.Time * 100))
				else
					local Stop = AlphaStops[SelectedAlpha]
					local Sampled = SampleColorStop(ColorStops, Stop.Time)
					AlphaSwatchColor.BackgroundColor3 = HsvToColor3(Sampled)
					AlphaSwatchColor.BackgroundTransparency = Stop.Value
					AlphaDrag.Position = UDim2.new(0, -1, 1 - Stop.Value, -6)
					AlphaInput.Input.Text = tostring(math.round((1 - Stop.Value) * 100))
					AlphaPosInput.Input.Text = tostring(math.round(Stop.Time * 100))
				end
			end

			local function SetStopTime(Stops, Index, Percent)
				if Index <= 1 or Index >= #Stops then
					return
				end
				Stops[Index].Time = math.clamp(Percent / 100, Stops[Index - 1].Time + MinGap, Stops[Index + 1].Time - MinGap)
			end

			local function BindChannel(Box, Channel)
				Creator.AddSignal(Box.Input.FocusLost, function(Enter)
					local Number = Enter and tonumber(Box.Input.Text)
					if Number then
						local Stop = ColorStops[SelectedColor]
						local Color = HsvToColor3(Stop)
						local Channels = { Color.R * 255, Color.G * 255, Color.B * 255 }
						Channels[Channel] = math.clamp(math.floor(Number), 0, 255)
						Stop.Hue, Stop.Sat, Stop.Vib = Color3.toHSV(Color3.fromRGB(math.round(Channels[1]), math.round(Channels[2]), math.round(Channels[3])))
					end
					Display()
				end)
			end

			BindChannel(RedInput, 1)
			BindChannel(GreenInput, 2)
			BindChannel(BlueInput, 3)

			Creator.AddSignal(HexInput.Input.FocusLost, function(Enter)
				if Enter then
					local Success, Result = pcall(Color3.fromHex, HexInput.Input.Text)
					if Success and typeof(Result) == "Color3" then
						local Stop = ColorStops[SelectedColor]
						Stop.Hue, Stop.Sat, Stop.Vib = Color3.toHSV(Result)
					end
				end
				Display()
			end)

			Creator.AddSignal(ColorPosInput.Input.FocusLost, function(Enter)
				local Number = Enter and tonumber(ColorPosInput.Input.Text)
				if Number then
					SetStopTime(ColorStops, SelectedColor, Number)
				end
				Display()
			end)

			Creator.AddSignal(AlphaPosInput.Input.FocusLost, function(Enter)
				local Number = Enter and tonumber(AlphaPosInput.Input.Text)
				if Number then
					SetStopTime(AlphaStops, SelectedAlpha, Number)
				end
				Display()
			end)

			Creator.AddSignal(AlphaInput.Input.FocusLost, function(Enter)
				local Number = Enter and tonumber(AlphaInput.Input.Text)
				if Number then
					AlphaStops[SelectedAlpha].Value = 1 - math.clamp(Number, 0, 100) * 0.01
				end
				Display()
			end)

			Creator.AddSignal(RotationInput.Input.FocusLost, function(Enter)
				local Number = Enter and tonumber(RotationInput.Input.Text)
				if Number then
					Rotation = math.clamp(Number, 0, 360)
				end
				Display()
			end)

			Creator.AddSignal(SatVibMap.InputBegan, function(Input)
				if IsPointerDown(Input) then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local MinX = SatVibMap.AbsolutePosition.X
						local MouseX = math.clamp(Mouse.X, MinX, MinX + SatVibMap.AbsoluteSize.X)
						local MinY = SatVibMap.AbsolutePosition.Y
						local MouseY = math.clamp(Mouse.Y, MinY, MinY + SatVibMap.AbsoluteSize.Y)

						local Stop = ColorStops[SelectedColor]
						Stop.Sat = (MouseX - MinX) / SatVibMap.AbsoluteSize.X
						Stop.Vib = 1 - ((MouseY - MinY) / SatVibMap.AbsoluteSize.Y)
						Display()

						RenderStepped:Wait()
					end
				end
			end)

			Creator.AddSignal(HueSlider.InputBegan, function(Input)
				if IsPointerDown(Input) then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local MinY = HueSlider.AbsolutePosition.Y
						local MouseY = math.clamp(Mouse.Y, MinY, MinY + HueSlider.AbsoluteSize.Y)

						ColorStops[SelectedColor].Hue = (MouseY - MinY) / HueSlider.AbsoluteSize.Y
						Display()

						RenderStepped:Wait()
					end
				end
			end)

			Creator.AddSignal(AlphaSlider.InputBegan, function(Input)
				if IsPointerDown(Input) then
					while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						local MinY = AlphaSlider.AbsolutePosition.Y
						local MouseY = math.clamp(Mouse.Y, MinY, MinY + AlphaSlider.AbsoluteSize.Y)

						AlphaStops[SelectedAlpha].Value = 1 - ((MouseY - MinY) / AlphaSlider.AbsoluteSize.Y)
						Display()

						RenderStepped:Wait()
					end
				end
			end)

			RebuildMarkers()
			Display()

			local DoneButton = Dialog:Button("Done", function()
				GradientPicker.Rotation = math.clamp(Rotation, 0, 360)
				GradientPicker:SetStops(ColorStops, HasTransparency and AlphaStops or nil)
			end, "check")
			local CancelButton = Dialog:Button("Cancel", nil, "x")

			for _, Btn in next, { DoneButton, CancelButton } do
				Creator.OverrideTag(Btn.Frame, { BackgroundColor3 = "ColorpickerButton" })
				Creator.OverrideTag(Btn.Frame.UIStroke, { Color = "ColorpickerButtonBorder" })
			end

			Dialog:Open()
		end

		function GradientPicker:Display()
			GradientPicker.Value = BuildColorSequence(GradientPicker.Stops)
			GradientPicker.Transparency = HasTransparency and BuildNumberSequence(GradientPicker.AlphaStops) or NumberSequence.new(0)

			DisplayFrameGradient.Color = GradientPicker.Value
			DisplayFrameGradient.Rotation = GradientPicker.Rotation
			DisplayFrameGradient.Transparency = GradientPicker.Transparency

			Element.Library:SafeCallback(GradientPicker.Callback, GradientPicker.Value, GradientPicker.Rotation, GradientPicker.Transparency)
			Element.Library:SafeCallback(GradientPicker.Changed, GradientPicker.Value, GradientPicker.Rotation, GradientPicker.Transparency)
		end

		function GradientPicker:SetStops(ColorStops, AlphaStops)
			GradientPicker.Stops = CopyStops(ColorStops)
			if AlphaStops then
				GradientPicker.AlphaStops = CopyStops(AlphaStops)
			end
			GradientPicker:Display()
		end

		function GradientPicker:SetHSV(StartHSV, EndHSV)
			GradientPicker.Stops = {
				{ Time = 0, Hue = StartHSV.Hue, Sat = StartHSV.Sat, Vib = StartHSV.Vib },
				{ Time = 1, Hue = EndHSV.Hue, Sat = EndHSV.Sat, Vib = EndHSV.Vib },
			}
			GradientPicker:Display()
		end

		function GradientPicker:SetRotation(Rotation)
			GradientPicker.Rotation = math.clamp(tonumber(Rotation) or 0, 0, 360)
			GradientPicker:Display()
		end

		function GradientPicker:SetValueSequence(Sequence)
			GradientPicker.Stops = StopsFromSequence(Sequence)
			GradientPicker:Display()
		end

		function GradientPicker:SetTransparency(Value)
			HasTransparency = true
			GradientPicker.AlphaStops = AlphaStopsFromValue(Value)
			GradientPicker:Display()
		end

		function GradientPicker:OnChanged(Func)
			GradientPicker.Changed = Func
			Func(GradientPicker.Value, GradientPicker.Rotation, GradientPicker.Transparency)
		end

		function GradientPicker:Destroy()
			GradientPickerFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Creator.AddSignal(GradientPickerFrame.Frame.MouseButton1Click, function()
			CreateGradientDialog()
		end)

		GradientPicker:Display()

		Library.Options[Idx] = GradientPicker
		return GradientPicker
	end

	return Element
end)()

ElementsTable.Dropdown = (function()
	local New = Creator.New

	local SortAliases = {
		load = "Load",
		loaded = "Load",
		order = "Load",
		default = "Load",
		none = "Load",
		alphabet = "Alphabetical",
		alphabetical = "Alphabetical",
		alpha = "Alphabetical",
		unicode = "Alphabetical",
		az = "Alphabetical",
		sorted = "Alphabetical",
		desc = "AlphabeticalDesc",
		alphabeticaldesc = "AlphabeticalDesc",
		za = "AlphabeticalDesc",
	}

	local function ResolveSortMode(Mode)
		if type(Mode) ~= "string" then
			return "Alphabetical"
		end
		return SortAliases[Mode:lower()] or "Alphabetical"
	end

	local Element = {}
	Element.__index = Element
	Element.__type = "Dropdown"

	function Element:New(Idx, Config)
		local Library = self.Library

		local InitialValue = Config.Default
		if Config.Multi then
			InitialValue = {}
			if type(Config.Default) == "table" then
				for Key, State in next, Config.Default do
					if type(Key) == "string" and State == true then
						InitialValue[Key] = true
					end
				end
			end
		end

		local Dropdown = {
			Values = Config.Values,
			Value = InitialValue,
			Multi = Config.Multi,
			SortMode = ResolveSortMode(Config.SortMode),
			Buttons = {},
			Opened = false,
			Type = "Dropdown",
			Callback = Config.Callback or function() end,
		}

		local IsGrouped = self.Type == "Group" or self.Type == "HStack" or self.Type == "VStack"

		local DropdownFrame = Components.Element(Config.Title, Config.Description, self.Container, "Hover", Config.LayoutOrder, Config.Icon, Config.Marquee, Config.Locked)

		local DropdownRow = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 34),
			LayoutOrder = 2,
			Visible = IsGrouped,
			Parent = DropdownFrame.LabelHolder,
		})

		Dropdown.SetTitle = DropdownFrame.SetTitle
		Dropdown.SetDesc = DropdownFrame.SetDesc
		DropdownFrame.LockHandle.Bind(Dropdown)

		local DropdownDisplay = New("TextLabel", {
			FontFace = Font.new(Library.Font, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			Text = "Value",
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 1, 0),
			Position = UDim2.new(0, 8, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			TextTruncate = Enum.TextTruncate.AtEnd,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		local DropdownIco = New("ImageLabel", {
			Image = "rbxassetid://10709790948",
			Size = UDim2.fromOffset(16, 16),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -8, 0.5, 0),
			BackgroundTransparency = 1,
			ThemeTag = {
				ImageColor3 = "SubText",
			},
		})

		local IcoMotor, SetIcoRotation = Creator.SpringMotor(0, DropdownIco, "Rotation", true)

		local DropdownInner = New("TextButton", {
			Size = IsGrouped and UDim2.new(1, 0, 0, 30) or UDim2.fromOffset(160, 30),
			Position = IsGrouped and UDim2.new(0, 0, 0.5, 0) or UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = IsGrouped and Vector2.new(0, 0.5) or Vector2.new(1, 0.5),
			BackgroundTransparency = 0.9,
			Parent = IsGrouped and DropdownRow or DropdownFrame.Frame,
			ThemeTag = {
				BackgroundColor3 = "DropdownFrame",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 5),
			}),
			New("UIStroke", {
				Transparency = 0.5,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "InElementBorder",
					Transparency = "InElementBorderTransparency",
				},
			}),
			DropdownIco,
			DropdownDisplay,
		})

		Creator.Adaptive(DropdownFrame, 170, 340, not IsGrouped, function(Inline)
			DropdownInner.Parent = Inline and DropdownFrame.Frame or DropdownRow
			DropdownInner.Size = Inline and UDim2.fromOffset(160, 30) or UDim2.new(1, 0, 0, 30)
			DropdownInner.Position = Inline and UDim2.new(1, -10, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
			DropdownInner.AnchorPoint = Inline and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
			DropdownRow.Visible = not Inline
		end)

		local DropdownListLayout = New("UIListLayout", {
			Padding = UDim.new(0, 3),
			SortOrder = Enum.SortOrder.LayoutOrder,
		})

		local DROPDOWN_Z_INDEX = 100000

		local DropdownScrollFrame = New("ScrollingFrame", {
			Size = UDim2.new(1, -5, 1, -10),
			Position = UDim2.fromOffset(5, 5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromScale(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ZIndex = DROPDOWN_Z_INDEX + 2,
		}, {
			DropdownListLayout,
		})

		Creator.AttachScrollBar(DropdownScrollFrame, { Thickness = 6 })

		local DropdownSearchBox, DropdownSearchHolder
		if Config.Search then
			local DropdownSearchIcon = New("ImageLabel", {
				Image = "rbxassetid://10734943674",
				Size = UDim2.fromOffset(16, 16),
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 10, 0.5, 0),
				BackgroundTransparency = 1,
				ImageTransparency = 0.3,
				ZIndex = DROPDOWN_Z_INDEX + 4,
				ThemeTag = {
					ImageColor3 = "SubText",
				},
			})

			DropdownSearchBox = New("TextBox", {
				FontFace = Font.new(Library.Font, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				PlaceholderText = "Search...",
				Text = "",
				ClearTextOnFocus = false,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, -36, 1, 0),
				Position = UDim2.new(0, 32, 0, 0),
				BackgroundTransparency = 1,
				ZIndex = DROPDOWN_Z_INDEX + 3,
				ThemeTag = {
					TextColor3 = "Text",
					PlaceholderColor3 = "SubText",
				},
			})

			DropdownSearchHolder = New("Frame", {
				Size = UDim2.new(1, -10, 0, 28),
				Position = UDim2.fromOffset(5, 5),
				BackgroundTransparency = 0.7,
				BackgroundColor3 = Color3.fromRGB(20, 20, 20),
				ZIndex = DROPDOWN_Z_INDEX + 2,
				ThemeTag = {
					BackgroundColor3 = "Element",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}),
				DropdownSearchIcon,
				DropdownSearchBox,
			})

			DropdownScrollFrame.Position = UDim2.fromOffset(5, 38)
			DropdownScrollFrame.Size = UDim2.new(1, -5, 1, -43)
		end

		local DropdownHolderChildren = {
			DropdownScrollFrame,
			New("UICorner", {
				CornerRadius = UDim.new(0, 7),
			}),
			New("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "DropdownBorder",
					Transparency = "DropdownBorderTransparency",
				},
			}),
			New("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "http://www.roblox.com/asset/?id=5554236805",
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(23, 23, 277, 277),
				Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30),
				Position = UDim2.fromOffset(-15, -15),
				ImageColor3 = Color3.fromRGB(0, 0, 0),
				ImageTransparency = 0.1,
				ZIndex = DROPDOWN_Z_INDEX,
			}),
		}
		if DropdownSearchHolder then
			table.insert(DropdownHolderChildren, DropdownSearchHolder)
		end

		table.insert(DropdownHolderChildren, New("UIGradient", {
			ThemeTag = {
				Color = "DropdownHolder",
				Rotation = "DropdownHolderRotation",
				Transparency = "DropdownHolderTransparency",
			},
		}))

		local DropdownHolderFrame = New("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0,
			ZIndex = DROPDOWN_Z_INDEX + 1,
		}, DropdownHolderChildren)

		local DropdownHolderCanvas = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(170, 300),
			Parent = self.Library.GUI,
			Visible = false,
			ZIndex = DROPDOWN_Z_INDEX,
		}, {
			DropdownHolderFrame,
			New("UISizeConstraint", {
				MinSize = Vector2.new(170, 0),
			}),
		})
		table.insert(Library.OpenFrames, DropdownHolderCanvas)

		local function RecalculateListPosition()
			local Add = 0
			if Camera.ViewportSize.Y - DropdownInner.AbsolutePosition.Y < DropdownHolderCanvas.AbsoluteSize.Y - 5 then
				Add = DropdownHolderCanvas.AbsoluteSize.Y
					- 5
					- (Camera.ViewportSize.Y - DropdownInner.AbsolutePosition.Y)
					+ 40
			end
			DropdownHolderCanvas.Position =
				UDim2.fromOffset(DropdownInner.AbsolutePosition.X - 1, DropdownInner.AbsolutePosition.Y - 5 - Add)
		end

		local ListSizeX = 0

		local function RecalculateListSize()
			local VisibleCount = 0
			for _, Option in next, DropdownScrollFrame:GetChildren() do
				if Option:IsA("TextButton") and Option.Visible then
					VisibleCount = VisibleCount + 1
				end
			end

			local ItemHeight = 32
			local ItemPadding = 3
			local InnerMargins = 10
			local SearchHeight = DropdownSearchHolder and 38 or 0
			local Content = VisibleCount > 0 and (VisibleCount * ItemHeight + (VisibleCount - 1) * ItemPadding) or 0
			local Height = math.min(Content + InnerMargins + SearchHeight, 392)
			local Width = math.max(DropdownInner.AbsoluteSize.X, ListSizeX)

			DropdownHolderCanvas.Size = UDim2.fromOffset(Width, Height)
			RecalculateListPosition()
		end

		local function RecalculateCanvasSize()
			DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0, DropdownListLayout.AbsoluteContentSize.Y)
		end

		RecalculateListPosition()
		RecalculateListSize()

		Creator.AddSignal(DropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
			RecalculateCanvasSize()
			RecalculateListSize()
		end)

		Creator.AddSignal(DropdownInner:GetPropertyChangedSignal("AbsolutePosition"), RecalculateListPosition)

		Creator.AddSignal(DropdownInner.MouseButton1Click, function()
			Dropdown:Open()
		end)

		Creator.AddSignal(UserInputService.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				local AbsPos, AbsSize = DropdownHolderFrame.AbsolutePosition, DropdownHolderFrame.AbsoluteSize
				if
					Mouse.X < AbsPos.X
					or Mouse.X > AbsPos.X + AbsSize.X
					or Mouse.Y < (AbsPos.Y - 20 - 1)
					or Mouse.Y > AbsPos.Y + AbsSize.Y
				then
					Dropdown:Close()
				end
			end
		end)

		function Dropdown:FilterOptions(Query)
			Query = (Query or ""):lower()
			for _, Option in next, DropdownScrollFrame:GetChildren() do
				if Option:IsA("TextButton") then
					local Label = Option:FindFirstChild("ButtonLabel")
					Option.Visible = Label == nil
						or Query == ""
						or string.find(Label.Text:lower(), Query, 1, true) ~= nil
				end
			end
			RecalculateCanvasSize()
			RecalculateListSize()
		end

		local ScrollFrame = self.ScrollFrame
		function Dropdown:Open()
			Dropdown.Opened = true
			ScrollFrame.ScrollingEnabled = false
			DropdownHolderCanvas.Visible = true
			SetIcoRotation(180)
			if DropdownSearchBox then
				DropdownSearchBox.Text = ""
				Dropdown:FilterOptions("")
			end
			TweenService:Create(
				DropdownHolderFrame,
				TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
				{ Size = UDim2.fromScale(1, 1) }
			):Play()
		end

		function Dropdown:Close()
			Dropdown.Opened = false
			ScrollFrame.ScrollingEnabled = true
			DropdownHolderFrame.Size = UDim2.fromScale(1, 0.6)
			DropdownHolderCanvas.Visible = false
			SetIcoRotation(0)
		end

		DropdownFrame.LockHandle.OnChanged = function(Value)
			if Value and Dropdown.Opened then
				Dropdown:Close()
			end
		end

		if DropdownSearchBox then
			Creator.AddSignal(DropdownSearchBox:GetPropertyChangedSignal("Text"), function()
				Dropdown:FilterOptions(DropdownSearchBox.Text)
			end)
		end

		function Dropdown:Display()
			local Values = Dropdown.Values
			local Str = ""

			if Config.Multi then
				for Idx, Value in next, Values do
					if Dropdown.Value[Value] then
						Str = Str .. Value .. ", "
					end
				end
				Str = Str:sub(1, #Str - 2)
			else
				Str = Dropdown.Value or ""
			end

			DropdownDisplay.Text = (Str == "" and "--" or Str)
		end

		function Dropdown:GetActiveValues()
			if Config.Multi then
				local T = {}

				for Value, Bool in next, Dropdown.Value do
					table.insert(T, Value)
				end

				return T
			else
				return Dropdown.Value and 1 or 0
			end
		end

		function Dropdown:BuildDropdownList()
			local rawValues = Dropdown.Values
			local Buttons = {}

			for _, child in next, DropdownScrollFrame:GetChildren() do
				if not child:IsA("UIListLayout") then
					child:Destroy()
				end
			end

			local Values = {}
			if Dropdown.SortMode == "Load" then
				for _, v in ipairs(rawValues) do
					table.insert(Values, v)
				end
			else
				local letters, numbers = {}, {}
				for _, v in ipairs(rawValues) do
					local first = tostring(v):sub(1, 1)
					if first:match("%d") then
						table.insert(numbers, v)
					else
						table.insert(letters, v)
					end
				end

				local Descending = Dropdown.SortMode == "AlphabeticalDesc"
				table.sort(letters, function(a, b)
					local A, B = tostring(a):lower(), tostring(b):lower()
					if A == B then
						A, B = tostring(a), tostring(b)
					end
					if Descending then
						return A > B
					end
					return A < B
				end)
				table.sort(numbers, function(a, b)
					local A, B = tonumber(tostring(a):match("^%d+")), tonumber(tostring(b):match("^%d+"))
					if A == B then
						A, B = tostring(a), tostring(b)
					end
					if Descending then
						return A > B
					end
					return A < B
				end)

				for _, v in ipairs(letters) do table.insert(Values, v) end
				for _, v in ipairs(numbers) do table.insert(Values, v) end
			end

			local Count = 0

			for Idx, Value in next, Values do
				local Table = {}

				Count = Count + 1

				local NewVisual = Library.NewVisual == true
				local TextOffset = 10
				local CheckTextOffset = 32

				local ButtonSelector
				local SelectorProp
				if NewVisual then
					ButtonSelector = New("ImageLabel", {
						Name = "ButtonCheck",
						Image = Library.InternalIcons.Check,
						Size = UDim2.fromOffset(14, 14),
						Position = UDim2.new(0, 10, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundTransparency = 1,
						ImageTransparency = 1,
						ZIndex = DROPDOWN_Z_INDEX + 4,
						ThemeTag = {
							ImageColor3 = "Accent",
						},
					})
					SelectorProp = "ImageTransparency"
				else
					ButtonSelector = New("Frame", {
						Size = UDim2.fromOffset(4, 6),
						BackgroundColor3 = Color3.fromRGB(76, 194, 255),
						BackgroundTransparency = 1,
						Position = UDim2.new(0, -1, 0.5, 0),
						AnchorPoint = Vector2.new(0, 0.5),
						ZIndex = DROPDOWN_Z_INDEX + 4,
						ThemeTag = {
							BackgroundColor3 = "Accent",
						},
					}, {
						New("UICorner", {
							CornerRadius = UDim.new(0, 2),
						}),
					})
					SelectorProp = "BackgroundTransparency"
				end

				local ButtonLabel = New("TextLabel", {
					FontFace = Font.new(Library.Font),
					Text = Value,
					TextColor3 = Color3.fromRGB(200, 200, 200),
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -TextOffset, 1, 0),
					Position = UDim2.fromOffset(TextOffset, 0),
					ZIndex = DROPDOWN_Z_INDEX + 4,
					Name = "ButtonLabel",
					ThemeTag = {
						TextColor3 = "Text",
					},
				})

				local Button = New("TextButton", {
					Size = UDim2.new(1, -5, 0, 32),
					BackgroundTransparency = 1,
					ZIndex = DROPDOWN_Z_INDEX + 3,
					Text = "",
					LayoutOrder = Count,
					Parent = DropdownScrollFrame,
					ThemeTag = {
						BackgroundColor3 = "DropdownOption",
					},
				}, {
					ButtonSelector,
					ButtonLabel,
					New("UICorner", {
						CornerRadius = UDim.new(0, 6),
					}),
				})

				local Selected

				if Config.Multi then
					Selected = Dropdown.Value[Value]
				else
					Selected = Dropdown.Value == Value
				end

				local BackMotor, SetBackTransparency = Creator.SpringMotor(1, Button, "BackgroundTransparency", true)
				local SelMotor, SetSelTransparency = Creator.SpringMotor(1, ButtonSelector, SelectorProp, true, not NewVisual)
				local SelectorSizeMotor = Flipper.SingleMotor.new(6)
				local LabelMotor = Flipper.SingleMotor.new(TextOffset)

				SelectorSizeMotor:onStep(function(value)
					if not NewVisual then
						ButtonSelector.Size = UDim2.new(0, 4, 0, value)
					end
				end)

				LabelMotor:onStep(function(value)
					ButtonLabel.Position = UDim2.fromOffset(value, 0)
					ButtonLabel.Size = UDim2.new(1, -value, 1, 0)
				end)

				Creator.AddSignal(Button.MouseEnter, function()
					SetBackTransparency(Selected and Creator.HoverShift(0.89, 0.04) or Creator.HoverShift(1, 0.11))
				end)
				Creator.AddSignal(Button.MouseLeave, function()
					SetBackTransparency(Selected and 0.89 or 1)
				end)
				Creator.AddSignal(Button.MouseButton1Down, function()
					SetBackTransparency(Creator.HoverShift(1, 0.08))
				end)
				Creator.AddSignal(Button.MouseButton1Up, function()
					SetBackTransparency(Selected and Creator.HoverShift(0.89, 0.04) or Creator.HoverShift(1, 0.11))
				end)

				function Table:UpdateButton()
					if Config.Multi then
						Selected = Dropdown.Value[Value]
						if Selected then
							SetBackTransparency(0.89)
						end
					else
						Selected = Dropdown.Value == Value
						SetBackTransparency(Selected and 0.89 or 1)
					end

					if NewVisual then
						LabelMotor:setGoal(Flipper.Spring.new(Selected and CheckTextOffset or TextOffset, { frequency = 6 }))
					else
						SelectorSizeMotor:setGoal(Flipper.Spring.new(Selected and 14 or 6, { frequency = 6 }))
					end
					SetSelTransparency(Selected and 0 or 1)
				end

				Creator.AddSignal(Button.Activated, function()
					local Try = not Selected

					if Dropdown:GetActiveValues() == 1 and not Try and not Config.AllowNull then
					else
						if Config.Multi then
							Selected = Try
							Dropdown.Value[Value] = Selected and true or nil
						else
							Selected = Try
							Dropdown.Value = Selected and Value or nil

							for _, OtherButton in next, Buttons do
								OtherButton:UpdateButton()
							end
						end

						Table:UpdateButton()
						Dropdown:Display()

						Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
						Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
					end
				end)

				Table:UpdateButton()
				Dropdown:Display()

				Buttons[Button] = Table
			end

			ListSizeX = 0
			for Button, Table in next, Buttons do
				if Button.ButtonLabel then
					if Button.ButtonLabel.TextBounds.X > ListSizeX then
						ListSizeX = Button.ButtonLabel.TextBounds.X
					end
				end
			end
			ListSizeX = ListSizeX + (Library.NewVisual and 52 or 30)

			RecalculateCanvasSize()
			RecalculateListSize()

			if DropdownSearchBox then
				Dropdown:FilterOptions(DropdownSearchBox.Text)
			end
		end

		function Dropdown:SetSortMode(Mode)
			Dropdown.SortMode = ResolveSortMode(Mode)
			Dropdown:BuildDropdownList()
		end

		function Dropdown:SetValues(NewValues)
			if NewValues then
				Dropdown.Values = NewValues
			end

			Dropdown:BuildDropdownList()
		end

		function Dropdown:OnChanged(Func)
			Dropdown.Changed = Func
			Func(Dropdown.Value)
		end

		function Dropdown:SetValue(Val)
			if Dropdown.Multi then
				local nTable = {}

				for Value, Bool in next, Val do
					if table.find(Dropdown.Values, Value) then
						nTable[Value] = true
					end
				end

				Dropdown.Value = nTable
			else
				if not Val then
					Dropdown.Value = nil
				elseif table.find(Dropdown.Values, Val) then
					Dropdown.Value = Val
				end
			end

			Dropdown:BuildDropdownList()

			Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
			Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
		end

		function Dropdown:Destroy()
			DropdownFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Dropdown:BuildDropdownList()
		Dropdown:Display()

		local Defaults = {}

		if type(Config.Default) == "string" then
			local Idx = table.find(Dropdown.Values, Config.Default)
			if Idx then
				table.insert(Defaults, Idx)
			end
		elseif type(Config.Default) == "table" then
			for _, Value in next, Config.Default do
				local Idx = table.find(Dropdown.Values, Value)
				if Idx then
					table.insert(Defaults, Idx)
				end
			end
		elseif type(Config.Default) == "number" and Dropdown.Values[Config.Default] ~= nil then
			table.insert(Defaults, Config.Default)
		end

		if next(Defaults) then
			for i = 1, #Defaults do
				local Index = Defaults[i]
				if Config.Multi then
					Dropdown.Value[Dropdown.Values[Index]] = true
				else
					Dropdown.Value = Dropdown.Values[Index]
				end

				if not Config.Multi then
					break
				end
			end

			Dropdown:BuildDropdownList()
			Dropdown:Display()
		end

		Library.Options[Idx] = Dropdown
		return Dropdown
	end

	return Element
end)()

ElementsTable.Input = (function()
	local New = Creator.New
	local AddSignal = Creator.AddSignal

	local Element = {}
	Element.__index = Element
	Element.__type = "Input"

	function Element:New(Idx, Config)
		local Library = self.Library
		assert(Config.Title, "Input - Missing Title")
		Config.Callback = Config.Callback or function() end

		local Input = {
			Value = Config.Default or "",
			Numeric = Config.Numeric or false,
			Finished = Config.Finished or false,
			Callback = Config.Callback or function(Value) end,
			Type = "Input",
		}

		local IsGrouped = self.Type == "Group" or self.Type == "HStack" or self.Type == "VStack"

		local InputFrame = Components.Element(Config.Title, Config.Description, self.Container, "Hover", Config.LayoutOrder, Config.Icon, Config.Marquee, Config.Locked)

		local InputRow = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 34),
			LayoutOrder = 2,
			Visible = IsGrouped,
			Parent = InputFrame.LabelHolder,
		})

		Input.SetTitle = InputFrame.SetTitle
		Input.SetDesc = InputFrame.SetDesc
		InputFrame.LockHandle.Bind(Input)

		local Textbox = Components.Textbox(IsGrouped and InputRow or InputFrame.Frame, true)
		Creator.Adaptive(InputFrame, 170, 340, not IsGrouped, function(Inline)
			Textbox.Frame.Parent = Inline and InputFrame.Frame or InputRow
			Textbox.Frame.Position = Inline and UDim2.new(1, -10, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)
			Textbox.Frame.AnchorPoint = Inline and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
			Textbox.Frame.Size = Inline and UDim2.fromOffset(160, 30) or UDim2.new(1, 0, 0, 30)
			InputRow.Visible = not Inline
		end)
		Textbox.Input.Text = Config.Default or ""
		Textbox.Input.PlaceholderText = Config.Placeholder or ""

		local Box = Textbox.Input

		function Input:SetValue(Text)
			if Config.MaxLength and #Text > Config.MaxLength then
				Text = Text:sub(1, Config.MaxLength)
			end

			if Input.Numeric then
				if (not tonumber(Text)) and Text:len() > 0 then
					Text = Input.Value
				end
			end

			Input.Value = Text
			Box.Text = Text

			Library:SafeCallback(Input.Callback, Input.Value)
			Library:SafeCallback(Input.Changed, Input.Value)
		end

		if Input.Finished then
			AddSignal(Box.FocusLost, function(enter)
				if not enter then
					return
				end
				Input:SetValue(Box.Text)
			end)
		else
			AddSignal(Box:GetPropertyChangedSignal("Text"), function()
				Input:SetValue(Box.Text)
			end)
		end

		function Input:OnChanged(Func)
			Input.Changed = Func
			Func(Input.Value)
		end

		function Input:Destroy()
			InputFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Library.Options[Idx] = Input
		return Input
	end

	return Element
end)()

ElementsTable.Keybind = (function()
	local New = Creator.New

	local Element = {}
	Element.__index = Element
	Element.__type = "Keybind"

	function Element:New(Idx, Config)
		local Library = self.Library
		assert(Config.Title, "KeyBind - Missing Title")
		assert(Config.Default, "KeyBind - Missing default value.")

		local Keybind = {
			Value = Config.Default,
			Toggled = false,
			Mode = Config.Mode or "Toggle",
			Type = "Keybind",
			Callback = Config.Callback or function(Value) end,
			ChangedCallback = Config.ChangedCallback or function(New) end,
		}

		local Picking = false

		local IsGrouped = self.Type == "Group" or self.Type == "HStack" or self.Type == "VStack"

		local KeybindFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config.LayoutOrder, Config.Icon, Config.Marquee, Config.Locked)

		KeybindFrame.TitleLabel.Size = UDim2.new(1, -70, 0, 14)
		KeybindFrame.DescLabel.Size = UDim2.new(1, -70, 0, 14)

		Keybind.SetTitle = KeybindFrame.SetTitle
		Keybind.SetDesc = KeybindFrame.SetDesc
		KeybindFrame.LockHandle.Bind(Keybind)

		local KeybindDisplayLabel = New("TextLabel", {
			FontFace = Font.new(Library.Font, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
			Text = Config.Default,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.new(0, 0, 0, 14),
			Position = UDim2.new(0, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		local KeybindDisplayFrame = New("TextButton", {
			Size = UDim2.fromOffset(0, 30),
			Position = UDim2.new(1, -10, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 0.9,
			Parent = KeybindFrame.Frame,
			AutomaticSize = Enum.AutomaticSize.X,
			ThemeTag = {
				BackgroundColor3 = "Keybind",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 5),
			}),
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
			}),
			New("UIStroke", {
				Transparency = 0.5,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "InElementBorder",
					Transparency = "InElementBorderTransparency",
				},
			}),
			KeybindDisplayLabel,
		})

		function Keybind:GetState()
			if (Keybind.Locked or UserInputService:GetFocusedTextBox()) and Keybind.Mode ~= "Always" then
				return false
			end

			if Keybind.Mode == "Always" then
				return true
			elseif Keybind.Mode == "Hold" then
				if Keybind.Value == "None" then
					return false
				end

				local Key = Keybind.Value

				if Key == "MouseLeft" or Key == "MouseRight" then
					return Key == "MouseLeft" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
						or Key == "MouseRight"
							and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
				else
					return UserInputService:IsKeyDown(Enum.KeyCode[Keybind.Value])
				end
			else
				return Keybind.Toggled
			end
		end

		function Keybind:SetValue(Key, Mode)
			Key = Key or Keybind.Key
			Mode = Mode or Keybind.Mode

			KeybindDisplayLabel.Text = Key
			Keybind.Value = Key
			Keybind.Mode = Mode
		end

		function Keybind:OnClick(Callback)
			Keybind.Clicked = Callback
		end

		function Keybind:OnChanged(Callback)
			Keybind.Changed = Callback
			Callback(Keybind.Value)
		end

		function Keybind:DoClick()
			Library:SafeCallback(Keybind.Callback, Keybind.Toggled)
			Library:SafeCallback(Keybind.Clicked, Keybind.Toggled)
		end

		function Keybind:Destroy()
			KeybindFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Creator.AddSignal(KeybindDisplayFrame.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Picking = true
				KeybindDisplayLabel.Text = "..."

				wait(0.2)

				local Event
				Event = UserInputService.InputBegan:Connect(function(Input)
					local Key

					if Input.UserInputType == Enum.UserInputType.Keyboard then
						Key = Input.KeyCode.Name
					elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Key = "MouseLeft"
					elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
						Key = "MouseRight"
					end

					local EndedEvent
					EndedEvent = UserInputService.InputEnded:Connect(function(Input)
						if
							Input.KeyCode.Name == Key
							or Key == "MouseLeft" and Input.UserInputType == Enum.UserInputType.MouseButton1
							or Key == "MouseRight" and Input.UserInputType == Enum.UserInputType.MouseButton2
						then
							Picking = false

							KeybindDisplayLabel.Text = Key
							Keybind.Value = Key

							Library:SafeCallback(Keybind.ChangedCallback, Input.KeyCode or Input.UserInputType)
							Library:SafeCallback(Keybind.Changed, Input.KeyCode or Input.UserInputType)

							Event:Disconnect()
							EndedEvent:Disconnect()
						end
					end)
				end)
			end
		end)

		Creator.AddSignal(UserInputService.InputBegan, function(Input)
			if not Picking and not Keybind.Locked and not UserInputService:GetFocusedTextBox() then
				if Keybind.Mode == "Toggle" then
					local Key = Keybind.Value

					if Key == "MouseLeft" or Key == "MouseRight" then
						if
							Key == "MouseLeft" and Input.UserInputType == Enum.UserInputType.MouseButton1
							or Key == "MouseRight" and Input.UserInputType == Enum.UserInputType.MouseButton2
						then
							Keybind.Toggled = not Keybind.Toggled
							Keybind:DoClick()
						end
					elseif Input.UserInputType == Enum.UserInputType.Keyboard then
						if Input.KeyCode.Name == Key then
							Keybind.Toggled = not Keybind.Toggled
							Keybind:DoClick()
						end
					end
				end
			end
		end)

		Library.Options[Idx] = Keybind
		return Keybind
	end

	return Element
end)()

ElementsTable.Paragraph = (function()
	local Paragraph = {}
	Paragraph.__index = Paragraph
	Paragraph.__type = "Paragraph"

	function Paragraph:New(Config)
		assert(Config.Title, "Paragraph - Missing Title")
		Config.Content = Config.Content or ""

		local ParagraphFrame = Components.Element(Config.Title, Config.Content, Paragraph.Container, false, Config.LayoutOrder, Config.Icon, Config.Marquee == true, Config.Locked)
		ParagraphFrame.Frame.BackgroundTransparency = 0.92
		ParagraphFrame.Border.Transparency = 0.6

		local Para = ParagraphFrame
		Para.SetTitle = ParagraphFrame.SetTitle
		Para.SetDesc = ParagraphFrame.SetDesc
		Para.SetContent = ParagraphFrame.SetDesc
		ParagraphFrame.LockHandle.Bind(Para)

		return Para
	end

	return Paragraph
end)()

ElementsTable.Slider = (function()
	local New = Creator.New

	local Element = {}
	Element.__index = Element
	Element.__type = "Slider"

	function Element:New(Idx, Config)
		local Library = self.Library
		assert(Config.Title, "Slider - Missing Title.")
		assert(Config.Default, "Slider - Missing default value.")
		assert(Config.Min, "Slider - Missing minimum value.")
		assert(Config.Max, "Slider - Missing maximum value.")
		assert(Config.Rounding, "Slider - Missing rounding value.")

		local Slider = {
			Value = nil,
			Min = Config.Min,
			Max = Config.Max,
			Rounding = Config.Rounding,
			Callback = Config.Callback or function(Value) end,
			Type = "Slider",
		}

		local Dragging = false
		local UseButtons = Config.StepButtons == true
		local LeftIconName = Config.LeftIcon or (UseButtons and Library.InternalIcons.Minus or nil)
		local RightIconName = Config.RightIcon or (UseButtons and Library.InternalIcons.Plus or nil)
		local PadLeft = LeftIconName and 22 or 0
		local PadRight = RightIconName and 22 or 0
		local IsGrouped = self.Type == "Group" or self.Type == "HStack" or self.Type == "VStack"

		local SliderFrame = Components.Element(Config.Title, Config.Description, self.Container, "Hover", Config.LayoutOrder, Config.Icon, Config.Marquee, Config.Locked)

		local SliderDot, SliderRail, SliderFill, SliderDisplay, SliderInner, SliderRow, SliderHit, SliderValueTooltip, SliderConstraint, SliderTooltipStroke
		local ShowTooltip, HideTooltip

		SliderRow = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 20),
			LayoutOrder = 2,
			Visible = IsGrouped,
			Parent = SliderFrame.LabelHolder,
		})

		if Library.NewVisual then

			SliderTooltipStroke = New("UIStroke", {
				Thickness = 1,
				Transparency = 1,
				ThemeTag = {
					Color = "InElementBorder",
				},
			})

			SliderValueTooltip = New("CanvasGroup", {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0, 0, 0, -6),
				Size = UDim2.fromOffset(48, 22),
				BackgroundTransparency = 0,
				GroupTransparency = 1,
				Visible = true,
				ZIndex = 10,
				ThemeTag = {
					BackgroundColor3 = "Element",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}),
				SliderTooltipStroke,
				New("TextLabel", {
					Name = "ValueLabel",
					FontFace = Font.new(Library.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
					Text = "0",
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Center,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 10,
					ThemeTag = {
						TextColor3 = "Text",
					},
				}),
			})

			SliderDot = New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(3, 18),
				ZIndex = 5,
				ThemeTag = {
					BackgroundColor3 = "Accent",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 2),
				}),
				New("UIStroke", {
					Thickness = 1.5,
					Transparency = 0.3,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {
						Color = "AcrylicBorder",
					},
				}),
				SliderValueTooltip,
			})

			SliderRail = New("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, 0),
				Size = UDim2.fromScale(1, 1),
			}, {
				SliderDot,
			})

			SliderFill = New("Frame", {
				Size = UDim2.new(0, 0, 1, 0),
				ThemeTag = {
					BackgroundColor3 = "Accent",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			})

			SliderInner = New("Frame", {
				Size = IsGrouped and UDim2.new(1, -40, 0, 4) or UDim2.new(1, 0, 0, 4),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = IsGrouped and UDim2.new(1, -8, 0.5, 0) or UDim2.new(1, -10, 0.5, 0),
				BackgroundTransparency = 0.4,
				Parent = IsGrouped and SliderRow or SliderFrame.Frame,
				ThemeTag = {
					BackgroundColor3 = "SliderRail",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			})

			SliderConstraint = New("UISizeConstraint", {
				MaxSize = IsGrouped and Vector2.new(math.huge, math.huge) or Vector2.new(150, math.huge),
				Parent = SliderInner,
			})

			SliderFill.Parent = SliderInner
			SliderRail.Parent = SliderInner

			SliderHit = New("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, 12, 0, 24),
				BackgroundTransparency = 1,
				ZIndex = 2,
				Parent = SliderInner,
			})

			local TooltipTween
			local TooltipStrokeTween

			local function SetTooltipVisible(Visible)
				if TooltipTween then
					TooltipTween:Cancel()
				end
				if TooltipStrokeTween then
					TooltipStrokeTween:Cancel()
				end
				local Info = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
				TooltipTween = TweenService:Create(SliderValueTooltip, Info, { GroupTransparency = Visible and 0 or 1 })
				TooltipStrokeTween = TweenService:Create(
					SliderTooltipStroke,
					Info,
					{ Transparency = Visible and 0.5 or 1 }
				)
				TooltipTween:Play()
				TooltipStrokeTween:Play()
			end

			ShowTooltip = function()
				SetTooltipVisible(true)
			end

			HideTooltip = function()
				SetTooltipVisible(false)
			end
		else
			SliderDot = New("ImageLabel", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, -7, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				Image = "http://www.roblox.com/asset/?id=12266946128",
				ThemeTag = {
					ImageColor3 = "Accent",
				},
			})

			SliderRail = New("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(7, 0),
				Size = UDim2.new(1, -14, 1, 0),
			}, {
				SliderDot,
			})

			SliderFill = New("Frame", {
				Size = UDim2.new(0, 0, 1, 0),
				ThemeTag = {
					BackgroundColor3 = "Accent",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			})

			SliderDisplay = New("TextLabel", {
				FontFace = Font.new(Library.Font),
				Text = "Value",
				TextSize = 12,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Right,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 100, 0, 14),
				Position = UDim2.new(0, -4 - PadLeft, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				ThemeTag = {
					TextColor3 = "SubText",
				},
			})

			SliderConstraint = New("UISizeConstraint", {
				MaxSize = IsGrouped and Vector2.new(math.huge, math.huge) or Vector2.new(150, math.huge),
			})

			SliderInner = New("Frame", {
				Size = IsGrouped and UDim2.new(1, -40, 0, 4) or UDim2.new(1, 0, 0, 4),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = IsGrouped and UDim2.new(1, -8, 0.5, 0) or UDim2.new(1, -10, 0.5, 0),
				BackgroundTransparency = 0.4,
				Parent = IsGrouped and SliderRow or SliderFrame.Frame,
				ThemeTag = {
					BackgroundColor3 = "SliderRail",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
				SliderConstraint,
				SliderDisplay,
				SliderFill,
				SliderRail,
			})
		end

		local MinusButton, PlusButton

		local function CreateSideIcon(IconName, Direction, Interactive)
			local Icon = Library:GetIcon(IconName)
			return New(Interactive and "ImageButton" or "ImageLabel", {
				Size = UDim2.fromOffset(16, 16),
				AnchorPoint = Direction < 0 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5),
				Position = Direction < 0 and UDim2.new(0, -4, 0.5, 0) or UDim2.new(1, 4, 0.5, 0),
				BackgroundTransparency = 1,
				Image = Icon and Icon.Image or "",
				ImageRectOffset = Icon and Icon.ImageRectOffset or Vector2.zero,
				ImageRectSize = Icon and Icon.ImageRectSize or Vector2.zero,
				ZIndex = 4,
				Parent = SliderInner,
				ThemeTag = {
					ImageColor3 = "SubText",
				},
			})
		end

		if LeftIconName then
			MinusButton = CreateSideIcon(LeftIconName, -1, UseButtons)
		end

		if RightIconName then
			PlusButton = CreateSideIcon(RightIconName, 1, UseButtons)
		end

		Creator.Adaptive(SliderFrame, 170 + PadLeft + PadRight, 340 + PadLeft + PadRight, not IsGrouped, function(Inline)
			SliderRow.Visible = not Inline
			SliderInner.Parent = Inline and SliderFrame.Frame or SliderRow
			SliderInner.Size = Inline and UDim2.new(1, 0, 0, 4) or UDim2.new(1, -(Library.NewVisual and 16 or 40) - PadLeft - PadRight, 0, 4)
			SliderInner.Position = Inline and UDim2.new(1, -10 - PadRight, 0.5, 0) or UDim2.new(1, -8 - PadRight, 0.5, 0)
			SliderConstraint.MaxSize = Inline and Vector2.new(150, math.huge) or Vector2.new(math.huge, math.huge)
		end)

		Slider.SetTitle = SliderFrame.SetTitle
		Slider.SetDesc = SliderFrame.SetDesc
		SliderFrame.LockHandle.Bind(Slider)
		SliderFrame.LockHandle.OnChanged = function(Value)
			if Value then
				Dragging = false
			end
		end

		local function BeginDrag(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = true
				if ShowTooltip then
					ShowTooltip()
				end
				local SizeScale =
					math.clamp((Input.Position.X - SliderRail.AbsolutePosition.X) / SliderRail.AbsoluteSize.X, 0, 1)
				Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * SizeScale))
			end
		end

		Creator.AddSignal(SliderDot.InputBegan, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = true
				if ShowTooltip then
					ShowTooltip()
				end
			end
		end)

		Creator.AddSignal(SliderRail.InputBegan, BeginDrag)

		if SliderHit then
			Creator.AddSignal(SliderHit.InputBegan, BeginDrag)
		end

		Creator.AddSignal(UserInputService.InputEnded, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				Dragging = false
				if HideTooltip then
					HideTooltip()
				end
			end
		end)

		Creator.AddSignal(UserInputService.InputChanged, function(Input)
			if
				Dragging
				and (
					Input.UserInputType == Enum.UserInputType.MouseMovement
					or Input.UserInputType == Enum.UserInputType.Touch
				)
			then
				local SizeScale =
					math.clamp((Input.Position.X - SliderRail.AbsolutePosition.X) / SliderRail.AbsoluteSize.X, 0, 1)
				Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * SizeScale))
			end
		end)

		function Slider:OnChanged(Func)
			Slider.Changed = Func
			Func(Slider.Value)
		end

		function Slider:SetValue(Value)
			self.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Rounding)
			local Scale = (self.Value - Slider.Min) / (Slider.Max - Slider.Min)
			if SliderValueTooltip then
				SliderDot.Position = UDim2.new(Scale, 0, 0.5, 0)
				SliderValueTooltip.ValueLabel.Text = tostring(self.Value)
			else
				SliderDot.Position = UDim2.new(Scale, -7, 0.5, 0)
			end
			SliderFill.Size = UDim2.fromScale(Scale, 1)
			if SliderDisplay then
				SliderDisplay.Text = tostring(self.Value)
			end

			Library:SafeCallback(Slider.Callback, self.Value)
			Library:SafeCallback(Slider.Changed, self.Value)
		end

		function Slider:Destroy()
			SliderFrame:Destroy()
			Library.Options[Idx] = nil
		end

		if UseButtons then
			local HoldToken = 0
			local StepSize = Config.Step or (1 / 10 ^ Slider.Rounding)

			local function IsPress(Input)
				return Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch
			end

			local function StopHold()
				HoldToken = HoldToken + 1
				if HideTooltip then
					HideTooltip()
				end
			end

			local function StartHold(Direction)
				HoldToken = HoldToken + 1
				local Token = HoldToken
				Slider:SetValue(Slider.Value + StepSize * Direction)
				if ShowTooltip then
					ShowTooltip()
				end

				task.spawn(function()
					task.wait(0.4)
					local Interval = 0.12
					local Ticks = 0
					while Token == HoldToken do
						local Multiplier = 1 + math.floor(Ticks / 15)
						Slider:SetValue(Slider.Value + StepSize * Direction * Multiplier)
						Ticks = Ticks + 1
						Interval = math.max(Interval * 0.92, 0.03)
						task.wait(Interval)
					end
				end)
			end

			for Button, Direction in pairs({ [MinusButton] = -1, [PlusButton] = 1 }) do
				Creator.AddSignal(Button.InputBegan, function(Input)
					if IsPress(Input) then
						StartHold(Direction)
					end
				end)

				Creator.AddSignal(Button.InputEnded, function(Input)
					if IsPress(Input) then
						StopHold()
					end
				end)

				Creator.AddSignal(Button.MouseEnter, function()
					Button.ImageColor3 = Creator.GetThemeProperty("Text")
				end)

				Creator.AddSignal(Button.MouseLeave, function()
					Button.ImageColor3 = Creator.GetThemeProperty("SubText")
				end)
			end

			Creator.AddSignal(UserInputService.InputEnded, function(Input)
				if IsPress(Input) then
					StopHold()
				end
			end)
		end

		Slider:SetValue(Config.Default)

		Library.Options[Idx] = Slider
		return Slider
	end

	return Element
end)()


ElementsTable.Toggle = (function()
	local New = Creator.New

	local Element = {}
	Element.__index = Element
	Element.__type = "Toggle"

	function Element:New(Idx, Config)
		local Library = self.Library
		assert(Config.Title, "Toggle - Missing Title")

		local Toggle = {
			Value = Config.Default or false,
			Callback = Config.Callback or function(Value) end,
			Type = "Toggle",
		}

		local IsGrouped = self.Type == "Group" or self.Type == "HStack" or self.Type == "VStack"

		local ToggleFrame = Components.Element(Config.Title, Config.Description, self.Container, true, Config.LayoutOrder, Config.Icon, Config.Marquee, Config.Locked)
		ToggleFrame.DescLabel.Size = UDim2.new(1, -54, 0, 14)
		ToggleFrame.TitleLabel.Size = UDim2.new(1, -54, 0, 14)

		Toggle.SetTitle = ToggleFrame.SetTitle
		Toggle.SetDesc = ToggleFrame.SetDesc
		ToggleFrame.LockHandle.Bind(Toggle)

		local ToggleCircle = New("ImageLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.fromOffset(14, 14),
			Position = UDim2.new(0, 2, 0.5, 0),
			Image = "http://www.roblox.com/asset/?id=12266946128",
			ImageTransparency = 0.5,
			ThemeTag = {
				ImageColor3 = "ToggleSlider",
			},
		})

		local ToggleBorder = New("UIStroke", {
			Transparency = 0.5,
			ThemeTag = {
				Color = "ToggleSlider",
			},
		})

		local ToggleSlider = New("Frame", {
			Size = UDim2.fromOffset(36, 18),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			Parent = ToggleFrame.Frame,
			BackgroundTransparency = 1,
			ThemeTag = {
				BackgroundColor3 = "Accent",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 9),
			}),
			ToggleBorder,
			ToggleCircle,
		})

		function Toggle:OnChanged(Func)
			Toggle.Changed = Func
			Func(Toggle.Value)
		end

		local ToggleCircleIcon
		if Library.NewVisual then
			ToggleCircleIcon = New("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(8, 8),
				BackgroundTransparency = 1,
				Image = "rbxassetid://110786993356448",
				ImageColor3 = Color3.new(1, 1, 1),
				ZIndex = 2,
				Parent = ToggleCircle,
			})
		end

		local function UpdateToggleIconColor()
			if not ToggleCircleIcon then return end
			local KnobColor = Creator.GetThemeProperty(Toggle.Value and "ToggleToggled" or "ToggleSlider")
			ToggleCircleIcon.ImageColor3 = Color3.new(1 - KnobColor.R, 1 - KnobColor.G, 1 - KnobColor.B)
		end

		if Library.NewVisual then
			Creator.OnThemeChanged(UpdateToggleIconColor)
		end

		function Toggle:SetValue(Value)
			Value = not not Value
			Toggle.Value = Value

			Creator.OverrideTag(ToggleBorder, { Color = Toggle.Value and "Accent" or "ToggleSlider" })
			Creator.OverrideTag(ToggleCircle, { ImageColor3 = Toggle.Value and "ToggleToggled" or "ToggleSlider" })
			if Library.NewVisual then
				ToggleCircleIcon.Image = Toggle.Value and "rbxassetid://93898873302694" or "rbxassetid://110786993356448"
				UpdateToggleIconColor()
			end
			TweenService:Create(
				ToggleCircle,
				TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
				{ Position = UDim2.new(0, Toggle.Value and 19 or 2, 0.5, 0) }
			):Play()
			TweenService:Create(
				ToggleSlider,
				TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
				{ BackgroundTransparency = Toggle.Value and 0 or 1 }
			):Play()
			ToggleCircle.ImageTransparency = Toggle.Value and 0 or 0.5

			Library:SafeCallback(Toggle.Callback, Toggle.Value)
			Library:SafeCallback(Toggle.Changed, Toggle.Value)
		end

		function Toggle:Destroy()
			ToggleFrame:Destroy()
			Library.Options[Idx] = nil
		end

		Creator.AddSignal(ToggleFrame.Frame.MouseButton1Click, function()
			Toggle:SetValue(not Toggle.Value)
		end)

		Toggle:SetValue(Toggle.Value)

		Library.Options[Idx] = Toggle
		return Toggle
	end

	return Element
end)()

ElementsTable.Image = (function()
	local New = Creator.New

	local Element = {}
	Element.__index = Element
	Element.__type = "Image"

	local function ResolveImage(Source)
		if type(Source) ~= "string" or Source == "" then
			return ""
		end
		if Source:match("^rbxassetid://") or Source:match("^rbxasset://") then
			return Source
		end
		if Source:match("^%d+$") then
			return "rbxassetid://" .. Source
		end
		return Source
	end

	local function ParseAspectRatio(Ratio)
		if type(Ratio) == "number" then
			return Ratio
		end
		local Width, Height = tostring(Ratio):match("(%d+):(%d+)")
		if Width and Height and tonumber(Height) ~= 0 then
			return tonumber(Width) / tonumber(Height)
		end
		return 16 / 9
	end

	function Element:New(Config)
		Config = Config or {}
		local Parent = self.Container
		if not Parent then
			return
		end

		local Radius = Config.Radius or 8
		local AspectRatio = ParseAspectRatio(Config.AspectRatio or "16:9")
		local IsGrouped = self.Type == "Group" or self.Type == "HStack" or self.Type == "VStack"
		local OffsetX = IsGrouped and 0 or -16

		local Wrap = New("Frame", {
			Size = UDim2.new(1, OffsetX, 0, 150),
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = Config.LayoutOrder or 0,
			Parent = Parent,
		})

		local function RecalcAspectRatio()
			local Width = Wrap.AbsoluteSize.X
			if Width > 0 and AspectRatio and AspectRatio > 0 then
				Wrap.Size = UDim2.new(1, OffsetX, 0, math.floor(Width / AspectRatio))
			end
		end

		Creator.AddSignal(Wrap:GetPropertyChangedSignal("AbsoluteSize"), RecalcAspectRatio)
		task.defer(RecalcAspectRatio)

		local Library = self.Library

		local ImageLabel = New("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Image = "",
			ScaleType = Enum.ScaleType.Fit,
			Parent = Wrap,
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, Radius) }),
		})

		local function ApplyImage(Source)
			local Resolved = ResolveImage(Source)
			if Resolved:match("^rbxasset") then
				ImageLabel.Image = Resolved
			else
				ImageLabel.Image = Library:ResolveMedia(Resolved)
			end
		end

		task.spawn(ApplyImage, Config.Image or "")

		local Image = { Frame = Wrap, Type = "Image" }

		Creator.AttachLock(Wrap, Config.Locked, { Radius = Radius }).Bind(Image)

		function Image:SetImage(Source)
			task.spawn(ApplyImage, Source)
		end

		function Image:SetAspectRatio(Ratio)
			AspectRatio = ParseAspectRatio(Ratio)
			RecalcAspectRatio()
		end

		function Image:Destroy()
			Wrap:Destroy()
		end

		return Image
	end

	return Element
end)()

ElementsTable.Viewport = (function()
	local New = Creator.New

	local Element = {}
	Element.__index = Element
	Element.__type = "Viewport"

	local function ParseAspectRatio(Ratio)
		if type(Ratio) == "number" then
			return Ratio
		end
		if type(Ratio) == "string" then
			local Width, Height = Ratio:match("(%d+):(%d+)")
			if Width and Height and tonumber(Height) ~= 0 then
				return tonumber(Width) / tonumber(Height)
			end
		end
		return nil
	end

	function Element:New(IdxOrConfig, MaybeConfig)
		local SaveIndex, Config
		if type(IdxOrConfig) == "string" then
			SaveIndex, Config = IdxOrConfig, MaybeConfig
		else
			Config = IdxOrConfig
		end
		Config = Config or {}

		local Parent = self.Container
		if not Parent then return end

		local Library = self.Library
		local ScrollFrame = self.ScrollFrame
		local IsGrouped = self.Type == "Group" or self.Type == "HStack" or self.Type == "VStack"
		local OffsetX = IsGrouped and 0 or -16
		local Radius = Config.Radius or 8

		local Viewport = {
			__type = "Viewport",
			Type = "Viewport",
			Object = nil,
			Camera = Config.Camera or Instance.new("Camera"),
			Interactive = Config.Interactive or false,
			Height = Config.Height or 200,
			Focused = Config.Focused ~= false,
			Ambient = Config.Ambient,
			LightColor = Config.LightColor,
			LightDirection = Config.LightDirection,
			Value = nil,
		}

		local IsDragging, IsPinching = false, false
		local LastMousePosition, LastPinchDistance = nil, 0
		local AspectRatio = ParseAspectRatio(Config.AspectRatio)

		local HolderFrame = New("Frame", {
			Name = "ViewportHolder",
			Size = UDim2.new(1, OffsetX, 0, Viewport.Height),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = Config.LayoutOrder or 0,
			Parent = Parent,
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, Radius) }),
			New("UIStroke", {
				Transparency = 0.6,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = {
					Color = "InElementBorder",
				},
			}),
		})

		local function RecalculateAspect()
			if not AspectRatio or AspectRatio <= 0 then return end
			local Width = HolderFrame.AbsoluteSize.X
			if Width > 0 then
				HolderFrame.Size = UDim2.new(1, OffsetX, 0, math.floor(Width / AspectRatio))
			end
		end

		Creator.AddSignal(HolderFrame:GetPropertyChangedSignal("AbsoluteSize"), RecalculateAspect)
		if AspectRatio then
			task.defer(RecalculateAspect)
		end

		local Background = New("ImageLabel", {
			Name = "ViewportBackground",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Config.BackgroundColor or Color3.fromRGB(15, 15, 20),
			BackgroundTransparency = Config.BackgroundTransparency or 0.1,
			BorderSizePixel = 0,
			Image = "",
			ImageTransparency = Config.ImageTransparency or 0,
			ScaleType = Config.ScaleType or Enum.ScaleType.Crop,
			Parent = HolderFrame,
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, Radius) }),
		})

		if Config.Noise ~= false then
			New("ImageLabel", {
				Name = "ViewportNoise",
				Image = "rbxassetid://9968344227",
				ScaleType = Enum.ScaleType.Tile,
				TileSize = UDim2.fromOffset(128, 128),
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ImageTransparency = 0.92,
				Parent = Background,
			}, {
				New("UICorner", { CornerRadius = UDim.new(0, Radius) }),
			})
		end

		local function ApplyImage(Image)
			if Image and Image ~= "" then
				Background.Image = Library:ResolveMedia(Image)
			else
				Background.Image = ""
			end
		end

		if Config.Image then
			task.spawn(ApplyImage, Config.Image)
		end

		local Canvas = New("CanvasGroup", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Parent = HolderFrame,
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, Radius) }),
		})

		local ViewportFrame = New("ViewportFrame", {
			Name = "Viewport",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			CurrentCamera = Viewport.Camera,
			Active = Viewport.Interactive,
			Parent = Canvas,
		})

		if Viewport.Ambient then
			ViewportFrame.Ambient = Viewport.Ambient
		end
		if Viewport.LightColor then
			ViewportFrame.LightColor = Viewport.LightColor
		end
		if Viewport.LightDirection then
			ViewportFrame.LightDirection = Viewport.LightDirection
		end

		Viewport.Camera.Parent = ViewportFrame
		Viewport.Viewport = ViewportFrame

		local function GetPivot()
			if not Viewport.Object then return nil end
			local Success, Pivot = pcall(function()
				return Viewport.Object:GetPivot().Position
			end)
			return Success and Pivot or nil
		end

		local function UpdateZoomValue()
			local Pivot = GetPivot()
			if Pivot then
				Viewport.Value = (Viewport.Camera.CFrame.Position - Pivot).Magnitude
			end
		end

		local function Zoom(Amount)
			local Pivot = GetPivot()
			if not Pivot then return end
			local Camera = Viewport.Camera
			local Distance = (Camera.CFrame.Position - Pivot).Magnitude - Amount
			if Config.ZoomMin then
				Distance = math.max(Distance, Config.ZoomMin)
			end
			if Config.ZoomMax then
				Distance = math.min(Distance, Config.ZoomMax)
			end
			Distance = math.max(Distance, 0.1)
			Camera.CFrame = CFrame.lookAt(Pivot - Camera.CFrame.LookVector * Distance, Pivot)
			UpdateZoomValue()
		end

		local function IsPositionInViewport(Position)
			local FramePosition, FrameSize = ViewportFrame.AbsolutePosition, ViewportFrame.AbsoluteSize
			return Position.X >= FramePosition.X and Position.X <= FramePosition.X + FrameSize.X
				and Position.Y >= FramePosition.Y and Position.Y <= FramePosition.Y + FrameSize.Y
		end

		local function SetScrolling(Enabled)
			if ScrollFrame then
				ScrollFrame.ScrollingEnabled = Enabled
			end
		end

		Creator.AddSignal(ViewportFrame.MouseEnter, function()
			if Viewport.Interactive then
				SetScrolling(false)
			end
		end)

		Creator.AddSignal(ViewportFrame.InputEnded, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
				SetScrolling(true)
			end
		end)

		Creator.AddSignal(ViewportFrame.InputBegan, function(Input)
			if not Viewport.Interactive then return end
			if Input.UserInputType == Enum.UserInputType.MouseButton1
				or (Input.UserInputType == Enum.UserInputType.Touch and not IsPinching) then
				IsDragging = true
				LastMousePosition = Input.Position
			end
		end)

		Creator.AddSignal(UserInputService.InputEnded, function(Input)
			if not Viewport.Interactive then return end
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsDragging = false
			end
		end)

		Creator.AddSignal(UserInputService.InputChanged, function(Input)
			if not (Viewport.Interactive and IsDragging and not IsPinching) then return end
			if Input.UserInputType ~= Enum.UserInputType.MouseMovement and Input.UserInputType ~= Enum.UserInputType.Touch then return end
			local Pivot = GetPivot()
			if not Pivot then return end

			local Delta = Input.Position - LastMousePosition
			LastMousePosition = Input.Position

			local Camera = Viewport.Camera
			local Yaw = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -Delta.X * 0.02)
			Camera.CFrame = CFrame.new(Pivot) * Yaw * CFrame.new(-Pivot) * Camera.CFrame

			local Pitch = CFrame.fromAxisAngle(Camera.CFrame.RightVector, -Delta.Y * 0.02)
			local Pitched = CFrame.new(Pivot) * Pitch * CFrame.new(-Pivot) * Camera.CFrame
			if Pitched.UpVector.Y > 0.1 then
				Camera.CFrame = Pitched
			end
		end)

		Creator.AddSignal(ViewportFrame.InputChanged, function(Input)
			if Viewport.Interactive and Input.UserInputType == Enum.UserInputType.MouseWheel then
				Zoom(Input.Position.Z * 2)
			end
		end)

		Creator.AddSignal(UserInputService.TouchPinch, function(TouchPositions, _, _, State)
			if not Viewport.Interactive then return end
			if State == Enum.UserInputState.Begin then
				local Midpoint = (TouchPositions[1] + TouchPositions[2]) / 2
				if not IsPositionInViewport(Midpoint) then return end
				IsPinching = true
				IsDragging = false
				LastPinchDistance = (TouchPositions[1] - TouchPositions[2]).Magnitude
			elseif State == Enum.UserInputState.Change then
				if not IsPinching then return end
				local CurrentDistance = (TouchPositions[1] - TouchPositions[2]).Magnitude
				Zoom((CurrentDistance - LastPinchDistance) * 0.03)
				LastPinchDistance = CurrentDistance
			elseif State == Enum.UserInputState.End or State == Enum.UserInputState.Cancel then
				IsPinching = false
			end
		end)

		local function FocusCamera()
			local Object = Viewport.Object
			if not Object then return end

			local Size
			if Object:IsA("BasePart") then
				Size = Object.Size
			elseif Object:IsA("Model") then
				Size = select(2, Object:GetBoundingBox())
			else
				return
			end

			local Extent = math.max(Size.X, Size.Y, Size.Z)
			local Pivot = Object:GetPivot().Position
			Viewport.Camera.CFrame = CFrame.lookAt(Pivot + Vector3.new(0, Extent / 2, Extent * 2), Pivot)
			UpdateZoomValue()
		end

		function Viewport:SetObject(NewObject, Clone)
			if Clone and NewObject then
				local WasArchivable = NewObject.Archivable
				NewObject.Archivable = true
				local Copy = NewObject:Clone()
				NewObject.Archivable = WasArchivable
				NewObject = Copy
			end
			if Viewport.Object then
				Viewport.Object:Destroy()
			end
			Viewport.Object = NewObject
			if NewObject then
				NewObject.Parent = ViewportFrame
				if Viewport.Focused then
					FocusCamera()
				end
			end
		end

		function Viewport:SetModel(Model)
			Viewport:SetObject(Model, true)
		end

		function Viewport:SetHeight(NewHeight)
			Viewport.Height = NewHeight
			AspectRatio = nil
			HolderFrame.Size = UDim2.new(1, OffsetX, 0, NewHeight)
		end

		function Viewport:SetAspectRatio(Ratio)
			AspectRatio = ParseAspectRatio(Ratio)
			if AspectRatio then
				RecalculateAspect()
			else
				HolderFrame.Size = UDim2.new(1, OffsetX, 0, Viewport.Height)
			end
		end

		function Viewport:Focus()
			FocusCamera()
		end

		function Viewport:SetCamera(NewCamera)
			Viewport.Camera = NewCamera
			ViewportFrame.CurrentCamera = NewCamera
		end

		function Viewport:SetInteractive(Value)
			Viewport.Interactive = Value
			ViewportFrame.Active = Value
		end

		function Viewport:SetValue(Distance)
			if type(Distance) ~= "number" then return end
			local Pivot = GetPivot()
			if not Pivot then return end
			local Direction = Viewport.Camera.CFrame.Position - Pivot
			if Direction.Magnitude < 1e-4 then
				Direction = Vector3.new(0, 0, 1)
			end
			Viewport.Camera.CFrame = CFrame.lookAt(Pivot + Direction.Unit * Distance, Pivot)
			Viewport.Value = Distance
		end

		function Viewport:SetAmbient(Color)
			Viewport.Ambient = Color
			ViewportFrame.Ambient = Color
		end

		function Viewport:SetLightColor(Color)
			Viewport.LightColor = Color
			ViewportFrame.LightColor = Color
		end

		function Viewport:SetLightDirection(Direction)
			Viewport.LightDirection = Direction
			ViewportFrame.LightDirection = Direction
		end

		function Viewport:SetImage(Image)
			task.spawn(ApplyImage, Image)
		end

		function Viewport:SetImageTransparency(Value)
			Background.ImageTransparency = Value
		end

		function Viewport:SetBackgroundColor(Color)
			Background.BackgroundColor3 = Color
		end

		function Viewport:Destroy()
			HolderFrame:Destroy()
		end

		Viewport.Frame = HolderFrame

		Creator.AttachLock(HolderFrame, Config.Locked, { Radius = Radius }).Bind(Viewport)

		if Config.Object then
			Viewport:SetObject(Config.Object, Config.Clone)
		end

		if SaveIndex and Library.Options then
			Library.Options[SaveIndex] = Viewport
		end

		return Viewport
	end

	return Element
end)()

ElementsTable.Space = (function()
	local New = Creator.New

	local Element = {}
	Element.__index = Element
	Element.__type = "Space"

	local function ParseHeight(Height)
		local Parsed = tonumber(Height)
		if Parsed and Parsed >= 0 then
			return Parsed
		end
		return 8
	end

	function Element:New(Config)
		Config = Config or {}
		local Parent = self.Container
		if not Parent then
			return
		end

		local Height = ParseHeight(Config.Height)

		local Wrap = New("Frame", {
			Name = "SpaceElement",
			Size = UDim2.new(1, 0, 0, Height),
			BackgroundTransparency = 1,
			LayoutOrder = Config.LayoutOrder or 0,
			Parent = Parent,
		})

		local Space = { Frame = Wrap, Type = "Space" }

		function Space:SetHeight(NewHeight)
			Height = ParseHeight(NewHeight)
			Wrap.Size = UDim2.new(1, 0, 0, Height)
		end

		function Space:Destroy()
			Wrap:Destroy()
		end

		return Space
	end

	return Element
end)()

ElementsTable.Group = (function()
	local New = Creator.New

	local Element = {}
	Element.__index = Element
	Element.__type = "Group"

	function Element:New(Config)
		Config = Config or {}
		local Parent = self.Container
		if not Parent then
			return
		end

		local Gap = Config.Gap or 6
		local Columns = math.max(Config.Columns or 2, 1)

		local OuterWrap = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			LayoutOrder = Config.LayoutOrder or 0,
			Parent = Parent,
		})

		New("UIPadding", {
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 2),
			Parent = OuterWrap,
		})

		local InnerWrap = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			Parent = OuterWrap,
		})

		local TotalGap = Gap * (Columns - 1)
		local ColumnScale = 1 / Columns
		local ColumnOffset = -math.floor(TotalGap / Columns + 0.5)

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, Gap),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = InnerWrap,
		})

		local Group = {
			Frame = OuterWrap,
			Container = OuterWrap,
			Type = "Group",
			ScrollFrame = self.ScrollFrame,
			Library = self.Library,
			Elements = {},
		}

		Creator.AttachLock(OuterWrap, Config.Locked).Bind(Group)

		function Group:AddElement()
			local ElementFrame = New("Frame", {
				Size = UDim2.new(ColumnScale, ColumnOffset, 0, 0),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				Parent = InnerWrap,
			})

			New("UIListLayout", {
				Padding = UDim.new(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = ElementFrame,
			})

			local ColumnGroup = setmetatable({
				Container = ElementFrame,
				Type = Group.Type,
				ScrollFrame = Group.ScrollFrame,
				Library = Group.Library,
			}, Elements)

			table.insert(Group.Elements, { Frame = ElementFrame, Group = ColumnGroup })
			return ColumnGroup
		end

		function Group:Destroy()
			OuterWrap:Destroy()
		end

		return Group
	end

	return Element
end)()

ElementsTable.HStack = (function()
	local New = Creator.New

	local Element = {}
	Element.__index = Element
	Element.__type = "HStack"

	function Element:New(Config)
		Config = Config or {}
		local Parent = self.Container
		if not Parent then
			return
		end

		local Gap = Config.Gap or 6

		local OuterWrap = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			LayoutOrder = Config.LayoutOrder or 0,
			Parent = Parent,
		})

		New("UIPadding", {
			PaddingTop = UDim.new(0, 2),
			PaddingBottom = UDim.new(0, 2),
			Parent = OuterWrap,
		})

		local InnerRow = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			Parent = OuterWrap,
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, Gap),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = InnerRow,
		})

		local Columns = {}

		local function RecalcColumns()
			local Count = #Columns
			if Count == 0 then
				return
			end
			local Slots = math.max(Count, 2)
			local TotalGap = Gap * (Slots - 1)
			local ColumnScale = 1 / Slots
			local ColumnOffset = -math.floor(TotalGap / Slots + 0.5)

			for _, Column in ipairs(Columns) do
				Column.Size = UDim2.new(ColumnScale, ColumnOffset, 0, 0)
			end
		end

		local HStack = {
			Frame = OuterWrap,
			Container = OuterWrap,
			Type = "HStack",
			ScrollFrame = self.ScrollFrame,
			Library = self.Library,
			_elementCount = 0,
		}

		Creator.AttachLock(OuterWrap, Config.Locked).Bind(HStack)

		function HStack:AddVStack(Config2)
			Config2 = Config2 or {}
			local ColumnGap = Config2.Gap or Gap

			local ColumnFrame = New("Frame", {
				Size = UDim2.new(0.5, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				Parent = InnerRow,
			})

			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, ColumnGap),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = ColumnFrame,
			})

			table.insert(Columns, ColumnFrame)
			RecalcColumns()

			local ColumnGroup = setmetatable({
				Frame = ColumnFrame,
				Container = ColumnFrame,
				Type = "VStack",
				ScrollFrame = HStack.ScrollFrame,
				Library = HStack.Library,
				_elementCount = 0,
			}, Elements)

			return ColumnGroup
		end
		HStack.AddVerticalGroup = HStack.AddVStack

		setmetatable(HStack, {
			__index = function(_, Key)
				local Generic = Elements[Key]
				if type(Generic) == "function" then
					return function(Caller, ...)
						local Column = Caller:AddVStack()
						return Generic(Column, ...)
					end
				end
				return Generic
			end,
		})

		return HStack
	end

	return Element
end)()

ElementsTable.VStack = (function()
	local New = Creator.New

	local Element = {}
	Element.__index = Element
	Element.__type = "VStack"

	function Element:New(Config)
		Config = Config or {}
		local Parent = self.Container
		if not Parent then
			return
		end

		local Gap = Config.Gap or 6

		local LockHost = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			LayoutOrder = Config.LayoutOrder or 0,
			Parent = Parent,
		})

		local OuterWrap = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			Parent = LockHost,
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 4),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = OuterWrap,
		})

		local TitleLabel = New("TextLabel", {
			Name = "VStackTitle",
			FontFace = Font.new(Library.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			Text = Config.Title or "",
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, 0, 0, 14),
			BackgroundTransparency = 1,
			Visible = Config.Title ~= nil and Config.Title ~= "",
			LayoutOrder = -2,
			Parent = OuterWrap,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		local DescLabel = New("TextLabel", {
			Name = "VStackDesc",
			FontFace = Font.new(Library.Font),
			Text = Config.Description or "",
			TextSize = 12,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
			Visible = Config.Description ~= nil and Config.Description ~= "",
			LayoutOrder = -1,
			Parent = OuterWrap,
			ThemeTag = {
				TextColor3 = "SubText",
			},
		})

		local ContentHolder = New("Frame", {
			Name = "VStackContent",
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			LayoutOrder = 0,
			Parent = OuterWrap,
		})

		New("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, Gap),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = ContentHolder,
		})

		local VStack = setmetatable({
			Frame = LockHost,
			Container = ContentHolder,
			Type = "VStack",
			ScrollFrame = self.ScrollFrame,
			Library = self.Library,
			_elementCount = 0,
			TitleLabel = TitleLabel,
			DescLabel = DescLabel,
		}, Elements)

		Creator.AttachTitleDesc(VStack, TitleLabel, DescLabel)

		Creator.AttachLock(LockHost, Config.Locked).Bind(VStack)

		return VStack
	end

	return Element
end)()

ElementsTable.Divider = (function()
	local New = Creator.New

	local Element = {}
	Element.__index = Element
	Element.__type = "Divider"

	function Element:New(Idx, Config)
		if type(Idx) == "table" and Config == nil then
			Config = Idx
		end
		if type(Config) ~= "table" then
			Config = {}
		end

		local Parent = self.Container
		if not Parent then
			return
		end

		local Library = self.Library
		local Text = Config.Text and tostring(Config.Text) or ""
		local Height = tonumber(Config.Height) or (Text ~= "" and 26 or 14)
		local Thickness = math.max(tonumber(Config.Thickness) or 1, 1)
		local LineTransparency = tonumber(Config.Transparency) or 0.82
		local Gap = tonumber(Config.Gap) or 10

		local Divider = { Type = "Divider" }

		local Wrap = New("Frame", {
			Name = "DividerElement",
			Size = UDim2.new(1, 0, 0, Height),
			BackgroundTransparency = 1,
			LayoutOrder = Config.LayoutOrder or 0,
			Parent = Parent,
		})

		local Left = New("Frame", {
			Name = "LineLeft",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.new(1, 0, 0, Thickness),
			BackgroundTransparency = LineTransparency,
			BorderSizePixel = 0,
			Parent = Wrap,
			ThemeTag = {
				BackgroundColor3 = "Text",
			},
		})

		local Right = New("Frame", {
			Name = "LineRight",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.fromScale(1, 0.5),
			Size = UDim2.new(0.5, 0, 0, Thickness),
			BackgroundTransparency = LineTransparency,
			BorderSizePixel = 0,
			Visible = false,
			Parent = Wrap,
			ThemeTag = {
				BackgroundColor3 = "Text",
			},
		})

		local Label = New("TextLabel", {
			Name = "DividerText",
			FontFace = Font.new(Library.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			Text = Text,
			TextSize = 12,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, 14),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			Visible = Text ~= "",
			Parent = Wrap,
			ThemeTag = {
				TextColor3 = "SubText",
			},
		})

		local function Update()
			if Label.Text == "" then
				Label.Visible = false
				Right.Visible = false
				Left.Size = UDim2.new(1, 0, 0, Thickness)
				return
			end

			Label.Visible = true
			Right.Visible = true
			local Half = Label.AbsoluteSize.X / 2 + Gap
			Left.Size = UDim2.new(0.5, -Half, 0, Thickness)
			Right.Size = UDim2.new(0.5, -Half, 0, Thickness)
		end

		Creator.AddSignal(Label:GetPropertyChangedSignal("AbsoluteSize"), Update)
		Update()
		task.defer(Update)

		Divider.Frame = Wrap
		Divider.Label = Label

		function Divider:SetText(NewText)
			Label.Text = NewText and tostring(NewText) or ""
			Update()
		end

		function Divider:SetVisible(State)
			Wrap.Visible = State and true or false
		end

		function Divider:Destroy()
			Wrap:Destroy()
		end

		return Divider
	end

	return Element
end)()

local IconCache = {}

local IconURLsFlat = {
	lucide = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/lucide/dist/Icons.lua",
	solar = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/solar/dist/Icons.lua",
	gravity = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/gravity/dist/Icons.lua",
	hero = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/hero/dist/Icons.lua",
	feather = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/Feather/dist/Icons.lua",
	sfsymbols = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/sfsymbols/dist/Icons.lua",
	geist = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/geist/dist/Icons.lua",
}

local IconURLsSprite = {
	tabler = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/Tabler/dist/Icons.lua",
	phosphor = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/Phosphor/dist/Icons.lua",
	bootstrap = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/Bootstrap/dist/Icons.lua",
	craft = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/craft/dist/Icons.lua",
	prime = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/prime/dist/Icons.lua",
	pixelart = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/PixelArtsIcons/dist/Icons.lua",
}

local MaterialBase = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/Material/dist/"

local function MakeMaterialUrls(style, counts)
	local urls = {}
	for _, size in next, { "18", "24", "36", "48" } do
		urls[size] = {}
		for i = 1, counts do
			table.insert(urls[size], MaterialBase .. style .. size .. "Part" .. i .. ".lua")
		end
	end
	return urls
end

local MaterialVariantUrls = {
	default  = MakeMaterialUrls("Default",  4),
	outlined = MakeMaterialUrls("Outlined", 2),
	round    = MakeMaterialUrls("Round",    2),
	sharp    = MakeMaterialUrls("Sharp",    2),
	twotone  = MakeMaterialUrls("Twotone",  2),
}

local IconVariants = {
	fluent = { DefaultVariant = "filled",  filled = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/Fluent/dist/Variant/Filled/Icons.lua",  outlined = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/Fluent/dist/Variant/Outlined/Icons.lua" },
	mynaui = { DefaultVariant = "solid",   solid = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/MynaUi/dist/Variant/Solid/Icons.lua",   regular = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/MynaUi/dist/Variant/Regular/Icons.lua" },
	weui = { DefaultVariant = "filled",  filled = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/WeUi/dist/Variant/Filled/Icons.lua",    outlined = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/WeUi/dist/Variant/Outlined/Icons.lua" },
}
IconVariants.material = setmetatable({ DefaultVariant = "default" }, {
	__index = function(_, key)
		local k = key:lower():gsub("[ -]", "")
		if k == "twotone" or k == "two tone" then k = "twotone" end
		return MaterialVariantUrls[k]
	end,
})

local function LoadOnePart(url)
	local ok, raw = pcall(game.HttpGet, game, url, true)
	if not ok or not raw then return nil end
	local chunk = loadstring(raw)
	if not chunk then return nil end
	local ok2, result = pcall(chunk)
	if not ok2 or type(result) ~= "table" then return nil end
	return result
end

local function LoadIconSource(cacheKey, url)
	if IconCache[cacheKey] then return IconCache[cacheKey] end

	if type(url) == "table" then
		local merged = {}
		for _, partUrl in next, url do
			local result = LoadOnePart(partUrl)
			if result then
				for k, v in next, result do
					merged[k] = v
				end
			end
		end
		IconCache[cacheKey] = merged
		return merged
	end

	local raw = game:HttpGet(url, true)
	local patched = raw:gsub("\n(%s*)([%a][%w%-_]*)%s*=%s*%{", function(indent, key)
		if key == "return" or key == "Icons" or key == "Spritesheets" then
			return "\n" .. indent .. key .. " = {"
		end
		return "\n" .. indent .. '["' .. key .. '"] = {'
	end)
	local ok, result = pcall(loadstring(patched))
	if not ok then
		warn("[Icons] Failed to load '" .. cacheKey .. "': " .. tostring(result))
		return nil
	end
	if result and result.Icons then
		IconCache[cacheKey] = { _sprites = result.Spritesheets or {}, _icons = result.Icons }
	else
		IconCache[cacheKey] = result
	end
	return IconCache[cacheKey]
end

local function ResolveSpritesheetEntry(entry, sprites)
	local sheetId = sprites[tostring(entry.Image)] or sprites[entry.Image] or tostring(entry.Image or "")
	local offset = entry.ImageRectOffset or entry.ImageRectPosition or Vector2.new(0, 0)
	local size = entry.ImageRectSize or Vector2.new(0, 0)
	return { Image = sheetId, ImageRectOffset = offset, ImageRectSize = size }
end

local function ToPascalKebab(s)
	return (s:gsub("(%a)([^%-_]*)", function(first, rest)
		return first:upper() .. rest
	end))
end

local function LookupInSource(src, iconName)
	if src._icons then
		local entry = src._icons[iconName]
		if not entry then return nil end
		return ResolveSpritesheetEntry(entry, src._sprites)
	end
	local val = src[iconName]
	if val == nil then val = src[ToPascalKebab(iconName)] end
	if type(val) == "table" and val.Image then
		return {
			Image = tostring(val.Image),
			ImageRectOffset = val.ImageRectOffset or Vector2.new(0, 0),
			ImageRectSize = val.ImageRectSize or Vector2.new(0, 0),
		}
	end
	if type(val) == "string" then
		return { Image = val, ImageRectOffset = Vector2.new(0, 0), ImageRectSize = Vector2.new(0, 0) }
	end
	return nil
end

local NotificationModule = Components.Notification
local ToastModule = Components.Toast
ToastModule:Init(GUI)
NotificationModule:Init(GUI)

function Library:GetIcon(Name)
	if Name == nil or Name == "" then return nil end

	if type(Name) == "string" and (Name:match("^rbxassetid://") or Name:match("^rbxasset://")) then
		return { Image = Name, ImageRectOffset = Vector2.zero, ImageRectSize = Vector2.zero }
	end

	local segments = {}
	for seg in Name:gmatch("[^/]+") do
		table.insert(segments, seg)
	end

	if #segments == 0 then return nil end

	local pack = segments[1]:lower()

	if #segments >= 3 then
		local variantInfo = IconVariants[pack]
		if variantInfo then
			local rawVariant = segments[2]:lower()
			local iconName = table.concat(segments, "/", 3)
			local urlOrTable = variantInfo[rawVariant]
			if not urlOrTable then return nil end
			if type(urlOrTable) == "table" and not urlOrTable[1] then
				local sizeKey = segments[3]:gsub("[^%d]", "")
				if sizeKey ~= "" and #segments >= 4 then
					local parts = urlOrTable[sizeKey]
					if not parts then return nil end
					local iName = table.concat(segments, "/", 4)
					local cacheKey = pack .. ":" .. rawVariant .. ":" .. sizeKey
					local src = LoadIconSource(cacheKey, parts)
					if not src then return nil end
					return LookupInSource(src, iName)
				end
				local parts = urlOrTable["18"]
				if not parts then return nil end
				local cacheKey = pack .. ":" .. rawVariant .. ":18"
				local src = LoadIconSource(cacheKey, parts)
				if not src then return nil end
				return LookupInSource(src, iconName)
			end
			local cacheKey = pack .. ":" .. rawVariant
			local src = LoadIconSource(cacheKey, urlOrTable)
			if not src then return nil end
			return LookupInSource(src, iconName)
		end
	end

	if #segments >= 2 then
		local iconName = table.concat(segments, "/", 2)
		local variantInfo = IconVariants[pack]
		if variantInfo then
			local defVariant = variantInfo.DefaultVariant
			local urlOrTable = variantInfo[defVariant]
			if type(urlOrTable) == "table" and not urlOrTable[1] then
				local parts = urlOrTable["18"]
				if not parts then return nil end
				local cacheKey = pack .. ":" .. defVariant .. ":18"
				local src = LoadIconSource(cacheKey, parts)
				if not src then return nil end
				return LookupInSource(src, iconName)
			end
			local cacheKey = pack .. ":" .. defVariant
			local src = LoadIconSource(cacheKey, urlOrTable)
			if not src then return nil end
			return LookupInSource(src, iconName)
		end

		local flatUrl = IconURLsFlat[pack]
		if flatUrl then
			local src = LoadIconSource(pack, flatUrl)
			if not src then return nil end
			return LookupInSource(src, iconName)
		end

		local spriteUrl = IconURLsSprite[pack]
		if spriteUrl then
			local src = LoadIconSource(pack, spriteUrl)
			if not src then return nil end
			return LookupInSource(src, iconName)
		end

		return nil
	end

	local src = LoadIconSource("lucide", IconURLsFlat.lucide)
	if not src then return nil end
	local val = src[Name] or src["lucide-" .. Name]
	if type(val) == "string" then
		return { Image = val, ImageRectOffset = Vector2.new(0, 0), ImageRectSize = Vector2.new(0, 0) }
	end
	return nil
end

Elements = {}
Elements.__index = Elements
Elements.__namecall = function(Table, Key, ...)
	return Elements[Key](...)
end

for _, ElementComponent in pairs(ElementsTable) do
	local AddMethod = function(self, Idx, Config)
		ElementComponent.Container = self.Container
		ElementComponent.Type = self.Type
		ElementComponent.ScrollFrame = self.ScrollFrame
		ElementComponent.Library = Library

		local resolvedConfig = Config
		if resolvedConfig == nil and type(Idx) == "table" then
			resolvedConfig = Idx
		end

		if ElementComponent.__type == "Divider" and type(resolvedConfig) ~= "table" then
			resolvedConfig = { Text = type(Idx) == "string" and Idx or nil }
			Idx, Config = resolvedConfig, nil
		end

		if type(resolvedConfig) == "table" and not resolvedConfig.LayoutOrder then
			self._layoutOrder = (self._layoutOrder or 0) + 1
			resolvedConfig.LayoutOrder = self._layoutOrder
		end

		return ElementComponent:New(Idx, Config)
	end

	Elements["Add" .. ElementComponent.__type] = AddMethod
	Elements[ElementComponent.__type] = AddMethod
end

Elements.Switch = Elements.Toggle
Elements.AddSwitch = Elements.AddToggle
Elements.EmptyFrame = Elements.Space
Elements.AddEmptyFrame = Elements.AddSpace
Elements.ViewportFrame = Elements.Viewport
Elements.AddViewportFrame = Elements.AddViewport

Library.Elements = Elements

function Library:CreateWindow(Config)
	assert(Config.Title, "Window - Missing Title")

	if Library.Window then
		print("You cannot create more than one window.")
		return
	end

	Library.MinimizeKey = Config.MinimizeKey or Enum.KeyCode.LeftControl
	Library.UseAcrylic = Config.Acrylic or false
	Library.Acrylic = Config.Acrylic or false
	Library.Theme = Config.Theme or "Dark"
	if Config.Acrylic then
		Acrylic.init()
	end

	Library.NewVisual = Config.NewVisual == true

	local Window = Components.Window({
		Parent = GUI,
		Size = Config.Size,
		Title = Config.Title,
		SubTitle = Config.SubTitle,
		TabWidth = Config.TabWidth,
		Search = Config.Search,
		UserInfo = Config.UserInfo,
		NewVisual = Library.NewVisual,
	})

	Library.Window = Window
	Library:SetTheme(Config.Theme)

	if Config.Font then
		Library:SetFont(Config.Font)
	end
	if Config.Transparency ~= nil then
		local Transparency = Config.Transparency
		if type(Transparency) == "number" and Transparency > 1 then
			Transparency = Transparency / 100
		end
		Library:SetTransparency(Transparency)
	end
	if Config.ShowUserInfo ~= nil then
		Library:ToggleUserInfo(Config.ShowUserInfo)
	end
	if Config.SeasonalHats ~= nil then
		Library:SetSeasonalHat(Config.SeasonalHats)
	end
	if Config.DisableBackground ~= nil then
		Library.DisableBackground = Config.DisableBackground
	end
	if Config.KeepWindowInsideFrame ~= nil then
		Library:ToggleKeepWindowInsideFrame(Config.KeepWindowInsideFrame)
	end

	return Window
end

function Library:SetTheme(Value)
	if not Library.Window then return end
	if type(Value) == "table" then
		Library.Theme = Value.Name or "Custom"
		Library.CustomThemeData = Value
		Creator.UpdateTheme()
	elseif table.find(Library.Themes, Value) then
		Library.Theme = Value
		Library.CustomThemeData = nil
		Creator.UpdateTheme()
	end
end

local OriginalThemes = {}

for _, ThemeName in ipairs(Themes.Names) do
	OriginalThemes[ThemeName] = Themes[ThemeName]
end

Library.ThemeOverrides = {}
Library.PendingOverrides = {}

function Library:OverrideTheme(Name, Data)
	local Original = OriginalThemes[Name]
	if not Original then
		Library.PendingOverrides[Name] = Data
		return nil
	end

	local Theme = {}
	for Key, Value in next, Original do
		Theme[Key] = Value
	end
	for Key, Value in next, Data do
		Theme[Key] = Value
	end
	Theme.Name = Name

	Themes[Name] = Theme
	Library.ThemeOverrides[Name] = true

	if Library.Window and Library.Theme == Name and not Library.CustomThemeData then
		Creator.UpdateTheme()
	end
	if Library.OnThemeAdded then
		Library.OnThemeAdded(Name)
	end

	return Theme
end

function Library:ResetTheme(Name)
	local Original = OriginalThemes[Name]
	Library.PendingOverrides[Name] = nil
	if not Original then
		return nil
	end

	Themes[Name] = Original
	Library.ThemeOverrides[Name] = nil

	if Library.Window and Library.Theme == Name and not Library.CustomThemeData then
		Creator.UpdateTheme()
	end
	if Library.OnThemeAdded then
		Library.OnThemeAdded(Name)
	end

	return Original
end

function Library:AddTheme(Data)
	assert(type(Data) == "table" and type(Data.Name) == "string", "AddTheme - Missing Name")
	assert(Data.Name ~= "Names", "AddTheme - Invalid Name")

	local Theme = {}
	for Key, Value in next, Themes[Data.Base or "Dark"] or Themes.Dark do
		Theme[Key] = Value
	end
	for Key, Value in next, Data do
		Theme[Key] = Value
	end

	Themes[Data.Name] = Theme
	OriginalThemes[Data.Name] = Theme
	Library.ThemeOverrides[Data.Name] = nil

	if not table.find(Themes.Names, Data.Name) then
		table.insert(Themes.Names, Data.Name)
	end

	local Pending = Library.PendingOverrides[Data.Name]
	if Pending then
		Library.PendingOverrides[Data.Name] = nil
		Library:OverrideTheme(Data.Name, Pending)
		return Themes[Data.Name]
	end

	if Library.Window and Library.Theme == Data.Name and not Library.CustomThemeData then
		Creator.UpdateTheme()
	end

	if Library.OnThemeAdded then
		Library.OnThemeAdded(Data.Name)
	end

	return Theme
end

function Library:SetFont(fontAsset)
	Library.Font = fontAsset
	Creator.UpdateFont()
end

Library.AddedFonts = {}

local FontWeightLookup = {
	thin = "Thin", extralight = "ExtraLight", light = "Light", regular = "Regular", medium = "Medium",
	semibold = "SemiBold", bold = "Bold", extrabold = "ExtraBold", heavy = "Heavy",
	[100] = "Thin", [200] = "ExtraLight", [300] = "Light", [400] = "Regular", [500] = "Medium",
	[600] = "SemiBold", [700] = "Bold", [800] = "ExtraBold", [900] = "Heavy",
}

function Library:AddFont(Data)
	assert(type(Data) == "table" and type(Data.Name) == "string" and Data.Name:match("%S"), "AddFont - Missing Name")

	local Source = Data.AssetId or Data.Asset or Data.Source
	assert(Source ~= nil and tostring(Source):match("%S"), "AddFont - Missing AssetId")

	local WeightKey = Data.Weight
	if type(WeightKey) == "string" then
		WeightKey = tonumber(WeightKey) or WeightKey:lower()
	end

	local Entry = {
		Name = Data.Name:match("^%s*(.-)%s*$"),
		Weight = FontWeightLookup[WeightKey] or "Regular",
		Style = tostring(Data.Style or ""):lower() == "italic" and "Italic" or "Normal",
		AssetId = tostring(Source),
		Select = Data.Select == true,
	}

	local Replaced = false
	for Index, Existing in ipairs(Library.AddedFonts) do
		if Existing.Name == Entry.Name then
			Library.AddedFonts[Index] = Entry
			Replaced = true
			break
		end
	end
	if not Replaced then
		table.insert(Library.AddedFonts, Entry)
	end

	if Library.OnFontAdded then
		Library.OnFontAdded(Entry)
	end

	return Entry
end

function Library:Destroy()
	if Library.Window then
		Library.Unloaded = true
		if Library.UseAcrylic then
			Library.Window.AcrylicPaint.Model:Destroy()
		end
		Creator.Disconnect()
		Library.GUI:Destroy()
	end
end

function Library:ToggleAcrylic(Value)
	if Library.Window then
		if Library.UseAcrylic then
			Library.Acrylic = Value
			Library.Window.AcrylicPaint.Model.Transparency = Value and 0.98 or 1
			if Value then
				Acrylic.Enable()
			else
				Acrylic.Disable()
			end
		end
	end
end

function Library:SetTransparency(Value)
	if type(Value) == "boolean" then
		Value = Value and 0.35 or 0
	end
	Value = math.clamp(tonumber(Value) or 0, 0, 1)
	Library.Transparency = Value
	if Library.Window then
		Library.Window.AcrylicPaint.Frame.Background.BackgroundTransparency = Value
	end
end

function Library:ToggleTransparency(Value)
	Library:SetTransparency(Value)
end

function Library:SetSeasonalHat(Value)
	Library.SeasonalHats.Enabled = Value == true
	Creator.RefreshHats()
end

function Library:SetSeasonalHatEvent(Name)
	Library.SeasonalHats.Force = Name
	Creator.RefreshHats()
end

function Library:ToggleUserInfo(Value)
	if Library.Window and Library.Window.UserInfoFrame then
		Library.Window.UserInfoFrame.Visible = Value
	end
end

function Library:ToggleKeepWindowInsideFrame(Value)
	Library.KeepWindowInsideFrame = Value
end

function Library:SetBoundaryMargin(Value)
	Library.BoundaryMargin = Value or 0
	if Library.Window and Library.Window.RefreshBoundary then
		Library.Window.RefreshBoundary()
	end
end

function Library:SetBoundaryInset(Inset)
	Inset = Inset or {}
	Library.BoundaryInset = {
		Top = Inset.Top or 0,
		Bottom = Inset.Bottom or 0,
		Left = Inset.Left or 0,
		Right = Inset.Right or 0,
	}
	if Library.Window and Library.Window.RefreshBoundary then
		Library.Window.RefreshBoundary()
	end
end

local MediaCache = {
	DefaultFolder = "FluentReimaginedCache",
	Folder = nil,
}

function MediaCache:GetFolder()
	return self.Folder or self.DefaultFolder
end

function MediaCache:SetFolder(Folder)
	self.Folder = Folder
	self:EnsureFolder()
end

function MediaCache:EnsureFolder()
	local Path = ""
	for Part in self:GetFolder():gmatch("[^/]+") do
		Path = Path == "" and Part or (Path .. "/" .. Part)
		if not isfolder(Path) then
			makefolder(Path)
		end
	end
end

function MediaCache:Download(Url, Extension)
	local Success, Result = pcall(function()
		self:EnsureFolder()

		local Hash = 0
		for Index = 1, #Url do
			Hash = (Hash * 31 + string.byte(Url, Index)) % 1000000007
		end

		local Path = self:GetFolder() .. "/" .. tostring(Hash) .. Extension
		if isfile(Path) and #readfile(Path) == 0 then
			delfile(Path)
		end
		if not isfile(Path) then
			writefile(Path, game:HttpGet(Url))
		end

		return Path
	end)

	if Success then
		return Result
	end

	warn("[MediaCache] Failed to download: " .. Url)
	return nil
end

Library.MediaCache = MediaCache

local backgroundImageCache = {}

function Library:CacheFile(Url, Extension)
	return MediaCache:Download(Url, Extension)
end

function Library:ResolveMedia(Input)
	if not Input or Input == "" then
		return ""
	end

	if
		Input:match("^rbxassetid://")
		or Input:match("^rbxasset://")
		or Input:match("^https?://www%.roblox%.com/asset")
	then
		return Input
	end

	if tonumber(Input) then
		return "rbxassetid://" .. Input
	end

	if isfile and getcustomasset then
		local Ok, Exists = pcall(isfile, Input)
		if Ok and Exists then
			local Loaded, Asset = pcall(getcustomasset, Input)
			if Loaded and Asset then
				return Asset
			end
			return "rbxasset://" .. Input
		end
	end

	if Input:match("^https?://") then
		if backgroundImageCache[Input] then
			return backgroundImageCache[Input]
		end

		local success, result = pcall(function()
			return getcustomasset(Library:CacheFile(Input, ".png"))
		end)

		if success and result then
			backgroundImageCache[Input] = result
			return result
		end

		warn("[Background] Failed to load image from URL: " .. Input)
		return ""
	end

	return Input
end


local backgroundAnimation
local backgroundLabels = {}
local backgroundToken = 0
local backgroundEditable
local backgroundKey
local backgroundReady = false
local backgroundDecoded = setmetatable({}, { __mode = "k" })

local Base64Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local Base64Lookup = table.create(128, 0)

for Index = 1, #Base64Alphabet do
	Base64Lookup[string.byte(Base64Alphabet, Index)] = Index - 1
end

local function DecodeBase64(Text)
	local Bytes = buffer.create(math.floor(#Text / 4) * 3)
	local Size = 0

	for Index = 1, #Text - 3, 4 do
		local A, B, C, D = string.byte(Text, Index, Index + 3)
		local Value = Base64Lookup[A] * 262144 + Base64Lookup[B] * 4096 + Base64Lookup[C] * 64 + Base64Lookup[D]
		buffer.writeu8(Bytes, Size, math.floor(Value / 65536))
		buffer.writeu8(Bytes, Size + 1, math.floor(Value / 256) % 256)
		buffer.writeu8(Bytes, Size + 2, Value % 256)
		Size = Size + 3
	end

	return Bytes, Size
end

local function DecodePaletteFrame(Text, Pixels, Palette, Previous)
	local Bytes, Size = DecodeBase64(Text)
	if Size == 0 then
		return nil
	end

	local Flag = buffer.readu8(Bytes, 0)
	local Output = buffer.create(Pixels * 4)

	if Flag == 1 then
		for Pixel = 0, Pixels - 1 do
			if Pixel + 1 >= Size then break end
			buffer.writeu32(Output, Pixel * 4, Palette[buffer.readu8(Bytes, Pixel + 1)])
		end
	elseif Flag == 2 and Previous then
		buffer.copy(Output, 0, Previous)
		local Pixel = 0
		local Read = 1

		while Pixel < Pixels and Read < Size do
			local Operation = buffer.readu8(Bytes, Read)
			Read = Read + 1

			if Operation < 128 then
				Pixel = Pixel + Operation + 1
			else
				for _ = 1, Operation - 127 do
					if Pixel < Pixels and Read < Size then
						buffer.writeu32(Output, Pixel * 4, Palette[buffer.readu8(Bytes, Read)])
					end
					Read = Read + 1
					Pixel = Pixel + 1
				end
			end
		end
	else
		return nil
	end

	return Output
end

local function DecodeFrame(Text, Pixels)
	local Bytes, Size = DecodeBase64(Text)

	if Size == 0 or buffer.readu8(Bytes, 0) ~= 1 then
		return nil
	end

	local Output = buffer.create(Pixels * 4)
	local Read = 1
	local Pixel = 0

	while Pixel < Pixels and Read + 2 < Size do
		local X = buffer.readu8(Bytes, Read)
		local Y = buffer.readu8(Bytes, Read + 1)
		local Z = buffer.readu8(Bytes, Read + 2)
		Read = Read + 3

		local Offset = Pixel * 4
		buffer.writeu8(Output, Offset, math.floor(X / 16) * 17)
		buffer.writeu8(Output, Offset + 1, (X % 16) * 17)
		buffer.writeu8(Output, Offset + 2, math.floor(Y / 16) * 17)
		buffer.writeu8(Output, Offset + 3, 255)
		Pixel = Pixel + 1

		if Pixel < Pixels then
			Offset = Pixel * 4
			buffer.writeu8(Output, Offset, (Y % 16) * 17)
			buffer.writeu8(Output, Offset + 1, math.floor(Z / 16) * 17)
			buffer.writeu8(Output, Offset + 2, (Z % 16) * 17)
			buffer.writeu8(Output, Offset + 3, 255)
			Pixel = Pixel + 1
		end
	end

	return Output
end

local function StopBackgroundAnimation()
	backgroundToken = backgroundToken + 1
	if backgroundAnimation then
		backgroundAnimation:Disconnect()
		backgroundAnimation = nil
	end
	if backgroundEditable then
		pcall(function()
			backgroundEditable:Destroy()
		end)
		backgroundEditable = nil
	end
	for _, Label in ipairs(backgroundLabels) do
		Label:Destroy()
	end
	backgroundLabels = {}
	backgroundKey = nil
	backgroundReady = false
end

function Library:UpdateBackground()
	if not Library.Window or not Library.Window.BackgroundImage then
		return
	end

	local backgroundImage = Library.Window.BackgroundImage
	local Background = Creator.GetThemeProperty("Background")
	local Transparency = Creator.GetThemeProperty("BackgroundTransparency")

	if Library.DisableBackground then
		StopBackgroundAnimation()
		backgroundImage.ImageTransparency = 1
		return
	end

	if backgroundKey ~= nil and backgroundKey == Background then
		if type(Background) == "table" then
			if backgroundReady then
				for _, Label in ipairs(backgroundLabels) do
					Label.ImageTransparency = Transparency
				end
			end
		else
			backgroundImage.ImageTransparency = Transparency
		end
		return
	end

	StopBackgroundAnimation()
	backgroundKey = Background

	if type(Background) ~= "table" then
		backgroundImage.ImageTransparency = Transparency
		backgroundImage.ImageRectOffset = Vector2.zero
		backgroundImage.ImageRectSize = Vector2.zero
		backgroundImage.Image = Library:ResolveMedia(Background)
		return
	end

	local Token = backgroundToken
	backgroundImage.Image = ""
	backgroundImage.ImageTransparency = 1

	local function Play(Decoded)
		local Created, Editable = pcall(function()
			return AssetService:CreateEditableImage({ Size = Vector2.new(Decoded.Width, Decoded.Height) })
		end)
		if not Created or not Editable then
			warn("[Background] EditableImage is not available in this environment")
			return
		end

		if Token ~= backgroundToken then
			Editable:Destroy()
			return
		end

		backgroundEditable = Editable

		local Buffers = Decoded.Buffers
		local Size = Vector2.new(Decoded.Width, Decoded.Height)
		Editable:WritePixelsBuffer(Vector2.zero, Size, Buffers[1])

		local FrameLabel = New("ImageLabel", {
			Name = "BackgroundFrames",
			ImageTransparency = Creator.GetThemeProperty("BackgroundTransparency"),
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Parent = backgroundImage,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		})

		backgroundLabels[1] = FrameLabel
		FrameLabel.ImageContent = Content.fromObject(Editable)
		backgroundReady = true

		local Index = 1
		local Elapsed = 0
		local Step = 1 / Decoded.FPS

		backgroundAnimation = RunService.Heartbeat:Connect(function(Delta)
			Elapsed = Elapsed + Delta
			if Elapsed < Step then return end
			Elapsed = Elapsed % Step
			Index = Index % #Buffers + 1
			if Buffers[Index] then
				Editable:WritePixelsBuffer(Vector2.zero, Size, Buffers[Index])
			end
		end)
	end

	local Cached = backgroundDecoded[Background]
	if Cached then
		Play(Cached)
		return
	end

	local FrameSource = Background.Source

	if not FrameSource and not (type(Background.Frames) == "table" and type(Background.Frames[1]) == "string") then
		warn("[Background] Unknown background table, use Source or Frames")
		return
	end

	task.spawn(function()
		local Data = Background

		if FrameSource then
			local Loaded, Result = pcall(function()
				local Path = FrameSource
				if Path:match("^https?://") then
					Path = Library:CacheFile(Path, ".lua")
				end
				return loadstring(readfile(Path))()
			end)
			if not Loaded or type(Result) ~= "table" then
				warn("[Background] Frame file could not be loaded: " .. tostring(FrameSource))
				return
			end
			Data = Result
		end

		local Frames = Data.Frames
		local Width = Background.Width or Data.Width
		local Height = Background.Height or Data.Height
		local FPS = Background.FPS or Data.FPS or 15

		if type(Frames) ~= "table" or #Frames == 0 or not Width or not Height then
			warn("[Background] Frame data needs Frames, Width and Height")
			return
		end

		local Pixels = Width * Height
		local PaletteData = Background.Palette or Data.Palette
		local Palette

		if PaletteData then
			Palette = table.create(256, 0)
			for Index = 0, 255 do
				Palette[Index] = (PaletteData[Index * 3 + 1] or 0)
					+ (PaletteData[Index * 3 + 2] or 0) * 256
					+ (PaletteData[Index * 3 + 3] or 0) * 65536
					+ 255 * 16777216
			end
		end

		local Buffers = {}
		local SliceStart = os.clock()

		for Index = 1, #Frames do
			if Token ~= backgroundToken then return end

			if Palette then
				Buffers[Index] = DecodePaletteFrame(Frames[Index], Pixels, Palette, Buffers[Index - 1])
			else
				Buffers[Index] = DecodeFrame(Frames[Index], Pixels)
			end

			if FrameSource then
				Frames[Index] = false
			end

			if os.clock() - SliceStart > 0.003 then
				task.wait()
				SliceStart = os.clock()
			end
		end

		if Token ~= backgroundToken then return end

		local Decoded = { Buffers = Buffers, Width = Width, Height = Height, FPS = FPS }
		backgroundDecoded[Background] = Decoded
		Play(Decoded)
	end)
end

function Library:ToggleBackground(Value)
	Library.DisableBackground = Value
	Library:UpdateBackground()
end

Creator.OnThemeChanged(function()
	Library:UpdateBackground()
end)

function Library:Notify(Config)
	return NotificationModule:New(Config)
end

function Library:Toast(Config)
	return ToastModule:New(Config)
end


local InterfaceManager = {} do
	InterfaceManager.Folder = "FluentReimaginedSettings"
	InterfaceManager.Settings = {
		Theme = "Dark",
		Font = "rbxasset://fonts/families/GothamSSm.json",
		Acrylic = true,
		Transparency = 35,
		MenuKeybind = "LeftControl",
		ShowUserInfo = true,
		DisableBackground = false,
		KeepWindowInsideFrame = true,
		ActiveCustomTheme = nil,
		SidePanels = {},
		WindowSize = nil,
	}

	local ThemeManager = {}

	local themePropertyKeys = {
		"Accent","AcrylicMain","AcrylicBorder","AcrylicBorderTransparency","AcrylicGradient","AcrylicGradientRotation","AcrylicGradientTransparency","AcrylicNoise",
		"Background","BackgroundTransparency","TitleBarLine","TitleBarLineTransparency","Tab","TabOverlay","ScrollBar",
		"Element","ElementBorder","ElementBorderTransparency","InElementBorder","InElementBorderTransparency","ElementTransparency",
		"ToggleSlider","ToggleToggled","SliderRail",
		"DropdownFrame","DropdownHolder","DropdownHolderRotation","DropdownHolderTransparency","DropdownBorder","DropdownBorderTransparency","DropdownOption",
		"Keybind","Input","InputFocused","InputIndicator",
		"Dialog","DialogHolder","DialogHolderRotation","DialogHolderTransparency","DialogHolderLine","DialogButton","DialogButtonBorder",
		"DialogBorder","DialogBorderTransparency","DialogInput","DialogInputLine","DialogInputFocused",
		"ColorpickerDialog","ColorpickerDialogBorder","ColorpickerHolder","ColorpickerHolderRotation","ColorpickerHolderTransparency","ColorpickerHolderLine",
		"ColorpickerButton","ColorpickerButtonBorder","ColorpickerInput","ColorpickerInputLine",
		"ColorpickerInputBorder","ColorpickerInputFocused",
		"MenuBackground","MenuBackgroundRotation","MenuBackgroundTransparency","MenuBorder","MenuBorderTransparency","MenuHolder","MenuHolderLine",
		"MenuButton","MenuButtonBorder","MenuInput","MenuInputLine","MenuInputFocused",
		"Text","SubText","Hover","HoverChange",
	}

	local colorFieldDefs = {
		{ key = "Accent", title = "Accent", description = "Primary accent color used across interactive elements." },
		{ key = "AcrylicMain", title = "Acrylic Main", description = "Base color of the acrylic window background." },
		{ key = "AcrylicBorder", transparency = "AcrylicBorderTransparency", title = "Acrylic Border", description = "Border color around the acrylic window." },
		{ key = "TitleBarLine", transparency = "TitleBarLineTransparency", title = "Title Bar Line", description = "Divider line under the title bar." },
		{ key = "Tab", title = "Tab", description = "Tab background color." },
		{ key = "TabOverlay", title = "Tab Overlay", description = "Overlay color behind the selected tab." },
		{ key = "ScrollBar", title = "Scroll Bar", description = "Scroll bar and scroll bar dot color." },
		{ key = "Element", transparency = "ElementTransparency", title = "Element", description = "Background color of elements." },
		{ key = "ElementBorder", transparency = "ElementBorderTransparency", title = "Element Border", description = "Border color of elements." },
		{ key = "InElementBorder", transparency = "InElementBorderTransparency", title = "Inner Element Border", description = "Border color inside elements." },
		{ key = "ToggleSlider", title = "Toggle Rail", description = "Toggle rail color when off." },
		{ key = "ToggleToggled", title = "Toggle Knob", description = "Toggle knob color when on." },
		{ key = "SliderRail", title = "Slider Rail", description = "Slider rail color." },
		{ key = "DropdownFrame", title = "Dropdown Frame", description = "Dropdown frame color." },
		{ key = "DropdownBorder", transparency = "DropdownBorderTransparency", title = "Dropdown Border", description = "Dropdown border color." },
		{ key = "DropdownOption", title = "Dropdown Option", description = "Dropdown option color." },
		{ key = "Keybind", title = "Keybind", description = "Keybind element color." },
		{ key = "Input", title = "Input", description = "Input field color." },
		{ key = "InputFocused", title = "Input Focused", description = "Input field color when focused." },
		{ key = "InputIndicator", title = "Input Indicator", description = "Input focus indicator color." },
		{ key = "Dialog", title = "Dialog", description = "Dialog background color." },
		{ key = "DialogHolderLine", title = "Dialog Holder Line", description = "Dialog holder divider line color." },
		{ key = "DialogButton", title = "Dialog Button", description = "Dialog button color." },
		{ key = "DialogButtonBorder", title = "Dialog Button Border", description = "Dialog button border color." },
		{ key = "DialogBorder", transparency = "DialogBorderTransparency", title = "Dialog Border", description = "Dialog border color." },
		{ key = "DialogInput", title = "Dialog Input", description = "Dialog input field color." },
		{ key = "DialogInputLine", title = "Dialog Input Line", description = "Dialog input focus line color." },
		{ key = "DialogInputFocused", title = "Dialog Input Focused", description = "Dialog input color when focused." },
		{ key = "ColorpickerDialog", title = "Colorpicker Dialog", description = "Colorpicker dialog background color." },
		{ key = "ColorpickerDialogBorder", title = "Colorpicker Dialog Border", description = "Colorpicker dialog border color." },
		{ key = "ColorpickerHolderLine", title = "Colorpicker Holder Line", description = "Colorpicker holder divider line color." },
		{ key = "ColorpickerButton", title = "Colorpicker Button", description = "Colorpicker button color." },
		{ key = "ColorpickerButtonBorder", title = "Colorpicker Button Border", description = "Colorpicker button border color." },
		{ key = "ColorpickerInput", title = "Colorpicker Input", description = "Colorpicker input field color." },
		{ key = "ColorpickerInputLine", title = "Colorpicker Input Line", description = "Colorpicker input focus line color." },
		{ key = "ColorpickerInputBorder", title = "Colorpicker Input Border", description = "Colorpicker input border color." },
		{ key = "ColorpickerInputFocused", title = "Colorpicker Input Focused", description = "Colorpicker input color when focused." },
		{ key = "MenuBorder", transparency = "MenuBorderTransparency", title = "Menu Border", description = "Border color of the menu." },
		{ key = "MenuHolder", title = "Menu Holder", description = "Background color of the menu button area." },
		{ key = "MenuHolderLine", title = "Menu Holder Line", description = "Divider line above the menu buttons." },
		{ key = "MenuButton", title = "Menu Button", description = "Menu button color." },
		{ key = "MenuButtonBorder", title = "Menu Button Border", description = "Menu button border color." },
		{ key = "MenuInput", title = "Menu Input", description = "Menu input field color." },
		{ key = "MenuInputLine", title = "Menu Input Line", description = "Menu input focus line color." },
		{ key = "MenuInputFocused", title = "Menu Input Focused", description = "Menu input color when focused." },
		{ key = "Text", title = "Text", description = "Primary text color." },
		{ key = "SubText", title = "SubText", description = "Secondary text color." },
		{ key = "Hover", title = "Hover", description = "Hover highlight color." },
	}

	local gradientFieldDefs = {
		{ key = "AcrylicGradient", after = "AcrylicBorder", title = "Acrylic Gradient", description = "Colors of the acrylic background gradient. Rotation controls its direction and Transparency controls how much of the acrylic shows through." },
		{ key = "DropdownHolder", after = "DropdownFrame", title = "Dropdown Holder", description = "Start and end color of the dropdown list background gradient. Rotation controls its direction." },
		{ key = "DialogHolder", after = "Dialog", title = "Dialog Holder", description = "Start and end color of the dialog holder background gradient. Rotation controls its direction." },
		{ key = "ColorpickerHolder", after = "ColorpickerDialogBorder", title = "Colorpicker Holder", description = "Start and end color of the colorpicker holder background gradient. Rotation controls its direction." },
		{ key = "MenuBackground", after = "MenuBorder", title = "Menu Background", description = "Start and end color of the menu background gradient. Rotation controls its direction." },
	}

	local themePanelOrder = {
		"Name",
		"Accent",
		"AcrylicMain",
		"AcrylicBorder",
		"AcrylicGradient",
		"AcrylicNoise",
		"Background",
		"BackgroundTransparency",
		"TitleBarLine",
		"Tab",
		"TabOverlay",
		"ScrollBar",
		"Element",
		"ElementBorder",
		"InElementBorder",
		"ToggleSlider",
		"ToggleToggled",
		"SliderRail",
		"DropdownFrame",
		"DropdownHolder",
		"DropdownBorder",
		"DropdownOption",
		"Keybind",
		"Input",
		"InputFocused",
		"InputIndicator",
		"Dialog",
		"DialogHolder",
		"DialogHolderLine",
		"DialogButton",
		"DialogButtonBorder",
		"DialogBorder",
		"DialogInput",
		"DialogInputLine",
		"DialogInputFocused",
		"ColorpickerDialog",
		"ColorpickerDialogBorder",
		"ColorpickerHolder",
		"ColorpickerHolderLine",
		"ColorpickerButton",
		"ColorpickerButtonBorder",
		"ColorpickerInput",
		"ColorpickerInputLine",
		"ColorpickerInputBorder",
		"ColorpickerInputFocused",
		"MenuBackground",
		"MenuBorder",
		"MenuHolder",
		"MenuHolderLine",
		"MenuButton",
		"MenuButtonBorder",
		"MenuInput",
		"MenuInputLine",
		"MenuInputFocused",
		"Text",
		"SubText",
		"Hover",
		"HoverChange",
	}

	local backgroundTables = {}

	local function backgroundToText(value)
		if type(value) == "table" then
			return value.Source or ""
		end
		return type(value) == "string" and value or ""
	end

	local function textToBackground(text)
		if type(text) == "string" and text:lower():match("%.lua$") then
			backgroundTables[text] = backgroundTables[text] or { Source = text }
			return backgroundTables[text]
		end
		return text
	end

	local function sanitizeFileName(name)
		return (name:gsub('[\\/:%*%?"<>|]', "_"))
	end

	local function color3ToHex(c)
		return string.format("%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
	end

	local function colorToText(c, format)
		if format == "RGB" then
			return string.format("%d, %d, %d", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
		elseif format == "HSV" then
			local h, s, v = c:ToHSV()
			return string.format("hsv(%d, %d, %d)", math.floor(h * 360 + 0.5), math.floor(s * 100 + 0.5), math.floor(v * 100 + 0.5))
		end
		return color3ToHex(c)
	end

	local function hexToColor3(h)
		local r = tonumber(h:sub(1,2),16) or 0
		local g = tonumber(h:sub(3,4),16) or 0
		local b = tonumber(h:sub(5,6),16) or 0
		return Color3.fromRGB(r,g,b)
	end

	local function colorSeqToArray(cs, format)
		local arr = {}
		for _, kp in ipairs(cs.Keypoints) do
			table.insert(arr, { t = kp.Time, c = colorToText(kp.Value, format) })
		end
		return arr
	end

	local function arrayToColorSeq(arr)
		local kps = {}
		for _, entry in ipairs(arr) do
			table.insert(kps, ColorSequenceKeypoint.new(entry.t, hexToColor3(entry.c)))
		end
		return ColorSequence.new(kps)
	end

	local function numberSeqToArray(ns)
		local arr = {}
		for _, kp in ipairs(ns.Keypoints) do
			table.insert(arr, { t = kp.Time, v = kp.Value })
		end
		return arr
	end

	local function arrayToNumberSeq(arr)
		local kps = {}
		for _, entry in ipairs(arr) do
			table.insert(kps, NumberSequenceKeypoint.new(entry.t, entry.v))
		end
		return NumberSequence.new(kps)
	end

	local function isValidCardGradient(Value)
		return type(Value) == "table" and typeof(Value[1]) == "Color3" and typeof(Value[2]) == "Color3"
	end

	local function generateGradientColors(themeData)
		local Fallback = { Color3.fromRGB(50, 50, 50), Color3.fromRGB(20, 20, 20) }
		if type(themeData) ~= "table" then
			return Fallback
		end

		local Gradient = themeData.AcrylicGradient
		local ColorA, ColorB

		if typeof(Gradient) == "ColorSequence" then
			local Keypoints = Gradient.Keypoints
			ColorA = Keypoints[1].Value
			ColorB = Keypoints[#Keypoints].Value
		elseif typeof(Gradient) == "Color3" then
			ColorA = Gradient
			ColorB = Gradient
		else
			return Fallback
		end

		local Difference = math.abs(ColorA.R - ColorB.R) + math.abs(ColorA.G - ColorB.G) + math.abs(ColorA.B - ColorB.B)
		if Difference < 0.06 then
			ColorB = ColorA:Lerp(Color3.new(0, 0, 0), 0.5)
		end

		return { ColorA, ColorB }
	end

	local function resolveCardGradient(themeData)
		if type(themeData) == "table" then
			if isValidCardGradient(themeData.CardGradient) then
				return { themeData.CardGradient[1], themeData.CardGradient[2] }
			end
			if isValidCardGradient(themeData.__cardGradient) then
				return { themeData.__cardGradient[1], themeData.__cardGradient[2] }
			end
		end
		return generateGradientColors(themeData)
	end

	function ThemeManager.serializeTheme(themeData, format)
		local raw = {}
		for _, key in ipairs(themePropertyKeys) do
			local val = themeData[key]
			if val == nil then
				raw[key] = nil
			elseif typeof(val) == "Color3" then
				raw[key] = { __type = "Color3", value = colorToText(val, format) }
			elseif typeof(val) == "ColorSequence" then
				raw[key] = { __type = "ColorSequence", value = colorSeqToArray(val, format) }
			elseif typeof(val) == "NumberSequence" then
				raw[key] = { __type = "NumberSequence", value = numberSeqToArray(val) }
			else
				raw[key] = val
			end
		end
		local gradColors = resolveCardGradient(themeData)
		local metaGrad = {}
		for _, c in ipairs(gradColors) do
			table.insert(metaGrad, color3ToHex(c))
		end
		raw.__meta = {
			Name = themeData.Name or "Custom",
			Id = themeData.Id,
			BuiltIn = themeData.BuiltIn,
			CardGradient = metaGrad,
			Author = {
				Name = LocalPlayer and LocalPlayer.Name or "Unknown",
				UserId = LocalPlayer and LocalPlayer.UserId or 0,
			},
		}
		return HttpService:JSONEncode(raw)
	end

	function ThemeManager.toAddThemeCode(themeData, format)
		local function colorCode(c)
			if format == "RGB" then
				return string.format("Color3.fromRGB(%d, %d, %d)", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
			elseif format == "HSV" then
				local h, s, v = c:ToHSV()
				return string.format("Color3.fromHSV(%.3f, %.3f, %.3f)", h, s, v)
			end
			return string.format('Color3.fromHex("%s")', color3ToHex(c))
		end

		local lines = { "Library:AddTheme({", string.format("\tName = %q,", themeData.Name or "Custom") }

		for _, key in ipairs(themePropertyKeys) do
			local val = themeData[key]
			if typeof(val) == "Color3" then
				table.insert(lines, string.format("\t%s = %s,", key, colorCode(val)))
			elseif typeof(val) == "ColorSequence" then
				table.insert(lines, string.format("\t%s = ColorSequence.new({", key))
				for _, kp in ipairs(val.Keypoints) do
					table.insert(lines, string.format("\t\tColorSequenceKeypoint.new(%s, %s),", tostring(math.floor(kp.Time * 1000 + 0.5) / 1000), colorCode(kp.Value)))
				end
				table.insert(lines, "\t}),")
			elseif typeof(val) == "NumberSequence" then
				table.insert(lines, string.format("\t%s = NumberSequence.new({", key))
				for _, kp in ipairs(val.Keypoints) do
					table.insert(lines, string.format("\t\tNumberSequenceKeypoint.new(%s, %s),", tostring(math.floor(kp.Time * 1000 + 0.5) / 1000), tostring(math.floor(kp.Value * 1000 + 0.5) / 1000)))
				end
				table.insert(lines, "\t}),")
			elseif type(val) == "table" and val.Source then
				table.insert(lines, string.format("\t%s = { Source = %q },", key, val.Source))
			elseif type(val) == "string" then
				table.insert(lines, string.format("\t%s = %q,", key, val))
			elseif type(val) == "number" then
				table.insert(lines, string.format("\t%s = %s,", key, tostring(math.floor(val * 1000 + 0.5) / 1000)))
			end
		end

		local gradient = resolveCardGradient(themeData)
		if #gradient >= 2 then
			table.insert(lines, string.format("\tCardGradient = { %s, %s },", colorCode(gradient[1]), colorCode(gradient[2])))
		end

		table.insert(lines, "})")
		return table.concat(lines, "\n")
	end

	function ThemeManager.deserializeTheme(jsonStr)
		local success, decoded = pcall(HttpService.JSONDecode, HttpService, jsonStr)
		if not success or type(decoded) ~= "table" then return nil end

		local themeData = {}
		for _, key in ipairs(themePropertyKeys) do
			local val = decoded[key]
			if val == nil then
			elseif type(val) == "table" and val.__type == "Color3" then
				themeData[key] = hexToColor3(val.value)
			elseif type(val) == "table" and val.__type == "ColorSequence" then
				themeData[key] = arrayToColorSeq(val.value)
			elseif type(val) == "table" and val.__type == "NumberSequence" then
				themeData[key] = arrayToNumberSeq(val.value)
			else
				themeData[key] = val
			end
		end

		if decoded.__meta then
			themeData.Name = decoded.__meta.Name or "Custom"
			themeData.Id = decoded.__meta.Id
			themeData.BuiltIn = decoded.__meta.BuiltIn
			local gradArr = decoded.__meta.CardGradient
			if type(gradArr) == "table" and type(gradArr[1]) == "string" and type(gradArr[2]) == "string"
				and gradArr[1]:match("^#?%x%x%x%x%x%x$") and gradArr[2]:match("^#?%x%x%x%x%x%x$") then
				themeData.__cardGradient = { hexToColor3((gradArr[1]:gsub("^#", ""))), hexToColor3((gradArr[2]:gsub("^#", ""))) }
			end
			if not themeData.__cardGradient then
				themeData.__cardGradient = generateGradientColors(themeData)
			end
			if type(decoded.__meta.Author) == "table" then
				themeData.Author = decoded.__meta.Author
			end
		end

		return themeData
	end

	function ThemeManager.buildFromCurrentOptions(name, optionValues)
		local themeData = {}

		for _, field in ipairs(colorFieldDefs) do
			local value = optionValues["Panel" .. field.key]
			if typeof(value) == "Color3" then
				themeData[field.key] = value
			end

			local colorOption = Library.Options["Panel" .. field.key]
			if field.transparency and colorOption and typeof(colorOption.Transparency) == "number" then
				themeData[field.transparency] = colorOption.Transparency
			end
		end

		for _, field in ipairs(gradientFieldDefs) do
			local gradientValue = optionValues["Panel" .. field.key]
			if typeof(gradientValue) == "ColorSequence" then
				themeData[field.key] = gradientValue
			end

			local gradientOption = Library.Options["Panel" .. field.key]
			if gradientOption and typeof(gradientOption.Rotation) == "number" then
				themeData[field.key .. "Rotation"] = gradientOption.Rotation
			end
			if gradientOption and typeof(gradientOption.Transparency) == "NumberSequence" then
				themeData[field.key .. "Transparency"] = gradientOption.Transparency
			end
		end

		if optionValues.PanelBackground ~= nil then
			themeData.Background = textToBackground(optionValues.PanelBackground)
		end
		if optionValues.PanelBackgroundTransparency then
			themeData.BackgroundTransparency = optionValues.PanelBackgroundTransparency / 100
		end
		if optionValues.PanelAcrylicNoise then
			themeData.AcrylicNoise = optionValues.PanelAcrylicNoise / 100
		end
		if optionValues.PanelHoverChange then
			themeData.HoverChange = optionValues.PanelHoverChange / 100
		end

		themeData.Name = name and name ~= "" and name or "Custom"
		themeData.__cardGradient = generateGradientColors(themeData)

		return themeData
	end

	local normalizeColorValue

	function normalizeColorValue(value)
		if typeof(value) == "Color3" then
			return value
		end

		if type(value) == "table" then
			if value.__type == "Color3" and value.value then
				return normalizeColorValue(value.value)
			end

			local r = value.r or value.R or value[1]
			local g = value.g or value.G or value[2]
			local b = value.b or value.B or value[3]
			if r and g and b then
				if r <= 1 and g <= 1 and b <= 1 then
					return Color3.new(r, g, b)
				end
				return Color3.fromRGB(r, g, b)
			end
		end

		if type(value) == "string" then
			local cleanHex = value:gsub("^#", ""):gsub("^0[xX]", "")
			if cleanHex:match("^%x%x%x%x%x%x$") then
				return hexToColor3(cleanHex)
			end

			local r, g, b = value:match("^%s*rgb%(%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*%)%s*$")
			if not r then
				r, g, b = value:match("^%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*$")
			end
			if r then
				return Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
			end

			local h, s, v = value:match("^%s*hsv%(%s*([%d%.]+)%s*,%s*([%d%.]+)%s*,%s*([%d%.]+)%s*%)%s*$")
			if h then
				return Color3.fromHSV(math.clamp(tonumber(h) / 360, 0, 1), math.clamp(tonumber(s) / 100, 0, 1), math.clamp(tonumber(v) / 100, 0, 1))
			end
		end

		return nil
	end

	local function normalizeGradientValue(value)
		if typeof(value) == "ColorSequence" then
			return value
		end

		if type(value) == "table" and value.__type == "ColorSequence" and type(value.value) == "table" then
			local keypoints = {}
			for _, entry in ipairs(value.value) do
				local entryColor = normalizeColorValue(entry.c or entry.Color or entry.value)
				local entryTime = tonumber(entry.t or entry.Time)
				if entryColor and entryTime then
					table.insert(keypoints, { Time = math.clamp(entryTime, 0, 1), Value = entryColor })
				end
			end
			table.sort(keypoints, function(a, b) return a.Time < b.Time end)

			if #keypoints >= 2 then
				keypoints[1].Time = 0
				keypoints[#keypoints].Time = 1
				local sequenceKeypoints = {}
				for _, kp in ipairs(keypoints) do
					table.insert(sequenceKeypoints, ColorSequenceKeypoint.new(kp.Time, kp.Value))
				end
				return ColorSequence.new(sequenceKeypoints)
			elseif #keypoints == 1 then
				return ColorSequence.new(keypoints[1].Value)
			end
		end

		if type(value) == "table" and value[1] and value[2] then
			local colorStart = normalizeColorValue(value[1])
			local colorEnd = normalizeColorValue(value[2])
			if colorStart and colorEnd then
				return ColorSequence.new(colorStart, colorEnd)
			end
		end

		return nil
	end

	local function normalizeNumberSequenceValue(value)
		if typeof(value) == "NumberSequence" then
			return value
		end

		if type(value) == "number" then
			return NumberSequence.new(math.clamp(value, 0, 1))
		end

		if type(value) == "table" and value.__type == "NumberSequence" and type(value.value) == "table" then
			local keypoints = {}
			for _, entry in ipairs(value.value) do
				local entryTime = tonumber(entry.t or entry.Time)
				local entryValue = tonumber(entry.v or entry.Value)
				if entryTime and entryValue then
					table.insert(keypoints, { Time = math.clamp(entryTime, 0, 1), Value = math.clamp(entryValue, 0, 1) })
				end
			end
			table.sort(keypoints, function(a, b) return a.Time < b.Time end)

			if #keypoints >= 2 then
				keypoints[1].Time = 0
				keypoints[#keypoints].Time = 1
				local sequenceKeypoints = {}
				for _, kp in ipairs(keypoints) do
					table.insert(sequenceKeypoints, NumberSequenceKeypoint.new(kp.Time, kp.Value))
				end
				return NumberSequence.new(sequenceKeypoints)
			elseif #keypoints == 1 then
				return NumberSequence.new(keypoints[1].Value)
			end
		end

		return nil
	end

	local sequenceThemeKeys = {
		AcrylicGradientTransparency = true,
		DropdownHolderTransparency = true,
		DialogHolderTransparency = true,
		ColorpickerHolderTransparency = true,
		MenuBackgroundTransparency = true,
	}

	local numericThemeKeys = {
		BackgroundTransparency = true,
		AcrylicNoise = true,
		ElementTransparency = true,
		TitleBarLineTransparency = true,
		HoverChange = true,
		ElementBorderTransparency = true,
		InElementBorderTransparency = true,
		AcrylicBorderTransparency = true,
		MenuBorderTransparency = true,
		DialogBorderTransparency = true,
		DropdownBorderTransparency = true,
	}

	local rawNumericThemeKeys = {
		AcrylicGradientRotation = true,
		MenuBackgroundRotation = true,
		DropdownHolderRotation = true,
		DialogHolderRotation = true,
		ColorpickerHolderRotation = true,
	}

	local function finalizeThemeData(extracted)
		if not extracted then
			return nil
		end

		local themeData = {}

		local gradientThemeKeys = {
			AcrylicGradient = true,
			MenuBackground = true,
			DropdownHolder = true,
			DialogHolder = true,
			ColorpickerHolder = true,
		}

		local legacyGradientKeys = {
			DropdownHolder = true,
			DialogHolder = true,
			ColorpickerHolder = true,
		}

		for _, key in ipairs(themePropertyKeys) do
			local value = extracted[key]
			if value ~= nil then
				if gradientThemeKeys[key] then
					local gradient = normalizeGradientValue(value)
					if not gradient and legacyGradientKeys[key] then
						local legacyColor = normalizeColorValue(value)
						if legacyColor then
							gradient = ColorSequence.new(legacyColor)
							if key == "DialogHolder" then
								themeData.DialogInputFocused = legacyColor
							end
						end
					end
					if gradient then
						themeData[key] = gradient
					end
				elseif sequenceThemeKeys[key] then
					local sequence = normalizeNumberSequenceValue(value)
					if sequence then
						themeData[key] = sequence
					end
				elseif key == "Background" then
					themeData.Background = type(value) == "table" and value or tostring(value)
				elseif rawNumericThemeKeys[key] then
					local num = tonumber(value)
					if num then
						themeData[key] = num
					end
				elseif numericThemeKeys[key] then
					local num = tonumber(value)
					if num then
						themeData[key] = num > 1 and (num / 100) or num
					end
				else
					local color = normalizeColorValue(value)
					if color then
						themeData[key] = color
					end
				end
			end
		end

		if not themeData.AcrylicGradient then
			local gradient = normalizeGradientValue({ extracted.AcrylicGradientStart, extracted.AcrylicGradientEnd })
			if gradient then
				themeData.AcrylicGradient = gradient
			end
		end

		themeData.Name = (extracted.Name and tostring(extracted.Name) ~= "") and tostring(extracted.Name) or "Imported"

		local gradientMeta = extracted.CardGradient
		if type(gradientMeta) == "table" and gradientMeta[1] and gradientMeta[2] then
			local colorA = normalizeColorValue(gradientMeta[1])
			local colorB = normalizeColorValue(gradientMeta[2])
			if colorA and colorB then
				themeData.__cardGradient = { colorA, colorB }
			end
		end

		if not themeData.__cardGradient then
			themeData.__cardGradient = generateGradientColors(themeData)
		end

		return themeData
	end

	local function parseJsonFormat(text)
		local success, decoded = pcall(HttpService.JSONDecode, HttpService, text)
		if not success or type(decoded) ~= "table" then
			return nil
		end

		local source = decoded.Import or decoded
		local extracted = {}

		for key, value in next, source do
			if key == "__meta" or key == "Meta" then
				if type(value) == "table" then
					extracted.Name = value.Name
					extracted.CardGradient = value.CardGradient
				end
			elseif key ~= "__type" then
				extracted[key] = value
			end
		end

		return extracted
	end

	local function parseLuaTableFormat(text)
		local body = text:gsub("^%s*Import%s*=%s*", ""):gsub("^%s*return%s+", "")

		local bracePos = body:find("{")
		if not bracePos then
			return nil
		end
		body = body:sub(bracePos)

		local patchedBody = body:gsub("([%a_][%w_]*)%s*=%s*([^,{}\n]-)%s*([,\n}])", function(matchKey, matchValue, term)
			local trimmed = matchValue:match("^%s*(.-)%s*$")
			if trimmed == "" then
				return nil
			end
			local firstChar = trimmed:sub(1, 1)
			if firstChar == "\"" or firstChar == "'" then
				return nil
			end
			if trimmed:find("(", 1, true) then
				return nil
			end
			if trimmed == "true" or trimmed == "false" or trimmed == "nil" then
				return nil
			end
			if tonumber(trimmed) then
				return nil
			end
			if not trimmed:match("^%x%x%x%x%x%x$") then
				return nil
			end
			return matchKey .. ' = "' .. trimmed .. '"' .. term
		end)

		local chunk = loadstring("return " .. patchedBody) or loadstring("return " .. body)
		if not chunk then
			return nil
		end

		local success, result = pcall(chunk)
		if not success or type(result) ~= "table" then
			return nil
		end

		local extracted = {}
		for key, value in next, result do
			if key == "Meta" then
				if type(value) == "table" then
					extracted.Name = value.Name
					extracted.CardGradient = value.CardGradient
				end
			else
				extracted[key] = value
			end
		end

		return extracted
	end

	local function parseLineFormat(text)
		local extracted = {}
		local foundAny = false

		for line in text:gmatch("[^\r\n]+") do
			local key, value = line:match("^%s*([%a_][%w_]*)%s*[:=]%s*(.-)%s*$")
			if key and value and value ~= "" then
				value = value:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
				extracted[key] = value
				foundAny = true
			end
		end

		if not foundAny then
			return nil
		end

		return extracted
	end

	local importFormatParsers = {
		parseJsonFormat,
		parseLuaTableFormat,
		parseLineFormat,
	}

	function ThemeManager.parseImportString(raw)
		if not raw or raw:gsub("%s", "") == "" then
			return nil
		end

		local trimmed = raw:match("^%s*(.-)%s*$")

		for _, parser in ipairs(importFormatParsers) do
			local ok, extracted = pcall(parser, trimmed)
			if ok and extracted then
				local themeData = finalizeThemeData(extracted)
				if themeData then
					return themeData
				end
			end
		end

		return nil
	end

	function InterfaceManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function InterfaceManager:SetLibrary(library)
		self.Library = library
	end

	function InterfaceManager:ImportTheme(Raw, Options)
		assert(self.Library, "Must set InterfaceManager.Library")
		local Lib = self.Library

		if type(Options) == "string" then
			Options = { Name = Options }
		end
		Options = Options or {}

		local Parsed
		if type(Raw) == "table" then
			Parsed = finalizeThemeData(Raw)
		elseif type(Raw) == "string" then
			Parsed = ThemeManager.parseImportString(Raw)
		end

		if not Parsed then
			return nil, "ImportTheme - Invalid theme format"
		end

		if type(Options.Name) == "string" and Options.Name ~= "" then
			Parsed.Name = Options.Name
		end
		if type(Options.Base) == "string" then
			Parsed.Base = Options.Base
		end

		Parsed.CardGradient = Parsed.__cardGradient
		Parsed.__cardGradient = nil

		local Theme = Lib:AddTheme(Parsed)

		if Options.Select then
			Lib:SetTheme(Parsed.Name)
		end

		return Theme
	end

	function InterfaceManager:ImportFont(Raw, Options)
		assert(self.Library, "Must set InterfaceManager.Library")
		local Lib = self.Library

		if type(Options) == "string" then
			Options = { Name = Options }
		end
		Options = Options or {}

		local Parsed
		if type(Raw) == "table" then
			local Ok, Encoded = pcall(HttpService.JSONEncode, HttpService, Raw)
			Parsed = Ok and InterfaceManager.ParseFontImport(Encoded) or nil
		elseif type(Raw) == "string" then
			Parsed = InterfaceManager.ParseFontImport(Raw)
		end

		if not Parsed then
			return nil, "ImportFont - Invalid font format"
		end

		if type(Options.Name) == "string" and Options.Name ~= "" then
			Parsed.Name = Options.Name
		end
		if Options.Weight ~= nil then
			Parsed.Weight = Options.Weight
		end
		if Options.Style ~= nil then
			Parsed.Style = Options.Style
		end
		Parsed.Select = Options.Select == true

		return Lib:AddFont(Parsed)
	end

	function InterfaceManager:BuildFolderTree()
		local paths = {}

		local parts = self.Folder:split("/")
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, "/", 1, idx)
		end

		table.insert(paths, self.Folder)
		table.insert(paths, self.Folder .. "/settings")
		table.insert(paths, self.Folder .. "/Theme")

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function InterfaceManager:GenerateThemeId(name)
		local base = sanitizeFileName(name and name ~= "" and name or "Custom")
		local n = 1
		while isfile(self.Folder .. "/Theme/" .. base .. "_" .. n .. ".theme") do
			n = n + 1
		end
		return base .. "_" .. n
	end

	function InterfaceManager:SaveCustomTheme(themeData)
		local id = themeData.Id or self:GenerateThemeId(themeData.Name)
		themeData.Id = id
		local path = self.Folder .. "/Theme/" .. sanitizeFileName(id) .. ".theme"
		local encoded = ThemeManager.serializeTheme(themeData)
		writefile(path, encoded)
	end

	function InterfaceManager:LoadCustomThemes()
		local folder = self.Folder .. "/Theme"
		if not isfolder(folder) then return {} end
		local files = listfiles(folder)
		local out = {}
		for _, file in ipairs(files) do
			if file:sub(-6) == ".theme" then
				local ok, data = pcall(readfile, file)
				if ok and data then
					local themeData = ThemeManager.deserializeTheme(data)
					if themeData then
						if not themeData.Id or themeData.Id == "" then
							local newId = self:GenerateThemeId(themeData.Name)
							themeData.Id = newId
							pcall(function()
								self:SaveCustomTheme(themeData)
								if isfile(file) then
									delfile(file)
								end
							end)
						end
						table.insert(out, themeData)
					end
				end
			end
		end
		return out
	end

	function InterfaceManager:DeleteCustomTheme(id)
		local path = self.Folder .. "/Theme/" .. sanitizeFileName(id) .. ".theme"
		if isfile(path) then
			delfile(path)
		end
	end

	local FontWeightValues = {
		Thin = 100, ExtraLight = 200, Light = 300, Regular = 400, Medium = 500,
		SemiBold = 600, Bold = 700, ExtraBold = 800, Heavy = 900,
	}
	InterfaceManager.FontWeightNames = { "Thin", "ExtraLight", "Light", "Regular", "Medium", "SemiBold", "Bold", "ExtraBold", "Heavy" }
	InterfaceManager.FontStyleNames = { "Normal", "Italic" }
	InterfaceManager.CustomFontAssets = {}

	local FontWeightNamesByValue = {}
	for Name, Value in next, FontWeightValues do
		FontWeightNamesByValue[Value] = Name
	end

	local function ResolveFontWeightName(Raw)
		if Raw == nil then
			return nil
		end
		local Number = tonumber(Raw)
		if Number then
			return FontWeightNamesByValue[Number]
		end
		local Text = tostring(Raw):lower()
		for _, Name in ipairs(InterfaceManager.FontWeightNames) do
			if Name:lower() == Text then
				return Name
			end
		end
		return nil
	end

	local function ResolveFontStyleName(Raw)
		if tostring(Raw or ""):lower() == "italic" then
			return "Italic"
		end
		return "Normal"
	end

	function InterfaceManager.ParseFontImport(Raw)
		if type(Raw) ~= "string" or not Raw:match("%S") then
			return nil
		end

		local Text = Raw:match("^%s*(.-)%s*$")
		local Entry

		local Ok, Decoded = pcall(HttpService.JSONDecode, HttpService, Text)
		if Ok and type(Decoded) == "table" then
			if type(Decoded.faces) == "table" and type(Decoded.faces[1]) == "table" then
				local Face = Decoded.faces[1]
				Entry = {
					Name = Decoded.name,
					Weight = Face.weight,
					Style = Face.style,
					AssetId = Face.assetId,
				}
			else
				Entry = {
					Name = Decoded.Name or Decoded.name,
					Weight = Decoded.Weight or Decoded.weight,
					Style = Decoded.Style or Decoded.style,
					AssetId = Decoded.AssetId or Decoded.assetId or Decoded.assetid,
				}
			end
		else
			local function Find(Key)
				local Quoted = Text:match(Key .. "%s*[=:]%s*\"([^\"]*)\"") or Text:match(Key .. "%s*[=:]%s*'([^']*)'")
				if Quoted then
					return Quoted
				end
				local Loose = Text:match(Key .. "%s*[=:]%s*([^\n,}]+)")
				return Loose and Loose:match("^%s*(.-)%s*$") or nil
			end
			Entry = {
				Name = Find("Name"),
				Weight = Find("Weight"),
				Style = Find("Style"),
				AssetId = Find("AssetId"),
			}
		end

		if not Entry or type(Entry.Name) ~= "string" or not Entry.Name:match("%S") then
			return nil
		end
		if Entry.AssetId == nil or tostring(Entry.AssetId) == "" then
			return nil
		end

		return {
			Name = Entry.Name:match("^%s*(.-)%s*$"),
			Weight = ResolveFontWeightName(Entry.Weight) or "Regular",
			Style = ResolveFontStyleName(Entry.Style),
			AssetId = tostring(Entry.AssetId),
		}
	end

	function InterfaceManager:FontId(name)
		return "custom:" .. sanitizeFileName(tostring(name or "Font"))
	end
	function InterfaceManager:IsLocalFontSource(source)
		source = tostring(source or ""):match("^%s*(.-)%s*$")
		if tonumber(source) then return false end
		if source:match("^rbxassetid://") or source:match("^rbxasset://") or source:match("^https?://www%.roblox%.com/asset") then
			return false
		end
		return true
	end
	function InterfaceManager:ResolveCustomFont(entry)
		local source = tostring(entry.AssetId or ""):match("^%s*(.-)%s*$")
		if source == "" then
			return nil, "Asset Id is empty."
		end
		if tonumber(source) then
			return "rbxassetid://" .. source
		end
		if not self:IsLocalFontSource(source) then
			return source
		end

		if not (isfile and writefile and getcustomasset) then
			return nil, "Your executor does not support getcustomasset."
		end

		local folder = self.Folder .. "/Fonts"
		if not isfolder(folder) then
			makefolder(folder)
		end

		local id = sanitizeFileName(tostring(entry.Name))
		local path = source

		if source:match("^https?://") then
			path = folder .. "/" .. id .. ".ttf"
			if not isfile(path) then
				local ok, body = pcall(game.HttpGet, game, source)
				if not ok or type(body) ~= "string" or #body == 0 then
					return nil, "Failed to download the font."
				end
				writefile(path, body)
			end
		end

		if not isfile(path) then
			return nil, "File not found: " .. path
		end
		if path:lower():match("%.json$") then
			local ok, asset = pcall(getcustomasset, path)
			if ok and asset then return asset end
			return nil, "getcustomasset failed."
		end
		local weightName = FontWeightValues[entry.Weight] and entry.Weight or "Regular"
		local okFile, fileAsset = pcall(getcustomasset, path)
		if not okFile or not fileAsset then
			return nil, "getcustomasset failed."
		end

		local jsonPath = folder .. "/" .. id .. ".json"
		writefile(jsonPath, HttpService:JSONEncode({
			name = tostring(entry.Name),
			faces = {{
				name = weightName,
				weight = FontWeightValues[weightName],
				style = entry.Style == "Italic" and "italic" or "normal",
				assetId = fileAsset,
			}},
		}))

		local okJson, jsonAsset = pcall(getcustomasset, jsonPath)
		if okJson and jsonAsset then return jsonAsset end
		return nil, "Failed to create the font family."
	end

	function InterfaceManager:DeleteCustomFontFile(name)
		local jsonPath = self.Folder .. "/Fonts/" .. sanitizeFileName(tostring(name)) .. ".json"
		if isfile and isfile(jsonPath) then
			pcall(delfile, jsonPath)
		end
	end


	function InterfaceManager:SaveSettings()
		local Path = self.Folder .. "/options.json"
		if InterfaceManager.Building and not isfile(Path) then
			return
		end
		writefile(Path, HttpService:JSONEncode(InterfaceManager.Settings))
	end

	function InterfaceManager:LoadSettings()
		local allThemes = self:LoadCustomThemes()
		local customThemes = {}
		InterfaceManager.Overrides = {}

		for _, themeData in ipairs(allThemes) do
			if themeData.BuiltIn then
				InterfaceManager.Overrides[themeData.BuiltIn] = themeData
				Library:OverrideTheme(themeData.BuiltIn, themeData)
			else
				table.insert(customThemes, themeData)
			end
		end

		local WindowSettings = InterfaceManager.Settings
		local UserInfoFrame = Library.Window and Library.Window.UserInfoFrame
		WindowSettings.Theme = Library.Theme
		WindowSettings.Font = Library.Font
		WindowSettings.Acrylic = Library.Acrylic
		WindowSettings.Transparency = math.floor((Library.Transparency or 0.35) * 100 + 0.5)
		WindowSettings.MenuKeybind = (Library.MinimizeKey and Library.MinimizeKey.Name) or WindowSettings.MenuKeybind
		WindowSettings.ShowUserInfo = UserInfoFrame == nil or UserInfoFrame.Visible
		WindowSettings.DisableBackground = Library.DisableBackground
		WindowSettings.KeepWindowInsideFrame = Library.KeepWindowInsideFrame
		WindowSettings.ActiveCustomTheme = nil

		local activeCustomName = nil
		local optionsPath = self.Folder .. "/options.json"
		if isfile(optionsPath) then
			local data = readfile(optionsPath)
			local success, decoded = pcall(HttpService.JSONDecode, HttpService, data)
			if success then
				for i, v in next, decoded do
					InterfaceManager.Settings[i] = v
				end
				activeCustomName = decoded.ActiveCustomTheme
			end
		end

		if activeCustomName then
			local matchedById = nil
			local matchedByNameCount = 0
			local matchedByName = nil

			for _, themeData in ipairs(customThemes) do
				if themeData.Id == activeCustomName then
					matchedById = themeData
				elseif themeData.Name == activeCustomName then
					matchedByNameCount = matchedByNameCount + 1
					matchedByName = themeData
				end
			end

			local resolved = matchedById
			if not resolved and matchedByNameCount == 1 then
				resolved = matchedByName
				InterfaceManager.Settings.ActiveCustomTheme = resolved.Id
				pcall(function() self:SaveSettings() end)
			end

			if resolved then
				Library.CustomThemeData = resolved
				Library.Theme = resolved.Name
			end
		end

		return customThemes
	end

	function InterfaceManager:BuildInterfaceSection(tab)
		assert(self.Library, "Must set InterfaceManager.Library")
		local library = self.Library
		local settings = InterfaceManager.Settings

		InterfaceManager.Building = true
		local loadedCustomThemes = InterfaceManager:LoadSettings()

		if type(settings.SidePanels) ~= "table" then
			settings.SidePanels = {}
		end
		for panelId, panelState in next, Library.PanelSizes do
			if settings.SidePanels[panelId] == nil then
				settings.SidePanels[panelId] = panelState
			end
		end
		Library.PanelSizes = settings.SidePanels

		Library.OnPanelSizeChanged = function()
			pcall(function()
				InterfaceManager:SaveSettings()
			end)
		end

		Library.OnWindowSizeChanged = function(size)
			settings.WindowSize = { X = size.X.Offset, Y = size.Y.Offset }
			pcall(function()
				InterfaceManager:SaveSettings()
			end)
		end

		if type(settings.WindowSize) == "table" and Library.Window and Library.Window.SetSize then
			local savedX = tonumber(settings.WindowSize.X)
			local savedY = tonumber(settings.WindowSize.Y)
			if savedX and savedY then
				Library.Window:SetSize(Vector2.new(savedX, savedY))
			end
		end

		if type(settings.Transparency) == "boolean" then
			settings.Transparency = settings.Transparency and 35 or 0
		end
		settings.Transparency = math.clamp(tonumber(settings.Transparency) or 35, 0, 100)

		if settings.ActiveCustomTheme and Library.CustomThemeData then
			library:SetTheme(Library.CustomThemeData)
		else
			library:SetTheme(settings.Theme)
		end

		settings.CustomFonts = type(settings.CustomFonts) == "table" and settings.CustomFonts or {}
		InterfaceManager.CustomFontAssets = {}
		for _, entry in ipairs(settings.CustomFonts) do
			local ok, asset = pcall(InterfaceManager.ResolveCustomFont, InterfaceManager, entry)
			if ok and asset then
				InterfaceManager.CustomFontAssets[InterfaceManager:FontId(entry.Name)] = asset
			else
				warn("[Font] Failed to load custom font '" .. tostring(entry.Name) .. "'")
			end
		end

		local function resolveAddedFont(entry)
			local ok, asset = pcall(InterfaceManager.ResolveCustomFont, InterfaceManager, entry)
			if ok and asset then
				InterfaceManager.CustomFontAssets[InterfaceManager:FontId(entry.Name)] = asset
				return asset
			end
			warn("[Font] Failed to load added font '" .. tostring(entry.Name) .. "'")
			return nil
		end

		local hasSavedFont = false
		local savedOptionsPath = InterfaceManager.Folder .. "/options.json"
		if isfile(savedOptionsPath) then
			local okRead, rawOptions = pcall(readfile, savedOptionsPath)
			local okDecode, decodedOptions = pcall(HttpService.JSONDecode, HttpService, okRead and rawOptions or "")
			hasSavedFont = okDecode and type(decodedOptions) == "table" and decodedOptions.Font ~= nil
		end

		local pendingSelectKey
		for _, entry in ipairs(Library.AddedFonts) do
			local asset = resolveAddedFont(entry)
			if asset and entry.Select and not hasSavedFont then
				pendingSelectKey = InterfaceManager:FontId(entry.Name)
			end
		end

		local startFontKey = pendingSelectKey or settings.Font or Library.Font
		local startFontAsset = startFontKey
		if type(startFontKey) == "string" and startFontKey:sub(1, 7) == "custom:" then
			startFontAsset = InterfaceManager.CustomFontAssets[startFontKey]
			if not startFontAsset then
				startFontKey = Library.Font
				startFontAsset = Library.Font
			end
		end
		settings.Font = startFontKey
		library:SetFont(startFontAsset)


		library:ToggleUserInfo(settings.ShowUserInfo)
		library:ToggleBackground(settings.DisableBackground)

		if settings.KeepWindowInsideFrame == nil then
			settings.KeepWindowInsideFrame = true
		end
		library:ToggleKeepWindowInsideFrame(settings.KeepWindowInsideFrame)

		local section = tab:AddSection("Appearance")

		local New = Creator.New

		local themeGradients = {
			Dark = { Color3.fromRGB(95,  95,  95),  Color3.fromRGB(60,  60,  60)  },
			Darker = { Color3.fromRGB(30,  30,  30),  Color3.fromRGB(12,  12,  12)  },
			Light = { Color3.fromRGB(220, 220, 220), Color3.fromRGB(180, 180, 180) },
			Aqua = { Color3.fromRGB(60,  140, 140), Color3.fromRGB(30,  70,  70)  },
			Amethyst = { Color3.fromRGB(85,  57,  139), Color3.fromRGB(40,  25,  65)  },
			Rose = { Color3.fromRGB(190, 60,  135), Color3.fromRGB(150, 45,  65)  },
			["Crimson Noir"] = { Color3.fromRGB(197, 3, 55), Color3.fromRGB(5, 5, 18)    },
			Gold = { Color3.fromRGB(255, 198, 41),  Color3.fromRGB(160, 120, 24)  },
		}

		local pickerWrapper = New("Frame", {
			Name = "ThemePickerWrapper",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 0.89,
			BackgroundColor3 = Color3.fromRGB(130, 130, 130),
			LayoutOrder = 1,
			Parent = section.Container,
			ThemeTag = {
				BackgroundColor3 = "Element",
				BackgroundTransparency = "ElementTransparency",
			},
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 4) }),
			New("UIStroke", {
				Transparency = 0.5,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = { Color = "ElementBorder", Transparency = "ElementBorderTransparency" },
			}),
		})

		New("ImageLabel", {
			Image = "rbxassetid://86350350950064",
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.fromOffset(10, 9),
			BackgroundTransparency = 1,
			ZIndex = 2,
			ThemeTag = { ImageColor3 = "Text" },
			Parent = pickerWrapper,
		})

		New("TextLabel", {
			Text = "Theme",
			FontFace = Font.new(Library.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 0, 14),
			Position = UDim2.fromOffset(32, 10),
			BackgroundTransparency = 1,
			ThemeTag = { TextColor3 = "Text" },
			Parent = pickerWrapper,
		})

		New("TextLabel", {
			Text = "Changes the interface theme.",
			FontFace = Font.new(Library.Font),
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 0, 14),
			Position = UDim2.fromOffset(32, 26),
			BackgroundTransparency = 1,
			ThemeTag = { TextColor3 = "SubText" },
			Parent = pickerWrapper,
		})

		local scrollFrame = New("ScrollingFrame", {
			Name = "ThemeCardScroll",
			Size = UDim2.new(1, -20, 0, 92),
			Position = UDim2.fromOffset(10, 46),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			CanvasSize = UDim2.fromScale(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			Parent = pickerWrapper,
		}, {
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 2),
				PaddingRight = UDim.new(0, 2),
			}),
		})

		local themeCards = {}
		local customThemeCards = {}
		local currentSelectedName = settings.ActiveCustomTheme or settings.Theme

		local function setSelectedCard(selectedName)
			for themeName, cardData in pairs(themeCards) do
				local isSelected = themeName == selectedName
				cardData.stroke.Transparency = isSelected and 0.1 or 0.7
				cardData.stroke.Color = isSelected
					and Creator.GetThemeProperty("Accent")
					or Color3.fromRGB(70, 70, 70)
				cardData.checkBadge.Visible = isSelected
			end
			for themeName, cardData in pairs(customThemeCards) do
				local isSelected = themeName == selectedName
				cardData.stroke.Transparency = isSelected and 0.1 or 0.7
				cardData.stroke.Color = isSelected
					and Creator.GetThemeProperty("Accent")
					or Color3.fromRGB(70, 70, 70)
				cardData.checkBadge.Visible = isSelected
			end
		end

		local function addCustomThemeCard(themeData, layoutOrder)
			local gradColors = themeData.__cardGradient or { Color3.fromRGB(50,50,50), Color3.fromRGB(20,20,20) }
			local colorA, colorB = gradColors[1], gradColors[2]
			local themeName = themeData.Name
			local themeId = themeData.Id

			local card = New("Frame", {
				Name = "ThemeCard_Custom_" .. themeId,
				Size = UDim2.fromOffset(72, 72),
				BackgroundColor3 = colorA,
				BorderSizePixel = 0,
				LayoutOrder = layoutOrder or 9999,
				Parent = scrollFrame,
				ClipsDescendants = true,
			}, {
				New("UICorner", { CornerRadius = UDim.new(0, 8) }),
				New("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, colorA),
						ColorSequenceKeypoint.new(1, colorB),
					}),
					Rotation = 135,
				}),
			})

			New("TextLabel", {
				Text = themeName,
				FontFace = Font.new(Library.Font, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
				TextSize = 9,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextStrokeTransparency = 0.4,
				TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Center,
				Size = UDim2.new(1, -4, 0, 14),
				Position = UDim2.new(0, 2, 1, -16),
				BackgroundTransparency = 1,
				ZIndex = 3,
				Parent = card,
			})

			local stroke = New("UIStroke", {
				Thickness = 2,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(70, 70, 70),
				Transparency = 0.7,
				Parent = card,
			})

			local checkBadge = New("Frame", {
				Size = UDim2.fromOffset(18, 18),
				Position = UDim2.fromOffset(5, 5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 4,
				Visible = false,
				Parent = card,
			}, {
				New("UICorner", { CornerRadius = UDim.new(1, 0) }),
			})

			New("ImageLabel", {
				Size = UDim2.fromOffset(10, 10),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = "rbxassetid://93898873302694",
				ImageColor3 = Color3.fromRGB(20, 20, 20),
				ZIndex = 5,
				Parent = checkBadge,
			})

			customThemeCards[themeId] = {
				card = card,
				stroke = stroke,
				checkBadge = checkBadge,
				themeData = themeData,
			}

			local hitBox = New("TextButton", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",
				ZIndex = 6,
				Parent = card,
			})

			Creator.AttachCardHover(card, hitBox)

			Creator.AddSignal(hitBox.MouseEnter, function()
				if currentSelectedName ~= themeId then
					stroke.Transparency = 0.4
				end
			end)
			Creator.AddSignal(hitBox.MouseLeave, function()
				if currentSelectedName ~= themeId then
					stroke.Transparency = 0.7
				end
			end)
			Creator.AddSignal(hitBox.MouseButton1Click, function()
				library:SetTheme(themeData)
				currentSelectedName = themeId
				settings.Theme = themeName
				settings.ActiveCustomTheme = themeId
				InterfaceManager:SaveSettings()
				setSelectedCard(themeId)
			end)
		end

		local themeTargetDropdown

		local themeTargetLabelToId = {}

		local function getCustomThemeNames()
			local entries = {}
			for id, cardData in pairs(customThemeCards) do
				table.insert(entries, { name = cardData.themeData.Name, id = id })
			end
			for builtInName, record in pairs(InterfaceManager.Overrides) do
				table.insert(entries, { name = builtInName .. " (Built-in)", id = record.Id })
			end
			table.sort(entries, function(a, b) return a.name < b.name end)

			themeTargetLabelToId = {}
			local labels = {}
			local seen = {}
			for _, entry in ipairs(entries) do
				local label = entry.name
				if seen[entry.name] then
					seen[entry.name] = seen[entry.name] + 1
					label = entry.name .. " (" .. seen[entry.name] .. ")"
				else
					seen[entry.name] = 1
				end
				table.insert(labels, label)
				themeTargetLabelToId[label] = entry.id
			end
			return labels
		end

		local function refreshThemeTargetDropdown()
			if themeTargetDropdown then
				themeTargetDropdown:SetValues(getCustomThemeNames())
			end
		end

		local function resolveThemeName(candidateName)
			if candidateName and tostring(candidateName):match("%S") then
				return tostring(candidateName)
			end

			local nameOpt = Library.Options["PanelThemeName"]
			if nameOpt and nameOpt.Value and tostring(nameOpt.Value):match("%S") then
				return tostring(nameOpt.Value)
			end

			return nil
		end

		local function getSuggestedThemeName()
			if settings.ActiveCustomTheme then
				for _, existingTheme in ipairs(loadedCustomThemes) do
					if existingTheme.Id == settings.ActiveCustomTheme then
						return existingTheme.Name
					end
				end
			end

			return settings.Theme or "Dark"
		end

		local function persistCustomTheme(themeData, allowOverwrite, existingId)
			local finalName = themeData.Name
			local themeId = existingId or themeData.Id

			if not (allowOverwrite and themeId) then
				themeId = InterfaceManager:GenerateThemeId(finalName)
			end
			themeData.Id = themeId

			InterfaceManager:SaveCustomTheme(themeData)

			local existingCard = customThemeCards[themeId]
			local layoutOrder = existingCard and existingCard.card.LayoutOrder or (1000 + #loadedCustomThemes)
			if existingCard then
				existingCard.card:Destroy()
				customThemeCards[themeId] = nil
			end
			addCustomThemeCard(themeData, layoutOrder)

			local replaced = false
			for i, existingTheme in ipairs(loadedCustomThemes) do
				if existingTheme.Id == themeId then
					loadedCustomThemes[i] = themeData
					replaced = true
					break
				end
			end
			if not replaced then
				table.insert(loadedCustomThemes, themeData)
			end

			library:SetTheme(themeData)
			currentSelectedName = themeId
			settings.Theme = finalName
			settings.ActiveCustomTheme = themeId
			InterfaceManager:SaveSettings()
			setSelectedCard(themeId)
			refreshThemeTargetDropdown()

			return themeData
		end

		local function findExistingCustomThemeId(name)
			for id, cardData in pairs(customThemeCards) do
				if cardData.themeData.Name == name then
					return id
				end
			end
			return nil
		end

		local function persistBuiltInOverride(themeData, builtInName)
			local record = InterfaceManager.Overrides[builtInName]
			themeData.Name = builtInName
			themeData.BuiltIn = builtInName
			themeData.Id = record and record.Id or InterfaceManager:GenerateThemeId(builtInName)

			InterfaceManager:SaveCustomTheme(themeData)
			InterfaceManager.Overrides[builtInName] = themeData

			library:OverrideTheme(builtInName, themeData)
			library:SetTheme(builtInName)

			currentSelectedName = builtInName
			settings.Theme = builtInName
			settings.ActiveCustomTheme = nil
			InterfaceManager:SaveSettings()
			setSelectedCard(builtInName)
			refreshThemeTargetDropdown()
		end

		local function confirmAndPersistTheme(themeData, successMessage)
			if table.find(library.Themes, themeData.Name) then
				library.Window:Dialog({
					Title = "Built-in Theme",
					Content = "'" .. themeData.Name .. "' is a built-in theme. Overwrite it with these values? Deleting the override restores the original.",
					Buttons = {
						{ Title = "Cancel", Callback = function() end },
						{ Title = "Duplicate", Callback = function()
							persistCustomTheme(themeData, false)
							library:Notify({ Title = "Theme", Content = "Custom", SubContent = successMessage, Duration = 5 })
						end },
						{ Title = "Overwrite", Callback = function()
							persistBuiltInOverride(themeData, themeData.Name)
							library:Notify({ Title = "Theme", Content = "Custom", SubContent = "Built-in theme '" .. themeData.Name .. "' overwritten.", Duration = 5 })
						end },
					},
				})
				return
			end

			local existingId = findExistingCustomThemeId(themeData.Name)

			if not existingId then
				persistCustomTheme(themeData, false)
				library:Notify({ Title = "Theme", Content = "Custom", SubContent = successMessage, Duration = 5 })
				return
			end

			library.Window:Dialog({
				Title = "Theme Name Already Exists",
				Content = "A theme named '" .. themeData.Name .. "' already exists. What would you like to do?",
				Buttons = {
					{ Title = "Cancel", Callback = function() end },
					{ Title = "Duplicate", Callback = function()
						persistCustomTheme(themeData, false)
						library:Notify({ Title = "Theme", Content = "Custom", SubContent = successMessage, Duration = 5 })
					end },
					{ Title = "Overwrite", Callback = function()
						persistCustomTheme(themeData, true, existingId)
						library:Notify({ Title = "Theme", Content = "Custom", SubContent = successMessage, Duration = 5 })
					end },
				},
			})
		end

		local addThemeCard = New("Frame", {
			Name = "ThemeCard_AddCustom",
			Size = UDim2.fromOffset(72, 72),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 0,
			Parent = scrollFrame,
			ClipsDescendants = true,
			ThemeTag = {
				BackgroundColor3 = "Element",
				BackgroundTransparency = "ElementTransparency",
			},
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 8) }),
			New("UIStroke", {
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Transparency = 0.5,
				ThemeTag = { Color = "DialogBorder" },
			}),
		})

		local addThemeImage = New("ImageLabel", {
			Image = Library.InternalIcons.Plus,
			Size = UDim2.fromOffset(20, 20),
			Position = UDim2.fromScale(0.5, 0.44),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			ZIndex = 3,
			Parent = addThemeCard,
			ThemeTag = { ImageColor3 = "SubText" },
		})

		New("TextLabel", {
			Text = "Custom",
			FontFace = Font.new(Library.Font, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			TextSize = 9,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.new(1, -4, 0, 14),
			Position = UDim2.new(0, 2, 1, -16),
			BackgroundTransparency = 1,
			ZIndex = 3,
			Parent = addThemeCard,
			ThemeTag = { TextColor3 = "SubText" },
		})

		local addThemeHitBox = New("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			ZIndex = 6,
			Parent = addThemeCard,
		})

		Creator.AttachCardHover(addThemeCard, addThemeHitBox)

		Creator.AddSignal(addThemeHitBox.MouseEnter, function()
			addThemeCard.UIStroke.Transparency = 0.2
		end)
		Creator.AddSignal(addThemeHitBox.MouseLeave, function()
			addThemeCard.UIStroke.Transparency = 0.5
		end)
		Creator.AddSignal(addThemeHitBox.MouseButton1Click, function()
			local Panel
			local suggestedName = getSuggestedThemeName()

			Panel = library.Window:SidePanel({
				Title = "Custom Theme",
				Description = "Create or import a custom theme.",
				Side = "Right",
				Width = 320,
				Buttons = {
					{ Title = "Cancel", CloseOnClick = true, Callback = function() end },
					{ Title = "Import", CloseOnClick = false, Callback = function()
						Panel:PromptImport({
							Title = "Paste theme code",
							Placeholder = '{"Accent":{"__type":"Color3","value":"#FFFFFF"},"__meta":{"Name":"Theme"}}',
							Callback = function(rawText)
								if not rawText or rawText:gsub("%s", "") == "" then
									library:Notify({ Title = "Theme", Content = "Import", SubContent = "The pasted text is empty.", Duration = 4 })
									return
								end

									local parsed = ThemeManager.parseImportString(rawText)
								if not parsed then
									library:Notify({ Title = "Theme", Content = "Import", SubContent = "Invalid theme format.", Duration = 4 })
									return
								end

								local themeName = resolveThemeName(parsed.Name)
								if not themeName then
									library:Notify({ Title = "Theme", Content = "Import", SubContent = "This theme has no name. Type one in Theme Name first.", Duration = 6 })
									return
								end
								parsed.Name = themeName

								if Library.Options["PanelThemeName"] then
									Library.Options["PanelThemeName"]:SetValue(themeName)
								end

								for _, field in ipairs(colorFieldDefs) do
									local optionKey = "Panel" .. field.key
									if parsed[field.key] ~= nil and Library.Options[optionKey] then
										Library.Options[optionKey]:SetValueRGB(parsed[field.key], field.transparency and parsed[field.transparency] or nil)
									end
								end

								for _, field in ipairs(gradientFieldDefs) do
									local gradientOption = Library.Options["Panel" .. field.key]
									if gradientOption then
										if parsed[field.key] then
											gradientOption:SetValueSequence(parsed[field.key])
										end
										if parsed[field.key .. "Rotation"] then
											gradientOption:SetRotation(parsed[field.key .. "Rotation"])
										end
										if parsed[field.key .. "Transparency"] then
											gradientOption:SetTransparency(parsed[field.key .. "Transparency"])
										end
									end
								end

								if parsed.Background ~= nil and Library.Options["PanelBackground"] then
									Library.Options["PanelBackground"]:SetValue(backgroundToText(parsed.Background))
								end
								if parsed.BackgroundTransparency and Library.Options["PanelBackgroundTransparency"] then
									Library.Options["PanelBackgroundTransparency"]:SetValue(math.floor(parsed.BackgroundTransparency * 100))
								end
								if parsed.AcrylicNoise and Library.Options["PanelAcrylicNoise"] then
									Library.Options["PanelAcrylicNoise"]:SetValue(math.floor(parsed.AcrylicNoise * 100))
								end
								if parsed.HoverChange and Library.Options["PanelHoverChange"] then
									Library.Options["PanelHoverChange"]:SetValue(math.floor(parsed.HoverChange * 100))
								end

								confirmAndPersistTheme(parsed, "Theme '" .. parsed.Name .. "' imported and saved.")
							end,
						})
					end },
					{ Title = "Confirm", CloseOnClick = true, Callback = function()
						local nameOpt = Library.Options["PanelThemeName"]
						local themeName = resolveThemeName(nameOpt and nameOpt.Value)
						if not themeName then
							library:Notify({ Title = "Theme", Content = "Custom", SubContent = "Enter a theme name first.", Duration = 5 })
							return
						end

						local optionValues = {}
						for key, option in pairs(Library.Options) do
							if key:sub(1, 5) == "Panel" then
								optionValues[key] = option.Value
							end
						end

						local finalTheme = ThemeManager.buildFromCurrentOptions(themeName, optionValues)
						confirmAndPersistTheme(finalTheme, "Theme '" .. finalTheme.Name .. "' saved.")
					end },
				},
			})

			local colorFieldByKey = {}
			for _, field in ipairs(colorFieldDefs) do
				colorFieldByKey[field.key] = field
			end

			local gradientFieldByKey = {}
			for _, field in ipairs(gradientFieldDefs) do
				gradientFieldByKey[field.key] = field
			end

			local panelBuilders = {
				Name = function()
					Panel:AddInput("PanelThemeName", {
						Title = "Theme Name",
						Description = "Name of the custom theme.",
						Default = suggestedName,
						Placeholder = suggestedName,
						Finished = true,
						Callback = function() end,
					})
				end,
				AcrylicNoise = function()
					Panel:AddSlider("PanelAcrylicNoise", {
						Title = "Acrylic Noise",
						Description = "Noise intensity of the acrylic background (0-100).",
						Min = 0,
						Max = 100,
						Default = math.floor((Creator.GetThemeProperty("AcrylicNoise") or 0) * 100),
						Rounding = 0,
						Callback = function() end,
					})
				end,
				Background = function()
					Panel:AddInput("PanelBackground", {
						Title = "Background",
						Description = "Background image asset or URL, or a .lua frame file (local path or URL) for an animated background. Leave empty for none.",
						Placeholder = "rbxassetid://0",
						Finished = true,
						Default = backgroundToText(Creator.GetThemeProperty("Background")),
						Callback = function() end,
					})
				end,
				BackgroundTransparency = function()
					Panel:AddSlider("PanelBackgroundTransparency", {
						Title = "Background Transparency",
						Description = "Transparency of the background (0-100).",
						Min = 0,
						Max = 100,
						Default = math.floor((Creator.GetThemeProperty("BackgroundTransparency") or 0) * 100),
						Rounding = 0,
						Callback = function() end,
					})
				end,
				HoverChange = function()
					Panel:AddSlider("PanelHoverChange", {
						Title = "Hover Intensity",
						Description = "Strength of the hover effect (0-100).",
						Min = 0,
						Max = 100,
						Default = math.floor((Creator.GetThemeProperty("HoverChange") or 0.07) * 100),
						Rounding = 0,
						Callback = function() end,
					})
				end,
			}

			local function buildPanelField(key)
				local builder = panelBuilders[key]
				local colorField = colorFieldByKey[key]
				local gradientField = gradientFieldByKey[key]

				if builder then
					builder()
					return true
				end

				if colorField then
					Panel:AddColorpicker("Panel" .. colorField.key, {
						Title = colorField.title,
						Description = colorField.description,
						Default = Creator.GetThemeProperty(colorField.key),
						Transparency = colorField.transparency and Creator.GetThemeProperty(colorField.transparency) or nil,
						Callback = function() end,
					})
					return true
				end

				if gradientField then
					Panel:AddGradientPicker("Panel" .. gradientField.key, {
						Title = gradientField.title,
						Description = gradientField.description,
						Default = Creator.GetThemeProperty(gradientField.key),
						Rotation = Creator.GetThemeProperty(gradientField.key .. "Rotation"),
						Transparency = Creator.GetThemeProperty(gradientField.key .. "Transparency"),
						Callback = function() end,
					})
					return true
				end

				return false
			end

			local builtFields = {}
			for _, key in ipairs(themePanelOrder) do
				if buildPanelField(key) then
					builtFields[key] = true
				end
			end

			for _, field in ipairs(colorFieldDefs) do
				if not builtFields[field.key] then
					buildPanelField(field.key)
				end
			end
			for _, field in ipairs(gradientFieldDefs) do
				if not builtFields[field.key] then
					buildPanelField(field.key)
				end
			end

			Panel:AddDropdown("PanelCopyFormat", {
				Title = "Color Format",
				Description = "Format of the colors when copying theme data.",
				Values = { "Hex", "RGB", "HSV" },
				Default = 1,
				Multi = false,
				Callback = function() end,
			})

			local function buildShareTheme()
				local nameOpt = Library.Options["PanelThemeName"]
				local shareName = resolveThemeName(nameOpt and nameOpt.Value)
				if not shareName then
					library:Notify({ Title = "Theme", Content = "Copy", SubContent = "Enter a theme name first.", Duration = 5 })
					return nil
				end

				local optionValues = {}
				for key, option in pairs(Library.Options) do
					if key:sub(1, 5) == "Panel" then
						optionValues[key] = option.Value
					end
				end

				local formatOpt = Library.Options["PanelCopyFormat"]
				local format = formatOpt and formatOpt.Value or "Hex"

				return ThemeManager.buildFromCurrentOptions(shareName, optionValues), format
			end

			local function copyText(text, message)
				if setclipboard then
					setclipboard(text)
					library:Notify({ Title = "Theme", Content = "Copy", SubContent = message, Duration = 5 })
				else
					library:Notify({ Title = "Theme", Content = "Copy", SubContent = "Your executor does not support setclipboard.", Duration = 5 })
				end
			end

			Panel:AddButton({
				Title = "Copy Theme Data",
				Description = "Copies this theme so it can be pasted into Import, or shared with others.",
				Icon = Library.InternalIcons.Copy,
				Callback = function()
					local shareTheme, format = buildShareTheme()
					if shareTheme then
						copyText(ThemeManager.serializeTheme(shareTheme, format), "Theme data copied. Paste it into Import to share.")
					end
				end,
			})

			Panel:AddButton({
				Title = "Copy AddTheme Code",
				Description = "Copies this theme as a Library:AddTheme call that developers can place in a script.",
				Icon = Library.InternalIcons.Code,
				Callback = function()
					local shareTheme, format = buildShareTheme()
					if shareTheme then
						copyText(ThemeManager.toAddThemeCode(shareTheme, format), "AddTheme code copied.")
					end
				end,
			})

			themeTargetDropdown = Panel:AddDropdown("PanelCustomThemeTarget", {
				Title = "Custom Theme",
				Description = "Pick an existing custom theme, or a built-in theme you overwrote, to delete or overwrite.",
				Values = getCustomThemeNames(),
				Multi = false,
				AllowNull = true,
				Callback = function() end,
			})

			Panel:AddButton({
				Title = "Delete Custom Theme",
				Description = "Deletes the custom theme selected in the dropdown above.",
				Icon = Library.InternalIcons.Trash,
				Callback = function()
					local targetOpt = Library.Options["PanelCustomThemeTarget"]
					local targetLabel = targetOpt and targetOpt.Value
					if not targetLabel or targetLabel == "" then
						library:Notify({ Title = "Theme", Content = "Delete", SubContent = "Select a custom theme to delete first.", Duration = 5 })
						return
					end

					local targetId = themeTargetLabelToId[targetLabel]

					local overrideName
					for builtInName, record in pairs(InterfaceManager.Overrides) do
						if record.Id == targetId then
							overrideName = builtInName
						end
					end

					if overrideName then
						library.Window:Dialog({
							Title = "Delete Override?",
							Content = "This deletes your changes to '" .. overrideName .. "' and restores the original built-in theme.",
							Buttons = {
								{ Title = "Cancel", Callback = function() end },
								{ Title = "Delete", Callback = function()
									InterfaceManager:DeleteCustomTheme(targetId)
									InterfaceManager.Overrides[overrideName] = nil
									library:ResetTheme(overrideName)
									refreshThemeTargetDropdown()
									targetOpt:SetValue(nil)
									library:Notify({ Title = "Theme", Content = "Delete", SubContent = "'" .. overrideName .. "' restored to the built-in theme.", Duration = 5 })
								end },
							},
						})
						return
					end

					if not targetId or not customThemeCards[targetId] then
						library:Notify({ Title = "Theme", Content = "Delete", SubContent = "Could not find that custom theme.", Duration = 5 })
						return
					end

					local targetName = customThemeCards[targetId].themeData.Name

					library.Window:Dialog({
						Title = "Delete Theme?",
						Content = "This permanently deletes '" .. targetName .. "'. This can't be undone.",
						Buttons = {
							{ Title = "Cancel", Callback = function() end },
							{ Title = "Delete", Callback = function()
								InterfaceManager:DeleteCustomTheme(targetId)

								local existingCard = customThemeCards[targetId]
								if existingCard then
									existingCard.card:Destroy()
									customThemeCards[targetId] = nil
								end

								for i, existingTheme in ipairs(loadedCustomThemes) do
									if existingTheme.Id == targetId then
										table.remove(loadedCustomThemes, i)
										break
									end
								end

								if settings.ActiveCustomTheme == targetId then
									settings.ActiveCustomTheme = nil
									settings.Theme = "Dark"
									Library.CustomThemeData = nil
									library:SetTheme("Dark")
									currentSelectedName = "Dark"
									InterfaceManager:SaveSettings()
									setSelectedCard("Dark")
								end

								refreshThemeTargetDropdown()
								targetOpt:SetValue(nil)

								library:Notify({ Title = "Theme", Content = "Delete", SubContent = "Theme '" .. targetName .. "' deleted.", Duration = 5 })
							end },
						},
					})
				end,
			})

			Panel:AddButton({
				Title = "Overwrite Selected Theme",
				Description = "Replaces the selected custom theme with the values currently set in this panel.",
				Icon = Library.InternalIcons.Save,
				Callback = function()
					local targetOpt = Library.Options["PanelCustomThemeTarget"]
					local targetLabel = targetOpt and targetOpt.Value
					if not targetLabel or targetLabel == "" then
						library:Notify({ Title = "Theme", Content = "Overwrite", SubContent = "Select a custom theme to overwrite first.", Duration = 5 })
						return
					end

					local targetId = themeTargetLabelToId[targetLabel]

					local overrideName
					for builtInName, record in pairs(InterfaceManager.Overrides) do
						if record.Id == targetId then
							overrideName = builtInName
						end
					end

					if overrideName then
						library.Window:Dialog({
							Title = "Overwrite Theme?",
							Content = "This replaces your changes to '" .. overrideName .. "' with the values currently set in this panel.",
							Buttons = {
								{ Title = "Cancel", Callback = function() end },
								{ Title = "Overwrite", Callback = function()
									local optionValues = {}
									for key, option in pairs(Library.Options) do
										if key:sub(1, 5) == "Panel" then
											optionValues[key] = option.Value
										end
									end
									persistBuiltInOverride(ThemeManager.buildFromCurrentOptions(overrideName, optionValues), overrideName)
									library:Notify({ Title = "Theme", Content = "Overwrite", SubContent = "'" .. overrideName .. "' updated.", Duration = 5 })
								end },
							},
						})
						return
					end

					if not targetId or not customThemeCards[targetId] then
						library:Notify({ Title = "Theme", Content = "Overwrite", SubContent = "Could not find that custom theme.", Duration = 5 })
						return
					end

					local targetName = customThemeCards[targetId].themeData.Name

					library.Window:Dialog({
						Title = "Overwrite Theme?",
						Content = "This replaces '" .. targetName .. "' with the values currently set in this panel. This can't be undone.",
						Buttons = {
							{ Title = "Cancel", Callback = function() end },
							{ Title = "Overwrite", Callback = function()
								local optionValues = {}
								for key, option in pairs(Library.Options) do
									if key:sub(1, 5) == "Panel" then
										optionValues[key] = option.Value
									end
								end

								local overwrittenTheme = ThemeManager.buildFromCurrentOptions(targetName, optionValues)
								persistCustomTheme(overwrittenTheme, true, targetId)

								library:Notify({ Title = "Theme", Content = "Overwrite", SubContent = "Theme '" .. targetName .. "' updated.", Duration = 5 })
							end },
						},
					})
				end,
			})
		end)

		local function getCardColors(themeName)
			local data = Themes[themeName]
			if library.ThemeOverrides[themeName] then
				return resolveCardGradient(data)
			end
			if themeGradients[themeName] then
				return themeGradients[themeName]
			end
			return resolveCardGradient(data)
		end

		local function addBuiltInThemeCard(themeName, idx)
			if themeCards[themeName] then
				themeCards[themeName].card:Destroy()
				themeCards[themeName] = nil
			end

			local colors = getCardColors(themeName)
			local colorA, colorB = colors[1], colors[2]

			local card = New("Frame", {
				Name = "ThemeCard_" .. themeName,
				Size = UDim2.fromOffset(72, 72),
				BackgroundColor3 = colorA,
				BorderSizePixel = 0,
				LayoutOrder = idx,
				Parent = scrollFrame,
				ClipsDescendants = true,
			}, {
				New("UICorner", { CornerRadius = UDim.new(0, 8) }),
				New("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, colorA),
						ColorSequenceKeypoint.new(1, colorB),
					}),
					Rotation = 135,
				}),
			})

			New("TextLabel", {
				Text = themeName,
				FontFace = Font.new(Library.Font, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
				TextSize = 9,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextStrokeTransparency = 0.4,
				TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
				TextXAlignment = Enum.TextXAlignment.Center,
				Size = UDim2.new(1, -4, 0, 14),
				Position = UDim2.new(0, 2, 1, -16),
				BackgroundTransparency = 1,
				ZIndex = 3,
				Parent = card,
			})

			local stroke = New("UIStroke", {
				Thickness = 2,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(70, 70, 70),
				Transparency = 0.7,
				Parent = card,
			})

			local checkBadge = New("Frame", {
				Size = UDim2.fromOffset(18, 18),
				Position = UDim2.fromOffset(5, 5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 4,
				Visible = false,
				Parent = card,
			}, {
				New("UICorner", { CornerRadius = UDim.new(1, 0) }),
			})

			New("ImageLabel", {
				Size = UDim2.fromOffset(10, 10),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = "rbxassetid://93898873302694",
				ImageColor3 = Color3.fromRGB(20, 20, 20),
				ZIndex = 5,
				Parent = checkBadge,
			})

			themeCards[themeName] = {
				card = card,
				stroke = stroke,
				checkBadge = checkBadge,
			}

			local hitBox = New("TextButton", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",
				ZIndex = 6,
				Parent = card,
			})

			Creator.AttachCardHover(card, hitBox)

			Creator.AddSignal(hitBox.MouseEnter, function()
				if currentSelectedName ~= themeName then
					stroke.Transparency = 0.4
				end
			end)
			Creator.AddSignal(hitBox.MouseLeave, function()
				if currentSelectedName ~= themeName then
					stroke.Transparency = 0.7
				end
			end)
			Creator.AddSignal(hitBox.MouseButton1Click, function()
				library:SetTheme(themeName)
				currentSelectedName = themeName
				settings.Theme = themeName
				settings.ActiveCustomTheme = nil
				InterfaceManager:SaveSettings()
				setSelectedCard(themeName)
			end)
		end

		for idx, themeName in ipairs(library.Themes) do
			addBuiltInThemeCard(themeName, idx)
		end

		library.OnThemeAdded = function(themeName)
			addBuiltInThemeCard(themeName, table.find(library.Themes, themeName))
			setSelectedCard(currentSelectedName)
		end

		for cIdx, themeData in ipairs(loadedCustomThemes) do
			addCustomThemeCard(themeData, 1000 + cIdx)
		end

		setSelectedCard(currentSelectedName)

		local themePickerProxy = {
			Type = "Dropdown",
			Value = currentSelectedName,
		}
		function themePickerProxy:SetValue(value)
			if table.find(library.Themes, value) then
				library:SetTheme(value)
				currentSelectedName = value
				settings.Theme = value
				settings.ActiveCustomTheme = nil
				InterfaceManager:SaveSettings()
				setSelectedCard(value)
				self.Value = value
			end
		end
		Library.Options["InterfaceTheme"] = themePickerProxy

		section:AddToggle("KeepWindowInsideFrameToggle", {
			Title = "Keep Window Inside Frame",
			Description = "Prevents the window from being dragged or resized outside its parent frame.",
			Default = settings.KeepWindowInsideFrame,
			LayoutOrder = 6,
			Icon = "rbxassetid://81973586053257",
			Callback = function(value)
				library:ToggleKeepWindowInsideFrame(value)
				settings.KeepWindowInsideFrame = value
				InterfaceManager:SaveSettings()
			end,
		})

		local uiFonts = {
			{ name = "Gotham", asset = "rbxasset://fonts/families/GothamSSm.json", weight = Enum.FontWeight.Medium, label = "Ab" },
			{ name = "Jura", asset = "rbxasset://fonts/families/Jura.json", weight = Enum.FontWeight.SemiBold, label = "Cd" },
			{ name = "Ubuntu", asset = "rbxasset://fonts/families/Ubuntu.json", weight = Enum.FontWeight.Medium, label = "Ef" },
			{ name = "Sarpanch", asset = "rbxasset://fonts/families/Sarpanch.json", weight = Enum.FontWeight.Regular, label = "Gh" },
			{ name = "Nunito", asset = "rbxasset://fonts/families/Nunito.json", weight = Enum.FontWeight.SemiBold, label = "Ij" },
			{ name = "Oswald", asset = "rbxasset://fonts/families/Oswald.json", weight = Enum.FontWeight.Medium, label = "Kl" },
			{ name = "Balthazar", asset = "rbxasset://fonts/families/Balthazar.json", weight = Enum.FontWeight.Regular, label = "Mn" },
			{ name = "Arimo", asset = "rbxasset://fonts/families/Arimo.json", weight = Enum.FontWeight.Medium, label = "Op" },
			{ name = "Builder Sans", asset = "rbxasset://fonts/families/BuilderSans.json", weight = Enum.FontWeight.SemiBold, label = "Qr" },
			{ name = "Silkscreen", asset = "rbxassetid://12187371840", weight = Enum.FontWeight.Regular, label = "St" },
		}

		local fontWrapper = New("Frame", {
			Name = "FontPickerWrapper",
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 0.89,
			BackgroundColor3 = Color3.fromRGB(130, 130, 130),
			LayoutOrder = 7,
			Parent = section.Container,
			ThemeTag = {
				BackgroundColor3 = "Element",
				BackgroundTransparency = "ElementTransparency",
			},
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 4) }),
			New("UIStroke", {
				Transparency = 0.5,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				ThemeTag = { Color = "ElementBorder", Transparency = "ElementBorderTransparency" },
			}),
		})

		New("ImageLabel", {
			Image = "rbxassetid://133543553793564",
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.fromOffset(10, 9),
			BackgroundTransparency = 1,
			ZIndex = 2,
			ThemeTag = { ImageColor3 = "Text" },
			Parent = fontWrapper,
		})

		New("TextLabel", {
			Text = "UI Font",
			FontFace = Font.new(Library.Font, Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 0, 14),
			Position = UDim2.fromOffset(32, 10),
			BackgroundTransparency = 1,
			ThemeTag = { TextColor3 = "Text" },
			Parent = fontWrapper,
		})

		New("TextLabel", {
			Text = "Changes the font used across all UI.",
			FontFace = Font.new(Library.Font),
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -40, 0, 14),
			Position = UDim2.fromOffset(32, 26),
			BackgroundTransparency = 1,
			ThemeTag = { TextColor3 = "SubText" },
			Parent = fontWrapper,
		})

		local fontScrollFrame = New("ScrollingFrame", {
			Name = "FontCardScroll",
			Size = UDim2.new(1, -20, 0, 92),
			Position = UDim2.fromOffset(10, 46),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			CanvasSize = UDim2.fromScale(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			Parent = fontWrapper,
		}, {
			New("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, 4),
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 2),
				PaddingRight = UDim.new(0, 2),
			}),
		})

		local fontCards = {}

		local function setSelectedFont(selectedAsset)
			for asset, cardData in pairs(fontCards) do
				local isSelected = asset == selectedAsset
				cardData.stroke.Transparency = isSelected and 0.1 or 0.7
				cardData.stroke.Color = isSelected
					and Creator.GetThemeProperty("Accent")
					or Color3.fromRGB(70, 70, 70)
				cardData.checkBadge.Visible = isSelected
			end
		end

		local uiFontByName = {}
		for idx, f in ipairs(uiFonts) do
			f.key = f.asset
			f.order = idx
			uiFontByName[f.name] = f
		end

		local customFontData = {}
		local customFontOrder = 100

		local function addFontCard(fontData, layoutOrder)
			local fontCard = New("Frame", {
				Name = "FontCard_" .. fontData.name,
				Size = UDim2.fromOffset(72, 72),
				BackgroundTransparency = 0.89,
				BackgroundColor3 = Color3.fromRGB(130, 130, 130),
				BorderSizePixel = 0,
				LayoutOrder = layoutOrder,
				Parent = fontScrollFrame,
				ClipsDescendants = true,
				ThemeTag = {
					BackgroundColor3 = "Element",
					BackgroundTransparency = "ElementTransparency",
				},
			}, {
				New("UICorner", { CornerRadius = UDim.new(0, 8) }),
			})

			New("TextLabel", {
				Text = fontData.label,
				FontFace = Font.new(fontData.asset, fontData.weight, fontData.style or Enum.FontStyle.Normal),
				IgnoreFontUpdate = true,
				TextSize = 26,
				TextColor3 = Color3.fromRGB(240, 240, 240),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, 0, 0, 44),
				Position = UDim2.fromOffset(0, 6),
				BackgroundTransparency = 1,
				ZIndex = 2,
				ThemeTag = { TextColor3 = "Text" },
				Parent = fontCard,
			})

			New("TextLabel", {
				Text = fontData.name,
				FontFace = Font.new(fontData.asset, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				IgnoreFontUpdate = true,
				TextSize = 9,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				TextXAlignment = Enum.TextXAlignment.Center,
				Size = UDim2.new(1, -4, 0, 14),
				Position = UDim2.new(0, 2, 1, -16),
				BackgroundTransparency = 1,
				ZIndex = 2,
				ThemeTag = { TextColor3 = "SubText" },
				Parent = fontCard,
			})

			local fontStroke = New("UIStroke", {
				Thickness = 2,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(70, 70, 70),
				Transparency = 0.7,
				Parent = fontCard,
			})

			local fontCheckBadge = New("Frame", {
				Size = UDim2.fromOffset(18, 18),
				Position = UDim2.fromOffset(5, 5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				ZIndex = 4,
				Visible = false,
				Parent = fontCard,
			}, {
				New("UICorner", { CornerRadius = UDim.new(1, 0) }),
			})

			New("ImageLabel", {
				Size = UDim2.fromOffset(10, 10),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = "rbxassetid://93898873302694",
				ImageColor3 = Color3.fromRGB(20, 20, 20),
				ZIndex = 5,
				Parent = fontCheckBadge,
			})

			local cardData = {
				card = fontCard,
				stroke = fontStroke,
				checkBadge = fontCheckBadge,
			}
			fontCards[fontData.key] = cardData

			local fontHitBox = New("TextButton", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Text = "",
				ZIndex = 6,
				Parent = fontCard,
			})

			Creator.AttachCardHover(fontCard, fontHitBox)

			Creator.AddSignal(fontHitBox.MouseEnter, function()
				if settings.Font ~= fontData.key then
					fontStroke.Transparency = 0.4
				end
			end)
			Creator.AddSignal(fontHitBox.MouseLeave, function()
				if settings.Font ~= fontData.key then
					fontStroke.Transparency = 0.7
				end
			end)
			Creator.AddSignal(fontHitBox.MouseButton1Click, function()
				library:SetFont(fontData.asset)
				settings.Font = fontData.key
				InterfaceManager:SaveSettings()
				setSelectedFont(fontData.key)
			end)

			return cardData
		end

		for idx, fontData in ipairs(uiFonts) do
			addFontCard(fontData, idx)
		end

		local function removeCustomFontCard(id)
			local data = customFontData[id]
			if not data then return end

			local cardData = fontCards[data.key]
			if cardData then
				cardData.card:Destroy()
			end
			fontCards[data.key] = nil
			customFontData[id] = nil
		end

		local function mountCustomFont(entry, asset)
			local id = InterfaceManager:FontId(entry.Name)
			removeCustomFontCard(id)

			customFontOrder = customFontOrder + 1
			local order = customFontOrder

			local fontData = {
				name = entry.Name,
				asset = asset,
				key = id,
				label = "Aa",
				weight = Enum.FontWeight[entry.Weight] or Enum.FontWeight.Regular,
				style = Enum.FontStyle[entry.Style] or Enum.FontStyle.Normal,
				source = entry.AssetId,
			}
			customFontData[id] = fontData
			addFontCard(fontData, order)
			return fontData
		end

		local function upsertCustomFontEntry(entry)
			local id = InterfaceManager:FontId(entry.Name)
			for i, existing in ipairs(settings.CustomFonts) do
				if InterfaceManager:FontId(existing.Name) == id then
					settings.CustomFonts[i] = entry
					return
				end
			end
			table.insert(settings.CustomFonts, entry)
		end

		local function getCustomFontNames()
			local names = {}
			for _, entry in ipairs(settings.CustomFonts) do
				table.insert(names, entry.Name)
			end
			return names
		end

		local function getBaseFont()
			local data = customFontData[settings.Font]
			if data then
				return {
					Name = data.name,
					Weight = data.weight.Name,
					Style = data.style.Name,
					AssetId = data.source,
				}
			end
			for _, font in ipairs(uiFonts) do
				if font.key == settings.Font then
					return {
						Name = font.name .. " Custom",
						Weight = font.weight.Name,
						Style = Enum.FontStyle.Normal.Name,
						AssetId = font.asset,
					}
				end
			end
			return { Name = "Custom Font", Weight = "Regular", Style = "Normal", AssetId = "" }
		end

		local function fontNotify(message)
			library:Notify({ Title = "Font", Content = "Custom", SubContent = message, Duration = 5 })
		end

		local function confirmCustomFont(Panel)
			local function opt(key)
				local o = Library.Options[key]
				return o and o.Value
			end
			local function trim(s)
				return tostring(s or ""):match("^%s*(.-)%s*$")
			end

			local name = trim(opt("FontPanelName"))
			local assetId = trim(opt("FontPanelAssetId"))
			local weight = opt("FontPanelWeight") or "Regular"
			local style = opt("FontPanelStyle") or "Normal"

			if name == "" then
				return fontNotify("Enter a font name first.")
			end
			if assetId == "" then
				return fontNotify("Enter an Asset Id first.")
			end
			if uiFontByName[name] then
				return fontNotify("That name is already used by a built-in font.")
			end

			local id = InterfaceManager:FontId(name)

			local entry = { Name = name, Weight = weight, Style = style, AssetId = assetId }

			local ok, asset, err = pcall(InterfaceManager.ResolveCustomFont, InterfaceManager, entry)
			if not ok then
				return fontNotify("Failed to load font: " .. tostring(asset))
			end
			if not asset then
				return fontNotify(err or "Failed to load font.")
			end

			InterfaceManager.CustomFontAssets[id] = asset
			upsertCustomFontEntry(entry)
			mountCustomFont(entry, asset)

			library:SetFont(asset)
			settings.Font = id
			InterfaceManager:SaveSettings()
			setSelectedFont(id)

			Panel:Close()
			fontNotify("Font '" .. name .. "' saved and applied.")
		end

		local function deleteCustomFont(name)
			local id = InterfaceManager:FontId(name)

			for i, entry in ipairs(settings.CustomFonts) do
				if InterfaceManager:FontId(entry.Name) == id then
					table.remove(settings.CustomFonts, i)
					break
				end
			end

			removeCustomFontCard(id)
			InterfaceManager.CustomFontAssets[id] = nil
			InterfaceManager:DeleteCustomFontFile(name)

			if settings.Font == id then
				local default = uiFontByName["Gotham"]
				library:SetFont(default.asset)
				settings.Font = default.key
				setSelectedFont(default.key)
			end
			InterfaceManager:SaveSettings()
		end

		local function openCustomFontPanel()
			local Panel
			local customFontTarget
			local base = getBaseFont()

			Panel = library.Window:SidePanel({
				Title = "Custom Font",
				Description = "Create or import a custom font.",
				Side = "Right",
				Width = 320,
				Buttons = {
					{ Title = "Cancel", CloseOnClick = true, Callback = function() end },
					{ Title = "Import", CloseOnClick = false, Callback = function()
						Panel:PromptImport({
							Title = "Paste font code",
							Placeholder = '{"Name":"Minecraft","Weight":"Regular","Style":"Normal","AssetId":"rbxassetid://0"}',
							Callback = function(rawText)
								if not rawText or rawText:gsub("%s", "") == "" then
									return fontNotify("The pasted text is empty.")
								end

								local parsed = InterfaceManager.ParseFontImport(rawText)
								if not parsed then
									return fontNotify("Invalid font format.")
								end

								for key, value in pairs({
									FontPanelName = parsed.Name,
									FontPanelWeight = parsed.Weight,
									FontPanelStyle = parsed.Style,
									FontPanelAssetId = parsed.AssetId,
								}) do
									if Library.Options[key] then
										Library.Options[key]:SetValue(value)
									end
								end

								confirmCustomFont(Panel)
							end,
						})
					end },
					{ Title = "Confirm", CloseOnClick = false, Callback = function()
						confirmCustomFont(Panel)
					end },
				},
			})

			Panel:AddInput("FontPanelName", {
				Title = "Name",
				Description = "Name shown on the font card.",
				Default = base.Name,
				Placeholder = base.Name,
				Marquee = true,
				Callback = function() end,
			})

			Panel:AddDropdown("FontPanelWeight", {
				Title = "Weight",
				Description = "Weight of the font face.",
				Values = InterfaceManager.FontWeightNames,
				Default = base.Weight,
				Multi = false,
				Callback = function() end,
			})

			Panel:AddDropdown("FontPanelStyle", {
				Title = "Style",
				Description = "Style of the font face.",
				Values = InterfaceManager.FontStyleNames,
				Default = base.Style,
				Multi = false,
				Callback = function() end,
			})

			Panel:AddInput("FontPanelAssetId", {
				Title = "Asset Id",
				Description = "Asset id, file path or URL.",
				Default = base.AssetId,
				Placeholder = base.AssetId,
				Marquee = true,
				Callback = function() end,
			})

			customFontTarget = Panel:AddDropdown("FontPanelCustomTarget", {
				Title = "Custom Font",
				Description = "Pick a custom font to delete.",
				Values = getCustomFontNames(),
				Multi = false,
				AllowNull = true,
				Callback = function() end,
			})

			Panel:AddButton({
				Title = "Copy Font Code",
				Description = "Copies the font in this panel as a code that Import accepts.",
				Icon = Library.InternalIcons.Copy,
				Marquee = true,
				Callback = function()
					local function value(key)
						local option = Library.Options[key]
						return option and option.Value and tostring(option.Value) or ""
					end

					local name = value("FontPanelName"):match("^%s*(.-)%s*$")
					local assetId = value("FontPanelAssetId"):match("^%s*(.-)%s*$")
					if name == "" or assetId == "" then
						return fontNotify("Enter a name and an Asset Id first.")
					end
					if not setclipboard then
						return fontNotify("Your executor does not support setclipboard.")
					end

					local encode = function(text)
						return HttpService:JSONEncode(text)
					end
					setclipboard(string.format(
						'{"Name":%s,"Weight":%s,"Style":%s,"AssetId":%s}',
						encode(name),
						encode(value("FontPanelWeight") ~= "" and value("FontPanelWeight") or "Regular"),
						encode(value("FontPanelStyle") ~= "" and value("FontPanelStyle") or "Normal"),
						encode(assetId)
					))
					fontNotify("Font code copied.")
				end,
			})

			Panel:AddButton({
				Title = "Delete Custom Font",
				Description = "Deletes the custom font selected in the dropdown above.",
				Icon = Library.InternalIcons.Trash,
				Marquee = true,
				Callback = function()
					local targetName = customFontTarget and customFontTarget.Value
					if not targetName or targetName == "" then
						return fontNotify("Select a custom font to delete first.")
					end

					library.Window:Dialog({
						Title = "Delete Font?",
						Content = "This permanently deletes '" .. targetName .. "'. This can't be undone.",
						Buttons = {
							{ Title = "Cancel", Callback = function() end },
							{ Title = "Delete", Callback = function()
								deleteCustomFont(targetName)
								pcall(function()
									customFontTarget:SetValues(getCustomFontNames())
									customFontTarget:SetValue(nil)
								end)
								fontNotify("Font '" .. targetName .. "' deleted.")
							end },
						},
					})
				end,
			})
		end

		local addFontCardButton = New("Frame", {
			Name = "FontCard_AddCustom",
			Size = UDim2.fromOffset(72, 72),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 0,
			Parent = fontScrollFrame,
			ClipsDescendants = true,
			ThemeTag = {
				BackgroundColor3 = "Element",
				BackgroundTransparency = "ElementTransparency",
			},
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, 8) }),
			New("UIStroke", {
				Thickness = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Transparency = 0.5,
				ThemeTag = { Color = "DialogBorder" },
			}),
		})

		local addFontImage = New("ImageLabel", {
			Image = Library.InternalIcons.Plus,
			Size = UDim2.fromOffset(20, 20),
			Position = UDim2.fromScale(0.5, 0.44),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			ZIndex = 3,
			Parent = addFontCardButton,
			ThemeTag = { ImageColor3 = "SubText" },
		})

		New("TextLabel", {
			Text = "Custom",
			FontFace = Font.new(Library.Font, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			TextSize = 9,
			TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.new(1, -4, 0, 14),
			Position = UDim2.new(0, 2, 1, -16),
			BackgroundTransparency = 1,
			ZIndex = 3,
			Parent = addFontCardButton,
			ThemeTag = { TextColor3 = "SubText" },
		})

		local addFontHitBox = New("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			ZIndex = 6,
			Parent = addFontCardButton,
		})

		Creator.AttachCardHover(addFontCardButton, addFontHitBox)

		Creator.AddSignal(addFontHitBox.MouseEnter, function()
			addFontCardButton.UIStroke.Transparency = 0.2
		end)
		Creator.AddSignal(addFontHitBox.MouseLeave, function()
			addFontCardButton.UIStroke.Transparency = 0.5
		end)
		Creator.AddSignal(addFontHitBox.MouseButton1Click, openCustomFontPanel)
		for _, entry in ipairs(settings.CustomFonts) do
			local asset = InterfaceManager.CustomFontAssets[InterfaceManager:FontId(entry.Name)]
			if asset then
				mountCustomFont(entry, asset)
			end
		end

		for _, entry in ipairs(Library.AddedFonts) do
			local asset = InterfaceManager.CustomFontAssets[InterfaceManager:FontId(entry.Name)]
			if asset then
				mountCustomFont(entry, asset)
			end
		end

		library.OnFontAdded = function(entry)
			local asset = resolveAddedFont(entry)
			if not asset then
				return
			end
			mountCustomFont(entry, asset)
			if entry.Select then
				local id = InterfaceManager:FontId(entry.Name)
				library:SetFont(asset)
				settings.Font = id
				InterfaceManager:SaveSettings()
				setSelectedFont(id)
			end
		end

		settings.Font = settings.Font or Library.Font
		setSelectedFont(settings.Font)

		Creator.OnThemeChanged(function()
			setSelectedCard(settings.Theme)
			setSelectedFont(settings.Font)
		end)

		if library.UseAcrylic then
			section:AddToggle("AcrylicToggle", {
				Title = "Acrylic",
				Description = "The blurred background requires graphic quality 8+",
				Default = settings.Acrylic,
				LayoutOrder = 2,
				Icon = "rbxassetid://81973586053257",
				Callback = function(value)
					library:ToggleAcrylic(value)
					settings.Acrylic = value
					InterfaceManager:SaveSettings()
				end,
			})
		end

		section:AddSlider("TransparencySlider", {
			Title = "Transparency",
			Description = "Adjusts the interface transparency.",
			Default = settings.Transparency,
			Min = 0,
			Max = 100,
			Rounding = 0,
			LayoutOrder = 3,
			Icon = "rbxassetid://100033680381365",
			Callback = function(value)
				library:SetTransparency(value / 100)
				settings.Transparency = value
				InterfaceManager:SaveSettings()
			end,
		})

		local menuKeybind = section:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = settings.MenuKeybind, LayoutOrder = 4, Icon = "rbxassetid://121474456068237" })
		menuKeybind:OnChanged(function()
			settings.MenuKeybind = menuKeybind.Value
			InterfaceManager:SaveSettings()
		end)
		library.MinimizeKeybind = menuKeybind

		section:AddToggle("ShowUserInfoToggle", {
			Title = "Show User Info",
			Description = "Toggles the avatar and username block in the sidebar.",
			Default = settings.ShowUserInfo,
			LayoutOrder = 5,
			Icon = "rbxassetid://136220511671311",
			Callback = function(value)
				library:ToggleUserInfo(value)
				settings.ShowUserInfo = value
				InterfaceManager:SaveSettings()
			end,
		})

		section:AddToggle("DisableBackgroundToggle", {
			Title = "Disable Background",
			Description = "Hides the window background.",
			Default = settings.DisableBackground,
			LayoutOrder = 8,
			Icon = "rbxassetid://81934811700938",
			Callback = function(value)
				library:ToggleBackground(value)
				settings.DisableBackground = value
				InterfaceManager:SaveSettings()
			end,
		})

		InterfaceManager.Building = false
	end
end

local SaveManager = {} do
	SaveManager.Folder = "FluentReimaginedSettings"
	SaveManager.Ignore = {}
	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object)
				return { type = "Toggle", idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Slider = {
			Save = function(idx, object)
				return { type = "Slider", idx = idx, value = tostring(object.Value) }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Dropdown = {
			Save = function(idx, object)
				return { type = "Dropdown", idx = idx, value = object.Value, mutli = object.Multi }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Colorpicker = {
			Save = function(idx, object)
				return { type = "Colorpicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
				end
			end,
		},
		Keybind = {
			Save = function(idx, object)
				return { type = "Keybind", idx = idx, mode = object.Mode, key = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.key, data.mode)
				end
			end,
		},
		Input = {
			Save = function(idx, object)
				return { type = "Input", idx = idx, text = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] and type(data.text) == "string" then
					SaveManager.Options[idx]:SetValue(data.text)
				end
			end,
		},
	}

	function SaveManager:SetIgnoreIndexes(list)
		for _, key in next, list do
			self.Ignore[key] = true
		end
	end

	function SaveManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function SaveManager:Save(name)
		if not name then
			return false, "no config file is selected"
		end

		local fullPath = self.Folder .. "/settings/" .. name .. ".json"

		local data = { objects = {} }

		for idx, option in next, SaveManager.Options do
			if not self.Parser[option.Type] then continue end
			if self.Ignore[idx] then continue end

			table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
		end

		local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
		if not success then
			return false, "failed to encode data"
		end

		writefile(fullPath, encoded)
		return true
	end

	function SaveManager:Load(name)
		if not name then
			return false, "no config file is selected"
		end

		local file = self.Folder .. "/settings/" .. name .. ".json"
		if not isfile(file) then return false, "invalid file" end

		local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
		if not success then return false, "decode error" end

		for _, option in next, decoded.objects do
			if self.Parser[option.type] then
				task.spawn(function() self.Parser[option.type].Load(option.idx, option) end)
			end
		end

		return true
	end

	function SaveManager:Delete(name)
		if not name then
			return false, "no config file is selected"
		end

		local file = self.Folder .. "/settings/" .. name .. ".json"
		if not isfile(file) then
			return false, "invalid file"
		end

		delfile(file)
		return true
	end

	function SaveManager:IgnoreThemeSettings()
		self:SetIgnoreIndexes({
			"InterfaceTheme",
			"AcrylicToggle",
			"TransparencySlider",
			"MenuKeybind",
			"ShowUserInfoToggle",
			"DisableBackgroundToggle",
			"PanelThemeName",
			"PanelCopyFormat",
			"PanelAccent",
			"PanelAcrylicMain",
			"PanelAcrylicBorder",
			"PanelAcrylicGradient",
			"PanelMenuBackground",
			"PanelMenuBorder",
			"PanelMenuHolder",
			"PanelMenuHolderLine",
			"PanelMenuButton",
			"PanelMenuButtonBorder",
			"PanelMenuInput",
			"PanelMenuInputLine",
			"PanelMenuInputFocused",
			"PanelAcrylicNoise",
			"PanelBackground",
			"PanelBackgroundTransparency",
			"PanelTitleBarLine",
			"PanelTab",
			"PanelElement",
			"PanelElementBorder",
			"PanelInElementBorder",
			"PanelToggleSlider",
			"PanelToggleToggled",
			"PanelSliderRail",
			"PanelDropdownFrame",
			"PanelDropdownHolder",
			"PanelDropdownBorder",
			"PanelDropdownOption",
			"PanelKeybind",
			"PanelInput",
			"PanelInputFocused",
			"PanelInputIndicator",
			"PanelDialog",
			"PanelDialogHolder",
			"PanelDialogHolderLine",
			"PanelDialogButton",
			"PanelDialogButtonBorder",
			"PanelDialogBorder",
			"PanelDialogInput",
			"PanelDialogInputLine",
			"PanelDialogInputFocused",
			"PanelColorpickerDialog",
			"PanelColorpickerDialogBorder",
			"PanelColorpickerHolder",
			"PanelColorpickerHolderLine",
			"PanelColorpickerButton",
			"PanelColorpickerButtonBorder",
			"PanelColorpickerInput",
			"PanelColorpickerInputLine",
			"PanelColorpickerInputBorder",
			"PanelColorpickerInputFocused",
			"PanelText",
			"PanelSubText",
			"PanelHover",
			"PanelHoverChange",
			"PanelCustomThemeTarget",
		})
	end

	function SaveManager:BuildFolderTree()
		local paths = { self.Folder, self.Folder .. "/settings" }

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function SaveManager:RefreshConfigList()
		local list = listfiles(self.Folder .. "/settings")

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == ".json" then
				local pos = file:find(".json", 1, true)
				local start = pos

				local char = file:sub(pos, pos)
				while char ~= "/" and char ~= "\\" and char ~= "" do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == "/" or char == "\\" then
					local name = file:sub(pos + 1, start - 1)
					if name ~= "options" then
						table.insert(out, name)
					end
				end
			end
		end

		return out
	end

	function SaveManager:SetLibrary(library)
		self.Library = library
		self.Options = library.Options
	end

	function SaveManager:LoadAutoloadConfig()
		if isfile(self.Folder .. "/settings/autoload.txt") then
			local name = readfile(self.Folder .. "/settings/autoload.txt")

			local success, err = self:Load(name)
			if not success then
				return self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = "Failed to load autoload config: " .. err,
					Duration = 7,
				})
			end

			self.Library:Notify({
				Title = "Interface",
				Content = "Config loader",
				SubContent = string.format("Auto loaded config %q", name),
				Duration = 7,
			})
		end
	end

	function SaveManager:BuildConfigSection(tab)
		assert(self.Library, "Must set SaveManager.Library")

		local section = tab:AddSection("Configuration")

		section:AddInput("SaveManager_ConfigName", { Title = "Config name", Icon = Library.InternalIcons.TextCursorInput })
		section:AddDropdown("SaveManager_ConfigList", { Title = "Config list", Values = self:RefreshConfigList(), AllowNull = true, Icon = Library.InternalIcons.FolderOpen })

		section:AddButton({
			Title = "Create config",
			Icon = Library.InternalIcons.Save,
			Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigName.Value

				if name:gsub(" ", "") == "" then
					return self.Library:Notify({
						Title = "Interface",
						Content = "Config loader",
						SubContent = "Invalid config name (empty)",
						Duration = 7,
					})
				end

				local success, err = self:Save(name)
				if not success then
					return self.Library:Notify({
						Title = "Interface",
						Content = "Config loader",
						SubContent = "Failed to save config: " .. err,
						Duration = 7,
					})
				end

				self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = string.format("Created config %q", name),
					Duration = 7,
				})

				SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
				SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
			end,
		})

		section:AddButton({
			Title = "Load config",
			Icon = Library.InternalIcons.Download,
			Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigList.Value

				local success, err = self:Load(name)
				if not success then
					return self.Library:Notify({
						Title = "Interface",
						Content = "Config loader",
						SubContent = "Failed to load config: " .. err,
						Duration = 7,
					})
				end

				self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = string.format("Loaded config %q", name),
					Duration = 7,
				})
			end,
		})

		section:AddButton({
			Title = "Overwrite config",
			Icon = Library.InternalIcons.SaveAll,
			Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigList.Value
				if not name then
					return self.Library:Notify({
						Title = "Interface",
						Content = "Config loader",
						SubContent = "No config selected",
						Duration = 7,
					})
				end

				self.Library.Window:Dialog({
					Title = "Overwrite Config?",
					Content = "This replaces the saved config " .. string.format("%q", name) .. " with your current settings. This can't be undone.",
					Buttons = {
						{ Title = "Cancel", Callback = function() end },
						{ Title = "Overwrite", Callback = function()
							local success, err = self:Save(name)
							if not success then
								return self.Library:Notify({
									Title = "Interface",
									Content = "Config loader",
									SubContent = "Failed to overwrite config: " .. err,
									Duration = 7,
								})
							end

							self.Library:Notify({
								Title = "Interface",
								Content = "Config loader",
								SubContent = string.format("Overwrote config %q", name),
								Duration = 7,
							})
						end },
					},
				})
			end,
		})

		section:AddButton({
			Title = "Delete config",
			Icon = Library.InternalIcons.Trash,
			Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigList.Value
				if not name then
					return self.Library:Notify({
						Title = "Interface",
						Content = "Config loader",
						SubContent = "No config selected",
						Duration = 7,
					})
				end

				self.Library.Window:Dialog({
					Title = "Delete Config?",
					Content = "This permanently deletes the config " .. string.format("%q", name) .. ". This can't be undone.",
					Buttons = {
						{ Title = "Cancel", Callback = function() end },
						{ Title = "Delete", Callback = function()
							local success, err = self:Delete(name)
							if not success then
								return self.Library:Notify({
									Title = "Interface",
									Content = "Config loader",
									SubContent = "Failed to delete config: " .. err,
									Duration = 7,
								})
							end

							self.Library:Notify({
								Title = "Interface",
								Content = "Config loader",
								SubContent = string.format("Deleted config %q", name),
								Duration = 7,
							})

							SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
							SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
						end },
					},
				})
			end,
		})

		section:AddButton({
			Title = "Refresh list",
			Icon = Library.InternalIcons.Refresh,
			Callback = function()
				SaveManager.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
				SaveManager.Options.SaveManager_ConfigList:SetValue(nil)
			end,
		})

		local autoloadButton
		autoloadButton = section:AddButton({
			Title = "Set as autoload",
			Description = "Current autoload config: none",
			Icon = Library.InternalIcons.Pin,
			Callback = function()
				local name = SaveManager.Options.SaveManager_ConfigList.Value
				writefile(self.Folder .. "/settings/autoload.txt", name)
				autoloadButton:SetDesc("Current autoload config: " .. name)
				self.Library:Notify({
					Title = "Interface",
					Content = "Config loader",
					SubContent = string.format("Set %q to auto load", name),
					Duration = 7,
				})
			end,
		})

		if isfile(self.Folder .. "/settings/autoload.txt") then
			local name = readfile(self.Folder .. "/settings/autoload.txt")
			autoloadButton:SetDesc("Current autoload config: " .. name)
		end

		SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })
	end

	SaveManager:BuildFolderTree()
end

if getgenv then
	getgenv().FluentReimagined = Library
end

local Extension = {}

Extension.Creator = Creator
Extension.Flipper = Flipper
Extension.Components = Components
Extension.Library = Library
Extension.New = Creator.New

Extension._CustomThemeTags = {}
Extension._MiddlewareCallbacks = {}
Extension._ExtensionRegistry = {}
Extension._WindowHooks = {}
Extension._TabHooks = {}

function Extension:RegisterElement(ElementDef)
	assert(type(ElementDef) == "table", "RegisterElement: expected table")
	assert(type(ElementDef.__type) == "string", "RegisterElement: missing __type")
	assert(type(ElementDef.New) == "function", "RegisterElement: missing New function")

	local TypeName = ElementDef.__type

	local AddMethod = function(Self, Idx, Config)
		local Def = setmetatable({}, { __index = ElementDef })
		Def.Container = Self.Container
		Def.Type = Self.Type
		Def.ScrollFrame = Self.ScrollFrame
		Def.Library = Library
		Def.Extension = Extension

		local ResolvedConfig = Config
		if ResolvedConfig == nil and type(Idx) == "table" then
			ResolvedConfig = Idx
		end

		if type(ResolvedConfig) == "table" and not ResolvedConfig.LayoutOrder then
			Self._layoutOrder = (Self._layoutOrder or 0) + 1
			ResolvedConfig.LayoutOrder = Self._layoutOrder
		end

		for _, Middleware in next, Extension._MiddlewareCallbacks do
			if Middleware.Type == TypeName or Middleware.Type == "*" then
				ResolvedConfig = Middleware.Fn(ResolvedConfig, Def) or ResolvedConfig
			end
		end

		local Result = Def:New(Idx, ResolvedConfig)

		if Result and type(Result) == "table" then
			Result._extensionType = TypeName
		end

		return Result
	end

	Elements["Add" .. TypeName] = AddMethod
	Elements[TypeName] = AddMethod

	Extension._ExtensionRegistry[TypeName] = ElementDef
end

local OriginalGetThemeProperty = Creator.GetThemeProperty
Creator.GetThemeProperty = function(Property)
	if Extension._CustomThemeTags[Property] ~= nil then
		local CustomData = Library.CustomThemeData
		if CustomData and CustomData[Property] ~= nil then
			return CustomData[Property]
		end
		return Extension._CustomThemeTags[Property]
	end
	return OriginalGetThemeProperty(Property)
end

function Extension:DefineThemeTag(TagName, DefaultValue)
	assert(type(TagName) == "string", "DefineThemeTag: TagName must be string")
	assert(DefaultValue ~= nil, "DefineThemeTag: DefaultValue required")
	Extension._CustomThemeTags[TagName] = DefaultValue
end

function Extension:SetCustomThemeValue(TagName, Value)
	assert(Extension._CustomThemeTags[TagName] ~= nil, "SetCustomThemeValue: '" .. TagName .. "' not defined — call DefineThemeTag first")
	Extension._CustomThemeTags[TagName] = Value
	task.defer(Creator.UpdateTheme)
end

function Extension:GetThemeValue(TagName)
	return Creator.GetThemeProperty(TagName)
end

function Extension:ApplyThemeTag(Object, Tag)
	return Creator.AddThemeObject(Object, Tag)
end

function Extension:OverrideThemeTag(Object, Tag)
	Creator.OverrideTag(Object, Tag)
end

function Extension:RegisterElementMiddleware(ElementType, Fn)
	assert(type(ElementType) == "string", "RegisterElementMiddleware: ElementType must be string")
	assert(type(Fn) == "function", "RegisterElementMiddleware: Fn must be function")
	table.insert(Extension._MiddlewareCallbacks, { Type = ElementType, Fn = Fn })
end

function Extension:RegisterSaveParser(TypeName, Parser)
	assert(type(TypeName) == "string", "RegisterSaveParser: TypeName must be string")
	assert(type(Parser.Save) == "function", "RegisterSaveParser: missing Save")
	assert(type(Parser.Load) == "function", "RegisterSaveParser: missing Load")
	SaveManager.Parser[TypeName] = Parser
end

function Extension:RegisterOption(Idx, Object)
	assert(type(Idx) == "string", "RegisterOption: Idx must be string")
	assert(type(Object) == "table", "RegisterOption: Object must be table")
	assert(type(Object.Type) == "string", "RegisterOption: Object must have .Type")
	Library.Options[Idx] = Object
end

function Extension:IsThemeChanged(Callback)
	return Creator.OnThemeChanged(Callback)
end

function Extension:IsFontChanged(Callback)
	table.insert(Creator.FontChangedCallbacks, Callback)
end

function Extension:RegisterFontObject(Object, Weight, Style)
	Creator.RegisterFontObject(Object, Weight, Style)
end

function Extension:Dialog(Config)
	assert(Library.Window, "Dialog: Window not created yet")
	Library.Window:Dialog(Config)
end

function Extension:SidePanel(Config)
	assert(Library.Window, "SidePanel: Window not created yet")
	return Library.Window:SidePanel(Config)
end

function Extension:IsWindowCreated(Callback)
	if Library.Window then
		Callback(Library.Window)
	else
		table.insert(Extension._WindowHooks, Callback)
	end
end

function Extension:IsTabSelected(Callback)
	table.insert(Extension._TabHooks, Callback)
end

function Extension:SpringMotor(Initial, Object, Property)
	return Creator.SpringMotor(Initial, Object, Property)
end

function Extension:SingleMotor(Initial)
	return Flipper.SingleMotor.new(Initial)
end

function Extension:GroupMotor(Initial)
	return Flipper.GroupMotor.new(Initial)
end

function Extension:Spring(Goal, Config)
	return Flipper.Spring.new(Goal, Config)
end

function Extension:Immediate(Goal)
	return Flipper.Immediate.new(Goal)
end

function Extension:GetRegisteredElements()
	local List = {}
	for TypeName in next, Extension._ExtensionRegistry do
		table.insert(List, TypeName)
	end
	return List
end

local OriginalCreateWindow = Library.CreateWindow
function Library:CreateWindow(Config)
	local Window = OriginalCreateWindow(self, Config)
	for _, Hook in next, Extension._WindowHooks do
		pcall(Hook, Window)
	end
	Extension._WindowHooks = {}

	local OriginalSelectTab = Window.SelectTab
	function Window:SelectTab(Tab)
		local Result = OriginalSelectTab(self, Tab)
		for _, Hook in next, Extension._TabHooks do
			pcall(Hook, Tab, Window)
		end
		return Result
	end

	return Window
end

Library.Extension = Extension

if getgenv then
	getgenv().FluentReimaginedExtension = Extension
end

return Library, SaveManager, InterfaceManager, MediaCache
