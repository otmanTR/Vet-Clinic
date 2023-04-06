/*Day one the used queries*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

/*Day two the used queries*/

BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species = '';
COMMIT;
SELECT * FROM animals;
BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
-- Delete all animals born after Jan 1st, 2022.
DELETE FROM animals WHERE date_of_birth > '2022-01-01';

-- Create a savepoint for the transaction.
SAVEPOINT my_savepoint;

-- Update all animals' weight to be their weight multiplied by -1.
UPDATE animals SET weight_kg = -1 * weight_kg;

-- Rollback to the savepoint
ROLLBACK TO SAVEPOINT my_savepoint;

-- Update all animals' weights that are negative to be their weight multiplied by -1.
UPDATE animals SET weight_kg = -1 * weight_kg WHERE weight_kg < 0;

-- Commit transaction
COMMIT;
SELECT * FROM animals;

   --How many animals are there?
   
SELECT COUNT(*) FROM animals;

   --How many animals have never tried to escape?

SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

   --What is the average weight of animals?

SELECT AVG(weight_kg) FROM animals;

    --Who escapes the most, neutered or not neutered animals?

SELECT neutered, SUM(escape_attempts) AS total_escape_attempts
FROM animals
GROUP BY neutered
ORDER BY total_escape_attempts DESC
LIMIT 1;

    --What is the minimum and maximum weight of each type of animal?

SELECT species, MIN(weight_kg), MAX(weight_kg)
FROM animals
GROUP BY species;

    --What is the average number of escape attempts per animal type of those born between 1990 and 2000?

SELECT species, AVG(escape_attempts) AS avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

/*Day three the used queries*/

-- Melody's animals

SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- list of pokemon animals

SELECT animals.name
FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- list of all animals and owns

SELECT owners.full_name, animals.name
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id;

--animal numbers per spacies

SELECT species.name, COUNT(animals.id)
FROM species
JOIN animals ON species.id = animals.species_id
GROUP BY species.name;

--list of Jennifer's digimons

SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
JOIN species ON animals.species_id = species.id
WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'Digimon';

--list of animals owned by Dean Winchester that haven't tried to escape

SELECT * FROM animals WHERE owner_id = 5 AND escape_attempts = 0;

-- who has most animals

SELECT owners.full_name, COUNT(animals.id) AS num_animals
FROM owners
JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.full_name
ORDER BY num_animals DESC
LIMIT 1;

/*Day four the used queries*/

--Who was the last animal seen by William Tatcher?

SELECT animals.name
FROM animals
JOIN visits ON animals.id = visits.animal_id
JOIN vets ON visits.vet_id = vets.id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.visit_date DESC
LIMIT 1;

--How many different animals did Stephanie Mendez see?

SELECT COUNT(DISTINCT a.id)
FROM animals a
JOIN visits v ON v.animal_id=a.id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez';

--List all vets and their specialties, including vets with no specialties.

SELECT v.name, s.name AS specialty
FROM vets v
LEFT JOIN specializations sp ON sp.vet_id = v.id
LEFT JOIN species s ON s.id = sp.species_id
ORDER BY v.name;

--List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.

SELECT a.name
FROM animals a
JOIN visits v ON v.animal_id = a.id
JOIN vets vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez'
AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

--What animal has the most visits to vets?

SELECT a.name, COUNT(*) AS num_visits
FROM animals a
JOIN visits v ON v.animal_id = a.id
GROUP BY a.id
ORDER BY num_visits DESC
LIMIT 1;

--Who was Maisy Smith's first visit?

SELECT owners.full_name AS owner_name, animals.name AS animal_name, visits.visit_date
FROM visits
JOIN vets ON visits.vet_id = vets.id
JOIN animals ON visits.animal_id = animals.id
JOIN owners ON animals.owner_id = owners.id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.visit_date ASC
LIMIT 1;

--Details for most recent visit: animal information, vet information, and date of visit.

SELECT a.name AS animal_name, v.name AS vet_name, vt.visit_date
FROM visits vt
JOIN animals a ON a.id = vt.animal_id
JOIN vets v ON v.id = vt.vet_id
ORDER BY vt.visit_date DESC
LIMIT 1;

--How many visits were with a vet that did not specialize in that animal's species?

SELECT COUNT(*) 
FROM visits v
JOIN animals a ON a.id = v.animal_id
JOIN vets vt ON vt.id = v.vet_id
LEFT JOIN specializations sp ON sp.vet_id = vt.id AND sp.species_id = a.species_id
WHERE sp.vet_id IS NULL;

--What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT s.name AS recommended_specialty
FROM animals a
JOIN species s ON s.id = a.species_id
JOIN visits v ON v.animal_id = a.id
JOIN vets vt ON vt.id = v.vet_id
JOIN owners o ON o.id = a.owner_id
WHERE o.full_name = 'Maisy Smith'
GROUP BY s.id
ORDER BY COUNT(*) DESC
LIMIT 1;
