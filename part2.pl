%Grid definition.
%state(Row, Col, Pathy, steps, survivors)

grid([[r, e, s],
[d, f, e],
[e, s, e]]).

%grid([[r, e, d, e, e],
%[e, e, f, e, s],
%[d, e, e, e, d],
%[e, s, e, f, s]]).

get_initial_state(Matrix, state(Row, Col, [(Row, Col)], 0, 0)) :-
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



right(state(R, C, Path, Steps, Survivors),
      state(R, C1, NewPath, NewSteps, NewSurvivors)) :-
    C1 is C + 1,
    check(R, C1),
    \+ member((R, C1), Path),
    grid(Matrix),
    nth1(R, Matrix, Row),
    nth1(C1, Row, Value),
     ( Value = s ->
        NewSurvivors is Survivors + 1
    ;
        NewSurvivors is Survivors
    ),
    append(Path, [(R, C1)], NewPath),
    NewSteps is Steps + 1.

left(state(R, C, Path, Steps, Survivors),
     state(R, C1, NewPath, NewSteps, NewSurvivors)) :-
    C1 is C - 1,
    check(R, C1),
    \+ member((R, C1), Path),
    grid(Matrix),
    nth1(R, Matrix, Row),
    nth1(C1, Row, Value),
    ( Value = s ->
        NewSurvivors is Survivors + 1
    ;
        NewSurvivors is Survivors
    ),
    append(Path, [(R, C1)], NewPath),
    NewSteps is Steps + 1.

up(state(R, C, Path, Steps, Survivors),
   state(R1, C, NewPath, NewSteps, NewSurvivors)) :-
    R1 is R - 1,
    check(R1, C),
    \+ member((R1, C), Path),
    grid(Matrix),
    nth1(R1, Matrix, Row),
    nth1(C, Row, Value),
    ( Value = s ->
        NewSurvivors is Survivors + 1
    ;
        NewSurvivors is Survivors
    ),
    append(Path, [(R1, C)], NewPath),
    NewSteps is Steps + 1.

down(state(R, C, Path, Steps, Survivors),
     state(R1, C, NewPath, NewSteps, NewSurvivors)) :-
    R1 is R + 1,
    check(R1, C),
    \+ member((R1, C), Path),
    grid(Matrix),
    nth1(R1, Matrix, Row),
    nth1(C, Row, Value),
    ( Value = s ->
        NewSurvivors is Survivors + 1
    ;
        NewSurvivors is Survivors
    ),
    append(Path, [(R1, C)], NewPath),
    NewSteps is Steps + 1.

next_state(State, NextState) :-
    right(State, NextState);
    left(State, NextState);
    up(State, NextState);
    down(State, NextState).


heuristic(state(_, _, _, _, Survivors), Survivors).

greedy([], Visited, Visited).

greedy(Open, Visited, Result) :-
    pick_best(Open, Current),
    Current = state(_, _, _, _, S),
    count_survivors(Total),
    S =:= Total,
    !,
    Result = [Current|Visited].

greedy(Open, Visited, Result) :-

    pick_best(Open, Current),
    remove(Current, Open, NewOpen),

    findall(Next,
        (next_state(Current, Next),
         \+ member(Next, Visited)
         ),
    Children),
    append(NewOpen, Children, UpdatedOpen),

    greedy(UpdatedOpen, [Current|Visited], Result).

count_survivors(Total) :-
    grid(Matrix),
    findall(s, (member(Row, Matrix), member(s, Row)), Survivors),
    length(Survivors, Total).

pick_best([Best], Best).

pick_best([H|T], Best) :-
    pick_best(T, BestTail),
    heuristic(H, S1),
    heuristic(BestTail, S2),
    (S1 >= S2 ->
        Best = H
    ;
        Best = BestTail
    ).

remove(X, [X|T], T).

remove(X, [H|T], [H|R]) :-
    remove(X, T, R).

solve :-
    grid(Matrix),
    get_initial_state(Matrix, Initial),
    greedy([Initial], [], Solution),
    pick_best(Solution, BestState),
    BestState = state(_, _, Path, Steps, Survivors),
    write('Path found: '), write(Path), nl,
    write('Survivors rescued: '), write(Survivors), nl,
    write('Number of steps: '), write(Steps), nl.
