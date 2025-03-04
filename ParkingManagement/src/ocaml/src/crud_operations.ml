open File_io
open Dao

module CrudOps = struct

  let create_file filename =
    if not (Sys.file_exists filename) then
      FileIO.write_csv_file filename []  (* Create empty file *)

  let read_all_data filename: dao list option =
    try
      Some (FileIO.read_csv_file filename)
    with exn ->
      raise (Failure ("Error processing line: " ^ Printexc.to_string exn))  (* Handle potential errors during reading *)

  let delete_all_data filename: unit =
    FileIO.write_csv_file filename []

  let insert_record inputParams: unit =
    let params = Array.of_list (Str.split (Str.regexp " ") inputParams) in 
    let filename = params.(1) in
    let dao_string = params.(0) in
    let record =
      try
        let fields = Array.of_list (Str.split (Str.regexp ",") dao_string) in
        { id = int_of_string (fields.(0));
          startTime = fields.(1);
          typeProduct = int_of_string (fields.(2));
          licensePlate = fields.(3);
          baseTime = int_of_string (fields.(4));
          userId = int_of_string (fields.(5));
          userName = fields.(6);
          userType = FileIO.userType_of_string (fields.(7) ) }
      with exn ->
        raise (Failure ("Error parsing DAO string: " ^ Printexc.to_string exn))  (* Handle parsing errors *)
    in
    FileIO.write_csv_file filename (record :: (FileIO.read_csv_file filename))  (* Efficiently append new record *)

  let remove_record_by_id inputParams: unit =
    let params = Array.of_list (Str.split (Str.regexp " ") inputParams) in
    let filename = params.(1) in
    let id = int_of_string params.(0) in
    FileIO.write_csv_file filename (
      List.filter (fun record -> record.id <> id) (FileIO.read_csv_file filename)
    )  (* Efficiently filter and write *)
end
