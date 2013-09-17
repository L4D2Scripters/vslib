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
 * The EasyLogic table provides helper functions that automate laborious processes.
 *
 * \todo @TODO some of these can be moved to Utils table
 */
::VSLib.EasyLogic <-
{
	// Chat triggers
	_itChatFunction = {}
	_itChatTextIndex = {}
	_itChatCount = 0
	_triggerStart = "!"
	
	// Intercept chat hooks
	_interceptCount = 0
	_interceptList = {}
	
	// Update() hooks
	Update = {}
	
	// Easier chat triggers
	Triggers = {}
	
	// Easier damage hooks
	OnDamage = {}
	OnTakeDamage = {}
	
	// User defined data storage
	UserDefinedVars = {}
	
	// Player/object helpers
	Players = {}
	Objects = {}
	
	// Round variables
	RoundVars =
	{
		function _newslot(key,value)
		{
			::VSLib.EasyLogic.OrigRoundVars[key] <- value;
			return value;
		}
	}
	
	OrigRoundVars = {}
	
	// Holds precached sounds
	PrecachedSounds = {}
	
	// Holds precached models
	PrecachedModels = {}
}

// Game event wrapper.
// Just add any events that you want here. The actual event information follows this table.
::VSLib.EasyLogic.Notifications <-
{
	// General events
	OnAwarded = {}
	OnDoorClosed = {}
	OnDoorOpened = {}
	OnFinaleWon = {}
	OnRescueVehicleReady = {}
	OnRescueVehicleLeaving = {}
	OnFinaleWin = {}
	OnRoundStart = {}
	OnRoundEnd = {}
	OnMapEnd = {}
	
	// General player events (both infected and survivors)
	OnPlayerJoined = {}
	OnDeath = {}
	OnInfectedDeath = {}
	OnZombieDeath = {}
	OnEnterSaferoom = {}
	OnLeaveSaferoom = {}
	OnHurt = {}
	OnSpawn = {}
	OnPostSpawn = {}
	OnFirstSpawn = {}
	OnShoved = {}
	OnUse = {}
	OnTeamChanged = {}
	OnNameChanged = {}
	OnGrabbedLedge = {}
	OnReleasedLedge = {}
	
	// General infected events
	OnAbilityUsed = {}
	OnPanicEvent = {}
	OnInfectedHurt = {}
	OnWitchStartled = {}
	OnWitchKilled = {}
	OnZombieIgnited = {}
	
	// Survivor events
	OnDefibSuccess = {}
	OnAdrenalineUsed = {}
	OnHealStart = {}
	OnHealEnd = {}
	OnHealSuccess = {}
	OnPillsUsed = {}
	OnIncapacitated = {}
	OnJump = {}
	FirstSurvLeftStartArea = {}
	OnSurvivorsLeftStartArea = {}
	OnReviveBegin = {}
	OnReviveEnd = {}
	OnReviveSuccess = {}
	OnWeaponGiven = {}
	OnWeaponFire = {}
	OnWeaponFireEmpty = {}
	OnWeaponReload = {}
	OnWeaponZoom = {}
	OnItemPickup = {} // Called when a player picks up a weapon, ammo, etc (see Notifications::CanPickupObject if you want to block pickups)
	OnSurvivorRescued = {}
	
	// Charger events
	OnChargerCharged = {}
	OnChargerCarryVictim = {}
	OnChargerCarryVictimEnd = {}
	OnChargerImpact = {}
	OnChargerPummelBegin = {}
	OnChargerPummelEnd = {}
	
	// Smoker events
	OnSmokerChokeBegin = {}
	OnSmokerChokeEnd = {}
	OnSmokerChokeStopped = {}
	OnSmokerTongueReleased = {}
	OnSmokerTongueGrab = {}
	
	// Spitter events
	OnEnterSpit = {}
	
	// Jockey
	OnJockeyRideStart = {}
	OnJockeyRideEnd = {}
	
	// Hunter
	OnHunterPouncedVictim = {}
	OnHunterPounceStopped = {}
	OnHunterReleasedVictim = {}
	
	// Boomer
	OnPlayerVomited = {}
	
	// Tank
	OnTankPissed = {}
	OnTankKilled = {}
	OnTankSpawned = {}
	
	// Misc
	OnDifficulty = {}
	OnSurvivorsDead = {}
	OnPickupInvItem = {} // Called when a player tries to pickup an item spawned with Utils.SpawnInventoryItem()
	CanPickupObject = {} // Called when a player tries to pickup a game-related item (such as some prop or weapon)
}

/**
 * Global constants
 */
// "Difficulty" to be used with OnDifficulty()
getconsttable()["EASY"] <- "Easy";
getconsttable()["NORMAL"] <- "Normal";
getconsttable()["ADVANCED"] <- "Hard";
getconsttable()["EXPERT"] <- "Expert";

// Create entity data cache system
::VSLib.EasyLogic.Cache <- {};

