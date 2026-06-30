select stu_name,stu_birth from tb_student 
where stu_sex = 0
      or stu_addr = '四川成都';

-- 查询学分大于2的课程的名称和学分（数据筛选）
select cou_name,cou_credit from tb_course
where cou_credit > 2;

-- 查询学分是奇数的课程的名称和学分（数据筛选）
-- Query the names and credits of courses with an odd number of credits(data filtering)
select cou_name,cou_credit
from tb_course
where cou_credit MOD 2 <> 0;

-- 查询选择选了1111的课程考试成绩在90分以上的学生学号（数据筛选）
-- Query the student IDs of students who selected course 1111 and scored above 90 in the exam (data filtering)
select stu_id 
from tb_record
where cou_id = 1111
and score > 90;


-- 查询名字叫“杨过”的学生的姓名和性别（数据筛选）
-- Query the names and genders of students named "YangGuo"(data filtering)
select stu_name,if(stu_sex,'男','女') as 性别
from tb_student
where stu_name = "杨过";

-- 查询名字中有“不”字或“嫣”字的学生的学号和姓名（模糊匹配和并集运算）
-- Query the student IDs and names of students whose names contain the character "Bu" or "Yan" (fuzzy matching and union operation)
select stu_id,stu_name 
from tb_student
where stu_name like "%不%"
or stu_name like "%嫣%";

-- 查询没有录入籍贯的学生姓名（空值处理）
-- Query the names of students whose native place information has not been entered (null value handling)
select stu_name 
from tb_student
where stu_addr is null
or TRIM(stu_addr) = '' ;


-- 查询学生选课的所有日期（去重）
-- Query all distinct dates when students selected courses
select DISTINCT sel_date
from tb_record;

-- 查询学生的籍贯（去重）
-- Query student's native places(distinct)
select DISTINCT stu_addr 
from tb_student
where stu_addr is not NULL
or TRIM(stu_addr) = '';

-- 查询男学生的姓名和生日按年龄从大到小排序（排序）
-- Query the names and birthdays of male students sorted by age in descending order (sorting)
select stu_name as '姓名', stu_birth as '生日' from tb_student
where  stu_sex = 1
ORDER BY stu_birth DESC;

-- 补充：将上面的生日转换成年龄（日期函数 、数值函数）
-- Supplement:Convert the above birthdays to ages (date functions, numeric functions)
select stu_name as 姓名,FLOOR(DATEDIFF(CURDATE(),stu_birth)/365) as 年龄
from tb_student
where stu_sex = 1
ORDER BY 年龄 DESC;

-- 查询年龄最大的学生的出生日期（聚合函数）
-- Query the birth data of the oldest student(aggregate function)
select MIN(stu_birth) from tb_student;

-- 查询年龄最小的学生的出生日期（聚合函数）
-- Query the birth data of the youngest student(aggregate function)
select max(stu_birth) from tb_student;

-- 查询编号为1111的课程考试成绩的最高分（聚合函数）
-- Query the highest exam score of the course with ID 1111(aggregate function)
select MAX(score) from tb_record
where cou_id = '1111'
 
-- 查询学号为1001的学生考试成绩的最低分、最高分、平均分、标准差、方差（聚合函数）
-- Query the minimum score, maximum score, average score, standard deviation and variance of exam scores for the student with student ID 1001(aggregate functions)
select MIN(score) as 最低分,
			 MAX(score) as 最高分,
			 ROUND(AVG(score),1) as 平均分,
			 STDDEV(score) as 标准差,
			 VARIANCE(score) as 方差
	 from tb_record
	 where stu_id = 1001;
	 
 -- 查询学号为1001的学生考试成绩的平均分，如果有null值算0分（聚合函数）
 -- Query the average exam score of the student with student ID 1001, and treat null values as 0 points(aggregate function)
 select ROUND(SUM(score)/COUNT(*),1)  as 平均分
 from tb_record
 where stu_id = 1001;
 
 select ROUND(AVG(IFNULL(score,0)),1)  as 平均分
 from tb_record
 where stu_id = 1001;
 
 -- 查询男女学生的人数（分组和聚合函数）
 -- Query the number of male and female students(GROUP BY and aggregate functions)
 select case stu_sex when 1 then '男' else '女' end as 性别,
 count(*) as 人数
 from tb_student
 GROUP BY stu_sex;
 
 -- 查询每个学院学生人数（分组和聚合函数）
 -- Query the number of students in each college(GROUP BY and aggregate functions)
 select col_id, case col_id when 1 then '计算机学院' 
 when 2 then '外国语学院' 
