void OnStart()
{
    double close[];
    int barsCopied = CopyClose(NULL, PERIOD_D1, 0, 20, close);
    if(barsCopied <= 0) Print("Error");
    
    double closeDifference[19];
    int closeState[19];
    int closeStateMatrix[3][3];
    ArrayInitialize(closeStateMatrix, 0);
    
    for(int i = 0; i < 19; i++)
    {
        closeDifference[i] = close[i + 1] - close[i];
        if(closeDifference[i] > 0.100) closeState[i] = 0;
        else if(closeDifference[i] <= 0.100 && closeDifference[i] >= -0.100) closeState[i] = 1;
        else if(closeDifference[i] < -0.100) closeState[i] = 2;
        
        if(i > 0)
        {
            if(closeState[i - 1] == 0)
            {
                if(closeState[i] == 0) closeStateMatrix[0][0] += 1;
                else if(closeState[i] == 1) closeStateMatrix[0][1] += 1;
                else if(closeState[i] == 2) closeStateMatrix[0][2] += 1;
            }
            else if(closeState[i -1] == 1)
            {
                if(closeState[i] == 0) closeStateMatrix[1][0] += 1;
                else if(closeState[i] == 1) closeStateMatrix[1][1] += 1;
                else if(closeState[i] == 2) closeStateMatrix[1][2] += 1;
            }
            else if(closeState[i - 1] == 2)
            {
                if(closeState[i] == 0) closeStateMatrix[2][0] += 1;
                else if(closeState[i] == 1) closeStateMatrix[2][1] += 1;
                else if(closeState[i] == 2) closeStateMatrix[2][2] += 1;
            }
        }
    }
    
    double upTotal = closeStateMatrix[0][0] + closeStateMatrix[0][1] + closeStateMatrix[0][2];
    double zeroPlusTotal = closeStateMatrix[1][0] + closeStateMatrix[1][1] + closeStateMatrix[1][2];
    double downTotal = closeStateMatrix[2][0] + closeStateMatrix[2][1] + closeStateMatrix[2][2];
    
    double transitionMatrix[3][3];
    for(int i = 0; i < 3; i++)
    {
        transitionMatrix[0][i] = closeStateMatrix[0][i] / upTotal;
        transitionMatrix[1][i] = closeStateMatrix[1][i] / zeroPlusTotal;
        transitionMatrix[2][i] = closeStateMatrix[2][i] / downTotal;
    }
    
    ArrayPrint(transitionMatrix);
    
    // Testing
}