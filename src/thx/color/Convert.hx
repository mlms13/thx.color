/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;
import thx.core.Floats;
using Math;

class ConvertRGB
{
	inline public static function toCMYK(rgb : RGB)
		return ConvertRGBChannels.toCMYK(rgb.red / 255, rgb.green / 255, rgb.blue / 255)
}

class ConvertRGBX
{
	inline public static function toCMYK(rgb : RGBX)
		return ConvertRGBChannels.toCMYK(rgb.redf, rgb.greenf, rgb.bluef)
}

class ConvertRGBChannels
{
	static function toHSLArray(r : Float, g : Float, b : Float)
	{
		var	min = r.min(g).min(b),
			max = r.max(g).max(b),
			delta = max - min,
			h,
			s,
			l = (max + min) / 2;
		if (delta == 0.0)
			s = h = 0.0;
		else {
			s = l < 0.5 ? delta / (max + min) : delta / (2 - max - min);
			if (r == max)
				h = (g - b) / delta + (g < b ? 6 : 0);
			else if (g == max)
				h = (b - r) / delta + 2;
			else
				h = (r - g) / delta + 4;
			h *= 60;
		}
		return [h, s, l];
	}
	
	public static function toHSL(r : Float, g : Float, b : Float)
	{
		var arr = toHSLArray(r, g, b);
		return new HSL(arr[0], arr[1], arr[2]);
	}
	
	public static function toCMYK(r : Float, g : Float, b : Float)
	{
		var c = 0.0, y = 0.0, m = 0.0, k;
		if (r + g + b == 0)
		{
			k = 1.0;
		} else {
			c = 1 - r;
			m = 1 - g;
			y = 1 - b;
			k = c.min(m).min(y);
			c = (c - k) / (1 - k);
			m = (m - k) / (1 - k);
			y = (y - k) / (1 - k);
		}
		return new CMYK(c, m, y, k);
	}
}