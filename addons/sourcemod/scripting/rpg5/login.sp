/*		If a player is connected to the server, pull their database information.	*/

public OnClientPostAdminCheck(client)
{
	// After we clear data, we try to load their data. We clear in case they join
	// and take over someone elses playerID.
	if (IsHuman(client))
	{
		ClearData(client);
		SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
		if (!RoundReset) SetTeamBonusValue();
	}
}

public Action:SavePlayerData(Handle:timer, any:client)
{
	if (!IsHuman(client)) return Plugin_Stop;
	if (Ph[client][2] > 1 && Ph[client][2] > 1 && 
		In[client][2] > 1 && In[client][2] > 1)
	{
		SaveData(client);
	}
	return Plugin_Stop;
}

/*		If a player is human, when they disconnect from the server, save their data.	*/
/*		BUT only save their data if their levels are > 0 (i.e. if they've loaded data)	*/

public OnClientDisconnect(client)
{
	if (IsClientConnected(client) && IsClientInGame(client))
	{
		SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
		if (GetClientTeam(client) == 2 && !RoundReset) SetTeamBonusValue();
		if (GetClientTeam(client) == 3 && ClassTank[client] == true)
		{
			TankCount--;
			TankCooldownTime = -1.0;
			if (TankCount < 1)
			{
				TankCount = 0;
				CreateTimer(1.0, EnableTankPurchases, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		decl String:clientName[256];
		GetClientName(client, clientName, sizeof(clientName));
		decl String:clientCheckName[256];
		if (!IsClientIndexOutOfRange(VipName) && IsClientConnected(VipName) && IsClientInGame(client))
		{
			GetClientName(VipName, clientCheckName, sizeof(clientCheckName));
			if (StrEqual(clientName, clientCheckName, false) && !RoundReset)
			{
				// Client was the VIP... Assign a new VIP.
				SetTheVip();
			}
		}
		if (StrContains(clientName, "`", false) > -1 || StrContains(clientName, "'", false) > -1) return;
		if (Ph[client][2] > 1 && Ph[client][2] > 1 && 
			In[client][2] > 1 && In[client][2] > 1)
		{
			SaveData(client);
		}
		if (!RoundReset) SetTeamBonusValue();
	}
}

/*		Clear player data, and then attempt to load correct data.		*/
ClearData(client)
{
	Ensnared[client] = false;
	LocationSaved[client] = false;
	showpoints[client] = true;
	Pi[client][0] = 0;
	Pi[client][2] = 0;
	Pi[client][1] = 0;
	Me[client][0] = 0;
	Me[client][2] = 0;
	Me[client][1] = 0;
	Uz[client][0] = 0;
	Uz[client][2] = 0;
	Uz[client][1] = 0;
	Sh[client][0] = 0;
	Sh[client][2] = 0;
	Sh[client][1] = 0;
	Sn[client][0] = 0;
	Sn[client][2] = 0;
	Sn[client][1] = 0;
	Ri[client][0] = 0;
	Ri[client][2] = 0;
	Ri[client][1] = 0;
	Gr[client][0] = 0;
	Gr[client][2] = 0;
	Gr[client][1] = 0;
	It[client][0] = 0;
	It[client][2] = 0;
	It[client][1] = 0;
	Ph[client][0] = 0;
	Ph[client][2] = 0;
	Ph[client][1] = 0;

	// Infected XP Levels
	Hu[client][0] = 0;
	Hu[client][2] = 0;
	Hu[client][1] = 0;
	Sm[client][0] = 0;
	Sm[client][2] = 0;
	Sm[client][1] = 0;
	Bo[client][0] = 0;
	Bo[client][2] = 0;
	Bo[client][1] = 0;
	Jo[client][0] = 0;
	Jo[client][2] = 0;
	Jo[client][1] = 0;
	Ch[client][0] = 0;
	Ch[client][2] = 0;
	Ch[client][1] = 0;
	Sp[client][0] = 0;
	Sp[client][2] = 0;
	Sp[client][1] = 0;
	Ta[client][0] = 0;
	Ta[client][2] = 0;
	Ta[client][1] = 0;
	In[client][0] = 0;
	In[client][2] = 0;
	In[client][1] = 0;
	Ach[client][0] = 0;
	Ach[client][1] = 0;

	// Reset Presets
	for (new i = 0; i <= 4; i++)
	{
		Mw[client][i] = "None";
		Sw[client][i] = "None";
		Hi[client][i] = "None";
		Gi[client][i] = "None";
	}

	SkyPoints[client] = 0;
	XPMultiplierTime[client] = 0;
	Bounty[client] = 0;
	
	/*	Try to Load Their Data	*/
	decl String:clientName[256];
	GetClientName(client, clientName, sizeof(clientName));
	//if (!StrContains(clientName, "`", false) > -1 && !StrContains(clientName, "'", false) > -1)
	LoadData(client);
	if (bAllClientsLoaded) CreateTimer(5.0, DisplayConnectMessage, client, TIMER_FLAG_NO_MAPCHANGE);
}

public Action:DisplayConnectMessage(Handle:timer, any:client)
{
	if (IsClientConnected(client) && !IsFakeClient(client) && GetClientTeam(client) != 1 && Ph[client][2] > 0 && In[client][2] > 0)
	{
		decl String:Level[64];
		if (GetClientTeam(client) == 2) Format(Level, sizeof(Level), "\x01[\x03Lv. %d\x01]", Ph[client][2]);
		else if (GetClientTeam(client) == 3) Format(Level, sizeof(Level), "\x01[\x04Lv. %d\x01]", In[client][2]);

		decl String:ClientName[32];
		if (!StrEqual(ChatColor[client][2], "def")) Format(ClientName, sizeof(ClientName), "%s", ChatColor[client][2]);
		else
		{
			if (GetClientTeam(client) == 2) Format(ClientName, sizeof(ClientName), "\x03");
			else if (GetClientTeam(client) == 3) Format(ClientName, sizeof(ClientName), "\x04");
		}

		decl String:Name[256];
		GetClientName(client, Name, sizeof(Name));
		decl String:ConnectMessage[1024];
		if (GetClientTeam(client) == 2) Format(ConnectMessage, sizeof(ConnectMessage), "\x03Survivor \x01Player (%s %s %s \x01) has connected to the server.", ClientName, Name, Level);
		else if (GetClientTeam(client) == 3) Format(ConnectMessage, sizeof(ConnectMessage), "\x04Infected \x01Player (%s %s %s \x01) has connected to the server.", ClientName, Name, Level);
		PrintToChatAll("%s", ConnectMessage);
	}
	if (IsClientInGame(client) && Ph[client][2] <= GetConVarInt(WikiForceLevel) || In[client][2] <= GetConVarInt(WikiForceLevel)) Call_HelpMenu(client);
	return Plugin_Stop;
}