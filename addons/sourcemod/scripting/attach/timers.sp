public Action:Timer_SurvivorBlackWhite(Handle:timer)
{
	if (roundReset) return Plugin_Stop;
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || !IsPlayerAlive(i) || GetClientTeam(i) != 2) continue;
		SetEntityRenderMode(i, RENDER_TRANSCOLOR);
		if (GetEntProp(i, Prop_Send, "m_currentReviveCount") < 2) SetEntityRenderColor(i, 255, 255, 255, 255);
		else SetEntityRenderColor(i, 200, 0, 0, 255);
	}
	return Plugin_Continue;
}

public Action:Timer_SurvivorRespawn(Handle:timer)
{
	if (roundReset) return Plugin_Stop;
	respawnTimer--;
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || IsPlayerAlive(i) || GetClientTeam(i) != TEAM_SURVIVORS || respawnType[i] == 0) continue;
		if (rescueVehicleHasArrived)
		{
			respawnType[i] = 0;
			PrintToChat(i, "%s - \x01your respawn has been cancelled, due to \x05the rescue vehicle arriving.", INFO_GENERAL);
		}
		else if (respawnTimer > 0) PrintHintText(i, "%d sec(s) until you respawn", respawnTimer);
		else
		{
			if (respawnType[i] == 1) Respawn_Corpse(i);
			else Respawn_Start(i);
			respawnType[i] = 0;
		}
	}
	if (respawnTimer < 1) respawnTimer = GetConVarInt(Timer_RespawnCounter);
	return Plugin_Continue;
}

public Action:Timer_RemoveDeepFreeze(Handle:timer)
{
	static Float:count = -1.0;
	if (roundReset) return Plugin_Stop;
	if (count == -1.0) count = 0.0;
	if (count < GetConVarFloat(Time_DeepFreeze)) count++;
	else
	{
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != TEAM_SURVIVORS || !IsPlayerAlive(i)) continue;
			SetEntDataFloat(i, laggedMovementOffset, 1.0, true);
		}
		PrintToChatAll("%s - \x01The effects of Deep Freeze have yielded.", INFO_GENERAL);
		count = -1.0;
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:Timer_EnableDeepFreeze(Handle:timer)
{
	static Float:count = -1.0;
	if (roundReset) return Plugin_Stop;
	if (count == -1.0) count = 0.0;
	if (count < GetConVarFloat(Delay_DeepFreeze)) count++;
	else
	{
		deepFreezeCooldown = false;
		count = -1.0;
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:Timer_CheckIfEnsnared(Handle:timer, any:client)
{
	if (roundReset) return Plugin_Stop;
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || IsFakeClient(client) || GetClientTeam(client) != TEAM_SURVIVORS || !IsPlayerAlive(client) || 
		!IsIncapacitated(client)) return Plugin_Stop;
	if (!ensnared[client])
	{
		ExecCheatCommand(client, "give", "health");
		incapProtection[client]--;
		PrintToChat(client, "%s - \x01You have \x05%d Incap Protection Charges Remaining.", INFO_GENERAL, incapProtection[client]);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:Timer_SpawnAnywhere(Handle:timer, any:client)
{
	if (roundReset) return Plugin_Stop;
	if (IsPlayerGhost(client))
	{
		SDKHook(client, SDKHook_PreThinkPost, Set_SpawnAnywhere);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Set_SpawnAnywhere(client)
{
	SetEntProp(client, Prop_Send, "m_ghostSpawnState", 0);
}

public Action:Timer_DisableBloatEffect(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || roundReset) return Plugin_Stop;
	if (IsPlayerAlive(client)) SetEntityGravity(client, 1.0);
	return Plugin_Stop;
}

public Action:Timer_DisableBloatImmune(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || roundReset) return Plugin_Stop;
	bloatImmune[client] = false;
	return Plugin_Stop;
}

public Action:Timer_DisableBlindEffect(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || roundReset) return Plugin_Stop;
	BlindPlayer(client, 0);
	return Plugin_Stop;
}

public Action:Timer_DisableBlindImmune(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || roundReset) return Plugin_Stop;
	blindImmune[client] = false;
	return Plugin_Stop;
}

public Action:Timer_DisableSlowmoEffect(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || roundReset) return Plugin_Stop;
	SetEntDataFloat(client, laggedMovementOffset, 1.0, true);
	return Plugin_Stop;
}

