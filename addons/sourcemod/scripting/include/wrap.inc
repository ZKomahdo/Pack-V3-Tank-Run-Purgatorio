/**
 * =============================================================================
 * Left 4 Dead Stocks Library (C)2012 Michael "Sky" Toth
 * =============================================================================
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * As a special exception, AlliedModders LLC gives you permission to link the
 * code of this program (as well as its derivative works) to "Half-Life 2," the
 * "Source Engine," the "SourcePawn JIT," and any Game MODs that run on software
 * by the Valve Corporation.  You must obey the GNU General Public License in
 * all respects for all other code used.  Additionally, AlliedModders LLC grants
 * this exception to all derivative works.  AlliedModders LLC defines further
 * exceptions, found in LICENSE.txt (as of this writing, version JULY-31-2007),
 * or <http://www.sourcemod.net/license.php>.
 */

#if defined _wrap_included
 #endinput
#endif
#define _wrap_included

#include <sourcemod>

stock ExecCheatCommand(client = 0,const String:command[],const String:parameters[] = "")
{
	new iFlags = GetCommandFlags(command);
	SetCommandFlags(command,iFlags & ~FCVAR_CHEAT);

	if(!IsClientHuman(client))
	{
		ServerCommand("%s %s",command,parameters);
	}
	else
	{
		FakeClientCommand(client,"%s %s",command,parameters);
	}

	SetCommandFlags(command,iFlags);
	SetCommandFlags(command,iFlags|FCVAR_CHEAT);
}

stock bool:IsClientActual(client)
{
	if (client < 1 || client > MaxClients || !IsClientInGame(client)) return false;
	return true;
}

stock bool:IsClientBot(client)
{
	if (!IsClientActual(client)) return false;
	if (IsFakeClient(client)) return true;
	/*
	decl String:Key[64];
	GetClientAuthString(client, Key, sizeof(Key));
	if (StrEqual(Key, "BOT")) return true;
	*/
	return false;
}

stock bool:IsClientHuman(client)
{
	if (IsClientActual(client) && !IsFakeClient(client)) return true;
	return false;
}

stock bool:IsGhost(client)
{
	return bool:GetEntProp(client, Prop_Send, "m_isGhost", 1);
}