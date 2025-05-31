---
applyTo: '**'
---

# Flutter Development Guidelines for VSCode Agent

## Code Quality & Error Prevention
- **Always validate syntax**: Before completing any code generation or file changes, run syntax checks and validate code structure
- **Error detection**: Check for common Flutter/Dart errors including:
  - Missing imports
  - Incorrect widget hierarchy
  - Type mismatches
  - Null safety violations
  - Unused variables and imports
- **Linting compliance**: Ensure code follows Flutter linting rules and dart formatting standards
- **Build verification**: When possible, verify that generated code compiles without errors

## Package Management
- **Use latest stable versions**: Always check for and implement the latest stable versions of Flutter packages
- **Required libraries**:
  - `get: ^4.6.6` (or latest) - State management and navigation
  - `flutter/material.dart` - Material Design components
  - `flutter_localizations` - Flutter internationalization support
  - `intl: ^0.19.0` (or latest) - Internationalization and localization utilities
- **Package verification**: Before adding dependencies, verify package compatibility and maintenance status
- **Version constraints**: Use appropriate version constraints in pubspec.yaml

## UI Framework Standards
- **GetX Library**: Use GetX for all state management, dependency injection, and route management
  - Controllers: Use GetxController for business logic
  - State management: Use Obx() and GetBuilder() appropriately
  - Navigation: Use Get.to(), Get.off(), Get.offAll() for routing
  - Dependency injection: Use Get.put(), Get.lazyPut(), Get.find()
- **Material Design**: Implement Material UI components consistently
  - Use Material 3 design system when available
  - Follow Material Design guidelines for spacing, typography, and colors
  - Utilize built-in Material widgets (AppBar, Scaffold, Card, etc.)

## Implementation Approach
- **Step-by-step development**: Break down complex implementations into manageable steps:
  1. **Setup phase**: Create basic file structure and imports
  2. **Model/Controller phase**: Implement data models and GetX controllers
  3. **UI phase**: Build widgets incrementally
  4. **Integration phase**: Connect UI with controllers and test functionality
  5. **Refinement phase**: Add animations, error handling, and polish

## Code Structure Requirements
- **File organization**: 
  - Follow Flutter project structure conventions
  - Separate concerns (views, controllers, models, services)
  - Use meaningful file and folder names
  - Create `l10n` folder for localization files
  - Organize translation files by language (en.arb, mr.arb)
- **Widget composition**: 
  - Create reusable custom widgets
  - Keep widgets focused and single-purpose
  - Use proper widget lifecycle methods
- **GetX patterns**:
  - Controllers in separate files under `/controllers`
  - Views in `/views` or `/screens`
  - Models in `/models`
  - Services in `/services`
  - Language controllers in `/controllers/language_controller.dart`

## Development Process
1. **Analysis**: Understand requirements thoroughly before coding
2. **Planning**: Outline step-by-step implementation approach
3. **Implementation**: Code incrementally with frequent validation
4. **Testing**: Verify each step works before proceeding
5. **Documentation**: Add clear comments explaining complex logic
6. **Review**: Final syntax and error check before completion

## Error Handling & Best Practices
- Implement proper error handling with try-catch blocks
- Use null safety features consistently
- Handle loading states and user feedback
- Implement proper dispose methods for controllers
- Follow Flutter performance best practices
- Use const constructors where appropriate

## Communication Style
- Explain each implementation step clearly
- Provide rationale for technology choices
- Highlight potential issues or considerations
- Offer alternative approaches when applicable
- Include helpful comments in generated code