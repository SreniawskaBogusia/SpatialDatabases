create database lab3;
create extension postgis;
--ex1
select * from t2019_kar_buildings tkb2019 
left join t2018_kar_buildings tkb2018 on tkb2019.geom = tkb2018.geom			
where tkb2018.gid is null;

--ex2
with new_poi as (select * from t2019_kar_poi_table as tkpt2019 
			left join t2018_kar_poi_table as tkpt2018 on tkpt2019.geom = tkpt2018.geom),
new_buildings as (select * from t2019_kar_buildings as tkb2019 
				left join t2018_kar_buildings as tkb2018 on tkb2019.geom = tkb2018.geom where tkb2018.gid is null)
select count(*) from new_poi, new_buildings where st_dwithin(new_poi.geom, new_buildings.geom) <=500 group by new_poi.type

--ex3
create table streets_reprojected(gid serial4 not null primary key, link_id float8, st_name varchar(254), ref_in_id float8,
	  			    nref_in_id float8, func_class varchar(1), speed_cat varchar(1), 
				    fr_speed_I float8, to_speed_I float8, dir_travel varchar(1), geom geometry);
				   
insert into streets_reprojected 
select gid, link_id, st_name, ref_in_id, nref_in_id, func_class, speed_cat, fr_speed_l, to_speed_l, dir_travel, st_transform(st_setsrid(geom,4326), 3068) 
from t2019_kar_streets;
select * from streets_reprojected

--ex4
create table input_points (id serial4 not null primary key, point_name varchar(254), geom geometry);
insert into input_points values (1,'p1','point(8.36093 49.03174)' ), 
								(2,'p2','point(8.39876 49.00644)' );
select * from input_points

--ex5
update input_points set geom = st_transform(st_setsrid(geom,4326),3068);
select * from input_points 

--ex6
update t2019_kar_street_node set geom = st_transform(st_setsrid(geom,4326),3068) where gid >0;
select * from t2019_kar_street_node
with lines as ( select st_makeline(geom) as line from input_points)
select * from t2019_kar_street_node tksn2019 
join lines on st_dwithin(tksn2019.geom, lines.line, 200)

--ex7
with store as (select * from t2019_kar_poi_table where type='Sporting Goods Store')
select count(distinct store.gid) from store join t2019_kar_land_use_a on st_dwithin(store.geom, t2019_kar_land_use_a.geom, 300)

--ex8
select distinct (st_intersection(tkr.geom, tkwl.geom)) as geom into T2019_KAR_BRIDGES
from t2019_kar_railways tkr, t2019_kar_water_lines tkwl;
select * from T2019_KAR_BRIDGES