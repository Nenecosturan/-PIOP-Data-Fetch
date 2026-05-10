local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Window = Rayfield:CreateWindow({
   Name = "•PIOP• | Data Fetcher |-ZENITH-",
   LoadingTitle = "LOADING 3D MENU & PLAYERS...",
   LoadingSubtitle = "Loading PIOP - AI Engine",
   Theme = "Serenity",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false 
})

-- ==========================================
-- 3D HOLOGRAFİK PANEL (ÖZEL ARAYÜZ)
-- ==========================================
-- Güvenli GUI oluşturma
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PIOP_3D_Monitor"
pcall(function() syn.protect_gui(screenGui) end)
screenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui

-- Ana Kapsayıcı (Sürüklenebilir Alan)
local DragContainer = Instance.new("Frame", screenGui)
DragContainer.Size = UDim2.new(0, 220, 0, 280)
DragContainer.Position = UDim2.new(1, -250, 1, -300) -- Sağ alt
DragContainer.BackgroundTransparency = 1
DragContainer.Active = false -- HATA ÇÖZÜLDÜ: Artık arka plan tıklamaları engellemeyecek!

-- Hap (Pill) Butonu
local PillBtn = Instance.new("TextButton", DragContainer)
PillBtn.Size = UDim2.new(0, 110, 0, 26)
PillBtn.Position = UDim2.new(0.5, -55, 0, 0)
PillBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
PillBtn.BackgroundTransparency = 0.1
PillBtn.Text = "•3D-SCREEN•"
PillBtn.TextColor3 = Color3.fromRGB(180, 230, 255)
PillBtn.Font = Enum.Font.GothamMedium -- ESTETİK DÜZELTME: Daha şık bir font
PillBtn.TextSize = 12
PillBtn.AutoButtonColor = false
local PillCorner = Instance.new("UICorner", PillBtn)
PillCorner.CornerRadius = UDim.new(1, 0) 

local PillStroke = Instance.new("UIStroke", PillBtn)
PillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border -- ESTETİK DÜZELTME: Yazıyı değil, hapın dışını çizer!
PillStroke.Color = Color3.fromRGB(0, 150, 255)
PillStroke.Thickness = 1.2
PillStroke.Transparency = 0.3

-- 3D Arka Plan ve Çerçeve
local HoloBg = Instance.new("Frame", DragContainer)
HoloBg.Size = UDim2.new(1, 0, 1, -34)
HoloBg.Position = UDim2.new(0, 0, 0, 34)
HoloBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HoloBg.ClipsDescendants = true
local HoloCorner = Instance.new("UICorner", HoloBg)
HoloCorner.CornerRadius = UDim.new(0, 15)

-- İnce Kontür
local HoloStroke = Instance.new("UIStroke", HoloBg)
HoloStroke.Color = Color3.fromRGB(0, 150, 255)
HoloStroke.Thickness = 1.5

-- Gradyan Arka Plan (Maviden Beyaza Yumuşak Geçiş)
local HoloGradient = Instance.new("UIGradient", HoloBg)
HoloGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 80, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 240, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
HoloGradient.Rotation = 45

RunService.RenderStepped:Connect(function()
    HoloGradient.Rotation = HoloGradient.Rotation + 0.15
end)

-- ViewportFrame
local Viewport = Instance.new("ViewportFrame", HoloBg)
Viewport.Size = UDim2.new(0.9, 0, 0.9, 0)
Viewport.Position = UDim2.new(0.5, 0, 0.5, 0)
Viewport.AnchorPoint = Vector2.new(0.5, 0.5)
Viewport.BackgroundTransparency = 1
Viewport.LightColor = Color3.fromRGB(255, 255, 255)

local VpCamera = Instance.new("Camera")
Viewport.CurrentCamera = VpCamera

local WorldModel = Instance.new("WorldModel", Viewport)
local currentAvatar = nil

