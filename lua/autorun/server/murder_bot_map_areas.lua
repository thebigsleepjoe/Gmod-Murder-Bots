
local areas = {}

/*timer.Simple(1, function()
	for i,v in pairs(ents.GetAll()) do
		if v:GetClass() == "murder_bots_area" then
			table.insert(areas, v)
			PrintTable(v:GetKeyValues())
		end
	end
	if #areas == 0 then print("This map has no defined areas for murder bots! Bot callouts will NOT work!") return end
end)*/

local Meta = FindMetaTable("Player")
local calls = 0

function MUInitBotAreas()
	areas = {}
	calls = calls + 1
	for i,v in pairs(ents.GetAll()) do
		if v:GetClass() == "murder_bots_area" then
			table.insert(areas, {name=v.Name,entity=v})
		end
	end
end

function Meta:NearestAreaName()
	local bot = self
	local d = 9999999
	local lenom = nil
	if #areas > 0 then
		for i,v in pairs(areas) do
			if v.entity:GetPos():Distance(bot:GetPos()) < d then
				d = v.entity:GetPos():Distance(bot:GetPos())
				lenom = v.name
			end
		end
		if lenom != nil then return lenom end
	else
		if calls < 3 then -- don't lag the server
			MUInitBotAreas()
			return bot:NearestAreaName()	
		end
	end
	return "nil"
end

--timer.Create("MUTEST010101", 1, 0, function()
	--print(player.GetHumans()[1]:GetBystanderName().." is nearest to "..player.GetHumans()[1]:NearestAreaName())
--end)