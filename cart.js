// --- 修改後的 cart.js ---

// 1. 取得購物車資料
function getCartFromStorage() {
    return JSON.parse(localStorage.getItem("cart")) || [];
}

// 2. 儲存購物車資料
function saveCartToStorage(cart) {
    localStorage.setItem("cart", JSON.stringify(cart));
}

// 3. 修改後的 renderCart (直接從 localStorage 讀取)
function renderCart() {
    const container = document.getElementById("cart-container");
    const cart = getCartFromStorage();
    
    container.replaceChildren();

    if (cart.length > 0) {
        cart.forEach(item => {
            // ... 這裡保留你原本用 document.createElement 產生 HTML 的邏輯 ...
            // 記得在按鈕綁定事件時，呼叫下方的 updateCartQty
        });
        updateTotalFromStorage(cart);
    } else {
        container.innerHTML = "<p>購物車空空如也...</p>";
        updateTotalFromStorage([]);
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