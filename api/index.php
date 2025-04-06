<?php
// Show detailed errors during deployment setup
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Support Vercel serverless environment
$_SERVER['SCRIPT_NAME'] = '/index.php';

// Print environment information for debugging
if (isset($_GET['phpinfo'])) {
    phpinfo();
    exit;
}

// Try to create storage symlink for uploads
if (!file_exists(__DIR__ . '/../public/storage') && function_exists('symlink')) {
    try {
        if (file_exists(__DIR__ . '/../storage/app/public')) {
            @symlink(__DIR__ . '/../storage/app/public', __DIR__ . '/../public/storage');
        }
    } catch (Exception $e) {
        // Silent fail - continue anyway
    }
}

// Load Laravel application
try {
    require __DIR__ . '/../public/index.php';
} catch (Exception $e) {
    // Show a user-friendly error
    http_response_code(500);
    echo "<h1>Server Error</h1>";
    echo "<p>The application could not be loaded.</p>";
    
    // Only show detailed errors if debug mode is enabled
    if (getenv('APP_DEBUG') === 'true') {
        echo "<h2>Error Details:</h2>";
        echo "<pre>" . htmlspecialchars($e->getMessage()) . "</pre>";
    }
    
    // Log the error
    error_log('Laravel Error: ' . $e->getMessage());
}
