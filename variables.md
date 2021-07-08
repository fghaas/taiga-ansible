# Overridable variables defined for `ansible-taiga`

## Variables defined in `taiga`

```yaml
---
# Which host runs our backend?
taiga_backend_host: "{{ hostvars[groups['taiga_back'][0]]['ansible_fqdn'] }}"

# Which host should run the taiga-events service?
taiga_events_host: "{{ hostvars[groups['taiga_events'][0]]['ansible_fqdn'] }}"

# Which host should run the Taiga front end?
taiga_frontend_host: "{{ hostvars[groups['taiga_front'][0]]['ansible_fqdn'] }}"

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

# Should Taiga install the latest version of all packages it manages?
taiga_upgrade: false

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
# node.js services? Defaults to "circus" for historical reasons,
# because that used to be the upstream preference. Highly recommended
# to set this to "systemd", which is also the current upstream
# recommendation.
taiga_service_manager: circus

# Twitter handle to include in notification emails
taiga_twitter_handle: taigaio

# GitHub organization to include in notification emails
taiga_github_organization: taigaio

# Support URL to include in notification emails
taiga_support_url: "https://tree.taiga.io/support"

# Support email address to include in notification emails
taiga_support_email: "support@taiga.io"

# Mailing list URL to include in notification emails
taiga_support_mailing_list: "https://groups.google.com/forum/#!forum/taigaio"

# IP addresses from which Taiga should accept GitLab webhook
# calls. GitLab webhooks are not signed, so there is no way to
# cryptographically verify their validity. Thus, the only way to be
# somewhat sure that they come from a legitimate GitLab instance is to
# verify the origin IP address.
taiga_gitlab_valid_origin_ips: []

# Should Taiga support Slack notifications?
taiga_enable_slack: false

# Which GitHub organization should we clone taiga-contrib-slack
# from? Ignored unless taiga_enable_slack is set.
taiga_contrib_slack_mirror: "{{ taiga_git_mirror }}"

# The name of the taiga-contrib-slack repository. Ignored unless
# taiga_enable_slack is set.
taiga_contrib_slack_repo: "taiga-contrib-slack"

# The checkout directory for taiga-contrib-slack. Ignored unless
# taiga_enable_slack is set.
taiga_contrib_slack_checkout_dir: "{{ taiga_contrib_slack_repo }}"

# Version, tag, branch, or commit to check out when installing
# taiga-contrib-slack. Ignored unless taiga_enable_slack is
# set.
taiga_contrib_slack_version: "stable"

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

# A suffix that Taiga should attach to the login name when searching
# the LDAP directory. Ignored unless taiga_enable_ldap_login is
# set. Set this if you want users to log in with just their username
# (not their email address), and that username itself is not in your
# LDAP directory for some reason.
taiga_ldap_search_suffix: ""

# Should Taiga support SAML authentication?
taiga_enable_saml_login: false

# Which GitHub organization should we clone taiga-contrib-saml-auth
# from? Ignored unless taiga_enable_saml_login is set.
taiga_contrib_saml_auth_mirror: "https://github.com/jgiannuzzi"

# The name of the taiga-contrib-saml-auth repository. Ignored unless
# taiga_enable_saml_login is set.
taiga_contrib_saml_auth_repo: "taiga-contrib-saml-auth"

# The checkout directory for taiga-contrib-saml-auth. Ignored unless
# taiga_enable_saml_login is set.
taiga_contrib_saml_auth_checkout_dir: "{{ taiga_contrib_saml_auth_repo }}"

# Version, tag, branch, or commit to check out when installing
# taiga-contrib-saml-auth. Ignored unless taiga_enable_saml_login is
# set.
taiga_contrib_saml_auth_version: "1.1.0"

# The SAML NameId format, if your IdP requires that you specify
# one. Ignored unless taiga_enable_saml_login is set.
taiga_saml_sp_name_id_format: ""

# Your SAML IdP's entity ID. Ignored unless taiga_enable_saml_login is
# set.
taiga_saml_idp_entity_id: ""

# Your SAML IdP's SSO URL. Ignored unless taiga_enable_saml_login is
# set.
taiga_saml_idp_single_sign_on_url: ""

# The SAML SSO binding protocol. Ignored unless
# taiga_enable_saml_login is set.
taiga_saml_idp_single_sign_on_binding: "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"

# Your SAML IdP's SLO URL. Ignored unless taiga_enable_saml_login is
# set. If left empty, SAML authentication will use the same URL as
# that specified in taiga_saml_idp_single_sign_on_url.
taiga_saml_idp_single_logout_url: ""

# The SAML SLO binding protocol. Ignored unless
# taiga_enable_saml_login is set.
taiga_saml_idp_single_logout_binding: "{{ taiga_saml_idp_single_sign_on_binding }}"

# Your SAML IdP's X.509 certificate. Ignored unless
# taiga_enable_saml_login is set.
taiga_saml_idp_cert: ""

# Your SAML IdP's X.509 certificate. Ignored unless
# taiga_enable_saml_login is set. This is also ignored if you choose
# to specify the whole certificate instead. In other words, set either
# taiga_saml_idp_cert or this variable.
taiga_saml_idp_cert_fingerprint: ""

# Security settings for your SAML configuration. Ignored unless
# taiga_enable_saml_login is set. Leaving this dictionary empty has
# the same effect as specifying the following values:
# taiga_saml_security:
#   nameIdEncrypted:         false
#   authnRequestsSigned:     false
#   logoutRequestSigned:     false
#   logoutResponseSigned:    false
#   signMetadata:            false
#   wantMessagesSigned:      false
#   wantAssertionsSigned:    false
#   wantNameId:              true
#   wantAssertionsEncrypted: false
#   wantNameIdEncrypted:     false
#   wantAttributeStatement:  true
#   requestedAuthnContext:   true
taiga_saml_security: {}

# Organization settings for your SAML SP. Ignored unless
# taiga_enable_saml_login is set. If unset, this information is
# generated from the frontend hostname.
# Example settings:
# taiga_saml_organization:  # populate at least for en-US, and for other languages as needed
#   en-US:
#     name:          # organization identifier
#     displayname:   # name to display for the organization
#     url:           # web site URL
taiga_saml_organization: {}

# Contact person settings for your SAML SP. Ignored unless
# taiga_enable_saml_login is set. If unset, this is omitted from the
# SP metadata.
# Example settings:
# taiga_saml_contact_person:
#   technical:
#     givenName:     # name of your technical contact
#     emailAddress:  # email address of your technical contact
#   support:
#     givenName:     # name of your support contact
#     emailAddress:  # email address of your support contact
taiga_saml_contact_person: {}

# Attribute mapping settings for your SAML SP. Ignored unless
# taiga_enable_saml_login is set.
# Example settings:
# taiga_saml_mapping:  # map SAML users to Taiga users
#   id: SAML_NAMEID
#   attributes:
#     email:     SAML_ATTRIBUTE_NAME_EMAIL
#     username:  SAML_ATTRIBUTE_NAME_USERNAME
#     full_name: SAML_ATTRIBUTE_NAME_FULLNAME
#     bio:       SAML_ATTRIBUTE_NAME_BIO
#     lang:      SAML_ATTRIBUTE_NAME_LANG
#     timezone:  SAML_ATTRIBUTE_NAME_TIMEZONE
taiga_saml_mapping: {}

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

# Do we want to fall back to user avatars from gravatar.com, for users
# who don't upload a profile image but have a matching email address
# associated with their Gravatar profile?
taiga_front_enable_gravatar: true

```

## Variables defined in `taiga-back`

```yaml
---
# Which minimum memory requirement (in MB) should we enforce?
taiga_back_required_memory: 1024

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

# Do we want to restore data from a backup?
taiga_back_restore: false

# For restoring from a backup, what's the filename of the local
# tarball we should restore?
taiga_back_restore_file: "backup/taiga-restore.tar.bz2"

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

## Variables defined in `taiga-node`

```yaml
---
# Repo release of Node.js to be installed.
taiga_node_version: 12

```
