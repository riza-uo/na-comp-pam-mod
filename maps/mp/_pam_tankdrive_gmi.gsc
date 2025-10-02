// Originally modded my gitman, spawn selection method and additional checks changed/added by bell
modifiedtankmain()
{
	level.watereffects 	= loadfx ("fx/water/tug_froth.efx");
	level.fireydeath = loadfx ("fx/fire/pathfinder_extreme.efx");

	level.tank_hud_bar = "gfx/hud/hud@health_bar.dds";

	precacheShader( "gfx/hud/hud@littletank.dds" );
	precacheShader( "gfx/hud/hud@fire_ready_shell.tga" );
	precacheShader( "gfx/hud/hud@vehiclehealth.dds");
	precacheShader( "gfx/hud/tankhudhealthbar" );
	precacheShader( level.tank_hud_bar );
	precacheShader( "white" );
	precacheShader( "black" );

	precacheShader( "gfx/hud/tank_reticle25.dds");
	precacheShader( "gfx/hud/tank_reticle50.dds");
	precacheShader( "gfx/hud/tank_reticle75.dds");
	precacheShader( "gfx/hud/tank_reticle100.dds");

	precacheString(&"GMI_MP_CAPTURED_ALLIED_TANK_BROADCAST");
	precacheString(&"GMI_MP_CAPTURED_AXIS_TANK_BROADCAST");
	precacheString(&"GMI_MP_TANK_CAPTURING");
	precacheString(&"GMI_MP_TANK_CAPTURED");

	initVehicleCvars();
	
	// this is now a cvar (gitman)
	//level.tank_capture_time = 15000;		// todo: capture time should be a cvar

	// !! TEMP HACK !!
	// the tanks will eventually have mg42's included in the models
	// but for now we need to actually map one onto them manually
	//gunmodel = "xmodel/vehicle_tank_panzeriv_machinegun";
	//precachemodel(gunmodel);

	restrictPlacedVehicles();

	// precache everything for the tanks
	tankEffect_init();
	wait 1;

	// Get spawns
	gt = getcvar("g_gametype");
	switch (gt)
	{
		case "sd":
			spawn_allied = getentarray("mp_searchanddestroy_spawn_allied", "classname");
			spawn_axis   = getentarray("mp_searchanddestroy_spawn_axis", "classname");
			break;

		case "re":
			spawn_allied = getentarray("mp_retrieval_spawn_allied", "classname");
			spawn_axis   = getentarray("mp_retrieval_spawn_axis", "classname");
			break;

		case "bas":
			spawn_allied = getentarray("mp_gmi_bas_allies_spawn", "classname");
			spawn_axis   = getentarray("mp_gmi_bas_axis_spawn", "classname");
			break;

		case "ctf":
		case "dom":
			spawn_allied = getentarray("mp_uo_spawn_allies", "classname");
			if(!spawn_allied.size)
				spawn_allied = getentarray("mp_uo_spawn_allies_secondary", "classname");
			spawn_axis   = getentarray("mp_uo_spawn_axis", "classname");
			if(!spawn_axis.size)
				spawn_axis = getentarray("mp_uo_spawn_axis_secondary", "classname");
			break;

		default:
			spawn_allied = getentarray("mp_teamdeathmatch_spawn", "classname");
			spawn_axis   = getentarray("mp_teamdeathmatch_spawn", "classname");
			break;
	}
	if(!spawn_allied.size)	spawn_allied = getentarray("mp_teamdeathmatch_spawn", "classname");
	if(!spawn_allied.size)	spawn_allied = getentarray("mp_deathmatch_spawn", "classname");
	if(!spawn_axis.size)	spawn_axis   = getentarray("mp_teamdeathmatch_spawn", "classname");
	if(!spawn_axis.size)	spawn_axis   = getentarray("mp_deathmatch_spawn", "classname");

	allied_origin	= spawn_allied[0].origin;
	axis_origin		= spawn_axis[0].origin;

	if(level.t34_limit)
	{
		t34_arr = findtanks("t34_mp");
		if (isdefined(t34_arr) && t34_arr.size)
		{
			if(isdefined(allied_origin))
				tankSort = maps\mp\gametypes\_spawnlogic_gmi::GMI_distance_sort(allied_origin, t34_arr);
			else
				tankSort = t34_arr;
			limitTank_init(tankSort, level.t34_limit);
		}
	}
	if(level.su152_limit)
	{
		su152_arr = findtanks("su152_mp");
		if (isdefined(su152_arr) && su152_arr.size)
		{
			if(isdefined(allied_origin))
				tankSort = maps\mp\gametypes\_spawnlogic_gmi::GMI_distance_sort(allied_origin, su152_arr);
			else
				tankSort = su152_arr;
			limitTank_init(tankSort, level.su152_limit);
		}
	}
	if(level.sherman_limit)
	{
		sherman_arr = findtanks("shermantank_mp");
		if (isdefined(sherman_arr) && sherman_arr.size)
		{
			if(isdefined(allied_origin))
				tankSort = maps\mp\gametypes\_spawnlogic_gmi::GMI_distance_sort(allied_origin, sherman_arr);
			else
				tankSort = sherman_arr;
			limitTank_init(tankSort, level.sherman_limit);
		}
	}
	if(level.panzeriv_limit)
	{
		panzeriv_arr = findtanks("panzeriv_mp");
		if (isdefined(panzeriv_arr) && panzeriv_arr.size)
		{
			if(isdefined(axis_origin))
				tankSort = maps\mp\gametypes\_spawnlogic_gmi::GMI_distance_sort(axis_origin, panzeriv_arr);
			else
				tankSort = panzeriv_arr;
			limitTank_init(tankSort, level.panzeriv_limit);
		}
	}
	if(level.elefant_limit)
	{
		elefant_arr = findtanks("elefant_mp");
		if (isdefined(elefant_arr) && elefant_arr.size)
		{
			if(isdefined(axis_origin))
				tankSort = maps\mp\gametypes\_spawnlogic_gmi::GMI_distance_sort(axis_origin, elefant_arr);
			else
				tankSort = elefant_arr;
			limitTank_init(tankSort, level.elefant_limit);
		}
	}
}

