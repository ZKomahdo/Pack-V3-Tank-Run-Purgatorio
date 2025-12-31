public Events_InfectedStart()
{
	HookEvent("player_now_it", Event_PlayerNowIt);

	HookEvent("lunge_pounce", Event_LungePounce);
	HookEvent("pounce_stopped", Event_PounceStopped);

	HookEvent("jockey_ride", Event_JockeyRide);
	HookEvent("jockey_ride_end", Event_JockeyRideEnd);

	HookEvent("charger_charge_start", Event_ChargeStart);
	HookEvent("charger_charge_end", Event_ChargeEnd);
	HookEvent("charger_pummel_end", Event_ChargerPummelEnd);
	HookEvent("charger_carry_start", Event_ChargerCarryStart);
	HookEvent("charger_carry_end", Event_ChargerCarryEnd);

	HookEvent("tongue_grab", Event_TongueGrab);
	HookEvent("tongue_release", Event_TongueRelease);
	HookEvent("tongue_pull_stopped", Event_TonguePullStopped);
	HookEvent("choke_start", Event_ChokeStart);
	HookEvent("choke_stopped", Event_TonguePullStopped);
}

public Action:Event_PlayerNowIt(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "attacker"));
	new victim						= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED && 
		!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		playerPoints[attacker][1] += (GetConVarFloat(Enhancement_InfectedTouch) * survivorMultiplier[victim]);
		if (GetConVarInt(PointsNotice) == 1) PrintToChat(attacker, "%s - \x01Survivor Contact: \x05%3.2f Point(s).", INFO_GENERAL, GetConVarFloat(Enhancement_InfectedTouch) * survivorMultiplier[victim]);

		theBoomer[victim] = attacker;
		bileCovered[victim] = true;
		bilePoints[victim] = 0.0;
		CreateTimer(GetConVarFloat(Ability_BilePointsTime), Timer_DisableBilePoints, victim, TIMER_FLAG_NO_MAPCHANGE);

		if (bBlindingBile)
		{
			BlindPlayer(victim, GetConVarInt(Effect_BlindAmmo));
			CreateTimer(GetConVarFloat(Ability_BilePointsTime), Timer_DisableBlindBile, victim, TIMER_FLAG_NO_MAPCHANGE);
		}
		if (bSlowingBile)
		{
			SetEntDataFloat(victim, laggedMovementOffset, GetConVarFloat(Enhancement_BileSlowAmount), true);
			CreateTimer(GetConVarFloat(Ability_BilePointsTime), Timer_DisableSlowBile, victim, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public Action:Event_LungePounce(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED)
	{
		new Float:pounceLocationEnd[3];
		GetClientAbsOrigin(attacker, pounceLocationEnd);

		new Float:pounceDistance = GetVectorDistance(pounceLocationStart[attacker], pounceLocationEnd);
		pounceDistance *= GetConVarFloat(Distance_HunterPounce);
		if (pounceDistance > 0.0)
		{
			playerPoints[attacker][1] += pounceDistance;
			if (GetConVarInt(PointsNotice) == 1) PrintToChat(attacker, "%s - \x01Survivor Contact: \x05%3.2f Point(s).", INFO_GENERAL, pounceDistance);
		}

		new victim					= GetClientOfUserId(GetEventInt(event, "victim"));
		if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
		{
			ensnared[victim] = true;
		}
	}
}

public Action:Event_PounceStopped(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_SURVIVORS)
	{
		playerPoints[attacker][0] += (GetConVarFloat(Enhancement_Helper) * survivorMultiplier[attacker]);
		if (GetConVarInt(PointsNotice) == 1) PrintToChat(attacker, "%s - \x01Helped a teammate: \x05%3.2f Point(s).", INFO_GENERAL, GetConVarFloat(Enhancement_Helper) * survivorMultiplier[attacker]);
	}

	new victim						= GetClientOfUserId(GetEventInt(event, "victim"));
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		ensnared[victim] = false;
	}
}

