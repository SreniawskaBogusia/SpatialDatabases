--ex2
create database bdp_lab2;
--ex3
create extension postgis;
--ex4
create table buildings( id integer not null primary key, geometry geometry, name varchar(100) );
create table roads( id integer not null primary key, geometry geometry, name varchar(100) );
create table poi( id integer not null primary key, geometry geometry, name varchar(100) );
--ex5
insert into buildings values(1, 'POLYGON((8 4, 8 1.5, 10 1.5, 10.5 4, 8 4))', 'BuildingA'),
							(2, 'POLYGON((4 7, 4 5, 6 5, 6.5 6, 4 7))', 'BuildingB'),
							(3, 'POLYGON((3 8, 3 6, 5 6, 5 8, 3 8))', 'BuildingC'),
							(4, 'POLYGON((9 9, 9 8, 10 8, 10 9, 9 9))', 'BuildingD'),
							(5, 'POLYGON((1 2, 1 1, 2 1, 2 2, 1 2))', 'BuildingF');

insert into roads values (1, 'LINESTRING(0 4.5, 12 4.5)', 'RoadX'),
                         (2, 'LINESTRING(7.5 0, 7.5 10.5)', 'RoadY');
                        
insert into poi values (1, 'POINT(1 3.5)', 'G'),
                       (2,'POINT(5.5 1.5)','H'),
                       (3,'POINT(9.5 6)','I'),
                       (4,'POINT(6.5 6)','J'),
                       (5,'POINT(6 9.5)','K');

--ex6a
select sum(ST_LENGTH(geometry)) from roads;
--ex6b
select st_astext(geometry), st_area(geometry), st_perimeter(geometry) from buildings where name='BuildingA';
--ex6c
select name, st_area(geometry) from buildings order by name;
--ex6d
select name, st_perimeter(geometry) from buildings order by st_perimeter(geometry) desc limit 2;
--ex6e
select st_distance(buildings.geometry, poi.geometry) from buildings, poi where poi.name = 'K' and buildings.name = 'BuildingC';
--ex6f
with B_B as (select geometry from buildings where name = 'BuildingB'),
     B_C as (select geometry from buildings where name = 'BuildingC')
select st_area(B_C.geometry) - st_area(st_intersection(st_buffer(B_B.geometry,0.5),B_C.geometry)) as res from B_B,B_C;
--ex6g
with ex6g as (select geometry from roads where name = 'RoadX')
select name from buildings,ex6g where st_y(st_centroid(buildings.geometry))>st_y(st_centroid(ex6g.geometry));
--ex6h
with B_C as (select geometry from buildings where name = 'BuildingC')
select st_area(B_C.geometry) + st_area(st_geomfromtext('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')) 
- 2 * st_area(st_intersection(B_C.geometry,st_geomfromtext('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) from B_C;


