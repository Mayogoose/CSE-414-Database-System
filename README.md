# CSE 414 — HW 6: Appointment Reservation System

> **Course:** CSE 414 (Database Systems) — Winter 2026
> **Objective:** Gain experience with database application development and learn how to use SQL from within Java via JDBC.

---

## Overview

A command-line vaccine appointment scheduling application backed by a local SQLite database. Users are either **patients** (booking appointments) or **caregivers** (managing availability and vaccine inventory).

---

## Project Structure

```
vaccine-scheduler-java-main/
├── src/main/
│   ├── scheduler/
│   │   ├── Scheduler.java              # Main entry point (CLI)
│   │   ├── db/
│   │   │   └── ConnectionManager.java  # JDBC connection wrapper
│   │   ├── model/
│   │   │   ├── Caregiver.java          # Caregiver data model
│   │   │   ├── Patient.java            # Patient data model
│   │   │   └── Vaccine.java            # Vaccine data model
│   │   └── util/
│   │       └── Util.java               # Password hashing utilities
│   └── resources/
│       ├── sqlite/
│       │   └── create.sql              # SQLite table definitions
│       └── aurora/
│           └── aurora-create.sql       # Amazon Aurora table definitions (optional)
└── lib/
    └── sqlite-jdbc-3.49.1.0.jar        # SQLite JDBC driver
```

---

## Setup

### 1. Prerequisites

- Java 11+
- IntelliJ IDEA (recommended)
- SQLite JDBC driver (`sqlite-jdbc-3.49.1.0.jar`) — place in `lib/`

### 2. Configure IntelliJ

1. Open the project in IntelliJ with `vaccine-scheduler-java-main` as the root.
2. Right-click `vaccine-scheduler-java-main` → **Mark Directory As** → **Sources Root**.
3. Go to **File → Project Structure → Modules → Dependencies**, click `+`, select **Jars or Directories**, and add the JDBC jar from `lib/`.
4. Add a Run Configuration (**Application**):
   - **Main class:** `scheduler.Scheduler`
   - **Environment variable:** `DBPath=~/scheduler.db` (path to your SQLite database file)

### 3. Initialize the Database

Before running, create the tables in your SQLite database:

```bash
sqlite3 ~/scheduler.db < src/main/resources/sqlite/create.sql
```

### 4. Run the Application

Run `Scheduler.java`. You should see:

```
Welcome to the COVID-19 Vaccine Reservation Scheduling Application!
*** Please enter one of the following commands ***
> create_patient <username> <password>
> create_caregiver <username> <password>
> login_patient <username> <password>
> login_caregiver <username> <password>
> search_caregiver_schedule <date>
> reserve <date> <vaccine>
> upload_availability <date>
> cancel <appointment_id>
> add_doses <vaccine> <number>
> show_appointments
> logout
> quit
```

---

## Database Schema

```sql
CREATE TABLE Caregivers (
    Username VARCHAR(255) PRIMARY KEY,
    Salt     BINARY(16),
    Hash     BINARY(16)
);

CREATE TABLE Patients (
    Username VARCHAR(255) PRIMARY KEY,
    Salt     BINARY(16),
    Hash     BINARY(16)
);

CREATE TABLE Availabilities (
    Time     DATE,
    Username VARCHAR(255) REFERENCES Caregivers,
    PRIMARY KEY (Time, Username)
);

CREATE TABLE Vaccines (
    Name  VARCHAR(255) PRIMARY KEY,
    Doses INT
);

CREATE TABLE Appointments (
    AppointmentID     INTEGER PRIMARY KEY AUTOINCREMENT,
    PatientUsername   VARCHAR(255) REFERENCES Patients(Username),
    CaregiverUsername VARCHAR(255) REFERENCES Caregivers(Username),
    VaccineName       VARCHAR(255) REFERENCES Vaccines(Name),
    AppointmentDate   DATE
);
```

---

## Commands

| Command | Role | Description |
|---|---|---|
| `create_patient <username> <password>` | — | Register a new patient |
| `create_caregiver <username> <password>` | — | Register a new caregiver |
| `login_patient <username> <password>` | — | Log in as a patient |
| `login_caregiver <username> <password>` | — | Log in as a caregiver |
| `search_caregiver_schedule <date>` | Both | List available caregivers and vaccine inventory for a date |
| `upload_availability <date>` | Caregiver | Mark yourself available on a date (`YYYY-MM-DD`) |
| `add_doses <vaccine> <number>` | Caregiver | Add vaccine doses to inventory |
| `reserve <date> <vaccine>` | Patient | Book an appointment |
| `show_appointments` | Both | View your scheduled appointments |
| `cancel <appointment_id>` | Both | Cancel an appointment (extra credit) |
| `logout` | Both | Log out of current session |
| `quit` | — | Exit the application |

### Example Workflow

```
# Caregiver sets up availability
> login_caregiver docsmith Password1!
> upload_availability 2026-03-20
> add_doses Pfizer 10
> logout

# Patient books an appointment
> login_patient johndoe Password1!
> search_caregiver_schedule 2026-03-20
> reserve 2026-03-20 Pfizer
Appointment ID 1, Caregiver username docsmith
> show_appointments
1 Pfizer 2026-03-20 docsmith
> cancel 1
Appointment ID 1 has been successfully canceled
```

---

## Password Requirements

Passwords must be **strong**:
- At least 8 characters
- At least one uppercase and one lowercase letter
- At least one digit
- At least one special character from `!`, `@`, `#`, `?`

---

## Security

Passwords are never stored in plain text. The app uses **PBKDF2WithHmacSHA1** with a random 16-byte salt for secure password hashing.
