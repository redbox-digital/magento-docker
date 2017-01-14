# Redbox Docker

A "batteries not included" best practice development environment for Magento 2,
based on Docker.

## Installation

1. Download a tarball of the latest release, and extract it somewhere.
2. Clone your project into a directory called `src`: `git clone <project url>
src`
1. Obtain an `env.php`, and a `config.php` from somewhere, and drop them into
`src/app/etc/`.
1. Start your engines: `docker-compose up -d`
2. Install your project. To run commands in the docker environment, please use
the `rd` utility provided. For example: `./bin/rd run composer install`.

You should now be up and running. If you're not, then you are having fun and
games to get Magento up and running.

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

*  `bin/rd`: This is a utility that allows you to manage your Magento
installation from outside your containers.
* `servers/`: We include volume mappings for some configuration files, since
these are commonly customised on a project by project basis. For example, if you
need to add multi-site functionality, you might amend your `nginx.conf` file to
handle this.

## Containers

Redbox Docker comes with:

* Nginx
* PHP 7.0,
* Percona 5.6
* Redis (for cache and session back end)
* RabbitMQ, with a management interface.
* Mailcatcher, for receiving emails.

## Debugging

There are two app servers, both largely identical. Where they differ is that one
of them has Xdebug installed.

These two containers are named `appserver` and `appserver_debug` respectively.
You should switch to use that container if you need to debug. Having no Xdebug
installed on the container used most of the time saves you from the performance
penalty associated with Xdebug.

Switching is very easy. Simply send the Xdebug cookie with an IDE key of
`docker`, and the web server will intelligently route your request. Since
everything else is shared, this switch is totally transparent.

## OS Support

We built this to run on Linux. We are pretty sure that it should run on Docker
for Mac, or Docker for Windows, but we haven't tested, and it's likely you will
suffer from poor volume performance.

## `./bin/rd`

This utility is the management console for the Redbox Docker environment. It
comes with a few commands, but the most common of these is `run`

`./bin/rd run` allows you to run commands inside your Docker environment. For
example, you might want to run `composer install`, or `n98-magerun
setup:upgrade`.

The way this command actually works is by inserting a container into the Redbox
Docker network, running your command, and then gracefully removing itself. This
keeps your server containers lean and without all that administration junk.

The container that runs these commands is based on a custom console image.
Please check its documentation for a full list of installed utilities, and to
remind us of anything that was missed. 

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

Any commands run via `./bin/rd run [...]` will run with your host user id, and the group 82.

## Known Issues

- [ ] Alpine Linux does not support the `GLOB_BRACE` constant, which exposes
a notice in the glob utility in the version of `Zend\StdLib` that Magento
2 currently uses. This is fixed in the latest version, and we are petitioning
Magento to upgrade their dependencies.
- [ ] It is not yet possible to debug a console command. This is important for
debugging upgrade scripts, or cron tasks.
