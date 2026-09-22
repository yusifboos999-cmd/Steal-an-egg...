-- Egg Steal Mobile Script
-- Hand Menu / UI for Mobile (Delta Executor Compatible)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Egg Steal Hub 🥚",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by GitHub Community",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Variables
local LocalPlayer = game.Players.LocalPlayer
local AntiHitEnabled = false
local AntiTrapEnabled = false
local EggESPEnabled = false
local ESPObjects = {}

-- Main Tab
local MainTab = Window:CreateTab("الحماية (Anti)", 4483362458)

-- Anti Hit Toggle
MainTab:CreateToggle({
   Name = "Anti Hit (حماية من الضرب)",
   CurrentValue = false,
   Callback = function(Value)
      AntiHitEnabled = Value
      task.spawn(function()
         while AntiHitEnabled do
            pcall(function()
               local char = LocalPlayer.Character
               if char then
                  for _, part in pairs(char:GetChildren()) do
                     if part:IsA("BasePart") then
                        part.CanTouch = not AntiHitEnabled
                     end
                  end
               end
            end)
            task.wait(0.1)
         end
      end)
   end,
})

-- Anti Trap Toggle
MainTab:CreateToggle({
   Name = "Anti Trap (حماية من الفخاخ)",
   CurrentValue = false,
   Callback = function(Value)
      AntiTrapEnabled = Value
      task.spawn(function()
         while AntiTrapEnabled do
            pcall(function()
               for _, obj in pairs(workspace:GetDescendants()) do
                  if obj.Name:lower():find("trap") or obj.Name:lower():find("fakh") then
                     if obj:IsA("BasePart") then
                        obj.CanTouch = not AntiTrapEnabled
                     end
                  end
               end
            end)
            task.wait(0.5)
         end
      end)
   end,
})

-- ESP Tab
local ESPTab = Window:CreateTab("كشف البيض (ESP)", 4483362458)

local function ClearESP()
   for _, esp in pairs(ESPObjects) do
      if esp and esp.Parent then
         esp:Destroy()
      end
   end
   ESPObjects = {}
end

local function CreateEggESP(egg)
   if egg:FindFirstChild("EggInfoUI") then return end

   local billboard = Instance.new("BillboardGui")
   billboard.Name = "EggInfoUI"
   billboard.Adornee = egg
   billboard.Size = UDim2.new(0, 140, 0, 45)
   billboard.StudsOffset = Vector3.new(0, 2, 0)
   billboard.AlwaysOnTop = true

   local textLabel = Instance.new("TextLabel")
   textLabel.Parent = billboard
   textLabel.Size = UDim2.new(1, 0, 1, 0)
   textLabel.BackgroundTransparency = 1
   textLabel.TextColor3 = Color3.fromRGB(255, 230, 0)
   textLabel.TextSize = 10
   textLabel.Font = Enum.Font.SourceSansBold

   -- Read attributes or children
   local weight = egg:GetAttribute("Weight") or (egg:FindFirstChild("Weight") and egg.Weight.Value) or "N/A"
   local price = egg:GetAttribute("Price") or (egg:FindFirstChild("Price") and egg.Price.Value) or "N/A"
   local rarity = egg:GetAttribute("Rarity") or (egg:FindFirstChild("Rarity") and egg.Rarity.Value) or "عادي"

   textLabel.Text = string.format("🥚 %s\nالوزن: %s | السعر: %s\nالندرة: %s", egg.Name, tostring(weight), tostring(price), tostring(rarity))
   billboard.Parent = egg
   table.insert(ESPObjects, billboard)
end

ESPTab:CreateToggle({
   Name = "ESP Egg (تفعيل كشف البيانات)",
   CurrentValue = false,
   Callback = function(Value)
      EggESPEnabled = Value
      if not Value then
         ClearESP()
      else
         task.spawn(function()
            while EggESPEnabled do
               pcall(function()
                  for _, obj in pairs(workspace:GetDescendants()) do
                     if obj.Name:lower():find("egg") and (obj:IsA("BasePart") or obj:IsA("Model")) then
                        CreateEggESP(obj)
                     end
                  end
               end)
               task.wait(1)
            end
         end)
      end
   end,
})

Rayfield:Notify({
   Title = "Egg Steal Script",
   Content = "تم تشغيل السكربت بنجاح!",
   Duration = 3,
   Image = 4483362458,
})
