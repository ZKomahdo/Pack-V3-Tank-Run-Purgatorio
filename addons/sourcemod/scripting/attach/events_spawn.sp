public Events_SpawnStart()
{
	HookEvent("player_spawn", Event_PlayerSpawn);
}

public Action:Event_PlayerSpawn(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new attacker					= GetClientOfUserId(GetEventInt(event, "userid"));

	if (!IsClientIndexOutOfRange(attacker) && IsClientInGame(attacker) && !IsFakeClient(attacker) && GetClientTeam(attacker) == TEAM_INFECTED)
	{
		bRiding[attacker] = false;
		bJumping[attacker] = false;
		SetEntityMoveType(attacker, MOVETYPE_WALK);
		SetEntityGravity(attacker, 1.0);

		SetupZombie(attacker);
	}
}

public SetupZombie(client)
{
	classHunter[client] = false;
	classSmoker[client] = false;
	classBoomer[client] = false;
	classJockey[client] = false;
	classCharger[client] = false;
	classSpitter[client] = false;
	classTank[client]	= false;

	SetEntProp(client, Prop_Data, "m_takedamage", 2, 1);

	new class = GetEntProp(client, Prop_Send, "m_zombieClass");

	if (class == ZOMBIECLASS_HUNTER) classHunter[client] = true;
	if (class == ZOMBIECLASS_SMOKER) classSmoker[client] = true;
	if (class == ZOMBIECLASS_BOOMER) classSmoker[client] = true;
	if (class == ZOMBIECLASS_JOCKEY) classJockey[client] = true;
	if (class == ZOMBIECLASS_CHARGER) classCharger[client] = true;
	if (class == ZOMBIECLASS_SPITTER) classSpitter[client] = true;
	if (class == ZOMBIECLASS_TANK) classTank[client] = true;

	if (class != ZOMBIECLASS_TANK)
	{
		SetEntityHealth(client, GetClientHealth(client) + SIHealth);
		SetEntDataFloat(client, laggedMovementOffset, 1.0, true);

	}
	else
	{
		SetEntityHealth(client, tankHealth);
		SetEntDataFloat(client, laggedMovementOffset, tankUPS, true);
		tankCount++;
	}
}