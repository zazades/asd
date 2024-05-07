local playerNames1 = {"Efebilen4848","AGuy_Noyan","KanTonS","SkyC_B","iCrawall","Ahmet987987987","LyxTheGoat","NoyanFlexingU","CryptedAspect", "angell02400","farmniba", "HadesMissYou","TurkYabgu","Beeinqz","NoyanOwnsYou","NoyanTheGoat","WichansMissYou","HeartzMissYou"}

local player = game.Players.LocalPlayer

local function isPlayerInTable1(playerName)
    for _, name in ipairs(playerNames1) do
        if name == playerName then
            return true
        end
    end
 return false
end

--[[local playerNameToCheck = game.Players.LocalPlayer.Name
if isPlayerInTable1(player.Name) then
    print("hosgeldiniiiz")
else
    player:Kick("Bi siktir git")
end]]

wait(3)
local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer.PlayerGui

local textLabel = Instance.new("TextLabel")
textLabel.Parent = gui
textLabel.Size = UDim2.new(1, 0, 0, 50)
textLabel.Position = UDim2.new(0.5, -10, 0.5, 0) -- Centered horizontally and vertically
textLabel.AnchorPoint = Vector2.new(0.5, 0.5) -- Center anchor point
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.new(1, 1, 1) -- Red text color
textLabel.TextStrokeTransparency = 0.5 -- Adjusted stroke transparency
textLabel.TextStrokeColor3 = Color3.new(255,0,0) -- White stroke color
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextSize = 24
textLabel.TextWrapped = true
textLabel.Text = ""

local textLabel1 = Instance.new("TextLabel")
textLabel1.Parent = gui
textLabel1.Size = UDim2.new(1, 0, 0, 50)
textLabel1.Position = UDim2.new(0.5, 0, 0.5, 30) -- Centered horizontally and vertically, with an offset
textLabel1.AnchorPoint = Vector2.new(0.5, 0.5) -- Center anchor point
textLabel1.BackgroundTransparency = 1
textLabel1.TextColor3 = Color3.new(1, 1, 1) -- Red text color
textLabel1.TextStrokeTransparency = 0.5 -- Adjusted stroke transparency
textLabel1.TextStrokeColor3 = Color3.new(255,0,0) -- White stroke color
textLabel1.Font = Enum.Font.SourceSansBold
textLabel1.TextSize = 24
textLabel1.TextWrapped = true
textLabel1.Text = ""


local text = "Angel's Library :)"
local text1 = "Welcome ".. player.Name
local delay = 0.07

for i = 1, #text do
    textLabel.Text = textLabel.Text .. text:sub(i, i)
    wait(delay)
end

for i = 1, #text1 do
    textLabel1.Text = textLabel1.Text .. text1:sub(i, i)
    wait(delay)
end

wait(2)

for i = #text, 1, -1 do
    textLabel.Text = textLabel.Text:sub(1, i - 1)
    wait(delay)
end

for i = #text1, 1, -1 do
    textLabel1.Text = textLabel1.Text:sub(1, i - 1)
    wait(delay)
end

