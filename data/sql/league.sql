CREATE TABLE IF NOT EXISTS league  ( 
	sLeagueID	varchar(32) NOT NULL,
	sName    	longtext NULL,
	sKey     	varchar(20) NULL,
	bActive  	int(11) NULL,
	PRIMARY KEY(sLeagueID)
)

insert into league (sLeagueID, sName, sKey, bActive )
values ('C898E8A7BF7D0F9875845AF3AD01A0FE', 'Pickem', 'pickem', 1 ),
('C89C3370A58C1E6B62588C46C647CFC6', 'NFL Underdog', 'nflUnderdog', 1 ),
('C89DE23DE0BE12F927789325F2AB9672', 'NFL Perfect Challenge', 'nflPerfect', 1 )