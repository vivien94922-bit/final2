<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%@ include file="webutil.jsp" %>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>登機用 | VANTERA</title>
<link rel="stylesheet" href="../CSS/style.css">
<script src="../JavaScript/script.js" defer></script>
</head>
<body>
<%@ include file="header.jsp" %>
<%
Connection con = getConnection();
PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM product WHERE category = 'boarding'"
);
ResultSet rs = ps.executeQuery();
%>

<section class="products">
  <h2>登機用 Boarding Series</h2>

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

    <div class="product" data-id="<%= id %>" data-name="<%= escapeHtml(fullName) %>" data-price="<%= price %>" data-img="<%= escapeHtml(image) %>">
      <a href="JSP/product.jsp?id=<%= id %>" class="product-link">

        <img src="<%=escapeHtml(image)%>" alt="<%=escapeHtml(fullName)%>">

        <div class="product-info">
          <div class="product-name" style="line-height: 1.4; min-height: 48px; text-align: left;">
              <span style="font-weight: 600; display: block; color: #222;"><%= escapeHtml(engName) %></span>
              <span style="font-size: 20px; color: #666; display: block; margin-top: 2px;"><%= escapeHtml(chName) %></span>
          </div>
          <div class="product-price">NT$<%= price %></div>
        </div>

      </a>

      <img src="images/heart.png" class="favorite-icon" alt="收藏" onclick="toggleFavorite(event, this)">
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
  <p>聯絡我們｜vantera2026@gmail.com</p>
  <p>© 2026 VANTERA. All rights reserved.</p>
  <p><a href="privacy.html" style="color:#bbb;">隱私權政策</a></p>
</footer>

<button id="backToTop" title="回到頂部">↑</button>

<script src="../JavaScript/cookie-consent.js" defer></script>
<script>
    // 頁面載入時自動執行：同步收藏狀態
    document.addEventListener("DOMContentLoaded", () => {
        fetch("JSP/favorite_list.jsp")
            .then(res => res.json())
            .then(data => {
                if (!data) return;
                const favoriteIds = data.map(item => item.id);

                document.querySelectorAll(".product").forEach(product => {
                    const id = parseInt(product.dataset.id);
                    const icon = product.querySelector(".favorite-icon");

                    if (icon) {
                        if (favoriteIds.includes(id)) {
                            icon.src = "../images/love.png";
                        } else {
                            icon.src = "../images/heart.png";
                        }
                    }
                });
            })
            .catch(err => console.log("目前無登入或收藏列表為空"));
    });
</script>

</body>
</html>

