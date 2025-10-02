Rules()
{
	/* Match Setup Options */
	setcvar("scr_ctf_scoringmethod", "captures");	// If set to 'round' it scores like stock CTF, 1 point per round win.

	setcvar("scr_ctf_half_round" , "1");	// Switch AFTER this round.

	setcvar("scr_ctf_half_score" , "0");	// Switch AFTER this score.

	setcvar("scr_ctf_end_round" , "2");	// End Map AFTER this round.

	setcvar("scr_ctf_end_score" , "0");		// End Map AFTER this total score.

	setcvar("scr_ctf_end_half2score" , "0");	// End Map AFTER this 2nd-half score.

	// *****************************************************
	// *********** Stock Match Config Cvars ****************
	// *****************************************************
	
	// CTF Settings 
	setcvar("scr_ctf_scorelimit" , "0");
	setcvar("scr_ctf_timelimit" , "0");
	setcvar("scr_ctf_roundlimit" , "0");
	setcvar("scr_ctf_roundlength" , "20");
	setcvar("scr_ctf_startrounddelay" , "15");
	setcvar("scr_ctf_endrounddelay" , "10");

	setcvar("scr_ctf_clearscoreeachround" , "0");

	// Respawn Timer
	setcvar("scr_death_wait_time", "10");

	// Compass Settings
	setcvar("scr_ctf_showoncompass" , "0");
	setcvar("scr_ctf_positiontime", "5");

	// Shellshock 
	setcvar("scr_shellshock" , "1");

	// Health Drop 
	setcvar("scr_drophealth" , "1");

	// Battleranks 
	setcvar("scr_battlerank" , "1");
	setcvar("scr_forcerank", "0");
	setcvar("scr_rank_ppr" , "10"); //Sets the Points Per Rank

	// Hostname and MOTD 
	setcvar("sv_hostname" , "TWL Match in Progress"); 
	setcvar("scr_motd" , "PAMUO v3.1 TWL-Ladder Match Mode v1.2"); 

	//Logo
	game["leaguestring"] = &"TWL-Ladder Match Mode v1.2";  //NOTE!!! NEVER REMOVE THE & SYMBOL OR SERVER WILL CRASH
	
	// *****************************************************
	// ********** PAM UO Match Config Cvars ****************
	// *****************************************************
	// OT settings
	setcvar("g_ot", "1");	// Are there Overtime rules for this match? 0=No / 1=Yes
	setcvar("scr_usetouches", "0");	//If the map score is tied, uses the number of times a team was able to touch the opponents flag to determine a winner
	setcvar("scr_ctf_allowmatchtie", "1");	// Do we allow a match to end in a Tie 0=NO (go to sudden death!) 1=YES (For OT or Match Ties)
	setCvar("scr_randomsides", "0");	// Choose Random Sides for us if we need OT - Not implemented in SD yet

	// OT Settings
	if (getcvarint("g_ot_active") == 1)
	{
		setcvar("scr_ctf_half_round" , "0");	// Switch AFTER this round.

		setcvar("scr_ctf_end_round" , "0");		// End Map AFTER this round.

		setcvar("scr_ctf_end_score" , "1");

		setcvar("scr_ctf_roundlength" , "0"); // Length of each round

		setcvar("g_ot", "0");	// Are there Overtime rules for this match? 0=No / 1=Yes
	}

	// Death Penalty
	setcvar("scr_ctf_respawnpenalty", "10"); // Respawn Timer Penalty for a player that was TKed or Suicided. Does not work in 'pub' mode

	// Round Draw Setting
	setcvar("scr_ctf_count_draws", "1");	// Count rounds that end in a draw? 1=Yes 0=No
	setcvar("scr_ctf_allowrounddraw", "1");	// Do we allow Round Draws 0=No (go to Sudden Death) 1=Yes  Only works when scroring method is 'round'.

	// Timers
	setcvar("g_roundwarmuptime", "5");	// round warmup time

	// Score Settings
	setcvar("scr_ctf_clearscoreeachhalf", "1");	// Re-set Players Score / Battlerank at halftime? 1=Yes 0=No

	// HUD & Scoreboard Options
	setcvar("sv_scoreboard", "tiny");	// Use tiny Scoreboard (Other Settings: "big" & "small")
	setcvar("scr_ctf_showscores" , "0"); //Shows a continuous tiny scoreboard at the bottom of the screen

	// Flag Return Options
	setcvar("scr_ctf_flagresettime", "20");	//How long (seconds) the flag sits after being dropped before it returns automatically. 20 is Stock. -1 is Never
	setcvar("scr_ctf_allowflagreturn", "1");	// Determines whether a team can return a flag to its base by touching it. When this is on AND scr_ctf_flagresettime is set to -1 (NEVER), your flag does NOT need to be at your base to capture the enemies flag.

	// Warm-up Mines
	setcvar("sv_warmupmines", "1"); //Leave this on for now. Mines need to be re-worked.


	// *****************************************************
	// ************ Vehicle Settings ***********************
	// *****************************************************
	
	// Vehicle Explosion Timer
	setcvar("g_vehicleBurnTime" , "10"); // Time in seconds a vehicle burns before blowing up


	// Jeeps
	setcvar("scr_allow_jeeps" , "1");
	setcvar("scr_allow_jeep_gunner" , "1");

	setcvar("scr_jeep_spawn_limit", "0"); // 0 is disabled. Each vehicle will only spawn this number of times
	setcvar("scr_vehicle_limit_jeep", "0"); // Limits the number of jeeps available on the map at any given time (0 = disabled)

	setcvar("scr_allow_horch" , "1");
	setcvar("scr_allow_gaz67b" , "1"); 
	setcvar("scr_allow_willyjeep" , "1");

	setcvar("scr_jeep_respawn_wait" , "5");
	setCvar("scr_selfDestructJeepTime", "90");


	//Tanks
	setcvar("scr_allow_tanks" , "1");

	setcvar("scr_tank_spawn_limit", "0"); // 0 is disabled. Each vehicle will only spawn this number of times
	setcvar("scr_vehicle_limit_medium_tank", "50"); // Limits the number of medium tanks available on the map at any given time (0 = disabled)
	setcvar("scr_vehicle_limit_heavy_tank", "50"); // Limits the number of heavy tanks available on the map at any given time (0 = disabled)

	setcvar("scr_allow_su152" , "1");
	setcvar("scr_allow_elefant" , "1");
	setcvar("scr_allow_panzeriv" , "1");
	setcvar("scr_allow_t34" , "1");
	setcvar("scr_allow_sherman" , "1");

	setcvar("scr_tank_respawn_wait" , "120");
	setCvar("scr_selfDestructTankTime", "180");


	// *****************************************************
	// ************ Weapon Settings ************************
	// *****************************************************

	// Map-Placed Weapon Respawns
	setcvar("g_weaponrespawn", "5"); // Weapons on the ground in maps will respawn after this many seconds

	// Force Bolt-Action Rifles Only
	setcvar("scr_force_bolt_rifles" , "0");

	// Rifles 
	setcvar("scr_allow_enfield" , "1");
	setcvar("scr_allow_kar98k" , "1");
	setcvar("scr_allow_m1garand" , "1");
	setcvar("scr_allow_nagant" , "1");
	setcvar("scr_allow_gewehr43" , "1");


	//Snipers
	setcvar("sv_noDropSniper", "0");	// 1=can't drop sniper rifle, 0=Sniper Rifle Drops
	setcvar("sv_alliedSniperLimit", "99");	// allied sniper limit
	setcvar("sv_axisSniperLimit", "99");	// axis sniper limit

	setcvar("scr_allow_kar98ksniper" , "1");
	setcvar("scr_allow_nagantsniper" , "1");
	setcvar("scr_allow_springfield" , "1");
	setcvar("scr_allow_svt40" , "1");
	setcvar("scr_allow_fg42" , "0");

	// MGs
	setcvar("sv_alliedMGLimit", "99");	// allied mg limit
	setcvar("sv_axisMGLimit", "99");	// axis mg limit

	setcvar("scr_allow_bar" , "1");
	setcvar("scr_allow_bren" , "1");
	setcvar("scr_allow_mp44" , "1");
	setcvar("scr_allow_ppsh" , "1");

	//SMGs
	setcvar("sv_alliedSMGLimit", "99");	// allied smg limit
	setcvar("sv_axisSMGLimit", "99");	// axis smg limit

	setcvar("scr_allow_sten" , "1");
	setcvar("scr_allow_mp40" , "1");
	setcvar("scr_allow_thompson" , "1");
	setcvar("scr_allow_m1carbine" , "1");

	// Rockets
	setcvar("scr_allow_panzerfaust" , "1");
	setcvar("scr_allow_panzerschreck", "1");
	setcvar("scr_allow_bazooka" , "1");

	// Deployable Machine Guns
	setcvar("sv_noDropDMG", "0");	// 1=can't drop Deployable MG, 0=DMG Drops
	setcvar("sv_alliedDMGLimit", "99"); // allied deployable mg limit
	setcvar("sv_axisDMGLimit", "99"); // axis deployable mg limit

	setcvar("scr_allow_mg34" , "1");
	setcvar("scr_allow_dp28" , "1");
	setcvar("scr_allow_mg30cal" , "1");

	// Pistols
	setcvar("scr_allow_pistols" , "1");

	// Nades and Satchels
	setcvar("scr_allow_smoke" , "1");
	setcvar("scr_allow_grenades" , "1");
	setcvar("scr_allow_satchel" , "1");

	// Artillery Settings
	setcvar("scr_allow_artillery" , "1");
	setcvar("scr_artillery_first_interval" , "45"); // How long after spawn the Artillery Strike becomes available?
	setcvar("scr_artillery_interval" , "120"); // How long between artillery stikes
	setcvar("scr_artillery_interval_range" , "15"); // Random number of seconds added to scr_artillery_interval

	// Flamethrower
	setcvar("scr_allow_flamethrower" , "1");

	// Flak Canons
	setcvar("scr_allow_flak88" , "1");

	// MG42 (Stationary MG positions)
	setCvar("scr_allow_mg42", "1");


	// *****************************************************
	// ****************** Timeouts *************************
	// *****************************************************
	setcvar("g_timeoutsAllowed", "0"); //The number of timeouts allowed per side. 
	setcvar("g_timeoutLength", "0"); //The length of each timeout. 
	setcvar("g_timeoutRecovery", "0"); //The length of the preparation period which occurs after a time-in is called, or after a timeout expires.  This recovery period is used to alert all players that play is about to begin. 
	setcvar("g_timeoutBank", "0"); //The total amount of time a team can spend in timeout.


	// *****************************************************
	// *********** PAM UO Auto Demo/Screenshots ************
	// *****************************************************
	setcvar("g_autoscreenshot" , "1");

	// *****************************************************
	// *********** PAM UO Auto Console Lock ****************
	// *****************************************************
	setcvar("sv_consolelock" , "0");



	// ************************************************
	// *********** CVARs NOT Liekly to change *********
	// ************************************************

	// HTTP Setup 
	setcvar("sv_wwwDownload" , "0");
	setcvar("sv_wwwBaseURL" , ""); 
	setcvar("sv_wwwDlDisconnected", "0");
	setcvar("sv_allowdownload", "0");

	//SV Pure
	setcvar("sv_pure", "1");

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

	//Misc
	setcvar("sv_reconnectlimit", "5");
	setcvar("sv_minPing", "0");			
	setcvar("sv_maxPing", "0");
	setcvar("g_inactivity", "0");

	/* Do NOT Touch These */
	game["mode"] = "match";
}

SuddenDeathRules()
{
	level.flagtimeout = 20;	//How long the flag sits after being dropped before it returns automatically. 20 is Stock. -1 is Never.
	level.flagtimeout = 1;	// Determines whether a team can return a flag to its base by touching it. When this is on AND scr_ctf_flagresettime is set to -1 (NEVER), your flag does NOT need to be at your base to capture the enemies flag.
}