package service.algo;

public class KMeansResult {
    public final int[] labels;
    public final float[][] centers;
    public final int iterations;
    public final boolean converged;

    public KMeansResult(int[] labels, float[][] centers, int iterations, boolean converged) {
        this.labels = labels;
        this.centers = centers;
        this.iterations = iterations;
        this.converged = converged;
    }
}