/*
 * All the game events are below. Note how we wrap the events to make the
 * interface easy to use and much more organized. For example, "OnEnterSafeRoom"
 * is much easier to understand than "player_entered_checkpoint". Also, we pass
 * the major event table params as individual paramaters to the function hooks,
 * enabling the data to be used quickly and efficiently. That also removes
 * a lot of repetitive logic by organizing common tasks in ::VSLib.EasyLogic.
 *
 * \todo @TODO This stuff can get repetitive... fast. A function to group similar instructions would be nice. 
 */

function OnGameEvent_player_hurt(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	local _id = ents.entity.GetIndex();
	if(_id in ::VSLib.EasyLogic.Cache)
		::VSLib.EasyLogic.Cache[_id]._lastAttacker <- ents.attacker;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnHurt)
		func(ents.entity, ents.attacker, params);
}

function OnGameEvent_award_earned(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local subjectentid = ::VSLib.EasyLogic.GetEventInt(params, "subjectentid");
	local award = ::VSLib.EasyLogic.GetEventInt(params, "award");
	
	local idx = ents.entity.GetIndex();
	if (!("Awards" in ::VSLib.EasyLogic.Cache[idx]))
		::VSLib.EasyLogic.Cache[idx].Awards <- {};
	::VSLib.EasyLogic.Cache[idx].Awards[award] <- true;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnAwarded)
		func(ents.entity, subjectentid, award, params);
}

function OnGameEvent_door_close(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local checkpoint = ::VSLib.EasyLogic.GetEventInt(params, "checkpoint");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnDoorClosed)
		func(ents.entity, checkpoint, params);
}

function OnGameEvent_door_open(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local checkpoint = ::VSLib.EasyLogic.GetEventInt(params, "checkpoint");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnDoorOpened)
		func(ents.entity, checkpoint, params);
}

function OnGameEvent_finale_vehicle_leaving(params)
{
	local count = ::VSLib.EasyLogic.GetEventInt(params, "survivorcount");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnRescueVehicleLeaving)
		func(count, params);
}

function OnGameEvent_finale_vehicle_ready(params)
{
	local campaign = ::VSLib.EasyLogic.GetEventString(params, "campaign");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnRescueVehicleReady)
		func(campaign, params);
}

function OnGameEvent_finale_win(params)
{
	local map_name = ::VSLib.EasyLogic.GetEventString(params, "map_name");
	local diff = ::VSLib.EasyLogic.GetEventInt(params, "difficulty");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnFinaleWin)
		func(map_name, diff, params);
}

function OnGameEvent_difficulty_changed(params)
{
	local newDiff = params["newDifficulty"].tointeger();
	local diff = "";
	
	if (newDiff == 0) // just a guess...
		diff = "Easy";
	else if (newDiff == 1)
		diff = "Normal";
	else if (newDiff == 2)
		diff = "Hard";
	else if (newDiff == 3)
		diff = "Expert";
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnDifficulty)
		func(diff);
}



function VSLib_ResetRoundVars()
{
	// reset round vars
	foreach (idx, var in ::VSLib.EasyLogic.OrigRoundVars)
		::VSLib.EasyLogic.RoundVars[idx] = var;
}

function VSLib_RemoveDeadTimers()
{
	// Clear timer cache
	if ("Timers" in VSLib)
	{
		if ("TimersList" in ::VSLib.Timers)
		{
			foreach (idx, timer in ::VSLib.Timers.TimersList)
			{
				if ( !(timer._flags & TIMER_FLAG_KEEPALIVE) )
					delete ::VSLib.Timers.TimersList[idx];
			}
		}
	}
}

function VSLib_ResetCache()
{
	// clear the cache
	::VSLib.EasyLogic.Cache.clear();
	
	// Re-create entity data cache system
	::VSLib.EasyLogic.Cache <- {};
	for (local i = -1; i < 2048; i++)
		::VSLib.EasyLogic.Cache[i] <- { Awards = {} };
	
	for (local i = -1; i <= 64; i++)
	{
		::VSLib.EasyLogic.Cache[i]._isAlive <- true;
	}
}

function OnGameEvent_round_start_post_nav(params)
{
	VSLib_ResetRoundVars();
	VSLib_ResetCache();
	
	::VSLib.GlobalCache <- ::VSLib.FileIO.LoadTable( "_vslib_global_cache" );
	if (::VSLib.GlobalCache == null)
		::VSLib.GlobalCache <- {};
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnRoundStart)
		func(params);
		
	local diff = Convars.GetStr( "z_difficulty" );
	foreach (func in ::VSLib.EasyLogic.Notifications.OnDifficulty)
		func(diff);
}

function OnGameEvent_map_transition (params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnMapEnd)
		func();
}

function OnGameEvent_mission_lost (params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSurvivorsDead)
		func(params);
}

