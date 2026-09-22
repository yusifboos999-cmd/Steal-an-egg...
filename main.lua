-- Steal an Egg Mobile Script (Updated Version)
-- Mobile UI (Delta Exec Compatible)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Egg Steal Hub 🥚",
   LoadingTitle = "Loading Advanced Script...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local AntiHitEnabled = false
local AntiTrapEnabled = false
local EggESPEnabled = false
local SpeedEnabled = false
local SpeedValue = 200
local MaxDistance = 30 -- مسافة ظهور الـ ESP (القرب من البيضة)

local ESPObjects = {}

-- Main Tab
local MainTab = Window:CreateTab("الرئيسية & الحماية", 4483362458)

-- Speed Hack with Bypass
MainTab:CreateToggle({
   Name = "تفعيل السرعة (Speed)",
   CurrentValue = false,
   Callback = function(Value)
      SpeedEnabled = Value
      if not Value then
         pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
               LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "مقدار السرعة",
   Range = {16, 500},
   Increment = 10,
   Suffix = "Speed",
   CurrentValue = 200,
   Callback = function(Value)
      SpeedValue = Value
   end,
})

-- Speed Bypass Loop (تجنب الرجوع للخلف)
RunService.Stepped:Connect(function()
   if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      pcall(function()
         local hum = LocalPlayer.Character.Humanoid
         hum.WalkSpeed = SpeedValue
         -- إلغاء تأثير السحب التلقائي
         if hum.MoveDirection.Magnitude > 0 then
            LocalPlayer.Character:TranslateBy(hum.MoveDirection * (SpeedValue / 1000))
         end
      end)
   end
end)

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

-- Rarity Color Handler
local function GetRarityColor(rarityText)
   local r = tostring(rarityText):lower()
   if r:find("common") then return Color3.fromRGB(200, 200, 200)
   elseif r:find("rare") then return Color3.fromRGB(0, 150, 255)
   elseif r:find("epic") then return Color3.fromRGB(170, 0, 255)
   elseif r:find("legendary") then return Color3.fromRGB(255, 170, 0)
   elseif r:find("mythic") then return Color3.fromRGB(255, 0, 80)
   elseif r:find("secret") then return Color3.fromRGB(0, 255, 200)
   elseif r:find("eternal") then return Color3.fromRGB(255, 255, 255)
   elseif r:find("divine") then return Color3.fromRGB(255, 215, 0)
   else return Color3.fromRGB(255, 255, 0) end
end

-- Read Values Function
local function GetEggData(egg)
   local weight = egg:GetAttribute("Weight") or (egg:FindFirstChild("Weight") and egg.Weight.Value) or (egg:FindFirstChild("WeightLabel") and egg.WeightLabel.Text) or "غير معروف"
   local price = egg:GetAttribute("Price") or (egg:FindFirstChild("Price") and egg.Price.Value) or (egg:FindFirstChild("PriceLabel") and egg.PriceLabel.Text) or "غير معروف"
   local rarity = egg:GetAttribute("Rarity") or (egg:FindFirstChild("Rarity") and egg.Rarity.Value) or (egg:FindFirstChild("RarityLabel") and egg.RarityLabel.Text) or "Common"
   
   return weight, price, rarity
end

local function UpdateEggESP()
   if not EggESPEnabled then return end
   
   local char = LocalPlayer.Character
   if not char or not char:FindFirstChild("HumanoidRootPart") then return end
   local hrp = char.HumanoidRootPart

   for _, obj in pairs(workspace:GetDescendants()) do
      if obj.Name:lower():find("egg") and (obj:IsA("BasePart") or obj:IsA("Model")) then
         local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
         if part then
            local dist = (hrp.Position - part.Position).Magnitude
            local billboard = part:FindFirstChild("EggInfoUI")

            if dist <= MaxDistance then
               if not billboard then
                  billboard = Instance.new("BillboardGui")
                  billboard.Name = "EggInfoUI"
                  billboard.Adornee = part
                  billboard.Size = UDim2.new(0, 160, 0, 50)
                  billboard.StudsOffset = Vector3.new(0, 3, 0)
                  billboard.AlwaysOnTop = true

                  local textLabel = Instance.new("TextLabel")
                  textLabel.Name = "Label"
                  textLabel.Parent = billboard
                  textLabel.Size = UDim2.new(1, 0, 1, 0)
                  textLabel.BackgroundTransparency = 1
                  textLabel.TextSize = 10
                  textLabel.Font = Enum.Font.SourceSansBold

                  billboard.Parent = part
                  table.insert(ESPObjects, billboard)
               end

               local weight, price, rarity = GetEggData(obj)
               local label = billboard:FindFirstChild("Label")
               if label then
                  label.TextColor3 = GetRarityColor(rarity)
                  label.Text = string.format("🥚 %s\nالوزن: %s | السعر: %s\nالندرة: %s", obj.Name, tostring(weight), tostring(price), tostring(rarity))
               end
            else
               if billboard then
                  billboard:Destroy()
               end
            end
         end
      end
   end
end

ESPTab:CreateToggle({
   Name = "ESP Egg (كشف عند القرب فقط)",
   CurrentValue = false,
   Callback = function(Value)
      EggESPEnabled = Value
      if not Value then
         ClearESP()
      else
         task.spawn(function()
            while EggESPEnabled do
               pcall(UpdateEggESP)
               task.wait(0.3)
            end
         end)
      end
   end,
})

ESPTab:CreateSlider({
   Name = "مسافة ظهور الـ ESP (بالأمتار)",
   Range = {10, 100},
   Increment = 5,
   Suffix = "Studs",
   CurrentValue = 30,
   Callback = function(Value)
      MaxDistance = Value
   end,
})

Rayfield:Notify({
   Title = "Egg Steal Script",
   Content = "تم تحديث السكربت بنجاح!",
   Duration = 3,
   Image = 4483362458,
})
