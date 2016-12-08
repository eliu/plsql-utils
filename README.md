# plsql-utils：README

这个项目包含了我自从接触Oracle数据库和E-Business Suite系统以来的一些通用程序包和常用脚本。

我把它们放在这里有两个目的：

1. 为自己：集中维护在一个地方，方便以后查找和防止丢失

2. 为大家：共享出来能让其他人受益，少走些弯路


### 内容概要

| 子目录 | 对象名称 | 对象描述 |
| :--- | :--- | :--- |
| /tests | N/A | 功能测试脚本 |
| /src/scripts | N/A | 常用的查询脚本 |
| /src/packages | app\_record2 | 用于方便的将Form数据块中的一行记录进行禁用/启用，仅适用于Form模块。 |
|  | cux\_seq\_utils | 重置序列值 |
|  | utl\_smtp\_helper | 基于utl\_smtp标准包的邮件发送助手程序，支持纯文本和HTML两种内容格式，支持多附件上传。 |
|  | cux\_xmldom\_helper | 基于dbms\_xmldom的助手程序，里面的innerText函数可以方便的提取XML标记中的所有文本内容。 |
|  | cux\_dbws\_helper | 基于utl\_dbws包的助手程序，简化使用utl\_dbws调用Web Service的过程。 |



