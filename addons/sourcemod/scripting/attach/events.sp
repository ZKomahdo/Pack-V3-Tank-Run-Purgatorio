public Events_OnPluginStart()
{
	HookEvent("infected_death", Event_InfectedDeath);
	HookEvent("player_death", Event_PlayerDeath);
	HookEvent("player_hurt", Event_PlayerHurt);
	HookEvent("player_incapacitated", Event_PlayerIncapacitated);
	HookEvent("player_ledge_grab", Event_PlayerIncapacitated);
	HookEvent("witch_killed", Event_WitchKilled);
	HookEvent("player_shoved", Event_PlayerShoved);
	HookEvent("finale_escape_start", Event_RescueVehicleArrives);
}

public Action:Event_PlayerIncapacitated(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new victim					= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		if (incapProtection[victim] > 0) CreateTimer(1.0, Timer_CheckIfEnsnared, victim, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		if (deepFreezeAmount > 0 && !deepFreezeCooldown)
		{
			new number = GetRandomInt(1, 100);
			if (number <= deepFreezeAmount)
			{
				deepFreezeCooldown = true;
				for (new i = 1; i <= MaxClients; i++)
				{
					if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != TEAM_SURVIVORS || !IsPlayerAlive(i)) continue;
					SetEntDataFloat(i, laggedMovementOffset, GetConVarFloat(Strength_DeepFreeze), true);
				}
				CreateTimer(1.0, Timer_RemoveDeepFreeze, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				CreateTimer(1.0, Timer_EnableDeepFreeze, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
				PrintToChatAll("%s - \x03%N \x01has become incapacitated, triggering \x03Deep Freeze.", INFO_GENERAL, victim);
			}
		}
	}
}

public Action:Event_InfectedDeath(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new gender						= GetEventInt(event, "gender");
	new bool:headshot				= GetEventBool(event, "headshot");
	new attacker					= GetClientOfUserId(GetEventInt(event, "attacker"));

	if (gender != 1 && gender != 2) return;
	if (IsClientIndexOutOfRange(attacker) || !IsClientInGame(attacker) || IsFakeClient(attacker) || GetClientTeam(attacker) != TEAM_SURVIVORS) return;
	survivorCommon[attacker]++;
	survivorTeamCommon++;
	if (headshot)
	{
		survivorHeadshot[attacker]++;
		survivorTeamHeadshot++;
	}

	if (survivorCommon[attacker] == survivorCommonGoal[attacker])
	{
		survivorMultiplier[attacker] += GetConVarFloat(Multiplier_Bonus);
		if (survivorMultiplier[attacker] > GetConVarFloat(Multiplier_Maximum)) survivorMultiplier[attacker] = GetConVarFloat(Multiplier_Maximum);
		playerPoints[attacker][0] += (survivorMultiplier[attacker] * GetConVarFloat(Multiplier_Award));
		PrintToChat(attacker, "%s - \x01Common kills goal reached for %3.2f Point(s). Multiplier is now: \x05%3.2f", INFO_GENERAL, survivorMultiplier[attacker] * GetConVarFloat(Multiplier_Award), survivorMultiplier[attacker]);
		survivorCommonGoal[attacker] = RoundToFloor(survivorCommonGoal[attacker] * GetConVarFloat(Multiplier_Multiplier));
	}
	if (survivorTeamCommon == survivorTeamCommonGoal)
	{
		survivorMultiplier[attacker] += GetConVarFloat(Multiplier_Bonus);
		if (survivorMultiplier[attacker] > GetConVarFloat(Multiplier_Maximum)) survivorMultiplier[attacker] = GetConVarFloat(Multiplier_Maximum);
		PrintToSurvivors("%s - \x01Team Common kills goal reached for %3.2f Point(s). \x03%N's multiplier.", INFO_GENERAL, survivorMultiplier[attacker] * GetConVarFloat(Multiplier_Award), attacker);
		survivorTeamCommonGoal = RoundToFloor(survivorTeamCommonGoal * GetConVarFloat(Multiplier_Multiplier));
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != TEAM_SURVIVORS) continue;
			playerPoints[i][0] += (survivorMultiplier[attacker] * GetConVarFloat(Multiplier_Award));
		}
	}
	if (survivorHeadshot[attacker] == survivorHeadshotGoal[attacker])
	{
		survivorMultiplier[attacker] += GetConVarFloat(Multiplier_Bonus);
		if (survivorMultiplier[attacker] > GetConVarFloat(Multiplier_Maximum)) survivorMultiplier[attacker] = GetConVarFloat(Multiplier_Maximum);
		playerPoints[attacker][0] += (survivorMultiplier[attacker] * GetConVarFloat(Multiplier_Award));
		PrintToChat(attacker, "%s - \x01Headshot kills goal reached for %3.2f Point(s). Multiplier is now: \x05%3.2f", INFO_GENERAL, survivorMultiplier[attacker] * GetConVarFloat(Multiplier_Award), survivorMultiplier[attacker]);
		survivorHeadshotGoal[attacker] = RoundToFloor(survivorHeadshotGoal[attacker] * GetConVarFloat(Multiplier_Multiplier));
	}
	if (survivorTeamHeadshot == survivorTeamHeadshotGoal)
	{
		survivorMultiplier[attacker] += GetConVarFloat(Multiplier_Bonus);
		if (survivorMultiplier[attacker] > GetConVarFloat(Multiplier_Maximum)) survivorMultiplier[attacker] = GetConVarFloat(Multiplier_Maximum);
		PrintToSurvivors("%s - \x01Team Headshot kills goal reached for %3.2f Point(s). \x03%N's multiplier.", INFO_GENERAL, survivorMultiplier[attacker] * GetConVarFloat(Multiplier_Award), attacker);
		survivorTeamHeadshotGoal = RoundToFloor(survivorTeamHeadshotGoal * GetConVarFloat(Multiplier_Multiplier));
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != TEAM_SURVIVORS) continue;
			playerPoints[i][0] += (survivorMultiplier[attacker] * GetConVarFloat(Multiplier_Award));
		}
	}
}

