#Approach 1:
With cte as(
Select item_id, sellar_id, rank () over (Partition by sellar_id order by order_date) as “rnk” from Orders),
Acte as (Select cte.sellar_id, Items.item_brand from cte join items on cte.item_id=items.item_id where rnk=2)
Select Users.user_id as “sellar_id”, If(Users.favorite_brand=acte.item_brand,”yes”,”no”) as 2nd_item_fav_brand from users left join acte on users.user_id=acte.sellar_id;

#Approach 2:
WITH RankedOrders AS (
    SELECT 
        o.seller_id, 
        i.item_brand, 
        RANK() OVER (PARTITION BY o.seller_id ORDER BY o.order_date) AS rnk
    FROM Orders o
    JOIN Items i
    ON o.item_id = i.item_id
),
SecondSoldItems AS (
    SELECT 
        seller_id, 
        item_brand 
    FROM RankedOrders 
    WHERE rnk = 2
)
SELECT 
    u.user_id AS seller_id, 
    CASE 
        WHEN u.favorite_brand = s.item_brand THEN 'yes'
        ELSE 'no'
    END AS second_item_fav_brand
FROM Users u
LEFT JOIN SecondSoldItems s
ON u.user_id = s.seller_id;
