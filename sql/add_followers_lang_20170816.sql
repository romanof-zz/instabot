ALTER TABLE followers ADD lang varchar(5) DEFAULT NULL;
UPDATE followers SET lang = "rus";