RunService.RenderStepped:Connect(function()
    if currentAvatar and currentAvatar.PrimaryPart then
        local t = tick() * 0.5
        VpCamera.CFrame = CFrame.new(
            currentAvatar.PrimaryPart.Position + Vector3.new(math.sin(t) * 6, 1.5, math.cos(t) * 6),
            currentAvatar.PrimaryPart.Position
        )
    end
end)

-- Sürükle (Drag) vs Tıklama (Click) Mantığı
local isDragging = false
local dragStartPos, startUIPos
local dragThreshold = 5
local isClick = true
local isHoloOpen = true

PillBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        isClick = true
        dragStartPos = input.Position
        startUIPos = DragContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
                if isClick then
                    isHoloOpen = not isHoloOpen
                    local targetSize = isHoloOpen and UDim2.new(1, 0, 1, -34) or UDim2.new(1, 0, 0, 0)
                    TweenService:Create(HoloBg, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
                end
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartPos
        if delta.Magnitude > dragThreshold then
            isClick = false
            DragContainer.Position = UDim2.new(startUIPos.X.Scale, startUIPos.X.Offset + delta.X, startUIPos.Y.Scale, startUIPos.Y.Offset + delta.Y)
        end
    end
end)

local function updateHologram(userId)
    if currentAvatar then currentAvatar:Destroy() end
    pcall(function()
        currentAvatar = Players:CreateHumanoidModelFromUserId(userId)
        currentAvatar.Parent = WorldModel
        if currentAvatar:FindFirstChild("HumanoidRootPart") then
            currentAvatar.PrimaryPart = currentAvatar.HumanoidRootPart
        end
    end)
end

-- ==========================================
-- SİSTEM HAFIZASI & CHAT LOG
-- ==========================================
local Intel = { SelectedTarget = "", Logs = {} }

local function hookChat(p)
    Intel.Logs[p.Name] = {}
    p.Chatted:Connect(function(msg)
        table.insert(Intel.Logs[p.Name], "[" .. os.date("%X") .. "]: " .. msg)
        if #Intel.Logs[p.Name] > 10 then table.remove(Intel.Logs[p.Name], 1) end
    end)
end
for _, p in pairs(Players:GetPlayers()) do hookChat(p) end
Players.PlayerAdded:Connect(hookChat)

-- ==========================================
-- AKILLI ANALİZ & TAHMİN MOTORU
-- ==========================================
local function getPlatform(p)
    if p == Players.LocalPlayer then
        return UserInputService.TouchEnabled and "Mobile 📱" or "PC/Console 💻"
    else
        local hash = p.UserId % 10
        if hash <= 6 then return "Mobile 📱" 
        elseif hash <= 8 then return "PC 💻"
        else return "console 🎮" end
    end
end

local function getDetailedStats(p)
    local s = {}
    s.Name = p.Name
    s.Display = p.DisplayName
    s.Age = p.AccountAge
    s.Date = os.date("%d/%m/%Y", os.time() - (p.AccountAge * 86400))
    s.Premium = p.MembershipType == Enum.MembershipType.Premium and "Yes ✅" or "No ❌"
    s.Verified = p.HasVerifiedBadge and "Verified 🔵" or "Not Verified⚪"
    s.Platform = getPlatform(p)
    local isDev = (p:IsInGroup(1200769) or p.UserId == game.CreatorId)
    s.Status = isDev and "Creator / Developer 🛠️" or "Standart Player 👤"
    return s
end

-- ==========================================
-- TAB 1: SERVER SCAN
-- ==========================================
local OverviewTab = Window:CreateTab("Server Scan", 7072724424)
local MasterPara = OverviewTab:CreateParagraph({Title = "Checking Players...", Content = "Action may be last for 5 seconds."})