function OnGameEvent_round_end(params)
{
	VSLib_ResetRoundVars();
	VSLib_ResetCache();
	VSLib_RemoveDeadTimers();
	
	local winner = ::VSLib.EasyLogic.GetEventInt(params, "winner"); // team or player
	local reason = ::VSLib.EasyLogic.GetEventInt(params, "reason");
	local message = ::VSLib.EasyLogic.GetEventString(params, "message");
	local time = ::VSLib.EasyLogic.GetEventFloat(params, "time");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnRoundEnd)
		func(winner, reason, message, time, params);
}


function RetryConnect(params)
{
	g_ModeScript.OnGameEvent_player_connect(params);
}

function OnGameEvent_player_connect(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local name = ::VSLib.EasyLogic.GetEventString(params, "name");
	local ipAddress = ::VSLib.EasyLogic.GetEventString(params, "address");
	local steamID = ::VSLib.EasyLogic.GetEventString(params, "networkid");
	
	if (ents.entity != null)
	{
		local _id = ents.entity.GetIndex();
		
		if (_id in ::VSLib.GlobalCache)
			delete ::VSLib.GlobalCache[_id];
		
		::VSLib.GlobalCache[_id] <- {};
		::VSLib.GlobalCache[_id]["_name"] <- name;
		::VSLib.GlobalCache[_id]["_ip"] <- ipAddress;
		::VSLib.GlobalCache[_id]["_steam"] <- steamID;
		
		// Save our changes to the global cache
		::VSLib.FileIO.SaveTable( "_vslib_global_cache", ::VSLib.GlobalCache );
		
		foreach (func in ::VSLib.EasyLogic.Notifications.OnPlayerJoined)
			func(ents.entity, name, ipAddress, steamID, params);
	}
	else
	{
		::VSLib.Timers.AddTimer(1, false, RetryConnect, params);
	}
}


function OnGameEvent_player_changename(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local oldname = ::VSLib.EasyLogic.GetEventString(params, "oldname");
	local newname = ::VSLib.EasyLogic.GetEventString(params, "newname");
	
	local _id = ents.entity.GetIndex();
	if(_id in ::VSLib.EasyLogic.Cache)
		::VSLib.EasyLogic.Cache[_id]._name <- newname;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnNameChanged)
		func(ents.entity, oldname, newname, params);
}

function OnGameEvent_player_death(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	if (ents.entity == null) return;
	if (!ents.entity.IsPlayerEntityValid()) return;
	
	local idx = ents.entity.GetIndex();
	::VSLib.EasyLogic.Cache[idx]._isAlive <- false;
	::VSLib.EasyLogic.Cache[idx]._lastKilledBy <- ents.attacker;
	::VSLib.EasyLogic.Cache[idx]._deathPos <- ents.entity.GetLocation();
	::VSLib.EasyLogic.Cache[idx]._isFrustrated <- false;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnDeath)
		func(ents.entity, ents.attacker, params);
}

function OnGameEvent_item_pickup(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnItemPickup)
		func(ents.entity, "weapon_" + params["item"], params);
}
	
function OnGameEvent_defibrillator_used(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local reviver = ents.entity;
	local subject = ::VSLib.EasyLogic.GetEventPlayer(params, "subject");
	
	local idx = subject.GetIndex();
	::VSLib.EasyLogic.Cache[idx]._isAlive <- true;
	::VSLib.EasyLogic.Cache[idx]._lastDefibBy <- reviver;
	::VSLib.EasyLogic.Cache[idx]._reviveCount <- 0;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnDefibSuccess)
		func(subject, reviver, params);
}

function OnGameEvent_player_entered_checkpoint(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	local _id = ents.entity.GetIndex();
	if(_id in ::VSLib.EasyLogic.Cache)
		::VSLib.EasyLogic.Cache[_id]._inSafeRoom <- true;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnEnterSaferoom)
		func(ents.entity, params);
}

function OnGameEvent_player_left_checkpoint(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	local _id = ents.entity.GetIndex();
	if(_id in ::VSLib.EasyLogic.Cache)
		::VSLib.EasyLogic.Cache[_id]._inSafeRoom <- false;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnLeaveSaferoom)
		func(ents.entity, params);
}

function OnGameEvent_player_jump(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnJump)
		func(ents.entity, params);
}

function _OnPostSpawnEv(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	if (ents.entity == null || !("IsPlayerEntityValid" in ents.entity))
		return false;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPostSpawn)
		func(ents.entity, params);
}

function OnGameEvent_player_spawn(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local _id = ents.entity.GetIndex();
	
	if (!(_id in ::VSLib.EasyLogic.Cache))
		::VSLib.EasyLogic.Cache[_id] <- {};
		
	::VSLib.EasyLogic.Cache[_id]._isAlive <- true;
	::VSLib.EasyLogic.Cache[_id]._reviveCount <- 0;
	::VSLib.EasyLogic.Cache[_id]._startPos <- ents.entity.GetLocation();
	
	// Remove any bots off the global cache
	if (ents.entity.IsBot() && _id in ::VSLib.GlobalCache)
		delete ::VSLib.GlobalCache[_id];
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSpawn)
		func(ents.entity, params);
	
	Timers.AddTimer(1.0, false, _OnPostSpawnEv, params);
}

