if函数
如下，当满足xx条件时返回1，否则返回0.同时求avg
round(avg(if(rating<3,1,0))*100,2)

取别名，比如将author_id在输出时变成id
select author_id as id from

输出升序排列
select viewer_id from Views order by author_id asc

升序asc
降序desc
按顺序的优先级(优先percentage的desc降序，如果相等则再以contest_id排序)
order by percentage desc,b.contest_id
去重gruop by
select id from views group by id   ##根据ip去重

查字符串的字数
char_length（str）

left join on 左连接，空处用null填充
join on 内连接，空处舍弃

进行满足on后条件的两表的左合并，空处取null
left join ...on..

cross join：
select * from a cross join b，求出a和b的所有组合，比如说a有三行，b有四行，那就共有十二行

group by ... having .... 
have是group by的过滤器，如下用来过滤掉group by我们想要的，类似uhwere
select a.name  from Employee a left join Employee b on b.managerId=a.id group by a.id,a.name,a.department having count(b.managerId)>=5

group by 后在select的列处可有的常见操作
------------------------------------------------------------------
将yy-mm-dd转化的操作，如下，将trans_date转化为year-month的形式，方便聚合
DATE_FORMAT(trans_date, '%Y-%m')

取几位小数，round，把..的值取2位小数
round(..,2)

如果为不为空值则返回action1的结果，否则返回action2的
IFNULL(action1，action2)

求平均值AVG
AVG(...)
有个比较好的求xx成功率方法,假如我们要求do的成功率，那就直接avg这个，因为当action不等于do时，会返回0
假如有五个action，则有 1 1 0 0 0 ，do的概率为2/5，刚好与结果相同
AVG(x.action=“do”)

相加SUM
SUM(a.price*b.units)/SUM(b.units)

根据某个列需要在betwenn特定条件进行聚合
如下，这个就是聚合b到a里面，且满足b的销售date列日期在a的日期之间
left join UnitsSold b 
on b.purchase_date between a.start_date and a.end_date 
--------------------------------------------------------------------

一个有点神奇的取列数方法，常用于求比例
如下，我们先求users表 user_id的列数，直接select count(user_id) from users即可
select id,(select count(user_id) from users)

对于group by条件的思考，也就是进行一个组合，比如说
我们 group by student_id，student_name，subject_name，那么我们在进行计算的时候，就会将它们看成满足这三个条件相等的看成同一组进行计算



如有 Employees 表:
+----+----------+
| id | name     |
+----+----------+
| 1  | Alice    |
| 7  | Bob      |
| 11 | Meir     |
| 90 | Winston  |
| 3  | Jonathan |
+----+----------+
EmployeeUNI 表:
+----+-----------+
| id | unique_id |
+----+-----------+
| 3  | 1         |
| 11 | 2         |
| 90 | 3         |
+----+-----------+
我们现在想把这两个表合并，可以看到他们的相同列id，则有
select * from Employees left join EmployeeUNI on Employees.id=EmployeeUNI.id





编写解决方案，找出与之前（昨天的）日期相比温度更高的所有日期的 id 。

返回结果 无顺序要求 。
输入：
Weather 表：
+----+------------+-------------+
| id | recordDate | Temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
输出：
+----+
| id |
+----+
| 2  |
| 4  |
+----+
解释：
2015-01-02 的温度比前一天高（10 -> 25）
2015-01-04 的温度比前一天高（20 -> 30）
解题思路：一个自连接， DATEDIFF(w1.recordDate,w2.recordDate)=1表示w1的日期减去w2的日期正好等于1
a a1 join a a2 on DATEDIFF(a1.Date，a2.Date)=1

select w1.id as Id from Weather w1 join Weather w2 on DATEDIFF(w1.recordDate,w2.recordDate)=1 where w1.temperature>w2.temperature


现在有一个工厂网站由几台机器运行，每台机器上运行着 相同数量的进程 。编写解决方案，计算每台机器各自完成一个进程任务的平均耗时。
完成一个进程任务的时间指进程的'end' 时间戳 减去 'start' 时间戳。平均耗时通过计算每台机器上所有进程任务的总耗费时间除以机器上的总进程数量获得。
结果表必须包含machine_id（机器ID） 和对应的 average time（平均耗时） 别名 processing_time，且四舍五入保留3位小数。
以 任意顺序 返回表。
具体参考例子如下。
示例 1:
输入：
Activity table:
+------------+------------+---------------+-----------+
| machine_id | process_id | activity_type | timestamp |
+------------+------------+---------------+-----------+
| 0          | 0          | start         | 0.712     |
| 0          | 0          | end           | 1.520     |
| 0          | 1          | start         | 3.140     |
| 0          | 1          | end           | 4.120     |
| 1          | 0          | start         | 0.550     |
| 1          | 0          | end           | 1.550     |
| 1          | 1          | start         | 0.430     |
| 1          | 1          | end           | 1.420     |
| 2          | 0          | start         | 4.100     |
| 2          | 0          | end           | 4.512     |
| 2          | 1          | start         | 2.500     |
| 2          | 1          | end           | 5.000     |
+------------+------------+---------------+-----------+
输出：
+------------+-----------------+
| machine_id | processing_time |
+------------+-----------------+
| 0          | 0.894           |
| 1          | 0.995           |
| 2          | 1.456           |
+------------+-----------------+
解释：
一共有3台机器,每台机器运行着两个进程.
机器 0 的平均耗时: ((1.520 - 0.712) + (4.120 - 3.140)) / 2 = 0.894
机器 1 的平均耗时: ((1.550 - 0.550) + (1.420 - 0.430)) / 2 = 0.995
机器 2 的平均耗时: ((4.512 - 4.100) + (5.000 - 2.500)) / 2 = 1.456

