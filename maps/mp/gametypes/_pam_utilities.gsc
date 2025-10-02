// This File has various PAM ulitities

// Curent Revision placed here
Get_Current_PAM_Ver()
{
	game["pamstring"] = &"P.A.M. UO V3.1";
}

//The below lines should be updated each new release:
Get_Stock_PK3()
{
	// List all Allowed PK3 file names HERE separated by a space.  DO NOT include '.pk3'
	level.stockPK3 = "uomappack00 pakuo07 pakuo06 pakuo05 pakuo04 pakuo03 pakuo02 pakuo01 pakuo00 pakb paka pak9 pak8 pak6 pak5 pak4 pak3 pak2 pak1 pak0 z_svr_pamuo_V3_1";
}

// Compares Known PAM Modes to catch mistakes, needs to be updated if new pam modes are included
Check_PAM_Modes(pammode)
{
	gametype = getcvar("g_gametype");

	if (gametype == "sd")
	{
		switch (pammode)
		{
		case "twl_ladder":
		case "twl_rifles":
		case "twl_classic_ladder":
		case "twl_league":
		case "ogl":
		case "cb":
		case "cal":
		case "bl":
		case "mgl":
		case "bl_classic":
		case "kw":
		case "pub":
		case "lan":
			return 1;

		default:
			return 0;
		}
	}
	else if (gametype == "ctf")
	{
		switch (pammode)
		{
			case "twl_ladder":
			case "twl_league":
			case "ogl":
			case "cb":
			case "cal":
			case "pub":
			case "twl_atc2":
			case "twl_rifles":
			case "twl_classic_ladder":
			case "twl_classic_league":
			case "bl":
			case "ga":
			case "ccodl":
			case "lan":
				return 1;

			default:
				return 0;
		}
	}
	else if (gametype == "tdm")
	{
		switch (pammode)
		{
			case "twl":
			case "bl":
			case "pub":
			case "lan":
			case "cb":
				return 1;

			default:
				return 0;
		}
	}
	else if (gametype == "dom")
	{
		switch (pammode)
		{
			case "twl":
			case "pub":
			case "lan":
				return 1;

			default:
				return 0;
		}
	}
	else if (gametype == "bas")
	{
		switch (pammode)
		{
			case "twl":
			case "pub":
			case "lan":
				return 1;

			default:
				return 0;
		}
	}
	else if (gametype == "hq")
	{
		switch (pammode)
		{
			case "twl":
			case "pub":
			case "lan":
				return 1;

			default:
				return 0;
		}
	}
	else if (gametype == "dm")
	{
		if (pammode == "pub")
			return 1;
		else
			return 0;
	}

	iprintln("^1Gametype ^3" + gametype + " ^1 not supported by PAM UO");
	return 0;
}


// **********************************************************************
// Should not need to change anything below here!
// **********************************************************************

//Searches for unknown PK3 files for use with all gametype competition modes
NonstockPK3Check()
{
	Get_Stock_PK3();

	level.serverPK3 = [];
	level.serverPK3 = getCvar("sv_pakNames");
	
	foundCount = 0;
	level.PK3check = [];
	level.PK3check[0] = "none";

	foundPK3 = splitArray(level.serverPK3, " ", "", true);
	for (i=0; i < foundPK3.size ; i++)
	{
		found = findStr(foundPK3[i], level.stockPK3, "anywhere");
		if (found != -1)
			continue;
		else
		{
			foundCount++;
			level.PK3check[foundCount] = foundPK3[i];
		}
	}
}


CheckPK3files()
{
	level.serverPK3 = [];
	level.serverPK3 = getCvar("sv_pakNames");
	self iprintln("^2Server PK3 Files:");
	self iprintln("^2" + level.serverPK3);

	// Print Unknown PK3 Files
	if (level.PK3check.size > 1)
	{
		self iprintln("^1Unknown PK3 files:");
		for (index = 1;index < level.PK3check.size; index++ )
		{
			self iprintln("^1" + level.PK3check[index]);
			wait .05;
		}
	}
	self iprintln("^8.");
	self iprintln("^8.");
	self iprintln("^8.");
	self iprintln("^8.");
	self iprintln("^2Server PK3 Files in console");
	if (level.PK3check.size > 1)
	{
			self iprintln("^1Warning: Unknown PK3 Files listed in console");
	}
}

