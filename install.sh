##user data section for launch_configuration

##Change s3://123434-hackforward4063 with your bucket name given in the terraform.tfvars file


#!/bin/bash
yum update -y
yum install -y httpd php git
mkdir -p /home/ec2-user/hackforward/{code,script}
cd /home/ec2-user/hackforward/code/
git init
echo "cd /home/ec2-user/hackforward/code/"
echo "git pull https://github.com/JUSTPERFECT/hackforwardtest.git" > /home/ec2-user/hackforward/script/syncCode.sh
echo "aws s3 sync /home/ec2-user/hackforward/code/ s3://123434-hackforward4063" >> /home/ec2-user/hackforward/script/syncCode.sh
chmod 777 /home/ec2-user/hackforward/script/syncCode.sh
(crontab -l ; echo "* * * * * /home/ec2-user/hackforward/script/syncCode.sh") | crontab -
echo "hello world" >> /var/www/html/index.html
service httpd start
chkconfig httpd on
