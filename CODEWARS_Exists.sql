SELECT id, name
FROM departments
WHERE EXISTS
(
  SELECT name
  FROM sales
  WHERE department_id = departments.id AND price > 98
)