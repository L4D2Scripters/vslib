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
* Helper functions that VSLib uses.
*/
::VSLib.Utils <- {};


/**
 * Global constants
 */
// "Survivor"s, to be used with SpawnL4D1Survivor()
getconsttable()["BILL"] <- 4;
getconsttable()["ZOEY"] <- 5;
getconsttable()["FRANCIS"] <- 6;
getconsttable()["LOUIS"] <- 7;

// Campaigns to be used with GetCampaign()
getconsttable()["DEAD_CENTER"] <- 1;
getconsttable()["DARK_CARNIVAL"] <- 2;
getconsttable()["SWAMP_FEVER"] <- 3;
getconsttable()["HARD_RAIN"] <- 4;
getconsttable()["THE_PARISH"] <- 5;
getconsttable()["THE_PASSING"] <- 6;
getconsttable()["THE_SACRIFICE"] <- 7;
getconsttable()["NO_MERCY"] <- 8;
getconsttable()["CRASH_COURSE"] <- 9;
getconsttable()["DEATH_TOLL"] <- 10;
getconsttable()["DEAD_AIR"] <- 11;
getconsttable()["BLOOD_HARVEST"] <- 12;
getconsttable()["COLD_STREAM"] <- 13;

// Stages to be used with GetNextStage() or Utils.TriggerStage().
getconsttable()["STAGE_PANIC"] <- 0;
getconsttable()["STAGE_TANK"] <- 1;
getconsttable()["STAGE_DELAY"] <- 2;
getconsttable()["STAGE_ONSLAUGHT"] <- 3;
getconsttable()["STAGE_SCRIPTED"] <- 3;
getconsttable()["STAGE_CLEAROUT"] <- 4;
getconsttable()["STAGE_SETUP"] <- 5;
getconsttable()["STAGE_UNKNOWN"] <- 6;
getconsttable()["STAGE_ESCAPE"] <- 7;
getconsttable()["STAGE_RESULTS"] <- 8;
getconsttable()["STAGE_NONE"] <- 9;


/**
 * Replaces parts of a string with another string,
 *
 * @param string The full string
 * @param original The string to replace
 * @param replacement The string to replace "original" with
 * 
 * @return The modified string
 */
function VSLib::Utils::StringReplace(string, original, replacement)
{
	local expression = regexp(original);
	local result = "";
	local position = 0;

	local captures = expression.capture(string);

	while (captures != null)
	{
		foreach (i, capture in captures)
		{
			result += string.slice(position, capture.begin);
			result += replacement;
			position = capture.end;
		}

		captures = expression.capture(string, position);
	}

	result += string.slice(position);

	return result;
}

/**
 * Searches in the Vars and RoundVars tables if not found in the root table.
 */
function VSLib::Utils::SearchMainTables(idx)
{
	if (idx in getroottable())
		return getroottable()[idx];
	else if (idx in ::VSLib.EasyLogic.UserDefinedVars)
		return ::VSLib.EasyLogic.UserDefinedVars[idx];
	else if (idx in ::VSLib.EasyLogic.RoundVars)
		return ::VSLib.EasyLogic.RoundVars[idx];
	
	throw null;
}

/**
 * Combines all elements of an array into one string
 */
function VSLib::Utils::CombineArray(args, delimiter = " ")
{
	local str = "";
	for (local i = 0; i < args.len(); i++)
		str += args[i].tostring() + delimiter;
	return str;
}

/**
 * Deserializes and returns a table of integer string indexes converted to integer indexes
 */
function VSLib::Utils::DeserializeIdxTable(t)
{
	local reg = regexp("^[0-9]+$");

	foreach (idx, val in t)
	{
		if (typeof val == "table")
			t[idx] <- DeserializeIdxTable(val);

		if (reg.match(idx.tostring()))
		{
			delete t[idx];
			t[idx.tointeger()] <- val;
		}
	}

	return t;
}

/**
 * Prints a table or array
 */
function VSLib::Utils::PrintTable(debugTable, prefix = "")
{
	if (prefix == "")
	{
		if ( typeof(debugTable) == "table" )
			printl("{")
		else if ( typeof(debugTable) == "array" )
			printl("[")
		prefix = "   "
	}
	foreach (idx, val in debugTable)
	{
		if ( typeof(val) == "table" )
		{
			printl( prefix + idx + " = \n" + prefix + "{")
			::VSLib.Utils.PrintTable( val, prefix + "   " )
			printl(prefix + "}")
		}
		else if ( typeof(val) == "array" )
		{
			printl( prefix + idx + " = \n" + prefix + "[")
			::VSLib.Utils.PrintTable( val, prefix + "   " )
			printl(prefix + "]")
		}
		else if ( typeof(val) == "string" )
			printl(prefix + idx + "\t= \"" + val + "\"")
		else
			printl(prefix + idx + "\t= " + val)
	}
	if (prefix == "   ")
	{
		if ( typeof(debugTable) == "table" )
			printl("}")
		else if ( typeof(debugTable) == "array" )
			printl("]")
	}
}

/**
 * Returns a progress bar as a string.
 *
 * For example:  30%  ||||||--------------
 *
 *
 * @param width The length (number of chars) that this progress bar should have
 * @param count The current value
 * @param goal The maximum value possible
 * @param fill What character to fill in for a completed block
 * @param empty What character to fill in for an incomplete block
 *
 * @return A formatted progress bar as string
 */
function VSLib::Utils::BuildProgressBar(width, count, goal, fill = "|", empty = ".")
{
	if(count > goal)
		count = goal;
	
	local constant = goal.tofloat() / (width.tofloat() - 1.0);
	local bars = ceil( count.tofloat() / constant.tofloat() );
	
	local bar = "";
	
	for(local i = 0; i <= bars; i++)
		bar += fill;
	
	for(local i = bars + 1; i < width; i++)
		bar += empty;
	
	return bar;
}

/**
 * Add printf helper to global table.
 *
 * Really, really horrendous way to go about this, but this is the
 * only way since Squirrel cannot pass arbitrary stack levels onto
 * other functions.
 *
 * Supports up to 12 inputs, can easily add more below if needed.
 */
::printf <- function(str, ...)
{
	switch (vargv.len())
	{
		case 0:
			printl(str);
			break;
		case 1:
			printl(format(str, vargv[0]));
			break;
		case 2:
			printl(format(str, vargv[0], vargv[1]));
			break;
		case 3:
			printl(format(str, vargv[0], vargv[1], vargv[2]));
			break;
		case 4:
			printl(format(str, vargv[0], vargv[1], vargv[2], vargv[3]));
			break;
		case 5:
			printl(format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4]));
			break;
		case 6:
			printl(format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5]));
			break;
		case 7:
			printl(format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6]));
			break;
		case 8:
			printl(format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7]));
			break;
		case 9:
			printl(format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8]));
			break;
		case 10:
			printl(format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9]));
			break;
		case 11:
			printl(format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9], vargv[10]));
			break;
		case 12:
			printl(format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9], vargv[10], vargv[11]));
			break;
	}
}


/**
 * Wraps Say() to make it easier to read. This will Say to all.
 */
function VSLib::Utils::SayToAll(str, ...)
{
	switch (vargv.len())
	{
		case 0:
			Say(null, str, false);
			break;
		case 1:
			Say(null, format(str, vargv[0]), false);
			break;
		case 2:
			Say(null, format(str, vargv[0], vargv[1]), false);
			break;
		case 3:
			Say(null, format(str, vargv[0], vargv[1], vargv[2]), false);
			break;
		case 4:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3]), false);
			break;
		case 5:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4]), false);
			break;
		case 6:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5]), false);
			break;
		case 7:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6]), false);
			break;
		case 8:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7]), false);
			break;
		case 9:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8]), false);
			break;
		case 10:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9]), false);
			break;
		case 11:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9], vargv[10]), false);
			break;
		case 12:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9], vargv[10], vargv[11]), false);
			break;
	}
}

/**
 * Wraps Say() to make it easier to read. This will Say to the current team only.
 */
function VSLib::Utils::SayToTeam(player, str, ...)
{
	switch (vargv.len())
	{
		case 0:
			Say(player.GetBaseEntity(), str, true);
			break;
		case 1:
			Say(player.GetBaseEntity(), format(str, vargv[0]), true);
			break;
		case 2:
			Say(player.GetBaseEntity(), format(str, vargv[0], vargv[1]), true);
			break;
		case 3:
			Say(player.GetBaseEntity(), format(str, vargv[0], vargv[1], vargv[2]), true);
			break;
		case 4:
			Say(player.GetBaseEntity(), format(str, vargv[0], vargv[1], vargv[2], vargv[3]), true);
			break;
		case 5:
			Say(player.GetBaseEntity(), format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4]), true);
			break;
		case 6:
			Say(player.GetBaseEntity(), format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5]), true);
			break;
		case 7:
			Say(player.GetBaseEntity(), format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6]), true);
			break;
		case 8:
			Say(player.GetBaseEntity(), format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7]), true);
			break;
		case 9:
			Say(player.GetBaseEntity(), format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8]), true);
			break;
		case 10:
			Say(player.GetBaseEntity(), format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9]), true);
			break;
		case 11:
			Say(player.GetBaseEntity(), format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9], vargv[10]), true);
			break;
		case 12:
			Say(player.GetBaseEntity(), format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9], vargv[10], vargv[11]), true);
			break;
	}
}


/**
 * Says some text after a delay.
 */
