# Store Ease App

![store_ease_cover](https://github.com/YJZeng1120/store_ease_demo/assets/84773273/00a1d954-1b43-43c0-addb-dde43ce68962)
![store_ease](https://github.com/YJZeng1120/store_ease_demo/assets/84773273/56eed8fb-d2ea-425c-8dd0-9f5679a6f426)

---
## 目錄
- [作品介紹](#作品介紹)
- [負責項目](#負責項目)
- [Demo影片](#Demo影片)
- [使用工具](#使用工具)

## 作品介紹
我與另一名後端工程師合作並設計開發的一款餐廳點餐系統，分為**商店管理系統**（商店輕鬆理 Store Ease） 與**快速點餐系統**（餐點輕鬆訂 Order Ease）兩部份；而這個 Project 是提供給**商家端使用**的商店管理系統。
- 商店輕鬆理
    - 功能特色：
        - 帳戶管理： 以 E-Mail 註冊，並於後續更改使用者資訊或刪除用戶
        - 商店管理： 輕鬆管理多個商店資訊、菜單和座位配置。
        - 訂單管理： 生成 QRCode 提供給客戶，讓他們可以快速點餐，並實時接收訂單信息。
        - 即時通訊： 透過 FCM，在客戶點餐時即時接收訂單資訊，
        - 未來展望： 整合理財系統，進行營業額統計與視覺化呈現。
## 負責項目：
- 負責整個 **商店輕鬆理 Store Ease** App的前端開發
- App功能
    - 註冊驗證（包含E-Mail OTP驗證 跟 資料格式驗證）
    - 新增/讀取/編輯/刪除 用戶資訊（搭配 Firebase Auth）
    - 多國語系設置
    - 相機拍照、相簿選擇及圖片上傳功能
    - 新增/讀取/編輯/刪除 **商店**、**菜單**、**座位**資訊
    - 點餐座位自動產生QRCode供店家下載與顧客掃描點餐
    - 串接Firebase Cloud Messaging (FCM)，**即時接收訂單資訊**
    - 即時回傳**接受訂單**、**取消訂單**、**完成訂單**、**刪除訂單**等訂單狀態

### 開發時長：
- 前端系統從無到建立，包括規劃並和後端工程師密切溝通，開發總時長為 10 週。

在執行專案之前，先於 Flutter 的專案路徑 :file_folder: `store_ease_app`執行：
```
flutter gen-l10n
```
## Demo影片
[![store_ease_cover](https://github.com/YJZeng1120/store_ease_demo/assets/84773273/3679b25c-6bc0-4d08-9611-73015bc16547)](https://youtu.be/8_l8sXE4EpE)
## 使用工具
- **Frontend**
    - Flutter`v3.13.9`
        - Design pattern 
            - Model–view–controller(MVC)
        - Main Dependencies:
            - Bloc (State Management)
            - dio (Api Request)
            - dartz (Error handling)
        - All Dependencies:

          <img width="332" alt="Screenshot 2023-12-04 at 5 30 11 PM" src="https://github.com/YJZeng1120/store_ease_demo/assets/84773273/6a92db45-0234-46e6-8aeb-21630a7f719e">



- **Cloud Services**
    - Firebase Auth
    - Firebase Cloud Messaging (FCM)
- **Other Tools**
    - **Git** (Version control)
    - **Postman** (API tool)
    - **Trello** (Scrum pattern)

