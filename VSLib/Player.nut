/*  
 * Copyright (c) 2013 LuKeM
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
 * \brief Provides many helpful player functions.
 *
 * The Player class works with ::VSLib.EasyLogic.Notifications and builds on the Entity class.
 */
class ::VSLib.Player extends ::VSLib.Entity
{
	constructor(index)
	{
		base.constructor(index);
	}
	
	function _typeof()
	{
		return "VSLIB_PLAYER";
	}
}

/**
 * Returns true if the player entity is valid or false otherwise.
 */
function VSLib::Player::IsPlayerEntityValid()
{
	if (_ent == null)
		return false;
	
	if (!("IsValid" in _ent))
		return false;
	
	if (!_ent.IsValid())
		return false;
	
	// LukeM 6/1/2013
	// Commented out the below since IsPlayer should exist for players anyway
	//if ("player" != _ent.GetClassname().tolower())
	//	return false;
	
	if ("IsPlayer" in _ent)
		return _ent.IsPlayer();
	
	return false;
}

/**
 * Gets the character name (not steam name). E.g. "Nick" or "Rochelle"
 */
function VSLib::Player::GetCharacterName()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return "";
	}
	
	return g_MapScript.GetCharacterDisplayName(_ent);
}

/**
 * Gets the player's Steam ID.
 */
function VSLib::Player::GetSteamID()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return "";
	}
	
	if ("_steam" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.EasyLogic.Cache[_idx]._steam;
	
	return null;
}

/**
 * Gets the player's name.
 */
function VSLib::Player::GetName()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return "";
	}
	
	if ("_name" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.EasyLogic.Cache[_idx]._name;
	
	return base.GetName();
}

/**
 * Gets the player's IP address.
 */
function VSLib::Player::GetIPAddress()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return "";
	}
	
	if ("_ip" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.EasyLogic.Cache[_idx]._ip;
	
	return null;
}

/**
 * Returns true if the player is alive.
 */
function VSLib::Player::IsAlive()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	return !_ent.IsDead();
	
	// No longer needed after EMS 5/29 update:
	
	//local baseStats = GetPlayerType() > 0 && !IsGhost() && !_ent.IsDead();
	//if ("_isAlive" in ::VSLib.EasyLogic.Cache[_idx])
	//	return ::VSLib.EasyLogic.Cache[_idx]._isAlive && baseStats;
}

/**
 * Returns true if the player is dead.
 */
function VSLib::Player::IsDead()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.IsDead();
}

/**
 * Returns true if the entity is incapped.
 */
function VSLib::Player::IsIncapacitated()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	if (!IsPlayer())
		return false;
	
	return GetPlayerType() == SURVIVOR && _ent.IsIncapacitated();
}

/**
 * Returns true if the entity is hanging off a ledge.
 */
function VSLib::Player::IsHangingFromLedge()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	if (!IsPlayer())
		return false;
	
	return GetPlayerType() == SURVIVOR && _ent.IsHangingFromLedge();
}

/**
 * Returns true if the entity is a bot.
 */
function VSLib::Player::IsBot()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	return IsPlayerABot(_ent);
}

/**
 * Returns true if the entity is a real human (non-bot).
 */
function VSLib::Player::IsHuman()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	return !IsBot();
}

/**
 * Returns true if the entity is in ghost mode (i.e. infected ghost).
 */
function VSLib::Player::IsGhost()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	return _ent.IsGhost();
}

/**
 * Returns true if the player is currently in the ending saferoom.
 */
function VSLib::Player::IsInEndingSafeRoom()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if ("_inSafeRoom" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.EasyLogic.Cache[_idx]._inSafeRoom;
	
	return false;
}

/**
 * Gets the player's spawn location.
 */
function VSLib::Player::GetSpawnLocation()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if ("_startPos" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.EasyLogic.Cache[_idx]._startPos;
	
	return null;
}

