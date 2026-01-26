use sistema_biblioteca;

## Subconsultas

SELECT nombre, apellido, email 
FROM Usuario 
WHERE id_usuario IN (
    SELECT id_usuario 
    FROM Prestamo 
    WHERE estado = 'Retrasado'
);

SELECT titulo, total 
FROM (
    SELECT id_libro, COUNT(*) AS total 
    FROM Ejemplar 
    GROUP BY id_libro
) AS ConteoEjemplares
JOIN Libro ON Libro.id_libro = ConteoEjemplares.id_libro
WHERE total > 3;
