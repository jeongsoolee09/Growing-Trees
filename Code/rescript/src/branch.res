open Webapi.Canvas
open Belt

type t = {
  startX: float,
  startY: float,
  endX: float,
  endY: float,
  color: string,
  lineWidth: int,

  frame: int,
  cntFrame: int,

  gapX: float,
  gapY: float,

  currentX: float,
  currentY: float
}

let init = (startX, startY, endX, endY, lineWidth) : t => {
  let color = "#000000"
  let frame = 10
  let cntFrame = 0
  {
    startX: startX, startY: startY, endX: endX, endY: endY,
    color: color,
    lineWidth: lineWidth,
    frame: frame, cntFrame: cntFrame,
    gapX: endX -. startX /. Int.toFloat(frame),
    gapY: endY -. startY /. Int.toFloat(frame),
    currentX: startX, currentY: startY
  }
}

let draw = (ctx: Canvas2d.t, branch: t) : (t, bool) => {
  if branch.cntFrame == branch.frame {
    (branch, true)
  } else {
    Canvas2d.beginPath(ctx);

    let newCurrentX = branch.gapX
    let newCurrentY = branch.gapY

    Canvas2d.moveTo(ctx, ~x=branch.startX, ~y=branch.startY);
    Canvas2d.lineTo(ctx, ~x=newCurrentX, ~y=newCurrentY);


    Canvas2d.lineWidth(ctx, Int.toFloat(branch.lineWidth));
    Canvas2d.setFillStyle(ctx, Canvas2d.String, branch.color);
    Canvas2d.setStrokeStyle(ctx, Canvas2d.String, branch.color);

    Canvas2d.stroke(ctx);
    Canvas2d.closePath(ctx);

    let newBranch = {
      ...branch,
      currentX: branch.currentX +. branch.gapX,
      currentY: branch.currentY +. branch.gapY,
      cntFrame: branch.cntFrame + 1
    }

    (newBranch, false)
  }
}
