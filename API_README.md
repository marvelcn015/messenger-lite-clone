# Messenger Lite Clone API 文件

## 📋 總覽

本專案已根據 BDD 功能規格完成 API 端點設計，並提供完整的 Swagger API 文件。所有 API 端點都以繁體中文撰寫，完全對應 `features/` 目錄中的 BDD 功能場景。

## 🚀 快速開始

### 查看 API 文件

1. **啟動文件伺服器**:
   ```bash
   npm run docs
   ```

2. **開啟瀏覽器訪問**:
   - Swagger UI: http://localhost:3001/api-docs
   - 健康檢查: http://localhost:3001/health

### 文件檔案位置

- **Swagger 規格**: `swagger.yaml` - 完整的 OpenAPI 3.0.3 規格
- **API 設計文件**: `API_DESIGN.md` - 詳細的設計說明
- **文件伺服器**: `docs/serve-docs.js` - 本地文件瀏覽工具

## 📚 API 模組概覽

### 🔐 使用者管理
- 註冊、登入、登出
- 電子郵件/手機驗證
- 個人資料管理
- 大頭照上傳

### 👥 好友管理
- 多方式搜尋使用者
- 好友邀請系統
- 好友分組管理
- QR Code 快速加友

### 💬 即時訊息
- 文字、圖片、檔案、語音訊息
- 訊息狀態追蹤
- 編輯/刪除功能
- 對話歷史管理

### 👨‍👩‍👧‍👦 群組聊天
- 群組建立與管理
- 成員權限控制
- @提及與回覆功能
- 群組通知設定

### 🔔 通知系統
- 推播通知管理
- 勿打擾模式
- 重要聯絡人設定
- 通知歷史記錄

### 🔒 線上狀態與隱私
- 多種線上狀態
- 隱私設定控制
- 讀取回條管理
- 最後上線時間

### 📎 檔案上傳
- 圖片自動壓縮
- 多格式檔案支援
- 語音訊息處理
- 安全檢查機制

## 🎯 功能對應

每個 API 端點都直接對應到 BDD 功能規格：

| Feature File | API 模組 | 主要端點 |
|-------------|---------|----------|
| `user-management.feature` | 使用者管理 | `/auth/*`, `/profile` |
| `friend-management.feature` | 好友管理 | `/friends/*` |
| `instant-messaging.feature` | 即時訊息 | `/conversations/*`, `/messages/*` |
| `group-chat.feature` | 群組聊天 | `/groups/*` |
| `notification-system.feature` | 通知系統 | `/notifications/*` |
| `online-status-privacy.feature` | 狀態與隱私 | `/status`, `/privacy` |

## 🛠 技術規格

- **API 標準**: REST API 基於 HTTP/HTTPS
- **認證方式**: JWT Bearer Token
- **資料格式**: JSON
- **文件標準**: OpenAPI 3.0.3
- **多環境支援**: 開發/測試/正式環境
- **國際化**: 完整繁體中文支援

## 🔍 API 使用範例

### 使用者註冊
```bash
curl -X POST https://api.messenger-lite.com/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "email": "john@example.com", 
    "password": "SecurePass123",
    "phoneNumber": "+1234567890"
  }'
```

### 發送訊息
```bash
curl -X POST https://api.messenger-lite.com/v1/conversations/conv_123/messages \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "text",
    "content": "Hello World!"
  }'
```

### 建立群組
```bash
curl -X POST https://api.messenger-lite.com/v1/groups \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "專案討論群",
    "description": "我們的專案團隊",
    "memberIds": ["user_123", "user_456"]
  }'
```

## 🎨 Swagger UI 功能

在 Swagger UI 中可以：

1. **瀏覽所有端點** - 按模組分類檢視
2. **查看請求格式** - 完整的參數說明
3. **測試 API** - 直接在介面中測試請求
4. **下載規格** - 匯出 OpenAPI 規格檔案
5. **查看回應範例** - 完整的回應資料結構

## 📋 開發檢查清單

### ✅ 已完成
- [x] 分析所有 BDD 功能規格
- [x] 設計完整 API 端點結構
- [x] 撰寫繁體中文 Swagger 文件
- [x] 建立本地文件瀏覽器
- [x] 提供 API 使用範例
- [x] 整理技術規格說明

### 🔄 下一步實作建議
1. **API 伺服器實作** - 根據 Swagger 規格實作端點
2. **資料庫設計** - 設計對應的資料庫結構
3. **認證系統** - 實作 JWT Token 認證機制
4. **檔案上傳** - 實作檔案處理與儲存
5. **即時功能** - 整合 WebSocket 即時通訊
6. **推播通知** - 整合 Firebase/APNs 服務
7. **BDD 測試** - 實作自動化測試驗證

## 📖 相關文件

- `swagger.yaml` - 完整 API 規格
- `API_DESIGN.md` - 詳細設計文件
- `features/` - BDD 功能規格
- `docs/serve-docs.js` - 文件伺服器

## 🤝 協作指南

1. **API 變更** - 修改 `swagger.yaml` 並更新版本號
2. **新增功能** - 先更新 BDD 功能規格，再設計對應 API
3. **文件同步** - 確保 Swagger 文件與實作保持同步
4. **測試驗證** - 每個端點都應有對應的 BDD 測試場景

---

📝 **備註**: 此 API 設計文件基於 BDD 功能驅動開發方法論，確保每個端點都對應到實際的使用者需求場景。