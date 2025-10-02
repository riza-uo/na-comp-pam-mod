PamMain()
{
	level.callbackStartGameType = ::Callback_StartGameType; // Set the level to refer to this script when called upon.
	level.callbackPlayerConnect = ::Callback_PlayerConnect; // Set the level to refer to this script when called upon.
	level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect; // Set the level to refer to this script when called upon.
	level.callbackPlayerDamage = ::Callback_PlayerDamage; // Set the level to refer to this script when called upon.
	level.callbackPlayerKilled = ::Callback_PlayerKilled; // Set the level to refer to this script when called upon.

	maps\mp\gametypes\_callbacksetup::SetupCallbacks(); // Run this script upon load.

	allowed[0] = "ctf"; 
	maps\mp\gametypes\_gameobjects::main(allowed); // Take the "allowed" array and apply it to this script. which just deletes all of the objects that do not have script_objectname set to any of the allowed arrays. Ex. allowed[0].

	level.mapname = getcvar("mapname");
	maps\mp\gametypes\_pam_utilities::NonstockPK3Check();

	if(getCvar("scr_ctf_timelimit") == "")		// Time limit per map
		setCvar("scr_ctf_timelimit", "0");
	else if(getCvarFloat("scr_ctf_timelimit") > 1440)
		setCvar("scr_ctf_timelimit", "1440");
	level.timelimit = getCvarFloat("scr_ctf_timelimit");
	setCvar("ui_ctf_timelimit", level.timelimit);
	makeCvarServerInfo("ui_ctf_timelimit", "0");

	if(getCvar("scr_ctf_roundlength") == "")		// Time length of each round
		setCvar("scr_ctf_roundlength", "20");
	else if(getCvarFloat("scr_ctf_roundlength") > 60)
		setCvar("scr_ctf_roundlength", "60");
	level.roundlength = getCvarFloat("scr_ctf_roundlength");
	setCvar("ui_ctf_roundlength", getCvar("scr_ctf_roundlength"));
	makeCvarServerInfo("ui_ctf_roundlength", "0");

	if(getCvar("scr_ctf_scorelimit") == "")		// Score limit per map
		setCvar("scr_ctf_scorelimit", "5");
	level.scorelimit = getCvarint("scr_ctf_scorelimit");
	setCvar("ui_ctf_scorelimit", getCvar("scr_ctf_scorelimit"));
	makeCvarServerInfo("ui_ctf_scorelimit", "0");
		
	if(getCvar("scr_friendlyfire") == "")		// Friendly fire
		setCvar("scr_friendlyfire", "1");	//default is ON

	if(getCvar("scr_showicons") == "")		// flag icons on or off
		setCvar("scr_showicons", "1");

	if(getCvar("scr_ctf_startrounddelay") == "")	// Time to wait at the begining of the round
		setCvar("scr_ctf_startrounddelay", "15");
	if(getCvar("scr_ctf_endrounddelay") == "")		// Time to wait at the end of the round
		setCvar("scr_ctf_endrounddelay", "10");

	if(getCvar("scr_ctf_clearscoreeachround") == "")	// clears everyones score between each round if true
		setCvar("scr_ctf_clearscoreeachround", "1");
	setCvar("ui_ctf_clearscoreeachround", getCvar("scr_ctf_clearscoreeachround"));
	makeCvarServerInfo("ui_ctf_clearscoreeachround", "0");

	if(getCvar("scr_ctf_clearscoreeachhalf") == "")	// clears everyones score each HALF if true
		setCvar("scr_ctf_clearscoreeachhalf", "1");

	if(getCvar("scr_ctf_scoringmethod") == "")	// Determines the scoring method
		setCvar("scr_ctf_scoringmethod", "round");

	if(getCvar("scr_ctf_allowrounddraw") == "")	// Do we allow a Draw or go to Sudden Death? Only works when scroring method is 'round'.
		setCvar("scr_ctf_allowrounddraw", "0");

	if(getCvar("scr_ctf_allowmatchtie") == "")	// Do we allow a Match to end in a Tie?
		setCvar("scr_ctf_allowmatchtie", "1");

	if(getCvar("scr_randomsides") == "")	// Will Choose a Random Side for Teams before OT begins.
		setCvar("scr_randomsides", "0");

	if(getCvar("scr_ctf_flagresettime") == "")	// Do we allow a Draw or go to Sudden Death? Only works when scroring method is 'round'.
		setCvar("scr_ctf_flagresettime", "20");

	if(getCvar("scr_ctf_allowflagreturn") == "")	// Do we allow a Draw or go to Sudden Death? Only works when scroring method is 'round'.
		setCvar("scr_ctf_allowflagreturn", "1");

	if(getCvar("scr_drawfriend") == "")		// Draws a team icon over teammates, default is on.
		setCvar("scr_drawfriend", "1");
	level.drawfriend = getCvarint("scr_drawfriend");

	if(getCvar("scr_battlerank") == "")		// Draws the battle rank.  Overrides drawfriend.
		setCvar("scr_battlerank", "1");	//default is ON
	level.battlerank = getCvarint("scr_battlerank");
	setCvar("ui_battlerank", level.battlerank);
	makeCvarServerInfo("ui_battlerank", "0");

	if(getCvar("scr_shellshock") == "")		// controls whether or not players get shellshocked from grenades or rockets
		setCvar("scr_shellshock", "1");
	setCvar("ui_shellshock", getCvar("scr_shellshock"));
	makeCvarServerInfo("ui_shellshock", "0");
			
	if(getCvar("g_allowvote") == "")		// Ability to cast votes.
		setCvar("g_allowvote", "1");	
	level.allowvote = getCvarint("g_allowvote");
	setCvar("scr_allow_vote", level.allowvote);

	if(getcvar("g_ot_active") == "")
		setcvar("g_ot_active", "0");

	if ( getcvar( "g_allowtie" ) == "" )
		setcvar("g_allowtie", "1");
	
	if(getCvar("sv_messagecenter") == "")
		setCvar("sv_messagecenter", "0");

	if(getCvar("pam_mode") == "")
		setCvar("pam_mode", "pub");

	if(getCvar("sv_consolelock") == "")	// Locks the console in PAM
		setCvar("sv_consolelock", "0");

	if(!isdefined(game["runonce"]))
	{
		//Turn on all client consoles
		setCvar("sv_disableClientConsole", "0");

		/* Get Game Settings */
		level.scorelimit = getCvarInt("scr_ctf_scorelimit");
		level.roundlimit = getCvarInt("scr_ctf_roundlimit");

		level.ruleset = getCvar("pam_mode");
		switch(level.ruleset)
		{
		case "twl_ladder":
			thread maps\mp\gametypes\rules\_twl_ladder_ctf_rules::Rules();
			break;
		case "twl_league":
			thread maps\mp\gametypes\rules\_twl_league_ctf_rules::Rules();
			break;
		case "ogl":
			thread maps\mp\gametypes\rules\_ogl_ctf_rules::Rules();
			break;
		case "cb":
			thread maps\mp\gametypes\rules\_cb_ctf_rules::Rules();
			break;
		case "cal":
			thread maps\mp\gametypes\rules\_cal_ctf_rules::Rules();
			break;
		case "twl_rifles":
			thread maps\mp\gametypes\rules\_twl_rifles_ctf_rules::Rules();
			break;
		case "twl_classic_ladder":
			thread maps\mp\gametypes\rules\_twl_classic_ladder_ctf_rules::Rules();
			break;
		case "twl_classic_league":
			thread maps\mp\gametypes\rules\_twl_classic_league_ctf_rules::Rules();
			break;
		case "bl":
			thread maps\mp\gametypes\rules\_britleague_ctf_rules::Rules();
			break;
		case "ccodl":
			thread maps\mp\gametypes\rules\_ccodl_ctf_rules::Rules();
			break;
		case "ga":
			thread maps\mp\gametypes\rules\_ga_ctf_rules::Rules();
			break;
		case "lan":
			thread maps\mp\gametypes\rules\_lan_ctf_rules::Rules();
			break;

		default:
			thread maps\mp\gametypes\rules\_public_ctf_rules::Rules();
			setCvar("pam_mode", "pub");
			break;
		}

		if(!isDefined(game["mode"]))
			game["mode"] = "match";

		game["switchprevent"] = 0; //Can't switch teams after this bit gets set and you are already on a team

		game["runonce"] = 1;
	}

	//Turn off client console for PUB servers if set
	if (game["mode"] != "match" && getcvar("sv_consolelock") )
		setCvar("sv_disableClientConsole", "1");

	if(getcvar("g_matchwarmuptime") == "")	// match warmup time
		setcvar("g_matchwarmuptime", "10");
	if(getcvar("g_roundwarmuptime") == "")	// round warmup time
		setcvar("g_roundwarmuptime", "5");
	if(getcvar("g_matchintermission") == "")		// match intermission
		setcvar("g_matchintermission", "10");

	if(getcvar("sv_warmupmines") == "")			// warmup mines off/on
		setcvar("sv_warmupmines", "1");	

	//Turn off OT for pub mode
	if(getcvar("g_ot") == "" || game["mode"] == "pub")
		setcvar("g_ot", "0");

	/* Set up Level variables */
	// level settings
	level.timelimit = getCvarFloat("scr_ctf_timelimit");
	level.roundlength = getCvarFloat("scr_ctf_roundlength");
	level.graceperiod = getCvarFloat("scr_ctf_graceperiod");
	level.killcam = getCvarInt("scr_killcam");
	level.teambalance = getCvarInt("scr_teambalance");
	level.allowfreelook = getCvarInt("scr_freelook");
	level.allowenemyspectate = getCvarInt("scr_spectateenemy");
	level.drawfriend = getCvarInt("scr_drawfriend");
	level.ffire = getCvarInt("scr_friendlyfire");
	level.pure = getCvarInt("sv_pure");
	level.vote = getCvarInt("g_allowVote");
	level.sshock = getcvarint("scr_shellshock");
	level.drophealth = getcvarint("scr_drophealth");

	// Mod Specific Settings
	level.league = getcvar("pam_mode");
	level.pamenable = getcvarint("svr_pamenable");
	level.halfround = getcvarint("scr_ctf_half_round");
	level.endround = getcvarint("scr_ctf_end_round");
	level.halfscore = getcvarint("scr_ctf_half_score");
	level.matchround = getcvarint("scr_ctf_end_round");
	level.matchscore1 = getcvarint("scr_ctf_end_score");
	level.matchscore2 = getcvarint("scr_ctf_end_half2score");
	level.countdraws = getcvarint("scr_ctf_count_draws");
	level.allowrounddraw = getcvarint("scr_ctf_allowrounddraw");
	level.scoringmethod = getcvarint("scr_ctf_scoringmethod");
	level.clearscoreeachhalf = getcvarint("scr_ctf_clearscoreeachhalf");
	level.flagtimeout = getcvarFloat("scr_ctf_flagresettime");
	level.allowflagreturn = getcvarint("scr_ctf_allowflagreturn");
	level.overtime = 0;	//Makes sure OT settings get loaded after defaults loaded
	level.allowmatchtie = getcvarint("scr_ctf_allowmatchtie");
	level.randomsides = getcvarint("scr_randomsides");
	level.ot_count = getcvarint("g_ot_count");
	level.allowflagactions = false;
	level.rdyup = 0;
	level.warmup = 0;
	level.hithalftime = 0;
	level.checksettings = 0;
	level.allowautobalance = true;
	level.killvehicles = false;

	//Ready-Up
	level.R_U_Name = [];
	level.R_U_State = [];
	level.playersready = false;

	// weapon settings
	level.faust = getcvarint("scr_allow_panzerfaust");
	level.fg42gun = getcvarint("scr_allow_fg42");
	level.mg30gun = getcvarint("scr_allow_mg30cal");
	level.dp28gun = getcvarint("scr_allow_dp28");
	level.bazookagun = getcvarint("scr_allow_bazooka"); 
	level.flamegun = getcvarint("scr_allow_flamethrower"); // TO DO
	level.nodropsniper = getcvar("sv_noDropSniper");
	level.axissnipelimit = getcvarint("sv_axisSniperLimit");
	level.allysnipelimit = getcvarint("sv_alliedSniperLimit");

	level.ruleset = getCvar("pam_mode");

	if(!isdefined(game["halftimeflag"]))
	{
		game["dolive"] = "0";
		game["halftimeflag"] = "0";
		game["round1alliesscore"] = 0;
		game["round1axisscore"] = 0; 
		game["round2alliesscore"] = 0;
		game["round2axisscore"] = 0;
		game["firsthalfready"] = 0;
		game["readyup"] = 0;
		game["axismatchscore"] = 0;
		game["alliesmatchscore"] = 0;
		game["startingsecondhalf"] = 0;
		game["alliestouches"] = 0;
		game["axistouches"] = 0;
	}

	// WEAPON EXPLOIT FIX
	if(!isDefined(game["dropsecondweap"]))
		game["dropsecondweap"] = false;
	
	//Message Center
	if(game["mode"] != "match" && getCvar("sv_messagecenter") != "0")
		thread maps\mp\gametypes\_message_center::messages();

	//PAM UO Admin Tools
	thread maps\mp\gametypes\_pam_admin::main();

	if(!isDefined(game["state"]))			// Setting the game state.
		game["state"] = "playing";
	if(!isDefined(game["roundsplayed"]))
		game["roundsplayed"] = 0;
	if(!isDefined(game["matchstarted"]))
		game["matchstarted"] = false;
	if(!isDefined(game["matchstarting"]))
		game["matchstarting"] = false;
	if(!isDefined(game["timepassed"]))
		game["timepassed"] = 0;
		
	if(!isDefined(game["alliedscore"]))		// Setup the score for the allies to be 0.
		game["alliedscore"] = 0;
	setTeamScore("allies", game["alliedscore"]);

	if(!isDefined(game["axisscore"]))		// Setup the score for the axis to be 0.
		game["axisscore"] = 0;
	setTeamScore("axis", game["axisscore"]);

	if(getCvar("scr_drophealth") == "")		// Free look spectator
		setCvar("scr_drophealth", "1");

	// turn off ceasefire
	level.ceasefire = 0;
	setCvar("scr_ceasefire", "0");

	// set up kill cam
	killcam = getCvar("scr_killcam");
	if(killcam == "")				// Kill cam
		killcam = "1";
	setCvar("scr_killcam", killcam, true);
	level.killcam = getCvarInt("scr_killcam");
	setCvar("ui_killcam", level.killcam);
	makeCvarServerInfo("ui_killcam", "0");

	if(getCvar("scr_teambalance") == "")		// Auto Team Balancing
		setCvar("scr_teambalance", "0");
	level.teambalance = getCvarInt("scr_teambalance");
	level.teambalancetimer = 0;

	if(getCvar("scr_freelook") == "")		// Free look spectator
		setCvar("scr_freelook", "0");
	level.allowfreelook = getCvarInt("scr_freelook");
	
	if(getCvar("scr_spectateenemy") == "")		// Spectate Enemy Team
		setCvar("scr_spectateenemy", "0");
	level.allowenemyspectate = getCvarInt("scr_spectateenemy");
	
	if(getCvar("scr_death_wait_time") == "")	// Made up cvar, for the allies_deat_wait_time. This controls the delay for respawning reinforcement waves.
		setCvar("scr_death_wait_time", "5");
	level.death_wait_time = getCvarint("scr_death_wait_time");
	
	if(getCvar("scr_ctf_roundlimit") == "")		// Round limit per map
		setCvar("scr_ctf_roundlimit", "5");
	level.roundlimit = getCvarInt("scr_ctf_roundlimit");
	setCvar("ui_ctf_roundlimit", level.roundlimit);
	makeCvarServerInfo("ui_ctf_roundlimit", "0");

	if(!isDefined(game["compass_range"]))		// set up the compass range.
		game["compass_range"] = 1024;		
	setCvar("cg_hudcompassMaxRange", game["compass_range"]);
	makeCvarServerInfo("cg_hudcompassMaxRange", "0");

	if(!isDefined(game["ctf_attacker_obj_text"]))		
		game["ctf_attacker_obj_text"] = (&"GMI_CTF_ATTACKER_OBJECTIVE");
	
	if(!isDefined(game["ctf_spectator_obj_text"]))		
		game["ctf_spectator_obj_text"] = (&"GMI_CTF_SPECTATOR_OBJECTIVE");
	
	if(getCvar("scr_ctf_showoncompass") == "")
		setCvar("scr_ctf_showoncompass", "0");
	level.showoncompass = getCvarInt("scr_ctf_showoncompass");

	if(getCvar("scr_ctf_positiontime") == "")
		setCvar("scr_ctf_positiontime", "6");
	level.PositionUpdateTime = getCvarInt("scr_ctf_positiontime");

	if (!isdefined (game["BalanceTeamsNextRound"]))
		game["BalanceTeamsNextRound"] = false;
	
	level.ROUNDSTARTED = false;			// Set up level.roundstarted to be false, until both teams have 1 person.
	level.roundended = false;			// Set up level.roundended to be false, until the round has ended, this will be taken out, since there will not be a timelimit to rounds.
	level.mapended = false;				// Set up level.mapended to be false, until the overall timelimit is finished.
	
	level.exist["allies"] = 0; 	// This is a level counter, used when clients choose a team.
	level.exist["axis"] = 0; 	// This is a level counter, used when clients choose a team.
	level.exist["teams"] = false;
	level.didexist["allies"] = false;
	level.didexist["axis"] = false;
	level.death_pool["allies"] = 0; // Sets the allies death pool to 0.
	level.death_pool["axis"] = 0; // Sets the axis death pool to 0.
	level.allies_cap_count = 0;  // how many times the allies capped in the current round
	level.axis_cap_count = 0;  // how many times the axis capped in the current round
	
	// only going to archive if kill cam is on
	if(level.killcam >= 1)
		setarchive(true);

	//get the minefields
	level.minefield = getentarray("minefield", "targetname");
	if (!isdefined (level.minefield))
		level.minefield = [];
	hurtTrigs = getentarray("trigger_hurt","classname");
	for (i=0;i<hurtTrigs.size;i++)
		level.minefield[level.minefield.size] = hurtTrigs[i];
	level.deepwater = getentarray("deepwater", "targetname");
	if (!isdefined (level.deepwater))
		level.deepwater = [];

	if(!isDefined(game["allies"]))
		game["allies"] = "american"; // If not defined, set the global game["allies"] to american.
	if(!isDefined(game["axis"]))
		game["axis"] = "german"; // If not defined, set the global game["axis"] to german.

	level.axis_held_flag = "xmodel/o_ctf_flag_g";
	level.held_tag_flag = "TAG_HELMETSIDE";
	level.healthqueue = [];
	level.healthqueuecurrent = 0;

	switch( game["allies"])
	{
		case	"british":	level.allies_held_flag = "xmodel/o_ctf_flag_b";
					break;
		case	"russian":	level.allies_held_flag = "xmodel/o_ctf_flag_r";
					break;
		default:		level.allies_held_flag = "xmodel/o_ctf_flag_us";
					break;
	}

	// 
	// DEBUG
	//
	if(getCvar("scr_debug_ctf") == "")
		setCvar("scr_debug_ctf", "0"); 

	//TEST
	if(getCvar("test_var") == "")
		setCvar("test_var", "2"); 
	level.testvar = 2;

	level.threadcount = 0;

}

