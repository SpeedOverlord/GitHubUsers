# 取得GitHub 使用者列表與詳細資料

此專案目的為取得GitHub 使用者列表與詳細資料，架構使用MVVMC，比MVVM多了Coordinator用於畫面轉導。此外，還加入了多語系、深淺色模式支援，以及部分用於測試API是否順暢的單元測試。

## 功能

- 取得GitHub 使用者列表
- 顯示GitHub 使用者詳細資料
- 支援多語系
- 支援深淺色模式
- 錯誤處理以及對應畫面
- 使用Unit Test測試API是否順暢

## 技術架構

- **MVVMC架構**：比MVVM多了Coordinator用於畫面轉導
- **UserDefaults簡易Cache系統**：在呼叫個人詳細資料API時，使用ETag來實現簡單的Cache機制
- **Combine框架**：用於資料綁定和事件處理
- **Compositional Layout**：用於自動布局的UI設計
