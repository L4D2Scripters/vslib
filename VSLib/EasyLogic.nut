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
	
	// Bash hooks
	OnBash = {}
	
	// User command hooks
	OnUserCommand = {}
	
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
	
	// These are used for custom event notifications
	PreSpawnFired = false
	PlayersSpawned = false
	PlayersLeftStart = false
	
	// This is used to store the base mode name
	BaseModeName = ""
	CheckedMode = false
	
	// This is used to store the current difficulty
	Difficulty = ""
}

// Game event wrapper.
// Just add any events that you want here. The actual event information follows this table.
::VSLib.EasyLogic.Notifications <-
{
	// General events
	OnAwarded = {}
	OnInstructorDraw = {}
	OnInstructorNoDraw = {}
	OnServerHintCreated = {}
	OnServerHintStopped = {}
	OnDoorClosed = {}
	OnDoorOpened = {}
	OnDoorUnlocked = {}
	OnRescueVehicleIncoming = {}
	OnRescueVehicleReady = {}
	OnRescueVehicleLeaving = {}
	OnGauntletFinaleStart = {}
	OnFinaleStart = {}
	OnFinaleWin = {}
	OnEscapeStarted = {}
	OnPreRadioStart = {}
	OnReloadedScriptedHud = {}
	OnRoundStartPreEntity = {}
	OnRoundStart = {}
	OnRoundBegin = {}
	OnRoundFreezeEnd = {}
	OnRoundEnd = {}
	OnMapEnd = {}
	OnNavBlocked = {}
	OnSurvivalStart = {}
	OnVersusStart = {}
	OnScavengeStart = {}
	OnScavengeHalftime = {}
	OnScavengeOvertime = {}
	OnScavengeRoundFinished = {}
	OnScavengeTied = {}
	OnScavengeMatchFinished = {}
	OnVersusMarkerReached = {}
	OnVersusMatchFinished = {}
	OnServerCvarChanged = {}
	OnServerPreShutdown = {}
	OnServerShutdown = {}
	OnTriggeredCarAlarm = {}
	
	// General player events (both infected and survivors)
	OnPlayerJoined = {}
	OnPlayerConnected = {}
	OnPlayerLeft = {}
	OnDeath = {}
	OnInfectedDeath = {}
	OnZombieDeath = {}
	OnMeleeKill = {}
	OnEnterStartArea = {}
	OnEnterSaferoom = {}
	OnLeaveSaferoom = {}
	OnHurt = {}
	OnHurtConcise = {}
	OnActivate = {}
	OnPreSpawn = {}
	OnSpawn = {}
	OnPostSpawn = {}
	OnFirstSpawn = {}
	OnEntityShoved = {}
	OnPlayerShoved = {}
	OnEntityVisible = {}
	OnWeaponSpawnVisible = {}
	OnDeadSurvivorVisible = {}
	OnCheckpointButtonWaiting = {}
	OnCheckpointButtonUsed = {}
	OnCheckpointDoorWaiting = {}
	OnCheckpointDoorWaitingVersus = {}
	OnHitSafeRoom = {}
	OnRescueDoorOpened = {}
	OnMountedGunUsed = {}
	OnMountedGunOverheated = {}
	OnUse = {}
	OnTeamChanged = {}
	OnNameChanged = {}
	OnGrabbedLedge = {}
	OnReleasedLedge = {}
	OnPourCompleted = {}
	OnPourBlocked = {}
	OnPourInterrupted = {}
	OnPlayerReplacedBot = {}
	OnBotReplacedPlayer = {}
	OnSay = {}
	OnVoteCastYes = {}
	OnVoteCastNo = {}
	
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
	OnIncapacitatedStart = {}
	OnJump = {}
	OnJumpApex = {}
	FirstSurvLeftStartArea = {}
	OnSurvivorsLeftStartArea = {}
	OnSurvivorsSpawned = {}
	OnReviveBegin = {}
	OnReviveEnd = {}
	OnReviveSuccess = {}
	OnFriendlyFire = {}
	OnGascanDropped = {}
	OnWeaponDropped = {}
	OnWeaponGiven = {}
	OnWeaponFire = {}
	OnWeaponFireAt40 = {}
	OnWeaponFireEmpty = {}
	OnWeaponReload = {}
	OnWeaponZoom = {}
	OnItemPickup = {} // Called when a player picks up a weapon, ammo, etc (see Notifications::CanPickupObject if you want to block pickups)
	OnAmmoPickup = {}
	OnAmmoCantUse = {}
	OnSpawnerGaveItem = {}
	OnSurvivorCallForHelp = {}
	OnSurvivorRescueAbandoned = {}
	OnSurvivorRescued = {}
	OnUpgradeDeploying = {}
	OnUpgradeDeployed = {}
	OnUpgradeReceived = {}
	
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
	OnSmokerPullStopped = {}
	OnSmokerTongueReleased = {}
	OnSmokerTongueGrab = {}
	
	// Spitter events
	OnSpitLanded = {}
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
	OnPlayerVomitEnd = {}
	OnBoomerExploded = {}
	OnBoomerNear = {}
	
	// Tank
	OnTankFrustrated = {}
	OnTankKilled = {}
	OnTankSpawned = {}
	OnSpawnedAsTank = {}
	
	// Achievements
	OnPunchedClown = {}
	OnInfectedDecapitated = {}
	OnNonMeleeFired = {}
	OnMolotovThrown = {}
	OnForcedGasCanDrop = {}
	OnStrongmanBellKnockedOff = {}
	OnStashwhackerGameWon = {}
	OnChargerKilled = {}
	OnSpitterKilled = {}
	OnJockeyKilled = {}
	OnVomitBombTank = {}
	
	// Misc
	OnDifficulty = {}
	OnSurvivorsDead = {}
	OnBrokeProp = {}
	OnPickupInvItem = {} // Called when a player tries to pickup an item spawned with Utils.SpawnInventoryItem()
	CanPickupObject = {} // Called when a player tries to pickup a game-related item (such as some prop or weapon)
	OnModeStart = {}
}