解题思路：感觉还是挺复杂的，需要自联表，链接条件是machine_id，process_id相同，同时表1的activity_type应该是start，表2的activity_type应该是end。同时还需要针对machine_id做个gruop by



编写解决方案，报告每个奖金 少于 1000 的员工的姓名和奖金数额。

以 任意顺序 返回结果表。

结果格式如下所示。
示例 1：

输入：
Employee table:
+-------+--------+------------+--------+
| empId | name   | supervisor | salary |
+-------+--------+------------+--------+
| 3     | Brad   | null       | 4000   |
| 1     | John   | 3          | 1000   |
| 2     | Dan    | 3          | 2000   |
| 4     | Thomas | 3          | 4000   |
+-------+--------+------------+--------+
Bonus table:
+-------+-------+
| empId | bonus |
+-------+-------+
| 2     | 500   |
| 4     | 2000  |
+-------+-------+
输出：
+------+-------+
| name | bonus |
+------+-------+
| Brad | null  |
| John | null  |
| Dan  | 500   |
+------+-------+
解题思路：使用左连接进行一个链接，条件是empId相同，再来个where bonus is null or bonus<1000
select a.name,b.bonus from Employee a left join Bonus b on  a.empId=b.empId where b.bonus is null or b.bonus<1000z



查询出每个学生参加每一门科目测试的次数，结果按 student_id 和 subject_name 排序。
示例 1：

输入：
Students table:
+------------+--------------+
| student_id | student_name |
+------------+--------------+
| 1          | Alice        |
| 2          | Bob          |
| 13         | John         |
| 6          | Alex         |
+------------+--------------+
Subjects table:
+--------------+
| subject_name |
+--------------+
| Math         |
| Physics      |
| Programming  |
+--------------+
Examinations table:
+------------+--------------+
| student_id | subject_name |
+------------+--------------+
| 1          | Math         |
| 1          | Physics      |
| 1          | Programming  |
| 2          | Programming  |
| 1          | Physics      |
| 1          | Math         |
| 13         | Math         |
| 13         | Programming  |
| 13         | Physics      |
| 2          | Math         |
| 1          | Math         |
+------------+--------------+
输出：
+------------+--------------+--------------+----------------+
| student_id | student_name | subject_name | attended_exams |
+------------+--------------+--------------+----------------+
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |
+------------+--------------+--------------+----------------+
解题思路：首先用cross join 查出学生表和科目的全部组合，再使用left join 考试厂数组合过去
select a.student_id,a.student_name,b.subject_name,count(c.subject_name) as attended_exams from Students a cross join Subjects b left join Examinations c on c.student_id=a.student_id and c.subject_name=b.subject_name
group by a.student_id,b.subject_name,a.student_name
order by a.student_id  asc




+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id 是此表的主键（具有唯一值的列）。
该表的每一行表示雇员的名字、他们的部门和他们的经理的id。
如果managerId为空，则该员工没有经理。
没有员工会成为自己的管理者。
 

编写一个解决方案，找出至少有五个直接下属的经理。

以 任意顺序 返回结果表。

查询结果格式如下所示。
示例 1:

输入: 
Employee 表:
+-----+-------+------------+-----------+
| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | Null      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
+-----+-------+------------+-----------+
输出: 
+------+
| name |
+------+
| John |
+------+
解题思路：一个自连接，然后分个组，使用haveing找到有五个b.managerId的名字
select a.name  from Employee a left join Employee b on b.managerId=a.id group by a.id,a.name,a.department having count(b.managerId)>=5










编写一个 sql 查询来查找每个月和每个国家/地区的事务数及其总金额、已批准的事务数及其总金额。
以 任意顺序 返回结果表。
输入：
Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 121  | US      | approved | 1000   | 2018-12-18 |
| 122  | US      | declined | 2000   | 2018-12-19 |
| 123  | US      | approved | 2000   | 2019-01-01 |
| 124  | DE      | approved | 2000   | 2019-01-07 |
+------+---------+----------+--------+------------+
输出：
+----------+---------+-------------+----------------+--------------------+-----------------------+
| month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
+----------+---------+-------------+----------------+--------------------+-----------------------+
| 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
+----------+---------+-------------+----------------+--------------------+-----------------------+
集体思路：计算，没什么好说的，关键点是把trans_date转成mouth，方法select DATE_FORMAT(trans_date, '%Y-%m') AS month,
select DATE_FORMAT(trans_date, '%Y-%m') AS month,
a.country,count(a.state) as trans_count,
sum(if(state="approved",1,0)) as approved_count,
sum(amount) as trans_total_amount,
sum(if(state="approved",amount,0)) as approved_total_amount
from Transactions a group by month,country