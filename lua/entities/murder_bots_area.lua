if SERVER then AddCSLuaFile() end

ENT.Type = "point"

function ENT:Initialize()
  self:SetModel("models/props_lab/huladoll.mdl")
  self:SetNoDraw(true)
  self:DrawShadow(false)
  self:SetSolid(SOLID_NONE)
end

function ENT:KeyValue(key, value)
  if (key == "areaname") then
    self.Name = value
    --print("Set name to "..value)
  else
    --print("key,value=",key,value)
  end

end