/**
 * Global constants
 */
// "Difficulty" to be used with OnDifficulty()
getconsttable()["EASY"] <- "easy";
getconsttable()["NORMAL"] <- "normal";
getconsttable()["ADVANCED"] <- "hard";
getconsttable()["EXPERT"] <- "impossible";

// Create entity data cache system
::VSLib.EasyLogic.Cache <- {};

// Create user data cache system
::VSLib.EasyLogic.UserCache <- {};

function VSLib_OnCoop()
{
	::VSLib.EasyLogic.BaseModeName <- "coop";
}

function VSLib_OnVersus()
{
	::VSLib.EasyLogic.BaseModeName <- "versus";
}

function VSLib_OnSurvival()
{
	::VSLib.EasyLogic.BaseModeName <- "survival";
}

function VSLib_OnScavenge()
{
	::VSLib.EasyLogic.BaseModeName <- "scavenge";
}

function VSLib_OnMode( speaker, query )
{
	if ( "GameMode" in query )
		::VSLib.EasyLogic.BaseModeName <- query.gamemode;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnModeStart)
		func(query.gamemode);
}

function VSLib_SpawnInfoGamemode()
{
	local _vsl_info_gamemode = VSLib.Utils.SpawnEntity("info_gamemode", "vslib_gamemode");
	_vsl_info_gamemode.ConnectOutput( "OnCoopPostIO", VSLib_OnCoop );
	_vsl_info_gamemode.ConnectOutput( "OnVersusPostIO", VSLib_OnVersus );
	_vsl_info_gamemode.ConnectOutput( "OnSurvivalPostIO", VSLib_OnSurvival );
	_vsl_info_gamemode.ConnectOutput( "OnScavengePostIO", VSLib_OnScavenge );
}

if ( !Entities.FindByName( null, "vslib_gamemode" ) )
	VSLib_SpawnInfoGamemode();

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

function OnGameEvent_player_hurt_concise(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnHurtConcise)
		func(ents.entity, ents.attacker, params);
}

function OnGameEvent_award_earned(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local subjectentid = ::VSLib.EasyLogic.GetEventInt(params, "subjectentid");
	local award = ::VSLib.EasyLogic.GetEventInt(params, "award");
	
	local idx = ents.entity.GetIndex();
	
	if(!(idx in ::VSLib.EasyLogic.Cache))
		::VSLib.EasyLogic.Cache[idx] <- {};
	if (!("Awards" in ::VSLib.EasyLogic.Cache[idx]))
		::VSLib.EasyLogic.Cache[idx].Awards <- {};
	::VSLib.EasyLogic.Cache[idx].Awards[award] <- true;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnAwarded)
		func(ents.entity, subjectentid, award, params);
}

function OnGameEvent_gameinstructor_draw(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnInstructorDraw)
		func();
}

function OnGameEvent_gameinstructor_nodraw(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnInstructorNoDraw)
		func();
}

function OnGameEvent_instructor_server_hint_create(params)
{
	local player = ::VSLib.EasyLogic.GetEventInt(params, "userid");
	if ( player != 0 )
		player = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local entity = ::VSLib.EasyLogic.GetEventEntity(params, "hint_entindex");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnServerHintCreated)
		func(player, entity, params);
}

function OnGameEvent_instructor_server_hint_stop(params)
{
	local entity = ::VSLib.EasyLogic.GetEventEntity(params, "hint_entindex");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnServerHintStopped)
		func(entity, params);
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

function OnGameEvent_door_unlocked(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local checkpoint = ::VSLib.EasyLogic.GetEventInt(params, "checkpoint");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnDoorUnlocked)
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

function OnGameEvent_finale_vehicle_incoming(params)
{
	local campaign = ::VSLib.EasyLogic.GetEventString(params, "campaign");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnRescueVehicleIncoming)
		func(campaign, params);
}

function OnGameEvent_gauntlet_finale_start(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnGauntletFinaleStart)
		func();
}

function OnGameEvent_finale_start(params)
{
	local campaign = ::VSLib.EasyLogic.GetEventString(params, "campaign");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnFinaleStart)
		func(campaign, params);
}

function OnGameEvent_finale_win(params)
{
	local map_name = ::VSLib.EasyLogic.GetEventString(params, "map_name");
	local diff = ::VSLib.EasyLogic.GetEventInt(params, "difficulty");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnFinaleWin)
		func(map_name, diff, params);
}

function OnGameEvent_finale_escape_start(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnEscapeStarted)
		func(params);
}

function OnGameEvent_started_pre_radio(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPreRadioStart)
		func(params);
}

function OnGameEvent_difficulty_changed(params)
{
	local newDiff = params["newDifficulty"].tointeger();
	local diff = "";
	
	if (newDiff == 0)
		diff = "easy";
	else if (newDiff == 1)
		diff = "normal";
	else if (newDiff == 2)
		diff = "hard";
	else if (newDiff == 3)
		diff = "impossible";
	
	::VSLib.EasyLogic.Difficulty <- diff;
	
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
		::VSLib.EasyLogic.Cache[i]._isAlive <- true;
}

