CREATE TABLE AllowedRange (
	-- AllowedRange is where ValueRestriction allows ValueRange and maybe ValueRange has maximum-Bound and Bound is inclusive,
	ValueRangeMaximumBoundIsInclusive       bit NULL,
	-- AllowedRange is where ValueRestriction allows ValueRange and maybe ValueRange has maximum-Bound and Bound has Value,
	ValueRangeMaximumBoundValue             varchar(256) NULL,
	-- AllowedRange is where ValueRestriction allows ValueRange and maybe ValueRange has minimum-Bound and Bound is inclusive,
	ValueRangeMinimumBoundIsInclusive       bit NULL,
	-- AllowedRange is where ValueRestriction allows ValueRange and maybe ValueRange has minimum-Bound and Bound has Value,
	ValueRangeMinimumBoundValue             varchar(256) NULL,
	-- AllowedRange is where ValueRestriction allows ValueRange and ValueRestriction has ValueRestrictionId,
	ValueRestrictionId                      int NOT NULL,
	UNIQUE(ValueRestrictionId, ValueRangeMinimumBoundValue, ValueRangeMinimumBoundIsInclusive, ValueRangeMaximumBoundValue, ValueRangeMaximumBoundIsInclusive)
)
GO

CREATE TABLE Concept (
	-- Concept is independent,
	IsIndependent                           bit NOT NULL,
	-- Concept is called Name,
	Name                                    varchar(64) NOT NULL,
	-- maybe Concept uses Pronoun,
	Pronoun                                 varchar(20) NULL CHECK(Pronoun = 'feminine' OR Pronoun = 'masculine' OR Pronoun = 'personal'),
	-- maybe ValueType is a subtype of Concept and maybe ValueType has Length,
	ValueTypeLength                         int NULL,
	-- maybe ValueType is a subtype of Concept and maybe ValueType has Scale,
	ValueTypeScale                          int NULL,
	-- maybe ValueType is a subtype of Concept and maybe ValueType is subtype of Supertype and Concept is called Name,
	ValueTypeSupertypeName                  varchar(64) NULL,
	-- maybe ValueType is a subtype of Concept and maybe ValueType is subtype of Supertype and Concept belongs to Vocabulary and Vocabulary is called Name,
	ValueTypeSupertypeVocabularyName        varchar(64) NULL,
	-- maybe ValueType is a subtype of Concept and maybe ValueType is of Unit and Unit has UnitId,
	ValueTypeUnitId                         int NULL,
	-- maybe ValueType is a subtype of Concept and maybe ValueType has ValueRestriction and ValueRestriction has ValueRestrictionId,
	ValueTypeValueRestrictionId             int NULL,
	-- Concept belongs to Vocabulary and Vocabulary is called Name,
	VocabularyName                          varchar(64) NOT NULL,
	PRIMARY KEY(VocabularyName, Name),
	FOREIGN KEY (ValueTypeSupertypeName, ValueTypeSupertypeVocabularyName) REFERENCES Concept (Name, VocabularyName)
)
GO

