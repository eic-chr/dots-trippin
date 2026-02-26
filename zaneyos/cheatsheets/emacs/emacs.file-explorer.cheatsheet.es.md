[English](./emacs.file-explorer.cheatsheet.md) | Español

# Cheatsheet del Explorador de Archivos de Doom Emacs
## 🗂️ **¿Qué es Dired?**

Dired (Directory Editor) es el gestor de archivos incorporado de Emacs que te permite navegar, gestionar y manipular archivos y directorios de manera eficiente.
- Navega por los directorios con el teclado
- Marca, copia, mueve y elimina archivos
- Ejecuta comandos en múltiples archivos a la vez
- Se integra con otras herramientas y búferes de Emacs

## 📋 **Requisitos**
- Doom Emacs (Dired está incorporado)
- **Treemacs**: Debe estar habilitado en `~/.doom.d/init.el` (descomenta la línea `treemacs`)
- Herramientas opcionales para una funcionalidad mejorada:
  - `rsync` - Sincronización y copia rápida de archivos
  - `fd` o `find` - Búsqueda de archivos mejorada
  - `rg` (ripgrep) o `ag` (the_silver_searcher) - Búsqueda rápida de texto
  - `exa` o `lsd` - Listados de directorios mejorados
  - `trash-cli` - Eliminación segura de archivos a la papelera
  - `zip`/`unzip`, `tar`, `gzip` - Manejo de archivos comprimidos

## ⌨️ **Abriendo Exploradores de Archivos**

### **Dired (Gestor de Archivos Incorporado):**
- `SPC .` - **Abrir Dired** en el directorio actual
- `SPC f d` - **Buscar directorio** (abrir Dired en una ruta específica)
- `C-x d` - **Abrir Dired** (atajo clásico de Emacs)

### **Navegación de Archivos del Proyecto:**
- `SPC SPC` - **Buscar archivo** en el proyecto
- `SPC f f` - **Buscar archivo** en cualquier lugar
- `SPC f r` - **Archivos recientes**
- `SPC p f` - **Buscar archivo** en el proyecto

### **Exploradores en Estilo de Árbol:**
- `SPC o p` - **Alternar barra lateral del proyecto** (Treemacs)
- `SPC f t` - **Buscar archivo** en el árbol

## 🧭 **Navegación en Dired**

### **Movimiento Básico:**
- `j/k` o `n/p` - **Moverse arriba/abajo** entre archivos
- `h` - **Subir** un directorio (padre)
- `l` o `RET` - **Entrar en el directorio** o abrir archivo
- `^` - **Ir al directorio padre**
- `g` - **Refrescar** el listado del directorio

### **Saltando:**
- `gg` - **Ir al principio** del listado
- `G` - **Ir al final** del listado
- `/` - **Buscar** por nombre de archivo/directorio
- `SPC s s` - **Buscar dentro** del directorio

### **Información del Archivo:**
- `(` - **Alternar detalles** (mostrar/ocultar información del archivo)
- `s` - **Ordenar** archivos (por nombre, fecha, tamaño)
- `C-h m` - **Mostrar ayuda** para el modo actual

## 📁 **Operaciones con Archivos**

### **Abriendo Archivos:**
- `RET` - **Abrir archivo** en la ventana actual
- `o` - **Abrir archivo** en otra ventana
- `C-o` - **Abrir archivo** en otra ventana (mantener el cursor en Dired)
- `v` - **Ver archivo** (solo lectura)
- `f` - **Buscar archivo** (igual que RET)

### **Creando Archivos y Directorios:**
- `+` - **Crear directorio**
- `SPC f c` - **Crear archivo** (cuando estás en el búfer de Dired)
- `C-x C-f` - **Buscar/crear archivo** (desde Dired)

## 🏷️ **Marcando Archivos**

### **Marcado Básico:**
- `m` - **Marcar archivo** para operaciones
- `u` - **Desmarcar archivo**
- `U` - **Desmarcar todos** los archivos
- `t` - **Alternar marcas** (marcar los no marcados, desmarcar los marcados)
- `* %` - **Marcar por patrón** de expresión regular

### **Marcado Rápido:**
- `* .` - **Marcar por extensión** (ej., *.txt)
- `* /` - **Marcar directorios**
- `* @` - **Marcar enlaces simbólicos**
- `* *` - **Marcar ejecutables**

### **Marcado Avanzado:**
- `% m` - **Marcar archivos** que coincidan con una expresión regular
- `% d` - **Marcar para eliminar** archivos que coincidan con una expresión regular
- `* c` - **Cambiar marcas** (cambiar una marca por otra)

## ✂️ **Operaciones de Gestión de Archivos**

### **Copiar, Mover, Eliminar:**
- `C` - **Copiar** archivos marcados (o el archivo bajo el cursor)
- `R` - **Renombrar/Mover** archivos marcados
- `D` - **Eliminar** archivos marcados inmediatamente
- `d` - **Marcar para eliminar** (usa `x` para ejecutar)
- `x` - **Ejecutar eliminaciones** (eliminar archivos marcados con `d`)