function OnGameEvent_round_start_pre_entity(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnRoundStartPreEntity)
		func();
}

function OnGameEvent_round_start_post_nav(params)
{
	// Restore and save session tables
	RestoreTable( "_vslib_global_cache_session", ::VSLib.GlobalCacheSession );
	SaveTable( "_vslib_global_cache_session", ::VSLib.GlobalCacheSession );
	
	::VSLib.GlobalCache <- ::VSLib.FileIO.LoadTable( "_vslib_global_cache" );
	if (::VSLib.GlobalCache == null)
	{
		::VSLib.GlobalCache <- {};
		
		// Attempt read from session
		::VSLib.GlobalCache <- Utils.DeserializeIdxTable(::VSLib.GlobalCacheSession);
		
		if (::VSLib.GlobalCache == null)
			::VSLib.GlobalCache <- {};
	}
	
	if ( Entities.FindByName( null, "vslib_gamemode" ) )
	{
		foreach( vslib_gamemode in Objects.OfName("vslib_gamemode") )
			vslib_gamemode.Kill();
		
		if ( ::VSLib.EasyLogic.BaseModeName == "" )
			::VSLib.EasyLogic.BaseModeName <- SessionState.ModeName;
	}
	
	local diff = Convars.GetStr( "z_difficulty" ).tolower();
	::VSLib.EasyLogic.Difficulty <- diff;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnRoundStart)
		func();
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnDifficulty)
		func(diff);
}

function OnGameEvent_round_start(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnRoundBegin)
		func(params);
}

function OnGameEvent_round_freeze_end(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnRoundFreezeEnd)
		func();
}

function OnGameEvent_map_transition(params)
{
	SaveTable( "_vslib_user_cache", ::VSLib.EasyLogic.UserCache );
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnMapEnd)
		func();
}

function OnGameEvent_scriptedmode_reloadhud(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnReloadedScriptedHud)
		func();
}

function OnGameEvent_survival_round_start(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSurvivalStart)
		func();
}

function OnGameEvent_versus_round_start(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnVersusStart)
		func();
}

function OnGameEvent_scavenge_round_start(params)
{
	local round = ::VSLib.EasyLogic.GetEventInt(params, "round");
	local firsthalf = ::VSLib.EasyLogic.GetEventInt(params, "firsthalf");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnScavengeStart)
		func(round, (firsthalf > 0) ? true : false, params);
}

function OnGameEvent_scavenge_round_halftime(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnScavengeHalftime)
		func();
}

function OnGameEvent_begin_scavenge_overtime(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnScavengeOvertime)
		func();
}

function OnGameEvent_scavenge_round_finished(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnScavengeRoundFinished)
		func();
}

function OnGameEvent_scavenge_score_tied(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnScavengeTied)
		func();
}

function OnGameEvent_scavenge_match_finished(params)
{
	local winners = ::VSLib.EasyLogic.GetEventInt(params, "winners");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnScavengeMatchFinished)
		func(winners, params);
}

function OnGameEvent_versus_marker_reached(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local marker = ::VSLib.EasyLogic.GetEventInt(params, "marker");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnVersusMarkerReached)
		func(ents.entity, marker, params);
}

function OnGameEvent_versus_match_finished(params)
{
	local winners = ::VSLib.EasyLogic.GetEventInt(params, "winners");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnVersusMatchFinished)
		func(winners, params);
}

function OnGameEvent_mission_lost(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSurvivorsDead)
		func();
}

function OnGameEvent_round_end(params)
{
	VSLib_ResetRoundVars();
	VSLib_ResetCache();
	VSLib_RemoveDeadTimers();
	
	SaveTable( "_vslib_user_cache", ::VSLib.EasyLogic.UserCache );
	
	local winner = ::VSLib.EasyLogic.GetEventInt(params, "winner"); // team or player
	local reason = ::VSLib.EasyLogic.GetEventInt(params, "reason");
	local message = ::VSLib.EasyLogic.GetEventString(params, "message");
	local time = ::VSLib.EasyLogic.GetEventFloat(params, "time");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnRoundEnd)
		func(winner, reason, message, time, params);
}

function OnGameEvent_nav_blocked(params)
{
	local area = ::VSLib.EasyLogic.GetEventInt(params, "area");
	local blocked = ::VSLib.EasyLogic.GetEventInt(params, "blocked");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnNavBlocked)
		func(area, (blocked > 0) ? true : false, params);
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
	local xuid = ::VSLib.EasyLogic.GetEventString(params, "xuid");
	
	if (ents.entity != null)
	{
		local _id = ents.entity.GetIndex();
		
		if (_id in ::VSLib.GlobalCache)
			delete ::VSLib.GlobalCache[_id];
		
		::VSLib.GlobalCache[_id] <- {};
		::VSLib.GlobalCache[_id]["_name"] <- name;
		::VSLib.GlobalCache[_id]["_ip"] <- ipAddress;
		::VSLib.GlobalCache[_id]["_steam"] <- steamID;
		::VSLib.GlobalCache[_id]["_xuid"] <- xuid;
		
		// Save our changes to the global cache
		::VSLib.FileIO.SaveTable( "_vslib_global_cache", ::VSLib.GlobalCache );
		SaveTable( "_vslib_global_cache_session", ::VSLib.GlobalCache );
		
		if ( ents.entity.IsHuman() )
		{
			local _userid = "_vslUserID_" + ents.entity.GetUserID();
			
			if (_userid in ::VSLib.EasyLogic.UserCache)
				delete ::VSLib.EasyLogic.UserCache[_userid];
			
			::VSLib.EasyLogic.UserCache[_userid] <- {};
			::VSLib.EasyLogic.UserCache[_userid]["_name"] <- name;
			::VSLib.EasyLogic.UserCache[_userid]["_ip"] <- ipAddress;
			::VSLib.EasyLogic.UserCache[_userid]["_steam"] <- steamID;
			::VSLib.EasyLogic.UserCache[_userid]["_xuid"] <- xuid;
			
			// Save our user data to the user cache
			SaveTable( "_vslib_user_cache", ::VSLib.EasyLogic.UserCache );
		}
		
		foreach (func in ::VSLib.EasyLogic.Notifications.OnPlayerJoined)
			func(ents.entity, name, ipAddress, steamID, params);
	}
	else
	{
		::VSLib.Timers.AddTimer(1, false, RetryConnect, params);
	}
}


