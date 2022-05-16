open Webapi.Canvas
open Belt


type t = {
  posX: float,
  posY: float,
  branches: list<list<Branch.t>>,
  depth: int,
  cntDepth: int,
}


let toString = (tree: t) : string => {
  let posX = Float.toString(tree.posX)
  let posY = Float.toString(tree.posY)
  let branches = Branch.llToString(tree.branches)
  j`<position: ($posX, $posY), branches: $branches>`
}


let append = (list1: list<'a>, list2: list<'a>) : list<'a> => {
  let rec inner = (acc, current) =>
      switch current {
          | list{} => acc
          | list{h, ...rest} => inner(List.add(acc, h), rest)
      }
  inner(list2, List.reverse(list1))
}


let makeDrawCallback = (tree : t, ctx: Canvas2d.t) : (float => unit) => {
  let drawCallback = (_ : float) : unit => {
    if tree.cntDepth == tree.depth {
      ()
    }

    let cntDepthRef = ref(tree.cntDepth)

    let rec drawBranchAndIncCntDepth = (ctx: Canvas2d.t, cntDepth: int, branches: list<Branch.t>) : int =>
        switch branches {
            | list{} => cntDepth
            | list{branch, ...rest} => {
              let (_, pass) = Branch.draw(ctx, branch)
              if !pass {
                cntDepth
              } else {
                drawBranchAndIncCntDepth(ctx, cntDepth+1, rest)
              }
            }
        }

    List.forEach(tree.branches, (branches) => {
      cntDepthRef := drawBranchAndIncCntDepth(ctx, cntDepthRef.contents, branches)
    })
  }
  drawCallback
}


let degToRad = (angle: float) : float =>
    (angle /. 180.) *. Js.Math._PI


let cos = (angle: float) : float =>
    angle
    -> degToRad
    -> cos


let sin = (angle: float) : float =>
    angle
    -> degToRad
    -> sin



let random = (min: int, max: int) : float =>
    Float.fromInt(min +
                  Js.Math.floor_int(Js.Math.random() *.
                                    (Float.fromInt (max - min + 1))))


let init = (posX, posY) : t => {
  let currDepth = 11
  let cntDepth = 0

  let rec createBranch = (startX, startY, angle, depth, acc): list<list<Branch.t>> =>
      if depth == currDepth {
        List.reverse(acc)
      } else {
        let len = depth == 0 ? random(10, 13) : random(0, 11)
        let endX = startX +. cos(angle) *. len *. (Float.fromInt (depth - currDepth))
        let endY = startY +. sin(angle) *. len *. (Float.fromInt (depth - currDepth))

        let newBranch = Branch.init(startX, startY, endX, endY, depth - currDepth)
        let newAcc = List.add(acc, list{newBranch})
        let newBranches1 = createBranch(endX, endY, angle -. random(15, 23), depth+1, newAcc)
        let newBranches2 = createBranch(endX, endY, angle +. random(15, 23), depth+1, newAcc)
        append(newBranches1, newBranches2)
      }

  let branches = createBranch(posX, posY, -90., 0, list{})

  {
    posX: posX,
    posY: posY,
    branches: branches,
    depth: currDepth,
    cntDepth: cntDepth
  }
}