public Action:Event_PlayerDeath(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "attacker"));
	new victim						= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_SURVIVORS && 
		!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && GetClientTeam(victim) == TEAM_INFECTED)
	{
		survivorSpecial[attacker]++;
		survivorTeamSpecial++;

		if (survivorSpecial[attacker] == survivorSpecialGoal[attacker])
		{
			survivorMultiplier[attacker] += GetConVarFloat(Multiplier_Bonus);
			if (survivorMultiplier[attacker] > GetConVarFloat(Multiplier_Maximum)) survivorMultiplier[attacker] = GetConVarFloat(Multiplier_Maximum);
			playerPoints[attacker][0] += (survivorMultiplier[attacker] * GetConVarFloat(Multiplier_Award));
			PrintToChat(attacker, "%s - \x01Special kills goal reached for %3.2f Point(s). Multiplier is now: \x05%3.2f", INFO_GENERAL, survivorMultiplier[attacker] * GetConVarFloat(Multiplier_Award), survivorMultiplier[attacker]);
			survivorSpecialGoal[attacker] = RoundToFloor(survivorSpecialGoal[attacker] * GetConVarFloat(Multiplier_Multiplier));
		}
		if (survivorTeamSpecial == survivorTeamSpecialGoal)
		{
			survivorMultiplier[attacker] += GetConVarFloat(Multiplier_Bonus);
			if (survivorMultiplier[attacker] > GetConVarFloat(Multiplier_Maximum)) survivorMultiplier[attacker] = GetConVarFloat(Multiplier_Maximum);
			PrintToSurvivors("%s - \x01Team Special kills goal reached for %3.2f Point(s). \x03%N's multiplier.", INFO_GENERAL, survivorMultiplier[attacker] * GetConVarFloat(Multiplier_Award), attacker);
			survivorTeamSpecialGoal = RoundToFloor(survivorTeamSpecialGoal * GetConVarFloat(Multiplier_Multiplier));
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != TEAM_SURVIVORS) continue;
				playerPoints[i][0] += (survivorMultiplier[attacker] * GetConVarFloat(Multiplier_Award));
			}
		}
	}
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		locationSaved[victim] = true;
		GetClientAbsOrigin(victim, locationDeath[victim]);
	}
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) != TEAM_SPECTATOR)
	{
		SDKUnhook(victim, SDKHook_OnTakeDamage, OnTakeDamage);
	}
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_INFECTED)
	{
		if (classTank[victim])
		{
			CreateTimer(0.1, Timer_GatherPointsOnGhost, victim, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			Infected_GatherPoints(victim);
			if (bSpawnAnywhere) CreateTimer(0.1, Timer_SpawnAnywhere, victim, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			if (bWallOfFire) CreateFireEx(victim);
			if (bBerserk[victim]) bBerserk[victim] = false;
		}
	}
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && GetClientTeam(victim) == TEAM_INFECTED)
	{
		if (!IsFakeClient(victim) && classTank[victim])
		{
			// tank points, etc., are awarded when the player enters ghost mode, since playerdeath doesn't always trigger for tanks.
			CreateTimer(0.1, Timer_AwardPointsOnGhost, victim, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		else
		{
			Infected_PlayerDeath(victim);
			bCharging[victim] = false;
			SetEntDataFloat(victim, laggedMovementOffset, 1.0, true);
		}
	}
}

public Infected_PlayerDeath(client)
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != TEAM_SURVIVORS) continue;
		if (damageDealt[i][client] < 1) continue;
		if (classTank[client])
		{
			PrintToChat(i, "%s - \x01Damage Dealt: \x05%d \x01against \x03%N \x01for \x05%3.2f Point(s).", INFO_GENERAL, damageDealt[i][client], client, damageDealt[i][client] * GetConVarFloat(survivorDamageMultiplierTank));
			playerPoints[i][0] += (damageDealt[i][client] * GetConVarFloat(survivorDamageMultiplierTank));
			teamPoints[0] += ((damageDealt[i][client] * GetConVarFloat(survivorDamageMultiplierTank)) * GetConVarFloat(survivorTeamPointsMultiplier));
			damageDealt[i][client] = 0;
		}
		else
		{
			PrintToChat(i, "%s - \x01Damage Dealt: \x05%d \x01against \x03%N \x01for \x05%3.2f Point(s).", INFO_GENERAL, damageDealt[i][client], client, damageDealt[i][client] * GetConVarFloat(survivorDamageMultiplier));
			playerPoints[i][0] += (damageDealt[i][client] * GetConVarFloat(survivorDamageMultiplier));
			teamPoints[0] += ((damageDealt[i][client] * GetConVarFloat(survivorDamageMultiplier)) * GetConVarFloat(survivorTeamPointsMultiplier));
			damageDealt[i][client] = 0;
		}
	}
	classHunter[client] = false;
	classSmoker[client] = false;
	classBoomer[client] = false;
	classJockey[client] = false;
	classCharger[client] = false;
	classSpitter[client] = false;
	classTank[client]	= false;
}

