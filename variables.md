# Overridable variables defined for `ansible-taiga`

## Variables defined in `taiga`

```yaml
---
# Which host runs our backend?
taiga_backend_host: "{{ hostvars[groups['taiga-back'][0]]['ansible_fqdn'] }}"

# Which host should run the taiga-events service?
taiga_events_host: "{{ hostvars[groups['taiga-events'][0]]['ansible_fqdn'] }}"

# Which host should run the Taiga front end?
taiga_frontend_host: "{{ hostvars[groups['taiga-front'][0]]['ansible_fqdn'] }}"

# Which user should be created on all hosts for Taiga's own purposes?
# Taiga services must not be run as root.
taiga_user: taiga

# Which home directory should we create for the Taiga user?
taiga_user_home: '/home/{{ taiga_user }}'

# Which directory should Taiga write its logs to?
# (relative to taiga_user_home)
taiga_log_dir: 'logs'

# What port should the Taiga backend Django REST application listen on?
taiga_backend_port: 8001

# Do we want debug logging for all services? Can be overridden on a
# per-role basis. Do not enable this permanently on a production
# system, particularly when simultaneously setting
# taiga_enable_async_tasks (there are known memory leaks in Celery
# when running in debug mode).
taiga_debug: false

# Email address to be associated with the Taiga "admin" user.
taiga_admin_email: "taiga@{{ ansible_fqdn }}"

# Should Taiga send email?
taiga_enable_email: false

# What SMTP host, port, username and password should Taiga use for
# sending email? (Only applies when taiga_email_enable is set.)
taiga_email_host: "{{ ansible_fqdn }}"
taiga_email_host_password: ""
taiga_email_host_user: "{{ taiga_user }}@{{ ansible_domain }}"
taiga_email_port: 25

# Do we want to connect with TLS when sending email? (Only applies
# when taiga_email_enable is set.)
taiga_email_use_tls: false

# Should Taiga enable asynchronous task processing with Celery?
taiga_enable_async_tasks: false

# Should Taiga enable websockets events?
taiga_enable_events: false

# Which (backend) port should the taiga-events service listen on?
taiga_events_port: 8888

# Should Taiga come with a "Send feedback" button?
taiga_enable_feedback: false

# Do we want users to be able to log in with their GitHub identity?
taiga_enable_github_login: false

# What API client ID and secret should be used when authenticating
# users via GitHub?(Ignored unless taiga_enable_github_login is set.)
taiga_github_api_client_id: ""
taiga_github_api_client_secret: ""

# Do we want to enable anyone to register?
taiga_enable_public_register: false

# Should Taiga enable SSL for the frontend web site (HTTPS) and events
# WebSockets (WSS)?
taiga_enable_ssl: false

# The common name in the X.509 certificate used for SSL (and SAML, if
# configured).
taiga_ssl_common_name: "{{ taiga_frontend_host or ansible_fqdn }}"

# The SSL key to use. If defined, this key is used for both HTTPS on
# the front end, and for the configuration of the SAML SP. If
# taiga_enable_ssl is set to true, and this value is empty, then a
# self-signed certificate is created from a new key.
taiga_ssl_key: ""

# The default SSL certificate to use. If defined, this certificate is
# used for both HTTPS on the front end, and for the configuration of
# the SAML SP.
taiga_ssl_certificate: ""

# Which GitHub organization should we clone Taiga from?
taiga_git_mirror: 'https://github.com/taigaio'

# What Taiga version, tag, branch, or commit should we check out
# when installing?
taiga_version: stable

# Do we want to create name/address entries for all hosts we touch, in
# every hosts's /etc/hosts file?
taiga_populate_hosts: true

# Which RabbitMQ host should Taiga communicate with? Ignored if
# neither taiga_enable_events nor taiga_enable_async_tasks is set.  If
# either of the two is set, then RabbitMQ will be installed on the
# matching node.
taiga_rabbitmq_host: "{{ taiga_backend_host }}"
taiga_rabbitmq_port: 5672
taiga_rabbitmq_user: "taiga"
taiga_rabbitmq_vhost: taiga

# Which service manager should run the Taiga gunicorn, Celery, and
# node.js services? Defaults to "circus" because that is the
# upstream-preferred default. Can also be set to "systemd", if using
# Ansible 2.2 or later.
taiga_service_manager: circus

# Should Taiga support LDAP authentication?
taiga_enable_ldap_login: false

# LDAP server to connect to for authentication. Ignored unless
# taiga_enable_ldap_login is set, must not be blank otherwise. Must be
# specified as a URI, using either ldap:// or ldaps:// as its scheme.
taiga_ldap_server: ""

# LDAP server port. Ignored unless taiga_enable_ldap_login is set.
taiga_ldap_port: 389

# LDAP bind DN and password. Ignored unless taiga_enable_ldap_login is
# set. Can be left blank, in which case Taiga attempts to bind to the
# LDAP server anonymously. If set, must be given in Distinguished Name
# (DN) format.
taiga_ldap_bind_dn: ""
taiga_ldap_bind_password: ""

# LDAP search base. Ignored unless taiga_enable_ldap_login is
# set. Must be given in Distinguished Name (DN) format. Can be left
# blank, in which case Taiga attempts to search from the top of the
# LDAP tree (note that some LDAP servers disallow this by default.)
taiga_ldap_search_base: ""

# The LDAP property that Taiga should interpret as the user's email
# address. Ignored unless taiga_enable_ldap_login is set.
taiga_ldap_email_property: mail

# The LDAP property that Taiga should interpret as the user's full
# name.  Ignored unless taiga_enable_ldap_login is set.
taiga_ldap_full_name_property: name

# The LDAP property that Taiga should use to build its search filter
# when looking for a matching user. Ignored unless
# taiga_enable_ldap_login is set. Defaults to the property that
# defines the user's email address, meaning the email address
# effectively becomes the user's login name.
taiga_ldap_search_property: "{{ taiga_ldap_email_property }}"
```

