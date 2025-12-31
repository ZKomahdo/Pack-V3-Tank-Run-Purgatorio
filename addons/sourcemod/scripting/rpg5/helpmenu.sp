public Handle:Help_MainMenu (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "WIKI");
	new String:text[512];
	Format(text, sizeof(text), "Helpful Commands:");
	DrawPanelText(menu, text);
	if (GetClientTeam(client) == 2)
	{
		Format(text, sizeof(text), "!heal - Instantly heal!");
		DrawPanelText(menu, text);
		Format(text, sizeof(text), "!incap - 3 free instant heals!");
		DrawPanelText(menu, text);
		Format(text, sizeof(text), "You have %d FREE Medical uses remaining!", HealCount[client]);
		DrawPanelText(menu, text);
	}
	Format(text, sizeof(text), "!up - Opens RPG Menu");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Select A Topic:");
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Leveling: What I need to know");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Unlocking New Weapons: Your Equipment Locker");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Points and Experience: What's the difference?");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Ammo types and What they do");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Special Infected: Tier, Leveling, and Colouring");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "You're Dead: What Now?");
	DrawPanelItem(menu, text);

	Format(text, sizeof(text),"WIKI Auto appears on death until phys/inf Lv. > %d", GetConVarInt(WikiForceLevel));
	DrawPanelText(menu, text);

	return menu;
}

public Help_MainMenu_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Help_Leveling(client), client, Help_Leveling_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				SendPanelToClient(Help_EquipmentLocker(client), client, Help_EquipmentLocker_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				SendPanelToClient(Help_Experience(client), client, Help_Experience_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				SendPanelToClient(Help_AmmoTypes(client), client, Help_AmmoTypes_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				SendPanelToClient(Help_InfectedTypes(client), client, Help_InfectedTypes_Init, MENU_TIME_FOREVER);
			}
			case 6:
			{
				SendPanelToClient(Help_Dead(client), client, Help_Dead_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Help_MainMenu(client), client, Help_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Help_Leveling (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "");
	new String:text[512];
	Format(text, sizeof(text), "Physical XP: earned FOR ALL ACTIONS.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Weapon XP: earned for its respective category.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Weapon DMG: Based on respective category level, affects special ammo effectiveness.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Item XP: earned for healing or rescuing yourself/teammates.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Infected XP: earned FOR ALL ACTIONS.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Class XP: earned for CURRENT/SHAPESHIFTED class ONLY.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "ALL XP EARNED: DMG dealt to human/bot(SI only) players.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "SURVIVOR BASE XP: 1XP / kill , +%d XP for headshots, %d base for SI kills", GetConVarInt(HSXP), GetConVarInt(SIXP));
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Return To Help Main Menu");
	DrawPanelItem(menu, text);

	return menu;
}

public Help_Leveling_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Help_MainMenu(client), client, Help_MainMenu_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Help_MainMenu(client), client, Help_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Help_EquipmentLocker (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "");
	new String:text[512];
	Format(text, sizeof(text), "Unlocking new weapons:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Several weapons start locked. To unlock them, you must");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Use an unlocked weapon in that weapon category.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "By using a weapon that you have unlocked, you earn CATEGORY EXPERIENCE");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "with that weapon. Otherwise, you earn only PHYSICAL EXPERIENCE");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "All weapons in your equipment locker are granted LASER SIGHT");
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Return To Help Main Menu");
	DrawPanelItem(menu, text);

	return menu;
}

public Help_EquipmentLocker_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Help_MainMenu(client), client, Help_MainMenu_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Help_MainMenu(client), client, Help_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Help_Experience (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "");
	new String:text[512];
	Format(text, sizeof(text), "Points and Experience are both earned for all actions in the game.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Points:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "1. Last until the end of the round.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "2. Used for USEPOINTS-Module purchases - which expire at end of round.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Experience:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "1. Lasts forever - even when you leave/rejoin the server!");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "2. Used to PERMANENTLY UNLOCK new items, abilities.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "3. Level Up! - More Weapon DMG, Health, Speed, etc.!");
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Return To Help Main Menu");
	DrawPanelItem(menu, text);

	return menu;
}