CREATE TABLE [Constraint] (
	-- Constraint has ConstraintId,
	ConstraintId                            int IDENTITY NOT NULL,
	-- maybe Constraint requires Enforcement,
	Enforcement                             varchar(16) NULL,
	-- maybe Name is of Constraint,
	Name                                    varchar(64) NULL,
	-- maybe PresenceConstraint is a subtype of Constraint and PresenceConstraint is mandatory,
	PresenceConstraintIsMandatory           bit NULL,
	-- maybe PresenceConstraint is a subtype of Constraint and PresenceConstraint is preferred identifier,
	PresenceConstraintIsPreferredIdentifier bit NULL,
	-- maybe PresenceConstraint is a subtype of Constraint and maybe PresenceConstraint has max-Frequency restricted to {1..},
	PresenceConstraintMaxFrequency          int NULL CHECK(PresenceConstraintMaxFrequency >= 1),
	-- maybe PresenceConstraint is a subtype of Constraint and maybe PresenceConstraint has min-Frequency restricted to {2..},
	PresenceConstraintMinFrequency          int NULL CHECK(PresenceConstraintMinFrequency >= 2),
	-- maybe PresenceConstraint is a subtype of Constraint and PresenceConstraint covers RoleSequence and RoleSequence has RoleSequenceId,
	PresenceConstraintRoleSequenceId        int NULL,
	-- maybe RingConstraint is a subtype of Constraint and maybe other-Role is of RingConstraint and Role is where FactType has Ordinal place played by Concept and FactType has FactTypeId,
	RingConstraintOtherRoleFactTypeId       int NULL,
	-- maybe RingConstraint is a subtype of Constraint and maybe other-Role is of RingConstraint and Role is where FactType has Ordinal place played by Concept,
	RingConstraintOtherRoleOrdinal          int NULL,
	-- maybe RingConstraint is a subtype of Constraint and RingConstraint is of RingType,
	RingConstraintRingType                  varchar NULL,
	-- maybe RingConstraint is a subtype of Constraint and maybe Role is of RingConstraint and Role is where FactType has Ordinal place played by Concept and FactType has FactTypeId,
	RingConstraintRoleFactTypeId            int NULL,
	-- maybe RingConstraint is a subtype of Constraint and maybe Role is of RingConstraint and Role is where FactType has Ordinal place played by Concept,
	RingConstraintRoleOrdinal               int NULL,
	-- maybe SetConstraint is a subtype of Constraint and maybe SetComparisonConstraint is a subtype of SetConstraint and maybe SetExclusionConstraint is a subtype of SetComparisonConstraint and SetExclusionConstraint is mandatory,
	SetExclusionConstraintIsMandatory       bit NULL,
	-- maybe SetConstraint is a subtype of Constraint and maybe SubsetConstraint is a subtype of SetConstraint and SubsetConstraint covers subset-RoleSequence and RoleSequence has RoleSequenceId,
	SubsetConstraintSubsetRoleSequenceId    int NULL,
	-- maybe SetConstraint is a subtype of Constraint and maybe SubsetConstraint is a subtype of SetConstraint and SubsetConstraint covers superset-RoleSequence and RoleSequence has RoleSequenceId,
	SubsetConstraintSupersetRoleSequenceId  int NULL,
	-- maybe Vocabulary contains Constraint and Vocabulary is called Name,
	VocabularyName                          varchar(64) NULL,
	PRIMARY KEY(ConstraintId)
)
GO

CREATE VIEW dbo.SubsetConstraintInConstraint_SubsetRoleSequenceIdSupersetRoleSequenceId (SubsetConstraintSubsetRoleSequenceId, SubsetConstraintSupersetRoleSequenceId) WITH SCHEMABINDING AS
	SELECT SubsetConstraintSubsetRoleSequenceId, SubsetConstraintSupersetRoleSequenceId FROM dbo.[Constraint]
	WHERE	SubsetConstraintSubsetRoleSequenceId IS NOT NULL
	  AND	SubsetConstraintSupersetRoleSequenceId IS NOT NULL
GO

CREATE UNIQUE CLUSTERED INDEX IX_SubsetConstraintInConstraintBySubsetConstraintSubsetRoleSequenceIdSubsetConstraintSupersetRoleSequenceId ON dbo.SubsetConstraintInConstraint_SubsetRoleSequenceIdSupersetRoleSequenceId(SubsetConstraintSubsetRoleSequenceId, SubsetConstraintSupersetRoleSequenceId)
GO

CREATE VIEW dbo.Constraint_VocabularyNameName (VocabularyName, Name) WITH SCHEMABINDING AS
	SELECT VocabularyName, Name FROM dbo.[Constraint]
	WHERE	VocabularyName IS NOT NULL
	  AND	Name IS NOT NULL
GO

CREATE UNIQUE CLUSTERED INDEX IX_ConstraintByVocabularyNameName ON dbo.Constraint_VocabularyNameName(VocabularyName, Name)
GO