## Variables defined in `taiga-webserver`

```yaml
---
# Which webserver should we install for the Taiga frontend? Currently
# only supports "nginx" because that is the upstream-preferred
# default.
taiga_webserver: nginx

# Do we want to enable debug logging for the webserver?
taiga_webserver_debug: "{{ taiga_debug }}"

# Do we want to enable HSTS, and if so, with what max age? (Ignored if
# taiga_enable_ssl is off.)
taiga_webserver_enable_hsts: true
taiga_webserver_hsts_max_age: 63072000

# Which SSL ciphers do we want to allow? (Ignored if taiga_enable_ssl
# is off.)
taiga_webserver_ssl_ciphers:
  - ECDHE-RSA-AES128-GCM-SHA256
  - ECDHE-ECDSA-AES128-GCM-SHA256
  - ECDHE-RSA-AES256-GCM-SHA384
  - ECDHE-ECDSA-AES256-GCM-SHA384
  - DHE-RSA-AES128-GCM-SHA256
  - DHE-DSS-AES128-GCM-SHA256
  - kEDH+AESGCM
  - ECDHE-RSA-AES128-SHA256
  - ECDHE-ECDSA-AES128-SHA256
  - ECDHE-RSA-AES128-SHA
  - ECDHE-ECDSA-AES128-SHA
  - ECDHE-RSA-AES256-SHA384
  - ECDHE-ECDSA-AES256-SHA384
  - ECDHE-RSA-AES256-SHA
  - ECDHE-ECDSA-AES256-SHA
  - DHE-RSA-AES128-SHA256
  - DHE-RSA-AES128-SHA
  - DHE-DSS-AES128-SHA256
  - DHE-RSA-AES256-SHA256
  - DHE-DSS-AES256-SHA
  - DHE-RSA-AES256-SHA
  - '!aNULL'
  - '!eNULL'
  - '!EXPORT'
  - '!DES'
  - '!RC4'
  - '!3DES'
  - '!MD5'
  - '!PSK'

# What length do we want for our Diffie-Hellman parameters? (Ignored if
# taiga_enable_ssl is off.)
taiga_webserver_ssl_dhparam_bits: 4096

# Which SSL protocols do we want to allow? (Ignored if
# taiga_enable_ssl is off.)
taiga_webserver_ssl_protocols:
  - TLSv1
  - TLSv1.1
  - TLSv1.2

```

## Variables defined in `taiga-front`

```yaml
---
# What repo should we check out?
# (relative to taiga_git_mirror)
taiga_front_repo: "taiga-front-dist"

# Which directory should we check it out into?
# (relative to taiga_user_home)
taiga_front_checkout_dir: "{{ taiga_front_repo }}"

# What Taiga version, tag, branch, or commit should we check out
# when installing?
taiga_front_version: "{{ taiga_version }}"

# Where should we write our logs?
taiga_front_log_dir: "{{ taiga_log_dir }}"

# Do we want to enable debugging for the frontend?
taiga_front_debug: "{{ taiga_debug }}"

# Do we want to expose the Django admin interface in the front end?
taiga_front_enable_django_admin: false

```

## Variables defined in `taiga-back`

```yaml
---
# What repo should we check out?
# (relative to taiga_git_mirror)
taiga_back_repo: "taiga-back"

# Which directory should we check it out into?
# (relative to taiga_user_home)
taiga_back_checkout_dir: "{{ taiga_back_repo }}"

# What Taiga version, tag, branch, or commit should we check out
# when installing?
taiga_back_version: "{{ taiga_version }}"

# What name should we use for the virtualenv for the backend?
taiga_back_venv_name: taiga

# Where should we install the virtualenv for the backend?
# (relative to taiga_user_home)
taiga_back_venv_dir: ".virtualenvs/{{ taiga_back_venv_name }}"

# Where should we write our logs?
taiga_back_log_dir: "{{ taiga_log_dir }}"

# Do we want to enable debugging for the backend?
taiga_back_debug: "{{ taiga_debug }}"

# Which hostname should go into the Django app's configuration?
taiga_back_hostname: "{{ ansible_fqdn }}"

# Do we want to load the Taiga initial project templates and user
# data?
# (Set both of these to true on initial deployment, and then
# leave them at the defaults for any subsequent runs.)
taiga_back_load_initial_project_templates: false
taiga_back_load_initial_user_data: false

# Do we want to create a set of sample Taiga data? (Leave disabled on
# a production system.)
taiga_back_create_sample_data: false

# Which address should the backend send email from? (Ignored if
# taiga_enable_email is off.)
taiga_back_default_from_email: "{{ taiga_admin_email }}"

# What PostgreSQL database name and user should we configure?
taiga_back_database_name: taiga
taiga_back_database_user: "{{ taiga_user }}"

# Which Redis host should we connect to?
taiga_back_redis_host: localhost

```

## Variables defined in `taiga-events`

```yaml
---
# What repo should we check out?
# (relative to taiga_git_mirror)
taiga_events_repo: "taiga-events"

# Which directory should we check it out into?
# (relative to taiga_user_home)
taiga_events_checkout_dir: "{{ taiga_events_repo }}"

# What Taiga version, tag, branch, or commit should we check out
# when installing?
taiga_events_version: "master"  # No stable branch exists for taiga-events

# Where should we write our logs?
taiga_events_log_dir: "{{ taiga_log_dir }}"

```
