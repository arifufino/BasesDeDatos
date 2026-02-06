
##CIFRADO DE CONTRASEÑAS
alter table usuario
add password_hash varchar(256);
#INSERTAR CONTRASEÑA CIFRADA
update usuario
set password_hash = sha2('clave_segura123', 256)
where id_usuario = 1;
#validación de login
select id_usuario
from usuario
where email = 'juan.perez@mail.com'
and password_hash = sha2('clave_segura123', 256);