init_tank(precache)
{
	// give us some health, and manage hud elements
	self thread init_tank_hud();

	// init the riding_count
	self.riding_count = 0;

	// start the respawn thread
	self thread tank_respawn();

	// setup death model and wait for tank death
	if ((self.vehicletype == "t34_mp") ||
		(self.vehicletype == "shermantank_mp") ||
		(self.vehicletype == "elefant_mp") ||
		(self.vehicletype == "su152_mp") ||
		(self.vehicletype == "panzeriv_mp"))
	{
		self maps\mp\_tankeffects_gmi::init( 0 );
	}
	self thread maps\mp\_tankeffects_gmi::tank_damaged_smoke();
	self thread maps\mp\_tankeffects_gmi::tank_death();

	// set the team for capturing
	self tank_set_team();

	// wait for a player to jump in
	self thread wait_for_activate();
}

tank_set_team()
{
	game_type = getcvar("g_gametype");
	// if this is deathmatch, tdm, or hq then vehicles do not have a team because we
	// can not control where people spawn in these modes
	if ( game_type == "dm" || game_type == "tdm" || game_type == "hq")
	{
		self.team = "all";
		return;
	}

	if ((self.vehicletype == "t34_mp") || (self.vehicletype == "shermantank_mp" )|| (self.vehicletype == "su152_mp"))
	{
		self.team = "allies";
		//self.team = "axis";
	}
	else if (self.vehicletype == "panzeriv_mp" || self.vehicletype == "elefant_mp")
	{
		self.team = "axis";
		//self.team = "allies";
	}
}

tank_respawn()
{
	self waittill("death");

	wait self.delay;

	// check for a NO_RESPAWN flag	
	if (!(self.spawnflags & 2))
	{
		dupe = self spawnduplicate();
		
		// this is for debuggin
		dupe.tank_num = self.tank_num;
		
		dupe thread wait_for_safe_respawn();
		
		// let us disappear
		self notify("allow_explode");
	}
	else
	{
		// let us disappear
		self notify("allow_explode");
	}
}

wait_for_safe_respawn()
{
	self unlinkfromworld();

	spawn_limit = getCvarInt("scr_tank_spawn_limit");
	
	// dont respawn this vehicle if it is over the spawn_limit
	if ( spawn_limit > 0 && self.spawn_count >= spawn_limit )
	{
		self delete();
		return;
	}
	
	wait_time = cvardef("scr_tank_respawn_wait",10,0,99999,"int");

	// now wait for a safe time to respawn
	wait wait_time;	// delay before respawn
	while (1)
	{
		self clearvehicleposition();
		
		if (self verifyposition())
			break;
		wait 1.0;
	}
	self linkintoworld();
	self thread init_tank( 0 );
}

wait_for_activate()
{
	self endon("death");

	while (1)
	{
		self waittill("activated", vehpos, activator);
		
		self thread delayed_process_activate( vehpos, activator );
	}
}

