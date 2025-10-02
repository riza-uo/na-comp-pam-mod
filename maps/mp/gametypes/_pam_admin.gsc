// This is originally from Ravir, some modifications made by me
main()
{
	self notify("boot");
	wait 0.05; // let the threads die

	if(game["mode"] != "match")
	{
		thread switchteam();
		thread killum();
		thread switchspec();
	}
}

switchteam()
{
	self endon("boot");
	setcvar("g_switchteam", "");
	while(1)
	{
		if(getcvar("g_switchteam") != "")
		{
			if (getcvar("g_switchteam") == "all")
				setcvar("g_switchteam", "-1");

			movePlayerNum = getcvarint("g_switchteam");
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				thisPlayerNum = players[i] getEntityNumber();
				if(thisPlayerNum == movePlayerNum || movePlayerNum == -1) // this is the one we're looking for
				{

					if(players[i].pers["team"] == "axis")
						newTeam = "allies";
					if(players[i].pers["team"] == "allies")
						newTeam = "axis";

					if(isAlive(self))
					{
						players[i] suicide();

						players[i].pers["score"]++;
						players[i].score = players[i].pers["score"];
						players[i].pers["deaths"]--;
						players[i].deaths = players[i].pers["deaths"];
					}

					players[i].pers["team"] = newTeam;
					players[i].pers["weapon"] = undefined;
					players[i].pers["weapon1"] = undefined;
					players[i].pers["weapon2"] = undefined;
					players[i].pers["spawnweapon"] = undefined;
					players[i].pers["savedmodel"] = undefined;

					players[i] setClientCvar("scr_showweapontab", "1");

					if(players[i].pers["team"] == "allies")
					{
						players[i] setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
						players[i] openMenu(game["menu_weapon_allies"]);
					}
					else
					{
						players[i] setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
						players[i] openMenu(game["menu_weapon_axis"]);
					}
					if(movePlayerNum != -1)
						iprintln(players[i].name + "^7 was forced to switch teams by the admin");
				}
			}
			if(movePlayerNum == -1)
				iprintln("The admin forced all players to switch teams.");

			setcvar("g_switchteam", "");
		}
		wait 0.05;
	}
}



killum()
{
	self endon("boot");

	setcvar("g_killplayer", "");
	while(1)
	{
		if(getcvar("g_killplayer") != "")
		{
			killPlayerNum = getcvarint("g_killplayer");
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				thisPlayerNum = players[i] getEntityNumber();
				if(thisPlayerNum == killPlayerNum) // this is the one we're looking for
				{
					players[i] suicide();
					iprintln(players[i].name + "^7 was killed by the admin");
				}
			}
			setcvar("g_killplayer", "");
		}
		wait 0.05;
	}
}

switchspec()
{
	self endon("boot");
	setcvar("g_switchspec", "");
	while(1)
	{
		if(getcvar("g_switchspec") != "")
		{

			movePlayerNum = getcvarint("g_switchspec");
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				thisPlayerNum = players[i] getEntityNumber();
				if(thisPlayerNum == movePlayerNum) // this is the one we're looking for
				{
					if(isAlive(self))
					{
						players[i] suicide();

						players[i].pers["score"]++;
						players[i].score = players[i].pers["score"];
						players[i].pers["deaths"]--;
						players[i].deaths = players[i].pers["deaths"];
					}
						
					players[i].pers["team"] = "spectator";
					players[i].pers["teamTime"] = 1000000;
					players[i].pers["weapon"] = undefined;
					players[i].pers["weapon1"] = undefined;
					players[i].pers["weapon2"] = undefined;
					players[i].pers["spawnweapon"] = undefined;
					players[i].pers["savedmodel"] = undefined;
					
					players[i].sessionteam = "spectator";
					players[i].sessionstate = "spectator";
					players[i].spectatorclient = -1;
					players[i].archivetime = 0;
					players[i].friendlydamage = undefined;
					players[i] setClientCvar("g_scriptMainMenu", game["menu_team"]);
					players[i] setClientCvar("ui_weapontab", "0");
					players[i].statusicon = "";
					
					players[i] notify("spawned");
					resettimeout();

					maps\mp\gametypes\_teams::SetSpectatePermissions();

					spawnpointname = "mp_teamdeathmatch_intermission";
					spawnpoints = getentarray(spawnpointname, "classname");
					spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	
					if(isDefined(spawnpoint))
						players[i] spawn(spawnpoint.origin, spawnpoint.angles);
					else
						maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

					iprintln(players[i].name + "^7 was forced to Spectate by the admin");
				}
			}

			setcvar("g_switchspec", "");
		}
		wait 0.05;
	}
}

substr(searchfor, searchin)
{
	location = -1;
	if(searchin.size < searchfor.size)
		return location;

	if(searchin.size == searchfor.size && searchin != searchfor)
		return location;

	if(searchfor.size == 0)
		return 0;

	for (c = 0; c < searchin.size; c++)
	{
		if(searchin[c] == searchfor[0]) // matched the first character
		{
			location = c;
			for(i = 0; i+c < searchin.size && i < searchfor.size && location > -1; i++)
			{
				if(searchin[i+c] != searchfor[i])
					location = -1;
			}
			if(i < searchfor.size)
				location = -1;
		}
	}

	return location;
}



smiteplayer() // make a player explode, will hurt people up to 15 feet away
{
	self endon("boot");

	setcvar("g_smite", "");
	while(1)
	{
		if(getcvar("g_smite") != "")
		{
			smitePlayerNum = getcvarint("g_smite");
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
			{
				thisPlayerNum = players[i] getEntityNumber();
				if(thisPlayerNum == smitePlayerNum && players[i].sessionstate == "playing") // this is the one we're looking for
				{
					// explode 
					range = 180;
					maxdamage = 150;
					mindamage = 10;

					playfx(level._effect["bombexplosion"], players[i].origin);
					radiusDamage(players[i].origin + (0,0,12), range, maxdamage, mindamage);
					iprintln("Lo, the admin smote " + players[i].name + "^7 with fire!");
				}
			}
			setcvar("g_smite", "");
		}
		wait 0.05;
	}
}