public Infected_GatherPoints(client)
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != TEAM_SURVIVORS) continue;
		if (damageDealt[client][i] < 1) continue;
		if (GetConVarInt(Detail_DamageReport) == 1)
		{
			PrintToChat(client, "%s - \x01Damage Dealt: \x05%d \x01against \x03%N \x01for \x05%3.2f Point(s).", INFO_GENERAL, damageDealt[client][i], i, damageDealt[client][i] * GetConVarFloat(infectedDamageMultiplier));
			playerPoints[client][1] += (damageDealt[client][i] * GetConVarFloat(infectedDamageMultiplier));
			teamPoints[1] += ((damageDealt[client][i] * GetConVarFloat(infectedDamageMultiplier)) * GetConVarFloat(infectedTeamPointsMultiplier));
			damageDealt[client][i] = 0;
		}
		else
		{
			totalDamage[client] += damageDealt[client][i];
			damageDealt[client][i] = 0;
		}
	}
	if (GetConVarInt(Detail_DamageReport) == 0)
	{
		PrintToChat(client, "%s - \x01Damage Dealt: \x05%d \x01for \x05%3.2f Point(s).", INFO_GENERAL, totalDamage[client], totalDamage[client] * GetConVarFloat(infectedDamageMultiplier));
		playerPoints[client][1] += (totalDamage[client] * GetConVarFloat(infectedDamageMultiplier));
		teamPoints[1] += ((totalDamage[client] * GetConVarFloat(infectedDamageMultiplier)) * GetConVarFloat(infectedTeamPointsMultiplier));
		totalDamage[client] = 0;
	}
}

