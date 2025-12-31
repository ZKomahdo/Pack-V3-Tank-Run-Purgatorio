stock GetRandomRGBColor(color[])
{
    new RED = GetRandomInt(0, 255);
    new BLUE = GetRandomInt(0, 255);
    new GREEN = GetRandomInt(0, 255);
    new ALPHA = GetRandomInt(190, 255);

    if(RED == BLUE && RED == GREEN && BLUE == RED && BLUE == GREEN && GREEN == RED && GREEN == BLUE)
    {
        GetRandomRGBColor(color);
    } else {
        color[0] = RED;
        color[1] = BLUE;
        color[2] = GREEN;
        color[3] = ALPHA;
    }
} 