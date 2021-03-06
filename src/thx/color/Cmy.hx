package thx.color;

using thx.Arrays;
using thx.Floats;
import thx.color.parse.ColorParser;

@:access(thx.color.Rgbx)
@:access(thx.color.Cmyk)
abstract Cmy(Array<Float>) {
  public var cyan(get, never): Float;
  public var magenta(get, never): Float;
  public var yellow(get, never): Float;

  public static function create(cyan: Float, magenta: Float, yellow: Float) : Cmy
    return new Cmy([
      cyan.normalize(),
      magenta.normalize(),
      yellow.normalize()
    ]);

  @:from public static function fromFloats(arr : Array<Float>) {
    arr.resize(3);
    return Cmy.create(arr[0], arr[1], arr[2]);
  }

  @:from public static function fromString(color : String) {
    var info = ColorParser.parseColor(color);
    if(null == info)
      return null;
    return try switch info.name {
      case 'cmy':
        new thx.color.Cmy(ColorParser.getFloatChannels(info.channels, 3));
      case _:
        null;
    } catch(e : Dynamic) null;
  }

  inline function new(channels : Array<Float>) : Cmy
    this = channels;

  public function interpolate(other : Cmy, t : Float)
    return new Cmy([
      t.interpolate(cyan,    other.cyan),
      t.interpolate(magenta, other.magenta),
      t.interpolate(yellow,  other.yellow)
    ]);

  public function withCyan(newcyan : Float)
    return new Cmy([
      newcyan.normalize(),
      magenta,
      yellow
    ]);

  public function withMagenta(newmagenta : Float)
    return new Cmy([
      cyan,
      newmagenta.normalize(),
      yellow
    ]);

  public function withYellow(newyellow : Float)
    return new Cmy([
      cyan,
      magenta,
      newyellow.normalize()
    ]);

  @:to public function toString() : String
    return 'cmy(${cyan.roundTo(6)},${magenta.roundTo(6)},${yellow.roundTo(6)})';

  @:op(A==B) public function equals(other : Cmy) : Bool
    return cyan.nearEquals(other.cyan) && magenta.nearEquals(other.magenta) && yellow.nearEquals(other.yellow);

  @:to public function toCieLab()
    return toRgbx().toCieLab();

  @:to public function toCieLCh()
    return toRgbx().toCieLCh();

  @:to public function toCmyk() {
    var k = cyan.min(magenta).min(yellow);
    if(k == 1)
      return new Cmyk([0,0,0,1]);
    else
      return new Cmyk([
        (cyan - k)    / (1 - k),
        (magenta - k) / (1 - k),
        (yellow - k)  / (1 - k),
        k
      ]);
  }

  @:to public function toGrey()
    return toRgbx().toGrey();

  @:to public function toHsl()
    return toRgbx().toHsl();

  @:to public function toHsv()
    return toRgbx().toHsv();

  @:to public function toRgb()
    return toRgbx().toRgb();

  @:to public function toRgba()
    return toRgbxa().toRgba();

  @:to public function toRgbx()
    return new Rgbx([
      1 - cyan,
      1 - magenta,
      1 - yellow
    ]);

  @:to public function toRgbxa() : Rgbxa
    return toRgbx().toRgbxa();

  @:to public function toXyz() : Xyz
    return toRgbx().toXyz();

  @:to public function toYxy() : Yxy
    return toRgbx().toYxy();

  inline function get_cyan() : Float
    return this[0];
  inline function get_magenta() : Float
    return this[1];
  inline function get_yellow() : Float
    return this[2];
}