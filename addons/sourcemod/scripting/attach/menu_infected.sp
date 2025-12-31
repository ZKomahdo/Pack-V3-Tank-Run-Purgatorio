public Handle:Points_InfectedMenu(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Main Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][1], teamPoints[1]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Class Change");
	DrawPanelItem(menu, text);
	if (IsPlayerGhost(client)) Format(text, sizeof(text), "Change your special infected (ex. Tanks) for free!");
	else Format(text, sizeof(text), "Change your special infected, cost: %3.2f Point(s).", GetConVarFloat(SICost));
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Summon Zombies");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Uncommon Drops, Panic Events, etc., cost: %3.2f Point(s).", GetConVarFloat(SZCost));
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Team Upgrades");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Round-long, Team-enhancing upgrades, cost: %3.2f Point(s).", GetConVarFloat(ITUCost));
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "End it... End it all.");
	DrawPanelItem(menu, text);
	

	return menu;
}

public Points_InfectedMenu_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Points_InfectedCC(client), client, Points_InfectedCC_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				SendPanelToClient(Points_InfectedSZ(client), client, Points_InfectedSZ_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				SendPanelToClient(Points_InfectedTU(client), client, Points_InfectedTU_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				if (GetClientTeam(client) != 3 || IsPlayerGhost(client)) return;
				new Class = GetEntProp(client, Prop_Send, "m_zombieClass");
				if (Class != ZOMBIECLASS_TANK) ForcePlayerSuicide(client);
			}
		}
	}
}

public Handle:Points_InfectedCC(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Class Change Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][1], teamPoints[1]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Hunter");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Smoker");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Boomer");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Jockey");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Charger");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Spitter");
	DrawPanelItem(menu, text);
	if (!IsPlayerGhost(client) && !tankRestriction)
	{
		Format(text, sizeof(text), "Tank");
		DrawPanelItem(menu, text);
	}

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	if (IsPlayerGhost(client)) Format(text, sizeof(text), "You're in Ghost Mode, Class changes are Free.");
	else Format(text, sizeof(text), "Buy a Class Change, cost: %3.2f Point(s).", GetConVarFloat(SICost));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Buy a Tank, cost: %3.2f Point(s).", GetConVarFloat(SITCost));
	DrawPanelText(menu, text);
	if (tankRestriction)
	{
		Format(text, sizeof(text), "Tank restricted for %3.2f sec(s).", GetConVarFloat(Amount_TankRestriction) - tankRestrictionTime);
		DrawPanelText(menu, text);
	}
	
	return menu;
}

