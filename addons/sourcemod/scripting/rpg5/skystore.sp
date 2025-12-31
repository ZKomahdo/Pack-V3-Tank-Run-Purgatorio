public Handle:Sky_Store (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[128];
	Format(text, sizeof(text), "Sky Store\nYou have %d Sky Points", SkyPoints[client]);
	SetPanelTitle(menu, text);
	Format(text, sizeof(text), "Buy Experience");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Buy Items/Abilities");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Buy XP Multiplier - %3.1f minutes, %3.1fx Multiplier (%d cost)", GetConVarFloat(BuyXPMultiplierAmount), GetConVarFloat(BuyXPMultiplier), GetConVarInt(BuyXPMultiplierCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "May stack XP Multiplier time (forever!)");
	DrawPanelText(menu, text);
	if (XPMultiplierTime[client] > 0)
	{
		new seconds = XPMultiplierTime[client];
		new minutes = 0;
		while (seconds >= 60)
		{
			minutes++;
			seconds -= 60;
		}
		Format(text, sizeof(text), "Multiplier Time Remaining: %d min(s), %d sec(s)", minutes, seconds);
		DrawPanelText(menu, text);
	}

	// Hopefully people realize that they would probably want to edit this and make changes accordingly.
	// I mean, I don't personally mind if you don't, but you might.
	Format(text, sizeof(text), "How to buy sky points:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "PayPal to Mikel.toth@gmail.com (include your steam_id)");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "20 SP - 1$\n100 SP + 1month Reserve Slot per 5$");
	DrawPanelText(menu, text);

	return menu;
}

public Sky_Store_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Sky_StoreXPSelect(client), client, Sky_StoreXPSelect_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				SendPanelToClient(Sky_StoreItems(client), client, Sky_StoreItems_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				if (SkyPoints[client] < GetConVarInt(BuyXPMultiplierCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyXPMultiplierCost) - SkyPoints[client]));
					return;
				}
				XPMultiplierTime[client] += RoundToFloor(GetConVarFloat(BuyXPMultiplierAmount) * 60.0);
				if (!XPMultiplierTimer[client])
				{
					XPMultiplierTimer[client] = true;
					CreateTimer(1.0, DeductMultiplierTime, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				}
				SkyPoints[client] -= GetConVarInt(BuyXPMultiplierCost);
				new seconds = XPMultiplierTime[client];
				new minutes = 0;
				while (seconds >= 60)
				{
					minutes++;
					seconds -= 60;
				}
				PrintToChat(client, "%s \x01%d min(s), %d sec(s) remaining of \x04%3.1fx \x01XP Multiplier.", INFO, minutes, seconds, GetConVarFloat(BuyXPMultiplier));
				SaveSkyPoints(client);
			}
			default:
			{
				if (GetClientTeam(client) == 2) SendPanelToClient(Survivor_MainMenu(client), client, Survivor_MainMenu_Init, MENU_TIME_FOREVER);
				else if (GetClientTeam(client) == 3) SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Sky_StoreXPSelect (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[128];
	Format(text, sizeof(text), "Sky Store\nYou have %d Sky Points", SkyPoints[client]);
	SetPanelTitle(menu, text);
	Format(text, sizeof(text), "Buy Survivor Experience");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Buy Infected Experience");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Buy XP in pre-set chunks above");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Buy Survivor Next Level XP");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Buy Infected Next Level XP");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Buy XP needed for the next lv. in a category.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "15% cheaper than pre-set costs, when buying in bulk!");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "\nHow to buy sky points:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "PayPal to Mikel.toth@gmail.com (include your steam_id)");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "20 SP - 1$\n100 SP + 1month Reserve Slot per 5$");
	DrawPanelText(menu, text);

	return menu;
}

