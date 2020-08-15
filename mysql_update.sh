#!/bin/bash
# 接收输入所需参数
echo "+------------------------------------+"
echo "| 若输入有误，请按下Ctrl + Backspace |"
echo "+------------------------------------+"
read -p "请输入你的数据库用户名：" user
read -s -p  "请输入你的数据库密码："  password
echo "******"
read -p "请输入数据库名字：" database

# 切换工作路径
cd /mnt
work=`pwd` 

# 获取指定数据库的所有表，并写入一个txt文件，用变量接收等待使用
mysql -u$user -p$password -N -B -e "use $database;show tables;" > tables.txt
sedtables=`cat  $work/tables.txt`

# 传入替换所需的参数{查询值,替换值}
read -p "请输入查询值：" inquire
read -p "请输入替换值：" replace

# 设置for循环将得到的表名逐个插入数组
c=1
for t in $sedtables
do
	# 获取指定数据库下数据表的表字段，并写入一个txt文件，用变量接收等待处理
	mysql -u$user -p$password -N -B -e "use $database;desc $t;" > desc.txt
	awkdesc=`awk '{print $1}' $work/desc.txt`
	# 将获取的数据表进行套用，再将数据表内的表字段进行套用
	for d in $awkdesc 
	do
		mysql -u$user -p$password -e "use $database;update $t set $d=replace($d,'$inquire','$replace');"
		echo "程序运行了 $c 次！！!"
		c=`expr $c + 1`
	done
done

# 清理生成的文件
rm -rf $work/{desc.txt,tables.txt}

