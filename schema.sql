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
