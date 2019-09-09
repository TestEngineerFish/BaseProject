#  说明

* 数据库创建
* 数据库删除
* 表创建
* 表删除
* 记录更新
* 记录查询
* 构造对象

### 文件结构说明
    * BPDatabaseProtocol (定义了数据库的执行器,操作类只需要继承即可使用数据库对应的 **执行器** )
    * BPDatabaseManager  (构造数据的执行器)
    * BPSQLManager       (定义所有SQL语句)
    * BPNormalOperator   (普通数据库的 **操作类** ,用来执行SQL语句)
    * BPIMDBOperator     (IM系统的数据库 **操作类** ,用来执行SQL语句)
    * NormalDBCenter     (面下业务层,对普通数据库的操作,统一从这个类进行 **调用** )
    * IMDBCenter         (面向业务层,对IM系统数据库的操作,统一从这个类进行 **调用** )
    
    


