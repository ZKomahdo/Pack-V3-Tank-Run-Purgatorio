#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

_DamageEvents_OnPluginStart()
{
	g_WeaponTrailLevel = CreateConVar("skyrpg_weapon_trail_level","0","If 0, trails are available to weapons of max level, otherwise the level stated.", CVAR_SHOW);

	HookEvent("infected_death", Event_InfectedDeath);
	HookEvent("player_death", Event_PlayerDeath);
	HookEvent("player_hurt", Event_PlayerHurt);
	HookEvent("player_incapacitated", Event_PlayerIncapacitated);
	HookEvent("player_shoved", Event_PlayerShoved);
	HookEvent("zombie_ignited", Event_ZombieIgnited);
	HookEvent("finale_escape_start", Event_FinaleEscapeStart);
	HookEvent("player_ledge_grab", Event_LedgeGrab);
	HookEvent("tank_killed", Event_TankKilled);
	HookEvent("witch_killed", Event_WitchKilled);
	HookEvent("finale_start", Event_FinaleRadioStart);

	HookEvent("bullet_impact", Event_BulletImpact);
}

public bool:bBulletTrailUnlocked(attacker)
{
	if ((GetConVarInt(g_WeaponTrailLevel) > 0 && Pi[attacker][2] >= GetConVarInt(g_WeaponTrailLevel)) || 
			Pi[attacker][2] == GetConVarInt(LevelCap)) return true;
	else if ((GetConVarInt(g_WeaponTrailLevel) > 0 && Uz[attacker][2] >= GetConVarInt(g_WeaponTrailLevel)) || 
			Uz[attacker][2] == GetConVarInt(LevelCap)) return true;
	else if ((GetConVarInt(g_WeaponTrailLevel) > 0 && Sh[attacker][2] >= GetConVarInt(g_WeaponTrailLevel)) || 
			Sh[attacker][2] == GetConVarInt(LevelCap)) return true;
	else if ((GetConVarInt(g_WeaponTrailLevel) > 0 && Ri[attacker][2] >= GetConVarInt(g_WeaponTrailLevel)) || 
			Ri[attacker][2] == GetConVarInt(LevelCap)) return true;
	else if ((GetConVarInt(g_WeaponTrailLevel) > 0 && Sn[attacker][2] >= GetConVarInt(g_WeaponTrailLevel)) || 
			Sn[attacker][2] == GetConVarInt(LevelCap)) return true;
	else return false;
}

public bool:bWeaponTrailLevel(attacker)
{
	new String:weaponused[64];
	GetClientWeapon(attacker, weaponused, sizeof(weaponused));
	if (StrEqual(weaponused, "weapon_pistol", true) || StrEqual(weaponused, "weapon_pistol_magnum", true))
	{
		if ((GetConVarInt(g_WeaponTrailLevel) > 0 && Pi[attacker][2] >= GetConVarInt(g_WeaponTrailLevel)) || 
			Pi[attacker][2] == GetConVarInt(LevelCap))
		{
			ColourTrail[attacker][0] = PiTrail[attacker][0];
			ColourTrail[attacker][1] = PiTrail[attacker][1];
			ColourTrail[attacker][2] = PiTrail[attacker][2];
			ColourTrail[attacker][3] = PiTrail[attacker][3];
			return true;
		}
		else return false;
	}
	else if (StrEqual(weaponused, "weapon_smg", true) || StrEqual(weaponused, "weapon_smg_mp5", true) || StrEqual(weaponused, "weapon_smg_silenced", true))
	{
		if ((GetConVarInt(g_WeaponTrailLevel) > 0 && Uz[attacker][2] >= GetConVarInt(g_WeaponTrailLevel)) || 
			Uz[attacker][2] == GetConVarInt(LevelCap))
		{
			ColourTrail[attacker][0] = UzTrail[attacker][0];
			ColourTrail[attacker][1] = UzTrail[attacker][1];
			ColourTrail[attacker][2] = UzTrail[attacker][2];
			ColourTrail[attacker][3] = UzTrail[attacker][3];
			return true;
		}
		else return false;
	}
	else if (StrEqual(weaponused, "weapon_autoshotgun", true) || StrEqual(weaponused, "weapon_pumpshotgun", true) || 
			 StrEqual(weaponused, "weapon_shotgun_chrome", true) || StrEqual(weaponused, "weapon_shotgun_spas", true))
	{
		if ((GetConVarInt(g_WeaponTrailLevel) > 0 && Sh[attacker][2] >= GetConVarInt(g_WeaponTrailLevel)) || 
			Sh[attacker][2] == GetConVarInt(LevelCap))
		{
			ColourTrail[attacker][0] = ShTrail[attacker][0];
			ColourTrail[attacker][1] = ShTrail[attacker][1];
			ColourTrail[attacker][2] = ShTrail[attacker][2];
			ColourTrail[attacker][3] = ShTrail[attacker][3];
			return true;
		}
		else return false;
	}
	else if (StrEqual(weaponused, "weapon_rifle", true) || StrEqual(weaponused, "weapon_rifle_ak47", true) || 
			 StrEqual(weaponused, "weapon_rifle_desert", true) || StrEqual(weaponused, "weapon_rifle_m60", true) || 
			 StrEqual(weaponused, "weapon_rifle_sg552", true))
	{
		if ((GetConVarInt(g_WeaponTrailLevel) > 0 && Ri[attacker][2] >= GetConVarInt(g_WeaponTrailLevel)) || 
			Ri[attacker][2] == GetConVarInt(LevelCap))
		{
			ColourTrail[attacker][0] = RiTrail[attacker][0];
			ColourTrail[attacker][1] = RiTrail[attacker][1];
			ColourTrail[attacker][2] = RiTrail[attacker][2];
			ColourTrail[attacker][3] = RiTrail[attacker][3];
			return true;
		}
		else return false;
	}
	else if (StrEqual(weaponused, "weapon_sniper_awp", true) || StrEqual(weaponused, "weapon_sniper_military", true) || 
			 StrEqual(weaponused, "weapon_sniper_scout", true) || StrEqual(weaponused, "weapon_hunting_rifle", true))
	{
		if ((GetConVarInt(g_WeaponTrailLevel) > 0 && Sn[attacker][2] >= GetConVarInt(g_WeaponTrailLevel)) || 
			Sn[attacker][2] == GetConVarInt(LevelCap))
		{
			ColourTrail[attacker][0] = SnTrail[attacker][0];
			ColourTrail[attacker][1] = SnTrail[attacker][1];
			ColourTrail[attacker][2] = SnTrail[attacker][2];
			ColourTrail[attacker][3] = SnTrail[attacker][3];
			return true;
		}
		else return false;
	}
	return false;
}

public Action:Event_BulletImpact(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));

	if (IsClientIndexOutOfRange(attacker) || !IsClientInGame(attacker) || IsFakeClient(attacker)) return;

	// Two ways to unlock weapon trails. Buy it with sky points or have your current weapon meet the level requirement.
	if (bWeaponTrailLevel(attacker) && weaponTrails[attacker] == 1)
	{
		new Float:Coords[3];
		Coords[0] = GetEventFloat(event, "x");
		Coords[1] = GetEventFloat(event, "y");
		Coords[2] = GetEventFloat(event, "z");
		new Float:EyeCoords[3];
		GetClientEyePosition(attacker, EyeCoords);
		// Adjust the coords so they line up with the gun
		EyeCoords[2] += -5.0;
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 2) continue;
			TE_SetupBeamPoints(EyeCoords, Coords, g_iSprite, 0, 0, 0, GetConVarFloat(g_LaserTime), GetConVarFloat(g_LaserWidth), GetConVarFloat(g_LaserWidth), 1, 0.0, ColourTrail[attacker], 0);
			TE_SendToClient(i);
		}
	}
}

public Action:Event_WitchKilled(Handle:event, String:event_name[], bool:dontBroadcast)
{
	if (witchCount > 0) witchCount--;
}

