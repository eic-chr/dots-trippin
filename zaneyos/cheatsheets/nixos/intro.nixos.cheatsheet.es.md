NixOS, flakes y home-manager funcionan juntos para lograr una configuración del sistema declarativa y reproducible. Forman parte de un cambio de paradigma frente a la administración tradicional (imperativa).

## NixOS

**NixOS** es una distribución Linux construida sobre el **gestor de paquetes Nix**. A diferencia de otras distros donde instalas y configuras software manualmente, NixOS usa un **enfoque declarativo**. Escribes un solo `configuration.nix` que describe el estado completo del sistema (kernel, servicios, programas). Al "construir" y "cambiar" tu config, NixOS crea un sistema nuevo desde cero.

La clave: en lugar de modificar archivos in‑place, NixOS crea una nueva **generación**. Si algo falla, puedes **volver atrás** de forma segura a una generación previa.

## Flakes

Los **flakes** (experimentales pero muy usados) estandarizan la gestión de dependencias. Un flake es un directorio con `flake.nix` y `flake.lock`.

- `flake.nix` declara entradas (versiones de Nixpkgs, repos, etc.) y salidas (config del sistema, devshells). Todo queda **explícito**.
- `flake.lock` fija versiones exactas de todas las entradas (commits). Garantiza **reproducibilidad** bit a bit.

## Home Manager

Mientras NixOS gestiona la config del sistema (`/etc`), **Home Manager** aplica el mismo enfoque declarativo a tu entorno de usuario (`~/.config`). Gestiona shell, programas y otros ajustes de usuario con Nix.

Puede usarse solo o integrado en tu flake NixOS para la misma **reproducibilidad** y **cambios atómicos** del entorno de usuario.

## Por qué los archivos de configuración son de solo lectura

Núcleo del diseño de Nix: garantiza reproducibilidad.

NixOS construye configuraciones en el **Nix Store** (`/nix/store`), que es de solo lectura. Al reconstruir, Nix genera un conjunto nuevo de archivos y lo guarda en un directorio nuevo del Store.

En vez de escribir directamente a `~/.bashrc`, NixOS y Home Manager crean **enlaces simbólicos** desde ubicaciones conocidas hacia el archivo generado del Store.

Ventajas:

1. **Inmutabilidad:** no puedes romper el sistema editando archivos generados.
2. **Reproducibilidad:** la misma fuente genera siempre el mismo resultado.
3. **Actualizaciones/rollbacks atómicos:** cada generación es autocontenida, y cambiar entre ellas es instantáneo.
