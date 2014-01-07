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


// @see DropWeaponSlot
getconsttable()["SLOT_PRIMARY"] <- 0;
getconsttable()["SLOT_SECONDARY"] <- 1;
getconsttable()["SLOT_THROW"] <- 2;
getconsttable()["SLOT_MEDKIT"] <- 3;
getconsttable()["SLOT_PILLS"] <- 4;



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
	
	local id = _idx;
	if (!(id in ::VSLib.GlobalCache))
		return "";
	
	if ("_steam" in ::VSLib.GlobalCache[id])
		return ::VSLib.GlobalCache[id]["_steam"];
	
	return "";
}

/**
 * Gets the player's Unqiue ID (clean, formatted Steam ID).
 */
function VSLib::Player::GetUniqueID()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return "";
	}
	
	local steamid = GetSteamID();
	steamid = Utils.StringReplace(steamid, "STEAM_1:", "S");
	steamid = Utils.StringReplace(steamid, "STEAM_0:", "S");
	steamid = Utils.StringReplace(steamid, ":", "");
	
	return steamid;
}

/**
 * Gets the player's name.
 */
function VSLib::Player::GetName()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return base.GetName();
	}
	
	local id = _idx;
	if (!(id in ::VSLib.GlobalCache))
		return base.GetName();
	
	if ("_name" in ::VSLib.GlobalCache[id])
		return ::VSLib.GlobalCache[id]["_name"];
	
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
	
	local id = _idx;
	if (!(id in ::VSLib.GlobalCache))
		return "";
	
	if ("_ip" in ::VSLib.GlobalCache[id])
		return ::VSLib.GlobalCache[id]["_ip"];
	
	return "";
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
	
	return GetPlayerType() == Z_SURVIVOR && _ent.IsIncapacitated();
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
	
	return GetPlayerType() == Z_SURVIVOR && _ent.IsHangingFromLedge();
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
 * Returns the VSLib::Entity of the player's active weapon
 */
function VSLib::Player::GetActiveWeapon()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return null;
	}
	
	return _ent.GetActiveWeapon();
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
 * Returns the type of player. E.g. Z_SPITTER, Z_TANK, Z_SURVIVOR, Z_HUNTER, Z_JOCKEY, Z_SMOKER, Z_BOOMER, Z_CHARGER, Z_COMMON, or UNKNOWN.
 */
function VSLib::Player::GetPlayerType()
{
	if (!IsPlayerEntityValid())
	{
		if (IsEntityValid())
		{
			if (_ent.GetClassname() == "infected")
				return Z_COMMON;
			else if (_ent.GetClassname() == "witch")
				return Z_WITCH;
		}
		return UNKNOWN;
	}
	
	if (!("GetZombieType" in _ent))
		return UNKNOWN;
	
	return _ent.GetZombieType();
}

/**
 * Incaps the player
 */
function VSLib::Player::Incapacitate()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if (IsIncapacitated())
		return;
	
	SetRawHealth(1);
	SetHealthBuffer(0);
	Hurt(5, 0);
}

/**
 * Kills the player.
 */
function VSLib::Player::Kill()
{
	if (IsPlayerEntityValid())
		Hurt(65535, 0);
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
function VSLib::Player::CanSeeOtherEntity(otherEntity, tolerance = 50)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	// First check whether the player is even looking in its direction
	if (!CanSeeLocation(otherEntity.GetLocation(), tolerance))
		return false;
	
	// Next check to make sure it's not behind a wall or something
	local m_trace = { start = GetEyePosition(), end = otherEntity.GetLocation(), ignore = _ent, mask = g_MapScript.TRACE_MASK_SHOT };
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
 * Returns true if this player can trace a line from the eyes to the specified location.
 */
function VSLib::Player::CanTraceToLocation(finishPos, traceMask = MASK_NPCWORLDSTATIC)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	local begin = GetEyePosition();
	local finish = finishPos;
	
	local m_trace = { start = begin, end = finish, ignore = _ent, mask = traceMask };
	TraceLine(m_trace);
	
	if (Utils.AreVectorsEqual(m_trace.pos, finish))
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
 * Sets the player's health buffer.
 */
function VSLib::Player::SetHealthBuffer(value)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	_ent.SetHealthBuffer(value);
}

/**
 * Drops a weapon from a slot.
 *
 * You can use global constants SLOT_PRIMARY, SLOT_SECONDARY, SLOT_THROW,
 * SLOT_MEDKIT (also works for defibs), SLOT_PILLS (also works for adrenaline etc)
 */
function VSLib::Player::DropWeaponSlot(slot)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	
	slot = "slot" + slot;
	local t = GetHeldItems();
	
	if (t && slot in t)
	{
		local wep = Entity(t[slot]);
		wep.Kill();
	}
}

/**
 * Drops all held weapons
 */