public Action:Timer_DisableSlowmoImmune(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || roundReset) return Plugin_Stop;
	slowmoImmune[client] = false;
	return Plugin_Stop;
}

public Action:Timer_DisableBeanbagImmune(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || roundReset) return Plugin_Stop;
	beanbagImmune[client] = false;
	return Plugin_Stop;
}

public Action:Timer_DisableSpatialEffect(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || roundReset) return Plugin_Stop;
	if (IsPlayerAlive(client)) SetEntityGravity(client, 1.0);
	return Plugin_Stop;
}

public Action:Timer_DisableSpatialImmune(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || roundReset) return Plugin_Stop;
	spatialImmune[client] = false;
	return Plugin_Stop;
}

public Action:Timer_EnableSummonZombie(Handle:timer)
{
	if (roundReset) return Plugin_Stop;
	if (summonZombieCooldown < 1.0)
	{
		PrintToInfected("%s - \x01Summon Zombie purchases may now be used.", INFO_GENERAL);
		summonZombieCooldown = 0.0;
		return Plugin_Stop;
	}
	summonZombieCooldown--;
	return Plugin_Continue;
}

public Action:Timer_MedicalHOT(Handle:timer, any:client)
{
	static Float:count = -1.0;
	if (roundReset) return Plugin_Stop;
	if (count == -1.0) count = 0.0;
	if (count < GetConVarFloat(Ability_HOTTime))
	{
		SetEntityHealth(client, GetClientHealth(client) + GetConVarInt(Ability_HOTAmount));
		count++;
		return Plugin_Continue;
	}
	count = -1.0;
	return Plugin_Stop;
}

public Action:Timer_RemoveAdrenalineUser(Handle:timer, any:client)
{
	if (roundReset) return Plugin_Stop;
	adrenalineJunkie[client] = false;
	drugUses[client]++;
	new chance = GetRandomInt(1, 100);
	if (chance <= drugUses[client])
	{
		PrintToSurvivors("%s - \x03%N \x01couldn't handle withdrawal.", INFO_GENERAL, client);
		ForcePlayerSuicide(client);
		permaDeath[client] = true;
	}
	else if (GetConVarInt(InfoNotice) == 1) PrintToChat(client, "%s - \x01You feel normal again.", INFO_GENERAL);
	return Plugin_Stop;
}

public Action:Timer_RemovePillsUser(Handle:timer, any:client)
{
	if (roundReset) return Plugin_Stop;
	pillsJunkie[client] = false;
	drugUses[client]++;
	new chance = GetRandomInt(1, 100);
	if (chance <= drugUses[client])
	{
		PrintToSurvivors("%s - \x03%N \x01couldn't handle withdrawal.", INFO_GENERAL, client);
		ForcePlayerSuicide(client);
		permaDeath[client] = true;
	}
	else if (GetConVarInt(InfoNotice) == 1) PrintToChat(client, "%s - \x01You feel normal again.", INFO_GENERAL);
	return Plugin_Stop;
}

public Action:Timer_DisableBilePoints(Handle:timer, any:client)
{
	if (roundReset) return Plugin_Stop;
	new attacker = theBoomer[client];
	if (bilePoints[client] > 0.0)
	{
		playerPoints[attacker][1] += bilePoints[client];
		if (GetConVarInt(InfoNotice) == 1) PrintToChat(attacker, "%s - \x01Bile Damage against %N: \x05%3.2f Point(s).", INFO_GENERAL, client, bilePoints[client]);
	}
	bilePoints[client] = 0.0;
	bileCovered[client] = false;
	return Plugin_Stop;
}

