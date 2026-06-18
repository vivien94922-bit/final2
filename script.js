document.addEventListener("DOMContentLoaded", () => {

  /* ===================== 搜尋 ===================== */
  const searchIcon = document.getElementById("searchIcon");
  const searchBox = document.getElementById("searchBox");
  const searchInput = document.getElementById("searchInput");
  const searchResult = document.getElementById("searchResult");
  
  searchIcon.addEventListener("click", () => {
    searchBox.classList.toggle("active");
  });
  
  let timer;
  
  searchInput.addEventListener("input", () => {
  
    const keyword = searchInput.value.trim();
  
    clearTimeout(timer);
  
    if(keyword.length === 0){
      searchResult.innerHTML = "";
      return;
    }
  
    timer = setTimeout(() => {
  
      fetch("search.jsp?keyword=" + encodeURIComponent(keyword))
        .then(res => res.text())
        .then(data => {
          searchResult.innerHTML = data;
        });
  
    }, 200);
  
  });
  /* ===================== menu ===================== */
  const menuIcon = document.getElementById("menuIcon");
  const menuBox = document.getElementById("menuBox");

  if (menuIcon && menuBox) {
    menuIcon.addEventListener("click", () => {
      menuBox.classList.toggle("active");
    });
  }

  /* ===================== banner ===================== */
  let current = 0;

  const images = ["images/banner1.png","images/banner2.png","images/banner3.png"];
  const titles = ["NEW ARRIVAL", "WANDERLUST", "BUSINESS CLASS"];
  const descs = ["年度新品・限時 8 折起", "尋找你的完美旅行隊友", "專屬商務菁英的頂級移動美學"];
  const ids = [4,14,3];

  function updateBanner() {
    const img = document.getElementById("bannerImage");
    const title = document.getElementById("bannerTitle");
    const desc = document.getElementById("bannerDesc");
    const btn = document.getElementById("bannerBuyNowBtn");
    const dots = document.getElementById("dotsContainer");

    if (!img || !title || !desc || !btn || !dots) return;

    img.src = images[current];
    title.innerText = titles[current];
    desc.innerText = descs[current];

    btn.onclick = () => {
      location.href = `product.jsp?id=${ids[current]}`;
    };

    dots.innerHTML = "";
    images.forEach((_, i) => {
      const dot = document.createElement("span");
      dot.className = i === current ? "dot active" : "dot";
      dot.onclick = () => {
        current = i;
        updateBanner();
      };
      dots.appendChild(dot);
    });
  }

  function next() {
    current = (current + 1) % images.length;
    updateBanner();
  }

  function prev() {
    current = (current - 1 + images.length) % images.length;
    updateBanner();
  }

  setInterval(next, 5000);
  updateBanner();

  document.querySelector(".next")?.addEventListener("click", next);
  document.querySelector(".prev")?.addEventListener("click", prev);

  /* ===================== toast ===================== */
  function toast(msg) {
    const t = document.createElement("div");
    t.className = "toast";
    t.innerText = msg;
    document.body.appendChild(t);

    setTimeout(() => t.classList.add("show"), 10);
    setTimeout(() => t.remove(), 2000);
  }

/* ===================== Header 登入 UI ===================== */
const userArea = document.getElementById("user-area");
if (userArea) {
    // 假設你在登入頁面會存一個 "isLoggedIn": "true" 到 localStorage
    const isLoggedIn = localStorage.getItem("isLoggedIn");
    if (isLoggedIn === "true") {
        userArea.innerHTML = `<a href="member.html">會員中心</a> <a href="logout.html" onclick="localStorage.removeItem('isLoggedIn')">登出</a>`;
    } else {
        userArea.innerHTML = `<a href="login.html"><img src="images/user.png"></a>`;
    }
}
  /* ===================== 回到頂部 ===================== */
  const topBtn = document.getElementById("backToTop");

  if (topBtn) {
    window.addEventListener("scroll", () => {
      topBtn.style.display = window.scrollY > 300 ? "block" : "none";
    });

    topBtn.addEventListener("click", () => {
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
  }

 /* ===================== 加入購物車 (靜態化版本) ===================== */
document.addEventListener("click", async (e) => {
    if (!e.target.classList.contains("add-cart-btn")) return;

    const p = e.target.closest(".product");
    if (!p) return;

    const id = p.dataset.id;
    // 從 localStorage 獲取購物車，沒有則初始化為空陣列
    let cart = JSON.parse(localStorage.getItem("cart")) || [];
    
    // 加入商品
    cart.push({ id: id, quantity: 1 });
    localStorage.setItem("cart", JSON.stringify(cart));

    alert("已加入購物車 (靜態儲存)");
});
/* ===================== 收藏功能 (靜態化版本) ===================== */
window.toggleFavorite = function (event, el) {
    if (event) { event.stopPropagation(); event.preventDefault(); }
    
    const id = el.closest(".product").dataset.id;
    let favorites = JSON.parse(localStorage.getItem("favorites")) || [];

    const index = favorites.indexOf(id);
    if (index === -1) {
        favorites.push(id);
        el.src = "images/love.png"; // 更新圖示
        toast("已加入收藏");
    } else {
        favorites.splice(index, 1);
        el.src = "images/heart.png";
        toast("已移除收藏");
    }
    localStorage.setItem("favorites", JSON.stringify(favorites));
};
});
// 在 script.js 或各頁面的 <script> 中
function initHeaderUI() {
    const searchIcon = document.getElementById("searchIcon");
    const menuIcon = document.getElementById("menuIcon");
    const searchBox = document.getElementById("searchBox");
    const menuBox = document.getElementById("menuBox");

    if (searchIcon && searchBox) {
        searchIcon.addEventListener("click", () => {
            searchBox.classList.toggle("active");
        });
    }
    if (menuIcon && menuBox) {
        menuIcon.addEventListener("click", () => {
            menuBox.classList.toggle("active");
        });
    }
}