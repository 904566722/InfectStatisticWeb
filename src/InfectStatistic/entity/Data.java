package InfectStatistic.entity;

public class Data {
    private int id;
    private String date;
    private String province;
    private int eip;
    private int esp;
    private int tip;
    private int tsp;
    private int cure;
    private int dead;

    public int getId() {
        return id;
    }

    public String getDate() {
        return date;
    }

    public String getProvince() {
        return province;
    }

    public int getEip() {
        return eip;
    }

    public int getEsp() {
        return esp;
    }

    public int getTip() {
        return tip;
    }

    public int getTsp() {
        return tsp;
    }

    public int getCure() {
        return cure;
    }

    public int getDead() {
        return dead;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public void setEip(int eip) {
        this.eip = eip;
    }

    public void setEsp(int esp) {
        this.esp = esp;
    }

    public void setTip(int tip) {
        this.tip = tip;
    }

    public void setTsp(int tsp) {
        this.tsp = tsp;
    }

    public void setCure(int cure) {
        this.cure = cure;
    }

    public void setDead(int dead) {
        this.dead = dead;
    }
}
