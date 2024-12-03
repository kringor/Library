<?php
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

require '../src/vendor/autoload.php';
$app = new \Slim\App;

// Database connection details
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "library";
$port = 3308;

// Function to generate a new access token
function generateAccessToken() {
    $key = 'server_hack';
    $iat = time(); // Current timestamp
    $exp = $iat + 3600; // Token expiration time, 1 hour later

    // JWT payload
    $payload = [
        'iss' => 'http://library.org',
        'aud' => 'http://library.com',
        'iat' => $iat,
        'exp' => $exp,
    ];

    // Generate token using HS256
    return [
        'token' => JWT::encode($payload, $key, 'HS256'),
        'iat' => $iat,
        'exp' => $exp,
    ];
}

// Function to store tokens in the database along with iat and exp
function storeToken($tokenData) {
    $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
    $sql = "INSERT INTO jwt_tokens (token, iat, exp, used, created_at) VALUES (:token, :iat, :exp, 0, NOW())";
    $stmt = $conn->prepare($sql);
    $stmt->execute([
        ':token' => $tokenData['token'],
        ':iat' => $tokenData['iat'],
        ':exp' => $tokenData['exp'],
    ]);
}


// Function to delete expired tokens
function deleteExpiredTokens() {
    $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
    $sql = "DELETE FROM jwt_tokens WHERE created_at < NOW() - INTERVAL 1 DAY";
    $stmt = $conn->prepare($sql);
    $stmt->execute();
}

// Validate token middleware
function validateToken($request, $response, $next) {
    deleteExpiredTokens();

    $data = json_decode($request->getBody(), true);
    if (!isset($data['token'])) {
        return $response->withStatus(401)->write(json_encode([
            "status" => "fail", 
            "access_token" => null, 
            "message" => "Token missing"
        ]));
    }

    $token = $data['token'];
    $key = 'server_hack';

    try {
        // Decode the token
        $decoded = JWT::decode($token, new Key($key, 'HS256'));

        // Get token info from the database
        $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
        $sql = "SELECT used, exp FROM jwt_tokens WHERE token = :token";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':token' => $token]);
        $tokenData = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$tokenData) {
            return $response->withStatus(401)->write(json_encode([
                "status" => "fail", 
                "access_token" => null, 
                "message" => "Token not found"
            ]));
        }

        if ($tokenData['used'] == 1) {
            return $response->withStatus(401)->write(json_encode([
                "status" => "fail", 
                "access_token" => null, 
                "message" => "Token already used"
            ]));
        }

        // Check if the token has expired using the stored exp value
        if ($tokenData['exp'] < time()) {
            return $response->withStatus(401)->write(json_encode([
                "status" => "fail", 
                "access_token" => null, 
                "message" => "Token expired"
            ]));
        }

    } catch (Exception $e) {
        return $response->withStatus(401)->write(json_encode([
            "status" => "fail", 
            "access_token" => null, 
            "message" => "Unauthorized"
        ]));
    }

    return $next($request, $response);
}


// Function to mark the token as used
function markTokenAsUsed($token) {
    $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
    $sql = "UPDATE jwt_tokens SET used = 1 WHERE token = :token";
    $stmt = $conn->prepare($sql);
    $stmt->execute([':token' => $token]);
}

// Respond with new access token
function respondWithNewAccessToken(Response $response) {
    $newAccessToken = generateAccessToken();
    storeToken($newAccessToken);
    return $response->withHeader('New-Access-Token', $newAccessToken['token']);
}

// Register a new user
$app->post('/user/register', function (Request $request, Response $response) use ($servername, $username, $password, $dbname, $port) {
    $data = json_decode($request->getBody());
    $uname = $data->username;
    $pass = $data->password;

    try {
        $conn = new PDO("mysql:host=$servername;port=$port;dbname=$dbname", $username, $password);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $hashedPassword = password_hash($pass, PASSWORD_BCRYPT);
        $sql = "INSERT INTO users (username, password) VALUES (:uname, :pass)";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':uname' => $uname, ':pass' => $hashedPassword]);
        $response->getBody()->write(json_encode(["status" => "success", "access_token" => null, "data" => null]));
    } catch (PDOException $e) {
        $response->getBody()->write(json_encode([
            "status" => "fail", 
            "access_token" => null, 
            "data" => ["title" => $e->getMessage()]
        ]));
    }

    $conn = null;
    return $response;
});