public Action:Event_JockeyRide(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));
	new victim						= GetClientOfUserId(GetEventInt(event, "victim"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED)
	{
		if (bJumping[attacker])
		{
			bJumping[attacker] = false;
			new Float:jumpLocationEnd[3];
			GetClientAbsOrigin(attacker, jumpLocationEnd);
			new Float:jumpDistance = GetVectorDistance(jumpLocationStart[attacker], jumpLocationEnd);
			jumpDistance *= GetConVarFloat(Distance_JockeyPounce);
			if (jumpDistance > 0.0)
			{
				playerPoints[attacker][1] += jumpDistance;
				if (GetConVarInt(PointsNotice) == 1) PrintToChat(attacker, "%s - \x01Survivor Contact: \x05%3.2f Point(s).", INFO_GENERAL, jumpDistance);
			}
		}
		ridePoints[attacker] = GetTime();
	}
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		ensnared[victim] = true;
	}
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED && 
		!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		bRiding[attacker] = true;
		jockeyVictim[attacker] = victim;
		jockey[victim] = attacker;

		if (bJockeyBlind)
		{
			BlindPlayer(victim, GetConVarInt(Effect_BlindAmmo));
		}
	}
}

public Action:Event_JockeyRideEnd(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new victim						= GetClientOfUserId(GetEventInt(event, "victim"));

	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		if (bJockeyBlind)
		{
			BlindPlayer(victim, 0);
		}
		ensnared[victim] = false;

		new attacker				= jockey[victim];
		if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED)
		{
			ridePoints[attacker] = GetTime() - ridePoints[attacker];
			playerPoints[attacker][1] += ridePoints[attacker];
			if (GetConVarInt(PointsNotice) == 1) PrintToChat(attacker, "%s - \x01Survivor Contact Length: \x05%d Point(s).", INFO_GENERAL, ridePoints[attacker]);
			bRiding[attacker] = false;
			
			if (bJockeyBerserk && !bBerserk[attacker] && ridePoints[attacker] > GetConVarInt(Time_BerserkRequirement))
			{
				CreateTimer(0.1, Timer_JockeyBerserkCheck, victim, TIMER_FLAG_NO_MAPCHANGE);
			}
			ridePoints[attacker] = 0;
		}

		new rescuer					= GetClientOfUserId(GetEventInt(event, "rescuer"));
		if (!IsClientIndexOutOfRange(rescuer) && IsClientInGame(rescuer) && !IsFakeClient(rescuer) && GetClientTeam(rescuer) == TEAM_SURVIVORS)
		{
			playerPoints[rescuer][0] += (GetConVarFloat(Enhancement_Helper) * survivorMultiplier[rescuer]);
			if (GetConVarInt(PointsNotice) == 1) PrintToChat(rescuer, "%s - \x01Helped a teammate: \x05%3.2f Point(s).", INFO_GENERAL, GetConVarFloat(Enhancement_Helper) * survivorMultiplier[rescuer]);
		}
	}
}

public Action:Event_ChargeStart(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED)
	{
		bCharging[attacker] = true;
		SetEntDataFloat(attacker, laggedMovementOffset, chargeSpeed, true);
	}
}

public Action:Event_ChargeEnd(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED)
	{
		bCharging[attacker] = false;
		chargeVictim[attacker] = -1;
		SetEntDataFloat(attacker, laggedMovementOffset, 1.0, true);
	}
}

public Action:Event_ChargerPummelEnd(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new victim						= GetClientOfUserId(GetEventInt(event, "victim"));

	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		ensnared[victim] = false;

		if (chargeVolley > 0)
		{
			new chance = GetRandomInt(1, 100);
			if (chance <= chargeVolley)
			{
				new Float:vel[3];
				vel[0] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[0]");
				vel[1] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[1]");
				vel[2] = GetEntPropFloat(victim, Prop_Send, "m_vecVelocity[2]");
				vel[2] += GetConVarFloat(Amount_ChargeVolley);
				TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, vel);
			}
		}
	}
}

public Action:Event_ChargerCarryStart(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));
	new victim						= GetClientOfUserId(GetEventInt(event, "victim"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED)
	{
		GetClientAbsOrigin(attacker, chargeLocationStart[attacker]);
	}
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED && 
		!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		chargeVictim[attacker] = victim;
		playerPoints[attacker][1] += (GetConVarFloat(Enhancement_InfectedTouch) * survivorMultiplier[victim]);
		if (GetConVarInt(PointsNotice) == 1) PrintToChat(attacker, "%s - \x01Survivor Contact: \x05%3.2f Point(s).", INFO_GENERAL, GetConVarFloat(Enhancement_InfectedTouch) * survivorMultiplier[victim]);
	}
}

