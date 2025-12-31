/*		THESE TIMERS ARE ASSOCIATED WITH THE EQUIPMENT LOCKER AND NOT THE ACTUAL USEPOINTS SYSTEM		*/

public EnableMultiplierTimers()
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsHuman(i) || XPMultiplierTime[i] <= 0 || XPMultiplierTimer[i]) continue;
		XPMultiplierTimer[i] = true;
		PrintToChat(i, "%s \x01Your bonus multiplier is now active.", INFO);
		CreateTimer(1.0, DeductMultiplierTime, i, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action:Timer_EnableWOFBots(Handle:timer)
{
	bWOFCooldown = false;
	return Plugin_Stop;
}

public DayOfPlayedAchievement(client)
{
	if (GetClientTeam(client) == 2)
	{
		PrintToChatAll("%s \x03%N \x01has just recorded \x04%d \x01DAYS of play time in this server!", INFO, client, TimePlayed[client][0]);
		PrintToChatAll("%s \x03%N \x01earned the \x05Dedicated Achievement. \x01Value: \x04%d \x05XP \x01All Categories + %d Sky Points.", ACHIEVEMENT_INFO, client, TimePlayed[client][0] * GetConVarInt(OneDayBonus), GetConVarInt(SkyPointsPerDay));
	}
	else if (GetClientTeam(client) == 3)
	{
		PrintToChatAll("%s \x04%N \x01has just recorded \x04%d \x01DAYS of play time in this server!", INFO, client, TimePlayed[client][0]);
		PrintToChatAll("%s \x04%N \x01earned the \x05Dedicated Achievement. \x01Value: \x04%d \x05XP \x01All Categories + %d Sky Points.", ACHIEVEMENT_INFO, client, TimePlayed[client][0] * GetConVarInt(OneDayBonus), GetConVarInt(SkyPointsPerDay));
	}
	Pi[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Me[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Uz[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Sh[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Sn[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Ri[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Gr[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	It[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Ph[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Hu[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Sm[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Bo[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Jo[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Ch[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Sp[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	Ta[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	In[client][0] += (TimePlayed[client][0] * GetConVarInt(OneDayBonus));
	experience_increase(client, 0);

	SkyPoints[client] += GetConVarInt(SkyPointsPerDay);
	SaveSkyPoints(client);
}

public Action:RecordPlayerTime(Handle:timer)
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i)) continue;
		if (IsFakeClient(i)) continue;
		TimePlayed[i][3]++;
		if (TimePlayed[i][3] >= 60)
		{
			TimePlayed[i][3] = 0;
			TimePlayed[i][2]++;
			if (TimePlayed[i][2] >= 60)
			{
				// Award a sky point bonus for an hour of play!
				SkyPoints[i] += GetConVarInt(SkyPointsPerHour);
				SaveSkyPoints(i);
				PrintToChat(i, "%s \x01Earned: \x03%d Sky Points \x01added to your account (\x04hourly bonus\x01)", INFO, GetConVarInt(SkyPointsPerHour));

				TimePlayed[i][2] = 0;
				TimePlayed[i][1]++;
				if (TimePlayed[i][1] >= 24)
				{
					TimePlayed[i][1] = 0;
					TimePlayed[i][0]++;
					DayOfPlayedAchievement(i);
				}
			}
		}
		if (GetClientTeam(i) == 3)
		{
			// Check if their levels do not match as it sometimes won't catch
			// Like when they earn levels at round end.
			if (InfectedLevel[i] != In[i][2])
			{
				TimeInfectedPlayed[i][3] = 0;
				TimeInfectedPlayed[i][2] = 0;
				TimeInfectedPlayed[i][1] = 0;
				TimeInfectedPlayed[i][0] = 0;
				InfectedLevel[i] = In[i][2];
			}
			TimeInfectedPlayed[i][3]++;
			if (TimeInfectedPlayed[i][3] >= 60)
			{
				TimeInfectedPlayed[i][3] = 0;
				TimeInfectedPlayed[i][2]++;
				if (TimeInfectedPlayed[i][2] >= 60)
				{
					TimeInfectedPlayed[i][2] = 0;
					TimeInfectedPlayed[i][1]++;
					if (TimeInfectedPlayed[i][1] >= 24)
					{
						TimeInfectedPlayed[i][1] = 0;
						TimeInfectedPlayed[i][0]++;
					}
				}
			}
		}
		else if (GetClientTeam(i) == 2)
		{
			if (SurvivorLevel[i] != Ph[i][2])
			{
				TimeSurvivorPlayed[i][3] = 0;
				TimeSurvivorPlayed[i][2] = 0;
				TimeSurvivorPlayed[i][1] = 0;
				TimeSurvivorPlayed[i][0] = 0;
				SurvivorLevel[i] = Ph[i][2];
			}
			TimeSurvivorPlayed[i][3]++;
			if (TimeSurvivorPlayed[i][3] >= 60)
			{
				TimeSurvivorPlayed[i][3] = 0;
				TimeSurvivorPlayed[i][2]++;
				if (TimeSurvivorPlayed[i][2] >= 60)
				{
					TimeSurvivorPlayed[i][2] = 0;
					TimeSurvivorPlayed[i][1]++;
					if (TimeSurvivorPlayed[i][1] >= 24)
					{
						TimeSurvivorPlayed[i][1] = 0;
						TimeSurvivorPlayed[i][0]++;
					}
				}
			}
		}
	}
}

public Action:DeductMultiplierTime(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client)) return Plugin_Stop;
	if (!IsClientInGame(client) || IsFakeClient(client) || !XPMultiplierTimer[client]) return Plugin_Stop;
	if (RoundReset)
	{
		XPMultiplierTimer[client] = false;
		PrintToChat(client, "%s \x01Your bonus multiplier is now inactive.", INFO);
		return Plugin_Stop;
	}
	if (IsPlayerAlive(client))
	{
		XPMultiplierTime[client]--;
		if (XPMultiplierTime[client] <= 0)
		{
			XPMultiplierTime[client] = 0;
			XPMultiplierTimer[client] = false;
			return Plugin_Stop;
		}
	}
	return Plugin_Continue;
}

public Action:DrugsUsedCounter(Handle:timer, any:attacker)
{
	if (IsClientIndexOutOfRange(attacker)) return Plugin_Stop;
	if (RoundReset)
	{
		DrugTimer[attacker] = -1.0;
		return Plugin_Stop;
	}
	if (!IsClientInGame(attacker) || IsFakeClient(attacker) || !IsPlayerAlive(attacker)) return Plugin_Stop;
	if (DrugTimer[attacker] == -1.0) DrugTimer[attacker] = GetConVarFloat(DrugTimerStart);
	if (DrugTimer[attacker] == 0.0)
	{
		DrugTimer[attacker] = -1.0;
		ForcePlayerSuicide(attacker);
		PrintToSurvivors("%s \x03%N \x01died due to a drug overdose.", INFO, attacker);
		return Plugin_Stop;
	}
	PrintHintText(attacker, "You're addicted!\n%3.1f sec(s) remaining to get your fix!", DrugTimer[attacker]);
	DrugTimer[attacker]--;
	return Plugin_Continue;
}

public Action:EnableUncommonEvent(Handle:timer)
{
	if (UncommonPanicEventCount == -1.0) UncommonPanicEventCount = 0.0;
	if (UncommonPanicEventCount >= GetConVarFloat(UncommonPanicEventTimer) || RoundReset)
	{
		UncommonPanicEventCount = -1.0;
		return Plugin_Stop;
	}
	UncommonPanicEventCount++;
	return Plugin_Continue;
}

public Action:EnableHealAmmo(Handle:timer, any:attacker)
{
	if (IsClientIndexOutOfRange(attacker)) return Plugin_Stop;
	if (!IsClientInGame(attacker) || IsFakeClient(attacker)) return Plugin_Stop;
	if (HealAmmoCounter[attacker] == -1.0) HealAmmoCounter[attacker] = 0.0;
	if (HealAmmoCounter[attacker] >= GetConVarFloat(HealAmmoCooldown))
	{
		HealAmmoCounter[attacker] = -1.0;
		HealAmmoDisabled[attacker] = false;
		PrintToChat(attacker, "%s \x03Heal Ammo \x01is available.", INFO);
		return Plugin_Stop;
	}
	HealAmmoCounter[attacker]++;
	return Plugin_Continue;
}

public SetTheVip()
{
	// We need to set a VIP.

	VipName = 0;
	VipExperience = 0;
	new PotentialVipFound = 0;
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i)) continue;
		if (!IsClientInGame(i) || IsFakeClient(i) || !IsPlayerAlive(i) || GetClientTeam(i) != 2) continue;
		if (Ph[i][2] < GetConVarInt(VipMinimumLevel)) continue;
		PotentialVipFound++;
	}
	if (PotentialVipFound >= 2)
	{
		new i = 0;
		while (VipExperience == 0)
		{
			i = GetRandomInt(1, MaxClients);
			if (!IsClientIndexOutOfRange(i) && IsClientInGame(i) && !IsFakeClient(i) && IsPlayerAlive(i) && GetClientTeam(i) == 2)
			{
				if (Ph[i][2] >= GetConVarInt(VipMinimumLevel))
				{
					PrintToSurvivors("%s \x03%N \x01is your VIP! Protect Them!", INFO, i);
					PrintToInfected("%s \x04%N \x01is the Survivor VIP! \x04KILL THEM!", INFO, i);
					VipName = i;
					VipExperience = GetConVarInt(VipAward) * Ph[i][2];
					SetEntityRenderMode(i, RENDER_TRANSCOLOR);
					SetEntityRenderColor(i, GetConVarInt(VipColor[0]), GetConVarInt(VipColor[1]), GetConVarInt(VipColor[2]), 255);
				}
			}
		}
	}
}

public Action:Timer_RemoveTankIce(Handle:timer, any:client)
{
	bIcedByTank[client] = false;
	SetEntDataFloat(client, laggedMovementOffset, 1.0, true);
	return Plugin_Stop;
}

public Action:RemoveFireTankImmune(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim) || IsFakeClient(victim) || !IsPlayerAlive(victim) || GetClientTeam(victim) != 2) return Plugin_Stop;
	if (FireTankCount[victim] == -1.0) FireTankCount[victim] = 0.0;
	if (FireTankCount[victim] < GetConVarFloat(FireTankTime))
	{
		FireTankCount[victim]++;
		if (GetClientHealth(victim) - GetConVarInt(FireTankDamage) >= 1)
		{
			SetEntityHealth(victim, GetClientHealth(victim) - GetConVarInt(FireTankDamage));
		}
		else
		{
			FireTankImmune[victim] = false;
			return Plugin_Stop;
		}
		if (GetClientHealth(victim) > GetConVarInt(FireTankHealthEnd))
		{
			FireTankImmune[victim] = false;
			return Plugin_Stop;
		}
		return Plugin_Continue;
	}
	else
	{
		FireTankImmune[victim] = false;
		return Plugin_Stop;
	}
}

public Action:RemoveDrugEffect(Handle:timer, any:attacker)
{
	if (IsClientIndexOutOfRange(attacker)) return Plugin_Stop;
	if (!IsClientInGame(attacker) || IsFakeClient(attacker)) return Plugin_Stop;
	DrugEffect[attacker] = false;
	PrintToChat(attacker, "%s \x01The drugs effects have worn off.", INFO);
	return Plugin_Stop;
}

public Action:RemoveBlindAmmo(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim) || IsFakeClient(victim)) return Plugin_Stop;
	BlindPlayer(victim, 0);
	CreateTimer(GetConVarFloat(BlindAmmoCooldown), RemoveBlindImmune, victim, TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

public Action:RemoveBlindImmune(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim) || IsFakeClient(victim)) return Plugin_Stop;
	BlindAmmoImmune[victim] = false;
	return Plugin_Stop;
}

public Action:RemoveBloatAmmo(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim)) return Plugin_Stop;
	if (IsPlayerAlive(victim) && GetClientTeam(victim) == 2) SetEntityGravity(victim, 1.0);
	else if (IsPlayerAlive(victim) && GetClientTeam(victim) == 3) SetEntityGravity(victim, 1.0 - (0.01 * In[victim][2]));
	SufferingFromBloatAmmo[victim] = false;
	CreateTimer(GetConVarFloat(BloatAmmoCooldown), RemoveBloatImmune, victim, TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

public Action:RemoveBloatImmune(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim)) return Plugin_Stop;
	BloatAmmoImmune[victim] = false;
	return Plugin_Stop;
}

public Action:RemoveIceAmmo(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim)) return Plugin_Stop;
	// Set speed to the level speed of the victim.
	if (IsPlayerAlive(victim)) SetEntDataFloat(victim, laggedMovementOffset, PlayerMovementSpeed[victim], true);
	CreateTimer(GetConVarFloat(IceAmmoCooldown), RemoveIceImmune, victim, TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Stop;
}

public Action:RemoveIceImmune(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim)) return Plugin_Stop;
	IceAmmoImmune[victim] = false;
	return Plugin_Stop;
}

