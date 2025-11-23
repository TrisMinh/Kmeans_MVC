package service.algo;

import java.util.*;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.stream.IntStream;

public class Kmeans {
    private final int K;
    private final int tonggt, tongdiem;
    private float[][] diem;
    private float[][] tam;
    private int[] idNhom;

    public Kmeans(int K, int tongdiem, int tonggt) {
        this.K = K;
        this.tongdiem = tongdiem;
        this.tonggt = tonggt;
    }

    private void chuanBiDuLieu(java.util.List<Diem> ds) {
        diem = new float[tongdiem][tonggt];
        idNhom = new int[tongdiem];
        Arrays.fill(idNhom, -1);
        for (int i = 0; i < tongdiem; i++) {
            for (int j = 0; j < tonggt; j++) {
                diem[i][j] = (float) ds.get(i).laygt(j);
            }
        }
        tam = new float[K][tonggt];
    }

    private static float kc(float[] a, float[] b) {
        float dx = a[0] - b[0], dy = a[1] - b[1], dz = a[2] - b[2];
        return (float) Math.sqrt(dx*dx + dy*dy + dz*dz);
    }

    private void capNhatTam(float[][] tong, int[] dem) {
        for (int i = 0; i < K; i++) {
            if (dem[i] == 0) continue;
            tam[i][0] = tong[i][0] / dem[i];
            tam[i][1] = tong[i][1] / dem[i];
            tam[i][2] = tong[i][2] / dem[i];
        }
    }

    public KMeansResult run(java.util.List<Diem> ds) {
        chuanBiDuLieu(ds);

        java.util.Random rand = new java.util.Random();
        boolean[] used = new boolean[tongdiem];

        for (int k = 0; k < K; k++) {
            int idx;
            do {
                idx = rand.nextInt(tongdiem);
            } while (used[idx]);
            used[idx] = true;
            System.arraycopy(diem[idx], 0, tam[k], 0, tonggt);
            idNhom[idx] = k;
        }

        int lap = 0;
        boolean thayDoi;

        do {
            thayDoi = false;
            float[][] tong = new float[K][tonggt];
            int[] dem = new int[K];
            for (int i = 0; i < tongdiem; i++) {
                float kcMin = kc(diem[i], tam[0]);
                int idNew = 0;
                for (int k = 1; k < K; k++) {
                    float kcTam = kc(diem[i], tam[k]);
                    if (kcTam < kcMin) {
                        kcMin = kcTam;
                        idNew = k;
                    }
                }

                int idOld = idNhom[i];
                if (idOld != idNew) {
                    idNhom[i] = idNew;
                    thayDoi = true;
                }

                for (int j = 0; j < tonggt; j++) {
                    tong[idNew][j] += diem[i][j];
                }
                dem[idNew]++;
            }
            for (int k = 0; k < K; k++) {
                if (dem[k] == 0) continue;
                for (int j = 0; j < tonggt; j++) {
                    tam[k][j] = tong[k][j] / dem[k];
                }
            }
            lap++;
        } while (thayDoi && lap < 50);
        boolean converged = !thayDoi;
        float[][] centers = new float[K][tonggt];
        for (int k = 0; k < K; k++) {
            System.arraycopy(tam[k], 0, centers[k], 0, tonggt);
        }
        int[] labels = java.util.Arrays.copyOf(idNhom, idNhom.length);
        return new KMeansResult(labels, centers, lap, converged);
    }

}
