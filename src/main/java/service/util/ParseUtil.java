package service.util;

import java.util.ArrayList;
import java.util.List;

public final class ParseUtil {
    private ParseUtil() {}

    public static List<int[]> parsePointsRGB(String raw) {
        List<int[]> out = new ArrayList<>();
        if (raw == null) return out;
        String[] lines = raw.split("\\r?\\n");
        for (String ln : lines) {
            ln = ln.trim();
            if (ln.isEmpty()) continue;
            String[] p = ln.split(",");
            if (p.length != 3) throw new IllegalArgumentException("Moi dong phai co 3 so r,g,b");
            int r = Integer.parseInt(p[0].trim());
            int g = Integer.parseInt(p[1].trim());
            int b = Integer.parseInt(p[2].trim());
            if (r < 0 || r > 255 || g < 0 || g > 255 || b < 0 || b > 255)
                throw new IllegalArgumentException("RGB chi trong [0..255]");
            out.add(new int[]{r, g, b});
        }
        return out;
    }
}
