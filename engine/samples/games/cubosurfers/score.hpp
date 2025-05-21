#pragma once

#include <cubos/engine/prelude.hpp>

struct Score
{
    CUBOS_REFLECT;
    float value = 0.0f;
    bool persistent = false;
};

void scorePlugin(cubos::engine::Cubos& cubos);
