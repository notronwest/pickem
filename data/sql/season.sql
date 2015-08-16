
SELECT * FROM season
GO

select distinct sSeason from standing

update standing set nSeasonID = 1 where sSeason = '2014-2015'

update week set nSeasonID = 1 where sSeason = '2014-2015'

insert into season (sName, dtStart, dtEnd) values('2015-2016', '2015-08-01', '2015-02-28')
insert into season (sName, dtStart, dtEnd) values('2014-2015', '2014-08-23', '2015-02-01')