function VSLib::Utils::SayToAllDel(str, ...)
{
	local temp = "";

	switch (vargv.len())
	{
		case 0:
			temp = str;
			break;
		case 1:
			temp = format(str, vargv[0]);
			break;
		case 2:
			temp = format(str, vargv[0], vargv[1]);
			break;
		case 3:
			temp = format(str, vargv[0], vargv[1], vargv[2]);
			break;
		case 4:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3]);
			break;
		case 5:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4]);
			break;
		case 6:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5]);
			break;
		case 7:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6]);
			break;
		case 8:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7]);
			break;
		case 9:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8]);
			break;
		case 10:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9]);
			break;
		case 11:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9], vargv[10]);
			break;
		case 12:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9], vargv[10], vargv[11]);
			break;
	}
	
	Timers.AddTimer ( 0.1, false, ::VSLib.Utils._sayfunc, { txt = temp, team = false } );
}


/**
 * Says some text after a delay to the team.
 */
function VSLib::Utils::SayToTeamDel(player, str, ...)
{
	local temp = "";

	switch (vargv.len())
	{
		case 0:
			temp = str;
			break;
		case 1:
			temp = format(str, vargv[0]);
			break;
		case 2:
			temp = format(str, vargv[0], vargv[1]);
			break;
		case 3:
			temp = format(str, vargv[0], vargv[1], vargv[2]);
			break;
		case 4:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3]);
			break;
		case 5:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4]);
			break;
		case 6:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5]);
			break;
		case 7:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6]);
			break;
		case 8:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7]);
			break;
		case 9:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8]);
			break;
		case 10:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9]);
			break;
		case 11:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9], vargv[10]);
			break;
		case 12:
			temp = format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9], vargv[10], vargv[11]);
			break;
	}
	
	Timers.AddTimer ( 0.1, false, ::VSLib.Utils._sayfunc, { txt = temp, team = true, p = player } );
}


/**
 * Used by SayToAllDel and SayToTeamDel
 */
function VSLib::Utils::_sayfunc(args)
{
	if ("p" in args)
		Say(args.p.GetBaseEntity(), args.txt, args.team);
	else
		Say(null, args.txt, args.team);
}


//
// Helper spawn functions
//

/**
 * Spawns a new entity and returns it as VSLib::Entity.
 *
 * @param _classname The classname of the entity
 * @param pos Where to spawn it (a Vector object)
 * @param ang Angles it should spawn with
 * @param kvs Other keyvalues you may want it to have
 * @return A VSLib entity object
 */
function VSLib::Utils::CreateEntity(_classname, pos = Vector(0,0,0), ang = QAngle(0,0,0), kvs = {})
{
	kvs.classname <- _classname;
	kvs.origin <- pos;
	kvs.angles <- ang;
	
	local ent = g_ModeScript.CreateSingleSimpleEntityFromTable(kvs);
	ent.ValidateScriptScope();
	
	return ::VSLib.Entity(ent);
}

/**
 * Alternative to Utils.CreateEntity(). Spawns a new entity and returns it as VSLib::Entity.
 *
 * @param _classname The classname of the entity
 * @param _targetname The targetname of the entity
 * @param pos Where to spawn it (a Vector object)
 * @param ang Angles it should spawn with
 * @param kvs Other keyvalues you may want it to have
 * @return A VSLib entity object
 */
function VSLib::Utils::SpawnEntity(_classname, _targetname = "", pos = Vector(0,0,0), ang = QAngle(0,0,0), kvs = {})
{
	local angvec = Vector( ang.x, ang.y, ang.z );
	kvs.targetname <- _targetname;
	kvs.origin <- pos;
	kvs.angles <- angvec;
	
	local ent = SpawnEntityFromTable(_classname, kvs);
	ent.ValidateScriptScope();
	
	return ::VSLib.Entity(ent);
}

/**
 * Spawns the requested L4D1 Survivor at the location you want.
 *
 * @authors Rayman1103
 */
function VSLib::Utils::SpawnL4D1Survivor(survivor, pos = Vector(0,0,0), ang = QAngle(0,0,0))
{
	if ( survivor == 4 )
		::VSLib.Utils.PrecacheModel( "models/survivors/survivor_namvet.mdl" );
	else if ( survivor == 5 )
		::VSLib.Utils.PrecacheModel( "models/survivors/survivor_teenangst.mdl" );
	else if ( survivor == 6 )
		::VSLib.Utils.PrecacheModel( "models/survivors/survivor_biker.mdl" );
	else if ( survivor == 7 )
		::VSLib.Utils.PrecacheModel( "models/survivors/survivor_manager.mdl" );
	
	local ent = ::VSLib.Utils.CreateEntity("info_l4d1_survivor_spawn", pos, ang, { character = survivor });
	ent.Input( "SpawnSurvivor" );
	ent.Input( "Kill" );
}

/**
 * Spawns the requested zombie via the Director at the specified location.
 */
function VSLib::Utils::SpawnZombie(zombieType, pos = Vector(0,0,0), ang = QAngle(0,0,0), offerTank = false, victim = null)
{
	if ( zombieType == "witch" )
		::VSLib.Utils.PrecacheModel( "models/infected/witch.mdl" );
	else if ( zombieType == "witch_bride" )
		::VSLib.Utils.PrecacheModel( "models/infected/witch_bride.mdl" );
	
	local ent = ::VSLib.Utils.CreateEntity("info_zombie_spawn", pos, ang);
	ent.SetKeyValue("population", zombieType);
	ent.SetKeyValue("offer_tank", offerTank.tointeger());
	ent.Input("SpawnZombie");
	if ( victim != null )
		ent.Input("StartleZombie", victim, 0.1);
	
	ent.Input("Kill", "", 0.2);
}

/**
 * Spawns the requested zombie near a player and also
 * checks to make sure that the spawn point is not visible to
 * any survivor. Attempts to locate a position 50 times.
 * If it can't find a suitable spawn location, it'll return false.
 * Keep in mind that the closer the min and max distances are to each
 * other, the lesser the chance that a suitable spawn will be found.
 * For a good spawn chance, keep the min and max dist far apart.
 * If by chance the survivors are looking everywhere at once,
 * the infected prob won't spawn!
 */
function VSLib::Utils::SpawnZombieNearPlayer( player, zombie, maxDist = 128.0, minDist = 32.0, checkVisibility = true, offerTank = false, victim = null )
{
	if (!player)
		return false;
	
	maxDist = maxDist.tofloat();
	minDist = minDist.tofloat();
	
	if (maxDist < minDist)
		maxDist = minDist;
	
	local playerPos = null;
	if (player.IsDead())
		playerPos = player.GetLastDeathLocation();
	else
		playerPos = player.GetLocation();
	
	local survs = ::VSLib.EasyLogic.Players.AliveSurvivors();
	
	// Loop through some pathable location :\ cmon valve, give me
	// some function to get a pos the players can't see
	for (local i = 0; i < 50; i++)
	{
		local _pos = player.GetNearbyLocation( maxDist );
		local dist = ::VSLib.Utils.CalculateDistance(_pos, playerPos);
		
		if (dist > maxDist || dist < minDist)
			continue;
		
		local canSee = false;
		
		if ( checkVisibility )
		{
			// see if ppl can see this pos
			foreach (survivor in survs)
			{
				local survivorEyeAng = survivor.GetEyeAngles();
				local posLeft = _pos + survivorEyeAng.Left().Scale(64);
				local posRight = _pos + survivorEyeAng.Left().Scale(-64);
				
				if (
					survivor.CanTraceToLocation(_pos)
					|| survivor.CanTraceToLocation(_pos + Vector(0, 0, 128))
					|| survivor.CanTraceToLocation(posLeft)
					|| survivor.CanTraceToLocation(posRight)
				)
				{
					canSee = true;
					break;
				}
				
				local survdist = ::VSLib.Utils.CalculateDistance(_pos, survivor.GetLocation());
				if ((survivor.IsInEndingSafeRoom() && survdist < 800.0) || survdist < minDist)
				{
					canSee = true;
					break;
				}
			}
		}
		
		// If they cannot see it, then spawn.
		if (!canSee)
		{
			if ( (typeof zombie) == "integer" )
			{
				if ( zombie == 7 )
					::VSLib.Utils.PrecacheModel( "models/infected/witch.mdl" );
				else if ( zombie == 11 )
					::VSLib.Utils.PrecacheModel( "models/infected/witch_bride.mdl" );
				ZSpawn( { type = zombie, pos = _pos } );
				return true;
			}
			else
			{
				if ( zombie.find("common_") != null )
				{
					::VSLib.Utils.SpawnCommentaryZombie(zombie, _pos);
					return true;
				}
				else
				{
					if ( victim != null )
						::VSLib.Utils.SpawnZombie(zombie, _pos, QAngle(0,0,0), offerTank, victim);
					else
						::VSLib.Utils.SpawnZombie(zombie, _pos, QAngle(0,0,0), offerTank);
					return true;
				}
			}
		}
	}
	
	return false;
}

/**
 * Spawns the requested commentary zombie at the location you want.
 *
 * @authors Rayman1103
 */
function VSLib::Utils::SpawnCommentaryZombie(zombieModel, pos = Vector(0,0,0), ang = QAngle(0,0,0))
{
	if ( zombieModel == "witch" )
		::VSLib.Utils.PrecacheModel( "models/infected/witch.mdl" );
	
	//::VSLib.Utils.PrecacheModel( "models/infected/" + zombieModel + ".mdl" );
	local ent = ::VSLib.Utils.CreateEntity("commentary_zombie_spawner", pos, ang);
	ent.Input("SpawnZombie", zombieModel);
	ent.Input("Kill");
}


