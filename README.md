# Break-out-using-asm

## Brick Breaker Game in Assembly Language
Brick Breaker is a classic arcade game where the player must hit a ball with a paddle to eliminate all the bricks at the top of the screen. The game has multiple levels, each with increasing difficulty, and a time limit of 4 minutes. The player has three lives and must complete all the levels without losing all their lives.

The game is programmed using Assembly Language, a low-level programming language that provides direct access to the computer's hardware resources. The game's graphics are created using the VGA video display, and the sound effects are generated using the PC speaker.

## Game Rules
- The game starts with a ball on the paddle.
- The player moves the paddle left and right using the keyboard arrow keys to hit the ball.
- The ball bounces off the paddle and hits the bricks at the top of the screen.
- When a brick is hit, it disappears, and the player earns points.
- If the ball hits the bottom enclosure, the player loses a life.
- The game ends when the player loses all their lives or completes all the levels.
- The player has a maximum of 3 lives.
- The game has a time limit of 4 minutes, and the remaining time is displayed with a counter.
- The game has multiple levels, each with increasing difficulty.
- To complete a level, the player must eliminate all the bricks at the top of the screen.
## Game Controls
Use the left and right arrow keys on the keyboard to move the paddle.
Press the Spacebar key to release the ball from the paddle.
Press the Esc key to exit the game.
## Technical Details
The game is programmed using Assembly Language, which provides low-level access to the computer's hardware resources. The game's graphics are created using the VGA video display, which provides a resolution of 320x200 pixels with 256 colors. The game's sound effects are generated using the PC speaker, which produces simple beep sounds.

The game uses interrupts to handle keyboard input, timer events, and video display updates. The keyboard interrupt handler checks for arrow key input and updates the paddle position. The timer interrupt handler updates the ball position and checks for collisions with the bricks, paddle, and enclosure. The video display interrupt handler updates the screen with the current game state.

## Conclusion
The Brick Breaker game is a classic arcade game that provides a fun and challenging experience for players of all ages. The game's simple yet addictive gameplay, combined with the low-level programming techniques used to create it, makes it an impressive achievement in Assembly Language programming. With its multiple levels, time limit, and limited lives, the game offers a rewarding challenge for players who can master its mechanics.
