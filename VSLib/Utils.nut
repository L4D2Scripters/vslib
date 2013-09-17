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
 * Spawns the requested L4D1 Survivor at the location you want.
 *
 * \todo @TODO Possibly add a way to determine if a requested survivor should glow or not.
 *
 * @authors Rayman1103
 */
function VSLib::Utils::SpawnL4D1Survivor(survivor = 4, pos = Vector(0,0,0), ang = Vector(0,0,0))
{
	local info_l4d1_survivor_spawn = g_ModeScript.CreateSingleSimpleEntityFromTable({ classname = "info_l4d1_survivor_spawn", targetname = "vslib_tmp_" + UniqueString(), origin = pos, angles = ang, character = survivor });
	
	DoEntFire( "!self", "SpawnSurvivor", "", 0, info_l4d1_survivor_spawn, info_l4d1_survivor_spawn );
	DoEntFire( "!self", "Kill", "", 0, null, info_l4d1_survivor_spawn );
}

/**
 * Spawns the requested zombie via the Director at the specified location.
 */
function VSLib::Utils::SpawnZombie(pos, zombieType = "default", attackOnSpawn = true)
{
	local ent = VSLib.Utils.CreateEntity("info_zombie_spawn", pos);
	ent.SetKeyValue("population", zombieType);
	ent.SetKeyValue("AttackOnSpawn", attackOnSpawn.tointeger());
	ent.Input("SpawnZombie");
	ent.Kill();
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
function VSLib::Utils::SpawnZombieNearPlayer( player, zombieNum, maxDist = 128.0, minDist = 32.0, checkVisibility = true, useAltSpawn = false )
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
			if ( useAltSpawn )
			{
				local ent = VSLib.Utils.CreateEntity("info_zombie_spawn", _pos);
				ent.SetKeyValue("population", zombieNum);
				ent.SetKeyValue("AttackOnSpawn", attackOnSpawn.tointeger());
				ent.Input("SpawnZombie");
				ent.Kill();
				return true;
			}
			else
			{
				ZSpawn( { type = zombieNum, pos = _pos } );
				return true;
			}
		}
	}
	
	return false;
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
function VSLib::Utils::SlowTime(desiredTimeScale = 0.2, re_Acceleration = 2.0, minBlendRate = 1.0, blendDeltaMultiplier = 2.0)
{
	if (_vsl_func_timescale == null)
	{
		_vsl_func_timescale = VSLib.Utils.CreateEntity("func_timescale");
		
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
	
	Timers.AddTimer(1.5, 0, Utils.ResumeTime, _vsl_func_timescale);
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
 * Returns a pseudorandom number from min to max
 */
function VSLib::Utils::GetRandNumber( min, max )
{
	//return rand() % (max - min + 1) + min;
	return g_MapScript.RandomInt(min, max);
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
 * Precaches a model
 *
 * @authors Rayman1103
 */
function VSLib::Utils::PrecacheModel( mdl )
{
	local Model = { classname = "prop_dynamic", model = mdl, angles = Vector(0,0,0), origin = Vector(0,0,0) }
	if ( !(mdl in ::EasyLogic.PrecachedModels) )
	{
		printf("VSLib: Precaching: %s", mdl);
		PrecacheEntityFromTable( Model );
		::EasyLogic.PrecachedModels[mdl] <- 1;
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
 * @auhors Rayman1103, Neil
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
 * @auhors Rayman1103, Neil
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
	return Utils.IsValidMeleeWeapon(classname) || Utils.IsValidFireWeapon(classname);
}

/**
 * Gets a random value from an array
 */
function VSLib::Utils::GetRandValueFromArray(arr)
{
	local arrlen = arr.len();
	
	if (arrlen <= 0)
		return null;
	
	return arr[ Utils.GetRandNumber(0, arrlen - 1) ];
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