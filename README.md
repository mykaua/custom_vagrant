# custom_vagrant


We are going to create vargant with confluence using scripts.
We have a few scripts:
1. mysql.cnf - config file of mysql. There we enable InnoDB
2. nginx - proxy virtualhost for confluence
3. id_ras - public key for AWS
4. Vagrantfile - vagrant file with configuration or VM. This file has OS, and upload our files: mysql.cnf, nginx and id_rsa on the server and running our script.
5. prod_script.sh - our script. This script help us to install mysql, nginx, java, conflunece and doing something with these files.

How to use these scripts:

1. Please download repo on your local PC. Your local PC should have virtualbox and Vagrant.
2. Pleae put your private key into id_rsa
3. Please rename domain name in nginx file 
4. Please change domain for SSL cert  and plese use your AWS for SSH tunnel  in prod_script.sh # please read comments in prod_script.sh 

If you are changed these options, you will be able to create VM with Confluence.
And check Confluence using AWS.


Thank you.
