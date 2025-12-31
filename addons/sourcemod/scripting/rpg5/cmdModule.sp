new String:sBuffer1[MAXPLAYERS + 1][MAX_CHAT_LENGTH];
new bool:ClearBuffer_Timer[MAXPLAYERS + 1];

_cmdModule_OnPluginStart()
{
	RegConsoleCmd("say", SayTrigger);
	RegConsoleCmd("say_team", TeamSayTrigger);

	RegConsoleCmd("hidecmds", HideCommands);
}

_cmdModule_RoundEnd()
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || IsFakeClient(i)) continue;
		ClearBuffer_Timer[i] = false;
	}
}

public Action:HideCommands(client, args)
{
	if (cmds[client] == 1)
	{
		PrintToChat(client, "%s You will no longer see who used commands in the chat box.", CMDS_INFO);
		cmds[client] = 0;
	}
	else
	{
		PrintToChat(client, "%s You will now see who used commands in the chat box.", CMDS_INFO);
		cmds[client] = 1;
	}
}

static const String:PUBLICCOMMANDS[][] = {
	"health",
	"heal",
	"shop",
	"ammo",
	"haste",
	"respawn",
	"saferespawn",
	"laser",
	"up",
	"htp",
	"tank",
	"witch",
	"kill",
	"cost",
	"usepoints",
	"buy",
	"fly",
	"extinguish",
	"idle",
	"afk",
	"spectate",
	"tv",
	"healthmenu",
	"shotguns",
	"rifles",
	"snipers",
	"melee",
	"notify",
	"join",
	"language",
	"sharepoints",
	"sp",
	"perfume",
	"teams",
	"privatechat",
	"worlditems",
	"votenow",
	"sprint",
	"repeatbuy",
	"showinfo",
	"showpoints",
	"tntstart",
	"survivor",
	"infected",
	"jointeam",
	"helpme",
	"incap",
	"cp",
	"preset", 
	"wiki"
};

public Action:SayTrigger(client,args)
{
	if (client == 0) return Plugin_Continue;
	decl String:sBuffer[MAX_CHAT_LENGTH];
	decl String:chatBuffer[MAX_CHAT_LENGTH + 256];
	decl String:tBuffer[64];
	decl String:Level[64];
	if (args < 1) return Plugin_Continue; // Too few or too many arguments
	GetCmdArg(1,sBuffer,sizeof(sBuffer));
	StripQuotes(sBuffer);
	if (StrContains(sBuffer,"!") != 0 && StrContains(sBuffer,"/") != 0 && !StrEqual(ChatColor[client][0], "def") && 
		!StrEqual(ChatColor[client][1], "def") && !StrEqual(ChatColor[client][2], "def") && 
		!StrEqual(ChatColor[client][3], "def"))
	{
		// ! and / were not the first chars of the string text.
		if (GetClientTeam(client) == 1) Format(tBuffer, sizeof(tBuffer), "Spectator");
		else if (GetClientTeam(client) == 2) Format(tBuffer, sizeof(tBuffer), "Survivor");
		else if (GetClientTeam(client) == 3) Format(tBuffer, sizeof(tBuffer), "Infected");
		
		if (GetClientTeam(client) == 2) Format(Level, sizeof(Level), "%s[%sLv. %s%d%s]", ChatColor[client][0], ChatColor[client][1], ChatColor[client][2], Ph[client][2], ChatColor[client][0]);
		else if (GetClientTeam(client) == 3) Format(Level, sizeof(Level), "%s[%sLv. %s%d%s]", ChatColor[client][0], ChatColor[client][1], ChatColor[client][2], In[client][2], ChatColor[client][0]);

		if (GetClientTeam(client) != 1) Format(chatBuffer, sizeof(chatBuffer), "%s(%s%s%s) %s%N %s%s: %s%s", ChatColor[client][0], ChatColor[client][1], tBuffer, ChatColor[client][0], 
												ChatColor[client][2], client, Level, ChatColor[client][0], ChatColor[client][3], sBuffer);
		else Format(chatBuffer, sizeof(chatBuffer), "%s(%s%s%s) %s%N%s: %s%s", ChatColor[client][0], ChatColor[client][1], tBuffer, ChatColor[client][0], 
					ChatColor[client][2], client, ChatColor[client][0], ChatColor[client][3], sBuffer);

		PrintToChatAll("%s", chatBuffer);

		return Plugin_Handled;
	}
	for (new j; j < sizeof(PUBLICCOMMANDS); j++)
	{
		if (StrContains(sBuffer,PUBLICCOMMANDS[j], false) != 1) continue;
		if (!StrEqual(sBuffer, sBuffer1[client]))
		{
			if (GetClientTeam(client) == 2)
			{
				for (new i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 2 || cmds[i] == 0) continue;
					PrintToChat(i, "%s \x03%N \x01used command \x04%s", CMDS_INFO, client, sBuffer);
				}
			}
			else if (GetClientTeam(client) == 3)
			{
				for (new i = 1; i <= MaxClients; i++)
				{
					if (!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 3 || cmds[i] == 0) continue;
					PrintToChat(i, "%s \x04%N \x01used command \x04%s", CMDS_INFO, client, sBuffer);
				}
			}
		}
		sBuffer1[client] = sBuffer;
		if (ClearBuffer_Timer[client] == false)
		{
			ClearBuffer_Timer[client] = true;
			CreateTimer(30.0, ClearBuffer, client, TIMER_FLAG_NO_MAPCHANGE);
		}
		return Plugin_Handled;
	}	
	return Plugin_Continue;
}

