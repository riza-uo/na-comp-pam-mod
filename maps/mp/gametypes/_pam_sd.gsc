// PAM Enabled Script
PamMain()
{
	level.callbackStartGameType = ::Callback_StartGameType;
	level.callbackPlayerConnect = ::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = ::Callback_PlayerDamage;
	level.callbackPlayerKilled = ::Callback_PlayerKilled;

	maps\mp\gametypes\_callbacksetup::SetupCallbacks();

	level.mapname = getcvar("mapname");
	maps\mp\gametypes\_pam_utilities::NonstockPK3Check();

	level._effect["bombexplosion"] = loadfx("fx/explosions/mp_bomb.efx");

	allowed[0] = "sd";
	allowed[1] = "bombzone";
	allowed[2] = "blocker";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	maps\mp\gametypes\_rank_gmi::InitializeBattleRank();
	maps\mp\gametypes\_secondary_gmi::Initialize();
	
	level.warmup = 0;	// warmup time reset in case they restart map via menu

	if(getCvar("scr_sd_timelimit") == "")		// Time limit per map
		setCvar("scr_sd_timelimit", "0");
	else if(getCvarFloat("scr_sd_timelimit") > 1440)
		setCvar("scr_sd_timelimit", "1440");
	level.timelimit = getCvarFloat("scr_sd_timelimit");
	setCvar("ui_sd_timelimit", level.timelimit);
	makeCvarServerInfo("ui_sd_timelimit", "0");

	if(!isDefined(game["timepassed"]))
		game["timepassed"] = 0;

	if(getCvar("scr_sd_scorelimit") == "")		// Score limit per map
		setCvar("scr_sd_scorelimit", "10");
	level.scorelimit = getCvarInt("scr_sd_scorelimit");
	setCvar("ui_sd_scorelimit", level.scorelimit);
	makeCvarServerInfo("ui_sd_scorelimit", "10");

	if(getCvar("scr_sd_roundlimit") == "")		// Round limit per map
		setCvar("scr_sd_roundlimit", "0");
	level.roundlimit = getCvarInt("scr_sd_roundlimit");
	setCvar("ui_sd_roundlimit", level.roundlimit);
	makeCvarServerInfo("ui_sd_roundlimit", "0");

	if(getCvar("scr_sd_roundlength") == "")		// Time length of each round
		setCvar("scr_sd_roundlength", "4");
	else if(getCvarFloat("scr_sd_roundlength") > 10)
		setCvar("scr_sd_roundlength", "10");
	level.roundlength = getCvarFloat("scr_sd_roundlength");

	if(getCvar("scr_sd_graceperiod") == "")		// Time at round start where spawning and weapon choosing is still allowed
		setCvar("scr_sd_graceperiod", "15");
	else if(getCvarFloat("scr_sd_graceperiod") > 60)
		setCvar("scr_sd_graceperiod", "60");
	level.graceperiod = getCvarFloat("scr_sd_graceperiod");

	if(getCvar("scr_battlerank") == "")		
		setCvar("scr_battlerank", "1");	//default is ON
	level.battlerank = getCvarint("scr_battlerank");
	setCvar("ui_battlerank", level.battlerank);
	makeCvarServerInfo("ui_battlerank", "0");

	if(getCvar("scr_shellshock") == "")		// controls whether or not players get shellshocked from grenades or rockets
		setCvar("scr_shellshock", "1");
	level.sshock = getcvarint("scr_shellshock");
	setCvar("ui_shellshock", getCvar("scr_shellshock"));
	makeCvarServerInfo("ui_shellshock", "0");
			
	if(!isDefined(game["compass_range"]))		// set up the compass range.
		game["compass_range"] = 1024;		
	setCvar("cg_hudcompassMaxRange", game["compass_range"]);
	makeCvarServerInfo("cg_hudcompassMaxRange", "0");

	if(getCvar("scr_drophealth") == "")		// Free look spectator
		setCvar("scr_drophealth", "1");
	level.healthdrop = getCvar("scr_drophealth");

	killcam = getCvar("scr_killcam");
	if(killcam == "")				// Kill cam
		killcam = "1";
	setCvar("scr_killcam", killcam, true);
	level.killcam = getCvarInt("scr_killcam");
	
	if(getCvar("scr_teambalance") == "")		// Auto Team Balancing
		setCvar("scr_teambalance", "0");
	level.teambalance = getCvarInt("scr_teambalance");
	level.lockteams = false;

	if(getCvar("scr_freelook") == "")		// Free look spectator
		setCvar("scr_freelook", "1");
	level.allowfreelook = getCvarInt("scr_freelook");
	
	if(getCvar("scr_spectateenemy") == "")		// Spectate Enemy Team
		setCvar("scr_spectateenemy", "1");
	level.allowenemyspectate = getCvarInt("scr_spectateenemy");
	
	if(getCvar("scr_drawfriend") == "")		// Draws a team icon over teammates
		setCvar("scr_drawfriend", "1");
	level.drawfriend = getCvarInt("scr_drawfriend");

	if(getCvar("scr_sd_clearscoreeachhalf") == "")		// Reset Player Scores at halftime
		setCvar("scr_sd_clearscoreeachhalf", "1");

//BEGIN WORM
	if(getCvar("sv_pure") == "")
		setCvar("sv_pure", "0");

	if(getCvar("g_allowVote") == "")
		setCvar("g_allowVote", "0");

	if(getcvar("g_ot") == "")
		setcvar("g_ot", "0");

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
		level.scorelimit = getCvarInt("scr_sd_scorelimit");
		level.roundlimit = getCvarInt("scr_sd_roundlimit");

		ruleset = getCvar("pam_mode");
		switch(ruleset)
		{
		case "twl_ladder":
			thread maps\mp\gametypes\rules\_twl_ladder_sd_rules::Rules();
			break;
		case "twl_rifles":
			thread maps\mp\gametypes\rules\_twl_rifles_sd_rules::Rules();
			break;
		case "twl_classic_ladder":
			thread maps\mp\gametypes\rules\_twl_classic_ladder_sd_rules::Rules();
			break;
		case "twl_league":
			thread maps\mp\gametypes\rules\_twl_league_sd_rules::Rules();
			break;
		case "ogl":
			thread maps\mp\gametypes\rules\_ogl_sd_rules::Rules();
			break;
		case "cb":
			thread maps\mp\gametypes\rules\_cb_sd_rules::Rules();
			break;
		case "cal":
			thread maps\mp\gametypes\rules\_cal_sd_rules::Rules();
			break;
		case "bl":
			thread maps\mp\gametypes\rules\_britleague_sd_rules::Rules();
			break;
		case "mgl":
			thread maps\mp\gametypes\rules\_mgl_sd_rules::Rules();
			break;
		case "kw":
			thread maps\mp\gametypes\rules\_kw_sd_rules::Rules();
			break;
		case "bl_classic":
			thread maps\mp\gametypes\rules\_britleague_classic_sd_rules::Rules();
			break;
		case "na_comp":
			thread maps\mp\gametypes\rules\_na_comp_sd_rules::Rules();
			break;
		case "lan":
			thread maps\mp\gametypes\rules\_lan_sd_rules::Rules();
			break;

		default:
			thread maps\mp\gametypes\rules\_public_sd_rules::Rules();
			setCvar("pam_mode", "pub");
			break;
		}

		if(!isDefined(game["mode"]))
			game["mode"] = "match";

		setcvar("scr_numbots", "11");
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
	if(getcvar("sv_playersleft") == "")			// display players left
		setcvar("sv_playersleft", "1");		
	if(getcvar("sv_warmupmines") == "")			// warmup mines off/on
		setcvar("sv_warmupmines", "0");	
	if ( getcvar( "sv_BombPlantTime" ) == ""  )
		setcvar("sv_BombPlantTime", "10");
	if ( getcvar( "sv_BombDefuseTime" ) == "")
		setcvar("sv_BombDefuseTime", "10");
	if ( getcvar( "sv_BombTimer" ) == "" )
		setcvar("sv_BombTimer", "60");
	if(getcvar("sv_showBombTimer") == "" )
		setcvar("sv_showBombTimer", "0");

	/* Set up Level variables */
	// level settings
	level.timelimit = getCvarFloat("scr_sd_timelimit");
	level.roundlength = getCvarFloat("scr_sd_roundlength");
	level.graceperiod = getCvarFloat("scr_sd_graceperiod");
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
	level.playersleft = getcvarint("sv_playersleft");
	level.halfround = getcvarint("scr_sd_half_round");
	level.halfscore = getcvarint("scr_sd_half_score");
	level.matchround = getcvarint("scr_sd_end_round");
	level.matchscore1 = getcvarint("scr_sd_end_score");
	level.matchscore2 = getcvarint("scr_sd_end_half2score");
	level.countdraws = getcvarint("scr_sd_count_draws");
	level.planttime = getcvarFloat("sv_BombPlantTime");
	level.defusetime = getcvarFloat("sv_BombDefuseTime");
	level.countdowntime = getcvarFloat("sv_BombTimer");
	level.countdownclock = getcvar("sv_ShowBombTimer");
	//CODUO NA COMP ADDITION - bomb timer colors
	level.countdowntimerstartcolor = (1, 1, 0);
	level.countdowntimerendcolor = (1, 0, 0);
	level.overtime = 0;	//Makes sure OT settings get loaded after defaults loaded
	level.rdyup = 0;
	level.hithalftime = 0;
	level.readyname = [];
	level.readystate = [];
	level.playersready = false;
	level.checksettings = 0;
	level.killvehicles = false;

	//Ready-Up
	level.R_U_Name = [];
	level.R_U_State = [];

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


	if(!isdefined(game["halftimeflag"]))
	{
		game["dolive"] = "0";
		game["halftimeflag"] = "0";
		game["round1alliesscore"] = 0;
		game["round1axisscore"] = 0; 
		game["round2alliesscore"] = 0;
		game["round2axisscore"] = 0;
	}

	// WEAPON EXPLOIT FIX
	if(!isDefined(game["dropsecondweap"]))
		game["dropsecondweap"] = false;
	
	//Message Center
	if(game["mode"] != "match" && getCvar("sv_messagecenter") == "1")
		thread maps\mp\gametypes\_message_center::messages();

	//PAM UO Admin Tools
	thread maps\mp\gametypes\_pam_admin::main();

// END WORM

	if(!isDefined(game["state"]))
		game["state"] = "playing";
	if(!isDefined(game["roundsplayed"]))
		game["roundsplayed"] = 0;
	if(!isDefined(game["matchstarted"]))
		game["matchstarted"] = false;
		
	if(!isDefined(game["alliedscore"]))
		game["alliedscore"] = 0;
	setTeamScore("allies", game["alliedscore"]);

	if(!isDefined(game["axisscore"]))
		game["axisscore"] = 0;
	setTeamScore("axis", game["axisscore"]);

	// turn off ceasefire
	level.ceasefire = 0;
	setCvar("scr_ceasefire", "0");

	level.bombplanted = false;
	level.bombexploded = false;
	level.roundstarted = false;
	level.roundended = false;
	level.mapended = false;
	
	if (!isdefined (game["BalanceTeamsNextRound"]))
		game["BalanceTeamsNextRound"] = false;
	
	level.exist["allies"] = 0;
	level.exist["axis"] = 0;
	level.exist["teams"] = false;
	level.didexist["allies"] = false;
	level.didexist["axis"] = false;

	level.healthqueue = [];
	level.healthqueuecurrent = 0;

	if(level.killcam >= 1)
		setarchive(true);
}

