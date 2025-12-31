new bool:bClientsLoaded;
new Handle:PurchaseNotice;
new Handle:PointsNotice;
new Handle:InfoNotice;

new Float:playerPoints[MAXPLAYERS + 1][2];
new Float:teamPoints[2];
new Float:ItemCost[MAXPLAYERS + 1];
new String:LastPrimary[MAXPLAYERS + 1][256];
new String:LastSecondary[MAXPLAYERS + 1][256];
new String:ItemName[MAXPLAYERS + 1][256];
new PurchaseItem[MAXPLAYERS + 1];

new Handle:PSLCost;
new Handle:WACost;
new Handle:PPCost;
new Handle:GRCost;
new incapProtection[MAXPLAYERS + 1];

new meds[MAXPLAYERS + 1];
new difference[MAXPLAYERS + 1];
new Handle:Value_MedsAmount;

new bool:adrenalineJunkie[MAXPLAYERS + 1];
new drugUses[MAXPLAYERS + 1];
new bool:permaDeath[MAXPLAYERS + 1];
new bool:pillsJunkie[MAXPLAYERS + 1];

new Handle:SICost;
new Handle:SITCost;
new Handle:SZCost;
new Handle:ITUCost;
new Handle:SZCooldown;
new uncommonRemaining;
new Handle:panicEventSize;
new Handle:uncommonDropSize;
new bool:uncommonPanicEvent;

new Float:commonBodyArmour;
new bool:bInfectedCloak;
new bool:bSpawnAnywhere;
new bool:bWallOfFire;
new bool:bCommonMeleeImmune;
new bool:bCommonFireImmune;
new bool:bSpecialFireImmune;
new bool:bSteelTongue;
new bool:bSmokerWhip;
new bool:bNoSurvivorGlow;
new bool:bWitchStrength;
new bool:bJockeyJump;
new bool:bJockeyBerserk;
new bool:bJockeyBlind;
new bool:bJockeyControl;
new bool:bBlindingBile;
new bool:bUnstableBoomer;
new bool:bSlowingBile;
new spawnTimer;
new bool:bChargerJump;
new chargeVolley;
new Float:spitProtectionTime;
new Float:spitSlowTime;
new Float:spitSlowAmount;
new Float:chargeSpeed;
new Handle:Limit_ChargeSpeed;
new Handle:Value_ChargeSpeedStart;
new Handle:Enhancement_ChargeSpeed;
new Handle:Limit_SpawnTimer;
new Handle:Value_SpawnTimerStart;
new Handle:Enhancement_SpawnTimer;
new Handle:Limit_ChargeVolley;
new Handle:Value_ChargeVolleyStart;
new Handle:Enhancement_ChargeVolley;
new Handle:Limit_SpitProtectionTime;
new Handle:Value_SpitProtectionStart;
new Handle:Enhancement_SpitProtection;
new Handle:Limit_SpitSlowTime;
new Handle:Value_SpitSlowStart;
new Handle:Enhancement_SpitSlowTime;
new Handle:Limit_SpitSlowAmount;
new Handle:Value_SpitSlowAmountStart;
new Handle:Enhancement_SpitSlowAmount;
new Handle:Value_CommonBodyArmour;
new Handle:Enhancement_BodyArmour;
new Handle:Time_DeepFreeze;
new Handle:Strength_DeepFreeze;
new Handle:Delay_DeepFreeze;
new Handle:Enhancement_Helper;
new chargeVictim[MAXPLAYERS + 1];
new Handle:Value_ChargeJumpHeight;
new bool:bJumpCooldown[MAXPLAYERS + 1];
new Handle:Time_ChargeJumpHeight;
new Handle:Value_JockeyJumpHeight;
new Handle:Time_JockeyJumpHeight;

new Handle:Time_SmokerWhipCooldown;
new Handle:Value_SmokerWhipMinimum;
new Handle:Value_SmokerWhipMaximum;
new Handle:Value_SmokerWhipPullMinimum1;
new Handle:Value_SmokerWhipPullMaximum1;
new Handle:Value_SmokerWhipPullMinimum2;
new Handle:Value_SmokerWhipPullMaximum2;
new Handle:Value_SmokerWhipPushMinimum1;
new Handle:Value_SmokerWhipPushMaximum1;
new Handle:Value_SmokerWhipPushMinimum2;
new Handle:Value_SmokerWhipPushMaximum2;


