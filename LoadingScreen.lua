--[[
    WindUI – Loading Screen
    ========================
    Paste this at the TOP of your script, before any WindUI setup.
    It shows a cinematic loading screen while WindUI (and your UI) loads,
    then fades out cleanly once everything is ready.

    Customise:
        LOADING_TITLE   – big header text
        LOADING_TIPS    – rotated tip shown at the bottom
        DISCORD_LINK    – your Discord invite shown at the bottom
        ACCENT_COLOR    – the spinner / ring colour
        STEPS           – table of { label, function } load steps
]]

-- ─────────────────────────────────────────────────────────────
--  CONFIG
-- ─────────────────────────────────────────────────────────────
local LOADING_TITLE  = "Loading Script"
local DISCORD_LINK   = "discord.gg/YourInvite"
local ACCENT_COLOR   = Color3.fromRGB(56, 152, 255)   -- blue ring
local BG_COLOR       = Color3.fromRGB(14, 14, 20)
local CARD_COLOR     = Color3.fromRGB(22, 22, 32)
local TEXT_COLOR     = Color3.fromRGB(220, 220, 230)
local SUB_COLOR      = Color3.fromRGB(120, 120, 145)

local LOADING_TIPS = {
    "Hold RightShift to toggle the menu open or closed.",
    "Use tabs to keep your features organised.",
    "Premium users get access to exclusive features.",
    "Developer tools are hidden from regular users.",
    "Report bugs in our Discord server!",
}

-- ─────────────────────────────────────────────────────────────
--  SERVICES
-- ─────────────────────────────────────────────────────────────
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local LocalPlayer    = Players.LocalPlayer
local PlayerGui      = LocalPlayer:WaitForChild("PlayerGui")

-- ─────────────────────────────────────────────────────────────
--  SCREEN GUI
-- ─────────────────────────────────────────────────────────────
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "WindUI_LoadingScreen"
ScreenGui.IgnoreGuiInset  = true
ScreenGui.DisplayOrder    = 999
ScreenGui.ResetOnSpawn    = false
ScreenGui.Parent          = PlayerGui

-- Full-screen dark background
local Background = Instance.new("Frame")
Background.Size                = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3    = BG_COLOR
Background.BorderSizePixel     = 0
Background.ZIndex              = 1
Background.Parent              = ScreenGui

-- ─────────────────────────────────────────────────────────────
--  TOP-LEFT LABEL  (e.g. "991F8" player tag)
-- ─────────────────────────────────────────────────────────────
local TagFrame = Instance.new("Frame")
TagFrame.Size               = UDim2.new(0, 70, 0, 22)
TagFrame.Position           = UDim2.new(0, 14, 0, 14)
TagFrame.BackgroundColor3   = Color3.fromRGB(32, 32, 44)
TagFrame.BorderSizePixel    = 0
TagFrame.ZIndex             = 2
TagFrame.Parent             = Background
Instance.new("UICorner", TagFrame).CornerRadius = UDim.new(0, 5)

local TagLabel = Instance.new("TextLabel")
TagLabel.Size                = UDim2.new(1, 0, 1, 0)
TagLabel.BackgroundTransparency = 1
TagLabel.Text                = "● " .. (LocalPlayer.Name:sub(1,5):upper())
TagLabel.TextColor3          = SUB_COLOR
TagLabel.TextSize            = 11
TagLabel.Font                = Enum.Font.GothamMedium
TagLabel.ZIndex              = 3
TagLabel.Parent              = TagFrame

-- ─────────────────────────────────────────────────────────────
--  CENTRE CARD
-- ─────────────────────────────────────────────────────────────
local Card = Instance.new("Frame")
Card.Size                 = UDim2.new(0, 310, 0, 230)
Card.Position             = UDim2.new(0.5, -155, 0.5, -115)
Card.BackgroundColor3     = CARD_COLOR
Card.BorderSizePixel      = 0
Card.ZIndex               = 2
Card.Parent               = Background
Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 14)

-- Subtle card border
local CardStroke = Instance.new("UIStroke", Card)
CardStroke.Color       = Color3.fromRGB(45, 45, 65)
CardStroke.Thickness   = 1
CardStroke.Transparency = 0.3

