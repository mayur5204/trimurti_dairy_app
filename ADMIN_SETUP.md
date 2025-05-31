# Admin User Setup Guide

## Overview
This guide explains how to create the dairy owner's admin account through Firebase Console. The app only supports one admin user (dairy owner) whose credentials must be created directly in Firebase Console for security purposes.

## Steps to Create Admin User

### 1. Access Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your **Trimurti Dairy** project
3. Navigate to **Authentication** in the left sidebar

### 2. Enable Email/Password Authentication
1. Click on the **Sign-in method** tab
2. Find **Email/Password** in the providers list
3. Click on it and enable it
4. Save the changes

### 3. Create Admin User
1. Go to the **Users** tab in Authentication
2. Click **Add user** button
3. Fill in the admin details:
   - **Email**: Enter the dairy owner's email (e.g., `owner@trimurtidairy.com`)
   - **Password**: Create a strong password (minimum 6 characters)
4. Click **Add user**

### 4. Verify User Creation
1. The new user should appear in the Users list
2. Note down the **User UID** for future reference
3. The user is now ready to sign in to the mobile app

## Security Recommendations

### Strong Password Policy
- Use at least 8 characters
- Include uppercase and lowercase letters
- Include numbers and special characters
- Avoid common words or personal information

### Account Security
- Enable 2FA when available
- Regularly update the password
- Monitor sign-in activity from Firebase Console
- Keep login credentials secure and private

## App Behavior

### Login Process
- The app only shows a **Sign In** form (no sign-up option)
- Only the admin user created in Firebase Console can access the app
- Failed login attempts will show appropriate error messages
- Password reset functionality is available if needed

### Error Messages
The app will show user-friendly error messages for common issues:
- "No user found for this email address"
- "Wrong password provided"
- "The email address is not valid"
- "This user account has been disabled"

## Troubleshooting

### Cannot Sign In
1. Verify the email and password are correct
2. Check if the user exists in Firebase Console > Authentication > Users
3. Ensure the user account is not disabled
4. Try password reset if needed

### Password Reset
1. User can click "Forgot Password?" on the login screen
2. Enter the admin email address
3. Check email for password reset link
4. Follow the link to create a new password

### Account Management
- To change admin email: Update in Firebase Console > Authentication > Users
- To disable access: Disable user in Firebase Console
- To view login history: Check Firebase Console > Authentication > Users > [User] > Recent activity

## Firebase Console Access
Make sure the following people have access to Firebase Console for user management:
- Dairy owner (primary admin)
- IT administrator (if applicable)
- Authorized personnel only

## Next Steps
1. Create the admin user following steps above
2. Test login with the mobile app
3. Ensure password reset functionality works
4. Keep backup access to Firebase Console
5. Document the admin credentials securely

---
**Note**: This is the only way to create user accounts for this app. No in-app registration is available for security reasons.
