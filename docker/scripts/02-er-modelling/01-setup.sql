-- demo-setup.sql
-- Enable performance extensions
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pg_buffercache;
CREATE EXTENSION IF NOT EXISTS pg_prewarm;

-- Reset pg_stat_statements
SELECT pg_stat_statements_reset();