function VSLib::Player::DropAllWeapons()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	
	local t = GetHeldItems();
	
	if (t)
		foreach (ent in t)
			Entity(ent).Kill();
}

/**
 * Gets the player's health buffer.
 */
function VSLib::Player::GetHealthBuffer()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	return _ent.GetHealthBuffer();
}

/**
 * Gets the player's valve inventory (molotov, weapons, pills, etc).
 */
function VSLib::Player::GetHeldItems()
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	local t = {};
	GetInvTable(_ent, t);
	
	return t;
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
	
	if (GetPlayerType() != Z_TANK)
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
	
	if (file == "" || !file)
		return;
	
	if ( !(file in ::EasyLogic.PrecachedSounds) )
	{
		printf("VSLib: Precaching named sound: %s", file);
		_ent.PrecacheScriptSound(file);
		::EasyLogic.PrecachedSounds[file] <- 1;
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
	
	::VSLib.EntData._objPickupTimer[_idx] <- ::VSLib.Timers.AddTimer(0.1, 1, @(pEnt) pEnt.__CalcPickups(), this);
}

/**
 * Instead of using this directly, @see AllowPickups
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
				
				HoldingEntity.SetVelocity(vecVel);
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
 * Drops the held HL2/Amnesia physics-based object or the valve-style object
 */
function VSLib::Player::DropPickup( )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	// Drop amnesia object
	::VSLib.EntData._objHolding[_idx] <- null;
	
	// Drop valve object
	if (_idx in ::VSLib.EntData._objValveHolding)
	{
		::VSLib.EntData._objValveHolding[_idx].ApplyAbsVelocityImpulse(Utils.VectorFromQAngle(GetEyeAngles(), 100));
		delete ::VSLib.EntData._objValveHolding[_idx];
	}
}


/**
 * Picks up the given VSLib Entity object
 */
function VSLib::Player::NativePickupObject( otherEnt )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	DropPickup();
	
	if (otherEnt.GetClassname() != "prop_physics")
		return;
	
	::VSLib.EntData._objValveHolding[_idx] <- otherEnt.GetBaseEntity();
	PickupObject(_ent, otherEnt.GetBaseEntity());
}

/**
 * The "give" concommand.
 *
 * @param str What to give the entity (for example, "health")
 */
function VSLib::Player::Give(str)
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	_ent.GiveItem(str);
}






/**
 * Enables Valve-style object pickups
 * @authors Neil, Rectus
 */
function VSLib::Player::BeginValvePickupObjects( pickupSound = "Defibrillator.Use", throwSound = "Adrenaline.NeedleOpen" )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	EndValvePickupObjects();
	
	::VSLib.EntData._objEnableDmg[_idx] <- false;
	::VSLib.EntData._objValveHoldDmg[_idx] <- 5;
	::VSLib.EntData._objValveThrowDmg[_idx] <- 30;
	::VSLib.EntData._objValveThrowPower[_idx] <- 100;
	::VSLib.EntData._objValvePickupRange[_idx] <- 64;
	::VSLib.EntData._objOldBtnMask[_idx] <- GetPressedButtons();
	::VSLib.EntData._objValveTimer[_idx] <- ::VSLib.Timers.AddTimer(0.1, true, @(p) p.ent.__CalcValvePickups(p.ps, p.ts), {ent = this, ps = pickupSound, ts = throwSound});
}

/**
 * Disables Valve-style object pickups
 * @authors Rectus
 */
function VSLib::Player::EndValvePickupObjects( )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if (_idx in ::VSLib.EntData._objValveTimer)
		Timers.RemoveTimer( ::VSLib.EntData._objValveTimer[_idx] );
}

/**
 * Sets the throwing force for Valve-style object pickups (default 100)
 * @authors Rectus
 */
function VSLib::Player::ValvePickupThrowPower( power )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	::VSLib.EntData._objValveThrowPower[_idx] <- power;
	
	return true;
}

/**
 * Sets the pickup range for Valve-style object pickups (default 64)
 * @authors Rectus
 */
function VSLib::Player::ValvePickupPickupRange( range )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	::VSLib.EntData._objValvePickupRange[_idx] <- range;
	
	return true;
}

/**
 * Sets the throw damage for Valve-style object pickups (default 30)
 */
function VSLib::Player::SetThrowDamage( dmg )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	::VSLib.EntData._objValveThrowDmg[_idx] <- dmg.tointeger();
}

/**
 * Sets the hold damage for Valve-style object pickups (default 5)
 */
function VSLib::Player::SetHoldDamage( dmg )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	::VSLib.EntData._objValveHoldDmg[_idx] <- dmg.tointeger();
}

/**
 * Enables or disables hold/throw damage calculation
 */
function VSLib::Player::SetDamageEnabled( isEnabled )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	::VSLib.EntData._objEnableDmg[_idx] <- isEnabled;
}

