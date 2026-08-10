import 'package:bingo/core/data/models/booklet.dart';
import 'package:bingo/ui/bingo/bloc/bingo_event.dart';
import 'package:bingo/ui/bingo/bloc/bingo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameTypeBloc extends Bloc<GameTypeEvent, GameTypeState> {
  GameTypeBloc()
      : super(GameTypeState(
          aditional: 0,
          counter: 0,
          booklets: [],
          precioPorCartilla: 0,
          total: 0,
        )) {

    on<SelectAditional>((event, emit) {
      //int newCounter = (event.aditional == 2) ? 1 : 0;
      int newCounter = state.counter;

      // Si se selecciona progresivo, empieza en 1
      if (event.aditional == 2 && state.aditional != 2) newCounter = 1;

      // Si se cambia a normal o promocional, progresivo se reinicia
      if (event.aditional != 2) newCounter = 0;

      emit(state.copyWith(
        aditional: event.aditional,
        counter: newCounter,
        total: _calculateTotal(
          aditional: event.aditional,
          counter: newCounter,
          booklets: state.booklets,
          price: state.precioPorCartilla,
        ),
      ));
    });

    on<IncrementCounter>((event, emit) {
      if (state.aditional == 2) {
        const maxLimit = 10;

        int newCounter = state.counter + 1;

        // Limitar al máximo según día
        if (newCounter > maxLimit) newCounter = maxLimit;
        emit(state.copyWith(
          counter: newCounter,
          total: _calculateTotal(
            aditional: state.aditional,
            counter: newCounter,
            booklets: state.booklets,
            price: state.precioPorCartilla,
          ),
        ));
      }
    });

    on<DecrementCounter>((event, emit) {
      if (state.aditional == 2 /*&& state.counter > 1*/) {
        int newCounter = state.counter - 1;
        if (newCounter < 1) newCounter = 1;
        emit(state.copyWith(
          counter: newCounter,
          total: _calculateTotal(
            aditional: state.aditional,
            counter: newCounter,
            booklets: state.booklets,
            price: state.precioPorCartilla,
          ),
        ));
      }
    });

    on<ChangeCounter>((event, emit) {
      if (state.aditional == 2) {
        int newCounter = event.counter;
        if (newCounter < 1) newCounter = 1;

        const maxLimit = 10;
        if (newCounter > maxLimit) newCounter = maxLimit;

        emit(state.copyWith(
          counter: newCounter,
          total: _calculateTotal(
            aditional: state.aditional,
            counter: newCounter,
            booklets: state.booklets,
            price: state.precioPorCartilla,
          ),
        ));
      }
      /*int newCounter = event.counter;
      if (state.aditional != 2) newCounter = 0;
      if (state.aditional == 2 && newCounter < 1) newCounter = 1;

      emit(state.copyWith(
        counter: newCounter,
        total: _calculateTotal(
          aditional: state.aditional,
          counter: newCounter,
          booklets: state.booklets,
          price: state.precioPorCartilla,
        ),
      ));*/
    });

    on<UpdateBooklets>((event, emit) {
      emit(state.copyWith(
        booklets: event.booklets,
        total: _calculateTotal(
          aditional: state.aditional,
          counter: state.counter,
          booklets: event.booklets,
          price: state.precioPorCartilla,
        ),
      ));
    });

    on<SetPrecioPorCartilla>((event, emit) {
      emit(state.copyWith(
        precioPorCartilla: event.precio,
        total: _calculateTotal(
          aditional: state.aditional,
          counter: state.counter,
          booklets: state.booklets,
          price: event.precio,
        ),
      ));
    });
  }

  int _calculateTotal({
    required int aditional,
    required int counter,
    required List<Booklet> booklets,
    required double price,
  }) {
    double total = 0;

    switch (aditional) {
      case 0:
        for (var b in booklets) {
          if (b.estado ?? false) total += price;
        }
        break;
      case 2:
        /*for (var b in booklets) {
          if (b.estado ?? false) total += (price * counter) + price;
        }*/
        for (var b in booklets) {
          if (b.estado ?? false) total += price * (counter + 1);
        }
        break;
      default:
        total = 0;
    }

    return total.toInt();
  }
}
