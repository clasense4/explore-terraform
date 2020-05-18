#!/bin/bash
sudo apt-get update -y
sudo apt-get install nginx git zip curl wget php php-mbstring php-json php-xml php-tokenizer php-fpm php-bcmath -y

cd ~
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
git clone https://github.com/clasense4/laravel.git
cd /root/laravel
git checkout 1ddb329c60d6f19290c5107423d065850c1e10e4
export COMPOSER_HOME=/root
composer global require "hirak/prestissimo:^0.3"
composer install -vvv --profile --prefer-dist
sudo cp .env.example .env
sudo php artisan key:generate

sudo mv /root/laravel /var/www/laravel
sudo chown -R www-data:www-data /var/www/laravel
sudo rm -rf /etc/nginx/sites-available/example.com
cat <<EOF | sudo tee /etc/nginx/sites-available/example.com
server {
    listen 80;
    root /var/www/laravel/public;
    index index.php index.html index.htm index.nginx-debian.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl stop apache2
sudo systemctl restart nginx