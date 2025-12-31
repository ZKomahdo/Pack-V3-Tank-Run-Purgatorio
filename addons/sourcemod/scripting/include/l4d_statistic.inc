#if defined _l4d_statistic_included
	#endinput
#endif
#define _l4d_statistic

/*
* Меню было создано
* The menu was created
*/
forward void ST_OnBuild();
/*
* Игрок нажал пункт меню
* The player pressed a menu item
*/
forward void ST_OnSelectItem(int client);
/*
* Дейсвие при нажании param в ST_OnSelectItem
* Action when pressing param in ST_OnSelectItem
*/
forward void ST_OnDrawItem(int client, int &style);

/*
* Зарегистрировать пункт в меню
* Register item in menu
*/
native void ST_RegisterItem(const char[] display = "", int style = ITEMDRAW_DEFAULT);

/*
 *	Called when the statistics plugin has loaded.
*/
forward void L4D_Statistic_Loaded();

/*
*	Get the number of killed zombies by the client.
*	enum IDATA
*/
native int GetPlayerData(int client, int data);

/*
 *	Get the name of the client's rank.
*/
native int GetPlayerRankName(int client, char[] sRank, int iSize);

/*
*	Get the number of hits on a specific hit by the player.
*	enum HITBOXES
*/
native int GetPlayerHits(int client, int hit);

/*
*	enum IWEAPON
*/
native int GetPlayerCountItemFire(int client, int index);

/*
*	enum IDATAKILLS
*/
native int GetPlayerCountDataKills(int client, int index);

/*
* Client information.
*/
enum
{
	GmameTime,
	FinaleWin,
	PlayerTop,
	PlayerDead,
	Player_Fire,
	Player_Hurt,
	Player_Damage,
	IDATA
}

/*
*	Получить данные по количеству выстрелов-ударов огнестрельным или ближнем боем. Счётчик использования медикаментов.
*	Get data on the number of shots-strikes with firearms or close combat. Medication use counter.
*	enum IWEAPON
*/
enum
{
	//Weapons
	pistol,
	pistol_magnum,
	autoshotgun,
	shotgun_chrome,
	pumpshotgun,
	shotgun_spas,
	smg,
	smg_mp5,
	smg_silenced,
	rifle_ak47,
	rifle_sg552,
	rifle,
	rifle_m60,
	rifle_desert,
	hunting_rifle,
	sniper_military,
	sniper_awp,
	sniper_scout,
	weapon_grenade_launcher,
	// Grenades
	molotov,
	pipe_bomb,
	vomitjar,
	// Melee
	melee,
	baseball_bat,
	cricket_bat,
	crowbar,
	electric_guitar,
	fireaxe,
	frying_pan,
	katana,
	knife,
	machete,
	tonfa,
	// Medication
	pain_pills,
	adrenaline,
	defibrillator,
	first_aid_kit,
	IWEAPON
}

/*
* Information of the player's hits on the body parts of the players or the infected.
*/
enum 
{
	NULL_HITBOX,
	HEAD,
	CHEST,
	STOMACH,
	LEFT_ARM,
	RIGHT_ARM,
	LEFT_LEG,
	RIGHT_LEG,
	HITBOXES
}

/*
*	Data on the number of players killed or infected.
*	Данные о количестве убитых игроков или зараженных.
*	enum IDATAKILLS
*/
enum 
{
	infected_death,
	tank_killed,
	boomer_exploded,
	hunter_headshot,
	charger_killed,
	spitter_killed,
	jockey_killed,
	witch_killed,
	survivor_killed,
	IDATAKILLS
}

public SharedPlugin __pl_l4d_statistic = 
{
	name = "l4d_statistic",
	file = "l4d_statistic.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public __pl_l4d_statistic_SetNTVOptional()
{
	MarkNativeAsOptional("GetPlayerData");
	MarkNativeAsOptional("GetPlayerRankName");
	MarkNativeAsOptional("GetPlayerHits");
	MarkNativeAsOptional("GetPlayerCountItemFire");
	MarkNativeAsOptional("GetPlayerCountDataKills");
}
#endif
