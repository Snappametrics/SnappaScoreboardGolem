CREATE SCHEMA snappa

    CREATE TABLE games(
        id SERIAL PRIMARY KEY, 
        start_time timestamp with time zone NOT NULL, 
        end_time timestamp with time zone,
        rounds integer,
        in_progress boolean NOT NULL,
        arena varchar(69) NOT NULL,
        metadata json,
        ruleset json
    )
    
    CREATE TABLE players(
        id SERIAL PRIMARY KEY, 
        name varchar(69) NOT NULL,
        height_in integer,
        weight_lbs integer,
        dob date,
        handedness varchar(20),
        main_id integer REFERENCES players,
        
        CONSTRAINT name_unique UNIQUE (name),
        CONSTRAINT reasonable_height CHECK (height_in > 24 AND height_in < 97),
        CONSTRAINT reasonable_weight CHECK (weight_lbs > 30 AND weight_lbs < 500),
        CONSTRAINT reasonable_dob CHECK (date_part('year', AGE(dob)) < 120)
    )
    
    CREATE TABLE teams(
        id SERIAL PRIMARY KEY, 
        name varchar(50),
        home_primary varchar(10),
        home_secondary varchar(10),
        away_primary varchar(10),
        away_secondary varchar(10)
        
    )
    
    CREATE TABLE team_players(
        id SERIAL, 
        player integer REFERENCES players,
        
        PRIMARY KEY (id, player),
        FOREIGN KEY (id) REFERENCES teams
    )
    
    CREATE TABLE game_teams(
        game integer REFERENCES games ON DELETE CASCADE, 
        team integer REFERENCES teams, 
        side varchar(1) NOT NULL,
        
        PRIMARY KEY (game, team)
    )
    
    CREATE TABLE scores(
        game integer REFERENCES games ON DELETE CASCADE,
        id SERIAL, 
        player integer NOT NULL REFERENCES players, 
        shot integer NOT NULL, 
        points integer NOT NULL, 
        paddle boolean NOT NULL, 
        clink boolean NOT NULL, 
        foot boolean NOT NULL, 
        head boolean NOT NULL, 
        linked boolean NOT NULL,
        
        CONSTRAINT score_key PRIMARY KEY (game, id)
    )
    
    CREATE TABLE assists(
        game integer,
        id SERIAL, 
        player integer NOT NULL REFERENCES players, 
        score integer, 
        paddle boolean NOT NULL, 
        foot boolean NOT NULL,
        head boolean NOT NULL,
        
        FOREIGN KEY (game, id) REFERENCES scores (game, id) ON DELETE CASCADE
    )
    
    CREATE TABLE catches(
        game integer REFERENCES games ON DELETE CASCADE,
        id SERIAL, 
        round integer NOT NULL,
        catcher integer NOT NULL REFERENCES players, 
        catches integer NOT NULL,
        
        CONSTRAINT catch_key PRIMARY KEY (game, id)
    )
    
    CREATE TABLE casualties(
        game integer REFERENCES games ON DELETE CASCADE,
        id SERIAL, 
        victim integer REFERENCES players, 
        offender integer REFERENCES players, 
        score integer,
        round integer,
        type varchar(20) NOT NULL,
        
        PRIMARY KEY (game, id, victim),
		    FOREIGN KEY (game, score) REFERENCES scores (game, id)
    )
    
    