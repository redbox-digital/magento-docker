# Redbox Docker

A "batteries not included" best practice development environment for Magento 2,
based on Docker.

## Installation

1. Download a tarball of the latest release, and extract it somewhere.
2. Clone your project into a directory called `src`: `git clone <project url>
src`
3. Obtain an `env.php`, and a `config.php` from somewhere, and drop them into
`src/app/etc/`.
4. Start your engines: `docker-compose up -d`
5. Install your project. To run commands in the docker environment, please use
the `rd` utility provided. For example: `./bin/rd run composer install`.

You should now be up and running.

## What's Included

When we say "batteries not included", we mean that there is nothing here to
scaffold a Magento installation. Redbox Docker merely contains a good server
environment, and we leave installation to you.

An installation of Redbox Docker is quite small, and doesn't contain an awful
lot. In fact, this is it:

```
redbox-docker
├── .gitignore
├── bin
│   └── rd
├── docker-compose.yml
└── servers
    ├── appserver
    │   └── etc
    │       └── php.ini
    └── webserver
        └── etc
            └── nginx.conf
```

Beyond the `docker-compose.yml` file, we have the following:

+ `bin/rd`: This is a utility that allows you to manage your Magento
installation from outside your containers.
+ `servers/`: We include volume mappings for some configuration files, since
these are commonly customised on a project by project basis. For example, if you
need to add multi-site functionality, you might amend your `nginx.conf` file to
handle this.

## OS Support

We built this to run on Linux. We are pretty sure that it should run on Docker
for Mac, or Docker for Windows, but we haven't tested, and it's likely you will
suffer from poor volume performance.

## Permissions

### tl;dr

```
./bin/rd fix-permissions
```

Docker can be fiddly about permissions. If you encounter troubles such as not
being able to write logs, or save media, we can help.

Since these containers (with the exception of `messagequeue` and `mail`) run on
Alpine Linux, the UIDs are different. The two containers that access files
(`webserver` and `appserver`) both run as `www-data:www-data`. In Alpine, these
names correspond to `82:82`. So you need to make sure that a user running with
those permissions has read and write to your project.

This can be achieved by setting the group to `82` on your host, and then making
sure that the group has read permissions on everything, and write permissions
where it needs them. Further, if you set the sticky flag on group permissions,
all new files will be created with the correct group.

It is important that your host user retain ownership of the files, so that you
can always read from and write to whatever you choose.
