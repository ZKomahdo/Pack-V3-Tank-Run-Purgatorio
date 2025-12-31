/*
	Variables
*/
new Unlimited;
new AllowTR;
new AllowCT;
new AdvControl;
/*
	Float
*/
new Float:Force;
new Float:ReloadTime;
new Float:JetMaxUses;
new Float:jetUses[MAXPLAYERS+1];
/*
	Bools
*/
new bool:CjetEnable;
new bool:OnlyAdmins;
new bool:Activated[MAXPLAYERS+1];
new bool:HaveJet[MAXPLAYERS+1];
new bool:ResetOnSpawn;
new bool:Flying[MAXPLAYERS+1];
new bool:HudInfo[MAXPLAYERS+1];
new bool:FlyKeys;
/*
	Handles
*/
new Handle:gCjetEnable = INVALID_HANDLE;
new Handle:gOnlyAdmins = INVALID_HANDLE;
new Handle:gAdmflag = INVALID_HANDLE;
new Handle:gUnlimited = INVALID_HANDLE;
new Handle:gForce = INVALID_HANDLE;
new Handle:gJetMaxUses = INVALID_HANDLE;
new Handle:gReloadTime = INVALID_HANDLE;
new Handle:hReloadTime[MAXPLAYERS+1];
new Handle:gResetOnSpawn = INVALID_HANDLE;
new Handle:gFlyKeys = INVALID_HANDLE;
new Handle:gFlySound = INVALID_HANDLE;
new Handle:gReloadSound = INVALID_HANDLE;
new Handle:gEmptySound = INVALID_HANDLE;
new Handle:gAllowTR = INVALID_HANDLE;
new Handle:gAllowCT = INVALID_HANDLE;
new Handle:gAdvControl = INVALID_HANDLE;
/*
	String
*/
new String:FlySound[256];
new String:ReloadSound[256];
new String:EmptySound[256];

Init_CVars()
{
	gCjetEnable = CreateConVar("sm_cjet_enabled", "1", "Crazy Jet plugin enabled?", FCVAR_NONE, true, 0.0, true, 1.0);
	gOnlyAdmins = CreateConVar("sm_cjet_adminonly", "0", "Crazy Jet for admins only?", FCVAR_NONE, true, 0.0, true, 1.0);
	gAdmflag = CreateConVar("sm_cjet_adminflag", "b", "If adminonly is enabled, put here a flag for filter users", FCVAR_NONE);
	gUnlimited = CreateConVar("sm_cjet_unlimited", "0", "Unlimited fuel. 0 dont unlimited / 1 all / 2 adm only", FCVAR_NONE, true, 0.0, true, 2.0);
	gForce = CreateConVar("sm_cjet_force", "450", "Jet fly force", FCVAR_NONE, true, 100.0, true, 1000.0);
	gAllowTR = CreateConVar("sm_cjet_allow_tr", "1", "Allow terrorists use jet?", FCVAR_NONE, true, 0.0, true, 1.0);
	gAllowCT = CreateConVar("sm_cjet_allow_ct", "1", "Allow counter-terrorists use jet?", FCVAR_NONE, true, 0.0, true, 1.0);
	gJetMaxUses = CreateConVar("sm_cjet_fuel", "200.0", "Fuel of jet. -1/s if flying", FCVAR_NONE, true, 10.0, true, 1000.0);
	gReloadTime = CreateConVar("sm_cjet_time", "5.0", "Time to jet charge", FCVAR_NONE, true, 0.0, true, 1000.0);
	gResetOnSpawn = CreateConVar("sm_cjet_reset_respawn", "0", "Reset jet fuel on player respawn?", FCVAR_NONE, true, 0.0, true, 1.0);
	gFlyKeys = CreateConVar("sm_cjet_fly_keys", "0", "Keys to fly. 0 default (jump) / 1 custom (jump + mouse attack2)", FCVAR_NONE, true, 0.0, true, 1.0);
	gFlySound = CreateConVar("sm_cjet_fly_sound", "ambient/machines/gas_loop_1.wav", "Sound of jet fly", FCVAR_NONE);
	gReloadSound = CreateConVar("sm_cjet_reload_sound", "buttons/weapon_confirm.wav", "Sound if jet reload the fuel", FCVAR_NONE);
	gEmptySound = CreateConVar("sm_cjet_empty_sound", "buttons/weapon_cant_buy.wav", "Sound if jet empty of fuel", FCVAR_NONE);
	gAdvControl = CreateConVar("sm_cjet_adv_control", "0", "Advanced jet control? (beta)", FCVAR_NONE, true, 0.0, true, 1.0);
	AutoExecConfig(true, "sm_crazy_jet");

	HookConVarChange(gCjetEnable, ConVarChange);
	HookConVarChange(gOnlyAdmins, ConVarChange);
	HookConVarChange(gAdmflag, ConVarChange);
	HookConVarChange(gUnlimited, ConVarChange);
	HookConVarChange(gForce, ConVarChange);
	HookConVarChange(gJetMaxUses, ConVarChange);
	HookConVarChange(gReloadTime, ConVarChange);
	HookConVarChange(gResetOnSpawn, ConVarChange);
	HookConVarChange(gFlyKeys, ConVarChange);
	HookConVarChange(gFlySound, ConVarChange);
	HookConVarChange(gReloadSound, ConVarChange);
	HookConVarChange(gEmptySound, ConVarChange);
	HookConVarChange(gAllowTR, ConVarChange);
	HookConVarChange(gAllowCT, ConVarChange);
	HookConVarChange(gAdvControl, ConVarChange);

	CjetEnable = GetConVarBool(gCjetEnable);
	OnlyAdmins = GetConVarBool(gOnlyAdmins);
	GetConVarString(gAdmflag, Admflag, sizeof(Admflag));
	Unlimited = GetConVarInt(gUnlimited);
	Force = GetConVarFloat(gForce);
	JetMaxUses = GetConVarFloat(gJetMaxUses);
	ReloadTime = GetConVarFloat(gReloadTime);
	ResetOnSpawn = GetConVarBool(gResetOnSpawn);
	FlyKeys = GetConVarBool(gFlyKeys);
	GetConVarString(gFlySound, FlySound, sizeof(FlySound));
	GetConVarString(gReloadSound, ReloadSound, sizeof(ReloadSound));
	GetConVarString(gEmptySound, EmptySound, sizeof(EmptySound));
	AllowTR = GetConVarBool(gAllowTR);
	AllowCT = GetConVarBool(gAllowCT);
	AdvControl = GetConVarBool(gAdvControl);
}

public ConVarChange(Handle:convar, const String:oldValue[], const String:newValue[])
{
	CjetEnable = GetConVarBool(gCjetEnable);
	OnlyAdmins = GetConVarBool(gOnlyAdmins);
	GetConVarString(gAdmflag, Admflag, sizeof(Admflag));
	Unlimited = GetConVarInt(gUnlimited);
	Force = GetConVarFloat(gForce);
	JetMaxUses = GetConVarFloat(gJetMaxUses);
	ReloadTime = GetConVarFloat(gReloadTime);
	ResetOnSpawn = GetConVarBool(gResetOnSpawn);
	FlyKeys = GetConVarBool(gFlyKeys);
	GetConVarString(gFlySound, FlySound, sizeof(FlySound));
	GetConVarString(gReloadSound, ReloadSound, sizeof(ReloadSound));
	GetConVarString(gEmptySound, EmptySound, sizeof(EmptySound));
	AllowTR = GetConVarBool(gAllowTR);
	AllowCT = GetConVarBool(gAllowCT);
	AdvControl = GetConVarBool(gAdvControl);
}