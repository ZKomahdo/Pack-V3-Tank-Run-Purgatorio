public Events_AbilityUse()
{
	HookEvent("weapon_reload", Event_WeaponReload);
	HookEvent("ability_use", Event_AbilityUse);
}

public Action:Event_WeaponReload(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_SURVIVORS)
	{
		ExecCheatCommand(attacker, "give", "ammo");
	}
}

public Action:Event_AbilityUse(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client						= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(client) && IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == TEAM_INFECTED && 
		(classHunter[client] || classSpitter[client]))
	{
		decl String:ability[64];
		GetEventString(event, "ability", ability, sizeof(ability));

		if (StrContains(ability, "lunge", true) > -1) GetClientAbsOrigin(client, Float:pounceLocationStart[client]);
		else if (StrContains(ability, "spit", true) > -1 && spitProtectionTime > 0.0)
		{
			SetEntityRenderMode(client, RENDER_TRANSCOLOR);
			SetEntityRenderColor(client, 255, 255, 255, 0);
			SetEntProp(client, Prop_Data, "m_takedamage", 1, 1);
			CreateTimer(spitProtectionTime, Timer_RemoveSpitProtection, client, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public Action:OnPlayerRunCmd(client, &buttons)
{
	if (!IsClientIndexOutOfRange(client) && IsClientInGame(client) && !IsFakeClient(client))
	{
		decl Float:vel_z;
		vel_z = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
		if (classCharger[client] && bCharging[client] && bChargerJump && (buttons & IN_JUMP) && 
			vel_z == 0.0)
		{
			JumpCharger(client);
		}
		if (classSmoker[client] && isSmoking[client] && smokerVictim[client] != -1 && bSmokerWhip && (buttons && IN_ATTACK))
		{
			SmokerWhip(client);
		}
		if (classJockey[client])
		{
			if (vel_z == 0.0 && bJockeyJump && bRiding[client] && (buttons & IN_JUMP))
			{
				JockeyRideJump(client);
			}
			else if (vel_z == 0.0 && !bRiding[client] && (buttons & IN_ATTACK))
			{
				GetClientAbsOrigin(client, jumpLocationStart[client]);
				bJumping[client] = true;
			}
		}
	}
}

public SmokerWhip(client)
{
	if (bJumpCooldown[client]) return;

	new victim = smokerVictim[client];
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		new Float:pullAmount;
		new Float:pushAmount;
		new pullChance = GetRandomInt(1, 2);
		new pushChance = GetRandomInt(1, 2);

		new Float:vel[3];
		vel[0] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[0]");
		vel[1] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[1]");
		vel[2] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[2]");

		new Float:whipVelocity = GetRandomFloat(GetConVarFloat(Value_SmokerWhipMinimum), GetConVarFloat(Value_SmokerWhipMaximum));
		vel[2] += whipVelocity;

		if (pullChance == 1) pullAmount = GetRandomFloat(GetConVarFloat(Value_SmokerWhipPullMinimum1), GetConVarFloat(Value_SmokerWhipPullMaximum1));
		else pullAmount = GetRandomFloat(GetConVarFloat(Value_SmokerWhipPullMinimum2), GetConVarFloat(Value_SmokerWhipPullMaximum2));

		if (pushChance == 1) pushAmount = GetRandomFloat(GetConVarFloat(Value_SmokerWhipPushMinimum1), GetConVarFloat(Value_SmokerWhipPushMaximum1));
		else pushAmount = GetRandomFloat(GetConVarFloat(Value_SmokerWhipPushMinimum2), GetConVarFloat(Value_SmokerWhipPushMaximum2));

		if (pullAmount < 0.0 && vel[0] > 0.0) vel[0] *= -1.0;
		vel[0] += pullAmount;
		if (pushAmount < 0.0 && vel[1] > 0.0) vel[1] *= -1.0;
		vel[1] += pushAmount;

		TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, vel);
		bJumpCooldown[client] = true;

		CreateTimer(GetConVarFloat(Time_SmokerWhipCooldown), Timer_EnableChargeJump, client, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public JockeyRideJump(client)
{
	if (bJumpCooldown[client]) return;
	
	new Float:vel[3];
	vel[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
	vel[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
	vel[2] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
	vel[2] += GetConVarFloat(Value_JockeyJumpHeight);
	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vel);
	new Float:velo[3];
	velo[0] = GetEntPropFloat(jockeyVictim[client], Prop_Send, "m_vecVelocity[0]");
	velo[1] = GetEntPropFloat(jockeyVictim[client], Prop_Send, "m_vecVelocity[1]");
	velo[2] = GetEntPropFloat(jockeyVictim[client], Prop_Send, "m_vecVelocity[2]");
	velo[2] += GetConVarFloat(Value_JockeyJumpHeight);
	TeleportEntity(jockeyVictim[client], NULL_VECTOR, NULL_VECTOR, velo);
	
	bJumpCooldown[client] = true;
	CreateTimer(GetConVarFloat(Time_JockeyJumpHeight), Timer_EnableChargeJump, client, TIMER_FLAG_NO_MAPCHANGE);
}

public JumpCharger(client)
{
	if (bJumpCooldown[client]) return;
	if (chargeVictim[client] == -1)
	{
		new Float:vel[3];
		vel[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
		vel[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
		vel[2] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
		vel[2] += GetConVarFloat(Value_ChargeJumpHeight);
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vel);
	}
	else
	{
		new Float:vel[3];
		vel[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
		vel[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
		vel[2] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
		vel[2] += GetConVarFloat(Value_ChargeJumpHeight);
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vel);
		new Float:velo[3];
		velo[0] = GetEntPropFloat(chargeVictim[client], Prop_Send, "m_vecVelocity[0]");
		velo[1] = GetEntPropFloat(chargeVictim[client], Prop_Send, "m_vecVelocity[1]");
		velo[2] = GetEntPropFloat(chargeVictim[client], Prop_Send, "m_vecVelocity[2]");
		velo[2] += GetConVarFloat(Value_ChargeJumpHeight);
		TeleportEntity(chargeVictim[client], NULL_VECTOR, NULL_VECTOR, velo);
	}
	bJumpCooldown[client] = true;
	CreateTimer(GetConVarFloat(Time_ChargeJumpHeight), Timer_EnableChargeJump, client, TIMER_FLAG_NO_MAPCHANGE);
}

public StrafeChargerLeft(client)
{
	if (chargeVictim[client] == -1)
	{
		new Float:vel[3];
		vel[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
		vel[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
		vel[2] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
		vel[0]--;
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vel);
	}
	else
	{
		new Float:vel[3];
		vel[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
		vel[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
		vel[2] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
		vel[0]--;
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vel);
		new Float:velo[3];
		velo[0] = GetEntPropFloat(chargeVictim[client], Prop_Send, "m_vecVelocity[0]");
		velo[1] = GetEntPropFloat(chargeVictim[client], Prop_Send, "m_vecVelocity[1]");
		velo[2] = GetEntPropFloat(chargeVictim[client], Prop_Send, "m_vecVelocity[2]");
		velo[0]--;
		TeleportEntity(chargeVictim[client], NULL_VECTOR, NULL_VECTOR, velo);
	}
}

public StrafeChargerRight(client)
{
	if (chargeVictim[client] == -1)
	{
		new Float:vel[3];
		vel[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
		vel[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
		vel[2] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
		vel[0]++;
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vel);
	}
	else
	{
		new Float:vel[3];
		vel[0] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[0]");
		vel[1] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[1]");
		vel[2] = GetEntPropFloat(client, Prop_Send, "m_vecVelocity[2]");
		vel[0]++;
		TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vel);
		new Float:velo[3];
		velo[0] = GetEntPropFloat(chargeVictim[client], Prop_Send, "m_vecVelocity[0]");
		velo[1] = GetEntPropFloat(chargeVictim[client], Prop_Send, "m_vecVelocity[1]");
		velo[2] = GetEntPropFloat(chargeVictim[client], Prop_Send, "m_vecVelocity[2]");
		velo[0]++;
		TeleportEntity(chargeVictim[client], NULL_VECTOR, NULL_VECTOR, velo);
	}
}