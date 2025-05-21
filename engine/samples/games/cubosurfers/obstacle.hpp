#pragma once

#include <glm/vec3.hpp>

#include <cubos/engine/prelude.hpp>

struct Obstacle
{
    CUBOS_REFLECT;

    glm::vec3 velocity{0.0F, 0.0F, -1.0F};
    float killZ{0.0F};

    // Add these new fields
    static float speedMultiplier;    // Shared speed multiplier for all obstacles
    static float speedIncreaseRate;  // How quickly speed increases per second
    static float maxSpeedMultiplier; // Cap for speed multiplier
    bool persistent = false;
};

void obstaclePlugin(cubos::engine::Cubos& cubos);
