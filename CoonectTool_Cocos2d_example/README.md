# com.17dame.connecttool_ios_oc

## Table of Contents  
- [安裝](#安裝) 
- [Setting](#setting)
    - [加入 ConnectToolConfig](#加入-connecttoolconfig)
- [VC 佈局](#viewcontroller-佈局)
    - [ConnectTool 初始](#connecttool-初始)
- [發行版本切換](#發行版本切換)
- [登入 / 註冊](#登入--註冊)
    - [範例](#呼叫範例)
    - [參考](#參考)
- [取得用戶資訊](#取得用戶資訊)
    - [範例](#呼叫範例-1) 
- [儲值 SP](#儲值-sp)
    - [範例](#呼叫範例-2) 
    - [儲值 SP 測試用資料](#儲值-sp-測試用資料) 
    - [參考](#參考-1)
- [消費 SP](#消費-sp)
    - [範例](#呼叫範例-3)
    - [消費說明](#開啟頁面)
- [遊戲 Server 端驗證方式](#遊戲-server-端驗證方式)
  
## 安裝
-  取得 ConnectToolKit.xcframework
-  選取專案 -> Link Binary With Libraries , 選擇下方下入 
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_example/link_flow_1.jpg" width="600">

-  彈跳視窗選擇 Add Files
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_example/link_flow_2.jpg" width="300">

-  選擇 SDK 提供的 ConnectToolKit.xcframework 資料夾
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_example/link_flow_3.jpg" width="400">

-  完成 Link Binary With Libraries 的引用
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_example/link_flow_4.jpg" width="400">

 
