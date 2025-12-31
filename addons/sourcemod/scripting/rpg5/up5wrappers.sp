_Wrappers_OnPluginStart()
{
	RegConsoleCmd("heal", Survivor_BuyInstantHeal);
	RegConsoleCmd("incap", Survivor_BuyIncapProtection);

	//HookEvent("finale_escape_start", Event_FinaleEscapeStart);
	HookEvent("tank_spawn", Event_TankSpawn);
	//HookEvent("weapon_fire", Event_WeaponFire);
}

public ExperienceHours()
{
	decl String:weekDay[64];
	FormatTime(weekDay, sizeof(weekDay),"%A");
	decl String:sBuffer[64];
	FormatTime(sBuffer, sizeof(sBuffer), "%H");
	new hour = StringToInt(sBuffer);
	decl String:pct[32];
	Format(pct, sizeof(pct), "%");
	if (StrEqual(weekDay, "Friday") || StrEqual(weekDay, "Saturday") || StrEqual(weekDay, "Sunday"))
	{
		// It's the weekend. Check for the times for the xp bonus.
		if (hour >= 0 && hour < 9)
		{
			// It's the weekend, and between the hours of 9pm and 9am, triple XP.
			PrintToChatAll("%s \x01Current Global Experience rate: \x04300%s", WEEKEND_INFO, pct);
		}
		else
		{
			// It's the weekend, and between the hours of 9:01am and 8:59pm, double XP.
			PrintToChatAll("%s \x01Current Global Experience rate: \x04200%s", WEEKEND_INFO, pct);
		}
	}
	else
	{
		// It's not the weekend.
		if (hour >= 0 && hour < 9)
		{
			// Double XP.
			PrintToChatAll("%s \x01Current Global Experience rate: \x04200%s", WEEKDAY_INFO, pct);
		}
		else
		{
			// Normal XP
			PrintToChatAll("%s \x01Current Global Experience rate: \x04Normal (100%s)", WEEKDAY_INFO, pct);
		}
	}
}

/*public Action:Event_WeaponFire(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!IsHuman(attacker)) return;		// don't remove weapons from bots.
	new String:WeaponUsed[64];
	GetClientWeapon(attacker, WeaponUsed, sizeof(WeaponUsed));
	if (StrEqual(WeaponUsed, "weapon_melee", true) || StrEqual(WeaponUsed, "weapon_pistol", true)) return;
	if (LockedWeaponUsed(attacker))
	{
		if (StrEqual(WeaponUsed, "weapon_pistol_magnum", true)) L4D_RemoveWeaponSlot(attacker, L4DWeaponSlot_Secondary);
		else L4D_RemoveWeaponSlot(attacker, L4DWeaponSlot_Primary);
		PrintHintText(attacker, "You don't have this weapon unlocked! Removed from inventory!\nType !up into chat & grab a gun from your equipment locker!\nLevel a category to unlock more, and deal more damage!");
	}
}*/

public Action:EnableWalking(Handle:timer, any:client)
{
	SetEntityMoveType(client, MOVETYPE_WALK);
	return Plugin_Stop;
}


stock bool:IsHuman(client)
{
	if (!IsClientIndexOutOfRange(client) && IsClientInGame(client) && !IsFakeClient(client)) return true;
	else return false;
}

public Action:Survivor_BuyInstantHeal(client, args)
{
	if (IsClientIndexOutOfRange(client)) return;
	if (GetClientTeam(client) != 2 || !IsPlayerAlive(client)) return;
	if (L4D2_GetInfectedAttacker(client) != -1 && IsIncapacitated(client))
	{
		PrintToChat(client, "%s \x01You are ensnared and incapped! Healing would kill you!", ERROR_INFO);
		return;
	}
	Ensnared[client] = false;

	if (It[client][2] >= GetConVarInt(HealthHealLevel) && HealCount[client] > 0)
	{
		ExecCheatCommand(client, "give", "health");
		HealCount[client]--;
		PrintToChat(client, "%s \x01You have \x05%d \x03Free Healing Items \x01remaining in your locker.", INFO, HealCount[client]);
	}
	else
	{
		ItemName[client] = "health";
		PurchaseItem[client] = 2;
		SurvivorPurchaseFunc(client);
	}
}

