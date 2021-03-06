package aerys.minko.render.renderer
{
	import aerys.minko.Minko;
	import aerys.minko.ns.minko;
	import aerys.minko.ns.minko_render;
	import aerys.minko.render.Viewport;
	import aerys.minko.type.Factory;
	import aerys.minko.type.log.DebugLevel;

	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.utils.getTimer;

	public class DirectRenderer implements IRenderer
	{
		use namespace minko;
		use namespace minko_render;

		private static const RENDER_STATE	: Factory			= Factory.getFactory(RendererState);

		private var _context		: Context3D					= null;
		private var _currentState	: RendererState				= new RendererState();
		private var _actualState	: RendererState				= null;
		private var _numTriangles	: uint						= 0;
		private var _viewport		: Viewport					= null;
		private var _drawingTime	: int						= 0;
		private var _frame			: uint						= 0;

		public function get state() 		: RendererState	{ return _currentState; }
		public function get numTriangles()	: uint			{ return _numTriangles; }
		public function get viewport()		: Viewport		{ return _viewport; }
		public function get drawingTime()	: int			{ return _drawingTime; }
		public function get frameId()		: uint			{ return _frame; }

		public function DirectRenderer(viewport : Viewport, context : Context3D)
		{
			_viewport = viewport;
			_context = context;

			_context.enableErrorChecking = (Minko.debugLevel & DebugLevel.RENDERER) != 0;
		}

		public function drawTriangles(offset		: uint	= 0,
									  numTriangles	: int	= -1) : void
		{
			var t : int	= getTimer();

			_numTriangles += _currentState.apply(_context, _actualState);

			_drawingTime += getTimer() - t;
			_actualState = _currentState;
		}

		public function reset() : void
		{
			_numTriangles = 0;
			_drawingTime = 0;

			_actualState = null;
			_currentState = null;
		}

		public function present() : void
		{
			var time : int = getTimer();

			_context.present();

			_drawingTime += getTimer() - time;
			++_frame;
		}

		public function drawToBackBuffer() : void
		{

		}

		public function dumpBackbuffer(bitmapData : BitmapData) : void
		{
			var time : int = getTimer();

			_context.drawToBitmapData(bitmapData);

			_drawingTime += getTimer() - time;
			++_frame;
		}

		public function pushState(state : RendererState) : void
		{
			_currentState = state;
		}
	}
}
