<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%@ include file="webutil.jsp" %>
<%@ include file="header.jsp" %>
<%
String resultType = null;
String resultMsg = null;

// 📥 新增：接收測驗結果並計算
String q1 = request.getParameter("q1");
String q2 = request.getParameter("q2");
String q3 = request.getParameter("q3");
String q4 = request.getParameter("q4");
String q5 = request.getParameter("q5");

if (q1 != null && q2 != null && q3 != null && q4 != null && q5 != null) {
    // 簡單的計分邏輯：把所有選項的值加起來
    int totalScore = Integer.parseInt(q1) + Integer.parseInt(q2) + 
                     Integer.parseInt(q3) + Integer.parseInt(q4) + 
                     Integer.parseInt(q5);
    
    // 根據總分判定推薦的行李箱類型
    if (totalScore <= 7) {
        resultType = "極致輕便登機箱";
        resultMsg = "你是一位追求效率的精簡實用派！20吋的輕量登機箱最適合你，說走就走毫無負擔。";
    } else if (totalScore <= 11) {
        resultType = "時尚萬用商務/全能箱";
        resultMsg = "你的旅行頻率與天數非常標準，推薦 24-26 吋的中型行李箱，容量與機動性完美平衡。";
    } else {
        resultType = "豪華大容量奢華深箱";
        resultMsg = "看來你熱愛長途旅行或是一位購物狂潮兒！29吋以上的大容量巨無霸行李箱絕對是你的神隊友。";
    }
}
%>
<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

int count = 0;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = getConnection();

    // 不是刷新才增加
    if(session.getAttribute("visitor_counted") == null){

        ps = con.prepareStatement(
            "UPDATE counter SET count = count + 1 WHERE id = 1"
        );
        ps.executeUpdate();
        ps.close();

        session.setAttribute("visitor_counted", Boolean.TRUE);
    }

    ps = con.prepareStatement(
        "SELECT count FROM counter WHERE id = 1"
    );

    rs = ps.executeQuery();

    if(rs.next()){
        count = rs.getInt("count");
    }

}catch(Exception e){
    out.println("錯誤：" + e.getMessage());
}
%>

<!DOCTYPE html>
<html lang="zh-Hant">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>STANDARD DAY Clothing Store</title>

  <link rel="stylesheet" href="style.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@100..900&family=Oxanium:wght@200..800&display=swap" rel="stylesheet">
  <style>
  .visitor{
      width:200px;
      margin:10px auto;
      padding:5px;
      text-align:center;
      font-size:18px;
  }

  /* 🧳 測驗專屬全新美化樣式 */
  .quiz-section {
      max-width: 600px;
      margin: 40px auto;
      padding: 30px;
      background: #ffffff;
      border-radius: 16px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.05);
      text-align: center;
      font-family: 'Noto Sans TC', sans-serif;
  }
  .quiz-section h3 {
      font-size: 24px;
      color: #222;
      margin-bottom: 25px;
      font-weight: 600;
      letter-spacing: 1px;
  }
  .quiz-progress {
      font-size: 14px;
      color: #888;
      margin-bottom: 15px;
  }
  .quiz-step {
      display: none; /* 預設隱藏，由 JS 控制顯示 */
      animation: fadeIn 0.4s ease-in-out;
  }
  .quiz-step.active {
      display: block;
  }
  .quiz-step p {
      font-size: 18px;
      color: #444;
      margin-bottom: 20px;
      font-weight: 500;
  }
  .quiz-section select {
      width: 100%;
      padding: 12px 20px;
      font-size: 16px;
      border: 2px solid #e0e0e0;
      border-radius: 8px;
      background-color: #fafafa;
      color: #333;
      outline: none;
      transition: all 0.3s ease;
      cursor: pointer;
  }
  .quiz-section select:focus {
      border-color: #222;
      background-color: #fff;
  }
  .quiz-btn-group {
      margin-top: 30px;
      display: flex;
      justify-content: space-between;
      gap: 15px;
  }
  .quiz-btn {
      flex: 1;
      padding: 12px;
      font-size: 16px;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      transition: all 0.3s ease;
      font-weight: 500;
  }
  .quiz-btn.next-btn, .quiz-btn.submit-btn {
      background-color: #222;
      color: #fff;
  }
  .quiz-btn.next-btn:hover, .quiz-btn.submit-btn:hover {
      background-color: #444;
  }
  .quiz-btn.prev-btn {
      background-color: #eee;
      color: #555;
  }
  .quiz-btn.prev-btn:hover {
      background-color: #ddd;
  }

  /* ✨ 測驗結果美化樣式 */
  .quiz-result-box {
      background: #f9f9f9;
      border-left: 5px solid #222;
      padding: 20px;
      margin-top: 25px;
      border-radius: 4px 12px 12px 4px;
      text-align: left;
      animation: fadeIn 0.5s ease;
  }
  .quiz-result-box h4 {
      margin: 0 0 10px 0;
      font-size: 20px;
      color: #222;
  }
  .quiz-result-box p {
      margin: 0;
      font-size: 15px;
      color: #666;
      line-height: 1.6;
  }

  @keyframes fadeIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
  }
  </style>
