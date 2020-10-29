package com.face.service.Impl;

import com.face.dao.ImageDao;
import com.face.entity.Image;
import com.face.service.ImageService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @Author Ni RunFeng
 * @Date 2020/10/24 21:42
 * @Version 1.0
 */
@Service
public class ImageServiceImpl implements ImageService {

    @Resource
    private ImageDao imageDao;

    @Override
    public List<Image> findAllImage() {
        return imageDao.findAllImg();
    }

    @Override
    public String findImgById(int id) {
        return imageDao.findImgById(id);
    }

    @Override
    public void addImage(Image image) {
        imageDao.insertImg(image);
    }

    @Override
    public void delImage(int id) {
        imageDao.deleteImg(id);
    }
}
