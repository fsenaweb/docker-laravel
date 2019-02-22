# Docker Laravel
Dockerize a Laravel App with a single command.

## Setup
Install Laravel App (or push with a laravel container):
``` bash
$ composer create-project --prefer-dist laravel/laravel <app-name>
```
Clone the repository on your laravel path:
``` bash
$ git clone https://github.com/fsenaweb/docker-laravel.git
```

Move the files in docker-laravel directory to Laravel path:
``` bash
$ cd docker-laravel && mv * ../ && cd .. && rm -rf docker-laravel
```

Next run the **docker-compose** command:
``` bash
$ docker-compose up -d
```

First, this command will build the containers. Then it will install all the necessary dependencies and start the development server. 
The development environment will be available on either *http://localhost:8000* (or in other port that you will configure). 
You can on your Docker Machine IP (*http://192.168.99.100* by default) depending on your operating system.
For access in PHPMyAdmin, will be availabe in *http://localhost:8080* and use the credencials in docker-compose.yml .

## Usage

### Starting the development server
After using the `docker-compose up -d` command, just simply access the page at `localhost: 8000` and use the start using your application.

### Other commands
* Execute a container: `docker exec -it {CONTAINER_ID} bash`

## Contribute
Make your contribution. If you're interested, send a pull request of your code and we'll help you have access to a simple system and help small developers manage their containers more easily.
