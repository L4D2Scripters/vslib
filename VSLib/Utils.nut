/**
* Helper functions that VSLib uses.
*/
::VSLib.Utils <- {};


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
function VSLib::Utils::CombineArray(args)
{
	local str = "";
	for (local i = 0; i < args.len(); i++)
		str += args[i].tostring() + " ";
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
function VSLib::Utils::SayToTeam(str, ...)
{
	switch (vargv.len())
	{
		case 0:
			Say(null, str, true);
			break;
		case 1:
			Say(null, format(str, vargv[0]), true);
			break;
		case 2:
			Say(null, format(str, vargv[0], vargv[1]), true);
			break;
		case 3:
			Say(null, format(str, vargv[0], vargv[1], vargv[2]), true);
			break;
		case 4:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3]), true);
			break;
		case 5:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4]), true);
			break;
		case 6:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5]), true);
			break;
		case 7:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6]), true);
			break;
		case 8:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7]), true);
			break;
		case 9:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8]), true);
			break;
		case 10:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9]), true);
			break;
		case 11:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9], vargv[10]), true);
			break;
		case 12:
			Say(null, format(str, vargv[0], vargv[1], vargv[2], vargv[3], vargv[4], vargv[5], vargv[6], vargv[7], vargv[8], vargv[9], vargv[10], vargv[11]), true);
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
function VSLib::Utils::SayToTeamDel(str, ...)
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
	
	Timers.AddTimer ( 0.1, false, ::VSLib.Utils._sayfunc, { txt = temp, team = true } );
}


/**
 * Used by SayToAllDel and SayToTeamDel
 */
function VSLib::Utils::_sayfunc(args)
{
	Say(null, args.txt, args.team);
}

/**
 * Used by SayToAllDel and SayToTeamDel
 */
function VSLib::Utils::_sayfunc(args)
{
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
function VSLib::Utils::CreateEntity(_classname, pos = Vector(0,0,0), ang = Vector(0,0,0), kvs = {})
{
	kvs.classname <- _classname;
	kvs.origin <- pos;
	kvs.angles <- ang;
	
	local ent = g_ModeScript.CreateSingleSimpleEntityFromTable(kvs);
	ent.ValidateScriptScope();
	
	return ::VSLib.Entity(ent);
}

/**
 * Spawns the requested zombie via the Director
 */
function VSLib::Utils::SpawnZombie(zombieType = "default", attackOnSpawn = true)
{
	local ent = VSLib.Utils.CreateEntity("info_zombie_spawn");
	ent.SetKeyValue("population", zombieType);
	ent.SetKeyValue("AttackOnSpawn", attackOnSpawn.tointeger());
	ent.Input("SpawnZombie");
	ent.Kill();
}

/**
 * Spawns the requested zombie near a player and also
 * checks to make sure that the spawn point is not visible to
 * any survivor. Attempts to locate a position 20 times.
 * If it can't find a suitable spawn location, it'll return false.
 * Keep in mind that the closer the min and max distances are to each
 * other, the lesser the chance that a suitable spawn will be found.
 * For a good spawn chance, keep the min and max dist far apart.
 * If by chance the survivors are looking everywhere at once,
 * the infected prob won't spawn!
 */
function VSLib::Utils::SpawnZombieNearPlayer( player, zombieNum, maxDist = 128, minDist = 32 )
{
	if (maxDist < minDist)
		maxDist = minDist;
	
	local playerPos = player.GetLocation();
	
	// Loop through some pathable location :\ cmon valve, give me
	// some function to get a pos the players can't see
	for (local i = 0; i < 20; i++)
	{
		local _pos = player.GetNearbyLocation( maxDist );
		local dist = ::VSLib.Utils.CalculateDistance(_pos, playerPos);
		
		if (dist > maxDist || dist < minDist)
			continue;
		
		local canSee = false;
		
		// see if ppl can see this pos
		foreach (survivor in ::VSLib.EasyLogic.Players.Survivors())
		{
			if (survivor.CanSeeLocation(_pos))
				canSee = true;
		}
		
		if (!canSee)
		{
			ZSpawn( { type = zombieNum, pos = _pos } );
			return true;
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
function VSLib::Utils::VectorfromQAngle(angles, radius = 1.0)
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
 
 
 

// Add a weak reference to the global table.
::Utils <- ::VSLib.Utils.weakref();