/**
 * Instead of using this directly, @see BeginValvePickupObjects
 * @authors Neil, Rectus
 */
function VSLib::Player::__CalcValvePickups( pickupSound, throwSound )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return false;
	}
	
	local curinv = GetHeldItems();
	
	if (_idx in ::VSLib.EntData._objValveHolding && (!("Held" in curinv) || ::VSLib.EntData._objValveHolding[_idx] != curinv["Held"]))
	{
		if (::VSLib.EntData._objEnableDmg[_idx])
			Timers.RemoveTimerByName("vPickup" + _idx);
		
		delete ::VSLib.EntData._objValveHolding[_idx];
		
		return;
	}
	
	local oldbuttons = ::VSLib.EntData._objOldBtnMask[_idx];
	
	local function _calcThrowDmg(params)
	{
		params.ent.HurtAround(params.dmg, 1, "", null, 64.0, [params.ignore]);
	}
	
	if (IsPressingUse() && !(oldbuttons & (1 << 5)))
	{
		local traceTable =
		{
			start = GetEyePosition()
			end = GetEyePosition() + Utils.VectorFromQAngle(GetEyeAngles(), ::VSLib.EntData._objValvePickupRange[_idx])
			ignore = _ent
			mask = g_MapScript.TRACE_MASK_SHOT 
		}

		local result = TraceLine(traceTable);
		
		if (result && "enthit" in traceTable && traceTable.enthit.GetClassname() == "prop_physics")
		{
			::VSLib.EntData._objValveHolding[_idx] <- traceTable.enthit;
			PickupObject(_ent, traceTable.enthit);
			PlaySound(pickupSound);
			
			if (::VSLib.EntData._objEnableDmg[_idx])
				Timers.AddTimerByName( "vPickup" + _idx, 0.1, true, _calcThrowDmg, { ent = Entity(::VSLib.EntData._objValveHolding[_idx]), ignore = this, dmg = ::VSLib.EntData._objValveHoldDmg[_idx] } );
		}
	}
	else if (IsPressingAttack() && _idx in ::VSLib.EntData._objValveHolding)
	{
		try
		{
			::VSLib.EntData._objValveHolding[_idx].ApplyAbsVelocityImpulse(Utils.VectorFromQAngle(GetEyeAngles(), ::VSLib.EntData._objValveThrowPower[_idx]));
			
			if (::VSLib.EntData._objEnableDmg[_idx])
				Timers.AddTimerByName( "vPickup" + _idx, 0.1, true, _calcThrowDmg, { ent = Entity(::VSLib.EntData._objValveHolding[_idx]), ignore = this, dmg = ::VSLib.EntData._objValveThrowDmg[_idx] }, TIMER_FLAG_COUNTDOWN, { count = 12 } );
			
			delete ::VSLib.EntData._objValveHolding[_idx];
			PlaySound(throwSound);
		}
		catch (id)
		{
			printl("Impulse failed! " + id);
		}
	
	}
	
	::VSLib.EntData._objOldBtnMask[_idx] <- GetPressedButtons();
}


/**
 * Returns the quantity of the requested inventory item.
 * Inventory items can be spawned with Utils::SpawnInventoryItem().
 */
function VSLib::Player::GetInventory( itemName )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return 0;
	}
	
	if (!(_idx in ::VSLib.EntData._inv))
		return 0;
	
	if (!(itemName in ::VSLib.EntData._inv[_idx]))
		return 0;
	
	return ::VSLib.EntData._inv[_idx][itemName];
}

/**
 * Sets the quantity of the specified inventory item.
 */
function VSLib::Player::SetInventory( itemName, quantity )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}
	
	if (!(_idx in ::VSLib.EntData._inv))
		::VSLib.EntData._inv[_idx] <- {};
	
	::VSLib.EntData._inv[_idx][itemName] <- quantity;
}

/**
 * Returns the player's inventory table. You can use it like this:
 * 
 * 		local inv = player.GetInventoryTable();
 * 		inv["itemName"] <- 25; // change quantity to 25
 */
function VSLib::Player::GetInventoryTable( )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return 0;
	}
	
	if (!(_idx in ::VSLib.EntData._inv))
		::VSLib.EntData._inv[_idx] <- {};
	
	return ::VSLib.EntData._inv[_idx];
}





// Allows pickups
function CanPickupObject(object)
{
	local vsent = ::VSLib.Entity(object);
	local classname = object.GetClassname();
	
	foreach (func in ::VSLib.EasyLogic.Notifications.CanPickupObject)
		if (func(vsent, classname))
			return true;
	
	foreach (obj in ::VSLib.EntData._objValveHolding)
		if (obj == object)
			return true;
	
	return false;
}



// Add a weakref
::Player <- ::VSLib.Player.weakref();