# com.17dame.connecttool_ios_oc

## Table of Contents  
- [安裝](#安裝) 
- [Setting](#setting)
    - [加入 ConnectToolConfig](#加入-connecttoolconfig) 
  
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


## Setting   
### 加入 ConnectToolConfig
- Add ConnectToolConfig.xcconfig to Project 
- File > New > File > Configurations > Debug & Release
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios/blob/main/images/add_config.png?raw=true" width="600">

- 命其名為 : ConnectToolConfig
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_example/saveConfig.jpg" width="400">
 
- 儲存
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_example/saveConfig.jpg" width="400">

- 進 Project 進行配置
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_example/configSet.jpg" width="450">

- 填入對應資料
```txt
X_Developer_Id = 
client_secret =  
Game_id = 
```

- Info.plist 增加數據
```XML 
    <key>X_Developer_Id</key>
    <string>$(X_Developer_Id)</string>
    <key>client_secret</key>
    <string>$(client_secret)</string>
    <key>redirect_uri</key>
    <string>$(redirect_uri)</string>
    <key>Game_id</key>
    <string>$(Game_id)</string>  
```
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_example/infoAddkey.jpg" width="450">

 
