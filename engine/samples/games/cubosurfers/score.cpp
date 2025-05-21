#include "score.hpp"

#include <cubos/core/ecs/reflection.hpp>
#include <cubos/core/reflection/external/primitives.hpp>

#include <cubos/engine/imgui/plugin.hpp>

using namespace cubos::engine;

CUBOS_REFLECT_IMPL(Score)
{
    return cubos::core::ecs::TypeBuilder<Score>("Score").withField("value", &Score::value).build();
}

void scorePlugin(Cubos& cubos)
{
    cubos.depends(imguiPlugin);

    // Register the component
    cubos.component<Score>();

    // System to update score with a clear window
    cubos.system("update score").tagged(imguiTag).call([](const DeltaTime& dt, Query<Score&> scores, Commands cmds) {
        // Begin a window with a clear title and fixed position
        ImGui::SetNextWindowPos(ImVec2(10, 10), ImGuiCond_Once);
        ImGui::SetNextWindowSize(ImVec2(200, 80), ImGuiCond_Once);
        ImGui::Begin("Game Score", nullptr, ImGuiWindowFlags_NoCollapse);

        if (!scores.empty())
        {
            for (auto [score] : scores)
            {
                // Update score
                score.value += dt.value();

                // Display score prominently
                ImGui::TextColored(ImVec4(1, 1, 0, 1), "Score: %.0f", score.value);
            }
        }
        else
        {
            auto builder = cmds.create();
            builder.add<Score>(Score{});
        }

        ImGui::End();
    });

    // Create the Score entity in a startup system
    cubos.startupSystem("spawn score entity").call([](Commands cmds) {
        // Directly create the score entity
        auto builder = cmds.create();
        builder.add<Score>(Score{});
    });
}
