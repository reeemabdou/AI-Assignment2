%Grid definition.
%state(Row, Col, Pathy, steps, battery)

grid([[r, e, e],
[d, f, e],
[e, e, s]]).

%grid([[r, e, d, e, e],
%[e, e, f, e, s],
%[d, e, e, e, e],
%[e, s, e, f, e]]).

get_initial_state(Matrix, state(Row, Col, [(Row, Col)], 0, 100)) :-
    nth1(Row, Matrix, R),
    nth1(Col, R, r).

check(R, C) :-
    grid(Matrix),
    length(Matrix, MaxRow),
    nth1(1, Matrix, FirstRow),
    length(FirstRow, MaxCol),

    R >= 1, R =< MaxRow,
    C >= 1, C =< MaxCol,

    nth1(R, Matrix, Row),
    nth1(C, Row, Value),
    Value \= d,
    Value \= f.



right(state(R, C, Path, Steps, Battery),
      state(R, C1, NewPath, NewSteps, NewBattery)) :-
    C1 is C + 1,
    check(R, C1),
    \+ member((R, C1), Path),
    NewBattery is Battery - 10,
    NewBattery >= 0,
    append(Path, [(R, C1)], NewPath),
    NewSteps is Steps + 1.

left(state(R, C, Path, Steps, Battery),
     state(R, C1, NewPath, NewSteps, NewBattery)) :-
    C1 is C - 1,
    check(R, C1),
    \+ member((R, C1), Path),
    NewBattery is Battery - 10,
    NewBattery >= 0,
    append(Path, [(R, C1)], NewPath),
    NewSteps is Steps + 1.

up(state(R, C, Path, Steps, Battery),
   state(R1, C, NewPath, NewSteps, NewBattery)) :-
    R1 is R - 1,
    check(R1, C),
    \+ member((R1, C), Path),
    NewBattery is Battery - 10,
    NewBattery >= 0,
    append(Path, [(R1, C)], NewPath),
    NewSteps is Steps + 1.

down(state(R, C, Path, Steps, Battery),
     state(R1, C, NewPath, NewSteps, NewBattery)) :-
    R1 is R + 1,
    check(R1, C),
    \+ member((R1, C), Path),
    NewBattery is Battery - 10,
    NewBattery >= 0,
    append(Path, [(R1, C)], NewPath),
    NewSteps is Steps + 1.

next_state(State, NextState) :-
    right(State, NextState);
    left(State, NextState);
    up(State, NextState);
    down(State, NextState).


is_goal(state(R, C, _, _, _)) :-
    grid(Matrix),
    nth1(R, Matrix, Row),
    nth1(C, Row, Value),
    Value = s.


bfs([State | _], _, State) :-
    is_goal(State).

bfs([State | Rest], Visited, GoalState) :-
    findall(
        NextState,
        (
            next_state(State, NextState),
            \+ member(NextState, Visited)
        ),
        Children
    ),
    append(Rest, Children, NewQueue),
    bfs(NewQueue, [State | Visited], GoalState).


solve_part1 :-
    grid(Matrix),
    get_initial_state(Matrix, Initial),

    bfs([Initial], [], Solution),

    Solution = state(_, _, Path, Steps, Battery),

    write('Path found : '), write(Path), nl,
    write('Number of Steps: '), write(Steps), nl,
    write('Remaining Battery: '), write(Battery), nl.