public Action:Survivor_BuyIncapProtection(client, args)
{
	if (IsClientIndexOutOfRange(client)) return;
	if (GetClientTeam(client) != 2 || !IsPlayerAlive(client)) return;
	if (IncapProtection[client] == -1)
	{
		PrintToChat(client, "%s \x01Incap Protection is on cooldown.", ERROR_INFO);
		return;
	}
	if (IncapProtection[client] > 0)
	{
		PrintToChat(client, "%s \x01still have \x05%d \x01uses remaining.", ERROR_INFO, IncapProtection[client]);
		return;
	}
	if (It[client][2] >= GetConVarInt(HealthIncapLevel) && HealCount[client] > 0)
	{
		PrintToChat(client, "%s \x01Incap Protection Added.", INFO);
		IncapProtection[client] = GetConVarInt(IncapCount);
		HealCount[client]--;
		PrintToChat(client, "%s \x01You have \x05%d \x03Free Healing Items \x01remaining in your locker.", INFO, HealCount[client]);
		CreateTimer(1.0, CheckIfEnsnared, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	}
	else
	{
		ItemName[client] = "incap_protection";
		PurchaseItem[client] = 2;
		SurvivorPurchaseFunc(client);
	}
}

/*	*
	*
	* Print a message to all survivor players.
	*
	*
	*/

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

/*	*
	*
	* Print a message to all infected players.
	*
	*
	*/

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

/*	*
	*
	* Allows a client to execute a cheat command, such as give, z_spawn, and so on.
	*
	*
	*/

ExecCheatCommand(client = 0,const String:command[],const String:parameters[] = "")
{
	new iFlags = GetCommandFlags(command);
	SetCommandFlags(command,iFlags & ~FCVAR_CHEAT);

	if(IsClientIndexOutOfRange(client) || !IsClientInGame(client))
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

/*	*
	*
	* Checks to see if the client is incapacitated
	*
	*
	*/

stock bool:IsIncapacitated(client)
{
	return bool:GetEntProp(client, Prop_Send, "m_isIncapacitated");
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

bool:LockedWeaponUsed(attacker)
{
	if (IsClientIndexOutOfRange(attacker)) return true;
	if (!IsClientInGame(attacker) || IsFakeClient(attacker)) return true;
	new String:WeaponUsed[64];
	GetClientWeapon(attacker, WeaponUsed, sizeof(WeaponUsed));
	
	if ((StrEqual(WeaponUsed, "weapon_pistol_magnum", true) && Pi[attacker][2] < GetConVarInt(PistolDeagleLevel)) || 
		(StrEqual(WeaponUsed, "weapon_smg", true) && (Uz[attacker][2] < GetConVarInt(UziMp5Level) || Ph[attacker][2] < GetConVarInt(UziLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_smg_silenced", true) && (Uz[attacker][2] < GetConVarInt(UziTmpLevel) || Ph[attacker][2] < GetConVarInt(UziLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_smg_mp5", true) && (Uz[attacker][2] < GetConVarInt(UziMp5Level) || Ph[attacker][2] < GetConVarInt(UziLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_autoshotgun", true) && (Sh[attacker][2] < GetConVarInt(ShotgunAutoLevel) || Ph[attacker][2] < GetConVarInt(ShotgunLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_pumpshotgun", true) && (Sh[attacker][2] < GetConVarInt(ShotgunPumpLevel) || Ph[attacker][2] < GetConVarInt(ShotgunLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_shotgun_chrome", true) && (Sh[attacker][2] < GetConVarInt(ShotgunChromeLevel) || Ph[attacker][2] < GetConVarInt(ShotgunLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_shotgun_spas", true) && (Sh[attacker][2] < GetConVarInt(ShotgunSpasLevel) || Ph[attacker][2] < GetConVarInt(ShotgunLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_rifle", true) && (Ri[attacker][2] < GetConVarInt(RifleM16Level) || Ph[attacker][2] < GetConVarInt(RifleLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_rifle_ak47", true) && (Ri[attacker][2] < GetConVarInt(RifleAK47Level) || Ph[attacker][2] < GetConVarInt(RifleLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_rifle_desert", true) && (Ri[attacker][2] < GetConVarInt(RifleDesertLevel) || Ph[attacker][2] < GetConVarInt(RifleLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_rifle_m60", true) && (Ri[attacker][2] < GetConVarInt(RifleM60Level) || Ph[attacker][2] < GetConVarInt(RifleLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_rifle_sg552", true) && (Ri[attacker][2] < GetConVarInt(RifleSG552Level) || Ph[attacker][2] < GetConVarInt(RifleLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_sniper_awp", true) && (Sn[attacker][2] < GetConVarInt(SniperAwpLevel) || Ph[attacker][2] < GetConVarInt(SniperLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_sniper_scout", true) && (Sn[attacker][2] < GetConVarInt(SniperScoutLevel) || Ph[attacker][2] < GetConVarInt(SniperLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_sniper_military", true) && (Sn[attacker][2] < GetConVarInt(SniperMilitaryLevel) || Ph[attacker][2] < GetConVarInt(SniperLevelUnlock))) || 
		(StrEqual(WeaponUsed, "weapon_hunting_rifle", true) && (Sn[attacker][2] < GetConVarInt(SniperHuntingLevel) || Ph[attacker][2] < GetConVarInt(SniperLevelUnlock))))
	{
		// If the player is using a gun they haven't unlocked, we don't let them use the custom ammo type.
		// They might have it for that weapon category because they purchased it on another weapon they do have
		// unlocked in that weapon category, and then tried to switch weapons.
		// So we stop them from exploiting that here.
		return true;
	}
	else return false;
}

stock bool:IsClientIndexOutOfRange(client)
{
	if (client <= 0 || client > MaxClients) return true;
	else return false;
}

public Action:CheckBlackWhite(Handle:timer)
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i)) continue;
		if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 2 || !IsPlayerAlive(i) || Ensnared[i]) continue;
		if (VipName == i)
		{
			if (GetEntProp(i, Prop_Send, "m_currentReviveCount") >= 2 && IncapProtection[i] < 1)
			{
				SetEntityRenderMode(i, RENDER_TRANSCOLOR);
				SetEntityRenderColor(i, GetConVarInt(VipColor[0]), GetConVarInt(VipColor[1]), GetConVarInt(VipColor[2]), 200);
			}
			else
			{
				SetEntityRenderMode(i, RENDER_TRANSCOLOR);
				SetEntityRenderColor(i, GetConVarInt(VipColor[0]), GetConVarInt(VipColor[1]), GetConVarInt(VipColor[2]), 255);
			}
		}
		else if (GetEntProp(i, Prop_Send, "m_currentReviveCount") >= 2 && IncapProtection[i] < 1)
		{
			SetEntityRenderMode(i, RENDER_TRANSCOLOR);
			SetEntityRenderColor(i, GetConVarInt(BlackWhiteColor[0]), GetConVarInt(BlackWhiteColor[1]), GetConVarInt(BlackWhiteColor[2]), 255);
		}
		else if (bIcedByTank[i])
		{
			SetEntityRenderMode(i, RENDER_TRANSCOLOR);
			SetEntityRenderColor(i, 50, 50, 255, 255);
		}
		else
		{
			SetEntityRenderMode(i, RENDER_NORMAL);
			SetEntityRenderColor(i, 255, 255, 255, 255);
		}
	}
}

SpawnMachineGun(client)
{
	decl Float:VecOrigin[3], Float:VecAngles[3], Float:VecDirection[3];
	if (MiniGunType[client] == 1)
	{
		MiniGun[client] = CreateEntityByName("prop_minigun");
		DispatchKeyValue(MiniGun[client], "model", "models/w_models/weapons/50cal.mdl");
	}
	else if (MiniGunType[client] == 2)
	{
		MiniGun[client] = CreateEntityByName("prop_minigun_l4d1");
		DispatchKeyValue(MiniGun[client], "model", "models/w_models/weapons/w_minigun.mdl");
	}
	DispatchKeyValueFloat (MiniGun[client], "MaxPitch", 360.00);
	DispatchKeyValueFloat (MiniGun[client], "MinPitch", -360.00);
	DispatchKeyValueFloat (MiniGun[client], "MaxYaw", 90.00);
	DispatchSpawn(MiniGun[client]);

	GetClientAbsOrigin(client, VecOrigin);
	GetClientEyeAngles(client, VecAngles);
	GetAngleVectors(VecAngles, VecDirection, NULL_VECTOR, NULL_VECTOR);
	VecOrigin[0] += VecDirection[0] * 32;
	VecOrigin[1] += VecDirection[1] * 32;
	VecOrigin[2] += VecDirection[2] * 1;   
	VecAngles[0] = 0.0;
	VecAngles[2] = 0.0;
	VecOrigin[2] -= 5000;		// Start mini gun in an "unseen" location.
	DispatchKeyValueVector(MiniGun[client], "Angles", VecAngles);
	DispatchSpawn(MiniGun[client]);
	TeleportEntity(MiniGun[client], VecOrigin, NULL_VECTOR, NULL_VECTOR);
	SetEntityMoveType(client, MOVETYPE_NONE);
	MiniGunUse[client] = false;		// not using the minigun , teleport it with the player.
}

public Action:Timer_MoveMiniGun(Handle:timer)
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsHuman(i) || GetClientTeam(i) != 2 || MiniGun[i] == -1) continue;
		if (!IsPlayerAlive(i))
		{
			// Player has been killed, but their minigun still exists, so remove it.
			AcceptEntityInput(MiniGun[i], "Kill");
			MiniGun[i] = -1;
			continue;
		}

		// Teleport the mini gun to the location of the player, until the player uses it.
		decl Float:VecOrigin[3], Float:VecAngles[3], Float:VecDirection[3];

		GetClientAbsOrigin(i, VecOrigin);
		GetClientEyeAngles(i, VecAngles);
		GetAngleVectors(VecAngles, VecDirection, NULL_VECTOR, NULL_VECTOR);
		VecOrigin[0] += VecDirection[0] * 34;
		VecOrigin[1] += VecDirection[1] * 34;
		VecOrigin[2] += VecDirection[2] * 1;
		VecAngles[0] = 0.0;
		VecAngles[2] = 0.0;
		if (MiniGunMobile[i] == true)
		{
			// If mobile is enabled...
			DispatchKeyValueVector(MiniGun[i], "Angles", VecAngles);
			TeleportEntity(MiniGun[i], VecOrigin, NULL_VECTOR, NULL_VECTOR);
		}
	}
}

KillMiniGun(client)
{
	if (MiniGun[client] != -1)
	{
		MiniGunMobile[client] = false;
		MiniGunState[client] = 1;
		AcceptEntityInput(MiniGun[client], "Kill");
		MiniGun[client] = -1;
		PrintToChat(client, "%s \x01Minigun destroyed.", INFO);
		CreateTimer(0.1, EnableWalking, client, TIMER_FLAG_NO_MAPCHANGE);
	}
	else PrintToChat(client, "%s \x01Minigun could not be found.", ERROR_INFO);
}

stock PrintToAdmins(const String:format[], any:...)
{
	decl String:buffer[1024];
	VFormat(buffer, sizeof(buffer), format, 2);
	for (new i = 1; i <= MaxClients;i++)
	{
		if (!IsClientInGame(i)) continue;
		if (IsFakeClient(i)) continue;
		new flags = GetUserFlagBits(i);
		if (!(flags & ADMFLAG_ROOT || flags & ADMFLAG_GENERIC)) continue;

		PrintToChat(i, buffer);
	}
}

stock CreateFireEx(client)
{
	if (IsClientIndexOutOfRange(client)) return;
	if (!IsClientInGame(client)) return;
	decl Float:BombOrigin[3];
	GetClientAbsOrigin(client, BombOrigin);
	CreateFire(BombOrigin);
}

stock bool:IsPlayerGhost(client)
{
	return bool:GetEntProp(client, Prop_Send, "m_isGhost", 1);
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

public Action:SurvivorRespawnTimer(Handle:timer)
{
	static Float:count = -1.0;
	if (count == -1.0) count = GetConVarFloat(SurvivorRespawnQueue);
	if (count > 0.0)
	{
		count -= 1.0;
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsClientIndexOutOfRange(i)) continue;
			if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 2 || RespawnType[i] == 0 || IsPlayerAlive(i)) continue;
			PrintHintText(i, "survivors will respawn in\n%2.1f second(s).", count);
			if (RescueCalled)
			{
				RespawnType[i] = 0;
				PrintHintText(i, "Finale has begun!\nRespawn cancelled.");
			}
		}
		return Plugin_Continue;
	}
	if (count < 2.0)
	{
		count = GetConVarFloat(SurvivorRespawnQueue);
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsClientIndexOutOfRange(i)) continue;
			if (!IsClientInGame(i) || IsFakeClient(i) || 
				GetClientTeam(i) != 2 || RespawnType[i] == 0 || IsPlayerAlive(i)) continue;
			if (RespawnType[i] == 1) respawnatstart(i);
			else respawnatcorpse(i);
			RespawnType[i] = 0;
			RespawnCount[i]++;
			if (RespawnCount[i] + 1 < GetConVarInt(RespawnLimit) && GetConVarInt(RespawnLimit) > 0)
			{
				PrintToChat(i, "%s \x01You have used \x03%d \x01out of \x04%d \x01Respawns available.", INFO, RespawnCount[i], GetConVarInt(RespawnLimit));
			}
			else if (RespawnCount[i] + 1 >= GetConVarInt(RespawnLimit) && GetConVarInt(RespawnLimit) > 0)
			{
				PrintToChat(i, "%s \x01You have used your \x03last available respawn purchase\x01.", INFO);
			}
		}
		return Plugin_Continue;
	}
	return Plugin_Continue;
}

