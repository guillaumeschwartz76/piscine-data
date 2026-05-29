CREATE TABLE data_2022_dec (
	event_time TIMESTAMPTZ,
	event_type VARCHAR,
	product_id INTEGER,
	price NUMERIC,
	user_id BIGINT,
	user_session UUID
);

CREATE TABLE data_2022_nov (
	event_time TIMESTAMPTZ,
	event_type VARCHAR,
	product_id INTEGER,
	price NUMERIC,
	user_id BIGINT,
	user_session UUID
);

CREATE TABLE data_2022_oct (
	event_time TIMESTAMPTZ,
	event_type VARCHAR,
	product_id INTEGER,
	price NUMERIC,
	user_id BIGINT,
	user_session UUID
);

CREATE TABLE data_2023_jan (
	event_time TIMESTAMPTZ,
	event_type VARCHAR,
	product_id INTEGER,
	price NUMERIC,
	user_id BIGINT,
	user_session UUID
);

CREATE TABLE items (
	product_id INTEGER,
	category_id	BIGINT,
	category_code VARCHAR(50),
	brand VARCHAR(50)
);

SELECT * FROM data_2022_dec;
DROP TABLE IF EXISTS data_2023_jan, data_2022_dec, data_2022_oct, data_2022_nov, items;