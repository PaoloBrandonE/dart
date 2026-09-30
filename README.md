# Gestor de tareas

Aplicación de consola en Dart que desarrolla el punto 5 de la Guía de Aplicación 02.

## Ejecutar

Abrir una terminal en `E:\DSII\grupal` y ejecutar:

```powershell
dart run bin/gestor_tareas.dart
```

También se puede usar `dart run`. No utiliza paquetes externos.

## Fases del código

1. Clase `Tarea`: título obligatorio, categoría opcional y estado inicial pendiente.
2. Clase `TareaConVencimiento`: hereda de `Tarea` y añade la fecha a su descripción.
3. Lista y funciones para agregar ambos tipos de tarea y mostrar la lista numerada.
4. Funciones para completar y eliminar, validando el número ingresado.
5. Estadísticas de tareas totales, completadas, pendientes y cantidades por categoría con un `Map`.
6. Menú con `while` y `switch`, con salida mediante la opción 0.

Las fases están señaladas en `bin/gestor_tareas.dart` y fueron ejecutadas progresivamente. La función `agregarTareaConVencimiento()` completa la parte que falta en el ejemplo de la guía.

## Uso

- La categoría se puede omitir con Enter.
- La fecha debe tener el formato `dd/mm/aaaa`, por ejemplo `30/09/2026`.
- Se admiten fechas pasadas, pero no fechas inexistentes.
- Los números de las tareas corresponden a la lista actual y cambian al eliminar una tarea.
- Los datos se guardan en memoria mientras el programa está abierto; al salir se pierden.

`VERIFICACION.txt` resume las comprobaciones realizadas y `ejemplo_ejecucion.txt` contiene la salida real de una sesión de prueba.

No se permiten titulos duplicados, incluso entre tareas simples y con vencimiento. Para comparar se convierten a minusculas, se reemplazan vocales con tilde y se quitan todos los espacios. El titulo mostrado conserva su escritura original.
