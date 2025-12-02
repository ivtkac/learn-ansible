---
created: 2025-11-21
title: Ansible tags
tags:
  - ansible
aliases:
---

> [!tldr]
> **Теги (tags)** дозволяють виконувати лише певні частини [[ansible playbook|плейбука]].

> [!question] Навіщо?
> - частоково оновити
> - пропустити певні завдання
> - протестувати окремо компоненти

> [!example]
> ```bash
> ansible-playbook -i inventory.ini playbook.yml --tags "apache"
> ```