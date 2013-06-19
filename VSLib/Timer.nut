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
 * \brief A timer system to call a function after a certain amount of time.
 *
 *  The Timer table allows the developer to easily add synchronized callbacks.
 */
::VSLib.Timers <-
{
	TimersList = {}
	count = 0
}

/*
 * Constants
 */
getconsttable()["NO_TIMER_PARAMS"] <- null;
const UPDATE_RATE = 0.1;

// Flags
getconsttable()["TIMER_FLAG_KEEPALIVE"] <- (1 << 1);


/**
 * Calls a function and passes the specified table to the callback after the specified delay.
 */
function VSLib::Timers::AddTimer(delay, repeat, func, paramTable = null, flags = 0)
{
	delay = delay.tofloat();
	repeat = repeat.tointeger();
	
	local rep = (repeat > 0) ? true : false;
	
	if (delay < UPDATE_RATE)
	{
		printl("VSLib Warning: Timer delay cannot be less than " + UPDATE_RATE + " second(s). Delay has been reset to " + UPDATE_RATE + ".");
		delay = UPDATE_RATE;
	}
	
	++count;
	TimersList[count] <-
	{
		_delay = delay
		_func = func
		_params = paramTable
		_startTime = Time()
		_repeat = rep
		_flags = flags
	}
	
	return count;
}

/**
 * Removes the specified timer.
 */
function VSLib::Timers::RemoveTimer(idx)
{
	if (idx in TimersList)
		delete ::VSLib.Timers.TimersList[idx];
}

/**
 * Manages all timers and provides interface for custom updates.
 */
::VSLib.Timers._thinkFunc <- function()
{
	// current time
	local curtime = Time();
	
	// Execute timers as needed
	foreach (idx, timer in ::VSLib.Timers.TimersList)
	{
		if ((curtime - timer._startTime) >= timer._delay)
		{
			try
			{
				if (timer._func(timer._params) == false)
					timer._repeat = false;
			}
			catch (id)
			{
				printf("VSLib Timer caught exception; closing timer. Error was: %s", id.tostring());
				local deadFunc = timer._func;
				local params = timer._params;
				delete ::VSLib.Timers.TimersList[idx];
				deadFunc(params); // this will most likely throw
				continue;
			}
			
			if (timer._repeat)
				timer._startTime = curtime;
			else
				if (idx in ::VSLib.Timers.TimersList) // recheck-- timer may have been removed by timer callback
					delete ::VSLib.Timers.TimersList[idx];
		}
	}
}

/*
 * Create a think timer
 */
if (!("_thinkTimer" in ::VSLib.Timers))
{
	::VSLib.Timers._thinkTimer <- g_ModeScript.CreateSingleSimpleEntityFromTable({ classname = "info_target" });
	if (::VSLib.Timers._thinkTimer != null)
	{
		::VSLib.Timers._thinkTimer.ValidateScriptScope();
		local scrScope = ::VSLib.Timers._thinkTimer.GetScriptScope();
		scrScope["ThinkTimer"] <- ::VSLib.Timers._thinkFunc;
		AddThinkToEnt(::VSLib.Timers._thinkTimer, "ThinkTimer");
	}
	else
		throw "VSLib Error: Timer system could not be created; Could not create dummy entity";
}


// Add a weakref
::Timers <- ::VSLib.Timers.weakref();