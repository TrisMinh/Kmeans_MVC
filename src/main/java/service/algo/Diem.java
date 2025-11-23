package service.algo;

import java.util.ArrayList;
import java.util.List;

public class Diem {
    private int id, idnhom;
    private List<Integer> gt;
    private int tonggt;

    public Diem(int id, List<Integer> gt) {
        this.id = id;
        this.gt = new ArrayList<>(gt);
        this.tonggt = gt.size();
        this.idnhom = -1;
    }

    public int layID() { return id; }
    public void taoidnhom(int idnhom) { this.idnhom = idnhom; }
    public int layidnhom() { return idnhom; }
    public double laygt(int i) { return gt.get(i); }
    public int tongsogt() { return tonggt; }
}