Prevent_Map_Change()
{
	mapname = getcvar("mapname");
	setcvar("sv_mapRotationCurrent" , mapname);
}

PAMRestartMap()
{
	Prevent_Map_Change();

	pammode = getcvar("pam_mode");
	iprintlnbold("^2PAM UO Mode Changed to ^3" + pammode);
	iprintlnbold("^3Please Wait");

	wait 3;
	exitLevel(false);

}
PAM_Auto_Demo_Start()
{
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		player setClientCvar("cg_autodemo", "1");
		wait .5;
		player autoDemoStart();
	}

	game["demosrecording"] = 1;

	level.demosrecording = newHudElem();
	level.demosrecording.x = 575;
	level.demosrecording.y = 410;
	level.demosrecording.alignX = "center";
	level.demosrecording.alignY = "middle";
	level.demosrecording.fontScale = 1.5;
	level.demosrecording.color = (1, 1, 0);
	level.demosrecording setText(game["hudrecording"]);
}

PAM_Auto_Demo_Stop()
{
	//Prepare Client Side Cvars
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if (getCvar("g_autoscreenshot") == "1")
			player setClientCvar("cg_autoscreenshot", "1");
		if (game["demosrecording"] == 1)
			player setClientCvar("cg_autodemo", "1");
	}

	//Give Clients a chance to respond
	wait 1;

	// Stop the demo & Take screenshot
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		if (getCvar("g_autoscreenshot") == "1")
		{
			player autoScreenshot();
			player setClientCvar("cg_autoscreenshot", "0");
		}

		if (game["demosrecording"] == 1)
		{
			player autoDemoStop();
			player setClientCvar("cg_autodemo", "0");
		}
	}

	game["demosrecording"] = 0;
}

CheckValidTeam(temp_team)
{
	switch (temp_team)
	{
		case "american":
		case "british":
		case "russian":
		case "":
			return true;

		default:
			return false;
	}
}

StartPAMUO(reason)
{
	mapname = getcvar("mapname");
	mapname = "map " + mapname;
	if (mapname == "map mp_foy")
		mapname = "map mp_italy";
	else
		mapname = "map mp_foy";

	setcvar("sv_maprotationcurrent", mapname);

	if (reason == "enable")
	{
		iprintlnbold("^2PAM UO Enabled, Starting PAM UO");
		iprintlnbold("^3Please Wait");
		wait 3;
	}
	else if (reason == "modechange")
	{
		pammode = getcvar("pam_mode");
		iprintlnbold("^2PAM UO Mode Changed to ^3" + pammode);
		iprintlnbold("^3Please Wait");
		wait 5;
	}
	else if (reason == "cvar")
	{
		iprintlnbold("^2PAM UO Has Detected a CVAR Change that");
		iprintlnbold("^1REQUIRES ^2the map to change");
		iprintlnbold("^3Please Wait");
		wait 5;
	}

	exitLevel(false);
}

StopPAMUO()
{
	mapname = getcvar("mapname");
	mapname = "map " + mapname;
	if (mapname == "map mp_foy")
		mapname = "map mp_italy";
	else
		mapname = "map mp_foy";

	setcvar("sv_maprotationcurrent", mapname);

	iprintlnbold("^1PAM UO Disabled, Starting Stock UO");
	iprintlnbold("^3Please Wait");
	wait 3;

	exitLevel(false);
}


