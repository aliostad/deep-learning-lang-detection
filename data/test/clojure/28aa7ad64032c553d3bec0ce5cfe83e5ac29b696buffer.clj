(ns alchemy.gui.lwjgl.buffer
  (:import [org.lwjgl.opengl GL15 GL20 GL30])
  (:require [alchemy.gui.lwjgl.vertex :as vertex]
            [alchemy.entity :as entity]))

;; fns for tracking which data is being used by opengl

(defn add-buffer
  "adds an entity buffer"
  [time buffers entity]
  (let [vao-id (vertex/gen-vao-id)]
    (vertex/with-vao vao-id
      (let [vbo-id (vertex/gen-vbo-id)]
        (vertex/with-vbo vbo-id
          (vertex/add-vertices-to-buffer (entity/position entity time))
          (vertex/add-buffer-to-vertex-attributes))
        ;; add buffer meta data for the entity
        (assoc buffers (:id entity) {:type (:type entity)
                                     :vao-id vao-id
                                     :vbo-id vbo-id})))))

(defn update-buffer
  "updates an entity buffer"
  [time buffers entity]
  ;; if we have valid buffers and entity
  (when (and (seq buffers) entity)
    (let [buffer (buffers (:id entity))]
      (vertex/with-vbo (:vbo-id buffer)
        (vertex/update-vertices-in-buffer (entity/position entity time))))))

(defn remove-buffer
  "removes an entity buffer"
  [buffers id]
  (let [buffer (buffers id)
        vbo-id (:vbo-id buffer)
        vao-id (:vao-id buffer)]
    ;; disable buffer index from array attrib list
    (GL20/glDisableVertexAttribArray 0)
    ;; delete buffer
    (GL15/glBindBuffer GL15/GL_ARRAY_BUFFER 0)
    (GL15/glDeleteBuffers vbo-id)
    ;; delete array
    (GL30/glBindVertexArray 0)
    (GL30/glDeleteVertexArrays vao-id)
    ;; remove from buffers
    (dissoc buffers id)))

(defn not-contains?
  "fixed not contains? for lazy and key seqs"
  [col x]
  (not-any? #(= x %) col))

(defn manage-buffers
  "manages opengl vertex array/buffer objects"
  [state buffers]
  (let [time (:time state)
        entities (vals (:entities state))
        buffer-keys (keys buffers)
        ;; remove missing entities from buffers
        removed-ids (filter #(not-contains? (map :id entities) %) buffer-keys)
        buffers (reduce remove-buffer buffers removed-ids)
        ;; update existing buffers that remain
        _ (doseq [entity entities] (update-buffer time buffers entity))
        ;; add new entities to buffers
        new-entities (filter #(not-contains? buffer-keys (:id %)) entities)
        buffers (reduce (partial add-buffer time) buffers new-entities)]
    buffers))
