# ¡Bienvenido a ZaneyOS! Guía para principiantes

¡Bienvenido! Esta guía es para usuarios nuevos en Nix que quieren realizar personalizaciones comunes en ZaneyOS. Mantendremos todo simple y al grano.

## Entendiendo la estructura

Para cambios cotidianos, basta con conocer algunos archivos y directorios clave:

- `flake.nix`: archivo principal del sistema. Normalmente no necesitas editarlo para cambios comunes.
- `hosts/`: configuración por equipo (host).
  - `hosts/<tu-hostname>/`:
    - `variables.nix`: panel principal para activar/desactivar funciones y cambiar opciones.
    - `host-packages.nix`: paquetes solo para ese equipo.
- `modules/`: configuración modular reutilizable.
  - `modules/core/global-packages.nix`: paquetes para todos tus equipos ZaneyOS.
  - `modules/home/hyprland/binds.nix`: personaliza atajos de Hyprland.

## Cómo añadir paquetes

Dos maneras:

### 1) Solo para un equipo
Edita `hosts/<tu-hostname>/host-packages.nix` y añade el paquete a la lista:
```nix path=null start=null
[
  brave
  (catppuccin-vsc.override {
    variant = "mocha";
  })
  cowsay
]
```
Guarda el archivo.

### 2) Para todos los equipos
Edita `modules/core/global-packages.nix` y añade el paquete igual que arriba.

## Cambiar ajustes de monitores

En `hosts/<tu-hostname>/variables.nix` busca `extraMonitorSettings`:
```nix path=null start=null
extraMonitorSettings = "monitor=DP-1,1920x1080@144";
```
Guarda el archivo.

## Cambiar atajos de Hyprland

En `modules/home/hyprland/binds.nix` puedes editar mapeos:
```nix path=null start=null
"SUPER, T, exec, ${terminal}"
```
Guarda el archivo.

## Aplicar cambios

Tras editar:
```bash path=null start=null
zcli rebuild
```
Si termina con éxito, ¡tus cambios están activos! Algunos pueden requerir reinicio.

