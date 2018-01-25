[![Build Status](https://travis-ci.org/Otus-DevOps-2017-11/Maksov_Infra.svg?branch=master)](https://travis-ci.org/Otus-DevOps-2017-11/Maksov_Infra)
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

## Домашняя работа № 9

Ход выполенения

В результате выполнения работы были созданы и изучены принципы создания модулей в terrraform, создания окружения и работы в команде

Самостоятельное задание

Для повторного переиспользования кода и реализации модели base-app-service
для модулей app, db параметрзируем дополнительно следующие параметры:
app - для ресурса app: name, machine_type,tags, для ресурса firewall_app: name, ports, source_ranges, target_tags, source_ranges
db - для ресурса db: name, machine_type, tags, для ресурса firewall_db: name, ports, target_tags, sourse_tags

теперь можно использовать код для любого приложения по данной архитектуре. app-db(MongoDB, PostgreSQL, MySQL и т.д.) как я понял+повторное использование кода

## Задание со звездочкой *
```
terraform {
  backend "gcs" {
    bucket = "maksov"
    path = "/terraform/terraform.tfstate"
    project = "infra-188917"
  }
}
```
При запуске terraform apply происходит блокировка state файла, создается lock файл и выполнить применение конфигурации из другого окружения невозможно.

## Задание со звездочкой **

Используем template_file для рендеринга конфигурации MongoDB с ip 0.0.0.0 для прослушивания. На внутренем ip сети 10.136.0.0 не заработало. Ошибка Cycle. Как понял срендерит он после создания инстанса. Думал может потом можно выполнить провиженеры. Если так, не разобрался как.
```
data "template_file" "mongod" {

  template = "${file("${path.module}/files/mongod.tpl")}"

  vars {
    bind_ip = "0.0.0.0"
  }
}

используемые провиженеры

connection {
	type        = "ssh"
	user        = "Maksim"
	agent       =  false
	private_key = "${file(var.private_key_path)}"

 }

 provisioner "file" {
	source      = "${data.template_file.mongod.rendered}"
	destination = "/tmp/mongod.conf"

 }

 provisioner "remote-exec" {
	 script = "${path.module}/files/conf_mongodb.sh"
 }

```

Для добавления  IP адреса в переменную DATABASE_URL создаем output переменную инстанса db

И провиженором выполняем скрипты по экспорту переменной и перезапуску WebServer

Но самка связка так и не заработала. P.S. Технологию понял, но полностью не заработала

## Реестр модулей

Подключение модуля sweetops успешно. Бакеты созданы

```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

storage-bucket_url = [
    gs://storage-maksov-1,
    gs://storage-maksov-2
]
```

## Домашняя работа № 10 Знакомство с Ansible

Создание inventory файла:
```
[app]
reddit-app ansible_host=35.205.69.221

[db]
dbserver ansible_host=35.195.213.181
```

Создание inventory в формате YML

```
all:
 children:
  app:
   hosts:
    reddit-app:
     ansible_host:
      35.205.69.221
  db:
   hosts:
    dbserver:
     ansible_host:
      35.195.213.181
```

## Задание со *

Создание inventory в формате json

```
{
    "all": {
        "children": {
            "app",
            "db"
        },

    },
    "app": {
        "hosts": {
            "reddit-app":{
            "ansible_host":"35.195.213.181"
          }
        }
    },
    "db": {
        "hosts": {
            "dbserver": {
           "ansible_host":"35.205.69.221"
     }

        }
    }
}
```

В ходе домашнего задания изучены принципы работы с модулями
Использованы модули command, shell, github

```
Единственное выполнение комманд ruby -v, bundle -v, systemctl status mongod не отработали. reddit-app | FAILED | rc=2 >>
[Errno 2] No such file or directory

Как понял связано с окружением. Модуль не может найти комманду. Пробовал напряму указать /usr/bin/ruby. Тож не зафурычило.
```

## Домашнее задание 11 Деплой и управление конфигурацией с Ansible

Ход выполенения

-- Создание плейбука настройки инстанса MongoDB, инстанса приложеня, дплоя приложения (tasks: Change mongo config file, Add unit file for Puma, Enable puma, Fetch the latest version, Bundle Install, handlers: restart mongod, reload puma, restart puma)

Результат: reddit_app.yml - Playbook -  один сценарий с тегами для настройки БД, деплоя и настройки приложения

-- Один Playbook, несколько сценариев

Результат: reddit-app2.yml - Playbook с несколькими сценариями (Configure MongoDB, Configure environment, Deploy Application)

-- Несколько Playbooks

-- Сборка образов Packer с помощью Playbooks (Playbook: packer/scripts/packer_app.yml, packer/scripts/packer_db.yml). Использованы циклы.

В ходе выполнения изучена работа с модулем apt  и циклы в ansible

но применение apt не увенчалось успехом. возникала ошибка при сборке пакером. Все что нашел перепробовал. Не получилось запустить. В итоге модулем command собирал.


### Сборка app. Одна из ошибок
```
{"changed": true, "cmd": ["apt", "update"], "delta": "0:00:00.043185", "end": "2018-01-17 21:02:28.671300", "msg": "non-zero return code", "rc": 100, "start": "2018-01-17 21:02:28.628115", "stderr": "\nWARNING: apt does not have a stable CLI interface. Use with caution in scripts.\n\nW: chmod 0700 of directory /var/lib/apt/lists/partial failed - SetupAPTPartialDirectory (1: Operation not permitted)\nE: Could not open lock file /var/lib/apt/lists/lock - open (13: Permission denied)\nE: Unable to lock directory /var/lib/apt/lists/\nW: Problem unlinking the file /var/cache/apt/pkgcache.bin - RemoveCaches (13: Permission denied)\nW: Problem unlinking the file /var/cache/apt/srcpkgcache.bin - RemoveCaches (13: Permission denied)", "stderr_lines": ["", "WARNING: apt does not have a stable CLI interface. Use with caution in scripts.", "", "W: chmod 0700 of directory /var/lib/apt/lists/partial failed - SetupAPTPartialDirectory (1: Operation not permitted)", "E: Could not open lock file /var/lib/apt/lists/lock - open (13: Permission denied)", "E: Unable to lock directory /var/lib/apt/lists/", "W: Problem unlinking the file /var/cache/apt/pkgcache.bin - RemoveCaches (13: Permission denied)", "W: Problem unlinking the file /var/cache/apt/srcpkgcache.bin - RemoveCaches (13: Permission denied)"], "stdout": "Reading package lists...", "stdout_lines": ["Reading package lists..."]}
    googlecompute:      to retry, use: --limit @/root/ansible/scripts/packer_ap
```

### Сборка db. Ошибка

```
 googlecompute: fatal: [default]: FAILED! => {"changed": false, "cmd": "/usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv EA312927", "msg": "Error fetching key EA312927 from keyserver: keyserver.ubuntu.com", "rc": 1, "stderr": "gpg: requesting key EA312927 from hkp server keyserver.ubuntu.com\ngpg: key EA312927: public key \"MongoDB 3.2 Release Signing Key <packaging@mongodb.com>\" imported\ngpg: Total number processed: 1\ngpg:               imported: 1  (RSA: 1)\ngpg: no writable keyring found: eof\ngpg: error reading `[stdin]': general error\ngpg: import from `[stdin]' failed: general error\ngpg: Total number processed: 0\n", "stderr_lines": ["gpg: requesting key EA312927 from hkp server keyserver.ubuntu.com", "gpg: key EA312927: public key \"MongoDB 3.2 Release Signing Key <packaging@mongodb.com>\" imported", "gpg: Total number processed: 1", "gpg:               imported: 1  (RSA: 1)", "gpg: no writable keyring found: eof", "gpg: error reading `[stdin]': general error", "gpg: import from `[stdin]' failed: general error", "gpg: Total number processed: 0"], "stdout": "Executing: /tmp/tmp.N4HCZS81kL/gpg.1.sh --keyserver\nkeyserver.ubuntu.com\n--recv\nEA312927\n", "stdout_lines": ["Executing: /tmp/tmp.N4HCZS81kL/gpg.1.sh --keyserver", "keyserver.ubuntu.com", "--recv", "EA312927"]}
 ```


-- Задание со *  Dynamic inventory

Для Dynamic Inventory используется GCE dynamic inventory plugin script gce.py, gce.ini. Скрипт выполняет запрос GCE и передает Ansible информацию какими серверами необходимо управлять.

Настройка

gce.ini

```
gce_service_account_email_address = # Service account email found in ansible json file
gce_service_account_pem_file_path = # Path to ansible service account json file
gce_project_id = # Your GCE project name

