package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Tuple;
import thx.color.parse.ColorParser;

@:access(thx.color.Rgbxa)
@:access(thx.color.Hsv)
abstract Hsva(Array<Float>) {
  public var hue(get, never) : Float;
  public var saturation(get, never) : Float;
  public var value(get, never) : Float;
  public var alpha(get, never) : Float;

  public static function create(hue : Float, saturation : Float, value : Float, alpha : Float)
    return new Hsva([
      hue.wrapCircular(360),
      saturation.clamp(0, 1),
      value.clamp(0, 1),
      alpha.clamp(0, 1)
    ]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(4);
    return Hsva.create(arr[0], arr[1], arr[2], arr[3]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
      case 'hsv':
        new thx.color.Hsv(ColorParser.getFloatChannels(info.channels, 3)).toHsva();
      case 'hsva':
        new thx.color.Hsva(ColorParser.getFloatChannels(info.channels, 4));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Hsva
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function transparent(t : Float)
    return new Hsva([
      hue,
      saturation,
      value,
      t.interpolate(alpha, 0)
    ]);

  public function opaque(t : Float)
    return new Hsva([
      hue,
      saturation,
      value,
      t.interpolate(alpha, 1)
    ]);

  public function interpolate(other : Hsva, t : Float)
    return new Hsva([
      t.interpolateAngle(hue, other.hue),
      t.interpolate(saturation, other.saturation),
      t.interpolate(value, other.value),
      t.interpolate(alpha, other.alpha)
    ]);

  public function rotate(angle : Float)
    return Hsva.create(hue + angle, saturation, value, alpha);

  public function split(spread = 150.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function withAlpha(newalpha : Float)
    return new Hsva([hue, saturation, value, newalpha.normalize()]);

  public function withHue(newhue : Float)
    return new Hsva([newhue.wrapCircular(360), saturation, value, alpha]);

  public function withLightness(newvalue : Float)
    return new Hsva([hue, saturation, newvalue.normalize(), alpha]);

  public function withSaturation(newsaturation : Float)
    return new Hsva([hue, newsaturation.normalize(), value, alpha]);

  public function toString() : String
    return 'hsva(${hue.roundTo(6)},${(saturation*100).roundTo(6)}%,${(value*100).roundTo(6)}%,${alpha.roundTo(6)})';

  @:op(A==B) public function equals(other : Hsva) : Bool
    return hue.nearEquals(other.hue) && saturation.nearEquals(other.saturation) && value.nearEquals(other.value) && alpha.nearEquals(other.alpha);

  @:to public function toHsv()
    return new Hsv(this.slice(0, 3));

  @:to public function toHsla()
    return toRgbxa().toHsla();

  @:to public function toRgb()
    return toRgbxa().toRgb();

  @:to public function toRgba()
    return toRgbxa().toRgba();

  @:to public function toRgbxa() {
    if(saturation == 0)
      return new Rgbxa([value, value, value, alpha]);

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

    return new Rgbxa([r, g, b, alpha]);
  }

  inline function get_hue() : Float
    return this[0];
  inline function get_saturation() : Float
    return this[1];
  inline function get_value() : Float
    return this[2];
  inline function get_alpha() : Float
    return this[3];
}