/**
 * Returns true if the player is still around the starting area.
 * Note that they can be outside the saferoom and still AROUND the
 * starting area. This function will return true if they are near
 * where they first spawned.
 */
function VSLib::Player::IsNearStartingArea()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	local startVec = GetSpawnLocation();
	if (!startVec)
		return false;
	
	local curpos = GetLocation();
	if (!curpos)
		return false;
	
	return ::VSLib.Utils.CalculateDistance(curpos, startVec) < 600.0;
}

/**
 * Returns the player's last attacker (the last person who hurt this player).
 * Null is returned if the "attacker" is the world or some other invalid object.
 */
function VSLib::Player::GetLastAttacker()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if ("_lastAttacker" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.EasyLogic.Cache[_idx]._lastAttacker;
	
	return null;
}

/**
 * Returns true if the player has earned some kind of award this round.
 * For example, award 67 is when a player protects another player. If you
 * do HasAward(67), the function will return true if and only if the player
 * has protected another player sometime that round. So, you ask, how do I
 * find out which number is what? Good question! Trial and error. Use
 * EasyLogic.Notifications.OnAwarded hook to find out what awards are
 * given when you do something in-game. Then use the number you find out
 * to do whatever it is that you need to do. You may be thinking that it
 * sounds complicated, but it's easier with VSLib than if you were to do
 * the same without it.
 */
function VSLib::Player::HasAward(award)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	local idx = GetIndex();
	if ("Awards" in ::VSLib.EasyLogic.Cache[idx])
		if (award in ::VSLib.EasyLogic.Cache[idx].Awards)
			return true;
	
	return false;
}

/**
 * Returns the entity or player that last killed this player. If this player
 * has not been killed yet or the killer is an invalid object, returns null.
 */
function VSLib::Player::GetLastKilledBy()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if ("_lastKilledBy" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.EasyLogic.Cache[_idx]._lastKilledBy;
	
	return null;
}

/**
 * Returns the entity or player that last defibbed this player. If this player
 * has not been defibbed or hasn't been defibbed by a valid player entity, returns null.
 */
function VSLib::Player::GetLastDefibbedBy()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if ("_lastDefibBy" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.EasyLogic.Cache[_idx]._lastDefibBy;
	
	return null;
}

/**
 * Returns the entity or player that last shoved this player. If this player
 * has not been shoved yet, returns null.
 */
function VSLib::Player::GetLastShovedBy()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if ("_lastShovedBy" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.EasyLogic.Cache[_idx]._lastShovedBy;
	
	return null;
}

/**
 * Returns the entity that this player last tried to "Use".
 * If the player has not tried to use anything yet, returns null.
 */
function VSLib::Player::GetLastUsed()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if ("_lastUse" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.Entity(::VSLib.EasyLogic.Cache[_idx]._lastUse._ent);
	
	return null;
}

/**
 * Returns the team that this player is currently on.
 */
function VSLib::Player::GetTeam()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if ("_team" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.EasyLogic.Cache[_idx]._team;
	
	return base.GetTeam();
}

/**
 * Returns the last ability that this player used.
 * E.g. "ability_lunge" or "ability_tongue" or "ability_vomit" or "ability_charge" or "ability_spit" or "ability_ride"
 * This function is applicable for SI only.
 */
function VSLib::Player::GetLastAbilityUsed()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if (GetTeam() != INFECTED)
		return null;
	
	if ("_lastAbility" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.EasyLogic.Cache[_idx]._lastAbility;
	
	return null;
}

/**
 * Returns the Player entity of the current attacker, or null if there is no entity
 * attacking this player. Note that this function will only return the current hunter,
 * smoker, charger, or jockey attacker. Boomer, tank, and spitter cannot "continuously"
 * trap the survivor and attack, so they will not be returned. If there is no SI attacking
 * this player, then null is returned. This function is applicable for Survivors only.
 */
