
# Library Management API

This API is built with PHP (Slim Framework) and uses JWT for authentication and MySQL as the database. It provides endpoints for managing users, authors, books, and book-author relations.

## Features

- User authentication with JWT-based token management.
- CRUD operations for authors, books, and book-author relations.
- Token validation and renewal mechanism.
- Secure database operations using PDO.

---

## Setup

### Prerequisites

- PHP 7.4 or higher
- MySQL
- Composer
- Slim Framework
- Firebase JWT library

### Installation

1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```

2. Install dependencies using Composer:
   ```bash
   composer install
   ```

3. Update the database configuration in the PHP code:
   ```php
   $servername = "localhost";
   $username = "root";
   $password = "";
   $dbname = "library";
   $port = 3308;
   ```

4. Import the database schema (SQL file provided in the repository).

5. Start the Xampp server:


---

## API Endpoints

### 1. User Registration
**Endpoint:** `/user/register`  
**Method:** POST  

**Request:**  
```json
{
  "username": "john_doe",
  "password": "securepassword"
}
```

**Response:**  
```json
{
  "status": "success",
  "access_token": null,
  "data": null
}
```

---

### 2. User Authentication
**Endpoint:** `/user/authenticate`  
**Method:** POST  

**Request:**  
```json
{
  "username": "john_doe",
  "password": "securepassword"
}
```

**Response:**  
```json
{
  "status": "success",
  "access_token": "jwt_token_here",
  "data": null
}
```

---

### 3. Create Author
**Endpoint:** `/authors/Create`  
**Method:** POST  

**Request:**  
```json
{
  "name": "Author Name",
  "token": "jwt_token_here"
}
```

**Response:**  
```json
{
  "status": "success",
  "access_token": "new_jwt_token",
  "data": null
}
```

---

### 4. Get All Authors
**Endpoint:** `/authors/Get`  
**Method:** GET  

**Request:**  
```json
{
  "token": "jwt_token_here"
}
```

**Response:**  
```json
{
  "status": "success",
  "access_token": "new_jwt_token",
  "data": [
    {
      "authorid": 1,
      "name": "Author Name"
    }
  ]
}
```

---

### 5. Update Author
**Endpoint:** `/authors/Update/{id}`  
**Method:** PUT  

**Request:**  
```json
{
  "name": "Updated Author Name",
  "token": "jwt_token_here"
}
```

**Response:**  
```json
{
  "status": "success",
  "access_token": "new_jwt_token",
  "data": null
}
```

---

### 6. Delete Author
**Endpoint:** `/authors/Delete/{id}`  
**Method:** DELETE  

**Request:**  
```json
{
  "token": "jwt_token_here"
}
```

**Response:**  
```json
{
  "status": "success",
  "access_token": "new_jwt_token",
  "data": null
}
```

---

### 7. Create Book
**Endpoint:** `/books/Create`  
**Method:** POST  

**Request:**  
```json
{
  "title": "Book Title",
  "author_id": 1,
  "token": "jwt_token_here"
}
```

**Response:**  
```json
{
  "status": "success",
  "access_token": "new_jwt_token",
  "data": null
}
```

---

### 8. Get All Books
**Endpoint:** `/books/Get`  
**Method:** GET  

**Request:**  
```json
{
  "token": "jwt_token_here"
}
```

**Response:**  
```json
{
  "status": "success",
  "access_token": "new_jwt_token",
  "data": [
    {
      "bookid": 1,
      "title": "Book Title",
      "authorid": 1
    }
  ]
}
```

---

### 9. Update Book
**Endpoint:** `/books/Update/{id}`  
**Method:** PUT  

**Request:**  
```json
{
  "title": "Updated Book Title",
  "author_id": 2,
  "token": "jwt_token_here"
}
```

**Response:**  
```json
{
  "status": "success",
  "access_token": "new_jwt_token",
  "data": null
}
```

---

### 10. Delete Book
**Endpoint:** `/books/Delete/{id}`  
**Method:** DELETE  

**Request:**  
```json
{
  "token": "jwt_token_here"
}
```

**Response:**  
```json
{
  "status": "success",
  "access_token": "new_jwt_token",
  "data": null
}
```

---

### 11. Get Books by Author ID

**Endpoint**: `/books/GetByAuthorId`  
**Method**: `POST`  

**Request**:  
```json
{
  "author_id": 1,
  "token": "jwt_token_here"
}
```

**Response**:  
```json
{
  "status": "success",
  "access_token": "new_jwt_token",
  "data": [
    {
      "bookid": 1,
      "title": "Book Title",
      "authorid": 1
    }
  ]
}
```

---

### 12. Create Book-Author Relation

**Endpoint**: `/BooksAuthors`  
**Method**: `POST`  

**Request**:  
```json
{
  "book_id": 1,
  "author_id": 2,
  "token": "jwt_token_here"
}
```

**Response**:  
```json
{
  "status": "success",
  "access_token": "new_jwt_token",
  "data": null
}
```

---

### 13. Get All Book-Author Relations

**Endpoint**: `/BooksAuthors/Get`  
**Method**: `GET`  

**Request**:  
```json
{
  "token": "jwt_token_here"
}
```

**Response**:  
```json
{
  "status": "success",
  "access_token": "new_jwt_token",
  "data": [
    {
      "collectionid": 1,
      "bookid": 1,
      "authorid": 2
    }
  ]
}
```

---

### 14. Delete Book-Author Relation

**Endpoint**: `/BooksAuthors/Delete/{id}`  
**Method**: `DELETE`  

**Request**:  
```json
{
  "token": "jwt_token_here"
}
```

**Response**:  
```json
{
  "status": "success",
  "access_token": "new_jwt_token",
  "data": null
}
```

### Error Response when Token already used

**Failure Response:**  
```json
{
  "status": "fail",
  "access_token": null,
  "message": "Token already used"
}
```

---

### Notes

1. All endpoints require a valid JWT token in the request body for authentication.
2. Tokens are refreshed after each request to ensure secure interactions.
3. Expired tokens are automatically removed from the database.

### Project Information
This project is developed as part of a midterm requirement for the ITPC 115(System Integration and Architecture) subject, showcasing the ability to build secure API endpoints and manage tokens effectively.

### Contact Information
If you need assistance or have any questions, feel free to reach out to me. Below are my contact details:

- Name: Kenneth Denver Ringor
- University: Don Mariano Marcos Memorial State University (Mid-La Union Campus)
- Email: kringor20722@student.dmmmsu.edu.ph
- Phone: 09695878499


