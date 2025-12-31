_SmokerEvents_OnPluginStart()
{
	HookEvent("tongue_grab", Event_TongueGrab);
	HookEvent("tongue_release", Event_TongueRelease);
	HookEvent("tongue_pull_stopped", Event_TonguePullStopped);
	HookEvent("choke_start", Event_ChokeStart);
	HookEvent("choke_stopped", Event_TonguePullStopped);
}

/*			SMOKER EVENTS			*/

public Action:Event_TongueGrab(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));
	if (IsClientIndexOutOfRange(attacker) || !IsClientInGame(attacker)) return;
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker)) IsSmoking[attacker] = true;
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim))
	{
		// Just in case they have gravity boots - set their gravity to normal
		SetEntityGravity(victim, 1.0);
		Ensnared[victim] = true;
		SmokeVictim[attacker] = victim;
		GetClientAbsOrigin(victim, StartSmokeLocation[victim]);
	
		decl Float:EnsnareValue;
		EnsnareValue = SurvivorMultiplier[victim] * GetConVarFloat(SurvivorEnsnareValue);
		if (showpoints[attacker] == 1 && !IsFakeClient(attacker)) PrintToChat(attacker, "%s \x01Survivor Ensnared: \x04%3.3f \x01Point(s).", POINTS_INFO, EnsnareValue);
		if (IsFakeClient(attacker)) InfectedPoints[attacker] += (EnsnareValue * GetConVarFloat(InfectedBotHandicap));
		else InfectedPoints[attacker] += EnsnareValue;

		experience_increase(attacker, RoundToFloor(EnsnareValue));

		if (AISmoker[2] >= GetConVarInt(InfectedTier3Level) && IsFakeClient(attacker))
		{
			CreateTimer(3.0, Timer_BotSmokerWhip, attacker, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	
	// Set the ensnare value if a survivor bot, so survivor bot doesn't use heal for no reason.
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && IsFakeClient(victim))
	{
		Ensnared[victim] = true;
	}
}

public Action:Timer_BotSmokerWhip(Handle:timer, any:bot)
{
	if (IsClientIndexOutOfRange(bot) || !IsClientInGame(bot) || !IsPlayerAlive(bot)) return Plugin_Stop;
	new victim = SmokeVictim[bot];
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim) || !IsPlayerAlive(victim) || Ensnared[victim] == false) return Plugin_Stop;
	CallSmokerWhip(bot);
	return Plugin_Continue;
}

public Action:Event_TongueRelease(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));
	if (IsHuman(attacker)) IsSmoking[attacker] = false;
	if (IsHuman(victim))
	{
		Ensnared[victim] = false;
		
		new Float:EndSmokeLocation[3];
		GetClientAbsOrigin(victim, EndSmokeLocation);
		decl Float:SmokeDistance;
		SmokeDistance = GetVectorDistance(StartSmokeLocation[victim], EndSmokeLocation);
		SmokeDistance *= GetConVarFloat(SmokeDistanceMultiplier);
		
		if (showpoints[attacker] == 1 && !IsFakeClient(attacker)) PrintToChat(attacker, "%s \x01Smoke Distance: \x04%3.3f \x01Point(s).", POINTS_INFO, SmokeDistance);
		if (IsFakeClient(attacker)) InfectedPoints[attacker] += (SmokeDistance * GetConVarFloat(InfectedBotHandicap));
		else InfectedPoints[attacker] += SmokeDistance;

		experience_increase(attacker, RoundToFloor(SmokeDistance));
	}
	if (IsHuman(victim)) Ensnared[victim] = false;

	// Set the ensnare value if a survivor bot, so survivor bot doesn't use heal for no reason.
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && IsFakeClient(victim))
	{
		Ensnared[victim] = false;
	}
}

public Action:Event_ChokeStart(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker)) IsSmoking[attacker] = true;
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim)) Ensnared[victim] = true;
}

public Action:Event_TonguePullStopped(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new savior = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));
	new smoker = GetClientOfUserId(GetEventInt(event, "smoker"));
	
	if (!IsClientIndexOutOfRange(smoker) && IsClientInGame(smoker) && !IsFakeClient(smoker)) IsSmoking[smoker] = false;
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim)) Ensnared[victim] = false;
	new type = GetEventInt(event, "release_type");
	if (type != 4 && type != 2) return;
	if (IsHuman(savior) && GetClientTeam(savior) == 2)
	{
		SurvivorPoints[savior] += SurvivorMultiplier[savior] * GetConVarFloat(SaveSurvivorPoints);
		if (showpoints[savior] == 1) PrintToChat(savior, "%s \x01Save Survivor: \x03%3.3f \x01Point(s).", POINTS_INFO, SurvivorMultiplier[savior] * GetConVarFloat(SaveSurvivorPoints));
		experience_medical_increase(savior, RoundToFloor((SurvivorMultiplier[savior] * GetConVarFloat(SaveSurvivorPoints))));

		RoundRescuer[savior] += RoundToFloor(SurvivorMultiplier[savior] * GetConVarFloat(SaveSurvivorPoints));
		if (RoundRescuer[savior] > BestRescuer[0])
		{
			BestRescuer[0] = RoundRescuer[savior];
			BestRescuer[1] = savior;
		}
	}
}