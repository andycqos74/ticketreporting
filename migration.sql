-- =============================================================================
--  Single-table + filter model for the live dashboard
--  Run against the qosfctickets database.
--
--  Model:
--    * The poller writes the CURRENT fixture's rows into ticketco_matchsales_live
--      (upsert keyed on fixtureid + TicketCoRef), keeping every fixture's data.
--    * It records which fixture to show in dashboard_current_fixture (auto-picked
--      from qosfclivecopy.vw_nexthomematch.ticketcoid, or a manual override).
--    * vw_ticketsalesreport is filtered to that fixture, so the dashboard always
--      shows the current match with no archive/clear step.
-- =============================================================================

-- 1) State table: one row holding the fixture the dashboard should display.
CREATE TABLE IF NOT EXISTS dashboard_current_fixture (
  id         TINYINT      NOT NULL PRIMARY KEY,
  fixtureid  VARCHAR(45)  NULL
);
INSERT INTO dashboard_current_fixture (id, fixtureid)
VALUES (1, NULL)
ON DUPLICATE KEY UPDATE fixtureid = fixtureid;   -- no-op if row already there

-- 2) Live table now holds MANY fixtures, so dedupe per (fixture, ticket) instead
--    of per ticket alone. Truncate first — it is only the live cache and the
--    poller refills it within one interval.
TRUNCATE TABLE ticketco_matchsales_live;
ALTER TABLE ticketco_matchsales_live
  DROP INDEX TicketCoRef_UNIQUE,
  ADD UNIQUE KEY uq_fixture_ref (fixtureid, TicketCoRef);

-- 3) Filter the dashboard view to the current fixture.
--    vw_ticketsalesreport currently ends with:   ... from ticketco_matchsales_live
--    Re-create it with the SAME body plus this clause appended at the very end:
--
--        WHERE fixtureid = (SELECT fixtureid FROM dashboard_current_fixture LIMIT 1)
--
--    In MySQL Workbench: right-click vw_ticketsalesreport -> Alter View, add the
--    WHERE line after the final FROM, then Apply. (Paste the full CREATE VIEW here
--    if you'd like it handed back ready-made.)

-- Privilege note: the app's DB user (qosfclivedb) must be able to SELECT
-- qosfclivecopy.vw_nexthomematch (it already reaches qosfclivecopy via the
-- QOSLive connection) and INSERT/UPDATE dashboard_current_fixture.
