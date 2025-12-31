/*
	Variables
*/
new Unlimited;
new AllowScout;
new AllowSniper;
new AllowSoldier;
new AllowDemoMan;
new AllowMedic;
new AllowHeavy;
new AllowPyro;
new AllowSpy;
new AllowEngineer;
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
new bool:WinAllow;
new bool:RoundEnd = false;
new bool:AllowIntel = false;
new bool:HaveIntel[MAXPLAYERS+1] = false;
new bool:HudInfo[MAXPLAYERS+1];
new bool:FlyKeys;
new bool:FuelInfo;
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
new Handle:gWinAllow = INVALID_HANDLE;
new Handle:gAllowIntel = INVALID_HANDLE;
new Handle:gAllowScout = INVALID_HANDLE;
new Handle:gAllowSniper = INVALID_HANDLE;
new Handle:gAllowSoldier = INVALID_HANDLE;
new Handle:gAllowDemoMan = INVALID_HANDLE;
new Handle:gAllowMedic = INVALID_HANDLE;
new Handle:gAllowHeavy = INVALID_HANDLE;
new Handle:gAllowPyro = INVALID_HANDLE;
new Handle:gAllowSpy = INVALID_HANDLE;
new Handle:gAllowEngineer = INVALID_HANDLE;
new Handle:gFlySound = INVALID_HANDLE;
new Handle:gParticle1 = INVALID_HANDLE;
new Handle:gParticle2 = INVALID_HANDLE;
new Handle:gFlyKeys = INVALID_HANDLE;
new Handle:gReloadSound = INVALID_HANDLE;
new Handle:gEmptySound = INVALID_HANDLE;
new Handle:gFuelInfo = INVALID_HANDLE;
new Handle:gAdvControl = INVALID_HANDLE;
/*
	String
*/
new String:FlySound[256];
new String:Particle1[128];
new String:Particle2[128];
new String:ReloadSound[256];
new String:EmptySound[256];