### **Opciones de Eliminación:**
- `d` y luego `x` - **Eliminación segura** (marcar primero, luego ejecutar)
- `D` - **Eliminación inmediata** (omite el paso de marcar)
- **Integración con la papelera**: Si `trash-cli` está instalado, los archivos van a la papelera en lugar de ser eliminados permanentemente

### **Operaciones Avanzadas:**
- `Z` - **Comprimir/descomprimir** archivos (usa `gzip`, `zip`, `tar` automáticamente)
- `A` - **Buscar** en archivos marcados (usa `grep` o `rg` si está disponible)
- `Q` - **Consultar y reemplazar** en archivos marcados
- `!` - **Ejecutar comando de shell** en archivos marcados
- `&` - **Ejecutar comando de shell asíncrono** en archivos marcados

## 📋 **Copiando y Moviendo**

### **Operaciones de Copia:**
- `C` - **Copiar archivos** (solicita el destino)
- Funciona con archivos marcados o un solo archivo bajo el cursor
- Usa `rsync` si está disponible para una copia más rápida y reanudable
- Admite la copia a diferentes unidades/particiones

### **Operaciones de Mover/Renombrar:**
- `R` - **Renombrar/Mover** archivos
- Puede renombrar archivos individuales o mover múltiples archivos marcados
- Admite el movimiento entre directorios

### **Consejos para Copiar/Mover:**
- Marca múltiples archivos primero, luego usa `C` o `R`
- El autocompletado con Tab funciona para las rutas de destino
- Usa rutas relativas (`.`, `..`) para una navegación rápida

## 🔍 **Búsqueda y Filtro**

### **Encontrando Archivos:**
- `/` - **Buscar** nombres de archivo en el listado actual
- `n/N` - **Siguiente/anterior** coincidencia de búsqueda

### **Búsqueda Mejorada (con herramientas externas):**
- `A` - **Buscar dentro de los archivos** (usa `rg` > `ag` > `grep` en orden de prioridad)
- Mucho más rápido con `ripgrep` o `the_silver_searcher`
- Admite patrones de expresiones regulares y filtrado por tipo de archivo

### **Filtrando la Visualización:**
- `(` - **Alternar** vista detallada
- `s` - **Ordenar** por diferentes criterios
- `C-u s` - **Ordenar** con opciones personalizadas

### **Búsqueda de Contenido:**
- `A` - **Buscar dentro** de los archivos marcados
- `Q` - **Consultar y reemplazar** en los archivos marcados

## 🔧 **Características Avanzadas**

### **Wdired (Dired Editable):**
- `C-x C-q` - **Editar nombres de archivo** directamente (como renombrar)
- Edita los nombres de archivo como texto, luego `C-c C-c` para aplicar los cambios
- `C-c C-k` para cancelar las ediciones

### **Múltiples Ventanas:**
- `o` - **Abrir en otra ventana**
- `C-o` - **Mostrar en otra ventana** (permanecer en Dired)
- `2` - **Dividir la ventana** verticalmente para dos vistas de Dired

### **Subdirectorios:**
- `i` - **Insertar subdirectorio** en el mismo búfer
- `$` - **Ocultar/mostrar** el contenido del subdirectorio
- `M-$` - **Ocultar todos** los subdirectorios

## 📊 **Comparación de Archivos**

### **Operaciones de Diferencias:**
- `=` - **Comparar archivo** con otro
- `M-=` - **Comparar** archivos marcados entre sí
- Funciona con herramientas de diferencias externas

## 🗜️ **Operaciones con Archivos Comprimidos**

### **Compresión y Archivos:**
- `Z` - **Comprimir/descomprimir** detecta automáticamente el formato
- Admite: `.gz`, `.zip`, `.tar`, `.tar.gz`, `.tar.xz`, `.7z`
- Usa las herramientas apropiadas: `gzip`, `zip`, `tar`, `7z`

### **Visualización de Archivos Comprimidos:**
- Abre archivos `.zip`, `.tar`, etc. directamente para navegar por su contenido
- Extrae archivos específicos de los archivos comprimidos

## 🎛️ **Personalización y Ajustes**

### **Opciones de Vista:**
- `(` - **Alternar** entre vista simple y detallada
- `s` - **Ciclar** entre los órdenes de clasificación (nombre, fecha, tamaño)
- Listados mejorados con `exa` o `lsd` si están disponibles

### **Ajustes Útiles:**
- Dired reutiliza los búferes por defecto en Doom
- Actualización automática al cambiar los archivos
- Integración con los atajos de teclado del modo Evil

## ⚡ **Treemacs (Explorador en Árbol)**

### **Treemacs Básico:**
- `SPC o p` - **Alternar** la barra lateral de Treemacs
- `j/k` - **Navegar** arriba/abajo en el árbol
- `RET` - **Abrir archivo** o expandir/contraer directorio
- `TAB` - **Expandir/contraer** directorio

