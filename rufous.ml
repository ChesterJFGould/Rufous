module type Rufous = sig
  type 'a r

  type 'msg html

  val text : string r -> 'msg html r

  type ('model, 'msg) program

  val string : string -> string r

  val program : 'model r -> ('model r -> 'msg html r) -> ('msg r -> 'model r -> 'model r) -> ('model, 'msg) program
end

module type Browser = sig
  module Js : sig
    type 'a v
    type 'a s

    val (let*) : 'a s -> ('a v -> 'b s) -> 'b s
    val return : 'a v -> 'a s

    module Html : sig
      type html

      val create_element : string v -> html s
      val set_text : html v -> string v -> unit s
      val children : html v -> html list s
      val clear_children : html v -> unit s
      val append_child : html v -> html v -> unit s
    end

    val string : string -> string v
    val int : int -> int v
    val unit : unit v
    val abs : ('d v -> 'c s) -> ('d -> 'c) v
    val app : ('d -> 'c) v -> 'd v -> 'c s
  end

  module Html : sig
    type html

    type attr

    val text : string -> html
    val node : string -> attr list -> html list
    val script : string -> attr list -> unit Js.s -> html
  end

  type page

  val page : Html.html -> page
end

module RufousBrowser(B : Browser) : Rufous with type 'a r = 'a B.Js.v = struct
  open B

  type 'a r = 'a Js.v

  type 'msg html = Js.Html.html -> unit

  let text s = Js.abs (fun n -> Js.Html.set_text n s)

  type ('msg, 'model) program = unit Js.s

  let string s = Js.string s

  let program _ _ _ = Js.return Js.unit
end
