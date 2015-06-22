package thx.color;

using thx.Arrays;
using thx.Floats;
using thx.Tuple;
import thx.color.parse.ColorParser;

@:access(thx.color.CieLab)
abstract Hcl(Array<Float>) {
  public var hue(get, never) : Float;
  public var chroma(get, never) : Float;
  public var luminance(get, never) : Float;

  inline public static function create(hue : Float, chroma : Float, luminance : Float)
    return new Hcl([hue, chroma, luminance]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return Hcl.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;

    return try switch info.name {
    case 'hcl':
        new thx.color.Hcl(ColorParser.getFloatChannels(info.channels, 3, false));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Hcl
    this = channels;

  public function analogous(spread = 30.0)
    return new Tuple2(
      rotate(-spread),
      rotate(spread)
    );

  public function complement()
    return rotate(180);

  public function interpolate(other : Hcl, t : Float)
    return new Hcl([
      t.interpolateAngle(hue, other.hue, 360),
      t.interpolate(chroma, other.chroma),
      t.interpolate(luminance, other.luminance)
    ]);

  public function min(other : Hcl)
    return create(hue.min(other.hue), chroma.min(other.chroma), luminance.min(other.luminance));

  public function max(other : Hcl)
    return create(hue.max(other.hue), chroma.max(other.chroma), luminance.max(other.luminance));

  public function normalize()
    return create(hue.wrapCircular(360), chroma, luminance);

  public function rotate(angle : Float)
    return withHue(hue + angle).normalize();

  public function roundTo(decimals : Int)
    return create(hue.roundTo(decimals), chroma.roundTo(decimals), luminance.roundTo(decimals));

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

  public function withHue(newhue : Float)
    return new Hcl([newhue, chroma, luminance]);

  public function withLuminance(newluminance : Float)
    return new Hcl([hue, chroma, newluminance]);

  public function withChroma(newchroma : Float)
    return new Hcl([hue, newchroma, luminance]);

  @:to public function toString() : String
    return 'hcl(${hue},${chroma},${luminance})';

  @:op(A==B) public function equals(other : Hcl) : Bool
    return nearEquals(other);

  public function nearEquals(other : Hcl, ?tolerance = Floats.EPSILON) : Bool
    return hue.nearEqualAngles(other.hue, null, tolerance) && chroma.nearEquals(other.chroma, tolerance) && luminance.nearEquals(other.luminance, tolerance);

  @:to public function toCieLab() {
    var h = hue / 180 * Math.PI,
        l = luminance,
        a = Math.cos(h) * chroma,
        b = Math.sin(h) * chroma;
    return new CieLab([l, a, b]);
  }

  @:to public function toCieLCh()
    return toCieLab().toCieLCh();

  @:to public function toCieLuv()
    return toRgbx().toCieLuv();

  @:to public function toCmy()
    return toCieLab().toCmy();

  @:to public function toCmyk()
    return toCieLab().toCmyk();

  @:to public function toCubeHelix()
    return toRgbx().toCubeHelix();

  @:to public function toGrey()
    return toCieLab().toGrey();

  @:to public function toHsl()
    return toCieLab().toHsl();

  @:to public function toHsv()
    return toCieLab().toHsv();

  @:to public function toHunterLab()
    return toXyz().toHunterLab();

  @:to public function toRgb()
    return toCieLab().toRgb();

  @:to public function toRgba()
    return toCieLab().toRgba();

  @:to public function toRgbx()
    return toCieLab().toRgbx();

  @:to public function toRgbxa()
    return toCieLab().toRgbxa();

  @:to public function toTemperature()
    return toRgbx().toTemperature();

  @:to public function toXyz()
    return toCieLab().toXyz();

  @:to public function toYuv()
    return toRgbx().toYuv();

  @:to public function toYxy()
    return toCieLab().toYxy();

  inline function get_hue() : Float
    return this[0];
  inline function get_chroma() : Float
    return this[1];
  inline function get_luminance() : Float
    return this[2];
}