public Help_Experience_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Help_MainMenu(client), client, Help_MainMenu_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Help_MainMenu(client), client, Help_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Help_AmmoTypes (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "");
	new String:text[512];
	Format(text, sizeof(text), "Ammo Types and What they do:");
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Bloat Ammo:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Makes SI %3.1fx heavier for %3.1f sec(s) + %3.1f sec(s) x weaponLevel", GetConVarFloat(BloatAmount), GetConVarFloat(BloatAmmoTime), GetConVarFloat(BloatAmmoTimeLevel));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Blind Ammo:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Blinds SI for %3.1f sec(s) + %3.1f sec(s) x weaponLevel", GetConVarFloat(BloatAmmoTime), GetConVarFloat(BloatAmmoTimeLevel));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Ice Ammo:");
	DrawPanelText(menu, text);
	decl String:pct[32];
	Format(pct, sizeof(pct), "%");
	Format(text, sizeof(text), "Slows SI by %3.1f%s speed for %3.1f sec(s) + %3.1f sec(s) x weaponLevel", GetConVarFloat(IceAmount), pct, GetConVarFloat(IceAmmoTime), GetConVarFloat(IceAmmoTimeLevel));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Heal Ammo:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Heals teammates up to maximum health - deals NO DAMAGE to SI");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Bean Bag Ammo:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Knock SI around with %3.1f force + %3.1f force x weaponLevel", GetConVarFloat(BeanBagForceVel[0]), GetConVarFloat(BeanBagAmountLevel));
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Return To Help Main Menu");
	DrawPanelItem(menu, text);

	return menu;
}

public Help_AmmoTypes_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Help_MainMenu(client), client, Help_MainMenu_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Help_MainMenu(client), client, Help_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Help_InfectedTypes (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "");
	new String:text[512];
	Format(text, sizeof(text), "Tier 2 (Blue): Level %d", GetConVarInt(InfectedTier2Level));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tier 3 (Green): Level %d", GetConVarInt(InfectedTier3Level));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tier 4 (Red): Level %d", GetConVarInt(InfectedTier4Level));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Wall of Fire: Level %d", GetConVarInt(WallOfFireLevel));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Spawn Anywhere: Level %d", GetConVarInt(SpawnAnywhereLevel));
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Global Health Bonus: %d", RoundToFloor((GetConVarFloat(PhysicalHealthPerLevel) * In[client][2])));
	DrawPanelText(menu, text);
	
	decl String:pct[32];
	Format(pct, sizeof(pct), "%");
	Format(text, sizeof(text), "Movement Speed: %3.0f%s", PlayerMovementSpeed[client] * 100.0, pct);
	DrawPanelText(menu, text);

	Format(text, sizeof(text), "Detailed Information on:");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Hunter");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Smoker");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Boomer");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Jockey");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Charger");
	DrawPanelItem(menu, text);
	Format(text, sizeof(text), "Spitter");
	DrawPanelItem(menu, text);
	
	Format(text, sizeof(text), "Return To Help Main Menu");
	DrawPanelItem(menu, text);

	return menu;
}

