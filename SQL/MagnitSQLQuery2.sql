With Q1 as(
Select *,
case when isnull(DATEDIFF(d, lag(DayID) over (Partition by ArtID Order by DayID), DayID), 0 )<>1 Then 0 Else 1 End as PrevDay,
case when isnull(DATEDIFF(d, lag(DayID) over (Partition by ArtID Order by DayID), DayID), 0 )<>1 Then 1 Else 0 End as FlagStartSequence
From tTestTable1
),

Q2 as(
Select *, 
(case when PrevDay <> 0 then Sum(PrevDay) over (Partition by ArtID, PrevDay Order by DayID Rows between UNBOUNDED PRECEDING and CURRENT ROW) Else 0 end)+1 as PrevDaySequence,
sum(FlagStartSequence) over (Partition by ArtID Order by DayID Rows between UNBOUNDED PRECEDING and CURRENT ROW) as grp
From Q1
)

Select DayID,ArtID,CntrID, EndQnty, PrevDaySequence,
(EndQnty - min(EndQnty) over(Partition by ArtID, grp Order by DayID Rows between UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING)) as DifBalance
From Q2
Order by ArtID,DayID, ID