function OnGameEvent_player_first_spawn(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnFirstSpawn)
		func(ents.entity, params);
}

function OnGameEvent_player_shoved(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	local _id = ents.entity.GetIndex();
	if(_id in ::VSLib.EasyLogic.Cache)
		::VSLib.EasyLogic.Cache[_id]._lastShovedBy <- ents.attacker;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnShoved)
		func(ents.entity, ents.attacker, params);
}

function OnGameEvent_player_use(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local targetid = ::VSLib.EasyLogic.GetEventPlayer(params, "targetid");
	
	local _id = ents.entity.GetIndex();
	if(_id in ::VSLib.EasyLogic.Cache)
		::VSLib.EasyLogic.Cache[_id]._lastUse <- targetid;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnUse)
		func(ents.entity, targetid, params);
}

function OnGameEvent_player_team(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local oldteam = ::VSLib.EasyLogic.GetEventInt(params, "oldteam");
	local newteam = ::VSLib.EasyLogic.GetEventInt(params, "team");
	
	local _id = ents.entity.GetIndex();
	if(_id in ::VSLib.EasyLogic.Cache)
		::VSLib.EasyLogic.Cache[_id]._team <- newteam;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnTeamChanged)
		func(ents.entity, oldteam, newteam, params);
}

function OnGameEvent_ability_use(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local ability = ::VSLib.EasyLogic.GetEventString(params, "ability");
	
	local _id = ents.entity.GetIndex();
	if(_id in ::VSLib.EasyLogic.Cache)
		::VSLib.EasyLogic.Cache[_id]._lastAbility <- ability;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnAbilityUsed)
		func(ents.entity, ability, params);
}

function OnGameEvent_create_panic_event(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPanicEvent)
		func(ents.entity, params);
}

function OnGameEvent_infected_hurt(params)
{
	local infected = EasyLogic.GetEventEntity(params, "entityid");
	local attacker = EasyLogic.GetEventPlayer(params, "attacker");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnInfectedHurt)
		func(infected, attacker, params);
}

function OnGameEvent_infected_death(params)
{
	local infected = EasyLogic.GetEventEntity(params, "infected_id");
	local attacker = EasyLogic.GetEventPlayer(params, "attacker");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnInfectedDeath)
		func(infected, attacker, params);
}

function OnGameEvent_zombie_death(params)
{
	local infected = EasyLogic.GetEventEntity(params, "infected_id");
	local victim = EasyLogic.GetEventEntity(params, "victim");
	local attacker = EasyLogic.GetEventPlayer(params, "attacker");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnZombieDeath)
		func(infected, victim, attacker, params);
}

function OnGameEvent_witch_harasser_set(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local witchid = ::VSLib.EasyLogic.GetEventPlayer(params, "witchid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnWitchStartled)
		func(witchid, ents.entity, params);
}

function OnGameEvent_witch_killed(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local witchid = ::VSLib.EasyLogic.GetEventPlayer(params, "witchid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnWitchKilled)
		func(witchid, ents.entity, params);
}

function OnGameEvent_zombie_ignited(params)
{
	local attacker = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "entityid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnZombieIgnited)
		func(victim, attacker, params);
}

function OnGameEvent_adrenaline_used(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnAdrenalineUsed)
		func(ents.entity, params);
}

function OnGameEvent_heal_begin(params)
{
	local healer = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local healee = ::VSLib.EasyLogic.GetEventPlayer(params, "subject");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnHealStart)
		func(healee, healer, params);
}

function OnGameEvent_heal_end(params)
{
	local healer = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local healee = ::VSLib.EasyLogic.GetEventPlayer(params, "subject");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnHealEnd)
		func(healee, healer, params);
}

function OnGameEvent_heal_success(params)
{
	local healer = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local healee = ::VSLib.EasyLogic.GetEventPlayer(params, "subject");
	local health = ::VSLib.EasyLogic.GetEventInt(params, "health_restored");
	
	local _id = healee.GetIndex();
	if(_id in ::VSLib.EasyLogic.Cache)
		::VSLib.EasyLogic.Cache[_id]._reviveCount <- 0;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnHealSuccess)
		func(healee, healer, health, params);
}

function OnGameEvent_pills_used(params)
{
	local healee = ::VSLib.EasyLogic.GetEventPlayer(params, "subject");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPillsUsed)
		func(healee, params);
}

function OnGameEvent_player_incapacitated(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnIncapacitated)
		func(ents.entity, ents.attacker, params);
}

function OnGameEvent_player_left_start_area(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.FirstSurvLeftStartArea)
		func(ents.entity, params);
}



::VSLib.EasyLogic.PlayersLeftStart <- false;

function VSLib::EasyLogic::Update::_VSLib_SurvsLeft()
{
	if ( ::VSLib.EasyLogic.PlayersLeftStart == false && Director.HasAnySurvivorLeftSafeArea() )
	{
		::VSLib.EasyLogic.PlayersLeftStart <- true;
		survivors_left_start_area();
	}
}

