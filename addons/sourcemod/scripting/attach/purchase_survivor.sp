public SurvivorPurchaseFunc(client)
{
	if (PurchaseItem[client] == 0) ItemCost[client] = GetConVarFloat(PSLCost);
	if (PurchaseItem[client] == 1) ItemCost[client] = GetConVarFloat(WACost);
	if (PurchaseItem[client] == 2) ItemCost[client] = GetConVarFloat(PPCost);
	if (PurchaseItem[client] == 3) ItemCost[client] = GetConVarFloat(GRCost);


	if (playerPoints[client][0] < ItemCost[client])
	{
		if (playerPoints[client][0] + teamPoints[0] < ItemCost[client])
		{
			PrintToChat(client, "%s - \x01You do not have the points to make this purchase.", INFO_GENERAL);
			return;
		}
		ItemCost[client] -= playerPoints[client][0];
		playerPoints[client][0] = 0.0;
		teamPoints[0] -= ItemCost[client];
		ItemCost[client] = 0.0;
	}
	else
	{
		playerPoints[client][0] -= ItemCost[client];
		ItemCost[client] = 0.0;
	}

	if (PurchaseItem[client] == 0)
	{
		LastPrimary[client] = ItemName[client];
		ExecCheatCommand(client, "give", ItemName[client]);
		if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has purchased \x05%s.", client, ItemName[client]);
		SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
	}
	if (PurchaseItem[client] == 1)
	{
		if (StrEqual(ItemName[client], "bloat_ammo"))
		{
			bloatAmmo[client] += GetConVarInt(Enhancement_BloatAmmo);
			PrintToChat(client, "%s - \x01%d bloat ammo added to your arsenal. (\x05%d bloat ammo remaining.\x01)", INFO_GENERAL);
		}
		else if (StrEqual(ItemName[client], "blind_ammo"))
		{
			blindAmmo[client] += GetConVarInt(Enhancement_BlindAmmo);
			PrintToChat(client, "%s - \x01%d blind ammo added to your arsenal. (\x05%d blind ammo remaining.\x01)", INFO_GENERAL);
		}
		else if (StrEqual(ItemName[client], "slowmo_ammo"))
		{
			slowmoAmmo[client] += GetConVarInt(Enhancement_SlowmoAmmo);
			PrintToChat(client, "%s - \x01%d slowmo ammo added to your arsenal. (\x05%d slowmo ammo remaining.\x01)", INFO_GENERAL);
		}
		else if (StrEqual(ItemName[client], "beanbag_ammo"))
		{
			beanbagAmmo[client] += GetConVarInt(Enhancement_BeanbagAmmo);
			PrintToChat(client, "%s - \x01%d beanbag ammo added to your arsenal. (\x05%d beanbag ammo remaining.\x01)", INFO_GENERAL);
		}
		else if (StrEqual(ItemName[client], "spatial_ammo"))
		{
			spatialAmmo[client] += GetConVarInt(Enhancement_SpatialAmmo);
			PrintToChat(client, "%s - \x01%d spatial ammo added to your arsenal. (\x05%d spatial ammo remaining.\x01)", INFO_GENERAL);
		}
		if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has purchased \x05%s.", client, ItemName[client]);
		SendPanelToClient(Points_SurvivorMenu(client), client, Points_SurvivorMenu_Init, MENU_TIME_FOREVER);
	}
	if (PurchaseItem[client] == 2)
	{
		if (StrEqual(ItemName[client], "respawn_at_your_corpse"))
		{
			respawnType[client] = 1;
			PrintToChat(client, "%s - \x01You have been placed in the respawn queue for: \x05Respawn At Your Corpse.", INFO_GENERAL);
		}
		else if (StrEqual(ItemName[client], "respawn_at_the_start"))
		{
			respawnType[client] = 2;
			PrintToChat(client, "%s - \x01You have been placed in the respawn queue for: \x05Respawn At The Start Of The Map.", INFO_GENERAL);
		}
		else if (StrEqual(ItemName[client], "incap_protection"))
		{
			incapProtection[client] = GetConVarInt(Ability_IncapProtection);
			PrintToChat(client, "%s - \x01You now have \x05%d Incap Protection Charges.", INFO_GENERAL, GetConVarInt(Ability_IncapProtection));
			if (IsIncapacitated(client)) CreateTimer(1.0, Timer_CheckIfEnsnared, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		else if (StrEqual(ItemName[client], "health"))
		{
			ExecCheatCommand(client, "give", "health");
			PrintToChat(client, "%s - \x01You have purchased \x05Instant Heal.", INFO_GENERAL);
		}
		else if (StrEqual(ItemName[client], "adrenaline"))
		{
			ExecCheatCommand(client, "give", "adrenaline");
			PrintToChat(client, "%s - \x01You have purchased \x05Adrenaline.", INFO_GENERAL);
		}
		else if (StrEqual(ItemName[client], "first_aid_kit"))
		{
			ExecCheatCommand(client, "give", "first_aid_kit");
			PrintToChat(client, "%s - \x01You have purchased \x05Medical Pack.", INFO_GENERAL);
		}
		else if (StrEqual(ItemName[client], "pain_pills"))
		{
			ExecCheatCommand(client, "give", "pain_pills");
			PrintToChat(client, "%s - \x01You have purchased \x05Pain Pills.", INFO_GENERAL);
		}
		if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has purchased \x05%s.", client, ItemName[client]);
		SendPanelToClient(Points_SurvivorMenu(client), client, Points_SurvivorMenu_Init, MENU_TIME_FOREVER);
	}
	if (PurchaseItem[client] == 3)
	{
		ExecCheatCommand(client, "give", ItemName[client]);
		if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has purchased \x05%s.", client, ItemName[client]);
		SendPanelToClient(Points_SurvivorMenu(client), client, Points_SurvivorMenu_Init, MENU_TIME_FOREVER);
	}
}