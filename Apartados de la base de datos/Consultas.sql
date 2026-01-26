use sistema_biblioteca;

###CONSULTAS

###Libros actualemnte prestados con datos del usuario

SELECT 
    u.nombre,
    u.apellido,
    l.titulo,
    e.codigo_barra,
    p.fecha_prestamo,
    p.fecha_devolucion_estimada
FROM Prestamo p
JOIN Usuario u ON p.id_usuario = u.id_usuario
JOIN Detalle_Prestamo dp ON p.id_prestamo = dp.id_prestamo
JOIN Ejemplar e ON dp.id_ejemplar = e.id_ejemplar
JOIN Libro l ON e.id_libro = l.id_libro
WHERE p.estado = 'Activo';

###Usuarios con préstamos retrasados

SELECT 
    u.nombre,
    u.apellido,
    u.dni,
    p.fecha_devolucion_estimada,
    DATEDIFF(CURDATE(), p.fecha_devolucion_estimada) AS dias_retraso
FROM Prestamo p
JOIN Usuario u ON p.id_usuario = u.id_usuario
WHERE p.estado = 'Activo'
AND p.fecha_devolucion_estimada < CURDATE();

###Libros más prestados

SELECT 
    l.titulo,
    COUNT(dp.id_ejemplar) AS veces_prestado
FROM Detalle_Prestamo dp
JOIN Ejemplar e ON dp.id_ejemplar = e.id_ejemplar
JOIN Libro l ON e.id_libro = l.id_libro
GROUP BY l.id_libro
ORDER BY veces_prestado DESC
LIMIT 5;

###Disponibilidad de libros por título

SELECT 
    l.titulo,
    SUM(CASE WHEN e.estado = 'Disponible' THEN 1 ELSE 0 END) AS disponibles,
    COUNT(e.id_ejemplar) AS total_ejemplares
FROM Libro l
JOIN Ejemplar e ON l.id_libro = e.id_libro
GROUP BY l.id_libro;

###Historial de préstamos de un usuario

SELECT 
    u.nombre,
    u.apellido,
    l.titulo,
    p.fecha_prestamo,
    p.fecha_devolucion_real,
    p.estado
FROM Usuario u
JOIN Prestamo p ON u.id_usuario = p.id_usuario
JOIN Detalle_Prestamo dp ON p.id_prestamo = dp.id_prestamo
JOIN Ejemplar e ON dp.id_ejemplar = e.id_ejemplar
JOIN Libro l ON e.id_libro = l.id_libro
WHERE u.id_usuario = 1;
