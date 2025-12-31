/*
	Strings
*/
new String:Admflag[32];

public IsClientAdmin(client) 
{
	if(StrEqual(Admflag, "a"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Reservation))
			return true; 

	if(StrEqual(Admflag, "b"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Generic))
			return true; 

	if(StrEqual(Admflag, "c"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Kick))
			return true; 

	if(StrEqual(Admflag, "d"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Ban))
			return true; 

	if(StrEqual(Admflag, "e"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Unban))
			return true; 

	if(StrEqual(Admflag, "f"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Slay))
			return true; 

	if(StrEqual(Admflag, "g"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Changemap))
			return true; 

//	if(StrEqual(Admflag, "h"))
//		if(GetAdminFlag(GetUserAdmin(client), Admin_Cvars)) (SM BUG? ADMINFLAG_CVAR DONT WORK)
//			return true; 

	if(StrEqual(Admflag, "i"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Config))
			return true; 

	if(StrEqual(Admflag, "j"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Chat))
			return true; 

	if(StrEqual(Admflag, "k"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Vote))
			return true; 

	if(StrEqual(Admflag, "l"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Password))
			return true; 

	if(StrEqual(Admflag, "m"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_RCON))
			return true; 

	if(StrEqual(Admflag, "n"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Cheats))
			return true; 

	if(StrEqual(Admflag, "o"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Custom1))
			return true; 

	if(StrEqual(Admflag, "p"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Custom2))
			return true; 

	if(StrEqual(Admflag, "q"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Custom3))
			return true; 

	if(StrEqual(Admflag, "r"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Custom4))
			return true; 

	if(StrEqual(Admflag, "s"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Custom5))
			return true; 

	if(StrEqual(Admflag, "t"))
		if(GetAdminFlag(GetUserAdmin(client), Admin_Custom6))
			return true; 

	return false; 
}