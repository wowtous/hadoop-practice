# hadoop practice

A project created to some hadoop example practice. 

#### 项目准备
```sh
git clone https://github.com/wowtous/hadoop-practice.git
cd hadoop-practice
```

---

## HDFS 实验

#### 读取local2hdfs第101-120字节的内容写入HDFS成为一个新文件

+ 编译打包源码
```sh
javac -cp $($HADOOP_HOME/bin/hadoop classpath) \
    -encoding UTF8 \
    -sourcepath src/main/java \
    -d build \
    src/main/java/org/darebeat/hdfs/LocalFile2Hdfs.java

cd build && jar cvf ../hcp.jar org && rm -rf ./* && cd ..
```

+ 新增数据文件
```sh
echo "Manifest-Version: 1.0
Created-By: Darebeat
Name: org.darebeat.hdfs
Main-Class: org.darebeat.hdfs.*
Class-Path: xxx.jar" > test1.txt
```

+ 运行jar包进行测试
```sh
hadoop fs -mkdir -p /data/test
hadoop jar hcp.jar org.darebeat.hdfs.LocalFile2Hdfs ./test1.txt /data/test/test1.txt
hadoop fs -cat /data/test/test1.txt
```

#### 使用编译代码查看文件内容

+ 编译打包源码
```sh
javac -cp $($HADOOP_HOME/bin/hadoop classpath) \
    -encoding UTF8 \
    -sourcepath src/main/java \
    -d build \
    src/main/java/org/darebeat/hdfs/FileSystemCat.java

cd build && jar cvf ../hcat.jar org && rm -rf ./* && cd ..
```

+ 上传文件到hdfs
```sh
hadoop fs -put test1.txt /data/test/test2.txt
```

+ 运行jar包进行测试
```sh
hadoop jar hcat.jar org.darebeat.hdfs.FileSystemCat /data/test/test2.txt
```

#### 在HDFS中生成一个大约100字节的文本文件，写一段程序读入这个文件，并将其第101-120字节的内容写入本地文件系统成为一个新文件。

+ 编译打包源码
```sh
javac -cp $($HADOOP_HOME/bin/hadoop classpath) \
    -encoding UTF8 \
    -sourcepath src/main/java \
    -d build \
    src/main/java/org/darebeat/hdfs/Hdfs2LocalFile.java

cd build && jar cvf ../hget.jar org && rm -rf ./* && cd ..
```

+ 运行jar包进行测试
```sh
hadoop jar hget.jar org.darebeat.hdfs.Hdfs2LocalFile /data/test/test2.txt test2.txt
cat test2.txt
```

## MapReduce 实验

### 气象数据实验
---

#### 数据准备
```sh
# NCDC气象数据下载
cd data
wget http://labfile.oss.aliyuncs.com/courses/237/temperature.zip
unzip temperature.zip && rm -rf temperature.zip
zcat 1971/*.gz > temperature.txt
```

+ 解压气象数据并上传到HDFS中

```sh
hadoop fs -mkdir -p /data/input
hadoop fs -copyFromLocal temperature.txt /data/input
hadoop fs -ls /data/input
cd ..
```

#### 求每年的最低温度
+ 编译打包代码
```sh
javac -cp $($HADOOP_HOME/bin/hadoop classpath) \
    -encoding UTF8 \
    -sourcepath src/main/java \
    -d build \
    src/main/java/org/darebeat/mapreduce/tp/min/*.java

cd build && jar cvf ../minTp.jar org && rm -rf ./* && cd ..
```

+ 运行程序
```sh
hadoop jar minTp.jar org.darebeat.mapreduce.tp.min.MinTemperature /data/input/temperature.txt /data/output
```

+ 查看结果
```sh
hadoop fs -ls /data/output
hadoop fs -cat /data/output/part-r-00000
```

#### 求每年温度的平均值
+ 编译打包代码
```sh
javac -cp $($HADOOP_HOME/bin/hadoop classpath) \
    -encoding UTF8 \
    -sourcepath src/main/java \
    -d build \
    src/main/java/org/darebeat/mapreduce/tp/avg/*.java

cd build && jar cvf ../avgTp.jar org && rm -rf ./* && cd ..
```

+ 运行程序
```sh
hadoop jar avgTp.jar org.darebeat.mapreduce.tp.avg.AvgTemperature /data/input/temperature.txt /data/output1
```

+ 查看结果
```sh
hadoop fs -ls /data/output1
hadoop fs -cat /data/output1/part-r-00000
```

### 员工数据统计实验
---

#### 测试数据准备
```sh
echo " \
10,ACCOUNTING,NEW YORK \
20,RESEARCH,DALLAS \
30,SALES,CHICAGO \
40,OPERATIONS,BOSTON" > data/dept

echo "\
7369,SMITH,CLERK,7902,17-12月-80,800,,20 \
7499,ALLEN,SALESMAN,7698,20-2月-81,1600,300,30 \
7521,WARD,SALESMAN,7698,22-2月-81,1250,500,30 \
7566,JONES,MANAGER,7839,02-4月-81,2975,,20 \
7654,MARTIN,SALESMAN,7698,28-9月-81,1250,1400,30 \
7698,BLAKE,MANAGER,7839,01-5月-81,2850,,30 \
7782,CLARK,MANAGER,7839,09-6月-81,2450,,10 \
7839,KING,PRESIDENT,,17-11月-81,5000,,10 \
7844,TURNER,SALESMAN,7698,08-9月-81,1500,0,30 \
7900,JAMES,CLERK,7698,03-12月-81,950,,30 \
7902,FORD,ANALYST,7566,03-12月-81,3000,,20 \
7934,MILLER,CLERK,7782,23-1月-82,1300,,10 " > data/emp
```

#### 上传数据到HDFS中

```sh
hadoop fs -mkdir -p /data/input # if not exists
hadoop fs -copyFromLocal data/dept /data/input
hadoop fs -copyFromLocal data/emp /data/input
hadoop fs -ls /data/input
```

#### 员工数据统计
+ 编译并打包代码
```sh
javac -cp $($HADOOP_HOME/bin/hadoop classpath) \
    -encoding UTF8 \
    -sourcepath src/main/java \
    -d build \
    src/main/java/org/darebeat/mapreduce/emp/*.java

cd build && jar cvf ../hemp.jar org && rm -rf ./* && cd ..
```

+ 运行并查看结果
```sh
./runEmp.sh Q1SumDeptSalary
./runEmp.sh Q2DeptNumberAveSalary
./runEmp.sh Q3DeptEarliestEmp
./runEmp.sh Q4SumCitySalary
./runEmp.sh Q5EarnMoreThanManager hemp.jar /data/input/emp /data/Q5EarnMoreThanManager
./runEmp.sh Q6HigherThanAveSalary hemp.jar /data/input/emp /data/Q6HigherThanAveSalary
./runEmp.sh Q7NameDeptOfStartJ
./runEmp.sh Q8SalaryTop3Salary hemp.jar /data/input/emp /data/Q8SalaryTop3Salary
./runEmp.sh Q9EmpSalarySort hemp.jar /data/input/emp /data/Q9EmpSalarySort
./runEmp.sh Q10MiddlePersonsCountForComm hemp.jar /data/input/emp /data/Q10MiddlePersonsCountForComm
```