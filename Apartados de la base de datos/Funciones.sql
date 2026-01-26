use sistema_biblioteca;

## Funciones

DELIMITER //

CREATE FUNCTION TotalLibrosPorCategoria(p_id_categoria INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total 
    FROM Libro 
    WHERE id_categoria = p_id_categoria;
    
    RETURN total;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION EjemplaresDisponibles(p_id_libro INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    
    SELECT COUNT(*) INTO cantidad 
    FROM Ejemplar 
    WHERE id_libro = p_id_libro AND estado = 'Disponible';
    
    RETURN cantidad;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION PromedioLibrosPorPrestamo() 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);
    
    SELECT AVG(conteo) INTO promedio FROM (
        SELECT COUNT(*) as conteo 
        FROM Detalle_Prestamo 
        GROUP BY id_prestamo
    ) AS subconsulta;
    
    RETURN promedio;
END //

DELIMITER ;

select TotalLibrosPorCategoria(1);
select EjemplaresDisponibles(1);
select PromedioLibrosPorPrestamo();

## Función cadena
DELIMITER //

CREATE FUNCTION NombreCompletoUsuario(p_id_usuario INT) 
RETURNS VARCHAR(201)
DETERMINISTIC
BEGIN
    DECLARE v_nombre_completo VARCHAR(201);
    
    SELECT CONCAT(nombre, ' ', apellido) INTO v_nombre_completo
    FROM Usuario
    WHERE id_usuario = p_id_usuario;
    
    RETURN v_nombre_completo;
END //

DELIMITER ;


DELIMITER //
CREATE FUNCTION obtener_usuario(p_id_usuario INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	DECLARE resultado VARCHAR(100);
    SELECT nombre
    INTO resultado
    FROM usuario
    WHERE id_usuario = p_id_usuario;
    
    RETURN resultado;
END//
DELIMITER ;

select obtener_usuario(3 or 2=2);