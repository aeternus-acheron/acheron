-- REDLINER | Precision Player Training Suite
-- LocalScript for an experience you own or are authorized to modify.
-- Targets active player characters in the experience for debug/testing.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

local GUI_NAME = "RedlinerPlayerPrecisionSuite"

local oldGui = playerGui:FindFirstChild(GUI_NAME)
if oldGui then oldGui:Destroy() end

local settings = {
    ESP = true,
    Names = true,
    ShowFOV = true,
    TargetSelector = true,
    SmoothTrack = false,
    SkipOccluded = true,
    FOV = 130,
    Smoothness = 0.16,
    ColorIndex = 1,
}

local palette = {
    {name = "Cyan", color = Color3.fromRGB(74, 224, 255)},
    {name = "Violet", color = Color3.fromRGB(177, 112, 255)},
    {name = "Lime", color = Color3.fromRGB(154, 255, 111)},
    {name = "Amber", color = Color3.fromRGB(255, 190, 85)},
    {name = "Rose", color = Color3.fromRGB(255, 105, 145)},
}

local function accent()
    return palette[settings.ColorIndex].color
end

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 50
gui.Parent = playerGui

local function make(className, props, parent)
    local obj = Instance.new(className)
    for key, value in pairs(props) do obj[key] = value end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius)}, parent)
end

local function stroke(parent, color, thickness, transparency)
    return make("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
    }, parent)
end

local bg = Color3.fromRGB(15, 18, 26)
local panel = Color3.fromRGB(23, 27, 38)
local panel2 = Color3.fromRGB(31, 36, 49)
local muted = Color3.fromRGB(151, 162, 182)
local white = Color3.fromRGB(240, 245, 255)

local main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(310, 505),
    Position = UDim2.new(0, 26, 0.5, -252),
    BackgroundColor3 = bg,
    BorderSizePixel = 0,
    Active = true,
}, gui)
corner(main, 16)
stroke(main, Color3.fromRGB(65, 78, 101), 1, 0.2)

local top = make("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 82),
    BackgroundColor3 = panel,
    BorderSizePixel = 0,
    Active = true,
}, main)
corner(top, 16)

make("Frame", {
    Position = UDim2.new(0, 0, 1, -16),
    Size = UDim2.new(1, 0, 0, 16),
    BackgroundColor3 = panel,
    BorderSizePixel = 0,
}, top)

local accentBar = make("Frame", {
    Position = UDim2.fromOffset(16, 17),
    Size = UDim2.fromOffset(4, 43),
    BackgroundColor3 = accent(),
    BorderSizePixel = 0,
}, top)
corner(accentBar, 4)

make("TextLabel", {
    Position = UDim2.fromOffset(30, 14),
    Size = UDim2.new(1, -82, 0, 27),
    BackgroundTransparency = 1,
    Text = "REDLINER",
    TextColor3 = white,
    TextSize = 19,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left,
}, top)

make("TextLabel", {
    Position = UDim2.fromOffset(31, 42),
    Size = UDim2.new(1, -85, 0, 20),
    BackgroundTransparency = 1,
    Text = "PRECISION  /  PLAYER ROSTER",
    TextColor3 = muted,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
}, top)

local hideButton = make("TextButton", {
    Position = UDim2.new(1, -43, 0, 19),
    Size = UDim2.fromOffset(27, 27),
    BackgroundColor3 = panel2,
    Text = "—",
    TextColor3 = white,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = true,
}, top)
corner(hideButton, 8)

local statusDot = make("Frame", {
    Position = UDim2.fromOffset(18, 96),
    Size = UDim2.fromOffset(7, 7),
    BackgroundColor3 = Color3.fromRGB(90, 235, 155),
    BorderSizePixel = 0,
}, main)
corner(statusDot, 8)

local statusLabel = make("TextLabel", {
    Position = UDim2.fromOffset(31, 91),
    Size = UDim2.new(1, -45, 0, 18),
    BackgroundTransparency = 1,
    Text = "ROSTER LOBBY  /  SCANNING",
    TextColor3 = muted,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
}, main)

local content = make("Frame", {
    Position = UDim2.fromOffset(14, 119),
    Size = UDim2.new(1, -28, 1, -132),
    BackgroundTransparency = 1,
}, main)
make("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, content)

local function section(labelText)
    local label = make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 17),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = accent(),
        TextSize = 10,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, content)
    return label
end

