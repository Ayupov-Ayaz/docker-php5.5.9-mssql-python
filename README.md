### Docker образ для случаев когда:

 > * Требуется python в системе
 > * Python должен подключаеться к базе данных
 
 Для всех остальных случаев целесообразнее использовать [облегченный  образ без python](https://github.com/Ayupov-Ayaz/docker-php5.5.9-mssql)
    


##### Образ состоит из: 

> `apache2` + `php:5.5.9` + `mssql:latest` + `python`


##### Требования

> Наличие в системе установленного `Docker`
    
    
    

