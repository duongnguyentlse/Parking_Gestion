open Dao

module FileIO = struct

  let string_of_userType( _userType : userType) : string = 
    match _userType with
    | NORMAL -> "NORMAL"
    | DISABLE -> "DISABLE"

  let userType_of_string( _userType : string) : userType = 
    match _userType with
    | "NORMAL" -> NORMAL
    | "DISABLE" -> DISABLE
    | _ -> raise (Failure ("Invalid userType: " ^ _userType))

  let close_file file =
    try
      close_in file
    with exn ->
      raise (Failure ("Error closing file: " ^ Printexc.to_string exn))

  let read_csv_file filename: dao list =
    let ic = open_in filename in
    let lines = ref []  in (* Change to a mutable list *)
    try
      while true; do
        let line = input_line ic in
        if String.length line > 0 then (* Skip empty lines *)
          lines := line :: !lines  (* Append line using mutable list *)
      done; []
    with
      | End_of_file ->
        close_file ic;
        List.map (fun line ->
          try
            let fields = Array.of_list (Str.split (Str.regexp ",") line) in
            { id = int_of_string (fields.(0));
              startTime = fields.(1);
              typeProduct = int_of_string (fields.(2));
              licensePlate = fields.(3);
              baseTime = int_of_string (fields.(4));
              userId = int_of_string (fields.(5));
              userName = fields.(6);
              userType = userType_of_string fields.(7)}
          with exn ->
            raise (Failure ("Error processing line: " ^ line ^ " - " ^ Printexc.to_string exn))
        ) !lines
    | exn ->
        close_file ic;
        raise (Failure ("Error reading file: " ^ filename ^ " - " ^ Printexc.to_string exn))

  let write_csv_file filename records: unit =
    let oc = open_out filename in
    match oc with
    | oc ->
      try
        List.iter (fun record ->
          let line =
            String.concat ","
              [ string_of_int record.id;
                record.startTime;
                string_of_int record.typeProduct;
                record.licensePlate;
                string_of_int record.baseTime;
                string_of_int record.userId;
                record.userName;
                string_of_userType record.userType ]
          in
          output_string oc line;
          output_char oc '\n';
        ) records;
      with exn ->
        raise (Failure ("Error writing file: " ^ filename ^ " - " ^ Printexc.to_string exn))
end
