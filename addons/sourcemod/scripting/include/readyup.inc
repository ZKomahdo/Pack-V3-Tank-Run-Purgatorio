#if defined _readyup_included_
  #endinput
#endif
#define _readyup_included_

public SharedPlugin:__pl_rup = 
{
	name = "readyup",
	file = "readyup.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

forward FirstClientLoaded();
forward AllClientsLoaded();
forward ReadyUpStart();
forward ReadyUpEnd();
forward RoundIsOver();
forward CheckpointDoorStartOpened();
forward CoopMapEnd();
forward CampaignComplete();