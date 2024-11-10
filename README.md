# Lost and Found

[![Flutter](https://img.shields.io/badge/Flutter-3.24.4-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Auth%20%7C%20Firestore-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A mobile app built with Flutter to help people report **lost** and **found** items. It allows users to log in, report items they’ve lost, or found, upload images, and view posts from other users. The app utilizes **Firebase** for authentication and data storage, and **ImgBB** for image hosting.

## Features

- **User Authentication**: Firebase Auth for login and sign-up.
- **Lost Item Reporting**: Report lost items with descriptions and images.
- **Found Item Reporting**: Report found items with descriptions and images.
- **Real-Time Updates**: Items are stored in Firebase Firestore and updated in real-time.
- **Image Upload**: Images of lost/found items uploaded to ImgBB and displayed in the app.
- **Push Notifications** (optional): Real-time notifications for updates on lost/found items.

## Screenshots

![Login Page](assets/screenshots/login_page.png)
![Register Page](assets/screenshots/register_page.png)
![Forgot Password](assets/screenshots/forgot_pw_page.png)
![Google Sign In](assets/screenshots/google_sign_in_page.png)
![Lost Items](assets/screenshots/lost_page.png)
![Found Items](assets/screenshots/found_page.png)
![Report Lost Items](assets/screenshots/report_lost_page.png)
![Report Found Items](assets/screenshots/report_found_page.png)



## Installation

### Prerequisites

1. **Flutter SDK**: Ensure you have Flutter installed. For instructions, check the [Flutter Installation Guide](https://flutter.dev/docs/get-started/install).
2. **Firebase Project Setup**: Set up a Firebase project with Authentication (Email/Password) and Firestore for data storage.
3. **ImgBB API Key**: Obtain an API key from [ImgBB](https://imgbb.com/) for image uploads.

### Clone the Repository

```bash
git clone https://github.com/your-username/lost-and-found.git
cd lost-and-found
