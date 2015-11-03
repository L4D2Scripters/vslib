/*  
 * Copyright (c) 2013 LuKeM aka Neil - 119 and Rayman1103
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software
 * and associated documentation files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
 * BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 */


/**
 * \brief Provides many helpful entity functions.
 *
 *  The Entity class wraps many Valve functions as well as provide numerous
 *  helper functions that aid in the development of maps, mods, and mutations.
 */
class ::VSLib.Entity
{
	constructor(index)
	{
		if ("_ent" in index && "_idx" in index)
		{
			_ent = index._ent;
			_idx = index._idx;
		}
		else if ((typeof index) == "instance")
		{
			_ent = index;
			_idx = GetBaseIndex();
		}
		else if ((typeof index) == "integer")
		{
			_ent = Ent(index);
			_idx = index;
		}
		else if ((typeof index) == "string" && index.find("!") != 0)
		{
			_ent = Entities.FindByName(null, index);
			
			if (_ent == null)
				_ent = Entities.FindByClassname(null, index);
			
			if (_ent == null)
			{
				printf("VSLib Warning: Invalid targetname or classname (target not found)");
				_idx = -1;
			}
			else
				_idx = GetBaseIndex();
		}
		else
		{
			_ent = Ent(index);
			_idx = GetBaseIndex();
		}
	}
	
	
	function _typeof()
	{
		return "VSLIB_ENTITY";
	}
	
	function _cmp(other)
	{
		if ("_ent" in other && "_idx" in other)
		{
			if (_idx > other._idx)
				return 1;
			else if (_idx == other._idx)
				return 0;
			else if (_idx < other._idx)
				return -1;
		}
		else if ((typeof other) == "integer")
		{
			if (_idx > other)
				return 1;
			else if (_idx == other)
				return 0;
			else if (_idx < other)
				return -1;
		}
		else if ((typeof index) == "instance")
		{
			if (_ent > other)
				return 1;
			else if (_ent == other)
				return 0;
			else if (_ent < other)
				return -1;
		}
	}
	
	
	static _vsEntityClass = "VSLIB_ENTITY";
	_ent = null;
	_idx = null;
}

/**
 * Holds global entity data.
 *
 * \todo @TODO Perhaps move all of these into two distinct tables with KVs instead of leaving the KVs out in the EntData table
 */
::VSLib.EntData <-
{
	// single point_hurt data
	_lastHurt = -1
	_hurtIntent = -1
	_hurtDmg = 0
	_hurtIgnore = []
	
	_objPickupTimer = {}
	_objBtnPickup = {}
	_objBtnThrow = {}
	_objOldBtnMask = {}
	_objHolding = {}
	
	_objValveTimer = {}
	_objValveHolding = {}
	_objValveThrowPower = {}
	_objValvePickupRange = {}
	_objValveThrowDmg = {}
	_objValveHoldDmg = {}
	_objEnableDmg = {}
	
	_inv = {}
	_invItems = {}
}



/**
 * Global definitions and constants.
 */
getconsttable()["InvalidEntity"] <- null;

// Teams
getconsttable()["UNKNOWN"] <- 0; /**< Anything that is unknown. */
getconsttable()["SPECTATORS"] <- 1;
getconsttable()["SURVIVORS"] <- 2;
getconsttable()["INFECTED"] <- 3;
getconsttable()["L4D1_SURVIVORS"] <- 4;

// "Gender" types, to be used with GetGender()
getconsttable()["MALE"] <- 1;
getconsttable()["FEMALE"] <- 2;

// "Zombie" types, to be used with GetPlayerType()
getconsttable()["Z_INFECTED"] <- 0;
getconsttable()["Z_COMMON"] <- 0;
getconsttable()["Z_SMOKER"] <- 1;
getconsttable()["Z_BOOMER"] <- 2;
getconsttable()["Z_HUNTER"] <- 3;
getconsttable()["Z_SPITTER"] <- 4;
getconsttable()["Z_JOCKEY"] <- 5;
getconsttable()["Z_CHARGER"] <- 6;
getconsttable()["Z_WITCH"] <- 7;
getconsttable()["Z_TANK"] <- 8;
getconsttable()["Z_SURVIVOR"] <- 9;
getconsttable()["Z_MOB"] <- 10;
getconsttable()["Z_WITCH_BRIDE"] <- 11;

// "Uncommon" types, to be used with GetUncommonInfected()
getconsttable()["Z_CEDA"] <- 11;
getconsttable()["Z_MUD"] <- 12;
getconsttable()["Z_ROADCREW"] <- 13;
getconsttable()["Z_FALLEN"] <- 14;
getconsttable()["Z_RIOT"] <- 15;
getconsttable()["Z_CLOWN"] <- 16;
getconsttable()["Z_JIMMY"] <- 17;

// More button values to be used with IsPressingButton()
getconsttable()["BUTTON_ATTACK"] <- 1;
getconsttable()["BUTTON_JUMP"] <- 2;
getconsttable()["BUTTON_DUCK"] <- 4;
getconsttable()["BUTTON_FORWARD"] <- 8;
getconsttable()["BUTTON_BACK"] <- 16;
getconsttable()["BUTTON_USE"] <- 32;
getconsttable()["BUTTON_CANCEL"] <- 64;
getconsttable()["BUTTON_LEFT"] <- 128;
getconsttable()["BUTTON_RIGHT"] <- 256;
getconsttable()["BUTTON_MOVELEFT"] <- 512; // move left key (e.g. A)
getconsttable()["BUTTON_MOVERIGHT"] <- 1024; // move right key (e.g. D)
getconsttable()["BUTTON_SHOVE"] <- 2048;
getconsttable()["BUTTON_RUN"] <- 4096;
getconsttable()["BUTTON_RELOAD"] <- 8192;
getconsttable()["BUTTON_ALT1"] <- 16384;
getconsttable()["BUTTON_ALT2"] <- 32768;
getconsttable()["BUTTON_SCORE"] <- 65536;   // Used by client.dll for when scoreboard is held down
getconsttable()["BUTTON_WALK"] <- 131072; // Player is holding the walk key
getconsttable()["BUTTON_ZOOM"] <- 524288; // Zoom key
getconsttable()["BUTTON_WEAPON1"] <- 1048576; // weapon defines these bits
getconsttable()["BUTTON_WEAPON2"] <- 2097152; // weapon defines these bits
getconsttable()["BUTTON_BULLRUSH"] <- 4194304;
getconsttable()["BUTTON_GRENADE1"] <- 8388608; // grenade 1
getconsttable()["BUTTON_GRENADE2"] <- 16777216; // grenade 2
getconsttable()["BUTTON_LOOKSPIN"] <- 0x2000000; // lookspin if bound #shotgunefx

// Damage types that can be used with Hurt(), etc
getconsttable()["DMG_GENERIC"] <- 0;
getconsttable()["DMG_CRUSH"] <- (1 << 0);
getconsttable()["DMG_BULLET"] <- (1 << 1);
getconsttable()["DMG_SLASH"] <- (1 << 2);
getconsttable()["DMG_BURN"] <- (1 << 3);
getconsttable()["DMG_VEHICLE"] <- (1 << 4);
getconsttable()["DMG_FALL"] <- (1 << 5);
getconsttable()["DMG_BLAST"] <- (1 << 6);
getconsttable()["DMG_CLUB"] <- (1 << 7);
getconsttable()["DMG_SHOCK"] <- (1 << 8);
getconsttable()["DMG_SONIC"] <- (1 << 9);
getconsttable()["DMG_ENERGYBEAM"] <- (1 << 10);
getconsttable()["DMG_PREVENT_PHYSICS_FORCE"] <- (1 << 11);
getconsttable()["DMG_NEVERGIB"] <- (1 << 12);
getconsttable()["DMG_ALWAYSGIB"] <- (1 << 13);
getconsttable()["DMG_DROWN"] <- (1 << 14);
getconsttable()["DMG_PARALYZE"] <- (1 << 15);
getconsttable()["DMG_NERVEGAS"] <- (1 << 16);
getconsttable()["DMG_POISON"] <- (1 << 17);
getconsttable()["DMG_RADIATION"] <- (1 << 18);
getconsttable()["DMG_DROWNRECOVER"] <- (1 << 19);
getconsttable()["DMG_CHOKE"] <- (1 << 20);
getconsttable()["DMG_ACID"] <- (1 << 20);
getconsttable()["DMG_MELEE"] <- (1 << 21);
getconsttable()["DMG_SLOWBURN"] <- (1 << 21);
getconsttable()["DMG_REMOVENORAGDOLL"] <- (1 << 22);
getconsttable()["DMG_PHYSGUN"] <- (1 << 23);
getconsttable()["DMG_PLASMA"] <- (1 << 24);
getconsttable()["DMG_STUMBLE"] <- (1 << 25);
getconsttable()["DMG_AIRBOAT"] <- (1 << 25);
getconsttable()["DMG_DISSOLVE"] <- (1 << 26);
getconsttable()["DMG_BLAST_SURFACE"] <- (1 << 27);
getconsttable()["DMG_DIRECT"] <- (1 << 28);
getconsttable()["DMG_BUCKSHOT"] <- (1 << 29);
getconsttable()["DMG_HEADSHOT"] <- (1 << 30);
getconsttable()["DMG_DISMEMBER"] <- (1 << 31);


// Upgrades that can be used with GiveUpgrade(), etc
getconsttable()["UPGRADE_INCENDIARY_AMMO"] <- 0;
getconsttable()["UPGRADE_EXPLOSIVE_AMMO"] <- 1;
getconsttable()["UPGRADE_LASER_SIGHT"] <- 2;

// Bash values that can be used with OnBash().
getconsttable()["ALLOW_BASH_ALL"] <- 0;
getconsttable()["ALLOW_BASH_PUSHONLY"] <- 1;
getconsttable()["ALLOW_BASH_NONE"] <- 2;

// Bot sense flags.
getconsttable()["BOT_CANT_SEE"] <- (1 << 0);
getconsttable()["BOT_CANT_HEAR"] <- (1 << 1);
getconsttable()["BOT_CANT_FEEL"] <- (1 << 2);

// Values that can be used to command bots.
getconsttable()["BOT_CMD_ATTACK"] <- 0;
getconsttable()["BOT_CMD_MOVE"] <- 1;
getconsttable()["BOT_CMD_RETREAT"] <- 2;
getconsttable()["BOT_CMD_RESET"] <- 3;

// Infected bot sense flags.
getconsttable()["INFECTED_FLAG_CANT_SEE_SURVIVORS"] <- (1 << 13);
getconsttable()["INFECTED_FLAG_CANT_HEAR_SURVIVORS"] <- (1 << 14);
getconsttable()["INFECTED_FLAG_CANT_FEEL_SURVIVORS"] <- (1 << 15);