CREATE TABLE ContextNote (
	-- maybe Concept has ContextNote and Concept is called Name,
	ConceptName                             varchar(64) NULL,
	-- maybe Concept has ContextNote and Concept belongs to Vocabulary and Vocabulary is called Name,
	ConceptVocabularyName                   varchar(64) NULL,
	-- maybe Constraint has ContextNote and Constraint has ConstraintId,
	ConstraintId                            int NULL,
	-- ContextNote has ContextNoteId,
	ContextNoteId                           int IDENTITY NOT NULL,
	-- maybe FactType has ContextNote and FactType has FactTypeId,
	FactTypeId                              int NULL,
	PRIMARY KEY(ContextNoteId),
	FOREIGN KEY (ConceptName, ConceptVocabularyName) REFERENCES Concept (Name, VocabularyName),
	FOREIGN KEY (ConstraintId) REFERENCES [Constraint] (ConstraintId)
)
GO

CREATE TABLE Derivation (
	-- Derivation is where DerivedUnit is derived from BaseUnit and Unit has UnitId,
	BaseUnitId                              int NOT NULL,
	-- Derivation is where DerivedUnit is derived from BaseUnit and Unit has UnitId,
	DerivedUnitId                           int NOT NULL,
	-- maybe Derivation has Exponent,
	Exponent                                int NULL,
	PRIMARY KEY(DerivedUnitId, BaseUnitId)
)
GO

CREATE TABLE Fact (
	-- Fact has FactId,
	FactId                                  int IDENTITY NOT NULL,
	-- Fact is of FactType and FactType has FactTypeId,
	FactTypeId                              int NOT NULL,
	-- Population includes Fact and Population has Name,
	PopulationName                          varchar(64) NOT NULL,
	-- Population includes Fact and maybe Vocabulary includes Population and Vocabulary is called Name,
	PopulationVocabularyName                varchar(64) NULL,
	PRIMARY KEY(FactId)
)
GO

CREATE TABLE FactType (
	-- maybe EntityType nests FactType and Concept is called Name,
	EntityTypeName                          varchar(64) NULL,
	-- maybe EntityType nests FactType and Concept belongs to Vocabulary and Vocabulary is called Name,
	EntityTypeVocabularyName                varchar(64) NULL,
	-- FactType has FactTypeId,
	FactTypeId                              int IDENTITY NOT NULL,
	-- maybe TypeInheritance is a subtype of FactType and maybe Assimilation applies to TypeInheritance,
	TypeInheritanceAssimilation             varchar NULL CHECK(TypeInheritanceAssimilation = 'partitioned' OR TypeInheritanceAssimilation = 'separate'),
	-- maybe TypeInheritance is a subtype of FactType and TypeInheritance provides identification,
	TypeInheritanceProvidesIdentification   bit NULL,
	-- maybe TypeInheritance is a subtype of FactType and TypeInheritance is where Subtype is subtype of Supertype and Concept is called Name,
	TypeInheritanceSubtypeName              varchar(64) NULL,
	-- maybe TypeInheritance is a subtype of FactType and TypeInheritance is where Subtype is subtype of Supertype and Concept belongs to Vocabulary and Vocabulary is called Name,
	TypeInheritanceSubtypeVocabularyName    varchar(64) NULL,
	-- maybe TypeInheritance is a subtype of FactType and TypeInheritance is where Subtype is subtype of Supertype and Concept is called Name,
	TypeInheritanceSupertypeName            varchar(64) NULL,
	-- maybe TypeInheritance is a subtype of FactType and TypeInheritance is where Subtype is subtype of Supertype and Concept belongs to Vocabulary and Vocabulary is called Name,
	TypeInheritanceSupertypeVocabularyName  varchar(64) NULL,
	PRIMARY KEY(FactTypeId),
	FOREIGN KEY (EntityTypeName, EntityTypeVocabularyName) REFERENCES Concept (Name, VocabularyName),
	FOREIGN KEY (TypeInheritanceSubtypeName, TypeInheritanceSubtypeVocabularyName) REFERENCES Concept (Name, VocabularyName),
	FOREIGN KEY (TypeInheritanceSupertypeName, TypeInheritanceSupertypeVocabularyName) REFERENCES Concept (Name, VocabularyName)
)
GO

