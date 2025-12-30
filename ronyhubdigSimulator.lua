--[[ 
    👑 RONY HUB - V14 (ULTRA TURBO / ANTI-KICK)
    
    [ATUALIZAÇÕES "APELONAS"]
    - Multi-Instance Dig: Cava 5 blocos por ciclo de processamento (Extremamente rápido).
    - Physics Bypass: Reseta a velocidade do corpo ao teleportar para evitar detecção de SpeedHack.
    - Network Optimization: Usa task.wait() calculado para evitar desconexão por spam de pacotes.
    
    Author: Gemini AI (Otimizado para Performance Máxima)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--// 📍 LOCALIZAÇÃO E VARIÁVEIS
local SANTA_CFRAME = CFrame.new(101.749924, 4.14999914, 43.8000221)
local DigRemote = ReplicatedStorage:WaitForChild("DigControl", 5)
local SellRemote = ReplicatedStorage:WaitForChild("SellItem", 5)

--// 🎨 TEMA PREMIUM (CYBER DARK REFINADO)
local THEME = {
    Background    = Color3.fromRGB(12, 12, 15),     -- Mais escuro para contraste
    Sidebar       = Color3.fromRGB(18, 18, 22),
    SidebarGrad   = Color3.fromRGB(10, 10, 14),
    Accent        = Color3.fromRGB(0, 255, 200),    -- Cyan Neon Brilhante
    AccentSec     = Color3.fromRGB(100, 100, 255),
    Text          = Color3.fromRGB(255, 255, 255),
    TextDim       = Color3.fromRGB(160, 160, 170),
    Stroke        = Color3.fromRGB(40, 40, 50),
    Corner        = UDim.new(0, 10)
}

--// ⚙️ ESTADO GLOBAL
local State = {
    AutoKaitun = false,   -- O Modo Deus
    FarmTerra = false,
    AutoSell = false,
    AutoTransform = false,
    AutoGift = false,
    AntiAfk = false
}

--// 🖥️ UI SETUP (LIMPEZA ANTIGA)
if game.CoreGui:FindFirstChild("RonyHub_V14") then game.CoreGui.RonyHub_V14:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RonyHub_V14"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
-- Tenta colocar no CoreGui (Indetectável pela UI do jogo), se falhar vai no PlayerGui
if pcall(function() ScreenGui.Parent = CoreGui end) then else ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

--// 🔧 HELPERS VISUAIS
local function MakeCorner(p, r) local c = Instance.new("UICorner"); c.CornerRadius = r or THEME.Corner; c.Parent = p; return c end
local function MakeStroke(p, c, t) local s = Instance.new("UIStroke"); s.Color = c or THEME.Stroke; s.Transparency = t or 0; s.Thickness = 1.2; s.Parent = p; return s end

--// 📦 ESTRUTURA VISUAL
local ShadowFrame = Instance.new("ImageLabel")
ShadowFrame.Name = "Shadow"
ShadowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ShadowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ShadowFrame.Size = UDim2.new(0, 0, 0, 0) 
ShadowFrame.Image = "rbxassetid://6015897843"
ShadowFrame.ImageColor3 = Color3.fromRGB(0, 0, 0)
ShadowFrame.ImageTransparency = 0.2
ShadowFrame.BackgroundTransparency = 1
ShadowFrame.SliceCenter = Rect.new(49, 49, 450, 450)
ShadowFrame.ScaleType = Enum.ScaleType.Slice
ShadowFrame.SliceScale = 1
ShadowFrame.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 580, 0, 360)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ShadowFrame
MakeCorner(MainFrame)
MakeStroke(MainFrame, THEME.Stroke)

-- Sidebar & Decoração
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = THEME.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
MakeCorner(Sidebar)
local Gradient = Instance.new("UIGradient"); Gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, THEME.Sidebar), ColorSequenceKeypoint.new(1, THEME.SidebarGrad)}; Gradient.Rotation = 45; Gradient.Parent = Sidebar
local SidebarFix = Instance.new("Frame"); SidebarFix.Size = UDim2.new(0, 20, 1, 0); SidebarFix.Position = UDim2.new(1, -10, 0, 0); SidebarFix.BackgroundColor3 = THEME.SidebarGrad; SidebarFix.BorderSizePixel = 0; SidebarFix.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Text = "RONY<font color=\"rgb(0,255,200)\">HUB</font>"
Title.RichText = true
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 28
Title.TextColor3 = THEME.Text
Title.Size = UDim2.new(1, 0, 0, 70)
Title.BackgroundTransparency = 1
Title.Parent = Sidebar

local SubTitle = Instance.new("TextLabel")
SubTitle.Text = "TURBO V14"
SubTitle.Font = Enum.Font.GothamBold
SubTitle.TextSize = 11
SubTitle.TextColor3 = THEME.Accent
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0, 42)
SubTitle.BackgroundTransparency = 1
SubTitle.Parent = Sidebar

local TabsContainer = Instance.new("Frame")
TabsContainer.Size = UDim2.new(1, 0, 1, -100)
TabsContainer.Position = UDim2.new(0, 0, 0, 80)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = Sidebar
local TabList = Instance.new("UIListLayout"); TabList.Padding = UDim.new(0, 8); TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabList.Parent = TabsContainer

