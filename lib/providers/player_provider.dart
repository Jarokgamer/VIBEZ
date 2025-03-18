import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:party_game_app/models/player.dart';
import 'dart:convert';

class PlayerProvider extends ChangeNotifier {
  List<Player> _players = [];
  Player? _currentPlayer;

  List<Player> get players => _players;
  Player? get currentPlayer => _currentPlayer;

  Future<void> loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playersJson = prefs.getStringList('players') ?? [];
    
    _players = playersJson
        .map((playerJson) => Player.fromJson(json.decode(playerJson)))
        .toList();
    
    notifyListeners();
  }

  Future<void> savePlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playersJson = _players
        .map((player) => json.encode(player.toJson()))
        .toList();
    
    await prefs.setStringList('players', playersJson);
  }

  void addPlayer(Player player) {
    _players.add(player);
    notifyListeners();
    savePlayers();
  }

  void removePlayer(String id) {
    _players.removeWhere((player) => player.id == id);
    notifyListeners();
    savePlayers();
  }

  void updatePlayer(Player updatedPlayer) {
    final index = _players.indexWhere((player) => player.id == updatedPlayer.id);
    if (index != -1) {
      _players[index] = updatedPlayer;
      notifyListeners();
      savePlayers();
    }
  }

  void setCurrentPlayer(String id) {
    _currentPlayer = _players.firstWhere((player) => player.id == id);
    notifyListeners();
  }

  void updateScore(String id, int points) {
    final index = _players.indexWhere((player) => player.id == id);
    if (index != -1) {
      final updatedPlayer = _players[index].copyWith(
        score: _players[index].score + points,
      );
      _players[index] = updatedPlayer;
      notifyListeners();
      savePlayers();
    }
  }

  void resetScores() {
    _players = _players.map((player) => player.copyWith(score: 0)).toList();
    notifyListeners();
    savePlayers();
  }
}