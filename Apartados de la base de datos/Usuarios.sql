use sistema_biblioteca;

CREATE USER 'admin_biblio'@'localhost' IDENTIFIED BY '12345';
GRANT ALL PRIVILEGES ON Sistema_Biblioteca.* TO 'admin_biblio'@'localhost';

CREATE USER 'bibliotecario_1'@'localhost' IDENTIFIED BY '12345';
GRANT SELECT, INSERT, UPDATE ON Sistema_Biblioteca.* TO 'bibliotecario_1'@'localhost';

CREATE USER 'lector_consulta'@'localhost' IDENTIFIED BY '12345';
GRANT SELECT ON Sistema_Biblioteca.Libro TO 'lector_consulta'@'localhost';
GRANT SELECT ON Sistema_Biblioteca.Vista_Catalogo_Completo TO 'lector_consulta'@'localhost';


DROP USER 'admin_biblio'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'admin_biblio'@'localhost';

DROP USER 'bibliotecario_1'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'bibliotecario_1'@'localhost';

DROP USER 'lector_consulta'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'lector_consulta'@'localhost';