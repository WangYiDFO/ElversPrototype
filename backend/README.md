nodejs-resource-server: Node.js Resource Server
===================================================

Level: Beginner  
Technologies: Node.js  
Summary: Node.js Service  
Target Product: <span>Keycloak</span>

What is it?
-----------

This quickstart demonstrates how to write a RESTful service with Node.js that is secured with <span>Keycloak</span>.

There are 3 endpoints exposed by the service:

* `public` - requires no authentication
* `regular` - can be invoked by users with any logged in user
* `actorrole` - can be invoked by users with the `actor` role

The endpoints are very simple and will only return a simple message stating what endpoint was invoked.

System Requirements
-------------------

To compile and run this quickstart you will need:

* Node.js 18.16.0+
* Keycloak 21+

Starting and Configuring the Keycloak Server
-------------------

To start a Keycloak Server you can use OpenJDK on Bare Metal, Docker, Openshift or any other option described in [Keycloak Getting Started guides]https://www.keycloak.org/guides#getting-started. For example when using Docker just run the following command in the root directory of this quickstart:

```shell
docker run --name keycloak \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  --network=host \
  quay.io/keycloak/keycloak:{KC_VERSION} \
  start-dev \
  --http-port=8180
```

where `KC_VERSION` should be set to 21.0.0 or higher.

You should be able to access your Keycloak Server at http://localhost:8180.

Log in as the admin user to access the Keycloak Administration Console. Username should be `admin` and password `admin`.

Build and Deploy the Quickstart
-------------------------------

1. Open a terminal and navigate to the root directory of this quickstart.

2. The following shows the command to run the quickstart:

   ````
   npm install
   npm start
   ````

Access the Quickstart
---------------------

There are 3 endpoints exposed by the service:

* http://localhost:3000/public - requires no authentication
* http://localhost:3000/regular - can be invoked by users with any logged-in user
* http://localhost:3000/actorrole - can be invoked by users with the `actor` role

You can open the public endpoint directly in the browser to test the service. The two other endpoints are protected and require
invoking them with a bearer token.

To invoke the protected endpoints using a bearer token, your client needs to obtain an OAuth2 access token from a Keycloak server.
In this example, we are going to obtain tokens using the front end Flutter Web.

References
--------------------

* [Keycloak Node.js Adapter](https://www.keycloak.org/docs/latest/securing_apps/#_nodejs_adapter)
* [Keycloak Documentation](https://www.keycloak.org/documentation)