delayed_process_activate( vehpos, activator )
{
	self.riding_count++;

	// wait for the tank to be deactivated
	// this needs to be run at the top of the function in case the player jumps in and out on the same frame
	self thread deactivated( activator );

	// if this is the driver assume they are capturing to prevent a early fire 
	// before the capture code kicks in.
	if (vehpos == 1)
		self.capturing = 1;
		
	// wait one frame to make sure a simultaneous deactivate is processed first
	wait 0.1;

	// if the tank is set to self-destruct, then abort it if this person is of the correct team
//	if (isdefined(self.self_destruct_team) && (self.self_destruct_team == activator.pers["team"])) 
//	{
		self notify("stop_self_destruct");
//	}

	activator.vehpos = vehpos;

	// do tank capturing stuff
	self thread tank_check_capture( activator );
	
	// wait one frame so the capturing stuff can be set up
	wait 0.1;
	
	if (vehpos == 1)
	{	
		self.has_been_driven = 1;
	
		self.driver = activator;
		self thread player_shoot();
		self thread player_shoot_alt();
	}
	else if (vehpos == 2)
	{
		self.gunner = activator;
		self thread player_shoot_gunner();
	}

	// give them a hud display for the tank
	self thread tank_hud_activated( activator );
	
	// wait for the tank to be deactivated
	self thread deactivated( activator );
	
	// blow us up if the tank dies while we're in it
	activator thread tank_death_player_damage( self );
	
}

tank_check_capture( activator )
{
	// clear the capture variable because it is assumed in a capture mode when a driver gets in
	if (activator.vehpos == 1)
		self.capturing = 0;
	
	if (!isdefined( self.team ))
		return;
	
	// no capturing in dm
	if ( getcvar("g_gametype") == "dm" )
		return;
		
	if (self.team == "all")
		return;
		
	if (activator.vehpos == 1 && self.team != activator.pers["team"]) {
		// this person needs to capture the tank before it can be driven
		self thread tank_capture_think( activator );
	}
}

tank_capture_hud_destroy_thread(tank, driver, capturehud, capturehud2, capturehudtext)
{
	driver waittill("stop_tank_capture_hud");

	tank.capturing = 0;

	if (!isValidPlayer( driver ))
	{
		// already disconnected, hudelem's must have been destroyed
		return;
	}

	capturehud destroy();
	capturehud2 destroy();
	capturehudtext destroy();
}

tank_capture_think( activator )
{
	hud_bar_height	= 12;

	activator endon("stop_tank_capture_hud");

	self.capturing = 1;
	
	capture_starttime = gettime();
	capture_endtime = capture_starttime + level.tank_capture_time;

	self.capture_hud_maxwidth = maps\mp\_util_mp_gmi::get_progressbar_maxwidth();
	self.capture_hud_width = 1;

	capturehudtext = maps\mp\_util_mp_gmi::get_progressbar_text(activator,&"GMI_MP_TANK_CAPTURING");
		
	// background
	capturehud2 =  maps\mp\_util_mp_gmi::get_progressbar_background(activator);

	// foreground
	capturehud = maps\mp\_util_mp_gmi::get_progressbar(activator);
	maps\mp\_util_mp_gmi::set_progressbar_width(capturehud, self.capture_hud_width);

	level thread tank_capture_hud_destroy_thread( self, activator, capturehud, capturehud2, capturehudtext );
	level thread tank_capture_sound( activator, self );
	
	while (gettime() < capture_endtime)
	{
		wait 0.2;
		
		if ( !isAlive(self) || !isDefined(capturehud) )
			return;
			
		// update the capture hud
		self.capture_hud_width = (1.0 * self.capture_hud_maxwidth * (gettime() - capture_starttime)) / level.tank_capture_time;
		if (self.capture_hud_width > self.capture_hud_maxwidth) self.capture_hud_width = self.capture_hud_maxwidth;
		if (self.capture_hud_width < 1) self.capture_hud_width = 1;  	// progress bar does not work right if set to 0
		maps\mp\_util_mp_gmi::set_progressbar_width(capturehud, self.capture_hud_width);
	}

	// success!
	self.team = "all";

	// give us props
	clientAnnouncement( activator, &"GMI_MP_TANK_CAPTURED" );

	// message to all teammates
	players = getentarray("player", "classname"); 
	for(i = 0; i < players.size; i++) 
	{ 
		player = players[i]; 
		if (activator.pers["team"] == player.pers["team"])
		{
			if (player.pers["team"] == "axis")
				player iprintln(&"GMI_MP_CAPTURED_ALLIED_TANK_BROADCAST", activator);
			else
				player iprintln(&"GMI_MP_CAPTURED_AXIS_TANK_BROADCAST", activator);
		}
	}
      	
      	self notify("stop_self_destruct");
	activator notify("stop_tank_capture_hud");
}

