// lib/features/comunidad/presentation/notifiers/comunidad_notifier.dart
//
// Usa Riverpod. Si usas Provider o Bloc, ajusta el patrón pero la lógica es igual.
//
// Dependencia: flutter_riverpod (ya deberías tenerlo si lo usas en auth/eventos)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:my_secure_app/features/comunidad/data/comunidad_local_datasource.dart';
import 'package:my_secure_app/features/comunidad/data/comunidad_repository_impl.dart';
import 'package:my_secure_app/features/comunidad/models/emprendimiento_model.dart';
//import '../../data/datasources/comunidad_local_datasource.dart';
//import '../../data/models/emprendimiento_model.dart';
//import '../../data/repositories/comunidad_repository_impl.dart';

// ---------- Estado ----------
class ComunidadState {
  final List<EmprendimientoModel> todos;
  final List<EmprendimientoModel> filtrados;
  final String
  categoriaActiva; // 'all' | 'gastronomia' | 'artesania' | 'hospedaje'
  final bool isLoading;

  const ComunidadState({
    this.todos = const [],
    this.filtrados = const [],
    this.categoriaActiva = 'all',
    this.isLoading = false,
  });

  ComunidadState copyWith({
    List<EmprendimientoModel>? todos,
    List<EmprendimientoModel>? filtrados,
    String? categoriaActiva,
    bool? isLoading,
  }) {
    return ComunidadState(
      todos: todos ?? this.todos,
      filtrados: filtrados ?? this.filtrados,
      categoriaActiva: categoriaActiva ?? this.categoriaActiva,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ---------- Notifier ----------
class ComunidadNotifier extends StateNotifier<ComunidadState> {
  final ComunidadRepositoryImpl _repo;

  ComunidadNotifier(this._repo) : super(const ComunidadState()) {
    _cargarTodos();
  }

  void _cargarTodos() {
    final todos = _repo.obtenerTodos();
    state = state.copyWith(todos: todos, filtrados: todos);
  }

  void filtrarPorCategoria(String categoria) {
    final filtrados = categoria == 'all'
        ? state.todos
        : _repo.obtenerPorCategoria(categoria);

    state = state.copyWith(
      filtrados: filtrados,
      categoriaActiva: categoria,
    );
  }
}

// ---------- Provider ----------
final comunidadRepositoryProvider = Provider<ComunidadRepositoryImpl>((ref) {
  return ComunidadRepositoryImpl(
    datasource: ComunidadLocalDatasource(),
  );
});

final comunidadProvider =
    StateNotifierProvider<ComunidadNotifier, ComunidadState>((ref) {
      return ComunidadNotifier(ref.watch(comunidadRepositoryProvider));
    });