function OnGameEvent_player_connect_full(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPlayerConnected)
		func(ents.entity, params);
}


function OnGameEvent_player_disconnect(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local name = ::VSLib.EasyLogic.GetEventString(params, "name");
	local steamID = ::VSLib.EasyLogic.GetEventString(params, "networkid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPlayerLeft)
		func(ents.entity, name, steamID, params);
}


function OnGameEvent_player_activate(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnActivate)
		func(ents.entity, params);
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
	
	if (ents.entity.IsPlayer())
	{
		local idx = ents.entity.GetIndex();
		::VSLib.EasyLogic.Cache[idx]._isAlive <- false;
		::VSLib.EasyLogic.Cache[idx]._lastKilledBy <- ents.attacker;
		::VSLib.EasyLogic.Cache[idx]._deathPos <- ents.entity.GetLocation();
		::VSLib.EasyLogic.Cache[idx]._isFrustrated <- false;
	}
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnDeath)
		func(ents.entity, ents.attacker, params);
}

function OnGameEvent_item_pickup(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local item = ::VSLib.EasyLogic.GetEventString(params, "item");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnItemPickup)
		func(ents.entity, "weapon_" + item, params);
}

function OnGameEvent_ammo_pickup(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnAmmoPickup)
		func(ents.entity, params);
}

function OnGameEvent_ammo_pile_weapon_cant_use_ammo(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnAmmoCantUse)
		func(ents.entity, params);
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

function OnGameEvent_player_jump_apex(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnJumpApex)
		func(ents.entity, params);
}

function _OnPreSpawnEv()
{
	g_ModeScript.VSLib_ResetRoundVars();
	g_ModeScript.VSLib_ResetCache();
	
	RestoreTable( "_vslib_user_cache", ::VSLib.EasyLogic.UserCache );
	
	if (::VSLib.EasyLogic.UserCache == null)
		::VSLib.EasyLogic.UserCache <- {};
	else
		SaveTable( "_vslib_user_cache", ::VSLib.EasyLogic.UserCache );
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPreSpawn)
		func();
}

function _OnPostSpawnEv(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	if (ents.entity == null || !("IsPlayerEntityValid" in ents.entity))
		return false;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPostSpawn)
		func(ents.entity, params);
}

function VSLib::EasyLogic::Update::_VSLib_SurvsSpawned()
{
	if ( !::VSLib.EasyLogic.PlayersSpawned && Entities.FindByClassname( null, "player" ) )
	{
		::VSLib.EasyLogic.PlayersSpawned <- true;
		vslib_survivors_spawned();
	}
}

function vslib_survivors_spawned()
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSurvivorsSpawned)
		func();
}

function OnGameEvent_player_spawn(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local _id = ents.entity.GetIndex();
	
	if ( !::VSLib.EasyLogic.CheckedMode )
	{
		local vsl_mode_check =
		[
			{
				name = "VSLibModeCheck",
				criteria =
				[
					[ "Concept", "VSLibModeCheck" ],
				],
				responses =
				[
					{
						func = VSLib_OnMode
					}
				],
				group_params = ::VSLib.ResponseRules.GroupParams({ permitrepeats = true, sequential = false, norepeat = false })
			},
		]
		::VSLib.ResponseRules.ProcessRules( vsl_mode_check );
		
		ents.entity.Input( "SpeakResponseConcept", "VSLibModeCheck" );
		::VSLib.EasyLogic.CheckedMode <- true;
	}
	
	if ( !::VSLib.EasyLogic.PreSpawnFired )
	{
		_OnPreSpawnEv();
		::VSLib.EasyLogic.PreSpawnFired <- true;
	}
	
	if (!(_id in ::VSLib.EasyLogic.Cache))
		::VSLib.EasyLogic.Cache[_id] <- {};
		
	::VSLib.EasyLogic.Cache[_id]._isAlive <- true;
	::VSLib.EasyLogic.Cache[_id]._reviveCount <- 0;
	::VSLib.EasyLogic.Cache[_id]._startPos <- ents.entity.GetLocation();
	
	// Remove any bots off the global cache
	if (ents.entity.IsBot() && ents.entity.GetTeam() == INFECTED && _id in ::VSLib.GlobalCache)
		delete ::VSLib.GlobalCache[_id];
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSpawn)
		func(ents.entity, params);
	
	Timers.AddTimer(1.0, false, _OnPostSpawnEv, params);
}

function OnGameEvent_player_first_spawn(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local _id = ents.entity.GetIndex();
	
	// Remove any bots off the global cache
	if (ents.entity.IsBot() && ents.entity.GetTeam() == SURVIVORS && _id in ::VSLib.GlobalCache)
		delete ::VSLib.GlobalCache[_id];
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnFirstSpawn)
		func(ents.entity, params);
}

