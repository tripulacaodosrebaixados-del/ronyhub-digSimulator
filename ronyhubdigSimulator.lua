--[[ 
    👑 RONY HUB - V14 (CYBER PREMIUM / STABLE TURBO)
    
    [VISUAL]
    - Design "Cyber Dark": Fundo sólido premium, gradientes sutis e detalhes Neon.
    - Sem transparência excessiva (fácil de ver).
    - Animações de Hover e Entrada (Pop-up).
    
    [LÓGICA HÍBRIDA]
    - Velocidade: Loops de cavar/vender sem delay (Velocidade Máxima).
    - Estabilidade: Teleporte inteligente (Só move se distância > 6 studs).
    
    Author: Gemini AI
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

--// 📍 LOCALIZAÇÃO
local SANTA_CFRAME = CFrame.new(101.749924, 4.14999914, 43.8000221)

--// 🎨 TEMA PREMIUM (CYBER)
local THEME = {
    Background    = Color3.fromRGB(18, 18, 22),     -- Preto Azulado Profundo
    Sidebar       = Color3.fromRGB(24, 24, 28),     -- Contraste suave
    SidebarGrad   = Color3.fromRGB(15, 15, 20),     -- Gradiente
    Accent        = Color3.fromRGB(0, 255, 180),    -- Ciano Neon (O "Glow")
    AccentSec     = Color3.fromRGB(80, 80, 255),    -- Roxo Secundário
    Text          = Color3.fromRGB(255, 255, 255),
    TextDim       = Color3.fromRGB(140, 140, 150),
    Stroke        = Color3.fromRGB(45, 45, 55),     -- Linhas sutis
    Corner        = UDim.new(0, 12)
}

--// ⚙️ ESTADO GLOBAL
local State = {
    AutoKaitun = false,
    FarmTerra = false,
    AutoSell = false,
    AutoTransform = false,
    AutoGift = false,
    AntiAfk = false
}

--// 🖥️ UI SETUP
if game.CoreGui:FindFirstChild("RonyHub_V14") then game.CoreGui.RonyHub_V14:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RonyHub_V14"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if pcall(function() ScreenGui.Parent = CoreGui end) then else ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

--// 🔧 HELPERS VISUAIS PREMIUM
local function MakeCorner(p, r) local c = Instance.new("UICorner"); c.CornerRadius = r or THEME.Corner; c.Parent = p; return c end
local function MakeStroke(p, c, t) local s = Instance.new("UIStroke"); s.Color = c or THEME.Stroke; s.Transparency = t or 0; s.Thickness = 1; s.Parent = p; return s end
local function MakeGradient(p, c1, c2) local g = Instance.new("UIGradient"); g.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2)}; g.Rotation = 45; g.Parent = p; return g end

--// 📦 SOMBRA DE FUNDO (GLOW SUTIL)
local ShadowFrame = Instance.new("ImageLabel")
ShadowFrame.Name = "Shadow"
ShadowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ShadowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ShadowFrame.Size = UDim2.new(0, 0, 0, 0) -- Começa invisível
ShadowFrame.Image = "rbxassetid://6015897843"
ShadowFrame.ImageColor3 = Color3.fromRGB(0, 0, 0)
ShadowFrame.ImageTransparency = 0.3
ShadowFrame.BackgroundTransparency = 1
ShadowFrame.SliceCenter = Rect.new(49, 49, 450, 450)
ShadowFrame.ScaleType = Enum.ScaleType.Slice
ShadowFrame.SliceScale = 1
ShadowFrame.Parent = ScreenGui

--// 📦 MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 580, 0, 360) -- Tamanho Premium
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ShadowFrame
MakeCorner(MainFrame)
MakeStroke(MainFrame, THEME.Stroke)

-- Barra Lateral (Com Gradiente)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(255,255,255)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
MakeCorner(Sidebar)
local SideGrad = MakeGradient(Sidebar, THEME.Sidebar, THEME.SidebarGrad)
-- Fix visual para conectar com o main frame
local SideFix = Instance.new("Frame"); SideFix.Size = UDim2.new(0, 20, 1, 0); SideFix.Position = UDim2.new(1, -10, 0, 0); SideFix.BackgroundColor3 = THEME.SidebarGrad; SideFix.BorderSizePixel = 0; SideFix.Parent = Sidebar

