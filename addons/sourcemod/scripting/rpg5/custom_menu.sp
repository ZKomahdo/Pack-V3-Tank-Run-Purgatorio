public Handle:Menu_Custom (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "Customization Menu");
	new String:text[128];
	Format(text, sizeof(text), "Set Custom Chat Colours");
	DrawPanelItem(menu, text);
	if (Hu[client][2] >= GetConVarInt(WallOfFireLevel) || 
		Sm[client][2] >= GetConVarInt(WallOfFireLevel) || 
		Bo[client][2] >= GetConVarInt(WallOfFireLevel) || 
		Jo[client][2] >= GetConVarInt(WallOfFireLevel) || 
		Ch[client][2] >= GetConVarInt(WallOfFireLevel) || 
		Sp[client][2] >= GetConVarInt(WallOfFireLevel) || 
		Ta[client][2] >= GetConVarInt(WallOfFireLevel))
	{
		Format(text, sizeof(text), "Wall Of Fire Options");
	}
	else
	{
		Format(text, sizeof(text), "Wall Of Fire Options [Locked]");
	}
	DrawPanelItem(menu, text);
	if (bBulletTrailUnlocked(client))
	{
		if (weaponTrails[client] == 0) Format(text, sizeof(text), "Bullet Trails [Disabled]");
		else Format(text, sizeof(text), "Bullet Trails [Enabled]");
	}
	else
	{
		new String:unlockLv[128];
		if (GetConVarInt(g_WeaponTrailLevel) == 0) Format(unlockLv, sizeof(unlockLv), "Unlocks at Weapon Lv. %d", GetConVarInt(LevelCap));
		else Format(unlockLv, sizeof(unlockLv), "Unlocks at Weapon Lv. %d", GetConVarInt(g_WeaponTrailLevel));
		Format(text, sizeof(text), "Bullet Trails [%s]", unlockLv);
	}
	DrawPanelItem(menu, text);
	return menu;
}

