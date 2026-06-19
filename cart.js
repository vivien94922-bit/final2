// --- 修改後的 cart.js ---

// 1. 取得購物車資料
function getCartFromStorage() {
    const data = localStorage.getItem("cart");
    console.log("從 localStorage 讀取到的資料:", data); // 測試用：在 Console 查看是否有資料
    return data ? JSON.parse(data) : [];
}
// 2. 儲存購物車資料
function saveCartToStorage(cart) {
    localStorage.setItem("cart", JSON.stringify(cart));
}

// 3. 修改後的 renderCart (直接從 localStorage 讀取)
function renderCart() {
    const container = document.getElementById("cart-container");
    const cart = getCartFromStorage(); // 確保這裡抓得到資料
    
    // 如果 cart 是空的，先清空容器
    container.innerHTML = "";

    if (cart && cart.length > 0) {
        cart.forEach(item => {
            const div = document.createElement("div");
            div.className = "cart-item";
            div.innerHTML = `
                <p>${item.name}</p>
                <p>數量: ${item.quantity}</p>
                <p>單價: ${item.price}</p>
            `;
            container.appendChild(div);
        });
        // 記得計算總金額
        updateTotalFromStorage(cart);
    } else {
        container.innerHTML = "<p>購物車空空如也...</p>";
    }
}

// 4. 修改後的更新數量功能 (取代 sendUpdate)
function updateCartQty(cartId, newQty) {
    let cart = getCartFromStorage();
    if (newQty <= 0) {
        cart = cart.filter(item => item.id !== cartId);
    } else {
        const item = cart.find(i => i.id === cartId);
        if (item) item.quantity = newQty;
    }
    saveCartToStorage(cart);
    renderCart(); // 重新渲染畫面
}