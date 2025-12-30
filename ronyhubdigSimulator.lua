--[[ 
    👑 RONY HUB - V15 (ULTIMATE PROFILE EDITION)
    
    [NOVIDADES V15]
    - Sistema de Janela: Botão de Minimizar e Reabrir (Dragável).
    - Aba Configurações: 
      > FPS Boost (Remove Texturas/Efeitos).
      > Seletor de Temas (Muda a cor do menu em tempo real).
    - Lógica "Apelona": Otimizada para rodar no limite sem desconectar.
    
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
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// 📍 VARIÁVEIS DO JOGO
local SANTA_CFRAME = CFrame.new(101.749924, 4.14999914, 43.8000221)
local DigRemote = ReplicatedStorage:WaitForChild("DigControl", 5)
local SellRemote = ReplicatedStorage:WaitForChild("SellItem", 5)

--// 🎨 SISTEMA DE TEMAS DINÂMICO
local CurrentTheme = {
    Accent = Color3.fromRGB(0, 255, 200), -- Padrão (Cyan)
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(20, 20, 25),
    Text = Color3.fromRGB(255, 255, 255),
    Stroke = Color3.fromRGB(50, 50, 60)
}

-- Lista de objetos para atualizar cor quando trocar tema
local ThemeObjects = {Strokes = {}, Texts = {}, Backgrounds = {}}

--// ⚙️ ESTADO GLOBAL
local State = {
    AutoKaitun = false,
    FarmTerra = false,
    AutoSell = false,
    AutoTransform = false,
    AutoGift = false,
    AntiAfk = false,
    Open = true
}

--// 🖥️ UI SETUP
if game.CoreGui:FindFirstChild("RonyHub_V15") then game.CoreGui.RonyHub_V15:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RonyHub_V15"
ScreenGui.ResetOnSpawn = false
if pcall(function() ScreenGui.Parent = CoreGui end) then else ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

--// 🔧 FUNÇÕES VISUAIS
local function MakeCorner(p, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = p; return c end
local function MakeStroke(p, color, thick) 
    local s = Instance.new("UIStroke"); s.Color = color or CurrentTheme.Stroke; s.Thickness = thick or 1; s.Parent = p; 
    table.insert(ThemeObjects.Strokes, s) -- Salva para atualizar tema depois
    return s 
end

--// 🔘 BOTÃO DE ABRIR (MINIMIZADO)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = CurrentTheme.Sidebar
OpenBtn.Text = "R"
OpenBtn.TextColor3 = CurrentTheme.Accent
OpenBtn.Font = Enum.Font.GothamBlack
OpenBtn.TextSize = 30
OpenBtn.Visible = false -- Começa invisível pois o menu já abre aberto
OpenBtn.Parent = ScreenGui
MakeCorner(OpenBtn, 12)
MakeStroke(OpenBtn, CurrentTheme.Accent, 2)

--// 📦 MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 600, 0, 380)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = CurrentTheme.Background
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
MakeCorner(MainFrame, 10)
MakeStroke(MainFrame, CurrentTheme.Stroke, 1.5)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = CurrentTheme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
MakeCorner(Sidebar, 10)
-- Retirar arredondamento do lado direito da sidebar
local SideFix = Instance.new("Frame"); SideFix.Size = UDim2.new(0, 10, 1, 0); SideFix.Position = UDim2.new(1, -5, 0, 0); SideFix.BackgroundColor3 = CurrentTheme.Sidebar; SideFix.BorderSizePixel = 0; SideFix.Parent = Sidebar

local Title = Instance.new("TextLabel")
Title.Text = "RONY<b>HUB</b>"
Title.RichText = true
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 24
Title.TextColor3 = CurrentTheme.Text
Title.Size = UDim2.new(1, 0, 0, 60)
Title.BackgroundTransparency = 1
Title.Parent = Sidebar

local Ver = Instance.new("TextLabel")
Ver.Text = "V15 ULTIMATE"
Ver.Font = Enum.Font.GothamBold
Ver.TextSize = 10
Ver.TextColor3 = CurrentTheme.Accent
Ver.Size = UDim2.new(1, 0, 0, 20)
Ver.Position = UDim2.new(0, 0, 0, 40)
Ver.BackgroundTransparency = 1
Ver.Parent = Sidebar
table.insert(ThemeObjects.Texts, Ver) -- Para trocar a cor do acento

-- Botão de Fechar (Minimizar)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "—"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.Parent = MainFrame

-- Lógica de Abrir/Fechar
local function ToggleMenu()
    State.Open = not State.Open
    if State.Open then
        OpenBtn.Visible = false
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 380)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.3)
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end
end
CloseBtn.MouseButton1Click:Connect(ToggleMenu)
OpenBtn.MouseButton1Click:Connect(ToggleMenu)

--// SISTEMA DE ABAS
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 1, -80)
TabContainer.Position = UDim2.new(0, 0, 0, 80)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Sidebar
local TabList = Instance.new("UIListLayout"); TabList.Padding = UDim.new(0, 5); TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center; TabList.Parent = TabContainer

