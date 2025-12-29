function onCreatePost() {
	var overlayColor = [0.0, 0.0, 0.0, 1.0];
	var satinColor = [0.6, 0.6, 0.1, 0.7];
	var innerShadowColor = [0.9, 0.9, 0.8, 0.14];
	var innerShadowDistance = 25;
	var layernumbers = 8.0;
	var layerseparation = 1.3;

	var shaderBF = newShader('RTXLighting');
	shaderBF.setFloatArray('overlayColor', overlayColor);
	shaderBF.setFloatArray('satinColor', satinColor);
	shaderBF.setFloatArray('innerShadowColor', innerShadowColor);
	shaderBF.setFloat('layernumbers', layernumbers);
	shaderBF.setFloat('layerseparation', layerseparation);
	shaderBF.setFloat('innerShadowDistance', innerShadowDistance);
	shaderBF.setFloat('innerShadowAngle', -115 * (Math.PI / 180));
	game.boyfriend.shader = shaderBF;

	var shaderDad = newShader('RTXLighting');
	shaderDad.setFloatArray('overlayColor', overlayColor);
	shaderDad.setFloatArray('satinColor', satinColor);
	shaderDad.setFloatArray('innerShadowColor', innerShadowColor);
	shaderDad.setFloat('layernumbers', layernumbers);
	shaderDad.setFloat('layerseparation', layerseparation);
	shaderDad.setFloat('innerShadowDistance', innerShadowDistance);
	shaderDad.setFloat('innerShadowAngle', -65 * (Math.PI / 180));
	game.dad.shader = shaderDad;
}
