import 'package:flutter/material.dart';

class CardGame {
  final String name;
  final String description;

  const CardGame({
    required this.name,
    required this.description,
  });
}

class CardGameRules {
  static const List<CardGame> rules = [
    CardGame(
      name: '1 TRAGO',
      description: 'Elige a alguien para tomar 1 trago.',
    ),
    CardGame(
      name: '1 TRAGO',
      description: 'Elige a alguien para tomar 1 trago.',
    ),
    CardGame(
      name: '2 TRAGOS',
      description: 'Elige a una o más personas para tomar un total de 2 tragos.',
    ),
    CardGame(
      name: '3 TRAGOS',
      description: 'Elige a una o más personas para tomar un total de 3 tragos.',
    ),
    CardGame(
      name: 'CACHETES',
      description: 'Disimuladamente infla tus cachetes. El ultimo en inflarlos hace fondo blanco.',
    ),
    CardGame(
      name: 'PUTA',
      description: 'Elegí tu PUTA. Hasta que haya otra puta, debe tomar siempre que el dueño le recuerde que debe tomar ("Ej: La puta toma conmigo").',
    ),
    CardGame(
      name: 'PUTA',
      description: 'Elegí tu PUTA. Hasta que haya otra puta, debe tomar siempre que el dueño le recuerde que debe tomar ("Ej: La puta toma conmigo").',
    ),
    CardGame(
      name: 'VERDAD o RETO',
      description: 'Elige VERDAD O RETO y el resto de los participantes crearan una pregunta o reto para vos. Sino FONDO BLANCO',
    ),
    CardGame(
      name: 'BARQUITO PERUANO',
      description: '"Tengo un barquito peruano cargado de... " El que no diga una palabra relacionada al tema elegido debe tomar.',
    ),
    CardGame(
      name: 'CARTA EN LA BOCA',
      description: 'Los jugadores deben pasar una carta (Sin no hay cartas puede ser un cubo de hielo) Los jugadorxs que se les caiga, deben darse un beso y tomar.',
    ),
    CardGame(
      name: 'PASE AL BAÑO',
      description: 'Permite al jugador ir al baño sin penalización (NO SE PUEDE INTERCAMBIAR). Quien va al baño sin carta. FONDO BLANCO',
    ),
    CardGame(
      name: 'PASE AL BAÑO',
      description: 'Permite al jugador ir al baño sin penalización (NO SE PUEDE INTERCAMBIAR). Quien va al baño sin carta. FONDO BLANCO',
    ),
    CardGame(
      name: 'PALABRA PROHIBIDA',
      description: 'Se elige una palabra prohibida; cualquier jugador que la diga debe beber.',
    ),
    CardGame(
      name: 'HISTORIA',
      description: 'Empiza a contar una historia, 1 palabra por jugador, el que se olvida de la historia, FONDO BLANCO.',
    ),
    CardGame(
      name: 'REGLA',
      description: 'Con esta carta podes elegir una regla que se debe cumplir desde ahora hasta que termine el juego.',
    ),
    CardGame(
      name: 'Toma el jugador de tu DERECHA',
      description: 'El jugador que está sentado a tu derecha debe tomar un trago.',
    ),
    CardGame(
      name: 'Toma el jugador de tu IZQUIERDA',
      description: 'El jugador que está sentado a tu izquierda debe tomar un trago.',
    ),
    CardGame(
      name: 'LIMON',
      description: 'A cada jugador se le asigna un numero en orden de como están sentados y deben decir Ex: "su numero" limon; 1/2 limon; "el numero de alguien más" Limon. El que se equivoca bebe',
    ),
    CardGame(
      name: 'PREGUNTAS',
      description: 'Tenes 1 pregunta trampa, hacé una pregunta en cualquier momento de aquí en adelante y quien la responda debe beber.',
    ),
    CardGame(
      name: 'JUEGO RANDOM',
      description: 'Elige o pide ayuda para hacer un juego de los conocidos para jugar por una ronda. Ej: Yo nunca, dedo, botella, etc.',
    ),
   ];
}