With Q1 as(
Select *, DATEPART(WEEK, DayID) as WeekArrival, DATEPART(YEAR, DayID) as YearArrival
From tTestTable2
Where IncomingType = 1 OR IncomingType = 2
),
Q2 as(
Select * , sum(Volume) over (Partition by WeekArrival, YearArrival Order by DayID Rows between UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING) as Summa From Q1
)

select WeekArrival, Floor((Volume/summa)*100) as ShareOfVolume From Q2
where IncomingType = 1 AND CntrID = 1 
Order by ArtID,DayID, ID