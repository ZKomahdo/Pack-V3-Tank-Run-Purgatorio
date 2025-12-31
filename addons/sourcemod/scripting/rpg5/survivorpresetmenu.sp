public Handle:Customize_Settings (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[64];
	Format(text, sizeof(text), "%N Statistics Page", client);
	SetPanelTitle(menu, text);

	if (Ph[client][2] < GetConVarInt(UnlockPresetLevel[0])) Format(text, sizeof(text), "Preset 1 (Unlocks at Physical Lv.%d)", GetConVarInt(UnlockPresetLevel[0]));
	else Format(text, sizeof(text), "Preset 1 (%s)", Mw[client][0]);
	DrawPanelItem(menu, text);
	
	if (Ph[client][2] < GetConVarInt(UnlockPresetLevel[1])) Format(text, sizeof(text), "Preset 2 (Unlocks at Physical Lv.%d)", GetConVarInt(UnlockPresetLevel[1]));
	else Format(text, sizeof(text), "Preset 2 (%s)", Mw[client][1]);
	DrawPanelItem(menu, text);

	if (Ph[client][2] < GetConVarInt(UnlockPresetLevel[2])) Format(text, sizeof(text), "Preset 3 (Unlocks at Physical Lv.%d)", GetConVarInt(UnlockPresetLevel[2]));
	else Format(text, sizeof(text), "Preset 3 (%s)", Mw[client][2]);
	DrawPanelItem(menu, text);

	if (Ul[client][0] == 0) Format(text, sizeof(text), "Preset 4 (Buy in the Sky Store!)");
	else Format(text, sizeof(text), "Preset 4 (%s)", Mw[client][3]);
	DrawPanelItem(menu, text);

	if (Ul[client][1] == 0) Format(text, sizeof(text), "Preset 5 (Buy in the Sky Store!)");
	else Format(text, sizeof(text), "Preset 5 (%s)", Mw[client][4]);
	DrawPanelItem(menu, text);
	
	DrawPanelItem(menu, "Main Menu");
	return menu;
}