function survivors_left_start_area()
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSurvivorsLeftStartArea)
		func();
}



function OnGameEvent_revive_begin(params)
{
	local revivor = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local revivee = ::VSLib.EasyLogic.GetEventPlayer(params, "subject");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnReviveBegin)
		func(revivee, revivor, params);
}

function OnGameEvent_revive_end(params)
{
	local revivor = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local revivee = ::VSLib.EasyLogic.GetEventPlayer(params, "subject");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnReviveEnd)
		func(revivee, revivor, params);
}

function OnGameEvent_revive_success(params)
{
	local revivor = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local revivee = ::VSLib.EasyLogic.GetEventPlayer(params, "subject");
	
	local _id = revivee.GetIndex();
	if(_id in ::VSLib.EasyLogic.Cache)
	{
		if ( !("_reviveCount" in ::VSLib.EasyLogic.Cache[_id]) )
			::VSLib.EasyLogic.Cache[_id]._reviveCount <- 0;
		
		::VSLib.EasyLogic.Cache[_id]._reviveCount++;
	}
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnReviveSuccess)
		func(revivee, revivor, params);
}

function OnGameEvent_weapon_given(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local giver = ::VSLib.EasyLogic.GetEventPlayer(params, "giver");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnWeaponGiven)
		func(ents.entity, giver, params);
}

function OnGameEvent_weapon_fire(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnWeaponFire)
		func(ents.entity, params);
}

function OnGameEvent_weapon_fire_on_empty(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnWeaponFireEmpty)
		func(ents.entity, params);
}
function OnGameEvent_weapon_reload(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local manual = ::VSLib.EasyLogic.GetEventInt(params, "manual");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnWeaponReload)
		func(ents.entity, (manual > 0) ? true : false, params);
}

function OnGameEvent_weapon_zoom(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnWeaponZoom)
		func(ents.entity, params);
}

function OnGameEvent_charger_charge_start(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnChargerCharged)
		func(ents.entity, params);
}

function OnGameEvent_charger_carry_end(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnChargerCarryVictimEnd)
		func(ents.entity, victim, params);
}

function OnGameEvent_charger_carry_start(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnChargerCarryVictim)
		func(ents.entity, victim, params);
}

function OnGameEvent_charger_impact(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnChargerImpact)
		func(ents.entity, victim, params);
}

function OnGameEvent_charger_pummel_start(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	::VSLib.EasyLogic.Cache[victim.GetIndex()]._curAttker <- ents.entity;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnChargerPummelBegin)
		func(ents.entity, victim, params);
}

function OnGameEvent_charger_pummel_end(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	::VSLib.EasyLogic.Cache[victim.GetIndex()]._curAttker <- null;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnChargerPummelEnd)
		func(ents.entity, victim, params);
}

function OnGameEvent_choke_start(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	::VSLib.EasyLogic.Cache[victim.GetIndex()]._curAttker <- ents.entity;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSmokerChokeBegin)
		func(ents.entity, victim, params);
}

function OnGameEvent_choke_stopped(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	local smoker = ::VSLib.EasyLogic.GetEventPlayer(params, "smoker");
	
	::VSLib.EasyLogic.Cache[victim.GetIndex()]._curAttker <- null;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSmokerChokeStopped)
		func(smoker, victim, ents.entity, params);
}

function OnGameEvent_choke_end(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	::VSLib.EasyLogic.Cache[victim.GetIndex()]._curAttker <- null;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSmokerChokeEnd)
		func(ents.entity, victim, params);
}

function OnGameEvent_tongue_release(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	::VSLib.EasyLogic.Cache[victim.GetIndex()]._curAttker <- null;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSmokerTongueReleased)
		func(ents.entity, victim, params);
}

function OnGameEvent_tongue_grab(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	::VSLib.EasyLogic.Cache[victim.GetIndex()]._curAttker <- ents.entity;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSmokerTongueGrab)
		func(ents.entity, victim, params);
}

function OnGameEvent_entered_spit(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnEnterSpit)
		func(ents.entity, params);
}

function OnGameEvent_jockey_ride(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	local _id = ents.entity.GetIndex();
	if(_id in ::VSLib.EasyLogic.Cache)
		::VSLib.EasyLogic.Cache[_id]._lastAbility <- "ability_ride";
	::VSLib.EasyLogic.Cache[victim.GetIndex()]._curAttker <- ents.entity;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnJockeyRideStart)
		func(ents.entity, victim, params);
}

function OnGameEvent_jockey_ride_end(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	::VSLib.EasyLogic.Cache[victim.GetIndex()]._curAttker <- null;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnJockeyRideEnd)
		func(ents.entity, victim, params);
}

function OnGameEvent_lunge_pounce(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	::VSLib.EasyLogic.Cache[victim.GetIndex()]._curAttker <- ents.entity;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnHunterPouncedVictim)
		func(ents.entity, victim, params);
}

function OnGameEvent_pounce_stopped(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	::VSLib.EasyLogic.Cache[victim.GetIndex()]._curAttker <- null;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnHunterPounceStopped)
		func(ents.entity, victim, params);
}

