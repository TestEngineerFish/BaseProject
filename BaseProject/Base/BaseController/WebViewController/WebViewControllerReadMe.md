#  BPBaseWebViewController 使用说明
所有的配置都在BPBaseWebViewController中实现
主要动态有以下两个
* 需要注册的函数
    > 所有函数写到一个固定的类中,然后在AppDelegate类中的didFinishLaunchingWithOptions函数中指定
```
BPBaseWebViewController.lmplClass = XXX.classForCoder()
```
    
    
* 需要注入的js脚本

