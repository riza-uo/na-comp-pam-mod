/* This PAM public code will allow you to set up your match style in a config file
rather than having one hard-coded set of public settings.  In case the settings 
are unacceptable, the server will still run with a scorelimit of 7 (assigned below).  
Please note that it is advised to change the pam_mode to "pub" and do a 
map_restart INSIDE the config file as well.  Thus, to change from a league mode
to pub mode you would ONLY exec the config file.

/rcon exec public.cfg (for example)

You could even have multiple config files such as a rifles only config, a config 
that uses halftime, and a normal everyday config.  A sample config file is
included. Edit and rename the config files at will. 

worm                                                                          */

Rules()
{
	// Logo
	game["leaguestring"] = &"Pub Mode";

	/* Check to see if you have a 2nd half match limit but no halftime */
	level.matchround = getcvarint("scr_ctf_end_round");
	level.matchscore = getcvarint("scr_ctf_end_score");
	level.matchscore2 = getcvarint("scr_ctf_end_half2score");
	level.halfround = getcvarint("scr_ctf_half_round");
	level.halfscore = getcvarint("scr_ctf_half_score");
	if (level.matchscore2 != 0 && level.halfround == 0 && level.halfscore == 0)
	{
		level.matchscore2 = 0;
		setcvar("scr_ctf_end_half2score", "0");
	}

	/* What if they don't have their server setup at all? */
	if(level.matchround == 0 && level.matchscore == 0 && level.matchscore2 == 0)
	{
		if(level.roundlimit == 0 && level.scorelimit == 0 && level.timelimit == 0)
		{
			level.roundlimit = 1; // SET A DEFAULT ROUNDLIMIT HERE!
			setcvar("scr_ctf_ctf_roundlimit", level.roundlimit);
		}

		if (level.roundlimit != 0)
			setcvar("scr_ctf_end_round", level.roundlimit);

		if (level.scorelimit != 0)
			setcvar("scr_ctf_end_score", level.scorelimit);
	}

		/* Common Settings */
	if (getcvar("sv_noDropSniper") == "")
		setcvar("sv_noDropSniper", "0");
	if (getcvar("sv_noDropDMG") == "")
		setcvar("sv_noDropDMG", "0");
	if (getcvar("sv_alliedSniperLimit") == "")
		setcvar("sv_alliedSniperLimit", "99");
	if (getcvar("sv_alliedSMGLimit") == "")
		setcvar("sv_alliedSMGLimit", "99");
	if (getcvar("sv_alliedMGLimit") == "")
		setcvar("sv_alliedMGLimit", "99");
	if (getcvar("sv_alliedDMGLimit") == "")
		setcvar("sv_alliedDMGLimit", "99");

	if (getcvar("sv_axisSniperLimit") == "")
		setcvar("sv_axisSniperLimit", "99");
	if (getcvar("sv_axisSMGLimit") == "")
		setcvar("sv_axisSMGLimit", "99");
	if (getcvar("sv_axisMGLimit") == "")
		setcvar("sv_axisMGLimit", "99");
	if (getcvar("sv_axisDMGLimit") == "")
		setcvar("sv_axisDMGLimit", "99");

	if (getcvar("scr_artillery_first") == "")
		setcvar("scr_artillery_first", "45");
	if (getcvar("scr_artillery_interval") == "")
		setcvar("scr_artillery_interval", "120");


	if(getCvar("sv_playersleft") == "")
		setCvar("sv_playersleft", "1");
	if(getCvar("sv_scoreboard") == "")
		setcvar("sv_scoreboard", "small");
	if(getCvar("scr_ctf_count_draws") == "")
		setcvar("scr_ctf_count_draws", "0");

	setcvar("g_inactivity", "0");

	/* Do NOT Touch These */
	game["mode"] = "pub";
}

OTRules()
{
	//Nothing here, No OT in Public
}

SuddenDeathRules()
{
	//Nothing here, No Sudden Death in Public
}
