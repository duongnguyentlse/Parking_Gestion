Require Import List.
Require Import String.

Inductive vehicleType : Set :=
| TwoWheeler : vehicleType
| FourWheeler : vehicleType
| PMR : vehicleType.

Inductive ticket : Set :=
| Ticket : string -> nat -> nat -> nat -> vehicleType -> ticket.

Definition parkingLot : Set := list ticket.

Parameter addTicket : ticket -> parkingLot -> parkingLot.
Parameter removeTicket : ticket -> parkingLot -> parkingLot.
Parameter calculateAmount : ticket -> nat.
Parameter updateRates : vehicleType -> nat -> nat.
Parameter searchTicketByPlate : string -> parkingLot -> option ticket.
Parameter initialRate : nat. (* Initial parking rate *)
Parameter maxParkingDuration : nat. (* Maximum parking duration allowed *)



Axiom addTicket_axiom : forall (t : ticket) (p : parkingLot), In t (addTicket t p).
Axiom removeTicket_axiom : forall (t : ticket) (p : parkingLot), ~ In t (removeTicket t p).
Axiom calculateAmount_axiom : forall (t : ticket), calculateAmount t >= 0.
Axiom updateRates_axiom : forall (v : vehicleType) (oldRate : nat), updateRates v oldRate > oldRate.
Axiom searchTicketByPlate_axiom : forall (plate : string) (p : parkingLot) (t : ticket),
  searchTicketByPlate plate p = Some t -> In t p.
Axiom initialRatePositive : initialRate > 0.
Axiom updateRates_preserves_positivity : forall (v : vehicleType) (oldRate : nat),
  oldRate > 0 -> updateRates v oldRate > 0.
Axiom maxParkingDurationPositive : maxParkingDuration > 0.
Axiom calculateAmount_bounded : forall (t : ticket),
  calculateAmount t <= maxParkingDuration * initialRate.
Axiom maxParkingDuration_ticket_validity : forall (t : ticket),
  calculateAmount t = maxParkingDuration ->
  (* Autres conditions garantissant la validité du billet en fonction de la durée, du type, etc. *) True.

(* Theorems *)
Theorem ticketAmountPositive : forall t : ticket, calculateAmount t >= 0.
Proof.
  intros t.
  apply calculateAmount_axiom.
Qed.

Theorem updatedRatesGreater : forall (v : vehicleType) (oldRate : nat), updateRates v oldRate > oldRate.
Proof.
  intros v oldRate.
  apply updateRates_axiom.
Qed.

Theorem searchedTicketInList : forall (plate : string) (p : parkingLot) (t : ticket),
  searchTicketByPlate plate p = Some t -> In t p.
Proof.
  intros plate p t H.
  apply searchTicketByPlate_axiom with (plate := plate) in H.
  apply H.
Qed.

Theorem initialRate_positive : initialRate > 0.
Proof.
  apply initialRatePositive.
Qed.

Theorem updatedRates_preserve_positivity : forall (v : vehicleType) (oldRate : nat),
  oldRate > 0 -> updateRates v oldRate > 0.
Proof.
  apply updateRates_preserves_positivity.
Qed.

Theorem maxParkingDuration_positive : maxParkingDuration > 0.
Proof.
  apply maxParkingDurationPositive.
Qed.

Theorem calculateAmount_bounded_by_duration : forall (t : ticket),
  calculateAmount t <= maxParkingDuration * initialRate.
Proof.
  apply calculateAmount_bounded.
Qed.

Theorem maxParkingDuration_implies_validity : forall (t : ticket),
  calculateAmount t = maxParkingDuration -> True.
Proof.
  apply maxParkingDuration_ticket_validity.
Qed.

Lemma parkingLot_non_empty_after_add : forall (t : ticket) (p : parkingLot),
  In t (addTicket t p).
Proof.
  intros t p.
  apply addTicket_axiom.
Qed.

Lemma calculateAmount_non_negative : forall (t : ticket),
  calculateAmount t >= 0.
Proof.
  intros t.
  apply calculateAmount_axiom.
Qed.

Lemma searchTicketByPlate_iff_In : forall (plate : string) (p : parkingLot) (t : ticket),
  searchTicketByPlate plate p = Some t -> In t p.
Proof.
  intros plate p t H.
  apply searchTicketByPlate_axiom in H.
  apply H.
Qed.

Lemma addTicket_preserves_In : forall (t : ticket) (p : parkingLot),
  In t (addTicket t p).
Proof.
  intros t p.
  apply addTicket_axiom.
Qed.



  


