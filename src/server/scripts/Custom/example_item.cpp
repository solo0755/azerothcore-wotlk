/*
    MIT License

    Copyright (c) 2018 José González

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
 */

#include "ScriptMgr.h"
#include "Group.h"
#include "PzxConfig.h"
#include "Config.h"
#include "common_example.h"
#include  "Log.h"

//#include "ScriptPCH.h"   <- You could use the Precompiled Headers too!

//    item_ + "something"
class item_example : public ItemScript
{
public:
    item_example() : ItemScript("item_example"){}  //炉石ID 6948
	void PSendSysMessage(Player *player, const char *format, ...)
	{
		va_list ap;
		char str[2048];
		va_start(ap, format);
		vsnprintf(str, 2048, format, ap);
		va_end(ap);

		WorldPacket data(SMSG_SERVER_MESSAGE, (strlen(str) + 1));              // guess size
		data << uint32(SERVER_MSG_STRING);
		data << str;

		if (player&&player->GetSession())
			player->GetSession()->SendPacket(&data);

	}
    // Triggers when the item executes the spell assigned to it
    // If you don't want a spell executed, assign the "Dummy Spell" (ID: 18282)
    bool OnUse(Player * player, Item * item, SpellCastTargets const& targets)
    {
		player->PlayerTalkClass->ClearMenus();
       // player->GetSession()->SendNotification(u8"|CFF7BBEF7[测试]|r:炉石功能测试");

		if (sPzxConfig->GetIntDefault("show.additem", 1)) {
			player->ADD_GOSSIP_ITEM_EXTENDED(6, u8"我需要一个物品<|cffff0000危险操作|h|r>|n|cff00f700   **使用说明**|h|r:在弹出框中输入|cff6247c8物品ID|h|r", GOSSIP_SENDER_MAIN, 1001, "reload config 配置abc", 0,true);
		}
		player->ADD_GOSSIP_ITEM(0, u8"传送到达拉然", GOSSIP_SENDER_MAIN, 1002);
		player->ADD_GOSSIP_ITEM(0, u8"|cff6247c8复活并召唤|h|r全体团员", GOSSIP_SENDER_MAIN, 404);
		player->ADD_GOSSIP_ITEM(0, u8"为我和全团加满|cff6247c8世界BUFF|h|r", GOSSIP_SENDER_MAIN, 102);
		player->ADD_GOSSIP_ITEM(0, u8"新手接待", GOSSIP_SENDER_MAIN, 998);
		player->ADD_GOSSIP_ITEM(0, u8"重新加载服务器个性化配置", GOSSIP_SENDER_MAIN, 999);
		player->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, item->GetGUID());