// Trace masks for TraceLine().
getconsttable()["TRACE_MASK_ALL"] <- -1;
getconsttable()["TRACE_MASK_VISION"] <- 33579073;
getconsttable()["TRACE_MASK_VISIBLE_AND_NPCS"] <- 33579137;
getconsttable()["TRACE_MASK_PLAYER_SOLID"] <- 33636363;
getconsttable()["TRACE_MASK_NPC_SOLID"] <- 33701899;
getconsttable()["TRACE_MASK_SHOT"] <- 1174421507;


// Content flags
getconsttable()["CONTENTS_EMPTY"] <-			0;		/**< No contents. */
getconsttable()["CONTENTS_SOLID"] <-			0x1;		/**< an eye is never valid in a solid . */
getconsttable()["CONTENTS_WINDOW"] <-			0x2;		/**< translucent, but not watery (glass). */
getconsttable()["CONTENTS_AUX"] <-			0x4;
getconsttable()["CONTENTS_GRATE"] <-			0x8;		/**< alpha-tested "grate" textures.  Bullets/sight pass through, but solids don't. */
getconsttable()["CONTENTS_SLIME"] <-			0x10;
getconsttable()["CONTENTS_WATER"] <-			0x20;
getconsttable()["CONTENTS_MIST"] <-			0x40;
getconsttable()["CONTENTS_OPAQUE"] <-			0x80;		/**< things that cannot be seen through (may be non-solid though). */
getconsttable()["LAST_VISIBLE_CONTENTS"] <-	0x80;
getconsttable()["ALL_VISIBLE_CONTENTS"] <- 	(getconsttable()["LAST_VISIBLE_CONTENTS"] | (getconsttable()["LAST_VISIBLE_CONTENTS"]-1))
getconsttable()["CONTENTS_TESTFOGVOLUME"] <-	0x100;
getconsttable()["CONTENTS_UNUSED5"] <-		0x200;
getconsttable()["CONTENTS_UNUSED6"] <-		0x4000;
getconsttable()["CONTENTS_TEAM1"] <-			0x800;		/**< per team contents used to differentiate collisions. */
getconsttable()["CONTENTS_TEAM2"] <-			0x1000;		/**< between players and objects on different teams. */
getconsttable()["CONTENTS_IGNORE_NODRAW_OPAQUE"] <-	0x2000;		/**< ignore CONTENTS_OPAQUE on surfaces that have SURF_NODRAW. */
getconsttable()["CONTENTS_MOVEABLE"] <-		0x4000;		/**< hits entities which are MOVETYPE_PUSH (doors, plats, etc) */
getconsttable()["CONTENTS_AREAPORTAL"] <-		0x8000;		/**< remaining contents are non-visible, and don't eat brushes. */
getconsttable()["CONTENTS_PLAYERCLIP"] <-		0x10000;
getconsttable()["CONTENTS_MONSTERCLIP"] <-	0x20000;
getconsttable()["CONTENTS_ORIGIN"] <-			0x1000000;	/**< removed before bsping an entity. */
getconsttable()["CONTENTS_MONSTER"] <-		0x2000000;	/**< should never be on a brush, only in game. */
getconsttable()["CONTENTS_DEBRIS"] <-			0x4000000;
getconsttable()["CONTENTS_DETAIL"] <-			0x8000000;	/**< brushes to be added after vis leafs. */
getconsttable()["CONTENTS_TRANSLUCENT"] <-	0x10000000;	/**< auto set if any surface has trans. */
getconsttable()["CONTENTS_LADDER"] <-			0x20000000;
getconsttable()["CONTENTS_HITBOX"] <-			0x40000000;	/**< use accurate hitboxes on trace. */


// Many more masks
getconsttable()["MASK_WATER"] <-(getconsttable()["CONTENTS_WATER"]|getconsttable()["CONTENTS_MOVEABLE"]|getconsttable()["CONTENTS_SLIME"]) /**< water physics in these contents */
getconsttable()["MASK_OPAQUE"] <-(getconsttable()["CONTENTS_SOLID"]|getconsttable()["CONTENTS_MOVEABLE"]|getconsttable()["CONTENTS_OPAQUE"]) /**< everything that blocks line of sight for AI, lighting, etc */
getconsttable()["MASK_OPAQUE_AND_NPCS"] <-(getconsttable()["MASK_OPAQUE"]|getconsttable()["CONTENTS_MONSTER"])/**< everything that blocks line of sight for AI, lighting, etc, but with monsters added. */
getconsttable()["MASK_VISIBLE"] <-(getconsttable()["MASK_OPAQUE"]|getconsttable()["CONTENTS_IGNORE_NODRAW_OPAQUE"]) /**< everything that blocks line of sight for players */
getconsttable()["MASK_VISIBLE_AND_NPCS"] <-(getconsttable()["MASK_OPAQUE_AND_NPCS"]|getconsttable()["CONTENTS_IGNORE_NODRAW_OPAQUE"]) /**< everything that blocks line of sight for players, but with monsters added. */
getconsttable()["MASK_SHOT_HULL"] <-(getconsttable()["CONTENTS_SOLID"]|getconsttable()["CONTENTS_MOVEABLE"]|getconsttable()["CONTENTS_MONSTER"]|getconsttable()["CONTENTS_WINDOW"]|getconsttable()["CONTENTS_DEBRIS"]|getconsttable()["CONTENTS_GRATE"]) /**< non-raycasted weapons see this as solid (includes grates) */
getconsttable()["MASK_SHOT_PORTAL"] <-(getconsttable()["CONTENTS_SOLID"]|getconsttable()["CONTENTS_MOVEABLE"]|getconsttable()["CONTENTS_WINDOW"]) /**< hits solids (not grates) and passes through everything else */
getconsttable()["MASK_SOLID_BRUSHONLY"] <-(getconsttable()["CONTENTS_SOLID"]|getconsttable()["CONTENTS_MOVEABLE"]|getconsttable()["CONTENTS_WINDOW"]|getconsttable()["CONTENTS_GRATE"]) /**< everything normally solid, except monsters (world+brush only) */
getconsttable()["MASK_PLAYERSOLID_BRUSHONLY"] <-(getconsttable()["CONTENTS_SOLID"]|getconsttable()["CONTENTS_MOVEABLE"]|getconsttable()["CONTENTS_WINDOW"]|getconsttable()["CONTENTS_PLAYERCLIP"]|getconsttable()["CONTENTS_GRATE"]) /**< everything normally solid for player movement, except monsters (world+brush only) */
getconsttable()["MASK_NPCSOLID_BRUSHONLY"] <-(getconsttable()["CONTENTS_SOLID"]|getconsttable()["CONTENTS_MOVEABLE"]|getconsttable()["CONTENTS_WINDOW"]|getconsttable()["CONTENTS_MONSTERCLIP"]|getconsttable()["CONTENTS_GRATE"]) /**< everything normally solid for npc movement, except monsters (world+brush only) */
getconsttable()["MASK_NPCWORLDSTATIC"] <-(getconsttable()["CONTENTS_SOLID"]|getconsttable()["CONTENTS_WINDOW"]|getconsttable()["CONTENTS_MONSTERCLIP"]|getconsttable()["CONTENTS_GRATE"]) /**< just the world, used for route rebuilding */
getconsttable()["MASK_SPLITAREAPORTAL"] <-(getconsttable()["CONTENTS_WATER"]|getconsttable()["CONTENTS_SLIME"]) /**< These are things that can split areaportals */




/**
 * Returns true if the entity is valid or false otherwise.
 * Sometimes, just because an entity or edict exists doesn't mean that
 * it hasn't freed up or become invalidated. Luckily, you will rarely use
 * this function since VSLib uses it automatically.
 */
function VSLib::Entity::IsEntityValid()
{
	if (_ent == null)
		return false;
	
	if (!("IsValid" in _ent))
		return false;
	
	return _ent.IsValid();
}

/**
 * Gets the entity's real health.
 * If the entity is valid, the entity's health is returned; otherwise, null is returned.
 * The health includes any adrenaline or pill health.
 */
function VSLib::Entity::GetHealth()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local hp = _ent.GetHealth();
	if (IsPlayer())
		hp += _ent.GetHealthBuffer();
	
	return hp;
}

/**
 * Gets the entity's raw health.
 * If the entity is valid, the entity's health is returned; otherwise, null is returned.
 * Raw health does not include temporary health.
 */
function VSLib::Entity::GetRawHealth()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetHealth();
}

/**
 * Hurts the entity. Internal function. There should not be any need to use this directly.
 * @see Hurt, @see HurtAround, @see HurtTime instead
 */
function VSLib::Entity::__HurtInt__(value, dmgtype, weapon, attacker, radius, _hurtIntent, _hurtIgnore)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tointeger();
	dmgtype = dmgtype.tointeger();
	
	local spawn = { classname = "point_hurt", targetname = "vslib_tmp_" + UniqueString(), origin = GetLocation(), angles = QAngle(0,0,0), Damage = value, DamageType = dmgtype, DamageRadius = radius.tostring() };
	
	local point_hurt = g_ModeScript.CreateSingleSimpleEntityFromTable(spawn);
	
	// if the entity is not valid (e.g. entdata has reached the max), then try something else.
	if (!point_hurt)
	{
		Msg("Warning: Could not create point_hurt entity.");
		SetRawHealth(GetHealth() - value);
		return;
	}
	
	local vsHurt = ::VSLib.Entity(point_hurt);
	
	if(weapon != "")
		vsHurt.SetKeyValue("classname", weapon);
	
	if (!attacker)
		attacker = vsHurt;
	
	::VSLib.EntData._lastHurt = attacker.GetBaseEntity();
	::VSLib.EntData._hurtIntent = _hurtIntent;
	::VSLib.EntData._hurtDmg = value;
	::VSLib.EntData._hurtIgnore = _hurtIgnore;
	
	vsHurt.Input("Hurt", "", 0, attacker);
	vsHurt.SetKeyValue("classname", "point_hurt");
	
	vsHurt.Kill();
}

/**
 * Hurts the entity.
 *
 * @param value Amount of damage to inflict.
 * @param dmgtype The type of damage to inflict (e.g. DMG_GENERIC)
 * @param weapon The classname of the weapon (if set, the point hurt will "pretend" to be the weapon)
 * @param attacker If set, the damage will be done by the specified VSLib::Entity or VSLib::Player
 */
function VSLib::Entity::Hurt(value, dmgtype = 0, weapon = "", attacker = null, radius = 64.0)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	__HurtInt__(value, dmgtype, weapon, attacker, radius, _ent, []);
}

/**
 * Hurts AROUND the entity without hurting the entity itself.
 *
 * @param value Amount of damage to inflict.
 * @param dmgtype The type of damage to inflict (e.g. DMG_GENERIC)
 * @param weapon The classname of the weapon (if set, the point hurt will "pretend" to be the weapon)
 * @param attacker If set, the damage will be done by the specified VSLib::Entity or VSLib::Player
 */
