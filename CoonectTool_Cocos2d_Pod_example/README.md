# com.17dame.connecttool_ios_oc_Pod
 
## 安裝 Pod
### Install
-  Terminal 移動到 iOS 專案資料夾下,例如：/proj.ios_mac/專案.xcodeproj
-  執行指令 pod init, 產生出 Podfile
- 在專案 target 中加入 :  pod 'ConnectToolOC', '~> 0.1'

```txt
# Uncomment the next line to define a global platform for your project
# platform :ios, '15.0'

target '專案-desktop' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for 專案-desktop
end

target '專案-mobile' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for 專案-mobile

  pod 'ConnectToolOC', '~> 0.1'
end
```
- 填妥後回到 Terminal ,並執行 pod repo update
- 更新完後執行 pod install

### Pod 調整
- 把 pod 對應的.xcconfig添加到 iOS 裡 
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_Pod_example/images/InfoConfig.png" width="500">


### 執行
- 專案資料夾會新增 "專案.xcworkspace", 用.xcworkspace 來開啟專案
- 開啟 Product -> Clean Build Folder, 清除資料 
- 完成安裝


## Setting   
### 加入 ConnectToolConfig
- Add ConnectToolConfig.xcconfig to Project 
- File > New > File > Configurations > Debug & Release
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios/blob/main/images/add_config.png?raw=true" width="500">

- 命其名為 : ConnectToolConfig

- 進 Project 進行配置
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios_oc/blob/main/CoonectTool_Cocos2d_Pod_example/images/projectConfig.jpg" width="500">

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
    <key>Game_id</key>
    <string>$(Game_id)</string>  
```
<img src="https://github.com/jianweiCiou/com.17dame.connecttool_ios/blob/main/images/plist.png?raw=true" width="600">




 