        return true;
    }

    // Triggers when the player accepts the quest assigned to the item
    bool OnQuestAccept(Player* player, Item* item, Quest const* quest)
    {
        return true;
    }

    // Triggers when the item expires, just before destroying it
    bool OnItemExpire(Player* player, ItemTemplate const* proto)
    {
        return true;
    }

	void addItemSet(Player *player, uint8 itemindex) {
		uint32 itemsetid = IDS[player->getClass()][itemindex];

		if (itemsetid) {
		
			for (uint32 entryId = 0; entryId < sItemSetStore.GetNumRows(); ++entryId)
			{
				ItemSetEntry const* setEntry = sItemSetStore.LookupEntry(itemsetid);
				if (!setEntry)
					continue;

				for (uint32 i = 0; i < MAX_ITEM_SET_ITEMS; ++i)
					if (setEntry->itemId[i]) {
						if (player->HasItemCount(setEntry->itemId[i], 1, true)) {//已经有一件了
							continue;
						}
						ItemPosCountVec dest;
						InventoryResult msg = player->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, setEntry->itemId[i], 1);
						if (msg == EQUIP_ERR_OK)
						{
							Item* item = player->StoreNewItem(dest, setEntry->itemId[i], true);

							// remove binding (let GM give it to another player later)

							//player->SendNewItem(item, 1, false, true);
							player->SendNewItem(item, 1, true, false);
							PSendSysMessage(player, u8"[系统消息]:%s 已经添加到你包中", item->GetTemplate()->Name1.c_str());
						}
						else
						{
							player->SendEquipError(msg, nullptr, nullptr, setEntry->itemId[i]);
							PSendSysMessage(player, u8"[系统消息]:请保持包包有足够空间");
							//PSendSysMessage(LANG_ITEM_CANNOT_CREATE, pProto->ItemId, 1);
						}
						//itemSetItems.insert(setEntry->itemId[i]);
					}
			}

		}
	}
    // Triggers when the player selects an option from the gossip menu assigned to the item
    void OnGossipSelect(Player* player, Item* item, uint32 sender, uint32 action)
    {
		sLog->outString("[pzx](%d)-[%s] action %d", player->GetGUIDLow(), player->GetName().c_str(), action);
		//1.判断1
		switch (action)
		{

		case 404://团长工具
		case 405:
		case 406:
		case 407:
		case 408:
		case 409://+减速buff
		case 410:
		case 411:
		case 412:
		case 413:
		{
			if (player->IsInCombat()) {
				PSendSysMessage(player, u8"|cffff0000[系统消息]:|h|r不可以在战斗中能使用此功能");
				player->CLOSE_GOSSIP_MENU();
				return ;
			}
			if (!(player->GetGroup() && player->HasFlag(PLAYER_FLAGS, PLAYER_FLAGS_GROUP_LEADER))) {
				PSendSysMessage(player, u8"|cffff0000[系统消息]:|h|r只有团队领袖才能使用此功能");
				player->CLOSE_GOSSIP_MENU();
				return ;
			}
		}
		break;
		default:
			break;
		}
		//2.判断2
		switch (action)
		{
		case 404://队长集合+复活
		{

			//std::list<Player*> reivePlayers;
			if (Group *group = player->GetGroup()) {

				for (GroupReference* groupRef = group->GetFirstMember(); groupRef != NULL; groupRef = groupRef->next())
				{

					Player* member = groupRef->GetSource();

					if (!member || !member->GetSession() || member == player)
						continue;

					// check online security
					if (member->IsInCombat() || member->IsBeingTeleported()) {//战斗中正在传送中不可再次使用
						PSendSysMessage(player, u8"团队成员[|cffff0000%s|h|r]正在战斗中", member->GetName());
						continue;
					}
					if (member->IsAlive() && member->GetDistance2d(player) < sPzxConfig->GetIntDefault("raidTool.instance", 50) && player->IsWithinLOSInMap(member) ) {
						//小于50码而且在同一地图，不召唤
						continue;
					}
					if (member->IsAlive()) {
						player->CastSpell(member, 7720, true);
					}
					else {
						Corpse* pcor = member->GetCorpse();
						if (!pcor) {//没释放，还没有尸体
							if (player->IsWithinLOSInMap(member)) {
								player->CastSpell(member, 20770, true);
								continue;
							}
						}
						//释放了,直接瞬间复活
						float x, y, z;
						player->GetPosition(x, y, z);
						try
						{
							member->TeleportTo(player->GetMapId(), x, y, z + 2.0f, member->GetAngle(player), TELE_TO_GM_MODE);
							//if (pcor) {//释放了的才复活
							member->ResurrectPlayer(0.59f);
							member->SpawnCorpseBones();
							//	}
						}
						catch (const std::exception&)
						{
							PSendSysMessage(player, u8"召唤玩家 |cffff0000[%s]|h|r 失败", member->GetName());
							sLog->outError("[pzx-exception-call] (%d)-[%s]", player->GetGUIDLow(), player->GetName());
							continue;
						}


					}

					PSendSysMessage(player, u8"召唤玩家 |cff00ff00[%s]|h|r 成功", member->GetName());
				 }
			}

			PSendSysMessage(player, u8"您的队伍已经|cff00ff00集合完毕|h|r");

		}
		break;
		case 102:
			player->CastSpell(player, 22888, true);
			player->CastSpell(player, 16609, true);
			player->CastSpell(player, 24425, true);
			break;
		case 1002://传送达拉然
			player->TeleportTo(571, 5797.87f, 798.383f, 661.952f, 4.59022f);
		case 998://新手接待
				 //player->LearnSpell(33389, false);
			if (player->getLevel() < 80) {
				player->SetLevel(80);
				player->InitTalentForLevel();
			}
			player->AddItem(13335,1);
			player->learnSpell(33389);
			player->SetUInt32Value(PLAYER_XP, 0);
			player->UpdateSkillsToMaxSkillsForLevel();
			addItemSet(player, sPzxConfig->GetIntDefault("initItemSet", 6));//增加T3套装
			break;
		case 999:
			sPzxConfig->Reload();
			break;
		default:
			break;
		}
		player->CLOSE_GOSSIP_MENU();
       // return true;
    }

    // Same as before, but this time the option has a code assigned
    void OnGossipSelectCode(Player* player, Item* item, uint32 sender, uint32 action, const char* code)
    {

		if (action == 1001) {
			/*	if (!player->HasItemCount(sPzxConfig.GetIntDefault("vipItemID", 40003), 1, true)) {
			PSendSysMessage(player, u8"[系统消息]:需要VIP认证卡才可以使用本功能，请联系GM获取");
			player->CLOSE_GOSSIP_MENU();

			return false;
			}*/
			sLog->outString("[pzx] get Input str =%s", code);
			uint32 getItemID;
			try {
				getItemID = std::stoi(code);
				if (getItemID <= 0) {
					PSendSysMessage(player, u8"[系统消息]:请输入正确的物品ID");
					player->CLOSE_GOSSIP_MENU();
					return;
				}
			}
			catch (...) {
				PSendSysMessage(player, u8"[系统消息]:请输入正确的物品ID");
				player->CLOSE_GOSSIP_MENU();
				return;
			}

			ItemTemplateContainer const* its = sObjectMgr->GetItemTemplateStore();
			for (ItemTemplateContainer::const_iterator itr = its->begin(); itr != its->end(); ++itr)
			{
				if (itr->second.ItemId == getItemID)
				{
					if (itr->second.Quality< sPzxConfig->GetIntDefault("item.quality", ITEM_QUALITY_LEGENDARY))
					{
						if (player->HasItemCount(getItemID, 1, true)) {//已经有一件了
							PSendSysMessage(player, u8"[系统消息]:该物品唯一");
						}
						ItemPosCountVec dest;
						InventoryResult msg = player->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, getItemID, 1);
						if (msg == EQUIP_ERR_OK)
						{
							Item* item = player->StoreNewItem(dest, getItemID, true);
							player->SendNewItem(item, 1, true, false);
							PSendSysMessage(player, u8"[系统消息]:%s 已经添加到你包中", item->GetTemplate()->Name1.c_str());
						}
						else
						{
							player->SendEquipError(msg, nullptr, nullptr, getItemID);
							PSendSysMessage(player, u8"[系统消息]:请保持包包有足够空间");
						}
					}
					else {
						PSendSysMessage(player, u8"[系统消息]:获取物品等级过高，请联系GM");
						
					}
					player->CLOSE_GOSSIP_MENU();
					return;
				}

			}

			PSendSysMessage(player, u8"[系统消息]:物品未找到");

		}

		player->CLOSE_GOSSIP_MENU();
		return;
    }
};

void AddSC_item_example()
{
	if (!sPzxConfig->LoadInitial("pzx.conf")) {
		sLog->outError(u8"未找到pzx.conf");
	}
    new item_example();
}