if CLIENT then return end

ENT.Type = "brush"

function ENT:Initialize()
	self:SetTrigger(true)
	self.m_iPercentageToFire = self.m_iPercentageToFire or 0
	self.m_bActive = self.m_bActive or false
end

function ENT:Think()
	if not self.m_bActive then return end

	local numplayers = #player.GetAll()
	local humans = team.NumPlayers(TEAM_SURVIVOR)
	
	if numplayers > 0 then
		local fPercentage = (humans/numplayers) * 100

		if fPercentage >= self.m_iPercentageToFire then
			self:Input("OnCount", self)
		end
	end
	
	self:NextThink(CurTime() + 1)
	return true
end

function ENT:KeyValue( key, value )
	key = string.lower(key)
	if key == "active" then
		self.m_bActive = tonumber(value) == 1
	elseif key == "percentagetofire" then
		self.m_iPercentageToFire = tonumber(value) or self.m_iPercentageToFire
	elseif string.sub(key, 1, 2) == "on" then
		self:AddOnOutput(key, value)
	end
end

function ENT:AcceptInput(name, caller, activator, arg)
	name = string.lower(name)
	if name == "toggle" then
		self:InputToggle()
		return true
	elseif name == "enable" then
		self:InputEnable()
		return true
	elseif name == "disable" then
		self:InputDisable()
		return true
	elseif string.sub(name, 1, 2) == "on" then
		self:FireOutput(name, activator, caller, args)
	end
end

function ENT:InputToggle()
	self.m_bActive = not self.m_bActive
end

function ENT:InputDisable()
	self.m_bActive = false
end

function ENT:InputEnable()
	self.m_bActive = true
end