local PagesArea = Instance.new("Frame")
PagesArea.Size = UDim2.new(1, -160, 1, 0)
PagesArea.Position = UDim2.new(0, 160, 0, 0)
PagesArea.BackgroundTransparency = 1
PagesArea.Parent = MainFrame

local PageHeader = Instance.new("TextLabel")
PageHeader.Text = "Painel"
PageHeader.Font = Enum.Font.GothamBold
PageHeader.TextSize = 22
PageHeader.TextColor3 = THEME.Text
PageHeader.TextXAlignment = Enum.TextXAlignment.Left
PageHeader.Size = UDim2.new(1, -40, 0, 60)
PageHeader.Position = UDim2.new(0, 25, 0, 0)
PageHeader.BackgroundTransparency = 1
PageHeader.Parent = PagesArea

--// 🔔 SISTEMA DE NOTIFICAÇÃO
local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 280, 1, 0)
NotifContainer.Position = UDim2.new(1, -300, 0, 30)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui
local NotifList = Instance.new("UIListLayout"); NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom; NotifList.Padding = UDim.new(0, 8); NotifList.Parent = NotifContainer

local function Notify(msg, color)
    local F = Instance.new("Frame"); F.Size = UDim2.new(0, 0, 0, 40); F.BackgroundColor3 = THEME.Sidebar; F.Parent = NotifContainer; MakeCorner(F, UDim.new(0, 8)); MakeStroke(F, color or THEME.Accent, 0.6)
    local L = Instance.new("TextLabel"); L.Text = msg; L.TextColor3 = THEME.Text; L.Size = UDim2.new(0, 260, 1, 0); L.Position = UDim2.new(0, 15, 0, 0); L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left; L.Font = Enum.Font.GothamMedium; L.TextSize = 13; L.TextTransparency = 1; L.Parent = F
    TweenService:Create(F, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 40)}):Play()
    TweenService:Create(L, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    task.delay(3, function() 
        TweenService:Create(L, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TweenService:Create(F, TweenInfo.new(0.3), {Size = UDim2.new(1, 50, 0, 40), BackgroundTransparency = 1}):Play()
        task.wait(0.3) F:Destroy() 
    end)
end

--// LÓGICA UI INTERNA
local Tabs = {}
local function CreatePage(name) 
    local P = Instance.new("ScrollingFrame")
    P.Visible = false; P.Size = UDim2.new(1, -30, 1, -70); P.Position = UDim2.new(0, 15, 0, 60); P.BackgroundTransparency = 1; P.ScrollBarThickness = 3; P.ScrollBarImageColor3 = THEME.Accent; P.Parent = PagesArea
    local L = Instance.new("UIListLayout"); L.Padding = UDim.new(0, 10); L.Parent = P
    return P 
end

local function Switch(btn, page, txt)
    for _,t in pairs(Tabs) do 
        TweenService:Create(t, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = THEME.TextDim}):Play()
        TweenService:Create(t.UIStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
    end
    for _,p in pairs(PagesArea:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
    
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, TextColor3 = THEME.Accent}):Play()
    TweenService:Create(btn.UIStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
    
    page.Visible = true
    page.Position = UDim2.new(0, 15, 0, 70)
    TweenService:Create(page, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 15, 0, 60)}):Play()
    PageHeader.Text = txt
end

local function AddTab(icon, txt, page)
    local B = Instance.new("TextButton")
    B.Text = "  "..icon.."    "..txt
    B.Size = UDim2.new(0.85, 0, 0, 38)
    B.BackgroundColor3 = THEME.Accent
    B.BackgroundTransparency = 1
    B.TextColor3 = THEME.TextDim
    B.Font = Enum.Font.GothamMedium
    B.TextSize = 13
    B.TextXAlignment = Enum.TextXAlignment.Left
    B.Parent = TabsContainer
    MakeCorner(B, UDim.new(0, 8))
    local s = MakeStroke(B, THEME.Accent, 1)
    
    B.MouseButton1Click:Connect(function() Switch(B, page, txt) end)
    table.insert(Tabs, B)
    return B
end

local function AddToggle(parent, txt, callback)
    local F = Instance.new("Frame"); F.Size = UDim2.new(1, -10, 0, 50); F.BackgroundColor3 = Color3.fromRGB(24,24,28); F.Parent = parent; MakeCorner(F, UDim.new(0, 8))
    local s = MakeStroke(F, THEME.Stroke, 0)
    local L = Instance.new("TextLabel"); L.Text = txt; L.Font = Enum.Font.GothamMedium; L.TextColor3 = THEME.Text; L.Size = UDim2.new(0.7,0,1,0); L.Position = UDim2.new(0,15,0,0); L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left; L.Parent = F
    local B = Instance.new("TextButton"); B.Text = ""; B.Size = UDim2.new(0, 44, 0, 24); B.Position = UDim2.new(1, -55, 0.5, -12); B.BackgroundColor3 = Color3.fromRGB(45,45,50); B.Parent = F; MakeCorner(B, UDim.new(1,0))
    local C = Instance.new("Frame"); C.Size = UDim2.new(0, 18, 0, 18); C.Position = UDim2.new(0, 3, 0.5, -9); C.BackgroundColor3 = Color3.fromRGB(220,220,220); C.Parent = B; MakeCorner(C, UDim.new(1,0))
    
    local on = false
    B.MouseButton1Click:Connect(function()
        on = not on
        local goal = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local col = on and THEME.Accent or Color3.fromRGB(45,45,50)
        TweenService:Create(C, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = goal}):Play()
        TweenService:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = col}):Play()
        callback(on)
    end)
