Español | [English](./emacs.nix.cheatsheet.md)

# Guía Rápida: Doom Emacs + Nix

Esta guía enumera los comandos de Nix y los atajos configurados en tu Doom Emacs.

## Requisitos
- Módulo de Doom habilitado: `(nix +tree-sitter +lsp)` en `~/.doom.d/init.el`
- Paquetes instalados (en `~/.doom.d/packages.el`): `nix`, `nix-update`, `nixos-options`
- Herramientas Nix disponibles en el sistema: `nix`, `nixfmt` (o tu formateador preferido)
- Opcional pero recomendado: `nil` (LSP de Nix)

## Convenciones de teclas (Leader)
- `SPC` = tecla líder de Doom
- `SPC m` = menú del modo mayor (contextual al buffer actual, p. ej., buffers Nix)

## Atajos para Nix
- `SPC m f` → `nix-format-buffer` — Formatea el buffer Nix actual (usa `nixfmt` por defecto)
- `SPC m b` → `nix-build` — Construye la derivación/expresión actual
- `SPC m s` → `nix-shell` — Abre un `nix-shell`
- `SPC m u` → `nix-unpack` — Desempaqueta una fuente de Nix
- `SPC m r` → `nix-repl-show` — Muestra información de símbolo en el REPL de Nix
- `SPC m U` → `nix-update-fetch` — Actualiza fetchers/hashes en expresiones Nix
- `SPC m o` → `+nix/lookup-option` — Busca una opción de NixOS (requiere `:tools lookup` y `nixos-options`)

## Referencia de comandos
- `nix-format-buffer`: Formatea el buffer usando `nixfmt`.
  - Configuración: `(setq nix-nixfmt-bin "nixfmt")`.
  - Consejo: ¿Prefieres otro formateador? Instálalo y ajusta `nix-nixfmt-bin` (p. ej., `"alejandra"` o `"nixpkgs-fmt"`).
- `nix-build`: Inicia una construcción para el archivo/contexto actual.
- `nix-shell`: Abre un shell de desarrollo derivado de la expresión Nix actual.
- `nix-unpack`: Desempaqueta la fuente de una derivación (útil para inspeccionar fuentes).
- `nix-repl-show`: Muestra información de símbolo desde una sesión del REPL de Nix.
- `nix-update-fetch`: Actualiza atributos de fetcher (rev, sha256, etc.).
- `+nix/lookup-option`: Salta a la documentación de una opción de NixOS usando la integración con `nixos-options`.

## Consejos
- Asegúrate de estar editando un archivo `.nix` para que `SPC m` (modo mayor) esté disponible.
- Para funciones LSP (documentación, autocompletado, diagnósticos), verifica que el servidor `nil` esté instalado y activo.

## Solución de problemas
- ¿Comandos no disponibles en Emacs? Ejecuta `~/.emacs.d/bin/doom sync` y reinicia Emacs.
- ¿El formateador no funciona? Verifica que `nixfmt` (u otro) esté en tu PATH y que `nix-nixfmt-bin` coincida con su nombre.
- ¿La búsqueda de opciones no funciona? Asegúrate de tener `nixos-options` instalado y que `:tools lookup` esté habilitado en Doom.

