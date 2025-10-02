PamMain()
{
	level.callbackStartGameType = ::Callback_StartGameType;
	level.callbackPlayerConnect = ::Callback_PlayerConnect;
	level.callbackPlayerDisconnect = ::Callback_PlayerDisconnect;
	level.callbackPlayerDamage = ::Callback_PlayerDamage;
	level.callbackPlayerKilled = ::Callback_PlayerKilled;

	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	
	allowed[0] = "tdm";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	maps\mp\gametypes\_rank_gmi::InitializeBattleRank();
	maps\mp\gametypes\_secondary_gmi::Initialize();

	level.mapname = getcvar("mapname");
	maps\mp\gametypes\_pam_utilities::NonstockPK3Check();
	
	if(getCvar("scr_tdm_timelimit") == "")		// Time limit per map
		setCvar("scr_tdm_timelimit", "30");
	else if(getCvarFloat("scr_tdm_timelimit") > 1440)
		setCvar("scr_tdm_timelimit", "1440");
	level.timelimit = getCvarFloat("scr_tdm_timelimit");
	setCvar("ui_tdm_timelimit", level.timelimit);
	makeCvarServerInfo("ui_tdm_timelimit", "30");

	if(getCvar("scr_tdm_scorelimit") == "")		// Score limit per map
		setCvar("scr_tdm_scorelimit", "100");
	level.scorelimit = getCvarInt("scr_tdm_scorelimit");
	setCvar("ui_tdm_scorelimit", level.scorelimit);
	makeCvarServerInfo("ui_tdm_scorelimit", "100");

	if(getCvar("scr_forcerespawn") == "")		// Force respawning
		setCvar("scr_forcerespawn", "0");
	
	if(getCvar("scr_teambalance") == "")		// Auto Team Balancing
		setCvar("scr_teambalance", "0");
	level.teambalance = getCvarInt("scr_teambalance");
	level.teambalancetimer = 0;

	teamscorepenalty = getCvar("scr_teamscorepenalty");
	if(teamscorepenalty == "")			// Decrement teamscore for team kills and suicides
		teamscorepenalty = "1";
	setCvar("scr_teamscorepenalty", teamscorepenalty);
	
	if(getCvar("scr_battlerank") == "")		
		setCvar("scr_battlerank", "1");	//default is ON
	level.battlerank = getCvarint("scr_battlerank");
	setCvar("ui_battlerank", level.battlerank);
	makeCvarServerInfo("ui_battlerank", "0");

	if(getCvar("scr_shellshock") == "")		// controls whether or not players get shellshocked from grenades or rockets
		setCvar("scr_shellshock", "1");
	setCvar("ui_shellshock", getCvar("scr_shellshock"));
	makeCvarServerInfo("ui_shellshock", "0");
			
	if(!isDefined(game["compass_range"]))		// set up the compass range.
		game["compass_range"] = 1024;		
	setCvar("cg_hudcompassMaxRange", game["compass_range"]);
	makeCvarServerInfo("cg_hudcompassMaxRange", "0");

	if(getCvar("scr_drophealth") == "")		// Free look spectator
		setCvar("scr_drophealth", "1");

	killcam = getCvar("scr_killcam");
	if(killcam == "")				// Kill cam
		killcam = "1";
	setCvar("scr_killcam", killcam, true);
	level.killcam = getCvarInt("scr_killcam");
	
	if(getCvar("scr_drawfriend") == "")		// Draws a team icon over teammates
		setCvar("scr_drawfriend", "1");
	level.drawfriend = getCvarInt("scr_drawfriend");

	if(getCvar("sv_messagecenter") == "")
		setCvar("sv_messagecenter", "0");

	if(getCvar("pam_mode") == "")
		setCvar("pam_mode", "pub");

	if(getCvar("g_ot_count") == "")
		setCvar("g_ot_count", "0");

	if(getCvar("sv_consolelock") == "")	// Locks the console in PAM
		setCvar("sv_consolelock", "0");

	if(!isdefined(game["runonce"]))
	{
		//Turn on all client consoles
		setCvar("sv_disableClientConsole", "0");

		/* Get Game Settings */
		level.scorelimit = getCvarInt("scr_tdm_scorelimit");

		ruleset = getCvar("pam_mode");
		switch(ruleset)
		{
			case "twl":
				maps\mp\gametypes\rules\_twl_tdm_rules::Rules();
				break;
			case "bl":
				maps\mp\gametypes\rules\_britleague_tdm_rules::Rules();
				break;
			case "lan":
				maps\mp\gametypes\rules\_lan_tdm_rules::Rules();
				break;
			case "cb":
				maps\mp\gametypes\rules\_cb_tdm_rules::Rules();
				break;

			default:
				maps\mp\gametypes\rules\_public_tdm_rules::Rules();
				setCvar("pam_mode", "pub");
				break;
		}

		if(!isDefined(game["mode"]))
			game["mode"] = "match";

		level.warmup = 0;		// warmup time reset in case they restart map via menu

		game["switchprevent"] = 0; //Can't switch teams after this bit gets set and you are already on a team

		game["runonce"] = 1;
	}

	//Turn off client console for PUB servers if set
	if (game["mode"] != "match" && getcvar("sv_consolelock") )
		setCvar("sv_disableClientConsole", "1");

	if(getcvar("sv_warmupmines") == "")			// warmup mines off/on
		setcvar("sv_warmupmines", "0");	

	/* Set up Level variables */
	// level settings
	level.timelimit = getCvarFloat("scr_tdm_timelimit");
	level.scorelimit = getCvarFloat("scr_tdm_scorelimit");
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
	level.half_time = getcvarint("scr_tdm_half_time");
	level.halfscore = getcvarint("scr_tdm_half_score");
	level.matchscore1 = getcvarint("scr_tdm_end_score");
	level.matchscore2 = getcvarint("scr_tdm_end_half2score");
	level.scoringpenalty = getcvar("scr_teamscorepenalty");
	level.clearscoreeachhalf = getcvarint("scr_tdm_clearscoreeachhalf");
	level.overtime = 0;	//Makes sure OT settings get loaded after defaults loaded
	//level.allowmatchtie = getcvarint("scr_ctf_allowmatchtie");
	level.randomsides = getcvarint("scr_randomsides");
	level.ot_count = getcvarint("g_ot_count");
	level.warmup = 0;
	level.rdyup = 0;
	level.hithalftime = 0;
	level.readyname = [];
	level.readystate = [];
	level.playersready = false;
	level.checksettings = 0;
	level.allowautobalance = true;
	level.allowscoring = false;
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
		game["team1score"] = 0;
		game["team2score"] = 0;
		game["firsthalfready"] = 0;
		game["readyup"] = 0;
		game["axismatchscore"] = 0;
		game["alliesmatchscore"] = 0;
	}

	// WEAPON EXPLOIT FIX
	if(!isDefined(game["dropsecondweap"]))
		game["dropsecondweap"] = false;
	
	// Message Center
	if(game["mode"] != "match" && getCvar("sv_messagecenter") != "0")
		thread maps\mp\gametypes\_message_center::messages();
	
	//PAM UO Admin Tools
	thread maps\mp\gametypes\_pam_admin::main();

	if(!isDefined(game["state"]))
		game["state"] = "playing";

	if(!isDefined(game["alliedscore"]))		// Setup the score for the allies to be 0.
		game["alliedscore"] = 0;
	setTeamScore("allies", game["alliedscore"]);

	if(!isDefined(game["axisscore"]))		// Setup the score for the axis to be 0.
		game["axisscore"] = 0;
	setTeamScore("axis", game["axisscore"]);

	// turn off ceasefire
	level.ceasefire = 0;
	setCvar("scr_ceasefire", "0");

	level.mapended = false;
	level.healthqueue = [];
	level.healthqueuecurrent = 0;
	
	level.team["allies"] = 0;
	level.team["axis"] = 0;
	
	if(level.killcam >= 1)
		setarchive(true);
}

