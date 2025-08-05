# Messenger Lite Clone 系統架構設計

## 🏗️ 系統整體架構

```mermaid
graph TB
    subgraph "客戶端層 Client Layer"
        MA[移動應用程式<br/>Mobile App<br/>React Native/Flutter]
        WA[網頁應用程式<br/>Web App<br/>React/Vue.js]
        DA[桌面應用程式<br/>Desktop App<br/>Electron]
    end

    subgraph "負載均衡與閘道層 Gateway Layer"
        LB[負載均衡器<br/>Load Balancer<br/>Nginx/HAProxy]
        AG[API 閘道<br/>API Gateway<br/>Express Gateway]
    end

    subgraph "應用服務層 Application Layer"
        subgraph "API 服務集群 API Services Cluster"
            API1[API Server 1<br/>Express.js + TypeScript]
            API2[API Server 2<br/>Express.js + TypeScript]
            API3[API Server N<br/>Express.js + TypeScript]
        end
        
        subgraph "即時通訊服務 Real-time Services"
            WS1[WebSocket Server 1<br/>Socket.io]
            WS2[WebSocket Server 2<br/>Socket.io]
        end
        
        subgraph "背景服務 Background Services"
            NS[通知服務<br/>Notification Service]
            FS[檔案處理服務<br/>File Processing Service]
            ES[電子郵件服務<br/>Email Service]
            SMS[簡訊服務<br/>SMS Service]
        end
    end

    subgraph "資料層 Data Layer"
        subgraph "主要資料庫 Primary Database"
            PDB[(PostgreSQL<br/>用戶、好友、群組)]
        end
        
        subgraph "訊息資料庫 Message Database"
            MDB[(MongoDB<br/>訊息、對話記錄)]
        end
        
        subgraph "快取層 Cache Layer"
            REDIS[(Redis<br/>會話、狀態、快取)]
        end
    end

    subgraph "外部服務層 External Services"
        subgraph "檔案儲存 File Storage"
            CDN[CDN<br/>CloudFlare/AWS CloudFront]
            S3[對象儲存<br/>AWS S3/MinIO]
        end
        
        subgraph "推播服務 Push Services"
            FCM[Firebase Cloud Messaging<br/>Android 推播]
            APNS[Apple Push Notification Service<br/>iOS 推播]
        end
        
        subgraph "第三方整合 Third-party Integration"
            TWILIO[Twilio<br/>簡訊驗證]
            SMTP[SMTP 服務<br/>電子郵件寄送]
        end
    end

    subgraph "監控與日誌層 Monitoring Layer"
        LOG[日誌系統<br/>ELK Stack]
        MON[監控系統<br/>Prometheus + Grafana]
        APM[應用效能監控<br/>New Relic/DataDog]
    end

    %% 客戶端連接
    MA --> LB
    WA --> LB
    DA --> LB

    %% 負載均衡
    LB --> AG
    AG --> API1
    AG --> API2
    AG --> API3
    AG --> WS1
    AG --> WS2

    %% API 服務連接資料庫
    API1 --> PDB
    API1 --> MDB
    API1 --> REDIS
    API2 --> PDB
    API2 --> MDB
    API2 --> REDIS
    API3 --> PDB
    API3 --> MDB
    API3 --> REDIS

    %% WebSocket 連接
    WS1 --> REDIS
    WS2 --> REDIS

    %% 背景服務
    API1 --> NS
    API2 --> NS
    API3 --> NS
    NS --> FCM
    NS --> APNS
    
    API1 --> FS
    FS --> S3
    S3 --> CDN

    API1 --> ES
    ES --> SMTP
    
    API1 --> SMS
    SMS --> TWILIO

    %% 監控連接
    API1 --> LOG
    API2 --> LOG
    API3 --> LOG
    WS1 --> LOG
    WS2 --> LOG
    
    API1 --> MON
    API2 --> MON
    API3 --> MON
    PDB --> MON
    MDB --> MON
    REDIS --> MON

    %% 樣式定義
    classDef clientClass fill:#e1f5fe,stroke:#0277bd,stroke-width:2px
    classDef gatewayClass fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef apiClass fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef dataClass fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    classDef externalClass fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    classDef monitorClass fill:#f1f8e9,stroke:#558b2f,stroke-width:2px

    class MA,WA,DA clientClass
    class LB,AG gatewayClass
    class API1,API2,API3,WS1,WS2,NS,FS,ES,SMS apiClass
    class PDB,MDB,REDIS dataClass
    class CDN,S3,FCM,APNS,TWILIO,SMTP externalClass
    class LOG,MON,APM monitorClass
```

