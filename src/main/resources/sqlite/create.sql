CREATE TABLE Caregivers (
    Username varchar(255),
    Salt BINARY(16),
    Hash BINARY(16),
    PRIMARY KEY (Username)
);

CREATE TABLE Patients (
    Username varchar(255) PRIMARY KEY,
    salt BINARY(16),
    hash BINARY(16)
);

CREATE TABLE Availabilities (
    Time date,
    Username varchar(255) REFERENCES Caregivers,
    PRIMARY KEY (Time, Username)
);

CREATE TABLE Vaccines (
    Name varchar(255),
    Doses int,
    PRIMARY KEY (Name)
);

CREATE TABLE Appointments (
    AppointmentID INTEGER PRIMARY KEY AUTOINCREMENT,
    PatientUsername varchar(255) REFERENCES Patients(Username),
    CaregiverUsername varchar(255) REFERENCES Caregivers(Username),
    VaccineName varchar(255) REFERENCES Vaccines(Name),
    AppointmentDate date
);