public Sky_StoreXPSelect_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Sky_StoreSurvNormXP(client), client, Sky_StoreSurvNormXP_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				SendPanelToClient(Sky_StoreInfeNormXP(client), client, Sky_StoreInfeNormXP_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				SendPanelToClient(Sky_StoreSurvNextXP(client), client, Sky_StoreSurvNextXP_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				SendPanelToClient(Sky_StoreInfeNextXP(client), client, Sky_StoreInfeNextXP_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				if (GetClientTeam(client) == 2) SendPanelToClient(Survivor_MainMenu(client), client, Survivor_MainMenu_Init, MENU_TIME_FOREVER);
				else if (GetClientTeam(client) == 3) SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Sky_StoreSurvNormXP (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[128];
	Format(text, sizeof(text), "Sky Store\nYou have %d Sky Points", SkyPoints[client]);
	SetPanelTitle(menu, text);
	Format(text, sizeof(text), "Pistol (%d XP) (%d Cost)", GetConVarInt(BuyPistolXP), GetConVarInt(BuyPistolXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Melee (%d XP) (%d Cost)", GetConVarInt(BuyMeleeXP), GetConVarInt(BuyMeleeXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Uzi (%d XP) (%d Cost)", GetConVarInt(BuyUziXP), GetConVarInt(BuyUziXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Shotgun (%d XP) (%d Cost)", GetConVarInt(BuyShotgunXP), GetConVarInt(BuyShotgunXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Sniper (%d XP) (%d Cost)", GetConVarInt(BuySniperXP), GetConVarInt(BuySniperXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Rifle (%d XP) (%d Cost)", GetConVarInt(BuyRifleXP), GetConVarInt(BuyRifleXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Grenade (%d XP) (%d Cost)", GetConVarInt(BuyGrenadeXP), GetConVarInt(BuyGrenadeXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Item (%d XP) (%d Cost)", GetConVarInt(BuyItemXP), GetConVarInt(BuyItemXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Physical (%d XP) (%d Cost)", GetConVarInt(BuyPhysicalXP), GetConVarInt(BuyPhysicalXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "How to buy sky points:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "PayPal to Mikel.toth@gmail.com (include your steam_id)");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "20 SP for each 1$\nOR\n100 SP + 1month Reserve Slot for each 5$");
	DrawPanelText(menu, text);

	return menu;
}

public Sky_StoreSurvNormXP_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (SkyPoints[client] < GetConVarInt(BuyPistolXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyPistolXPCost) - SkyPoints[client]));
					return;
				}
				Pi[client][0] += GetConVarInt(BuyPistolXP);
				SkyPoints[client] -= GetConVarInt(BuyPistolXPCost);
				PrintToChat(client, "%s \x01%d Pistol XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyPistolXP));
				SaveSkyPoints(client);
			}
			case 2:
			{
				if (SkyPoints[client] < GetConVarInt(BuyMeleeXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyMeleeXPCost) - SkyPoints[client]));
					return;
				}
				Me[client][0] += GetConVarInt(BuyMeleeXP);
				SkyPoints[client] -= GetConVarInt(BuyMeleeXPCost);
				PrintToChat(client, "%s \x01%d Melee XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyMeleeXP));
				SaveSkyPoints(client);
			}
			case 3:
			{
				if (SkyPoints[client] < GetConVarInt(BuyUziXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyUziXPCost) - SkyPoints[client]));
					return;
				}
				Uz[client][0] += GetConVarInt(BuyUziXP);
				SkyPoints[client] -= GetConVarInt(BuyUziXPCost);
				PrintToChat(client, "%s \x01%d Uzi XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyUziXP));
				SaveSkyPoints(client);
			}
			case 4:
			{
				if (SkyPoints[client] < GetConVarInt(BuyShotgunXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyShotgunXPCost) - SkyPoints[client]));
					return;
				}
				Sh[client][0] += GetConVarInt(BuyShotgunXP);
				SkyPoints[client] -= GetConVarInt(BuyShotgunXPCost);
				PrintToChat(client, "%s \x01%d Shotgun XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyShotgunXP));
				SaveSkyPoints(client);
			}
			case 5:
			{
				if (SkyPoints[client] < GetConVarInt(BuySniperXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuySniperXPCost) - SkyPoints[client]));
					return;
				}
				Sn[client][0] += GetConVarInt(BuySniperXP);
				SkyPoints[client] -= GetConVarInt(BuySniperXPCost);
				PrintToChat(client, "%s \x01%d Sniper XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuySniperXP));
				SaveSkyPoints(client);
			}
			case 6:
			{
				if (SkyPoints[client] < GetConVarInt(BuyRifleXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyRifleXPCost) - SkyPoints[client]));
					return;
				}
				Ri[client][0] += GetConVarInt(BuyRifleXP);
				SkyPoints[client] -= GetConVarInt(BuyRifleXPCost);
				PrintToChat(client, "%s \x01%d Rifle XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyRifleXP));
				SaveSkyPoints(client);
			}
			case 7:
			{
				if (SkyPoints[client] < GetConVarInt(BuyGrenadeXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyGrenadeXPCost) - SkyPoints[client]));
					return;
				}
				Gr[client][0] += GetConVarInt(BuyGrenadeXP);
				SkyPoints[client] -= GetConVarInt(BuyGrenadeXPCost);
				PrintToChat(client, "%s \x01%d Grenade XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyGrenadeXP));
				SaveSkyPoints(client);
			}
			case 8:
			{
				if (SkyPoints[client] < GetConVarInt(BuyItemXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyItemXPCost) - SkyPoints[client]));
					return;
				}
				It[client][0] += GetConVarInt(BuyItemXP);
				SkyPoints[client] -= GetConVarInt(BuyItemXPCost);
				PrintToChat(client, "%s \x01%d Item XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyItemXP));
				SaveSkyPoints(client);
			}
			case 9:
			{
				if (SkyPoints[client] < GetConVarInt(BuyPhysicalXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyPhysicalXPCost) - SkyPoints[client]));
					return;
				}
				Ph[client][0] += GetConVarInt(BuyPhysicalXP);
				SkyPoints[client] -= GetConVarInt(BuyPhysicalXPCost);
				PrintToChat(client, "%s \x01%d Physical XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyPhysicalXP));
				SaveSkyPoints(client);
			}
			default:
			{
				if (GetClientTeam(client) == 2) SendPanelToClient(Survivor_MainMenu(client), client, Survivor_MainMenu_Init, MENU_TIME_FOREVER);
				else if (GetClientTeam(client) == 3) SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

// Infected Store
public Handle:Sky_StoreInfeNormXP (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[128];
	Format(text, sizeof(text), "Sky Store\nYou have %d Sky Points", SkyPoints[client]);
	SetPanelTitle(menu, text);
	Format(text, sizeof(text), "Hunter (%d XP) (%d Cost)", GetConVarInt(BuyHunterXP), GetConVarInt(BuyHunterXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Smoker (%d XP) (%d Cost)", GetConVarInt(BuySmokerXP), GetConVarInt(BuySmokerXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Boomer (%d XP) (%d Cost)", GetConVarInt(BuyBoomerXP), GetConVarInt(BuyBoomerXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Jockey (%d XP) (%d Cost)", GetConVarInt(BuyJockeyXP), GetConVarInt(BuyJockeyXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Charger (%d XP) (%d Cost)", GetConVarInt(BuyChargerXP), GetConVarInt(BuyChargerXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Spitter (%d XP) (%d Cost)", GetConVarInt(BuySpitterXP), GetConVarInt(BuySpitterXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Tank (%d XP) (%d Cost)", GetConVarInt(BuyTankXP), GetConVarInt(BuyTankXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Infected (%d XP) (%d Cost)", GetConVarInt(BuyInfectedXP), GetConVarInt(BuyInfectedXPCost));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "How to buy sky points:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "PayPal to Mikel.toth@gmail.com (include your steam_id)");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "20 SP for each 1$\nOR\n100 SP + 1month Reserve Slot for each 5$");
	DrawPanelText(menu, text);

	return menu;
}

public Sky_StoreInfeNormXP_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (SkyPoints[client] < GetConVarInt(BuyHunterXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyHunterXPCost) - SkyPoints[client]));
					return;
				}
				Hu[client][0] += GetConVarInt(BuyHunterXP);
				SkyPoints[client] -= GetConVarInt(BuyHunterXPCost);
				PrintToChat(client, "%s \x01%d Hunter XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyHunterXP));
				SaveSkyPoints(client);
			}
			case 2:
			{
				if (SkyPoints[client] < GetConVarInt(BuySmokerXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuySmokerXPCost) - SkyPoints[client]));
					return;
				}
				Sm[client][0] += GetConVarInt(BuySmokerXP);
				SkyPoints[client] -= GetConVarInt(BuySmokerXPCost);
				PrintToChat(client, "%s \x01%d Smoker XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuySmokerXP));
				SaveSkyPoints(client);
			}
			case 3:
			{
				if (SkyPoints[client] < GetConVarInt(BuyBoomerXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyBoomerXPCost) - SkyPoints[client]));
					return;
				}
				Bo[client][0] += GetConVarInt(BuyBoomerXP);
				SkyPoints[client] -= GetConVarInt(BuyBoomerXPCost);
				PrintToChat(client, "%s \x01%d Boomer XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyBoomerXP));
				SaveSkyPoints(client);
			}
			case 4:
			{
				if (SkyPoints[client] < GetConVarInt(BuyJockeyXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyJockeyXPCost) - SkyPoints[client]));
					return;
				}
				Jo[client][0] += GetConVarInt(BuyJockeyXP);
				SkyPoints[client] -= GetConVarInt(BuyJockeyXPCost);
				PrintToChat(client, "%s \x01%d Jockey XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyJockeyXP));
				SaveSkyPoints(client);
			}
			case 5:
			{
				if (SkyPoints[client] < GetConVarInt(BuyChargerXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyChargerXPCost) - SkyPoints[client]));
					return;
				}
				Ch[client][0] += GetConVarInt(BuyChargerXP);
				SkyPoints[client] -= GetConVarInt(BuyChargerXPCost);
				PrintToChat(client, "%s \x01%d Charger XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyChargerXP));
				SaveSkyPoints(client);
			}
			case 6:
			{
				if (SkyPoints[client] < GetConVarInt(BuySpitterXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuySpitterXPCost) - SkyPoints[client]));
					return;
				}
				Sp[client][0] += GetConVarInt(BuySpitterXP);
				SkyPoints[client] -= GetConVarInt(BuySpitterXPCost);
				PrintToChat(client, "%s \x01%d Spitter XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuySpitterXP));
				SaveSkyPoints(client);
			}
			case 7:
			{
				if (SkyPoints[client] < GetConVarInt(BuyTankXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyTankXPCost) - SkyPoints[client]));
					return;
				}
				Ta[client][0] += GetConVarInt(BuyTankXP);
				SkyPoints[client] -= GetConVarInt(BuyTankXPCost);
				PrintToChat(client, "%s \x01%d Tank XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyTankXP));
				SaveSkyPoints(client);
			}
			case 8:
			{
				if (SkyPoints[client] < GetConVarInt(BuyInfectedXPCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyInfectedXPCost) - SkyPoints[client]));
					return;
				}
				In[client][0] += GetConVarInt(BuyInfectedXP);
				SkyPoints[client] -= GetConVarInt(BuyInfectedXPCost);
				PrintToChat(client, "%s \x01%d Infected XP awarded to your account!", PURCHASE_INFO, GetConVarInt(BuyInfectedXP));
				SaveSkyPoints(client);
			}
			default:
			{
				if (GetClientTeam(client) == 2) SendPanelToClient(Survivor_MainMenu(client), client, Survivor_MainMenu_Init, MENU_TIME_FOREVER);
				else if (GetClientTeam(client) == 3) SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Sky_StoreItems (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[128];
	Format(text, sizeof(text), "Sky Store\nYou have %d Sky Points", SkyPoints[client]);
	SetPanelTitle(menu, text);
	if (Ul[client][0] == 0) Format(text, sizeof(text), "Unlock Preset 4 (%d Cost)", GetConVarInt(BuyPresetCost));
	else Format(text, sizeof(text), "Preset 4 (Unlocked!)");
	DrawPanelItem(menu, text);
	if (Ul[client][1] == 0) Format(text, sizeof(text), "Unlock Preset 5 (%d Cost)", GetConVarInt(BuyPresetCost));
	else Format(text, sizeof(text), "Preset 5 (Unlocked!)");
	DrawPanelItem(menu, text);
	if (MountedGunsPurchased[client] == 0) Format(text, sizeof(text), "Unlock Mobile Mounted Guns (%d Cost)", GetConVarInt(BuyMountedGunsCost));
	else Format(text, sizeof(text), "Mobile Mounted Guns (Unlocked!)");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Prev Page");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "How to buy sky points:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "PayPal to Mikel.toth@gmail.com (include your steam_id)");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "20 SP for each 1$\nOR\n100 SP + 1month Reserve Slot for each 5$");
	DrawPanelText(menu, text);

	return menu;
}

