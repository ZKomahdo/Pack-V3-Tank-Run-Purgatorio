public OnEntityCreated(entity, const String:classname[])
{
	if (StrEqual(classname, "infected", false) && uncommonRemaining > 0)
	{
		if (uncommonPanicEvent) uncommonType = GetRandomInt(1, 4);
		if (uncommonType == 1) SetEntityModel(entity, MODEL_MUDMEN);
		if (uncommonType == 2) SetEntityModel(entity, MODEL_JIMMY);
		if (uncommonType == 3) SetEntityModel(entity, MODEL_RIOTCOPS);
		if (uncommonType == 4) SetEntityModel(entity, MODEL_ROADKREW);
		uncommonRemaining--;
	}
	else if (StrEqual(classname, "infected", false) && uncommonRemaining < 1)
	{
		if (IsCommon(entity)) SDKHook(entity, SDKHook_OnTakeDamage, OnTakeDamage_Commons);
		else SDKUnhook(entity, SDKHook_OnTakeDamage, OnTakeDamage_Commons);
	}
	if (uncommonRemaining < 1 && uncommonPanicEvent)
	{
		uncommonPanicEvent = false;
		summonZombieCooldown = 0.0;
		PrintToSurvivors("%s - \x01Summon Zombie purchases may now be used.", INFO_GENERAL);
	}
}

public IsCommon(entity)
{
	decl String:sTemp[64];
	GetEntPropString(entity, Prop_Data, "m_ModelName", sTemp, sizeof(sTemp));

	// If the infected is not a special infected, and not a riot cop...
	if (!StrEqual(sTemp, MODEL_MUDMEN) && 
		!StrEqual(sTemp, MODEL_JIMMY) && 
		!StrEqual(sTemp, MODEL_RIOTCOPS) && 
		!StrEqual(sTemp, MODEL_ROADKREW)) return true;
	return false;
}

public Action:OnTakeDamage_Commons(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
	if (bCommonFireImmune && (damagetype == 8 || damagetype == 2056 || damagetype == 268435464))
	{
		damage = 0.0;
		return Plugin_Handled;
	}
	if (bCommonMeleeImmune)
	{
		if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && GetClientTeam(attacker) == 2)
		{
			new String:weaponused[64];
			GetClientWeapon(attacker, weaponused, sizeof(weaponused));
			if (StrEqual(weaponused, "weapon_melee", true))
			{
				damage = 0.0;
				return Plugin_Handled;
			}
		}
	}
	if (commonBodyArmour > 0.0)
	{
		// Common have body armour, so we need to change the damage value they receive.
		damage = damage * (1.0 - commonBodyArmour);
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == 2)
	{
		if (pillsJunkie[victim])
		{
			damage *= GetConVarFloat(Ability_PillsUse);
			return Plugin_Changed;
		}
	}
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == 3)
	{
		if (bSpecialFireImmune && (damagetype == 8 || damagetype == 2056 || damagetype == 268435464))
		{
			damage = 0.0;
			return Plugin_Handled;
		}
		if (adrenalineJunkie[attacker])
		{
			damage *= GetConVarFloat(Ability_AdrenalineUse);
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}