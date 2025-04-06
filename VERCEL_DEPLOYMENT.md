# Deploying Laravel to Vercel

This guide explains how to deploy your Laravel application to [Vercel](https://vercel.com/), a platform optimized for frontend frameworks and serverless functions.

## Benefits of Vercel

-   **Zero Configuration**: Deploy with minimal setup
-   **Global CDN**: Edge network for fast content delivery
-   **Automatic HTTPS**: SSL certificates provided automatically
-   **Serverless Functions**: Scale automatically with demand
-   **Preview Deployments**: Each pull request gets its own preview environment

## Prerequisites

1. A Vercel account (sign up at [vercel.com](https://vercel.com/signup))
2. Your code pushed to a Git repository (GitHub, GitLab, or Bitbucket)

## Quick Deployment

The quickest way to deploy is using our helper script:

```bash
./deploy-to-vercel.sh
```

This script will guide you through the deployment process and automatically create required files if they're missing.

## Manual Deployment Steps

### 1. Setup Vercel CLI (Optional)

You can deploy directly from the Vercel web interface, but using the CLI offers more control:

```bash
npm install -g vercel
vercel login
```

### 2. Project Configuration

This project has been configured for Vercel with:

-   A `vercel.json` file for deployment configuration
-   An `api/index.php` file as the entry point
-   A custom `vercel-build.sh` script to handle building Laravel
-   Optimized environment variables in `.env.example`

**Important Note**: In `vercel.json`, we set `"framework": null` since Laravel is not a native Vercel framework. Attempting to use `"framework": "laravel"` will result in a deployment error.

### 3. Custom Build Script

We use a custom build script (`vercel-build.sh`) that:

1. Downloads and installs Composer during the build process
2. Installs PHP dependencies with Composer
3. Clears Laravel caches
4. Installs NPM dependencies and builds assets
5. Sets up the storage link

This approach solves the common "composer: command not found" error that occurs when deploying Laravel to Vercel.

### 4. Deployment Options

#### Option 1: Using Vercel CLI

From your project directory, run:

```bash
vercel
```

To deploy to production:

```bash
vercel --prod
```

#### Option 2: Using Vercel Web Interface

1. Go to [vercel.com/new](https://vercel.com/new)
2. Import your Git repository
3. Configure project settings
4. Deploy

### 5. Environment Variables

Set up your environment variables in the Vercel dashboard:

1. Go to your project in the Vercel dashboard
2. Navigate to "Settings" > "Environment Variables"
3. Add your variables (database credentials, API keys, etc.)

**Essential Environment Variables**:

-   `APP_KEY`: Your Laravel application key (generate with `php artisan key:generate --show`)
-   `DB_*`: Database connection details
-   `AWS_*`: S3 storage configuration (if using file uploads)

## Database Configuration

Vercel doesn't provide database hosting, so you'll need to use an external database service:

### Recommended Providers:

-   **MySQL**: [PlanetScale](https://planetscale.com/) (serverless MySQL)
-   **PostgreSQL**: [Neon](https://neon.tech/) (serverless Postgres)
-   **MongoDB**: [MongoDB Atlas](https://www.mongodb.com/atlas/database)

Make sure to update your environment variables with your database connection details.

## File Storage

Since Vercel deployments are ephemeral (stateless), you need to use external storage for:

-   User uploads
-   Generated files
-   Any data that needs to persist between deployments

Recommended: Set up an S3-compatible storage provider like AWS S3, Cloudflare R2, or DigitalOcean Spaces.

Configure your Vercel environment variables with:

```
FILESYSTEM_DISK=s3
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
AWS_DEFAULT_REGION=your-region
AWS_BUCKET=your-bucket
AWS_URL=your-url
```

## Limitations and Workarounds

### Background Tasks

Vercel doesn't support long-running processes like Laravel queue workers or schedulers. For these, use:

-   [Laravel Forge](https://forge.laravel.com/) for managing separate queue servers
-   [Cronhooks](https://cronhooks.io/) or similar for scheduled tasks

### Cache Configuration

Vercel functions are stateless, so file-based caching won't persist. Use:

-   Redis cache driver (via [Upstash](https://upstash.com/))
-   Database cache driver (for smaller applications)
-   Set `CACHE_DRIVER=array` for simple applications (default in our configuration)

## Troubleshooting

### Common Issues:

1. **"composer: command not found" Error**:

    - This is addressed in our setup by using a custom build script (`vercel-build.sh`) that installs Composer before using it.
    - If you're still seeing this error, make sure your repository includes the `vercel-build.sh` script and it's set to executable (`chmod +x vercel-build.sh`).

2. **"Framework should be equal to one of the allowed values" Error**:

    - Make sure your `vercel.json` has `"framework": null` instead of `"framework": "laravel"`.
    - Laravel is not in Vercel's list of supported frameworks, so we use a custom configuration.

3. **Deployment Fails**:

    - Check that the PHP version in `vercel-php@0.6.0` runtime is compatible with your Laravel version.
    - Ensure your build script completes successfully.
    - Check the build logs in the Vercel dashboard for specific errors.

4. **Missing Assets**:

    - Ensure your assets are being built correctly with `npm run build`.
    - Check that your routes in `vercel.json` correctly map to your asset directories.

5. **Database Connection Issues**:

    - Verify your database credentials in the Vercel environment variables.
    - Ensure your database provider allows connections from Vercel's IP ranges.

6. **500 Errors After Deployment**:
    - Check Vercel logs in the dashboard.
    - Temporarily set `APP_DEBUG=true` in environment variables to see detailed error messages.

## Resources

-   [Vercel Documentation](https://vercel.com/docs)
-   [Laravel Documentation](https://laravel.com/docs)
-   [Vercel CLI Reference](https://vercel.com/docs/cli)
-   [Vercel + Laravel Guide](https://vercel.com/guides/deploying-laravel-with-vercel)