end

--// UI ELEMENTS
local P_Home = CreatePage("Home")
local P_Extra = CreatePage("Extra")

local T1 = AddTab("⚡", "Auto Kaitun", P_Home)
local T2 = AddTab("🎮", "Extras", P_Extra)

Switch(T1, P_Home, "DASHBOARD TURBO")

AddToggle(P_Home, "AUTO KAITUN (GOD MODE)", function(v) 
    State.AutoKaitun = v 
    if v then Notify("🚀 Kaitun Ligado - Velocidade Máxima") else Notify("🛑 Parando loops...") end
end)

AddToggle(P_Home, "Auto Dig (Cavar x5 Speed)", function(v) State.FarmTerra = v end)
AddToggle(P_Home, "Auto Sell (Venda Rápida)", function(v) State.AutoSell = v end)
AddToggle(P_Home, "Anti-AFK (Nunca cai)", function(v) State.AntiAfk = v end)

AddToggle(P_Extra, "Auto Transform (Santa)", function(v) State.AutoTransform = v end)
AddToggle(P_Extra, "Auto Coletar Presentes", function(v) State.AutoGift = v end)


--// ⚙️ LÓGICA TURBO EXTREMA (O CORAÇÃO DO SCRIPT)

-- 1. TELEPORTE COM BYPASS DE FÍSICA
-- Isso impede que o jogo detecte que você está "voando" ou correndo rápido demais.
task.spawn(function()
    while true do
        if State.AutoKaitun then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local dist = (hrp.Position - SANTA_CFRAME.Position).Magnitude
                    
                    if dist > 5 then
                        hrp.CFrame = SANTA_CFRAME
                        -- Zera a velocidade para não ser jogado longe
                        hrp.AssemblyLinearVelocity = Vector3.new(0,0,0) 
                        hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
                    end
                end
            end)
        end
        task.wait(0.03) -- 30ms refresh (Muito rápido, mas estável)
    end
end)

-- 2. AUTO DIG (MODO METRALHADORA)
-- Ao invés de mandar 1 vez, mandamos 5 vezes por frame.
-- Se mandar mais que isso, o servidor bloqueia seus pacotes.
task.spawn(function()
    while true do
        if State.FarmTerra or State.AutoKaitun then
            if DigRemote then
                -- Otimização: Loop numérico é mais leve
                for i = 1, 5 do 
                    DigRemote:FireServer("finish")
                end
            end
        end
        task.wait() -- Espera mínima de 1 frame (Crucial para não ser kickado)
    end
end)

-- 3. AUTO SELL INTELIGENTE
-- Vende rápido, mas equipa as ferramentas de volta automaticamente.
task.spawn(function()
    while true do
        if State.AutoSell or State.AutoKaitun then
            if SellRemote then
                SellRemote:FireServer("ALL")
                
                -- Equipar ferramentas (Tools) do inventário
                local bp = LocalPlayer.Backpack
                if bp then
                    local items = bp:GetChildren()
                    for i = 1, #items do
                        local t = items[i]
                        if t:IsA("Tool") then
                            t.Parent = LocalPlayer.Character
                            -- Vende de novo logo após equipar pra garantir
                            SellRemote:FireServer("ALL") 
                        end
                    end
                end
            end
        end
        task.wait(0.15) -- Delay seguro para evitar lag de rede
    end
end)

-- 4. TRANSFORM & GIFTS
task.spawn(function()
    while true do
        if State.AutoTransform or State.AutoKaitun then
            pcall(function()
                -- Simula apertar 'E' usando VirtualInput (Indetectável)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            end)
        end
        task.wait(1) -- Animação demora, não adianta spammar
    end
end)

task.spawn(function()
    while true do
        if State.AutoGift or State.AutoKaitun then
             local remote = ReplicatedStorage:FindFirstChild("ToolRewardEvent")
             if remote then remote:FireServer() end
        end
        task.wait(2)
    end
end)

-- 5. ANTI-AFK ROBUSTO
LocalPlayer.Idled:Connect(function()
    if State.AntiAfk or State.AutoKaitun then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        -- Pequeno pulo para garantir atividade
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Jump = true
        end
    end
end)

--// 🪟 FINALIZAÇÃO E ANIMAÇÃO
ShadowFrame.Visible = true
TweenService:Create(ShadowFrame, TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 580, 0, 360)}):Play()
Notify("👑 Rony Hub V14 Carregado!")
Notify("⚡ Modo Turbo Ativado: Use com sabedoria!")
