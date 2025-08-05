const express = require('express');
const swaggerUi = require('swagger-ui-express');
const YAML = require('yamljs');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.DOCS_PORT || 3001;

// Load the swagger YAML file
const swaggerDocument = YAML.load(path.join(__dirname, '../swagger.yaml'));

// Enhanced Swagger UI options with custom JavaScript for Mermaid support
const options = {
  customCss: `
    .swagger-ui .topbar { display: none }
    .swagger-ui .info .title { color: #1976d2; }
    .swagger-ui .scheme-container { display: none }
    .architecture-section {
      margin: 20px 0;
      padding: 20px;
      border: 1px solid #ddd;
      border-radius: 8px;
      background-color: #f9f9f9;
    }
    .architecture-section h3 {
      color: #1976d2;
      margin-bottom: 15px;
    }
    .mermaid {
      text-align: center;
      margin: 20px 0;
    }
    .nav-tabs {
      display: flex;
      border-bottom: 1px solid #ddd;
      margin-bottom: 20px;
    }
    .nav-tab {
      padding: 10px 20px;
      cursor: pointer;
      border: 1px solid #ddd;
      border-bottom: none;
      background-color: #f5f5f5;
      margin-right: 5px;
    }
    .nav-tab.active {
      background-color: #1976d2;
      color: white;
    }
    .tab-content {
      display: none;
    }
    .tab-content.active {
      display: block;
    }
  `,
  customJs: `
    // Load Mermaid library
    const script = document.createElement('script');
    script.src = 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js';
    script.onload = function() {
      mermaid.initialize({
        startOnLoad: true,
        theme: 'default',
        themeVariables: {
          primaryColor: '#1976d2',
          primaryTextColor: '#333',
          primaryBorderColor: '#1976d2',
          lineColor: '#666'
        }
      });
      
      // Tab switching functionality
      setTimeout(() => {
        const tabs = document.querySelectorAll('.nav-tab');
        const contents = document.querySelectorAll('.tab-content');
        
        tabs.forEach((tab, index) => {
          tab.addEventListener('click', () => {
            tabs.forEach(t => t.classList.remove('active'));
            contents.forEach(c => c.classList.remove('active'));
            
            tab.classList.add('active');
            contents[index].classList.add('active');
            
            // Re-render mermaid diagrams in the active tab
            mermaid.init(undefined, document.querySelectorAll('.tab-content.active .mermaid'));
          });
        });
        
        // Activate first tab by default
        if (tabs.length > 0) {
          tabs[0].click();
        }
      }, 1000);
    };
    document.head.appendChild(script);
  `,
  customSiteTitle: "Messenger Lite Clone API Documentation",
  customfavIcon: "/favicon.ico"
};

// Serve static files
app.use('/static', express.static(path.join(__dirname)));

