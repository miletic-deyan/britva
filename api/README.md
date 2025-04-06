# API Directory for Vercel Deployment

This directory contains the serverless functions entry point for the Laravel application when deployed to Vercel.

## Files

-   `index.php` - The main entry point for all HTTP requests. This file forwards requests to the Laravel application's public/index.php file.

## How it Works

Vercel uses the `api` directory for serverless functions. When a request is made to your Vercel-deployed Laravel application, it routes through:

1. Vercel routing (defined in vercel.json)
2. api/index.php (this directory)
3. public/index.php (Laravel's standard entry point)
4. Laravel's routing system

## Customization

If you need to add custom Vercel-specific logic before the Laravel application handles the request, you can modify the index.php file in this directory.

## More Information

For more details on how Laravel works with Vercel, refer to the [VERCEL_DEPLOYMENT.md](../VERCEL_DEPLOYMENT.md) file in the root directory.
