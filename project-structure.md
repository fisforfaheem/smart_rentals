# Project Structure

## Directory Organization
```
lib/
├── app/
│   ├── core/
│   │   ├── services/
│   │   ├── theme/
│   │   ├── utils/
│   │   └── values/
│   ├── data/
│   │   └── services/
│   ├── modules/
│   │   ├── admin/
│   │   ├── auth/
│   │   ├── car_details/
│   │   ├── details/
│   │   ├── driver/
│   │   ├── driver_profile/
│   │   ├── home/
│   │   ├── onboarding/
│   │   ├── role_selection/
│   │   └── splash/
│   └── routes/
├── assets/
├── test/
└── main.dart
```

## Architecture
- Modular architecture using GetX
- Feature-first organization
- Clean separation of concerns
- Service-based dependency injection

## Key Components
1. Core Layer
   - Services
   - Theme configuration
   - Utilities
   - Constants

2. Data Layer
   - Authentication services
   - Database services
   - API services

3. Feature Modules
   - Each module contains:
     - Controllers
     - Views
     - Bindings
     - Models

4. Routes
   - Centralized routing configuration
   - Route guards and middleware 