Callback_StartGameType()
{
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

		// DEMO TEXT
		game["startdemo"] = &"Players Start Your Demos - /record in console";
		precacheString(game["startdemo"]);	
		
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


		precacheString(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
		precacheString(&"MPSCRIPT_KILLCAM");
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
		precacheShader("hudScoreboard_mp");
		precacheShader("gfx/hud/hud@mpflag_spectator.tga");
		precacheStatusIcon("gfx/hud/hud@status_dead.tga");
		precacheStatusIcon("gfx/hud/hud@status_connecting.tga");
		precacheItem("item_health");
	}

	maps\mp\gametypes\_pam_teams::modeltype();
	maps\mp\gametypes\_pam_teams::precache();
	maps\mp\gametypes\_pam_teams::scoreboard();
	maps\mp\gametypes\_pam_teams::initGlobalCvars();
	maps\mp\gametypes\_pam_teams::initWeaponCvars();
	maps\mp\gametypes\_pam_teams::restrictPlacedWeapons();
	thread maps\mp\gametypes\_pam_teams::updateGlobalCvars();
	thread maps\mp\gametypes\_pam_teams::updateWeaponCvars();

	game["gamestarted"] = true;

	setClientNameMode("auto_change");
	
	thread startGame();
	//thread addBotClients(); // For development testing
	thread updateGametypeCvars();
}

