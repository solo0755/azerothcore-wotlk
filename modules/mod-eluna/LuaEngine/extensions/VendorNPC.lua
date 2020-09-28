print(">>Script: VendorNPC loging.")

local NPCID = 198605
local NPCNAME = "随身商人"
local NPCNAMEDES = "随身商人副标题"

-- 菜单号

local WARPON = 5
local FINGER = 6
local NECK = 7
local DW = 8 -- 雕文
local STON = 9 -- 镶嵌宝石
local SPELLITEM = 10 -- 施法物品
local TRADEITEM = 11 -- 商业材料
local RIDER = 12 -- 坐骑
local HUJIA=13 --按职业区分的护甲

--菜单号,一定要比上面的物品类型大
local CHUANJIABAO=0x500

local CLASS_WARRIOR = 1 -- 战士
local CLASS_PALADIN = 2 -- 圣骑士
local CLASS_HUNTER = 3 -- 猎人
local CLASS_ROGUE = 4 -- 盗贼
local CLASS_PRIEST = 5 -- 牧师
local CLASS_DEATH_KNIGHT = 6 -- 死亡骑士
local CLASS_SHAMAN = 7 -- 萨满
local CLASS_MAGE = 8 -- 法师
local CLASS_WARLOCK = 9 -- 术士
local CLASS_DRUID = 11 -- 德鲁伊

-- GOSSIP_ICON 菜单图标
local GOSSIP_ICON_CHAT = 7 -- 对话
local GOSSIP_ICON_VENDOR = 1 -- 货物


