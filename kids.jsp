<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%@ include file="webutil.jsp" %>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>親子友善 | VANTERA</title>
<link rel="stylesheet" href="style.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@100&family=Oxanium&display=swap" rel="stylesheet">
<script src="script.js" defer></script>
</head>
<style>
    /* 確保卡片定位點 */
.product {
    position: relative;
}

/* 圖示懸浮位置 (與首頁一致) */
.favorite-icon, .share-icon {
    width: 24px !important;
    height: 24px !important;
    padding: 8px;
    position: absolute;
    bottom: 75px; 
    cursor: pointer;
    box-sizing: content-box;
    transition: transform 0.2s;
    z-index: 2;
}

.favorite-icon { right: 50px; }
.share-icon { right: 10px; }
</style>
<body>
<%@ include file="header.jsp" %>
<%
Connection con = getConnection();
PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM product WHERE category = 'family'"
);
ResultSet rs = ps.executeQuery();
%>

<section class="products">
  <h2>親子友善 Family Vacation</h2>

  <div class="product-grid">

  <%
  while(rs.next()){
      int id = rs.getInt("id");
      String fullName = rs.getString("name");
      int price = rs.getInt("price");
      String image = rs.getString("image");

      // 🔍 自動尋找最後一個英文跟中文交界的空格進行拆分
      int splitIdx = fullName.lastIndexOf(" "); 
      String engName = (splitIdx != -1) ? fullName.substring(0, splitIdx) : fullName;
      String chName = (splitIdx != -1) ? fullName.substring(splitIdx + 1) : "";
  %>

    <div class="product" data-id="<%= id %>">
      <a href="product.jsp?id=<%= id %>" class="product-link">

        <img src="<%=escapeHtml(image)%>" alt="<%=escapeHtml(fullName)%>">

        <div class="product-info">
          <div class="product-name" style="line-height: 1.4; min-height: 48px; text-align: left;">
              <span style="font-weight: 600; display: block; color: #222;"><%= escapeHtml(engName) %></span>
              <span style="font-size: 20px; color: #666; display: block; margin-top: 2px;"><%= escapeHtml(chName) %></span>
          </div>
          <div class="product-price">NT$<%= price %></div>
        </div>

      </a>

      <div class="product-actions">
    <img src="images/heart.png" class="favorite-icon" onclick="toggleFavorite(event, this)">
    <img src="images/share.png" class="share-icon" onclick="shareProduct(event, '<%= escapeHtml(fullName) %>', 'product.jsp?id=<%= id %>')">
</div>
<button class="add-cart-btn">加入購物車</button>

    </div>

  <%
  }
  rs.close();
  ps.close();
  con.close();
  %>

  </div>
</section>

<footer>
  <p>聯絡我們｜service@standardday.com</p>
  <p>© 2025 STANDARD DAY. All rights reserved.</p>
  <p><a href="privacy.html" style="color:#bbb;">隱私權政策</a></p>
</footer>

<button id="backToTop" title="回到頂部">↑</button>

<!-- Cookie 同意提示（組員D：個資法/Cookie） -->
<script src="cookie-consent.js" defer></script>
<script>
    // 🚀 新增分享功能函式
    function shareProduct(event, name, url) {
        event.preventDefault();
        event.stopPropagation(); // 防止點擊圖示時觸發頁面跳轉
        const shareData = { 
            title: 'VANTERA 推薦商品', 
            text: `看看這個行李箱：${name}`, 
            url: window.location.origin + '/' + url 
        };
        
        if (navigator.share) {
            navigator.share(shareData).catch(err => console.error("分享失敗:", err));
        } else {
            // 不支援 Web Share API 的瀏覽器改為複製連結
            navigator.clipboard.writeText(shareData.url).then(() => alert('商品連結已複製！'));
        }
    }

    // 頁面載入時同步狀態
    document.addEventListener("DOMContentLoaded", () => {
        fetch("favorite_list.jsp")
            .then(res => res.json())
            .then(data => {
                const favoriteIds = data.map(item => item.id);
                document.querySelectorAll(".product").forEach(product => {
                    const id = parseInt(product.dataset.id);
                    const icon = product.querySelector(".favorite-icon");
                    if (icon && favoriteIds.includes(id)) {
                        icon.src = "images/love.png";
                    }
                });
            })
            .catch(err => console.log("收藏列表載入中或為空"));
    });
</script>

</body>
</html>

