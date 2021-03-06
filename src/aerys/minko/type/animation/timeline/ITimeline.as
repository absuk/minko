package aerys.minko.type.animation.timeline
{
	import aerys.minko.scene.node.IScene;
	import aerys.minko.type.math.Matrix4x4;

	public interface ITimeline
	{
		function get duration()		: uint;
		function get targetName()	: String;
		function get propertyName()	: String;

		function updateAt(t : uint, scene : IScene) : void;
		function clone() : ITimeline;
		function reverse() : void;
	}
}