CREATE VIEW dbo.FactType_EntityTypeVocabularyNameEntityTypeName (EntityTypeVocabularyName, EntityTypeName) WITH SCHEMABINDING AS
	SELECT EntityTypeVocabularyName, EntityTypeName FROM dbo.FactType
	WHERE	EntityTypeVocabularyName IS NOT NULL
	  AND	EntityTypeName IS NOT NULL
GO

CREATE UNIQUE CLUSTERED INDEX EntityTypeNestsOneFactType ON dbo.FactType_EntityTypeVocabularyNameEntityTypeName(EntityTypeVocabularyName, EntityTypeName)
GO

CREATE VIEW dbo.TypeInheritanceInFactType_SubtypeVocabularyNameSubtypeNameProvidesIdentification (TypeInheritanceSubtypeVocabularyName, TypeInheritanceSubtypeName, TypeInheritanceProvidesIdentification) WITH SCHEMABINDING AS
	SELECT TypeInheritanceSubtypeVocabularyName, TypeInheritanceSubtypeName, TypeInheritanceProvidesIdentification FROM dbo.FactType
	WHERE	TypeInheritanceSubtypeVocabularyName IS NOT NULL
	  AND	TypeInheritanceSubtypeName IS NOT NULL
	  AND	TypeInheritanceProvidesIdentification IS NOT NULL
GO

CREATE UNIQUE CLUSTERED INDEX OnlyOneSupertypeMayBePrimary ON dbo.TypeInheritanceInFactType_SubtypeVocabularyNameSubtypeNameProvidesIdentification(TypeInheritanceSubtypeVocabularyName, TypeInheritanceSubtypeName, TypeInheritanceProvidesIdentification)
GO

CREATE VIEW dbo.TypeInheritanceInFactType_SubtypeVocabularyNameSubtypeNameSupertypeVocabularyNameSupertypeName (TypeInheritanceSubtypeVocabularyName, TypeInheritanceSubtypeName, TypeInheritanceSupertypeVocabularyName, TypeInheritanceSupertypeName) WITH SCHEMABINDING AS
	SELECT TypeInheritanceSubtypeVocabularyName, TypeInheritanceSubtypeName, TypeInheritanceSupertypeVocabularyName, TypeInheritanceSupertypeName FROM dbo.FactType
	WHERE	TypeInheritanceSubtypeVocabularyName IS NOT NULL
	  AND	TypeInheritanceSubtypeName IS NOT NULL
	  AND	TypeInheritanceSupertypeVocabularyName IS NOT NULL
	  AND	TypeInheritanceSupertypeName IS NOT NULL
GO

CREATE UNIQUE CLUSTERED INDEX PK_TypeInheritanceInFactType ON dbo.TypeInheritanceInFactType_SubtypeVocabularyNameSubtypeNameSupertypeVocabularyNameSupertypeName(TypeInheritanceSubtypeVocabularyName, TypeInheritanceSubtypeName, TypeInheritanceSupertypeVocabularyName, TypeInheritanceSupertypeName)
GO

CREATE TABLE Instance (
	-- Instance is of Concept and Concept is called Name,
	ConceptName                             varchar(64) NOT NULL,
	-- Instance is of Concept and Concept belongs to Vocabulary and Vocabulary is called Name,
	ConceptVocabularyName                   varchar(64) NOT NULL,
	-- Instance has InstanceId,
	InstanceId                              int IDENTITY NOT NULL,
	-- Population includes Instance and Population has Name,
	PopulationName                          varchar(64) NOT NULL,
	-- Population includes Instance and maybe Vocabulary includes Population and Vocabulary is called Name,
	PopulationVocabularyName                varchar(64) NULL,
	-- maybe Instance has Value,
	Value                                   varchar(256) NULL,
	PRIMARY KEY(InstanceId),
	FOREIGN KEY (ConceptName, ConceptVocabularyName) REFERENCES Concept (Name, VocabularyName)
)
GO

