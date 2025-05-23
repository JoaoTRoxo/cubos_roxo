#include "obstacle.hpp"

#include <cubos/core/ecs/reflection.hpp>
#include <cubos/core/reflection/external/glm.hpp>
#include <cubos/core/reflection/external/primitives.hpp>
#include <cubos/core/reflection/external/string.hpp>

#include <cubos/engine/assets/plugin.hpp>
#include <cubos/engine/transform/plugin.hpp>

using namespace cubos::engine;

// Initialize static members
float Obstacle::speedMultiplier = 1.0F;
float Obstacle::speedIncreaseRate = 0.2F;

CUBOS_REFLECT_IMPL(Obstacle)
{
    return cubos::core::ecs::TypeBuilder<Obstacle>("Obstacle")
        .withField("velocity", &Obstacle::velocity)
        .withField("killZ", &Obstacle::killZ)
        .build();
}

void obstaclePlugin(Cubos& cubos)
{
    cubos.depends(assetsPlugin);
    cubos.depends(transformPlugin);

    cubos.component<Obstacle>();

    // Add a system to increase the speed over time
    cubos.system("increase game speed").call([](const DeltaTime& dt) {
        // Increase speed based on elapsed time
        Obstacle::speedMultiplier += Obstacle::speedIncreaseRate * dt.value();
    });

    cubos.system("move obstacles")
        .call([](Commands cmds, const DeltaTime& dt, Query<Entity, const Obstacle&, Position&> obstacles) {
            for (auto [ent, obstacle, position] : obstacles)
            {
                // Apply the speed multiplier to obstacle velocity
                position.vec += obstacle.velocity * Obstacle::speedMultiplier * dt.value();
                position.vec.y = glm::abs(glm::sin(position.vec.z * 0.15F)) * 1.5F;

                if (position.vec.z < obstacle.killZ)
                {
                    cmds.destroy(ent);
                }
            }
        });
}
