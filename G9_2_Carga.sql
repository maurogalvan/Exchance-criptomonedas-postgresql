
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


--------------------------MONEDAS--------------------------------------

------------------------MONEDAS FIAT---------------------------------

--Ingreso de Moneda Fiat Dolar
insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
('USD', 'Dolar', 'Dolar estadounidense','20/10/2020' , 1,1);
--Ingreso de Moneda Fiat Euro
insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
('EUR', 'Euro', 'Euro', '20/10/2020', 1,1);
--Ingreso de Moneda Fiat Yen
insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
('JPY', 'Yen', 'Yen japones', '20/10/2020', 1,1);
insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
('GBP', 'Libra esterlina', 'moneda del reino unico', '20/10/2020', 1,1);
insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
('AUD', 'Dolar Australiano', 'moneda del australia', '20/10/2020', 1,1);

--------------------------MONEDA ESTABLE--------------------------------
insert into g9_moneda(moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('USDT', 'Tether', 'USDT is a stablecoin (stable-value cryptocurrency) that mirrors the price of the U.S. dollar,',
     '21/10/2020', 1 , 0);

insert into g9_moneda(moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('USDC', 'USD Coin', 'USD Coin (known by its ticker USDC) is a stablecoin that is pegged to the U.S. dollar on a 1:1 ' ||
                         'basis.', '21/10/2020', 1 , 0);

insert into g9_moneda(moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('Dai', 'DAI', 'Dai price today is $1.01 USD with a 24-hour trading volume of $119,134,185 USD.' , '21/10/2020', 1 , 0);

insert into g9_moneda(moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('BUSD', 'Binance USD', 'Binance USD price today is $1.00 USD with a 24-hour trading volume of $640,919,409 USD.' ,
     '21/10/2020', 1 , 0);

insert into g9_moneda(moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('PAX', 'Paxos Standard ', 'Paxos Standard price today is $1.00 USD with a 24-hour trading volume of $139,489,741 USD.' ||
                               ' Paxos Standard is up 0.26% in the last 24 hours.' , '21/10/2020', 1 , 0)

------------------------- CRIPTOMONEDAS -----------------------
insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('BTC', 'Bitcoin', 'Bitcoin is a decentralized cryptocurrency originally described in a 2008',
     '06/08/2008', 1, 0);

insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('ETH', 'Ethereum', 'Ethereum is a decentralized open-source blockchain system', '03/05/2010', 1, 0);

insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('XRP', 'XRP', 'XRP is the currency that runs on a digital payment platform called RippleNet, ' ||
                   'which is on top of a distributed ledger database called XRP Ledger', '01/07/2016', 1, 0);

insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('TRX', 'TRON', 'TRON is a blockchain-based operating system that aims to ensure this ' ||
                    'technology is suitable for daily use', '03/09/2018', 1, 0);

insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('WAVES', 'Waves', 'Waves describes itself as an open network for Web 3.0 applications ' ||
                       'and custom decentralized solutions', '10/12/2011', 1, 0);

insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('XTZ', 'Tezos', 'Tezos is a blockchain network that’s based on smart contracts', '12/12/2017', 1, 0);

insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('ATOM', 'Cosmos', 'Cosmos bills itself as a project that solves some of the “hardest ' ||
                       'problems” facing the blockchain industry', '04/05/2011', 1, 0);

insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('BCH', 'Bitcon Cash', 'Criptomoneda', '12/12/2017', 1, 0);

insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('LINK', 'Chainlink', 'Criptomoneda', '12/12/2020', 1, 0);

insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('BNB', 'Binance Coin', 'Criptomoneda', '12/12/2020', 1, 0);

insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('DOT', 'Polkadot', 'Criptomoneda', '12/12/2020', 1, 0);

insert into g9_moneda (moneda, nombre, descripcion, alta, estado, fiat) VALUES
    ('LTC', 'Litecoin', 'Criptomoneda', '12/12/2020', 1, 0);

---------------------------MERCADO------------------------------

--Crear un mercado de cada moneda contra las estables


