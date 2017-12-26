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