public Help_InfectedTypes_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Help_InfectedTypes_Hunter(client), client, Help_InfectedTypes_Hunter_Init, MENU_TIME_FOREVER);
			}
			case 2:
			{
				SendPanelToClient(Help_InfectedTypes_Smoker(client), client, Help_InfectedTypes_Smoker_Init, MENU_TIME_FOREVER);
			}
			case 3:
			{
				SendPanelToClient(Help_InfectedTypes_Boomer(client), client, Help_InfectedTypes_Boomer_Init, MENU_TIME_FOREVER);
			}
			case 4:
			{
				SendPanelToClient(Help_InfectedTypes_Jockey(client), client, Help_InfectedTypes_Jockey_Init, MENU_TIME_FOREVER);
			}
			case 5:
			{
				SendPanelToClient(Help_InfectedTypes_Charger(client), client, Help_InfectedTypes_Charger_Init, MENU_TIME_FOREVER);
			}
			case 6:
			{
				SendPanelToClient(Help_InfectedTypes_Spitter(client), client, Help_InfectedTypes_Spitter_Init, MENU_TIME_FOREVER);
			}
			case 7:
			{
				SendPanelToClient(Help_MainMenu(client), client, Help_MainMenu_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Help_MainMenu(client), client, Help_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Help_InfectedTypes_Hunter (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "");
	new String:text[512];
	Format(text, sizeof(text), "Tier 2: Partial Invisibility when lunging");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tier 3: Hunter AND Survivor Partial Invisibility while pounced.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tier 4: Hunter AND Survivor NO OUTLINES while pounced.");
	DrawPanelText(menu, text);
	

	Format(text, sizeof(text), "Health bonus: %d", RoundToFloor((GetConVarFloat(HealthPerLevel) * Hu[client][2])));
	DrawPanelText(menu, text);
	
	Format(text, sizeof(text), "Return To Help Main Menu");
	DrawPanelItem(menu, text);

	return menu;
}

public Help_InfectedTypes_Hunter_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Help_InfectedTypes(client), client, Help_InfectedTypes_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Help_InfectedTypes(client), client, Help_InfectedTypes_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Help_InfectedTypes_Smoker (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "");
	new String:text[512];
	Format(text, sizeof(text), "Tier 2: Smoked Survivors Suffer %d burn DMG when hurt.", GetConVarInt(SmokerBurnDamage));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tier 3: Can Smoker-Whip Survivors (REPEATEDLY PRESS PRIM. ATK. KEY) after ensnared.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Height of whip: %3.1f to %3.1f units + (%3.1f units per level)", GetConVarFloat(SmokerWhipForceMin), GetConVarFloat(SmokerWhipForceMax), GetConVarFloat(SmokerWhipForceLevel));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tier 4: Move tongue and player w/ STRAFELEFT and STRAFERIGHT keys.");
	DrawPanelText(menu, text);
	

	Format(text, sizeof(text), "Health bonus: %d", RoundToFloor((GetConVarFloat(HealthPerLevel) * Sm[client][2])));
	DrawPanelText(menu, text);
	
	Format(text, sizeof(text), "Return To Help Main Menu");
	DrawPanelItem(menu, text);

	return menu;
}

public Help_InfectedTypes_Smoker_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Help_InfectedTypes(client), client, Help_InfectedTypes_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Help_InfectedTypes(client), client, Help_InfectedTypes_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Help_InfectedTypes_Boomer (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "");
	new String:text[512];
	Format(text, sizeof(text), "Tier 2: Blind Survivors for %3.1f sec(s) + (%3.1f sec(s) per level)", GetConVarFloat(BlindAmmoTime), GetConVarFloat(BlindBilePerLevel));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tier 3: Unstable Boomer - Explode instantly, if shoved!");
	DrawPanelText(menu, text);
	decl String:pct[32];
	Format(pct, sizeof(pct), "%");
	Format(text, sizeof(text), "Tier 4: Slowing Bile, slows by %3.1f%s for %3.1f sec(s) + (%3.1f sec(s) per level)", GetConVarFloat(StickyBileSpeed) * 100.0, pct, GetConVarFloat(StickyBileTime), GetConVarFloat(StickyBilePerLevel));
	DrawPanelText(menu, text);
	

	Format(text, sizeof(text), "Health bonus: %d", RoundToFloor((GetConVarFloat(HealthPerLevel) * Bo[client][2])));
	DrawPanelText(menu, text);
	
	Format(text, sizeof(text), "Return To Help Main Menu");
	DrawPanelItem(menu, text);

	return menu;
}

public Help_InfectedTypes_Boomer_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Help_InfectedTypes(client), client, Help_InfectedTypes_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Help_InfectedTypes(client), client, Help_InfectedTypes_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Help_InfectedTypes_Jockey (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "");
	new String:text[512];
	Format(text, sizeof(text), "Tier 2: Instant Kill survivors you incap, once per life, if ride > %d sec(s)", GetConVarInt(BerserkRideTime));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tier 3: Jump while riding! %3.1f units + (%3.1f units per level)", GetConVarFloat(JockeyRideJumpForce), GetConVarFloat(RideJumpForceLevel));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tier 4: Blind Players while riding them!");
	DrawPanelText(menu, text);
	

	Format(text, sizeof(text), "Health bonus: %d", RoundToFloor((GetConVarFloat(HealthPerLevel) * Jo[client][2])));
	DrawPanelText(menu, text);
	
	Format(text, sizeof(text), "Return To Help Main Menu");
	DrawPanelItem(menu, text);

	return menu;
}

