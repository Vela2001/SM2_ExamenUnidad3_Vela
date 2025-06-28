import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_moviles2/model/ticket_model.dart';
import 'package:proyecto_moviles2/model/usuario_model.dart';

void main() {
  // Prueba 1: Lógica de prioridad
  test('Cálculo del score de prioridad', () {
    String prioridad = 'alta';
    int score;
    switch (prioridad.toLowerCase()) {
      case 'alta':
        score = 3;
        break;
      case 'media':
        score = 2;
        break;
      case 'baja':
        score = 1;
        break;
      default:
        score = 0;
    }
    expect(score, 3);
  });

  // Prueba 2: Filtrar tickets localmente
  test('Filtrar tickets por título', () {
    final tickets = [
      Ticket(
        id: '1',
        titulo: 'Error al iniciar sesión',
        descripcion: '',
        estado: '',
        userId: '',
        usuarioNombre: '',
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now(),
        prioridad: '',
        categoria: '',
      ),
      Ticket(
        id: '2',
        titulo: 'Pantalla blanca',
        descripcion: '',
        estado: '',
        userId: '',
        usuarioNombre: '',
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now(),
        prioridad: '',
        categoria: '',
      ),
    ];

    final resultado = tickets.where((t) => t.titulo.toLowerCase().contains('error')).toList();
    expect(resultado.length, 1);
    expect(resultado.first.titulo, contains('Error'));
  });

  // Prueba 3: Verificar si un usuario es admin
  test('Verificar rol de usuario', () {
    final usuario = Usuario(
      id: 'u1',
      username: 'adminuser',
      email: 'admin@example.com',
      nombreCompleto: 'Admin',
      fechaCreacion: DateTime.now(),
      rol: 'admin',
    );

    final esAdmin = usuario.rol.toLowerCase() == 'admin';
    expect(esAdmin, true);
  });
}
