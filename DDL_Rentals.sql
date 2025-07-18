CREATE SCHEMA Rentals;
GO

-- Lookup tables:

CREATE TABLE Rentals.PropertyType (
    PropertyTypeId INT IDENTITY(1,1) PRIMARY KEY,
    PropertyTypeName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Rentals.RentalType (
    RentalTypeId INT IDENTITY(1,1) PRIMARY KEY,
    RentalTypeName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Rentals.VerificationStatus (
    VerificationStatusId INT IDENTITY(1,1) PRIMARY KEY,
    VerificationStatusName VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Rentals.LayoutType (
    LayoutTypeId INT IDENTITY(1,1) PRIMARY KEY,
    LayoutTypeName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Rentals.AvailabilityStatus (
    AvailabilityStatusId INT IDENTITY(1,1) PRIMARY KEY,
    AvailabilityStatusName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Rentals.PreferredTenants (
    PreferredTenantId INT IDENTITY(1,1) PRIMARY KEY,
    PreferredTenantName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Rentals.AmenityCategory (
    AmenityCategoryId INT IDENTITY(1,1) PRIMARY KEY,
    AmenityCategoryName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Rentals.MessageStatus (
    MessageStatusId INT IDENTITY(1,1) PRIMARY KEY,
    MessageStatusName VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Rentals.VisitRequestStatus (
    VisitRequestStatusId INT IDENTITY(1,1) PRIMARY KEY,
    VisitRequestStatusName VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Rentals.BookingRequestStatus (
    BookingRequestStatusId INT IDENTITY(1,1) PRIMARY KEY,
    BookingRequestStatusName VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Rentals.PaymentStatus (
    PaymentStatusId INT IDENTITY(1,1) PRIMARY KEY,
    PaymentStatusName VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE Rentals.ReportStatus (
    ReportStatusId INT IDENTITY(1,1) PRIMARY KEY,
    ReportStatusName VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Rentals.RoleName (
    RoleNameId INT IDENTITY(1,1) PRIMARY KEY,
    RoleNameValue VARCHAR(45) NOT NULL UNIQUE
);

CREATE TABLE Rentals.SubscriptionUserType (
    SubscriptionUserTypeId INT IDENTITY(1,1) PRIMARY KEY,
    UserTypeName VARCHAR(45) NOT NULL UNIQUE
);

-- Main tables

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

CREATE TABLE Rentals.Tenant (
    TenantId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CreatedAt DATETIME2 NULL,
    UpdatedAt DATETIME2 NULL,
    CONSTRAINT FK_Tenant_User FOREIGN KEY (UserId)
        REFERENCES Rentals.[User](UserId)
);

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

CREATE TABLE Rentals.Amenity (
    AmenityId INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    CategoryId INT NOT NULL,
    Description VARCHAR(MAX),
    CONSTRAINT FK_Amenity_Category FOREIGN KEY (CategoryId)
        REFERENCES Rentals.AmenityCategory(AmenityCategoryId)
);

CREATE TABLE Rentals.ListingAmenity (
    ListingId INT NOT NULL,
    AmenityId INT NOT NULL,
    PRIMARY KEY (ListingId, AmenityId),
    CONSTRAINT FK_ListingAmenity_Listing FOREIGN KEY (ListingId)
        REFERENCES Rentals.Listing(ListingId),
    CONSTRAINT FK_ListingAmenity_Amenity FOREIGN KEY (AmenityId)
        REFERENCES Rentals.Amenity(AmenityId)
);

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

CREATE TABLE Rentals.Role (
    RoleId INT IDENTITY(1,1) PRIMARY KEY,
    RoleNameId INT NOT NULL UNIQUE,
    Description VARCHAR(MAX) NULL,
    CONSTRAINT FK_Role_RoleName FOREIGN KEY (RoleNameId)
        REFERENCES Rentals.RoleName(RoleNameId)
);

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

CREATE TABLE Rentals.ListingMedia (
    ListingMediaId INT IDENTITY(1,1) PRIMARY KEY,
    ListingId INT NOT NULL,
    MediaType VARCHAR(10) NOT NULL CHECK (MediaType IN ('Image', 'Video')),
    MediaUrl VARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_ListingMedia_Listing FOREIGN KEY (ListingId)
        REFERENCES Rentals.Listing(ListingId)
);

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
