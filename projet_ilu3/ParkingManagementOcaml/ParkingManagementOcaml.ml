#load "unix.cma";;
#load "str.cma";;
open Unix;;
open Scanf;;
open String;;
open Str;;

module IntMap = Map.Make(Int);;

(* declare method to cast date to string *)
let days = [| "Sun"; "Mon"; "Tue"; "Wed"; "Thu"; "Fri"; "Sat" |]
let months = [| "Jan"; "Feb"; "Mar"; "Apr"; "May"; "Jun";
                "Jul"; "Aug"; "Sep"; "Oct"; "Nov"; "Dec" |]
(* let string_of_date time option=
  match time with
  | None -> "None"
  | Some time ->
    let tm = time in
      Printf.sprintf "%s %s %2d %02d:%02d:%02d %04d"
        days.(tm.tm_wday)
        months.(tm.tm_mon)
        tm.tm_mday
        tm.tm_hour
        tm.tm_min
        tm.tm_sec
        (tm.tm_year + 1900) *)

let string_of_date time=
  let tm = time in
  Printf.sprintf "%s %s %2d %02d:%02d:%02d %04d"
    days.(tm.tm_wday)
    months.(tm.tm_mon)
    tm.tm_mday
    tm.tm_hour
    tm.tm_min
    tm.tm_sec
    (tm.tm_year + 1900)

let date_to_string time = 
  let tm = time in
    Printf.sprintf "%04d-%02d-%02d %02d:%02d:%02d"
      (tm.tm_year + 1900)
      (tm.tm_mon + 1)
      tm.tm_mday
      tm.tm_hour
      tm.tm_min
      tm.tm_sec

(* Déclaration du type somme pour les types de véhicules *)
type vehicle_type =
  | Car
  | Motorbike
  | Wheelchair

(* declare class vehicle *)
class virtual vehicle licensePlate baseTime = 
  object (self)
    val mutable licensePlate : string = licensePlate
    val mutable baseTime : int = baseTime
    val mutable totalParkingTime = (0: int)

    method get_licensePlate = licensePlate
    method set_licensePlate _licensePlate = licensePlate <- _licensePlate
    method get_baseTime = baseTime
    method set_baseTime _baseTime = baseTime <- _baseTime
    method get_totalParkingTime = totalParkingTime
    method set_totalParkingTime _totalParkingTime = totalParkingTime <- _totalParkingTime

    method virtual calculateFare : float
    method virtual calculateFire : float 
    method virtual toString : string
    method virtual getName : string
  end;;

(* declare class car inherit from vehicle *)
class car licensePlate baseTime = 
  object (self)
    inherit vehicle licensePlate baseTime

    method getName = "car"
    method calculateFare = 500.0
    method calculateFire = if self#get_totalParkingTime <= self#get_baseTime then 0.0 else self#calculateFare *. 0.3
    method toString = "Car [License Plate=" ^ self#get_licensePlate ^ ", Base Time=" ^ string_of_int self#get_baseTime ^ ", Total Parking Time=" ^ string_of_int self#get_totalParkingTime ^ ", Fare Fee=" ^ string_of_float self#calculateFare ^ ", Fire Fee=" ^ string_of_float self#calculateFire ^ "]"
  end;;

(* declare class wheelchair inherit from vehicle *)
class wheelchair licensePlate baseTime = 
  object (self)
    inherit vehicle licensePlate baseTime
    
    method getName = "wheelchair"
    method calculateFare = 200.0
    method calculateFire = if self#get_totalParkingTime <= self#get_baseTime then 0.0 else self#calculateFare *. 0.2
    method toString = "Wheelchair [License Plate=" ^ self#get_licensePlate ^ ", Base Time=" ^ string_of_int self#get_baseTime ^ ", Total Parking Time=" ^ string_of_int self#get_totalParkingTime ^ ", Fare Fee=" ^ string_of_float self#calculateFare ^ ", Fire Fee=" ^ string_of_float self#calculateFire ^ "]"
  end;;