public Sky_StoreItems_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (SkyPoints[client] < GetConVarInt(BuyPresetCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyPresetCost) - SkyPoints[client]));
					return;
				}
				if (Ul[client][0] == 1)
				{
					PrintToChat(client, "%s \x01We're flattered, but you already own this item.", ERROR_INFO);
					SendPanelToClient(Sky_StoreItems(client), client, Sky_StoreItems_Init, MENU_TIME_FOREVER);
				}
				else
				{
					Ul[client][0] = 1;
					SkyPoints[client] -= GetConVarInt(BuyPresetCost);
					PrintToChat(client, "%s \x01%Preset 4 unlocked for your account!", PURCHASE_INFO);
					SaveSkyPoints(client);
				}
			}
			case 2:
			{
				if (SkyPoints[client] < GetConVarInt(BuyPresetCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyPresetCost) - SkyPoints[client]));
					return;
				}
				if (Ul[client][1] == 1)
				{
					PrintToChat(client, "%s \x01We're flattered, but you already own this item.", ERROR_INFO);
					SendPanelToClient(Sky_StoreItems(client), client, Sky_StoreItems_Init, MENU_TIME_FOREVER);
				}
				else
				{
					Ul[client][1] = 1;
					SkyPoints[client] -= GetConVarInt(BuyPresetCost);
					PrintToChat(client, "%s \x01%Preset 5 unlocked for your account!", PURCHASE_INFO);
					SaveSkyPoints(client);
				}
			}
			case 3:
			{
				if (SkyPoints[client] < GetConVarInt(BuyMountedGunsCost))
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, (GetConVarInt(BuyMountedGunsCost) - SkyPoints[client]));
					return;
				}
				if (MountedGunsPurchased[client] == 1)
				{
					PrintToChat(client, "%s \x01This item is already permanently added to your account!", ERROR_INFO);
					SendPanelToClient(Sky_StoreItems(client), client, Sky_StoreItems_Init, MENU_TIME_FOREVER);
				}
				else
				{
					MountedGunsPurchased[client] = 1;
					SkyPoints[client] -= GetConVarInt(BuyMountedGunsCost);
					PrintToChatAll("%s \x04%N \x01purchased the \x03Mobile Mounted Guns Pack \x01in the \x03Sky Store\x01!", PURCHASE_INFO, client);
					SaveSkyPoints(client);
				}
			}
			case 4:
			{
				SendPanelToClient(Sky_Store(client), client, Sky_Store_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				if (GetClientTeam(client) == 2) SendPanelToClient(Survivor_MainMenu(client), client, Survivor_MainMenu_Init, MENU_TIME_FOREVER);
				else if (GetClientTeam(client) == 3) SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Sky_StoreSurvNextXP (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[128];
	Format(text, sizeof(text), "Sky Store\nYou have %d Sky Points", SkyPoints[client]);
	SetPanelTitle(menu, text);

	NextXPCost[client] = Pi[client][1] - Pi[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyPistolXP)) * GetConVarInt(BuyPistolXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Pi[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Pi[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Pi[client][1] - Pi[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Pistol (%d XP -> Lv.%d) (%d Cost)", Pi[client][1] - Pi[client][0], Pi[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = Me[client][1] - Me[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyMeleeXP)) * GetConVarInt(BuyMeleeXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Me[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Me[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Me[client][1] - Me[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Melee (%d XP -> Lv.%d) (%d Cost)", Me[client][1] - Me[client][0], Me[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = Uz[client][1] - Uz[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyUziXP)) * GetConVarInt(BuyUziXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Uz[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Uz[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Uz[client][1] - Uz[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Uzi (%d XP -> Lv.%d) (%d Cost)", Uz[client][1] - Uz[client][0], Uz[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = Sh[client][1] - Sh[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyShotgunXP)) * GetConVarInt(BuyShotgunXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Sh[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Sh[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Sh[client][1] - Sh[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Shotgun (%d XP -> Lv.%d) (%d Cost)", Sh[client][1] - Sh[client][0], Sh[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = Sn[client][1] - Sn[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuySniperXP)) * GetConVarInt(BuySniperXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Sn[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Sn[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Sn[client][1] - Sn[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Sniper (%d XP -> Lv.%d) (%d Cost)", Sn[client][1] - Sn[client][0], Sn[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = Ri[client][1] - Ri[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyRifleXP)) * GetConVarInt(BuyRifleXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Ri[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Ri[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Ri[client][1] - Ri[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Rifle (%d XP -> Lv.%d) (%d Cost)", Ri[client][1] - Ri[client][0], Ri[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = Gr[client][1] - Gr[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyGrenadeXP)) * GetConVarInt(BuyGrenadeXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Gr[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Gr[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Gr[client][1] - Gr[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Grenade (%d XP -> Lv.%d) (%d Cost)", Gr[client][1] - Gr[client][0], Gr[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = It[client][1] - It[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyItemXP)) * GetConVarInt(BuyItemXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && It[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (It[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (It[client][1] - It[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Item (%d XP -> Lv.%d) (%d Cost)", It[client][1] - It[client][0], It[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = Ph[client][1] - Ph[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyPhysicalXP)) * GetConVarInt(BuyPhysicalXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Ph[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Ph[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Ph[client][1] - Ph[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Physical (%d XP -> Lv.%d) (%d Cost)", Ph[client][1] - Ph[client][0], Ph[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "How to buy sky points:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "PayPal to Mikel.toth@gmail.com (include your steam_id)");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "20 SP for each 1$\nOR\n100 SP + 1month Reserve Slot for each 5$");
	DrawPanelText(menu, text);

	return menu;
}

public Sky_StoreSurvNextXP_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				NextXPCost[client] = Pi[client][1] - Pi[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyPistolXP)) * GetConVarInt(BuyPistolXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Pi[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Pi[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Pi[client][1] - Pi[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Pistol XP awarded to your account!", PURCHASE_INFO, Pi[client][1] - Pi[client][0]);
				Pi[client][0] = Pi[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 2:
			{
				NextXPCost[client] = Me[client][1] - Me[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyMeleeXP)) * GetConVarInt(BuyMeleeXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Me[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Me[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Me[client][1] - Me[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Melee XP awarded to your account!", PURCHASE_INFO, Me[client][1] - Me[client][0]);
				Me[client][0] = Me[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 3:
			{
				NextXPCost[client] = Uz[client][1] - Uz[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyUziXP)) * GetConVarInt(BuyUziXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Uz[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Uz[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Uz[client][1] - Uz[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Uzi XP awarded to your account!", PURCHASE_INFO, Uz[client][1] - Uz[client][0]);
				Uz[client][0] = Uz[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 4:
			{
				NextXPCost[client] = Sh[client][1] - Sh[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyShotgunXP)) * GetConVarInt(BuyShotgunXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Sh[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Sh[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Sh[client][1] - Sh[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Shotgun XP awarded to your account!", PURCHASE_INFO, Sh[client][1] - Sh[client][0]);
				Sh[client][0] = Sh[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 5:
			{
				NextXPCost[client] = Sn[client][1] - Sn[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuySniperXP)) * GetConVarInt(BuySniperXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Sn[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Sn[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Sn[client][1] - Sn[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Sniper XP awarded to your account!", PURCHASE_INFO, Sn[client][1] - Sn[client][0]);
				Sn[client][0] = Sn[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 6:
			{
				NextXPCost[client] = Ri[client][1] - Ri[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyRifleXP)) * GetConVarInt(BuyRifleXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Ri[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Ri[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Ri[client][1] - Ri[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Rifle XP awarded to your account!", PURCHASE_INFO, Ri[client][1] - Ri[client][0]);
				Ri[client][0] = Ri[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 7:
			{
				NextXPCost[client] = Gr[client][1] - Gr[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyGrenadeXP)) * GetConVarInt(BuyGrenadeXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Gr[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Gr[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Gr[client][1] - Gr[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Grenade XP awarded to your account!", PURCHASE_INFO, Gr[client][1] - Gr[client][0]);
				Gr[client][0] = Gr[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 8:
			{
				NextXPCost[client] = It[client][1] - It[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyItemXP)) * GetConVarInt(BuyItemXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && It[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (It[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (It[client][1] - It[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Item XP awarded to your account!", PURCHASE_INFO, It[client][1] - It[client][0]);
				It[client][0] = It[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 9:
			{
				NextXPCost[client] = Ph[client][1] - Ph[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyPhysicalXP)) * GetConVarInt(BuyPhysicalXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Ph[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Ph[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Ph[client][1] - Ph[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Physical XP awarded to your account!", PURCHASE_INFO, Ph[client][1] - Ph[client][0]);
				Ph[client][0] = Ph[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			default:
			{
				if (GetClientTeam(client) == 2) SendPanelToClient(Survivor_MainMenu(client), client, Survivor_MainMenu_Init, MENU_TIME_FOREVER);
				else if (GetClientTeam(client) == 3) SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Sky_StoreInfeNextXP (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[128];
	Format(text, sizeof(text), "Sky Store\nYou have %d Sky Points", SkyPoints[client]);
	SetPanelTitle(menu, text);

	NextXPCost[client] = Hu[client][1] - Hu[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyHunterXP)) * GetConVarInt(BuyHunterXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Hu[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Hu[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Hu[client][1] - Hu[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	Format(text, sizeof(text), "Hunter (%d XP -> Lv.%d) (%d Cost)", Hu[client][1] - Hu[client][0], Hu[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = Sm[client][1] - Sm[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuySmokerXP)) * GetConVarInt(BuySmokerXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Sm[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Sm[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Sm[client][1] - Sm[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	Format(text, sizeof(text), "Smoker (%d XP -> Lv.%d) (%d Cost)", Sm[client][1] - Sm[client][0], Sm[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = Bo[client][1] - Bo[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyBoomerXP)) * GetConVarInt(BuyBoomerXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Bo[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Bo[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Bo[client][1] - Bo[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	Format(text, sizeof(text), "Boomer (%d XP -> Lv.%d) (%d Cost)", Bo[client][1] - Bo[client][0], Bo[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = Jo[client][1] - Jo[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyJockeyXP)) * GetConVarInt(BuyJockeyXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Jo[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Jo[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Jo[client][1] - Jo[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Jockey (%d XP -> Lv.%d) (%d Cost)", Jo[client][1] - Jo[client][0], Jo[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = Ch[client][1] - Ch[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyChargerXP)) * GetConVarInt(BuyChargerXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Ch[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Ch[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Ch[client][1] - Ch[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Charger (%d XP -> Lv.%d) (%d Cost)", Ch[client][1] - Ch[client][0], Ch[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = Sp[client][1] - Sp[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuySpitterXP)) * GetConVarInt(BuySpitterXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Sp[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Sp[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Sp[client][1] - Sp[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Spitter (%d XP -> Lv.%d) (%d Cost)", Sp[client][1] - Sp[client][0], Sp[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = Ta[client][1] - Ta[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyTankXP)) * GetConVarInt(BuyTankXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && Ta[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (Ta[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Ta[client][1] - Ta[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Tank (%d XP -> Lv.%d) (%d Cost)", Ta[client][1] - Ta[client][0], Ta[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	NextXPCost[client] = In[client][1] - In[client][0];
	NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyInfectedXP)) * GetConVarInt(BuyInfectedXPCost);
	NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
	if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

	if (NextXPCost[client] < 1 && In[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
	else if (In[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (In[client][1] - In[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
	
	Format(text, sizeof(text), "Infected (%d XP -> Lv.%d) (%d Cost)", In[client][1] - In[client][0], In[client][2] + 1, NextXPCost[client]);
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "How to buy sky points:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "PayPal to Mikel.toth@gmail.com (include your steam_id)");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "20 SP for each 1$\nOR\n100 SP + 1month Reserve Slot for each 5$");
	DrawPanelText(menu, text);

	return menu;
}

public Sky_StoreInfeNextXP_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				NextXPCost[client] = Hu[client][1] - Hu[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyHunterXP)) * GetConVarInt(BuyHunterXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Hu[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Hu[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Hu[client][1] - Hu[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Hunter XP awarded to your account!", PURCHASE_INFO, Hu[client][1] - Hu[client][0]);
				Hu[client][0] = Hu[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 2:
			{
				NextXPCost[client] = Sm[client][1] - Sm[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuySmokerXP)) * GetConVarInt(BuySmokerXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Sm[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Sm[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Sm[client][1] - Sm[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Smoker XP awarded to your account!", PURCHASE_INFO, Sm[client][1] - Sm[client][0]);
				Sm[client][0] = Sm[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 3:
			{
				NextXPCost[client] = Bo[client][1] - Bo[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyBoomerXP)) * GetConVarInt(BuyBoomerXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Bo[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Bo[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Bo[client][1] - Bo[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Boomer XP awarded to your account!", PURCHASE_INFO, Bo[client][1] - Bo[client][0]);
				Bo[client][0] = Bo[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 4:
			{
				NextXPCost[client] = Jo[client][1] - Jo[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyJockeyXP)) * GetConVarInt(BuyJockeyXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Jo[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Jo[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Jo[client][1] - Jo[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Jockey XP awarded to your account!", PURCHASE_INFO, Jo[client][1] - Jo[client][0]);
				Jo[client][0] = Jo[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 5:
			{
				NextXPCost[client] = Ch[client][1] - Ch[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyChargerXP)) * GetConVarInt(BuyChargerXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Ch[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Ch[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Ch[client][1] - Ch[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Charger XP awarded to your account!", PURCHASE_INFO, Ch[client][1] - Ch[client][0]);
				Ch[client][0] = Ch[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 6:
			{
				NextXPCost[client] = Sp[client][1] - Sp[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuySpitterXP)) * GetConVarInt(BuySpitterXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Sp[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Sp[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Sp[client][1] - Sp[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Spitter XP awarded to your account!", PURCHASE_INFO, Sp[client][1] - Sp[client][0]);
				Sp[client][0] = Sp[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 7:
			{
				NextXPCost[client] = Ta[client][1] - Ta[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyTankXP)) * GetConVarInt(BuyTankXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && Ta[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (Ta[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (Ta[client][1] - Ta[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Tank XP awarded to your account!", PURCHASE_INFO, Ta[client][1] - Ta[client][0]);
				Ta[client][0] = Ta[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			case 8:
			{
				NextXPCost[client] = In[client][1] - In[client][0];
				NextXPCost[client] = (NextXPCost[client] / GetConVarInt(BuyInfectedXP)) * GetConVarInt(BuyInfectedXPCost);
				NextXPCost[client] = RoundToCeil(NextXPCost[client] * GetConVarFloat(BulkXPDiscount));
				if (NextXPCost[client] < GetConVarInt(g_NextXPCostMin)) NextXPCost[client] = GetConVarInt(g_NextXPCostMin);

				if (NextXPCost[client] < 1 && In[client][0] < GetConVarInt(MustExceedXPForFreeUpgrade)) NextXPCost[client] = 1;
				else if (In[client][0] >= GetConVarInt(MustExceedXPForFreeUpgrade) && (In[client][1] - In[client][0]) < GetConVarInt(FreeXPUpgradeRange)) NextXPCost[client] = 0;
				
				if (SkyPoints[client] < NextXPCost[client])
				{
					PrintToChat(client, "%s \x01Not enough Sky Points, you need %d more!", ERROR_INFO, NextXPCost[client]);
					return;
				}
				
				SkyPoints[client] -= NextXPCost[client];
				PrintToChat(client, "%s \x01%d Infected XP awarded to your account!", PURCHASE_INFO, In[client][1] - In[client][0]);
				In[client][0] = In[client][1];
				experience_increase(client, 0);
				SaveSkyPoints(client);
			}
			default:
			{
				if (GetClientTeam(client) == 2) SendPanelToClient(Survivor_MainMenu(client), client, Survivor_MainMenu_Init, MENU_TIME_FOREVER);
				else if (GetClientTeam(client) == 3) SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}