// ----------------------------------------------------------------------------------
// CALLBACKS
// ----------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------
//	Callback_StartGameType
//
// 		Gets called automatically when the game starts
// ----------------------------------------------------------------------------------
Callback_StartGameType() // Setup the game.
{
	// if this is a fresh map start, set nationalities based on cvars, otherwise leave game variable nationalities as set in the level script
	if(!isDefined(game["gamestarted"]))
	{
		// defaults if not defined in level script
		if(!isDefined(game["allies"]))
			game["allies"] = "american"; // If not defined, set the global game["allies"] to american.
		if(!isDefined(game["axis"]))
			game["axis"] = "german"; // If not defined, set the global game["axis"] to german.

		if(!isDefined(game["ctf_layoutimage"])) // If not defined, set the game["layoutimage"] to default. usually this is set in the mapname.gsc
			game["ctf_layoutimage"] = "default";

		layoutname = "levelshots/layouts/hud@layout_" + game["ctf_layoutimage"]; // Set layoutname to be hud@layout_"whatever game["layoutimage"]" is.

		precacheShader(layoutname); // Precache the layoutimage.
		setCvar("scr_layoutimage", layoutname); // Setup the scr_layoutimage cvar to be layoutname.
		makeCvarServerInfo("scr_layoutimage", ""); // Set the cvar with the scr_layoutimage.

		// server cvar overrides
		if(getCvar("scr_allies") != "")
			game["allies"] = getCvar("scr_allies");	
		if(getCvar("scr_axis") != "")
			game["axis"] = getCvar("scr_axis");

		game["menu_serverinfo"] = "serverinfo_" + getCvar("g_gametype");
		game["menu_team"] = "team_" + game["allies"] + game["axis"];
		game["menu_weapon_allies"] = "weapon_" + game["allies"];
		game["menu_weapon_axis"] = "weapon_" + game["axis"];
		game["menu_viewmap"] = "viewmap";
		game["menu_callvote"] = "callvote";
		game["menu_quickcommands"] = "quickcommands";
		game["menu_quickstatements"] = "quickstatements";
		game["menu_quickresponses"] = "quickresponses";
		game["menu_quickvehicles"] = "quickvehicles";
		game["menu_quickrequests"] = "quickrequests";

		// WORM BEGIN
		/* Mod Screen Elements*/

		/* PAM precacheStrings */
		maps\mp\gametypes\_pam_utilities::Get_Current_PAM_Ver();
		precacheString(game["pamstring"]);

		/* Get League Logo */
		if (!isdefined(game["leaguestring"]))
			game["leaguestring"] = &"Unknown Pam_Mode Error";
		precacheString(game["leaguestring"]);

		// TEAM NAMES
		game["dspteam1"] = &"TEAM 1";
		precacheString(game["dspteam1"]);
		game["dspteam2"] = &"TEAM 2";

		// MATCH RESULTS
		precacheString(game["dspteam2"]);
		game["team1win"] = &"Team 1 Wins!";
		precacheString(game["team1win"]);
		game["team2win"] = &"Team 2 Wins!";
		precacheString(game["team2win"]);
		game["dsptie"] = &"Its a TIE!";
		precacheString(game["dsptie"]);
		game["matchover"] = &"Match Over";
		precacheString(game["matchover"]);
		game["overtime"] = &"Going to OverTime";
		precacheString(game["overtime"]);
		game["overtimemode"] = &"Overtime";
		precacheString(game["overtimemode"]);
		game["timeexp"] = &"Time Expired";
		precacheString(game["timeexp"]);

		// HALFTIME TEXT
		game["halftime"] = &"Halftime";
		precacheString(game["halftime"]);
		game["switching"] = &"Team Auto-Switch";
		precacheString(game["switching"]);	
		game["switching2"] = &"Please wait";
		precacheString(game["switching2"]);

		// READY-UP TEXT
		game["waiting"] = &"Ready-Up Mode";
		precacheString(game["waiting"]);
		game["allready"] = &"All Players Ready!";
		precacheString(game["allready"]);
		game["start2ndhalf"] = &"Second Half Starting";
		precacheString(game["start2ndhalf"]);
		game["start1sthalf"] = &"Match Starting";
		precacheString(game["start1sthalf"]);
		game["MatchLive"] = &"Match Live!";
		precacheString(game["MatchLive"]);
		game["ready"] = &"Ready";
		precacheString(game["ready"]);
		game["notready"] = &"Not Ready";
		precacheString(game["notready"]);
		game["status"] = &"Your Status";
		precacheString(game["status"]);
		game["waitingon"] = &"Waiting on";
		precacheString(game["waitingon"]);
		game["playerstext"] = &"Players";
		precacheString(game["playerstext"]);
		game["hudrecording"] = &"Demos Started";
		precacheString(game["hudrecording"]);


		//Round Starting Display
		game["round"] = &"Round";
		precacheString(game["round"]);
		game["starting"] = &"Starting";
		precacheString(game["starting"]);

		// PLAYERS LEFT TEXT
		game["dspaxisleft"] = &"AXIS LEFT:";
		precacheString(game["dspaxisleft"]);		
		game["dspalliesleft"] = &"ALLIES LEFT:";
		precacheString(game["dspalliesleft"]);

		// Penalty Notice
		game["penalty"] = &"Penalty Time";
		precacheString(game["penalty"]);

		//precacheString(&"pam_PlayerName");
		
		// Scoreboard Text
		game["scorebd"] = &"Scoreboard";
		precacheString(game["scorebd"]);
		game["dspaxisscore"] = &"AXIS SCORE";
		precacheString(game["dspaxisscore"]);		
		game["dspalliesscore"] = &"ALLIES SCORE";
		precacheString(game["dspalliesscore"]);
		game["1sthalf"] = &"1st Half";
		precacheString(game["1sthalf"]);	
		game["2ndhalf"] = &"2nd Half";
		precacheString(game["2ndhalf"]);
		game["matchscore2"] = &"Match";
		precacheString(game["matchscore2"]);	
		game["1sthalfscore"] = &"1st Half Scores:";
		precacheString(game["1sthalfscore"]);	
		game["2ndhalfscore"] = &"2nd Half Scores:";
		precacheString(game["2ndhalfscore"]);	
		game["matchscore"] = &"Match Scores:";
		precacheString(game["matchscore"]);	
		game["touches"] = &"Touches";
		precacheString(game["touches"]);

		// FLAG NEW Announcements
		game["flagret"] = &"Flag Returned";
		precacheString(game["flagret"]);
		game["flagdrop"] = &"Flag Dropped";
		precacheString(game["flagdrop"]);
		game["flagtaken"] = &"Flag Taken";
		precacheString(game["flagtaken"]);

		// Random Team Announcements
		game["forOT"] = &"For OT";
		precacheString(game["forOT"]);
		game["sameteams"]=&"Same Sides";
		precacheString(game["sameteams"]);
		game["swapteams"]=&"Swap Sides";
		precacheString(game["swapteams"]);

		// Sudden Death
		game["suddendeath"]=&"Sudden Death Active";
		precacheString(game["suddendeath"]);

		/* end PAM precacheStrings */


		precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");
		precacheString(&"MPSCRIPT_KILLCAM");
		precacheString(&"MPSCRIPT_ALLIES_WIN");
		precacheString(&"MPSCRIPT_AXIS_WIN");
		// GMI STRINGS
		precacheString(&"GMI_MP_CEASEFIRE");
		precacheString(&"GMI_CTF_MATCHSTARTING");
		precacheString(&"GMI_CTF_MATCHRESUMING");
		precacheString(&"GMI_CTF_OBJECTIVE");
		precacheString(&"GMI_CTF_ALLIES_CAP_FLAG");
		precacheString(&"GMI_CTF_AXIS_CAP_FLAG");
		precacheString(&"GMI_MP_YOU_WILL_SPAWN_WITH_AN_NEXT");
		precacheString(&"GMI_MP_YOU_WILL_SPAWN_WITH_A_NEXT");
		precacheString(&"GMI_CTF_ATTACKER_OBJECTIVE");
		precacheString(&"GMI_CTF_SPECTATOR_OBJECTIVE");
		precacheString(&"GMI_CTF_TIMEEXPIRED");
		precacheString(&"GMI_CTF_ROUND_DRAW");
		precacheString(&"GMI_CTF_AXIS_PICKED_UP_FLAG");
		precacheString(&"GMI_CTF_ALLIES_PICKED_UP_FLAG");
		precacheString(&"GMI_CTF_ALLIES_FLAG_RETURNED");
		precacheString(&"GMI_CTF_AXIS_FLAG_RETURNED");
		precacheString(&"GMI_CTF_PLAYER_RETURNED_FLAG_AXIS");
		precacheString(&"GMI_CTF_PLAYER_RETURNED_FLAG_ALLIES");
		precacheString(&"GMI_CTF_AXIS_CAPTURED_FLAG");
		precacheString(&"GMI_CTF_ALLIES_CAPTURED_FLAG");
		precacheString(&"GMI_CTF_PLAYER_CAPTURED_FLAG_AXIS");
		precacheString(&"GMI_CTF_PLAYER_CAPTURED_FLAG_ALLIES");
		precacheString(&"GMI_CTF_FLAG_INMINES");
		precacheString(&"GMI_CTF_AXIS_FLAG_DROPPED");
		precacheString(&"GMI_CTF_ALLIES_FLAG_DROPPED");
		precacheString(&"GMI_CTF_AXIS_FLAG_TIMEOUT_RETURNING");
		precacheString(&"GMI_CTF_ALLIES_FLAG_TIMEOUT_RETURNING");
		precacheString(&"GMI_CTF_U_R_CARRYING_AXIS");
		precacheString(&"GMI_CTF_U_R_CARRYING_ALLIES");
		precacheString(&"GMI_CTF_DEFENDED_AXIS_FLAG");
		precacheString(&"GMI_CTF_DEFENDED_ALLIES_FLAG");
		precacheString(&"GMI_CTF_ASSISTED_AXIS_FLAG_CARRIER");
		precacheString(&"GMI_CTF_ASSISTED_ALLIES_FLAG_CARRIER");
		precacheString(&"GMI_DOM_ALLIEDMISSIONACCOMPLISHED");
		precacheString(&"GMI_DOM_AXISMISSIONACCOMPLISHED");
		precacheString(&"num_0");
		precacheString(&"num_1");
		precacheString(&"num_2");
		precacheString(&"num_3");
		precacheString(&"num_4");
		precacheString(&"num_5");
		precacheString(&"num_6");
		precacheString(&"num_7");
		precacheString(&"num_8");
		precacheString(&"num_9");

		precacheMenu(game["menu_serverinfo"]);
		precacheMenu(game["menu_team"]);
		precacheMenu(game["menu_weapon_allies"]);
		precacheMenu(game["menu_weapon_axis"]);
		precacheMenu(game["menu_viewmap"]);
		precacheMenu(game["menu_callvote"]);
		precacheMenu(game["menu_quickcommands"]);
		precacheMenu(game["menu_quickstatements"]);
		precacheMenu(game["menu_quickresponses"]);
		precacheMenu(game["menu_quickvehicles"]);
		precacheMenu(game["menu_quickrequests"]);
		
		precacheShader("black");
		precacheShader("white");
		precacheShader("hudScoreboard_mp");
		precacheShader("gfx/hud/hud@mpflag_spectator.tga");

		precacheStatusIcon("gfx/hud/hud@status_dead.tga");
		precacheStatusIcon("gfx/hud/hud@status_connecting.tga");

		//	all silly stuff
		precacheShader("gfx/hud/ctf_stance_crouch.dds");
		precacheShader("gfx/hud/ctf_stance_stand.dds");
		precacheShader("gfx/hud/ctf_stance_prone.dds");
		precacheShader("gfx/hud/ctf_stance_sprint.dds");

		// GMI FLAG MATCH IMAGES:
		precacheShader("gfx/hud/headicon@german.dds");
		precacheShader("hudStopwatch");
		precacheShader("hudStopwatchNeedle");

		// set up team specific variables
		switch( game["allies"])
		{
		case "british":
			game["headicon_carrier_axis"] = "gfx/hud/headicon@ctf_british.dds";
			game["statusicon_carrier_axis"] = "gfx/hud/hud@ctf_british.dds";

			game["hud_allies_base_with_flag"] = "gfx/hud/hud@objective_british";
			game["hud_allies_base"] = "gfx/hud/hud@b_flag_nobase2";

			game["hud_allies_flag"] 	= "gfx/hud/ctf_flag_b_1.dds";
			game["hud_allies_flag_taken"] 	= "gfx/hud/ctf_flag_b_0.dds";
			
			game["sound_allies_victory_vo"] = "MP_announcer_allies_win";
			game["sound_allies_victory_music"] = "uk_victory";
			game["sound_allies_we_have_enemy_flag"] = "uk_grabbed_enemy_flag";
			game["sound_allies_enemy_has_our_flag"] = "uk_our_flag_taken";
			game["sound_allies_enemy_has_captured"] = "uk_our_flag_captured";  
			game["sound_allies_we_captured"] = "uk_captured_flag";  
			game["sound_allies_flag_has_been_returned"] = "uk_flag_returned";  
			break;
		case "russian":
			game["headicon_carrier_axis"] = "gfx/hud/headicon@ctf_russian.dds";
			game["statusicon_carrier_axis"] = "gfx/hud/hud@ctf_russian.dds";

			game["hud_allies_base_with_flag"] = "gfx/hud/hud@objective_russian";
			game["hud_allies_base"] = "gfx/hud/hud@r_flag_nobase";

			game["hud_allies_flag"] 	= "gfx/hud/ctf_flag_r_1.dds";
			game["hud_allies_flag_taken"] 	= "gfx/hud/ctf_flag_r_0.dds";

			game["sound_allies_victory_vo"] = "MP_announcer_allies_win";
			game["sound_allies_victory_music"] = "ru_victory";
			game["sound_allies_we_have_enemy_flag"] = "ru_grabbed_enemy_flag";
			game["sound_allies_enemy_has_our_flag"] = "ru_our_flag_taken";
			game["sound_allies_we_captured"] = "ru_captured_flag";  
			game["sound_allies_enemy_has_captured"] = "ru_our_flag_captured";  
			game["sound_allies_flag_has_been_returned"] = "ru_flag_returned";  
			break;
		default:		// default is american
			game["headicon_carrier_axis"] = "gfx/hud/headicon@ctf_american.dds";
			game["statusicon_carrier_axis"] = "gfx/hud/hud@ctf_american.dds";

			game["hud_allies_base_with_flag"] = "gfx/hud/hud@objective_american";
			game["hud_allies_base"] = "gfx/hud/hud@a_flag_nobase";

			game["hud_allies_flag"] 	= "gfx/hud/ctf_flag_us_1.dds";
			game["hud_allies_flag_taken"] 	= "gfx/hud/ctf_flag_us_0.dds";


			game["sound_allies_victory_vo"] = "MP_announcer_allies_win";
			game["sound_allies_victory_music"] = "us_victory";
			game["sound_allies_we_have_enemy_flag"] = "us_grabbed_enemy_flag";
			game["sound_allies_enemy_has_our_flag"] = "us_our_flag_taken";
			game["sound_allies_we_captured"] = "us_captured_flag";  
			game["sound_allies_enemy_has_captured"] = "us_our_flag_captured";  
			game["sound_allies_flag_has_been_returned"] = "us_flag_returned";  
			break;
		}

							 
		game["sound_axis_victory_vo"] = "MP_announcer_axis_win";
		game["sound_axis_victory_music"] = "ge_victory";
		game["sound_axis_we_have_enemy_flag"] = "ge_grabbed_enemy_flag";
		game["sound_axis_enemy_has_our_flag"] = "ge_our_flag_taken";
		game["sound_axis_we_captured"] = "ge_captured_flag";  
		game["sound_axis_enemy_has_captured"] = "ge_our_flag_captured";  	
		game["sound_axis_flag_has_been_returned"] = "ge_flag_returned";  

		game["sound_round_draw_vo"] = "MP_announcer_round_draw";

		game["hud_axis_base_with_flag"] = "gfx/hud/hud@objective_german";
		game["hud_axis_base"] = "gfx/hud/hud@g_flag_nobase3";


		precacheShader(game["hud_allies_base_with_flag"]+ ".dds");
		precacheShader(game["hud_allies_base_with_flag"]+ "_up.dds");
		precacheShader(game["hud_allies_base_with_flag"]+ "_down.dds");
		precacheShader(game["hud_allies_base"]+ ".dds");
		precacheShader(game["hud_allies_base"]+ "_up.dds");
		precacheShader(game["hud_allies_base"]+ "_down.dds");
		precacheShader(game["hud_axis_base_with_flag"]+ ".dds");
		precacheShader(game["hud_axis_base_with_flag"]+ "_up.dds");
		precacheShader(game["hud_axis_base_with_flag"]+ "_down.dds");
		precacheShader(game["hud_axis_base"]+ ".dds");
		precacheShader(game["hud_axis_base"]+ "_up.dds");
		precacheShader(game["hud_axis_base"]+ "_down.dds");
		precacheShader("gfx/hud/hud@objective_bel.tga");
		precacheShader("gfx/hud/hud@objective_bel_up.tga");
		precacheShader("gfx/hud/hud@objective_bel_down.tga");

		// set up the hud flag icons

		game["hud_axis_flag"] 		= "gfx/hud/ctf_flag_g_1.dds";
		game["hud_axis_flag_taken"] 	= "gfx/hud/ctf_flag_g_0.dds";
		
		// victory images
		if ( !isDefined( game["hud_allies_victory_image"] ) )
			game["hud_allies_victory_image"] = "gfx/hud/allies_win";
		if ( !isDefined( game["hud_axis_victory_image"] ) )
			game["hud_axis_victory_image"] = "gfx/hud/axis_win";

		precacheShader(game["hud_axis_flag"]);
		precacheShader(game["hud_axis_flag_taken"]);
		precacheShader(game["hud_allies_flag"]);
		precacheShader(game["hud_allies_flag_taken"]);
		precacheShader(game["hud_allies_victory_image"]);
		precacheShader(game["hud_axis_victory_image"]);

		// set some values for the icon positions
		game["flag_icons_w"] = 64;
		game["flag_icons_h"] = 32;
		game["flag_icons_spacing"] = 128;
		game["flag_icons_x"] = 190;
		game["flag_icons_y"] = 440;
				
		// the head icon should actually be the opposite teams flag
		game["headicon_carrier_allies"] = "gfx/hud/headicon@ctf_german.dds";
		game["statusicon_carrier_allies"] = "gfx/hud/hud@ctf_german.dds";

		precacheHeadIcon(game["headicon_carrier_allies"]);
		precacheHeadIcon(game["headicon_carrier_axis"]);
		precacheStatusIcon(game["statusicon_carrier_axis"]);
		precacheStatusIcon(game["statusicon_carrier_allies"]);

		maps\mp\gametypes\_pam_teams::precache(); // Precache weapons.
		maps\mp\gametypes\_pam_teams::scoreboard(); // Precache scoreboard menu.

		precacheItem("item_health");

		precachemodel("xmodel/o_ctf_flag_b");
		precachemodel("xmodel/o_ctf_flag_r");
		precachemodel("xmodel/o_ctf_flag_us");
		precachemodel("xmodel/o_ctf_flag_g");
	
		// if fs_copyfiles is set then we are building paks and cache everything
		if ( getcvar("fs_copyfiles") == "1")
		{
			precacheHeadIcon("gfx/hud/headicon@american.dds");
			precacheHeadIcon("gfx/hud/headicon@british.dds");
			precacheHeadIcon("gfx/hud/headicon@russian.dds");
			precacheStatusIcon("gfx/hud/headicon@american.dds");
			precacheStatusIcon("gfx/hud/headicon@british.dds");
			precacheStatusIcon("gfx/hud/headicon@russian.dds");
			
			precacheShader("gfx/hud/hud@objective_british");
			precacheShader("gfx/hud/hud@objective_british_up");
			precacheShader("gfx/hud/hud@objective_british_down");
			precacheShader("gfx/hud/hud@b_flag_nobase2");
			precacheShader("gfx/hud/hud@b_flag_nobase2_up");
			precacheShader("gfx/hud/hud@b_flag_nobase2_down");
			precacheShader("gfx/hud/hud@b_cenflag.dds");
			precacheShader("gfx/hud/hud@b_cenflag_cap.dds");
			precacheShader("gfx/hud/hud@objective_russian");
			precacheShader("gfx/hud/hud@objective_russian_up");
			precacheShader("gfx/hud/hud@objective_russian_down");
			precacheShader("gfx/hud/hud@r_flag_nobase");
			precacheShader("gfx/hud/hud@r_flag_nobase_up");
			precacheShader("gfx/hud/hud@r_flag_nobase_down");
			precacheShader("gfx/hud/hud@r_cenflag.dds");
			precacheShader("gfx/hud/hud@r_cenflag_cap.dds");
			precacheShader("gfx/hud/hud@objective_american");
			precacheShader("gfx/hud/hud@objective_american_up");
			precacheShader("gfx/hud/hud@objective_american_down");
			precacheShader("gfx/hud/hud@a_flag_nobase");
			precacheShader("gfx/hud/hud@a_flag_nobase_up");
			precacheShader("gfx/hud/hud@a_flag_nobase_down");
			precacheShader("gfx/hud/hud@a_cenflag.dds");
			precacheShader("gfx/hud/hud@a_cenflag_cap.dds");
		}
	}
	
	maps\mp\gametypes\_pam_teams::modeltype(); // Precache player models.
	maps\mp\gametypes\_pam_teams::initGlobalCvars();
	maps\mp\gametypes\_pam_teams::initWeaponCvars();
	maps\mp\gametypes\_pam_teams::restrictPlacedWeapons(); // Restrict certain weapons, if they exist. Cvar dependant.
	thread maps\mp\gametypes\_pam_teams::updateGlobalCvars();
	thread maps\mp\gametypes\_pam_teams::updateWeaponCvars();

	game["gamestarted"] = true; // Set the global flag of "gamestarted" to be true.
	
	setClientNameMode("auto_change"); 

	thread ctf();

	thread GameRoundThink();

	thread startGame();
	thread updateGametypeCvars();
	
//	thread checkEvenTeams();
}

// ----------------------------------------------------------------------------------
//	Callback_PlayerConnect
//
// 		Gets called automatically when a player joins
// ----------------------------------------------------------------------------------
Callback_PlayerConnect()
{
	self.statusicon = "gfx/hud/hud@status_connecting.tga";
	self waittill("begin");
	self.statusicon = "";
	if (!isdefined (self.pers["teamTime"]))
		self.pers["teamTime"] = 1000000;
	self.hudelem = [];
	
	if(!isDefined(self.pers["score"]))
		self.pers["score"] = 0;

	if(!isDefined(self.pers["team"]))
		iprintln(&"MPSCRIPT_CONNECTED", self);

	lpselfnum = self getEntityNumber();

	level.R_U_Name[lpselfnum] = self.name;
	level.R_U_State[lpselfnum] = "notready";
	self.R_U_Looping = 0;

	if(level.rdyup == 1)
	{
		self.statusicon = game["br_hudicons_allies_0"];
		self thread maps\mp\gametypes\_pam_readyup::readyup(lpselfnum);
	}

	lpselfguid = self getGuid();
	logPrint("J;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");

	self.flag_held = 0;

	// make sure that the rank variable is initialized
	if ( !isDefined( self.pers["rank"] ) )
		self.pers["rank"] = 0;

	// setup teamkiller tracking
	if(!isDefined(self.teamkiller) || self.teamkiller != 0)
		self.teamkiller = 0;
	if(!isDefined(self.teamkillertotal) || self.teamkillertotal != 0)
		self.teamkillertotal = 0;
	if(!isDefined(self.wereteamkilled))
		self.wereteamkilled = 0;		

	// set the cvar for the map quick bind
	self setClientCvar("g_scriptQuickMap", game["menu_viewmap"]);
	
	if(game["state"] == "intermission")
	{
		SpawnIntermission();
		return;
	}

	level endon("intermission");

	if(isDefined(self.pers["team"]) && self.pers["team"] != "spectator")
	{
		self setClientCvar("ui_weapontab", "1");

		if(self.pers["team"] == "allies")
		{
			checkSnipers();
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
		}
		else
		{
			checkSnipers();
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
		}

		if(isDefined(self.pers["weapon"]))
			spawnPlayer();
		else
		{
			self.sessionteam = "spectator";

			SpawnSpectator();
			checkSnipers();

			if(self.pers["team"] == "allies")
				self openMenu(game["menu_weapon_allies"]);
			else
				self openMenu(game["menu_weapon_axis"]);
		}
	}
	else
	{
		self setClientCvar("g_scriptMainMenu", game["menu_team"]);
		self setClientCvar("ui_weapontab", "0");

		if(!isDefined(self.pers["skipserverinfo"]))
			self openMenu(game["menu_serverinfo"]);

		self.pers["team"] = "spectator";
		self.sessionteam = "spectator";

		SpawnSpectator();
	}

	// start the vsay thread
	self thread maps\mp\gametypes\_pam_teams::vsay_monitor();

	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		if(menu == game["menu_serverinfo"] && response == "close")
		{
			self.pers["skipserverinfo"] = true;
			self openMenu(game["menu_team"]);
		}

		if(response == "open" || response == "close")
			continue;
			
		if(menu == game["menu_team"] ) // && self.teamkiller != 1)	// check to make sure they're not trying to switch teams while in TK limbo

		{
			switch(response)
			{
			case "allies":
			case "axis":
			case "autoassign":
				if(response == "autoassign")
				{
					numonteam["allies"] = 0;
					numonteam["axis"] = 0;

					players = getentarray("player", "classname");
					for(i = 0; i < players.size; i++)
					{
						player = players[i];
					
						if(!isDefined(player.pers["team"]) || player.pers["team"] == "spectator" || player == self)
							continue;
			
						numonteam[player.pers["team"]]++;
					}
					
					// if teams are equal return the team with the lowest score
					if(numonteam["allies"] == numonteam["axis"])
					{
						if(getTeamScore("allies") == getTeamScore("axis"))
						{
							teams[0] = "allies";
							teams[1] = "axis";
							response = teams[randomInt(2)];
						}
						else if(getTeamScore("allies") < getTeamScore("axis"))
							response = "allies";
						else
							response = "axis";
					}
					else if(numonteam["allies"] < numonteam["axis"])
						response = "allies";
					else
						response = "axis";
					skipbalancecheck = true;
				}
				
				if(response == self.pers["team"] && self.sessionstate == "playing")
					break;
				
				
				//Check if the teams will become unbalanced when the player goes to this team...
				//------------------------------------------------------------------------------
				if ( (level.teambalance > 0) && (!isdefined (skipbalancecheck)) )
				{
					//Get a count of all players on Axis and Allies
					players = maps\mp\gametypes\_pam_teams::CountPlayers();
					
					if (self.sessionteam != "spectator")
					{
						if (((players[response] + 1) - (players[self.pers["team"]] - 1)) > level.teambalance)
						{
							if (response == "allies")
							{
								if (game["allies"] == "american")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED",&"PATCH_1_3_AMERICAN");
								else if (game["allies"] == "british")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED",&"PATCH_1_3_BRITISH");
								else if (game["allies"] == "russian")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED",&"PATCH_1_3_RUSSIAN");
							}
							else
								self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED",&"PATCH_1_3_GERMAN");
							break;
						}
					}
					else
					{
						if (response == "allies")
							otherteam = "axis";
						else
							otherteam = "allies";
						if (((players[response] + 1) - players[otherteam]) > level.teambalance)
						{
							if (response == "allies")
							{
								if (game["allies"] == "american")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED2",&"PATCH_1_3_AMERICAN");
								else if (game["allies"] == "british")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED2",&"PATCH_1_3_BRITISH");
								else if (game["allies"] == "russian")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_ALLIED2",&"PATCH_1_3_RUSSIAN");
							}
							else
							{
								if (game["allies"] == "american")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_AXIS",&"PATCH_1_3_AMERICAN");
								else if (game["allies"] == "british")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_AXIS",&"PATCH_1_3_BRITISH");
								else if (game["allies"] == "russian")
									self iprintlnbold(&"PATCH_1_3_CANTJOINTEAM_AXIS",&"PATCH_1_3_RUSSIAN");
							}
							break;
						}
					}
				}
				skipbalancecheck = undefined;
				//------------------------------------------------------------------------------
				
				if(response != self.pers["team"] && self.sessionstate == "playing")
					self suicide();

				self notify("end_respawn");

				self.pers["team"] = response;
				self.pers["teamTime"] = (gettime() / 1000);
				self.pers["weapon"] = undefined;
				self.pers["weapon1"] = undefined;
				self.pers["weapon2"] = undefined;
				self.pers["spawnweapon"] = undefined;
				self.pers["savedmodel"] = undefined;
				self.nextroundweapon = undefined;
				
				self thread printJoinedTeam(self.pers["team"]);

				// if there are weapons the user can select then open the weapon menu
				if ( maps\mp\gametypes\_pam_teams::isweaponavailable(self.pers["team"]) )
				{
					if(self.pers["team"] == "allies")
					{
						menu = game["menu_weapon_allies"];
					}
					else
					{
						menu = game["menu_weapon_axis"];
					}
				
					self setClientCvar("ui_weapontab", "1");
					self openMenu(menu);
				}
				else
				{
					self setClientCvar("ui_weapontab", "0");
					self menu_spawn("none");
				}
		
				self setClientCvar("g_scriptMainMenu", menu);
				break;
				
			case "spectator":
				if(self.pers["team"] != "spectator")
				{
					if(isAlive(self))
						self suicide();
						
					self thread stopwatch_delete("spectator");

					self.pers["team"] = "spectator";
					self.pers["teamTime"] = 1000000;
					self.pers["weapon"] = undefined;
					self.pers["weapon1"] = undefined;
					self.pers["weapon2"] = undefined;
					self.pers["spawnweapon"] = undefined;
					self.pers["savedmodel"] = undefined;
					
					self.sessionteam = "spectator";
					self setClientCvar("g_scriptMainMenu", game["menu_team"]);
					self setClientCvar("ui_weapontab", "0");
					SpawnSpectator();
	
					level thread CheckMatchStart();
				}
				break;

			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;

			case "viewmap":
				self openMenu(game["menu_viewmap"]);
				break;
			
			case "callvote":
				self openMenu(game["menu_callvote"]);
				break;
			}
		}		
		else if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"])
		{
			if(response == "team")
			{
				self openMenu(game["menu_team"]);
				continue;
			}
			else if(response == "viewmap")
			{
				self openMenu(game["menu_viewmap"]);
				continue;
			}
			else if(response == "callvote")
			{
				self openMenu(game["menu_callvote"]);
				continue;
			}
			
			if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
				continue;

			weapon = self maps\mp\gametypes\_pam_teams::restrict(response);

			if(weapon == "restricted")
			{
				self openMenu(menu);
				continue;
			}
			
			self.pers["selectedweapon"] = weapon;

			if(isDefined(self.pers["weapon"]) && self.pers["weapon"] == weapon && !isDefined(self.pers["weapon1"]))
				continue;

			menu_spawn(weapon);
		}
		else if(menu == game["menu_viewmap"])
		{
			switch(response)
			{
			case "team":
				self openMenu(game["menu_team"]);
				break;
				
			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;

			case "callvote":
				self openMenu(game["menu_callvote"]);
				break;
			}
		}
		else if(menu == game["menu_callvote"])
		{
			switch(response)
			{
			case "team":
				self openMenu(game["menu_team"]);
				break;
				
			case "weapon":
				if(self.pers["team"] == "allies")
					self openMenu(game["menu_weapon_allies"]);
				else if(self.pers["team"] == "axis")
					self openMenu(game["menu_weapon_axis"]);
				break;

			case "viewmap":
				self openMenu(game["menu_viewmap"]);
				break;
			}
		}
		else if(menu == game["menu_quickcommands"])
			maps\mp\gametypes\_pam_teams::quickcommands(response);
		else if(menu == game["menu_quickstatements"])
			maps\mp\gametypes\_pam_teams::quickstatements(response);
		else if(menu == game["menu_quickresponses"])
			maps\mp\gametypes\_pam_teams::quickresponses(response);
		else if(menu == game["menu_quickvehicles"])
			maps\mp\gametypes\_pam_teams::quickvehicles(response);
		else if(menu == game["menu_quickrequests"])
			maps\mp\gametypes\_pam_teams::quickrequests(response);
	}

}