when 3 then '经济管理学院'	
else '其他学院' end as 学院,
				COUNT(*) as 人数
 from tb_student
 GROUP BY col_id;
 
 -- 查询每个学院男女学生人数（分组和聚合函数）
 -- Query the number of male and female students in each college(GROUP BY and aggregate functions)
 
 select case col_id when 1 then '计算机学院'
 when 2 then '外国语学院'
 when 3 then '经济管理学院'
 else '其他学院' end as '学院名称',
 case stu_sex when 1 then '男'
 else '女' end as '性别',
 count(*)  as '人数'
 from tb_student
 GROUP BY col_id,stu_sex;
 
 
 SELECT
  CASE col_id
    WHEN 1 THEN '计算机学院'
    WHEN 2 THEN '外国语学院'
    WHEN 3 THEN '经济管理学院'
    ELSE '其他学院'
  END AS 学院名称,
  -- 统计男生数量：stu_sex=1 记1，否则0求和
  SUM(CASE WHEN stu_sex = 1 THEN 1 ELSE 0 END) AS 男生人数,
  -- 统计女生数量：stu_sex≠1 记1，否则0求和
  SUM(CASE WHEN stu_sex = 0 THEN 1 ELSE 0 END) AS 女生人数
FROM tb_student
GROUP BY col_id;

-- 查询每个学生的学号和平均成绩（分组和聚合函数）
-- Query each student's student ID and average score(GROUP BY and aggregate)
select stu_id as '学号',AVG(score) as '平均成绩'
from tb_record
GROUP BY stu_id;

-- 查询平均成绩大于等于90分的学生的学号和平均成绩（分组后的数据筛选）
-- Query the student ID and average score of students whose average score is greater than or equal to 90 points(data filtering after grouping)
select stu_id as '学号',ROUND(AVG(score),1) as '平均成绩'
from tb_record
GROUP BY stu_id
HAVING 平均成绩 >= 90;

-- 查询1111、2222、3333三门课程平均成绩大于等于90分的学生的学号和平均成绩（分组前后的数据筛选）
-- Query the student IDs and average scores of students whose average scores of the three courses 1111,2222 and 3333 are greater than or equal to 90(data filtering before and after grouping)
select stu_id as 学号, ROUND(AVG(score),1) as 平均成绩
from tb_record 
where cou_id in (1111,2222,3333)
GROUP BY stu_id
HAVING 平均成绩 >= 90
ORDER BY 平均成绩  ASC;

-- 查询年龄最大的学生的姓名（子查询）
-- Query the name of the student with the maximum age (subquery)
select stu_name FROM tb_student WHERE stu_birth = (select MIN(stu_birth) from tb_student);


-- 查询选了两门以上的课程的学生姓名（子查询和集合运算）
-- Query the names of students who have selected more than two courses(subqueries and set operations)
select stu_name from tb_student
where stu_id in (SELECT stu_id from tb_record GROUP BY stu_id HAVING COUNT(*) > 2);

-- 查询学生的姓名、生日和所在学院名称（表连接）
-- Query students' names, birthdays and college names(table join)
select stu_name, stu_birth, col_name
from tb_student as t1, tb_college as t2
where t1.col_id = t2.col_id;

select stu_name, stu_birth, col_name
from tb_student INNER JOIN tb_college
on tb_student.col_id = tb_college.col_id;

select stu_name, stu_birth, col_name
from tb_student NATURAL JOIN tb_college;

SELECT stu_name,
       stu_birth,
	   col_name
  FROM tb_student CROSS JOIN tb_college;
	

-- 查询学生姓名、课程名称以及成绩（表连接）
-- Query student names, course names and scores(table join)
select stu_name,cou_name,score
from tb_student, tb_course,tb_record
where tb_student.stu_id = tb_record.stu_id
and tb_course.cou_id = tb_record.cou_id
and score is not null;

select stu_name,cou_name,score
from tb_student inner JOIN tb_record
on tb_student.stu_id = tb_record.stu_id
inner join tb_course on tb_course.cou_id = tb_record.cou_id

where score is not null;


-- 补充：上面的查询结果取前5条数据（分页查询）
-- supplement:Take the first 5 entries from the above query results(paged query)

select stu_name,cou_name,score
from tb_student inner join tb_record
on tb_student.stu_id = tb_record.stu_id
INNER join tb_course
on tb_record.cou_id = tb_course.cou_id
where score is not NULL
order by tb_course.cou_id asc,score DESC
LIMIT 5;

SELECT stu_name,
       cou_name,
       score
  FROM tb_student 
	   NATURAL JOIN tb_record
       NATURAL JOIN tb_course
 WHERE score is not null
 ORDER BY cou_id ASC, score DESC
 LIMIT 5;

-- 补充：上面的查询结果取第6-10条数据（分页查询）
-- supplement:Extract the 6th to 10th pieces of data from the above query results(paged query)
SELECT stu_name,
       cou_name,
       score
  FROM tb_student 
	   NATURAL JOIN tb_record
       NATURAL JOIN tb_course
 WHERE score is not null
 ORDER BY cou_id ASC, score DESC
 LIMIT 5
 offset 5;
 
 -- 补充：上面的查询结果取第11-15条数据（分页查询）
 -- Supplement: Extract the 11th to 15th entries from the above query results (paged query)
 SELECT stu_name,
       cou_name,
       score
  FROM tb_student 
	   NATURAL JOIN tb_record
       NATURAL JOIN tb_course
 WHERE score is not null
 ORDER BY cou_id ASC, score DESC
 LIMIT 10,5;
 
 -- 查询选课学生的姓名和平均成绩（子查询和表连接）
 -- Quey the names and averages scores of students who selected courses(subqueries and joins)
 