  CREATE USER camundauser WITH PASSWORD 'camundapass';
  CREATE DATABASE camunda;
  GRANT ALL PRIVILEGES ON DATABASE camunda TO camundauser;
--
--   CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';
--   CREATE DATABASE $APP_DB_NAME;
--   GRANT ALL PRIVILEGES ON DATABASE $APP_DB_NAME TO $APP_DB_USER;
--   \connect $APP_DB_NAME $APP_DB_USER
--   BEGIN;
--     CREATE TABLE IF NOT EXISTS event (
-- 	  id CHAR(26) NOT NULL CHECK (CHAR_LENGTH(id) = 26) PRIMARY KEY,
-- 	  aggregate_id CHAR(26) NOT NULL CHECK (CHAR_LENGTH(aggregate_id) = 26),
-- 	  event_data JSON NOT NULL,
-- 	  version INT,
-- 	  UNIQUE(aggregate_id, version)
-- 	);
-- 	CREATE INDEX idx_event_aggregate_id ON event (aggregate_id);
--   COMMIT;