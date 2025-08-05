# Messenger Lite Clone API 設計文件

## 概述

基於 BDD 功能規格設計的即時通訊應用程式 RESTful API，支援使用者管理、好友系統、即時訊息、群組聊天、通知系統與隱私控制等完整功能。

## API 模組架構

### 1. 使用者管理 (User Management)
- **註冊/登入/登出**: 完整的身份驗證流程
- **電子郵件/手機驗證**: 雙重驗證機制
- **個人資料管理**: 頭像上傳、資料編輯
- **JWT Token 認證**: 安全的 API 存取控制

**核心端點**:
```
POST /auth/register      - 使用者註冊
POST /auth/login         - 使用者登入
POST /auth/logout        - 使用者登出
POST /auth/verify/email  - 電子郵件驗證
POST /auth/verify/phone  - 手機號碼驗證
GET  /profile           - 取得個人資料
PUT  /profile           - 更新個人資料
POST /profile/avatar    - 上傳大頭照
```

### 2. 好友管理 (Friend Management)
- **多元搜尋**: 支援電子郵件、手機、使用者名稱搜尋
- **好友邀請系統**: 發送、接受、拒絕、撤回邀請
- **好友分組**: 組織好友列表
- **QR Code 新增**: 快速新增好友功能

**核心端點**:
```
GET    /friends/search                    - 搜尋使用者
GET    /friends/requests                  - 取得好友邀請
POST   /friends/requests                  - 發送好友邀請
POST   /friends/requests/{id}/accept      - 接受邀請
POST   /friends/requests/{id}/reject      - 拒絕邀請
DELETE /friends/requests/{id}/withdraw    - 撤回邀請
GET    /friends                          - 好友列表
DELETE /friends/{id}                     - 刪除好友
GET    /friends/groups                   - 好友分組
POST   /friends/groups                   - 建立分組
GET    /friends/qr-code                  - 生成 QR Code
```

### 3. 即時訊息 (Instant Messaging)
- **多媒體訊息**: 文字、圖片、檔案、語音訊息
- **訊息狀態追蹤**: 傳送中、已送達、已讀狀態
- **訊息編輯/刪除**: 5分鐘內可編輯
- **對話管理**: 搜尋、分頁載入歷史訊息

**核心端點**:
```
GET    /conversations                       - 對話列表
GET    /conversations/{id}/messages         - 取得訊息
POST   /conversations/{id}/messages         - 發送訊息
PUT    /messages/{id}                      - 編輯訊息
DELETE /messages/{id}                      - 刪除訊息
POST   /messages/{id}/read                 - 標記已讀
```

### 4. 群組聊天 (Group Chat)
- **群組管理**: 建立、刪除、設定群組
- **成員管理**: 新增、移除、提升管理員
- **群組訊息**: @提及、回覆功能
- **權限控制**: 管理員與一般成員權限區分

**核心端點**:
```
GET    /groups                           - 群組列表
POST   /groups                           - 建立群組
GET    /groups/{id}                      - 群組資訊
PUT    /groups/{id}                      - 更新群組
DELETE /groups/{id}                      - 刪除群組
GET    /groups/{id}/members              - 成員列表
POST   /groups/{id}/members              - 新增成員
DELETE /groups/{id}/members/{memberId}   - 移除成員
POST   /groups/{id}/members/{memberId}/promote - 提升管理員
POST   /groups/{id}/leave                - 離開群組
GET    /groups/{id}/messages             - 群組訊息
POST   /groups/{id}/messages             - 發送群組訊息
```

### 5. 通知系統 (Notification System)
- **推播通知**: 跨平台推播支援
- **通知設定**: 聲音、震動、勿打擾模式
- **重要聯絡人**: 特殊通知處理
- **通知歷史**: 通知記錄管理

**核心端點**:
```
GET  /notifications                    - 通知列表
POST /notifications/{id}/read          - 標記已讀
POST /notifications/read-all           - 全部標記已讀
GET  /notifications/settings           - 通知設定
PUT  /notifications/settings           - 更新設定
```

### 6. 線上狀態與隱私 (Online Status & Privacy)
- **狀態管理**: 線上、忙碌、離開、隱形、離線
- **隱私控制**: 搜尋、訊息、狀態可見度設定
- **讀取回條**: 可控制的訊息已讀顯示
- **最後上線時間**: 隱私保護選項

**核心端點**:
```
GET /status    - 取得線上狀態
PUT /status    - 更新狀態
GET /privacy   - 隱私設定
PUT /privacy   - 更新隱私設定
```

### 7. 檔案上傳 (File Upload)
- **圖片上傳**: 自動壓縮、縮圖生成
- **檔案上傳**: 多格式支援
- **語音訊息**: 60秒限制
- **安全檢查**: 檔案類型與大小限制

**核心端點**:
```
POST /upload/image   - 上傳圖片
POST /upload/file    - 上傳檔案
POST /upload/voice   - 上傳語音
```

## 技術特點

### 認證與安全
- **JWT Token**: 無狀態認證機制
- **Bearer Authentication**: 標準化 API 認證
- **密碼安全**: 8字元以上英數字組合要求
- **雙重驗證**: 電子郵件與手機號碼驗證

### 資料驗證
- **OpenAPI 3.0.3**: 完整的 API 規格定義
- **輸入驗證**: 所有端點都有詳細的資料驗證規則
- **錯誤處理**: 統一的錯誤回應格式
- **國際化**: 繁體中文錯誤訊息與文件

### 效能考量
- **分頁載入**: 大型資料集的分頁處理
- **檔案壓縮**: 自動圖片壓縮節省頻寬
- **狀態管理**: 即時狀態同步機制
- **快取策略**: 減少不必要的 API 調用

### 擴展性設計
- **模組化架構**: 清晰的功能模組劃分
- **RESTful 設計**: 標準化的 API 設計模式
- **版本控制**: URL 版本控制 (/v1/)
- **多環境支援**: 開發、測試、正式環境設定

## BDD 功能對應

每個 API 端點都直接對應到 BDD 功能規格中的具體場景：

- **使用者註冊**: 對應 user-management.feature 中的註冊場景
- **好友搜尋**: 對應 friend-management.feature 中的搜尋場景
- **訊息傳送**: 對應 instant-messaging.feature 中的訊息場景
- **群組管理**: 對應 group-chat.feature 中的群組場景
- **通知系統**: 對應 notification-system.feature 中的通知場景
- **隱私控制**: 對應 online-status-privacy.feature 中的隱私場景

## API 使用範例

### 使用者註冊
```bash
curl -X POST https://api.messenger-lite.com/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com",
    "password": "SecurePass123",
    "phoneNumber": "+1234567890",
    "acceptTerms": true
  }'
```

### 發送訊息
```bash
curl -X POST https://api.messenger-lite.com/v1/conversations/conv_123/messages \
  -H "Authorization: Bearer your_jwt_token" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "text",
    "content": "Hello Jane!"
  }'
```

### 建立群組
```bash
curl -X POST https://api.messenger-lite.com/v1/groups \
  -H "Authorization: Bearer your_jwt_token" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Team Discussion",
    "description": "Our project team",
    "memberIds": ["user_67890", "user_11111"]
  }'
```

## 下一步實作建議

1. **實作優先順序**: 使用者管理 → 好友管理 → 即時訊息 → 群組聊天 → 通知系統 → 隱私控制
2. **測試驗證**: 每個模組都應對應 BDD 測試場景進行驗證
3. **即時功能**: WebSocket 連接用於即時訊息傳送
4. **推播通知**: 整合 Firebase/APNs 推播服務
5. **資料庫設計**: 對應 API 需求設計資料庫結構