Callback_StartGameType()
{
	// if this is a fresh map start, set nationalities based on cvars, otherwise leave game variable nationalities as set in the level script
	if(!isDefined(game["gamestarted"]))
	{
		// defaults if not defined in level script
		if(!isDefined(game["allies"]))
			game["allies"] = "american";
		if(!isDefined(game["axis"]))
			game["axis"] = "german";

		if(!isDefined(game["layoutimage"]))
			game["layoutimage"] = "default";
		layoutname = "levelshots/layouts/hud@layout_" + game["layoutimage"];
		precacheShader(layoutname);
		setCvar("scr_layoutimage", layoutname);
		makeCvarServerInfo("scr_layoutimage", "");

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

		//Bomb Plant Announcement
		game["planted"] = &"Explosives Planted";
		precacheString(game["planted"]);

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

		precacheShader("hudStopwatch");

		/* end PAM precacheStrings */
		// END WORM

		precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");
		precacheString(&"MPSCRIPT_KILLCAM");
		precacheString(&"SD_MATCHSTARTING");
		precacheString(&"SD_MATCHRESUMING");
		precacheString(&"SD_EXPLOSIVESPLANTED");
		precacheString(&"SD_EXPLOSIVESDEFUSED");
		precacheString(&"SD_ROUNDDRAW");
		precacheString(&"SD_TIMEHASEXPIRED");
		precacheString(&"SD_ALLIEDMISSIONACCOMPLISHED");
		precacheString(&"SD_AXISMISSIONACCOMPLISHED");
		precacheString(&"SD_ALLIESHAVEBEENELIMINATED");
		precacheString(&"SD_AXISHAVEBEENELIMINATED");
		precacheString(&"GMI_MP_CEASEFIRE");

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

		precacheShader("ui_mp/assets/hud@plantbomb.tga");
		precacheShader("ui_mp/assets/hud@defusebomb.tga");
		precacheShader("gfx/hud/hud@objectiveA.tga");
		precacheShader("gfx/hud/hud@objectiveA_up.tga");
		precacheShader("gfx/hud/hud@objectiveA_down.tga");
		precacheShader("gfx/hud/hud@objectiveB.tga");
		precacheShader("gfx/hud/hud@objectiveB_up.tga");
		precacheShader("gfx/hud/hud@objectiveB_down.tga");
		precacheShader("gfx/hud/hud@bombplanted.tga");
		precacheShader("gfx/hud/hud@bombplanted_up.tga");
		precacheShader("gfx/hud/hud@bombplanted_down.tga");
		precacheShader("gfx/hud/hud@bombplanted_down.tga");
		precacheModel("xmodel/mp_bomb1_defuse");
		precacheModel("xmodel/mp_bomb1");
		precacheItem("item_health");
	
	
		maps\mp\gametypes\_pam_teams::precache();
		maps\mp\gametypes\_pam_teams::scoreboard();

		//thread addBotClients();
	}
	
	maps\mp\gametypes\_pam_teams::modeltype();
	maps\mp\gametypes\_pam_teams::initGlobalCvars();
	maps\mp\gametypes\_pam_teams::initWeaponCvars();
	maps\mp\gametypes\_pam_teams::restrictPlacedWeapons();
	thread maps\mp\gametypes\_pam_teams::updateGlobalCvars();
	thread maps\mp\gametypes\_pam_teams::updateWeaponCvars();

	game["gamestarted"] = true;
	
	setClientNameMode("manual_change");

	thread bombzones();
	thread startGame();
	thread updateGametypeCvars();
	//thread addBotClients();
}

