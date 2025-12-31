_ChargerEvents_OnPluginStart()
{
	HookEvent("charger_pummel_end", Event_ChargerPummelEnd);
	HookEvent("charger_carry_start", Event_ChargerCarryStart);
	HookEvent("charger_carry_end", Event_ChargerCarryEnd);
	HookEvent("charger_impact", Event_ChargerImpact);
	HookEvent("charger_charge_start", Event_ChargeStart);
	HookEvent("charger_charge_end", Event_ChargeEnd);
}

/*			CHARGER EVENTS			*/

public Action:Event_ChargeStart(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	if (IsHuman(attacker) && SuperUpgradeCharger[attacker] && IsPlayerAlive(attacker))
	{
		SetEntDataFloat(attacker, laggedMovementOffset, (PlayerMovementSpeed[attacker] * GetConVarFloat(ChargerSpeedIncrease)) + (GetConVarFloat(ChargerSpeedPerLevel) * Ch[attacker][2]), true);
	}
	else if (!IsClientIndexOutOfRange(attacker) && IsFakeClient(attacker) && AICharger[2] >= GetConVarInt(InfectedTier3Level) && IsPlayerAlive(attacker))
	{
		SetEntDataFloat(attacker, laggedMovementOffset, (PlayerMovementSpeed[attacker] * GetConVarFloat(ChargerSpeedIncrease)) + (GetConVarFloat(ChargerSpeedPerLevel) * AICharger[2]), true);
	}
}

public Action:Event_ChargeEnd(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	if (IsHuman(attacker) && SuperUpgradeCharger[attacker] && IsPlayerAlive(attacker))
	{
		SetEntDataFloat(attacker, laggedMovementOffset, PlayerMovementSpeed[attacker], true);
	}
	else if (!IsClientIndexOutOfRange(attacker) && IsFakeClient(attacker) && AICharger[2] >= GetConVarInt(InfectedTier3Level) && IsPlayerAlive(attacker))
	{
		SetEntDataFloat(attacker, laggedMovementOffset, PlayerMovementSpeed[attacker], true);
	}
}

public Action:Event_ChargerPummelEnd(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));
	if (IsClientIndexOutOfRange(victim) || !IsClientInGame(victim)) return;
	Ensnared[victim] = false;
}

public Action:Event_ChargerCarryStart(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));
	
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker))
	{
		if (!IsFakeClient(attacker)) GetClientAbsOrigin(attacker, Float:StartChargeLocation[attacker]);
		if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim))
		{
			if (IsFakeClient(attacker)) GetClientAbsOrigin(victim, Float:StartChargeLocation[victim]);
			decl Float:EnsnareValue;
			EnsnareValue = SurvivorMultiplier[victim] * GetConVarFloat(SurvivorEnsnareValue);
			if (showpoints[attacker] == 1 && !IsFakeClient(attacker)) PrintToChat(attacker, "%s \x01Survivor Ensnared: \x04%3.3f \x01Point(s).", POINTS_INFO, EnsnareValue);
			if (IsFakeClient(attacker)) InfectedPoints[attacker] += (EnsnareValue * GetConVarFloat(InfectedBotHandicap));
			else InfectedPoints[attacker] += EnsnareValue;

			experience_increase(attacker, RoundToFloor(EnsnareValue));

			// Check to see if the Charger Jump-while-carrying upgrade is active.
			// Victim must also be human, and the Charger cannot be currently affected by bloat ammo.
			if (TUpgrade_CarryJump == true && SufferingFromBloatAmmo[victim] == false && !IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim))
			{
				ChargerCanJump[attacker] = true;
				ChargerIsJumping[attacker] = false;
				ChargerCarryVictim[attacker] = victim;

				if (IsFakeClient(attacker))
				{
					// If it's a bot, we want to grab a random float time and force the charger to use the jump ability.
					new Float:delay = GetRandomFloat(0.1, 2.0);
					CreateTimer(delay, Timer_BotChargerJump, attacker, TIMER_FLAG_NO_MAPCHANGE);
				}
			}
		}
	}
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim)) Ensnared[victim] = true;
}

public Action:Timer_BotChargerJump(Handle:timer, any:client)
{
	if (IsClientIndexOutOfRange(client) || !IsClientInGame(client) || !IsPlayerAlive(client) || ChargerCanJump[client] == false) return Plugin_Stop;
	CallChargerJump(client);
	return Plugin_Stop;
}

