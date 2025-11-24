package model.BO;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import model.Bean.DiemBean;

public final class ImageProcBO {
	private ImageProcBO() {
	}

	public static List<DiemBean> imageToDiemList(BufferedImage img) {
		int w = img.getWidth(), h = img.getHeight();
		List<DiemBean> ds = new ArrayList<>(w * h);
		int id = -1;
		for (int x = 0; x < h; x++) {
			for (int y = 0; y < w; y++) {
				id++;
				Color c = new Color(img.getRGB(y, x));
				ds.add(new DiemBean(id, Arrays.asList(c.getRed(), c.getGreen(), c.getBlue())));
			}
		}
		return ds;
	}

	public static BufferedImage labelsToImage(int width, int height, int[] labels, float[][] centers) {
		BufferedImage out = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		int m = 0;
		for (int x = 0; x < height; x++) {
			for (int y = 0; y < width; y++) {
				int id = labels[m++];
				int r = clamp(Math.round(centers[id][0]));
				int g = clamp(Math.round(centers[id][1]));
				int b = clamp(Math.round(centers[id][2]));
				out.setRGB(y, x, new Color(r, g, b).getRGB());
			}
		}
		return out;
	}

	private static int clamp(int v) {
		return v < 0 ? 0 : Math.min(255, v);
	}
}

