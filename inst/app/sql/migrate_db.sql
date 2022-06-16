--1. Copy in games

INSERT INTO snappa.games (start_time, end_time, in_progress, arena) (

select to_timestamp(game_start, 'YYYY-MM-DD hh24:mi:ss') as start_time, to_timestamp(game_end, 'YYYY-MM-DD hh24:mi:ss') as game_end, false as in_progress, 'Test Universe' as arena from game_stats
ORDER BY game_id
)

-- 2. Copy players
INSERT INTO snappa.players (name) (
	SELECT player_name FROM players
)
-- TODO: Create teams from distinct pairs of player stats teams

-- 3. Copy scores
INSERT INTO snappa.scores (game, player, shot, points, paddle, clink, foot, head, linked) (
	select new_game_id, player_id, 1 as shot, points_scored, paddle, clink, foot, COALESCE(head, false), false as linked from scores
LEFT JOIN (SELECT game_id, ROW_NUMBER() OVER (ORDER BY game_id) AS new_game_id FROM game_stats) AS new_game_ids
USING (game_id)
ORDER BY game_id, score_id
	
	
)