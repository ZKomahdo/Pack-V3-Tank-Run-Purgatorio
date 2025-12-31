_ResetVariables_OnPluginStart()
{
	HookEvent("round_end", Event_RoundEnd);
	HookEvent("round_start", Event_RoundStart);
	HookEvent("player_team", Event_PlayerTeam);
	HookEvent("spawner_give_item", Event_SpawnerGiveItem);

	HookEvent("finale_win", Event_FinaleWin);

	HookEvent("mission_lost", Event_MapTransition);
	HookEvent("map_transition", Event_MapTransition);

	RegConsoleCmd("up", Trigger_MainMenu);
	RegConsoleCmd("buy", Trigger_MainMenu);
	RegConsoleCmd("usepoints", Trigger_MainMenu);
	RegAdminCmd("reload", Trigger_ReloadPlugin, ADMFLAG_KICK);
	RegConsoleCmd("micro", Trigger_Micro);
	RegConsoleCmd("hidepoints", Trigger_HidePoints);
	RegConsoleCmd("preset", Trigger_LoadPreset);
}

public Action:Trigger_LoadPreset(client, args)
{
	if (GetClientTeam(client) != 2) return Plugin_Handled;
	if (args < 1)
	{
		PrintToChat(client, "%s \x01Syntax: [preset] [value]", INFO);
		return Plugin_Handled;
	}
	decl String:arg[16];
	GetCmdArg(1, arg, sizeof(arg));
	if (StringToInt(arg) == 1)
	{
		PresetViewer[client] = 0;
		LoadPresets(client);
	}
	else if (StringToInt(arg) == 2)
	{
		PresetViewer[client] = 1;
		LoadPresets(client);
	}
	else if (StringToInt(arg) == 3)
	{
		PresetViewer[client] = 2;
		LoadPresets(client);
	}
	else if (StringToInt(arg) == 4)
	{
		PresetViewer[client] = 3;
		LoadPresets(client);
	}
	else if (StringToInt(arg) == 5)
	{
		PresetViewer[client] = 4;
		LoadPresets(client);
	}
	return Plugin_Handled;
}

public Action:Trigger_Micro(client, args)
{
	if (showinfo[client] == 1)
	{
		showinfo[client] = 0;
		PrintToChat(client, "%s \x01Minimal menu and game information will be displayed to you.", INFO);
	}
	else
	{
		showinfo[client] = 1;
		PrintToChat(client, "%s \x01All menu and game information will be displayed to you.", INFO);
	}
	return Plugin_Handled;
}

public Action:Trigger_HidePoints(client, args)
{
	if (showpoints[client] == 1)
	{
		showpoints[client] = 0;
		PrintToChat(client, "%s \x01Point earning will no longer show to you.", INFO);
	}
	else
	{
		showpoints[client] = 1;
		PrintToChat(client, "%s \x01Point earning will now show to you.", INFO);
	}
	return Plugin_Handled;
}

public Action:Trigger_ReloadPlugin(client, args)
{
	ResetEverything();
	PrintToChatAll("\x04Usepoints\x055\x04 reloaded.");
}

public Event_SpawnerGiveItem(Handle:event, const String:name[], bool:dontBroadcast)
{
	new ent = GetEventInt(event, "spawner");
	if (IsValidEdict(ent)) RemoveEdict(ent);
}

public Action:Event_FinaleWin(Handle:event, String:event_name[], bool:dontBroadcast)
{
	decl String:GameTypeCurrent[128];
	GetConVarString(FindConVar("mp_gamemode"), GameTypeCurrent, 128);
	if (StrEqual(GameTypeCurrent, "versus")) return;
	RoundEndCount = 3;
	RoundEnd();
}