public Action:Event_ChargerCarryEnd(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED)
	{
		new Float:chargeLocationEnd[3];
		GetClientAbsOrigin(attacker, chargeLocationEnd);
		new Float:chargeDistance = GetVectorDistance(chargeLocationStart[attacker], chargeLocationEnd);
		chargeDistance *= GetConVarFloat(Distance_ChargeCarry);
		if (chargeDistance > 0.0)
		{
			playerPoints[attacker][1] += chargeDistance;
			if (GetConVarInt(PointsNotice) == 1) PrintToChat(attacker, "%s - \x01Survivor Contact Length: \x05%3.2f Point(s).", INFO_GENERAL, chargeDistance);
		}
	}
}

public Action:Event_TongueGrab(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));
	new victim						= GetClientOfUserId(GetEventInt(event, "victim"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED)
	{
		isSmoking[attacker] = true;
	}

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED && 
		!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		smokerVictim[attacker] = victim;
		GetClientAbsOrigin(victim, smokeLocationStart[victim]);

		playerPoints[attacker][1] += (GetConVarFloat(Enhancement_InfectedTouch) * survivorMultiplier[victim]);
		if (GetConVarInt(PointsNotice) == 1) PrintToChat(attacker, "%s - \x01Survivor Contact: \x05%3.2f Point(s).", INFO_GENERAL, GetConVarFloat(Enhancement_InfectedTouch) * survivorMultiplier[victim]);
	}

	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		ensnared[victim] = true;
	}
}

public Action:Event_TongueRelease(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));
	new victim						= GetClientOfUserId(GetEventInt(event, "victim"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED)
	{
		isSmoking[attacker] = false;
	}
	
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED && 
		!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		smokerVictim[attacker] = -1;
		new Float:smokeLocationEnd[3];
		GetClientAbsOrigin(victim, smokeLocationEnd);
		new Float:smokeDistance = GetVectorDistance(smokeLocationStart[victim], smokeLocationEnd);
		smokeDistance *= GetConVarFloat(Distance_Smoker);

		if (smokeDistance > 0.0)
		{
			playerPoints[attacker][1] += smokeDistance;
			if (GetConVarInt(PointsNotice) == 1) PrintToChat(attacker, "%s - \x01Survivor Contact Length: \x05%3.2f Point(s).", INFO_GENERAL, smokeDistance);
		}
	}

	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		ensnared[victim] = false;
	}
}

public Action:Event_TonguePullStopped(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new rescuer						= GetClientOfUserId(GetEventInt(event, "userid"));
	new victim						= GetClientOfUserId(GetEventInt(event, "victim"));
	new smoker						= GetClientOfUserId(GetEventInt(event, "smoker"));

	if (!IsClientIndexOutOfRange(smoker) && IsClientInGame(smoker) && !IsFakeClient(smoker) && GetClientTeam(smoker) == TEAM_INFECTED)
	{
		isSmoking[smoker] = false;
	}

	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		ensnared[victim] = false;
	}

	new type						= GetEventInt(event, "release_type");
	if (type != 4 && type != 2) return;

	if (!IsClientIndexOutOfRange(rescuer) && IsClientInGame(rescuer) && !IsFakeClient(rescuer) && GetClientTeam(rescuer) == TEAM_SURVIVORS && 
		!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		if (GetConVarInt(InfoNotice) == 1) PrintToChat(victim, "%s - \x01Helped By: \x05%N.", INFO_GENERAL, rescuer);
		playerPoints[rescuer][0] += (GetConVarFloat(Enhancement_Helper) * survivorMultiplier[rescuer]);
		if (GetConVarInt(PointsNotice) == 1) PrintToChat(rescuer, "%s - \x01Helped a teammate: \x05%3.2f Point(s).", INFO_GENERAL, GetConVarFloat(Enhancement_Helper) * survivorMultiplier[rescuer]);
	}
}

public Action:Event_ChokeStart(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));
	new victim						= GetClientOfUserId(GetEventInt(event, "victim"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED)
	{
		isSmoking[attacker] = true;
	}

	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim) && GetClientTeam(victim) == TEAM_SURVIVORS)
	{
		ensnared[victim] = true;
	}
}