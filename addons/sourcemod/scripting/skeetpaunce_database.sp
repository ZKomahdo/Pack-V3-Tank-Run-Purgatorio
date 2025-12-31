#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

new Handle:hEnablePlugin;
new Handle:OneShotSkeet;
new Handle:hCvarAnnounce;
new Handle:g_hCvarMPGameMode;
new Handle:g_hCvarModesTog;
new Handle:g_hCvarAIHunter;
new bool:g_bCvarAllow;
new Handle:g_hCvarSurvivorLimit;
new bool:g_bRoundEndAnnounce;
new bool:g_bShotCounted[MAXPLAYERS+1][MAXPLAYERS+1];
new bool:g_bIsPouncing[MAXPLAYERS+1];
new bool:g_bHasLandedPounce[MAXPLAYERS+1];
new timerDeath[MAXPLAYERS+1];
new Skeets[MAXPLAYERS+1];
new Kills[MAXPLAYERS+1];
new DeadStoped[MAXPLAYERS+1];
new g_iShotsDealt[MAXPLAYERS+1][MAXPLAYERS+1];
new g_damage[MAXPLAYERS+1][MAXPLAYERS+1];
new g_iDamageDealt[MAXPLAYERS+1][MAXPLAYERS+1];
new g_iLastHealth[MAXPLAYERS+1];
new g_iSurvivorLimit = 4;
new CvarAnnounce;
ConVar hMaxPounceDistance;
ConVar hMinPounceDistance;
ConVar hMaxPounceDamage;
//hunter position store
new Float:infectedPosition[MAXPLAYERS+1][3]; //support up to 32 slots on a server
//cvars
ConVar hMinPounceAnnounce;
ConVar hChat;
new ConVar_maxdmg,ConVar_max,ConVar_min;
new String:datafilepathskeet[256];
new String:datafilepathpounce[256];

public Plugin:myinfo = 
{
	name = "Pounce + skeet Announce (database)",
	author = "",
	description = "",
	version = "1.0",
	url = ""
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) 
{
	EngineVersion test = GetEngineVersion();
	
	if( test != Engine_Left4Dead2 && test != Engine_Left4Dead)
	{
		strcopy(error, err_max, "Plugin only supports Left 4 Dead 1 & 2.");
		return APLRes_SilentFailure;
	}
	
	return APLRes_Success; 
}