// Authenticate user and generate access token
$app->post('/user/authenticate', function (Request $request, Response $response) use ($servername, $username, $password, $dbname, $port) {
    $data = json_decode($request->getBody());
    $uname = $data->username;
    $pass = $data->password;

    try {
        // Database connection
        $conn = new PDO("mysql:host=$servername;port=$port;dbname=$dbname", $username, $password);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // Query to fetch user data
        $sql = "SELECT * FROM users WHERE username = :uname";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':uname' => $uname]);
        $stmt->setFetchMode(PDO::FETCH_ASSOC);
        $userData = $stmt->fetch();

        // If user exists and password is correct
        if ($userData && password_verify($pass, $userData['password'])) {
            
            // Generate JWT token (with iat and exp)
            $tokenData = generateAccessToken(); // Should return token, iat, exp

            // Store the token details in the database
            storeToken($tokenData, $conn);

            // Respond with token and success message
            $response->getBody()->write(json_encode([
                "status" => "success", 
                "access_token" => $tokenData['token'],  // Send token in response
                "data" => null
            ]));
        } else {
            // Failed authentication
            $response->getBody()->write(json_encode([
                "status" => "fail", 
                "access_token" => null, 
                "data" => ["title" => "Authentication Failed"]
            ]));
        }

    } catch (PDOException $e) {
        // Error handling for DB exceptions
        $response->getBody()->write(json_encode([
            "status" => "fail", 
            "access_token" => null, 
            "data" => ["title" => $e->getMessage()]
        ]));
    }

    $conn = null;
    return $response;
});



// CRUD operations for authors
$app->group('/authors', function () use ($app) {
    // Create author
    $app->post('/Create', function (Request $request, Response $response) {
        $data = json_decode($request->getBody(), true);
        $name = $data['name'];
        $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
        $sql = "INSERT INTO authors (name) VALUES (:name)";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':name' => $name]);

        markTokenAsUsed($data['token']);
        $response = respondWithNewAccessToken($response);
        $response->getBody()->write(json_encode(["status" => "success", "access_token" => $response->getHeader('New-Access-Token')[0], "data" => null]));
        return $response;
    })->add('validateToken');

    // Get all authors
    $app->get('/Get', function (Request $request, Response $response) {
        $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
        $stmt = $conn->query("SELECT * FROM authors");
        $authors = $stmt->fetchAll(PDO::FETCH_ASSOC);

        markTokenAsUsed($request->getParsedBody()['token']);
        $response = respondWithNewAccessToken($response);
        $response->getBody()->write(json_encode(["status" => "success", "access_token" => $response->getHeader('New-Access-Token')[0], "data" => $authors]));
        return $response;
    })->add('validateToken');

    // Update author
    $app->put('/Update/{id}', function (Request $request, Response $response, array $args) {
        $data = json_decode($request->getBody(), true);
        $id = $args['id'];
        $name = $data['name'];
        $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
        $sql = "UPDATE authors SET name = :name WHERE authorid = :id";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':name' => $name, ':id' => $id]);

        markTokenAsUsed($data['token']);
        $response = respondWithNewAccessToken($response);
        $response->getBody()->write(json_encode(["status" => "success", "access_token" => $response->getHeader('New-Access-Token')[0], "data" => null]));
        return $response;
    })->add('validateToken');

    // Delete author
    $app->delete('/Delete/{id}', function (Request $request, Response $response, array $args) {
        $data = $request->getParsedBody();
        $id = $args['id'];

        $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
        $sql = "DELETE FROM authors WHERE authorid = :id";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':id' => $id]);

        markTokenAsUsed($data['token']);
        $response = respondWithNewAccessToken($response);
        $response->getBody()->write(json_encode(["status" => "success", "access_token" => $response->getHeader('New-Access-Token')[0], "data" => null]));
        return $response;
    })->add('validateToken');
});


