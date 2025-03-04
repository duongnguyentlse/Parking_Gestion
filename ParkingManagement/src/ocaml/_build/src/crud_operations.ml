open File_io
open Dao

module CrudOps = struct

  let create_file filename =
    if not (Sys.file_exists filename) then
      FileIO.write_csv_file filename []  (* Create empty file *)
    else
      raise (Failure ("File '" ^ filename ^ "' already exists"))

  let read_all_data filename: dao list option =
    try
      Some (FileIO.read_csv_file filename)
    with exn ->
      None  (* Handle potential errors during reading *)

  let delete_all_data filename: unit =
    FileIO.write_csv_file filename []

  let insert_record filename dao_string: unit =
    let record =
      try
        let fields = Array.of_list (Str.split (Str.regexp ",") dao_string) in
        { id = int_of_string (fields.(0));
          startTime = fields.(1);
          typeProduct = int_of_string (fields.(2));
          licensePlate = fields.(3);
          baseTime = int_of_string (fields.(4));
          userId = int_of_string (fields.(5));
          isDisable = bool_of_string (fields.(6) ) }
      with exn ->
        raise (Failure ("Error parsing DAO string: " ^ Printexc.to_string exn))  (* Handle parsing errors *)
    in
    FileIO.write_csv_file filename (record :: (FileIO.read_csv_file filename))  (* Efficiently append new record *)

  let remove_record_by_id filename id: unit =
    FileIO.write_csv_file filename (
      List.filter (fun record -> record.id <> id) (FileIO.read_csv_file filename)
    )  (* Efficiently filter and write *)
end