public Help_InfectedTypes_Jockey_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Help_InfectedTypes(client), client, Help_InfectedTypes_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Help_InfectedTypes(client), client, Help_InfectedTypes_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Help_InfectedTypes_Charger (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "");
	new String:text[512];
	decl String:pct[32];
	Format(pct, sizeof(pct), "%");
	Format(text, sizeof(text), "Tier 2: Increases charging speed by %3.1f%s per level.", GetConVarFloat(ChargerSpeedPerLevel) * 100.0, pct);
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tier 3: Blind survivors impacted by charge for %3.1f sec(s) + (%3.1f sec(s) per level)", GetConVarFloat(ImpactBlindTime), GetConVarFloat(ChargerBlindPerLevel));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tier 4: Break the legs of survivors impacted during a charge!");
	DrawPanelText(menu, text);
	

	Format(text, sizeof(text), "Health bonus: %d", RoundToFloor((GetConVarFloat(HealthPerLevel) * Ch[client][2])));
	DrawPanelText(menu, text);
	
	Format(text, sizeof(text), "Return To Help Main Menu");
	DrawPanelItem(menu, text);

	return menu;
}

public Help_InfectedTypes_Charger_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Help_InfectedTypes(client), client, Help_InfectedTypes_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Help_InfectedTypes(client), client, Help_InfectedTypes_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Help_InfectedTypes_Spitter (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "");
	new String:text[512];
	decl String:pct[32];
	Format(pct, sizeof(pct), "%");
	Format(text, sizeof(text), "Tier 2: Spit slows survivors by %3.1f%s + (%3.2f%s per level) for %3.1f sec(s)", GetConVarFloat(StickySpitSpeed) * 100.0, pct, GetConVarFloat(StickySpitPerLevel) * 100.0, pct, GetConVarFloat(StickySpitTime));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tier 3: Invisibility + Invulnerability for %3.1f sec(s) after spitting!", GetConVarFloat(SpitterInvisTime));
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "Tier 4: Spit increases victim's graviy by 5x for 2.0 sec(s)!");
	DrawPanelText(menu, text);
	

	Format(text, sizeof(text), "Health bonus: %d", RoundToFloor((GetConVarFloat(HealthPerLevel) * Sp[client][2])));
	DrawPanelText(menu, text);
	
	Format(text, sizeof(text), "Return To Help Main Menu");
	DrawPanelItem(menu, text);

	return menu;
}

public Help_InfectedTypes_Spitter_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Help_InfectedTypes(client), client, Help_InfectedTypes_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Help_InfectedTypes(client), client, Help_InfectedTypes_Init, MENU_TIME_FOREVER);
			}
		}
	}
}

public Handle:Help_Dead (client)
{
	new Handle:menu = CreatePanel();
	
	SetPanelTitle(menu, "");
	new String:text[512];
	Format(text, sizeof(text), "When a Survivor player dies, they have the ability to respawn.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "If you have enough points, purchase a respawn by");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "1. Open the rpg menu - !up in chatbox");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "2. Open Usepoints module - Option 2 (Spend Points)");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "3. Open Abilities menu - Option 3 (Abilities)");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "4. Select which version of respawn you'd like to buy.");
	DrawPanelText(menu, text);
	Format(text, sizeof(text), "-> Post-purchase, you can switch between respawn types for free.");
	DrawPanelText(menu, text);


	Format(text, sizeof(text), "Return To Help Main Menu");
	DrawPanelItem(menu, text);

	return menu;
}

public Help_Dead_Init (Handle:topmenu, MenuAction:action, client, param2)
{
	if (topmenu != INVALID_HANDLE) CloseHandle(topmenu);

	if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 1:
			{
				SendPanelToClient(Help_MainMenu(client), client, Help_MainMenu_Init, MENU_TIME_FOREVER);
			}
			default:
			{
				SendPanelToClient(Help_MainMenu(client), client, Help_MainMenu_Init, MENU_TIME_FOREVER);
			}
		}
	}
}