package aerys.minko.render.shader.node.operation.packing
{
	import aerys.minko.render.shader.node.Components;
	import aerys.minko.render.shader.node.Dummy;
	import aerys.minko.render.shader.node.INode;
	import aerys.minko.render.shader.node.leaf.Constant;
	import aerys.minko.render.shader.node.operation.builtin.Divide;
	import aerys.minko.render.shader.node.operation.builtin.Saturate;
	import aerys.minko.render.shader.node.operation.builtin.Substract;
	import aerys.minko.render.shader.node.operation.manipulation.Extract;

	public class PackScalarToColor extends Dummy
	{
		private static const BIT_SH		: Constant	= new Constant(256. * 256. * 256.,
																   256. * 256,
																   256.,
																   1.);

		private static const BIT_MSK	: Constant	= new Constant(0.,
																   1. / 256.,
																   1. / 256.,
																   1. / 256.);

		override public function get size() : uint
		{
			return 4;
		}

		public function PackScalarToColor(node			: INode,
										  maxValueParts	: INode = null,
										  maxValue		: INode = null)
		{
			maxValueParts	||= new Constant(0, 200, 400, 600);
			maxValue		||= new Constant(800);

			var nodeOpposite		: INode = new Substract(maxValue, node);
			var packedDepthOpposite	: INode = new Saturate(
				new Divide(
					new Substract(nodeOpposite, maxValueParts),
					new Extract(maxValueParts, Components.Y)
				)
			);

			super(packedDepthOpposite);

			/*var comp : Fractional = new Fractional(
				new Multiply(
					new Divide(
						node,
						new Constant(1600)),
					BIT_SH
				));

			super(new Substract(comp, new Multiply(new Extract(comp, Components.XXYZ), BIT_MSK)));*/

			if (node.size != 1)
				throw new Error('node must be of size 1');
			if (maxValueParts.size != 4)
				throw new Error('maxValueParts must be of size 4');
			if (maxValue.size != 1)
				throw new Error('maxValue must be of size 1');
		}
	}
}