public Action:RemoveHeavySpit(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim) || IsFakeClient(victim)) return Plugin_Stop;
	HeavyBySpit[victim] = false;
	SetEntityGravity(victim, 1.0);
	return Plugin_Stop;
}

public Action:RemoveStickySpit(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim) || IsFakeClient(victim)) return Plugin_Stop;
	if (IsPlayerAlive(victim)) SetEntDataFloat(victim, laggedMovementOffset, 1.0, true);
	CreateTimer(GetConVarFloat(StickySpitImmuneTime), RemoveStickySpitImmune, victim);
	return Plugin_Stop;
}

public Action:RemoveStickySpitImmune(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim) || IsFakeClient(victim)) return Plugin_Stop;
	SpitterImmune[victim] = false;
	return Plugin_Stop;
}

public Action:RewardBoomerPoints(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim) || IsFakeClient(victim)) return Plugin_Stop;
	CoveredInBile[victim] = false;
	new attacker = WhoWasBoomer[victim];
	if (!IsClientInGame(attacker)) return Plugin_Stop;
	if (!IsFakeClient(attacker))
	{
		InfectedPoints[attacker] += BoomerActionPoints[victim];
		Bo[attacker][0] += RoundToFloor(BoomerActionPoints[victim] * GetConVarFloat(BileHitXP));
		if (BoomerActionPoints[victim] > 0.0) PrintToChat(attacker, "%s \x04%3.3f \x01Bile Hurt point(s) against \x03%N", POINTS_INFO, BoomerActionPoints[victim], victim);
	}
	else
	{
		AIBoomer[0] += RoundToFloor(BoomerActionPoints[victim] * GetConVarFloat(BileHitXP));
	}
	// Give them no experience, since we've forced experience to their boomer pool.
	// Do this in case the experience is awarded after they're no longer a boomer.
	BoomerActionPoints[victim] = 0.0;
	experience_increase(attacker, 0);
	return Plugin_Stop;
}