tank_capture_sound( activator, tank )
{
	activator endon("stop_tank_capture_hud");
	sound_object = spawn ("script_model",tank.origin);
	sound_object.started = false;
	
	// this prevents the entity from being solid and blocking the radius damage
	sound_object SetContents(0);
	
	thread tank_capture_sound_cleanup( activator, sound_object );
	
	// the capture time is 10 secs, the sound is 7 secs, so we will start the sound
	// 3 secs in to the capture to get the sound to roll right into the regular tank sound
	// if either the capture time or the sound length changes then this needs to be updated
//	wait_time = (level.tank_capture_time * 0.001) - 7.5;
//	if (wait_time < 0)
//		wait_time = 0;
//		
//	println("waiting cap sound sound" + wait_time);
//	wait(wait_time);
	
	// even though this sound only plays once we need to play it as a looping sound so
	// we can stop it if the player jumps out.  You can only stop looping sounds.
	sound_object playloopsound ("tank_hotwire");
	sound_object.started = true;
}

tank_capture_sound_cleanup( activator, sound_object )
{
	activator waittill("stop_tank_capture_hud");
	
	if ( sound_object.started )
		sound_object stoploopsound();
	
	// let the sound stop
	wait(0.01);
	
	sound_object delete();
}

tank_death_player_damage( tank )
{
	self endon ("deactivated_player");
	
	tank waittill("death");

	mod = "MOD_EXPLOSIVE";
	
	if ( isDefined(self.deepwater) && self.deepwater )
		mod = "MOD_WATER";
		
	// kill the tank
	if (isDefined( tank.last_attacker ) && isValidPlayer( tank.last_attacker ))
	{
		inflictor = tank.last_attacker;
		if (isDefined( tank.last_inflictor ))
		{
			inflictor = tank.last_inflictor;
		}
		self DoDamage( 10000, tank.origin,  tank.last_attacker, inflictor, mod );
	}
	else
	{
		self DoDamage( 10000, tank.origin, tank, tank, mod );
	}
}

send_delayed_player_deactivate()
{
	// wait for a bit, so that the deactivate on tank death doesnt abort the damage function before the tank death can be processed
	wait 0.1;
	self notify("deactivated_player");
}

deactivated( activator )
{
	while (1)
	{
		self waittill("deactivated", deactivator);
		
		if (activator != deactivator)
		{
			// someone else, so go back to waiting
			continue;
		}

		// the activator, has deactivated
		
		self.riding_count--;
		
		// send this so they can end player-oriented threads
		if ( isValidPlayer(activator) )
			activator thread send_delayed_player_deactivate();
		
		self thread process_deactivate(deactivator);
		break;
	}
}

/*
deactivated( activator )
{
	while (!level.killvehicles)
	{
		self waittill("deactivated", deactivator);
		
		if (activator != deactivator)
		{
			// someone else, so go back to waiting
			continue;
		}

		// the activator, has deactivated
		
		self.riding_count--;
		
		// send this so they can end player-oriented threads
		if ( isValidPlayer(activator) && !level.killvehicles )
			activator thread send_delayed_player_deactivate();
		
		self thread process_deactivate(deactivator);
		break;
	}

	if (level.killvehicles)
	{
		activator thread send_delayed_player_deactivate();
		self thread PAM_process_deactivate();
	}

}*/


PAM_deactivate_tanks()
{
	level.killvehicles = true;

	tanks = getentarray("script_vehicle","classname");
	for(i=0;i<tanks.size;i++)
	{
		tank = tanks[i];

		owner = tank getvehicleowner();

		if (isdefined(owner) )
		{
			owner thread KillMe();
		}
	}
}

KillMe()
{
	self suicide();

	if (getcvar("g_gametype") == "sd")
	{
		self.pers["deaths"]--;
		self.deaths = self.pers["deaths"];

		self.pers["score"]++;
		self.score = self.pers["score"];
	}
}

PAM_process_deactivate()
{
	wait 3;

	self.health = 0;
	self.hud_width = 0;

	radiusDamage ( (self.origin[0],self.origin[1],self.origin[2]+25), 2, 10000, 9000 );
}
	