public Customize_Settings_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (Ph[client][2] < GetConVarInt(UnlockPresetLevel[0])) return;
				PresetViewer[client] = 0;
				SendPanelToClient(Survivor_PresetMenu(client), client, Survivor_PresetMenu_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				if (Ph[client][2] < GetConVarInt(UnlockPresetLevel[1])) return;
				PresetViewer[client] = 1;
				SendPanelToClient(Survivor_PresetMenu(client), client, Survivor_PresetMenu_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				if (Ph[client][2] < GetConVarInt(UnlockPresetLevel[2])) return;
				PresetViewer[client] = 2;
				SendPanelToClient(Survivor_PresetMenu(client), client, Survivor_PresetMenu_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				if (Ul[client][0] == 0) return;
				PresetViewer[client] = 3;
				SendPanelToClient(Survivor_PresetMenu(client), client, Survivor_PresetMenu_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				if (Ul[client][1] == 0) return;
				PresetViewer[client] = 4;
				SendPanelToClient(Survivor_PresetMenu(client), client, Survivor_PresetMenu_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Survivor_MainMenu(client), client, Survivor_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

// For the preset layout, we give the player 4 lines describing what they currently have saved in each slot
// And then 6 options. 4 to change those slots, and 1 to save, and 1 to load.

public Handle:Survivor_PresetMenu (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[64];
	Format(text, sizeof(text), "%N Statistics Page", client);
	SetPanelTitle(menu, text);

	if (PresetViewer[client] == 0) Format(text, sizeof(text), "Primary Weapon: %s", Mw[client][0]);
	else if (PresetViewer[client] == 1) Format(text, sizeof(text), "Primary Weapon: %s", Mw[client][1]);
	else if (PresetViewer[client] == 2) Format(text, sizeof(text), "Primary Weapon: %s", Mw[client][2]);
	else if (PresetViewer[client] == 3) Format(text, sizeof(text), "Primary Weapon: %s", Mw[client][3]);
	else if (PresetViewer[client] == 4) Format(text, sizeof(text), "Primary Weapon: %s", Mw[client][4]);
	DrawPanelText(menu, text);
	if (PresetViewer[client] == 0) Format(text, sizeof(text), "Secondary Weapon: %s", Sw[client][0]);
	else if (PresetViewer[client] == 1) Format(text, sizeof(text), "Secondary Weapon: %s", Sw[client][1]);
	else if (PresetViewer[client] == 2) Format(text, sizeof(text), "Secondary Weapon: %s", Sw[client][2]);
	else if (PresetViewer[client] == 3) Format(text, sizeof(text), "Secondary Weapon: %s", Sw[client][3]);
	else if (PresetViewer[client] == 4) Format(text, sizeof(text), "Secondary Weapon: %s", Sw[client][4]);
	DrawPanelText(menu, text);
	if (PresetViewer[client] == 0) Format(text, sizeof(text), "Health Item: %s", Hi[client][0]);
	else if (PresetViewer[client] == 1) Format(text, sizeof(text), "Health Item: %s", Hi[client][1]);
	else if (PresetViewer[client] == 2) Format(text, sizeof(text), "Health Item: %s", Hi[client][2]);
	else if (PresetViewer[client] == 3) Format(text, sizeof(text), "Health Item: %s", Hi[client][3]);
	else if (PresetViewer[client] == 4) Format(text, sizeof(text), "Health Item: %s", Hi[client][4]);
	DrawPanelText(menu, text);
	if (PresetViewer[client] == 0) Format(text, sizeof(text), "Grenade: %s", Gi[client][0]);
	else if (PresetViewer[client] == 1) Format(text, sizeof(text), "Grenade: %s", Gi[client][1]);
	else if (PresetViewer[client] == 2) Format(text, sizeof(text), "Grenade: %s", Gi[client][2]);
	else if (PresetViewer[client] == 3) Format(text, sizeof(text), "Grenade: %s", Gi[client][3]);
	else if (PresetViewer[client] == 4) Format(text, sizeof(text), "Grenade: %s", Gi[client][4]);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Set Primary Weapon");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Set Secondary Weapon");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Set Health Item");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Set Grenades");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text), "Load This Preset");
	DrawPanelItem(menu, text);
	
	DrawPanelItem(menu, "Main Menu");
	return menu;
}

public Survivor_PresetMenu_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Survivor_SetPrimary(client), client, Survivor_SetPrimary_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				SendPanelToClient(Survivor_SetSecondary(client), client, Survivor_SetSecondary_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				SendPanelToClient(Survivor_SetItem(client), client, Survivor_SetItem_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				SendPanelToClient(Survivor_SetGrenade(client), client, Survivor_SetGrenade_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				LoadPresets(client);
			}
			default:
			{
				SendPanelToClient(Survivor_MainMenu(client), client, Survivor_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Survivor_SetPrimary (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[64];
	SetPanelTitle(menu, "Equipment Locker");
	if (Ph[client][2] >= GetConVarInt(UziLevelUnlock)) Format(text, sizeof(text), "Uzis");
	else Format(text, sizeof(text), "Uzis (Unlocks at Physical Lv.%d)", GetConVarInt(UziLevelUnlock));
	DrawPanelItem(menu, text);
	if (Ph[client][2] >= GetConVarInt(ShotgunLevelUnlock)) Format(text, sizeof(text), "Shotguns");
	else Format(text, sizeof(text), "Shotguns (Unlocks at Physical Lv.%d)", GetConVarInt(ShotgunLevelUnlock));
	DrawPanelItem(menu, text);
	if (Ph[client][2] >= GetConVarInt(SniperLevelUnlock)) Format(text, sizeof(text), "Snipers");
	else Format(text, sizeof(text), "Snipers (Unlocks at Physical Lv.%d)", GetConVarInt(SniperLevelUnlock));
	DrawPanelItem(menu, text);
	if (Ph[client][2] >= GetConVarInt(RifleLevelUnlock)) Format(text, sizeof(text), "Rifles");
	else Format(text, sizeof(text), "Rifles (Unlocks at Physical Lv.%d)", GetConVarInt(RifleLevelUnlock));
	DrawPanelItem(menu, text);
	
	return menu;
}

public Survivor_SetPrimary_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (Ph[client][2] >= GetConVarInt(UziLevelUnlock)) SendPanelToClient(Survivor_SetUzis(client), client, Survivor_SetUzis_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				if (Ph[client][2] >= GetConVarInt(ShotgunLevelUnlock)) SendPanelToClient(Survivor_SetShotgun(client), client, Survivor_SetShotgun_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				if (Ph[client][2] >= GetConVarInt(SniperLevelUnlock)) SendPanelToClient(Survivor_SetSniper(client), client, Survivor_SetSniper_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				if (Ph[client][2] >= GetConVarInt(RifleLevelUnlock)) SendPanelToClient(Survivor_SetRifle(client), client, Survivor_SetRifle_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Survivor_MainMenu(client), client, Survivor_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Survivor_SetSecondary (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[64];
	SetPanelTitle(menu, "Equipment Locker");
	DrawPanelItem(menu, "Pistols");
	if (Ph[client][2] >= GetConVarInt(MeleeLevelUnlock)) Format(text, sizeof(text), "Melee");
	else Format(text, sizeof(text), "Melee (Unlocks at Physical Lv.%d)", GetConVarInt(MeleeLevelUnlock));
	DrawPanelItem(menu, text);
	
	return menu;
}

public Survivor_SetSecondary_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Survivor_SetPistols(client), client, Survivor_SetPistols_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				if (Ph[client][2] >= GetConVarInt(MeleeLevelUnlock)) SendPanelToClient(Survivor_SetMelee(client), client, Survivor_SetMelee_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Survivor_SetPistols (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[64];
	Format(text, sizeof(text), "%N Equipment Locker", client);
	SetPanelTitle(menu, text);
	Format(text, sizeof(text), "Pistols");
	DrawPanelItem(menu, text);
	if (Pi[client][2] >= GetConVarInt(PistolDeagleLevel)) Format(text, sizeof(text), "D. Eagle");
	else Format(text, sizeof(text), "D. Eagle (Unlocks at Pistol Lv. %d)", GetConVarInt(PistolDeagleLevel));
	DrawPanelItem(menu, text);

	return menu;
}

public Survivor_SetPistols_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (PresetViewer[client] == 0) Sw[client][0] = "pistol";
				else if (PresetViewer[client] == 1) Sw[client][1] = "pistol";
				else if (PresetViewer[client] == 2) Sw[client][2] = "pistol";
				else if (PresetViewer[client] == 3) Sw[client][3] = "pistol";
				else if (PresetViewer[client] == 4) Sw[client][4] = "pistol";
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				if (Pi[client][2] >= GetConVarInt(PistolDeagleLevel))
				{
					if (PresetViewer[client] == 0) Sw[client][0] = "pistol_magnum";
					else if (PresetViewer[client] == 1) Sw[client][1] = "pistol_magnum";
					else if (PresetViewer[client] == 2) Sw[client][2] = "pistol_magnum";
					else if (PresetViewer[client] == 3) Sw[client][3] = "pistol_magnum";
					else if (PresetViewer[client] == 4) Sw[client][4] = "pistol_magnum";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Survivor_SetUzis (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[64];
	Format(text, sizeof(text), "%N Equipment Locker", client);
	SetPanelTitle(menu, text);
	if (Uz[client][2] >= GetConVarInt(UziMp5Level)) Format(text, sizeof(text), "Mp5");
	else Format(text, sizeof(text), "Mp5 (Unlocks at Uzi Lv. %d)", GetConVarInt(UziMp5Level));
	DrawPanelItem(menu, text);
	if (Uz[client][2] >= GetConVarInt(UziMac10Level)) Format(text, sizeof(text), "Mac10");
	else Format(text, sizeof(text), "Mac10 (Unlocks at Uzi Lv. %d)", GetConVarInt(UziMac10Level));
	DrawPanelItem(menu, text);
	if (Uz[client][2] >= GetConVarInt(UziTmpLevel)) Format(text, sizeof(text), "Tmp-Silenced");
	else Format(text, sizeof(text), "Tmp-Silenced (Unlocks at Uzi Lv. %d)", GetConVarInt(UziTmpLevel));
	DrawPanelItem(menu, text);

	return menu;
}

public Survivor_SetUzis_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (Uz[client][2] >= GetConVarInt(UziMp5Level))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "smg_mp5";
					else if (PresetViewer[client] == 1) Mw[client][1] = "smg_mp5";
					else if (PresetViewer[client] == 2) Mw[client][2] = "smg_mp5";
					else if (PresetViewer[client] == 3) Mw[client][3] = "smg_mp5";
					else if (PresetViewer[client] == 4) Mw[client][4] = "smg_mp5";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				if (Uz[client][2] >= GetConVarInt(UziMac10Level))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "smg";
					else if (PresetViewer[client] == 1) Mw[client][1] = "smg";
					else if (PresetViewer[client] == 2) Mw[client][2] = "smg";
					else if (PresetViewer[client] == 3) Mw[client][3] = "smg";
					else if (PresetViewer[client] == 4) Mw[client][4] = "smg";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				if (Uz[client][2] >= GetConVarInt(UziTmpLevel))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "smg_silenced";
					else if (PresetViewer[client] == 1) Mw[client][1] = "smg_silenced";
					else if (PresetViewer[client] == 2) Mw[client][2] = "smg_silenced";
					else if (PresetViewer[client] == 3) Mw[client][3] = "smg_silenced";
					else if (PresetViewer[client] == 4) Mw[client][4] = "smg_silenced";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Survivor_SetShotgun (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[64];
	Format(text, sizeof(text), "%N Equipment Locker", client);
	SetPanelTitle(menu, text);
	if (Sh[client][2] >= GetConVarInt(ShotgunChromeLevel)) Format(text, sizeof(text), "Chrome Shotgun");
	else Format(text, sizeof(text), "Chrome Shotgun (Unlocks at Shotgun Lv. %d)", GetConVarInt(ShotgunChromeLevel));
	DrawPanelItem(menu, text);
	if (Sh[client][2] >= GetConVarInt(ShotgunPumpLevel)) Format(text, sizeof(text), "Pump Shotgun");
	else Format(text, sizeof(text), "Pump Shotgun (Unlocks at Shotgun Lv. %d)", GetConVarInt(ShotgunPumpLevel));
	DrawPanelItem(menu, text);
	if (Sh[client][2] >= GetConVarInt(ShotgunSpasLevel)) Format(text, sizeof(text), "SPAS Shotgun");
	else Format(text, sizeof(text), "SPAS Shotgun (Unlocks at Shotgun Lv. %d)", GetConVarInt(ShotgunSpasLevel));
	DrawPanelItem(menu, text);
	if (Sh[client][2] >= GetConVarInt(ShotgunAutoLevel)) Format(text, sizeof(text), "Auto-Shotgun");
	else Format(text, sizeof(text), "Auto-Shotgun (Unlocks at Shotgun Lv. %d)", GetConVarInt(ShotgunAutoLevel));
	DrawPanelItem(menu, text);

	return menu;
}

public Survivor_SetShotgun_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (Sh[client][2] >= GetConVarInt(ShotgunChromeLevel))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "shotgun_chrome";
					else if (PresetViewer[client] == 1) Mw[client][1] = "shotgun_chrome";
					else if (PresetViewer[client] == 2) Mw[client][2] = "shotgun_chrome";
					else if (PresetViewer[client] == 3) Mw[client][3] = "shotgun_chrome";
					else if (PresetViewer[client] == 4) Mw[client][4] = "shotgun_chrome";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				if (Sh[client][2] >= GetConVarInt(ShotgunPumpLevel))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "pumpshotgun";
					else if (PresetViewer[client] == 1) Mw[client][1] = "pumpshotgun";
					else if (PresetViewer[client] == 2) Mw[client][2] = "pumpshotgun";
					else if (PresetViewer[client] == 3) Mw[client][3] = "pumpshotgun";
					else if (PresetViewer[client] == 4) Mw[client][4] = "pumpshotgun";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				if (Sh[client][2] >= GetConVarInt(ShotgunSpasLevel))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "shotgun_spas";
					else if (PresetViewer[client] == 1) Mw[client][1] = "shotgun_spas";
					else if (PresetViewer[client] == 2) Mw[client][2] = "shotgun_spas";
					else if (PresetViewer[client] == 3) Mw[client][3] = "shotgun_spas";
					else if (PresetViewer[client] == 4) Mw[client][4] = "shotgun_spas";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				if (Sh[client][2] >= GetConVarInt(ShotgunAutoLevel))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "autoshotgun";
					else if (PresetViewer[client] == 1) Mw[client][1] = "autoshotgun";
					else if (PresetViewer[client] == 2) Mw[client][2] = "autoshotgun";
					else if (PresetViewer[client] == 3) Mw[client][3] = "autoshotgun";
					else if (PresetViewer[client] == 4) Mw[client][4] = "autoshotgun";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Survivor_SetSniper (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[64];
	Format(text, sizeof(text), "%N Equipment Locker", client);
	SetPanelTitle(menu, text);
	if (Sn[client][2] >= GetConVarInt(SniperScoutLevel)) Format(text, sizeof(text), "Scout");
	else Format(text, sizeof(text), "Scout (Unlocks at Sniper Lv. %d)", GetConVarInt(SniperScoutLevel));
	DrawPanelItem(menu, text);
	if (Sn[client][2] >= GetConVarInt(SniperAwpLevel)) Format(text, sizeof(text), "AWP");
	else Format(text, sizeof(text), "AWP (Unlocks at Sniper Lv. %d)", GetConVarInt(SniperAwpLevel));
	DrawPanelItem(menu, text);
	if (Sn[client][2] >= GetConVarInt(SniperMilitaryLevel)) Format(text, sizeof(text), "Military");
	else Format(text, sizeof(text), "Military (Unlocks at Sniper Lv. %d)", GetConVarInt(SniperMilitaryLevel));
	DrawPanelItem(menu, text);
	if (Sn[client][2] >= GetConVarInt(SniperHuntingLevel)) Format(text, sizeof(text), "Hunting Rifle");
	else Format(text, sizeof(text), "Hunting Rifle (Unlocks at Sniper Lv. %d)", GetConVarInt(SniperHuntingLevel));
	DrawPanelItem(menu, text);

	return menu;
}

public Survivor_SetSniper_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (Sn[client][2] >= GetConVarInt(SniperScoutLevel))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "sniper_scout";
					else if (PresetViewer[client] == 1) Mw[client][1] = "sniper_scout";
					else if (PresetViewer[client] == 2) Mw[client][2] = "sniper_scout";
					else if (PresetViewer[client] == 3) Mw[client][3] = "sniper_scout";
					else if (PresetViewer[client] == 4) Mw[client][4] = "sniper_scout";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				if (Sn[client][2] >= GetConVarInt(SniperAwpLevel))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "sniper_awp";
					else if (PresetViewer[client] == 1) Mw[client][1] = "sniper_awp";
					else if (PresetViewer[client] == 2) Mw[client][2] = "sniper_awp";
					else if (PresetViewer[client] == 3) Mw[client][3] = "sniper_awp";
					else if (PresetViewer[client] == 4) Mw[client][4] = "sniper_awp";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				if (Sn[client][2] >= GetConVarInt(SniperMilitaryLevel))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "sniper_military";
					else if (PresetViewer[client] == 1) Mw[client][1] = "sniper_military";
					else if (PresetViewer[client] == 2) Mw[client][2] = "sniper_military";
					else if (PresetViewer[client] == 3) Mw[client][3] = "sniper_military";
					else if (PresetViewer[client] == 4) Mw[client][4] = "sniper_military";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				if (Sn[client][2] >= GetConVarInt(SniperHuntingLevel))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "hunting_rifle";
					else if (PresetViewer[client] == 1) Mw[client][1] = "hunting_rifle";
					else if (PresetViewer[client] == 2) Mw[client][2] = "hunting_rifle";
					else if (PresetViewer[client] == 3) Mw[client][3] = "hunting_rifle";
					else if (PresetViewer[client] == 4) Mw[client][4] = "hunting_rifle";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Survivor_SetRifle (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[64];
	Format(text, sizeof(text), "%N Equipment Locker", client);
	SetPanelTitle(menu, text);
	if (Ri[client][2] >= GetConVarInt(RifleDesertLevel)) Format(text, sizeof(text), "Desert Rifle");
	else Format(text, sizeof(text), "Desert Rifle (Unlocks at Rifle Lv. %d)", GetConVarInt(RifleDesertLevel));
	DrawPanelItem(menu, text);
	if (Ri[client][2] >= GetConVarInt(RifleM16Level)) Format(text, sizeof(text), "M16");
	else Format(text, sizeof(text), "M16 (Unlocks at Rifle Lv. %d)", GetConVarInt(RifleM16Level));
	DrawPanelItem(menu, text);
	if (Ri[client][2] >= GetConVarInt(RifleSG552Level)) Format(text, sizeof(text), "SG552");
	else Format(text, sizeof(text), "SG552 (Unlocks at Rifle Lv. %d)", GetConVarInt(RifleSG552Level));
	DrawPanelItem(menu, text);
	if (Ri[client][2] >= GetConVarInt(RifleAK47Level)) Format(text, sizeof(text), "AK47");
	else Format(text, sizeof(text), "AK47 (Unlocks at Rifle Lv. %d)", GetConVarInt(RifleAK47Level));
	DrawPanelItem(menu, text);
	if (Ri[client][2] >= GetConVarInt(RifleM60Level) && !M60CD[client]) Format(text, sizeof(text), "M60");
	else if (M60CD[client]) Format(text, sizeof(text), "M60 %3.1f sec(s) cooldown", GetConVarFloat(M60CDTIME) - M60COUNT[client]);
	else Format(text, sizeof(text), "M60 (Unlocks at Rifle Lv. %d)", GetConVarInt(RifleM60Level));
	DrawPanelItem(menu, text);

	return menu;
}

public Survivor_SetRifle_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (Ri[client][2] >= GetConVarInt(RifleDesertLevel))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "rifle_desert";
					else if (PresetViewer[client] == 1) Mw[client][1] = "rifle_desert";
					else if (PresetViewer[client] == 2) Mw[client][2] = "rifle_desert";
					else if (PresetViewer[client] == 3) Mw[client][3] = "rifle_desert";
					else if (PresetViewer[client] == 4) Mw[client][4] = "rifle_desert";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				if (Ri[client][2] >= GetConVarInt(RifleM16Level))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "rifle";
					else if (PresetViewer[client] == 1) Mw[client][1] = "rifle";
					else if (PresetViewer[client] == 2) Mw[client][2] = "rifle";
					else if (PresetViewer[client] == 3) Mw[client][3] = "rifle";
					else if (PresetViewer[client] == 4) Mw[client][4] = "rifle";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				if (Ri[client][2] >= GetConVarInt(RifleSG552Level))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "rifle_sg552";
					else if (PresetViewer[client] == 1) Mw[client][1] = "rifle_sg552";
					else if (PresetViewer[client] == 2) Mw[client][2] = "rifle_sg552";
					else if (PresetViewer[client] == 3) Mw[client][3] = "rifle_sg552";
					else if (PresetViewer[client] == 4) Mw[client][4] = "rifle_sg552";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				if (Ri[client][2] >= GetConVarInt(RifleAK47Level))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "rifle_ak47";
					else if (PresetViewer[client] == 1) Mw[client][1] = "rifle_ak47";
					else if (PresetViewer[client] == 2) Mw[client][2] = "rifle_ak47";
					else if (PresetViewer[client] == 3) Mw[client][3] = "rifle_ak47";
					else if (PresetViewer[client] == 4) Mw[client][4] = "rifle_ak47";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				if (Ri[client][2] >= GetConVarInt(RifleM60Level))
				{
					if (PresetViewer[client] == 0) Mw[client][0] = "rifle_m60";
					else if (PresetViewer[client] == 1) Mw[client][1] = "rifle_m60";
					else if (PresetViewer[client] == 2) Mw[client][2] = "rifle_m60";
					else if (PresetViewer[client] == 3) Mw[client][3] = "rifle_m60";
					else if (PresetViewer[client] == 4) Mw[client][4] = "rifle_m60";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Survivor_SetMelee (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[64];
	Format(text, sizeof(text), "%N Equipment Locker", client);
	SetPanelTitle(menu, text);
	if (Me[client][2] >= GetConVarInt(MelGuitarLevel)) Format(text, sizeof(text), "Electric Guitar");
	else Format(text, sizeof(text), "Electric Guitar (Unlocks at Mel Lv. %d)", GetConVarInt(MelGuitarLevel));
	DrawPanelItem(menu, text);
	if (Me[client][2] >= GetConVarInt(MelPanLevel)) Format(text, sizeof(text), "Frying Pan");
	else Format(text, sizeof(text), "Frying Pan (Unlocks at Mel Lv. %d)", GetConVarInt(MelPanLevel));
	DrawPanelItem(menu, text);
	if (Me[client][2] >= GetConVarInt(MelCricketLevel)) Format(text, sizeof(text), "Cricket Bat");
	else Format(text, sizeof(text), "Cricket Bat (Unlocks at Mel Lv. %d)", GetConVarInt(MelCricketLevel));
	DrawPanelItem(menu, text);
	if (Me[client][2] >= GetConVarInt(MelFireaxeLevel)) Format(text, sizeof(text), "Fireaxe");
	else Format(text, sizeof(text), "Fireaxe (Unlocks at Mel Lv. %d)", GetConVarInt(MelFireaxeLevel));
	DrawPanelItem(menu, text);
	if (Me[client][2] >= GetConVarInt(MelGolfclubLevel)) Format(text, sizeof(text), "Golf Club");
	else Format(text, sizeof(text), "Golf Club (Unlocks at Mel Lv. %d)", GetConVarInt(MelGolfclubLevel));
	DrawPanelItem(menu, text);
	if (Me[client][2] >= GetConVarInt(MelTonfaLevel)) Format(text, sizeof(text), "Tonfa");
	else Format(text, sizeof(text), "Tonfa (Unlocks at Mel Lv. %d)", GetConVarInt(MelTonfaLevel));
	DrawPanelItem(menu, text);
	if (Me[client][2] >= GetConVarInt(MelChainsawLevel)) Format(text, sizeof(text), "Chainsaw");
	else Format(text, sizeof(text), "Chainsaw (Unlocks at Mel Lv. %d)", GetConVarInt(MelChainsawLevel));
	DrawPanelItem(menu, text);
	if (Me[client][2] >= GetConVarInt(MelMacheteLevel)) Format(text, sizeof(text), "Machete");
	else Format(text, sizeof(text), "Machete (Unlocks at Mel Lv. %d)", GetConVarInt(MelMacheteLevel));
	DrawPanelItem(menu, text);

	return menu;
}

public Survivor_SetMelee_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (Me[client][2] >= GetConVarInt(MelGuitarLevel))
				{
					if (PresetViewer[client] == 0) Sw[client][0] = "electric_guitar";
					else if (PresetViewer[client] == 1) Sw[client][1] = "electric_guitar";
					else if (PresetViewer[client] == 2) Sw[client][2] = "electric_guitar";
					else if (PresetViewer[client] == 3) Sw[client][3] = "electric_guitar";
					else if (PresetViewer[client] == 4) Sw[client][4] = "electric_guitar";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				if (Me[client][2] >= GetConVarInt(MelPanLevel))
				{
					if (PresetViewer[client] == 0) Sw[client][0] = "frying_pan";
					else if (PresetViewer[client] == 1) Sw[client][1] = "frying_pan";
					else if (PresetViewer[client] == 2) Sw[client][2] = "frying_pan";
					else if (PresetViewer[client] == 3) Sw[client][3] = "frying_pan";
					else if (PresetViewer[client] == 4) Sw[client][4] = "frying_pan";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				if (Me[client][2] >= GetConVarInt(MelCricketLevel))
				{
					if (PresetViewer[client] == 0) Sw[client][0] = "cricket_bat";
					else if (PresetViewer[client] == 1) Sw[client][1] = "cricket_bat";
					else if (PresetViewer[client] == 2) Sw[client][2] = "cricket_bat";
					else if (PresetViewer[client] == 3) Sw[client][3] = "cricket_bat";
					else if (PresetViewer[client] == 4) Sw[client][4] = "cricket_bat";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				if (Me[client][2] >= GetConVarInt(MelFireaxeLevel))
				{
					if (PresetViewer[client] == 0) Sw[client][0] = "fireaxe";
					else if (PresetViewer[client] == 1) Sw[client][1] = "fireaxe";
					else if (PresetViewer[client] == 2) Sw[client][2] = "fireaxe";
					else if (PresetViewer[client] == 3) Sw[client][3] = "fireaxe";
					else if (PresetViewer[client] == 4) Sw[client][4] = "fireaxe";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				if (Me[client][2] >= GetConVarInt(MelGolfclubLevel))
				{
					if (PresetViewer[client] == 0) Sw[client][0] = "golfclub";
					else if (PresetViewer[client] == 1) Sw[client][1] = "golfclub";
					else if (PresetViewer[client] == 2) Sw[client][2] = "golfclub";
					else if (PresetViewer[client] == 3) Sw[client][3] = "golfclub";
					else if (PresetViewer[client] == 4) Sw[client][4] = "golfclub";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 6:
			{
				if (Me[client][2] >= GetConVarInt(MelTonfaLevel))
				{
					if (PresetViewer[client] == 0) Sw[client][0] = "tonfa";
					else if (PresetViewer[client] == 1) Sw[client][1] = "tonfa";
					else if (PresetViewer[client] == 2) Sw[client][2] = "tonfa";
					else if (PresetViewer[client] == 3) Sw[client][3] = "tonfa";
					else if (PresetViewer[client] == 4) Sw[client][4] = "tonfa";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 7:
			{
				if (Me[client][2] >= GetConVarInt(MelChainsawLevel))
				{
					if (PresetViewer[client] == 0) Sw[client][0] = "chainsaw";
					else if (PresetViewer[client] == 1) Sw[client][1] = "chainsaw";
					else if (PresetViewer[client] == 2) Sw[client][2] = "chainsaw";
					else if (PresetViewer[client] == 3) Sw[client][3] = "chainsaw";
					else if (PresetViewer[client] == 4) Sw[client][4] = "chainsaw";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 8:
			{
				if (Me[client][2] >= GetConVarInt(MelMacheteLevel))
				{
					if (PresetViewer[client] == 0) Sw[client][0] = "machete";
					else if (PresetViewer[client] == 1) Sw[client][1] = "machete";
					else if (PresetViewer[client] == 2) Sw[client][2] = "machete";
					else if (PresetViewer[client] == 3) Sw[client][3] = "machete";
					else if (PresetViewer[client] == 4) Sw[client][4] = "machete";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Survivor_SetGrenade (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[64];
	Format(text, sizeof(text), "%N Equipment Locker", client);
	SetPanelTitle(menu, text);
	
	if (Gr[client][2] >= GetConVarInt(GrenPipeLevel))
	{
		Format(text, sizeof(text), "Pipe Bomb");
	}
	else Format(text, sizeof(text), "Pipe Bomb (Unlocks at Grenade Lv. %d)", GetConVarInt(GrenPipeLevel));
	DrawPanelItem(menu, text);
	
	if (Gr[client][2] >= GetConVarInt(GrenJarLevel))
	{
		Format(text, sizeof(text), "Vomit Jar");
	}
	else Format(text, sizeof(text), "Vomit Jar (Unlocks at Grenade Lv. %d)", GetConVarInt(GrenJarLevel));
	DrawPanelItem(menu, text);
	
	if (Gr[client][2] >= GetConVarInt(GrenMolLevel))
	{
		Format(text, sizeof(text), "Molotov");
	}
	else Format(text, sizeof(text), "Molotov (Unlocks at Grenade Lv. %d)", GetConVarInt(GrenMolLevel));
	DrawPanelItem(menu, text);

	return menu;
}

public Survivor_SetGrenade_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (Gr[client][2] >= GetConVarInt(GrenPipeLevel) && GrenadeCount[client] > 0)
				{
					if (PresetViewer[client] == 0) Gi[client][0] = "pipe_bomb";
					else if (PresetViewer[client] == 1) Gi[client][1] = "pipe_bomb";
					else if (PresetViewer[client] == 2) Gi[client][2] = "pipe_bomb";
					else if (PresetViewer[client] == 3) Gi[client][3] = "pipe_bomb";
					else if (PresetViewer[client] == 4) Gi[client][4] = "pipe_bomb";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				if (Gr[client][2] >= GetConVarInt(GrenJarLevel) && GrenadeCount[client] > 0)
				{
					if (PresetViewer[client] == 0) Gi[client][0] = "vomitjar";
					else if (PresetViewer[client] == 1) Gi[client][1] = "vomitjar";
					else if (PresetViewer[client] == 2) Gi[client][2] = "vomitjar";
					else if (PresetViewer[client] == 3) Gi[client][3] = "vomitjar";
					else if (PresetViewer[client] == 4) Gi[client][4] = "vomitjar";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				if (Gr[client][2] >= GetConVarInt(GrenMolLevel) && GrenadeCount[client] > 0)
				{
					if (PresetViewer[client] == 0) Gi[client][0] = "molotov";
					else if (PresetViewer[client] == 1) Gi[client][1] = "molotov";
					else if (PresetViewer[client] == 2) Gi[client][2] = "molotov";
					else if (PresetViewer[client] == 3) Gi[client][3] = "molotov";
					else if (PresetViewer[client] == 4) Gi[client][4] = "molotov";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Survivor_SetItem (client)
{
	new Handle:menu = CreatePanel();
	
	new String:text[64];
	Format(text, sizeof(text), "%N Equipment Locker", client);
	SetPanelTitle(menu, text);
	
	if (It[client][2] >= GetConVarInt(HealthPillsLevel))
	{
		Format(text, sizeof(text), "Pain Killers");
	}
	else Format(text, sizeof(text), "Pain Killers (Unlocks at Health Lv. %d)", GetConVarInt(HealthPillsLevel));
	DrawPanelItem(menu, text);
	
	if (It[client][2] >= GetConVarInt(HealthPackLevel))
	{
		Format(text, sizeof(text), "Medkits");
	}
	else Format(text, sizeof(text), "Medkits (Unlocks at Health Lv. %d)", GetConVarInt(HealthPackLevel));
	DrawPanelItem(menu, text);
	
	if (It[client][2] >= GetConVarInt(HealthAdrenLevel))
	{
		Format(text, sizeof(text), "Adrenaline");
	}
	else Format(text, sizeof(text), "Adrenaline (Unlocks at Health Lv. %d)", GetConVarInt(HealthAdrenLevel));
	DrawPanelItem(menu, text);
	
	if (It[client][2] >= GetConVarInt(HealthIncapLevel))
	{
		Format(text, sizeof(text), "Incap Protection");
	}
	else Format(text, sizeof(text), "Incap Protection (Unlocks at Health Lv. %d)", GetConVarInt(HealthIncapLevel));
	DrawPanelItem(menu, text);
	
	return menu;
}

public Survivor_SetItem_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				if (It[client][2] >= GetConVarInt(HealthPillsLevel) && TempHealCount[client] > 0)
				{
					if (PresetViewer[client] == 0) Hi[client][0] = "pain_pills";
					else if (PresetViewer[client] == 1) Hi[client][1] = "pain_pills";
					else if (PresetViewer[client] == 2) Hi[client][2] = "pain_pills";
					else if (PresetViewer[client] == 3) Hi[client][3] = "pain_pills";
					else if (PresetViewer[client] == 4) Hi[client][4] = "pain_pills";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				if (It[client][2] >= GetConVarInt(HealthPackLevel) && HealCount[client] > 0)
				{
					if (PresetViewer[client] == 0) Hi[client][0] = "first_aid_kit";
					else if (PresetViewer[client] == 1) Hi[client][1] = "first_aid_kit";
					else if (PresetViewer[client] == 2) Hi[client][2] = "first_aid_kit";
					else if (PresetViewer[client] == 3) Hi[client][3] = "first_aid_kit";
					else if (PresetViewer[client] == 4) Hi[client][4] = "first_aid_kit";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				if (It[client][2] >= GetConVarInt(HealthAdrenLevel) && TempHealCount[client] > 0)
				{
					if (PresetViewer[client] == 0) Hi[client][0] = "adrenaline";
					else if (PresetViewer[client] == 1) Hi[client][1] = "adrenaline";
					else if (PresetViewer[client] == 2) Hi[client][2] = "adrenaline";
					else if (PresetViewer[client] == 3) Hi[client][3] = "adrenaline";
					else if (PresetViewer[client] == 4) Hi[client][4] = "adrenaline";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				if (It[client][2] >= GetConVarInt(HealthIncapLevel) && HealCount[client] > 0)
				{
					if (PresetViewer[client] == 0) Hi[client][0] = "incap_protection";
					else if (PresetViewer[client] == 1) Hi[client][1] = "incap_protection";
					else if (PresetViewer[client] == 2) Hi[client][2] = "incap_protection";
					else if (PresetViewer[client] == 3) Hi[client][3] = "incap_protection";
					else if (PresetViewer[client] == 4) Hi[client][4] = "incap_protection";
				}
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Customize_Settings(client), client, Customize_Settings_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

// Load player preset data
LoadPresets(client)
{
	if (PresetViewer[client] == 0 && !StrEqual(Sw[client][0], "none") || 
		PresetViewer[client] == 1 && !StrEqual(Sw[client][1], "none") || 
		PresetViewer[client] == 2 && !StrEqual(Sw[client][2], "none") || 
		PresetViewer[client] == 3 && !StrEqual(Sw[client][3], "none") || 
		PresetViewer[client] == 4 && !StrEqual(Sw[client][4], "none"))
	{
		L4D_RemoveWeaponSlot(client, L4DWeaponSlot_Secondary);
		if (PresetViewer[client] == 0) ExecCheatCommand(client, "give", Sw[client][0]);
		else if (PresetViewer[client] == 1) ExecCheatCommand(client, "give", Sw[client][1]);
		else if (PresetViewer[client] == 2) ExecCheatCommand(client, "give", Sw[client][2]);
		else if (PresetViewer[client] == 3) ExecCheatCommand(client, "give", Sw[client][3]);
		else if (PresetViewer[client] == 4) ExecCheatCommand(client, "give", Sw[client][4]);
	}
	if (PresetViewer[client] == 0 && !StrEqual(Hi[client][0], "none") || 
		PresetViewer[client] == 1 && !StrEqual(Hi[client][1], "none") || 
		PresetViewer[client] == 2 && !StrEqual(Hi[client][2], "none") || 
		PresetViewer[client] == 3 && !StrEqual(Hi[client][3], "none") || 
		PresetViewer[client] == 4 && !StrEqual(Hi[client][4], "none"))
	{
		if (PresetViewer[client] == 0 && (StrEqual(Hi[client][0], "pain_pills") || StrEqual(Hi[client][0], "adrenaline")) || 
			PresetViewer[client] == 1 && (StrEqual(Hi[client][1], "pain_pills") || StrEqual(Hi[client][1], "adrenaline")) || 
			PresetViewer[client] == 2 && (StrEqual(Hi[client][2], "pain_pills") || StrEqual(Hi[client][2], "adrenaline")) || 
			PresetViewer[client] == 3 && (StrEqual(Hi[client][3], "pain_pills") || StrEqual(Hi[client][3], "adrenaline")) || 
			PresetViewer[client] == 4 && (StrEqual(Hi[client][4], "pain_pills") || StrEqual(Hi[client][4], "adrenaline")))
		{
			if (TempHealCount[client] > 0)
			{
				L4D_RemoveWeaponSlot(client, L4DWeaponSlot_Pills);
				TempHealCount[client]--;
				if (PresetViewer[client] == 0) ExecCheatCommand(client, "give", Hi[client][0]);
				else if (PresetViewer[client] == 1) ExecCheatCommand(client, "give", Hi[client][1]);
				else if (PresetViewer[client] == 2) ExecCheatCommand(client, "give", Hi[client][2]);
				else if (PresetViewer[client] == 3) ExecCheatCommand(client, "give", Hi[client][3]);
				else if (PresetViewer[client] == 4) ExecCheatCommand(client, "give", Hi[client][4]);
			}
		}
		else if (PresetViewer[client] == 0 && StrEqual(Hi[client][0], "first_aid_kit") || 
				 PresetViewer[client] == 1 && StrEqual(Hi[client][1], "first_aid_kit") || 
				 PresetViewer[client] == 2 && StrEqual(Hi[client][2], "first_aid_kit") || 
				 PresetViewer[client] == 3 && StrEqual(Hi[client][3], "first_aid_kit") || 
				 PresetViewer[client] == 4 && StrEqual(Hi[client][4], "first_aid_kit"))
		{
			if (HealCount[client] > 0)
			{
				L4D_RemoveWeaponSlot(client, L4DWeaponSlot_FirstAid);
				HealCount[client]--;
				if (PresetViewer[client] == 0) ExecCheatCommand(client, "give", Hi[client][0]);
				else if (PresetViewer[client] == 1) ExecCheatCommand(client, "give", Hi[client][1]);
				else if (PresetViewer[client] == 2) ExecCheatCommand(client, "give", Hi[client][2]);
				else if (PresetViewer[client] == 3) ExecCheatCommand(client, "give", Hi[client][3]);
				else if (PresetViewer[client] == 4) ExecCheatCommand(client, "give", Hi[client][4]);
			}
		}
		else if (PresetViewer[client] == 0 && StrEqual(Hi[client][0], "incap_protection") || 
				 PresetViewer[client] == 1 && StrEqual(Hi[client][1], "incap_protection") || 
				 PresetViewer[client] == 2 && StrEqual(Hi[client][2], "incap_protection") || 
				 PresetViewer[client] == 3 && StrEqual(Hi[client][3], "incap_protection") || 
				 PresetViewer[client] == 4 && StrEqual(Hi[client][4], "incap_protection"))
		{
			if (HealCount[client] > 0 && IncapProtection[client] == 0)
			{
				PrintToChat(client, "%s \x01Incap Protection Added.", INFO);
				IncapProtection[client] = GetConVarInt(IncapCount);
				HealCount[client]--;
				CreateTimer(1.0, CheckIfEnsnared, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);	
			}
		}
	}
	if (PresetViewer[client] == 0 && !StrEqual(Gi[client][0], "none") || 
		PresetViewer[client] == 1 && !StrEqual(Gi[client][1], "none") || 
		PresetViewer[client] == 2 && !StrEqual(Gi[client][2], "none") || 
		PresetViewer[client] == 3 && !StrEqual(Gi[client][3], "none") || 
		PresetViewer[client] == 4 && !StrEqual(Gi[client][4], "none"))
	{
		if (GrenadeCount[client] > 0)
		{
			L4D_RemoveWeaponSlot(client, L4DWeaponSlot_Grenade);
			if (PresetViewer[client] == 0) ExecCheatCommand(client, "give", Gi[client][0]);
			else if (PresetViewer[client] == 1) ExecCheatCommand(client, "give", Gi[client][1]);
			else if (PresetViewer[client] == 2) ExecCheatCommand(client, "give", Gi[client][2]);
			else if (PresetViewer[client] == 3) ExecCheatCommand(client, "give", Gi[client][3]);
			else if (PresetViewer[client] == 4) ExecCheatCommand(client, "give", Gi[client][4]);
			GrenadeCount[client]--;
		}
	}

	// We give the primary last, so it's in their hands when they begin.
	// We also do this so that when ammo upgrades gets added to the preset screen
	// that the correct weapon gets the ammo added to it.

	if (PresetViewer[client] == 0 && !StrEqual(Mw[client][0], "none") || 
		PresetViewer[client] == 1 && !StrEqual(Mw[client][1], "none") || 
		PresetViewer[client] == 2 && !StrEqual(Mw[client][2], "none") || 
		PresetViewer[client] == 3 && !StrEqual(Mw[client][3], "none") || 
		PresetViewer[client] == 4 && !StrEqual(Mw[client][4], "none"))
	{
		if (PresetViewer[client] == 0 && StrEqual(Mw[client][0], "rifle_m60") || 
			PresetViewer[client] == 1 && StrEqual(Mw[client][1], "rifle_m60") || 
			PresetViewer[client] == 2 && StrEqual(Mw[client][2], "rifle_m60") || 
			PresetViewer[client] == 3 && StrEqual(Mw[client][3], "rifle_m60") || 
			PresetViewer[client] == 4 && StrEqual(Mw[client][4], "rifle_m60"))
		{
			if (M60CD[client]) return;
			M60CD[client] = true;
			M60COUNT[client] = -1.0;
			CreateTimer(1.0, EnableM60, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		L4D_RemoveWeaponSlot(client, L4DWeaponSlot_Primary);
		if (PresetViewer[client] == 0)
		{
			ExecCheatCommand(client, "give", Mw[client][0]);
			LastWeaponOwned[client] = Mw[client][0];
		}
		else if (PresetViewer[client] == 1)
		{
			ExecCheatCommand(client, "give", Mw[client][1]);
			LastWeaponOwned[client] = Mw[client][1];
		}
		else if (PresetViewer[client] == 2)
		{
			ExecCheatCommand(client, "give", Mw[client][2]);
			LastWeaponOwned[client] = Mw[client][2];
		}
		else if (PresetViewer[client] == 3)
		{
			ExecCheatCommand(client, "give", Mw[client][3]);
			LastWeaponOwned[client] = Mw[client][3];
		}
		else if (PresetViewer[client] == 4)
		{
			ExecCheatCommand(client, "give", Mw[client][4]);
			LastWeaponOwned[client] = Mw[client][4];
		}
		ExecCheatCommand(client, "upgrade_add", "LASER_SIGHT");
	}
}