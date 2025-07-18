# RoomRental Application

## Project Overview

RoomRental is a comprehensive platform designed to streamline the process of finding and renting rooms/properties. It connects tenants seeking accommodation with landlords offering properties, featuring robust tools for listing, searching, communication, and payment management.

---

## Features

The RoomRental application offers a diverse set of features catering to different user roles:

### Common Features

* **User Authentication**: Register and sign in using email, Google, or WhatsApp.
* **Account Management**: Ability to change and modify all account-related settings.
* **Security**: Password reset and account recovery functionalities.
* **Reporting**: Flagging fake listings and reporting malicious users to maintain platform integrity.

### Tenant Features

Tenants can efficiently find and manage their rental properties with features like:

* **Advanced Search & Filter**:
    * **Location**: Search by exact location (integrates with mapping APIs like Google Maps).
    * **Property Type**: Filter by Residential (Flat, House, Business, Office Space, Apartment, Single Room, Hostel/PG) or Commercial (Flat, House, Business, Office Space).
    * **Layout Type**: Search for 1RK, 1BHK, 2BHK, 3BHK, 4BHK, 4+BHK, Studio.
    * **Price**: Filter within a specified price range.
    * **Availability**: Filter by immediate, within 15 days, within 30 days, or 30+ days.
    * **Preferred Tenant**: Search for properties preferring Families, Bachelor Male, Bachelor Female, Company, or Friends.
    * **Amenities**: Detailed filtering options including:
        * **Room Amenities**: Furnishings (Furnished, Partial-Furnished, Not Furnished), Air Condition, Heater, Hot Water (Geyser/Solar), Kitchen Equipment (Cooking), Fridge, Wi-Fi, Power Backup, Attached Bathroom, Balcony.
        * **Property Amenities**: CCTV, Security, Bike Parking, Car Parking, Drainage, Waste Disposal, Drinking Water, 24x7 Water (Boring, Well, Municipal, Tanker), Accessibility.
    * **Property Rules**: Filter by "Pets Allowed?" and "Smoking Allowed?".
    * **Verification Status**: Filter for "Verified" properties.
* **Listing Details**: View comprehensive information for each listing, including:
    * Property Name/Title
    * Listing Price
    * Verified Location (integrated with Google Maps)
    * Property Area
    * Room Layout Type
    * Video and Images
    * Preferred Tenant
    * Amenities
    * Description
    * Other Details: Floor in building, Age of Building, Property Facing.
* **Engagement**:
    * **Shortlist**: Like and save listings for later viewing.
    * **Communication**: Call and message landowners (chat-messaging), with verified contact number and email.
    * **Visit Scheduling**: Schedule property visits, subject to landlord approval.
    * **Online Booking**: Book properties after landlord approval (integrates with payment gateways like Esewa). A lease agreement is generated post-booking.
* **Payments**: Ability to pay monthly rent directly from the application.
* **Dashboards**: Access various dashboards for tracking:
    * Appointment Dashboard
    * Booking Dashboard
    * Shortlist Dashboard
    * Monthly Rent Dashboard
* **Premium Benefits (Subscription)**: Tenants can pay a subscription fee for benefits like verified properties only and an ad-free experience.

### Landlord Features

Landlords can efficiently manage their properties and tenants with features like:

* **Landlord Registration**: Register as a landlord, providing:
    * Full Name
    * Phone Number (verified via OTP)
    * Email Address (verified)
    * Identifying Document (Citizenship, Passport, Driving License, PAN)
* **Listing Management**:
    * Draft and publish new property listings with detailed information:
        * Property Name (Title)
        * Location (integrated with Google Map)
        * Property Type (Residential, Commercial)
        * Types of Rental Properties (Flat, House, Business, Office Space, Apartment, Single Room, Hostel/PG)
        * Layout Type
        * Price
        * Photos (5 mandatory) and Video (mandatory)
        * Availability (Immediate, within 15 day, within 30 days, 30+ days)
        * Preferred Tenant
        * Amenities (Room and Property amenities as listed above)
* **Request Management**:
    * Approve property visit requests from tenants.
    * Approve tenants online and accept booking prices.
* **Dashboards**: Access owner-specific dashboards for tracking:
    * Appointments Dashboard
    * Booking Dashboard

### Admin Features

Admins are responsible for maintaining the platform's integrity and user experience:

* **Listing Management**: Edit and delete any listing.
* **Report Management**: View, approve, or deny reports for reported listings. Approving a report will delete the listing; denying it will keep the listing as is.
* **User Management**: Suspend, block, or delete user accounts.
* **Verification**: Review and approve account information, especially landlord identification documents.

---

## Database Schema

The application's data is structured within the `Rentals` schema, designed to support all the features and user roles described above.

* **Entity-Relationship Diagram (ERD)**: The overall structure and relationships between entities are visualized in the ERD provided.
      For a quick visual overview of the database structure:
      ![RoomRental ERD Overview](images/Rentals_PNG.png)
    * **Click for Detailed ERD (SVG)**: You can view a high-resolution, zoomable version of the ERD by clicking [here](images/Rentals_SVG.svg).
* **Database Definition Language (DDL)**: The detailed table definitions, including columns, data types, primary keys, and foreign key constraints, are specified in the DDL script. This script sets up the `Rentals` schema and all its tables, including various lookup tables for maintaining data consistency (e.g., `PropertyType`, `RentalType`, `LayoutType`, `AvailabilityStatus`, `PreferredTenants`, `AmenityCategory`, `MessageStatus`, `VisitRequestStatus`, `BookingRequestStatus`, `PaymentStatus`, `ReportStatus`, `RoleName`, `SubscriptionUserType`).

You can visualize the database schema using the dbdiagram.io code provided previously. Simply paste the code into [dbdiagram.io](https://dbdiagram.io/home) to generate an interactive diagram.

---

## 🚀 Usage (Conceptual)

Once the application is set up, users can:

* **Register/Login**: Create an account or sign in using their preferred method.
* **Browse Listings**: Tenants can explore properties using various search and filter options.
* **Create Listings**: Landlords can draft and publish their property listings.
* **Interact**: Tenants and landlords can communicate, schedule visits, and manage bookings and payments through the platform.
* **Admin Panel**: Admin users can access a dedicated interface for platform moderation and management.

---
