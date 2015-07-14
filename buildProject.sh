

#自动化构建IPA
buildIpa(){
	#! /bin/bash
	#进入工程目录
	security unlock-keychain -p '1a2b3c4d' /Users/chencc/Library/Keychains/login.keychain
	cd ~/Desktop/vpackage/project/${app_framework_version}/platforms/ios
	#clean
	xcodebuild -target V3APP clean
	#开始构建工程：修改buildsettings，暂时先修改工程名称、支持版本
	xcodebuild -target V3APP PRODUCT_NAME='${app_name_UTF8}'
	#将build生成的app二进制文件打包成ipa文件
	xcrun -l -sdk iphoneos PackageApplication -v ~/Desktop/vpackage/project/${app_framework_version}/platforms/ios/build/Release-iphoneos/"$app_name_GBK".app -o ~/Desktop/vpackage/config/projectName/output/ipa/${app_name_hashcode}.ipa
	xcrun -l -sdk iphoneos PackageApplication -v ~/Desktop/vpackage/project/${app_framework_version}/platforms/ios/build/Release-iphoneos/${app_name_GBK}.app -o ~/Desktop/vpackage/config/projectName/output/ipa/${app_name_hashcode}.ipa
	
}

#二、修改启动模式信息，需要求改GlobalVariables.js文件
configPath="/Users/chencc/Desktop/vpackage/project/${app_framework_version}/platforms/ios/www/config/"
while read line
do
key=`echo $line|awk -F '=' '{print $1}'`
value=`echo $line|awk -F '=' '{print $2}'`
if [ "$key" == "var serverPath " ]; then
#修改服务器默认地址
sed "s#${value}#'${app_serverUrl}' ;#g" ${configPath}GlobalVariables.js>${configPath}temp.js
mv ${configPath}temp.js ${configPath}GlobalVariables.js
elif [ "$key" == "var localComponent " ]; then
#修改app加载模式
sed "s#${value}#${app_islocalComponent};#g" ${configPath}GlobalVariables.js>${configPath}temp.js
#mv ${configPath}temp1.js ${configPath}GlobalVariables.js
elif [ "$key" == "var port " ]; then
#修改app加载模式
sed "s#${value}#'${app_port}';#g" ${configPath}GlobalVariables.js>${configPath}temp.js
mv ${configPath}temp.js ${configPath}GlobalVariables.js
fi
done < ${configPath}GlobalVariables.js


#四、调用构建方法
buildIpa

