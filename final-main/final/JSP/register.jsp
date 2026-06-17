<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>註冊｜VANTERA</title>

<link rel="stylesheet" href="CSS/style.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@100..900&family=Oxanium:wght@200..800&display=swap" rel="stylesheet">
<style>
body{
    margin:0;
    font-family: "Oxanium","Noto Sans TC", sans-serif;
    background: #f6f6f6;
}

/* ===== 註冊區塊置中 ===== */
.register-wrapper{
    min-height: calc(100vh - 120px);
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 40px 0; /* 留點上下間距，避免手機版塞滿 */
}

/* ===== 註冊卡片 ===== */
.register-card{
    width: 360px;
    background: #fff;
    padding: 35px 30px;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    text-align: center;
    animation: fadeIn 0.6s ease;
}

@keyframes fadeIn{
    from{opacity:0; transform: translateY(20px);}
    to{opacity:1; transform: translateY(0);}
}

.register-title{
    font-size: 22px;
    margin-bottom: 20px;
    letter-spacing: 2px;
    color: #222;
}

/* ===== input ===== */
.register-input{
    width: 100%;
    padding: 12px 14px;
    margin: 8px 0;
    border: 1px solid #ddd;
    border-radius: 10px;
    outline: none;
    box-sizing: border-box; /* 防止 input 超出卡片寬度 */
    transition: 0.3s;
}

.register-input:focus{
    border-color: #333;
    box-shadow: 0 0 0 3px rgba(0,0,0,0.05);
}

/* ===== button ===== */
.register-btn{
    width: 100%;
    padding: 12px;
    margin-top: 15px;
    border: none;
    border-radius: 10px;
    background: #222;
    color: white;
    cursor: pointer;
    font-size: 15px;
    transition: 0.3s;
}

.register-btn:hover{
    background: #444;
    transform: translateY(-2px);
}

/* ===== 返回登入連結 ===== */
.login-link{
    margin-top: 15px;
    font-size: 13px;
    color: #666;
    cursor: pointer;
}

.login-link:hover{
    color: #000;
    text-decoration: underline;
}
.privacy-consent{display:flex;align-items:flex-start;gap:8px;margin-top:12px;text-align:left;font-size:13px;line-height:1.5}
.privacy-consent input{margin-top:3px}
</style>
</head>

<body>
<div class="register-wrapper">

  <div class="register-card">
    <div class="register-title">新會員註冊</div>

    <form action="JSP/register_process.jsp" method="post">
      
      <input class="register-input" type="text" name="username" placeholder="請設定帳號" required>
      <input class="register-input" type="password" name="password" placeholder="請設定密碼" required>
      <input class="register-input" type="text" name="name" placeholder="真實姓名" required>
      <input class="register-input" type="email" name="email" placeholder="電子信箱" required>
      <input class="register-input" type="text" name="phone" placeholder="行動電話" required>
      <label class="privacy-consent">
        <input type="checkbox" name="agree_privacy" value="yes" required>
        <span>我已閱讀並同意<a href="privacy.html" target="_blank" rel="noopener">隱私權政策</a>及個人資料蒐集、處理與利用說明。</span>
      </label>

      <button class="register-btn" type="submit">確認註冊</button>
    </form>

    <div class="login-link" onclick="location.href='JSP/login.jsp'">
      已有帳號？返回登入
    </div>
  </div>

</div>
<footer>
  <p>聯絡我們｜vantera2026@gmail.com</p>
  <p>© 2026 VANTERA. All rights reserved.</p>
  <p><a href="privacy.html" style="color:#bbb;">隱私權政策</a></p>
</footer>
<script src="JavaScript/cookie-consent.js" defer></script>

</body>
</html>