//
// Below are helper math functions.
//

/**
 * Calculates the distance between two vectors.
 */
function VSLib::Utils::CalculateDistance(vec1, vec2)
{
	if (!vec1 || !vec2)
		return -1.0;
	
	return (vec2 - vec1).Length();
}

/**
 * Calculates the dot product of two vectors.
 */
function VSLib::Utils::VectorDotProduct(a, b)
{
	return (a.x * b.x) + (a.y * b.y) + (a.z * b.z);
}

/**
 * Calculates the cross product of two vectors.
 */
function VSLib::Utils::VectorCrossProduct(a, b)
{
	return Vector((a.y * b.z) - (a.z * b.y), (a.z * b.x) - (a.x * b.z), (a.x * b.y) - (a.y * b.x));
}


/**
 * Converts QAngles into vectors, with an optional vector length.
 * 
 * @authors Rectus
 */
function VSLib::Utils::VectorFromQAngle(angles, radius = 1.0)
{
	local function ToRad(angle)
	{
		return (angle * PI) / 180;
	}
	
	local yaw = ToRad(angles.Yaw());
	local pitch = ToRad(-angles.Pitch());
	
	local x = radius * cos(yaw) * cos(pitch);
	local y = radius * sin(yaw) * cos(pitch);
	local z = radius * sin(pitch);
	
	return Vector(x, y, z);
}


/**
 * Calculates the distance between two entities.
 */
function VSLib::Utils::GetDistBetweenEntities(ent1, ent2)
{
	return ::VSLib.Utils.CalculateDistance(ent1.GetLocation(), ent2.GetLocation());
}


//
// MISC HELPERS
//

/**
 * Draws a line from one location to another
 */
function VSLib::Utils::DrawLine(pos1, pos2, time = 10.0, red = 255, green = 0, blue = 0)
{
	DebugDrawLine(pos1, pos2, red, green, blue, true, time);
}

/**
 * Slows down time.
 */
::_vsl_func_timescale <- null;
function VSLib::Utils::SlowTime(desiredTimeScale = 0.2, re_Acceleration = 2.0, minBlendRate = 1.0, blendDeltaMultiplier = 2.0, allowResumeTime = true)
{
	if (_vsl_func_timescale == null)
	{
		_vsl_func_timescale = VSLib.Utils.SpawnEntity("func_timescale", "vslib_timescale");
		
		if (_vsl_func_timescale == null)
		{
			printf("Could not create _vsl_func_timescale.");
			return;
		}
	}
	
	_vsl_func_timescale.SetKeyValue("desiredTimescale", desiredTimeScale);
	_vsl_func_timescale.SetKeyValue("acceleration", re_Acceleration);
	_vsl_func_timescale.SetKeyValue("minBlendRate", minBlendRate);
	_vsl_func_timescale.SetKeyValue("blendDeltaMultiplier", blendDeltaMultiplier);
	
	_vsl_func_timescale.Input("Start");
	
	if ( allowResumeTime )
		Timers.AddTimer(1.5, 0, ::VSLib.Utils.ResumeTime, _vsl_func_timescale);
}

/**
 * Resumes time. The param is only for VSLib's SlowTime timer.
 */
function VSLib::Utils::ResumeTime(timescale = null)
{
	if (timescale)
	{
		timescale.Input("Stop");
		return;
	}
	
	if (_vsl_func_timescale != null)
		_vsl_func_timescale.Input("Stop");
}


/**
 * Plays a sound to all clients
 */
function VSLib::Utils::PlaySoundToAll(sound)
{
	foreach (p in Players.All())
		p.PlaySound(sound);
}

/**
 * Stops a sound on all clients
 */
function VSLib::Utils::StopSoundOnAll(sound)
{
	foreach (p in Players.All())
		p.StopSound(sound);
}


/**
 * Returns a table with some infected counts.
 */
function VSLib::Utils::InfectedStats()
{
	local t = {};
	GetInfectedStats(t);
	
	return t;
}

/**
 * Returns the victim of the attacker player or null if there is no victim
 */
function VSLib::Utils::GetVictimOfAttacker( attacker )
{
	if (attacker.GetTeam() != INFECTED)
		return;
	
	foreach (surv in Players.Survivors())
	{
		local curattker = surv.GetCurrentAttacker();
		if (curattker != null && curattker.GetIndex() == attacker.GetIndex())
			return surv;
	}
}

/**
 * Checks if the entity belongs to CBaseEntity or CTerrorPlayer, then returns it as a VSLib entity
 */
function VSLib::Utils::GetEntityOrPlayer( ent )
{
	if (ent.IsValid())
	{
		if ( ent.IsPlayer() )
			return ::VSLib.Player(ent);
		else
			return ::VSLib.Entity(ent);
	}
	
	return null;
}

/**
 * Returns a pseudorandom number from min to max
 */
function VSLib::Utils::GetRandNumber( min, max )
{
	return rand() % (max - min + 1) + min;
}

// Seed rand num generator
srand( Time() );

/**
 * Forces a panic event
 */
function VSLib::Utils::ForcePanicEvent( )
{
	local ent = null;
	if (ent = Entities.FindByClassname(ent, "info_director"))
	{
		local vsent = Entity(ent);
		vsent.Input("ForcePanicEvent");
	}
	else
	{
		ent = ::VSLib.Utils.CreateEntity("info_director");
		ent.Input("ForcePanicEvent");
		ent.Input("Kill");
	}
}

/**
 * Triggers a stage type
 */
function VSLib::Utils::TriggerStage( stage, value = 1 )
{
	SessionOptions.A_CustomFinale_StageCount <- 1;
	SessionOptions.A_CustomFinale1 <- stage.tointeger();
	SessionOptions.A_CustomFinaleValue1 <- value.tofloat();
	
	local ent = null;
	if (ent = Entities.FindByClassname(ent, "info_director"))
	{
		local vsent = Entity(ent);
		vsent.Input("ScriptedPanicEvent");
	}
	else
	{
		ent = ::VSLib.Utils.CreateEntity("info_director");
		ent.Input("ScriptedPanicEvent");
		ent.Input("Kill");
	}
}

/**
 * Starts the finale
 */
function VSLib::Utils::StartFinale( )
{
	local ent = null;
	if (ent = Entities.FindByClassname(ent, "trigger_finale"))
	{
		local vsent = Entity(ent);
		
		local finale_nav = ::VSLib.Utils.CreateEntity("point_nav_attribute_region", Players.AnyAliveSurvivor().GetLocation(), QAngle(0,0,0), { maxs = "999999 999999 999999", mins = "-999999 -999999 -999999", spawnflags = "64" });
		
		if ( SessionState.MapName == "c2m5_concert" )
			EntFire( "stadium_entrance_door_relay", "Kill" );
		EntFire( "info_game_event_proxy", "Kill" );
		vsent.Input("ForceFinaleStart");
		finale_nav.Input("Kill");
	}
}

/**
 * Triggers the rescue vehicle to arrive
 */
function VSLib::Utils::TriggerRescue( )
{
	local ent = null;
	if (ent = Entities.FindByClassname(ent, "trigger_finale"))
	{
		local vsent = Entity(ent);
		
		::VSLib.Utils.StartFinale();
		
		vsent.Input("FinaleEscapeStarted");
		EntFire( "relay_car_ready", "Trigger" );
		NavMesh.UnblockRescueVehicleNav();
	}
}

/**
 * Generates a game event
 */
function VSLib::Utils::GenerateGameEvent( str )
{
	local eventtbl =
	{
		event_name = str.tostring(),
		range = "0",
		spawnflags = "0",
		targetname = "vslib_tmp_" + UniqueString(),
	};
	
	local hint = ::Utils.CreateEntity("info_game_event_proxy", Vector(0, 0, 0), QAngle(0, 0, 0), eventtbl);
	
	hint.Input("GenerateGameEvent");
	hint.Input("Kill");
}


/**
 * Returns a table with the hours, minutes, and seconds provided the total seconds (e.g. Time())
 *
 * Example:
 *     local t = GetTimeTable ( Time() );
 *     printf("Hours: %i, Minutes: %i, Seconds: %i", t.hours, t.minutes, t.seconds);
 */
function VSLib::Utils::GetTimeTable( time )
{
	// Constants
	const SECONDS_IN_HOUR = 3600;
	const SECONDS_IN_MINUTE = 60;
	
	// Modulated values
	local bh = 0;
	local bm = 0;
	local bs = 0;
	
	// Determine the number of seconds left since the start time
	if (time < 0) time = 0;

	// Hours
	if (time >= SECONDS_IN_HOUR)
	{
	   bh = ceil(time / SECONDS_IN_HOUR);
	   time = time % SECONDS_IN_HOUR;
	}
	
	// Minutes
	if (time >= SECONDS_IN_MINUTE)
	{
	   bm = ceil(time / SECONDS_IN_MINUTE);
	   time = time % SECONDS_IN_MINUTE;
	}

	// Seconds
	bs = time;
	
	return { hours = bh.tointeger(), minutes = bm.tointeger(), seconds = bs.tointeger() };
}

/**
 * Broadcasts a command to all clients
 *
 * @authors Rayman1103
 * Currently doesn't work for other clients, only works for the host.
 */
