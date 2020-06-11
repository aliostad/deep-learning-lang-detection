-- creates the mitochondrial model
INSERT INTO entity VALUES (NULL, 'cell', 'place', 0, 2);
INSERT INTO entity VALUES (NULL, 'mitochondria', 'place', (SELECT id FROM entity WHERE name='cell' AND model=2), 2);
INSERT INTO entity VALUES (NULL, 'nucleus', 'place', (SELECT id FROM entity WHERE name='cell' AND model=2), 2);

INSERT INTO entity VALUES (NULL, 'ROS rate', 'transient', (SELECT id FROM entity WHERE name='mitochondria' AND model=2), 2);
INSERT INTO entity VALUES (NULL, 'ROS', 'transient', (SELECT id FROM entity WHERE name='mitochondria' AND model=2), 2);
INSERT INTO entity VALUES (NULL, 'ATP', 'transient', (SELECT id FROM entity WHERE name='mitochondria' AND model=2), 2);
INSERT INTO entity VALUES (NULL, 'Lon rate', 'transient', (SELECT id FROM entity WHERE name='nucleus' AND model=2), 2);
INSERT INTO entity VALUES (NULL, 'Lon Protease mRNA', 'stable', (SELECT id FROM entity WHERE name='nucleus' AND model=2), 2);
INSERT INTO entity VALUES (NULL, 'Lon Protease', 'transient', (SELECT id FROM entity WHERE name='mitochondria' AND model=2), 2);
INSERT INTO entity VALUES (NULL, 'mutated mtDNA', 'stable', (SELECT id FROM entity WHERE name='mitochondria' AND model=2), 2);
INSERT INTO entity VALUES (NULL, 'damaged mitochondria', 'stable', (SELECT id FROM entity WHERE name='mitochondria' AND model=2), 2);
INSERT INTO entity VALUES (NULL, 'antioxidants', 'transient', (SELECT id FROM entity WHERE name='mitochondria' AND model=2), 2);

-- ROS in the mitochondria increases with ROS rate in the mitochondria
INSERT INTO link VALUES
  (NULL,
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='ROS' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  'increases',
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='ROS rate' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  2);

-- mutated mtDNA in the mitochondria increases with ROS in the mitochondria
INSERT INTO link VALUES
  (NULL,
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='mutated mtDNA' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  'increases',
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='ROS' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  2);

-- Lon Protease mRNA in the nucleus decreases with Lon rate in the nucleus
INSERT INTO link VALUES
  (NULL,
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='Lon Protease mRNA' AND e.location=e2.id AND e2.name='nucleus' AND e.model=2 AND e2.model=2),
  'decreases',
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='Lon rate' AND e.location=e2.id AND e2.name='nucleus' AND e.model=2 AND e2.model=2),
  2);
  
-- Lon protease in the mitochondria increases with Lon protease mRNA in the nucleus (model 2)
INSERT INTO link VALUES
  (NULL,
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='Lon protease' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  'increases',
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='Lon Protease mRNA' AND e.location=e2.id AND e2.name='nucleus' AND e.model=2 AND e2.model=2),
  2);
  
-- mutated mtDNA in the mitochondria decreases with Lon Protease in the mitochondria (model 2)
INSERT INTO link VALUES
  (NULL,
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='mutated mtDNA' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  'decreases',
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='Lon Protease' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  2);
  
-- damaged mitochondria in the mitochondria increases with mutated mtRNA in the mitochondria (model 2)
INSERT INTO link VALUES
  (NULL,
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='damaged mitochondria' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  'increases',
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='mutated mtDNA' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  2);
  
-- ===============

-- damaged mitochondria in the mitochondria decreases with Lon Protease in the mitochondria (model 2)
INSERT INTO link VALUES
  (NULL,
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='damaged mitochondria' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  'decreases',
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='Lon Protease' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  2);

-- ROS in the mitochondria decreases with antioxidants in the mitochondria (model 2)
INSERT INTO link VALUES
  (NULL,
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='ROS' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  'decreases',
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='antioxidants' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  2);

-- ROS in the mitochondria increases with damaged membrane in the mitochondria (model 2)
INSERT INTO link VALUES
  (NULL,
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='ROS' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  'increases',
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='damaged mitochondria' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  2);

-- ATP in the mitochondria decreases with damaged membrane in the mitochondria (model 2)
INSERT INTO link VALUES
  (NULL,
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='ATP' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  'decreases',
  (SELECT e.id FROM entity e, entity e2 WHERE e.name='damaged mitochondria' AND e.location=e2.id AND e2.name='mitochondria' AND e.model=2 AND e2.model=2),
  2);

-- FACT: damaged mitochondria in the mitochondria increases with time
INSERT INTO fact VALUES (NULL, 47, 'increases', 49, 2);

-- FACT: ATP in the mitochondria increases with time
INSERT INTO fact VALUES (NULL, 42, 'increases', 49, 2);

-- FACT: ROS in the mitochondria increases with time
INSERT INTO fact VALUES (NULL, 41, 'increases', 49, 2);

-- FACT: mutated mtDNA decreases with antioxidants in the mitochondria
INSERT INTO fact VALUES (NULL, 46, 'decreases', 48, 2);