public Action:Event_ChargerCarryEnd(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));
	
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker))
	{
		new Float:EndChargeLocation[3];
		new Float:ChargeDistance;
		if (!IsFakeClient(attacker))
		{
			GetClientAbsOrigin(attacker, EndChargeLocation);
			ChargeDistance = GetVectorDistance(StartChargeLocation[attacker], EndChargeLocation);
		}
		else if (IsFakeClient(attacker) && !IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim))
		{
			GetClientAbsOrigin(victim, EndChargeLocation);
			ChargeDistance = GetVectorDistance(StartChargeLocation[victim], EndChargeLocation);
		}
		ChargeDistance *= GetConVarFloat(ChargeDistanceMultiplier);
		
		if (showpoints[attacker] == 1 && !IsFakeClient(attacker)) PrintToChat(attacker, "%s \x01Charge Distance: \x04%3.3f \x01Point(s).", POINTS_INFO, ChargeDistance);
		if (IsFakeClient(attacker)) InfectedPoints[attacker] += (ChargeDistance * GetConVarFloat(InfectedBotHandicap));
		else InfectedPoints[attacker] += ChargeDistance;

		experience_increase(attacker, RoundToFloor(ChargeDistance));

		if (ChargerCanJump[attacker] == true)
		{
			// If the charger jump ability is active, deactivate it.
			ChargerCanJump[attacker] = false;
			ChargerIsJumping[attacker] = false;
			ChargerCarryVictim[attacker] = 0;		// set to 0 so they can't jump while charging without a victim.
		}
	}
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim)) Ensnared[victim] = false;
}

public Action:Event_ChargerImpact(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	new victim = GetClientOfUserId(GetEventInt(event, "victim"));
	
	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker))
	{
		if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim) && !IsFakeClient(victim))
		{
			if (showpoints[attacker] == 1 && !IsFakeClient(attacker)) PrintToChat(attacker, "%s \x01Impact Survivor: \x04%3.3f \x01Point(s).", POINTS_INFO, SurvivorMultiplier[victim] * GetConVarFloat(SurvivorImpactPoints));
			InfectedPoints[attacker] += (SurvivorMultiplier[victim] * GetConVarFloat(SurvivorImpactPoints));
			
			experience_increase(attacker, RoundToFloor(SurvivorMultiplier[victim] * GetConVarFloat(SurvivorImpactPoints)));
			
			if (IsHuman(attacker))
			{
				if (UpgradeCharger[attacker] || Ch[attacker][2] >= GetConVarInt(InfectedTier2Level))
				{
					BlindPlayer(victim, GetConVarInt(BlindAmount));
					CreateTimer(GetConVarFloat(ImpactBlindTime) + (GetConVarFloat(ChargerBlindPerLevel) * Ch[attacker][2]), RemoveBlindAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
				}
				if (Ch[attacker][2] >= GetConVarInt(InfectedTier4Level) && !BrokenLegs[victim])
				{
					if (IsPlayerAlive(victim))
					{
						BrokenLegs[victim] = true;
						SetEntDataFloat(victim, laggedMovementOffset, GetConVarFloat(BrokenLegsSpeed), true);
						PrintHintText(victim, "Your legs are broken!\nFind some adrenaline!\nDrugs will make you feel better!");
					}
				}
			}
			else if (IsFakeClient(attacker))
			{
				if (AICharger[2] >= GetConVarInt(InfectedTier2Level))
				{
					BlindPlayer(victim, GetConVarInt(BlindAmount));
					CreateTimer(GetConVarFloat(ImpactBlindTime) + (GetConVarFloat(ChargerBlindPerLevel) * AICharger[2]), RemoveBlindAmmo, victim, TIMER_FLAG_NO_MAPCHANGE);
				}
				if (AICharger[2] >= GetConVarInt(InfectedTier4Level) && !BrokenLegs[victim])
				{
					if (IsPlayerAlive(victim))
					{
						BrokenLegs[victim] = true;
						SetEntDataFloat(victim, laggedMovementOffset, GetConVarFloat(BrokenLegsSpeed), true);
						PrintHintText(victim, "Your legs are broken!\nFind some adrenaline!\nDrugs will make you feel better!");
					}
				}
			}
		}
	}
	if (!IsClientIndexOutOfRange(victim) && IsClientInGame(victim)) Ensnared[victim] = false;
}