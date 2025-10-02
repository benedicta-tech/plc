# Data Model: Preachers Management

## Entities

### Preacher

- **id**: `int` (primary key)
- **fullName**: `String`
- **phone**: `String` (unique)
- **city**: `String`
- **state**: `String`

### PreachingTheme

- **id**: `int` (primary key)
- **name**: `String` (unique)

### PreacherPreachingTheme

- **preacherId**: `int` (foreign key to Preacher)
- **preachingThemeId**: `int` (foreign key to PreachingTheme)
