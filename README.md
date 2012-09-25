# Introducción

Este es el software utilizado en UCSC para que los usuarios de Zimbra recuperen su contraseña de forma autónoma y para que los administradores puedan cambiar de forma fácil la contraseña de los usuarios.

Se puede visitar en http://cambioclave.ucsc.cl

## Uso para Administradores
El usuario que también es administrador de Zimbra CS (atributo __zimbraIsAdminAccount__) puede ingresar a la aplicación en http://cambioclave.ucsc.cl, con su dirección correo y contraseña de Zimbra.

Una vez dentro tendrá la opción de buscar usuarios, utilizando la dirección de correos, y realizar el cambio de contraseña.

## Uso para Usuarios
Los usuarios con cuenta de correo en Zimbra pueden recuperar la contraseña ingresando a http://cambioclave.ucsc.cl/password_resets/new.

El procedimiento para recupera la contraseña es el siguiente:

1. Conectarse a http://cambioclave.ucsc.cl/password_resets/new
2. Ingresar dirección de correo de Zimbra.
3. El sistema enviará un correo con la información para restablecer la contraseña a una dirección de correo electrónico que el usuario tiene registrada en los sistema de UCSC.
4. El correo electrónico tiene un enlace, que dura 24 horas, con el cual el usuario puede restablecer la contraseña.

# Instalación
La aplicación está construida con el Framework Ruby on Rails. A continuación se indican los pasos para instalar y configurarla.

## Configuración de S.O.
Esta herramienta fue desarrollada para trabajar con CentOS/Red Hat 5 o superior.
Se debe realizar la siguiente configuración del Sistema Operativo.

### Configuración de Repositorios

1. Instalar repositorio EPEL: http://fedoraproject.org/wiki/EPEL/es
2. Instalar repositorio de Nodejs: https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager

### Instalación de Software Base

1. Instalar Puppet
```bash
yum install puppet -y
```

### Configuración de Dependencias

####1. Descargar y descomprir tgz de la aplicación:
```bash
curl -L -k https://github.com/pbruna/zimbra_password_reset/tarball/master > zimbra_password_reset.tgz
```

####2. Copiar contenido del directorio puppet a /etc/puppet
```bash
cp -a pbruna-zimbra_password_reset-f07e8cf/puppet/* /etc/puppet/
```

####3. Configurar sistema con puppet
```bash
puppet apply /etc/puppet/manifests/default.pp
```

Este proceso puede demorar un buen tiempo, ya que debe descargar una serie de paquetes desde Internet.

_Puede ser necesario ejecutarlo dos veces, debes ver la siguiente salida_
```bash
notice: /Stage[main]/Rvm_setup/Rvm_system_ruby[ruby-1.9.3-p0]/ensure: created
notice: /Stage[main]/Rvm_setup/Rvm_gemset[ruby-1.9.3-p0@rails-3.2]/ensure: created
notice: /Stage[main]/Rvm_setup/Rvm_gem[ruby-1.9.3-p0@rails-3.2/rails]/ensure: created
```

####4. Instalar Aplicación
```bash
cp -a pbruna-zimbra_password_reset-c91d4cd/Rails_App/ /home/itlinux/
chown itlinux.itlinux -R /home/itlinux/
sudo su - itlinux
cd Rails_App/ZimbraPasswordReset/ # Aceptar la pregunta
bundle
bundle install --binstubs
```