function VSLib::Entity::HurtAround(value, dmgtype = 0, weapon = "", attacker = null, radius = 64.0, ignoreEntities = [])
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	ignoreEntities.push(this);
	__HurtInt__(value, dmgtype, weapon, attacker, radius, null, ignoreEntities);
}

/**
 * Damages the entity.
 */
function VSLib::Entity::Damage(value, dmgtype = 0)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tointeger();
	dmgtype = dmgtype.tointeger();
	
	local removeName = false;
	
	if ( _ent.GetName() == "" )
	{
		SetName("vslib_damage_tmp_" + GetBaseIndex());
		removeName = true;
	}
	
	local spawn = { targetname = "vslib_tmp_" + UniqueString(), Damage = value, DamageType = dmgtype, DamageRadius = "64.0", DamageTarget = _ent.GetName() };
	local vsDamage = ::VSLib.Utils.CreateEntity("point_hurt", GetLocation(), QAngle(0,0,0), spawn);
	
	vsDamage.Input("Hurt");
	vsDamage.Input("Kill");
	
	if ( removeName )
		Input("Addoutput", "targetname ");
}

/**
 * Fires a specific input
 */
function VSLib::Entity::Input(input, value = "", delay = 0, activator = null)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if (activator != null)
		DoEntFire("!self", input.tostring(), value.tostring(), delay.tofloat(), activator.GetBaseEntity(), _ent);
	else
		DoEntFire("!self", input.tostring(), value.tostring(), delay.tofloat(), null, _ent);
}

/**
 * Breaks the entity (if it is breakable)
 */
function VSLib::Entity::Break()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	Input("Break");
}

/**
 * Makes the entity become a ragdoll
 */
function VSLib::Entity::BecomeRagdoll()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local origin = GetLocation();
	local angles = GetAngles();
	
	local function VSLib_RagdollDeathModel( origin )
	{
		foreach ( death_model in Objects.OfClassnameWithin( "survivor_death_model", origin, 1 ) )
			death_model.Input( "BecomeRagdoll" );
	}
	
	if ( IsSurvivor() )
	{
		if ( GetTeam() == 4 )
		{
			Input( "Kill" );
			::VSLib.Utils.SpawnRagdoll( GetSurvivorModel(), origin, angles );
		}
		else
		{
			if ( IsAlive() )
				Kill();
			if ( Entities.FindByClassnameWithin( null, "survivor_death_model", origin, 1 ) )
				VSLib_RagdollDeathModel( origin );
			else
				::VSLib.Timers.AddTimer(0.1, false, VSLib_RagdollDeathModel, origin);
		}
	}
	else if ( GetTeam() == 3 )
		Input("BecomeRagdoll");
}

/**
 * Dispatches a keyvalue to the entity
 */
function VSLib::Entity::SetKeyValue(key, value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if (typeof value == "instance")
		_ent.__KeyValueFromVector(key.tostring(), value);
	else if (typeof value == "integer")
		_ent.__KeyValueFromInt(key.tostring(), value.tointeger());
	else
		_ent.__KeyValueFromString(key.tostring(), value.tostring());
}

/**
 * Same as Hurt(), except it keeps hurting for the specified time.
 * It hurts at the specified interval for the specified time.
 */
function VSLib::Entity::HurtTime(value, dmgtype, interval, time, weapon = "", attacker = null, radius = 64.0)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tointeger();
	dmgtype = dmgtype.tointeger();
	time = time.tofloat();
	interval = interval.tofloat();
	
	::VSLib.Timers.AddTimer( interval, true, @(params) params.player.Hurt(params.val, params.dmgt, params.wep, params.activator, params.rad), { player = this, val = value, dmgt = dmgtype, wep = weapon, activator = attacker, rad = radius }, TIMER_FLAG_DURATION, { duration = time } );
}

/**
 * Same as Damage(), except it keeps damaging for the specified time.
 * It damages at the specified interval for the specified time.
 */
function VSLib::Entity::DamageTime(value, dmgtype, interval, time)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tointeger();
	dmgtype = dmgtype.tointeger();
	time = time.tofloat();
	interval = interval.tofloat();
	
	::VSLib.Timers.AddTimer( interval, true, @(params) params.player.Damage(params.val, params.dmgt), { player = this, val = value, dmgt = dmgtype }, TIMER_FLAG_DURATION, { duration = time } );
}

/**
 * Sets the entity's raw health.
 * If the entity is valid, the entity's health is set.
 * Setting raw health removes any existing temp health.
 */
function VSLib::Entity::SetRawHealth(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.SetHealth(value.tointeger());
}

/**
 * Sets the entity's health.
 * If the entity is valid, the entity's health is set.
 * This will also incapacitate the player if the input value is
 * less than or equal to 0.
 */
function VSLib::Entity::SetHealth(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tointeger();
	
	local hp = GetHealth();
	if ( IsPlayer() )
		Input("SetHealth", value);
	else
	{
		if (value <= 0)
		{
			SetRawHealth(0);
			Hurt(1, (1 << 2));
		}
		else if (value < hp)
			Hurt(hp - value, 0);
		else
			SetRawHealth(value);
	}
}

/**
 * Sets the entity's maximum possible health without modifying the entity's current health.
 * If the entity is valid, the entity's max health is set.
 */
function VSLib::Entity::SetMaxHealth(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
		
	value = value.tointeger();
	
	_ent.__KeyValueFromInt("max_health", value);
}

/**
 * Increases the entity's health by the value entered.
 */
function VSLib::Entity::IncreaseHealth(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.SetHealth(_ent.GetHealth() + value.tointeger());
}

/**
 * Decreases the entity's health by the value entered.
 */
function VSLib::Entity::DecreaseHealth(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.SetHealth(_ent.GetHealth() - value.tointeger());
}

/**
 * Vomits on the Entity
 */
function VSLib::Entity::Vomit()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if ("HitWithVomit" in _ent)
		_ent.HitWithVomit();
}

/**
 * Gets the entity's classname.
 * If the entity is valid, the entity's class is returned; otherwise, null is returned.
 * For example, "prop_dynamic" or "weapon_rifle_ak47"
 */
function VSLib::Entity::GetClassname()
{
	if (!IsEntityValid())
		return null;
	
	return _ent.GetClassname();
}

/**
 * Sets the entity's global name.
 * If the entity is valid, the global name of the entity is set. The global name
 * of the entity corresponds to the "Global Name" field of the entity in the Property
 * Window in Hammer. Global entities may carry over onto future maps in a campaign,
 * so setting an entity's global name may be helpful in certain situations.
 */
function VSLib::Entity::SetGlobalName(name)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	name = name.tostring();
	
	_ent.__KeyValueFromString("globalname", name);
}

/**
 * Sets the entity's parent name.
 * If the entity is valid, the name of the entity is set. Note that this function does
 * NOT parent an entity; only the parent's targetname is set. This is equivalent to setting
 * the "Parent" field in Hammer.
 */
function VSLib::Entity::SetParentName(name)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	name = name.tostring();
	
	_ent.__KeyValueFromString("parentname", name);
}

/**
 * Sets the entity's name.
 */
function VSLib::Entity::SetName(name)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	name = name.tostring();
	
	_ent.__KeyValueFromString("targetname", name);
}

/**
 * Sets the entity's speed.
 * If the entity is valid, the speed of the entity is set.
 * The speed cannot be set for player entities.
 */
function VSLib::Entity::SetSpeed(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tostring();
	_ent.__KeyValueFromString("speed", value);
}

/**
 * Sets the entity's render effect.
 * The entity can be given a special effect (like fading, pulsing, etc).
 * If the entity is valid, the render effect is set. Here are the possible values:
 * 	0 -> No effect
 * 	1 -> Slow pulse
 * 	2 -> Fast pulse
 * 	3 -> Slow, wide pulse
 * 	4 -> Fast, wide pulse
 * 	5 -> Slow fade
 * 	6 -> Fast fade
 * 	7 -> Slow solidify (no you can't make ice)
 * 	8 -> Fast solidify
 * 	9 -> Slow strobe
 * 	10 -> Fast strobe
 * 	11 -> Strobe even faster
 * 	12 -> Slow flicker
 * 	13 -> Fast flicker
 * 	14 -> No dissipation
 * 	15 -> Distort entity
 * 	16 -> Hologram effect
 * 	17 -> Super scale; become huge
 * 	18 -> Glowing shell
 * 	19 -> Clamp sprite (prevents sprites from getting smaller when increasing disatance)
 * 	20 -> Rain effect (for environments)
 * 	21 -> Snow effect (for environments again)
 * 	22 -> Valve's experimental spotlight effect
 * 	23 -> Ragdoll effect
 * 	24 -> Pulse faster and wider (dunno why Valve put the value all the way down here)
 */
function VSLib::Entity::SetRenderEffects(value)
{
	if (_ent == null)
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
		
	value = value.tointeger();
	
	_ent.__KeyValueFromInt("renderfx", value);
}

/**
 * Sets the entity's render mode.
 * The render mode allows you to change how an entity should render. With specific values,
 * you can make entities invisible, change the object's buffer checks, blending, and more.
 * Here are the possible values:
 * 	0 -> Normal (no render mode modification)
 * 	1 -> Transcolor
 * 	2 -> Transtexture
 * 	3 -> Glow
 * 	4 -> Transalpha
 * 	5 -> Transadd
 * 	6 -> Environmental
 * 	7 -> Transadd Frame Blend
 * 	8 -> Transalpha add
 * 	9 -> World glow
 * 	10 -> Rend None
 */
function VSLib::Entity::SetRenderMode(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tointeger();
	
	_ent.__KeyValueFromInt("rendermode", value);
}

/**
 * Sets the entity's next Think time.
 * To be totally honest, I can't think of a reason for this function.
 * Provided just for those who may need it. \todo @TODO This may or may not
 * work, provided that the KV field is FIELD_TICK.
 */
function VSLib::Entity::SetNextThinkTime(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tointeger();
	
	_ent.__KeyValueFromInt("nextthink", value);
}

/**
 * Sets the entity's secondary effects.
 * Depending on the value, effects like light projection (i.e. flashlight)
 * can be enabled and disabled (for player entities). See Player class
 * for a function already made for that purpose.
 */
function VSLib::Entity::SetEffects(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tointeger();
	
	_ent.__KeyValueFromInt("effects", value);
}

/**
 * Sets the entity's render color.
 * Changes the overall color of the entity. For example, a value of (255, 0, 0, 255)
 * will give the entity a red hue. The alpha property really doesn't affect much unless
 * the render mode also changes. If you are looking to change the visibility, use
 * Entity.SetVisible() instead.
 */
function VSLib::Entity::SetColor(red, green, blue, alpha)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.__KeyValueFromString("rendercolor", red + " " + green + " " + blue + " " + alpha);
}

