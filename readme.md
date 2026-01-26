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