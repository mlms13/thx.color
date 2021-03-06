import MiniCanvas;

import thx.color.*;
using thx.Iterators;
using thx.Arrays;
import thx.Ints;

class Demo {
  static function interpolations() {
    var left  : Hsv = 'hsv(160deg,100%,63%)',
        right : Hsv = 'hsv(345deg,88%,77%)';

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgba return (left : Rgb).interpolate(right, t))
      .display('interpolateRgb');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgba return (left : Cmy).interpolate(right, t))
      .display('interpolateCmy');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgba return (left : Cmyk).interpolate(right, t))
      .display('interpolateCmyk');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgba return (left : Grey).interpolate(right, t))
      .display('interpolateGrey');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgba return (left : Hsl).interpolate(right, t))
      .display('interpolateHsl');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgba return (left : Hsv).interpolate(right, t))
      .display('interpolateHsv');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgba return (left : CieLab).interpolate(right, t))
      .display('interpolateCielab');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgba return (left : CieLCh).interpolate(right, t))
      .display('interpolateCielch');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgba return (left : Xyz).interpolate(right, t))
      .display('interpolateXyz');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t : Float) : Rgba return (left : Yxy).interpolate(right, t))
      .display('interpolateYxy');
  }

  public static function main() {
    interpolations();

    MiniCanvas.create(200, 200).box(
      function(x : Float, y : Float) : Rgba
        return Hsl.create(x * 360, 1, y))
      .display("rainbowHsl");

    MiniCanvas.create(200, 200).box(
      function(x : Float, y : Float) : Rgba
        return CieLCh.create(65, y * 65, x * 360))
      .display("rainbowCielch");

    MiniCanvas.create(200, 200).box(
      function(x : Float, y : Float) : Rgba
        return CieLab.create(40, x * 200 - 100, y * 200 - 100))
      .display("rainbowCielab");

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t) : Rgba
        return ('#ff0000' : Rgb).darker(t))
      .display('darkerRgb');

    MiniCanvas.create(400, 20).gradientHorizontal(
      function(t) : Rgba
        return ('#0000ff' : Rgb).lighter(t))
      .display('lighterRgb');

    var c = MiniCanvas.create(900, 1200);
    colorTable(c.ctx, c.width, c.height);
    c.display('colorTable');
  }

  public static function colorTable(ctx, w, h) {
    var columns = 5,
        colors  = Color.names.keys().toArray().filter(function(n) return n.indexOf(' ') < 0),
        cellw   = w / columns,
        cellh   = h / Math.ceil(colors.length / columns);
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";
    ctx.font = '${Math.round(cellh*0.4)}px Verdana, sans-serif';
    colors.mapi(function(name, i) {
      var col   = i % columns,
        row   = Math.floor(i / columns),
        color = Color.names.get(name);

      ctx.fillStyle = color.toString();
      ctx.fillRect(col * cellw, row * cellh, cellw, cellh);

      ctx.fillStyle = color.toRgbx()
        .toPerceivedGrey()
        .contrast()
        .toRgb().toString();
      ctx.fillText(
        name,
        Math.round(col * cellw + cellw / 2) + 0.5,
        Math.round(row * cellh + cellh / 2) + 0.5,
        cellw);
    });
  }
}