/**
 * Changes the entity's visibility.
 * If the visible parameter is true, the entity will become visible to all players.
 * If the visible paramater is false, the entity will become invisible to all players.
 */
function VSLib::Entity::SetVisible(canSee)
{
	local visible = (canSee.tointeger() > 0) ? true : false;
	
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if (visible)
	{
		SetRenderMode(0); // Render mode: normal
		SetColor(255, 255, 255, 255); // Default hue.
	}
	else
	{
		SetRenderMode(1); // Render mode: transcolor
		SetColor(0, 0, 0, 0); // zero all values for color
	}
}

/**
 * Sets the entity's model index.
 * If the entity has more than one model associated with it (i.e. it has more than one
 * model index), then you can instantly change the model index with this function. This
 * function is useful for those who would like to have an entity have more than one model.
 * \todo @TODO verify that global keyfields can be modified with Valve's __KeyValueFromInt()
 */
function VSLib::Entity::SetModelIndex(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
		
	value = value.tointeger();
	
	_ent.__KeyValueFromInt("modelindex", value);
}

/**
 * Sets the entity's response context.
 * This function deals more with AI criteria sets and dispatching responses.
 * Practically useless for what we do, since the entity would need to be
 * re-activated and there's no plausible way to do that via VScripts.
 * If your mod needs to deal with m_iszResponseContext, use another scripting
 * engine like HammerCode or SourceMod.
 */
function VSLib::Entity::SetResponseContext(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tostring();
	
	_ent.__KeyValueFromString("ResponseContext", value);
}

/**
 * Sets the m_target netprop of the entity.
 * Provided for completeness, but the function doesn't seem to do much on L4D2.
 * The prop has taken a back seat to m_iName from the looks of it.
 */
function VSLib::Entity::SetTarget(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tostring();
	
	_ent.__KeyValueFromString("target", value);
}

/**
 * Sets the damage filter name of the entity.
 * Provided for completeness. This function sets the m_iszDamageFilterName KV,
 * which is later used in InputSetDamageFilter() in the c++ backend to
 * find the name stored in m_iszDamageFilterName to set m_hDamageFilter, which is
 * later used in PassesDamageFilter() to see if the CTakeDamageInfo object passes
 * the damage filter. In simple terms, this function is as good as useless for us.
 */
function VSLib::Entity::SetDamageFilter(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tostring();
	
	_ent.__KeyValueFromString("damagefilter", value);
}

/**
 * Sets the shadow cast distance.
 * I honestly cannot think of any good use for this, unless you want to change the
 * shadow distance over time or something. Granted, it may not even work. Provided
 * for completeness.
 */
function VSLib::Entity::SetShadowCastDistance(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tostring();
	
	_ent.__KeyValueFromString("shadowcastdist", value);
}

/**
 * Applies an absolute velocity impulse to an entity.
 * An impulse is given to the entity. In this function, by setting a value negative
 * to an entity's trajectory, the entity may or may not change paths depending on the
 * scalar value of the vector. All we are doing is "pushing" an entity in the given
 * direction. The higher the dimensional value, the stronger the "push" (to put it
 * very simply). There are a lot of uses for this function.
 */
function VSLib::Entity::Push(vec)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.ApplyAbsVelocityImpulse(vec);
}

/**
 * Applies an angular velocity impulse to an entity.
 * Using this function, we can make physics props spin around or rotate.
 */
function VSLib::Entity::Spin(vec)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.ApplyLocalAngularVelocityImpulse(vec);
}

/**
 * Sets the entity's gravity.
 */
function VSLib::Entity::SetGravity(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tostring();
	
	_ent.__KeyValueFromString("gravity", value);
}

/**
 * Sets the entity's friction.
 */
function VSLib::Entity::SetFriction(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	value = value.tostring();
	
	_ent.__KeyValueFromString("friction", value);
}

/**
 * Overrides the entity's friction for the desired duration.
 */
function VSLib::Entity::OverrideFriction(duration, friction)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.OverrideFriction(duration, friction);
}

/**
 * Precaches a model.
 */
function VSLib::Entity::PrecacheModel(mdl)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.PrecacheModel(mdl);
}

/**
 * Precaches a scripted sound.
 */
function VSLib::Entity::PrecacheScriptSound(sound)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.PrecacheScriptSound(sound);
}

/**
 * Returns the entity's forward vector.
 */
function VSLib::Entity::GetForwardVector()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetForwardVector();
}

/**
 * Sets the orientation of the entity to have this forward vector.
 */
function VSLib::Entity::SetForwardVector(direction)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.SetForwardVector(direction);
}

/**
 * Returns the entity's base velocity vector.
 */
function VSLib::Entity::GetBaseVelocity()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetBaseVelocity();
}

/**
 * Returns the entity's angular velocity.
 */
function VSLib::Entity::GetLocalAngularVelocity()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetLocalAngularVelocity();
}

/**
 * Returns the entity's relative velocity vector.
 */
function VSLib::Entity::GetLocalVelocity()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetLocalVelocity();
}

/**
 * Returns the entity's current velocity vector.
 */
function VSLib::Entity::GetVelocity()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetVelocity();
}

/**
 * Sets the entity's current velocity vector.
 * This can be used to force an entity to move in a particular direction.
 */
function VSLib::Entity::SetVelocity(vec)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.SetVelocity(vec);
}

/**
 * Sets the entity's current velocity vector KV.
 */
function VSLib::Entity::SetVelocityKV(vec)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	SetKeyValue("velocity", vec);
}

/**
 * Sets the entity's current base velocity vector KV.
 */
function VSLib::Entity::SetBaseVelocity(vec)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	SetKeyValue("basevelocity", vec);
}

/**
 * Sets the entity's current angular velocity vector KV.
 */
function VSLib::Entity::SetAngularVelocity(vec)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	SetKeyValue("avelocity", vec);
}

/**
 * Sets the entity's current water level.
 */
function VSLib::Entity::SetWaterLevel(lvl)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	SetKeyValue("waterlevel", lvl.tostring());
}

/**
 * Sets the entity's spawn flags.
 */
function VSLib::Entity::SetSpawnFlags(flags)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	SetKeyValue("spawnflags", flags.tostring());
}

/**
 * Gets the direction that the entity's eyes are facing.
 */
function VSLib::Entity::GetEyeAngles()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if (!("EyeAngles" in _ent))
	{
		printl("VSLib Warning: Entity " + _idx + " does not have Eye Angles.");
		return;
	}
	
	return _ent.EyeAngles();
}

/**
 * Returns the base entity (in case you need to access Valve's CBaseEntity/CBaseAnimating functions manually)
 */
function VSLib::Entity::GetBaseEntity()
{
	return _ent;
}

/**
 * Returns the initial index or name passed to the entity.
 */
function VSLib::Entity::GetIndex()
{
	return _idx;
}

/**
 * Gets the entity's current location.
 */
function VSLib::Entity::GetLocation()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetOrigin();
}

/**
 * Sets the entity's current location vector (i.e. teleports the entity).
 */
function VSLib::Entity::SetLocation(vec)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.SetOrigin(vec);
}

/**
 * Sets the entity's current position (basically calls SetLocation() internally).
 */
function VSLib::Entity::SetPosition(x, y, z)
{
	SetLocation( Vector(x, y, z) );
}

/**
 * Gets the entity's current position (basically calls GetLocation() internally).
 */
function VSLib::Entity::GetPosition()
{
	return GetLocation();
}

/**
 * Does the same thing as SetLocation() in that it teleports the entity.
 * Internally the function just calls SetLocation(). Provided for simplicity,
 * as a lot of mappers seem to have difficulty understanding various terms.
 */
function VSLib::Entity::Teleport(vec)
{
	SetLocation(vec);
}

/**
 * Teleports the entity to another ::VSLib.Entity.
 */
function VSLib::Entity::TeleportTo(otherEntity)
{
	Teleport(otherEntity.GetLocation());
}

/**
 * Tries to guess what team the player might be on.
 * Returns either INFECTED, SURVIVORS or L4D1_SURVIVORS.
 */
function VSLib::Entity::GetTeam()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if ( _ent.GetClassname() == "infected" )
		return INFECTED;
	else if ( _ent.GetClassname() == "player" )
	{
		if (!("GetZombieType" in _ent))
			return UNKNOWN;
		else if (_ent.IsSurvivor() || _ent.GetZombieType() == Z_SURVIVOR)
		{
			if ( ::VSLib.Utils.GetSurvivorSet() == 2 && ( GetTargetname() == "!bill" || GetTargetname() == "!francis" || GetTargetname() == "!louis" || GetTargetname() == "!zoey" ) )
				return L4D1_SURVIVORS;
			else
				return SURVIVORS;
		}
		else if ((_ent.GetZombieType() > 0 && _ent.GetZombieType() < 9) || _ent.IsGhost())
			return INFECTED;
	}
	
	return UNKNOWN;
}

/**
 * Returns the type of entity. E.g. Z_SPITTER, Z_TANK, Z_SURVIVOR, Z_HUNTER, Z_JOCKEY, Z_SMOKER, Z_BOOMER, Z_CHARGER, Z_COMMON, or Z_WITCH.
 */
function VSLib::Entity::GetType()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if ( _ent.GetClassname() == "infected" )
		return Z_COMMON;
	else if ( _ent.GetClassname() == "witch" )
		return Z_WITCH;
	else if ( _ent.GetClassname() == "player" )
	{
		if (!("GetZombieType" in _ent))
			return;
		
		return _ent.GetZombieType();
	}
	
	return;
}

/**
 * Returns the inventory slot the weapon uses.
 */
