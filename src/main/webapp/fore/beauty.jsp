<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2020/10/26
  Time: 14:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
    <link rel="stylesheet" href="../static/custom-css/beauty.css">
    <title>创意工坊</title>
    <style>
        body{
            background:#fff;
        }
    </style>

</head>

<body>
<p id="canvasboxbar">
    <span>
        滤镜：
    </span>
    <span>
        <input type="checkbox" id="invert"> 反相（负片）
    </span>

    <span>
        <input type="checkbox" id="grayscale"> 灰化
    </span>

    <span>
        <input type="checkbox" id="sepia"> 复古(怀旧)
    </span>

    <span>
        <input type="checkbox" id="brightness"> 变亮
    </span>

    <span>
        <input type="checkbox" id="threshold"> 阈值
    </span>

    <span>
        <input type="checkbox" id="blur"> 模糊
    </span>

    <span>
        <input type="checkbox" id="relief"> 浮雕
    </span>
</p>
<%--动态数值条--%>
<div class="valuebar">
    <input type="range" min="0" max="100" step="1" value="10">
</div>
<canvas id="canvas" width="250" height="300" ></canvas>
<canvas id="canvasout" width="250" height="300"></canvas>
<p id="beautyboxbar">
    <span>
        美颜：
    </span>
    <span>
        <input type="checkbox" id="dermabrasion"> 磨皮
    </span>
</p>

