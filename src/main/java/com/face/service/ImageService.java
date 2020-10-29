package com.face.service;

import com.face.entity.Image;

import java.util.List;

/**
 * @Author Ni RunFeng
 * @Date 2020/10/24 21:39
 * @Version 1.0
 */
public interface ImageService {
    /**
     *
     * @return
     */
    public List<Image> findAllImage();
    /**
     * 根据id查询Image
     * @param id
     * @return base64
     */
    public String findImgById(int id);

    /**
     * 添加图片
     * @param image
     */
    public void addImage(Image image);

    /**
     * 根据id删除图片
     * @param id
     */
    public void delImage(int id);
}
