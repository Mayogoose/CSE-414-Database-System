-- ============================================================
-- test-populate.sql
-- Run AFTER creating users via the app (create_caregiver / create_patient),
-- since passwords are hashed by the app and cannot be inserted via SQL.
--
-- Step 1 – in the app, run:
--   create_caregiver c1 Test1234!
--   create_caregiver c2 Test1234!
--   create_caregiver c3 Test1234!
--   create_patient   p1 Test1234!
--   create_patient   p2 Test1234!
--
-- Step 2 – run this file:
--   sqlite3 /Users/glmeiyao/scheduler.db < test-populate.sql
-- ============================================================

-- Vaccines
INSERT OR IGNORE INTO Vaccines (Name, Doses) VALUES ('covid', 10);
INSERT OR IGNORE INTO Vaccines (Name, Doses) VALUES ('flu',   5);
INSERT OR IGNORE INTO Vaccines (Name, Doses) VALUES ('hpv',   3);

-- Caregiver availabilities
INSERT OR IGNORE INTO Availabilities (Time, Username) VALUES ('2026-03-15', 'c1');
INSERT OR IGNORE INTO Availabilities (Time, Username) VALUES ('2026-03-15', 'c2');
INSERT OR IGNORE INTO Availabilities (Time, Username) VALUES ('2026-03-15', 'c3');
INSERT OR IGNORE INTO Availabilities (Time, Username) VALUES ('2026-03-16', 'c1');
INSERT OR IGNORE INTO Availabilities (Time, Username) VALUES ('2026-03-16', 'c2');
INSERT OR IGNORE INTO Availabilities (Time, Username) VALUES ('2026-03-17', 'c2');
INSERT OR IGNORE INTO Availabilities (Time, Username) VALUES ('2026-03-17', 'c3');

-- Verify
SELECT 'Vaccines:'  AS '';  SELECT Name, Doses FROM Vaccines;
SELECT 'Caregivers:' AS ''; SELECT Username FROM Caregivers;
SELECT 'Patients:'  AS '';  SELECT Username FROM Patients;
SELECT 'Availabilities:' AS ''; SELECT Time, Username FROM Availabilities ORDER BY Time, Username;