CREATE TABLE [Join] (
	-- maybe Join traverses Concept and Concept is called Name,
	ConceptName                             varchar(64) NULL,
	-- maybe Join traverses Concept and Concept belongs to Vocabulary and Vocabulary is called Name,
	ConceptVocabularyName                   varchar(64) NULL,
	-- maybe Join has input-Role and Role is where FactType has Ordinal place played by Concept and FactType has FactTypeId,
	InputRoleFactTypeId                     int NULL,
	-- maybe Join has input-Role and Role is where FactType has Ordinal place played by Concept,
	InputRoleOrdinal                        int NULL,
	-- Join is where RoleRef has JoinStep join,
	JoinStep                                int NOT NULL,
	-- maybe Join has output-Role and Role is where FactType has Ordinal place played by Concept and FactType has FactTypeId,
	OutputRoleFactTypeId                    int NULL,
	-- maybe Join has output-Role and Role is where FactType has Ordinal place played by Concept,
	OutputRoleOrdinal                       int NULL,
	-- Join is where RoleRef has JoinStep join and RoleRef is where RoleSequence in Ordinal position includes Role,
	RoleRefOrdinal                          int NOT NULL,
	-- Join is where RoleRef has JoinStep join and RoleRef is where RoleSequence in Ordinal position includes Role and RoleSequence has RoleSequenceId,
	RoleRefRoleSequenceId                   int NOT NULL,
	PRIMARY KEY(RoleRefRoleSequenceId, RoleRefOrdinal, JoinStep),
	FOREIGN KEY (ConceptName, ConceptVocabularyName) REFERENCES Concept (Name, VocabularyName)
)
GO

CREATE TABLE ParamValue (
	-- ParamValue is where Value for Parameter applies to ValueType and Parameter is where Name is a parameter of ValueType,
	ParameterName                           varchar(64) NOT NULL,
	-- ParamValue is where Value for Parameter applies to ValueType and Parameter is where Name is a parameter of ValueType and Concept is called Name,
	ParameterValueTypeName                  varchar(64) NOT NULL,
	-- ParamValue is where Value for Parameter applies to ValueType and Parameter is where Name is a parameter of ValueType and Concept belongs to Vocabulary and Vocabulary is called Name,
	ParameterValueTypeVocabularyName        varchar(64) NOT NULL,
	-- ParamValue is where Value for Parameter applies to ValueType,
	Value                                   varchar(256) NOT NULL,
	-- ParamValue is where Value for Parameter applies to ValueType and Concept is called Name,
	ValueTypeName                           varchar(64) NOT NULL,
	-- ParamValue is where Value for Parameter applies to ValueType and Concept belongs to Vocabulary and Vocabulary is called Name,
	ValueTypeVocabularyName                 varchar(64) NOT NULL,
	PRIMARY KEY(Value, ParameterName, ParameterValueTypeVocabularyName, ParameterValueTypeName),
	FOREIGN KEY (ValueTypeName, ValueTypeVocabularyName) REFERENCES Concept (Name, VocabularyName)
)
GO

CREATE TABLE Reading (
	-- FactType has Reading and FactType has FactTypeId,
	FactTypeId                              int NOT NULL,
	-- Reading is in Ordinal position,
	Ordinal                                 int NOT NULL,
	-- Reading is in RoleSequence and RoleSequence has RoleSequenceId,
	RoleSequenceId                          int NOT NULL,
	-- Reading has Text,
	Text                                    varchar(256) NOT NULL,
	PRIMARY KEY(FactTypeId, Ordinal),
	FOREIGN KEY (FactTypeId) REFERENCES FactType (FactTypeId)
)
GO

CREATE TABLE Role (
	-- Role is where FactType has Ordinal place played by Concept and Concept is called Name,
	ConceptName                             varchar(64) NOT NULL,
	-- Role is where FactType has Ordinal place played by Concept and Concept belongs to Vocabulary and Vocabulary is called Name,
	ConceptVocabularyName                   varchar(64) NOT NULL,
	-- Role is where FactType has Ordinal place played by Concept and FactType has FactTypeId,
	FactTypeId                              int NOT NULL,
	-- Role is where FactType has Ordinal place played by Concept,
	Ordinal                                 int NOT NULL,
	-- maybe Role has role-Name,
	RoleName                                varchar(64) NULL,
	-- maybe Role has role-ValueRestriction and ValueRestriction has ValueRestrictionId,
	RoleValueRestrictionId                  int NULL,
	PRIMARY KEY(FactTypeId, Ordinal),
	FOREIGN KEY (ConceptName, ConceptVocabularyName) REFERENCES Concept (Name, VocabularyName),
	FOREIGN KEY (FactTypeId) REFERENCES FactType (FactTypeId)
)
GO

