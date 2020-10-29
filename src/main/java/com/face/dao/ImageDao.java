package com.face.dao;

import com.face.entity.Image;

import java.util.List;

/**
 * @Author Ni RunFeng
 * @Date 2020/10/24 21:15
 * @Version 1.0
 */
public interface ImageDao {
    /**
     * 查询所有照片
     * @return 返回base64列表
     */
    public List<Image> findAllImg();
    /**
     *根据id查询图片
     * @param id
     * @return 图片的base64位编码
     */
    public String findImgById(int id);

    /**
     * 向数据库添加图片
     * @param image
     */
    public void insertImg(Image image);

    /**
     * 根据id删除图片
     * @param id
     */
    public void deleteImg(int id);
}
