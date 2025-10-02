PamMain() // Starts when map is loaded.
{
	// init the spawn points first because if they do not exist then abort the game
	// Set up the spawnpoints of the "allies"
	if ( !maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_uo_spawn_allies", 1) )
		return;
	// Set up the spawnpoints of the "axis"
	if ( !maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_uo_spawn_axis", 1) )
		return;

	// Make sure the intermission spawn is there
	if ( !maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_dom_intermission", 1, 1) )
		return;

	// set up secondary spawn points but don't abort if they are not there
	maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_uo_spawn_allies_secondary");
	maps\mp\gametypes\_spawnlogic_gmi::InitSpawnPoints("mp_uo_spawn_axis_secondary");

	maps\mp\gametypes\_rank_gmi::InitializeBattleRank();
	maps\mp\gametypes\_secondary_gmi::Initialize();
	
	// set some values for the icon positions
	game["flag_icons_w"] = 32;
	game["flag_icons_h"] = 32;
	game["flag_icons_x"] = 320 - ( game["flag_icons_w"] * 2.5 );  // defaults to five flags changed later for actual flag count
	game["flag_icons_y"] = 480 - game["flag_icons_h"];
	
	level.callbackStartGameType = ::Callback_StartGameType; // Set the level to refer to this script when called upon.
	level.callbackPlayerConnect = ::Callback_PlayerConnect; // Set the level to refer to this script when called upon.
	level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect; // Set the level to refer to this script when called upon.
	level.callbackPlayerDamage = ::Callback_PlayerDamage; // Set the level to refer to this script when called upon.
	level.callbackPlayerKilled = ::Callback_PlayerKilled; // Set the level to refer to this script when called upon.

	maps\mp\gametypes\_callbacksetup::SetupCallbacks(); // Run this script upon load.

	allowed[0] = "flag_cap"; 
	allowed[1] = "dom"; 	
	maps\mp\gametypes\_gameobjects::main(allowed); // Take the "allowed" array and apply it to this script. which just deletes all of the objects that do not have script_objectname set to any of the allowed arrays. Ex. allowed[0].

	level.mapname = getcvar("mapname");
	maps\mp\gametypes\_pam_utilities::NonstockPK3Check();

	if(getCvar("scr_dom_timelimit") == "")		// Time limit per map
		setCvar("scr_dom_timelimit", "0");
	else if(getCvarFloat("scr_dom_timelimit") > 1440)
		setCvar("scr_dom_timelimit", "1440");
	level.timelimit = getCvarFloat("scr_dom_timelimit");
	setCvar("ui_dom_timelimit", level.timelimit);
	makeCvarServerInfo("ui_dom_timelimit", "0");

	if(getCvar("scr_dom_scorelimit") == "")		// Score limit per map
		setCvar("scr_dom_scorelimit", "0");
	level.scorelimit = getCvarint("scr_dom_scorelimit");
	setCvar("ui_dom_scorelimit", getCvar("scr_dom_scorelimit"));
	makeCvarServerInfo("ui_dom_scorelimit", "0");
		
	if(getCvar("scr_friendlyfire") == "")		// Friendly fire
		setCvar("scr_friendlyfire", "1");	//default is ON

	if(getCvar("scr_dom_startrounddelay") == "")	// Time to wait at the begining of the round
		setCvar("scr_dom_startrounddelay", "15");
	if(getCvar("scr_dom_endrounddelay") == "")		// Time to wait at the end of the round
		setCvar("scr_dom_endrounddelay", "10");

	if(getCvar("scr_drawfriend") == "")		// Draws a team icon over teammates, default is on.
		setCvar("scr_drawfriend", "1");
	level.drawfriend = getCvarint("scr_drawfriend");

	if(getCvar("scr_battlerank") == "")		// Draws the battle rank.  Overrides drawfriend.
		setCvar("scr_battlerank", "1");	//default is ON
	level.battlerank = getCvarint("scr_battlerank");
	setCvar("ui_battlerank", level.battlerank);
	makeCvarServerInfo("ui_battlerank", "0");

	if(getCvar("scr_dom_clearscoreeachround") == "")	// clears everyones score between each round if true
		setCvar("scr_dom_clearscoreeachround", "1");
	setCvar("ui_dom_clearscoreeachround", getCvar("scr_dom_clearscoreeachround"));
	makeCvarServerInfo("ui_dom_clearscoreeachround", "0");

	if(getCvar("scr_shellshock") == "")		// controls whether or not players get shellshocked from grenades or rockets
		setCvar("scr_shellshock", "1");
	setCvar("ui_shellshock", getCvar("scr_shellshock"));
	makeCvarServerInfo("ui_shellshock", "0");
			
	if(getCvar("g_allowvote") == "")		// Ability to cast votes.
		setCvar("g_allowvote", "1");	
	level.allowvote = getCvarint("g_allowvote");
	setCvar("scr_allow_vote", level.allowvote);

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

		level.ruleset = getCvar("pam_mode");
		switch(level.ruleset)
		{
		case "twl":
			thread maps\mp\gametypes\rules\_twl_dom_rules::Rules();
			break;
		case "lan":
			thread maps\mp\gametypes\rules\_lan_dom_rules::Rules();
			break;
		
		default:
			thread maps\mp\gametypes\rules\_public_dom_rules::Rules();
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

	if(getcvar("sv_warmupmines") == "")			// warmup mines off/on
		setcvar("sv_warmupmines", "1");	

	//Turn off OT for pub mode
	if(getcvar("g_ot") == "" || game["mode"] == "pub")
		setcvar("g_ot", "0");

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

	if(getCvar("scr_showicons") == "")		// flag icons on or off
		setCvar("scr_showicons", "1");

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
	
	// This controls the delay for respawning reinforcement waves.
	if(getCvar("scr_dom_respawn_wave_time") == "")	
		setCvar("scr_dom_respawn_wave_time", "10");
	else if(getCvarFloat("scr_dom_respawn_wave_time") < 1)
		setCvar("scr_dom_respawn_wave_time", "1");
	level.respawn_wave_time = getCvarint("scr_dom_respawn_wave_time");
	level.respawn_timer["axis"] = level.respawn_wave_time;
	level.respawn_timer["allies"] = level.respawn_wave_time;
	
	if(!isDefined(game["compass_range"]))		// set up the compass range.
		game["compass_range"] = 1024;		
	setCvar("cg_hudcompassMaxRange", game["compass_range"]);

	if(!isDefined(game["dom_allies_obj_text"]))		
		game["dom_allies_obj_text"] = (&"GMI_DOM_OBJ_ALLIES");
	if(!isDefined(game["dom_axis_obj_text"]))		
		game["dom_axis_obj_text"] = (&"GMI_DOM_OBJ_AXIS");
	if(!isDefined(game["dom_spectator_obj_text"]))		
		game["dom_spectator_obj_text"] = (&"GMI_DOM_OBJ_SPECTATOR");
	
	if (!isdefined (game["BalanceTeamsNextRound"]))
		game["BalanceTeamsNextRound"] = false;

	level.allowcaptures = false;
	level.roundstarted = false;			// Set up level.roundstarted to be false, until both teams have 1 person.
	level.roundended = false;			// Set up level.roundended to be false, until the round has ended, this will be taken out, since there will not be a timelimit to rounds.
	level.mapended = false;				// Set up level.mapended to be false, until the overall timelimit is finished.
	
	level.exist["allies"] = 0; 	// This is a level counter, used when clients choose a team.
	level.exist["axis"] = 0; 	// This is a level counter, used when clients choose a team.
	level.exist["teams"] = false;
	level.didexist["allies"] = false;
	level.didexist["axis"] = false;
	level.death_pool["allies"] = 0; // Sets the allies death pool to 0.
	level.death_pool["axis"] = 0; // Sets the axis death pool to 0.
	level.flagcount = 1; // Used to count how many flags are in the level.
	level.max_flag_count = 15;  // this is the limit of the amount of flags in one level
	
	level.healthqueue = [];
	level.healthqueuecurrent = 0;

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

	if(!isdefined(game["halftimeflag"]))
	{
		game["dolive"] = "0";
		game["halftimeflag"] = "0";
		game["round1alliesscore"] = 0;
		game["round1axisscore"] = 0; 
		game["round2alliesscore"] = 0;
		game["round2axisscore"] = 0;
		game["team1score"] = 0;
		game["team2score"] = 0;
		game["firsthalfready"] = 0;
		game["readyup"] = 0;
		game["axismatchscore"] = 0;
		game["alliesmatchscore"] = 0;
	}

	//Ready-Up
	level.R_U_Name = [];
	level.R_U_State = [];
	level.rdyup = 0;

	level.warmup = 0;
	level.hithalftime = 0;
	level.playersready = false;
	level.allowautobalance = true;

	//Message Center
	if(game["mode"] != "match" && getCvar("sv_messagecenter") != "0")
		thread maps\mp\gametypes\_message_center::messages();

	//PAM UO Admin Tools
	thread maps\mp\gametypes\_pam_admin::main();

	// 
	// DEBUG
	//
	if(getCvar("scr_debug_dom") == "")
		setCvar("scr_debug_dom", "0"); 
	if(getCvar("scr_debug_dom") != "0")
	{		
		setCvar("scr_dom_startrounddelay", "5");
		setCvar("scr_dom_respawn_wave_time", "10");
	}
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

		if(!isDefined(game["dom_layoutimage"])) // If not defined, set the game["layoutimage"] to default. usually this is set in the mapname.gsc
			game["dom_layoutimage"] = "default";

		layoutname = "levelshots/layouts/hud@layout_" + game["dom_layoutimage"]; // Set layoutname to be hud@layout_"whatever game["layoutimage"]" is.

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
		game["first"] = &"First";
		precacheString(game["first"]);
		game["second"] = &"Second";
		precacheString(game["second"]);
		game["half"] = &"Half";
		precacheString(game["half"]);
		game["starting"] = &"Starting";
		precacheString(game["starting"]);

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

		// Random Team Announcements
		game["forOT"] = &"For OT";
		precacheString(game["forOT"]);
		game["sameteams"]=&"Same Sides";
		precacheString(game["sameteams"]);
		game["swapteams"]=&"Swap Sides";
		precacheString(game["swapteams"]);

		// Flag Cap Hud Elements
		game["hudallcap"] = &"Capped ALL Flags";
		precacheString(game["hudallcap"]);
		game["hudaxis"] = &"Axis";
		precacheString(game["hudaxis"]);
		game["hudallies"] = &"Allies";
		precacheString(game["hudallies"]);
		game["hudpoints"] = &"Points!";
		precacheString(game["hudpoints"]);
		game["colon"] = &":";
		precacheString(game["colon"]);
		game["resetmap"] = &"Reseting Map";
		precacheString(game["resetmap"]);
		/* end PAM precacheStrings */
		
		precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");
		precacheString(&"MPSCRIPT_KILLCAM");
		precacheString(&"MPSCRIPT_ALLIES_WIN");
		precacheString(&"MPSCRIPT_AXIS_WIN");
		// GMI STRINGS
		precacheString(&"GMI_MP_CEASEFIRE");
		precacheString(&"GMI_DOM_MATCHSTARTING");
		precacheString(&"GMI_DOM_MATCHRESUMING");
		precacheString(&"GMI_DOM_OBJ_SPECTATOR_ALLIES");
		precacheString(&"GMI_DOM_OBJ_SPECTATOR_AXIS");
		precacheString(&"GMI_DOM_ALLIES_CAP_FLAG_SOLO");
		precacheString(&"GMI_DOM_ALLIES_CAP_FLAG_TEAM");
		precacheString(&"GMI_DOM_AXIS_CAP_FLAG_SOLO");
		precacheString(&"GMI_DOM_AXIS_CAP_FLAG_TEAM");
		precacheString(&"GMI_DOM_OBJ_ALLIES");
		precacheString(&"GMI_DOM_OBJ_AXIS");
		precacheString(&"GMI_MP_YOU_WILL_SPAWN_WITH_AN_NEXT");
		precacheString(&"GMI_MP_YOU_WILL_SPAWN_WITH_A_NEXT");
		precacheString(&"GMI_DOM_WAIT_TILL_MATCHSTART");
		precacheString(&"GMI_DOM_CAPTURING_FLAG");
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
		precacheString(&"GMI_DOM_UNNAMED_FLAG0");
		precacheString(&"GMI_DOM_UNNAMED_FLAG1");
		precacheString(&"GMI_DOM_UNNAMED_FLAG2");
		precacheString(&"GMI_DOM_UNNAMED_FLAG3");
		precacheString(&"GMI_DOM_UNNAMED_FLAG4");
		precacheString(&"GMI_DOM_ALLIEDMISSIONACCOMPLISHED");
		precacheString(&"GMI_DOM_AXISMISSIONACCOMPLISHED");
		
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

		game["hud_ring"] = "gfx/hud/hudadd@dom_ring.dds";
		game["hud_axis_flag"] = "gfx/hud/hud@dom_g.dds";
		game["hud_neutral_flag"] = "gfx/hud/hud@dom_n.dds";
		
		// set up team specific variables
		switch( game["allies"])
		{
		case "british":
			game["hud_allies_radar"] = "gfx/hud/hud@objective_british";
			game["hud_allies_flag"] = "gfx/hud/hud@dom_b.dds";
			
			game["sound_allies_victory_vo"] = "MP_announcer_allies_win";
			game["sound_allies_victory_music"] = "uk_victory";
			game["sound_allies_area_secure"] = "uk_area_secured";
			game["sound_allies_ground_taken"] = "uk_ground_taken";
			game["sound_allies_enemy_has_taken_flag"] = "uk_lost_ground";
			game["sound_allies_enemy_is_taking_flag"] = "uk_losing_ground";
			break;
		case "russian":
			game["hud_allies_radar"] = "gfx/hud/hud@objective_russian";
			game["hud_allies_flag"] = "gfx/hud/hud@dom_r.dds";

			game["sound_allies_victory_vo"] = "MP_announcer_allies_win";
			game["sound_allies_victory_music"] = "ru_victory";
			game["sound_allies_area_secure"] = "ru_area_secured";
			game["sound_allies_ground_taken"] = "ru_ground_taken";
			game["sound_allies_enemy_has_taken_flag"] = "ru_lost_ground";
			game["sound_allies_enemy_is_taking_flag"] = "ru_losing_ground";
			break;
		default:		// default is american
			game["hud_allies_radar"] = "gfx/hud/hud@objective_american";
			game["hud_allies_flag"] = "gfx/hud/hud@dom_us.dds";

			game["sound_allies_victory_vo"] = "MP_announcer_allies_win";
			game["sound_allies_victory_music"] = "us_victory";
			game["sound_allies_area_secure"] = "us_area_secured";
			game["sound_allies_ground_taken"] = "us_ground_taken";
			game["sound_allies_enemy_has_taken_flag"] = "us_lost_ground";
			game["sound_allies_enemy_is_taking_flag"] = "us_losing_ground";
			break;
		}

		game["sound_axis_victory_vo"] = "MP_announcer_axis_win";
		game["sound_axis_victory_music"] = "ge_victory";
		game["sound_axis_area_secure"] = "ge_area_secured";
		game["sound_axis_ground_taken"] = "ge_ground_taken";
		game["sound_axis_enemy_has_taken_flag"] = "ge_lost_ground";
		game["sound_axis_enemy_is_taking_flag"] = "ge_losing_ground";
	
		game["sound_round_draw_vo"] = "MP_announcer_round_draw";

		game["hud_neutral_radar"] = "gfx/hud/hud@objective_gray";
		game["hud_capping_radar"] = "gfx/hud/objective_yellow";
		game["hud_axis_radar"] = "gfx/hud/hud@objective_german";
		
		// victory images
		if ( !isDefined( game["hud_allies_victory_image"] ) )
			game["hud_allies_victory_image"] = "gfx/hud/allies_win";
		if ( !isDefined( game["hud_axis_victory_image"] ) )
			game["hud_axis_victory_image"] = "gfx/hud/axis_win";
		
		precacheShader(game["hud_axis_flag"]);
		precacheShader(game["hud_allies_flag"]);

		precacheShader(game["hud_neutral_radar"]);
		precacheShader(game["hud_neutral_radar"]+ "_up");
		precacheShader(game["hud_neutral_radar"]+ "_down");
		precacheShader(game["hud_capping_radar"]);
		precacheShader(game["hud_capping_radar"]+ "_up");
		precacheShader(game["hud_capping_radar"]+ "_down");
		precacheShader(game["hud_allies_radar"]);
		precacheShader(game["hud_allies_radar"]+ "_up");
		precacheShader(game["hud_allies_radar"]+ "_down");
		precacheShader(game["hud_axis_radar"]);
		precacheShader(game["hud_axis_radar"]+ "_up");
		precacheShader(game["hud_axis_radar"]+ "_down");

		// GMI FLAG MATCH IMAGES:
		precacheShader(game["hud_ring"]);
		precacheShader(game["hud_axis_flag"]);
		precacheShader(game["hud_allies_flag"]);
		precacheShader(game["hud_neutral_flag"]);
		precacheShader("hudStopwatch");
		precacheShader("hudStopwatchNeedle");
		precacheShader(game["hud_allies_victory_image"]);
		precacheShader(game["hud_axis_victory_image"]);
		precacheItem("item_health");
			
	
		maps\mp\gametypes\_pam_teams::precache(); // Precache weapons.
		maps\mp\gametypes\_pam_teams::scoreboard(); // Precache scoreboard menu.
		
		// if fs_copyfiles is set then we are building paks and cache everything
		if ( getcvar("fs_copyfiles") == "1")
		{
			precacheShader("gfx/hud/hud@dom_b.dds");
			precacheShader("gfx/hud/hud@dom_r.dds");
			precacheShader("gfx/hud/hud@dom_us.dds");
			precacheShader("gfx/hud/hud@dom_g.dds");

			precacheShader("gfx/hud/hud@objective_british");
			precacheShader("gfx/hud/hud@objective_british_up");
			precacheShader("gfx/hud/hud@objective_british_down");
			precacheShader("gfx/hud/hud@objective_russian");
			precacheShader("gfx/hud/hud@objective_russian_up");
			precacheShader("gfx/hud/hud@objective_russian_down");
			precacheShader("gfx/hud/hud@objective_american");
			precacheShader("gfx/hud/hud@objective_american_up");
			precacheShader("gfx/hud/hud@objective_american_down");
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

	Flag_InitTriggers();
	Flag_StartThinking(); // Start the Flag_StartThinking thread. This sets up the flags for primetime.

	thread Flag_AllCapturedThink();

	thread drawFlagsOnCompass();
	thread maps\mp\gametypes\_secondary_gmi::SetupSecondaryObjectives();

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

	// set the cvar for the map quick bind
	self setClientCvar("g_scriptQuickMap", game["menu_viewmap"]);
	
	if(game["state"] == "intermission")
	{
		SpawnIntermission();
		return;
	}

	level endon("intermission");

	// make sure that the rank variable is initialized
	if ( !isDefined( self.pers["rank"] ) )
		self.pers["rank"] = 0;

	//JS setup teamkiller tracking
	if(!isDefined(self.teamkiller) || self.teamkiller != 0)
		self.teamkiller = 0;
	if(!isDefined(self.teamkillertotal) || self.teamkillertotal != 0)
		self.teamkillertotal = 0;
	if(!isDefined(self.wereteamkilled))
		self.wereteamkilled = 0;
		
		
	if(isDefined(self.pers["team"]) && self.pers["team"] != "spectator")
	{
		self setClientCvar("ui_weapontab", "1");

		maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();

		if(self.pers["team"] == "allies")
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
		else
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);

		if(isDefined(self.pers["weapon"]))
			spawnPlayer();
		else
		{
			self.sessionteam = "spectator";

			SpawnSpectator();
			maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();

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
			
		if(menu == game["menu_team"] ) // && self.teamkiller != 1)	//JS check to make sure they're not trying to switch teams while in TK limbo

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

//			if(isDefined(self.pers["weapon"]) && self.pers["weapon"] == weapon && !isDefined(self.pers["weapon1"]))
//				continue;

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
	self endon("spawned");

	if(self.sessionteam == "spectator")
		return;

	// reset the progress bar stuff
	self.progresstime = 0;
	self.view_bar = 0;

	self Player_ClearHud();
	
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

	self.sessionstate = "dead";
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
		// check to see if they were killed in the process of capping the flag
		capping = Capture_CheckCappingFlag(self);
		
		if(attacker == self) // killed himself
		{
			doKillcam = false;

			if ( !level.roundended && !isdefined (self.autobalance) )
			{
				attacker.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetSuicidePoints();
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
					attacker.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetTeamKillPoints();

					// mark the teamkiller as such, punish him next time he dies.
					attacker.teamkiller = 1;
					attacker.teamkillertotal ++;
					self.wereteamkilled = 1;
				}
				// if the dead person was capping then give the killer a defense bonus
				else if ( capping )
				{
					attacker.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetDefensePoints();

					// WORM Addition to give Team Points for Kills IF on
					if (game["TeamPointsForKill"] > 0)
					{
						if (attacker.pers["team"] == "allies")
						{
							game["alliedscore"] = game["alliedscore"] + game["TeamPointsForKill"];
							setTeamScore("allies", game["alliedscore"]);
						}
						else
						{
							game["axisscore"] = game["axisscore"] + game["TeamPointsForKill"];
							setTeamScore("axis", game["axisscore"]);
						}
					}
				}
				else
				{
					attacker.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetKillPoints();;

					// WORM Addition to give Team Points for Kills IF on
					if (game["TeamPointsForKill"] > 0)
					{
						if (attacker.pers["team"] == "allies")
						{
							game["alliedscore"] = game["alliedscore"] + game["TeamPointsForKill"];
							setTeamScore("allies", game["alliedscore"]);
						}
						else
						{
							game["axisscore"] = game["axisscore"] + game["TeamPointsForKill"];
							setTeamScore("axis", game["axisscore"]);
						}
					}
				}
			}
		}
		
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

		if ( !isdefined(eInflictor) )
			self.pers["score"] += maps\mp\gametypes\_scoring_gmi::GetNoAttackerKillPoints();

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
		self dropItem(self getcurrentweapon());

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
		time_to_respawn = level.respawn_timer[self.pers["team"]] - 1;
		
		self thread maps\mp\gametypes\_killcam_gmi::DisplayKillCam(who_to_watch, time_to_respawn, delay);	
	}
	else
	{
		currentorigin = self.origin;
		currentangles = self.angles;

		self thread spawnSpectator(currentorigin + (0, 0, 60), currentangles);
	}
	
	self thread respawn();	
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
			}
		}
	}
	//JS If the player is alive and playing during a round, don't give the new weapon for now.  We'll give it to the player next time he spawns.
	else if( (self.sessionteam == self.pers["team"] || self.pers["team"] == "spectator" ) && game["matchstarted"] == true && level.roundstarted == true)
	{
		if(isDefined(self.pers["weapon"]))
		{
			self.nextroundweapon = weapon;
		}
			
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
	
		if(self.sessionstate != "playing")
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
// FLAG FUNCTIONS
// ----------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------
//	Flag_Initialize
//
// 		Sets up a flag
// ----------------------------------------------------------------------------------
Flag_Initialize(flag)
{
	flag.team = "neutral";
	flag.allies = 0;
	flag.axis = 0;
	flag.progresstime = 0;
	flag.axis_capping = 0;
	flag.allies_capping = 0;
	flag.capping = 0;
	flag.last_capping = 0;
	flag.scale = 0;
	flag.radarupdated = 0;
	flag.beingcapped = false;
	
	// now see if we can find any props that need to be turned off 
	props = getentarray("flag" + flag.id + "stuff_allies", "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] hide();
	}

	// now see if we can find any props that need to be turned on 
	props = getentarray("flag" + flag.id + "stuff_axis", "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] hide();
	}

	// now see if we can find any props that need to be turned on 
	props = getentarray("flag" + flag.id + "stuff_neutral", "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] show();
	}
	
	// start special flag sounds playing if there are any
	sound_maker = getent("flag"+ flag.id + "radio" ,"targetname");
	if (isDefined(sound_maker) && isDefined(game["neutralradio"]))
	{
		sound_maker playloopsound( game["neutralradio"]);
	}	
}

// ----------------------------------------------------------------------------------
//	Flag_InitTriggers
//
// 		Sets up all of the flag triggers with an id and a description
// ----------------------------------------------------------------------------------
Flag_InitTriggers()
{
	// Setting up the flag TRIGGERS
	for(q=1;q<level.max_flag_count;q++) // Makes the flag limit of 15, then searches for all of the flags in the map.
	{
		current_flag = getent("flag" + q,"targetname");
		if(!isDefined(current_flag)) // If the flag exists, then proceed. Which then tells all of the allies and axis flag to be hidden.
		{
			continue;
		}
		level.flagcount++;

		getent("flag" + q + "_allies","targetname") hide();
		getent("flag" + q + "_axis","targetname") hide();

		if(!isDefined(current_flag.script_idnumber) || current_flag.script_idnumber == 0)
		{
			current_flag.script_idnumber = q;
		}

		if(!isDefined(current_flag.description)) // If a flag has no description set, randomly pick something silly.
		{
			n = randomint(5);
			switch(n)
			{
				case 0:
					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG0");
					break;
				case 1:
					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG1");
					break;
				case 2:
					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG2");
					break;
				case 3:
					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG3");
					break;
				case 4:
					current_flag.description = (&"GMI_DOM_UNNAMED_FLAG4");
					break;
			}
								
		}
	}

	if (level.flagcount == 1) // If no flags are found, then error out.
	{
		maps\mp\_utility::error("THERE ARE NO FLAGS IN MAP");
	}
	
	// set the x position of the first flag icon
	game["flag_icons_x"] = 320 - ( game["flag_icons_w"] * (level.flagcount - 1 ) * 0.5 );  

}

// ----------------------------------------------------------------------------------
//	Flag_StartThinking
//
// 		Sets up the flags and then starts the think loop for each one
// ----------------------------------------------------------------------------------
Flag_StartThinking()
{
	//worm
	if (!isdefined(game["scoreinterval"]) )
	{

		if (getcvar("scr_dom_scoreinterval") == "")
		{
			iprintln("No Mod Scoring Rules Detected, Inserting Sample Scoring Rules");

			game["scoreinterval"] = 30;

			game["tier6time"] = 0;
			game["tier5time"] = 39;
			game["tier4time"] = 24;
			game["tier3time"] = 14;
			game["tier2time"] = 4;

			game["tier6score"] = 0;
			game["tier5score"] = 20;
			game["tier4score"] = 4;
			game["tier3score"] = 3;
			game["tier2score"] = 2;
			game["tier1score"] = 1;

			game["TeamCapPoints"] = 0;
			game["TeamCapAllPoints"] = 15;
			game["TeamPointsForKill"] = 0;
		}
		else
		{
			game["scoreinterval"] = getcvarint("scr_dom_scoreinterval");
			if (game["scoreinterval"] < 5)
				game["scoreinterval"] = 5;

			game["tier6time"] = getcvarint("scr_dom_tier6interval");
			game["tier5time"] = getcvarint("scr_dom_tier5interval");
			game["tier4time"] = getcvarint("scr_dom_tier4interval");
			game["tier3time"] = getcvarint("scr_dom_tier3interval");
			game["tier2time"] = getcvarint("scr_dom_tier2interval");

			game["tier6score"] = getcvarint("scr_dom_tier6score");
			game["tier5score"] = getcvarint("scr_dom_tier5score");
			game["tier4score"] = getcvarint("scr_dom_tier4score");
			game["tier3score"] = getcvarint("scr_dom_tier3score");
			game["tier2score"] = getcvarint("scr_dom_tier2score");
			game["tier1score"] = getcvarint("scr_dom_tier1score");

			game["TeamCapPoints"] = getcvarint("scr_dom_CapturePoints");
			game["TeamCapAllPoints"] = getcvarint("scr_dom_CaptureAllPoints");
			game["TeamPointsForKill"] = getcvarint("scr_dom_KillPoints");
		}
	}


	for(q=1;q<level.flagcount;q++)
	{
		flag = getent("flag"+q,"targetname");
		
		flag.id = q;
		Flag_Initialize(flag);
				
		if(flag.script_idnumber < 0 || flag.script_idnumber > level.flagcount )
		{
			maps\mp\_utility::error("Bad script_idnumber " + script_idnumber + " for flag " + q);
		}
		
		SetupFlagIcon(flag);
		flag thread Flag_ZoneThink();
		flag thread Comp_Flag_Scoring(q);
	}
}

// ----------------------------------------------------------------------------------
//	Flag_ZoneThink
//
// 		This is continually called for each flag.  This lets the flag determine
//		if it is being captured
// ----------------------------------------------------------------------------------
Flag_ZoneThink()
{
	level endon("round_ended");

	if(!isDefined(self.script_timer))
		self.script_timer = 10;

	name = "blah";
	count = 1;
	
	for(;;)
	{
		if(self.capping == 0 || level.roundended)
		{
			self Capture_Canceled();
			self waittill("trigger", other);		
		}

		if(game["matchstarted"] == false || level.roundstarted == false)
		{
			count -= 1;
			if(count == 0)
			{
				other iprintln(&"GMI_DOM_WAIT_TILL_MATCHSTART");
				count = 100;
			}
			wait 0.05;
			continue;
		}

		// zero out the flag capping count
		self.capping = 0;
		self.allied_capping = 0;
		self.axis_capping = 0;
		
		players = getentarray("player", "classname");
		
		// count up the people in the flag area
		for(i = 0; i < players.size; i++)
		{
			player = players[i];

			if(isAlive(player) && (player istouching(self)) && !(player isinvehicle()) )
			{
				if(player.pers["team"] == "allies")
				{
					self.allied_capping++;
				}
				else if(player.pers["team"] == "axis")					
				{
					self.axis_capping++;		
				}
			}
		}
		
		self.capping = self.allied_capping - self.axis_capping;	
	
		// set this variable if only one team is currently trying to cap
		one_team = 0;
		if ( self.allied_capping == 0 || self.axis_capping == 0 )
		{ 
			if ( self.allied_capping != 0 && self.team != "allies" )
			{
				one_team = 1;
			}
			else if ( self.axis_capping != 0 && self.team != "axis" )
			{
				one_team = 1;
			}
		}
		
		if (!level.allowcaptures)
			one_team = 0;

		// is only one team trying to cap?
		if ( one_team )
		{
			// now each player need to have their flag progress bar started
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
	
				if(isAlive(player) && player istouching(self))
				{
					if(!isDefined(player.pers["capture_process_thread"]))
						player.pers["capture_process_thread"] = 0;
	
					// if this flag is set then the player is currently already displaying the flag info
					if (player.pers["capture_process_thread"] == 1)
						continue;
						
					player.pers["capture_process_thread"] = 1;
					player thread Capture_PlayerCappingFlag(self);
				}
			}
	
			// if this just started being capped then update the radar
			if ( !self.beingcapped )
			{
				self.radarupdated = false;
			}
			self.beingcapped = true;
			
			if (self.capping > 0)
			{
				self.progresstime += (0.05) * ((1 + (self.capping - 1) * 0.5 ));
				if(self.capping == 1)
				{
					name = other;
				}
			}
			else if (self.capping < 0)
			{
				self.progresstime +=  (0.05) * ((1 + (-1 * self.capping - 1) * 0.5 ));
				if(self.capping == -1)
				{
					name = other;
				}
			}

			self.scale = (self.progresstime / self.script_timer);
		}
		else
		{
			self Capture_Canceled();
			wait 0.05;
		}	

//			self.blinking_icon.x  =-64;	//	move off
//			self.blinking_icon.y = -64;
		
		// display the screen icons
		if (game["showicons"] && self.scale > 0.00001)
		{
			if(!isDefined(self.capping_icon))
			{
				self.capping_icon = newHudElem();
				self.capping_icon.alignX = "left";
				self.capping_icon.alignY = "top";
				self.capping_icon.x =game["flag_icons_x"] + (self.script_idnumber * game["flag_icons_w"]) - game["flag_icons_h"];
				self.capping_icon.y = game["flag_icons_y"];
				self.capping_icon.sort = 0.5;  // To fix a stupid bug, where the first flag icon (or the one to the furthest left) will not sort through the capping icon. BAH!
			}

			if (!isDefined(self.blinking_icon))
			{
				self.blinking_icon = newHudElem();
				self.blinking_icon.alignX ="left";
				self.blinking_icon.alignY ="top";
				self.blinking_icon.x =game["flag_icons_x"] + (self.script_idnumber * game["flag_icons_w"]) - game["flag_icons_h"];
				self.blinking_icon.y = game["flag_icons_y"];
				self.blinking_icon.sort = 0.7;  // To fix a stupid bug, where the first flag icon (or the one to the furthest left) will not sort through the capping icon. BAH!
			}

			if(self.scale * game["flag_icons_w"] >= 1)
			{

				//	we need to clamp this to int values and back to float 
				//	this is because just using float values is TOOO smooth 
				capping_int	= (int)(self.scale * 32);

			
				capping_float = (float)capping_int / 32.0;
			
				switch((capping_int/2) % 2)
				{
					case	0:	self.blinking_icon.color = (1,1,0);
							break;
					case	1:	self.blinking_icon.color = (0,0,0);
							break;
				}
				self.blinking_icon setShader(game["hud_ring"], 32,32);

				if(self.capping > 0)
				{
					self.capping_icon setShader(game["hud_allies_flag"], game["flag_icons_w"], self.scale * game["flag_icons_h"],1.0,capping_float);
				}
				else
				{
					self.capping_icon setShader(game["hud_axis_flag"], game["flag_icons_w"], self.scale * game["flag_icons_h"],1.0,capping_float);
				}
			}

		}

		self.last_capping = self.capping;
		if(self.scale >= 0.999999)
		{
			cappers = self.capping;
			
			if(self.capping > 0)
			{
				self thread Capture_AlliesCappedFlag(cappers,name);
			}
			else
			{
				self thread Capture_AxisCappedFlag(cappers,name);
			}
			
			other.score = other.pers["score"];
			
			self Capture_Canceled();
		}
		wait 0.05;
	}


}

// ----------------------------------------------------------------------------------
//	Flag_AllCapturedThink
//
// 	Continually checks to see if all of the flags have been captured.
// ----------------------------------------------------------------------------------
Flag_AllCapturedThink()
{
	// WORM Modified for scoring my way
	if (game["TeamCapAllPoints"] <= 0)
		return;
	
	allflagsheld = false;
	flags = level.flagcount - 1;
	for(;;)
	{
		flag_count_allied = 0;
		flag_count_axis = 0;
		for(q=1;q<level.flagcount;q++)
		{
			flag = getent("flag"+q,"targetname");
			
			if(flag.team == "allies" && !flag.beingcapped)
			{
				flag_count_allied++;
			}
			else if(flag.team == "axis" && !flag.beingcapped)
			{
				flag_count_axis++;
			}
		}

		if(flag_count_allied == flags && !allflagsheld)
		{
			allflagsheld = true;
			thread AllCap("allies");
		}
		else if(flag_count_axis == flags && !allflagsheld)
		{
			allflagsheld = true;
			thread AllCap("axis");
		}
		
		if (flag_count_allied != flags && flag_count_axis != flags)
		{
			flagbeingcapped = false;

			for(q=1;q<level.flagcount;q++)
			{
				flag = getent("flag"+q,"targetname");

				if (flag.beingcapped)
					flagbeingcapped = true;
			}

			if (!flagbeingcapped)
				allflagsheld = false;
		}

		
		wait .5;
	}
}

// ----------------------------------------------------------------------------------
// CAPTURE FUNCTION
// ----------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------
//	Capture_AlliesCappedFlag
//
// 		Gets called when the allies cap a flag.  Displays the appropriate flag.
//		Also displays the cap messages.
// ----------------------------------------------------------------------------------
Capture_AlliesCappedFlag(cappers,name)
{
	self notify("captured");
	
	old_team = self.team;
	self.team = "allies";
	self.radarupdated = 0;	

	//play the flag taken vo on all players.  
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(player.pers["team"] == "allies")
		{
			if ( old_team != "axis" )
				player playLocalSound(game["sound_allies_area_secure"]);
			else
				player playLocalSound(game["sound_allies_ground_taken"]);
		}
		else
			player playLocalSound(game["sound_axis_enemy_has_taken_flag"]);
	}
	
	getent((self.targetname + "_axis"),"targetname") hide();
	getent((self.targetname + "_neutral"),"targetname") hide();
	getent((self.targetname + "_allies"),"targetname") show();	
	
	if (game["showicons"])
		self.icon setShader(game["hud_allies_flag"], game["flag_icons_w"], game["flag_icons_h"]);
	
	/* WORM Don't want this scoring
	// if the flag is capped from the other teamgive them all the reverse penalty
	if ( old_team == "axis" )
	{
		GivePointsToTeam( "axis", game["br_points_reversal"] );
	}
	
	// give the team points out
	GivePointsToTeam( self.team, game["br_points_teamcap"] );
	*/

	//WORM I want this scoring
	// give points to capping team
	game["alliedscore"] = game["alliedscore"] + game["TeamCapPoints"];
	setTeamScore("allies", game["alliedscore"]);

	// give out points to the cappers
	self GivePointsToCappers( "allies" );

	names = self GetCappers("allies");

	// display the cap message
	if(cappers > 1)
	{
		// this will cause an unlocalized string warning if you are running in developer mode because of the names
		PrintCappedMessage(&"GMI_DOM_ALLIES_CAP_FLAG_TEAM",self.description,names);
	}
	else
	{
		// this will cause an unlocalized string warning if you are running in developer mode because of the names
		iprintln(&"GMI_DOM_ALLIES_CAP_FLAG_SOLO",names[0],self.description);
	}
	
	// now see if we can find any props that need to be turned off 
	props = getentarray("flag" + self.script_idnumber + "stuff_" + old_team, "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] hide();
	}

	// now see if we can find any props that need to be turned on 
	props = getentarray("flag" + self.script_idnumber + "stuff_allies", "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] show();
	}
	
	// start special flag sounds playing if there are any
	sound_maker = getent("flag" + self.script_idnumber + "radio","targetname");
	if (isDefined(sound_maker) && isDefined(game[self.team + "radio"]))
	{
		sound_maker playloopsound(game[self.team + "radio"]);
	}
}

// ----------------------------------------------------------------------------------
//	Capture_AxisCappedFlag
//
// 		Gets called when the axis cap a flag.  Displays the appropriate flag.
//		Also displays the cap messages.
// ----------------------------------------------------------------------------------
Capture_AxisCappedFlag(cappers,name)
{
	self notify("captured");

	old_team = self.team;
	self.team = "axis";
	self.radarupdated = 0;	
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if(player.pers["team"] == "allies")
			player playLocalSound(game["sound_allies_enemy_has_taken_flag"]);
		else
		{
			if ( old_team != "allies" )
				player playLocalSound(game["sound_axis_area_secure"]);
			else
				player playLocalSound(game["sound_axis_ground_taken"]);
		}
	}
	
	getent((self.targetname + "_allies"),"targetname") hide();
	getent((self.targetname + "_neutral"),"targetname") hide();
	getent((self.targetname + "_axis"),"targetname") show();

	if (game["showicons"])
		self.icon setShader(game["hud_axis_flag"], game["flag_icons_w"], game["flag_icons_h"]);

	/* WORM I dont want this scoring
	// if the flag is capped from the other teamgive them all the reverse penalty
	if ( old_team == "allies" )
	{
		GivePointsToTeam( "allies", game["br_points_reversal"] );
	}
	
	// give the team points out
	GivePointsToTeam( self.team, game["br_points_teamcap"] );
	*/

	//WORM I want this scoring
	// give points to capping team
	game["axisscore"] = game["axisscore"] + game["TeamCapPoints"];
	setTeamScore("axis", game["axisscore"]);
	
	// give out points to the cappers
	self GivePointsToCappers( "axis" );

	names = self GetCappers("axis");

	// display the cap message
	if(cappers < -1)
	{
		// this will cause an unlocalized string warning if you are running in developer mode because of the names
		PrintCappedMessage(&"GMI_DOM_AXIS_CAP_FLAG_TEAM",self.description,names);
	}
	else
	{
		// this will cause an unlocalized string warning if you are running in developer mode because of the names
		iprintln(&"GMI_DOM_AXIS_CAP_FLAG_SOLO",names[0],self.description);
	}
	
	// now see if we can find any props that need to be turned off 
	props = getentarray("flag" + self.script_idnumber + "stuff_" + old_team, "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] hide();
	}

	// now see if we can find any props that need to be turned on 
	props = getentarray("flag" + self.script_idnumber + "stuff_axis", "targetname");
	for ( i = 0; i < props.size; i++ )
	{
		props[i] show();
	}
	
	// start special flag sounds playing if there are any
	sound_maker = getent("flag" + self.script_idnumber + "radio","targetname");
	if (isDefined(sound_maker )&& isDefined(game[self.team + "radio"]))
	{
		sound_maker playloopsound( game[self.team + "radio"]);
	}
		
}

