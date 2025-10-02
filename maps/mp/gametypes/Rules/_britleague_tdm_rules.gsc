Rules()
{
	/* Match Setup Options */
	setcvar("scr_teamscorepenalty", "1");	// TK's, Suicides, and other non-enemy-caused deaths take points from teams

	setcvar("scr_tdm_half_time" , "15");	// Switch AFTER this amount of time. 0 = Don't switch and scr_tdm_timelimit is used.

	setcvar("scr_tdm_half_score" , "0");	// Switch AFTER this score. NOT IMPLEMENTED

	setcvar("scr_tdm_end_score" , "0");		// End Map AFTER this total score. NOT IMPLEMENTED

	setcvar("scr_tdm_end_half2score" , "0");	// End Map AFTER this 2nd-half score. NOT IMPLEMENTED

	setcvar("scr_tdm_dohalftime", "1"); // Are there 2 halves? 1=yes


	// TDM Settings 
	setcvar("scr_tdm_scorelimit" , "0");
	setcvar("scr_tdm_timelimit" , "0");

	//Auto-Demos & Auto-Screenies
	setcvar("g_autoscreenshot" , "1");

	//Disable Client Console During Matches
	setcvar("sv_consolelock" , "0");

	//SV Pure
	setcvar("sv_pure", "1");
	
	/* PAM cvars */
	// Draws & OT settings
	setcvar("g_ot", "1");	// Are there Overtime rules for this match? 0=No / 1=Yes
	setcvar("scr_tdm_allowmatchtie", "0");	// Do we allow a match to end in a Tie 0=NO (go to sudden death!) 1=YES (For OT or Match Ties) NOT IMPLEMENTED
	setCvar("scr_randomsides", "0");	// Choose Random Sides for us if we need OT

	// Timers
	setcvar("scr_artillery_first_interval" , "45"); // How long after spawn the Artillery Strike becomes available?
	setcvar("scr_artillery_interval" , "120"); // How long between artillery stikes
	setcvar("scr_artillery_interval_range" , "15"); // Random number of seconds added to scr_artillery_interval
	setcvar("g_roundwarmuptime", "5");	// round warmup time

	//Timeouts
	setcvar("g_timeoutsAllowed", "0"); //The number of timeouts allowed per side. 
	setcvar("g_timeoutLength", "0"); //The length of each timeout. 
	setcvar("g_timeoutRecovery", "0"); //The length of the preparation period which occurs after a time-in is called, or after a timeout expires.  This recovery period is used to alert all players that play is about to begin. 
	setcvar("g_timeoutBank", "0"); //The total amount of time a team can spend in timeout.

	// Score Settings
	setcvar("scr_tdm_clearscoreeachhalf", "1");	// Re-set Players Score / Battlerank at halftime? 1=Yes 0=No

	// HUD & Scoreboard Options
	setcvar("sv_scoreboard", "tiny");	// Use tiny Scoreboard (Other Settings: "big" & "small")

	// Weapon Settings
	setcvar("sv_noDropSniper", "1");	// 1=can't drop sniper rifle, 0=Sniper Rifle Drops
	setcvar("sv_alliedSniperLimit", "1");	// allied sniper limit
	setcvar("sv_alliedSMGLimit", "99");	// allied smg limit
	setcvar("sv_alliedMGLimit", "99");	// allied mg limit
	setcvar("sv_alliedDMGLimit", "99"); // allied deployable mg limit
	setcvar("sv_axisSniperLimit", "1");	// axis sniper limit
	setcvar("sv_axisSMGLimit", "99");	// axis smg limit
	setcvar("sv_axisMGLimit", "99");	// axis mg limit
	setcvar("sv_axisDMGLimit", "99"); // axis deployable mg limit

	// Allow Voting 
	setcvar("scr_allow_vote" , "0");
	setcvar("g_allowvote" , "0");
	setcvar("g_allowvotetempbanuser" , "0");
	setcvar("g_allowvotetempbanclient" , "0");
	setcvar("g_allowvotekick" , "0");
	setcvar("g_allowvoteclientkick" , "0");
	setcvar("g_allowvotegametype" , "0");
	setcvar("g_allowvotetypemap" , "0");
	setcvar("g_allowvotemap" , "0");
	setcvar("g_allowvotemaprotate" , "0");
	setcvar("g_allowvotemaprestart" , "0");

	// Team Icons 
	setcvar("scr_drawfriend" , "1");

	// Friendly Fire 
	setcvar("scr_friendlyfire" , "1");

	// Kill Cam & Spectate
	setcvar("scr_killcam" , "0");
	setcvar("scr_freelook" , "0");
	setcvar("scr_spectateenemy" , "0");
	setcvar("g_deadChat" , "0");

	// Auto Team Balance 
	setcvar("scr_teambalance" , "0");

	// Shellshock 
	setcvar("scr_shellshock" , "1");

	// Health Drop 
	setcvar("scr_drophealth" , "0");

	// Force Respawn
	setcvar("scr_forcerespawn", "1");

	// Battleranks 
	setcvar("scr_battlerank" , "0");
	setcvar("scr_forcerank", "0");
	setcvar("scr_rank_ppr" , "10"); //Sets the Points Per Rank

	// Weapon Respawns
	setcvar("g_weaponrespawn", "5");

	// Force Bolt-Action Rifles Only
	setcvar("scr_force_bolt_rifles" , "0");

	// Weapons 
	setcvar("scr_allow_bar" , "1");
	setcvar("scr_allow_bren" , "1");
	setcvar("scr_allow_enfield" , "1");
	setcvar("scr_allow_kar98k" , "1");
	setcvar("scr_allow_kar98ksniper" , "1");
	setcvar("scr_allow_m1carbine" , "1");
	setcvar("scr_allow_m1garand" , "1");
	setcvar("scr_allow_mp40" , "1");
	setcvar("scr_allow_mp44" , "1");
	setcvar("scr_allow_nagant" , "1");
	setcvar("scr_allow_nagantsniper" , "1");
	setcvar("scr_allow_panzerfaust" , "1");
	setcvar("scr_allow_ppsh" , "1");
	setcvar("scr_allow_springfield" , "1");
	setcvar("scr_allow_sten" , "1");
	setcvar("scr_allow_thompson" , "1");
	setcvar("scr_allow_fg42" , "0");
	setcvar("scr_allow_pistols" , "1");
	setcvar("scr_allow_satchel" , "1");
	setcvar("scr_allow_smoke" , "1");
	setcvar("scr_allow_grenades" , "1");
	setcvar("scr_allow_flamethrower" , "1");
	setcvar("scr_allow_artillery" , "1");
	setcvar("scr_allow_bazooka" , "1");
	setcvar("scr_allow_mg34" , "1");
	setcvar("scr_allow_dp28" , "1");
	setcvar("scr_allow_mg30cal" , "1");
	setcvar("scr_allow_gewehr43" , "1");
	setcvar("scr_allow_svt40" , "1");
	setcvar("scr_allow_panzerschreck", "1");

	// Vehicles 
	setcvar("scr_allow_jeeps" , "1");
	setcvar("scr_allow_jeep_gunner" , "1");
	setcvar("scr_allow_tanks" , "1");

	setcvar("scr_allow_flak88" , "1");
	setcvar("scr_allow_su152" , "1");
	setcvar("scr_allow_elefant" , "1");
	setcvar("scr_allow_panzeriv" , "1");
	setcvar("scr_allow_t34" , "1");
	setcvar("scr_allow_sherman" , "1");
	setcvar("scr_allow_horch" , "1");
	setcvar("scr_allow_gaz67b" , "1");
	setcvar("scr_allow_willyjeep" , "1");

	// MG42 (Stationary MG positions)
	setCvar("scr_allow_mg42", "1");

	//Vehicle Limits & Timers
	setcvar("scr_jeep_spawn_limit", "0"); // 0 is disabled
	setcvar("scr_tank_spawn_limit", "0"); // 0 is disabled
	setcvar("scr_vehicle_limit_jeep", "50");
	setcvar("scr_vehicle_limit_medium_tank", "2");
	setcvar("scr_vehicle_limit_heavy_tank", "1");
	setcvar("scr_jeep_respawn_wait" , "5");
	setcvar("scr_tank_respawn_wait" , "300");

	// Vehicle Self Destruct Times
	setCvar("scr_selfDestructTankTime", "180");
	setCvar("scr_selfDestructJeepTime", "90");

	setcvar("g_vehicleBurnTime" , "10"); // Time in seconds a vehicle burns before blowing up

	// Hostname and MOTD 
	setcvar("sv_hostname" , "BritLeague Match in Progress"); 
	setcvar("scr_motd" , "BritLeague Match - www.britleague.com"); 

	// Logo
	game["leaguestring"] = &"BritLeague- Match Mode"; //NOTE!!! NEVER REMOVE THE & SYMBOL OR SERVER WILL CRASH
	
	// HTTP Setup 
	setcvar("sv_wwwDownload" , "0");
	setcvar("sv_wwwBaseURL" , ""); 
	setcvar("sv_wwwDlDisconnected", "0");
	setcvar("sv_allowdownload", "0");

	//Misc
	setcvar("sv_reconnectlimit", "5");
	setcvar("sv_minPing", "0");			
	setcvar("sv_maxPing", "0");
	setcvar("g_inactivity", "0");

	// OT Rules
	if (getcvarint("g_ot_active") > 0)
	{
		setcvar("scr_half_time" , "7");
	}

	/* Do NOT Touch These */
	game["mode"] = "match";
}