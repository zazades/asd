local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/luke1for1/pv3/main/orionlibmod')))()

local Window = OrionLib:MakeWindow({Name = "Pineapple V3", HidePremium = false, SaveConfig = true, ConfigFolder = "pv3"})

-- Prepare the data for the Discord webhook
local localPlayer = game.Players.LocalPlayer
local username = localPlayer.Name
local userId = localPlayer.UserId

OrionLib:MakeNotification({
	Name = "Angel's library",
	Content = "Successfully executed",
	Image = nil,
	Time = 4
})

optimize = false

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

local magicchars = "[%(%)%.%%%+%-%*%?%[%]%^%$]"
local function sanitize(str)
	return string.gsub(str,magicchars,function(s) return "%"..s end)
end

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

--make a velocity toggle which does its absolute best to disable all movement
local veltoggle = Instance.new("BodyVelocity")
veltoggle.P=math.huge
veltoggle.Velocity=Vector3.new()
veltoggle.MaxForce=Vector3.new(math.huge,math.huge,math.huge)

--make some basic helper functions
local isrunning = true
local unloads = {
}
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


local Combat = Window:MakeTab({
	Name = "Combat",
	Icon = nil,
	PremiumOnly = false
})

local Farming = Window:MakeTab({
	Name = "Farming",
	Icon = nil,
	PremiumOnly = false
})

local Utilities = Window:MakeTab({
	Name = "Player",
	Icon = nil,
	PremiumOnly = false
})

local Misc = Window:MakeTab({
	Name = "Miscellaneous",
	Icon = nil,
	PremiumOnly = false
})

local Teleports = Window:MakeTab({
	Name = "Teleports",
	Icon = nil,
	PremiumOnly = false
})

local Combats = Combat:AddSection({
	Name = "Combat"
})

local Utils = Utilities:AddSection({
	Name = "Farming"
})

local Players = Utilities:AddSection({
	Name = "Player"
})

local Miscs = Misc:AddSection({
	Name = "Misc"
})

local Teleport = Teleports:AddSection({
	Name = "Teleports"
})

local ts = game:GetService("TeleportService")

-- // Teleports // --

Teleports:AddButton({
	Name = "Big Void Server (More Players)",
	Callback = function()
        local servers = getServers(11879754496).data
        local touse = {}
        for i, v in pairs(servers) do
            if v.playing > 25 then
                table.insert(touse, v.id)
            end
        end
        local bestid = #touse > 0 and touse[math.random(1, #touse)] or servers[1].id
        ts:TeleportToPlaceInstance(11879754496, bestid, plr)
  	end    
})

Teleports:AddButton({
	Name = "Small Void Server (Less Players)",
	Callback = function()
        local servers = getServers(11879754496).data
        local touse = {}
        for i, v in pairs(servers) do
            if v.playing < 10 then
                table.insert(touse, v.id)
            end
        end
        local bestid = #touse > 0 and touse[math.random(1, #touse)] or servers[1].id
        ts:TeleportToPlaceInstance(11879754496, bestid, plr)
  	end    
})

Teleports:AddButton({
	Name = "Low Latency Void",
	Callback = function()
    local servers = getServers(11879754496).data
    local bestid
    local bestval = math.huge
    for i, v in pairs(servers) do
        if v.ping < bestval then
            bestid = v.id
        end
    end
    ts:TeleportToPlaceInstance(11879754496, bestid, plr)
  	end    
})

Teleports:AddButton({
	Name = "Small Overworld Server (Less Players)",
	Callback = function()
        local servers = getServers(11729688377).data
        local touse = {}
        for i, v in pairs(servers) do
            if v.playing < 10 then
                table.insert(touse, v.id)
            end
        end
        local bestid = #touse > 0 and touse[math.random(1, #touse)] or servers[1].id
        ts:TeleportToPlaceInstance(11729688377, bestid, plr)
  	end    
})




-- // Combat // --

local autohit_enabled

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

Combat:AddToggle({
	Name = "Auto Heal",
	Default = false,
	Callback = function(Value)
		print(Value)
	end    
})

-- // Farming // --

local options = {}

for x, v in next, ItemData do
    if v.grows then
        table.insert(options, x)
    end
end

local autofarmplants_enabled
local autofarmplants_scan
local autofarmplants_resources
local autofarmplants_speed

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

Farming:AddToggle({
	Name = "Autofarm Plants",
	Default = false,
	Callback = function(Value)
		autofarmplants_enabled = Value
	end    
})

Farming:AddSlider({
	Name = "Speed",
	Min =0,
	Max = 75,
	Default = 23.5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		autofarmplants_speed = tostring(Value)
	end    
})

Farming:AddDropdown({
	Name = "Fruits",
	Default = "Bloodfruit",
	Options = options,
	Callback = function(Value)
		print(Value)
       -- autofarmplants_resources 
	end    
})

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

OrionLib:Init()
