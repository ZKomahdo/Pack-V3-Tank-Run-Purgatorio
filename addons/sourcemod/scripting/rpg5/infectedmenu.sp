public Handle:Infected_MainMenu (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "Infected Main Menu");
	new String:text[64];
	Format(text, sizeof(text), "Sky Points: %d\nYour Points: %3.2f\nTeam Points: %3.2f", SkyPoints[client], InfectedPoints[client], InfectedTeamPoints);
	DrawPanelText(menu, text);
	
	Format(text, sizeof(text), "Spend Points");
	DrawPanelItem(menu, text);
	if (showinfo[client] == 1) DrawPanelText(menu, "Spend your (team) points earned in-game");

	Format(text, sizeof(text), "Experience Status");
	DrawPanelItem(menu, text);
	if (showinfo[client] == 1) DrawPanelText(menu, "View experience, and stuff like that");

	Format(text, sizeof(text), "AI(BOT) Experience Status");
	DrawPanelItem(menu, text);
	if (showinfo[client] == 1) DrawPanelText(menu, "View Bot experience");
	
	Format(text, sizeof(text), "Challenge Board");
	DrawPanelItem(menu, text);
	if (showinfo[client] == 1) DrawPanelText(menu, "View The Server Challenge Board");

	Format(text, sizeof(text), "Customize Yourself");
	DrawPanelItem(menu, text);
	if (showinfo[client] == 1) DrawPanelText(menu, "Enhance your experience on the server!");

	Format(text, sizeof(text), "Bounty Board");
	DrawPanelItem(menu, text);
	if (showinfo[client] == 1) DrawPanelText(menu, "Check out the bounty value of in-game survivors!");

	Format(text, sizeof(text), "Next Page -> Quests");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Sky Servers In-Game Store");
	DrawPanelItem(menu, text);
	if (showinfo[client] == 1) DrawPanelText(menu, "Spend Sky Points earned or purchased!");

	DrawPanelItem(menu, "End Your Life");
	return menu;
}

