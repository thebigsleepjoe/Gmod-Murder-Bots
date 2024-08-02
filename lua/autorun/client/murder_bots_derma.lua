local info = {
    ["diff"] = 0,
    ["hide"] = 0,
}

net.Receive("ClientDisplayInfoMU", function()
    info = net.ReadTable()
end)

local maxplys = game.MaxPlayers()

local settings = {
    {
        ["Tracker"] = "diff",
        ["Config Name"] = "murder_bot_difficulty",
        ["Display Name"] = "Bot Difficulty",
        ["Description"] = "Enter a # between 1 to 100\n(or more if you're daring) to increase difficulty. Default is 25."
    },
    {
        ["Tracker"] = "hide",
        ["Config Name"] = "murder_bot_disable_hiding",
        ["Display Name"] = "Enable Hiding",
        ["Description"] = "Should the murder bots be able to hide?",
        ["Checkbox"] = true
    },
    {
        ["Tracker"] = "quota",
        ["Config Name"] = "murder_bot_quota",
        ["Display Name"] = "Bot Quota",
        ["Description"] = "Set the murder bot quota. Will automatically kick/add bots if needed."
    },
    {
        ["Tracker"] = "removedoors",
        ["Config Name"] = "murder_bot_remove_doors",
        ["Display Name"] = "Remove All Doors",
        ["Description"] = "Remove all doors on the map at the start of every round. \nThis can resolve potential pathfinding problems or can prevent bots from\n getting stuck in a door open-close loop..."
    },
    {
        ["Tracker"] = "nocollide",
        ["Config Name"] = "murder_bot_nocollide",
        ["Display Name"] = "No Collide",
        ["Description"] = "Enables/Disables the no collision of bots.\nCan prevent \"traffic jams\". \nDefault is true."
    }
}
net.Receive("RequestMenuMU", function()
    local ply = LocalPlayer()
    if ply:IsSuperAdmin() then
        local Frame = vgui.Create( "DFrame" )
        Frame:SetPos( ScrW()/2-300, ScrH()/2-300 )
        Frame:SetSize( 600, 600 )
        Frame:SetTitle( "Easy FPP Murder Bot Configuration Menu" )
        Frame:SetVisible( true )
        Frame:SetDraggable( true )
        Frame:ShowCloseButton( true )
        Frame:MakePopup()
        Frame.Paint = function(self,w,h)
            surface.SetDrawColor(0, 0, 0, 255)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(0, 0, 255, 20)
            surface.DrawRect(0, 0, w, 30)

            surface.SetDrawColor(255, 255, 255, 20)
            surface.DrawRect(0, 30, 230, 570)
        end

        local addone = vgui.Create("DButton", Frame)
        addone:SetText("Add 1 Preset Bot")
        addone:SetPos(10,40)
        addone:SetSize(100,34)
        addone.Paint = function(self,w,h)
            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(0, 0, w, h)
        end
        addone.DoClick = function()
            net.Start("RequestAddBotsMU")
            net.WriteInt(1, 32)
            net.SendToServer()
        end

        local kickone = vgui.Create("DButton", Frame)
        kickone:SetText("Remove 1 Bot")
        kickone:SetPos(120,40)
        kickone:SetSize(100,34)
        kickone.Paint = function(self,w,h)
            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(0, 0, w, h)
        end
        kickone.DoClick = function()
            net.Start("RequestKickBotsMU")
            net.WriteInt(1, 32)
            net.SendToServer()
        end

        local addone = vgui.Create("DButton", Frame)
        addone:SetText("Fill slots")
        addone:SetPos(10,84)
        addone:SetSize(100,34)
        addone.Paint = function(self,w,h)
            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(0, 0, w, h)
        end
        addone.DoClick = function()
            net.Start("RequestAddBotsMU")
            net.WriteInt(maxplys-(#player.GetAll()), 32)
            net.SendToServer()
        end

        local kickone = vgui.Create("DButton", Frame)
        kickone:SetText("Remove bots")
        kickone:SetPos(120,84)
        kickone:SetSize(100,34)
        kickone.Paint = function(self,w,h)
            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(0, 0, w, h)
        end
        kickone.DoClick = function()
            net.Start("RequestKickBotsMU")
            net.WriteInt(#player.GetBots(), 32)
            net.SendToServer()
        end

        local botcount = vgui.Create( "DLabel", Frame )
        botcount:SetPos( 40, 84+100 )
        botcount:SetSize(200,40)
        botcount.Paint = function(self,w,h)
            self:SetText("Number of bots: "..#player.GetBots())
        end


        local slotcount = vgui.Create( "DLabel", Frame )
        slotcount:SetPos( 40, 100+100 )
        slotcount:SetSize(200,40)
        slotcount.Paint = function(self,w,h)
            self:SetText("Empty slots: "..maxplys-(#player.GetAll()))
        end

        for i,v in pairs(settings) do
            local yval = 40+((i-1)*100)

            local label = vgui.Create( "DLabel", Frame )
            label:SetPos( 350, yval)
            label:SetSize(200,40)
            label:SetText(v["Display Name"].." ("..v["Config Name"]..")")
            --------- same variable on purpose
            label = vgui.Create( "DLabel", Frame )
            label:SetPos( 250, yval+30)
            label:SetSize(400,40)
            label:SetText(v["Description"])

            if v["Checkbox"] then
                local check = vgui.Create( "DCheckBox", Frame )
                check:SetPos( 350, yval+70)
                check:SetSize(40,15)
                check:SetChecked(info[v["Tracker"]])
                check:SetConVar(v["Config Name"])
                check.Paint = function(self,w,h)
                    local chk = self:GetChecked()
                    local txt = ""
                    if chk then txt = "Enabled" else txt = "Disabled" end
                    surface.SetDrawColor(255, 255, 255)
                    surface.DrawRect(-10, 0, w+10, h)

                    surface.SetFont( "DermaDefault" )
                    if chk then
                        surface.SetTextColor( 0, 75, 0 )
                    else
                        surface.SetTextColor( 75, 0, 0 )
                    end
                    surface.SetTextPos( 0, 0 )
                    surface.DrawText( txt )
                end
            else
                local TextEntry = vgui.Create( "DTextEntry", Frame )
                TextEntry:SetPos( 350, yval+70 )
                TextEntry:SetSize( 40, 15 )
                TextEntry:SetText(info[v["Tracker"]])
                TextEntry:SetConVar(v["Config Name"])
                TextEntry.Paint = function(self,w,h)
                    surface.SetDrawColor(255, 255, 255, 255)
                    surface.DrawRect(-15, 0, w+15, h)

                    surface.SetFont( "DermaDefault" )
                    surface.SetTextColor( 255, 0, 0 )
                    surface.SetTextPos( 0, 0 )
                    surface.DrawText( self:GetText() )
                end
            end
        end

--[[
        local customprof = {name = "Custom Bot", accuracy = 1, personalty = 1}

        local perso = vgui.Create( "DComboBox", Frame)
        perso:SetPos( 10, 150+300 )
        perso:SetSize( 150, 20 )
        perso:SetValue( "Bot Chat Profile" )
        perso:AddChoice( "Friendly" )
        perso:AddChoice( "Hostile" )
        perso:AddChoice( "Troll" )
        perso:AddChoice( "Average" )
        perso.OnSelect = function( panel, index, value )
            customprof.personality = index-1
        end

        local accur = vgui.Create( "DComboBox", Frame)
        accur:SetPos( 10, 200+300 )
        accur:SetSize( 150, 20 )
        accur:SetValue( "Accuracy Setting" )

        accur:AddChoice( "1: Absolutely Terrible" )
        accur:AddChoice( "2: Still Terrible" )
        accur:AddChoice( "3: Terrible" )
        accur:AddChoice( "4: Below Average" )
        accur:AddChoice( "5: Average" )
        accur:AddChoice( "6: Above Average" )
        accur:AddChoice( "7: Pretty Good" )
        accur:AddChoice( "8: Aimbot?" )

        accur.OnSelect = function( panel, index, value )
            customprof.accuracy = math.Remap(index, 1, 7, 0.5, 1.5)
        end

        local Label = vgui.Create( "DLabel", Frame )
        Label:SetPos( 10, 100+250 )
        Label:SetSize( 150,20 )
        Label:SetText("Custom Bot Creator")

        local TextEntry = vgui.Create( "DTextEntry", Frame )
        TextEntry:SetPos( 10, 100+300 )
        TextEntry:SetSize( 150,20 )
        TextEntry:SetText("Bot Name")

        TextEntry.Paint = function(self,w,h)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawRect(-15, 0, w+15, h)
            surface.SetFont( "DermaDefault" )
            surface.SetTextColor( 0, 0, 0 )
            surface.SetTextPos( 5, 0 )
            surface.DrawText( self:GetText() )
        end


        local addcustom = vgui.Create("DButton", Frame)
        addcustom:SetText("Add Custom Bot")
        addcustom:SetPos( 10, 550 )
        addcustom:SetSize( 150, 20 )
        addcustom.Paint = function(self,w,h)
            surface.SetDrawColor(255,255,255,255)
            surface.DrawRect(0, 0, w, h)
        end
        addcustom.DoClick = function()
            customprof.name = TextEntry:GetText()
            net.Start("RequestAddCustomBot")
            net.WriteTable(customprof)
            net.SendToServer()
        end
--]]
        return false
    else
        ply:ChatPrint("You must be a superadmin to open the Easy TTT Bot Configuration Menu.")
    end
end)