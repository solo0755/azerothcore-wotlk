print(">>Script: PlayerLog loging.")
local TEAM_ALLIANCE=0
local TEAM_HORDE=1
--CLASS					职业	
local CLASS_WARRIOR 		= 1		--战士
local CLASS_PALADIN			= 2		--圣骑士
local CLASS_HUNTER			= 3		--猎人
local CLASS_ROGUE			= 4		--盗贼
local CLASS_PRIEST			= 5		--牧师
local CLASS_DEATH_KNIGHT	= 6		--死亡骑士
local CLASS_SHAMAN			= 7		--萨满
local CLASS_MAGE			= 8		--法师
local CLASS_WARLOCK			= 9		--术士
local CLASS_DRUID			= 11	--德鲁伊

local ClassName={--职业表
	[CLASS_WARRIOR]	="战士",
	[CLASS_PALADIN]	="圣骑士",
	[CLASS_HUNTER]	="猎人",
	[CLASS_ROGUE]	="盗贼",
	[CLASS_PRIEST]	="牧师",
	[CLASS_DEATH_KNIGHT]="死亡骑士",
	[CLASS_SHAMAN]	="萨满",
	[CLASS_MAGE]	="法师",
	[CLASS_WARLOCK]	="术士",
	[CLASS_DRUID]	="德鲁伊",
}

local function GetPlayerInfo(player)--得到玩家信息
	local Pclass	= ClassName[player:GetClass()] or "? ? ?" --得到职业
	local Pname		= player:GetName()
	local Pteam		= ""
	local team=player:GetTeam()
	if(team==TEAM_ALLIANCE)then
		Pteam		="|cFF0070d0联盟|r"
	elseif(team==TEAM_HORDE)then 
		Pteam		="|cFFF000A0部落|r"
	end
	return string.format("%s%s玩家[|cFF00FF00|Hplayer:%s|h%s|h|r]",Pteam,Pclass,Pname,Pname)
end

local function duelEnd(event, playerWin,playLoster)--玩家首次登录
	SendWorldMessage("|cFFFF0000[PVP系统公告]|r"..GetPlayerInfo(playerWin).."在决斗中战胜了"..GetPlayerInfo(playLoster))
	playerWin:ResetAllCooldowns()
	playLoster:ResetAllCooldowns()
	print("Player is Created. GUID:"..player:GetGUIDLow())
end

local function PlayerFirstLogin(event, player)--玩家首次登录
	if(player:GetGMRank()==0)then
		SendWorldMessage("|cFFFF0000[系统公告]|r 欢迎新人"..GetPlayerInfo(player).." |cFFFF0000来到 巫妖王之怒怀旧练习服！|r")
	end
	if(player:GetClass()==CLASS_DEATH_KNIGHT ) then
		if player:HasItem(6948) == false then player:AddItem(6948) end -- 职业物品
		if player:HasSpell(50977)== false then player.LearnSpell(player,50977) end--死骑传送前需要学习的技能，黑锋之门
		local team=player:GetTeam()
		if(team==TEAM_ALLIANCE)then
			player:Teleport(0,-4900.47,-962.585,501.455,5.40538,TELE_TO_GM_MODE)--传送铁炉堡
		elseif(team==TEAM_HORDE)then 
			player:Teleport(0, 1633.75, 240.167, -43.1034, 6.26128,TELE_TO_GM_MODE)--传送奥格瑞玛
		end
	end
	print("Player is Created. GUID:"..player:GetGUIDLow())
end

local function PlayerLogin(event, player)--玩家登录
	if(player:GetGMRank()==0)then
		SendWorldMessage("|cFFFF0000[系统通知]|r欢迎"..GetPlayerInfo(player).." 上线了！")
	end
	print("Player is Login. GUID:"..player:GetGUIDLow())
end

function addonMSG(event, player, type, prefix, msg, target)
if("uptonext" == prefix  ) then
	player:SendBroadcastMessage("msg:"..msg);
	local status=player:doItemUP()
	if (999 == status) then
	player:SendBroadcastMessage("物品合成成功");
	elseif(3 == status) then
	player:SendBroadcastMessage("合成物品缺失");
	elseif(2 == status) then
	player:SendBroadcastMessage("合成概率过低,合成失败了");
	elseif(1 == status) then
	player:SendBroadcastMessage("无合成任务");--待改进
	else
	player:SendBroadcastMessage("合成物品系统异常");
	end
end
return false
end

local function PlayerLogout(event, player)--玩家登出
--	SendWorldMessage("|cFFFF0000[系统公告]|r"..GetPlayerInfo(player).." 下线了！")
	print("Player is Logout. GUID:"..player:GetGUIDLow())
end

--PLAYER_EVENT_ON_FIRST_LOGIN             =     30       -- (event, player)
	RegisterPlayerEvent(30, PlayerFirstLogin)--首次登录
--PLAYER_EVENT_ON_LOGIN                   =     3        -- (event, player)
	RegisterPlayerEvent(3, PlayerLogin)--登录
--PLAYER_EVENT_ON_LOGOUT                  =     4        -- (event, player)
	RegisterPlayerEvent(4, PlayerLogout)--登出
	
	RegisterServerEvent(30,addonMSG)
	
	RegisterPlayerEvent(11, duelEnd)
	
