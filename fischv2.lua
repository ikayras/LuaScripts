-- UI Library Setup
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ui-library-sample/main.lua"))()
local Window = Library:CreateWindow("Fishing & Treasure Script")
local Tab = Window:CreateTab("Auto Farm")

-- Variables
local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local rodName = ""

-- Function to Find Rod Name
local function getRodName()
    for _, item in ipairs(player.Backpack:GetChildren()) do
        if item:IsA("Tool") and string.find(item.Name, "Rod") then
            return item.Name
        end
    end
    return nil
end

-- Cast Function
local function castRod()
    rodName = getRodName()
    if rodName then
        local rod = player.Backpack:FindFirstChild(rodName)
        if rod and rod:FindFirstChild("events") and rod.events:FindFirstChild("cast") then
            local args = {
                [1] = 100,
                [2] = 1
            }
            rod.events.cast:FireServer(unpack(args))
        end
    else
        warn("No rod found in backpack!")
    end
end

-- Shake Button Function
local function waitForReel()
    while not player.PlayerGui:FindFirstChild("shakeui") do
        task.wait(0.1)
    end
    local button = player.PlayerGui.shakeui.safezone.button
    while not player.PlayerGui:FindFirstChild("reelguis") do
        button:FireServer()
        task.wait(0.1)
    end
end

-- Reel Finish Function
local function finishReel()
    local args = {
        [1] = 100,
        [2] = false
    }
    replicatedStorage:WaitForChild("events"):WaitForChild("reelfinished"):FireServer(unpack(args))
end

-- Auto Farm Function
local function autoFarm()
    while true do
        castRod()
        waitForReel()
        finishReel()
        task.wait(1) -- Delay to avoid spam
    end
end

-- Treasure Map Function
local function getTreasureMap()
    local jackMarrow = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Jack Marrow")
    if jackMarrow:FindFirstChild("treasure") and jackMarrow.treasure:FindFirstChild("repairmap") then
        jackMarrow.treasure.repairmap:InvokeServer()
    else
        warn("Treasure map could not be found!")
    end
end

-- UI Buttons
Tab:CreateButton("Start Auto Farm", function()
    autoFarm()
end)

Tab:CreateButton("Get Treasure Map (250C Required)", function()
    getTreasureMap()
end)
