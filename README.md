### Hexlet tests and linter status:
[![Actions Status](https://github.com/okorovin/devops-for-developers-project-76/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/okorovin/devops-for-developers-project-76/actions)

## Ссылка на сайт
https://gosha.tech

## Команды

```bash
make install      # подтянуть роли из Ansible Galaxy
make setup        # install + установить Docker и Python-пакет docker на ВМ
make deploy       # развернуть/обновить Redmine на серверах (без переустановки настроек ОС)
make ping         # SSH-доступность всех ВМ
make edit-vault   # отредактировать зашифрованные секреты
make view-vault   # посмотреть зашифрованные секреты
```