process_deactivate(deactivator)
{
	if (isdefined(deactivator) && deactivator.vehpos == 1) {	// driver
		self.driver = undefined;
	}
	if (isdefined(deactivator) && deactivator.vehpos == 2) {	// gunner
		self.gunner = undefined;
	}

	if ( isValidPlayer( deactivator ) )
	{
		deactivator notify ("stop_tank_capture_hud");
		deactivator notify ("stop_tank_hud");
		self.self_destruct_team = deactivator.pers["team"];
	}
	else
	{
		self.self_destruct_team = "all";
	}

	if (self.riding_count == 0 && isdefined(self.has_been_driven) && (self.team == "all" || self.team == self.self_destruct_team)) 
	{
		// now start a timer to self destruct
		self endon("stop_self_destruct");
		
		// wait and then if not being used blow up
		wait(180);

		// TODO: some kind of onscreen display so the rider knows what happened??
		
		// only blow up if it is empty
		if (isValidPlayer( deactivator ))
			radiusDamage ( (self.origin[0],self.origin[1],self.origin[2]+25), 2, 10000, 9000, deactivator, self );
		else
			radiusDamage ( (self.origin[0],self.origin[1],self.origin[2]+25), 2, 10000, 9000 );
	}
}

init_tank_hud()
{
	self.healthbuffer = 2000;
	self.basehealth = 900;
	self.health = self.basehealth + self.healthbuffer;
	self.currenthealth = self.health;
	self.hud_width = 128;
	self.hud_maxwidth = self.hud_width;
	basewidth = self.hud_width;
	minwidth = 1;

	while(self.hud_width > minwidth)
	{
		self waittill ("damage",ammount,attacker,dir,point,mod,inflictor);

		println("tank " + self.tank_num + " taking damage " + ammount );
		// if we are in ceasefire mode vehicles can not be damaged
		if(level.ceasefire)
		{
			self.health = self.health + ammount;
			continue;
		}
		
		if ( !isdefined(inflictor) )
			inflictor = attacker;
			
		owner = self getvehicleowner();
		
		// no damage if friendly fire
		if(isdefined(attacker) && isPlayer(attacker) && isdefined(owner) 
			&& (self != inflictor) && (owner.pers["team"] == attacker.pers["team"])
			&& level.friendlyfire == "0" && getcvar("g_gametype") != "dm" )
		{
			self.health = self.health + ammount;
			continue;
		}
		
		// pass on some of the damage to the driver (muahhh muahhhh muahh muahhh ahhh)
//		if ( isdefined(self.driver) && isvalidplayer(self.driver) )
//		{
//			println("passing damage to driver " + ammount + " "+ ammount * 0.045 );
//			if (isDefined( attacker ) && isValidPlayer( attacker ))
//			{
//				self.driver dodamage( ammount * 0.045, point, attacker, inflictor, mod );
//			}
//			else
//			{
//				// really should never get here
//				self.driver dodamage( ammount * 0.045, point, self, self, mod );
//			}
//		}
		
		self.currenthealth = self.health;
		if(!(self.health < self.healthbuffer))
		{
			self.hud_width = ((self.health - self.healthbuffer)*basewidth)/self.basehealth;
		}
		else
		{
			self.hud_width = 0;
		}

		self notify("tank_hud_update");
	}

	// save who the last attacker was so we can give them credit for the driverkill
	self.last_attacker = attacker;
	self.last_inflictor = inflictor;	
	
	// kill the tank
	if ( mod != "MOD_WATER")
	{
		if (isDefined( attacker ) && isValidPlayer( attacker ))
		{
			radiusDamage ( (self.origin[0],self.origin[1],self.origin[2]+25), 2, 10000, 9000, attacker, inflictor);
		}
		else
		{
			radiusDamage ( (self.origin[0],self.origin[1],self.origin[2]+25), 2, 10000, 9000 );
		}
	
		// big explosion
		if (isDefined( attacker ))
		{
			radiusDamage ( (self.origin[0],self.origin[1],self.origin[2]+25), 512,  150, 0, attacker, inflictor);
		}
		else
		{
			radiusDamage ( (self.origin[0],self.origin[1],self.origin[2]+25), 512, 150, 0);
		}
	}
	
}

tank_hud_destroy_thread(tank, driver, tankhud, tankhud2, overheat, littletank, fireicon)
{
	driver waittill("vehicle_deactivated",tank);
//	driver waittill("stop_tank_hud");

	if (!isvalidplayer( driver ))
	{
		// already disconnected, hudelem's must have been destroyed
		return;
	}

	littletank destroy();

	tankhud destroy();
	tankhud2 destroy();
	overheat destroy();
	
	if (isdefined(fireicon))
	{
		if (isdefined( fireicon[0] )) fireicon[0] destroy();
		if (isdefined( fireicon[1] )) fireicon[1] destroy();
		if (isdefined( fireicon[2] )) fireicon[2] destroy();
		if (isdefined( fireicon[3] )) fireicon[3] destroy();
	}
}

