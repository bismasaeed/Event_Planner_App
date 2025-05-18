📅 Smart Event Planning App

## Overview
**Smart Event Planning App** is a mobile application built to streamline the event planning process by enabling seamless collaboration between two primary roles: **Vendors** and **Organizers**. The platform offers a centralized, interactive space where users can connect, communicate, and coordinate effortlessly. Whether it's booking a venue, choosing a catering service, or finding the perfect decor, this app simplifies it all.

## 🚀 Features

### 1. Splash Screen
- Displays app logo and name for 3–5 seconds.

<div>
  <img src="ss1.png" width="250" style="margin-right: 10px;"/>
  <img src="ss2.png" width="250"/>
</div>

---

### 2. Authentication Flow
- Google Sign-In via Firebase Authentication.
- Persistent login using session management.
- Redirects:
    - To **Sign-Up Screen** if the user is not logged in.
    - To **Role-based Dashboard** if authenticated.

<img src="ss3.png" width="250"/>

---

### 3. User Role Selection
- Users choose between **Vendor** or **Organizer** roles.
- Role-based access delivers a tailored user experience.

<img src="ss4.png" width="250"/>

---

### 4. Vendor Dashboard
- View a list of uploaded services and upcoming booked events.

<div>
  <img src="ss12.png" width="250" style="margin-right: 10px;"/>
  <img src="ss13.png" width="250"/>
</div>

- Edit existing service posts.

<img src="ss133.png" width="250"/>

- Add new services with:
    - Category selection (e.g., Food, Decor, Venue)

<img src="ss14.png" width="250"/>

---

### 5. Booking Requests
- View incoming booking details:
    - Organizer Name, Service, Date, Status
- Accept or Reject bookings with one tap.

<img src="ss15.png" width="250"/>

---

### 6. Organizer Dashboard
- Browse services by category: **Food**, **Decor**, **Venue**.

<div>
  <img src="ss5.png" width="250" style="margin-right: 10px;"/>
  <img src="ss6.png" width="250"/>
</div>

- Submit booking requests by selecting date and time.
- Users can view and post comments on services and experiences.

<div>
  <img src="ss10.png" width="250" style="margin-right: 10px;"/>
  <img src="ss11.png" width="250"/>
</div>

#### My Bookings
- View bookings by status: **Pending**, **Accepted**, **Rejected**.
- Option to cancel bookings.

<img src="ss7.png" width="250"/>

---

### 7. Search & Filtering
- Keyword search for services or vendors.
- Filter results by category for easy discovery.

<div>
  <img src="ss8.png" width="250" style="margin-right: 10px;"/>
  <img src="ss9.png" width="250"/>
</div>

---

## Technologies Used
- **Flutter**
- **Firebase Authentication**
- **Firebase Firestore**
- **BLoC Pattern for State Management**