new tankCount;
new tankLimit;
new Float:tankUPS;
new tankHealth;
new witchLimit;
new witchUPS;
new SIHealth;
new deepFreezeAmount;

new Handle:Limit_TankAmount;
new Handle:Value_TankLimitStart;
new Handle:Enhancement_TankLimit;
new Handle:Limit_TankSpeed;
new Handle:Value_TankSpeedStart;
new Handle:Enhancement_TankSpeed;
new Handle:Limit_TankHealth;
new Handle:Value_TankHealthStart;
new Handle:Enhancement_TankHealth;
new Handle:Limit_WitchAmount;
new Handle:Value_WitchStart;
new Handle:Enhancement_WitchAmount;
new Handle:Limit_WitchSpeed;
new Handle:Value_WitchSpeedStart;
new Handle:Enhancement_WitchSpeed;
new Handle:Limit_SIHealth;
new Handle:Value_SIHealthStart;
new Handle:Enhancement_SIHealth;
new Handle:Limit_DeepFreeze;
new Handle:Value_DeepFreezeStart;
new Handle:Enhancement_DeepFreeze;





new tongueRange;
new commonLimit;
new Handle:Limit_CommonLimit;
new Handle:Limit_TongueRange;
new Handle:Limit_CommonBodyArmour;
new Handle:Value_TongueRangeStart;
new Handle:Value_CommonLimitStart;
new Handle:Enhancement_CommonLimit;
new Handle:Enhancement_TongueLimit;

new witchCount;

new Float:summonZombieCooldown;
new uncommonType;


new bool:classHunter[MAXPLAYERS + 1];
new bool:classSmoker[MAXPLAYERS + 1];
new bool:classBoomer[MAXPLAYERS + 1];
new bool:classJockey[MAXPLAYERS + 1];
new bool:classCharger[MAXPLAYERS + 1];
new bool:classSpitter[MAXPLAYERS + 1];
new bool:classTank[MAXPLAYERS + 1];


new bloatAmmo[MAXPLAYERS + 1];
new blindAmmo[MAXPLAYERS + 1];
new slowmoAmmo[MAXPLAYERS + 1];
new beanbagAmmo[MAXPLAYERS + 1];
new spatialAmmo[MAXPLAYERS + 1];

new Handle:Enhancement_BloatAmmo;
new Handle:Enhancement_BlindAmmo;
new Handle:Enhancement_SlowmoAmmo;
new Handle:Enhancement_BeanbagAmmo;
new Handle:Enhancement_SpatialAmmo;
new Handle:Effect_BloatAmmo;
new Handle:Effect_BlindAmmo;
new Handle:Effect_SlowmoAmmo;
new Handle:Effect_BeanbagAmmo[3];
new Handle:Time_BloatAmmo;
new Handle:Time_BlindAmmo;
new Handle:Time_SlowmoAmmo;
new Handle:Time_SpatialAmmo;
new Handle:Immune_BloatAmmo;
new Handle:Immune_BlindAmmo;
new Handle:Immune_SlowmoAmmo;
new Handle:Immune_SpatialAmmo;
new Handle:Immune_BeanbagAmmo;
new bool:bloatImmune[MAXPLAYERS + 1];
new bool:blindImmune[MAXPLAYERS + 1];
new bool:slowmoImmune[MAXPLAYERS + 1];
new bool:beanbagImmune[MAXPLAYERS + 1];
new bool:spatialImmune[MAXPLAYERS + 1];

new Handle:Ability_IncapProtection;
new Handle:Ability_AdrenalineUse;
new Handle:Ability_AdrenalineTime;
new Handle:Ability_HOTAmount;
new Handle:Ability_HOTTime;
new Handle:Ability_PillsUse;
new Handle:Ability_PillsTime;