function VSLib::Entity::GetWeaponSlot()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local WeaponNames =
	{
		weapon_smg = SLOT_PRIMARY,
		weapon_smg_silenced = SLOT_PRIMARY,
		weapon_smg_mp5 = SLOT_PRIMARY,
		weapon_pumpshotgun = SLOT_PRIMARY,
		weapon_shotgun_chrome = SLOT_PRIMARY,
		weapon_rifle = SLOT_PRIMARY,
		weapon_rifle_ak47 = SLOT_PRIMARY,
		weapon_rifle_desert = SLOT_PRIMARY,
		weapon_rifle_sg552 = SLOT_PRIMARY,
		weapon_rifle_m60 = SLOT_PRIMARY,
		weapon_autoshotgun = SLOT_PRIMARY,
		weapon_shotgun_spas = SLOT_PRIMARY,
		weapon_hunting_rifle = SLOT_PRIMARY,
		weapon_sniper_military = SLOT_PRIMARY,
		weapon_sniper_awp = SLOT_PRIMARY,
		weapon_sniper_scout = SLOT_PRIMARY,
		weapon_grenade_launcher = SLOT_PRIMARY,
		weapon_pistol = SLOT_SECONDARY,
		weapon_pistol_magnum = SLOT_SECONDARY,
		weapon_melee = SLOT_SECONDARY,
		weapon_chainsaw = SLOT_SECONDARY,
		weapon_pipe_bomb = SLOT_THROW,
		weapon_molotov = SLOT_THROW,
		weapon_vomitjar = SLOT_THROW,
		weapon_first_aid_kit = SLOT_MEDKIT,
		weapon_defibrillator = SLOT_MEDKIT,
		weapon_upgradepack_incendiary = SLOT_MEDKIT,
		weapon_upgradepack_explosive = SLOT_MEDKIT,
		weapon_pain_pills = SLOT_PILLS,
		weapon_adrenaline = SLOT_PILLS,
		weapon_gascan = SLOT_CARRIED,
		weapon_propanetank = SLOT_CARRIED,
		weapon_oxygentank = SLOT_CARRIED,
		weapon_gnome = SLOT_CARRIED,
		weapon_cola_bottles = SLOT_CARRIED,
		weapon_fireworkcrate = SLOT_CARRIED,
	}
	
	if ( _ent.GetClassname().find("weapon_") != null )
	{
		foreach( weapon, slot in WeaponNames )
		{
			foreach( wep in Objects.OfClassname(weapon) )
			{
				if ( wep.GetClassname() == _ent.GetClassname() )
					return slot;
			}
		}
		return;
	}
	
	return;
}

/**
 * Returns the gender of the infected.
 */
function VSLib::Entity::GetGender()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local InfectedModels =
	{
		common_male_ceda = MALE,
		common_male_mud = MALE,
		common_male_roadcrew = MALE,
		common_male_roadcrew_rain = MALE,
		common_male_fallen_survivor = MALE,
		common_male_riot = MALE,
		common_male_clown = MALE,
		common_male_jimmy = MALE,
		common_male_tshirt_cargos = MALE,
		common_male_tankTop_jeans = MALE,
		common_male_dressShirt_jeans = MALE,
		common_female_tankTop_jeans = FEMALE,
		common_female_tshirt_skirt = FEMALE,
		common_male_tankTop_overalls = MALE,
		common_male_tankTop_jeans_rain = MALE,
		common_female_tankTop_jeans_rain = FEMALE,
		common_male_tankTop_overalls_rain = MALE,
		common_male_tshirt_cargos_swamp = MALE,
		common_male_tankTop_overalls_swamp = MALE,
		common_female_tshirt_skirt_swamp = FEMALE,
		common_male_polo_jeans = MALE,
		common_male_formal = MALE,
		common_female_formal = FEMALE,
		common_male_biker = MALE,
		common_patient_male01_l4d2 = MALE,
		common_male01 = MALE,
		common_female01 = FEMALE,
		common_police_male01 = MALE,
		common_military_male01 = MALE,
		common_worker_male01 = MALE,
		common_male_suit = MALE,
		common_patient_male01 = MALE,
		common_female_nurse01 = FEMALE,
		common_surgeon_male01 = MALE,
		common_male_baggagehandler_01 = MALE,
		common_tsaagent_male01 = MALE,
		common_male_pilot = MALE,
		common_male_rural01 = MALE,
		common_female_rural01 = FEMALE,
	}
	
	if ( _ent.GetClassname() == "infected" )
	{
		foreach( model, gender in InfectedModels )
		{
			foreach( infected in Objects.OfModel("models/infected/" + model + ".mdl") )
			{
				if ( infected.GetEntityHandle() == _ent.GetEntityHandle() )
					return gender;
			}
		}
		return UNKNOWN;
	}
	
	return;
}

/**
 * Returns the type of uncommon infected.
 */
function VSLib::Entity::GetUncommonInfected()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local UncommonModels =
	{
		common_male_ceda = Z_CEDA,
		common_male_mud = Z_MUD,
		common_male_roadcrew = Z_ROADCREW,
		common_male_roadcrew_rain = Z_ROADCREW,
		common_male_fallen_survivor = Z_FALLEN,
		common_male_riot = Z_RIOT,
		common_male_clown = Z_CLOWN,
		common_male_jimmy = Z_JIMMY,
	}
	
	if ( _ent.GetClassname() == "infected" )
	{
		foreach( model, zombie in UncommonModels )
		{
			foreach( uncommon in Objects.OfModel("models/infected/" + model + ".mdl") )
			{
				if ( uncommon.GetEntityHandle() == _ent.GetEntityHandle() )
					return zombie;
			}
		}
		return Z_COMMON;
	}
	
	return;
}

/**
 * Gets the zombie's name
 */
function VSLib::Entity::GetZombieName()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if ( _ent.GetClassname() == "infected" )
		return "Infected";
	else if ( _ent.GetClassname() == "witch" )
	{
		if ( IsWitchBride() )
			return "Witch Bride";
		else
			return "Witch";
	}
	else if ( _ent.GetClassname() == "player" )
	{
		if (!("GetZombieType" in _ent))
			return;
		
		if ( _ent.GetZombieType() == Z_SMOKER )
			return "Smoker";
		else if ( _ent.GetZombieType() == Z_BOOMER )
			return "Boomer";
		else if ( _ent.GetZombieType() == Z_HUNTER )
			return "Hunter";
		else if ( _ent.GetZombieType() == Z_SPITTER )
			return "Spitter";
		else if ( _ent.GetZombieType() == Z_JOCKEY )
			return "Jockey";
		else if ( _ent.GetZombieType() == Z_CHARGER )
			return "Charger";
		else if ( _ent.GetZombieType() == Z_TANK )
			return "Tank";
		else if ( _ent.GetZombieType() == Z_SURVIVOR )
			return "Survivor";
	}
	
	return;
}

/**
 * Kills common infected and witches, and removes other entities from the map.
 */
function VSLib::Entity::Kill()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if ( _ent.GetClassname() == "infected" || _ent.GetClassname() == "witch" )
	{
		Damage(GetHealth());
	}
	else
		Input("Kill");
}

/**
 * Alternative method to kill/remove the entity from the map.
 */
function VSLib::Entity::KillEntity()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.Kill();
}

/**
 * Returns the base angles.
 */
function VSLib::Entity::GetAngles()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetAngles();
}

/**
 * Sets the base angles.
 */
function VSLib::Entity::SetAngles(x, y, z)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.SetAngles(QAngle(x,y,z));
}

/**
 * Sets the base angles.
 *
 * @authors shotgunefx
 */
function VSLib::Entity::SetAnglesFrom(ent)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.SetAngles(ent.GetAngles());
}

/**
 * Sets the base angles via vector.
 * @authors shotgunefx
 */
function VSLib::Entity::SetAnglesVec(vec)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.SetAngles(vec);
}

/**
 * Sets the base angles via QAngle.
 * @authors shotgunefx
 */
function VSLib::Entity::SetAnglesFromQAngle(qangle)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.SetAngles(qangle);
}

/**
 * Kills/removes the entity and associated entities from the map.
 */
function VSLib::Entity::KillHierarchy()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	DoEntFire("!self", "KillHierarchy", "", 0, null, _ent);
}

/**
 * Attempts to "Use" or pick up another entity.
 */
function VSLib::Entity::Use(otherEntity)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	DoEntFire("!self", "Use", "", 0, _ent, otherEntity.GetBaseEntity());
}

/**
 * Attempts to "Use" or pick up another entity.
 */
function VSLib::Entity::UseOther(otherEntity)
{
	Use(otherEntity);
}

/**
 * Attempts to be "used" or picked up BY another entity.
 */
function VSLib::Entity::UsedByOther(otherEntity)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	DoEntFire("!self", "Use", "", 0, otherEntity.GetBaseEntity(), _ent);
}

/**
 * Set the alpha value of the entity.
 * Only seems to work for players.
 */
function VSLib::Entity::SetAlpha(value)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	DoEntFire("!self", "Alpha", value.tostring(), 0, null, _ent);
}

/**
 * Inputs a color to an entity. This is an alternative to SetColor().
 */
function VSLib::Entity::InputColor(red, green, blue)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	DoEntFire("!self", "Color", red + " " + green + " " + blue, 0, null, _ent);
}

/**
 * Parents an entity to this entity.
 * In other words, attaches an entity to this entity. Cool for attaching bumper cars
 * or other objects to players. If teleportOther is TRUE, the other entity is teleported
 * to this entity. If it is FALSE, the entity is parented without teleporting.
 *
 * @authors shotgunefx - added optional delay for teleporting
 */
function VSLib::Entity::AttachOther(otherEntity, teleportOther, delay = 0)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	teleportOther = (teleportOther.tointeger() > 0) ? true : false;
	
	if (teleportOther)
		otherEntity.SetLocation(GetLocation());
	
	DoEntFire("!self", "SetParent", "!activator", delay, _ent, otherEntity.GetBaseEntity());
}

/**
 * Attaches another entity to a specific point.
 * Call this function after AttachOther() to parent at a specific attachment point. For example,
 * if attachment equals "rhand", the object will be attached to the player's or entity's
 * right hand. "forward" to attach to head etc. Search for player or entity attachment points
 * on Google (i.e. "L4D2 survivor attachment points" or something along those lines).
 * If ShouldMaintainOffset is true, then the initial distance between the object is maintained,
 * and the angles usually point in the direction of the parent.
 *
 * @authors shotgunefx - added optional delay
 */
function VSLib::Entity::SetAttachmentPoint(otherEntity, attachment, bShouldMaintainOffset, delay = 0)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	attachment = attachment.tostring();
	bShouldMaintainOffset = (bShouldMaintainOffset.tointeger() > 0) ? true : false;
	
	if (bShouldMaintainOffset)
		DoEntFire("!self", "SetParentAttachmentMaintainOffset", attachment, delay, _ent, otherEntity.GetBaseEntity());
	else
		DoEntFire("!self", "SetParentAttachment", attachment, delay, _ent, otherEntity.GetBaseEntity());
}

/**
 * Remove the parenting.
 *
 * @authors shotgunefx - edit: added optional delay
 */
function VSLib::Entity::RemoveAttached(otherEntity, delay = 0)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	DoEntFire("!self", "ClearParent", "", delay, _ent, otherEntity.GetBaseEntity());
}

/**
 * Get move parent
 *
 * @authors shotgunefx 
 */
function VSLib::Entity::GetParent()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return ::VSLib.Entity(GetBaseEntity().GetMoveParent());
}

/**
 * Estimates the eye position.
 */
function VSLib::Entity::GetEyePosition()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	//// 5/21 EMS update
	// If the entity has an eyeposition function, return it.
	if ("EyePosition" in _ent)
		return _ent.EyePosition();
	
	// if it's not a player, it probably doesn't have eyes...
	return GetLocation();
}

/**
 * Gets the entity that this entity is pointing at, or null if this entity is not pointing at a valid entity.
 * This is useful for things like detecting what entity a player may be looking at.
 *
 * @authors shotgunefx, added optional track mask
 */
