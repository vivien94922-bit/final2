document.addEventListener("DOMContentLoaded", async () => {
    await initPage();
    initBanner();
    initSearch();
    initBackToTop();
    initCartAndFavorites();
});

async function initPage() {
    try {
        const headerRes = await fetch('header.html');
        const headerText = await headerRes.text();
        const headerContainer = document.getElementById('header-placeholder');
        if (headerContainer) {
            headerContainer.innerHTML = headerText;
            initHeaderUI();
            checkLoginStatus();
        }

        const footerRes = await fetch('footer.html');
        const footerText = await footerRes.text();
        const footerContainer = document.getElementById('footer-placeholder');
        if (footerContainer) footerContainer.innerHTML = footerText;
    } catch (err) {
        console.error("載入失敗:", err);
    }
}

function initHeaderUI() {
    const sIcon = document.getElementById("searchIcon");
    const sBox = document.getElementById("searchBox");
    const mIcon = document.getElementById("menuIcon");
    const mBox = document.getElementById("menuBox");

    if (sIcon && sBox) sIcon.addEventListener("click", () => sBox.classList.toggle("active"));
    if (mIcon && mBox) mIcon.addEventListener("click", () => mBox.classList.toggle("active"));
}

function checkLoginStatus() {
    const userArea = document.getElementById("user-area");
    if (!userArea) return;
    const isLogin = localStorage.getItem("isLoggedIn");
    userArea.innerHTML = (isLogin === "true") 
        ? `<a href="member.html">會員中心</a> <a href="logout.html" onclick="localStorage.removeItem('isLoggedIn')">登出</a>`
        : `<a href="login.html"><img src="images/user.png"></a>`;
}

function initSearch() {
    const input = document.getElementById("searchInput");
    const result = document.getElementById("searchResult");
    if (!input) return;
    let timer;
    input.addEventListener("input", () => {
        const val = input.value.trim();
        clearTimeout(timer);
        if (val.length === 0) { result.innerHTML = ""; return; }
        timer = setTimeout(() => {
            fetch("search.jsp?keyword=" + encodeURIComponent(val))
                .then(res => res.text())
                .then(data => result.innerHTML = data);
        }, 200);
    });
}

function initBanner() {
    let cur = 0;
    const imgs = ["images/banner1.png","images/banner2.png","images/banner3.png"];
    const titles = ["NEW ARRIVAL", "WANDERLUST", "BUSINESS CLASS"];
    const descs = ["年度新品・限時 8 折起", "尋找你的完美旅行隊友", "專屬商務菁英的頂級移動美學"];
    const ids = [4, 14, 3];

    function render() {
        const img = document.getElementById("bannerImage");
        const t = document.getElementById("bannerTitle");
        const d = document.getElementById("bannerDesc");
        const btn = document.getElementById("bannerBuyNowBtn");
        const dots = document.getElementById("dotsContainer");
        if (!img || !t || !d || !btn || !dots) return;

        img.src = imgs[cur];
        t.innerText = titles[cur];
        d.innerText = descs[cur];
        btn.onclick = () => location.href = `product.html?id=${ids[cur]}`;

        dots.innerHTML = "";
        imgs.forEach((_, i) => {
            const dot = document.createElement("span");
            dot.className = i === cur ? "dot active" : "dot";
            dot.onclick = () => { cur = i; render(); };
            dots.appendChild(dot);
        });
    }

    setInterval(() => { cur = (cur + 1) % imgs.length; render(); }, 5000);
    document.querySelector(".next")?.addEventListener("click", () => { cur = (cur + 1) % imgs.length; render(); });
    document.querySelector(".prev")?.addEventListener("click", () => { cur = (cur - 1 + imgs.length) % imgs.length; render(); });
    render();
}

function initBackToTop() {
    const btn = document.getElementById("backToTop");
    if (!btn) return;
    window.addEventListener("scroll", () => btn.style.display = window.scrollY > 300 ? "block" : "none");
    btn.addEventListener("click", () => window.scrollTo({ top: 0, behavior: "smooth" }));
}

function initCartAndFavorites() {
    // 只保留收藏功能的邏輯
    window.toggleFavorite = (e, el) => {
        e.stopPropagation(); e.preventDefault();
        const id = el.closest(".product").dataset.id;
        let favs = JSON.parse(localStorage.getItem("favorites")) || [];
        const idx = favs.indexOf(id);
        if (idx === -1) {
            favs.push(id);
            el.src = "images/love.png";
            toast("已加入收藏");
        } else {
            favs.splice(idx, 1);
            el.src = "images/heart.png";
            toast("已移除收藏");
        }
        localStorage.setItem("favorites", JSON.stringify(favs));
    };
}

function toast(msg) {
    const t = document.createElement("div");
    t.className = "toast";
    t.innerText = msg;
    document.body.appendChild(t);
    setTimeout(() => t.classList.add("show"), 10);
    setTimeout(() => t.remove(), 2000);
}
// 使用事件代理，監聽整個網頁的點擊事件
document.addEventListener("click", (e) => {
    if (e.target.classList.contains("add-cart-btn")) {
        const productElement = e.target.closest(".product");
        const productId = productElement.dataset.id;
        
        // 從 DOM 取得文字時，記得要把 <br> 換成空格或處理一下，避免格式跑掉
        const productName = productElement.querySelector(".product-name").innerText.replace(/\n/g, " ");
        const productPrice = productElement.querySelector(".product-price").textContent;
        
        let cart = JSON.parse(localStorage.getItem("cart")) || [];
        
        const existingItem = cart.find(item => item.id === productId);
        if (existingItem) {
            existingItem.quantity += 1;
        } else {
            cart.push({ 
                id: productId, 
                name: productName, 
                price: productPrice, 
                quantity: 1 
            });
        }
        
        localStorage.setItem("cart", JSON.stringify(cart));
        toast("已加入購物車"); // 記得加上這一行，不然使用者不知道按了沒
    }
});