<script src="../static/opencvjs/opencv.js"></script>
<script src="../static/custom-js/StackBlur.js"></script>
<script>
    function draw(){
        var canvas = document.getElementById("canvas");
        ctx = canvas.getContext("2d"),
            img = new Image(),
            tempImageData = null,
            imgData = null;

        var invert = document.getElementById("invert"),
            grayscale = document.getElementById("grayscale"),
            sepia = document.getElementById("sepia"),
            brightness = document.getElementById("brightness"),
            threshold = document.getElementById("threshold"),
            blur = document.getElementById("blur"),
            relief = document.getElementById("relief"),
            dermabrasion=document.getElementById("dermabrasion");

        function getInitImageData(){
            ctx.drawImage(img , 0 , 0 , canvas.width , canvas.height);
            tempImageData = ctx.getImageData(0 , 0 , canvas.width , canvas.height); // 重新获取原始图像数据点信息
            imgData = tempImageData.data;
        }

        function getbeautyImageData(){
            ctx.drawImage(img,0,0,canvas.width,canvas.height);
            img.src=canvas.toDataURL();
        }

        //获取处理后的图像信息
        function resetImageData(){
            ctx.drawImage( img , 0 , 0 , canvas.width , canvas.height);
        }

        //canvas滤镜的各个函数
        var canvasFilter = {
            // 反向
            invert : function(obj , i){
                obj[i] = 255 - obj[i];
                obj[i+1] = 255 - obj[i+1];
                obj[i+2] = 255 - obj[i+2];
            },
            // 灰化
            grayscale : function(obj,i){
                var average = (obj[i] + obj[i+1] + obj[i+2]) / 3;
                //var average = 0.2126*obj[i] + 0.7152*obj[i+1] + 0.0722*obj[i+2]; 或者
                obj[i] = obj[i+1] = obj[i+2] = average;
            },
            // 复古
            sepia : function(obj , i){
                var r = obj[i],
                    g = obj[i+1],
                    b = obj[i+2];
                obj[i] = (r*0.393)+(g*0.769)+(b*0.189);
                obj[i+1] = (r*0.349)+(g*0.686)+(b*0.168);
                obj[i+2] = (r*0.272)+(g*0.534)+(b*0.131);
            },
            //变亮
            brightness : function(obj , i , brightVal){
                var r = obj[i],
                    g = obj[i+1],
                    b = obj[i+2];
                obj[i] += brightVal;
                obj[i+1] += brightVal;
                obj[i+2] += brightVal;
            },
            // 阈值
            threshold : function(obj , i , thresholdVal){
                var average = (obj[i] + obj[i+1] + obj[i+2]) / 3;
                obj[i] = obj[i+1] = obj[i+2] = average > thresholdVal ? 255 : 0;
            },
            relief : function(obj , i , canvas){
                if ((i+1) % 4 !== 0) { // 每个像素点的第四个（0,1,2,3  4,5,6,7）是透明度。这里取消对透明度的处理
                    if ((i+4) % (canvas.width*4) == 0) { // 每行最后一个点，特殊处理。因为它后面没有边界点，所以变通下，取它前一个点
                        obj[i] = obj[i-4];
                        obj[i+1] = obj[i-3];
                        obj[i+2] = obj[i-2];
                        obj[i+3] = obj[i-1];
                        i+=4;
                    }
                    else{ // 取下一个点和下一行的同列点，当前点的值乘以2，加上128减去相邻点的值，然后减去下一行对应点的值；
                        obj[i] = 255/2         // 平均值
                            + 2*obj[i]   // 当前像素点
                            - obj[i+4]   // 下一点
                            - obj[i+canvas.width*4]; // 下一行的同列点
                    }
                }
                else {  // 最后一行，特殊处理
                    if ((i+1) % 4 !== 0) {
                        obj[i] = obj[i-canvas.width*4];
                    }
                }
            }
        }

        //美颜的各个函数
        var beautyFilter={
            //磨皮
            /**
             *
             * @param image 传入图片
             * @param skabrasion 磨皮系数
             * @param defactor 细节系数
             */
            dermabrasion:function (image,skabrasion,defactor){
                let dst=new cv.Mat();
                if(skabrasion==null||skabrasion==undefined) skabrasion=3;
                if(defactor==null||defactor==undefined) defactor=1;

                var dx=skabrasion*5;    //双边滤波参数
                var fc=skabrasion*12.5; //参数
                var p=0.1;              //透明度

                let temp1 = new cv.Mat(), temp2 = new cv.Mat(), temp3 = new cv.Mat(), temp4 = new cv.Mat();

                cv.cvtColor(image, image, cv.COLOR_RGBA2RGB, 0);
                cv.bilateralFilter(image, temp1, dx, fc, fc);
                let temp22 = new cv.Mat();
                cv.subtract(temp1, image, temp22);//bilateralFilter(Src) - Src

                cv.add(temp22, new cv.Mat(image.rows, image.cols, image.type(), new cv.Scalar(128, 128, 128, 128)), temp2);//bilateralFilter(Src) - Src + 128

                cv.GaussianBlur(temp2, temp3, new cv.Size(2 * defactor - 1, 2 * defactor - 1), 0, 0);
                //2 * GuassBlur(bilateralFilter(Src) - Src + 128) - 1

                let temp44 = new cv.Mat();
                temp3.convertTo(temp44, temp3.type(), 2, -255);
                //2 * GuassBlur(bilateralFilter(Src) - Src + 128) - 256

                cv.add(image, temp44, temp4);
                cv.addWeighted(image, p, temp4, 1-p, 0.0, dst);
                //Src * (100 - Opacity)

                cv.add(dst, new cv.Mat(image.rows, image.cols, image.type(), new cv.Scalar(10, 10, 10, 0)), dst);
                //(Src * (100 - Opacity) + (Src + 2 * GuassBlur(bilateralFilter(Src) - Src + 128) - 256) * Opacity) /100

                return dst;
            }
        }


        // 反相：取每个像素点与255的差值
        invert.addEventListener( "click" , function(){
            getInitImageData();
            if(this.checked){
                for(var i = 0 , len = imgData.length ; i < len ; i+=4){
                    canvasFilter.invert(imgData , i);
                }
                ctx.putImageData( tempImageData , 0 , 0);
            }
            else{
                resetImageData();
            }
        } , false);

        // 灰化：取某个点的rgb的平均值
        grayscale.addEventListener( "click" , function(){
            getInitImageData();
            if(this.checked){
                for(var i = 0 , len = imgData.length ; i < len ; i+=4){
                    canvasFilter.grayscale(imgData , i);
                }
                ctx.putImageData( tempImageData , 0 , 0);
            }
            else{
                resetImageData();
            }
        } , false);

        // 怀旧：特定公式
        sepia.addEventListener( "click" , function(){
            getInitImageData();
            if(this.checked){
                for(var i = 0 , len = imgData.length ; i < len ; i+=4){
                    canvasFilter.sepia(imgData , i);
                }
                ctx.putImageData( tempImageData , 0 , 0);
            }
            else{
                resetImageData();
            }
        } , false);

        // 变亮：rgb点加上某个数值
        brightness.addEventListener( "click" , function(){
            getInitImageData();
            if(this.checked){
                for(var i = 0 , len = imgData.length ; i < len ; i+=4){
                    canvasFilter.brightness(imgData , i , 30);
                }
                ctx.putImageData( tempImageData , 0 , 0);
            }
            else{
                resetImageData();
            }
        } , false);

        // 阈值：将灰度值与设定的阈值比较，如设置果大于等于阈值，则将该点设置为255，否则为0
        //“阈值”命令将灰度或彩色图像转换为高对比度的黑白图像。您可以指定某个色阶作为阈值。所有比阈值亮的像素转换为白色；而所有比阈值暗的像素转换为黑色。“阈值”命令对确定图像的最亮和最暗区域很有用。
        threshold.addEventListener( "click" , function(){
            getInitImageData();
            if(this.checked){
                for(var i = 0 , len = imgData.length ; i < len ; i+=4){
                    canvasFilter.threshold(imgData , i , 150);
                }
                ctx.putImageData( tempImageData , 0 , 0);
            }
            else{
                resetImageData();
            }
        } , false);

        // 模糊
        // stackblur
        blur.addEventListener( "click" , function(){
            getInitImageData();
            if(this.checked){
                stackBlurCanvasRGBA( "canvas", 0, 0, canvas.width, canvas.height, 10 );
            }
            else{
                resetImageData();
            }
        } , false);

        // 浮雕：取下一个点和下一行对应的点值
        relief.addEventListener( "click" , function(){
            getInitImageData();
            if(this.checked){
                for(var i = 0 , len = imgData.length ; i < len ; i++){
                    canvasFilter.relief(imgData , i , canvas);
                }
                ctx.putImageData( tempImageData , 0 , 0);
            }
            else{
                resetImageData();
            }
        } , false);

        //磨皮
        dermabrasion.addEventListener("click",function (){
            getbeautyImageData();
            if(this.checked){
                let mat = cv.imread(img);
                mat = beautyFilter.dermabrasion(mat,4,3);
                cv.imshow('canvasout', mat);
                mat.delete();
            }
        },false);

        // init
        img.onload = function(){
            getInitImageData();
        }

        img.src = "${base64}";
    }
    draw();

    //动态数值条变化js
    //js代码监听效果，需要绑定监听事件，代码如下：

    var elem = document.querySelector('input[type="range"]');
    //获取一个想显示值的标签，并且初始化默认值
    var target = document.querySelector('.value');
    target.innerHTML = elem.value;

    var rangeValue = function(){
        var newValue = elem.value;
        target.innerHTML = newValue;
    }
    //绑定input监听事件

    elem.addEventListener("input", rangeValue);
</script>

</body>
</html>
