import 'dart:async';

import 'package:mobx/mobx.dart';

part 'pomodoro.store.g.dart';

class PomodoroStore = _PomodoroStore with _$PomodoroStore;

enum TipoIntervalo { TRABALHO, DESCANSO }

abstract class _PomodoroStore with Store {
  @observable
  TipoIntervalo tipoIntervalo = TipoIntervalo.TRABALHO;

  Timer? cronometro;

  @observable
  bool iniciado = false;

  @action
  void iniciar() {
    iniciado = true;
    cronometro = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (minutos == 0 && segundos == 0) {
        _trocarTipoIntervalo();
      } else if (segundos == 0) {
        segundos = 59;
        minutos--;
      } else {
        segundos--;
      }
    });
  }

  @action
  void parar() {
    iniciado = false;
    cronometro?.cancel();
  }

  @action
  void reniciar() {
    parar();
    minutos = estaTrabalhando() ? tempoTrabalho : tempoDescanso;
    segundos = 0;
  }

  @observable
  int minutos = 2;

  @observable
  int segundos = 0;

  @observable
  int tempoTrabalho = 2;

  @observable
  int tempoDescanso = 1;

  @action
  void incrementarTempoTrabalho() {
    tempoTrabalho++;
    if (estaTrabalhando()) {
      reniciar();
    }
  }

  @action
  void decrementarTempoTrabalho() {
    if (tempoTrabalho > 1) {
      tempoTrabalho--;
      if (estaTrabalhando()) {
        reniciar();
      }
    }
  }

  @action
  void incrementarTempoDescanso() {
    if (tempoDescanso > 1) {
      tempoDescanso++;
      if (estaDescansando()) {
        reniciar();
      }
    }
  }

  @action
  void decrementarTempoDescanso() {
    tempoDescanso--;
    if (estaDescansando()) {
      reniciar();
    }
  }

  bool estaTrabalhando() {
    return tipoIntervalo == TipoIntervalo.TRABALHO;
  }

  bool estaDescansando() {
    return tipoIntervalo == TipoIntervalo.DESCANSO;
  }

  void _trocarTipoIntervalo() {
    if (estaTrabalhando()) {
      tipoIntervalo = TipoIntervalo.DESCANSO;
      minutos = tempoDescanso;
    } else {
      tipoIntervalo = TipoIntervalo.TRABALHO;
      minutos = tempoTrabalho;
    }
    segundos = 0;
  }
}
