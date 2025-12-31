#include <sourcemod>
#include <sdkhooks>
#include <multicolors>
public Plugin myinfo =
{
    name = "Calculadora",
    author = "marcel",
    description = "fun",
    version = "1.0",
    url = ""
};
char kupka[MAXPLAYERS+1];
char words[256]={
	'a','b','c','d',
	'e','f','g','h',
	'i','j','k','l',
	'm','n','o','p',
	'q','r','s','t',
	'u','v','w','x',
	'y','z','-','+',
	'!','@','#','$',
	'%','^','&','*',
	'(',')','{','}',
	':','"','<','>',
	'?','\0'};
public void OnPluginStart()
{
	RegConsoleCmd("cld",calculator);
	RegConsoleCmd("calcular",AddNumbers);
}
public void OnClientConnected(int client)
{
	if(!IsFakeClient(client))
	{
		kupka[client]='x';
	}
}

public int wypisz(Menu menu, MenuAction action, int param1, int param2)
{
	char infos[32];
	if(action==MenuAction_Select)
	{
		menu.GetItem(param2,infos,sizeof(infos));
		kupka[param1]='\0';
		if(StrEqual(infos,"a")){StrCat(kupka[param1],MAXPLAYERS+1,infos);}
		else if(StrEqual(infos,"s")){StrCat(kupka[param1],MAXPLAYERS+1,infos);}
		else if(StrEqual(infos,"m")){StrCat(kupka[param1],MAXPLAYERS+1,infos);}
		else if(StrEqual(infos,"d")){StrCat(kupka[param1],MAXPLAYERS+1,infos);}
	}
	return 0;
}

public Action calculator(int client,int args)
{
	if(client == 0)return Plugin_Handled;
	Menu menu = CreateMenu(wypisz);
	menu.SetTitle("★ Calculadora ★");
	menu.AddItem("a","Sumar");
	menu.AddItem("s","Sustraer");
	menu.AddItem("m","Multiplicar");
	menu.AddItem("d","Dividir");
	menu.Display(client,20);
	
	return Plugin_Handled;
}

public Action AddNumbers(int client, int args)
{
	char buffor[256];
	int a=0;
	int b=0;
	if(StrEqual(kupka[client],"x")){PrintToChat(client,"\x04[\x03CALCULADORA\x04] \x05lo siento, pero primero debes usar el comando \x04!cld, \x05para usar \x04!calcular");return Plugin_Handled;}
	int lengths = GetCmdArgString(buffor, sizeof(buffor));
	if((args <= 0 && args < 2) || (CheckArguments(buffor,lengths) == true)){PrintToChat(client,"\x04★ \x05máximo de \x04dos \x05argumentos!");return Plugin_Handled;}
	
	// checks arguments
	a=GetCmdArgInt(1);
	b=GetCmdArgInt(2);
	
	if(StrEqual(kupka[client],"a"))
	{
		PrintToChat(client,"\x05Resultado \x04(\x03+\x04)");
		PrintToChat(client,"\x05%d \x01+\x05%d \x01= \x03%d",a,b,a+b);
		PrintToChat(client,"\x04--------------");
	}
	else if(StrEqual(kupka[client],"s"))
	{
		PrintToChat(client,"\x05Resultado \x04(\x03-\x04)");
		PrintToChat(client,"\x05%d \x01- \x05%d \x01= \x03%d",a,b,a-b);
		PrintToChat(client,"\x04--------------");
	}
	else if(StrEqual(kupka[client],"m"))
	{
		PrintToChat(client,"\x05Resultado \x04(\x03x\x04)");
		PrintToChat(client,"\x05%d \x01= \x05%d \x01= \x03%d",a,b,a*b);
		PrintToChat(client,"\x04--------------");
	}
	else if(StrEqual(kupka[client],"d"))
	{
		if(b == 0){PrintToChat(client,"\x04★ \x05Nosotros no dividimos por \x03cero!");return Plugin_Handled;}
		PrintToChat(client,"\x05Resultado \x04(\x03/\x04)");
		PrintToChat(client,"\x05%d \x01/ \x05%d \x01= \x03%d",a,b,a/b);
		PrintToChat(client,"\x04--------------");
	}
	else
	{
		PrintToChat(client,"\x04★ \x05Error desconocido con la \x03calculadora!");
	}
	return Plugin_Handled;
}

bool CheckArguments(char[] buffor,int lengths)
{
	for(int i=0;i<lengths;i++)
	{
		if(buffor[i] == ' ')continue;
		for(int j=0;j<(sizeof(words)/1);j++)
		{
			if(words[j] != '\0' && buffor[i] == words[j])return true;
		}
	}
	return false;
}