// ----------------------------------------------------------------------------------
//	Capture_PlayerCappingFlag
//
// 		Gets called when a player starts capping a flag.  This displays the 
//		progress bar.
// ----------------------------------------------------------------------------------
Capture_UpdateProgressBar(flag)
{
	self endon("death");
	level endon("round_ended");
	flag endon("capture_canceled");
	flag endon("captured");

	barsize = maps\mp\_util_mp_gmi::get_progressbar_maxwidth();
	height = maps\mp\_util_mp_gmi::get_progressbar_height();
	InitProgressbar(self, &"GMI_DOM_CAPTURING_FLAG");
		
	// loop until done displaying the progress bar
	// dump out if:
	//	1: Not touching the flag anymore
	//	2: Your team is the same as the flag team.
	//	3: You are a spectator
	while(	((flag.axis_capping == 0) || (flag.allied_capping == 0))
		&& self.pers["team"] != flag.team 
		&& self.pers["team"] != "spectator")
	{
		if (flag.scale > 0)
		{
			self.progressbar setShader("white", flag.scale * barsize,  height);
		}
		wait .01;
	}
}

// ----------------------------------------------------------------------------------
//	Capture_PlayerCappingFlag
//
// 		Gets called when a player starts capping a flag.  This displays the 
//		progress bar.
// ----------------------------------------------------------------------------------
Capture_PlayerCappingFlag(flag)
{
	if ( !isAlive(self) )
		return;
		
	if(flag.capping != 0)
	{
		getent((flag.targetname + "_neutral"),"targetname") playloopsound("start_flag_capture");
	}
	
	self thread Capture_UpdateProgressBar(flag);
	
	flag waittill("capture_canceled");
	
	// we are done so destroy the progress bars
	if (isDefined(self.progressbar))
	{
		self.progressbar destroy();
	}
	if (isDefined(self.progressbackground))
	{
		self.progressbackground destroy();
	}
	if(isDefined(self.progresstext))
	{					
		self.progresstext destroy();
	}
	
	getent((flag.targetname + "_neutral"),"targetname") stoploopsound("start_flag_capture");
	self.view_bar = 0;
	self.pers["capture_process_thread"] = 0;
}