public Menu_Custom_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				if (Hu[client][2] >= GetConVarInt(WallOfFireLevel) || 
					Sm[client][2] >= GetConVarInt(WallOfFireLevel) || 
					Bo[client][2] >= GetConVarInt(WallOfFireLevel) || 
					Jo[client][2] >= GetConVarInt(WallOfFireLevel) || 
					Ch[client][2] >= GetConVarInt(WallOfFireLevel) || 
					Sp[client][2] >= GetConVarInt(WallOfFireLevel) || 
					Ta[client][2] >= GetConVarInt(WallOfFireLevel))
				{
					SendPanelToClient(Menu_SetInfectedWOF(client), client, Menu_SetInfectedWOF_Init, MENU_TIME_FOREVER);
				}
			}
			case 3:
			{
				if (bBulletTrailUnlocked(client))
				{
					if (weaponTrails[client] == 0)
					{
						weaponTrails[client] = 1;
						if (showinfo[client] == 1)
						{
							PrintToChat(client, "%s \x01To set bullet trail colours, use !trails [pistol | uzi | shotgun | rifle | sniper] [red] [green] [blue] [transparency] , ranges 0 - 255", INFO);
							PrintToChat(client, "%s \x01Example: !trails rifle 200 0 0 255 , sets rifle trail colour red with no transparency.", INFO);
						}
					}
					else weaponTrails[client] = 0;
				}
				SendPanelToClient(Menu_Custom(client), client, Menu_Custom_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Menu_Custom(client), client, Menu_Custom_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Menu_SetInfectedWOF (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "Set Wall Of Fire Settings");
	new String:text[128];
	if (Hu[client][2] >= GetConVarInt(WallOfFireLevel))
	{
		if (WOF[client][0] == 1) Format(text, sizeof(text), "Hunter: Wall Of Fire [Enabled]");
		else Format(text, sizeof(text), "Hunter: Wall Of Fire [Disabled]");
	}
	else Format(text, sizeof(text), "Hunter: Wall Of Fire [Unlock at Hunter Lv. %d]", GetConVarInt(WallOfFireLevel));
	DrawPanelItem(menu, text);

	if (Sm[client][2] >= GetConVarInt(WallOfFireLevel))
	{
		if (WOF[client][1] == 1) Format(text, sizeof(text), "Smoker: Wall Of Fire [Enabled]");
		else Format(text, sizeof(text), "Smoker: Wall Of Fire [Disabled]");
	}
	else Format(text, sizeof(text), "Smoker: Wall Of Fire [Unlock at Smoker Lv. %d]", GetConVarInt(WallOfFireLevel));
	DrawPanelItem(menu, text);

	if (Bo[client][2] >= GetConVarInt(WallOfFireLevel))
	{
		if (WOF[client][2] == 1) Format(text, sizeof(text), "Boomer: Wall Of Fire [Enabled]");
		else Format(text, sizeof(text), "Boomer: Wall Of Fire [Disabled]");
	}
	else Format(text, sizeof(text), "Boomer: Wall Of Fire [Unlock at Boomer Lv. %d]", GetConVarInt(WallOfFireLevel));
	DrawPanelItem(menu, text);

	if (Jo[client][2] >= GetConVarInt(WallOfFireLevel))
	{
		if (WOF[client][3] == 1) Format(text, sizeof(text), "Jockey: Wall Of Fire [Enabled]");
		else Format(text, sizeof(text), "Jockey: Wall Of Fire [Disabled]");
	}
	else Format(text, sizeof(text), "Jockey: Wall Of Fire [Unlock at Jockey Lv. %d]", GetConVarInt(WallOfFireLevel));
	DrawPanelItem(menu, text);

	if (Ch[client][2] >= GetConVarInt(WallOfFireLevel))
	{
		if (WOF[client][4] == 1) Format(text, sizeof(text), "Charger: Wall Of Fire [Enabled]");
		else Format(text, sizeof(text), "Charger: Wall Of Fire [Disabled]");
	}
	else Format(text, sizeof(text), "Charger: Wall Of Fire [Unlock at Charger Lv. %d]", GetConVarInt(WallOfFireLevel));
	DrawPanelItem(menu, text);

	if (Sp[client][2] >= GetConVarInt(WallOfFireLevel))
	{
		if (WOF[client][5] == 1) Format(text, sizeof(text), "Spitter: Wall Of Fire [Enabled]");
		else Format(text, sizeof(text), "Spitter: Wall Of Fire [Disabled]");
	}
	else Format(text, sizeof(text), "Spitter: Wall Of Fire [Unlock at Spitter Lv. %d]", GetConVarInt(WallOfFireLevel));
	DrawPanelItem(menu, text);

	if (Ta[client][2] >= GetConVarInt(WallOfFireLevel))
	{
		if (WOF[client][6] == 1) Format(text, sizeof(text), "Tank: Wall Of Fire [Enabled]");
		else Format(text, sizeof(text), "Tank: Wall Of Fire [Disabled]");
	}
	else Format(text, sizeof(text), "Tank: Wall Of Fire [Unlock at Tank Lv. %d]", GetConVarInt(WallOfFireLevel));
	DrawPanelItem(menu, text);

	return menu;
}

public Menu_SetInfectedWOF_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (Hu[client][2] >= GetConVarInt(WallOfFireLevel))
				{
					if (WOF[client][0])
					{
						WOF[client][0] = 0;
						PrintToChat(client, "%s \x05Hunter: Wall Of Fire \x04Disabled", INFO);
					}
					else
					{
						WOF[client][0] = 1;
						PrintToChat(client, "%s \x05Hunter: Wall Of Fire \x03Enabled", INFO);
					}
				}
				SendPanelToClient(Menu_SetInfectedWOF(client), client, Menu_SetInfectedWOF_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				if (Sm[client][2] >= GetConVarInt(WallOfFireLevel))
				{
					if (WOF[client][1])
					{
						WOF[client][1] = 0;
						PrintToChat(client, "%s \x05Smoker: Wall Of Fire \x04Disabled", INFO);
					}
					else
					{
						WOF[client][1] = 1;
						PrintToChat(client, "%s \x05Smoker: Wall Of Fire \x03Enabled", INFO);
					}
				}
				SendPanelToClient(Menu_SetInfectedWOF(client), client, Menu_SetInfectedWOF_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				if (Bo[client][2] >= GetConVarInt(WallOfFireLevel))
				{
					if (WOF[client][2])
					{
						WOF[client][2] = 0;
						PrintToChat(client, "%s \x05Boomer: Wall Of Fire \x04Disabled", INFO);
					}
					else
					{
						WOF[client][2] = 1;
						PrintToChat(client, "%s \x05Boomer: Wall Of Fire \x03Enabled", INFO);
					}
				}
				SendPanelToClient(Menu_SetInfectedWOF(client), client, Menu_SetInfectedWOF_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				if (Jo[client][2] >= GetConVarInt(WallOfFireLevel))
				{
					if (WOF[client][3])
					{
						WOF[client][3] = 0;
						PrintToChat(client, "%s \x05Jockey: Wall Of Fire \x04Disabled", INFO);
					}
					else
					{
						WOF[client][3] = 1;
						PrintToChat(client, "%s \x05Jockey: Wall Of Fire \x03Enabled", INFO);
					}
				}
				SendPanelToClient(Menu_SetInfectedWOF(client), client, Menu_SetInfectedWOF_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				if (Ch[client][2] >= GetConVarInt(WallOfFireLevel))
				{
					if (WOF[client][4])
					{
						WOF[client][4] = 0;
						PrintToChat(client, "%s \x05Charger: Wall Of Fire \x04Disabled", INFO);
					}
					else
					{
						WOF[client][4] = 1;
						PrintToChat(client, "%s \x05Charger: Wall Of Fire \x03Enabled", INFO);
					}
				}
				SendPanelToClient(Menu_SetInfectedWOF(client), client, Menu_SetInfectedWOF_Init, MENU_TIME_FOREVER);
			}
			case 6:
			{
				if (Sp[client][2] >= GetConVarInt(WallOfFireLevel))
				{
					if (WOF[client][5])
					{
						WOF[client][5] = 0;
						PrintToChat(client, "%s \x05Spitter: Wall Of Fire \x04Disabled", INFO);
					}
					else
					{
						WOF[client][5] = 1;
						PrintToChat(client, "%s \x05Spitter: Wall Of Fire \x03Enabled", INFO);
					}
				}
				SendPanelToClient(Menu_SetInfectedWOF(client), client, Menu_SetInfectedWOF_Init, MENU_TIME_FOREVER);
			}
			case 7:
			{
				if (Ta[client][2] >= GetConVarInt(WallOfFireLevel))
				{
					if (WOF[client][6])
					{
						WOF[client][6] = 0;
						PrintToChat(client, "%s \x05Tank: Wall Of Fire \x04Disabled", INFO);
					}
					else
					{
						WOF[client][6] = 1;
						PrintToChat(client, "%s \x05Tank: Wall Of Fire \x03Enabled", INFO);
					}
				}
				SendPanelToClient(Menu_SetInfectedWOF(client), client, Menu_SetInfectedWOF_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Menu_Custom(client), client, Menu_Custom_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Menu_SetChatColor (client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Set Chat Colors");
	new String:text[512];

	Format(text, sizeof(text), "Set Paranthesis Color");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Set Team Text Color");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Set Name Text Color");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Set Chat Text Color");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Reset Chat Color Defaults");
	DrawPanelItem(menu, text);
	DrawPanelItem(menu, "Return to Main Menu");
	return menu;
}

public Menu_SetChatColor_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Menu_SetParanthesisColor(client), client, Menu_SetParanthesisColor_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				SendPanelToClient(Menu_SetTeamTextColor(client), client, Menu_SetTeamTextColor_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				SendPanelToClient(Menu_SetNameTextColor(client), client, Menu_SetNameTextColor_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				SendPanelToClient(Menu_SetChatTextColor(client), client, Menu_SetChatTextColor_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				for (new i = 0; i <= 3; i++)
				{
					ChatColor[client][i] = "def";
				}
				if (Ach[client][2] == 1)
				{
					Ach[client][2] = 0;
					PrintToChatAll("%s \x03%N \x01has \x04failed \x05%s [Achievement, -%d Physical XP]", ACHIEVEMENT_INFO, client, AchievementName[2], GetConVarInt(Achievement[2][1]));
					Ph[client][0] -= GetConVarInt(Achievement[2][1]);
				}
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 6:
			{
				SendPanelToClient(Menu_Custom(client), client, Menu_Custom_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Menu_Custom(client), client, Menu_Custom_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Menu_SetParanthesisColor (client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Set Paranthesis Color");
	new String:text[512];

	Format(text, sizeof(text), "White");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Light Green");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Orange");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Dark Green");
	DrawPanelItem(menu, text);
	DrawPanelItem(menu, "Return To Previous Page");
	return menu;
}

public Check_Colours(client)
{
	if (Ach[client][2] == 0 && !StrEqual(ChatColor[client][0], "def") && 
		!StrEqual(ChatColor[client][1], "def") && !StrEqual(ChatColor[client][2], "def") && 
		!StrEqual(ChatColor[client][3], "def")) AchievementCheck(client, 2);
}

public Menu_SetParanthesisColor_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				ChatColor[client][0] = "\x01";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				ChatColor[client][0] = "\x03";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				ChatColor[client][0] = "\x04";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				ChatColor[client][0] = "\x05";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Menu_SetTeamTextColor (client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Set Team Text Color");
	new String:text[512];

	Format(text, sizeof(text), "White");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Light Green");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Orange");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Dark Green");
	DrawPanelItem(menu, text);
	DrawPanelItem(menu, "Return To Previous Page");
	return menu;
}

public Menu_SetTeamTextColor_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				ChatColor[client][1] = "\x01";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				ChatColor[client][1] = "\x03";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				ChatColor[client][1] = "\x04";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				ChatColor[client][1] = "\x05";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Menu_SetNameTextColor (client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Set Name Text Color");
	new String:text[512];

	Format(text, sizeof(text), "White");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Light Green");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Orange");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Dark Green");
	DrawPanelItem(menu, text);
	DrawPanelItem(menu, "Return To Previous Page");
	return menu;
}

public Menu_SetNameTextColor_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				ChatColor[client][2] = "\x01";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				ChatColor[client][2] = "\x03";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				ChatColor[client][2] = "\x04";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				ChatColor[client][2] = "\x05";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Menu_SetChatTextColor (client)
{
	new Handle:menu = CreatePanel();

	SetPanelTitle(menu, "Set Chat Text Color");
	new String:text[512];

	Format(text, sizeof(text), "White");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Light Green");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Orange");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Dark Green");
	DrawPanelItem(menu, text);
	DrawPanelItem(menu, "Return To Previous Page");
	return menu;
}

public Menu_SetChatTextColor_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				ChatColor[client][3] = "\x01";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				ChatColor[client][3] = "\x03";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				ChatColor[client][3] = "\x04";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				ChatColor[client][3] = "\x05";
				Check_Colours(client);
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Menu_SetChatColor(client), client, Menu_SetChatColor_Init, MENU_TIME_FOREVER);
			}
		}
	}
}