-- DDL
-- ------------------------------------------------------------
--  1. GALAXY
-- ------------------------------------------------------------
CREATE TABLE galaxy (
    galaxy_id               SERIAL          PRIMARY KEY,
    name                    VARCHAR(100)    NOT NULL UNIQUE,
    galaxy_type             VARCHAR(50)     NOT NULL,
    age_in_millions_of_years INT,
    distance_from_earth     NUMERIC(15, 2),
    has_life                BOOLEAN         NOT NULL DEFAULT FALSE,
    description             TEXT
);

-- ------------------------------------------------------------
--  2. STAR
-- ------------------------------------------------------------
CREATE TABLE star (
    star_id                 SERIAL          PRIMARY KEY,
    name                    VARCHAR(100)    NOT NULL UNIQUE,
    galaxy_id               INT             NOT NULL,
    age_in_millions_of_years INT,
    mass                    NUMERIC(10, 4),
    is_spherical            BOOLEAN         NOT NULL DEFAULT TRUE,
    has_planets             BOOLEAN         NOT NULL DEFAULT FALSE,
    spectral_type           VARCHAR(10),
    CONSTRAINT fk_star_galaxy FOREIGN KEY (galaxy_id)
        REFERENCES galaxy (galaxy_id) ON DELETE RESTRICT
);

-- ------------------------------------------------------------
--  3. PLANET_TYPE  (5th required table)
-- ------------------------------------------------------------
CREATE TABLE planet_type (
    planet_type_id  SERIAL          PRIMARY KEY,
    name            VARCHAR(50)     NOT NULL UNIQUE,
    description     TEXT            NOT NULL,
    is_habitable    BOOLEAN         NOT NULL DEFAULT FALSE
);

-- ------------------------------------------------------------
--  4. PLANET
-- ------------------------------------------------------------
CREATE TABLE planet (
    planet_id               SERIAL          PRIMARY KEY,
    name                    VARCHAR(100)    NOT NULL UNIQUE,
    star_id                 INT             NOT NULL,
    planet_type_id          INT,
    age_in_millions_of_years INT,
    distance_from_star      NUMERIC(15, 6),
    has_life                BOOLEAN         NOT NULL DEFAULT FALSE,
    is_spherical            BOOLEAN         NOT NULL DEFAULT TRUE,
    radius_km               INT,
    CONSTRAINT fk_planet_star FOREIGN KEY (star_id)
        REFERENCES star (star_id) ON DELETE RESTRICT ,
    CONSTRAINT  fk_planet_planet_type FOREIGN KEY (planet_type_id)
        REFERENCES planet_type (planet_type_id) ON DELETE RESTRICT
);

-- ------------------------------------------------------------
--  5. MOON
-- ------------------------------------------------------------
CREATE TABLE moon (
    moon_id                 SERIAL          PRIMARY KEY,
    name                    VARCHAR(100)    NOT NULL UNIQUE,
    planet_id               INT             NOT NULL,
    age_in_millions_of_years INT,
    radius_km               INT,
    is_spherical            BOOLEAN         NOT NULL DEFAULT TRUE,
    has_atmosphere          BOOLEAN         NOT NULL DEFAULT FALSE,
    distance_from_planet    NUMERIC(12, 2),
    CONSTRAINT fk_moon_planet FOREIGN KEY (planet_id)
        REFERENCES planet (planet_id) ON DELETE RESTRICT
);


-- DML
-- ------------------------------------------------------------
--  GALAXY  (6 rows)
-- ------------------------------------------------------------
INSERT INTO galaxy (name, galaxy_type, age_in_millions_of_years, distance_from_earth, has_life, description) VALUES
('Milky Way',              'Barred Spiral', 13600,  0.00,         TRUE,  'Our home galaxy, a barred spiral containing over 200 billion stars.'),
('Andromeda',              'Spiral',        10100,  2537000.00,   FALSE, 'Nearest large galaxy to the Milky Way; on a collision course with it in ~4.5 Gy.'),
('Triangulum',             'Spiral',        10000,  2730000.00,   FALSE, 'Third-largest galaxy in the Local Group, a pure spiral with active star formation.'),
('Large Magellanic Cloud', 'Irregular',     13000,  163000.00,    FALSE, 'Satellite galaxy of the Milky Way, visible with the naked eye from the Southern Hemisphere.'),
('Small Magellanic Cloud', 'Irregular',      6500,  200000.00,    FALSE, 'Dwarf satellite galaxy orbiting the Milky Way, located in the constellation Tucana.'),
('Whirlpool Galaxy',       'Spiral',          400,  23000000.00,  FALSE, 'Grand-design spiral galaxy in gravitational interaction with its companion NGC 5195.');

