(* Homework3 Simple Test*)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

val test1 = only_capitals ["A","B","C"] = ["A","B","C"]
val test101 = only_capitals ["a","B","C"] = ["B","C"]
val test102 = only_capitals ["Abc","ABc","abC"] = ["Abc","ABc"]
val test103 = only_capitals ["1AB","?AB","Abc","ABc","abC"] = ["Abc","ABc"]

val test2 = longest_string1 ["A","bc","C"] = "bc"
val test201 = longest_string1 ["A","bc","C", "de"] = "bc"
val test202 = longest_string1 ["A","bc","C", "def"] = "def"

val test3 = longest_string2 ["A","bc","C"] = "bc"
val test301 = longest_string2 ["A","bc","C", "de"] = "de"
val test302 = longest_string2 ["A","bc","C", "def"] = "def"

val test4a = longest_string3 ["A","bc","C"] = "bc"
val test4a1 = longest_string3 ["A","bc","C", "de"] = "bc"
val test4a2 = longest_string3 ["A","bc","C", "def"] = "def"

val test4b = longest_string4 ["A","B","C"] = "C"
val test4b1 = longest_string4 ["A","bc","C", "de"] = "de"
val test4b2 = longest_string4 ["A","bc","C", "def"] = "def"

val test5 = longest_capitalized ["A","bc","C"] = "A"
val test501 = longest_capitalized [] = ""
val test502 = longest_capitalized ["ab", "a", "b"] = ""

val test6 = rev_string "abc" = "cba"
val test601 = rev_string "" = ""

val test7 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4
val test701 = first_answer (fn x => if x > 3 then SOME x else NONE) [4,2,3,5] = 4
val test702 = (first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3] ; false) handle NoAnswer => true
val test7022 = (first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3] ; false) handle OtherException => true
val test703 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,2] = 4

val test8 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE
val test801 = all_answers (fn x => if x = 2 then SOME [x] else NONE) [3,2,4,5,6,7] = NONE
val test802 = all_answers (fn x => if x mod 2 = 0 then SOME [x] else NONE) [2,4,5,6,8] = NONE
val test803 = all_answers (fn x => if x mod 2 = 0 then SOME [x] else NONE) [2,4,6,8] = SOME [2,4,6,8]
val test804 = all_answers (fn x => if x mod 2 = 0 then SOME [x, x + 1] else NONE) [2,4,6,8] = SOME [2,3,4,5,6,7,8,9]
val test805 = all_answers (fn x => if x mod 2 = 0 then SOME [] else NONE) [2,4,6,8] = SOME []
val test806 = all_answers (fn x => if x mod 2 = 0 then SOME [x] else NONE) [] = SOME []

val test9a = count_wildcards Wildcard = 1
val test9a01 = count_wildcards (Variable "str") = 0
val test9a02 = count_wildcards (TupleP [Wildcard, ConstP 12, Wildcard]) = 2
val test9a03 = count_wildcards (ConstructorP("pattern", (TupleP [Wildcard, ConstP 12, Wildcard]))) = 2

val test9b = count_wild_and_variable_lengths (Variable("a")) = 1
val test9b01 = count_wild_and_variable_lengths Wildcard = 1
val test9b02 = count_wild_and_variable_lengths (TupleP [Wildcard, ConstP 12, Wildcard]) = 2
val test9b03 = count_wild_and_variable_lengths (TupleP [Wildcard, Variable "str", Wildcard]) = 5
val test9b04 = count_wild_and_variable_lengths (TupleP [Wildcard, Variable "str", Wildcard, Variable "str2"]) = 9
val test9b05 = count_wild_and_variable_lengths (ConstructorP("pattern", (TupleP [Wildcard, ConstP 12, Wildcard]))) = 2
val test9b06 = count_wild_and_variable_lengths (ConstructorP("pattern", (TupleP [Wildcard, Variable "str", Wildcard]))) = 5

