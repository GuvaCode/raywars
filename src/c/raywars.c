#include "raylib.h"
#include "raymath.h"
#include <stdio.h>

int main(void)
{
    const int screenWidth = 800;
    const int screenHeight = 400;
    SetWindowState(FLAG_MSAA_4X_HINT);
    InitWindow(screenWidth, screenHeight, "RayWars Opening Crawl v0.1");

    // Text content
    const char* text[] = {
        "Episode I",
        "",
        "",
        "THE CODING ADVENTURE",
        "",
        "In a galaxy powered by code,",
        "brave programmers unite to",
        "build incredible software",
        "that brings joy to users",
        "across the digital realm.",
        "",
        "Armed with keyboards and",
        "determination, these heroes",
        "debug complex systems and",
        "craft elegant solutions to",
        "seemingly impossible",
        "technical challenges.",
        "",
        "Now, a new generation of",
        "developers embarks on an",
        "epic quest to master the",
        "ancient art of programming,",
        "seeking to create applications",
        "that will shape the future",
        "of technology forever....",
        ""
    };
    int textCount = sizeof(text) / sizeof(text[0]);

    float scrollOffset = screenHeight;
    float scrollSpeed = 30.0f;

    // Generate random star positions
    Vector2 stars[100];
    float starSizes[100];
    for (int i = 0; i < 100; i++)
    {
        stars[i].x = GetRandomValue(0, screenWidth);
        stars[i].y = GetRandomValue(0, screenHeight);
        starSizes[i] = GetRandomValue(5, 10) / 10.0f; // 0.5 to 1.0 pixels
    }

    // Create textures with large font size
    const int baseFontSize = 80;
    RenderTexture2D textTextures[sizeof(text) / sizeof(text[0])];
    for (int i = 0; i < textCount; i++)
    {
        int textWidth = MeasureText(text[i], baseFontSize);
        int textHeight = baseFontSize + 10;
        if (textWidth > 0 && textHeight > 0)
        {
            textTextures[i] = LoadRenderTexture(textWidth, textHeight);
            BeginTextureMode(textTextures[i]);
            ClearBackground(BLANK);
            Color textColor = (i == 0 || i == 2) ? YELLOW : (Color){255, 232, 31, 255};
            DrawText(text[i], 0, 0, baseFontSize, textColor);
            EndTextureMode();
            // Set texture filtering to bilinear (reduces flickering)
            SetTextureFilter(textTextures[i].texture, TEXTURE_FILTER_BILINEAR);
        }
    }

    SetTargetFPS(60);

    while (!WindowShouldClose())
    {
        // Update
        scrollOffset -= scrollSpeed * GetFrameTime();

        // Reset when the last text goes above the screen
        float totalHeight = textCount * 60;
        if (scrollOffset + totalHeight < -100)
        {
            scrollOffset = screenHeight;
        }

        // Draw
        BeginDrawing();
        ClearBackground(BLACK);

        // Starfield effect
        for (int i = 0; i < 100; i++)
        {
            DrawCircle((int)stars[i].x, (int)stars[i].y, starSizes[i], WHITE);
        }

        // Draw text with perspective (45-degree tilt)
        float currentY = scrollOffset;
        for (int i = 0; i < textCount; i++)
        {
            float yPos = currentY;
            if (yPos > -100 && yPos < screenHeight + 100)
            {
                // Perspective: bottom of screen is near (large), top is far (small)
                float distanceFromBottom = screenHeight - yPos;
                float perspective = 1.0f - (distanceFromBottom / (screenHeight * 1.5f));
                perspective = Clamp(perspective, 0.3f, 1.0f);

                int textWidth = textTextures[i].texture.width;
                int textHeight = textTextures[i].texture.height;

                // Scale calculation
                float scale = perspective;
                float scaledWidth = (screenWidth * 0.9f) * scale;
                float scaledHeight = (textHeight / (float)textWidth) * scaledWidth;

                // Compress Y coordinate heavily (enhances 45-degree tilt effect)
                // Set vanishing point at 1/4 from the top of the screen
                float vanishingPoint = screenHeight * 0.25f;
                float compressedY = screenHeight - distanceFromBottom * (1.0f - vanishingPoint / screenHeight);

                // Center horizontally
                float xPos = (screenWidth - scaledWidth) / 2.0f;

                // Alpha (fade out near the top of the screen)
                float alpha = perspective;
                // Fade out near the vanishing point
                if (compressedY < vanishingPoint + 50)
                {
                    float fadeDistance = 50.0f;
                    float fadeAmount = (compressedY - (vanishingPoint - fadeDistance)) / (fadeDistance * 2);
                    fadeAmount = Clamp(fadeAmount, 0.0f, 1.0f);
                    alpha *= fadeAmount;
                }

                Rectangle source = {0, 0, (float)textWidth, -(float)textHeight};
                Rectangle dest = {xPos, compressedY, scaledWidth, scaledHeight};
                Color tint = WHITE;
                tint.a = (unsigned char)(alpha * 255);

                DrawTexturePro(textTextures[i].texture, source, dest, (Vector2){0, 0}, 0.0f, tint);
            }
            // Calculate position for the next line
            currentY += 60;
        }

        EndDrawing();
    }

    // Unload textures
    for (int i = 0; i < textCount; i++)
    {
        UnloadRenderTexture(textTextures[i]);
    }

    CloseWindow();
    return 0;
}
