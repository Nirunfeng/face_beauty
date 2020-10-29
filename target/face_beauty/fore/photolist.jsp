<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2020/10/25
  Time: 12:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>照片列表</title>
    <%--引入bootstrap--%>
    <link rel="stylesheet" href="../static/bootstrap/css/bootstrap.min.css">
    <script src="../static/bootstrap/js/bootstrap.min.js"></script>
    <%--引入jquery--%>
    <script src="../static/jquery/jquery-3.5.1.min.js"></script>
    <style>
        *{
            margin: 0;
            padding: 0;
        }
        body{
            background: #fff;
        }
        h2{
            text-align: center;
            color: #fff;
        }
        table{
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row">
        <h2 class="h2">照片</h2>
    </div>
    <div class="row">
        <table class="table">
            <%--TODO--%>
            <c:forEach items="${imageList}" var="img">
                <tr>
                    <td>
                        <img src="data:image/png; base64,${img.base64}">
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>
</div>
</body>
</html>
