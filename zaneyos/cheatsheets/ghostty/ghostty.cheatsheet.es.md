[English](./ghostty.cheatsheet.md) | Español

# Ghostty en ZaneyOS — Resumen y Cheatsheet
## 🚀 Resumen de modules/home/terminals/ghostty.nix

- Programa
  - Ghostty habilitado con el paquete de Nix: pkgs.ghostty
  - Integraciones de shell: Fish, Zsh, Bash
  - clearDefaultKeybinds = true (todos los atajos se definen explícitamente a continuación)

- Apariencia
  - Título: ZaneyOS-GhosTTY
  - TERM: xterm-256color
  - Tema: oscuro: catppuccin-mocha; claro: catppuccin-mocha
  - Tema de la ventana: oscuro
  - Fuente: Maple Mono NF, tamaño 12
  - Ajuste de altura de celda: +10%
  - Opacidad del fondo: 1.00 (opaco)
  - Radio de desenfoque del fondo: 60
  - Estilo del cursor: barra
  - Colores de selección: fondo #2d3f76, frente #c8d3f5
  - Opacidad de división sin foco: 0.5
  - Posición de terminal rápida: centro

- Ventana y Comportamiento
  - Tamaño de ventana predeterminado: 110x32 (columnas x filas)
  - Confirmar cierre de superficie: false
  - Esperar después del comando: false
  - Integración de shell: detectar; características: cursor, sudo
  - Estado de guardado de ventana: siempre
  - Instancia única de GTK: true
  - Ratón: ocultar al escribir: true

- Atajos de Teclado (esquema de prefijo Super/Alt)
  - El acorde personalizado tipo líder usa Alt+s y luego la tecla, ej. alt+s>c
  - Portapapeles estándar y tamaño de fuente con acordes Ctrl+Shift
  - Pestañas, divisiones, navegación, zoom, ecualizar definidos a continuación

---

## 🗝️ Cheatsheet de Atajos de Teclado

Portapapeles
- Ctrl+Shift+C — copy_to_clipboard
- Ctrl+Shift+V — paste_from_clipboard

Tamaño de fuente
- Ctrl+Shift+= (más) — increase_font_size:1
- Ctrl+Shift+- (menos) — decrease_font_size:1
- Ctrl+Shift+0 — reset_font_size

Sesión
- Alt+s r — reload_config
- Alt+s x — close_surface
- Alt+s n — new_window

Pestañas
- Alt+s c — new_tab
- Alt+s Shift+L — next_tab
- Alt+s Shift+H — previous_tab
- Alt+s , — move_tab:-1
- Alt+s . — move_tab:+1
- Alt+s 1..9 — goto_tab:N

Divisiones
- Alt+s \ — new_split:right
- Alt+s - — new_split:down
- Alt+s j — goto_split:bottom
- Alt+s k — goto_split:top
- Alt+s h — goto_split:left
- Alt+s l — goto_split:right
- Alt+s z — toggle_split_zoom
- Alt+s e — equalize_splits

Notas
- clearDefaultKeybinds = true significa que solo los anteriores están activos.
- La notación Alt+s> denota un acorde de dos teclas: mantén presionado Alt, presiona s, luego la siguiente tecla.

---

## ⚙️ Referencia de Opciones Predeterminadas (según configuración)

Terminal y ventana
- term: xterm-256color
- window-width: 110
- window-height: 32
- window-theme: dark
- window-save-state: always
- gtk-single-instance: true
- quick-terminal-position: center

Apariencia
- theme: catppuccin-mocha (oscuro y claro mapeados a mocha)
- font-family: Maple Mono NF
- font-size: 12
- adjust-cell-height: 10%
- background-opacity: 1.00
- background-blur-radius: 60
- selection-background: #2d3f76
- selection-foreground: #c8d3f5
- cursor-style: bar
- unfocused-split-opacity: 0.5

Comportamiento
- confirm-close-surface: false
- mouse-hide-while-typing: true
- wait-after-command: false
- shell-integration: detect
- shell-integration-features: cursor,sudo

Integraciones
- Integraciones de Fish, Zsh, Bash habilitadas

---

## 📝 Notas de Estilo/Formato

Este cheatsheet refleja el estilo de tus cheatsheets de Emacs:
- Encabezados de sección claros con emoji
- Listas con viñetas con descripciones concisas
- Bloques cortos de "Notas" para comportamientos especiales

Si lo deseas, puedo enlazar esto desde un índice central o agregar más consejos de Ghostty (temas, indicadores de rendimiento, solución de problemas).