public bool:bhardModeRequirement()
{
	new humans = 0;
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 2) continue;
		humans++;
	}
	if (humans >= GetConVarInt(g_hardModeRequirement)) return true;
	else return false;
}

respawnatstart(i)
{
	if (IsClientIndexOutOfRange(i)) return;
	if (!IsClientInGame(i) || IsFakeClient(i) || IsPlayerAlive(i)) return;
	SDKCall(hRoundRespawn, i);
	if (!StrEqual(LastWeaponOwned[i], "none", false)) ExecCheatCommand(i, "give", LastWeaponOwned[i]);
	ExecCheatCommand(i, "upgrade_add", "LASER_SIGHT");
	SetEntityHealth(i, 100 + Ph[i][2] + It[i][2]);
	AdjustTeamValue();
}

respawnatcorpse(i)
{
	if (IsClientIndexOutOfRange(i)) return;
	if (!IsClientInGame(i) || IsFakeClient(i) || IsPlayerAlive(i)) return;
	SDKCall(hRoundRespawn, i);
	TeleportEntity(i, Float:SurvivorDeathSpot[i], NULL_VECTOR, NULL_VECTOR);
	if (!StrEqual(LastWeaponOwned[i], "none", false)) ExecCheatCommand(i, "give", LastWeaponOwned[i]);
	ExecCheatCommand(i, "upgrade_add", "LASER_SIGHT");
	SetEntityHealth(i, 100 + Ph[i][2] + It[i][2]);
	AdjustTeamValue();
}