function VSLib::Utils::BroadcastClientCommand(command)
{
	local point_broadcastclientcommand = g_ModeScript.CreateSingleSimpleEntityFromTable({ classname = "point_broadcastclientcommand", origin = Vector(0,0,0), angles = Vector(0,0,0) });
	
	DoEntFire( "!self", "Command", command, 0, point_broadcastclientcommand, point_broadcastclientcommand );
	DoEntFire( "!self", "Kill", "", 0, null, point_broadcastclientcommand );
}

/**
 * Precaches a model
 *
 * @authors Rayman1103
 */
function VSLib::Utils::PrecacheModel( mdl )
{
	local Model = { classname = "prop_dynamic", model = mdl }
	if ( !(mdl in ::EasyLogic.PrecachedModels) )
	{
		printf("VSLib: Precaching: %s", mdl);
		PrecacheEntityFromTable( Model );
		::EasyLogic.PrecachedModels[mdl] <- 1;
	}
}

/**
 * Precaches the CS:S weapons, making them usable
 *
 * @authors Rayman1103
 */
function VSLib::Utils::PrecacheCSSWeapons( )
{
	local weps = ["weapon_rifle_sg552", "weapon_smg_mp5", "weapon_sniper_awp", "weapon_sniper_scout"];

	foreach(wep in weps)
	{
		local weapon = { classname = wep }
		PrecacheEntityFromTable( weapon );
	}
}

/**
 * Spawns a dynamic model at the specified location
 */
function VSLib::Utils::SpawnDynamicProp( mdl, pos, ang = QAngle(0,0,0), keyvalues = {} )
{
	::VSLib.Utils.PrecacheModel( mdl );
	local t = { model = mdl, StartDisabled = "false", Solid = "6", spawnflags = "8" };
	foreach (idx, val in t)
		keyvalues[idx] <- val;
	return ::VSLib.Utils.CreateEntity("prop_dynamic_override", pos, ang, keyvalues);
}

/**
 * Spawns a physics model at the specified location
 */
function VSLib::Utils::SpawnPhysicsProp( mdl, pos, ang = QAngle(0,0,0), keyvalues = {} )
{
	::VSLib.Utils.PrecacheModel( mdl );
	local t = { model = mdl };
	foreach (idx, val in t)
		keyvalues[idx] <- val;
	return ::VSLib.Utils.CreateEntity("prop_physics", pos, ang, keyvalues);
}

/**
 * Spawns a ragdoll model at the specified location
 *
 * @authors Rayman1103
 */
function VSLib::Utils::SpawnRagdoll( mdl, pos, ang = QAngle(0,0,0), keyvalues = {} )
{
	::VSLib.Utils.PrecacheModel( mdl );
	local t = { model = mdl, body = "0", fademindist = "-1", fadescale = "1", skin = "0", spawnflags = "4", StartDisabled = "false", };
	foreach (idx, val in t)
		keyvalues[idx] <- val;
	return ::VSLib.Utils.CreateEntity("prop_ragdoll", pos, ang, keyvalues);
}

/**
 * Spawns a commentary dummy model at the specified location
 *
 * @authors Rayman1103
 */
function VSLib::Utils::SpawnCommentaryDummy( mdl = "models/survivors/survivor_gambler.mdl", weps = "weapon_pistol", anim = "Idle_Calm_Pistol", pos = Vector(0,0,0), ang = QAngle(0,0,0), keyvalues = {} )
{
	::VSLib.Utils.PrecacheModel( mdl );
	local t = { model = mdl, startinganim = anim, eyeheight = "64", startingweapons = weps, headyawposeparam = "head_yaw", headpitchposeparam = "head_pitch", lookatplayers = "1", };
	foreach (idx, val in t)
		keyvalues[idx] <- val;
	return ::VSLib.Utils.CreateEntity("commentary_dummy", pos, ang, keyvalues);
}

/**
 * Spawns a minigun at the specified location
 *
 * @authors Rayman1103
 */
function VSLib::Utils::SpawnMinigun( pos, ang = QAngle(0,0,0), keyvalues = {} )
{
	local t = { model = "models/w_models/weapons/50cal.mdl", body = "0", fademindist = "-1", fadescale = "1", MaxAnimTime = "10", MaxPitch = "50", MaxYaw = "65", MinAnimTime = "5", MinPitch = "-25", spawnflags = "0", StartDisabled = "false", };
	foreach (idx, val in t)
		keyvalues[idx] <- val;
	return ::VSLib.Utils.CreateEntity("prop_mounted_machine_gun", pos, ang, keyvalues);
}

/**
 * Spawns a L4D1 minigun at the specified location
 *
 * @authors Rayman1103
 */
function VSLib::Utils::SpawnL4D1Minigun( pos, ang = QAngle(0,0,0), keyvalues = {} )
{
	local t = { model = "models/w_models/weapons/w_minigun.mdl", body = "0", fademindist = "-1", fadescale = "1", MaxAnimTime = "10", MaxPitch = "50", MaxYaw = "65", MinAnimTime = "5", MinPitch = "-25", spawnflags = "0", StartDisabled = "false", };
	foreach (idx, val in t)
		keyvalues[idx] <- val;
	return ::VSLib.Utils.CreateEntity("prop_minigun_l4d1", pos, ang, keyvalues);
}

/**
 * Spawns the requested weapon at the specified location
 *
 * @authors Rayman1103
 */
function VSLib::Utils::SpawnWeapon( weapon, Count = 5, pos = Vector(0,0,0), ang = QAngle(0,0,90), keyvalues = {} )
{
	local SpawnFlag = 2;
	
	if ( weapon.find("weapon_") == null )
		weapon = "weapon_" + weapon;
	
	if ( weapon == "weapon_smg_mp5" || weapon == "weapon_rifle_sg552" || weapon == "weapon_sniper_scout" || weapon == "weapon_sniper_awp" )
	{
		SpawnFlag = 1;
		Count = 1;
	}
	else
		weapon = weapon + "_spawn";
	
	if ( Count == 0 )
	{
		SpawnFlag = 10;
		Count = 1;
	}
	local t = { ammo = "999", count = Count, spawnflags = SpawnFlag, };
	foreach (idx, val in t)
		keyvalues[idx] <- val;
	return ::VSLib.Utils.CreateEntity(weapon, pos, ang, keyvalues);
}

/**
 * Spawns an ammo pile at the specified location
 *
 * @authors Rayman1103
 */
function VSLib::Utils::SpawnAmmo( mdl = "models/props/terror/ammo_stack.mdl", pos = Vector(0,0,0), ang = QAngle(0,0,0), keyvalues = {} )
{
	::VSLib.Utils.PrecacheModel( mdl );
	local t = { model = mdl, count = "5", solid = "6", spawnflags = "2", };
	foreach (idx, val in t)
		keyvalues[idx] <- val;
	return ::VSLib.Utils.CreateEntity("weapon_ammo_spawn", pos, ang, keyvalues);
}

/**
 * Spawns an already deployed upgrade at the specified location
 *
 * @authors Rayman1103
 */
function VSLib::Utils::SpawnUpgrade( upgrade, Count = 4, pos = Vector(0,0,0), ang = QAngle(0,0,0), keyvalues = {} )
{
	if ( typeof(upgrade) == "integer" )
	{
		if ( upgrade == 0 )
			upgrade = "upgrade_ammo_incendiary";
		else if ( upgrade == 1 )
			upgrade = "upgrade_ammo_explosive";
		else if ( upgrade == 2 )
			upgrade = "upgrade_laser_sight";
	}
	local t = { count = Count, spawnflags = "2", };
	foreach (idx, val in t)
		keyvalues[idx] <- val;
	
	local ent = ::VSLib.Utils.CreateEntity(upgrade, pos, ang, keyvalues);
	ent.SetKeyValue("count", Count);
	return ent;
}

/**
 * Spawns a fuel barrel at the specified location
 *
 * @authors Rayman1103
 */
function VSLib::Utils::SpawnFuelBarrel( pos, ang = QAngle(0,0,0), keyvalues = {} )
{
	local t = { model = "models/props_industrial/barrel_fuel.mdl", BasePiece = "models/props_industrial/barrel_fuel_partb.mdl", DetonateParticles = "weapon_pipebomb", DetonateSound = "BaseGrenade.Explode", fademindist = "-1", fadescale = "1", FlyingParticles = "barrel_fly", FlyingPiece01 = "models/props_industrial/barrel_fuel_parta.mdl", };
	foreach (idx, val in t)
		keyvalues[idx] <- val;
	return ::VSLib.Utils.CreateEntity("prop_fuel_barrel", pos, ang, keyvalues);
}

/**
 * Spawns a door at the specified location
 *
 * @authors Rayman1103
 */
function VSLib::Utils::SpawnDoor( mdl = "models/props_downtown/door_interior_112_01.mdl", pos = Vector(0,0,0), ang = QAngle(0,0,0), keyvalues = {} )
{
	::VSLib.Utils.PrecacheModel( mdl );
	local t = { model = mdl, axis = "-1692 -2016 -376.21, -1692 -2016 -376.21", body = "0", distance = "90", fademindist = "-1", fadescale = "1", forceclosed = "0", health = "0", returndelay = "-1", spawnpos = "0", speed = "200", spawnflags = "8192", };
	foreach (idx, val in t)
		keyvalues[idx] <- val;
	return ::VSLib.Utils.CreateEntity("prop_door_rotating", pos, ang, keyvalues);
}

/**
 * Spawns an ambient_generic and plays the desired .wav sound everywhere
 *
 * @authors Rayman1103
 */
