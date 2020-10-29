package com.face.entity;

/**
 * @Author Ni RunFeng
 * @Date 2020/10/22 17:34
 * @Version 1.0
 */
public class Image {
    private int id;
    private String base64;

    public Image() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBase64() {
        return base64;
    }

    public void setBase64(String base64) {
        this.base64 = base64;
    }

    @Override
    public String toString() {
        return "Image{" +
                "id=" + id +
                ", base64='" + base64 + '\'' +
                '}';
    }
}
