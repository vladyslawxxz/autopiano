local Players         = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService     = game:GetService("HttpService")
local TweenService    = game:GetService("TweenService")
local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local BG      = Color3.fromRGB(18, 18, 22)
local SURFACE = Color3.fromRGB(26, 27, 34)
local BORDER  = Color3.fromRGB(45, 46, 58)
local ACCENT2 = Color3.fromRGB(72, 149, 239)
local GREEN   = Color3.fromRGB(52, 199, 89)
local RED     = Color3.fromRGB(255, 69, 58)
local TEXT    = Color3.fromRGB(230, 230, 235)
local SUBTEXT = Color3.fromRGB(140, 140, 155)
local CR      = UDim.new(0, 10)
local CS      = UDim.new(0, 6)
local BASE_URL = "https://raw.githubusercontent.com/vladyslawxxz/autopiano/refs/heads/main/songs/"
local TOTAL    = 20
local function corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = r or CR; c.Parent = p; return c
end
local function stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color = col or BORDER; s.Thickness = th or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = p; return s
end
local function tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad), props):Play()
end
local gui = Instance.new("ScreenGui")
gui.Name           = "AutoPianoPlayer"
gui.ResetOnSpawn   = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent         = playerGui
local frame = Instance.new("Frame")
frame.Size            = UDim2.new(0, 320, 0, 340)
frame.Position        = UDim2.new(0.5, -160, 0.5, -170)
frame.BackgroundColor3 = BG
frame.BorderSizePixel = 0
frame.Parent          = gui
corner(frame, CR)
stroke(frame, BORDER, 1)
local titleBar = Instance.new("Frame")
titleBar.Size                = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundTransparency = 1
titleBar.Parent              = frame
local titleLabel = Instance.new("TextLabel")
titleLabel.Size               = UDim2.new(1, -50, 1, 0)
titleLabel.Position           = UDim2.new(0, 14, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text               = "🎹 AutoPiano"
titleLabel.Font               = Enum.Font.GothamBold
titleLabel.TextSize           = 15
titleLabel.TextColor3         = TEXT
titleLabel.TextXAlignment     = Enum.TextXAlignment.Left
titleLabel.Parent             = titleBar
local closeBtn = Instance.new("TextButton")
closeBtn.Size             = UDim2.new(0, 28, 0, 28)
closeBtn.Position         = UDim2.new(1, -36, 0.5, -14)
closeBtn.Text             = "✕"
closeBtn.Font             = Enum.Font.GothamBold
closeBtn.TextSize         = 14
closeBtn.TextColor3       = SUBTEXT
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
closeBtn.BorderSizePixel  = 0
closeBtn.Parent           = titleBar
corner(closeBtn, UDim.new(0, 6))
closeBtn.MouseEnter:Connect(function() tw(closeBtn, {TextColor3 = TEXT, BackgroundColor3 = Color3.fromRGB(60,30,35)}) end)
closeBtn.MouseLeave:Connect(function() tw(closeBtn, {TextColor3 = SUBTEXT, BackgroundColor3 = Color3.fromRGB(40,40,50)}) end)
local divider = Instance.new("Frame")
divider.Size             = UDim2.new(1, -24, 0, 1)
divider.Position         = UDim2.new(0, 12, 0, 44)
divider.BackgroundColor3 = BORDER
divider.BorderSizePixel  = 0
divider.Parent           = frame
local listContainer = Instance.new("ScrollingFrame")
listContainer.Size                = UDim2.new(1, -24, 0, 256)
listContainer.Position            = UDim2.new(0, 12, 0, 54)
listContainer.BackgroundColor3    = SURFACE
listContainer.BorderSizePixel     = 0
listContainer.ScrollBarThickness  = 4
listContainer.ScrollBarImageColor3 = BORDER
listContainer.CanvasSize          = UDim2.new(0, 0, 0, 0)
listContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
listContainer.Parent              = frame
corner(listContainer, CS)
stroke(listContainer, BORDER, 1)
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding   = UDim.new(0, 2)
listLayout.Parent    = listContainer
local listPad = Instance.new("UIPadding")
listPad.PaddingTop    = UDim.new(0, 5)
listPad.PaddingBottom = UDim.new(0, 5)
listPad.PaddingLeft   = UDim.new(0, 6)
listPad.PaddingRight  = UDim.new(0, 6)
listPad.Parent        = listContainer
local statusLabel = Instance.new("TextLabel")
statusLabel.Size              = UDim2.new(1, -24, 0, 18)
statusLabel.Position          = UDim2.new(0, 12, 0, 316)
statusLabel.BackgroundTransparency = 1
statusLabel.Text              = "Loading..."
statusLabel.Font              = Enum.Font.Gotham
statusLabel.TextSize          = 11
statusLabel.TextColor3        = SUBTEXT
statusLabel.TextXAlignment    = Enum.TextXAlignment.Left
statusLabel.Parent            = frame
local openBtn = Instance.new("TextButton")
openBtn.Size             = UDim2.new(0, 120, 0, 36)
openBtn.Position         = UDim2.new(0, 12, 1, -48)
openBtn.Text             = "🎹 AutoPiano"
openBtn.Font             = Enum.Font.GothamBold
openBtn.TextSize         = 13
openBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
openBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
openBtn.BorderSizePixel  = 0
openBtn.Visible          = false
openBtn.Parent           = gui
corner(openBtn, CS)
stroke(openBtn, BORDER, 1)
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible   = false
    openBtn.Visible = true
end)
openBtn.MouseButton1Click:Connect(function()
    frame.Visible   = true
    openBtn.Visible = false
end)
local dragging, dragStart, startPos = false, nil, nil
local function onDragBegan(pos)
    dragging  = true
    dragStart = pos
    startPos  = frame.Position
