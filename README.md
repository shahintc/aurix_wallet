Markdown
# 🪙 Aurix Wallet MVP

A modern, mobile-first Flutter application simulating a gold-backed digital wallet. Users can securely view their balances, buy and sell digital gold (BPC), and seamlessly send value to other users in a clean, fintech-inspired interface.

---

## 🚀 How to Run the App

1. **Prerequisites:** Ensure you have the [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.12.0 or higher) and Android Studio or VS Code installed.
2. **Clone the repository:**
   ```bash
   git clone [https://github.com/shahintc/aurix_wallet.git](https://github.com/shahintc/aurix_wallet.git)
   cd aurix_wallet
Install Dependencies:

Bash
flutter pub get
Run the Application:
Select your preferred device (Emulator or Chrome web) and run:

Bash
flutter run
Note: To build a production-ready Android APK, run flutter build apk --release.



🏗️ Architecture Decisions
To meet the 24-hour MVP deadline while maintaining a highly scalable codebase, the following architectural decisions were made:

State Management (Provider): Chosen for its simplicity and efficiency. It allows for a clean separation of business logic (currency conversions, transaction history, and balance updates) from the UI components.

Domain-Driven Folder Structure: The lib directory is strictly organized into screens, providers, widgets, models, and theme. This ensures the project remains maintainable as the application scales.

Custom Reusable Widgets: UI elements like AurixCard, PrimaryButton, and AmountField were abstracted into reusable widgets to enforce visual consistency and adhere strictly to the provided Fintech design system (Deep Navy, Gold, and White).

In-Memory Storage: For this simulation, data is handled in-memory via the WalletProvider. This satisfies the core MVP requirements without the overhead of spinning up a live database.



✅ What is Completed

The following core flows have been successfully implemented and tested:

Authentication UI: Welcome and Login screens designed and fully routed.

Dashboard: Home screen featuring an animated balance card and quick-action navigation.

Live Market Simulation: A dynamic timer that actively simulates live gold market price fluctuations every 8 seconds, automatically updating portfolio USD values in real-time.

Buy & Sell Logic: Full mathematical conversions between USD, Grams of Gold, and BPC (1 BPC = 0.0001g), complete with validation for insufficient balances.

Peer-to-Peer Transfers: A Send screen allowing users to transfer BPC to email addresses or Wallet IDs.

Transaction Tracking: A complete History screen that securely logs all Buys, Sells, and Transfers with accurate timestamps and formatting.



🚧 What is Missing

As this is a 24-hour conceptual simulation, the following production features were intentionally deferred:

Persistent Backend: A real database to store user credentials, wallet balances, and permanent transaction ledgers.

True Authentication: Integration with Firebase Auth or OAuth for secure user login and session management.

Live Financial APIs: Connecting to a real-world market API (e.g., Alpha Vantage or Metalprice API) instead of utilizing a local mathematical simulation.

Recipient Validation: The current P2P transfer logic does not cross-reference the recipient email against a live database of registered users.



🚀 What I Would Improve with More Time

If given additional time to push this MVP to a production-ready state, I would prioritize:

Backend Integration: Connect the app to Firebase or Supabase to handle real-time data syncing, user authentication, and persistent wallet states.

Enhanced Security: Implement biometric authentication (FaceID/Fingerprint) before allowing outgoing transactions.

QR Code Functionality: Add the ability for users to generate and scan QR codes for frictionless, in-person BPC transfers.

Automated Testing: Expand the testing suite to include comprehensive widget and unit tests for the core conversion mathematics to ensure absolute financial accuracy.

CI/CD Pipeline: Set up GitHub Actions to automatically lint, test, and build the APK/iOS outputs upon every commit to the main branch.