// ----------------------------------------------------------------------------------
//	Capture_Canceled
//
// 		Called on a flag when the capture is ended for any reason
// ----------------------------------------------------------------------------------
Capture_Canceled()
{
	self notify("capture_canceled");
	
	self.beingcapped = false;
	self.radarupdated = 0;

	self.progresstime = 0;
	self.scale = 0;

	if(isDefined(self.capping_icon))
	{
		self.capping_icon destroy();
	}
	if(isDefined(self.blinking_icon))
	{
		self.blinking_icon destroy();
	}
	
	getent((self.targetname + "_neutral"),"targetname") stoploopsound("start_flag_capture");

}

// ----------------------------------------------------------------------------------
//	Capture_CheckCappingFlag
//
// 	Checks to see if the player is currently capping the flag and returns true.
// ----------------------------------------------------------------------------------
Capture_CheckCappingFlag(player)
{
	opposing_team = "allies"; 
	if ( player.pers["team"] == "allies") 
		opposing_team = "axis" ; 
	
	// loop through all the flags and see if the player is in one
	for(q=1;q<level.flagcount;q++)
	{
		flag = getent("flag"+q,"targetname");

		// we only need to check the ones held by the other team
		if(flag.team == opposing_team && player istouching(flag))
		{
			return true;
		}
	}
	
	return false;
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
	self playLocalSound(music);
	wait 2.0;
	if (announcer != "none")
		self playLocalSound(announcer);
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
Respawn()
{
	self endon ("end_respawn");
	self endon ("spawned");
	if(!isDefined(self.pers["weapon"]))
		return;

	wait(0.01);
	
	if(self.pers["team"] != "allies" && self.pers["team"] != "axis")
	{
		maps\mp\_utility::error("Team not set correctly on spawning player " + self + " " + self.pers["team"]);
	}
	self stopwatch_start("respawn", level.respawn_timer[self.pers["team"]] );
	level thread respawn_pool(self.pers["team"]);
	
	level waittill("respawn_" + self.pers["team"]);
	
	self thread spawnPlayer();
}

// ----------------------------------------------------------------------------------
//	respawn_pool
//
// 		Gets called for every guy that dies.  Starts the next wave timer if 
//		is not already started.  Sends out a notification when 
//		done.
// ----------------------------------------------------------------------------------
respawn_pool(team)
{
	if(level.respawn_timer[team] < level.respawn_wave_time)
		return;
		
	for(i=level.respawn_wave_time;i>0;i--)
	{
		level.respawn_timer[team] = i;
		wait 1;
	}
	level.respawn_timer[team] = level.respawn_wave_time;	
	level notify("respawn_" + team);
}

// ----------------------------------------------------------------------------------
//	SpawnPlayer
//
// 		spawns the player
// ----------------------------------------------------------------------------------
SpawnPlayer()
{
	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();
	self endon ("end_respawn");
	self notify("spawned");

	resettimeout();

	// clear any hud elements
	self Player_ClearHud();

	self.sessionteam = self.pers["team"];
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;
	
	//JS reset all progress bar stuff
	self.progresstime = 0;
	self.view_bar = 0;
	self.pers["capture_process_thread"] = 0;

	//JS reset teamkiller flag
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
	else
	{
		maps\mp\_utility::error("Team not set correctly on spawning player " + self);
	}
	
	// get the base spawnpoints
	spawnpoints = getentarray(base_spawn_name, "classname");
	
	// now add to the array any spawnpoints that are related to held flags
	for(q=1;q<level.flagcount;q++)
	{
		flag_trigger = getent("flag" + q,"targetname");
		
		if ( !isDefined( flag_trigger.target ) )
			continue;
			
		// only get spawnpoints from flags that are held by this team	
		if ( self.pers["team"] != flag_trigger.team )
			continue;
			
		secondary_spawns =  getentarray(flag_trigger.target, "targetname");
	
		for ( i = 0; i < secondary_spawns.size; i++ )
		{
			// only get the ones for the current team
			if ( secondary_spawns[i].classname != secondary_spawn_name )
				continue;
				
			spawnpoints = maps\mp\_util_mp_gmi::add_to_array(spawnpoints, secondary_spawns[i]);
		}
	}

	// now add any secondary spawnpoints
	array = maps\mp\gametypes\_secondary_gmi::GetSecondaryTriggers(self.pers["team"]);
	for ( i = 0; i < array.size; i++ )
	{
		if ( !isDefined( array[i].target ) )
			continue;
			
		secondary_spawns =  getentarray(array[i].target, "targetname");
	
		for ( j = 0; j < secondary_spawns.size; j++ )
		{
			// only get the ones for the current team
			if ( secondary_spawns[j].classname != secondary_spawn_name )
				continue;
				
			spawnpoints = maps\mp\_util_mp_gmi::add_to_array(spawnpoints, secondary_spawns[j]);
		}
	}

	// now pick a spawn point
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
	self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;
	
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
	
	if(self.pers["team"] == "allies")
		self setClientCvar("cg_objectiveText", game["dom_allies_obj_text"]);
	else if(self.pers["team"] == "axis" )
		self setClientCvar("cg_objectiveText", game["dom_axis_obj_text"]);
		
	// battle rank icons take precidence over the draw friend icons
	if(level.drawfriend)
	{
		if(level.battlerank)
		{
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
			else
			{
				self.headicon = game["headicon_axis"];
				self.headiconteam = "axis";
			}
		}
	}
	else if(level.battlerank)
	{
		self.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(self);
	}	

	// Check to see if the player changed weapon class during round.
	if(isDefined(self.nextroundweapon))
	{
		self.pers["weapon"] = self.nextroundweapon;
		self.nextroundweapon = undefined;
	}

	// setup all the weapons
	self maps\mp\gametypes\_pam_loadout_gmi::PlayerSpawnLoadout();

	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();

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
	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();
	self notify("spawned");

	resettimeout();

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";

	maps\mp\gametypes\_pam_teams::SetSpectatePermissions();
	if(isDefined(origin) && isDefined(angles))
		self spawn(origin, angles);
	else
	{
		spawnpointname = "mp_dom_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
					
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isDefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}

	self.usedweapons = false;

	updateTeamStatus();

	if( "allies" == self.pers["team"])
		self setClientCvar("cg_objectiveText", game["dom_allies_obj_text"]);
	else if("axis" == self.pers["team"])
		self setClientCvar("cg_objectiveText", game["dom_axis_obj_text"]);
	else 
		self setClientCvar("cg_objectiveText", game["dom_spectator_obj_text"]);
}

// ----------------------------------------------------------------------------------
//	SpawnIntermission
//
// 		spawns an intermission player (kinda like a spectator but different)
// ----------------------------------------------------------------------------------
SpawnIntermission()
{
	self notify("spawned");
	
	resettimeout();
	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;

	spawnpointname = "mp_dom_intermission";
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
	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();

	level.warmup = 1;
	level.roundstarted = false;
	level.roundended = false;

	CheckMatchStart();

	if (!game["matchstarted"])
		return;

	if (game["mode"] == "match" && game["readyup"] == 1)
	{
		// 1st Half Ready-up Only.  2nd Half is done in Do_Halftime
		Do_Ready_Up();

		game["firsthalfready"] = 1;
		//cause the map to restart
		map_restart(true);
	}
	else if (game["readyup"] == 1)
	{
		Pub_Match_Start();

		ResetAllScores();

		//cause the map to restart
		map_restart(true);
	}

	level.starttime = getTime();

	if (game["halftimeflag"] == "0")
	{
		Run_First_Half();

		if (getcvar("scr_dom_dohalftime") == "1")
			Do_Halftime();
		else
			Do_Endgame();
	}
	else
	{
		Start_Second_Half();

		Do_Endgame();
	}
}

Run_First_Half()
{
	level.warmup = 0;

	level.allowcaptures = true;
	level.roundstarted = true;
	game["firsthalfready"] = 1;

	thread maps\mp\gametypes\_pam_teams::sayMoveIn();

	level.roundstarttime = getTime();
	level.allies_cap_count = 0;  
	level.axis_cap_count = 0;  

	// if the round length is zero then no clock or timer
	if ( level.timelimit == 0 )
		return;
		
	if (isDefined(level.clock))
		level.clock destroy();

	//WORMs STOPPABLE CLOCK 
	Worms_Stoppable_Clock();

	if(level.roundended)
		return;

	level notify("round_ended");
	level.roundended = true;
	level.warmup = 1;

	thread Create_HUD_TimeExp();
}

Start_Second_Half()
{
	level.warmup = 0;

	level.allowcaptures = true;
	level.roundstarted = true;

	thread maps\mp\gametypes\_pam_teams::sayMoveIn();

	level.roundstarttime = getTime();
	level.allies_cap_count = 0;  
	level.axis_cap_count = 0;  

	// if the round length is zero then no clock or timer
	if ( level.timelimit == 0 )
		return;
		
	if (isDefined(level.clock))
		level.clock destroy();

	//WORMs STOPPABLE CLOCK 
	Worms_Stoppable_Clock();

	if(level.roundended)
		return;

	level notify("round_ended");
	level.roundended = true;
	level.warmup = 1;

	thread Create_HUD_TimeExp();
}


Do_Halftime()
{
	// Don't let teambalance take effect
	level.allowautobalance = false;

	// Compute Scores
	game["round1alliesscore"] = game["alliedscore"];
	game["team2score"] = game["alliedscore"];
	game["round1axisscore"] = game["axisscore"];
	game["team1score"] = game["axisscore"];

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

		if ( getCvarint("scr_dom_clearscoreeachhalf") == 1 )
		{
			player.pers["score"] = 0;
			player.pers["deaths"] = 0;

			if (level.battlerank)
				maps\mp\gametypes\_rank_gmi::ResetPlayerRank();
		}
	}  // end for loop

	thread maps\mp\_pam_tankdrive_gmi::PAM_deactivate_tanks();

	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();

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
	axistempscore = getTeamScore("axis");
	alliestempscore = getTeamScore("allies");
	setTeamScore("axis", alliestempscore);
	setTeamScore("allies", axistempscore);

	game["alliedscore"] = getTeamScore("allies");
	game["axisscore"] = getTeamScore("axis");

	game["halftimeflag"] = "1";

	/* READY UP */
	if( game["mode"] == "match")
		Do_Ready_Up();

	map_restart(true);
}

