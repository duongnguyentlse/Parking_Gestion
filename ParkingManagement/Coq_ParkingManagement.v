From Coq Require Import Arith List String Bool.
Import ListNotations.

Module Type ParkingSystem.

  (* Types de données *)
  Parameter VehicleType : Type.
  Parameter Vehicle : Type.
  Parameter Ticket : Type.
  Parameter Parking : Type.

  (* Constructeurs *)
  Parameter mkVehicle : string -> VehicleType -> nat -> nat -> Vehicle.
  Parameter mkTicket : nat -> nat -> option nat -> Vehicle -> nat -> option nat -> Ticket.
  Parameter mkParking : list Ticket -> bool -> Parking.

  (* Fonctions d'accès *)
  Parameter get_tickets : Parking -> list Ticket.
  Parameter get_accessible : Parking -> bool.
  Parameter get_ticket_id : Ticket -> nat.
  Parameter get_entry_time : Ticket -> nat.
  Parameter get_exit_time : Ticket -> option nat.
  Parameter get_vehicle : Ticket -> Vehicle.
  Parameter get_amount_due : Ticket -> nat.
  Parameter get_fine : Ticket -> option nat.
  Parameter get_vehicle_type : Vehicle -> VehicleType.

  (* Fonctions pour gérer le parking *)
  Parameter add_ticket : Parking -> Ticket -> Parking.
  Parameter remove_ticket : Parking -> nat -> Parking.
  Parameter find_ticket : Parking -> nat -> option Ticket.
  Parameter sort_tickets_by_vehicle_type : list Ticket -> list Ticket.
  Parameter sort_tickets_by_entry_time : list Ticket -> list Ticket.

  (* Axiomes et propriétés à démontrer *)
  Axiom add_ticket_correct : forall (p: Parking) (t: Ticket), In t (get_tickets (add_ticket p t)).
  Axiom remove_ticket_correct : forall (p: Parking) (id: nat) (t: Ticket),
    In t (get_tickets (remove_ticket p id)) -> get_ticket_id t <> id.
  Axiom sorted_by_vehicle_type : list Ticket -> Prop.
  Axiom sorted_by_entry_time : list Ticket -> Prop.

End ParkingSystem.

Inductive VehicleType := 
  | TwoWheeler
  | FourWheeler.

Record Vehicle := {
  plate : string;
  vehicle_type : VehicleType;
  initial_rate : nat;
  rate_increase : nat;
}.

Record Ticket := {
  ticket_id : nat;
  entry_time : nat;
  exit_time : option nat;
  vehicle : Vehicle;
  amount_due : nat;
  fine : option nat;
}.

Record Parking := {
  tickets : list Ticket;
  accessible : bool;
}.

Module ParkingSystemImpl.

  Definition VehicleType := VehicleType.
  Definition Vehicle := Vehicle.
  Definition Ticket := Ticket.
  Definition Parking := Parking.

  (* Constructeurs *)
  Definition mkVehicle (plate: string) (vtype: VehicleType) (irate: nat) (rate_inc: nat) : Vehicle :=
    {| plate := plate; vehicle_type := vtype; initial_rate := irate; rate_increase := rate_inc |}.

  Definition mkTicket (id: nat) (entry: nat) (exit: option nat) (veh: Vehicle) (amount: nat) (fine: option nat) : Ticket :=
    {| ticket_id := id; entry_time := entry; exit_time := exit; vehicle := veh; amount_due := amount; fine := fine |}.

  Definition mkParking (ts: list Ticket) (access: bool) : Parking :=
    {| tickets := ts; accessible := access |}.

  (* Fonctions d'accès *)
  Definition get_tickets (p: Parking) : list Ticket := p.(tickets).
  Definition get_accessible (p: Parking) : bool := p.(accessible).
  Definition get_ticket_id (t: Ticket) : nat := t.(ticket_id).
  Definition get_entry_time (t: Ticket) : nat := t.(entry_time).
  Definition get_exit_time (t: Ticket) : option nat := t.(exit_time).
  Definition get_vehicle (t: Ticket) : Vehicle := t.(vehicle).
  Definition get_amount_due (t: Ticket) : nat := t.(amount_due).
  Definition get_fine (t: Ticket) : option nat := t.(fine).
  Definition get_vehicle_type (v: Vehicle) : VehicleType := v.(vehicle_type).

  (* Fonction de comparaison VehicleType *)
  Definition compare_vehicle_type (vt1 vt2: VehicleType) : comparison :=
    match vt1, vt2 with
    | TwoWheeler, FourWheeler => Lt
    | FourWheeler, TwoWheeler => Gt
    | _, _ => Eq
    end.

  (* Vérification de la liste triée par type de véhicule *)
  Fixpoint sorted_by_vehicle_type (l: list Ticket) : Prop :=
    match l with
    | [] => True
    | [_] => True
    | x :: y :: xs => (compare_vehicle_type (get_vehicle_type (get_vehicle x)) (get_vehicle_type (get_vehicle y)) <> Gt) /\ sorted_by_vehicle_type xs
    end.

  (* Vérification de la liste triée par heure d'entrée *)
  Fixpoint sorted_by_entry_time (l: list Ticket) : Prop :=
    match l with
    | [] => True
    | [_] => True
    | x :: y :: xs => (get_entry_time x <= get_entry_time y) /\ sorted_by_entry_time xs
    end.

  (* Ajout d'un ticket *)
  Definition add_ticket (p: Parking) (t: Ticket) : Parking :=
    {| tickets := t :: p.(tickets); accessible := p.(accessible) |}.

  (* Suppression d'un ticket *)
  Definition remove_ticket (p: Parking) (id: nat) : Parking :=
    {| tickets := filter (fun t => negb (t.(ticket_id) =? id)) p.(tickets); accessible := p.(accessible) |}.

  (* Recherche d'un ticket *)
  Definition find_ticket (p: Parking) (id: nat) : option Ticket :=
    find (fun t => t.(ticket_id) =? id) p.(tickets).

  (* Tri des tickets par type de véhicule *)
  Definition compare_ticket_vehicle_type (t1 t2: Ticket) : bool :=
    match compare_vehicle_type (get_vehicle_type (get_vehicle t1)) (get_vehicle_type (get_vehicle t2)) with
    | Lt | Eq => true
    | Gt => false
    end.

  Fixpoint insertion_sort {A: Type} (cmp: A -> A -> bool) (l: list A) : list A :=
    match l with
    | [] => []
    | h :: tl => let sorted_tl := insertion_sort cmp tl in
                 let fix insert (x: A) (l: list A) :=
                     match l with
                     | [] => [x]
                     | h' :: tl' => if cmp x h' then x :: l else h' :: insert x tl'
                     end
                 in insert h sorted_tl
    end.

  Definition sort_tickets_by_vehicle_type (l: list Ticket) : list Ticket :=
    insertion_sort compare_ticket_vehicle_type l.

  (* Tri des tickets par heure d'entrée *)
  Definition compare_entry_time (t1 t2: Ticket) : bool :=
    t1.(entry_time) <=? t2.(entry_time).

  Definition sort_tickets_by_entry_time (l: list Ticket) : list Ticket :=
    insertion_sort compare_entry_time l.

  (* Théorèmes de correction *)
  Theorem ticket_in_list : forall (t: Ticket) (l: list Ticket),
    In t l -> In t (t :: l).
  Proof.
    intros.
    simpl.
    right.
    assumption.
  Qed.
  
  Theorem add_ticket_correct : forall (p: Parking) (t: Ticket), In t (get_tickets (add_ticket p t)).
  Proof.
    intros.
    simpl.
    left.
    reflexivity.
  Qed.

  Theorem remove_ticket_correct : forall (p: Parking) (id: nat) (t: Ticket),
    In t (get_tickets (remove_ticket p id)) -> get_ticket_id t <> id.
  Proof.
    intros.
    simpl in *.
    apply filter_In in H.
    destruct H as [H1 H2].
    apply Bool.negb_true_iff in H2.
    apply Nat.eqb_neq in H2.
    assumption.
  Qed.

  Theorem vehicle_type_comparable : forall (vt1 vt2: VehicleType),
    {compare_vehicle_type vt1 vt2 = Lt} + {compare_vehicle_type vt2 vt1 = Lt} + {compare_vehicle_type vt1 vt2 = Eq}.
  Proof.
    intros.
    destruct vt1, vt2; simpl; auto.
  Qed.

End ParkingSystemImpl.