-- ------------------------------------------------------------
--  STAR  (6 rows — all in Milky Way, galaxy_id = 1)
-- ------------------------------------------------------------
INSERT INTO star (name, galaxy_id, age_in_millions_of_years, mass, is_spherical, has_planets, spectral_type) VALUES
('Sun',              1, 4600, 1.0000,  TRUE, TRUE,  'G2V'),
('Sirius',           1,  242, 2.0630,  TRUE, FALSE, 'A1V'),
('Betelgeuse',       1,    8, 11.6000, TRUE, FALSE, 'M2Iab'),
('Proxima Centauri', 1, 4850, 0.1221,  TRUE, TRUE,  'M5Ve'),
('Alpha Centauri A', 1, 5300, 1.1000,  TRUE, FALSE, 'G2V'),
('Rigel',            1,    8, 21.0000, TRUE, FALSE, 'B8Iab');

-- ------------------------------------------------------------
--  PLANET_TYPE  (4 rows)
-- ------------------------------------------------------------
INSERT INTO planet_type (name, description, is_habitable) VALUES
('Terrestrial', 'Rocky planets with solid surfaces, similar to Earth and Mars.',               TRUE),
('Gas Giant',   'Large planets composed mainly of hydrogen and helium, like Jupiter.',         FALSE),
('Ice Giant',   'Planets made largely of icy materials: water, ammonia and methane.',          FALSE),
('Super Earth', 'Exoplanets more massive than Earth but lighter than Neptune; may be rocky.',  TRUE);

-- ------------------------------------------------------------
--  PLANET  (12 rows)
--  star_id: 1=Sun, 2=Sirius, 4=Proxima Centauri, 5=Alpha Centauri A, 6=Rigel
--  planet_type_id: 1=Terrestrial, 2=Gas Giant, 3=Ice Giant, 4=Super Earth
-- ------------------------------------------------------------
INSERT INTO planet (name, star_id, planet_type_id, age_in_millions_of_years, distance_from_star, has_life, is_spherical, radius_km) VALUES
('Mercury',           1, 1, 4500,  0.387100, FALSE, TRUE,  2439),
('Venus',             1, 1, 4500,  0.723300, FALSE, TRUE,  6051),
('Earth',             1, 1, 4543,  1.000000, TRUE,  TRUE,  6371),
('Mars',              1, 1, 4503,  1.523700, FALSE, TRUE,  3389),
('Jupiter',           1, 2, 4503,  5.204400, FALSE, TRUE,  69911),
('Saturn',            1, 2, 4503,  9.582600, FALSE, TRUE,  58232),
('Uranus',            1, 3, 4503, 19.218400, FALSE, TRUE,  25362),
('Neptune',           1, 3, 4503, 30.070000, FALSE, TRUE,  24622),
('Proxima Centauri b',4, 4, 4850,  0.048500, FALSE, TRUE,  7160),
('Sirius Ab',         2, 2,  242,  3.400000, FALSE, TRUE,  50000),
('Alpha Centauri Ab', 5, 1, 5300,  1.100000, FALSE, TRUE,  7200),
('Rigel b',           6, 2,    8, 10.000000, FALSE, FALSE, 80000);

-- ------------------------------------------------------------
--  MOON  (21 rows)
--  planet_id: 3=Earth, 4=Mars, 5=Jupiter, 6=Saturn, 7=Uranus, 8=Neptune
-- ------------------------------------------------------------
INSERT INTO moon (name, planet_id, age_in_millions_of_years, radius_km, is_spherical, has_atmosphere, distance_from_planet) VALUES
-- Earth
('Moon',      3, 4530,  1737, TRUE,  FALSE,  384400.00),
-- Mars
('Phobos',    4, 4503,    11, FALSE, FALSE,    9376.00),
('Deimos',    4, 4503,     6, FALSE, FALSE,   23463.00),
-- Jupiter
('Io',        5, 4503,  1821, TRUE,  TRUE,   421700.00),
('Europa',    5, 4503,  1560, TRUE,  TRUE,   671100.00),
('Ganymede',  5, 4503,  2634, TRUE,  TRUE,  1070400.00),
('Callisto',  5, 4503,  2410, TRUE,  FALSE, 1882700.00),
-- Saturn
('Titan',     6, 4503,  2574, TRUE,  TRUE,  1221870.00),
('Enceladus', 6, 4503,   252, TRUE,  TRUE,   238020.00),
('Mimas',     6, 4503,   198, TRUE,  FALSE,  185539.00),
('Rhea',      6, 4503,   764, TRUE,  FALSE,  527108.00),
('Dione',     6, 4503,   561, TRUE,  FALSE,  377396.00),
('Tethys',    6, 4503,   531, TRUE,  FALSE,  294619.00),
-- Uranus
('Titania',   7, 4503,   788, TRUE,  FALSE,  435910.00),
('Oberon',    7, 4503,   761, TRUE,  FALSE,  583520.00),
('Miranda',   7, 4503,   235, FALSE, FALSE,  129390.00),
('Ariel',     7, 4503,   578, TRUE,  FALSE,  191020.00),
('Umbriel',   7, 4503,   584, TRUE,  FALSE,  266300.00),
-- Neptune
('Triton',    8, 4503,  1353, TRUE,  TRUE,   354759.00),
('Nereid',    8, 4503,   170, FALSE, FALSE, 5513400.00),
('Proteus',   8, 4503,   210, FALSE, FALSE,  117647.00);
