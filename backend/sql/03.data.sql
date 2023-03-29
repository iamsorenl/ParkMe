-- ACCOUNT
INSERT INTO account (id, data) 
VALUES ('00000000-0000-0000-0000-000000000001', 
        jsonb_build_object('name', 'Frodo Baggins', 'email', 'frodo@theshire.com', 'pfp', 'https://cdn.vox-cdn.com/thumbor/N3RGEixdgKeAyQ-FEz1EnDkA7KU=/0x0:1920x796/1200x0/filters:focal(0x0:1920x796):no_upscale()/cdn.vox-cdn.com/uploads/chorus_asset/file/22263336/lotr3_movie_screencaps.com_10334.jpg', 'scopes', jsonb_build_array('user'), 'password', crypt('adventure', gen_salt('bf')))
);

INSERT INTO account (data) 
VALUES (jsonb_build_object('name', 'Bilbo Baggins', 'email', 'bilbo@theshire.com','pfp', 'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/4391fcd1-d078-448d-a116-db037272768f/d6a07r1-baf09dc8-b336-415d-a7e4-5e534a923f6c.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzQzOTFmY2QxLWQwNzgtNDQ4ZC1hMTE2LWRiMDM3MjcyNzY4ZlwvZDZhMDdyMS1iYWYwOWRjOC1iMzM2LTQxNWQtYTdlNC01ZTUzNGE5MjNmNmMuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.5Fe7y9wupHIbwIiwjI5y-kWBBlp5C5ASXbPjxKue7DM', 'scopes', jsonb_build_array('user'), 'password', crypt('bilbo', gen_salt('bf')))
);

INSERT INTO account (id, data) 
VALUES ('00000000-0000-0000-0000-000000000003', 
        jsonb_build_object('name', 'Samwise Gamgee', 'email', 'sam@theshire.com', 'scopes', jsonb_build_array('user'), 'password', crypt('sam', gen_salt('bf')))
);

INSERT INTO spot (id, data, uid) 
VALUES ('d15b4670-3152-42f6-b67f-5f761b77146b', 
        jsonb_build_object('address', jsonb_build_object('addr', '1157 High St', 'zipcode', '95060', 'locality', 'Santa Cruz', 'region', 'California', 'country', 'US'), 'time', jsonb_build_object('start', now(), 'end', now() + interval '2 hours'), 'coords', jsonb_build_object('lat', 36.9772174, 'long', -122.0509138), 'description', 'parking at ucsc', 'priceRate', 10, 'name', 'UCSC'), 
        '00000000-0000-0000-0000-000000000001'
);

INSERT INTO spot (id, data, uid) 
VALUES ('2bffb279-9ebf-4b56-8d90-42ecf00ddfb2', 
        jsonb_build_object('address', jsonb_build_object('addr', '1314 River St', 'zipcode', '95060', 'locality', 'Santa Cruz', 'region', 'California', 'country', 'US'), 'time', jsonb_build_object('start', now(), 'end', now() + interval '2 hours'), 'coords', jsonb_build_object('lat', 36.9911600, 'long', -122.0322400), 'description', 'this spot is owned by frodo, frodo cant rent this spot', 'priceRate', 30, 'name', 'Soren Old House'), 
        '00000000-0000-0000-0000-000000000001'
);

INSERT INTO spot (id, data, uid) 
VALUES ('017c576f-723e-4e62-9704-6d57b78047d3', 
        jsonb_build_object('address', jsonb_build_object('addr', '331 Mission St', 'zipcode', '95060', 'locality', 'Santa Cruz', 'region', 'California', 'country', 'US'), 'time', jsonb_build_object('start', now(), 'end', now() + interval '2 hours'), 'coords', jsonb_build_object('lat', 36.9762100, 'long', -122.0319700), 'description', 'this spot does not have a rental created for it by default', 'priceRate', 15, 'name', 'soren house'), 
        '00000000-0000-0000-0000-000000000003'
);

INSERT INTO spot (id, data, uid) 
VALUES ('80c14ecd-eee9-460e-9924-4bea64d209de', 
        jsonb_build_object('address', jsonb_build_object('addr', '404 King St', 'zipcode', '95060', 'locality', 'Santa Cruz', 'region', 'California', 'country', 'US'), 'time', jsonb_build_object('start', now() + interval '24 hours', 'end', now() + interval '26 hours'), 'coords', jsonb_build_object('lat', 36.9752700, 'long', -122.0359500), 'description', 'this spot is available to users like frodo in the future', 'priceRate', 100, 'name', 'a house'), 
        '00000000-0000-0000-0000-000000000003'
);

-- RENTAL
INSERT INTO rental (id, data, sid, uid) 
VALUES ('8f21b4d4-66c2-4e51-8ca4-356c7d1f2fc9', jsonb_build_object('start', now(), 'end', now() + interval '1 hours', 'amount', 20),
        'd15b4670-3152-42f6-b67f-5f761b77146b', '00000000-0000-0000-0000-000000000003');