function VSLib::Utils::PlaySound( sound, keyvalues = {} )
{
	local t = { health = "10", message = sound, pitch = "100", pitchstart = "100", radius = "1250", spawnflags = "33", };
	foreach (idx, val in t)
		keyvalues[idx] <- val;
	local ent = VSLib.Utils.CreateEntity("ambient_generic", Vector(0,0,0), QAngle(0,0,0), keyvalues);
	ent.Input("PlaySound");
	ent.Kill();
}

/**
 * Kills the given entity. Useful to use with timers.
 */
function VSLib::Utils::RemoveEntity( ent )
{
	ent.Kill();
}

/**
 * Returns a Vector position that is between the min and max radius, or null if not found.
 */
function VSLib::Utils::GetNearbyLocationRadius( player, minDist, maxDist )
{
	if (!player)
		return null;
	
	maxDist = maxDist.tofloat();
	minDist = minDist.tofloat();
	
	if (maxDist < minDist)
		maxDist = minDist;
	
	local playerPos = null;
	if (player.IsDead())
		playerPos = player.GetLastDeathLocation();
	else
		playerPos = player.GetLocation();
	
	for (local i = 0; i < 50; i++)
	{
		local _pos = player.GetNearbyLocation( maxDist );
		local dist = ::VSLib.Utils.CalculateDistance(_pos, playerPos);
		
		if (dist > maxDist || dist < minDist)
			continue;
		
		return _pos;
	}
}

/**
 * Spawns an inventory item that can be picked up by players. Returns the spawned item.
 *
 * @see Player::GetInventory()
 */
function VSLib::Utils::SpawnInventoryItem( itemName, mdl, pos )
{
	::VSLib.Utils.PrecacheModel(mdl);
	local vsent = ::VSLib.Utils.CreateEntity("prop_dynamic_override", pos, QAngle(0,0,0), { model = mdl, StartDisabled = "false", Solid = "6", spawnflags = "8" });
	vsent.Input("EnableCollision");
	vsent.Input("TurnOn");
	
	local function CalcPlayerPos()
	{
		foreach (surv in Players.AliveSurvivors())
			if (Utils.CalculateDistance(surv.GetLocation(), this.ent.GetLocation()) < 32.0)
				if (surv.CanTraceToOtherEntity(this.ent))
				{
					foreach (func in ::VSLib.EasyLogic.Notifications.OnPickupInvItem)
						func(surv, this.itemName, this.ent);
					
					surv.SetInventory( this.itemName, surv.GetInventory(this.itemName) + 1 );
					this.ent.Kill();
				}
	}
	
	vsent.GetScriptScope()["itemName"] <- itemName;
	vsent.AddThinkFunction(CalcPlayerPos);
	
	return vsent;
}

/**
 * Creates a hint on the specified entity, optionally "parenting" the hint.
 *
 * \todo @TODO See why normal SetParent doesn't work, needed to "parent" manually
 *
 * @param entity The VSLib Entity or Player to set a hint to
 * @param hinttext The hint to display
 * @param icon The icon to show, see a list of icons here: https://developer.valvesoftware.com/wiki/Env_instructor_hint#Icons
 * @param range The maximum range to display this icon. Enter 0 for infinite range
 * @param parentEnt Set to true to make the hint "follow" the entity
 * @param duration How long to show the hint. Enter 0 for infinite time.
 *
 * @return The actual hint object's VSLib::Entity
 */
function VSLib::Utils::SetEntityHint( entity, hinttext, icon = "icon_info", range = 0, parentEnt = false, duration = 0.0, noOffScreen = 1 )
{
	local HintSpawnInfo =
	{
		hint_auto_start = "1"
		hint_range = range.tostring()
		hint_suppress_rest = "1"
		hint_nooffscreen = noOffScreen.tostring()
		hint_forcecaption = "1"
		hint_icon_onscreen = icon
	}
	
	local hintTargetName = "vslib_hint_" + UniqueString();
	g_MapScript.CreateHintTarget( hintTargetName, entity.GetLocation(), null, g_MapScript.TrainingHintTargetCB );
	g_MapScript.CreateHintOn( SessionState.TrainingHintTargetNextName, entity.GetLocation(), hinttext, HintSpawnInfo, g_MapScript.TrainingHintCB );
	
	local hintObject = Entity(SessionState.TrainingHintTargetNextName);
	local baseEnt = hintObject.GetBaseEntity();
	
	if (baseEnt != null)
	{
		if (parentEnt)
		{
			baseEnt.ValidateScriptScope();
			local scrScope = baseEnt.GetScriptScope();
			scrScope.hint <- baseEnt;
			scrScope.prop <- entity.GetBaseEntity();
			scrScope["ThinkTimer"] <- function()
			{
				if (hint.IsValid() && prop.IsValid())
					hint.SetOrigin(prop.GetOrigin());
			}
			
			if (scrScope.prop != null)
				AddThinkToEnt(baseEnt, "ThinkTimer");
		}
		
		if (duration > 0.0)
			Timers.AddTimer(duration, false, ::VSLib.Utils.RemoveEntity, hintObject);
	}
	
	SessionState.rawdelete( "TrainingHintTargetNextName" );
	
	return hintObject;
}

/**
 * Manually compares two vectors and returns true if they are equal.
 * Fix for vector instance overloaded == not firing properly
 */
function VSLib::Utils::AreVectorsEqual(vec1, vec2)
{
	return vec1.x == vec2.x && vec1.y == vec2.y && vec1.z == vec2.z;
}

/**
 * Shakes the screen with the specified amplitude at the specified location. If the location specified is
 * null, then the map is shaken globally. Returns the env_shake entity. Note that the returned entity is
 * automatically killed after its use is done.
 *
 * @authors Rayman1103, Neil
 */
function VSLib::Utils::ShakeScreen(pos = null, _amplitude = 2, _duration = 5.0, _frequency = 35, _radius = 500)
{
	local spawn = {
		classname = "env_shake",
		amplitude = _amplitude,
		duration = _duration,
		frequency = _frequency,
		radius = _radius,
		targetname = "vslib_shake_script" + UniqueString(),
		origin = pos,
		angles = QAngle(0, 0, 0)
	};
	
	if (!pos)
	{
		spawn["spawnflags"] <- 1;
		spawn["origin"] <- Vector(0, 0, 0);
	}
	else
		spawn["spawnflags"] <- 0;
	
	local env_shake = ::VSLib.Entity(g_ModeScript.CreateSingleSimpleEntityFromTable(spawn));
	env_shake.Input("StartShake");
	
	if (_duration > 0.0)
		Timers.AddTimer(_duration, false, ::VSLib.Utils.RemoveEntity, env_shake);
	
	return env_shake;
}

/**
 * Fades player's screen with the specified color, alpha, etc. Returns the env_fade entity. Note that the entity is
 * automatically killed after its use is done.
 *
 * @authors Rayman1103, Neil
 */
function VSLib::Utils::FadeScreen(player, red = 0, green = 0, blue = 0, alpha = 255, _duration = 5.0, _holdtime = 5.0, modulate = false, fadeFrom = false)
{
	local flags = 4;
	
	if (modulate)
		flags = flags | 2;
	
	if (fadeFrom)
		flags = flags | 1;
	
	local spawn = {
		classname = "env_fade",
		duration = _duration,
		holdtime = _holdtime,
		renderamt = 255,
		rendercolor = red + " " + green + " " + blue,
		spawnflags = (8 | flags),
		targetname = "vslib_fade_script" + UniqueString(),
		origin = Vector(0, 0, 0),
		angles = Vector(0, 0, 0),
		connections =
		{
			OnBeginFade =
			{
				cmd1 = ""
			}
		}
	};
	
	local env_fade = ::VSLib.Entity(g_ModeScript.CreateSingleSimpleEntityFromTable(spawn));
	env_fade.Input("Alpha", alpha);
	env_fade.Input("Fade", "", 0, player);
	
	if (_duration > 0.0)
		Timers.AddTimer(_duration + _holdtime + 1.0, false, ::VSLib.Utils.RemoveEntity, env_fade);
	
	return env_fade;
}

/**
 * Returns true if the specified classname is a valid melee weapon.
 */
function VSLib::Utils::IsValidMeleeWeapon(classname)
{
	return classname == "weapon_melee" || classname == "melee";
}

/**
 * Returns true if the specified classname is a valid fire weapon (does not include melee weapons).
 */
function VSLib::Utils::IsValidFireWeapon(weapon)
{
	return weapon.find("pistol") != null || weapon.find("shotgun") != null || weapon.find("rifle") != null || weapon.find("launcher") != null || weapon.find("sniper") != null || weapon.find("smg") != null;
}

/**
 * Returns true if the specified classname is a valid weapon (includes melee and fire weapons).
 */
function VSLib::Utils::IsValidWeapon(classname)
{
	return ::VSLib.Utils.IsValidMeleeWeapon(classname) || ::VSLib.Utils.IsValidFireWeapon(classname);
}

/**
 * Gets a random value from an array
 */
function VSLib::Utils::GetRandValueFromArray(arr, removeValue = false)
{
	local arrlen = arr.len();
	
	if (arrlen <= 0)
		return null;
	
	local idx = RandomInt( 0, arrlen - 1 );
	local arrvalue = arr[ idx ];
	if ( removeValue )
		arr.remove( idx );
	
	return arrvalue;
	//return arr[ ::VSLib.Utils.GetRandNumber(0, arrlen - 1) ];
}

/**
 * Returns a value of 1 or 2 depending on survivor set
 */
