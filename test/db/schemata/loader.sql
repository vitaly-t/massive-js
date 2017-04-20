CREATE SCHEMA public;

CREATE TABLE t1 (id serial PRIMARY KEY);
CREATE TABLE t2 (id serial PRIMARY KEY);
CREATE TABLE t3 (id int);
CREATE TABLE "tA" (id serial PRIMARY KEY);

CREATE VIEW v1 AS SELECT * FROM t1;
CREATE VIEW v2 AS SELECT * FROM t2;

CREATE MATERIALIZED VIEW mv1 AS SELECT * FROM t1;
CREATE MATERIALIZED VIEW mv2 AS SELECT * FROM t2;

CREATE OR REPLACE FUNCTION f1() RETURNS int AS $$ SELECT * FROM t1 $$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION f2() RETURNS int AS $$ SELECT * FROM t2 $$ LANGUAGE SQL;

CREATE SCHEMA one;

CREATE TABLE one.t1 (id serial PRIMARY KEY);
CREATE TABLE one.t2 (id serial PRIMARY KEY);

CREATE VIEW one.v1 AS SELECT * FROM one.t1;
CREATE VIEW one.v2 AS SELECT * FROM one.t2;

CREATE OR REPLACE FUNCTION one.f1() RETURNS int AS $$ SELECT * FROM one.t1 $$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION one.f2() RETURNS int AS $$ SELECT * FROM one.t2 $$ LANGUAGE SQL;

CREATE SCHEMA two;

CREATE TABLE two.t1 (id serial PRIMARY KEY);

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER loopback FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'localhost', dbname 'massive', port '5432');

CREATE USER MAPPING FOR postgres
        SERVER loopback
        OPTIONS (user 'postgres');

CREATE FOREIGN TABLE foreigntable (id serial) SERVER loopback OPTIONS (schema_name 'public', table_name 't1');