-- 菜单类型
local FUNC = 1
local MENU = 2
local CLASSFUNC = 3
-- 数据库
local inSQL = [[
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`, `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `mindmg`, `maxdmg`, `dmgschool`, `attackpower`, `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `unit_class`, `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`, `trainer_race`, `minrangedmg`, `maxrangedmg`, `rangedattackpower`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `resistance1`, `resistance2`, `resistance3`, `resistance4`, `resistance5`, `resistance6`, `spell1`, `spell2`, `spell3`, `spell4`, `spell5`, `spell6`, `spell7`, `spell8`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `RacialLeader`, `movementId`, `RegenHealth`, `mechanic_immune_mask`, `flags_extra`, `ScriptName`, `VerifiedBuild`) VALUES (]] ..
                  NPCID ..
                  [[, '0', '0', '0', '0', '0', '7176', '0', '0', '0', ']] ..
                  NPCNAME .. [[', ']] .. NPCNAMEDES ..
                  [[', '', '0', '80', '80', '1', '35', '129', '1.125', '1.14286', '1.3', '0', '248', '363', '0', '135', '1', '2000', '1684', '8', '2', '2048', '0', '0', '0', '0', '0', '0', '233', '347', '28', '7', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '', '1', '3', '1', '1', '1', '1', '0', '0', '1', '0', '2', '', '12340');
]]

local unSQL = "DELETE FROM `creature_template` WHERE `entry`=" .. NPCID .. ";"

local GOODS = { -- 货物id号
    [0] = { -- 菜单

		{CLASSMENU, "文字取子菜单", HUJIA},--按职业区分的护甲
        {FUNC, "|cFF990066|TInterface\\ICONS\\INV_Sword_62.blp:20|t|r 新兵-|cffa335ee武器、副手|r", WARPON},--武器
        {FUNC, "|cFF990066|TInterface\\ICONS\\INV_Jewelry_Ring_20.blp:20|t|r 新兵-|cffa335ee饰品、戒指|r", FINGER},--项链戒指
		{FUNC, "|cFF990066|TInterface\\ICONS\\INV_Misc_Cape_Naxxramas_02.blp:20|t|r 新兵-|cffa335ee披风、项链|r", NECK}, --散件
		{CLASSFUNC, "|cFF990066|TInterface\\ICONS\\INV_Inscription_MajorGlyph09.blp:20|t|r 职业雕文", DW}, -- 换成职业自己的
		{FUNC, "|cFF990066|TInterface\\ICONS\\INV_Jewelcrafting_CrimsonSpinel_01.blp:20|t|r 镶嵌宝石", STON}, --宝石
		{FUNC, "|cFF990066|TInterface\\ICONS\\INV_Misc_Rune_06.blp:20|t|r 施法材料", SPELLITEM},--施法材料
		{FUNC, "|cFF990066|TInterface\\ICONS\\INV_Ore_Copper_01.blp:20|t|r 专业材料", TRADEITEM}, --专业材料
		{FUNC, "|cFF990066|TInterface\\ICONS\\Ability_Mount_RidingHorse.blp:20|t|r 坐骑商人", RIDER},--坐骑
        {MENU, "|cFF990066|TInterface\\ICONS\\Achievement_PVP_G_12.blp:20|t|r 传家宝装备", CHUANJIABAO}--传家宝
    },


	[HUJIA]={--新手装备
		[CLASS_WARRIOR] = {FUNC,"|cFF990066|TInterface\\ICONS\\INV_Chest_Plate12.blp:20|t|r 新兵-|cffa335ee板甲|r",HUJIA+010},
		[CLASS_PALADIN]= {FUNC, "|cFF990066|TInterface\\ICONS\\INV_Chest_Plate12.blp:20|t|r 新兵-|cffa335ee板甲|r",HUJIA+010},
		[CLASS_HUNTER]= {FUNC, "|cFF990066|TInterface\\ICONS\\INV_Chest_Chain.blp:20|t|r 新兵-|cffa335ee锁甲|r",HUJIA+020},
		[CLASS_ROGUE]= {FUNC, "|cFF990066|TInterface\\ICONS\\INV_Chest_Cloth_22.blp:20|t|r 新兵-|cffa335ee布甲|r",HUJIA+030},
		[CLASS_PRIEST]= {FUNC, "|cFF990066|TInterface\\ICONS\\INV_Chest_Cloth_22.blp:20|t|r 新兵-|cffa335ee布甲|r",HUJIA+040},
		[CLASS_DEATH_KNIGHT]= {FUNC, "|cFF990066|TInterface\\ICONS\\INV_Chest_Plate12.blp:20|t|r 新兵-|cffa335ee板甲|r",HUJIA+010},
		[CLASS_SHAMAN]= {FUNC, "|cFF990066|TInterface\\ICONS\\INV_Chest_Chain.blp:20|t|r 新兵-|cffa335ee锁甲|r",HUJIA+020},
		[CLASS_MAGE]= {FUNC, "|cFF990066|TInterface\\ICONS\\INV_Chest_Cloth_22.blp:20|t|r 新兵-|cffa335ee布甲|r",HUJIA+040},
		[CLASS_WARLOCK]= {FUNC, "|cFF990066|TInterface\\ICONS\\INV_Chest_Cloth_22.blp:20|t|r 新兵-|cffa335ee布甲|r",HUJIA+040},
		[CLASS_DRUID]= {FUNC, "|cFF990066|TInterface\\ICONS\\INV_Chest_Cloth_22.blp:20|t|r 新兵-|cffa335ee布甲|r",HUJIA+030},
	},
	[HUJIA+010] = {--板甲
		39139, 39188, 39195, 39197, 39198, 39228, 39234, 39235, 39239, 39249,
        39258, 39260, 39261, 39262, 39267, 39280, 39293, 39298, 39306, 39369,
        39398, 39403
    },
    [HUJIA+020] = { --锁甲
		39189, 39194, 39217, 39236, 39243, 39248, 39251, 39274, 39278, 39294,
        39307, 39391, 39405
    },
    [HUJIA+030] = {--皮甲
		39191, 39196, 39215, 39224, 39230, 39237, 39240, 39247, 39259, 39275,
        39279, 39283, 39299, 39308, 39386, 39399
    },
    [HUJIA+040] = {--布甲
        39190, 39192, 39216,  39242, 39252, 39254,  39273,
        39285, 39295,  39310, 39390, 39396,  39408, 39409
    },
    [WARPON] = {
		39140, 39200, 39221, 39226, 39233, 39245,  39256, 39270, 39271,
        39276, 39281, 39291, 39296, 39344, 39394, 39416, 39417, 39419, 39420,
        39422, 39423, 39424, 39426,39199,39311,39255
    },
    [FINGER] = {
		39141,  39193,  39277, 39231,  39244,  39250,
        39257, 39229,  39292,  39388, 39389,  39401, 39407
	},
	[NECK] ={
		39404,39415,39297,39225,39272,39241,39425,39146,39232,39246,39282,39392,39421
	},
    [STON] = {
		40111, 40112, 40113, 40114,
        40115, 40116, 40117, 40118, 40119, 40120, 40121, 40122, 40123, 40124,
        40125, 40126, 40127, 40128, 40129, 40130, 40131, 40132, 40133, 40134,
        40135, 40136, 40137, 40138, 40139, 40140, 40141, 40142, 40143, 40144,
        40145, 40146, 40147, 40148, 40149, 40150, 40151, 40152, 40153, 40154,
        40155, 40156, 40157, 40158, 40159, 40160, 40161, 40162, 40163, 40164,
        40165, 40166, 40167, 40168, 40169, 40170, 40171, 40172, 40173, 40174,
        40175, 40176, 40177, 40178, 40179, 40180, 40181, 40182, 44066, 45862,
        45879, 45880, 45881, 45882, 45883, 45987, 49110,41285,41307,41333,41335,41339,41375,41376,41377,41378,41379,41380,41381,41382,41385,41389,41395,41396,41397,41398,41400,41401,44076,44078,44081,44082,44084,44087,44088,44089
	},
	
    [RIDER] = {30609,32314,32316,32317,32318,32319,32458,32857,32858,32859,32860,32861,32862,33999,34092,35226,37676,43516,43951,43952,43953,43954,43955,43986,44151,44160,44164,44168,44175,44177,44178,44707,45693,45801,45802,46171,46708,47840,49286,49636,50435,51954,51955},
	
    [SPELLITEM] = {
		5565, 16583, 17020, 17021, 17026, 17028, 17029, 17030, 17031, 17032,
        17033, 17034, 17035, 17036, 17037, 17038, 21177, 22147, 22148, 37201,
        44605, 44614, 44615
	},
	
	[TRADEITEM] = {46376,46377,46379,46378,36895,36909, 36910, 36912,45279,49040,41611},

	--------------------------------------职业雕文	
    --------------------------------------职业雕文	
    [DW] = {
        [CLASS_ROGUE] = {
            42954, 42955, 42956, 42957, 42958, 42959, 42960, 42961, 42962,
            42963, 42964, 42965, 42966, 42967, 42968, 42969, 42970, 42971,
            42972, 42973, 42974, 43343, 43376, 43377, 43378, 43379, 43380,
            45761, 45762, 45764, 45766, 45767, 45768, 45769, 45908
        },
        [CLASS_DRUID] = {
            40896, 40897, 40899, 40900, 40901, 40902, 40903, 40906, 40908,
            40909, 40912, 40913, 40914, 40915, 40916, 40919, 40920, 40921,
            40922, 40923, 40924, 43316, 43331, 43332, 43334, 43335, 43674,
            44922, 44928, 45601, 45602, 45603, 45604, 45622, 45623, 46372
        },
        [CLASS_MAGE] = {
            42734, 42735, 42736, 42737, 42738, 42739, 42740, 42741, 42742,
            42743, 42744, 42745, 42746, 42747, 42748, 42749, 42750, 42751,
            42752, 42753, 42754, 43339, 43357, 43359, 43360, 43361, 43362,
            43364, 44684, 44920, 44955, 45736, 45737, 45738, 45739, 45740
        },
        [CLASS_HUNTER] = {
            42897, 42898, 42899, 42900, 42901, 42902, 42903, 42904, 42905,
            42906, 42907, 42908, 42909, 42910, 42911, 42912, 42913, 42914,
            42915, 42917, 43338, 43350, 43351, 43354, 43355, 43356, 45625,
            45731, 45732, 45733, 45734, 45735
        },
        [CLASS_PRIEST] = {
            42396, 42397, 42398, 42399, 42400, 42401, 42402, 42403, 42404,
            42405, 42406, 42407, 42408, 42409, 42410, 42411, 42412, 42414,
            42415, 42416, 42417, 43342, 43370, 43371, 43372, 43373, 43374,
            45753, 45755, 45756, 45757, 45758, 45760
        },
        [CLASS_PALADIN] = {
            41092, 41094, 41095, 41096, 41097, 41098, 41099, 41100, 41101,
            41102, 41103, 41104, 41105, 41106, 41107, 41108, 41109, 41110,
            43340, 43365, 43366, 43367, 43368, 43369, 43867, 43868, 43869,
            45741, 45742, 45743, 45744, 45745, 45746, 45747
        },
        [CLASS_SHAMAN] = {
            41517, 41518, 41524, 41526, 41527, 41529, 41530, 41531, 41532,
            41533, 41534, 41535, 41536, 41537, 41538, 41539, 41540, 41541,
            41542, 41547, 41552, 43344, 43381, 43385, 43386, 43388, 43725,
            44923, 45770, 45771, 45772, 45775, 45776, 45777, 45778
        },
        [CLASS_WARLOCK] = {
            42453, 42454, 42455, 42456, 42457, 42458, 42459, 42460, 42461,
            42462, 42463, 42464, 42465, 42466, 42467, 42468, 42469, 42470,
            42471, 42472, 42473, 43389, 43390, 43391, 43392, 43393, 43394,
            45779, 45780, 45781, 45782, 45783, 45785, 45789
        },
        [CLASS_DEATH_KNIGHT] = {
            43533, 43534, 43535, 43536, 43537, 43538, 43539, 43541, 43542,
            43543, 43544, 43545, 43546, 43547, 43548, 43549, 43550, 43551,
            43552, 43553, 43554, 43671, 43672, 43673, 43825, 43826, 43827,
            45799, 45800, 45803, 45804, 45805, 45806
        },
        [CLASS_WARRIOR] = {
            43395, 43396, 43397, 43398, 43399, 43400, 43412, 43413, 43414,
            43415, 43416, 43417, 43418, 43419, 43420, 43421, 43422, 43423,
            43424, 43425, 43426, 43427, 43428, 43429, 43430, 43431, 43432,
            45790, 45792, 45793, 45794, 45797
        }
    },

[CHUANJIABAO]={--传送菜单
	{FUNC, "传家宝一号",			CHUANJIABAO+0x10,GOSSIP_ICON_BATTLE},
	{FUNC, "传家宝二号",			CHUANJIABAO+0x20,GOSSIP_ICON_BATTLE},
},

[CHUANJIABAO+0x10] = { -- 传家宝1
44097, 44098, 44099, 44100, 44101, 44102, 44103, 44105, 44107, 48677,
48683, 48685, 48687, 48689, 48691, 48716, 48718, 50255, 21537, 6265,
23162
},
[CHUANJIABAO+0x20] = { -- 传家宝2
42943, 42944, 42945, 42946, 42947, 42948, 42949, 42950, 42951, 42952,
42984, 42985, 42991, 42992, 44091, 44092, 44093, 44094, 44095, 44096
}

}

local Says = { -- 随机的话
    "我的货物不打折的哦",
    "慢慢看，我的货物在其他地方买不到。",
    "我的时间可不多，你要快点买。",
    "我这里有很多高级宝石。", "你不买点材料做生意吗？",
    "要来点高级宝石，给装备强化吗？",
    "你应该需要更换你的雕文。",
    "当年我可是第一盗贼，留下很多钥匙。"
}

function GOODS.AddMenu(player, unit, id)
    player:GossipClearMenu() -- 清除菜单
    local menus = GOODS[id]

    for k, v in pairs(menus) do
        local mtype, text, icon, intid = v[1], (v[2] or "???"),
                                         (v[4] or GOSSIP_ICON_CHAT),
                                         (id * 0x100 + k)

        if (mtype == CLASSMENU) then -- 菜单编号取子菜单
            -- id=v[3]
            local itemV = GOODS[v[3]][player:GetClass()]
            mtype = itemV[1]
            text = itemV[2] or "???"
            icon = itemV[4] or GOSSIP_ICON_CHAT
            intid = v[3] * 0x100 + player:GetClass() -- 职业菜单要加职业偏移量
        end

        if (mtype == CLASSFUNC) then -- 菜单编号取子菜单
            intid = v[3] * 0x100 + player:GetClass()
        end
        -- player:SendBroadcastMessage("ID"..intid..";mtype:"..mtype..";text:"..text)
        if (mtype == MENU) then -- 菜单类型
            player:GossipMenuAddItem(icon, text, 0, (v[3] or id) * 0x100) -- 标记他的起始菜单，所以少了K
        elseif (mtype == FUNC) then
            local code, msg, money = v[5], (v[6] or ""), (v[7] or 0)
            if ((code == true or code == false)) then
                player:GossipMenuAddItem(icon, text, money, intid, code, msg,
                                         money)
            else
                player:GossipMenuAddItem(icon, text, 0, intid)
            end
        else
            player:GossipMenuAddItem(icon, text, 0, intid)
        end
    end
    player:GossipSendMenu(1, unit) -- 发送菜单
end

function GOODS.Book(event, player, unit) -- 显示菜单
    GOODS.AddMenu(player, unit, 0)
end

math.randomseed(os.time())

function GOODS.Select(event, player, unit, sender, intid, code, menu_id) -- 添加货物
    --	player:SendBroadcastMessage("select"..intid)
    local menuid = math.modf(intid / 0x100) -- 菜单组
    local rowid = intid - menuid * 0x100 -- 动态显示当前菜单项
    --player:SendBroadcastMessage("menuid:" .. menuid .. ";rowid:" .. rowid)

    local text = Says[math.random(1, #Says)] or nil
    if (text) then unit:SendUnitSay(text, 0) end
    -- player:GossipComplete() -- 关闭菜单

    local goodsItems

    if (menuid == DW) then -- 对于套装需要职业过滤,按ID来做
        goodsItems = GOODS[menuid][player:GetClass()]
    elseif (menuid == HUJIA) then
        local mmid = GOODS[menuid][player:GetClass()][3] -- 重新计算菜单
        goodsItems = GOODS[mmid]
    else

        -- goodsItems=GOODS[rowid]   
        goodsItems = GOODS[menuid] and GOODS[menuid][rowid] ---这个菜单值是动态的，特别重点
        -- player:SendBroadcastMessage("goodsItems:"..goodsItems[3])  
    end

    if (goodsItems) then
        local entry = unit:GetEntry()
        VendorRemoveAllItems(entry)
        local goods = GOODS[goodsItems[3]] or goodsItems -- 重点，动态取菜单
        for k, v in pairs(goods) do AddVendorItem(entry, v, 0, 0, 0) end
        player:SendListInventory(unit)
    else
        -- goodsItems为空时，表示是菜单
        GOODS.AddMenu(player, unit, menuid)
        return
    end
    player:GossipComplete() -- 关闭菜单
end

-- WorldDBExecute(inSQL)--添加商人
RegisterCreatureGossipEvent(NPCID, 1, GOODS.Book)
RegisterCreatureGossipEvent(NPCID, 2, GOODS.Select)
-- WorldDBExecute(unSQL)删除商人
