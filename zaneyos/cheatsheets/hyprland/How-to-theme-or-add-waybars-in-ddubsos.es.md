# Cómo tematizar o añadir Waybars en ZaneyOS

Esta guía muestra cómo ZaneyOS selecciona y configura Waybar, cómo añadir tu propio módulo de Waybar y cómo personalizar fuentes, tamaños, colores, iconos, widgets y layout. También indica dónde colocar scripts y una nota crítica sobre git add para evitar fallos de rebuild.

## Módulos Waybar disponibles
Guardados en modules/home/waybar/:
- waybar-tony.nix
- waybar-ddubs.nix
- waybar-ddubsos-v1.nix
- waybar-dwm.nix
- waybar-curved.nix
- waybar-simple.nix
- waybar-ddubs-2.nix
- waybar-mecha.nix
- waybar-dwm2.nix
- waybar-nekodyke.nix
- Jerry-waybar.nix

## Dónde seleccionas tu Waybar
Selecciona el módulo en hosts/default/variables.nix vía waybarChoice. Ejemplo (extracto real):
```nix path=/home/dwilliams/ZaneyOS/hosts/default/variables.nix start=73
  # Set Waybar
  # Includes alternates such as:
  # Comment out the current choice and uncomment the one you want
  #waybarChoice = ../../modules/home/waybar/waybar-curved.nix;
  #waybarChoice = ../../modules/home/waybar/Jerry-waybars.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-simple.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-mecha.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-nekodyke.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;
  waybarChoice = ../../modules/home/waybar/waybar-tony.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs-2.nix;
```
Notas:
- Asegúrate de que la ruta coincide con un archivo real bajo modules/home/waybar/. Por ejemplo, la lista incluye Jerry-waybar.nix (singular) pero el comentario muestra Jerry-waybars.nix (plural). Usa el nombre correcto para evitar errores de build.

## CRÍTICO: usa git add o fallará el rebuild
Cuando añadas un archivo Waybar o scripts que use, debes prepararlos con git antes de reconstruir, o Nix no verá esas rutas y fallará la build.
- Ejemplo:
```bash path=null start=null
# Añade tu módulo y scripts
git add modules/home/waybar/my-waybar.nix modules/home/waybar/scripts/my-widget.sh
# Commit (opcional pero recomendado)
git commit -m "Add my Waybar module and widget script"
```

## Cómo están estructurados los módulos Waybar aquí
- Exponen un módulo de Home Manager que define programs.waybar.settings (config estilo JSON) y programs.waybar.style (CSS).
- Copian scripts auxiliares a ~/.config/waybar/scripts desde un directorio compartido scripts.

Ejemplo: waybar-tony.nix copia scripts y define config y CSS de Waybar:
```nix path=/home/dwilliams/ZaneyOS/modules/home/waybar/waybar-tony.nix start=15
  # Configure & Theme Waybar (Tony)
  home.file = builtins.listToAttrs (map
    (name: {
      name = ".config/waybar/scripts/" + name;
      value = {
        source = "${scriptsDir}/${name}";
        executable = true;
      };
    })
    scripts);

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        modules-left = [
          "custom/startmenu" "hyprland/workspaces" "custom/sep" "tray" "custom/sep" "hyprland/window" "custom/sep"
        ];
        modules-center = [ "custom/sep" "idle_inhibitor" "custom/notification" "custom/sep" ];
        modules-right = [ "custom/sep" "pulseaudio" "network" "cpu" "memory" "clock" "custom/sep" "custom/power" ];
        # ... component configs ...
      }
    ];
    style = concatStrings [
      ''
        @define-color bg    #1a1b26;
        @define-color fg    #a9b1d6;
        * { font-family: "JetBrainsMono Nerd Font", monospace; font-size: 16px; font-weight: bold; }
        window#waybar { background-color: @bg; color: @fg; }
        #workspaces button { padding: 0 6px; color: @cyn; }
        #clock { color: @cyn; border-bottom: 4px solid @cyn; }
        #pulseaudio { color: @blu; border-bottom: 4px solid @blu; }
        #idle_inhibitor.activated { color: @grn; border-bottom: 4px solid @grn; }
      ''
    ];
  };
```
Puntos clave:
- El layout se controla con modules-left, modules-center y modules-right.
- La configuración de cada módulo (p. ej., hyprland/workspaces, pulseaudio) va en el mismo objeto.
- El CSS controla tipografías, tamaños, colores, bordes y espaciado.
- scriptsDir = ./scripts relativo al archivo; se instalan en ~/.config/waybar/scripts y se marcan como ejecutables.

