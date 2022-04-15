# Shogi-App

## TODO

- METHOD:
  - [x] Complete Move Method
  - [x] Capture Method
    - [x] Piece will be in hand
  - [x] Drop Method
    - [x] Check if piece in hand
    - [x] Check if destination is empty / legal

## Other things

- [ ] Promotion
  - [x] TO (Promoted Pawn), NY (P-Lance), NK (P-Knight), NG (P-Silver)
  - [ ] UM (P-Bishop), RY (P-Rook)
- [ ] Winning Condition
- [ ] Record Reader - (KIFU)
  - [ ] Check if we can actually read document before moving on to next step
  - [ ] KIFU Format [CSA format](https://shogidb2.com/latest)
- [ ] Terminal Output/Prompt/Interface

Read CSA Format, then output to console to see if working
Then integrate with Rails

Refactor
  How to do in Rails
  Classes needed
    Users
    Game Room
      Each Room has one game
    Game
      Has logic (winning conditions)
    Peice
      Specialized Peices
        Promoted Peices
