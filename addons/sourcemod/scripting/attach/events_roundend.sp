public Events_RoundEnd()
{
	HookEvent("round_end", Event_RoundEnd);
}

public Action:Event_RoundEnd(Handle:event, String:event_name[], bool:dontBroadcast)
{
	roundReset										= true;
	ReadyUpEnd_ResetStatistics();
}