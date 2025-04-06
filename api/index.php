<?php
// Support Vercel serverless environment
$_SERVER['SCRIPT_NAME'] = '/' . basename(__FILE__);

// Create a storage symlink if it doesn't exist
if (isset($_SERVER['APP_ENV']) && $_SERVER['APP_ENV'] === 'production') {
    if (!file_exists(__DIR__ . '/../public/storage') && file_exists(__DIR__ . '/../storage/app/public')) {
        symlink(__DIR__ . '/../storage/app/public', __DIR__ . '/../public/storage');
    }
}

// Load Laravel application
require __DIR__ . '/../public/index.php';