## 🗃️ 資料庫架構設計

```mermaid
erDiagram
    USERS {
        uuid id PK
        string username UK
        string email UK
        string phone_number UK
        string password_hash
        string display_name
        string avatar_url
        string status_message
        enum status
        jsonb privacy_settings
        boolean is_verified
        boolean is_active
        timestamp created_at
        timestamp updated_at
        timestamp last_seen_at
    }

    FRIENDSHIPS {
        uuid id PK
        uuid user_id FK
        uuid friend_id FK
        enum status
        timestamp created_at
        timestamp updated_at
    }

    FRIEND_REQUESTS {
        uuid id PK
        uuid from_user_id FK
        uuid to_user_id FK
        string message
        enum status
        timestamp created_at
        timestamp expires_at
    }

    FRIEND_GROUPS {
        uuid id PK
        uuid user_id FK
        string name
        timestamp created_at
        timestamp updated_at
    }

    FRIEND_GROUP_MEMBERS {
        uuid friend_group_id FK
        uuid friend_id FK
        timestamp added_at
    }

    GROUPS {
        uuid id PK
        string name
        string description
        string avatar_url
        uuid created_by FK
        boolean is_private
        integer max_members
        timestamp created_at
        timestamp updated_at
    }

    GROUP_MEMBERS {
        uuid id PK
        uuid group_id FK
        uuid user_id FK
        enum role
        timestamp joined_at
    }

    CONVERSATIONS {
        uuid id PK
        enum type
        string name
        uuid group_id FK
        timestamp created_at
        timestamp updated_at
        timestamp last_message_at
    }

    CONVERSATION_PARTICIPANTS {
        uuid conversation_id FK
        uuid user_id FK
        timestamp joined_at
        timestamp last_read_at
    }

    MESSAGES {
        uuid id PK
        uuid conversation_id FK
        uuid sender_id FK
        enum type
        text content
        jsonb metadata
        uuid reply_to_id FK
        string[] mentions
        boolean is_edited
        boolean is_deleted
        enum status
        timestamp created_at
        timestamp updated_at
    }

    MESSAGE_STATUS {
        uuid id PK
        uuid message_id FK
        uuid user_id FK
        enum status
        timestamp created_at
    }

    NOTIFICATIONS {
        uuid id PK
        uuid user_id FK
        enum type
        string title
        string body
        jsonb data
        boolean is_read
        timestamp created_at
    }

    NOTIFICATION_SETTINGS {
        uuid id PK
        uuid user_id FK
        boolean push_enabled
        boolean sound_enabled
        boolean vibration_enabled
        jsonb do_not_disturb
        uuid[] important_contacts
        jsonb contact_settings
        timestamp updated_at
    }

    DEVICE_TOKENS {
        uuid id PK
        uuid user_id FK
        string device_token
        enum device_type
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }

    FILE_UPLOADS {
        uuid id PK
        uuid uploaded_by FK
        string original_name
        string file_name
        string file_path
        string mime_type
        integer file_size
        jsonb metadata
        timestamp created_at
    }

    %% 關聯定義
    USERS ||--o{ FRIENDSHIPS : "user_id"
    USERS ||--o{ FRIENDSHIPS : "friend_id"
    USERS ||--o{ FRIEND_REQUESTS : "from_user_id"
    USERS ||--o{ FRIEND_REQUESTS : "to_user_id"
    USERS ||--o{ FRIEND_GROUPS : "user_id"
    FRIEND_GROUPS ||--o{ FRIEND_GROUP_MEMBERS : "friend_group_id"
    USERS ||--o{ FRIEND_GROUP_MEMBERS : "friend_id"
    
    USERS ||--o{ GROUPS : "created_by"
    GROUPS ||--o{ GROUP_MEMBERS : "group_id"
    USERS ||--o{ GROUP_MEMBERS : "user_id"
    
    GROUPS ||--o{ CONVERSATIONS : "group_id"
    CONVERSATIONS ||--o{ CONVERSATION_PARTICIPANTS : "conversation_id"
    USERS ||--o{ CONVERSATION_PARTICIPANTS : "user_id"
    
    CONVERSATIONS ||--o{ MESSAGES : "conversation_id"
    USERS ||--o{ MESSAGES : "sender_id"
    MESSAGES ||--o{ MESSAGES : "reply_to_id"
    MESSAGES ||--o{ MESSAGE_STATUS : "message_id"
    USERS ||--o{ MESSAGE_STATUS : "user_id"
    
    USERS ||--o{ NOTIFICATIONS : "user_id"
    USERS ||--o{ NOTIFICATION_SETTINGS : "user_id"
    USERS ||--o{ DEVICE_TOKENS : "user_id"
    USERS ||--o{ FILE_UPLOADS : "uploaded_by"
```

