<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2020/10/28
  Time: 0:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>美拍一刻</title>
    <!--引入track.js-->
    <script src="../static/tracking/build/tracking-min.js"></script>
    <script src="../static/tracking/build/data/face-min.js"></script>
    <!--引入jquery-->
    <script src="../static/jquery/jquery-3.5.1.min.js"></script>
    <!--引入bootstrap-->
    <link rel="stylesheet" href="../static/bootstrap/css/bootstrap.min.css">
    <script src="../static/bootstrap/js/bootstrap.min.js"></script>
    <!--引入自定义css-->
    <style>
        /*cream.jsp页面样式*/
        *{
            padding: 0;
            margin: 0;
        }
        /*body CSS*/
        body
        {
            background-color: #fff;
        }

        video, canvas {
            margin-left: 38%;
            position: absolute;
            border-radius: 100%;
        }


        /*button CSS*/
        #button-model
        {
            position: absolute;
            left: 50%;
            top: 90%;
            text-decoration: none;
            transform: translate(-50%,-50%);
            font-size: 24px;
            background: linear-gradient(90deg,#03a9f4,#f441a5,#ffeb3b,#03a9f4);
            background-size: 400%;
            width: 300px;
            height: 100px;
            color: #fff;
            line-height: 100px;
            text-align: center;
            text-transform: uppercase;
            border-radius: 50px;
        }
    </style>
</head>
<body>
<div class="row">
    <a class="btn" href="/index.jsp">返回</a>
</div>
<div>
    <video id="video" width="320" height="320" preload autoplay loop muted></video>
    <canvas id="canvas" width="320" height="320"></canvas>
</div>
<button id="button-model" class="btn" type="button" onclick="Shoot()">拍照</button>
<script>
    window.onload = function() {
        var video = document.getElementById('video');
        var canvas = document.getElementById('canvas');
        var context = canvas.getContext('2d');
        var button=document.getElementById("button-model");

        var tracker = new tracking.ObjectTracker('face');
        tracker.setInitialScale(4);
        tracker.setStepSize(2);
        tracker.setEdgesDensity(0.1);

        tracking.track('#video', tracker, { camera: true });

        tracker.on('track', function(event) {
            context.clearRect(0, 0, canvas.width, canvas.height);

            event.data.forEach(function(rect) {
                context.strokeStyle = '#000';
                context.strokeRect(rect.x, rect.y, rect.width, rect.height);
                context.font = '11px Helvetica';
                context.fillStyle = "#fff";
                context.fillText('x: ' + rect.x + 'px', rect.x + rect.width + 5, rect.y + 11);
                context.fillText('y: ' + rect.y + 'px', rect.x + rect.width + 5, rect.y + 22);
                button.Shoot=function ()
                {
                    console.log(rect);
                    var trackerTask = tracking.track(video, tracker);
                    //先清除掉 canvas 画的框,避免截图获取到这个框 -- 理论上从视频获取不会截取到,但调试时实际有截取,所以做下清除
                    context.clearRect(0, 0, canvas.width, canvas.height);
                    //从视频的这个区域画图,捕获人脸
                    context.drawImage(video,rect.x,rect.y,rect.width,rect.height);
                    //将图片写到元素
                    var img = document.createElement("img");
                    img.src = canvas.toDataURL("image/png");
                    //删除字符串前的提示信息 "data:image/png;base64,"
                    var b64 = img.src.substring(22);
                    //通过ajax实现前后端交互
                    $.ajax({
                        type:'post',
                        //TODO
                        url:'/saveImage.do',
                        data:{
                            "base64":b64.toString()
                        }
                    });
                }
            });
        });
    };
</script>

</body>
</html>
