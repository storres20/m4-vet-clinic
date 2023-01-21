/*Queries that provide answers to the questions from all projects.*/

/* Find all animals whose name ends in "mon". */
select * from animals where name like '%mon';

/* List the name of all animals born between 2016 and 2019. */
select name from animals where date_of_birth between '2016-01-01' and '2019-12-31';

/* List the name of all animals that are neutered and have less than 3 escape attempts. */
select name from animals where neutered = true and escape_attempts < 3;

/* List the date of birth of all animals named either "Agumon" or "Pikachu". */
select date_of_birth from animals where name in('Agumon','Pikachu');

/* List name and escape attempts of animals that weigh more than 10.5kg */
select name, escape_attempts from animals where weight_kg > 10.5;

/* Find all animals that are neutered. */
select * from animals where neutered = true;

/* Find all animals not named Gabumon. */
select * from animals where name != 'Gabumon';

/* Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg) */
select * from animals where weight_kg between 10.4 and 17.3;


/* Project 2 */
/* Vet clinic database: query and update animals table */

/* Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction. */
begin;
alter table animals
add species text;

update animals
set species = 'unspecified';

select * from animals;

rollback;

select * from animals;

/* Inside a transaction:

    Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
    Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
    Commit the transaction.
    Verify that change was made and persists after commit.

Take a screenshot of the results of your actions. */
begin;

alter table animals
add species text;

update animals
set species = 'digimon'
where name like '%mon';

update animals
set species = 'pokemon'
where species not like '%mon';

commit;

select * from animals;

/* Now, take a deep breath and... Inside a transaction delete all records in the animals table, then roll back the transaction.
After the rollback verify if all records in the animals table still exists. After that, you can start breathing as usual ;)
Take a screenshot of the results of your actions. */
begin;

delete from animals;

rollback;

select * from animals;

/* Inside a transaction:

    Delete all animals born after Jan 1st, 2022.
    Create a savepoint for the transaction.
    Update all animals' weight to be their weight multiplied by -1.
    Rollback to the savepoint
    Update all animals' weights that are negative to be their weight multiplied by -1.
    Commit transaction

Take a screenshot of the results of your actions. */
begin;

delete from animals
where date_of_birth > '2022-01-01';

savepoint my_savepoint;

update animals
set weight_kg = weight_kg * (-1);

rollback to savepoint my_savepoint;

update animals
set weight_kg = weight_kg * (-1)
where weight_kg < 0;

commit;

/* Write queries to answer the following questions: */

/* How many animals are there? */
select count(*) from animals;

/* How many animals have never tried to escape? */
select count(*) from animals
where escape_attempts = 0;

/* What is the average weight of animals? */
select avg(weight_kg) from animals;

/* Who escapes the most, neutered or not neutered animals? */
select neutered, max(escape_attempts) from animals
group by neutered;

/* What is the minimum and maximum weight of each type of animal? */
select species, max(weight_kg), min(weight_kg) from animals
group by species;

/* What is the average number of escape attempts per animal type of those born between 1990 and 2000? */
select species, avg(escape_attempts) from animals
where date_of_birth between '1990-01-01' and '2000-12-31'
group by species;


/* Project 3 - Multiple Tables */
/* What animals belong to Melody Pond? */
SELECT name, full_name FROM animals a
INNER JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Melody Pond';

/* List of all animals that are pokemon (their type is Pokemon). */
SELECT * FROM animals a
INNER JOIN species s ON a.species_id = s.id
WHERE s.name='Pokemon';

/* List all owners and their animals, remember to include those that don't own any animal. */
SELECT name, date_of_birth, neutered, weight_kg, full_name, age
FROM animals a
INNER JOIN owners o
ON  o.id = a.owner_id;

/* How many animals are there per species? */
SELECT COUNT(a.name), s.name
FROM animals a
INNER JOIN species s ON a.species_id = s.id
GROUP BY s.name;

/* List all Digimon owned by Jennifer Orwell. */
SELECT name, full_name
FROM animals a
INNER JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Jennifer Orwell' AND name Like '%mon';

/* List all animals owned by Dean Winchester that haven't tried to escape. */
SELECT name, full_name
FROM animals a
INNER JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' and escape_attempts=0;

