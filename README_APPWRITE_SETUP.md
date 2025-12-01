# Appwrite Database Setup Guide

For the **Reviews**, **Messages**, and **Bookings** features to work, you must create the corresponding collections in your Appwrite Database.

## 1. Open Appwrite Console
Go to your project dashboard and navigate to **Databases** -> Select your database (`692e06f30032cdc6d967`).

---

## 2. Create "Reviews" Collection
1. Click **Create Collection**.
   - **Name:** `Reviews`
   - **Collection ID:** `reviews` (Click the pencil icon to set this custom ID).
2. Click **Create**.
3. Go to the **Attributes** tab and add:
   - `serviceId` (String, Size: 50, Required: Yes)
   - `userId` (String, Size: 50, Required: Yes)
   - `userName` (String, Size: 100, Required: Yes)
   - `rating` (Float, Required: Yes)
   - `comment` (String, Size: 1000, Required: No)
4. Go to the **Settings** tab (Permissions):
   - Under **Permissions**, add a role.
   - Select **Any** -> Check **Read**.
   - Select **Users** -> Check **Create**, **Read**.

---

## 3. Create "Messages" Collection
1. Click **Create Collection**.
   - **Name:** `Messages`
   - **Collection ID:** `messages` (Click the pencil icon to set this custom ID).
2. Click **Create**.
3. Go to the **Attributes** tab and add:
   - `chatId` (String, Size: 100, Required: Yes)
   - `senderId` (String, Size: 50, Required: Yes)
   - `text` (String, Size: 5000, Required: Yes)
4. Go to the **Settings** tab (Permissions):
   - Under **Permissions**, add a role.
   - Select **Users** -> Check **Create**, **Read**.

---

## 4. Create "Bookings" Collection
1. Click **Create Collection**.
   - **Name:** `Bookings`
   - **Collection ID:** `bookings` (Click the pencil icon to set this custom ID).
2. Click **Create**.
3. Go to the **Attributes** tab and add:
   - `serviceId` (String, Size: 50, Required: Yes)
   - `serviceTitle` (String, Size: 100, Required: Yes)
   - `userId` (String, Size: 50, Required: Yes)
   - `providerName` (String, Size: 100, Required: Yes)
   - `bookingDate` (String, Size: 50, Required: Yes)
   - `status` (String, Size: 20, Required: Yes, Default: "pending")
4. Go to the **Settings** tab (Permissions):
   - Under **Permissions**, add a role.
   - Select **Users** -> Check **Create**, **Read**, **Update**.

---

## 5. Verify "Services" Collection
Ensure your existing `services` collection has these permissions so users can see them:
- **Any** -> **Read**
