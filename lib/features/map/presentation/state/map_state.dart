class MapState {
  bool showTramos;
  bool showHitos;
  bool showEventos;
  bool showEmprendimientos;

  MapState({
    this.showTramos = false,
    this.showHitos = false,
    this.showEventos = false,
    this.showEmprendimientos = false,
  });

  MapState copyWith({
    bool? showTramos,
    bool? showHitos,
    bool? showEventos,
    bool? showEmprendimientos,
  }) {
    return MapState(
      showTramos: showTramos ?? this.showTramos,
      showHitos: showHitos ?? this.showHitos,
      showEventos: showEventos ?? this.showEventos,
      showEmprendimientos:
          showEmprendimientos ?? this.showEmprendimientos,
    );
  }
}