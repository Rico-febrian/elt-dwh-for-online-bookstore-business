-- Data Warehouse Final Schema

-- Create UUID extension if not exist yet
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create schema if not exist yet
CREATE SCHEMA IF NOT EXISTS final AUTHORIZATION postgres;