public Points_InfectedCC_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (classCharger[client] && IsPlayerAlive(client)) return;
				if (!IsPlayerAlive(client) || (classHunter[client] && !IsPlayerGhost(client))) return;
				ItemName[client] = "Hunter";
				PurchaseItem[client] = 0;
				InfectedPurchaseFunc(client);
			}
			case 2:
			{
				if (classCharger[client] && IsPlayerAlive(client)) return;
				if (!IsPlayerAlive(client) || (classSmoker[client] && !IsPlayerGhost(client))) return;
				ItemName[client] = "Smoker";
				PurchaseItem[client] = 0;
				InfectedPurchaseFunc(client);
			}
			case 3:
			{
				if (classCharger[client] && IsPlayerAlive(client)) return;
				if (!IsPlayerAlive(client) || (classBoomer[client] && !IsPlayerGhost(client))) return;
				ItemName[client] = "Boomer";
				PurchaseItem[client] = 0;
				InfectedPurchaseFunc(client);
			}
			case 4:
			{
				if (classCharger[client] && IsPlayerAlive(client)) return;
				if (!IsPlayerAlive(client) || (classJockey[client] && !IsPlayerGhost(client))) return;
				ItemName[client] = "Jockey";
				PurchaseItem[client] = 0;
				InfectedPurchaseFunc(client);
			}
			case 5:
			{
				if (classCharger[client] && IsPlayerAlive(client)) return;
				if (!IsPlayerAlive(client) || (classCharger[client] && !IsPlayerGhost(client))) return;
				ItemName[client] = "Charger";
				PurchaseItem[client] = 0;
				InfectedPurchaseFunc(client);
			}
			case 6:
			{
				if (classCharger[client] && IsPlayerAlive(client)) return;
				if (!IsPlayerAlive(client) || (classSpitter[client] && !IsPlayerGhost(client))) return;
				ItemName[client] = "Spitter";
				PurchaseItem[client] = 0;
				InfectedPurchaseFunc(client);
			}
			case 7:
			{
				if (classTank[client]) return;
				if (IsPlayerGhost(client) || tankRestriction) SendPanelToClient(Points_InfectedMenu(client), client, Points_InfectedMenu_Init, MENU_TIME_FOREVER);
				else
				{
					if (classCharger[client] && IsPlayerAlive(client)) return;
					if (!IsPlayerAlive(client)) return;
					if (tankCount >= tankLimit)
					{
						PrintToChat(client, "%s - \x01The amount of active tanks \x05is currently reached.", INFO_GENERAL);
						return;
					}
					ItemName[client] = "Tank";
					PurchaseItem[client] = 1;
					InfectedPurchaseFunc(client);
				}
			}
			case 8:
			{
				if (!IsPlayerGhost(client)) SendPanelToClient(Points_InfectedMenu(client), client, Points_InfectedMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_InfectedSZ(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Summon Zombies Menu");
	new String:text[128];


	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][1], teamPoints[1]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Common Infected Drop");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Brown Plop Drop");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Jimmy (Rage) Drop");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Riot (Blue) Drop");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Road Krew Drop");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Uncommon Panic Event");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Witch Drop %d out of %d", witchCount, witchLimit);
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Summon Zombies, cost: %3.2f Point(s).", GetConVarFloat(SZCost));
	DrawPanelText(menu, text);
	if (summonZombieCooldown > 0.0)
	{
		Format(text, sizeof(text), "Time until you can summon zombies: %3.2f sec(s).", summonZombieCooldown);
		DrawPanelText(menu, text);
	}
	if (uncommonRemaining > 0)
	{
		Format(text, sizeof(text), "Uncommons Remaining: %d", uncommonRemaining);
		DrawPanelText(menu, text);
	}

	
	return menu;
}

public Points_InfectedSZ_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (summonZombieCooldown > 0.0 || uncommonRemaining > 0) return;
				ItemName[client] = "common_drop";
				PurchaseItem[client] = 2;
				InfectedPurchaseFunc(client);
			}
			case 2:
			{
				if (summonZombieCooldown > 0.0 || uncommonRemaining > 0) return;
				ItemName[client] = "brown_plop_drop";
				PurchaseItem[client] = 2;
				InfectedPurchaseFunc(client);
			}
			case 3:
			{
				if (summonZombieCooldown > 0.0 || uncommonRemaining > 0) return;
				ItemName[client] = "jimmy_rage_drop";
				PurchaseItem[client] = 2;
				InfectedPurchaseFunc(client);
			}
			case 4:
			{
				if (summonZombieCooldown > 0.0 || uncommonRemaining > 0) return;
				ItemName[client] = "riot_blue_drop";
				PurchaseItem[client] = 2;
				InfectedPurchaseFunc(client);
			}
			case 5:
			{
				if (summonZombieCooldown > 0.0 || uncommonRemaining > 0) return;
				ItemName[client] = "road_krew_drop";
				PurchaseItem[client] = 2;
				InfectedPurchaseFunc(client);
			}
			case 6:
			{
				if (summonZombieCooldown > 0.0 || uncommonRemaining > 0) return;
				ItemName[client] = "uncommon_panic_event";
				PurchaseItem[client] = 2;
				InfectedPurchaseFunc(client);
			}
			case 7:
			{
				if (summonZombieCooldown > 0.0 || witchCount >= witchLimit) return;
				ItemName[client] = "witch_drop";
				PurchaseItem[client] = 2;
				InfectedPurchaseFunc(client);
			}
			case 8:
			{
				SendPanelToClient(Points_InfectedMenu(client), client, Points_InfectedMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_InfectedTU(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Team Upgrades Menu");
	new String:text[128];

	new String:Pct[16];
	Format(Pct, sizeof(Pct), "%");

	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][1], teamPoints[1]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Tank Limit %d out of %d Maximum", tankLimit, GetConVarInt(Limit_TankAmount));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Tank Speed %3.2f%s ups of %3.2f%s ups Maximum", tankUPS * 100.0, Pct, GetConVarFloat(Limit_TankSpeed) * 100.0, Pct);
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Tank Health %d out of %d Maximum", tankHealth, GetConVarInt(Limit_TankHealth));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Witch Limit %d out of %d Maximum", witchLimit, GetConVarInt(Limit_WitchAmount));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Witch Speed %d ups of %d ups Maximum", witchUPS, GetConVarInt(Limit_WitchSpeed));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "SI Health %d out of %d Maximum", SIHealth, GetConVarInt(Limit_SIHealth));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Deep Freeze %d%s out of %d%s Maximum", deepFreezeAmount, Pct, GetConVarInt(Limit_DeepFreeze), Pct);
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Next Page");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Team Upgrades, last until round end, cost: %3.2f Point(s).", GetConVarFloat(ITUCost));
	DrawPanelText(menu, text);

	
	return menu;
}

