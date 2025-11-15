const std = @import("std");
const rl = @import("raylib");

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 400;
const BASE_FONT_SIZE: f32 = 60;
const SCROLL_SPEED: f32 = 0.5;
const STAR_COUNT = 100;

pub fn main() !void {
    rl.SetConfigFlags(rl.FLAG_MSAA_4X_HINT);
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Ray Wars Opening Crawl in Zig,   <SPACE>:Start / Stop, <R>:Restart");
    rl.SetTargetFPS(60);

    var stars: [STAR_COUNT]rl.Vector2 = undefined;
    var starSizes: [STAR_COUNT]f32 = undefined;

    // Generate random stars
    for (0..STAR_COUNT) |i| {
        const rx = rl.GetRandomValue(0, SCREEN_WIDTH);
        const ry = rl.GetRandomValue(0, SCREEN_HEIGHT);
        stars[i].x = @as(f32, @floatFromInt(rx));
        stars[i].y = @as(f32, @floatFromInt(ry));
        const rs = rl.GetRandomValue(5, 10);
        starSizes[i] = @as(f32, @floatFromInt(rs)) / 10.0;
    }

    // Text lines
    const textLines = [_][:0]const u8{
        "Epic I",
        "THE CODING ADVENTURE",
        "",
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
        "",
    };

    var textTextures: [textLines.len]rl.RenderTexture2D = undefined;

    for (textLines, 0..) |line, i| {
        if (line[0] == 0) {
            textTextures[i] = rl.RenderTexture2D{
                .id = 0,
                .texture = rl.Texture2D{ .id = 0 },
                .depth = rl.Texture2D{ .id = 0 },
            };
            continue;
        }

        const fontSize: f32 = if (i == 0) BASE_FONT_SIZE * 2 else BASE_FONT_SIZE;
        const textWidth = rl.MeasureText(line, @intFromFloat(fontSize));
        const textHeight = @as(c_int, @intFromFloat(fontSize + 10));

        if (textWidth <= 0 or textHeight <= 0) {
            textTextures[i] = rl.RenderTexture2D{
                .id = 0,
                .texture = rl.Texture2D{ .id = 0 },
                .depth = rl.Texture2D{ .id = 0 },
            };
            continue;
        }

        const tex = rl.LoadRenderTexture(textWidth, textHeight);
        rl.BeginTextureMode(tex);
        rl.ClearBackground(rl.BLANK);

        const color = if (i == 0 or i == 2)
            rl.YELLOW
        else
            rl.Color{ .r = 255, .g = 232, .b = 31, .a = 255 };

        rl.DrawText(line, 0, 0, @intFromFloat(fontSize), color);
        rl.EndTextureMode();
        rl.SetTextureFilter(tex.texture, rl.TEXTURE_FILTER_BILINEAR);
        textTextures[i] = tex;
    }

    const camera = rl.Camera3D{
        .position = rl.Vector3{ .x = 0, .y = 0, .z = 0 },
        .target = rl.Vector3{ .x = 0, .y = 0, .z = -1 },
        .up = rl.Vector3{ .x = 0, .y = 1, .z = 0 },
        .fovy = 45.0,
        .projection = rl.CAMERA_PERSPECTIVE,
    };

    var scrollOffset: f32 = 0.0;
    var paused: bool = false;

    while (!rl.WindowShouldClose()) {
        // Check for space key (pause/resume)
        if (rl.IsKeyPressed(rl.KEY_SPACE)){
            paused = ! paused;
        }
        // Check for R key (restart)
        if (rl.IsKeyPressed(rl.KEY_R)) {
          scrollOffset = 0.0;
          paused = false;
        }
        // Update scroll position (only if not paused)
        if (!paused) {
            scrollOffset += SCROLL_SPEED * rl.GetFrameTime();
        }
        if (scrollOffset > @as(f32, @floatFromInt(textLines.len)) * 0.8 + 10.0)
            scrollOffset = 0.0;

        rl.BeginDrawing();
        rl.ClearBackground(rl.BLACK);

        // Draw stars
        for (0..STAR_COUNT) |i| {
            rl.DrawCircle(
                @intFromFloat(stars[i].x),
                @intFromFloat(stars[i].y),
                starSizes[i],
                rl.WHITE,
            );
        }

        rl.BeginMode3D(camera);

        for (textLines, 0..) |_, i| {
            if (textTextures[i].id == 0) continue;

            const texWidth: f32 = @as(f32, @floatFromInt(textTextures[i].texture.width));
            const texHeight: f32 = @as(f32, @floatFromInt(textTextures[i].texture.height));
            const lineOffset: f32 = scrollOffset - @as(f32, @floatFromInt(i)) * 0.55;

            if (lineOffset > -2.0 and lineOffset < 15.0) {
                rl.rlPushMatrix();

                const moveY = lineOffset * 0.866;
                const moveZ = -lineOffset * 0.5;
                rl.rlTranslatef(0.0, -3.0 + moveY, -5.0 + moveZ);
                rl.rlRotatef(-70.0, 1.0, 0.0, 0.0);

                const planeWidth = texWidth / 100.0;
                const planeHeight = texHeight / 100.0;

                var alpha: f32 = 1.0;
                if (lineOffset > 5.0)
                    alpha = 1.0 - ((lineOffset - 5.0) / 3.0);
                if (lineOffset < 1.0)
                    alpha = lineOffset;
                if (alpha < 0.0) alpha = 0.0;
                if (alpha > 1.0) alpha = 1.0;

                rl.rlSetTexture(textTextures[i].texture.id);
                rl.rlBegin(rl.RL_QUADS);
                rl.rlColor4f(1.0, 1.0, 1.0, alpha);

                rl.rlTexCoord2f(0.0, 0.0);
                rl.rlVertex3f(-planeWidth / 2, 0.0, 0.0);
                rl.rlTexCoord2f(1.0, 0.0);
                rl.rlVertex3f(planeWidth / 2, 0.0, 0.0);
                rl.rlTexCoord2f(1.0, 1.0);
                rl.rlVertex3f(planeWidth / 2, planeHeight, 0.0);
                rl.rlTexCoord2f(0.0, 1.0);
                rl.rlVertex3f(-planeWidth / 2, planeHeight, 0.0);

                rl.rlEnd();
                rl.rlSetTexture(0);
                rl.rlPopMatrix();
            }
        }

        rl.EndMode3D();
        rl.EndDrawing();
    }

    rl.CloseWindow();
}
