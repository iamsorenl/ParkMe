# PARKME
PARKME is a mobile application developed by Joseph, Maxim, Alper, Neel, and Soren for users to find and reserve available parking spaces in their vicinity.    The app uses Google Maps APIs to display parking locations and availability, and allows users to book and pay for parking spots in advance.   

Installation
Before installing PARKME, please ensure that you have the following software installed on your machine:   

Flutter (https://flutter.dev/docs/get-started/install)  
Android Studio SDK (for Android users) (https://developer.android.com/studio) 
XCode (for iOS users) (download from the App Store on your Mac) 
Docker to run a containerized version of Postgres 
To install PARKME, follow these steps:    
Clone or download the PARKME project from our GitHub repository: `https://github.com/ParkMeCSE115a/parkme`.
Open the project in your preferred IDE. 
In the root directory, run `npm run prestart` . This installs the necessary node packages in the backend, and the flutter pub libraries in the frontend.  
To start the backend, navigate to /backend and run the following: `
```
docker compose up -d
npm run dev
```
To start the frontend navigate to /frontend and run the following:  
```flutter run```   
And then select your device.  
For the app to run, both the backend and the frontend must be running.  
If you encounter any issues during installation, please refer to the Flutter documentation for troubleshooting tips: https://flutter.dev/docs/get-started/install.  

Required Environment Variables  
To run the application, there are variables needed to put in a .env in both the frontend and backend, in addition to google map api keys. 

Backend   
Navigate to the backend and add a .env file (/backend/.env)   
The required .env variables for the backend are:    

```
PORT=
POSTGRES_DB=
POSTGRES_USER=
POSTGRES_PASSWORD=
JWT_ACCESS_TOKEN=
GCLOUD_PROJECT_ID=
GCLOUD_STORAGE_BUCKET=
```

Frontend  
```
host=
```

Usage
Upon opening the PARKME app, you will be prompted to enable location services. Please ensure that you have location services enabled to use the app's features.

Once location services are enabled, the app will display available parking locations near you on a map. You can view parking details such as price, availability, and distance from your current location. You can also reserve a parking spot by selecting the desired location and entering your payment details.
