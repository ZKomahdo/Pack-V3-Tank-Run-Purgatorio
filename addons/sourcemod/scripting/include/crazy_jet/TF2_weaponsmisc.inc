public Action:OnWeaponCanUse(client, weapon)
{
	new String:datstring[32];
	GetEntityClassname(weapon, datstring, 32);
	if (StrEqual(datstring, "tf_weapon_minigun", true))
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype, &weapon, Float:damageForce[3], Float:damagePosition[3], damagecustom)
{
	if(damagecustom == TF_CUSTOM_BOOTS_STOMP && HaveJet[attacker])
	{
		return Plugin_Handled;
	}

	return Plugin_Continue;
}