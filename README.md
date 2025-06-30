# 🛒 Kuku Marketplace

**Kuku Marketplace** is a Flutter-based mobile application that connects farmers and customers. It enables farmers to list and sell agricultural products, while customers can browse, order, chat, pay, and rate farmers directly from their phones.

---

## App Features

### Farmer
- Add, edit, and delete products
- View real-time orders
- Receive and reply to customer messages
- View customer ratings and feedback

###  Customer
- Browse all products with filtering and sorting
- View detailed product pages with farmer ratings
- Place orders with quantity selection
- Chat with farmers before/after ordering
- Pay for orders (manual for now, payment gateway can be integrated)
- Rate farmers after completing an order

###  Admin
- View all registered users (farmers/customers)
- View all products in the system
- Delete users (except self)
- Monitor overall app activity

---

## Authentication & Roles
- Firebase Authentication is used for sign up and login.
- Users are assigned roles: `customer`, `farmer`, or `admin`.
- Each role sees a different dashboard and permissions.

---

## Order Workflow

1. **Customer browses** products.
2. **Places an order** (if stock is available).
3. **Order appears in "My Orders"**.
4. **Customer clicks "Pay Now"** to complete purchase.
   - Commission is calculated.
   - Farmer's balance is updated.
5. **Customer can then rate** the farmer.
6. **Rating appears on product and profile.**

---

## 💬 Messaging System

- Real-time chat between farmers and customers
- Messages stored in Firestore under the `messages` collection
- Farmers see customer messages in their own inbox

---

## 🌟 Rating System

- Customers can rate farmers only after a paid order
- One rating per order
- Stored in `ratings/{farmerId}/reviews`
- Ratings and reviews visible on product details and farmer profile

---

## ☁️ Firebase Integration

- **Firestore**: Products, Orders, Users, Ratings, Messages
- **Authentication**: Role-based login/signup
- **Storage**: Product images

---

## Design Theme

- Modern UI with consistent green-themed styling
- Gradient AppBars, smooth cards, and clean layouts
- Responsive design across Android/iOS

---

## Getting Started

1. Clone the repo:

```bash
git clone https://github.com/seb498/kuku_marketplace_final.git

