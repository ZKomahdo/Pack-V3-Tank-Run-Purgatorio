new Float:SCalc[MAXPLAYERS+1];
new Float:SCalc0[MAXPLAYERS+1];
new Float:SCalc1[MAXPLAYERS+1];
new Float:SCalc2[MAXPLAYERS+1];

public Action:PJetHUDInfo(Handle:timer)
{
	for(new client = 1; client <= MaxClients; client++)
	{
		if(IsValidClient(client) && HaveJet[client] && CjetEnable && HudInfo[client])
		{
			decl String:splash[512];
			decl String:txt[512];

			if(FuelInfo)
			{
				if (100 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (99 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (98 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (97 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (96 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (95 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (94 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (93 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (92 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (91 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (90 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (89 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (88 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (87 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (86 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (85 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (84 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (83 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (82 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (81 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (80 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (79 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (78 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (77 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (76 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (75 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (74 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (73 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (72 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (71 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (70 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (69 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (68 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (67 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (66 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (65 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (64 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (63 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (62 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (61 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (60 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪▪:");
				}
				if (59 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪▪:");
				}
				if (58 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪▪:");
				}
				if (57 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪▪:");
				}
				if (56 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪▪:");
				}
				if (55 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪▪:");
				}
				if (54 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪▪:");
				}
				if (53 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪▪:");
				}
				if (52 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪▪:");
				}
				if (51 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n2X :▪:");
				}
				if (50 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (49 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (48 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (47 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (46 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (45 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (44 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (43 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (42 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (41 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (40 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (39 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (38 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (37 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (36 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (35 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (34 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (33 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (32 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (31 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (30 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (29 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (28 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (27 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (26 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (25 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (24 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (23 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (22 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (21 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (20 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (19 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (18 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (17 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (16 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (15 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (14 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (13 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (12 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (11 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪▪:");
				}
				if (10 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪▪:");
				}
				if (9 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪▪:");
				}
				if (8 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪▪:");
				}
				if (7 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪▪:");
				}
				if (6 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪▪:");
				}
				if (5 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪▪:");
				}
				if (4 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪▪:");
				}
				if (3 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪▪:");
				}
				if (2 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪▪:");
				}
				if (1 == SCalc2[client])
				{
					Format(splash, 512, "[JET FUEL]\n:▪:");
				}

				ShowMessage(client, 0.33, 0.75, 0.3, splash);
			}

			else if(!FuelInfo)
			{
				Format(txt, 512, "FUEL: [%.f | percent]", SCalc2[client]);

				ShowMessage(client, 0.41, 0.75, 0.3, txt);
			}
		}
	}

	return Plugin_Continue;
}