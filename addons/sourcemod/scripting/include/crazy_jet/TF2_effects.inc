/*
	Variables
*/
new pRainbow[MAXPLAYERS+1] = -1;
new pStars[MAXPLAYERS+1] = -1;

stock _:SpawnParticle(const String:particleName[], Float:durationTime = 0.0, bool:startSpawn = true, attachEnt = 0, const String:attachBone[] = "", Float:effectPos[3] = NULL_VECTOR, Float:effectAng[3] = NULL_VECTOR, Float:effectVel[3] = NULL_VECTOR)
{
	new particle = CreateEntityByName("info_particle_system");
	if(IsValidEdict(particle))
	{
		new Float:pos[3];
		new Float:ang[3];

		if(StrEqual(attachBone, ""))
		{
			GetEntPropVector(attachEnt, Prop_Send, "m_vecOrigin", pos);
			AddVectors(pos, effectPos, pos);
			GetEntPropVector(attachEnt, Prop_Send, "m_angRotation", ang);
			AddVectors(ang, effectAng, ang);
			TeleportEntity(particle, pos, ang, effectVel);
		}

		new String:tName[32];
		GetEntPropString(attachEnt, Prop_Data, "m_iName", tName, sizeof( tName ));
		DispatchKeyValue(particle, "targetname", "tf2particle");
		DispatchKeyValue(particle, "parentname", tName);
		DispatchKeyValue(particle, "effect_name", particleName);
		DispatchSpawn(particle);

		if(attachEnt != 0)
		{
			SetVariantString("!activator");
			AcceptEntityInput(particle, "SetParent", attachEnt, particle, 0);

			if(!StrEqual(attachBone, ""))
			{
				SetVariantString(attachBone);
				AcceptEntityInput(particle, "SetParentAttachment", attachEnt, particle, 0);
				TeleportEntity(particle, effectPos, effectAng, effectVel);
			}
		}
		ActivateEntity(particle);

		if(startSpawn)
		{
			AcceptEntityInput(particle, "start");
		}

		if(durationTime > 0.0)
		{
			CreateTimer(durationTime, RemoveParticle, particle);
		}

		return particle;
	
	}
	return -1;
	
}

public Action:RemoveParticle(Handle:timer, any:particle)
{
	if(IsValidEntity(particle))
	{
		new String:classname[32];
		GetEdictClassname(particle, classname, sizeof(classname));
		if(StrEqual(classname, "info_particle_system", false))
		{
			AcceptEntityInput(particle, "stop");
			AcceptEntityInput(particle, "Kill");
			particle = -1;
		}
	}
}

stock DelParticles(any:client)
{	
	if(pRainbow[client] != -1)
	{
		DeleteParticle(pRainbow[client]);
		pRainbow[client] = -1;
	}

	if(pStars[client] != -1)
	{
		DeleteParticle(pStars[client]);
		pStars[client] = -1;
	}
} 

stock DeleteParticle(&particle, Float:delay = 0.0)
{
	if(particle != -1)
	{
		if(IsValidEdict(particle))
		{
			new String:classname[32];
			GetEdictClassname(particle, classname, sizeof(classname));
			if(StrEqual(classname, "info_particle_system", false))
			{
				ActivateEntity(particle);
				AcceptEntityInput(particle, "stop");
				CreateTimer(delay, RemoveParticle, particle);
				particle = -1;
			}
		}
	}
} 

stock ShowMessage(client, Float:x, Float:y, Float:duration, const String:msg[])
{
	new color[3];
	GetRandomRGBColor(color);

	SetHudTextParams(x, y, duration, color[0], color[1], color[2], 255);
	ShowHudText(client, 1, msg);
}

stock GetRandomRGBColor(color[])
{
    new RED = GetRandomInt(0, 255);
    new BLUE = GetRandomInt(0, 255);
    new GREEN = GetRandomInt(0, 255);

    if(RED == BLUE && RED == GREEN && BLUE == RED && BLUE == GREEN && GREEN == RED && GREEN == BLUE)
    {
        GetRandomRGBColor(color);
    } else {
        color[0] = RED;
        color[1] = BLUE;
        color[2] = GREEN;
    }
} 