Callback_PlayerConnect()
{
	self.statusicon = "gfx/hud/hud@status_connecting.tga";
	self waittill("begin");
	self.statusicon = "";
	self.pers["teamTime"] = 1000000;

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
	
	// make sure that the rank variable is initialized
	if ( !isDefined( self.pers["rank"] ) )
		self.pers["rank"] = 0;

	if(game["state"] == "intermission")
	{
		spawnIntermission();
		return;
	}

	level endon("intermission");

	// start the vsay thread
	self thread maps\mp\gametypes\_pam_teams::vsay_monitor();
	
	if(isDefined(self.pers["team"]) && self.pers["team"] != "spectator")
	{
		self setClientCvar("ui_weapontab", "1");

		if(self.pers["team"] == "allies")
		{
			maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
		}
		else
		{
			maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
		}

		if(isDefined(self.pers["weapon"]))
			spawnPlayer();
		else
		{
			self.sessionteam = "spectator";

			spawnSpectator();
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

		if(!isDefined(self.pers["team"]))
			self openMenu(game["menu_team"]);

		self.pers["team"] = "spectator";
		self.sessionteam = "spectator";

		spawnSpectator();
	}

	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		if(response == "open" || response == "close")
			continue;

		if(menu == game["menu_team"])
		{
			switch(response)
			{
			case "allies":
			case "axis":
			case "autoassign":
				if (level.lockteams)
					break;

				if (game["switchprevent"] == 1 && self.sessionteam != "spectator")
					break;

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
	                        
				self.pers["team"] = response;
				self.pers["teamTime"] = (gettime() / 1000);
				self.pers["weapon"] = undefined;
				self.pers["weapon1"] = undefined;
				self.pers["weapon2"] = undefined;
				self.pers["spawnweapon"] = undefined;
				self.pers["savedmodel"] = undefined;
				self.grenadecount = undefined;

				// update spectator permissions immediately on change of team
				maps\mp\gametypes\_pam_teams::SetSpectatePermissions();

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
				if (level.lockteams)
					break;
				if(self.pers["team"] != "spectator")
				{
					if(isAlive(self))
						self suicide();

					self.pers["team"] = "spectator";
					self.pers["teamTime"] = 1000000;
					self.pers["weapon"] = undefined;
					self.pers["weapon1"] = undefined;
					self.pers["weapon2"] = undefined;
					self.pers["spawnweapon"] = undefined;
					self.pers["savedmodel"] = undefined;
					self.grenadecount = undefined;

					self.sessionteam = "spectator";
					self setClientCvar("g_scriptMainMenu", game["menu_team"]);
					self setClientCvar("ui_weapontab", "0");
					spawnSpectator();
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
			//WORM BIG DIFFERENCE HERE (SPAWNING - MATCH START)	
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

	if(game["matchstarted"])
		level thread updateTeamStatus();
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	if(level.warmup != 0)
		return;

	if(self.sessionteam == "spectator")
		return;

	// dont take damage during ceasefire mode
	// but still take damage from ambient damage (water, minefields, fire)
	if(level.ceasefire && sMeansOfDeath != "MOD_EXPLOSIVE" && sMeansOfDeath != "MOD_WATER")
		return;

	// Don't do knockback if the damage direction was not specified
	if(!isDefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

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

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
	self endon("spawned");

	if(level.warmup != 0)
		return;

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

	self.sessionstate = "dead";
	if(level.rdyup != 1)
		self.statusicon = "gfx/hud/hud@status_dead.tga";
	self.headicon = "";
	self.noInactivityKick = 1;
	self.grenadecount = undefined;
	if (!isdefined (self.autobalance))
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

	if(isPlayer(attacker))
	{
		if(attacker == self) // killed himself
		{
			doKillcam = false;
			if (!isdefined (self.autobalance))
			{
				attacker.pers["score"]--;
				attacker.score = attacker.pers["score"];
			}
			
			if(isDefined(attacker.friendlydamage))
				clientAnnouncement(attacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT"); 
		}
		else
		{
			attackerNum = attacker getEntityNumber();
			doKillcam = true;

			if(self.pers["team"] == attacker.pers["team"]) // killed by a friendly
			{
				attacker.pers["score"]--;
				attacker.score = attacker.pers["score"];
			}
			else
			{
				attacker.pers["score"]++;
				attacker.score = attacker.pers["score"];
			}
		}
		
		lpattacknum = attacker getEntityNumber();
		lpattackguid = attacker getGuid();
		lpattackname = attacker.name;
		lpattackerteam = attacker.pers["team"];
	}
	else // If you weren't killed by a player, you were in the wrong place at the wrong time
	{
		doKillcam = false;

		self.pers["score"]--;
		self.score = self.pers["score"];

		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";
		lpattackerteam = "world";
	}

	logPrint("K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

	// Make the player drop his weapon
	if (!isdefined (self.autobalance))
	{
		dropSniper();
		
		// Make the player drop health
		self dropHealth();
	}

	self.pers["weapon1"] = undefined;
	self.pers["weapon2"] = undefined;
	self.pers["spawnweapon"] = undefined;
	
	if (!isdefined (self.autobalance))
		body = self cloneplayer();
	self.autobalance = undefined;

	updateTeamStatus();

	// TODO: Add additional checks that allow killcam when the last player killed wouldn't end the round (bomb is planted)
	if((getCvarInt("scr_killcam") <= 0) || !level.exist[self.pers["team"]]) // If the last player on a team was just killed, don't do killcam
		doKillcam = false;

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// ?? Also required for Callback_PlayerKilled to complete before killcam can execute

	if(doKillcam && !level.roundended)
		self thread killcam(attackerNum, delay);
	else
	{
		currentorigin = self.origin;
		currentangles = self.angles;

		self thread spawnSpectator(currentorigin + (0, 0, 60), currentangles);
	}
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
		if(isDefined(self.pers["weapon"]))
		{
	 		self.pers["weapon"] = weapon;
			self.pers["weapon1"] = weapon;

			// setup all the weapons
			self maps\mp\gametypes\_pam_loadout_gmi::PlayerSpawnLoadout();
	 		self setWeaponSlotWeapon("primary", weapon);
//			self setWeaponSlotAmmo("primary", 999);
//			self setWeaponSlotClipAmmo("primary", 999);
			self switchToWeapon(weapon);

//			maps\mp\gametypes\_teams::givePistol();
//			maps\mp\gametypes\_teams::giveGrenades(self.pers["selectedweapon"]);
		}
		else
		{
			self.pers["weapon"] = weapon;
			self.pers["weapon1"] = weapon;
			self.spawned = undefined;
			spawnPlayer();
			self thread printJoinedTeam(self.pers["team"]);
			level checkMatchStart();
		}
	}
	else if(!level.roundstarted && !self.usedweapons)
	{
	 	if(isDefined(self.pers["weapon"]))
	 	{
	 		self.pers["weapon"] = weapon;
			self.pers["weapon1"] = weapon;
			// setup all the weapons
			self maps\mp\gametypes\_pam_loadout_gmi::PlayerSpawnLoadout();
	 		self setWeaponSlotWeapon("primary", weapon);
//			self setWeaponSlotAmmo("primary", 999);
//			self setWeaponSlotClipAmmo("primary", 999);
			self switchToWeapon(weapon);

//			maps\mp\gametypes\_teams::givePistol();
//			maps\mp\gametypes\_teams::giveGrenades(self.pers["selectedweapon"]);
		}
	 	else
		{			 	
			self.pers["weapon"] = weapon;
			if(!level.exist[self.pers["team"]])
			{
				self.spawned = undefined;
				spawnPlayer();
				self thread printJoinedTeam(self.pers["team"]);
				level checkMatchStart();
			}
			else
			{
				spawnPlayer();
				self thread printJoinedTeam(self.pers["team"]);
			}
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
			spawnPlayer();
			self thread printJoinedTeam(self.pers["team"]);
		}				
		else if(!level.didexist[self.pers["team"]] && !level.roundended)
		{
			self.spawned = undefined;
			spawnPlayer();
			self thread printJoinedTeam(self.pers["team"]);
			level checkMatchStart();
		}
		else
		{
			weaponname = maps\mp\gametypes\_pam_teams::getWeaponName(self.pers["weapon"]);

			if(self.pers["team"] == "allies")
			{
				if(maps\mp\gametypes\_pam_teams::useAn(self.pers["weapon"]))
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_AN_NEXT_ROUND", weaponname);
				else
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_ALLIED_WITH_A_NEXT_ROUND", weaponname);
			}
			else if(self.pers["team"] == "axis")
			{
				if(maps\mp\gametypes\_pam_teams::useAn(self.pers["weapon"]))
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_AN_NEXT_ROUND", weaponname);
				else
					self iprintln(&"MPSCRIPT_YOU_WILL_SPAWN_AXIS_WITH_A_NEXT_ROUND", weaponname);
			}
		}
	}
	self thread maps\mp\gametypes\_pam_teams::SetSpectatePermissions();
	if (isdefined (self.autobalance_notify))
		self.autobalance_notify destroy();
}

spawnPlayer()
{
	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();
	self notify("spawned");

	resettimeout();

	self.sessionteam = self.pers["team"];
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;
	self.noInactivityKick = 0;

	if(isDefined(self.spawned))
		return;

	self.sessionstate = "playing";
		
	if(self.pers["team"] == "allies")
		spawnpointname = "mp_searchanddestroy_spawn_allied";
	else
		spawnpointname = "mp_searchanddestroy_spawn_axis";

	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	
	self.spawned = true;
	if(level.rdyup != 1)
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
	
	// setup all the weapons
	self maps\mp\gametypes\_pam_loadout_gmi::PlayerSpawnLoadout();

	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();

	self.usedweapons = false;
	thread maps\mp\gametypes\_pam_teams::watchWeaponUsage();

	if(self.pers["team"] == game["attackers"])
		self setClientCvar("cg_objectiveText", &"SD_OBJ_ATTACKERS");
	else if(self.pers["team"] == game["defenders"])
		self setClientCvar("cg_objectiveText", &"SD_OBJ_DEFENDERS");
		
	if(level.drawfriend)
	{
		if(level.battlerank)
		{
			if(level.rdyup != 1)
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
	else if(level.battlerank && level.rdyup != 1)
	{
		self.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(self);
	}	

	// setup the hud rank indicator
	self thread maps\mp\gametypes\_rank_gmi::RankHudInit();
}

spawnSpectator(origin, angles)
{
	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();
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
		self spawn(origin, angles);
	else
	{
 		spawnpointname = "mp_searchanddestroy_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

		if(isDefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}

	updateTeamStatus();

	self.usedweapons = false;

	if(game["attackers"] == "allies")
		self setClientCvar("cg_objectiveText", &"SD_OBJ_SPECTATOR_ALLIESATTACKING");
	else if(game["attackers"] == "axis")
		self setClientCvar("cg_objectiveText", &"SD_OBJ_SPECTATOR_AXISATTACKING");
}

spawnIntermission()
{
	self notify("spawned");
	
	resettimeout();
	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();
	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;

	spawnpointname = "mp_searchanddestroy_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

killcam(attackerNum, delay)
{
	self endon("spawned");
	
	// killcam
	if(attackerNum < 0)
		return;

	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.archivetime = delay + 7;

	maps\mp\gametypes\_pam_teams::SetKillcamSpectatePermissions();

	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;

	if(self.archivetime <= delay)
	{
		self.spectatorclient = -1;
		self.archivetime = 0;
	
		maps\mp\gametypes\_pam_teams::SetSpectatePermissions();
		return;
	}

	self.killcam = true;

	if(!isDefined(self.kc_topbar))
	{
		self.kc_topbar = newClientHudElem(self);
		self.kc_topbar.archived = false;
		self.kc_topbar.x = 0;
		self.kc_topbar.y = 0;
		self.kc_topbar.alpha = 0.5;
		self.kc_topbar setShader("black", 640, 112);
	}

	if(!isDefined(self.kc_bottombar))
	{
		self.kc_bottombar = newClientHudElem(self);
		self.kc_bottombar.archived = false;
		self.kc_bottombar.x = 0;
		self.kc_bottombar.y = 368;
		self.kc_bottombar.alpha = 0.5;
		self.kc_bottombar setShader("black", 640, 112);
	}

	if(!isDefined(self.kc_title))
	{
		self.kc_title = newClientHudElem(self);
		self.kc_title.archived = false;
		self.kc_title.x = 320;
		self.kc_title.y = 40;
		self.kc_title.alignX = "center";
		self.kc_title.alignY = "middle";
		self.kc_title.sort = 1; // force to draw after the bars
		self.kc_title.fontScale = 3.5;
	}
	self.kc_title setText(&"MPSCRIPT_KILLCAM");

	if(!isDefined(self.kc_skiptext))
	{
		self.kc_skiptext = newClientHudElem(self);
		self.kc_skiptext.archived = false;
		self.kc_skiptext.x = 320;
		self.kc_skiptext.y = 70;
		self.kc_skiptext.alignX = "center";
		self.kc_skiptext.alignY = "middle";
		self.kc_skiptext.sort = 1; // force to draw after the bars
	}
	self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_SKIP");

	if(!isDefined(self.kc_timer))
	{
		self.kc_timer = newClientHudElem(self);
		self.kc_timer.archived = false;
		self.kc_timer.x = 320;
		self.kc_timer.y = 428;
		self.kc_timer.alignX = "center";
		self.kc_timer.alignY = "middle";
		self.kc_timer.fontScale = 3.5;
		self.kc_timer.sort = 1;
	}
	self.kc_timer setTenthsTimer(self.archivetime - delay);

	self thread spawnedKillcamCleanup();
	self thread waitSkipKillcamButton();
	self thread waitKillcamTime();
	self waittill("end_killcam");

	self removeKillcamElements();

	self.spectatorclient = -1;
	self.archivetime = 0;
	self.killcam = undefined;
	
	maps\mp\gametypes\_pam_teams::SetSpectatePermissions();
}

waitKillcamTime()
{
	self endon("end_killcam");
	
	wait(self.archivetime - 0.05);
	self notify("end_killcam");
}

waitSkipKillcamButton()
{
	self endon("end_killcam");
	
	while(self useButtonPressed())
		wait .05;

	while(!(self useButtonPressed()))
		wait .05;
	
	self notify("end_killcam");	
}

removeKillcamElements()
{
	if(isDefined(self.kc_topbar))
		self.kc_topbar destroy();
	if(isDefined(self.kc_bottombar))
		self.kc_bottombar destroy();
	if(isDefined(self.kc_title))
		self.kc_title destroy();
	if(isDefined(self.kc_skiptext))
		self.kc_skiptext destroy();
	if(isDefined(self.kc_timer))
		self.kc_timer destroy();
}

spawnedKillcamCleanup()
{
	self endon("end_killcam");

	self waittill("spawned");
	self removeKillcamElements();
}

startGame()
{
	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();
	level.starttime = getTime();
	thread startRound();
	
	if ( (level.teambalance > 0) && (!game["BalanceTeamsNextRound"]) )
		level thread maps\mp\gametypes\_pam_teams::TeamBalance_Check_Roundbased();
}

startRound()
{
	// WEAPON EXPLOIT FIX
	if (game["dropsecondweap"])
		DropSecWeapon();
	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();
	level.switchprevent = true;

	level endon("bomb_planted");

	thread maps\mp\gametypes\_pam_teams::sayMoveIn();

	level.clock = newHudElem();
	level.clock.x = 320;
	level.clock.y = 460;
	level.clock.alignX = "center";
	level.clock.alignY = "middle";
	level.clock.font = "bigfixed";
	level.clock setTimer(level.roundlength * 60);

	if(game["matchstarted"])
	{
		level.clock.color = (0, 1, 0);
		maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();

		if(game["dolive"] == "1" && level.warmup == 0)
		{
			game["dolive"] = "0";

			game["switchprevent"] = 1;
		}

		if((level.roundlength * 60) > level.graceperiod)
		{
			wait level.graceperiod;

			level notify("round_started");
			level.roundstarted = true;
			level.clock.color = (1, 1, 1);

			// Players on a team but without a weapon show as dead since they can not get in this round
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				player = players[i];

				if(player.sessionteam != "spectator" && !isDefined(player.pers["weapon"]))
					player.statusicon = "gfx/hud/hud@status_dead.tga";
			}
		
			wait((level.roundlength * 60) - level.graceperiod);
		}
		else
			wait(level.roundlength * 60);
	}
	else	
	{
		level.clock.color = (1, 1, 1);
		wait(level.roundlength * 60);
	}
	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();
	if(level.roundended)
		return;

	if(!level.exist[game["attackers"]] || !level.exist[game["defenders"]])
	{
		if(level.warmup == 1)
			return;

		announcement(&"SD_TIMEHASEXPIRED");
		level thread endRound("draw");
		return;
	}

	if(level.warmup != 1)
	{
		announcement(&"SD_TIMEHASEXPIRED");
		level thread endRound(game["defenders"]);
	}
}

checkMatchStart()
{
	oldvalue["teams"] = level.exist["teams"];
	level.exist["teams"] = false;
	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();
	// If teams currently exist
	if(level.exist["allies"] && level.exist["axis"])
		level.exist["teams"] = true;

	// If teams previously did not exist and now they do
	if(!oldvalue["teams"] && level.exist["teams"])
	{
		if(!game["matchstarted"])
		{
			if(!level.roundended)
			{

				Create_HUD_Header();

				if( game["mode"] == "match")
				{
				
					//readyup
					level.warmup = 1;

					maps\mp\gametypes\_pam_readyup::PAM_Ready_UP();

					if (getcvar("sv_consolelock") )
						setCvar("sv_disableClientConsole", "1");

					Create_HUD_PlayersReady("1");

					wait 5;
	
					if(isdefined(level.allready))
						level.allready destroy();
					if(isdefined(level.half1start))
						level.half1start destroy();

					// get rid of warmup weapons
					players = getentarray("player", "classname");
					for(i = 0; i < players.size; i++)
					{ 
	
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
	
						//pull up menus
						player = players[i];
						player closeMenu();
						player setClientCvar("g_scriptMainMenu", "main");
						if(player.pers["team"] == "allies")
							player setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
						else
							player setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
						if(player.pers["team"] == "allies")
							player openMenu(game["menu_weapon_allies"]);
						else if(player.pers["team"] == "axis")
							player openMenu(game["menu_weapon_axis"]);
	
					} //end for

					level.warmup = 0;
				}

				else
					wait 3;

				Destroy_HUD_Header();

				if (isdefined(level.demosrecording))
					level.demosrecording destroy();

				maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();

				//end readyup

			}
//			announcement(&"SD_MATCHSTARTING");

			level notify("kill_endround");
			level.roundended = false;
			level thread endRound("reset");
		}
		else
		{
			announcement(&"SD_MATCHRESUMING");

			level notify("kill_endround");
			level.roundended = false;
			level thread endRound("draw");
		}

		return;
	}
}

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
	game["round1alliesscore"] = 0;
	game["round1axisscore"] = 0; 
	game["round2alliesscore"] = 0;
	game["round2axisscore"] = 0;
	
	if (level.battlerank)
	{
		maps\mp\gametypes\_rank_gmi::ResetPlayerRank();
	}

}

endRound(roundwinner)
{
	level.switchprevent = false;
	level endon("kill_endround");

	if(level.roundended)
		return;
	level.roundended = true;

	// End bombzone threads and remove related hud elements and objectives
	level notify("round_ended");

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(isDefined(player.planticon))
			player.planticon destroy();

		if(isDefined(player.defuseicon))
			player.defuseicon destroy();

		if(isDefined(player.progressbackground))
			player.progressbackground destroy();

		if(isDefined(player.progressbar))
			player.progressbar destroy();

		player unlink();
		player enableWeapon();
	}

	objective_delete(0);
	objective_delete(1);

	if(roundwinner == "allies")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
			players[i] playLocalSound("MP_announcer_allies_win");
	}
	else if(roundwinner == "axis")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
			players[i] playLocalSound("MP_announcer_axis_win");
	}
	else if(roundwinner == "draw")
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
			players[i] playLocalSound("MP_announcer_round_draw");
	}

	wait 5;

	winners = "";
	losers = "";

	if(roundwinner == "allies")
	{
		if ( level.battlerank )
		{
			GivePointsToTeam( "allies", 3);
		}
		
		game["alliedscore"]++;
		setTeamScore("allies", game["alliedscore"]);

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
			lpGuid = players[i] getGuid();
			if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
				winners = (winners + ";" + lpGuid + ";" + players[i].name);
			else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
				losers = (losers + ";" + lpGuid + ";" + players[i].name);
		}
		logPrint("W;allies" + winners + "\n");
		logPrint("L;axis" + losers + "\n");
	}
	else if(roundwinner == "axis")
	{
		if ( level.battlerank )
		{
			GivePointsToTeam( "axis", 3);
		}
		
		game["axisscore"]++;
		setTeamScore("axis", game["axisscore"]);

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

	if(!game["matchstarted"] && roundwinner == "reset")
	{
		game["matchstarted"] = true;
		thread resetScores();
		game["roundsplayed"] = 0;
	}

	game["timepassed"] = game["timepassed"] + ((getTime() - level.starttime) / 1000) / 60.0;

	checkTimeLimit();

	if(level.mapended)
		return;
	level.mapended = true;

	// for all living players store their weapons
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
		{
			primary = player getWeaponSlotWeapon("primary");
			primaryb = player getWeaponSlotWeapon("primaryb");

			// If a menu selection was made
			if(isDefined(player.oldweapon))
			{
				// If a new weapon has since been picked up (this fails when a player picks up a weapon the same as his original)
				if(player.oldweapon != primary && player.oldweapon != primaryb && primary != "none")
				{
					player.pers["weapon1"] = primary;
					player.pers["weapon2"] = primaryb;
					player.pers["spawnweapon"] = player getCurrentWeapon();
				} // If the player's menu chosen weapon is the same as what is in the primaryb slot, swap the slots
				else if(player.pers["weapon"] == primaryb)
				{
					player.pers["weapon1"] = primaryb;
					player.pers["weapon2"] = primary;
					player.pers["spawnweapon"] = player.pers["weapon1"];
				} // Give them the weapon they chose from the menu
				else
				{
					player.pers["weapon1"] = player.pers["weapon"];
					player.pers["weapon2"] = primaryb;
					player.pers["spawnweapon"] = player.pers["weapon1"];
				}
			} // No menu choice was ever made, so keep their weapons and spawn them with what they're holding, unless it's a pistol or grenade
			else
			{
				if(primary == "none")
					player.pers["weapon1"] = player.pers["weapon"];
				else
					player.pers["weapon1"] = primary;
					
				player.pers["weapon2"] = primaryb;

				spawnweapon = player getCurrentWeapon();
				if ( (spawnweapon == "none") && (isdefined (primary)) ) 
					spawnweapon = primary;
				
				if(!maps\mp\gametypes\_pam_teams::isPistolOrGrenade(spawnweapon))
					player.pers["spawnweapon"] = spawnweapon;
				else
					player.pers["spawnweapon"] = player.pers["weapon1"];
			}
		}
	}

	if ( (level.teambalance > 0) && (game["BalanceTeamsNextRound"]) )
	{
		level.lockteams = true;
		level thread maps\mp\gametypes\_pam_teams::TeamBalance();
		level waittill ("Teams Balanced");
		wait 4;
	}

	// BEGIN WORM
	if((getcvar("g_roundwarmuptime") != "0") && (game["roundsplayed"] != "0" ) && level.hithalftime == 0)
	{	
		//display scores

		Create_HUD_Header();

		Create_HUD_Scoreboard();

		timer = getcvarint("g_roundwarmuptime");
		Create_HUD_RoundStart(timer);

		level.warmup = 1;

		/* Remove match countdown text */
		
		Destroy_HUD_Header();

		Destroy_HUD_Scoreboard();

		Destroy_HUD_NextRound();

	}

	if((getcvar("g_roundwarmuptime") != "0") && (game["roundsplayed"] == "0"))
	{
		Create_HUD_Header();

		timer = getcvarint("g_matchwarmuptime");
		Create_HUD_RoundStart(timer);

		level.warmup = 0;

		/* Remove match countdown text */

		Destroy_HUD_Header();

		Destroy_HUD_NextRound();

		thread resetScores();

	} //END WORM

	map_restart(true);
}

endMap()
{
	game["state"] = "intermission";
	level notify("intermission");
	
	if(isdefined(level.bombmodel))
		level.bombmodel stopLoopSound();

	if(game["alliedscore"] == game["axisscore"])
		text = &"MPSCRIPT_THE_GAME_IS_A_TIE";
	else if(game["alliedscore"] > game["axisscore"])
		text = &"MPSCRIPT_ALLIES_WIN";
	else
		text = &"MPSCRIPT_AXIS_WIN";

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		player closeMenu();
		player setClientCvar("g_scriptMainMenu", "main");
		player setClientCvar("cg_objectiveText", text);
		player spawnIntermission();
	}

	if (game["mode"] == "match")
		maps\mp\gametypes\_pam_utilities::Prevent_Map_Change();

	// Enable all Client Consoles
	setCvar("sv_disableClientConsole", "0");

	wait 7;

	exitLevel(false);
}

checkTimeLimit()
{
	if(level.warmup == 1)
		return;

	if(level.timelimit <= 0)
		return;
	
	if(game["timepassed"] < level.timelimit)
		return;
	
	if(level.mapended)
		return;
	level.mapended = true;

	iprintln(&"MPSCRIPT_TIME_LIMIT_REACHED");
	level thread endMap();
}

checkMatchRoundLimit()
{
	if(level.warmup == 1)
		return;
		
	/*  Is it a round-base halftime? */
	if (level.halfround != 0  && game["halftimeflag"] == "0")
	{
		if(game["roundsplayed"] >= level.halfround)
		{   /*scorelimit if */

			game["halftimeflag"] = "1";	
			game["BalanceTeamsNextRound"] = false;

			//display scores

			Create_HUD_Header();

			Create_HUD_Halftime();
			
			Create_HUD_Scoreboard();
			
			wait 1;

			Create_HUD_TeamSwap();
		
			/* Remove match countdown text */
		
			wait 7;

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

				if ( getCvarint("scr_sd_clearscoreeachhalf") == 1 )
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
			axistempscore = game["axisscore"];
			game["axisscore"] = game["alliedscore"];
			setTeamScore("axis", game["alliedscore"]);
			game["alliedscore"] = axistempscore;
			setTeamScore("allies", game["alliedscore"]);


			/* READY UP */
			if( game["mode"] == "match")
			{
				level.warmup = 1;

				maps\mp\gametypes\_pam_readyup::PAM_Ready_UP();

				Create_HUD_PlayersReady("2");

				wait 5;

				if(isdefined(level.allready))
					level.allready destroy();
				if(isdefined(level.half2start))
					level.half2start destroy();

				level.warmup = 0;

				Reset_Status_Icon();
			}
			else
				wait 1;

			// WEAPON EXPLOIT FIX
			game["dropsecondweap"] = true;

			Destroy_HUD_Header();

			return;

		}  /*scorelimit if */
	}

	/*  End of Map Roundlimit! */
	if (level.matchround != 0)
	{
		if (game["roundsplayed"] >= level.matchround)
		{
			if(game["alliedscore"] == game["axisscore"] && getcvar("g_ot") == "1")  // have a tie and overtime mode is on
				Prepare_map_Tie();
			else
				setCvar("g_ot_active", "0");

			Create_HUD_Matchover();

			Create_HUD_TeamWin();

			Create_HUD_Header();
				
			Create_HUD_Scoreboard();

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

checkMatchScoreLimit()
{
	if(level.warmup == 1)
		return;

	/* Is it a score-based Halftime? */
	if(game["halftimeflag"] == "0" && level.halfscore != 0)
	{
		if(game["alliedscore"] >= level.halfscore || game["axisscore"] >= level.halfscore)
		{ //level.halfscore if	
			game["halftimeflag"] = "1";	
			game["BalanceTeamsNextRound"] = false;

			//display scores
			Create_HUD_Header();

			Create_HUD_Halftime();
			
			Create_HUD_Scoreboard();
			
			wait 1;

			Create_HUD_TeamSwap();
		
			/* Remove match countdown text */
		
			wait 7;

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

				if ( getCvarint("scr_sd_clearscoreeachhalf") == 1 )
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
			axistempscore = game["axisscore"];
			game["axisscore"] = game["alliedscore"];
			setTeamScore("axis", game["alliedscore"]);
			game["alliedscore"] = axistempscore;
			setTeamScore("allies", game["alliedscore"]);


			/* READY UP */
			if( game["mode"] == "match")
			{
				level.warmup = 1;

				maps\mp\gametypes\_pam_readyup::PAM_Ready_UP();

				Create_HUD_PlayersReady("2");

				wait 5;

				if(isdefined(level.allready))
					level.allready destroy();
				if(isdefined(level.half2start))
					level.half2start destroy();

				level.warmup = 0;
				
				Reset_Status_Icon();
			}

			else
				wait 1;

			// WEAPON EXPLOIT FIX
			game["dropsecondweap"] = true;
			Destroy_HUD_Header();

			return;

		}  /*scorelimit if */
	}


	/* 2nd-Half Score Limit Check */
	if (level.matchscore2 != 0)
	{
		if ( game["round2axisscore"] >= level.matchscore2 || game["round2alliesscore"] >= level.matchscore2)
		{
			if(game["alliedscore"] == game["axisscore"] && getcvar("g_ot") == "1")  // have a tie and overtime mode is on
				Prepare_map_Tie();
			else
				setCvar("g_ot_active", "0");

			Create_HUD_Matchover();

			Create_HUD_TeamWin();

			Create_HUD_Header();
				
			Create_HUD_Scoreboard();

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

		if(game["alliedscore"] == game["axisscore"] && getcvar("g_ot") == "1")  // have a tie and overtime mode is on
				Prepare_map_Tie();
			else
				setCvar("g_ot_active", "0");

		Create_HUD_Matchover();

		Create_HUD_TeamWin();

		Create_HUD_Header();
				
		Create_HUD_Scoreboard();

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

		ceasefire = getCvarint("scr_ceasefire");
		// if we are in cease fire mode display it on the screen
		if (ceasefire != level.ceasefire)
		{
			level.ceasefire = ceasefire;
			if ( ceasefire )
				level thread maps\mp\_util_mp_gmi::make_permanent_announcement(&"GMI_MP_CEASEFIRE", "end ceasefire", 220, (1.0,0.0,0.0));			
			else
				level notify("end ceasefire");
		}

		// check all the players for rank changes
		if ( getCvarint("scr_battlerank") )
			maps\mp\gametypes\_rank_gmi::CheckPlayersForRankChanges();

		playersleft = getcvarint("sv_playersleft");
		if (playersleft != level.playersleft)
		{
			level.playersleft = playersleft;
			if (playersleft == 1)
				iprintln("^3Players Left Display Turned ^2ON");
			else
				iprintln("^3Players Left Display Turned ^1OFF");
		}
				
		halfround = getCvarInt("scr_sd_half_round");
		if (halfround != level.halfround)
		{
			level.halfround = halfround;
			iprintln("^3scr_sd_half_round ^7has been changed to ^3" + halfround);
		}

		halfscore = getCvarInt("scr_sd_half_score");
		if (halfscore != level.halfscore)
		{
			level.halfscore = halfscore;
			iprintln("^3scr_sd_half_score ^7has been changed to ^3" + halfscore);
		}

		matchround = getCvarInt("scr_sd_end_round");
		if (matchround != level.matchround)
		{
			level.matchround = matchround;
			iprintln("^3scr_sd_end_round ^7has been changed to ^3" + matchround);
		}

		matchscore = getCvarInt("scr_sd_end_score");
		if (matchscore != level.matchscore1)
		{
			level.matchscore1 = matchscore;
			iprintln("^3scr_sd_end_score ^7has been changed to ^3" + matchscore);
		}

		matchscore2 = getCvarInt("scr_sd_end_half2score");
		if (matchscore2 != level.matchscore2)
		{
			level.matchscore2 = matchscore2;
			iprintln("^3scr_sd_end_half2score ^7has been changed to ^3" + matchscore2);
		}

		countdraws = getCvarInt("scr_sd_count_draws");
		if (countdraws != level.countdraws)
		{
			level.countdraws = countdraws;
			iprintln("^3scr_sd_count_draws ^7has been changed to ^3" + countdraws);
			if (countdraws == 1)
				iprintln("Round Draws will not be replayed");
			else
				iprintln("Round Draws will be replayed");
		}

		timelimit = getCvarFloat("scr_sd_timelimit");
		if(level.timelimit != timelimit)
		{
			if(timelimit > 1440)
			{
				timelimit = 1440;
				setCvar("scr_sd_timelimit", "1440");
			}

			level.timelimit = timelimit;
			iprintln("^3TIMELIMIT has been changed to ^5" + timelimit);
			setCvar("ui_sd_timelimit", level.timelimit);
		}

		roundlength = getCvarFloat("scr_sd_roundlength");
		if(roundlength > 10)
			setCvar("scr_sd_roundlength", "10");
		if (roundlength != level.roundlength)
		{
			level.roundlength = getCvarFloat("scr_sd_roundlength");
			iprintln("ROUNDLENGTH has been changed to ^5" + roundlength);
		}

		graceperiod = getCvarFloat("scr_sd_graceperiod");
		if(graceperiod > 60)
			setCvar("scr_sd_graceperiod", "60");

		drawfriend = getCvarint("scr_drawfriend");
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
							iprintln("^3Draw Friend has been turned ^2ON!");
						}
						else
						{
							player.headicon = "";
							iprintln("^3Draw Friend has been turned ^1OFF!");
						}
					}
				}
			}
			else if(level.drawfriend)
			{
				// for all living players, show the appropriate headicon
				iprintln("^3Draw Friend has been turned ^2ON!");
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
				iprintln("^3Draw Friend has been turned ^1OFF!");
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

		killcam = getCvarInt("scr_killcam");
		if (level.killcam != killcam)
		{
			level.killcam = getCvarInt("scr_killcam");
			if(level.killcam >= 1)
			{
				setarchive(true);
				iprintln("^3Kill Cam ^2ON!");
			}
			else
			{
				setarchive(false);
				iprintln("^3Kill Cam ^1OFF!");
			}
		}
		
		freelook = getCvarInt("scr_freelook");
		if (level.allowfreelook != freelook)
		{
			level.allowfreelook = getCvarInt("scr_freelook");
			level maps\mp\gametypes\_pam_teams::UpdateSpectatePermissions();
			if (freelook == 0)
				iprintln("^3FREELOOK has been turned ^1OFF!");
			else
				iprintln("^3FREELOOK has been turned ^2ON!");
		}
		
		enemyspectate = getCvarInt("scr_spectateenemy");
		if (level.allowenemyspectate != enemyspectate)
		{
			level.allowenemyspectate = getCvarInt("scr_spectateenemy");
			level maps\mp\gametypes\_pam_teams::UpdateSpectatePermissions();
			if (enemyspectate == 0)
				iprintln("^3Spectate Enemies has been turned ^1OFF!");
			else
				iprintln("^3Spectate Enemies has been turned ^2ON!");
		}
		
		teambalance = getCvarInt("scr_teambalance");
		if (level.teambalance != teambalance)
		{
			level.teambalance = getCvarInt("scr_teambalance");
			if (level.teambalance > 0)
			{
				iprintln("^3TEAMBALANCE has been turned ^2ON!");
				level thread maps\mp\gametypes\_pam_teams::TeamBalance_Check_Roundbased();
			}
			else
				iprintln("^3TEAMBALANCE has been turned ^1OFF!");
		}

				ffire = getCvarInt("scr_friendlyfire");
		if (level.ffire != ffire)
		{
			level.ffire = getCvarInt("scr_friendlyfire");
			if (level.ffire == 0)
				iprintln("^3Friendly Fire has been turned ^1OFF!");
			else if (level.ffire == 1 || level.ffire > 3)
				iprintln("^3Friendly Fire has been turned ^1ON!");
			else if (level.ffire == 2)
				iprintln("^3Friendly Fire has been switched to ^1REFLECTION!");
			else if (level.ffire == 3)
				iprintln("^3Friendly Fire has been turned ^1ON with REFLECTION!");
		}

		pure = getCvarInt("sv_pure");
		if (pure != level.pure)
		{
			level.pure = getCvarInt("sv_pure");
			if (level.pure == 1)
				iprintln("^3SV_PURE has been turned ^2ON!");
			else
				iprintln("^3SV_PURE has been turned ^1OFF");
		}

		vote = getCvarInt("g_allowVote");
		if(vote != level.vote)
		{
			level.vote = getCvarInt("g_allowVote");
			if(level.vote == 0)
				iprintln("^3Voting has been turned ^1OFF!");
			else
				iprintln("^3Voting has been turned ^2ON!");
		}
		
		league = getCvar("pam_mode");
		if(league != level.league)
		{
			iprintln("^3PAM Mode has been cheanged to ^1" + league);
			iprintln("^3map_restart is required!");
			wait 5;
		}

		nodropsniper = getcvarint("sv_noDropSniper");
		if (nodropsniper != level.nodropsniper)
		{
			level.nodropsniper = nodropsniper;
			if (nodropsniper == 1)
				iprintln("^3Sniper Rifle Drops have been turned ^2ON!");
			else
				iprintln("^3Sniper Rifle Drops have been turned ^1OFF!");
		}

		allysnipelimit = getcvarint("sv_alliedSniperLimit");
		if (allysnipelimit != level.allysnipelimit)
		{
			level.allysnipelimit = allysnipelimit;
			iprintln("^3Allied Sniper Rifles limited to ^5" + allysnipelimit);
		}

		axissnipelimit = getcvarint("sv_axisSniperLimit");
		if (axissnipelimit != level.axissnipelimit)
		{
			level.axissnipelimit = axissnipelimit;
			iprintln("^3Axis Sniper Rifles limited to ^5" + axissnipelimit);
		}

		bombplanttime = getcvarFloat("sv_BombPlantTime");
		if (bombplanttime != level.planttime)
		{
			level.planttime = bombplanttime;
			iprintln("^3Bomb Plant Time has been changed to ^5" + bombplanttime);
		}

		bombdefusetime = getcvarFloat("sv_BombDefuseTime");
		if (bombdefusetime != level.defusetime)
		{
			level.defusetime = bombdefusetime;
			iprintln("^3Bomb Defuse Time has been changed to ^5" + bombdefusetime);
		}

		countdowntime = getcvarFloat("sv_BombTimer");
		if (countdowntime != level.countdowntime)
		{
			level.countdowntime = countdowntime;
			iprintln("^3Bomb Timer has been changed to ^5" + countdowntime);
		}
		
		countdownclock = getcvarint("sv_ShowBombTimer");
		if (countdownclock != level.countdownclock)
		{
			level.countdownclock = countdownclock;
			if (countdownclock == 1)
			{
				iprintln("^5Countdown Clock ^7has been turned ^5ON");
				iprintln("^9sv_ShowBombTimer 1");
			}
			else
			{
				iprintln("^3Countdown Clock ^7has been turned ^1OFF");
				iprintln("^9sv_ShowBombTimer 0");
			}
		}

		hdrop = getcvarint("scr_drophealth");
		if (hdrop != level.drophealth)
		{
			level.drophealth = hdrop;
			if (hdrop == 0)
				iprintln("^1Health Drop OFF");
			else
				iprintln("^2Health Drop ON");
		}

		// Weapon notifications - check these settings less often
		if (level.checksettings == 5)
		{
			faust = getcvarint("scr_allow_panzerfaust");
			if (faust != level.faust)
			{
				level.faust = faust;
				if (faust == 0)
					iprintln("^3Rockets have been turned ^1OFF!");
				else
					iprintln("^3Rockets have been turned ^2ON!");
			}
			
			mg30gun = getcvarint("scr_allow_mg30cal");
			if (mg30gun != level.mg30gun)
			{
				level.mg30gun = mg30gun;
				if (mg30gun == 0)
					iprintln("^1MG 30 Caliber turned OFF");
				else
					iprintln("^2MG 30 Caliber turned ON");
			}

			dp28gun = getcvarint("scr_allow_dp28");
			if (dp28gun != level.dp28gun)
			{
				level.dp28gun = dp28gun;
				if (dp28gun == 0)
					iprintln("^1DP28 turned OFF");
				else
					iprintln("^2DP28 turned ON");
			}

			bazookagun = getcvarint("scr_allow_bazooka");
			if (bazookagun != level.bazookagun)
			{
				level.bazookagun = bazookagun;
				if (bazookagun == 0)
					iprintln("^1Bazooka turned OFF");
				else
					iprintln("^2Bazooka turned ON");
			}

			flamegun = getcvarint("scr_allow_flamethrower");
			if (flamegun != level.flamegun)
			{
				level.flamegun = flamegun;
				if (flamegun == 0)
					iprintln("^1Flamethrower turned OFF");
				else
					iprintln("^2Flamethrower turned ON");
			}

			sshock = getcvarint("scr_shellshock");
			if (sshock != level.sshock)
			{
				level.sshock = sshock;
				if (sshock == 0)
					iprintln("^1Shell Shock OFF");
				else
					iprintln("^2Shell Shock ON");
			}

			fg42gun = getcvarint("scr_allow_fg42");
			if (fg42gun != level.fg42gun)
			{
				level.fg42gun = fg42gun;
				if (fg42gun == 0)
					iprintln("^3The FG42 has been turned ^1OFF!");
				else
					iprintln("^3The FG42 has been turned ^2ON!");
			}

			level.checksettings = 0;
		}
		else
			level.checksettings++;

		wait 1;
	}
}

updateTeamStatus()
{
	wait 0;	// Required for Callback_PlayerDisconnect to complete before updateTeamStatus can execute
	
	resettimeout();
	
	oldvalue["allies"] = level.exist["allies"];
	oldvalue["axis"] = level.exist["axis"];
	level.exist["allies"] = 0;
	level.exist["axis"] = 0;
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if(isDefined(player.pers["team"]) && player.pers["team"] != "spectator" && player.sessionstate == "playing")
			level.exist[player.pers["team"]]++;
	}

	if(getcvar("sv_playersleft") == "1")
	{	
		// destroy old huds so they can be refreshed
		if(isdefined(level.alliesleft))
			level.alliesleft destroy();
		if(isdefined(level.axisleft))
			level.axisleft destroy();
		if(isdefined(level.alliesleftnum))
			level.alliesleftnum destroy();
		if(isdefined(level.axisleftnum))
			level.axisleftnum destroy();
			
	
		// display allies left axis left
		level.alliesleft = newHudElem();
		level.alliesleft.x = 380;
		level.alliesleft.y = 460;
		level.alliesleft.alignX = "left";
		level.alliesleft.alignY = "bottom";
		level.alliesleft.fontScale = .75;
		level.alliesleft.color = (1, 1, 1);
		level.alliesleft.alpha = 1;
		level.alliesleft setText(game["dspalliesleft"]);
		
		level.alliesleftnum = newHudElem();
		level.alliesleftnum.x = 450;
		level.alliesleftnum.y = 460;
		level.alliesleftnum.alignX = "left";
		level.alliesleftnum.alignY = "bottom";
		level.alliesleftnum.fontScale = .75;
		level.alliesleftnum.color = (1, 1, 1);
		level.alliesleftnum.alpha = 1;
		level.alliesleftnum setValue(level.exist["allies"]);
			
		level.axisleft = newHudElem();
		level.axisleft.x = 380;
		level.axisleft.y = 470;
		level.axisleft.alignX = "left";
		level.axisleft.alignY = "bottom";
		level.axisleft.fontScale = .75;
		level.axisleft.color = (1, 1, 1);
		level.axisleft.alpha = 1;
		level.axisleft setText(game["dspaxisleft"]);
		
		level.axisleftnum = newHudElem();
		level.axisleftnum.x = 450;
		level.axisleftnum.y = 470;
		level.axisleftnum.alignX = "left";
		level.axisleftnum.alignY = "bottom";
		level.axisleftnum.fontScale = .75;
		level.axisleftnum.color = (1, 1, 1);
		level.axisleftnum.alpha = 1;
		level.axisleftnum setValue(level.exist["axis"]);
	}

	if(level.exist["allies"])
		level.didexist["allies"] = true;
	if(level.exist["axis"])
		level.didexist["axis"] = true;

	if(level.warmup == 1)
		return;

	if(level.roundended)
		return;

	if(oldvalue["allies"] && !level.exist["allies"] && oldvalue["axis"] && !level.exist["axis"])
	{
		if(!level.bombplanted)
		{
			announcement(&"SD_ROUNDDRAW");
			level thread endRound("draw");
			return;
		}

		if(game["attackers"] == "allies")
		{
			announcement(&"SD_ALLIEDMISSIONACCOMPLISHED");
			level thread endRound("allies");
			return;
		}

		announcement(&"SD_AXISMISSIONACCOMPLISHED");
		level thread endRound("axis");
		return;
	}

	if(oldvalue["allies"] && !level.exist["allies"])
	{
		// no bomb planted, axis win
		if(!level.bombplanted)
		{
			announcement(&"SD_ALLIESHAVEBEENELIMINATED");
			level thread endRound("axis");
			return;
		}

		if(game["attackers"] == "allies")
			return;
		
		// allies just died and axis have planted the bomb
		if(level.exist["axis"])
		{
			announcement(&"SD_ALLIESHAVEBEENELIMINATED");
			level thread endRound("axis");
			return;
		}

		announcement(&"SD_AXISMISSIONACCOMPLISHED");
		level thread endRound("axis");
		return;
	}
	
	if(oldvalue["axis"] && !level.exist["axis"])
	{
		// no bomb planted, allies win
		if(!level.bombplanted)
		{
			announcement(&"SD_AXISHAVEBEENELIMINATED");
			level thread endRound("allies");
			return;
 		}
 		
 		if(game["attackers"] == "axis")
			return;
		
		// axis just died and allies have planted the bomb
		if(level.exist["allies"])
		{
			announcement(&"SD_AXISHAVEBEENELIMINATED");
			level thread endRound("allies");
			return;
		}
		
		announcement(&"SD_ALLIEDMISSIONACCOMPLISHED");
		level thread endRound("allies");
		return;
	}	
}

bombzones()
{
	level.barsize = 288;
	//level.planttime = 5;		// seconds to plant a bomb
	//level.defusetime = 10;		// seconds to defuse a bomb

	bombtrigger = getent("bombtrigger", "targetname");
	bombtrigger maps\mp\_utility::triggerOff();

	bombzone_A = getent("bombzone_A", "targetname");
	bombzone_B = getent("bombzone_B", "targetname");
	bombzone_A thread bombzone_think(bombzone_B);
	bombzone_B thread bombzone_think(bombzone_A);

	wait 1;	// TEMP: without this one of the objective icon is the default. Carl says we're overflowing something.
	objective_add(0, "current", bombzone_A.origin, "gfx/hud/hud@objectiveA.tga");
	objective_add(1, "current", bombzone_B.origin, "gfx/hud/hud@objectiveB.tga");
}

bombzone_think(bombzone_other)
{
	level endon("round_ended");

	level.barincrement = (level.barsize / (20.0 * level.planttime));
	
	for(;;)
	{
		self waittill("trigger", other);

		if(isDefined(bombzone_other.planting))
		{
			if(isDefined(other.planticon))
				other.planticon destroy();

			continue;
		}
		
		if(isPlayer(other) && (other.pers["team"] == game["attackers"]) && (other isOnGround()) && !(other isinvehicle()) && (other maps\mp\_util_mp_gmi::canPlantGMI()))
		{
			if(!isDefined(other.planticon))
			{
				other.planticon = newClientHudElem(other);				
				other.planticon.alignX = "center";
				other.planticon.alignY = "middle";
				other.planticon.x = 320;
				other.planticon.y = 345;
				other.planticon setShader("ui_mp/assets/hud@plantbomb.tga", 64, 64);			
			}
			
			while(other istouching(self) && isAlive(other) && other useButtonPressed())
			{
				other notify("kill_check_bombzone");
				
				self.planting = true;

				if(!isDefined(other.progressbackground))
				{
					other.progressbackground = newClientHudElem(other);				
					other.progressbackground.alignX = "center";
					other.progressbackground.alignY = "middle";
					other.progressbackground.x = 320;
					other.progressbackground.y = 385;
					other.progressbackground.alpha = 0.5;
				}
				other.progressbackground setShader("black", (level.barsize + 4), 12);		

				if(!isDefined(other.progressbar))
				{
					other.progressbar = newClientHudElem(other);				
					other.progressbar.alignX = "left";
					other.progressbar.alignY = "middle";
					other.progressbar.x = (320 - (level.barsize / 2.0));
					other.progressbar.y = 385;
				}
				other.progressbar setShader("white", 0, 8);
				other.progressbar scaleOverTime(level.planttime, level.barsize, 8);

				other playsound("MP_bomb_plant");
				other linkTo(self);
				other disableWeapon();

				self.progresstime = 0;
				while(isAlive(other) && other useButtonPressed() && (self.progresstime < level.planttime) && (other maps\mp\_util_mp_gmi::canPlantGMI()))
				{
					self.progresstime += 0.05;
					wait 0.05;
				}
	
				if(isDefined(other.progressbackground))
					other.progressbackground destroy();
				if(isDefined(other.progressbar))
					other.progressbar destroy();

				if(self.progresstime >= level.planttime)
				{
					if(isDefined(other.planticon))
						other.planticon destroy();

					other enableWeapon();

					if ( level.battlerank )
					{
						other.pers["score"] += 5;
						other.score = other.pers["score"];
					}
					
					level.bombexploder = self.script_noteworthy;
					
					bombzone_A = getent("bombzone_A", "targetname");
					bombzone_B = getent("bombzone_B", "targetname");
					bombzone_A delete();
					bombzone_B delete();
					objective_delete(0);
					objective_delete(1);
	
					plant = other maps\mp\_util_mp_gmi::getPlantGMI();
					
					level.bombmodel = spawn("script_model", plant.origin);
					level.bombmodel.angles = plant.angles;
					level.bombmodel setmodel("xmodel/mp_bomb1_defuse");
					level.bombmodel playSound("Explo_plant_no_tick");
					
					bombtrigger = getent("bombtrigger", "targetname");
					bombtrigger.origin = level.bombmodel.origin;

					objective_add(0, "current", bombtrigger.origin, "gfx/hud/hud@bombplanted.tga");
		
					level.bombplanted = true;
					
					lpselfnum = other getEntityNumber();
					lpselfguid = other getGuid();
					logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + game["attackers"] + ";" + other.name + ";" + "bomb_plant" + "\n");

					//announcement(&"SD_EXPLOSIVESPLANTED");
					thread HUD_Bomb_Planted();
										
					players = getentarray("player", "classname");
					for(i = 0; i < players.size; i++)
						players[i] playLocalSound("MP_announcer_bomb_planted");
					
					bombtrigger thread bomb_think();
					bombtrigger thread bomb_countdown();
					
					level notify("bomb_planted");
					level.clock destroy();
					
					//CODUO NA COMP PAM ADDITION - Show Bomb Timer
					
					if(level.countdownclock)
					{
						level.clock = newHudElem();
						level.clock.x = 320;
						level.clock.y = 460;
						level.clock.alignX = "center";
						level.clock.alignY = "middle";
						level.clock.font = "bigfixed";
						level.clock.color = level.countdowntimerstartcolor;
						level.clock setTimer(level.countdowntime * 1);
					}
					
					return;	//TEMP, script should stop after the wait .05
				}
				else
				{
					other unlink();
					other enableWeapon();
				}
				
				wait .05;
			}
			
			self.planting = undefined;
			other thread check_bombzone(self);
		}
	}
}

check_bombzone(trigger)
{
	self notify("kill_check_bombzone");
	self endon("kill_check_bombzone");
	level endon("round_ended");

	while(isDefined(trigger) && !isDefined(trigger.planting) && self istouching(trigger) && isAlive(self))
		wait 0.05;

	if(isDefined(self.planticon))
		self.planticon destroy();
}

bomb_countdown()
{
	self endon("bomb_defused");
	level endon("intermission");
	
	level.bombmodel playLoopSound("bomb_tick");
	
	//CODUO NA COMP ADDITION - bomb timer color change
	currframe = 1;
	endframe = level.countdowntime * 20;
	
	
	while( currframe <= endframe )
	{
		progress = currframe / endframe;
		
		startR = level.countdowntimerstartcolor[0];
		startG = level.countdowntimerstartcolor[1];
		startB = level.countdowntimerstartcolor[2];
		
		endR = level.countdowntimerendcolor[0];
		endG = level.countdowntimerendcolor[1];
		endB = level.countdowntimerendcolor[2];
		
		currR = startR + (endR - startR) * progress;
		currG = startG + (endG - startG) * progress;
		currB = startB + (endB - startB) * progress;
		
		if(level.countdownclock)
			level.clock.color = ( currR, currG, currB);
		else
			level.hudplanted.color = ( currR, currG, currB);
		
		wait 0.5;
		currframe += 10;
	}
	// set the countdown time
	//wait level.countdowntime;
	
	
	//CODUO NA COMP PAM ADDITION - make timer red if visible
	if(level.countdownclock != 0)
	{
		if(isdefined(level.clock))
		level.clock.color = level.countdowntimerendcolor;
		wait 1;
	}

	
	// bomb timer is up
	objective_delete(0);
	
	level.bombexploded = true;
	self notify("bomb_exploded");

	// trigger exploder if it exists
	if(isDefined(level.bombexploder))
		maps\mp\_utility::exploder(level.bombexploder);

	// explode bomb
	origin = self getorigin();
	range = 500;
	maxdamage = 2000;
	mindamage = 1000;
		
	self delete(); // delete the defuse trigger
	level.bombmodel stopLoopSound();
	level.bombmodel delete();

	playfx(level._effect["bombexplosion"], origin);
	radiusDamage(origin, range, maxdamage, mindamage);
	
	if(level.warmup == 1)
		return;

	if (game["attackers"] == "allies") {
		announcement(&"SD_ALLIEDMISSIONACCOMPLISHED");
	} else {
		announcement(&"SD_AXISMISSIONACCOMPLISHED");
	}
	level thread endRound(game["attackers"]);
}

bomb_think()
{
	self endon("bomb_exploded");
	level.barincrement = (level.barsize / (20.0 * level.defusetime));


	//CODUO NA COMP ADDITION - only destroy planted HUD if bomb timer is on
	
	
	thread Destroy_HUD_Planted();

	for(;;)
	{
		self waittill("trigger", other);
		
		// check for having been triggered by a valid player
		if(isPlayer(other) && (other.pers["team"] == game["defenders"]) && other isOnGround())
		{
			if(!isDefined(other.defuseicon))
			{
				other.defuseicon = newClientHudElem(other);				
				other.defuseicon.alignX = "center";
				other.defuseicon.alignY = "middle";
				other.defuseicon.x = 320;
				other.defuseicon.y = 345;
				other.defuseicon setShader("ui_mp/assets/hud@defusebomb.tga", 64, 64);			
			}
			
			while(other islookingat(self) && distance(other.origin, self.origin) < 64 && isAlive(other) && other useButtonPressed())
			{
				other notify("kill_check_bomb");

				if(!isDefined(other.progressbackground))
				{
					other.progressbackground = newClientHudElem(other);				
					other.progressbackground.alignX = "center";
					other.progressbackground.alignY = "middle";
					other.progressbackground.x = 320;
					other.progressbackground.y = 385;
					other.progressbackground.alpha = 0.5;
				}
				other.progressbackground setShader("black", (level.barsize + 4), 12);		

				if(!isDefined(other.progressbar))
				{
					other.progressbar = newClientHudElem(other);				
					other.progressbar.alignX = "left";
					other.progressbar.alignY = "middle";
					other.progressbar.x = (320 - (level.barsize / 2.0));
					other.progressbar.y = 385;
				}
				other.progressbar setShader("white", 0, 8);			
				other.progressbar scaleOverTime(level.defusetime, level.barsize, 8);

				other playsound("MP_bomb_defuse");
				other linkTo(self);
				other disableWeapon();

				self.progresstime = 0;
				while(isAlive(other) && other useButtonPressed() && (self.progresstime < level.defusetime))
				{
					self.progresstime += 0.05;
					wait 0.05;
				}

				if(isDefined(other.progressbackground))
					other.progressbackground destroy();
				if(isDefined(other.progressbar))
					other.progressbar destroy();

				if(self.progresstime >= level.defusetime)
				{
					if(isDefined(other.defuseicon))
						other.defuseicon destroy();

					if ( level.battlerank )
					{
						other.pers["score"] += 5;
						other.score = other.pers["score"];
					}
					
					objective_delete(0);

					self notify("bomb_defused");
					level.bombmodel setmodel("xmodel/mp_bomb1");
					level.bombmodel stopLoopSound();
					
					//CODUO NA COMP PAM ADDITION - Delete countdown clock if enabled
					if(level.countdownclock)
					{
						if(isdefined(level.clock))
						level.clock destroy();
					}
					
					self delete();

					announcement(&"SD_EXPLOSIVESDEFUSED");
					
					lpselfnum = other getEntityNumber();
					lpselfguid = other getGuid();
					logPrint("A;" + lpselfguid + ";" + lpselfnum + ";" + game["defenders"] + ";" + other.name + ";" + "bomb_defuse" + "\n");
					
					players = getentarray("player", "classname");
					for(i = 0; i < players.size; i++)
					{
						players[i] playLocalSound("MP_announcer_bomb_defused");
					}

					if(level.warmup == 1)
						return;	

					level thread endRound(game["defenders"]);
					return;	//TEMP, script should stop after the wait .05
				}
				else
				{
					other unlink();
					other enableWeapon();
				}
				
				wait .05;
			}

			self.defusing = undefined;
			other thread check_bomb(self);
		}
	}
}

check_bomb(trigger)
{
	self notify("kill_check_bomb");
	self endon("kill_check_bomb");

	while(isDefined(trigger) && !isDefined(trigger.defusing) && distance(self.origin, trigger.origin) < 32 && self islookingat(trigger) && isAlive(self))
		wait 0.05;

	if(isDefined(self.defuseicon))
		self.defuseicon destroy();
}

printJoinedTeam(team)
{
	if(team == "allies")
		iprintln(&"MPSCRIPT_JOINED_ALLIES", self);
	else if(team == "axis")
		iprintln(&"MPSCRIPT_JOINED_AXIS", self);
}

addBotClients()
{
	wait 5;
	
	for(i = 0; i < 2; i++)
	{
		ent[i] = addtestclient();
		wait 0.5;
	
		if(isPlayer(ent[i]))
		{
			if(i & 1)
			{
				ent[i] notify("menuresponse", game["menu_team"], "axis");
				wait 0.5;
				ent[i] notify("menuresponse", game["menu_weapon_axis"], "kar98k_mp");
			}
			else
			{
				ent[i] notify("menuresponse", game["menu_team"], "allies");
				wait 0.5;
				ent[i] notify("menuresponse", game["menu_weapon_allies"], "m1garand_mp");
			}
		}
	}
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

dropSniper()
{
	maps\mp\gametypes\_Check_Snipers::NoDropWeapon();
}

readyup()
{
	/*if(!isdefined(self.pers["team"]) || self.pers["team"] == "spectator") 
		return;*/

	self endon("respawn");
	self thread waitRespawnButton();
	self waittill("respawn");

}

waitRespawnButton()
{
	self endon("end_respawn");
	self endon("respawn");
	
	wait 0; // Required or the "respawn" notify could happen before it's waittill has begun

	maps\mp\gametypes\_pam_utilities::CheckPK3files();
	
	self iprintlnbold("^7Hit the ^3-Use- ^7key to Ready-Up");

	wait 1;
	
	while (!level.playersready)
	{
		wait .5;
		if(self useButtonPressed() == true)
		{ //if	
		
		for (index=0;index<level.readyname.size;index++)
		{
			if (level.readyname[index] == self.name)
			{

				if (level.readystate[index] == "notready")
				{
					level.readystate[index] = "ready";
					iprintln(self.name + "^2 is Ready");
					logPrint(self.name + ";" + " is Ready Logfile;" + "\n");
					wait 1;
				}
				else
				{
					level.readystate[index] = "notready";
					iprintln(self.name + "^1 is Not Ready");
					logPrint(self.name + ";" + " is Not Ready Logfile;" + "\n");
					wait 1;
				} // end notready if
			} // end name = name if
		}  // end for

		} //if
	} //while

	self notify("remove_respawntext");

	self notify("respawn");	
	
}

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
		if(game["halftimeflag"] == "1")
		{
			level.matchaxisscorenum.x = 440;
			level.matchaxisscorenum.color = (0, 1, 0);
		}
		else
		{
			level.matchaxisscorenum.x = 200;
			level.matchaxisscorenum.color = (1, 0, 0);
		}
		if (getcvar("sv_scoreboard") == "big")
			level.matchaxisscorenum.y = 240;
		else
			level.matchaxisscorenum.y = 135;
		level.matchaxisscorenum.alignX = "center";
		level.matchaxisscorenum.alignY = "middle";
		level.matchaxisscorenum.fontScale = 2;
		level.matchaxisscorenum setValue(game["axisscore"]);

		level.matchalliesscorenum = newHudElem();
		if(game["halftimeflag"] == "1")
		{
			level.matchalliesscorenum.x = 200;
			level.matchalliesscorenum.color = (1, 0, 0);
		}
		else
		{
			level.matchalliesscorenum.x = 440;
			level.matchalliesscorenum.color = (0, 1, 0);
		}
		if (getcvar("sv_scoreboard") == "big")
			level.matchalliesscorenum.y = 240;
		else
			level.matchalliesscorenum.y = 135;
		level.matchalliesscorenum.alignX = "center";
		level.matchalliesscorenum.alignY = "middle";
		level.matchalliesscorenum.fontScale = 2;
		level.matchalliesscorenum setValue(game["alliedscore"]);
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
		if(game["halftimeflag"] == "1")
		{
			level.matchaxisscorenum.x = 618;
			level.matchaxisscorenum.color = (.85, .99, .99);
		}
		else
		{
			level.matchaxisscorenum.x = 532;
			level.matchaxisscorenum.color = (.73, .99, .75);
		}
		level.matchaxisscorenum.y = 327;
		level.matchaxisscorenum.alignX = "center";
		level.matchaxisscorenum.alignY = "middle";
		level.matchaxisscorenum.fontScale = 1;
		level.matchaxisscorenum setValue(game["axisscore"]);

		level.matchalliesscorenum = newHudElem();
		if(game["halftimeflag"] == "1")
		{
			level.matchalliesscorenum.x = 535;
			level.matchalliesscorenum.color = (.73, .99, .75);
		}
		else
		{
			level.matchalliesscorenum.x = 618;
			level.matchalliesscorenum.color = (.85, .99, .99);
		}
		level.matchalliesscorenum.y = 327;
		level.matchalliesscorenum.alignX = "center";
		level.matchalliesscorenum.alignY = "middle";
		level.matchalliesscorenum.fontScale = 1;
		level.matchalliesscorenum setValue(game["alliedscore"]);
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

Create_HUD_NextRound()
{
	//if(isdefined(level.clock))
		//level.clock destroy();

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
			level.teamwin.color = (1, 1, 0);
			level.teamwin setText(game["dsptie"]);
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

Create_HUD_RoundStart(time)
{
	if ( time < 3 )
		time = 3;

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

	// Give all players a count-down stopwatch
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		
		if ( isDefined(player.pers["team"]) && player.pers["team"] == "spectator")
			continue;
			
		player thread stopwatch_start("match_start", time);
	}
	
	wait (time);

	if(isdefined(level.round))
		level.round destroy();
	if(isdefined(level.roundnum))
		level.roundnum destroy();
	if(isdefined(level.starting))
		level.starting destroy();
}

HUD_Bomb_Planted()
{
	level.hudplanted = newHudElem();
	level.hudplanted.x = 320;
	
	if(level.countdownclock)
		level.hudplanted.y = 460;
	else
		level.hudplanted.y = 390;
	level.hudplanted.alignX = "center";
	level.hudplanted.alignY = "middle";
	level.hudplanted.fontScale = 1.5;
	level.hudplanted.color = (1, 1, 0);
	level.hudplanted setText(game["planted"]);
}

Destroy_HUD_Planted()
{
	//CODUO NA COMP ADDITION - 
	//destroy Explosives planted HUD after 6 seconds if clock is on
	//or wait until bomb notify if not
	if(level.countdownclock)
	{
		wait 6;
		level.hudplanted destroy();
	}
	else
	{
		level waittill("round_ended");
		level.hudplanted destroy();
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

stopwatch_start(reason, time)
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

Prepare_map_Tie()
{
	otcount = getcvarint("g_ot_active");
	otcount = otcount + 1;
	setcvar("g_ot_active", otcount);
}

Reset_Status_Icon()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if (level.battlerank)
			player.statusicon = maps\mp\gametypes\_rank_gmi::GetRankStatusIcon(player);
		else
			player.statusicon = "";
	}
}