// ----------------------------------------------------------------------------------
//	Callback_PlayerDisconnect
//
// 		Gets called automatically when a player disconnects
// ----------------------------------------------------------------------------------
Callback_PlayerDisconnect()
{
	lpselfnum = self getEntityNumber();

	level.R_U_Name[lpselfnum] = "disconnected";
	level.R_U_State[lpselfnum] = "disconnected";
	self.R_U_Looping = 0;

	if(level.rdyup == 1)
		thread maps\mp\gametypes\_pam_readyup::Check_All_Ready();
	
	iprintln(&"MPSCRIPT_DISCONNECTED", self);
	
	lpselfguid = self getGuid();
	logPrint("Q;" + lpselfguid + ";" + lpselfnum + ";" + self.name + "\n");

	// make sure the flag gets dropped
	if(isdefined(self.hasflag))
	{
		self.hasflag drop_flag(self);
	}

	self notify("death");

	if(game["matchstarted"])
		level thread updateTeamStatus();
}

// ----------------------------------------------------------------------------------
//	Callback_PlayerDamage
//
// 		Gets called automatically when a player gets damaged
// ----------------------------------------------------------------------------------
Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	// If in warmup, do NO damage
	if (level.warmup == 1)
		return;

	if(self.sessionteam == "spectator")
		return;

	// Don't do knockback if the damage direction was not specified
	if(!isDefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	// dont take damage during ceasefire mode
	// but still take damage from ambient damage (water, minefields, fire)
	if(level.ceasefire && sMeansOfDeath != "MOD_EXPLOSIVE" && sMeansOfDeath != "MOD_WATER" && sMeansOfDeath != "MOD_TRIGGER_HURT")
		return;
		
	// check for completely getting out of the damage
//	if(!(iDFlags & level.iDFLAGS_NO_PROTECTION))
	{
		if(isPlayer(eAttacker) && (self != eAttacker) && (self.pers["team"] == eAttacker.pers["team"]))
		{
			if(level.friendlyfire == "1" || sMeansOfDeath == "MOD_CRUSH_TANK" || sMeansOfDeath == "MOD_CRUSH_JEEP")
			{
				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
			}
			else if(level.friendlyfire == "0" )
			{
				return;
			}
			else if(level.friendlyfire == "2")
			{
				eAttacker.friendlydamage = true;
		
				iDamage = iDamage * .5;

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
				eAttacker.friendlydamage = undefined;
				
				friendly = true;
			}
			else if(level.friendlyfire == "3")
			{
				eAttacker.friendlydamage = true;

				iDamage = iDamage * .5;

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;

				self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
				eAttacker finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
				eAttacker.friendlydamage = undefined;
				
				friendly = true;
			}
		}
		else
		{
			// Make sure at least one point of damage is done
			if(iDamage < 1)
				iDamage = 1;

			self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
		}
	}

	self maps\mp\gametypes\_shellshock_gmi::DoShellShock(sWeapon, sMeansOfDeath, sHitLoc, iDamage);
		
	// Do debug print if it's enabled
	if(getCvarInt("g_debugDamage"))
	{
		println("client:" + self getEntityNumber() + " health:" + self.health +
			" damage:" + iDamage + " hitLoc:" + sHitLoc);
	}

	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfguid = self getGuid();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackguid = self getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackguid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}

		if(isDefined(friendly))
		{  
			lpattacknum = lpselfnum;
			lpattackname = lpselfname;
			lpattackguid = lpselfguid;
		}

		logPrint("D;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
}

// ----------------------------------------------------------------------------------
//	Callback_PlayerKilled
//
// 		Gets called automatically when a player dies
// ----------------------------------------------------------------------------------
Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	// If in warmup, do NO killing
	if (level.warmup == 1)
		return;

	self endon("spawned");

	if(self.sessionteam == "spectator")
		return;

	// If the player was killed by a head shot, let players know it was a head shot kill
	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	// if this is a melee kill from a binocular then make sure they know that they are a loser
	if(sMeansOfDeath == "MOD_MELEE" && (sWeapon == "binoculars_artillery_mp" || sWeapon == "binoculars_mp") )
	{
		sMeansOfDeath = "MOD_MELEE_BINOCULARS";
	}
	
	// if this is a kill from the artillery binocs change the icon
	if(sMeansOfDeath != "MOD_MELEE_BINOCULARS" && sWeapon == "binoculars_artillery_mp" )
		sMeansOfDeath = "MOD_ARTILLERY";

	// send out an obituary message to all clients about the kill
	obituary(self, attacker, sWeapon, sMeansOfDeath);

	// make sure the flag gets dropped
	if(isdefined(self.hasflag))
	{
		self.hasflag drop_flag(self);
	}

	self.sessionstate = "dead";
	if (level.rdyup != 1)
		self.statusicon = "gfx/hud/hud@status_dead.tga";
	self.headicon = "";
	if (!isdefined (self.autobalance) && level.roundstarted)
	{
		self.pers["deaths"]++;
		self.deaths = self.pers["deaths"];
	}
	
	lpselfnum = self getEntityNumber();
	lpselfguid = self getGuid();
	lpselfname = self.name;
	lpselfteam = self.pers["team"];
	lpattackerteam = "";

	attackerNum = -1;

	doKillcam = true;
	
	if(isPlayer(attacker))
	{
		if(attacker == self) // killed himself
		{
			doKillcam = false;

			deathpenalty = 1;

			if ( !level.roundended && !isdefined (self.autobalance) )
			{
				attacker.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetPoints( -1, game["br_points_suicide"]);
			}
			
			if(isDefined(attacker.friendlydamage))
				clientAnnouncement(attacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT"); 
		}
		else
		{
			attackerNum = attacker getEntityNumber();

			if (!level.roundended)
			{
				if(self.pers["team"] == attacker.pers["team"]) // killed by a friendly
				{
					attacker.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetPoints( -1, game["br_points_teamkill"]);

					deathpenalty = 1;

					// mark the teamkiller as such, punish him next time he dies.
					attacker.teamkiller = 1;
					attacker.teamkillertotal ++;
					self.wereteamkilled = 1;
				}
				else 
				{
					deathpenalty = 0;

					gave_points = false;
					
					// if the dead person was close to the flag then give the killer a defense bonus
					if ( self is_near_flag() )
					{
						// let everyone know
						if ( attacker.pers["team"] == "axis" )
							iprintln(&"GMI_CTF_DEFENDED_AXIS_FLAG", attacker);
						else
							iprintln(&"GMI_CTF_DEFENDED_ALLIES_FLAG", attacker);
						
						attacker.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetPoints( 3, 3);
						gave_points = true;
						lpselfnum = attacker getEntityNumber();
						lpselfguid = attacker getGuid();
						logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + attacker.pers["team"] + ";" + attacker.name + ";" + "ctf_defended" + "\n");
					}
					
					// if the dead person was close to the flag carrier then give the killer a assist bonus
					if ( self is_near_carrier(attacker) )
					{
						// let everyone know
						if ( attacker.pers["team"] == "axis" )
							iprintln(&"GMI_CTF_ASSISTED_AXIS_FLAG_CARRIER", attacker);
						else
							iprintln(&"GMI_CTF_ASSISTED_ALLIES_FLAG_CARRIER", attacker);
						
						attacker.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetPoints( 3, 3);
						gave_points = true;
						lpselfnum = attacker getEntityNumber();
						lpselfguid = attacker getGuid();
						logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + attacker.pers["team"] + ";" + attacker.name + ";" + "ctf_assist" + "\n");
					}
					
					// if they were not given assist or defense points then give normal points
					if ( !gave_points )
					{
						attacker.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetPoints( 1, game["br_points_kill"]);
					}
				}
			}
		}
		
		// make sure the score is in an accepatable range
		attacker.pers["score"] = maps\mp\gametypes\_scoring_gmi::ValidateScore(attacker.pers["score"]);
					
		attacker.score = attacker.pers["score"];
		
		lpattacknum = attacker getEntityNumber();
		lpattackguid = attacker getGuid();
		lpattackname = attacker.name;
		lpattackerteam = attacker.pers["team"];
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;

		deathpenalty = 1;

		// check for inflictor as well
		if ( !isdefined(eInflictor) )
			self.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetPoints( -1, 0 );

		// make sure the score is in an accepatable range
		self.pers["score"] = maps\mp\gametypes\_scoring_gmi::ValidateScore(self.pers["score"]);
					
		self.score = self.pers["score"];
		
		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";
		lpattackerteam = "world";
	}

	logPrint("K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

	// Make the player drop his weapon
	if (!isdefined (self.autobalance))
		dropSniper();

	self.pers["weapon1"] = undefined;
	self.pers["weapon2"] = undefined;
	self.pers["spawnweapon"] = undefined;

	//Remove HUD text if there is any
	for(i = 1; i < 16; i++)
	{
		if((isdefined(self.hudelem)) && (isdefined(self.hudelem[i])))
			self.hudelem[i] destroy();
	}

	if (!isdefined (self.autobalance))
	{
		body = self cloneplayer();
		
		// Make the player drop health
		self dropHealth();
	}
	self.autobalance = undefined;

	updateTeamStatus();

	if((getCvarInt("scr_killcam") <= 0) || !level.exist[self.pers["team"]]) // If the last player on a team was just killed, don't do killcam
		doKillcam = false;

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// ?? Also required for Callback_PlayerKilled to complete before killcam can execute


	// start the kill cam if it is turned on
	if(doKillcam && !level.roundended)
	{	
		who_to_watch = attackerNum;
		killcam_time = level.death_wait_time - 1;
		
		self thread maps\mp\gametypes\_killcam_gmi::DisplayKillCam(who_to_watch, killcam_time, delay);	
	}
	else
	{
		currentorigin = self.origin;
		currentangles = self.angles;

		self thread spawnSpectator(currentorigin + (0, 0, 60), currentangles);
	}

	if (!isDefined(deathpenalty))
		deathpenalty = 0;

	self thread respawn(deathpenalty);	
}

// ----------------------------------------------------------------------------------
//	menu_spawn
//
// 		called from the player connect to spawn the player
// ----------------------------------------------------------------------------------
menu_spawn(weapon)
{
	if(!game["matchstarted"])
	{
		self.pers["weapon"] = weapon;
		self.spawned = undefined;
		self SpawnPlayer();
		level CheckMatchStart();
	}
	else if(!level.roundstarted && !self.usedweapons)
	{
		if(isDefined(self.pers["weapon"]))
		{
	 		self.pers["weapon"] = weapon;
			self maps\mp\gametypes\_pam_loadout_gmi::PlayerSpawnLoadout();
			self switchToWeapon(weapon);
		}
		else
		{
			self.pers["weapon"] = weapon;
			if(!level.exist[self.pers["team"]])
			{
				self.spawned = undefined;
				self spawnPlayer();
				level CheckMatchStart();
				self thread printJoinedTeam(self.pers["team"]);
			}
			else
			{
				self thread respawn();
				self thread printJoinedTeam(self.pers["team"]);
			}
		}
	}
	// If the player is alive and playing during a round, don't give the new weapon for now.  We'll give it to the player next time he spawns.
	else if((self.sessionteam == self.pers["team"] || self.pers["team"] == "spectator" ) && game["matchstarted"] == true && level.roundstarted == true)
	{
		if(isDefined(self.pers["weapon"]))
			self.nextroundweapon = weapon;
			
		weaponname = maps\mp\gametypes\_pam_teams::getWeaponName(weapon);
		if(maps\mp\gametypes\_pam_teams::useAn(weapon))
		{
			self iprintln(&"GMI_MP_YOU_WILL_SPAWN_WITH_AN_NEXT", weaponname);
		}
		else
		{
			self iprintln(&"GMI_MP_YOU_WILL_SPAWN_WITH_A_NEXT", weaponname);
		}
	}
	else
	{
		if(isDefined(self.pers["weapon"]))
			self.oldweapon = self.pers["weapon"];

		self.pers["weapon"] = weapon;
		self.sessionteam = self.pers["team"];

		if(self.sessionstate != "playing" || level.rdyup != 1)
			self.statusicon = "gfx/hud/hud@status_dead.tga";
	
		if(self.pers["team"] == "allies")
			otherteam = "axis";
		else if(self.pers["team"] == "axis")
			otherteam = "allies";
						
		// if joining a team that has no opponents, just spawn
		if(!level.didexist[otherteam] && !level.roundended)
		{
			self.spawned = undefined;
			self spawnPlayer();
		}		
		else if(!level.didexist[self.pers["team"]] && !level.roundended)
		{
			self.spawned = undefined;
			self thread  respawn();
			level CheckMatchStart();
		}
		else
		{
			if (level.hithalftime == 1)
			{
				self waittill("halftimefinished");
			}

			self notify("switched team");
			self.spawned = undefined;
			self thread respawn();
			level CheckMatchStart();				

		}
	}

	self thread maps\mp\gametypes\_pam_teams::SetSpectatePermissions();
	if (isdefined (self.autobalance_notify))
		self.autobalance_notify destroy();
}


// ----------------------------------------------------------------------------------
// VICTORY FUNCTION
// ----------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------
//	Victory_PlaySounds
//
// 		Plays the victory sounds with an appropriate delay in each
// ----------------------------------------------------------------------------------
Victory_PlaySounds( announcer, music )
{			
	self playLocalSound(announcer);
	wait 2.0;
	//self playLocalSound(music);
}

// ----------------------------------------------------------------------------------
//	Victory_DisplayImage
//
// 		Displays the victory hud image
// ----------------------------------------------------------------------------------
Victory_DisplayImage( image )
{			
	level.victory_image = newHudElem();		
	level.victory_image.alignX = "center";
	level.victory_image.alignY = "top";
	level.victory_image.x = 320;
	level.victory_image.y = 10;
	level.victory_image.alpha = 0.75;
	level.victory_image.sort = 0.5;
	level.victory_image setShader(image, 256, 128);
}

// ----------------------------------------------------------------------------------
// SPAWNING
// ----------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------
//	Respawn
//
// 		Sets up the countdown clock and then waits for the respawn wave
// ----------------------------------------------------------------------------------
Respawn(deathpenalty)
{
	checkSnipers();

	self endon("spawned");
	self endon("end_respawn");
	firsttime = 0;
	while(!isDefined(self.pers["weapon"])) {
		
		wait 3;
		
		//self iprintln(&"");	// TODO: tell them they need to select a weapon in order to spawn
		
		if (isDefined(self.pers["weapon"]))
			break;
		
		if (firsttime < 3)
		{
			if(self.pers["team"] == "allies")
				self openMenu(game["menu_weapon_allies"]);
			else
				self openMenu(game["menu_weapon_axis"]);
		}
		firsttime++;
	
		self waittill("menuresponse");
		
		wait 0.2;
	}

	if(self.pers["team"] != "allies" && self.pers["team"] != "axis")
	{
		maps\mp\_utility::error("Team not set correctly on spawning player " + self + " " + self.pers["team"]);
	}

	if (!isDefined(deathpenalty))
		deathpenalty = 0;

	if (deathpenalty == 1 && game["mode"] == "match")
	{
		respawnpenalty = getcvarint("scr_ctf_respawnpenalty");
		if (respawnpenalty > 0)
		{
			self thread Create_HUD_Penalty(respawnpenalty);
		}
	}
	else
		respawnpenalty = 0;

	death_wait_time = level.death_wait_time + respawnpenalty;

	self thread stopwatch_start("respawn", death_wait_time);

	wait (death_wait_time);

	self thread spawnPlayer();
}

// ----------------------------------------------------------------------------------
//	SpawnPlayer
//
// 		spawns the player
// ----------------------------------------------------------------------------------
SpawnPlayer()
{
	checkSnipers();
	self notify("spawned");

	resettimeout();

	self.sessionteam = self.pers["team"];
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;
	
	// reset teamkiller flag
	self.teamkiller = 0;

	// make sure that the client compass is at the correct zoom specified by the level
	self setClientCvar("cg_hudcompassMaxRange", game["compass_range"]);

	self.sessionstate = "playing";
	
	// pick the appropriate spawn point
	if(self.pers["team"] == "allies")
	{
		base_spawn_name = "mp_uo_spawn_allies";
		secondary_spawn_name = "mp_uo_spawn_allies_secondary";
	}
	else if(self.pers["team"] == "axis")
	{
		base_spawn_name = "mp_uo_spawn_axis";
		secondary_spawn_name = "mp_uo_spawn_axis_secondary";
	}	
	spawnpoints = getentarray(base_spawn_name, "classname");
	
	// secondary spawn points are used after the first few seconds of the round
	if ( game["matchstarted"] && ((level.roundstarttime + 5000) < getTime()) )
	{
		secondary_spawns =  getentarray(secondary_spawn_name, "classname");
	
		for ( i = 0; i < secondary_spawns.size; i++ )
		{
			
			// if this is targeted by a trigger then it must be a objective spawn so do not just grab it unless that trigger is 
			// owned by this team
			if ( isdefined(secondary_spawns[i].targetname) )
			{
				targeter =  getent(secondary_spawns[i].targetname, "target");
				
				if ( isdefined( targeter ) && isdefined(targeter.team) && targeter.team != self.pers["team"] )
				{
					continue;
				}
			}
		
			spawnpoints = maps\mp\_util_mp_gmi::add_to_array(spawnpoints, secondary_spawns[i]);
		}
	}
	
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(spawnpoints);
	
	// if we could not get a spawn point then fall back to random
	if(!isDefined(spawnpoint))
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	// this is somewhat redundant now because we verify when the game starts that the spawn points are in
	// but what the hey it does not hurt
	if(isDefined(spawnpoint))
		spawnpoint maps\mp\gametypes\_spawnlogic::SpawnPlayer(self);
	else
		maps\mp\_utility::error("NO " + base_spawn_name + " SPAWNPOINTS IN MAP");
	
	self.spawned = true;
	if (level.rdyup != 1)
		self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;
	self.flag_held = 0;
	
	updateTeamStatus();
	
	if(!isDefined(self.pers["score"]))
		self.pers["score"] = 0;
	self.score = self.pers["score"];
	
	self.pers["rank"] = maps\mp\gametypes\_rank_gmi::DetermineBattleRank(self);
	self.rank = self.pers["rank"];
	
	if(!isDefined(self.pers["deaths"]))
		self.pers["deaths"] = 0;
	self.deaths = self.pers["deaths"];
	
	if(!isDefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_pam_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);
	
	self setClientCvar("cg_objectiveText", game["ctf_attacker_obj_text"]);
		
	// setup the head and status icons
	self setPlayerIcons();
	
	// Check to see if the player changed weapon class during round.
	if(isDefined(self.nextroundweapon))
	{
		self.pers["weapon"] = self.nextroundweapon;
		self.nextroundweapon = undefined;
	}

	// setup all the weapons
	self maps\mp\gametypes\_pam_loadout_gmi::PlayerSpawnLoadout();
	checkSnipers();

	self.usedweapons = false;
	thread maps\mp\gametypes\_pam_teams::watchWeaponUsage();

	// setup the hud rank indicator
	self thread maps\mp\gametypes\_rank_gmi::RankHudInit();
}

