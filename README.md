### Hexlet tests and linter status:
[![Actions Status](https://github.com/okorovin/devops-for-developers-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/okorovin/devops-for-developers-project-76/actions)

# DevOps for developers — project 76

Учебный проект Hexlet. Приложение Redmine развёрнуто в Yandex Cloud на двух ВМ за Application Load Balancer, с Managed PostgreSQL в качестве БД. На серверах поднят DataDog Agent для мониторинга. Конфигурация серверов и деплой автоматизированы через Ansible.

**Ссылка на приложение:** https://gosha.tech

## Требования к системе

- Ansible 2.14+ (`brew install ansible` или `pip install ansible`)
- `ansible-vault` (поставляется вместе с Ansible)
- Доступ по SSH к серверам по ключу `~/.ssh/id_rsa`

## Подготовка перед запуском

1. Создай локальный файл `.vault-password` с паролем от Ansible Vault. Этот файл в `.gitignore`, в репозиторий не попадает.
   ```bash
   echo 'твой-пароль-от-vault' > .vault-password
   chmod 600 .vault-password
   ```
2. Подтяни роли и коллекции из Ansible Galaxy:
   ```bash
   make install
   ```

## Команды

```bash
make install      # подтянуть роли и коллекции из Ansible Galaxy
make setup        # установить и сконфигурировать Docker, Python-пакет docker и DataDog Agent на ВМ
make deploy       # развернуть/обновить Redmine на серверах (без переустановки настроек ОС)
make ping         # SSH-доступность всех ВМ
make edit-vault   # отредактировать зашифрованные секреты
make view-vault   # посмотреть зашифрованные секреты
```

- `make setup` запускает плейбук с тегом `setup` (роли `geerlingguy.pip`, `geerlingguy.docker`, `datadog.datadog`).
- `make deploy` запускает плейбук с тегом `deploy` — рендерит `/opt/redmine/.env` из шаблона и поднимает/перезапускает контейнер `redmine:6.0` с `restart_policy=unless-stopped`. Контейнер пересоздаётся **только если изменился `.env`**.

## Тесты

Бейджик `hexlet-check` сверху — это автоматическая проверка от Hexlet. Она запускается на каждый push в любую ветку через GitHub Actions (`.github/workflows/hexlet-check.yml`) и валидирует, что выполнены требования проекта. Локальных тестов нет — проект инфраструктурный.

## Структура

| Файл / директория | Назначение |
|---|---|
| `inventory.ini` | Инвентарь Ansible, группа `webservers` с двумя ВМ |
| `playbook.yml` | Основной плейбук с тремя play и тегами `setup` / `deploy` |
| `requirements.yml` | Роли Galaxy (`geerlingguy.pip`, `geerlingguy.docker`, `datadog.datadog`) и коллекция `community.docker` |
| `group_vars/all/` | Несекретные переменные для всех хостов (например, `ansible_python_interpreter`) |
| `group_vars/webservers/vars.yml` | Открытые переменные для веб-серверов: порт, образ, конфиг БД, http_check, теги DataDog |
| `group_vars/webservers/vault.yml` | Зашифрованные Vault'ом секреты: пароль БД, secret_key Redmine, API-ключ DataDog |
| `templates/redmine.env.j2` | Шаблон `.env` для контейнера Redmine |
| `ansible.cfg` | Конфигурация Ansible (vault_password_file = `.vault-password`) |
| `Makefile` | Команды установки, деплоя и работы с vault |
| `cloud-init.yaml` | Bootstrap-скрипт ВМ при создании в Yandex Cloud |

## Секреты

Чувствительные значения (`db_password`, `redmine_secret_key`, `datadog_api_key`) лежат зашифрованными в `group_vars/webservers/vault.yml` (Ansible Vault, AES256). Открытые переменные — в `group_vars/webservers/vars.yml`, они ссылаются на vault через `db_password: "{{ vault_db_password }}"`. Пароль от vault — в `.vault-password` (в `.gitignore`); путь к файлу прописан в `ansible.cfg`, поэтому `make deploy` подхватывает его автоматически.
