#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = {
    name = "soundboard",
    author = "",
    description = "",
    version = "0.0.1",
    url = "none"
};

public void OnPluginStart()
{
	LoadTranslations("common.phrases");
	LoadTranslations("sounds.phrases");
        RegAdminCmd("sm_tratra", Cmd_tratra, ADMFLAG_VOTE, "" );
	RegConsoleCmd("sm_ds", Cmd_ds, "Refuse to disable ds." );
	RegAdminCmd("sm_aaa", Cmd_aaa, ADMFLAG_VOTE, "" );
	RegAdminCmd("sm_hola", Cmd_hola, ADMFLAG_VOTE, "" );

	RegConsoleCmd("sm_hb", Cmd_hb, "hb" );
	RegAdminCmd("sm_soundboard", Cmd_soundboard, ADMFLAG_VOTE, "print all commands" );

	PrecacheSound("common\\null.wav");
	PrecacheSound("dystopia\\tratra.mp3");
	PrecacheSound("dystopia\\callate.mp3");
	PrecacheSound("dystopia\\hola2.mp3");
}


public Action Command_Play(const char[] arguments)
{

	for(int i=1; i<=MaxClients; i++)
	{
		if( !IsClientInGame(i) )
		continue;
     	  	ClientCommand(i, "playgamesound %s", arguments);

	}  
	//return Plugin_Handled;
}