// ----------------------------------------------------------------------------------
//	SpawnSpectator
//
// 		spawns a spectator
// ----------------------------------------------------------------------------------
SpawnSpectator(origin, angles)
{
	checkSnipers();
	self notify("spawned");

	resettimeout();

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;

	if(self.pers["team"] == "spectator" && level.rdyup != 1)
		self.statusicon = "";

	maps\mp\gametypes\_pam_teams::SetSpectatePermissions();

	if(isDefined(origin) && isDefined(angles))
	{
		self spawn(origin, angles);
	}
	else
	{
		spawnpointname = "mp_ctf_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isDefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}

	updateTeamStatus();

	self.usedweapons = false;

	self setClientCvar("cg_objectiveText", game["ctf_spectator_obj_text"]);
}

// ----------------------------------------------------------------------------------
//	SpawnIntermission
//
// 		spawns an intermission player (kinda like a spectator but different)
// ----------------------------------------------------------------------------------
SpawnIntermission()
{
	checkSnipers();
	self notify("spawned");
	
	resettimeout();

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;

	spawnpointname = "mp_ctf_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
		
}

// ----------------------------------------------------------------------------------
//	startGame
//
// 		starts the game
// ----------------------------------------------------------------------------------
startGame()
{
	checkSnipers();
	seconds = 0;

	level.starttime = getTime();
	thread startRound();

	if ( (level.teambalance > 0) && (!game["BalanceTeamsNextRound"]) )
		level thread maps\mp\gametypes\_pam_teams::TeamBalance_Check_Roundbased();

	for(;;)
	{
		checkTimeLimit();
		
		if (!level.roundstarted && (!level.roundended))
		{
			if (seconds > 60)
			{	// we havent even started, so count down the timelimit so the map rotation continues
				game["timepassed"] += 1;		// add a minute to the timer
				seconds -= 60;						// dec the seconds
			}
		} else
		{
			seconds = 0;	// round is playing, so prevent idle counter
		}
		
		wait 1;
		seconds++;
	}
}

// ----------------------------------------------------------------------------------
//	startRound
//
// 		Starts the round.  Initializes all of the players
// ----------------------------------------------------------------------------------
startRound()
{	
	// round does not start until the match starts
	if ( !game["matchstarted"] )
		return;
	
	checkSnipers();

	// Turn off warmup mode
	level.warmup = 0;

	level.roundstarted = true;
	level.roundended = false;
	level.allowflagactions = true;

	if (getcvarint("scr_ctf_showscores") > 0)
		thread Persistant_Scoreboard();
	
	thread maps\mp\gametypes\_pam_teams::sayMoveIn();

	level.allies_cap_count = 0;
	level.axis_cap_count = 0;
	
	level.roundstarttime = getTime();
	level.allies_cap_count = 0;  
	level.axis_cap_count = 0;  

	if (game["dolive"] == 1)
	{
		thread Create_HUD_Live();
		game["dolive"] = 0;
	}


	// if the round length is zero then no clock or timer
	if ( level.roundlength == 0 )
		return;
		
	if (isDefined(level.clock))
		level.clock destroy();
		
	level.clock = newHudElem();
	level.clock.x = 56;
	level.clock.y = 365;

	level.clock.alignX = "center";
	level.clock.alignY = "middle";
	level.clock.font = "bigfixed";
	level.clock setTimer(level.roundlength * 60);

	level.clock.color = (1, 1, 1);
	level.clock.alpha = 0.6;
	wait(level.roundlength * 60);
	
	if(level.roundended)
		return;

	thread Create_HUD_TimeExp();
	//announcement(&"GMI_CTF_TIMEEXPIRED");
	
	if (getCvar("scr_ctf_scoringmethod") == "round")
	{
		if(level.allies_cap_count == level.axis_cap_count)
		{
			if (level.allowrounddraw == 0)
			{
				cnt = 0;
				while (level.allies_cap_count == level.axis_cap_count)
				{
					Create_HUD_SuddenDeath();

					wait 1;
				}

				if(isdefined(level.suddendeath))
					level.suddendeath destroy();
			}

			level thread endRound("draw");
			
		}
		
		if ( level.allies_cap_count > level.axis_cap_count )
		{
			level thread endRound("allies");
		}
		else
		{
			level thread endRound("axis");
		}
	}

	if (!level.allowmatchtie && (game["roundsplayed"] + 1) == level.endround)
	{
		AlliesTempScore = game["alliesmatchscore"] + level.allies_cap_count;
		AxisTempScore = game["axismatchscore"] + level.axis_cap_count;

		if (AlliesTempScore == AxisTempScore)
		{
			alliescount = level.allies_cap_count;
			axiscount = level.axis_cap_count;

			while (alliescount == level.allies_cap_count && axiscount == level.axis_cap_count)
			{
				if(!isdefined(level.suddendeath))
					Create_HUD_SuddenDeath();

				wait 1;
			}

			if(isdefined(level.suddendeath))
				level.suddendeath destroy();
		}
	}

	level.allowflagactions = false;
	level thread endRound("none");

}

// ----------------------------------------------------------------------------------
//	CheckMatchStart
//
// 		Checks to see if the round is ready to start.  Starts round if ready.
// ----------------------------------------------------------------------------------
CheckMatchStart()
{
	updateTeamStatus();

	checkSnipers();
	oldvalue["teams"] = level.exist["teams"];
	level.exist["teams"] = false;

	// If teams currently exist
	if(getCvarInt("scr_debug_ctf") != 1)
	{
		if(level.exist["allies"] && level.exist["axis"])
			level.exist["teams"] = true;
	}
	else
	{
		level.exist["teams"] = true;
	}

	// If teams previously did not exist and now they do
	if(!oldvalue["teams"] && level.exist["teams"] && !level.roundstarted)
	{
		if(!game["matchstarting"])
		{			
			level notify("kill_endround");
			level.roundended = false;
			thread endRound("reset");
		}
	}
}

// ----------------------------------------------------------------------------------
//	resetScores
//
// 		Resets all of the scores
// ----------------------------------------------------------------------------------
resetScores()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player.pers["score"] = 0;
		player.pers["deaths"] = 0;
	}

	game["alliedscore"] = 0;
	setTeamScore("allies", game["alliedscore"]);
	game["axisscore"] = 0;
	setTeamScore("axis", game["axisscore"]);
	
	if (level.battlerank)
	{
		maps\mp\gametypes\_rank_gmi::ResetPlayerRank();
	}
}

// ----------------------------------------------------------------------------------
//	endRound
//
// 		Ends the round
// ----------------------------------------------------------------------------------
endRound(roundwinner)
{
	// Stop all killing
	level.warmup = 1;

	level endon("kill_endround");

	if(level.roundended)
		return;
	if ( game["matchstarted"] )
		level.roundended = true;
 
 	if (roundwinner == "abort")
		game["matchstarted"] = false;
	level.roundstarted = false;
	
	// End threads and remove related hud elements and objectives
	level notify("round_ended");

	if(roundwinner == "allies")
	{
		//announcement(&"GMI_CTF_ALLIEDMISSIONACCOMPLISHED");

		if(game["halftimeflag"] == "1")
		{
			game["round2alliesscore"]++;
			halftimeflag = game["halftimeflag"];
		}
		else if(game["matchstarted"])
			game["round1alliesscore"]++;
		
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			players[i] thread Victory_PlaySounds(game["sound_allies_victory_vo"],game["sound_allies_victory_music"]);
		}
		//level thread Victory_DisplayImage(game["hud_allies_victory_image"]);
	}
	else if(roundwinner == "axis")
	{
		//announcement(&"GMI_CTF_AXISMISSIONACCOMPLISHED");

		if(game["halftimeflag"] == "1")
		{
			game["round2axisscore"]++;
			halftimeflag = game["halftimeflag"];
		}
		else if(game["matchstarted"])
			game["round1axisscore"]++;

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			players[i] thread Victory_PlaySounds(game["sound_axis_victory_vo"],game["sound_axis_victory_music"]);
		}
		//level thread Victory_DisplayImage(game["hud_axis_victory_image"]);
	}
	else if(roundwinner == "draw" || roundwinner == "abort")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			players[i] playLocalSound(game["sound_round_draw_vo"]);
		}
	}

	if (roundwinner == "none" || roundwinner == "score")
	{
		if(game["halftimeflag"] == "1")
		{
			game["round2alliesscore"] = game["round2alliesscore"] + level.allies_cap_count;
			game["round2axisscore"] = game["round2axisscore"] + level.axis_cap_count;
		}
		else if(game["matchstarted"])
		{
			game["round1alliesscore"] = game["round1alliesscore"] + level.allies_cap_count;
			game["round1axisscore"] = game["round1axisscore"] + level.axis_cap_count;
		}

		game["axismatchscore"] = game["round2alliesscore"] + game["round1axisscore"];
		game["alliesmatchscore"] = game["round1alliesscore"] + game["round2axisscore"];

		if (roundwinner == "score")
		{
			if(game["alliedscore"] == game["axisscore"] && getcvar("g_ot") == "1" )  // have a tie and overtime mode is on
			{
				Prepare_map_Tie();

				if (level.randomsides == 1)
					Choose_Random_Side();
			}
			else
				setCvar("g_ot_active", "0");

			Create_HUD_Matchover();
			
			Create_HUD_TeamWin();

			Create_HUD_Header();
				
			Create_HUD_Scoreboard();

			if(game["alliedscore"] == game["axisscore"] && getcvar("scr_usetouches") != "0" )
					Create_HUD_Touches();

			wait 10;

			Destroy_HUD_Header();

			Destroy_HUD_Scoreboard();

			Destroy_HUD_TeamWin();

			if(isdefined(level.matchover))
				level.matchover destroy();

			if(level.mapended)
				return;

			level.mapended = true;

			endMap();
		}

	}

	winners = "";
	losers = "";

	if(roundwinner == "allies" && !level.mapended)
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			lpGuid = players[i] getGuid();
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				winners = (winners + ";" + lpGuid + ";" + players[i].name);
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				losers = (losers + ";" + lpGuid + ";" + players[i].name);
		}
		logPrint("W;allies" + winners + "\n");
		logPrint("L;axis" + losers + "\n");
	}
	else if(roundwinner == "axis" && !level.mapended)
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			lpGuid = players[i] getGuid();
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				winners = (winners + ";" + lpGuid + ";" + players[i].name);
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				losers = (losers + ";" + lpGuid + ";" + players[i].name);
		}
		logPrint("W;axis" + winners + "\n");
		logPrint("L;allies" + losers + "\n");
	}
	
	if(game["matchstarted"])
	{
		if (level.countdraws == 1)
			game["roundsplayed"]++;
		else if(roundwinner != "draw")
			game["roundsplayed"]++;

		checkMatchRoundLimit();
		checkMatchScoreLimit();
	}

	if (roundwinner != "reset")
	{
		time = getCvarInt("scr_ctf_endrounddelay");
		
		if ( time < 1 )
			time = 1;
			
		wait(time);		
	}
	
	game["timepassed"] = game["timepassed"] + ((getTime() - level.starttime) / 1000) / 60.0;
	println("timepassed " + game["timepassed"]);
	
	// call these checks before calling the score resetting
	checkTimeLimit();
	
	if(!game["matchstarted"] && roundwinner == "reset" )
	{
		thread resetScores();
		game["roundsplayed"] = 0;
		game["firsthalfready"] = 0;
	}
	
	if(level.mapended)
		return;

	// if the teams are not full then abort
	if ( !(level.exist["axis"] && level.exist["allies"]) && !getcvarint("scr_debug_ctf") )
	{
		if (isDefined(level.clock))
			level.clock destroy();

		level.clock = undefined;
		return;
	}
	
	//WORM
	if( getcvar("g_roundwarmuptime") != "0" && game["roundsplayed"] != "0" && !level.hithalftime)
	{	
		//display scores

		Create_HUD_Header();

		Create_HUD_Scoreboard();

		//Create_HUD_NextRound();

		warmup = getcvarint("g_roundwarmuptime");
		for(i = warmup; i > 0; i--)
		{
			wait 1;
		}

		/* Remove match countdown text */
		
		Destroy_HUD_Header();

		Destroy_HUD_Scoreboard();

		Destroy_HUD_NextRound();

	}

	while (level.hithalftime)
	{
		wait 1;
	}

	thread RestartMap();
}

// ----------------------------------------------------------------------------------
//	RestartMap
//
// 		Displays the match starting message and a timer.  Then when the timer
//		is done the map is restarted.
// ----------------------------------------------------------------------------------
RestartMap( )
{
	level endon("kill_startround");
	
	// if the match is already starting then do not restart
	if (game["matchstarting"] || level.mapended)
		return;
		
	game["matchstarting"] = true;

	if(game["firsthalfready"] == 0)
	{
		game["readyup"] = 1;
		Create_HUD_Header();

		if( game["mode"] == "match")
		{
			Ready_UP();

			if (getcvar("sv_consolelock") )
				setCvar("sv_disableClientConsole", "1");

			Create_HUD_PlayersReady("1");

			wait 5;
		}

		else
			wait 3;

		Destroy_HUD_Header();

		checkSnipers();

		game["firsthalfready"] = 1;

		if(isdefined(level.allready))
			level.allready destroy();
		if(isdefined(level.half1start))
			level.half1start destroy();
		if (isdefined(level.demosrecording))
			level.demosrecording destroy();
		//end readyup

		clearscores = 1;
	}

	if (game["startingsecondhalf"] == 1)
	{
		game["startingsecondhalf"] = 0;

		game["readyup"] = 1;
		Create_HUD_Header();

		if( game["mode"] == "match")
		{
			Ready_UP();

			Create_HUD_PlayersReady("2");

			wait 5;

			if(isdefined(level.allready))
				level.allready destroy();
			if(isdefined(level.half2start))
				level.half2start destroy();
			if(isdefined(level.halftime))
				level.halftime destroy();

			Destroy_HUD_Scoreboard();
		}

		else
			wait 1;
			
		Destroy_HUD_Header();

		if (getCvarint("scr_ctf_clearscoreeachhalf") == 1 )
			clearscores = 1;
	}

	//level thread maps\mp\_util_mp_gmi::make_permanent_announcement(&"GMI_CTF_MATCHSTARTING", "cleanup match starting");			

	time = getCvarInt("scr_ctf_startrounddelay");
	
	if ( time < 1 )
		time = 1;

	if ( isDefined(level.victory_image) )
	{
		level.victory_image destroy();
		level.victory_image = undefined;
	}
	
	// give all of the players clocks to count down until the round starts
	Create_HUD_RoundStart();

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if ( isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue;
			
		player stopwatch_start("match_start", time);
	}
	
	wait (time);

	Destroy_HUD_RoundStart();

	if ( level.mapended )
		return;

	game["readyup"] = 0;
	game["matchstarted"] = true;
	game["matchstarting"] = false;
	
	if ( getCvarint("scr_ctf_clearscoreeachround") == 1 && !level.mapended )
	{
		thread resetScores();
	}

	// Clear scores if needed
	if ( isdefined(clearscores) )
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			player.pers["score"] = 0;
			player.pers["deaths"] = 0;

			if (level.battlerank)
				maps\mp\gametypes\_rank_gmi::ResetPlayerRank();
		}
	}

	level notify("cleanup match starting");

	// Allow killing now

	map_restart(true);
}

// ----------------------------------------------------------------------------------
//	endMap
//
// 		Ends the map
// ----------------------------------------------------------------------------------
endMap()
{
	game["state"] = "intermission";
	
	level notify("intermission");
	level notify("kill_startround");

	if(game["alliedscore"] == game["axisscore"])
	{
		endRound("draw");
		text = &"MPSCRIPT_THE_GAME_IS_A_TIE";
	}
	else if(game["alliedscore"] > game["axisscore"])
	{
		endRound("allies");
		text = &"MPSCRIPT_ALLIES_WIN";
	}
	else
	{
		endRound("axis");
		text = &"MPSCRIPT_AXIS_WIN";
	}

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		player closeMenu();
		player setClientCvar("g_scriptMainMenu", "main");
		player setClientCvar("cg_objectiveText", text);
		player SpawnIntermission();
	}

	if (game["mode"] == "match")
		maps\mp\gametypes\_pam_utilities::Prevent_Map_Change();

	// Enable all Client Consoles
	setCvar("sv_disableClientConsole", "0");

	wait 7;

	exitLevel(false);
}

// ----------------------------------------------------------------------------------
//	checkTimeLimit
//
// 		Checks to see if the time limit has been hit and ends the map.
// ----------------------------------------------------------------------------------
checkTimeLimit()
{
	if(level.timelimit <= 0)
		return;

	// never abruptly end a round in progress
	if (level.roundstarted)
		return;

	if(game["timepassed"] < level.timelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	iprintln(&"MPSCRIPT_TIME_LIMIT_REACHED");
	level thread endMap();
	
	// dont return immediatly need time for the calling loop to be killed
	wait(1);
}



checkMatchRoundLimit()
{

	/*  Is it a round-base halftime? */
	if (level.halfround != 0  && game["halftimeflag"] == "0")
	{
		if(game["roundsplayed"] >= level.halfround)
		{   /*scorelimit if */

			game["halftimeflag"] = "1";
			level.hithalftime = 1;
			level.allowautobalance = false;

			//display scores

			Create_HUD_Header();

			Create_HUD_Halftime();
			
			Create_HUD_Scoreboard();
			
			wait 1;

			Create_HUD_TeamSwap();
		
			/* Remove match countdown text */
		
			wait 7;

			if (getcvar("sv_scoreboard") == "big" || getcvar("sv_scoreboard") == "small")
				Destroy_HUD_Scoreboard();

			wait .5;

			if(isdefined(level.switching))
				level.switching destroy();
			if(isdefined(level.switching2))
				level.switching2 destroy();
		
		
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{ 
				if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "axis") )
				{
					players[i].pers["team"] = "allies";
					axissavedmodel = players[i].pers["savedmodel"];
				}
				else if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "allies") )
				{
					players[i].pers["team"] = "axis";
					alliedsavedmodel = players[i].pers["savedmodel"];
				}

				//drop weapons and make spec
				player = players[i];
				players[i].pers["weapon"] = undefined;
				players[i].pers["weapon1"] = undefined;
				players[i].pers["weapon2"] = undefined;
				players[i].pers["spawnweapon"] = undefined;
				player.sessionstate = "spectator";
				player.spectatorclient = -1;
				player.archivetime = 0;
				player.reflectdamage = undefined;


				//change headicons
				if(level.drawfriend)
				{
					if(player.pers["team"] == "allies")
					{
						player.headicon = game["headicon_allies"];
						player.headiconteam = "allies";
					}
					else
					{
						player.headicon = game["headicon_axis"];
						player.headiconteam = "axis";
					}
				}
			}  // end for loop

			checkSnipers();
			
			thread maps\mp\_pam_tankdrive_gmi::PAM_deactivate_tanks();

			//switch player models
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{ 
				if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "axis") )
					 players[i].pers["savedmodel"] = axissavedmodel;
				else if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "allies") )
					players[i].pers["savedmodel"] = alliedsavedmodel;

				//pull up menus
				player = players[i];
				player closeMenu();
				player setClientCvar("g_scriptMainMenu", "main");
				//player spawnIntermission();
				if(player.pers["team"] == "allies")
					player setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
				else
					player setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
				if(player.pers["team"] == "allies")
					player openMenu(game["menu_weapon_allies"]);
				else if(player.pers["team"] == "axis")
					player openMenu(game["menu_weapon_axis"]);
			}

			//switch scores
			axistempscore = game["axisscore"];
			game["axisscore"] = game["alliedscore"];
			setTeamScore("axis", game["alliedscore"]);
			game["alliedscore"] = axistempscore;
			setTeamScore("allies", game["alliedscore"]);

			// switch touches
			axistempscore = game["axistouches"];
			game["axistouches"] = game["alliestouches"];
			game["alliestouches"] = axistempscore;

			/* DO READY UP */
			game["startingsecondhalf"] = 1;

			level notify("kill_matchroundchecks");
			level notify("halftimefinished");
			level.hithalftime = 0;

			thread RestartMap();

			return;

		}  /*scorelimit if */
	}

	/*  End of Map Roundlimit! */
	if (level.matchround != 0)
	{
		if (game["roundsplayed"] >= level.matchround)
		{
			if(game["alliedscore"] == game["axisscore"] && getcvar("g_ot") == "1")  // have a tie and overtime mode is on
			{
				Prepare_map_Tie();

				if (level.randomsides == 1)
					Choose_Random_Side();
			}
			else
				setCvar("g_ot_active", "0");

			Create_HUD_Matchover();

			Create_HUD_TeamWin();

			Create_HUD_Header();
				
			Create_HUD_Scoreboard();

			if(game["alliedscore"] == game["axisscore"] && getcvar("scr_usetouches") != "0" )
				Create_HUD_Touches();

			wait 10;

			Destroy_HUD_Header();

			Destroy_HUD_Scoreboard();

			Destroy_HUD_TeamWin();

			if(isdefined(level.matchover))
				level.matchover destroy();

			if(level.mapended)
				return;

			level.mapended = true;

			endMap();
		}
	}
}