// CRUD operations for Books
$app->group('/books', function () use ($app) {

    // Create Book
    $app->post('/Create', function (Request $request, Response $response) {
        $data = json_decode($request->getBody(), true);
        $title = $data['title'];
        $author_id = $data['author_id'];

        $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
        $sql = "INSERT INTO books (title, authorid) VALUES (:title, :authorid)";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':title' => $title, ':authorid' => $author_id]);

        markTokenAsUsed($data['token']);
        $response = respondWithNewAccessToken($response);
        $response->getBody()->write(json_encode(["status" => "success", "access_token" => $response->getHeader('New-Access-Token')[0], "data" => null]));
        return $response;
    })->add('validateToken');

    // Get All Books
    $app->get('/Get', function (Request $request, Response $response) {
        $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
        $stmt = $conn->query("SELECT * FROM books");
        $books = $stmt->fetchAll(PDO::FETCH_ASSOC);

        markTokenAsUsed($request->getParsedBody()['token']);
        $response = respondWithNewAccessToken($response);
        $response->getBody()->write(json_encode(["status" => "success", "access_token" => $response->getHeader('New-Access-Token')[0], "data" => $books]));
        return $response;
    })->add('validateToken');

    // Update Book
    $app->put('/Update/{id}', function (Request $request, Response $response, array $args) {
        $data = json_decode($request->getBody(), true);
        $id = $args['id'];
        $title = $data['title'];
        $author_id = $data['author_id'];

        $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
        $sql = "UPDATE books SET title = :title, authorid = :authorid WHERE bookid = :id";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':title' => $title, ':authorid' => $author_id, ':id' => $id]);

        markTokenAsUsed($data['token']);
        $response = respondWithNewAccessToken($response);
        $response->getBody()->write(json_encode(["status" => "success", "access_token" => $response->getHeader('New-Access-Token')[0], "data" => null]));
        return $response;
    })->add('validateToken');

    // Delete Book
    $app->delete('/Delete/{id}', function (Request $request, Response $response, array $args) {
        $id = $args['id'];

        $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
        $sql = "DELETE FROM books WHERE bookid = :id";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':id' => $id]);

        markTokenAsUsed($request->getParsedBody()['token']);
        $response = respondWithNewAccessToken($response);
        $response->getBody()->write(json_encode(["status" => "success", "access_token" => $response->getHeader('New-Access-Token')[0], "data" => null]));
        return $response;
    })->add('validateToken');

});

// Get Books by Author ID
$app->get('/books/GetByAuthorId', function (Request $request, Response $response) {
    $data = json_decode($request->getBody(), true);
    $author_id = $data['author_id'];

    // Validate that author_id is provided
    if (empty($author_id)) {
        return $response->withStatus(400)->write(json_encode(["status" => "fail", "access_token" => null, "message" => "author_id is required"]));
    }

    try {
        $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
        $sql = "SELECT * FROM books WHERE authorid = :authorid";
        $stmt = $conn->prepare($sql);
        $stmt->execute([':authorid' => $author_id]);
        $books = $stmt->fetchAll(PDO::FETCH_ASSOC);

        // Mark the old token as used
        markTokenAsUsed($request->getParsedBody()['token']); // Pass the token from the request

        // Respond with a new access token
        $response = respondWithNewAccessToken($response);
        $response->getBody()->write(json_encode(["status" => "success", "access_token" => $response->getHeader('New-Access-Token')[0], "data" => $books]));
    } catch (PDOException $e) {
        $response->getBody()->write(json_encode(["status" => "fail", "access_token" => null, "data" => ["title" => $e->getMessage()]]));
    }

    return $response;
})->add('validateToken');

// Create Book-Author Relations
$app->post('/BooksAuthors', function (Request $request, Response $response) {
    $data = json_decode($request->getBody(), true);
    $book_id = $data['book_id'];
    $author_id = $data['author_id'];

    $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
    $sql = "INSERT INTO books_authors (bookid, authorid) VALUES (:bookid, :authorid)";
    $stmt = $conn->prepare($sql);
    $stmt->execute([':bookid' => $book_id, ':authorid' => $author_id]);

    // Mark the old token as used
    markTokenAsUsed($data['token']); // Pass the token from the request

    // Respond with a new access token
    $response = respondWithNewAccessToken($response);
    $response->getBody()->write(json_encode(["status" => "success", "access_token" => $response->getHeader('New-Access-Token')[0], "data" => null]));
    return $response;
})->add('validateToken');

// Get All Book-Author Relations
$app->get('/BooksAuthors/Get', function (Request $request, Response $response) {
    $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
    $stmt = $conn->query("SELECT * FROM books_authors");
    $relations = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Mark the old token as used
    markTokenAsUsed($request->getParsedBody()['token']); // Pass the token from the request

    // Respond with a new access token
    $response = respondWithNewAccessToken($response);
    $response->getBody()->write(json_encode(["status" => "success", "access_token" => $response->getHeader('New-Access-Token')[0], "data" => $relations]));
    return $response;
})->add('validateToken');

// Delete Book-Author Relations
$app->delete('/BooksAuthors/Delete/{id}', function (Request $request, Response $response, array $args) {
    $id = $args['id'];

    $conn = new PDO("mysql:host=localhost;port=3308;dbname=library", "root", "");
    $sql = "DELETE FROM books_authors WHERE collectionid = :id";
    $stmt = $conn->prepare($sql);
    $stmt->execute([':id' => $id]);

    // Mark the old token as used
    markTokenAsUsed($request->getParsedBody()['token']); // Pass the token from the request

    // Respond with a new access token
    $response = respondWithNewAccessToken($response);
    $response->getBody()->write(json_encode(["status" => "success", "access_token" => $response->getHeader('New-Access-Token')[0], "data" => null]));
    return $response;
})->add('validateToken');

$app->run();