end
local function onDragMoved(pos)
    if not dragging then return end
    local d = pos - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + d.X,
        startPos.Y.Scale, startPos.Y.Offset + d.Y
    )
end
local function onDragEnded()
    dragging = false
end
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        onDragBegan(input.Position)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then onDragEnded() end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        onDragMoved(input.Position)
    end
end)
local VK = {
    Backspace=0x08,Tab=0x09,Return=0x0D,LeftShift=0xA0,RightShift=0xA1,
    LeftControl=0xA2,RightControl=0xA3,LeftAlt=0xA4,RightAlt=0xA5,
    Pause=0x13,CapsLock=0x14,Escape=0x1B,Space=0x20,PageUp=0x21,
    PageDown=0x22,End=0x23,Home=0x24,Left=0x25,Up=0x26,Right=0x27,
    Down=0x28,Insert=0x2D,Delete=0x2E,Semicolon=0xBA,Equals=0xBB,
    Comma=0xBC,Minus=0xBD,Period=0xBE,Slash=0xBF,Backquote=0xC0,
    LeftBracket=0xDB,BackSlash=0xDC,RightBracket=0xDD,Quote=0xDE,
}
VK.Zero=0x30 VK.One=0x31 VK.Two=0x32 VK.Three=0x33 VK.Four=0x34
VK.Five=0x35 VK.Six=0x36 VK.Seven=0x37 VK.Eight=0x38 VK.Nine=0x39
for i=1,12 do VK["F"..i]=0x6F+i end
for c=string.byte("A"),string.byte("Z") do VK[string.char(c)]=c end
local vimOk, VIM = pcall(function() return game:GetService("VirtualInputManager") end)
local function emitKey(isDown, keyCode)
    if vimOk and VIM and VIM.SendKeyEvent then
        VIM:SendKeyEvent(isDown, keyCode, false, game)
        return true
    end
    local n = VK[keyCode.Name]
    if not n then return false end
    if isDown and keypress   then pcall(keypress,   n) return true end
    if (not isDown) and keyrelease then pcall(keyrelease, n) return true end
    return false
