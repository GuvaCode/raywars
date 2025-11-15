# raywars.nim
# 3D Star Wars Opening Crawl with textured planes

import raylib
import rlgl
import random

const
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 400
  BASE_FONT_SIZE = 60
  SCROLL_SPEED = 0.5
  STAR_COUNT = 100

# Text content
let textLines = [
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
  ""
]

#------
# main
#------
proc main() =
  # Initialize window
  setConfigFlags(flags(Msaa4xHint))
  initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Ray Wars Opening Crawl in Nim,    <SPACE>:Start / Stop, <R>:Restart")
  setTargetFPS(60)

  # Generate random stars
  var
    stars: array[STAR_COUNT, Vector2]
    starSizes: array[STAR_COUNT, float32]

  for i in 0..<STAR_COUNT:
    stars[i] = Vector2(x: rand(0..SCREEN_WIDTH).float32, y: rand(0..SCREEN_HEIGHT).float32)
    starSizes[i] = rand(5..10).float32 / 10.0f

  # Create textures for each line
  var textTextures: seq[RenderTexture2D] = @[]
  for i, line in textLines:
    if line.len == 0:
      textTextures.add(RenderTexture2D(id: 0, texture: Texture2D(id: 0), depth: Texture2D(id: 0)))
      continue

    let fontSize = if i == 0: BASE_FONT_SIZE * 2 else: BASE_FONT_SIZE
    let textWidth = measureText(line, fontSize.int32)
    let textHeight = (fontSize + 10).int32

    if textWidth <= 0 or textHeight <= 0:
      textTextures.add(RenderTexture2D(id: 0, texture: Texture2D(id: 0), depth: Texture2D(id: 0)))
      continue

    var tex = loadRenderTexture(textWidth, textHeight)
    beginTextureMode(tex)
    clearBackground(BLANK)
    let color = if i == 0 or i == 2: YELLOW else: Color(r: 255, g: 232, b: 31, a: 255)
    drawText(line, 0, 0, fontSize.int32, color)
    endTextureMode()
    setTextureFilter(tex.texture, TextureFilter.Bilinear)
    textTextures.add(tex)

  # 3D Camera
  var camera = Camera3D(
    position: Vector3(x: 0.0f, y: 0.0f, z: 0.0f),
    target: Vector3(x: 0.0f, y: 0.0f, z: -1.0f),
    up: Vector3(x: 0.0f, y: 1.0f, z: 0.0f),
    fovy: 45.0f,
    projection: CameraProjection.Perspective
  )

  var scrollOffset = 0.0f
  var paused = false

  # Main loop
  while not windowShouldClose():
    # Check for space key (pause/resume)
    if isKeyPressed(Space):
      paused = not paused

    # Check for R key (restart)
    if isKeyPressed(R):
      scrollOffset = 0.0
      paused = false

    # Update scroll position (only if not paused)
    if not paused:
      scrollOffset += SCROLL_SPEED * getFrameTime()

    if scrollOffset > textLines.len.float32 * 0.8f + 10.0f:
      scrollOffset = 0.0f

    beginDrawing()
    clearBackground(BLACK)

    # Draw stars
    for i in 0..<STAR_COUNT:
      drawCircle(stars[i].x.int32, stars[i].y.int32, starSizes[i], WHITE)

    # 3D Mode
    beginMode3D(camera)

    for i in 0..<textLines.len:
      if textTextures[i].id == 0:
        continue

      let texWidth  = textTextures[i].texture.width.float32
      let texHeight = textTextures[i].texture.height.float32
      let lineOffset = scrollOffset - i.float32 * 0.55f

      if lineOffset > -2.0f and lineOffset < 15.0f:
        pushMatrix()

        let moveY = lineOffset * 0.866f
        let moveZ = -lineOffset * 0.5f
        translatef(0.0f, -3.0f + moveY, -5.0f + moveZ)
        rotatef(-70.0f, 1.0f, 0.0f, 0.0f)

        let planeWidth = texWidth / 100.0f
        let planeHeight = texHeight / 100.0f

        var alpha = 1.0f
        if lineOffset > 5.0f:
          alpha = 1.0f - ((lineOffset - 5.0f) / 3.0f)
        if lineOffset < 1.0f:
          alpha = lineOffset
        alpha = clamp(alpha, 0.0f, 1.0f)

        setTexture(textTextures[i].texture.id)
        rlBegin(QUADS)
        color4f(1.0f, 1.0f, 1.0f, alpha)

        texCoord2f(0.0f, 0.0f); vertex3f(-planeWidth/2, 0.0f, 0.0f)
        texCoord2f(1.0f, 0.0f); vertex3f( planeWidth/2, 0.0f, 0.0f)
        texCoord2f(1.0f, 1.0f); vertex3f( planeWidth/2, planeHeight, 0.0f)
        texCoord2f(0.0f, 1.0f); vertex3f(-planeWidth/2, planeHeight, 0.0f)

        rlEnd()
        setTexture(0)
        popMatrix()

    endMode3D()
    endDrawing()

#end while
  closeWindow()

#------
# main
#------
main()
