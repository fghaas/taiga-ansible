# `taiga-ansible`

### [Ansible](https://www.ansible.com/) roles and playbooks to deploy [Taiga](https://taiga.io/)
	
This is a set of Ansible roles and example playbook that enable you to
deploy the Taiga project management platform to your own servers. It
is based on the recommendations given in the Taiga
[production environment setup guide](http://taigaio.github.io/taiga-doc/dist/setup-production.html).

## Prerequisites

The [setup
guide](http://taigaio.github.io/taiga-doc/dist/setup-production.html)
requires that all systems in your inventory run [Ubuntu 16.04 Xenial
Xerus](http://releases.ubuntu.com/16.04/). This is the only platform
where upstream expects everything to work. However, the roles in this
repository are also being used on [Ubuntu 18.04 Bionic
Beaver](http://releases.ubuntu.com/18.04/) systems, and should be
working fine there as well.

Your deploy host must be running at least Ansible 2.5. Since that
version is not included in Ubuntu Xenial, you can install Ansible
either
[from a PPA](https://launchpad.net/~ansible/+archive/ubuntu/ansible),
or
[using `pip`](http://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html?#latest-releases-via-pip).

## Roles

Taiga hosts are to be sorted into three different roles:

- `taiga-back`: Taiga backend node running the Taiga Django REST
  application (and optionally, asynchronous task processing via
  Celery). This node also runs PostgreSQL and, if needed, RabbitMQ and
  Redis.
  
- `taiga-front`: Frontend node running nginx and the Taiga AngularJS
  frontend application.

- `taiga-events`: Backend node running the Taiga events processing
  system. This role is optional.

It is perfectly acceptable to assign all three roles to the same host,
if needed.

The other defined roles, `taiga`, `taiga-node`, and `taiga-webserver`,
are auxiliary and should never be used directly. The `taiga-back`,
`taiga-front`, and `taiga-events` roles inherit from these as needed.

## Inventory

For a **single-node** installation where you install Taiga to the same
node as Ansible, your inventory file could look like this:

```ini
[taiga-back]
localhost ansible_connection=local

[taiga-front:children]
taiga-back

[taiga-events:children]
taiga-back
```

For a **multi-node** installation where all nodes are distinct from
the Ansible node, you could use an inventory like this:

```ini
[taiga-back]
taiga-backend.example.com

[taiga-front]
taiga.example.com

[taiga-events]
taiga-events.example.com
```

## Playbooks

An example playbook is provided in `taiga.yml`. It understands the
group names `taiga-back`, `taiga-front`, and `taiga-events`, and maps
them to the roles of the same name.

## Variables

Your inventory, vars file, or environment must always set the
following variable:

- `taiga_secret_key`: defines the secret key used by both the backend
  and the events processor.

You should set the following variables on the initial deployment run
only. It is recommended that you set these from the command line with
`ansible-playbook -e`:

- `taiga_back_load_initial_user_data`: if `true`, populates the
  database with initial user data.

- `taiga_back_load_initial_project_templates`: if `true`, populates
  the database with initial project templates.

Other variables that you might want to set include:

- `taiga_frontend_host`: defines the server name of your Taiga
  frontend. If unset, defaults to your `taiga-front` node’s FQDN.

- `taiga_enable_events`: enables the event processor. Note that adding
  the `taiga-events` role to a node merely installs the moving parts
  necessary to run the event processor, `taiga_enable_events: true` is
  required to activate it.

- `taiga_enable_async_tasks`: enables the backend’s asynchronous task
  queue based on Celery.

- `taiga_rabbitmq_password`: password used by the event processor and
  the backend’s Celery asynchronous task queue. Must be set if either
  `taiga_enable_events` or `taiga_enable_async_tasks` is set to
  `true`.

- `taiga_service_manager`: when set to `circus` (the default),
  installs the Circus service manager and runs Taiga-related services
  from there. When set to `systemd`, creates and enables systemd
  services for Taiga instead.

- `taiga_enable_ssl`: configures the web server for HTTPS, and the
  event processor (if enabled) for secure Websockets (WSS). Note that
  SSL is terminated on the frontend node; communications between the
  frontend node and the backend and event processor are
  unencrypted. Leaving `taiga_ssl_key` empty will create a self-signed
  certificate for test deployments.

- `taiga_back_version`, `taiga_front_version`, and
  `taiga_events_version`: defines the Git branch, tag, or commit you
  want to check out from the Taiga GitHub repository and
  install. Defaults to `stable` for `taiga_back_version` and
  `taiga_front_version`, and to `master` for `taiga_events_version`.

Several other variables can be overridden; for their defaults, please
see [variables.md](variables.md).

## Slack Support

To enable the Slack notification plugin, set `taiga_enable_slack` to
`true`.

## LDAP Authentication

To enable LDAP authentication support, set `taiga_enable_ldap_login`
to `true`, and set `taiga_ldap_*` variables to match your LDAP server
configuration. For details on supported variables, see
[variables.md](variables.md).

## SAML Authentication

To enable SAML authentication, set `taiga_enable_saml_login` to
`true`, and include your SAML configuration in the `taiga_saml_*`
dictionary variables. An example configuration for those variables is
given below:

```yaml
taiga_saml_sp_name_id_format: "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress" 
taiga_saml_idp_entity_id: "http://example.com/saml"
taiga_saml_idp_single_sign_on_url: "http://example.com/saml/sso"
taiga_saml_security:    # these are the defaults, to use them just omit this variable
  nameIdEncrypted:         false
  authnRequestsSigned:     false
  logoutRequestSigned:     false
  logoutResponseSigned:    false
  signMetadata:            false
  wantMessagesSigned:      false
  wantAssertionsSigned:    false
  wantNameId:              true
  wantAssertionsEncrypted: false
  wantNameIdEncrypted:     false
  wantAttributeStatement:  true
  requestedAuthnContext:   true
taiga_saml_contact_person:
  technical:
    givenName:     # name of your technical contact
    emailAddress:  # email address of your technical contact
  support:
    givenName:     # name of your support contact
    emailAddress:  # email address of your support contact
taiga_saml_mapping:  # map SAML users to Taiga users
  id: SAML_NAMEID
  attributes:
    email:     SAML_ATTRIBUTE_NAME_EMAIL
    username:  SAML_ATTRIBUTE_NAME_USERNAME
    full_name: SAML_ATTRIBUTE_NAME_FULLNAME
    bio:       SAML_ATTRIBUTE_NAME_BIO
    lang:      SAML_ATTRIBUTE_NAME_LANG
    timezone:  SAML_ATTRIBUTE_NAME_TIMEZONE
```

## Backups

Taiga creates two sets of data that merit backup and that you might
use to restore (or pre-populate) a Taiga installation: the PostgreSQL
database, and the `media` directory in `taiga-back`, where user
uploads like avatars, project logos, and file attachments go.

To create a backup, simply run the `taiga.yml` playbook. It will
automatically place a timestamped backup tarball in your local
`backup` directory.

```
$ ansible-playbook taiga.yml
[...]
PLAY RECAP ****************************************************************
xenial-taiga-aio           : ok=111  changed=14   unreachable=0    failed=0

$ ls backup
20171123-224624.tar.bz2
```

If you want to run *just* a backup, run only the tasks marked with the
`backup` tag:

```
$ ansible-playbook taiga.yml -t backup
[...]
PLAY RECAP ****************************************************************
xenial-taiga-aio           : ok=33   changed=6    unreachable=0 failed=0

ls backup/
20171123-224624.tar.bz2  20171123-224837.tar.bz2
```

The backup tarball contains your PostgreSQL database dump
(`taiga.sql`) and a copy of the `media` directory:

```
$ tar -vtjf backup/20171123-224837.tar.bz2
-rw-r--r-- taiga/taiga  254602 2017-11-23 23:48 taiga.sql
drwxr-xr-x taiga/taiga       0 2017-11-23 23:34 media/project/
drwxr-xr-x taiga/taiga       0 2017-11-23 23:34 media/user/
drwxr-xr-x taiga/taiga       0 2017-11-23 22:09 media/project/e/
drwxr-xr-x taiga/taiga       0 2017-11-23 22:09 media/project/e/4/
drwxr-xr-x taiga/taiga       0 2017-11-23 22:09 media/project/e/4/5/
drwxr-xr-x taiga/taiga       0 2017-11-23 22:09 media/project/e/4/5/6/
drwxr-xr-x taiga/taiga       0 2017-11-23 22:09 media/project/e/4/5/6/1c77291428251856b6ddc6985e6558bf06eb0f723258d032f9d44f8147c1/
[...]
```

## Restore

To restore or pre-populate a Taiga installation, either

* create a copy of, or a symlink to, the backup you want to restore,
  named `taiga-restore.tar.bz2`, in your local `backup` directory,
  _or_
* override the `taiga_back_restore_file` variable to point to whatever
  tarball you want to restore.

Then, invoke the playbook with the `taiga_back_restore` variable set
to `true`:

```
$ ansible-playbook taiga.yml -e taiga_back_restore=true
[...]
PLAY RECAP ****************************************************************
xenial-taiga-aio           : ok=120  changed=21   unreachable=0    failed=0
```

The playbook run will fail if you set `taiga_back_restore=true`, but
there is no restore file.

If you want to run *just* a restore, run only the tasks marked with the
`restore` tag (but just as with the full playbook, don’t forget to
also set the `taiga_back_restore` variable):

```
$ ansible-playbook taiga.yml -e taiga_back_restore=true -t restore
[...]
PLAY RECAP ****************************************************************
xenial-taiga-aio           : ok=35   changed=9    unreachable=0    failed=0
```


## Upgrades

Taiga itself will be updated on every run to whatever Git version
(tag, branch, etc.) you specify.

When run with `taiga_upgrade` set to `true`, the playbook also invokes
`apt-get safe-upgrade`, and also upgrades all installed PIP and NPM
modules (as far as possible).

If you *only* want to run a package upgrade and not change any
configuration, you can run just the `install` tasks with
`taiga_upgrade=true`:

```
$ ansible-playbook taiga.yml -e taiga_upgrade=true -t install
[...]
PLAY RECAP ****************************************************************
xenial-taiga-aio           : ok=84   changed=7    unreachable=0    failed=0
```


## Tags

The roles support the following
[tags](http://docs.ansible.com/ansible/latest/playbooks_tags.html):

* `install`: only create scaffolding and install packages as needed,
  but don’t change any configuration.
* `config`: the opposite — _only_ make configuration changes, don’t
  install any packages.
* `front-install`, `back-install`: like `install`, but only for the
  frontend or backend.
* `front-config`, `back-config`: like `config`, but only for the
  frontend or backend.
* `backup`: create a backup tarball, and fetch it to the local system
  (see [Backups](#backups) above).
* `restore`: upload a backup tarball, and apply it on the remote system
  (see [Restore](#restore) above).
* `offline`: only run those tasks that don’t require your target
  systems to have a working internet connection. This is primarily
  useful for working on a local, previously installed test system
  while traveling or otherwise disconnected. 
  
For example, if you wanted to run the whole playbook but skip all
tasks that require connectivity, and also skip the automatic backups,
you might run with `ansible-playbook taiga.yml --tags offline
--skip-tags backup`.


## Limitations

- PostgreSQL gets installed to the `taiga-back` node. There is
  currently no provision to use a remote PostgreSQL instance, nor is
  there support for using any other database.
- There is currently no support for high availability of any kind.
- SSL certificate autogeneration is currently available for
  self-signed certificates only; there is no provision for Let’s
  Encrypt (`certbot`) certificate automation yet.

In addition, you should be aware that the variable defaults for
`taiga_backend_host`, `taiga_events_host` and `taiga_frontend_host`
assume that you operate a single Taiga environment from your
inventory. If you want to manage several Taiga instances, then you
should

* create a separate inventory for each, *or*
* manage everything in a single inventory, but override these three
  variables for each of your instances, *or*
* manage everything in a single inventory and write your own playbook,
  so that the roles are mapped to different group names than in
  `taiga.yml`.

### Low-memory platforms

On low-memory platforms, you may bump into into the rather hefty
memory utilization from compiling the `pip`-installed `lxml` package,
to the point of your memory being exhausted and the installation
failing. To that end, the `taiga-back` role checks
`taiga_back_required_memory` against the available memory on the
target machine, defaulting to 1024 (MB).

You can still install Taiga on a box with less available memory (such
as an [Ubuntu](https://wiki.ubuntu.com/ARM/RaspberryPi)-powered
[Raspberry Pi
3](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/) that
you may use to host a Taiga instance for personal use). But you must
meet a few prerequisites, at least for the duration of the
installation:

1. Swap space must be available. Yes, it’ll be terribly slow on a
   MicroSD card, but it will get you over `lxml`’s memory utilization
   hump.
   
2. PostgreSQL must be stopped while the compilation is running. This
   must be done manually, the `taiga-back` role does not have a task
   for this.
	   
3. RabbitMQ must not run while the compilation is running. This can be
   accomplished by stopping RabbitMQ (again, manually), or you can set
   both `taiga_enable_events` and `taiga_enable_async_tasks` to
   `false`; both those features are probably not of much use on a
   Raspberry Pi or similar platform anyway.

4. You must set `taiga_back_required_memory` to a value that matches
   your target system, such as 900.

Even with all these hacks in place, you’re not certain to
succeed. Running Taiga on a low-memory platform generally isn’t
something that you should consider “supported.”


### Python 3

All of Taiga runs on Python 3, and [since Ansible 2.5 and later fully
support Python
3](https://docs.ansible.com/ansible/latest/reference_appendices/python_3_support.html),
the roles in this repository should allow you to build completely
“Python 2-free” systems.

However, the `rabbitmq-server` package in Ubuntu Bionic [currently has
a dependency](https://packages.ubuntu.com/bionic/rabbitmq-server) on
`python` (the Ubuntu Python 2 package). Thus, if you run with
`taiga_enable_events: true` and/or `taiga_enable_async_tasks: true`,
which will install `rabbitmq-server` onto your `taiga-back` and
`taiga-events` nodes, you will pull Python 2 libraries into those
systems. This — [depending on your Ansible
configuration](https://docs.ansible.com/ansible/2.8/reference_appendices/interpreter_discovery.html)
— may or may not cause Ansible to revert to Python 2 on subsequent
runs.

## License

Like Taiga itself, these playbooks are licensed under the AGPL 3.0;
for the full license text see [LICENSE](LICENSE).
