# Flutter Nodejs Keycloak Integration Demo

## Description
This project is a web application built using Flutter for the frontend and Node.js for the backend. The backend APIs are secured using Keycloak.
Flutter Web frontend log in user via Keycloak, save Access_Token. When calliing backend API, add Bearer Token to access protected API.

## Prerequisites
Before running this project, ensure you have the following installed:
- Flutter SDK
- Node.js
- Keycloak server

## Installation
1. Clone this repository.
2. Navigate to the `frontend` directory and run `flutter pub get` to install dependencies.
3. Navigate to the `backend` directory and run `npm install` to install dependencies.

## Configuration
1. Keycloak Configuration:
   - Set up Keycloak server and create a realm.
   - Create a client in Keycloak for your demo project.
   - This sample project use Authenticate Code Flow with PKCS enabled. Please setup correctly.
   - Add some users. Some regular user, and some with Realm Role called `actor`.
   

2. Backend Configuration:
   - Configure the backend service to use the Keycloak client for authentication and authorization.
   - Update the `backend/keycloak.json` file with your Keycloak configuration.

3. Frontend Configuration:
   - Update the `frontend/lib/config.dart` file with the appropriate Keycloak configuation and backend API URLs.

## Usage
1. Start the backend server:
```
cd backend
npm start
```

2. Run the frontend application:
```
cd frontend
flutter run -d chrome --web-port=5678
```


## Contributing
Contributions are welcome! Please fork this repository and create a pull request with your changes.

## License
This project is licensed under the [MIT License](LICENSE).

## Support
This project is a prototype demo project at DFO, provided as is

