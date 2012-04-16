package com.bensonarts.util
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * @author Aaron Benson
	 */
	public class ShapeGenerator
	{
		private static var shape:Shape;
		private static var sprite:Sprite;
		/**
		 * Returns a Shape object
		 * Draws a solid box
		 **/
		public static function drawRect( 	width:Number, 
											height:Number, 
											color:uint, 
											radius:Number=0,
											borderWidth:Number=0, 
											borderColor:uint=0 ):Shape
		{
			shape = new Shape();
			if ( borderWidth > 0 ) shape.graphics.lineStyle( borderWidth, borderColor );
			shape.graphics.beginFill( color );
			shape.graphics.drawRoundRect( 0, 0, width, height, radius, radius );
			shape.graphics.endFill();
			return shape;
		}
		/**
		 * Returns a Shape object
		 * Draws a linear gradient box
		 **/
		public static function drawGradientRect( 	width:Number, 
										 	height:Number, 
											gradientTopColor:uint, 
											gradientBottomColor:uint, 
											radius:Number=0,
											strokeWidth:Number=0, 
											strokeColor:uint=0 ):Shape
		{
			shape = new Shape();
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [ gradientTopColor, gradientBottomColor ];
			var alphas:Array = [ 1, 1 ];
			var ratios:Array = [ 0x00, 0xff ];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( width, height, Math.PI / 2, 0, 0 );
			var spreadMethod:String = SpreadMethod.PAD;
			shape.graphics.lineStyle( strokeWidth, strokeColor );
			shape.graphics.beginGradientFill( fillType, colors, alphas, ratios, matrix, spreadMethod );
			shape.graphics.drawRoundRect( 0, 0, width, height, radius, radius );
			shape.graphics.endFill();
			return shape;
		}
	}
}