import 'dart:ui';

import 'package:the_seeker/game_controller.dart';

class Enemy {

  final GameController gameController;
  int health;
  int damage;
  double speed;
  Rect enemyRect;
  bool isDead = false;

  Enemy(this.gameController, double x, double y) {
    health = 3;
    damage = 1;
    speed = gameController.tileSize * 2;
    enemyRect = Rect.fromLTWH(x, y, gameController.tileSize *1.2, gameController.tileSize *1.2);

  }

  void render(Canvas c) {
    Color color;
    switch(health) {
      case 1:
         color = Color(0xFFF06292);
         break;
      case 2:
         color =  Color(0xFFD81B60); 
         break;  
      case 3:
         color = Color(0xFF880E4F); 
         break; 
         default :
         color= Color(0xFF8BC34A);
         break;    
    }
    Paint enemyColor = Paint()..color = color;
    c.drawRect(enemyRect, enemyColor);
  }
  void update(double t) {
    if(!isDead) {
      double stepDistance = speed * t;
      Offset toPlayer = gameController.player.playerRect.center - enemyRect.center;
      if(stepDistance <= toPlayer.distance - gameController.tileSize * 1.25) {
        Offset stepToPlayer = Offset.fromDirection(toPlayer.direction, stepDistance);
        enemyRect = enemyRect.shift(stepToPlayer);
      }else {
        attack();
      }
    }
  }


void attack() {
  if(!gameController.player.isDead) {
    gameController.player.currentHealth -= damage;
  }
} 

  void onTapDown() {
    if(!isDead) {
      health--;
      if(health <= 0) {
        isDead = true;
        //score
        gameController.score++;
        if(gameController.score > gameController.storage.getInt('hghScore') ?? 0) {
          gameController.storage.setInt('highScore', gameController.score);
        }
      }
    }
  }
}