IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Rentals')
BEGIN
    EXEC('CREATE SCHEMA Rentals;');
END
GO

-- Lookup tables:
IF OBJECT_ID('Rentals.PropertyType', 'U') IS NOT NULL
    DROP TABLE Rentals.PropertyType;
CREATE TABLE Rentals.PropertyType (
    PropertyTypeId INT IDENTITY(1,1) PRIMARY KEY,
    PropertyTypeName VARCHAR(50) NOT NULL UNIQUE
);

IF OBJECT_ID('Rentals.RentalType', 'U') IS NOT NULL
    DROP TABLE Rentals.RentalType;
CREATE TABLE Rentals.RentalType (
    RentalTypeId INT IDENTITY(1,1) PRIMARY KEY,
    RentalTypeName VARCHAR(50) NOT NULL UNIQUE
);


IF OBJECT_ID('Rentals.VerificationStatus', 'U') IS NOT NULL
    DROP TABLE Rentals.VerificationStatus;
CREATE TABLE Rentals.VerificationStatus (
    VerificationStatusId INT IDENTITY(1,1) PRIMARY KEY,
    VerificationStatusName VARCHAR(20) NOT NULL UNIQUE
);

IF OBJECT_ID('Rentals.LayoutType', 'U') IS NOT NULL
    DROP TABLE Rentals.LayoutType;
CREATE TABLE Rentals.LayoutType (
    LayoutTypeId INT IDENTITY(1,1) PRIMARY KEY,
    LayoutTypeName VARCHAR(50) NOT NULL UNIQUE
);


IF OBJECT_ID('Rentals.AvailabilityStatus', 'U') IS NOT NULL
    DROP TABLE Rentals.AvailabilityStatus;
CREATE TABLE Rentals.AvailabilityStatus (
    AvailabilityStatusId INT IDENTITY(1,1) PRIMARY KEY,
    AvailabilityStatusName VARCHAR(50) NOT NULL UNIQUE
);


IF OBJECT_ID('Rentals.PreferredTenants', 'U') IS NOT NULL
    DROP TABLE Rentals.PreferredTenants;
CREATE TABLE Rentals.PreferredTenants (
    PreferredTenantId INT IDENTITY(1,1) PRIMARY KEY,
    PreferredTenantName VARCHAR(50) NOT NULL UNIQUE
);


IF OBJECT_ID('Rentals.AmenityCategory', 'U') IS NOT NULL
    DROP TABLE Rentals.AmenityCategory;
CREATE TABLE Rentals.AmenityCategory (
    AmenityCategoryId INT IDENTITY(1,1) PRIMARY KEY,
    AmenityCategoryName VARCHAR(50) NOT NULL UNIQUE
);


IF OBJECT_ID('Rentals.MessageStatus', 'U') IS NOT NULL
    DROP TABLE Rentals.MessageStatus;
CREATE TABLE Rentals.MessageStatus (
    MessageStatusId INT IDENTITY(1,1) PRIMARY KEY,
    MessageStatusName VARCHAR(20) NOT NULL UNIQUE
);


IF OBJECT_ID('Rentals.VisitRequestStatus', 'U') IS NOT NULL
    DROP TABLE Rentals.VisitRequestStatus;
CREATE TABLE Rentals.VisitRequestStatus (
    VisitRequestStatusId INT IDENTITY(1,1) PRIMARY KEY,
    VisitRequestStatusName VARCHAR(20) NOT NULL UNIQUE
);


IF OBJECT_ID('Rentals.BookingRequestStatus', 'U') IS NOT NULL
    DROP TABLE Rentals.BookingRequestStatus;
CREATE TABLE Rentals.BookingRequestStatus (
    BookingRequestStatusId INT IDENTITY(1,1) PRIMARY KEY,
    BookingRequestStatusName VARCHAR(20) NOT NULL UNIQUE
);


IF OBJECT_ID('Rentals.PaymentStatus', 'U') IS NOT NULL
    DROP TABLE Rentals.PaymentStatus;
CREATE TABLE Rentals.PaymentStatus (
    PaymentStatusId INT IDENTITY(1,1) PRIMARY KEY,
    PaymentStatusName VARCHAR(10) NOT NULL UNIQUE
);


IF OBJECT_ID('Rentals.ReportStatus', 'U') IS NOT NULL
    DROP TABLE Rentals.ReportStatus;
CREATE TABLE Rentals.ReportStatus (
    ReportStatusId INT IDENTITY(1,1) PRIMARY KEY,
    ReportStatusName VARCHAR(20) NOT NULL UNIQUE
);


IF OBJECT_ID('Rentals.RoleName', 'U') IS NOT NULL
    DROP TABLE Rentals.RoleName;
