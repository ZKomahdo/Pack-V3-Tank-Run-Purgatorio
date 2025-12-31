public Handle:Points_SurvivorMenu(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Main Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][0], teamPoints[0]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Weapon Supply Locker");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "WSL are Free!");
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Premium Weapon Supply Locker");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "PSL cost: %3.2f Point(s).", GetConVarFloat(PSLCost));
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Weapon Attachments");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Free Laser, Ammo Extensions cost: %3.2f Point(s).", GetConVarFloat(WACost));
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Personal Purchases");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Respawns, Health-based Purchases, cost: %3.2f Point(s).", GetConVarFloat(PPCost));
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Grenades (Throwables)");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Throwables, cost: %3.2f Point(s).", GetConVarFloat(GRCost));
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Multiplier Information");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Detailed Statistics regarding your point multiplier status.");
	DrawPanelText(menu, text);

	

	return menu;
}

public Points_SurvivorMenu_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				SendPanelToClient(Points_SurvivorPSL(client), client, Points_SurvivorPSL_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				SendPanelToClient(Points_SurvivorWA(client), client, Points_SurvivorWA_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				SendPanelToClient(Points_SurvivorPP(client), client, Points_SurvivorPP_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				SendPanelToClient(Points_SurvivorGR(client), client, Points_SurvivorGR_Init, MENU_TIME_FOREVER);
			}
			case 6:
			{
				SendPanelToClient(Points_SurvivorMS(client), client, Points_SurvivorMS_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_SurvivorWSL(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Weapon Supply Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][0], teamPoints[0]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Pistols");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Melee Weapons");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Sub-Machine Guns");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Shotguns");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Assault Rifles");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Sniper Rifles");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "All weapons in these menus are supplied free of charge.");
	DrawPanelText(menu, text);

	

	return menu;
}

public Points_SurvivorWSL_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Points_Pistols(client), client, Points_Pistols_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				SendPanelToClient(Points_Melee(client), client, Points_Melee_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				SendPanelToClient(Points_SMGs(client), client, Points_SMGs_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				SendPanelToClient(Points_Shotguns(client), client, Points_Shotguns_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				SendPanelToClient(Points_Rifles(client), client, Points_Rifles_Init, MENU_TIME_FOREVER);
			}
			case 6:
			{
				SendPanelToClient(Points_Snipers(client), client, Points_Snipers_Init, MENU_TIME_FOREVER);
			}
			case 7:
			{
				SendPanelToClient(Points_SurvivorMenu(client), client, Points_SurvivorMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_Pistols(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Pistols Supply Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][0], teamPoints[0]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Double Pistols");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Desert Eagle");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	

	return menu;
}

public Points_Pistols_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				LastSecondary[client] = "pistol";
				ExecCheatCommand(client, "give", "pistol");
				ExecCheatCommand(client, "give", "pistol");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Double Pistols.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				LastSecondary[client] = "pistol_magnum";
				ExecCheatCommand(client, "give", "pistol_magnum");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Desert Eagle.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_Melee(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Melee Weapon Supply Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][0], teamPoints[0]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Fire Axe");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Cricket Bat");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Frying Pan");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Electric Guitar");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Golf Club");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Tonfa");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Machete");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Katana");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	

	return menu;
}

