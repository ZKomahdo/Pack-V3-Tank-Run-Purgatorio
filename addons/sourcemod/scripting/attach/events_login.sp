public OnClientPostAdminCheck(client)
{
	if (!IsClientIndexOutOfRange(client) && IsClientInGame(client) && !IsFakeClient(client))
	{
		ResetPlayerStatistics(client);
	}
}

public OnClientDisconnect(client)
{
	if (IsClientConnected(client) && IsClientInGame(client))
	{
		SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
	}
}