public Action:Event_TankKilled(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid"));
	//if (IsClientIndexOutOfRange(victim) || !IsFakeClient(victim)) return;

	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && IsFakeClient(victim))
	{
		InfectedPlayerHasDied(victim);

		// If TankCount already is 0 when a tank dies, it means the director didn't buy it
		// So we don't want to go through here (or it'll completely mess up the timers)
		if (TankCount < 1) return;
		TankCount--;
		PrintToChatAll("%s \x04Tanks Alive: \x01%d", INFO, TankCount);
		TankCooldownTime = -1.0;
		if (TankCount < 1)
		{
			TankCount = 0;
			PrintToChatAll("%s \x04Tanks are restricted", INFO);
			CreateTimer(1.0, EnableTankPurchases, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	/*
	else if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim))
	{
		InfectedGhost[victim] = true;
		point_restriction(victim);
		InfectedPlayerHasDied(victim);
	}
	*/
}

public Action:Timer_DelayLedgeHeal(Handle:timer, any:attacker)
{
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && IsFakeClient(attacker))
	{
		PrintToChatAll("%s \x04%N \x01has purchased \x05Instant Heal", INFO, attacker);
		ExecCheatCommand(attacker, "give", "health");
		HealCount[attacker]--;
	}
	return Plugin_Stop;
}

public Action:Event_LedgeGrab(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && IsFakeClient(attacker))
	{
		if (Ensnared[attacker] == false && HealCount[attacker] > 0)
		{
			CreateTimer(0.5, Timer_DelayLedgeHeal, attacker, TIMER_FLAG_NO_MAPCHANGE);
		}
		else if (Ensnared[attacker] == true && IncapProtection[attacker] > 0)
		{
			CreateTimer(1.0, CheckIfEnsnared, attacker, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		return;
	}
	if (It[attacker][2] < GetConVarInt(IncapProtectionAdvanced)) return;
	CreateTimer(1.0, CheckIfEnsnared, attacker, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

/*				PREVENT RESPAWNS WHEN THE FINALE HAS BEGIN					*/

public Action:Event_FinaleEscapeStart(Handle:event, String:event_name[], bool:dontBroadcast)
{
	bRescue = false;
	PrintToSurvivors("%s \x01The Rescue Vehicle is here!", INFO);
}

public Action:Event_FinaleRadioStart(Handle:event, String:event_name[], bool:dontBroadcast)
{
	RescueCalled = true;
	bRescue = true;
	PrintToChatAll("%s \x01The \x04Finale Radio \x01has been used! \x04Respawns Disabled\x01!", INFO);
}

/*				EVENTS FOR EARNING POINTS THROUGH KILLING THINGS			*/

public Action:Event_PlayerShoved(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (IsClientIndexOutOfRange(attacker) || !IsClientInGame(attacker) || GetClientTeam(attacker) != 2) return;
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || GetClientTeam(client) != 3) return;

	if (!IsFakeClient(client) && ClassBoomer[client] && (SuperUpgradeBoomer[client] || Bo[client][2] >= GetConVarInt(InfectedTier3Level)))
	{
		if (IsPlayerAlive(client))
		{
			SetEntityHealth(client, 1);
			IgniteEntity(client, 1.0);
		}
	}
	else if (IsFakeClient(client) && ClassBoomer[client] && AIBoomer[2] >= GetConVarInt(InfectedTier3Level))
	{
		if (IsPlayerAlive(client))
		{
			SetEntityHealth(client, 1);
			IgniteEntity(client, 1.0);
		}
	}

	if (!IsFakeClient(attacker) && Me[attacker][2] >= GetConVarInt(ShoveBounceLevel) && IsPlayerAlive(client))
	{
		new Float:vel[3];
		vel[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
		vel[0] += (GetConVarFloat(MeleeShovePower) * Me[attacker][2]);
		vel[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
		vel[1] += (GetConVarFloat(MeleeShovePower) * Me[attacker][2]);
		vel[2] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
		vel[2] += (GetConVarFloat(MeleeShovePower) * Me[attacker][2]);
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vel);
	}
}

public Action:Event_ZombieIgnited(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	if (IsClientIndexOutOfRange(attacker) || !IsClientInGame(attacker) || IsFakeClient(attacker) || GetClientTeam(attacker) != 2) return;
	experience_explosion_increase(attacker, 1);
}

public Action:Event_InfectedDeath(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (IsClientIndexOutOfRange(attacker) || !IsClientInGame(attacker) || IsFakeClient(attacker) || GetClientTeam(attacker) != 2) return;

	// Check the day of the month against the players saved day of the month
	// So we can reset the kill count for this daily quest if they do not match.
	decl String:sBuffer[32];
	FormatTime(sBuffer,sizeof(sBuffer),"%d");
	new day = StringToInt(sBuffer);

	// If days do not match...
	if (AchDate[attacker] != day)
	{
		ResetDailyAchievement(attacker, day);	// Reset all of the attackers daily achievement earnings.
	}
	AchievementCheck(attacker, 0);		// Send the client to the achievement page to check values.
	new bool:headshot = GetEventBool(event, "headshot");
	new bool:blast = GetEventBool(event, "blast");
	if (!blast)
	{
		if (headshot)
		{
			SurvivorHeadshotValue[attacker]++;
			experience_increase(attacker, 1 + GetConVarInt(HSXP));
			RoundHS[attacker]++;
			if (RoundHS[attacker] > BestSurvivorHS[0])
			{
				BestSurvivorHS[0] = RoundHS[attacker];
				BestSurvivorHS[1] = attacker;
			}
		}
		else experience_increase(attacker, 1);
	}
	if (blast)
	{
		experience_explosion_increase(attacker, 1);
	}
	RoundKills[attacker]++;
	if (IsClientIndexOutOfRange(BestKills[1]) || !IsClientInGame(BestKills[1]))
	{
		BestKills[0] = 0;
	}
	if (RoundKills[attacker] > BestKills[0])
	{
		BestKills[0] = RoundKills[attacker];
		BestKills[1] = attacker;
	}
	SurvivorCommonValue[attacker]++;
	TeamCommonValue++;
	experience_multiplier(attacker);
}

public Action:Event_PlayerDeath(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	new victim	 = GetClientOfUserId(GetEventInt(event, "userid"));

	if (IsHuman(victim) && 
		(Ph[victim][2] <= GetConVarInt(WikiForceLevel) || In[victim][2] <= GetConVarInt(WikiForceLevel))) Call_HelpMenu(victim);

	decl oldattacker;
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && 
		GetClientTeam(victim) == 2)
	{
		oldattacker = LastToHurtMe[victim];
	}
	if (!IsClientIndexOutOfRange(oldattacker) && IsClientInGame(oldattacker) && !IsFakeClient(oldattacker) && 
		GetClientTeam(oldattacker) == 3 && GetClientTeam(oldattacker) != GetClientTeam(victim))
	{
		// Check if the survivor player was the infected player's nemesis, and also set the
		// infected player as the survivor player's nemesis.
		decl String:Key[64];
		GetClientAuthString(victim, Key, 65);
		if (StrEqual(Key, Nemesis[oldattacker]))
		{
			// The Infected player killed the survivor who was his nemesis.
			// Award the XP, announce it to the world, and then set the survivor's nemesis.
			new count = 1;		// 1 for the player, obviously.

			// How many other people had this player as their nemesis? Let's find out.
			// Remove the player from their list if so, but add a counter.
			// The counter multiplies the value of the bounty.
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 3 || i == oldattacker || oldattacker == attacker) continue;

				// If this survivor isn't the nemesis of an oldattacker, ignore them.
				if (!StrEqual(Key, Nemesis[i])) continue;

				PrintToChat(i, "%s \x01Your nemesis, \x03%N\x01, was killed by \x04%N \x01for \x04%d \x01XP!", INFO, victim, oldattacker, (GetConVarInt(NemesisAward) * count));
				count++;
				Nemesis[i] = "killed";
			}
			Nemesis[oldattacker] = "revenge";
			if (ClassHunter[oldattacker]) Hu[oldattacker][0] += ((GetConVarInt(NemesisAward) * count)/2);
			else if (ClassSmoker[oldattacker]) Sm[oldattacker][0] += ((GetConVarInt(NemesisAward) * count)/2);
			else if (ClassBoomer[oldattacker]) Bo[oldattacker][0] += ((GetConVarInt(NemesisAward) * count)/2);
			else if (ClassJockey[oldattacker]) Jo[oldattacker][0] += ((GetConVarInt(NemesisAward) * count)/2);
			else if (ClassCharger[oldattacker]) Ch[oldattacker][0] += ((GetConVarInt(NemesisAward) * count)/2);
			else if (ClassSpitter[oldattacker]) Sp[oldattacker][0] += ((GetConVarInt(NemesisAward) * count)/2);
			else if (ClassTank[oldattacker]) Ta[oldattacker][0] += ((GetConVarInt(NemesisAward) * count)/2);
			In[oldattacker][0] += (GetConVarInt(NemesisAward) * count);
			PrintToChat(oldattacker, "%s \x01You took revenge on your nemesis, \x03%N \x01for \x04%d \x01XP!", INFO, victim, (GetConVarInt(NemesisAward) * count));
			PrintToChat(oldattacker, "%s \x03%N \x01was Nemesis to \x04%d \x01other players!", INFO, victim, count);
			experience_increase(oldattacker, 0);
		}
		GetClientAuthString(oldattacker, Key, 65);
		Nemesis[victim] = Key;
		GetClientName(oldattacker, NemesisName[victim], 257);
		PrintToChat(victim, "%s \x04%N \x01is your new nemesis!", INFO, oldattacker);
	}
	else
	{
		if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && 
			GetClientTeam(victim) == 2)
		{
			Nemesis[victim] = "none";
		}
	}
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == 2)
	{
		if (!RoundReset) SetTeamBonusValue();
		LocationSaved[victim] = true;
		GetClientAbsOrigin(victim, SurvivorDeathSpot[victim]);
		new killer = LastToHurtMe[victim];
		if (!IsClientIndexOutOfRange(killer) && IsClientInGame(killer) && !IsFakeClient(killer) && GetClientTeam(killer) == 3 && !RoundReset)
		{
			//LevelXP(killer, victim);
			// Award the Bounty Experience.
			if (Bounty[victim] > 0)
			{
				if (ClassHunter[killer])
				{
					Hu[killer][0] += Bounty[victim];
					In[killer][0] += Bounty[victim];
					PrintToChatAll("%s \x04%N \x01has collected the Bounty on \x03%N \x01for \x05%d Hunter/Infected XP.", BOUNTY_INFO, killer, victim, Bounty[victim]);
				}
				else if (ClassSmoker[killer])
				{
					Sm[killer][0] += Bounty[victim];
					In[killer][0] += Bounty[victim];
					PrintToChatAll("%s \x04%N \x01has collected the Bounty on \x03%N \x01for \x05%d Smoker/Infected XP.", BOUNTY_INFO, killer, victim, Bounty[victim]);
				}
				else if (ClassBoomer[killer])
				{
					Bo[killer][0] += Bounty[victim];
					In[killer][0] += Bounty[victim];
					PrintToChatAll("%s \x04%N \x01has collected the Bounty on \x03%N \x01for \x05%d Boomer/Infected XP.", BOUNTY_INFO, killer, victim, Bounty[victim]);
				}
				else if (ClassJockey[killer])
				{
					Jo[killer][0] += Bounty[victim];
					In[killer][0] += Bounty[victim];
					PrintToChatAll("%s \x04%N \x01has collected the Bounty on \x03%N \x01for \x05%d Jockey/Infected XP.", BOUNTY_INFO, killer, victim, Bounty[victim]);
				}
				else if (ClassCharger[killer])
				{
					Ch[killer][0] += Bounty[victim];
					In[killer][0] += Bounty[victim];
					PrintToChatAll("%s \x04%N \x01has collected the Bounty on \x03%N \x01for \x05%d Charger/Infected XP.", BOUNTY_INFO, killer, victim, Bounty[victim]);
				}
				else if (ClassSpitter[killer])
				{
					Sp[killer][0] += Bounty[victim];
					In[killer][0] += Bounty[victim];
					PrintToChatAll("%s \x04%N \x01has collected the Bounty on \x03%N \x01for \x05%d Spitter/Infected XP.", BOUNTY_INFO, killer, victim, Bounty[victim]);
				}
				else if (ClassTank[killer])
				{
					Ta[killer][0] += Bounty[victim];
					In[killer][0] += Bounty[victim];
					PrintToChatAll("%s \x04%N \x01has collected the Bounty on \x03%N \x01for \x05%d Tank/Infected XP.", BOUNTY_INFO, killer, victim, Bounty[victim]);
				}
				Bounty[victim] = 0;
			}
		}
	}
	// For bounty Stuff
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == 2 &&
		!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && GetClientTeam(victim) == 3)
	{
		if (!IsFakeClient(victim))
		{
			if (Ph[attacker][2] >= In[victim][2]) Bounty[attacker] += Ph[attacker][2];
			else Bounty[attacker] += (In[victim][2] - Ph[attacker][2]);
		}
		else
		{
			if (Ph[attacker][2] >= AIInfected[2]) Bounty[attacker] += Ph[attacker][2];
			else Bounty[attacker] += (AIInfected[2] - Ph[attacker][2]);
		}
		if (IsFakeClient(victim))
		{
			if (ClassHunter[victim])
			{
				if (AIHunter[2] + AIInfected[2] > Ph[attacker][2]) Bounty[attacker] += ((AIHunter[2] + AIInfected[2]) - Ph[attacker][2]);
				else Bounty[attacker] += Ph[attacker][2];
			}
			else if (ClassSmoker[victim])
			{
				if (AISmoker[2] + AIInfected[2] > Ph[attacker][2]) Bounty[attacker] += ((AISmoker[2] + AIInfected[2]) - Ph[attacker][2]);
				else Bounty[attacker] += Ph[attacker][2];
			}
			else if (ClassBoomer[victim])
			{
				if (AIBoomer[2] + AIInfected[2] > Ph[attacker][2]) Bounty[attacker] += ((AIBoomer[2] + AIInfected[2]) - Ph[attacker][2]);
				else Bounty[attacker] += Ph[attacker][2];
			}
			else if (ClassJockey[victim])
			{
				if (AIJockey[2] + AIInfected[2] > Ph[attacker][2]) Bounty[attacker] += ((AIJockey[2] + AIInfected[2]) - Ph[attacker][2]);
				else Bounty[attacker] += Ph[attacker][2];
			}
			else if (ClassCharger[victim])
			{
				if (AICharger[2] + AIInfected[2] > Ph[attacker][2]) Bounty[attacker] += ((AICharger[2] + AIInfected[2]) - Ph[attacker][2]);
				else Bounty[attacker] += Ph[attacker][2];
			}
			else if (ClassSpitter[victim])
			{
				if (AISpitter[2] + AIInfected[2] > Ph[attacker][2]) Bounty[attacker] += ((AISpitter[2] + AIInfected[2]) - Ph[attacker][2]);
				else Bounty[attacker] += Ph[attacker][2];
			}
		}
		else if (!IsFakeClient(victim))
		{
			if (ClassHunter[victim])
			{
				if (Hu[victim][2] + In[victim][2] > Ph[attacker][2]) Bounty[attacker] += ((Hu[victim][2] + In[victim][2]) - Ph[attacker][2]);
				else Bounty[attacker] += Ph[attacker][2];
			}
			else if (ClassSmoker[victim])
			{
				if (Sm[victim][2] + In[victim][2] > Ph[attacker][2]) Bounty[attacker] += ((Sm[victim][2] + In[victim][2]) - Ph[attacker][2]);
				else Bounty[attacker] += Ph[attacker][2];
			}
			else if (ClassBoomer[victim])
			{
				if (Bo[victim][2] + In[victim][2] > Ph[attacker][2]) Bounty[attacker] += ((Bo[victim][2] + In[victim][2]) - Ph[attacker][2]);
				else Bounty[attacker] += Ph[attacker][2];
			}
			else if (ClassJockey[victim])
			{
				if (Jo[victim][2] + In[victim][2] > Ph[attacker][2]) Bounty[attacker] += ((Jo[victim][2] + In[victim][2]) - Ph[attacker][2]);
				else Bounty[attacker] += Ph[attacker][2];
			}
			else if (ClassCharger[victim])
			{
				if (Ch[victim][2] + In[victim][2] > Ph[attacker][2]) Bounty[attacker] += ((Ch[victim][2] + In[victim][2]) - Ph[attacker][2]);
				else Bounty[attacker] += Ph[attacker][2];
			}
			else if (ClassSpitter[victim])
			{
				if (Sp[victim][2] + In[victim][2] > Ph[attacker][2]) Bounty[attacker] += ((Sp[victim][2] + In[victim][2]) - Ph[attacker][2]);
				else Bounty[attacker] += Ph[attacker][2];
			}
		}
	}
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && GetClientTeam(victim) == 3)
	{
		// Check to see if the charger jump while charging ability is active, and deactivate it if it is.
		if (ChargerCanJump[attacker] == true)
		{
			// If the charger jump ability is active, deactivate it.
			ChargerCanJump[attacker] = false;
			ChargerIsJumping[attacker] = false;
			ChargerCarryVictim[attacker] = 0;		// set to 0 so they can't jump while charging without a victim.
		}

		TeamSpecialValue++;
		InfectedTeamPoints += (HurtAward[victim] * GetConVarFloat(InfectedTeamPointsMP));
		// Assign the infected player his hurt points in experience and points.
		
		if (!IsFakeClient(victim))
		{
			if (HunterHurtAward[victim] > 0.0) Hu[victim][0] += RoundToFloor(HunterHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (SmokerHurtAward[victim] > 0.0) Sm[victim][0] += RoundToFloor(SmokerHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (BoomerHurtAward[victim] > 0.0) Bo[victim][0] += RoundToFloor(BoomerHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (JockeyHurtAward[victim] > 0.0) Jo[victim][0] += RoundToFloor(JockeyHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (ChargerHurtAward[victim] > 0.0) Ch[victim][0] += RoundToFloor(ChargerHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (SpitterHurtAward[victim] > 0.0) Sp[victim][0] += RoundToFloor(SpitterHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (TankHurtAward[victim] > 0.0) Ta[victim][0] += RoundToFloor(TankHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (HurtAward[victim] > 0.0) In[victim][0] += RoundToFloor(HurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
		}
		else
		{
			if (HunterHurtAward[victim] > 0.0) AIHunter[0] += RoundToFloor(HunterHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (SmokerHurtAward[victim] > 0.0) AISmoker[0] += RoundToFloor(SmokerHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (BoomerHurtAward[victim] > 0.0) AIBoomer[0] += RoundToFloor(BoomerHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (JockeyHurtAward[victim] > 0.0) AIJockey[0] += RoundToFloor(JockeyHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (ChargerHurtAward[victim] > 0.0) AICharger[0] += RoundToFloor(ChargerHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (SpitterHurtAward[victim] > 0.0) AISpitter[0] += RoundToFloor(SpitterHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (TankHurtAward[victim] > 0.0) AITank[0] += RoundToFloor(TankHurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
			if (HurtAward[victim] > 0.0) AIInfected[0] += RoundToFloor(HurtAward[victim] * GetConVarFloat(HurtAwardInfectedXP));
		}
		HunterHurtAward[victim] = 0.0;
		SmokerHurtAward[victim] = 0.0;
		BoomerHurtAward[victim] = 0.0;
		JockeyHurtAward[victim] = 0.0;
		ChargerHurtAward[victim] = 0.0;
		SpitterHurtAward[victim] = 0.0;
		TankHurtAward[victim] = 0.0;
		experience_increase(victim, 0);
		
		if (ClassTank[victim]) HurtAward[victim] *= GetConVarFloat(HurtAwardTankPoints);
		else HurtAward[victim] *= GetConVarFloat(HurtAwardInfectedPoints);
		if (!IsFakeClient(victim))
		{
			InfectedPoints[victim] += HurtAward[victim];
			if (HurtAward[victim] > 0.0) PrintToChat(victim, "%s \x01Hurt Damage: \x04%3.3f \x01Point(s).", POINTS_INFO, HurtAward[victim]);
		}
		HurtAward[victim] = 0.0;

		// Wall of Fire triggers automatically if a players level is above a certain point.
		if (!InfectedGhost[victim])
		{
			if (!IsFakeClient(victim))
			{
				if (ClassHunter[victim] && Hu[victim][2] >= GetConVarInt(WallOfFireLevel) && WOF[victim][0] == 1 || 
					ClassSmoker[victim] && Sm[victim][2] >= GetConVarInt(WallOfFireLevel) && WOF[victim][1] == 1 || 
					ClassBoomer[victim] && Bo[victim][2] >= GetConVarInt(WallOfFireLevel) && WOF[victim][2] == 1 || 
					ClassJockey[victim] && Jo[victim][2] >= GetConVarInt(WallOfFireLevel) && WOF[victim][3] == 1 || 
					ClassCharger[victim] && Ch[victim][2] >= GetConVarInt(WallOfFireLevel) && WOF[victim][4] == 1 || 
					ClassSpitter[victim] && Sp[victim][2] >= GetConVarInt(WallOfFireLevel) && WOF[victim][5] == 1 || 
					ClassTank[victim] && Ta[victim][2] >= GetConVarInt(WallOfFireLevel) && WOF[victim][6] == 1) CreateFireEx(victim);
			}
			else if (IsFakeClient(victim) && !bWOFCooldown)
			{
				bWOFCooldown = true;
				CreateTimer(GetConVarFloat(g_WOFCooldownBots), Timer_EnableWOFBots, _, TIMER_FLAG_NO_MAPCHANGE);
				if (ClassHunter[victim] && AIHunter[2] >= GetConVarInt(WallOfFireLevel) || 
					ClassSmoker[victim] && AISmoker[2] >= GetConVarInt(WallOfFireLevel) || 
					ClassBoomer[victim] && AIBoomer[2] >= GetConVarInt(WallOfFireLevel) || 
					ClassJockey[victim] && AIJockey[2] >= GetConVarInt(WallOfFireLevel) || 
					ClassCharger[victim] && AICharger[2] >= GetConVarInt(WallOfFireLevel) || 
					ClassSpitter[victim] && AISpitter[2] >= GetConVarInt(WallOfFireLevel) || 
					ClassTank[victim] && AITank[2] >= GetConVarInt(WallOfFireLevel)) CreateFireEx(victim);
			}
		}
	}
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == 2)
	{
		// We want to get the total number of kills the survivor player has
		// As they are rewarded phyiscal experience at the end of a round.
		if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == 3) LevelXP(attacker, victim);
		RoundKills[attacker]++;

		// Check the day of the month against the players saved day of the month
		// So we can reset the kill count for this daily quest if they do not match.
		decl String:sBuffer[32];
		FormatTime(sBuffer,sizeof(sBuffer),"%d");
		new day = StringToInt(sBuffer);
		// If days do not match...

		// In this instance, we need to make sure the victim is team 3, due to not checking
		// results in common zombies rewarding SI kills.
		if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && GetClientTeam(victim) == 3)
		{
			if (AchDate[attacker] != day)
			{
				ResetDailyAchievement(attacker, day);	// Reset all of the attackers daily achievement earnings.
			}
			AchievementCheck(attacker, 1);		// Send the client to the achievement page to check values.
		}

		new bool:headshot = GetEventBool(event, "headshot");
		if (headshot)
		{
			if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim)) experience_increase(attacker, RoundToFloor(0.3 * In[victim][2]) + (GetConVarInt(SIXP) + GetConVarInt(HSXP)));
			SurvivorHeadshotValue[attacker]++;
			RoundHS[attacker]++;
			if (RoundHS[attacker] > BestSurvivorHS[0])
			{
				BestSurvivorHS[0] = RoundHS[attacker];
				BestSurvivorHS[1] = attacker;
			}
		}
		else
		{
			if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim)) experience_increase(attacker, RoundToFloor(0.3 * In[victim][2]) + GetConVarInt(SIXP));
		}
		SurvivorSpecialValue[attacker]++;
		experience_multiplier(attacker);
		if (IsClientIndexOutOfRange(BestKills[1]) || !IsClientInGame(BestKills[1]))
		{
			BestKills[0] = 0;
		}
		if (RoundKills[attacker] > BestKills[0])
		{
			BestKills[0] = RoundKills[attacker];
			BestKills[1] = attacker;
		}
		
		if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && ClassTank[victim] == false)
		{
			// Survivors earn points through damage dealt.
			// End of round experience bonuses are also through damage dealt.
			if (!IsFakeClient(victim))
			{
				InfectedGhost[victim] = true;
				point_restriction(victim);
			}
			InfectedPlayerHasDied(victim);
		}
	}
	if (!RoundReset) SetTeamBonusValue();
}

public Action:Event_PlayerIncapacitated(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new victim	 = GetClientOfUserId(GetEventInt(event, "userid"));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));

	// Set the ensnare value if a survivor bot, so survivor bot doesn't use heal for no reason.
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && IsFakeClient(victim) && GetClientTeam(victim) == 2)
	{
		if (Ensnared[victim] == false && IncapProtection[victim] < 1)
		{
			// If the user is not ensnared... and if he has no incap charges...
			// and if he has free heal charges...
			if (IncapProtection[victim] < 1 && HealCount[victim] > 0)
			{
				PrintToChatAll("%s \x04%N \x01has purchased \x05Incap Protection", INFO, victim);
				ExecCheatCommand(victim, "give", "health");
				IncapProtection[victim] = GetConVarInt(IncapCount);
				HealCount[victim]--;
				return;
			}
		}
		if (Ensnared[victim] == true || IncapProtection[victim] > 0)
		{
			if (IncapProtection[victim] < 1 && HealCount[victim] > 0)
			{
				PrintToChatAll("%s \x04%N \x01has purchased \x05Incap Protection", INFO, victim);
				IncapProtection[victim] = GetConVarInt(IncapCount);
				HealCount[victim]--;
			}
			CreateTimer(1.0, CheckIfEnsnared, victim, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		return;
	}
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == 2)
	{
		CreateTimer(1.0, CheckIfEnsnared, victim, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		if (DeepFreezeAmount > 0 && !DeepFreezeCooldown)
		{
			new number = GetRandomInt(1, 100);
			if (number <= DeepFreezeAmount)
			{
				DeepFreezeCooldown = true;
				for (new i = 1; i <= MaxClients; i++)
				{
					if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 2) continue;
					PlayerMovementSpeed[i] -= GetConVarFloat(DeepFreezeSlowDown);
					if (IsPlayerAlive(i)) SetEntDataFloat(i, laggedMovementOffset, PlayerMovementSpeed[i], true);
				}
				CreateTimer(GetConVarFloat(DeepFreezeTime), RemoveDeepFreeze, _, TIMER_FLAG_NO_MAPCHANGE);
				CreateTimer(GetConVarFloat(DeepFreezeDisableTime), EnableDeepFreeze, _, TIMER_FLAG_NO_MAPCHANGE);
				PrintToChatAll("%s \x04Deep Freeze \x01is in effect!", INFO);
			}
		}
		if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == 3)
		{
			//LevelXP(attacker, victim);
		}
	}
}

public Action:Event_PlayerHurt(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	new victim	 = GetClientOfUserId(GetEventInt(event, "userid"));
	new damage	 = GetEventInt(event, "dmg_health");
	new type	 = GetEventInt(event, "type");
	/*
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && IsFakeClient(victim) && GetClientTeam(victim) == 3 && IsIncapacitated(victim) && ClassTank[victim])
	{
		// having a problem with tanks that are incapacitated who still receive damage and get stuck in a death animation state.
		// this attempts to prevent that.
		return;
	}
	*/
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == 2 && 
		!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == 2)
	{
		if (!LockedWeaponUsed(attacker) && IsPlayerAlive(victim) && attacker != victim)
		{
			CallHealAmmo(attacker, victim);
		}
	}
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == 2 && GetClientTeam(victim) != 2)
	{
		if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsIncapacitated(victim))
		{
			// we set the damage increase bonuses for each weapon, to properly award the survivor
			// for each weapon used on the infected player when the infected player dies.
			if (!IsIncapacitated(victim)) CallWeaponDamage(attacker, victim, damage);
			new Class = GetEntProp(victim, Prop_Send, "m_zombieClass");
			CallScoutAbility(attacker, victim, Class);
			if (!LockedWeaponUsed(attacker) && IsPlayerAlive(victim) && Class != ZOMBIECLASS_TANK)
			{
				new String:WeaponType[32];
				GetEventString(event, "weapon", WeaponType, 32);
				if (!StrEqual(WeaponType, "inferno") && !StrEqual(WeaponType, "insect_swarm") && 
					type != 8 && type != 268435464)
				{
					CallBlindAmmo(attacker, victim);
					CallBloatAmmo(attacker, victim);
					CallIceAmmo(attacker, victim);
					BeanBagAmmo(attacker, victim);
				}
			}
		}
		// We want to tally the total damage a player has done in a round
		// Because they are awarded bonus physical experience based on it.
		RoundAward[attacker] += damage;
		AssistHurtInfected[attacker][victim] += damage;
		RoundSurvivorDamage[attacker] += damage;
		if (RoundSurvivorDamage[attacker] > BestSurvivorDamage[0])
		{
			BestSurvivorDamage[0] = RoundSurvivorDamage[attacker];
			BestSurvivorDamage[1] = attacker;
		}
	}
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && GetClientTeam(victim) == 2)	// no attacker specified since commons can deal damage to the player.
	{
		new String:WeaponCallBack[32];
		GetEventString(event, "weapon", WeaponCallBack, 32);
		if (!StrEqual(WeaponCallBack, "inferno") && !StrEqual(WeaponCallBack, "insect_swarm"))
		{
			if (GetConVarInt(DirectorEnabled) == 1)
			{
				// Give the director points for hurting humans or bots.
				DirectorPoints += GetConVarFloat(DirectorPointsOnHurt);
			}
			if (CoveredInBile[victim]) BoomerActionPoints[victim] += (SurvivorMultiplier[victim] * GetConVarFloat(BoomerAwardPoints));
		}
		if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && GetClientTeam(attacker) == 3 && 
			!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == 2)
		{
			if (GetClientTeam(attacker) != GetClientTeam(victim)) LastToHurtMe[victim] = attacker;
			if (!IsFakeClient(attacker))
			{
				RoundDamage[attacker] += damage;
				if (IsClientIndexOutOfRange(MapBestDamage[1]) || !IsClientInGame(MapBestDamage[1]))
				{
					MapBestDamage[0] = 0;
				}
				if (RoundDamage[attacker] > MapBestDamage[0])
				{
					MapBestDamage[0] = RoundDamage[attacker];
					MapBestDamage[1] = attacker;
				}
				// Tally their round total damage.
				RoundAward[attacker] += damage;
			}
			if (IsFakeClient(attacker) && ClassTank[attacker] && AITank[2] >= GetConVarInt(InfectedTier2Level) && bIcedByTank[victim] == false)
			{
				// Ice Punches that slow players down!
				bIcedByTank[victim] = true;
				if (VipName != victim)
				{
					SetEntityRenderMode(victim, RENDER_TRANSCOLOR);
					SetEntityRenderColor(victim, 50, 50, 255, 255);
				}
				SetEntDataFloat(victim, laggedMovementOffset, GetConVarFloat(g_IcedByTankSpeed), true);
				CreateTimer(GetConVarFloat(g_IcedByTankTime), Timer_RemoveTankIce, victim, TIMER_FLAG_NO_MAPCHANGE);
			}

			// We only want to give class-specific points if the player is alive.
			// Ex. If spit does damage after the spitter dies, infected XP only.
			if (IsPlayerAlive(attacker))
			{
				// Check the day of the month against the players saved day of the month
				// So we can reset the kill count for this daily quest if they do not match.
				decl String:sBuffer[32];
				FormatTime(sBuffer,sizeof(sBuffer),"%d");
				new day = StringToInt(sBuffer);

				// If days do not match...
				if (AchDate[attacker] != day)
				{
					ResetDailyAchievement(attacker, day);	// Reset all of the attackers daily achievement earnings.
				}
				// Give the player damage points towards their daily quest.
				if (!IsFakeClient(attacker) && Ach[attacker][3] != GetConVarInt(Achievement[3][0]) * -1)
				{
					if (ClassHunter[attacker]) Ach[attacker][3] += RoundToFloor(damage * GetConVarFloat(HunterDamageNerf));
					else if (ClassSmoker[attacker]) Ach[attacker][3] += RoundToFloor(damage * GetConVarFloat(SmokerDamageNerf));
					else if (ClassBoomer[attacker]) Ach[attacker][3] += RoundToFloor(damage * GetConVarFloat(BoomerDamageNerf));
					else if (ClassJockey[attacker]) Ach[attacker][3] += RoundToFloor(damage * GetConVarFloat(JockeyDamageNerf));
					else if (ClassCharger[attacker]) Ach[attacker][3] += RoundToFloor(damage * GetConVarFloat(ChargerDamageNerf));
					else if (ClassSpitter[attacker]) Ach[attacker][3] += RoundToFloor(damage * GetConVarFloat(SpitterDamageNerf));
					else if (ClassTank[attacker]) Ach[attacker][3] += RoundToFloor(damage * GetConVarFloat(HurtAwardTankPoints));
					AchievementCheck(attacker, 3);
				}



				// Now we go through and give specific points and stuff to the infected player.
				// New feature, for each class you earn XP as, you get XP in that category.
				if (ClassHunter[attacker]) HunterHurtAward[attacker] += (damage * GetConVarFloat(HunterDamageNerf));
				else if (ClassSmoker[attacker]) SmokerHurtAward[attacker] += (damage * GetConVarFloat(SmokerDamageNerf));
				else if (ClassBoomer[attacker]) BoomerHurtAward[attacker] += (damage * GetConVarFloat(BoomerDamageNerf));
				else if (ClassJockey[attacker]) JockeyHurtAward[attacker] += (damage * GetConVarFloat(JockeyDamageNerf));
				else if (ClassCharger[attacker]) ChargerHurtAward[attacker] += (damage * GetConVarFloat(ChargerDamageNerf));
				else if (ClassSpitter[attacker]) SpitterHurtAward[attacker] += (damage * GetConVarFloat(SpitterDamageNerf));
				else if (ClassTank[attacker])
				{
					// Check if the Tank is a Tier 4 Tank!
					if ((!IsFakeClient(attacker) && Ta[attacker][2] >= GetConVarInt(InfectedTier4Level)) || 
						(IsFakeClient(attacker) && AITank[2] >= GetConVarInt(InfectedTier4Level)))
					{
						if (IsPlayerAlive(victim) && !FireTankImmune[victim] && GetClientHealth(victim) >= GetConVarInt(FireTankMinimumHealth))
						{
							FireTankImmune[victim] = true;
							FireTankCount[victim] = -1.0;
							IgniteEntity(victim, GetConVarFloat(FireTankTime));
							CreateTimer(1.0, RemoveFireTankImmune, victim, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
							TankHurtAward[attacker] += (GetConVarFloat(FireTankTime) * GetConVarInt(FireTankDamage));
						}
					}
					TankHurtAward[attacker] += damage;
				}
			}
			// Basic Hurt Award goes to the players infected level and usepoints. Cumulative of all damages.
			// This is also the only award given if the player is no longer alive.
			if (IsPlayerAlive(attacker) && !ClassSpitter[attacker] && !ClassCharger[attacker]) HurtAward[attacker] += damage;
			else if (IsPlayerAlive(attacker) && ClassCharger[attacker]) HurtAward[attacker] += (damage * GetConVarFloat(ChargerDamageNerf));
			else if (IsPlayerAlive(attacker) && ClassSpitter[attacker]) HurtAward[attacker] += (damage * GetConVarFloat(SpitterDamageNerf));
			// Add Smoker Burn and Spitter Slow here.
			if (ClassSmoker[attacker] && (UpgradeSmoker[attacker] || Sm[attacker][2] >= GetConVarInt(InfectedTier2Level)))
			{
				if (GetClientHealth(victim) > GetConVarInt(SmokerBurnDamage) && !BurnDamageImmune[victim] && IsPlayerAlive(victim))
				{
					BurnDamageImmune[victim] = true;
					CreateTimer(5.0, EnableBurnDamage, victim);
					IgniteEntity(victim, 3.0);
					SetEntityHealth(victim, GetClientHealth(victim) - GetConVarInt(SmokerBurnDamage));
					HurtAward[attacker] += GetConVarInt(SmokerBurnDamage);
				}
			}
			if (ClassSpitter[attacker] && (UpgradeSpitter[attacker] || Sp[attacker][2] >= GetConVarInt(InfectedTier2Level)) && !SpitterImmune[victim] && 
				!BrokenLegs[victim])
			{
				if (HazmatBoots[victim] > 0)
				{
					new number = GetRandomInt(GetConVarInt(PersonalAbilityLossMin), GetConVarInt(PersonalAbilityLossMax));
					HazmatBoots[victim] -= number;
					if (HazmatBoots[victim] < 1)
					{
						PrintToChat(victim, "%s \x01Your Hazmat Boots' composition breaks apart.", INFO);
						HazmatBoots[victim] = 0;
					}
				}
				else
				{
					SpitterImmune[victim] = true;
					if (IsPlayerAlive(victim) && !IsFakeClient(attacker)) SetEntDataFloat(victim, laggedMovementOffset, GetConVarFloat(StickySpitSpeed) - (GetConVarFloat(StickySpitPerLevel) * Sp[attacker][2]), true);
					else if (IsPlayerAlive(victim) && IsFakeClient(attacker)) SetEntDataFloat(victim, laggedMovementOffset, GetConVarFloat(StickySpitSpeed) - (GetConVarFloat(StickySpitPerLevel) * AISpitter[2]), true);
					CreateTimer(GetConVarFloat(StickySpitTime), RemoveStickySpit, victim);

					if (Sp[attacker][2] >= GetConVarInt(InfectedTier4Level) && !HeavyBySpit[victim])
					{
						HeavyBySpit[victim] = true;
						SetEntityGravity(victim, 5.0);
						CreateTimer(2.0, RemoveHeavySpit, victim, TIMER_FLAG_NO_MAPCHANGE);
					}
				}
			}
		}
	}
}

