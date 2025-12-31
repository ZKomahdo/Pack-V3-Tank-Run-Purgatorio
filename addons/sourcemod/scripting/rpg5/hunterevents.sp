_HunterEvents_OnPluginStart()
{
	HookEvent("lunge_pounce", Event_LungePounce);
	HookEvent("pounce_stopped", Event_PounceStopped);
}

/*			HUNTER EVENTS			*/

public Action:Event_LungePounce(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	if (IsClientIndexOutOfRange(attacker) || !IsClientInGame(attacker)) return;
	new Float:EndPounceLocation[3];
	GetClientAbsOrigin(attacker, EndPounceLocation);
	
	new Float:PounceDistance = GetVectorDistance(StartPounceLocation[attacker], EndPounceLocation);
	PounceDistance *= GetConVarFloat(HunterDistanceMultiplier);
	if (PounceDistance < 1.0) PounceDistance = 1.0;
	
	if (IsFakeClient(attacker)) InfectedPoints[attacker] += (PounceDistance * GetConVarFloat(InfectedBotHandicap));
	else InfectedPoints[attacker] += PounceDistance;
	if (showpoints[attacker] == 1 && !IsFakeClient(attacker)) PrintToChat(attacker, "%s \x01Pounce Distance: \x04%3.3f \x01Point(s).", POINTS_INFO, PounceDistance);
	if (PounceDistance >= 2.0) experience_increase(attacker, RoundToFloor(PounceDistance/2.0));
	else experience_increase(attacker, RoundToFloor(PounceDistance));

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

	// Check if the pounce qualifies for the daily quest.
	if (PounceDistance >= GetConVarFloat(Achievement[4][2]))
	{
		if (Ach[attacker][4] < GetConVarInt(Achievement[4][0])) AchievementCheck(attacker, 4);
	}
	
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));
	// Set the ensnare value if a survivor bot, so survivor bot doesn't use heal for no reason.
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim)) return;
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && IsFakeClient(victim))
	{
		Ensnared[victim] = true;
		return;
	}
	if (!IsPlayerAlive(victim)) return;
	// Just in case they have gravity boots - set their gravity to normal
	SetEntityGravity(victim, 1.0);
	if (SuperUpgradeHunter[attacker] || 
		(!IsFakeClient(attacker) && Hu[attacker][2] >= GetConVarInt(InfectedTier3Level)) || 
		(IsFakeClient(attacker) && AIHunter[2] >= GetConVarInt(InfectedTier2Level)))
	{
		// Super hunter! Make the player invisible with the hunter
		// And remove his glow. lol
		L4D2_SetPlayerSurvivorGlowState(victim, false);
		SetEntityRenderMode(victim, RENDER_TRANSCOLOR)
		if (IsBlackWhite[victim] && VipName != victim)
		{
			SetEntityRenderColor(victim, GetConVarInt(BlackWhiteColor[0]), GetConVarInt(BlackWhiteColor[1]), GetConVarInt(BlackWhiteColor[2]), 150);
		}
		else
		{
			if (VipName == victim) SetEntityRenderColor(victim, GetConVarInt(VipColor[0]), GetConVarInt(VipColor[1]), GetConVarInt(VipColor[2]), 150);
			else SetEntityRenderColor(victim, 255, 255, 255, 150);
		}
	}
	Ensnared[victim] = true;
	Hunter[victim] = attacker;
}

public Action:Event_PounceStopped(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new savior = GetClientOfUserId(GetEventInt(event, "userid"));
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
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));
	// Set the ensnare value if a survivor bot, so survivor bot doesn't use heal for no reason.
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && IsFakeClient(victim))
	{
		Ensnared[victim] = false;
		return;
	}
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim)) return;
	Ensnared[victim] = false;
	if (!IsPlayerAlive(victim)) return;
	L4D2_SetPlayerSurvivorGlowState(victim, true);
	if (IsPlayerAlive(victim)) SetEntityRenderMode(victim, RENDER_NORMAL);
	if (IsBlackWhite[victim])
	{
		if (IsPlayerAlive(victim))
		{
			if (VipName == victim) SetEntityRenderColor(victim, GetConVarInt(VipColor[0]), GetConVarInt(VipColor[1]), GetConVarInt(VipColor[2]), 200);
			else SetEntityRenderColor(victim, GetConVarInt(BlackWhiteColor[0]), GetConVarInt(BlackWhiteColor[1]), GetConVarInt(BlackWhiteColor[2]), 255);
		}
	}
	else
	{
		if (IsPlayerAlive(victim))
		{
			if (VipName == victim) SetEntityRenderColor(victim, GetConVarInt(VipColor[0]), GetConVarInt(VipColor[1]), GetConVarInt(VipColor[2]), 255);
			else SetEntityRenderColor(victim, 255, 255, 255, 255);
		}
	}
}

FindHunterVictim(attacker)
{
	new victim = 0;
	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsHuman(i)) continue;
		if (Hunter[i] != attacker) continue;
		victim = Hunter[i];
		break;
	}
	if (victim == 0 || !IsClientInGame(victim)) return;
	Ensnared[victim] = false;
	if (!IsPlayerAlive(victim)) return;
	new hunter = Hunter[victim];
	if (!IsClientIndexOutOfRange(hunter) && IsClientInGame(hunter) && !IsFakeClient(hunter) && SuperUpgradeHunter[hunter])
	{
		L4D2_SetPlayerSurvivorGlowState(victim, true);
		if (IsPlayerAlive(victim)) SetEntityRenderMode(victim, RENDER_NORMAL);
		if (IsBlackWhite[victim])
		{
			if (IsPlayerAlive(victim))
			{
				if (VipName == victim) SetEntityRenderColor(victim, GetConVarInt(VipColor[0]), GetConVarInt(VipColor[1]), GetConVarInt(VipColor[2]), 200);
				else SetEntityRenderColor(victim, GetConVarInt(BlackWhiteColor[0]), GetConVarInt(BlackWhiteColor[1]), GetConVarInt(BlackWhiteColor[2]), 255);
			}
		}
		else
		{
			if (IsPlayerAlive(victim))
			{
				if (VipName == victim) SetEntityRenderColor(victim, GetConVarInt(VipColor[0]), GetConVarInt(VipColor[1]), GetConVarInt(VipColor[2]), 255);
				else SetEntityRenderColor(victim, 255, 255, 255, 255);
			}
		}
	}
}