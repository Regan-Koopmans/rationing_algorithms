% Ration what is asked for an distribute remainder equally

:- use_module(library(lists)).

distribute(_, Count, List, Result) :- Count = 0, Result = List.
distribute(Portion, Count, [H|T], [H2|T2])
    :- 
        H2 is H + Portion,
        C2 is Count - 1,
        distribute(Portion, C2, T, T2).

next_lowest_divisor(Amount, Divisor, Result)
    :- 
        0 =:= mod(Amount, Divisor), Divisor = Result ; 
        0 \= mod(Amount, Divisor), D2 is Divisor - 1,
        next_lowest_divisor(Amount, D2, Result), !.

distribute_remainder(Remainder, Demands, Rationing)
    :- 
        length(Demands, Length),
        (0 is Remainder mod Length,
        Portion is Remainder / Length,
        distribute(Portion, Length, Demands, Rationing) ;
        \+ 0 is mod(Remainder, Length), 
        next_lowest_divisor(Remainder, Length, Divisor),
        Portion is Remainder / Divisor,
        distribute(Portion, Divisor, Demands, Rationing)).

ration(_, Demands, Rationing)               
    :- 
        Demands = [], Rationing = []. % If there are no demands, there is no rationing

ration(Amount, Demands, Rationing) 
    :- 
        sum_list(Demands, TotalDemand), 
        Amount >= TotalDemand, 
        Remainder is Amount - TotalDemand, 
        distribute_remainder(Remainder, Demands, Rationing).
