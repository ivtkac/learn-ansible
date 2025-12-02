---
created: 2025-11-21
title: Ansible variables
tags:
  - ansible
aliases:
---

> [!tldr]
> **Змінні** у [[Ansible]] дозволяють уникнути жорстко закодованих значень.

Можна визначити:

- Глобально в [[ansible playbook|playbook]]
- В [[Ansible inventory|інвенторії]] файлу
- В окремих файлах змінних

> [!example]
> ```yaml
> vars:
> 	apache_port: 8080
> ```