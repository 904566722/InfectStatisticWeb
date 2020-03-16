# InfectStatisticWeb

## 项目简介

使用javaEE实现的某次疫情统计可视化，可通过地图的形式来直观显示疫情的大致分布情况，还可以点击查看具体省份的疫情统计情况。

## 云服务器地址

[http://47.100.50.81:8080/infectStatisticWeb/](http://47.100.50.81:8080/infectStatisticWeb/)

## 构建方法

1. 使用IDEA或Eclipse创建javaEE项目，推荐tomcat8.5和jdk11以上版本；
2. 将src和web包内的文件复制到新建项目对应目录中；
3. 为项目添加sqlite-jdbc和json依赖，将dependency包内zip解压并为项目添加依赖；
4. 将database包中的infectStatistic.db置于D盘根目录（可至src/InfectStatistic/util/DBConnect.java改变数据库路径）；
5. 使用tomcat运行项目。