function VSLib::Utils::GetSurvivorSet()
{
	local L4D1Survs =
	[
		"!bill"
		"!francis"
		"!zoey"
		"!louis"
	]
	
	local ent = null;
	
	foreach( s in L4D1Survs )
	{
		while ( ent = Entities.FindByName( ent, s ) )
		{
			if ( ent.IsValid() )
			{
				if ( !IsPlayerABot(ent) )
				{
					return 1;
				}
			}
		}
	}
	
	return 2;
}

/**
 * Gets the base mode
 */
function VSLib::Utils::GetBaseMode()
{
	return ::VSLib.EasyLogic.BaseModeName;
}

/**
 * Gets the campaign
 */
function VSLib::Utils::GetCampaign()
{
	if ( SessionState.MapName.find("c1m") != null )
		return DEAD_CENTER;
	else if ( SessionState.MapName.find("c2m") != null )
		return DARK_CARNIVAL;
	else if ( SessionState.MapName.find("c3m") != null )
		return SWAMP_FEVER;
	else if ( SessionState.MapName.find("c4m") != null )
		return HARD_RAIN;
	else if ( SessionState.MapName.find("c5m") != null )
		return THE_PARISH;
	else if ( SessionState.MapName.find("c6m") != null )
		return THE_PASSING;
	else if ( SessionState.MapName.find("c7m") != null )
		return THE_SACRIFICE;
	else if ( SessionState.MapName.find("c8m") != null )
		return NO_MERCY;
	else if ( SessionState.MapName.find("c9m") != null )
		return CRASH_COURSE;
	else if ( SessionState.MapName.find("c10m") != null )
		return DEATH_TOLL;
	else if ( SessionState.MapName.find("c11m") != null )
		return DEAD_AIR;
	else if ( SessionState.MapName.find("c12m") != null )
		return BLOOD_HARVEST;
	else if ( SessionState.MapName.find("c13m") != null )
		return COLD_STREAM;
	else
		return 0;
}

/**
 * Gets the origin vector for the ending saferoom
 */
function VSLib::Utils::GetSaferoomLocation()
{
	local furthestDistance = 0;
	
	if ( SessionState.MapName == "c1m1_hotel" )
		return Vector( 2031.436035, 4465.583984, 1184.031250 );
	else if ( SessionState.MapName == "c3m1_plankcountry" )
		return Vector( -2666.985352, 460.419403, 56.031250 );
	else if ( SessionState.MapName == "c4m1_milltown_a" )
		return Vector( 3911.232422, -1564.834961, 232.281250 );
	else if ( SessionState.MapName == "c4m3_sugarmill_b" )
		return Vector( 3668.776123, -1693.819092, 232.281250 );
	else if ( SessionState.MapName == "c5m4_quarter" )
		return Vector( 1476.493408, -3572.280518, 64.031250 );
	else if ( SessionState.MapName == "c8m3_sewers" )
		return Vector( 12362.519531, 12528.189453, 16.031250 );
	else if ( SessionState.MapName == "c10m2_drainage" )
		return Vector( -8597.331055, -5553.929688, -30.968748 );
	else if ( SessionState.MapName == "c10m3_ranchhouse" )
		return Vector( -2563.044678, -43.700687, 160.031250 );
	else if ( SessionState.MapName == "c12m1_hilltop" )
		return Vector( -6549.538574, -6711.419434, 348.031250 );
	else if ( SessionState.MapName == "c13m3_memorialbridge" )
		return Vector( 6117.068848, -6170.154785, 386.031250 );
	else
	{
		foreach( landmark in Objects.OfClassname("info_landmark") )
		{
			local dist = ::VSLib.Utils.CalculateDistance(landmark.GetLocation(), Players.AnyAliveSurvivor().GetSpawnLocation());
			
			if ( dist > furthestDistance )
			{
				foreach( saferoomDoor in Objects.OfClassname("prop_door_rotating_checkpoint") )
				{
					if ( ::VSLib.Utils.CalculateDistance(saferoomDoor.GetLocation(), landmark.GetLocation()) < 2000 )
					{
						furthestDistance = dist;
						return landmark.GetLocation();
					}
				}
			}
		}
	}
}

::VSLib_DirectorDisabled <- false;
::VSLib_Restore_cm_DominatorLimit <- null;
::VSLib_Restore_DominatorLimit <- null;
::VSLib_Restore_cm_MaxSpecials <- null;
::VSLib_Restore_MaxSpecials <- null;
::VSLib_Restore_cm_CommonLimit <- null;
::VSLib_Restore_CommonLimit <- null;
::VSLib_Restore_SmokerLimit <- null;
::VSLib_Restore_BoomerLimit <- null;
::VSLib_Restore_HunterLimit <- null;
::VSLib_Restore_SpitterLimit <- null;
::VSLib_Restore_JockeyLimit <- null;
::VSLib_Restore_ChargerLimit <- null;
::VSLib_Restore_WitchLimit <- null;
::VSLib_Restore_cm_WitchLimit <- null;
::VSLib_Restore_TankLimit <- null;
::VSLib_Restore_cm_TankLimit <- null;
/**
 * Enables the Director
 */
function VSLib::Utils::StartDirector()
{
	if ( !::VSLib_DirectorDisabled )
		return;
	
	SessionOptions.cm_DominatorLimit = VSLib_Restore_cm_DominatorLimit;
	SessionOptions.DominatorLimit = VSLib_Restore_DominatorLimit;
	SessionOptions.cm_MaxSpecials = VSLib_Restore_cm_MaxSpecials;
	SessionOptions.cm_CommonLimit = VSLib_Restore_cm_CommonLimit;
	SessionOptions.CommonLimit = VSLib_Restore_CommonLimit;
	SessionOptions.SmokerLimit = VSLib_Restore_SmokerLimit;
	SessionOptions.BoomerLimit = VSLib_Restore_BoomerLimit;
	SessionOptions.HunterLimit = VSLib_Restore_HunterLimit;
	SessionOptions.SpitterLimit = VSLib_Restore_SpitterLimit;
	SessionOptions.JockeyLimit = VSLib_Restore_JockeyLimit;
	SessionOptions.ChargerLimit = VSLib_Restore_ChargerLimit;
	SessionOptions.WitchLimit = VSLib_Restore_WitchLimit;
	SessionOptions.cm_WitchLimit = VSLib_Restore_cm_WitchLimit;
	SessionOptions.TankLimit = VSLib_Restore_TankLimit;
	SessionOptions.cm_TankLimit = VSLib_Restore_cm_TankLimit;
}

/**
 * Disables the Director
 */
