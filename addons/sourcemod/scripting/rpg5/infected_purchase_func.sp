InfectedPurchaseFunc(client)
{
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || IsFakeClient(client)) return;
	if (GetClientTeam(client) != 3) return;
	if (GetConVarInt(CostEvaluation) == 0 || GetConVarInt(CostEvaluation) == 1)
	{
		if (PurchaseItem[client] == 1) ItemCost[client] = SpecialPurchaseValue[client];
		if (PurchaseItem[client] == 2) ItemCost[client] = TankPurchaseValue[client];
		if (PurchaseItem[client] == 3) ItemCost[client] = UncommonPurchaseValue[client];
		if (PurchaseItem[client] == 4) ItemCost[client] = TeamUpgradesPurchaseValue[client];
		if (PurchaseItem[client] == 5) ItemCost[client] = PersonalUpgradesPurchaseValue[client];
	}
	else if (GetConVarInt(CostEvaluation) == 2)
	{
		if (PurchaseItem[client] == 1)
		{
			if (IsPlayerGhost(client)) ItemCost[client] = 0.0;
			else
			{
				if (StrEqual(ItemName[client], "Hunter", false)) ItemCost[client] = Hu[client][2] * GetConVarFloat(SpecialCostByLevel);
				else if (StrEqual(ItemName[client], "Smoker", false)) ItemCost[client] = Sm[client][2] * GetConVarFloat(SpecialCostByLevel);
				else if (StrEqual(ItemName[client], "Boomer", false)) ItemCost[client] = Bo[client][2] * GetConVarFloat(SpecialCostByLevel);
				else if (StrEqual(ItemName[client], "Jockey", false)) ItemCost[client] = Jo[client][2] * GetConVarFloat(SpecialCostByLevel);
				else if (StrEqual(ItemName[client], "Charger", false)) ItemCost[client] = Ch[client][2] * GetConVarFloat(SpecialCostByLevel);
				else if (StrEqual(ItemName[client], "Spitter", false)) ItemCost[client] = Sp[client][2] * GetConVarFloat(SpecialCostByLevel);
			}
		}
		else if (PurchaseItem[client] == 2)
		{
			if (StrEqual(ItemName[client], "witch", false)) ItemCost[client] = In[client][2] * GetConVarFloat(WitchCostByLevel);
			else ItemCost[client] = Ta[client][2] * GetConVarFloat(TankCostByLevel);
		}
		else if (PurchaseItem[client] == 3) ItemCost[client] = In[client][2] * GetConVarFloat(UncommonCostByLevel);
		else if (PurchaseItem[client] == 4) ItemCost[client] = In[client][2] * GetConVarFloat(TeamUpgradesCostByLevel);
		else if (PurchaseItem[client] == 5) ItemCost[client] = In[client][2] * GetConVarFloat(PersonalUpgradesCostByLevel);
	}

	// Check to see if an item cost > 0 is set. If it isn't, the players data hasn't loaded, or they're a new player, and we don't
	// want to let the player make any purchases (otherwise it could result in something tragic, possibly something A HUNDRED WITCHES IN THE SAFEROOM!)
	if (ItemCost[client] < 1 && (!IsPlayerGhost(client) && PurchaseItem[client] != 1))
	{
		PrintToChat(client, "%s \x01Purchases cannot be made until your data has loaded, or first been saved.", ERROR_INFO);
		return;
	}
	
	if (InfectedPoints[client] < ItemCost[client])
	{
		if ((InfectedPoints[client] + InfectedTeamPoints) < ItemCost[client] || InfectedPoints[client] < 1.0)
		{
			PrintToChat(client, "%s \x01Insufficient points to purchase %s", INFO, ItemName[client]);
			return;
		}
		else InfectedTeamPurchase[client] = true;
	}
	else InfectedTeamPurchase[client] = false;
	
	if (PurchaseItem[client] == 1) ChangeZombieClass(client);
	else if (PurchaseItem[client] == 2)
	{
		PrintToInfected("%s \x04%N \x01Purchased \x05%s", PURCHASE_INFO, client, ItemName[client]);
		if (StrEqual(ItemName[client], "witch", false))
		{
			witchCount++;
			ExecCheatCommand(client, "z_spawn", ItemName[client]);
		}
		else
		{
			decl zombieclass;
			zombieclass = GetEntProp(client, Prop_Send, "m_zombieClass");
			if (zombieclass == ZOMBIECLASS_TANK) return;
		
			TankCount++;
			ClassHunter[client] = false;
			ClassSmoker[client] = false;
			ClassBoomer[client] = false;
			ClassJockey[client] = false;
			ClassCharger[client] = false;
			ClassSpitter[client] = false;
			ClassTank[client] = true;
			new WeaponIndex;
			while ((WeaponIndex = GetPlayerWeaponSlot(client, 0)) != -1)
			{
				RemovePlayerItem(client, WeaponIndex);
				RemoveEdict(WeaponIndex);
			}
			SDKCall(g_hSetClass, client, 8);
			AcceptEntityInput(MakeCompatEntRef(GetEntProp(client, Prop_Send, "m_customAbility")), "Kill");
			SetEntProp(client, Prop_Send, "m_customAbility", GetEntData(SDKCall(g_hCreateAbility, client), g_oAbility));
		}
	}
	else if (PurchaseItem[client] == 3)
	{
		if (StrEqual(ItemName[client], LastUncommon))
		{
			PrintToChat(client, "%s \x01%s was called last, try something else first!", ERROR_INFO, ItemName[client]);
			return;
		}
		Format(LastUncommon, sizeof(LastUncommon), "%s", ItemName[client]);
		if (StrEqual(ItemName[client], "mudmen_drop", false))
		{
			UncommonRemaining = GetConVarInt(UncommonDropAmount);
			UncommonType = 1;			// mudmen
			for (new i = 1; i <= UncommonRemaining; i++)
			{
				ExecCheatCommand(client, "z_spawn", "common");
			}
			UncommonRemaining = 0;
		}
		else if (StrEqual(ItemName[client], "jimmy_drop", false))
		{
			UncommonRemaining = GetConVarInt(UncommonDropAmount);
			UncommonType = 2;			// jimmy gibbs
			for (new i = 1; i <= UncommonRemaining; i++)
			{
				ExecCheatCommand(client, "z_spawn", "common");
			}
			UncommonRemaining = 0;
		}
		else if (StrEqual(ItemName[client], "riot_drop", false))
		{
			UncommonRemaining = GetConVarInt(UncommonDropAmount);
			UncommonType = 3;			// jimmy gibbs
			for (new i = 1; i <= UncommonRemaining; i++)
			{
				ExecCheatCommand(client, "z_spawn", "common");
			}
			UncommonRemaining = 0;
		}
		else if (StrEqual(ItemName[client], "road_drop", false))
		{
			UncommonRemaining = GetConVarInt(UncommonDropAmount);
			UncommonType = 4;			// jimmy gibbs
			for (new i = 1; i <= UncommonRemaining; i++)
			{
				ExecCheatCommand(client, "z_spawn", "common");
			}
			UncommonRemaining = 0;
		}
		else if (StrEqual(ItemName[client], "mudmen_queue", false))
		{
			UncommonRemaining = GetConVarInt(UncommonQueueAmount);
			UncommonType = 5;			// mudmen
		}
		else if (StrEqual(ItemName[client], "jimmy_queue", false))
		{
			UncommonRemaining = GetConVarInt(UncommonQueueAmount);
			UncommonType = 6;			// jimmy gibbs
		}
		else if (StrEqual(ItemName[client], "riot_queue", false))
		{
			UncommonRemaining = GetConVarInt(UncommonQueueAmount);
			UncommonType = 7;			// jimmy gibbs
		}
		else if (StrEqual(ItemName[client], "road_queue", false))
		{
			UncommonRemaining = GetConVarInt(UncommonQueueAmount);
			UncommonType = 8;			// jimmy gibbs
		}
		else if (StrEqual(ItemName[client], "uncommon_event", false))
		{
			UncommonRemaining = GetConVarInt(PanicAmount);
			UncommonType = 9;
			ExecCheatCommand(client, "director_force_panic_event");
			CreateTimer(1.0, EnableUncommonEvent, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
		UncommonCooldown = true;
		CreateTimer(1.0, EnableUncommonPurchases, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		PrintToInfected("%s \x04%N \x01Purchased \x05%s", PURCHASE_INFO, client, ItemName[client]);
	}
	else if (PurchaseItem[client] == 4)
	{
		PrintToInfected("%s \x04%N \x01Purchased \x05%s", PURCHASE_INFO, client, ItemName[client]);
		new String:Pct[32];
		Format(Pct, sizeof(Pct), "%");
		if (StrEqual(ItemName[client], "steel_tongue", false))
		{
			SteelTongue = true;
			PrintToInfected("%s \x01Smoker tongues are now unbreakable!", INFO);
		}
		else if (StrEqual(ItemName[client], "tank_limit", false))
		{
			TankLimit += GetConVarInt(TankLimitIncrement);
			PrintToInfected("%s \x01Tank Limit has been raised to \x05%d", INFO, TankLimit);
		}
		else if (StrEqual(ItemName[client], "deep_freeze", false))
		{
			DeepFreezeAmount += GetConVarInt(DeepFreezeIncrement);
			if (DeepFreezeAmount > GetConVarInt(DeepFreezeMax)) DeepFreezeAmount = GetConVarInt(DeepFreezeMax);
			PrintToInfected("%s \x01Deep Freeze has been raised to \x05%d%s", INFO, DeepFreezeAmount, Pct);
		}
		else if (StrEqual(ItemName[client], "spawn_timer", false))
		{
			SpawnTimer -= GetConVarInt(SpawnTimerSubtract);
			if (SpawnTimer < GetConVarInt(SpawnTimerMin)) SpawnTimer = GetConVarInt(SpawnTimerMin);
			SetConVarInt(FindConVar("z_ghost_delay_min"), SpawnTimer);
			SetConVarInt(FindConVar("z_ghost_delay_max"), SpawnTimer);
			PrintToInfected("%s \x01Spawn Timers reduced to \x05%d \x01second(s).", INFO, SpawnTimer);
		}
		else if (StrEqual(ItemName[client], "common_body_armour", false))
		{
			commonBodyArmour += GetConVarFloat(CommonBodyArmourAmount);
			PrintToInfected("%s \x01Common Body Armour Increased to \x05%3.1f\x01%s Damage Reduction.", INFO, commonBodyArmour * 100.0, Pct);
		}
		else if (StrEqual(ItemName[client], "more_commons", false))
		{
			moreCommonsAmount += GetConVarInt(MoreCommonsIncrement);
			SetConVarInt(FindConVar("z_common_limit"), moreCommonsAmount);
			PrintToInfected("%s \x01Common Infected have been increased to %d", INFO, moreCommonsAmount);
		}
		else if (StrEqual(ItemName[client], "survivor_realism", false))
		{
			SurvivorRealism = true;
			SetConVarInt(FindConVar("sv_disable_glow_faritems"), 1);
			if (!CommonHeadshots) SetConVarFloat(FindConVar("z_non_head_damage_factor_multiplier"), 0.05);
			SetConVarInt(FindConVar("z_head_damage_causes_wounds"), 1);
			SetConVarInt(FindConVar("z_use_next_difficulty_damage_factor"), 1);		
		}
		else if (StrEqual(ItemName[client], "charger_can_jump_while_carrying", false))
		{
			TUpgrade_CarryJump = true;
			PrintToInfected("%s \x01Chargers can press the \x03JUMP \x01key to jump while carrying survivors!", INFO);
		}
		else if (StrEqual(ItemName[client], "witch_limit", false))
		{
			witchMax += GetConVarInt(WitchMaximumIncrement);
			PrintToInfected("%s \x01Witch Limit has been increased to \x04%d", INFO, witchMax);
		}
		else if (StrEqual(ItemName[client], "common_inferno_immune", false))
		{
			bCommonFireImmune = true;
			PrintToInfected("%s \x01Common Infected are now \x04Immune \x01to Fire.", INFO);
		}
		else if (StrEqual(ItemName[client], "common_melee_immune", false))
		{
			bCommonMeleeImmune = true;
			PrintToInfected("%s \x01Common Infected are now \x04Immune \x01to Melee Weapons.", INFO);
		}
		else if (StrEqual(ItemName[client], "wandering_commons_limit", false))
		{
			wanderingCommonsAmount += GetConVarInt(WanderingCommonsIncrement);
			SetConVarInt(FindConVar("z_reserved_wanderers"), wanderingCommonsAmount);
			PrintToInfected("%s \x01Common Infected Wanderers have been increased to %d", INFO, wanderingCommonsAmount);
		}
	}
	else if (PurchaseItem[client] == 5)
	{
		if (StrEqual(ItemName[client], "hunter_tier2", false))
		{
			UpgradeHunter[client] = true;
			PrintToChat(client, "%s \x01Your hunter is now partially invisible at all times.", PURCHASE_INFO);
		}
		else if (StrEqual(ItemName[client], "smoker_tier2", false))
		{
			UpgradeSmoker[client] = true;
			PrintToChat(client, "%s \x01Your smoker now burns survivors.", PURCHASE_INFO);
		}
		else if (StrEqual(ItemName[client], "boomer_tier2", false))
		{
			UpgradeBoomer[client] = true;
			PrintToChat(client, "%s \x01Your boomer bile now blinds survivors.", PURCHASE_INFO);
		}
		else if (StrEqual(ItemName[client], "jockey_tier2", false))
		{
			UpgradeJockey[client] = true;
			PrintToChat(client, "%s \x01Your jockey now instant kills survivors it incaps (1 per life).", PURCHASE_INFO);
		}
		else if (StrEqual(ItemName[client], "charger_tier2", false))
		{
			UpgradeCharger[client] = true;
			PrintToChat(client, "%s \x01Your charger now blinds (temporarily) survivors hit during a charge.", PURCHASE_INFO);
		}
		else if (StrEqual(ItemName[client], "spitter_tier2", false))
		{
			UpgradeSpitter[client] = true;
			PrintToChat(client, "%s \x01Your spit now slows down survivors.", PURCHASE_INFO);
		}
		else if (StrEqual(ItemName[client], "hunter_tier3", false))
		{
			UpgradeHunter[client] = true;
			SuperUpgradeHunter[client] = true;
			PrintToChat(client, "%s \x01Survivors pounced lose their glow and become invisible, too!", PURCHASE_INFO);
		}
		else if (StrEqual(ItemName[client], "smoker_tier3", false))
		{
			UpgradeSmoker[client] = true;
			SuperUpgradeSmoker[client] = true;
			PrintToChat(client, "%s \x01You can now smoker whip! Primary attack, while below the ensnared survivor!", PURCHASE_INFO);
		}
		else if (StrEqual(ItemName[client], "boomer_tier3", false))
		{
			UpgradeBoomer[client] = true;
			SuperUpgradeBoomer[client] = true;
			PrintToChat(client, "%s \x01Your boomer becomes unstable! Being melee'd results in an instant explosion!", PURCHASE_INFO);
		}
		else if (StrEqual(ItemName[client], "jockey_tier3", false))
		{
			UpgradeJockey[client] = true;
			SuperUpgradeJockey[client] = true;
			PrintToChat(client, "%s \x01Make that survivor jump, press your jump key while riding!", PURCHASE_INFO);
		}
		else if (StrEqual(ItemName[client], "charger_tier3", false))
		{
			UpgradeCharger[client] = true;
			SuperUpgradeCharger[client] = true;
			PrintToChat(client, "%s \x01Your charger now charges %1.1f times faster!", PURCHASE_INFO, GetConVarFloat(ChargerSpeedIncrease));
		}
		else if (StrEqual(ItemName[client], "spitter_tier3", false))
		{
			UpgradeSpitter[client] = true;
			SuperUpgradeSpitter[client] = true;
			PrintToChat(client, "%s \x01Your spit now does an additional %d damage to survivors!", PURCHASE_INFO, GetConVarInt(SpitterDamageIncrease));
		}
		PersonalUpgrades[client]++;
	}
	if (InfectedTeamPurchase[client])
	{
		ItemCost[client] -= InfectedPoints[client];
		InfectedPoints[client] = 0.0;
		InfectedTeamPoints -= ItemCost[client];
		InfectedTeamPurchase[client] = false;
	}
	else InfectedPoints[client] -= ItemCost[client];
	if (ItemCost[client] > 0.0)
	{
		if (PurchaseItem[client] == 1) SpecialPurchaseValue[client] += GetConVarFloat(IncrementSpecialCost);
		if (PurchaseItem[client] == 2)
		{
			TankPurchaseValue[client] += (GetConVarFloat(IncrementTankCost) + Ta[client][2]);
		}
		if (PurchaseItem[client] == 3) UncommonPurchaseValue[client] += GetConVarFloat(IncrementUncommonCost);
		if (PurchaseItem[client] == 4) TeamUpgradesPurchaseValue[client] += GetConVarFloat(IncrementTeamUpgradesCost);
		if (PurchaseItem[client] == 5) PersonalUpgradesPurchaseValue[client] += GetConVarFloat(IncrementPersonalUpgradesCost);
	}
	PrintToChat(client, "%s Purchased %s", PURCHASE_INFO, ItemName[client]);
	if (PurchaseItem[client] == 1 || PurchaseItem[client] == 2)
	{
		PlayerZombieCheck(client);
		if (IsPlayerGhost(client)) Check_SpawnAnywhere(client);
	}
}

public ChangeZombieClass(client)
{
	decl zombieclass;
	zombieclass = GetEntProp(client, Prop_Send, "m_zombieClass");
	if (zombieclass == ZOMBIECLASS_TANK) return;
	
	if (StrEqual(ItemName[client], "Hunter", false)) ClassType[client] = 3;
	else if (StrEqual(ItemName[client], "Smoker", false)) ClassType[client] = 1;
	else if (StrEqual(ItemName[client], "Boomer", false)) ClassType[client] = 2;
	else if (StrEqual(ItemName[client], "Jockey", false)) ClassType[client] = 5;
	else if (StrEqual(ItemName[client], "Charger", false)) ClassType[client] = 6;
	else if (StrEqual(ItemName[client], "Spitter", false)) ClassType[client] = 4;
		
	new WeaponIndex;
	while ((WeaponIndex = GetPlayerWeaponSlot(client, 0)) != -1)
	{
		RemovePlayerItem(client, WeaponIndex);
		RemoveEdict(WeaponIndex);
	}
		
	SDKCall(g_hSetClass, client, ClassType[client]);
	AcceptEntityInput(MakeCompatEntRef(GetEntProp(client, Prop_Send, "m_customAbility")), "Kill");
	SetEntProp(client, Prop_Send, "m_customAbility", GetEntData(SDKCall(g_hCreateAbility, client), g_oAbility));
}