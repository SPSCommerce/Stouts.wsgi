#!/bin/sh

# This file was generated by Ansible for {{ansible_fqdn}}
# Do NOT modify this file by hand!

{% set app = item -%}
{% set app_dir = item.app_dir|default(wsgi_app_dir) -%}
{% set virtualenv = item.get('virtualenv', wsgi_virtualenv) -%}
{% set pip = (virtualenv + '/bin/pip') if virtualenv else 'pip' -%}
{% set pip_packages = item.get('pip_packages', wsgi_pip_packages) -%}
{% set pip_requirements = item.get('pip_requirements') -%}

[ -d {{app_dir}} ] || {
    echo "Application directory is not found. Exiting. "
    exit 0
}

cd {{app_dir}}

{% if virtualenv -%}
[ -d {{virtualenv}} ] || virtualenv {{virtualenv}} -p {{app.get('virtualenv_python', wsgi_virtualenv_python)}}
{% endif %}

# Instal WSGI Server
{{pip}} install {{item.get('server', wsgi_server)}}

{% for package in pip_packages %}
{{pip}} install {{package}}
{% endfor %}

{% if pip_requirements %}
# Install requiremrents
{{pip}} install -r {{pip_requirements}}
{% endif %}
