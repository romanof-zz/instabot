ALTER TABLE followers ADD source varchar(255) DEFAULT NULL;
UPDATE followers SET source = "artem__kryuchkov|kudadi";
ALTER TABLE followers ADD category varchar(60) DEFAULT NULL;
UPDATE followers SET category = "travel";
