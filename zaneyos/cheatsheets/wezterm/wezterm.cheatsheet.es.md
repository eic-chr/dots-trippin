[English](./wezterm.cheatsheet.md) | Español

# WezTerm en ZaneyOS — Resumen y Cheatsheet
## 🚀 Resumen de modules/home/terminals/wezterm.nix

- Programa
  - WezTerm habilitado con el paquete pkgs.wezterm
  - Configuración de Lua proporcionada en ~/.config/wezterm/wezterm.lua

- Apariencia y Comportamiento
  - Ocultar la barra de pestañas si solo hay una pestaña
  - Cadena de fuentes de respaldo: Maple Mono NF (delgada), Fira Code, JetBrains Mono, Hack
  - Fuente: FiraCode Regular (marco de la ventana: JetBrainsMono Nerd Font Mono); tamaño: 12
  - Esquema de colores: Catppuccin Mocha; colores personalizados de la barra de pestañas
  - Opacidad del fondo de la ventana: 0.75; relleno: 10 en todos los lados
  - Barra de pestañas elegante habilitada; fuente personalizada de window_frame
  - Cursor: BlinkingUnderline, velocidad de parpadeo 500
  - Term: xterm-256color
  - Rendimiento: max_fps 120; animation_fps 30
  - Wayland: enable_wayland = true
  - Advertencias de glifos faltantes: deshabilitadas

---

## 🗝️ Cheatsheet de Atajos de Teclado

Pestañas
- Alt+t — Crear pestaña (CurrentPaneDomain)
- Alt+w — Cerrar pestaña actual (sin confirmar)
- Alt+n — Pestaña siguiente
- Alt+p — Pestaña anterior

Paneles
- Alt+v — Dividir verticalmente
- Alt+h — Dividir horizontalmente
- Alt+q — Cerrar panel actual (sin confirmar)
- Alt+Teclas de flecha — Activar panel en la dirección de la flecha

Notas
- Lua contiene ajustes opcionales relacionados con NVIDIA comentados.
- default_prog se puede habilitar si el prompt de Starship tiene problemas de inicio.
