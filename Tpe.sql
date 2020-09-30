* Debe tener por lo menos 10 usuarios.
El Sitio debe manejar 20 monedas y al menos tiene que tener 3 monedas Fiat y 5 estables. Entre las monedas usar:
BTC, ETH  y las que Uds. quieran como criptomonedas.
USDT, DAI, USDC, DGX, Petro como monedas estables
Dólares, Euros y Yenes como monedas FIAT
Crear un mercado de cada moneda contra las estables
Crear un mercado de cada criptomoneda contra el BTC
Inicializar las órdenes con al menos 100 filas


----------------------Extras---------------------------
--Para que el date tome el aspecto de 'dd/mm/aaaa'
set datestyle to 'European';

------------------------PAIS-------------------------
--Ingreso del pais 100, nombre ARGENTINA
INSERT INTO g9_pais (id_pais, nombre, cod_telef)
             values (100, 'Argentina', 054);

--Ingreso del pais 101, nombre URUGUAY
INSERT INTO g9_pais (id_pais, nombre, cod_telef)
             values (101, 'Uruguay', 598);

--Ingreso del pais 102, nombre PARAGUAY
INSERT INTO g9_pais (id_pais, nombre, cod_telef)
             values (102, 'Paraguay', 595);
--Ingreso del pais 102, nombre CHILE
INSERT INTO g9_pais (id_pais, nombre, cod_telef)
             values (103, 'Chile', 56);

-----------------------USUARIO---------------------------------
--Ingreso de usuario 001, nombre y apellido MAURO GALVAN
insert into g9_usuario (id_usuario, apellido, nombre, fecha_alta, estado,email, password, telefono, id_pais)
                values (001, 'Galvan', 'Mauro', '28/09/1998', 'REEMPLAZAR','maurogalvanbalca@gmail.com', 'mgaEXA', 15494592, 100);
--Ingreso de usuario 002, nombre y apellido ALEJANDRO LAGAR
insert into g9_usuario (id_usuario, apellido, nombre, fecha_alta, estado,email, password, telefono, id_pais)
                values (002, 'Lagar', 'Alejandro', '20/04/2019', 'REEMPLAZAR','alelagar@gmail.com', 'aleEXA', 15436582, 100);
--Ingreso de usuario 003, nombre y apellido JUAN DITELLA
insert into g9_usuario (id_usuario, apellido, nombre, fecha_alta, estado,email, password, telefono, id_pais)
                values (003, 'Ditella', 'Juan', '02/06/2019', 'REEMPLAZAR','juanditella@gmail.com', 'juanEXA', 15727542, 100);
--Ingreso de usuario 004, nombre y apellido CAETANO RODRIGUEZ
insert into g9_usuario (id_usuario, apellido, nombre, fecha_alta, estado,email, password, telefono, id_pais)
                values (004, 'Rodriguez', 'Caetano', '08/07/2019', 'REEMPLAZAR','caetarod@gmail.com', 'caetaEXA', 15988262, 101);
--Ingreso de usuario 005, nombre y apellido TANIA PEREZ
insert into g9_usuario (id_usuario, apellido, nombre, fecha_alta, estado,email, password, telefono, id_pais)
                values (005, 'Perez', 'Tania', '15/09/2019', 'REEMPLAZAR','taniap@gmail.com', 'taniaEXA', 15342524, 102);
--Ingreso de usuario 006, nombre y apellido PEDRO TORRES
insert into g9_usuario (id_usuario, apellido, nombre, fecha_alta, estado,email, password, telefono, id_pais)
                values (006, 'Torres', 'Pedro', '20/09/2019', 'REEMPLAZAR','pedrotorr@gmail.com', 'pedroEXA', 15200851, 103);
--Ingreso de usuario 007, nombre y apellido JULIANA GUZMAN
insert into g9_usuario (id_usuario, apellido, nombre, fecha_alta, estado,email, password, telefono, id_pais)
                values (007, 'Juliana', 'Guzman', '28/10/2019', 'REEMPLAZAR','juliaguz@gmail.com', 'jusEXA', 15943735, 102);
--Ingreso de usuario 008, nombre y apellido FLORENCIA SCIOLI
insert into g9_usuario (id_usuario, apellido, nombre, fecha_alta, estado,email, password, telefono, id_pais)
                values (008, 'Florencia', 'Scioli', '31/10/2019', 'REEMPLAZAR','florscioli@gmail.com', 'flosEXA', 15947818, 102);
--Ingreso de usuario 009, nombre y apellido JORDANA GENOVA
insert into g9_usuario (id_usuario, apellido, nombre, fecha_alta, estado,email, password, telefono, id_pais)
                values (009, 'Jordana', 'Genova', '02/11/2019', 'REEMPLAZAR','jorg@gmail.com', 'jordg', 15596595, 101);
--Ingreso de usuario 010, nombre y apellido ANTONELA NAVARRO
insert into g9_usuario (id_usuario, apellido, nombre, fecha_alta, estado,email, password, telefono, id_pais)
                values (010, 'Antonela', 'Navarro', '06/12/2019', 'REEMPLAZAR','antonavar@gmail.com', 'qwer1', 15309226, 103);





select *
from g9_usuario u

SELECT *
FROM g9_pais