-- ─────────────────────────────────────────────────────────────
--  TITLE ROW  ("Loading Script" + eye icon)
-- ─────────────────────────────────────────────────────────────
local TitleRow = Instance.new("Frame")
TitleRow.Size                    = UDim2.new(1, -30, 0, 28)
TitleRow.Position                = UDim2.new(0, 15, 0, 22)
TitleRow.BackgroundTransparency  = 1
TitleRow.ZIndex                  = 3
TitleRow.Parent                  = Card

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size                = UDim2.new(1, -30, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text                = LOADING_TITLE
TitleLabel.TextColor3          = TEXT_COLOR
TitleLabel.TextSize            = 22
TitleLabel.Font                = Enum.Font.GothamBold
TitleLabel.TextXAlignment      = Enum.TextXAlignment.Center
TitleLabel.ZIndex              = 3
TitleLabel.Parent              = TitleRow

-- Eye / hide icon (decorative, top-right of title)
local EyeLabel = Instance.new("TextLabel")
EyeLabel.Size                 = UDim2.new(0, 22, 0, 22)
EyeLabel.Position             = UDim2.new(1, -22, 0, 3)
EyeLabel.BackgroundTransparency = 1
EyeLabel.Text                 = "👁"
EyeLabel.TextSize             = 14
EyeLabel.Font                 = Enum.Font.Gotham
EyeLabel.TextColor3           = SUB_COLOR
EyeLabel.ZIndex               = 3
EyeLabel.Parent               = TitleRow

-- Subtitle / status line
local SubLabel = Instance.new("TextLabel")
SubLabel.Size                 = UDim2.new(1, -30, 0, 18)
SubLabel.Position             = UDim2.new(0, 15, 0, 52)
SubLabel.BackgroundTransparency = 1
SubLabel.Text                 = "Preparing your experience..."
SubLabel.TextColor3           = SUB_COLOR
SubLabel.TextSize             = 13
SubLabel.Font                 = Enum.Font.Gotham
SubLabel.TextXAlignment       = Enum.TextXAlignment.Center
SubLabel.ZIndex               = 3
SubLabel.Parent               = Card

-- ─────────────────────────────────────────────────────────────
--  SPINNER  (rotating arc drawn with ImageLabel)
-- ─────────────────────────────────────────────────────────────
local SpinnerFrame = Instance.new("Frame")
SpinnerFrame.Size                    = UDim2.new(0, 80, 0, 80)
SpinnerFrame.Position                = UDim2.new(0.5, -40, 0, 78)
SpinnerFrame.BackgroundTransparency  = 1
SpinnerFrame.ZIndex                  = 3
SpinnerFrame.Parent                  = Card

-- Outer dim ring (track)
local TrackRing = Instance.new("ImageLabel")
TrackRing.Size                = UDim2.new(1, 0, 1, 0)
TrackRing.BackgroundTransparency = 1
TrackRing.Image               = "rbxassetid://4965945816"  -- circle image
TrackRing.ImageColor3         = Color3.fromRGB(40, 40, 58)
TrackRing.ZIndex              = 3
TrackRing.Parent              = SpinnerFrame

-- Spinning arc (accent colour)
local SpinArc = Instance.new("ImageLabel")
SpinArc.Size                 = UDim2.new(1, 0, 1, 0)
SpinArc.BackgroundTransparency = 1
SpinArc.Image                = "rbxassetid://4965945816"
SpinArc.ImageColor3          = ACCENT_COLOR
SpinArc.ZIndex               = 4
SpinArc.Parent               = SpinnerFrame

-- Gradient mask so it looks like an arc not a full circle
local ArcGradient = Instance.new("UIGradient", SpinArc)
ArcGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,   0),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1,   1),
})
ArcGradient.Rotation = 0

-- "Loading.." text centred in spinner
local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Size                 = UDim2.new(1, 0, 1, 0)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text                 = "Loading.."
LoadingLabel.TextColor3           = TEXT_COLOR
LoadingLabel.TextSize             = 13
LoadingLabel.Font                 = Enum.Font.GothamMedium
LoadingLabel.TextXAlignment       = Enum.TextXAlignment.Center
LoadingLabel.TextYAlignment       = Enum.TextYAlignment.Center
LoadingLabel.ZIndex               = 5
LoadingLabel.Parent               = SpinnerFrame

