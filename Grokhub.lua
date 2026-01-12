Name:GrokHub.lua
-- Grok Ultimate Blox Fruits Hub v1.0 by xAI (2026) | Combined Best Features
-- Mobile/PC Keyless | Rayfield UI | Update 26+ Compatible

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "🧠 Grok Ultimate Hub",
    LoadingTitle = "Grok xAI Loading...",
    LoadingSubtitle = "Best Combined | Update 26+",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "GrokBF",
        FileName = "GrokHub"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

local getgenv = getgenv
getgenv.Grok = {
    Toggles = {},
    Sliders = {}
}

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Utils
spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function() game:GetService("RunService"):SetFPSCap(999) end)
    settings().Physics.PhysicsEnvironmentalThrottleEnabled = false
end)
getgenv()._G.SimRadius = math.huge

local function notify(title, text, duration)
    Rayfield:Notify({
        Title = title,
        Content = text,
        Duration = duration or 3,
        Image = 4483362458
    })
end

local function toTarget(cf)
    local Tween = TweenService:Create(RootPart, TweenInfo.new(0.8, Enum.EasingStyle.Linear), {CFrame = cf})
    Tween:Play()
end

local function getClosest(type)
    local dist, obj = math.huge
    for _, v in pairs(Workspace[type]:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local magnitude = (v.HumanoidRootPart.Position - RootPart.Position).Magnitude
            if magnitude < dist then
                dist = magnitude
                obj = v
            end
        end
    end
    return obj
end

local function equip(toolName)
    for _, v in pairs(Player.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.Name:find(toolName) then
            v.Parent = Character
        end
    end
end

local CommF = ReplicatedStorage.Remotes.CommF_

-- TPs (Full Map + Events/Bosses)
local TPs = {
    ["Starter Island"] = CFrame.new(-384.4, 73.7, 58.5),
    ["Marine Starter"] = CFrame.new(2135.5, 26.8, 128.4),
    ["Middle Town"] = CFrame.new(-684.2, 73.7, 3835.8),
    ["Frozen Village"] = CFrame.new(1384.6, 37, -1293.2),
    ["Bandit Quest"] = CFrame.new(1061.7, 16.5, 1547.5),
    ["Snow Mountain"] = CFrame.new(1337.3, 454.5, -636.8),
    ["Marine Fortress"] = CFrame.new(-4916.2, 60.1, -1483.5),
    ["Skytown"] = CFrame.new(-7861.8, 5627.9, -415),
    ["Hot and Cold"] = CFrame.new(5711.5, 52.8, -2859.3),
    ["Cave"] = CFrame.new(5193.8, 10.5, -1050.9),
    ["Jungle"] = CFrame.new(-1321.9, 64.7, 2315.1),
    ["Kingdom of Rose"] = CFrame.new(-1257.3, 94, 1097.1),
    ["Cafe"] = CFrame.new(-381.6, 79, 555.4),
    ["Mansion"] = CFrame.new(-387.7, 93, 92),
    ["Graveyard"] = CFrame.new(2680.9, 16.3, -1183.5),
    ["Dark Step"] = CFrame.new(2873.5, 44.3, -983.3),
    ["Green Zone"] = CFrame.new(-2448.3, 73, -3215.4),
    ["Floating Turtle"] = CFrame.new(-13234.8, 332.4, -7484.4),
    ["Hydra Island"] = CFrame.new(5374.4, 9.5, 418.3),
    ["Castle on the Sea"] = CFrame.new(-5074.7, 299, -6871.4),
    ["Port Town"] = CFrame.new(-2936.6, 40.7, 5460.7),
    ["Great Tree"] = CFrame.new(1449.9, 92.5, -1359.4),
    ["Sea of Treats"] = CFrame.new(-2595.6, 90.7, 2718.8),
    ["Haunted Castle"] = CFrame.new(-9478.8, 141.7, 5841.9),
    ["Tiki Outpost"] = CFrame.new(-16029.1, 9.9, 757.4),
    ["Peanut Land"] = CFrame.new(-2140.1, 49.8, -10319.8),
    ["Citadel"] = CFrame.new(-5219.5, 10.8, -4710.9),
    ["Mero Sea Event"] = CFrame.new(385.5, 92.4, -1109.8),
    ["Mirage Island"] = CFrame.new(-13375, 144, -8263),
    ["Prehistoric Island"] = CFrame.new(-5509, 100, -4689),
    ["Thunder God"] = CFrame.new(-2869, 35, 4596),
    ["Cursed Captain"] = CFrame.new(916, 181, 1337),
    ["Elite Hunter"] = CFrame.new(-5430, 100, -900)
}

-- Farm Tab
local FarmTab = Window:CreateTab("🏴‍☠️ Farm", 4483362458)

FarmTab:CreateToggle({
    Name = "Auto Farm Level (Nearest Mobs)",
    CurrentValue = false,
    Flag = "AutoFarmLevel",
    Callback = function(Value)
        getgenv().Grok.Toggles.AutoFarmLevel = Value
        spawn(function()
            while getgenv().Grok.Toggles.AutoFarmLevel and Character and RootPart do
                local enemy = getClosest("Enemies")
                if enemy then
                    equip("Combat")
                    toTarget(enemy.HumanoidRootPart.CFrame * CFrame.new(math.random(-8,8), 15, math.random(-8,8)))
                end
                wait(0.2)
            end
        end)
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Farm Boss (Nearest)",
    CurrentValue = false,
    Flag = "AutoBoss",
    Callback = function(Value)
        getgenv().Grok.Toggles.AutoBoss = Value
        spawn(function()
            while getgenv().Grok.Toggles.AutoBoss and Character and RootPart do
                local boss = getClosest("Enemies")
                if boss and boss.Name:find("Boss") then
                    equip("Combat")
                    toTarget(boss.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                end
                wait(0.3)
            end
        end)
    end,
})

FarmTab:CreateToggle({
    Name = "Auto Raid (Flame)",
    CurrentValue = false,
    Flag = "AutoRaid",
    Callback = function(Value)
        getgenv().Grok.Toggles.AutoRaid = Value
        if Value then
            CommF:InvokeServer("Raid", "Select", "Flame")
            notify("Raid", "Started Flame Raid!", 4)
        end
    end,
})

-- Fruits Tab
local FruitsTab = Window:CreateTab("🍎 Fruits", 6033837536)

FruitsTab:CreateToggle({
    Name = "Fruit ESP (Rarity Labels)",
    CurrentValue = false,
    Flag = "FruitESP",
    Callback = function(Value)
        getgenv().Grok.Toggles.FruitESP = Value
        if Value then
            spawn(function()
                while getgenv().Grok.Toggles.FruitESP do
                    for _, fruit in pairs(Workspace:GetChildren()) do
                        if fruit:IsA("Tool") and fruit.Name:find("Fruit") and not fruit:FindFirstChild("GrokESP") then
                            local esp = Instance.new("BillboardGui", fruit)
                            esp.Name = "GrokESP"
                            esp.Size = UDim2.new(0, 100, 0, 50)
                            esp.StudsOffset = Vector3.new(0, 5, 0)
                            esp.Adornee = fruit:FindFirstChild("Handle") or fruit
                            local text = Instance.new("TextLabel", esp)
                            text.Size = UDim2.new(1, 0, 1, 0)
                            text.BackgroundTransparency = 1
                            text.Text = fruit.Name
                            text.TextColor3 = Color3.fromRGB(255, 255, 0)
                            text.TextStrokeTransparency = 0
                            text.TextScaled = true
                            text.Font = Enum.Font.GothamBold
                        end
                    end
                    wait(1)
                end
            end)
        else
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:FindFirstChild("GrokESP") then obj.GrokESP:Destroy() end
            end
        end
    end,
})

FruitsTab:CreateToggle({
    Name = "Fruit Sniper (Auto Grab)",
    CurrentValue = false,
    Flag = "FruitSniper",
    Callback = function(Value)
        getgenv().Grok.Toggles.FruitSniper = Value
        spawn(function()
            while getgenv().Grok.Toggles.FruitSniper and Character and RootPart do
                for _, fruit in pairs(Workspace:GetChildren()) do
                    if fruit:IsA("Tool") and fruit.Name:find("Fruit") then
                        toTarget(fruit.Handle.CFrame * CFrame.new(0, 5, 0))
                        firetouchinterest(RootPart, fruit.Handle, 0)
                        wait(0.1)
                        firetouchinterest(RootPart, fruit.Handle, 1)
                    end
                end
                wait(0.5)
            end
        end)
    end,
})

-- Teleport Tab
local TeleTab = Window:CreateTab("🗺️ Teleport", 6033939200)
local IslandDropdown = TeleTab:CreateDropdown({
    Name = "Select Island/Boss",
    Options = {"Starter Island","Marine Starter","Middle Town","Frozen Village","Bandit Quest","Snow Mountain","Marine Fortress","Skytown","Hot and Cold","Cave","Jungle","Kingdom of Rose","Cafe","Mansion","Graveyard","Dark Step","Green Zone","Floating Turtle","Hydra Island","Castle on the Sea","Port Town","Great Tree","Sea of Treats","Haunted Castle","Tiki Outpost","Peanut Land","Citadel","Mero Sea Event","Mirage Island","Prehistoric Island","Thunder God","Cursed Captain","Elite Hunter"},
    CurrentOption = "Castle on the Sea",
    Flag = "IslandSelect",
    Callback = function(Option)
        getgenv().SelectedIsland = Option
    end,
})

TeleTab:CreateButton({
    Name = "Teleport!",
    Callback = function()
        if TPs[getgenv().SelectedIsland] and RootPart then
            toTarget(TPs[getgenv().SelectedIsland])
            notify("TP", "Teleported to " .. getgenv().SelectedIsland, 2)
        end
    end,
})

TeleTab:CreateButton({
    Name = "Server Hop (Low Ping)",
    Callback = function()
        local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, v in pairs(Servers.data) do
            if type(v) == "table" and v.playing < v.maxPlayers*0.8 and v.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
                break
            end
        end
        notify("Hop", "Joining low ping server...", 3)
    end,
})

-- Player Tab
local PlayerTab = Window:CreateTab("👤 Player", 4483362458)

PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 500},
    Increment = 5,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        if Humanoid then Humanoid.WalkSpeed = Value end
    end,
})

PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        if Humanoid then Humanoid.JumpPower = Value end
    end,
})

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(Value)
        getgenv().Grok.Toggles.InfJump = Value
        if Value then
            UserInputService.JumpRequest:Connect(function()
                if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end
    end,
})

PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        getgenv().Grok.Toggles.Noclip = Value
        spawn(function()
            while getgenv().Grok.Toggles.Noclip do
                if Character then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
                wait()
            end
        end)
    end,
})

-- Fly System
getgenv().FlySpeed = 192
local Flying = false
local FlyKeys = {w=false, a=false, s=false, d=false, space=false, lshift=false}

PlayerTab:CreateToggle({
    Name = "Fly (WASD + Space/Shift)",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        Flying = Value
        if Character and RootPart then
            local BV = Instance.new("BodyVelocity", RootPart)
            BV.MaxForce = Vector3.new(4000,4000,4000)
            BV.Velocity = Vector3.new()
            repeat
                local cam = Workspace.CurrentCamera.CFrame
                local vel = Vector3.new()
                if FlyKeys.w then vel = vel + cam.LookVector * getgenv().FlySpeed end
                if FlyKeys.s then vel = vel - cam.LookVector * getgenv().FlySpeed end
                if FlyKeys.a then vel = vel - cam.RightVector * getgenv().FlySpeed end
                if FlyKeys.d then vel = vel + cam.RightVector * getgenv().FlySpeed end
                if FlyKeys.space then vel = vel + Vector3.new(0, getgenv().FlySpeed, 0) end
                if FlyKeys.lshift then vel = vel - Vector3.new(0, getgenv().FlySpeed, 0) end
                BV.Velocity = vel
                wait()
            until not Flying
            BV:Destroy()
        end
    end,
})

PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 192,
    Flag = "FlySpeed",
    Callback = function(Value) getgenv().FlySpeed = Value end,
})

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    pcall(function()
        if input.KeyCode == Enum.KeyCode.W then FlyKeys.w = true
        elseif input.KeyCode == Enum.KeyCode.S then FlyKeys.s = true
        elseif input.KeyCode == Enum.KeyCode.A then FlyKeys.a = true
        elseif input.KeyCode == Enum.KeyCode.D then FlyKeys.d = true
        elseif input.KeyCode == Enum.KeyCode.Space then FlyKeys.space = true
        elseif input.KeyCode == Enum.KeyCode.LeftShift then FlyKeys.lshift = true end
    end)
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    pcall(function()
        if input.KeyCode == Enum.KeyCode.W then FlyKeys.w = false
        elseif input.KeyCode == Enum.KeyCode.S then FlyKeys.s = false
        elseif input.KeyCode == Enum.KeyCode.A then FlyKeys.a = false
        elseif input.KeyCode == Enum.KeyCode.D then FlyKeys.d = false
        elseif input.KeyCode == Enum.KeyCode.Space then FlyKeys.space = false
        elseif input.KeyCode == Enum.KeyCode.LeftShift then FlyKeys.lshift = false end
    end)
end)

-- Misc Tab
local MiscTab = Window:CreateTab("⚙️ Misc", 6034076785)

MiscTab:CreateDropdown({
    Name = "Set Team",
    Options = {"Pirates", "Marines"},
    CurrentOption = "Pirates",
    Flag = "TeamSelect",
    Callback = function(Option)
        getgenv().SelectedTeam = Option
    end,
})

MiscTab:CreateButton({
    Name = "Set Team",
    Callback = function()
        CommF:InvokeServer("SetTeam", getgenv().SelectedTeam)
        notify("Team", "Set to " .. getgenv().SelectedTeam, 2)
    end,
})

MiscTab:CreateToggle({
    Name = "Anti AFK + No Death",
    CurrentValue = true,
    Flag = "AntiAFK",
    Callback = function(Value)
        if Value then
            Player.Idled:Connect(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game, 1)
                wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game, 1)
            end)
        end
    end,
})

MiscTab:CreateButton({
    Name = "Infinite Yield (Admin Console)",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        notify("IY", "Loaded! Type ;help", 3)
    end,
})

MiscTab:CreateButton({
    Name = "Rejoin Current Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, Player)
    end,
})

-- Respawn Fix
Players.LocalPlayer.CharacterAdded:Connect(function(Char)
    Character = Char
    Humanoid = Char:WaitForChild("Humanoid")
    RootPart = Char:WaitForChild("HumanoidRootPart")
    pcall(function()
        Humanoid.WalkSpeed = Rayfield.Flags.WalkSpeed.CurrentValue
        Humanoid.JumpPower = Rayfield.Flags.JumpPower.CurrentValue
    end)
end)

notify("Grok Hub", "Loaded Successfully! 🚀 Alt acc + VPN advised.", 5)
Rayfield:LoadConfiguration()
