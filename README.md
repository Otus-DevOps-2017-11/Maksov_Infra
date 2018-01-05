# Maksov_Infra
## Домашнее задание 05
## Способ подключения к серверу internalhost в одну команду

ssh -i ~/.ssh/Maksim -J Maksim@35.205.192.125 10.132.0.3

## Вариант решения подключения ssh по имени хоста
Для подключения к серверу, находящегося в корпоративной сети (за шлюзом), по имени хоста использовался способ указания Псевдонимов (Alias) и ssh jumphost, позволяющий автоматически выполнять ssh команды на удаленных хостах по цепочке

Создан config файл со следующими настройками
```
### Подключение к хосту bastion (Прямое подключение)
Host bastion
	HostName 35.205.192.125
	User Maksim
  	IdentityFile ~/.ssh/Maksim
### Хост для прыжка
Host internalhost
  HostName 10.132.0.3
  ProxyJump  bastion
 ```
ProxyJump как я понял появилась сравнительно недавно и данный параметр упрощает настройку
Поэтому если выполнять через ProxyCommand конфигурация будет выглядеть так

```
--- Подключение к хосту bastion (прямое)
Host bastion
	HostName 35.205.192.125
	User Maksim
	IdentityFile ~/.ssh/Maksim
--- Хост для прыжка
Host internalhost
  HostName 10.132.0.3
  ProxyCommand  ssh -q bastion nc -q0 internalhost 22
--- Вариация 2
--- Хост для прыжка
Host internalhost
  HostName 10.132.0.3
  Port 22
  ProxyCommand  ssh -i ~/.ssh/Maksim -q Maksim@35.205.192.125 nc -q0 %h %p
 ```
## Конфигурация

Хост: bastion, внешний IP:35.205.192.125, внутренний IP: 10.132.0.2

Хост: internalhost, внутренний IP: 10.132.0.3

## Домашнее задание 06
## Результаты работы

Созданы скрипты установки приложений

install_ruby.sh - скрипт установки Ruby и build-essential (список пакетов для сборки приложения)

install_mongodb.sh - скрипт установки MongoDB 3.2

deploy.sh - скрипт скачивания, сборки и запуска приложения puma

Запуск приложения выполнен на порту 9292

Конфигурация puma-server

int IP 10.135.0.4/ext IP 35.205.163.111

## Доп задание 1

Создан скрипт startupscript.sh - скрипт, выполянющий тоже, что и скрипты install_ruby.sh, install_mongodb.sh,deploy.sh

В ходе выполнения при запуске скриптов возникла проблема  запуска скрипта /bin/bash^M bad interpreter: No such file or directory
В ходе поиска решения проблемы выявлено, что при создании скриптов в Windows редакторы добавляют символ "возврата каретки" CR/LF
Проблема решена установкой dos2unix и перекодированием соответствующих файлов

## Доп задание 2
Команды gcloud для запуска startup script
gcloud compute instances create example-instance
--metadata-from-file startup-script=path/to/file
или для запуска по url
--metadata startup-script-url=url

В итоге

-- вариант команды gcloud для запуска Startup script из файла при создании инстанса:

```
gcloud compute instances create reddit-app --boot-disk-size=10GB --image-family ubuntu-1604-lts --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --metadata-from-file startup-script=C:\Maksov_Infra\startupscript.sh
```
Данный вариант сработал!

-- вариант команды gcloud для запуска Startup script по url при создании инстанса:
Был создан Storage bucket maksov и подлит файл startupscript.sh

```
gcloud compute instances create reddit-app --boot-disk-size=10GB --image-family ubuntu-1604-lts --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --scopes storage-ro --metadata startup-script-url=https://storage.googleapis.com/maksov/startupscript.sh
```

По скрипту сначала не заработало! Пробовал и  gs://maksov/startupscript.sh
Но в итоге анализируя /var/log/syslog таже проблема с тем, что файл был создан в Windows

## Доп задание 3

Команда gcloud для добавления правила брэндмауера

gcloud compute firewall-rules create default-puma-server --allow tcp:9292  --target-tags=puma-server

## Домашнее задание 07 Сборка образов VM при помощи Packer
## Результаты работы

## Самостоятельное задание № 1
Для параметризации пользовательские переменные id_project, source_image_family, machine указаны в
разделе variables конфигурационного файла. Переменные указываются в файле variables.json. Пример заполнения variables.json.example

## Самостоятельное задание № 2
Дополнительные опции параметризации

* Описание образа - "image_description",
* Размер и тип диска - "disk_size", "disk_type"
* Название сети - "network"
* Теги - "tags"

## Задание № 1*

immutable.json - конфигурационный файл создания полного образа Reddit (с приложением) по принципу Immutable infrastructure

