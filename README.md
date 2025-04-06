<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

## About Laravel

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects, such as:

-   [Simple, fast routing engine](https://laravel.com/docs/routing).
-   [Powerful dependency injection container](https://laravel.com/docs/container).
-   Multiple back-ends for [session](https://laravel.com/docs/session) and [cache](https://laravel.com/docs/cache) storage.
-   Expressive, intuitive [database ORM](https://laravel.com/docs/eloquent).
-   Database agnostic [schema migrations](https://laravel.com/docs/migrations).
-   [Robust background job processing](https://laravel.com/docs/queues).
-   [Real-time event broadcasting](https://laravel.com/docs/broadcasting).

Laravel is accessible, powerful, and provides tools required for large, robust applications.

## Learning Laravel

Laravel has the most extensive and thorough [documentation](https://laravel.com/docs) and video tutorial library of all modern web application frameworks, making it a breeze to get started with the framework.

You may also try the [Laravel Bootcamp](https://bootcamp.laravel.com), where you will be guided through building a modern Laravel application from scratch.

If you don't feel like reading, [Laracasts](https://laracasts.com) can help. Laracasts contains thousands of video tutorials on a range of topics including Laravel, modern PHP, unit testing, and JavaScript. Boost your skills by digging into our comprehensive video library.

## Laravel Sponsors

We would like to extend our thanks to the following sponsors for funding Laravel development. If you are interested in becoming a sponsor, please visit the [Laravel Partners program](https://partners.laravel.com).

### Premium Partners

-   **[Vehikl](https://vehikl.com/)**
-   **[Tighten Co.](https://tighten.co)**
-   **[WebReinvent](https://webreinvent.com/)**
-   **[Kirschbaum Development Group](https://kirschbaumdevelopment.com)**
-   **[64 Robots](https://64robots.com)**
-   **[Curotec](https://www.curotec.com/services/technologies/laravel/)**
-   **[Cyber-Duck](https://cyber-duck.co.uk)**
-   **[DevSquad](https://devsquad.com/hire-laravel-developers)**
-   **[Jump24](https://jump24.co.uk)**
-   **[Redberry](https://redberry.international/laravel/)**
-   **[Active Logic](https://activelogic.com)**
-   **[byte5](https://byte5.de)**
-   **[OP.GG](https://op.gg)**

## Contributing

Thank you for considering contributing to the Laravel framework! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## Code of Conduct

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](https://laravel.com/docs/contributions#code-of-conduct).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

# Laravel Docker Environment

This repository contains a Docker-based environment for Laravel development. It includes:

-   PHP 8.2 FPM
-   Nginx web server
-   MySQL 8.0 database
-   Redis server
-   CI/CD with GitHub Actions
-   Conventional Commits linting
-   Vercel deployment support

## Requirements

-   Docker
-   Docker Compose
-   Node.js and npm (for commit linting)

## Setup Instructions

1. Clone this repository to your local machine.

2. Start the Docker containers:

    ```bash
    docker-compose up -d
    ```

3. Make the setup script executable:

    ```bash
    chmod +x setup.sh
    ```

4. Run the setup script to install Laravel:

    ```bash
    ./setup.sh
    ```

    This script will:

    - Create a new Laravel project in a temporary location
    - Copy the Laravel files to the main directory
    - Set the proper permissions
    - Generate an application key
    - Run the migrations

5. Install Node.js dependencies for commit linting:

    ```bash
    npm install
    ```

6. Access your Laravel application at [http://localhost:8000](http://localhost:8000)

## Docker Containers

The following containers are included:

-   **app**: PHP 8.2 FPM container where Laravel runs
-   **nginx**: Nginx web server
-   **db**: MySQL 8.0 database
-   **redis**: Redis server for caching

## Database Connection

The database can be accessed with the following credentials:

-   Host: `localhost`
-   Port: `3306`
-   Database: `laravel`
-   Username: `laravel`
-   Password: `secret`

You can change these credentials in the `.env` file.

## Running Laravel Commands

You can run Laravel Artisan commands by executing them within the app container:

```bash
docker-compose exec app php artisan <command>
```

For example:

```bash
docker-compose exec app php artisan make:controller UserController
```

## Composer Commands

Similarly, you can run Composer commands:

```bash
docker-compose exec app composer <command>
```

## CI/CD with GitHub Actions

This project includes GitHub Actions workflows for continuous integration and deployment:

-   **CI Workflow**: Runs tests, linting, and checks on every push and pull request.
-   **Commit Lint Workflow**: Ensures that commit messages follow the conventional commits format in pull requests.

## Deployment Options

### Vercel

This project is configured for easy deployment to Vercel, a platform optimized for frontend frameworks and serverless functions.

To deploy to Vercel:

1. Run the deployment helper script:

    ```bash
    ./deploy-to-vercel.sh
    ```

2. Follow the prompts to complete the deployment process

Benefits of Vercel:

-   Zero configuration deployment
-   Global CDN with automatic HTTPS
-   Preview deployments for pull requests
-   Serverless architecture that scales automatically

For detailed instructions, see [VERCEL_DEPLOYMENT.md](VERCEL_DEPLOYMENT.md)

### Laravel Cloud

For Laravel Cloud deployment, please refer to [LARAVEL_CLOUD_DEPLOYMENT.md](LARAVEL_CLOUD_DEPLOYMENT.md)

### Custom Deployment

For custom deployment options, you can use the included GitHub Actions CD workflow. See the [Custom Deployment](#required-secrets-for-custom-cd) section below.

#### Required Secrets for Custom CD

To enable the custom deployment workflow, you need to add the following secrets to your GitHub repository:

-   `DOCKER_HUB_USERNAME`: Your Docker Hub username
-   `DOCKER_HUB_TOKEN`: Your Docker Hub access token
-   `HOST`: The deployment server hostname or IP
-   `USERNAME`: The SSH username for the deployment server
-   `SSH_PRIVATE_KEY`: The SSH private key for connection
-   `PORT`: The SSH port (usually 22)

## Conventional Commits

This project enforces [Conventional Commits](https://www.conventionalcommits.org/) format for all commit messages. The format is:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

Where `type` is one of:

-   `feat`: A new feature
-   `fix`: A bug fix
-   `docs`: Documentation only changes
-   `style`: Changes that do not affect the meaning of the code
-   `refactor`: A code change that neither fixes a bug nor adds a feature
-   `perf`: A code change that improves performance
-   `test`: Adding missing tests or correcting existing tests
-   `build`: Changes that affect the build system or external dependencies
-   `ci`: Changes to CI configuration files and scripts
-   `chore`: Other changes that don't modify src or test files

You can use the following command to create a commit with a guided prompt:

```bash
npm run commit
```

## Troubleshooting

If you encounter any issues during setup or need to restart the process, you can use the included clean script:

```bash
chmod +x clean.sh
./clean.sh
```

This script will:

-   Stop all running containers
-   Remove all Laravel project files while preserving Docker configuration files
-   Allow you to start fresh with `docker-compose up -d` and `./setup.sh`

## Customization

You can customize the Docker environment by modifying the following files:

-   `docker-compose.yml`: Docker Compose configuration
-   `Dockerfile`: PHP container configuration
-   `docker/nginx/conf.d/app.conf`: Nginx configuration
-   `.env`: Environment variables
