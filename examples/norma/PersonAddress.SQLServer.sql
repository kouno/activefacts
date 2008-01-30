﻿CREATE SCHEMA PersonAddress
GO

GO

CREATE TABLE PersonAddress.Person
(
	familyName NATIONAL CHARACTER VARYING(20) NOT NULL,
	givenNames NATIONAL CHARACTER VARYING(20) NOT NULL,
	livesAtAddressStreetLine1 NATIONAL CHARACTER VARYING(64) NOT NULL,
	livesAtAddressStreetLine2 NATIONAL CHARACTER VARYING(64) NOT NULL,
	livesAtAddressStreetLine3 NATIONAL CHARACTER VARYING(64) NOT NULL,
	livesAtAddressCity NATIONAL CHARACTER VARYING(64) NOT NULL,
	livesAtAddressPostcode NATIONAL CHARACTER VARYING() NOT NULL,
	livesAtAddressStreetNumber NATIONAL CHARACTER VARYING(12) NOT NULL,
	CONSTRAINT PersonIsKnownByFamilyNameGivenName PRIMARY KEY(familyName, givenNames)
)
GO



GO