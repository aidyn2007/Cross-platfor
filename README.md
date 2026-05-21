# Books App - Midterm Project

A personal library management app with a loyalty system and profile management.

## Implemented Features

1. **Loyalty Points System:**
* Adding any book to the "Library List" awards the user +100 points.
* The current point count is displayed in the **Account** section.
* Points are calculated dynamically based on the number of saved books.

2. **Profile Management (Personal Information):**
* The "Personal Information" button is available in the **Account** section.
* The user can change their **First Name** and **Last Name**.
* Data is saved locally and immediately updated in the profile header.

## Testing

To verify the correct operation of these features, integration tests have been written in the `test/features_test.dart` file.

### What the tests check:
* **Points Accrual Test:** Checks that clicking "Add to Library" increases the account's point counter proportionally to the number of books (1 book = 100 points).
* **Navigation Test:** Checks that the transition from the account settings to the profile editing page works correctly.
* **Data Update Test:** Checks that after entering a new name and clicking "Save," the data is successfully updated on the account main page.

### How to run the tests:

Open a terminal in the project root and run the command:

```sh
flutter test test/features_test.dart
```

## Tech Stack
* **State Management:** Flutter Riverpod
* **Navigation:** GoRouter
* **Local Storage:** SharedPreferences
* **Testing:** flutter_test
