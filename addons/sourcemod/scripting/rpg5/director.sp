public Action:Timer_DirectorPurchase(Handle:timer)
{
	if (GetConVarInt(DirectorEnabled) == 0 || RoundReset)
	{
		PrintToChatAll("%s \x01The AI Director relinquishes control... for now.", INFO);
		return Plugin_Stop;
	}

	DirectorPurchaseFunc();
	return Plugin_Continue;
}

public DirectorPurchaseFunc()
{
	new number = GetRandomInt(1, 100);
	new playerfound = 0;
	new chance = 0;
	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsHuman(i)) continue;
		playerfound = i;
		break;
	}
	if (playerfound == 0) return;

	// The only time director makes purchases is if there are human players in the server.

	if (!bRescue && RescueCalled && !bFinaleTankRush)
	{
		// Boolean to prevent hundreds of tank spam!
		bFinaleTankRush = true;
		// The rescue vehicle has arrived, spawn the tanks!
		CreateTimer(0.1, Timer_SpawnRescueTanks, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	}
	else
	{
		// If the rescue vehicle hasn't arrived, we consider the next two possibilities.
		// No need to check them if the rescue vehicle is here
		// since multiple tanks spawn for free at the "last stretch"
		if (TankLimit < GetConVarInt(TankLimitMax) && DirectorPoints >= GetConVarFloat(TeamUpgradesPurchaseStart) && bTankBotsAllowed)
		{
			TankLimit += GetConVarInt(TankLimitIncrement);
			DirectorPoints -= GetConVarFloat(TeamUpgradesPurchaseStart);
			if (!bFirstUpgrade) bFirstUpgrade = true;
		}
		if (TankCooldownTime == 0.0 && TankCount < TankLimit && DirectorPoints >= GetConVarFloat(TankPurchaseStart) && bTankBotsAllowed)
		{
			TankCount++;
			ExecCheatCommand(playerfound, "z_spawn", "tank");
			DirectorPoints -= GetConVarFloat(TankPurchaseStart);
			if (!bFirstUpgrade) bFirstUpgrade = true;
		}
	}
	if (!UncommonCooldown && DirectorPoints >= GetConVarFloat(UncommonPurchaseStart) && !bRescue)
	{
		CreateTimer(1.0, EnableUncommonPurchases, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		UncommonCooldown = true;
		if (UncommonPanicEventCount == -1.0)
		{
			UncommonRemaining = GetConVarInt(PanicAmount);
			UncommonType = 9;
			ExecCheatCommand(playerfound, "director_force_panic_event");
			DirectorPoints -= GetConVarFloat(UncommonPurchaseStart);
			CreateTimer(1.0, EnableUncommonEvent, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		else if (number <= 40)
		{
			UncommonRemaining = GetConVarInt(UncommonDropAmount);
			DirectorPoints -= GetConVarFloat(UncommonPurchaseStart);
			UncommonType = 2;			// jimmy gibbs
			for (new i = 1; i <= UncommonRemaining; i++)
			{
				ExecCheatCommand(playerfound, "z_spawn", "common");
			}
			UncommonRemaining = 0;
		}
		else if (number <= 80)
		{
			UncommonRemaining = GetConVarInt(UncommonDropAmount);
			DirectorPoints -= GetConVarFloat(UncommonPurchaseStart);
			UncommonType = 3;			// jimmy gibbs
			for (new i = 1; i <= UncommonRemaining; i++)
			{
				ExecCheatCommand(playerfound, "z_spawn", "common");
			}
			UncommonRemaining = 0;
		}
	}
	if (number <= 20 && DirectorPoints >= GetConVarFloat(UncommonPurchaseStart))
	{
		CreateTimer(0.01, Timer_SpawnSpecialDrop, playerfound, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		DirectorPoints -= GetConVarFloat(UncommonPurchaseStart);
	}
	if (!SteelTongue && DirectorPoints >= GetConVarFloat(TeamUpgradesPurchaseStart))
	{
		SteelTongue = true;
		DirectorPoints -= GetConVarInt(TeamUpgradesPurchaseStart);
		if (!bFirstUpgrade) bFirstUpgrade = true;
	}
	if (!bCommonMeleeImmune && DirectorPoints >= GetConVarFloat(TeamUpgradesPurchaseStart) 
		&& number <= 20)
	{
		bCommonMeleeImmune = true;
		DirectorPoints -= GetConVarFloat(TeamUpgradesPurchaseStart);
		if (!bFirstUpgrade) bFirstUpgrade = true;
	}
	if (moreCommonsAmount < GetConVarInt(MoreCommonsLimit) && DirectorPoints >= GetConVarFloat(TeamUpgradesPurchaseStart) 
		&& number <= 30)
	{
		moreCommonsAmount += GetConVarInt(MoreCommonsIncrement);
		SetConVarInt(FindConVar("z_common_limit"), moreCommonsAmount);
		DirectorPoints -= GetConVarFloat(TeamUpgradesPurchaseStart);
		if (!bFirstUpgrade) bFirstUpgrade = true;
	}
	if (commonBodyArmour < GetConVarFloat(CommonBodyArmourMax) && DirectorPoints >= GetConVarFloat(TeamUpgradesPurchaseStart) 
		&& number <= 40)
	{
		commonBodyArmour += GetConVarFloat(CommonBodyArmourAmount);
		DirectorPoints -= GetConVarFloat(TeamUpgradesPurchaseStart);
		if (!bFirstUpgrade) bFirstUpgrade = true;
	}
	if (DeepFreezeAmount < GetConVarInt(DeepFreezeMax) && DirectorPoints >= GetConVarFloat(TeamUpgradesPurchaseStart) 
		&& number <= 50)
	{
		DeepFreezeAmount += GetConVarInt(DeepFreezeIncrement);
		if (DeepFreezeAmount > GetConVarInt(DeepFreezeMax)) DeepFreezeAmount = GetConVarInt(DeepFreezeMax);
		DirectorPoints -= GetConVarFloat(TeamUpgradesPurchaseStart);
		if (!bFirstUpgrade) bFirstUpgrade = true;
	}
	/*
	if (witchCount < witchMax && DirectorPoints >= GetConVarFloat(TankPurchaseStart))
	{
		witchCount++;
		ExecCheatCommand(playerfound, "z_spawn", "witch");
		DirectorPoints -= GetConVarFloat(TankPurchaseStart);
		if (!bFirstUpgrade) bFirstUpgrade = true;
	}
	*/
	if (bFirstUpgrade && GetConVarInt(g_hardMode) == 1 && bhardModeRequirement())
	{
		if (!bhardModeTrigger)
		{
			bhardModeTrigger = true;
			PrintToChatAll("%s \x04Hard Mode \x01has been \x03triggered", INFO);
		}
		chance = GetRandomInt(1, 30);
		if (chance == 1) ExecCheatCommand(playerfound, "z_spawn", "hunter");
		if (chance == 2) ExecCheatCommand(playerfound, "z_spawn", "smoker");
		if (chance == 3) ExecCheatCommand(playerfound, "z_spawn", "boomer");
		if (chance == 4) ExecCheatCommand(playerfound, "z_spawn", "jockey");
		if (chance == 5) ExecCheatCommand(playerfound, "z_spawn", "charger");
		if (chance == 6) ExecCheatCommand(playerfound, "z_spawn", "spitter");
	}
}

public Action:Timer_SpawnSpecialDrop(Handle:timer, any:client)
{
	static specialdrop = 0;
	specialdrop++;
	new chance = GetRandomInt(1, 6);
	if (chance == 1) ExecCheatCommand(client, "z_spawn", "hunter");
	if (chance == 2) ExecCheatCommand(client, "z_spawn", "smoker");
	if (chance == 3) ExecCheatCommand(client, "z_spawn", "boomer");
	if (chance == 4) ExecCheatCommand(client, "z_spawn", "jockey");
	if (chance == 5) ExecCheatCommand(client, "z_spawn", "charger");
	if (chance == 6) ExecCheatCommand(client, "z_spawn", "spitter");
	if (specialdrop >= GetConVarInt(g_SpecialDropAmount)) return Plugin_Stop;
	return Plugin_Continue;
}

public Action:Timer_SpawnRescueTanks(Handle:timer)
{
	static oldplayerfound = 0;
	new playerfound = 0;
	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsHuman(i) || i == oldplayerfound) continue;
		oldplayerfound = i;
		playerfound = i;
		break;
	}
	if (playerfound == 0) return Plugin_Stop;
	ExecCheatCommand(playerfound, "z_spawn", "tank");
	TankCount++;
	if (TankCount >= GetConVarInt(g_RescueTankCount)) return Plugin_Stop;
	return Plugin_Continue;
}