AdjustTeamValue()
{
	TeamSurvivorAmount += GetConVarInt(TeamSurvivorValue);
	TeamInfectedAmount -= GetConVarInt(TeamSurvivorValue);
}

public Action:L4D_OnSpawnTank(const Float:vector[3], const Float:qangle[3])
{
	// Don't let the director spawn a tank if it's versus.
	decl String:GameTypeCurrent[128];
	GetConVarString(FindConVar("mp_gamemode"), GameTypeCurrent, 128);
	if (StrEqual(GameTypeCurrent, "versus")) return Plugin_Handled;
	//if (TankCount == 0 || TankLimit == 0 || TankCount > TankLimit) return Plugin_Handled;
	return Plugin_Continue;
}

public Action:Event_TankSpawn(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (IsClientInGame(client) && IsFakeClient(client))
	{
		//PrintToChatAll("%s \x05Tank health: \x04%d", INFO, GetClientHealth(client));
		CreateTimer(1.0, Timer_SetBotTankHealth, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action:Timer_SetBotTankHealth(Handle:timer, any:client)
{
	if (IsClientInGame(client) && IsFakeClient(client) && IsPlayerAlive(client))
	{
		SetEntityHealth(client, GetClientHealth(client) + (GetConVarInt(TankDefaultHealth) * GetConVarInt(SurvivorCount)));
		SetEntityHealth(client, GetClientHealth(client) + (GetConVarInt(PhysicalHealthPerLevel) * AIInfected[2]));
		SetEntityHealth(client, GetClientHealth(client) + (GetConVarInt(TankHealthPerLevel) * AITank[2]));
		SetEntityHealth(client, GetClientHealth(client) + (GetConVarInt(TankHealthTimesSurvivorLimit) * GetConVarInt(SurvivorCount)));
		//PrintToChatAll("%s \x05TANK HEALTH: \x04%d", INFO, GetClientHealth(client));
	}
	return Plugin_Stop;
}