(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)
fun all_except_option(s: string, lst: string list) =
  case lst of
       []    => NONE
     | x::xs => if same_string(s, x)
                then SOME xs
                else case all_except_option(s, xs) of
                          NONE => NONE
                        | SOME xs' => SOME(x::xs')

fun get_substitutions1(lst, s) =
  case lst of
       [] => []
     | xs::xs' => let
                    val next = get_substitutions1(xs', s)
                  in case all_except_option(s, xs) of
                          NONE => next
                        | SOME(ss) => ss @ next
                  end

fun get_substitutions2(lst, s) =
  let
    fun aux(rs, xs) =
      case xs of
           [] => rs
         | es::es' => case all_except_option(s, es) of
                           NONE => aux(rs, es')
                         | SOME xs' => aux(rs @ xs', es')
  in aux([], lst)
  end

fun similar_names(lst, {first=f, middle=m, last=l}) =
  let
    fun produce(firstname) = {first=firstname, middle=m, last=l}
    fun h(es) = case es of
                     [] => []
                   | xs::xs' => produce(xs)::h(xs') 
  in
    produce(f)::h(get_substitutions2(lst, f))
  end
(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
fun card_color((su, rk): card) =
  case su of
    (Spades | Clubs) => Black
  | (Diamonds | Hearts) => Red

fun card_value((su, rk): card) =
  case rk of
    Num n => n
  | Ace => 11
  | (Jack | Queen | King) => 10

fun remove_card(lst: card list, c: card, e) =
  let
    fun aux(lst: card list, find: bool) =
      case lst of
        [] => if find then [] else raise e
      | xs::xs' => if xs = c andalso not find
                   then aux(xs', true)
                   else xs::aux(xs', find)
  in
    aux(lst, false)
  end

fun all_same_color(lst: card list) =
  case lst of
    [] => true
  | xs::xs' => case xs' of
                  [] => true
                | nx::nx' => if card_color(xs) = card_color(nx)
                             then all_same_color(xs')
                             else false

fun sum_cards(lst: card list) =
  case lst of
    [] => 0
  | xs::xs' => card_value(xs) + sum_cards(xs')

fun score(lst: card list, goal: int) =
  let
    val sum = sum_cards(lst)
    fun aux(s) = if s > goal then 3 * (s - goal) else goal - s
  in
    if all_same_color(lst) then aux(sum) div 2 else aux(sum)
  end

fun officiate(lst: card list, moves: move list, goal: int) =
  let
    fun aux(lst: card list, held: card list, moves: move list) =
      if sum_cards(held) > goal
      then score(held, goal)
      else
        case moves of
          [] => score(held, goal)
        | Discard(c)::mv' => aux(lst, remove_card(held, c, IllegalMove), mv')
        | Draw::mv' => case lst of
                            [] => score(held, goal)
                          | xs::xs' => aux(xs', xs::held, mv')
  in aux(lst, [], moves)
  end
