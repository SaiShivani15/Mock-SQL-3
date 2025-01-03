#Approach 1:
WITH CombinedScores AS (
    SELECT 
        p.group_id,
        m.first_player AS player_id,
        m.first_score AS score
    FROM Matches m
    JOIN Players p
    ON m.first_player = p.player_id

    UNION ALL

    SELECT 
        p.group_id,
        m.second_player AS player_id,
        m.second_score AS score
    FROM Matches m
    JOIN Players p
    ON m.second_player = p.player_id
), RankedScores AS (
    SELECT 
        group_id,
        player_id,
        RANK() OVER (PARTITION BY group_id ORDER BY SUM(score) DESC, player_id ASC) AS rnk
    FROM CombinedScores
    GROUP BY group_id, player_id
)
SELECT 
    group_id,
    player_id
FROM RankedScores
WHERE rnk = 1;


#Approach 2:
Select group_id, player_id (Select p.group_id, p.player_id, rank() over (partition by p.group_id order Sum( 
Case
When p.player_id=m.first_player then m.first_score
else m.second_score
END) Desc, player_id asc) as rnk from Players p Join Matches on p.player_id In(m.first_player, m.second_player) Group By p.group_id, p.player_id) as sub where rnk=1