public OnPluginStart()
{
	hMaxPounceDistance = FindConVar("z_pounce_damage_range_max");
	hMinPounceDistance = FindConVar("z_pounce_damage_range_min");
	hMaxPounceDamage = FindConVar("z_hunter_max_pounce_bonus_damage");
	
	if(hMaxPounceDistance == null) hMaxPounceDistance = CreateConVar("z_pounce_damage_range_max", "1000.0", "Not available on this server, added by pounce_database.", FCVAR_NOTIFY, true, 0.0, false );
	if(hMinPounceDistance == null) hMinPounceDistance = CreateConVar("z_pounce_damage_range_min", "300.0", "Not available on this server, added by pounce_database.", FCVAR_NOTIFY, true, 0.0, false );
	if(hMaxPounceDamage == null) hMaxPounceDamage = CreateConVar( "z_hunter_max_pounce_bonus_damage",  "49", "Not available on this server, added by pounce_database.", FCVAR_NOTIFY, true, 0.0, false );
	
	hEnablePlugin = CreateConVar("skeet_paunce_database_enable", "1", "Enable this plugin?", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	hMinPounceAnnounce = CreateConVar("pounce_database_minimum","25","The minimum amount of damage required to record the pounce", FCVAR_SPONLY|FCVAR_NOTIFY);
	hChat = CreateConVar("pounce_database_announce","1","Announces the pounce in chatbox.", FCVAR_SPONLY|FCVAR_NOTIFY);
	OneShotSkeet = CreateConVar("skeet_database_announce_oneshot", "1", "Only count 'One Shot' skeet?[1: Yes, 0: No]", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	hCvarAnnounce = CreateConVar("skeet_database_announce", "1", "Announce skeet/shots in chatbox when someone skeets.", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	g_hCvarAIHunter =	CreateConVar("skeet_database_ai_hunter_enable",		"0",			"Count AI Hunter also?[1: Yes, 0: No]", FCVAR_NOTIFY , true, 0.0, true, 1.0);
	g_hCvarModesTog =	CreateConVar("skeet_database_modes_tog",		"4",			"Turn on the plugin in these game modes. 0=All, 1=Coop, 2=Survival, 4=Versus. Add numbers together.", FCVAR_NOTIFY, true, 0.0, true, 7.0);
	
	
	HookConVarChange(hMaxPounceDamage, Convar_MaxPounceDamage);
	HookConVarChange(hCvarAnnounce, ConVarChange_hCvarAnnounce);
	ConVar_maxdmg = GetConVarInt(hMaxPounceDamage);
	
	g_hCvarMPGameMode = FindConVar("mp_gamemode");
	g_hCvarSurvivorLimit = FindConVar("survivor_limit");
	
	HookConVarChange(hEnablePlugin, ConVarChanged_Allow);
	HookConVarChange(g_hCvarMPGameMode, ConVarChanged_Allow);
	HookConVarChange(g_hCvarModesTog, ConVarChanged_Allow);
	HookConVarChange(g_hCvarSurvivorLimit, ConVarChanged_Allow);
	
	if(hMaxPounceDistance != null)
	{
		HookConVarChange(hMaxPounceDistance, Convar_Max);
		ConVar_max = GetConVarInt(hMaxPounceDistance);
	}

	if(hMinPounceDistance != null)
	{
		HookConVarChange(hMinPounceDistance, Convar_Min);
		ConVar_min = GetConVarInt(hMinPounceDistance);
	}
	
	BuildPath(PathType:0, datafilepathskeet, 256, "data/%s", "skeet_database.txt");
	BuildPath(PathType:0, datafilepathpounce, 256, "data/%s", "pounce_database.txt");
	
	RegConsoleCmd("sm_pounces", Command_StatsPounce, "Show your current pounce statistics and rank.", 0);
	RegConsoleCmd("sm_pounce5", Command_TopPounce, "Show TOP 5 pounce players in statistics.", 0);
	RegConsoleCmd("sm_skeets", Command_StatsSkeet, "Show your current skeet statistics and rank.", 0);
	RegConsoleCmd("sm_top5", Command_TopSkeet, "Show TOP 5 players in statistics.", 0);
	
	AutoExecConfig(true,"skeet_pounce_database");
}

public OnConfigsExecuted()
{
	IsAllowed();
}

IsAllowed()
{
	new bool:bCvarAllow = GetConVarBool(hEnablePlugin);
	new bool:bAllowMode = IsAllowedGameMode();
	
	if( g_bCvarAllow == false && bCvarAllow == true && bAllowMode == true)
	{
		g_bCvarAllow = true;
		ConVar_maxdmg = GetConVarInt(hMaxPounceDamage);
		ConVar_max = GetConVarInt(hMaxPounceDistance);
		ConVar_min = GetConVarInt(hMinPounceDistance);
		CvarAnnounce = GetConVarInt(hCvarAnnounce);
		
		HookEvent("lunge_pounce",Event_PlayerPounced);
		HookEvent("ability_use",Event_AbilityUse);
		
		HookEvent("player_hurt", Event_PlayerHurt, EventHookMode:1);
		HookEvent("player_death", Event_PlayerDeath, EventHookMode:1);
		HookEvent("round_start", Event_RoundStart, EventHookMode:1);
		HookEvent("round_end", Event_RoundEnd, EventHookMode:1);
		HookEvent("weapon_fire", weapon_fire, EventHookMode:1);
		HookEvent("player_bot_replace", Event_Replace, EventHookMode:1);
		HookEvent("bot_player_replace", Event_Replace, EventHookMode:1);
		HookEvent("player_shoved", Event_PlayerShoved, EventHookMode:1);
		HookEvent("lunge_pounce", Event_LungePounce, EventHookMode:1);
	}
	else if( g_bCvarAllow == true && (bCvarAllow == false || bAllowMode == false))
	{
		g_bCvarAllow = false;
		UnhookEvent("lunge_pounce",Event_PlayerPounced);
		UnhookEvent("ability_use",Event_AbilityUse);
		
		UnhookEvent("player_hurt", Event_PlayerHurt, EventHookMode:1);
		UnhookEvent("player_death", Event_PlayerDeath, EventHookMode:1);
		UnhookEvent("round_start", Event_RoundStart, EventHookMode:1);
		UnhookEvent("round_end", Event_RoundEnd, EventHookMode:1);
		UnhookEvent("weapon_fire", weapon_fire, EventHookMode:1);
		UnhookEvent("player_bot_replace", Event_Replace, EventHookMode:1);
		UnhookEvent("bot_player_replace", Event_Replace, EventHookMode:1);
		UnhookEvent("player_shoved", Event_PlayerShoved, EventHookMode:1);
		UnhookEvent("lunge_pounce", Event_LungePounce, EventHookMode:1);
	}
}

bool:IsAllowedGameMode()
{
	if( g_hCvarMPGameMode == INVALID_HANDLE )
	return false;
	
	new iCvarModesTog = GetConVarInt(g_hCvarModesTog);
	if( iCvarModesTog == 0) return true;
	
	decl String:CurrentGameMode[32];
	GetConVarString(g_hCvarMPGameMode, CurrentGameMode, sizeof(CurrentGameMode));
	new g_iCurrentMode = 0;
	
	if(StrEqual(CurrentGameMode,"coop", false))
	{
		g_iCurrentMode = 1;
	}
	else if (StrEqual(CurrentGameMode,"versus", false))
	{
		g_iCurrentMode = 4;
	}
	else if (StrEqual(CurrentGameMode,"survival", false))
	{
		g_iCurrentMode = 2;
	}

	if( g_iCurrentMode == 0 )
		return false;
		
	if(!(iCvarModesTog & g_iCurrentMode))
		return false;

	return true;
}

public ConVarChanged_Allow(Handle:convar, const String:oldValue[], const String:newValue[])
{	
	IsAllowed();
}

public OnMapStart()
{
	PrecacheSound("player/damage1.wav", true);
	PrecacheSound("player/damage2.wav", true);
	PrecacheSound("player/neck_snap_01.wav", true);
	PrecacheSound("player/orch_hit_Csharp_short.wav", true);
	ClearSkeetCounter();
}

public Action:Command_StatsPounce(client, args)
{
	if(g_bCvarAllow)
	{
		PrintPouncesToClient(client);
		ShowPounceRank(client);
	}
	return Plugin_Continue;
}

public Action:Command_TopPounce(client, args)
{
	if(g_bCvarAllow)
		PrintTopPouncers(client);
	return Plugin_Continue;
}

public Action:Command_StatsSkeet(client, args)
{
	if(g_bCvarAllow)
	{
		ShowSkeetRank(client);
		PrintSkeetsToClient(client);
	}
	return Plugin_Continue;
}

public Action:Command_TopSkeet(client, args)
{
	if(g_bCvarAllow)
		PrintTopSkeetersToClient(client);
	return Plugin_Continue;
}

public Convar_MaxPounceDamage (Handle:convar, const String:oldValue[], const String:newValue[])
{
	new newdmg=StringToInt(newValue);
	if (newdmg<1)
		newdmg=1;
	else if (newdmg>1000)
		newdmg=1000;
	ConVar_maxdmg = newdmg;
	
}

public Convar_Max (Handle:convar, const String:oldValue[], const String:newValue[])
{
	new newmax=StringToInt(newValue);
	if (newmax<1)
		newmax=1;

	ConVar_max = newmax;
	
}
public Convar_Min (Handle:convar, const String:oldValue[], const String:newValue[])
{
	new newmin=StringToInt(newValue);
	if (newmin<1)
		newmin=1;

	ConVar_min = newmin;	
}

public Action:Event_AbilityUse(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	//Save the location of the player who just used an infected ability
	GetClientAbsOrigin(client,infectedPosition[client]);
	
	if (IsClientInGame(client) && IsPlayerHunter(client))
	{
		g_bIsPouncing[client] = true;
		CreateTimer(0.1, Timer_GroundedCheck, client, 1);
	}
	return Plugin_Continue;

}

public Event_PlayerPounced(Handle:event, const String:name[], bool:dontBroadcast)
{
	new attackerClient = GetClientOfUserId(GetEventInt(event, "userid"));
	new victimClient = GetClientOfUserId(GetEventInt(event, "victim"));
	if(!IsClientInGame(attackerClient) || IsFakeClient(attackerClient) || GetClientTeam(attackerClient) != 3) return;
	if(!IsClientInGame(victimClient) || IsFakeClient(victimClient) || GetClientTeam(victimClient) != 2) return;
	
	new Float:pouncePosition[3];
	new minAnnounce = GetConVarInt(hMinPounceAnnounce);
	
	//get hunter-related pounce cvars
	new max = ConVar_max;
	new min = ConVar_min;
	new maxDmg = ConVar_maxdmg;
	
	//Get current position while pounced
	GetClientAbsOrigin(attackerClient,pouncePosition);
	
	//Calculate 2d distance between previous position and pounce position
	new distance = RoundToNearest(GetVectorDistance(infectedPosition[attackerClient], pouncePosition));
	
	//Get damage using hunter damage formula
	//damage in this is expressed as a float because my server has competitive hunter pouncing where the decimal counts
	new Float:dmg = (((distance - float(min)) / float(max - min)) * float(maxDmg)) + 1;
	
	if(distance >= min && dmg >= minAnnounce)
	{
		StatisticPounce(attackerClient);
		PrintTopPouncers();
		Pounced(attackerClient);
		
		if(GetConVarBool(hChat) == true)
		{
			decl String:pounceLine[256];
			Format(pounceLine,sizeof(pounceLine),"\x01[\x05TS\x01] \x04%N \x01pounced \x05%N \x01for \x03%.01f \x01damage.(Max: %d)",attackerClient,victimClient,dmg,maxDmg + 1);
			PrintToChatAll(pounceLine);	
		}
	}
}

public Action:Event_LungePounce(Handle:event, String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "userid"));
	g_bIsPouncing[attacker] = false;
	g_bHasLandedPounce[attacker] = true;
	return Plugin_Continue;
}

public Action:Event_Replace(Handle:event, String:name[], bool:dontBroadcast)
{
	new player = GetClientOfUserId(GetEventInt(event, "player"));
	new bot = GetClientOfUserId(GetEventInt(event, "bot"));
	Skeets[player] = 0;
	Skeets[bot] = 0;
	Kills[player] = 0;
	Kills[bot] = 0;
	return Plugin_Continue;
}

public Action:Event_PlayerHurt(Handle:event, String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!victim || !IsClientInGame(victim))
	{
		return Plugin_Continue;
	}
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	new damage = GetEventInt(event, "dmg_health");
	if (IsValidClient(attacker) && GetClientTeam(attacker) == 2)
	{
		if (IsPlayerHunter(victim))
		{
			if (!g_bShotCounted[victim][attacker])
			{
				g_iShotsDealt[victim][attacker]++;
				g_bShotCounted[victim][attacker] = true;
			}
			new remaining_health = GetEventInt(event, "health");
			if (0 >= remaining_health)
			{
				return Plugin_Continue;
			}
			g_iLastHealth[victim] = remaining_health;
			g_iDamageDealt[victim][attacker] += damage;
		}
	}
	return Plugin_Continue;
}