checkRoundScoreLimit()
{
	if(level.warmup == 1)
		return;

	/* Is it a score-based Halftime? */
	if(game["halftimeflag"] == "0" && level.halfscore != 0)
	{
		if(game["alliedscore"] >= level.halfscore || game["axisscore"] >= level.halfscore)
		{ //level.halfscore if

			game["halftimeflag"] = "1";
			level.hithalftime = 1;
			level.allowautobalance = false;

			//display scores

			Create_HUD_Header();

			Create_HUD_Halftime();
			
			Create_HUD_Scoreboard();
			
			wait 1;

			Create_HUD_TeamSwap();
		
			/* Remove match countdown text */
		
			wait 7;

			if (getcvar("sv_scoreboard") == "big" || getcvar("sv_scoreboard") == "small")
				Destroy_HUD_Scoreboard();

			wait .5;

			if(isdefined(level.switching))
				level.switching destroy();
			if(isdefined(level.switching2))
				level.switching2 destroy();
		
		
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{ 
				if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "axis") )
				{
					players[i].pers["team"] = "allies";
					axissavedmodel = players[i].pers["savedmodel"];
				}
				else if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "allies") )
				{
					players[i].pers["team"] = "axis";
					alliedsavedmodel = players[i].pers["savedmodel"];
				}

				//drop weapons and make spec
				player = players[i];
				players[i].pers["weapon"] = undefined;
				players[i].pers["weapon1"] = undefined;
				players[i].pers["weapon2"] = undefined;
				players[i].pers["spawnweapon"] = undefined;
				player.sessionstate = "spectator";
				player.spectatorclient = -1;
				player.archivetime = 0;
				player.reflectdamage = undefined;


				//change headicons
				if(level.drawfriend)
				{
					if(player.pers["team"] == "allies")
					{
						player.headicon = game["headicon_allies"];
						player.headiconteam = "allies";
					}
					else
					{
						player.headicon = game["headicon_axis"];
						player.headiconteam = "axis";
					}
				}
			}  // end for loop

			checkSnipers();

			thread maps\mp\_pam_tankdrive_gmi::PAM_deactivate_tanks();

			//switch player models
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{ 
				if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "axis") )
					 players[i].pers["savedmodel"] = axissavedmodel;
				else if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "allies") )
					players[i].pers["savedmodel"] = alliedsavedmodel;

				//pull up menus
				player = players[i];
				player closeMenu();
				player setClientCvar("g_scriptMainMenu", "main");
				//player spawnIntermission();
				if(player.pers["team"] == "allies")
					player setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
				else
					player setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
				if(player.pers["team"] == "allies")
					player openMenu(game["menu_weapon_allies"]);
				else if(player.pers["team"] == "axis")
					player openMenu(game["menu_weapon_axis"]);
			}

			//switch scores
			axistempscore = game["axisscore"];
			game["axisscore"] = game["alliedscore"];
			setTeamScore("axis", game["alliedscore"]);
			game["alliedscore"] = axistempscore;
			setTeamScore("allies", game["alliedscore"]);

			// switch touches
			axistempscore = game["axistouches"];
			game["axistouches"] = game["alliestouches"];
			game["alliestouches"] = axistempscore;

			/* DO READY UP */
			game["startingsecondhalf"] = 1;

			level notify("kill_matchroundchecks");
			level notify("halftimefinished");
			level.hithalftime = 0;

			thread RestartMap();

			return;

		}  /*scorelimit if */
	}

	/* 2nd-Half Score Limit Check */
	if (level.matchscore2 != 0)
	{
		if ( game["round2axisscore"] >= level.matchscore2 || game["round2alliesscore"] >= level.matchscore2)
		{

			if(game["alliedscore"] == game["axisscore"] && getcvar("g_ot") == "1")  // have a tie and overtime mode is on
			{
				Prepare_map_Tie();

				if (level.randomsides == 1)
					Choose_Random_Side();
			}
			else
				setCvar("g_ot_active", "0");

			Create_HUD_Matchover();

			Create_HUD_TeamWin();

			Create_HUD_Header();
				
			Create_HUD_Scoreboard();

			if(game["alliedscore"] == game["axisscore"] && getcvar("scr_usetouches") != "0" )
				Create_HUD_Touches();

			wait 10;

			Destroy_HUD_Header();

			Destroy_HUD_Scoreboard();

			Destroy_HUD_TeamWin();

			if(isdefined(level.matchover))
				level.matchover destroy();

			if(level.mapended)
				return;

			level.mapended = true;

			endMap();
		}
	}

	/* Match Score Check */
	if (level.matchscore1 != 0)
	{
		if(game["alliedscore"] < level.matchscore1 && game["axisscore"] < level.matchscore1)
			return;

		endRound("score");
	}

	return;
}

checkMatchScoreLimit()
{
	if(level.warmup == 1)
		return;

	if (level.scoringmethod != "round")
		return;

	/* Is it a score-based Halftime? */
	if(game["halftimeflag"] == "0" && level.halfscore != 0)
	{
		if(game["alliedscore"] >= level.halfscore || game["axisscore"] >= level.halfscore)
		{ //level.halfscore if	
			game["halftimeflag"] = "1";
			level.allowautobalance = false;

			//display scores
			Create_HUD_Header();

			Create_HUD_Halftime();
			
			Create_HUD_Scoreboard();
			
			wait 1;

			Create_HUD_TeamSwap();
		
			/* Remove match countdown text */
		
			wait 7;

			if (getcvar("sv_scoreboard") == "big" || getcvar("sv_scoreboard") == "small")
				Destroy_HUD_Scoreboard();		

			wait .5;

			if(isdefined(level.switching))
				level.switching destroy();
			if(isdefined(level.switching2))
				level.switching2 destroy();
		
		
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{ 
				if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "axis") )
				{
					players[i].pers["team"] = "allies";
					axissavedmodel = players[i].pers["savedmodel"];
				}
				else if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "allies") )
				{
					players[i].pers["team"] = "axis";
					alliedsavedmodel = players[i].pers["savedmodel"];
				}

				//drop weapons and make spec
				player = players[i];
				players[i].pers["weapon"] = undefined;
				players[i].pers["weapon1"] = undefined;
				players[i].pers["weapon2"] = undefined;
				players[i].pers["spawnweapon"] = undefined;
				player.sessionstate = "spectator";
				player.spectatorclient = -1;
				player.archivetime = 0;
				player.reflectdamage = undefined;

	
				//change headicons
				if(level.drawfriend)
				{
					if(player.pers["team"] == "allies")
					{
						player.headicon = game["headicon_allies"];
						player.headiconteam = "allies";
					}
					else
					{
						player.headicon = game["headicon_axis"];
						player.headiconteam = "axis";
					}
				}
			}  // end for loop

			checkSnipers();

			thread maps\mp\_pam_tankdrive_gmi::PAM_deactivate_tanks();

			//switch player models
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{ 
				if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "axis") )
					 players[i].pers["savedmodel"] = axissavedmodel;
				else if ( (isdefined (players[i].pers["team"])) && (players[i].pers["team"] == "allies") )
					players[i].pers["savedmodel"] = alliedsavedmodel;

				//pull up menus
				player = players[i];
				player closeMenu();
				player setClientCvar("g_scriptMainMenu", "main");
				//player spawnIntermission();
				if(player.pers["team"] == "allies")
					player setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
				else
					player setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
				if(player.pers["team"] == "allies")
					player openMenu(game["menu_weapon_allies"]);
				else if(player.pers["team"] == "axis")
					player openMenu(game["menu_weapon_axis"]);
			}

			//switch scores
			axistempscore = game["axisscore"];
			game["axisscore"] = game["alliedscore"];
			setTeamScore("axis", game["alliedscore"]);
			game["alliedscore"] = axistempscore;
			setTeamScore("allies", game["alliedscore"]);

			// switch touches
			axistempscore = game["axistouches"];
			game["axistouches"] = game["alliestouches"];
			game["alliestouches"] = axistempscore;

			/* DO READY UP */
			game["startingsecondhalf"] = 1;

			level notify("kill_matchroundchecks");
			level notify("halftimefinished");
			level.hithalftime = 0;

			thread RestartMap();

			return;

		}  /*scorelimit if */
	}


	/* 2nd-Half Score Limit Check */
	if (level.matchscore2 != 0)
	{
		if ( game["round2axisscore"] >= level.matchscore2 || game["round2alliesscore"] >= level.matchscore2)
		{

			if(game["alliedscore"] == game["axisscore"] && getcvar("g_ot") == "1")  // have a tie and overtime mode is on
			{
				Prepare_map_Tie();

				if (level.randomsides == 1)
					Choose_Random_Side();
			}
			else
				setCvar("g_ot_active", "0");

			Create_HUD_Matchover();

			Create_HUD_TeamWin();

			Create_HUD_Header();
				
			Create_HUD_Scoreboard();

			if(game["alliedscore"] == game["axisscore"] && getcvar("scr_usetouches") != "0" )
				Create_HUD_Touches();

			wait 10;

			Destroy_HUD_Header();

			Destroy_HUD_Scoreboard();

			Destroy_HUD_TeamWin();

			if(isdefined(level.matchover))
				level.matchover destroy();

			if(level.mapended)
				return;

			level.mapended = true;

			endMap();
		}
	}

	/* Match Score Check */
	if (level.matchscore1 != 0)
	{
		if(game["alliedscore"] < level.matchscore1 && game["axisscore"] < level.matchscore1)
		{
			level notify("kill_matchchecks");
			return;
		}

		setCvar("g_ot_active", "0");

		if(game["alliedscore"] == game["axisscore"] && getcvar("g_ot") == "1")  // have a tie and overtime mode is on
		{
			Prepare_map_Tie();

			if (level.randomsides == 1)
				Choose_Random_Side();
		}
		else
			setCvar("g_ot_active", "0");

		Create_HUD_Matchover();
		
		Create_HUD_TeamWin();

		Create_HUD_Header();
			
		Create_HUD_Scoreboard();

		if(game["alliedscore"] == game["axisscore"] && getcvar("scr_usetouches") != "0" )
				Create_HUD_Touches();

		wait 10;

		Destroy_HUD_Header();

		Destroy_HUD_Scoreboard();

		Destroy_HUD_TeamWin();

		if(isdefined(level.matchover))
			level.matchover destroy();

		if(level.mapended)
			return;

		level.mapended = true;

		endMap();
	}

	return;
}


// ----------------------------------------------------------------------------------
//	checkScoreLimit
//
// 		Checks to see if the score limit has been hit and ends the map.
// ----------------------------------------------------------------------------------
checkScoreLimit()
{
	if(level.scorelimit <= 0)
		return;
	
	if(game["alliedscore"] < level.scorelimit && game["axisscore"] < level.scorelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	iprintln(&"MPSCRIPT_SCORE_LIMIT_REACHED");
	level thread endMap();

	// dont return immediatly need time for the calling loop to be killed
	wait(1);
}

// ----------------------------------------------------------------------------------
//	checkRoundLimit
//
// 		Checks to see if the round limit has been hit and ends the map.
// ----------------------------------------------------------------------------------
checkRoundLimit()
{
	if(level.roundlimit <= 0)
		return;
	
	if(game["roundsplayed"] < level.roundlimit)
		return;
	
	if(level.mapended)
		return;
	level.mapended = true;

	iprintln(&"MPSCRIPT_ROUND_LIMIT_REACHED");
	thread endMap();

	// dont return immediatly need time for the calling loop to be killed
	wait(1);
}

// ----------------------------------------------------------------------------------
//	updateGametypeCvars
//
// 		Checks for changes in various cvars
// ----------------------------------------------------------------------------------
updateGametypeCvars()
{
	level endon("PAMRestart");
	enabling = 0;

	for(;;)
	{
		// WORM PAM Disable Check
		pamenable = getCvarint("svr_pamenable");
		if (pamenable != level.pamenable && pamenable == 0)
		{
			enabling = 1;
			level.pamenable = pamenable;
			//iprintln("^1PAM has been turned OFF!");
			//iprintln("^1map_restart is required");

			maps\mp\gametypes\_pam_utilities::StopPAMUO();
			level notify("PAMRestart");
		}

		league = getCvar("pam_mode");
		if(league != level.league && !enabling)
		{
			ValidPamMode = maps\mp\gametypes\_pam_utilities::Check_PAM_Modes(league);
			if (ValidPamMode)
			{
				wait .1;
				thread maps\mp\gametypes\_pam_utilities::PAMRestartMap();
				level notify("PAMRestart");
			}
			else
			{
				iprintln("^3PAM Mode has been changed to ^1" + league);
				iprintln("^1" + league + " ^3mode is not valid!");
				iprintln("^3map_restart will return you to pub mode");
			}
			level.league = league;
		}

		// WORM CVAR Security Checks & Announcements
		pure = getCvarInt("sv_pure");
		if (pure != level.pure)
		{
			level.pure = getCvarInt("sv_pure");
			if (level.pure == 1)
				iprintln("^2SV_PURE turned ON!");
			else
				iprintln("^1SV_PURE turned OFF!");
		}

		scoringmethod = getCvar("scr_ctf_scoringmethod");
		if (scoringmethod != level.scoringmethod)
		{
			if (scoringmethod == "round")
			{
				iprintln("^3Scoring Method changed to ^1round");
			}
			else
			{
				setcvar("scr_ctf_scoringmethod", "captures");
				scoringmethod = "captures";
				iprintln("^3Scoring Method changed to ^1captures");
			}
			level.scoringmethod = scoringmethod;
		}

		clearscoreathalf = getcvarInt("scr_ctf_clearscoreeachhalf");
		if (clearscoreathalf != level.clearscoreeachhalf)
		{
			level.clearscoreeachhalf = clearscoreathalf;
			if (clearscoreathalf == 0)
				iprintln("^1Clear Score Each Half turned OFF!");
			else
				iprintln("^2Clear Score Each Half turned ON!");
		}

		allowrounddraw = getcvarInt("scr_ctf_allowrounddraw");
		if (allowrounddraw != level.allowrounddraw)
		{
			level.allowrounddraw = allowrounddraw;
			if (allowrounddraw == 0)
				iprintln("^1Round Draws turned OFF!");
			else
				iprintln("^2Round Draws turned ON!");
		}

		allowmatchtie = getcvarInt("scr_ctf_allowmatchtie");
		if (allowmatchtie != level.allowmatchtie)
		{
			level.allowmatchtie = allowmatchtie;
			if (allowmatchtie == 0)
				iprintln("^1Match Ties NOT allowed!");
			else
				iprintln("^2Match Ties allowed!");
		}

		vote = getCvarInt("g_allowVote");
		if(vote != level.vote)
		{
			level.vote = getCvarInt("g_allowVote");
			if(level.vote == 0)
				iprintln("^1Voting turned OFF!");
			else
				iprintln("^2Voting turned ON!");
		}

		drawfriend = getCvarFloat("scr_drawfriend");
		battlerank = getCvarint("scr_battlerank");
		if(level.battlerank != battlerank || level.drawfriend != drawfriend)
		{
			level.drawfriend = drawfriend;
			level.battlerank = battlerank;
			
			// battle rank has precidence over draw friend
			if(level.battlerank)
			{
				// for all living players, show the appropriate headicon
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					// make sure we do not do this if the player is carrying the flag
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing" && !isDefined(player.hasflag))
					{
						// setup the hud rank indicator
						player thread maps\mp\gametypes\_rank_gmi::RankHudInit();

						player.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(player);
						
						if ( level.drawfriend )
						{
							player.headicon = maps\mp\gametypes\_rank_gmi::GetRankHeadIcon(player);
							player.headiconteam = player.pers["team"];
							iprintln("^2Draw Friend turned ON!");
						}
						else
						{
							player.headicon = "";
							iprintln("^1Draw Friend turned OFF!");
						}
					}
				}
			}
			else if(level.drawfriend)
			{
				// for all living players, show the appropriate headicon
				iprintln("^2Draw Friend turned ON!");
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					// make sure we do not do this if the player is carrying the flag
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing" && !isDefined(player.hasflag))
					{
						if(player.pers["team"] == "allies")
						{
							player.headicon = game["headicon_allies"];
							player.headiconteam = "allies";
				
						}
						else
						{
							player.headicon = game["headicon_axis"];
							player.headiconteam = "axis";
						}
						player.statusicon = "";
					}
				}
			}
			else
			{
				iprintln("^1Draw Friend turned OFF!");
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					// make sure we do not do this if the player is carrying the flag
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing" && !isDefined(player.hasflag))
					{
						player.headicon = "";
					}
				}
			}
		}

		timelimit = getCvarFloat("scr_ctf_timelimit");
		if(level.timelimit != timelimit)
		{
			if(timelimit > 1440)
			{
				timelimit = 1440;
				setCvar("scr_ctf_timelimit", "1440");
			}
			
			level.timelimit = timelimit;
			setCvar("ui_ctf_timelimit", level.timelimit);
			iprintln("^3Time Limit ^7changed to ^3" + timelimit);
		}

		scorelimit = getCvarInt("scr_ctf_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;
			setCvar("ui_ctf_scorelimit", level.scorelimit);
			iprintln("^3Score Limit ^7changed to ^3" + scorelimit);
		}

		roundlimit = getCvarInt("scr_ctf_roundlimit");
		if(level.roundlimit != roundlimit)
		{
			level.roundlimit = roundlimit;
			setCvar("ui_ctf_roundlimit", level.roundlimit);
			iprintln("^3Round Limit ^7changed to ^3" + roundlimit);
		}

		showoncompass = getCvarInt("scr_ctf_showoncompass");
		if(level.showoncompass != showoncompass)
		{
			level.showoncompass = showoncompass;
			if ( level.axis_flag.moved )
				level.axis_flag update_objective();
			if ( level.allies_flag.moved )
				level.allies_flag update_objective();
		}

		roundlength = getCvarFloat("scr_ctf_roundlength");
		if (level.roundlength != roundlength)
		{
			if(level.roundlength > 60)
				setCvar("scr_ctf_roundlength", "60");
			level.roundlength = getCvarFloat("scr_ctf_roundlength");
			iprintln("^3Round Length ^7changed to ^3" + roundlength);
		}
	
		killcam = getCvarInt("scr_killcam");
		if (level.killcam != killcam)
		{
			level.killcam = getCvarInt("scr_killcam");
			if(level.killcam >= 1)
			{
				setarchive(true);
				iprintln("^2Kill Cam ON!");
			}
			else
			{
				setarchive(false);
				iprintln("^1Kill Cam OFF!");
			}
		}
		
		freelook = getCvarInt("scr_freelook");
		if (level.allowfreelook != freelook)
		{
			level.allowfreelook = getCvarInt("scr_freelook");
			level maps\mp\gametypes\_pam_teams::UpdateSpectatePermissions();
			if (freelook == 0)
				iprintln("^1Free Look turned OFF!");
			else
				iprintln("^2Free Look turned ^2ON!");
		}
		
		enemyspectate = getCvarInt("scr_spectateenemy");
		if (level.allowenemyspectate != enemyspectate)
		{
			level.allowenemyspectate = getCvarInt("scr_spectateenemy");
			level maps\mp\gametypes\_pam_teams::UpdateSpectatePermissions();
			if (enemyspectate == 0)
				iprintln("^1Spectate Enemies turned OFF!");
			else
				iprintln("^2Spectate Enemies turned ON!");
		}
		
		teambalance = getCvarInt("scr_teambalance");
		if (level.teambalance != teambalance)
		{
			level.teambalance = getCvarInt("scr_teambalance");
			if (level.teambalance > 0)
			{
				iprintln("^2Team Balance turned ON!");
				level thread maps\mp\gametypes\_pam_teams::TeamBalance_Check_Roundbased();
			}
			else
				iprintln("^1Team Balance turned OFF!");
		}

		if (level.teambalance > 0 && level.allowautobalance)
		{
			level.teambalancetimer++;
			if (level.teambalancetimer >= 60)
			{
				level thread maps\mp\gametypes\_pam_teams::TeamBalance_Check();
				level.teambalancetimer = 0;
			}
		}

		sshock = getcvarint("scr_shellshock");
		if (sshock != level.sshock)
		{
			level.sshock = sshock;
			if (sshock == 0)
				iprintln("^1Shell Shock turned OFF");
			else
				iprintln("^2Shell Shock turned ON");
		}

		hdrop = getcvarint("scr_drophealth");
		if (hdrop != level.drophealth)
		{
			level.drophealth = hdrop;
			if (hdrop == 0)
				iprintln("^1Health Drop turned OFF");
			else
				iprintln("^2Health Drop turned ON");
		}

		wait 1;
	}
}

// ----------------------------------------------------------------------------------
//	updateTeamStatus
//
// 		Sets up the variables which keep track of the teams.
// ----------------------------------------------------------------------------------
updateTeamStatus()
{
	wait 0;	// Required for Callback_PlayerDisconnect to complete before updateTeamStatus can execute
	
	resettimeout();

	oldvalue["allies"] = level.exist["allies"];
	oldvalue["axis"] = level.exist["axis"];
	level.exist["allies"] = 0;
	level.exist["axis"] = 0;
	level.exist["teams"] = 0;
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && isDefined(player.pers["weapon"]))
			level.exist[player.pers["team"]]++;
	}

	if(level.exist["allies"])
		level.didexist["allies"] = true;
	if(level.exist["axis"])
		level.didexist["axis"] = true;

	debug = getCvarint("scr_debug_ctf");
	
	// if one team is empty then abort the round
/* Removed for now
	if(!debug && !game["readyup"] && (oldvalue["allies"] && !level.exist["allies"]) || (oldvalue["axis"] && !level.exist["axis"]))
	{
		iprintln("Match RESTARTING!!!");
		level notify("kill_startround");
		level notify("cleanup match starting");
		game["matchstarting"] = false;

		// level may be starting so dont announce the round a draw
		if(level.roundended || !level.roundstarted)
		{		
			return;
		}
		
		announcement(&"GMI_CTF_ROUND_DRAW");
		level thread endRound("abort");
		return;
	}
*/
}

// ----------------------------------------------------------------------------------
//	ctf
//
// 		starts the flags thinking
// ----------------------------------------------------------------------------------
ctf()
{
	level.allies_flag = getent("ctf_flag_allies", "targetname");
	
	if ( !isDefined(level.allies_flag) )
	{
		maps\mp\_utility::error("NO ALLIED FLAG IN MAP");
		return;
	}
	
	// get the mobile version of the flag
	level.allies_flag.mobile_model = getent("ctf_flag_allies_mobile", "targetname");
	if ( !isDefined(level.allies_flag.mobile_model) )
	{
		maps\mp\_utility::error("NO ALLIED MOBILE FLAG IN MAP");
		return;
	}
	level.allies_flag.mobile_model SetContents(0);
	
	level.allies_flag.icon = newHudElem();
	level.allies_flag.icon.alignX = "left";
	level.allies_flag.icon.alignY = "top";
	level.allies_flag.icon.x = game["flag_icons_x"];
	level.allies_flag.icon.y = game["flag_icons_y"];
	level.allies_flag.icon.sort = -50; // To fix a stupid bug, where the first flag icon (or the one to the furthest left) will not sort through the capping icon. BAH!
	level.allies_flag.icon setShader(game["hud_allies_flag"], game["flag_icons_w"], game["flag_icons_h"]);

	level.allies_flag.mobile_model hide();	
	level.allies_flag.team = "allies";
	level.allies_flag.hudnum = 1;
	level.allies_flag thread ctf_spawn_flag();
	level.allies_flag thread flag_think();

	level.axis_flag = getent("ctf_flag_axis", "targetname");
	
	if ( !isDefined(level.axis_flag) )
	{
		maps\mp\_utility::error("NO AXIS FLAG IN MAP");
		return;
	}
	
	// get the mobile version of the flag
	level.axis_flag.mobile_model = getent("ctf_flag_axis_mobile", "targetname");
	level.axis_flag.mobile_model SetContents(0);

	if ( !isDefined(level.axis_flag.mobile_model) )
	{
		maps\mp\_utility::error("NO ALLIED MOBILE FLAG IN MAP");
		return;
	}

	level.axis_flag.icon = newHudElem();
	level.axis_flag.icon.alignX = "left";
	level.axis_flag.icon.alignY = "top";
	level.axis_flag.icon.x =game["flag_icons_x"]  + game["flag_icons_w"] + game["flag_icons_spacing"];
	level.axis_flag.icon.y = game["flag_icons_y"];
	level.axis_flag.icon.sort = -50; // To fix a stupid bug, where the first flag icon (or the one to the furthest left) will not sort through the capping icon. BAH!
	level.axis_flag.icon setShader(game["hud_axis_flag"], game["flag_icons_w"], game["flag_icons_h"]);

	level.axis_flag.mobile_model hide();	
	level.axis_flag.team = "axis";
	level.axis_flag.hudnum = 2;
	level.axis_flag thread ctf_spawn_flag();
	level.axis_flag thread flag_think();
}

flag_think()
{
	enemy_team = "allies";
	// add the flag base to the radar
	if ( self.team == "allies" )
	{
		objective_add(self.hudnum, "current", self.startorigin, game["hud_allies_base_with_flag"] + ".dds");
	}
	else
	{
		objective_add(self.hudnum, "current", self.startorigin, game["hud_axis_base_with_flag"] + ".dds");
		enemy_team = "axis";
	}
}

