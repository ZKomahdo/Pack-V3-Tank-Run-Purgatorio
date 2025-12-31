_BoomerEvents_OnPluginStart()
{
	HookEvent("player_now_it", Event_PlayerNowIt);
}

/*			BOOMER TAGS PLAYER EVENT - SETTING UP BOOMER POINTS			*/

public Action:Event_PlayerNowIt(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (IsClientIndexOutOfRange(attacker) || !IsClientInGame(attacker) || (IsFakeClient(attacker) && GetClientTeam(attacker) == 2)) return;
	new victim = GetClientOfUserId(GetEventInt(event, "userid"));
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim) || IsFakeClient(victim)) return;
	// Just in case they have gravity boots - set their gravity to normal
	SetEntityGravity(victim, 1.0);
	if (GetClientTeam(attacker) == 2)
	{
		// The player tagged someone with a vomit jar. Give grenade experience if they have vomitjar unlocked.
		if (Gr[attacker][2] >= GetConVarInt(GrenJarLevel))
		{
			if (Ph[attacker][2] < In[victim][2]) experience_explosion_increase(attacker, 1 + (GetConVarInt(LevelDifferencePoints) * (In[victim][2] - Ph[attacker][2])));
			else experience_explosion_increase(attacker, 1);
		}
		return;		// If the attacker was Survivor, we DON'T want to instate the boomer upgrade (slow bile) etc.
	}
	if (SurvivorMultiplier[victim] < 1.0) SurvivorMultiplier[victim] = 1.0;
	WhoWasBoomer[victim] = attacker;
	CoveredInBile[victim] = true;
	CreateTimer(GetConVarFloat(BoomerPointsTime), RewardBoomerPoints, victim, TIMER_FLAG_NO_MAPCHANGE);
	if ((!IsFakeClient(attacker) && (UpgradeBoomer[attacker] || Bo[attacker][2] >= GetConVarInt(InfectedTier2Level))) || 
		(IsFakeClient(attacker) && AIBoomer[2] >= GetConVarInt(InfectedTier2Level)))
	{
		if (EyeGoggles[victim] > 0)
		{
			new number = GetRandomInt(GetConVarInt(PersonalAbilityLossMin), GetConVarInt(PersonalAbilityLossMax));
			EyeGoggles[victim] -= number;
			if (EyeGoggles[victim] < 1)
			{
				PrintToChat(victim, "%s \x01Your Eye Goggles' crack, so you throw them away.", INFO);
				EyeGoggles[victim] = 0;
			}
		}
		else if (!BlindAmmoImmune[victim])
		{
			BlindAmmoImmune[victim] = true;
			BlindPlayer(victim, GetConVarInt(BlindAmount));
			if (!IsFakeClient(attacker)) CreateTimer(GetConVarFloat(BlindAmmoTime) + (GetConVarFloat(BlindBilePerLevel) * Bo[attacker][2]), RemoveBlindAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
			else CreateTimer(GetConVarFloat(BlindAmmoTime) + (GetConVarFloat(BlindBilePerLevel) * AIBoomer[2]), RemoveBlindAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
			if (!IsFakeClient(attacker))
			{
				if (Bo[attacker][2] >= GetConVarInt(InfectedTier3Level) && !SpitterImmune[victim] && !BrokenLegs[victim])
				{
					SpitterImmune[victim] = true;
					if (IsPlayerAlive(victim)) SetEntDataFloat(victim, laggedMovementOffset, GetConVarFloat(StickyBileSpeed) - (GetConVarFloat(BoomerSlowPerLevel) * Bo[attacker][2]), true);
					CreateTimer(GetConVarFloat(StickyBileTime) + (GetConVarFloat(StickyBilePerLevel) * Bo[attacker][2]), RemoveStickySpit, victim);
				}
			}
			else
			{
				if (AIBoomer[2] >= GetConVarInt(InfectedTier3Level) && !SpitterImmune[victim] && !BrokenLegs[victim])
				{
					SpitterImmune[victim] = true;
					if (IsPlayerAlive(victim)) SetEntDataFloat(victim, laggedMovementOffset, GetConVarFloat(StickyBileSpeed) - (GetConVarFloat(BoomerSlowPerLevel) * AIBoomer[2]), true);
					CreateTimer(GetConVarFloat(StickyBileTime) + (GetConVarFloat(StickyBilePerLevel) * AIBoomer[2]), RemoveStickySpit, victim);
				}
			}
		}
	}
	new bool:exploded = GetEventBool(event, "exploded");
	decl pointEarn;
	decl levelDifference;
	levelDifference = (Ph[victim][2] - In[attacker][2]) * GetConVarInt(LevelDifferencePoints);
	if (!exploded)
	{
		if (showpoints[attacker] == 1 && !IsFakeClient(attacker)) PrintToChat(attacker, "%s \x01Vomitted on \x03%N \x01for \x05%3.3f \x01Point(s).", POINTS_INFO, victim, SurvivorMultiplier[victim] * GetConVarFloat(BoomerBilePoints));
		InfectedPoints[attacker] += (SurvivorMultiplier[victim] * GetConVarFloat(BoomerBilePoints));
		pointEarn = RoundToFloor((SurvivorMultiplier[victim] * GetConVarFloat(BoomerBilePoints)));
		if (pointEarn + levelDifference > 0) experience_increase(attacker, pointEarn + levelDifference);
		else experience_increase(attacker, pointEarn);
	}
	else
	{
		if (showpoints[attacker] == 1 && !IsFakeClient(attacker)) PrintToChat(attacker, "%s \x01Exploded on \x03%N \x01for \x05%3.3f \x01Point(s).", POINTS_INFO, victim, SurvivorMultiplier[victim] * GetConVarFloat(BoomerBlowPoints));
		InfectedPoints[attacker] += (SurvivorMultiplier[victim] * GetConVarFloat(BoomerBlowPoints));
		pointEarn = RoundToFloor((SurvivorMultiplier[victim] * GetConVarFloat(BoomerBlowPoints)));
		if (pointEarn + levelDifference > 0) experience_increase(attacker, pointEarn + levelDifference);
		else experience_increase(attacker, pointEarn);
	}
}