public Points_Melee_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				LastSecondary[client] = "fireaxe";
				ExecCheatCommand(client, "give", "fireaxe");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Fire Axe.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				LastSecondary[client] = "cricket_bat";
				ExecCheatCommand(client, "give", "cricket_bat");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Cricket Bat.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				LastSecondary[client] = "frying_pan";
				ExecCheatCommand(client, "give", "frying_pan");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Frying Pan.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				LastSecondary[client] = "electric_guitar";
				ExecCheatCommand(client, "give", "electric_guitar");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Electric Guitar.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				LastSecondary[client] = "golfclub";
				ExecCheatCommand(client, "give", "golfclub");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Golf Club.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 6:
			{
				LastSecondary[client] = "tonfa";
				ExecCheatCommand(client, "give", "tonfa");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Tonfa.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 7:
			{
				LastSecondary[client] = "machete";
				ExecCheatCommand(client, "give", "machete");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Machete.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 8:
			{
				LastSecondary[client] = "katana";
				ExecCheatCommand(client, "give", "katana");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Katana.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 9:
			{
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_SMGs(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - SMGs Supply Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][0], teamPoints[0]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "MP-5");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Mac-10");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "TMP-Silenced");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	

	return menu;
}

public Points_SMGs_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				LastPrimary[client] = "smg_mp5";
				ExecCheatCommand(client, "give", "smg_mp5");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05MP-5.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				LastPrimary[client] = "smg";
				ExecCheatCommand(client, "give", "smg");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Mac-10.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				LastPrimary[client] = "smg_silenced";
				ExecCheatCommand(client, "give", "smg_silenced");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05TMP-Silenced.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_Shotguns(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Shotguns Supply Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][0], teamPoints[0]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Pump Shotgun");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "L4D1 Autoshotgun");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "L4D2 Autoshotgun");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	

	return menu;
}

public Points_Shotguns_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				LastPrimary[client] = "pumpshotgun";
				ExecCheatCommand(client, "give", "pumpshotgun");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Pump Shotgun.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				LastPrimary[client] = "autoshotgun";
				ExecCheatCommand(client, "give", "autoshotgun");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05L4D1 Autoshotgun (Silver).", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				LastPrimary[client] = "shotgun_spas";
				ExecCheatCommand(client, "give", "shotgun_spas");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05L4D2 Autoshotgun (SPAS).", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_Rifles(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Rifles Supply Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][0], teamPoints[0]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Desert Rifle");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "M-16");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "SG-552");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	

	return menu;
}

public Points_Rifles_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				LastPrimary[client] = "rifle_desert";
				ExecCheatCommand(client, "give", "rifle_desert");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Desert Rifle.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				LastPrimary[client] = "rifle";
				ExecCheatCommand(client, "give", "rifle");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05M-16.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				LastPrimary[client] = "rifle_sg552";
				ExecCheatCommand(client, "give", "rifle_sg552");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05SG-552.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_Snipers(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Sniper Rifles Supply Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][0], teamPoints[0]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Scout Sniper");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "AWP Sniper");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Hunting Rifle");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Military Sniper");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	

	return menu;
}

public Points_Snipers_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				LastPrimary[client] = "sniper_scout";
				ExecCheatCommand(client, "give", "sniper_scout");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Scout Sniper Rifle.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				LastPrimary[client] = "sniper_awp";
				ExecCheatCommand(client, "give", "sniper_awp");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05AWP Sniper Rifle.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				LastPrimary[client] = "hunting_rifle";
				ExecCheatCommand(client, "give", "hunting_rifle");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Hunting Rifle.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				LastPrimary[client] = "sniper_military";
				ExecCheatCommand(client, "give", "sniper_military");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Military Sniper.", client);
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_SurvivorPSL(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Premium Weapons Supply Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][0], teamPoints[0]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "AK-47");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "M-60");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Grenade Launcher");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Chainsaw");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Premium Weapons Cost: %3.2f Point(s).", GetConVarFloat(PSLCost));
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	

	return menu;
}

public Points_SurvivorPSL_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				ItemName[client] = "rifle_ak47";
				PurchaseItem[client] = 0;
				SurvivorPurchaseFunc(client);
			}
			case 2:
			{
				ItemName[client] = "rifle_m60";
				PurchaseItem[client] = 0;
				SurvivorPurchaseFunc(client);
			}
			case 3:
			{
				ItemName[client] = "grenade_launcher";
				PurchaseItem[client] = 0;
				SurvivorPurchaseFunc(client);
			}
			case 4:
			{
				ItemName[client] = "chainsaw";
				PurchaseItem[client] = 0;
				SurvivorPurchaseFunc(client);
			}
			case 5:
			{
				SendPanelToClient(Points_SurvivorWSL(client), client, Points_SurvivorWSL_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_SurvivorWA(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Weapon Attachments Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][0], teamPoints[0]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Laser Sight (Free)");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Bloat Ammo (%d Charges, %d Remaining)", GetConVarInt(Enhancement_BloatAmmo), bloatAmmo[client]);
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Blind Ammo (%d Charges, %d Remaining)", GetConVarInt(Enhancement_BlindAmmo), blindAmmo[client]);
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Slowmo Ammo (%d Charges, %d Remaining)", GetConVarInt(Enhancement_SlowmoAmmo), slowmoAmmo[client]);
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Bean-Bag Ammo (%d Charges, %d Remaining)", GetConVarInt(Enhancement_BeanbagAmmo), beanbagAmmo[client]);
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Spatial Ammo (%d Charges, %d Remaining)", GetConVarInt(Enhancement_SpatialAmmo), spatialAmmo[client]);
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Weapon Enhancement Cost: %3.2f Point(s).", GetConVarFloat(WACost));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Enhancements can be stacked/apply to all weapons.");
	DrawPanelText(menu, text);

	

	return menu;
}

