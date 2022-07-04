# Atividade Compass

 Objetivo dessa atividade é subir 1(um) servidor Oracle Linux do zero (sem
interface grafica).

## Primeiros passos: Instalação do Oracle Linux

Antes de instalarmos o sistema operacional deixamos a máquina virtual em modo NAT no Virtual Box.  

![nat](https://user-images.githubusercontent.com/63206031/177155691-f19922d4-ce0e-48ee-af8c-fd5727c1ee26.png)

Na hora de instalar o Oracle Linux, fizemos a partição do disco manualmente, criamos um filesystem /var/lib/docker com 10GB em EXT4 para as imagens do docker. Depois instalamos com minimal install para termos um Oracle Linux sem interface gráfica. 

## Configurando o Hostname 

Para alterar o hostname de localhost para redis usamos o comando: 

    hostnamectl set-hostname redis
    
## Configurando SSH

Para configurar o SSH primeiro é necessário descomentar uma linha do arquivo /etc/ssh/sshd_config, para que seja possível acessar o ssh pela porta 22. Usamos o comando abaixo para abrir com o editor vi o arquivo /etc/ssh/sshd_config, foi necessário para escrever no arquivo usar o sudo.

    sudo vi /etc/ssh/sshd_config

Depois procuramos a seguinte linha:
    #Port 22

E tiramos o '#' para descomentar. 
Após isso para bloquear o acesso root via SSH pois pode ser perigoso, dentro do mesmo arquivo, procuramos a linha

    PermitRootLogin yes
    
E colocamos "no" no lugar do "yes", ficou assim:

    PermitRootLogin no
    
## Utilizando o Docker

Primeiro fizemos a instalação do Docker, com os seguintes comandos

    sudo yum install -y yum-utils


    sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
    
    
    sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    
Depois para iniciar o docker

    sudo systemctl start docker
    
Para verificarmos se foi instalado corretamente usamos o a imagem hello-world do Docker

    sudo docker run hello-world
    
## Instalando uma imagem da aplicação redis com mysql na porta 3307 via Docker

Para subir a aplicação docker do mysql com o redis via Docker foi necessário o Docker Compose para executar esses dois containers. Para instalar o Docker Compose usamos o comando: 

    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

Depois para mudar as permissões

    sudo chmod +x /usr/local/bin/docker-compose
    
Depois para vincular o comando docker-compose

    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose


Para verificar se baixou

    docker-compose --version

Após isso criamos um diretório ymls esse diretório vai estar o arquivo do docker-compose o .yml

    mkdir ymls
    
Depois criamos o arquivo docker-compose.yml no diretório ymls

    cd ymls
    
    touch docker-compose.yml

Depois colocamos o conteúdo nesse arquivo, onde é dado as instruções da aplicação para criação. O conteúdo desse arquivo está nesse repositório. Depois criamos outro diretório arquivos-docker, com subdiretório db. No diretório arquivos-docker estará o arquivo dockerfile, seu conteúdo está nesse repositório também. Após esses passos, dentro do diretório /ymls executamos o comando para subir a aplicação

    sudo docker-compose up -d
    
Dessa maneira nossa aplicação Docker está ativa.

## Versionamento

Para versionamento usamos o git, para instalar o git no Oracle Linux,usamos os seguintes comandos:

    sudo yum update
    
    sudo yum install git
    
Dessa forma teremos instalado o git. Depois criamos um repositório no GitHub e utilizamos os comandos abaixo para vincular com nossa conta:

    git config --global user.name "Fulano de Tal"
    
    git config --global user.email “fulanodetal@exemplo.br”
    
Após isso usamos os comandos abaixo para iniciar o git e depois subir para o GitHub

    echo "# compass" >> README.md
    
    git init
    
    git add README.md
    
    git commit -m "primeiro commit"
    
    git branch -M main
    
    git remote add origin https://github.com/gabrielcarsa/compassLinuxDocker.git
    
    git push -u origin main


## Cofigurando DNS e IP fixo
    
Primeiro para configurar o DNS com o nome redismysqllabcontainer foi necessário abrir o arquivo /etc/hosts, com o seguinte comando

    sudo vi /etc/hosts

Depois adicionamos uma linha com nosso ip, que pode ser visualizado com o comando ifconfig, na linha que adicionamos colocamos o nosso IP e o nome redismysqllabcontainer, dessa maneira abaixo:

    10.0.2.15   redismysqllabcontainer

Depois de ter configurado o DNS, configuramos o IP fixo, para fazer isso foi necessário fazer algumas alterações no arquivo /etc/sysconfig/network-scripts/ifcfg-enp0s3, o comando abaixo foi usado para abrir com editor Vi.

    sudo vi /etc/sysconfig/network-scripts/ifcfg-enp0s3
    
A primeira alteração feita foi na linha:

    BOOTPROTO=dhcp
    
Alteramos para:

    BOOTPROTO=static
    
E adicionamos mais uma linha da seguinte maneira:

    PREFIX=24
    
Assim o colocamos um IP estático.