Do_Endgame()
{
	level.mapended = true;

	if (getcvar("scr_dom_dohalftime") == "0")
	{
		// Compute Scores without Halftime
		game["round1alliesscore"] = game["alliedscore"];
		game["team2score"] = game["alliedscore"];
		game["round1axisscore"] = game["axisscore"];
		game["team1score"] = game["axisscore"];
	}
	else
	{
		// Compute Scores WITH Halftime
		game["round2alliesscore"] = game["alliedscore"] - game["round1axisscore"];
		game["team2score"] = game["axisscore"];
		game["round2axisscore"] = game["axisscore"] - game["round1alliesscore"];
		game["team1score"] = game["alliedscore"];
	}

	Create_HUD_TeamWin();

	Create_HUD_Matchover();

	Create_HUD_Header();
		
	Create_HUD_Scoreboard();

	wait 10;

	Destroy_HUD_Header();

	Destroy_HUD_Scoreboard();

	Destroy_HUD_TeamWin();

	if(isdefined(level.matchover))
		level.matchover destroy();

	level thread endMap();
}

/*
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

	level.allowcaptures = true;
	level.roundstarted = true;
	
	thread maps\mp\gametypes\_teams::sayMoveIn();

	level.roundstarttime = getTime();
	level.allies_cap_count = 0;  
	level.axis_cap_count = 0;  

	// if the round length is zero then no clock or timer
	if ( level.roundlength == 0 )
		return;
		
	if (isDefined(level.clock))
		level.clock destroy();

	//WORMs STOPPABLE CLOCK 
	Worms_Stoppable_Clock();

	if(level.roundended)
		return;

	announcement(&"GMI_DOM_TIMEEXPIRED");
	
	level thread endRound("none");
}*/

