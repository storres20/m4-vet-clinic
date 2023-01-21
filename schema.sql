/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id int,
    name text,
    date_of_birth date,
    escape_attempts int,
    neutered boolean,
    weight_kg decimal
);

ALTER TABLE animals
ADD species text;

/* Create a table named owners with the following columns:

    id: integer (set it as autoincremented PRIMARY KEY)
    full_name: string
    age: integer
 */
 CREATE TABLE owners (
    id int generated always as identity,
    full_name text,
    age int,
    PRIMARY KEY(id)
 );
 
 /* Create a table named species with the following columns:

    id: integer (set it as autoincremented PRIMARY KEY)
    name: string
 */
 CREATE TABLE species (
    id int generated always as identity,
    name text,
    PRIMARY KEY(id)
 );
 
 /* Modify animals table:

    Make sure that id is set as autoincremented PRIMARY KEY
    Remove column species
    Add column species_id which is a foreign key referencing species table
    Add column owner_id which is a foreign key referencing the owners table
 */
 ALTER TABLE animals
 ADD PRIMARY KEY(id);
 
 SELECT SETVAL('animals_id_seq', (SELECT max(id) from animals));
 
 ALTER TABLE animals
 DROP species;
 
 ALTER TABLE animals
 ADD species_id int;
 
 ALTER TABLE animals
 ADD foreign key(species_id) references species(id);
 
 ALTER TABLE animals
 ADD owner_id int;
 
 ALTER TABLE animals
 ADD foreign key(owner_id) references owners(id);
 