new respawnType[MAXPLAYERS + 1];

new Handle:Multiplier_CommonStart;
new Handle:Multiplier_SpecialStart;
new Handle:Multiplier_TeamCommonStart;
new Handle:Multiplier_TeamSpecialStart;
new Handle:Multiplier_HeadshotStart;
new Handle:Multiplier_TeamHeadshotStart;
new Handle:Multiplier_Multiplier;
new Handle:Multiplier_Maximum;
new Handle:Multiplier_Start;
new Handle:Multiplier_Bonus;
new Handle:Multiplier_Award;
new Float:survivorMultiplier[MAXPLAYERS + 1];
new survivorCommon[MAXPLAYERS + 1];
new survivorCommonGoal[MAXPLAYERS + 1];
new survivorTeamCommon;
new survivorTeamCommonGoal;
new survivorSpecial[MAXPLAYERS + 1];
new survivorSpecialGoal[MAXPLAYERS + 1];
new survivorTeamSpecial;
new survivorTeamSpecialGoal;
new survivorHeadshot[MAXPLAYERS + 1];
new survivorHeadshotGoal[MAXPLAYERS + 1];
new survivorTeamHeadshot;
new survivorTeamHeadshotGoal;

new bool:roundReset;
new roundEndCount;
new Handle:Timer_RespawnCounter;
new respawnTimer;


new bool:deepFreezeCooldown;

new laggedMovementOffset = -1;

new bool:locationSaved[MAXPLAYERS + 1];
new Float:locationDeath[MAXPLAYERS + 1][3];




new damageDealt[MAXPLAYERS + 1][MAXPLAYERS + 1];
new totalDamage[MAXPLAYERS + 1];
new Handle:Detail_DamageReport;
new Handle:survivorDamageMultiplier;
new Handle:survivorDamageMultiplierTank;
new Handle:infectedDamageMultiplier;
new Handle:infectedDamageMultiplierTank;
new Handle:survivorTeamPointsMultiplier;
new Handle:infectedTeamPointsMultiplier;

new UserMsg:BlindMsgID;

new Handle:hRoundRespawn = INVALID_HANDLE;
new Handle:hGameConf = INVALID_HANDLE;

new Handle:g_hGameConf = INVALID_HANDLE;
new Handle:g_hSetClass = INVALID_HANDLE;
new Handle:g_hCreateAbility	= INVALID_HANDLE;
new g_oAbility = 0;

new Handle:Enhancement_InfectedTouch;
new Handle:Ability_BilePointsTime;
new Handle:Enhancement_BileSlowAmount;
new Float:bilePoints[MAXPLAYERS + 1];
new bool:bileCovered[MAXPLAYERS + 1];
new theBoomer[MAXPLAYERS + 1];

new Float:pounceLocationStart[MAXPLAYERS + 1][3];
new Handle:Distance_HunterPounce;
new bool:ensnared[MAXPLAYERS + 1];
new Float:jumpLocationStart[MAXPLAYERS + 1][3];
new Handle:Distance_JockeyPounce;
new ridePoints[MAXPLAYERS + 1];
new bool:bRiding[MAXPLAYERS + 1];
new jockeyVictim[MAXPLAYERS + 1];
new jockey[MAXPLAYERS + 1];
new bool:bBerserk[MAXPLAYERS + 1];
new Handle:Time_BerserkRequirement;

new bool:bCharging[MAXPLAYERS + 1];
new Float:chargeLocationStart[MAXPLAYERS + 1][3];
new Handle:Distance_ChargeCarry;
new bool:isSmoking[MAXPLAYERS + 1];
new Float:smokeLocationStart[MAXPLAYERS + 1][3];
new Handle:Distance_Smoker;
new smokerVictim[MAXPLAYERS + 1];
new bool:rescueVehicleHasArrived;
new bool:bSlow[MAXPLAYERS + 1];
new Handle:Amount_ChargeVolley;
new bool:tankRestriction;
new Float:tankRestrictionTime;
new Handle:Amount_TankRestriction;
new bool:bJumping[MAXPLAYERS + 1];