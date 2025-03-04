(* Include necessary modules *)
open Crud_operations
open Dao
open File_io

(* Module to encapsulate CLI functionality *)
module Cli = struct

  (* Function to define command-line options *)
  (* let define_options = [
    ("-c", Arg.String (CrudOps.create_file), "Create new CSV file");
    ("-r", Arg.String (fun filename -> 
              let data = CrudOps.read_all_data filename in
              print_endline (string_of_list data)
            ), "Read data from CSV file");
    ("-d", Arg.String (CrudOps.delete_all_data), "Delete all data from CSV file");
    ("-in", Arg.Tuple [Arg.String (fun dao -> CrudOps.insert_record filename dao); Arg.String (fun filename -> filename)], "Insert new record (comma-separated dao fields)");
    ("-out", Arg.Int (fun id -> Arg.Tuple [Arg.Int (fun filename -> CrudOps.remove_record_by_id filename id); Arg.String (fun filename -> filename)]), "Remove record by ID")
  ]; *)

  let string_of_dao (dao: dao): string = 
    "" ^ string_of_int dao.id ^
    "," ^ dao.startTime ^ "" ^
    "," ^ string_of_int dao.typeProduct ^
    "," ^ dao.licensePlate ^ "" ^
    "," ^ string_of_int dao.baseTime ^
    "," ^ string_of_int dao.userId ^
    "," ^ dao.userName ^
    "," ^ FileIO.string_of_userType dao.userType;;
  
  (* Function to convert a list of dao to a list of strings *)
  let string_of_list (daos: dao list): string =
    let separator = String.make 1 (Char.chr 10) in  (* Newline character for separation *)
    String.concat separator (List.map string_of_dao daos)

  (* Main function to handle program execution *)
  let main () =
    (* Initialize a filename variable to store the filename argument *)
    let filename = ref "" in 
            let spec = [
      ("-c", Arg.String (CrudOps.create_file), "Create new CSV file");
      ("-r", Arg.String (fun filename -> 
                let data = CrudOps.read_all_data filename in
                print_endline (string_of_list (match data with
                  | Some l -> l
                  | None -> [] ))
              ), "Read data from CSV file");
      ("-d", Arg.String (CrudOps.delete_all_data), "Delete all data from CSV file");
      ("-in", Arg.String (CrudOps.insert_record), "Insert new record (comma-separated dao fields)");
      ("-out", Arg.String (CrudOps.remove_record_by_id), "Remove record by ID");
    ] in
      let usage_msg = "Usage: crudocaml.exe [-c filename] | [-r filename] | [-d filename] | [-in dao_string filename] | [-out id filename]" in

        ((* Parse the command-line arguments *)
        Arg.parse spec (fun anon_arg -> filename := anon_arg) usage_msg;

        (* Match the action with the corresponding CRUD operation *)
        match !filename with
        (* | "" -> print_endline "No filename provided" *)
        | _ -> ())

end

(* Entry point for the program *)
let () = Cli.main ()
