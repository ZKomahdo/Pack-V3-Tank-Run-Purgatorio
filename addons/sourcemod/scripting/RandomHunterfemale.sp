#include <sourcemod>
#include <sdktools>
#pragma semicolon 1

#define PLUGIN_VERSION "1.0"

#define MODEL_HUNTER_HONOKA			  "models/infected/honoka_hunter.mdl"
#define MODEL_HUNTER_HUNTRESS		  "models/infected/huntress.mdl"
#define MODEL_HUNTER_FELICIA 		  "models/infected/felicia_hunter.mdl"
#define MODEL_HUNTER_HARU		  	  "models/infected/haru_hunter.mdl"
#define MODEL_HUNTER_MILEENA		  "models/infected/mileena_hunter.mdl"
#define MODEL_HUNTER_MILEENA_A		  "models/infected/muleena_hunter.mdl"

#define TEAM_INFECTED                 3

#define L4D2_ZOMBIECLASS_HUNTER       3

public Plugin:myinfo = 
{
	name = "RandomHunter(Female)",
	author = "Ludastar (Armonic), Benjamin(edit hunters)",
	description = "Just Adds the chance between each hunter model",
	version = PLUGIN_VERSION,
	url = ""
}

public OnPluginStart()
{	
	HookEvent("player_spawn", Event_PlayerSpawn);
}

