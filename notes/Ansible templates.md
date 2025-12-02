---
created: 2025-11-21
title: Ansible templates
tags:
  - ansible
aliases:
---
> [!tldr]
> **Шаблони** у [[Ansible]] використовують [[Jinja2]] для динамічного створення конфігураційних файлів. Це дозволяє підставляти змінні в шаблони.

> [!example]
> ```xml
><VirtualHost *:{{ apache_port }}>
>    ServerName {{ server_name }}
>    DocumentRoot {{ document_root }}
> </VirtualHost>
>```