public Action:ClearBuffer(Handle:timer, any:client)
{
	if (!IsClientInGame(client) || IsFakeClient(client)) return Plugin_Stop;
	ClearBuffer_Timer[client] = false;
	sBuffer1[client] = "none";
	return Plugin_Stop;
}

public Action:TeamSayTrigger(client,args)
{
	decl String:sBuffer[MAX_CHAT_LENGTH];
	decl String:chatBuffer[MAX_CHAT_LENGTH + 256];
	decl String:tBuffer[64];
	decl String:Level[64];
	if (args < 1) return Plugin_Continue; // Too few or too many arguments
	GetCmdArg(1,sBuffer,sizeof(sBuffer));
	StripQuotes(sBuffer);
	if (StrContains(sBuffer,"!") != 0 && StrContains(sBuffer,"/") != 0 && StrContains(sBuffer,"@") != 0 && 
		!StrEqual(ChatColor[client][0], "def") && !StrEqual(ChatColor[client][1], "def") && !StrEqual(ChatColor[client][2], "def") && 
		!StrEqual(ChatColor[client][3], "def"))
	{
		// ! and / and @ were not the first chars of the string text.
		if (GetClientTeam(client) == 1) Format(tBuffer, sizeof(tBuffer), "Spectator Only");
		else if (GetClientTeam(client) == 2) Format(tBuffer, sizeof(tBuffer), "Survivor Only");
		else if (GetClientTeam(client) == 3) Format(tBuffer, sizeof(tBuffer), "Infected Only");

		if (GetClientTeam(client) == 2) Format(Level, sizeof(Level), "%s[%sLv. %s%d%s]", ChatColor[client][0], ChatColor[client][1], ChatColor[client][2], Ph[client][2], ChatColor[client][0]);
		else if (GetClientTeam(client) == 3) Format(Level, sizeof(Level), "%s[%sLv. %s%d%s]", ChatColor[client][0], ChatColor[client][1], ChatColor[client][2], In[client][2], ChatColor[client][0]);

		if (GetClientTeam(client) != 1) Format(chatBuffer, sizeof(chatBuffer), "%s(%s%s%s) %s%N%s%s: %s%s", ChatColor[client][0], ChatColor[client][1], tBuffer, ChatColor[client][0], 
												ChatColor[client][2], client, Level, ChatColor[client][0], ChatColor[client][3], sBuffer);
		else Format(chatBuffer, sizeof(chatBuffer), "%s(%s%s%s) %s%N%s: %s%s", ChatColor[client][0], ChatColor[client][1], tBuffer, ChatColor[client][0], 
					ChatColor[client][2], client, ChatColor[client][0], ChatColor[client][3], sBuffer);

		if (GetClientTeam(client) == 1) PrintToSpectators("%s", chatBuffer);
		else if (GetClientTeam(client) == 2) PrintToSurvivors("%s", chatBuffer);
		else if (GetClientTeam(client) == 3) PrintToInfected("%s", chatBuffer);

		return Plugin_Handled;
	}
	
	for (new i; i < sizeof(PUBLICCOMMANDS); i++)
	{
		if (StrContains(sBuffer,PUBLICCOMMANDS[i], false) != 1) continue;
		return Plugin_Handled;
	}
	return Plugin_Continue;
}