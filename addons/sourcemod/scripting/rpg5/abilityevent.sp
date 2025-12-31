_AbilityEvent_OnPluginStart()
{
	HookEvent("weapon_reload", Event_WeaponReload);
	HookEvent("ability_use", Event_AbilityUse);
}

/*			CONNECTIVITY EVENTS			*/

public Action:Event_WeaponReload(Handle:event, String:event_name[], bool:dontBroadcast)
{
	if (GetConVarInt(g_UnlimitedAmmo) == 0) return;
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!IsClientIndexOutOfRange(client) && IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == 2) ExecCheatCommand(client, "give", "ammo");
}

public Action:Event_AbilityUse(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || GetClientTeam(client) != 3 || 
	    (	!ClassHunter[client] && !ClassSpitter[client]	)) return;
	decl String:AbilityUsed[64];
	GetEventString(event, "ability", AbilityUsed, sizeof(AbilityUsed));
	
	if (StrContains(AbilityUsed, "lunge", true) > -1)
	{
		GetClientAbsOrigin(client, Float:StartPounceLocation[client]);
	}
	if (StrContains(AbilityUsed, "spit", true) > -1 && SuperUpgradeSpitter[client])
	{
		CreateTimer(0.2, SetInvisState, client);
	}
}

public Action:SetInvisState(Handle:timer, any:client)
{
	SetEntityRenderMode(client, RENDER_TRANSCOLOR);
	SetEntityRenderColor(client, GetConVarInt(InfectedTier3Color[0]), GetConVarInt(InfectedTier3Color[1]), GetConVarInt(InfectedTier3Color[2]), 0);
	SetEntProp(client, Prop_Data, "m_takedamage", 1, 1);
	CreateTimer(GetConVarFloat(SpitterInvisTime), RemoveSpitterInvis, client);
}

public Action:Timer_AllowGhostSwap(Handle:timer, any:client)
{
	bGhostSwap[client] = false;
	return Plugin_Stop;
}

