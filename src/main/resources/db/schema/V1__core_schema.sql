--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.5
-- Dumped by pg_dump version 9.5.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: core; Type: SCHEMA; Schema: -; Owner: build
--

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;


--
-- Name: core; Type: SCHEMA; Schema: -; Owner: build
--

DROP SCHEMA IF EXISTS core CASCADE;
CREATE SCHEMA core;


--
-- Name: production; Type: SCHEMA; Schema: -; Owner: build
--

DROP SCHEMA IF EXISTS production CASCADE;
CREATE SCHEMA production;


--
-- Name: srss; Type: SCHEMA; Schema: -; Owner: build
--

DROP SCHEMA IF EXISTS srss CASCADE;
CREATE SCHEMA srss;


SET search_path = production, pg_catalog;

--
-- Name: rule_type; Type: TYPE; Schema: production; Owner: build
--

DROP TYPE IF EXISTS rule_type CASCADE;
CREATE TYPE rule_type AS ENUM (
    'MAX_QUANTITY_PER_YEAR',
    'MAX_QUANTITY_PER_ACTIVITY',
    'MIN_ATTENDEE_PER_ACTIVITY',
    'MAX_ATTENDEE_PER_ACTIVITY',
    'PROMOTIONAL_MATERIAL_END_DATE',
    'TEMPORARILY_UNAVAILABLE'
);


SET search_path = core, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activity; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS activity (
    id uuid NOT NULL,
    sample_request_form_id uuid
);


--
-- Name: attribute_customer_reference_number_seq; Type: SEQUENCE; Schema: core; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS attribute_customer_reference_number_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attribute_imported_customer_reference_number_seq; Type: SEQUENCE; Schema: core; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS attribute_imported_customer_reference_number_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: command_import; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS command_import (
    id bigint NOT NULL,
    tenant_id uuid NOT NULL,
    dispatch_request json NOT NULL,
    status text DEFAULT 'NEW'::text NOT NULL,
    error text,
    handled_at timestamp with time zone,
    batch_name text,
    CONSTRAINT command_import_status_check CHECK ((status = ANY (ARRAY['NEW'::text, 'IN_PROGRESS'::text, 'OK'::text, 'ERROR'::text, 'LIMBO'::text])))
);


--
-- Name: command_import_id_seq; Type: SEQUENCE; Schema: core; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS command_import_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: command_import_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: build
--

ALTER SEQUENCE command_import_id_seq OWNED BY command_import.id;


--
-- Name: customer_number_seq; Type: SEQUENCE; Schema: core; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS customer_number_seq
    START WITH 1000000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_reference_seq; Type: SEQUENCE; Schema: core; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS customer_reference_seq
    START WITH 1000000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: domain_event; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS domain_event (
    id bigint NOT NULL,
    aggregate_identifier uuid NOT NULL,
    sequence_number bigint NOT NULL,
    type text NOT NULL,
    event_identifier uuid NOT NULL,
    meta_data text NOT NULL,
    payload text NOT NULL,
    payload_revision text,
    payload_type text NOT NULL,
    time_stamp timestamp with time zone NOT NULL
);


--
-- Name: domain_event_id_seq; Type: SEQUENCE; Schema: core; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS domain_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: domain_event_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: build
--

ALTER SEQUENCE domain_event_id_seq OWNED BY domain_event.id;


--
-- Name: domain_snapshot; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS domain_snapshot (
    id bigint NOT NULL,
    aggregate_identifier uuid NOT NULL,
    sequence_number bigint NOT NULL,
    type text NOT NULL,
    event_identifier uuid NOT NULL,
    meta_data text NOT NULL,
    payload text NOT NULL,
    payload_revision text,
    payload_type text NOT NULL,
    time_stamp timestamp with time zone NOT NULL
);


--
-- Name: domain_snapshot_id_seq; Type: SEQUENCE; Schema: core; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS domain_snapshot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: domain_snapshot_id_seq; Type: SEQUENCE OWNED BY; Schema: core; Owner: build
--

ALTER SEQUENCE domain_snapshot_id_seq OWNED BY domain_snapshot.id;


--
-- Name: qrtz_blob_triggers; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS qrtz_blob_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    blob_data bytea
);


--
-- Name: qrtz_calendars; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS qrtz_calendars (
    sched_name character varying(120) NOT NULL,
    calendar_name character varying(200) NOT NULL,
    calendar bytea NOT NULL
);


--
-- Name: qrtz_cron_triggers; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS qrtz_cron_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    cron_expression character varying(120) NOT NULL,
    time_zone_id character varying(80)
);


--
-- Name: qrtz_fired_triggers; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS qrtz_fired_triggers (
    sched_name character varying(120) NOT NULL,
    entry_id character varying(95) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    instance_name character varying(200) NOT NULL,
    fired_time bigint NOT NULL,
    sched_time bigint NOT NULL,
    priority integer NOT NULL,
    state character varying(16) NOT NULL,
    job_name character varying(200),
    job_group character varying(200),
    is_nonconcurrent boolean,
    requests_recovery boolean
);


--
-- Name: qrtz_job_details; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS qrtz_job_details (
    sched_name character varying(120) NOT NULL,
    job_name character varying(200) NOT NULL,
    job_group character varying(200) NOT NULL,
    description character varying(250),
    job_class_name character varying(250) NOT NULL,
    is_durable boolean NOT NULL,
    is_nonconcurrent boolean NOT NULL,
    is_update_data boolean NOT NULL,
    requests_recovery boolean NOT NULL,
    job_data bytea
);


--
-- Name: qrtz_locks; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS qrtz_locks (
    sched_name character varying(120) NOT NULL,
    lock_name character varying(40) NOT NULL
);


--
-- Name: qrtz_paused_trigger_grps; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS qrtz_paused_trigger_grps (
    sched_name character varying(120) NOT NULL,
    trigger_group character varying(200) NOT NULL
);


--
-- Name: qrtz_scheduler_state; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS qrtz_scheduler_state (
    sched_name character varying(120) NOT NULL,
    instance_name character varying(200) NOT NULL,
    last_checkin_time bigint NOT NULL,
    checkin_interval bigint NOT NULL
);


--
-- Name: qrtz_simple_triggers; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS qrtz_simple_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    repeat_count bigint NOT NULL,
    repeat_interval bigint NOT NULL,
    times_triggered bigint NOT NULL
);


--
-- Name: qrtz_simprop_triggers; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS qrtz_simprop_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    str_prop_1 character varying(512),
    str_prop_2 character varying(512),
    str_prop_3 character varying(512),
    int_prop_1 integer,
    int_prop_2 integer,
    long_prop_1 bigint,
    long_prop_2 bigint,
    dec_prop_1 numeric(13,4),
    dec_prop_2 numeric(13,4),
    bool_prop_1 boolean,
    bool_prop_2 boolean
);


--
-- Name: qrtz_triggers; Type: TABLE; Schema: core; Owner: build
--

CREATE TABLE IF NOT EXISTS qrtz_triggers (
    sched_name character varying(120) NOT NULL,
    trigger_name character varying(200) NOT NULL,
    trigger_group character varying(200) NOT NULL,
    job_name character varying(200) NOT NULL,
    job_group character varying(200) NOT NULL,
    description character varying(250),
    next_fire_time bigint,
    prev_fire_time bigint,
    priority integer,
    trigger_state character varying(16) NOT NULL,
    trigger_type character varying(8) NOT NULL,
    start_time bigint NOT NULL,
    end_time bigint,
    calendar_name character varying(200),
    misfire_instr smallint,
    job_data bytea
);


SET search_path = production, pg_catalog;

--
-- Name: event_cost_item; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_cost_item (
    id uuid NOT NULL,
    event_id uuid NOT NULL,
    cost_type_id uuid NOT NULL,
    sequence integer NOT NULL,
    cost numeric,
    cost_currency text,
    tax numeric,
    tax_currency text,
    invoice_number text,
    invoice_date timestamp with time zone,
    paid_by_person_assignment_id uuid,
    payment_cost_center text,
    payment_status text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    associated_person_id uuid,
    cost_position_number text,
    CONSTRAINT event_cost_item_payment_status_check CHECK ((payment_status = ANY (ARRAY['PAID'::text, 'NOT_PAID'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: academic_title; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS academic_title (
    id uuid NOT NULL,
    name text,
    type text,
    state text DEFAULT 'ACTIVE'::text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    short_name character varying,
    sort_code integer,
    customer_reference text,
    CONSTRAINT academic_title_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text]))),
    CONSTRAINT academic_title_type_check CHECK ((type = ANY (ARRAY['POSTFIX'::text, 'PREFIX'::text])))
);


--
-- Name: activity; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS activity (
    id uuid NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    activity_type_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    organizer_id uuid NOT NULL,
    sealed boolean DEFAULT false NOT NULL,
    state text NOT NULL,
    status text NOT NULL,
    sample_request_form_id uuid,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    event_id uuid,
    batch_id uuid,
    comment text,
    organizational_unit_id uuid,
    CONSTRAINT activity_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text]))),
    CONSTRAINT activity_status_check CHECK ((status = ANY (ARRAY['PLANNED'::text, 'CLOSED'::text])))
);


--
-- Name: COLUMN activity.comment; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN activity.comment IS 'Free text entered by a user - only used by XPRIS';


