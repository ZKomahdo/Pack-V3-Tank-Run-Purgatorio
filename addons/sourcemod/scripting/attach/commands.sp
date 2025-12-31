public Commands_OnPluginStart()
{
	RegConsoleCmd("up", Command_OpenMenu);
	RegConsoleCmd("usepoints", Command_OpenMenu);
	RegConsoleCmd("buy", Command_OpenMenu);
}

public Action:Command_OpenMenu(client, args)
{
	// At some point, when the RPG Module is created, I'll update this section.
	// Until then we'll just go ahead and fast-forward to the usepoints menu.

	if (args < 1 || GetClientTeam(client) != TEAM_SURVIVORS)
	{
		if (GetClientTeam(client) == TEAM_SURVIVORS) SendPanelToClient(Points_SurvivorMenu(client), client, Points_SurvivorMenu_Init, MENU_TIME_FOREVER);
		else if (GetClientTeam(client) == TEAM_INFECTED) SendPanelToClient(Points_InfectedMenu(client), client, Points_InfectedMenu_Init, MENU_TIME_FOREVER);
	}
	else
	{
		decl String:CMD[128];
		GetCmdArg(1, CMD, sizeof(CMD));
		if (GetClientTeam(client) == 2)
		{
			ItemName[client] = CMD;
			if (StrEqual(CMD, "help"))
			{
				PrintToChat(client, "%s - \x01Commands have been printed to your console.", INFO_GENERAL);
				PrintToConsole(client, "rifle_ak47 , rifle_m60 , grenade_launcher , chainsaw");						// purchase item = 0;
				PrintToConsole(client, "bloat_ammo , blind_ammo , slowmo_ammo , beanbag_ammo , spatial_ammo");		// purchase item = 1;
				PrintToConsole(client, "health , adrenaline , first_aid_kit , pain_pills");							// purchase item = 2;
				PrintToConsole(client, "molotov , vomitjar , pipe_bomb");											// purchase item = 3;
			}
			else if (StrEqual(CMD, "rifle_ak47") || StrEqual(CMD, "rifle_m60") || StrEqual(CMD, "grenade_launcher") || StrEqual(CMD, "chainsaw")) PurchaseItem[client] = 0;
			else if (StrEqual(CMD, "bloat_ammo") || StrEqual(CMD, "blind_ammo") || StrEqual(CMD, "slowmo_ammo") || StrEqual(CMD, "beanbag_ammo") || StrEqual(CMD, "spatial_ammo")) PurchaseItem[client] = 1;
			else if (StrEqual(CMD, "health") || StrEqual(CMD, "adrenaline") || StrEqual(CMD, "first_aid_kit") || StrEqual(CMD, "pain_pills")) PurchaseItem[client] = 2;
			else if (StrEqual(CMD, "molotov") || StrEqual(CMD, "vomitjar") || StrEqual(CMD, "pipe_bomb")) PurchaseItem[client] = 3;

			if (!StrEqual(CMD, "help")) SurvivorPurchaseFunc(client);
		}
	}
}