package thx.color;

using thx.core.Arrays;
using thx.core.Floats;
using thx.core.Tuple;
import thx.color.parse.ColorParser;

@:access(thx.color.RGBX)
@:access(thx.color.HSVA)
abstract HSV(Array<Float>) {
  public var hue(get, never) : Float;
  public var huef(get, never) : Float;
  public var saturation(get, never) : Float;
  public var value(get, never) : Float;

  public static function create(hue : Float, saturation : Float, lightness : Float)
    return new HSV([
      hue.wrapCircular(360),
      saturation.clamp(0, 1),
      lightness.clamp(0, 1)
    ]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return HSV.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'hsv':
        new thx.color.HSV(ColorParser.getFloatChannels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : HSV
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function interpolate(other : HSV, t : Float)
    return new HSV([
      t.interpolateAngle(hue, other.hue),
      t.interpolate(saturation, other.saturation),
      t.interpolate(value, other.value)
    ]);

  public function rotate(angle : Float)
    return withHue(hue + angle);

  public function split(spread = 144.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function square()
    return tetrad(90);

  public function tetrad(angle : Float)
    return new Tuple4(
      rotate(0),
      rotate(angle),
      rotate(180),
      rotate(180 + angle)
    );

  public function triad()
    return new Tuple3(
      rotate(-120),
      rotate(0),
      rotate(120)
    );

  inline public function withAlpha(alpha : Float)
    return new HSVA(this.concat([alpha.normalize()]));

  inline public function withHue(newhue : Float)
    return new HSV([newhue.normalize(), saturation, value]);

  inline public function withValue(newvalue : Float)
    return new HSV([hue, saturation, newvalue.normalize()]);

  inline public function withSaturation(newsaturation : Float)
    return new HSV([hue, newsaturation.normalize(), value]);

  inline public function toString() : String
    return 'hsv($huef,${saturation*100}%,${value*100}%)';

  @:op(A==B) public function equals(other : HSV) : Bool
    return hue.nearEquals(other.hue) && saturation.nearEquals(other.saturation) && value.nearEquals(other.value);

  @:to inline public function toCIELab()
    return toRGBX().toCIELab();

  @:to inline public function toCIELCh()
    return toRGBX().toCIELCh();

  @:to inline public function toCMY()
    return toRGBX().toCMY();

  @:to inline public function toCMYK()
    return toRGBX().toCMYK();

  @:to inline public function toGrey()
    return toRGBX().toGrey();

  @:to inline public function toHSL()
    return toRGBX().toHSL();

  @:to inline public function toHSVA()
    return withAlpha(1.0);

  @:to inline public function toRGB()
    return toRGBX().toRGB();

  @:to inline public function toRGBA()
    return toRGBXA().toRGBA();

  @:to inline public function toRGBX() {
    if(saturation == 0)
      return new RGBX([value, value, value]);

    var r : Float, g : Float, b : Float, i : Int, f : Float, p : Float, q : Float, t : Float;
    var h = hue / 60;

    i = Math.floor(h);
    f = h - i;
    p = value * (1 - saturation);
    q = value * (1 - f * saturation);
    t = value * (1 - (1 - f) * saturation);

    switch(i){
      case 0: r = value; g = t; b = p;
      case 1: r = q; g = value; b = p;
      case 2: r = p; g = value; b = t;
      case 3: r = p; g = q; b = value;
      case 4: r = t; g = p; b = value;
      default: r = value; g = p; b = q; // case 5
    }

    return new RGBX([r, g, b]);
  }

  @:to inline public function toRGBXA()
    return toRGBX().toRGBXA();

  @:to inline public function toXYZ()
    return toRGBX().toXYZ();

  @:to inline public function toYxy()
    return toRGBX().toYxy();

  inline function get_hue() : Float
    return this[0];
  inline function get_huef() : Float
    return this[0];
  inline function get_saturation() : Float
    return this[1];
  inline function get_value() : Float
    return this[2];
}