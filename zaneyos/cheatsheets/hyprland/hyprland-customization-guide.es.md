# Guía para personalizar Hyprland en ZaneyOS

Esta guía ofrece una visión detallada de cómo personalizar tu experiencia con Hyprland en ZaneyOS. Veremos los archivos de configuración más importantes, qué hacen y cómo puedes editarlos.

**Aviso:** Los archivos están escritos en el lenguaje Nix. La sintaxis es estricta y cualquier error puede impedir que tu sistema se reconstruya. Edita con cuidado y sigue los ejemplos.

## Aplicar cambios

Tras editar, aplica los cambios desde una terminal:

```bash path=null start=null
zcli rebuild
```

Esto reconstruirá el sistema con tu configuración. Si hay errores, el comando fallará.

---

### `binds.nix` - Atajos de teclado

Controla atajos de teclado y ratón en Hyprland.

**Ubicación:** `modules/home/hyprland/binds.nix`

Formato: cadena con valores separados por comas: `MODIFICADOR, TECLA, ACCIÓN, VALOR`.

**Ejemplo:** Cambiar el atajo para abrir la terminal de `SUPER + Return` a `SUPER + T`.

```nix path=null start=null
# ...
    bind = [
      # ...
      "$modifier,T,exec, ${terminal}"
      # ...
    ];
# ...
```

---

### `exec-once.nix` - Aplicaciones al inicio

Lista de aplicaciones/comandos que se lanzan al iniciar Hyprland.

**Ubicación:** `modules/home/hyprland/exec-once.nix`

**Ejemplo:** Añadir `copyq` para que arranque siempre.

```nix path=null start=null
# ...
    exec-once = [
      # ...
      "pypr &" # pyprland para terminal desplegable SUPERSHIFT + T
      "copyq"
    ];
# ...
```

---

### `decoration.nix` - Decoración de ventanas

Controla bordes, sombras y desenfoque.

**Ubicación:** `modules/home/hyprland/decoration.nix`

**Ejemplo:** Aumentar el redondeo de esquinas a `10`.

```nix path=null start=null
# ...
      decoration = {
        rounding = 10;
# ...
```

---

### `env.nix` - Variables de entorno

Variables de entorno para la sesión.

**Ubicación:** `modules/home/hyprland/env.nix`

**Ejemplo:** Forzar Firefox en Wayland.

```nix path=null start=null
# ...
    env = [
      # ...
      "SDL_VIDEODRIVER, wayland"
      "MOZ_ENABLE_WAYLAND, 1"
      # ...
    ];
# ...
```

---

### `gestures.nix` - Gestos del touchpad

Control de gestos (p. ej., cambio de espacios de trabajo).

**Ubicación:** `modules/home/hyprland/gestures.nix`

**Ejemplo:** Deshabilitar el swipe de espacios:

```nix path=null start=null
# ...
      gestures = {
        workspace_swipe = 0;
# ...
```

---

### `misc.nix` - Miscelánea

Ajustes varios.

**Ubicación:** `modules/home/hyprland/misc.nix`

**Ejemplo:** Activar VRR (Variable Refresh Rate).

```nix path=null start=null
# ...
      misc = {
        # ...
        vrr = 1;
        # ...
      };
# ...
```

---

### `hyprland.nix` - Configuración principal

Ajustes generales, dispositivos de entrada y layout.

**Ubicación:** `modules/home/hyprland/hyprland.nix`

**Ejemplo:** Cambiar la distribución de teclado a `us`.

```nix path=null start=null
# ...
      input = {
        kb_layout = "us";
# ...
```

---

### `windowrules.nix` - Reglas de ventanas

Define comportamientos por aplicación (flotante, workspace, opacidad, etc.).

**Ubicación:** `modules/home/hyprland/windowrules.nix`

**Ejemplo:** Hacer que Thunar siempre flote.

```nix path=null start=null
# ...
      windowrule = [
        # ...
        "float, class:^(foot-floating)$"
        "float, class:^(Thunar)$"
        # ...
      ];
# ...
```

