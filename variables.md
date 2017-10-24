# Overridable variables defined for `ansible-taiga`

## Variables defined in `taiga`

```yaml
---
taiga_populate_hosts: true
taiga_user: taiga
taiga_user_home: '/home/{{ taiga_user }}'
taiga_log_dir: '{{ taiga_user_home }}/logs'
taiga_git_mirror: 'https://github.com/taigaio'
taiga_version: stable
taiga_venv_name: taiga
taiga_venv_dir: "{{ taiga_user_home }}/{{ taiga_venv_name }}"
taiga_debug: false
taiga_enable_ssl: false
taiga_enable_hsts: false
taiga_enable_public_register: false
taiga_enable_feedback: false
taiga_enable_async_tasks: false
taiga_enable_events: false
taiga_enable_email: false
taiga_email_use_tls: false
taiga_email_host: "{{ ansible_fqdn }}"
taiga_email_host_user: ""
taiga_email_host_password: ""
taiga_email_port: 25
taiga_enable_github_login: false
taiga_github_api_client_id: ""
taiga_github_api_client_secret: ""
taiga_frontend_host: "{{ hostvars[groups['taiga-front'][0]]['ansible_fqdn'] }}"
taiga_backend_host: "{{ hostvars[groups['taiga-back'][0]]['ansible_fqdn'] }}"
taiga_events_host: "{{ hostvars[groups['taiga-events'][0]]['ansible_fqdn'] }}"
taiga_rabbitmq_user: "taiga"
taiga_rabbitmq_host: "{{ taiga_backend_host }}"
taiga_rabbitmq_port: 5672
taiga_rabbitmq_vhost: taiga
taiga_backend_port: 8001
taiga_events_port: 8888
taiga_service_manager: circus
```

## Variables defined in `taiga-webserver`

```yaml
---
taiga_webserver: nginx
taiga_webserver_ssl_dhparam_bits: 4096
taiga_webserver_ssl_protocols:
  - TLSv1
  - TLSv1.1
  - TLSv1.2
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
taiga_webserver_enable_hsts: true
taiga_webserver_hsts_max_age: 63072000
```

## Variables defined in `taiga-front`

```yaml
---
taiga_front_repo: "{{ taiga_git_mirror }}/taiga-front-dist.git"
taiga_front_version: "{{ taiga_version }}"
taiga_front_checkout_dir: "{{ taiga_user_home }}/taiga-front-dist"
taiga_front_debug: "{{ taiga_debug }}"
taiga_front_enable_public_register: "{{ taiga_enable_public_register }}"
taiga_front_enable_feedback: "{{ taiga_enable_feedback }}"
taiga_front_backend_hostname: "{{ taiga_backend_host }}"
taiga_front_log_dir: "{{ taiga_log_dir }}"
taiga_front_events_hostname: "{{ taiga_events_host }}"
taiga_front_enable_django_admin: false
```

## Variables defined in `taiga-back`

```yaml
---
taiga_back_checkout_dir: "{{ taiga_user_home }}/taiga-back"
taiga_back_create_sample_data: false
taiga_back_debug: "{{ taiga_debug }}"
taiga_back_default_from_email: "no-reply@{{ taiga_back_domain }}"
taiga_back_domain: "{{ ansible_domain }}"
taiga_back_enable_public_register: "{{ taiga_enable_public_register }}"
taiga_back_enable_ssl: "{{ taiga_enable_ssl }}"
taiga_back_hostname: "{{ ansible_fqdn }}"
taiga_back_load_initial_project_templates: true
taiga_back_load_initial_user_data: true
taiga_back_log_dir: "{{ taiga_log_dir }}"
taiga_back_postgres_db: taiga
taiga_back_postgres_user: "{{ taiga_user }}"
taiga_back_rabbitmq_host: "{{ taiga_rabbitmq_host }}"
taiga_back_rabbitmq_password: "{{ taiga_rabbitmq_password }}"
taiga_back_rabbitmq_port: "{{ taiga_rabbitmq_port }}"
taiga_back_rabbitmq_user: "{{ taiga_rabbitmq_user }}"
taiga_back_rabbitmq_vhost: "{{ taiga_rabbitmq_vhost }}"
taiga_back_repo: "{{ taiga_git_mirror }}/taiga-back.git"
taiga_back_secret_key: "{{ taiga_secret_key }}"
taiga_back_venv_dir: "{{ taiga_venv_dir }}"
taiga_back_version: "{{ taiga_version }}"
```

## Variables defined in `taiga-events`

```yaml
---
taiga_events_repo: "{{ taiga_git_mirror }}/taiga-events.git"
# No stable branch exists for taiga-events
taiga_events_version: "master"
taiga_events_checkout_dir: "{{ taiga_user_home }}/taiga-events"
taiga_events_backend_hostname: "{{ hostvars[groups['taiga-back'][0]]['ansible_fqdn'] }}"
taiga_events_rabbitmq_host: "{{ taiga_rabbitmq_host }}"
taiga_events_secret_key: "{{ taiga_secret_key }}"
taiga_events_log_dir: "{{ taiga_log_dir }}"
```
