_JockeyEvents_OnPluginStart()
{
	HookEvent("jockey_ride", Event_JockeyRide);
	HookEvent("jockey_ride_end", Event_JockeyRideEnd);
}

/*			JOCKEY EVENTS			*/

public Action:Event_JockeyRide(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim))
	{
		Ensnared[victim] = true;
		JockeyRidingMe[victim] = attacker;
	}
	// Just in case they have gravity boots - set their gravity to normal
	SetEntityGravity(victim, 1.0);
	if (IsClientIndexOutOfRange(attacker) || !IsClientInGame(attacker)) return;
	JockeyVictim[attacker] = victim;
	IsRiding[attacker] = true;
	if (IsFakeClient(attacker))
	{
		if (AIJockey[2] >= GetConVarInt(InfectedTier3Level)) CreateTimer(3.0, Timer_BotJockeyJump, attacker, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		if (AIJockey[2] >= GetConVarInt(InfectedTier4Level))
		{
			JockeyRideBlind[victim] = true;
			BlindPlayer(victim, GetConVarInt(BlindAmount));
		}
		return;
	}
	if (JockeyJumping[attacker])
	{
		JockeyJumping[attacker] = false;
		new Float:EndingJockeyLocation[3];
		GetClientAbsOrigin(attacker, EndingJockeyLocation);
		new Float:JockeyDistance = GetVectorDistance(StartingJockeyLocation[attacker], EndingJockeyLocation);
		JockeyDistance *= GetConVarFloat(JockeyDistanceMultiplier);
		
		if (showpoints[attacker] == 1) PrintToChat(attacker, "%s \x01Jump Distance: \x04%3.3f \x01Point(s).", POINTS_INFO, JockeyDistance);
		InfectedPoints[attacker] += JockeyDistance;
		
		if (JockeyDistance >= 2.0) experience_increase(attacker, RoundToFloor(JockeyDistance/2.0));
		else experience_increase(attacker, RoundToFloor(JockeyDistance));
	}
	if (Jo[attacker][2] >= GetConVarInt(InfectedTier4Level))
	{
		JockeyRideBlind[victim] = true;
		BlindPlayer(victim, GetConVarInt(BlindAmount));
	}
	JockeyRideBonus[attacker] = GetTime();
}

public Action:Event_JockeyRideEnd(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));
	if (IsHuman(victim))
	{
		BlindPlayer(victim, 0);
		Ensnared[victim] = false;
		new attacker = JockeyRidingMe[victim];
		if (IsHuman(attacker))
		{
			JockeyRideBonus[attacker] = GetTime() - JockeyRideBonus[attacker];
			if (showpoints[attacker] == 1) PrintToChat(attacker, "%s \x01Ride Bonus: \x04%d \x01Point(s).", POINTS_INFO, JockeyRideBonus[attacker]);
			InfectedPoints[attacker] += JockeyRideBonus[attacker];
			IsRiding[attacker] = false;
			CreateTimer(0.1, CheckForIncap, victim, TIMER_FLAG_NO_MAPCHANGE);
			experience_increase(attacker, JockeyRideBonus[attacker]);
		}
	}
	new savior = GetClientOfUserId(GetEventInt(event, "rescuer"));
	if (IsHuman(savior))
	{
		SurvivorPoints[savior] += SurvivorMultiplier[savior] * GetConVarFloat(SaveSurvivorPoints);
		if (showpoints[savior] == 1) PrintToChat(savior, "%s \x01Save Survivor: \x03%3.3f \x01Point(s).", POINTS_INFO, SurvivorMultiplier[savior] * GetConVarFloat(SaveSurvivorPoints));
		experience_medical_increase(savior, RoundToFloor(SurvivorMultiplier[savior] * GetConVarFloat(SaveSurvivorPoints)));
		
		RoundRescuer[savior] += RoundToFloor(SurvivorMultiplier[savior] * GetConVarFloat(SaveSurvivorPoints));
		if (RoundRescuer[savior] > BestRescuer[0])
		{
			BestRescuer[0] = RoundRescuer[savior];
			BestRescuer[1] = savior;
		}
	}
}

public Action:CheckForIncap(Handle:timer, any:victim)
{
	if (!IsHuman(victim) || !IsIncapacitated(victim)) return Plugin_Stop;
	new attacker = JockeyRidingMe[victim];
	if (!IsHuman(attacker)) return Plugin_Stop;
	new Class = GetEntProp(attacker, Prop_Send, "m_zombieClass");
	if (Class != ZOMBIECLASS_JOCKEY) return Plugin_Stop;

	if (!BerserkerKill[attacker] && (Jo[attacker][2] >= GetConVarInt(InfectedTier2Level) || UpgradeJockey[attacker]))
	{
		if (JockeyRideBonus[attacker] >= GetConVarInt(BerserkRideTime))
		{
			BerserkerKill[attacker] = true;
			if (IsPlayerAlive(victim)) ForcePlayerSuicide(victim);
			PrintToChatAll("%s \x04%N \x01'\x04berserks, \x01instantly killing \x03%N\x01.", INFO, attacker, victim);
			JockeyRideBonus[attacker] = 0;
		}
	}
	return Plugin_Stop;
}

public Action:Timer_BotJockeyJump(Handle:timer, any:bot)
{
	if (IsClientIndexOutOfRange(bot) || !IsClientInGame(bot) || !IsPlayerAlive(bot)) return Plugin_Stop;
	new victim = JockeyVictim[bot];
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim) || !IsPlayerAlive(victim) || Ensnared[victim] == false) return Plugin_Stop;
	new Float:vel;
	vel = GetEntPropFloat(bot, Prop_Send, "m_vecVelocity[2]");
	if (vel > 0.0) return Plugin_Continue;
	CallJockeyJump(bot);
	return Plugin_Continue;
}