public Action:Timer_DisableBlindBile(Handle:timer, any:client)
{
	if (roundReset) return Plugin_Stop;
	BlindPlayer(client, 0);
	return Plugin_Stop;
}

public Action:Timer_DisableSlowBile(Handle:timer, any:client)
{
	if (roundReset) return Plugin_Stop;
	SetEntDataFloat(client, laggedMovementOffset, 1.0, true);
	return Plugin_Stop;
}

public Action:Timer_JockeyBerserkCheck(Handle:timer, any:client)
{
	if (roundReset) return Plugin_Stop;
	if (IsIncapacitated(client))
	{
		new attacker = jockey[client];
		if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED)
		{
			ForcePlayerSuicide(client);
			PrintToChatAll("%s - \x03%N \x01was berserked by \x05%N.", INFO_GENERAL, client, attacker);
			bBerserk[attacker] = true;
		}
	}
	return Plugin_Stop;
}

public Action:Timer_DisableSpitSlowSpeed(Handle:timer, any:client)
{
	if (roundReset) return Plugin_Stop;
	SetEntDataFloat(client, laggedMovementOffset, 1.0, true);
	bSlow[client] = false;
	return Plugin_Stop;
}

public Action:Timer_TriggerTankCount(Handle:timer, any:client)
{
	if (roundReset) return Plugin_Stop;
	if (IsPlayerGhost(client))
	{
		tankCount--;
		if (!tankRestriction)
		{
			tankRestriction = true;
			PrintToInfected("%s - \x01Tank restrictions are now in place.", INFO_GENERAL);
		}
		if (tankCount < 1)
		{
			tankCount = 0;
			tankRestrictionTime = 0.0;
			PrintToInfected("%s - \x01Tanks will be available \x05in %3.2f sec(s).", GetConVarFloat(Amount_TankRestriction));
			CreateTimer(1.0, Timer_RemoveTankRestriction, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:Timer_RemoveTankRestriction(Handle:timer)
{
	if (roundReset) return Plugin_Stop;
	if (tankRestrictionTime < GetConVarFloat(Amount_TankRestriction))
	{
		tankRestrictionTime++;
	}
	else
	{
		tankRestrictionTime = 0.0;
		tankRestriction = false;
		PrintToInfected("%s - \x01Tanks are now \x05available for purchase.", INFO_GENERAL);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:Timer_RemoveSpitProtection(Handle:timer, any:client)
{
	if (!IsClientIndexOutOfRange(client) && IsClientInGame(client) && !IsFakeClient(client))
	{
		SetEntityRenderMode(client, RENDER_NORMAL);
		SetEntityRenderColor(client, 255, 255, 255, 255);
		SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
	}
	return Plugin_Stop;
}

public Action:Timer_EnableChargeJump(Handle:timer, any:client)
{
	if (roundReset) return Plugin_Stop;
	bJumpCooldown[client] = false;
	return Plugin_Stop;
}

public Action:Timer_AwardPointsOnGhost(Handle:timer, any:client)
{
	if (roundReset) return Plugin_Stop;
	if (IsPlayerGhost(client))
	{
		Infected_PlayerDeath(client);
		bCharging[client] = false;
		SetEntDataFloat(client, laggedMovementOffset, 1.0, true);
		CreateTimer(0.1, Timer_TriggerTankCount, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:Timer_GatherPointsOnGhost(Handle:timer, any:client)
{
	if (roundReset) return Plugin_Stop;
	if (IsPlayerGhost(client))
	{
		Infected_GatherPoints(client);
		if (bSpawnAnywhere) CreateTimer(0.1, Timer_SpawnAnywhere, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		if (bBerserk[client]) bBerserk[client] = false;
		return Plugin_Stop;
	}
	return Plugin_Continue;
}