local function addToggle(labelText, key, description)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 43),
        BackgroundColor3 = panel,
        BorderSizePixel = 0,
        LayoutOrder = #content:GetChildren() + 1,
    }, content)
    corner(row, 9)

    make("TextLabel", {
        Position = UDim2.fromOffset(11, 5),
        Size = UDim2.new(1, -75, 0, 18),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = white,
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    make("TextLabel", {
        Position = UDim2.fromOffset(11, 23),
        Size = UDim2.new(1, -75, 0, 13),
        BackgroundTransparency = 1,
        Text = description or "Toggle feature",
        TextColor3 = muted,
        TextSize = 9,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local toggle = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(45, 24),
        BackgroundColor3 = settings[key] and accent() or panel2,
        Text = settings[key] and "ON" or "OFF",
        TextColor3 = settings[key] and bg or muted,
        TextSize = 9,
        Font = Enum.Font.GothamBlack,
        AutoButtonColor = true,
    }, row)
    corner(toggle, 7)

    toggle.Activated:Connect(function()
        settings[key] = not settings[key]
        toggle.Text = settings[key] and "ON" or "OFF"
        toggle.BackgroundColor3 = settings[key] and accent() or panel2
        toggle.TextColor3 = settings[key] and bg or muted
    end)
    return row
end

local function addControl(labelText, valueText, callback)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = panel,
        BorderSizePixel = 0,
        LayoutOrder = #content:GetChildren() + 1,
    }, content)
    corner(row, 9)

    make("TextLabel", {
        Position = UDim2.fromOffset(11, 0),
        Size = UDim2.new(1, -102, 1, 0),
        BackgroundTransparency = 1,
        Text = labelText,
        TextColor3 = white,
        TextSize = 11,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local button = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0.5, 0),
        Size = UDim2.fromOffset(88, 27),
        BackgroundColor3 = panel2,
        Text = valueText,
        TextColor3 = accent(),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = true,
    }, row)
    corner(button, 7)
    button.Activated:Connect(function()
        local newText = callback()
        button.Text = newText
    end)
    return row
end

section("VISUALS")
addToggle("Player highlights", "ESP", "Highlight user models")
addToggle("Player tags", "Names", "Show label above each user")
addToggle("FOV ring", "ShowFOV", "Display screen-space selection radius")
section("TARGETING")
addToggle("Target selector", "TargetSelector", "Pick closest visible target in ring")
addToggle("Aim assist (Players)", "SmoothTrack", "Smooth camera tracking for players")
addToggle("Require clear sightline", "SkipOccluded", "Ignore targets behind obstacles")
addControl("FOV radius", tostring(settings.FOV) .. " px", function()
    settings.FOV = settings.FOV + 25
    if settings.FOV > 300 then settings.FOV = 75 end
    return tostring(settings.FOV) .. " px"
end)
addControl("Tracking smoothness", tostring(math.floor(settings.Smoothness * 100)) .. "%", function()
    settings.Smoothness = settings.Smoothness + 0.08
    if settings.Smoothness > 0.56 then settings.Smoothness = 0.08 end
    return tostring(math.floor(settings.Smoothness * 100)) .. "%"
end)
addControl("Accent color", palette[settings.ColorIndex].name, function()
    settings.ColorIndex = settings.ColorIndex % #palette + 1
    local c = accent()
    accentBar.BackgroundColor3 = c
    fovStroke.Color = c
    return palette[settings.ColorIndex].name
end)

local footer = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1,
    Text = "AIM ASSIST  •  PLAYERS EDITION",
    TextColor3 = muted,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    LayoutOrder = 999,
}, content)

-- Dragging logic
local dragging, dragInput, dragStart, startPosition
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

top.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
end)

local reopen = make("TextButton", {
    Position = UDim2.new(0, 18, 0.5, -20),
    Size = UDim2.fromOffset(130, 40),
    BackgroundColor3 = panel,
    Text = "OPEN  /  REDLINER",
    TextColor3 = accent(),
    TextSize = 10,
    Font = Enum.Font.GothamBlack,
    Visible = false,
    AutoButtonColor = true,
}, gui)
corner(reopen, 10)
stroke(reopen, accent(), 1, 0.25)

hideButton.Activated:Connect(function()
    main.Visible = false
    reopen.Visible = true
end)
reopen.Activated:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)

local fovCircle = make("Frame", {
    Name = "FOVRing",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(settings.FOV * 2, settings.FOV * 2),
    BackgroundTransparency = 1,
    Visible = settings.ShowFOV,
}, gui)
corner(fovCircle, 1000)
local fovStroke = stroke(fovCircle, accent(), 2, 0.08)

local targetReadout = make("TextLabel", {
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0.5, settings.FOV + 16),
    Size = UDim2.fromOffset(250, 28),
    BackgroundColor3 = bg,
    BackgroundTransparency = 0.1,
    Text = "TARGET  /  NONE",
    TextColor3 = white,
    TextSize = 11,
    Font = Enum.Font.GothamBold,
    Visible = settings.TargetSelector,
}, gui)
corner(targetReadout, 8)
stroke(targetReadout, Color3.fromRGB(65, 78, 101), 1, 0.35)

local targetMarker = make("BillboardGui", {
    Name = "PlayerTargetMarker",
    Size = UDim2.fromOffset(150, 28),
    StudsOffset = Vector3.new(0, 3.2, 0),
    AlwaysOnTop = true,
    Enabled = false,
}, gui)
make("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "LOCKED TARGET",
    TextColor3 = accent(),
    TextStrokeTransparency = 0.2,
    TextSize = 12,
    Font = Enum.Font.GothamBlack,
}, targetMarker)

local tracked = {}

