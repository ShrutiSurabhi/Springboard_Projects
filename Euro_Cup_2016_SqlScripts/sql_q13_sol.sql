/***** 13. Write a SQL query to find all the defenders who scored a goal for their teams. *****/SELECT player_name FROM goal_details gdJOIN player_mast pmON gd.player_id = pm.player_idWHERE posi_to_play = 'DF'GROUP BY player_name;