function VSLib::Player::GetCurrentAttacker()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if (GetTeam() != SURVIVORS)
		return null;
	
	if ("_curAttker" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.EasyLogic.Cache[_idx]._curAttker;
	
	return null;
}

/**
 * Returns true if the Survivor player is trapped by an SI attacker like smoker,
 * hunter, charger, or jockey.
 */
function VSLib::Player::IsSurvivorTrapped()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	return GetTeam() == SURVIVORS && GetCurrentAttacker() != null;
}

/**
 * Commands this player to move to a particular location (only applies to bots).
 */
function VSLib::Player::BotMoveToLocation(newpos)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Bot " + _idx + " is invalid.");
		return;
	}
	
	if (!IsBot()) return;
	
	CommandABot( { cmd = 1, pos = newpos, bot = _ent } );
}

/**
 * Commands this player to move to another entity's location (only applies to bots).
 */
function VSLib::Player::BotMoveToOther(otherEntity)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Bot " + _idx + " is invalid.");
		return;
	}
	
	if (!IsBot()) return;
	
	CommandABot( { cmd = 1, pos = otherEntity.GetLocation(), bot = _ent } );
}

/**
 * Commands the other bot entity to move to this entity's location (only applies to bots).
 */
function VSLib::Player::BotMoveOtherToThis(otherEntity)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Bot " + _idx + " is invalid.");
		return;
	}
	
	if (!IsBot()) return;
	
	CommandABot( { cmd = 1, pos = GetLocation(), bot = otherEntity.GetBaseEntity() } );
}

/**
 * Commands this player to attack a particular entity (only applies to bots).
 */
function VSLib::Player::BotAttack(otherEntity)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Bot " + _idx + " is invalid.");
		return;
	}
	
	if (!IsBot()) return;
	
	CommandABot( { cmd = 0, target = otherEntity.GetBaseEntity(), bot = _ent } );
}

/**
 * Commands this player to retreat from a particular entity (only applies to bots).
 */
function VSLib::Player::BotRetreatFrom(otherEntity)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Bot " + _idx + " is invalid.");
		return;
	}
	
	if (!IsBot()) return;
	
	CommandABot( { cmd = 2, target = otherEntity.GetBaseEntity(), bot = _ent } );
}

/**
 * Returns the bot to normal after it is commanded.
 */
function VSLib::Player::BotReset()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Bot " + _idx + " is invalid.");
		return;
	}
	
	if (!IsBot()) return;
	
	CommandABot( { cmd = 3, bot = _ent } );
}

/**
 * Returns the type of player. E.g. SPITTER, TANK, SURVIVOR, HUNTER, JOCKEY, SMOKER, BOOMER, CHARGER, or UNKNOWN.
 */
function VSLib::Player::GetPlayerType()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return UNKNOWN;
	}
	
	if (!("GetZombieType" in _ent))
		return UNKNOWN;
	
	return _ent.GetZombieType();
}

/**
 * Kills the player.
 */
function VSLib::Player::Kill()
{
	if (IsPlayerEntityValid())
		ForcedHurt(65535, 0);
	else
		base.Kill();
}

/**
 * Returns true if this player can see the inputted location in their vision.
 * 
 * @param pos         The vector location that you want to check if the player can see.
 * @param tolerance   The tolerence of the result. 75 is the default Source field of view.
 */
function VSLib::Player::CanSeeLocation(targetPos, tolerance = 50)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	local clientPos = GetEyePosition();
	local clientToTargetVec = targetPos - clientPos;
	local clientAimVector = GetEyeAngles().Forward();
	
	local angToFind = acos(::VSLib.Utils.VectorDotProduct(clientAimVector, clientToTargetVec) / (clientAimVector.Length() * clientToTargetVec.Length())) * 360 / 2 / 3.14159265;
	
	if (angToFind < tolerance)
		return true;
	else
		return false;
}

/**
 * Returns true if this player can see the inputted entity.
 */