local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, -150, 1, 0)
PagesContainer.Position = UDim2.new(0, 150, 0, 0)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = MainFrame

local function CreatePage()
    local P = Instance.new("ScrollingFrame")
    P.Size = UDim2.new(1, -20, 1, -20)
    P.Position = UDim2.new(0, 10, 0, 10)
    P.BackgroundTransparency = 1
    P.ScrollBarThickness = 2
    P.Visible = false
    P.Parent = PagesContainer
    local L = Instance.new("UIListLayout"); L.Padding = UDim.new(0, 8); L.Parent = P
    return P
end

local Tabs = {}
local function SwitchTab(btn, page)
    for _, t in pairs(Tabs) do 
        TweenService:Create(t, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150,150,150)}):Play()
    end
    for _, p in pairs(PagesContainer:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
    
    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, TextColor3 = CurrentTheme.Accent}):Play()
    page.Visible = true
end

local function AddTab(name, icon, page)
    local B = Instance.new("TextButton")
    B.Text = icon .. "  " .. name
    B.Size = UDim2.new(0.9, 0, 0, 35)
    B.BackgroundColor3 = CurrentTheme.Accent
    B.BackgroundTransparency = 1
    B.TextColor3 = Color3.fromRGB(150, 150, 150)
    B.Font = Enum.Font.GothamMedium
    B.TextSize = 13
    B.Parent = TabContainer
    MakeCorner(B, 6)
    
    B.MouseButton1Click:Connect(function() SwitchTab(B, page) end)
    table.insert(Tabs, B)
    if #Tabs == 1 then SwitchTab(B, page) end -- Seleciona a primeira
    return B
end

local function AddToggle(page, text, callback)
    local F = Instance.new("Frame"); F.Size = UDim2.new(1, 0, 0, 40); F.BackgroundColor3 = Color3.fromRGB(25, 25, 30); F.Parent = page; MakeCorner(F, 6)
    local L = Instance.new("TextLabel"); L.Text = text; L.TextColor3 = Color3.fromRGB(220, 220, 220); L.Font = Enum.Font.GothamMedium; L.TextSize = 12; L.Size = UDim2.new(0.7, 0, 1, 0); L.Position = UDim2.new(0, 10, 0, 0); L.BackgroundTransparency = 1; L.TextXAlignment = Enum.TextXAlignment.Left; L.Parent = F
    local B = Instance.new("TextButton"); B.Text = ""; B.Size = UDim2.new(0, 36, 0, 18); B.Position = UDim2.new(1, -46, 0.5, -9); B.BackgroundColor3 = Color3.fromRGB(40, 40, 45); B.Parent = F; MakeCorner(B, 9)
    local C = Instance.new("Frame"); C.Size = UDim2.new(0, 14, 0, 14); C.Position = UDim2.new(0, 2, 0.5, -7); C.BackgroundColor3 = Color3.fromRGB(255, 255, 255); C.Parent = B; MakeCorner(C, 7)
    
    local on = false
    B.MouseButton1Click:Connect(function()
        on = not on
        local goal = on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local col = on and CurrentTheme.Accent or Color3.fromRGB(40, 40, 45)
        TweenService:Create(C, TweenInfo.new(0.2), {Position = goal}):Play()
        TweenService:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = col}):Play()
        callback(on)
    end)
    table.insert(ThemeObjects.Backgrounds, B) -- Para mudar cor do toggle ativo com tema
end

local function AddButton(page, text, callback)
    local B = Instance.new("TextButton")
    B.Text = text
    B.Size = UDim2.new(1, 0, 0, 35)
    B.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Font = Enum.Font.GothamBold
    B.TextSize = 12
    B.Parent = page
    MakeCorner(B, 6)
    B.MouseButton1Click:Connect(callback)
end

--// 📄 PÁGINAS E CONTEÚDO
local PageHome = CreatePage()
local PageExtra = CreatePage()
local PageConfig = CreatePage()

AddTab("Inicio", "🏠", PageHome)
AddTab("Extras", "🎁", PageExtra)
AddTab("Config", "⚙️", PageConfig)

-- HOME
AddToggle(PageHome, "Auto Kaitun (Deus Mode)", function(v) State.AutoKaitun = v end)
AddToggle(PageHome, "Auto Dig (Cavar Turbo 5x)", function(v) State.FarmTerra = v end)
AddToggle(PageHome, "Auto Sell (Vender Rápido)", function(v) State.AutoSell = v end)
AddToggle(PageHome, "Anti-AFK (Não cai)", function(v) State.AntiAfk = v end)