local function clearModel(model)
    local info = tracked[model]
    if info then
        if info.highlight then info.highlight:Destroy() end
        if info.label then info.label:Destroy() end
        tracked[model] = nil
    end
end

local function setupPlayerVisuals(targetPlayer)
    if targetPlayer == player then return end

    local function onCharacterAdded(char)
        clearModel(char)
        local info = {}

        if settings.ESP then
            info.highlight = Instance.new("Highlight")
            info.highlight.Name = "RedlinerPlayerHighlight"
            info.highlight.Adornee = char
            info.highlight.FillColor = accent()
            info.highlight.OutlineColor = accent()
            info.highlight.FillTransparency = 0.72
            info.highlight.OutlineTransparency = 0.05
            info.highlight.DepthMode = Enum.HighlightDepthMode.Occluded
            info.highlight.Parent = gui
        end

        if settings.Names then
            local part = char:WaitForChild("Head", 5) or char:WaitForChild("HumanoidRootPart", 5)
            if part then
                info.label = Instance.new("BillboardGui")
                info.label.Name = "RedlinerPlayerName"
                info.label.Adornee = part
                info.label.Size = UDim2.fromOffset(160, 25)
                info.label.StudsOffset = Vector3.new(0, 2.5, 0)
                info.label.AlwaysOnTop = true
                info.label.Parent = gui

                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.fromScale(1, 1)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = targetPlayer.DisplayName or targetPlayer.Name
                textLabel.TextColor3 = accent()
                textLabel.TextStrokeTransparency = 0.35
                textLabel.TextSize = 12
                textLabel.Font = Enum.Font.GothamBold
                textLabel.Parent = info.label
            end
        end
        tracked[char] = info
    end

    if targetPlayer.Character then
        task.spawn(onCharacterAdded, targetPlayer.Character)
    end
    targetPlayer.CharacterAdded:Connect(onCharacterAdded)
    targetPlayer.CharacterRemoving:Connect(clearModel)
end

for _, p in ipairs(Players:GetPlayers()) do setupPlayerVisuals(p) end
Players.PlayerAdded:Connect(setupPlayerVisuals)

local function hasLineOfSight(targetModel, targetPart)
    if not settings.SkipOccluded then return true end
    camera = Workspace.CurrentCamera
    if not camera then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {player.Character, camera}
    params.IgnoreWater = true
    local origin = camera.CFrame.Position
    local result = Workspace:Raycast(origin, targetPart.Position - origin, params)
    return result == nil or result.Instance:IsDescendantOf(targetModel)
end

RunService.RenderStepped:Connect(function()
    camera = Workspace.CurrentCamera
    if not camera then return end

    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    fovCircle.Position = UDim2.fromOffset(center.X, center.Y)
    fovCircle.Size = UDim2.fromOffset(settings.FOV * 2, settings.FOV * 2)
    fovCircle.Visible = settings.ShowFOV
    fovStroke.Color = accent()
    targetReadout.Visible = settings.TargetSelector
    targetReadout.Position = UDim2.fromOffset(center.X, center.Y + settings.FOV + 16)
    targetReadout.TextColor3 = accent()

    for model, info in pairs(tracked) do
        if not model.Parent then
            clearModel(model)
        else
            if info.highlight then
                info.highlight.Enabled = settings.ESP
                info.highlight.FillColor = accent()
                info.highlight.OutlineColor = accent()
            end
            if info.label then
                info.label.Enabled = settings.Names
                local label = info.label:FindFirstChildOfClass("TextLabel")
                if label then label.TextColor3 = accent() end
            end
        end
    end

    if not settings.TargetSelector then
        targetReadout.Text = "TARGET  /  SELECTOR OFF"
        targetMarker.Enabled = false
        return
    end

    local bestModel, bestPart, bestDistance = nil, nil, settings.FOV
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local char = p.Character
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            local part = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and part and hasLineOfSight(char, part) then
                local point, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen and point.Z > 0 then
                    local distance = (Vector2.new(point.X, point.Y) - center).Magnitude
                    if distance <= bestDistance then
                        bestDistance = distance
                        bestModel = char
                        bestPart = part
                    end
                end
            end
        end
    end

    if bestModel and bestPart then
        local targetPlayer = Players:GetPlayerFromCharacter(bestModel)
        targetReadout.Text = string.format("TARGET  /  %s  /  %.0f PX", targetPlayer and targetPlayer.Name or bestModel.Name, bestDistance)
        targetMarker.Adornee = bestPart
        targetMarker.Enabled = true
        local markerLabel = targetMarker:FindFirstChildOfClass("TextLabel")
        if markerLabel then markerLabel.TextColor3 = accent() end

        if settings.SmoothTrack then
            local desired = CFrame.lookAt(camera.CFrame.Position, bestPart.Position)
            camera.CFrame = camera.CFrame:Lerp(desired, math.clamp(settings.Smoothness, 0.01, 1))
        end
    else
        targetReadout.Text = "TARGET  /  NONE IN FOV"
        targetMarker.Adornee = nil
        targetMarker.Enabled = false
    end
end)

print("Redliner Player Precision Suite Loaded.")
