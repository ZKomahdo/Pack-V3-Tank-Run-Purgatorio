AchievementCheck(client, achieve)
{
	if (achieve == 0)						// COMMON KILLS , REWARDS PHYSICAL XP
	{
		// If the player has yet to reach the goal...
		if (Ach[client][0] < GetConVarInt(Achievement[0][0]))
		{
			// Add one to the goal counter...
			Ach[client][0]++;

			// If the goal has been reached, the player won't see this screen again, so we
			// need to reward them for completing this quest.
			if (Ach[client][0] == GetConVarInt(Achievement[0][0]))
			{
				SkyPoints[client]++;			// Give a sky point for completing the quest.
				SaveSkyPoints(client);			// Save their new sky point amount.
				// Award the player their experience, and then check their experience goals.
				Ph[client][0] += (GetConVarInt(Achievement[0][1]) * Ph[client][2]);
				experience_increase(client, 0);

				// Now, announce to the WORLD that they've completed this daily quest!
				PrintToChatAll("%s \x03%N \x01has completed \x05%s [Daily Quest, %d Physical XP]", ACHIEVEMENT_INFO, client, AchievementName[0], GetConVarInt(Achievement[0][1]) * Ph[client][2]);
			}
		}
		return;
	}
	else if (achieve == 1)						// SPECIAL INFECTED KILLS , REWARDS PHYSICAL XP
	{
		// If the player has yet to reach the goal...
		if (Ach[client][1] < GetConVarInt(Achievement[1][0]))
		{
			// Add one to the goal counter...
			Ach[client][1]++;

			// If the goal has been reached, the player won't see this screen again, so we
			// need to reward them for completing this quest.
			if (Ach[client][1] == GetConVarInt(Achievement[1][0]))
			{
				SkyPoints[client]++;			// Give a sky point for completing the quest.
				SaveSkyPoints(client);			// Save their new sky point amount.
				// Award the player their experience, and then check their experience goals.
				Ph[client][0] += (GetConVarInt(Achievement[1][1]) * Ph[client][2]);
				experience_increase(client, 0);

				// Now, announce to the WORLD that they've completed this daily quest!
				PrintToChatAll("%s \x03%N \x01has completed \x05%s [Daily Quest, %d Physical XP]", ACHIEVEMENT_INFO, client, AchievementName[1], GetConVarInt(Achievement[1][1]) * Ph[client][2]);
			}
		}
		return;
	}
	else if (achieve == 2)						// FOR CUSTOMIZING YOUR TEXT COLOURS
	{
		if (Ach[client][2] == 0)
		{
			Ach[client][2] = 1;
			SkyPoints[client]++;
			SaveSkyPoints(client);
			Ph[client][0] += GetConVarInt(Achievement[2][1]);
			experience_increase(client, 0);
			PrintToChatAll("%s \x03%N \x01has completed \x05%s [Achievement, %d Physical XP]", ACHIEVEMENT_INFO, client, AchievementName[2], GetConVarInt(Achievement[2][1]));
		}
		return;
	}
	else if (achieve == 3)						// FOR REACHING SPECIAL INFECTED DAMAGE, REWARDS INFECTED XP
	{
		if (Ach[client][3] >= GetConVarInt(Achievement[3][0]))
		{
			Ach[client][3] = GetConVarInt(Achievement[3][0]) * -1;
			SkyPoints[client]++;
			SaveSkyPoints(client);
			In[client][0] += (GetConVarInt(Achievement[3][1]) * In[client][2]);
			experience_increase(client, 0);

			// SHARE IT WITH THE WORLD!!!
			PrintToChatAll("%s \x04%N \x01has completed \x05%s [Daily Quest, %d Infected XP]", ACHIEVEMENT_INFO, client, AchievementName[3], GetConVarInt(Achievement[3][1]) * In[client][2]);
		}
		return;
	}
	else if (achieve == 4)						// FOR EARNING POUNCE DISTANCE POINTS A CERTAIN AMOUNT OF TIMES, REWARDS HUNTER XP
	{
		Ach[client][4]++;
		if (Ach[client][4] == GetConVarInt(Achievement[4][0]))
		{
			SkyPoints[client]++;
			SaveSkyPoints(client);
			Hu[client][0] += (GetConVarInt(Achievement[4][1]) * Hu[client][2]);
			In[client][0] += (GetConVarInt(Achievement[4][1]) * Hu[client][2]);
			experience_increase(client, 0);

			// SHARE IT WITH THE WORLD!!!
			PrintToChatAll("%s \x04%N \x01has completed \x05%s [Daily Quest, %d Hunter XP]", ACHIEVEMENT_INFO, client, AchievementName[4], GetConVarInt(Achievement[4][1]) * Hu[client][2]);
		}
		return;
	}
}

public ResetDailyAchievement(client, day)
{
	AchDate[client] = day;		// Set the day for the current cycle
	Ach[client][0] = 0;			// The amount of common kills
	Ach[client][1] = 0;			// The amount of special infected kills
	Ach[client][3] = 0;			// The amount of special infected damage
	Ach[client][4] = 0;			// The amount of long distance hunter pounces.
}