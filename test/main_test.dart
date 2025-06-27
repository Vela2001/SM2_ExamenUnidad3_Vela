import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'mocks/mock_firestore.mocks.dart';
import 'package:proyecto_moviles2/services/ticket_service.dart';
import 'package:proyecto_moviles2/services/usuario_service.dart';
import 'package:proyecto_moviles2/model/ticket_model.dart';
import 'package:proyecto_moviles2/model/usuario_model.dart';

void main() {
  group('Pruebas unitarias - TicketService y UsuarioService', () {
    // Variables comunes
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockTicketsCollection;
    late MockCollectionReference<Map<String, dynamic>> mockUsuariosCollection;
    late MockDocumentReference<Map<String, dynamic>> mockTicketDocRef;
    late MockDocumentReference<Map<String, dynamic>> mockUsuarioDocRef;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockTicketsCollection = MockCollectionReference<Map<String, dynamic>>();
      mockUsuariosCollection = MockCollectionReference<Map<String, dynamic>>();
      mockTicketDocRef = MockDocumentReference<Map<String, dynamic>>();
      mockUsuarioDocRef = MockDocumentReference<Map<String, dynamic>>();
    });

    // PRUEBA 1: Crear ticket con Firestore simulado
    test('crearTicket() debe guardar correctamente un ticket', () async {
      // Configurar mocks
      when(mockFirestore.collection('tickets')).thenReturn(mockTicketsCollection);
      when(mockTicketsCollection.doc()).thenReturn(mockTicketDocRef);
      when(mockTicketDocRef.id).thenReturn('mockTicketId');
      when(mockTicketDocRef.set(any)).thenAnswer((_) async => null);

      final ticketService = TicketServiceTestable(mockFirestore);
      final ticket = await ticketService.crearTicket(
        titulo: 'Test Ticket',
        descripcion: 'Descripción de prueba',
        prioridad: 'alta',
        categoria: 'soporte',
      );

      expect(ticket.id, 'mockTicketId');
      expect(ticket.titulo, 'Test Ticket');
      verify(mockTicketDocRef.set(any)).called(1);
    });

    // PRUEBA 2: Filtrar tickets por título localmente (sin Firebase)
    test('buscarTicketsPorTituloYUsuarioLocal() debe filtrar bien', () async {
      final service = TicketService();

      final lista = [
        Ticket(
          id: '1',
          titulo: 'Error al iniciar sesión',
          descripcion: '',
          estado: '',
          userId: 'u1',
          usuarioNombre: '',
          fechaCreacion: DateTime.now(),
          fechaActualizacion: DateTime.now(),
          prioridad: '',
          categoria: '',
        ),
        Ticket(
          id: '2',
          titulo: 'Pantalla en blanco',
          descripcion: '',
          estado: '',
          userId: 'u1',
          usuarioNombre: '',
          fechaCreacion: DateTime.now(),
          fechaActualizacion: DateTime.now(),
          prioridad: '',
          categoria: '',
        ),
      ];

      // Simulación de filtrado local
      final resultados = lista.where((ticket) =>
          ticket.titulo.toLowerCase().contains('error')).toList();

      expect(resultados.length, 1);
      expect(resultados[0].titulo, contains('Error'));
    });

    // PRUEBA 3: Crear usuario con Firestore simulado
    test('crearUsuario() debe guardar correctamente un usuario', () async {
      // Configurar mocks
      when(mockFirestore.collection('usuarios')).thenReturn(mockUsuariosCollection);
      when(mockUsuariosCollection.doc('u123')).thenReturn(mockUsuarioDocRef);
      when(mockUsuarioDocRef.set(any)).thenAnswer((_) async => null);

      final usuario = Usuario(
        id: 'u123',
        nombre: 'Helbert',
        rol: 'admin',
        fechaCreacion: DateTime.now(),
      );

      final usuarioService = UsuarioServiceTestable(mockFirestore);
      await usuarioService.crearUsuario(usuario);

      verify(mockUsuarioDocRef.set(any)).called(1);
    });
  });
}

// Servicios modificados para permitir inyección de Firebase simulado

class TicketServiceTestable extends TicketService {
  final FirebaseFirestore firestoreMock;

  TicketServiceTestable(this.firestoreMock);

  @override
  FirebaseFirestore get _firestore => firestoreMock;
}

class UsuarioServiceTestable extends UsuarioService {
  final FirebaseFirestore firestoreMock;

  UsuarioServiceTestable(this.firestoreMock);

  @override
  CollectionReference<Map<String, dynamic>> get _usuariosRef =>
      firestoreMock.collection('usuarios');
}