CREATE TABLE Rentals.RoleName (
    RoleNameId INT IDENTITY(1,1) PRIMARY KEY,
    RoleNameValue VARCHAR(45) NOT NULL UNIQUE
);


IF OBJECT_ID('Rentals.SubscriptionUserType', 'U') IS NOT NULL
    DROP TABLE Rentals.SubscriptionUserType;
CREATE TABLE Rentals.SubscriptionUserType (
    SubscriptionUserTypeId INT IDENTITY(1,1) PRIMARY KEY,
    UserTypeName VARCHAR(45) NOT NULL UNIQUE
);

-- Main tables

IF OBJECT_ID('Rentals.[User]', 'U') IS NOT NULL
    DROP TABLE Rentals.[User];
CREATE TABLE Rentals.[User] (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(35),
    WhatsAppNumber VARCHAR(35),
    IsEmailVerified BIT NOT NULL DEFAULT 0,
    IsMobileVerified BIT NOT NULL DEFAULT 0,
    IsWhatsAppVerified BIT NOT NULL DEFAULT 0,
    GoogleID VARCHAR(255),
    ProfileImageUrl VARCHAR(255),
    PasswordHash VARCHAR(255) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

IF OBJECT_ID('Rentals.Tenant', 'U') IS NOT NULL
    DROP TABLE Rentals.Tenant;
CREATE TABLE Rentals.Tenant (
    TenantId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CreatedAt DATETIME2 NULL,
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_Tenant_User FOREIGN KEY (UserId)
        REFERENCES Rentals.[User](UserId)
);

IF OBJECT_ID('Rentals.DocumentRegistration', 'U') IS NOT NULL
    DROP TABLE Rentals.DocumentRegistration;
CREATE TABLE Rentals.DocumentRegistration (
    DocumentId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    DocumentType VARCHAR(45) NOT NULL,
    DocumentNumber VARCHAR(45) NOT NULL,
    DocumentImageUrl VARCHAR(255) NOT NULL,
    IsVerified BIT NULL,
    VerifiedBy INT NOT NULL,
    VerificationStatusId INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_DocumentRegistration_User FOREIGN KEY (UserId)
        REFERENCES Rentals.[User](UserId),
    CONSTRAINT FK_DocumentRegistration_VerifiedBy FOREIGN KEY (VerifiedBy)
        REFERENCES Rentals.[User](UserId),
    CONSTRAINT FK_DocumentRegistration_VerificationStatus FOREIGN KEY (VerificationStatusId)
        REFERENCES Rentals.VerificationStatus(VerificationStatusId)
);

IF OBJECT_ID('Rentals.Landlord', 'U') IS NOT NULL
    DROP TABLE Rentals.Landlord;
CREATE TABLE Rentals.Landlord (
    LandlordId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    IdentificationDocumentId INT NULL,
    CreatedAt DATETIME2 NULL,
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_Landlord_User FOREIGN KEY (UserId)
        REFERENCES Rentals.[User](UserId),
    CONSTRAINT FK_Landlord_DocumentRegistration FOREIGN KEY (IdentificationDocumentId)
        REFERENCES Rentals.DocumentRegistration(DocumentId)
);


IF OBJECT_ID('Rentals.Listing', 'U') IS NOT NULL
    DROP TABLE Rentals.Listing;
CREATE TABLE Rentals.Listing (
    ListingId INT IDENTITY(1,1) PRIMARY KEY,
    LandlordId INT NOT NULL,
    Title VARCHAR(255) NOT NULL,
    Description VARCHAR(MAX),
    PropertyTypeId INT NOT NULL,
    RentalTypeId INT NOT NULL,
    LayoutTypeId INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Area DECIMAL(10, 2) NOT NULL,
    LocationText VARCHAR(100) NOT NULL,
    LocationLatitude DECIMAL(11, 8) NOT NULL,
    LocationLongitude DECIMAL(11, 8) NOT NULL,
    AvailabilityStatusId INT,
    PreferredTenantId INT,
    IsVerified BIT NOT NULL,
    FloorNumber INT NOT NULL,
    BuildingAge INT NOT NULL,
    PropertyFacing VARCHAR(50) NOT NULL,
    IsPetsAllowed BIT NOT NULL,
    IsSmokingAllowed BIT NOT NULL,
    IsActive BIT,
    CONSTRAINT FK_Listing_Landlord FOREIGN KEY (LandlordId)
        REFERENCES Rentals.Landlord(LandlordId),
    CONSTRAINT FK_Listing_PropertyType FOREIGN KEY (PropertyTypeId)
        REFERENCES Rentals.PropertyType(PropertyTypeId),
    CONSTRAINT FK_Listing_RentalType FOREIGN KEY (RentalTypeId)
        REFERENCES Rentals.RentalType(RentalTypeId),
    CONSTRAINT FK_Listing_LayoutType FOREIGN KEY (LayoutTypeId)
        REFERENCES Rentals.LayoutType(LayoutTypeId),
    CONSTRAINT FK_Listing_AvailabilityStatus FOREIGN KEY (AvailabilityStatusId)
        REFERENCES Rentals.AvailabilityStatus(AvailabilityStatusId),
    CONSTRAINT FK_Listing_PreferredTenant FOREIGN KEY (PreferredTenantId)
        REFERENCES Rentals.PreferredTenants(PreferredTenantId)
);

IF OBJECT_ID('Rentals.Amenity', 'U') IS NOT NULL
    DROP TABLE Rentals.Amenity;
CREATE TABLE Rentals.Amenity (
    AmenityId INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    CategoryId INT NOT NULL,
    Description VARCHAR(MAX),
    CONSTRAINT FK_Amenity_Category FOREIGN KEY (CategoryId)
        REFERENCES Rentals.AmenityCategory(AmenityCategoryId)
);


IF OBJECT_ID('Rentals.ListingAmenity', 'U') IS NOT NULL
    DROP TABLE Rentals.ListingAmenity;
CREATE TABLE Rentals.ListingAmenity (
    ListingId INT NOT NULL,
    AmenityId INT NOT NULL,
    PRIMARY KEY (ListingId, AmenityId),
    CONSTRAINT FK_ListingAmenity_Listing FOREIGN KEY (ListingId)
        REFERENCES Rentals.Listing(ListingId),
    CONSTRAINT FK_ListingAmenity_Amenity FOREIGN KEY (AmenityId)
        REFERENCES Rentals.Amenity(AmenityId)
);


IF OBJECT_ID('Rentals.Conversation', 'U') IS NOT NULL
    DROP TABLE Rentals.Conversation;
CREATE TABLE Rentals.Conversation (
    ConversationId INT IDENTITY(1,1) PRIMARY KEY,
    TenantId INT NOT NULL,
    LandlordId INT NOT NULL,
    ListingId INT NOT NULL,
    IsActive BIT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Conversation_Tenant FOREIGN KEY (TenantId)
        REFERENCES Rentals.Tenant(TenantId),
    CONSTRAINT FK_Conversation_Landlord FOREIGN KEY (LandlordId)
        REFERENCES Rentals.Landlord(LandlordId),
    CONSTRAINT FK_Conversation_Listing FOREIGN KEY (ListingId)
        REFERENCES Rentals.Listing(ListingId)
);


IF OBJECT_ID('Rentals.Message', 'U') IS NOT NULL
    DROP TABLE Rentals.Message;
CREATE TABLE Rentals.Message (
    MessageId INT IDENTITY(1,1) PRIMARY KEY,
    ConversationId INT NOT NULL,
    SenderId INT NOT NULL,
    ReceiverId INT NOT NULL,
    Content VARCHAR(255) NOT NULL,
    SentAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    MessageStatusId INT NOT NULL,
    CONSTRAINT FK_Message_Conversation FOREIGN KEY (ConversationId)
        REFERENCES Rentals.Conversation(ConversationId),
    CONSTRAINT FK_Message_Sender FOREIGN KEY (SenderId)
        REFERENCES Rentals.[User](UserId),
    CONSTRAINT FK_Message_Receiver FOREIGN KEY (ReceiverId)
        REFERENCES Rentals.[User](UserId),
    CONSTRAINT FK_Message_MessageStatus FOREIGN KEY (MessageStatusId)
        REFERENCES Rentals.MessageStatus(MessageStatusId)
);


IF OBJECT_ID('Rentals.VisitRequest', 'U') IS NOT NULL
    DROP TABLE Rentals.VisitRequest;
CREATE TABLE Rentals.VisitRequest (
    VisitRequestId INT IDENTITY(1,1) PRIMARY KEY,
    TenantId INT NOT NULL,
    ListingId INT NOT NULL,
    PreferredVisitDateTime DATETIME2 NOT NULL,
    TenantRequestMessage VARCHAR(255) NULL,
    StatusId INT NOT NULL,
    LandlordResponseMessage VARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_VisitRequest_Tenant FOREIGN KEY (TenantId)
        REFERENCES Rentals.Tenant(TenantId),
    CONSTRAINT FK_VisitRequest_Listing FOREIGN KEY (ListingId)
        REFERENCES Rentals.Listing(ListingId),
    CONSTRAINT FK_VisitRequest_Status FOREIGN KEY (StatusId)
        REFERENCES Rentals.VisitRequestStatus(VisitRequestStatusId)
);


IF OBJECT_ID('Rentals.BookingRequest', 'U') IS NOT NULL
    DROP TABLE Rentals.BookingRequest;
CREATE TABLE Rentals.BookingRequest (
    BookingRequestId INT IDENTITY(1,1) PRIMARY KEY,
    TenantId INT NOT NULL,
    ListingId INT NOT NULL,
    RequestedRent DECIMAL(10,2) NULL,
    RequestedDuration INT NULL,
    BookingRequestStatusId INT NULL,
    TenantBookingRequestMessage VARCHAR(255) NULL,
    LandlordResponseMessage VARCHAR(255) NULL,
    CreatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_BookingRequest_Tenant FOREIGN KEY (TenantId)
        REFERENCES Rentals.Tenant(TenantId),
    CONSTRAINT FK_BookingRequest_Listing FOREIGN KEY (ListingId)
        REFERENCES Rentals.Listing(ListingId),
    CONSTRAINT FK_BookingRequest_Status FOREIGN KEY (BookingRequestStatusId)
        REFERENCES Rentals.BookingRequestStatus(BookingRequestStatusId)
);


IF OBJECT_ID('Rentals.LeaseAgreement', 'U') IS NOT NULL
    DROP TABLE Rentals.LeaseAgreement;
CREATE TABLE Rentals.LeaseAgreement (
    LeaseAgreementId INT IDENTITY(1,1) PRIMARY KEY,
    TenantId INT NOT NULL,
    LandlordId INT NOT NULL,
    ListingId INT NOT NULL,
    BookingRequestId INT NOT NULL,
    StartDate DATE NULL,
    EndDate DATE NULL,
    MonthlyRent DECIMAL(10,2) NULL,
    AgreementFileUrl VARCHAR(255) NULL,
    IsActive BIT NULL,
    CreatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_LeaseAgreement_Tenant FOREIGN KEY (TenantId)
        REFERENCES Rentals.Tenant(TenantId),
    CONSTRAINT FK_LeaseAgreement_Landlord FOREIGN KEY (LandlordId)
        REFERENCES Rentals.Landlord(LandlordId),
    CONSTRAINT FK_LeaseAgreement_Listing FOREIGN KEY (ListingId)
        REFERENCES Rentals.Listing(ListingId),
    CONSTRAINT FK_LeaseAgreement_BookingRequest FOREIGN KEY (BookingRequestId)
        REFERENCES Rentals.BookingRequest(BookingRequestId)
);


IF OBJECT_ID('Rentals.BookingPayment', 'U') IS NOT NULL
    DROP TABLE Rentals.BookingPayment;
CREATE TABLE Rentals.BookingPayment (
    BookingPaymentId INT IDENTITY(1,1) PRIMARY KEY,
    BookingRequestId INT NOT NULL,
    TenantId INT NOT NULL,
    Amount DECIMAL(10,2) NULL,
    PaymentStatusId INT NULL,
    PaidAt DATETIME2 NULL,
    PaymentReference VARCHAR(45) NULL,
    CreatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_BookingPayment_BookingRequest FOREIGN KEY (BookingRequestId)
        REFERENCES Rentals.BookingRequest(BookingRequestId),
    CONSTRAINT FK_BookingPayment_Tenant FOREIGN KEY (TenantId)
        REFERENCES Rentals.Tenant(TenantId),
    CONSTRAINT FK_BookingPayment_PaymentStatus FOREIGN KEY (PaymentStatusId)
        REFERENCES Rentals.PaymentStatus(PaymentStatusId)
);


IF OBJECT_ID('Rentals.RentPayment', 'U') IS NOT NULL
    DROP TABLE Rentals.RentPayment;
CREATE TABLE Rentals.RentPayment (
    RentPaymentId INT IDENTITY(1,1) PRIMARY KEY,
    LeaseAgreementId INT NOT NULL,
    TenantId INT NOT NULL,
    Amount DECIMAL(10,2) NULL,
    TransactionRef VARCHAR(255) NULL,
    ForMonth DATE NULL,
    Notes VARCHAR(255) NULL,
    PaymentStatusId INT NOT NULL,
    PaidAt DATETIME2 NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_RentPayment_LeaseAgreement FOREIGN KEY (LeaseAgreementId)
        REFERENCES Rentals.LeaseAgreement(LeaseAgreementId),
    CONSTRAINT FK_RentPayment_Tenant FOREIGN KEY (TenantId)
        REFERENCES Rentals.Tenant(TenantId),
    CONSTRAINT FK_RentPayment_PaymentStatus FOREIGN KEY (PaymentStatusId)
        REFERENCES Rentals.PaymentStatus(PaymentStatusId)
);


IF OBJECT_ID('Rentals.Subscription', 'U') IS NOT NULL
    DROP TABLE Rentals.Subscription;
CREATE TABLE Rentals.Subscription (
    SubscriptionId INT IDENTITY(1,1) PRIMARY KEY,
    ForUserTypeId INT NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Description VARCHAR(MAX) NULL,
    Price DECIMAL(10,2) NULL,
    DurationDays INT NULL, 
    IsActive BIT NULL,
    CreatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Subscription_UserType FOREIGN KEY (ForUserTypeId)
        REFERENCES Rentals.SubscriptionUserType(SubscriptionUserTypeId)
);


IF OBJECT_ID('Rentals.TenantSubscription', 'U') IS NOT NULL
    DROP TABLE Rentals.TenantSubscription;
CREATE TABLE Rentals.TenantSubscription (
    TenantSubscriptionId INT IDENTITY(1,1) PRIMARY KEY,
    TenantId INT NOT NULL,
    SubscriptionId INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    TransactionRef VARCHAR(45) NULL,
    Amount DECIMAL(10,2) NULL,
    PaymentStatusId INT NULL,
    PaidAt DATETIME2 NULL,
    CreatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    IsActive BIT NULL,
    CONSTRAINT FK_TenantSubscription_Tenant FOREIGN KEY (TenantId)
        REFERENCES Rentals.Tenant(TenantId),
    CONSTRAINT FK_TenantSubscription_Subscription FOREIGN KEY (SubscriptionId)
        REFERENCES Rentals.Subscription(SubscriptionId),
    CONSTRAINT FK_TenantSubscription_PaymentStatus FOREIGN KEY (PaymentStatusId)
        REFERENCES Rentals.PaymentStatus(PaymentStatusId)
);


IF OBJECT_ID('Rentals.ReportListing', 'U') IS NOT NULL
    DROP TABLE Rentals.ReportListing;
CREATE TABLE Rentals.ReportListing (
    ReportListingID INT IDENTITY(1,1) PRIMARY KEY,
    ListingId INT NOT NULL,
    Reason VARCHAR(MAX) NULL,
    StatusId INT NOT NULL,
    ReviewedBy INT NULL,
    ReportedBy INT NOT NULL,
    CreatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_ReportListing_Listing FOREIGN KEY (ListingId)
        REFERENCES Rentals.Listing(ListingId),
    CONSTRAINT FK_ReportListing_ReportedBy FOREIGN KEY (ReportedBy)
        REFERENCES Rentals.[User](UserId),
    CONSTRAINT FK_ReportListing_ReviewedBy FOREIGN KEY (ReviewedBy)
        REFERENCES Rentals.[User](UserId),
    CONSTRAINT FK_ReportListing_Status FOREIGN KEY (StatusId)
        REFERENCES Rentals.ReportStatus(ReportStatusId)
);


IF OBJECT_ID('Rentals.ReportUser', 'U') IS NOT NULL
    DROP TABLE Rentals.ReportUser;
CREATE TABLE Rentals.ReportUser (
    ReportUserId INT IDENTITY(1,1) PRIMARY KEY,
    ReportedUserId INT NOT NULL,
    ReportedByUserId INT NOT NULL,
    Reason VARCHAR(MAX) NULL,
    StatusId INT NOT NULL,
    AdminNotes VARCHAR(MAX) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_ReportUser_ReportedUser FOREIGN KEY (ReportedUserId)
        REFERENCES Rentals.[User](UserId),
    CONSTRAINT FK_ReportUser_ReportedBy FOREIGN KEY (ReportedByUserId)
        REFERENCES Rentals.[User](UserId),
    CONSTRAINT FK_ReportUser_Status FOREIGN KEY (StatusId)
        REFERENCES Rentals.ReportStatus(ReportStatusId)
);


IF OBJECT_ID('Rentals.Role', 'U') IS NOT NULL
    DROP TABLE Rentals.Role;
CREATE TABLE Rentals.Role (
    RoleId INT IDENTITY(1,1) PRIMARY KEY,
    RoleNameId INT NOT NULL UNIQUE,
    Description VARCHAR(MAX) NULL,
    CONSTRAINT FK_Role_RoleName FOREIGN KEY (RoleNameId)
        REFERENCES Rentals.RoleName(RoleNameId)
);


IF OBJECT_ID('Rentals.UserRole', 'U') IS NOT NULL
    DROP TABLE Rentals.UserRole;
CREATE TABLE Rentals.UserRole (
    UserId INT NOT NULL,
    RoleId INT NOT NULL,
    AssignedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_UserRole PRIMARY KEY (UserId, RoleId),
    CONSTRAINT FK_UserRole_User FOREIGN KEY (UserId)
        REFERENCES Rentals.[User](UserId),
    CONSTRAINT FK_UserRole_Role FOREIGN KEY (RoleId)
        REFERENCES Rentals.Role(RoleId)
);


IF OBJECT_ID('Rentals.ListingMedia', 'U') IS NOT NULL
    DROP TABLE Rentals.ListingMedia;
CREATE TABLE Rentals.ListingMedia (
    ListingMediaId INT IDENTITY(1,1) PRIMARY KEY,
    ListingId INT NOT NULL,
    MediaType VARCHAR(10) NOT NULL CHECK (MediaType IN ('Image', 'Video')),
    MediaUrl VARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_ListingMedia_Listing FOREIGN KEY (ListingId)
        REFERENCES Rentals.Listing(ListingId)
);


IF OBJECT_ID('Rentals.SavedListing', 'U') IS NOT NULL
    DROP TABLE Rentals.SavedListing;
CREATE TABLE Rentals.SavedListing (
    ListingId INT NOT NULL,
    TenantId INT NOT NULL,
    SavedAt DATETIME2 NULL,
    CONSTRAINT PK_SavedListing PRIMARY KEY (ListingId, TenantId),
    CONSTRAINT FK_SavedListing_Listing FOREIGN KEY (ListingId)
        REFERENCES Rentals.Listing(ListingId),
    CONSTRAINT FK_SavedListing_Tenant FOREIGN KEY (TenantId)
        REFERENCES Rentals.Tenant(TenantId)
);


IF OBJECT_ID('Rentals.LandlordSubscription', 'U') IS NOT NULL
    DROP TABLE Rentals.LandlordSubscription;
CREATE TABLE Rentals.LandlordSubscription (
    LandlordSubscriptionId INT IDENTITY(1,1) PRIMARY KEY,
    LandlordId INT NOT NULL,
    SubscriptionId INT NOT NULL,
    StartDate DATE NULL,
    EndDate DATE NULL,
    TransactionRef VARCHAR(45) NULL,
    Amount DECIMAL(10,2) NULL,
    IsActive BIT NULL,
    CreatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NULL DEFAULT SYSUTCDATETIME(),
    PaidAt DATETIME2 NULL,
    PaymentStatusId INT NULL,
    CONSTRAINT FK_LandlordSubscription_Landlord FOREIGN KEY (LandlordId)
        REFERENCES Rentals.Landlord(LandlordId),
    CONSTRAINT FK_LandlordSubscription_Subscription FOREIGN KEY (SubscriptionId)
        REFERENCES Rentals.Subscription(SubscriptionId),
    CONSTRAINT FK_LandlordSubscription_PaymentStatus FOREIGN KEY (PaymentStatusId)
        REFERENCES Rentals.PaymentStatus(PaymentStatusId)
);

-- Add Movers Requirement to the database

IF OBJECT_ID('Rentals.Mover', 'U') IS NOT NULL
    DROP TABLE Rentals.Mover;
CREATE TABLE Rentals.Mover (
    MoverId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    CompanyName VARCHAR(255) NOT NULL UNIQUE,          
    ContactPerson VARCHAR(255) NULL,                   
    ContactEmail VARCHAR(255) NULL UNIQUE,             
    ContactPhone VARCHAR(35) NULL UNIQUE,              
    AddressText VARCHAR(100) NOT NULL,
    AddressLatitude DECIMAL(11, 8) NOT NULL,
    AddressLongitude DECIMAL(11, 8) NOT NULL,
    Description VARCHAR(MAX) NULL,                                               
    IsVerified BIT NOT NULL DEFAULT 0,                 
    IsActive BIT NOT NULL DEFAULT 1,                   
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

-- Lookup Table for MovingRequest Table

IF OBJECT_ID('Rentals.MovingRequestStatus', 'U') IS NOT NULL
    DROP TABLE Rentals.MovingRequestStatus;
CREATE TABLE Rentals.MovingRequestStatus (
    MovingRequestStatusId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    StatusName VARCHAR(50) NOT NULL UNIQUE -- e.g., 'Pending', 'Accepted', 'Scheduled', 'Completed', 'Cancelled'
);

IF OBJECT_ID('Rentals.MovingRequest', 'U') IS NOT NULL
    DROP TABLE Rentals.MovingRequest;
CREATE TABLE Rentals.MovingRequest (
    MovingRequestId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    LeaseAgreementId INT NOT NULL, -- LeaseAgreement confirms the booking                  
    MoverId INT NOT NULL,                           
    PickupAddress VARCHAR(255) NOT NULL,            
    DestinationAddress VARCHAR(255) NOT NULL,       
    RequestedDateTime DATETIME2 NOT NULL,           
    Cost DECIMAL(10,2) NULL,                                 
    RequestDetails VARCHAR(MAX) NULL,               
    MovingRequestStatusId INT NOT NULL,             
    Notes VARCHAR(MAX) NULL,                        
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),

    CONSTRAINT FK_MovingRequest_LeaseAgreement FOREIGN KEY (LeaseAgreementId)
        REFERENCES Rentals.LeaseAgreement(LeaseAgreementId),
    CONSTRAINT FK_MovingRequest_Mover FOREIGN KEY (MoverId)
        REFERENCES Rentals.Mover(MoverId),
    CONSTRAINT FK_MovingRequest_Status FOREIGN KEY (MovingRequestStatusId)
        REFERENCES Rentals.MovingRequestStatus(MovingRequestStatusId)
);

-- Adding Non-Clusterd Indexes to Foreign Keys 
-- Create non-clustered indexes for Foreign Keys

-- Rentals.Tenant
CREATE NONCLUSTERED INDEX IX_Tenant_UserId
ON Rentals.Tenant (UserId);

-- Rentals.DocumentRegistration
CREATE NONCLUSTERED INDEX IX_DocumentRegistration_UserId
ON Rentals.DocumentRegistration (UserId);
CREATE NONCLUSTERED INDEX IX_DocumentRegistration_VerifiedBy
ON Rentals.DocumentRegistration (VerifiedBy);
CREATE NONCLUSTERED INDEX IX_DocumentRegistration_VerificationStatusId
ON Rentals.DocumentRegistration (VerificationStatusId);

-- Rentals.Landlord
CREATE NONCLUSTERED INDEX IX_Landlord_UserId
ON Rentals.Landlord (UserId);
CREATE NONCLUSTERED INDEX IX_Landlord_IdentificationDocumentId
ON Rentals.Landlord (IdentificationDocumentId);

-- Rentals.Listing
CREATE NONCLUSTERED INDEX IX_Listing_LandlordId
ON Rentals.Listing (LandlordId);
CREATE NONCLUSTERED INDEX IX_Listing_PropertyTypeId
ON Rentals.Listing (PropertyTypeId);
CREATE NONCLUSTERED INDEX IX_Listing_RentalTypeId
ON Rentals.Listing (RentalTypeId);
CREATE NONCLUSTERED INDEX IX_Listing_LayoutTypeId
ON Rentals.Listing (LayoutTypeId);
CREATE NONCLUSTERED INDEX IX_Listing_AvailabilityStatusId
ON Rentals.Listing (AvailabilityStatusId);
CREATE NONCLUSTERED INDEX IX_Listing_PreferredTenantId
ON Rentals.Listing (PreferredTenantId);

-- Rentals.Amenity
CREATE NONCLUSTERED INDEX IX_Amenity_CategoryId
ON Rentals.Amenity (CategoryId);

-- Rentals.ListingAmenity (Composite PK on (ListingId, AmenityId), so ListingId is covered. Index AmenityId for lookups by amenity alone)
CREATE NONCLUSTERED INDEX IX_ListingAmenity_AmenityId
ON Rentals.ListingAmenity (AmenityId);

-- Rentals.Conversation
CREATE NONCLUSTERED INDEX IX_Conversation_TenantId
ON Rentals.Conversation (TenantId);
CREATE NONCLUSTERED INDEX IX_Conversation_LandlordId
ON Rentals.Conversation (LandlordId);
CREATE NONCLUSTERED INDEX IX_Conversation_ListingId
ON Rentals.Conversation (ListingId);

-- Rentals.Message
CREATE NONCLUSTERED INDEX IX_Message_ConversationId
ON Rentals.Message (ConversationId);
CREATE NONCLUSTERED INDEX IX_Message_SenderId
ON Rentals.Message (SenderId);
CREATE NONCLUSTERED INDEX IX_Message_ReceiverId
ON Rentals.Message (ReceiverId);
CREATE NONCLUSTERED INDEX IX_Message_MessageStatusId
ON Rentals.Message (MessageStatusId);

-- Rentals.VisitRequest
CREATE NONCLUSTERED INDEX IX_VisitRequest_TenantId
ON Rentals.VisitRequest (TenantId);
CREATE NONCLUSTERED INDEX IX_VisitRequest_ListingId
ON Rentals.VisitRequest (ListingId);
CREATE NONCLUSTERED INDEX IX_VisitRequest_StatusId
ON Rentals.VisitRequest (StatusId);

-- Rentals.BookingRequest
CREATE NONCLUSTERED INDEX IX_BookingRequest_TenantId
ON Rentals.BookingRequest (TenantId);
CREATE NONCLUSTERED INDEX IX_BookingRequest_ListingId
ON Rentals.BookingRequest (ListingId);
CREATE NONCLUSTERED INDEX IX_BookingRequest_BookingRequestStatusId
ON Rentals.BookingRequest (BookingRequestStatusId);

-- Rentals.LeaseAgreement
CREATE NONCLUSTERED INDEX IX_LeaseAgreement_TenantId
ON Rentals.LeaseAgreement (TenantId);
CREATE NONCLUSTERED INDEX IX_LeaseAgreement_LandlordId
ON Rentals.LeaseAgreement (LandlordId);
CREATE NONCLUSTERED INDEX IX_LeaseAgreement_ListingId
ON Rentals.LeaseAgreement (ListingId);
CREATE NONCLUSTERED INDEX IX_LeaseAgreement_BookingRequestId
ON Rentals.LeaseAgreement (BookingRequestId);

-- Rentals.BookingPayment
CREATE NONCLUSTERED INDEX IX_BookingPayment_BookingRequestId
ON Rentals.BookingPayment (BookingRequestId);
CREATE NONCLUSTERED INDEX IX_BookingPayment_TenantId
ON Rentals.BookingPayment (TenantId);
CREATE NONCLUSTERED INDEX IX_BookingPayment_PaymentStatusId
ON Rentals.BookingPayment (PaymentStatusId);

-- Rentals.RentPayment
CREATE NONCLUSTERED INDEX IX_RentPayment_LeaseAgreementId
ON Rentals.RentPayment (LeaseAgreementId);
CREATE NONCLUSTERED INDEX IX_RentPayment_TenantId
ON Rentals.RentPayment (TenantId);
CREATE NONCLUSTERED INDEX IX_RentPayment_PaymentStatusId
ON Rentals.RentPayment (PaymentStatusId);

-- Rentals.Subscription
CREATE NONCLUSTERED INDEX IX_Subscription_ForUserTypeId
ON Rentals.Subscription (ForUserTypeId);

-- Rentals.TenantSubscription
CREATE NONCLUSTERED INDEX IX_TenantSubscription_TenantId
ON Rentals.TenantSubscription (TenantId);
CREATE NONCLUSTERED INDEX IX_TenantSubscription_SubscriptionId
ON Rentals.TenantSubscription (SubscriptionId);
CREATE NONCLUSTERED INDEX IX_TenantSubscription_PaymentStatusId
ON Rentals.TenantSubscription (PaymentStatusId);

-- Rentals.ReportListing
CREATE NONCLUSTERED INDEX IX_ReportListing_ListingId
ON Rentals.ReportListing (ListingId);
CREATE NONCLUSTERED INDEX IX_ReportListing_StatusId
ON Rentals.ReportListing (StatusId);
CREATE NONCLUSTERED INDEX IX_ReportListing_ReviewedBy
ON Rentals.ReportListing (ReviewedBy);
CREATE NONCLUSTERED INDEX IX_ReportListing_ReportedBy
ON Rentals.ReportListing (ReportedBy);

-- Rentals.ReportUser
CREATE NONCLUSTERED INDEX IX_ReportUser_ReportedUserId
ON Rentals.ReportUser (ReportedUserId);
CREATE NONCLUSTERED INDEX IX_ReportUser_ReportedByUserId
ON Rentals.ReportUser (ReportedByUserId);
CREATE NONCLUSTERED INDEX IX_ReportUser_StatusId
ON Rentals.ReportUser (StatusId);

-- Rentals.Role
CREATE NONCLUSTERED INDEX IX_Role_RoleNameId
ON Rentals.Role (RoleNameId);

-- Rentals.UserRole (Composite PK on (UserId, RoleId). Index RoleId for lookups by role alone)
CREATE NONCLUSTERED INDEX IX_UserRole_RoleId
ON Rentals.UserRole (RoleId);

-- Rentals.ListingMedia
CREATE NONCLUSTERED INDEX IX_ListingMedia_ListingId
ON Rentals.ListingMedia (ListingId);

-- Rentals.SavedListing (Composite PK on (ListingId, TenantId). Index TenantId for lookups by tenant alone)
CREATE NONCLUSTERED INDEX IX_SavedListing_TenantId
ON Rentals.SavedListing (TenantId);

-- Rentals.LandlordSubscription
CREATE NONCLUSTERED INDEX IX_LandlordSubscription_LandlordId
ON Rentals.LandlordSubscription (LandlordId);
CREATE NONCLUSTERED INDEX IX_LandlordSubscription_SubscriptionId
ON Rentals.LandlordSubscription (SubscriptionId);
CREATE NONCLUSTERED INDEX IX_LandlordSubscription_PaymentStatusId
ON Rentals.LandlordSubscription (PaymentStatusId);

-- Rentals.MovingRequest
CREATE NONCLUSTERED INDEX IX_MovingRequest_LeaseAgreementId
ON Rentals.MovingRequest (LeaseAgreementId);
CREATE NONCLUSTERED INDEX IX_MovingRequest_MoverId
ON Rentals.MovingRequest (MoverId);
CREATE NONCLUSTERED INDEX IX_MovingRequest_MovingRequestStatusId
ON Rentals.MovingRequest (MovingRequestStatusId);