### **Operaciones de Archivo en Treemacs:**
- `cf` - **Crear archivo**
- `cd` - **Crear directorio**
- `R` - **Renombrar**
- `d` - **Eliminar**
- `yy` - **Copiar** la ruta al portapapeles

## 🚀 **Flujo de Trabajo de Inicio Rápido**

### **Gestión Básica de Archivos:**
1. **Presiona `SPC .`** - Abre Dired en el directorio actual
2. **Navega con `j/k`** - Muévete entre los archivos
3. **Marca archivos con `m`** - Selecciona múltiples archivos
4. **Usa `C` para copiar** o `R` para mover/renombrar
5. **Presiona `g`** para refrescar cuando termines

### **Operaciones de Archivo Eficientes:**
1. **Marca múltiples archivos** con `m`
2. **Ejecuta operaciones por lotes** (`C` para copiar, `R` para mover)
3. **Usa `!`** para ejecutar comandos de shell en los archivos marcados
4. **Alterna los detalles con `(`** para más/menos información

## 📚 **Resumen de Atajos Esenciales**

| Acción | Tecla | Descripción |
|--------|-----|-------------|
| Abrir Dired | `SPC .` | Abrir explorador de archivos |
| Navegar | `j/k` | Moverse arriba/abajo |
| Entrar/Abrir | `RET` o `l` | Abrir archivo/directorio |
| Directorio Padre | `h` o `^` | Subir un directorio |
| Marcar | `m` | Marcar archivo para operaciones |
| Copiar | `C` | Copiar archivos marcados |
| Mover/Renombrar | `R` | Mover o renombrar archivos |
| Eliminar | `d` y luego `x` | Marcar para eliminar, ejecutar |
| Crear Directorio | `+` | Crear nuevo directorio |
| Comprimir | `Z` | Comprimir/descomprimir |
| Buscar en Archivos | `A` | Buscar dentro de los archivos |
| Refrescar | `g` | Refrescar el listado del directorio |
| Ayuda | `?` | Mostrar comandos disponibles |

## 🔧 **Solución de Problemas**

### **Problemas Comunes:**
- **¿El búfer de Dired no se actualiza?** Presiona `g` para refrescar
- **¿No puedes ver los detalles del archivo?** Presiona `(` para alternar la vista detallada
- **¿Las operaciones son lentas?** Usa el marcado (`m`) para operaciones por lotes
- **¿Orden de clasificación incorrecto?** Presiona `s` para ciclar entre las opciones de clasificación

### **Consejos de Rendimiento:**
- Instala `fd` para una búsqueda de archivos más rápida
- Instala `rg` (ripgrep) para una búsqueda de texto más rápida
- Usa `rsync` para una copia de archivos eficiente
- Considera `exa` o `lsd` para listados de directorios mejorados

### **Obteniendo Ayuda:**
- `?` - **Ayuda contextual** en cualquier búfer de Dired
- `C-h m` - **Ayuda específica del modo**
- `SPC h d f dired` - **Documentación completa de Dired**

## 📋 **Comparación: Dired vs Treemacs**

### **Usa Dired cuando:**
- Gestionas múltiples archivos a la vez
- Necesitas información detallada de los archivos
- Realizas operaciones por lotes
- Trabajas con permisos/propiedad de archivos

### **Usa Treemacs cuando:**
- Necesitas una vista rápida del proyecto
- Navegación de archivos simple
- Prefieres una estructura de árbol visual
- Necesitas una barra lateral persistente

## 🛠️ **Integración con Herramientas Externas**

### **Herramientas Recomendadas:**
- **`rsync`** - Copia de archivos rápida y fiable con capacidad de reanudación
- **`ripgrep` (rg)** - Búsqueda de texto extremadamente rápida, mucho más rápida que grep
- **`fd`** - Alternativa rápida a find con mejores valores predeterminados
- **`exa`** - Reemplazo moderno de ls con colores e integración con git
- **`trash-cli`** - Eliminación segura a la papelera en lugar de eliminación permanente
- **`7z`** - Maneja archivos 7zip y otros formatos de compresión

### **Instalación (Debian/Ubuntu):**
```bash
sudo apt install rsync ripgrep fd-find exa trash-cli p7zip-full
```

## 🎯 **Consejos Profesionales**

- **Operaciones por lotes**: Marca los archivos primero (`m`), luego ejecuta las operaciones
- **Navegación rápida**: Usa `/` para buscar archivos por nombre
- **Editar nombres de archivo**: Usa `C-x C-q` para el modo Wdired para renombrar múltiples archivos
- **Integración con la shell**: Usa `!` para ejecutar comandos de shell en los archivos
- **Múltiples directorios**: Usa `i` para mostrar subdirectorios en el mismo búfer
- **Eliminación segura**: Instala `trash-cli` para enviar archivos a la papelera en lugar de eliminarlos permanentemente
- **Búsqueda rápida**: Instala `ripgrep` para una búsqueda de texto ultrarrápida en los archivos

Dired proporciona una experiencia completa de gestión de archivos que se integra bien con herramientas externas de Linux, haciendo que las operaciones con archivos sean eficientes y potentes.