ctf_spawn_flag()
{
	targeted = getentarray(self.target, "targetname");
	for(i=0;i<targeted.size;i++)
	{
		if(targeted[i].classname == "mp_gmi_ctf_flag")
		{
			if ( isDefined(self.spawnloc) )
			{
				maps\mp\_utility::error("multiple mp_gmi_ctf_flag for the " + self.team + " team");
				return;
			}
			
			spawnloc = targeted[i];
		}
		else
		if(targeted[i].classname == "trigger_multiple")
		{
			if ( isDefined(self.trigger) )
			{
				maps\mp\_utility::error("to many flag triggers for the " + self.team + " team. There should be one.");
				return;
			}
			
			self.trigger = (targeted[i]);
		}
	}
	
	if((!isdefined(spawnloc)))
	{
		maps\mp\_utility::error( self.team + " flag does not target a mp_gmi_ctf_flag entity");
		return;
	}
	if(!isdefined(self.trigger))
	{
		maps\mp\_utility::error(self.team + " flag does not target a trigger_multiple");
		return;
	}
	targeted = getentarray(spawnloc.target, "targetname");
	for(i=0;i<targeted.size;i++)
	{
		if(targeted[i].classname == "trigger_multiple")
		{
			if ( isDefined(self.goal) )
			{
				maps\mp\_utility::error("to many goal triggers for the " + self.team + " team.  There should only be one");
				return;
			}
			
			self.goal = (targeted[i]);
		}
	}
	if(!isdefined(self.goal))
	{
		maps\mp\_utility::error(self.team + " mp_gmi_ctf_flag does not target a trigger_multiple");
		return;
	}
	
	// get the mobile version of the flag trigger
	targeted = getentarray(self.mobile_model.target, "targetname");
	for(i=0;i<targeted.size;i++)
	{
		if(targeted[i].classname == "trigger_multiple")
		{
			if ( isDefined(self.mobile_trigger) )
			{
				maps\mp\_utility::error("to many flag triggers for the " + self.team + " team. There should be one.");
				return;
			}
			
			self.mobile_trigger = (targeted[i]);
		}
	}
	
	if(!isdefined(self.mobile_trigger))
	{
		maps\mp\_utility::error(self.team + " mobile flag does not target a trigger_multiple");
		return;
	}
	
	
	//move flag to its base position
	self.origin = spawnloc.origin;
	self.startorigin = self.origin;
	self.startangles = self.angles;
	self.trigger.origin = self.origin;
	self.trigger.startorigin = self.trigger.origin;
	self.mobile_model.origin = self.origin;
	self.mobile_trigger.origin = self.origin;
	self.mobile_trigger.startorigin = self.trigger.origin;
	self.carried_by = undefined;

	// turn off the mobile parts
	self.mobile_trigger triggerOff();
	self.mobile_model hide();

	self.moved = false;
	
	self thread ctf_think();
	
	//Set hintstring on the objectives trigger
	wait 0;//required for level script to run and load the level.obj array
}

ctf_think() //each flag model runs this to find it's trigger and goal
{
	//level endon("round_ended");
	self endon("timeout");
//	if(isdefined(self.hudnum))
//		objective_position(self.hudnum, self.origin);

	while(1)
	{
		if ( self.moved )
			self.mobile_trigger waittill ("trigger", other);
		else
			self.trigger waittill ("trigger", other);
		
		if(!game["matchstarted"]  )
			return;

		// do not allow people in vehicles to touch flag
		if (other isinvehicle())
			continue;

		if((isPlayer(other)) && isAlive(other) && (other.pers["team"] != self.team) && level.allowflagactions)
		{
			// Touches Script
			if (!self.moved)
			{
				if ( other.pers["team"] == "axis" )
					game["axistouches"]++;
				else
					game["alliestouches"]++;
			}

			// let the player know they picked up the flag
			if ( other.pers["team"] == "axis" )
			{
				thread FlagNews("allies", "taken");
				//announcement(&"GMI_CTF_ALLIES_FLAG_TAKEN", other);
			}
			else
			{
				thread FlagNews("axis", "taken");
				//announcement(&"GMI_CTF_AXIS_FLAG_TAKEN", other);
			}

			// play the flag has been grabbed sound
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
				
				if ( self.team == "allies" )
				{
					if(player.pers["team"] == "allies")
						player playLocalSound(game["sound_allies_enemy_has_our_flag"]);
					else
						player playLocalSound(game["sound_axis_we_have_enemy_flag"]);
				}
				else
				{
					if(player.pers["team"] == "allies")
						player playLocalSound(game["sound_allies_we_have_enemy_flag"]);
					else
						player playLocalSound(game["sound_axis_enemy_has_our_flag"]);
				}
			}
			
			// update the objective icon to the base but no flag there icon WORM FLAG ICONS SET HERE
			if ( self.team == "allies" )
			{
				level.allies_flag.icon setShader(game["hud_allies_flag_taken"], game["flag_icons_w"], game["flag_icons_h"]);
			}
			else
			{
				level.axis_flag.icon setShader(game["hud_axis_flag_taken"], game["flag_icons_w"], game["flag_icons_h"]);
			}
			
			lpselfnum = other getEntityNumber();
			lpselfguid = other getGuid();
			logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + other.pers["team"] + ";" + other.name + ";" + "ctf_take" + "\n");

			self.returned_by = undefined;
			
			self thread hold_flag(other);
			self thread update_objective();
			return;

		}
		// the team that owns the flag can only touch it if it has been moved AND it is allowed
		else if((isPlayer(other)) && (other.pers["team"] == self.team) && self.moved && level.allowflagreturn != 0 && level.allowflagactions)
		{
			if(other.sessionteam == "allies")
			{
				//announcement(&"GMI_CTF_ALLIES_FLAG_RETURNED");
				iprintln(&"GMI_CTF_PLAYER_RETURNED_FLAG_ALLIES",other);
			}
			else if(other.sessionteam == "axis")
			{
				//announcement(&"GMI_CTF_AXIS_FLAG_RETURNED");
				iprintln(&"GMI_CTF_PLAYER_RETURNED_FLAG_AXIS",other);
			}
			
			self.returned_by = other;
				
			lpselfnum = other getEntityNumber();
			lpselfguid = other getGuid();
			logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + other.pers["team"] + ";" + other.name + ";" + "ctf_returned" + "\n");

			// play the flag has been returned sound
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				temp_player = players[i];
				if(temp_player.pers["team"] == "allies" && self.team == "allies")
					temp_player playLocalSound(game["sound_allies_flag_has_been_returned"]);
				else if(temp_player.pers["team"] == "axis" && self.team == "axis")
					temp_player playLocalSound(game["sound_axis_flag_has_been_returned"]);
			}
			
			self reset_flag();
		}
		else
			wait(.5);
	}
}

GetVehicleFlagPos(flagname,flag)
{
	
	switch(self.vehicletype)
	{
		case	"t34_mp":
		case	"sherman_mp":
		case	"su152_mp":
		case	"panzeriv_mp":
		case	"elefant_mp":
			break;

		case	"horch_mp":
			break;
	}


	flag.vehiclemodel = spawn("script_model", self.origin + (0,0,160));
	flag.vehiclemodel.angles = self.angles + (0,0,0);
	flag.vehiclemodel setmodel(flagname);
	flag.vehiclemodel linkto(self,"tag_turret");
	flag.vehiclemodel setcontents(0);
	flag.vehiclemodel notsolid();
}

handle_change_flag()
{
	while(isdefined(self.carried_by))
	{
		wait(0.05);
	}

	self notify("dropped");
	if (isdefined(self.vehiclemodel))
		self.vehiclemodel delete();
}

handle_vehicle_flag()
{
	self thread handle_change_flag();
	self endon("dropped");
	self endon("completed");
	while(1)
	{
		if (isdefined( self.carried_by) && !(self.carried_by isinvehicle()))		
			self.carried_by waittill("vehicle_activated",pos,vehicle);

		vehicle GetVehicleFlagPos(self.holding_flag,self);
		
		if ( isdefined(self.carried_by) && isvalidplayer(self.carried_by) )
		{
			if ( self.carried_by.has_attached )
			{
				self.carried_by.has_attached = false;
				self.carried_by detach(self.holding_flag,level.held_tag_flag);
			}
	
			self thread handle_vehicle_flag_exited();

			// wait until the the guy gets out of the vehicle before continuing
			wait(0.001);
			self.carried_by waittill("vehicle_deactivated",vehicle);
		}
		else
		{
			if (isdefined(self.vehiclemodel))
				self.vehiclemodel delete();
		}
		
		wait(0.001);
	}

}

handle_vehicle_flag_exited()
{
	self.carried_by waittill("vehicle_deactivated",vehicle);
	
	// check for valid player
	if ( isvalidplayer(self.carried_by) )
	{
		self.carried_by.has_attached = true;
		self.carried_by attach(self.holding_flag,level.held_tag_flag, true);
	}
	
	if (isdefined(self.vehiclemodel))
		self.vehiclemodel delete();
}

hold_flag(player) //the objective model runs this to be held by 'player'
{
	self endon("completed");
	self endon("dropped");


	team = player.sessionteam;
	player.hasflag = self;
	self.carried_by = player;
	self.moved = true;
	self hide();
	self.origin = (self.origin[0], self.origin[1], self.origin[2] - 3000 );
	self.mobile_model hide();
	self.mobile_trigger triggerOff();
	self.trigger triggerOff();

	self thread handle_vehicle_flag();

	lpselfnum = player getEntityNumber();
	lpselfguid = player getGuid();
	logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + self.team + ";" + player.name + ";" + "ctf_pickup" + "\n");
	
	self notify("picked up");

	if ( team == "axis")
	{
		player.statusicon = game["statusicon_carrier_axis"];
		self.holding_flag = level.allies_held_flag;
	}
	else
	{
		player.statusicon = game["statusicon_carrier_allies"];
		self.holding_flag = level.axis_held_flag;
	}

	player.has_attached = true;
	player attach(self.holding_flag,level.held_tag_flag,true);
	
	self thread flag_carrier_atgoal_wait(player);
}

flag_carrier_atgoal_wait(player)
{
	level endon("round_ended");
	self endon("dropped");
	while(1)
	{
		self.goal waittill("trigger", other);

		if ( other isinvehicle() )
			continue;

		if((other == player) && (isPlayer(player)) && level.allowflagactions)
		{
			// make sure the other flag is there
			if (level.flagtimeout > 0 || level.allowflagreturn != 0)
			{
				if ( self.team == "axis" && level.allies_flag.moved )
					continue;
				if ( self.team == "allies" && level.axis_flag.moved )
					continue;
			}
				
			self notify("completed");
			other notify("dropped");

			// get rid of the flag model off the player
			if (player.has_attached == true)
			{
				player.has_attached = false;
				player detach(self.holding_flag,level.held_tag_flag);	
			}
		
			// announce the flag has been grabbed
			if ( other.pers["team"] == "axis" )
			{
				game["axisscore"]++;
				setTeamScore("axis", game["axisscore"]);
				
				//announcement(&"GMI_CTF_AXIS_CAPTURED_FLAG");
				iprintln(&"GMI_CTF_PLAYER_CAPTURED_FLAG_AXIS",player);
			}
			else
			{
				game["alliedscore"]++;
				setTeamScore("allies", game["alliedscore"]);
	
				//announcement(&"GMI_CTF_ALLIES_CAPTURED_FLAG");
				iprintln(&"GMI_CTF_PLAYER_CAPTURED_FLAG_ALLIES",player);
			}

			// play the flag has been captured sound
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				temp_player = players[i];
				if(player.pers["team"] == "allies")
				{
					if ( temp_player.pers["team"] == "allies")
					{
						temp_player playLocalSound(game["sound_allies_we_captured"]);
					}
					else
						temp_player playLocalSound(game["sound_axis_enemy_has_captured"]);
				}
				else
				{
					if ( temp_player.pers["team"] == "allies")
						temp_player playLocalSound(game["sound_allies_enemy_has_captured"]);
					else
						temp_player playLocalSound(game["sound_axis_we_captured"]);
				}
			}
			
			// set the team cap count up one
			if ( other.pers["team"] == "axis" )
			{
				level.axis_cap_count++;
			}
			else
			{
				level.allies_cap_count++;
			}
			
			// give the team points
			GivePointsToTeam( player.pers["team"],  maps\mp\gametypes\_scoring_gmi::GetPoints( 5, 5));

			// give out points to the capper
			if(isValidPlayer(player))
			{
				player.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetPoints( 8, 8 );
				player.score = player.pers["score"];
			}
			
			if ( self.team == "axis" )
				other_flag = level.allies_flag;
			else
				other_flag = level.axis_flag;

			lpselfnum = player getEntityNumber();
			lpselfguid = player getGuid();
			logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + player.pers["team"] + ";" + player.name + ";" + "ctf_captured" + "\n");

			// give assist points
			if (isDefined(other_flag.returned_by) && isValidPlayer(other_flag.returned_by) && other_flag.returned_by != player)
			{
				// let everyone know
				if ( other_flag.returned_by.pers["team"] == "axis" )
					iprintln(&"GMI_CTF_ASSISTED_AXIS_FLAG_CARRIER", other_flag.returned_by);
				else
					iprintln(&"GMI_CTF_ASSISTED_ALLIES_FLAG_CARRIER", other_flag.returned_by);
						
				other_flag.returned_by.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetPoints( 3, 3);
				other_flag.returned_by = other_flag.returned_by.pers["score"];
			}
			
			self.returned_by = undefined;
			
			num = (16 - (self.hudnum));
			
			// remove the carrying flag message from the player
			if((isdefined(player.hudelem)) && (isdefined(player.hudelem[num])))
				player.hudelem[num] destroy();
				
			//move flag to its base position
			self reset_flag();
		
			// clean up the player
			if(isPlayer(player))
			{
				player.hasflag = undefined;
				player setPlayerIcons();
			}
						
			self thread ctf_think();
		
			// check the score to see if we need to end the round
			thread checkRoundScoreLimit();
			return;
		}
		else
		{
			wait .05;
		}
	}
}

reset_flag()
{
	self notify("reset");
	
	//move flag to its base position
	self.trigger.origin = self.trigger.startorigin;
	self.origin = self.startorigin;
	self.angles = self.startangles;
	self.moved = false;
	self show();
	
	self.mobile_trigger.origin = self.trigger.startorigin;
	self.mobile_trigger triggerOff();
	self.mobile_model hide();

	self.carried_by = undefined;

	if ( level.showoncompass != 0 && isdefined(self.objnum) )
	{
		objective_delete( self.objnum );
		self.objnum = undefined;
	}
	// update the objective icon
	if ( self.team == "allies" )
	{
		objective_icon(self.hudnum,game["hud_allies_base_with_flag"] + ".dds");
		level.allies_flag.icon setShader(game["hud_allies_flag"], game["flag_icons_w"], game["flag_icons_h"]);
	}
	else
	{
		objective_icon(self.hudnum,game["hud_axis_base_with_flag"] + ".dds");
		level.axis_flag.icon setShader(game["hud_axis_flag"], game["flag_icons_w"], game["flag_icons_h"]);
	}
	
}

drop_flag(player)
{
	if (isdefined(player))
	{
		if (player.has_attached == true)
		{
			player.has_attached = false;
			player detach(self.holding_flag,level.held_tag_flag);	
		}
	}

	if(isPlayer(player))
	{
		num = (16 - (self.hudnum));
		
		if((isdefined(player.hudelem)) && (isdefined(player.hudelem[num])))
			player.hudelem[num] destroy();
	}
	loc = (player.origin + (0, 0, 25));

	// get the drop position
	plant = player maps\mp\_utility::getPlant();
	end_loc = plant.origin;

	if(distance(loc, end_loc) > 0)
	{
		self.mobile_model.origin = loc;
		self.mobile_model.angles = plant.angles;
		self.mobile_model show();
		speed = (distance(loc, end_loc) / 250);
		if(speed > 0.4)
		{
			self.mobile_model moveto(end_loc, speed, 0.1, 0.1);
			self.mobile_model waittill("movedone");
			self.mobile_trigger.origin = end_loc;
		}
		else
		{
			self.mobile_model.origin = end_loc;
			self.mobile_model show();
			self.mobile_trigger.origin = end_loc;
		}
	}
	else
	{
		self.mobile_model.origin = end_loc;
		self.mobile_model show();
		self.mobile_trigger.origin = end_loc;
	}

	// check if its inside a vehicle
	vehicles = getentarray("script_vehicle","classname");

	for(i=0;i<vehicles.size;i++)
	{
		if ( self.mobile_model istouching(vehicles[i]) )
		{
			valid_origin =  vehicles[i] getdismountspot();
			
			self.mobile_model.origin = valid_origin;
			self.mobile_model.angles = plant.angles;  // just use the angles from the plant
			self.mobile_trigger.origin = valid_origin;
			break;
		}
	}
	
	self.mobile_model show();

	if(isPlayer(player))
	{
		player.hasflag = undefined;
		player setPlayerIcons();
	}

	for(i = 1; i < 16; i++)
	{
		if((isdefined(self.hudelem)) && (isdefined(self.hudelem[i])))
			self.hudelem[i] destroy();
	}

	//check if it's in a minefield
	In_Mines = 0;
	for(i = 0; i < level.minefield.size; i++)
	{
		if(self.mobile_model istouching(level.minefield[i]))
		{
			In_Mines = 1;
			break;
		}
	}

	In_Water = 0;
	for(i = 0; i < level.deepwater.size; i++)
	{
		if(self.mobile_model istouching(level.deepwater[i]))
		{
			In_Water = 1;
			break;
		}
	}
	if(In_Mines == 1)
	{
		if((!isdefined(level.lastdropper)) || (level.lastdropper != player))
		{
			level.lastdropper = player;
			iprintln(&"GMI_CTF_FLAG_INMINES", player);
		}
		
		self reset_flag();
	}
	else if(In_Mines == 1)
	{
		if((!isdefined(level.lastdropper)) || (level.lastdropper != player))
		{
			level.lastdropper = player;
			iprintln(&"GMI_CTF_FLAG_INWATER", player);
		}
		
		self reset_flag();
	}
	else
	{
		self thread flag_timeout();

		if ( self.team == "allies" )
		{
			thread FlagNews("allies", "dropped");
			//announcement(&"GMI_CTF_ALLIES_FLAG_DROPPED");
		}
		else
		{
			thread FlagNews("axis", "dropped");
			//announcement(&"GMI_CTF_AXIS_FLAG_DROPPED");
		}
	}

	self notify("dropped");
	self thread ctf_think();
}

flag_timeout()
{
	self endon("picked up");
	self endon("reset");
	flag_timeout = level.flagtimeout;

	count = 0;
	while (1)
	{
		if (count == flag_timeout)
		{
			break;
		}
		count++;
		wait 1;
	}
	
	if ( self.team == "axis")
		thread FlagNews("axis", "returned");
	else
		thread FlagNews("allies", "returned");
	
	// play the flag has been returned sound
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		temp_player = players[i];
		if(temp_player.pers["team"] == "allies" && self.team == "allies")
			temp_player playLocalSound(game["sound_allies_flag_has_been_returned"]);
		else if(temp_player.pers["team"] == "axis" && self.team == "axis")
			temp_player playLocalSound(game["sound_axis_flag_has_been_returned"]);
	}
	
	self.returned_by = undefined;

	self reset_flag();
	self notify("timeout");
	self thread ctf_think();
}

get_flag_position()
{
	origin = self.mobile_trigger.origin;
	
	// set the origin to be the carriers position if being carried
	if ( isdefined(self.carried_by) && isalive(self.carried_by))
	{
		origin = self.carried_by.origin;
	}
	return origin;
}

update_objective()
{
	self endon("completed");
	self endon("reset");
	count1 = 1;
	
	// 0 is off, 1 is immediatly, greater then 1 is the position will be shown after that time in secs goes by
	show_time = level.showoncompass;
	
	if(show_time == 0)
	{
		// make sure it was not on already
		if ( isDefined(self.objnum) && self.objnum )
		{
			objective_delete( self.objnum );
			self.objnum = undefined;
		}
		return;
	}
	
	// if show_time is greater then 0 then wait that number of seconds before displaying on radar for the first time	
	if ( show_time > 0 )
	{ 
		wait(show_time * 60);
	}		
	
	origin = get_flag_position();
	
	objnum = self.hudnum + 2;
	if ( !isDefined(self.objnum) )
	{
		self.objnum = objnum;
		objective_add(objnum, "current", origin, "gfx/hud/hud@objective_bel.tga");
		objective_icon(objnum,"gfx/hud/hud@objective_bel.tga");
		objective_team(objnum,"none");
	}
	objective_position(objnum, origin);
	lastobjpos = origin;
	newobjpos = origin;
	
	while(1)
	{
		wait(1);
		if(count1 != level.PositionUpdateTime)
			count1++;
		else
		{
			count1 = 1;
			origin = get_flag_position();
			lastobjpos = newobjpos;
			newobjpos = (((lastobjpos[0] + origin[0]) * 0.5), ((lastobjpos[1] + origin[1]) * 0.5), ((lastobjpos[2] + origin[2]) * 0.5));
			objective_position(objnum, newobjpos);
		}
	}
}

display_holding_flag(flag_ent)
{
	num = (16 - (flag_ent.hudnum));

	if(num > 16)
		return;
	
	offset = (150 + (flag_ent.hudnum * 15));
	
	self.hudelem[num] = newClientHudElem(self);
	self.hudelem[num].alignX = "right";
	self.hudelem[num].alignY = "middle";
	self.hudelem[num].x = 635;
	self.hudelem[num].y = (550 - offset);

	if ( self.sessionteam == "axis" )
	{
		self.hudelem[num] setText(&"GMI_CTF_U_R_CARRYING_AXIS");
	}
	else
	{
		self.hudelem[num] setText(&"GMI_CTF_U_R_CARRYING_ALLIES");		
	}

	self.stance_flag = newClientHudElem(self);
	self.stance_flag.alignX = "left";
	self.stance_flag.alignY = "top";
	self.stance_flag.x = 100;
	self.stance_flag.y = 434.375;
	self.color = (1,1,1);
	while(isDefined(self.hasflag))
	{
		x = self getstance();
		switch(x)
		{
			case	"sprint":	sName = "gfx/hud/ctf_stance_sprint.dds";
						break;
			case	"stand":	sName = "gfx/hud/ctf_stance_stand.dds";
						break;
			case	"crouch":	sName = "gfx/hud/ctf_stance_crouch.dds";
						break;
			case	"prone":	sName = "gfx/hud/ctf_stance_prone.dds";
						break;
		}

		
		if (self isinvehicle())
		{
			self.stance_flag.x = -64;
			self.stance_flag.y = -64;
		}
		else
		{
			self.stance_flag.x = 100;
			self.stance_flag.y = 434.375;
			self.stance_flag setShader(sName,40,40);
		}
		wait(0.5);
	}
	self.stance_flag destroy();

}

triggerOff()
{
	self.origin = (self.origin - (0, 0, 10000));
}

client_print(flag, text, s)
{
	num = (16 - flag.hudnum);

	if(num > 16)
		return;

	self notify("stop client print");
	self endon("stop client print");

	//if((isdefined(self.hudelem)) && (isdefined(self.hudelem[num])))
	//	self.hudelem[num] destroy();
	
	for(i = 1; i < 16; i++)
	{
		if((isdefined(self.hudelem)) && (isdefined(self.hudelem[i])))
			self.hudelem[i] destroy();
	}
	
	self.hudelem[num] = newClientHudElem(self);
	self.hudelem[num].alignX = "center";
	self.hudelem[num].alignY = "middle";
	self.hudelem[num].x = 320;
	self.hudelem[num].y = 200;

	if(isdefined(s))
	{
		self.hudelem[num].label = text;
		self.hudelem[num] setText(s);
	}
	else
		self.hudelem[num] setText(text);

	wait 3;
	
	if((isdefined(self.hudelem)) && (isdefined(self.hudelem[num])))
		self.hudelem[num] destroy();
}

