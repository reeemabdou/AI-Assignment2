%Grid definition.
%state(Row, Col, Pathy, steps, battery)

grid([
    [r,s,s],
    [e,e,e],
    [e,s,e]
]).

get_initial_state(Matrix, state(Row, Col, [], 0, 100)) :-
    nth1(Row, Matrix, R),
    nth1(Col, R, r).


check(R, C) :-
   grid(Matrix),
   length(Matrix, MaxRow),
   nth1(1, Matrix, FirstRow),
   length(FirstRow, MaxCol),
   nth1(R, Matrix, Row),
   nth1(C, Row, Value),
   Value \= d,
   Value \= f,
   R >= 1, R =< MaxRow,
   C >= 1, C =< MaxCol.
    


right(state(R, C, Path, Steps, Battery), state(R, C1, NewPath, Newsteps, NewBattery)) :-
    C1 is C + 1,
    check(R, C1),
    \+ member((R, C1), Path),
    append(Path, [(R, C1)], NewPath),
    Newsteps is Steps + 1,
    NewBattery is Battery - 10.

left(state(R, C, Path, Steps, Battery), state(R, C1, NewPath, Newsteps, NewBattery)) :-
    C1 is C - 1,
    check(R, C1),
    \+ member((R, C1), Path),
    append(Path, [(R, C1)], NewPath),
    Newsteps is Steps + 1,
    NewBattery is Battery - 10.

up(state(R, C, Path, Steps, Battery), state(R1, C, NewPath, Newsteps, NewBattery)) :-
    R1 is R - 1,
    check(R1, C),
    \+ member((R1, C), Path),
    append(Path, [(R1, C)], NewPath),
    Newsteps is Steps + 1,
    NewBattery is Battery - 10.


down(state(R, C, Path, Steps, Battery), state(R1, C, NewPath, Newsteps, NewBattery)) :-
    R1 is R + 1,
    check(R1, C),
    \+ member((R1, C), Path),
    append(Path, [(R1, C)], NewPath),
    Newsteps is Steps + 1,
    NewBattery is Battery - 10.



