public Events_SurvivorStart()
{
	HookEvent("heal_success", Event_HealSuccess);
	HookEvent("heal_begin", Event_HealBegin);
	HookEvent("revive_success", Event_ReviveSuccess);
	HookEvent("adrenaline_used", Event_AdrenalineUsed);
	HookEvent("pills_used", Event_PillsUsed);
}

public Action:Event_HealSuccess(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));
	new subject						= GetClientOfUserId(GetEventInt(event, "subject"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_SURVIVORS && 
		!IsClientIndexOutOfRange(subject) && IsClientInGame(subject) && !IsFakeClient(subject) && GetClientTeam(subject) == TEAM_SURVIVORS)
	{
		playerPoints[attacker][0] += (GetConVarFloat(Enhancement_Helper) * survivorMultiplier[attacker]);
		if (GetConVarInt(PointsNotice) == 1) PrintToChat(attacker, "%s - \x01Helped a teammate: \x05%3.2f Point(s).", INFO_GENERAL, GetConVarFloat(Enhancement_Helper) * survivorMultiplier[attacker]);

		// Determine the amount of meds to remove from the medpack

		new healthRestored = GetEventInt(event, "health_restored");
		if (healthRestored >= meds[attacker])
		{
			if (difference[subject] + meds[attacker] > 100) SetEntityHealth(subject, 100);
			meds[attacker] = 0;
		}
		else if (healthRestored < meds[attacker])
		{
			meds[attacker] -= healthRestored;
			if (GetConVarInt(InfoNotice) == 1) PrintToChat(attacker, "%s - \x01Used \x05%d meds\x01, have \x05%d remaining.", INFO_GENERAL, healthRestored, meds[attacker]);
			ExecCheatCommand(attacker, "give", "first_aid_kit");
		}
		if (attacker != subject)
		{
			// we give the player a HOT if they didn't heal themselves. it's stackable.
			CreateTimer(1.0, Timer_MedicalHOT, attacker, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public Action:Event_HealBegin(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));
	new subject						= GetClientOfUserId(GetEventInt(event, "subject"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_SURVIVORS && 
		!IsClientIndexOutOfRange(subject) && IsClientInGame(subject) && !IsFakeClient(subject) && GetClientTeam(subject) == TEAM_SURVIVORS)
	{
		if (meds[attacker] < 1 || meds[attacker] > GetConVarInt(Value_MedsAmount)) meds[attacker] = GetConVarInt(Value_MedsAmount);
		difference[subject] = GetClientHealth(subject);
	}
}

public Action:Event_ReviveSuccess(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));
	new subject						= GetClientOfUserId(GetEventInt(event, "subject"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_SURVIVORS && 
		!IsClientIndexOutOfRange(subject) && IsClientInGame(subject) && !IsFakeClient(subject) && GetClientTeam(subject) == TEAM_SURVIVORS)
	{
		playerPoints[attacker][0] += (GetConVarFloat(Enhancement_Helper) * survivorMultiplier[attacker]);
		if (GetConVarInt(PointsNotice) == 1) PrintToChat(attacker, "%s - \x01Helped a teammate: \x05%3.2f Point(s).", INFO_GENERAL, GetConVarFloat(Enhancement_Helper) * survivorMultiplier[attacker]);
	}
}

public Action:Event_AdrenalineUsed(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_SURVIVORS && !adrenalineJunkie[attacker])
	{
		if (GetConVarInt(InfoNotice) == 1) PrintToChat(attacker, "%s - \x01You feel spontaneous and crazy. Damage increase by \x05%3.2fx \x01for \x05%3.2f sec(s).", INFO_GENERAL, GetConVarFloat(Ability_AdrenalineUse), GetConVarFloat(Ability_AdrenalineTime));
		adrenalineJunkie[attacker] = true;
		CreateTimer(GetConVarFloat(Ability_AdrenalineTime), Timer_RemoveAdrenalineUser, attacker, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action:Event_PillsUsed(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "subject"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_SURVIVORS && !pillsJunkie[attacker])
	{
		if (GetConVarInt(InfoNotice) == 1) PrintToChat(attacker, "%s - \x01Phil's Pills take the edge off a little. Damage decreased by \x05%3.2fx \x01for \x05%3.2f sec(s).", INFO_GENERAL, GetConVarFloat(Ability_PillsUse), GetConVarFloat(Ability_PillsTime));
		pillsJunkie[attacker] = true;
		CreateTimer(GetConVarFloat(Ability_PillsTime), Timer_RemovePillsUser, attacker, TIMER_FLAG_NO_MAPCHANGE);
	}
}