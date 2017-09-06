select count(*) from followers where type="public";
select count(*) from followers where type="private";
select count(*) from engagement where type="pb.v1" and user="roman0f";
select count(*) from engagement where type="pb.v1" and user="yulyassana";
select count(*) from engagement where type in ("pr.v1","pr.req","pr.fld") and user="roman0f";
select count(*) from engagement where type in ("pr.v1","pr.req","pr.fld") and user="yulyassana";
