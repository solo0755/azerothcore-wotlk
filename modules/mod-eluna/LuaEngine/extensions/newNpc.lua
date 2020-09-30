print(">>Script: HelloWorld  NPC loading.")

local NPCID    =    198601
local NPCNAME="随身商人"
local buff = 2
local DW=1
local OT=2
--GOSSIP_ICON 菜单图标
local GOSSIP_ICON_CHAT            = 0                    -- 对话
local GOSSIP_ICON_VENDOR          = 1                    -- 货物
local factionIDSH=   {947, 942, 1011, 935, 989,1156} -- 部落
local factionIDSA=   {946, 942, 1011, 935, 989,1156} -- 联盟

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

local allPersSkill = {
	[CLASS_WARRIOR]={ "学习 |cff6247c8狂暴姿态、防御姿态|h|r",{ 2458, 71, 355, 7386, 20617 },{},{ "武器","狂怒","防护" } },
	[CLASS_PALADIN]={"学习 |cff6247c8救赎|h|r 职业技能",{ 7328 },{} ,{ "神圣","惩戒","防护" } },
	[CLASS_HUNTER]={"学习 |cff6247c8驯服野兽|h|r 职业技能",{ 1515, 5149, 883, 2641, 6991, 982 },{} ,{ "野兽控制","射击","生存" } },
	--[CLASS_ROGUE]={"学习 |cff6247c8制毒|h|r 职业技能",{ 2842 },{} ,{ "刺杀","战斗","敏锐" } },
	[CLASS_SHAMAN]={"获取 |cff6247c8风火水地图腾|h|r",{3599,8071,5394},{ 5175 ,5176,5177,5178 } ,{ "元素","增强","恢复" } },
	[CLASS_WARLOCK]={"学习 |cff6247c8召唤小鬼|h|r 职业技能",{ 688, 712,691 },{} ,{ "痛苦","恶魔学识","毁灭" } },
	[CLASS_DRUID]={"学习 |cff6247c8各种形态|h|r 职业技能",{ 5487,9634,6795,6807,33943 },{} ,{ "平衡","野性战斗","恢复" } },
}

local GOODS={--货物id号
    [0]={--菜单
        {"新手物品",1,1},
        {"学习法术和武器技能",100,3}, 
       -- {"提升奥尔多或占星者声望",997,0}, 
        {"提升常用声望到崇拜",998,0},  
	{"获取竞技点和荣誉值",999,0},  
        {"增加世界BUFF",1000,7},  
        {"打开我的银行",2001,6},  
    }

}

local Says={--随机的话
    "我的货物不打折的哦",
    "慢慢看，我的货物在其他地方买不到。",
    "我的时间可不多，你要快点买。",
    "没有的物品可以通过炉石中输入ID来获取装备",
    "你应该需要的是变红变粗的buff...",
    "如有问题留言GM微信: solomon0728 会尽快回复你",
}

local function OnHelloBuff(event, player, creature)
    --player:GossipMenuAddItem(0, "护甲 + 10%", buff, 23767)
    player:GossipMenuAddItem(0, "近战伤害 + 1 - 10%", buff, 23768)
    --player:GossipMenuAddItem(0, "抗性 + 25", buff, 23769)
    --player:GossipMenuAddItem(0, "敏捷 + 10%", buff, 23736)
    --player:GossipMenuAddItem(0, "智力 + 10%", buff, 23766)
    --player:GossipMenuAddItem(0, "精神 + 10%", buff, 23738)
    --player:GossipMenuAddItem(0, "力量 + 10%", buff, 23735)
    player:GossipMenuAddItem(0, "耐力 + 10%", buff, 23737)
    --player:GossipMenuAddItem(0, "屠龙者的咆哮", buff, 22888)
    player:GossipMenuAddItem(0, "赞达拉之魂", buff, 24425)
    player:GossipMenuAddItem(0, "阿达尔的祝福", buff, 35076)
    player:GossipSendMenu(1, creature)
end

function GOODS.AddMenu(player, unit, id)
    player:GossipClearMenu()--清除菜单
    local menus=GOODS[id]
    for k ,v in pairs(menus)do
        player:GossipMenuAddItem(v[3] or GOSSIP_ICON_VENDOR, v[1] or "???", 0, (v[2] or k))
    end
    if allPersSkill[player:GetClass()] ~= nil then
        player:GossipMenuAddItem(3, allPersSkill[player:GetClass()][1], 0, 99999)
    end
    if player:GetClass()==CLASS_HUNTER then
         player:GossipMenuAddItem(3, "提升宠物等级到80", 0, 99998)
    end
    player:GossipSendMenu(1, unit)--发送菜单
end

function GOODS.Book(event, player, unit)--显示菜单
    GOODS.AddMenu(player, unit, 0)
end

math.randomseed(os.time())

function GOODS.Select(event, player, unit, sender, intid, code, menu_id)--添加货物
    local canspeak = math.random(1,10)
    
	
    --player:SendNotification("initid=="..intid.." sender="..sender)
    if intid==1 then
        player:SendListInventory(unit)
            player:GossipComplete()    --关闭菜单
    elseif intid == 998 then -- 提升声望
         --player:SendNotification("阵营声望+:"..player:GetTeam())
         if (player:GetTeam() == 0) then
                    for i, v in pairs(factionIDSA) do
                            if player:GetReputation(v)<56000 then player:SetReputation(v,56001) end
                    end
         else
                    for i, v in pairs(factionIDSH) do
                            if player:GetReputation(v)<56000 then player:SetReputation(v,56001) end
                    end
         end
    
         player:SendNotification("声望已经加装至崇拜")
		 player:GossipComplete()    --关闭菜单
    elseif intid==999 then
	if player:GetHonorPoints()<75000 then player:SetHonorPoints(75000) end
	if player:GetArenaPoints()<10000 then player:SetArenaPoints(10000) end
	if canspeak >5 then	unit:SendUnitSay("勇士,你需要的荣誉点和竞技场点数已经加满,开始奔跑吧",0) end
	player:GossipComplete()    --关闭菜单
    elseif intid==100 then
        player:SendTrainerList(unit)
    elseif intid ==1000  then   --加BUFF
        OnHelloBuff(event, player, unit)
    elseif intid ==2001  then  --打开银行
        player:SendShowBank(unit)
	 elseif intid ==99998  then  --打开银行
        player:levelUpPet()
		player:GossipComplete()    --关闭菜单
    elseif intid ==99999  then
        --1职业技能
        for i, v in pairs(allPersSkill[player:GetClass()][2]) do
            if player:HasSpell(v) == false then player:LearnSpell(v) end -- 职业技能
        end
        --2职业物品
        for i, v in pairs(allPersSkill[player:GetClass()][3]) do
            if player:HasItem(v) == false then player:AddItem(v) end -- 职业物品
        end
		player:SendNotification("您的职业任务已经完成咯,开始您新的巫妖之旅吧...")
		player:GossipComplete()    --关闭菜单
    elseif  sender==buff then
        player:CastSpell(player, intid, true)
		if canspeak >5 then	unit:SendUnitSay("勇士,您已经足够强大，莫非你要的是变红变粗的...BUFF",0) end
		player:GossipComplete()    --关闭菜单
    end
end

    RegisterCreatureGossipEvent(NPCID, 1, GOODS.Book)
    RegisterCreatureGossipEvent(NPCID, 2, GOODS.Select)