Init_CVars()
{
	gCjetEnable = CreateConVar("sm_cjet_enabled", "1", "Crazy Jet plugin enabled?", FCVAR_NONE, true, 0.0, true, 1.0);
	gOnlyAdmins = CreateConVar("sm_cjet_adminonly", "0", "Crazy Jet for admins only?", FCVAR_NONE, true, 0.0, true, 1.0);
	gAdmflag = CreateConVar("sm_cjet_adminflag", "b", "If adminonly is enabled, put here a flag for filter users", FCVAR_NONE);
	gUnlimited = CreateConVar("sm_cjet_unlimited", "0", "Unlimited fuel. 0 dont unlimited / 1 all / 2 adm only", FCVAR_NONE, true, 0.0, true, 2.0);
	gForce = CreateConVar("sm_cjet_force", "450", "Jet fly force", FCVAR_NONE, true, 100.0, true, 1000.0);
	gJetMaxUses = CreateConVar("sm_cjet_fuel", "200.0", "Fuel of jet. -1/s if flying", FCVAR_NONE, true, 10.0, true, 1000.0);
	gReloadTime = CreateConVar("sm_cjet_time", "5.0", "Time to jet charge", FCVAR_NONE, true, 0.0, true, 1000.0);
	gResetOnSpawn = CreateConVar("sm_cjet_reset_respawn", "0", "Reset jet fuel on player respawn?", FCVAR_NONE, true, 0.0, true, 1.0);
	gWinAllow = CreateConVar("sm_cjet_win_allow", "0", "Allow use Jet on round end?", FCVAR_NONE, true, 0.0, true, 1.0);
	gAllowIntel = CreateConVar("sm_cjet_intel_allow", "0", "Allow use Jet while carry intel?", FCVAR_NONE, true, 0.0, true, 1.0);
	gAllowScout = CreateConVar("sm_cjet_allow_scout", "1", "Allow scout use jet?", FCVAR_NONE, true, 0.0, true, 1.0);
	gAllowSniper = CreateConVar("sm_cjet_allow_sniper", "1", "Allow sniper use jet?", FCVAR_NONE, true, 0.0, true, 1.0);
	gAllowSoldier = CreateConVar("sm_cjet_allow_soldier", "1", "Allow soldier use jet?", FCVAR_NONE, true, 0.0, true, 1.0);
	gAllowDemoMan = CreateConVar("sm_cjet_allow_demoman", "1", "Allow demoman use jet?", FCVAR_NONE, true, 0.0, true, 1.0);
	gAllowMedic = CreateConVar("sm_cjet_allow_medic", "1", "Allow medic use jet?", FCVAR_NONE, true, 0.0, true, 1.0);
	gAllowHeavy = CreateConVar("sm_cjet_allow_heavy", "1", "Allow heavy use jet?", FCVAR_NONE, true, 0.0, true, 1.0);
	gAllowPyro = CreateConVar("sm_cjet_allow_pyro", "1", "Allow pyro use jet?", FCVAR_NONE, true, 0.0, true, 1.0);
	gAllowSpy = CreateConVar("sm_cjet_allow_spy", "1", "Allow spy use jet?", FCVAR_NONE, true, 0.0, true, 1.0);
	gAllowEngineer = CreateConVar("sm_cjet_allow_engineer", "1", "Allow engineer use jet?", FCVAR_NONE, true, 0.0, true, 1.0);
	gFlySound = CreateConVar("sm_cjet_fly_sound", "ambient/boiler_01.wav", "Sound of jet fly", FCVAR_NONE);
	gReloadSound = CreateConVar("sm_cjet_reload_sound", "weapons/recon_ping.wav", "Sound if jet reload the fuel", FCVAR_NONE);
	gEmptySound = CreateConVar("sm_cjet_empty_sound", "weapons/buffed_off.wav", "Sound if jet empty of fuel", FCVAR_NONE);
	gParticle1 = CreateConVar("sm_cjet_primary_particle", "burningplayer_rainbow_OLD", "Base particle effect", FCVAR_NONE);
	gParticle2 = CreateConVar("sm_cjet_secondary_particle", "burningplayer_rainbow_stars", "Secondary particle effect", FCVAR_NONE);
	gFlyKeys = CreateConVar("sm_cjet_fly_keys", "0", "Keys to fly. 0 default (jump) / 1 custom (jump + mouse attack2)", FCVAR_NONE, true, 0.0, true, 1.0);
	gFuelInfo = CreateConVar("sm_cjet_fuel_info", "0", "Fuel on HUD. 0 default (text) / 1 custom (splash bar)", FCVAR_NONE, true, 0.0, true, 1.0);
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
	HookConVarChange(gWinAllow, ConVarChange);
	HookConVarChange(gAllowIntel, ConVarChange);
	HookConVarChange(gAllowScout, ConVarChange);
	HookConVarChange(gAllowSniper, ConVarChange);
	HookConVarChange(gAllowSoldier, ConVarChange);
	HookConVarChange(gAllowDemoMan, ConVarChange);
	HookConVarChange(gAllowMedic, ConVarChange);
	HookConVarChange(gAllowHeavy, ConVarChange);
	HookConVarChange(gAllowPyro, ConVarChange);
	HookConVarChange(gAllowSpy, ConVarChange);
	HookConVarChange(gAllowEngineer, ConVarChange);
	HookConVarChange(gFlySound, ConVarChange);
	HookConVarChange(gParticle1, ConVarChange);
	HookConVarChange(gParticle2, ConVarChange);
	HookConVarChange(gFlyKeys, ConVarChange);
	HookConVarChange(gReloadSound, ConVarChange);
	HookConVarChange(gEmptySound, ConVarChange);
	HookConVarChange(gFuelInfo, ConVarChange);
	HookConVarChange(gAdvControl, ConVarChange);

	CjetEnable = GetConVarBool(gCjetEnable);
	OnlyAdmins = GetConVarBool(gOnlyAdmins);
	GetConVarString(gAdmflag, Admflag, sizeof(Admflag));
	Unlimited = GetConVarInt(gUnlimited);
	Force = GetConVarFloat(gForce);
	JetMaxUses = GetConVarFloat(gJetMaxUses);
	ReloadTime = GetConVarFloat(gReloadTime);
	ResetOnSpawn = GetConVarBool(gResetOnSpawn);
	WinAllow = GetConVarBool(gWinAllow);
	AllowIntel = GetConVarBool(gAllowIntel);
	AllowScout = GetConVarBool(gAllowScout);
	AllowSniper = GetConVarBool(gAllowSniper);
	AllowSoldier = GetConVarBool(gAllowSoldier);
	AllowDemoMan = GetConVarBool(gAllowDemoMan);
	AllowMedic = GetConVarBool(gAllowMedic);
	AllowHeavy = GetConVarBool(gAllowHeavy);
	AllowPyro = GetConVarBool(gAllowPyro);
	AllowSpy = GetConVarBool(gAllowSpy);
	AllowEngineer = GetConVarBool(gAllowEngineer);
	GetConVarString(gFlySound, FlySound, sizeof(FlySound));
	GetConVarString(gParticle1, Particle1, sizeof(Particle1));
	GetConVarString(gParticle2, Particle2, sizeof(Particle2));
	FlyKeys = GetConVarBool(gFlyKeys);
	GetConVarString(gReloadSound, ReloadSound, sizeof(ReloadSound));
	GetConVarString(gEmptySound, EmptySound, sizeof(EmptySound));
	FuelInfo = GetConVarBool(gFuelInfo);
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
	WinAllow = GetConVarBool(gWinAllow);
	AllowIntel = GetConVarBool(gAllowIntel);
	AllowScout = GetConVarBool(gAllowScout);
	AllowSniper = GetConVarBool(gAllowSniper);
	AllowSoldier = GetConVarBool(gAllowSoldier);
	AllowDemoMan = GetConVarBool(gAllowDemoMan);
	AllowMedic = GetConVarBool(gAllowMedic);
	AllowHeavy = GetConVarBool(gAllowHeavy);
	AllowPyro = GetConVarBool(gAllowPyro);
	AllowSpy = GetConVarBool(gAllowSpy);
	AllowEngineer = GetConVarBool(gAllowEngineer);
	GetConVarString(gFlySound, FlySound, sizeof(FlySound));
	GetConVarString(gParticle1, Particle1, sizeof(Particle1));
	GetConVarString(gParticle2, Particle2, sizeof(Particle2));
	FlyKeys = GetConVarBool(gFlyKeys);
	GetConVarString(gReloadSound, ReloadSound, sizeof(ReloadSound));
	GetConVarString(gEmptySound, EmptySound, sizeof(EmptySound));
	FuelInfo = GetConVarBool(gFuelInfo);
	AdvControl = GetConVarBool(gAdvControl);
}