
# SmartTyrePulse

A performance analysis and monitoring application for tyres, built using Flutter. The app allows users to track tyre fitment records, cumulative working hours, failure reasons, inventory management, cost analysis, and receive real-time alerts.

## Table of Contents
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Steps to Install](#steps-to-install)
- [Usage](#usage)
- [Limitations & Future Scope](#limitations--future-scope)
  - [Current Limitations](#current-limitations)
  - [Future Enhancements](#future-enhancements)
- [Contribution](#contribution)
- [License](#license)
- [References](#references)
- [Contributors](#contributors)
- [Support & Star](#support--star)

## Features
- **Tyre Fitment Tracking** – Maintain records of tyre installations and replacements.
- **Real-time Monitoring** – Track cumulative working hours and performance.
- **Failure Analysis** – Identify reasons for tyre failures to improve maintenance.
- **Inventory Management** – Keep records of available and used tyres.
- **Cost Analysis** – Monitor and optimize costs associated with tyre usage.
- **Alert System** – Get notifications for tyre replacements and critical conditions.

## Technologies Used
- **Flutter** – For building a cross-platform mobile application.
- **Firebase** – For real-time data storage and retrieval.
- **Dart** – For backend logic and data processing.
- **MQTT** – For IIoT integration and telemetry data transfer.

## Installation

### Prerequisites
- Install Flutter: [Flutter Setup](https://flutter.dev/docs/get-started/install)
- Ensure Dart SDK is installed.
- Set up Firebase for real-time data storage.

### Steps to Install
1. Clone the repository:
   ```bash
   git clone https://github.com/aavvvacado/SmartTyrePulse.git
   cd SmartTyrePulse
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Firebase:
   - Create a Firebase project.
   - Add Firebase credentials to the app.
   - Enable Firestore for real-time data sync.
4. Run the application:
   ```bash
   flutter run
   ```

## Usage
- Open the app and add tyre details manually.
- Track performance and working hours.
- View inventory records and cost analysis.
- Receive alerts for tyre maintenance and failures.


## Limitations & Future Scope

### Current Limitations
- Requires manual data entry for initial setup.
- Limited to mobile platforms.

### Future Enhancements
- Automatic data fetching from IIoT sensors.
- Predictive analysis for tyre performance.
- Web dashboard for broader accessibility.

## Contribution
1. Fork the repository.
2. Create a new branch: `git checkout -b feature-branch`.
3. Commit your changes: `git commit -m 'Add new feature'`.
4. Push the branch: `git push origin feature-branch`.
5. Open a Pull Request.

## License
This project is licensed under the MIT License.

## References
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [MQTT Protocol](https://mqtt.org/)

## Contributors
- **Owner:** [aavvvacado](https://github.com/aavvvacado)
- **Future Contributors:** Contributions are welcome! Feel free to submit a pull request.

## Support & Star
If you found this project useful, please consider giving it a ⭐ on GitHub!

