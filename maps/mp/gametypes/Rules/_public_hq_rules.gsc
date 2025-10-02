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

	if(getCvar("sv_scoreboard") == "")
		setcvar("sv_scoreboard", "tiny");

	setcvar("g_inactivity", "0");

	/* Do NOT Touch These */
	game["mode"] = "pub";
}