Callback_PlayerConnect()
{
	self.statusicon = "gfx/hud/hud@status_connecting.tga";
	self waittill("begin");
	self.statusicon = "";
	self.pers["teamTime"] = 1000000;
	
	iprintln(&"MPSCRIPT_CONNECTED", self);

	resettimeout();

	lpselfnum = self getEntityNumber();

	level.R_U_Name[lpselfnum] = self.name;
	level.R_U_State[lpselfnum] = "notready";
	self.R_U_Looping = 0;

	if(level.rdyup == 1)
	{
		self.statusicon = game["br_hudicons_allies_0"];
		self thread maps\mp\gametypes\_pam_readyup::readyup(lpselfnum);
	}

	lpGuid = self getGuid();
	logPrint("J;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");

	// set the cvar for the map quick bind
	self setClientCvar("g_scriptQuickMap", game["menu_viewmap"]);

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
			checkSnipers();
			self.sessionteam = "allies";
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
		}
		else
		{
			checkSnipers();
			self.sessionteam = "axis";
			self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
		}
			
		if(isDefined(self.pers["weapon"]))
			spawnPlayer();
		else
		{
			spawnSpectator();
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

		spawnSpectator();
	}

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

		if(menu == game["menu_team"])
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
				
				if(response == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead"))
				{
					if(self.pers["team"] == "allies")
					{
						self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
						self openMenu(game["menu_weapon_allies"]);
					}
					else
					{
						self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
						self openMenu(game["menu_weapon_axis"]);
					}				
					break;
				}
				
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
				self.pers["savedmodel"] = undefined;

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
					self.pers["team"] = "spectator";
					self.pers["teamTime"] = 1000000;
					self.pers["weapon"] = undefined;
					self.pers["savedmodel"] = undefined;
					
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
			
			if(isDefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
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

Callback_PlayerDisconnect()
{
	lpselfnum = self getEntityNumber();

	level.R_U_Name[lpselfnum] = "disconnected";
	level.R_U_State[lpselfnum] = "disconnected";
	self.R_U_Looping = 0;

	if(level.rdyup == 1)
		thread maps\mp\gametypes\_pam_readyup::Check_All_Ready();

	iprintln(&"MPSCRIPT_DISCONNECTED", self);
	
	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("Q;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
	if(self.sessionteam == "spectator")
		return;

	// dont take damage during ceasefire mode
	// but still take damage from ambient damage (water, minefields, fire)
	if(level.ceasefire && sMeansOfDeath != "MOD_EXPLOSIVE" && sMeansOfDeath != "MOD_WATER" && sMeansOfDeath != "MOD_TRIGGER_HURT")
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
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpselfGuid = self getGuid();
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackGuid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}

		if(isDefined(friendly)) 
		{  
			lpattacknum = lpselfnum;
			lpattackname = lpselfname;
			lpattackGuid = lpselfGuid;
		}
		
		logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
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
	
	self.sessionstate = "dead";
	if(level.rdyup != 1)
		self.statusicon = "gfx/hud/hud@status_dead.tga";
	self.headicon = "";
	if (!isdefined (self.autobalance) && level.allowscoring)
		self.deaths++;

	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpselfguid = self getGuid();
	lpselfteam = self.pers["team"];
	lpattackerteam = "";

	attackerNum = -1;
	if(isPlayer(attacker))
	{
		if(attacker == self) // killed himself
		{
			doKillcam = false;
			if (!isdefined (self.autobalance) && level.allowscoring)
				attacker.score--;

			if (level.scoringpenalty == "match" && level.allowscoring)
			{
				teamscore = getTeamScore(attacker.pers["team"]);
				teamscore--;
				setTeamScore(attacker.pers["team"], teamscore);

				if (lpselfteam == "axis")
				{
					if (game["halftimeflag"] == "0")
						game["round1axisscore"]--;
					else
						game["round2axisscore"]--;
				}
				else if (game["halftimeflag"] == "0")
					game["round1alliesscore"]--;
				else
					game["round2alliesscore"]--;
			}
			
			if(isDefined(attacker.friendlydamage))
				clientAnnouncement(attacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT"); 
		}
		else
		{
			attackerNum = attacker getEntityNumber();
			doKillcam = true;

			if(self.pers["team"] == attacker.pers["team"] && level.allowscoring) // killed by a friendly
			{
				attacker.score--;

				if (level.scoringpenalty == "match")
				{
					teamscore = getTeamScore(attacker.pers["team"]);
					teamscore--;
					setTeamScore(attacker.pers["team"], teamscore);

					if (lpselfteam == "axis")
					{
						if (game["halftimeflag"] == "0")
							game["round1axisscore"]--;
						else
							game["round2axisscore"]--;
					}
					else if (game["halftimeflag"] == "0")
						game["round1alliesscore"]--;
					else
						game["round2alliesscore"]--;
				}
			}
			else if (level.allowscoring)
			{
				attacker.score++;

				teamscore = getTeamScore(attacker.pers["team"]);
				teamscore++;
				setTeamScore(attacker.pers["team"], teamscore);

				if (lpselfteam == "axis")
				{
					if (game["halftimeflag"] == "0")
						game["round1alliesscore"]++;
					else
						game["round2alliesscore"]++;
				}
				else if (game["halftimeflag"] == "0")
					game["round1axisscore"]++;
				else
					game["round2axisscore"]++;
			
				if (game["mode"] == "pub")
					checkScoreLimit();
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
		
		if (level.allowscoring)
			self.score--;

		if (level.scoringpenalty == "match" && isdefined(self.pers["team"]) && level.allowscoring)
		{
			teamscore = getTeamScore(self.pers["team"]);
			teamscore--;
			setTeamScore(self.pers["team"], teamscore);

			if (lpselfteam == "axis")
			{
				if (game["halftimeflag"] == "0")
					game["round1axisscore"]--;
				else
					game["round2axisscore"]--;
			}
			else if (game["halftimeflag"] == "0")
				game["round1alliesscore"]--;
			else
				game["round2alliesscore"]--;
		}

		lpattacknum = -1;
		lpattackname = "";
		lpattackguid = "";
		lpattackerteam = "world";
	}

	game["team1score"] = game["round1axisscore"] + game["round2alliesscore"];
	game["team2score"] = game["round2axisscore"] + game["round1alliesscore"];

	game["alliedscore"] = getTeamScore("allies");
	game["axisscore"] = getTeamScore("axis");

	logPrint("K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");

	// Stop thread if map ended on this death
	if(level.mapended)
		return;

	// Make the player drop his weapon
	self dropItem(self getcurrentweapon());
	
	// Make the player drop health
	self dropHealth();
	self.autobalance = undefined;
	body = self cloneplayer();

	delay = 2;	// Delay the player becoming a spectator till after he's done dying
	wait delay;	// ?? Also required for Callback_PlayerKilled to complete before respawn/killcam can execute

	if((getCvarInt("scr_killcam") <= 0) || (getCvarInt("scr_forcerespawn") > 0))
		doKillcam = false;
	
	if(doKillcam)
		self thread killcam(attackerNum, delay);
	else
		self thread respawn();
}

// ----------------------------------------------------------------------------------
//	menu_spawn
//
// 		called from the player connect to spawn the player
// ----------------------------------------------------------------------------------
menu_spawn(weapon)
{
	if(!isDefined(self.pers["weapon"]))
	{
		self.pers["weapon"] = weapon;
		spawnPlayer();
		self thread printJoinedTeam(self.pers["team"]);
	}
	else
	{
		self.pers["weapon"] = weapon;

		weaponname = maps\mp\gametypes\_pam_teams::getWeaponName(self.pers["weapon"]);
		
		if(maps\mp\gametypes\_pam_teams::useAn(self.pers["weapon"]))
			self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_AN", weaponname);
		else
			self iprintln(&"MPSCRIPT_YOU_WILL_RESPAWN_WITH_A", weaponname);
	}
	if (isdefined (self.autobalance_notify))
		self.autobalance_notify destroy();
}

spawnPlayer()
{
	checkSnipers();
	self notify("spawned");
	self notify("end_respawn");
	
	resettimeout();

	self.sessionteam = self.pers["team"];
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;
		
	spawnpointname = "mp_teamdeathmatch_spawn";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(spawnpoints);

	if(isDefined(spawnpoint))
		spawnpoint maps\mp\gametypes\_spawnlogic::SpawnPlayer(self);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

	if(level.rdyup != 1)
		self.statusicon = "";
	self.maxhealth = 100;
	self.health = self.maxhealth;
	
	self.pers["rank"] = maps\mp\gametypes\_rank_gmi::DetermineBattleRank(self);
	self.rank = self.pers["rank"];
	
	if(!isDefined(self.pers["savedmodel"]))
		maps\mp\gametypes\_pam_teams::model();
	else
		maps\mp\_utility::loadModel(self.pers["savedmodel"]);

	// setup all the weapons
	self maps\mp\gametypes\_pam_loadout_gmi::PlayerSpawnLoadout();

	checkSnipers();

	if(self.pers["team"] == "allies")
		self setClientCvar("cg_objectiveText", &"TDM_KILL_AXIS_PLAYERS");
	else if(self.pers["team"] == "axis")
		self setClientCvar("cg_objectiveText", &"TDM_KILL_ALLIED_PLAYERS");

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
	checkSnipers();
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;

	if(self.pers["team"] == "spectator" && level.rdyup != 1)
		self.statusicon = "";
	
	if(isDefined(origin) && isDefined(angles))
		self spawn(origin, angles);
	else
	{
         	spawnpointname = "mp_teamdeathmatch_intermission";
		spawnpoints = getentarray(spawnpointname, "classname");
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	
		if(isDefined(spawnpoint))
			self spawn(spawnpoint.origin, spawnpoint.angles);
		else
			maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
	}
	
	self setClientCvar("cg_objectiveText", &"TDM_ALLIES_KILL_AXIS_PLAYERS");
}

spawnIntermission()
{
	self notify("spawned");
	self notify("end_respawn");

	resettimeout();

	checkSnipers();

	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.friendlydamage = undefined;

	spawnpointname = "mp_teamdeathmatch_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	
	if(isDefined(spawnpoint))
		self spawn(spawnpoint.origin, spawnpoint.angles);
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

respawn()
{
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
		
	if(getCvarInt("scr_forcerespawn") > 0)
	{
		self thread waitForceRespawnTime();
		self thread waitRespawnButton();
		self waittill("respawn");
	}
	else
	{
		self thread waitRespawnButton();
		self waittill("respawn");
	}
	
	self thread spawnPlayer();
}

waitForceRespawnTime()
{
	self endon("end_respawn");
	self endon("respawn");
	
	wait getCvarInt("scr_forcerespawn");
	self notify("respawn");
}

waitRespawnButton()
{
	self endon("end_respawn");
	self endon("respawn");
	
	wait 0; // Required or the "respawn" notify could happen before it's waittill has begun

	if ( getcvar("scr_forcerespawn") == "1" )
		return;
	
	self.respawntext = newClientHudElem(self);
	self.respawntext.alignX = "center";
	self.respawntext.alignY = "middle";
	self.respawntext.x = 320;
	self.respawntext.y = 70;
	self.respawntext.archived = false;
	self.respawntext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

	thread removeRespawnText();
	thread waitRemoveRespawnText("end_respawn");
	thread waitRemoveRespawnText("respawn");

	while(self useButtonPressed() != true)
		wait .05;
	
	self notify("remove_respawntext");

	self notify("respawn");	
}

removeRespawnText()
{
	self waittill("remove_respawntext");

	if(isDefined(self.respawntext))
		self.respawntext destroy();
}

waitRemoveRespawnText(message)
{
	self endon("remove_respawntext");

	self waittill(message);
	self notify("remove_respawntext");
}

killcam(attackerNum, delay)
{
	self endon("spawned");

//	previousorigin = self.origin;
//	previousangles = self.angles;
	
	// killcam
	if(attackerNum < 0)
		return;

	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.archivetime = delay + 7;

	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;

	if(self.archivetime <= delay)
	{
		self.spectatorclient = -1;
		self.archivetime = 0;
		self.sessionstate = "dead";
	
		self thread respawn();
		return;
	}

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

	if ( getcvar("scr_forcerespawn") != "1" )
	{
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
		self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");
	}

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
	self.sessionstate = "dead";

	//self thread spawnSpectator(previousorigin + (0, 0, 60), previousangles);
	self thread respawn();
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
	checkSnipers();

	level.warmup = 1;
	if( game["mode"] == "match" && game["firsthalfready"] == 0)
		CheckMatchStart();

	if (game["readyup"] == 1)
	{
		// 1st Half Ready-up Only.  2nd Half is done in Do_Halftime
		Do_Ready_Up();

		game["firsthalfready"] = 1;
		//cause the map to restart
		map_restart(true);
	}

	level.starttime = getTime();

	if (level.half_time < 1)
	{
		level.allowscoring = true;

		if(level.timelimit > 0)
		{
			level.warmup = 0;

			level.clock = newHudElem();
			level.clock.x = 320;
			level.clock.y = 460;
			level.clock.alignX = "center";
			level.clock.alignY = "middle";
			level.clock.font = "bigfixed";
			level.clock setTimer(level.timelimit * 60);
		}
		
		for(;;)
		{
			checkTimeLimit();
			wait 1;
		}
	}
	else if (game["halftimeflag"] == "0")
	{
		Run_First_Half();

		if (getcvar("scr_tdm_dohalftime") == "1")
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

endMap()
{
	game["state"] = "intermission";
	level notify("intermission");
	
	if(game["alliedscore"] == game["axisscore"])
	{
		winningteam = "tie";
		losingteam = "tie";
		text = "MPSCRIPT_THE_GAME_IS_A_TIE";
	}
	else if(game["alliedscore"] > game["axisscore"])
	{
		winningteam = "allies";
		losingteam = "axis";
		text = &"MPSCRIPT_ALLIES_WIN";
	}
	else
	{
		winningteam = "axis";
		losingteam = "allies";
		text = &"MPSCRIPT_AXIS_WIN";
	}
	
	if((winningteam == "allies") || (winningteam == "axis"))
	{
		winners = "";
		losers = "";
	}
	
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if((winningteam == "allies") || (winningteam == "axis"))
		{
			lpGuid = player getGuid();
			if((isDefined(player.pers["team"])) && (player.pers["team"] == winningteam))
					winners = (winners + ";" + lpGuid + ";" + player.name);
			else if((isDefined(player.pers["team"])) && (player.pers["team"] == losingteam))
					losers = (losers + ";" + lpGuid + ";" + player.name);
		}
		player closeMenu();
		player setClientCvar("g_scriptMainMenu", "main");
		player setClientCvar("cg_objectiveText", text);
		player spawnIntermission();
	}

	if (game["mode"] == "match")
		maps\mp\gametypes\_pam_utilities::Prevent_Map_Change();

	// Enable all Client Consoles
	setCvar("sv_disableClientConsole", "0");

	if((winningteam == "allies") || (winningteam == "axis"))
	{
		logPrint("W;" + winningteam + winners + "\n");
		logPrint("L;" + losingteam + losers + "\n");
	}
	
	wait 7;

	exitLevel(false);
}

checkTimeLimit()
{
	if(level.timelimit <= 0)
		return;
	
	timepassed = (getTime() - level.starttime) / 1000;
	timepassed = timepassed / 60.0;
	
	if(timepassed < level.timelimit)
		return;
	
	if(level.mapended)
		return;
	level.mapended = true;

	level.allowscoring = false;

	iprintln(&"MPSCRIPT_TIME_LIMIT_REACHED");
	level thread endMap();
}

checkScoreLimit()
{
	if(level.scorelimit <= 0)
		return;
	
	if(getTeamScore("allies") < level.scorelimit && getTeamScore("axis") < level.scorelimit)
		return;

	if(level.mapended)
		return;
	level.mapended = true;

	iprintln(&"MPSCRIPT_SCORE_LIMIT_REACHED");
	level thread endMap();
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

		pure = getCvarInt("sv_pure");
		if (pure != level.pure)
		{
			level.pure = getCvarInt("sv_pure");
			if (level.pure == 1)
				iprintln("^2SV_PURE turned ON!");
			else
				iprintln("^1SV_PURE turned OFF!");
		}

		scoringpenalty = getCvar("scr_teamscorepenalty");
		if (scoringpenalty != level.scoringpenalty)
		{
			if (scoringpenalty)
				iprintln("^2TDM Scoring Penalty turned ON");
			else
				iprintln("^1TDM Scoring Penalty turned OFF");

			level.scoringpenalty = scoringpenalty;
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

		timelimit = getCvarFloat("scr_tdm_timelimit");
		if(level.timelimit != timelimit)
		{
			if(timelimit > 1440)
			{
				timelimit = 1440;
				setCvar("scr_tdm_timelimit", "1440");
			}
			
			level.timelimit = timelimit;
			setCvar("ui_tdm_timelimit", level.timelimit);
			level.starttime = getTime();
			
			if(level.timelimit > 0)
			{
				if(!isDefined(level.clock))
				{
					level.clock = newHudElem();
					level.clock.x = 320;
					level.clock.y = 440;
					level.clock.alignX = "center";
					level.clock.alignY = "middle";
					level.clock.font = "bigfixed";
				}
				level.clock setTimer(level.timelimit * 60);
			}
			else
			{
				if(isDefined(level.clock))
					level.clock destroy();
			}
			
			//checkTimeLimit();
		}

		scorelimit = getCvarInt("scr_tdm_scorelimit");
		if(level.scorelimit != scorelimit)
		{
			level.scorelimit = scorelimit;
			setCvar("ui_tdm_scorelimit", level.scorelimit);
		}
		if (game["mode"] == "pub")
			checkScoreLimit();

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
			if (level.teambalancetimer >= 60 )
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

printJoinedTeam(team)
{
	if(team == "allies")
		iprintln(&"MPSCRIPT_JOINED_ALLIES", self);
	else if(team == "axis")
		iprintln(&"MPSCRIPT_JOINED_AXIS", self);
}

// ----------------------------------------------------------------------------------
//	dropHealth
// ----------------------------------------------------------------------------------
dropHealth()
{
	if ( !level.drophealth )
		return;
		
	if(isDefined(level.healthqueue[level.healthqueuecurrent]))
		level.healthqueue[level.healthqueuecurrent] delete();
	
	level.healthqueue[level.healthqueuecurrent] = spawn("item_health", self.origin + (0, 0, 1));
	level.healthqueue[level.healthqueuecurrent].angles = (0, randomint(360), 0);

	level.healthqueuecurrent++;
	
	if(level.healthqueuecurrent >= 16)
		level.healthqueuecurrent = 0;
}

addBotClients()
{
	wait 5;
	
	for(;;)
	{
		if(getCvarInt("scr_numbots") > 0)
			break;
		wait 1;
	}
	
	iNumBots = getCvarInt("scr_numbots");
	for(i = 0; i < iNumBots; i++)
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
				ent[i] notify("menuresponse", game["menu_weapon_allies"], "springfield_mp");
			}
		}
	}
}

CheckMatchStart()
{
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

		wait 1;
	}

	// Two teams are here, ready-up!
	game["readyup"] = 1;

	// Reset all Player and Team Scores
	resetScores();

}

checkSnipers()
{
	maps\mp\gametypes\_Check_Snipers::CheckSnipersScript();
}

Ready_UP()
{
	maps\mp\gametypes\_pam_readyup::PAM_Ready_UP();
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

	checkSnipers();

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
			
		player thread stopwatch_start("match_start", time);
	}
	
	wait (time);

	Destroy_HUD_RoundStart();

	game["readyup"] = 0;
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

Run_First_Half()
{
	level.warmup = 0;
	game["firsthalfready"] = 1;

	level.allowscoring = true;

	level.clock = newHudElem();
	level.clock.x = 320;
	level.clock.y = 460;
	level.clock.alignX = "center";
	level.clock.alignY = "middle";
	level.clock.font = "bigfixed";
	level.clock setTimer(level.half_time * 60);

	while(1)
	{
		timepassed = (getTime() - level.starttime) / 1000;
		timepassed = timepassed / 60.0;
	
		if(timepassed > level.half_time)
			break;

		wait 1;
	}

	level.allowscoring = false;

	level.warmup = 1;

	thread Create_HUD_TimeExp();
}

Do_Halftime()
{
	// Don't let teambalance take effect
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

		if ( getCvarint("scr_tdm_clearscoreeachhalf") == 1 )
		{
			player.pers["score"] = 0;
			player.pers["deaths"] = 0;

			if (level.battlerank)
				maps\mp\gametypes\_rank_gmi::ResetPlayerRank();
		}
	}  // end for loop

	thread maps\mp\_pam_tankdrive_gmi::PAM_deactivate_tanks();

	checkSnipers();

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

Start_Second_Half()
{
	//cause players to respawn
	if(isdefined(level.clock))
		level.clock destroy();

	level.warmup = 0;

	level.allowscoring = true;

	level.starttime = getTime();

	level.clock = newHudElem();
	level.clock.x = 320;
	level.clock.y = 460;
	level.clock.alignX = "center";
	level.clock.alignY = "middle";
	level.clock.font = "bigfixed";
	level.clock setTimer(level.half_time * 60);

	while(1)
	{
		timepassed = (getTime() - level.starttime) / 1000;
		timepassed = timepassed / 60.0;
	
		if(timepassed > level.half_time)
			break;

		wait 1;
	}

	level.warmup = 1;

	level.allowscoring = false;

	thread Create_HUD_TimeExp();
}

Respawn_Players()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player thread spawnPlayer();
	}
}

Do_Endgame()
{
	level.mapended = true;

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