```

Проверка работоспособности

./gce.py --list > inventory_dynamic.json

ansible all -i ./gce.py -m ping
```
reddit-app | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
reddit-db | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

Материалы:

- http://docs.ansible.com/ansible/latest/intro_dynamic_inventory.html
- https://www.jeffgeerling.com/blog/creating-custom-dynamic-inventories-ansible

## Домашнее задание № 12 Ansible: работа с ролями и окружениями
Ход выполнения
- создание ролей app и db и их применение
-  создание окружений stage
- работа с коммьюнити ролями (jdauphant.nginx)

C check не рабоатет. При непосредственном выполнении все ок.
```
failed: [reddit-app] (item={'value': [u'listen 80', u'server_name "reddit"', u'location / { http://127.0.0.1:9292; }'], 'key': u'default'}) => {"changed": false, "item": {"key": "default", "value": ["listen 80", "server_name \"reddit\"", "location / { http://127.0.0.1:9292; }"]}, "msg": "src file does not exist, use \"force=yes\" if you really want to create the link: /etc/nginx/sites-available/default.conf", "path": "/etc/nginx/sites-enabled/default.conf", "src": "/etc/nginx/sites-available/default.conf", "state": "absent"}
```
+ ошибка отсутсвия python-apt. Просто вручную установил на app host.

