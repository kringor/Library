
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

5. Start the server:
   ```bash
   php -S localhost:8080 -t public
   ```

---

## API Endpoints

### 1. Get Books by Author ID

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

### 2. Create Book-Author Relation

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

### 3. Get All Book-Author Relations

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

### 4. Delete Book-Author Relation

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

---

### Notes

1. All endpoints require a valid JWT token in the request body for authentication.
2. Tokens are refreshed after each request to ensure secure interactions.
3. Expired tokens are automatically removed from the database.
