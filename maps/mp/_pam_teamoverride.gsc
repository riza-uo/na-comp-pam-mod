main()
{
	if (getcvarint("svr_pamenable") == 1 && getcvar("scr_force_allies") != "")
	{
		allies = getcvar("scr_force_allies");
		validteam = maps\mp\gametypes\_pam_utilities::CheckValidTeam(allies);
		if (validteam)
			maps\mp\gametypes\_pam_utilities::Team_Override(allies);
	}
}