CREATE TABLE RoleRef (
	-- maybe RoleRef has leading-Adjective,
	LeadingAdjective                        varchar(64) NULL,
	-- RoleRef is where RoleSequence in Ordinal position includes Role,
	Ordinal                                 int NOT NULL,
	-- RoleRef is where RoleSequence in Ordinal position includes Role and Role is where FactType has Ordinal place played by Concept and FactType has FactTypeId,
	RoleFactTypeId                          int NOT NULL,
	-- RoleRef is where RoleSequence in Ordinal position includes Role and Role is where FactType has Ordinal place played by Concept,
	RoleOrdinal                             int NOT NULL,
	-- RoleRef is where RoleSequence in Ordinal position includes Role and RoleSequence has RoleSequenceId,
	RoleSequenceId                          int NOT NULL,
	-- maybe RoleRef has trailing-Adjective,
	TrailingAdjective                       varchar(64) NULL,
	PRIMARY KEY(RoleSequenceId, Ordinal),
	UNIQUE(RoleFactTypeId, RoleOrdinal, RoleSequenceId),
	FOREIGN KEY (RoleFactTypeId, RoleOrdinal) REFERENCES Role (FactTypeId, Ordinal)
)
GO

CREATE TABLE RoleSequence (
	-- RoleSequence has RoleSequenceId,
	RoleSequenceId                          int IDENTITY NOT NULL,
	PRIMARY KEY(RoleSequenceId)
)
GO

CREATE TABLE RoleValue (
	-- RoleValue fulfils Fact and Fact has FactId,
	FactId                                  int NOT NULL,
	-- Instance plays RoleValue and Instance has InstanceId,
	InstanceId                              int NOT NULL,
	-- Population includes RoleValue and Population has Name,
	PopulationName                          varchar(64) NOT NULL,
	-- Population includes RoleValue and maybe Vocabulary includes Population and Vocabulary is called Name,
	PopulationVocabularyName                varchar(64) NULL,
	-- RoleValue is of Role and Role is where FactType has Ordinal place played by Concept and FactType has FactTypeId,
	RoleFactTypeId                          int NOT NULL,
	-- RoleValue is of Role and Role is where FactType has Ordinal place played by Concept,
	RoleOrdinal                             int NOT NULL,
	PRIMARY KEY(InstanceId, FactId),
	FOREIGN KEY (FactId) REFERENCES Fact (FactId),
	FOREIGN KEY (InstanceId) REFERENCES Instance (InstanceId),
	FOREIGN KEY (RoleFactTypeId, RoleOrdinal) REFERENCES Role (FactTypeId, Ordinal)
)
GO

CREATE TABLE SetComparisonRoles (
	-- SetComparisonRoles is where SetComparisonConstraint has in Ordinal position RoleSequence,
	Ordinal                                 int NOT NULL,
	-- SetComparisonRoles is where SetComparisonConstraint has in Ordinal position RoleSequence and RoleSequence has RoleSequenceId,
	RoleSequenceId                          int NOT NULL,
	-- SetComparisonRoles is where SetComparisonConstraint has in Ordinal position RoleSequence and Constraint has ConstraintId,
	SetComparisonConstraintId               int NOT NULL,
	PRIMARY KEY(SetComparisonConstraintId, Ordinal),
	UNIQUE(SetComparisonConstraintId, RoleSequenceId),
	FOREIGN KEY (SetComparisonConstraintId) REFERENCES [Constraint] (ConstraintId),
	FOREIGN KEY (RoleSequenceId) REFERENCES RoleSequence (RoleSequenceId)
)
GO