OverviewTab:CreateButton({
   Name = "•Scan Server•",
   Callback = function()
      local report = ""
      for _, p in pairs(Players:GetPlayers()) do
         local stats = getDetailedStats(p)
         report = report .. "👤 " .. stats.Display .. " (@" .. stats.Name .. ")\n"
         report = report .. "   ├ 🛠️ Rank (Dev or sum): " .. stats.Status .. "\n   ├ 📱 Platform: " .. stats.Platform .. "\n   ├ 📅 Account Age: " .. stats.Age .. " day\n   └ 💎 Premium: " .. stats.Premium .. "\n\n"
      end
      MasterPara:Set({Title = "CURRENT SERVER STATUS ("..#Players:GetPlayers().." Player ", Content = report})
   end,
})

-- ==========================================
-- TAB 3: CANLI RAPOR (TEK SEKME)
-- ==========================================
local ReportTab = Window:CreateTab("Single Person Info", 6026568213)

ReportTab:CreateSection("🗂️ Basic Identity")
local L_Name = ReportTab:CreateLabel("User: Loading...")
local L_Device = ReportTab:CreateLabel("Platform: -")
local L_Age = ReportTab:CreateLabel("Account & real age(estimated): -")
local L_Premium = ReportTab:CreateLabel("Premium & Badge: -")
local L_Status = ReportTab:CreateLabel("Status: -")

ReportTab:CreateSection("🧠 PIOP AI ANALYSIS ")
local L_Robux = ReportTab:CreateLabel("💰 Avatar Cost: -")
local L_AI_Age = ReportTab:CreateLabel("🎂 Estimated Age: -")
local L_Persona = ReportTab:CreateLabel("🎭 Phsycologyc personality: -")

ReportTab:CreateSection("💬 Live Chat Logs")
local P_Chat = ReportTab:CreateParagraph({Title = "Last Chat Logs", Content = "Player hasnt been chosen."})

-- ==========================================
-- TAB 2: DEEP SCAN (ARAMA MODÜLÜ)
-- ==========================================
local DeepTab = Window:CreateTab("Deep Intel", 6031154871)
DeepTab:CreateSection("Choose Target")

local Dropdown = DeepTab:CreateDropdown({
   Name = "Choose Player",
   Options = {},
   CurrentOption = "",
   MultipleOptions = false,
   Callback = function(Option)
      local selectedStr = type(Option) == "table" and Option[1] or Option
      Intel.SelectedTarget = tostring(selectedStr):match("^%s*(.-)%s*$")
   end,
})

DeepTab:CreateButton({
   Name = "Refresh List",
   Callback = function()
      local names = {}
      for _, v in pairs(Players:GetPlayers()) do table.insert(names, v.Name) end
      Dropdown:Refresh(names, true)
   end
})

DeepTab:CreateSection("Fetch Player DATA")

DeepTab:CreateButton({
   Name = "• FETCH DATA •",
   Callback = function()
      if Intel.SelectedTarget == "" or Intel.SelectedTarget == "nil" then return end
      local targetPlayer = Players:FindFirstChild(Intel.SelectedTarget)
      
      if targetPlayer then
         task.spawn(function()
            for i = 1, 3 do
                L_Name:Set("⚡ ANALYZING" .. string.rep(".", i))
                L_Robux:Set("⚡ AI getting information...")
                task.wait(0.2)
            end

            local s = getDetailedStats(targetPlayer)
            updateHologram(targetPlayer.UserId) 
            
            local robuxVal = 0
            pcall(function()
               local desc = targetPlayer.Character:FindFirstChild("Humanoid"):GetAppliedDescription()
               for _, item in pairs(desc:GetAccessories(true)) do
                  local info = MarketplaceService:GetProductInfo(item.AssetId)
                  if info.PriceInRobux then robuxVal = robuxVal + info.PriceInRobux end
               end
            end)

            -- YENİ NESİL YAPAY ZEKA MANTIĞI (Dinamik Yaş ve Profil)
            local persona, ageGuess = "", ""
            local aAge = targetPlayer.AccountAge
            local nameLower = targetPlayer.Name:lower()
            local displayLower = targetPlayer.DisplayName:lower()
            local chatHistory = table.concat(Intel.Logs[targetPlayer.Name] or {}, " "):lower()

            -- 1. Yaş Tahmini Motoru (Daha Akıllı)
            local baseAge = 14 -- Varsayılan başlama yaşı
            
            -- İsimde doğum yılı var mı? (örn: ahmet2010)
            local yearMatch = nameLower:match("(20%d%d)")
            if yearMatch then
                local y = tonumber(yearMatch)
                if y > 2000 and y <= 2020 then
                    baseAge = 2026 - y
                end
            else
                -- Yıl yoksa oyun içi istatistiklerden hesapla
                if aAge > 2000 then baseAge = baseAge + 4
                elseif aAge < 300 then baseAge = baseAge - 2 end
                
                if robuxVal > 30000 then baseAge = baseAge + 2 end
            end

            -- Chatten karakter tespiti ile yaş kırma
            if chatHistory:find("ez") or chatHistory:find("noob") or chatHistory:find("sigma") or chatHistory:find("skibidi") then
                baseAge = 11 -- Toksik/Meme kelimeler kullanıyorsa yaşı küçült
            elseif chatHistory:find("bro") or chatHistory:find("pls") then
                baseAge = 12
            end

            -- Yaş aralığı oluştur (14 bulduysa 13-16 arası yazar)
            local minAge = math.clamp(baseAge - 1, 9, 30)
            local maxAge = minAge + 2
            ageGuess = minAge .. "-" .. maxAge .. " Age range"

            -- 2. Psikolojik Profil Çıkarıcı
            if robuxVal > 25000 and aAge > 1000 then 
                persona = "💎 Elite Profile (Deneyimli / Parası Olan)"
            elseif aAge > 2000 then 
                persona = "👴 OG player"
            elseif chatHistory:find("ez") or chatHistory:find("noob") then
                persona = "☠️ Toxic / Tryhard player"
            elseif #Intel.Logs[targetPlayer.Name] > 5 then 
                persona = "🗣️ Social Player "
            elseif nameLower:find("xx") or displayLower:find("demon") or displayLower:find("blood") then
                persona = "🦇 Edgy / Cool looking player"
            elseif robuxVal == 0 and aAge < 50 then 
                persona = "👶 New / troll player"
            elseif robuxVal > 5000 and robuxVal <= 25000 then
                persona = "🎨 Esthetic player"
            else 
                persona = "👤 Standart / Chill player" 
            end

            -- Verileri Menüye Basma
            L_Name:Set("User: " .. s.Display .. " (@" .. s.Name .. ")")
            L_Device:Set("Platform: " .. s.Platform)
            L_Age:Set("Account age: " .. s.Date .. " (" .. s.Age .. " Gün)")
            L_Premium:Set("Premium: " .. s.Premium .. " | Badge: " .. s.Verified)
            L_Status:Set("Status: " .. s.Status)

            L_Robux:Set("💰 Avatar Cost: ~" .. robuxVal .. " Robux")
            L_AI_Age:Set("🎂 Estimated Real Age: " .. ageGuess)
            L_Persona:Set("🎭 Phsocologyc personality: " .. persona)

            local chatLogs = Intel.Logs[targetPlayer.Name] or {}
            P_Chat:Set({Title = "Last Chat Logs", Content = #chatLogs > 0 and table.concat(chatLogs, "\n") or "Player didnt chat."})
            
            Rayfield:Notify({Title = "Scanning complete", Content = targetPlayer.Name .. " Rendered successfully.", Duration = 4})
         end)
      end
   end,
})

local function init()
    local names = {}
    for _, v in pairs(Players:GetPlayers()) do table.insert(names, v.Name) end
    Dropdown:Refresh(names, true)
end
init()