-- Título
local Title = Instance.new("TextLabel")
Title.Text = "RONY<font color=\"rgb(0,255,180)\">HUB</font>"
Title.RichText = true
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 26
Title.TextColor3 = THEME.Text
Title.Size = UDim2.new(1, 0, 0, 70)
Title.BackgroundTransparency = 1
Title.Parent = Sidebar

local SubTitle = Instance.new("TextLabel")
SubTitle.Text = "PREMIUM V14"
SubTitle.Font = Enum.Font.GothamBold
SubTitle.TextSize = 10
SubTitle.TextColor3 = THEME.Accent
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0, 45)
SubTitle.BackgroundTransparency = 1
SubTitle.Parent = Sidebar

-- Divisor
local Div = Instance.new("Frame"); Div.Size = UDim2.new(0, 1, 1, 0); Div.Position = UDim2.new(0, 160, 0, 0); Div.BackgroundColor3 = THEME.Stroke; Div.BorderSizePixel = 0; Div.Parent = MainFrame

-- Container de Abas
local TabsContainer = Instance.new("Frame")
TabsContainer.Size = UDim2.new(1, 0, 1, -100)
TabsContainer.Position = UDim2.new(0, 0, 0, 80)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = Sidebar
local TabList = Instance.new("UIListLayout"); TabList.Padding = UDim.new(0, 8); TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabList.Parent = TabsContainer

-- Área de Páginas
local PagesArea = Instance.new("Frame")
PagesArea.Size = UDim2.new(1, -160, 1, 0)
PagesArea.Position = UDim2.new(0, 160, 0, 0)
PagesArea.BackgroundTransparency = 1
PagesArea.Parent = MainFrame

local PageHeader = Instance.new("TextLabel")
PageHeader.Text = "Painel de Controle"
PageHeader.Font = Enum.Font.GothamBold
PageHeader.TextSize = 20
PageHeader.TextColor3 = THEME.Text
PageHeader.TextXAlignment = Enum.TextXAlignment.Left
PageHeader.Size = UDim2.new(1, -40, 0, 60)
PageHeader.Position = UDim2.new(0, 25, 0, 0)
PageHeader.BackgroundTransparency = 1
PageHeader.Parent = PagesArea

--// 🔔 NOTIFICAÇÕES (Estilo Card)
local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 280, 1, 0)
NotifContainer.Position = UDim2.new(1, -300, 0, 30)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui
local NotifList = Instance.new("UIListLayout"); NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom; NotifList.Padding = UDim.new(0, 8); NotifList.Parent = NotifContainer

local function Notify(msg)
    local F = Instance.new("Frame"); F.Size = UDim2.new(0, 0, 0, 45); F.BackgroundColor3 = THEME.Sidebar; F.Parent = NotifContainer; MakeCorner(F, UDim.new(0, 8)); MakeStroke(F, THEME.Accent, 0.5)
    local L = Instance.new("TextLabel"); L.Text = msg; L.TextColor3 = THEME.Text; L.Size = UDim2.new(0, 260, 1, 0); L.Position = UDim2.new(0, 15, 0, 0); L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left; L.Font = Enum.Font.GothamMedium; L.TextSize = 13; L.Parent = F
    
    TweenService:Create(F, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 45)}):Play()
    task.delay(3, function() 
        TweenService:Create(F, TweenInfo.new(0.3), {Size = UDim2.new(1, 100, 0, 45), BackgroundTransparency = 1}):Play()
        TweenService:Create(L, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        task.wait(0.3) F:Destroy() 
    end)
end

--// LÓGICA DE UI
local Tabs = {}
local function CreatePage(name) 
    local P = Instance.new("ScrollingFrame")
    P.Visible = false; P.Size = UDim2.new(1, -30, 1, -70); P.Position = UDim2.new(0, 15, 0, 60); P.BackgroundTransparency = 1; P.ScrollBarThickness = 2; P.Parent = PagesArea
    local L = Instance.new("UIListLayout"); L.Padding = UDim.new(0, 10); L.Parent = P
    return P 
end

local function Switch(btn, page, txt)
    for _,t in pairs(Tabs) do 
        TweenService:Create(t, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = THEME.TextDim}):Play()
        TweenService:Create(t.UIStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
    end
    for _,p in pairs(PagesArea:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
    
    -- Efeito de botão ativo
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, TextColor3 = THEME.Accent}):Play()
    TweenService:Create(btn.UIStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
    
    page.Visible = true
    page.Position = UDim2.new(0, 15, 0, 70) -- Animação de slide
    TweenService:Create(page, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 15, 0, 60)}):Play()
    PageHeader.Text = txt
