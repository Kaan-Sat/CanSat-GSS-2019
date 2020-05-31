# GSS-2019

Software de Estación Terrena utilizado durante la competencia CanSat CUCEI 2019. El software esta desarrollado con Qt para proveer soporte multiplataforma y reducir las dependencias durante una eventual instalación.

## Compilación

Para compilar el proyecto, se necesita descargar e instalar [Qt](https://qt.io/download). Una vez que se haya instalado Qt, abra el archivo `CanSat-GSS.pro` en Qt Creator, seleccione el kit apropiado y presione el botón de compilar.

Alternativamente, abra una terminal (Linux/macOS) y ejecute los siguientes comandos:

        mkdir build
        cd build
        qmake ../
        make -j4
        
## Autores

- [Alex Spataru](https://github.com/alex-spataru)

## Licencia

Este proyecto esta distribuido bajo los terminos y condiciones de la licencia MIT, para más información, haga clic [aquí](LICENSE.md).