function OnGameEvent_player_shoved(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	local _id = ents.entity.GetIndex();
	if(_id in ::VSLib.EasyLogic.Cache)
		::VSLib.EasyLogic.Cache[_id]._lastShovedBy <- ents.attacker;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPlayerShoved)
		func(ents.entity, ents.attacker, params);
}

function OnGameEvent_entity_shoved(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnEntityShoved)
		func(ents.entity, ents.attacker, params);
}

function OnGameEvent_waiting_checkpoint_button_used(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnCheckpointButtonWaiting)
		func(ents.entity, params);
}

function OnGameEvent_success_checkpoint_button_used(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnCheckpointButtonUsed)
		func(ents.entity, params);
}

function OnGameEvent_waiting_checkpoint_door_used(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local door = ::VSLib.EasyLogic.GetEventEntity(params, "entindex");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnCheckpointDoorWaiting)
		func(ents.entity, door, params);
}

function OnGameEvent_waiting_door_used_versus(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local door = ::VSLib.EasyLogic.GetEventEntity(params, "entindex");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnCheckpointDoorWaitingVersus)
		func(ents.entity, door, params);
}

function OnGameEvent_hit_safe_room(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnHitSafeRoom)
		func(ents.entity, params);
}

function OnGameEvent_rescue_door_open(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local door = ::VSLib.EasyLogic.GetEventEntity(params, "entindex");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnRescueDoorOpened)
		func(ents.entity, door, params);
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

function OnGameEvent_player_bot_replace(params)
{
	local player = ::VSLib.EasyLogic.GetEventPlayer(params, "player");
	local bot = ::VSLib.EasyLogic.GetEventPlayer(params, "bot");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnBotReplacedPlayer)
		func(player, bot, params);
}

function OnGameEvent_bot_player_replace(params)
{
	local player = ::VSLib.EasyLogic.GetEventPlayer(params, "player");
	local bot = ::VSLib.EasyLogic.GetEventPlayer(params, "bot");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPlayerReplacedBot)
		func(player, bot, params);
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

function OnGameEvent_gascan_pour_completed(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPourCompleted)
		func(ents.entity, params);
}

function OnGameEvent_gascan_pour_blocked(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPourBlocked)
		func(ents.entity, params);
}

function OnGameEvent_gascan_pour_interrupted(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPourInterrupted)
		func(ents.entity, params);
}

function OnGameEvent_gascan_dropped(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnGascanDropped)
		func(ents.entity, params);
}

function OnGameEvent_infected_hurt(params)
{
	local infected = ::VSLib.EasyLogic.GetEventEntity(params, "entityid");
	local attackerid = ::VSLib.EasyLogic.GetEventInt(params, "attacker");
	local attacker = null;
	if (attackerid != 0)
		attacker = ::VSLib.EasyLogic.GetEventPlayer(params, "attacker");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnInfectedHurt)
		func(infected, attacker, params);
}

function OnGameEvent_melee_kill(params)
{
	local player = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local victim = ::VSLib.EasyLogic.GetEventEntity(params, "entityid");
	local ambush = ::VSLib.EasyLogic.GetEventInt(params, "ambush");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnMeleeKill)
		func(player, victim, (ambush > 0) ? true : false, params);
}

function OnGameEvent_infected_death(params)
{
	local attackerid = ::VSLib.EasyLogic.GetEventInt(params, "attacker");
	local attacker = null;
	if (attackerid != 0)
		attacker = ::VSLib.EasyLogic.GetEventPlayer(params, "attacker");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnInfectedDeath)
		func(attacker, params);
}

function OnGameEvent_zombie_death(params)
{
	local victim = ::VSLib.EasyLogic.GetEventEntity(params, "victim");
	if (victim.IsPlayer())
		victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	local attackerid = ::VSLib.EasyLogic.GetEventInt(params, "attacker");
	local attacker = null;
	if (attackerid != 0)
	{
		attacker = ::VSLib.EasyLogic.GetEventEntity(params, "attacker");
		if (attacker.IsPlayer())
			attacker = ::VSLib.EasyLogic.GetEventPlayer(params, "attacker");
	}

	foreach (func in ::VSLib.EasyLogic.Notifications.OnZombieDeath)
		func(victim, attacker, params);
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
	local victim = ::VSLib.EasyLogic.GetEventEntity(params, "entityid");
	if (victim.IsPlayer())
		victim = ::VSLib.EasyLogic.GetEventPlayer(params, "entityid");
	local attackerid = ::VSLib.EasyLogic.GetEventInt(params, "userid");
	local attacker = null;
	if (attackerid != 0)
		attacker = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	
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

function OnGameEvent_player_incapacitated_start(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnIncapacitatedStart)
		func(ents.entity, ents.attacker, params);
}

function OnGameEvent_player_entered_start_area(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnEnterStartArea)
		func(ents.entity, params);
}

function OnGameEvent_player_left_start_area(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.FirstSurvLeftStartArea)
		func(ents.entity, params);
}



function VSLib::EasyLogic::Update::_VSLib_SurvsLeft()
{
	if ( !::VSLib.EasyLogic.PlayersLeftStart && Director.HasAnySurvivorLeftSafeArea() )
	{
		::VSLib.EasyLogic.PlayersLeftStart <- true;
		vslib_survivors_left_start_area();
	}
}

function vslib_survivors_left_start_area()
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

