#include "world_view.hpp"

WorldView::WorldView(World *world)
        : world(world) {
    for (Chunk *chunk : world->chunks) {
        chunk_views.push_back(new ChunkView(chunk));
    }
}

WorldView::~WorldView() {
    for (ChunkView *chunk_view : chunk_views) {
        delete chunk_view;
    }
    chunk_views.clear();
}

void WorldView::gl_init() {
    for (ChunkView *chunk_view : chunk_views) {
        chunk_view->gl_init();
    }

    list = GL::GenLists(1);
    GL::NewList(list, GL_COMPILE);
    for (ChunkView *chunk_view : chunk_views) {
        chunk_view->display();
    }
    GL::EndList();
}

void WorldView::display() {
    GL::CallList(list);
}
