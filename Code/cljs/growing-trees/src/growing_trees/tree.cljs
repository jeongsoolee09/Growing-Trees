(ns growing-trees.tree
  (:require [growing-trees.branch :as Branch]))

(def total-depth 11)

(defn degToRad [angle]
  (* (/ angle 180) Math/PI))

(defn cos [angle]
  (-> angle
      degToRad
      Math/cos))

(defn sin [angle]
  (-> angle
      degToRad
      Math/sin))

(defn random [min max]
  (+ min (Math/floor (* (Math/random)
                        (- max (+ min 1))))))

(defn make-initial-branch
  [total-depth startX startY angle]
  (let [len (random 10 13)
        current-depth 0
        newStartX startX
        newStartY startY
        newEndX (+ newStartX
                   (* (cos angle) len total-depth))
        newEndY (+ newStartY
                   (* (sin angle) len total-depth))]
    (Branch/make newStartX newStartY
                 newEndX newEndY
                 (+ (angle (random 15 23)) current-depth))))

(defn make-plus-branch
  "Kernel: Given a branch, make a plus-branch from it."
  [total-depth branch angle current-depth]
  (let [len (random 0 11)
        newStartX (branch :endX)
        newStartY (branch :endY)
        newEndX (+ newStartX
                   (* (cos angle) len (- total-depth current-depth)))
        newEndY (+ newStartY
                   (* (sin angle) len (- total-depth current-depth)))]
    (Branch/make newStartX newStartY
                 newEndX newEndY
                 (+ (angle (random 15 23)) current-depth))))

(defn make-minus-branch
  "Kernel: Given a branch, make a plus-branch from it."
  [total-depth branch angle current-depth]
  (let [len (random 0 11)
        newStartX (branch :endX)
        newStartY (branch :endY)
        newEndX (+ newStartX
                   (* (cos angle) len (- total-depth current-depth)))
        newEndY (+ newStartY
                   (* (sin angle) len (- total-depth current-depth)))]
    (Branch/make newStartX newStartY
                 newEndX newEndY
                 (- (angle (random 15 23)) (+ current-depth 1)))))

(defn make-new-branches [branches angle total-depth current-depth]
  (mapcat (fn [branch]
            [(make-plus-branch  total-depth branch angle current-depth)
             (make-minus-branch total-depth branch angle current-depth)]) branches))

(defn create-branches [total-depth startX startY angle]
  (loop [acc []
         current-depth 0]
    (recur (conj acc
                 (if (empty? acc)
                   [(make-initial-branch total-depth startX startY angle)]
                   (mapcat (fn [branch]
                             [(make-plus-branch total-depth branch angle current-depth)
                              (make-minus-branch total-depth branch angle current-depth)])
                           (last acc))))
           (+ current-depth 1))))

(defn make [posX posY]
  {:posX posX :posY posY
   :branches (create-branches total-depth posX posY -90)
   :depth total-depth
   :animation nil})

(defn draw [tree ctx]
  (let [animation (js/.requestAnimationFrame draw)]
    (loop [count-depth 0]
      (if (= count-depth total-depth)
        (js/.cancelAnimationFrame animation)
        (do
          (doseq
           [branch-list (tree :branches)
            branch branch-list]
            (Branch/draw branch ctx))
          (recur (+ count-depth 0)))))))