public Action:EnableIncapTimer(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim) || IsFakeClient(victim)) return Plugin_Stop;
	IncapDisabled[victim] = false;
	return Plugin_Stop;
}

public Action:SetIncapProtectionHealth(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim)) return Plugin_Stop;
	if (!IsPlayerAlive(victim)) return Plugin_Stop;
	if (!IsFakeClient(victim)) SetEntityHealth(victim, 100 + Ph[victim][2] + It[victim][2]);
	else SetEntityHealth(victim, 100);
	return Plugin_Stop;
}

public Action:EnableIncapProtection(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim) || IsFakeClient(victim)) return Plugin_Stop;
	IncapProtection[victim] = 0;
	PrintToChat(victim , "%s \x04Incap Protection \x01is now available for purchase.", INFO);
	return Plugin_Stop;
}

public Action:EnableTankPurchases(Handle:timer)
{
	if (TankCooldownTime == -1.0) TankCooldownTime = 1.0;
	TankCooldownTime++;
	if (TankCooldownTime >= GetConVarFloat(TankCooldown) || RoundReset)
	{
		TankCooldownTime = 0.0;
		PrintToInfected("%s \x01Tank purchases are \x05no longer restricted\x01.", INFO);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:EnableM60(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client)) return Plugin_Stop;
	if (!IsClientInGame(client) || IsFakeClient(client)) return Plugin_Stop;
	if (!M60CD[client]) return Plugin_Stop;
	if (M60COUNT[client] == -1.0) M60COUNT[client] = 0.0;
	M60COUNT[client]++;
	if (M60COUNT[client] >= GetConVarFloat(M60CDTIME))
	{
		M60COUNT[client] = 0.0;
		M60CD[client] = false;
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:CheckForGrounding(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client)) return Plugin_Stop;
	if (!IsClientInGame(client) || IsFakeClient(client)) return Plugin_Stop;
	if (GetClientTeam(client) != 2 || !IsPlayerAlive(client)) return Plugin_Stop;
	if (GetEntityFlags(client) & FL_ONGROUND)
	{
		SetEntityGravity(client, 1.0);
		return Plugin_Stop;
	}
	else if (CoveredInBile[client] || Ensnared[client])
	{
		SetEntityGravity(client, 1.0);
		return Plugin_Stop;
	}
	else if (HeavyBySpit[client])
	{
		SetEntityGravity(client, 5.0);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:CheckIfEnsnared(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim) || !IsPlayerAlive(victim)) return Plugin_Stop;
	if (GetClientTeam(victim) != 2 || IncapProtection[victim] < 1 || !IsIncapacitated(victim) || IncapDisabled[victim]) return Plugin_Stop;
	if (L4D2_GetInfectedAttacker(victim) == -1)
	{
		if (!IsFakeClient(victim))
		{
			IncapDisabled[victim] = true;
			CreateTimer(5.0, EnableIncapTimer, victim, TIMER_FLAG_NO_MAPCHANGE);
		}

		Ensnared[victim] = false;
		IncapProtection[victim]--;
		ExecCheatCommand(victim, "give", "health");
		
		if (IncapProtection[victim] < 1)
		{
			PrintToChat(victim, "%s \x01No Incap Protection charges remaining.", INFO);
			IncapProtection[victim] = -1;
			CreateTimer(GetConVarFloat(IncapProtectionDisabled), EnableIncapProtection, victim, TIMER_FLAG_NO_MAPCHANGE);
			PrintToChat(victim, "%s \x03%2.1f \x01second(s) until \x04Incap Protection \x01may be purchased.", INFO, GetConVarFloat(IncapProtectionDisabled));
		}
		else PrintToChat(victim, "%s \x03%d \x01charges of \x04Incap Protection \x01remaining.", INFO, IncapProtection[victim]);
		CreateTimer(0.1, SetIncapProtectionHealth, victim, TIMER_FLAG_NO_MAPCHANGE);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:RemoveDeepFreeze(Handle:timer)
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i)) continue;
		if (!IsClientInGame(i) || IsFakeClient(i)) continue;
		if (GetClientTeam(i) != 2) continue;
		PlayerMovementSpeed[i] += GetConVarFloat(DeepFreezeSlowDown);
		if (!IsPlayerAlive(i)) continue;
		SetEntDataFloat(i, laggedMovementOffset, PlayerMovementSpeed[i], true);
	}
}

