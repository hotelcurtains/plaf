
(* ******************************************** *)
(** Basic functions on finite automata *)
(* ******************************************** *)
(**
   Code stub for assignment 1
*)

type symbol = char
type input = char list

type state = string

(* transition function *)
type tf = (state * symbol * state) list

(* initial state * transition function * end state *)
type fa = { states: state list; start:state; tf: tf; final: state list}


(* ******************************************** *)
(* Examples of automata *)
(* ******************************************** *)

let a = {states = ["q0";"q1";"q2"];
         start = "q0";
         tf = [("q0",'a',"q1"); ("q1",'b',"q1"); ("q1",'c',"q2")];
         final = ["q2"]}

let a2 = {states = ["q0";"q1";"q2";"q3";"q4"];
          start = "q0";
          tf = [("q0",'a',"q1"); ("q1",'b',"q1")
               ; ("q1",'c',"q2");  ("q3",'a',"q4")];
          final= ["q2"]
         }

let a4 = {states = ["q0";"q1";"q2";"q3"];
         start = "q0";
         tf = [("q0",'a',"q1"); ("q1",'b',"q1")
              ; ("q1",'c',"q2");  ("q0",'a',"q3")];
         final= ["q2";"q3"]
        }

let tf_of_a = [("q0",'a',"q1"); ("q1",'b',"q1"); ("q1",'c',"q2")]



(* ******************************************** *)
(* Helper functions *)
(* ******************************************** *)

let input_of_string s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []


(* ******************************************** *)
(* Simulating automata *)
(* ******************************************** *)

(* 
Applies the transition function f to the symbol sym,
assuming that the current state is st and the FA is deterministic. 
apply_transition_function : tf -> state -> symbol -> state option
*)
let rec apply_transition_function f st sym =
  match f with
  | [] -> None
  | (qi,s,qf)::t when qi = st && s = sym -> Some qf
  | _::t -> apply_transition_function t st sym

(* 
Check whether a word is accepted or recognized by a FA.
accept : fa -> input -> bool
*)
let rec accept fa word = 
  (* state option -> input -> state option *)
  let rec run qo word =
    match word with
    | [] -> qo
    | h::t -> 
      match apply_transition_function fa.tf qo h with
      | Some qf -> run qf t
      | None -> qo
  in List.mem (run fa.start word) fa.final

(* 
Returns the list of all the states that are successors of the given state
with the given symbol.
next : tf -> state -> symbol -> state list
*)
let rec next tf q l =
  match tf with
  | [] -> []
  | (qi,s,qf)::t when qi = q && l = s -> qf::next t q l
  | _::t -> next t q l

(*
Checks whether the given automaton is deterministic or not.
is_deterministic : fa -> bool
*)
let rec is_deterministic fa =
  let rec test q = 
    match q with
    | [] -> true
    | (qi,s,qf)::t -> 
      List.for_all (fun (x,y,z) -> not (x=qi && y=s && z<>qf)) t && test t
  in
  test fa.tf
