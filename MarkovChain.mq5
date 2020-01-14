void OnStart()
{
    double close[];
    int copied = CopyClose(NULL, PERIOD_D1, 0, 20, close);
    
    double closeDifference[19];
    int closeState[19];
    int transitionMatrix[3][3];
    ArrayInitialize(transitionMatrix, 0);
    
    for(int i = 0; i < 19; i++)
    {
        closeDifference[i] = close[i + 1] - close[i];
        if(closeDifference[i] > 0.100) closeState[i] = 0;
        else if(closeDifference[i] <= 0.100 && closeDifference[i] >= -0.100) closeState[i] = 1;
        else if(closeDifference[i] < -0.100) closeState[i] = 2;
        
        if(i != 0)
        {
            if(closeState[i - 1] == 0)
            {
                if(closeState[i] == 0) transitionMatrix[0][0] += 1;
                else if(closeState[i] == 1) transitionMatrix[0][1] += 1;
                else if(closeState[i] == 2) transitionMatrix[0][2] += 1;
            }
            else if(closeState[i -1] == 1)
            {
                if(closeState[i] == 0) transitionMatrix[1][0] += 1;
                else if(closeState[i] == 1) transitionMatrix[1][1] += 1;
                else if(closeState[i] == 2) transitionMatrix[1][2] += 1;
            }
            else if(closeState[i - 1] == 2)
            {
                if(closeState[i] == 0) transitionMatrix[2][0] += 1;
                else if(closeState[i] == 1) transitionMatrix[2][1] += 1;
                else if(closeState[i] == 2) transitionMatrix[2][2] += 1;
            }
        }
    }
    
    ArrayPrint(closeState);
    ArrayPrint(transitionMatrix);
    
    double upTotal = transitionMatrix[0][0] + transitionMatrix[0][1] + transitionMatrix[0][2];
    double zeroPlusTotal = transitionMatrix[1][0] + transitionMatrix[1][1] + transitionMatrix[1][2];
    double downTotal = transitionMatrix[2][0] + transitionMatrix[2][1] + transitionMatrix[2][2];
    
    double transitionProbabilityMatrix[3][3];
    for(int i = 0; i < 3; i++)
    {
        transitionProbabilityMatrix[0][i] = transitionMatrix[0][i] / upTotal;
        transitionProbabilityMatrix[1][i] = transitionMatrix[1][i] / zeroPlusTotal;
        transitionProbabilityMatrix[2][i] = transitionMatrix[2][i] / downTotal;
    }
    
    
    
    ArrayPrint(transitionProbabilityMatrix);
}