tank_hud_activated(activator)
{
	// create the hud elements
	littletank = newClientHudElem(activator);
	littletank setShader("gfx/hud/hud@littletank.dds", 12, 10);
	littletank.alignX = "left";
	littletank.alignY = "top";
	littletank.x = 488;
	littletank.y = 445;

	overheat = newClientHudElem( activator );
	overheat setShader(level.tank_hud_bar, 128, 4);
	overheat.alignX = "left";
	overheat.alignY = "top";
	overheat.x = 488+14;
	overheat.y = 437;

	tankhud = newClientHudElem( activator );
	tankhud.color = (1.0,0.0,0.0);

	tankhud setShader(level.tank_hud_bar, self.hud_width,8);
	tankhud.alignX = "left";
	tankhud.alignY = "top";
	tankhud.x = 488+13;
	tankhud.y = 446;
	
	tankhud2 = newClientHudElem( activator );
	tankhud2 setShader("gfx/hud/hud@vehiclehealth.dds", 128, 32);
	tankhud2.alignX = "left";
	tankhud2.alignY = "top";
	tankhud2.x = 488+13;
	tankhud2.y = 452-16;
	
	if (isdefined(self.driver) && activator == self.driver)
	{	
		fireicon[0] = newClientHudElem( activator );
		fireicon[0].alignX = "center";
		fireicon[0].alignY = "middle";
		fireicon[0].x = 320;
		fireicon[0].y = 240;
		fireicon[0] setShader("gfx/hud/tank_reticle25.dds", 64, 64);

		fireicon[1] = newClientHudElem( activator );
		fireicon[1].alignX = "center";
		fireicon[1].alignY = "middle";
		fireicon[1].x = 320;
		fireicon[1].y = 240;
		fireicon[1] setShader("gfx/hud/tank_reticle50.dds", 64, 64);

		fireicon[2] = newClientHudElem( activator );
		fireicon[2].alignX = "center";
		fireicon[2].alignY = "middle";
		fireicon[2].x = 320;
		fireicon[2].y = 240;
		fireicon[2] setShader("gfx/hud/tank_reticle75.dds", 64, 64);

		fireicon[3] = newClientHudElem( activator );
		fireicon[3].alignX = "center";
		fireicon[3].alignY = "middle";
		fireicon[3].x = 320;
		fireicon[3].y = 240;
		fireicon[3] setShader("gfx/hud/tank_reticle100.dds", 64, 64);

		self thread tank_hud_fireicon_run( activator, fireicon);
		level thread tank_hud_destroy_thread( self, activator, tankhud, tankhud2, overheat, littletank, fireicon );
		self thread tank_hud_overheat_run( activator,overheat, true);
	}
	else
	{
		level thread tank_hud_destroy_thread( self, activator, tankhud, tankhud2, overheat, littletank );
		self thread tank_hud_overheat_run( activator,overheat, false );
	}
		
	// while the player is using the tank, keep updating the hud	
	self thread tank_hud_run( activator, tankhud );
}

tank_hud_run(driver, tankhud)
{
	self endon("death");
	driver endon("death");
	driver endon("stop_tank_hud");
	
	minwidth = 0;

	while(1)
	{
		self waittill("tank_hud_update");

		if ( !isAlive(self) || !isDefined(tankhud) )
			continue;
			
		if(self.hud_width > minwidth)
			tankhud setShader(level.tank_hud_bar, self.hud_width,8);
		else
		{
			tankhud setShader(level.tank_hud_bar, minwidth,8);
			break;
		}
	}
}

tank_hud_overheat_run(activator, overheat, is_driver)
{
	self endon("death");
	activator endon("death");
	activator endon("stop_tank_hud");
	
	minheight = 0;

	max_width = 126;
	
	while(1)
	{
		wait (0.1);
		if ( !isAlive(self) || !isDefined(overheat) )
			continue;
		
		if (is_driver)
		{	
			heat = self getaltheat();
			overheating = self getaltoverheating();
		}
		else
		{
			heat = self getgunnerheat();
			overheating = self getgunneroverheating();
		}
		if ( overheating )
		{
			overheat.color = ( 1.0, 0.0, 0.0);
		}
		else
		{
			overheat.color = ( 1.0, 1.0-heat,1.0-heat);
		}
		
		hud_width = (1.0 - heat) * max_width;
		
		if ( hud_width < 1 )
			hud_width = 1;
			
		overheat setShader(level.tank_hud_bar, hud_width, 5);
	}
}