function OnGameEvent_weapon_drop(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local item = ::VSLib.EasyLogic.GetEventEntity(params, "propid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnWeaponDropped)
		func(ents.entity, item, params);
}

function OnGameEvent_weapon_fire(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local weapon = ::VSLib.EasyLogic.GetEventString(params, "weapon");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnWeaponFire)
		func(ents.entity, "weapon_" + weapon, params);
}

function OnGameEvent_weapon_fire_at_40(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local weapon = ::VSLib.EasyLogic.GetEventString(params, "weapon");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnWeaponFireAt40)
		func(ents.entity, "weapon_" + weapon, params);
}

function OnGameEvent_weapon_fire_on_empty(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local weapon = ::VSLib.EasyLogic.GetEventString(params, "weapon");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnWeaponFireEmpty)
		func(ents.entity, "weapon_" + weapon, params);
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

function OnGameEvent_friendly_fire(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnFriendlyFire)
		func(ents.entity, victim, params);
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

function OnGameEvent_tongue_pull_stopped(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	local smoker = ::VSLib.EasyLogic.GetEventPlayer(params, "smoker");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSmokerPullStopped)
		func(ents.entity, victim, smoker, params);
}

function OnGameEvent_tongue_release(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victimid = ::VSLib.EasyLogic.GetEventInt(params, "victim");
	local victim = null;
	if ( victimid != 0 )
		victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
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

function OnGameEvent_spit_burst(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local subject = ::VSLib.EasyLogic.GetEventPlayer(params, "subject");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSpitLanded)
		func(ents.entity, subject, params);
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

function OnGameEvent_player_no_longer_it(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPlayerVomitEnd)
		func(ents.entity, params);
}

function OnGameEvent_boomer_exploded(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local splashedbile = ::VSLib.EasyLogic.GetEventInt(params, "splashedbile");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnBoomerExploded)
		func(ents.entity, ents.attacker, (splashedbile > 0) ? true : false, params);
}

function OnGameEvent_boomer_near(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnBoomerNear)
		func(ents.entity, victim, params);
}

function OnGameEvent_tank_frustrated(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	local _id = ents.entity.GetIndex();
	::VSLib.EasyLogic.Cache[_id]._isFrustrated <- true;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnTankFrustrated)
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

function OnGameEvent_spawned_as_tank(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSpawnedAsTank)
		func(ents.entity, params);
}

function OnGameEvent_survivor_call_for_help(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local subject = ::VSLib.EasyLogic.GetEventEntity(params, "subject");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSurvivorCallForHelp)
		func(ents.entity, subject, params);
}

function OnGameEvent_survivor_rescue_abandoned(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSurvivorRescueAbandoned)
		func();
}

function OnGameEvent_survivor_rescued(params)
{
	local rescuer = ::VSLib.EasyLogic.GetEventPlayer(params, "rescuer");
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSurvivorRescued)
		func(rescuer, victim, params);
}

function OnGameEvent_upgrade_pack_begin(params)
{
	local deployer = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnUpgradeDeploying)
		func(deployer, params);
}

function OnGameEvent_upgrade_pack_used(params)
{
	local deployer = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local upgrade = ::VSLib.EasyLogic.GetEventEntity(params, "upgradeid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnUpgradeDeployed)
		func(deployer, upgrade, params);
}

function OnGameEvent_receive_upgrade(params)
{
	local receiver = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local upgrade = ::VSLib.EasyLogic.GetEventString(params, "upgrade");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnUpgradeReceived)
		func(receiver, upgrade, params);
}

function OnGameEvent_player_ledge_grab(params)
{
	local causer = ::VSLib.EasyLogic.GetEventPlayer(params, "causer");
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnGrabbedLedge)
		func(causer, victim, params);
}

function OnGameEvent_player_ledge_release(params)
{
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnReleasedLedge)
		func(victim, params);
}

function OnGameEvent_player_say(params)
{
	local player = ::VSLib.EasyLogic.GetEventInt(params, "userid");
	if ( player != 0 )
		player = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local text = ::VSLib.EasyLogic.GetEventString(params, "text");
	
	// Separate the commands and arguments
	local arr = split(text, " ");
	
	// Build an argument array
	local args = {};
	local idx = -1;
	foreach (k, v in arr)
	{
		if (k != -1 && v != null && v != "")
		{
			args[idx] <- v;
			idx++;
		}
	}
	
	// Store it.
	::VSLib.EasyLogic.LastArgs <- args;
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSay)
		func(player, text, params);
}

function OnGameEvent_vote_cast_yes(params)
{
	local player = ::VSLib.EasyLogic.GetEventPlayer(params, "entityid");
	local team = ::VSLib.EasyLogic.GetEventInt(params, "team");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnVoteCastYes)
		func(player, team, params);
}

function OnGameEvent_vote_cast_no(params)
{
	local player = ::VSLib.EasyLogic.GetEventPlayer(params, "entityid");
	local team = ::VSLib.EasyLogic.GetEventInt(params, "team");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnVoteCastNo)
		func(player, team, params);
}

function OnGameEvent_server_cvar(params)
{
	local cvar = ::VSLib.EasyLogic.GetEventString(params, "cvarname");
	local value = ::VSLib.EasyLogic.GetEventString(params, "cvarvalue");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnServerCvarChanged)
		func(cvar, value, params);
}

function OnGameEvent_server_pre_shutdown(params)
{
	local reason = ::VSLib.EasyLogic.GetEventString(params, "reason");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnServerPreShutdown)
		func(reason, params);
}

function OnGameEvent_server_shutdown(params)
{
	local reason = ::VSLib.EasyLogic.GetEventString(params, "reason");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnServerShutdown)
		func(reason, params);
}

