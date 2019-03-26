DROP table if exists public."notion" CASCADE;
DROP table if exists public."langue" CASCADE;
DROP table if exists public."traduction" CASCADE;


create table if not exists "langue"
(
  id        serial    PRIMARY KEY  not null,
  nom     varchar(255) not null,
  code_iso   varchar(2) not null
);


create table if not exists "notion"
(
  id        serial    PRIMARY KEY  not null,
  mot    varchar(255) not null,
  définition text,
  langue int NOT NULL references langue(id)



create table if not exists "traduction"
(
    id serial PRIMARY KEY NOT NULL,
    source int NOT NULL references notion(id),
    cible int NOT NULL references notion(id),
    unique(source, cible)
);


insert into langue(id, nom, code_iso) values (1, 'Polski', 'PL');
insert into langue(id, nom, code_iso) values (2, 'Francuski', 'FR');
insert into langue(id, nom, code_iso) values (3, 'Angielski', 'EN');

insert into notion(mot, définition, langue) values('język', 'Język, jakim mówimy', 1);
insert into notion(mot, définition, langue) values('langue', 'La langue que nous parlons', 2);
insert into notion(mot, définition, langue) values('language', 'Language we speak', 3);

insert into traduction(source, cible) values (1, 2);
insert into traduction(source, cible) values (1, 3);
insert into traduction(source, cible) values (2, 3);
insert into traduction(source, cible) values (2, 1);
insert into traduction(source, cible) values (3, 1);
insert into traduction(source, cible) values (3, 2);


DROP FUNCTION traduis(character varying,character varying);
CREATE or REPLACE FUNCTION traduis(term varchar, lang  varchar)
 RETURNS TABLE (
  notion varchar,
  langue_source_nom varchar,
  traduction varchar,
  traduction_definicja text,
  langue_cible_nom varchar )
  AS $func$
BEGIN
RETURN QUERY
  select n.mot as notion,
         ls.nom as langue_source_nom,
         n.nom as traduction,
         n.définition as définition,
         lc.nom as langue_cible_nom
    FROM
      langue ls,
      langue lc,
      notion n,
      notion nt,
      traduction t
    WHERE
      n.nom=term
      and
      lc.code_iso=langue
      and
      t.cible = lc.id
      and
      t.source = n.langue
      and ls.id = nom.langue
      and nt.langue = lc.id
;

END ; $func$
LANGUAGE PLPGSQL;