// ----------------------------------------------------------------------------------
//	CheckMatchStart
//
// 		Checks to see if the round is ready to start.  Starts round if ready.
// ----------------------------------------------------------------------------------
CheckMatchStart()
{
	if (game["matchstarted"])
		return;

	//Check to see if we even have 2 teams to start
	level.exist["teams"] = 0;

	while(!level.exist["teams"])
	{
		level.exist["allies"] = 0;
		level.exist["axis"] = 0;

		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			
			if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
				level.exist[player.pers["team"]]++;
		}

		if (level.exist["allies"] && level.exist["axis"])
			level.exist["teams"] = 1;

		if (getcvar("scr_debug_dom") == "1")
			level.exist["teams"] = 1;

		wait 1;
	}

	// Two teams are here, ready-up!
	game["readyup"] = 1;
	game["matchstarted"] = true;

	// Reset all Player and Team Scores
	resetAllScores();
}


// ----------------------------------------------------------------------------------
//	resetScores
//
// 		Resets Player's scoress
// ----------------------------------------------------------------------------------
resetPlayerScores()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player.pers["score"] = 0;
		player.pers["deaths"] = 0;
	}

	if (level.battlerank)
	{
		maps\mp\gametypes\_rank_gmi::ResetPlayerRank();
	}
}

// ----------------------------------------------------------------------------------
//	Player_ClearHud
//
// 		Destroys all player hud elemets
// ----------------------------------------------------------------------------------
Player_ClearHud()
{
	if(isDefined(self.progressbackground))	
	{
		self.progressbackground destroy();
	}
	if(isDefined(self.progressbar))
	{
		self.progressbar destroy();
	}
	if(isDefined(self.progresstext))
	{					
		self.progresstext destroy();
	}
}

// ----------------------------------------------------------------------------------
//	endRound
//
// 		Ends the round
// ----------------------------------------------------------------------------------
endRound(roundwinner)
{
	level endon("kill_endround");

	if(level.roundended)
		return;
	if ( game["matchstarted"] )
		level.roundended = true;
	
	// End threads and remove related hud elements and objectives
	level notify("round_ended");

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player Player_ClearHud();
	}

	for(q=1;q<level.flagcount;q++)
	{
		flag = getent("flag"+q,"targetname");
		flag Capture_Canceled();
	}

 	if (roundwinner == "abort")
		game["matchstarted"] = false;
	level.roundstarted = false;

	/*
	if(roundwinner == "allies")
	{		
		announcement(&"GMI_DOM_ALLIEDMISSIONACCOMPLISHED");
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			players[i] thread Victory_PlaySounds(game["sound_allies_victory_vo"],game["sound_allies_victory_music"]);
		}
		level thread Victory_DisplayImage(game["hud_allies_victory_image"]);
	}
	else if(roundwinner == "axis")
	{
		announcement(&"GMI_DOM_AXISMISSIONACCOMPLISHED");
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			players[i] thread Victory_PlaySounds(game["sound_axis_victory_vo"],game["sound_axis_victory_music"]);
		}
		level thread Victory_DisplayImage(game["hud_axis_victory_image"]);
	} */
	
	if(roundwinner == "abort")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
			players[i] playLocalSound(game["sound_round_draw_vo"]);
	}

	if (roundwinner != "reset")
	{
		time = getCvarInt("scr_dom_endrounddelay");
		
		if ( time < 1 )
			time = 1;
		wait(time);
	}

	winners = "";
	losers = "";

	if(roundwinner == "allies" && !level.mapended)
	{
		//game["alliedscore"]++;
		//setTeamScore("allies", game["alliedscore"]);
		
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
		//game["axisscore"]++;
		//setTeamScore("axis", game["axisscore"]);

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

	game["timepassed"] = game["timepassed"] + ((getTime() - level.starttime) / 1000) / 60.0;

	// call these checks before calling the score resetting
	checkScoreLimit();
	
	if(!game["matchstarted"] && roundwinner == "reset")
	{
		thread resetAllScores();
		game["roundsplayed"] = 0;
	}
	
	if(level.mapended)
		return;
	
	// if the teams are not full then abort
	if ( !(level.exist["axis"] && level.exist["allies"]) && !getcvarint("scr_debug_dom") )
	{
		if (isDefined(level.clock))
			level.clock destroy();

		level.clock = undefined;
		return;
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

	if ( game["matchstarting"] == true || level.mapended)
		return;
	
	game["matchstarting"] = true;
	
	level thread maps\mp\_util_mp_gmi::make_permanent_announcement(&"GMI_DOM_MATCHSTARTING", "cleanup match starting");			
	
	time = getCvarint("scr_dom_startrounddelay");

	if (time < 1)
		time = 1;
		
	if ( isDefined(level.victory_image) )
	{
		level.victory_image destroy();
	}
	
	// give all of the players clocks to count down until the round starts
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		// clear any hud elements again
		player Player_ClearHud();

		if ( isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue;
			
		player stopwatch_start("match_start", time);
	}
	
	wait (time);
	
	if ( level.mapended )
		return;

	game["matchstarted"] = true;
	game["matchstarting"] = false;

	if ( getCvarint("scr_dom_clearscoreeachround") == 1 && !level.mapended )
	{
		thread resetPlayerScores();
	}

	level notify("cleanup match starting");
	map_restart(true);
}

// ----------------------------------------------------------------------------------
//	endMap
//
// 		Ends the map
// ----------------------------------------------------------------------------------
endMap()
{
	level notify("kill_startround");
	game["state"] = "intermission";
	level notify("intermission");
	
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

	wait 10;
	exitLevel(false);
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
					
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
					{
						// setup the hud rank indicator
						player thread maps\mp\gametypes\_rank_gmi::RankHudInit();
						
						player.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(player);
						if ( level.drawfriend )
						{
							player.headicon = maps\mp\gametypes\_rank_gmi::GetRankHeadIcon(player);
							player.headiconteam = player.pers["team"];
						}
						else
						{
							player.headicon = "";
						}
					}
				}
			}
			else if(level.drawfriend)
			{
				// for all living players, show the appropriate headicon
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
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
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					
					if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
					{
						player.headicon = "";
						player.statusicon = "";
					}
				}
			}
		}

		timelimit = getCvarFloat("scr_dom_timelimit");
		if(level.timelimit != timelimit)
		{
			if(timelimit > 1440)
			{
				timelimit = 1440;
				setCvar("scr_dom_timelimit", "1440");
			}

			level.timelimit = timelimit;
			setCvar("ui_dom_timelimit", level.timelimit);
		}

		scorelimit = getCvarInt("scr_dom_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;
			setCvar("ui_dom_scorelimit", level.scorelimit);

			if(game["matchstarted"])
				checkScoreLimit();
		}

		killcam = getCvarInt("scr_killcam");
		if (level.killcam != killcam)
		{
			level.killcam = getCvarInt("scr_killcam");
			if(level.killcam >= 1)
				setarchive(true);
			else
				setarchive(false);
		}
		
		freelook = getCvarInt("scr_freelook");
		if (level.allowfreelook != freelook)
		{
			level.allowfreelook = getCvarInt("scr_freelook");
			level maps\mp\gametypes\_pam_teams::UpdateSpectatePermissions();
		}
		
		enemyspectate = getCvarInt("scr_spectateenemy");
		if (level.allowenemyspectate != enemyspectate)
		{
			level.allowenemyspectate = getCvarInt("scr_spectateenemy");
			level maps\mp\gametypes\_pam_teams::UpdateSpectatePermissions();
		}
		
		teambalance = getCvarInt("scr_teambalance");
		if (level.teambalance != teambalance)
		{
			level.teambalance = getCvarInt("scr_teambalance");
			if (level.teambalance > 0)
				level thread maps\mp\gametypes\_pam_teams::TeamBalance_Check_Roundbased();
		}

		if (level.teambalance > 0)
		{
			level.teambalancetimer++;
			if (level.teambalancetimer >= 60)
			{
				level thread maps\mp\gametypes\_pam_teams::TeamBalance_Check();
				level.teambalancetimer = 0;
			}
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

	debug = getCvarint("scr_debug_dom");

	// if one team is empty then abort the round
	if(!debug && (oldvalue["allies"] && !level.exist["allies"]) || (oldvalue["axis"] && !level.exist["axis"]))
	{
		level notify("kill_startround");
		level notify("cleanup match starting");
		game["matchstarting"] = false;

		// level may be starting
		if(level.roundended || !level.roundstarted)
		{
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];
				player Player_ClearHud();
			}
			
			return;
		}
			
		announcement(&"GMI_DOM_ROUND_DRAW");
		level thread endRound("abort");
		return;
	}
}