fadeoff()
{
	while(self.alpha > 0.0)
	{
		self.alpha = self.alpha - 0.2;
		wait(0.05);
	}
	self.threaded = 0;
}


tank_hud_fireicon_run( driver,fireicon )
{
	self endon ("death");
	driver endon ("death");
	driver endon ("stop_tank_hud");

	for (q=0;q<4;q++)
	{
		fireicon[q].threaded = 0;
		fireicon[q].alpha = 0;
	}

	while (1)
	{
		self waittill ("turret_fire");

		if(level.ceasefire == 2)
			continue;

		for (q=0;q<4;q++)
			fireicon[q].alpha = 1.0;

		wait .5;
		self playsound ("tank_reload");
	
		while (self isTurretReady() != true)
		{
			val = self get_fire_time() / 500;
			if (val<=3)
			{
//				self.fireicon[val].alpha = 0;
				if (fireicon[val].threaded == 0)
				{
					fireicon[val].threaded = 1;
					fireicon[val] thread fadeoff();
				}
			}
			wait .25;
		}
	}
}

deathrollon()
{
	if(self.health > 0)
		self.rollingdeath = 1;
}

deathrolloff()
{
	self.rollingdeath = undefined;
	self notify("deathrolloff");
}

player_shoot()
{
	self notify("kill_existing_player_shoot");
	self endon("kill_existing_player_shoot");
	while(self.health > 0)
	{
		self waittill( "turret_fire" );
		self fire();
	}
}

fire()
{
	if(self.health <= 0)
		return;

	if(self.capturing)
		return;

	if(level.ceasefire == 2)
		return;

	// fire the turret
	self FireTurret();
}

player_shoot_alt()
{
	self notify("kill_existing_player_shoot_alt");
	self endon("kill_existing_player_shoot_alt");
	while(self.health > 0)
	{
		self waittill( "turret_alt_fire" );
		self fire_alt();
	}
}

fire_alt()
{
	if(self.health <= 0)
		return;

	if(self.capturing)
		return;

	if(level.ceasefire == 2)
		return;

	// fire the turret
	self FireAltTurret();
}

player_shoot_gunner()
{
	self notify("kill_existing_player_shoot_gunner");
	self endon("kill_existing_player_shoot_gunner");
	while(self.health > 0)
	{
		self waittill( "turret_gunner_fire" );
		self fire_gunner();
	}
}

fire_gunner()
{
	if(self.health <= 0)
		return;

	if(level.ceasefire == 2)
		return;

	// fire the turret
	self FireGunner();
	
	wait (0.01);
}

restrictPlacedVehicles()
{
	if(!level.t34_limit)
		deletePlacedEntity("t34_mp");
	if(!level.sherman_limit)
		deletePlacedEntity("shermantank_mp");
	if(!level.panzeriv_limit)
		deletePlacedEntity("panzeriv_mp");
	if(!level.elefant_limit)
		deletePlacedEntity("elefant_mp");
	if(!level.su152_limit)
		deletePlacedEntity("su152_mp");
}

deletePlacedEntity(vehicletype)
{
	tanks = getentarray("script_vehicle","classname");

	for(i=0;i<tanks.size;i++)
	{
		if (tanks[i].vehicletype == vehicletype)
		{
			// precache effects and setup for death model change
//			println("DELETED: ", tanks[i].vehicletype);
			tanks[i] delete();
		}
	}
}

// precache effects for all available tanks
tankEffect_init()
{
	tanks = getentarray("script_vehicle","classname");
	for(i=0;i<tanks.size;i++)
	{
		switch(tanks[i].vehicletype)
		{
			case "t34_mp":
			case "shermantank_mp":
			case "elefant_mp":
			case "su152_mp":
			case "panzeriv_mp":
				// precache effects and setup for death model change
				tanks[i] maps\mp\_tankeffects_gmi::init( 1 );
				break;
			default:
				break;
		}
	}
}

limitTank_init(array, limit)
{
	for (i = 0; i < array.size; i++)
	{
		if(i<limit)
		{
			array[i] thread init_tank(1);
			array[i].tank_num = i;
		}
		else
			array[i] delete();
	}
}

findtanks(tanktype)
{
	tanks = getentarray("script_vehicle","classname");
	tankarr = [];
	for(i=0; i < tanks.size; i++)
		if(tanks[i].vehicletype == tanktype)
			tankarr[tankarr.size] = tanks[i];
	return tankarr;
}