end

local function AddTab(icon, txt, page)
    local B = Instance.new("TextButton")
    B.Text = "  "..icon.."   "..txt
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
    B.MouseEnter:Connect(function() if B.TextColor3 ~= THEME.Accent then TweenService:Create(B, TweenInfo.new(0.2), {BackgroundTransparency = 0.95, TextColor3 = THEME.Text}):Play() end end)
    B.MouseLeave:Connect(function() if B.TextColor3 ~= THEME.Accent then TweenService:Create(B, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = THEME.TextDim}):Play() end end)
    
    table.insert(Tabs, B)
    return B
end

local function AddToggle(parent, txt, callback)
    local F = Instance.new("Frame"); F.Size = UDim2.new(1, 0, 0, 50); F.BackgroundColor3 = Color3.fromRGB(28,28,32); F.Parent = parent; MakeCorner(F, UDim.new(0, 10))
    local s = MakeStroke(F, THEME.Stroke, 0)
    
    local L = Instance.new("TextLabel"); L.Text = txt; L.Font = Enum.Font.GothamMedium; L.TextColor3 = THEME.Text; L.Size = UDim2.new(0.7,0,1,0); L.Position = UDim2.new(0,20,0,0); L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left; L.Parent = F
    
    local B = Instance.new("TextButton"); B.Text = ""; B.Size = UDim2.new(0, 44, 0, 24); B.Position = UDim2.new(1, -64, 0.5, -12); B.BackgroundColor3 = Color3.fromRGB(50,50,55); B.Parent = F; MakeCorner(B, UDim.new(1,0))
    local C = Instance.new("Frame"); C.Size = UDim2.new(0, 18, 0, 18); C.Position = UDim2.new(0, 3, 0.5, -9); C.BackgroundColor3 = Color3.fromRGB(220,220,220); C.Parent = B; MakeCorner(C, UDim.new(1,0))
    
    local on = false
    B.MouseButton1Click:Connect(function()
        on = not on
        local goal = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local col = on and THEME.Accent or Color3.fromRGB(50,50,55)
        local strokeCol = on and THEME.Accent or THEME.Stroke
        
        TweenService:Create(C, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = goal}):Play()
        TweenService:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = col}):Play()
        TweenService:Create(s, TweenInfo.new(0.2), {Color = strokeCol}):Play()
        callback(on)
    end)
end

--// CONTEÚDO
local P_Home = CreatePage("Home")
local P_Manual = CreatePage("Manual")
local P_Config = CreatePage("Config")

local T1 = AddTab("🚀", "Auto Kaitun", P_Home)
local T2 = AddTab("🕹️", "Manual", P_Manual)
local T3 = AddTab("🔧", "Configuração", P_Config)

Switch(T1, P_Home, "AUTO KAITUN TURBO")

AddToggle(P_Home, "ATIVAR AUTO KAITUN (Rápido)", function(v) 
    State.AutoKaitun = v
    if v then Notify("⚡ Kaitun Iniciado!") else Notify("🛑 Parado.") end
end)

AddToggle(P_Manual, "Auto Dig (Cavar Turbo)", function(v) State.FarmTerra = v end)
AddToggle(P_Manual, "Auto Sell (Vender)", function(v) State.AutoSell = v end)
AddToggle(P_Manual, "Auto Transform (Santa)", function(v) State.AutoTransform = v end)
AddToggle(P_Manual, "Coletar Presentes", function(v) State.AutoGift = v end)

AddToggle(P_Config, "Anti-AFK", function(v) State.AntiAfk = v end)

--// ⚙️ LÓGICA TURBO + ESTABILIDADE (PERFEITA)