function OnGameEvent_triggered_car_alarm(params)
{
	foreach (func in ::VSLib.EasyLogic.Notifications.OnTriggeredCarAlarm)
		func();
}

function OnGameEvent_break_prop(params)
{
	local userid = ::VSLib.EasyLogic.GetEventInt(params, "userid");
	local attacker = null;
	if ( userid != 0 )
		attacker = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local prop = ::VSLib.EasyLogic.GetEventEntity(params, "entindex");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnBrokeProp)
		func(attacker, prop, params);
}

function OnGameEvent_entity_visible(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local subject = ::VSLib.EasyLogic.GetEventEntity(params, "subject");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnEntityVisible)
		func(ents.entity, subject, params);
}

function OnGameEvent_weapon_spawn_visible(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local subject = ::VSLib.EasyLogic.GetEventEntity(params, "subject");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnWeaponSpawnVisible)
		func(ents.entity, subject, params);
}

function OnGameEvent_dead_survivor_visible(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local subject = ::VSLib.EasyLogic.GetEventPlayer(params, "subject");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnDeadSurvivorVisible)
		func(ents.entity, subject, params);
}

function OnGameEvent_spawner_give_item(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local spawner = ::VSLib.EasyLogic.GetEventEntity(params, "spawner");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSpawnerGaveItem)
		func(ents.entity, spawner, params);
}

function OnGameEvent_mounted_gun_start(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	local subject = ::VSLib.EasyLogic.GetEventPlayer(params, "subject");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnMountedGunUsed)
		func(ents.entity, subject, params);
}

function OnGameEvent_mounted_gun_overheated(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnMountedGunOverheated)
		func(ents.entity, params);
}


function OnGameEvent_punched_clown(params)
{
	local player = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnPunchedClown)
		func(player, params);
}

function OnGameEvent_infected_decapitated(params)
{
	local player = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local weapon = ::VSLib.EasyLogic.GetEventString(params, "weapon");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnInfectedDecapitated)
		func(player, weapon, params);
}

function OnGameEvent_non_melee_fired(params)
{
	local ents = ::VSLib.EasyLogic.GetPlayersFromEvent(params);
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnNonMeleeFired)
		func(ents.entity, params);
}

function OnGameEvent_molotov_thrown(params)
{
	local player = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnMolotovThrown)
		func(player, params);
}

function OnGameEvent_gas_can_forced_drop(params)
{
	local attacker = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local victim = ::VSLib.EasyLogic.GetEventPlayer(params, "victim");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnForcedGasCanDrop)
		func(attacker, victim, params);
}

function OnGameEvent_strongman_bell_knocked_off(params)
{
	local player = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnStrongmanBellKnockedOff)
		func(player, params);
}

function OnGameEvent_stashwhacker_game_won(params)
{
	local player = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnStashwhackerGameWon)
		func(player, params);
}

function OnGameEvent_charger_killed(params)
{
	local charger = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local attackerid = ::VSLib.EasyLogic.GetEventInt(params, "attacker");
	local attacker = null;
	if (attackerid != 0)
		attacker = ::VSLib.EasyLogic.GetEventPlayer(params, "attacker");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnChargerKilled)
		func(charger, attacker, params);
}

function OnGameEvent_spitter_killed(params)
{
	local spitter = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local attackerid = ::VSLib.EasyLogic.GetEventInt(params, "attacker");
	local attacker = null;
	if (attackerid != 0)
		attacker = ::VSLib.EasyLogic.GetEventPlayer(params, "attacker");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnSpitterKilled)
		func(spitter, attacker, params);
}

function OnGameEvent_jockey_killed(params)
{
	local jockey = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	local attackerid = ::VSLib.EasyLogic.GetEventInt(params, "attacker");
	local attacker = null;
	if (attackerid != 0)
		attacker = ::VSLib.EasyLogic.GetEventPlayer(params, "attacker");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnJockeyKilled)
		func(jockey, attacker, params);
}

function OnGameEvent_vomit_bomb_tank(params)
{
	local player = ::VSLib.EasyLogic.GetEventPlayer(params, "userid");
	
	foreach (func in ::VSLib.EasyLogic.Notifications.OnVomitBombTank)
		func(player, params);
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
	{
		if (params["attacker"] != null && params["attacker"] != "")
		{
			if (params["attacker"] != 0)
				atk = GetPlayerFromUserID(params["attacker"]);
			else
			{
				if ("attackerentid" in params)
				{
					if (params["attackerentid"] != null && params["attackerentid"] != "")
						atk = EntIndexToHScript(params["attackerentid"]);
				}
			}
		}
	}
	else if ("attackerentid" in params)
	{
		if (params["attackerentid"] != null && params["attackerentid"] != "")
			atk = EntIndexToHScript(params["attackerentid"]);
	}
	
	if (ent)
	{
		if (ent.IsPlayer())
			ent = ::VSLib.Player(ent);
		else
			ent = ::VSLib.Entity(ent);
	}
	
	if (atk)
	{
		if (atk.IsPlayer())
			atk = ::VSLib.Player(atk);
		else
			atk = ::VSLib.Entity(atk);
	}
	
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



//
//	Below is the UserConsoleCommand() function.
//



/**
 * Lets you send commands by using scripted_user_func in console
 */
function UserConsoleCommand( playerScript, arg )
{
	// Separate the commands and arguments
	local arr = split(arg, ",");
	
	// Build an argument array
	local args = {};
	local idx = -1;
	foreach (k, v in arr)
	{
		if (k != -1 && v != null && v != "")
		{
			args[idx] <- v;
			idx++;
		}
	}
	
	// Store it.
	::VSLib.EasyLogic.LastArgs <- args;
	
	local player = ::VSLib.Player(playerScript);
	
	foreach(v in ::VSLib.EasyLogic.OnUserCommand)
	{
		if (v != null)
			v(player, arg);
	}
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
 * Returns a table of all survivor bots.
 */
function VSLib::EasyLogic::Players::SurvivorBots()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.IsBot() && libObj.GetTeam() == SURVIVORS)
				t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns a table of all alive survivor bots.
 */
function VSLib::EasyLogic::Players::AliveSurvivorBots()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.IsBot() && libObj.GetTeam() == SURVIVORS && libObj.IsAlive())
				t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns a table of all dead survivor bots.
 */
