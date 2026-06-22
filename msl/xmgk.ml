module HMagick = Magick.Magick
let () =
  let xt = Xmlerr.parse_file ~filename:Sys.argv.(1) in
  let xt = Xmlerr.strip_space xt in
  (*
  Xmlerr.print_code xt;
  *)

  let id = (fun v -> v) in
 
  let p2_scanf txt_d2 =
    Scanf.sscanf txt_d2 "%d,%d" (fun x y -> (x, y))
  in
  let d2_scanf txt_d2 =
    Scanf.sscanf txt_d2 "%d %d" (fun x y -> (x, y))
  in
  let d3_scanf txt_d3 =
    Scanf.sscanf txt_d3 "%d,%d,%d" (fun r g b -> (r, g, b, 255))
  in

  let default_some prm = Some prm in
  let default_some_float prm = Some(float_of_string prm) in

  let filter_list = ["blur"; "edge"; "negate"; "charcoal"; "modulate"; "emboss"; "shade";
    "sharpen"; "spread"; "solarize"; "equalize"; "despeckle"; "draw_text"; "draw_line"] in

  let param_default_get conv_f param_name default_value xml_attrs =
    try let str_param = List.assoc param_name xml_attrs in conv_f str_param
    with Not_found | Failure _ -> default_value
  in

  let apply_filter primitive tag =
    match tag with

    (*

    val fill_primitive : Magick.image ->
       prim:Prim.t -> ?fill:Color.t -> unit -> unit

    val stroke_primitive : Magick.image ->
       prim:Prim.t ->
       ?stroke:Color.t -> ?stroke_width:float -> unit -> unit

    *)

    | Xmlerr.Tag ("draw_line", xml_attrs) ->
        let p0 = param_default_get p2_scanf "p1" ( 0, 10) xml_attrs in
        let p1 = param_default_get p2_scanf "p2" (10, 10) xml_attrs in
        let rgba = param_default_get d3_scanf "rgb" (0, 0, 0, 255) xml_attrs in
        let stroke_width = param_default_get float_of_string "stroke_width" 1.0 xml_attrs in
        let r, g, b, _ = rgba in
        Printf.printf "# draw-line: [%d %d %d], %g\n%!" r g b stroke_width;
        begin match primitive with
        | None -> ()
        | Some image ->
            HMagick.stroke_primitive image
                 ~prim:(HMagick.Prim.prim_line p0 p1)
                 ~stroke:(HMagick.Color.map8 rgba)
                 ~stroke_width:stroke_width ();
        end;
        primitive


    | Xmlerr.Tag ("draw_text", xml_attrs) ->
        let text = param_default_get id "txt" "" xml_attrs in
        let pos = param_default_get d2_scanf "pos" (0, 0) xml_attrs in
        let font = param_default_get default_some "font" None xml_attrs in
        let pointsize = param_default_get default_some_float "pointsize" None xml_attrs in
        let rgba = param_default_get d3_scanf "rgb" (0, 0, 0, 255) xml_attrs in
        let _ = font in
        (*
          ../ext/Generic.ttf

        *)
        (*
          (Color.map8 (0, 0, 0, 255))
        *)
        begin match primitive with
        | None -> ()
        | Some image ->
            (*
              ~font:"/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"
            *)
            HMagick.draw_text image
              ~pos:pos
              ~txt:text
              ?font:font
              ?pointsize:pointsize
              ~fill:(HMagick.Color.map8 rgba)
              (*
              ?fill:Color.t
              ?stroke:Color.t
              ?stroke_width:float
              *)
              ()
            ;
        end;
        primitive

    | Xmlerr.Tag ("modulate", xml_attrs) ->
        let brightness = param_default_get int_of_string "brightness" 100 xml_attrs in
        let saturation = param_default_get int_of_string "saturation" 100 xml_attrs in
        let hue        = param_default_get int_of_string "hue"        100 xml_attrs in
        begin match primitive with
        | Some image -> HMagick.image_modulate image ~modulate:(brightness, saturation, hue);
        | None -> ()
        end;
        primitive

    | Xmlerr.Tag ("charcoal", xml_attrs) ->
        let radius = param_default_get float_of_string "radius" 1.0 xml_attrs in
        let sigma = param_default_get float_of_string "sigma" 1.0 xml_attrs in
        let image =
          match primitive with
          | Some img -> Some (HMagick.image_charcoal img ~radius ~sigma)
          | None -> (None)
        in
        image

    | Xmlerr.Tag ("edge", xml_attrs) ->
        let radius = param_default_get float_of_string "radius" 1.0 xml_attrs in
        let image =
          match primitive with
          | Some img -> Some (HMagick.image_edge img ~radius)
          | None -> None
        in
        image

    | Xmlerr.Tag ("shade", xml_attrs) ->
        let gray = param_default_get bool_of_string "gray" true xml_attrs in
        let azimuth = param_default_get float_of_string "azimuth" 1.0 xml_attrs in
        let elevation = param_default_get float_of_string "elevation" 1.0 xml_attrs in
        let image =
          match primitive with
          | Some img -> Some (HMagick.image_shade img ~gray ~azimuth ~elevation)
          | None -> None
        in
        image

    | Xmlerr.Tag ("emboss", xml_attrs) ->
        let radius = param_default_get float_of_string "radius" 1.0 xml_attrs in
        let sigma = param_default_get float_of_string "sigma" 1.0 xml_attrs in
        let image =
          match primitive with
          | Some img -> Some (HMagick.image_emboss img ~radius ~sigma)
          | None -> None
        in
        image

    | Xmlerr.Tag ("sharpen", xml_attrs) ->
        let radius = param_default_get float_of_string "radius" 1.0 xml_attrs in
        let sigma = param_default_get float_of_string "sigma" 1.0 xml_attrs in
        let image =
          match primitive with
          | Some img -> Some (HMagick.image_sharpen img ~radius ~sigma)
          | None -> None
        in
        image

    | Xmlerr.Tag ("spread", xml_attrs) ->
        let radius = param_default_get float_of_string "radius" 1.0 xml_attrs in
        let image =
          match primitive with
          | Some image -> Some (HMagick.image_spread image ~meth:Magick.Average ~radius)
          | None -> None
        in
        image

    | Xmlerr.Tag ("solarize", xml_attrs) ->
        let threshold = param_default_get float_of_string "threshold" 1.0 xml_attrs in
        begin match primitive with
        | Some image -> HMagick.image_solarize image ~threshold;
        | None -> ()
        end;
        primitive

    | Xmlerr.Tag ("equalize", xml_attrs) ->
        begin match primitive with
        | Some image -> HMagick.image_equalize image;
        | None -> ()
        end;
        primitive

    | Xmlerr.Tag ("despeckle", xml_attrs) ->
        let image =
          match primitive with
          | Some image -> Some (HMagick.image_despeckle image)
          | None -> None
        in
        image

    | Xmlerr.Tag ("blur", xml_attrs) ->
        let radius = param_default_get float_of_string "radius" 1.0 xml_attrs in
        let sigma = param_default_get float_of_string "sigma" 1.0 xml_attrs in
        let image =
          match primitive with
          | Some img -> Some (HMagick.image_blur img ~radius ~sigma)
          | None -> None
        in
        image

    | Xmlerr.Tag ("negate", xml_attrs) ->
        begin match primitive with
        | Some image -> HMagick.image_negate image;
        | None -> ()
        end;
        primitive

    | _ -> primitive
  in

  let rec aux_merge prim compose layers xt =
    Printf.printf "# entered-merge\n%!";
    match xt with
    | Xmlerr.ETag ("layer")::msl_image ->
        Printf.printf "# layer-end\n%!";
        let compose =
          match compose with
          | Some compose -> compose
          | None -> ""
        in
        begin match prim with
        | Some img -> aux_merge None None ((img, compose)::layers) msl_image
        | None -> aux_merge None None (layers) msl_image
        end;

    | (Xmlerr.Tag ("read", [("filename", filename)]))::msl_image ->
        Printf.printf "# layer-read: %s\n%!" filename;
        let image = HMagick.image_read filename in
        aux_merge (Some image) compose layers msl_image

    | Xmlerr.Tag ("layer", xml_attrs)::msl_image ->
        let compose = param_default_get id "compose" "" xml_attrs in
        Printf.printf "# caught-layer: '%s'\n%!" compose;
        aux_merge None (Some compose) layers msl_image

    | ((Xmlerr.Tag (filter_name, _)) as tag)::msl_image
      when List.mem filter_name filter_list ->
        Printf.printf "# layer-filter: %s\n%!" filter_name;
        let prim = apply_filter prim tag in
        aux_merge prim compose layers msl_image

    | (Xmlerr.Tag (filter_name, _))::msl_image ->
        Printf.printf "# layer-filter: %s (un-match-ed)\n%!" filter_name;
        aux_merge prim compose layers msl_image

    | (Xmlerr.ETag ("merge"))::msl_image ->
        Printf.printf "# merge-end\n%!";
        let layers = List.rev layers in
        let rec aux_compose layers =
          match layers with
          | (layer_0, _)::(layer_1, compose)::layers ->
              let compose = Magick.CompositeOp.of_string compose in
              HMagick.image_composite layer_0 layer_1 compose (0, 0);
              aux_compose ((layer_0, "")::layers)
          | (layer_0, _)::[] -> Some(layer_0)
          | [] -> None
        in
        let prim = aux_compose layers in
        (prim, msl_image)

    | [] ->
        Printf.printf "# list-end\n%!";
        (prim, [])

    | _::msl_image ->
        Printf.printf "# default-merge-loop\n%!";
        aux_merge prim compose layers msl_image

    (*
    | _ ->
        Printf.printf "# caught-default\n%!";
        (prim, [])
    *)
  in

  let rec aux_image primitive xt =
    Printf.printf "# entering-image\n%!";
    match xt with
    | (Xmlerr.Tag ("new", [("w", w); ("h", h);]))::xt ->

        let color = (65535, 65535, 65535, 65535) in
        Printf.printf "# image-new\n%!";
        let w = int_of_string w in
        let h = int_of_string h in
        let image = HMagick.new_image w h color in
        aux_image (Some image) xt

    | (Xmlerr.Tag ("read", [("filename", filename)]))::xt ->
        Printf.printf "# image-read\n%!";
        let image = HMagick.image_read filename in
        aux_image (Some image) xt

    | (Xmlerr.Tag ("merge", []))::xt ->
        Printf.printf "# entering-merge\n%!";
        let primitive, xt = aux_merge None None [] xt in
        aux_image primitive xt

    | (Xmlerr.Tag ("write", xml_attrs))::xt ->
        let filename = param_default_get id "filename" "" xml_attrs in
        begin match primitive with
        | Some img -> HMagick.image_write img ~filename;
        | None -> ()
        end;
        aux_image primitive xt

    | ((Xmlerr.Tag (filter_name, xml_attrs)) as tag)::xt
      when List.mem filter_name filter_list ->
        let image = apply_filter primitive tag in
        aux_image image xt

    | (Xmlerr.Tag ("display", []))::xt ->
        begin match primitive with
          | Some img -> HMagick.image_display img;
          | None -> ()
        end;
        aux_image primitive xt

    | _::xt ->
        aux_image primitive xt

    | [] -> ()
  in
  let rec aux_msl xt =
    Printf.printf "# entering-msl\n%!";
    match xt with
    | Xmlerr.Tag ("image", _)::msl_image ->
        Printf.printf "# caught-image\n%!";
        aux_image None msl_image
    | xt ->
        Printf.printf "# default-caught\n%!";
        Xmlerr.print_code xt;
        ()
  in
  let rec aux xt =
    match xt with
    | (Xmlerr.Tag ("msl", _))::msl_xml -> aux_msl msl_xml
    (*
    | _::msl_xml -> aux_msl msl_xml
    *)
    | _ ->
        Printf.printf "# xml-un-caught\n%!";
        ()
  in
  aux xt
;;
