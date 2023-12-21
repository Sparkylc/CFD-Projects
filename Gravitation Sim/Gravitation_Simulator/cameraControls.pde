PVector offset;

//worldX and Y are the world coordinates, while screenX and Y are the screen coordinates
void worldToScreen(PVector worldSpace, PVector screenSpace)
    {
        screenSpace = PVector.sub(worldSpace, offset);
    }
void screenToWorld(PVector screenSpace, PVector worldSpace)
    {
        worldSpace = PVector.add(screenSpace, offset);
    }