### Hexlet tests and linter status:
[![Actions Status](https://github.com/okorovin/devops-for-developers-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/okorovin/devops-for-developers-project-76/actions)

## Ссылка на сайт
https://gosha.tech

## Команды

```bash
make install   # подтянуть роли из Ansible Galaxy
make setup     # install + установить Docker и Python-пакет docker на ВМ
make deploy    # развернуть/обновить Redmine на серверах (без переустановки настроек ОС)
make ping      # SSH-доступность всех ВМ
```

`make setup` запускает первый play плейбука с тегом `setup` (роли `geerlingguy.pip` и `geerlingguy.docker`).

`make deploy` запускает второй play с тегом `deploy` — рендерит `/opt/redmine/.env` из шаблона и поднимает/перезапускает контейнер `redmine:6.0` с `restart_policy=unless-stopped`. Контейнер пересоздаётся **только если изменился `.env`**.