public Points_SurvivorWA_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				ExecCheatCommand(client, "upgrade_add", "LASER_SIGHT");
				if (GetConVarInt(PurchaseNotice) == 1) PrintToSurvivors("\x03%N \x01has equipped \x05Laser Sight Upgrade.", client);
				SendPanelToClient(Points_SurvivorMenu(client), client, Points_SurvivorMenu_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				ItemName[client] = "bloat_ammo";
				PurchaseItem[client] = 1;
				SurvivorPurchaseFunc(client);
			}
			case 3:
			{
				ItemName[client] = "blind_ammo";
				PurchaseItem[client] = 1;
				SurvivorPurchaseFunc(client);
			}
			case 4:
			{
				ItemName[client] = "slowmo_ammo";
				PurchaseItem[client] = 1;
				SurvivorPurchaseFunc(client);
			}
			case 5:
			{
				ItemName[client] = "beanbag_ammo";
				PurchaseItem[client] = 1;
				SurvivorPurchaseFunc(client);
			}
			case 6:
			{
				ItemName[client] = "spatial_ammo";
				PurchaseItem[client] = 1;
				SurvivorPurchaseFunc(client);
			}
			case 7:
			{
				SendPanelToClient(Points_SurvivorMenu(client), client, Points_SurvivorMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_SurvivorPP(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Personal Purchases Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][0], teamPoints[0]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Respawn at your Corpse");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Respawn at the Start");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Incap Protection (%d Charges)", GetConVarInt(Ability_IncapProtection));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Instant Heal");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Adrenaline (Effect: %3.2fx Damage Increase for %3.2f sec(s).)", GetConVarFloat(Ability_AdrenalineUse), GetConVarFloat(Ability_AdrenalineTime));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Med Pack (Effect: %3.2f Health HOT for %3.2f sec(s).)", GetConVarFloat(Ability_HOTAmount), GetConVarFloat(Ability_HOTTime));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Phil's Pills (Effect: %3.2fx Damage Reduction for %3.2f sec(s).)", GetConVarFloat(Ability_PillsUse), GetConVarFloat(Ability_PillsTime));
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Personal Purchases Cost: %3.2f Point(s).", GetConVarFloat(PPCost));
	DrawPanelText(menu, text);

	

	return menu;
}