function VSLib::Utils::StopDirector()
{
	if ( ::VSLib_DirectorDisabled )
		return;
	
	if ( "cm_DominatorLimit" in SessionOptions )
		VSLib_Restore_cm_DominatorLimit = SessionOptions.cm_DominatorLimit;
	else
		VSLib_Restore_cm_DominatorLimit = 2;
	if ( "DominatorLimit" in SessionOptions )
		VSLib_Restore_DominatorLimit = SessionOptions.DominatorLimit;
	else
		VSLib_Restore_DominatorLimit = 2;
	if ( "cm_MaxSpecials" in SessionOptions )
		VSLib_Restore_cm_MaxSpecials = SessionOptions.cm_MaxSpecials;
	else
	{
		if ( ::VSLib.Utils.GetBaseMode() == "survival" )
			VSLib_Restore_cm_MaxSpecials = Convars.GetFloat("survival_max_specials");
		else
			VSLib_Restore_cm_MaxSpecials = 2;
	}
	if ( "MaxSpecials" in SessionOptions )
		VSLib_Restore_MaxSpecials = SessionOptions.MaxSpecials;
	else
	{
		if ( ::VSLib.Utils.GetBaseMode() == "survival" )
			VSLib_Restore_MaxSpecials = Convars.GetFloat("survival_max_specials");
		else
			VSLib_Restore_MaxSpecials = 2;
	}
	if ( "cm_CommonLimit" in SessionOptions )
		VSLib_Restore_cm_CommonLimit = SessionOptions.cm_CommonLimit;
	else
		VSLib_Restore_cm_CommonLimit = Convars.GetFloat("z_common_limit");
	if ( "CommonLimit" in SessionOptions )
		VSLib_Restore_CommonLimit = SessionOptions.CommonLimit;
	else
		VSLib_Restore_CommonLimit = Convars.GetFloat("z_common_limit");
	if ( "SmokerLimit" in SessionOptions )
		VSLib_Restore_SmokerLimit = SessionOptions.SmokerLimit;
	else
	{
		if ( ::VSLib.Utils.GetBaseMode() == "survival" )
			VSLib_Restore_SmokerLimit = Convars.GetFloat("survival_max_smokers");
		else if ( ::VSLib.Utils.GetBaseMode() == "versus" )
			VSLib_Restore_SmokerLimit = Convars.GetFloat("z_versus_smoker_limit");
		else
			VSLib_Restore_SmokerLimit = Convars.GetFloat("z_smoker_limit");
	}
	if ( "BoomerLimit" in SessionOptions )
		VSLib_Restore_BoomerLimit = SessionOptions.BoomerLimit;
	else
	{
		if ( ::VSLib.Utils.GetBaseMode() == "survival" )
			VSLib_Restore_BoomerLimit = Convars.GetFloat("survival_max_boomers");
		else if ( ::VSLib.Utils.GetBaseMode() == "versus" )
			VSLib_Restore_BoomerLimit = Convars.GetFloat("z_versus_boomer_limit");
		else
			VSLib_Restore_BoomerLimit = Convars.GetFloat("z_boomer_limit");
	}
	if ( "HunterLimit" in SessionOptions )
		VSLib_Restore_HunterLimit = SessionOptions.HunterLimit;
	else
	{
		if ( ::VSLib.Utils.GetBaseMode() == "survival" )
			VSLib_Restore_HunterLimit = Convars.GetFloat("survival_max_hunters");
		else if ( ::VSLib.Utils.GetBaseMode() == "versus" )
			VSLib_Restore_HunterLimit = Convars.GetFloat("z_versus_hunter_limit");
		else
			VSLib_Restore_HunterLimit = Convars.GetFloat("z_hunter_limit");
	}
	if ( "SpitterLimit" in SessionOptions )
		VSLib_Restore_SpitterLimit = SessionOptions.SpitterLimit;
	else
	{
		if ( ::VSLib.Utils.GetBaseMode() == "survival" )
			VSLib_Restore_SpitterLimit = Convars.GetFloat("survival_max_spitters");
		else if ( ::VSLib.Utils.GetBaseMode() == "versus" )
			VSLib_Restore_SpitterLimit = Convars.GetFloat("z_versus_spitter_limit");
		else
			VSLib_Restore_SpitterLimit = Convars.GetFloat("z_spitter_limit");
	}
	if ( "JockeyLimit" in SessionOptions )
		VSLib_Restore_JockeyLimit = SessionOptions.JockeyLimit;
	else
	{
		if ( ::VSLib.Utils.GetBaseMode() == "survival" )
			VSLib_Restore_JockeyLimit = Convars.GetFloat("survival_max_jockeys");
		else if ( ::VSLib.Utils.GetBaseMode() == "versus" )
			VSLib_Restore_JockeyLimit = Convars.GetFloat("z_versus_jockey_limit");
		else
			VSLib_Restore_JockeyLimit = Convars.GetFloat("z_jockey_limit");
	}
	if ( "ChargerLimit" in SessionOptions )
		VSLib_Restore_ChargerLimit = SessionOptions.ChargerLimit;
	else
	{
		if ( ::VSLib.Utils.GetBaseMode() == "survival" )
			VSLib_Restore_ChargerLimit = Convars.GetFloat("survival_max_chargers");
		else if ( ::VSLib.Utils.GetBaseMode() == "versus" )
			VSLib_Restore_ChargerLimit = Convars.GetFloat("z_versus_charger_limit");
		else
			VSLib_Restore_ChargerLimit = Convars.GetFloat("z_charger_limit");
	}
	if ( "WitchLimit" in SessionOptions )
		VSLib_Restore_WitchLimit = SessionOptions.WitchLimit;
	else
	{
		if ( ::VSLib.Utils.GetBaseMode() == "survival" )
			VSLib_Restore_WitchLimit = 0;
		else
			VSLib_Restore_WitchLimit = 1;
	}
	if ( "cm_WitchLimit" in SessionOptions )
		VSLib_Restore_cm_WitchLimit = SessionOptions.cm_WitchLimit;
	else
	{
		if ( ::VSLib.Utils.GetBaseMode() == "survival" )
			VSLib_Restore_cm_WitchLimit = 0;
		else
			VSLib_Restore_cm_WitchLimit = 1;
	}
	if ( "TankLimit" in SessionOptions )
		VSLib_Restore_TankLimit = SessionOptions.TankLimit;
	else
	{
		if ( ::VSLib.Utils.GetBaseMode() == "survival" )
			VSLib_Restore_TankLimit = 2;
		else
			VSLib_Restore_TankLimit = 1;
	}
	if ( "cm_TankLimit" in SessionOptions )
		VSLib_Restore_cm_TankLimit = SessionOptions.cm_TankLimit;
	else
	{
		if ( ::VSLib.Utils.GetBaseMode() == "survival" )
			VSLib_Restore_cm_TankLimit = 2;
		else
			VSLib_Restore_cm_TankLimit = 1;
	}
	
	SessionOptions.cm_DominatorLimit <- 0;
	SessionOptions.DominatorLimit <- 0;
	SessionOptions.cm_MaxSpecials <- 0;
	SessionOptions.MaxSpecials <- 0;
	SessionOptions.cm_CommonLimit <- 0;
	SessionOptions.CommonLimit <- 0;
	SessionOptions.SmokerLimit <- 0;
	SessionOptions.BoomerLimit <- 0;
	SessionOptions.HunterLimit <- 0;
	SessionOptions.SpitterLimit <- 0;
	SessionOptions.JockeyLimit <- 0;
	SessionOptions.ChargerLimit <- 0;
	SessionOptions.WitchLimit <- 0;
	SessionOptions.cm_WitchLimit <- 0;
	SessionOptions.TankLimit <- 0;
	SessionOptions.cm_TankLimit <- 0;
	
	::VSLib_DirectorDisabled = true;
}

/**
 * Removes all held weapons from the map.
 * @authors Rayman1103
 */
function VSLib::Utils::SanitizeHeldWeapons()
{
	EntFire( "weapon_pistol", "kill" );
	EntFire( "weapon_pistol_magnum", "kill" );
	EntFire( "weapon_smg", "kill" );
	EntFire( "weapon_pumpshotgun", "kill" );
	EntFire( "weapon_autoshotgun", "kill" );
	EntFire( "weapon_rifle", "kill" );
	EntFire( "weapon_hunting_rifle", "kill" );
	EntFire( "weapon_smg_silenced", "kill" );
	EntFire( "weapon_shotgun_chrome", "kill" );
	EntFire( "weapon_sniper_military", "kill" );
	EntFire( "weapon_shotgun_spas", "kill" );
	EntFire( "weapon_rifle_desert", "kill" );
	EntFire( "weapon_rifle_ak47", "kill" );
	EntFire( "weapon_smg_mp5", "kill" );
	EntFire( "weapon_rifle_sg552", "kill" );
	EntFire( "weapon_sniper_awp", "kill" );
	EntFire( "weapon_sniper_scout", "kill" );
	EntFire( "weapon_grenade_launcher", "kill" );
	EntFire( "weapon_rifle_m60", "kill" );
	EntFire( "weapon_melee", "kill" );
	EntFire( "weapon_chainsaw", "kill" );
}

/**
 * Removes all held primary weapons from the map.
 * @authors Rayman1103
 */
function VSLib::Utils::SanitizeHeldPrimary()
{
	EntFire( "weapon_smg", "kill" );
	EntFire( "weapon_pumpshotgun", "kill" );
	EntFire( "weapon_autoshotgun", "kill" );
	EntFire( "weapon_rifle", "kill" );
	EntFire( "weapon_hunting_rifle", "kill" );
	EntFire( "weapon_smg_silenced", "kill" );
	EntFire( "weapon_shotgun_chrome", "kill" );
	EntFire( "weapon_sniper_military", "kill" );
	EntFire( "weapon_shotgun_spas", "kill" );
	EntFire( "weapon_rifle_desert", "kill" );
	EntFire( "weapon_rifle_ak47", "kill" );
	EntFire( "weapon_smg_mp5", "kill" );
	EntFire( "weapon_rifle_sg552", "kill" );
	EntFire( "weapon_sniper_awp", "kill" );
	EntFire( "weapon_sniper_scout", "kill" );
	EntFire( "weapon_grenade_launcher", "kill" );
	EntFire( "weapon_rifle_m60", "kill" );
}

/**
 * Removes all held secondary weapons from the map.
 * @authors Rayman1103
 */
function VSLib::Utils::SanitizeHeldSecondary()
{
	EntFire( "weapon_pistol", "kill" );
	EntFire( "weapon_pistol_magnum", "kill" );
	EntFire( "weapon_melee", "kill" );
	EntFire( "weapon_chainsaw", "kill" );
}

/**
 * Removes all held items from the map.
 * @authors Rayman1103
 */
function VSLib::Utils::SanitizeHeldItems()
{
	EntFire( "weapon_pipe_bomb", "kill" );
	EntFire( "weapon_molotov", "kill" );
	EntFire( "weapon_vomitjar", "kill" );
	EntFire( "weapon_upgradepack_incendiary", "kill" );
	EntFire( "weapon_upgradepack_explosive", "kill" );
}

/**
 * Removes all held meds from the map.
 * @authors Rayman1103
 */
function VSLib::Utils::SanitizeHeldMeds()
{
	EntFire( "weapon_first_aid_kit", "kill" );
	EntFire( "weapon_pain_pills", "kill" );
	EntFire( "weapon_adrenaline", "kill" );
	EntFire( "weapon_defibrillator", "kill" );
}

/**
 * Removes all unheld weapons from the map.
 * @authors Rayman1103
 */
function VSLib::Utils::SanitizeUnheldWeapons()
{
	EntFire( "weapon_spawn", "kill" );
	EntFire( "weapon_pistol_spawn", "kill" );
	EntFire( "weapon_pistol_magnum_spawn", "kill" );
	EntFire( "weapon_smg_spawn", "kill" );
	EntFire( "weapon_pumpshotgun_spawn", "kill" );
	EntFire( "weapon_autoshotgun_spawn", "kill" );
	EntFire( "weapon_rifle_spawn", "kill" );
	EntFire( "weapon_hunting_rifle_spawn", "kill" );
	EntFire( "weapon_smg_silenced_spawn", "kill" );
	EntFire( "weapon_shotgun_chrome_spawn", "kill" );
	EntFire( "weapon_sniper_military_spawn", "kill" );
	EntFire( "weapon_shotgun_spas_spawn", "kill" );
	EntFire( "weapon_rifle_desert_spawn", "kill" );
	EntFire( "weapon_rifle_ak47_spawn", "kill" );
	EntFire( "weapon_smg_mp5_spawn", "kill" );
	EntFire( "weapon_rifle_sg552_spawn", "kill" );
	EntFire( "weapon_sniper_awp_spawn", "kill" );
	EntFire( "weapon_sniper_scout_spawn", "kill" );
	EntFire( "weapon_grenade_launcher_spawn", "kill" );
	EntFire( "weapon_rifle_m60_spawn", "kill" );
	EntFire( "weapon_melee_spawn", "kill" );
	EntFire( "weapon_chainsaw_spawn", "kill" );
}

