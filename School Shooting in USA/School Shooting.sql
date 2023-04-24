------------------------------------------------------  
-- School Shooting - if..null
------------------------------------------------------
IF OBJECT_ID('dbo.School_Shooting', 'U') IS NOT NULL DROP TABLE dbo.School_Shooting
IF OBJECT_ID('dbo.School_Shooting_loc', 'U') IS NOT NULL DROP TABLE dbo.School_Shooting_loc
IF OBJECT_ID('dbo.School_Shooting_situation', 'U') IS NOT NULL DROP TABLE dbo.School_Shooting_situation
GO     


------------------------------------------------------
-- School Shooting - Create tables -Start 
------------------------------------------------------   


------------------------------------------------------  
-- School Shooting - total 
------------------------------------------------------

    
CREATE TABLE School_Shooting
("Start School Year" int , "End School Year" int ,"casualties from shootings- Total" int ,
 "casualties from shootings-Deaths" int ,"casualties from shootings- Injuries" int,
  "school shootings, by type of casualty- Total" int , "school shootings, by type of casualty- Number with deaths" int , 
  "school shootings, by type of casualty- Number with injuries only" int,
  "school shootings, by type of casualty- number with no casualties" int ,
  "schools with shootings, by level of school - Elementary schools" int,
  "schools with shootings, by level of school- Middle or junior high schools" int,
  "schools with shootings, by level of school - High schools or other schools ending in grade" int,
  "schools with shootings, by level of school- Other" int )    
GO  

BULK INSERT School_Shooting
FROM 'C:\Users\user\Desktop\Data_Analysis\Projects\Data-analysis-projects-\Shooting un USA\School Shooting\Raw Data\school shooting.csv'
WITH (FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR='\n',
    BATCHSIZE=250000);	
/*
SELECT *
FROM School_Shooting
*/



------------------------------------------------------  
-- School Shooting - location 
------------------------------------------------------

    
CREATE TABLE School_Shooting_loc
("Start School Year" int , "End School Year" int ,"Classroom" int , "Hallway" int ,"Elsewhere inside the school building" int,
  "Beside or in front of school building" int , " Play-ground" int , "Football field, basketball court, or general field" int,
  "Parking lot" int , "Off school property" int,"School bus" int,  "Other" int, "Morning classes" int , "After-noon classes" int,"Lunch" int,
   " After/before school, dismissal" int,"School/sport event" int,"Outside school hours/ unknown" int , "Total" int)    
GO  

BULK INSERT School_Shooting_loc
FROM 'C:\Users\user\Desktop\Data_Analysis\Projects\Data-analysis-projects-\Shooting un USA\School Shooting\Raw Data\school shooting-by location.csv'
WITH (FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR='\n',
    BATCHSIZE=250000);	
/*
SELECT *
FROM School_Shooting_loc
*/

------------------------------------------------------  
-- School Shooting - situation associated
------------------------------------------------------

    
CREATE TABLE School_Shooting_situation
("Start School Year" int , "End School Year" int ,"Escalation of dispute" int,"Accidental" int , "Suicide or attempted suicide" int ,
 "Domestic, with targeted victim" int, "Indiscrim- inate shooting" int , "Anger over grades/ suspension/ discipline" int ,
  "Murder/ suicide" int, "Bullying" int , "Psychosis" int,"Hostage standoff" int,  "Intentional property damage" int,
   "Self-defense" int , "Drive-by" int,"Illegal activity" int, "Unknown" int, "Total" int )    
GO  

BULK INSERT School_Shooting_situation
FROM 'C:\Users\user\Desktop\Data_Analysis\Projects\Data-analysis-projects-\Shooting un USA\School Shooting\Raw Data\school shooting-situation associated.csv'
WITH (FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR='\n',
    BATCHSIZE=250000);	
/*
SELECT *
FROM School_Shooting_situation
*/

------------------------------------------------------  
-- School Shooting - Q1- from 2000 - 2012 what was the percentage of shooting over grades/suspension/ discipline 
------------------------------------------------------   
/*
SELECT  ROUND(CAST(SUM([Anger over grades/ suspension/ discipline]) AS FLOAT) / CAST(SUM(Total) AS FLOAT) * 100,2) AS '% of Anger over grades/ suspension/ discipline '
FROM School_Shooting_situation
WHERE [Start School Year] < 2013
*/
------------------------------------------------------  
-- School Shooting - Q2- where is the safetest location at the school 
------------------------------------------------------   
  -- the answer in the panadas

------------------------------------------------------  
-- School Shooting - Q3-  from all over the years that the ratio of Injuries casualties are above  the  avg  which top 3  years has highest ratio in morning 
------------------------------------------------------   

;WITH "Injuries cte"  AS 
(
SELECT [Start School Year]
       ,ROUND (CAST([casualties from shootings- Injuries] AS FLOAT) / CAST([casualties from shootings- Total] AS FLOAT ) *100 ,2) AS 'Ratio of Injuries' 
FROM  School_Shooting
), "avg-Injuries-cte" AS 
(
SELECT  ROUND(AVG([Ratio of Injuries]),2) AS 'AVG  of Ratio of Injuries'
FROM "Injuries cte"
), "above the avg cte" AS
(
SELECT *
FROM "Injuries cte" 
WHERE [Ratio of Injuries] > (SELECT * FROM "avg-Injuries-cte")
)
SELECT TOP 3 [Start School Year],[ RATIO shouting morning] 
FROM (
SELECT aavg.[Start School Year],SSLOC.[Morning classes],SSLOC.Total,
ROUND(CAST(SSLOC.[Morning classes] AS float)/CAST(SSLOC.Total AS float) *100,2) ' RATIO shouting morning'
FROM "above the avg cte" AS aavg JOIN  School_Shooting_loc AS SSLOC
ON aavg.[Start School Year] = SSLOC.[Start School Year]
) AS tbl1
ORDER BY  [ RATIO shouting morning] DESC