function VSLib::Player::CanSeeOtherEntity(otherEntity)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	// First check whether the player is even looking in its direction
	if (!CanSeeLocation(otherEntity.GetLocation()))
		return false;
	
	// Next check to make sure it's not behind a wall or something
	local m_trace = { start = GetEyePosition(), end = otherEntity.GetLocation(), ignore = _ent };
	TraceLine(m_trace);
	
	if (!m_trace.hit || m_trace.enthit == null || m_trace.enthit == _ent)
		return false;
	
	if (m_trace.enthit.GetClassname() == "worldspawn" || !m_trace.enthit.IsValid())
		return false;
		
	if (m_trace.enthit == otherEntity.GetBaseEntity())
		return true;
	
	return false;
}

/**
 * Sends a client command to the player entity.
 * \todo @TODO Doesn't work, need to fix.
 */
function VSLib::Player::ClientCommand(str)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	local cl_cmd = g_ModeScript.CreateSingleSimpleEntityFromTable({ classname = "point_clientcommand", origin = GetLocation(), angles = Vector(0,0,0) });
	if (!cl_cmd)
	{
		printf("VSLib Error: Could not exec cl_cmd; entity is invalid!");
		return;
	}
	if (!cl_cmd.IsValid())
	{
		printf("VSLib Error: Could not exec cl_cmd; entity is invalid!");
		return;
	}
	DoEntFire("!self", "Command", str.tostring(), 0, _ent, cl_cmd);
	cl_cmd.Kill();
}

/**
 * Changes the flashlight state.
 */
function VSLib::Player::SetFlashlight(turnFlashOn)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if (turnFlashOn)
		SetEffects(4);
	else
		SetEffects(0);
}

/**
 * Gets the position where the player last died, or null if the player has not died yet
 */
function VSLib::Player::GetLastDeathLocation()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if ("_deathPos" in ::VSLib.EasyLogic.Cache[_idx])
		return ::VSLib.EasyLogic.Cache[_idx]._deathPos;
}

/**
 * Sets the player's revive count
 */
function VSLib::Player::SetReviveCount(count)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if(_idx in ::VSLib.EasyLogic.Cache)
		if ("_reviveCount" in ::VSLib.EasyLogic.Cache[_idx])
			::VSLib.EasyLogic.Cache[_idx]._reviveCount <- count;
	
	_ent.SetReviveCount(count);
}

/**
 * Gets the player's revive count, or null if the player does not have revive information yet
 */
function VSLib::Player::GetReviveCount()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if(_idx in ::VSLib.EasyLogic.Cache)
		if ("_reviveCount" in ::VSLib.EasyLogic.Cache[_idx])
			return ::VSLib.EasyLogic.Cache[_idx]._reviveCount;
}

/**
 * Revives a player (also checks if player is incapped first).
 * Returns true if the player was revived.
 */
function VSLib::Player::Revive()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	if (IsIncapacitated())
	{
		_ent.ReviveFromIncap();
		return true;
	}
	
	return false;
}

/**
 * Defibs a dead player (also checks if player is dead first).
 * Returns true if the player was defibbed.
 */
function VSLib::Player::Defib()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	if (IsDead())
	{
		_ent.ReviveByDefib();
		return true;
	}
	
	return false;
}

/**
 * Vomits on the player
 */
function VSLib::Player::Vomit()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	_ent.HitWithVomit();
}

/**
 * Gets the last player who vomited this player, or returns null if the player
 * has not been vomited on yet OR has not been vomited on by a valid player
 */
function VSLib::Player::GetLastVomitedBy()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if(_idx in ::VSLib.EasyLogic.Cache)
		if ("_lastVomitedBy" in ::VSLib.EasyLogic.Cache[_idx])
			return ::VSLib.EasyLogic.Cache[_idx]._lastVomitedBy;
}

/**
 * Returns true if this player was ever vomited this round
 */
