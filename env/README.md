# Environment Configuration Files

This directory contains environment-specific configuration files for the application.

## Files

- **`.env.development`** - Development environment variables
- **`.env.staging`** - Staging environment variables
- **`.env.production`** - Production environment variables
- **`.env.example`** - Template file (safe to commit)

## Setup

1. Copy `.env.example` to create your environment files:
   ```bash
   cp .env.example .env.development
   cp .env.example .env.staging
   cp .env.example .env.production
   ```

2. Update each file with your actual values:
   ```
   BASE_URL=https://your-api-url.com
   API_KEY=your_actual_api_key
   SESSION_KEY=your_session_key
   ```

## Security

⚠️ **NEVER commit actual credentials!**

- Only `.env.example` should be committed to version control
- All other `.env*` files are automatically ignored by `.gitignore`
- Keep production credentials secure and separate

## Usage

The app automatically loads the correct `.env` file based on the build configuration:

```bash
# Development
flutter run -t lib/main_development.dart

# Staging
flutter run -t lib/main_staging.dart

# Production
flutter run -t lib/main_production.dart
```