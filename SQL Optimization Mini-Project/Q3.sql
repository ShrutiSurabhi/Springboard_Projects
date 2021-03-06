use springboardopt;
SET @v1 = 1612521;
SET @v2 = 1145072;
SET @v3 = 1828467;
SET @v4 = 'MGT382';
SET @v5 = 'Amber Hill';
SET @v6 = 'MGT';
SET @v7 = 'EE';			  
SET @v8 = 'MAT';


-- 3. List the names of students who have taken course v4 (crsCode).
EXPLAIN ANALYZE
SELECT name FROM Student WHERE id IN (SELECT studId FROM Transcript WHERE crsCode = @v4);
/*
-> Inner hash join (student.id = `<subquery2>`.studId)  (actual time=0.171..0.331 rows=2 loops=1)
     -> Table scan on Student  (cost=5.04 rows=400) (actual time=0.007..0.175 rows=400 loops=1)
     -> Hash
         -> Table scan on <subquery2>  (actual time=0.000..0.001 rows=2 loops=1)
             -> Materialize with deduplication  (actual time=0.094..0.094 rows=2 loops=1)
                 -> Filter: (transcript.studId is not null)  (cost=10.25 rows=10) (actual time=0.050..0.087 rows=2 loops=1)
                     -> Filter: (transcript.crsCode = <cache>((@v4)))  (cost=10.25 rows=10) (actual time=0.049..0.086 rows=2 loops=1)
                         -> Table scan on Transcript  (cost=10.25 rows=100) (actual time=0.030..0.071 rows=100 loops=1)
 
*/
EXPLAIN ANALYZE
WITH cte AS
(SELECT studId FROM Transcript WHERE crsCode = @v4)
SELECT name
FROM Student, cte
WHERE Student.id = cte.studId;
/*
-> Nested loop inner join  (cost=17.50 rows=10) (actual time=0.058..0.101 rows=2 loops=1)
     -> Filter: ((transcript.crsCode = <cache>((@v4))) and (transcript.studId is not null))  (cost=10.25 rows=10) (actual time=0.042..0.082 rows=2 loops=1)
         -> Table scan on Transcript  (cost=10.25 rows=100) (actual time=0.023..0.066 rows=100 loops=1)
     -> Single-row index lookup on Student using PRIMARY (id=transcript.studId)  (cost=0.63 rows=1) (actual time=0.008..0.009 rows=1 loops=2)
*/
 /*
 Solution: Single-row index lookup on Student using PRIMARY (id=transcript.studId) 
 and Transcript.crsCode = @v4 
*/


EXPLAIN ANALYZE
SELECT name
FROM Student, Transcript
WHERE Student.id = Transcript.studId AND Transcript.crsCode = @v4 ;
/*
-> Nested loop inner join  (cost=21.25 rows=10) (actual time=0.059..0.087 rows=2 loops=1)
     -> Filter: (transcript.crsCode = <cache>((@v4)))  (cost=10.25 rows=10) (actual time=0.048..0.073 rows=2 loops=1)
         -> Index scan on Transcript using PRIMARY  (cost=10.25 rows=100) (actual time=0.036..0.058 rows=100 loops=1)
     -> Single-row index lookup on Student using PRIMARY (id=transcript.studId)  (cost=1.01 rows=1) (actual time=0.006..0.006 rows=1 loops=2)
 
*/