</head>

<body>

<%
String msg = (String) session.getAttribute("msg");

if ("logout".equals(msg)) {
    session.removeAttribute("msg");
%>
<script>
alert("您已成功登出");
</script>
<%
}
%>

<script src="script.js"></script>

<%
if (session.getAttribute("intro_shown") == null) {
    session.setAttribute("intro_shown", true);
%>
    <div class="intro" id="intro">
      <div class="title">
        <span class="left">STANDARD</span>
        <span class="right">DAY</span>
      </div>
    </div>
<%
} else {
%>
    <div class="intro" id="intro" style="display: none;"></div>
<%
}
%>
<section class="banner">
  <img id="bannerImage" src="../images/banner1.jpg">

  <div class="banner-text">
    <h1 id="bannerTitle"></h1>
    <p id="bannerDesc"></p>
    <button id="bannerBuyNowBtn">立即選購</button>
  </div>

  <div id="dotsContainer"></div>
  <button class="prev">‹</button>
  <button class="next">›</button>
</section>


<section class="quiz-section">
    <h3>測驗你最適合的行李箱</h3>
    
    <% if (resultType == null) { %>
        <div class="quiz-progress" id="quizProgress">第 1 / 5 題</div>

        <form method="post" id="quizForm">
            <div class="quiz-step active" data-step="1">
                <p>你旅行頻率？</p>
                <select name="q1">
                    <option value="1">很常（每月）</option>
                    <option value="2">偶爾（每季）</option>
                    <option value="3">很少</option>
                </select>
            </div>

            <div class="quiz-step" data-step="2">
                <p>旅行天數？</p>
                <select name="q2">
                    <option value="1">1–3天</option>
                    <option value="2">4–7天</option>
                    <option value="3">7天以上</option>
                </select>
            </div>

            <div class="quiz-step" data-step="3">
                <p>你偏好行李重量？</p>
                <select name="q3">
                    <option value="1">越輕越好</option>
                    <option value="2">普通</option>
                    <option value="3">不在意</option>
                </select>
            </div>

            <div class="quiz-step" data-step="4">
                <p>出國還是國內？</p>
                <select name="q4">
                    <option value="1">常出國</option>
                    <option value="2">國內旅遊</option>
                    <option value="3">都差不多</option>
                </select>
            </div>

            <div class="quiz-step" data-step="5">
                <p>你的收納習慣？</p>
                <select name="q5">
                    <option value="1">精簡派</option>
                    <option value="2">普通整理</option>
                    <option value="3">東西很多</option>
                </select>
            </div>

            <div class="quiz-btn-group">
                <button type="button" class="quiz-btn prev-btn" id="prevBtn" style="visibility: hidden;">上一題</button>
                <button type="button" class="quiz-btn next-btn" id="nextBtn">下一題</button>
                <button type="submit" class="quiz-btn submit-btn" id="submitBtn" style="display: none;">看結果</button>
            </div>
        </form>
    <% } else { %>
        <div class="quiz-result-box">
            <h4>專屬你的測驗結果：<%= resultType %></h4>
            <p><%= resultMsg %></p>
        </div>
        <div class="quiz-btn-group">
            <button type="button" class="quiz-btn next-btn" onclick="window.location.href=window.location.pathname;">重新測驗</button>
        </div>
    <% } %>
</section>


<div class="visitor">
  您是本站第 <b><%= count %></b> 位訪客
</div>

<section class="products">

<h2>熱門商品</h2>

<div class="product-grid">

<%
Connection con2 = getConnection();
PreparedStatement ps2 = con2.prepareStatement(
    "SELECT * FROM product LIMIT 3"
);
ResultSet rs2 = ps2.executeQuery();

while(rs2.next()){
%>

<div class="product"
     data-id="<%= rs2.getInt("id") %>"
     data-name="<%=escapeHtml(rs2.getString("name"))%>"
     data-price="<%= rs2.getInt("price") %>"
     data-img="<%=escapeHtml(rs2.getString("image"))%>">
    
    <a href="product.jsp?id=<%= rs2.getInt("id") %>" class="product-link">
        <img src="<%=escapeHtml(rs2.getString("image"))%>" alt="<%=escapeHtml(rs2.getString("name"))%>">
        <div class="product-info">
            <div class="product-name"><%=escapeHtml(rs2.getString("name"))%></div>
            <div class="product-price">NT$<%= rs2.getInt("price") %></div>
        </div>
    </a>

    <img src="/final/final/images/heart.png" class="favorite-icon" alt="收藏" onclick="toggleFavorite(event, this)">

    <button class="add-cart-btn">加入購物車</button>
</div>

<%
}
rs2.close();
ps2.close();
%>