## 🔄 API 流程圖

### 使用者註冊流程
```mermaid
sequenceDiagram
    participant C as 客戶端
    participant API as API Server
    participant DB as Database
    participant Email as Email Service
    participant SMS as SMS Service

    C->>API: POST /auth/register
    API->>API: 驗證請求參數
    API->>DB: 檢查電子郵件/手機是否已存在
    
    alt 已存在
        DB-->>API: 用戶已存在
        API-->>C: 409 Conflict
    else 不存在
        DB-->>API: 可以註冊
        API->>DB: 創建新用戶(未驗證狀態)
        DB-->>API: 用戶創建成功
        
        par 電子郵件驗證
            API->>Email: 發送驗證郵件
            Email-->>API: 發送成功
        and 手機驗證
            API->>SMS: 發送驗證簡訊
            SMS-->>API: 發送成功
        end
        
        API-->>C: 201 Created (需要驗證)
    end
```

### 即時訊息傳送流程
```mermaid
sequenceDiagram
    participant C1 as 發送者客戶端
    participant WS as WebSocket Server
    participant API as API Server  
    participant DB as Message DB
    participant Cache as Redis
    participant C2 as 接收者客戶端
    participant Push as Push Service

    C1->>WS: 發送訊息 via WebSocket
    WS->>API: 驗證訊息並處理
    API->>DB: 儲存訊息
    DB-->>API: 儲存成功
    
    par 即時推送
        API->>Cache: 更新對話狀態
        Cache-->>API: 更新成功
        API->>WS: 廣播訊息
        WS->>C2: 推送訊息(如果在線)
        WS->>C1: 確認訊息已發送
    and 離線推送
        alt 接收者離線
            API->>Push: 發送推播通知
            Push->>C2: 推播通知
        end
    end
```

### 群組管理流程
```mermaid
sequenceDiagram
    participant Admin as 管理員
    participant API as API Server
    participant DB as Database
    participant WS as WebSocket Server
    participant Members as 群組成員

    Admin->>API: POST /groups (創建群組)
    API->>API: 驗證管理員權限
    API->>DB: 創建群組記錄
    DB-->>API: 群組創建成功
    
    API->>DB: 添加群組成員
    DB-->>API: 成員添加成功
    
    API->>WS: 通知所有成員
    WS->>Members: 群組創建通知
    
    API-->>Admin: 201 Created (群組資訊)
```

## 🚀 部署架構