function VSLib::Entity::GetLookingEntity(mask = TRACE_MASK_VISIBLE_AND_NPCS)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if (!("EyeAngles" in _ent))
	{
		printl("VSLib Warning: Entity " + _idx + " does not have Eye Angles.");
		return;
	}
	
	local startPt = GetEyePosition();
	local endPt = startPt + _ent.EyeAngles().Forward().Scale(999999);
	
	local m_trace = { start = startPt, end = endPt, ignore = _ent, mask = mask };
	TraceLine(m_trace);
	
	if (!m_trace.hit || m_trace.enthit == null || m_trace.enthit == _ent)
		return null;
	
	if (m_trace.enthit.GetClassname() == "worldspawn" || !m_trace.enthit.IsValid())
		return null;
	
	return ::VSLib.Utils.GetEntityOrPlayer(m_trace.enthit);
}

/**
 * Returns the numerical index of the entity.
 * Because Valve didn't provide a function to convert a base entity back to an index,
 * we go the long way around by using an entity loop.
 */
function VSLib::Entity::GetBaseIndex()
{
	if (_ent == null)
	{
		printl("VSLib Warning: Entity is invalid.");
		return -1;
	}
	
	// After the 5/21 EMS update, we now have GetEntityIndex()
	return _ent.GetEntityIndex();
	
	// No longer needed
	/*
	for (local i = 1; i <= 2048; i++)	
		if (_ent == Ent(i))
			return i;
	
	return -1;
	*/
}

/**
 * Kills the entity after the specified delay in seconds; fractions may be used if needed (e.g. 1.5 seconds).
 */
function VSLib::Entity::KillDelayed(seconds)
{
	if (_ent == null)
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	seconds = seconds.tofloat();
	
	DoEntFire("!self", "Kill", "", seconds, null, _ent);
}

/**
 * Returns whether one ent is behind another
 * @authors shotgunefx
 */
function VSLib::Entity::IsBehind(otherEnt)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	local fwd = otherEnt.GetAngles().Forward()
	local o1 = _ent.GetOrigin();
	local o2 = otherEnt.GetLocation();
	local product = (o1["x"] - o2["x"]) * fwd["x"] + (o1["y"] - o2["y"]) * fwd["y"] + (o1["z"] - o2["z"]) * fwd["z"];
	if (product > 0.0)
		return false;
	else 
		return true;
}

/**
 * Returns whether one ent is in front of another
 * @authors shotgunefx
 */
function VSLib::Entity::IsInFront(otherEnt)
{
    return !IsBehind(otherEnt);
}

/**
 * Returns a vector position of where the entity is looking.
 */
function VSLib::Entity::GetLookingLocation()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if (!("EyeAngles" in _ent))
	{
		printl("VSLib Warning: Entity " + _idx + " does not have Eye Angles.");
		return;
	}
	
	local startPt = GetEyePosition();
	local endPt = startPt + _ent.EyeAngles().Forward().Scale(999999);
	
	local m_trace = { start = startPt, end = endPt, ignore = _ent, mask = TRACE_MASK_SHOT };
	TraceLine(m_trace);
	
	if (!m_trace.hit || m_trace.enthit == _ent)
		return null;
	
	return m_trace.pos;
}

/**
 * Ignites the entity for the specified time. Fractions can be used (e.g. 1.5 seconds).
 */
function VSLib::Entity::Ignite(time)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	time = time.tostring();
	
	HurtTime(1, 2056, 0.3, time);
	DoEntFire("!self", "IgniteLifetime", time, 0, null, _ent);
}

/**
 * Attaches a particle to this entity.
 * E.g. "gas_fireball" or "elevatorsparks". Internally spawns an
 * info_particle_system, so all effects that can be shown with that
 * entity can be shown with this function. This function will return the
 * particle system that was created, so if you need to attach it to a
 * specific attachment point or whatever, you can.
 */
function VSLib::Entity::AttachParticle(particleName, duration)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	particleName = particleName.tostring();
	duration = duration.tofloat();
	
	local particle = g_ModeScript.CreateSingleSimpleEntityFromTable({ classname = "info_particle_system", targetname = "vslib_tmp_" + UniqueString(), origin = GetLocation(), angles = QAngle(0,0,0), start_active = true, effect_name = particleName });
	
	if (!particle)
	{
		Msg("Warning: Could not create info_particle_system entity.");
		return;
	}
	
	DoEntFire("!self", "Start", "", 0, null, particle);
	
	local vsParticle = ::VSLib.Entity(particle);
	
	vsParticle.KillDelayed(duration);
	AttachOther(vsParticle, true);
	
	return vsParticle;
}

/**
 * Returns true if the entity is a player.
 */
function VSLib::Entity::IsPlayer()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	if ("IsPlayer" in _ent)
		return _ent.IsPlayer();
	
	return "player" == _ent.GetClassname().tolower();
}

/**
 * Returns true if the player is on the survivor team (Otherwise, infected).
 */
function VSLib::Entity::IsSurvivor()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	if (!IsPlayer())
		return false;
	
	return _ent.IsSurvivor();
}

/**
 * Returns true if the entity is alive.
 * For players, once a player dies, it still reports alive. Use Player class for IsAlive().
 */
function VSLib::Entity::IsAlive()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return GetHealth() > 0;
}

/**
 * Returns the name of the entity.
 */
function VSLib::Entity::GetName()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetName();
}

/**
 * Returns the targetname of the entity.
 */
function VSLib::Entity::GetTargetname()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	local SurvivorNames =
	[
		"!coach"
		"!ellis"
		"!nick"
		"!rochelle"
		"!bill"
		"!francis"
		"!louis"
		"!zoey"
	]
	
	if ( IsPlayer() && GetType() == Z_SURVIVOR )
	{
		foreach( name in SurvivorNames )
		{
			foreach( survivor in Objects.OfName(name) )
			{
				if ( survivor.GetEntityHandle() == _ent.GetEntityHandle() )
					return name;
			}
		}
		
		if ( IsBot() )
		{
			if ( ::VSLib.Utils.GetSurvivorSet() == 1 )
			{
				if ( GetName().find("Bill") != null || GetName().find("Nick") != null )
					return "!nick";
				else if ( GetName().find("Francis") != null || GetName().find("Ellis") != null )
					return "!ellis";
				else if ( GetName().find("Louis") != null || GetName().find("Coach") != null )
					return "!coach";
				else if ( GetName().find("Zoey") != null || GetName().find("Rochelle") != null )
					return "!rochelle";
			}
			else
			{
				if ( GetName().find("Coach") != null )
					return "!coach";
				else if ( GetName().find("Ellis") != null )
					return "!ellis";
				else if ( GetName().find("Nick") != null )
					return "!nick";
				else if ( GetName().find("Rochelle") != null )
					return "!rochelle";
				else if ( GetName().find("Bill") != null )
					return "!bill";
				else if ( GetName().find("Francis") != null )
					return "!francis";
				else if ( GetName().find("Louis") != null )
					return "!louis";
				else if ( GetName().find("Zoey") != null )
					return "!zoey";
			}
		}
	}
	
	return _ent.GetName();
}

/**
 * Gets the actor name of the entity.
 */
function VSLib::Entity::GetActorName()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return "";
	}
	
	if ( _ent.GetClassname() == "infected" )
	{
		if ( IsUncommonInfected() )
		{
			if ( GetUncommonInfected() == Z_CEDA )
				return "Ceda";
			else if ( GetUncommonInfected() == Z_MUD )
				return "Crawler";
			else if ( GetUncommonInfected() == Z_ROADCREW )
				return "Undistractable";
			else if ( GetUncommonInfected() == Z_FALLEN )
				return "Fallen";
			else if ( GetUncommonInfected() == Z_RIOT )
				return "riot_control";
			else if ( GetUncommonInfected() == Z_CLOWN )
				return "Clown";
			else if ( GetUncommonInfected() == Z_JIMMY )
				return "Jimmy";
		}
		else
			return "Common";
	}
	else if ( _ent.GetClassname() == "witch" )
		return "Witch";
	else if ( _ent.GetClassname() == "player" )
	{
		if ( GetType() == Z_SURVIVOR )
		{
			if ( ::VSLib.Utils.GetSurvivorSet() == 1 )
			{
				if ( GetTargetname() == "!coach" )
					return "Manager";
				else if ( GetTargetname() == "!ellis" )
					return "Biker";
				else if ( GetTargetname() == "!nick" )
					return "NamVet";
				else if ( GetTargetname() == "!rochelle" )
					return "TeenGirl";
			}
			else
			{
				if ( GetTargetname() == "!coach" )
					return "Coach";
				else if ( GetTargetname() == "!ellis" )
					return "Mechanic";
				else if ( GetTargetname() == "!nick" )
					return "Gambler";
				else if ( GetTargetname() == "!rochelle" )
					return "Producer";
				else if ( GetTargetname() == "!bill" )
					return "NamVet";
				else if ( GetTargetname() == "!francis" )
					return "Biker";
				else if ( GetTargetname() == "!louis" )
					return "Manager";
				else if ( GetTargetname() == "!zoey" )
					return "TeenGirl";
			}
		}
		else
		{
			return GetZombieName();
		}
	}
	
	return "";
}

/**
 * Returns entity's first move child if exists
 */
function VSLib::Entity::FirstMoveChild()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local firstMoveChild = _ent.FirstMoveChild();
	if (!firstMoveChild)
		return null;
	return ::VSLib.Entity(firstMoveChild);
}

/**
 * If in hierarchy, retrieves the entity's parent.
 */
function VSLib::Entity::GetMoveParent()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local moveParent = _ent.GetMoveParent();
	if (!moveParent)
		return null;
	return ::VSLib.Entity(moveParent);
}

/**
 * Returns next child entity
 */
function VSLib::Entity::NextMovePeer()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local nextMovePeer = _ent.NextMovePeer();
	if (!nextMovePeer)
		return null;
	return ::VSLib.Entity(nextMovePeer);
}

/**
 * If in hierarchy, walks up the hierarchy to find the root parent.
 */
function VSLib::Entity::GetRootMoveParent()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local rootMoveParent = _ent.GetRootMoveParent();
	if (!rootMoveParent)
		return null;
	return ::VSLib.Entity(rootMoveParent);
}

/**
 * Looks up a context and returns it if available. May return string, float, or null (if the context isn't found).
 */
function VSLib::Entity::GetContext(str)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetContext(str);
}

/**
 * Stores any key/value pair in this entity's dialog contexts. Value must be a string. Will last for duration (set 0 to mean 'forever').
 */
function VSLib::Entity::SetContext( name, value, duration )
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.SetContext(name, value, duration);
}

/**
 * Stores any key/value pair in this entity's dialog contexts. Value must be a number (int or float). Will last for duration (set 0 to mean 'forever').
 */
