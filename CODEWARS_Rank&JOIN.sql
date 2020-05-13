SELECT p.id, p.name, slscnt.sale_count,
RANK () OVER (
ORDER BY slscnt.sale_count DESC
) sale_rank
FROM people p
JOIN (SELECT people_id, COUNT(sale) AS sale_count
            FROM sales
            GROUP BY people_id) AS slscnt
            ON p.id = slscnt.people_id