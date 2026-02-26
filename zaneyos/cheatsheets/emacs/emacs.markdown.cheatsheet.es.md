[English](./emacs.markdown.cheatsheet.md) | Español

# Cheatsheet de Markdown para Doom Emacs
## 📝 **Primeros Pasos**
- Abre cualquier archivo `.md` - Doom habilita automáticamente `markdown-mode`
- Obtendrás resaltado de sintaxis, sangría adecuada y características específicas de markdown

## ⌨️ **Comandos Clave de Markdown** (con atajos de Evil/Vim)

### **Formato de Texto:**
- `SPC m b` - Texto en **negrita**
- `SPC m i` - Texto en *cursiva*
- `SPC m c` - `Código en línea`
- `SPC m C` - Bloque de código
- `SPC m s` - ~~Tachado~~

### **Encabezados:**
- `SPC m h` - Insertar encabezado (solicita el nivel 1-6)
- `SPC m H` - Insertar encabezado con estilo de subrayado

### **Listas:**
- `SPC m l` - Insertar elemento de lista no ordenada
- `SPC m L` - Insertar elemento de lista ordenada

### **Enlaces e Imágenes:**
- `SPC m l l` - Insertar enlace
- `SPC m l i` - Insertar imagen
- `SPC m l u` - Insertar URL

### **Navegación:**
- `]]` - Siguiente encabezado
- `[[` - Encabezado anterior
- `SPC m o` - Abrir esquema/tabla de contenidos

## 👁️ **Vista Previa en Vivo**
- `SPC m p` - Vista previa en el navegador
- `SPC m P` - Exportar a HTML

## 📊 **Tablas**
- `SPC m t` - Comandos de tabla
- `SPC m t t` - Insertar tabla
- `TAB` - Navegar entre celdas
- `S-TAB` - Navegar hacia atrás entre celdas

## 🎯 **Atajos Útiles de Evil en Markdown**
- `TAB` - Ciclar el plegado de encabezados
- `S-TAB` - Ciclar el plegado globalmente
- `RET` - Seguir enlaces
- `M-RET` - Insertar nuevo elemento de lista

## 🧪 **Ejemplos de Prueba**

### Formato de Muestra
Este es **texto en negrita** y este es *texto en cursiva*.

Aquí hay algo de `código en línea` y un bloque de código:

```bash
# Ejemplo de bloque de código
echo "¡Hola desde markdown!"
```

### Lista de Muestra
- [ ] Elemento de casilla de verificación 1
- [x] Casilla de verificación completada
- Punto de viñeta normal

### Tabla de Muestra
| Característica | Atajo   | Descripción              |
|----------------|---------|--------------------------|
| Negrita        | SPC m b | Poner texto en negrita   |
| Cursiva        | SPC m i | Poner texto en cursiva   |
| Vista Previa   | SPC m p | Vista previa en el navegador |

## 🚀 **Consejos Profesionales**
1. Usa `SPC m o` para obtener una vista de esquema para la navegación
2. `TAB` en los encabezados para plegar/desplegar secciones
3. `RET` en los enlaces para seguirlos
4. Usa `SPC m p` para previsualizar tu markdown en un navegador
5. Crea listas de verificación con la sintaxis `- [ ]`

## 📚 **Referencia Rápida**
- Todos los comandos de markdown comienzan con `SPC m`
- Usa `SPC m ?` o `C-h m` para ver todos los comandos disponibles
- Navegación entre encabezados: `]]` (siguiente) y `[[` (anterior)
- Alternar plegado: `TAB` (local) y `S-TAB` (global)
