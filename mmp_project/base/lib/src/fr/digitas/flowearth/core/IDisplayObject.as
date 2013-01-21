/* ***** BEGIN LICENSE BLOCK *****
 * Copyright (C) 2007-2009 Digitas France
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * The Initial Developer of the Original Code is
 * Digitas France Flash Team
 *
 * Contributor(s):
 *   Digitas France Flash Team
 *
 * ***** END LICENSE BLOCK ***** */

package fr.digitas.flowearth.core {
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;	

	/**
	 * @author Pierre Lepers
	 */
	public interface IDisplayObject {

		function get y() : Number;

		function get transform() : Transform;

		function get stage() : Stage;

		function localToGlobal(point : Point) : Point;

		function get name() : String;

		function set width(value : Number) : void;

		function get blendMode() : String;

		function get scale9Grid() : Rectangle;

		function set name(value : String) : void;

		function set scaleX(value : Number) : void;

		function set scaleY(value : Number) : void;

		function get accessibilityProperties() : AccessibilityProperties;

		function set scrollRect(value : Rectangle) : void;

		function get cacheAsBitmap() : Boolean;

		function globalToLocal(point : Point) : Point;

		function get height() : Number;

		function set blendMode(value : String) : void;

		function get parent() : DisplayObjectContainer;

		function getBounds(targetCoordinateSpace : DisplayObject) : Rectangle;

		function get opaqueBackground() : Object;

		function set scale9Grid(innerRectangle : Rectangle) : void;

		function set alpha(value : Number) : void;

		function set accessibilityProperties(value : AccessibilityProperties) : void;

		function get width() : Number;

		function hitTestPoint(x : Number, y : Number, shapeFlag : Boolean = false) : Boolean;

		function get scaleX() : Number;

		function get scaleY() : Number;

		function get mouseX() : Number;

		function set height(value : Number) : void;

		function set mask(value : DisplayObject) : void;

		function getRect(targetCoordinateSpace : DisplayObject) : Rectangle;

		function get mouseY() : Number;

		function get alpha() : Number;

		function set transform(value : Transform) : void;

		function get scrollRect() : Rectangle;

		function get loaderInfo() : LoaderInfo;

		function get root() : DisplayObject;

		function set visible(value : Boolean) : void;

		function set opaqueBackground(value : Object) : void;

		function set cacheAsBitmap(value : Boolean) : void;

		function hitTestObject(obj : DisplayObject) : Boolean;

		function set x(value : Number) : void;

		function set y(value : Number) : void;

		function get mask() : DisplayObject;

		function set filters(value : Array) : void;

		function get x() : Number;

		function get visible() : Boolean;

		function get filters() : Array;

		function set rotation(value : Number) : void;

		function get rotation() : Number;

	}
}
