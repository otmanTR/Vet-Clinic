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