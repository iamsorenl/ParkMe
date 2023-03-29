CREATE EXTENSION IF NOT EXISTS pgcrypto;

DROP TABLE IF EXISTS account CASCADE;
DROP TABLE IF EXISTS spot CASCADE;
DROP TABLE IF EXISTS rental CASCADE;

CREATE TABLE account (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,
    data JSONB
);

CREATE TABLE spot (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,
    data JSONB,
    uid UUID REFERENCES account(id) ON DELETE CASCADE
);

CREATE TABLE rental (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,
    data JSONB,
    sid UUID REFERENCES spot(id) ON DELETE CASCADE,
    uid UUID REFERENCES account(id)
);
