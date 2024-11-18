-- GUI Oluşturma
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
local closeButton = Instance.new("TextButton", frame)
local optionsFrame = Instance.new("Frame", frame)
local infoLabel = Instance.new("TextLabel", frame)

-- GUI Özellikleri
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.35, 0, 0.35, 0)
frame.Draggable = true
frame.Active = true
frame.Selectable = true
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.MouseButton1Click:Connect(function() gui:Destroy() end)

optionsFrame.Size = UDim2.new(0, 180, 0, 360)
optionsFrame.Position = UDim2.new(0.4, 0, 0, 40)
optionsFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

infoLabel.Text = "By swenzy\nDiscord: swenzy_x1"
infoLabel.Size = UDim2.new(1, 0, 0, 40)
infoLabel.Position = UDim2.new(0, 0, 0, 0)
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.TextScaled = true
infoLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
infoLabel.BackgroundTransparency = 0.5

-- Buton Oluşturma
local function createButton(text, pos, func)
    local btn = Instance.new("TextButton", frame)
    btn.Text = text
    btn.Size = UDim2.new(0, 100, 0, 40)
    btn.Position = pos
    btn.MouseButton1Click:Connect(func)
end

-- Aimbot ve ESP Bölümleri
local aimbotEnabled = false
local teamCheckEnabled = false
local hitboxEnabled = false
local silentAimEnabled = false
local visibleCheckEnabled = false
local silentAimRadius = 100  -- Silent Aim yuvarlağı başlangıç boyutu
local recoilDisabled = false -- Sekmeme (No Recoil)

-- Visible Check Fonksiyonu
local function isPartVisible(part)
    local camera = game.Workspace.CurrentCamera
    local ray = Ray.new(camera.CFrame.p, (part.Position - camera.CFrame.p).unit * 500)
    local hit, _ = workspace:FindPartOnRay(ray, game.Players.LocalPlayer.Character)
    return hit and hit:IsDescendantOf(part.Parent)
end

-- Aimbot Fonksiyonu
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        game:GetService("RunService").RenderStepped:Connect(function()
            if aimbotEnabled then
                local closestPlayer
                local shortestDistance = math.huge
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                        if teamCheckEnabled and player.Team == game.Players.LocalPlayer.Team then continue end
                        
                        local head = player.Character.Head
                        if not visibleCheckEnabled or isPartVisible(head) then  -- Görünürlük kontrolü
                            local distance = (head.Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                            if distance < shortestDistance then
                                closestPlayer = player
                                shortestDistance = distance
                            end
                        end
                    end
                end
                if closestPlayer and closestPlayer.Character then
                    game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.p, closestPlayer.Character.Head.Position)
                end
            end
        end)
    end
end

-- Team Check Fonksiyonu
local function toggleTeamCheck()
    teamCheckEnabled = not teamCheckEnabled
end

-- Silent Aim Fonksiyonu
local function toggleSilentAim()
    silentAimEnabled = not silentAimEnabled
    if silentAimEnabled then
        print("Silent Aim Açıldı")
        -- Silent Aim için hedef tespiti
        game:GetService("RunService").RenderStepped:Connect(function()
            if silentAimEnabled then
                -- Silent Aim işlevi burada
            end
        end)
    else
        print("Silent Aim Kapandı")
    end
end

-- Hitbox Fonksiyonu
local function toggleHitbox()
    hitboxEnabled = not hitboxEnabled
    if hitboxEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                local root = player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Size = Vector3.new(10, 10, 10)
                    root.Transparency = 0.7
                    root.BrickColor = BrickColor.new("Really black")
                    root.Material = Enum.Material.Neon
                    root.CanCollide = false
                end
            end
        end
    else
        print("Hitbox Kapatıldı")
    end
end

-- Silent Aim Yuvarlağının Boyutu
local function setSilentAimRadius(radius)
    silentAimRadius = radius
    print("Silent Aim Radius:", radius)