</div>

<h2>旅行Travel</h2>

<div class="product-grid">

<%
PreparedStatement psTop = con2.prepareStatement(
     "SELECT * FROM product WHERE category = 'plane' LIMIT 3"
);
ResultSet rsTop = psTop.executeQuery();

while(rsTop.next()){
%>

<div class="product" data-id="<%= rsTop.getInt("id") %>">
    <a href="product.jsp?id=<%= rsTop.getInt("id") %>" class="product-link">
        <img src="<%=escapeHtml(rsTop.getString("image"))%>" alt="<%=escapeHtml(rsTop.getString("name"))%>">
        <div class="product-info">
            <div class="product-name"><%=escapeHtml(rsTop.getString("name"))%></div>
            <div class="product-price">NT$<%= rsTop.getInt("price") %></div>
        </div>
    </a>

    <img src="../images/heart.png"
         class="favorite-icon"
         onclick="toggleFavorite(event, this)">

    <button class="add-cart-btn">加入購物車</button>
</div>

<%
}
rsTop.close();
psTop.close();
%>

</div>
<h2>登機Boarding</h2>

<div class="product-grid">

<%
PreparedStatement psBottom = con2.prepareStatement(
    "SELECT * FROM product WHERE category = 'travel' LIMIT 3"
);
ResultSet rsBottom = psBottom.executeQuery();

while(rsBottom.next()){
%>

<div class="product" data-id="<%= rsBottom.getInt("id") %>">
    <a href="product.jsp?id=<%= rsBottom.getInt("id") %>" class="product-link">
        <img src="<%=escapeHtml(rsBottom.getString("image"))%>" alt="<%=escapeHtml(rsBottom.getString("name"))%>">
        <div class="product-info">
            <div class="product-name"><%=escapeHtml(rsBottom.getString("name"))%></div>
            <div class="product-price">NT$<%= rsBottom.getInt("price") %></div>
        </div>
    </a>

    <img src="../images/heart.png"
         class="favorite-icon"
         onclick="toggleFavorite(event, this)">

    <button class="add-cart-btn">加入購物車</button>
</div>

<%
}
rsBottom.close();
psBottom.close();
con2.close();
%>

</div>

</section>

<footer>
  <p>聯絡我們｜service@standardday.com</p>
  <p>© 2025 STANDARD DAY. All rights reserved.</p>
  <p><a href="privacy.html" style="color:#bbb;">隱私權政策</a></p>
</footer>

<button id="backToTop">↑</button>
<script src="cookie-consent.js" defer></script>
<script>
    // 🎮 測驗動態一題題切換邏輯 (有做過防 Java 衝突處理)
    let currentStep = 1;
    const totalSteps = 5;

    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');
    const submitBtn = document.getElementById('submitBtn');
    const progressText = document.getElementById('quizProgress');

    function updateQuizStep() {
        if(!prevBtn || !nextBtn) return; // 如果已經是結果畫面，就不用執行
        
        // 切換題目 active 狀態
        document.querySelectorAll('.quiz-step').forEach(step => {
            step.classList.remove('active');
        });
        const currentStepEl = document.querySelector('.quiz-step[data-step="' + currentStep + '"]');
        if(currentStepEl) currentStepEl.classList.add('active');

        // 更新上方第幾題進度文字
        if(progressText) progressText.innerText = "第 " + currentStep + " / " + totalSteps + " 題";

        // 第一題時隱藏「上一題」按鈕
        if (currentStep === 1) {
            prevBtn.style.visibility = 'hidden';
        } else {
            prevBtn.style.visibility = 'visible';
        }

        // 最後一題時切換為「看結果」按鈕
        if (currentStep === totalSteps) {
            nextBtn.style.display = 'none';
            submitBtn.style.display = 'inline-block';
        } else {
            nextBtn.style.display = 'inline-block';
            submitBtn.style.display = 'none';
        }
    }

    if(nextBtn) {
        nextBtn.addEventListener('click', () => {
            if (currentStep < totalSteps) {
                currentStep++;
                updateQuizStep();
            }
        });
    }

    if(prevBtn) {
        prevBtn.addEventListener('click', () => {
            if (currentStep > 1) {
                currentStep--;
                updateQuizStep();
            }
        });
    }

    // 頁面載入時自動執行：同步收藏狀態
    document.addEventListener("DOMContentLoaded", () => {
        fetch("favorite_list.jsp")
            .then(res => res.json())
            .then(data => {
                const favoriteIds = data.map(item => item.id);

                document.querySelectorAll(".product").forEach(product => {
                    const id = parseInt(product.dataset.id);
                    const icon = product.querySelector(".favorite-icon");

                    if (icon) {
                        if (favoriteIds.includes(id)) {
                            icon.src = "images/love.png";
                        } else {
                            icon.src = "images/heart.png";
                        }
                    }
                });
            });
    });
</script>

</body>
</html>
