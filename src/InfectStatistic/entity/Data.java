package InfectStatistic.entity;

public class Data {
    private int id;
    private String date;
    private String province;
    private int ip;
    private int sp;
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

    public int getIp() {
        return ip;
    }

    public int getSp() {
        return sp;
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

    public void setIp(int ip) {
        this.ip = ip;
    }

    public void setSp(int sp) {
        this.sp = sp;
    }

    public void setCure(int cure) {
        this.cure = cure;
    }

    public void setDead(int dead) {
        this.dead = dead;
    }
}
