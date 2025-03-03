
select * from cricketdata;



## Copy data into another table
CREATE TABLE cricketDataStagged AS SELECT * FROM cricketdata;
SELECT * FROM cricketDataStagged;


## Basic Analizing
#1.  Total balls faced - Total Runs made for each batsman sorted Descending
SELECT batsmanName, SUM(balls) As totalBallsFaced, SUM(runs) AS totalRunsMade
FROM cricketdatastagged
GROUP BY batsmanName
ORDER BY totalRunsMade DESC;

#2 Best Average Strike Rate While being not Out
SELECT batsmanName, ROUND(AVG(SR), 2) AS Average_Strike_Rate FROM cricketdatastagged
WHERE `out/not_out` = 'not out'
GROUP BY batsmanName
ORDER BY Average_Strike_Rate DESC
;

#3 Choosing best Batsman -> Average Runs * Average Strike Rate
SELECT 
batsmanName, 
ROUND(AVG(SR), 3) as Average_strike_rate,
AVG(runs) as Average_runs,
ROUND(ROUND(AVG(SR), 3) * AVG(runs) , 3) as Better_Economy_Batsman
FROM cricketdatastagged
GROUP BY batsmanName
ORDER BY Better_Economy_Batsman desc
;

SELECT 
    batsmanName, 
    ROUND(AVG(SR), 3) AS Average_strike_rate,
    AVG(runs) AS Average_runs,
    ROUND(AVG(SR), 3) * AVG(runs) AS Better_Economy_Batsman
FROM cricketdatastagged
GROUP BY batsmanName
ORDER BY Better_Economy_Batsman DESC;



## intemediate analizing
select * from cricketdatastagged;

#1. Contributions based on position
SELECT 
CASE 
    WHEN battingPos between 1 and 4 then 'First Order' 
	WHEN battingPos between 5 and 7 then 'Middle Order'
    WHEN battingPos between 8 and 11 then 'Lower Order'
END as Batting_Order,
SUM(runs) as contribution_Runs, ROUND(AVG(SR) , 3) as Average_SR
from cricketdatastagged
group by Batting_Order;
 # -> Conclusion: First Order Batsman, Contributed more
 
 #2. For Every Boundary is hit, How much Runs a batsman makes
Select 
batsmanName, 
Sum(runs) as total_Runs,
sum(4s) as total_4s, 
sum(6s) as total_6s,
sum(4s) + sum(6s) as total_Boundary,
Sum(runs)/(sum(4s) + sum(6s)) as RunsPerBoundary,
CASE
    WHEN Sum(runs)/(sum(4s) + sum(6s)) < 7 THEN "Aggressive Batsman"
    WHEN Sum(runs)/(sum(4s) + sum(6s)) BETWEEN 7 AND 10 THEN "Hitting Batsman"
    WHEN Sum(runs)/(sum(4s) + sum(6s)) > 10 THEN "Defensive BATSMAN"
END AS Batsman_Profile

 from cricketdatastagged
 group by batsmanName;
 



## advance analyzing 
select * from cricketdatastagged;
# 1 Total Wins for a country Count
#1.a Which team won which match

select t1.Match_ID, t1.winning_score, t2.teamInnings from
(select Match_Id, max(team_total_runs) as winning_score from(
select teamInnings, Match_ID, sum(runs) as team_total_runs
from cricketdatastagged
group by teamInnings, Match_Id
order by Match_Id desc, teamInnings
) as match_summary
group by Match_ID) t1

join 
(
select teamInnings, Match_ID, sum(runs) as team_total_runs
from cricketdatastagged
group by teamInnings, Match_Id
order by Match_Id desc, teamInnings
)
 t2 on ((t1.Match_Id = t2.Match_Id) and (t1.winning_score = t2.team_total_runs))
 ;
 
 
 
 #1.b Which Team Won more matches
# we will use previous query ans table and add another query on top of that table just

;

select teamInnings as country, count(*) as winns
from
(

# previous table
select t1.Match_ID, t1.winning_score, t2.teamInnings from
(select Match_Id, max(team_total_runs) as winning_score from(
select teamInnings, Match_ID, sum(runs) as team_total_runs
from cricketdatastagged
group by teamInnings, Match_Id
order by Match_Id desc, teamInnings
) as match_summary
group by Match_ID) t1

join 
(
select teamInnings, Match_ID, sum(runs) as team_total_runs
from cricketdatastagged
group by teamInnings, Match_Id
order by Match_Id desc, teamInnings
)
 t2 on ((t1.Match_Id = t2.Match_Id) and (t1.winning_score = t2.team_total_runs))
 

) as Winns_Table

group by country
order by winns desc
;


