/* Day one the used queries */

CREATE TABLE animals (
   id SERIAL PRIMARY KEY,
   name VARCHAR(255) NOT NULL,
   date_of_birth DATE NOT NULL,
   escape_attempts INTEGER DEFAULT 0,
   neutered BOOLEAN DEFAULT FALSE,
   weight_kg DECIMAL(5,2) NOT NULL
);
/* Day two the used queries */

ALTER TABLE animals ADD COLUMN species VARCHAR(50);

/* Day three the used QUERIES */

-- add owners table

CREATE TABLE owners ( id SERIAL PRIMARY KEY, full_name VARCHAR(255), age INTEGER );

--add species table

CREATE TABLE species ( id SERIAL PRIMARY KEY, name VARCHAR(255) );

--modify animals table

ALTER TABLE animals
  DROP COLUMN species,
  ADD COLUMN species_id INTEGER REFERENCES species(id),
  ADD COLUMN owner_id INTEGER REFERENCES owners(id);

  ALTER TABLE animals
  ALTER COLUMN id SET DEFAULT nextval('animals_id_seq');