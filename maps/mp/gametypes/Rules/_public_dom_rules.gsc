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

	if (level.timelimit == 0 && level.scorelimit == 0)
	{
		setcvar("scr_dom_timelimit", "20");
		level.timelimit = 20;
	}

	//What if they don't have any scoring options set-up?
	if (getcvar("scr_dom_scoreinterval") == "")
		setcvar("scr_dom_scoreinterval", "30");
	
	if (getcvar("scr_dom_tier2interval") == "" &&
		getcvar("scr_dom_tier3interval") == "" &&
		getcvar("scr_dom_tier4interval") == "" &&
		getcvar("scr_dom_tier5interval") == "" &&
		getcvar("scr_dom_tier6interval") == "")
	{
		setcvar("scr_dom_tier6interval", "0");
		setcvar("scr_dom_tier5interval", "0");
		setcvar("scr_dom_tier4interval", "0");
		setcvar("scr_dom_tier3interval", "0");
		setcvar("scr_dom_tier2interval", "0");

		setcvar("scr_dom_tier6score", "0");
		setcvar("scr_dom_tier5score", "0");
		setcvar("scr_dom_tier4score", "0");
		setcvar("scr_dom_tier3score", "0");
		setcvar("scr_dom_tier2score", "0");
		setcvar("scr_dom_tier1score", "1");
	}

	if (getcvar("scr_dom_CapturePoints") == "")
		setcvar("scr_dom_CapturePoints", "0");

	if (getcvar("scr_dom_CaptureAllPoints") == "")
		setcvar("scr_dom_CaptureAllPoints", "15");

	if (getcvar("scr_dom_KillPoints") == "")
		setcvar("scr_dom_KillPoints", "0");

	if (getcvar("scr_dom_restartdelay") == "")
		setcvar("scr_dom_restartdelay", "15"); //Restart Timer between All-Caps

	if (getcvar("g_roundwarmuptime") == "");	// round warmup time
		setcvar("g_roundwarmuptime", "10");	// round warmup time

		/* Common Settings */
	if (getcvar("sv_noDropSniper") == "")
		setcvar("sv_noDropSniper", "0");
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

	setcvar("g_inactivity", "0");

	if(getCvar("sv_scoreboard") == "")
		setcvar("sv_scoreboard", "tiny");

	/* Do NOT Touch These */
	game["mode"] = "pub";
}