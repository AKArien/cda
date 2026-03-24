# cda (backronym pending)

## Goals and use

This is a learning project for preparing a certification CDA (french acronym, Conception et Développement d’Applications).

The goal is to make a complete solution that allows an entity to know, within it’s perimeter, where people are and when. Note it does not aim to reliably count and locate every individual that steps into the monitored zones, such as could be used for a safety system such as within a fire response.

Then intent is to gather data on the flow of people moving for analysis by organisations. As such, it is directed for organisations that have a need for such data, presumably to better their services. It’s direct target audience is theme parks and malls, though there is no doubt other bodies could make use of it, such as within a warehouse to optimise the position and flow of workers and goods.

## Components

This repository holds general information and assets for the project, as well as the necessary documentation and files for deployment.

Every part of the project, as well as their technical documentation, can be found in their own repositories, found as submodules of this.

For a quick presentation of each of them :
- database : Contains the source code for the backend, database and api of the project.
- firmware : Contains the source code and files necessary for hardware construction of the micro-controllers that gather the data on premises.
- gateway : Contains the source code for communication between the micro-controllers and the main server.
- web-console : Contains the source code for the website through which a deployment is accessed and the data is consulted.

## Running

Clone this repository and the `database` and `web-console` submodules.

```bash
git clone https://github.com/AKArien/cda.git
git submodule update --init --recursive database
git submodule update --init web-console
```

For physical setup, follow the intructions specific to [the gateway setup](https://github.com/AKArien/cda-gateway/tree/main) and [the watchers setup](https://github.com/AKArien/cda-firmware/tree/main).

If you just want to see numbers flashing on your screen, you can instead run [the faker script]().

To start the backend and serve the frontend, populate your environment. There is an example in .env.example :

```
DB_PASS_ADMIN=very_secure_password # The password to the `postgres` user
REST_JWT_SECRET=remember_to_use_this_in_prod_this_is_important # The JWT secret to be used by postgREST for signing authentication
# « Account 0 » is a sort of admin, that has every right to the entities in the database. Used for granting initial accesses to others on their domains.
ACCOUNT_ZERO_NAME=admin
ACCOUNT_ZERO_PASS=omnipotent
```

Run the compose (here with podman, but should run fine with docker as well) :

```bash
podman-compose up
```

To refresh the frontend, restart the `web-builder` container, which will build the frontend bundle for the web server :

```bash
podman-compose start web-builder
```
