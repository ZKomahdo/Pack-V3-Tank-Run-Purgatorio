_SpawnEvent_OnPluginStart()
{
	HookEvent("player_spawn", Event_PlayerSpawn);
}

/*			PLAYERSPAWN EVENT - SETTING UP INFECTED HEALTH BASED ON CLASS-LEVEL			*/

public Action:Event_PlayerSpawn(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	if (IsClientIndexOutOfRange(attacker) || !IsClientInGame(attacker) || GetClientTeam(attacker) != 3) return;
	BerserkerKill[attacker] = false;												// Players Can Use This Skill Again.
	InJump[attacker] = false;
	SetEntityMoveType(attacker, MOVETYPE_WALK);
	SetEntityGravity(attacker, 1.0);
	if (IsFakeClient(attacker)) RemoveAmmoImmune(attacker);
	PlayerZombieCheck(attacker);					// Bots go to a different function.
}

RemoveAmmoImmune(attacker)
{
	IceAmmoImmune[attacker] = false;
	BloatAmmoImmune[attacker] = false;
	SpitterImmune[attacker] = false;
	BeanBagAmmoImmune[attacker] = false;
}

PlayerZombieCheck(attacker)
{
	if (IsClientIndexOutOfRange(attacker)) return;
	if (!IsClientInGame(attacker) || GetClientTeam(attacker) != 3 || !IsPlayerAlive(attacker)) return;
	// We need to check if the player is shapeshifting from a hunter, to fix the glow bug.
	if (!IsFakeClient(attacker) && !IsPlayerGhost(attacker) && IsPlayerAlive(attacker) && ClassHunter[attacker]) FindHunterVictim(attacker);
	InfectedGhost[attacker] = false;
	ClassHunter[attacker] = false;
	ClassSmoker[attacker] = false;
	ClassBoomer[attacker] = false;
	ClassJockey[attacker] = false;
	ClassCharger[attacker] = false;
	ClassSpitter[attacker] = false;
	new Class = GetEntProp(attacker, Prop_Send, "m_zombieClass");
	if (!IsFakeClient(attacker))
	{
		if ((Class == ZOMBIECLASS_HUNTER && Hu[attacker][2] >= GetConVarInt(WallOfFireLevel)) || 
			(Class == ZOMBIECLASS_SMOKER && Sm[attacker][2] >= GetConVarInt(WallOfFireLevel)) || 
			(Class == ZOMBIECLASS_BOOMER && Bo[attacker][2] >= GetConVarInt(WallOfFireLevel)) || 
			(Class == ZOMBIECLASS_JOCKEY && Jo[attacker][2] >= GetConVarInt(WallOfFireLevel)) || 
			(Class == ZOMBIECLASS_CHARGER && Ch[attacker][2] >= GetConVarInt(WallOfFireLevel)) || 
			(Class == ZOMBIECLASS_SPITTER && Sp[attacker][2] >= GetConVarInt(WallOfFireLevel)) || 
			(Class == ZOMBIECLASS_TANK && Ta[attacker][2] >= GetConVarInt(WallOfFireLevel)))
		{
			SDKHook(attacker, SDKHook_OnTakeDamage, OnTakeDamage);
		}
		else SDKUnhook(attacker, SDKHook_OnTakeDamage, OnTakeDamage);
		if (Hu[attacker][2] >= GetConVarInt(InfectedTier2Level) && !UpgradeHunter[attacker])
		{
			UpgradeHunter[attacker] = true;
			PersonalUpgrades[attacker]++;
		}
		if (Sm[attacker][2] >= GetConVarInt(InfectedTier2Level) && !UpgradeSmoker[attacker])
		{
			UpgradeSmoker[attacker] = true;
			PersonalUpgrades[attacker]++;
		}
		if (Bo[attacker][2] >= GetConVarInt(InfectedTier2Level) && !UpgradeBoomer[attacker])
		{
			UpgradeBoomer[attacker] = true;
			PersonalUpgrades[attacker]++;
		}
		if (Jo[attacker][2] >= GetConVarInt(InfectedTier2Level) && !UpgradeJockey[attacker])
		{
			UpgradeJockey[attacker] = true;
			PersonalUpgrades[attacker]++;
		}
		if (Ch[attacker][2] >= GetConVarInt(InfectedTier2Level) && !UpgradeCharger[attacker])
		{
			UpgradeCharger[attacker] = true;
			PersonalUpgrades[attacker]++;
		}
		if (Sp[attacker][2] >= GetConVarInt(InfectedTier2Level) && !UpgradeSpitter[attacker])
		{
			UpgradeSpitter[attacker] = true;
			PersonalUpgrades[attacker]++;
		}
		if (Hu[attacker][2] >= GetConVarInt(InfectedTier3Level) && !SuperUpgradeHunter[attacker])
		{
			SuperUpgradeHunter[attacker] = true;
			PersonalUpgrades[attacker]++;
		}
		if (Sm[attacker][2] >= GetConVarInt(InfectedTier3Level) && !SuperUpgradeSmoker[attacker])
		{
			SuperUpgradeSmoker[attacker] = true;
			PersonalUpgrades[attacker]++;
		}
		if (Bo[attacker][2] >= GetConVarInt(InfectedTier3Level) && !SuperUpgradeBoomer[attacker])
		{
			SuperUpgradeBoomer[attacker] = true;
			PersonalUpgrades[attacker]++;
		}
		if (Jo[attacker][2] >= GetConVarInt(InfectedTier3Level) && !SuperUpgradeJockey[attacker])
		{
			SuperUpgradeJockey[attacker] = true;
			PersonalUpgrades[attacker]++;
		}
		if (Ch[attacker][2] >= GetConVarInt(InfectedTier3Level) && !SuperUpgradeCharger[attacker])
		{
			SuperUpgradeCharger[attacker] = true;
			PersonalUpgrades[attacker]++;
		}
		if (Sp[attacker][2] >= GetConVarInt(InfectedTier3Level) && !SuperUpgradeSpitter[attacker])
		{
			SuperUpgradeSpitter[attacker] = true;
			PersonalUpgrades[attacker]++;
		}
	}
	if (Class != ZOMBIECLASS_TANK)
	{
		if (!IsFakeClient(attacker))
		{
			if (	((Class == ZOMBIECLASS_HUNTER && Hu[attacker][2] >= GetConVarInt(InfectedTier4Level)))	|| 
					((Class == ZOMBIECLASS_SMOKER && Sm[attacker][2] >= GetConVarInt(InfectedTier4Level)))	|| 
					((Class == ZOMBIECLASS_BOOMER && Bo[attacker][2] >= GetConVarInt(InfectedTier4Level)))	|| 
					((Class == ZOMBIECLASS_JOCKEY && Jo[attacker][2] >= GetConVarInt(InfectedTier4Level)))	|| 
					((Class == ZOMBIECLASS_CHARGER && Ch[attacker][2] >= GetConVarInt(InfectedTier4Level)))	|| 
					((Class == ZOMBIECLASS_SPITTER && Sp[attacker][2] >= GetConVarInt(InfectedTier4Level)))	)
			{
				if (!IsPlayerAlive(attacker)) return;
				SetEntityRenderMode(attacker, RENDER_TRANSCOLOR);
				if (Class != ZOMBIECLASS_HUNTER) SetEntityRenderColor(attacker, GetConVarInt(InfectedTier4Color[0]), GetConVarInt(InfectedTier4Color[1]), GetConVarInt(InfectedTier4Color[2]), 235);
				else SetEntityRenderColor(attacker, GetConVarInt(InfectedTier4Color[0]), GetConVarInt(InfectedTier4Color[1]), GetConVarInt(InfectedTier4Color[2]), 50);
			}
			else if (	((Class == ZOMBIECLASS_HUNTER && SuperUpgradeHunter[attacker]) || (Class == ZOMBIECLASS_HUNTER && Hu[attacker][2] >= GetConVarInt(InfectedTier3Level)))	|| 
					((Class == ZOMBIECLASS_SMOKER && SuperUpgradeSmoker[attacker]) || (Class == ZOMBIECLASS_SMOKER && Sm[attacker][2] >= GetConVarInt(InfectedTier3Level)))	|| 
					((Class == ZOMBIECLASS_BOOMER && SuperUpgradeBoomer[attacker]) || (Class == ZOMBIECLASS_BOOMER && Bo[attacker][2] >= GetConVarInt(InfectedTier3Level)))	|| 
					((Class == ZOMBIECLASS_JOCKEY && SuperUpgradeJockey[attacker]) || (Class == ZOMBIECLASS_JOCKEY && Jo[attacker][2] >= GetConVarInt(InfectedTier3Level)))	|| 
					((Class == ZOMBIECLASS_CHARGER && SuperUpgradeCharger[attacker]) || (Class == ZOMBIECLASS_CHARGER && Ch[attacker][2] >= GetConVarInt(InfectedTier3Level)))	|| 
					((Class == ZOMBIECLASS_SPITTER && SuperUpgradeSpitter[attacker]) || (Class == ZOMBIECLASS_SPITTER && Sp[attacker][2] >= GetConVarInt(InfectedTier3Level)))	)
			{
				if (!IsPlayerAlive(attacker)) return;
				SetEntityRenderMode(attacker, RENDER_TRANSCOLOR);
				if (Class != ZOMBIECLASS_HUNTER) SetEntityRenderColor(attacker, GetConVarInt(InfectedTier3Color[0]), GetConVarInt(InfectedTier3Color[1]), GetConVarInt(InfectedTier3Color[2]), 255);
				else SetEntityRenderColor(attacker, GetConVarInt(InfectedTier3Color[0]), GetConVarInt(InfectedTier3Color[1]), GetConVarInt(InfectedTier3Color[2]), 100);
			}
			else if (	((Class == ZOMBIECLASS_HUNTER && UpgradeHunter[attacker]) || (Class == ZOMBIECLASS_HUNTER && Hu[attacker][2] >= GetConVarInt(InfectedTier2Level)))	|| 
					((Class == ZOMBIECLASS_SMOKER && UpgradeSmoker[attacker]) || (Class == ZOMBIECLASS_SMOKER && Sm[attacker][2] >= GetConVarInt(InfectedTier2Level)))	|| 
					((Class == ZOMBIECLASS_BOOMER && UpgradeBoomer[attacker]) || (Class == ZOMBIECLASS_BOOMER && Bo[attacker][2] >= GetConVarInt(InfectedTier2Level)))	|| 
					((Class == ZOMBIECLASS_JOCKEY && UpgradeJockey[attacker]) || (Class == ZOMBIECLASS_JOCKEY && Jo[attacker][2] >= GetConVarInt(InfectedTier2Level)))	|| 
					((Class == ZOMBIECLASS_CHARGER && UpgradeCharger[attacker]) || (Class == ZOMBIECLASS_CHARGER && Ch[attacker][2] >= GetConVarInt(InfectedTier2Level)))	|| 
					((Class == ZOMBIECLASS_SPITTER && UpgradeSpitter[attacker]) || (Class == ZOMBIECLASS_SPITTER && Sp[attacker][2] >= GetConVarInt(InfectedTier2Level)))	)
			{
				if (!IsPlayerAlive(attacker)) return;
				SetEntityRenderMode(attacker, RENDER_TRANSCOLOR);
				if (Class != ZOMBIECLASS_HUNTER) SetEntityRenderColor(attacker, GetConVarInt(InfectedTier2Color[0]), GetConVarInt(InfectedTier2Color[1]), GetConVarInt(InfectedTier2Color[2]), 255);
				else SetEntityRenderColor(attacker, GetConVarInt(InfectedTier2Color[0]), GetConVarInt(InfectedTier2Color[1]), GetConVarInt(InfectedTier2Color[2]), 150);
			}
		}
		else
		{
			if (	((Class == ZOMBIECLASS_HUNTER && AIHunter[2] >= GetConVarInt(InfectedTier4Level)))	|| 
					((Class == ZOMBIECLASS_SMOKER && AISmoker[2] >= GetConVarInt(InfectedTier4Level)))	|| 
					((Class == ZOMBIECLASS_BOOMER && AIBoomer[2] >= GetConVarInt(InfectedTier4Level)))	|| 
					((Class == ZOMBIECLASS_JOCKEY && AIJockey[2] >= GetConVarInt(InfectedTier4Level)))	|| 
					((Class == ZOMBIECLASS_CHARGER && AICharger[2] >= GetConVarInt(InfectedTier4Level)))	|| 
					((Class == ZOMBIECLASS_SPITTER && AISpitter[2] >= GetConVarInt(InfectedTier4Level)))	)
			{
				if (!IsPlayerAlive(attacker)) return;
				SetEntityRenderMode(attacker, RENDER_TRANSCOLOR);
				if (Class != ZOMBIECLASS_HUNTER) SetEntityRenderColor(attacker, GetConVarInt(InfectedTier4Color[0]), GetConVarInt(InfectedTier4Color[1]), GetConVarInt(InfectedTier4Color[2]), 235);
				else SetEntityRenderColor(attacker, GetConVarInt(InfectedTier4Color[0]), GetConVarInt(InfectedTier4Color[1]), GetConVarInt(InfectedTier4Color[2]), 50);
			}
			else if (	((Class == ZOMBIECLASS_HUNTER && AIHunter[2] >= GetConVarInt(InfectedTier3Level)))	|| 
					((Class == ZOMBIECLASS_SMOKER && AISmoker[2] >= GetConVarInt(InfectedTier3Level)))	|| 
					((Class == ZOMBIECLASS_BOOMER && AIBoomer[2] >= GetConVarInt(InfectedTier3Level)))	|| 
					((Class == ZOMBIECLASS_JOCKEY && AIJockey[2] >= GetConVarInt(InfectedTier3Level)))	|| 
					((Class == ZOMBIECLASS_CHARGER && AICharger[2] >= GetConVarInt(InfectedTier3Level)))	|| 
					((Class == ZOMBIECLASS_SPITTER && AISpitter[2] >= GetConVarInt(InfectedTier3Level)))	)
			{
				if (!IsPlayerAlive(attacker)) return;
				SetEntityRenderMode(attacker, RENDER_TRANSCOLOR);
				if (Class != ZOMBIECLASS_HUNTER) SetEntityRenderColor(attacker, GetConVarInt(InfectedTier3Color[0]), GetConVarInt(InfectedTier3Color[1]), GetConVarInt(InfectedTier3Color[2]), 255);
				else SetEntityRenderColor(attacker, GetConVarInt(InfectedTier3Color[0]), GetConVarInt(InfectedTier3Color[1]), GetConVarInt(InfectedTier3Color[2]), 100);
			}
			else if (	((Class == ZOMBIECLASS_HUNTER && AIHunter[2] >= GetConVarInt(InfectedTier2Level)))	|| 
					((Class == ZOMBIECLASS_SMOKER && AISmoker[2] >= GetConVarInt(InfectedTier2Level)))	|| 
					((Class == ZOMBIECLASS_BOOMER && AIBoomer[2] >= GetConVarInt(InfectedTier2Level)))	|| 
					((Class == ZOMBIECLASS_JOCKEY && AIJockey[2] >= GetConVarInt(InfectedTier2Level)))	|| 
					((Class == ZOMBIECLASS_CHARGER && AICharger[2] >= GetConVarInt(InfectedTier2Level)))	|| 
					((Class == ZOMBIECLASS_SPITTER && AISpitter[2] >= GetConVarInt(InfectedTier2Level)))	)
			{
				if (!IsPlayerAlive(attacker)) return;
				SetEntityRenderMode(attacker, RENDER_TRANSCOLOR);
				if (Class != ZOMBIECLASS_HUNTER) SetEntityRenderColor(attacker, GetConVarInt(InfectedTier2Color[0]), GetConVarInt(InfectedTier2Color[1]), GetConVarInt(InfectedTier2Color[2]), 255);
				else SetEntityRenderColor(attacker, GetConVarInt(InfectedTier2Color[0]), GetConVarInt(InfectedTier2Color[1]), GetConVarInt(InfectedTier2Color[2]), 150);
			}
		}
		
		if (Class == ZOMBIECLASS_HUNTER)
		{
			if (!IsPlayerAlive(attacker)) return;
			ClassHunter[attacker] = true;
			if (!IsFakeClient(attacker)) SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(HealthPerLevel) * Hu[attacker][2])));
			else SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(HealthPerLevel) * AIHunter[2])));
		}
		else ClassHunter[attacker] = false;
		if (Class == ZOMBIECLASS_SMOKER)
		{
			if (!IsPlayerAlive(attacker)) return;
			ClassSmoker[attacker] = true;
			if (!IsFakeClient(attacker)) SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(HealthPerLevel) * Sm[attacker][2])));
			else SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(HealthPerLevel) * AISmoker[2])));
		}
		else ClassSmoker[attacker] = false;
		if (Class == ZOMBIECLASS_BOOMER)
		{
			if (!IsPlayerAlive(attacker)) return;
			ClassBoomer[attacker] = true;
			if (!IsFakeClient(attacker)) SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(HealthPerLevel) * Bo[attacker][2])));
			else SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(HealthPerLevel) * AIBoomer[2])));
		}
		else ClassBoomer[attacker] = false;
		if (Class == ZOMBIECLASS_JOCKEY)
		{
			if (!IsPlayerAlive(attacker)) return;
			ClassJockey[attacker] = true;
			if (!IsFakeClient(attacker)) SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(HealthPerLevel) * Jo[attacker][2])));
			else SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(HealthPerLevel) * AIJockey[2])));
		}
		else ClassJockey[attacker] = false;
		if (Class == ZOMBIECLASS_CHARGER)
		{
			if (!IsPlayerAlive(attacker)) return;
			ClassCharger[attacker] = true;
			if (!IsFakeClient(attacker)) SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(HealthPerLevel) * Ch[attacker][2])));
			else SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(HealthPerLevel) * AICharger[2])));
		}
		else ClassCharger[attacker] = false;
		if (Class == ZOMBIECLASS_SPITTER)
		{
			if (!IsPlayerAlive(attacker)) return;
			ClassSpitter[attacker] = true;
			if (!IsFakeClient(attacker)) SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(HealthPerLevel) * Sp[attacker][2])));
			else SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(HealthPerLevel) * AISpitter[2])));
		}
		else ClassSpitter[attacker] = false;
		ClassTank[attacker] = false;
	}
	else
	{
		ClassTank[attacker] = true;
		if ((!IsFakeClient(attacker) && Ta[attacker][2] >= GetConVarInt(InfectedTier4Level)) || 
			(IsFakeClient(attacker) && AITank[2] >= GetConVarInt(InfectedTier4Level)))
		{
			if (!IsPlayerAlive(attacker)) return;
			SetEntityRenderMode(attacker, RENDER_TRANSCOLOR);
			SetEntityRenderColor(attacker, GetConVarInt(InfectedTier4Color[0]), GetConVarInt(InfectedTier4Color[1]), GetConVarInt(InfectedTier4Color[2]), 200);
		}
		else if ((!IsFakeClient(attacker) && Ta[attacker][2] >= GetConVarInt(InfectedTier3Level)) || 
				(IsFakeClient(attacker) && AITank[2] >= GetConVarInt(InfectedTier3Level)))
		{
			if (!IsPlayerAlive(attacker)) return;
			SetEntityRenderMode(attacker, RENDER_TRANSCOLOR);
			SetEntityRenderColor(attacker, GetConVarInt(InfectedTier3Color[0]), GetConVarInt(InfectedTier3Color[1]), GetConVarInt(InfectedTier3Color[2]), 235);
		}
		else if ((!IsFakeClient(attacker) && Ta[attacker][2] >= GetConVarInt(InfectedTier2Level)) || 
				(IsFakeClient(attacker) && AITank[2] >= GetConVarInt(InfectedTier2Level)))
		{
			if (!IsPlayerAlive(attacker)) return;
			SetEntityRenderMode(attacker, RENDER_TRANSCOLOR);
			SetEntityRenderColor(attacker, GetConVarInt(InfectedTier2Color[0]), GetConVarInt(InfectedTier2Color[1]), GetConVarInt(InfectedTier2Color[2]), 255);
		}
		if (IsPlayerAlive(attacker) && !IsFakeClient(attacker))
		{
			SetEntityHealth(attacker, (GetConVarInt(TankDefaultHealth) * GetConVarInt(SurvivorCount)) + (GetConVarInt(PhysicalHealthPerLevel) * In[attacker][2]) + (GetConVarInt(TankHealthPerLevel) * Ta[attacker][2]));
		}
		else if (IsPlayerAlive(attacker) && IsFakeClient(attacker))
		{
			//SetEntityHealth(attacker, (GetConVarInt(TankDefaultHealth) * GetConVarInt(SurvivorCount)) + (GetConVarInt(PhysicalHealthPerLevel) * AIInfected[2]) + (GetConVarInt(TankHealthPerLevel) * AITank[2]) + (GetConVarInt(TankHealthTimesSurvivorLimit) * GetConVarInt(SurvivorCount)));
		}
	}

	// Need to change how speeds work, maybe?


	if (IsClientIndexOutOfRange(attacker)) return;
	if (!IsClientInGame(attacker) || GetClientTeam(attacker) != 3 || !IsPlayerAlive(attacker)) return;

	if (!IsFakeClient(attacker))
	{
		SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(PhysicalHealthPerLevel) * In[attacker][2])));
		if (!ClassTank[attacker]) PlayerMovementSpeed[attacker] = GetConVarFloat(PlayerMovementSpeedBase_NotTank) + (In[attacker][2] * GetConVarFloat(SpeedPerLevel));
		else PlayerMovementSpeed[attacker] = GetConVarFloat(PlayerMovementSpeedBase_Tank) + (In[attacker][2] * GetConVarFloat(SpeedPerLevel));
		if (IsPlayerAlive(attacker)) SetEntDataFloat(attacker, laggedMovementOffset, PlayerMovementSpeed[attacker], true);

		// Set custom gravity.
		if (In[attacker][2] <= 70) SetEntityGravity(attacker, 1.0 - (0.01 * In[attacker][2]));
		else SetEntityGravity(attacker, 0.30);
	}
	else
	{
		SetEntityHealth(attacker, GetClientHealth(attacker) + RoundToFloor((GetConVarFloat(PhysicalHealthPerLevel) * AIInfected[2])));
		// AI Tanks get an additional boost.
		if (ClassTank[attacker]) SetEntityHealth(attacker, GetClientHealth(attacker) + GetConVarInt(TankHealthTimesSurvivorLimit) * GetConVarInt(SurvivorCount));
		if (!ClassTank[attacker]) PlayerMovementSpeed[attacker] = GetConVarFloat(PlayerMovementSpeedBase_NotTank) + (AIInfected[2] * GetConVarFloat(SpeedPerLevel));
		else PlayerMovementSpeed[attacker] = GetConVarFloat(PlayerMovementSpeedBase_Tank) + (AIInfected[2] * GetConVarFloat(SpeedPerLevel));
		if (IsPlayerAlive(attacker)) SetEntDataFloat(attacker, laggedMovementOffset, PlayerMovementSpeed[attacker], true);

		// Set custom gravity.
		if (AIInfected[2] <= 70) SetEntityGravity(attacker, 1.0 - (0.01 * AIInfected[2]));
		else SetEntityGravity(attacker, 0.30);
	}
}