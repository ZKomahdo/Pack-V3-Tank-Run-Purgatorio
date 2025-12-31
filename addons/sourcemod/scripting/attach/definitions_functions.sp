stock bool:IsClientIndexOutOfRange(client)
{
	if (client <= 0 || client > MaxClients) return true;
	else return false;
}

ExecCheatCommand(client = 0,const String:command[],const String:parameters[] = "")
{
	new iFlags = GetCommandFlags(command);
	SetCommandFlags(command,iFlags & ~FCVAR_CHEAT);

	if(IsClientIndexOutOfRange(client) || !IsClientInGame(client) || IsFakeClient(client))
	{
		ServerCommand("%s %s",command,parameters);
	}
	else
	{
		FakeClientCommand(client,"%s %s",command,parameters);
	}

	SetCommandFlags(command,iFlags);
	SetCommandFlags(command,iFlags|FCVAR_CHEAT);
}

stock PrintToSurvivors(const String:format[], any:...)
{
	decl String:buffer[1024];
	VFormat(buffer, sizeof(buffer), format, 2);
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i)) continue;
		if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 2) continue;
		PrintToChat(i, buffer);
	}
}

stock PrintToSpectators(const String:format[], any:...)
{
	decl String:buffer[1024];
	VFormat(buffer, sizeof(buffer), format, 2);
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i)) continue;
		if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 1) continue;
		PrintToChat(i, buffer);
	}
}

stock PrintToInfected(const String:format[], any:...)
{
	decl String:buffer[1024];
	VFormat(buffer, sizeof(buffer), format, 2);
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i)) continue;
		if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 3) continue;
		PrintToChat(i, buffer);
	}
}

stock bool:IsIncapacitated(client)
{
	return bool:GetEntProp(client, Prop_Send, "m_isIncapacitated");
}

stock bool:IsPlayerGhost(client)
{
	return bool:GetEntProp(client, Prop_Send, "m_isGhost", 1);
}

stock CreateFireEx(client)
{
	if (IsClientIndexOutOfRange(client)) return;
	if (!IsClientInGame(client) || IsFakeClient(client)) return;
	decl Float:BombOrigin[3];
	GetClientAbsOrigin(client, BombOrigin);
	CreateFire(BombOrigin);
}

static const String:MODEL_GASCAN[] = "models/props_junk/gascan001a.mdl";

stock CreateFire(const Float:BombOrigin[3])
{
	new entity = CreateEntityByName("prop_physics");
	DispatchKeyValue(entity, "physdamagescale", "0.0");
	if (!IsModelPrecached(MODEL_GASCAN))
	{
		PrecacheModel(MODEL_GASCAN);
	}
	DispatchKeyValue(entity, "model", MODEL_GASCAN);
	DispatchSpawn(entity);
	TeleportEntity(entity, BombOrigin, NULL_VECTOR, NULL_VECTOR);
	SetEntityMoveType(entity, MOVETYPE_VPHYSICS);
	AcceptEntityInput(entity, "Break");
}

BlindPlayer(client, amount)
{
	if (IsClientIndexOutOfRange(client)) return;
	if (!IsClientInGame(client) || IsFakeClient(client)) return;
	new clients[2];
	clients[0] = client;

	BlindMsgID = GetUserMessageId("Fade");
	new Handle:message = StartMessageEx(BlindMsgID, clients, 1);
	BfWriteShort(message, 1536);
	BfWriteShort(message, 1536);
	
	if (amount == 0)
	{
		BfWriteShort(message, (0x0001 | 0x0010));
	}
	else
	{
		BfWriteShort(message, (0x0002 | 0x0008));
	}
	
	BfWriteByte(message, 0);
	BfWriteByte(message, 0);
	BfWriteByte(message, 0);
	BfWriteByte(message, amount);
	
	EndMessage();
}

public Respawn_Corpse(client)
{
	// respawn at corpse
	SDKCall(hRoundRespawn, client);
	TeleportEntity(client, Float:locationDeath[client], NULL_VECTOR, NULL_VECTOR);
	if (!StrEqual(LastSecondary[client], "none")) ExecCheatCommand(client, "give", LastSecondary[client]);
	if (!StrEqual(LastPrimary[client], "none"))
	{
		ExecCheatCommand(client, "give", LastPrimary[client]);
		ExecCheatCommand(client, "upgrade_add", "LASER_SIGHT");
	}
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Respawn_Start(client)
{
	// respawn at corpse
	SDKCall(hRoundRespawn, client);
	if (!StrEqual(LastSecondary[client], "none")) ExecCheatCommand(client, "give", LastSecondary[client]);
	if (!StrEqual(LastPrimary[client], "none"))
	{
		ExecCheatCommand(client, "give", LastPrimary[client]);
		ExecCheatCommand(client, "upgrade_add", "LASER_SIGHT");
	}
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}