--
-- Name: activity_attendee; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS activity_attendee (
    activity_id uuid NOT NULL,
    person_id uuid NOT NULL,
    guest boolean DEFAULT false NOT NULL,
    guest_name text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: communication_data_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS communication_data_type (
    id uuid NOT NULL,
    name text,
    base_type text,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT communication_data_type_base_type_check CHECK ((base_type = ANY (ARRAY['EMAIL'::text, 'PHONE'::text, 'FAX'::text, 'PAGER'::text, 'INTERNET'::text, 'UNKNOWN'::text, 'WEB_CONFERENCE_URL'::text]))),
    CONSTRAINT communication_data_type_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: employee; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS employee (
    id uuid NOT NULL,
    person_id uuid,
    organization_id uuid,
    department_id uuid,
    function_id uuid,
    state text DEFAULT 'ACTIVE'::text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    sort_code integer,
    CONSTRAINT employee_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: given_promotional_material; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS given_promotional_material (
    id uuid NOT NULL,
    activity_id uuid NOT NULL,
    promotional_material_id uuid NOT NULL,
    quantity integer NOT NULL,
    dispatch_type text DEFAULT 'MANUAL'::text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    stock_type text,
    CONSTRAINT given_promotional_material_dispatch_type_check CHECK ((dispatch_type = ANY (ARRAY['FAX'::text, 'MAIL'::text, 'EMAIL'::text, 'MANUAL'::text, 'DISTRIBUTION_CENTER'::text]))),
    CONSTRAINT given_promotional_material_quantity_check CHECK ((quantity >= 0))
);


--
-- Name: organization; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organization (
    id uuid NOT NULL,
    name text,
    in_top_100 boolean DEFAULT false,
    customer_number text,
    searchable boolean DEFAULT true,
    responsible_body text,
    bed_count integer,
    state text DEFAULT 'ACTIVE'::text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    comment text,
    organization_state text,
    CONSTRAINT organization_organization_state_check CHECK ((organization_state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'UNKNOWN'::text, 'CLOSED'::text, 'DELETED'::text]))),
    CONSTRAINT organization_responsible_body_check CHECK ((responsible_body = ANY (ARRAY['PRI'::text, 'PUB'::text, 'UNI'::text, 'UNKNOWN'::text]))),
    CONSTRAINT organization_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: COLUMN organization.comment; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN organization.comment IS 'Free text entered by a user - only used by XPRIS';


--
-- Name: organization_address; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organization_address (
    id uuid NOT NULL,
    organization_id uuid,
    address_1 text,
    address_2 text,
    address_3 text,
    postal_code text,
    city text,
    federal_state text,
    post_box text,
    country_id uuid,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    latitude double precision,
    longitude double precision,
    address_type text NOT NULL,
    postal_code_city_id uuid,
    CONSTRAINT organization_address_check_address_type CHECK ((address_type = ANY (ARRAY['STANDARD'::text, 'VISIT'::text, 'DELIVERY'::text, 'LEGAL'::text])))
);


--
-- Name: organization_communication_data; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organization_communication_data (
    id uuid NOT NULL,
    organization_id uuid,
    communication_data_type_id uuid,
    value text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: person; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person (
    id uuid NOT NULL,
    first_name text,
    middle_name text,
    last_name text,
    prefix_academic_title_id uuid,
    postfix_academic_title_id uuid,
    gender text DEFAULT 'NOT_KNOWN'::text,
    birthday date,
    customer_number text,
    searchable boolean DEFAULT true,
    last_attended_activity_organizer_name text,
    last_attended_activity_date date,
    last_twelve_month_activity_count integer,
    state text DEFAULT 'ACTIVE'::text,
    lanr character varying(9),
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    person_state text,
    CONSTRAINT person_gender_check CHECK ((gender = ANY (ARRAY['MALE'::text, 'FEMALE'::text, 'NOT_APPLICABLE'::text, 'NOT_KNOWN'::text]))),
    CONSTRAINT person_person_state_check CHECK ((person_state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'UNKNOWN'::text, 'DECEASED'::text, 'RETIRED'::text, 'DELETED'::text]))),
    CONSTRAINT person_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: promotional_material; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS promotional_material (
    id uuid NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    product_id uuid,
    marketing_material_id uuid,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT promotional_material_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text]))),
    CONSTRAINT promotional_material_type_check CHECK ((type = ANY (ARRAY['PRODUCT'::text, 'MARKETING_MATERIAL'::text, 'PRODUCT_REQUEST'::text, 'MARKETING_SERVICE'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: activity_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS activity_type (
    id uuid NOT NULL,
    name text NOT NULL,
    single_person_usable boolean DEFAULT false,
    multi_person_usable boolean DEFAULT false,
    organization_usable boolean DEFAULT false,
    state text,
    scheduling text DEFAULT 'START_DATE'::text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT activity_type_scheduling_check CHECK ((scheduling = ANY (ARRAY['START_DATE'::text, 'START_DATE_TIME'::text, 'START_DATE_TIME_AND_DURATION'::text, 'START_AND_END_DATE'::text, 'START_AND_END_DATE_TIME'::text]))),
    CONSTRAINT activity_type_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: additional_event_location; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS additional_event_location (
    event_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: approval; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS approval (
    id uuid NOT NULL,
    object_id uuid NOT NULL,
    object_id_type text NOT NULL,
    approval_status text NOT NULL,
    requested_at timestamp with time zone,
    decided_at timestamp with time zone,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT approval_approval_status_check1 CHECK ((approval_status = ANY (ARRAY['OPEN'::text, 'APPROVED'::text, 'DISAPPROVED'::text]))),
    CONSTRAINT approval_state_check1 CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: approval_batch; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS approval_batch (
    id uuid NOT NULL,
    approval_id uuid NOT NULL,
    sequence integer NOT NULL,
    approval_status text NOT NULL,
    requested_at timestamp with time zone,
    decided_at timestamp with time zone,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    decision_reason text,
    CONSTRAINT approval_batch_approval_status_check CHECK ((approval_status = ANY (ARRAY['OPEN'::text, 'APPROVED'::text, 'DISAPPROVED'::text, 'OBSOLETE'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: attribute; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS attribute (
    id uuid NOT NULL,
    name text,
    attribute_type text,
    state text DEFAULT 'ACTIVE'::text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    abbreviation text,
    customer_reference text,
    sub_type text DEFAULT 'NONE'::text NOT NULL,
    CONSTRAINT attribute_attribute_type_check CHECK ((attribute_type = ANY (ARRAY['TEXT'::text, 'NUMERIC'::text, 'BOOLEAN'::text, 'DATE'::text, 'SINGLE_SELECTION'::text, 'MULTI_SELECTION'::text]))),
    CONSTRAINT attribute_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text]))),
    CONSTRAINT attribute_sub_type_check CHECK ((sub_type = ANY (ARRAY['NONE'::text, 'TARGET'::text, 'DETAIL'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: attribute_category; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS attribute_category (
    id uuid NOT NULL,
    name text,
    state text DEFAULT 'ACTIVE'::text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT attribute_category_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: attribute_container; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS attribute_container (
    id uuid NOT NULL,
    target_id uuid NOT NULL,
    type text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT attribute_container_type_check CHECK ((type = ANY (ARRAY['ORGANIZATIONAL_UNIT'::text, 'EVENT'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: attribute_option; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS attribute_option (
    id uuid NOT NULL,
    value text NOT NULL,
    attribute_id uuid NOT NULL,
    sequence integer NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text
);


SET search_path = production, pg_catalog;

--
-- Name: attribute_usage_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS attribute_usage_type (
    type text,
    attribute_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT attribute_usage_type_type_check CHECK ((type = ANY (ARRAY['ORGANIZATION'::text, 'PERSON'::text, 'ORGANIZATIONAL_UNIT'::text, 'EVENT'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: attribute_value; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS attribute_value (
    id uuid NOT NULL,
    attribute_id uuid NOT NULL,
    attribute_container_id uuid NOT NULL,
    value text NOT NULL,
    last_modification timestamp with time zone NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: attribute_category_to_attribute; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS attribute_category_to_attribute (
    attribute_category_id uuid NOT NULL,
    attribute_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: budget_allocation; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS budget_allocation (
    id uuid NOT NULL,
    name text NOT NULL,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT budget_allocation_state_check CHECK ((state = ANY (ARRAY['ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: channel_consent; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS channel_consent (
    id integer NOT NULL,
    person_id uuid NOT NULL,
    consent_status text,
    consent_status_last_set timestamp with time zone,
    email_consent boolean,
    email_consent_last_set timestamp with time zone,
    telephone_consent boolean,
    telephone_consent_last_set timestamp with time zone,
    fax_consent boolean,
    fax_consent_last_set timestamp with time zone,
    visit_consent boolean,
    visit_consent_last_set timestamp with time zone,
    letter_consent boolean,
    letter_consent_last_set timestamp with time zone,
    consent_document_id uuid,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    changing_source text,
    email_address text,
    document_signed_at date,
    email_address_last_set timestamp with time zone,
    CONSTRAINT channel_consent_consent_status_check CHECK ((consent_status = ANY (ARRAY['AWAITING_FEEDBACK'::text, 'REJECTED'::text, 'SIGNED'::text]))),
    CONSTRAINT email_consent_present_congruent_with_lastset CHECK ((((email_consent IS NOT NULL) AND (email_consent_last_set IS NOT NULL)) OR ((email_consent IS NULL) AND (email_consent_last_set IS NULL)))),
    CONSTRAINT fax_consent_present_congruent_with_lastset CHECK ((((fax_consent IS NOT NULL) AND (fax_consent_last_set IS NOT NULL)) OR ((fax_consent IS NULL) AND (fax_consent_last_set IS NULL)))),
    CONSTRAINT letter_consent_present_congruent_with_lastset CHECK ((((letter_consent IS NOT NULL) AND (letter_consent_last_set IS NOT NULL)) OR ((letter_consent IS NULL) AND (letter_consent_last_set IS NULL)))),
    CONSTRAINT telephone_consent_present_congruent_with_lastset CHECK ((((telephone_consent IS NOT NULL) AND (telephone_consent_last_set IS NOT NULL)) OR ((telephone_consent IS NULL) AND (telephone_consent_last_set IS NULL)))),
    CONSTRAINT visit_consent_present_congruent_with_lastset CHECK ((((visit_consent IS NOT NULL) AND (visit_consent_last_set IS NOT NULL)) OR ((visit_consent IS NULL) AND (visit_consent_last_set IS NULL))))
);


--
-- Name: TABLE channel_consent; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON TABLE channel_consent IS 'Contains information about the contact consents for a specific person';


--
-- Name: COLUMN channel_consent.person_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN channel_consent.person_id IS 'The unique ID of a person';


--
-- Name: COLUMN channel_consent.consent_status; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN channel_consent.consent_status IS 'Whether or not the person has given his consent (yet)';


--
-- Name: COLUMN channel_consent.consent_status_last_set; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN channel_consent.consent_status_last_set IS 'The date the consent status was changed for the last time';


--
-- Name: COLUMN channel_consent.email_consent; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN channel_consent.email_consent IS 'Whether or not the person wants to be contacted over email';


--
-- Name: COLUMN channel_consent.email_consent_last_set; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN channel_consent.email_consent_last_set IS 'The date the email consent changed for the last time';


--
-- Name: COLUMN channel_consent.telephone_consent; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN channel_consent.telephone_consent IS 'Whether or not the person wants to be contacted over phone';


--
-- Name: COLUMN channel_consent.telephone_consent_last_set; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN channel_consent.telephone_consent_last_set IS 'The date the telephone consent changed for the last time';


--
-- Name: COLUMN channel_consent.fax_consent; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN channel_consent.fax_consent IS 'Whether or not the person wants to be contacted over fax';


--
-- Name: COLUMN channel_consent.fax_consent_last_set; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN channel_consent.fax_consent_last_set IS 'The date the fax consent changed for the last time';


--
-- Name: COLUMN channel_consent.visit_consent; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN channel_consent.visit_consent IS 'Whether or not the person wants to be visited';


--
-- Name: COLUMN channel_consent.visit_consent_last_set; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN channel_consent.visit_consent_last_set IS 'The date the visit consent changed for the last time';


--
-- Name: COLUMN channel_consent.letter_consent; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN channel_consent.letter_consent IS 'Whether or not the person wants to receive information with letter';


--
-- Name: COLUMN channel_consent.letter_consent_last_set; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN channel_consent.letter_consent_last_set IS 'The date the letter consent changed for the last time';


SET search_path = production, pg_catalog;

--
-- Name: compensation; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS compensation (
    id uuid NOT NULL,
    name text NOT NULL,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT compensation_state_check CHECK ((state = ANY (ARRAY['ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: consent_artifact; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS consent_artifact (
    id uuid NOT NULL,
    name character varying NOT NULL,
    state text DEFAULT 'ACTIVE'::text,
    consent_artifact_group_id uuid,
    description text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT consent_artifact_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: consent_artifact_group; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS consent_artifact_group (
    id uuid NOT NULL,
    name character varying NOT NULL,
    state text DEFAULT 'ACTIVE'::text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT consent_artifact_group_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: consent_document; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS consent_document (
    id uuid NOT NULL,
    document_type text NOT NULL,
    document_version character varying NOT NULL,
    edited boolean NOT NULL,
    issuer_id uuid NOT NULL,
    issuer_type character varying NOT NULL,
    signer_id uuid NOT NULL,
    signer_type character varying NOT NULL,
    signed date NOT NULL,
    received timestamp without time zone NOT NULL,
    processed timestamp without time zone NOT NULL,
    state character varying DEFAULT 'ACTIVE'::character varying,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT consent_document_document_type_check CHECK ((document_type = ANY (ARRAY['CONTACT'::text, 'EFPIA'::text]))),
    CONSTRAINT consent_document_document_type_check1 CHECK ((document_type = ANY (ARRAY['CONTACT'::text, 'FSA'::text])))
);


--
-- Name: TABLE consent_document; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON TABLE consent_document IS 'Contains information about a signed consent document';


--
-- Name: COLUMN consent_document.id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document.id IS 'The unique ID of a single instance of a signed document';


--
-- Name: COLUMN consent_document.document_type; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document.document_type IS 'The type of a document';


--
-- Name: COLUMN consent_document.document_version; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document.document_version IS 'The version of that document type';


--
-- Name: COLUMN consent_document.edited; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document.edited IS 'Whether or not the document was somehow modified or edited before being signed';


--
-- Name: COLUMN consent_document.issuer_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document.issuer_id IS 'The unique ID of the person who gave the document to another person';


--
-- Name: COLUMN consent_document.issuer_type; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document.issuer_type IS 'The type of the person who gave away the document';


--
-- Name: COLUMN consent_document.signer_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document.signer_id IS 'The unique ID of of the person who received/signed the document';


--
-- Name: COLUMN consent_document.signer_type; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document.signer_type IS 'The type of the person who received/signed the document';


--
-- Name: COLUMN consent_document.signed; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document.signed IS 'The date this document was signed';


--
-- Name: COLUMN consent_document.received; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document.received IS 'The date this document was received by Docubyte';


--
-- Name: COLUMN consent_document.processed; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document.processed IS 'The date this document was processed by Docubyte';


--
-- Name: COLUMN consent_document.state; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document.state IS 'The state of this document';


SET search_path = production, pg_catalog;

--
-- Name: contract_partner_function; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS contract_partner_function (
    id uuid NOT NULL,
    name text,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT contract_partner_function_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: contract_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS contract_type (
    id uuid NOT NULL,
    name text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    document_id uuid,
    customer_reference text,
    CONSTRAINT contract_type_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: country; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS country (
    id uuid NOT NULL,
    name text,
    state text DEFAULT 'ACTIVE'::text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT country_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: discussed_topic; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS discussed_topic (
    activity_id uuid NOT NULL,
    topic_id uuid NOT NULL,
    sequence integer NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: efpia_consent; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS efpia_consent (
    id integer NOT NULL,
    person_id uuid NOT NULL,
    consent_document_id uuid,
    state text DEFAULT 'ACTIVE'::text,
    consent_document_status text,
    consent_document_status_last_set timestamp with time zone,
    value boolean,
    value_last_set timestamp with time zone,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    consent_document_signed_at date,
    CONSTRAINT efpia_consent_consent_document_status_check CHECK ((consent_document_status = ANY (ARRAY['AWAITING_FEEDBACK'::text, 'REJECTED'::text, 'SIGNED'::text])))
);


--
-- Name: TABLE efpia_consent; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON TABLE efpia_consent IS 'Contains information about the contact consents for a specific person';


--
-- Name: COLUMN efpia_consent.person_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_consent.person_id IS 'The unique ID of a person';


--
-- Name: COLUMN efpia_consent.consent_document_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_consent.consent_document_id IS 'The unique ID of a specific document instance, signed by that person';


--
-- Name: COLUMN efpia_consent.state; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_consent.state IS 'The state of the consent container';


--
-- Name: COLUMN efpia_consent.consent_document_status; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_consent.consent_document_status IS 'The status of the EFPIA document';


--
-- Name: COLUMN efpia_consent.consent_document_status_last_set; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_consent.consent_document_status_last_set IS 'Timestamp the document status was set for the last time';


--
-- Name: COLUMN efpia_consent.value; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_consent.value IS 'Whether or not a person has agreed to EFPIA or not';


--
-- Name: COLUMN efpia_consent.value_last_set; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_consent.value_last_set IS 'Timestamp the ';


SET search_path = production, pg_catalog;

--
-- Name: efpia_history; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS efpia_history (
    id integer NOT NULL,
    person_id uuid NOT NULL,
    history_date timestamp without time zone NOT NULL,
    type text NOT NULL,
    old_value text,
    new_value text NOT NULL,
    changed_by_name text,
    changed_by_id uuid,
    changed_by_source text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT efpia_history_type_check CHECK ((type = ANY (ARRAY['DOCUMENT'::text, 'ARTIFACT'::text, 'MERGE'::text])))
);


--
-- Name: TABLE efpia_history; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON TABLE efpia_history IS 'Contains the history of a specific history item type for a single person';


--
-- Name: COLUMN efpia_history.person_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_history.person_id IS 'The reference to a person';


--
-- Name: COLUMN efpia_history.history_date; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_history.history_date IS 'The date this entry was created';


--
-- Name: COLUMN efpia_history.type; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_history.type IS 'The type of this entry (e.g. which consent changed)';


--
-- Name: COLUMN efpia_history.old_value; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_history.old_value IS 'The previous value for a specific consent';


--
-- Name: COLUMN efpia_history.new_value; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_history.new_value IS 'The new value for a specific consent';


--
-- Name: COLUMN efpia_history.changed_by_name; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_history.changed_by_name IS 'The name of the person who performed the change';


--
-- Name: COLUMN efpia_history.changed_by_source; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN efpia_history.changed_by_source IS 'Contains the source system which triggered the change';


SET search_path = production, pg_catalog;

--
-- Name: employee_department; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS employee_department (
    id uuid NOT NULL,
    name text,
    state text DEFAULT 'ACTIVE'::text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT employee_department_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: employee_function; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS employee_function (
    id uuid NOT NULL,
    name text,
    state text DEFAULT 'ACTIVE'::text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT employee_function_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: event; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event (
    id uuid NOT NULL,
    creator_id uuid,
    person_in_charge_id uuid,
    event_type_id uuid NOT NULL,
    name text NOT NULL,
    description text,
    customer_reference text,
    event_location_id uuid,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    planned_budget_total numeric,
    planned_budget_total_currency text,
    planned_employee_attendees integer,
    planned_customer_attendees integer,
    planned_speakers integer,
    organizer_person_id uuid,
    certified_event boolean,
    event_contract_partner_person_id uuid,
    event_contract_partner_organization_id uuid,
    budget_allocation_id uuid,
    status_id uuid NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    approval_reason text,
    cancellation_reason text,
    parent_event_id uuid,
    details text,
    planned_sessions integer,
    planned_approver_person_id uuid,
    contract_type_id uuid,
    planned_regions integer,
    planned_sessions_per_region integer,
    contract_downloaded_at timestamp with time zone,
    contract_downloaded_by_person_id uuid,
    contract_uploaded_at timestamp with time zone,
    contract_uploaded_by_person_id uuid,
    payment_closed boolean,
    external_link text,
    objective text,
    requesting_country_id uuid,
    requesting_person_id uuid,
    comment text,
    planned_clinic_physicians integer,
    planned_practitioners integer,
    planned_experts integer,
    planned_journalists integer,
    reach text,
    planned_accommodation_expenses_pp numeric,
    planned_accommodation_expenses_pp_currency text,
    planned_traveling_expenses_pp numeric,
    planned_traveling_expenses_pp_currency text,
    planned_registration_fee_pp numeric,
    planned_registration_fee_pp_currency text,
    creator_organizational_unit_id uuid,
    person_in_charge_organizational_unit_id uuid,
    organizer_organizational_unit_id uuid,
    CONSTRAINT event_reach_type CHECK ((reach = ANY (ARRAY['NATIONAL'::text, 'EUROPE'::text, 'INTERNATIONAL'::text]))),
    CONSTRAINT event_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: event_to_organizing_organization; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_to_organizing_organization (
    event_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    sequence integer NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: event_attendee; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_attendee (
    event_id uuid NOT NULL,
    person_id uuid NOT NULL,
    invited_by uuid,
    guest boolean DEFAULT false NOT NULL,
    guest_name text,
    invitation_status text,
    participation_status text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    fee numeric,
    fee_currency text,
    contract_type_id uuid,
    planned_sessions integer,
    contract_date timestamp with time zone,
    contract_sent_by_person_id uuid,
    planned_session_fee numeric,
    planned_session_fee_currency text,
    CONSTRAINT event_attendee_fee_chk CHECK ((((fee IS NULL) AND (fee_currency IS NULL)) OR ((fee IS NOT NULL) AND (fee_currency IS NOT NULL))))
);


SET search_path = production, pg_catalog;

--
-- Name: event_budget_allocation_detail; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_budget_allocation_detail (
    id uuid NOT NULL,
    event_id uuid NOT NULL,
    name text NOT NULL,
    percent integer,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: event_co_organizer; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_co_organizer (
    event_id uuid NOT NULL,
    person_id uuid NOT NULL,
    participation_status text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    organizational_unit_id uuid
);


SET search_path = production, pg_catalog;

--
-- Name: event_compensation; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_compensation (
    event_id uuid NOT NULL,
    compensation_id uuid NOT NULL,
    confirmed boolean DEFAULT false,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: event_contract_partner_function; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_contract_partner_function (
    event_id uuid NOT NULL,
    partner_function_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: cost_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS cost_type (
    id uuid NOT NULL,
    name text,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    single_person_usable boolean,
    event_usable boolean,
    customer_reference text,
    inquiry_usable boolean,
    CONSTRAINT event_cost_type_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: COLUMN cost_type.single_person_usable; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN cost_type.single_person_usable IS 'TRUE: cost-type can be used to declare costs for a single person; FALSE or NULL: it cannot be used';


--
-- Name: COLUMN cost_type.event_usable; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN cost_type.event_usable IS 'TRUE: cost-type can be used to declare costs for an entire event; FALSE or NULL: it cannot be used';


SET search_path = production, pg_catalog;

--
-- Name: event_employee_attendee; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_employee_attendee (
    event_id uuid NOT NULL,
    person_id uuid NOT NULL,
    invitation_status text,
    participation_status text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    invited_by uuid,
    CONSTRAINT event_employee_attendee_check CHECK ((((invitation_status IS NULL) OR (invitation_status = ANY (ARRAY['INVITED'::text, 'ACCEPTED'::text, 'REJECTED'::text]))) AND ((participation_status IS NULL) OR (participation_status = ANY (ARRAY['PARTICIPATED'::text, 'NO_SHOW'::text, 'CANCELED'::text])))))
);


SET search_path = production, pg_catalog;

--
-- Name: event_indication_area; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_indication_area (
    event_id uuid NOT NULL,
    indication_area_id uuid NOT NULL,
    last_modification timestamp with time zone,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: event_speaker; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_speaker (
    event_id uuid NOT NULL,
    person_id uuid NOT NULL,
    fee numeric,
    fee_currency text,
    description text,
    contract_date timestamp with time zone,
    contract_sent_by_person_id uuid,
    participation_status text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    contract_type_id uuid,
    lecture_topic text,
    number_of_lectures integer,
    invitation_status text,
    CONSTRAINT event_speaker_invitation_status_check CHECK (((invitation_status IS NULL) OR (invitation_status = ANY (ARRAY['INVITED'::text, 'ACCEPTED'::text, 'REJECTED'::text]))))
);


SET search_path = production, pg_catalog;

--
-- Name: event_status; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_status (
    id uuid NOT NULL,
    name text NOT NULL,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    base_status text,
    CONSTRAINT event_status_base_status_check CHECK ((base_status = ANY (ARRAY['PLANNED'::text, 'CANCELED'::text, 'CLOSED'::text]))),
    CONSTRAINT event_status_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: event_subject; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_subject (
    id uuid NOT NULL,
    name text NOT NULL,
    event_subject_group_id uuid NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT event_subject_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: event_to_event_subject; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_to_event_subject (
    event_id uuid NOT NULL,
    event_subject_id uuid NOT NULL,
    sequence integer NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: event_target_audience; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_target_audience (
    event_id uuid NOT NULL,
    target_audience_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: event_topic; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_topic (
    event_id uuid NOT NULL,
    topic_id uuid NOT NULL,
    sequence integer NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: topic; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS topic (
    id uuid NOT NULL,
    name text NOT NULL,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT topic_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: event_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_type (
    id uuid NOT NULL,
    name text NOT NULL,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT event_type_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: COLUMN event_type.id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN event_type.id IS 'The unique ID of an event type';


--
-- Name: COLUMN event_type.name; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN event_type.name IS 'The name of an event type';


--
-- Name: COLUMN event_type.state; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN event_type.state IS 'The state of an event type';


SET search_path = production, pg_catalog;

--
-- Name: expense; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS expense (
    id uuid NOT NULL,
    name text NOT NULL,
    expense_limit_altering boolean NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT expense_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: expense_activity_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS expense_activity_type (
    expense_id uuid NOT NULL,
    activity_type_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: id_translation; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS id_translation (
    id bigint NOT NULL,
    aggregate_id uuid NOT NULL,
    aggregate_id_type text NOT NULL,
    value_object_id uuid,
    value_object_id_type text,
    external_reference_id uuid NOT NULL,
    external_reference_value text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


SET search_path = production, pg_catalog;

--
-- Name: incurred_expense; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS incurred_expense (
    id uuid NOT NULL,
    activity_id uuid NOT NULL,
    expense_id uuid NOT NULL,
    cost_value numeric NOT NULL,
    cost_currency text NOT NULL,
    description text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: indication_area; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS indication_area (
    id uuid NOT NULL,
    name text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT indication_area_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: inventory; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS inventory (
    id uuid NOT NULL,
    person_id uuid NOT NULL,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT inventory_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: list; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS list (
    id uuid NOT NULL,
    type text NOT NULL,
    name text NOT NULL,
    description text,
    creator_person_id uuid NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    interval_type text NOT NULL,
    CONSTRAINT list_interval_type_check CHECK ((interval_type = ANY (ARRAY['NONE'::text, 'LAST_WEEK'::text, 'LAST_MONTH'::text, 'LAST_3_MONTHS'::text, 'LAST_6_MONTHS'::text, 'LAST_YEAR'::text, 'CURRENT_YEAR'::text, 'CUSTOM_INTERVAL'::text]))),
    CONSTRAINT list_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text]))),
    CONSTRAINT list_type_check CHECK (((type = 'PERSON'::text) OR (type = 'ORGANIZATION'::text) OR (type = 'TERRITORY'::text)))
);


SET search_path = production, pg_catalog;

--
-- Name: marketing_material; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS marketing_material (
    id uuid NOT NULL,
    name text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT marketing_material_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: merged_organization; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS merged_organization (
    target_organization_id uuid NOT NULL,
    target_customer_number character varying,
    source_organization_id uuid NOT NULL,
    source_customer_number character varying,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: merged_person; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS merged_person (
    target_person_id uuid NOT NULL,
    source_person_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    target_customer_number character varying,
    source_customer_number character varying
);


SET search_path = production, pg_catalog;

--
-- Name: organizational_unit; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organizational_unit (
    id uuid NOT NULL,
    materialized_path uuid[] NOT NULL,
    name text NOT NULL,
    organizational_unit_type_id uuid NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    organizational_hierarchy_id uuid,
    customer_reference text
);


--
-- Name: organizational_unit_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organizational_unit_type (
    id uuid NOT NULL,
    name text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text
);


--
-- Name: person_assignment; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person_assignment (
    id uuid NOT NULL,
    organizational_hierarchy_id uuid NOT NULL,
    person_id uuid NOT NULL,
    organizational_unit_id uuid NOT NULL,
    person_assignment_type_id uuid NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    stand_in_person_id uuid,
    stand_in_active boolean,
    start_date date,
    end_date date,
    target_attribute_id uuid,
    detail_attribute_id uuid,
    is_primary boolean DEFAULT false
);


--
-- Name: sec_user; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS sec_user (
    id uuid NOT NULL,
    tenant_id uuid,
    user_name text,
    email text,
    password_salt text,
    password_hash text,
    person_id uuid,
    state text DEFAULT 'ACTIVE'::text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    tenant_authentication_id uuid,
    ldap_password_hash text,
    ldap_password_salt text,
    type text DEFAULT 'STANDARD'::text NOT NULL,
    password_expiration_notification_sent_at timestamp with time zone,
    login_expiration_notification_sent_at timestamp with time zone,
    CONSTRAINT sec_user_type_check CHECK ((type = ANY (ARRAY['STANDARD'::text, 'ADMIN'::text, 'SYSTEM'::text]))),
    CONSTRAINT user_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: COLUMN sec_user.password_expiration_notification_sent_at; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN sec_user.password_expiration_notification_sent_at IS 'The last time the user was sent an email that their account is due to expire due to not changing their password.';


--
-- Name: COLUMN sec_user.login_expiration_notification_sent_at; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN sec_user.login_expiration_notification_sent_at IS 'The last time the user was sent an email that their account is due to expire dur to not logging in.';


SET search_path = production, pg_catalog;

--
-- Name: organization_relation_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organization_relation_type (
    id uuid NOT NULL,
    source_name text NOT NULL,
    target_name text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT organization_relation_type_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: organization_address_to_territory; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organization_address_to_territory (
    organization_address_id uuid NOT NULL,
    territory_id uuid NOT NULL
);


SET search_path = production, pg_catalog;

--
-- Name: organizational_unit_version; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organizational_unit_version (
    id bigint NOT NULL,
    organizational_unit_id uuid NOT NULL,
    organizational_hierarchy_id uuid NOT NULL,
    name text NOT NULL,
    organizational_unit_type_id uuid NOT NULL,
    customer_reference text,
    materialized_path uuid[] NOT NULL,
    state text,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    CONSTRAINT organizational_unit_version_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: organization_attribute_value; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organization_attribute_value (
    id uuid NOT NULL,
    attribute_id uuid,
    organization_id uuid,
    value text,
    last_modification timestamp with time zone,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: organization_relation; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organization_relation (
    id uuid NOT NULL,
    source_organization_id uuid NOT NULL,
    target_organization_id uuid NOT NULL,
    organization_relation_type_id uuid NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT organization_relation_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: organization_assignment; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organization_assignment (
    id uuid NOT NULL,
    organizational_hierarchy_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    organizational_unit_id uuid NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    assignment_type text,
    CONSTRAINT organization_assignment_assignment_type_check CHECK ((assignment_type = ANY (ARRAY['MANUAL'::text, 'CALCULATED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: organization_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organization_type (
    id uuid NOT NULL,
    name text,
    state text DEFAULT 'ACTIVE'::text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    base_type text,
    customer_reference text,
    CONSTRAINT organization_type_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: organization_to_organization_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organization_to_organization_type (
    organization_id uuid NOT NULL,
    organization_type_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: organizational_unit_tag; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organizational_unit_tag (
    tag text NOT NULL,
    organizational_unit_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: participation_reason; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS participation_reason (
    id uuid NOT NULL,
    name text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT participation_reason_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: person_address; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person_address (
    id uuid NOT NULL,
    person_id uuid,
    address_1 text,
    address_2 text,
    address_3 text,
    postal_code text,
    city text,
    federal_state text,
    post_box text,
    country_id uuid,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    latitude double precision,
    longitude double precision,
    address_type text NOT NULL,
    CONSTRAINT person_address_check_address_type CHECK ((address_type = ANY (ARRAY['STANDARD'::text, 'VISIT'::text, 'DELIVERY'::text, 'LEGAL'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: person_assignment_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person_assignment_type (
    id uuid NOT NULL,
    name text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    base_type text DEFAULT 'BACK_OFFICE'::text NOT NULL,
    customer_reference text,
    CONSTRAINT person_assignment_type_base_type_check CHECK ((base_type = ANY (ARRAY['BACK_OFFICE'::text, 'FIELD_SERVICE'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: person_assignment_version; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person_assignment_version (
    id bigint NOT NULL,
    person_assignment_id uuid NOT NULL,
    person_id uuid NOT NULL,
    organizational_unit_id uuid NOT NULL,
    organizational_hierarchy_id uuid NOT NULL,
    state text NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: person_communication_data; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person_communication_data (
    id uuid NOT NULL,
    person_id uuid,
    communication_data_type_id uuid,
    value text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: person_consent_artifact; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person_consent_artifact (
    person_id uuid NOT NULL,
    consent_artifact_id uuid NOT NULL,
    value boolean NOT NULL,
    last_changed timestamp with time zone NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: person_work_journal_entry; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person_work_journal_entry (
    person_id uuid NOT NULL,
    date date NOT NULL,
    sequence_number integer NOT NULL,
    type text NOT NULL,
    ratio integer,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT person_work_journal_entry_type_check CHECK ((type = ANY (ARRAY['VACATION'::text, 'SICK_LEAVE'::text, 'CUSTOMER_CONTACT'::text, 'CUSTOMER_CONTACT_NEW_CHANNEL'::text, 'MEETING'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: person_speciality_group; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person_speciality_group (
    person_id uuid NOT NULL,
    speciality_group_id uuid,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: person_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person_type (
    id uuid NOT NULL,
    name text,
    state text DEFAULT 'ACTIVE'::text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    fsa_relevant boolean DEFAULT false NOT NULL,
    base_type text,
    customer_reference text,
    CONSTRAINT person_type_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: person_attribute_value; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person_attribute_value (
    id uuid NOT NULL,
    attribute_id uuid,
    person_id uuid,
    value text,
    last_modification timestamp with time zone,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    attribute_option_id uuid
);


SET search_path = production, pg_catalog;

--
-- Name: person_speciality; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person_speciality (
    id uuid NOT NULL,
    person_id uuid,
    speciality_id uuid,
    weight real,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: person_to_person_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person_to_person_type (
    person_id uuid NOT NULL,
    person_type_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: personal_email; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS personal_email (
    id uuid NOT NULL,
    template_instance_id uuid NOT NULL,
    sender uuid NOT NULL,
    receiver uuid NOT NULL,
    receiver_email character varying NOT NULL,
    subject character varying NOT NULL,
    state character varying DEFAULT 'ACTIVE'::character varying,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    organizational_unit_id uuid,
    sent_at timestamp with time zone
);


SET search_path = production, pg_catalog;

--
-- Name: personal_email_activity; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS personal_email_activity (
    id uuid NOT NULL,
    personal_email_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    activity_type_id uuid NOT NULL,
    state character varying DEFAULT 'ACTIVE'::character varying,
    batch_id uuid,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: personal_email_activity_topic; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS personal_email_activity_topic (
    personal_email_activity_id uuid NOT NULL,
    topic_id uuid NOT NULL
);


SET search_path = production, pg_catalog;

--
-- Name: postal_code_city; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS postal_code_city (
    id uuid NOT NULL,
    postal_code text NOT NULL,
    city text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT postal_code_city_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: product; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS product (
    id uuid NOT NULL,
    name text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    pzn text,
    customer_reference text,
    CONSTRAINT product_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: product_license_date; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS product_license_date (
    product_id uuid NOT NULL,
    license_date date NOT NULL
);


SET search_path = production, pg_catalog;

--
-- Name: promotional_material_rule; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS promotional_material_rule (
    promotional_material_id uuid NOT NULL,
    valid_from date,
    valid_to date,
    id uuid NOT NULL,
    rule_type rule_type NOT NULL,
    end_date date,
    max_quantity_per_activity integer,
    max_quantity_per_year integer,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT promotional_material_rule_valid CHECK (((rule_type = ANY (ARRAY['MAX_QUANTITY_PER_YEAR'::rule_type, 'MAX_QUANTITY_PER_ACTIVITY'::rule_type, 'PROMOTIONAL_MATERIAL_END_DATE'::rule_type, 'TEMPORARILY_UNAVAILABLE'::rule_type])) AND (((rule_type = 'MAX_QUANTITY_PER_YEAR'::rule_type) AND (max_quantity_per_year IS NOT NULL) AND (max_quantity_per_year >= 0)) OR ((rule_type = 'MAX_QUANTITY_PER_ACTIVITY'::rule_type) AND (max_quantity_per_activity IS NOT NULL) AND (max_quantity_per_activity >= 0)) OR ((rule_type = 'PROMOTIONAL_MATERIAL_END_DATE'::rule_type) AND (end_date IS NOT NULL)) OR (rule_type = 'TEMPORARILY_UNAVAILABLE'::rule_type))))
);


SET search_path = production, pg_catalog;

--
-- Name: promotional_material_topic; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS promotional_material_topic (
    promotional_material_id uuid NOT NULL,
    topic_id uuid NOT NULL
);


SET search_path = production, pg_catalog;

--
-- Name: speaker; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS speaker (
    id uuid NOT NULL,
    speaker_person_id uuid NOT NULL,
    creator_person_id uuid NOT NULL,
    person_in_charge_id uuid NOT NULL,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT speaker_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: speciality_to_speciality_group; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS speciality_to_speciality_group (
    speciality_id uuid NOT NULL,
    priority text NOT NULL,
    speciality_group_id uuid,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: speciality_group; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS speciality_group (
    id uuid NOT NULL,
    name text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT speciality_group_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: speciality; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS speciality (
    id uuid NOT NULL,
    name text,
    classification text DEFAULT 'HF'::text,
    state text DEFAULT 'ACTIVE'::text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT speciality_classification_check CHECK ((classification = ANY (ARRAY['HF'::text, 'ZF'::text, 'SP'::text]))),
    CONSTRAINT speciality_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: stock; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS stock (
    id uuid NOT NULL,
    inventory_id uuid NOT NULL,
    promotional_material_id uuid NOT NULL,
    quantity integer,
    type text,
    reset_before_transaction_number integer,
    next_transaction_number integer,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT stock_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text]))),
    CONSTRAINT stock_type_check CHECK ((type = ANY (ARRAY['PHYSICAL'::text, 'VIRTUAL'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: event_subject_group; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_subject_group (
    id uuid NOT NULL,
    name text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT event_subject_group_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


SET search_path = production, pg_catalog;

--
-- Name: template; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS template (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    name character varying NOT NULL,
    description character varying,
    type character varying NOT NULL,
    state character varying DEFAULT 'ACTIVE'::character varying,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    start_date date,
    end_date date,
    CONSTRAINT template_type_check CHECK (((type)::text = ANY ((ARRAY['NEWSLETTER'::character varying, 'E_CARD'::character varying, 'CONSENT_SIGNATURE'::character varying, 'SYSTEM'::character varying, 'TO_DO'::character varying, 'STOCK_DISTRIBUTION'::character varying, 'APPROVAL'::character varying])::text[])))
);


--
-- Name: template_version; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS template_version (
    id uuid NOT NULL,
    version_id bigint NOT NULL,
    template_id uuid NOT NULL,
    document_id uuid,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    mandatory_tracking_token text[],
    optional_tracking_token text[]
);


SET search_path = production, pg_catalog;

--
-- Name: template_instance; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS template_instance (
    id uuid NOT NULL,
    template_version_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


SET search_path = production, pg_catalog;

--
-- Name: activity_type_dispatch_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS activity_type_dispatch_type (
    dispatch_type text NOT NULL,
    activity_type_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT activity_type_dispatch_type_dispatch_type_check CHECK ((dispatch_type = ANY (ARRAY['FAX'::text, 'MAIL'::text, 'EMAIL'::text, 'MANUAL'::text, 'DISTRIBUTION_CENTER'::text])))
);


--
-- Name: activity_type_rule; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS activity_type_rule (
    activity_type_id uuid NOT NULL,
    valid_from date,
    valid_to date,
    min integer,
    max integer
);


--
-- Name: appointment_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS appointment_type (
    id uuid NOT NULL,
    name text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT appointment_type_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: approval_backup; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS approval_backup (
    id uuid,
    object_id uuid,
    object_id_type text,
    approval_status text,
    requested_at timestamp with time zone,
    decided_at timestamp with time zone,
    decision_reason text
);


--
-- Name: approval_batch_approver; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS approval_batch_approver (
    approval_batch_id uuid NOT NULL,
    person_id uuid NOT NULL,
    type text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    organizational_unit_id uuid,
    CONSTRAINT approval_batch_approver_type_check CHECK ((type = ANY (ARRAY['SELECTED_APPROVER'::text, 'ACTING_APPROVER'::text])))
);


--
-- Name: attachment; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS attachment (
    id uuid NOT NULL,
    object_id uuid NOT NULL,
    object_id_type text NOT NULL,
    type text NOT NULL,
    document_id uuid NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    valid_to timestamp with time zone,
    sub_object_id uuid,
    sub_object_id_type text,
    CONSTRAINT attachment_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: attribute_assignment; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS attribute_assignment (
    id uuid NOT NULL,
    organizational_unit_id uuid NOT NULL,
    attribute_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: attribute_assignment_permission_tag; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS attribute_assignment_permission_tag (
    type text,
    attribute_assignment_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT attribute_assignment_permission_tag_type_check CHECK ((type = ANY (ARRAY['READ'::text, 'WRITE'::text, 'ASSIGN'::text])))
);


--
-- Name: attribute_change_reason; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS attribute_change_reason (
    reason text NOT NULL,
    attribute_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: channel_consent_id_seq; Type: SEQUENCE; Schema: production; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS channel_consent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: channel_consent_id_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: build
--

ALTER SEQUENCE channel_consent_id_seq OWNED BY channel_consent.id;


--
-- Name: client_permission; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS client_permission (
    id uuid NOT NULL,
    permission text NOT NULL,
    description text NOT NULL
);


--
-- Name: compensation_event_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS compensation_event_type (
    compensation_id uuid NOT NULL,
    event_type_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: consent_document_fields; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS consent_document_fields (
    consent_document_id uuid NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL
);


--
-- Name: TABLE consent_document_fields; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON TABLE consent_document_fields IS 'Contains information about fields found on a consent document (like firstName, lastName)';


--
-- Name: COLUMN consent_document_fields.consent_document_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document_fields.consent_document_id IS 'Reference to the containing document (the document this field is
defined at)';


--
-- Name: COLUMN consent_document_fields.name; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document_fields.name IS 'The name of the field (like firstName, lastName)';


--
-- Name: COLUMN consent_document_fields.value; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document_fields.value IS 'The value found inside this field';


--
-- Name: consent_document_options; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS consent_document_options (
    consent_document_id uuid NOT NULL,
    name character varying NOT NULL,
    value boolean NOT NULL
);


--
-- Name: TABLE consent_document_options; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON TABLE consent_document_options IS 'Contains information about the options (checkboxes) found on a consent document';


--
-- Name: COLUMN consent_document_options.consent_document_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document_options.consent_document_id IS 'Reference to the containing document (the document this option is
defined at)';


--
-- Name: COLUMN consent_document_options.name; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document_options.name IS 'The name of the option (like werbung, produktNeuigkeiten)';


--
-- Name: COLUMN consent_document_options.value; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_document_options.value IS 'The value of this option';


--
-- Name: consent_history; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS consent_history (
    id bigint NOT NULL,
    person_id uuid NOT NULL,
    changed_at timestamp with time zone NOT NULL,
    changed_by_id uuid,
    changed_by_source text,
    email_address text,
    email_consent boolean,
    visit_consent boolean,
    telephone_consent boolean,
    fax_consent boolean,
    letter_consent boolean,
    reset_reason text,
    consent_document_id uuid,
    consent_artifact_ids uuid[],
    consent_document_status text,
    change_type text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    document_signed_at date,
    consent_transferred boolean,
    source_person_id uuid,
    CONSTRAINT new_consent_history_change_type_check CHECK ((change_type = ANY (ARRAY['COLLECT'::text, 'DOCUMENT'::text, 'EDIT'::text, 'RESET'::text, 'MERGE'::text]))),
    CONSTRAINT new_consent_history_consent_document_status_check CHECK (((consent_document_status IS NULL) OR (consent_document_status = ANY (ARRAY['REJECTED'::text, 'AWAITING_FEEDBACK'::text, 'SIGNED'::text]))))
);


--
-- Name: COLUMN consent_history.change_type; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_history.change_type IS 'COLLECT: Consent was collected from a physician,
 EDIT: The existing consent values were changed but the source should not change in the UI,
 RESET: The existing consent was revoked';


--
-- Name: COLUMN consent_history.consent_transferred; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_history.consent_transferred IS 'True if the consent info was transferred from the source person to the target person and false otherwise. ';


--
-- Name: COLUMN consent_history.source_person_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN consent_history.source_person_id IS 'Source PersonId for the consent merge entry.';


--
-- Name: consent_history_id_seq; Type: SEQUENCE; Schema: production; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS consent_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: consent_history_id_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: build
--

ALTER SEQUENCE consent_history_id_seq OWNED BY consent_history.id;


--
-- Name: contract_partner_reason; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS contract_partner_reason (
    id uuid NOT NULL,
    name text,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT contract_partner_reason_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: data_permission; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS data_permission (
    id text NOT NULL,
    aggregate text NOT NULL,
    usable_with_data_scopes boolean NOT NULL
);


--
-- Name: data_scope; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS data_scope (
    id uuid NOT NULL,
    name text,
    state text DEFAULT 'ACTIVE'::text,
    CONSTRAINT data_scope_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: data_scope_activity_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS data_scope_activity_type (
    id uuid NOT NULL,
    aggregate_id uuid NOT NULL,
    data_scope_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: data_scope_attribute_category; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS data_scope_attribute_category (
    id uuid NOT NULL,
    aggregate_id uuid NOT NULL,
    data_scope_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: data_scope_empty; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS data_scope_empty (
    id uuid NOT NULL,
    aggregate_id uuid NOT NULL,
    data_scope_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: data_scope_indication_area; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS data_scope_indication_area (
    aggregate_id uuid NOT NULL,
    data_scope_id uuid NOT NULL,
    user_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: data_scope_organization; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS data_scope_organization (
    id uuid NOT NULL,
    aggregate_id uuid NOT NULL,
    data_scope_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: data_scope_person; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS data_scope_person (
    id uuid NOT NULL,
    aggregate_id uuid NOT NULL,
    data_scope_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: data_scope_speaker_request_reason; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS data_scope_speaker_request_reason (
    id uuid NOT NULL,
    aggregate_id uuid NOT NULL,
    data_scope_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: data_scope_to_do; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS data_scope_to_do (
    id uuid NOT NULL,
    aggregate_id uuid NOT NULL,
    data_scope_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: data_scope_wizard_instance; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS data_scope_wizard_instance (
    id uuid NOT NULL,
    aggregate_id uuid NOT NULL,
    data_scope_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: document; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS document (
    id uuid NOT NULL,
    media_type text NOT NULL,
    name text,
    owner_id uuid,
    size bigint,
    hash text,
    created_at timestamp with time zone,
    is_master boolean
);


--
-- Name: efpia_consent_id_seq; Type: SEQUENCE; Schema: production; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS efpia_consent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: efpia_consent_id_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: build
--

ALTER SEQUENCE efpia_consent_id_seq OWNED BY efpia_consent.id;


--
-- Name: efpia_history_id_seq; Type: SEQUENCE; Schema: production; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS efpia_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: efpia_history_id_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: build
--

ALTER SEQUENCE efpia_history_id_seq OWNED BY efpia_history.id;


--
-- Name: employee_address; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS employee_address (
    id uuid NOT NULL,
    employee_id uuid,
    address_1 text,
    address_2 text,
    address_3 text,
    postal_code text,
    city text,
    federal_state text,
    post_box text,
    country_id uuid,
    latitude real,
    longitude real,
    address_type text NOT NULL,
    CONSTRAINT employee_address_check_address_type CHECK ((address_type = ANY (ARRAY['STANDARD'::text, 'VISIT'::text, 'DELIVERY'::text, 'LEGAL'::text])))
);


--
-- Name: employee_communication_data; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS employee_communication_data (
    id uuid NOT NULL,
    employee_id uuid,
    communication_data_type_id uuid,
    value text
);


--
-- Name: event_appointment; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_appointment (
    id uuid NOT NULL,
    event_id uuid NOT NULL,
    appointment_type_id uuid NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: event_attendee_to_participation_reason; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_attendee_to_participation_reason (
    person_id uuid NOT NULL,
    event_id uuid NOT NULL,
    participation_reason_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: event_contract_partner_reason; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_contract_partner_reason (
    event_id uuid NOT NULL,
    reason_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: event_custom_compensation; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_custom_compensation (
    event_id uuid NOT NULL,
    custom_compensation_id uuid NOT NULL,
    name text NOT NULL,
    confirmed boolean,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: event_custom_contract_partner_function; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_custom_contract_partner_function (
    event_id uuid NOT NULL,
    function text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: event_planned_participation_reason; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_planned_participation_reason (
    event_id uuid NOT NULL,
    participation_reason_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: event_type_to_finalization_wizard; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS event_type_to_finalization_wizard (
    event_type_id uuid NOT NULL,
    wizard_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: expense_topic; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS expense_topic (
    expense_id uuid NOT NULL,
    topic_id uuid NOT NULL
);


--
-- Name: export_item; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS export_item (
    id uuid NOT NULL,
    aggregate_id uuid NOT NULL,
    aggregate_class text NOT NULL,
    value_object_id uuid,
    value_object_class text,
    export_target text NOT NULL,
    export_action text NOT NULL,
    export_status text NOT NULL,
    export_id text,
    export_timestamp timestamp without time zone NOT NULL,
    source text NOT NULL
);


--
-- Name: id_translation_id_seq; Type: SEQUENCE; Schema: production; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS id_translation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: id_translation_id_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: build
--

ALTER SEQUENCE id_translation_id_seq OWNED BY id_translation.id;


--
-- Name: inquiry; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS inquiry (
    id uuid NOT NULL,
    creator_id uuid,
    creator_organizational_unit_id uuid,
    name text NOT NULL,
    description text,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    person_in_charge_id uuid,
    person_in_charge_organizational_unit_id uuid,
    contract_partner_person_id uuid,
    contract_partner_organization_id uuid,
    expertise text,
    performance_description text,
    budget_allocation_id uuid,
    comment text,
    status_id uuid NOT NULL,
    approval_reason text,
    cancellation_reason text,
    certified boolean,
    contract_type_id uuid,
    contract_downloaded_at timestamp with time zone,
    contract_downloaded_by_person_id uuid,
    contract_uploaded_at timestamp with time zone,
    contract_uploaded_by_person_id uuid,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text NOT NULL,
    inquiry_compensation_id uuid,
    type_id uuid NOT NULL,
    partner_organization_id uuid,
    CONSTRAINT inquiry_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: inquiry_budget_allocation_detail; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS inquiry_budget_allocation_detail (
    id uuid NOT NULL,
    inquiry_id uuid NOT NULL,
    name text NOT NULL,
    percent integer,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: inquiry_compensation; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS inquiry_compensation (
    inquiry_id uuid NOT NULL,
    id uuid NOT NULL,
    type text NOT NULL,
    amount numeric,
    wage numeric,
    wage_currency text,
    document_id uuid,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT inquiry_compensation_type_check CHECK ((type = ANY (ARRAY['HOURLY'::text, 'DAILY'::text, 'FLAT'::text])))
);


--
-- Name: inquiry_contract_partner_reason; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS inquiry_contract_partner_reason (
    inquiry_id uuid NOT NULL,
    reason_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: inquiry_cost_item; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS inquiry_cost_item (
    id uuid NOT NULL,
    inquiry_id uuid NOT NULL,
    cost_type_id uuid NOT NULL,
    sequence_number integer NOT NULL,
    cost numeric,
    cost_currency text,
    tax numeric,
    tax_currency text,
    invoice_number text,
    invoice_date timestamp with time zone,
    paid_by_person_assignment_id uuid,
    payment_cost_center text,
    payment_status text,
    associated_person_id uuid,
    cost_position_number text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: inquiry_partner_organization_person; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS inquiry_partner_organization_person (
    inquiry_id uuid NOT NULL,
    person_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: inquiry_proof_of_service; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS inquiry_proof_of_service (
    id uuid NOT NULL,
    inquiry_id uuid NOT NULL,
    performed_at timestamp with time zone NOT NULL,
    description text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: inquiry_status; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS inquiry_status (
    id uuid NOT NULL,
    name text NOT NULL,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT inquiry_status_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: inquiry_topic; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS inquiry_topic (
    inquiry_id uuid NOT NULL,
    topic_id uuid NOT NULL,
    sequence integer NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: inquiry_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS inquiry_type (
    id uuid NOT NULL,
    name text NOT NULL,
    customer_reference text,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT inquiry_type_state_check CHECK ((state = ANY (ARRAY['ACTIVE'::text, 'INACTIVE'::text, 'LIMBO'::text, 'DELETED'::text])))
);


--
-- Name: list_condition; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS list_condition (
    id uuid NOT NULL,
    list_id uuid NOT NULL,
    list_condition_definition_id uuid NOT NULL,
    sequence integer NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: list_condition_definition; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS list_condition_definition (
    id uuid NOT NULL,
    type text NOT NULL,
    name text NOT NULL,
    alias text NOT NULL,
    category text NOT NULL,
    resource_type text NOT NULL,
    resource_path text,
    static_criteria jsonb NOT NULL,
    supplier text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT list_condition_definition_category_check CHECK ((category = ANY (ARRAY['MASTER_DATA'::text, 'ATTRIBUTE'::text, 'CONSENT'::text, 'LOCATION_TERRITORY'::text, 'ACTIVITY'::text, 'EVENT'::text]))),
    CONSTRAINT list_condition_definition_resource_type_check CHECK ((resource_type = ANY (ARRAY['SELECTION'::text, 'TEXT'::text, 'NUMBER'::text, 'DATE'::text, 'MULTI_SELECTION'::text, 'BOOLEAN'::text, 'FREQUENCY'::text]))),
    CONSTRAINT list_condition_definition_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text]))),
    CONSTRAINT list_condition_definition_type_check CHECK (((type = 'PERSON'::text) OR (type = 'ORGANIZATION'::text) OR (type = 'TERRITORY'::text)))
);


--
-- Name: list_condition_definition_allowed_operator; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS list_condition_definition_allowed_operator (
    list_condition_definition_id uuid NOT NULL,
    operator text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT list_condition_definition_allowed_operator_operator_check CHECK ((operator = ANY (ARRAY['EQUALS'::text, 'NOT_EQUALS'::text, 'GREATER_THAN'::text, 'GREATER_THAN_EQUALS'::text, 'LESS_THAN'::text, 'LESS_THAN_EQUALS'::text, 'CONTAINS'::text, 'START_WITH'::text, 'END_WITH'::text, 'BETWEEN'::text])))
);


--
-- Name: list_criteria; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS list_criteria (
    id uuid NOT NULL,
    list_condition_id uuid NOT NULL,
    operator text NOT NULL,
    value text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT list_criteria_operator_check CHECK ((operator = ANY (ARRAY['EQUALS'::text, 'NOT_EQUALS'::text, 'GREATER_THAN'::text, 'GREATER_THAN_EQUALS'::text, 'LESS_THAN'::text, 'LESS_THAN_EQUALS'::text, 'CONTAINS'::text, 'START_WITH'::text, 'END_WITH'::text, 'BETWEEN'::text])))
);


--
-- Name: list_field; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS list_field (
    list_id uuid NOT NULL,
    list_field_definition_id uuid NOT NULL,
    sequence integer NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: list_field_definition; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS list_field_definition (
    id uuid NOT NULL,
    type text NOT NULL,
    name text NOT NULL,
    alias text NOT NULL,
    category text NOT NULL,
    sortable boolean NOT NULL,
    static_criteria jsonb NOT NULL,
    supplier text NOT NULL,
    related_condition_definition_id uuid,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT list_field_definition_category_check CHECK ((category = ANY (ARRAY['MASTER_DATA'::text, 'ATTRIBUTE'::text, 'CONSENT'::text, 'LOCATION_TERRITORY'::text, 'ACTIVITY'::text, 'EVENT'::text]))),
    CONSTRAINT list_field_definition_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text]))),
    CONSTRAINT list_field_definition_type_check CHECK (((type = 'PERSON'::text) OR (type = 'ORGANIZATION'::text) OR (type = 'TERRITORY'::text)))
);


--
-- Name: list_owner; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS list_owner (
    list_id uuid NOT NULL,
    user_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: list_sorting; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS list_sorting (
    list_id uuid NOT NULL,
    list_field_definition_id uuid NOT NULL,
    sorting_order text NOT NULL,
    sequence integer NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT list_sorting_sorting_order_check CHECK ((sorting_order = ANY (ARRAY['ASC'::text, 'DESC'::text])))
);


--
-- Name: list_viewer; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS list_viewer (
    list_id uuid NOT NULL,
    user_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: mailing; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS mailing (
    id uuid NOT NULL,
    requester_id uuid,
    requester_department text,
    sent_at timestamp with time zone,
    sent_by text,
    product text,
    target_group text,
    subject text,
    recipient_count integer,
    state text NOT NULL,
    organizational_unit_id uuid,
    CONSTRAINT mailing_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: mailing_attachment; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS mailing_attachment (
    mailing_id uuid NOT NULL,
    document_id uuid NOT NULL
);


--
-- Name: mailing_recipient; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS mailing_recipient (
    mailing_id uuid NOT NULL,
    person_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: notification; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS notification (
    id uuid NOT NULL,
    message text NOT NULL,
    published_at timestamp with time zone
);


--
-- Name: organization_group; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organization_group (
    id uuid NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT organization_group_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: organization_group_organization; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organization_group_organization (
    organization_group_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: organization_outpatient_department; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organization_outpatient_department (
    organization_id uuid NOT NULL,
    name text NOT NULL,
    attributes text[],
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: organizational_hierarchy; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organizational_hierarchy (
    id uuid NOT NULL,
    name text NOT NULL,
    state text NOT NULL,
    root_id uuid,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: organizational_unit_to_list; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS organizational_unit_to_list (
    organizational_unit_id uuid NOT NULL,
    list_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: organizational_unit_version_id_seq; Type: SEQUENCE; Schema: production; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS organizational_unit_version_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizational_unit_version_id_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: build
--

ALTER SEQUENCE organizational_unit_version_id_seq OWNED BY organizational_unit_version.id;


--
-- Name: password_policy; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS password_policy (
    tenant_id uuid NOT NULL,
    allowed_unsucessful_login_attempts integer,
    password_reuse_rotations integer,
    min_password_duration interval,
    max_password_duration interval,
    max_inactive_duration interval,
    expiration_notification_window interval,
    required_length integer,
    required_alphanumeric integer,
    required_lowercase integer,
    required_uppercase integer,
    required_digit integer,
    required_other integer
);


--
-- Name: COLUMN password_policy.allowed_unsucessful_login_attempts; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN password_policy.allowed_unsucessful_login_attempts IS 'The number of times a user may enter an incorrect password before their account is disabled.';


--
-- Name: COLUMN password_policy.password_reuse_rotations; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN password_policy.password_reuse_rotations IS 'The number of times a user must change their password away from a particular password before they may reuse that password.';


--
-- Name: COLUMN password_policy.min_password_duration; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN password_policy.min_password_duration IS 'The minimum time that must pass since a user changed their password before they may change it again.';


--
-- Name: COLUMN password_policy.max_password_duration; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN password_policy.max_password_duration IS 'The maximum time that a user may have a password before their account is disabled.';


--
-- Name: COLUMN password_policy.max_inactive_duration; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN password_policy.max_inactive_duration IS 'The maximum time that a user may not have logged in for before account is disabled.';


--
-- Name: COLUMN password_policy.expiration_notification_window; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN password_policy.expiration_notification_window IS 'The window before an account is expired during which the user will be emailed notifying them that their account will expire.';


--
-- Name: COLUMN password_policy.required_length; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN password_policy.required_length IS 'The minimum password length.';


--
-- Name: COLUMN password_policy.required_alphanumeric; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN password_policy.required_alphanumeric IS 'The minimum required combined lowercase, uppercase and digit characters in a password.';


--
-- Name: COLUMN password_policy.required_lowercase; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN password_policy.required_lowercase IS 'The minimum required lowercase characters in a password.';


--
-- Name: COLUMN password_policy.required_uppercase; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN password_policy.required_uppercase IS 'The minimum required uppercase characters in a password.';


--
-- Name: COLUMN password_policy.required_digit; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN password_policy.required_digit IS 'The minimum required digit characters in a password.';


--
-- Name: COLUMN password_policy.required_other; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN password_policy.required_other IS 'The minimum required non-alphanumeric characters in a password.';


--
-- Name: person_assignment_version_id_seq; Type: SEQUENCE; Schema: production; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS person_assignment_version_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_assignment_version_id_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: build
--

ALTER SEQUENCE person_assignment_version_id_seq OWNED BY person_assignment_version.id;


--
-- Name: person_touch_point; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS person_touch_point (
    person_id uuid,
    touch_point_id uuid NOT NULL,
    date timestamp with time zone NOT NULL,
    touch_point_type text,
    activity_type_id uuid,
    organizer_id uuid,
    state text,
    activity_status text,
    event_base_status text,
    closed boolean,
    CONSTRAINT person_touch_point_activity_status_check CHECK ((activity_status = ANY (ARRAY['PLANNED'::text, 'CLOSED'::text]))),
    CONSTRAINT person_touch_point_event_base_status_check CHECK ((event_base_status = ANY (ARRAY['PLANNED'::text, 'CANCELED'::text, 'CLOSED'::text]))),
    CONSTRAINT person_touch_point_state_check CHECK ((state = ANY (ARRAY['ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text, 'LIMBO'::text]))),
    CONSTRAINT person_touch_point_touch_point_type_check CHECK ((touch_point_type = ANY (ARRAY['ACTIVITY_ATTENDEE'::text, 'EVENT_ATTENDEE'::text, 'EVENT_SPEAKER'::text, 'PERSONAL_EMAIL_RECEIVER'::text, 'MAILING_RECIPIENT'::text, 'SUPPORT_TICKET_PERSON'::text, 'NONE'::text])))
);


--
-- Name: process_instance; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS process_instance (
    id text NOT NULL,
    process_definition_id uuid NOT NULL,
    user_id uuid NOT NULL,
    data jsonb,
    checkpoint_id uuid,
    checkpoint_data jsonb,
    retry boolean DEFAULT false,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    checkpoint_type text,
    CONSTRAINT process_instance_check CHECK (((checkpoint_id IS NULL) OR (checkpoint_type = ANY (ARRAY['ProcessDefinitionId'::text, 'ToDoId'::text]))))
);


--
-- Name: process_instance_association_value; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS process_instance_association_value (
    process_instance_id text NOT NULL,
    step text,
    key text NOT NULL,
    value text NOT NULL
);


--
-- Name: product_activity_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS product_activity_type (
    product_id uuid NOT NULL,
    activity_type_id uuid NOT NULL
);


--
-- Name: product_family; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS product_family (
    id uuid NOT NULL,
    name text NOT NULL,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT product_family_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: product_topic; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS product_topic (
    product_id uuid NOT NULL,
    topic_id uuid NOT NULL
);


--
-- Name: promotional_material_activity_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS promotional_material_activity_type (
    promotional_material_id uuid NOT NULL,
    activity_type_id uuid NOT NULL
);


--
-- Name: promotional_material_assignment; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS promotional_material_assignment (
    id uuid NOT NULL,
    organizational_hierarchy_id uuid NOT NULL,
    promotional_material_id uuid NOT NULL,
    organizational_unit_id uuid NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: promotional_material_dispatch_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS promotional_material_dispatch_type (
    promotional_material_id uuid NOT NULL,
    dispatch_type text NOT NULL,
    CONSTRAINT promotional_material_dispatch_type_dispatch_type_check CHECK ((dispatch_type = ANY (ARRAY['FAX'::text, 'MAIL'::text, 'EMAIL'::text, 'MANUAL'::text, 'DISTRIBUTION_CENTER'::text])))
);


--
-- Name: role; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS role (
    id uuid NOT NULL,
    name text,
    description text,
    state text DEFAULT 'ACTIVE'::text,
    CONSTRAINT role_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: role_to_client_permission; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS role_to_client_permission (
    role_id uuid NOT NULL,
    client_permission_id uuid NOT NULL,
    client_type text NOT NULL
);


--
-- Name: role_to_data_permission; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS role_to_data_permission (
    role_id uuid NOT NULL,
    data_permission text NOT NULL,
    data_scope_id uuid
);


--
-- Name: role_to_user; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS role_to_user (
    role_id uuid NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: sample_request_form; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS sample_request_form (
    id uuid NOT NULL,
    signer_id uuid NOT NULL,
    issuer_id uuid NOT NULL,
    address_id uuid NOT NULL,
    address_extension text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    state text NOT NULL,
    document_id uuid,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT sample_request_form_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: TABLE sample_request_form; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON TABLE sample_request_form IS 'A sample request form is required in order to hand out product samples';


--
-- Name: COLUMN sample_request_form.id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN sample_request_form.id IS 'The unique ID of a single sample request form';


--
-- Name: COLUMN sample_request_form.signer_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN sample_request_form.signer_id IS 'The person who wants to receive a product sample';


--
-- Name: COLUMN sample_request_form.issuer_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN sample_request_form.issuer_id IS 'The person who wants to hand out a product sample';


--
-- Name: COLUMN sample_request_form.address_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN sample_request_form.address_id IS 'The shipping address for the product sample';


--
-- Name: COLUMN sample_request_form.address_extension; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN sample_request_form.address_extension IS 'The shipping address extension in case some extra information is required';


--
-- Name: COLUMN sample_request_form.created_at; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN sample_request_form.created_at IS 'The timestamp a single request form was created';


--
-- Name: sample_request_form_deprecated; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS sample_request_form_deprecated (
    id uuid,
    form_body text
);


--
-- Name: sample_request_form_item; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS sample_request_form_item (
    sample_request_form_id uuid NOT NULL,
    stock_id uuid NOT NULL,
    quantity integer DEFAULT 0 NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT sample_request_form_item_quantity_check CHECK ((quantity > 0))
);


--
-- Name: TABLE sample_request_form_item; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON TABLE sample_request_form_item IS 'The number of items contained in a sample request form';


--
-- Name: COLUMN sample_request_form_item.sample_request_form_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN sample_request_form_item.sample_request_form_id IS 'Reference to the containing request form';


--
-- Name: COLUMN sample_request_form_item.stock_id; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN sample_request_form_item.stock_id IS 'Reference to the affected stock';


--
-- Name: COLUMN sample_request_form_item.quantity; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN sample_request_form_item.quantity IS 'The number of items to hand out';


--
-- Name: speaker_indication_area; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS speaker_indication_area (
    speaker_id uuid NOT NULL,
    indication_area_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: speaker_request_reason; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS speaker_request_reason (
    id uuid NOT NULL,
    name text NOT NULL,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT speaker_request_reason_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: speaker_speaker_request_reason; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS speaker_speaker_request_reason (
    speaker_id uuid NOT NULL,
    speaker_request_reason_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: stock_transaction; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS stock_transaction (
    stock_id uuid NOT NULL,
    number integer NOT NULL,
    activity_id uuid,
    type text NOT NULL,
    stock_transaction_reason_id uuid,
    quantity integer NOT NULL,
    date timestamp with time zone,
    related_stock_id uuid,
    transaction_group_id uuid,
    distributor_person_id uuid,
    id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT stock_transaction_type_check CHECK ((type = ANY (ARRAY['ACTIVITY'::text, 'MANUAL'::text, 'DISTRIBUTION'::text])))
);


--
-- Name: stock_transaction_reason; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS stock_transaction_reason (
    id uuid NOT NULL,
    name text,
    issue boolean,
    receipt boolean,
    state text,
    CONSTRAINT stock_transaction_reason_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: stock_transaction_reason_stock_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS stock_transaction_reason_stock_type (
    stock_transaction_reason_id uuid NOT NULL,
    stock_type text,
    CONSTRAINT stock_transaction_reason_stock_type_stock_type_check CHECK ((stock_type = ANY (ARRAY['PHYSICAL'::text, 'VIRTUAL'::text])))
);


--
-- Name: support_ticket; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS support_ticket (
    id uuid NOT NULL,
    external_id text,
    person_id uuid,
    created_at timestamp with time zone,
    created_by text,
    updated_at timestamp with time zone,
    updated_by text,
    closed_at timestamp with time zone,
    closed_by text,
    medium text,
    subject text,
    request text,
    solution text,
    product text,
    status text,
    state text NOT NULL,
    CONSTRAINT support_ticket_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: system_notification; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS system_notification (
    id uuid NOT NULL,
    title text NOT NULL,
    text text NOT NULL,
    date timestamp with time zone
);


--
-- Name: target_audience; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS target_audience (
    id uuid NOT NULL,
    name text NOT NULL,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    customer_reference text,
    CONSTRAINT target_audience_state_check CHECK ((state = ANY (ARRAY['ACTIVE'::text, 'INACTIVE'::text])))
);


--
-- Name: target_audience_event_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS target_audience_event_type (
    target_audience_id uuid NOT NULL,
    event_type_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: template_activity_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS template_activity_type (
    template_id uuid NOT NULL,
    activity_type_id uuid NOT NULL
);


--
-- Name: template_assignment; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS template_assignment (
    id uuid NOT NULL,
    organizational_unit_id uuid NOT NULL,
    template_id uuid NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: template_deprecated; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS template_deprecated (
    id uuid,
    content text
);


--
-- Name: template_placeholder; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS template_placeholder (
    template_instance_id uuid NOT NULL,
    name character varying NOT NULL,
    value character varying NOT NULL
);


--
-- Name: template_placeholder_collection; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS template_placeholder_collection (
    id uuid NOT NULL,
    name character varying NOT NULL,
    salutation_id uuid,
    closing_id uuid,
    title character varying,
    phone_number character varying,
    use_picture boolean DEFAULT false NOT NULL,
    person_id uuid NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    last_name text,
    first_name text,
    academic_title_style character varying DEFAULT 'SHORT'::character varying NOT NULL,
    CONSTRAINT signature_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: template_token; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS template_token (
    id uuid NOT NULL,
    type text NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT template_token_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text]))),
    CONSTRAINT template_token_type_check CHECK ((type = ANY (ARRAY['SALUTATION'::text, 'CLOSING'::text])))
);


--
-- Name: template_topic; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS template_topic (
    template_id uuid NOT NULL,
    topic_id uuid NOT NULL
);


--
-- Name: template_tracking; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS template_tracking (
    person_id uuid NOT NULL,
    personal_email_id uuid NOT NULL,
    tracking_token text[],
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: template_version_version_id_seq; Type: SEQUENCE; Schema: production; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS template_version_version_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: template_version_version_id_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: build
--

ALTER SEQUENCE template_version_version_id_seq OWNED BY template_version.version_id;


--
-- Name: tenant; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS tenant (
    id uuid NOT NULL,
    name text,
    description text,
    state text DEFAULT 'ACTIVE'::text,
    CONSTRAINT tenant_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: tenant_authentication; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS tenant_authentication (
    id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    type text NOT NULL,
    ldap_url text,
    ldap_user_dn_prefix text,
    ldap_user_dn_postfix text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT tenant_authentication_type_check CHECK ((type = ANY (ARRAY['PASSWORD'::text, 'LDAP'::text])))
);


--
-- Name: to_do; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS to_do (
    id uuid NOT NULL,
    title text,
    subtitle text,
    start_date timestamp without time zone NOT NULL,
    due_date timestamp without time zone,
    type text,
    state text,
    is_complete boolean DEFAULT false NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    object_id uuid,
    link_id uuid,
    CONSTRAINT to_do_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text]))),
    CONSTRAINT to_do_type_check CHECK ((type = ANY (ARRAY['TO_DO_SAMPLE_REQUEST'::text, 'TO_DO_EVENT'::text, 'TO_DO_INQUIRY'::text, 'TO_DO_SPEAKER'::text, 'TO_DO_PERSON'::text, 'TO_DO_SPEAKER_LIST'::text])))
);


--
-- Name: to_do_owner; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS to_do_owner (
    to_do_id uuid NOT NULL,
    owner_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    organizational_unit_id uuid
);


--
-- Name: topic_activity_type; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS topic_activity_type (
    topic_id uuid NOT NULL,
    activity_type_id uuid NOT NULL
);


--
-- Name: touch_point_attribute_option_plan; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS touch_point_attribute_option_plan (
    touch_point_attribute_plan_id uuid NOT NULL,
    attribute_option_id uuid NOT NULL,
    touch_point_group_id integer NOT NULL,
    value real
);


--
-- Name: touch_point_attribute_plan; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS touch_point_attribute_plan (
    id uuid NOT NULL,
    touch_point_plan_instance_id uuid NOT NULL,
    organizational_unit_id uuid NOT NULL,
    attribute_id uuid NOT NULL,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT touch_point_attribute_plan_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: touch_point_detail_plan; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS touch_point_detail_plan (
    touch_point_attribute_plan_id uuid NOT NULL,
    person_id uuid NOT NULL,
    touch_point_group_id integer NOT NULL,
    value real
);


--
-- Name: touch_point_plan; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS touch_point_plan (
    id uuid NOT NULL,
    name text NOT NULL,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    period_divisor integer,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    short_name text,
    CONSTRAINT touch_point_plan_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: touch_point_plan_instance; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS touch_point_plan_instance (
    id uuid NOT NULL,
    touch_point_plan_id uuid NOT NULL,
    person_id uuid NOT NULL,
    customer_contact_days real,
    customer_contact_new_channel_days real,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT touch_point_plan_instance_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: touch_point_plan_instance_person; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS touch_point_plan_instance_person (
    touch_point_attribute_plan_id uuid NOT NULL,
    attribute_option_id uuid NOT NULL,
    person_id uuid NOT NULL
);


--
-- Name: touch_point_plan_planning_period; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS touch_point_plan_planning_period (
    touch_point_plan_id uuid,
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL
);


--
-- Name: user_login; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS user_login (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    attempted_at timestamp with time zone NOT NULL,
    suceeded boolean NOT NULL
);


--
-- Name: TABLE user_login; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON TABLE user_login IS 'A log of each users authentication attempts.';


--
-- Name: user_login_id_seq; Type: SEQUENCE; Schema: production; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS user_login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_login_id_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: build
--

ALTER SEQUENCE user_login_id_seq OWNED BY user_login.id;


--
-- Name: user_notification; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS user_notification (
    user_id uuid NOT NULL,
    notification_id uuid NOT NULL,
    status text
);


--
-- Name: user_password; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS user_password (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    changed_at timestamp with time zone NOT NULL,
    hash text NOT NULL,
    salt text NOT NULL
);


--
-- Name: user_password_id_seq; Type: SEQUENCE; Schema: production; Owner: build
--

CREATE SEQUENCE IF NOT EXISTS user_password_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_password_id_seq; Type: SEQUENCE OWNED BY; Schema: production; Owner: build
--

ALTER SEQUENCE user_password_id_seq OWNED BY user_password.id;


--
-- Name: user_preference; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS user_preference (
    user_id uuid NOT NULL,
    type text NOT NULL,
    preference jsonb NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT user_preference_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: wizard; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS wizard (
    id uuid NOT NULL,
    name text,
    description text,
    wizard_definition_id uuid,
    wizard_type text,
    state text,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    start_parameters jsonb,
    wizard_category_id uuid,
    CONSTRAINT wizard_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: wizard_category; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS wizard_category (
    id uuid NOT NULL,
    name text NOT NULL,
    sequence integer NOT NULL,
    state text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT wizard_category_state_check CHECK ((state = ANY (ARRAY['LIMBO'::text, 'ACTIVE'::text, 'INACTIVE'::text, 'DELETED'::text])))
);


--
-- Name: wizard_instance; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS wizard_instance (
    id uuid NOT NULL,
    wizard_id uuid NOT NULL,
    wizard_definition_id uuid NOT NULL,
    summary_data jsonb,
    wizard_steps jsonb,
    execution_trace jsonb,
    status text NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text,
    CONSTRAINT wizard_instance_data_status_check CHECK ((status = ANY (ARRAY['IN_PROGRESS'::text, 'COMPLETED'::text, 'CANCELED'::text])))
);


--
-- Name: wizard_instance_owner; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS wizard_instance_owner (
    wizard_instance_id uuid NOT NULL,
    user_id uuid NOT NULL,
    rec_event_identifier uuid,
    rec_command_identifier uuid,
    rec_created_at timestamp with time zone,
    rec_updated_at timestamp with time zone,
    rec_editor uuid,
    rec_command_source text
);


--
-- Name: zov2_process_details; Type: TABLE; Schema: production; Owner: build
--

CREATE TABLE IF NOT EXISTS zov2_process_details (
    event_id uuid NOT NULL,
    "position" text,
    start_date timestamp with time zone
);


--
-- Name: COLUMN zov2_process_details.start_date; Type: COMMENT; Schema: production; Owner: build
--

COMMENT ON COLUMN zov2_process_details.start_date IS 'Stores the start date of the event when the last reminder email was sent. If this changes a new reminder will need to be sent.';

SET search_path = srss, pg_catalog;

--
-- Name: sample_request; Type: TABLE; Schema: srss; Owner: build
--

CREATE TABLE IF NOT EXISTS sample_request (
    id uuid NOT NULL,
    issuer_id uuid NOT NULL,
    signer_id uuid NOT NULL,
    token text NOT NULL,
    campaign_type text NOT NULL,
    organization_address_id uuid,
    address_extension text,
    body text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    redeemed_at timestamp with time zone,
    fulfilled_at timestamp with time zone,
    activity_id uuid,
    CONSTRAINT sample_request_campaign_type_check CHECK ((campaign_type = ANY (ARRAY['AERINAZE_04_2015'::text, 'LOTRICOMB_02_2016'::text, 'AERINAZE_05_2016'::text])))
);


--
-- Name: COLUMN sample_request.id; Type: COMMENT; Schema: srss; Owner: build
--

COMMENT ON COLUMN sample_request.id IS 'This will be shared with the linked production.sample_request_form so we can tell when they are linked';


--
-- Name: COLUMN sample_request.redeemed_at; Type: COMMENT; Schema: srss; Owner: build
--

COMMENT ON COLUMN sample_request.redeemed_at IS 'Person accepted token';


--
-- Name: COLUMN sample_request.fulfilled_at; Type: COMMENT; Schema: srss; Owner: build
--

COMMENT ON COLUMN sample_request.fulfilled_at IS 'Activity was created';

SET search_path = core, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: core; Owner: build
--

ALTER TABLE ONLY command_import ALTER COLUMN id SET DEFAULT nextval('command_import_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: core; Owner: build
--

ALTER TABLE ONLY domain_event ALTER COLUMN id SET DEFAULT nextval('domain_event_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: core; Owner: build
--

ALTER TABLE ONLY domain_snapshot ALTER COLUMN id SET DEFAULT nextval('domain_snapshot_id_seq'::regclass);


SET search_path = production, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: production; Owner: build
--

ALTER TABLE ONLY channel_consent ALTER COLUMN id SET DEFAULT nextval('channel_consent_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: production; Owner: build
--

ALTER TABLE ONLY consent_history ALTER COLUMN id SET DEFAULT nextval('consent_history_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: production; Owner: build
--

ALTER TABLE ONLY efpia_consent ALTER COLUMN id SET DEFAULT nextval('efpia_consent_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: production; Owner: build
--

ALTER TABLE ONLY efpia_history ALTER COLUMN id SET DEFAULT nextval('efpia_history_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: production; Owner: build
--

ALTER TABLE ONLY id_translation ALTER COLUMN id SET DEFAULT nextval('id_translation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: production; Owner: build
--

ALTER TABLE ONLY organizational_unit_version ALTER COLUMN id SET DEFAULT nextval('organizational_unit_version_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: production; Owner: build
--

ALTER TABLE ONLY person_assignment_version ALTER COLUMN id SET DEFAULT nextval('person_assignment_version_id_seq'::regclass);


--
-- Name: version_id; Type: DEFAULT; Schema: production; Owner: build
--

ALTER TABLE ONLY template_version ALTER COLUMN version_id SET DEFAULT nextval('template_version_version_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: production; Owner: build
--

ALTER TABLE ONLY user_login ALTER COLUMN id SET DEFAULT nextval('user_login_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: production; Owner: build
--

ALTER TABLE ONLY user_password ALTER COLUMN id SET DEFAULT nextval('user_password_id_seq'::regclass);


SET search_path = core, pg_catalog;

--
-- Name: activity_pk; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY activity
    ADD CONSTRAINT activity_pk PRIMARY KEY (id);


--
-- Name: activity_sample_request_form_id_key; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY activity
    ADD CONSTRAINT activity_sample_request_form_id_key UNIQUE (sample_request_form_id);


--
-- Name: command_import_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY command_import
    ADD CONSTRAINT command_import_pkey PRIMARY KEY (id);


--
-- Name: domain_event_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY domain_event
    ADD CONSTRAINT domain_event_pkey PRIMARY KEY (id);


--
-- Name: domain_snapshot_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY domain_snapshot
    ADD CONSTRAINT domain_snapshot_pkey PRIMARY KEY (id);


--
-- Name: qrtz_blob_triggers_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_blob_triggers
    ADD CONSTRAINT qrtz_blob_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_calendars_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_calendars
    ADD CONSTRAINT qrtz_calendars_pkey PRIMARY KEY (sched_name, calendar_name);


--
-- Name: qrtz_cron_triggers_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_cron_triggers
    ADD CONSTRAINT qrtz_cron_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_fired_triggers_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_fired_triggers
    ADD CONSTRAINT qrtz_fired_triggers_pkey PRIMARY KEY (sched_name, entry_id);


--
-- Name: qrtz_job_details_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_job_details
    ADD CONSTRAINT qrtz_job_details_pkey PRIMARY KEY (sched_name, job_name, job_group);


--
-- Name: qrtz_locks_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_locks
    ADD CONSTRAINT qrtz_locks_pkey PRIMARY KEY (sched_name, lock_name);


--
-- Name: qrtz_paused_trigger_grps_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_paused_trigger_grps
    ADD CONSTRAINT qrtz_paused_trigger_grps_pkey PRIMARY KEY (sched_name, trigger_group);


--
-- Name: qrtz_scheduler_state_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_scheduler_state
    ADD CONSTRAINT qrtz_scheduler_state_pkey PRIMARY KEY (sched_name, instance_name);


--
-- Name: qrtz_simple_triggers_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_simple_triggers
    ADD CONSTRAINT qrtz_simple_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simprop_triggers_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_simprop_triggers
    ADD CONSTRAINT qrtz_simprop_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_triggers_pkey; Type: CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_triggers
    ADD CONSTRAINT qrtz_triggers_pkey PRIMARY KEY (sched_name, trigger_name, trigger_group);


SET search_path = production, pg_catalog;

--
-- Name: activity_type_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY activity_type
    ADD CONSTRAINT activity_type_pkey PRIMARY KEY (id);


--
-- Name: appointment_type_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY appointment_type
    ADD CONSTRAINT appointment_type_pkey PRIMARY KEY (id);


--
-- Name: approval_batch_approval_id_sequence_key; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY approval_batch
    ADD CONSTRAINT approval_batch_approval_id_sequence_key UNIQUE (approval_id, sequence);


--
-- Name: approval_batch_approver_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY approval_batch_approver
    ADD CONSTRAINT approval_batch_approver_pkey PRIMARY KEY (approval_batch_id, person_id, type);


--
-- Name: approval_batch_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY approval_batch
    ADD CONSTRAINT approval_batch_pkey PRIMARY KEY (id);


--
-- Name: approval_pkey1; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY approval
    ADD CONSTRAINT approval_pkey1 PRIMARY KEY (id);


--
-- Name: attachment_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY attachment
    ADD CONSTRAINT attachment_pkey PRIMARY KEY (id);


--
-- Name: attribute_container_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY attribute_container
    ADD CONSTRAINT attribute_container_pkey PRIMARY KEY (id);


--
-- Name: attribute_value_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY attribute_value
    ADD CONSTRAINT attribute_value_pkey PRIMARY KEY (id);


--
-- Name: budget_allocation_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY budget_allocation
    ADD CONSTRAINT budget_allocation_pkey PRIMARY KEY (id);


--
-- Name: channel_consent_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY channel_consent
    ADD CONSTRAINT channel_consent_pkey PRIMARY KEY (id);


--
-- Name: compensation_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY compensation
    ADD CONSTRAINT compensation_pkey PRIMARY KEY (id);


--
-- Name: consent_artifact_group_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY consent_artifact_group
    ADD CONSTRAINT consent_artifact_group_pkey PRIMARY KEY (id);


--
-- Name: consent_artifact_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY consent_artifact
    ADD CONSTRAINT consent_artifact_pkey PRIMARY KEY (id);


--
-- Name: consent_document_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY consent_document
    ADD CONSTRAINT consent_document_pkey PRIMARY KEY (id);


--
-- Name: contract_partner_function_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY contract_partner_function
    ADD CONSTRAINT contract_partner_function_pkey PRIMARY KEY (id);


--
-- Name: contract_partner_reason_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY contract_partner_reason
    ADD CONSTRAINT contract_partner_reason_pkey PRIMARY KEY (id);


--
-- Name: contract_type_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY contract_type
    ADD CONSTRAINT contract_type_pkey PRIMARY KEY (id);


--
-- Name: data_scope_activity_type_aggregate_id_data_scope_id_user_id_key; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_activity_type
    ADD CONSTRAINT data_scope_activity_type_aggregate_id_data_scope_id_user_id_key UNIQUE (aggregate_id, data_scope_id, user_id);


--
-- Name: data_scope_attribute_category_aggregate_id_data_scope_id_us_key; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_attribute_category
    ADD CONSTRAINT data_scope_attribute_category_aggregate_id_data_scope_id_us_key UNIQUE (aggregate_id, data_scope_id, user_id);


--
-- Name: data_scope_empty_aggregate_id_data_scope_id_user_id_key; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_empty
    ADD CONSTRAINT data_scope_empty_aggregate_id_data_scope_id_user_id_key UNIQUE (aggregate_id, data_scope_id, user_id);


--
-- Name: data_scope_indication_area_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_indication_area
    ADD CONSTRAINT data_scope_indication_area_pkey PRIMARY KEY (aggregate_id, data_scope_id, user_id);


--
-- Name: data_scope_organization_aggregate_id_data_scope_id_user_id_key; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_organization
    ADD CONSTRAINT data_scope_organization_aggregate_id_data_scope_id_user_id_key UNIQUE (aggregate_id, data_scope_id, user_id);


--
-- Name: data_scope_person_aggregate_id_data_scope_id_user_id_key; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_person
    ADD CONSTRAINT data_scope_person_aggregate_id_data_scope_id_user_id_key UNIQUE (aggregate_id, data_scope_id, user_id);


--
-- Name: data_scope_speaker_request_re_aggregate_id_data_scope_id_us_key; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_speaker_request_reason
    ADD CONSTRAINT data_scope_speaker_request_re_aggregate_id_data_scope_id_us_key UNIQUE (aggregate_id, data_scope_id, user_id);


--
-- Name: data_scope_to_do_aggregate_id_data_scope_id_user_id_key; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_to_do
    ADD CONSTRAINT data_scope_to_do_aggregate_id_data_scope_id_user_id_key UNIQUE (aggregate_id, data_scope_id, user_id);


--
-- Name: data_scope_wizard_instance_aggregate_id_data_scope_id_user__key; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_wizard_instance
    ADD CONSTRAINT data_scope_wizard_instance_aggregate_id_data_scope_id_user__key UNIQUE (aggregate_id, data_scope_id, user_id);


--
-- Name: efpia_consent_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY efpia_consent
    ADD CONSTRAINT efpia_consent_pkey PRIMARY KEY (id);


--
-- Name: efpia_history_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY efpia_history
    ADD CONSTRAINT efpia_history_pkey PRIMARY KEY (id);


--
-- Name: event_appointment_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_appointment
    ADD CONSTRAINT event_appointment_pkey PRIMARY KEY (id);


--
-- Name: event_attendee_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_attendee
    ADD CONSTRAINT event_attendee_pkey PRIMARY KEY (event_id, person_id);


--
-- Name: event_attendee_to_participation_reason_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_attendee_to_participation_reason
    ADD CONSTRAINT event_attendee_to_participation_reason_pkey PRIMARY KEY (person_id, event_id, participation_reason_id);


--
-- Name: event_budget_allocation_detail_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_budget_allocation_detail
    ADD CONSTRAINT event_budget_allocation_detail_pkey PRIMARY KEY (id);


--
-- Name: event_co_organizer_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_co_organizer
    ADD CONSTRAINT event_co_organizer_pkey PRIMARY KEY (event_id, person_id);


--
-- Name: event_compensation_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_compensation
    ADD CONSTRAINT event_compensation_pkey PRIMARY KEY (event_id, compensation_id);


--
-- Name: event_contract_partner_function_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_contract_partner_function
    ADD CONSTRAINT event_contract_partner_function_pkey PRIMARY KEY (event_id, partner_function_id);


--
-- Name: event_contract_partner_reason_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_contract_partner_reason
    ADD CONSTRAINT event_contract_partner_reason_pkey PRIMARY KEY (event_id, reason_id);


--
-- Name: event_cost_item_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_cost_item
    ADD CONSTRAINT event_cost_item_pkey PRIMARY KEY (id);


--
-- Name: event_cost_type_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY cost_type
    ADD CONSTRAINT event_cost_type_pkey PRIMARY KEY (id);


--
-- Name: event_custom_compensation_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_custom_compensation
    ADD CONSTRAINT event_custom_compensation_pkey PRIMARY KEY (event_id, custom_compensation_id);


--
-- Name: event_custom_contract_partner_function_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_custom_contract_partner_function
    ADD CONSTRAINT event_custom_contract_partner_function_pkey PRIMARY KEY (event_id, function);


--
-- Name: event_employee_attendee_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_employee_attendee
    ADD CONSTRAINT event_employee_attendee_pkey PRIMARY KEY (event_id, person_id);


--
-- Name: event_indication_area_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_indication_area
    ADD CONSTRAINT event_indication_area_pk PRIMARY KEY (event_id, indication_area_id);


--
-- Name: event_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: event_planned_participation_reason_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_planned_participation_reason
    ADD CONSTRAINT event_planned_participation_reason_pkey PRIMARY KEY (event_id, participation_reason_id);


--
-- Name: event_speaker_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_speaker
    ADD CONSTRAINT event_speaker_pkey PRIMARY KEY (event_id, person_id);


--
-- Name: event_status_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_status
    ADD CONSTRAINT event_status_pkey PRIMARY KEY (id);


--
-- Name: event_subject_group_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_subject_group
    ADD CONSTRAINT event_subject_group_pkey PRIMARY KEY (id);


--
-- Name: event_subject_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_subject
    ADD CONSTRAINT event_subject_pkey PRIMARY KEY (id);


--
-- Name: event_target_audience_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_target_audience
    ADD CONSTRAINT event_target_audience_pkey PRIMARY KEY (event_id, target_audience_id);


--
-- Name: event_to_event_subject_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_to_event_subject
    ADD CONSTRAINT event_to_event_subject_pkey PRIMARY KEY (event_id, event_subject_id);


--
-- Name: event_to_organizing_organization_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_to_organizing_organization
    ADD CONSTRAINT event_to_organizing_organization_pkey PRIMARY KEY (event_id, organization_id);


--
-- Name: event_topic_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_topic
    ADD CONSTRAINT event_topic_pkey PRIMARY KEY (event_id, topic_id);


--
-- Name: event_type_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_type
    ADD CONSTRAINT event_type_pkey PRIMARY KEY (id);


--
-- Name: event_type_to_finalization_wizard_event_type_id_key; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_type_to_finalization_wizard
    ADD CONSTRAINT event_type_to_finalization_wizard_event_type_id_key UNIQUE (event_type_id);


--
-- Name: event_type_to_finalization_wizard_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY event_type_to_finalization_wizard
    ADD CONSTRAINT event_type_to_finalization_wizard_pkey PRIMARY KEY (event_type_id, wizard_id);


--
-- Name: export_item_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY export_item
    ADD CONSTRAINT export_item_pkey PRIMARY KEY (id);


--
-- Name: field_unique_by_consent_document_id_and_name; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY consent_document_fields
    ADD CONSTRAINT field_unique_by_consent_document_id_and_name UNIQUE (consent_document_id, name);


--
-- Name: id_number_key; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY stock_transaction
    ADD CONSTRAINT id_number_key UNIQUE (stock_id, number);


--
-- Name: indication_area_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY indication_area
    ADD CONSTRAINT indication_area_pkey PRIMARY KEY (id);


--
-- Name: inquiry_budget_allocation_detail_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY inquiry_budget_allocation_detail
    ADD CONSTRAINT inquiry_budget_allocation_detail_pkey PRIMARY KEY (id);


--
-- Name: inquiry_compensation_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY inquiry_compensation
    ADD CONSTRAINT inquiry_compensation_pkey PRIMARY KEY (inquiry_id, id);


--
-- Name: inquiry_contract_partner_reason_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY inquiry_contract_partner_reason
    ADD CONSTRAINT inquiry_contract_partner_reason_pkey PRIMARY KEY (inquiry_id, reason_id);


--
-- Name: inquiry_cost_item_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY inquiry_cost_item
    ADD CONSTRAINT inquiry_cost_item_pkey PRIMARY KEY (id);


--
-- Name: inquiry_partner_organization_person_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY inquiry_partner_organization_person
    ADD CONSTRAINT inquiry_partner_organization_person_pkey PRIMARY KEY (inquiry_id, person_id);


--
-- Name: inquiry_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY inquiry
    ADD CONSTRAINT inquiry_pkey PRIMARY KEY (id);


--
-- Name: inquiry_proof_of_service_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY inquiry_proof_of_service
    ADD CONSTRAINT inquiry_proof_of_service_pkey PRIMARY KEY (id);


--
-- Name: inquiry_status_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY inquiry_status
    ADD CONSTRAINT inquiry_status_pkey PRIMARY KEY (id);


--
-- Name: inquiry_topic_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY inquiry_topic
    ADD CONSTRAINT inquiry_topic_pkey PRIMARY KEY (inquiry_id, topic_id);


--
-- Name: inquiry_type_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY inquiry_type
    ADD CONSTRAINT inquiry_type_pkey PRIMARY KEY (id);


--
-- Name: inventory_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (id);


--
-- Name: new_consent_history_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY consent_history
    ADD CONSTRAINT new_consent_history_pkey PRIMARY KEY (id);


--
-- Name: notification_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: option_unique_by_consent_document_id_and_name; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY consent_document_options
    ADD CONSTRAINT option_unique_by_consent_document_id_and_name UNIQUE (consent_document_id, name);


--
-- Name: organization_outpatient_department_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organization_outpatient_department
    ADD CONSTRAINT organization_outpatient_department_pkey PRIMARY KEY (organization_id, name);


--
-- Name: organizational_unit_version_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organizational_unit_version
    ADD CONSTRAINT organizational_unit_version_pkey PRIMARY KEY (id);


--
-- Name: participation_reason_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY participation_reason
    ADD CONSTRAINT participation_reason_pkey PRIMARY KEY (id);


--
-- Name: password_policy_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY password_policy
    ADD CONSTRAINT password_policy_pkey PRIMARY KEY (tenant_id);


--
-- Name: person_assignment_version_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY person_assignment_version
    ADD CONSTRAINT person_assignment_version_pkey PRIMARY KEY (id);


--
-- Name: person_consent_artifact_unique; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY person_consent_artifact
    ADD CONSTRAINT person_consent_artifact_unique UNIQUE (person_id, consent_artifact_id);


--
-- Name: personal_email_activity_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY personal_email_activity
    ADD CONSTRAINT personal_email_activity_pkey PRIMARY KEY (id);


--
-- Name: personal_email_activity_topic_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY personal_email_activity_topic
    ADD CONSTRAINT personal_email_activity_topic_pk PRIMARY KEY (personal_email_activity_id, topic_id);


--
-- Name: personal_email_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY personal_email
    ADD CONSTRAINT personal_email_pkey PRIMARY KEY (id);


--
-- Name: pk_academic_title; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY academic_title
    ADD CONSTRAINT pk_academic_title PRIMARY KEY (id);


--
-- Name: pk_activity; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY activity
    ADD CONSTRAINT pk_activity PRIMARY KEY (id);


--
-- Name: pk_activity_attendee; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY activity_attendee
    ADD CONSTRAINT pk_activity_attendee PRIMARY KEY (activity_id, person_id);


--
-- Name: pk_activity_type_dispatch_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY activity_type_dispatch_type
    ADD CONSTRAINT pk_activity_type_dispatch_type PRIMARY KEY (activity_type_id, dispatch_type);


--
-- Name: pk_additional_event_location; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY additional_event_location
    ADD CONSTRAINT pk_additional_event_location PRIMARY KEY (event_id, organization_id);


--
-- Name: pk_attribute; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY attribute
    ADD CONSTRAINT pk_attribute PRIMARY KEY (id);


--
-- Name: pk_attribute_assignment; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY attribute_assignment
    ADD CONSTRAINT pk_attribute_assignment PRIMARY KEY (id);


--
-- Name: pk_attribute_category; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY attribute_category
    ADD CONSTRAINT pk_attribute_category PRIMARY KEY (id);


--
-- Name: pk_attribute_category_to_attribute; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY attribute_category_to_attribute
    ADD CONSTRAINT pk_attribute_category_to_attribute PRIMARY KEY (attribute_category_id, attribute_id);


--
-- Name: pk_attribute_option; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY attribute_option
    ADD CONSTRAINT pk_attribute_option PRIMARY KEY (id);


--
-- Name: pk_client_permission; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY client_permission
    ADD CONSTRAINT pk_client_permission PRIMARY KEY (id);


--
-- Name: pk_communication_data_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY communication_data_type
    ADD CONSTRAINT pk_communication_data_type PRIMARY KEY (id);


--
-- Name: pk_compensation_event_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY compensation_event_type
    ADD CONSTRAINT pk_compensation_event_type PRIMARY KEY (compensation_id, event_type_id);


--
-- Name: pk_country; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY country
    ADD CONSTRAINT pk_country PRIMARY KEY (id);


--
-- Name: pk_data_permission; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_permission
    ADD CONSTRAINT pk_data_permission PRIMARY KEY (id);


--
-- Name: pk_data_scope; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope
    ADD CONSTRAINT pk_data_scope PRIMARY KEY (id);


--
-- Name: pk_data_scope_activity_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_activity_type
    ADD CONSTRAINT pk_data_scope_activity_type PRIMARY KEY (id);


--
-- Name: pk_data_scope_attribute_category; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_attribute_category
    ADD CONSTRAINT pk_data_scope_attribute_category PRIMARY KEY (id);


--
-- Name: pk_data_scope_empty; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_empty
    ADD CONSTRAINT pk_data_scope_empty PRIMARY KEY (id);


--
-- Name: pk_data_scope_organization; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_organization
    ADD CONSTRAINT pk_data_scope_organization PRIMARY KEY (id);


--
-- Name: pk_data_scope_person; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_person
    ADD CONSTRAINT pk_data_scope_person PRIMARY KEY (id);


--
-- Name: pk_data_scope_speaker_request_reason; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_speaker_request_reason
    ADD CONSTRAINT pk_data_scope_speaker_request_reason PRIMARY KEY (id);


--
-- Name: pk_data_scope_to_do; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_to_do
    ADD CONSTRAINT pk_data_scope_to_do PRIMARY KEY (id);


--
-- Name: pk_discussed_topic; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY discussed_topic
    ADD CONSTRAINT pk_discussed_topic PRIMARY KEY (activity_id, topic_id);


--
-- Name: pk_document; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY document
    ADD CONSTRAINT pk_document PRIMARY KEY (id, media_type);


--
-- Name: pk_employee; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT pk_employee PRIMARY KEY (id);


--
-- Name: pk_employee_department; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY employee_department
    ADD CONSTRAINT pk_employee_department PRIMARY KEY (id);


--
-- Name: pk_employee_function; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY employee_function
    ADD CONSTRAINT pk_employee_function PRIMARY KEY (id);


--
-- Name: pk_employment_address; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY employee_address
    ADD CONSTRAINT pk_employment_address PRIMARY KEY (id);


--
-- Name: pk_employment_communication_data; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY employee_communication_data
    ADD CONSTRAINT pk_employment_communication_data PRIMARY KEY (id);


--
-- Name: pk_expense; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY expense
    ADD CONSTRAINT pk_expense PRIMARY KEY (id);


--
-- Name: pk_expense_related_activity_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY expense_activity_type
    ADD CONSTRAINT pk_expense_related_activity_type PRIMARY KEY (expense_id, activity_type_id);


--
-- Name: pk_expense_related_topic; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY expense_topic
    ADD CONSTRAINT pk_expense_related_topic PRIMARY KEY (expense_id, topic_id);


--
-- Name: pk_given_promotional_material; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY given_promotional_material
    ADD CONSTRAINT pk_given_promotional_material PRIMARY KEY (id);


--
-- Name: pk_id_translation; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY id_translation
    ADD CONSTRAINT pk_id_translation PRIMARY KEY (id);


--
-- Name: pk_incurred_expense; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY incurred_expense
    ADD CONSTRAINT pk_incurred_expense PRIMARY KEY (id);


--
-- Name: pk_list_condition; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY list_condition
    ADD CONSTRAINT pk_list_condition PRIMARY KEY (id);


--
-- Name: pk_list_condition_definition; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY list_condition_definition
    ADD CONSTRAINT pk_list_condition_definition PRIMARY KEY (id, type);


--
-- Name: pk_list_condition_definition_allowed_operator; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY list_condition_definition_allowed_operator
    ADD CONSTRAINT pk_list_condition_definition_allowed_operator PRIMARY KEY (list_condition_definition_id, operator);


--
-- Name: pk_list_criteria; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY list_criteria
    ADD CONSTRAINT pk_list_criteria PRIMARY KEY (id);


--
-- Name: pk_list_field; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY list_field
    ADD CONSTRAINT pk_list_field PRIMARY KEY (list_id, list_field_definition_id);


--
-- Name: pk_list_field_definition; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY list_field_definition
    ADD CONSTRAINT pk_list_field_definition PRIMARY KEY (id, type);


--
-- Name: pk_list_management; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY list
    ADD CONSTRAINT pk_list_management PRIMARY KEY (id);


--
-- Name: pk_list_owner; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY list_owner
    ADD CONSTRAINT pk_list_owner PRIMARY KEY (list_id, user_id);


--
-- Name: pk_list_sorting; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY list_sorting
    ADD CONSTRAINT pk_list_sorting PRIMARY KEY (list_id, list_field_definition_id);


--
-- Name: pk_list_viewer; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY list_viewer
    ADD CONSTRAINT pk_list_viewer PRIMARY KEY (list_id, user_id);


--
-- Name: pk_mailing; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY mailing
    ADD CONSTRAINT pk_mailing PRIMARY KEY (id);


--
-- Name: pk_mailing_attachment; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY mailing_attachment
    ADD CONSTRAINT pk_mailing_attachment PRIMARY KEY (mailing_id, document_id);


--
-- Name: pk_mailing_recipient; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY mailing_recipient
    ADD CONSTRAINT pk_mailing_recipient PRIMARY KEY (mailing_id, person_id, organization_id);


--
-- Name: pk_marketing_material; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY marketing_material
    ADD CONSTRAINT pk_marketing_material PRIMARY KEY (id);


--
-- Name: pk_merged_organizations; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY merged_organization
    ADD CONSTRAINT pk_merged_organizations PRIMARY KEY (target_organization_id, source_organization_id);


--
-- Name: pk_merged_person; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY merged_person
    ADD CONSTRAINT pk_merged_person PRIMARY KEY (target_person_id, source_person_id);


--
-- Name: pk_organization; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organization
    ADD CONSTRAINT pk_organization PRIMARY KEY (id);


--
-- Name: pk_organization_address; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organization_address
    ADD CONSTRAINT pk_organization_address PRIMARY KEY (id);


--
-- Name: pk_organization_assignment; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organization_assignment
    ADD CONSTRAINT pk_organization_assignment PRIMARY KEY (id, organizational_hierarchy_id);


--
-- Name: pk_organization_attribute_value; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organization_attribute_value
    ADD CONSTRAINT pk_organization_attribute_value PRIMARY KEY (id);


--
-- Name: pk_organization_communication_data; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organization_communication_data
    ADD CONSTRAINT pk_organization_communication_data PRIMARY KEY (id);


--
-- Name: pk_organization_group; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organization_group
    ADD CONSTRAINT pk_organization_group PRIMARY KEY (id);


--
-- Name: pk_organization_group_organization; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organization_group_organization
    ADD CONSTRAINT pk_organization_group_organization PRIMARY KEY (organization_group_id, organization_id);


--
-- Name: pk_organization_relation; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organization_relation
    ADD CONSTRAINT pk_organization_relation PRIMARY KEY (id);


--
-- Name: pk_organization_relation_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organization_relation_type
    ADD CONSTRAINT pk_organization_relation_type PRIMARY KEY (id);


--
-- Name: pk_organization_to_organization_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organization_to_organization_type
    ADD CONSTRAINT pk_organization_to_organization_type PRIMARY KEY (organization_id, organization_type_id);


--
-- Name: pk_organization_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organization_type
    ADD CONSTRAINT pk_organization_type PRIMARY KEY (id);


--
-- Name: pk_organizational_hierarchy; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organizational_hierarchy
    ADD CONSTRAINT pk_organizational_hierarchy PRIMARY KEY (id);


--
-- Name: pk_organizational_unit; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organizational_unit
    ADD CONSTRAINT pk_organizational_unit PRIMARY KEY (id);


--
-- Name: pk_organizational_unit_to_list; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organizational_unit_to_list
    ADD CONSTRAINT pk_organizational_unit_to_list PRIMARY KEY (organizational_unit_id, list_id);


--
-- Name: pk_organizational_unit_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY organizational_unit_type
    ADD CONSTRAINT pk_organizational_unit_type PRIMARY KEY (id);


--
-- Name: pk_person; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY person
    ADD CONSTRAINT pk_person PRIMARY KEY (id);


--
-- Name: pk_person_address; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT pk_person_address PRIMARY KEY (id);


--
-- Name: pk_person_assignment; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY person_assignment
    ADD CONSTRAINT pk_person_assignment PRIMARY KEY (id, organizational_hierarchy_id);


--
-- Name: pk_person_assignment_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY person_assignment_type
    ADD CONSTRAINT pk_person_assignment_type PRIMARY KEY (id);


--
-- Name: pk_person_attribute_value; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY person_attribute_value
    ADD CONSTRAINT pk_person_attribute_value PRIMARY KEY (id);


--
-- Name: pk_person_communication_data; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY person_communication_data
    ADD CONSTRAINT pk_person_communication_data PRIMARY KEY (id);


--
-- Name: pk_person_speciality; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY person_speciality
    ADD CONSTRAINT pk_person_speciality PRIMARY KEY (id);


--
-- Name: pk_person_to_person_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY person_to_person_type
    ADD CONSTRAINT pk_person_to_person_type PRIMARY KEY (person_id, person_type_id);


--
-- Name: pk_person_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY person_type
    ADD CONSTRAINT pk_person_type PRIMARY KEY (id);


--
-- Name: pk_person_work_journal_entry; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY person_work_journal_entry
    ADD CONSTRAINT pk_person_work_journal_entry PRIMARY KEY (person_id, date, sequence_number);


--
-- Name: pk_product; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY product
    ADD CONSTRAINT pk_product PRIMARY KEY (id);


--
-- Name: pk_promotional_material; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY promotional_material
    ADD CONSTRAINT pk_promotional_material PRIMARY KEY (id);


--
-- Name: pk_promotional_material_assignment; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY promotional_material_assignment
    ADD CONSTRAINT pk_promotional_material_assignment PRIMARY KEY (id, organizational_hierarchy_id);


--
-- Name: pk_promotional_material_related_activity_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY promotional_material_activity_type
    ADD CONSTRAINT pk_promotional_material_related_activity_type PRIMARY KEY (promotional_material_id, activity_type_id);


--
-- Name: pk_promotional_material_related_topic; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY promotional_material_topic
    ADD CONSTRAINT pk_promotional_material_related_topic PRIMARY KEY (promotional_material_id, topic_id);


--
-- Name: pk_role; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY role
    ADD CONSTRAINT pk_role PRIMARY KEY (id);


--
-- Name: pk_role_to_client_permission; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY role_to_client_permission
    ADD CONSTRAINT pk_role_to_client_permission PRIMARY KEY (role_id, client_permission_id, client_type);


--
-- Name: pk_role_to_user; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY role_to_user
    ADD CONSTRAINT pk_role_to_user PRIMARY KEY (role_id, user_id);


--
-- Name: pk_speciality; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY speciality
    ADD CONSTRAINT pk_speciality PRIMARY KEY (id);


--
-- Name: pk_speciality_group; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY speciality_group
    ADD CONSTRAINT pk_speciality_group PRIMARY KEY (id);


--
-- Name: pk_speciality_to_speciality_group; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY speciality_to_speciality_group
    ADD CONSTRAINT pk_speciality_to_speciality_group PRIMARY KEY (speciality_id);


--
-- Name: pk_stock_transaction; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY stock_transaction
    ADD CONSTRAINT pk_stock_transaction PRIMARY KEY (id);


--
-- Name: pk_support_ticket; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY support_ticket
    ADD CONSTRAINT pk_support_ticket PRIMARY KEY (id);


--
-- Name: pk_target_audience_event_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY target_audience_event_type
    ADD CONSTRAINT pk_target_audience_event_type PRIMARY KEY (target_audience_id, event_type_id);


--
-- Name: pk_template_assignment; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY template_assignment
    ADD CONSTRAINT pk_template_assignment PRIMARY KEY (id);


--
-- Name: pk_template_tracking; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY template_tracking
    ADD CONSTRAINT pk_template_tracking PRIMARY KEY (person_id, personal_email_id);


--
-- Name: pk_tenant; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY tenant
    ADD CONSTRAINT pk_tenant PRIMARY KEY (id);


--
-- Name: pk_topic_activity_type; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY topic_activity_type
    ADD CONSTRAINT pk_topic_activity_type PRIMARY KEY (topic_id, activity_type_id);


--
-- Name: pk_user; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY sec_user
    ADD CONSTRAINT pk_user PRIMARY KEY (id);


--
-- Name: pk_user_notification; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY user_notification
    ADD CONSTRAINT pk_user_notification PRIMARY KEY (user_id, notification_id);


--
-- Name: pk_wizard; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY wizard
    ADD CONSTRAINT pk_wizard PRIMARY KEY (id);


--
-- Name: pk_wizard_instance; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY data_scope_wizard_instance
    ADD CONSTRAINT pk_wizard_instance PRIMARY KEY (id);


--
-- Name: postal_code_city_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY postal_code_city
    ADD CONSTRAINT postal_code_city_pkey PRIMARY KEY (id);


--
-- Name: process_instance_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY process_instance
    ADD CONSTRAINT process_instance_pkey PRIMARY KEY (id);


--
-- Name: product_activity_type_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY product_activity_type
    ADD CONSTRAINT product_activity_type_pk PRIMARY KEY (product_id, activity_type_id);


--
-- Name: product_family_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY product_family
    ADD CONSTRAINT product_family_pkey PRIMARY KEY (id);


--
-- Name: product_license_date_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY product_license_date
    ADD CONSTRAINT product_license_date_pk PRIMARY KEY (product_id, license_date);


--
-- Name: product_topic_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY product_topic
    ADD CONSTRAINT product_topic_pk PRIMARY KEY (product_id, topic_id);


--
-- Name: promotional_material_dispatch_type_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY promotional_material_dispatch_type
    ADD CONSTRAINT promotional_material_dispatch_type_pk PRIMARY KEY (promotional_material_id, dispatch_type);


--
-- Name: promotional_material_rule_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY promotional_material_rule
    ADD CONSTRAINT promotional_material_rule_pkey PRIMARY KEY (id);


--
-- Name: role_to_data_permission_role_id_data_permission_data_scope__key; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY role_to_data_permission
    ADD CONSTRAINT role_to_data_permission_role_id_data_permission_data_scope__key UNIQUE (role_id, data_permission, data_scope_id);


--
-- Name: sample_request_form_item_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY sample_request_form_item
    ADD CONSTRAINT sample_request_form_item_pk PRIMARY KEY (sample_request_form_id, stock_id);


--
-- Name: sample_request_form_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY sample_request_form
    ADD CONSTRAINT sample_request_form_pkey PRIMARY KEY (id);


--
-- Name: signature_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY template_placeholder_collection
    ADD CONSTRAINT signature_pkey PRIMARY KEY (id);


--
-- Name: speaker_indication_area_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY speaker_indication_area
    ADD CONSTRAINT speaker_indication_area_pk PRIMARY KEY (speaker_id, indication_area_id);


--
-- Name: speaker_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY speaker
    ADD CONSTRAINT speaker_pk PRIMARY KEY (id);


--
-- Name: speaker_request_reason_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY speaker_request_reason
    ADD CONSTRAINT speaker_request_reason_pk PRIMARY KEY (id);


--
-- Name: speaker_speaker_request_reason_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY speaker_speaker_request_reason
    ADD CONSTRAINT speaker_speaker_request_reason_pk PRIMARY KEY (speaker_id, speaker_request_reason_id);


--
-- Name: stock_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY stock
    ADD CONSTRAINT stock_pkey PRIMARY KEY (id);


--
-- Name: stock_transaction_reason_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY stock_transaction_reason
    ADD CONSTRAINT stock_transaction_reason_pkey PRIMARY KEY (id);


--
-- Name: stock_transaction_reason_stock_type_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY stock_transaction_reason_stock_type
    ADD CONSTRAINT stock_transaction_reason_stock_type_pkey PRIMARY KEY (stock_transaction_reason_id);


--
-- Name: system_notification_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY system_notification
    ADD CONSTRAINT system_notification_pkey PRIMARY KEY (id);


--
-- Name: target_audience_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY target_audience
    ADD CONSTRAINT target_audience_pkey PRIMARY KEY (id);


--
-- Name: template_activity_type_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY template_activity_type
    ADD CONSTRAINT template_activity_type_pk PRIMARY KEY (template_id, activity_type_id);


--
-- Name: template_instance_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY template_instance
    ADD CONSTRAINT template_instance_pkey PRIMARY KEY (id);


--
-- Name: template_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY template
    ADD CONSTRAINT template_pkey PRIMARY KEY (id);


--
-- Name: template_placeholder_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY template_placeholder
    ADD CONSTRAINT template_placeholder_pk PRIMARY KEY (template_instance_id, name);


--
-- Name: template_token_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY template_token
    ADD CONSTRAINT template_token_pkey PRIMARY KEY (id);


--
-- Name: template_topic_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY template_topic
    ADD CONSTRAINT template_topic_pk PRIMARY KEY (template_id, topic_id);


--
-- Name: template_version_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY template_version
    ADD CONSTRAINT template_version_pkey PRIMARY KEY (id);


--
-- Name: tenant_authentication_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY tenant_authentication
    ADD CONSTRAINT tenant_authentication_pkey PRIMARY KEY (id);


--
-- Name: to_do_owner_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY to_do_owner
    ADD CONSTRAINT to_do_owner_pk PRIMARY KEY (to_do_id, owner_id);


--
-- Name: to_do_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY to_do
    ADD CONSTRAINT to_do_pkey PRIMARY KEY (id);


--
-- Name: topic_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_pkey PRIMARY KEY (id);


--
-- Name: touch_point_attribute_plan_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY touch_point_attribute_plan
    ADD CONSTRAINT touch_point_attribute_plan_pkey PRIMARY KEY (id);


--
-- Name: touch_point_plan_instance_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY touch_point_plan_instance
    ADD CONSTRAINT touch_point_plan_instance_pkey PRIMARY KEY (id);


--
-- Name: touch_point_plan_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY touch_point_plan
    ADD CONSTRAINT touch_point_plan_pkey PRIMARY KEY (id);


--
-- Name: user_login_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY user_login
    ADD CONSTRAINT user_login_pkey PRIMARY KEY (id);


--
-- Name: user_password_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY user_password
    ADD CONSTRAINT user_password_pkey PRIMARY KEY (id);


--
-- Name: user_preference_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY user_preference
    ADD CONSTRAINT user_preference_pk PRIMARY KEY (user_id, type);


--
-- Name: wizard_category_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY wizard_category
    ADD CONSTRAINT wizard_category_pkey PRIMARY KEY (id);


--
-- Name: wizard_instance_owner_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY wizard_instance_owner
    ADD CONSTRAINT wizard_instance_owner_pk PRIMARY KEY (wizard_instance_id, user_id);


--
-- Name: wizard_instance_pk; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY wizard_instance
    ADD CONSTRAINT wizard_instance_pk PRIMARY KEY (id);


--
-- Name: zov2_process_position_pkey; Type: CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY zov2_process_details
    ADD CONSTRAINT zov2_process_position_pkey PRIMARY KEY (event_id);


SET search_path = public, pg_catalog;


SET search_path = srss, pg_catalog;

--
-- Name: sample_request_campaign_type_signer_id_key; Type: CONSTRAINT; Schema: srss; Owner: build
--

ALTER TABLE ONLY sample_request
    ADD CONSTRAINT sample_request_campaign_type_signer_id_key UNIQUE (campaign_type, signer_id);


--
-- Name: sample_request_pkey; Type: CONSTRAINT; Schema: srss; Owner: build
--

ALTER TABLE ONLY sample_request
    ADD CONSTRAINT sample_request_pkey PRIMARY KEY (id);


--
-- Name: sample_request_token_key; Type: CONSTRAINT; Schema: srss; Owner: build
--

ALTER TABLE ONLY sample_request
    ADD CONSTRAINT sample_request_token_key UNIQUE (token);


SET search_path = core, pg_catalog;

--
-- Name: idx_domain_event_1; Type: INDEX; Schema: core; Owner: build
--

CREATE UNIQUE INDEX IF NOT EXISTS idx_domain_event_1 ON domain_event USING btree (aggregate_identifier, type, sequence_number);


--
-- Name: idx_domain_event_2; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_domain_event_2 ON domain_event USING btree (payload_type);


--
-- Name: idx_domain_snapshot_1; Type: INDEX; Schema: core; Owner: build
--

CREATE UNIQUE INDEX IF NOT EXISTS idx_domain_snapshot_1 ON domain_snapshot USING btree (aggregate_identifier, type);


--
-- Name: idx_qrtz_ft_inst_job_req_rcvry; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_ft_inst_job_req_rcvry ON qrtz_fired_triggers USING btree (sched_name, instance_name, requests_recovery);


--
-- Name: idx_qrtz_ft_j_g; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_ft_j_g ON qrtz_fired_triggers USING btree (sched_name, job_name, job_group);


--
-- Name: idx_qrtz_ft_jg; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_ft_jg ON qrtz_fired_triggers USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_ft_t_g; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_ft_t_g ON qrtz_fired_triggers USING btree (sched_name, trigger_name, trigger_group);


--
-- Name: idx_qrtz_ft_tg; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_ft_tg ON qrtz_fired_triggers USING btree (sched_name, trigger_group);


--
-- Name: idx_qrtz_ft_trig_inst_name; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_ft_trig_inst_name ON qrtz_fired_triggers USING btree (sched_name, instance_name);


--
-- Name: idx_qrtz_j_grp; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_j_grp ON qrtz_job_details USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_j_req_recovery; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_j_req_recovery ON qrtz_job_details USING btree (sched_name, requests_recovery);


--
-- Name: idx_qrtz_t_c; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_t_c ON qrtz_triggers USING btree (sched_name, calendar_name);


--
-- Name: idx_qrtz_t_g; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_t_g ON qrtz_triggers USING btree (sched_name, trigger_group);


--
-- Name: idx_qrtz_t_j; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_t_j ON qrtz_triggers USING btree (sched_name, job_name, job_group);


--
-- Name: idx_qrtz_t_jg; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_t_jg ON qrtz_triggers USING btree (sched_name, job_group);


--
-- Name: idx_qrtz_t_n_g_state; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_t_n_g_state ON qrtz_triggers USING btree (sched_name, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_n_state; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_t_n_state ON qrtz_triggers USING btree (sched_name, trigger_name, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_next_fire_time; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_t_next_fire_time ON qrtz_triggers USING btree (sched_name, next_fire_time);


--
-- Name: idx_qrtz_t_nft_misfire; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_t_nft_misfire ON qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time);


--
-- Name: idx_qrtz_t_nft_st; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_t_nft_st ON qrtz_triggers USING btree (sched_name, trigger_state, next_fire_time);


--
-- Name: idx_qrtz_t_nft_st_misfire; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_t_nft_st_misfire ON qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_state);


--
-- Name: idx_qrtz_t_nft_st_misfire_grp; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_t_nft_st_misfire_grp ON qrtz_triggers USING btree (sched_name, misfire_instr, next_fire_time, trigger_group, trigger_state);


--
-- Name: idx_qrtz_t_state; Type: INDEX; Schema: core; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_qrtz_t_state ON qrtz_triggers USING btree (sched_name, trigger_state);


SET search_path = production, pg_catalog;

--
-- Name: activity_attendee_activity_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS activity_attendee_activity_id_idx ON activity_attendee USING btree (activity_id);


--
-- Name: activity_attendee_person_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS activity_attendee_person_id_idx ON activity_attendee USING btree (person_id);


--
-- Name: activity_event_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS activity_event_id_idx ON activity USING btree (event_id);


--
-- Name: activity_event_id_state_active_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS activity_event_id_state_active_idx ON activity USING btree (event_id, state) WHERE (state = 'ACTIVE'::text);


--
-- Name: activity_id_active_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS activity_id_active_idx ON activity USING btree (id) WHERE (state = 'ACTIVE'::text);


--
-- Name: activity_organization_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS activity_organization_id_idx ON activity USING btree (organization_id);


--
-- Name: activity_organizer_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS activity_organizer_id_idx ON activity USING btree (organizer_id);


--
-- Name: activity_type_rule_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS activity_type_rule_idx ON activity_type_rule USING btree (activity_type_id);


--
-- Name: approval_object_id_active_not_open_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS approval_object_id_active_not_open_idx ON approval USING btree (object_id) WHERE ((state = 'ACTIVE'::text) AND (approval_status <> 'OPEN'::text));


--
-- Name: attribute_option_attribute_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS attribute_option_attribute_id_idx ON attribute_option USING btree (attribute_id);


--
-- Name: consent_history_person_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS consent_history_person_id_idx ON consent_history USING btree (person_id);


--
-- Name: discussed_topic_activity_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS discussed_topic_activity_id_idx ON discussed_topic USING btree (activity_id);


--
-- Name: employee_organization_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS employee_organization_id_idx ON employee USING btree (organization_id);


--
-- Name: employee_organization_id_state_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS employee_organization_id_state_idx ON employee USING btree (organization_id, state);


--
-- Name: employee_person_id_state_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS employee_person_id_state_idx ON employee USING btree (person_id, state);


--
-- Name: event_attendee_event_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_attendee_event_id_idx ON event_attendee USING btree (event_id);


--
-- Name: event_co_organizer_event_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_co_organizer_event_id_idx ON event_co_organizer USING btree (event_id);


--
-- Name: event_compensation_event_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_compensation_event_id_idx ON event_compensation USING btree (event_id);


--
-- Name: event_contract_partner_function_event_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_contract_partner_function_event_id_idx ON event_contract_partner_function USING btree (event_id);


--
-- Name: event_contract_partner_reason_event_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_contract_partner_reason_event_id_idx ON event_contract_partner_reason USING btree (event_id);


--
-- Name: event_custom_compensation_event_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_custom_compensation_event_id_idx ON event_custom_compensation USING btree (event_id);


--
-- Name: event_custom_contract_partner_function_event_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_custom_contract_partner_function_event_id_idx ON event_custom_contract_partner_function USING btree (event_id);


--
-- Name: event_employee_attendee_event_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_employee_attendee_event_id_idx ON event_employee_attendee USING btree (event_id);


--
-- Name: event_indication_area_event_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_indication_area_event_id_idx ON event_indication_area USING btree (event_id);


--
-- Name: event_parent_event_id_state_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_parent_event_id_state_idx ON event USING btree (parent_event_id, state) WHERE (state = 'ACTIVE'::text);


--
-- Name: event_planned_participation_reason_event_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_planned_participation_reason_event_id_idx ON event_planned_participation_reason USING btree (event_id);


--
-- Name: event_speaker_person_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_speaker_person_id ON event_speaker USING btree (person_id) WHERE (participation_status = 'PARTICIPATED'::text);


--
-- Name: event_target_audience_event_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_target_audience_event_id_idx ON event_target_audience USING btree (event_id);


--
-- Name: event_to_event_subject_event_subject_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_to_event_subject_event_subject_id_idx ON event_to_event_subject USING btree (event_subject_id);


--
-- Name: event_topic_event_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_topic_event_id_idx ON event_topic USING btree (event_id);


--
-- Name: event_type_state_index; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS event_type_state_index ON event_type USING btree (state);


--
-- Name: given_promotional_material_activity_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS given_promotional_material_activity_id_idx ON given_promotional_material USING btree (activity_id);


--
-- Name: given_promotional_material_activity_id_promotional_material_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS given_promotional_material_activity_id_promotional_material_id ON given_promotional_material USING btree (activity_id, promotional_material_id);


--
-- Name: given_promotional_material_promotional_material_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS given_promotional_material_promotional_material_id_idx ON given_promotional_material USING btree (promotional_material_id);


--
-- Name: idx_additional_event_location_event_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_additional_event_location_event_id ON additional_event_location USING btree (event_id);


--
-- Name: idx_additional_event_location_organization_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_additional_event_location_organization_id ON additional_event_location USING btree (organization_id);


--
-- Name: idx_attachment_object_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_attachment_object_id ON attachment USING btree (object_id);


--
-- Name: idx_attribute_container_1; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_attribute_container_1 ON attribute_container USING btree (target_id, type);


--
-- Name: idx_attribute_value_1; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_attribute_value_1 ON attribute_value USING btree (attribute_id);


--
-- Name: idx_attribute_value_2; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_attribute_value_2 ON attribute_value USING btree (attribute_container_id);


--
-- Name: idx_attribute_value_3; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_attribute_value_3 ON attribute_value USING btree (value);


--
-- Name: idx_event_appointment_event_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_event_appointment_event_id ON event_appointment USING btree (event_id);


--
-- Name: idx_event_budget_allocation_detail_event_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_event_budget_allocation_detail_event_id ON event_budget_allocation_detail USING btree (event_id);


--
-- Name: idx_event_cost_item_event_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_event_cost_item_event_id ON event_cost_item USING btree (event_id);


--
-- Name: idx_event_organizer_person_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_event_organizer_person_id ON event USING btree (organizer_person_id);


--
-- Name: idx_event_speaker_event_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_event_speaker_event_id ON event_speaker USING btree (event_id);


--
-- Name: idx_event_to_organizing_organization_event_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_event_to_organizing_organization_event_id ON event_to_organizing_organization USING btree (event_id);


--
-- Name: idx_event_to_organizing_organization_organization_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_event_to_organizing_organization_organization_id ON event_to_organizing_organization USING btree (organization_id);


--
-- Name: idx_inventory_person_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_inventory_person_id ON inventory USING btree (person_id);


--
-- Name: idx_inventory_state; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_inventory_state ON inventory USING btree (state);


--
-- Name: idx_mailing_recipient_mailing_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_mailing_recipient_mailing_id ON mailing_recipient USING btree (mailing_id);


--
-- Name: idx_mailing_recipient_organization_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_mailing_recipient_organization_id ON mailing_recipient USING btree (organization_id);


--
-- Name: idx_mailing_recipient_person_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_mailing_recipient_person_id ON mailing_recipient USING btree (person_id);


--
-- Name: idx_organization_assignment_active; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_organization_assignment_active ON organization_assignment USING btree (state) WHERE (state = 'ACTIVE'::text);


--
-- Name: idx_organization_assignment_active_state; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_organization_assignment_active_state ON organization_assignment USING btree (state);


--
-- Name: idx_organization_attribute_value_4; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_organization_attribute_value_4 ON organization_attribute_value USING btree (organization_id, attribute_id);


--
-- Name: idx_organizational_unit_materialized_path_btree_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE UNIQUE INDEX IF NOT EXISTS idx_organizational_unit_materialized_path_btree_idx ON organizational_unit USING btree (id, materialized_path);


--
-- Name: idx_organizational_unit_state; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_organizational_unit_state ON organizational_unit USING btree (state);


--
-- Name: idx_organizational_unit_type_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_organizational_unit_type_id ON organizational_unit USING btree (organizational_unit_type_id);


--
-- Name: idx_person_assignment_org_hierarchy_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_person_assignment_org_hierarchy_id ON person_assignment USING btree (organizational_hierarchy_id);


--
-- Name: idx_person_assignment_org_unit_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_person_assignment_org_unit_id ON person_assignment USING btree (organizational_unit_id);


--
-- Name: idx_person_assignment_person_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_person_assignment_person_id ON person_assignment USING btree (person_id);


--
-- Name: idx_person_assignment_state; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_person_assignment_state ON person_assignment USING btree (state);


--
-- Name: idx_person_assignment_type_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_person_assignment_type_id ON person_assignment USING btree (person_assignment_type_id);


--
-- Name: idx_person_attribute_value_4; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_person_attribute_value_4 ON person_attribute_value USING btree (person_id, attribute_id);


--
-- Name: idx_person_attribute_value_option_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_person_attribute_value_option_id ON person_attribute_value USING btree (attribute_option_id);


--
-- Name: idx_person_touch_point_date; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_person_touch_point_date ON person_touch_point USING btree (date);


--
-- Name: idx_person_touch_point_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_person_touch_point_id ON person_touch_point USING btree (touch_point_id);


--
-- Name: idx_person_touch_point_id_type; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_person_touch_point_id_type ON person_touch_point USING btree (touch_point_id, touch_point_type);


--
-- Name: idx_person_touch_point_organizer_id_date; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_person_touch_point_organizer_id_date ON person_touch_point USING btree (organizer_id, date);


--
-- Name: idx_person_touchpoint_person_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_person_touchpoint_person_id ON person_touch_point USING btree (person_id);


--
-- Name: idx_personal_email_activity_organization_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_personal_email_activity_organization_id ON personal_email_activity USING btree (organization_id);


--
-- Name: idx_personal_email_activity_personal_email_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_personal_email_activity_personal_email_id ON personal_email_activity USING btree (personal_email_id);


--
-- Name: idx_personal_email_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_personal_email_id ON personal_email USING btree (id);


--
-- Name: idx_promotional_material_assignment_org_unit_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_promotional_material_assignment_org_unit_id ON promotional_material_assignment USING btree (organizational_unit_id);


--
-- Name: idx_promotional_material_assignment_promotional_material_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_promotional_material_assignment_promotional_material_id ON promotional_material_assignment USING btree (promotional_material_id);


--
-- Name: idx_promotional_material_assignment_state; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_promotional_material_assignment_state ON promotional_material_assignment USING btree (state);


--
-- Name: idx_sec_user_person_id; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_sec_user_person_id ON sec_user USING btree (person_id);


--
-- Name: idx_sec_user_username; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_sec_user_username ON sec_user USING btree (lower(btrim(user_name)));


--
-- Name: idx_stock_inventory; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_stock_inventory ON stock USING btree (inventory_id);


--
-- Name: idx_stock_promotional_material_id_and_type; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_stock_promotional_material_id_and_type ON stock USING btree (promotional_material_id, type);


--
-- Name: idx_stock_state; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS idx_stock_state ON stock USING btree (state);


--
-- Name: incurred_expense_activity_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS incurred_expense_activity_id_idx ON incurred_expense USING btree (activity_id);


--
-- Name: incurred_expense_expense_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS incurred_expense_expense_id_idx ON incurred_expense USING btree (expense_id);


--
-- Name: inquiry_partner_organization_person_inquiry_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS inquiry_partner_organization_person_inquiry_id_idx ON inquiry_partner_organization_person USING btree (inquiry_id);


--
-- Name: ix_channel_consent_1; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_channel_consent_1 ON channel_consent USING btree (person_id);


--
-- Name: ix_consent_document_1; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_consent_document_1 ON consent_document USING btree (id);


--
-- Name: ix_consent_document_fields_1; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_consent_document_fields_1 ON consent_document_fields USING btree (consent_document_id);


--
-- Name: ix_consent_document_options_1; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_consent_document_options_1 ON consent_document_options USING btree (consent_document_id);


--
-- Name: ix_efpia_consent_1; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_efpia_consent_1 ON efpia_consent USING btree (person_id);


--
-- Name: ix_efpia_history_1; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_efpia_history_1 ON efpia_history USING btree (person_id);


--
-- Name: ix_id_translation_1; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_id_translation_1 ON id_translation USING btree (aggregate_id);


--
-- Name: ix_id_translation_2; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_id_translation_2 ON id_translation USING btree (value_object_id);


--
-- Name: ix_id_translation_3; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_id_translation_3 ON id_translation USING btree (external_reference_id, external_reference_value);


--
-- Name: ix_organization_attribute_value_1; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_organization_attribute_value_1 ON organization_attribute_value USING btree (attribute_id);


--
-- Name: ix_organization_attribute_value_2; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_organization_attribute_value_2 ON organization_attribute_value USING btree (organization_id);


--
-- Name: ix_organization_attribute_value_3; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_organization_attribute_value_3 ON organization_attribute_value USING btree (value);


--
-- Name: ix_person_attribute_value_1; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_person_attribute_value_1 ON person_attribute_value USING btree (attribute_id);


--
-- Name: ix_person_attribute_value_2; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_person_attribute_value_2 ON person_attribute_value USING btree (person_id);


--
-- Name: ix_person_attribute_value_3; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_person_attribute_value_3 ON person_attribute_value USING btree (value);


--
-- Name: ix_person_communication_data_1; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_person_communication_data_1 ON person_communication_data USING btree (communication_data_type_id);


--
-- Name: ix_person_communication_data_2; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_person_communication_data_2 ON person_communication_data USING btree (person_id);


--
-- Name: ix_person_speciality_1; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_person_speciality_1 ON person_speciality USING btree (speciality_id);


--
-- Name: ix_person_speciality_2; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS ix_person_speciality_2 ON person_speciality USING btree (person_id);


--
-- Name: list_condition_definition_state_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS list_condition_definition_state_idx ON list_condition_definition USING btree (state);


--
-- Name: list_condition_list_condition_definition_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS list_condition_list_condition_definition_id_idx ON list_condition USING btree (list_condition_definition_id);


--
-- Name: list_condition_sequence_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS list_condition_sequence_idx ON list_condition USING btree (sequence);


--
-- Name: list_criteria_list_condition_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS list_criteria_list_condition_id_idx ON list_criteria USING btree (list_condition_id);


--
-- Name: list_criteria_value_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS list_criteria_value_idx ON list_criteria USING btree (value);


--
-- Name: list_id_list_condition; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS list_id_list_condition ON list_condition USING btree (list_id);


--
-- Name: list_name_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS list_name_idx ON list USING btree (name);


--
-- Name: list_state_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS list_state_idx ON list USING btree (state);


--
-- Name: list_type_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS list_type_idx ON list USING btree (type);


--
-- Name: organization_address_organization_id_address_type_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS organization_address_organization_id_address_type_idx ON organization_address USING btree (organization_id, address_type);


--
-- Name: organization_address_organization_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS organization_address_organization_id_idx ON organization_address USING btree (organization_id);


--
-- Name: organization_address_postal_code_city_id_text_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS organization_address_postal_code_city_id_text_idx ON organization_address USING btree (((postal_code_city_id)::text));


--
-- Name: organization_assignment_organization_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS organization_assignment_organization_id_idx ON organization_assignment USING btree (organization_id);


--
-- Name: organization_assignment_unit_org_msd_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE UNIQUE INDEX IF NOT EXISTS organization_assignment_unit_org_msd_idx ON organization_assignment USING btree (organization_id, organizational_unit_id) WHERE ((organizational_hierarchy_id = '03f9ce00-8517-b28e-b1a1-8a4dabf4c0e4'::uuid) AND (assignment_type = 'CALCULATED'::text) AND (state = 'ACTIVE'::text));


--
-- Name: organization_communication_data_organization_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS organization_communication_data_organization_id_idx ON organization_communication_data USING btree (organization_id);


--
-- Name: organization_customer_number_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS organization_customer_number_idx ON organization USING btree (customer_number);


--
-- Name: organization_id_state_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS organization_id_state_idx ON organization USING btree (id, state) WHERE (state = 'ACTIVE'::text);


--
-- Name: organization_relation_source_organization_id_active_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS organization_relation_source_organization_id_active_idx ON organization_relation USING btree (source_organization_id) WHERE (state = 'ACTIVE'::text);


--
-- Name: organization_relation_target_organization_id_active_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS organization_relation_target_organization_id_active_idx ON organization_relation USING btree (target_organization_id) WHERE (state = 'ACTIVE'::text);


--
-- Name: person_communication_data_person_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS person_communication_data_person_id_idx ON person_communication_data USING btree (person_id);


--
-- Name: person_id_idx_template_tracking; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS person_id_idx_template_tracking ON template_tracking USING btree (person_id);


--
-- Name: person_id_state_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS person_id_state_idx ON person USING btree (id, state) WHERE (state = 'ACTIVE'::text);


--
-- Name: person_speciality_group_person_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS person_speciality_group_person_id_idx ON person_speciality_group USING btree (person_id);


--
-- Name: person_speciality_person_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS person_speciality_person_id_idx ON person_speciality USING btree (person_id);


--
-- Name: person_to_person_type_person_type_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS person_to_person_type_person_type_idx ON person_to_person_type USING btree (person_type_id);


--
-- Name: person_touch_point_person_id_touch_point_id_index; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS person_touch_point_person_id_touch_point_id_index ON person_touch_point USING btree (person_id, touch_point_id);


--
-- Name: personal_email_id_idx_template_tracking; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS personal_email_id_idx_template_tracking ON template_tracking USING btree (personal_email_id);


--
-- Name: personal_email_receiver_active_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS personal_email_receiver_active_idx ON personal_email USING btree (receiver) WHERE ((state)::text = 'ACTIVE'::text);


--
-- Name: personal_event_attendee_person_id_participated_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS personal_event_attendee_person_id_participated_idx ON event_attendee USING btree (person_id) WHERE (participation_status = 'PARTICIPATED'::text);


--
-- Name: process_instance_association_value_key_value_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS process_instance_association_value_key_value_idx ON process_instance_association_value USING btree (key, value);


--
-- Name: speaker_speaker_person_id_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS speaker_speaker_person_id_idx ON speaker USING btree (speaker_person_id);


--
-- Name: state_idx_personal_email; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS state_idx_personal_email ON personal_email USING btree (state);


--
-- Name: support_ticket_person_id_active_idx; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS support_ticket_person_id_active_idx ON support_ticket USING btree (person_id) WHERE (state = 'ACTIVE'::text);


--
-- Name: template_name; Type: INDEX; Schema: production; Owner: build
--

CREATE INDEX IF NOT EXISTS template_name ON template USING btree (name);


--
-- Name: unique_by_type_version_and_signer; Type: INDEX; Schema: production; Owner: build
--

CREATE UNIQUE INDEX IF NOT EXISTS unique_by_type_version_and_signer ON consent_document USING btree (document_type, document_version, signer_id) WHERE ((state)::text = 'ACTIVE'::text);


SET search_path = core, pg_catalog;

--
-- Name: qrtz_blob_triggers_sched_name_fkey; Type: FK CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_blob_triggers
    ADD CONSTRAINT qrtz_blob_triggers_sched_name_fkey FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_cron_triggers_sched_name_fkey; Type: FK CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_cron_triggers
    ADD CONSTRAINT qrtz_cron_triggers_sched_name_fkey FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simple_triggers_sched_name_fkey; Type: FK CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_simple_triggers
    ADD CONSTRAINT qrtz_simple_triggers_sched_name_fkey FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_simprop_triggers_sched_name_fkey; Type: FK CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_simprop_triggers
    ADD CONSTRAINT qrtz_simprop_triggers_sched_name_fkey FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES qrtz_triggers(sched_name, trigger_name, trigger_group);


--
-- Name: qrtz_triggers_sched_name_fkey; Type: FK CONSTRAINT; Schema: core; Owner: build
--

ALTER TABLE ONLY qrtz_triggers
    ADD CONSTRAINT qrtz_triggers_sched_name_fkey FOREIGN KEY (sched_name, job_name, job_group) REFERENCES qrtz_job_details(sched_name, job_name, job_group);


SET search_path = production, pg_catalog;

--
-- Name: consent_document_fields_consent_document_id_fkey; Type: FK CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY consent_document_fields
    ADD CONSTRAINT consent_document_fields_consent_document_id_fkey FOREIGN KEY (consent_document_id) REFERENCES consent_document(id);


--
-- Name: consent_document_options_consent_document_id_fkey; Type: FK CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY consent_document_options
    ADD CONSTRAINT consent_document_options_consent_document_id_fkey FOREIGN KEY (consent_document_id) REFERENCES consent_document(id);


--
-- Name: process_instance_association_value_process_instance_id_fkey; Type: FK CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY process_instance_association_value
    ADD CONSTRAINT process_instance_association_value_process_instance_id_fkey FOREIGN KEY (process_instance_id) REFERENCES process_instance(id) ON DELETE CASCADE;


--
-- Name: zov2_process_position_event_id_fkey; Type: FK CONSTRAINT; Schema: production; Owner: build
--

ALTER TABLE ONLY zov2_process_details
    ADD CONSTRAINT zov2_process_position_event_id_fkey FOREIGN KEY (event_id) REFERENCES event(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: build
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