function VSLib::Entity::SetContextNum( name, value, duration )
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.SetContextNum(name, value, duration);
}

/**
 * Returns the entity as an EHANDLE.
 */
function VSLib::Entity::GetEntityHandle()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetEntityHandle();
}

/**
 * Returns the distance (in units) to the ground from the entity's origin.
 */
function VSLib::Entity::GetDistanceToGround()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local startPt = GetLocation();
	local endPt = startPt + Vector(0, 0, -9999999);
	
	local m_trace = { start = startPt, end = endPt, ignore = _ent, mask = TRACE_MASK_SHOT };
	TraceLine(m_trace);
	
	if (m_trace.enthit == _ent || !m_trace.hit)
		return 0.0;
	
	return ::VSLib.Utils.CalculateDistance(startPt, m_trace.pos);
}

/**
 * Returns the position on ground below from the entity's origin.
 * @authors shotgunefx
 */
function VSLib::Entity::GetLocationBelow()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local startPt = GetLocation();
	local endPt = startPt + Vector(0, 0, -9999999);
	
	local m_trace = { start = startPt, end = endPt, ignore = _ent, mask = TRACE_MASK_SHOT };
	TraceLine(m_trace);
	
	if (!m_trace.hit)
		return;
	
	return m_trace.pos;
}

/**
 * Returns true if the entity is in the air.
 */
function VSLib::Entity::IsEntityInAir()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetDistanceToGround() > 5.0;
}

/**
 * Returns the entity's button mask
 */
function VSLib::Entity::GetPressedButtons()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask();
}

/**
 * Returns if the client is pressing the specified button
 */
function VSLib::Entity::IsPressingButton(btn)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return (_ent.GetButtonMask() & btn) > 0;
}

/**
 * Returns true if this player is currently pressing +lookspin (if bound)
 * @authors shotgunefx
 */
function VSLib::Entity::IsPressingLookspin()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask() & 0x2000000;
}

/**
 * Returns true if this player is currently firing a weapon (either a gun, bat, etc).
 * Note that it doesn't check if the gun has any ammo (just checks for key press).
 */
function VSLib::Entity::IsPressingAttack()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask() & (1 << 0);
}

/**
 * Returns true if this player is jumping (or pressing the space bar button for example).
 */
function VSLib::Entity::IsPressingJump()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask() & (1 << 1);
}

/**
 * Returns true if this player is ducking (or pressing the CTRL key for example).
 */
function VSLib::Entity::IsPressingDuck()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask() & (1 << 2);
}

/**
 * Returns true if this player is pressing forward (or pressing the W key for example).
 */
function VSLib::Entity::IsPressingForward()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask() & (1 << 3);
}

/**
 * Returns true if this player is pressing backward (or pressing the S key for example).
 */
function VSLib::Entity::IsPressingBackward()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask() & (1 << 4);
}

/**
 * Returns true if this player is pressing the USE key (or pressing the E key for example).
 */
function VSLib::Entity::IsPressingUse()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask() & (1 << 5);
}

/**
 * Returns true if this player is pressing the Left key (or pressing the A key for example).
 */
function VSLib::Entity::IsPressingLeft()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask() & (1 << 9);
}

/**
 * Returns true if this player is pressing the Right key (or pressing the D key for example).
 */
function VSLib::Entity::IsPressingRight()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask() & (1 << 10);
}

/**
 * Returns true if this player is pressing the shove key (or pressing right-click for example).
 */
function VSLib::Entity::IsPressingShove()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask() & (1 << 11);
}

/**
 * Returns true if this player is pressing the reload key (or pressing the R key for example).
 */
function VSLib::Entity::IsPressingReload()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask() & (1 << 13);
}

/**
 * Returns true if this player is pressing the walk key (or pressing the shift key for example).
 */
function VSLib::Entity::IsPressingWalk()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask() & (1 << 17);
}

/**
 * Returns true if this player is pressing the zoom key.
 */
function VSLib::Entity::IsPressingZoom()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.GetButtonMask() & (1 << 19);
}

/**
 * Returns the entity's owner, or null if the owner does not exist
 */
function VSLib::Entity::GetOwnerEntity()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local owner = _ent.GetOwnerEntity();
	if (!owner)
		return null;
	return ::VSLib.Entity(owner);
}

/**
 * Returns the entity's name stripped of template unique decoration.
 */
function VSLib::Entity::GetPreTemplateName()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetPreTemplateName();
}


/**
 * Commands this Entity to move to a particular location (only applies to bots).
 */
function VSLib::Entity::BotMoveToLocation(newpos)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Bot " + _idx + " is invalid.");
		return;
	}
	
	CommandABot( { cmd = 1, pos = newpos, bot = _ent } );
}

/**
 * Commands this Entity to move to another entity's location (only applies to bots).
 */
function VSLib::Entity::BotMoveToOther(otherEntity)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Bot " + _idx + " is invalid.");
		return;
	}
	
	CommandABot( { cmd = 1, pos = otherEntity.GetLocation(), bot = _ent } );
}

/**
 * Commands the other bot entity to move to this entity's location (only applies to bots).
 */
function VSLib::Entity::BotMoveOtherToThis(otherEntity)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Bot " + _idx + " is invalid.");
		return;
	}
	
	CommandABot( { cmd = 1, pos = GetLocation(), bot = otherEntity.GetBaseEntity() } );
}

/**
 * Commands this Entity to attack a particular entity (only applies to bots).
 */
function VSLib::Entity::BotAttack(otherEntity)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Bot " + _idx + " is invalid.");
		return;
	}
	
	CommandABot( { cmd = 0, target = otherEntity.GetBaseEntity(), bot = _ent } );
}

/**
 * Commands this Entity to retreat from a particular entity (only applies to bots).
 */
function VSLib::Entity::BotRetreatFrom(otherEntity)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Bot " + _idx + " is invalid.");
		return;
	}
	
	CommandABot( { cmd = 2, target = otherEntity.GetBaseEntity(), bot = _ent } );
}

/**
 * Returns the bot to normal after it is commanded.
 */
function VSLib::Entity::BotReset()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Bot " + _idx + " is invalid.");
		return;
	}
	
	CommandABot( { cmd = 3, bot = _ent } );
}

/**
 * Plays a sound file on an entity
 */
function VSLib::Entity::EmitSound( file )
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if (file == "" || !file)
		return;
	
	if ( !(file in ::EasyLogic.PrecachedSounds) )
	{
		printf("VSLib: Precaching named sound: %s", file);
		_ent.PrecacheScriptSound(file);
		::EasyLogic.PrecachedSounds[file] <- 1;
	}
	
	g_MapScript.EmitSoundOn(file, _ent);
}

/**
 * Stops a sound on an entity
 */
function VSLib::Entity::StopSound( file )
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	g_MapScript.StopSoundOn( file, _ent );
}

/**
 * Returns true if the entity is a bot.
 */
function VSLib::Entity::IsBot()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return IsPlayerABot(_ent);
}

/**
 * Sets the sense flags for this player.
 */
function VSLib::Entity::SetSenseFlags(flags)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if (!IsBot())
		return;
	
	_ent.SetSenseFlags(flags);
}

/**
 * Sets if the target can see.
 */
function VSLib::Entity::ChangeBotEyes(hasEyes)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	if (!IsBot())
		return;
	
	if (!hasEyes)
		_ent.SetSenseFlags(_ent.GetSenseFlags() | BOT_CANT_SEE);
	else
		_ent.SetSenseFlags(_ent.GetSenseFlags() & ~BOT_CANT_SEE);
}

/**
 * Gets the sense flags for this player.
 */
function VSLib::Entity::GetSenseFlags()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return 0;
	}
	
	if (!IsBot())
		return 0;
	
	return _ent.GetSenseFlags();
}

/**
 * Returns true if the entity is a real human (non-bot).
 */
function VSLib::Entity::IsHuman()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	return !IsBot();
}

/**
 * Returns true if the witch is a bride.
 */
function VSLib::Entity::IsWitchBride()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	if ( _ent.GetClassname() == "witch" )
	{
		foreach( witch_bride in Objects.OfModel("models/infected/witch_bride.mdl") )
		{
			if ( witch_bride.GetEntityHandle() == _ent.GetEntityHandle() )
				return true;
		}
	}
	
	return false;
}

/**
 * Returns true if the infected is an uncommon.
 */
function VSLib::Entity::IsUncommonInfected()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	if ( GetUncommonInfected() > 0 )
		return true;
	
	return false;
}

/**
 * Returns true if the passed in model matches the entity.
 */
function VSLib::Entity::IsModel( mdl )
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	foreach( model in Objects.OfModel(mdl) )
	{
		if ( model.GetEntityHandle() == _ent.GetEntityHandle() )
			return true;
	}
	
	return false;
}

/**
 * Adds to the entity's THINK function. You can use "this.ent" when you need to use the VSLib::Entity.
 * 
 * @param func A function to add to the think timer.
 */
function VSLib::Entity::AddThinkFunction( func )
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local funcName = "_thnk_" + UniqueString();
	_ent.ValidateScriptScope();
	local scrScope = _ent.GetScriptScope();
	scrScope.ent <- this;
	scrScope[funcName] <- func;
	AddThinkToEnt(_ent, funcName);
}

/**
 * Returns the entity's script scope.
 */
function VSLib::Entity::GetScriptScope( )
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.ValidateScriptScope();
	return _ent.GetScriptScope();
}

/**
 * Returns the entity's unique identifier used to refer to the entity within the scripting system.
 */
function VSLib::Entity::GetScriptID( )
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetScriptId();
}

/**
 * Connects an output to a function
 *
 * @param output The output name (string)
 * @param func Function to fire (pass in a function, not a string name)
 * @param name Function name (pass in a string name, not a function)
 */
function VSLib::Entity::ConnectOutput( output, func, name = "" )
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local oname = "";
	
	if ( name != "" )
		oname = "_vslib_out" + name;
	else
		oname = "_vslib_out" + UniqueString();
	
	GetScriptScope()[oname] <- func;
	_ent.ConnectOutput( output, oname );
}

/**
 * Removes a connected script function from an I/O event.
 *
 * @param output The output name (string)
 * @param name Function name (pass in a string name, not a function)
 */
function VSLib::Entity::DisconnectOutput( output, name )
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local oname = "_vslib_out" + name;
	_ent.DisconnectOutput( output, oname );
}

/**
 * Gets the closest entity from a passed in table
 */
function VSLib::Entity::GetClosestEntityFromTable( table )
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local dist = null;
	local ent = null;
	
	foreach( entity in table )
	{
		if ( entity.GetEntityHandle() != GetEntityHandle() )
		{
			if ( !dist || ::VSLib.Utils.CalculateDistance(GetLocation(), entity.GetLocation()) < dist )
			{
				dist = ::VSLib.Utils.CalculateDistance(GetLocation(), entity.GetLocation());
				ent = entity;
			}
		}
	}
	
	return ent;
}