// ----------------------------------------------------------------------------------
//	SetupFlagIcon
//
// 		Sets up a flag icon
// ----------------------------------------------------------------------------------
SetupFlagIcon(flag)
{
	game["showicons"] = false;

	if (!getCvarint("scr_showicons"))
		return;

	game["showicons"] = true;
	
	// Flag icons at top of screen
	if(!isDefined(flag.icon))
	{
		flag.icon = newHudElem();
	}
	flag.icon.alignX = "left";
	flag.icon.alignY = "top";
	flag.icon.x =game["flag_icons_x"] + (flag.script_idnumber * game["flag_icons_w"]) - game["flag_icons_w"];
	flag.icon.y = game["flag_icons_y"];
	flag.icon.sort = 0.0; // To fix a stupid bug, where the first flag icon (or the one to the furthest left) will not sort through the capping icon. BAH!

	if(flag.team == "allies")
	{
		flag.icon setShader(game["hud_allies_flag"], game["flag_icons_w"], game["flag_icons_h"]);
	}
	else if(flag.team == "axis")
	{
		flag.icon setShader(game["hud_axis_flag"], game["flag_icons_w"], game["flag_icons_h"]);
	}
	else
	{
		flag.icon setShader(game["hud_neutral_flag"], game["flag_icons_w"], game["flag_icons_h"]);
	}
}

// ----------------------------------------------------------------------------------
//	InitProgressbar
//
// 		Sets up the flag capture progress bar on the passed in player
// ----------------------------------------------------------------------------------
InitProgressbar(player, text)
{
	if(isdefined(player.progressbackground))
	{					
		player.progressbackground destroy();
	}
	if(isdefined(player.progressbar))
	{					
		player.progressbar destroy();
	}
	if(isdefined(player.progresstext))
	{					
		player.progresstext destroy();
	}
	
	player.progresstext = maps\mp\_util_mp_gmi::get_progressbar_text(player,text);
		
	// background
	player.progressbackground=  maps\mp\_util_mp_gmi::get_progressbar_background(player);

	// foreground
	player.progressbar = maps\mp\_util_mp_gmi::get_progressbar(player);
	player.view_bar = 1;	
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
//	GivePointsToCappers
//
// 		Gives points to everyone in the flag zone at the end of the cap1
// ----------------------------------------------------------------------------------
GivePointsToCappers( team )
{
	players = getentarray("player", "classname");
	
	// give points to everyone in the cap area
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isAlive(player) && player.pers["team"] == team && player istouching(self))
		{
			player.pers["score"] += game["br_points_cap"];		
			player.score = player.pers["score"];

			lpselfnum = player getEntityNumber();
			lpselfguid = player getGuid();
			logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + player.pers["team"] + ";" + player.name + ";" + "dom_captured" + "\n");
		}
	}
}

// ----------------------------------------------------------------------------------
//	GetCappers
//
// 		Makes a string of everyone who is in the cap area
// ----------------------------------------------------------------------------------
GetCappers( team )
{
	players = getentarray("player", "classname");
	
	names = [];
	
	// give points to everyone in the cap area
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if(isAlive(player) && player.pers["team"] == team && player istouching(self))
		{
			names[names.size] = player;
		}
	}
	return names;
}