Team_Override(temp_allies)
{
	// Prevent new randomizations if we are not on the SAME map & gametype
	if( getcvar("mapname") == getcvar("pam_oldmap") && getcvar("g_gametype") == getcvar("pam_oldgt") )
	{
		game["allies"] = getcvar("pam_oldallies");
		game[game["allies"] + "_soldiertype"] 	= getcvar("pam_oldsoldiertype");
		game[game["allies"] + "_soldiervariation"]= getcvar("pam_oldsoldiervariation");
		
		return;
	}

	wintermap = false;
	if(isdefined(game["german_soldiervariation"]) && game["german_soldiervariation"] == "winter")
		wintermap = true;

	switch (temp_allies)
	{
		case "american":
			game["allies"] = "american";
			game["american_soldiertype"] = "airborne";
			if (wintermap)
				game["american_soldiervariation"] = "winter";
			else
				game["american_soldiervariation"] = "normal";
		break;

		
		case "british":
			game["allies"] = "british";
			if(wintermap)
			{
				game["british_soldiertype"] = "commando";
				game["british_soldiervariation"] = "winter";
			}
			else
			{
				switch(randomInt(2))
				{
					case 0:
						game["british_soldiertype"] = "airborne";
						game["british_soldiervariation"] = "normal";
						break;

					default:
						game["british_soldiertype"] = "commando";
						game["british_soldiervariation"] = "normal";
						break;
				}
			}
		break;


		case "russian":
			game["allies"] = "russian";
			if(wintermap)
			{
				switch(randomInt(2))
				{
					case 0:
						game["russian_soldiertype"] = "conscript";
						game["russian_soldiervariation"] = "winter";
						break;

					default:
						game["russian_soldiertype"] = "veteran";
						game["russian_soldiervariation"] = "winter";
						break;
				}
			}
			else
			{
				switch(randomInt(2))
				{
					case 0:
						game["russian_soldiertype"] = "conscript";
						game["russian_soldiervariation"] = "normal";
						break;


					default:
						game["russian_soldiertype"] = "veteran";
						game["russian_soldiervariation"] = "normal";
						break;

				}
			}
		break;

		default:
			break;
	}
}


// CODE BELOW ORIGINALLY FROM CoDAM
splitArray( str, sep, quote, skipEmpty )
{
	if ( !isdefined( str ) || ( str == "" ) )
		return ( [] );

	if ( !isdefined( sep ) || ( sep == "" ) )
		sep = ";";	// Default separator

	if ( !isdefined( quote ) )
		quote = "";

	skipEmpty = isdefined( skipEmpty );

	a = _splitRecur( 0, str, sep, quote, skipEmpty );

	return ( a );
}

_splitRecur( iter, str, sep, quote, skipEmpty )
{
	s = sep[ iter ];

	_a = [];
	_s = "";
	doQuote = false;
	for ( i = 0; i < str.size; i++ )
	{
		ch = str[ i ];
		if ( ch == quote )
		{
			doQuote = !doQuote;

			if ( iter + 1 < sep.size )
				_s += ch;
		}
		else
		if ( ( ch == s ) && !doQuote )
		{
			if ( ( _s != "" ) || !skipEmpty )
			{
				_l = _a.size;

				if ( iter + 1 < sep.size )
				{
					_x = _splitRecur( iter + 1, _s,	sep, quote, skipEmpty );

					if ( ( _x.size > 0 ) || !skipEmpty )
					{
						_a[ _l ][ "str" ] = _s;
						_a[ _l ][ "fields" ] = _x;
					}
				}
				else
					_a[ _l ] = _s;
			}

			_s = "";
		}
		else
			_s += ch;
	}

	if ( _s != "" )
	{
		_l = _a.size;

		if ( iter + 1 < sep.size )
		{
			_x = _splitRecur( iter + 1, _s, sep, quote, skipEmpty );
			if ( _x.size > 0 )
			{
				_a[ _l ][ "str" ] = _s;
				_a[ _l ][ "fields" ] = _x;
			}
		}
		else
			_a[ _l ] = _s;
	}

	return ( _a );
}

findStr( find, str, pos )
{
	if ( !isdefined( find ) || ( find == "" ) || 
		 !isdefined( str ) || 
		 !isdefined( pos ) || 
		 ( find.size > str.size ) )
		return ( -1 );

	fsize = find.size;
	ssize = str.size;

	switch ( pos )
	{
	  case "start": place = 0 ; break;
	  case "end":	place = ssize - fsize; break;
	  default:	place = 0 ; break;
	}

	for ( i = place; i < ssize; i++ )
	{
		if ( i + fsize > ssize )
			break;			// Too late to compare

		// Compare now ...
		for ( j = 0; j < fsize; j++ )
			if ( str[ i + j ] != find[ j ] )
				break;		// No match

		if ( j >= fsize )
			return ( i );		// Found it!

		if ( pos == "start" )
			break;			// Didn't find at start
	}

	return ( -1 );
}