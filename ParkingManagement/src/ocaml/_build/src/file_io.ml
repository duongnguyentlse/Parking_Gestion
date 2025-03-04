open Dao

module FileIO = struct

  (* let open_file filename mode =
    try
      match mode with
      | "r" -> Some (open_in filename)
      | "w" -> Some (open_out filename)
      | _ -> None
    with exn ->
      raise (Failure ("Error opening file '" ^ filename ^ "': " ^ Printexc.to_string exn)) *)

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
              isDisable = bool_of_string (fields.(6)) }
          with exn ->
            raise (Failure ("Error processing line: " ^ line ^ " - " ^ Printexc.to_string exn))
        ) []
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
                string_of_bool record.isDisable ]
          in
          output_string oc line;
          output_char oc '\n';
        ) records;
      with exn ->
        raise (Failure ("Error writing file: " ^ filename ^ " - " ^ Printexc.to_string exn))
end
