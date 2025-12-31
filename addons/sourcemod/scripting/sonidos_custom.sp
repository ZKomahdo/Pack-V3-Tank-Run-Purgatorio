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
	RegAdminCmd("sm_mataron", Cmd_mataron, ADMFLAG_VOTE, "" );
	RegAdminCmd("sm_fuera", Cmd_fuera3, ADMFLAG_VOTE, "" );
	RegAdminCmd("sm_cagada",Cmd_cagada, ADMFLAG_VOTE, "" );
	RegAdminCmd("sm_creen", Cmd_creen, ADMFLAG_VOTE, "" );
	RegAdminCmd("sm_dina", Cmd_dina, ADMFLAG_VOTE, "" );
	RegAdminCmd("sm_aya", Cmd_aya, ADMFLAG_VOTE, "" );
	RegAdminCmd("sm_waza", Cmd_wazaa, ADMFLAG_VOTE, "" );
	RegAdminCmd("sm_ayuda", Cmd_ayuda, ADMFLAG_VOTE, "" );
	RegAdminCmd("sm_señores", Cmd_senores, ADMFLAG_VOTE, "" );
	RegAdminCmd("sm_noo", Cmd_noo, ADMFLAG_VOTE, "" );
	RegAdminCmd("sm_tmr", Cmd_tmr, ADMFLAG_VOTE, "" );
	RegAdminCmd("sm_vuela", Cmd_vuela, ADMFLAG_VOTE, "" );


	PrecacheSound("ROOT\\tratra.mp3");
	PrecacheSound("ROOT\\mataron.mp3");
	PrecacheSound("ROOT\\fuera3.mp3");
	PrecacheSound("ROOT\\cagada.mp3");
	PrecacheSound("ROOT\\creen.mp3");
	PrecacheSound("ROOT\\dina.mp3");
	PrecacheSound("ROOT\\aya.mp3");
	PrecacheSound("ROOT\\wazaa.mp3");
	PrecacheSound("ROOT\\ayuda.mp3");
	PrecacheSound("ROOT\\senores.mp3");
	PrecacheSound("ROOT\\noo.mp3");
	PrecacheSound("ROOT\\tmr.mp3");
	PrecacheSound("ROOT\\vuela.mp3");
}




public Action Cmd_tratra(int client,int args)
{
	Command_Play("ROOT\\tratra.mp3");
	return Plugin_Handled;
}


public Action Cmd_mataron(int client,int args)
{
	Command_Play("ROOT\\mataron.mp3");
	return Plugin_Handled;
}


public Action Cmd_fuera3(int client,int args)
{
	Command_Play("ROOT\\fuera3.mp3");
	return Plugin_Handled;
}


public Action Cmd_cagada(int client,int args)
{
	Command_Play("ROOT\\cagada.mp3");
	return Plugin_Handled;
}


public Action Cmd_creen(int client,int args)
{
	Command_Play("ROOT\\creen.mp3");
	return Plugin_Handled;
}


public Action Cmd_dina(int client,int args)
{
	Command_Play("ROOT\\dina.mp3");
	return Plugin_Handled;
}


public Action Cmd_aya(int client,int args)
{
	Command_Play("ROOT\\aya.mp3");
	return Plugin_Handled;
}


public Action Cmd_wazaa(int client,int args)
{
	Command_Play("ROOT\\wazaa.mp3");
	return Plugin_Handled;
}


public Action Cmd_ayuda(int client,int args)
{
	Command_Play("ROOT\\ayuda.mp3");
	return Plugin_Handled;
}


public Action Cmd_senores(int client,int args)
{
	Command_Play("ROOT\\senores.mp3");
	return Plugin_Handled;
}


public Action Cmd_noo(int client,int args)
{
	Command_Play("ROOT\\noo.mp3");
	return Plugin_Handled;
}


public Action Cmd_tmr(int client,int args)
{
	Command_Play("ROOT\\tmr.mp3");
	return Plugin_Handled;
}


public Action Cmd_vuela(int client,int args)
{
	Command_Play("ROOT\\vuela.mp3");
	return Plugin_Handled;
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
