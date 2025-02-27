# Coding Standards and Rules

## Code Style
1. Follow Flutter/Dart style guide
2. Use meaningful variable and function names
3. Keep functions small and focused
4. Document complex logic with comments
5. Use proper indentation and formatting

## Architecture Rules
1. Keep modules independent and loosely coupled
2. Use GetX for state management and dependency injection
3. Follow SOLID principles
4. Keep business logic in controllers
5. Use services for external communication

## File Organization
1. One widget per file
2. Group related files in feature modules
3. Keep shared code in core directory
4. Use proper file naming conventions:
   - snake_case for files
   - PascalCase for classes
   - camelCase for variables and functions

## State Management
1. Use GetX controllers for state
2. Avoid global state when possible
3. Keep state close to where it's used
4. Use proper reactive programming patterns

## Error Handling
1. Use try-catch blocks for error-prone code
2. Provide meaningful error messages
3. Handle edge cases appropriately
4. Log errors for debugging

## Testing
1. Write unit tests for business logic
2. Write widget tests for UI components
3. Use meaningful test descriptions
4. Follow arrange-act-assert pattern

## Security
1. Never store sensitive data in plain text
2. Use proper authentication methods
3. Validate all user inputs
4. Follow Firebase security best practices 