wait(#text1 * delay) 
textLabel:Destroy()
textLabel1:Destroy()

print("Start of log:")
--initialize config variables
optimize=false --optimizations can occasionally break the script on older or newer servers if the number of packets has been updated, so the value is configgable
--initialize basic variables
local players = game:GetService("Players")
local plr = players.LocalPlayer
local mouse = plr:GetMouse()
local char = plr.Character
local root:Part = if char then char:FindFirstChild("HumanoidRootPart") else nil
local hum:Humanoid = if char then char:FindFirstChild("Humanoid") else nil
plr.CharacterAdded:Connect(function() --update the char and root and hum when possible
	char = plr.Character
	root = char:WaitForChild("HumanoidRootPart")
	hum = char:WaitForChild("Humanoid")
end)
local rep = game:GetService("ReplicatedStorage")
local rs = game:GetService("RunService")
local input = game:GetService("UserInputService")
local keycodes = Enum.KeyCode:GetEnumItems()
local ts = game:GetService("TeleportService")
local cam = workspace.CurrentCamera
local isvoid = game.PlaceId==11879754496
local offset = -1

--initialize game specific variables
local packets = not isvoid and require(rep.Modules.Packets) or {}
if isvoid then
	for i,v in pairs(rep:WaitForChild("Events"):GetChildren()) do
		if v:IsA("RemoteEvent") then
			packets[v.Name]={send=function(...) v:FireServer(...) end}
		end
	end
end
local bytenet:RemoteEvent = if not isvoid then rep:FindFirstChild("ByteNetReliable") else nil

local packetsenumerated = {}
local c = 0
for i,v in pairs(packets) do
	c+=1
	packetsenumerated[i]=c
end
local itemids
local itemdata
for i,v in pairs(getreg()) do
	if type(v)=="table" then
		if not itemids and v[1]=="Wood" then
			itemids=v
		elseif not itemdata and type(v.Wood)=="table" and v.Wood.itemType then
			itemdata=v
		elseif itemids and itemdata then
			break
		end
	end
end

local offloaded:Instance = not isvoid and game:GetService("ReplicatedFirst").Animals.Offloaded or Instance.new("Folder")
local statsgui = plr.PlayerGui:WaitForChild("MainGui"):WaitForChild("Panels"):WaitForChild("Stats")
local inventorygui = plr.PlayerGui:WaitForChild("MainGui"):WaitForChild("RightPanel"):WaitForChild("Inventory"):WaitForChild("List")
--init basic ui

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local magicchars = "[%(%)%.%%%+%-%*%?%[%]%^%$]"
local function sanitize(str)
	return string.gsub(str,magicchars,function(s) return "%"..s end)
end

local uilib:string = game:HttpGet(repo .. 'Library.lua')

local find,sub = [[Library:GiveSignal(InputService.InputBegan:Connect(function(Input)
            if (not Picking) then
                if KeyPicker.Mode == 'Toggle' then
                    local Key = KeyPicker.Value;

                    if Key == 'MB1' or Key == 'MB2' then
                        if Key == 'MB1' and Input.UserInputType == Enum.UserInputType.MouseButton1
                        or Key == 'MB2' and Input.UserInputType == Enum.UserInputType.MouseButton2 then
                            KeyPicker.Toggled = not KeyPicker.Toggled
                            KeyPicker:DoClick()
                        end;
                    elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                        if Input.KeyCode.Name == Key then
                            KeyPicker.Toggled = not KeyPicker.Toggled;
                            KeyPicker:DoClick()
                        end;
                    end;
                end;

                KeyPicker:Update();
            end;

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = ModeSelectOuter.AbsolutePosition, ModeSelectOuter.AbsoluteSize;

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    ModeSelectOuter.Visible = false;
                end;
            end;
        end))

        Library:GiveSignal(InputService.InputEnded:Connect(function(Input)
            if (not Picking) then
                KeyPicker:Update();
            end;
        end))

        KeyPicker:Update();

        Options[Idx] = KeyPicker;

        return self;
    end;]],[[Library:GiveSignal(InputService.InputBegan:Connect(function(Input,processed)
    		if processed then return end
            if (not Picking) then
                if KeyPicker.Mode == 'Toggle' then
                    local Key = KeyPicker.Value;

                    if Key == 'MB1' or Key == 'MB2' then
                        if Key == 'MB1' and Input.UserInputType == Enum.UserInputType.MouseButton1
                        or Key == 'MB2' and Input.UserInputType == Enum.UserInputType.MouseButton2 then
                            KeyPicker.Toggled = not KeyPicker.Toggled
                            KeyPicker:DoClick()
                        end;
                    elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                        if Input.KeyCode.Name == Key then
                            KeyPicker.Toggled = not KeyPicker.Toggled;
                            KeyPicker:DoClick()
                        end;
                    end;
                end;

                KeyPicker:Update();
            end;

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = ModeSelectOuter.AbsolutePosition, ModeSelectOuter.AbsoluteSize;

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    ModeSelectOuter.Visible = false;
                end;
            end;
        end))

        Library:GiveSignal(InputService.InputEnded:Connect(function(Input)
            if (not Picking) then
                KeyPicker:Update();
            end;
        end))

        KeyPicker:Update();

        Options[Idx] = KeyPicker;

        return self;
    end;]]
uilib,c=uilib:gsub(sanitize(find),sub)
uilib = loadstring(uilib)()
local themelib = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local savelib = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local window = uilib:CreateWindow({
	Title="Angel's library",
	Center = true,
	AutoShow = true,
	TabPadding = 8,
	MenuFadeTime = 0.2
})

--make a velocity toggle which does its absolute best to disable all movement
local veltoggle = Instance.new("BodyVelocity")
veltoggle.P=math.huge
veltoggle.Velocity=Vector3.new()
veltoggle.MaxForce=Vector3.new(math.huge,math.huge,math.huge)

--make some basic helper functions
local isrunning = true
local unloads = {
}
uilib:OnUnload(function()
	isrunning = false
	for i,v in pairs(unloads) do
		task.spawn(v)
	end
end)

local function flatten(vec)
	return Vector3.new(vec.X,0,vec.Z)
end
local function remove(t1,find)
	if not table.find(t1,find) then return end
	return table.remove(t1,table.find(t1,find))
end
local function merge(t1,...)
	for i,t2 in pairs({...}) do
		table.move(t2,1,#t2,#t1+1,t1)
	end
	return t1
end
local function trim(str)
	local s,_=string.gsub(str, '^%s*(.-)%s*$', '%1')
	return s
end
local function truelen(t)
	local c = 0
	for _,_ in pairs(t) do
		c+=1
	end
	return c
end

local function getServers(id)
	return game:GetService("HttpService"):JSONDecode(request({Url=`https://games.roblox.com/v1/games/{id}/servers/0?sortOrder=2&excludeFullGames=true&limit=100`}).Body)
end

local function getMover(part)
	for i,v in pairs(part:GetDescendants()) do
		if not v:IsA("BasePart") then continue end
		local ocf = v.CFrame
		v.CFrame=CFrame.new()
		if v.CFrame==CFrame.new() then
			v.CFrame=ocf
			return v
		end
	end
end
local function getMovePart():BasePart
	if not root then return nil end
	if not (hum and root and hum.SeatPart and hum.SeatPart.Parent) then return root end
	return getMover(hum.SeatPart.Parent) or root
end
local function getMovementRaycastParams()
	local rp = RaycastParams.new()
	rp.IgnoreWater=true
	rp.FilterType=Enum.RaycastFilterType.Exclude
	local filt={workspace:FindFirstChild("Items"),hum and hum.SeatPart and hum.SeatPart.Parent,workspace:FindFirstChild("Critters")}
	for i,v in pairs(game:GetService("Players"):GetPlayers()) do
		table.insert(filt,v.Character)
	end
	for i,v in pairs(workspace:GetChildren()) do
		if v.Name=="RainPart" then
			table.insert(filt,v)
		end
	end
	rp.FilterDescendantsInstances=filt
	return rp
end

local function moveTo(pos:CFrame|Vector3)
	if not getMovePart() then return end
	if typeof(pos)=="Vector3" then pos = CFrame.new(pos) end
	local move=getMovePart()
	if move==root then
		move.CFrame = pos
	else
		local dif = (move.CFrame.Position-root.CFrame.Position)
		move.CFrame = pos+dif
	end
end


local newvels:{BodyVelocity} = {}
local ogvels = {}
local ogparts = {}
task.spawn(function()
	while isrunning do rs.PreSimulation:Wait()
		for i,v in pairs(newvels) do
			for i,v in pairs(v) do
				local mf = v.MaxForce
				v.Parent.Velocity=Vector3.new(mf.X==math.huge and 0 or v.Parent.Velocity.X,mf.Y==math.huge and 0 or v.Parent.Velocity.Y,mf.Z==math.huge and 0 or v.Parent.Velocity.Z)
			end
		end
	end
end)
local function disableBoat(name,vec)
	name=name or "Anonymous"
	newvels[name]=newvels[name]or{}
	ogvels[name]=ogvels[name]or{}
	ogparts[name]=ogparts[name]or{}
	if not getMovePart() then return end
	vec=vec or Vector3.new(1,1,1)
	local force = Vector3.new(if vec.X==1 then math.huge else 0,if vec.Y==1 then math.huge else 0,if vec.Z==1 then math.huge else 0)
	for i,v in pairs(char:GetDescendants()) do
		if ogvels[name][v] or ogparts[name][v] then continue end
		if v~=veltoggle and (v:IsA("BodyVelocity") or v:IsA("BodyPosition")) then
			ogvels[name][v]=v.MaxForce
			v.MaxForce=Vector3.new()
		elseif v:IsA("BasePart") then
			ogparts[name][v]={v.CanCollide,v.Massless}
			v.CanCollide=false
			v.Massless=true
			local newveltoggle = veltoggle:Clone()
			newveltoggle.Parent=v
			newveltoggle.MaxForce=force
			table.insert(newvels[name],newveltoggle)
		end
	end
	for i,v in pairs(hum and hum.SeatPart and hum.SeatPart.Parent and hum.SeatPart.Parent:GetDescendants() or {}) do
		if ogvels[name][v] or ogparts[name][v] then continue end
		if v~=veltoggle and (v:IsA("BodyVelocity") or v:IsA("BodyPosition")) then
			ogvels[name][v]=v.MaxForce
			v.MaxForce=Vector3.new()
		elseif v:IsA("BasePart") then
			ogparts[name][v]={v.CanCollide,v.Massless}
			v.CanCollide=false
			v.Massless=true
			local newveltoggle = veltoggle:Clone()
			newveltoggle.Parent=v
			newveltoggle.MaxForce=force
			table.insert(newvels[name],newveltoggle)
		end
	end
end
local function enableBoat(name)
	name=name or "Anonymous"
	newvels[name]=newvels[name]or{}
	ogvels[name]=ogvels[name]or{}
	ogparts[name]=ogparts[name]or{}
	for i,v in pairs(newvels[name]) do
		v:Destroy()
		remove(newvels[name],v)
	end
	for i,v in pairs(char:GetDescendants()) do
		if v:IsA("BodyVelocity") then
			v:Destroy()
		end
	end
	for i,v in pairs(ogvels[name]) do
		remove(ogvels[name],v)
		i.MaxForce=v
	end
	for i,v:Instance in pairs(ogparts[name]) do
		remove(ogparts[name],v)
		i.CanCollide=v[1]
		i.Massless=v[2]
	end
	newvels[name]=nil
	ogvels[name]=nil
	ogparts[name]=nil
end
table.insert(unloads,function()
	for i,v in pairs(newvels) do
		enableBoat(i)
	end
end)


local function teleportStepToward(pos,rate,step,height)
	if not root then return end
	local posflat=flatten(pos)
	local cposflat=flatten(root.Position)
	local dir = (posflat-cposflat).Unit
	local dist = (posflat-cposflat).Magnitude
	if dir.X~=dir.X then
		dir=Vector3.new()
	end
	cposflat+=dir*math.clamp((step or rs.PreSimulation:Wait())*rate,0,dist)
	local ray = workspace:Raycast(cposflat+Vector3.new(0,root.Position.Y+25,0),Vector3.new(0,-10000,0),getMovementRaycastParams())
	if ray then
		moveTo(ray.Position+Vector3.new(0,height or 3.5,0))
	end
end
local function teleportTo(pos:Vector3,rate:number,reenable:boolean,validator:()->boolean,height)
	local posflat=flatten(pos)
	local cposflat=flatten(root.Position)
	local dir = (posflat-cposflat).Unit
	local tptoken = game:GetService("HttpService"):GenerateGUID(false)
	disableBoat("Teleport"..tptoken)
	while getMovePart() and validator() do
		local step = rate*rs.PreSimulation:Wait()
		if (cposflat-posflat).Magnitude<step then
			moveTo(pos)
			break
		else
			cposflat+=dir*step
			local ray = workspace:Raycast(cposflat+Vector3.new(0,1000,0),Vector3.new(0,-2000,0),getMovementRaycastParams())
			if ray then
				moveTo(ray.Position+Vector3.new(0,height or 5,0))
			end
		end
	end
	enableBoat("Teleport"..tptoken)
end

local function getSlot(name)
	if inventorygui:FindFirstChild(name) and not inventorygui[name]:IsA("UILayout") then
		return inventorygui[name].LayoutOrder
	end
end
local function getCount(name)
	if inventorygui:FindFirstChild(name) and not inventorygui[name]:IsA("UILayout") and inventorygui[name]:FindFirstChild("QuantityText",true) then
		return tonumber(inventorygui[name]:FindFirstChild("QuantityText",true).Text) or 0
	end
	return 0
end
local function getItemId(name)
	return itemids[name]
end

local function teamcheck(plr2)
	return (plr.Neutral or plr.Team.Name=="NoTribe" or plr.Team~=plr2.Team)
end
--start of packet functions --most of these functions are technically slower because they add an extra function call but it doesn't really matter
local function hit(parts)
	packets.SwingTool.send(parts)
end
local function useSlot(slot)
	packets.UseBagItem.send(slot)
end
local pickupbuf = buffer.create(2)
buffer.writeu8(pickupbuf,0,packetsenumerated.Pickup)
buffer.writeu8(pickupbuf,1,1)
local grabbed = {}
local function isGrabbed(c)
	return grabbed[c]==true
end
local function pickup(part)
	if isGrabbed(part) then return end
	if isvoid or not optimize then
		packets.Pickup.send(part)
	else
		bytenet:FireServer(pickupbuf,{part})
	end
	task.spawn(function()
		grabbed[part]=true
		task.wait(plr:GetNetworkPing()+1)
		grabbed[part]=nil
	end)
end
local function plant(box,plant)
	if not isvoid then
		packets.InteractStructure.send({structure=box,itemID=plant})
	else
		packets.InteractStructure.send(box,plant)
	end
end
local function grab(item)
	packets.ForceInteract.send(item)
end
local function manipulate(item,func)
	grab(item)
	rs.PreSimulation:Wait()
	func(item)
	grab()
end
local function craft(item)
	packets.CraftItem.send(item)
end
local function touch(p1,p2) --the checks are to try to avoid crashing
	firetouchinterest(p1,p2,1)
	firetouchinterest(p1,p2,0)
end
local function place(name,rot,pos)
	if not isvoid then
		packets.PlaceStructure.send({
			buildingName=name,
			yrot=rot,
			vec=pos,
			isMobile=false,
		})
	else
		packets.PlaceStructure.send(
			pos,
			name,
			rot,
			false
		)
	end
end
local pressbuf = buffer.create(4)
buffer.writeu8(pressbuf,0,packetsenumerated.InteractStructure)
buffer.writeu8(pressbuf,1,1)
buffer.writeu16(pressbuf,2,if not isvoid then getItemId("Gold") else 0)
local function press(press)
	if isvoid then return plant(press,"Gold") end
	if not optimize then return plant(press,getItemId("Gold")) end
	bytenet:FireServer(pressbuf,{press})
end


--make categories
local combat = window:AddTab("Combat")
local movement = window:AddTab("Movement")
local utility = window:AddTab("Utility")
local visuals = window:AddTab("Visuals")
--init theme manager (mostly copied from example lmao)

local uisettings = window:AddTab("UI Settings")
local menu = uisettings:AddLeftGroupbox('Menu')
menu:AddButton('Unload', function() uilib:Unload() end)
menu:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RShift', NoUI = true, Text = 'Menu keybind' })
themelib:SetLibrary(uilib)
themelib:ApplyToTab(uisettings)
--make globally used cheat vars

local birds = {}
if game.ReplicatedFirst:FindFirstChild("Animals") then
	for i,v:Instance in pairs(game.ReplicatedFirst.Animals.Offloaded:GetChildren()) do
		if v.Name=="Bird" then
			table.insert(birds,v)
			local con
			con = v.AncestryChanged:Connect(function(c,p)
				if p==nil then
					remove(birds,v)
					con:Disconnect()
				end
			end)
		end
	end
	game.ReplicatedFirst.Animals.Offloaded.ChildAdded:Connect(function(v:Instance)
		if v.Name=="Bird" and not table.find(birds,v) then
			table.insert(birds,v)
			local con
			con = v.AncestryChanged:Connect(function(c,p)
				if p==nil then
					remove(birds,v)
					con:Disconnect()
				end
			end)
		end
	end)
end
for i,v:Instance in pairs(workspace.Critters:GetChildren()) do
	if v.Name=="Bird" then
		table.insert(birds,v)
		local con
		con = v.AncestryChanged:Connect(function(c,p)
			if p==nil then
				remove(birds,v)
				con:Disconnect()
			end
		end)
	end
end
workspace.Critters.ChildAdded:Connect(function(v:Instance)
	if v.Name=="Bird" and not table.find(birds,v) then
		table.insert(birds,v)
		local con
		con = v.AncestryChanged:Connect(function(c,p)
			if p==nil then
				remove(birds,v)
				con:Disconnect()
			end
		end)
	end
end)

local resources = {}
local function addResource(v:Instance)
	if v:IsA("Model") then
		table.insert(resources,v)
		local gone = false
		v.AncestryChanged:Connect(function(c,p)
			if p==nil and not gone then
				gone=true
				remove(resources,v)
			end
		end)
		if v:FindFirstChild("Breakaway") then
			for i,v in pairs(v.Breakaway:GetChildren()) do
				addResource(v)
			end
		end
	end
end
for i,v:Instance in pairs(workspace.Resources:GetChildren()) do
	addResource(v)
end
workspace.Resources.ChildAdded:Connect(addResource)

--cheats begin

local speed = movement:AddGroupbox({Name="Speed"})
speed_enabled = speed:AddToggle(1,{Text="Enabled"}):AddKeyPicker(1,{Default="Y",Text="Speed",SyncToggleState=true})
speed_speed = speed:AddSlider(1,{Text="Speed",Default=22.5,Min=0,Max=50,Rounding=1})
speed_boatspeed = speed:AddSlider(1,{Text="Boat Speed",Default=65,Min=0,Max=100,Rounding=1})
speed_height = speed:AddSlider(1,{Text="Height",Default=3,Min=0,Max=10,Rounding=1})
speed_usemax = speed:AddToggle(1,{Text="Use MaxSpeed",Default=true})
speed_maxadd = speed:AddSlider(1,{Text="Added Speed",Default=7.5,Min=0,Max=25,Rounding=1})

local stopspeedtokens={}
local disablestate = -1
local function disablespeed(token)
	if table.find(stopspeedtokens,token) then return end
	table.insert(stopspeedtokens,token)
end
local function enablespeed(token)
	remove(stopspeedtokens,token)
	disablestate=-1
end
local function isspeeddisabled(token)
	return table.find(stopspeedtokens,token)~=nil
end
plr.CharacterAdded:Connect(function()
	if not (isrunning and speed_enabled.Value) then return end
	disablestate=-1
end)
speed_enabled:OnChanged(function()
	local con = plr.CharacterAdded:Connect(function()
		disablestate=-1
	end)
	while true do
		local step = rs.PreSimulation:Wait()
		if not (isrunning and speed_enabled.Value) then break end
		if #stopspeedtokens>0 or not root or not hum then disablestate = -1 enableBoat("Speed") continue end
		if hum.SeatPart then
			if disablestate~=0 then
				enableBoat("Speed")
				disablestate=0
				disableBoat("Speed")
			end
			local speedtouse = speed_usemax.Value and hum.SeatPart:IsA("VehicleSeat") and hum.SeatPart.MaxSpeed+speed_maxadd.Value or speed_boatspeed.Value
			local ray = workspace:Raycast(root.Position+Vector3.new(0,15,0)+(hum.MoveDirection*step*speedtouse),Vector3.new(0,-2000,0),getMovementRaycastParams())
			if ray then
				moveTo(getMovePart().CFrame.Rotation+ray.Position+Vector3.new(0,speed_height.Value or 3,0))
			end
		else
			if disablestate~=1 then
				enableBoat("Speed")
				task.spawn(function()--i dont know how this works just trust the process
					hum:ChangeState(Enum.HumanoidStateType.Freefall)
					rs.PreSimulation:Wait()
					hum:ChangeState(Enum.HumanoidStateType.Running)
					rs.PreSimulation:Wait()
					hum:ChangeState(Enum.HumanoidStateType.Freefall)
					rs.PreSimulation:Wait()
					hum:ChangeState(Enum.HumanoidStateType.Running)
				end)
				disablestate=1
				disableBoat("Speed",Vector3.new(1,0,1))
			end
			root.CFrame+=hum.MoveDirection*speed_speed.Value*step
		end
	end
	con:Disconnect()
	disablestate=-1
	enableBoat("Speed")
	rs.PostSimulation:Wait()
	enableBoat("Speed")
end)

local autohit = combat:AddGroupbox({Name="Auto Hit",Side=1})
autohit_enabled = autohit:AddToggle(1,{Text="Enabled"}):AddKeyPicker(1,{Default="R",Text="Auto Hit",SyncToggleState=true})
autohit_silent = autohit:AddToggle(1,{Text="Silent"})
autohit_range = autohit:AddSlider(1,{Text="Range",Default=25,Min=0,Max=25,Rounding=1})
autohit_players = autohit:AddToggle(1,{Text="Players",Default=true})
autohit_critters = autohit:AddToggle(1,{Text="Critters",Default=true})
autohit_resources = autohit:AddToggle(1,{Text="Resources"})
autohit_buildings = autohit:AddToggle(1,{Text="Buildings"})

local silentbuffer = buffer.create(2)
buffer.writeu8(silentbuffer,0,65)
buffer.writeu8(silentbuffer,1,1)

local gethitbuffer=setmetatable({},{__index=function(s,i)
	local buf = buffer.create(3+i)
	buffer.writeu8(buf,0,13)
	buffer.writeu16(buf,1,i)
	for i1=1,i do
		buffer.writeu8(buf,i1+2,i1)
	end
	return buf
end,})
autohit_enabled:OnChanged(function()
	while true do
		local step = rs.PostSimulation:Wait()
		if not (isrunning and autohit_enabled.Value) then break end
		if not root then continue end
		local attackparts = {}
		if autohit_players.Value then
			for i,v in pairs(game:GetService("Players"):GetPlayers()) do
				if v~=plr and v.Character and teamcheck(v) then
					local vroot,vhum = v.Character:FindFirstChild("HumanoidRootPart"),v.Character:FindFirstChild("Humanoid")
					if vroot and vhum and vhum.Health>0 and (vroot.Position-root.Position).Magnitude<autohit_range.Value then
						for i,v in pairs(v.Character:GetChildren()) do
							if v:IsA("BasePart") then
								table.insert(attackparts,v)
							end
						end
					end
				end
			end
		end
		if autohit_critters.Value then 
			if workspace:FindFirstChild("Critters") then
				for i,v in pairs(workspace.Critters:GetChildren()) do
					local vroot,vhum = v:FindFirstChild("HumanoidRootPart"),v:FindFirstChild("Health")
					if vroot and vhum and vhum.Value>0 and (vroot.Position-root.Position).Magnitude<autohit_range.Value then
						local cp
						local cpm = math.huge
						for i,v in pairs(v:GetChildren()) do
							if v:IsA("BasePart") and (v.Position-root.Position).Magnitude<cpm then
								cp = v
								cpm = (v.Position-root.Position).Magnitude
							end
						end
						table.insert(attackparts,cp)
					end
				end
			end
			if workspace:FindFirstChild("HumanoidCritters") then
				for i,v in pairs(workspace.HumanoidCritters:GetChildren()) do
					local vroot,vhum = v:FindFirstChild("HumanoidRootPart"),v:FindFirstChild("Health")
					if vroot and vhum and vhum.Value>0 and (vroot.Position-root.Position).Magnitude<autohit_range.Value then
						local cp
						local cpm = math.huge
						for i,v in pairs(v:GetChildren()) do
							if v:IsA("BasePart") and (v.Position-root.Position).Magnitude<cpm then
								cp = v
								cpm = (v.Position-root.Position).Magnitude
							end
						end
						table.insert(attackparts,cp)
					end
				end
			end
		end
		if autohit_resources.Value and workspace:FindFirstChild("Resources") then
			for i,v:Instance in pairs(resources) do
				if not v:IsA("Model") then continue end
				local maxextent = v:GetExtentsSize()
				maxextent = math.max(maxextent.X,maxextent.Y,maxextent.Z)
				if v:GetPivot().Position~=Vector3.new() and (v:GetPivot().Position-root.Position).Magnitude<autohit_range.Value+maxextent then
					local cp
					local cpm = math.huge
					for i,v in pairs(v:GetChildren()) do
						if v:IsA("BasePart") and (v.Position-root.Position).Magnitude<cpm then
							cp = v
							cpm = (v.Position-root.Position).Magnitude
						end
					end
					table.insert(attackparts,cp)
				end
			end
		end
		if autohit_buildings.Value and workspace:FindFirstChild("Deployables") then
			for i,v:Instance in pairs(workspace.Deployables:GetChildren()) do
				if not v:IsA("Model") then continue end
				local maxextent = v:GetExtentsSize()
				maxextent = math.max(maxextent.X,maxextent.Y,maxextent.Z)
				if v:GetPivot().Position~=Vector3.new() and (v:GetPivot().Position-root.Position).Magnitude<autohit_range.Value+maxextent then
					local cp
					local cpm = math.huge
					for i,v in pairs(v:GetChildren()) do
						if v:IsA("BasePart") and (v.Position-root.Position).Magnitude<cpm then
							cp = v
							cpm = (v.Position-root.Position).Magnitude
						end
					end
					table.insert(attackparts,cp)
				end
			end
			for i,v:Instance in pairs(workspace.Totems:GetChildren()) do
				if not v:IsA("Model") then continue end
				local maxextent = v:GetExtentsSize()
				maxextent = math.max(maxextent.X,maxextent.Y,maxextent.Z)
				if v:GetPivot().Position~=Vector3.new() and (v:GetPivot().Position-root.Position).Magnitude<autohit_range.Value+maxextent then
					local cp
					local cpm = math.huge
					for i,v in pairs(v:GetChildren()) do
						if v:IsA("BasePart") and (v.Position-root.Position).Magnitude<cpm then
							cp = v
							cpm = (v.Position-root.Position).Magnitude
						end
					end
					table.insert(attackparts,cp)
				end
			end
		end
		if #attackparts>0 then
			if autohit_silent.Value then
				bytenet:FireServer(silentbuffer)
				bytenet:FireServer(gethitbuffer[#attackparts],attackparts)
				bytenet:FireServer(silentbuffer)
				for i=1,1 do rs.PostSimulation:Wait() end --wait a lil more so your game doesn't shit out
			else
				hit(attackparts)
			end
		end
	end
end)

local autoheal = combat:AddGroupbox({Name="Autoheal"})
autoheal_enabled = autoheal:AddToggle(1,{Text="Enabled"}):AddKeyPicker(1,{Default="",Text="Autoheal",SyncToggleState=true})
autoheal_void = autoheal:AddToggle(1,{Text="OP Void",Default=true})
autoheal_tokeep = autoheal:AddInput(1,{Text="To Keep",Numeric=true,Default="1000"})
autoheal_rate = autoheal:AddInput(1,{Text="Rate",Numeric=true,Default="50"})
autoheal_perhp = autoheal:AddInput(1,{Text="Per HP",Numeric=true,Default="0.5",Tooltip="The number of bloodfruit to eat per hitpoint of damage in the overworld"})
autoheal_item = autoheal:AddInput(1,{Text="Item",Default="Bloodfruit"})

local php = hum and hum.Health
local toheal = 0
local function hpcon()
	local chp = hum.Health
	if chp<php and getSlot(autoheal_item.Value) and getCount(autoheal_item.Value)>autoheal_tokeep.Value then
		if isvoid and autoheal_void.Value then
			for i=1,math.ceil((php-chp)/itemdata[autoheal_item.Value].nourishment.health) do
				useSlot(getSlot(autoheal_item.Value))
			end
		else
			toheal += php-chp
		end
	end
	php = chp
end
local lasthealed = 0

local hcon
plr.CharacterAdded:Connect(function()
	if autoheal_enabled.Value then
		hcon = hum.HealthChanged:Connect(hpcon)
	end
end)
autoheal_enabled:OnChanged(function()
	hcon = hum and hum.HealthChanged:Connect(hpcon)
	while true do
		local step = rs.PreSimulation:Wait()
		if not (isrunning and autoheal_enabled.Value) then break end
		if isvoid and autoheal_void.Value then continue end
		if toheal>0 and tick()-lasthealed>1/autoheal_rate.Value and getSlot(autoheal_item.Value) and getCount(autoheal_item.Value)>autoheal_tokeep.Value then
			useSlot(getSlot(autoheal_item.Value))
			lasthealed=tick()
			toheal-=1/autoheal_perhp.Value
		end
	end
	hcon:Disconnect()
end)

local autochase = combat:AddGroupbox({Name="Auto Chase"})
autochase_enabled = autochase:AddToggle(1,{Text="Enabled"}):AddKeyPicker(1,{Default="G",Text="Autochase",SyncToggleState=true})
autochase_speed = autochase:AddSlider(1,{Text="Speed",Default=23.5,Min=0,Max=25,Rounding=1})
autochase_range = autochase:AddSlider(1,{Text="Range",Default=25,Min=0,Max=25,Rounding=1})

autochase_enabled:OnChanged(function()
	while true do
		local step = rs.PreSimulation:Wait()
		enableBoat("Autochase")
		if not (isrunning and autochase_enabled.Value) then break end
		if not root then continue end
		local closestpos
		local closestmag=autochase_range.Value
		for i,v in pairs(game:GetService("Players"):GetPlayers()) do
			if v~=plr and v.Character and teamcheck(v) then
				local vroot,vhum = v.Character:FindFirstChild("HumanoidRootPart"),v.Character:FindFirstChild("Humanoid")
				if vroot and vhum and vhum.Health>0 then
					local dist = (vroot.Position-root.Position).Magnitude
					if dist<closestmag then
						closestpos=vroot.Position
						closestmag=dist
					end
				end
			end
		end
		if closestpos then
			disableBoat("Autochase")
			if not isspeeddisabled("Autochase") then
				disablespeed("Autochase")
			end
			local dir = closestpos-root.Position
			local mag = dir.Magnitude
			dir = dir.Unit
			if dir.X~=dir.X then
				dir=Vector3.new()
			end
			moveTo(root.CFrame+dir*math.clamp(step*autochase_speed.Value,0,mag))
		elseif isspeeddisabled("Autochase") then
			enablespeed("Autochase")
			enableBoat("Autochase")
		end
	end
	enablespeed("Autochase")
	enableBoat("Autochase")
end)

local autoeat = utility:AddGroupbox({Name="Auto Eat"})
autoeat_enabled = autoeat:AddToggle(1,{Text="Enabled"}):AddKeyPicker(1,{Default="",Text="Auto Eat",SyncToggleState=true})
autoeat_threshold = autoeat:AddSlider(1,{Text="Threshold",Default=75,Min=0,Max=100,Rounding=1})
autoeat_foods = autoeat:AddInput(1,{Text="Foods",Default="Lemon, Cooked Meat"})

autoeat_enabled:OnChanged(function()
	while true do
		local step = rs.PreSimulation:Wait()
		if not (isrunning and autoeat_enabled.Value) then break end
		local hunger = (statsgui.Food.Slider.AbsoluteSize.X/statsgui.Food.AbsoluteSize.X)*100
		if hunger<autoeat_threshold.Value then
			for i,v in pairs(autoeat_foods.Value:split(",")) do
				if getSlot(trim(v)) then
					useSlot(getSlot(trim(v)))
					break
				end
			end
			task.wait(plr:GetNetworkPing()+0.1)
		end
	end
end)

local noslide = movement:AddGroupbox({Name="No Slide"})
noslide_enabled=noslide:AddToggle(1,{Text="Enabled"}):AddKeyPicker(1,{Default="",Text="No Slide",SyncToggleState=true})

noslide_enabled:OnChanged(function()
	while true do
		local step = rs.PreSimulation:Wait()
		if not (isrunning and noslide_enabled.Value) then break end
		if not hum then continue end
		hum.MaxSlopeAngle=90
	end
	if hum then
		hum.MaxSlopeAngle=46
	end
end)

local clipup = movement:AddGroupbox({Name="Clip Up"})
clipup_activate = clipup:AddToggle(1,{Text="Activate",Callback=function()
	if not clipup_activate.Value then return end
	clipup_activate:SetValue(false)
	if not root or not isrunning then return end
	local ray = workspace:Raycast(root.Position+Vector3.new(0,5000,0),Vector3.new(0,-10000,0),getMovementRaycastParams())
	if ray then
		moveTo(ray.Position+Vector3.new(0,3,0))
	end
end}):AddKeyPicker(1,{Default="E",Text="Clip Up",SyncToggleState=true})

local clipdown = movement:AddGroupbox({Name="Clip Down"})
clipdown_activate = clipdown:AddToggle(1,{Text="Activate",Callback=function()
	if not clipdown_activate.Value then return end
	clipdown_activate:SetValue(false)
	if not root or not isrunning then return end
	local ray = workspace:Raycast(root.Position-(Vector3.new(0,5,0)+if hum and hum.SeatPart then Vector3.new(0,speed_height.Value,0) else Vector3.new()),Vector3.new(0,-10000,0),getMovementRaycastParams())
	if ray then
		moveTo(ray.Position+Vector3.new(0,3,0))
	end
end}):AddKeyPicker(1,{Default="Q",Text="Clip DOwn",SyncToggleState=true})

local nodoor = utility:AddGroupbox({Name="No Door"})
nodoor_enabled= nodoor:AddToggle(1,{Text="Enabled"}):AddKeyPicker(1,{Default="",Text="No Door",SyncToggleState=true})

local doors = {}
for i,v in pairs(workspace.Deployables:GetDescendants()) do
	if v.Name=="Door" and v:IsA("BasePart") then
		doors[v]=v.Parent
	end

end
workspace.Deployables.DescendantAdded:Connect(function(v)
	if v.Name=="Door" and v:IsA("BasePart") then
		task.wait()
		doors[v]=v.Parent
		if not pcall(function() v.Parent = if nodoor_enabled.Value then nil else v.Parent end) then doors[v]=nil end
	end
end)

nodoor_enabled:OnChanged(function()
	for i,v in pairs(doors) do
		if not pcall(function() i.Parent = if nodoor_enabled.Value then nil else v end) then doors[v]=nil end
	end
end)
table.insert(unloads,function()
	for i,v in pairs(doors) do
		pcall(function() i.Parent = v end)
	end
end)

local birdfarm = utility:AddGroupbox({Name="Bird Farm"})
birdfarm_enabled=birdfarm:AddToggle(1,{Text="Enabled"}):AddKeyPicker(1,{Default="",Text="No Slide",SyncToggleState=true})
birdfarm_speed=birdfarm:AddSlider(1,{Text="Speed",Default=50,Min=0,Max=75,Rounding=1})

local lasthit
birdfarm_enabled:OnChanged(function()
	disablespeed("Bird Farm")
	while true do
    wait(0.1)
		local step = rs.PreSimulation:Wait()
		if not (isrunning and birdfarm_enabled.Value) then break end
		if not root and hum then continue end
		disableBoat("Birdfarm")
		local dz = hum.SeatPart and hum.SeatPart.Parent and hum.SeatPart.Parent:FindFirstChild("DangerZone")
		local closest
		local closestmag=math.huge
		for i,v in pairs(birds) do
			local dist = (flatten(root.Position)-flatten(v:GetPivot().Position)).Magnitude
			if v:GetPivot().Position~=Vector3.new() and dist<closestmag then
				closest = v
				closestmag = dist
			end
		end
		if closest then
			teleportStepToward(closest:GetPivot().Position,birdfarm_speed.Value,step,3)
			local frp = flatten(root.Position)
			local crp = flatten(closest:GetPivot().Position)
			if (frp-crp).Magnitude<2 then
				local hits = {}
				for i,v in pairs(closest:GetChildren()) do
					if v:IsA("BasePart") then
						table.insert(hits,v)
					end
				end
				hit(hits)
				moveTo(flatten(root.Position)+Vector3.new(0,closest:GetPivot().Y,0))
			end
			if not (lasthit and lasthit.Parent) then
				lasthit=closest:FindFirstChild("HumanoidRootPart")
			end
			if dz and lasthit then
				touch(dz,lasthit)
			end
		end
	end
	enableBoat("Birdfarm")
	enablespeed("Bird Farm")
	rs.PreSimulation:Wait()
	enableBoat("Birdfarm")
end)

local function getAntsDistance(pos)
	if isvoid then return math.huge end
	local closestmag = math.huge
	for i,v in pairs(workspace.Mounds:GetChildren()) do
		local dist = (v:GetPivot().Position-pos).Magnitude
		if dist<closestmag then
			closestmag=dist
		end
	end
	return closestmag
end

local autofarm = utility:AddGroupbox({Name="Auto Farm"})
autofarm_enabled=autofarm:AddToggle(1,{Text="Enabled"}):AddKeyPicker(1,{Default="",Text="No Slide",SyncToggleState=true})
autofarm_resources=autofarm:AddInput(1,{Text="Resources",Default="Gold Node"})
autofarm_speed=autofarm:AddSlider(1,{Text="Speed",Default=50,Min=0,Max=75,Rounding=1})

local autofarmwhitelist = {}
autofarm_resources:OnChanged(function()
	table.clear(autofarmwhitelist)
	for i,v in pairs(autofarm_resources.Value:split(",")) do
		autofarmwhitelist[trim(v)]=true
	end
end)
for i,v in pairs(autofarm_resources.Value:split(",")) do
	autofarmwhitelist[trim(v)]=true
end
autofarm_enabled:OnChanged(function()
	disablespeed("Auto Farm")
	local goto
	while true do
		local step = rs.PreSimulation:Wait()
		enableBoat("Autofarm")
		if not (isrunning and autofarm_enabled.Value) then break end
		if not root and hum then continue end
		disableBoat("Autofarm")
		local dz = hum.SeatPart and hum.SeatPart.Parent and hum.SeatPart.Parent:FindFirstChild("DangerZone")
		local closest
		local closestmag=math.huge
		for i,v in pairs(resources) do
			if v:GetPivot().Position~=Vector3.new() and autofarmwhitelist[v.Name] then
				local dist = (flatten(root.Position)-flatten(v:GetPivot().Position)).Magnitude
				if dist<closestmag and getAntsDistance(v:GetPivot().Position)>50 then
					closest = v
					closestmag = dist
				end
			end
		end
		if closest then
			local rp = RaycastParams.new()
			rp.FilterDescendantsInstances={closest}
			rp.FilterType=Enum.RaycastFilterType.Include
			goto = workspace:Raycast(closest:GetPivot().Position+Vector3.new(0,100,0),Vector3.new(0,-200,0),rp).Position
			teleportTo(goto+Vector3.new(0,3,0),autofarm_speed.Value,false,function()
				return isrunning and autofarm_enabled.Value and getAntsDistance(closest:GetPivot().Position)>50
			end,3)
			local hits = {}
			for i,v in pairs(closest:GetChildren()) do
				if v:IsA("BasePart") then
					table.insert(hits,v)
				end
			end
			local grabcon = workspace.Items.ChildAdded:Connect(function(c)
				local dist = (c:GetPivot().Position-root.Position).Magnitude
				if dist<20 then
					pickup(c)
				end
			end)
			while closest and closest.Parent and isrunning and autofarm_enabled.Value do
				rs.PostSimulation:Wait()
				moveTo(goto+Vector3.new(0,3,0))
				hit(hits)
			end
			local goto = workspace:Raycast(closest:GetPivot().Position+Vector3.new(0,100,0),Vector3.new(0,-200,0),getMovementRaycastParams()).Position
			local t=tick()
			local towait = plr:GetNetworkPing()+0.1
			while tick()-t<towait and isrunning and autofarm_enabled.Value do rs.PostSimulation:Wait()
				moveTo(goto+Vector3.new(0,3,0))
			end
			grabcon:Disconnect()
		elseif goto then
			moveTo(goto+Vector3.new(0,3,0))
		end
	end
	enablespeed("Auto Farm")
	enableBoat("Autofarm")
end)

local autograb = utility:AddGroupbox({Name="Auto Grab"})
autograb_enabled = autograb:AddToggle(1,{Text="Enabled"}):AddKeyPicker(1,{Default="",Text="Auto Grab",SyncToggleState=true})
autograb_range = autograb:AddSlider(1,{Text="Range",Default=25,Min=0,Max=25,Rounding=1})
autograb_whitelistenabled = autograb:AddToggle(1,{Text="Whitelist Enabled",Default=true})
autograb_whitelist = autograb:AddInput(1,{Text="Resources",Default="Gold, Crystal Chunk, Void Shard, Essence, Emerald, Pink Diamond, Coin2, Coin, Magnetite, Spirit Key"})
autograb_chest = autograb:AddToggle(1,{Text="Chest"})
autograb_safechest = autograb:AddToggle(1,{Text="Safe Chest"})
local autograbchest
autograb:AddButton({Text="Bind Near Chest",Func=function()
	local best
	local bestdist = 25
	for i,v in pairs(workspace.Deployables:GetChildren()) do
		if v.Name:find("Chest") then
			if (root.Position-v:GetPivot().Position).Magnitude<bestdist then
				best=v.Base
			end
		end
	end
	autograbchest = best or autograbchest
end,})

local autograbwhitelist = {}
autograb_whitelist:OnChanged(function()
	table.clear(autograbwhitelist)
	for i,v in pairs(autograb_whitelist.Value:split(",")) do
		autograbwhitelist[trim(v)]=true
	end
end)
for i,v in pairs(autograb_whitelist.Value:split(",")) do
	autograbwhitelist[trim(v)]=true
end

local function chest(item)
	if not autograbchest then return end
	if item:IsA("Model") then
		for i,v in pairs(item:GetDescendants()) do
			if v:IsA("BasePart") then v.CFrame=autograbchest.CFrame end
		end
		touch(getMover(item),autograbchest)
	else
		item.CFrame=autograbchest.CFrame
		touch(item,autograbchest)
	end
end
autograb_enabled:OnChanged(function()
	local items = {}
	local lastupdate = Vector3.new(0,-1000,0)
	local itemcon = workspace.Items.ChildAdded:Connect(function(v)
		if v:GetPivot().Position~=Vector3.new() then
			local dist = (root.Position-v:GetPivot().Position).Magnitude
			if dist<75 then
				table.insert(items,v)
			end
		end
	end)
	while true do
		local step = rs.PostSimulation:Wait()
		if not (isrunning and autograb_enabled.Value) then break end
		if not root then continue end
		if (root.Position-lastupdate).Magnitude>25 then
			table.clear(items)
			for i,v in pairs(workspace.Items:GetChildren()) do
				if v:GetPivot().Position~=Vector3.new() then
					local dist = (root.Position-v:GetPivot().Position).Magnitude
					if dist<75 then
						table.insert(items,v)
					end
				end
			end
			lastupdate=root.Position
		end
		for i,v in pairs(items) do
			if v:GetPivot().Position~=Vector3.new() and (not autograb_whitelistenabled.Value or autograbwhitelist[v.Name]) then
				local dist = (root.Position-v:GetPivot().Position).Magnitude
				if dist<autograb_range.Value then
					if autograb_chest.Value then
						manipulate(v,chest,autograb_safechest.Value)
						break
					else
						pickup(v)
					end
				end
			end
		end
	end
	itemcon:Disconnect()
end)

local teleports = utility:AddGroupbox({Name="Teleports"})
teleports:AddButton({Text="Big Void",Func=function()
	local servers = getServers(11879754496).data
	local touse = {}
	for i,v in pairs(servers) do
		if v.playing>25 then
			table.insert(touse,v.id)
		end
	end
	local bestid = #touse>0 and touse[math.random(1,#touse)] or servers[1].id
	ts:TeleportToPlaceInstance(11879754496,bestid,plr)
end})
teleports:AddButton({Text="Small Void",Func=function()
	local servers = getServers(11879754496).data
	local bestid = servers[#servers].id
	ts:TeleportToPlaceInstance(11879754496,bestid,plr)
end})
teleports:AddButton({Text="Low Ping Void",Func=function()
	local servers = getServers(11879754496).data
	local bestid
	local bestval=math.huge
	for i,v in pairs(servers) do
		if v.ping<bestval then
			bestid=v.id
		end
	end
	ts:TeleportToPlaceInstance(11879754496,bestid,plr)
end})
teleports:AddButton({Text="Random Void",Func=function()
	local servers = getServers(11879754496).data
	local bestid = servers[math.random(1,#servers)].id
	while bestid==game.JobId do
		bestid = servers[math.random(1,#servers)].id
	end
	ts:TeleportToPlaceInstance(11879754496,bestid,plr)
end})
teleports:AddButton({Text="Big Overworld",Func=function()
	local servers = getServers(11729688377).data
	local touse = {}
	for i,v in pairs(servers) do
		if v.playing>25 then
			table.insert(touse,v.id)
		end
	end
	local bestid = #touse>0 and touse[math.random(1,#touse)] or servers[1].id
	ts:TeleportToPlaceInstance(11729688377,bestid,plr)
end})
teleports:AddButton({Text="Small Overworld",Func=function()
	local servers = getServers(11729688377).data
	local bestid = servers[#servers].id
	ts:TeleportToPlaceInstance(11729688377,bestid,plr)
end})
teleports:AddButton({Text="Low Ping Overworld",Func=function()
	local servers = getServers(11729688377).data
	local bestid
	local bestval=math.huge
	for i,v in pairs(servers) do
		if v.ping<bestval then
			bestid=v.id
		end
	end
	ts:TeleportToPlaceInstance(11729688377,bestid,plr)
end})
teleports:AddButton({Text="Random Overworld",Func=function()
	local servers = getServers(11729688377).data
	local bestid = servers[math.random(1,#servers)].id
	while bestid==game.JobId do
		bestid = servers[math.random(1,#servers)].id
	end
	ts:TeleportToPlaceInstance(11729688377,bestid,plr)
end})

--esp temp
local plrstatguis:{{Frame}} = {}
local esp = visuals:AddGroupbox({Name="ESP"})
esp_enabled=esp:AddToggle(1,{Text="Enabled"}):AddKeyPicker(1,{Default="",Text="ESP",SyncToggleState=true})
esp_name=esp:AddToggle(1,{Text="Name",Default=true})
esp_name:OnChanged(function()
	for i,v in pairs(plrstatguis) do
		if v.Name then
			v.Name.Parent=if esp_name.Value then v.Main else nil
		end
	end
end)
esp_health=esp:AddToggle(1,{Text="Health",Default=true})
esp_health:OnChanged(function()
	for i,v in pairs(plrstatguis) do
		if v.Health then
			v.Health.Parent=if esp_health.Value then v.Main else nil
		end
	end
end)



local trackedplrstats = {}
local offs = {}
for x=-0.5,0.5 do
	for y=-0.5,0.5 do
		for z=-0.5,0.5 do
			table.insert(offs,Vector3.new(x,y,z))
		end
	end
end

esp_enabled:OnChanged(function()
	if not esp_enabled.Value then
		for i,v in pairs(plrstatguis) do
			v.Main.Parent=nil
		end
	end
end)
game.Players.PlayerRemoving:Connect(function(v)
	if plrstatguis[v] then
		for i,v in pairs(plrstatguis[v]) do
			v.Parent=nil
		end
	end
	plrstatguis[v]=nil
end)
task.spawn(function()
	while isrunning do rs.RenderStepped:Wait()
		if esp_enabled.Value then
			for i,v in pairs(game:GetService("Players"):GetPlayers()) do
				local vchar = v.Character
				if v ~= plr and vchar then
					local vroot = vchar:FindFirstChild("HumanoidRootPart")
					local vhum = vchar:FindFirstChildOfClass("Humanoid")
					if vroot then
						if not plrstatguis[v] then
							plrstatguis[v]={}
							local frame = Instance.new("Frame")
							frame.BackgroundTransparency=1
							frame.AutomaticSize=Enum.AutomaticSize.XY
							frame.AnchorPoint=Vector2.new(0.5,0.5)
							local uilayout = Instance.new("UIListLayout")
							uilayout.Parent=frame
							local name = Instance.new("TextLabel")
							name.TextSize=10
							name.Size=UDim2.new(0,0,0,10)
							name.LayoutOrder=1
							name.BackgroundTransparency=1
							name.TextColor3=v.TeamColor.Color
							name.Text=`{v.Name}({v.DisplayName})`
							name.Parent=if esp_name.Value then frame else nil
							plrstatguis[v].Name=name
							local hp = Instance.new("TextLabel")
							hp.TextSize=10
							hp.Size=UDim2.new(0,0,0,10)
							hp.LayoutOrder=2
							hp.BackgroundTransparency=1
							hp.TextColor3=Color3.new(1,0,0)
							hp.Text=tostring(vhum and math.round(vhum.Health*10)/10 or "???")
							hp.Parent=if esp_name.Value then frame else nil
							plrstatguis[v].Health=hp
							plrstatguis[v].Main=frame
						end
						local frame = plrstatguis[v].Main
						local cpos = cam:WorldToViewportPoint(vroot.Position)
						if cpos.Z<0 then
							frame.Parent=nil
						else
							plrstatguis[v].Name.TextColor3=v.TeamColor.Color
							plrstatguis[v].Health.Text=tostring(vhum and math.round(vhum.Health*10)/10 or "???")
							frame.Parent=window.ScreenGui
							frame.Position=UDim2.new(0,cpos.X,0,cpos.Y)
						end
					elseif plrstatguis[v] then
						plrstatguis[v].Main.Parent=nil
					end
				end
			end
		end
	end
end)

local autopress = utility:AddGroupbox({Name="Auto Press"})
autopress_activate=autopress:AddToggle(1,{Text="Activate",Callback=function()
	if not autopress_activate.Value then return end
	autopress_activate:SetValue(false)
	for i,v:Instance in pairs(workspace.Deployables:GetChildren()) do
		if v.Name=="Coin Press" and (v:GetPivot().Position-root.Position).Magnitude<10 then
			for i=1,autopress_count.Value do
				press(v)
			end
			if not autopress_autograb.Value then return end
			local con:RBXScriptConnection = workspace.Items.ChildAdded:Connect(function(v)
				if v.Name=="Coin2" then
					pickup(v)
				end
			end)
			task.wait(10)
			con:Disconnect()
			break
		end
	end
end}):AddKeyPicker(1,{Default="",Text="Autopress",SyncToggleState=true})
autopress_autograb=autopress:AddToggle(1,{Text="Autograb"})
autopress_count=autopress:AddInput(1,{Text="Count",Numeric=true,Default="100"})

local autofarmplants = utility:AddGroupbox({Name="Auto Farm Plants"})
autofarmplants_enabled=autofarmplants:AddToggle(1,{Text="Enabled"}):AddKeyPicker(1,{Default="",Text="Clip Up",SyncToggleState=true})
autofarmplants_scan=autofarmplants:AddInput(1,{Text="Scan Range",Numeric=true,Default="1000"})
autofarmplants_resources=autofarmplants:AddInput(1,{Text="Item",Default="Bloodfruit",Finished=true})
autofarmplants_speed=autofarmplants:AddSlider(1,{Text="Speed",Default=23.5,Min=0,Max=75,Rounding=1})

local autofarmplantswhitelist = {}
local autofarmplantswhitelistnum = {}
autofarmplants_resources:OnChanged(function()
	table.clear(autofarmplantswhitelist)
	table.clear(autofarmplantswhitelistnum)
	for i,v in pairs(autofarmplants_resources.Value:split(",")) do
		autofarmplantswhitelist[trim(v)]=true
		autofarmplantswhitelistnum[#autofarmplantswhitelistnum+1]=trim(v)
	end
end)

local plantboxes = {}
for i,v in pairs(workspace.Deployables:GetChildren()) do
	if v.Name=="Plant Box" then
		table.insert(plantboxes,v)
		v:GetPropertyChangedSignal("Parent"):Connect(function()
			if v.Parent==nil then
				remove(plantboxes,v)
			end
		end)
	end
end
workspace.Deployables.ChildAdded:Connect(function(v)
	if v.Name=="Plant Box" then
		table.insert(plantboxes,v)
		v:GetPropertyChangedSignal("Parent"):Connect(function()
			if v.Parent==nil then
				remove(plantboxes,v)
			end
		end)
	end
end)

autofarmplants_enabled:OnChanged(function()
	disablespeed("Auto Farm Plants")
	local cplant = 1
	local planterboxes = {}
	local lastupdate = Vector3.new(math.huge,math.huge,math.huge)
	while true do
		local scandist = tonumber(autofarmplants_scan.Value) or math.huge
		--if (root.Position-lastupdate).Magnitude>scandist then
		--	table.clear(planterboxes)
		--	for i,v in pairs(plantboxes) do
		--		if v:GetPivot().Position~=Vector3.new() then
		--			local dist = (root.Position-v:GetPivot().Position).Magnitude
		--			if dist<(scandist*2)+10 then
		--				table.insert(plantboxes,v)
		--			end
		--		end
		--	end
		--	lastupdate=root.Position
		--end
		local step = rs.PreSimulation:Wait()
		if not (isrunning and autofarmplants_enabled.Value) then break end
		if not root then continue end
		disableBoat("Autofarmplants")
		local closestbox
		local closestboxmag = scandist
		print(#planterboxes)
		for i,v in pairs(plantboxes) do
			if not v:FindFirstChild("Seed") and v:GetPivot().Position~=Vector3.new() then
				local dist = (root.Position-v:GetPivot().Position).Magnitude
				if dist<closestboxmag then
					closestbox = v
					closestboxmag = dist
				end
			end
		end
		local closestbush
		local closestbushmag = scandist
		for i,v in pairs(workspace:GetChildren()) do
			if v:FindFirstChild("Pickup") and v:GetPivot().Position~=Vector3.new() then
				local dist = (root.Position-v:GetPivot().Position).Magnitude
				if dist<closestbushmag then
					closestbush = v
					closestbushmag = dist
				end
				if dist<25 then
					pickup(v)
				end
			end
		end
		print(closestbush,closestbox)
		if closestbush then
			teleportStepToward(closestbush:GetPivot().Position,autofarmplants_speed.Value,step,4)
		elseif closestbox then
			teleportStepToward(closestbox:GetPivot().Position,autofarmplants_speed.Value,step,4)
		end

		_= closestbox and (function()
			local item = autofarmplantswhitelistnum[cplant]
			cplant+=1
			if cplant>#autofarmplantswhitelistnum then
				cplant=1
			end
			while getCount(item) == 0 do
				item = autofarmplantswhitelistnum[cplant]
				cplant+=1
				if cplant>#autofarmplantswhitelistnum then
					cplant=1
					break
				end
			end
			if getCount(item)>0 then
				plant(closestbox,getItemId(item))
			end
		end)()
	end
	enableBoat("Autofarmplants")
	enablespeed("Auto Farm Plants")
end)

local hideitems = utility:AddGroupbox({Name="Hide Items"})
local hideitems_enabled = hideitems:AddToggle(1,{Text="Enabled"}):AddKeyPicker(1,{Default="",Text="No Slide",SyncToggleState=true})

local items = workspace:WaitForChild("Items")

hideitems_enabled:OnChanged(function(new)
	if new then
		items.Parent=nil
	else
		items.Parent=workspace
	end
end)
table.insert(unloads,function()
	items.Parent=workspace
end)