function VSLib::Player::WasEverVomited()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	if(_idx in ::VSLib.EasyLogic.Cache)
		if ("_wasVomited" in ::VSLib.EasyLogic.Cache[_idx])
			return ::VSLib.EasyLogic.Cache[_idx]._wasVomited;
	
	return false;
}

/**
 * Staggers this entity
 */
function VSLib::Player::Stagger()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	_ent.Stagger( Vector(0,0,0) );
}

/**
 * Staggers this entity away from another entity
 */
function VSLib::Player::StaggerAwayFromEntity(otherEnt)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	local loc = otherEnt.GetLocation();
	if (loc != null) _ent.Stagger( loc );
}

/**
 * Staggers this entity away from another location
 */
function VSLib::Player::StaggerAwayFromLocation(loc)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	_ent.Stagger( loc );
}

/**
 * Gives the player an upgrade
 */
function VSLib::Player::GiveUpgrade(upgrade)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	_ent.GiveUpgrade( upgrade ) ;
}

/**
 * Removes the player's upgrade
 */
function VSLib::Player::RemoveUpgrade(upgrade)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	_ent.RemoveUpgrade( upgrade ) ;
}

/**
 * Returns true if the player is a tank and is frustrated
 */
function VSLib::Player::IsFrustrated()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	if (GetPlayerType() != TANK)
		return false;
	
	if(_idx in ::VSLib.EasyLogic.Cache)
		if ("_isFrustrated" in ::VSLib.EasyLogic.Cache[_idx])
			return ::VSLib.EasyLogic.Cache[_idx]._isFrustrated;
}

/**
 * Gives the entity an adrenaline effect
 */
function VSLib::Player::GiveAdrenaline( time )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	_ent.UseAdrenaline( time ) ;
}

/**
 * Gets the userid of the entity
 */
function VSLib::Player::GetUserId()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetPlayerUserId();
}

/**
 * Gets the survivor slot
 */
function VSLib::Player::GetSurvivorSlot()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetSurvivorSlot();
}

/**
 * Gives ammo
 */
function VSLib::Player::GiveAmmo( amount )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	_ent.GiveAmmo(amount);
}

/**
 * Gets a valid path point within a radius
 */
function VSLib::Player::GetNearbyLocation( radius )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	return _ent.TryGetPathableLocationWithin(radius);
}

/**
 * Gets flow distance
 */
function VSLib::Player::GetFlowDistance()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	return g_MapScript.GetCurrentFlowDistanceForPlayer(_ent);
}

/**
 * Gets flow percent
 */
function VSLib::Player::GetFlowPercent()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	return g_MapScript.GetCurrentFlowPercentForPlayer(_ent);
}

/**
 * Plays a sound file to the player
 */
function VSLib::Player::PlaySound( file )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	g_MapScript.EmitSoundOnClient(file, _ent);
}

/**
 * Stops a sound on the player
 */
function VSLib::Player::StopSound( file )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	g_MapScript.StopSoundOn( file, _ent );
}


/**
 * Stops Amnesia/HL2 style object pickups
 */
function VSLib::Player::DisablePickups( )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if (_idx in ::VSLib.EntData._objPickupTimer)
		Timers.RemoveTimer(::VSLib.EntData._objPickupTimer[_idx]);
}

/**
 * Enables Amnesia/HL2 style object pickups
 */
function VSLib::Player::AllowPickups( BTN_PICKUP, BTN_THROW )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	DisablePickups();
	
	::VSLib.EntData._objBtnPickup[_idx] <- BTN_PICKUP;
	::VSLib.EntData._objBtnThrow[_idx] <- BTN_THROW;
	::VSLib.EntData._objOldBtnMask[_idx] <- GetPressedButtons();
	::VSLib.EntData._objHolding[_idx] <- null;
	::VSLib.EntData._objLastVel[_idx] <- Vector(0,0,0);
	
	::VSLib.EntData._objPickupTimer[_idx] <- ::VSLib.Timers.AddTimer(0.1, 1, @(pEnt) pEnt.__CalcPickups(), this);
}