function VSLib::EasyLogic::Players::DeadSurvivorBots()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.IsBot() && libObj.GetTeam() == SURVIVORS && !libObj.IsAlive())
				t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns a table of all infected bots.
 */
function VSLib::EasyLogic::Players::InfectedBots()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.IsBot() && libObj.GetTeam() == INFECTED)
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
			t[++i] <- ::VSLib.Entity(ent);
	}
	
	return t;
}

/**
 * Returns a table of all uncommon infected.
 */
function VSLib::EasyLogic::Players::UncommonInfected()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "infected"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Entity(ent);
			if (libObj.GetUncommonInfected() > 0)
				t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns a table of all witches.
 */
function VSLib::EasyLogic::Players::Witches()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "witch"))
	{
		if (ent.IsValid())
			t[++i] <- ::VSLib.Entity(ent);
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
 * Returns a table of all dead survivors.
 */
function VSLib::EasyLogic::Players::DeadSurvivors()
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.GetTeam() == SURVIVORS && !libObj.IsAlive())
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
 * Returns one valid alive survivor, or null if none exist
 */
function VSLib::EasyLogic::Players::AnyDeadSurvivor()
{
	local ent = null;
	while (ent = Entities.FindByClassname(ent, "player"))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Player(ent);
			if (libObj.GetTeam() == SURVIVORS && !libObj.IsAlive())
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
 * Returns one RANDOM valid dead survivor, or null if none exist
 */
function VSLib::EasyLogic::Players::RandomDeadSurvivor()
{
	return Utils.GetRandValueFromArray(Players.DeadSurvivors());
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
function VSLib::EasyLogic::Players::L4D1Survivors()
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
				local libObj = ::VSLib.Player(ent);
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
			local libObj = ::VSLib.Utils.GetEntityOrPlayer(ent);
			t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns all entities of a specific classname nearest to the specified point.
 */
function VSLib::EasyLogic::Objects::OfClassnameNearest(classname, origin, radius)
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassnameNearest(classname, origin, radius))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Utils.GetEntityOrPlayer(ent);
			t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns all entities of a specific classname within a radius.
 *
 * E.g. foreach ( object in Objects.OfClassnameWithin("prop_physics", Vector(0,0,0), 10) ) ...
 */
function VSLib::EasyLogic::Objects::OfClassnameWithin(classname, origin, radius)
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByClassnameWithin(ent, classname, origin, radius))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Utils.GetEntityOrPlayer(ent);
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
		{
			return ::VSLib.Utils.GetEntityOrPlayer(ent);
		}
	}
	
	return null;
}

/**
 * Returns all entities of a specific targetname.
 */
function VSLib::EasyLogic::Objects::OfName(targetname)
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByName(ent, targetname))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Utils.GetEntityOrPlayer(ent);
			t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns all entities of a specific targetname nearest to a point.
 */
function VSLib::EasyLogic::Objects::OfNameNearest(targetname, origin, radius)
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByNameNearest(targetname, origin, radius))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Utils.GetEntityOrPlayer(ent);
			t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns all entities of a specific targetname within a radius.
 */
function VSLib::EasyLogic::Objects::OfNameWithin(targetname, origin, radius)
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByNameWithin(ent, targetname, origin, radius))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Utils.GetEntityOrPlayer(ent);
			t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns a single entity of the specified targetname, or null if non-existent
 */
function VSLib::EasyLogic::Objects::AnyOfName(targetname)
{
	local ent = null;
	while (ent = Entities.FindByName(ent, targetname))
	{
		if (ent.IsValid())
		{
			return ::VSLib.Utils.GetEntityOrPlayer(ent);
		}
	}
	
	return null;
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
			local libObj = ::VSLib.Utils.GetEntityOrPlayer(ent);
			t[++i] <- libObj;
		}
	}
	
	return t;
}

/**
 * Returns a single entity of the specified model, or null if non-existent
 */
function VSLib::EasyLogic::Objects::AnyOfModel(model)
{
	local ent = null;
	while (ent = Entities.FindByModel(ent, model))
	{
		if (ent.IsValid())
		{
			return ::VSLib.Utils.GetEntityOrPlayer(ent);
		}
	}
	
	return null;
}

/**
 * Returns all entities by its target.
 */
function VSLib::EasyLogic::Objects::OfTarget(target)
{
	local t = {};
	local ent = null;
	local i = -1;
	while (ent = Entities.FindByTarget(ent, target))
	{
		if (ent.IsValid())
		{
			local libObj = ::VSLib.Utils.GetEntityOrPlayer(ent);
			t[++i] <- libObj;
		}
	}
	
	return t;
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
			local libObj = ::VSLib.Utils.GetEntityOrPlayer(ent);
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