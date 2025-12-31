new Handle:Achievement[5][3];
new Handle:WikiForceLevel;
new Handle:OneDayBonus;
new Handle:SkyPointsPerDay;
new Handle:SkyPointsPerHour;

// What version of costs is on? 0 - no increment. 1 - increment . 2 - based on level
new Handle:CostEvaluation;

// Costs for level evaluation based costs
new Handle:Tier2CostByLevel;
new Handle:HealthItemCostByLevel;
new Handle:PersonalAbilitiesCostByLevel;
new Handle:WeaponUpgradeCostByLevel;
new Handle:SpecialCostByLevel;
new Handle:TankCostByLevel;
new Handle:UncommonCostByLevel;
new Handle:TeamUpgradesCostByLevel;
new Handle:PersonalUpgradesCostByLevel;

new Handle:BuyPistolXP;
new Handle:BuyPistolXPCost;
new Handle:BuyMeleeXP;
new Handle:BuyMeleeXPCost;
new Handle:BuyUziXP;
new Handle:BuyUziXPCost;
new Handle:BuyShotgunXP;
new Handle:BuyShotgunXPCost;
new Handle:BuySniperXP;
new Handle:BuySniperXPCost;
new Handle:BuyRifleXP;
new Handle:BuyRifleXPCost;
new Handle:BuyGrenadeXP;
new Handle:BuyGrenadeXPCost;
new Handle:BuyItemXP;
new Handle:BuyItemXPCost;
new Handle:BuyPhysicalXP;
new Handle:BuyPhysicalXPCost;
new Handle:BuyHunterXP;
new Handle:BuyHunterXPCost;
new Handle:BuySmokerXP;
new Handle:BuySmokerXPCost;
new Handle:BuyBoomerXP;
new Handle:BuyBoomerXPCost;
new Handle:BuyJockeyXP;
new Handle:BuyJockeyXPCost;
new Handle:BuyChargerXP;
new Handle:BuyChargerXPCost;
new Handle:BuySpitterXP;
new Handle:BuySpitterXPCost;
new Handle:BuyTankXP;
new Handle:BuyTankXPCost;
new Handle:BuyInfectedXP;
new Handle:BuyInfectedXPCost;
new Handle:BuyPresetCost;
new Handle:BuyXPMultiplier;
new Handle:BuyXPMultiplierAmount;
new Handle:BuyXPMultiplierCost;
new Handle:BuyMountedGunsCost;
new NextXPCost[MAXPLAYERS + 1];
new Handle:g_NextXPCostMin;

// Respawn Limiter
new Handle:RespawnLimit;
new RespawnCount[MAXPLAYERS + 1];

new Handle:SurvivorPointLimit;
new Handle:InfectedPointLimit;
new Handle:AILevelingEnabled;
new Handle:SurvivorIncrement;
new Handle:InfectedIncrement;

new Handle:DirectorEnabled;
new Float:DirectorPoints;
new Handle:DirectorPointsOnHurt;
new bool:bWOFCooldown;
new Handle:g_WOFCooldownBots;

new Handle:g_IcedByTankSpeed;
new Handle:g_IcedByTankTime;
new bool:bIcedByTank[MAXPLAYERS + 1];

new Handle:GoalIncrementOne;
new Handle:g_WeaponTrailLevel;

new g_iSprite = 0;
new Handle:g_LaserWidth;
new Handle:g_LaserTime;
new weaponTrails[MAXPLAYERS + 1];
new ColourTrail[MAXPLAYERS + 1][4];
new PiTrail[MAXPLAYERS + 1][4];
new UzTrail[MAXPLAYERS + 1][4];
new ShTrail[MAXPLAYERS + 1][4];
new RiTrail[MAXPLAYERS + 1][4];
new SnTrail[MAXPLAYERS + 1][4];

new Handle:g_UnlimitedAmmo;
new Handle:MedsEnabled;
new Handle:g_LevelBroadcast;
new Handle:g_LevelBroadcastRequirement;