use sistema_biblioteca;

## Vistas

CREATE VIEW Vista_Catalogo_Completo AS
SELECT 
    l.id_libro,
    l.titulo,
    CONCAT(a.nombre, ' ', a.apellido) AS autor,
    e.nombre AS editorial,
    c.nombre AS categoria,
    l.anio_publicacion
FROM Libro l
JOIN Editorial e ON l.id_editorial = e.id_editorial
JOIN Categoria c ON l.id_categoria = c.id_categoria
JOIN Libro_Autor la ON l.id_libro = la.id_libro
JOIN Autor a ON la.id_autor = a.id_autor;

CREATE VIEW Vista_Prestamos_Pendientes AS
SELECT 
    p.id_prestamo,
    u.nombre AS usuario,
    u.telefono,
    l.titulo AS libro,
    ej.codigo_barra,
    p.fecha_devolucion_estimada
FROM Prestamo p
JOIN Usuario u ON p.id_usuario = u.id_usuario
JOIN Detalle_Prestamo dp ON p.id_prestamo = dp.id_prestamo
JOIN Ejemplar ej ON dp.id_ejemplar = ej.id_ejemplar
JOIN Libro l ON ej.id_libro = l.id_libro
WHERE p.estado = 'Activo';

CREATE VIEW Vista_Usuarios_Segura AS
SELECT 
    nombre, 
    apellido, 
    CONCAT('****', RIGHT(dni, 4)) AS dni_protegido, 
    tipo_usuario 
FROM Usuario;