public Action:OnPlayerRunCmd(client, &buttons)
{
	if (!IsClientIndexOutOfRange(client) && !IsFakeClient(client) && IsPlayerGhost(client) && !bGhostSwap[client] && (buttons & IN_ATTACK2))
	{
		// We let players change their ghost class for free, so we rotate if they press mouse2

		bGhostSwap[client] = true;
		CreateTimer(GetConVarFloat(g_GhostSwapDelay), Timer_AllowGhostSwap, client, TIMER_FLAG_NO_MAPCHANGE);

		new Class = GetEntProp(client, Prop_Send, "m_zombieClass");
		if (Class == ZOMBIECLASS_SMOKER) ItemName[client] = "Charger";
		else if (Class == ZOMBIECLASS_BOOMER) ItemName[client] = "Smoker";
		else if (Class == ZOMBIECLASS_HUNTER) ItemName[client] = "Boomer";
		else if (Class == ZOMBIECLASS_SPITTER) ItemName[client] = "Hunter";
		else if (Class == ZOMBIECLASS_JOCKEY) ItemName[client] = "Spitter";
		else if (Class == ZOMBIECLASS_CHARGER) ItemName[client] = "Jockey";

		ChangeZombieClass(client);
	}
	//if (IsClientIndexOutOfRange(client) || (!ClassJockey[client] && !GravityBoots[client] && !ClassSmoker[client] && !ClassCharger[client])) return;
	decl Float:vel_z;
	vel_z = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
	new Class = GetEntProp(client, Prop_Send, "m_zombieClass");
	//if (ClassJockey[client])
	if (Class == ZOMBIECLASS_JOCKEY)
	{
		if (GetEntityFlags(client) & FL_ONGROUND) JockeyJumping[client] = false;
		if ((buttons & IN_ATTACK) && (vel_z == 0.0) && !JockeyJumping[client])
		{
			JockeyJumping[client] = true;
			GetClientAbsOrigin(client, StartingJockeyLocation[client]);
		}
		else if ((SuperUpgradeJockey[client] || Jo[client][2] >= GetConVarInt(InfectedTier3Level)) && !JockeyJumpCooldown[client] && (buttons & IN_JUMP))
		{
			JockeyJumpCooldown[client] = true;
			CreateTimer(2.0, RemoveJockeyJump, client, TIMER_FLAG_NO_MAPCHANGE);
			CallJockeyJump(client);
		}
	}
	else if (GravityBoots[client] && !CoveredInBile[client] && !HeavyBySpit[client] && !BrokenLegs[client] && (GetEntityFlags(client) & FL_ONGROUND))
	{
		if (Ensnared[client])
		{
			if (L4D2_GetInfectedAttacker(client) == -1) Ensnared[client] = false;
		}
		if ((buttons & IN_JUMP) && GravityBoots[client] > 0 && !Ensnared[client])
		{
			// Check if vertical velocity is 0. If it isn't they're falling.
			new Float:vel;
			vel = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
			if (vel > 0.0) return;
			new number = GetRandomInt(GetConVarInt(PersonalAbilityLossMin), GetConVarInt(PersonalAbilityLossMax));
			GravityBoots[client] -= number;
			if (GravityBoots[client] < 1)
			{
				PrintToChat(client, "%s \x01Your Gravity Boots run out of super fuel.", INFO);
				GravityBoots[client] = 0;
			}
			SetEntityGravity(client, GetConVarFloat(GravityBootsGravity));
			CreateTimer(0.5, CheckForGrounding, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	else if (ClassSmoker[client])
	{
		if ((buttons & IN_ATTACK) && (SuperUpgradeSmoker[client] || Sm[client][2] >= GetConVarInt(InfectedTier3Level)) && !SmokerWhipCooldown[client])
		{
			SmokerWhipCooldown[client] = true;
			CreateTimer(3.0, RemoveSmokerWhip, client, TIMER_FLAG_NO_MAPCHANGE);
			CallSmokerWhip(client);
		}
	}
	else if (ClassCharger[client] && TUpgrade_CarryJump && ChargerCanJump[client] && 
			!ChargerIsJumping[client] && (GetEntityFlags(client) & FL_ONGROUND) && (buttons & IN_JUMP) && (vel_z == 0.0) && !ChargerJumpCooldown[client])
	{
		// If charger, upgrade purchases, allowed to jump, not currently jumping, on solid ground, and jump key is pressed down, and vertical velocity is 0 (not falling/jumping)...
		CallChargerJump(client);
		ChargerJumpCooldown[client] = true;
		CreateTimer(GetConVarFloat(ChargerJumpCooldownTime), Timer_EnableChargerJump, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}

CallChargerJump(client)
{
	new victim = ChargerCarryVictim[client];
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim) || IsFakeClient(victim) || !IsPlayerAlive(victim)) return;
	new Float:vel[3];
	vel[0] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[0]");
	vel[1] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[1]");
	vel[2] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[2]");
	new Float:velo[3];
	velo[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
	velo[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
	velo[2] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
	if (!IsFakeClient(client))
	{
		vel[2] += (GetConVarFloat(ChargerCarryJumpForce) + (Ch[client][2] * GetConVarFloat(ChargerJumpPerLevel)));
		velo[2] += (GetConVarFloat(ChargerCarryJumpForce) + (Ch[client][2] * GetConVarFloat(ChargerJumpPerLevel)));
	}
	else
	{
		vel[2] += (GetConVarFloat(ChargerCarryJumpForce) + (AICharger[2] * GetConVarFloat(ChargerJumpPerLevel)));
		velo[2] += (GetConVarFloat(ChargerCarryJumpForce) + (AICharger[2] * GetConVarFloat(ChargerJumpPerLevel)));
	}
	TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, vel);
	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, velo);
}

public Action:Timer_EnableChargerJump(Handle:timer, any:client)
{
	if (!IsClientInGame(client) || IsFakeClient(client)) return Plugin_Stop;
	ChargerJumpCooldown[client] = false;
	return Plugin_Stop;
}

CallJockeyJump(client)
{
	new victim = JockeyVictim[client];
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim) || IsFakeClient(victim) || !IsPlayerAlive(victim) || !IsRiding[client] || !Ensnared[victim]) return;
	new Float:vel[3];
	vel[0] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[0]");
	vel[1] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[1]");
	vel[2] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[2]");
	new Float:velo[3];
	velo[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
	velo[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
	velo[2] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
	if (!IsFakeClient(client))
	{
		vel[2] += GetConVarFloat(JockeyRideJumpForce) + (GetConVarFloat(RideJumpForceLevel) * Jo[client][2]);
		velo[2] += GetConVarFloat(JockeyRideJumpForce) + (GetConVarFloat(RideJumpForceLevel) * Jo[client][2]);
	}
	else
	{
		vel[2] += GetConVarFloat(JockeyRideJumpForce) + (GetConVarFloat(RideJumpForceLevel) * AIJockey[2]);
		velo[2] += GetConVarFloat(JockeyRideJumpForce) + (GetConVarFloat(RideJumpForceLevel) * AIJockey[2]);
	}
	TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, vel);
	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, velo);
}

CallSmokerWhip(client)
{
	new victim = SmokeVictim[client];
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim) || IsFakeClient(victim) || !IsPlayerAlive(victim) || !IsSmoking[client] || !Ensnared[victim]) return;
	new Float:pullrand;
	new Float:lungerand;
	new pullnumber = GetRandomInt(1, 2);
	new lungenumber = GetRandomInt(1, 2);
	new Float:vel[3];
	vel[0] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[0]");
	vel[1] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[1]");
	vel[2] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[2]");
	new Float:whipforce;
	if (!IsFakeClient(client))
	{
		whipforce = GetRandomFloat(GetConVarFloat(SmokerWhipForceMin) + (GetConVarFloat(SmokerWhipForceLevel) * Sm[client][2]), GetConVarFloat(SmokerWhipForceMax) + (GetConVarFloat(SmokerWhipForceLevel) * Sm[client][2]));
	}
	else
	{
		whipforce = GetRandomFloat(GetConVarFloat(SmokerWhipForceMin) + (GetConVarFloat(SmokerWhipForceLevel) * AISmoker[2]), GetConVarFloat(SmokerWhipForceMax) + (GetConVarFloat(SmokerWhipForceLevel) * AISmoker[2]));
	}
	vel[2] += whipforce;
	if (pullnumber == 1) pullrand = GetRandomFloat(GetConVarFloat(SmokerWhipMin1), GetConVarFloat(SmokerWhipMin2));
	else pullrand = GetRandomFloat(GetConVarFloat(SmokerWhipMax1), GetConVarFloat(SmokerWhipMax2));
	if (lungenumber == 1) lungerand = GetRandomFloat(GetConVarFloat(SmokerWhipPullMin1), GetConVarFloat(SmokerWhipPullMin2));
	else lungerand = GetRandomFloat(GetConVarFloat(SmokerWhipPullMax1), GetConVarFloat(SmokerWhipPullMax2));
	
	if (pullrand < 0.0 && vel[0] > 0.0)
	{
		vel[0] *= -1.0;
	}
	vel[0] += pullrand;
	if (lungerand < 0.0 && vel[1] > 0.0)
	{
		vel[1] *= -1.0;
	}
	vel[1] += lungerand;
	
	TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, vel);
}

