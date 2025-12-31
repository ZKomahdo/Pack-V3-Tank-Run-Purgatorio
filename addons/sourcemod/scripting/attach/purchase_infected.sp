public InfectedPurchaseFunc(client)
{
	if (PurchaseItem[client] == 0 && !IsPlayerGhost(client)) ItemCost[client] = GetConVarFloat(SICost);
	else if (PurchaseItem[client] == 0 && IsPlayerGhost(client)) ItemCost[client] = 0.0;
	if (PurchaseItem[client] == 1) ItemCost[client] = GetConVarFloat(SITCost);
	if (PurchaseItem[client] == 2) ItemCost[client] = GetConVarFloat(SZCost);
	if (PurchaseItem[client] == 3) ItemCost[client] = GetConVarFloat(ITUCost);


	if (playerPoints[client][1] < ItemCost[client])
	{
		if (playerPoints[client][1] + teamPoints[1] < ItemCost[client])
		{
			PrintToChat(client, "%s - \x01You do not have the points to make this purchase.", INFO_GENERAL);
			return;
		}
		ItemCost[client] -= playerPoints[client][1];
		playerPoints[client][1] = 0.0;
		teamPoints[1] -= ItemCost[client];
		ItemCost[client] = 0.0;
	}
	else
	{
		playerPoints[client][1] -= ItemCost[client];
		ItemCost[client] = 0.0;
	}

	if (PurchaseItem[client] == 0)
	{
		new WeaponIndex;
		while ((WeaponIndex = GetPlayerWeaponSlot(client, 0)) != -1)
		{
			RemovePlayerItem(client, WeaponIndex);
			RemoveEdict(WeaponIndex);
		}
		if (StrEqual(ItemName[client], "Hunter")) SDKCall(g_hSetClass, client, 3);
		if (StrEqual(ItemName[client], "Smoker")) SDKCall(g_hSetClass, client, 1);
		if (StrEqual(ItemName[client], "Boomer")) SDKCall(g_hSetClass, client, 2);
		if (StrEqual(ItemName[client], "Jockey")) SDKCall(g_hSetClass, client, 5);
		if (StrEqual(ItemName[client], "Charger")) SDKCall(g_hSetClass, client, 6);
		if (StrEqual(ItemName[client], "Spitter")) SDKCall(g_hSetClass, client, 4);
		
		AcceptEntityInput(MakeCompatEntRef(GetEntProp(client, Prop_Send, "m_customAbility")), "Kill");
		SetEntProp(client, Prop_Send, "m_customAbility", GetEntData(SDKCall(g_hCreateAbility, client), g_oAbility));
		if (GetConVarInt(PurchaseNotice) == 1 && IsPlayerGhost(client)) PrintToInfected("\x03%N \x01has changed their class to \x05%s.", client, ItemName[client]);
		else if (GetConVarInt(PurchaseNotice) == 1 && !IsPlayerGhost(client)) PrintToInfected("\x03%N \x01has purchased \x05%s.", client, ItemName[client]);
		SendPanelToClient(Points_InfectedCC(client), client, Points_InfectedCC_Init, MENU_TIME_FOREVER);

		if (!IsPlayerGhost(client)) SetupZombie(client);
	}
	else if (PurchaseItem[client] == 1)
	{
		new WeaponIndex;
		while ((WeaponIndex = GetPlayerWeaponSlot(client, 0)) != -1)
		{
			RemovePlayerItem(client, WeaponIndex);
			RemoveEdict(WeaponIndex);
		}
		SDKCall(g_hSetClass, client, 8);
		
		AcceptEntityInput(MakeCompatEntRef(GetEntProp(client, Prop_Send, "m_customAbility")), "Kill");
		SetEntProp(client, Prop_Send, "m_customAbility", GetEntData(SDKCall(g_hCreateAbility, client), g_oAbility));


		if (GetConVarInt(PurchaseNotice) == 1) PrintToInfected("\x03%N \x01has purchased a \x05%s.", client, ItemName[client]);
		SendPanelToClient(Points_InfectedMenu(client), client, Points_InfectedMenu_Init, MENU_TIME_FOREVER);

		SetupZombie(client);
	}
	else if (PurchaseItem[client] == 2)
	{
		if (StrEqual(ItemName[client], "witch_drop"))
		{
			ExecCheatCommand(client, "z_spawn", "witch");
			witchCount++;
		}
		else
		{
			if (StrEqual(ItemName[client], "uncommon_panic_event"))
			{
				summonZombieCooldown = 0.0;
				uncommonRemaining = GetConVarInt(panicEventSize);
				uncommonPanicEvent = true;
				ExecCheatCommand(client, "director_force_panic_event");
			}
			else
			{
				summonZombieCooldown = GetConVarFloat(SZCooldown);
				if (!StrEqual(ItemName[client], "common_drop")) uncommonRemaining = GetConVarInt(uncommonDropSize);
				else uncommonRemaining = 0;
			}
			if (StrEqual(ItemName[client], "common_drop")) uncommonType = 0;
			else if (StrEqual(ItemName[client], "brown_plop_drop")) uncommonType = 1;
			else if (StrEqual(ItemName[client], "jimmy_rage_drop")) uncommonType = 2;
			else if (StrEqual(ItemName[client], "riot_blue_drop")) uncommonType = 3;
			else if (StrEqual(ItemName[client], "road_krew_drop")) uncommonType = 4;
			if (!uncommonPanicEvent)
			{
				if (uncommonRemaining > 0) for (new i = 1; i <= uncommonRemaining; i++) ExecCheatCommand(client, "z_spawn", "common");
				else for (new i = 1; i <= GetConVarInt(uncommonDropSize); i++) ExecCheatCommand(client, "z_spawn", "common");
				uncommonRemaining = 0;
				CreateTimer(1.0, Timer_EnableSummonZombie, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		if (GetConVarInt(PurchaseNotice) == 1) PrintToInfected("%s - \x03%N \x01has purchased \x05%s.", INFO_GENERAL, client, ItemName[client]);
		SendPanelToClient(Points_InfectedMenu(client), client, Points_InfectedMenu_Init, MENU_TIME_FOREVER);
	}
	else if (PurchaseItem[client] == 3)
	{
		if (StrEqual(ItemName[client], "upgrade_tank_limit")) tankLimit += GetConVarInt(Enhancement_TankLimit);
		else if (StrEqual(ItemName[client], "upgrade_tank_speed")) tankUPS += GetConVarFloat(Enhancement_TankSpeed);
		else if (StrEqual(ItemName[client], "upgrade_tank_health")) tankHealth += GetConVarInt(Enhancement_TankHealth);
		else if (StrEqual(ItemName[client], "upgrade_witch_limit")) witchLimit += GetConVarInt(Enhancement_WitchAmount);
		else if (StrEqual(ItemName[client], "upgrade_witch_speed"))
		{
			witchUPS += GetConVarInt(Enhancement_WitchSpeed);
			SetConVarInt(FindConVar("z_witch_speed"), witchUPS);
		}
		else if (StrEqual(ItemName[client], "upgrade_si_health")) SIHealth += GetConVarInt(Enhancement_SIHealth);
		else if (StrEqual(ItemName[client], "upgrade_deep_freeze")) deepFreezeAmount += GetConVarInt(Enhancement_DeepFreeze);
		else if (StrEqual(ItemName[client], "upgrade_spawn_timer"))
		{
			spawnTimer -= GetConVarInt(Enhancement_SpawnTimer);
			SetConVarInt(FindConVar("z_ghost_delay_min"), spawnTimer);
			SetConVarInt(FindConVar("z_ghost_delay_max"), spawnTimer);
		}
		else if (StrEqual(ItemName[client], "upgrade_charge_jump")) bChargerJump = true;
		else if (StrEqual(ItemName[client], "upgrade_charge_speed")) chargeSpeed += GetConVarFloat(Enhancement_ChargeSpeed);
		else if (StrEqual(ItemName[client], "upgrade_charge_volley")) chargeVolley += GetConVarInt(Enhancement_ChargeVolley);
		else if (StrEqual(ItemName[client], "upgrade_spit_protection")) spitProtectionTime += GetConVarFloat(Enhancement_SpitProtection);
		else if (StrEqual(ItemName[client], "upgrade_spit_slow_time")) spitSlowTime += GetConVarFloat(Enhancement_SpitSlowTime);
		else if (StrEqual(ItemName[client], "upgrade_spit_slow_amount")) spitSlowAmount -= GetConVarFloat(Enhancement_SpitSlowAmount);
		else if (StrEqual(ItemName[client], "upgrade_jockey_jump")) bJockeyJump = true;
		else if (StrEqual(ItemName[client], "upgrade_jockey_kill")) bJockeyBerserk = true;
		else if (StrEqual(ItemName[client], "upgrade_jockey_ride")) bJockeyBlind = true;
		else if (StrEqual(ItemName[client], "upgrade_jockey_control"))
		{
			bJockeyControl = true;
			SetConVarFloat(FindConVar("z_jockey_control_variance"), 0.3);
		}
		else if (StrEqual(ItemName[client], "upgrade_blinding_bile")) bBlindingBile = true;
		else if (StrEqual(ItemName[client], "upgrade_unstable_boomer")) bUnstableBoomer = true;
		else if (StrEqual(ItemName[client], "upgrade_slowing_bile")) bSlowingBile = true;
		else if (StrEqual(ItemName[client], "upgrade_steel_tongue"))
		{
			bSteelTongue = true;
			SetConVarInt(FindConVar("tongue_break_from_damage_amount"), 999999);
		}
		else if (StrEqual(ItemName[client], "upgrade_smoker_whip")) bSmokerWhip = true;
		else if (StrEqual(ItemName[client], "upgrade_tongue_range"))
		{
			tongueRange += GetConVarInt(Enhancement_TongueLimit);
			SetConVarInt(FindConVar("tongue_range"), tongueRange);
		}
		else if (StrEqual(ItemName[client], "upgrade_survivor_glow"))
		{
			bNoSurvivorGlow = true;
			SetConVarInt(FindConVar("sv_disable_glow_survivors"), 1);
		}
		else if (StrEqual(ItemName[client], "upgrade_instantkill_witch"))
		{
			bWitchStrength = true;
			SetConVarInt(FindConVar("z_witch_always_kills"), 1);
		}
		else if (StrEqual(ItemName[client], "upgrade_more_commons"))
		{
			commonLimit += GetConVarInt(Enhancement_CommonLimit);
			SetConVarInt(FindConVar("z_common_limit"), commonLimit);
		}
		else if (StrEqual(ItemName[client], "upgrade_special_fire_immunity")) bSpecialFireImmune = true;
		else if (StrEqual(ItemName[client], "upgrade_common_fire_immunity")) bCommonFireImmune = true;
		else if (StrEqual(ItemName[client], "upgrade_common_melee_immunity")) bCommonMeleeImmune = true;
		else if (StrEqual(ItemName[client], "upgrade_common_body_armour")) commonBodyArmour += GetConVarFloat(Enhancement_BodyArmour);
		else if (StrEqual(ItemName[client], "upgrade_wall_of_fire")) bWallOfFire = true;
		else if (StrEqual(ItemName[client], "upgrade_spawn_anywhere")) bSpawnAnywhere = true;
		else if (StrEqual(ItemName[client], "upgrade_special_cloak")) bInfectedCloak = true;

		if (GetConVarInt(PurchaseNotice) == 1) PrintToInfected("%s - \x03%N \x01has purchased \x05%s.", INFO_GENERAL, client, ItemName[client]);
		
		if (StrEqual(ItemName[client], "upgrade_tank_limit") || StrEqual(ItemName[client], "upgrade_tank_speed") || 
			StrEqual(ItemName[client], "upgrade_tank_health") || StrEqual(ItemName[client], "upgrade_witch_limit") || 
			StrEqual(ItemName[client], "upgrade_witch_speed") || StrEqual(ItemName[client], "upgrade_si_health") || 
			StrEqual(ItemName[client], "upgrade_deep_freeze")) SendPanelToClient(Points_InfectedTU(client), client, Points_InfectedTU_Init, MENU_TIME_FOREVER);

		if (StrEqual(ItemName[client], "upgrade_spawn_timer") || StrEqual(ItemName[client], "upgrade_charge_jump") || 
			StrEqual(ItemName[client], "upgrade_charge_speed") || StrEqual(ItemName[client], "upgrade_charge_volley") || 
			StrEqual(ItemName[client], "upgrade_spit_protection") || StrEqual(ItemName[client], "upgrade_spit_slow_time") || 
			StrEqual(ItemName[client], "upgrade_spit_slow_amount")) SendPanelToClient(Points_InfectedTU2(client), client, Points_InfectedTU2_Init, MENU_TIME_FOREVER);

		if (StrEqual(ItemName[client], "upgrade_jockey_jump") || StrEqual(ItemName[client], "upgrade_jockey_kill") || 
			StrEqual(ItemName[client], "upgrade_jockey_ride") || StrEqual(ItemName[client], "upgrade_jockey_control") || 
			StrEqual(ItemName[client], "upgrade_blinding_bile") || StrEqual(ItemName[client], "upgrade_unstable_boomer") || 
			StrEqual(ItemName[client], "upgrade_slowing_bile")) SendPanelToClient(Points_InfectedTU3(client), client, Points_InfectedTU3_Init, MENU_TIME_FOREVER);

		if (StrEqual(ItemName[client], "upgrade_steel_tongue") || StrEqual(ItemName[client], "upgrade_smoker_whip") || 
			StrEqual(ItemName[client], "upgrade_tongue_range") || StrEqual(ItemName[client], "upgrade_survivor_glow") || 
			StrEqual(ItemName[client], "upgrade_instantkill_witch") || StrEqual(ItemName[client], "upgrade_strafe_charging") || 
			StrEqual(ItemName[client], "upgrade_more_commons")) SendPanelToClient(Points_InfectedTU4(client), client, Points_InfectedTU4_Init, MENU_TIME_FOREVER);

		if (StrEqual(ItemName[client], "upgrade_special_fire_immunity") || StrEqual(ItemName[client], "upgrade_common_fire_immunity") || 
			StrEqual(ItemName[client], "upgrade_common_melee_immunity") || StrEqual(ItemName[client], "upgrade_common_body_armour") || 
			StrEqual(ItemName[client], "upgrade_wall_of_fire") || StrEqual(ItemName[client], "upgrade_spawn_anywhere") || 
			StrEqual(ItemName[client], "upgrade_special_cloak")) SendPanelToClient(Points_InfectedTU5(client), client, Points_InfectedTU5_Init, MENU_TIME_FOREVER);
	}
}