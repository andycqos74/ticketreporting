-- =============================================================================
--  Soccer Camps 2026 shirt-collection tracker
--  ---------------------------------------------------------------------------
--  Free season tickets + free replica shirts are issued (via TicketCo) to
--  every child on a soccer camp. This table holds the season-ticket holders
--  pulled from TicketCo season pass 1127619, ticket type "Soccer Camps 2026",
--  plus the shirt-collection state so each kid can only collect one shirt.
--
--  Run once against the existing DB (default: qosfctickets). The app also
--  runs this automatically on startup, so a manual run is optional.
-- =============================================================================

CREATE TABLE IF NOT EXISTS soccercamp_tickets (
  TicketID         VARCHAR(64)  NOT NULL,                 -- TicketCo uuid; the QR code payload
  TicketCoRef      VARCHAR(45)  NOT NULL,                 -- ref_number; human-typeable fallback lookup
  PurchaseDate     DATETIME     NULL,
  TicketType       VARCHAR(255) NULL,                     -- item_type_title ("Soccer Camps 2026")
  EventName        VARCHAR(255) NULL,                     -- season pass title
  HolderFirstName  VARCHAR(255) NULL,
  HolderLastName   VARCHAR(255) NULL,
  BuyerFirstName   VARCHAR(255) NULL,
  BuyerLastName    VARCHAR(255) NULL,
  Collected        TINYINT(1)   NOT NULL DEFAULT 0,
  CollectedDate    DATETIME     NULL,
  CollectedBy      VARCHAR(100) NULL,                     -- optional: operator name typed on the collect page
  ShirtSize        VARCHAR(20)  NULL,
  CreatedAt        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UpdatedAt        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (TicketID),
  UNIQUE KEY uq_ticketcoref (TicketCoRef)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