public Infected_MainMenu_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Infected_BuyMenu(client), client, Infected_BuyMenu_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				SendPanelToClient(Infected_Stats(client), client, Infected_Stats_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				SendPanelToClient(AIInfected_Stats(client), client, Infected_Stats_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				SendPanelToClient(Challenge_Board(client), client, Challenge_Board_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				if (Ph[client][2] < 1 || In[client][2] < 1)
				{
					PrintToChat(client, "%s \x01You must be at least level 1 to use this.", ERROR_INFO);
					return;
				}
				SendPanelToClient(Menu_Custom(client), client, Menu_Custom_Init, MENU_TIME_FOREVER);
			}
			case 6:
			{
				SendPanelToClient(Menu_Bounty(client), client, Menu_Bounty_Init, MENU_TIME_FOREVER);
			}
			case 7:
			{
				SendPanelToClient(Menu_Quests(client), client, Menu_Quests_Init, MENU_TIME_FOREVER);
			}
			case 8:
			{
				SendPanelToClient(Sky_Store(client), client, Sky_Store_Init, MENU_TIME_FOREVER);
			}
			case 9:
			{
				if (GetClientTeam(client) != 3) return;
				new Class = GetEntProp(client, Prop_Send, "m_zombieClass");
				if (Class != ZOMBIECLASS_TANK) ForcePlayerSuicide(client);
			}
			default:
			{
				SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Menu_Bounty (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[512];
	decl String:Name[64];

	Format(text, sizeof(text), "Bounty Board");
	DrawPanelText(menu, text);

	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 2) continue;
		GetClientName(i, Name, 64);
		Format(text, sizeof(text), "%s [%d XP]", Name, Bounty[i]);
		DrawPanelText(menu, text);
	}
	DrawPanelItem(menu, "Return to Main Menu");
	return menu;
}

public Menu_Bounty_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Infected_Stats (client)
{
	new Handle:menu = CreatePanel();
	
	new String:pct[32];
	Format(pct, sizeof(pct), "%");
	new String:text[64];
	Format(text, sizeof(text), "Your Level Info");
	SetPanelTitle(menu, text);
	Format(text, sizeof(text), "Hunter:     %d of %d xp (%3.2f%s) [Lv.%d]", Hu[client][0], Hu[client][1], ((Hu[client][0] * 1.0) / (Hu[client][1] * 1.0)) * 100.0, pct, Hu[client][2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Smoker:    %d of %d xp (%3.2f%s) [Lv.%d]", Sm[client][0], Sm[client][1], ((Sm[client][0] * 1.0) / (Sm[client][1] * 1.0)) * 100.0, pct, Sm[client][2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Boomer:    %d of %d xp (%3.2f%s) [Lv.%d]", Bo[client][0], Bo[client][1], ((Bo[client][0] * 1.0) / (Bo[client][1] * 1.0)) * 100.0, pct, Bo[client][2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Jockey:     %d of %d xp (%3.2f%s) [Lv.%d]", Jo[client][0], Jo[client][1], ((Jo[client][0] * 1.0) / (Jo[client][1] * 1.0)) * 100.0, pct, Jo[client][2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Charger:    %d of %d xp (%3.2f%s) [Lv.%d]", Ch[client][0], Ch[client][1], ((Ch[client][0] * 1.0) / (Ch[client][1] * 1.0)) * 100.0, pct, Ch[client][2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Spitter:     %d of %d xp (%3.2f%s) [Lv.%d]", Sp[client][0], Sp[client][1], ((Sp[client][0] * 1.0) / (Sp[client][1] * 1.0)) * 100.0, pct, Sp[client][2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tank:       %d of %d xp (%3.2f%s) [Lv.%d]", Ta[client][0], Ta[client][1], ((Ta[client][0] * 1.0) / (Ta[client][1] * 1.0)) * 100.0, pct, Ta[client][2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Infected:   %d of %d xp (%3.2f%s) [Lv.%d]", In[client][0], In[client][1], ((In[client][0] * 1.0) / (In[client][1] * 1.0)) * 100.0, pct, In[client][2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Total Time Played: %dD %dH %dM %dS", TimePlayed[client][0], TimePlayed[client][1], TimePlayed[client][2], TimePlayed[client][3]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Time Played Infected Lv.: %dD %dH %dM %dS", TimeInfectedPlayed[client][0], TimeInfectedPlayed[client][1], TimeInfectedPlayed[client][2], TimeInfectedPlayed[client][3]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Max Lv.: %d", GetConVarInt(LevelCap));
	DrawPanelText(menu, text);
	
	DrawPanelItem(menu, "Main Menu");
	return menu;
}

public Infected_Stats_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:AIInfected_Stats (client)
{
	new Handle:menu = CreatePanel();
	
	new String:pct[32];
	Format(pct, sizeof(pct), "%");
	new String:text[64];
	Format(text, sizeof(text), "AI Statistics Page");
	SetPanelTitle(menu, text);
	Format(text, sizeof(text), "Hunter:     %d of %d xp (%3.2f%s) [Lv.%d]", AIHunter[0], AIHunter[1], ((AIHunter[0] * 1.0) / (AIHunter[1] * 1.0)) * 100.0, pct, AIHunter[2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Smoker:    %d of %d xp (%3.2f%s) [Lv.%d]", AISmoker[0], AISmoker[1], ((AISmoker[0] * 1.0) / (AISmoker[1] * 1.0)) * 100.0, pct, AISmoker[2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Boomer:    %d of %d xp (%3.2f%s) [Lv.%d]", AIBoomer[0], AIBoomer[1], ((AIBoomer[0] * 1.0) / (AIBoomer[1] * 1.0)) * 100.0, pct, AIBoomer[2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Jockey:     %d of %d xp (%3.2f%s) [Lv.%d]", AIJockey[0], AIJockey[1], ((AIJockey[0] * 1.0) / (AIJockey[1] * 1.0)) * 100.0, pct, AIJockey[2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Charger:    %d of %d xp (%3.2f%s) [Lv.%d]", AICharger[0], AICharger[1], ((AICharger[0] * 1.0) / (AICharger[1] * 1.0)) * 100.0, pct, AICharger[2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Spitter:     %d of %d xp (%3.2f%s) [Lv.%d]", AISpitter[0], AISpitter[1], ((AISpitter[0] * 1.0) / (AISpitter[1] * 1.0)) * 100.0, pct, AISpitter[2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tank:       %d of %d xp (%3.2f%s) [Lv.%d]", AITank[0], AITank[1], ((AITank[0] * 1.0) / (AITank[1] * 1.0)) * 100.0, pct, AITank[2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Infected:   %d of %d xp (%3.2f%s) [Lv.%d]", AIInfected[0], AIInfected[1], ((AIInfected[0] * 1.0) / (AIInfected[1] * 1.0)) * 100.0, pct, AIInfected[2]);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Points: %3.3f", DirectorPoints);
	DrawPanelText(menu, text);
	
	DrawPanelItem(menu, "Main Menu");
	return menu;
}

public AIInfected_Stats_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Infected_BuyMenu (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "Infected Buy Menu");
	new String:text[64];
	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", InfectedPoints[client], InfectedTeamPoints);
	DrawPanelText(menu, text);
	
	Format(text, sizeof(text), "Change Class");
	DrawPanelItem(menu, text);
	if (showinfo[client] == 1) DrawPanelText(menu, "Change your class if you're alive or in ghost");
	
	Format(text, sizeof(text), "Uncommon Infected");
	DrawPanelItem(menu, text);
	if (showinfo[client] == 1) DrawPanelText(menu, "Queue or Drop uncommon infected on players");

	Format(text, sizeof(text), "Team Upgrades");
	DrawPanelItem(menu, text);
	if (showinfo[client] == 1) DrawPanelText(menu, "Make your team more powerful");
	
	Format(text, sizeof(text), "Your Upgrades");
	DrawPanelItem(menu, text);
	if (showinfo[client] == 1) DrawPanelText(menu, "Make yourself more powerful");
	
	//DrawPanelItem(menu, "Suicide");

	return menu;
}

public Infected_BuyMenu_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Infected_ClassChangeMenu(client), client, Infected_ClassChangeMenu_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				SendPanelToClient(Infected_CommonDrop(client), client, Infected_CommonDrop_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				SendPanelToClient(Infected_TeamUpgrades(client), client, Infected_TeamUpgrades_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				if (PersonalUpgrades[client] < 12) SendPanelToClient(Infected_Personal1(client), client, Infected_Personal1_Init, MENU_TIME_FOREVER);
				else
				{
					PrintToChat(client, "%s \x01You have all of the personal upgrades.", ERROR_INFO);
					return;
				}
			}
			/*case 5:
			{
				if (GetClientTeam(client) != 3) return;
				decl zombieclass;
				zombieclass = GetEntProp(client, Prop_Send, "m_zombieClass");
				if (zombieclass == ZOMBIECLASS_TANK) return;
				ForcePlayerSuicide(client);
			}*/
			default:
			{
				SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Infected_ClassChangeMenu (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "Change Class Menu");
	new String:text[64];
	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", InfectedPoints[client], InfectedTeamPoints);
	DrawPanelText(menu, text);
	
	if (GetConVarInt(CostEvaluation) == 2)
	{
		if (!IsPlayerGhost(client))
		{
			Format(text, sizeof(text), "Hunter - %3.3f", Hu[client][2] * GetConVarFloat(SpecialCostByLevel));
			DrawPanelItem(menu, text);
			Format(text, sizeof(text), "Smoker - %3.3f", Sm[client][2] * GetConVarFloat(SpecialCostByLevel));
			DrawPanelItem(menu, text);
			Format(text, sizeof(text), "Boomer - %3.3f", Bo[client][2] * GetConVarFloat(SpecialCostByLevel));
			DrawPanelItem(menu, text);
			Format(text, sizeof(text), "Jockey - %3.3f", Jo[client][2] * GetConVarFloat(SpecialCostByLevel));
			DrawPanelItem(menu, text);
			Format(text, sizeof(text), "Charger - %3.3f", Ch[client][2] * GetConVarFloat(SpecialCostByLevel));
			DrawPanelItem(menu, text);
			Format(text, sizeof(text), "Spitter - %3.3f", Sp[client][2] * GetConVarFloat(SpecialCostByLevel));
			DrawPanelItem(menu, text);

			Format(text, sizeof(text), "Witch - %3.3f", In[client][2] * GetConVarFloat(WitchCostByLevel));
			DrawPanelItem(menu, text);
		}
		else
		{
			Format(text, sizeof(text), "Hunter - FREE");
			DrawPanelItem(menu, text);
			Format(text, sizeof(text), "Smoker - FREE");
			DrawPanelItem(menu, text);
			Format(text, sizeof(text), "Boomer - FREE");
			DrawPanelItem(menu, text);
			Format(text, sizeof(text), "Jockey - FREE");
			DrawPanelItem(menu, text);
			Format(text, sizeof(text), "Charger - FREE");
			DrawPanelItem(menu, text);
			Format(text, sizeof(text), "Spitter - FREE");
			DrawPanelItem(menu, text);

			Format(text, sizeof(text), "Tank - %3.3f", Ta[client][2] * GetConVarFloat(TankCostByLevel));
			DrawPanelItem(menu, text);
			Format(text, sizeof(text), "Witch - %3.3f", In[client][2] * GetConVarFloat(WitchCostByLevel));
			DrawPanelItem(menu, text);
		}
	}
	else
	{
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
		Format(text, sizeof(text), "Special Purchase: %3.3f Point(s).", SpecialPurchaseValue[client]);
		DrawPanelText(menu, text);
	
		Format(text, sizeof(text), "Tank");
		DrawPanelItem(menu, text);
		//Format(text, sizeof(text), "Witch");
		//DrawPanelItem(menu, text);
	
		Format(text, sizeof(text), "Boss Purchase: %3.3f Point(s).", TankPurchaseValue[client]);
		DrawPanelText(menu, text);
	}
	
	if (TankCooldownTime == 0.0) Format(text, sizeof(text), "Tanks Alive: %d of %d", TankCount, TankLimit);
	else if (TankCooldownTime == -1.0) Format(text, sizeof(text), "Tank is restricted %d of %d", TankCount, TankLimit);
	else Format(text, sizeof(text), "Tank unavailable %3.1f cooldown remaining", GetConVarFloat(TankCooldown) - TankCooldownTime);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Witch's on the Field: %d of %d (max)", witchCount, witchMax);
	DrawPanelText(menu, text);
	
	return menu;
}

public Infected_ClassChangeMenu_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (ClassCharger[client] && !IsPlayerGhost(client) && IsPlayerAlive(client)) return;
				if (!IsPlayerAlive(client) || (ClassHunter[client] && !IsPlayerGhost(client))) return;
				ItemName[client] = "Hunter";
				PurchaseItem[client] = 1;
				InfectedPurchaseFunc(client);
			}
			case 2:
			{
				if (ClassCharger[client] && !IsPlayerGhost(client) && IsPlayerAlive(client)) return;
				if (!IsPlayerAlive(client) || (ClassSmoker[client] && !IsPlayerGhost(client))) return;
				ItemName[client] = "Smoker";
				PurchaseItem[client] = 1;
				InfectedPurchaseFunc(client);
			}
			case 3:
			{
				if (ClassCharger[client] && !IsPlayerGhost(client) && IsPlayerAlive(client)) return;
				if (!IsPlayerAlive(client) || (ClassBoomer[client] && !IsPlayerGhost(client))) return;
				ItemName[client] = "Boomer";
				PurchaseItem[client] = 1;
				InfectedPurchaseFunc(client);
			}
			case 4:
			{
				if (ClassCharger[client] && !IsPlayerGhost(client) && IsPlayerAlive(client)) return;
				if (!IsPlayerAlive(client) || (ClassJockey[client] && !IsPlayerGhost(client))) return;
				ItemName[client] = "Jockey";
				PurchaseItem[client] = 1;
				InfectedPurchaseFunc(client);
			}
			case 5:
			{
				if (ClassCharger[client] && !IsPlayerGhost(client) && IsPlayerAlive(client)) return;
				if (!IsPlayerAlive(client) || (ClassCharger[client] && !IsPlayerGhost(client))) return;
				ItemName[client] = "Charger";
				PurchaseItem[client] = 1;
				InfectedPurchaseFunc(client);
			}
			case 6:
			{
				if (ClassCharger[client] && !IsPlayerGhost(client) && IsPlayerAlive(client)) return;
				if (!IsPlayerAlive(client) || (ClassSpitter[client] && !IsPlayerGhost(client))) return;
				ItemName[client] = "Spitter";
				PurchaseItem[client] = 1;
				InfectedPurchaseFunc(client);
			}
			case 7:
			{
				if (!IsPlayerGhost(client))
				{
					if (witchCount >= witchMax)
					{
						PrintToChat(client, "%s \x01The maximum number of witches has been reached.", ERROR_INFO);
						return;
					}
					ItemName[client] = "witch";
					PurchaseItem[client] = 2;
					InfectedPurchaseFunc(client);
				}
				else
				{
					//if (ClassCharger[client] && !IsPlayerGhost(client) && IsPlayerAlive(client)) return;
					//if (!IsPlayerAlive(client)) return;
					if (TankCooldownTime != 0.0 || TankCount >= TankLimit) return;
					if (!IsPlayerGhost(client))
					{
						PrintToChat(client, "%s \x01You can only buy tanks in ghost mode.", ERROR_INFO);
						return;
					}
					ItemName[client] = "Tank";
					PurchaseItem[client] = 2;
					InfectedPurchaseFunc(client);
				}
			}
			case 8:
			{
				if (IsPlayerGhost(client))
				{
					if (witchCount >= witchMax)
					{
						PrintToChat(client, "%s \x01The maximum number of witches has been reached.", ERROR_INFO);
						return;
					}
					ItemName[client] = "witch";
					PurchaseItem[client] = 2;
					InfectedPurchaseFunc(client);
				}
			}
			default:
			{
				SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Infected_CommonDrop (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "Common Drop Menu");
	new String:text[64];
	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", InfectedPoints[client], InfectedTeamPoints);
	DrawPanelText(menu, text);
	
	Format(text, sizeof(text), "Brown Plop Drop");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Jimmy Drop");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Riot Drop");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Road Crew Drop");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Summon MudMen");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Summon Jimmy Gibbs");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Summon Riot Cops");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Summon Road Crew");
	DrawPanelItem(menu, text);
	if (UncommonPanicEventCount == -1.0) Format(text, sizeof(text), "Uncommon Panic Event");
	else Format(text, sizeof(text), "Uncommon Panic Event (%3.1f sec(s) Cooldown)", (GetConVarFloat(UncommonPanicEventTimer) - UncommonPanicEventCount));
	DrawPanelItem(menu, text);
	if (UncommonRemaining < 1 && !UncommonCooldown)
	{
		Format(text, sizeof(text), "%d Uncommons Available to drop!", GetConVarInt(UncommonDropAmount));
		DrawPanelText(menu, text);
		Format(text, sizeof(text), "%d Uncommons Available to be summoned!", GetConVarInt(UncommonQueueAmount));
		DrawPanelText(menu, text);
	}
	else if (UncommonRemaining < 1 && UncommonCooldown)
	{
		Format(text, sizeof(text), "%3.1f second(s) until uncommons can be purchased.", GetConVarFloat(UncommonCooldownTime) - UncommonCooldownCount);
		DrawPanelText(menu, text);
	}
	else
	{
		Format(text, sizeof(text), "%d Uncommons are still on their way...", UncommonRemaining);
		DrawPanelText(menu, text);
	}
	if (GetConVarInt(CostEvaluation) == 2)
	{
		Format(text, sizeof(text), "Uncommon Infected Cost: %3.3f Point(s).", In[client][2] * GetConVarFloat(UncommonCostByLevel));
	}
	else
	{
		Format(text, sizeof(text), "Uncommon Infected Cost: %3.3f Point(s).", UncommonPurchaseValue[client]);
	}
	DrawPanelText(menu, text);
	
	return menu;
}

public Infected_CommonDrop_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (UncommonRemaining > 0 || UncommonCooldown) return;
				ItemName[client] = "mudmen_drop";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 2:
			{
				if (UncommonRemaining > 0 || UncommonCooldown) return;
				ItemName[client] = "jimmy_drop";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 3:
			{
				if (UncommonRemaining > 0 || UncommonCooldown) return;
				ItemName[client] = "riot_drop";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 4:
			{
				if (UncommonRemaining > 0 || UncommonCooldown) return;
				ItemName[client] = "road_drop";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 5:
			{
				if (UncommonRemaining > 0 || UncommonCooldown) return;
				ItemName[client] = "mudmen_queue";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 6:
			{
				if (UncommonRemaining > 0 || UncommonCooldown) return;
				ItemName[client] = "jimmy_queue";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 7:
			{
				if (UncommonRemaining > 0 || UncommonCooldown) return;
				ItemName[client] = "riot_queue";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 8:
			{
				if (UncommonRemaining > 0 || UncommonCooldown) return;
				ItemName[client] = "road_queue";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			case 9:
			{
				if (UncommonRemaining > 0 || UncommonCooldown || UncommonPanicEventCount != -1.0) return;
				ItemName[client] = "uncommon_event";
				PurchaseItem[client] = 3;
				InfectedPurchaseFunc(client);
			}
			default:
			{
				SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Infected_TeamUpgrades (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "Team Upgrades Menu");
	new String:Pct[32];
	Format(Pct, sizeof(Pct), "%");
	new String:text[128];
	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", InfectedPoints[client], InfectedTeamPoints);
	DrawPanelText(menu, text);
	
	if (!SteelTongue) Format(text, sizeof(text), "Steel Tongue");
	else Format(text, sizeof(text), "Steel Tongue (Purchased)");
	DrawPanelItem(menu, text);
	if (TankLimit < GetConVarInt(TankLimitMax)) Format(text, sizeof(text), "Tank Limit");
	else Format(text, sizeof(text), "Tank Limit (Max. Amount Reached)");
	DrawPanelItem(menu, text);
	if (DeepFreezeAmount < GetConVarInt(DeepFreezeMax)) Format(text, sizeof(text), "Deep Freeze %d%s of %d%s", DeepFreezeAmount, Pct, GetConVarInt(DeepFreezeMax), Pct);
	else Format(text, sizeof(text), "Deep Freeze (%d%s Limit Reached)", DeepFreezeAmount, Pct);
	DrawPanelItem(menu, text);
	if (SpawnTimer > GetConVarInt(SpawnTimerMin)) Format(text, sizeof(text), "Spawn Timer %d Seconds (%d minimum)", SpawnTimer, GetConVarInt(SpawnTimerMin));
	else Format(text, sizeof(text), "Spawn Timer (%d Second(s) Minimum Reached)", SpawnTimer);
	DrawPanelItem(menu, text);
	if (commonBodyArmour >= GetConVarFloat(CommonBodyArmourMax)) Format(text, sizeof(text), "Common Body Armour (%3.1f%s Limit)", commonBodyArmour * 100.0, Pct);
	else Format(text, sizeof(text), "Common Body Armour - %3.1f%s DMG Red.", commonBodyArmour * 100.0, Pct);
	DrawPanelItem(menu, text);
	if (moreCommonsAmount >= GetConVarInt(MoreCommonsLimit)) Format(text, sizeof(text), "More Commons (%d Limit Reached)", GetConVarInt(MoreCommonsLimit));
	else Format(text, sizeof(text), "More Commons (%d of %d Max)", moreCommonsAmount, GetConVarInt(MoreCommonsLimit));
	DrawPanelItem(menu, text);
	if (!SurvivorRealism) Format(text, sizeof(text), "Survivor Realism-ish");
	else Format(text, sizeof(text), "Survivor Realism (Purchased)");
	DrawPanelItem(menu, text);
	if (!TUpgrade_CarryJump) Format(text, sizeof(text), "Charger Jump w/ Carrying Survivor");
	else Format(text, sizeof(text), "Charger Jump w/ Carrying Survivor (Purchased)");
	DrawPanelItem(menu, text);

	DrawPanelItem(menu, "Page 2");
	if (GetConVarInt(CostEvaluation) == 2)
	{
		Format(text, sizeof(text), "Team Upgrades Cost: %3.3f Point(s).", In[client][2] * GetConVarFloat(TeamUpgradesCostByLevel));
	}
	else
	{
		Format(text, sizeof(text), "Team Upgrades Cost: %3.3f Point(s).", TeamUpgradesPurchaseValue[client]);
	}
	DrawPanelText(menu, text);
	
	return menu;
}

public Infected_TeamUpgrades_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (SteelTongue) return;
				ItemName[client] = "steel_tongue";
				PurchaseItem[client] = 4;
				InfectedPurchaseFunc(client);
			}
			case 2:
			{
				if (TankLimit >= GetConVarInt(TankLimitMax)) return;
				ItemName[client] = "tank_limit";
				PurchaseItem[client] = 4;
				InfectedPurchaseFunc(client);
			}
			case 3:
			{
				if (DeepFreezeAmount >= GetConVarInt(DeepFreezeMax)) return;
				ItemName[client] = "deep_freeze";
				PurchaseItem[client] = 4;
				InfectedPurchaseFunc(client);
			}
			case 4:
			{
				if (SpawnTimer <= GetConVarInt(SpawnTimerMin)) return;
				ItemName[client] = "spawn_timer";
				PurchaseItem[client] = 4;
				InfectedPurchaseFunc(client);
			}
			case 5:
			{
				if (commonBodyArmour >= GetConVarFloat(CommonBodyArmourMax))
				{
					PrintToChat(client, "%s \x01Commons have the maximum amount of body armour.", ERROR_INFO);
					return;
				}
				ItemName[client] = "common_body_armour";
				PurchaseItem[client] = 4;
				InfectedPurchaseFunc(client);
			}
			case 6:
			{
				if (moreCommonsAmount >= GetConVarInt(MoreCommonsLimit))
				{
					PrintToChat(client, "%s \x01The common infected limit has been reached.", ERROR_INFO);
					return;
				}
				ItemName[client] = "more_commons";
				PurchaseItem[client] = 4;
				InfectedPurchaseFunc(client);
			}
			case 7:
			{
				if (SurvivorRealism) return;
				ItemName[client] = "survivor_realism";
				PurchaseItem[client] = 4;
				InfectedPurchaseFunc(client);
			}
			case 8:
			{
				if (TUpgrade_CarryJump) return;
				ItemName[client] = "charger_can_jump_while_carrying";
				PurchaseItem[client] = 4;
				InfectedPurchaseFunc(client);
			}
			case 9:
			{
				SendPanelToClient(Infected_TeamUpgrades2(client), client, Infected_TeamUpgrades2_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Infected_TeamUpgrades2 (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "Team Upgrades Menu");
	new String:Pct[32];
	Format(Pct, sizeof(Pct), "%");
	new String:text[128];
	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", InfectedPoints[client], InfectedTeamPoints);
	DrawPanelText(menu, text);
	
	if (witchMax < GetConVarInt(WitchMaximum)) Format(text, sizeof(text), "Witch Limit");
	else Format(text, sizeof(text), "Witch Limit (Max. Amount Reached)");
	DrawPanelItem(menu, text);
	if (bCommonFireImmune) Format(text, sizeof(text), "Commons Immune To Fire (Purchased)");
	else Format(text, sizeof(text), "Commons Immune To Fire");
	DrawPanelItem(menu, text);
	if (bCommonMeleeImmune) Format(text, sizeof(text), "Commons Immune To Melee Wep. (Purchased)");
	else Format(text, sizeof(text), "Commons Immune To Melee Wep.");
	DrawPanelItem(menu, text);
	if (wanderingCommonsAmount >= GetConVarInt(WanderingCommonsLimit)) Format(text, sizeof(text), "Wandering Commons (%d Limit Reached)", GetConVarInt(WanderingCommonsLimit));
	else Format(text, sizeof(text), "Wandering Commons (%d of %d Max)", wanderingCommonsAmount, GetConVarInt(WanderingCommonsLimit));
	DrawPanelItem(menu, text);
	DrawPanelItem(menu, "Page 1");

	if (GetConVarInt(CostEvaluation) == 2)
	{
		Format(text, sizeof(text), "Team Upgrades Cost: %3.3f Point(s).", In[client][2] * GetConVarFloat(TeamUpgradesCostByLevel));
	}
	else
	{
		Format(text, sizeof(text), "Team Upgrades Cost: %3.3f Point(s).", TeamUpgradesPurchaseValue[client]);
	}
	DrawPanelText(menu, text);
	
	return menu;
}

public Infected_TeamUpgrades2_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (witchMax >= GetConVarInt(WitchMaximum))
				{
					PrintToChat(client, "%s \x01The witch limit maximum has been reached.", ERROR_INFO);
					return;
				}
				ItemName[client] = "witch_limit";
				PurchaseItem[client] = 4;
				InfectedPurchaseFunc(client);
			}
			case 2:
			{
				if (bCommonFireImmune)
				{
					PrintToChat(client, "%s \x01Common Infected are already immune to fire.", ERROR_INFO);
					return;
				}
				ItemName[client] = "common_inferno_immune";
				PurchaseItem[client] = 4;
				InfectedPurchaseFunc(client);
			}
			case 3:
			{
				if (bCommonMeleeImmune)
				{
					PrintToChat(client, "%s \x01Common Infected are already immune to melee weapons.", ERROR_INFO);
					return;
				}
				ItemName[client] = "common_melee_immune";
				PurchaseItem[client] = 4;
				InfectedPurchaseFunc(client);
			}
			case 4:
			{
				if (wanderingCommonsAmount >= GetConVarInt(WanderingCommonsLimit))
				{
					PrintToChat(client, "%s \x01The wandering common infected limit has been reached.", ERROR_INFO);
					return;
				}
				ItemName[client] = "wandering_commons_limit";
				PurchaseItem[client] = 4;
				InfectedPurchaseFunc(client);
			}
			case 5:
			{
				SendPanelToClient(Infected_TeamUpgrades(client), client, Infected_TeamUpgrades_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}



public Handle:Infected_Personal1 (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "Personal Upgrades Menu");
	new String:text[64];
	Format(text, sizeof(text), "Your Points: %3.2f\nTeam Points: %3.2f", InfectedPoints[client], InfectedTeamPoints);
	DrawPanelText(menu, text);
	
	if (!UpgradeHunter[client] && Hu[client][2] < GetConVarInt(InfectedTier2Level)) Format(text, sizeof(text), "Hunter -> Tier 2");
	else if (!SuperUpgradeHunter[client] && Hu[client][2] < GetConVarInt(InfectedTier3Level)) Format(text, sizeof(text), "Hunter -> Tier 3");
	else Format(text, sizeof(text), "Hunter (Tier 3 Upgraded)");
	DrawPanelItem(menu, text);
	if (!UpgradeSmoker[client] && Sm[client][2] < GetConVarInt(InfectedTier2Level)) Format(text, sizeof(text), "Smoker -> Tier 2");
	else if (!SuperUpgradeSmoker[client] && Sm[client][2] < GetConVarInt(InfectedTier3Level)) Format(text, sizeof(text), "Smoker -> Tier 3");
	else Format(text, sizeof(text), "Smoker (Tier 3 Upgraded)");
	DrawPanelItem(menu, text);
	if (!UpgradeBoomer[client] && Bo[client][2] < GetConVarInt(InfectedTier2Level)) Format(text, sizeof(text), "Boomer -> Tier 2");
	else if (!SuperUpgradeBoomer[client] && Bo[client][2] < GetConVarInt(InfectedTier3Level)) Format(text, sizeof(text), "Boomer -> Tier 3");
	else Format(text, sizeof(text), "Boomer (Tier 3 Upgraded)");
	DrawPanelItem(menu, text);
	if (!UpgradeJockey[client] && Jo[client][2] < GetConVarInt(InfectedTier2Level)) Format(text, sizeof(text), "Jockey -> Tier 2");
	else if (!SuperUpgradeJockey[client] && Jo[client][2] < GetConVarInt(InfectedTier3Level)) Format(text, sizeof(text), "Jockey -> Tier 3");
	else Format(text, sizeof(text), "Jockey (Tier 3 Upgraded)");
	DrawPanelItem(menu, text);
	if (!UpgradeCharger[client] && Ch[client][2] < GetConVarInt(InfectedTier2Level)) Format(text, sizeof(text), "Charger -> Tier 2");
	else if (!SuperUpgradeCharger[client] && Ch[client][2] < GetConVarInt(InfectedTier3Level)) Format(text, sizeof(text), "Charger -> Tier 3");
	else Format(text, sizeof(text), "Charger (Tier 3 Upgraded)");
	DrawPanelItem(menu, text);
	if (!UpgradeSpitter[client] && Sp[client][2] < GetConVarInt(InfectedTier2Level)) Format(text, sizeof(text), "Spitter -> Tier 2");
	else if (!SuperUpgradeSpitter[client] && Sp[client][2] < GetConVarInt(InfectedTier3Level)) Format(text, sizeof(text), "Spitter -> Tier 3");
	else Format(text, sizeof(text), "Spitter (Tier 3 Upgraded)");
	DrawPanelItem(menu, text);
	if (GetConVarInt(CostEvaluation) == 2)
	{
		Format(text, sizeof(text), "Personal Upgrade Cost: %3.3f Point(s).", In[client][2] * GetConVarFloat(PersonalUpgradesCostByLevel));
	}
	else
	{
		Format(text, sizeof(text), "Personal Upgrade Cost: %3.3f Point(s).", PersonalUpgradesPurchaseValue[client]);
	}
	DrawPanelText(menu, text);
	
	return menu;
}

public Infected_Personal1_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (UpgradeHunter[client] && SuperUpgradeHunter[client] || Hu[client][2] >= GetConVarInt(InfectedTier3Level)) return;
				if (UpgradeHunter[client] || Hu[client][2] >= GetConVarInt(InfectedTier2Level)) ItemName[client] = "hunter_tier3";
				else ItemName[client] = "hunter_tier2";
				PurchaseItem[client] = 5;
				InfectedPurchaseFunc(client);
			}
			case 2:
			{
				if (UpgradeSmoker[client] && SuperUpgradeSmoker[client] || Sm[client][2] >= GetConVarInt(InfectedTier3Level)) return;
				if (UpgradeSmoker[client] || Sm[client][2] >= GetConVarInt(InfectedTier2Level)) ItemName[client] = "smoker_tier3";
				else ItemName[client] = "smoker_tier2";
				PurchaseItem[client] = 5;
				InfectedPurchaseFunc(client);
			}
			case 3:
			{
				if (UpgradeBoomer[client] && SuperUpgradeBoomer[client] || Bo[client][2] >= GetConVarInt(InfectedTier3Level)) return;
				if (UpgradeBoomer[client] || Bo[client][2] >= GetConVarInt(InfectedTier2Level)) ItemName[client] = "boomer_tier3";
				else ItemName[client] = "boomer_tier2";
				PurchaseItem[client] = 5;
				InfectedPurchaseFunc(client);
			}
			case 4:
			{
				if (UpgradeJockey[client] && SuperUpgradeJockey[client] || Jo[client][2] >= GetConVarInt(InfectedTier3Level)) return;
				if (UpgradeJockey[client] || Jo[client][2] >= GetConVarInt(InfectedTier2Level)) ItemName[client] = "jockey_tier3";
				else ItemName[client] = "jockey_tier2";
				PurchaseItem[client] = 5;
				InfectedPurchaseFunc(client);
			}
			case 5:
			{
				if (UpgradeCharger[client] && SuperUpgradeCharger[client] || Ch[client][2] >= GetConVarInt(InfectedTier3Level)) return;
				if (UpgradeCharger[client] || Ch[client][2] >= GetConVarInt(InfectedTier2Level)) ItemName[client] = "charger_tier3";
				else ItemName[client] = "charger_tier2";
				PurchaseItem[client] = 5;
				InfectedPurchaseFunc(client);
			}
			case 6:
			{
				if (UpgradeSpitter[client] && SuperUpgradeSpitter[client] || Sp[client][2] >= GetConVarInt(InfectedTier3Level)) return;
				if (UpgradeSpitter[client] || Sp[client][2] >= GetConVarInt(InfectedTier2Level)) ItemName[client] = "spitter_tier3";
				else ItemName[client] = "spitter_tier2";
				PurchaseItem[client] = 5;
				InfectedPurchaseFunc(client);
			}
			default:
			{
				SendPanelToClient(Infected_MainMenu(client), client, Infected_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}