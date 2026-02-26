[English](./emacs.code-completion.cheatsheet.md) | Español

# Cheatsheet de Autocompletado y Búsqueda de Código en Doom Emacs
## 🚀 **Lo que Tienes (Como nvim-cmp + blink.cmp)**

Si tu configuración de Doom incluye:
- **Company Mode** - Framework de autocompletado
- **LSP Mode** - Soporte para el Protocolo de Servidor de Lenguaje
- **Tree-sitter** - Análisis de sintaxis avanzado
- **Herramientas de búsqueda** - Búsqueda de documentación y definiciones

## ⌨️ **Autocompletado de Código (Company)**

### **Controles de Autocompletado:**
- `TAB` o `C-SPC` - **Aceptar autocompletado**
- `C-n` / `j` - **Siguiente autocompletado** (modo evil)
- `C-p` / `k` - **Anterior autocompletado** (modo evil)
- `C-w` - **Mostrar documentación** para el autocompletado
- `C-s` - **Buscar/filtrar autocompletados**
- `ESC` o `C-g` - **Cancelar autocompletado**

### **Autocompletado Manual:**
- `M-/` - **Completar en el punto** (disparador manual)
- `C-M-/` - **Expandir abreviatura**

## 🔍 **Búsqueda y Navegación de Código**

### **Ir a Definición/Referencias:**
- `gd` - **Ir a la definición** (modo evil)
- `gD` - **Ir a la declaración**
- `gr` - **Ir a las referencias**
- `SPC c d` - **Buscar definición**
- `SPC c D` - **Buscar referencias**
- `SPC c i` - **Buscar implementaciones**

### **Búsqueda de Documentación:**
- `K` - **Buscar documentación** (modo evil)
- `SPC c k` - **Buscar documentación**
- `SPC c K` - **Buscar en conjuntos de documentos**
- `C-h f` - **Describir función**
- `C-h v` - **Describir variable**

### **Navegación de Símbolos:**
- `SPC c j` - **Saltar a símbolo en el búfer**
- `SPC c J` - **Saltar a símbolo en el proyecto**
- `SPC s i` - **Buscar símbolo**

## 🛠️ **Características de LSP (Servidor de Lenguaje)**

### **Acciones de LSP:**
- `SPC c a` - **Acciones de código** (refactorizar, arreglar, etc.)
- `SPC c r` - **Renombrar símbolo**
- `SPC c f` - **Formatear búfer/región**
- `SPC c o` - **Organizar importaciones**

### **Navegación de Errores:**
- `]e` - **Siguiente error**
- `[e` - **Error anterior**
- `SPC c x` - **Listar errores**

### **Información de LSP:**
- `SPC c l` - **Menú de LSP**
- `SPC c h` - **Mostrar información al pasar el ratón**
- `SPC c s` - **Mostrar firma**

## 🎯 **Características Específicas del Lenguaje**

### **C/C++ (clang-tools)**
- Autocompletado completo para funciones, variables, tipos
- Ir a la definición a través de archivos
- Comprobación de errores y diagnósticos
- Formateo de código con clang-format

### **Nix (nil LSP)**
- Autocompletado del lenguaje Nix
- Documentación de funciones
- Comprobación de sintaxis
- Ir a la definición para expresiones de Nix

### **JSON (vscode-json-languageserver)**
- Autocompletado basado en esquemas
- Validación y comprobación de errores
- Ir a la definición en archivos JSON

## ⚡ **Consejos Profesionales**

### **Búsqueda Difusa en Todo:**
- `SPC f f` - **Buscar archivos**
- `SPC /` - **Buscar en el proyecto**
- `SPC s s` - **Buscar en el búfer**
- `SPC p p` - **Cambiar de proyecto**

### **Mejor Navegación:**
- `C-o` - **Retroceder** (después de saltar a la definición)
- `C-i` - **Avanzar**
- `SPC j j` - **Saltar a un carácter** (como easymotion)

### **Ajustes de Autocompletado:**
- Los autocompletados aparecen después de 0.2 segundos de escribir
- Mínimo 1 carácter para activarse
- Muestra la documentación en una ventana emergente
- Funciona tanto con Company como con LSP

## 🔧 **Solución de Problemas**

### **Si el autocompletado no funciona:**
1. Comprueba si el servidor LSP se está ejecutando: `SPC c l`
2. Reinicia LSP: `SPC c l r`
3. Comprueba si hay errores de sintaxis: `SPC c x`

### **Rendimiento:**
- Los servidores LSP se inician automáticamente cuando abres archivos compatibles
- El autocompletado está optimizado para una respuesta rápida
- Usa `SPC h r r` para recargar la configuración de Doom después de los cambios

## 🚀 **Flujo de Trabajo de Inicio Rápido**

1. **Abre un archivo de código** (`.c`, `.nix`, `.json`)
2. **Empieza a escribir** - los autocompletados aparecen automáticamente
3. **Navega con `j/k`** y **acepta con `TAB`**
4. **Usa `gd`** para saltar a las definiciones
5. **Usa `K`** para ver la documentación
6. **Usa `SPC c a`** para acciones de código

## 📚 **Servidores de Lenguaje Incluidos**
- **C/C++**: `clang-tools` (clangd)
- **Nix**: `nil`
- **JSON**: `vscode-json-languageserver`
- ¡Se pueden añadir más por lenguaje según sea necesario!
