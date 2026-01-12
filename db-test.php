<?php
try {
    $pdo = new PDO(
        "mysql:unix_socket=/run/mysqld/mysqld.sock;dbname=laravel_development_db", 
        "admin_user", 
        "your_secure_password"
    );
    echo "✅ SUCCESS: PHP connected to MariaDB via Socket!\n";
} catch (PDOException $e) {
    echo "❌ ERROR: " . $e->getMessage() . "\n";
}
?>