function OnGameEvent_pounce_end(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	if (!victim) return; if (!victim.IsPlayerEntityValid()) return;
	
	::VSLib.EasyLogic.Cache[victim.GetIndex()]._curAttker <- null;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnHunterReleasedVictim)
		func(ents.entity, victim, params);
}

function OnGameEvent_player_now_it(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	local _id = ents.entity.GetIndex();
	::VSLib.EasyLogic.Cache[_id]._lastVomitedBy <- ents.attacker;
	::VSLib.EasyLogic.Cache[_id]._wasVomited <- true;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPlayerVomited)
		func(ents.entity, ents.attacker, params);
}

function OnGameEvent_tank_frustrated(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	local _id = ents.entity.GetIndex();
	::VSLib.EasyLogic.Cache[_id]._isFrustrated <- true;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnTankPissed)
		func(ents.entity, params);
}

function OnGameEvent_tank_killed(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnTankKilled)
		func(ents.entity, ents.attacker, params);
}

function OnGameEvent_tank_spawn(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnTankSpawned)
		func(ents.entity, params);
}

function OnGameEvent_survivor_rescued(params)
{
	local rescuer = EasyLogic.GetEventPlayer(params, "rescuer");
	local victim = EasyLogic.GetEventPlayer(params, "victim");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSurvivorRescued)
		func(rescuer, victim, params);
}