Дополнительные файлы

redditapp.service - конфигурационный файл запуска Ruby Web-Server Puma как сервиса с рабочей категорией приложения Reddit

startupscript.sh - скрипт установки Ruby, MongoDB 3.2 и деплоя приложения

Изученные материалы

* https://github.com/puma/puma/blob/master/docs/systemd.md
* https://www.freedesktop.org/wiki/Software/systemd/
* https://losst.ru/avtozagruzka-linux#104010741090108610791072107510881091107910821072_10891082108810801087109010861074_1074_Linux

## Задание № 2*

```
gcloud compute instances create reddit-app-full --boot-disk-size=10GB --image-family reddit-full --image-project=infra-188917 --machine-type=g1-small --tags puma-server
```
## Домашнее задание № 8 Практика IaC с использованием Terraform
Результаты работы

## Самостоятельное задание

* В файле переменных input.tf определены переменные - Коммит 631754e
1. private_key_path - путь к приватному ключу для подключения провижинеров
2. zone - зона инстанса

* Отформатированы конфигурационные файлы командой terraform fmt - Коммит 631754e

* terraform.tfvars.example - переменные для образца

## Задание со звездочкой *

* Описан ресурс для добавления ssh ключей нескольких пользователей - Коммит 631754e
```
resource "google_compute_project_metadata" "sshkey1" {
  metadata  {
    ssh-keys  = "Maksim1:${file("C:/Users/Maksim/.ssh/Maksim.pub")}\n Maksim2:${file("C:/Users/Maksim/.ssh/Maksim.pub")}"
  }
```
### Проблемы

* Ключи проекта блокируются ключами инстанса.
* Ключ appuser_web стирается при выполнении команды terraform apply, т.к. проект приводится к состоянию, описанному в terraform


## Задание со звездочкой ** - Создание балансировщика

1. В конфигурационном файле описано создание HTTP балансировщика. Добавлена output переменная адреса балансировщика

Алгоритм создания балансировщика

Предусловия

1. Создание глобального статистического адреса
```
resource "google_compute_global_address" "global_ip" {
  name = "global-reddit-ip"
}
```
2. Создание группы экземпляров
```
resource "google_compute_instance_group" "webservers" {
  name        = "reddit-group"
  description = "Reddit instance group"

  instances = [
    "${google_compute_instance.app.*.self_link}"
  ]

  named_port {
    name = "reddit-group-port"
    port = "9292"
  }

  zone = "${var.zone}-d"
}
```
3. Создание проверки (Health check)
```
resource "google_compute_http_health_check" "reddit-health" {
  name               = "reddit-health-check"
  port               = "9292"
  timeout_sec        = 1
  check_interval_sec = 1
}
```

* Настройка балансировщика

1. Именнованные порты - reddit-group-port
2. Создание backend-services
```
resource "google_compute_backend_service" "reddit-bk" {
  name        = "reddit-backend"
  description = "Our company website"
  port_name   = "reddit-group-port"
  protocol    = "HTTP"
  timeout_sec = 10
  enable_cdn  = false

  backend {
    group = "${google_compute_instance_group.webservers.self_link}"
  }

  health_checks = ["${google_compute_http_health_check.reddit-health.self_link}"]
}
```
3. Создание url-map (используется конфигурация по умолчанию)

```
resource "google_compute_url_map" "reddit-map" {
  name        = "urlmap"
  description = "a description"

  default_service = "${google_compute_backend_service.reddit-bk.self_link}"
}
```
4. Создание target-proxy
```
resource "google_compute_target_http_proxy" "http-reddit-proxy" {
  name        = "reddit-proxy"
  description = "a description"
  url_map     = "${google_compute_url_map.reddit-map.self_link}"
}
```
5. Создание forawrding-rule
```
resource "google_compute_global_forwarding_rule" "default" {
  name       = "default-rule"
  target     = "${google_compute_target_http_proxy.http-reddit-proxy.self_link}"
  ip_address = "${google_compute_global_address.global_ip.address}"
  port_range = "80"
}
```

Для создания идентичного инстанса был использован параметр ресурса count
```
	count = "2"
	name         = "reddit-app${count.index+1}" - Задание имени ресурса по индексу
```

Также по мануалу рекомендуют еще оставить доступ к инстансам только от адресов балансировщика

По вопросу про проблему конфигурации не совсем понял суть вопроса какого приложения  и какой конфигурации в данном случае имеется в виду: reddit-app2, или связки reddit-app1 и reddit-app2 или еще что подразумевается.

Но в данном случае как я понимаю все равно существуют риск отключения двух инстансов.
Можно было бы применить еще управляемую группу, которая восстановливала бы работспособность инстанса. Или скрипт восстановления службы создать при остановке.
