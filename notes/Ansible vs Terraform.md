---
created: 2025-11-21
title: Ansible vs Terraform
tags:
  - iac
  - ansible
  - terraform
  - question
  - devops
aliases:
---
- [[ansible]] = repair
	- для конфігурування і мейтенінг систем
		- якщо щось пішло не так, ansible виправляє систему назад до потрібного стану 
- [[Terraform]] = replace
	- провіжинг інфраструктури
		- мейнтенінг файлу стану і замінює ресурси, вказаних у конфігу

- terraform to provision EC2 instances, load balancers, and networks
- ansible to install packages, configure services, deploy apps on those instances