public Points_InfectedTU_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (tankLimit >= GetConVarInt(Limit_TankAmount))
				{
					SendPanelToClient(Points_InfectedTU(client), client, Points_InfectedTU_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_tank_limit";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 2:
			{
				if (tankUPS >= GetConVarFloat(Limit_TankSpeed))
				{
					SendPanelToClient(Points_InfectedTU(client), client, Points_InfectedTU_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_tank_speed";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 3:
			{
				if (tankHealth >= GetConVarInt(Limit_TankHealth))
				{
					SendPanelToClient(Points_InfectedTU(client), client, Points_InfectedTU_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_tank_health";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 4:
			{
				if (witchLimit >= GetConVarInt(Limit_WitchAmount))
				{
					SendPanelToClient(Points_InfectedTU(client), client, Points_InfectedTU_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_witch_limit";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 5:
			{
				if (witchUPS >= GetConVarInt(Limit_WitchSpeed))
				{
					SendPanelToClient(Points_InfectedTU(client), client, Points_InfectedTU_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_witch_speed";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 6:
			{
				if (SIHealth >= GetConVarInt(Limit_SIHealth))
				{
					SendPanelToClient(Points_InfectedTU(client), client, Points_InfectedTU_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_si_health";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 7:
			{
				if (deepFreezeAmount >= GetConVarInt(Limit_DeepFreeze))
				{
					SendPanelToClient(Points_InfectedTU(client), client, Points_InfectedTU_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_deep_freeze";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 8:
			{
				SendPanelToClient(Points_InfectedMenu(client), client, Points_InfectedMenu_Init, MENU_TIME_FOREVER);
			}
			case 9:
			{
				SendPanelToClient(Points_InfectedTU2(client), client, Points_InfectedTU2_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_InfectedTU2(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Team Upgrades Menu");
	new String:text[128];

	new String:Pct[16];
	Format(Pct, sizeof(Pct), "%");

	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][1], teamPoints[1]);
	DrawPanelText(menu, text);


	Format(text, sizeof(text), "Spawn Timers %d out of %d sec(s) Minimum", spawnTimer, GetConVarInt(Limit_SpawnTimer));
	DrawPanelItem(menu, text);
	if (bChargerJump) Format(text, sizeof(text), "Charger - Jump Ability (Purchased)");
	else Format(text, sizeof(text), "Charger - Jump Ability");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Charge Speed %3.2f%s out of %3.2f%s Maximum", chargeSpeed * 100.0, Pct, GetConVarFloat(Limit_ChargeSpeed) * 100.0, Pct);
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Charge Volley %d%s out of %d%s Maximum", chargeVolley, Pct, GetConVarInt(Limit_ChargeVolley), Pct);
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Spit Invis-Protection %3.2f out of %3.2f sec(s) Maximum", spitProtectionTime, GetConVarFloat(Limit_SpitProtectionTime));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Slowing Spit %3.2f out of %3.2f sec(s) Maximum", spitSlowTime, GetConVarFloat(Limit_SpitSlowTime));
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Slowing Spit Amount %3.2f out of %3.2f Minimum", spitSlowAmount, GetConVarFloat(Limit_SpitSlowAmount));
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Next Page");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Team Upgrades, last until round end, cost: %3.2f Point(s).", GetConVarFloat(ITUCost));
	DrawPanelText(menu, text);

	
	return menu;
}

public Points_InfectedTU2_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (spawnTimer <= GetConVarInt(Limit_SpawnTimer))
				{
					SendPanelToClient(Points_InfectedTU2(client), client, Points_InfectedTU2_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_spawn_timer";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 2:
			{
				if (bChargerJump)
				{
					SendPanelToClient(Points_InfectedTU2(client), client, Points_InfectedTU2_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_charge_jump";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 3:
			{
				if (chargeSpeed >= GetConVarFloat(Limit_ChargeSpeed))
				{
					SendPanelToClient(Points_InfectedTU2(client), client, Points_InfectedTU2_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_charge_speed";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 4:
			{
				if (chargeVolley >= GetConVarInt(Limit_ChargeVolley))
				{
					SendPanelToClient(Points_InfectedTU2(client), client, Points_InfectedTU2_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_charge_volley";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 5:
			{
				if (spitProtectionTime >= GetConVarFloat(Limit_SpitProtectionTime))
				{
					SendPanelToClient(Points_InfectedTU2(client), client, Points_InfectedTU2_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_spit_protection";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 6:
			{
				if (spitSlowTime >= GetConVarFloat(Limit_SpitSlowTime))
				{
					SendPanelToClient(Points_InfectedTU2(client), client, Points_InfectedTU2_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_spit_slow_time";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 7:
			{
				if (spitSlowAmount <= GetConVarFloat(Limit_SpitSlowAmount))
				{
					SendPanelToClient(Points_InfectedTU2(client), client, Points_InfectedTU2_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_spit_slow_amount";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 8:
			{
				SendPanelToClient(Points_InfectedTU(client), client, Points_InfectedTU_Init, MENU_TIME_FOREVER);
			}
			case 9:
			{
				SendPanelToClient(Points_InfectedTU3(client), client, Points_InfectedTU3_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_InfectedTU3(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Team Upgrades Menu");
	new String:text[128];

	new String:Pct[16];
	Format(Pct, sizeof(Pct), "%");

	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][1], teamPoints[1]);
	DrawPanelText(menu, text);


	if (bJockeyJump) Format(text, sizeof(text), "Jockey Jump (Purchased)");
	else Format(text, sizeof(text), "Jockey Jump");
	DrawPanelItem(menu, text);
	if (bJockeyBerserk) Format(text, sizeof(text), "Jockey Incap-Kill (Purchased)");
	else Format(text, sizeof(text), "Jockey Incap-Kill");
	DrawPanelItem(menu, text);
	if (bJockeyBlind) Format(text, sizeof(text), "Jockey Blind-Ride (Purchased)");
	else Format(text, sizeof(text), "Jockey Blind-Ride");
	DrawPanelItem(menu, text);
	if (bJockeyControl) Format(text, sizeof(text), "Jockey Ride-Control (Purchased)");
	else Format(text, sizeof(text), "Jockey Ride-Control");
	DrawPanelItem(menu, text);
	if (bBlindingBile) Format(text, sizeof(text), "Blinding Bile (Purchased)");
	else Format(text, sizeof(text), "Blinding Bile");
	DrawPanelItem(menu, text);
	if (bUnstableBoomer) Format(text, sizeof(text), "Unstable Boomer (Purchased)");
	else Format(text, sizeof(text), "Unstable Boomer");
	DrawPanelItem(menu, text);
	if (bSlowingBile) Format(text, sizeof(text), "Slowing Bile (Purchased)");
	else Format(text, sizeof(text), "Slowing Bile");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Next Page");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Team Upgrades, last until round end, cost: %3.2f Point(s).", GetConVarFloat(ITUCost));
	DrawPanelText(menu, text);

	
	return menu;
}

public Points_InfectedTU3_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (bJockeyJump)
				{
					SendPanelToClient(Points_InfectedTU3(client), client, Points_InfectedTU3_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_jockey_jump";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 2:
			{
				if (bJockeyBerserk)
				{
					SendPanelToClient(Points_InfectedTU3(client), client, Points_InfectedTU3_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_jockey_kill";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 3:
			{
				if (bJockeyBlind)
				{
					SendPanelToClient(Points_InfectedTU3(client), client, Points_InfectedTU3_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_jockey_ride";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 4:
			{
				if (bJockeyControl)
				{
					SendPanelToClient(Points_InfectedTU3(client), client, Points_InfectedTU3_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_jockey_control";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 5:
			{
				if (bBlindingBile)
				{
					SendPanelToClient(Points_InfectedTU3(client), client, Points_InfectedTU3_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_blinding_bile";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 6:
			{
				if (bUnstableBoomer)
				{
					SendPanelToClient(Points_InfectedTU3(client), client, Points_InfectedTU3_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_unstable_boomer";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 7:
			{
				if (bSlowingBile)
				{
					SendPanelToClient(Points_InfectedTU3(client), client, Points_InfectedTU3_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_slowing_bile";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 8:
			{
				SendPanelToClient(Points_InfectedTU2(client), client, Points_InfectedTU2_Init, MENU_TIME_FOREVER);
			}
			case 9:
			{
				SendPanelToClient(Points_InfectedTU4(client), client, Points_InfectedTU4_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_InfectedTU4(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Team Upgrades Menu");
	new String:text[128];

	new String:Pct[16];
	Format(Pct, sizeof(Pct), "%");

	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][1], teamPoints[1]);
	DrawPanelText(menu, text);


	if (bSteelTongue) Format(text, sizeof(text), "Steel Tongue (Purchased)");
	else Format(text, sizeof(text), "Steel Tongue");
	DrawPanelItem(menu, text);
	if (bSmokerWhip) Format(text, sizeof(text), "Smoker Whip (Purchased)");
	else Format(text, sizeof(text), "Smoker Whip");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Tongue Range %d ups out of %d ups Maximum", tongueRange, GetConVarInt(Limit_TongueRange));
	DrawPanelItem(menu, text);
	if (bNoSurvivorGlow) Format(text, sizeof(text), "No Survivor Glow (Purchased)");
	else Format(text, sizeof(text), "No Survivor Glow");
	DrawPanelItem(menu, text);
	if (bWitchStrength) Format(text, sizeof(text), "Instant Kill Witch (Purchased)");
	else Format(text, sizeof(text), "Instant Kill Witch");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "More Commons %d out of %d Maximum", commonLimit, GetConVarInt(Limit_CommonLimit));
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Next Page");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Team Upgrades, last until round end, cost: %3.2f Point(s).", GetConVarFloat(ITUCost));
	DrawPanelText(menu, text);

	
	return menu;
}

public Points_InfectedTU4_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (bSteelTongue)
				{
					SendPanelToClient(Points_InfectedTU4(client), client, Points_InfectedTU4_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_steel_tongue";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 2:
			{
				if (bSmokerWhip)
				{
					SendPanelToClient(Points_InfectedTU4(client), client, Points_InfectedTU4_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_smoker_whip";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 3:
			{
				if (tongueRange >= GetConVarInt(Limit_TongueRange))
				{
					SendPanelToClient(Points_InfectedTU4(client), client, Points_InfectedTU4_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_tongue_range";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 4:
			{
				if (bNoSurvivorGlow)
				{
					SendPanelToClient(Points_InfectedTU4(client), client, Points_InfectedTU4_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_survivor_glow";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 5:
			{
				if (bWitchStrength)
				{
					SendPanelToClient(Points_InfectedTU4(client), client, Points_InfectedTU4_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_instantkill_witch";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 6:
			{
				if (commonLimit >= GetConVarInt(Limit_CommonLimit))
				{
					SendPanelToClient(Points_InfectedTU4(client), client, Points_InfectedTU4_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_more_commons";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 7:
			{
				SendPanelToClient(Points_InfectedTU3(client), client, Points_InfectedTU3_Init, MENU_TIME_FOREVER);
			}
			case 8:
			{
				SendPanelToClient(Points_InfectedTU5(client), client, Points_InfectedTU5_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Points_InfectedTU5(client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Points Module - Team Upgrades Menu");
	new String:text[128];

	new String:Pct[16];
	Format(Pct, sizeof(Pct), "%");

	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", playerPoints[client][1], teamPoints[1]);
	DrawPanelText(menu, text);

	if (bSpecialFireImmune) Format(text, sizeof(text), "SI Fire Immunity (Purchased)");
	else Format(text, sizeof(text), "SI Fire Immunity");
	DrawPanelItem(menu, text);
	if (bCommonFireImmune) Format(text, sizeof(text), "Common Fire Immunity (Purchased)");
	else Format(text, sizeof(text), "Common Fire Immunity");
	DrawPanelItem(menu, text);
	if (bCommonMeleeImmune) Format(text, sizeof(text), "Common Melee Immunity (Purchased)");
	else Format(text, sizeof(text), "Common Melee Immunity");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Common Body Armour %3.2f%s out of %3.2f%s Maximum", commonBodyArmour * 100.0, Pct, GetConVarFloat(Limit_CommonBodyArmour) * 100.0, Pct);
	DrawPanelItem(menu, text);
	if (bWallOfFire) Format(text, sizeof(text), "Wall Of Fire (Purchased)");
	else Format(text, sizeof(text), "Wall Of Fire");
	DrawPanelItem(menu, text);
	if (bSpawnAnywhere) Format(text, sizeof(text), "Spawn Anywhere (Purchased)");
	else Format(text, sizeof(text), "Spawn Anywhere");
	DrawPanelItem(menu, text);
	/*
	if (bInfectedCloak) Format(text, sizeof(text), "Random SI Cloak (Purchased)");
	else Format(text, sizeof(text), "Random SI Cloak");
	DrawPanelItem(menu, text);
	*/
	Format(text, sizeof(text), "Previous Menu");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Main Menu");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Team Upgrades, last until round end, cost: %3.2f Point(s).", GetConVarFloat(ITUCost));
	DrawPanelText(menu, text);

	
	return menu;
}

public Points_InfectedTU5_Init(Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);
	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (bSpecialFireImmune)
				{
					SendPanelToClient(Points_InfectedTU5(client), client, Points_InfectedTU5_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_special_fire_immunity";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 2:
			{
				if (bCommonFireImmune)
				{
					SendPanelToClient(Points_InfectedTU5(client), client, Points_InfectedTU5_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_common_fire_immunity";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 3:
			{
				if (bCommonMeleeImmune)
				{
					SendPanelToClient(Points_InfectedTU5(client), client, Points_InfectedTU5_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_common_melee_immunity";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 4:
			{
				if (commonBodyArmour >= GetConVarFloat(Limit_CommonBodyArmour))
				{
					SendPanelToClient(Points_InfectedTU5(client), client, Points_InfectedTU5_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_common_body_armour";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 5:
			{
				if (bWallOfFire)
				{
					SendPanelToClient(Points_InfectedTU5(client), client, Points_InfectedTU5_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_wall_of_fire";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 6:
			{
				if (bSpawnAnywhere)
				{
					SendPanelToClient(Points_InfectedTU5(client), client, Points_InfectedTU5_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_spawn_anywhere";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			/*
			case 7:
			{
				if (bInfectedCloak)
				{
					SendPanelToClient(Points_InfectedTU5(client), client, Points_InfectedTU5_Init, MENU_TIME_FOREVER);
					return;
				}
				ItemName[client] = "upgrade_special_cloak";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			*/
			case 7:
			{
				SendPanelToClient(Points_InfectedTU4(client), client, Points_InfectedTU4_Init, MENU_TIME_FOREVER);
			}
			case 8:
			{
				SendPanelToClient(Points_InfectedMenu(client), client, Points_InfectedMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}