(* declare class motorbike inherit from vehicle *)
class motorbike licensePlate baseTime = 
  object (self)
    inherit vehicle licensePlate baseTime
    
    method getName = "motorbike"
    method calculateFare = 300.0
    method calculateFire = if self#get_totalParkingTime <= self#get_baseTime then 0.0 else self#calculateFare *. 0.2
    method toString = "Motorbike [License Plate=" ^ self#get_licensePlate ^ ", Base Time=" ^ string_of_int self#get_baseTime ^ ", Total Parking Time=" ^ string_of_int self#get_totalParkingTime ^ ", Fare Fee=" ^ string_of_float self#calculateFare ^ ", Fire Fee=" ^ string_of_float self#calculateFire ^ "]"
  end;;

(* Utilisation de List.map *)
let increase_base_time vehicles =
  List.map (function
    | (car : car) -> car#set_baseTime (car#get_baseTime + 10); car
  ) vehicles

(* Utilisation de List.filter *)
let filter_cars vehicles =
  List.filter (function
    | (car : car) -> true
  ) vehicles

(* Utilisation de List.fold_left *)
let sum_parking_times vehicles =
  List.fold_left (fun acc vehicle ->
    match vehicle with
    | (car : car) -> acc + car#get_totalParkingTime
  ) 0 vehicles

(* Utilisation de List.for_all *)
let check_all_vehicles vehicles =
  List.for_all (function
    | (car : car) -> car#get_baseTime > 0
  ) vehicles


(* declare class ticket *)
class ticket = 
  object(self)
    val mutable id = (0 : int)
    val mutable startTime = (None: Unix.tm option)
    (* (Unix.localtime (Unix.time())) *)
    val mutable endTime = (None: Unix.tm option)
    val mutable vehicle = (new car "" 0: vehicle)

    method get_vehicle = vehicle
    method set_vehicle _vehicle = vehicle <- _vehicle
    method get_id = id
    method set_id _id = id <- _id
    method get_startTime = startTime
    method set_startTime _startTime = startTime <- _startTime
    method get_endTime = endTime

    (* this method helps to add new vehicle to ticket *)
    method addVehicle licensePlate : bool = 
      let isSuccess = ref false in
        (try
          (* get current time to make sure unique id *)
          id <- int_of_float(Unix.time());

          (* ask to what kind of vehicle to input *)
          let kind = ref 0 in 
            let quit_loop = ref false in
              while not !quit_loop do
                print_string "What kind of vehicle: {0-Car, 1-Motobike, 2-Wheelchair, -1-Exit}? ";
                kind := read_int();

                match !kind with
                | 0 -> vehicle <- new car licensePlate 60; quit_loop := true;
                | 1 -> vehicle <- new motorbike licensePlate 60; quit_loop := true;
                | 2 -> vehicle <- new wheelchair licensePlate 60; quit_loop := true;
                | -1 -> quit_loop := true;
                | _ -> print_endline "Invalid vehicle!";
              done;

          (* ask start time *)
          if !kind <> (-1) then 
            let quit_loop = ref false in
              while not !quit_loop do
                print_string "Input start time (format yyyy-MM-dd hh:mm): ";

                let input = read_line() in 
                  try
                    let (year, month, day, hour, minute) = sscanf input "%d-%d-%d %d:%d" (fun x y z t w -> (x, y, z, t, w)) in
                      startTime <- Some (snd (mktime {
                          tm_sec = 0;
                          tm_min = minute;
                          tm_hour = hour;

                          tm_mday = day;
                          tm_mon = month - 1;
                          tm_year = year - 1900;

                          tm_wday = 0;
                          tm_yday = 0;
                          tm_isdst = false;
                        }));
                              
                      quit_loop := true;
                      isSuccess := true;
                  with
                  | _ -> print_endline "Invalid start time!";
              done;
        with
        | _ -> print_endline "Something went wrong when adding vehicle");

      match isSuccess with
      | _ -> !isSuccess;

    method toString = 
      let currentTime = match endTime with None -> Unix.time() | Some endTime -> fst(mktime(endTime)) in
        let diff = int_of_float (currentTime -. (match startTime with None -> Unix.time() | Some startTime -> fst(mktime(startTime)))) in
          let minutes = diff / 60 in vehicle#set_totalParkingTime minutes; 
              "Ticket [ID=" ^ string_of_int id 
                      ^ ", Start Time=" ^ (match startTime with None -> "None" | Some time -> string_of_date time) 
                      ^ ", End Time=" ^ (match endTime with None -> "None" | Some time -> string_of_date time) ^ ", Vehicle=" ^ vehicle#toString
                      ^ ", Total Fee=" ^ string_of_float (vehicle#calculateFare +. vehicle#calculateFire) ^ "]"
    
    (* method helps to remove vehicle *)
    method removeVehicle : bool = 
      let isSuccess = ref false in
        (try
          let quit_loop = ref false in
            while not !quit_loop do
              print_string "Input end time (format yyyy-MM-dd hh:mm): ";

              let input = read_line () in 
                try
                  let (year, month, day, hour, minute) = sscanf input "%d-%d-%d %d:%d" (fun x y z t w -> (x, y, z, t, w)) in
                  endTime <- Some (snd (mktime {
                      tm_sec = 0;
                      tm_min = minute;
                      tm_hour = hour;

                      tm_mday = day;
                      tm_mon = month - 1;
                      tm_year = year - 1900;

                      tm_wday = 0;
                      tm_yday = 0;
                      tm_isdst = false;
                    }));
                  
                  
                  match endTime with
                  | None -> print_endline "Invalid end time!";
                  | Some endTime ->
                    match startTime with
                    | None -> print_endline "Invalid start time!";
                    | Some startTime ->
                      if fst(mktime(endTime)) > fst(mktime(startTime)) then 
                        (quit_loop := true;
                        isSuccess := true;)
                      else
                        print_endline "End time must be after start time!";
                with
                | _ -> print_endline "Invalid end time!";  
            done;
        with
        | _ -> print_endline "Something went wrong when removing vehicle";);

      match isSuccess with
      | _ -> !isSuccess;
  end;;

(* declare class ticketiterator *)
class ticketiterator (tickets : ticket list) =
  object(self)
    val mutable index = 0

    (* check if there are more tickets *)
    method hasNext : bool =
      index < List.length tickets

    (* get the next ticket *)
    method next : ticket option =
      if self#hasNext then (
        let ticket = List.nth tickets index in
        index <- index + 1;
        Some ticket
      ) else None
  end;;