## Añadir tu propio Waybar (paso a paso)
1) Copia un módulo como base:
```bash path=null start=null
cp modules/home/waybar/waybar-simple.nix modules/home/waybar/my-waybar.nix
```
2) (Opcional) Añade scripts auxiliares en modules/home/waybar/scripts/.
3) Apunta variables.nix a tu módulo:
```nix path=/home/dwilliams/ZaneyOS/hosts/default/variables.nix start=81
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;
  waybarChoice = ../../modules/home/waybar/waybar-tony.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs-2.nix;
```
Cámbialo a:
```nix path=null start=null
waybarChoice = ../../modules/home/waybar/my-waybar.nix;
```
4) Prepara los archivos antes de reconstruir (crítico):
```bash path=null start=null
git add modules/home/waybar/my-waybar.nix modules/home/waybar/scripts/*
```
5) Reconstruye como siempre.

## Ejemplos de personalización
1) Cambiar tipografía y tamaño (CSS)
```css path=/home/dwilliams/ZaneyOS/modules/home/waybar/waybar-tony.nix start=207
* {
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 16px;
    font-weight: bold;
}
```
2) Mover widgets izquierda/centro/derecha
```nix path=/home/dwilliams/ZaneyOS/modules/home/waybar/waybar-simple.nix start=28
modules-center = [ "hyprland/workspaces" ];
modules-left = [ "custom/startmenu" "custom/arrow6" "pulseaudio" "cpu" "memory" "idle_inhibitor" "custom/arrow7" "hyprland/window" ];
modules-right = [ "custom/arrow4" "custom/hyprbindings" "custom/arrow3" "custom/notification" "custom/arrow3" "custom/power" "battery" "custom/arrow2" "tray" "custom/arrow1" "clock" ];
```
3) Cambiar colores y estilos de botones
```css path=/home/dwilliams/ZaneyOS/modules/home/waybar/waybar-tony.nix start=218
#workspaces button {
    padding: 0 6px;
    color: @cyn;
    background: transparent;
    border-bottom: 3px solid @bg;
}
#workspaces button.active {
    color: @cyn;
    border-bottom: 3px solid @mag;
}
```
4) Añadir iconos o cambiar etiquetas
```nix path=/home/dwilliams/ZaneyOS/modules/home/waybar/waybar-ddubs.nix start=104
"pulseaudio" = {
  format = "{icon} {volume}% {format_source}";
  format-icons = {
    headphone = "";
    default = [ "" "" "" ];
  };
};
```
5) Añadir un widget que ejecute un script
```nix path=null start=null
"custom/mywidget" = {
  exec = "~/.config/waybar/scripts/my-widget.sh";
  return-type = "json";
  interval = 5;
  format = "{}";
  on-click = "kitty -e my-tool";
};
```
6) Hacer la barra flotante o acoplada
```nix path=null start=null
settings = [
  {
    layer = "top";
    position = "top";
    mode = "overlay";
    # ...
  }
];
```
```css path=null start=null
window#waybar {
  background: rgba(0, 0, 0, 0.6);
  margin: 6px 10px;
  border-radius: 12px;
}
```

## Dónde guardar scripts usados por widgets
```nix path=/home/dwilliams/ZaneyOS/modules/home/waybar/waybar-ddubs.nix start=14
home.file = builtins.listToAttrs (map (name: {
  name = ".config/waybar/scripts/" + name;
  value = { source = "${scriptsDir}/${name}"; executable = true; };
}) scripts);
```
Copia todo desde ./scripts a ~/.config/waybar/scripts y marca ejecutable.

## Solución de problemas
- Fallo de ruta: asegúrate de hacer git add de los archivos nuevos.
- Nombre incorrecto en variables.nix: usa exactamente el nombre real.
- Iconos faltan: instala una Nerd Font (p. ej., JetBrainsMono Nerd Font) y selecciónala en CSS.
- Widgets faltan: confírmalos en modules-left/center/right y su bloque de config.

## Receta rápida
1) Crea modules/home/waybar/my-waybar.nix (copia uno y edítalo)
2) Añade scripts en modules/home/waybar/scripts/
3) En variables.nix:
```nix path=null start=null
waybarChoice = ../../modules/home/waybar/my-waybar.nix;
```
4) git add de los archivos
5) Reconstruye.