-- EXTRA
AddToggle(PageExtra, "Auto Transform (Santa)", function(v) State.AutoTransform = v end)
AddToggle(PageExtra, "Coletar Presentes", function(v) State.AutoGift = v end)

-- CONFIG (A NOVIDADE)
local function UpdateThemeColor(newColor)
    CurrentTheme.Accent = newColor
    -- Atualiza UI Elementos
    for _, s in pairs(ThemeObjects.Strokes) do s.Color = newColor end
    for _, t in pairs(ThemeObjects.Texts) do t.TextColor3 = newColor end
    OpenBtn.TextColor3 = newColor
    Ver.TextColor3 = newColor
end

local ConfigHeader = Instance.new("TextLabel"); ConfigHeader.Text = "TEMAS DA INTERFACE"; ConfigHeader.Size = UDim2.new(1,0,0,30); ConfigHeader.BackgroundTransparency=1; ConfigHeader.TextColor3=Color3.fromRGB(150,150,150); ConfigHeader.Font=Enum.Font.GothamBold; ConfigHeader.TextSize=12; ConfigHeader.Parent = PageConfig

AddButton(PageConfig, "🎨 Tema: Cyber Blue (Padrão)", function() UpdateThemeColor(Color3.fromRGB(0, 255, 200)) end)
AddButton(PageConfig, "🎨 Tema: Blood Red", function() UpdateThemeColor(Color3.fromRGB(255, 50, 50)) end)
AddButton(PageConfig, "🎨 Tema: Void Purple", function() UpdateThemeColor(Color3.fromRGB(170, 0, 255)) end)

local FPSHeader = Instance.new("TextLabel"); FPSHeader.Text = "OTIMIZAÇÃO (FPS)"; FPSHeader.Size = UDim2.new(1,0,0,30); FPSHeader.BackgroundTransparency=1; FPSHeader.TextColor3=Color3.fromRGB(150,150,150); FPSHeader.Font=Enum.Font.GothamBold; FPSHeader.TextSize=12; FPSHeader.Parent = PageConfig

AddButton(PageConfig, "🔥 FPS Boost (Remove Texturas)", function()
    -- Remove texturas e sombras para deixar leve
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("Texture") or v:IsA("Decal") then
            v:Destroy()
        end
    end
    game.StarterGui:SetCore("SendNotification", {Title = "FPS Boost"; Text = "Texturas removidas com sucesso!"; Duration = 3})
end)

--// 🧠 LÓGICA APELONA (FUNÇÕES)

-- 1. CAVAR METRALHADORA (5x Packets)
task.spawn(function()
    while true do
        if State.FarmTerra or State.AutoKaitun then
            if DigRemote then
                for i=1, 5 do -- Envia 5 sinais por frame (Limite seguro)
                    DigRemote:FireServer("finish")
                end
            end
        end
        task.wait() -- 1 Frame de espera
    end
end)

-- 2. TELEPORTE BYPASS
task.spawn(function()
    while true do
        if State.AutoKaitun then
            pcall(function()
                local hrp = LocalPlayer.Character.HumanoidRootPart
                local dist = (hrp.Position - SANTA_CFRAME.Position).Magnitude
                if dist > 6 then
                    hrp.CFrame = SANTA_CFRAME
                    hrp.AssemblyLinearVelocity = Vector3.zero -- Zera inércia (Bypass)
                end
            end)
        end
        task.wait(0.05)
    end
end)

-- 3. VENDER E EQUIPAR
task.spawn(function()
    while true do
        if State.AutoSell or State.AutoKaitun then
            SellRemote:FireServer("ALL")
            local bp = LocalPlayer.Backpack
            if bp then
                for _, t in pairs(bp:GetChildren()) do
                    if t:IsA("Tool") then
                        t.Parent = LocalPlayer.Character
                        SellRemote:FireServer("ALL")
                    end
                end
            end
        end
        task.wait(0.15)
    end
end)

-- 4. EXTRAS
task.spawn(function()
    while true do
        if State.AutoTransform or State.AutoKaitun then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait()
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
        task.wait(1)
    end
end)

task.spawn(function()
    while true do
        if State.AutoGift or State.AutoKaitun then
            local r = ReplicatedStorage:FindFirstChild("ToolRewardEvent")
            if r then r:FireServer() end
        end
        task.wait(2.5)
    end
end)

-- ANTI AFK
LocalPlayer.Idled:Connect(function()
    if State.AntiAfk or State.AutoKaitun then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.zero)
    end
end)

--// ARRASTAR UI (DRAG)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = MainFrame.Position end end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
MainFrame.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

game.StarterGui:SetCore("SendNotification", {Title = "Rony Hub V15"; Text = "Carregado! Abra a aba Config para Otimizar."; Duration = 5})
