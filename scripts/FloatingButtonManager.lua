local HttpService = game:GetService("HttpService")

local FloatingButtonManager = {}
FloatingButtonManager.Folder = "FloatingButtonManager"
FloatingButtonManager.Library = nil
FloatingButtonManager.FloatingButton = nil

local function SerializeUDim2(Value)
    return {
        ScaleX = Value.X.Scale,
        OffsetX = Value.X.Offset,
        ScaleY = Value.Y.Scale,
        OffsetY = Value.Y.Offset,
    }
end

local function DeserializeUDim2(Value)
    return UDim2.new(Value.ScaleX or 0, Value.OffsetX or 0, Value.ScaleY or 0, Value.OffsetY or 0)
end

local function IsBlank(Value)
    return not Value or Value:gsub(" ", "") == ""
end

function FloatingButtonManager:SettingsPath()
    return self.Folder .. "/settings"
end

function FloatingButtonManager:LayoutPath(Name)
    return self:SettingsPath() .. "/" .. Name .. ".json"
end

function FloatingButtonManager:AutoloadPath()
    return self:SettingsPath() .. "/autoload.txt"
end

function FloatingButtonManager:BuildFolderTree()
    for _, Path in ipairs({ self.Folder, self:SettingsPath() }) do
        if not isfolder(Path) then
            makefolder(Path)
        end
    end
end

function FloatingButtonManager:SetLibrary(Library)
    self.Library = Library
end

function FloatingButtonManager:SetFloatingButton(FloatingButton)
    self.FloatingButton = FloatingButton
end

function FloatingButtonManager:SetFolder(Folder)
    self.Folder = Folder
    self:BuildFolderTree()
end

FloatingButtonManager:BuildFolderTree()

function FloatingButtonManager:Notify(Content, SubContent)
    if not self.Library then
        return
    end

    self.Library:Notify({
        Title = "Floating Buttons",
        Content = Content,
        SubContent = SubContent,
        Duration = 5,
    })
end

function FloatingButtonManager:Save(Name)
    if IsBlank(Name) then
        return false, "invalid layout name"
    end

    local Data = {}

    for Idx, Button in pairs(self.FloatingButton.Buttons) do
        if Button.Root.Parent then
            Data[Idx] = {
                Position = SerializeUDim2(Button:GetPosition()),
                Locked = Button:GetLocked(),
            }
        end
    end

    local Encoded, Result = pcall(HttpService.JSONEncode, HttpService, Data)

    if not Encoded then
        return false, "encode failed"
    end

    if not pcall(writefile, self:LayoutPath(Name), Result) then
        return false, "write failed"
    end

    return true
end

function FloatingButtonManager:Load(Name)
    if not Name or Name == "" then
        return false, "no layout selected"
    end

    local Path = self:LayoutPath(Name)

    if not isfile(Path) then
        return false, "no such file"
    end

    local Decoded, Data = pcall(HttpService.JSONDecode, HttpService, readfile(Path))

    if not Decoded or type(Data) ~= "table" then
        return false, "decode failed"
    end

    for Idx, Saved in pairs(Data) do
        local Button = self.FloatingButton.Buttons[Idx]
        local Position = type(Saved) == "table" and (Saved.Position or Saved.position)

        if Button and Position then
            Button:SetPosition(DeserializeUDim2(Position))
        end

        if Button and type(Saved) == "table" and type(Saved.Locked) == "boolean" then
            Button:SetLocked(Saved.Locked, true)
        end
    end

    return true
end

function FloatingButtonManager:RefreshConfigList()
    local Names = {}

    for _, File in ipairs(listfiles(self:SettingsPath())) do
        local Name = File:match("([^/\\]+)%.json$")

        if Name then
            table.insert(Names, Name)
        end
    end

    table.sort(Names)
    return Names
end

function FloatingButtonManager:LoadAutoloadConfig()
    local Path = self:AutoloadPath()

    if not isfile(Path) then
        return
    end

    local Name = readfile(Path)
    local Success, Error = self:Load(Name)

    if not Success then
        return self:Notify("Autoload failed", tostring(Error))
    end

    self:Notify("Layout auto loaded", string.format("%q", Name))
end

