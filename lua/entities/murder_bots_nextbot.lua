if SERVER then AddCSLuaFile() end

ENT.Base = "base_nextbot"
ENT.Type = "nextbot"


function ENT:ChasePos()
  if self.PosGen == nil then return end

  --if self.P == nil then 
    self.P = Path("Follow")
    self.P:SetMinLookAheadDistance(00)
    self.P:SetGoalTolerance(100)
    self.P:Compute(self, self.PosGen)
  --end
  if !self.P:IsValid() then return end

  if self.P:GetAge() > 0.2 then
    self.P:Compute(self, self.PosGen)
  end
  if GetConVar("murder_bot_nav_debug"):GetInt() == 1 then
    self.P:Draw()
  end
end

function ENT:RunBehaviour()
  while (true) do
    if self.PosGen then
      self:ChasePos()
    end
		
  coroutine.yield()
  end
end

function ENT:Initialize()
  self:SetModel("models/props_lab/huladoll.mdl")
  self:SetNoDraw(true)
  self:DrawShadow(false)
  self:SetSolid(SOLID_NONE)
  self.PosGen = nil
end
