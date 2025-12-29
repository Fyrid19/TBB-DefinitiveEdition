package funkin.backend;

import flixel.math.FlxRandom;

import funkin.backend.MusicBeatState;
import funkin.scripting.ScriptedState;
import funkin.states.TitleState;
import funkin.states.MainMenuState;
import funkin.states.CreditsState;

class FunkinGame extends flixel.FlxGame
{
	public function new(gameWidth = 0, gameHeight = 0, ?initialState, updateFramerate = 60, drawFramerate = 60, skipSplash = false, startFullscreen = false)
	{
		super(gameWidth, gameHeight, initialState, updateFramerate, drawFramerate, skipSplash, startFullscreen);
	}
	
	override function switchState():Void
	{
		#if MODS_ALLOWED
		overrideState();
		#end
		super.switchState();
	}
	
	function overrideState()
	{
		var newState = _nextState.createInstance();
		
		if (Mods.isStateRedirected(newState))
		{
			final name = Mods.getRedirect(newState);
			
			if (name != null)
			{
				newState = FlxDestroyUtil.destroy(newState);
				_nextState = new ScriptedState(name);
			}
		}
	}
}
