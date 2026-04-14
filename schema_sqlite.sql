-- ============================================================
-- NEXTRIDE: SQLite Schema (Fallback for Replit/local dev)
-- ============================================================

CREATE TABLE IF NOT EXISTS Students (
    student_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name       TEXT NOT NULL,
    email      TEXT NOT NULL UNIQUE,
    phone      TEXT,
    password   TEXT NOT NULL,
    created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS Rides (
    ride_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    driver_id       INTEGER NOT NULL,
    source          TEXT NOT NULL,
    destination     TEXT NOT NULL,
    ride_time       TEXT NOT NULL,
    total_seats     INTEGER NOT NULL CHECK (total_seats > 0),
    available_seats INTEGER NOT NULL,
    price_per_seat  REAL NOT NULL CHECK (price_per_seat >= 0),
    status          TEXT DEFAULT 'Open' CHECK (status IN ('Open','Full','Cancelled','Completed')),
    created_at      TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (driver_id) REFERENCES Students(student_id)
);

CREATE TABLE IF NOT EXISTS Requests (
    request_id INTEGER PRIMARY KEY AUTOINCREMENT,
    ride_id    INTEGER NOT NULL,
    rider_id   INTEGER NOT NULL,
    status     TEXT DEFAULT 'Pending' CHECK (status IN ('Pending','Accepted','Rejected','Cancelled')),
    created_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (ride_id)  REFERENCES Rides(ride_id),
    FOREIGN KEY (rider_id) REFERENCES Students(student_id),
    UNIQUE (ride_id, rider_id)
);

CREATE TABLE IF NOT EXISTS Payments (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    request_id INTEGER NOT NULL UNIQUE,
    amount     REAL NOT NULL,
    status     TEXT DEFAULT 'Pending' CHECK (status IN ('Pending','Paid','Refunded')),
    paid_at    TEXT,
    FOREIGN KEY (request_id) REFERENCES Requests(request_id)
);
