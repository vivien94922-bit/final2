let cart =
JSON.parse(localStorage.getItem("cart")) || [];

const cartItems =
document.getElementById("cartItems");

function renderCart(){

    if(cart.length===0){

        cartItems.innerHTML=
        "<div class='empty'>購物車目前沒有商品</div>";

        document.getElementById("totalPrice")
        .innerText="NT$0";

        return;
    }

    let html="";
    let total=0;

    cart.forEach((item,index)=>{

        let subtotal =
        item.price * item.quantity;

        total += subtotal;

        html += `

        <div class="cart-item">

            <img src="${item.img}">

            <div class="info">

                <h3>${item.name}</h3>

                <div class="price">
                    NT$${item.price}
                </div>

            </div>

            <div class="quantity">

                <button onclick="decrease(${index})">-</button>

                <span>${item.quantity}</span>

                <button onclick="increase(${index})">+</button>

            </div>

            <div class="subtotal">
                NT$${subtotal}
            </div>

            <button
            class="delete-btn"
            onclick="removeItem(${index})">

                🗑️

            </button>

        </div>

        `;
    });

    cartItems.innerHTML = html;

    document.getElementById("totalPrice")
    .innerText = "NT$" + total;
}

function increase(index){

    cart[index].quantity++;

    saveCart();
}

function decrease(index){

    if(cart[index].quantity>1){

        cart[index].quantity--;

        saveCart();
    }
}

function removeItem(index){

    cart.splice(index,1);

    saveCart();
}

function saveCart(){

    localStorage.setItem(
        "cart",
        JSON.stringify(cart)
    );

    renderCart();
}

renderCart();
  
