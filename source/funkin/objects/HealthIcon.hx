package funkin.objects;

import flixel.FlxSprite;

typedef HealthIconAnimationData =
{
	var name:String;
	var fps:Int;
	var loop:Bool;
	var offsets:Array<Float>;
	var flipX:Bool;
	var flipY:Bool;
}

typedef HealthIconData =
{
	var offsets:Array<Float>;
	// var animations:Map<String, HealthIconAnimationData>; // ill add this shit later
	var frameAmount:Int;
}

@:nullSafety
class HealthIcon extends FlxSprite
{
	/**
	 * Optional parented sprite
	 * 
	 * If set `this` will follow the set parents position
	 */
	public var sprTracker:Null<FlxSprite> = null;
	
	/**
	 * Additional offsets for the icon
	 * 
	 * Used when `sprTracker` is not null.
	 */
	public var sprOffsets(default, null):FlxPoint = FlxPoint.get(10, -30);
	
	/**
	 * The icons current character name
	 */
	public var characterName(default, null):String = '';
	
	var iconOffsets:Array<Float> = [0, 0];
	
	/**
	 * Used to decide if the icon will be flipped
	 */
	var isPlayer:Bool = false;
	
	/**
	 * The data for the health icon
	 */
	var data:HealthIconData =
		{
			offsets: [0, 0],
			frameAmount: 2
		};
		
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}
	
	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (sprTracker != null) setPosition(sprTracker.x + sprTracker.width + sprOffsets.x, sprTracker.y + sprOffsets.y);
	}
	
	/**
	 * Attempts to load a new icon by file name
	 */
	public function changeIcon(char:String):Void
	{
		if (this.characterName == char) return;
		
		this.characterName = char;
		
		var name:String = 'icons/' + char;
		if (!Paths.fileExists('images/' + name + '.png')) name = 'icons/icon-' + char; // Older versions of psych engine's support
		if (!Paths.fileExists('images/' + name + '.png')) name = 'icons/icon-face'; // Prevents crash from missing icon
		
		if (Paths.fileExists('images/' + name + '.json'))
		{
			data = FunkinAssets.parseJson(FunkinAssets.getContent(Paths.getPath('images/' + name + '.json', null, true)));
			trace(data);
		}
		
		final graphic = Paths.image(name, null, false);
		
		var frameAmount:Int = data.frameAmount;
		var graphicWidth:Int = Math.floor(graphic.width / frameAmount);
		var graphicHeight:Int = Math.floor(graphic.height);
		var width2:Float = (width - width / frameAmount) / frameAmount;
		loadGraphic(graphic, true, graphicWidth, graphicHeight);
		iconOffsets[0] = width2 + data.offsets[0];
		iconOffsets[1] = width2 + data.offsets[1];
		updateHitbox();
		
		animation.add(char, MathUtil.numberArray(0, frameAmount - 1), 0, false, isPlayer);
		animation.play(char); // i do plan on adding more functionality to icons at a later date
		
		antialiasing = char.endsWith('-pixel') ? false : ClientPrefs.globalAntialiasing;
	}
	
	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}
	
	override function destroy()
	{
		sprOffsets = FlxDestroyUtil.put(sprOffsets);
		super.destroy();
	}
	
	/**
	 * Updates the current animation based on a value from 0 - 1.
	 */
	public inline function updateIconAnim(health:Float, ?frame:Int):Void
	{
		if (frame != null)
		{
			animation.frameIndex = frame;
		}
		else
		{
			if (data.frameAmount == 2)
			{
				animation.frameIndex = health < 0.2 ? 1 : 0;
			}
			else if (data.frameAmount >= 3)
			{
				if (health < 0.2)
				{
					animation.frameIndex = 1;
				}
				else if (health > 0.8)
				{
					animation.frameIndex = 2;
				}
				else
				{
					animation.frameIndex = 0;
				}
			}
		}
	}
}