CREATE TABLE Unit (
	-- maybe Unit has Coefficient and Coefficient has Denominator,
	CoefficientDenominator                  int NULL,
	-- maybe Unit has Coefficient and Coefficient is precise,
	CoefficientIsPrecise                    bit NULL,
	-- maybe Unit has Coefficient and Coefficient has Numerator,
	CoefficientNumerator                    decimal NULL,
	-- Unit is fundamental,
	IsFundamental                           bit NOT NULL,
	-- Name is of Unit,
	Name                                    varchar(64) NOT NULL,
	-- maybe Unit has Offset,
	Offset                                  decimal NULL,
	-- Unit has UnitId,
	UnitId                                  int IDENTITY NOT NULL,
	-- Vocabulary includes Unit and Vocabulary is called Name,
	VocabularyName                          varchar(64) NOT NULL,
	PRIMARY KEY(UnitId),
	UNIQUE(VocabularyName, Name)
)
GO

CREATE TABLE ValueRestriction (
	-- ValueRestriction has ValueRestrictionId,
	ValueRestrictionId                      int IDENTITY NOT NULL,
	PRIMARY KEY(ValueRestrictionId)
)
GO

ALTER TABLE AllowedRange
	ADD FOREIGN KEY (ValueRestrictionId) REFERENCES ValueRestriction (ValueRestrictionId)
GO

ALTER TABLE Concept
	ADD FOREIGN KEY (ValueTypeUnitId) REFERENCES Unit (UnitId)
GO

ALTER TABLE Concept
	ADD FOREIGN KEY (ValueTypeValueRestrictionId) REFERENCES ValueRestriction (ValueRestrictionId)
GO

ALTER TABLE [Constraint]
	ADD FOREIGN KEY (RingConstraintOtherRoleFactTypeId, RingConstraintOtherRoleOrdinal) REFERENCES Role (FactTypeId, Ordinal)
GO

ALTER TABLE [Constraint]
	ADD FOREIGN KEY (RingConstraintRoleFactTypeId, RingConstraintRoleOrdinal) REFERENCES Role (FactTypeId, Ordinal)
GO

ALTER TABLE [Constraint]
	ADD FOREIGN KEY (PresenceConstraintRoleSequenceId) REFERENCES RoleSequence (RoleSequenceId)
GO

ALTER TABLE [Constraint]
	ADD FOREIGN KEY (SubsetConstraintSubsetRoleSequenceId) REFERENCES RoleSequence (RoleSequenceId)
GO

ALTER TABLE [Constraint]
	ADD FOREIGN KEY (SubsetConstraintSupersetRoleSequenceId) REFERENCES RoleSequence (RoleSequenceId)
GO

ALTER TABLE ContextNote
	ADD FOREIGN KEY (FactTypeId) REFERENCES FactType (FactTypeId)
GO

ALTER TABLE Derivation
	ADD FOREIGN KEY (BaseUnitId) REFERENCES Unit (UnitId)
GO

ALTER TABLE Derivation
	ADD FOREIGN KEY (DerivedUnitId) REFERENCES Unit (UnitId)
GO

ALTER TABLE Fact
	ADD FOREIGN KEY (FactTypeId) REFERENCES FactType (FactTypeId)
GO

ALTER TABLE [Join]
	ADD FOREIGN KEY (InputRoleFactTypeId, InputRoleOrdinal) REFERENCES Role (FactTypeId, Ordinal)
GO

ALTER TABLE [Join]
	ADD FOREIGN KEY (OutputRoleFactTypeId, OutputRoleOrdinal) REFERENCES Role (FactTypeId, Ordinal)
GO

ALTER TABLE [Join]
	ADD FOREIGN KEY (RoleRefOrdinal, RoleRefRoleSequenceId) REFERENCES RoleRef (Ordinal, RoleSequenceId)
GO

ALTER TABLE Reading
	ADD FOREIGN KEY (RoleSequenceId) REFERENCES RoleSequence (RoleSequenceId)
GO

ALTER TABLE Role
	ADD FOREIGN KEY (RoleValueRestrictionId) REFERENCES ValueRestriction (ValueRestrictionId)
GO

ALTER TABLE RoleRef
	ADD FOREIGN KEY (RoleSequenceId) REFERENCES RoleSequence (RoleSequenceId)
GO