public Action:Event_PlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!victim || !IsClientInGame(victim))
	{
		return Plugin_Continue;
	}
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (attacker == 0 || !IsClientInGame(attacker))
	{
		if (GetClientTeam(victim) == 3)
		{
			ClearDamage(victim);
		}
		return Plugin_Continue;
	}
	if (GetClientTeam(attacker) == 2 && GetClientTeam(victim) == 3)
	{
		new zombieclass = GetEntProp(victim, PropType:0, "m_zombieClass", 4);
		if (zombieclass == 5)
		{
			return Plugin_Continue;
		}
		new lasthealth = g_iLastHealth[victim];
		g_iDamageDealt[victim][attacker] += lasthealth ;
		if (zombieclass == 3 && g_bIsPouncing[victim] == true)
		{
			decl assisters[g_iSurvivorLimit][2];
			new assister_count;
			new shots = g_iShotsDealt[victim][attacker];
			for (new i=1;i <= MaxClients;++i)
			{
				if (!(attacker == i))
				{
					if (g_iDamageDealt[victim][i] > 0 && IsClientInGame(i))
					{
						assisters[assister_count][0] = i;
						assisters[assister_count][1] = g_iDamageDealt[victim][i];
						assister_count++;
					}
				}
			}
			if (assister_count)
			{
			}
			else
			{
				if (!IsFakeClient(victim) || (IsFakeClient(victim) && GetConVarBool(g_hCvarAIHunter)) )
				{
					if (!IsFakeClient(attacker))
					{
						new mode = GetConVarInt(OneShotSkeet);
						if (mode == 1)
						{
							if (shots == 1)
							{
								StatisticSkeet(attacker);
								PrintTopSkeeters();
								Skeeted(attacker);
								Skeets[attacker]++;
								Kills[attacker]++;
							}
						}
						else
						{
							StatisticSkeet(attacker);
							PrintTopSkeeters();
							Skeeted(attacker);
							Skeets[attacker]++;
							Kills[attacker]++;
						}
						if (shots == 1)
						{
							if(CvarAnnounce == 1)
							{
								PrintToChatAll("\x01[\x04SM\x01] %N skeeted %N in 1 shot.", attacker, victim);
							}
						}
						else
						{
							if(CvarAnnounce == 1)
							{
								PrintToChatAll("\x01[\x04SM\x01] %N skeeted %N in %i shots.", attacker, victim,shots);
							}
						}
					}
				}
			}
		}
		else
		{
			Kills[attacker]++;
		}
	}
	if (GetClientTeam(victim) == 3)
	{
		ClearDamage(victim);
	}
	return Plugin_Continue;
}

