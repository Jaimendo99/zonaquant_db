-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- Table to store different types of accounts
CREATE TABLE account_types
(
    account_type_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    account_type    TEXT                              NOT NULL UNIQUE
);

-- Table to store accounts associated with users, producers, etc.
CREATE TABLE accounts
(
    account_id      INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    account_type_id INTEGER                           NOT NULL,
    balance         REAL                              NOT NULL,
    created_at      TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at      TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (account_type_id) REFERENCES account_types (account_type_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table to store user roles
CREATE TABLE roles
(
    role_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    role    TEXT                              NOT NULL UNIQUE
);

-- Table to store user credentials and associated account
CREATE TABLE users
(
    user_id    INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    username   TEXT                              NOT NULL UNIQUE,
    password   TEXT                              NOT NULL, -- Store hashed passwords
    role_id    INTEGER                           NOT NULL,
    account_id INTEGER                           NOT NULL,
    created_at TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (role_id) REFERENCES roles (role_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (account_id) REFERENCES accounts (account_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table to store producers' information
CREATE TABLE producers
(
    producer_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    full_name   TEXT                              NOT NULL,
    RUC         TEXT UNIQUE,
    nickname    TEXT,
    account_id  INTEGER                           NOT NULL,
    created_at  TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at  TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (account_id) REFERENCES accounts (account_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table to store empacadoras' (packaging companies) information
CREATE TABLE empacadoras
(
    empacadora_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    business_name TEXT                              NOT NULL,
    RUC           TEXT                              NOT NULL UNIQUE,
    account_id    INTEGER                           NOT NULL,
    created_at    TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at    TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (account_id) REFERENCES accounts (account_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Table to store purchase reports
CREATE TABLE purchase_reports
(
    purchase_report_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    date               TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    weight_discount    REAL                              NOT NULL,
    money_discount     REAL                              NOT NULL,
    total              REAL                              NOT NULL,
    commission         REAL                              NOT NULL,
    checked            INTEGER                           NOT NULL DEFAULT 0 CHECK (checked IN (0, 1)),
    created_at         TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at         TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime'))
);

-- Table to store details of purchase reports
CREATE TABLE purchase_report_details
(
    detail_id          INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    size_grams         REAL                              NOT NULL,
    pounds             REAL                              NOT NULL,
    price_per_pound    REAL                              NOT NULL,
    purchase_report_id INTEGER                           NOT NULL,
    created_at         TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at         TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (purchase_report_id) REFERENCES purchase_reports (purchase_report_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table to store selling reports
CREATE TABLE selling_reports
(
    selling_report_id   INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    date                TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    factory_batch       TEXT                              NOT NULL,
    tail_weight         REAL                              NOT NULL,
    head_weight         REAL                              NOT NULL,
    trash_weight        REAL                              NOT NULL,
    logistics_fee       REAL                              NOT NULL,
    logistics_retention REAL                              NOT NULL,
    product_retention   REAL                              NOT NULL,
    created_at          TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at          TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime'))
);

-- Table to store possible sizes
CREATE TABLE sizes
(
    size_id    INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    size_value TEXT                              NOT NULL UNIQUE
);

-- Table to store possible classes
CREATE TABLE classes
(
    class_id   INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    class_name TEXT                              NOT NULL UNIQUE
);

-- Table to store details of selling reports
CREATE TABLE selling_report_details
(
    detail_id         INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    size_id           INTEGER                           NOT NULL,
    class_id          INTEGER                           NOT NULL,
    box_quantity      INTEGER                           NOT NULL,
    pounds            REAL                              NOT NULL,
    price_per_pound   REAL                              NOT NULL,
    selling_report_id INTEGER                           NOT NULL,
    created_at        TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at        TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (size_id) REFERENCES sizes (size_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes (class_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (selling_report_id) REFERENCES selling_reports (selling_report_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table to store delivery reports
CREATE TABLE delivery_reports
(
    delivery_report_id   INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    date                 TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    delivery_tracking    TEXT                              NOT NULL,
    delivery_weight      REAL                              NOT NULL,
    product_unit         TEXT                              NOT NULL,
    unit_amount          REAL                              NOT NULL,
    price_per_unit       REAL                              NOT NULL,
    factory_total_weight REAL                              NOT NULL,
    created_at           TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at           TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime'))
);

-- Table to store batch information
CREATE TABLE batches
(
    batch_id           INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    batch_name         TEXT                              NOT NULL UNIQUE,
    producer_id        INTEGER                           NOT NULL,
    empacadora_id      INTEGER                           NOT NULL,
    purchase_report_id INTEGER,
    selling_report_id  INTEGER,
    delivery_report_id INTEGER,
    created_at         TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at         TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (producer_id) REFERENCES producers (producer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (empacadora_id) REFERENCES empacadoras (empacadora_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (purchase_report_id) REFERENCES purchase_reports (purchase_report_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (selling_report_id) REFERENCES selling_reports (selling_report_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (delivery_report_id) REFERENCES delivery_reports (delivery_report_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table to store logistics information associated with batches
CREATE TABLE logistics
(
    logistics_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    amount       REAL                              NOT NULL,
    description  TEXT                              NOT NULL,
    date         TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    batch_id     INTEGER                           NOT NULL,
    created_at   TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at   TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (batch_id) REFERENCES batches (batch_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table to store transaction states
CREATE TABLE transaction_states
(
    state_id   INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    state_name TEXT                              NOT NULL UNIQUE
);

-- Table to store financial transactions
CREATE TABLE transactions
(
    transaction_id  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    from_account_id INTEGER                           NOT NULL,
    to_account_id   INTEGER                           NOT NULL,
    amount          REAL                              NOT NULL,
    date            TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    state_id        INTEGER                           NOT NULL,
    description     TEXT,
    batch_id        INTEGER,
    created_at      TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at      TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (from_account_id) REFERENCES accounts (account_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (to_account_id) REFERENCES accounts (account_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (state_id) REFERENCES transaction_states (state_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (batch_id) REFERENCES batches (batch_id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Table to store details of transactions
CREATE TABLE transaction_details
(
    transaction_detail_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    transaction_id        INTEGER                           NOT NULL,
    amount                REAL                              NOT NULL,
    description           TEXT,
    created_at            TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at            TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (transaction_id) REFERENCES transactions (transaction_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE advances
(
    advance_id  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    amount      REAL                              NOT NULL,
    producer_id INTEGER                           NOT NULL,
    date        TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    created_at  TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),
    updated_at  TEXT                              NOT NULL DEFAULT (datetime('now', 'localtime')),

    FOREIGN KEY (producer_id) REFERENCES producers (producer_id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Indexes for optimizing queries
CREATE INDEX idx_users_role_id ON users (role_id);
CREATE INDEX idx_users_account_id ON users (account_id);
CREATE INDEX idx_transactions_from_account_id ON transactions (from_account_id);
CREATE INDEX idx_transactions_to_account_id ON transactions (to_account_id);
CREATE INDEX idx_batches_producer_id ON batches (producer_id);
CREATE INDEX idx_batches_empacadora_id ON batches (empacadora_id);
CREATE INDEX idx_purchase_report_details_report_id ON purchase_report_details (purchase_report_id);
CREATE INDEX idx_selling_report_details_report_id ON selling_report_details (selling_report_id);
CREATE INDEX idx_logistics_batch_id ON logistics (batch_id);
CREATE INDEX idx_transactions_batch_id ON transactions (batch_id);