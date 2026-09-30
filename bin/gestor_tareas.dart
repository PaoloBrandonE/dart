import 'dart:io';

// Fase 1: datos de una tarea.
class Tarea {
  String titulo;
  bool completada;
  String? categoria;

  Tarea({required this.titulo, this.categoria, this.completada = false});

  String get marca => completada ? '[X]' : '[ ]';

  String descripcion() {
    // Si no se escribio una categoria, mostramos este texto.
    String cat = categoria ?? 'Sin categoria';
    return '$marca $titulo  ($cat)';
  }
}

// Fase 2: esta tarea tambien tiene una fecha limite.
class TareaConVencimiento extends Tarea {
  String fechaVencimiento;

  TareaConVencimiento({
    required String titulo,
    required this.fechaVencimiento,
    String? categoria,
  }) : super(titulo: titulo, categoria: categoria);

  @override
  String descripcion() {
    // Aprovechamos la descripcion de Tarea y agregamos la fecha.
    return '${super.descripcion()}  vence: $fechaVencimiento';
  }
}

// Fase 3: guardar, agregar y listar las tareas.
List<Tarea> tareas = [];

String? leerTexto(String mensaje) {
  stdout.write(mensaje);
  return stdin.readLineSync()?.trim();
}

void agregarTarea() {
  String? titulo = leerTexto('Titulo de la tarea: ');
  if (titulo == null) return;
  if (titulo.isEmpty) {
    print('El titulo no puede estar vacio.');
    return;
  }
  String? entrada = leerTexto('Categoria (Enter para omitir): ');
  if (entrada == null) return;
  String? categoria = entrada.isEmpty ? null : entrada;
  tareas.add(Tarea(titulo: titulo, categoria: categoria));
  print('Tarea agregada correctamente.');
}

bool fechaValida(String fecha) {
  if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(fecha)) return false;
  List<String> partes = fecha.split('/');
  int dia = int.parse(partes[0]);
  int mes = int.parse(partes[1]);
  int anio = int.parse(partes[2]);
  if (anio < 1) return false;
  DateTime comprobacion = DateTime(anio, mes, dia);
  // DateTime ajusta fechas como 31/02; por eso comparamos sus partes.
  return comprobacion.day == dia &&
      comprobacion.month == mes &&
      comprobacion.year == anio;
}

void agregarTareaConVencimiento() {
  String? titulo = leerTexto('Titulo de la tarea: ');
  if (titulo == null) return;
  if (titulo.isEmpty) {
    print('El titulo no puede estar vacio.');
    return;
  }
  String? entrada = leerTexto('Categoria (Enter para omitir): ');
  if (entrada == null) return;
  String? categoria = entrada.isEmpty ? null : entrada;
  String? fecha = leerTexto('Fecha de vencimiento (dd/mm/aaaa): ');
  if (fecha == null) return;
  if (!fechaValida(fecha)) {
    print('Fecha invalida. Usa dd/mm/aaaa y una fecha que exista.');
    return;
  }
  tareas.add(TareaConVencimiento(
    titulo: titulo,
    categoria: categoria,
    fechaVencimiento: fecha,
  ));
  print('Tarea con vencimiento agregada correctamente.');
}

void listarTareas() {
  if (tareas.isEmpty) {
    print('No hay tareas registradas.');
    return;
  }
  print('--- LISTA DE TAREAS (${tareas.length}) ---');
  for (int i = 0; i < tareas.length; i++) {
    print('[${i + 1}] ${tareas[i].descripcion()}');
  }
}

// Fase 4: completar y eliminar usando el numero de la lista.
int? pedirIndice(String accion) {
  if (tareas.isEmpty) {
    print('No hay tareas para $accion.');
    return null;
  }
  listarTareas();
  String? entrada = leerTexto('Numero de la tarea a $accion: ');
  if (entrada == null) return null;
  int? numero = int.tryParse(entrada);
  if (numero == null || numero < 1 || numero > tareas.length) {
    print('Numero invalido.');
    return null;
  }
  // La numeracion empieza en 1, pero los indices empiezan en 0.
  return numero - 1;
}

void completarTarea() {
  int? indice = pedirIndice('completar');
  if (indice == null) return;
  if (tareas[indice].completada) {
    print('La tarea ya estaba completada.');
    return;
  }
  tareas[indice].completada = true;
  print('Tarea marcada como completada.');
}

void eliminarTarea() {
  int? indice = pedirIndice('eliminar');
  if (indice == null) return;
  Tarea eliminada = tareas.removeAt(indice);
  print('Se elimino: ${eliminada.titulo}');
}

// Fase 5: contar las tareas y agruparlas por categoria.
void verEstadisticas() {
  int completadas = 0;
  Map<String, int> porCategoria = {};
  for (Tarea tarea in tareas) {
    if (tarea.completada) completadas++;
    String categoria = tarea.categoria ?? 'Sin categoria';
    // Una categoria nueva empieza con cero antes de sumar.
    porCategoria[categoria] = (porCategoria[categoria] ?? 0) + 1;
  }
  print('--- ESTADISTICAS ---');
  print('Total de tareas : ${tareas.length}');
  print('Completadas     : $completadas');
  print('Pendientes      : ${tareas.length - completadas}');
  print('Por categoria:');
  if (porCategoria.isEmpty) print('  No hay categorias registradas.');
  porCategoria.forEach((categoria, cantidad) {
    print('  $categoria: $cantidad');
  });
}

// Fase 6: repetir el menu hasta elegir salir.
void mostrarMenu() {
  print('');
  print('===== GESTOR DE TAREAS =====');
  print('1. Agregar tarea');
  print('2. Agregar tarea con vencimiento');
  print('3. Ver tareas');
  print('4. Marcar como completada');
  print('5. Eliminar tarea');
  print('6. Ver estadisticas');
  print('0. Salir');
}

void main() {
  bool ejecutando = true;
  while (ejecutando) {
    mostrarMenu();
    String? opcion = leerTexto('Elige una opcion: ');
    // Si se cierra la entrada, salimos sin repetir el menu para siempre.
    if (opcion == null) {
      print('Fin de la entrada. Hasta pronto.');
      break;
    }
    switch (opcion) {
      case '1':
        agregarTarea();
        break;
      case '2':
        agregarTareaConVencimiento();
        break;
      case '3':
        listarTareas();
        break;
      case '4':
        completarTarea();
        break;
      case '5':
        eliminarTarea();
        break;
      case '6':
        verEstadisticas();
        break;
      case '0':
        ejecutando = false;
        print('Hasta pronto.');
        break;
      default:
        print('Opcion no valida, intenta de nuevo.');
    }
  }
}
