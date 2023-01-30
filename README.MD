## Docker Image
Stack:
- Nginx
- PHP FPM 8.1
- Maria DB 10.4
- Phpmyadmin 5.0.1

## How to use

### Test run:
1) Install Docker and Docker compose
2) Clone the repository to your local machine
3) Prepare .env file. Just copy .env.dist file
4) Modify your hosts file by adding these two lines or your own:
```
127.0.0.1 hello.loc
127.0.0.1 phpmyadmin.loc
```
5) Run ``docker compose up -d`` from the root folder you just cloned
6) Go ``http://hello.loc/`` to see PHP info default page or ``http://phpmyadmin.loc`` to see phpmyadmin panel to wor with databases

### Create your domains:
7) Create your own hosts for further work based on ``./hosts/hello-loc.conf``. Just copy it, rename and modify and edit. Example:
```
server {
    index index.php;
    server_name my-new-project.loc;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    root /var/www/my-new-project.loc;

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}
```
8) Don't forget to add your new domain ``my-new-project.loc`` to your computer **hosts** file
9) Go ``http://my-new-project.loc/`` to see your project

## Bonus
Use make scripts saved into ``Makefile`` to make your live easier :)
1) Install make ``sudo apt install make``
2) To use script just use it like that from your docker compose root directory where `p` is your project name folder in `www`: 
```
make composer_i p=hello.loc
```
Please, find the full list of command in the ``Makefile``

### ...or another option is to:
Add these bash scripts to your ``.bashrc`` files. Function name can be any you like.

Enter your PHP container via CLI. 
Please, note that your container name MUST contain ``php-`` in the grep part. 
```
enterServer(){
    docker exec -it $(docker ps --format "{{.Names}}" | grep "php-") bash
}
```

Stop all running containers:
``
stopAllContainers(){
    docker stop $(docker ps -q)
}
``

Run ``composer install`` for a particular project. 
Pass your project folder name as an argument. Example ``composerInstall hello.loc``
Please, note that your container name MUST contain ``php-`` in the grep part.
```
composerInstall(){
    docker exec -i $(docker ps --format "{{.Names}}" | grep "php-") composer install --working-dir=/var/www/$1
}
```

Import the database where you should pass:
1) You MySQL/MariaDb container name
2) Your database name
3) Your dump path
```
importDb(){
    docker exec -i $1 mysql -uroot -proot $2 < $3
}
```

Export the database where you should pass:
1) You MySQL/MariaDb container name
2) Your database name
```
exportDb(){
    docker exec -i $1 mysqldump -uroot -proot $2 | sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' | gzip > $2.sql.gz
}
```
