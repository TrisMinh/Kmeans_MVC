package model.Bean;

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

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getIdnhom() {
		return idnhom;
	}

	public void setIdnhom(int idnhom) {
		this.idnhom = idnhom;
	}

	public double getGt(int i) {
		return gt.get(i);
	}

	public void setGt(List<Integer> gt) {
		this.gt = gt;
	}

	public int getTonggt() {
		return tonggt;
	}

	public void setTonggt(int tonggt) {
		this.tonggt = tonggt;
	}
}