/* Who owns the most animals? */
SELECT o.full_name, COUNT(a.owner_id)
FROM animals a
INNER JOIN owners o ON o.id = a.owner_id
GROUP BY o.full_name;


/* Vet clinic database: add "join table" for visits */
/* Who was the last animal seen by William Tatcher? */
SELECT a.name AS "ANIMAL",
vet.name AS "VETERINARIAN",
vis.date_of_visit AS "DATE OF VISIT"
FROM animals a JOIN visits vis
ON vis.animal_id = a.id
JOIN vets vet
ON vet.id = vis.vet_id
WHERE vet.name = 'William Tatcher'
ORDER BY vis.date_of_visit DESC LIMIT 1;

/* How many different animals did Stephanie Mendez see? */
SELECT vet.name AS "VETERINARIAN",
COUNT(vis.date_of_visit) AS "Nº DATES"
FROM vets vet JOIN visits vis
ON vet.id = vis.vet_id
WHERE vet.name = 'Stephanie Mendez'
GROUP BY vet.name;

/* List all vets and their specialties, including vets with no specialties. */
SELECT vet.name AS "VETERINARIAN",
spc.name AS "SPECIALITY"
FROM vets vet LEFT JOIN specializations special
ON vet.id = special.vet_id
LEFT JOIN species spc
ON spc.id = special.species_id;

/* List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020. */
SELECT a.name AS "ANIMAL",
vet.name AS "VETERINARIAN",
vis.date_of_visit AS "DATE OF VISIT"
FROM animals a JOIN visits vis
ON a.id = vis.animal_id
JOIN vets vet
ON vet.id = vis.vet_id
WHERE vet.name = 'Stephanie Mendez'
AND vis.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

/* What animal has the most visits to vets? */
SELECT a.name AS "ANIMAL",
COUNT(vis.animal_id) AS "Nº OF VISITS"
FROM animals a JOIN visits vis
ON a.id = vis.animal_id
GROUP BY a.name
ORDER BY "Nº OF VISITS" DESC LIMIT 1;

/* Who was Maisy Smith's first visit? */
SELECT a.name AS "ANIMAL",
vis.date_of_visit AS "DATE"
FROM animals a JOIN visits vis
ON a.id = vis.animal_id
JOIN vets vet
ON vet.id = vis.vet_id
WHERE vet.name = 'Maisy Smith'
ORDER BY "DATE" ASC LIMIT 1;

/* Details for most recent visit: animal information, vet information, and date of visit. */
SELECT a.name AS "ANIMAL",
a.date_of_birth AS "DATE OF BIRTH",
a.escape_attempts AS "Nº OF ESCAPES",
a.neutered AS "NEUTERED",
a.weight_kg AS "WEIGHT",
vet.name AS "VETERINARIAN",
vet.age AS "AGE",
vet.date_of_graduation AS "DATE OF GRADUATION",
vis.date_of_visit AS "DATE OF VISIT"
FROM animals a JOIN visits vis
ON a.id = vis.animal_id
JOIN vets vet
ON vet.id = vis.vet_id
ORDER BY "DATE OF VISIT" DESC LIMIT 1;

/* How many visits were with a vet that did not specialize in that animal's species? */
SELECT COUNT(vis.animal_id) AS "Nº OF VISITS"
FROM animals a
JOIN visits vis
ON vis.animal_id = a.id
JOIN vets vet
ON vet.id = vis.vet_id
JOIN species spc
ON spc.id = a.species_id
JOIN specializations special
ON special.vet_id = vet.id
JOIN species spc2
ON spc2.id = special.species_id
WHERE spc.name <> spc2.name;

/* What specialty should Maisy Smith consider getting? Look for the species she gets the most. */
SELECT vet.name AS "VETERINARIAN",
spc.name AS "TYPE",
COUNT(spc.name) AS "QUANTITY"
FROM vets vet
JOIN visits vis
ON vet.id = vis.vet_id
JOIN animals a
ON a.id = vis.animal_id
JOIN species spc
ON spc.id = a.species_id
WHERE vet.name = 'Maisy Smith'
GROUP BY spc.name, vet.name
ORDER BY "QUANTITY" DESC LIMIT 1;


