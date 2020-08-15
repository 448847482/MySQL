#!/bin/bash
# 接收输入所需参数
echo "+------------------------------------+"
echo "| 若输入有误，请按下Ctrl + Backspace |"
echo "+------------------------------------+"
read -p "请输入你的数据库用户名：" user
read -s -p  "请输入你的数据库密码："  password
echo "******"
read -p "请输入数据库名字：" database
read -p "请输入你要查询的记录：" value

# 切换到指定目录，并获取该目录位置
cd /mnt
work=`pwd`

# 获取指定数据库的所有表，并写入一个txt文件，用变量接收等待使用
mysql -u$user -p$password -N -B -e "use $database;show tables;" > tables.txt
sedtables=`cat  $work/tables.txt`

# 将文件中的表名进行套用，获取全表指定内容
for p in $sedtables
do
	mysql -u$user -p$password -e "use $database;select * from $p;" | grep --color=auto $value
done
if [ $? -eq 0 ]
then
	echo "搜寻完毕......!"
else
	echo "数据库中不存在该记录......!"

fi
# 删除生成的文件
rm -rf $work/tables.txt