function FloatingButtonManager:BuildConfigSection(Tab)
    assert(self.Library, "Must set FloatingButtonManager.Library")
    assert(self.FloatingButton, "Must set FloatingButtonManager.FloatingButton")

    local Library = self.Library
    local Section = Tab:AddSection("Layout")
    local AutoloadPath = self:AutoloadPath()
    local AutoloadButton

    Section:AddInput("FloatingButtonLayoutName", {
        Title = "Layout name",
        Description = "Name for a new layout",
        Variant = "Field",
        Icon = "feather:edit-2",
        Placeholder = "My layout",
        Finished = false,
    })

    Section:AddDropdown("FloatingButtonLayoutList", {
        Title = "Layouts list",
        Description = "Select a saved layout",
        Icon = "tabler:folder-open",
        Variant = "Compact",
        Values = self:RefreshConfigList(),
        AllowNull = true,
    })

    local function Selected()
        return Library.Options.FloatingButtonLayoutList.Value
    end

    local function Refresh()
        Library.Options.FloatingButtonLayoutList:SetValues(self:RefreshConfigList())
        Library.Options.FloatingButtonLayoutList:SetValue(nil)
    end

    local function Confirm(Title, Content, Label, Action)
        Library.Window:Dialog({
            Title = Title,
            Content = Content,
            Buttons = {
                { Title = Label, Variant = "Danger", Callback = Action },
                { Title = "Cancel" },
            },
        })
    end

    local function Overwrite(Name)
        local Success, Error = self:Save(Name)

        if not Success then
            return self:Notify("Failed to overwrite", tostring(Error))
        end

        self:Notify("Layout overwritten", string.format("%q", Name))
    end

    local function Create(Name)
        local Success, Error = self:Save(Name)

        if not Success then
            return self:Notify("Failed to save", tostring(Error))
        end

        self:Notify("Layout saved", string.format("%q", Name))
        Refresh()
    end

    local function Delete(Name)
        local Path = self:LayoutPath(Name)

        if isfile(Path) then
            delfile(Path)
        end

        if isfile(AutoloadPath) and readfile(AutoloadPath) == Name then
            delfile(AutoloadPath)
            AutoloadButton:SetDesc("Current autoload layout: none")
        end

        self:Notify("Layout deleted", string.format("%q", Name))
        Refresh()
    end

    Section:AddButton({
        Title = "Create layout",
        Description = "Save current positions as a new layout",
        Variant = "Primary",
        ButtonText = "Create",
        ButtonIcon = "feather:save",
        Callback = function()
            local Name = Library.Options.FloatingButtonLayoutName.Value

            if IsBlank(Name) then
                return self:Notify("Failed to save", "invalid layout name")
            end

            if isfile(self:LayoutPath(Name)) then
                return Confirm(
                    "Overwrite layout",
                    string.format("Layout %q already exists. Do you want to overwrite it?", Name),
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
        Title = "Load layout",
        Description = "Apply positions from the selected layout",
        Variant = "Tonal",
        ButtonText = "Load",
        ButtonIcon = "feather:download",
        Callback = function()
            local Name = Selected()
            local Success, Error = self:Load(Name)

            if not Success then
                return self:Notify("Failed to load", tostring(Error))
            end

            self:Notify("Layout loaded", string.format("%q", Name))
        end,
    })

    Section:AddButton({
        Title = "Overwrite layout",
        Description = "Replace the selected layout with current positions",
        Variant = "Outline",
        ButtonText = "Overwrite",
        ButtonIcon = "feather:refresh-cw",
        Callback = function()
            local Name = Selected()

            if not Name or Name == "" then
                return self:Notify("Failed to overwrite", "no layout selected")
            end

            Confirm(
                "Overwrite layout",
                string.format("Are you sure you want to overwrite %q with the current positions?", Name),
                "Overwrite",
                function()
                    Overwrite(Name)
                end
            )
        end,
    })

    Section:AddButton({
        Title = "Delete layout",
        Description = "Delete the selected layout",
        Variant = "Danger",
        ButtonText = "Delete",
        ButtonIcon = "tabler:trash",
        Callback = function()
            local Name = Selected()

            if not Name or Name == "" then
                return self:Notify("Failed to delete", "no layout selected")
            end

            Confirm(
                "Delete layout",
                string.format("Are you sure you want to delete %q? This cannot be undone.", Name),
                "Delete",
                function()
                    Delete(Name)
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
        Description = "Current autoload layout: none",
        Variant = "Accent",
        ButtonText = "Toggle",
        ButtonIcon = "tabler:rocket",
        Callback = function()
            local Name = Selected()
            local Current = isfile(AutoloadPath) and readfile(AutoloadPath) or nil

            if Current and (not Name or Name == "" or Name == Current) then
                delfile(AutoloadPath)
                AutoloadButton:SetDesc("Current autoload layout: none")
                return self:Notify("Autoload disabled")
            end

            if not Name or Name == "" then
                return self:Notify("Failed", "no layout selected")
            end

            writefile(AutoloadPath, Name)
            AutoloadButton:SetDesc("Current autoload layout: " .. Name)
            self:Notify("Autoload set", string.format("%q", Name))
        end,
    })

    if isfile(AutoloadPath) then
        AutoloadButton:SetDesc("Current autoload layout: " .. readfile(AutoloadPath))
    end
end

return FloatingButtonManager
