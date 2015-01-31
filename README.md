# Game of Life

The Game of Life, also known simply as Life, is a cellular automaton devised by the British 
mathematician John Horton Conway in 1970 - [Wikipedia] [1]

## Example
To see a web example of this codebase, go to http://jkotchoff-gameoflife.herokuapp.com 

[![Web demo of game of life](http://jkotchoff-gameoflife.herokuapp.com)](https://raw.githubusercontent.com/jkotchoff/game_of_life/blog/master/screenshot.png)

## Project inspiration
Pete Yandell hosted a [code retreat] [2] at Envato on August 27th in 2011 where we practised TDD pairing using the Game of Life as our problem. It was a bit tricky to bang out a solution in 45 minutes. This github project was created to think about it a bit more.

## Running this codebase

    $ git clone git@github.com:jkotchoff/game_of_life.git
    $ cd game_of_life
    $ ./world.rb --simulate sample_worlds/oscillator-blinking.gol

## Codebase thoughts
This implementations board doesn't grow. It does however, simulate patterns which is enough for now.

The performance could definitely be optimised a lot - adding bigger worlds (eg. to the Gosper Glider Gun in the sample_worlds/ directory) is horriby slow. 

It would also be interesting to test with infinity in mind - would the data type usage blow up memory allocation?

Things to consider for a future code retreat!

  [1]: http://en.wikipedia.org/wiki/Conway's_Game_of_Life "Wikipedia"
  [2]: http://notes.envato.com/developers/code-retreat/   "code retreat"  