/**
 * Gets the closest survivor
 */
function VSLib::Entity::GetClosestSurvivor()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.Survivors() );
}

/**
 * Gets the closest L4D1 survivor
 */
function VSLib::Entity::GetClosestL4D1Survivor()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.L4D1Survivors() );
}

/**
 * Gets the closest L4D1 or L4D2 survivor
 */
function VSLib::Entity::GetAnyClosestSurvivor()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.AllSurvivors() );
}

/**
 * Gets the closest human survivor
 */
function VSLib::Entity::GetClosestHumanSurvivor()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local dist = null;
	local surv = null;
	
	foreach( survivor in Players.AllSurvivors() )
	{
		if ( survivor.IsHuman() && survivor.GetEntityHandle() != GetEntityHandle() )
		{
			if ( !dist || ::VSLib.Utils.CalculateDistance(GetLocation(), survivor.GetLocation()) < dist )
			{
				dist = ::VSLib.Utils.CalculateDistance(GetLocation(), survivor.GetLocation());
				surv = survivor;
			}
		}
	}
	
	return surv;
}

/**
 * Get the distance to the closest survivor
 */
function VSLib::Entity::GetDistanceToClosestSurvivor()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local survivor = GetClosestSurvivor();
	
	if ( !survivor )
		return;
	
	return ::VSLib.Utils.CalculateDistance(GetLocation(), survivor.GetLocation());
}

/**
 * Get the distance to the closest L4D1 survivor
 */
function VSLib::Entity::GetDistanceToClosestL4D1Survivor()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local survivor = GetClosestL4D1Survivor();
	
	if ( !survivor )
		return;
	
	return ::VSLib.Utils.CalculateDistance(GetLocation(), survivor.GetLocation());
}

/**
 * Get the distance to the closest L4D1 or L4D2 survivor
 */
function VSLib::Entity::GetDistanceToAnyClosestSurvivor()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	local survivor = GetAnyClosestSurvivor();
	
	if ( !survivor )
		return;
	
	return ::VSLib.Utils.CalculateDistance(GetLocation(), survivor.GetLocation());
}

/**
 * Gets the closest infected
 */
function VSLib::Entity::GetClosestInfected()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.AllInfected() );
}

/**
 * Gets the closest special infected
 */
function VSLib::Entity::GetClosestSpecialInfected()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.Infected() );
}

/**
 * Gets the closest smoker
 */
function VSLib::Entity::GetClosestSmoker()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.OfType(Z_SMOKER) );
}

/**
 * Gets the closest boomer
 */
function VSLib::Entity::GetClosestBoomer()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.OfType(Z_BOOMER) );
}

/**
 * Gets the closest hunter
 */
function VSLib::Entity::GetClosestHunter()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.OfType(Z_HUNTER) );
}

/**
 * Gets the closest spitter
 */
function VSLib::Entity::GetClosestSpitter()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.OfType(Z_SPITTER) );
}

/**
 * Gets the closest jockey
 */
function VSLib::Entity::GetClosestJockey()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.OfType(Z_JOCKEY) );
}

/**
 * Gets the closest charger
 */
function VSLib::Entity::GetClosestCharger()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.OfType(Z_CHARGER) );
}

/**
 * Gets the closest tank
 */
function VSLib::Entity::GetClosestTank()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.OfType(Z_TANK) );
}

/**
 * Gets the closest witch
 */
function VSLib::Entity::GetClosestWitch()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.Witches() );
}

/**
 * Gets the closest common infected
 */
function VSLib::Entity::GetClosestCommonInfected()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.CommonInfected() );
}

/**
 * Gets the closest uncommon infected
 */
function VSLib::Entity::GetClosestUncommonInfected()
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	return GetClosestEntityFromTable( Players.UncommonInfected() );
}


/**
 * Sets the entity's alpha
 *
 * @param value An integer value between 0 and 255
 */
function VSLib::Entity::SetEntityRenderAmt( value )
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return;
	}
	
	_ent.__KeyValueFromInt("renderamt", value.tointeger());
}


/**
 * Returns true if this entity can trace to another entity without hitting anything.
 * I.e. if a line can be drawn from this entity to the other entity without any collision.
 */
function VSLib::Entity::CanTraceToOtherEntity(otherEntity, height = 5)
{
	if (!IsEntityValid())
	{
		printl("VSLib Warning: Entity " + _idx + " is invalid.");
		return false;
	}
	
	local begin = GetLocation() + Vector(0, 0, height);
	local finish = otherEntity.GetLocation() + Vector(0, 0, height);
	
	// add 5 to z-axis so it doesn't collide with level ground
	local m_trace = { start = begin, end = finish, ignore = _ent, mask = TRACE_MASK_SHOT };
	TraceLine(m_trace);
	
	if (!m_trace.hit || m_trace.enthit == null || m_trace.enthit == _ent)
		return false;
	
	if (m_trace.enthit.GetClassname() == "worldspawn" || !m_trace.enthit.IsValid())
		return false;
	
	if (m_trace.enthit == otherEntity.GetBaseEntity() || ::VSLib.Utils.AreVectorsEqual(m_trace.pos, finish))
		return true;
	
	return false;
}






/**
 * Processes damage data associated with ::VSLib.
 */
::AllowTakeDamage <- function (damageTable)
{
	// Process triggered hurts
	if (damageTable.Attacker == ::VSLib.EntData._lastHurt)
	{
		foreach (hEnt in ::VSLib.EntData._hurtIgnore)
			if (hEnt.GetIndex() == damageTable.Victim.GetEntityIndex())
				return false;
		
		if (!::VSLib.EntData._hurtIntent || damageTable.Victim == ::VSLib.EntData._hurtIntent)
		{
			damageTable.DamageDone = ::VSLib.EntData._hurtDmg;
			return true;
		}
		
		return false;
	}
	
	// Process hooks
	if ("EasyLogic" in VSLib)
	{
		if (damageTable.Victim != null)
		{
			local name = damageTable.Victim.GetClassname();
			if (name in ::VSLib.EasyLogic.OnDamage)
			{
				local victim = ::VSLib.Utils.GetEntityOrPlayer(damageTable.Victim);
				local attacker = ::VSLib.Utils.GetEntityOrPlayer(damageTable.Attacker);
				
				local damagesave = damageTable.DamageDone;
				damageTable.DamageDone = ::VSLib.EasyLogic.OnDamage[name](victim, attacker, damageTable.DamageDone, damageTable);
				
				if (damageTable.DamageDone == null)
					damageTable.DamageDone = damagesave;
				else if (damageTable.DamageDone <= 0)
					return false;
				
				return true;
			}
		}
		
		foreach (func in ::VSLib.EasyLogic.OnTakeDamage)
		{
			if (func(damageTable) == false)
				return false;
		}
	}
	
	if ( "ModeAllowTakeDamage" in g_ModeScript )
		return ModeAllowTakeDamage(damageTable);
	if ( "MapAllowTakeDamage" in g_ModeScript )
		return MapAllowTakeDamage(damageTable);
	
	return true;
}

if ( ("AllowTakeDamage" in g_ModeScript) && (g_ModeScript.AllowTakeDamage != getroottable().AllowTakeDamage) )
{
	g_ModeScript.ModeAllowTakeDamage <- g_ModeScript.AllowTakeDamage;
	g_ModeScript.AllowTakeDamage <- getroottable().AllowTakeDamage;
}
if ( ("AllowTakeDamage" in g_MapScript) && (g_MapScript.AllowTakeDamage != getroottable().AllowTakeDamage) )
{
	g_ModeScript.MapAllowTakeDamage <- g_MapScript.AllowTakeDamage;
	g_ModeScript.AllowTakeDamage <- getroottable().AllowTakeDamage;
}
else
{
	g_ModeScript.AllowTakeDamage <- getroottable().AllowTakeDamage;
}



/**
 * Associates the AllowBash() function with ::VSLib.
 */
::AllowBash <- function (basher, bashee)
{
	local attacker = ::VSLib.Utils.GetEntityOrPlayer(basher);
	local victim = ::VSLib.Utils.GetEntityOrPlayer(bashee);
	
	foreach(func in ::VSLib.EasyLogic.OnBash)
	{
		if (func != null)
		{
			local res = func(attacker, victim);
			
			if (res != null)
			switch ( res )
			{
				case ALLOW_BASH_NONE:
					return ALLOW_BASH_NONE;
				case ALLOW_BASH_PUSHONLY:
					return ALLOW_BASH_PUSHONLY;
			}
		}
	}
	
	if ( "ModeAllowBash" in g_ModeScript )
		return ModeAllowBash(damageTable);
	if ( "MapAllowBash" in g_ModeScript )
		return MapAllowBash(damageTable);
	
	return ALLOW_BASH_ALL;
}

if ( ("AllowBash" in g_ModeScript) && (g_ModeScript.AllowBash != getroottable().AllowBash) )
{
	g_ModeScript.ModeAllowBash <- g_ModeScript.AllowBash;
	g_ModeScript.AllowBash <- getroottable().AllowBash;
}
else if ( ("AllowBash" in g_MapScript) && (g_MapScript.AllowBash != getroottable().AllowBash) )
{
	g_ModeScript.MapAllowBash <- g_MapScript.AllowBash;
	g_ModeScript.AllowBash <- getroottable().AllowBash;
}
else
{
	g_ModeScript.AllowBash <- getroottable().AllowBash;
}



/**
 * Processes BotQuery() with ::VSLib.
 */
::BotQuery <- function (queryflag, entity, defaultvalue)
{
	foreach (func in ::VSLib.EasyLogic.OnBotQuery)
		func(queryflag, entity, defaultvalue);
	
	if ( "ModeBotQuery" in g_ModeScript )
		return ModeBotQuery(queryflag, entity, defaultvalue);
	if ( "MapBotQuery" in g_ModeScript )
		return MapBotQuery(queryflag, entity, defaultvalue);
	
	return defaultvalue;
}

if ( ("BotQuery" in g_ModeScript) && (g_ModeScript.BotQuery != getroottable().BotQuery) )
{
	g_ModeScript.ModeBotQuery <- g_ModeScript.BotQuery;
	g_ModeScript.BotQuery <- getroottable().BotQuery;
}
else if ( ("BotQuery" in g_MapScript) && (g_MapScript.BotQuery != getroottable().BotQuery) )
{
	g_ModeScript.MapBotQuery <- g_MapScript.BotQuery;
	g_ModeScript.BotQuery <- getroottable().BotQuery;
}
else
{
	g_ModeScript.BotQuery <- getroottable().BotQuery;
}




// Add a weak reference to the global table.
::Entity <- ::VSLib.Entity.weakref();