end

-- No Recoil (Sekmeme) Fonksiyonu
local function toggleNoRecoil()
    recoilDisabled = not recoilDisabled
    if recoilDisabled then
        print("No Recoil Açıldı")
        -- Recoil sıfırlamak için karakter hareketini sıfırlar
        game:GetService("RunService").RenderStepped:Connect(function()
            if recoilDisabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0) -- Tepmeyi sıfırlar
            end
        end)
    else
        print("No Recoil Kapandı")
    end
end

-- ESP Fonksiyonları
local function enableBoxESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight", player.Character)
            highlight.FillTransparency = 1
            highlight.OutlineColor = Color3.new(1, 0, 0)
        end
    end
end

local function enableSkeletonESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local adorn = Instance.new("BoxHandleAdornment")
                    adorn.Adornee = part
                    adorn.Size = part.Size
                    adorn.Color3 = Color3.new(1, 1, 1)
                    adorn.AlwaysOnTop = true
                    adorn.ZIndex = 1
                    adorn.Parent = part
                end
            end
        end
    end
end

-- Bölümleri Gösterme
local function showOptions(section)
    optionsFrame:ClearAllChildren()
    if section == "ESP" then
        createButton("Box ESP", UDim2.new(0.5, -75, 0, 10), enableBoxESP)
        createButton("Skeleton ESP", UDim2.new(0.5, -75, 0, 60), enableSkeletonESP)
    elseif section == "Aim" then
        createButton("Aimbot ON/OFF", UDim2.new(0.5, -75, 0, 10), toggleAimbot)
        createButton("Team Check", UDim2.new(0.5, -75, 0, 60), toggleTeamCheck)
        createButton("Hitbox", UDim2.new(0.5, -75, 0, 110), toggleHitbox)
        createButton("Silent Aim", UDim2.new(0.5, -75, 0, 160), toggleSilentAim)
        createButton("No Recoil", UDim2.new(0.5, -75, 0, 210), toggleNoRecoil) -- Sekmeme butonu

        local radiusInput = Instance.new("TextBox", optionsFrame)
        radiusInput.Size = UDim2.new(0, 100, 0, 30)
        radiusInput.Position = UDim2.new(0.5, -50, 0, 260)
        radiusInput.PlaceholderText = "Silent Aim Boyut"
        radiusInput.FocusLost:Connect(function()
            local radius = tonumber(radiusInput.Text) or 100
            setSilentAimRadius(radius)
        end)

        local visibleCheckButton = Instance.new("TextButton", optionsFrame)
        visibleCheckButton.Text = "Visible Check"
        visibleCheckButton.Size = UDim2.new(0, 100, 0, 30)
        visibleCheckButton.Position = UDim2.new(0.5, -50, 0, 300)
        visibleCheckButton.MouseButton1Click:Connect(function()
            visibleCheckEnabled = not visibleCheckEnabled
            if visibleCheckEnabled then
                print("Visible Check Açıldı")
            else
                print("Visible Check Kapandı")
            end
        end)
    elseif section == "Speed" then
        local speedInput = Instance.new("TextBox", optionsFrame)
        speedInput.Size = UDim2.new(0, 100, 0, 30)
        speedInput.Position = UDim2.new(0.5, -50, 0, 10)
        speedInput.PlaceholderText = "Hız Girin"
        speedInput.FocusLost:Connect(function()
            local speed = tonumber(speedInput.Text) or 16
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end)
    end
end

-- Ana Menü Butonları
createButton("ESP", UDim2.new(0.05, 0, 0.3, 0), function() showOptions("ESP") end)
createButton("Aim", UDim2.new(0.05, 0, 0.5, 0), function() showOptions("Aim") end)
createButton("Speed", UDim2.new(0.05, 0, 0.7, 0), function() showOptions("Speed") end)

print("GUI yüklendi.")
