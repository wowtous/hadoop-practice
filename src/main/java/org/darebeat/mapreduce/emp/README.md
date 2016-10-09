# 准备测试数据
```sh
cd ~
mkdir data
cd data
echo " \
10,ACCOUNTING,NEW YORK \
20,RESEARCH,DALLAS \
30,SALES,CHICAGO \
40,OPERATIONS,BOSTON" > dept

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
7934,MILLER,CLERK,7782,23-1月-82,1300,,10 " > emp
```

# 上传数据到HDFS中
```sh
hadoop fs -mkdir -p /data/input # if not exists
hadoop fs -copyFromLocal dept /data/input
hadoop fs -copyFromLocal emp /data/input
hadoop fs -ls /data/input
```

# 编译并打包代码
```sh
javac -classpath xx1.jar:xx2.jar xx.java
jar cvf ./xxx.jar ./xx*.class
mv *.jar ../..
rm xx*.class
```

# 运行并查看结果
部门数据路径：hdfs://hadoop:9000/data/input/dept，部门数据将缓存在各运行任务的节点内容中，可以提供处理的效率<br>
员工数据路径：hdfs://hadoop:9000/data/input/emp<br>
输出路径：hdfs://hadoop:9000/data/output<br>

```sh
hadoop jar xxx.jar mainName hdfs://hadoop:9000/data/input/dept \
hdfs://hadoop:9000/data/input/emp \
hdfs://hadoop:9000/data/output

hadoop fs -ls /data/output
hadoop fs -cat /data/output/part-r-00000
```