// Architecture documentation endpoint
app.get('/architecture', (req, res) => {
  try {
    const architectureContent = fs.readFileSync(path.join(__dirname, 'architecture.md'), 'utf8');
    
    // Pre-process the content to escape it properly
    const escapedContent = architectureContent
      .replace(/\\/g, '\\\\')
      .replace(/`/g, '\\`')
      .replace(/\$/g, '\\$');
    
    const htmlContent = `
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messenger Lite Clone - 系統架構</title>
    <script src="https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"></script>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
            color: #333;
        }
        h1, h2, h3 { color: #1976d2; }
        .mermaid {
            text-align: center;
            margin: 30px 0;
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
        }
        .nav-buttons {
            text-align: center;
            margin: 20px 0;
        }
        .nav-buttons a {
            background: #1976d2;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            margin: 0 10px;
        }
        .nav-buttons a:hover {
            background: #1565c0;
        }
        pre {
            background: #f5f5f5;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #f5f5f5;
            font-weight: bold;
        }
        .section {
            margin: 40px 0;
            padding: 20px;
            border-left: 4px solid #1976d2;
            background: #f9f9f9;
        }
    </style>
</head>
<body>
    <div class="nav-buttons">
        <a href="/api-docs">← 返回 API 文件</a>
        <a href="/">🏠 首頁</a>
    </div>
    
    <div id="content"></div>
    
    <div class="nav-buttons">
        <a href="/api-docs">查看 API 端點詳細規格 →</a>
    </div>

    <script>
        // Initialize Mermaid
        mermaid.initialize({
            startOnLoad: true,
            theme: 'default',
            themeVariables: {
                primaryColor: '#1976d2',
                primaryTextColor: '#333',
                primaryBorderColor: '#1976d2',
                lineColor: '#666',
                background: '#ffffff'
            },
            flowchart: {
                useMaxWidth: true,
                htmlLabels: true
            },
            er: {
                useMaxWidth: true
            },
            sequence: {
                useMaxWidth: true
            }
        });

        // Content processing
        const rawContent = \`${escapedContent}\`;
        
        // Simple markdown to HTML conversion for our specific needs
        let html = rawContent
            .replace(/\`\`\`mermaid\\n([\\s\\S]*?)\\n\`\`\`/g, '<div class="mermaid">$1</div>')
            .replace(/### (.*)/g, '<h3>$1</h3>')
            .replace(/## (.*)/g, '<h2>$1</h2>')
            .replace(/# (.*)/g, '<h1>$1</h1>')
            .replace(/\\*\\*(.*?)\\*\\*/g, '<strong>$1</strong>')
            .replace(/\\*(.*?)\\*/g, '<em>$1</em>')
            .replace(/^- (.*)/gm, '<li>$1</li>')
            .replace(/((<li>.*<\\/li>\\s*)+)/gs, '<ul>$1</ul>')
            .replace(/\\n\\n/g, '</p><p>')
            .replace(/^(.+)$/gm, '<p>$1</p>')
            .replace(/<p><h/g, '<h')
            .replace(/<\\/h([1-6])><\\/p>/g, '</h$1>')
            .replace(/<p><ul>/g, '<ul>')
            .replace(/<\\/ul><\\/p>/g, '</ul>')
            .replace(/<p><div class="mermaid">/g, '<div class="mermaid">')
            .replace(/<\\/div><\\/p>/g, '</div>');

        document.getElementById('content').innerHTML = html;
        
        // Re-initialize Mermaid after content is loaded
        setTimeout(() => {
            mermaid.init(undefined, document.querySelectorAll('.mermaid'));
        }, 500);
    </script>
</body>
</html>
    `;
    
    res.send(htmlContent);
  } catch (error) {
    res.status(500).json({
      error: 'Failed to load architecture documentation',
      message: error.message
    });
  }
});

// Enhanced Swagger setup with architecture integration
const customSwaggerHtml = (swaggerUiAssetPath, swaggerUiBundle, swaggerUiStandalonePreset) => {
  return `
<!DOCTYPE html>
<html lang="zh-TW">
<head>
  <meta charset="UTF-8">
  <title>Messenger Lite Clone API Documentation</title>
  <link rel="stylesheet" type="text/css" href="${swaggerUiAssetPath}/swagger-ui-bundle.css" />
  <link rel="stylesheet" type="text/css" href="${swaggerUiAssetPath}/swagger-ui.css" />
  <style>
    ${options.customCss}
  </style>
</head>
<body>
  <div id="swagger-ui"></div>
  <script src="${swaggerUiAssetPath}/swagger-ui-bundle.js"></script>
  <script src="${swaggerUiAssetPath}/swagger-ui-standalone-preset.js"></script>
  <script>
    window.onload = function() {
      const ui = SwaggerUIBundle({
        url: '/swagger.json',
        dom_id: '#swagger-ui',
        deepLinking: true,
        presets: [
          SwaggerUIBundle.presets.apis,
          SwaggerUIStandalonePreset
        ],
        plugins: [
          SwaggerUIBundle.plugins.DownloadUrl
        ],
        layout: "StandaloneLayout"
      });
      
      ${options.customJs || ''}
    };
  </script>
</body>
</html>
  `;
};

// Serve swagger.json
app.get('/swagger.json', (req, res) => {
  res.json(swaggerDocument);
});

// Serve swagger documentation with custom HTML
app.use('/api-docs', swaggerUi.serve);
app.get('/api-docs', (req, res) => {
  res.send(customSwaggerHtml('/api-docs', 'swagger-ui-bundle.js', 'swagger-ui-standalone-preset.js'));
});

// Enhanced root endpoint with navigation
app.get('/', (req, res) => {
  const homeHtml = `
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messenger Lite Clone - API 文件中心</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 40px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }
        .container {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        h1 {
            color: #1976d2;
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5em;
        }
        .description {
            text-align: center;
            margin-bottom: 40px;
            font-size: 1.1em;
            color: #666;
        }
        .nav-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .nav-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 25px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s ease;
            text-align: center;
        }
        .nav-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            border-color: #1976d2;
        }
        .nav-card h3 {
            color: #1976d2;
            margin-bottom: 10px;
            font-size: 1.3em;
        }
        .nav-card p {
            margin: 0;
            font-size: 0.9em;
            color: #666;
        }
        .features {
            margin-top: 40px;
        }
        .features h3 {
            color: #1976d2;
            margin-bottom: 15px;
        }
        .features ul {
            list-style: none;
            padding: 0;
        }
        .features li {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        .features li:before {
            content: "✅ ";
            margin-right: 8px;
        }
        .footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            color: #999;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Messenger Lite Clone</h1>
        <div class="description">
            完整的即時通訊應用程式 API 文件與系統架構
        </div>
        
        <div class="nav-cards">
            <a href="/api-docs" class="nav-card">
                <h3>📋 API 規格文件</h3>
                <p>完整的 Swagger API 文件，包含所有端點規格與使用範例</p>
            </a>
            
            <a href="/architecture" class="nav-card">
                <h3>🏗️ 系統架構</h3>
                <p>詳細的系統架構圖、資料庫設計與部署架構說明</p>
            </a>
            
            <a href="/health" class="nav-card">
                <h3>❤️ 健康檢查</h3>
                <p>檢查文件伺服器運行狀態與系統資訊</p>
            </a>
        </div>
        
        <div class="features">
            <h3>🎯 主要功能模組</h3>
            <ul>
                <li><strong>使用者管理</strong> - 註冊、登入、個人資料管理</li>
                <li><strong>好友管理</strong> - 搜尋、邀請、分組管理</li>
                <li><strong>即時訊息</strong> - 多媒體訊息、狀態追蹤</li>
                <li><strong>群組聊天</strong> - 群組管理、權限控制</li>
                <li><strong>通知系統</strong> - 推播通知、勿打擾設定</li>
                <li><strong>隱私控制</strong> - 線上狀態、隱私設定</li>
                <li><strong>檔案上傳</strong> - 圖片、檔案、語音處理</li>
            </ul>
        </div>
        
        <div class="footer">
            基於 BDD (行為驅動開發) 設計 | Express.js + TypeScript | v1.0.0
        </div>
    </div>
</body>
</html>
  `;
  
  res.send(homeHtml);
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'API Documentation Server is running',
    version: '1.0.0',
    services: {
      swagger: 'Active',
      architecture: 'Active',
      mermaid: 'Supported'
    },
    endpoints: {
      home: 'http://localhost:' + PORT,
      apiDocs: 'http://localhost:' + PORT + '/api-docs',
      architecture: 'http://localhost:' + PORT + '/architecture',
      health: 'http://localhost:' + PORT + '/health'
    },
    timestamp: new Date().toISOString()
  });
});

app.listen(PORT, () => {
  console.log(`📚 API Documentation Server is running on port ${PORT}`);
  console.log(`🏠 Home: http://localhost:${PORT}`);
  console.log(`🌐 Swagger UI: http://localhost:${PORT}/api-docs`);
  console.log(`🏗️  Architecture: http://localhost:${PORT}/architecture`);
  console.log(`❤️  Health Check: http://localhost:${PORT}/health`);
});

module.exports = app;