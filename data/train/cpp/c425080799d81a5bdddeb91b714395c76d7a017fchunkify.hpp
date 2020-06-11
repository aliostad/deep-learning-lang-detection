#ifndef DSTORM_FITWINDOW_CHUNKIFY_HPP
#define DSTORM_FITWINDOW_CHUNKIFY_HPP

#include "fit_window/chunkify.h"

namespace dStorm {
namespace fit_window {

inline void chunkify_base(const fit_window::Plane& input, nonlinfit::plane::GenericData& output) {
    output.pixel_size = input.pixel_size;
    for (int d = 0; d < 2; ++d) {
        output.min[d] = input.min_coordinate[d];
        output.max[d] = input.max_coordinate[d];
    }
}

template <bool NeedLogOutput, typename Number, int ChunkSize>
void chunkify(const fit_window::Plane& input, nonlinfit::plane::DisjointData<Number, ChunkSize>& output) {
    chunkify_base(input, output);
    int chunk_count = input.points.size() / ChunkSize;
    assert(input.window_width == ChunkSize);
    assert(input.points.size() % ChunkSize == 0);

    output.data.resize(chunk_count);
    for (int chunk = 0; chunk < chunk_count; ++chunk) {
        output.data[chunk].inputs[0] = input.points[chunk * ChunkSize].position.y();
    }
    for (int i = 0; i < ChunkSize; ++i) {
        output.xs[i] = input.points[i].position.x();
    }

    for (int chunk = 0; chunk < chunk_count; ++chunk) {
        for (int i = 0; i < ChunkSize; ++i) {
            const DataPoint& point = input.points[chunk * ChunkSize + i];
            assert(std::abs(output.data[chunk].inputs[0] - point.position.y()) < 1E-10);
            assert(std::abs(output.xs[i] - point.position.x()) < 1E-10);
            output.data[chunk].output[i] = point.value;
            output.data[chunk].background[i] = point.background;
            if (NeedLogOutput) {
                output.data[chunk].logoutput[i] =
                    (point.value < 1E-10) ? -23*point.value : log(point.value);
            }
            output.data[chunk].residues[i] = 0;
        }
    }
}

template <bool NeedLogOutput, typename Number, int ChunkSize>
void chunkify(const fit_window::Plane& input, nonlinfit::plane::JointData<Number, ChunkSize>& output) {
    chunkify_base(input, output);
    int chunk_count = input.points.size() / ChunkSize;
    if (ChunkSize > 1 && input.points.size() % ChunkSize >= ChunkSize / 2) {
        chunk_count += 1;
    }

    output.data.resize(chunk_count);
    for (int chunk = 0; chunk < chunk_count; ++chunk) {
        for (int i = 0; i < ChunkSize; ++i) {
            const DataPoint& point = input.points[(chunk * ChunkSize + i) % input.points.size()];
            output.data[chunk].inputs(i, 0) = point.position.x();
            output.data[chunk].inputs(i, 1) = point.position.y();
            output.data[chunk].output[i] = point.value;
            output.data[chunk].background[i] = point.background;
            if (NeedLogOutput) {
                output.data[chunk].logoutput[i] =
                    (point.value < 1E-10) ? -23*point.value : log(point.value);
            }
            output.data[chunk].residues[i] = 0;
        }
    }
}

}
}

#endif
