<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2020/10/28
  Time: 0:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>创意工坊</title>
    <link rel="stylesheet" href="../static/custom-css/upImage.css">
    <script src="https://kit.fontawesome.com/a076d05399.js"></script>
    <!--引入jquery-->
    <script src="../static/jquery/jquery-3.5.1.min.js"></script>
</head>
<body id="body">
<div class="container">
    <div class="wrapper">
        <div class="image">
            <img src="">
        </div>
        <div class="content">
            <div class="icon"><i class="fas fa-cloud-upload-alt"></i></div>
            <div class="text">No file chosen, yet!</div>
        </div>
        <div id="cancel-btn"><i class="fas fa-times"></i></div>
        <div class="file-name">File name here</div>
    </div>
    <input id="default-btn" type="file" hidden>
    <button onclick = "defaultBtnActive()" id="custom-btn">Choose a file</button>

    <%--<button onclick="uploadFile()" id="upload-btn">Uplaod File</button>--%>
    <form method="post" action="/uploadImg.do">
        <input id="imgsrc" name="imgsrc" value="" style="display: none">
        <input type="submit" id="upload-btn" value="Uplaod File">
    </form>
</div>
<script>
    const wrapper = document.querySelector(".wrapper");
    const fileName = document.querySelector(".file-name");
    const cancelBtn = document.querySelector("#cancel-btn");
    const defaultBtn = document.querySelector("#default-btn");
    const customBtn = document.querySelector("#custom-btn");

    let img = document.querySelector("img");
    let regExp = /[0-9a-zA-Z\^\&\'\@\{\}\[\]\,\$\=\!\-\#\(\)\.\%\+\~\_ ]+$/;
    function defaultBtnActive(){
        defaultBtn.click();
    }
    defaultBtn.addEventListener("change", function(){
        const file = this.files[0];
        if(file){
            const reader = new FileReader();
            reader.onload = function(){
                const result = reader.result;
                img.src = result;
                $('#imgsrc').attr('value',img.src.toString());
                wrapper.classList.add("active");
            }
            cancelBtn.addEventListener("click",function(){
                img.src = "";
                wrapper.classList.remove("active");
            });
            reader.readAsDataURL(file);
        }
        if(this.value){
            let valueStore = this.value.match(regExp);
            fileName.textContent = valueStore;
        }
    });

</script>
</body>
</html>