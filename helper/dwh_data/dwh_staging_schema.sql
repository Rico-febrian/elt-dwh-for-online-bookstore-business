-- Data Warehouse Staging Schema


-- Create schema if not exist yet
CREATE SCHEMA IF NOT EXISTS stg AUTHORIZATION postgres;


------------------------------------------------------------------------------------------


-- CREATE TABLE

--
-- Name: address; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.address (
    address_id integer NOT NULL,
    street_number character varying(10),
    street_name character varying(200),
    city character varying(100),
    country_id integer,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


--
-- Name: address_status; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.address_status (
    status_id integer NOT NULL,
    address_status character varying(30),
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


--
-- Name: author; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.author (
    author_id integer NOT NULL,
    author_name character varying(400),
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


--
-- Name: book; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.book (
    book_id integer NOT NULL,
    title character varying(400),
    isbn13 character varying(13),
    language_id integer,
    num_pages integer,
    publication_date date,
    publisher_id integer,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


--
-- Name: book_author; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.book_author (
    book_id integer NOT NULL,
    author_id integer NOT NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


--
-- Name: book_language; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.book_language (
    language_id integer NOT NULL,
    language_code character varying(8),
    language_name character varying(50),
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


--
-- Name: country; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.country (
    country_id integer NOT NULL,
    country_name character varying(200),
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


--
-- Name: cust_order; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.cust_order (
    order_id integer NOT NULL,
    order_date timestamp without time zone,
    customer_id integer,
    shipping_method_id integer,
    dest_address_id integer,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


--
-- Name: customer; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.customer (
    customer_id integer NOT NULL,
    first_name character varying(200),
    last_name character varying(200),
    email character varying(350),
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


-- Name: customer_address; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.customer_address (
    customer_id integer NOT NULL,
    address_id integer NOT NULL,
    status_id integer,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


--
-- Name: order_history; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.order_history (
    history_id integer NOT NULL,
    order_id integer,
    status_id integer,
    status_date timestamp without time zone,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


--
-- Name: order_line; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.order_line (
    line_id integer NOT NULL,
    order_id integer,
    book_id integer,
    price numeric(5,2),
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


--
-- Name: order_status; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.order_status (
    status_id integer NOT NULL,
    status_value character varying(20),
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


--
-- Name: publisher; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.publisher (
    publisher_id integer NOT NULL,
    publisher_name character varying(400),
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


--
-- Name: shipping_method; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.shipping_method (
    method_id integer NOT NULL,
    method_name character varying(100),
    cost numeric(6,2),
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL
);


------------------------------------------------------------------------------------------


-- ADD PRIMARY KEY IN EACH TABLES

--
-- Name: address_status pk_addr_status; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.address_status
    ADD CONSTRAINT pk_addr_status PRIMARY KEY (status_id);


--
-- Name: address pk_address; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.address
    ADD CONSTRAINT pk_address PRIMARY KEY (address_id);


--
-- Name: author pk_author; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.author
    ADD CONSTRAINT pk_author PRIMARY KEY (author_id);


--
-- Name: book pk_book; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.book
    ADD CONSTRAINT pk_book PRIMARY KEY (book_id);


--
-- Name: book_author pk_bookauthor; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.book_author
    ADD CONSTRAINT pk_bookauthor PRIMARY KEY (book_id, author_id);


--
-- Name: country pk_country; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.country
    ADD CONSTRAINT pk_country PRIMARY KEY (country_id);


--
-- Name: customer_address pk_custaddr; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.customer_address
    ADD CONSTRAINT pk_custaddr PRIMARY KEY (customer_id, address_id);


--
-- Name: customer pk_customer; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.customer
    ADD CONSTRAINT pk_customer PRIMARY KEY (customer_id);


--
-- Name: cust_order pk_custorder; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.cust_order
    ADD CONSTRAINT pk_custorder PRIMARY KEY (order_id);


--
-- Name: book_language pk_language; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.book_language
    ADD CONSTRAINT pk_language PRIMARY KEY (language_id);


--
-- Name: order_history pk_orderhist; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.order_history
    ADD CONSTRAINT pk_orderhist PRIMARY KEY (history_id);


--
-- Name: order_line pk_orderline; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.order_line
    ADD CONSTRAINT pk_orderline PRIMARY KEY (line_id);


--
-- Name: order_status pk_orderstatus; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.order_status
    ADD CONSTRAINT pk_orderstatus PRIMARY KEY (status_id);


--
-- Name: publisher pk_publisher; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.publisher
    ADD CONSTRAINT pk_publisher PRIMARY KEY (publisher_id);


--
-- Name: shipping_method pk_shipmethod; Type: CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.shipping_method
    ADD CONSTRAINT pk_shipmethod PRIMARY KEY (method_id);


------------------------------------------------------------------------------------------


-- ADD CONSTRAINT/RELATION BETWEEN TABLES

--
-- Name: address fk_addr_ctry; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.address
    ADD CONSTRAINT fk_addr_ctry FOREIGN KEY (country_id) REFERENCES stg.country(country_id);


--
-- Name: book_author fk_ba_author; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.book_author
    ADD CONSTRAINT fk_ba_author FOREIGN KEY (author_id) REFERENCES stg.author(author_id);


--
-- Name: book_author fk_ba_book; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.book_author
    ADD CONSTRAINT fk_ba_book FOREIGN KEY (book_id) REFERENCES stg.book(book_id);


--
-- Name: book fk_book_lang; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.book
    ADD CONSTRAINT fk_book_lang FOREIGN KEY (language_id) REFERENCES stg.book_language(language_id);


--
-- Name: book fk_book_pub; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.book
    ADD CONSTRAINT fk_book_pub FOREIGN KEY (publisher_id) REFERENCES stg.publisher(publisher_id);


--
-- Name: customer_address fk_ca_addr; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.customer_address
    ADD CONSTRAINT fk_ca_addr FOREIGN KEY (address_id) REFERENCES stg.address(address_id);


--
-- Name: customer_address fk_ca_cust; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.customer_address
    ADD CONSTRAINT fk_ca_cust FOREIGN KEY (customer_id) REFERENCES stg.customer(customer_id);


--
-- Name: order_history fk_oh_order; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.order_history
    ADD CONSTRAINT fk_oh_order FOREIGN KEY (order_id) REFERENCES stg.cust_order(order_id);


--
-- Name: order_history fk_oh_status; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.order_history
    ADD CONSTRAINT fk_oh_status FOREIGN KEY (status_id) REFERENCES stg.order_status(status_id);


--
-- Name: order_line fk_ol_book; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.order_line
    ADD CONSTRAINT fk_ol_book FOREIGN KEY (book_id) REFERENCES stg.book(book_id);


--
-- Name: order_line fk_ol_order; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.order_line
    ADD CONSTRAINT fk_ol_order FOREIGN KEY (order_id) REFERENCES stg.cust_order(order_id);


--
-- Name: cust_order fk_order_addr; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.cust_order
    ADD CONSTRAINT fk_order_addr FOREIGN KEY (dest_address_id) REFERENCES stg.address(address_id);


--
-- Name: cust_order fk_order_cust; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.cust_order
    ADD CONSTRAINT fk_order_cust FOREIGN KEY (customer_id) REFERENCES stg.customer(customer_id);


--
-- Name: cust_order fk_order_ship; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.cust_order
    ADD CONSTRAINT fk_order_ship FOREIGN KEY (shipping_method_id) REFERENCES stg.shipping_method(method_id);


--
-- Name: customer_address fkey_status_add; Type: FK CONSTRAINT; Schema: stg; Owner: postgres
--

ALTER TABLE ONLY stg.customer_address
    ADD CONSTRAINT fkey_status_add FOREIGN KEY (status_id) REFERENCES stg.address_status(status_id);