/**
 * Warning: Do not use! Instead @see AllowPickups
 */
function VSLib::Player::__CalcPickups( )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	// Update global entity cache
	local buttons = GetPressedButtons();
	local OldButtons = ::VSLib.EntData._objOldBtnMask[_idx];
	local btnPickup = ::VSLib.EntData._objBtnPickup[_idx];
	local btnThrow = ::VSLib.EntData._objBtnThrow[_idx];
	local HoldingEntity = ::VSLib.EntData._objHolding[_idx];
	local LastVel = ::VSLib.EntData._objLastVel[_idx];
	
	// Constants -- \todo @TODO Make these user-configurable
	const DISTANCE_TO_HOLD = 100.0
	const DISTANCE_CLOSE = 256.0;
	const OBJECT_SPEED = 25.0;
	const THROW_SPEED = 1000.0;
	
	// Are they trying to pick up an object?
	if (buttons & btnPickup && !(OldButtons & btnPickup) && HoldingEntity == null && !(buttons & btnThrow) && !IsIncapacitated() && !IsHangingFromLedge())
	{
		// Are they looking at a valid grabbable entity?
		// If so, then cache it.
		local object = GetLookingEntity();
		if (object != null)
			::VSLib.EntData._objHolding[_idx] <- object;
	}
	
	// Are they holding an object?
	else if (buttons & btnPickup && OldButtons & btnPickup && !(buttons & btnThrow) &&
			HoldingEntity != null && !IsIncapacitated() && !IsHangingFromLedge())
	{
		if (HoldingEntity.IsEntityValid())
		{	
			local eyeAngles = GetEyeAngles();
			if (eyeAngles == null) return;
			local vecDir = eyeAngles.Forward();
			
			local vecPos = GetEyePosition();
			if (vecPos == null) return;
			
			local holdPos = HoldingEntity.GetLocation();
			if (holdPos == null) return;
			
			if (Utils.CalculateDistance(vecPos, holdPos) < DISTANCE_CLOSE)
			{
				// update object 
				vecPos.x += vecDir.x * DISTANCE_TO_HOLD;
				vecPos.y += vecDir.y * DISTANCE_TO_HOLD;
				vecPos.z += vecDir.z * DISTANCE_TO_HOLD;
				
				local vecVel = vecPos - holdPos;
				vecVel = vecVel.Scale(OBJECT_SPEED);
				
				HoldingEntity.Push(vecVel - LastVel);
				::VSLib.EntData._objLastVel[_idx] <- vecVel;
			}
			else
			{
				// Entity is no longer valid
				DropPickup();
			}
		}
	}
	// Are they trying to throw the object?
	else if(buttons & btnPickup && OldButtons & btnPickup && buttons & btnThrow && HoldingEntity != null)
	{
		if (HoldingEntity.IsEntityValid())
		{
			// then throw it!
			local eyeAngles = GetEyeAngles();
			if (eyeAngles == null) return;
			local speed = eyeAngles.Forward().Scale(THROW_SPEED);
			HoldingEntity.Push(speed);
			DropPickup();
		}
	}
	// Are they letting go of an object?
	else if (!(buttons & btnPickup) && OldButtons & btnPickup && HoldingEntity != null)
	{
		if (HoldingEntity.IsEntityValid())
		{	
			// let go of the object
			DropPickup();
		}
	}
	
	// Cache old buttons
	::VSLib.EntData._objOldBtnMask[_idx] <- buttons;
}

/**
 * Drops the held HL2/Amnesia physics-based object
 */
function VSLib::Player::DropPickup( )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	::VSLib.EntData._objHolding[_idx] <- null;
}





// Add a weakref
::Player <- ::VSLib.Player.weakref();