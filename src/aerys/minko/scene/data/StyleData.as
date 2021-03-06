package aerys.minko.scene.data
{
	import aerys.minko.ns.minko_render;
	import aerys.minko.render.effect.Style;
	import aerys.minko.type.IVersionable;

	public final class StyleData implements IVersionable
	{
		use namespace minko_render;
		
		private static const EMPTY		: Array 			= [];
		private static const FREE		: Vector.<Array>	= new Vector.<Array>();
		private static var _numFree		: int				= 0;
		
		private var _data 		: Vector.<Array>	= Vector.<Array>([EMPTY]);
		private var _size		: int				= 1;
		private var _cache		: Array				= [];

		private var _version	: uint				= 1;

		public function get version() : uint
		{
			return _version;
		}

		public final function get(styleId : uint, defaultValue : Object = null) : Object
		{
			if (_cache.hasOwnProperty(styleId))
				return _cache[styleId];

			for (var i : int = _size - 1; i >= 0; --i)
			{
				var data : Array = _data[i];

				if (data.hasOwnProperty(styleId))
				{
					var item : Object = data[styleId];

					_cache[styleId] = item;

					return item;
				}
			}

			if (defaultValue !== null)
				return defaultValue;

			throw new Error("The style named '"
							+ Style.getStyleName(styleId)
							+ "' is not set and no default value was provided.");
		}

		public final function isSet(id : int) : Object
		{
			return get(id, EMPTY) !== EMPTY;
		}

		public function set(styleId : int, value : Object) : StyleData
		{
			var top : Array = _data[int(_size - 1)];
			if (top === EMPTY)
			{
				if (_numFree > 0)
				{
					top = FREE[int(--_numFree)];
					top.length = 0;
				}
				else
				{
					top = [];
				}

				_data[int(_size - 1)] = top;
			}

			_cache[styleId] = value;
			top[styleId] = value;

			++_version;

			return this;
		}

		public function push(style : Style = null) : void
		{
			_data[int(_size++)] = style._data;
			_data[int(_size++)] = EMPTY;
			
			_version += style.version + 1;
		}

		public function pop() : void
		{
			var free : Array = _data[int(_size - 1)];
			
			if (free !== EMPTY)
				FREE[int(_numFree++)] = free;
			
			_size -= 2;
			_cache.length = 0;

			++_version;
		}
		
		public function reset() : void
		{
			_cache.length = 0;
			_data[0] = EMPTY;
		}
	}
}
