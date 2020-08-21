With Q1 as(
Select *,
case when isnull(DATEDIFF(d, lag(DayID) over (Partition by ArtID Order by DayID), DayID), 0 )<>1 Then 0 Else 1 End as PrevDay
From tTestTable1
)

Select DayID,ArtID,CntrID, EndQnty, 
(case when PrevDay <> 0 then Sum(PrevDay) over (Partition by ArtID, PrevDay Order by DayID Rows between UNBOUNDED PRECEDING and CURRENT ROW) Else 0 end)+1 as PrevDaySequence
From Q1
Order by ArtID,DayID, ID