public Action:Event_PlayerTeam(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client)) return;
	bGhostSwap[client] = false;
	MiniGun[client] = -1;
	WaitBeforeUses[client] = false;
	MiniGunUse[client] = false;
	showpoints[client] = true;
	InJump[client] = false;
	BlindAmmoImmune[client] = false;
	PlayerMovementSpeed[client] = 1.0;
	HurtAward[client] = 0.0;
	SurvivorMultiplier[client] = 1.0;
	LastWeaponOwned[client] = "none";
	bIcedByTank[client] = false;

	XPMultiplierTimer[client] = false;
		
	/*		SURVIVOR RESETS		*/
	RespawnCount[client] = 0;
	IncapProtection[client] = 0;
	HealCount[client] = GetConVarInt(HealSupply);
	TempHealCount[client] = GetConVarInt(TempHealSupply);
	GrenadeCount[client] = GetConVarInt(GrenadeSupply);
	SurvivorMultiplier[client] = 1.0;
	SurvivorPoints[client] = 0.0;
	Meds[client] = 0;
	Difference[client] = 0;
	CoveredInBile[client] = false;
	BoomerActionPoints[client] = 0.0;
	BlindAmmo[client] = 0;
	BloatAmmo[client] = 0;
	IceAmmo[client] = 0;
	HealAmmo[client] = 0;
	Scout[client] = false;
	Ensnared[client] = false;
	IncapDisabled[client] = false;
	M60CD[client] = false;

	JockeyRideTime[client] = 0;
		
	SurvivorHeadshotValue[client] = 0;
	SurvivorSpecialValue[client] = 0;
	SurvivorCommonValue[client] = 0;
	SurvivorPistolValue[client] = 0;
	SurvivorMeleeValue[client] = 0;
	SurvivorSmgValue[client] = 0;
	SurvivorShotgunValue[client] = 0;
	SurvivorRifleValue[client] = 0;
	SurvivorSniperValue[client] = 0;
		
	SurvivorHeadshotGoal[client] = GetConVarInt(SurvivorHeadshotStart);
	SurvivorSpecialGoal[client] = GetConVarInt(SurvivorSpecialStart);
	SurvivorCommonGoal[client] = GetConVarInt(SurvivorCommonStart);
	SurvivorPistolGoal[client] = GetConVarInt(SurvivorPistolStart);
	SurvivorMeleeGoal[client] = GetConVarInt(SurvivorMeleeStart);
	SurvivorSmgGoal[client] = GetConVarInt(SurvivorSmgStart);
	SurvivorShotgunGoal[client] = GetConVarInt(SurvivorShotgunStart);
	SurvivorRifleGoal[client] = GetConVarInt(SurvivorRifleStart);
	SurvivorSniperGoal[client] = GetConVarInt(SurvivorSniperStart);
	
	BloatAmmoPistol[client] = false;
	BlindAmmoPistol[client] = false;
	IceAmmoPistol[client] = false;
	HealAmmoPistol[client] = false;
	BeanBagAmmoPistol[client] = false;
	BloatAmmoAmountPistol[client] = 0;
	BlindAmmoAmountPistol[client] = 0;
	IceAmmoAmountPistol[client] = 0;
	HealAmmoAmountPistol[client] = 0;
	BeanBagAmmoAmountPistol[client] = 0;

	BloatAmmoSmg[client] = false;
	BlindAmmoSmg[client] = false;
	IceAmmoSmg[client] = false;
	HealAmmoSmg[client] = false;
	BeanBagAmmoSmg[client] = false;
	BloatAmmoAmountSmg[client] = 0;
	BlindAmmoAmountSmg[client] = 0;
	IceAmmoAmountSmg[client] = 0;
	HealAmmoAmountSmg[client] = 0;
	BeanBagAmmoAmountSmg[client] = 0;

	BloatAmmoShotgun[client] = false;
	BlindAmmoShotgun[client] = false;
	IceAmmoShotgun[client] = false;
	HealAmmoShotgun[client] = false;
	BeanBagAmmoShotgun[client] = false;
	BloatAmmoAmountShotgun[client] = 0;
	BlindAmmoAmountShotgun[client] = 0;
	IceAmmoAmountShotgun[client] = 0;
	HealAmmoAmountShotgun[client] = 0;
	BeanBagAmmoAmountShotgun[client] = 0;

	BloatAmmoRifle[client] = false;
	BlindAmmoRifle[client] = false;
	IceAmmoRifle[client] = false;
	HealAmmoRifle[client] = false;
	BeanBagAmmoRifle[client] = false;
	BloatAmmoAmountRifle[client] = 0;
	BlindAmmoAmountRifle[client] = 0;
	IceAmmoAmountRifle[client] = 0;
	HealAmmoAmountRifle[client] = 0;
	BeanBagAmmoAmountRifle[client] = 0;

	BloatAmmoSniper[client] = false;
	BlindAmmoSniper[client] = false;
	IceAmmoSniper[client] = false;
	HealAmmoSniper[client] = false;
	BeanBagAmmoSniper[client] = false;
	BloatAmmoAmountSniper[client] = 0;
	BlindAmmoAmountSniper[client] = 0;
	IceAmmoAmountSniper[client] = 0;
	HealAmmoAmountSniper[client] = 0;
	BeanBagAmmoAmountSniper[client] = 0;
	
	SurvivorTeamPurchase[client] = false;
	Tier2Cost[client] = GetConVarFloat(Tier2StartCost);
	HealthItemCost[client] = GetConVarFloat(HealthItemStartCost);
	PersonalAbilitiesCost[client] = GetConVarFloat(PersonalAbilitiesStartCost);
	WeaponUpgradeCost[client] = GetConVarFloat(WeaponUpgradeStartCost);
	
	HazmatBoots[client] = 0;
	EyeGoggles[client] = 0;
	GravityBoots[client] = 0;
	RespawnType[client] = 0;
	PlayerMovementSpeed[client] = 1.0;
	RoundKills[client] = 0;
	RoundDamage[client] = 0;

	OnDrugs[client] = false;
	DrugsUsed[client] = 0;
	DrugEffect[client] = false;
	DrugTimer[client] = -1.0;
	JockeyRideBlind[client] = false;

	/*		INFECTED RESETS		*/

	ChargerJumpCooldown[client] = false;
	SufferingFromBloatAmmo[client] = false;
	ChargerCanJump[client] = false;
	ChargerIsJumping[client] = false;
	BeanBagAmmoImmune[client] = false;
	InfectedPoints[client] = 0.0;
	BerserkerKill[client] = false;
	ClassHunter[client] = false;
	ClassSmoker[client] = false;
	ClassBoomer[client] = false;
	ClassJockey[client] = false;
	ClassCharger[client] = false;
	ClassSpitter[client] = false;
	ClassTank[client] = false;
	UpgradeHunter[client] = false;
	UpgradeSmoker[client] = false;
	UpgradeBoomer[client] = false;
	UpgradeJockey[client] = false;
	UpgradeCharger[client] = false;
	UpgradeSpitter[client] = false;
	SuperUpgradeHunter[client] = false;
	SuperUpgradeSmoker[client] = false;
	SuperUpgradeBoomer[client] = false;
	SuperUpgradeJockey[client] = false;
	SuperUpgradeCharger[client] = false;
	SuperUpgradeSpitter[client] = false;
	BloatAmmoImmune[client] = false;
	IceAmmoImmune[client] = false;
	SpitterImmune[client] = false;
	JockeyJumping[client] = false;
	IsSmoking[client] = false;
	RoundHealing[client] = 0;
	SpecialPurchaseValue[client] = GetConVarFloat(SpecialPurchaseStart);
	TankPurchaseValue[client] = GetConVarFloat(TankPurchaseStart);
	UncommonPurchaseValue[client] = GetConVarFloat(UncommonPurchaseStart);
	TeamUpgradesPurchaseValue[client] = GetConVarFloat(TeamUpgradesPurchaseStart);
	PersonalUpgradesPurchaseValue[client] = GetConVarFloat(PersonalUpgradesPurchaseStart);
	
	PersonalUpgrades[client] = 0;
	SpawnAnywhere[client] = false;
	WallOfFire[client] = false;
	SmokerWhipCooldown[client] = false;
	IsRiding[client] = false;
	IsSmoking[client] = false;
	JockeyJumpCooldown[client] = false;
	
	RoundHS[client] = 0;
	RoundSurvivorDamage[client] = 0;
	LocationSaved[client] = false;
	FireTankImmune[client] = false;

	HealAmmoDisabled[client] = false;

	InfectedGhost[client] = true;
	BrokenLegs[client] = false;
	HeavyBySpit[client] = false;

	RoundRescuer[client] = 0;
	
	SetEntityGravity(client, 1.0);
	// We check, to make sure the player didn't switch teams after earning XP.
	// If we don't check and we load, they lose everything when they switch teams, and
	// are put back at what they had last.
	/*
	decl String:clientName[256];
	GetClientName(client, clientName, sizeof(clientName));
	if (StrContains(clientName, "`", false) > -1 || StrContains(clientName, "'", false) > -1)
	{
		PrintToChat(client, "%s \x01your name contains \x04` \x01or \x04' \x01characters. Will not save or load data.", ERROR_INFO);
		return;
	}
	if (Ph[client][0] < 1 || PhysicalNextLevel[client] < 1 || 
		InfectedLevel[client] < 1 || InfectedNextLevel[client] < 1)
	{
		LoadData(client);
	}
	*/
	if (XPMultiplierTime[client] > 0 && !XPMultiplierTimer[client])
	{
		XPMultiplierTimer[client] = true;
		CreateTimer(1.0, DeductMultiplierTime, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action:Event_RoundStart(Handle:event, String:event_name[], bool:dontBroadcast)
{
	RoundStart();
}

public Action:Event_RoundEnd(Handle:event, String:event_name[], bool:dontBroadcast)
{
	RoundEndCount++;
	RoundEnd();
}

public Action:Event_MapTransition(Handle:event, String:event_name[], bool:dontBroadcast)
{
	decl String:GameTypeCurrent[128];
	GetConVarString(FindConVar("mp_gamemode"), GameTypeCurrent, 128);
	if (StrEqual(GameTypeCurrent, "versus")) return;
	RoundEndCount = 3;
	RoundEnd();
}

RoundStart()
{
	ResetEverything();
}

RoundEnd()
{
	_cmdModule_RoundEnd();
	// For the database thing.
	new String:WinnerName[256];
	if (RoundEndCount == 1 || RoundEndCount == 3)
	{
		RoundReset = true;

		new randomCat = 0;

		// Award Players on each team their bonus values
		if (TeamSurvivorAmount > 0)
		{
			randomCat = GetRandomInt(1, 8);
			new String:randomCatName[256];
			if (randomCat == 1) Format(randomCatName, sizeof(randomCatName), "Pistol Experience");
			else if (randomCat == 2) Format(randomCatName, sizeof(randomCatName), "Melee Experience");
			else if (randomCat == 3) Format(randomCatName, sizeof(randomCatName), "Uzi Experience");
			else if (randomCat == 4) Format(randomCatName, sizeof(randomCatName), "Shotgun Experience");
			else if (randomCat == 5) Format(randomCatName, sizeof(randomCatName), "Sniper Experience");
			else if (randomCat == 6) Format(randomCatName, sizeof(randomCatName), "Rifle Experience");
			else if (randomCat == 7) Format(randomCatName, sizeof(randomCatName), "Grenade Experience");
			else if (randomCat == 8) Format(randomCatName, sizeof(randomCatName), "Item Experience");
			PrintToSurvivors("%s \x03Survivor Team Bonus: \x05%d \x01Physical and %s", BONUS_INFO, TeamSurvivorAmount, randomCatName);
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 2) continue;
				if (randomCat == 1) Pi[i][0] += TeamSurvivorAmount;
				else if (randomCat == 2) Pi[i][0] += TeamSurvivorAmount;
				else if (randomCat == 3) Me[i][0] += TeamSurvivorAmount;
				else if (randomCat == 4) Uz[i][0] += TeamSurvivorAmount;
				else if (randomCat == 5) Sh[i][0] += TeamSurvivorAmount;
				else if (randomCat == 6) Ri[i][0] += TeamSurvivorAmount;
				else if (randomCat == 7) Gr[i][0] += TeamSurvivorAmount;
				else if (randomCat == 8) It[i][0] += TeamSurvivorAmount;

				Ph[i][0] += TeamSurvivorAmount;
			}
			TeamSurvivorAmount = 0;
		}

		if (TeamInfectedAmount > 0)
		{
			randomCat = GetRandomInt(1, 7);
			new String:randomCatName[256];
			if (randomCat == 1) Format(randomCatName, sizeof(randomCatName), "Hunter Experience");
			else if (randomCat == 2) Format(randomCatName, sizeof(randomCatName), "Smoker Experience");
			else if (randomCat == 3) Format(randomCatName, sizeof(randomCatName), "Boomer Experience");
			else if (randomCat == 4) Format(randomCatName, sizeof(randomCatName), "Jockey Experience");
			else if (randomCat == 5) Format(randomCatName, sizeof(randomCatName), "Charger Experience");
			else if (randomCat == 6) Format(randomCatName, sizeof(randomCatName), "Spitter Experience");
			else if (randomCat == 7) Format(randomCatName, sizeof(randomCatName), "Tank Experience");
			PrintToInfected("%s \x04Infected Team Bonus: \x05%d \x01Infected and %s", BONUS_INFO, TeamInfectedAmount, randomCatName);
			for (new i = 1; i <= MaxClients; i++)
			{
				if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 3) continue;
				if (randomCat == 1) Hu[i][0] += TeamInfectedAmount;
				else if (randomCat == 2) Sm[i][0] += TeamInfectedAmount;
				else if (randomCat == 3) Bo[i][0] += TeamInfectedAmount;
				else if (randomCat == 4) Jo[i][0] += TeamInfectedAmount;
				else if (randomCat == 5) Ch[i][0] += TeamInfectedAmount;
				else if (randomCat == 6) Sp[i][0] += TeamInfectedAmount;
				else if (randomCat == 7) Ta[i][0] += TeamInfectedAmount;

				In[i][0] += TeamInfectedAmount;
			}
			TeamInfectedAmount = 0;
		}

		if (!IsClientIndexOutOfRange(VipName) && IsClientInGame(VipName) && !IsFakeClient(VipName) && GetClientTeam(VipName) == 2)
		{
			if (IsPlayerAlive(VipName) && !IsIncapacitated(VipName))
			{
				SetEntityRenderMode(VipName, RENDER_NORMAL);
				SetEntityRenderColor(VipName, 255, 255, 255, 255);
				PrintToChatAll("%s \x01The VIP \x03Survived\x01! Survivors earn \x03%d \x01XP!", INFO, VipExperience);
				for (new i = 1; i <= MaxClients; i++)
				{
					if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 2) continue;
					Ph[i][0] += VipExperience;
				}
			}
			else
			{
				if (!IsPlayerAlive(VipName)) PrintToChatAll("%s \x01The VIP \x04Was Killed\x01! Infected earn \x04%d \x01XP!", INFO, VipExperience);
				else if (IsIncapacitated(VipName)) PrintToChatAll("%s \x01The VIP \x04Was Mortally Wounded\x01! Infected earn \x04%d \x01XP!", INFO, VipExperience);
				else PrintToChatAll("%s \x01The VIP \x04Tried to Cheat Death\x01! Infected earn \x04%d \x01XP!", INFO, VipExperience);
				for (new i = 1; i <= MaxClients; i++)
				{
					if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 3) continue;
					In[i][0] += VipExperience;
				}
			}
		}
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || GetClientTeam(i) != 3 || HurtAward[i] < 1.0) continue;
			if (!IsFakeClient(i))
			{
				if (HunterHurtAward[i] > 0.0) Hu[i][0] += RoundToFloor(HunterHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (SmokerHurtAward[i] > 0.0) Sm[i][0] += RoundToFloor(SmokerHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (BoomerHurtAward[i] > 0.0) Bo[i][0] += RoundToFloor(BoomerHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (JockeyHurtAward[i] > 0.0) Jo[i][0] += RoundToFloor(JockeyHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (ChargerHurtAward[i] > 0.0) Ch[i][0] += RoundToFloor(ChargerHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (SpitterHurtAward[i] > 0.0) Sp[i][0] += RoundToFloor(SpitterHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (TankHurtAward[i] > 0.0) Ta[i][0] += RoundToFloor(TankHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (HurtAward[i] > 0.0) In[i][0] += RoundToFloor(HurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
			}
			else
			{
				if (HunterHurtAward[i] > 0.0) AIHunter[0] += RoundToFloor(HunterHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (SmokerHurtAward[i] > 0.0) AISmoker[0] += RoundToFloor(SmokerHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (BoomerHurtAward[i] > 0.0) AIBoomer[0] += RoundToFloor(BoomerHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (JockeyHurtAward[i] > 0.0) AIJockey[0] += RoundToFloor(JockeyHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (ChargerHurtAward[i] > 0.0) AICharger[0] += RoundToFloor(ChargerHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (SpitterHurtAward[i] > 0.0) AISpitter[0] += RoundToFloor(SpitterHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (TankHurtAward[i] > 0.0) AITank[0] += RoundToFloor(TankHurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
				if (HurtAward[i] > 0.0) AIInfected[0] += RoundToFloor(HurtAward[i] * GetConVarFloat(HurtAwardInfectedXP));
			}
			HunterHurtAward[i] = 0.0;
			SmokerHurtAward[i] = 0.0;
			BoomerHurtAward[i] = 0.0;
			JockeyHurtAward[i] = 0.0;
			ChargerHurtAward[i] = 0.0;
			SpitterHurtAward[i] = 0.0;
			TankHurtAward[i] = 0.0;
			HurtAward[i] = 0.0;
			experience_increase(i, 0);
		}

		SaveDirectorData();
		if (BestKills[0] > MapBestKills && 
			!IsClientIndexOutOfRange(BestKills[1]) && 
			IsClientInGame(BestKills[1]) && 
			!IsFakeClient(BestKills[1]))
		{
			PrintToSurvivors("%s \x03%N \x01broke the \x03Survivor Infected Kills Record\x01: \x03%d \x01for \x03%d \x01Physical XP!", INFO, BestKills[1], BestKills[0], RoundToFloor(BestKills[0] * GetConVarFloat(MapKillsXPEach)));
			Ph[BestKills[1]][0] += RoundToFloor(BestKills[0] * GetConVarFloat(MapKillsXPEach));
			experience_increase(BestKills[1], 0);
			
			MapBestKills = BestKills[0];
			GetClientName(BestKills[1], WinnerName, sizeof(WinnerName));
			MapBestKillsName = WinnerName;
			BestKills[0] = 0;
		}
		
		if (BestSurvivorDamage[0] > MapBestSurvivorDamage && 
			!IsClientIndexOutOfRange(BestSurvivorDamage[1]) && 
			IsClientInGame(BestSurvivorDamage[1]) && 
			!IsFakeClient(BestSurvivorDamage[1]))
		{
			PrintToSurvivors("%s \x03%N \x01broke the \x03Survivor Damage Map Record\x01: \x03%d \x01for \x03%d \x01Physical XP!", INFO, BestSurvivorDamage[1], BestSurvivorDamage[0], RoundToFloor(BestSurvivorDamage[0] * GetConVarFloat(MapSurvivorDamageXPEach)));
			Ph[BestSurvivorDamage[1]][0] += RoundToFloor(BestSurvivorDamage[0] * GetConVarFloat(MapSurvivorDamageXPEach));
			experience_increase(BestSurvivorDamage[1], 0);
			
			MapBestSurvivorDamage = BestSurvivorDamage[0];
			GetClientName(BestSurvivorDamage[1], WinnerName, sizeof(WinnerName));
			MapBestSurvivorDamageName = WinnerName;
			BestSurvivorDamage[0] = 0;
		}
		if (BestSurvivorHS[0] > MapBestSurvivorHS && 
			!IsClientIndexOutOfRange(BestSurvivorHS[1]) && 
			IsClientInGame(BestSurvivorHS[1]) && 
			!IsFakeClient(BestSurvivorHS[1]))
		{
			PrintToSurvivors("%s \x03%N \x01broke the \x03Survivor Headshot Map Record\x01: \x03%d \x01for \x03%d \x01Physical XP!", INFO, BestSurvivorHS[1], BestSurvivorHS[0], RoundToFloor(BestSurvivorHS[0] * GetConVarFloat(MapHSXPEach)));
			Ph[BestSurvivorHS[1]][0] += RoundToFloor(BestSurvivorHS[0] * GetConVarFloat(MapHSXPEach));
			experience_increase(BestSurvivorHS[1], 0);
			
			MapBestSurvivorHS = BestSurvivorHS[0];
			GetClientName(BestSurvivorHS[1], WinnerName, sizeof(WinnerName));
			MapBestSurvivorHSName = WinnerName;
			BestSurvivorHS[0] = 0;
		}
		if (MapBestDamage[0] > MapBestInfectedDamage && 
			!IsClientIndexOutOfRange(MapBestDamage[1]) && 
			IsClientInGame(MapBestDamage[1]) && 
			!IsFakeClient(MapBestDamage[1]))
		{
			PrintToInfected("%s \x04%N \x01broke the \x04Infected Damage Map Record\x01: \x04%d \x01for \x04%d \x01Infected XP!", INFO, MapBestDamage[1], MapBestDamage[0], RoundToFloor(MapBestInfectedDamage * GetConVarFloat(MapDamageXPEach)));
			In[MapBestDamage[1]][0] += RoundToFloor(MapBestInfectedDamage * GetConVarFloat(MapDamageXPEach));
			experience_increase(MapBestDamage[1], 0);
			
			MapBestInfectedDamage = MapBestDamage[0];
			GetClientName(MapBestDamage[1], WinnerName, sizeof(WinnerName));
			MapBestInfectedDamageName = WinnerName;
			MapBestDamage[0] = 0;
		}
		if (BestHealing[0] > MapBestHealing && 
			!IsClientIndexOutOfRange(BestHealing[1]) && 
			IsClientInGame(BestHealing[1]) && 
			!IsFakeClient(BestHealing[1]))
		{
			PrintToSurvivors("%s \x03%N \x01broke the \x03Medic Healing Record\x01: \x03%d \x01for \x03%d \x01Physical XP!", INFO, BestHealing[1], BestHealing[0], RoundToFloor(MapBestHealing * GetConVarFloat(MapHealingXPEach)));
			Ph[BestHealing[1]][0] += RoundToFloor(MapBestHealing * GetConVarFloat(MapHealingXPEach));
			experience_increase(BestHealing[1], 0);
			
			MapBestHealing = BestHealing[0];
			GetClientName(BestHealing[1], WinnerName, sizeof(WinnerName));
			MapBestHealingName = WinnerName;
			BestHealing[0] = 0;
		}
		if (BestRescuer[0] > MapBestRescuer && 
			IsHuman(BestRescuer[1]))
		{
			PrintToSurvivors("%s \x03%N \x01broke the \x03Survivor Savior Record\x01: \x03%d \x01for \x03%d \x01Physical XP!", INFO, BestRescuer[1], BestRescuer[0], RoundToFloor(MapBestRescuer * GetConVarFloat(MapRescuerXPEach)));
			Ph[BestRescuer[1]][0] += RoundToFloor(MapBestRescuer * GetConVarFloat(MapRescuerXPEach));
			experience_increase(BestRescuer[1], 0);
			
			MapBestRescuer = BestRescuer[0];
			GetClientName(BestRescuer[1], WinnerName, sizeof(WinnerName));
			MapBestRescuerName = WinnerName;
			BestRescuer[0] = 0;
		}


		decl String:clientName[256];
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsClientIndexOutOfRange(i) || !IsClientInGame(i) || IsFakeClient(i)) continue;
			GetClientName(i, clientName, sizeof(clientName));
			if (StrContains(clientName, "`", false) > -1 || StrContains(clientName, "'", false) > -1)
			{
				PrintToChat(i, "%s \x01your name contains \x04` \x01or \x04' \x01characters. Will not save or load data.", ERROR_INFO);
				continue;
			}
			if (Ph[i][2] > 1 || Ph[i][1] > 1 || 
				In[i][2] > 1 || In[i][1] > 1)
			{
				SaveData(i);
			}
			else continue;
		}
		PrintToChatAll("%s \x04Player Data has been automatically saved.", INFO);


		Save_MapRecords();
		BestKills[0] = 0;
		MapBestDamage[0] = 0;
		BestSurvivorDamage[0] = 0;
		BestSurvivorHS[0] = 0;
		BestHealing[0] = 0;
		BestRescuer[0] = 0;
		ResetEverything();
	}
}

ClearDefibs()
{
	new EntCount = GetEntityCount();
	new String:EdictName[256];
	for (new i = 0; i <= EntCount; i++)
	{
		if (!IsValidEntity(i)) continue;
		if (!IsValidEdict(i)) continue;
		GetEdictClassname(i, EdictName, sizeof(EdictName));
		if (StrContains(EdictName, "defib", false) != -1)
		{
			if (!AcceptEntityInput(i, "Kill")) RemoveEdict(i);
		}
	}
}

ClearMapEntities()
{
	// Remove all weapons and items when ready up ends.
	new EntCount = GetEntityCount();
	new String:EdictName[256];
	for (new i = 0; i <= EntCount; i++)
	{
		if (!IsValidEntity(i)) continue;
		if (!IsValidEdict(i)) continue;
		GetEdictClassname(i, EdictName, sizeof(EdictName));
		if (StrContains(EdictName, "molotov", false) != -1 || 
			StrContains(EdictName, "pipe_bomb", false) != -1 || 
			StrContains(EdictName, "defib", false) != -1 || 
			StrContains(EdictName, "vomitjar", false) != -1 || 
			StrContains(EdictName, "launcher", false) != -1 || 
			StrContains(EdictName, "first_aid", false) != -1 || 
			StrContains(EdictName, "pills", false) != -1 || 
			StrContains(EdictName, "adrenaline", false) != -1 || 
			StrContains(EdictName, "chainsaw", false) != -1)
		{
			if (!AcceptEntityInput(i, "Kill")) RemoveEdict(i);
		}
	}
	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 2 || MiniGun[i] == -1) continue;
		if (MiniGun[i] != -1)
		{
			AcceptEntityInput(MiniGun[i], "Kill");
			MiniGun[i] = -1;
		}
	}
}

ResetEverything()
{
	ClearMapEntities();
	/*			SURVIVOR TEAM RESETS		*/
	SurvivorTeamPoints = 0.0;
	
	/*			INFECTED TEAM RESETS		*/

	witchCount = 0;
	witchMax = GetConVarInt(WitchMaximumDefault);

	DirectorPoints = 0.0;
	InfectedTeamPoints = 0.0;
	TankCooldownTime = 0.0;
	TankCount = 0;
	TankLimit = GetConVarInt(TankLimitStart);
	TeamSpecialValue = 0;
	TeamCommonValue = 0;
	TeamSpecialGoal = GetConVarInt(SurvivorTeamSpecialStart);
	TeamCommonGoal = GetConVarInt(SurvivorTeamCommonStart);
	Format(LastUncommon, sizeof(LastUncommon), "none");
	UncommonType = 0;
	UncommonRemaining = 0;
	UncommonPanicEventCount = -1.0;
	
	bCommonMeleeImmune = false;
	bCommonFireImmune = false;
	RescueCalled = false;

	commonBodyArmour = 0.0;
	moreCommonsAmount = GetConVarInt(CommonLimitNormal);
	wanderingCommonsAmount = GetConVarInt(WanderingCommonsStart);

	SetConVarInt(FindConVar("z_reserved_wanderers"), GetConVarInt(WanderingCommonsStart));
	SetConVarInt(FindConVar("sv_disable_glow_faritems"), 0);
	SetConVarInt(FindConVar("z_head_damage_causes_wounds"), 0);
	SetConVarInt(FindConVar("z_use_next_difficulty_damage_factor"), 0);
	SetConVarInt(FindConVar("z_common_limit"), GetConVarInt(CommonLimitNormal));
	CommonHeadshots = false;
	SetConVarFloat(FindConVar("z_non_head_damage_factor_multiplier"), 1.0);
	SetConVarInt(FindConVar("z_ghost_delay_min"), GetConVarInt(SpawnTimerStart));
	SetConVarInt(FindConVar("z_ghost_delay_max"), GetConVarInt(SpawnTimerStart));
	SpawnTimer = GetConVarInt(SpawnTimerStart);
	DeepFreezeAmount = 0;
	TankLimit = GetConVarInt(TankLimitStart);
	SteelTongue = false;
	SurvivorRealism = false;
	UncommonCooldown = false;
	UncommonCooldownCount = 0.0;
	DeepFreezeCooldown = false;
	BestKills[0] = 0;
	MapBestDamage[0] = 0;

	TUpgrade_CarryJump = false;
	
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientIndexOutOfRange(i) || !IsClientInGame(i)) continue;
		SDKUnhook(i, SDKHook_OnTakeDamage, OnTakeDamage);
		bGhostSwap[i] = false;
		bIcedByTank[i] = false;
		RoundHealing[i] = 0;
		showpoints[i] = true;
		InJump[i] = false;
		BlindAmmoImmune[i] = false;
		PlayerMovementSpeed[i] = 1.0;
		HurtAward[i] = 0.0;
		SurvivorMultiplier[i] = 1.0;
		FireTankImmune[i] = false;
		LastWeaponOwned[i] = "none";

		XPMultiplierTimer[i] = false;
		
		/*		SURVIVOR RESETS		*/
		RespawnCount[i] = 0;
		IncapProtection[i] = 0;
		HealCount[i] = GetConVarInt(HealSupply);
		TempHealCount[i] = GetConVarInt(TempHealSupply);
		GrenadeCount[i] = GetConVarInt(GrenadeSupply);
		SurvivorMultiplier[i] = 1.0;
		SurvivorPoints[i] = 0.0;
		Meds[i] = 0;
		Difference[i] = 0;
		CoveredInBile[i] = false;
		BoomerActionPoints[i] = 0.0;
		BlindAmmo[i] = 0;
		BloatAmmo[i] = 0;
		IceAmmo[i] = 0;
		Scout[i] = false;
		Ensnared[i] = false;
		IncapDisabled[i] = false;
		SurvivorHeadshotValue[i] = 0;
		SurvivorSpecialValue[i] = 0;
		SurvivorCommonValue[i] = 0;
		SurvivorPistolValue[i] = 0;
		SurvivorMeleeValue[i] = 0;
		SurvivorSmgValue[i] = 0;
		SurvivorShotgunValue[i] = 0;
		SurvivorRifleValue[i] = 0;
		SurvivorSniperValue[i] = 0;
		SurvivorHeadshotGoal[i] = GetConVarInt(SurvivorHeadshotStart);
		SurvivorSpecialGoal[i] = GetConVarInt(SurvivorSpecialStart);
		SurvivorCommonGoal[i] = GetConVarInt(SurvivorCommonStart);
		SurvivorPistolGoal[i] = GetConVarInt(SurvivorPistolStart);
		SurvivorMeleeGoal[i] = GetConVarInt(SurvivorMeleeStart);
		SurvivorSmgGoal[i] = GetConVarInt(SurvivorSmgStart);
		SurvivorShotgunGoal[i] = GetConVarInt(SurvivorShotgunStart);
		SurvivorRifleGoal[i] = GetConVarInt(SurvivorRifleStart);
		SurvivorSniperGoal[i] = GetConVarInt(SurvivorSniperStart);
		BloatAmmoPistol[i] = false;
		BlindAmmoPistol[i] = false;
		IceAmmoPistol[i] = false;
		HealAmmoPistol[i] = false;
		BeanBagAmmoPistol[i] = false;
		BloatAmmoAmountPistol[i] = 0;
		BlindAmmoAmountPistol[i] = 0;
		IceAmmoAmountPistol[i] = 0;
		HealAmmoAmountPistol[i] = 0;
		BeanBagAmmoAmountPistol[i] = 0;

		BloatAmmoSmg[i] = false;
		BlindAmmoSmg[i] = false;
		IceAmmoSmg[i] = false;
		HealAmmoSmg[i] = false;
		BeanBagAmmoSmg[i] = false;
		BloatAmmoAmountSmg[i] = 0;
		BlindAmmoAmountSmg[i] = 0;
		IceAmmoAmountSmg[i] = 0;
		HealAmmoAmountSmg[i] = 0;
		BeanBagAmmoAmountSmg[i] = 0;

		BloatAmmoShotgun[i] = false;
		BlindAmmoShotgun[i] = false;
		IceAmmoShotgun[i] = false;
		HealAmmoShotgun[i] = false;
		BeanBagAmmoShotgun[i] = false;
		BloatAmmoAmountShotgun[i] = 0;
		BlindAmmoAmountShotgun[i] = 0;
		IceAmmoAmountShotgun[i] = 0;
		HealAmmoAmountShotgun[i] = 0;
		BeanBagAmmoAmountShotgun[i] = 0;

		BloatAmmoRifle[i] = false;
		BlindAmmoRifle[i] = false;
		IceAmmoRifle[i] = false;
		HealAmmoRifle[i] = false;
		BeanBagAmmoRifle[i] = false;
		BloatAmmoAmountRifle[i] = 0;
		BlindAmmoAmountRifle[i] = 0;
		IceAmmoAmountRifle[i] = 0;
		HealAmmoAmountRifle[i] = 0;
		BeanBagAmmoAmountRifle[i] = 0;

		BloatAmmoSniper[i] = false;
		BlindAmmoSniper[i] = false;
		IceAmmoSniper[i] = false;
		HealAmmoSniper[i] = false;
		BeanBagAmmoSniper[i] = false;
		BloatAmmoAmountSniper[i] = 0;
		BlindAmmoAmountSniper[i] = 0;
		IceAmmoAmountSniper[i] = 0;
		HealAmmoAmountSniper[i] = 0;
		BeanBagAmmoAmountSniper[i] = 0;
		SurvivorTeamPurchase[i] = false;
		Tier2Cost[i] = GetConVarFloat(Tier2StartCost);
		HealthItemCost[i] = GetConVarFloat(HealthItemStartCost);
		PersonalAbilitiesCost[i] = GetConVarFloat(PersonalAbilitiesStartCost);
		WeaponUpgradeCost[i] = GetConVarFloat(WeaponUpgradeStartCost);
		HazmatBoots[i] = 0;
		EyeGoggles[i] = 0;
		GravityBoots[i] = 0;
		RespawnType[i] = 0;
		PlayerMovementSpeed[i] = 1.0;
		RoundKills[i] = 0;
		RoundDamage[i] = 0;
		RoundSurvivorDamage[i] = 0;
		RoundHS[i] = 0;

		M60CD[i] = false;

		OnDrugs[i] = false;
		DrugsUsed[i] = 0;
		DrugEffect[i] = false;
		DrugTimer[i] = -1.0;

		JockeyRideBlind[i] = false;

		HealAmmoDisabled[i] = false;

		BrokenLegs[i] = false;
		HeavyBySpit[i] = false;

		MiniGun[i] = -1;
		MiniGunUse[i] = false;
		MiniGunMobile[i] = false;
		WaitBeforeUses[i] = false;
		
		/*		INFECTED RESETS		*/

		ChargerJumpCooldown[i] = false;
		SufferingFromBloatAmmo[i] = false;
		ChargerCanJump[i] = false;
		ChargerIsJumping[i] = false;
		BeanBagAmmoImmune[i] = false;
		InfectedPoints[i] = 0.0;
		BerserkerKill[i] = false;
		ClassHunter[i] = false;
		ClassSmoker[i] = false;
		ClassBoomer[i] = false;
		ClassJockey[i] = false;
		ClassCharger[i] = false;
		ClassSpitter[i] = false;
		ClassTank[i] = false;
		UpgradeHunter[i] = false;
		UpgradeSmoker[i] = false;
		UpgradeBoomer[i] = false;
		UpgradeJockey[i] = false;
		UpgradeCharger[i] = false;
		UpgradeSpitter[i] = false;
		SuperUpgradeHunter[i] = false;
		SuperUpgradeSmoker[i] = false;
		SuperUpgradeBoomer[i] = false;
		SuperUpgradeJockey[i] = false;
		SuperUpgradeCharger[i] = false;
		SuperUpgradeSpitter[i] = false;
		BloatAmmoImmune[i] = false;
		IceAmmoImmune[i] = false;
		SpitterImmune[i] = false;
		JockeyJumping[i] = false;
		IsSmoking[i] = false;
		SpecialPurchaseValue[i] = GetConVarFloat(SpecialPurchaseStart);
		TankPurchaseValue[i] = GetConVarFloat(TankPurchaseStart);
		UncommonPurchaseValue[i] = GetConVarFloat(UncommonPurchaseStart);
		TeamUpgradesPurchaseValue[i] = GetConVarFloat(TeamUpgradesPurchaseStart);
		PersonalUpgradesPurchaseValue[i] = GetConVarFloat(PersonalUpgradesPurchaseStart);
		
		PersonalUpgrades[i] = 0;
		SpawnAnywhere[i] = false;
		WallOfFire[i] = false;
		SmokerWhipCooldown[i] = false;
		
		IsRiding[i] = false;
		IsSmoking[i] = false;
		JockeyJumpCooldown[i] = false;
		BurnDamageImmune[i] = false;
		
		LocationSaved[i] = false;

		JockeyRideTime[i] = 0;
		InfectedGhost[i] = true;

		RoundRescuer[i] = 0;
		
		SetEntityGravity(i, 1.0);
	}
	PrintToChatAll("%s \x01Round Data Has Been Reset", INFO);
	//PrintToChatAll("%s \x01Round Has Ended. Calculating Totals!", INFO);
}