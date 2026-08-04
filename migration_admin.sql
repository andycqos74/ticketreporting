-- =============================================================================
--  Ticket-type mapping (per fixture) for the admin page on dash_control.aspx.
--  Replaces the keyword classification (%home%/%away%/walkup/season) with an
--  explicit map, because ticket types are created per fixture and vary.
--  Run once against qosfctickets.
-- =============================================================================

-- One row per (fixture, ticket type). "Mapping only" model: the report view
-- classifies from these columns; a type with no row here is treated as Other.
CREATE TABLE IF NOT EXISTS ticket_type_map (
  fixtureid   VARCHAR(45)  NOT NULL,
  tickettype  VARCHAR(255) NOT NULL,                 -- the TicketType title as stored in ticketco_matchsales_live
  homeaway    ENUM('home','away','na')            NOT NULL DEFAULT 'na',
  attendance  ENUM('sold','checkedin','exclude')  NOT NULL DEFAULT 'checkedin',  -- which count feeds Reported Attendance
  channel     ENUM('online','walkup')             NOT NULL DEFAULT 'online',
  category    ENUM('season','match')              NOT NULL DEFAULT 'match',
  updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (fixtureid, tickettype)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Per-fixture admin extras (currently just the manual "other" figure).
CREATE TABLE IF NOT EXISTS fixture_admin (
  fixtureid    VARCHAR(45) NOT NULL PRIMARY KEY,
  other_manual INT NOT NULL DEFAULT 0,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