public Action:Event_PlayerHurt(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "attacker"));
	new victim						= GetClientOfUserId(GetEventInt(event, "userid"));
	new damage						= GetEventInt(event, "dmg_health");
	new type						= GetEventInt(event, "type");
	new String:weaponType[32];

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_SURVIVORS && 
		!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && GetClientTeam(victim) == TEAM_INFECTED)
	{
		damageDealt[attacker][victim] += damage;

		GetEventString(event, "weapon", weaponType, 32);
		if (!StrEqual(weaponType, "inferno") && !StrEqual(weaponType, "insect_swarm") && 
			type != 8 && type != 268435464)
		{
			if (bloatAmmo[attacker] > 0 && !bloatImmune[victim])
			{
				bloatAmmo[attacker]--;
				SetEntityGravity(victim, GetConVarFloat(Effect_BloatAmmo));
				CreateTimer(GetConVarFloat(Time_BloatAmmo), Timer_DisableBloatEffect, victim, TIMER_FLAG_NO_MAPCHANGE);

				bloatImmune[victim] = true;
				CreateTimer(GetConVarFloat(Immune_BloatAmmo), Timer_DisableBloatImmune, victim, TIMER_FLAG_NO_MAPCHANGE);
			}
			if (blindAmmo[attacker] > 0 && !blindImmune[victim])
			{
				blindAmmo[attacker]--;
				BlindPlayer(victim, GetConVarInt(Effect_BlindAmmo));
				CreateTimer(GetConVarFloat(Time_BlindAmmo), Timer_DisableBlindEffect, victim, TIMER_FLAG_NO_MAPCHANGE);

				blindImmune[victim] = true;
				CreateTimer(GetConVarFloat(Immune_BlindAmmo), Timer_DisableBlindImmune, victim, TIMER_FLAG_NO_MAPCHANGE);
			}
			if (slowmoAmmo[attacker] > 0 && !slowmoImmune[victim])
			{
				slowmoAmmo[attacker]--;
				SetEntDataFloat(victim, laggedMovementOffset, GetConVarFloat(Effect_SlowmoAmmo), true);
				CreateTimer(GetConVarFloat(Time_SlowmoAmmo), Timer_DisableSlowmoEffect, victim, TIMER_FLAG_NO_MAPCHANGE);

				slowmoImmune[victim] = true;
				CreateTimer(GetConVarFloat(Immune_SlowmoAmmo), Timer_DisableSlowmoImmune, victim, TIMER_FLAG_NO_MAPCHANGE);
			}
			if (beanbagAmmo[attacker] > 0 && !beanbagImmune[victim])
			{
				beanbagAmmo[attacker]--;
				new Float:vel[3];
				vel[0] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[0]");
				vel[1] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[1]");
				vel[2] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[2]");
				vel[0] -= GetConVarFloat(Effect_BeanbagAmmo[0]);
				vel[1] -= GetConVarFloat(Effect_BeanbagAmmo[1]);
				vel[2] += GetConVarFloat(Effect_BeanbagAmmo[2]);
				TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, vel);

				beanbagImmune[victim] = true;
				CreateTimer(GetConVarFloat(Immune_BeanbagAmmo), Timer_DisableBeanbagImmune, victim, TIMER_FLAG_NO_MAPCHANGE);
			}
			if (spatialAmmo[attacker] > 0 && !spatialImmune[victim])
			{
				spatialAmmo[attacker]--;
				SetEntityGravity(victim, -100.0);
				new Float:vel[3];
				vel[0] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[0]");
				vel[1] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[1]");
				vel[2] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[2]");
				vel[2] += GetConVarFloat(Effect_BeanbagAmmo[2]);
				TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, vel);
				CreateTimer(GetConVarFloat(Time_SpatialAmmo), Timer_DisableSpatialEffect, victim, TIMER_FLAG_NO_MAPCHANGE);

				spatialImmune[victim] = true;
				CreateTimer(GetConVarFloat(Immune_SpatialAmmo), Timer_DisableSpatialImmune, victim, TIMER_FLAG_NO_MAPCHANGE);
			}
		}
	}
	else if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED && 
			 !IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		if (!classTank[attacker]) damageDealt[attacker][victim] += damage;
		else damageDealt[attacker][victim] += RoundToFloor(damage * GetConVarFloat(infectedDamageMultiplierTank));

		if (bileCovered[victim]) bilePoints[victim] += (1.0 * survivorMultiplier[victim]);

		if (classSpitter[attacker] && spitSlowTime > 0.0 && spitSlowAmount < 1.0 && !bSlow[victim])
		{
			bSlow[victim] = true;
			SetEntDataFloat(victim, laggedMovementOffset, 1.0 - spitSlowAmount, true);
			CreateTimer(spitSlowTime, Timer_DisableSpitSlowSpeed, victim, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public Action:Event_WitchKilled(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_SURVIVORS)
	{
		PrintToSurvivors("%s - \x03%N \x01has eliminated a witch.", INFO_GENERAL, attacker);
	}
	witchCount--;
}

public Action:Event_PlayerShoved(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client						= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(client) && IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == TEAM_INFECTED && 
		bUnstableBoomer && classBoomer[client])
	{
		SetEntityHealth(client, 1);
		IgniteEntity(client, 1.0);
	}
}

public Action:Event_RescueVehicleArrives(Handle:event, String:event_name[], bool:dontBroadcast)
{
	rescueVehicleHasArrived = true;
	PrintToSurvivors("%s - \x01The rescue vehicle has arrived, \x05respawns have been disabled.", INFO_GENERAL);
}