(* declare class TicketComparatorByTypeVehicle *)
class ticketcomparatorbytypevehicle =
  object(self)

    method compare (ticket1 : ticket) (ticket2 : ticket) : int =
      let vehicleType1 = ticket1#get_vehicle#getName in
      let vehicleType2 = ticket2#get_vehicle#getName in
      compare vehicleType1 vehicleType2;
  end;;

(* declare class TicketComparatorByParkingTime *)
class ticketcomparatorbyparkingtime =
  object(self)

    method compare (ticket1 : ticket) (ticket2 : ticket) : int =
      match ticket1#get_startTime, ticket2#get_startTime with 
      | None, None -> 0
      | None, Some _ -> -1
      | Some _, None -> 1
      | Some t1, Some t2 ->
        let startTime1 = fst(mktime(t1)) in
        let startTime2 = fst(mktime(t2)) in
        if startTime1 < startTime2 then -1 
        else if startTime1 > startTime2 then 1 else 0;
  end;;


(* declare class parkingmanagement *)
class parkingmanagement =
  object(self)
    val mutable tickets = ([] : ticket list)

    (* print menu *)
    method private menu : int =
      print_endline "-------------------MENU-------------------";
      print_endline "1. Vehicle in/out";
      print_endline "2. Print all parking vehicle";
      print_endline "3. Sort tickets by type vehicle";
      print_endline "4. Sort tickets by parking time";
      print_endline "5. Find a vehicle";
      print_endline "6. Write data to CSV file";
      print_endline "7. Read data from CSV file";
      print_endline "0. Exit!";
      print_string "Please choose an option: ";

      let option = ref 0 in
        let quit_loop = ref false in
          while not !quit_loop do
            try
              option := read_int(); quit_loop := true;
            with
            | _ -> print_endline "Please input a number!";

            if not !quit_loop then
              print_string "Please choose an option: ";
          done;
      
      match option with
      | _ -> !option
    
    (* Find the specific ticket of a vehicle *)
    method private checkExists licensePlate : int = 
      let index = ref 0 in
        let iterator = new ticketiterator tickets in
          let quit_loop = ref false in
            while iterator#hasNext && not !quit_loop do
                match iterator#next with
                | Some x -> if x#get_vehicle#get_licensePlate = licensePlate then
                              quit_loop := true
                            else 
                              index := !index +1
                | None -> ()
            done;
      
      if ((List.length tickets) = !index) then -1 else !index;

    (* find a ticket by license plate*)
    method private searchTicket = 
      print_endline "Searching a ticket by license plate.....";
      print_string "Enter license plate to search: ";
      let licensePlate = read_line () in
        let index = self#checkExists licensePlate in match index with
        | -1 -> Printf.printf "Oooops! We can not find the ticket with license plate %s\n" licensePlate
        | _ -> let elem = List.nth tickets index in 
          print_endline "The ticket is: ";
          print_endline elem#toString

    method private printHelper tickets=
      let iterator = new ticketiterator tickets in
        let rec print_lines (iterator: ticketiterator) =
          match iterator#hasNext with
          | true ->
            let ticket = iterator#next in
              let _ = match ticket with
              | Some ticket -> print_endline ticket#toString
              | None -> () in
              print_lines iterator
          | false -> ()
        in
        print_lines iterator

    (* print all tickets in list *)
    method private printListTicket =
      print_endline "-------------------LIST TICKET-------------------";
      self#printHelper tickets;
      print_endline "-------------------------------------------------"
    
    (* sort tickets by type of vehicle *)
    method private sortTicketByType = 
      print_endline "Sorting tickets by type increasement.....";
      print_endline "List tickets after sorting....";
      let comparator = new ticketcomparatorbytypevehicle in
      let _tickets = List.sort (fun a b -> comparator#compare a b) tickets in
        self#printHelper _tickets

    (* sort tickets by parking time *)
    method private sortTicketByParkingTime = 
      print_endline "Sorting tickets by parking time increasement.....";
      print_endline "List tickets after sorting....";
      let comparator = new ticketcomparatorbyparkingtime in
      let _tickets = List.sort (fun a b -> comparator#compare a b) tickets in
        self#printHelper _tickets
    
    (* park vehicle *)
    method private parkVehicle =
      try
        print_string "Please enter the license plate: ";

        let licensePlate = read_line() in
          let index = self#checkExists licensePlate in match index with
          | -1 -> 
            (print_endline "Adding new ticket....";
            let ticket = new ticket in 
              let response = ticket#addVehicle licensePlate in match response with
              | true -> tickets <- tickets@[ticket]; print_endline "Add new ticket successfully!"
              | false -> print_endline "Fail to add new ticket! Try again!")
          | _ -> 
            (print_endline "Removing existing ticket....";
            let ticket = List.nth tickets index in
              let response = ticket#removeVehicle in match response with
              | true -> 
                let diff = int_of_float ((match ticket#get_endTime with None -> Unix.time() | Some endTime -> fst(mktime(endTime))) 
                                          -. (match ticket#get_startTime with None -> Unix.time() | Some startTime -> fst(mktime(startTime)))) in
                  let minutes = diff / 60 in
                    ticket#get_vehicle#set_totalParkingTime minutes;
                    print_endline "Payment ticket information....";
                    print_endline ticket#toString;
                    tickets <- List.filter (fun x -> x <> ticket) tickets
              | false -> print_endline "Fail to remove existing ticket! Try again!")
      with
      | _ -> print_endline "An error occurs!"

  (* write CSV file *)
  method private writeCSV =
    print_endline "Writing CSV file.....";
    let filename = "data.csv" in
      let fileWriter = open_out filename in
        let ticketIterator = new ticketiterator tickets in
          let rec write_lines (iterator: ticketiterator) =
            match iterator#hasNext with
            | true ->
              let ticket = iterator#next in
                let _ = match ticket with
                | Some ticket -> let id = string_of_int ticket#get_id in
                  let startTime = match ticket#get_startTime with None -> "None" | Some startTime -> date_to_string startTime in
                  let vehicleType =
                    match ticket#get_vehicle#getName with
                    | "car" -> "0"
                    | "motorbike" -> "1"
                    | _ -> "2"
                  in
                  let licensePlate = ticket#get_vehicle#get_licensePlate in
                  let baseTime = string_of_int ticket#get_vehicle#get_baseTime in
                  let line = id ^ "," ^ startTime ^ "," ^ vehicleType ^ "," ^ licensePlate ^ "," ^ baseTime ^ "\n" in
                  output_string fileWriter line;
                  write_lines iterator
                | None -> () in ()
            | false -> ()
        in
        write_lines ticketIterator;
      close_out fileWriter;
    print_endline "Write data to CSV file successfully!";

  (* read CSV file *)
  method private readCSV =
    print_endline "Reading data from CSV file.....";
    let filename = "data.csv" in
    let fileReader = open_in filename in
    let _ = Str.regexp "\\([0-9]+\\)-\\([0-9]+\\)-\\([0-9]+\\) \\([0-9]+\\):\\([0-9]+\\):\\([0-9]+\\)" in
    let rec read_lines () =
      try
        let line = input_line fileReader in
        let fields = Str.split (Str.regexp ",") line in
        let ticket = new ticket in
        ticket#set_id (int_of_string (List.nth fields 0));
        let startTime = List.nth fields 1 in
        let _ = 
          try
            let (year, month, day, hour, minute, second) = sscanf startTime "%d-%d-%d %d:%d:%d" (fun x y z t w v -> (x, y, z, t, w, v)) in
            let startTime = Some (snd(mktime{
              tm_sec = second;
              tm_min = minute;
              tm_hour = hour;

              tm_mday = day;
              tm_mon = month - 1;
              tm_year = year - 1900;

              tm_wday = 0;
              tm_yday = 0;
              tm_isdst = false;
            })) in
            ticket#set_startTime startTime
          with
          |  exn -> print_endline ("An exception of type: " ^ Printexc.to_string exn)
        in
        let vehicleType = int_of_string (List.nth fields 2) in
        let licensePlate = List.nth fields 3 in
        let baseTime = int_of_string (List.nth fields 4) in
        let vehicle = 
          match vehicleType with
          | 0 -> new car licensePlate baseTime
          | 1 -> new motorbike licensePlate baseTime
          | _ -> new wheelchair licensePlate baseTime
        in
        ticket#set_vehicle vehicle;
        tickets <- tickets@[ticket];
        read_lines ()
      with
      | End_of_file -> ()
    in
    read_lines ();
    close_in fileReader;
    print_endline "Read data from CSV file successfully!";

    method private exit = 
      print_endline "Good bye!";
      exit 0;

    (* run method *)
    method run = 
      let option_map = Hashtbl.create 10 in
        let () = 
            Hashtbl.add option_map 1 (fun ()-> self#parkVehicle);
            Hashtbl.add option_map 2 (fun ()-> self#printListTicket) ;
            Hashtbl.add option_map 3 (fun ()-> self#sortTicketByType);
            Hashtbl.add option_map 4 (fun ()-> self#sortTicketByParkingTime);
            Hashtbl.add option_map 5 (fun ()-> self#searchTicket);
            Hashtbl.add option_map 6 (fun ()-> self#writeCSV);
            Hashtbl.add option_map 7 (fun ()-> self#readCSV);
            Hashtbl.add option_map 0 (fun ()-> self#exit)  in 
          while true do
            let option = self#menu in match Hashtbl.find_opt option_map option with 
            | Some f -> f ()
            | None -> print_endline "Invalid option!"
          done;
        
        print_string "------------------------------------------\n"
  end;;

let p = new parkingmanagement;;
p#run;;
