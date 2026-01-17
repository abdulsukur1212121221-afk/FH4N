local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Fh4n Hub | F4",
   LoadingTitle = "Fh4n Hub Loading...",
   LoadingSubtitle = "by Gemini AI",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- VARIABLES
local lp = game.Players.LocalPlayer
local Speed = 16
local JumpPower = 50
local InfJump = false
local Noclip = false
local Flying = false
local FlySpeed = 50

-- TAB 1: SV TELEPORT (100 SLOTS)
local SVTab = Window:CreateTab("SV System", 4483362458)

local function CreateSVGroup(id)
   local SavedCFrame = nil
   SVTab:CreateSection("Slot " .. id)
   
   SVTab:CreateButton({
      Name = "SV (Save Position " .. id .. ")",
      Callback = function()
         if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            SavedCFrame = lp.Character.HumanoidRootPart.CFrame
            Rayfield:Notify({Title = "F4 Hub", Content = "Lokasi " .. id .. " Berhasil di-SV!", Duration = 1.5})
         end
      end,
   })

   SVTab:CreateButton({
      Name = "Teleport (Go to SV " .. id .. ")",
      Callback = function()
         if SavedCFrame and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = SavedCFrame
         else
            Rayfield:Notify({Title = "F4 Error", Content = "Slot " .. id .. " Masih Kosong!", Duration = 1.5})
         end
      end,
   })
end

-- Loop Otomatis 100 Slot
for i = 1, 100 do
   CreateSVGroup(i)
end

-- TAB 2: MISC (MOVEMENT & CHEATS)
local MiscTab = Window:CreateTab("Misc", 4483362458)

MiscTab:CreateSection("Movement Cheats")

MiscTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value) Speed = Value end,
})

MiscTab:CreateSlider({
   Name = "JumpHeight",
   Range = {50, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
      JumpPower = Value
      if lp.Character:FindFirstChild("Humanoid") then
         lp.Character.Humanoid.JumpPower = Value
         lp.Character.Humanoid.UseJumpPower = true
      end
   end,
})

MiscTab:CreateToggle({
   Name = "Fly (Terbang)",
   CurrentValue = false,
   Callback = function(Value)
      Flying = Value
      if Flying then
         local TBody = lp.Character:WaitForChild("HumanoidRootPart")
         local Camera = workspace.CurrentCamera
         local BV = Instance.new("BodyVelocity", TBody)
         local BG = Instance.new("BodyGyro", TBody)
         BV.Velocity = Vector3.new(0,0.1,0)
         BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
         BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
         
         task.spawn(function()
            while Flying and task.wait() do
               BV.Velocity = Camera.CFrame.LookVector * (FlySpeed * 2)
               BG.CFrame = Camera.CFrame
            end
            BV:Destroy()
            BG:Destroy()
         end)
      end
   end,
})

MiscTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value) InfJump = Value end,
})

MiscTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value) Noclip = Value end,
})

-- INTERNAL LOOPS
local RunService = game:GetService("RunService")
local HeartbeatConn = RunService.Heartbeat:Connect(function()
   if lp.Character and lp.Character:FindFirstChild("Humanoid") then
      lp.Character.Humanoid.WalkSpeed = Speed
      if Noclip then
         for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
         end
      end
   end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
   if InfJump and lp.Character:FindFirstChildOfClass("Humanoid") then
      lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
   end
end)

-- TAB 3: SETTINGS & AUTO OFF
local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateButton({
   Name = "Close Fh4n Hub",
   Callback = function()
      -- Matikan semua fitur sebelum menutup
      Flying = false
      Noclip = false
      InfJump = false
      Speed = 16
      
      if HeartbeatConn then HeartbeatConn:Disconnect() end
      
      if lp.Character and lp.Character:FindFirstChild("Humanoid") then
         lp.Character.Humanoid.WalkSpeed = 16
         lp.Character.Humanoid.JumpPower = 50
         for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
         end
      end
      
      Rayfield:Destroy()
      print("Fh4n Hub Closed & All Features Off")
   end,
})

Rayfield:Notify({
   Title = "Fh4n Hub Loaded",
   Content = "Selamat menggunakan F4 Hub!",
   Duration = 3
})