- Задание со * Динамический инвентори для окружений

Используется GCE Dynamic Inventory

Создан скрипт установки параметров в зависимости от окружения - ansible\set_env.sh

./set_env.sh stage | prod - указываем окружение. скрипт применяет настройки в зависимости от заданного окружения (создает ansible.cfg с ссылкой на dynamic inventory в необходимом окружении, создает )

Также для проверки задал для инстансов теги prod_app, prod_db, stage_db, stage_app. Dynamic Inventory формирует группы по тэгам следующим образом tag_prod_app, tag_stage_app и т.д.


- Задание со ** Travis CI

Создан Makefile для прогона тестов.

тесты

terraform_validate - проходит успешно
terraform_tflint - не получилось завести. travis не видел бинарник и не мог его выполнить. Добавлял в локалы, экспортом в переменные окрудения соответствующей папки делал, другую версию tflint выполнял и т..д.
packer_validate - проходит успешно
ansible_lint - проходит. но на ошибки travis не реагирует.

Настройка travis - build master на pull request

## Домашнее задание № 13 Разработка и тестирование Ansible ролей и плейбуков

 Ход работы

 - Локальная разработка с Vagrant

Так как окружение установлено в WSL необходимо было настроить параметры окружения
```
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/VagrantDir/"
```

+ в настройках провайдера добавил v.customize ["modifyvm", :id, "--uartmode1", "disconnected"] для отключения COM порта, который пишет в файл в WSL

Задание со звездочкой * Настройка nginx

Применил рекомендуюмую практику. В папке, шде лежит playbook добавил папку с переменными для группы.

 - Тестирование роли

Для запуска instanse в Molecule в WLS в шаблон настроек (molecule.yml) внес настройку отключения com-портов

platforms:
 raw_config_args:
  - customize ["modifyvm", :id, "--uartmode1", "disconnected"]
  
Для тестирования прослушивания порта используется class testinfra.modules.socket.Socket

Для packer в playbooks packer_app.yml, packer_db.yml добавил путь до роли и указал теги. P.S. То что в packer можно указать тоже видел.