-- 1. TELEPORTE INTELIGENTE (SEM BUG)
task.spawn(function()
    while true do
        if State.AutoKaitun then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local dist = (hrp.Position - SANTA_CFRAME.Position).Magnitude
                    
                    -- AQUI ESTÁ A MÁGICA: Só teleporta se a distância for > 6 studs.
                    -- Isso permite você andar um pouquinho sem a tela piscar.
                    if dist > 6 then
                        hrp.CFrame = SANTA_CFRAME
                        hrp.Velocity = Vector3.new(0,0,0) -- Trava física
                        hrp.RotVelocity = Vector3.new(0,0,0)
                    end
                end
            end)
        end
        -- Delay de 0.05 é ultra rápido mas dá tempo pra física respirar
        task.wait(0.05)
    end
end)

-- 2. CAVAR VELOCIDADE MÁXIMA (TURBO)
task.spawn(function()
    while true do
        if State.FarmTerra or State.AutoKaitun then
            -- Removemos delays grandes. É o limite do servidor.
            game:GetService("ReplicatedStorage"):WaitForChild("DigControl"):FireServer("finish")
        end
        -- Sem argumentos no wait = espera 1 frame (aprox 0.016s)
        task.wait() 
    end
end)

-- 3. VENDER RÁPIDO
task.spawn(function()
    while true do
        if State.AutoSell or State.AutoKaitun then
            game:GetService("ReplicatedStorage"):WaitForChild("SellItem"):FireServer("ALL")
            local bp = LocalPlayer.Backpack:GetChildren()
            if #bp > 0 then
                for _, t in pairs(bp) do
                    if t:IsA("Tool") then
                        t.Parent = LocalPlayer.Character
                        game:GetService("ReplicatedStorage"):WaitForChild("SellItem"):FireServer("ALL")
                    end
                end
            end
        end
        task.wait(0.2) -- 200ms delay (Muito rápido)
    end
end)

-- 4. TRANSFORMAR E PRESENTES
task.spawn(function()
    while true do
        if State.AutoTransform or State.AutoKaitun then
            pcall(function()
                local char = LocalPlayer.Character
                for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do if t:IsA("Tool") then t.Parent = char end end
                if char:FindFirstChildWhichIsA("Tool") then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait()
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end
            end)
        end
        task.wait(0.8)
    end
end)

task.spawn(function()
    while true do
        if State.AutoGift or State.AutoKaitun then
            game:GetService("ReplicatedStorage"):WaitForChild("ToolRewardEvent"):FireServer()
        end
        task.wait(2.5)
    end
end)

-- ANTI AFK
LocalPlayer.Idled:Connect(function()
    if State.AntiAfk or State.AutoKaitun then
        VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new())
    end
end)

--// 🪟 ANIMAÇÕES E CONTROLES
ShadowFrame.Visible = true
-- Animação de Entrada Elástica (Premium)
TweenService:Create(ShadowFrame, TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 380)}):Play()

local MinBtn = Instance.new("TextButton"); MinBtn.Text = "—"; MinBtn.TextColor3 = THEME.TextDim; MinBtn.Font = Enum.Font.GothamBlack; MinBtn.TextSize = 22; MinBtn.BackgroundTransparency = 1; MinBtn.Size = UDim2.new(0, 40, 0, 40); MinBtn.Position = UDim2.new(1, -40, 0, 0); MinBtn.Parent = MainFrame
local OpenBtn = Instance.new("ImageButton"); OpenBtn.Image = "rbxassetid://6031068426"; OpenBtn.ImageColor3 = THEME.Accent; OpenBtn.BackgroundColor3 = THEME.Background; OpenBtn.Size = UDim2.new(0, 50, 0, 50); OpenBtn.Position = UDim2.new(0, 20, 0.5, -25); OpenBtn.Visible = false; OpenBtn.Parent = ScreenGui; MakeCorner(OpenBtn, UDim.new(0,12)); MakeStroke(OpenBtn, THEME.Accent)

MinBtn.MouseButton1Click:Connect(function() 
    TweenService:Create(ShadowFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)}):Play()
    task.wait(0.4); ShadowFrame.Visible = false; OpenBtn.Visible = true 
end)
OpenBtn.MouseButton1Click:Connect(function() 
    OpenBtn.Visible = false; ShadowFrame.Visible = true 
    TweenService:Create(ShadowFrame, TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 380)}):Play()
end)

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = ShadowFrame.Position end end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; ShadowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
MainFrame.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

Notify("🌟 Rony Hub V14: Premium & Estável!")
