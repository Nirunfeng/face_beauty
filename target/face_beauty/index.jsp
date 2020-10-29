<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2020/10/24
  Time: 23:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta charset="UTF-8">
    <title>首页</title>
    <%--引入bootstrap--%>
    <script src="static/bootstrap/js/bootstrap.min.js"></script>
    <%--引入jquery--%>
    <script src="static/jquery/jquery-3.5.1.min.js"></script>
    <%--引入CSS--%>
    <link rel="stylesheet" href="static/custom-css/index.css">
    <style>
        body{
            background: #fff;
        }
    </style>
</head>
<body>
<%--<div class="container">
    <div class="row">
        <a class="btn" href="fore/crema.html">拍摄照片</a>
    </div>
    <div class="row">
        <a class="btn" href="/Imglist.do">照片列表</a>
    </div>
    <div class="row">
        <a class="btn" href="/fore/upImage.html">上传图片</a>
    </div>
</div>--%>
<a id="crema" href="fore/crema.jsp">拍摄照片</a>
<a id="list" href="/Imglist.do">照片列表</a>
<a id="upload" href="/fore/upImage.jsp">上传图片</a>
</body>
</html>
