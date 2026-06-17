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

    <div class="product" data-id="<%= id %>">
      <a href="product.jsp?id=<%= id %>" class="product-link">

        <img src="<%=escapeHtml(image)%>" alt="<%=escapeHtml(fullName)%>">

        <div class="product-info">
          <div class="product-name" style="line-height: 1.4; min-height: 48px; text-align: left;">
              <span style="font-weight: 600; display: block; color: #222;"><%= escapeHtml(engName) %></span>
              <span style="font-size: 14px; color: #666; display: block; margin-top: 2px;"><%= escapeHtml(chName) %></span>
          </div>
          <div class="product-price">NT$<%= price %></div>
        </div>

      </a>

      <img src="images/heart.png" class="favorite-icon" onclick="toggleFavorite(event, this)">
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