function OnGameEvent_player_ledge_grab(params)
{
	local causer = EasyLogic.GetEventPlayer(params, "causer");
	local victim = EasyLogic.GetEventPlayer(params, "userid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnGrabbedLedge)
		func(causer, victim, params);
}

function OnGameEvent_player_ledge_release(params)
{
	local victim = EasyLogic.GetEventPlayer(params, "userid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnReleasedLedge)
		func(victim, params);
}

//
//  END OF NOTIFICATION EVENTS.
//
//	Below are wrapper functions for notifications.
//

/**
 * Returns an integer value for the specified field, or null if it does not exist.
 */
function VSLib::EasyLogic::GetEventInt(params, field)
{
	if (field in params)
		if (params[field] != "" && params[field] != null)
			return params[field].tointeger();
	
	return null;
}

/**
 * Returns an Entity for the specified field (Entity index), or null if it does not exist.
 */
function VSLib::EasyLogic::GetEventEntity(params, field)
{
	if (field in params)
		if (params[field] != "" && params[field] != null)
			return ::VSLib.Entity(params[field].tointeger());
	
	return null;
}

/**
 * Returns a float value for the specified field, or null if it does not exist.
 */
function VSLib::EasyLogic::GetEventFloat(params, field)
{
	if (field in params)
		if (params[field] != "" && params[field] != null)
			return params[field].tofloat();
	
	return null;
}

/**
 * Returns a string value for the specified field, or null if it does not exist.
 */
function VSLib::EasyLogic::GetEventString(params, field)
{
	if (field in params)
		if (params[field] != "" && params[field] != null)
			return params[field].tostring();
	
	return null;
}

/**
 * Returns a player for the specified field, or null if it does not exist.
 */
function VSLib::EasyLogic::GetEventPlayer(params, field)
{
	if (field in params)
	{
		if (params[field] != "" && params[field] != null)
		{
			local ent = GetPlayerFromUserID(params[field]);
			if (!ent)
				ent = ::VSLib.Player(params[field].tointeger());
			else
				ent = ::VSLib.Player(ent);
			
			return ent;
		}
	}
	
	return null;
}

/**
 * This function returns the ::VSLib.Entity vars of the game event.
 * It sorts through "entity" and "userid" as well as attackers.
 * It will return a table of { entity, attacker }, and the value
 * will be null if it does not exist.
 */
function VSLib::EasyLogic::GetPlayersFromEvent(params)
{
	local ent = null;
	local atk = null;
	
	if ("userid" in params)
	{
		if (params["userid"] != null && params["userid"] != "")
			ent = GetPlayerFromUserID(params["userid"]);
	}
	else if ("entityid" in params)
	{
		if (params["entityid"] != null && params["entityid"] != "")
			ent = EntIndexToHScript(params["entityid"]);
	}
	
	if ("attacker" in params)
		if (params["attacker"] != null && params["attacker"] != "")
			atk = GetPlayerFromUserID(params["attacker"]);
	
	if (ent && atk)
		return { entity = ::VSLib.Player(ent), attacker = ::VSLib.Player(atk) };
	else if (ent)
		return { entity = ::VSLib.Player(ent), attacker = atk };
	else
		return { entity = ent, attacker = atk };
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	Below is the part of EasyLogic that incorporates SourceMod/HammerCode-like
//	chat triggers. For example, typing "!hello" into a chatbox can execute a function
//	that you want.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


/**
 * Adds a chat trigger.
 * For example, AddChatTrigger("test", someFunc) will cause someFunc() to fire when a player
 * types !test into their chatbox.
 */
function VSLib::EasyLogic::AddChatTrigger(trigger_text, func)
{
	local trigger = _triggerStart + trigger_text;
	
	// do not double up on triggers
	foreach (idx, v in _itChatTextIndex)
	{
		if (v == trigger_text)
			delete _itChatTextIndex[idx];
	}
	
	_itChatTextIndex[_itChatCount] <- trigger;
	_itChatFunction[_itChatCount] <- func;
	
	_itChatCount++;
}

/**
 * Removes a chat trigger.
 */
function VSLib::EasyLogic::RemoveChatTrigger(trigger_text)
{
	local trigger = _triggerStart + trigger_text;
	
	foreach (i, v in _itChatTextIndex)
	{
		if (v == trigger)
		{
			_itChatFunction[i] <- null;
			_itChatTextIndex[i] <- null;
			
			break;
		}
	}
}

/**
 * Changes the chat trigger starting text (e.g. the exclamation point).
 * Note that any triggers added before changing the starting text are
 * invalidated.
 */
function VSLib::EasyLogic::ChangeChatTriggerStartText(start_text)
{
	_triggerStart = start_text;
}

/**
 * Adds an InterceptChat() callback (in case you don't want to use the chat trigger feature).
 */
function VSLib::EasyLogic::AddInterceptChat(func)
{
	foreach (v in _interceptList)
	{
		if (v == func)
			return;
	}
	
	_interceptList[_interceptCount] <- func;
	_interceptCount++;
}

/**
 * Removes an InterceptChat() callback.
 */
function VSLib::EasyLogic::RemoveInterceptChat(func)
{
	foreach(i, v in _interceptList)
	{
		if (v == func)
		{
			_interceptList[i] <- null;
			break;
		}
	}
}

/**
 * Valve forward: Used by EasyLogic to implement chat triggers
 */
function InterceptChat( str, srcEnt )
{
	if (srcEnt != null)
	{
		// Strip the name from the chat text
		local name = srcEnt.GetName() + ": ";
		local text = strip(str.slice(str.find(name) + name.len()));

		if (text.find(::VSLib.EasyLogic._triggerStart) == 0)
		{
			// Separate the commands and arguments
			local arr = split(text, " ");
			
			// Identify the command
			local cmd = arr[0];
			
			// Build an argument array
			local args = {};
			local idx = 0;
			foreach (k, v in arr)
			{
				if (k != 0 && v != null && v != "")
				{
					args[idx] <- v;
					idx++;
				}
			}
			
			// Store it.
			::VSLib.EasyLogic.LastArgs <- args;
			
			local player = ::VSLib.Player(srcEnt);
			
			// Execute the permanent triggers
			local baseCmd = split(cmd, ::VSLib.EasyLogic._triggerStart)[0];
			if (baseCmd)
			{
				if (baseCmd in ::VSLib.EasyLogic.Triggers)
					::VSLib.EasyLogic.Triggers[baseCmd](player, args, text);
			}
			
			// Execute the removable trigger (if it is a trigger).
			foreach (i, trigger in ::VSLib.EasyLogic._itChatTextIndex)
			{
				if (trigger == cmd)
				{
					::VSLib.EasyLogic._itChatFunction[i](player, args, text);
					break;
				}
			}
		}
	}
	
	// Fire any intercept hooks
	foreach(v in ::VSLib.EasyLogic._interceptList)
	{
		if (v != null)
			v(str, srcEnt);
	}
}

/**
 * Retrieves an argument or returns null if the argument is not specified.
 * Note that you can reference the arguments array directly if you need to.
 */
function VSLib::EasyLogic::GetArgument(idx)
{
	if (!(idx-1 in ::VSLib.EasyLogic.LastArgs))
		return null;
	
	return ::VSLib.EasyLogic.LastArgs[idx-1];
}




//////////////////////////////////////////////////////////////////////////////////////////
// Player helpers
//////////////////////////////////////////////////////////////////////////////////////////


/**
 * Returns a table of all bots.
 */
function VSLib::EasyLogic::Players::Bots()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.IsBot())
				t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns a table of all players.
 */
function VSLib::EasyLogic::Players::All()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns a table of all special infected.
 */
function VSLib::EasyLogic::Players::Infected()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.GetTeam() == INFECTED)
				t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns a table of all common infected.
 */
function VSLib::EasyLogic::Players::CommonInfected()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "infected"))
	{
		if (ent.IsValid())
			t[++i] <- ::VSLib.Player(ent);
	}
	
	return t;
}

/**
 * Returns a table of all survivors.
 */
function VSLib::EasyLogic::Players::Survivors()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.GetTeam() == SURVIVORS)
				t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns a table of all alive survivors.
 */
function VSLib::EasyLogic::Players::AliveSurvivors()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.GetTeam() == SURVIVORS && libObj.IsAlive())
				t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns one valid survivor, or null if none exist
 */
function VSLib::EasyLogic::Players::AnySurvivor()
{
	local ent = null;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.GetTeam() == SURVIVORS)
				return libObj;
		}
	}
	
	return null;
}

