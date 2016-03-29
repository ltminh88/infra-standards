#Autodeployment với Rocketeer trong dự án PHP
## Giới thiệu về Rocketeer
    Rocketeer là một package PHP mới cho việc chạy và triển khai hệ thống. Nó được lấy cảm hứng từ triết lý của Laravel Framework, do đó mục tiêu đặt ra là nhanh, tao nhã và quan trọng hơn cả là dễ sử dụng.
Các tính năng chính:
 - **Đa năng**: hỗ trợ multiple connections, multiserver connections, multiple stages cho mỗi server , etc.
 - **Nhanh**: Queue tasks và chạy chúng song song trên tất cả các servers và stages.
 - **Khả năng điều biến**: ngoài việc add thêm các custom tasks và components, mỗi phần chính của Rocketeer có thể được hoán đổi, mở rộng.
 - **Cấu hình sẵn**: Rocketeer mang đến một sự tiện lợi trong công việc phát triển, đi kèm với những mặc định thông minh và xây dựng trong các tasks như việc cài đặt các ứng dụng phụ thuộc của bạn.
### Cài Đặt
```
$ wget http://rocketeer.autopergamene.eu/versions/rocketeer.phar
$ chmod +x rocketeer.phar
$ mv rocketeer.phar /usr/local/bin/rocketeer
```
### Sử dụng
Những command khả dụng với Rocketeer:
```
$ rocketeer
  check        Check if the server is ready to receive the application
  cleanup      Clean up old releases from the server
  current      Display what the current release is
  deploy       Deploys the website
  flush        Flushes Rocketeer's cache of credentials
  help         Displays help for a command
  ignite       Creates Rocketeer's configuration
  list         Lists commands
  rollback     Rollback to the previous release, or to a specific one
  setup        Set up the remote server for deployment
  strategies   Lists the available options for each strategy
  teardown     Remove the remote applications and existing caches
  test         Run the tests on the server and displays the output
  update       Update the remote server without doing a new release
```
Trong bài viết này tôi sẽ tập trung vào phần sử dụng Rocketeer để auto deploy một dự án PHP trên Amazon Server (Ec2) với Elastic Load Balancing (ELB) và các instances scale up của nó. Việc cài đặt và tạo môi trường trên Ec2, ELB, instances sẽ không được đề cập trong bài viết này.
## Requirements
   - Tạo một user deploy với quyền chạy nginx, fpm, cài đặt aws/aws-sdk-php ở tất cả server admin và server Api.
   - Có quyền clone code từ git server qua ssh.
   - [Composer](https://getcomposer.org/)
   - [Aws/aws-sdk-php](https://github.com/aws/aws-sdk-php)
   - [Rocketeer](http://rocketeer.autopergamene.eu/)
   - Một server Ec2, ELB và một vài instances.
   - Hiểu cơ chế của [load balancing](https://en.wikipedia.org/wiki/Load_balancing_(computing)).

## Autodeployment script
Các files đặt tại thư mục /home/deploy/bin tại server Admin:
 - *aws_config.php*: chứa các thông tin config của Amazon
 - *get_app_servers_addrs.php*: Lấy thông tin của các instances được gắn với ELB bằng ELB name.
 - *get_env*: Lấy file config environment từ Amazon S3
 - *update_elb_tag*: Create/Update tag của ELB chính là branch (version release) của project.
 - *api_servers_deploy*: Autodeployment các instances (Server Api) từ server Admin

Các files đặt tại thư mục /home/deploy/bin tại server Api:
 - *aws_config.php*: chứa các thông tin config của Amazon
 - *get_env*: Lấy file config environment từ Amazon S3
 - *get_current_branch*: Lấy thông tin version release (branch) đang được deploy.
 - *update_ec2_tags*: Tự update tag của chính instances scale up
 - *scaledup_auto_deploy*: Được thiết lập từ động chạy khi một instance tự scale up sẽ deploy chính nó theo version release (branch) đang được sử dụng ở các server Api khác.

[Autodeployment scripts](https://github.com/tranluan91/autodeployment).

Các file bin ở trên cần được cấp quyền thực thi và được chạy ở bất cứ nơi nào với quyền của user deploy. Ví dụ:
 ```
 chmod 600 /home/deploy/bin/get_env
 ```
 ```
 #.bash_profile
 # User specific environment and startup programs
 PATH=$PATH:$HOME/bin
 export PATH
 ```
## Cấu hình Rocketeer
Tạo thư mục cấu hình Rocketeer trong thư mục gốc của project:
```
project_path $ rocketeer ignite
```
Nhấn Enter bỏ qua việc nhập các thông tin cấu hình cho Rocketeer, chúng ta sẽ cấu hình chúng sau.
Rocketeer sẽ tạo ra thư mục ```.rocketeer``` bên trong project folder:
```
| -- config.php     // Chứa cấu hình server connections
| -- hooks.php      // Chứa các tasks trước, sau setup, deploy hay cleanup và custom tasks
| -- paths.php      // Chứa Configurable paths, nếu để mặc định thì Rocketeer sẽ lấy đường dẫn mặc định của php, composer, artisan
| -- remote.php     // Chứa các thông tin config của remote server
| -- scm.php        // Chứa thông tin SCM repository (git, svn), repository, branch mặc định
| -- stages.php     // multiples stages
| -- strategies.php // Config module, tasks được sử dụng và deployment flow
```
Trong file ```config.php```:
```php
<?php
use Rocketeer\Services\Connections\ConnectionsHandler;
include '/home/deploy/bin/get_app_servers_addrs.php'; // include file get thông tin các Api servers
// Some code
'connections'      => [
    'production' => [
        'servers' => $servers, // $servers được lấy từ file get_app_servers_addrs.php được include ở trên
    ],
],
```
Trong file ```hooks.php```:
```php
// Tasks to execute after the core Rocketeer Tasks
    'after'  => [
        'setup'   => [],
        'deploy'  => [
            '. ~/.bash_profile; get_env', // get file environment từ S3
            'ln -s /home/deploy/.env.php .env.php', // Tạo symbolic link từ file env vào trong project để tránh việc lộ source code
            '. ~/.bash_profile; update_ec2_tags', // Update instance tag
            'sh crontab.sh', // Chạy file cấu hình crontab nếu có
            // More task after deploy
            '/etc/init.d/php5-fpm restart', // restart php-fpm
            '/etc/init.d/nginx restart', // restart nginx
        ],
        'cleanup' => [],
    ],
```
```remote.php```:
```php
    // The root directory where your applications will be deployed
    // This path *needs* to start at the root, ie. start with a /
    'root_directory' => '/usr/share/nginx/your_project',
```
```scm.php```:
```php
    // Some code
    // Example: https://github.com/vendor/website.git
    'repository' => 'git@github.com:your_account_name/your_reponame.git',
    //
    'username'   => '', // Username và password nhớ để trống, chúng ta sẽ clone repo qua ssh
    'password'   => '',
```
Các file còn lại để mặc định (hoặc config tùy theo project).
## Autodeployment Flow
 Cơ chế autodeployment
![deploy.png](https://viblo.asia/uploads/images/cbd5df20e9546d8ac1e60c46687ff116ae4758f6/4e7100a9f1ab0f33de85bcd6b912c6240c879676.png)

Config ```aws_config.php```.
1. Tại Admin Server:
 - Deploy project của bạn trước.
 - Chạy lệnh ```api_servers_deploy``` deploy tất cả các Api server hiện đang tại theo version release (branch) của Admin Server.
 - Ngồi đợi kết quả thôi =))
2. Tạo [AMIs](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) (Amazon Machine Images) dùng để tạo các instance scale up mới giống hệt với Api server dùng để tạo AMI
3. Thiết lập Instance Scale up tự động chạy lệnh deploy chính nó khi mới bật lên ```scaleup_auto_
deploy```
Như vậy mỗi khi server của bạn quá tải thì một instance scale up mới sẽ được bật lên và tự động deploy version release giống với các Api Server đang chạy.

## Tài liệu tham khảo
 - [Rocketeer](http://rocketeer.autopergamene.eu/).
 - [Amazon SDK for PHP](http://aws.amazon.com/sdk-for-php/).
