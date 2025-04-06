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

This script will guide you through the deployment process.

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
-   Optimized environment variables in `.env.example`

### 3. Deployment Options

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

### 4. Environment Variables

Set up your environment variables in the Vercel dashboard:

1. Go to your project in the Vercel dashboard
2. Navigate to "Settings" > "Environment Variables"
3. Add your variables (database credentials, API keys, etc.)

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

Configure your `.env` file with:

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
-   Set `CACHE_DRIVER=array` for simple applications

## Troubleshooting

### Common Issues:

1. **Deployment Fails**: Check for any Laravel-specific configurations that assume a traditional server setup.

2. **Missing Assets**: Ensure your assets are being built correctly with `npm run build`.

3. **Database Connection Issues**: Verify your database credentials and ensure your database provider allows connections from Vercel's IP ranges.

## Resources

-   [Vercel Documentation](https://vercel.com/docs)
-   [Laravel Documentation](https://laravel.com/docs)
-   [Vercel CLI Reference](https://vercel.com/docs/cli)
-   [Vercel + Laravel Guide](https://vercel.com/guides/deploying-laravel-with-vercel)
