document.addEventListener("DOMContentLoaded", () => {

// ===== 取得商品ID =====
const params = new URLSearchParams(window.location.search);
const productId = Number(params.get("id")) || 1;

// ===== 找商品 =====
const productData = products.find(
p => p.id === productId
);

if (!productData) {
alert("找不到商品");
return;
}

// ===== 商品容器 =====
const productEl =
document.querySelector(".product-container");

productEl.dataset.id = productData.id;
productEl.dataset.name = productData.name;
productEl.dataset.price = productData.price;
productEl.dataset.img = productData.images[0];

// ===== 顯示商品資訊 =====
document.getElementById("productName").innerText =
productData.name;

document.getElementById("productDesc").innerText =
productData.desc;

document.getElementById("productPrice").innerText =
`NT$ ${productData.price}`;

document.getElementById("detail").innerHTML =
productData.detail;

document.getElementById("mainImage").src =
productData.images[0];

document.getElementById("mainImage").alt =
productData.name;

// ===== 型號選單 =====
const sizeSelect =
document.getElementById("sizeSelect");

sizeSelect.innerHTML = `

  <optgroup label="Apple">

<option>iPhone 17 Pro Max</option>
<option>iPhone 17 Pro</option>
<option>iPhone 17 Air</option>
<option>iPhone 17</option>

<option>iPhone 16 Pro Max</option>
<option>iPhone 16 Pro</option>
<option>iPhone 16 Plus</option>
<option>iPhone 16</option>

<option>iPhone 15 Pro Max</option>
<option>iPhone 15 Pro</option>
<option>iPhone 15</option>

  </optgroup>

  <optgroup label="Samsung">

<option>Galaxy S25 Ultra</option>
<option>Galaxy S24 Ultra</option>
<option>Galaxy A56</option>

  </optgroup>
  `;

// ===== 加入購物車 =====
document
.getElementById("addCartBtn")
.addEventListener("click", () => {

```
  const quantity =
  parseInt(
  document.querySelector('input[type="number"]').value
  ) || 1;

  const model =
  sizeSelect.value;

  let cart =
  JSON.parse(
  localStorage.getItem("cart")
  ) || [];

  const exist =
  cart.find(item =>
    item.id === productData.id &&
    item.model === model
  );

  if(exist){

      exist.quantity += quantity;

  }else{

      cart.push({

          id: productData.id,
          name: productData.name,
          price: productData.price,
          img: productData.images[0],
          model: model,
          quantity: quantity
      });
  }

  localStorage.setItem(
    "cart",
    JSON.stringify(cart)
  );

  alert(
    productData.name +
    " 已加入購物車"
  );
```

});

// ===== Tab切換 =====
document
.querySelectorAll(".tab")
.forEach(tab => {

```
tab.addEventListener("click", () => {

  document
  .querySelectorAll(".tab")
  .forEach(t =>
  t.classList.remove("active"));

  document
  .querySelectorAll(".content")
  .forEach(c =>
  c.classList.remove("active"));

  tab.classList.add("active");

  document
  .getElementById(tab.dataset.tab)
  .classList.add("active");
});
```

});

// ===== 顧客評價 =====
const feedbackContainer =
document.getElementById("feedback-list");

const noFeedbacksText =
document.getElementById("no-feedbacks");

const submitFeedbackButton =
document.getElementById("submit-feedback");

let productFeedbacks =
JSON.parse(
localStorage.getItem(
`feedbacks_${productId}`
));

if (!productFeedbacks) {

```
productFeedbacks =
reviews[productId] || [];

localStorage.setItem(
  `feedbacks_${productId}`,
  JSON.stringify(productFeedbacks)
);
```

}

function renderFeedbacks() {

```
feedbackContainer.innerHTML = "";

if(productFeedbacks.length === 0){

  noFeedbacksText.style.display =
  "block";

}else{

  noFeedbacksText.style.display =
  "none";

  productFeedbacks.forEach(fb => {

    const div =
    document.createElement("div");

    div.className =
    "feedback-item";

    div.innerHTML = `
      <strong>${fb.name}</strong>
      - ${"★".repeat(fb.rating)}
      <p>${fb.text}</p>
    `;

    feedbackContainer.appendChild(div);

  });
}
```

}

renderFeedbacks();

submitFeedbackButton
.addEventListener("click", () => {

```
const name =
document.getElementById(
"feedback-name").value;

const rating =
parseInt(
document.getElementById(
"feedback-rating").value);

const text =
document.getElementById(
"feedback-text").value;

if(!name || !rating || !text){

  alert("請填寫所有欄位！");
  return;
}

productFeedbacks.push({
  name,
  rating,
  text
});

localStorage.setItem(
  `feedbacks_${productId}`,
  JSON.stringify(productFeedbacks)
);

document.getElementById(
"feedback-name").value = "";

document.getElementById(
"feedback-text").value = "";

renderFeedbacks();
```

});

// ===== 配送與付款 =====
document
.getElementById("shipping")
.innerHTML = ` <h3>配送方式</h3> <p>宅配</p> <p>7-ELEVEN 取貨</p> <p>全家取貨</p>

```
<h3>付款方式</h3>
<p>Apple Pay</p>
<p>LINE Pay</p>
<p>信用卡付款</p>
<p>銀行轉帳</p>
<p>超商取貨付款</p>
```

`;

});