cvardef(varname, vardefault, min, max, type)
{
	// Small Change to make Match configs MUCH easier without interrupting Pub configs
	if(!isdefined(game["mode"]) )
		game["mode"] = "pub";

	if (game["mode"] != "match")
	{
		mapname = getcvar("mapname");		// "mp_dawnville", "mp_rocket", etc.
		gametype = getcvar("g_gametype");	// "tdm", "bel", etc.

		tempvar = varname + "_" + gametype;	// i.e., scr_teambalance becomes scr_teambalance_tdm
		if(getcvar(tempvar) != "") 		// if the gametype override is being used
			varname = tempvar; 		// use the gametype override instead of the standard variable

		tempvar = varname + "_" + mapname;	// i.e., scr_teambalance becomes scr_teambalance_mp_dawnville
		if(getcvar(tempvar) != "")		// if the map override is being used
			varname = tempvar;		// use the map override instead of the standard variable
	}

	// get the variable's definition
	switch(type)
	{
		case "int":
			if(getcvar(varname) == "")		// if the cvar is blank
				definition = vardefault;	// set the default
			else
				definition = getcvarint(varname);
			break;
		case "float":
			if(getcvar(varname) == "")		// if the cvar is blank
				definition = vardefault;	// set the default
			else
				definition = getcvarfloat(varname);
			break;
		case "string":
		default:
			if(getcvar(varname) == "")		// if the cvar is blank
				definition = vardefault;	// set the default
			else
				definition = getcvar(varname);
			break;
	}

	// if it's a number, with a minimum, that violates the parameter
	if((type == "int" || type == "float") && min != "" && definition < min)
		definition = min;

	// if it's a number, with a maximum, that violates the parameter
	if((type == "int" || type == "float") && max != "" && definition > max)
		definition = max;

	return definition;
}

initVehicleCvars()
{
	//Medium Tank Limits
	medium_tank_limit = cvardef("scr_vehicle_limit_medium_tank", 99, 0, 99, "int");
	level.t34_limit	= medium_tank_limit;
	level.panzeriv_limit = medium_tank_limit;
	level.sherman_limit	= medium_tank_limit;

	//Heavy Tank Limits
	heavy_tank_limit = cvardef("scr_vehicle_limit_heavy_tank", 99, 0, 99, "int");
	level.su152_limit = heavy_tank_limit;
	level.elefant_limit	= heavy_tank_limit;

	//Tank Capture Time
	level.tank_capture_time = cvardef("scr_tank_capture_time",15000,0,999999,"int");

	if(getCvar("scr_tank_respawn_wait") == "")
		setCvar("scr_tank_respawn_wait", "10");

	if(getCvar("scr_tank_spawn_limit") == "")
		setCvar("scr_tank_spawn_limit", "0");

	level.allow_tanks = getCvar("scr_allow_tanks");
	if(level.allow_tanks == "")
		level.allow_tanks = "1";
	setCvar("scr_allow_tanks", level.allow_tanks);
	setCvar("ui_allow_tanks", level.allow_tanks);
	makeCvarServerInfo("ui_allow_tanks", "1");

	level.allow_t34 = getCvar("scr_allow_t34");
	if(level.allow_t34 == "")
		level.allow_t34 = "1";
	setCvar("scr_allow_t34", level.allow_t34);
	setCvar("ui_allow_t34", level.allow_t34);
	makeCvarServerInfo("ui_allow_t34", "1");

	level.allow_elefant = getCvar("scr_allow_elefant");
	if(level.allow_elefant == "")
		level.allow_elefant = "1";
	setCvar("scr_allow_elefant", level.allow_elefant);
	setCvar("ui_allow_elefant", level.allow_elefant);
	makeCvarServerInfo("ui_allow_elefant", "1");

	level.allow_sherman = getCvar("scr_allow_sherman");
	if(level.allow_sherman == "")
		level.allow_sherman = "1";
	setCvar("scr_allow_sherman", level.allow_sherman);
	setCvar("ui_allow_sherman", level.allow_sherman);
	makeCvarServerInfo("ui_allow_sherman", "1");

	level.allow_panzeriv = getCvar("scr_allow_panzeriv");
	if(level.allow_panzeriv == "")
		level.allow_panzeriv = "1";
	setCvar("scr_allow_panzeriv", level.allow_panzeriv);
	setCvar("ui_allow_panzeriv", level.allow_panzeriv);
	makeCvarServerInfo("ui_allow_panzeriv", "1");

	level.allow_su152 = getCvar("scr_allow_su152");
	if(level.allow_su152 == "")
		level.allow_su152 = "1";
	setCvar("scr_allow_su152", level.allow_su152);
	setCvar("ui_allow_su152", level.allow_su152);
	makeCvarServerInfo("ui_allow_su152", "1");

}
