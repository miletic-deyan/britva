# Deploying to Laravel Cloud

This guide explains how to deploy your Laravel Docker application to [Laravel Cloud](https://cloud.laravel.com/), the official platform designed specifically for Laravel applications.

## Benefits of Laravel Cloud

-   **Quick Deployment**: Deploy in under 60 seconds
-   **Auto-scaling**: Automatically scales based on traffic
-   **Managed Resources**: One-click databases, caching, and storage
-   **Edge Network**: Global CDN and DDoS protection
-   **Zero Configuration**: Everything is optimized for Laravel out of the box

## Prerequisites

1. A Laravel Cloud account (sign up at [cloud.laravel.com](https://cloud.laravel.com/))
2. Your code pushed to a Git repository (GitHub, GitLab, or Bitbucket)

## Deployment Steps

### 1. Connect Your Git Repository

1. Log in to your Laravel Cloud account
2. Click "Get started" or "New Application"
3. Connect your Git provider (GitHub, GitLab, or Bitbucket)
4. Select your Laravel repository
5. Choose a name for your application

### 2. Configure Environment Variables

Some environment variables from your Docker setup may need to be added to Laravel Cloud:

1. Navigate to your application in Laravel Cloud
2. Go to "Settings" > "Environment Variables"
3. Add your custom environment variables

Important: Laravel Cloud will automatically inject database and cache connection details, so you don't need to configure those manually.

### 3. Setup Resources

Laravel Cloud lets you create resources with a single click:

1. **Database**: Choose between Serverless Postgres or bring your own
2. **Cache**: Laravel KV Store (Redis API-compatible)
3. **Object Storage**: For file uploads and assets

### 4. Configure Deployment Settings

1. Configure autoscaling options
2. Set up custom domains
3. Configure queue workers and schedulers

### 5. Deploy Your Application

1. Push to your connected Git branch, or
2. Manually trigger a deployment from the Laravel Cloud dashboard

## Moving from Docker to Laravel Cloud

### Database Migration

If you're using MySQL in Docker and want to move to Laravel Cloud's Postgres:

1. Export your MySQL data
2. Convert it for Postgres (you can use tools like [pgloader](https://pgloader.io/))
3. Import into your Laravel Cloud database

### Environment Variables

Update your `.env` to use the Laravel Cloud injected variables:

```
# Laravel Cloud automatically injects these variables
DB_CONNECTION=pgsql
DB_HOST=...
DB_PORT=...
DB_DATABASE=...
DB_USERNAME=...
DB_PASSWORD=...

REDIS_HOST=...
REDIS_PASSWORD=...
REDIS_PORT=...
```

### Queue Workers and Scheduled Tasks

Configure your queue workers in Laravel Cloud:

1. Go to your application's "Background Processes" section
2. Add commands like:
    - `php artisan queue:work`
    - `php artisan horizon` (if using Horizon)

For scheduled tasks, simply enable the Scheduler in Laravel Cloud.

## CI/CD with Laravel Cloud

Laravel Cloud provides automatic CI/CD:

1. Automated testing on every push
2. Automatic deployments on merge to specified branches
3. Preview environments for pull requests (on higher tier plans)

## Cost Management

Laravel Cloud offers cost-efficient options:

-   Hibernation for inactive applications
-   Autoscaling to match your traffic needs
-   Pay only for resources you use

## Additional Resources

-   [Laravel Cloud Documentation](https://cloud.laravel.com/docs)
-   [Laravel Cloud vs. Forge Comparison](https://cloud.laravel.com/docs/about/cloud-vs-forge)
-   [Laravel Cloud vs. Vapor Comparison](https://cloud.laravel.com/docs/about/cloud-vs-vapor)