public OnMapStart()
{
	/*honoka hunter*/
	AddFileToDownloadsTable("models/infected/honoka_hunter.dx90.vtx");
	AddFileToDownloadsTable("models/infected/honoka_hunter.mdl");
	AddFileToDownloadsTable("models/infected/honoka_hunter.phy");
	AddFileToDownloadsTable("models/infected/honoka_hunter.vvd");
	
	AddFileToDownloadsTable("materials/hunterhonoka/2.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/3.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/alisa_head_wrp.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/body-nrm.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/evy_skin_body.vmt");
	AddFileToDownloadsTable("materials/hunterhonoka/evy_skin_body.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/evy_skin_body_normal.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_backhair_base.vmt");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_backhair_base.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_backhair_nrm.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_cos_002_other02_base.vmt");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_cos_002_other02_base.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_dlcr_001_cloth02_base.vmt");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_dlcr_001_cloth02_base.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_face_base.vmt");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_face_base.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_face_nrm_vlh2_pp1.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_front_hair_base.vmt");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_front_hair_base.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_front_hair_nrm.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_glasses_base.vmt");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_glasses_base.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_hair_head_base.vmt");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_hair_head_base.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_hair_head_nrm.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_matuge_base_pp1.vmt");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_matuge_base_pp1.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_pony_base_pp5.vmt");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_pony_base_pp5.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/hon_pony_nrm.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/lightwarp.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/lis_body_bump.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/l_3.vmt");
	AddFileToDownloadsTable("materials/hunterhonoka/l_3.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/mar_matuge_base_pp1.vmt");
	AddFileToDownloadsTable("materials/hunterhonoka/mar_matuge_base_pp1.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/n.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/nyo_body_base.vmt");
	AddFileToDownloadsTable("materials/hunterhonoka/nyo_body_base.vtf");
	AddFileToDownloadsTable("materials/hunterhonoka/phongwarp_hair.vtf");
	
	
	
	/*Huntress*/
	AddFileToDownloadsTable("models/infected/huntress.dx90.vtx");
	AddFileToDownloadsTable("models/infected/huntress.mdl");
	AddFileToDownloadsTable("models/infected/huntress.phy");
	AddFileToDownloadsTable("models/infected/huntress.vvd");
	
	AddFileToDownloadsTable("materials/models/infected/hunter/synicle_clothes.vmt");
	AddFileToDownloadsTable("materials/models/infected/hunter/synicle_clothes.vtf");
	AddFileToDownloadsTable("materials/models/infected/hunter/synicle_clothes_bump.vtf");
	AddFileToDownloadsTable("materials/models/infected/hunter/synicle_skin.vmt");
	AddFileToDownloadsTable("materials/models/infected/hunter/synicle_skin.vtf");
	AddFileToDownloadsTable("materials/models/infected/hunter/synicle_skin_bump.vtf");
	
	
	/*Hunter felicia*/
	AddFileToDownloadsTable("models/infected/felicia_hunter.dx90.vtx");
	AddFileToDownloadsTable("models/infected/felicia_hunter.mdl");
	AddFileToDownloadsTable("models/infected/felicia_hunter.vvd");
	
	AddFileToDownloadsTable("materials/models/infected/felicia143/jiemao_d.vmt");
	AddFileToDownloadsTable("materials/models/infected/felicia143/jiemao_d.vtf");
	AddFileToDownloadsTable("materials/models/infected/felicia143/kouqiang_d.vmt");
	AddFileToDownloadsTable("materials/models/infected/felicia143/kouqiang_d.vtf");
	AddFileToDownloadsTable("materials/models/infected/felicia143/lianhetoufa_d.vmt");
	AddFileToDownloadsTable("materials/models/infected/felicia143/lianhetoufa_d.vtf");
	AddFileToDownloadsTable("materials/models/infected/felicia143/shenti_d.vmt");
	AddFileToDownloadsTable("materials/models/infected/felicia143/shenti_d.vtf");
	AddFileToDownloadsTable("materials/models/infected/felicia143/yanqiu_d.vmt");
	AddFileToDownloadsTable("materials/models/infected/felicia143/yanqiu_d.vtf");
	
	/*Hunter haru*/
	AddFileToDownloadsTable("models/infected/haru_hunter.dx90.vtx");
	AddFileToDownloadsTable("models/infected/haru_hunter.mdl");
	AddFileToDownloadsTable("models/infected/haru_hunter.phy");
	AddFileToDownloadsTable("models/infected/haru_hunter.vvd");
	
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_cashhair06_hair_29_mask_01.vmt");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_cashhair06_hair_29_mask_01.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_default_socks_05.vmt");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_default_socks_05.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_desire_eye_02.vmt");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_desire_eye_02.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_back_10.vmt");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_back_10.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_costume03_09.vmt");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_costume03_09.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_costume03_09_alpha.vmt");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_costume03_09_alpha.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_glove_05.vmt");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_glove_05.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_hairacc01_01.vmt");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_hairacc01_01.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_shoes_12.vmt");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_shoes_12.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_socks_11.vmt");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_socks_11.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_tail_13.vmt");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_eq_nightmare_tail_13.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_parts_default_body_03.vmt");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_parts_default_body_03.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_parts_default_face_02.vmt");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/pc_a_parts_default_face_02.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/warp.vtf");
	AddFileToDownloadsTable("materials/models/infected/succubus/haru/warp_mirror.vtf");
	
	/*mileena hunter*/
	AddFileToDownloadsTable("models/infected/mileena_hunter.dx90.vtx");
	AddFileToDownloadsTable("models/infected/mileena_hunter.mdl");
	AddFileToDownloadsTable("models/infected/mileena_hunter.phy");
	AddFileToDownloadsTable("models/infected/mileena_hunter.vvd");
	
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/body.vmt");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/eyeball_l.vmt");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/eyeball_r.vmt");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/eyelashes.vmt");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/eyelashes_diff.vtf");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/eye_diff.vtf");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/facemap.vmt");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/facemap.vtf");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/facemap_n.vtf");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/gold.vmt");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/hair_diff.vtf");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/hair_diffuse.vmt");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/hair_n.vtf");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/leather.vmt");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/mileena.vtf");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/mileena_n.vtf");
	AddFileToDownloadsTable("materials/models/dpfilms/characters/mileena/violet.vmt");
	
	
	
	/*muleena hunter*/
	AddFileToDownloadsTable("models/infected/muleena_hunter.dx90.vtx");
	AddFileToDownloadsTable("models/infected/muleena_hunter.mdl");
	AddFileToDownloadsTable("models/infected/muleena_hunter.phy");
	AddFileToDownloadsTable("models/infected/muleena_hunter.vvd");
	
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/body.vmt");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/eyeball_l.vmt");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/eyeball_r.vmt");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/eyelashes.vmt");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/eyelashes_diff.vtf");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/eye_diff.vtf");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/facemap.vmt");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/facemap.vtf");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/facemap_n.vtf");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/hair_diff.vtf");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/hair_diffuse.vmt");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/hair_n.vtf");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/mileena.vtf");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/mileena_fp.vtf");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/mileena_fp_band.vmt");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/mileena_fp_diff.vmt");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/mileena_fp_n.vtf");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/mileena_mask.vtf");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/mileena_n.vtf");
	AddFileToDownloadsTable("materials/models/gurl/characters/mileena/outfit_warp.vtf");
	
	
				
				
	PrecacheModel(MODEL_HUNTER_HONOKA, true);
	PrecacheModel(MODEL_HUNTER_HUNTRESS, true);
	PrecacheModel(MODEL_HUNTER_FELICIA, true);
	PrecacheModel(MODEL_HUNTER_HARU, true);
	PrecacheModel(MODEL_HUNTER_MILEENA, true);
	PrecacheModel(MODEL_HUNTER_MILEENA_A, true);
}

public void Event_PlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));

    if (GetClientTeam(client) != TEAM_INFECTED)
        return;

    int zombieclass = GetZombieClass(client);

    switch (zombieclass)
    {
        case L4D2_ZOMBIECLASS_HUNTER:
        {
        	switch(GetRandomInt(1, 6))
			{
				case 1:	SetEntityModel(client, MODEL_HUNTER_HONOKA);
				case 2:	SetEntityModel(client, MODEL_HUNTER_HUNTRESS);
				case 3:	SetEntityModel(client, MODEL_HUNTER_FELICIA);
				case 4:	SetEntityModel(client, MODEL_HUNTER_HARU);
				case 5:	SetEntityModel(client, MODEL_HUNTER_MILEENA);
				case 6:	SetEntityModel(client, MODEL_HUNTER_MILEENA_A);
			}
        }
    }
}

int GetZombieClass(int client)
{
    return (GetEntProp(client, Prop_Send, "m_zombieClass"));
}