public Action:RemoveSmokerWhip(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client)) return Plugin_Stop;
	if (!IsClientInGame(client) || IsFakeClient(client)) return Plugin_Stop;
	SmokerWhipCooldown[client] = false;
	return Plugin_Stop;
}

public Action:RemoveJockeyJump(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client)) return Plugin_Stop;
	if (!IsClientInGame(client)) return Plugin_Stop;
	JockeyJumpCooldown[client] = false;
	return Plugin_Stop;
}

public L4D_OnEnterGhostState(client)
{	
	if (ClassTank[client] == true)
	{
		InfectedGhost[client] = true;
		point_restriction(client);
		InfectedPlayerHasDied(client);
		
		TankCount--;
		TankCooldownTime = -1.0;
		if (TankCount < 1)
		{
			TankCount = 0;
			CreateTimer(1.0, EnableTankPurchases, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	// If player is ghost, move to class select function, destroy.
	SelectClass(client);
}

/*
public Action:Timer_IsPlayerGhost(Handle:timer, any:client)
{
	// If the player is not on infected team, or is alive but is not a ghost, destroy.
	if (client < 1 || !IsClientInGame(client) || GetClientTeam(client) != 3 || (!IsPlayerGhost(client) && IsPlayerAlive(client))) return Plugin_Stop;
	if (IsPlayerGhost(client))
	{
		// If ghost, check to see if the player was previously a tank.
		// If they were, remove a tank counter.
		if (ClassTank[client] == true)
		{
			TankCount--;
			TankCooldownTime = -1.0;
			if (TankCount < 1)
			{
				TankCount = 0;
				CreateTimer(1.0, EnableTankPurchases, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		// If player is ghost, move to class select function, destroy.
		SelectClass(client);
		return Plugin_Stop;
	}
	return Plugin_Continue;
}
*/

stock SelectClass(client)
{
	if (!IsPlayerGhost(client)) return;					// if not a ghost at this point, destroy.
	new random_num = GetRandomInt(1, 2);
	decl class_selection;
	ghost_rotation[client]++;
	if (ghost_rotation[client] == 1)
	{
		if (random_num == 1) class_selection = 3;		// hunter
		else				 class_selection = 5;		// jockey
	}
	else if (ghost_rotation[client] == 2)
	{
		if (random_num == 1) class_selection = 1;		// smoker
		else				 class_selection = 6;		// charger
	}
	else if (ghost_rotation[client] == 3)
	{
		if (random_num == 1) class_selection = 2;		// boomer
		else				 class_selection = 4;		// spitter
		// player at end of rotation, set to 0.
		ghost_rotation[client] = 0;
	}
	if (IsPlayerGhost(client))
	{
		new WeaponIndex;
		while ((WeaponIndex = GetPlayerWeaponSlot(client, 0)) != -1)
		{
			RemovePlayerItem(client, WeaponIndex);
			RemoveEdict(WeaponIndex);
		}
		SDKCall(g_hSetClass, client, class_selection);
		AcceptEntityInput(MakeCompatEntRef(GetEntProp(client, Prop_Send, "m_customAbility")), "Kill");
		SetEntProp(client, Prop_Send, "m_customAbility", GetEntData(SDKCall(g_hCreateAbility, client), g_oAbility));

		// Find out if the player can spawn anywhere that they want to.
		//Check_SpawnAnywhere(client);
		SDKHook(client, SDKHook_PreThinkPost, Check_SpawnAnywhere);
	}
}

public Check_SpawnAnywhere(client)
{
	if (!IsPlayerGhost(client)) return;
	if (!bAllClientsLoaded || RoundReset) return;
	new Class = GetEntProp(client, Prop_Send, "m_zombieClass");

	if (Class == ZOMBIECLASS_HUNTER && Hu[client][2] >= GetConVarInt(SpawnAnywhereLevel)) SetEntProp(client, Prop_Send, "m_ghostSpawnState", 0);
	else if (Class == ZOMBIECLASS_SMOKER && Sm[client][2] >= GetConVarInt(SpawnAnywhereLevel)) SetEntProp(client, Prop_Send, "m_ghostSpawnState", 0);
	else if (Class == ZOMBIECLASS_BOOMER && Bo[client][2] >= GetConVarInt(SpawnAnywhereLevel)) SetEntProp(client, Prop_Send, "m_ghostSpawnState", 0);
	else if (Class == ZOMBIECLASS_JOCKEY && Jo[client][2] >= GetConVarInt(SpawnAnywhereLevel)) SetEntProp(client, Prop_Send, "m_ghostSpawnState", 0);
	else if (Class == ZOMBIECLASS_CHARGER && Ch[client][2] >= GetConVarInt(SpawnAnywhereLevel)) SetEntProp(client, Prop_Send, "m_ghostSpawnState", 0);
	else if (Class == ZOMBIECLASS_SPITTER && Sp[client][2] >= GetConVarInt(SpawnAnywhereLevel)) SetEntProp(client, Prop_Send, "m_ghostSpawnState", 0);
}

public Action:EnableUncommonPurchases(Handle:timer)
{
	if (!UncommonCooldown) return Plugin_Stop;
	if (UncommonCooldownCount < GetConVarFloat(UncommonCooldownTime))
	{
		UncommonCooldownCount++;
		return Plugin_Continue;
	}
	else if (UncommonCooldownCount >= GetConVarFloat(UncommonCooldownTime))
	{
		UncommonCooldownCount = 0.0;
		UncommonCooldown = false;
		return Plugin_Stop;
	}
	return Plugin_Continue;
}

public Action:EnableDeepFreeze(Handle:timer)
{
	DeepFreezeCooldown = false;
	PrintToChatAll("%s \x04Deep Freeze \x01can be triggered again!", INFO);
	return Plugin_Stop;
}

public Action:EnableBurnDamage(Handle:timer, any:victim)
{
	if (IsClientIndexOutOfRange(victim)) return Plugin_Stop;
	if (!IsClientInGame(victim) || IsFakeClient(victim)) return Plugin_Stop;
	if (!IsPlayerAlive(victim)) return Plugin_Stop;
	BurnDamageImmune[victim] = false;
	return Plugin_Stop;
}

public Action:RemoveSpitterInvis(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client)) return Plugin_Stop;
	if (!IsClientInGame(client)) return Plugin_Stop;
	SetEntityRenderMode(client, RENDER_TRANSCOLOR);
	if (Sp[client][2] < GetConVarInt(InfectedTier4Level)) SetEntityRenderColor(client, GetConVarInt(InfectedTier3Color[0]), GetConVarInt(InfectedTier3Color[1]), GetConVarInt(InfectedTier3Color[2]), 255);
	else SetEntityRenderColor(client, GetConVarInt(InfectedTier4Color[0]), GetConVarInt(InfectedTier4Color[1]), GetConVarInt(InfectedTier4Color[2]), 235);
	SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
	return Plugin_Stop;
}