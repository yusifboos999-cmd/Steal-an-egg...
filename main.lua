-- Steal an Egg Mobile Script (Database-based Rarity & Anti-Rubberband)
-- Delta Exec Compatible

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Egg Steal Hub 🥚",
   LoadingTitle = "Loading Advanced Script...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Services & Local Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local AntiHitEnabled = false
local AntiTrapEnabled = false
local EggESPEnabled = false
local SpeedEnabled = false
local SpeedValue = 200
local MaxDistance = 30 

local ESPObjects = {}

-- Rarity Mapping Database
local RarityDatabase = {
   -- DIVINE
   ["unicorn"] = {Rarity = "Divine", Color = Color3.fromRGB(255, 215, 0)},
   ["kitsune"] = {Rarity = "Divine", Color = Color3.fromRGB(255, 215, 0)},
   ["nightflame"] = {Rarity = "Divine", Color = Color3.fromRGB(255, 215, 0)},
   ["archangel"] = {Rarity = "Divine", Color = Color3.fromRGB(255, 215, 0)},
   ["la vacca saturno saturnita"] = {Rarity = "Divine", Color = Color3.fromRGB(255, 215, 0)},

   -- ETERNAL
   ["eternal lunar dragon"] = {Rarity = "Eternal", Color = Color3.fromRGB(0, 255, 255)},
   ["pegasus"] = {Rarity = "Eternal", Color = Color3.fromRGB(0, 255, 255)},
   ["world burner"] = {Rarity = "Eternal", Color = Color3.fromRGB(0, 255, 255)},
   ["tralaledon"] = {Rarity = "Eternal", Color = Color3.fromRGB(0, 255, 255)},
   ["mosasaurus"] = {Rarity = "Eternal", Color = Color3.fromRGB(0, 255, 255)},

   -- SECRET
   ["royal sphinx"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["king snake"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["mutant shark"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["gorilla king"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["phoenix"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["lava dragon"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["cosmic dragon"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["cosmic skeleton boss"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["stag"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["gargoyle"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["razorfang"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["skeleton horse"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["pure jellyfish"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["centaur"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},
   ["trex"] = {Rarity = "Secret", Color = Color3.fromRGB(200, 200, 200)},

   -- MYTHIC
   ["scorpion"] = {Rarity = "Mythic", Color = Color3.fromRGB(255, 0, 50)},
   ["sand spider"] = {Rarity = "Mythic", Color = Color3.fromRGB(255, 0, 50)},
   ["cerberus"] = {Rarity = "Mythic", Color = Color3.fromRGB(255, 0, 50)},
   ["kraken"] = {Rarity = "Mythic", Color = Color3.fromRGB(255, 0, 50)},
   ["el maja"] = {Rarity = "Mythic", Color = Color3.fromRGB(255, 0, 50)},
   ["winged lamb"] = {Rarity = "Mythic", Color = Color3.fromRGB(255, 0, 50)},
   ["ankylosaurus"] = {Rarity = "Mythic", Color = Color3.fromRGB(255, 0, 50)},

   -- LEGENDARY
   ["snake"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["gorilla"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["orangutini ananassini"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["spider"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["tiger"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["crustacia"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["spideron"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["flaming bull"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["lava iguana"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["chillin chilli"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["shark"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["cosmic gecko"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["salamander"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["flame sprite"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["light dove"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},
   ["pterodactyl"] = {Rarity = "Legendary", Color = Color3.fromRGB(255, 170, 0)},

   -- EPIC
   ["tob tobi tob tob"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["crocodile"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["bladehide"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["rhinotaur"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["lava frog"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["whale shark"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["beluga whale"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["centipede"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["cosmic gorilla"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["crane"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["koi"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["snowy owl"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["oni tiger"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["triceratops"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},
   ["bronto"] = {Rarity = "Epic", Color = Color3.fromRGB(170, 0, 255)},

   -- RARE
   ["fennec"] = {Rarity = "Rare", Color = Color3.fromRGB(0, 150, 255)},
   ["camel"] = {Rarity = "Rare", Color = Color3.fromRGB(0, 150, 255)},
   ["chimpanzee"] = {Rarity = "Rare", Color = Color3.fromRGB(0, 150, 255)},
   ["mantaris"] = {Rarity = "Rare", Color = Color3.fromRGB(0, 150, 255)},
   ["swordfish"] = {Rarity = "Rare", Color = Color3.fromRGB(0, 150, 255)},
   ["red panda"] = {Rarity = "Rare", Color = Color3.fromRGB(0, 150, 255)},
   ["toro"] = {Rarity = "Rare", Color = Color3.fromRGB(0, 150, 255)},
   ["demon hound"] = {Rarity = "Rare", Color = Color3.fromRGB(0, 150, 255)},
   ["imp"] = {Rarity = "Rare", Color = Color3.fromRGB(0, 150, 255)},
   ["sacred moth"] = {Rarity = "Rare", Color = Color3.fromRGB(0, 150, 255)},
   ["holy peacock"] = {Rarity = "Rare", Color = Color3.fromRGB(0, 150, 255)},
   ["dodo"] = {Rarity = "Rare", Color = Color3.fromRGB(0, 150, 255)},

   -- COMMON
   ["jerboa"] = {Rarity = "Common", Color = Color3.fromRGB(220, 220, 220)},
   ["toucan"] = {Rarity = "Common", Color = Color3.fromRGB(220, 220, 220)},
   ["lava gecko"] = {Rarity = "Common", Color = Color3.fromRGB(220, 220, 220)},
   ["parrotfish"] = {Rarity = "Common", Color = Color3.fromRGB(220, 220, 220)}
}

-- Main Tab UI
local MainTab = Window:CreateTab("الرئيسية & السرعة", 4483362458)

-- Safe Speed Toggle
MainTab:CreateToggle({
   Name = "تفعيل السرعة (تخطي وزن البيضة)",
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

-- Advanced Speed Bypass (Anti-Rubberband & Weight Ignore)
RunService.Heartbeat:Connect(function()
   if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid") then
      pcall(function()
         local hum = LocalPlayer.Character.Humanoid
         local hrp = LocalPlayer.Character.HumanoidRootPart

         -- إجبار اللعبة على عدم تبطيئك بسبب وزن البيضة
         if hum.WalkSpeed ~= SpeedValue then
             hum.WalkSpeed = SpeedValue
         end

         -- التحكم في فيزياء الحركة لمنع الارتداد (Rubberbanding)
         if hum.MoveDirection.Magnitude > 0 then
            local moveDir = hum.MoveDirection
            hrp.AssemblyLinearVelocity = Vector3.new(moveDir.X * SpeedValue, hrp.AssemblyLinearVelocity.Y, moveDir.Z * SpeedValue)
         end
      end)
   end
end)

-- Anti Hit
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
            task.wait(0.2)
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

local function GetEggData(egg)
   local name = egg.Name
   local cleanName = name:lower():gsub("egg", ""):gsub("_", " "):gsub("^%s*(.-)%s*$", "%1")
   
   local rarity = "Common"
   local color = Color3.fromRGB(220, 220, 220)

   for key, data in pairs(RarityDatabase) do
      if cleanName:find(key) then
         rarity = data.Rarity
         color = data.Color
         break
      end
   end

   local weight = egg:GetAttribute("Weight") or (egg:FindFirstChild("Weight") and egg.Weight.Value) or (egg:FindFirstChild("WeightLabel") and egg.WeightLabel.Text) or "غير محدد"
   local price = egg:GetAttribute("Price") or (egg:FindFirstChild("Price") and egg.Price.Value) or (egg:FindFirstChild("PriceLabel") and egg.PriceLabel.Text) or "غير محدد"

   return name, weight, price, rarity, color
end

local function UpdateEggESP()
   if not EggESPEnabled then return end
   
   local char = LocalPlayer.Character
   if not char or not char:FindFirstChild("HumanoidRootPart") then return end
   local hrp = char.HumanoidRootPart

   for _, obj in pairs(workspace:GetDescendants()) do
      if (obj.Name:lower():find("egg") or obj.Name:lower():find("pet")) and (obj:IsA("BasePart") or obj:IsA("Model")) then
         local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
         if part then
            local dist = (hrp.Position - part.Position).Magnitude
            local billboard = part:FindFirstChild("EggInfoUI")

            if dist <= MaxDistance then
               if not billboard then
                  billboard = Instance.new("BillboardGui")
                  billboard.Name = "EggInfoUI"
                  billboard.Adornee = part
                  billboard.Size = UDim2.new(0, 180, 0, 60)
                  billboard.StudsOffset = Vector3.new(0, 3.5, 0)
                  billboard.AlwaysOnTop = true

                  local textLabel = Instance.new("TextLabel")
                  textLabel.Name = "Label"
                  textLabel.Parent = billboard
                  textLabel.Size = UDim2.new(1, 0, 1, 0)
                  textLabel.BackgroundTransparency = 1
                  textLabel.TextSize = 11
                  textLabel.Font = Enum.Font.SourceSansBold
                  textLabel.TextStrokeTransparency = 0.2

                  billboard.Parent = part
                  table.insert(ESPObjects, billboard)
               end

               local name, weight, price, rarity, color = GetEggData(obj)
               local label = billboard:FindFirstChild("Label")
               if label then
                  label.TextColor3 = color
                  label.Text = string.format("🥚 %s\n⚖️ الوزن: %s | 💰 السعر: %s\n⭐ الندرة: %s", name, tostring(weight), tostring(price), tostring(rarity))
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
   Name = "ESP Egg (كشف القرب التلقائي)",
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
   Name = "مسافة الكشف عند القرب",
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
   Content = "تم حل مشكلة الارتداد بنجاح!",
   Duration = 3,
   Image = 4483362458,
})
