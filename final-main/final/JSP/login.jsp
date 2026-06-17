<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>登入｜VANTERA</title>

<link rel="stylesheet" href="../CSS/style.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@100..900&family=Oxanium:wght@200..800&display=swap" rel="stylesheet">
<style>
body{
    margin:0;
    font-family:"Oxanium","Noto Sans TC", sans-serif;
    font-weight:100;
    background: #f6f6f6;
}

/* ===== 登入區塊置中 ===== */
.login-wrapper{
    height: calc(100vh - 120px);
    display:flex;
    justify-content:center;
    align-items:center;
}

/* ===== 登入卡片 ===== */
.login-card{
    width: 360px;
    background: #fff;
    padding: 35px 30px;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    text-align:center;
    animation: fadeIn 0.6s ease;
}

@keyframes fadeIn{
    from{opacity:0; transform: translateY(20px);}
    to{opacity:1; transform: translateY(0);}
}

.login-title{
    font-size: 22px;
    margin-bottom: 20px;
    letter-spacing: 2px;
    color:#222;
}

/* ===== input ===== */
.login-input{
    width:100%;
    padding: 12px 14px;
    margin: 8px 0;
    border:1px solid #ddd;
    border-radius: 10px;
    outline:none;
    transition: 0.3s;
}

.login-input:focus{
    border-color:#333;
    box-shadow: 0 0 0 3px rgba(0,0,0,0.05);
}

/* ===== button ===== */
.login-btn{
    width:100%;
    padding: 12px;
    margin-top: 15px;
    border:none;
    border-radius: 10px;
    background:#222;
    color:white;
    cursor:pointer;
    font-size: 15px;
    transition: 0.3s;
}

.login-btn:hover{
    background:#444;
    transform: translateY(-2px);
}

/* ===== 註冊連結 ===== */
.register-link{
    margin-top: 15px;
    font-size: 13px;
    color:#666;
    cursor:pointer;
}

.register-link:hover{
    color:#000;
    text-decoration: underline;
}
</style>
</head>

<body>
<!-- ===== 登入區 ===== -->
<div class="login-wrapper">

  <div class="login-card">
    <div class="login-title">會員登入</div>

    <form action="login_process.jsp" method="post">
      <input class="login-input" type="text" name="username" placeholder="帳號">
      <input class="login-input" type="password" name="password" placeholder="密碼">

      <button class="login-btn" type="submit">登入</button>
    </form>

    <div class="register-link" onclick="location.href='JSP/register.jsp'">
  還沒有帳號？立即註冊
</div>
  </div>

</div>
<footer>
  <p>聯絡我們｜vantera2026@gmail.com</p>
  <p>© 2026 VANTERA. All rights reserved.</p>
  <p><a href="privacy.html" style="color:#bbb;">隱私權政策</a></p>
</footer>
<!-- Cookie 同意 -->
<script src="../JavaScript/cookie-consent.js" defer></script>

</body>
</html>
