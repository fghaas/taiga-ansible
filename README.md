# `taiga-ansible`

### [Ansible](https://www.ansible.com/) roles and playbooks to deploy [Taiga](https://taiga.io/)
	
This is a set of Ansible roles and example playbook that enable you to
deploy the Taiga project management platform to your own servers. It
closely tracks the recommendations given in the Taiga
[production environment setup guide](http://taigaio.github.io/taiga-doc/dist/setup-production.html).

## Prerequisites

All systems in your inventory must be running Ubuntu 16.04 Xenial
Xerus.

Your deploy host must be running at least Ansible 2.4.

## Roles

Taiga hosts are to be sorted into three different roles:

- `taiga-back`: Taiga backend node running the Taiga Django REST
  application (and optionally, asynchronous task processing via
  Celery). This nodes also run PostgreSQL and, if needed, RabbitMQ and
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

## LDAP Authentication

To enable LDAP authentication support, set `taiga_enable_ldap_login`
to `true`, and set `taiga_ldap_*` variables to match your LDAP server
configuration. For details on supported variables, see
[variables.md](variables.md).

## Slack Support

To enable the Slack notification plugin, set `taiga_enable_slack` to
`true`.

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

## Limitations

- PostgreSQL gets installed to the `taiga-back` node. There is
  currently no provision to use a remote PostgreSQL instance, nor is
  there support for using any other database.
- There is currently no support for high availability of any kind.
- SSL certificate autogeneration is currently available for
  self-signed certificates only; there is no provision for Let’s
  Encrypt (`certbot`) certificate automation yet.

## License

Like Taiga itself, these playbooks are licensed under the AGPL 3.0;
for the full license text see [LICENSE](LICENSE).
