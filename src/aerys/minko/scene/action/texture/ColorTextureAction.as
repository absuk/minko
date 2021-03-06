package aerys.minko.scene.action.texture
{
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.renderer.IRenderer;
	import aerys.minko.scene.action.ActionType;
	import aerys.minko.scene.action.IAction;
	import aerys.minko.scene.node.IScene;
	import aerys.minko.scene.node.texture.ColorTexture;
	import aerys.minko.scene.visitor.ISceneVisitor;

	public final class ColorTextureAction implements IAction
	{
		private static const TYPE	: uint		= ActionType.UPDATE_STYLE;

		private static var _instance	: ColorTextureAction	= null;

		public static function get colorTextureAction() : ColorTextureAction
		{
			return _instance || (_instance = new ColorTextureAction());
		}

		public function get type() : uint		{ return TYPE; }

		public function run(scene : IScene, visitor : ISceneVisitor, renderer : IRenderer) : Boolean
		{
			var texture : ColorTexture = scene as ColorTexture;

			if (!texture)
				throw new Error('Only ColorTexture can use a ColorTextureAction');

			var color	: uint = texture.color;

			var alpha	: uint = (color >> 24) & 0xff
			var red		: uint = (color >> 16) & 0xff
			var green	: uint = (color >> 8) & 0xff
			var blue	: uint = color & 0xff;

			color = (red << 24) | (green << 16) | (blue << 8) | (alpha); 
			visitor.renderingData.styleData.set(BasicStyle.DIFFUSE, color);

			return true;
		}
	}
}