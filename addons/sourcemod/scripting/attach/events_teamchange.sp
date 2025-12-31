public Events_TeamChange()
{
	HookEvent("player_team", Event_PlayerTeam);
}

public Action:Event_PlayerTeam(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client							= GetClientOfUserId(GetEventInt(event, "userid"));
	if (!IsClientIndexOutOfRange(client) && IsClientInGame(client) && !IsFakeClient(client))
	{
		ResetPlayerStatistics(client);
	}
}

public ResetPlayerStatistics(client)
{
	SetEntDataFloat(client, laggedMovementOffset, 1.0, true);
	playerPoints[client][0]									= 0.0;
	playerPoints[client][1]									= 0.0;
	incapProtection[client]									= 0;
	bloatAmmo[client]										= 0;
	blindAmmo[client]										= 0;
	slowmoAmmo[client]										= 0;
	beanbagAmmo[client]										= 0;
	spatialAmmo[client]										= 0;
	respawnType[client]										= 0;
	survivorMultiplier[client]								= GetConVarFloat(Multiplier_Start);
	survivorCommon[client]									= 0;
	survivorCommonGoal[client]								= GetConVarInt(Multiplier_CommonStart);
	survivorTeamCommon										= 0;
	survivorTeamCommonGoal									= GetConVarInt(Multiplier_TeamCommonStart);
	survivorSpecial[client]									= 0;
	survivorSpecialGoal[client]								= GetConVarInt(Multiplier_SpecialStart);
	survivorTeamSpecial										= 0;
	survivorTeamSpecialGoal									= GetConVarInt(Multiplier_TeamSpecialStart);
	survivorHeadshot[client]								= 0;
	survivorHeadshotGoal[client]							= GetConVarInt(Multiplier_HeadshotStart);
	survivorTeamHeadshot									= 0;
	survivorTeamHeadshotGoal								= GetConVarInt(Multiplier_TeamHeadshotStart);
	locationSaved[client]									= false;
	totalDamage[client]										= 0;
	classTank[client]										= false;

	bloatImmune[client]										= false;
	blindImmune[client]										= false;
	slowmoImmune[client]									= false;
	beanbagImmune[client]									= false;
	spatialImmune[client]									= false;

	classHunter[client]										= false;
	classSmoker[client]										= false;
	classBoomer[client]										= false;
	classJockey[client]										= false;
	classCharger[client]									= false;
	classSpitter[client]									= false;
	classTank[client]										= false;

	meds[client]											= 0;
	difference[client]										= 0;
	adrenalineJunkie[client]								= false;
	pillsJunkie[client]										= false;
	drugUses[client]										= 0;
	permaDeath[client]										= false;

	bilePoints[client]										= 0.0;
	bileCovered[client]										= false;

	ensnared[client]										= false;

	bRiding[client]											= false;
	bBerserk[client]										= false;
	bCharging[client]										= false;
	isSmoking[client]										= false;
	smokerVictim[client]									= -1;
	bSlow[client]											= false;
	bJumping[client]										= false;
	chargeVictim[client]									= -1;
	bJumpCooldown[client]									= false;
	ridePoints[client]										= 0;

	SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);

	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i)) continue;
		damageDealt[client][i] = 0;
	}
}