// ----------------------------------------------------------------------------------
//	PrintCappedMessage
//
// 		Prints out a capped message for a variable amount of cappers
// ----------------------------------------------------------------------------------
PrintCappedMessage( text, flag, cappers )
{
	size = cappers.size;
	if ( size >= 7 )
		iprintln(text,flag,"^7 ",cappers[0],"^7, ",cappers[1],"^7, ",cappers[2],"^7, ",cappers[3],"^7, ",cappers[4],", "^7,cappers[5],"^7, ",cappers[6]);
	else if ( size == 6 )
		iprintln(text,flag,"^7 ",cappers[0],"^7, ",cappers[1],"^7, ",cappers[2],"^7, ",cappers[3],"^7, ",cappers[4],", "^7,cappers[5]);
	else if ( size == 5 )
		iprintln(text,flag,"^7 ",cappers[0],"^7, ",cappers[1],"^7, ",cappers[2],"^7, ",cappers[3],"^7, ",cappers[4]);
	else if ( size == 4 )
		iprintln(text,flag,"^7 ",cappers[0],"^7, ",cappers[1],"^7, ",cappers[2],"^7, ",cappers[3]);
	else if ( size == 3 )
		iprintln(text,flag,"^7 ",cappers[0],"^7, ",cappers[1],"^7, ",cappers[2]);
	else if ( size == 2 )
		iprintln(text,flag,"^7 ",cappers[0],"^7, ",cappers[1]);
	else if ( size == 1 )
		iprintln(text,flag,"^7 ",cappers[0]);
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
		if (ceasefire != level.ceasefire)
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
		scorelimit = getCvarint("scr_dom_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;

			if(game["matchstarted"])
				checkScoreLimit();
		}

		// end the round if there are not enough people playing
		if (game["matchstarted"] == true && level.roundstarted == true)
		{
			debug = getCvarint("scr_debug_dom");
			
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
//	drawFlagsOnCompass
//
// 	Draws all of the compass flags and objectives
// ----------------------------------------------------------------------------------
drawFlagsOnCompass()
{
	for(;;)
	{
		for(q=1;q<level.flagcount;q++)
		{
			current_flag = getent("flag" + q + "_neutral","targetname");
			flag_trigger = getent("flag" + q,"targetname");
			
			if (!isDefined(current_flag))
				maps\mp\_utility::error("Could not find the flag entity flag" + q + "_neutral"); 
			if (!isDefined(flag_trigger))
				maps\mp\_utility::error("Could not fine the flag trigger flag" + q ); 

			if ( !isDefined(flag_trigger.team) )
				continue;
				
			if ( flag_trigger.radarupdated )
				continue;		
		
			flag_trigger.radarupdated = true;
			
			if(flag_trigger.beingcapped)
			{
				objective_add(flag_trigger.id, "current", current_flag.origin, game["hud_capping_radar"]);
				objective_onEntity(flag_trigger.id, current_flag);
				flag_trigger.yellow = 1;	//JS - this is to keep the shader from starting over every 0.5 seconds

				//play the flag lost sound based on team
				players = getentarray("player", "classname");
				for(i = 0; i < players.size; i++)
				{
					player = players[i];
					switch(player.pers["team"])
					{
						case "allies":
						{
							if( flag_trigger.team == "allies")
							{
								player playLocalSound(game["sound_allies_enemy_is_taking_flag"]);
								player iprintln(&"GMI_DOM_AXIS_FLAG_OVERRUN", flag_trigger.description);
							}
							break;
						}
						case "axis":
						{
							if( flag_trigger.team== "axis" )
							{
								player playLocalSound(game["sound_axis_enemy_is_taking_flag"]);
								player iprintln(&"GMI_DOM_ALLIES_FLAG_OVERRUN", flag_trigger.description);
							}
						}
					}
				}
			}
			else if(flag_trigger.team == "allies")
			{
				objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_axis_radar"]);
				objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_neutral_radar"]);
				objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_capping_radar"]);
				objective_add(flag_trigger.id, "current", current_flag.origin, game["hud_allies_radar"]);
			}
			else if(flag_trigger.team == "axis")
			{
				objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_allies_radar"]);
				objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_neutral_radar"]);
				objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_capping_radar"]);
				objective_add(flag_trigger.id, "current", current_flag.origin, game["hud_axis_radar"]);
			}
			else if(flag_trigger.team == "neutral")
			{
				objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_allies_radar"]);
				objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_axis_radar"]);
				objective_delete(flag_trigger.id, "current", current_flag.origin, game["hud_capping_radar"]);
				objective_add(flag_trigger.id, "current", current_flag.origin, game["hud_neutral_radar"]);
			}
		}
	wait 0.5;
	}
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

	thread stopwatch_delete(reason);
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

	thread stopwatch_delete(reason);
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

//Worm
Comp_Flag_Scoring(q)
{
	flag = getent("flag"+q,"targetname");
	obj_name = flag.description;
			
	for(;;)
	{
		score = 0;
		alliescaplevel = 0;
		while(flag.team == "allies")
		{
			if (alliescaplevel >= game["tier6time"] && game["tier6time"] > 0)
			{
				score = game["tier6score"];
			}
			else if (alliescaplevel >= game["tier5time"] && game["tier5time"] > 0)
			{
				score = game["tier5score"];
			}
			else if (alliescaplevel >= game["tier4time"] && game["tier4time"] > 0)
			{
				score = game["tier4score"];
			}
			else if (alliescaplevel >= game["tier3time"] && game["tier3time"] > 0)
			{
				score = game["tier3score"];
			}
			else if (alliescaplevel >= game["tier2time"] && game["tier2time"] > 0)
			{
				score = game["tier2score"];
			}
			else if (alliescaplevel >= 1)
			{
				score = game["tier1score"];
			}

			if (score != 0 && !level.roundended && level.allowcaptures)
			{
				game["alliedscore"] = game["alliedscore"] + score;
				setTeamScore("allies", game["alliedscore"]);

				thread Scoring_HUD(q, "allies", score);
			}


			wait game["scoreinterval"];
			alliescaplevel++;
		}

		score = 0;
		axiscaplevel = 0;
		while(flag.team == "axis")
		{
			if (axiscaplevel >= game["tier4time"] && game["tier4time"] > 0)
			{
				score = game["tier4score"];
			}
			else if (axiscaplevel >= game["tier3time"] && game["tier3time"] > 0)
			{
				score = game["tier3score"];
			}
			else if (axiscaplevel >= game["tier2time"] && game["tier2time"] > 0)
			{
				score = game["tier2score"];
			}
			else if (axiscaplevel >= 1)
			{
				score = game["tier1score"];
			}

			if (score != 0 && !level.roundended && level.allowcaptures)
			{
				game["axisscore"] = game["axisscore"] + score;
				setTeamScore("axis", game["axisscore"]);

				thread Scoring_HUD(q, "axis", score);
			}

			wait game["scoreinterval"];
			axiscaplevel++;
		}

		if (flag.team != "allies" || flag.team != "axis")
			wait .5;

		wait .05;
	}
}

Scoring_HUD(q, team, points)
{
	scoring = newHudElem();
	scoring.alignX = "center";
	scoring.alignY = "middle";
	scoring.x = game["flag_icons_x"] + (q * game["flag_icons_w"]) - (game["flag_icons_w"] * .5);
	scoring.y = game["flag_icons_y"] - (game["flag_icons_h"] * .5);
	scoring.fontScale = 1.8;
	if (team == "allies")
		scoring.color = (.73, .99, .75);
	else
		scoring.color = (1, .66, .66);
	scoring setValue(points);

	wait 6;

	if(isdefined(scoring))
		scoring destroy();
}

All_Cap_Hud(team)
{
	level.allcaphud1 = newHudElem();
	level.allcaphud1.alignX = "center";
	level.allcaphud1.alignY = "middle";
	level.allcaphud1.x = 565;
	level.allcaphud1.y = 200;
	level.allcaphud1.fontScale = 1.4;
	if (team == "allies")
		level.allcaphud1.color = (.73, .99, .75);
	else
		level.allcaphud1.color = (1, .66, .66);
	level.allcaphud1 setText(game["hudallcap"]);


	level.allcaphudteam = newHudElem();
	level.allcaphudteam.alignX = "center";
	level.allcaphudteam.alignY = "middle";
	level.allcaphudteam.x = 565;
	level.allcaphudteam.y = 180;
	level.allcaphudteam.fontScale = 1.4;
	if (team == "allies")
	{
		level.allcaphudteam.color = (.73, .99, .75);
		level.allcaphudteam setText(game["hudallies"]);
	}
	else
	{
		level.allcaphudteam.color = (1, .66, .66);
		level.allcaphudteam setText(game["hudaxis"]);
	}

	level.allcaphudpoints = newHudElem();
	level.allcaphudpoints.alignX = "center";
	level.allcaphudpoints.alignY = "middle";
	level.allcaphudpoints.x = 540;
	level.allcaphudpoints.y = 220;
	level.allcaphudpoints.fontScale = 1.4;
	level.allcaphudpoints.color = (.99, .99, .75);
	points = game["TeamCapAllPoints"];
	level.allcaphudpoints setValue(points);


	level.allcaphud2 = newHudElem();
	level.allcaphud2.alignX = "center";
	level.allcaphud2.alignY = "middle";
	level.allcaphud2.x = 585;
	level.allcaphud2.y = 220;
	level.allcaphud2.fontScale = 1.4;
	if (team == "allies")
		level.allcaphud2.color = (.73, .99, .75);
	else
		level.allcaphud2.color = (1, .66, .66);
	level.allcaphud2 setText(game["hudpoints"]);

}


AllCap(cappers)
{
	if(level.roundended)
		return;

	if(level.mapended)
		return;

	level.allowcaptures = false;

	wait 1.5;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player Player_ClearHud();
	}

	for(q=1;q<level.flagcount;q++)
	{
		flag = getent("flag"+q,"targetname");
		flag Capture_Canceled();
	}

	if(cappers == "allies")
	{
		game["alliedscore"] = game["alliedscore"] + game["TeamCapAllPoints"];
		setTeamScore("allies", game["alliedscore"]);

		//announcement(&"GMI_DOM_ALLIEDMISSIONACCOMPLISHED");
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			player playLocalSound(game["sound_allies_victory_music"]);
		}
		level thread Victory_DisplayImage(game["hud_allies_victory_image"]);
	}
	else if(cappers == "axis")
	{
		game["axisscore"] = game["axisscore"] + game["TeamCapAllPoints"];
		setTeamScore("axis", game["axisscore"]);

		//announcement(&"GMI_DOM_AXISMISSIONACCOMPLISHED");
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			player playLocalSound(game["sound_axis_victory_music"]);
		}
		level thread Victory_DisplayImage(game["hud_axis_victory_image"]);
	}

	All_Cap_Hud(cappers);

	time = getCvarint("scr_dom_restartdelay");

	if (time < 14)
		time = 14;
		
	//Reseting Map Hud
	level.resetmaphud = newHudElem();
	level.resetmaphud.x = 590;
	level.resetmaphud.y = 335;
	level.resetmaphud.alignX = "center";
	level.resetmaphud.alignY = "middle";
	level.resetmaphud.fontScale = 1.2;
	level.resetmaphud.color = (1, 1, 0);
	level.resetmaphud.alpha = .9;
	level.resetmaphud setText(game["resetmap"]);
	
	// give all of the players clocks to count down until the round starts
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		// clear any hud elements again
		player Player_ClearHud();

		if ( isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue;
			
		player stopwatch_start("match_start", time);
	}
	
	wait (time);

	if (isDefined(level.victory_image))
		level.victory_image destroy();
	if(isdefined(level.allcaphud1))
		level.allcaphud1 destroy();
	if(isdefined(level.allcaphudteam))
		level.allcaphudteam destroy();
	if(isdefined(level.allcaphudpoints))
		level.allcaphudpoints destroy();
	if(isdefined(level.allcaphud2))
		level.allcaphud2 destroy();
	if(isdefined(level.resetmaphud))
		level.resetmaphud destroy();
	
	if ( level.mapended )
		return;

	//RESET FLAGS
	for(q=1;q<level.flagcount;q++)
	{
		flag = getent("flag"+q,"targetname");

		old_team = cappers;
		flag.team = "neutral";
		flag.radarupdated = 0;	

		getent((flag.targetname + "_axis"),"targetname") hide();
		getent((flag.targetname + "_allies"),"targetname") hide();	
		getent((flag.targetname + "_neutral"),"targetname") show();
		
	
		if (game["showicons"])
			flag.icon setShader(game["hud_neutral_flag"], game["flag_icons_w"], game["flag_icons_h"]);

		// now see if we can find any props that need to be turned off 
		props = getentarray("flag"+q + "stuff_allies", "targetname");
		for ( i = 0; i < props.size; i++ )
		{
			props[i] hide();
		}

		// now see if we can find any props that need to be turned on 
		props = getentarray("flag"+q + "stuff_axis", "targetname");
		for ( i = 0; i < props.size; i++ )
		{
			props[i] hide();
		}

		// now see if we can find any props that need to be turned on 
		props = getentarray("flag"+q + "stuff_neutral", "targetname");
		for ( i = 0; i < props.size; i++ )
		{
			props[i] show();
		}
		
		// start special flag sounds playing if there are any
		sound_maker = getent("flag"+q + "radio" ,"targetname");
		if (isDefined(sound_maker) && isDefined(game["neutralradio"]))
			sound_maker playloopsound( game["neutralradio"]);
	}

	//RESPAWN PLAYERS
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
	
		if (player.pers["team"] == "axis" || player.pers["team"] == "allies")
		{
			player.pers["weapon1"] = undefined;
			player.pers["weapon2"] = undefined;

			player thread AllCap_ReSpawnPlayer();
		}
	}

	thread maps\mp\gametypes\_pam_teams::sayMoveIn();
}



AllCap_ReSpawnPlayer()
{
	self endon ("end_respawn");
	self notify("spawned");

	resettimeout();

	// clear any hud elements
	self Player_ClearHud();

	self.sessionteam = self.pers["team"];
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;
	
	//JS reset all progress bar stuff
	self.progresstime = 0;
	self.view_bar = 0;
	self.pers["capture_process_thread"] = 0;

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
	else
	{
		maps\mp\_utility::error("Team not set correctly on spawning player " + self);
	}
	
	// get the base spawnpoints
	spawnpoints = getentarray(base_spawn_name, "classname");
	
	// now add to the array any spawnpoints that are related to held flags
	for(q=1;q<level.flagcount;q++)
	{
		flag_trigger = getent("flag" + q,"targetname");
		
		if ( !isDefined( flag_trigger.target ) )
			continue;
			
		// only get spawnpoints from flags that are held by this team	
		if ( self.pers["team"] != flag_trigger.team )
			continue;
			
		secondary_spawns =  getentarray(flag_trigger.target, "targetname");
	
		for ( i = 0; i < secondary_spawns.size; i++ )
		{
			// only get the ones for the current team
			if ( secondary_spawns[i].classname != secondary_spawn_name )
				continue;
				
			spawnpoints = maps\mp\_util_mp_gmi::add_to_array(spawnpoints, secondary_spawns[i]);
		}
	}

	// now add any secondary spawnpoints
	array = maps\mp\gametypes\_secondary_gmi::GetSecondaryTriggers(self.pers["team"]);
	for ( i = 0; i < array.size; i++ )
	{
		if ( !isDefined( array[i].target ) )
			continue;
			
		secondary_spawns =  getentarray(array[i].target, "targetname");
	
		for ( j = 0; j < secondary_spawns.size; j++ )
		{
			// only get the ones for the current team
			if ( secondary_spawns[j].classname != secondary_spawn_name )
				continue;
				
			spawnpoints = maps\mp\_util_mp_gmi::add_to_array(spawnpoints, secondary_spawns[j]);
		}
	}

	// now pick a spawn point
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
	self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;
	
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
	
	if(self.pers["team"] == "allies")
		self setClientCvar("cg_objectiveText", game["dom_allies_obj_text"]);
	else if(self.pers["team"] == "axis" )
		self setClientCvar("cg_objectiveText", game["dom_axis_obj_text"]);
		
	// battle rank icons take precidence over the draw friend icons
	if(level.drawfriend)
	{
		if(level.battlerank)
		{
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
			else
			{
				self.headicon = game["headicon_axis"];
				self.headiconteam = "axis";
			}
		}
	}
	else if(level.battlerank)
	{
		self.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(self);
	}	

	// Check to see if the player changed weapon class during round.
	if(isDefined(self.nextroundweapon))
	{
		self.pers["weapon"] = self.nextroundweapon;
		self.nextroundweapon = undefined;
	}

	// setup all the weapons
	self maps\mp\gametypes\_pam_loadout_gmi::PlayerSpawnLoadout();

	self.usedweapons = false;
	thread maps\mp\gametypes\_pam_teams::watchWeaponUsage();
	
	// setup the hud rank indicator
	self thread maps\mp\gametypes\_rank_gmi::RankHudInit();

	level.allowcaptures = true;
}

Worms_Stoppable_Clock()
{
	minutes = 0;
	tens_seconds = 0;
	seconds = level.timelimit * 60;
	while (seconds > 59)
	{
		minutes++;
		seconds = seconds - 60;
	}
	while (seconds > 9)
	{
		tens_seconds++;
		seconds = seconds - 10;
	}

	//Setup Clock HUDS
	level.clockcolon = newHudElem();
	level.clockcolon.x = 597;
	level.clockcolon.y = 412;
	level.clockcolon.alignX = "center";
	level.clockcolon.alignY = "middle";
	level.clockcolon.fontScale = 1.7;
	level.clockcolon.color = (1, 1, 1);
	level.clockcolon.alpha = .9;
	level.clockcolon setText(game["colon"]);

	while (1)
	{
		if (isdefined(level.clockmins))
		{
			level.clockmins destroy();
			level.clocktensecs destroy();
			level.clocksecs destroy();
		}

		level.clockmins = newHudElem();
		level.clockmins.x = 589;
		if (minutes > 9)
			level.clockmins.x = 584;
		level.clockmins.y = 412;
		level.clockmins.alignX = "center";
		level.clockmins.alignY = "middle";
		level.clockmins.fontScale = 1.7;
		level.clockmins.color = (1, 1, 1);
		level.clockmins.alpha = .9;
		level.clockmins setValue(minutes);

		level.clocktensecs = newHudElem();
		level.clocktensecs.x = 605;
		level.clocktensecs.y = 412;
		level.clocktensecs.alignX = "center";
		level.clocktensecs.alignY = "middle";
		level.clocktensecs.fontScale = 1.7;
		level.clocktensecs.color = (1, 1, 1);
		level.clocktensecs.alpha = .9;
		level.clocktensecs setValue(tens_seconds);

		level.clocksecs = newHudElem();
		level.clocksecs.x = 617;
		level.clocksecs.y = 412;
		level.clocksecs.alignX = "center";
		level.clocksecs.alignY = "middle";
		level.clocksecs.fontScale = 1.7;
		level.clocksecs.color = (1, 1, 1);
		level.clocksecs.alpha = .9;
		level.clocksecs setValue(seconds);

		while (!level.allowcaptures)
		{
			wait .5;
		}

		// Check and see if we are out of time
		if (minutes == 0 && tens_seconds == 0 && seconds == 0)
			return;

		if (level.roundended)
			return;

		// Not out of time, take off a second
		seconds = seconds - 1;
		if (seconds == -1)
		{
			seconds = 9;
			tens_seconds = tens_seconds - 1;
			if (tens_seconds == -1 && minutes > 0)
			{
				tens_seconds = 5;
				minutes = minutes - 1;
			}
			else if (tens_seconds == -1)
			{
				tens_seconds = 0;
			}
		}

		wait 1;
	}
}

