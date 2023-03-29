-- ACCOUNT
INSERT INTO account (id, data) VALUES ('00000000-0000-0000-0000-000000000001', jsonb_build_object('name', 'Frodo Baggins', 'email', 'frodo@theshire.com', 'scopes', jsonb_build_array('user'), 'password', crypt('adventure', gen_salt('bf'))));


INSERT INTO account (data) VALUES (jsonb_build_object('name', 'Bilbo Baggins', 'email', 'bilbo@theshire.com', 'scopes', jsonb_build_array('user'), 'password', crypt('bilbo', gen_salt('bf'))));

INSERT INTO account (id, data) VALUES ('00000000-0000-0000-0000-000000000003', jsonb_build_object('name', 'Samwise Gamgee', 'email', 'sam@theshire.com', 'scopes', jsonb_build_array('user'), 'password', crypt('sam', gen_salt('bf'))));

-- SPOT
INSERT INTO spot (id, data, uid) VALUES ('d15b4670-3152-42f6-b67f-5f761b77146c', jsonb_build_object('address', jsonb_build_object('addr', '1157 High St', 'zipcode', '95060', 'locality', 'Santa Cruz', 'region', 'California', 'country', 'US'), 'time', jsonb_build_object('start', '2023-03-13T01:00:00.000000+00:00', 'end', '2023-03-13T23:00:00.000000+00:00'), 'coords', jsonb_build_object('lat', 36.9772174, 'long', -122.0509138), 'description', 'parking at ucsc', 'priceRate', 10, 'name', 'UCSC'), '00000000-0000-0000-0000-000000000001');

-- SPOT
INSERT INTO spot (id, data, uid) VALUES ('d15b4670-3152-42f6-b67f-5f761b77146b', jsonb_build_object('address', jsonb_build_object('addr', '1157 High St', 'zipcode', '95060', 'locality', 'Santa Cruz', 'region', 'California', 'country', 'US'), 'time', jsonb_build_object('start', now() - INTERVAL '1 hour', 'end', now() + INTERVAL '1 hour'), 'coords', jsonb_build_object('lat', 36.9772174, 'long', -122.0509138), 'description', 'TESTING', 'priceRate', 10, 'name', 'TESTING'), '00000000-0000-0000-0000-000000000001');


INSERT INTO spot (id, data, uid) VALUES ('2bffb279-9ebf-4b56-8d90-42ecf00ddfb2', jsonb_build_object('address', jsonb_build_object('addr', '1314 River St', 'zipcode', '95060', 'locality', 'Santa Cruz', 'region', 'California', 'country', 'US'), 'time', jsonb_build_object('start', '2023-03-13T01:00:00.000000+00:00', 'end', '2023-03-13T23:00:00.000000+00:00'), 'coords', jsonb_build_object('lat', 36.9911600, 'long', -122.0322400), 'description', 'this spot is owned by frodo, frodo cant rent this spot', 'priceRate', 30, 'name', 'Soren Old House'), '00000000-0000-0000-0000-000000000001');

INSERT INTO spot (id, data, uid) VALUES ('017c576f-723e-4e62-9704-6d57b78047d3', jsonb_build_object('address', jsonb_build_object('addr', '331 Mission St', 'zipcode', '95060', 'locality', 'Santa Cruz', 'region', 'California', 'country', 'US'), 'time', jsonb_build_object('start', '2023-03-13T01:00:00.000000+00:00', 'end', '2023-03-13T23:00:00.000000+00:00'), 'coords', jsonb_build_object('lat', 36.9762100, 'long', -122.0319700), 'description', 'this spot does not have a rental created for it by default', 'priceRate', 15, 'name', 'soren house'), '00000000-0000-0000-0000-000000000003');

-- RENTAL
INSERT INTO rental (id, data, sid, uid) VALUES ('8f21b4d4-66c2-4e51-8ca4-356c7d1f2fc9', jsonb_build_object('start', '2023-03-13T05:00:00.000000+00:00', 'end', '2023-03-13T20:00:00.000000+00:00', 'amount', 20), 'd15b4670-3152-42f6-b67f-5f761b77146b', '00000000-0000-0000-0000-000000000001')