public Points_SurvivorPP_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (IsPlayerAlive(client))
				{
					PrintToChat(client, "%s - \x01You cannot purchase a respawn until you actually die.", INFO_GENERAL);
					return;
				}
				if (permaDeath[client])
				{
					PrintToChat(client, "%s - \x01You died of an overdose and cannot respawn this round.", INFO_GENERAL);
					return;
				}
				if (rescueVehicleHasArrived)
				{
					PrintToChat(client, "%s - \x01respawns are disabled.", INFO_GENERAL);
					return;
				}
				if (respawnType[client] != 0 && locationSaved[client])
				{
					respawnType[client] = 1;
					PrintToChat(client, "%s - \x01You have changed your respawn type to: \x05Respawn at your Corpse.", INFO_GENERAL);
					return;
				}
				ItemName[client] = "respawn_at_your_corpse";
				PurchaseItem[client] = 2;
				SurvivorPurchaseFunc(client);
			}
			case 2:
			{
				if (IsPlayerAlive(client))
				{
					PrintToChat(client, "%s - \x01You cannot purchase a respawn until you actually die.", INFO_GENERAL);
					return;
				}
				if (permaDeath[client])
				{
					PrintToChat(client, "%s - \x01You died of an overdose and cannot respawn this round.", INFO_GENERAL);
					return;
				}
				if (!locationSaved[client])
				{
					PrintToChat(client, "%s - \x01Strange... There are no records of your death.", INFO_GENERAL);
					return;
				}
				if (rescueVehicleHasArrived)
				{
					PrintToChat(client, "%s - \x01respawns are disabled.", INFO_GENERAL);
					return;
				}
				if (respawnType[client] != 0)
				{
					respawnType[client] = 2;
					PrintToChat(client, "%s - \x01You have changed your respawn type to: \x05Respawn at the Start.", INFO_GENERAL);
					return;
				}
				ItemName[client] = "respawn_at_the_start";
				PurchaseItem[client] = 2;
				SurvivorPurchaseFunc(client);
			}
			case 3:
			{
				if (!IsPlayerAlive(client))
				{
					PrintToChat(client, "%s - \x01You are not currently alive. Try respawning, first.", INFO_GENERAL);
					return;
				}
				if (incapProtection[client] > 0)
				{
					PrintToChat(client, "%s - \x01You currently have this ability (\x05%d charges remaining.\x01)", INFO_GENERAL, incapProtection[client]);
					return;
				}
				ItemName[client] = "incap_protection";
				PurchaseItem[client] = 2;
				SurvivorPurchaseFunc(client);
			}
			case 4:
			{
				if (!IsPlayerAlive(client))
				{
					PrintToChat(client, "%s - \x01You are not currently alive. Try respawning, first.", INFO_GENERAL);
					return;
				}
				ItemName[client] = "health";
				PurchaseItem[client] = 2;
				SurvivorPurchaseFunc(client);
			}
			case 5:
			{
				ItemName[client] = "adrenaline";
				PurchaseItem[client] = 2;
				SurvivorPurchaseFunc(client);
			}
			case 6:
			{
				ItemName[client] = "first_aid_kit";
				PurchaseItem[client] = 2;
				SurvivorPurchaseFunc(client);
			}
			case 7:
			{
				ItemName[client] = "pain_pills";
				PurchaseItem[client] = 2;
				SurvivorPurchaseFunc(client);
			}
			case 8:
			{
				SendPanelToClient(Points_SurvivorMenu(client), client, Points_SurvivorMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_SurvivorGR(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Grenade (Throwable) Purchases Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][0], teamPoints[0]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Molotov Cocktail");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Bile Bomb");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Pipe Bomb");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Grenade (Throwable) Purchases Cost: %3.2f Point(s).", GetConVarFloat(GRCost));
	DrawPanelText(menu, text);


	return menu;
}

public Points_SurvivorGR_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				ItemName[client] = "molotov";
				PurchaseItem[client] = 3;
				SurvivorPurchaseFunc(client);
			}
			case 2:
			{
				ItemName[client] = "vomitjar";
				PurchaseItem[client] = 3;
				SurvivorPurchaseFunc(client);
			}
			case 3:
			{
				ItemName[client] = "pipe_bomb";
				PurchaseItem[client] = 3;
				SurvivorPurchaseFunc(client);
			}
			case 4:
			{
				SendPanelToClient(Points_SurvivorMenu(client), client, Points_SurvivorMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_SurvivorMS(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Multiplier Status Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][0], teamPoints[0]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Commons Goal           : %d out of %d", survivorCommon[client], survivorCommonGoal[client]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Team Commons Goal  : %d out of %d", survivorTeamCommon, survivorTeamCommonGoal);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Special Goal              : %d out of %d", survivorSpecial[client], survivorSpecialGoal[client]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Team Special Goal     : %d out of %d", survivorTeamSpecial, survivorTeamSpecialGoal);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Headshot Goal           : %d out of %d", survivorHeadshot[client], survivorHeadshotGoal[client]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Team Headshot Goal  : %d out of %d", survivorTeamHeadshot, survivorTeamHeadshotGoal);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Multiplier                   : %3.2f of %3.2f Max.", survivorMultiplier[client], GetConVarFloat(Multiplier_Maximum));
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	

	return menu;
}

public Points_SurvivorMS_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Points_SurvivorMenu(client), client, Points_SurvivorMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}