```mermaid
graph TB
    subgraph "生產環境 Production Environment"
        subgraph "DMZ 區域"
            ELB[Elastic Load Balancer<br/>負載均衡器]
            WAF[Web Application Firewall<br/>網路應用程式防火牆]
        end
        
        subgraph "應用層 Application Tier"
            subgraph "可用區域 A"
                API1[API Server Pod 1]
                WS1[WebSocket Pod 1]
            end
            
            subgraph "可用區域 B"  
                API2[API Server Pod 2]
                WS2[WebSocket Pod 2]
            end
            
            subgraph "可用區域 C"
                API3[API Server Pod 3]
                WS3[WebSocket Pod 3]
            end
        end
        
        subgraph "資料層 Data Tier"
            subgraph "主資料庫叢集"
                PG_PRIMARY[(PostgreSQL Primary)]
                PG_REPLICA1[(PostgreSQL Replica 1)]
                PG_REPLICA2[(PostgreSQL Replica 2)]
            end
            
            subgraph "訊息資料庫叢集"
                MONGO_PRIMARY[(MongoDB Primary)]
                MONGO_SECONDARY1[(MongoDB Secondary 1)]
                MONGO_SECONDARY2[(MongoDB Secondary 2)]
            end
            
            subgraph "快取叢集"
                REDIS_MASTER[(Redis Master)]
                REDIS_SLAVE1[(Redis Slave 1)]
                REDIS_SLAVE2[(Redis Slave 2)]
            end
        end
    end
    
    subgraph "外部服務 External Services"
        S3_PROD[AWS S3 Production]
        CDN_PROD[CloudFront CDN]
        FCM_PROD[FCM Production]
        APNS_PROD[APNS Production]
    end
    
    subgraph "監控與日誌 Monitoring"
        PROMETHEUS[Prometheus 監控]
        GRAFANA[Grafana 儀表板]
        ELK[ELK 日誌系統]
    end

    %% 流量路由
    WAF --> ELB
    ELB --> API1
    ELB --> API2  
    ELB --> API3
    ELB --> WS1
    ELB --> WS2
    ELB --> WS3

    %% 資料庫連接
    API1 --> PG_PRIMARY
    API1 --> PG_REPLICA1
    API1 --> MONGO_PRIMARY
    API1 --> REDIS_MASTER
    
    API2 --> PG_PRIMARY
    API2 --> PG_REPLICA2
    API2 --> MONGO_PRIMARY
    API2 --> REDIS_MASTER
    
    API3 --> PG_PRIMARY
    API3 --> PG_REPLICA1
    API3 --> MONGO_PRIMARY
    API3 --> REDIS_MASTER

    %% 資料庫複製
    PG_PRIMARY --> PG_REPLICA1
    PG_PRIMARY --> PG_REPLICA2
    MONGO_PRIMARY --> MONGO_SECONDARY1
    MONGO_PRIMARY --> MONGO_SECONDARY2
    REDIS_MASTER --> REDIS_SLAVE1
    REDIS_MASTER --> REDIS_SLAVE2

    %% 外部服務連接
    API1 --> S3_PROD
    API2 --> S3_PROD
    API3 --> S3_PROD
    S3_PROD --> CDN_PROD
    
    API1 --> FCM_PROD
    API2 --> FCM_PROD
    API3 --> FCM_PROD
    
    API1 --> APNS_PROD
    API2 --> APNS_PROD
    API3 --> APNS_PROD

    %% 監控連接
    API1 --> PROMETHEUS
    API2 --> PROMETHEUS
    API3 --> PROMETHEUS
    WS1 --> PROMETHEUS
    WS2 --> PROMETHEUS
    WS3 --> PROMETHEUS
    
    PROMETHEUS --> GRAFANA
    
    API1 --> ELK
    API2 --> ELK
    API3 --> ELK

    %% 樣式
    classDef prodClass fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    classDef dataClass fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    classDef externalClass fill:#fce4ec,stroke:#c2185b,stroke-width:2px
    classDef monitorClass fill:#f1f8e9,stroke:#558b2f,stroke-width:2px

    class API1,API2,API3,WS1,WS2,WS3,ELB,WAF prodClass
    class PG_PRIMARY,PG_REPLICA1,PG_REPLICA2,MONGO_PRIMARY,MONGO_SECONDARY1,MONGO_SECONDARY2,REDIS_MASTER,REDIS_SLAVE1,REDIS_SLAVE2 dataClass
    class S3_PROD,CDN_PROD,FCM_PROD,APNS_PROD externalClass
    class PROMETHEUS,GRAFANA,ELK monitorClass
```

## 📊 容量規劃

### 預估使用量
- **活躍用戶**: 100萬人
- **同時在線**: 100,000人
- **每日訊息**: 1000萬則
- **檔案上傳**: 每日 100GB
- **推播通知**: 每日 500萬則

### 資源配置建議
- **API Server**: 6-8 個實例 (每個 4 核 8GB)
- **WebSocket Server**: 4-6 個實例 (每個 2 核 4GB)
- **PostgreSQL**: 主從架構 (主庫 8 核 32GB，從庫 4 核 16GB)
- **MongoDB**: 副本集 (每個 8 核 32GB)
- **Redis**: 叢集模式 (每個 4 核 16GB)

## 🔒 安全考量

### 網路安全
- **WAF**: 阻擋惡意請求
- **DDoS 防護**: 流量清洗
- **SSL/TLS**: 端到端加密
- **VPC**: 私有網路隔離

### 應用安全
- **JWT Token**: 短期有效期
- **Rate Limiting**: API 請求限制
- **輸入驗證**: 防止注入攻擊
- **權限控制**: RBAC 角色權限

### 資料安全
- **資料庫加密**: 靜態加密
- **備份加密**: 自動化備份
- **敏感資料**: 雜湊處理
- **審計日誌**: 操作追蹤