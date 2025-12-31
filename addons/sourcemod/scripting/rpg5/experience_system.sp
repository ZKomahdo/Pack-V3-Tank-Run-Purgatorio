experience_medical_increase(attacker, value)
{
	if (!IsHuman(attacker)) return;
	experience_verifyfirst(attacker);

	// Need to run them through FACIS... Determine if they have reached the point cap.
	point_restriction(attacker);

	decl String:weekDay[64];
	FormatTime(weekDay, sizeof(weekDay),"%A");
	decl String:sBuffer[64];
	FormatTime(sBuffer, sizeof(sBuffer), "%H");
	new hour = StringToInt(sBuffer);
	if (StrEqual(weekDay, "Friday") || StrEqual(weekDay, "Saturday") || StrEqual(weekDay, "Sunday"))
	{
		// It's the weekend. Check for the times for the xp bonus.
		if (hour >= 21 || hour <= 9)
		{
			// It's the weekend, and between the hours of 9pm and 9am, triple XP.
			It[attacker][0] += (value * 3);
		}
		else
		{
			// It's the weekend, and between the hours of 12:01pm and 11:59pm, double XP.
			It[attacker][0] += (value * 2);
		}
	}
	else
	{
		// It's not the weekend.
		if (hour >= 21 || hour <= 9)
		{
			// Double XP.
			It[attacker][0] += (value * 2);
		}
	}

	if (It[attacker][0] > It[attacker][1])
	{
		// If the players level is the level cap, they can't earn experience in that category.
		if (It[attacker][2] == GetConVarInt(LevelCap)) It[attacker][0] = 0;
		else
		{
			It[attacker][2]++;
			It[attacker][0] = 0;
			if (It[attacker][2] < GetConVarInt(GoalIncrementOne)) It[attacker][1] += RoundToFloor(It[attacker][1] * GetConVarFloat(SurvivorIncrement));
			else It[attacker][1] += RoundToFloor(It[attacker][1] * 0.01);
			PrintToChat(attacker, "%s \x01You have reached \x05Item Lv.\x03%d", LEVELUP_INFO, It[attacker][2]);
			if (It[attacker][2] == GetConVarInt(HealthPillsLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Pain Killers", LEVELUP_INFO);
			if (It[attacker][2] == GetConVarInt(HealthPackLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Medical Kit", LEVELUP_INFO);
			if (It[attacker][2] == GetConVarInt(HealthAdrenLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Adrenaline", LEVELUP_INFO);
			if (It[attacker][2] == GetConVarInt(HealthHealLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Instant Heal", LEVELUP_INFO);
			if (It[attacker][2] == GetConVarInt(HealthIncapLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Incap Protection", LEVELUP_INFO);
			if (It[attacker][2] == GetConVarInt(IncapProtectionAdvanced)) PrintToChat(attacker, "%s \x01You have unlocked \x05Advanced Incap Protection", LEVELUP_INFO);
			if (GetConVarInt(g_LevelBroadcast) == 1 && It[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
			{
				for (new i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
					PrintToChat(i, "%s \x03%N \x01has reached \x05Item Lv.\x03%d", LEVELUP_INFO, attacker, It[attacker][2]);
					if (It[attacker][2] == GetConVarInt(HealthPillsLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Pain Killers", LEVELUP_INFO, attacker);
					if (It[attacker][2] == GetConVarInt(HealthPackLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Medical Kit", LEVELUP_INFO, attacker);
					if (It[attacker][2] == GetConVarInt(HealthAdrenLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Adrenaline", LEVELUP_INFO, attacker);
					if (It[attacker][2] == GetConVarInt(HealthHealLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Instant Heal", LEVELUP_INFO, attacker);
					if (It[attacker][2] == GetConVarInt(HealthIncapLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Incap Protection", LEVELUP_INFO, attacker);
					if (It[attacker][2] == GetConVarInt(IncapProtectionAdvanced)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Advanced Incap Protection", LEVELUP_INFO, attacker);
				}
			}
		}
	}
	//SaveData(attacker);
}

experience_explosion_increase(attacker, value)
{
	if (!IsHuman(attacker)) return;
	experience_verifyfirst(attacker);

	// Need to run them through FACIS... Determine if they have reached the point cap.
	point_restriction(attacker);
	
	decl String:weekDay[64];
	FormatTime(weekDay, sizeof(weekDay),"%A");
	decl String:sBuffer[64];
	FormatTime(sBuffer, sizeof(sBuffer), "%H");
	new hour = StringToInt(sBuffer);
	if (StrEqual(weekDay, "Friday") || StrEqual(weekDay, "Saturday") || StrEqual(weekDay, "Sunday"))
	{
		// It's the weekend. Check for the times for the xp bonus.
		if (hour >= 21 || hour <= 9)
		{
			// It's the weekend, and between the hours of 12am and 12pm, triple XP.
			Gr[attacker][0] += (value * 3);
		}
		else
		{
			// It's the weekend, and between the hours of 12:01pm and 11:59pm, double XP.
			Gr[attacker][0] += (value * 2);
		}
	}
	else
	{
		// It's not the weekend.
		if (hour >= 21 || hour <= 9)
		{
			// Double XP.
			Gr[attacker][0] += (value * 2);
		}
	}

	if (Gr[attacker][0] > Gr[attacker][1])
	{
		// If the players level is the level cap, they can't earn experience in that category.
		if (Gr[attacker][2] == GetConVarInt(LevelCap)) Gr[attacker][0] = 0;
		else
		{
			Gr[attacker][2]++;
			Gr[attacker][0] = 0;
			if (Gr[attacker][2] < GetConVarInt(GoalIncrementOne)) Gr[attacker][1] += RoundToFloor(Gr[attacker][1] * GetConVarFloat(SurvivorIncrement));
			else Gr[attacker][1] += RoundToFloor(Gr[attacker][1] * 0.01);
			PrintToChat(attacker, "%s \x01You have reached \x05Grenade Lv.\x03%d", LEVELUP_INFO, Gr[attacker][2]);
			if (Gr[attacker][2] == GetConVarInt(GrenPipeLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Pipe Bomb", LEVELUP_INFO);
			if (Gr[attacker][2] == GetConVarInt(GrenJarLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Vomit Jar", LEVELUP_INFO);
			if (Gr[attacker][2] == GetConVarInt(GrenMolLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Molotov", LEVELUP_INFO);
			if (Gr[attacker][2] == GetConVarInt(GrenLauncherLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Grenade Launcher", LEVELUP_INFO);
			if (GetConVarInt(g_LevelBroadcast) == 1 && Gr[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
			{
				for (new i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
					PrintToChat(i, "%s \x03%N \x01has reached \x05Grenade Lv.\x03%d", LEVELUP_INFO, attacker, Gr[attacker][2]);
					if (Gr[attacker][2] == GetConVarInt(GrenPipeLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Pipe Bomb", LEVELUP_INFO, attacker);
					if (Gr[attacker][2] == GetConVarInt(GrenJarLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Vomit Jar", LEVELUP_INFO, attacker);
					if (Gr[attacker][2] == GetConVarInt(GrenMolLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Molotov", LEVELUP_INFO, attacker);
					if (Gr[attacker][2] == GetConVarInt(GrenLauncherLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Grenade Launcher", LEVELUP_INFO, attacker);
				}
			}
		}
	}
	//SaveData(attacker);
}

experience_increase(attacker, value)
{
	// Give no experience for kills or damage that happen before the round starts.
	if (RoundReset) return;

	experience_verifyfirst(attacker);

	// Need to run them through FACIS... Determine if they have reached the point cap.
	point_restriction(attacker);

	decl String:weekDay[64];
	FormatTime(weekDay, sizeof(weekDay),"%A");
	decl String:sBuffer[64];
	FormatTime(sBuffer, sizeof(sBuffer), "%H");
	new hour = StringToInt(sBuffer);
	if (StrEqual(weekDay, "Friday") || StrEqual(weekDay, "Saturday") || StrEqual(weekDay, "Sunday"))
	{
		// It's the weekend. Check for the times for the xp bonus.
		if (hour >= 21 || hour <= 9)
		{
			// It's the weekend, and between the hours of 12am and 12pm, triple XP.
			value = (value * 3);
		}
		else
		{
			// It's the weekend, and between the hours of 12:01pm and 11:59pm, double XP.
			value = (value * 2);
		}
	}
	else
	{
		// It's not the weekend.
		if (hour >= 21 || hour <= 9)
		{
			// Double XP.
			value = (value * 2);
		}
	}

	if (IsHuman(attacker) && GetClientTeam(attacker) == 2)
	{
		new String:weaponused[64];
		GetClientWeapon(attacker, weaponused, sizeof(weaponused));
		if (StrEqual(weaponused, "weapon_pistol", true) || 
			(StrEqual(weaponused, "weapon_pistol_magnum", true) && Pi[attacker][2] >= GetConVarInt(PistolDeagleLevel)))
		{
			Pi[attacker][0] += value;
		}
			
		else if (StrEqual(weaponused, "weapon_melee", true))
		{
			Me[attacker][0] += value;
		}
		
		else if ((StrEqual(weaponused, "weapon_smg", true) && Ph[attacker][2] >= GetConVarInt(UziLevelUnlock) && Uz[attacker][2] >= GetConVarInt(UziMac10Level)) || 
				(StrEqual(weaponused, "weapon_smg_mp5", true) && Ph[attacker][2] >= GetConVarInt(UziLevelUnlock) && Uz[attacker][2] >= GetConVarInt(UziMp5Level)) || 
				(StrEqual(weaponused, "weapon_smg_silenced", true) && Ph[attacker][2] >= GetConVarInt(UziLevelUnlock) && Uz[attacker][2] >= GetConVarInt(UziMp5Level)))
		{
			Uz[attacker][0] += value;
		}
				
		else if ((StrEqual(weaponused, "weapon_autoshotgun", true) && Ph[attacker][2] >= GetConVarInt(ShotgunLevelUnlock) && Sh[attacker][2] >= GetConVarInt(ShotgunAutoLevel)) || 
				(StrEqual(weaponused, "weapon_pumpshotgun", true) && Ph[attacker][2] >= GetConVarInt(ShotgunLevelUnlock) && Sh[attacker][2] >= GetConVarInt(ShotgunPumpLevel)) || 
				(StrEqual(weaponused, "weapon_shotgun_chrome", true) && Ph[attacker][2] >= GetConVarInt(ShotgunLevelUnlock) && Sh[attacker][2] >= GetConVarInt(ShotgunChromeLevel)) || 
				(StrEqual(weaponused, "weapon_shotgun_spas", true) && Ph[attacker][2] >= GetConVarInt(ShotgunLevelUnlock) && Sh[attacker][2] >= GetConVarInt(ShotgunSpasLevel)))
		{
			Sh[attacker][0] += value;
		}
		else if ((StrEqual(weaponused, "weapon_rifle", true) && Ph[attacker][2] >= GetConVarInt(RifleLevelUnlock) && Ri[attacker][2] >= GetConVarInt(RifleM16Level)) || 
				(StrEqual(weaponused, "weapon_rifle_ak47", true) && Ph[attacker][2] >= GetConVarInt(RifleLevelUnlock) && Ri[attacker][2] >= GetConVarInt(RifleAK47Level)) || 
				(StrEqual(weaponused, "weapon_rifle_desert", true) && Ph[attacker][2] >= GetConVarInt(RifleLevelUnlock) && Ri[attacker][2] >= GetConVarInt(RifleDesertLevel)) || 
				(StrEqual(weaponused, "weapon_rifle_m60", true) && Ph[attacker][2] >= GetConVarInt(RifleLevelUnlock) && Ri[attacker][2] >= GetConVarInt(RifleM60Level)) || 
				(StrEqual(weaponused, "weapon_rifle_sg552", true) && Ph[attacker][2] >= GetConVarInt(RifleLevelUnlock) && Ri[attacker][2] >= GetConVarInt(RifleSG552Level)))
		{
			Ri[attacker][0] += value;
		}
		else if ((StrEqual(weaponused, "weapon_sniper_awp", true) && Ph[attacker][2] >= GetConVarInt(SniperLevelUnlock) && Sn[attacker][2] >= GetConVarInt(SniperAwpLevel)) || 
				(StrEqual(weaponused, "weapon_sniper_military", true) && Ph[attacker][2] >= GetConVarInt(SniperLevelUnlock) && Sn[attacker][2] >= GetConVarInt(SniperMilitaryLevel)) || 
				(StrEqual(weaponused, "weapon_sniper_scout", true) && Ph[attacker][2] >= GetConVarInt(SniperLevelUnlock) && Sn[attacker][2] >= GetConVarInt(SniperScoutLevel)) || 
				(StrEqual(weaponused, "weapon_hunting_rifle", true) && Ph[attacker][2] >= GetConVarInt(SniperLevelUnlock) && Sn[attacker][2] >= GetConVarInt(SniperHuntingLevel)))
		{
			Sn[attacker][0] += value;
		}	
		
		
		// Whether the player has the weapon they are using or not unlocked, they receive physical experience.
		// Physical experience goes towards unlocking new weapons/abilities/items categories.
		Ph[attacker][0] += value;
		
		if (Pi[attacker][0] > Pi[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Pi[attacker][2] == GetConVarInt(LevelCap)) Pi[attacker][0] = 0;
			else
			{
				Pi[attacker][2]++;
				Pi[attacker][0] = 0;
				if (Pi[attacker][2] < GetConVarInt(GoalIncrementOne)) Pi[attacker][1] += RoundToFloor(Pi[attacker][1] * GetConVarFloat(SurvivorIncrement));
				else Pi[attacker][1] += RoundToFloor(Pi[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Pistol Lv.\x03%d", LEVELUP_INFO, Pi[attacker][2]);
				if (Pi[attacker][2] == GetConVarInt(PistolDeagleLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Desert Eagle", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Pi[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Pistol Lv.\x03%d", LEVELUP_INFO, attacker, Pi[attacker][2]);
						if (Pi[attacker][2] == GetConVarInt(PistolDeagleLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Desert Eagle", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (Me[attacker][0] > Me[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Me[attacker][2] == GetConVarInt(LevelCap)) Me[attacker][0] = 0;
			else
			{
				Me[attacker][2]++;
				Me[attacker][0] = 0;
				if (Me[attacker][2] < GetConVarInt(GoalIncrementOne)) Me[attacker][1] += RoundToFloor(Me[attacker][1] * GetConVarFloat(SurvivorIncrement));
				else Me[attacker][1] += RoundToFloor(Me[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Melee Lv.\x03%d", LEVELUP_INFO, Me[attacker][2]);
				if (Me[attacker][2] == GetConVarInt(MelGuitarLevel)) PrintToChat(attacker, "%s \x01You have unlocked \x05Electric Guitar", LEVELUP_INFO);
				if (Me[attacker][2] == GetConVarInt(MelPanLevel)) PrintToChat(attacker, "%s \x01You have unlocked \x05Frying Pan", LEVELUP_INFO);
				if (Me[attacker][2] == GetConVarInt(MelCricketLevel)) PrintToChat(attacker, "%s \x01You have unlocked \x05Cricket Bat", LEVELUP_INFO);
				if (Me[attacker][2] == GetConVarInt(MelFireaxeLevel)) PrintToChat(attacker, "%s \x01You have unlocked \x05Fire Axe", LEVELUP_INFO);
				if (Me[attacker][2] == GetConVarInt(MelGolfclubLevel)) PrintToChat(attacker, "%s \x01You have unlocked \x05Golf Club", LEVELUP_INFO);
				if (Me[attacker][2] == GetConVarInt(MelTonfaLevel)) PrintToChat(attacker, "%s \x01You have unlocked \x05Tonfa", LEVELUP_INFO);
				if (Me[attacker][2] == GetConVarInt(MelChainsawLevel)) PrintToChat(attacker, "%s \x01You have unlocked \x05Chainsaw", LEVELUP_INFO);
				if (Me[attacker][2] == GetConVarInt(MelMacheteLevel)) PrintToChat(attacker, "%s \x01You have unlocked \x05Machete", LEVELUP_INFO);
				if (Me[attacker][2] == GetConVarInt(ShoveBounceLevel)) PrintToChat(attacker, "%s \x01You have unlocked \x05Shove and Bounce", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Me[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Melee Lv.\x03%d", LEVELUP_INFO, attacker, Me[attacker][2]);
						if (Me[attacker][2] == GetConVarInt(MelGuitarLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Electric Guitar", LEVELUP_INFO, attacker);
						if (Me[attacker][2] == GetConVarInt(MelPanLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Frying Pan", LEVELUP_INFO, attacker);
						if (Me[attacker][2] == GetConVarInt(MelCricketLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Cricket Bat", LEVELUP_INFO, attacker);
						if (Me[attacker][2] == GetConVarInt(MelFireaxeLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Fire Axe", LEVELUP_INFO, attacker);
						if (Me[attacker][2] == GetConVarInt(MelGolfclubLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Golf Club", LEVELUP_INFO, attacker);
						if (Me[attacker][2] == GetConVarInt(MelTonfaLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Tonfa", LEVELUP_INFO, attacker);
						if (Me[attacker][2] == GetConVarInt(MelChainsawLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Chainsaw", LEVELUP_INFO, attacker);
						if (Me[attacker][2] == GetConVarInt(MelMacheteLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Machete", LEVELUP_INFO, attacker);
						if (Me[attacker][2] == GetConVarInt(ShoveBounceLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Shove and Bounce", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (Uz[attacker][0] > Uz[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Uz[attacker][2] == GetConVarInt(LevelCap)) Uz[attacker][0] = 0;
			else
			{
				Uz[attacker][2]++;
				Uz[attacker][0] = 0;
				if (Uz[attacker][2] < GetConVarInt(GoalIncrementOne)) Uz[attacker][1] += RoundToFloor(Uz[attacker][1] * GetConVarFloat(SurvivorIncrement));
				else Uz[attacker][1] += RoundToFloor(Uz[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Uzi Lv.\x03%d", LEVELUP_INFO, Uz[attacker][2]);
				if (Uz[attacker][2] == GetConVarInt(UziMac10Level)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Mac10", LEVELUP_INFO);
				if (Uz[attacker][2] == GetConVarInt(UziTmpLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Tmp-Silenced", LEVELUP_INFO);
				if (Uz[attacker][2] == GetConVarInt(BeanBagAmmoLevel)) PrintToChat(attacker, "%s \x01You have unlocked \x05Bean Bag Ammo", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Uz[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Uzi Lv.\x03%d", LEVELUP_INFO, attacker, Uz[attacker][2]);
						if (Uz[attacker][2] == GetConVarInt(UziMac10Level)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Mac10", LEVELUP_INFO, attacker);
						if (Uz[attacker][2] == GetConVarInt(UziTmpLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Tmp-Silenced", LEVELUP_INFO, attacker);
						if (Uz[attacker][2] == GetConVarInt(BeanBagAmmoLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Bean Bag Ammo", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (Sh[attacker][0] > Sh[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Sh[attacker][2] == GetConVarInt(LevelCap)) Sh[attacker][0] = 0;
			else
			{
				Sh[attacker][2]++;
				Sh[attacker][0] = 0;
				if (Sh[attacker][2] < GetConVarInt(GoalIncrementOne)) Sh[attacker][1] += RoundToFloor(Sh[attacker][1] * GetConVarFloat(SurvivorIncrement));
				else Sh[attacker][1] += RoundToFloor(Sh[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Shotgun Lv.\x03%d", LEVELUP_INFO, Sh[attacker][2]);
				if (Sh[attacker][2] == GetConVarInt(ShotgunPumpLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Pump Shotgun", LEVELUP_INFO);
				if (Sh[attacker][2] == GetConVarInt(ShotgunSpasLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Spas Shotgun", LEVELUP_INFO);
				if (Sh[attacker][2] == GetConVarInt(ShotgunAutoLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Auto Shotgun", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Sh[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Shotgun Lv.\x03%d", LEVELUP_INFO, attacker, Sh[attacker][2]);
						if (Sh[attacker][2] == GetConVarInt(ShotgunPumpLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Pump Shotgun", LEVELUP_INFO, attacker);
						if (Sh[attacker][2] == GetConVarInt(ShotgunSpasLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Spas Shotgun", LEVELUP_INFO, attacker);
						if (Sh[attacker][2] == GetConVarInt(ShotgunAutoLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Auto Shotgun", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (Sn[attacker][0] > Sn[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Sn[attacker][2] == GetConVarInt(LevelCap)) Sn[attacker][0] = 0;
			else
			{
				Sn[attacker][2]++;
				Sn[attacker][0] = 0;
				if (Sn[attacker][2] < GetConVarInt(GoalIncrementOne)) Sn[attacker][1] += RoundToFloor(Sn[attacker][1] * GetConVarFloat(SurvivorIncrement));
				else Sn[attacker][1] += RoundToFloor(Sn[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Sniper Lv.\x03%d", LEVELUP_INFO, Sn[attacker][2]);
				if (Sn[attacker][2] == GetConVarInt(SniperScoutLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Scout Rifle", LEVELUP_INFO);
				if (Sn[attacker][2] == GetConVarInt(SniperAwpLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Awp Rifle", LEVELUP_INFO);
				if (Sn[attacker][2] == GetConVarInt(SniperMilitaryLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Military Rifle", LEVELUP_INFO);
				if (Sn[attacker][2] == GetConVarInt(SniperHuntingLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Hunting Rifle", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Sn[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Sniper Lv.\x03%d", LEVELUP_INFO, attacker, Sn[attacker][2]);
						if (Sn[attacker][2] == GetConVarInt(SniperScoutLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Scout Rifle", LEVELUP_INFO, attacker);
						if (Sn[attacker][2] == GetConVarInt(SniperAwpLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Awp Rifle", LEVELUP_INFO, attacker);
						if (Sn[attacker][2] == GetConVarInt(SniperMilitaryLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Military Rifle", LEVELUP_INFO, attacker);
						if (Sn[attacker][2] == GetConVarInt(SniperHuntingLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Hunting Rifle", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (Ri[attacker][0] > Ri[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Ri[attacker][2] == GetConVarInt(LevelCap)) Ri[attacker][0] = 0;
			else
			{
				Ri[attacker][2]++;
				Ri[attacker][0] = 0;
				if (Ri[attacker][2] < GetConVarInt(GoalIncrementOne)) Ri[attacker][1] += RoundToFloor(Ri[attacker][1] * GetConVarFloat(SurvivorIncrement));
				else Ri[attacker][1] += RoundToFloor(Ri[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Rifle Lv.\x03%d", LEVELUP_INFO, Ri[attacker][2]);
				if (Ri[attacker][2] == GetConVarInt(RifleDesertLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Desert Rifle", LEVELUP_INFO);
				if (Ri[attacker][2] == GetConVarInt(RifleM16Level)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05M16", LEVELUP_INFO);
				if (Ri[attacker][2] == GetConVarInt(RifleSG552Level)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05SG552", LEVELUP_INFO);
				if (Ri[attacker][2] == GetConVarInt(RifleAK47Level)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05AK47", LEVELUP_INFO);
				if (Ri[attacker][2] == GetConVarInt(RifleM60Level)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05M60", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Ri[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Rifle Lv.\x03%d", LEVELUP_INFO, attacker, Ri[attacker][2]);
						if (Ri[attacker][2] == GetConVarInt(RifleDesertLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Desert Rifle", LEVELUP_INFO, attacker);
						if (Ri[attacker][2] == GetConVarInt(RifleM16Level)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05M16", LEVELUP_INFO, attacker);
						if (Ri[attacker][2] == GetConVarInt(RifleSG552Level)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05SG552", LEVELUP_INFO, attacker);
						if (Ri[attacker][2] == GetConVarInt(RifleAK47Level)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05AK47", LEVELUP_INFO, attacker);
						if (Ri[attacker][2] == GetConVarInt(RifleM60Level)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05M60", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (It[attacker][0] > It[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (It[attacker][2] == GetConVarInt(LevelCap)) It[attacker][0] = 0;
			else
			{
				It[attacker][2]++;
				It[attacker][0] = 0;
				if (It[attacker][2] < GetConVarInt(GoalIncrementOne)) It[attacker][1] += RoundToFloor(It[attacker][1] * GetConVarFloat(SurvivorIncrement));
				else It[attacker][1] += RoundToFloor(It[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Item Lv.\x03%d", LEVELUP_INFO, It[attacker][2]);
				if (It[attacker][2] == GetConVarInt(HealthPillsLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Pain Killers", LEVELUP_INFO);
				if (It[attacker][2] == GetConVarInt(HealthPackLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Medical Pack", LEVELUP_INFO);
				if (It[attacker][2] == GetConVarInt(HealthAdrenLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Adrenaline", LEVELUP_INFO);
				if (It[attacker][2] == GetConVarInt(HealthHealLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Instant Heal", LEVELUP_INFO);
				if (It[attacker][2] == GetConVarInt(HealthIncapLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Incap Protection", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && It[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Item Lv.\x03%d", LEVELUP_INFO, attacker, It[attacker][2]);
						if (It[attacker][2] == GetConVarInt(HealthPillsLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Pain Killers", LEVELUP_INFO, attacker);
						if (It[attacker][2] == GetConVarInt(HealthPackLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Medical Kit", LEVELUP_INFO, attacker);
						if (It[attacker][2] == GetConVarInt(HealthAdrenLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Adrenaline", LEVELUP_INFO, attacker);
						if (It[attacker][2] == GetConVarInt(HealthHealLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Instant Heal", LEVELUP_INFO, attacker);
						if (It[attacker][2] == GetConVarInt(HealthIncapLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Incap Protection", LEVELUP_INFO, attacker);
						if (It[attacker][2] == GetConVarInt(IncapProtectionAdvanced)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Advanced Incap Protection", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (Gr[attacker][0] > Gr[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Gr[attacker][2] == GetConVarInt(LevelCap)) Gr[attacker][0] = 0;
			else
			{
				Gr[attacker][2]++;
				Gr[attacker][0] = 0;
				if (Gr[attacker][2] < GetConVarInt(GoalIncrementOne)) Gr[attacker][1] += RoundToFloor(Gr[attacker][1] * GetConVarFloat(SurvivorIncrement));
				else Gr[attacker][1] += RoundToFloor(Gr[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Grenade Lv.\x03%d", LEVELUP_INFO, Gr[attacker][2]);
				if (Gr[attacker][2] == GetConVarInt(GrenPipeLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Pipe Bomb", LEVELUP_INFO);
				if (Gr[attacker][2] == GetConVarInt(GrenJarLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Vomit Jar", LEVELUP_INFO);
				if (Gr[attacker][2] == GetConVarInt(GrenMolLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Molotov", LEVELUP_INFO);
				if (Gr[attacker][2] == GetConVarInt(GrenLauncherLevel)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Grenade Launcher", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Gr[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Grenade Lv.\x03%d", LEVELUP_INFO, attacker, Gr[attacker][2]);
						if (Gr[attacker][2] == GetConVarInt(GrenPipeLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Pipe Bomb", LEVELUP_INFO, attacker);
						if (Gr[attacker][2] == GetConVarInt(GrenJarLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Vomit Jar", LEVELUP_INFO, attacker);
						if (Gr[attacker][2] == GetConVarInt(GrenMolLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Molotov", LEVELUP_INFO, attacker);
						if (Gr[attacker][2] == GetConVarInt(GrenLauncherLevel)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Grenade Launcher", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (Ph[attacker][0] > Ph[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Ph[attacker][2] == GetConVarInt(LevelCap)) Ph[attacker][0] = 0;
			else
			{
				Ph[attacker][2]++;
				Ph[attacker][0] = 0;
				if (Ph[attacker][2] < GetConVarInt(GoalIncrementOne)) Ph[attacker][1] += RoundToFloor(Ph[attacker][1] * GetConVarFloat(SurvivorIncrement));
				else Ph[attacker][1] += RoundToFloor(Ph[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Physical Lv.\x03%d", LEVELUP_INFO, Ph[attacker][2]);
				if (Ph[attacker][2] == GetConVarInt(UziLevelUnlock)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Uzi Category", UNLOCK_INFO, attacker);
				if (Ph[attacker][2] == GetConVarInt(ShotgunLevelUnlock)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Shotgun Category", UNLOCK_INFO, attacker);
				if (Ph[attacker][2] == GetConVarInt(SniperLevelUnlock)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Sniper Category", UNLOCK_INFO, attacker);
				if (Ph[attacker][2] == GetConVarInt(RifleLevelUnlock)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Rifle Category", UNLOCK_INFO, attacker);
				if (Ph[attacker][2] == GetConVarInt(GrenadeLevelUnlock)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Grenade Category", UNLOCK_INFO, attacker);
				if (Ph[attacker][2] == GetConVarInt(ItemLevelUnlock)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Items Category", UNLOCK_INFO, attacker);
				if (Ph[attacker][2] == GetConVarInt(MeleeLevelUnlock)) PrintToChat(attacker, "%s \x01You have \x01unlocked \x05Melee Category", UNLOCK_INFO, attacker);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Ph[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Physical Lv.\x03%d", LEVELUP_INFO, attacker, Ph[attacker][2]);
						if (Ph[attacker][2] == GetConVarInt(UziLevelUnlock)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Uzi Category", LEVELUP_INFO, attacker);
						if (Ph[attacker][2] == GetConVarInt(ShotgunLevelUnlock)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Shotgun Category", LEVELUP_INFO, attacker);
						if (Ph[attacker][2] == GetConVarInt(SniperLevelUnlock)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Sniper Category", LEVELUP_INFO, attacker);
						if (Ph[attacker][2] == GetConVarInt(RifleLevelUnlock)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Rifle Category", LEVELUP_INFO, attacker);
						if (Ph[attacker][2] == GetConVarInt(GrenadeLevelUnlock)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Grenade Category", LEVELUP_INFO, attacker);
						if (Ph[attacker][2] == GetConVarInt(ItemLevelUnlock)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Items Category", LEVELUP_INFO, attacker);
						if (Ph[attacker][2] == GetConVarInt(MeleeLevelUnlock)) PrintToChat(i, "%s \x03%N \x01has unlocked \x05Melee Category", LEVELUP_INFO, attacker);
					}
				}
			}
		}
	}
	else if (IsHuman(attacker) && GetClientTeam(attacker) == 3)
	{
		if (ClassHunter[attacker]) Hu[attacker][0] += value;
		else if (ClassSmoker[attacker]) Sm[attacker][0] += value;
		else if (ClassBoomer[attacker]) Bo[attacker][0] += value;
		else if (ClassJockey[attacker]) Jo[attacker][0] += value;
		else if (ClassCharger[attacker]) Ch[attacker][0] += value;
		else if (ClassSpitter[attacker]) Sp[attacker][0] += value;
		else if (ClassTank[attacker]) Ta[attacker][0] += value;
		
		// Whether the player has the weapon they are using or not unlocked, they receive physical experience.
		// Physical experience goes towards unlocking new weapons/abilities/items categories.
		In[attacker][0] += value;
		
		if (Hu[attacker][0] > Hu[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Hu[attacker][2] == GetConVarInt(LevelCap)) Hu[attacker][0] = 0;
			else
			{
				Hu[attacker][2]++;
				Hu[attacker][0] = 0;
				
				if (Hu[attacker][2] < GetConVarInt(GoalIncrementOne)) Hu[attacker][1] += RoundToFloor(Hu[attacker][1] * GetConVarFloat(InfectedIncrement));
				else Hu[attacker][1] += RoundToFloor(Hu[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Hunter Lv.\x04%d", LEVELUP_INFO, Hu[attacker][2]);
				if (Hu[attacker][2] == GetConVarInt(InfectedTier2Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Invisibility \x01ability for their Hunter!", LEVELUP_INFO);
				if (Hu[attacker][2] == GetConVarInt(InfectedTier3Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Improved Invisibility \x01ability for their Hunter!", LEVELUP_INFO);
				if (Hu[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Wall Of Fire \x01ability for their Hunter!", LEVELUP_INFO);
				if (Hu[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Spawn Anywhere \x01ability for their Hunter!", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Hu[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Hunter Lv.\x03%d", LEVELUP_INFO, attacker, Hu[attacker][2]);
						if (Hu[attacker][2] == GetConVarInt(InfectedTier2Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Invisibility Pounce", LEVELUP_INFO, attacker);
						if (Hu[attacker][2] == GetConVarInt(InfectedTier3Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Improved Invisibility", LEVELUP_INFO, attacker);
						if (Hu[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Wall Of Fire (Hunter)", LEVELUP_INFO, attacker);
						if (Hu[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Spawn Anywhere (Hunter)", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (Sm[attacker][0] > Sm[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Sm[attacker][2] == GetConVarInt(LevelCap)) Sm[attacker][0] = 0;
			else
			{
				Sm[attacker][2]++;
				Sm[attacker][0] = 0;
				if (Sm[attacker][2] < GetConVarInt(GoalIncrementOne)) Sm[attacker][1] += RoundToFloor(Sm[attacker][1] * GetConVarFloat(InfectedIncrement));
				else Sm[attacker][1] += RoundToFloor(Sm[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Smoker Lv.\x04%d", LEVELUP_INFO, Sm[attacker][2]);
				if (Sm[attacker][2] == GetConVarInt(InfectedTier2Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Burning Tongue \x01ability for their Smoker!", LEVELUP_INFO);
				if (Sm[attacker][2] == GetConVarInt(InfectedTier3Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Smoker Whip \x01ability for their Smoker!", LEVELUP_INFO);
				if (Sm[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Wall Of Fire \x01ability for their Smoker!", LEVELUP_INFO);
				if (Sm[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Spawn Anywhere \x01ability for their Smoker!", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Sm[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Smoker Lv.\x03%d", LEVELUP_INFO, attacker, Sm[attacker][2]);
						if (Sm[attacker][2] == GetConVarInt(InfectedTier2Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Burning Tongue", LEVELUP_INFO, attacker);
						if (Sm[attacker][2] == GetConVarInt(InfectedTier3Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Smoker Whip", LEVELUP_INFO, attacker);
						if (Sm[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Wall Of Fire (Smoker)", LEVELUP_INFO, attacker);
						if (Sm[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Spawn Anywhere (Smoker)", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (Bo[attacker][0] > Bo[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Bo[attacker][2] == GetConVarInt(LevelCap)) Bo[attacker][0] = 0;
			else
			{
				Bo[attacker][2]++;
				Bo[attacker][0] = 0;
				if (Bo[attacker][2] < GetConVarInt(GoalIncrementOne)) Bo[attacker][1] += RoundToFloor(Bo[attacker][1] * GetConVarFloat(InfectedIncrement));
				else Bo[attacker][1] += RoundToFloor(Bo[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Boomer Lv.\x04%d", LEVELUP_INFO, Bo[attacker][2]);
				if (Bo[attacker][2] == GetConVarInt(InfectedTier2Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Blinding Bile \x01ability for their Boomer!", LEVELUP_INFO);
				if (Bo[attacker][2] == GetConVarInt(InfectedTier3Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Unstable Genetics (explode when shoved) \x01ability for their Boomer!", LEVELUP_INFO);
				if (Bo[attacker][2] == GetConVarInt(InfectedTier4Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Slowing Bile \x01ability for their Boomer!", LEVELUP_INFO);
				if (Bo[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Wall Of Fire \x01ability for their Boomer!", LEVELUP_INFO);
				if (Bo[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Spawn Anywhere \x01ability for their Boomer!", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Bo[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Boomer Lv.\x03%d", LEVELUP_INFO, attacker, Bo[attacker][2]);
						if (Bo[attacker][2] == GetConVarInt(InfectedTier2Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Blinding Bile", LEVELUP_INFO, attacker);
						if (Bo[attacker][2] == GetConVarInt(InfectedTier3Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Unstable Genetics", LEVELUP_INFO, attacker);
						if (Bo[attacker][2] == GetConVarInt(InfectedTier4Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Slowing Bile", LEVELUP_INFO, attacker);
						if (Bo[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Wall Of Fire (Boomer)", LEVELUP_INFO, attacker);
						if (Bo[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Spawn Anywhere (Boomer)", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (Jo[attacker][0] > Jo[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Jo[attacker][2] == GetConVarInt(LevelCap)) Jo[attacker][0] = 0;
			else
			{
				Jo[attacker][2]++;
				Jo[attacker][0] = 0;
				if (Jo[attacker][2] < GetConVarInt(GoalIncrementOne)) Jo[attacker][1] += RoundToFloor(Jo[attacker][1] * GetConVarFloat(InfectedIncrement));
				else Jo[attacker][1] += RoundToFloor(Jo[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Jockey Lv.\x04%d", LEVELUP_INFO, Jo[attacker][2]);
				if (Jo[attacker][2] == GetConVarInt(InfectedTier2Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Berserker \x01ability for their Jockey!", LEVELUP_INFO);
				if (Jo[attacker][2] == GetConVarInt(InfectedTier3Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Jump w/ Riding \x01ability for their Jockey!", LEVELUP_INFO);
				if (Jo[attacker][2] == GetConVarInt(InfectedTier4Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Blind Ride \x01ability for their Jockey!", LEVELUP_INFO);
				if (Jo[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Wall Of Fire \x01ability for their Jockey!", LEVELUP_INFO);
				if (Jo[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Spawn Anywhere \x01ability for their Jockey!", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Jo[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Jockey Lv.\x03%d", LEVELUP_INFO, attacker, Jo[attacker][2]);
						if (Jo[attacker][2] == GetConVarInt(InfectedTier2Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Berserker", LEVELUP_INFO, attacker);
						if (Jo[attacker][2] == GetConVarInt(InfectedTier3Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Riding Jump", LEVELUP_INFO, attacker);
						if (Jo[attacker][2] == GetConVarInt(InfectedTier4Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Blind Ride", LEVELUP_INFO, attacker);
						if (Jo[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Wall Of Fire (Jockey)", LEVELUP_INFO, attacker);
						if (Jo[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Spawn Anywhere (Jockey)", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (Ch[attacker][0] > Ch[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Ch[attacker][2] == GetConVarInt(LevelCap)) Ch[attacker][0] = 0;
			else
			{
				Ch[attacker][2]++;
				Ch[attacker][0] = 0;
				if (Ch[attacker][2] < GetConVarInt(GoalIncrementOne)) Ch[attacker][1] += RoundToFloor(Ch[attacker][1] * GetConVarFloat(InfectedIncrement));
				else Ch[attacker][1] += RoundToFloor(Ch[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Charger Lv.\x04%d", LEVELUP_INFO, Ch[attacker][2]);
				if (Ch[attacker][2] == GetConVarInt(InfectedTier2Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Double Charging Speed \x01ability for their Charger!", LEVELUP_INFO);
				if (Ch[attacker][2] == GetConVarInt(InfectedTier3Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Blinding (literally!) Impact \x01ability for their Charger!", LEVELUP_INFO);
				if (Ch[attacker][2] == GetConVarInt(InfectedTier4Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Impact(tm) Bone Breaker \x01ability for their Charger!", LEVELUP_INFO);
				if (Ch[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Wall Of Fire \x01ability for their Charger!", LEVELUP_INFO);
				if (Ch[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Spawn Anywhere \x01ability for their Charger!", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Ch[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Charger Lv.\x03%d", LEVELUP_INFO, attacker, Ch[attacker][2]);
						if (Ch[attacker][2] == GetConVarInt(InfectedTier2Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Charge Speed Increase", LEVELUP_INFO, attacker);
						if (Ch[attacker][2] == GetConVarInt(InfectedTier3Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Blinding Impact", LEVELUP_INFO, attacker);
						if (Ch[attacker][2] == GetConVarInt(InfectedTier4Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Impact Leg Breaker", LEVELUP_INFO, attacker);
						if (Ch[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Wall Of Fire (Charger)", LEVELUP_INFO, attacker);
						if (Ch[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Spawn Anywhere (Charger)", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (Sp[attacker][0] > Sp[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Sp[attacker][2] == GetConVarInt(LevelCap)) Sp[attacker][0] = 0;
			else
			{
				Sp[attacker][2]++;
				Sp[attacker][0] = 0;
				if (Sp[attacker][2] < GetConVarInt(GoalIncrementOne)) Sp[attacker][1] += RoundToFloor(Sp[attacker][1] * GetConVarFloat(InfectedIncrement));
				else Sp[attacker][1] += RoundToFloor(Sp[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Spitter Lv.\x04%d", LEVELUP_INFO, Sp[attacker][2]);
				if (Sp[attacker][2] == GetConVarInt(InfectedTier2Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Slowing Spit \x01ability for their Spitter!", LEVELUP_INFO);
				if (Sp[attacker][2] == GetConVarInt(InfectedTier3Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Spit Protection \x01ability for their Spitter!", LEVELUP_INFO);
				if (Sp[attacker][2] == GetConVarInt(InfectedTier4Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Heavy Spit (can't jump) \x01ability for their Spitter!", LEVELUP_INFO);
				if (Sp[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Wall Of Fire \x01ability for their Spitter!", LEVELUP_INFO);
				if (Sp[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Spawn Anywhere \x01ability for their Spitter!", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Sp[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Spitter Lv.\x03%d", LEVELUP_INFO, attacker, Sp[attacker][2]);
						if (Sp[attacker][2] == GetConVarInt(InfectedTier2Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Slowing Spit", LEVELUP_INFO, attacker);
						if (Sp[attacker][2] == GetConVarInt(InfectedTier3Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Spit Protection", LEVELUP_INFO, attacker);
						if (Sp[attacker][2] == GetConVarInt(InfectedTier4Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Heavy Spit", LEVELUP_INFO, attacker);
						if (Sp[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Wall Of Fire (Spitter)", LEVELUP_INFO, attacker);
						if (Sp[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Spawn Anywhere (Spitter)", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (Ta[attacker][0] > Ta[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (Ta[attacker][2] == GetConVarInt(LevelCap)) Ta[attacker][0] = 0;
			else
			{
				Ta[attacker][2]++;
				Ta[attacker][0] = 0;
				if (Ta[attacker][2] < GetConVarInt(GoalIncrementOne)) Ta[attacker][1] += RoundToFloor(Ta[attacker][1] * GetConVarFloat(InfectedIncrement));
				else Ta[attacker][1] += RoundToFloor(Ta[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Tank Lv.\x04%d", LEVELUP_INFO, Ta[attacker][2]);
				if (Ta[attacker][2] == GetConVarInt(InfectedTier4Level)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Flame Tank (burn players!) \x01ability for their Tank!", LEVELUP_INFO);
				if (Ta[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Wall Of Fire \x01ability for their Tank!", LEVELUP_INFO);
				if (Ta[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(attacker, "%s \x01You have unlocked the \x04Spawn Anywhere \x01ability for their Tank!", LEVELUP_INFO);
				if (GetConVarInt(g_LevelBroadcast) == 1 && Ta[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Tank Lv.\x03%d", LEVELUP_INFO, attacker, Ta[attacker][2]);
						if (Ta[attacker][2] == GetConVarInt(InfectedTier2Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Ice Tank", LEVELUP_INFO, attacker);
						if (Ta[attacker][2] == GetConVarInt(InfectedTier4Level)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Flame Tank", LEVELUP_INFO, attacker);
						if (Ta[attacker][2] == GetConVarInt(WallOfFireLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Wall Of Fire (Tank)", LEVELUP_INFO, attacker);
						if (Ta[attacker][2] == GetConVarInt(SpawnAnywhereLevel)) PrintToChat(i, "%s \x04%N \x01has unlocked \x05Spawn Anywhere (Tank)", LEVELUP_INFO, attacker);
					}
				}
			}
		}
		if (In[attacker][0] > In[attacker][1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (In[attacker][2] == GetConVarInt(LevelCap)) In[attacker][0] = 0;
			else
			{
				In[attacker][2]++;
				In[attacker][0] = 0;
				if (In[attacker][2] < GetConVarInt(GoalIncrementOne)) In[attacker][1] += RoundToFloor(In[attacker][1] * GetConVarFloat(InfectedIncrement));
				else In[attacker][1] += RoundToFloor(In[attacker][1] * 0.01);
				PrintToChat(attacker, "%s \x01You have reached \x05Infected Lv.\x04%d", LEVELUP_INFO, In[attacker][2]);
				if (GetConVarInt(g_LevelBroadcast) == 1 && In[attacker][2] >= GetConVarInt(g_LevelBroadcastRequirement))
				{
					for (new i = 1; i <= MaxClients; i++)
					{
						if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != GetClientTeam(attacker) || i == attacker) continue;
						PrintToChat(i, "%s \x03%N \x01has reached \x05Infected Lv.\x03%d", LEVELUP_INFO, attacker, In[attacker][2]);
					}
				}
			}
		}
	}
	else if (!IsClientIndexOutOfRange(attacker) && IsFakeClient(attacker) && GetClientTeam(attacker) == 3)
	{
		if (GetConVarInt(AILevelingEnabled) == 0) return;
		if (ClassHunter[attacker]) AIHunter[0] += value;
		else if (ClassSmoker[attacker]) AISmoker[0] += value;
		else if (ClassBoomer[attacker]) AIBoomer[0] += value;
		else if (ClassJockey[attacker]) AIJockey[0] += value;
		else if (ClassCharger[attacker]) AICharger[0] += value;
		else if (ClassSpitter[attacker]) AISpitter[0] += value;
		else if (ClassTank[attacker]) AITank[0] += value;
		
		// Whether the player has the weapon they are using or not unlocked, they receive physical experience.
		// Physical experience goes towards unlocking new weapons/abilities/items categories.
		AIInfected[0] += value;
		
		if (AIHunter[0] > AIHunter[1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (AIHunter[2] == GetConVarInt(LevelCap)) AIHunter[0] = 0;
			else
			{
				AIHunter[2]++;
				AIHunter[0] = 0;
				if (AIHunter[2] < GetConVarInt(GoalIncrementOne)) AIHunter[1] += RoundToFloor(AIHunter[1] * GetConVarFloat(InfectedIncrement));
				else AIHunter[1] += RoundToFloor(AIHunter[1] * 0.01);
			}
		}
		if (AISmoker[0] > AISmoker[1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (AISmoker[2] == GetConVarInt(LevelCap)) AISmoker[0] = 0;
			else
			{
				AISmoker[2]++;
				AISmoker[0] = 0;
				if (AISmoker[2] < GetConVarInt(GoalIncrementOne)) AISmoker[1] += RoundToFloor(AISmoker[1] * GetConVarFloat(InfectedIncrement));
				else AISmoker[1] += RoundToFloor(AISmoker[1] * 0.01);
			}
		}
		if (AIBoomer[0] > AIBoomer[1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (AIBoomer[2] == GetConVarInt(LevelCap)) AIBoomer[0] = 0;
			else
			{
				AIBoomer[2]++;
				AIBoomer[0] = 0;
				if (AIBoomer[2] < GetConVarInt(GoalIncrementOne)) AIBoomer[1] += RoundToFloor(AIBoomer[1] * GetConVarFloat(InfectedIncrement));
				else AIBoomer[1] += RoundToFloor(AIBoomer[1] * 0.01);
			}
		}
		if (AIJockey[0] > AIJockey[1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (AIJockey[2] == GetConVarInt(LevelCap)) AIJockey[0] = 0;
			else
			{
				AIJockey[2]++;
				AIJockey[0] = 0;
				if (AIJockey[2] < GetConVarInt(GoalIncrementOne)) AIJockey[1] += RoundToFloor(AIJockey[1] * GetConVarFloat(InfectedIncrement));
				else AIJockey[1] += RoundToFloor(AIJockey[1] * 0.01);
			}
		}
		if (AICharger[0] > AICharger[1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (AICharger[2] == GetConVarInt(LevelCap)) AICharger[0] = 0;
			else
			{
				AICharger[2]++;
				AICharger[0] = 0;
				if (AICharger[2] < GetConVarInt(GoalIncrementOne)) AICharger[1] += RoundToFloor(AICharger[1] * GetConVarFloat(InfectedIncrement));
				else AICharger[1] += RoundToFloor(AICharger[1] * 0.01);
			}
		}
		if (AISpitter[0] > AISpitter[1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (AISpitter[2] == GetConVarInt(LevelCap)) AISpitter[0] = 0;
			else
			{
				AISpitter[2]++;
				AISpitter[0] = 0;
				if (AISpitter[2] < GetConVarInt(GoalIncrementOne)) AISpitter[1] += RoundToFloor(AISpitter[1] * GetConVarFloat(InfectedIncrement));
				else AISpitter[1] += RoundToFloor(AISpitter[1] * 0.01);
			}
		}
		if (AITank[0] > AITank[1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (AITank[2] == GetConVarInt(LevelCap)) AITank[0] = 0;
			else
			{
				AITank[2]++;
				AITank[0] = 0;
				if (AITank[2] < GetConVarInt(GoalIncrementOne)) AITank[1] += RoundToFloor(AITank[1] * GetConVarFloat(InfectedIncrement));
				else AITank[1] += RoundToFloor(AITank[1] * 0.01);
			}
		}
		if (AIInfected[0] > AIInfected[1])
		{
			// If the players level is the level cap, they can't earn experience in that category.
			if (AIInfected[2] == GetConVarInt(LevelCap)) AIInfected[0] = 0;
			else
			{
				AIInfected[2]++;
				AIInfected[0] = 0;
				if (AIInfected[2] < GetConVarInt(GoalIncrementOne)) AIInfected[1] += RoundToFloor(AIInfected[1] * GetConVarFloat(InfectedIncrement));
				else AIInfected[1] += RoundToFloor(AIInfected[1] * 0.01);
			}
		}
	}
}

experience_verifyfirst(attacker)
{
	if (IsHuman(attacker))
	{
		if (Ph[attacker][2] < 1 || Ph[attacker][1] < 1)
		{
			// if any level is 0, the player was just instantiated. Set all levels.
			Pi[attacker][2] = 1;
			Pi[attacker][1] = RoundToFloor(GetConVarFloat(PistolStartXP));
			Me[attacker][2] = 1;
			Me[attacker][1] = RoundToFloor(GetConVarFloat(MeleeStartXP));
			Uz[attacker][2] = 1;
			Uz[attacker][1] = RoundToFloor(GetConVarFloat(UziStartXP));
			Sh[attacker][2] = 1;
			Sh[attacker][1] = RoundToFloor(GetConVarFloat(ShotgunStartXP));
			Sn[attacker][2] = 1;
			Sn[attacker][1] = RoundToFloor(GetConVarFloat(SniperStartXP));
			Ri[attacker][2] = 1;
			Ri[attacker][1] = RoundToFloor(GetConVarFloat(RifleStartXP));
			Gr[attacker][2] = 1;
			Gr[attacker][1] = RoundToFloor(GetConVarFloat(GrenadeStartXP));
			It[attacker][2] = 1;
			It[attacker][1] = RoundToFloor(GetConVarFloat(ItemStartXP));
			Ph[attacker][2] = 1;
			Ph[attacker][1] = RoundToFloor(GetConVarFloat(PhysicalStartXP));
		}
		if (In[attacker][2] < 1 || In[attacker][1] < 1)
		{
			Hu[attacker][2] = 1;
			Hu[attacker][1] = RoundToFloor(GetConVarFloat(HunterStartXP));
			Sm[attacker][2] = 1;
			Sm[attacker][1] = RoundToFloor(GetConVarFloat(SmokerStartXP));
			Bo[attacker][2] = 1;
			Bo[attacker][1] = RoundToFloor(GetConVarFloat(BoomerStartXP));
			Jo[attacker][2] = 1;
			Jo[attacker][1] = RoundToFloor(GetConVarFloat(JockeyStartXP));
			Ch[attacker][2] = 1;
			Ch[attacker][1] = RoundToFloor(GetConVarFloat(ChargerStartXP));
			Sp[attacker][2] = 1;
			Sp[attacker][1] = RoundToFloor(GetConVarFloat(SpitterStartXP));
			Ta[attacker][2] = 1;
			Ta[attacker][1] = RoundToFloor(GetConVarFloat(TankStartXP));
			In[attacker][2] = 1;
			In[attacker][1] = RoundToFloor(GetConVarFloat(InfectedStartXP));
		}
	}
	else if (IsFakeClient(attacker))
	{
		if (AIInfected[2] < 1 || AIInfected[1] < 1)
		{
			AIHunter[2] = 1;
			AIHunter[1] = RoundToFloor(GetConVarFloat(HunterStartXP));
			AISmoker[2] = 1;
			AISmoker[1] = RoundToFloor(GetConVarFloat(SmokerStartXP));
			AIBoomer[2] = 1;
			AIBoomer[1] = RoundToFloor(GetConVarFloat(BoomerStartXP));
			AIJockey[2] = 1;
			AIJockey[1] = RoundToFloor(GetConVarFloat(JockeyStartXP));
			AICharger[2] = 1;
			AICharger[1] = RoundToFloor(GetConVarFloat(ChargerStartXP));
			AISpitter[2] = 1;
			AISpitter[1] = RoundToFloor(GetConVarFloat(SpitterStartXP));
			AITank[2] = 1;
			AITank[1] = RoundToFloor(GetConVarFloat(TankStartXP));
			AIInfected[2] = 1;
			AIInfected[1] = RoundToFloor(GetConVarFloat(InfectedStartXP));
		}
	}
}

point_restriction(attacker)
{
	if (GetClientTeam(attacker) == 2)
	{
		if (GetConVarFloat(SurvivorPointLimit) == 0.0) return;
		if (SurvivorPoints[attacker] > GetConVarFloat(SurvivorPointLimit)) SurvivorPoints[attacker] = GetConVarFloat(SurvivorPointLimit);
	}
	else if (GetClientTeam(attacker) == 3)
	{
		if (GetConVarFloat(InfectedPointLimit) == 0.0) return;
		if (InfectedPoints[attacker] > GetConVarFloat(InfectedPointLimit)) InfectedPoints[attacker] = GetConVarFloat(InfectedPointLimit);
	}
}