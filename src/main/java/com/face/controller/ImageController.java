package com.face.controller;

import com.face.dao.ImageDao;
import com.face.entity.Image;
import com.face.service.ImageService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @Author Ni RunFeng
 * @Date 2020/10/24 21:45
 * @Version 1.0
 */
@Controller
public class ImageController {
    @Resource
    private ImageService imageService;

    /**
     * 接收拍照获取的图片并保存至数据库
     * @param base64
     * @return
     */
    @RequestMapping("/saveImage")
    @ResponseBody
    public String saveImage(String base64){
        if (base64 != null) {
            Image image=new Image();
            image.setBase64(base64);
            imageService.addImage(image);
        }
        return "success";
    }

    @RequestMapping("/Imglist")
    public ModelAndView ImageList(){
        ModelAndView modelAndView=new ModelAndView();
        List<Image> imageList=imageService.findAllImage();
        modelAndView.addObject("imageList",imageList);
        modelAndView.setViewName("photolist");
        return modelAndView;
    }

    /*转发图片至beauty*/
    @RequestMapping(value = "/uploadImg")
    public ModelAndView ReceiveImage(@RequestParam("imgsrc") String imgsrc){
        ModelAndView modelAndView=new ModelAndView();
        modelAndView.addObject("base64",imgsrc);
        modelAndView.setViewName("beauty");
        return modelAndView;
    }
}
