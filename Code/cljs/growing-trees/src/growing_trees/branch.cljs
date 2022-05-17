(ns growing-trees.branch)

(def color "#000000")

(def frame 10)

(defn make [startX startY endX endY lineWidth]
  {:startX startX :startY startY
   :endX endX :endY endY
   :color color
   :lineWidth lineWidth
   :frame frame})

(defn draw [branch ctx]
  (dotimes [_ (branch :frame)]
    (do
      (js/.beginPath ctx)
      (js/.moveTo ctx (branch :startX) (branch :startY))
      (let [gapX (/ (- (branch :endX) (branch :startX)) frame)
            gapY (/ (- (branch :endY) (branch :startY)) frame)]
        (js/.lineTo ctx
                    (+ (branch :startX) gapX)
                    (+ (branch :startY) gapY)))
      (set! (.-lineWidth ctx) (branch :lineWidth))
      (set! (.-fillstyle ctx) (branch :color))
      (set! (.-strokeStyle ctx) (branch :color))
      (js/.stroke ctx)
      (js/.closePath ctx))))