Do_Ready_Up()
{
	Create_HUD_Header();

	Ready_UP();

	if (game["firsthalfready"] == 0)
	{
		Create_HUD_PlayersReady("1");

		if (getcvar("sv_consolelock") )
			setCvar("sv_disableClientConsole", "1");
	}
	else
		Create_HUD_PlayersReady("2");

	wait 5;

	if(isdefined(level.demosrecording))
		level.demosrecording destroy();

	Destroy_HUD_Header();

	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();

	if(isdefined(level.allready))
		level.allready destroy();
	if(isdefined(level.halfstart))
		level.halfstart destroy();
	//end readyup

	//Starting Round 1 Clock
	time = getCvarInt("g_roundwarmuptime");
	
	if ( time < 1 )
		time = 1;

	// give all of the players clocks to count down until the half starts
	if (game["firsthalfready"] == 0)
		Create_HUD_RoundStart(1);
	else
		Create_HUD_RoundStart(2);

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if ( isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue;
			
		player thread stopwatch2_start("match_start", time);
	}
	
	wait (time);

	Destroy_HUD_RoundStart();

	game["readyup"] = 0;
}

stopwatch2_start(reason, time)
{
	if(isDefined(self.stopwatch))
		self.stopwatch destroy();
		
	self.stopwatch = newClientHudElem(self);
	maps\mp\_util_mp_gmi::InitClock(self.stopwatch, time);
	self.stopwatch.archived = false;

	wait (time);

	if(isDefined(self.stopwatch)) 
		self.stopwatch destroy();
}

Pub_Match_Start()
{
	//Starting Round 1 Clock
	time = getCvarInt("g_roundwarmuptime");
	
	if ( time < 1 )
		time = 1;

	// give all of the players clocks to count down until the half starts
	Create_HUD_RoundStart(1);

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if ( isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue;
			
		player thread stopwatch2_start("match_start", time);
	}
	
	wait (time);

	Destroy_HUD_RoundStart();

	game["readyup"] = 0;
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

	wait 7;

	if(isdefined(level.timeexp))
		level.timeexp destroy();
}

Create_HUD_RoundStart(half)
{
	if (half == 1)
	{
		level.round = newHudElem();
		level.round.x = 540;
		level.round.y = 360;
		level.round.alignX = "center";
		level.round.alignY = "middle";
		level.round.fontScale = 1;
		level.round.color = (1, 1, 0);
		level.round setText(game["first"]);	
	}
	else
	{
		level.round = newHudElem();
		level.round.x = 540;
		level.round.y = 360;
		level.round.alignX = "center";
		level.round.alignY = "middle";
		level.round.fontScale = 1;
		level.round.color = (1, 1, 0);
		level.round setText(game["second"]);	
	}
		
	level.roundnum = newHudElem();
	level.roundnum.x = 540;
	level.roundnum.y = 380;
	level.roundnum.alignX = "center";
	level.roundnum.alignY = "middle";
	level.roundnum.fontScale = 1;
	level.roundnum.color = (1, 1, 0);
	level.roundnum setText(game["half"]);

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
			level.halfstart = newHudElem();
			level.halfstart.x = 320;
			level.halfstart.y = 300;
			level.halfstart.alignX = "center";
			level.halfstart.alignY = "middle";
			level.halfstart.fontScale = 2;
			level.halfstart.color = (0, 1, 0);
			level.halfstart setText(game["start1sthalf"]);
		}
		else
		{
			level.halfstart = newHudElem();
			level.halfstart.x = 320;
			level.halfstart.y = 300;
			level.halfstart.alignX = "center";
			level.halfstart.alignY = "middle";
			level.halfstart.fontScale = 2;
			level.halfstart.color = (0, 1, 0);
			level.halfstart setText(game["start2ndhalf"]);
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
			level.halfstart = newHudElem();
			level.halfstart.x = 320;
			level.halfstart.y = 370;
			level.halfstart.alignX = "center";
			level.halfstart.alignY = "middle";
			level.halfstart.fontScale = 1.5;
			level.halfstart.color = (0, 1, 0);
			level.halfstart setText(game["start1sthalf"]);
		}
		else
		{
			level.halfstart = newHudElem();
			level.halfstart.x = 320;
			level.halfstart.y = 370;
			level.halfstart.alignX = "center";
			level.halfstart.alignY = "middle";
			level.halfstart.fontScale = 1.5;
			level.halfstart.color = (0, 1, 0);
			level.halfstart setText(game["start2ndhalf"]);
		}
	}
}

Create_HUD_readyup()
{
	if (getcvar("sv_scoreboard") == "big" || getcvar("sv_scoreboard") == "small")
	{
		level.waiting = newHudElem();
		level.waiting.x = 320;
		level.waiting.y = 265;
		level.waiting.alignX = "center";
		level.waiting.alignY = "middle";
		level.waiting.fontScale = 2;
		level.waiting.color = (1, 0, 0);
		level.waiting setText(game["waiting"]);
	}
	else
	{
		level.waiting = newHudElem();
		level.waiting.x = 575;
		level.waiting.y = 210;
		level.waiting.alignX = "center";
		level.waiting.alignY = "middle";
		level.waiting.fontScale = 1.5;
		level.waiting.color = (1, 0, 0);
		level.waiting setText(game["waiting2"]);
	}
}

Create_HUD_Header()
{
	level.pamlogo = newHudElem();
	level.pamlogo.x = 630;
	level.pamlogo.y = 25;
	level.pamlogo.alignX = "right";
	level.pamlogo.alignY = "top";
	level.pamlogo.fontScale = 1;
	level.pamlogo.color = (0, 0, 1);
	level.pamlogo setText(game["pamstring"]);

	level.pammode = newHudElem();
	level.pammode.x = 10;
	level.pammode.y = 25;
	level.pammode.alignX = "left";
	level.pammode.alignY = "top";
	level.pammode.fontScale = 1;
	level.pammode.color = (1, 1, 0);
	level.pammode setText(game["leaguestring"]);

	if(getcvarint("g_ot_active") > 0)
	{
		level.overtimemode = newHudElem();
		level.overtimemode.x = 10;
		level.overtimemode.y = 45;
		level.overtimemode.alignX = "left";
		level.overtimemode.alignY = "top";
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
		if (game["team2score"] > game["team1score"])
		{
			level.teamwin = newHudElem();
			level.teamwin.x = 320;
			level.teamwin.y = 300;
			level.teamwin.alignX = "center";
			level.teamwin.alignY = "middle";
			level.teamwin.fontScale = 2;
			level.teamwin.color = (0, 153, 0);
			level.teamwin setText(game["team2win"]);

			setcvar("g_ot_active", "0");
		}
		else if (game["team2score"] < game["team1score"])
		{
			level.teamwin = newHudElem();
			level.teamwin.x = 320;
			level.teamwin.y = 300;
			level.teamwin.alignX = "center";
			level.teamwin.alignY = "middle";
			level.teamwin.fontScale = 2;
			level.teamwin.color = (1, 0, 0);
			level.teamwin setText(game["team1win"]);

			setcvar("g_ot_active", "0");
		}
		else
		{
			level.teamwin = newHudElem();
			level.teamwin.x = 320;
			level.teamwin.y = 300;
			level.teamwin.alignX = "center";
			level.teamwin.alignY = "middle";
			level.teamwin.fontScale = 2;
			level.teamwin.color = (1, 1, 0);
			level.teamwin setText(game["dsptie"]);

			if (getcvar("g_ot") == "1")
				setcvar("g_ot_active", "1");
			else
				setcvar("g_ot_active", "0");
		}
	}
	else
	{
		if (game["team2score"] > game["team1score"])
		{
			level.teamwin = newHudElem();
			level.teamwin.x = 575;
			level.teamwin.y = 220;
			level.teamwin.alignX = "center";
			level.teamwin.alignY = "middle";
			level.teamwin.fontScale = 1;
			level.teamwin.color = (.85, .99, .99);
			level.teamwin setText(game["team2win"]);

			setcvar("g_ot_active", "0");
		}
		else if (game["team2score"] < game["team1score"])
		{
			level.teamwin = newHudElem();
			level.teamwin.x = 575;
			level.teamwin.y = 220;
			level.teamwin.alignX = "center";
			level.teamwin.alignY = "middle";
			level.teamwin.fontScale = 1;
			level.teamwin.color = (.73, .99, .75);
			level.teamwin setText(game["team1win"]);

			setcvar("g_ot_active", "0");
		}
		else
		{
			level.teamwin = newHudElem();
			level.teamwin.x = 575;
			level.teamwin.y = 220;
			level.teamwin.alignX = "center";
			level.teamwin.alignY = "middle";
			level.teamwin.fontScale = 1;
			level.teamwin.color = (1, 1, 0);
			level.teamwin setText(game["dsptie"]);

			if (getcvar("g_ot") == "1")
				setcvar("g_ot_active", "1");
			else
				setcvar("g_ot_active", "0");
		}
	}
}

Destroy_HUD_TeamWin()
{
	if(isdefined(level.teamwin))
		level.teamwin destroy();
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
			level.firhalfalliesscore.color = (0, 153, 0);
			level.firhalfalliesscore setText(game["dspalliesscore"]);
				
			level.firhalfalliesscorenum = newHudElem();
			level.firhalfalliesscorenum.x = 440;
			level.firhalfalliesscorenum.y = 145;
			level.firhalfalliesscorenum.alignX = "center";
			level.firhalfalliesscorenum.alignY = "middle";
			level.firhalfalliesscorenum.fontScale = 1;
			level.firhalfalliesscorenum.color = (0, 153, 0);
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
			level.sechalfaxisscore.color = (0, 153, 0);
			level.sechalfaxisscore setText(game["dspaxisscore"]);
				
			level.sechalfaxisscorenum = newHudElem();
			level.sechalfaxisscorenum.x = 440;
			level.sechalfaxisscorenum.y = 205;
			level.sechalfaxisscorenum.alignX = "center";
			level.sechalfaxisscorenum.alignY = "middle";
			level.sechalfaxisscorenum.fontScale = 1;
			level.sechalfaxisscorenum.color = (0, 153, 0);
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
		level.team2.color = (0, 153, 0);
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
		level.matchaxisscorenum setValue(game["team1score"]);

		level.matchalliesscorenum = newHudElem();
		level.matchalliesscorenum.x = 440;
		level.matchalliesscorenum.color = (0, 153, 0);

		if (getcvar("sv_scoreboard") == "big")
			level.matchalliesscorenum.y = 240;
		else
			level.matchalliesscorenum.y = 135;
		level.matchalliesscorenum.alignX = "center";
		level.matchalliesscorenum.alignY = "middle";
		level.matchalliesscorenum.fontScale = 2;
		level.matchalliesscorenum setValue(game["team2score"]);
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
		level.matchaxisscorenum setValue(game["team1score"]);

		level.matchalliesscorenum = newHudElem();
		level.matchalliesscorenum.x = 618;
		level.matchalliesscorenum.y = 327;
		level.matchalliesscorenum.color = (.85, .99, .99);
		level.matchalliesscorenum.alignX = "center";
		level.matchalliesscorenum.alignY = "middle";
		level.matchalliesscorenum.fontScale = 1;
		level.matchalliesscorenum setValue(game["team2score"]);
	}
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

resetAllScores()
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

Ready_UP()
{
	maps\mp\gametypes\_pam_readyup::PAM_Ready_UP();
}