/**
 * Returns one valid alive survivor, or null if none exist
 */
function VSLib::EasyLogic::Players::AnyAliveSurvivor()
{
	local ent = null;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.GetTeam() == SURVIVORS && libObj.IsAlive())
				return libObj;
		}
	}
	
	return null;
}

/**
 * Returns one RANDOM valid alive survivor, or null if none exist
 */
function VSLib::EasyLogic::Players::RandomAliveSurvivor()
{
	return Utils.GetRandValueFromArray(Players.AliveSurvivors());
}

/**
 * Returns one valid alive survivor with the highest flow distance, or null if none exist
 */
function VSLib::EasyLogic::Players::SurvivorWithHighestFlow()
{
	local player = null;
	local flow = -1;
	local ent = null;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.GetTeam() == SURVIVORS && libObj.IsAlive())
			{
				local dist = libObj.GetFlowDistance();
				if (dist > flow)
				{
					player = libObj;
					flow = dist;
				}
			}
		}
	}
	
	return player;
}

/**
 * Returns a table of all human players.
 */
function VSLib::EasyLogic::Players::Humans()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (!libObj.IsBot())
				t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns a table of all infected of a specific type.
 */
function VSLib::EasyLogic::Players::OfType(playerType)
{
	playerType = playerType.tointeger();
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.GetPlayerType() == playerType)
				t[++i] <- libObj;
		}
	}
	
	return t;
}


/**
 * Returns a table of L4D1 survivors.
 */
function VSLib::EasyLogic::Objects::L4D1Survivors()
{
	local t = {};
	local ent = null;
	local i = -1;
	
	local L4D1Survs =
	[
		"!bill"
		"!francis" 
		"!zoey" 
		"!louis"
	]
	
	foreach (s in L4D1Survs)
	{
		while (ent = Entities.FindByName( ent, s ))
		{
			if (ent.IsValid())
			{
				local libObj = ::VSLib.Entity(ent);
				t[++i] <- libObj;
			}
		}
	}
	
	return t;
}

/**
 * Returns all entities of a specific classname.
 *
 * E.g. foreach ( object in Objects.OfClassname("prop_physics") ) ...
 */
function VSLib::EasyLogic::Objects::OfClassname(classname)
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, classname))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Entity(ent);
			t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns a single entity of the specified classname, or null if non-existent
 */
function VSLib::EasyLogic::Objects::AnyOfClassname(classname)
{
	local ent = null;
	while (ent = Entities.FindByClassname(ent, classname))
	{
		if (ent.IsValid())
			return ::VSLib.Entity(ent);
	}
	
	return null;
}

/**
 * Returns all entities around a radius.
 *
 * E.g. foreach ( object in Objects.AroundRadius(pos, radius) ) ...
 */
function VSLib::EasyLogic::Objects::AroundRadius(pos, radius)
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindInSphere(ent, pos, radius))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Entity(ent);
			t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns all infected/survivors (including commons) around specified position and radius.
 * If you need to find infected/survivors around a PLAYER instead, just pass in the player's
 * position with player.GetLocation()
 */
function VSLib::EasyLogic::Objects::AliveAroundRadius(pos, radius)
{
	local t = AroundRadius(pos, radius);
	
	foreach (idx, ent in t)
		if (ent.GetClassname() != "player" && ent.GetClassname() != "infected")
			delete t[idx];
		else if (::VSLib.Player(ent).IsDead()) // tag on a branched if statement
			delete t[idx];
	
	return t;
}

/**
 * Returns all entities of a particular model.
 */
function VSLib::EasyLogic::Objects::OfModel(model)
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByModel(ent, model))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Entity(ent);
			t[++i] <- libObj;
		}
	}
	
	return t;
}








////////////////////////////////////////////////////////////////////////////////////////////////////////
// Update Hooks
////////////////////////////////////////////////////////////////////////////////////////////////////////

function Update()
{
	foreach (update in ::VSLib.EasyLogic.Update)
		update();
}







// Lastly, we reference EasyLogic in the global table.
::EasyLogic <- ::VSLib.EasyLogic.weakref();
::GetArgument <- ::VSLib.EasyLogic.GetArgument.weakref();
::Vars <- ::VSLib.EasyLogic.UserDefinedVars.weakref();
::RoundVars <- ::VSLib.EasyLogic.RoundVars.weakref();
::Notifications <- ::VSLib.EasyLogic.Notifications.weakref();
::ChatTriggers <- ::VSLib.EasyLogic.Triggers.weakref();
::Players <- ::VSLib.EasyLogic.Players.weakref();
::Objects <- ::VSLib.EasyLogic.Objects.weakref();



// Set the delegates
foreach (row in ::VSLib.EasyLogic.Notifications)
	row.setdelegate(::g_MapScript);
foreach (row in ::VSLib.EasyLogic)
	if ("setdelegate" in row)
		row.setdelegate(::g_MapScript);