// ----------------------------------------------------------------------------------
//	GivePointsToTeam
//
// 		Gives points to everyone on a certain team
// ----------------------------------------------------------------------------------
GivePointsToTeam( team, points )
{
	players = getentarray("player", "classname");
	
	// count up the people in the flag area
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isAlive(player) && player.pers["team"] == team)
		{
			player.pers["score"] += points;
			player.score = player.pers["score"];
		}
	}
}

// ----------------------------------------------------------------------------------
//	GameRoundThink
//
// 	This checks for possible end round conditions.  Also displays round messages.
// ----------------------------------------------------------------------------------
GameRoundThink()
{
	for(;;)
	{
		ceasefire = getCvarint("scr_ceasefire");

		// if we are in cease fire mode display it on the screen
		if (ceasefire != level.ceasefire && getcvar("pam_mode") == "pub")
		{
			level.ceasefire = ceasefire;
			if ( ceasefire )
			{
				level thread maps\mp\_util_mp_gmi::make_permanent_announcement(&"GMI_MP_CEASEFIRE", "end ceasefire", 220, (1.0,0.0,0.0));			
			}
			else
			{
				level notify("end ceasefire");
			}
		}

		// check all the players for rank changes
		if ( getCvarint("scr_battlerank") )
			maps\mp\gametypes\_rank_gmi::CheckPlayersForRankChanges();
			
		// check to see if we hit the score limit
		scorelimit = getCvarint("scr_ctf_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;

			if(game["matchstarted"])
				thread checkScoreLimit();
		}

		// end the round if there are not enough people playing
		if (game["matchstarted"] == true && level.roundstarted == true)
		{
			debug = getCvarint("scr_debug_ctf");
			
			players_on_allies = 0;
			players_on_axis = 0;
			
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
				
				switch(player.pers["team"])
				{
					case "allies":
					{
						players_on_allies++;
						break;
					}
					case "axis":
					{
						players_on_axis++;
						break;
					}
				}
				
				// if we are in debug mode and we have found one person on a team then we are good
				if ( debug && (players_on_allies || players_on_axis) )
				{
					players_on_allies = 1;
					players_on_axis = 1;
					break;
				}			
		
				// if there is at least one player on each team then we are good.
				if (players_on_allies && players_on_axis )
				{
					break;
				}
			}
			
			// if one of these is zero then we only have one team
			if ( !players_on_allies || !players_on_axis )
			{
				updateTeamStatus();
			}
		}
			
		wait 0.5;
	}
}

// ----------------------------------------------------------------------------------
//	checkEvenTeams
//
//	JS 1/14/04
// 	Displays a message in the center of screen if teams are uneven by more than
//	one player.
// ----------------------------------------------------------------------------------
checkEvenTeams()
{
	for(;;)
	{
		if(!isDefined(level.messagedisplayed) || level.messagedisplayed == 0)	//Test to see if a message is already on-screen so we don't spam
		{
			//Count the players on each team			
			numonteam["allies"] = 0;
			numonteam["axis"] = 0;
	
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
			
				if(!isDefined(player.pers["team"]) || player.pers["team"] == "spectator")
					continue;
		
				numonteam[player.pers["team"]]++;
			}
	
			//If Allies have 2 or more players than Axis, display the message			
			if(numonteam["allies"] > numonteam["axis"] && (numonteam["allies"] - numonteam["axis"]) >= 2)
			{
				level.messagedisplayed = 1;
				iprintlnbold(&"GMI_MP_ALLIES_TOO_MANY_PLAYERS");
			}
	
			//If Axis have 2 or more players than Allies, display the message			
			else if(numonteam["axis"] > numonteam["allies"] && (numonteam["axis"] - numonteam["allies"]) >= 2)
			{
				level.messagedisplayed = 1;
				iprintlnbold(&"GMI_MP_AXIS_TOO_MANY_PLAYERS");
			}
				
			wait 8.0;	//Eight seconds between messages... should be annoying enough at that interval.
			level.messagedisplayed = 0;
		}
	}
}

// ----------------------------------------------------------------------------------
//	printJoinedTeam
//
// 	Displays a joined team message.
// ----------------------------------------------------------------------------------
printJoinedTeam(team)
{
	if(team == "allies")
		iprintln(&"MPSCRIPT_JOINED_ALLIES", self);
	else if(team == "axis")
		iprintln(&"MPSCRIPT_JOINED_AXIS", self);
}

// ----------------------------------------------------------------------------------
//	setPlayerIcons
//
// 	 	sets the appropriate icons for the player
// ----------------------------------------------------------------------------------
setPlayerIcons()
{
	if(level.drawfriend == 1)
	{
		// battle rank takes precidence
		if(level.battlerank)
		{
			if (level.rdyup != 1)
				self.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(self);
			self.headicon = maps\mp\gametypes\_rank_gmi::GetRankHeadIcon(self);
			self.headiconteam = self.pers["team"];
		}
		else
		{
			if(self.pers["team"] == "allies")
			{
				self.headicon = game["headicon_allies"];
				self.headiconteam = "allies";
			}
			else if(self.pers["team"] == "axis")
			{
				self.headicon = game["headicon_axis"];
				self.headiconteam = "axis";
			}
			else
			{
				self.headicon = "";
			}
			
			if (level.rdyup != 1)
				self.statusicon = "";
		}
	}
	else if (level.rdyup != 1)
	{
		if(level.battlerank)
		{
			self.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(self);
		}
		else
		{
			self.statusicon = "";
		}
		self.headicon = "";
		self.headiconteam = "none";
	}
}

// ----------------------------------------------------------------------------------
//	is_near_flag
//
// 	 	checks if the player is near the enemy flag
// ----------------------------------------------------------------------------------
is_near_flag()
{
	// determine the opposite teams flag
	if ( self.pers["team"] == "allies" )
		flag = level.axis_flag;
	else
		flag = level.allies_flag;	
		
	// if the flag is not at the base then return false
	if ( flag.moved )
		return false;
		
	dist = distance(flag.origin, self.origin);
	
	// if they were close to the flag then return true
	if ( dist < 750 )
		return true;
		
	return false;
}

// ----------------------------------------------------------------------------------
//	is_near_flag
//
// 	 	checks if the player is near the enemy flag carrier
// ----------------------------------------------------------------------------------
is_near_carrier(attacker)
{
	// determine the teams flag
	if ( self.pers["team"] == "axis" )
		flag = level.axis_flag;
	else
		flag = level.allies_flag;	
		
	// if the flag is at the base then return false
	if ( !flag.moved )
		return false;
	
	// if the attacker is the carrier then return false
	if ( attacker == flag.carried_by )
		return false;
		
	// if the attacker is the carrier then return false
	if ( !isdefined(flag.carried_by) || !isAlive(flag.carried_by) || !isValidPlayer(flag.carried_by) )
		return false;
		
	dist = distance(self.origin, flag.carried_by.origin);
	
	// if they were close to the flag carrier then return true
	if ( dist < 750 )
		return true;
		
	return false;
}

// ----------------------------------------------------------------------------------
//	clock_start
//
// 	 	starts the hud clock for the player if the reason is good enough
// ----------------------------------------------------------------------------------
stopwatch_start(reason, time)
{
	make_clock = false;

	// if we are not waiting for a match start or another match start comes in go ahead and make a new one
	if ( !isDefined( self.stopwatch_reason ) || reason == "match_start" )
	{
		make_clock = true;
	}
	
	if ( make_clock )
	{
		if(isDefined(self.stopwatch))
		{
			thread stopwatch_delete("do_it");
		}
		
		self.stopwatch = newClientHudElem(self);
		maps\mp\_util_mp_gmi::InitClock(self.stopwatch, time);
		self.stopwatch.archived = false;
		
		self.stopwatch_reason = reason;
		
		self thread stopwatch_cleanup(reason, time);
		
		// if this is a match start
		if ( reason == "match_start" )
		{
			self thread stopwatch_waittill_killrestart(reason);
		}
	}
}

// ----------------------------------------------------------------------------------
//	stopwatch_delete
//
// 	 	destroys the hud stopwatch for the player if the reason is good enough
// ----------------------------------------------------------------------------------
stopwatch_delete(reason)
{
	self endon("stop stopwatch cleanup");

	if(!isDefined(self.stopwatch))
		return;
	
	delete_it = false;
	
	if (reason == "spectator" || reason == "do_it" || reason == self.stopwatch_reason)
	{
		self.stopwatch_reason = undefined;
		self.stopwatch destroy();
		self notify("stop stopwatch cleanup");
	}
}

// ----------------------------------------------------------------------------------
//	stopwatch_cleanup_respawn
//
// 	 	should only be called by stopwatch_start
// ----------------------------------------------------------------------------------
stopwatch_cleanup(reason, time)
{
	self endon("stop stopwatch cleanup");
	wait (time);

	stopwatch_delete(reason);
}

// ----------------------------------------------------------------------------------
//	stopwatch_cleanup_respawn
//
// 	 	should only be called by stopwatch_start
// ----------------------------------------------------------------------------------
stopwatch_waittill_killrestart(reason)
{
	self endon("stop stopwatch cleanup");
	level waittill("kill_startround");

	stopwatch_delete(reason);
}

// ----------------------------------------------------------------------------------
//	adds a ent to the array
// ----------------------------------------------------------------------------------
merge_arrays(array1, array2)
{
	if(!isdefined(array2))
		return array1;
		
	if(!isdefined(array1))
		array1 = [];
	
	
	for ( i = 0; i < array2.size; i++ )
	{
		array1[array1.size] = array2[i];
	}
	
	return array1;	
}

// ----------------------------------------------------------------------------------
//	dropHealth
// ----------------------------------------------------------------------------------
dropHealth()
{
	if ( !getcvarint("scr_drophealth") )
		return;
		
	if(isDefined(level.healthqueue[level.healthqueuecurrent]))
		level.healthqueue[level.healthqueuecurrent] delete();
	
	level.healthqueue[level.healthqueuecurrent] = spawn("item_health", self.origin + (0, 0, 1));
	level.healthqueue[level.healthqueuecurrent].angles = (0, randomint(360), 0);

	level.healthqueuecurrent++;
	
	if(level.healthqueuecurrent >= 16)
		level.healthqueuecurrent = 0;
}

// WORM
Create_HUD_Header()
{
	level.pamlogo = newHudElem();
	level.pamlogo.x = 575;
	level.pamlogo.y = 10;
	level.pamlogo.alignX = "center";
	level.pamlogo.alignY = "middle";
	level.pamlogo.fontScale = 1;
	level.pamlogo.color = (.8, 1, 1);
	level.pamlogo setText(game["pamstring"]);

	level.pammode = newHudElem();
	level.pammode.x = 10;
	level.pammode.y = 10;
	level.pammode.alignX = "left";
	level.pammode.alignY = "middle";
	level.pammode.fontScale = 1;
	level.pammode.color = (1, 1, 0);
	level.pammode setText(game["leaguestring"]);

	if(getcvarint("g_ot_active") > 0)
	{
		level.overtimemode = newHudElem();
		level.overtimemode.x = 10;
		level.overtimemode.y = 30;
		level.overtimemode.alignX = "left";
		level.overtimemode.alignY = "middle";
		level.overtimemode.fontScale = 1;
		level.overtimemode.color = (1, 1, 0);
		level.overtimemode setText(game["overtimemode"]);
	}
}

Destroy_HUD_Header()
{
	if(isdefined(level.pammode))
		level.pammode destroy();
	if(isdefined(level.pamlogo))
		level.pamlogo destroy();
	if(isdefined(level.overtimemode))
		level.overtimemode destroy();
}

Create_HUD_Scoreboard()
{
	if (getcvar("sv_scoreboard") == "big" || getcvar("sv_scoreboard") == "small")
	{
		if (getcvar("sv_scoreboard") == "big")
		{
			// First Half Score Display
			level.firhalfscore = newHudElem();
			level.firhalfscore.x = 320;
			level.firhalfscore.y = 135;
			level.firhalfscore.alignX = "center";
			level.firhalfscore.alignY = "middle";
			level.firhalfscore.fontScale = 1.5;
			level.firhalfscore.color = (1, 1, 0);
			level.firhalfscore setText(game["1sthalfscore"]);

			level.firhalfaxisscore = newHudElem();
			level.firhalfaxisscore.x = 200;
			level.firhalfaxisscore.y = 130;
			level.firhalfaxisscore.alignX = "center";
			level.firhalfaxisscore.alignY = "middle";
			level.firhalfaxisscore.fontScale = 1;
			level.firhalfaxisscore.color = (1, 0, 0);
			level.firhalfaxisscore setText(game["dspaxisscore"]);
				
			level.firhalfaxisscorenum = newHudElem();
			level.firhalfaxisscorenum.x = 200;
			level.firhalfaxisscorenum.y = 145;
			level.firhalfaxisscorenum.alignX = "center";
			level.firhalfaxisscorenum.alignY = "middle";
			level.firhalfaxisscorenum.fontScale = 1;
			level.firhalfaxisscorenum.color = (1, 0, 0);
			level.firhalfaxisscorenum setValue(game["round1axisscore"]);

			level.firhalfalliesscore = newHudElem();
			level.firhalfalliesscore.x = 440;
			level.firhalfalliesscore.y = 130;
			level.firhalfalliesscore.alignX = "center";
			level.firhalfalliesscore.alignY = "middle";
			level.firhalfalliesscore.fontScale = 1;
			level.firhalfalliesscore.color = (0, 1, 0);
			level.firhalfalliesscore setText(game["dspalliesscore"]);
				
			level.firhalfalliesscorenum = newHudElem();
			level.firhalfalliesscorenum.x = 440;
			level.firhalfalliesscorenum.y = 145;
			level.firhalfalliesscorenum.alignX = "center";
			level.firhalfalliesscorenum.alignY = "middle";
			level.firhalfalliesscorenum.fontScale = 1;
			level.firhalfalliesscorenum.color = (0, 1, 0);
			level.firhalfalliesscorenum setValue(game["round1alliesscore"]);

			// Second Half Score Display
			level.sechalfscore = newHudElem();
			level.sechalfscore.x = 320;
			level.sechalfscore.y = 190;
			level.sechalfscore.alignX = "center";
			level.sechalfscore.alignY = "middle";
			level.sechalfscore.fontScale = 1.5;
			level.sechalfscore.color = (1, 1, 0);
			level.sechalfscore setText(game["2ndhalfscore"]);
					
			level.sechalfaxisscore = newHudElem();
			level.sechalfaxisscore.x = 440;
			level.sechalfaxisscore.y = 185;
			level.sechalfaxisscore.alignX = "center";
			level.sechalfaxisscore.alignY = "middle";
			level.sechalfaxisscore.fontScale = 1;
			level.sechalfaxisscore.color = (0, 1, 0);
			level.sechalfaxisscore setText(game["dspaxisscore"]);
				
			level.sechalfaxisscorenum = newHudElem();
			level.sechalfaxisscorenum.x = 440;
			level.sechalfaxisscorenum.y = 205;
			level.sechalfaxisscorenum.alignX = "center";
			level.sechalfaxisscorenum.alignY = "middle";
			level.sechalfaxisscorenum.fontScale = 1;
			level.sechalfaxisscorenum.color = (0, 1, 0);
			level.sechalfaxisscorenum setValue(game["round2axisscore"]);

			level.sechalfalliesscore = newHudElem();
			level.sechalfalliesscore.x = 200;
			level.sechalfalliesscore.y = 185;
			level.sechalfalliesscore.alignX = "center";
			level.sechalfalliesscore.alignY = "middle";
			level.sechalfalliesscore.fontScale = 1;
			level.sechalfalliesscore.color = (1, 0, 0);
			level.sechalfalliesscore setText(game["dspalliesscore"]);
				
			level.sechalfalliesscorenum = newHudElem();
			level.sechalfalliesscorenum.x = 200;
			level.sechalfalliesscorenum.y = 205;
			level.sechalfalliesscorenum.alignX = "center";
			level.sechalfalliesscorenum.alignY = "middle";
			level.sechalfalliesscorenum.fontScale = 1;
			level.sechalfalliesscorenum.color = (1, 0, 0);
			level.sechalfalliesscorenum setValue(game["round2alliesscore"]);
		}
				
		// Display TEAMS
		level.team1 = newHudElem();
		level.team1.x = 200;
		level.team1.y = 100;
		level.team1.alignX = "center";
		level.team1.alignY = "middle";
		level.team1.fontScale = 1.5;
		level.team1.color = (1, 0, 0);
		level.team1 setText(game["dspteam1"]);

		level.team2 = newHudElem();
		level.team2.x = 440;
		level.team2.y = 100;
		level.team2.alignX = "center";
		level.team2.alignY = "middle";
		level.team2.fontScale = 1.5;
		level.team2.color = (0, 1, 0);
		level.team2 setText(game["dspteam2"]);

		// Match Score Display
		level.matchscore = newHudElem();
		level.matchscore.x = 320;
		if (getcvar("sv_scoreboard") == "big")
			level.matchscore.y = 240;
		else
			level.matchscore.y = 135;
		level.matchscore.alignX = "center";
		level.matchscore.alignY = "middle";
		level.matchscore.fontScale = 2;
		level.matchscore.color = (1, 1, 0);
		level.matchscore setText(game["matchscore"]);

		level.matchaxisscorenum = newHudElem();
		level.matchaxisscorenum.x = 200;
		level.matchaxisscorenum.color = (1, 0, 0);

		if (getcvar("sv_scoreboard") == "big")
			level.matchaxisscorenum.y = 240;
		else
			level.matchaxisscorenum.y = 135;
		level.matchaxisscorenum.alignX = "center";
		level.matchaxisscorenum.alignY = "middle";
		level.matchaxisscorenum.fontScale = 2;
		level.matchaxisscorenum setValue(game["axismatchscore"]);

		level.matchalliesscorenum = newHudElem();
		level.matchalliesscorenum.x = 440;
		level.matchalliesscorenum.color = (0, 1, 0);

		if (getcvar("sv_scoreboard") == "big")
			level.matchalliesscorenum.y = 240;
		else
			level.matchalliesscorenum.y = 135;
		level.matchalliesscorenum.alignX = "center";
		level.matchalliesscorenum.alignY = "middle";
		level.matchalliesscorenum.fontScale = 2;
		level.matchalliesscorenum setValue(game["alliesmatchscore"]);
	}
	else
	{
		// Display TEAMS
		level.scorebd = newHudElem();
		level.scorebd.x = 575;
		level.scorebd.y = 262;
		level.scorebd.alignX = "center";
		level.scorebd.alignY = "middle";
		level.scorebd.fontScale = 1;
		level.scorebd.color = (.99, .99, .75);
		level.scorebd setText(game["scorebd"]);

		level.team1 = newHudElem();
		level.team1.x = 535;
		level.team1.y = 277;
		level.team1.alignX = "center";
		level.team1.alignY = "middle";
		level.team1.fontScale = .75;
		level.team1.color = (.73, .99, .73);
		level.team1 setText(game["dspteam1"]);

		level.team2 = newHudElem();
		level.team2.x = 615;
		level.team2.y = 277;
		level.team2.alignX = "center";
		level.team2.alignY = "middle";
		level.team2.fontScale = .75;
		level.team2.color = (.85, .99, .99);
		level.team2 setText(game["dspteam2"]);

		// First Half Score Display
		level.firhalfscore = newHudElem();
		level.firhalfscore.x = 575;
		level.firhalfscore.y = 290;
		level.firhalfscore.alignX = "center";
		level.firhalfscore.alignY = "middle";
		level.firhalfscore.fontScale = .75;
		level.firhalfscore.color = (.99, .99, .75);
		level.firhalfscore setText(game["1sthalf"]);

		level.firhalfaxisscorenum = newHudElem();
		level.firhalfaxisscorenum.x = 532;
		level.firhalfaxisscorenum.y = 290;
		level.firhalfaxisscorenum.alignX = "center";
		level.firhalfaxisscorenum.alignY = "middle";
		level.firhalfaxisscorenum.fontScale = .75;
		level.firhalfaxisscorenum.color = (.73, .99, .75);
		level.firhalfaxisscorenum setValue(game["round1axisscore"]);

		level.firhalfalliesscorenum = newHudElem();
		level.firhalfalliesscorenum.x = 618;
		level.firhalfalliesscorenum.y = 290;
		level.firhalfalliesscorenum.alignX = "center";
		level.firhalfalliesscorenum.alignY = "middle";
		level.firhalfalliesscorenum.fontScale = .75;
		level.firhalfalliesscorenum.color = (.85, .99, .99);
		level.firhalfalliesscorenum setValue(game["round1alliesscore"]);

		// Second Half Score Display
		level.sechalfscore = newHudElem();
		level.sechalfscore.x = 575;
		level.sechalfscore.y = 307;
		level.sechalfscore.alignX = "center";
		level.sechalfscore.alignY = "middle";
		level.sechalfscore.fontScale = .75;
		level.sechalfscore.color = (.99, .99, .75);
		level.sechalfscore setText(game["2ndhalf"]);
				
		level.sechalfaxisscorenum = newHudElem();
		level.sechalfaxisscorenum.x = 618;
		level.sechalfaxisscorenum.y = 307;
		level.sechalfaxisscorenum.alignX = "center";
		level.sechalfaxisscorenum.alignY = "middle";
		level.sechalfaxisscorenum.fontScale = .75;
		level.sechalfaxisscorenum.color = (.85, .99, .99);
		level.sechalfaxisscorenum setValue(game["round2axisscore"]);

		level.sechalfalliesscorenum = newHudElem();
		level.sechalfalliesscorenum.x = 532;
		level.sechalfalliesscorenum.y = 307;
		level.sechalfalliesscorenum.alignX = "center";
		level.sechalfalliesscorenum.alignY = "middle";
		level.sechalfalliesscorenum.fontScale = .75;
		level.sechalfalliesscorenum.color = (.73, .99, .75);
		level.sechalfalliesscorenum setValue(game["round2alliesscore"]);
				
		// Match Score Display
		level.matchscore = newHudElem();
		level.matchscore.x = 575;
		level.matchscore.y = 327;
		level.matchscore.alignX = "center";
		level.matchscore.alignY = "middle";
		level.matchscore.fontScale = .8;
		level.matchscore.color = (.99, .99, .75);
		level.matchscore setText(game["matchscore2"]);

		level.matchaxisscorenum = newHudElem();
		level.matchaxisscorenum.x = 532;
		level.matchaxisscorenum.y = 327;
		level.matchaxisscorenum.color = (.73, .99, .75);
		level.matchaxisscorenum.alignX = "center";
		level.matchaxisscorenum.alignY = "middle";
		level.matchaxisscorenum.fontScale = 1;
		level.matchaxisscorenum setValue(game["axismatchscore"]);

		level.matchalliesscorenum = newHudElem();
		level.matchalliesscorenum.x = 618;
		level.matchalliesscorenum.y = 327;
		level.matchalliesscorenum.color = (.85, .99, .99);
		level.matchalliesscorenum.alignX = "center";
		level.matchalliesscorenum.alignY = "middle";
		level.matchalliesscorenum.fontScale = 1;
		level.matchalliesscorenum setValue(game["alliesmatchscore"]);
	}
}

