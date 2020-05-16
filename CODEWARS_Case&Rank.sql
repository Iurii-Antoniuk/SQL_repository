SELECT SUM(points) AS total_points, COUNT(name) AS total_people,
CASE
  WHEN clan = '' THEN '[no clan specified]'
  ELSE clan END
AS clan,
RANK () OVER (
ORDER BY SUM(points) DESC
) "rank"
FROM people
GROUP BY clan