public OnEntityCreated(entity, const String:classname[])
{	
	if(StrEqual(classname, "infected", false) && UncommonType != 0)
	{
		if (UncommonType == 1 || UncommonType == 4) SetEntityModel(entity, "models/infected/common_male_mud.mdl");
		if (UncommonType == 2 || UncommonType == 5) SetEntityModel(entity, "models/infected/common_male_jimmy.mdl");
		else if (UncommonType == 3 || UncommonType == 6) SetEntityModel(entity, "models/infected/common_male_riot.mdl");
		else if (UncommonType == 4 || UncommonType == 8) SetEntityModel(entity, "models/infected/common_male_roadcrew.mdl");
		else if (UncommonType == 9)
		{
			// Uncommon Panic Event! A bunch of random uncommons!
			new number = GetRandomInt(1, 4);
			if (number == 1) SetEntityModel(entity, "models/infected/common_male_mud.mdl");
			else if (number == 2) SetEntityModel(entity, "models/infected/common_male_jimmy.mdl");
			else if (number == 3) SetEntityModel(entity, "models/infected/common_male_riot.mdl");
			else if (number == 4) SetEntityModel(entity, "models/infected/common_male_roadcrew.mdl");
		}
		UncommonRemaining--;
		if (UncommonRemaining < 1)
		{
			UncommonRemaining = 0;
			UncommonType = 0;
		}
	}
	else if (StrEqual(classname, "infected", false) && UncommonRemaining < 1)
	{
		if (IsCommon(entity)) SDKHook(entity, SDKHook_OnTakeDamage, OnTakeDamage);
		else SDKUnhook(entity, SDKHook_OnTakeDamage, OnTakeDamage);
	}
}

public IsCommon(entity)
{
	decl String:sTemp[64];
	GetEntPropString(entity, Prop_Data, "m_ModelName", sTemp, sizeof(sTemp));

	// If the infected is not a special infected, and not a riot cop...
	if (StrContains(sTemp, "models/infected/common", false)) return true;
	return false;
}

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
	// Melee weapons are currently overpowered. We want to set them to do damage based on their level.
	// Melee damage bonus still goes through on the damage event.
	// So if you're melee level 20, you'll do 20 damage per hit + 20 damage for your level, melee level 20: 40 damage
	// Only affects special infected
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && GetClientTeam(attacker) == 2 && !IsFakeClient(attacker) && 
		!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && GetClientTeam(victim) == 3)
	{
		new String:weapon[64];
		GetClientWeapon(attacker, weapon, sizeof(weapon));
		if (StrEqual(weapon, "weapon_melee", true))
		{
			damage = (GetConVarFloat(g_MeleeDamageReduction) * Me[attacker][2]);
			return Plugin_Changed;
		}
	}

	// If the player is an infected player who meets the requirements to be immune to fire
	// we need to make sure they never take the damage.
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && GetClientTeam(victim) == 2)
	{
		// At some point I'll be using this to give survivors an upgrade of some sorts.
		// Until then, let's just continue.
		return Plugin_Continue;
	}
	else if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && GetClientTeam(victim) == 3)
	{
		// If the damagetype is fire, or burn, or fire bullets, we nullify the damage.
		// If it isn't, we tell the plugin to continue.
		// The reason we continue instead of checking the other statements is this ticks each time anything takes damage.
		// If it's a human player, we don't want to nullify damage through the other statements.
		return Plugin_Continue;
	}
	if (bCommonFireImmune)
	{
		if (damagetype == 8 || damagetype == 2056 || damagetype == 268435464)
		{
			damage = 0.0;
			return Plugin_Changed;
		}
	}
	if (bCommonMeleeImmune)
	{
		if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && GetClientTeam(attacker) == 2)
		{
			new String:weaponused[64];
			GetClientWeapon(attacker, weaponused, sizeof(weaponused));
			if (StrEqual(weaponused, "weapon_melee", true))
			{
				damage = GetConVarFloat(CommonMeleeDamageResistance);
				return Plugin_Changed;
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