public ReadyUpEnd_RemoveItems()
{
	new EntCount						= GetEntityCount();
	new String:EdictName[256];

	for (new i = 0; i <= EntCount; i++)
	{
		if (!IsValidEntity(i) || !IsValidEdict(i)) continue;
		GetEdictClassname(i, EdictName, sizeof(EdictName));

		if (StrContains(EdictName, "defib", false) != -1)
		{
			if (!AcceptEntityInput(i, "Kill")) RemoveEdict(i);
		}
	}
}

public ReadyUpEnd_ResetStatistics()
{
	teamPoints[0]											= 0.0;
	teamPoints[1]											= 0.0;

	respawnTimer											= GetConVarInt(Timer_RespawnCounter);

	summonZombieCooldown									= 0.0;
	uncommonRemaining										= 0;
	uncommonType											= 0;
	uncommonPanicEvent										= false;
	commonBodyArmour										= GetConVarFloat(Value_CommonBodyArmour);
	bInfectedCloak											= false;
	bSpawnAnywhere											= false;
	bWallOfFire												= false;
	bCommonMeleeImmune										= false;
	bCommonFireImmune										= false;
	bSpecialFireImmune										= false;
	bSteelTongue											= false;
	bSmokerWhip												= false;
	bNoSurvivorGlow											= false;
	bWitchStrength											= false;
	bJockeyJump												= false;
	bJockeyBerserk											= false;
	bJockeyBlind											= false;
	bJockeyControl											= false;
	bBlindingBile											= false;
	bUnstableBoomer											= false;
	bSlowingBile											= false;
	tongueRange												= GetConVarInt(Value_TongueRangeStart);
	commonLimit												= GetConVarInt(Value_CommonLimitStart);
	SetConVarInt(FindConVar("z_common_limit"), commonLimit);
	spawnTimer												= GetConVarInt(Value_SpawnTimerStart);
	SetConVarInt(FindConVar("z_ghost_delay_min"), spawnTimer);
	SetConVarInt(FindConVar("z_ghost_delay_max"), spawnTimer);
	bChargerJump											= false;
	chargeVolley											= GetConVarInt(Value_ChargeVolleyStart);
	spitProtectionTime										= GetConVarFloat(Value_SpitProtectionStart);
	spitSlowTime											= GetConVarFloat(Value_SpitSlowStart);
	spitSlowAmount											= GetConVarFloat(Value_SpitSlowAmountStart);
	chargeSpeed												= GetConVarFloat(Value_ChargeSpeedStart);
	tankLimit												= GetConVarInt(Value_TankLimitStart);
	tankUPS													= GetConVarFloat(Value_TankSpeedStart);
	tankHealth												= GetConVarInt(Value_TankHealthStart);
	witchLimit												= GetConVarInt(Value_WitchStart);
	witchUPS												= GetConVarInt(Value_WitchSpeedStart);
	SIHealth												= GetConVarInt(Value_SIHealthStart);
	deepFreezeAmount										= GetConVarInt(Value_DeepFreezeStart);
	deepFreezeCooldown										= false;
	SetConVarInt(FindConVar("z_witch_speed"), witchUPS);
	SetConVarInt(FindConVar("sv_disable_glow_survivors"), 0);
	SetConVarInt(FindConVar("z_witch_always_kills"), 0);
	SetConVarInt(FindConVar("tongue_range"), GetConVarInt(Value_TongueRangeStart));
	SetConVarFloat(FindConVar("z_jockey_control_variance"), 0.7);
	SetConVarInt(FindConVar("tongue_break_from_damage_amount"), 50);
	witchCount												= 0;
	tankCount												= 0;
	rescueVehicleHasArrived									= false;
	tankRestriction											= false;
	tankRestrictionTime										= 0.0;

	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i)) continue;
		SetEntDataFloat(i, laggedMovementOffset, 1.0, true);
		playerPoints[i][0]									= 0.0;
		playerPoints[i][1]									= 0.0;
		incapProtection[i]									= 0;
		bloatAmmo[i]										= 0;
		blindAmmo[i]										= 0;
		slowmoAmmo[i]										= 0;
		beanbagAmmo[i]										= 0;
		spatialAmmo[i]										= 0;
		respawnType[i]										= 0;
		survivorMultiplier[i]								= GetConVarFloat(Multiplier_Start);
		survivorCommon[i]									= 0;
		survivorCommonGoal[i]								= GetConVarInt(Multiplier_CommonStart);
		survivorTeamCommon									= 0;
		survivorTeamCommonGoal								= GetConVarInt(Multiplier_TeamCommonStart);
		survivorSpecial[i]									= 0;
		survivorSpecialGoal[i]								= GetConVarInt(Multiplier_SpecialStart);
		survivorTeamSpecial									= 0;
		survivorTeamSpecialGoal								= GetConVarInt(Multiplier_TeamSpecialStart);
		survivorHeadshot[i]									= 0;
		survivorHeadshotGoal[i]								= GetConVarInt(Multiplier_HeadshotStart);
		survivorTeamHeadshot								= 0;
		survivorTeamHeadshotGoal							= GetConVarInt(Multiplier_TeamHeadshotStart);
		locationSaved[i]									= false;
		totalDamage[i]										= 0;
		classTank[i]										= false;

		bloatImmune[i]										= false;
		blindImmune[i]										= false;
		slowmoImmune[i]										= false;
		beanbagImmune[i]									= false;
		spatialImmune[i]									= false;

		classHunter[i]										= false;
		classSmoker[i]										= false;
		classBoomer[i]										= false;
		classJockey[i]										= false;
		classCharger[i]										= false;
		classSpitter[i]										= false;
		classTank[i]										= false;

		meds[i]												= 0;
		difference[i]										= 0;
		adrenalineJunkie[i]									= false;
		pillsJunkie[i]										= false;
		drugUses[i]											= 0;
		permaDeath[i]										= false;

		bilePoints[i]										= 0.0;
		bileCovered[i]										= false;

		ensnared[i]											= false;

		bRiding[i]											= false;
		bBerserk[i]											= false;
		bCharging[i]										= false;
		isSmoking[i]										= false;
		smokerVictim[i]										= -1;
		bSlow[i]											= false;
		bJumping[i]											= false;
		chargeVictim[i]										= -1;
		bJumpCooldown[i]									= false;
		ridePoints[i]										= 0;

		SetEntProp(i, Prop_Data, "m_takedamage", 2, 1);
		SDKHook(i, SDKHook_OnTakeDamage, OnTakeDamage);

		for (new ii = 1; ii <= MaxClients; ii++)
		{
			if (IsClientIndexOutOfRange(ii) || !IsClientInGame(ii) || IsFakeClient(ii)) continue;
			damageDealt[i][ii] = 0;
		}
	}
}