/**
 * Removes all unheld primary weapons from the map.
 * @authors Rayman1103
 */
function VSLib::Utils::SanitizeUnheldPrimary()
{
	EntFire( "weapon_spawn", "kill" );
	EntFire( "weapon_smg_spawn", "kill" );
	EntFire( "weapon_pumpshotgun_spawn", "kill" );
	EntFire( "weapon_autoshotgun_spawn", "kill" );
	EntFire( "weapon_rifle_spawn", "kill" );
	EntFire( "weapon_hunting_rifle_spawn", "kill" );
	EntFire( "weapon_smg_silenced_spawn", "kill" );
	EntFire( "weapon_shotgun_chrome_spawn", "kill" );
	EntFire( "weapon_sniper_military_spawn", "kill" );
	EntFire( "weapon_shotgun_spas_spawn", "kill" );
	EntFire( "weapon_rifle_desert_spawn", "kill" );
	EntFire( "weapon_rifle_ak47_spawn", "kill" );
	EntFire( "weapon_smg_mp5_spawn", "kill" );
	EntFire( "weapon_rifle_sg552_spawn", "kill" );
	EntFire( "weapon_sniper_awp_spawn", "kill" );
	EntFire( "weapon_sniper_scout_spawn", "kill" );
	EntFire( "weapon_grenade_launcher_spawn", "kill" );
	EntFire( "weapon_rifle_m60_spawn", "kill" );
}

/**
 * Removes all unheld secondary weapons from the map.
 * @authors Rayman1103
 */
function VSLib::Utils::SanitizeUnheldSecondary()
{
	EntFire( "weapon_spawn", "kill" );
	EntFire( "weapon_pistol_spawn", "kill" );
	EntFire( "weapon_pistol_magnum_spawn", "kill" );
	EntFire( "weapon_melee_spawn", "kill" );
	EntFire( "weapon_chainsaw_spawn", "kill" );
}

/**
 * Removes all unheld items from the map.
 * @authors Rayman1103
 */
function VSLib::Utils::SanitizeUnheldItems()
{
	EntFire( "weapon_pipe_bomb_spawn", "kill" );
	EntFire( "weapon_molotov_spawn", "kill" );
	EntFire( "weapon_vomitjar_spawn", "kill" );
	EntFire( "weapon_upgradepack_incendiary_spawn", "kill" );
	EntFire( "weapon_upgradepack_explosive_spawn", "kill" );
	EntFire( "upgrade_item", "kill" );
	EntFire( "ammo", "kill" );
}

/**
 * Removes all unheld meds from the map.
 * @authors Rayman1103
 */
function VSLib::Utils::SanitizeUnheldMeds()
{
	EntFire( "weapon_first_aid_kit_spawn", "kill" );
	EntFire( "weapon_pain_pills_spawn", "kill" );
	EntFire( "weapon_adrenaline_spawn", "kill" );
	EntFire( "weapon_defibrillator_spawn", "kill" );
}

/**
 * Removes all miniguns from the map.
 * @authors Rayman1103
 */
function VSLib::Utils::SanitizeMiniguns()
{
	EntFire( "prop_minigun", "kill" );
	EntFire( "prop_minigun_l4d1", "kill" );
	EntFire( "prop_mounted_machine_gun", "kill" );
}

/**
 * Kills common spawn locations.
 * @authors Rayman1103
 */
function VSLib::Utils::KillZombieSpawns()
{
	EntFire( "intro_zombie_spawn", "kill" );
    EntFire( "zspawn_lobby_fall_1", "kill" );
    EntFire( "zspawn_lobby_fall_2", "kill" );
    EntFire( "zspawn_lobby_fall_3", "kill" );
    EntFire( "zspawn_lobby_fall_4", "kill" );
    EntFire( "zspawn_lobby_fall_5", "kill" );
    EntFire( "zspawn_fall_1", "kill" );
    EntFire( "zspawn_fall_2", "kill" );
    EntFire( "zombie_outro", "kill" );
    EntFire( "escape_zombie", "kill" );
    EntFire( "zspawn_zombie_safe", "kill" );
    EntFire( "zspawn_zombie_safe2", "kill" );
    EntFire( "spawn_zombie_van", "kill" );
    EntFire( "spawn_zombie_alarm", "kill" );
    EntFire( "spawn_zombie_alarm2", "kill" );
    EntFire( "zombie_spawn1", "kill" );
    EntFire( "spawn_zombie_run", "kill" );
    EntFire( "spawn_zombie_end", "kill" );
    EntFire( "infected_spawner", "kill" );
    EntFire( "infected_spawner2", "kill" );
    EntFire( "spawn_zombie_location1", "kill" );
    EntFire( "spawn_zombie_location2", "kill" );
    EntFire( "spawn_zombie_location3", "kill" );
    EntFire( "spawn_zombie_location4", "kill" );
    EntFire( "spawn_zombie_location5", "kill" );
    EntFire( "spawn_zombie_location6", "kill" );
}

/**
 * Disables car alarms.
 * @authors Rayman1103
 */
function VSLib::Utils::DisableCarAlarms()
{
    foreach (car in Objects.OfModel("models/props_vehicles/cara_95sedan_glass_alarm.mdl"))
        car.Kill();
    
    foreach (car in Objects.OfModel("models/props_vehicles/cara_95sedan_glass.mdl"))
        car.Input("enable");
    
    EntFire( "prop_car_alarm", "disable" );
    EntFire( "instructor_impound", "kill" );
    EntFire( "InstanceAuto5-remark_caralarm", "kill" );
    EntFire( "alarm1-remark_caralarm", "kill" );
    EntFire( "alarm2-remark_caralarm", "kill" );
    EntFire( "alarm3-remark_caralarm", "kill" );
    EntFire( "alarm4-remark_caralarm", "kill" );
    EntFire( "alarm5-remark_caralarm", "kill" );
    EntFire( "alarm6-remark_caralarm", "kill" );
    EntFire( "alarm7-remark_caralarm", "kill" );
    EntFire( "alarm8-remark_caralarm", "kill" );
    EntFire( "remark_caralarm-car1_alarm", "kill" );
    EntFire( "remark_caralarm-car2_alarm", "kill" );
    EntFire( "remark_caralarm-car3_alarm", "kill" );
    EntFire( "car_alarm-remark_caralarm", "kill" );
    EntFire( "remark_caralarm", "kill" );
    EntFire( "InstanceAuto1-remark_caralarm", "kill" );
    EntFire( "InstanceAuto2-remark_caralarm", "kill" );
    EntFire( "car_alarm1-remark_caralarm", "kill" );
    EntFire( "InstanceAuto12-remark_caralarm", "kill" );
    EntFire( "remark_caralarm-car1", "kill" );
    EntFire( "remark_caralarm-car2", "kill" );
    EntFire( "remark_caralarm-car3", "kill" );
    EntFire( "remark_caralarm-car4", "kill" );
    EntFire( "remark_caralarm-car5", "kill" );
    EntFire( "caralarm_1-remark_caralarm", "kill" );
    EntFire( "caralarm_2-remark_caralarm", "kill" );
    EntFire( "caralarm_3-remark_caralarm", "kill" );
    EntFire( "caralarm_4-remark_caralarm", "kill" );
    EntFire( "caralarm_6-remark_caralarm", "kill" );
    EntFire( "caralarm_7-remark_caralarm", "kill" );
    EntFire( "caralarm_8-remark_caralarm", "kill" );
    EntFire( "InstanceAuto24-remark_caralarm", "kill" );
    EntFire( "InstanceAuto44-remark_caralarm", "kill" );
    EntFire( "car1-remark_caralarm", "kill" );
    EntFire( "car2-remark_caralarm", "kill" );
    EntFire( "car3-remark_caralarm", "kill" );
    EntFire( "car4-remark_caralarm", "kill" );
    EntFire( "car5-remark_caralarm", "kill" );
    EntFire( "InstanceAuto128-remark_caralarm", "kill" );
    EntFire( "InstanceAuto4-remark_caralarm", "kill" );
    EntFire( "InstanceAuto5-remark_caralarm", "kill" );
    EntFire( "alarma1-remark_caralarm", "kill" );
    EntFire( "alarma2-remark_caralarm", "kill" );
    EntFire( "alarma3-remark_caralarm", "kill" );
    EntFire( "alarma4-remark_caralarm", "kill" );
    EntFire( "alarma5-remark_caralarm", "kill" );
    EntFire( "alarma6-remark_caralarm", "kill" );
    EntFire( "alarma7-remark_caralarm", "kill" );
    EntFire( "alarma8-remark_caralarm", "kill" );
    EntFire( "alarma9-remark_caralarm", "kill" );
}

 
 

// Add a weak reference to the global table.
::Utils <- ::VSLib.Utils.weakref();