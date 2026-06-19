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

    const container =
    document.getElementById("cart-container");

    const cart =
    getCartFromStorage();

    container.innerHTML = "";

    if (!cart.length) {

        container.innerHTML =
        "<p>購物車空空如也...</p>";

        document.getElementById("cart-total")
        .innerText = "NT$0";

        return;
    }

    cart.forEach(item => {

        const div =
        document.createElement("div");

        div.className = "cart-item";

        div.innerHTML = `
            <img src="${item.image}"
                 width="120">

            <h3>${item.name}</h3>

            <p>NT$${item.price}</p>

            <p>
                數量：

                <button onclick="
                    updateCartQty(
                        ${item.id},
                        ${item.quantity - 1}
                    )
                ">－</button>

                ${item.quantity}

                <button onclick="
                    updateCartQty(
                        ${item.id},
                        ${item.quantity + 1}
                    )
                ">＋</button>
            </p>
        `;

        container.appendChild(div);

    });

    updateTotalFromStorage(cart);

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

function updateTotalFromStorage(cart) {

    let total = 0;

    cart.forEach(item => {
        total += item.price * item.quantity;
    });

    const totalElement =
    document.getElementById("cart-total");

    if (totalElement) {
        totalElement.innerText =
        "NT$" + total.toLocaleString();
    }

}