public Action:Award(Handle:timer, any:client)
{
	if (client < any:0 && !IsClientInGame(client))
	{
		return Action:4;
	}
	
	new random = GetRandomInt(1, 3);
	switch(random)
	{
		case 1 : EmitSoundToAll("player/damage1.wav", client, 3, 140, 0, 1.0);
		case 2 : EmitSoundToAll("player/damage2.wav", client, 3, 140, 0, 1.0);
		case 3 : EmitSoundToAll("player/neck_snap_01.wav", client, 3, 140, 0, 1.0);
	}
	return Action:4;
}

public Action:Timer_GroundedCheck(Handle:timer, any:client)
{
	if ((isClient(client) && IsGrounded(client)) || !IsValidAliveClient(client))
	{
		g_bIsPouncing[client] = false;
		remove_damage(client);
		KillTimer(timer, false);
	}
	return Plugin_Continue;
}

public Action:Timer_DeadstopCheck(Handle:timer, Handle:pack)
{
	ResetPack(pack, false);
	new attacker = ReadPackCell(pack);
	if (!g_bHasLandedPounce[attacker])
	{
		new victim = ReadPackCell(pack);
		if (!IsFakeClient(victim) || (IsFakeClient(victim) && GetConVarBool(g_hCvarAIHunter)) )
		{
			if (IsClientInGame(victim) && IsClientInGame(attacker))
			{
				DeadStoped[attacker]++;
				if (!IsFakeClient(attacker))
				{
					if(CvarAnnounce == 1)
					{
						PrintToChat(attacker, "\x01[\x04SM\x01] \x03You \x01DeadStoped \x04%N", victim);
					}
				}
				if (!IsFakeClient(victim))
				{
					if(CvarAnnounce == 1)
					{
						PrintToChat(victim, "\x01[\x04SM\x01] \x03You \x01were deadstopped by \x04%N", attacker);
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

Pounced(client)
{
	CreateTimer(0.1, Award, client, 2);
}

StatisticPounce(client)
{
	new String:clientname[32];
	GetClientName(client, clientname, 32);
	ReplaceString(clientname, 32, "'", "", true);
	ReplaceString(clientname, 32, "<", "", true);
	ReplaceString(clientname, 32, "{", "", true);
	ReplaceString(clientname, 32, "}", "", true);
	ReplaceString(clientname, 32, "\n", "", true);
	ReplaceString(clientname, 32, "\"", "", true);
	new String:clientauth[32];
	GetClientAuthId(client, AuthId_Steam2, clientauth, 32);
	new Handle:Data = CreateKeyValues("pouncedata", "", "");
	new count;
	new pounce;
	FileToKeyValues(Data, datafilepathpounce);
	KvJumpToKey(Data, "data", true);
	if (!KvJumpToKey(Data, clientauth, false))
	{
		KvGoBack(Data);
		KvJumpToKey(Data, "info", true);
		count = KvGetNum(Data, "count", 0);
		KvSetNum(Data, "count", ++count);
		KvGoBack(Data);
		KvJumpToKey(Data, "data", true);
		KvJumpToKey(Data, clientauth, true);
	}
	pounce = KvGetNum(Data, "pounce", 0);
	KvSetNum(Data, "pounce", ++pounce);
	KvSetString(Data, "name", clientname);
	KvRewind(Data);
	KeyValuesToFile(Data, datafilepathpounce);
	CloseHandle(Data);
	if(GetConVarBool(hChat) == true)
	{
		PrintToChat(client, "\x01[\x04SM\x01] \x03You \x04have \x01%d pounces.", pounce);
	}
}

PrintTopPouncers(client = 0)
{
	new Handle:Data = CreateKeyValues("pouncedata", "", "");
	new count;
	if (!FileToKeyValues(Data, datafilepathpounce))
	{
		return;
	}
	KvJumpToKey(Data, "info", false);
	count = KvGetNum(Data, "count", 0);
	new String:names[count][32];
	new pounces[count][2];
	new totalspounces=0;
	KvGoBack(Data);
	KvJumpToKey(Data, "data", false);
	KvGotoFirstSubKey(Data, true);
	for (new i=0;i<count;++i)
	{
		KvGetString(Data, "name", names[i], 32, "Unnamed");
		pounces[i][0] = i;
		pounces[i][1] = KvGetNum(Data, "pounce", 0);
		totalspounces += pounces[i][1];
		KvGotoNextKey(Data, true);
	}
	CloseHandle(Data);
	SortCustom2D(pounces, count, Sort_Function, Handle:0);
	
	new Handle:Panell = CreatePanel(Handle:0);
	SetPanelTitle(Panell, "Top 5 Pouncers                     ", false);
	DrawPanelText(Panell, "\n ");
	new String:text[256];
	if (totalspounces)
	{
		if (count > 5) count = 5;
		for (new i=0;i<count;++i)
		{
			Format(text, 255, "%d pounces - %s", pounces[i][1], names[pounces[i][0]]);
			DrawPanelItem(Panell, text);
		}
		DrawPanelText(Panell, "\n");
		Format(text, 255, "Total %d pounces on the server.", totalspounces);
		DrawPanelText(Panell, text);
	}
	else
	{
		Format(text, 255, "There are no pounces on this server yet.");
	}
	
	if(client == 0)
	{
		for (new i=1;i<=MaxClients;++i)
		{	
			if (IsClientInGame(i) && !IsFakeClient(i))
			{
				SendPanelToClient(Panell, i, TopPouncePanelHandler, 5);
			}
		}
	}
	else
	{
		SendPanelToClient(Panell, client, TopPouncePanelHandler, 5);
	}
	CloseHandle(Panell);
	return;
}

public TopPouncePanelHandler(Handle:menu, MenuAction:action, param1, param2)
{
	return 0;
}

ShowPounceRank(client)
{
	if (!client)
	{
		client = 1;
	}
	
	new Handle:Data = CreateKeyValues("pouncedata", "", "");
	new count;
	if (!FileToKeyValues(Data, datafilepathpounce))
	{
		return;
	}
	KvJumpToKey(Data, "info", false);
	count = KvGetNum(Data, "count", 0);
	KvGoBack(Data);
	KvJumpToKey(Data, "data", false);
	new pounce;
	new String:auth[32];
	GetClientAuthId(client, AuthId_Steam2, auth, 32);
	if (KvJumpToKey(Data, auth, false))
	{
		pounce = KvGetNum(Data, "pounce", 0);
	}
	else
	{
		pounce = 0;
	}
	new place = TopToP(pounce);
	PrintToChat(client, "Pounce Ranking: \x04%d\x01/\x05%d", place, count);
	CloseHandle(Data);
	return;
}

TopToP(pouncei)
{
	new Handle:Data = CreateKeyValues("pouncedata", "", "");
	new count;
	if (!FileToKeyValues(Data, datafilepathpounce))
	{
		return 0;
	}
	KvJumpToKey(Data, "info", false);
	count = KvGetNum(Data, "count", 0);
	new pounce[count];
	KvGoBack(Data);
	KvJumpToKey(Data, "data", false);
	KvGotoFirstSubKey(Data, true);
	new totalwin;
	for (new i=0;i < count;++i)
	{
		pounce[i] = KvGetNum(Data, "pounce", 0);
		if (pounce[i] >= pouncei)
		{
			totalwin++;
		}
		KvGotoNextKey(Data, true);
	}
	CloseHandle(Data);
	return totalwin;
}

PrintPouncesToClient(client)
{
	if (!client)
	{
		client = 1;
	}

	new Handle:Data = CreateKeyValues("pouncedata", "", "");
	new pounce;
	if (!FileToKeyValues(Data, datafilepathpounce))
	{
		PrintToChat(client, "\x03There is no \x01data yet.");
		return;
	}
	new String:auth[32];
	GetClientAuthId(client, AuthId_Steam2, auth, 32);
	KvJumpToKey(Data, "data", false);
	KvJumpToKey(Data, auth, false);
	pounce = KvGetNum(Data, "pounce", 0);
	CloseHandle(Data);
	if (pounce == 1)
	{
		PrintToChat(client, "\x04You \x03only \x01have 1 pounce.");
	}
	else if (pounce <= 0)
	{
		PrintToChat(client, "\x03You \x01don't have pounces.");
	}
	else
	{
		PrintToChat(client, "\x04You \x03have \x01%d pounces.", pounce);
	}
	return;
}

public Sort_Function(array1[], array2[], completearray[][], Handle:hndl)
{
	if (array1[1] > array2[1])
	{
		return -1;
	}
	if (array1[1] == array2[1])
	{
		return 0;
	}
	return 1;
}

remove_damage(client)
{
	for (new i=1;MaxClients >= i;++i)
	{
		g_damage[client][i] = 0;
	}
}

bool:IsGrounded(client)
{
	return GetEntProp(client, PropType:1, "m_fFlags", 4) & 1 > 0;
}

StatisticSkeet(client)
{
	new String:clientname[32];
	GetClientName(client, clientname, 32);
	ReplaceString(clientname, 32, "'", "", true);
	ReplaceString(clientname, 32, "<", "", true);
	ReplaceString(clientname, 32, "{", "", true);
	ReplaceString(clientname, 32, "}", "", true);
	ReplaceString(clientname, 32, "\n", "", true);
	ReplaceString(clientname, 32, "\"", "", true);
	new String:clientauth[32];
	GetClientAuthId(client, AuthId_Steam2, clientauth, 32);
	new Handle:Data = CreateKeyValues("skeetdata", "", "");
	new count;
	new skeet;
	FileToKeyValues(Data, datafilepathskeet);
	KvJumpToKey(Data, "data", true);
	if (!KvJumpToKey(Data, clientauth, false))
	{
		KvGoBack(Data);
		KvJumpToKey(Data, "info", true);
		count = KvGetNum(Data, "count", 0);
		count++;
		KvSetNum(Data, "count", count);
		KvGoBack(Data);
		KvJumpToKey(Data, "data", true);
		KvJumpToKey(Data, clientauth, true);
	}
	skeet = KvGetNum(Data, "skeet", 0);
	skeet++;
	KvSetNum(Data, "skeet", skeet);
	KvSetString(Data, "name", clientname);
	KvRewind(Data);
	KeyValuesToFile(Data, datafilepathskeet);
	CloseHandle(Data);
	if(CvarAnnounce == 1)
	{
		PrintToChat(client, "\x01[\x04SM\x01] \x03You \x04have \x01%d skeets", skeet);
	}
}

ClearDamage(client)
{
	for (new i=1;i <= MaxClients;++i)
	{
		g_iDamageDealt[client][i] = 0;
		g_iShotsDealt[client][i] = 0;
	}
}

bool:IsValidClient(client)
{
	if (client < 1 || client > MaxClients)
	{
		return false;
	}
	if (!IsValidEntity(client))
	{
		return false;
	}
	return true;
}

ClearSkeetCounter()
{
	for (new i=1;i <= MaxClients;++i)
	{
		Skeets[i] = 0;
		Kills[i] = 0;
		DeadStoped[i] = 0;
	}
}

PrintStats()
{
	new survivor_index = -1;
	new survivor_clients[8];
	new client;
	for (client=1;client <= MaxClients;++client)
	{
		if (!IsClientInGame(client) || GetClientTeam(client) == 2 || IsFakeClient(client))
		{
		}
		else
		{
			survivor_index++;
			survivor_clients[survivor_index] = client;
		}
	}
	SortCustom1D(survivor_clients, 8, SortByDamageDesc, Handle:0);
	PrintToChatAll("\x01------------------------------");
	decl frags;
	decl skeetscount;
	decl shoved;
	for (new i=0;i <= survivor_index;++i)
	{
		client = survivor_clients[i];
		frags = Kills[client];
		skeetscount = Skeets[client];
		shoved = DeadStoped[client];
		PrintToChatAll("\x04%N \x03(Frags: \x01%i \x03| Skeets: \x01%i \x03| Deadstops: \x01%i\x03)", client, frags, skeetscount, shoved);
	}
	PrintToChatAll("\x01------------------------------");
}

public SortByDamageDesc(elem1, elem2, array[], Handle:hndl)
{
	if (Kills[elem1] > Kills[elem2])
	{
		return -1;
	}
	if (Kills[elem2] > Kills[elem1])
	{
		return 1;
	}
	if (elem1 > elem2)
	{
		return -1;
	}
	if (elem2 > elem1)
	{
		return 1;
	}
	return 0;
}

Skeeted(client)
{
	CreateTimer(0.1, Award, client, 2);
	timerDeath[client] = 200;
}

bool:IsPlayerHunter(client)
{
	if (GetEntProp(client, PropType:0, "m_zombieClass", 4) == 3)
	{
		return true;
	}
	return false;
}

bool:IsValidAliveClient(client)
{
	if (client <= 0)
	{
		return false;
	}
	if (client > MaxClients)
	{
		return false;
	}
	if (!IsClientInGame(client))
	{
		return false;
	}
	if (!IsPlayerAlive(client))
	{
		return false;
	}
	return true;
}

public bool:isClient(client)
{
	return IsClientConnected(client) && IsClientInGame(client);
}

public Action:Command_Say(client, args)
{
	if (args < 1)
	{
		return Plugin_Continue;
	}
	decl String:text[16];
	GetCmdArg(1, text, 15);
	if (StrContains(text, "!skeets", true))
	{
		if (StrContains(text, "/skeets", true))
		{
			if (StrContains(text, "!top10", true))
			{
				if (StrContains(text, "!rank", true))
				{
					return Plugin_Continue;
				}
				ShowSkeetRank(client);
				return Plugin_Continue;
			}
			PrintTopSkeetersToClient(client);
			return Plugin_Continue;
		}
		PrintSkeetsToClient(client);
		return Plugin_Continue;
	}
	PrintSkeetsToClient(client);
	return Plugin_Continue;
}

PrintTopSkeetersToClient(client)
{
	if (!client)
	{
		client = 1;
	}

	new Handle:Data = CreateKeyValues("skeetdata", "", "");
	new count;
	if (!FileToKeyValues(Data, datafilepathskeet))
	{
		return;
	}
	KvJumpToKey(Data, "info", false);
	count = KvGetNum(Data, "count", 0);
	new String:names[count][32];
	new skeets[count][2];
	new totalskeets=0;
	KvGoBack(Data);
	KvJumpToKey(Data, "data", false);
	KvGotoFirstSubKey(Data, true);
	for (new i=0;i<count;++i)
	{
		KvGetString(Data, "name", names[i], 32, "Unnamed");
		skeets[i][0] = i;
		skeets[i][1] = KvGetNum(Data, "skeet", 0);
		totalskeets += skeets[i][1];
		KvGotoNextKey(Data, true);
	}
	CloseHandle(Data);
	SortCustom2D(skeets, count, Sort_Function, Handle:0);
	new Handle:Panell = CreatePanel(Handle:0);
	new oneshot = GetConVarInt(OneShotSkeet);
	if (oneshot == 1)
	{
		SetPanelTitle(Panell, "Best One Shot Skeeters            ", false);
	}
	else
	{
		SetPanelTitle(Panell, "Top 5 Skeeters                    ", false);
	}
	DrawPanelText(Panell, "\n ");
	new String:text[256];
	if (totalskeets)
	{
		if (count > 5)
		{
			count = 5;
		}
		for (new i=0;i<count;++i)
		{
			Format(text, 255, "%d skeets - %s", skeets[i][1], names[skeets[i][0]]);
			DrawPanelItem(Panell, text);
		}
		DrawPanelText(Panell, "\n ");
		Format(text, 255, "Total %d skeets on the server.", totalskeets);
		DrawPanelText(Panell, text);
	}
	else
	{
		Format(text, 255, "There are no skeets on this server yet.");
	}
	SendPanelToClient(Panell, client, TopSkeetPanelHandler, 5);
	CloseHandle(Panell);
	return;
}

PrintTopSkeeters()
{
	new Handle:Data = CreateKeyValues("skeetdata", "", "");
	new count;
	if (!FileToKeyValues(Data, datafilepathskeet))
	{
		return;
	}
	KvJumpToKey(Data, "info", false);
	count = KvGetNum(Data, "count", 0);
	new String:names[count][32];
	new skeets[count][2];
	new totalskeets=0;
	KvGoBack(Data);
	KvJumpToKey(Data, "data", false);
	KvGotoFirstSubKey(Data, true);
	for (new i=0;i<count;++i)
	{
		KvGetString(Data, "name", names[i], 32, "Unnamed");
		skeets[i][0] = i;
		skeets[i][1] = KvGetNum(Data, "skeet", 0);
		totalskeets += skeets[i][1];
		KvGotoNextKey(Data, true);
	}
	CloseHandle(Data);
	SortCustom2D(skeets, count, Sort_Function, Handle:0);
	new Handle:Panell = CreatePanel(Handle:0);
	new oneshot = GetConVarInt(OneShotSkeet);
	if (oneshot == 1)
	{
		SetPanelTitle(Panell, "5 Best One Shot skeeters            ", false);
	}
	else
	{
		SetPanelTitle(Panell, "Top 5 Skeeters                     ", false);
	}
	DrawPanelText(Panell, "\n ");
	new String:text[256];
	if (totalskeets)
	{
		if (count > 5)
		{
			count = 5;
		}
		for (new i=0;i<count;++i)
		{
			Format(text, 255, "%d skeets - %s", skeets[i][1], names[skeets[i][0]]);
			DrawPanelItem(Panell, text);
		}
		DrawPanelText(Panell, "\n ");
		Format(text, 255, "Total %d skeets on the server.", totalskeets);
		DrawPanelText(Panell, text);
	}
	else
	{
		Format(text, 255, "There are no skeets on this server yet.");
	}
	for (new i=1;i<=MaxClients;++i)
	{	
		if (IsClientInGame(i) && !IsFakeClient(i))
		{
			SendPanelToClient(Panell, i, TopSkeetPanelHandler, 5);
		}
	}
	CloseHandle(Panell);
	return;
}

PrintSkeetsToClient(client)
{
	if (!client)
	{
		client = 1;
	}
	
	new Handle:Data = CreateKeyValues("skeetdata", "", "");
	new skeet;
	if (!FileToKeyValues(Data, datafilepathskeet))
	{
		PrintToChat(client, "\x03There is no \x01data.");
		return;
	}
	new String:auth[32];
	GetClientAuthId(client, AuthId_Steam2, auth, 32);
	KvJumpToKey(Data, "data", false);
	KvJumpToKey(Data, auth, false);
	skeet = KvGetNum(Data, "skeet", 0);
	CloseHandle(Data);
	if (skeet == 1)
	{
		PrintToChat(client, "\x04You \x03only \x011 skeet.");
	}
	else if (skeet < 1)
	{
		PrintToChat(client, "\x03You \x01don't have skeets.");
	}
	else
	{
		PrintToChat(client, "\x04You \x03have \x01%d skeets.", skeet);
	}
	return;
}

ShowSkeetRank(client)
{
	if (!client)
	{
		client = 1;
	}
	
	new Handle:Data = CreateKeyValues("skeetdata", "", "");
	new count;
	if (!FileToKeyValues(Data, datafilepathskeet))
	{
		return;
	}
	KvJumpToKey(Data, "info", false);
	count = KvGetNum(Data, "count", 0);
	KvGoBack(Data);
	KvJumpToKey(Data, "data", false);
	new skeet;
	new String:auth[32];
	GetClientAuthId(client, AuthId_Steam2, auth, 32);
	if (KvJumpToKey(Data, auth, false))
	{
		skeet = KvGetNum(Data, "skeet", 0);
	}
	else
	{
		skeet = 0;
	}
	new place = TopToS(skeet);
	PrintToChat(client, "Skeet Ranking: %d/%d", place, count);
	CloseHandle(Data);
	return;
}

TopToS(skeeti)
{
	new Handle:Data = CreateKeyValues("skeetdata", "", "");
	new count;
	if (!FileToKeyValues(Data, datafilepathskeet))
	{
		return 0;
	}
	KvJumpToKey(Data, "info", false);
	count = KvGetNum(Data, "count", 0);
	new skeet[count];
	KvGoBack(Data);
	KvJumpToKey(Data, "data", false);
	KvGotoFirstSubKey(Data, true);
	new total;
	for (new i=0;i < count;++i)
	{
		skeet[i] = KvGetNum(Data, "skeet", 0);
		if (skeet[i] >= skeeti)
		{
			total++;
		}
		KvGotoNextKey(Data, true);
	}
	CloseHandle(Data);
	return total;
}

public TopSkeetPanelHandler(Handle:menu, MenuAction:action, param1, param2)
{
	return 0;
}

public Action:Event_RoundStart(Handle:hEvent, String:strName[], bool:DontBroadcast)
{
	ClearSkeetCounter();
	g_bRoundEndAnnounce = false;
	return Plugin_Continue;
}

public ConVarChange_hCvarAnnounce(Handle:convar, const String:oldValue[], const String:newValue[])
{	
	if (!StrEqual(oldValue, newValue))
		CvarAnnounce = StringToInt(newValue);
}

public Action:Event_RoundEnd(Handle:hEvent, String:strName[], bool:DontBroadcast)
{
	for (new i=1;i <= MaxClients;++i)
	{
		ClearDamage(i);
	}
	if (!g_bRoundEndAnnounce)
	{
		if(CvarAnnounce == 1)
			PrintStats();
		g_bRoundEndAnnounce = true;
	}
	return Plugin_Continue;
}

public Action:weapon_fire(Handle:event, String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	for (new i=1;i <= MaxClients;++i)
	{
		g_bShotCounted[i][client] = false;
	}
	return Plugin_Continue;
}

public Action:Event_PlayerShoved(Handle:event, String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!victim || !IsClientInGame(victim))
	{
		return Plugin_Continue;
	}
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	if (attacker == 0 || !IsClientInGame(attacker) || GetClientTeam(attacker) != 2)
	{
		return Plugin_Continue;
	}
	new zombieclass = GetEntProp(victim, PropType:0, "m_zombieClass", 4);
	if (zombieclass == 3 && g_bIsPouncing[victim])
	{
		if (IsFakeClient(victim) && !GetConVarBool(g_hCvarAIHunter) )
		{
			return Plugin_Continue;
		}
		g_bIsPouncing[victim] = false;
		g_bHasLandedPounce[attacker] = false;
		new Handle:pack;
		CreateDataTimer(0.2, Timer_DeadstopCheck, pack, 0);
		WritePackCell(pack, attacker);
		WritePackCell(pack, victim);
	}
	return Plugin_Continue;
}