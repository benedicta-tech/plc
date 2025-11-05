# PLC App

A Flutter application for the PLC community.

## Prerequisites

- Flutter SDK 3.35.5 or higher
- Dart SDK 3.6.2 or higher
- Android Studio / Xcode (for mobile development)
- Google Sheets API service account credentials

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <repository-url>
cd plc
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Google Sheets Credentials

The app uses [envied](https://pub.dev/packages/envied) for secure, obfuscated environment variables. You have several options to set this up:

#### Option A: Using the Setup Script (Recommended)

Run the interactive setup script:

```bash
./setup_credentials.sh
```

The script will guide you through:
- Importing from an existing `service_account.json` file
- Pasting the JSON content directly
- Creating from template for manual editing

#### Option B: Manual Setup

1. Copy the template file:
   ```bash
   cp .env.template .env
   ```

2. Edit `.env` and replace the placeholder JSON with your actual Google service account credentials

3. Save the file

#### Obtaining Service Account Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google Sheets API
4. Go to "IAM & Admin" > "Service Accounts"
5. Create a new service account
6. Generate and download the JSON key
7. Share your Google Sheets with the service account email address

### 4. Generate Envied Code

After creating your `.env` file, generate the obfuscated environment code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This creates `lib/core/config/env.g.dart` with your encrypted credentials.

### 5. Running the App

#### Development Mode

```bash
flutter run
```

#### Building

**Debug Build:**
```bash
flutter build apk --debug
```

**Release Build:**
```bash
flutter build apk --release
```

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```

### 6. Testing

```bash
flutter test
```

## Project Structure

```
lib/
├── core/
│   └── storage/
│       └── gsheets_storage_service.dart  # Google Sheets integration
├── features/                              # Feature modules
└── main.dart                             # App entry point
```

## CI/CD

The project uses GitHub Actions for continuous deployment:
- Builds are automatically created on workflow dispatch
- Deployment to Google Play Console (alpha, beta, production tracks)
- Credentials are injected securely via GitHub Secrets

### Required GitHub Secrets

- `GOOGLE_SERVICE_ACCOUNT`: Google service account JSON (as a JSON string)
- `ANDROID_KEYSTORE_BASE64`: Base64-encoded Android keystore
- `ANDROID_KEYSTORE_PASSWORD`: Android keystore password
- `GOOGLE_SERVICE_ACCOUNT_KEY`: Google Play Console service account key

## Security Notes

- **Never commit `.env`** - it's already in `.gitignore`
- **Never commit `service_account.json`** - keep credentials secure
- The app uses `envied` to obfuscate credentials at compile time
- Credentials are encrypted in the compiled binary (much more secure than `--dart-define`)
- The hardcoded credentials have been removed from the source code

## How Envied Works

`envied` provides compile-time obfuscation and encryption of environment variables:

1. **Compile-time encryption**: When you run `build_runner`, envied encrypts your credentials
2. **Obfuscated output**: The generated `env.g.dart` contains encrypted values
3. **Runtime decryption**: The app decrypts values at runtime (very fast)
4. **Binary protection**: Much harder to extract credentials from the compiled app compared to `--dart-define`

## Troubleshooting

### "Google Service Account credentials not configured" Error

This means the app couldn't find the credentials. Make sure:
1. You've created the `.env` file
2. You've run `dart run build_runner build --delete-conflicting-outputs`
3. The `env.g.dart` file was generated successfully

### "Target of URI hasn't been generated" Error

This means you need to run build_runner:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Invalid JSON Format

Ensure your `.env` follows this structure:
```
GOOGLE_SERVICE_ACCOUNT={"type":"service_account","project_id":"..."}
```

Note: The service account JSON should be on a single line without quotes around it.

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Envied Package](https://pub.dev/packages/envied)
- [Google Sheets API](https://developers.google.com/sheets/api)
- [Google Cloud Service Accounts](https://cloud.google.com/iam/docs/service-accounts)
