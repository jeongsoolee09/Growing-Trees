open Belt
open Webapi.Dom
open Webapi.Canvas

@val external devicePixelRatio : int = "window.devicePixelRatio"


let documentBody : Dom.element =
  document
  -> Document.asHtmlDocument
  -> Option.getExn
  -> HtmlDocument.body
  -> Option.getExn

let canvas = Document.createElement(document, "canvas")

let ctx = CanvasElement.getContext2d(canvas)


let resizeHandler = (_: Event.t) : unit => {
  let stageWidth = Element.clientWidth(documentBody)
  let stageHeight = Element.clientHeight(documentBody)

  CanvasElement.setWidth(canvas, stageWidth)
  CanvasElement.setHeight(canvas, stageHeight)

  Canvas2d.scale(ctx, ~x=1., ~y=1.);
  Canvas2d.clearRect(ctx, ~x=0., ~y=0.,
                     ~w=Float.fromInt(stageWidth),
                     ~h=Float.fromInt(stageHeight));
}


module MouseEvent = MouseEvent.Impl(Event)


let clickHandler = (event: Event.t) : unit => {
  let clientX =
    event
    -> MouseEvent.clientX
    -> Float.fromInt
  let stageHeight =
    documentBody
    -> Element.clientHeight
    -> Float.fromInt
  let tree = Tree.init(clientX, stageHeight)
  let callback = Tree.makeDrawCallback(tree, ctx)
  Webapi.requestAnimationFrame(callback)
}


let main = (event: Event.t) : unit => {
  Element.appendChild(documentBody, ~child=canvas)

  Window.addEventListener(window, "resize", resizeHandler)
  Window.addEventListener(window, "click", clickHandler)

  resizeHandler(event)
}


let () = Window.addEventListener(window, "load", main)