-- ─────────────────────────────────────────────────────────────
--  TIP  (bottom of card)
-- ─────────────────────────────────────────────────────────────
local TipLabel = Instance.new("TextLabel")
TipLabel.Size                 = UDim2.new(1, -30, 0, 32)
TipLabel.Position             = UDim2.new(0, 15, 1, -70)
TipLabel.BackgroundTransparency = 1
TipLabel.Text                 = "Tip: " .. LOADING_TIPS[math.random(#LOADING_TIPS)]
TipLabel.TextColor3           = SUB_COLOR
TipLabel.TextSize             = 11
TipLabel.Font                 = Enum.Font.Gotham
TipLabel.TextWrapped          = true
TipLabel.RichText             = true
TipLabel.TextXAlignment       = Enum.TextXAlignment.Center
TipLabel.ZIndex               = 3
TipLabel.Parent               = Card

-- Divider above tip
local Divider = Instance.new("Frame")
Divider.Size                = UDim2.new(1, -30, 0, 1)
Divider.Position            = UDim2.new(0, 15, 1, -75)
Divider.BackgroundColor3    = Color3.fromRGB(45, 45, 65)
Divider.BorderSizePixel     = 0
Divider.ZIndex              = 3
Divider.Parent              = Card

-- Discord link at very bottom
local DiscordLabel = Instance.new("TextLabel")
DiscordLabel.Size                 = UDim2.new(1, -30, 0, 18)
DiscordLabel.Position             = UDim2.new(0, 15, 1, -34)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Text                 = DISCORD_LINK
DiscordLabel.TextColor3           = ACCENT_COLOR
DiscordLabel.TextSize             = 11
DiscordLabel.Font                 = Enum.Font.Gotham
DiscordLabel.TextXAlignment       = Enum.TextXAlignment.Center
DiscordLabel.ZIndex               = 3
DiscordLabel.Parent               = Card

-- ─────────────────────────────────────────────────────────────
--  SPINNER ANIMATION  (runs on RenderStepped)
-- ─────────────────────────────────────────────────────────────
local spinAngle    = 0
local gradAngle    = 0
local spinConn = RunService.RenderStepped:Connect(function(dt)
    spinAngle  = (spinAngle  + dt * 220) % 360
    gradAngle  = (gradAngle  + dt * 180) % 360
    SpinArc.Rotation          = spinAngle
    ArcGradient.Rotation      = gradAngle
end)

-- Dots animation on "Loading.." label
local dotConn
do
    local dots  = 0
    local timer = 0
    dotConn = RunService.Heartbeat:Connect(function(dt)
        timer = timer + dt
        if timer >= 0.4 then
            timer = 0
            dots  = (dots + 1) % 4
            LoadingLabel.Text = "Loading" .. string.rep(".", dots)
        end
    end)
end

-- ─────────────────────────────────────────────────────────────
--  LOAD STEPS
--  Add your own steps here — each one runs in order.
--  The SubLabel updates to show the current step name.
-- ─────────────────────────────────────────────────────────────
local function setStatus(msg)
    SubLabel.Text = msg
end

local function loadStep(label, fn)
    setStatus(label)
    task.wait(0.05)   -- let the frame render the new status
    local ok, err = pcall(fn)
    if not ok then
        warn("[WindUI LoadingScreen] Step failed: " .. label .. "\n" .. tostring(err))
    end
end

-- ─── YOUR ACTUAL LOAD STEPS GO BELOW ───────────────────────
local WindUI

loadStep("Fetching WindUI library...", function()
    WindUI = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"
    ))()
end)

loadStep("Configuring access control...", function()
    -- Replace with your real UserIds
    WindUI:SetDevIds({
        12345678,
    })
    WindUI:SetPremiumIds({
        87654321,
    })
end)

loadStep("Building window...", function()
    -- ── CREATE YOUR WINDOW & TABS HERE ──────────────────────
    local Window = WindUI:CreateWindow({
        Title  = "My Hub",
        Icon   = "lucide:layout-dashboard",
        Theme  = "Dark",
        Folder = "MyHub",
    })

    local HomeTab = Window:Tab({ Title = "Home", Icon = "lucide:home" })
    HomeTab:Button({
        Title    = "Example Button",
        Callback = function() print("Clicked!") end,
    })

    local DevTab = Window:DevTab({ Title = "Developer" })
    DevTab:DevToggle({
        Title    = "Infinite Stamina",
        Value    = false,
        Callback = function(v) print("Stamina:", v) end,
    })

    local PremTab = Window:PremTab({ Title = "Premium" })
    PremTab:PremButton({
        Title    = "Auto Farm",
        Callback = function() print("Farming!") end,
    })
    -- ── END OF YOUR WINDOW SETUP ────────────────────────────
end)

loadStep("Finishing up...", function()
    task.wait(0.3)
end)

-- ─────────────────────────────────────────────────────────────
--  FADE OUT the loading screen once all steps are done
-- ─────────────────────────────────────────────────────────────
spinConn:Disconnect()
dotConn:Disconnect()
LoadingLabel.Text = "Done!"

TweenService:Create(Background, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
    BackgroundTransparency = 1,
}):Play()
TweenService:Create(Card, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
    BackgroundTransparency = 1,
    Position = UDim2.new(0.5, -155, 0.5, -95),
}):Play()

task.wait(0.65)
ScreenGui:Destroy()

