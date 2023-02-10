cp .env.example .env in the root of the project and change the database details here and also in your own app.

For vite: docker-compose run --rm --service-ports npm run dev -- --host

Aliases: nano .bashrc

- alias dc='docker-compose'
- alias dcu='dc up app -d'
- alias dcd='dc down'
- alias art='dc run --rm artisan'
- alias artm='art migrate'
- alias np='dc run --rm npm'
- alias npi='np install'
- alias npb='np --service-ports run build
- alias npd='np --service-ports npm run dev -- --host'
- alias com='dc run --rm composer'

Examples:

- _dcu_ (start the app containers detached)
- _dcd_ (stop all containers)
- _dc up -d_ (start all containers detached)
- _npi_ (npm install in docker)
- _artm_ (migrate database)
- _npd_ (npm run dev)
- _npb_ (npm run build)
- _art <anything>_ (run any artisan command)
- _np <anything>_ (run any npm command)
- _com <anything>_ (run any composer command)

# docker-compose-laravel
A pretty simplified Docker Compose workflow that sets up a LEMP network of containers for local Laravel development. You can view the full article that inspired this repo [here](https://dev.to/aschmelyun/the-beauty-of-docker-for-local-laravel-development-13c0).

## Usage

To get started, make sure you have [Docker installed](https://docs.docker.com/docker-for-mac/install/) on your system, and then clone this repository.

Next, navigate in your terminal to the directory you cloned this, and spin up the containers for the web server by running `docker-compose up -d --build app`.

After that completes, follow the steps from the [src/README.md](src/README.md) file to get your Laravel project added in (or create a new blank one).

**Note**: Your MySQL database host name should be `mysql`, **not** `localhost`. The username and database should both be `homestead` with a password of `secret`.

Bringing up the Docker Compose network with `app` instead of just using `up`, ensures that only our site's containers are brought up at the start, instead of all of the command containers as well. The following are built for our web server, with their exposed ports detailed:

- **nginx** - `:80`
- **mysql** - `:3306`
- **php** - `:9000`
- **redis** - `:6379`
- **mailhog** - `:8025`

Three additional containers are included that handle Composer, NPM, and Artisan commands *without* having to have these platforms installed on your local computer. Use the following command examples from your project root, modifying them to fit your particular use case.

- `docker-compose run --rm composer update`
- `docker-compose run --rm npm run dev`
- `docker-compose run --rm artisan migrate`

## Permissions Issues

If you encounter any issues with filesystem permissions while visiting your application or running a container command, try completing one of the sets of steps below.

**If you are using your server or local environment as the root user:**

- Bring any container(s) down with `docker-compose down`
- Replace any instance of `php.dockerfile` in the docker-compose.yml file with `php.root.dockerfile`
- Re-build the containers by running `docker-compose build --no-cache`

**If you are using your server or local environment as a user that is not root:**

- Bring any container(s) down with `docker-compose down`
- In your terminal, run `export UID=$(id -u)` and then `export GID=$(id -g)`
- If you see any errors about readonly variables from the above step, you can ignore them and continue
- Re-build the containers by running `docker-compose build --no-cache`

Then, either bring back up your container network or re-run the command you were trying before, and see if that fixes it.

## Persistent MySQL Storage

By default, whenever you bring down the Docker network, your MySQL data will be removed after the containers are destroyed. If you would like to have persistent data that remains after bringing containers down and back up, do the following:

1. Create a `mysql` folder in the project root, alongside the `nginx` and `src` folders.
2. Under the mysql service in your `docker-compose.yml` file, add the following lines:

```
volumes:
  - ./mysql:/var/lib/mysql
```

## Usage in Production

While I originally created this template for local development, it's robust enough to be used in basic Laravel application deployments. The biggest recommendation would be to ensure that HTTPS is enabled by making additions to the `nginx/default.conf` file and utilizing something like [Let's Encrypt](https://hub.docker.com/r/linuxserver/letsencrypt) to produce an SSL certificate.

## Compiling Assets

This configuration should be able to compile assets with both [laravel mix](https://laravel-mix.com/) and [vite](https://vitejs.dev/). In order to get started, you first need to add ` --host 0.0.0.0` after the end of your relevant dev command in `package.json`. So for example, with a Laravel project using Vite, you should see:

```json
"scripts": {
"dev": "vite --host 0.0.0.0",
"build": "vite build"
},
```

Then, run the following commands to install your dependencies and start the dev server:

- `docker-compose run --rm npm install`
- `docker-compose run --rm --service-ports npm run dev`

After that, you should be able to use `@vite` directives to enable hot-module reloading on your local Laravel application.

Want to build for production? Simply run `docker-compose run --rm npm run build`.