Create_HUD_Touches()
{
	team1touches = level.team1touchcount;
	team2touches = level.team2touchcount;

	level.touches = newHudElem();
	level.touches.x = 575;
	level.touches.y = 347;
	level.touches.alignX = "center";
	level.touches.alignY = "middle";
	level.touches.fontScale = 1;
	level.touches.color = (.99, .99, .75);
	level.touches setText(game["touches"]);

	level.team1touches = newHudElem();
	level.team1touches.x = 532;
	level.team1touches.y = 347;
	level.team1touches.color = (.73, .99, .75);
	level.team1touches.alignX = "center";
	level.team1touches.alignY = "middle";
	level.team1touches.fontScale = 1.2;
	level.team1touches setValue(team1touches);

	level.team2touches = newHudElem();
	level.team2touches.x = 618;
	level.team2touches.y = 347;
	level.team2touches.color = (.85, .99, .99);
	level.team2touches.alignX = "center";
	level.team2touches.alignY = "middle";
	level.team2touches.fontScale = 1.2;
	level.team2touches setValue(team2touches);
}

Destroy_HUD_Scoreboard()
{
	if(isdefined(level.scorebd))
		level.scorebd destroy();
	if(isdefined(level.team1))
		level.team1 destroy();
	if(isdefined(level.team2))
		level.team2 destroy();

	if(isdefined(level.firhalfscore))
		level.firhalfscore destroy();
	if(isdefined(level.firhalfaxisscore))
		level.firhalfaxisscore destroy();
	if(isdefined(level.firhalfalliesscore))
		level.firhalfalliesscore destroy();
	if(isdefined(level.firhalfaxisscorenum))
		level.firhalfaxisscorenum destroy();
	if(isdefined(level.firhalfalliesscorenum))
		level.firhalfalliesscorenum destroy();

	if(isdefined(level.sechalfscore))
		level.sechalfscore destroy();
	if(isdefined(level.sechalfaxisscore))
		level.sechalfaxisscore destroy();
	if(isdefined(level.sechalfalliesscore))
		level.sechalfalliesscore destroy();
	if(isdefined(level.sechalfaxisscorenum))
		level.sechalfaxisscorenum destroy();
	if(isdefined(level.sechalfalliesscorenum))
		level.sechalfalliesscorenum destroy();

	if(isdefined(level.matchscore))
		level.matchscore destroy();
	if(isdefined(level.matchaxisscorenum))
		level.matchaxisscorenum destroy();
	if(isdefined(level.matchalliesscorenum))
		level.matchalliesscorenum destroy();

	if (isdefined(level.touches))
		level.touches destroy();
	if (isdefined(level.team1touches))
		level.team1touches destroy();
	if (isdefined(level.team2touches))
		level.team2touches destroy();
}

Create_HUD_NextRound()
{
	level.round = newHudElem();
	level.round.x = 230;
	level.round.y = 350;
	level.round.alignX = "left";
	level.round.alignY = "top";
	level.round.fontScale = 1.5;
	level.round.color = (1, 1, 0);
	level.round setText(game["round"]);		
		
	level.roundnum = newHudElem();
	level.roundnum.x = 310;
	level.roundnum.y = 350;
	level.roundnum.alignX = "center";
	level.roundnum.alignY = "top";
	level.roundnum.fontScale = 1.5;
	level.roundnum.color = (1, 1, 0);
	round = game["roundsplayed"] +1;
	level.roundnum setValue(round);

	level.startingin = newHudElem();
	level.startingin.x = 410;
	level.startingin.y = 350;
	level.startingin.alignX = "right";
	level.startingin.alignY = "top";
	level.startingin.fontScale = 1.5;
	level.startingin.color = (1, 1, 0);
	level.startingin setText(game["startingin"]);	
		
	level.warmupclock = newHudElem();
	level.warmupclock.x = 320;
	level.warmupclock.y = 370;
	level.warmupclock.alignX = "center";
	level.warmupclock.alignY = "top";
	level.warmupclock.font = "bigfixed";
	level.warmupclock.color = (1, 1, 0);
	warmup = getcvarint("g_roundwarmuptime");
	level.warmupclock setTimer(warmup);
}

Destroy_HUD_NextRound()
{
	if(isdefined(level.round))
		level.round destroy();
	if(isdefined(level.roundnum))
		level.roundnum destroy();
	if(isdefined(level.startingin))
		level.startingin destroy();
	if(isdefined(level.warmupclock))
		level.warmupclock destroy();
}

Create_HUD_Matchover()
{
	if (getcvar("sv_scoreboard") == "big" || getcvar("sv_scoreboard") == "small")
	{
		level.matchover = newHudElem();
		level.matchover.x = 320;
		level.matchover.y = 60;
		level.matchover.alignX = "center";
		level.matchover.alignY = "middle";
		level.matchover.fontScale = 2;
		level.matchover.color = (1, 1, 0);
		if(getcvarint("g_ot_active") > 0)
			level.matchover setText(game["overtime"]);
		else
			level.matchover setText(game["matchover"]);
	}
	else
	{
		level.matchover = newHudElem();
		level.matchover.x = 575;
		level.matchover.y = 240;
		level.matchover.alignX = "center";
		level.matchover.alignY = "middle";
		level.matchover.fontScale = 1;
		level.matchover.color = (1, 1, 0);
		if(getcvarint("g_ot_active") > 0)
			level.matchover setText(game["overtime"]);
		else
			level.matchover setText(game["matchover"]);
	}
}

Create_HUD_TeamWin()
{
	if (getcvar("sv_scoreboard") == "big" || getcvar("sv_scoreboard") == "small")
	{
		level.teamwin = newHudElem();
		level.teamwin.x = 320;
		level.teamwin.y = 300;
		level.teamwin.alignX = "center";
		level.teamwin.alignY = "middle";
		level.teamwin.fontScale = 2;

		if (game["axisscore"] == game["alliedscore"])
		{
			level.teamwin.color = (1, 1, 0);
			level.teamwin setText(game["dsptie"]);
		}
		else if (game["axisscore"] > game["alliedscore"] && game["halftimeflag"] == "1")
		{
			level.teamwin.color = (0, 1, 0);
			level.teamwin setText(game["team2win"]);
		}
		else if (game["axisscore"] < game["alliedscore"] && game["halftimeflag"] == "0")
		{
			level.teamwin.color = (0, 1, 0);
			level.teamwin setText(game["team2win"]);
		}
		else
		{
			level.teamwin.color = (1, 0, 0);
			level.teamwin setText(game["team1win"]);
		}
	}
	else
	{
		level.teamwin = newHudElem();
		level.teamwin.x = 575;
		level.teamwin.y = 220;
		level.teamwin.alignX = "center";
		level.teamwin.alignY = "middle";
		level.teamwin.fontScale = 1;

		if (game["axisscore"] == game["alliedscore"])
		{
			if (getcvarint("scr_usetouches") != 0)// && game["axistouches"] != game["alliestouches"])
			{
				if (game["halftimeflag"] == 0)
				{
					level.team1touchcount = game["axistouches"];
					level.team2touchcount = game["alliestouches"];
				}
				else
				{
					level.team2touchcount = game["axistouches"];
					level.team1touchcount = game["alliestouches"];
				}

				if (game["axistouches"] != game["alliestouches"])
				{
					if (level.team1touchcount > level.team2touchcount)
					{
						level.teamwin.color = (.73, .99, .75);
						level.teamwin setText(game["team1win"]);
					}
					else
					{
						level.teamwin.color = (.85, .99, .99);
						level.teamwin setText(game["team2win"]);
					}
				}
				else
				{
					level.teamwin.color = (1, 1, 0);
					level.teamwin setText(game["dsptie"]);
				}
			}
			else
			{
				level.teamwin.color = (1, 1, 0);
				level.teamwin setText(game["dsptie"]);
			}
		}
		else if (game["axisscore"] > game["alliedscore"] && game["halftimeflag"] == "1")
		{
			level.teamwin.color = (.85, .99, .99);
			level.teamwin setText(game["team2win"]);
		}
		else if (game["axisscore"] < game["alliedscore"] && game["halftimeflag"] == "0")
		{
			level.teamwin.color = (.85, .99, .99);
			level.teamwin setText(game["team2win"]);
		}
		else
		{
			level.teamwin.color = (.73, .99, .75);
			level.teamwin setText(game["team1win"]);
		}
	}
}

Destroy_HUD_TeamWin()
{
	if(isdefined(level.teamwin))
		level.teamwin destroy();
}

Create_HUD_Halftime()
{
	if (getcvar("sv_scoreboard") == "big" || getcvar("sv_scoreboard") == "small")
	{
		level.halftime = newHudElem();
		level.halftime.x = 320;
		level.halftime.y = 60;
		level.halftime.alignX = "center";
		level.halftime.alignY = "middle";
		level.halftime.fontScale = 2;
		level.halftime.color = (1, 1, 0);
		level.halftime setText(game["halftime"]);
	}
	else
	{
		level.halftime = newHudElem();
		level.halftime.x = 575;
		level.halftime.y = 240;
		level.halftime.alignX = "center";
		level.halftime.alignY = "middle";
		level.halftime.fontScale = 1.5;
		level.halftime.color = (1, 1, 0);
		level.halftime setText(game["halftime"]);
	}
}

Create_HUD_PlayersReady(startinghalf)
{
	if (getcvar("sv_scoreboard") == "big" || getcvar("sv_scoreboard") == "small")
	{
		level.allready = newHudElem();
		level.allready.x = 320;
		level.allready.y = 265;
		level.allready.alignX = "center";
		level.allready.alignY = "middle";
		level.allready.fontScale = 2;
		level.allready.color = (0, 1, 0);
		level.allready setText(game["allready"]);

		if (startinghalf == "1")
		{
			level.half1start = newHudElem();
			level.half1start.x = 320;
			level.half1start.y = 300;
			level.half1start.alignX = "center";
			level.half1start.alignY = "middle";
			level.half1start.fontScale = 2;
			level.half1start.color = (0, 1, 0);
			level.half1start setText(game["start1sthalf"]);
		}
		else
		{
			level.half2start = newHudElem();
			level.half2start.x = 320;
			level.half2start.y = 300;
			level.half2start.alignX = "center";
			level.half2start.alignY = "middle";
			level.half2start.fontScale = 2;
			level.half2start.color = (0, 1, 0);
			level.half2start setText(game["start2ndhalf"]);
		}
	}
	else
	{
		level.allready = newHudElem();
		level.allready.x = 320;
		level.allready.y = 390;
		level.allready.alignX = "center";
		level.allready.alignY = "middle";
		level.allready.fontScale = 1.5;
		level.allready.color = (0, 1, 0);
		level.allready setText(game["allready"]);

		if (startinghalf == "1")
		{
			level.half1start = newHudElem();
			level.half1start.x = 320;
			level.half1start.y = 370;
			level.half1start.alignX = "center";
			level.half1start.alignY = "middle";
			level.half1start.fontScale = 1.5;
			level.half1start.color = (0, 1, 0);
			level.half1start setText(game["start1sthalf"]);
		}
		else
		{
			level.half2start = newHudElem();
			level.half2start.x = 575;
			level.half2start.y = 345;
			level.half2start.alignX = "center";
			level.half2start.alignY = "middle";
			level.half2start.fontScale = 1;
			level.half2start.color = (0, 1, 0);
			level.half2start setText(game["start2ndhalf"]);
		}
	}
}

Create_HUD_TeamSwap()
{
	if (getcvar("sv_scoreboard") == "big" || getcvar("sv_scoreboard") == "small")
	{
		level.switching = newHudElem();
		level.switching.x = 320;
		level.switching.y = 300;
		level.switching.alignX = "center";
		level.switching.alignY = "middle";
		level.switching.fontScale = 2;
		level.switching.color = (1, 1, 0);
		level.switching setText(game["switching"]);

		level.switching2 = newHudElem();
		level.switching2.x = 320;
		level.switching2.y = 335;
		level.switching2.alignX = "center";
		level.switching2.alignY = "middle";
		level.switching2.fontScale = 2;
		level.switching2.color = (1, 1, 0);
		level.switching2 setText(game["switching2"]);
	}
	else
	{
		level.switching = newHudElem();
		level.switching.x = 575;
		level.switching.y = 345;
		level.switching.alignX = "center";
		level.switching.alignY = "middle";
		level.switching.fontScale = 1;
		level.switching.color = (1, 1, 0);
		level.switching setText(game["switching"]);

		level.switching2 = newHudElem();
		level.switching2.x = 575;
		level.switching2.y = 365;
		level.switching2.alignX = "center";
		level.switching2.alignY = "middle";
		level.switching2.fontScale = 1;
		level.switching2.color = (1, 1, 0);
		level.switching2 setText(game["switching2"]);
	}
}



// WEAPON EXPLOIT FIX
DropSecWeapon()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{ 

		//drop weapons and make spec
		player = players[i];
		//players[i].pers["weapon"] = undefined;
		players[i].pers["weapon1"] = undefined;
		//players[i].pers["weapon2"] = undefined;
		//players[i].pers["spawnweapon"] = undefined;
	}

	game["dropsecondweap"] = false;
}

FlagNews(team, news)
{
	if (team == "axis")
	{
		if(isdefined(level.axflagnews))
			level.axflagnews destroy();

		level.axflagnews = newHudElem();
		level.axflagnews.x = 414;
		level.axflagnews.y = 417;
		level.axflagnews.alignX = "center";
		level.axflagnews.alignY = "middle";
		level.axflagnews.fontScale = 2;
		switch (news)
		{
			case "taken":
				level.axflagnews.color = (1, 0, 0);
				level.axflagnews setText(game["flagtaken"]);
				break;
			case "dropped":
				level.axflagnews.color = (1, 1, 0);
				level.axflagnews setText(game["flagdrop"]);
				break;
			case "returned":
				level.axflagnews.color = (0, 1, 0);
				level.axflagnews setText(game["flagret"]);
				break;
			default:
				break;
		}

		wait 7;

		if(isdefined(level.axflagnews))
			level.axflagnews destroy();
	}
	else
	{
		if(isdefined(level.alflagnews))
		level.alflagnews destroy();

		level.alflagnews = newHudElem();
		level.alflagnews.x = 222;
		level.alflagnews.y = 417;
		level.alflagnews.alignX = "center";
		level.alflagnews.alignY = "middle";
		level.alflagnews.fontScale = 2;
		switch (news)
		{
			case "taken":
				level.alflagnews.color = (1, 0, 0);
				level.alflagnews setText(game["flagtaken"]);
				break;
			case "dropped":
				level.alflagnews.color = (1, 1, 0);
				level.alflagnews setText(game["flagdrop"]);
				break;
			case "returned":
				level.alflagnews.color = (0, 1, 0);
				level.alflagnews setText(game["flagret"]);
				break;
			default:
				break;
		}

		wait 7;

		if(isdefined(level.alflagnews))
			level.alflagnews destroy();
	}
}

Create_HUD_RoundStart()
{
	level.round = newHudElem();
	level.round.x = 540;
	level.round.y = 360;
	level.round.alignX = "center";
	level.round.alignY = "middle";
	level.round.fontScale = 1;
	level.round.color = (1, 1, 0);
	level.round setText(game["round"]);		
		
	level.roundnum = newHudElem();
	level.roundnum.x = 540;
	level.roundnum.y = 380;
	level.roundnum.alignX = "center";
	level.roundnum.alignY = "middle";
	level.roundnum.fontScale = 1;
	level.roundnum.color = (1, 1, 0);
	round = game["roundsplayed"] +1;
	level.roundnum setValue(round);

	level.starting = newHudElem();
	level.starting.x = 540;
	level.starting.y = 400;
	level.starting.alignX = "center";
	level.starting.alignY = "middle";
	level.starting.fontScale = 1;
	level.starting.color = (1, 1, 0);
	level.starting setText(game["starting"]);
}

Destroy_HUD_RoundStart()
{
	if(isdefined(level.round))
		level.round destroy();
	if(isdefined(level.roundnum))
		level.roundnum destroy();
	if(isdefined(level.starting))
		level.starting destroy();
}



Create_HUD_TimeExp()
{
	if (getcvar("sv_scoreboard") == "big" || getcvar("sv_scoreboard") == "small")
	{
		level.timeexp = newHudElem();
		level.timeexp.x = 320;
		level.timeexp.y = 100;
		level.timeexp.alignX = "center";
		level.timeexp.alignY = "middle";
		level.timeexp.fontScale = 1.5;
		level.timeexp.color = (1, 1, 1);
		level.timeexp setText(game["timeexp"]);
	}
	else
	{
		level.timeexp = newHudElem();
		level.timeexp.x = 575;
		level.timeexp.y = 180;
		level.timeexp.alignX = "center";
		level.timeexp.alignY = "middle";
		level.timeexp.fontScale = 1.1;
		level.timeexp.color = (1, 1, 0);
		level.timeexp setText(game["timeexp"]);
	}

	wait 5;

	if(isdefined(level.timeexp))
		level.timeexp destroy();
}

Create_HUD_Live()
{
	for (i=0; i<6 ;i++)
	{
		if (i==0 || i==2 || i==4)
		{
			level.live = newHudElem();
			level.live.x = 597;
			level.live.y = 420;
			level.live.alignX = "center";
			level.live.alignY = "middle";
			level.live.fontScale = 1;
			level.live.color = (0, 1, 0);
			level.live setText(game["MatchLive"]);
		}
		else
		{
			if(isdefined(level.live))
				level.live destroy();
		}

		wait 1.5;
	}
}

Create_HUD_SuddenDeath()
{
	level.suddendeath = newHudElem();
	level.suddendeath.x = 320;
	level.suddendeath.y = 456;
	level.suddendeath.alignX = "center";
	level.suddendeath.alignY = "middle";
	level.suddendeath.fontScale = 1;
	level.suddendeath.color = (1, 0, 0);
	level.suddendeath setText(game["suddendeath"]);

	ruleset = getCvar("pam_mode");

	switch(ruleset)
	{
	case "twl_ladder":
		thread maps\mp\gametypes\rules\_twl_ladder_ctf_rules::SuddenDeathRules();
		break;
	case "twl_league":
		thread maps\mp\gametypes\rules\_twl_league_ctf_rules::SuddenDeathRules();
		break;
	case "ogl":
		thread maps\mp\gametypes\rules\_ogl_ctf_rules::SuddenDeathRules();
		break;
	case "cb":
		thread maps\mp\gametypes\rules\_cb_ctf_rules::SuddenDeathRules();
		break;
	case "cal":
		thread maps\mp\gametypes\rules\_cal_ctf_rules::SuddenDeathRules();
		break;
	case "twl_rifles":
		thread maps\mp\gametypes\rules\_twl_rifles_ctf_rules::SuddenDeathRules();
		break;
	case "twl_classic_ladder":
		thread maps\mp\gametypes\rules\_twl_classic_ladder_ctf_rules::SuddenDeathRules();
		break;
	case "twl_classic_league":
		thread maps\mp\gametypes\rules\_twl_classic_league_ctf_rules::SuddenDeathRules();
		break;

	case "pub":
	default:
		thread maps\mp\gametypes\rules\_public_ctf_rules::SuddenDeathRules();
		setCvar("pam_mode", "pub");
		break;
	}
}

checkSnipers()
{
	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();
}

Choose_Random_Side()
{
	//Step 1: Random Generator between Switch Sides / Same Sides
	randnum = randomInt(2);

	//Step 2: Display Result
	if (randnum == 0)
	{
		level.sameteams = newHudElem();
		level.sameteams.x = 575;
		level.sameteams.y = 130;
		level.sameteams.alignX = "center";
		level.sameteams.alignY = "middle";
		level.sameteams.fontScale = 1.5;
		level.sameteams.color = (1, 1, 0);
		level.sameteams setText(game["sameteams"]);

		iprintln("Use the ^3Same ^7sides for Overtime");
	}
	else
	{
		level.swapteams = newHudElem();
		level.swapteams.x = 575;
		level.swapteams.y = 130;
		level.swapteams.alignX = "center";
		level.swapteams.alignY = "middle";
		level.swapteams.fontScale = 1.5;
		level.swapteams.color = (1, 1, 0);
		level.swapteams setText(game["swapteams"]);

		iprintln("^3Swap ^7sides for Overtime");
	}

	level.forot = newHudElem();
	level.forot.x = 575;
	level.forot.y = 150;
	level.forot.alignX = "center";
	level.forot.alignY = "middle";
	level.forot.fontScale = 1.5;
	level.forot.color = (1, 1, 0);
	level.forot setText(game["forOT"]);

}

Prepare_map_Tie()
{
	otcount = getcvarint("g_ot_active");
	otcount = otcount + 1;
	setcvar("g_ot_active", otcount);
}

dropSniper()
{
	maps\mp\gametypes\_Check_Snipers::NoDropWeapon();
}

Create_HUD_Penalty(penalty)
{
	penaltyhud = newClientHudElem(self);
	penaltyhud.x = 590;
	penaltyhud.y = 415;
	penaltyhud.alignX = "center";
	penaltyhud.alignY = "middle";
	penaltyhud.fontScale = 1.1;
	penaltyhud.color = (1, 0, 0);
	penaltyhud setText(game["penalty"]);

	wait penalty;

	if(isdefined(penaltyhud))
		penaltyhud destroy();
}

Ready_UP()
{
	maps\mp\gametypes\_pam_readyup::PAM_Ready_UP();
}

Persistant_Scoreboard()
{
		// Display Team 1
		level.persteam1 = newHudElem();
		level.persteam1.x = 295;
		level.persteam1.y = 450;
		level.persteam1.alignX = "left";
		level.persteam1.alignY = "bottom";
		level.persteam1.fontScale = .75;
		level.persteam1.color = (1, 1, 1);
		level.persteam1.alpha = 1;
		level.persteam1 setText(game["dspteam1"]);

		//Team 1 Score Setup
		level.persscore1 = newHudElem();
		level.persscore1.x = 340;
		level.persscore1.y = 450;
		level.persscore1.alignX = "left";
		level.persscore1.alignY = "bottom";
		level.persscore1.fontScale = .75;
		level.persscore1.color = (1, 1, 1);
		level.persscore1.alpha = 1;

		// Display Team 2
		level.persteam2 = newHudElem();
		level.persteam2.x = 295;
		level.persteam2.y = 460;
		level.persteam2.alignX = "left";
		level.persteam2.alignY = "bottom";
		level.persteam2.fontScale = .75;
		level.persteam2.color = (1, 1, 1);
		level.persteam2.alpha = 1;
		level.persteam2 setText(game["dspteam2"]);

		//Team 2 Score Setup
		level.persscore2 = newHudElem();
		level.persscore2.x = 340;
		level.persscore2.y = 460;
		level.persscore2.alignX = "left";
		level.persscore2.alignY = "bottom";
		level.persscore2.fontScale = .75;
		level.persscore2.color = (1, 1, 1);
		level.persscore2.alpha = 1;

	while (!level.roundended)
	{
		if (game["halftimeflag"] == "1")
		{
			level.persscore1 setValue(game["alliedscore"]);
			level.persscore2 setValue(game["axisscore"]);
		}
		else
		{
			level.persscore1 setValue(game["axisscore"]);
			level.persscore2 setValue(game["alliedscore"]);
		}

		wait 1;
	}

	if(isdefined(level.persteam1))
		level.persteam1 destroy();
	if(isdefined(level.persteam2))
		level.persteam2 destroy();
	if(isdefined(level.persscore1))
		level.persscore1 destroy();
	if(isdefined(level.persscore2))
		level.persscore2 destroy();
}
