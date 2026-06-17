<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%@ include file="webutil.jsp" %>

<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>旅行用Travel</title>

<link rel="stylesheet" href="style.css">
<script src="script.js" defer></script>
</head>

<body>

<!-- ✅ header 一定要放 body 裡 -->
<%@ include file="header.jsp" %>

<section class="products">
  <h2>長途旅行 Check-In Travel</h2>

  <div class="product-grid">

<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    con = getConnection();

    ps = con.prepareStatement(
        "SELECT * FROM product WHERE category = 'travel'"
    );

    rs = ps.executeQuery();

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

    <div class="product"
         data-id="<%= id %>"
         data-name="<%=escapeHtml(fullName)%>"
         data-price="<%= price %>"
         data-img="<%=escapeHtml(image)%>">

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

      <img src="images/heart.png"
           class="favorite-icon"
           alt="收藏"
           onclick="toggleFavorite(event, this)">

      <button class="add-cart-btn">加入購物車</button>

    </div>

<%
    }

} catch(Exception e){
    out.println("錯誤：" + e.getMessage());
} finally {
    if(rs != null) rs.close();
    if(ps != null) ps.close();
    if(con != null) con.close();
}
%>

  </div>
</section>

<footer>
  <p>聯絡我們｜service@standardday.com</p>
  <p>© 2025 STANDARD DAY. All rights reserved.</p>
  <p><a href="privacy.html" style="color:#bbb;">隱私權政策</a></p>
</footer>

<button id="backToTop" title="回到頂部">↑</button>

<script src="cookie-consent.js" defer></script>
<script>
    // 頁面載入時自動執行：同步收藏狀態
    document.addEventListener("DOMContentLoaded", () => {
        fetch("favorite_list.jsp")
            .then(res => res.json())
            .then(data => {
                // 將後端回傳的 ID 整理成陣列 (假設回傳結構是 [{id: 1}, {id: 2}])
                const favoriteIds = data.map(item => item.id);

                // 檢查頁面上每一個產品卡片
                document.querySelectorAll(".product").forEach(product => {
                    const id = parseInt(product.dataset.id);
                    const icon = product.querySelector(".favorite-icon");

                    if (icon) {
                        // 如果該 ID 在清單內，顯示實心；否則顯示空心
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