CallBlindAmmo(attacker, victim)
{
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim) || IsFakeClient(victim) || !IsPlayerAlive(victim) || BlindAmmoImmune[victim]) return;
	new String:WeaponUsed[64];
	GetClientWeapon(attacker, WeaponUsed, sizeof(WeaponUsed));
	if (StrEqual(WeaponUsed, "weapon_pistol", true) || 
		StrEqual(WeaponUsed, "weapon_pistol_magnum", true))
	{
		if (!BlindAmmoPistol[attacker] || BlindAmmoAmountPistol[attacker] < 1) return;
		BlindAmmoAmountPistol[attacker]--;
		if (BlindAmmoAmountPistol[attacker] < 1) BlindAmmoPistol[attacker] = false;
		CreateTimer(GetConVarFloat(BlindAmmoTime) + (GetConVarFloat(BlindAmmoTimeLevel) * Pi[attacker][2]), RemoveBlindAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (StrEqual(WeaponUsed, "weapon_melee", true))
	{
		return;
	}
	else if (StrEqual(WeaponUsed, "weapon_smg", true) || 
			 StrEqual(WeaponUsed, "weapon_smg_silenced", true) || 
			 StrEqual(WeaponUsed, "weapon_smg_mp5", true))
	{
		if (!BlindAmmoSmg[attacker] || BlindAmmoAmountSmg[attacker] < 1) return;
		BlindAmmoAmountSmg[attacker]--;
		if (BlindAmmoAmountSmg[attacker] < 1) BlindAmmoSmg[attacker] = false;
		CreateTimer(GetConVarFloat(BlindAmmoTime) + (GetConVarFloat(BlindAmmoTimeLevel) * Uz[attacker][2]), RemoveBlindAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (StrEqual(WeaponUsed, "weapon_autoshotgun", true) || 
			 StrEqual(WeaponUsed, "weapon_pumpshotgun", true) || 
			 StrEqual(WeaponUsed, "weapon_shotgun_chrome", true) || 
			 StrEqual(WeaponUsed, "weapon_shotgun_spas", true))
	{
		if (!BlindAmmoShotgun[attacker] || BlindAmmoAmountShotgun[attacker] < 1) return;
		BlindAmmoAmountShotgun[attacker]--;
		if (BlindAmmoAmountShotgun[attacker] < 1) BlindAmmoShotgun[attacker] = false;
		CreateTimer(GetConVarFloat(BlindAmmoTime) + (GetConVarFloat(BlindAmmoTimeLevel) * Sh[attacker][2]), RemoveBlindAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (StrEqual(WeaponUsed, "weapon_rifle", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_ak47", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_desert", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_m60", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_sg552", true))
	{
		if (!BlindAmmoRifle[attacker] || BlindAmmoAmountRifle[attacker] < 1) return;
		BlindAmmoAmountRifle[attacker]--;
		if (BlindAmmoAmountRifle[attacker] < 1) BlindAmmoRifle[attacker] = false;
		CreateTimer(GetConVarFloat(BlindAmmoTime) + (GetConVarFloat(BlindAmmoTimeLevel) * Ri[attacker][2]), RemoveBlindAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (StrEqual(WeaponUsed, "weapon_sniper_awp", true) || 
			 StrEqual(WeaponUsed, "weapon_sniper_military", true) || 
			 StrEqual(WeaponUsed, "weapon_sniper_scout", true) || 
			 StrEqual(WeaponUsed, "weapon_hunting_rifle", true))
	{
		if (!BlindAmmoSniper[attacker] || BlindAmmoAmountSniper[attacker] < 1) return;
		BlindAmmoAmountSniper[attacker]--;
		if (BlindAmmoAmountSniper[attacker] < 1) BlindAmmoSniper[attacker] = false;
		CreateTimer(GetConVarFloat(BlindAmmoTime) + (GetConVarFloat(BlindAmmoTimeLevel) * Sn[attacker][2]), RemoveBlindAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}

	BlindPlayer(victim, GetConVarInt(BlindAmount));
	BlindAmmoImmune[victim] = true;
}

CallBloatAmmo(attacker, victim)
{
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim) || !IsPlayerAlive(victim) || BloatAmmoImmune[victim]) return;
	new String:WeaponUsed[64];
	GetClientWeapon(attacker, WeaponUsed, sizeof(WeaponUsed));
	if (StrEqual(WeaponUsed, "weapon_pistol", true) || 
		StrEqual(WeaponUsed, "weapon_pistol_magnum", true))
	{
		if (!BloatAmmoPistol[attacker] || BloatAmmoAmountPistol[attacker] < 1) return;
		BloatAmmoAmountPistol[attacker]--;
		if (BloatAmmoAmountPistol[attacker] < 1) BloatAmmoPistol[attacker] = false;
		CreateTimer(GetConVarFloat(BloatAmmoTime) + (GetConVarFloat(BloatAmmoTimeLevel) * Pi[attacker][2]), RemoveBloatAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (StrEqual(WeaponUsed, "weapon_melee", true))
	{
		return;
	}
	else if (StrEqual(WeaponUsed, "weapon_smg", true) || 
			 StrEqual(WeaponUsed, "weapon_smg_silenced", true) || 
			 StrEqual(WeaponUsed, "weapon_smg_mp5", true))
	{
		if (!BloatAmmoSmg[attacker] || BloatAmmoAmountSmg[attacker] < 1) return;
		BloatAmmoAmountSmg[attacker]--;
		if (BloatAmmoAmountSmg[attacker] < 1) BloatAmmoSmg[attacker] = false;
		CreateTimer(GetConVarFloat(BloatAmmoTime) + (GetConVarFloat(BloatAmmoTimeLevel) * Uz[attacker][2]), RemoveBloatAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (StrEqual(WeaponUsed, "weapon_autoshotgun", true) || 
			 StrEqual(WeaponUsed, "weapon_pumpshotgun", true) || 
			 StrEqual(WeaponUsed, "weapon_shotgun_chrome", true) || 
			 StrEqual(WeaponUsed, "weapon_shotgun_spas", true))
	{
		if (!BloatAmmoShotgun[attacker] || BloatAmmoAmountShotgun[attacker] < 1) return;
		BloatAmmoAmountShotgun[attacker]--;
		if (BloatAmmoAmountShotgun[attacker] < 1) BloatAmmoShotgun[attacker] = false;
		CreateTimer(GetConVarFloat(BloatAmmoTime) + (GetConVarFloat(BloatAmmoTimeLevel) * Sh[attacker][2]), RemoveBloatAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (StrEqual(WeaponUsed, "weapon_rifle", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_ak47", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_desert", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_m60", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_sg552", true))
	{
		if (!BloatAmmoRifle[attacker] || BloatAmmoAmountRifle[attacker] < 1) return;
		BloatAmmoAmountRifle[attacker]--;
		if (BloatAmmoAmountRifle[attacker] < 1) BloatAmmoRifle[attacker] = false;
		CreateTimer(GetConVarFloat(BloatAmmoTime) + (GetConVarFloat(BloatAmmoTimeLevel) * Ri[attacker][2]), RemoveBloatAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (StrEqual(WeaponUsed, "weapon_sniper_awp", true) || 
			 StrEqual(WeaponUsed, "weapon_sniper_military", true) || 
			 StrEqual(WeaponUsed, "weapon_sniper_scout", true) || 
			 StrEqual(WeaponUsed, "weapon_hunting_rifle", true))
	{
		if (!BloatAmmoSniper[attacker] || BloatAmmoAmountSniper[attacker] < 1) return;
		BloatAmmoAmountSniper[attacker]--;
		if (BloatAmmoAmountSniper[attacker] < 1) BloatAmmoSniper[attacker] = false;
		CreateTimer(GetConVarFloat(BloatAmmoTime) + (GetConVarFloat(BloatAmmoTimeLevel) * Sn[attacker][2]), RemoveBloatAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else return;
	SufferingFromBloatAmmo[victim] = true;
	SetEntityGravity(victim, GetConVarFloat(BloatAmount));
	BloatAmmoImmune[victim] = true;
}

CallIceAmmo(attacker, victim)
{
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim) || !IsPlayerAlive(victim) || IceAmmoImmune[victim]) return;
	new String:WeaponUsed[64];
	GetClientWeapon(attacker, WeaponUsed, sizeof(WeaponUsed));
	if (StrEqual(WeaponUsed, "weapon_pistol", true) || 
		StrEqual(WeaponUsed, "weapon_pistol_magnum", true))
	{
		if (!IceAmmoPistol[attacker] || IceAmmoAmountPistol[attacker] < 1) return;
		IceAmmoAmountPistol[attacker]--;
		if (IceAmmoAmountPistol[attacker] < 1) IceAmmoPistol[attacker] = false;
		CreateTimer(GetConVarFloat(IceAmmoTime) + (GetConVarFloat(IceAmmoTimeLevel) * Pi[attacker][2]), RemoveIceAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (StrEqual(WeaponUsed, "weapon_melee", true))
	{
		return;
	}
	else if (StrEqual(WeaponUsed, "weapon_smg", true) || 
			 StrEqual(WeaponUsed, "weapon_smg_silenced", true) || 
			 StrEqual(WeaponUsed, "weapon_smg_mp5", true))
	{
		if (!IceAmmoSmg[attacker] || IceAmmoAmountSmg[attacker] < 1) return;
		IceAmmoAmountSmg[attacker]--;
		if (IceAmmoAmountSmg[attacker] < 1) IceAmmoSmg[attacker] = false;
		CreateTimer(GetConVarFloat(IceAmmoTime) + (GetConVarFloat(IceAmmoTimeLevel) * Uz[attacker][2]), RemoveIceAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (StrEqual(WeaponUsed, "weapon_autoshotgun", true) || 
			 StrEqual(WeaponUsed, "weapon_pumpshotgun", true) || 
			 StrEqual(WeaponUsed, "weapon_shotgun_chrome", true) || 
			 StrEqual(WeaponUsed, "weapon_shotgun_spas", true))
	{
		if (!IceAmmoShotgun[attacker] || IceAmmoAmountShotgun[attacker] < 1) return;
		IceAmmoAmountShotgun[attacker]--;
		if (IceAmmoAmountShotgun[attacker] < 1) IceAmmoShotgun[attacker] = false;
		CreateTimer(GetConVarFloat(IceAmmoTime) + (GetConVarFloat(IceAmmoTimeLevel) * Sh[attacker][2]), RemoveIceAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (StrEqual(WeaponUsed, "weapon_rifle", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_ak47", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_desert", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_m60", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_sg552", true))
	{
		if (!IceAmmoRifle[attacker] || IceAmmoAmountRifle[attacker] < 1) return;
		IceAmmoAmountRifle[attacker]--;
		if (IceAmmoAmountRifle[attacker] < 1) IceAmmoRifle[attacker] = false;
		CreateTimer(GetConVarFloat(IceAmmoTime) + (GetConVarFloat(IceAmmoTimeLevel) * Ri[attacker][2]), RemoveIceAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else if (StrEqual(WeaponUsed, "weapon_sniper_awp", true) || 
			 StrEqual(WeaponUsed, "weapon_sniper_military", true) || 
			 StrEqual(WeaponUsed, "weapon_sniper_scout", true) || 
			 StrEqual(WeaponUsed, "weapon_hunting_rifle", true))
	{
		if (!IceAmmoSniper[attacker] || IceAmmoAmountSniper[attacker] < 1) return;
		IceAmmoAmountSniper[attacker]--;
		if (IceAmmoAmountSniper[attacker] < 1) IceAmmoSniper[attacker] = false;
		CreateTimer(GetConVarFloat(IceAmmoTime) + (GetConVarFloat(IceAmmoTimeLevel) * Sn[attacker][2]), RemoveIceAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
	}
	else return;
	SetEntDataFloat(victim, laggedMovementOffset, PlayerMovementSpeed[victim] - GetConVarFloat(IceAmount), true);
	IceAmmoImmune[victim] = true;
}

CallHealAmmo(attacker, victim)
{
	if (IsClientIndexOutOfRange(victim)) return;
	if (!IsClientInGame(victim) || IsFakeClient(victim) || !IsPlayerAlive(victim)) return;
	// If the players health pool is above their maximum health pool, don't let them be the
	// recipient of heal ammo.
	if (GetClientHealth(victim) >= (100 + Ph[victim][2])) return;
	new String:WeaponUsed[64];
	GetClientWeapon(attacker, WeaponUsed, sizeof(WeaponUsed));
	if (StrEqual(WeaponUsed, "weapon_pistol", true) || 
		StrEqual(WeaponUsed, "weapon_pistol_magnum", true))
	{
		if (!HealAmmoPistol[attacker] || HealAmmoAmountPistol[attacker] < 1) return;
		HealAmmoAmountPistol[attacker]--;
		if (HealAmmoAmountPistol[attacker] < 1)
		{
			HealAmmoPistol[attacker] = false;
			HealAmmoDisabled[attacker] = true;
			HealAmmoCounter[attacker] = -1.0;
			CreateTimer(1.0, EnableHealAmmo, attacker, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		if (GetClientHealth(victim) + Pi[attacker][2] > GetClientHealth(victim) + Ph[victim][2])
		{
			SetEntityHealth(victim, GetClientHealth(victim) + Ph[victim][2]);
		}
		else
		{
			SetEntityHealth(victim, GetClientHealth(victim) + Pi[attacker][2]);
		}
		RoundHealing[attacker] += Pi[attacker][2];
	}
	else if (StrEqual(WeaponUsed, "weapon_melee", true))
	{
		return;
	}
	else if (StrEqual(WeaponUsed, "weapon_smg", true) || 
			 StrEqual(WeaponUsed, "weapon_smg_silenced", true) || 
			 StrEqual(WeaponUsed, "weapon_smg_mp5", true))
	{
		if (!HealAmmoSmg[attacker] || HealAmmoAmountSmg[attacker] < 1) return;
		HealAmmoAmountSmg[attacker]--;
		if (HealAmmoAmountSmg[attacker] < 1)
		{
			HealAmmoSmg[attacker] = false;
			HealAmmoDisabled[attacker] = true;
			HealAmmoCounter[attacker] = -1.0;
			CreateTimer(1.0, EnableHealAmmo, attacker, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		if (GetClientHealth(victim) + Uz[attacker][2] > GetClientHealth(victim) + Ph[victim][2])
		{
			SetEntityHealth(victim, GetClientHealth(victim) + Ph[victim][2]);
		}
		else
		{
			SetEntityHealth(victim, GetClientHealth(victim) + Uz[attacker][2]);
		}
		RoundHealing[attacker] += Uz[attacker][2];
	}
	else if (StrEqual(WeaponUsed, "weapon_autoshotgun", true) || 
			 StrEqual(WeaponUsed, "weapon_pumpshotgun", true) || 
			 StrEqual(WeaponUsed, "weapon_shotgun_chrome", true) || 
			 StrEqual(WeaponUsed, "weapon_shotgun_spas", true))
	{
		if (!HealAmmoShotgun[attacker] || HealAmmoAmountShotgun[attacker] < 1) return;
		HealAmmoAmountShotgun[attacker]--;
		if (HealAmmoAmountShotgun[attacker] < 1)
		{
			HealAmmoShotgun[attacker] = false;
			HealAmmoDisabled[attacker] = true;
			HealAmmoCounter[attacker] = -1.0;
			CreateTimer(1.0, EnableHealAmmo, attacker, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		if (GetClientHealth(victim) + Sh[attacker][2] > GetClientHealth(victim) + Ph[victim][2])
		{
			SetEntityHealth(victim, GetClientHealth(victim) + Ph[victim][2]);
		}
		else
		{
			SetEntityHealth(victim, GetClientHealth(victim) + Sh[attacker][2]);
		}
		RoundHealing[attacker] += Sh[attacker][2];
	}
	else if (StrEqual(WeaponUsed, "weapon_rifle", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_ak47", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_desert", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_m60", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_sg552", true))
	{
		if (!HealAmmoRifle[attacker] || HealAmmoAmountRifle[attacker] < 1) return;
		HealAmmoAmountRifle[attacker]--;
		if (HealAmmoAmountRifle[attacker] < 1)
		{
			HealAmmoRifle[attacker] = false;
			HealAmmoDisabled[attacker] = true;
			HealAmmoCounter[attacker] = -1.0;
			CreateTimer(1.0, EnableHealAmmo, attacker, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		if (GetClientHealth(victim) + Ri[attacker][2] > GetClientHealth(victim) + Ph[victim][2])
		{
			SetEntityHealth(victim, GetClientHealth(victim) + Ph[victim][2]);
		}
		else
		{
			SetEntityHealth(victim, GetClientHealth(victim) + Ri[attacker][2]);
		}
		RoundHealing[attacker] += Ri[attacker][2];
	}
	else if (StrEqual(WeaponUsed, "weapon_sniper_awp", true) || 
			 StrEqual(WeaponUsed, "weapon_sniper_military", true) || 
			 StrEqual(WeaponUsed, "weapon_sniper_scout", true) || 
			 StrEqual(WeaponUsed, "weapon_hunting_rifle", true))
	{
		if (!HealAmmoSniper[attacker] || HealAmmoAmountSniper[attacker] < 1) return;
		HealAmmoAmountSniper[attacker]--;
		if (HealAmmoAmountSniper[attacker] < 1)
		{
			HealAmmoSniper[attacker] = false;
			HealAmmoDisabled[attacker] = true;
			HealAmmoCounter[attacker] = -1.0;
			CreateTimer(1.0, EnableHealAmmo, attacker, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		if (GetClientHealth(victim) + Sn[attacker][2] > GetClientHealth(victim) + Ph[victim][2])
		{
			SetEntityHealth(victim, GetClientHealth(victim) + Ph[victim][2]);
		}
		else
		{
			SetEntityHealth(victim, GetClientHealth(victim) + Sn[attacker][2]);
		}
		RoundHealing[attacker] += Sn[attacker][2];
	}
	else return;
	if (RoundHealing[attacker] > BestHealing[0])
	{
		BestHealing[0] = RoundHealing[attacker];
		BestHealing[1] = attacker;
	}
}

BeanBagAmmo(attacker, victim)
{
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim) || !IsPlayerAlive(victim) || BeanBagAmmoImmune[victim]) return;
	new String:WeaponUsed[64];
	GetClientWeapon(attacker, WeaponUsed, sizeof(WeaponUsed));
	new Float:BeanBagForce[3];
	if (StrEqual(WeaponUsed, "weapon_pistol", true) || 
		StrEqual(WeaponUsed, "weapon_pistol_magnum", true))
	{
		if (!BeanBagAmmoPistol[attacker] || BeanBagAmmoAmountPistol[attacker] < 1) return;
		BeanBagAmmoAmountPistol[attacker]--;
		if (BeanBagAmmoAmountPistol[attacker] < 1) BeanBagAmmoPistol[attacker] = false;
		BeanBagForce[0] = GetConVarFloat(BeanBagForceVel[0]) + (GetConVarFloat(BeanBagAmountLevel) * Pi[attacker][2]);
		BeanBagForce[1] = GetConVarFloat(BeanBagForceVel[1]) + (GetConVarFloat(BeanBagAmountLevel) * Pi[attacker][2]);
		BeanBagForce[2] = GetConVarFloat(BeanBagForceVel[2]) + (GetConVarFloat(BeanBagAmountLevel) * Pi[attacker][2]);
	}
	else if (StrEqual(WeaponUsed, "weapon_melee", true))
	{
		return;
	}
	else if (StrEqual(WeaponUsed, "weapon_smg", true) || 
			 StrEqual(WeaponUsed, "weapon_smg_silenced", true) || 
			 StrEqual(WeaponUsed, "weapon_smg_mp5", true))
	{
		if (!BeanBagAmmoSmg[attacker] || BeanBagAmmoAmountSmg[attacker] < 1) return;
		BeanBagAmmoAmountSmg[attacker]--;
		if (BeanBagAmmoAmountSmg[attacker] < 1) BeanBagAmmoSmg[attacker] = false;
		BeanBagForce[0] = GetConVarFloat(BeanBagForceVel[0]) + (GetConVarFloat(BeanBagAmountLevel) * Uz[attacker][2]);
		BeanBagForce[1] = GetConVarFloat(BeanBagForceVel[1]) + (GetConVarFloat(BeanBagAmountLevel) * Uz[attacker][2]);
		BeanBagForce[2] = GetConVarFloat(BeanBagForceVel[2]) + (GetConVarFloat(BeanBagAmountLevel) * Uz[attacker][2]);
	}
	else if (StrEqual(WeaponUsed, "weapon_autoshotgun", true) || 
			 StrEqual(WeaponUsed, "weapon_pumpshotgun", true) || 
			 StrEqual(WeaponUsed, "weapon_shotgun_chrome", true) || 
			 StrEqual(WeaponUsed, "weapon_shotgun_spas", true))
	{
		if (!BeanBagAmmoShotgun[attacker] || BeanBagAmmoAmountShotgun[attacker] < 1) return;
		BeanBagAmmoAmountShotgun[attacker]--;
		if (BeanBagAmmoAmountShotgun[attacker] < 1) BeanBagAmmoShotgun[attacker] = false;
		BeanBagForce[0] = GetConVarFloat(BeanBagForceVel[0]) + (GetConVarFloat(BeanBagAmountLevel) * Sh[attacker][2]);
		BeanBagForce[1] = GetConVarFloat(BeanBagForceVel[1]) + (GetConVarFloat(BeanBagAmountLevel) * Sh[attacker][2]);
		BeanBagForce[2] = GetConVarFloat(BeanBagForceVel[2]) + (GetConVarFloat(BeanBagAmountLevel) * Sh[attacker][2]);
	}
	else if (StrEqual(WeaponUsed, "weapon_rifle", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_ak47", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_desert", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_m60", true) || 
			 StrEqual(WeaponUsed, "weapon_rifle_sg552", true))
	{
		if (!BeanBagAmmoRifle[attacker] || BeanBagAmmoAmountRifle[attacker] < 1) return;
		BeanBagAmmoAmountRifle[attacker]--;
		if (BeanBagAmmoAmountRifle[attacker] < 1) BeanBagAmmoRifle[attacker] = false;
		BeanBagForce[0] = GetConVarFloat(BeanBagForceVel[0]) + (GetConVarFloat(BeanBagAmountLevel) * Ri[attacker][2]);
		BeanBagForce[1] = GetConVarFloat(BeanBagForceVel[1]) + (GetConVarFloat(BeanBagAmountLevel) * Ri[attacker][2]);
		BeanBagForce[2] = GetConVarFloat(BeanBagForceVel[2]) + (GetConVarFloat(BeanBagAmountLevel) * Ri[attacker][2]);
	}
	else if (StrEqual(WeaponUsed, "weapon_sniper_awp", true) || 
			 StrEqual(WeaponUsed, "weapon_sniper_military", true) || 
			 StrEqual(WeaponUsed, "weapon_sniper_scout", true) || 
			 StrEqual(WeaponUsed, "weapon_hunting_rifle", true))
	{
		if (!BeanBagAmmoSniper[attacker] || BeanBagAmmoAmountSniper[attacker] < 1) return;
		BeanBagAmmoAmountSniper[attacker]--;
		if (BeanBagAmmoAmountSniper[attacker] < 1) BeanBagAmmoSniper[attacker] = false;
		BeanBagForce[0] = GetConVarFloat(BeanBagForceVel[0]) + (GetConVarFloat(BeanBagAmountLevel) * Sn[attacker][2]);
		BeanBagForce[1] = GetConVarFloat(BeanBagForceVel[1]) + (GetConVarFloat(BeanBagAmountLevel) * Sn[attacker][2]);
		BeanBagForce[2] = GetConVarFloat(BeanBagForceVel[2]) + (GetConVarFloat(BeanBagAmountLevel) * Sn[attacker][2]);
	}
	else return;
		
	new Float:vel[3];
	vel[0] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[0]");
	vel[1] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[1]");
	vel[2] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[2]");
	vel[0] -= BeanBagForce[0];
	vel[1] -= BeanBagForce[1];
	vel[2] += BeanBagForce[2];

	BeanBagAmmoImmune[victim] = true;
	TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, vel);
	CreateTimer(GetConVarFloat(BeanBagAmmoImmuneTime), Timer_EnableBeanBag, victim, TIMER_FLAG_NO_MAPCHANGE);
}

public Action:Timer_EnableBeanBag(Handle:timer, any:victim)
{
	BeanBagAmmoImmune[victim] = false;
	return Plugin_Stop;
}

CallScoutAbility(attacker, victim, Class)
{
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim) || !IsPlayerAlive(victim)) return;
	if (IsClientIndexOutOfRange(attacker) || !IsClientInGame(attacker) || IsFakeClient(attacker) || !Scout[attacker]) return;
	decl String:ClassName[128];
	if (!IsFakeClient(victim))
	{
		if (Class == ZOMBIECLASS_HUNTER) Format(ClassName, sizeof(ClassName), "Hunter Lv. %d (%d)", Hu[victim][2], In[victim][2]);
		if (Class == ZOMBIECLASS_SMOKER) Format(ClassName, sizeof(ClassName), "Smoker Lv. %d (%d)", Sm[victim][2], In[victim][2]);
		if (Class == ZOMBIECLASS_BOOMER) Format(ClassName, sizeof(ClassName), "Boomer Lv. %d (%d)", Bo[victim][2], In[victim][2]);
		if (Class == ZOMBIECLASS_JOCKEY) Format(ClassName, sizeof(ClassName), "Jockey Lv. %d (%d)", Jo[victim][2], In[victim][2]);
		if (Class == ZOMBIECLASS_CHARGER) Format(ClassName, sizeof(ClassName), "Charger Lv. %d (%d)", Ch[victim][2], In[victim][2]);
		if (Class == ZOMBIECLASS_SPITTER) Format(ClassName, sizeof(ClassName), "Spitter Lv. %d (%d)", Sp[victim][2], In[victim][2]);
		if (Class == ZOMBIECLASS_TANK) Format(ClassName, sizeof(ClassName), "Tank Lv. %d (%d)", Ta[victim][2], In[victim][2]);
	}
	else
	{
		if (Class == ZOMBIECLASS_HUNTER) Format(ClassName, sizeof(ClassName), "Hunter Lv. %d (%d)", AIHunter[2], AIInfected[2]);
		if (Class == ZOMBIECLASS_SMOKER) Format(ClassName, sizeof(ClassName), "Smoker Lv. %d (%d)", AISmoker[2], AIInfected[2]);
		if (Class == ZOMBIECLASS_BOOMER) Format(ClassName, sizeof(ClassName), "Boomer Lv. %d (%d)", AIBoomer[2], AIInfected[2]);
		if (Class == ZOMBIECLASS_JOCKEY) Format(ClassName, sizeof(ClassName), "Jockey Lv. %d (%d)", AIJockey[2], AIInfected[2]);
		if (Class == ZOMBIECLASS_CHARGER) Format(ClassName, sizeof(ClassName), "Charger Lv. %d (%d)", AICharger[2], AIInfected[2]);
		if (Class == ZOMBIECLASS_SPITTER) Format(ClassName, sizeof(ClassName), "Spitter Lv. %d (%d)", AISpitter[2], AIInfected[2]);
		if (Class == ZOMBIECLASS_TANK) Format(ClassName, sizeof(ClassName), "Tank Lv. %d (%d)", AITank[2], AIInfected[2]);
	}
	PrintHintText(attacker, "%s\nHealth: %d", ClassName, GetClientHealth(victim));
}

LevelXP(attacker, victim)
{
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim) || !IsPlayerAlive(victim)) return;
	new XP = 0;
	new String:weaponused[64];
	if (GetClientTeam(attacker) == 3 && !IsFakeClient(victim))
	{
		GetClientWeapon(victim, weaponused, sizeof(weaponused));
		if (StrEqual(weaponused, "weapon_pistol", true) || 
			StrEqual(weaponused, "weapon_pistol_magnum", true)) XP += Pi[victim][2];
		else if (StrEqual(weaponused, "weapon_melee", true)) XP += Me[victim][2];
		else if (StrEqual(weaponused, "weapon_smg", true) || 
				 StrEqual(weaponused, "weapon_smg_mp5", true) || 
				 StrEqual(weaponused, "weapon_smg_silenced", true)) XP += Uz[victim][2];
		else if (StrEqual(weaponused, "weapon_autoshotgun", true) || 
				StrEqual(weaponused, "weapon_pumpshotgun", true) || 
				StrEqual(weaponused, "weapon_shotgun_chrome", true) || 
				StrEqual(weaponused, "weapon_shotgun_spas", true)) XP += Sh[victim][2];
		else if (StrEqual(weaponused, "weapon_rifle", true) || 
				StrEqual(weaponused, "weapon_rifle_ak47", true) || 
				StrEqual(weaponused, "weapon_rifle_desert", true) || 
				StrEqual(weaponused, "weapon_rifle_m60", true) || 
				StrEqual(weaponused, "weapon_rifle_sg552", true)) XP += Ri[victim][2];
		else if (StrEqual(weaponused, "weapon_sniper_awp", true) || 
				StrEqual(weaponused, "weapon_sniper_military", true) || 
				StrEqual(weaponused, "weapon_sniper_scout", true) || 
				StrEqual(weaponused, "weapon_hunting_rifle", true)) XP += Sn[victim][2];
		XP += Ph[victim][0];
		In[attacker][0] += XP;
		if (ClassHunter[attacker]) Hu[attacker][0] += XP;
		else if (ClassSmoker[attacker]) Sm[attacker][0] += XP;
		else if (ClassBoomer[attacker]) Bo[attacker][0] += XP;
		else if (ClassJockey[attacker]) Jo[attacker][0] += XP;
		else if (ClassCharger[attacker]) Ch[attacker][0] += XP;
		else if (ClassSpitter[attacker]) Sp[attacker][0] += XP;
		else if (ClassTank[attacker]) Ta[attacker][0] += XP;
	}
	else if (GetClientTeam(attacker) == 2)
	{
		GetClientWeapon(attacker, weaponused, sizeof(weaponused));
		if (LockedWeaponUsed(attacker)) return;
		// If the weapon isn't a locked weapon, we reward them for the SI kill.
		if (!IsFakeClient(victim))
		{
			if (ClassHunter[victim]) XP += Hu[victim][2];
			else if (ClassSmoker[victim]) XP += Sm[victim][2];
			else if (ClassBoomer[victim]) XP += Bo[victim][2];
			else if (ClassJockey[victim]) XP += Jo[victim][2];
			else if (ClassCharger[victim]) XP += Ch[victim][2];
			else if (ClassSpitter[victim]) XP += Sp[victim][2];
			else if (ClassTank[victim]) XP += Ta[victim][2];
			XP += In[victim][2];
		}
		else
		{
			if (ClassHunter[victim]) XP += AIHunter[2];
			else if (ClassSmoker[victim]) XP += AISmoker[2];
			else if (ClassBoomer[victim]) XP += AIBoomer[2];
			else if (ClassJockey[victim]) XP += AIJockey[2];
			else if (ClassCharger[victim]) XP += AICharger[2];
			else if (ClassSpitter[victim]) XP += AISpitter[2];
			else if (ClassTank[victim]) XP += AITank[2];
			XP += AIInfected[2];
		}
		if (StrEqual(weaponused, "weapon_pistol", true) || 
			StrEqual(weaponused, "weapon_pistol_magnum", true)) Pi[attacker][0] += XP;
		else if (StrEqual(weaponused, "weapon_melee", true)) Me[attacker][0] += XP;
		else if (StrEqual(weaponused, "weapon_smg", true) || 
				 StrEqual(weaponused, "weapon_smg_mp5", true) || 
				 StrEqual(weaponused, "weapon_smg_silenced", true)) Uz[attacker][0] += XP;
		else if (StrEqual(weaponused, "weapon_autoshotgun", true) || 
				StrEqual(weaponused, "weapon_pumpshotgun", true) || 
				StrEqual(weaponused, "weapon_shotgun_chrome", true) || 
				StrEqual(weaponused, "weapon_shotgun_spas", true)) Sh[attacker][0] += XP;
		else if (StrEqual(weaponused, "weapon_rifle", true) || 
				StrEqual(weaponused, "weapon_rifle_ak47", true) || 
				StrEqual(weaponused, "weapon_rifle_desert", true) || 
				StrEqual(weaponused, "weapon_rifle_m60", true) || 
				StrEqual(weaponused, "weapon_rifle_sg552", true)) Ri[attacker][0] += XP;
		else if (StrEqual(weaponused, "weapon_sniper_awp", true) || 
				StrEqual(weaponused, "weapon_sniper_military", true) || 
				StrEqual(weaponused, "weapon_sniper_scout", true) || 
				StrEqual(weaponused, "weapon_hunting_rifle", true)) Sn[attacker][0] += XP;
		Ph[attacker][0] += XP;
	}
}

CallWeaponDamage(attacker, victim, value)
{
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim) || !IsPlayerAlive(victim)) return;
	new damageBonus = 0;
	new String:weaponused[64];
	GetClientWeapon(attacker, weaponused, sizeof(weaponused));
	if (StrEqual(weaponused, "weapon_pistol", true) || 
		(StrEqual(weaponused, "weapon_pistol_magnum", true) && Pi[attacker][2] >= GetConVarInt(PistolDeagleLevel)))
	{
		// If the survivor is using heal ammo, don't add damage modifiers, and return the health to the infected player.
		if (HealAmmoPistol[attacker])
		{
			SetEntityHealth(victim, GetClientHealth(victim) + value);
			return;
		}
		PistolDamage[attacker][victim] += value;
		damageBonus = RoundToFloor(Pi[attacker][2] * GetConVarFloat(WeaponBonusDamage));
		if (DrugsUsed[attacker] > 0 && DrugEffect[attacker])
		{
			damageBonus += RoundToFloor(DrugsUsed[attacker] * GetConVarFloat(DrugBonusDamage));
		}
		if (IsPlayerAlive(victim) && (GetClientHealth(victim) - damageBonus) > 0)
		{
			SetEntityHealth(victim, GetClientHealth(victim) - damageBonus);
			RoundAward[attacker] += damageBonus;
			AssistHurtInfected[attacker][victim] += damageBonus;
		}
		
	}
		
	else if (StrEqual(weaponused, "weapon_melee", true))
	{
		MeleeDamage[attacker][victim] += value;
		damageBonus = RoundToFloor(Me[attacker][2] * GetConVarFloat(WeaponBonusDamage));
		if (DrugsUsed[attacker] > 0 && DrugEffect[attacker])
		{
			damageBonus += RoundToFloor(DrugsUsed[attacker] * GetConVarFloat(DrugBonusDamage));
		}
		if (IsPlayerAlive(victim) && (GetClientHealth(victim) - damageBonus) > 0)
		{
			SetEntityHealth(victim, GetClientHealth(victim) - damageBonus);
			RoundAward[attacker] += damageBonus;
			AssistHurtInfected[attacker][victim] += damageBonus;
		}
	}
	
	else if ((StrEqual(weaponused, "weapon_smg", true) && Ph[attacker][2] >= GetConVarInt(UziLevelUnlock) && Uz[attacker][2] >= GetConVarInt(UziMac10Level)) || 
			(StrEqual(weaponused, "weapon_smg_mp5", true) && Ph[attacker][2] >= GetConVarInt(UziLevelUnlock) && Uz[attacker][2] >= GetConVarInt(UziMp5Level)) || 
			(StrEqual(weaponused, "weapon_smg_silenced", true) && Ph[attacker][2] >= GetConVarInt(UziLevelUnlock) && Uz[attacker][2] >= GetConVarInt(UziMp5Level)))
	{
		// If the survivor is using heal ammo, don't add damage modifiers, and return the health to the infected player.
		if (HealAmmoSmg[attacker])
		{
			SetEntityHealth(victim, GetClientHealth(victim) + value);
			return;
		}
		UziDamage[attacker][victim] += value;
		damageBonus = RoundToFloor(Uz[attacker][2] * GetConVarFloat(WeaponBonusDamage));
		if (DrugsUsed[attacker] > 0 && DrugEffect[attacker])
		{
			damageBonus += RoundToFloor(DrugsUsed[attacker] * GetConVarFloat(DrugBonusDamage));
		}
		if (IsPlayerAlive(victim) && (GetClientHealth(victim) - damageBonus) > 0)
		{
			SetEntityHealth(victim, GetClientHealth(victim) - damageBonus);
			RoundAward[attacker] += damageBonus;
			AssistHurtInfected[attacker][victim] += damageBonus;
		}
	}
			
	else if ((StrEqual(weaponused, "weapon_autoshotgun", true) && Ph[attacker][2] >= GetConVarInt(ShotgunLevelUnlock) && Sh[attacker][2] >= GetConVarInt(ShotgunAutoLevel)) || 
			(StrEqual(weaponused, "weapon_pumpshotgun", true) && Ph[attacker][2] >= GetConVarInt(ShotgunLevelUnlock) && Sh[attacker][2] >= GetConVarInt(ShotgunPumpLevel)) || 
			(StrEqual(weaponused, "weapon_shotgun_chrome", true) && Ph[attacker][2] >= GetConVarInt(ShotgunLevelUnlock) && Sh[attacker][2] >= GetConVarInt(ShotgunChromeLevel)) || 
			(StrEqual(weaponused, "weapon_shotgun_spas", true) && Ph[attacker][2] >= GetConVarInt(ShotgunLevelUnlock) && Sh[attacker][2] >= GetConVarInt(ShotgunSpasLevel)))
	{
		// If the survivor is using heal ammo, don't add damage modifiers, and return the health to the infected player.
		if (HealAmmoShotgun[attacker])
		{
			SetEntityHealth(victim, GetClientHealth(victim) + value);
			return;
		}
		ShotgunDamage[attacker][victim] += value;
		damageBonus = RoundToFloor(Sh[attacker][2] * GetConVarFloat(WeaponBonusDamage));
		if (DrugsUsed[attacker] > 0 && DrugEffect[attacker])
		{
			damageBonus += RoundToFloor(DrugsUsed[attacker] * GetConVarFloat(DrugBonusDamage));
		}
		if (IsPlayerAlive(victim) && (GetClientHealth(victim) - damageBonus) > 0)
		{
			SetEntityHealth(victim, GetClientHealth(victim) - damageBonus);
			RoundAward[attacker] += damageBonus;
			AssistHurtInfected[attacker][victim] += damageBonus;
		}
	}
	else if ((StrEqual(weaponused, "weapon_rifle", true) && Ph[attacker][2] >= GetConVarInt(RifleLevelUnlock) && Ri[attacker][2] >= GetConVarInt(RifleM16Level)) || 
			(StrEqual(weaponused, "weapon_rifle_ak47", true) && Ph[attacker][2] >= GetConVarInt(RifleLevelUnlock) && Ri[attacker][2] >= GetConVarInt(RifleAK47Level)) || 
			(StrEqual(weaponused, "weapon_rifle_desert", true) && Ph[attacker][2] >= GetConVarInt(RifleLevelUnlock) && Ri[attacker][2] >= GetConVarInt(RifleDesertLevel)) || 
			(StrEqual(weaponused, "weapon_rifle_m60", true) && Ph[attacker][2] >= GetConVarInt(RifleLevelUnlock) && Ri[attacker][2] >= GetConVarInt(RifleM60Level)) || 
			(StrEqual(weaponused, "weapon_rifle_sg552", true) && Ph[attacker][2] >= GetConVarInt(RifleLevelUnlock) && Ri[attacker][2] >= GetConVarInt(RifleSG552Level)))
	{
		// If the survivor is using heal ammo, don't add damage modifiers, and return the health to the infected player.
		if (HealAmmoRifle[attacker])
		{
			SetEntityHealth(victim, GetClientHealth(victim) + value);
			return;
		}
		RifleDamage[attacker][victim] += value;
		damageBonus = RoundToFloor(Ri[attacker][2] * GetConVarFloat(WeaponBonusDamage));
		if (DrugsUsed[attacker] > 0 && DrugEffect[attacker])
		{
			damageBonus += RoundToFloor(DrugsUsed[attacker] * GetConVarFloat(DrugBonusDamage));
		}
		if (IsPlayerAlive(victim) && (GetClientHealth(victim) - damageBonus) > 0)
		{
			SetEntityHealth(victim, GetClientHealth(victim) - damageBonus);
			RoundAward[attacker] += damageBonus;
			AssistHurtInfected[attacker][victim] += damageBonus;
		}
	}
	else if ((StrEqual(weaponused, "weapon_sniper_awp", true) && Ph[attacker][2] >= GetConVarInt(SniperLevelUnlock) && Sn[attacker][2] >= GetConVarInt(SniperAwpLevel)) || 
			(StrEqual(weaponused, "weapon_sniper_military", true) && Ph[attacker][2] >= GetConVarInt(SniperLevelUnlock) && Sn[attacker][2] >= GetConVarInt(SniperMilitaryLevel)) || 
			(StrEqual(weaponused, "weapon_sniper_scout", true) && Ph[attacker][2] >= GetConVarInt(SniperLevelUnlock) && Sn[attacker][2] >= GetConVarInt(SniperScoutLevel)) || 
			(StrEqual(weaponused, "weapon_hunting_rifle", true) && Ph[attacker][2] >= GetConVarInt(SniperLevelUnlock) && Sn[attacker][2] >= GetConVarInt(SniperHuntingLevel)))
	{
		// If the survivor is using heal ammo, don't add damage modifiers, and return the health to the infected player.
		if (HealAmmoSniper[attacker])
		{
			SetEntityHealth(victim, GetClientHealth(victim) + value);
			return;
		}
		SniperDamage[attacker][victim] += value;
		damageBonus = RoundToFloor(Sn[attacker][2] * GetConVarFloat(WeaponBonusDamage));
		if (DrugsUsed[attacker] > 0 && DrugEffect[attacker])
		{
			damageBonus += RoundToFloor(DrugsUsed[attacker] * GetConVarFloat(DrugBonusDamage));
		}
		if (IsPlayerAlive(victim) && (GetClientHealth(victim) - damageBonus) > 0)
		{
			SetEntityHealth(victim, GetClientHealth(victim) - damageBonus);
			RoundAward[attacker] += damageBonus;
			AssistHurtInfected[attacker][victim] += damageBonus;
		}
	}
}

InfectedPlayerHasDied(infected)
{
	if (IsClientIndexOutOfRange(infected)) return;
	if (!IsClientInGame(infected)) return;
	
	if (GetConVarInt(DirectorEnabled) == 1 && IsFakeClient(infected))
	{
		// Transfer the infected bots points to the director pool
		// since bots are removed from the game shortly after they die.
		DirectorPoints += InfectedPoints[infected];
	}
	decl Float:point_reward;
	decl xp_reward;
	// We check if tank is > 0 to make sure that it wasn't a tank spawned on the finale (with 1 health)
	
	/*		Was this player alone? Find out			*/
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 2 || !IsPlayerAlive(i)) continue;
		if (AssistHurtInfected[i][infected] > 0.0)
		{
			point_reward = 0.0;
			xp_reward = 0;
			if (!ClassTank[infected])
			{
				point_reward = ((AssistHurtInfected[i][infected] * GetConVarFloat(SurvivorAssistPoints)) * SurvivorMultiplier[i]) * GetConVarFloat(SurvivorAssistMultiplier);
				xp_reward = RoundToFloor(AssistHurtInfected[i][infected] * GetConVarFloat(XPPerRoundDamageSurvivor));
			}
			else
			{
				point_reward = ((AssistHurtInfected[i][infected] * GetConVarFloat(SurvivorAssistPoints)) * SurvivorMultiplier[i]) * GetConVarFloat(SurvivorTankAssistPoints);
				xp_reward = RoundToFloor(AssistHurtInfected[i][infected] * GetConVarFloat(XPPerTankDamageSurvivor));
			}
			SurvivorTeamPoints += (point_reward * GetConVarFloat(SurvivorTeamPointsMP));
			if (showpoints[i] == 1)
			{
				PrintToChat(i, "%s \x01DMG \x04%N \x01: \x05%d \x01for \x05 %3.3f \x01point(s). (%3.3f)", POINTS_INFO, infected, AssistHurtInfected[i][infected], point_reward, SurvivorMultiplier[i]);
			}
			SurvivorPoints[i] += point_reward;
			Ph[i][0] += xp_reward;
			AssistHurtInfected[i][infected] = 0;
			// give 0 experience since we gave them physical experience.
			experience_increase(i, 0);
			continue;
		}
	}
	
	// now we need to award them for each of the weapon categories they used, if they have that category unlocked.
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 2 || !IsPlayerAlive(i)) continue;
		PistolDamage[i][infected] = RoundToFloor(PistolDamage[i][infected] * GetConVarFloat(XPPerRoundDamageSurvivor));
		MeleeDamage[i][infected] = RoundToFloor(MeleeDamage[i][infected] * GetConVarFloat(XPPerRoundDamageSurvivor));
		UziDamage[i][infected] = RoundToFloor(UziDamage[i][infected] * GetConVarFloat(XPPerRoundDamageSurvivor));
		ShotgunDamage[i][infected] = RoundToFloor(ShotgunDamage[i][infected] * GetConVarFloat(XPPerRoundDamageSurvivor));
		SniperDamage[i][infected] = RoundToFloor(SniperDamage[i][infected] * GetConVarFloat(XPPerRoundDamageSurvivor));
		RifleDamage[i][infected] = RoundToFloor(RifleDamage[i][infected] * GetConVarFloat(XPPerRoundDamageSurvivor));
		/*
		if (showpoints[i])
		{
			if (PistolDamage[i][infected] > 0) PrintToChat(i, "%s \x01Pistol : \x05%d", XP_INFO, PistolDamage[i][infected]);
			if (MeleeDamage[i][infected] > 0) PrintToChat(i, "%s \x01Melee : \x05%d", XP_INFO, MeleeDamage[i][infected]);
			if (UziDamage[i][infected] > 0) PrintToChat(i, "%s \x01Uzi : \x05%d", XP_INFO, UziDamage[i][infected]);
			if (ShotgunDamage[i][infected] > 0) PrintToChat(i, "%s \x01Shotgun : \x05%d", XP_INFO, ShotgunDamage[i][infected]);
			if (SniperDamage[i][infected] > 0) PrintToChat(i, "%s \x01Sniper : \x05%d", XP_INFO, SniperDamage[i][infected]);
			if (RifleDamage[i][infected] > 0) PrintToChat(i, "%s \x01Rifle : \x05%d", XP_INFO, RifleDamage[i][infected]);
		}
		*/
		Pi[i][0] += PistolDamage[i][infected];
		Me[i][0] += MeleeDamage[i][infected];
		Uz[i][0] += UziDamage[i][infected];
		Sh[i][0] += ShotgunDamage[i][infected];
		Sn[i][0] += SniperDamage[i][infected];
		Ri[i][0] += RifleDamage[i][infected];
		PistolDamage[i][infected] = 0;
		MeleeDamage[i][infected] = 0;
		UziDamage[i][infected] = 0;
		ShotgunDamage[i][infected] = 0;
		SniperDamage[i][infected] = 0;
		RifleDamage[i][infected] = 0;
		experience_increase(i, 0);
	}
}