(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
		val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)
val only_capitals = List.filter(fn(s) => Char.isUpper(String.sub(s, 0)))

val longest_string1 = List.foldl(fn(a, b) => if String.size a > String.size b then a else b) ""

val longest_string2 = List.foldl(fn(a, b) => if String.size a >= String.size b then a else b) ""

fun longest_string_helper f lst = List.foldl(fn(a, b) => if f(String.size a, String.size b) then a else b) "" lst

val longest_string3 = longest_string_helper(fn(al, bl) => al > bl)

val longest_string4 = longest_string_helper(fn(al, bl) => al >= bl)

val longest_capitalized = longest_string3 o only_capitals

val rev_string = String.implode o List.rev o String.explode

fun first_answer f lst = let
							fun aux(li) = case li of
												[] => raise NoAnswer
											|	xs::xs' => case f(xs) of
																NONE => aux(xs')
															|   SOME n => n
						in aux(lst) end

fun all_answers f lst = let
							fun aux(li) = case li of
												[] => SOME []
											|	xs::xs' => case f(xs) of
																NONE => NONE
															|   SOME n => case aux(xs') of NONE => NONE | SOME ns => SOME (n @ ns)
						in
							aux(lst)
						end

val count_wildcards = g (fn() => 1) (fn(x) => 0)

val count_wild_and_variable_lengths = g (fn() => 1) String.size

fun count_some_var(x, p) = g (fn() => 0) (fn(s) => if x = s then 1 else 0) p

fun check_pat(p) = let
						fun varStrList(p) =
						case p of
							Variable x => [x]
						|   TupleP ps => List.foldl (fn (p,r) => (varStrList p) @ r) [] ps
						|   ConstructorP(_,p) => varStrList p
						|   _ => []
						fun isRepeat(lst) =
						case lst of
							[] => false
						|   xs::xs' => List.exists (fn(x) => x = xs) xs' orelse isRepeat(xs')
					in
						not(isRepeat(varStrList p))
					end

fun match(v: valu, p: pattern) = 
					let
						fun zip(vls: valu list, pts: pattern list) = ListPair.zip(vls, pts)
					in
						case p of
							Wildcard => SOME []
						|   Variable s => SOME [(s, v)]
						|   UnitP => (case v of Unit => SOME [] | _ => NONE)
						|   ConstP c => (case v of Const cv => if c = cv then SOME [] else NONE | _ => NONE)
						|   TupleP ps => (case v of 
												Tuple vs => if List.length(vs) = List.length(ps) then all_answers(match) (zip(vs, ps)) else NONE
											  | _ => NONE)
						|   ConstructorP(s, p') => (case v of Constructor(sv, v') => if s = sv then match(v', p') else NONE | _ => NONE)
					end

fun first_match v ps = SOME(first_answer (fn(p) => match(v, p)) ps)
						handle NoAnswer => NONE