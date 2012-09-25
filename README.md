# Introducción

Este es el software utilizado en UCSC para que los usuarios de Zimbra recuperen su contraseña de forma autónoma y para que los administradores puedan cambiar de forma fácil la contraseña de los usuarios.

Se puede visitar en http://password-reset.ucsc.cl

## Uso para Administradores
El usuario que también es administrador de Zimbra CS (atributo __zimbraIsAdminAccount__) puede ingresar a la aplicación en http://password-reset.ucsc.cl, con su dirección correo y contraseña de Zimbra.

Una vez dentro tendrá la opción de buscar usuarios, utilizando la dirección de correos, y realizar el cambio de contraseña.

## Uso para Usuarios
Los usuarios con cuenta de correo en Zimbra pueden recuperar la contraseña ingresando a http://password-reset.ucsc.cl/password_resets/new.

El procedimiento para recupera la contraseña es el siguiente:

1. Conectarse a http://password-reset.ucsc.cl/password_resets/new
2. Ingresar dirección de correo de Zimbra.
3. El sistema enviará un correo con la información para restablecer la contraseña a una dirección de correo electrónico que el usuario tiene registrada en los sistema de UCSC.
4. El correo electrónico tiene un enlace, que dura 24 horas, con el cual el usuario puede restablecer la contraseña.

# Instalación

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

1. Descargar 