end
local SLEEP_THRESHOLD = 0.004
local SPIN_WINDOW     = 0.002
local isPlaying       = false
local currentEntry    = nil
local function makeRow(idx, name, author, events)
    local row = Instance.new("Frame")
    row.Size             = UDim2.new(1, 0, 0, 42)
    row.LayoutOrder      = idx
    row.BackgroundColor3 = Color3.fromRGB(30, 32, 40)
    row.BorderSizePixel  = 0
    row.Parent           = listContainer
    corner(row, UDim.new(0, 6))
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft  = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 8)
    pad.Parent       = row
    local badge = Instance.new("TextLabel")
    badge.Size               = UDim2.new(0, 22, 0, 22)
    badge.Position           = UDim2.new(0, 0, 0.5, -11)
    badge.BackgroundColor3   = Color3.fromRGB(40, 42, 55)
    badge.Text               = tostring(idx)
    badge.Font               = Enum.Font.GothamBold
    badge.TextSize           = 11
    badge.TextColor3         = SUBTEXT
    badge.BorderSizePixel    = 0
    badge.Parent             = row
    corner(badge, UDim.new(0, 5))
    local lbl = Instance.new("TextLabel")
    lbl.Size             = UDim2.new(1, -110, 0, 18)
    lbl.Position         = UDim2.new(0, 30, 0.5, -18)
    lbl.BackgroundTransparency = 1
    lbl.Text             = name
    lbl.Font             = Enum.Font.GothamSemibold
    lbl.TextSize         = 13
    lbl.TextColor3       = TEXT
    lbl.TextXAlignment   = Enum.TextXAlignment.Left
    lbl.TextTruncate     = Enum.TextTruncate.AtEnd
    lbl.Parent           = row
    local sub = Instance.new("TextLabel")
    sub.Size             = UDim2.new(1, -110, 0, 14)
    sub.Position         = UDim2.new(0, 30, 0.5, 2)
    sub.BackgroundTransparency = 1
    sub.Text             = author
    sub.Font             = Enum.Font.Gotham
    sub.TextSize         = 11
    sub.TextColor3       = SUBTEXT
    sub.TextXAlignment   = Enum.TextXAlignment.Left
    sub.TextTruncate     = Enum.TextTruncate.AtEnd
    sub.Parent           = row
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(0, 68, 0, 28)
    btn.Position         = UDim2.new(1, -68, 0.5, -14)
    btn.Text             = "▶ Play"
    btn.Font             = Enum.Font.GothamSemibold
    btn.TextSize         = 12
    btn.TextColor3       = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = ACCENT2
    btn.BorderSizePixel  = 0
    btn.Parent           = row
    corner(btn, UDim.new(0, 6))
    local entry = {row=row, btn=btn, playing=false, events=events, name=name}
    local function setEntryState(playing)
        entry.playing = playing
        if playing then
            tw(btn, {BackgroundColor3 = RED}, 0.12)
            btn.Text = "■ Stop"
        else
            tw(btn, {BackgroundColor3 = ACCENT2}, 0.12)
            btn.Text = "▶ Play"
        end
    end
    local function stopEntry(reason)
        isPlaying    = false
        currentEntry = nil
        setEntryState(false)
        statusLabel.Text = reason or "Stopped"
    end
    local function startEntry()
        if isPlaying and currentEntry and currentEntry ~= entry then
            isPlaying = false
            currentEntry.playing = false
            tw(currentEntry.btn, {BackgroundColor3 = ACCENT2}, 0.12)
            currentEntry.btn.Text = "▶ Play"
        end
        if type(events) ~= "table" or #events == 0 then
            statusLabel.Text = "No events in " .. name
            return
        end
        isPlaying    = true
        currentEntry = entry
        setEntryState(true)
        statusLabel.Text = string.format("Playing %d events — %s", #events, name)
        task.spawn(function()
            local n      = #events
            local sorted = table.create(n)
            for i = 1, n do
                local ev = events[i]
                sorted[i] = {
                    t     = math.max(tonumber(ev.t) or 0, 0),
                    key   = tostring(ev.key),
                    state = tostring(ev.state),
                    idx   = i,
                }
            end
            table.sort(sorted, function(a, b)
                if a.t == b.t then return a.idx < b.idx end
                return a.t < b.t
            end)
            local origin = os.clock()
            for i = 1, n do
                if not isPlaying or currentEntry ~= entry then return end
                local ev         = sorted[i]
                local targetTime = origin + ev.t
                local remaining  = targetTime - os.clock()
                if remaining > SLEEP_THRESHOLD then
                    task.wait(remaining - SPIN_WINDOW)
                end
                while os.clock() < targetTime do end
                if not isPlaying or currentEntry ~= entry then return end
                local enumKey = Enum.KeyCode[ev.key]
                if enumKey then
                    local ok = false
                    if ev.state == "down" then
                        ok = emitKey(true, enumKey)
                    elseif ev.state == "up" then
                        ok = emitKey(false, enumKey)
                    end
                    if not ok then stopEntry("No input API available") return end
                end
            end
            stopEntry("Done — " .. name)
        end)
    end
    btn.MouseButton1Click:Connect(function()
        if entry.playing then stopEntry("Stopped by user") else startEntry() end
    end)
    return entry
end
local placeholders = {}
for i = 1, TOTAL do
    local ph = Instance.new("Frame")
    ph.Size             = UDim2.new(1, 0, 0, 42)
    ph.LayoutOrder      = i
    ph.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
    ph.BorderSizePixel  = 0
    ph.Parent           = listContainer
    corner(ph, UDim.new(0, 6))
    local phLbl = Instance.new("TextLabel")
    phLbl.Size               = UDim2.new(1, -20, 1, 0)
    phLbl.Position           = UDim2.new(0, 12, 0, 0)
    phLbl.BackgroundTransparency = 1
    phLbl.Text               = "Loading s" .. i .. ".json..."
    phLbl.Font               = Enum.Font.Gotham
    phLbl.TextSize           = 12
    phLbl.TextColor3         = SUBTEXT
    phLbl.TextXAlignment     = Enum.TextXAlignment.Left
    phLbl.Parent             = ph
    placeholders[i] = ph
end
local loaded = 0
local failed = 0
task.spawn(function()
    for i = 1, TOTAL do
        local url = BASE_URL .. i .. ".json"
        local ok, raw = pcall(function()
            return game:HttpGet(url)
        end)
        if ok and raw then
            local jOk, data = pcall(function()
                return HttpService:JSONDecode(raw)
            end)
            if jOk and type(data) == "table" and data.type == "keyboard_macro" then
                local name   = tostring(data.name   or ("Track " .. i))
                local author = tostring(data.author  or "Unknown")
                local events = type(data.events) == "table" and data.events or {}
                if placeholders[i] then
                    placeholders[i]:Destroy()
                    placeholders[i] = nil
                end
                makeRow(i, name, author, events)
                loaded = loaded + 1
            else
                if placeholders[i] then
                    placeholders[i]:FindFirstChildOfClass("TextLabel").Text = "s" .. i .. " — invalid format"
                    placeholders[i]:FindFirstChildOfClass("TextLabel").TextColor3 = Color3.fromRGB(180,80,80)
                end
                failed = failed + 1
            end
        else
            if placeholders[i] then
                placeholders[i]:FindFirstChildOfClass("TextLabel").Text = "s" .. i .. " — not found"
                placeholders[i]:FindFirstChildOfClass("TextLabel").TextColor3 = Color3.fromRGB(100,100,110)
            end
            failed = failed + 1
        end
        statusLabel.Text = string.format("Loaded %d / %d ...", loaded, TOTAL - failed)
        task.wait()  
    end
    if failed == TOTAL then
        statusLabel.Text = "No tracks found. Check repo."
    elseif failed > 0 then
        statusLabel.Text = string.format("%d tracks loaded, %d not found", loaded, failed)
    else
        statusLabel.Text = string.format("All %d tracks ready", loaded)
    end
end)
