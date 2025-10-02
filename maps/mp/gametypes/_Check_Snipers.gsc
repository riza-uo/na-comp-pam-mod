CheckSnipersScript()
{
	//check weapon limits
	sniperlimit = getcvarint("sv_SniperLimit");
	if (sniperlimit < 1 || sniperlimit == 99)
		sniperlimit = 99;
	else 
		limitsnipers = true;

	alliedSniperLimit = sniperlimit;
	axisSniperLimit = sniperlimit;
	ialliedSniperCount = 0;
	iaxisSniperCount = 0;

	smglimit = getcvarint("sv_SMGLimit");
	if (smglimit < 1 || smglimit == 99)
		smglimit = 99;
	else
		limitsmgs = true;
	alliedSMGLimit = smglimit;
	axisSMGLimit = smglimit;
	ialliedSMGCount = 0;
	iaxisSMGCount = 0;

	mglimit = getcvarint("sv_MGLimit");
	if (mglimit < 1 || mgslimit == 99)
		mglimit = 99;
	else
		limitmgs = true;
	alliedMGLimit = mglimit;
	axisMGLimit = mglimit;
	ialliedMGCount = 0;
	iaxisMGCount = 0;

	dmglimit = getcvarint("sv_DMGLimit");
	if (dmglimit < 1 || dmglimit == 99)
		dmglimit = 99;
	else
		limitdmgs = true;
	alliedDMGLimit = dmglimit;
	axisDMGLimit = dmglimit;
	ialliedDMGCount = 0;
	iaxisDMGCount = 0;

	inoWeaponCheck = 0;

	//get weapon counts
	lplayers = getentarray("player", "classname");
	for(i = 0; i < lplayers.size; i++)
	{
		lplayer = lplayers[i];
		take_away_weap = 0;

		if(!isdefined(lplayer.pers["weapon"]))
		{
			inoWeaponCheck = inoWeaponCheck + 1;
			setcvar("scr_noWeaponCheck", inoWeaponCheck);
		}
		else
		{
			switch (lplayer.pers["weapon"])
			{
				case "springfield_mp":
				case "mosin_nagant_sniper_mp":
					ialliedSniperCount = ialliedSniperCount + 1;
					if (ialliedSniperCount > alliedSniperLimit)
					{
						take_away_weap = 1;
						ialliedSniperCount--;
					}
					break;

				case "thompson_mp":
				case "thompson_semi_mp":
				case "sten_mp":
				case "ppsh_mp":
				case "ppsh_semi_mp":
				case "sten_silenced_mp":
					ialliedMGCount = ialliedMGCount + 1;
					if (ialliedSMGCount > alliedSMGLimit)
					{
						take_away_weap = 1;
						ialliedSMGCount--;
					}				
					break;
				
				case "bren_mp":
				case "bar_mp":
				case "bar_slow_mp":
					ialliedMGCount = ialliedMGCount + 1;
					if (ialliedMGCount > alliedMGLimit)
					{
						take_away_weap = 1;
						ialliedMGCount--;
					}
					break;
				
				case "dp28_mp":
				case "mg30cal_mp":
					ialliedDMGCount = ialliedDMGCount + 1;
					if (ialliedDMGCount > alliedDMGLimit)
					{
						take_away_weap = 1;
						ialliedDMGCount--;
					}
					break;
				
				case "kar98k_sniper_mp":
					iaxisSniperCount = iaxisSniperCount + 1;
					if (iaxisSniperCount > axisSniperLimit)
					{
						take_away_weap = 1;
						iaxisSniperCount--;
					}
					break;
				
				case "mp40_mp":
					iaxisSMGCount = iaxisSMGCount + 1;
					if (iaxisSMGCount > axisSMGLimit)
					{
						take_away_weap = 1;
						iaxisSMGCount--;
					}
					break;
				
				case "mp44_mp":
				case "mp44_semi_mp":
					iaxisMGCount = iaxisMGCount + 1;
					if (iaxisMGCount > axisMGLimit)
					{
						take_away_weap = 1;
						iaxisMGCount--;
					}
					break;
				
				case "mg34_mp":
					iaxisDMGCount = iaxisDMGCount + 1;
					if (iaxisDMGCount > axisDMGLimit)
					{
						take_away_weap = 1;
						iaxisDMGCount--;
					}
					break;
				
				default:
					inoWeaponCheck = inoWeaponCheck + 1;
					setcvar("scr_noWeaponCheck", inoWeaponCheck);
					break;	
			}


			// Take Away the Weapon if Needed
			if (take_away_weap)
			{
				lplayer.pers["weapon"] = undefined;
				lplayer.pers["weapon1"] = undefined;
				lplayer.pers["weapon2"] = undefined;
				lplayer.pers["spawnweapon"] = undefined;

				if(lplayer.pers["team"] == "allies")
				{
					lplayer setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
					lplayer openMenu(game["menu_weapon_allies"]);
				}
				else if (lplayer.pers["team"] == "axis")
				{
					lplayer setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
					lplayer openMenu(game["menu_weapon_axis"]);
				}
			}
		}
	}

	//Limit Snipers
	if (isdefined(limitsnipers))
	{
		if(ialliedSniperCount < alliedSniperLimit)
		{ 
			//turn on sniper weapon select
			setcvar("scr_allow_springfield", "1");
			setcvar("scr_allow_nagantsniper", "1");
		}
		else
		{
			//turn off sniper weapon select
			setcvar("scr_allow_springfield", "0");
			setcvar("scr_allow_nagantsniper", "0");	
		}

		if(iaxisSniperCount < axisSniperLimit)
		{ 
			//turn on sniper weapon select
			setcvar("scr_allow_kar98ksniper", "1");
		}
		else
		{
			//turn off sniper weapon select
			setcvar("scr_allow_kar98ksniper", "0");	
		}
	}

	//Limit SMGs
	if (isdefined(limitsmgs))
	{
		if(ialliedSMGCount < alliedSMGLimit)
		{ 
			//turn on SMG weapon select
			setcvar("scr_allow_thompson", "1");
			setcvar("scr_allow_sten", "1");
			setcvar("scr_allow_ppsh", "1");
		}
		else
		{
			//turn off SMG weapon select
			setcvar("scr_allow_thompson", "0");
			setcvar("scr_allow_sten", "0");
			setcvar("scr_allow_ppsh", "0");	
		}

		if(iaxisSMGCount < axisSMGLimit)
		{ 
			//turn on SMG weapon select
			setcvar("scr_allow_MP40", "1");
		}
		else
		{
			//turn off SMG weapon select
			setcvar("scr_allow_MP40", "0");	
		}
	}

	// Limit MGs
	if (isdefined(limitmgs))
	{
		if(ialliedMGCount < alliedMGLimit)
		{ 
			//turn on MG weapon select
			setcvar("scr_allow_bren", "1");
			setcvar("scr_allow_bar", "1");
		}
		else
		{
			//turn off MG weapon select
			setcvar("scr_allow_bren", "0");
			setcvar("scr_allow_bar", "0");
		}

		if(iaxisMGCount < axisMGLimit)
		{ 
			//turn on MG weapon select
			setcvar("scr_allow_MP44", "1");
		}
		else
		{
			//turn off MG weapon select
			setcvar("scr_allow_MP44", "0");
		}
	}

	// Limit DMGs
	if (isdefined(limitdmgs))
	{
		if(ialliedDMGCount < alliedDMGLimit)
		{ 
			//turn on DMG weapon select
			setcvar("scr_allow_dp28", "1");
			setcvar("scr_allow_mg30cal", "1");
		}
		else
		{
			//turn off DMG weapon select
			setcvar("scr_allow_dp28", "0");
			setcvar("scr_allow_mg30cal", "0");
		}

		if(iaxisDMGCount < axisDMGLimit)
		{ 
			//turn on DMG weapon select
			setcvar("scr_allow_mg34", "1");
		}
		else
		{
			//turn off DMG weapon select
			setcvar("scr_allow_mg34", "0");
		}
	}
}

NoDropWeapon()
{
	if (getcvar("sv_noDropDMG") == "")
		setcvar("sv_noDropDMG", "0");
	noDropDMG = getcvarint("sv_noDropDMG");

	if (getcvar("sv_noDropSniper") == "")
		setcvar("sv_noDropSniper", "0");
	noDropSniper = getcvarint("sv_noDropSniper");

	if (isdefined(self.pers["weapon"]) )
	{
		switch (self.pers["weapon"])
		{
			case "springfield_mp":
			case "kar98k_sniper_mp":
			case "mosin_nagant_sniper_mp":
				if (noDropSniper)
					return;
				break;
			
			case "dp28_mp":
			case "mg30cal_mp":
			case "mg34_mp":
				if (noDropDMG)
					return;
				break;
		}
		
		self dropItem(self getcurrentweapon());
	}
}