val test9c = count_some_var ("x", Variable("x")) = 1
val test9c01 = count_some_var ("x", (TupleP [Wildcard, ConstP 12, Wildcard])) = 0
val test9c02 = count_some_var ("x", (TupleP [Wildcard, Variable "str", Wildcard])) = 0
val test9c03 = count_some_var ("x", (TupleP [Wildcard, Variable "x", Wildcard])) = 1
val test9c04 = count_some_var ("x", (TupleP [Wildcard, Variable "x", Wildcard, Variable "x"])) = 2
val test9c05 = count_some_var ("x", (ConstructorP("pattern", (TupleP [Wildcard, Variable "x", Wildcard])))) = 1
val test9c06 = count_some_var ("x", (ConstructorP("x", (TupleP [Wildcard, Variable "x", Wildcard])))) = 1

val test10 = check_pat (Variable("x")) = true
val test1001 = check_pat (TupleP [Wildcard, Variable "x", Wildcard]) = true
val test1002 = check_pat (TupleP [Wildcard, Variable "x", Variable "y"]) = true
val test1003 = check_pat (TupleP [Wildcard, Variable "x", Variable "x"]) = false
val test1004 = check_pat (ConstructorP("x", (TupleP [Wildcard, Variable "x", Wildcard]))) = true
val test1005 = check_pat (ConstructorP("x", (TupleP [Wildcard, Variable "x", ConstructorP("y", Variable "y")]))) = true
val test1006 = check_pat (ConstructorP("x", (TupleP [Wildcard, Variable "x", ConstructorP("y", Variable "x")]))) = false
val test1007 = check_pat (ConstructorP("x", (TupleP [Wildcard, Variable "x", ConstructorP("y", TupleP [Variable "y"])]))) = true
val test1008 = check_pat (ConstructorP("x", (TupleP [Wildcard, Variable "x", ConstructorP("y", TupleP [Variable "z"])]))) = true
val test1009 = check_pat (ConstructorP("x", (TupleP [Wildcard, Variable "x", ConstructorP("y", TupleP [Variable "x"])]))) = false
val test1010 = check_pat (ConstructorP("x", (ConstructorP("y", TupleP [Variable "x", Variable "y"])))) = true
val test1011 = check_pat (ConstructorP("x", (ConstructorP("y", TupleP [Variable "x", Variable "x"])))) = false
val test1012 = check_pat (TupleP [Wildcard, Variable "x", TupleP [Variable "y"]]) = true

val test11 = match (Const(1), UnitP) = NONE
val test1101 = match (Const(1), ConstP 1) = SOME []
val test1102 = match (Const(1), Variable "s") = SOME [("s", Const(1))]
val test1103 = match (Const(1), TupleP [Wildcard]) = NONE
val test1104 = match (Const(1), TupleP [ConstP 1]) = NONE
val test1105 = match (Tuple [Unit], TupleP [UnitP]) = SOME []
val test1106 = match (Tuple [Tuple [Unit]], TupleP [TupleP[UnitP]]) = SOME []
val test1107 = match (Tuple [Tuple [Unit]], TupleP [TupleP[UnitP, Variable "x"]]) = NONE
val test1108 = match (Tuple [Const(1), Tuple [Unit]], TupleP [ConstP 1, TupleP[UnitP]]) = SOME []
val test1109 = match (Tuple [Const(1), Tuple [Unit, Const(2)]], TupleP [ConstP 1, TupleP[UnitP, Variable("s")]]) = SOME [("s", Const(2))]
val test1110 = match (Tuple [Const(1), Tuple [Unit, Const(2)]], TupleP [ConstP 2, TupleP[UnitP, Variable("s")]]) = NONE
val test1111 = match (Tuple [Const(1), Tuple [Unit, Const(2)]], TupleP [ConstP 1, TupleP[UnitP, Variable("s"), Wildcard]]) = NONE

val test12 = first_match Unit [UnitP] = SOME []
val test1201 = first_match Unit [Variable ("s")] = SOME [("s", Unit)]
val test1202 = first_match (Tuple [Const(1), Tuple [Unit, Const(2)]]) [(TupleP [ConstP 1, TupleP[UnitP, Variable("s")]])] = SOME [("s", Const(2))]
(* val test1203 = first_match (Tuple [Const(1), Tuple [Unit, Const(2)]]) [(TupleP [ConstP 1, TupleP[UnitP, ConstP 3]])] = NONE *)