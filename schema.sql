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
 

/* Vet clinic database: add "join table" for visits */
/* Create a table named vets with the following columns:

    id: integer (set it as autoincremented PRIMARY KEY)
    name: string
    age: integer
    date_of_graduation: date
 */
 CREATE TABLE vets(
   id int generated always as identity PRIMARY KEY,
   name text,
   age int,
   date_of_graduation date
 );
 
/* There is a many-to-many relationship between the tables species and vets: a vet can specialize in multiple species, and a species can have multiple vets specialized in it. Create a "join table" called specializations to handle this relationship. */
CREATE TABLE specializations(
   id int generated always as identity,
   vet_id int,
   species_id int,
   foreign key(vet_id) references vets(id),
   foreign key(species_id) references species(id),
   PRIMARY KEY(id, vet_id, species_id)
);

/* There is a many-to-many relationship between the tables animals and vets: an animal can visit multiple vets and one vet can be visited by multiple animals. Create a "join table" called visits to handle this relationship, it should also keep track of the date of the visit. */
CREATE TABLE visits(
   id int generated always as identity,
   animal_id int,
   vet_id int,
   date_of_visit date,
   foreign key(animal_id) references animals(id),
   foreign key(vet_id) references vets(id),
   PRIMARY KEY(id, vet_id, animal_id, date_of_visit)
);

