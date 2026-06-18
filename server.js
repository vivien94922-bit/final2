// 必須要有這幾行，而且順序很重要！
const express = require('express'); // <-- 關鍵就是這行，你可能漏掉了
const cors = require('cors');
const db = require('./db'); // 確保也有引入你的資料庫設定
const crypto = require('crypto');

const app = express(); // 現在這裡才能運作

app.use(cors());
app.use(express.json());
app.post('/login', async (req, res) => {
    const { username, password } = req.body;

    // 1. 先用同樣的演算法把使用者輸入的密碼轉成雜湊值
    const hash = crypto.createHash('sha256').update(password).digest('hex');

    try {
        // 2. 用雜湊後的值去查詢資料庫
        const [rows] = await db.query(
            'SELECT * FROM members WHERE username = ? AND password = ?', 
            [username, hash] // 比對雜湊值
        );

        if (rows.length > 0) {
            res.json({ success: true, message: "登入成功！" });
        } else {
            res.json({ success: false, message: "帳號或密碼錯誤" });
        }
    } catch (err) {
        res.status(500).json({ success: false, message: "伺服器錯誤" });
    }
});
// 註冊功能
app.post('/register', async (req, res) => {
    const { username, password, name, email, phone } = req.body;

    // 1. 將新密碼進行雜湊處理
    const hash = crypto.createHash('sha256').update(password).digest('hex');

    try {
        // 2. 執行 INSERT 將資料存入資料庫
        // 注意：這裡假設你的資料庫表欄位是 username, password, salt
        // 如果你的資料庫不需要 salt 或有其他預設值，請依照實際狀況調整
        await db.query(
            'INSERT INTO members (username, password, name, email, phone, salt) VALUES (?, ?, ?, ?, ?, ?)',
            [username, hash, name, email, phone, 'default_salt']
        );

        res.json({ success: true, message: "註冊成功，請前往登入！" });
    } catch (err) {
        console.error(err);
        res.json({ success: false, message: "註冊失敗，帳號可能已存在" });
    }
});