class CMarkovTrend
{
    public:
        void GetTransitionMatrix(int barIndex,int weeksRange, double &transitionMatrix[][3]);
    
    private:
        double close[];
        double closeDifference[];
        int closeState[];
        int closeStateMatrix[3][3];
        
        void GetWeeksClose(int barIndex, int weeksRange);
        void GetCloseStateMatrix();
};

void CMarkovTrend::GetWeeksClose(int barIndex,int weeksRange)
{
    int daysRange = weeksRange * 5;
    int barsCopied = CopyClose(NULL, PERIOD_D1, barIndex, daysRange, close);
    if(barsCopied <= 0) Print("Error");
}

void CMarkovTrend::GetCloseStateMatrix()
{
    int numClose = ArraySize(close);
    ArrayResize(closeDifference, numClose - 1);
    ArrayResize(closeState, numClose - 1);
    
    for(int i = 0; i < numClose - 1; i++)
    {
        closeDifference[i] = close[i + 1] - close[i];
        if(closeDifference[i] > 0.100) closeState[i] = 0;
        else if(closeDifference[i] >= -0.100 && closeDifference[i] <= 0.100) closeState[i] = 1;
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
}

void CMarkovTrend::GetTransitionMatrix(int barIndex,int weeksRange, double &transitionMatrix[][3])
{
    ArrayInitialize(close, 0);
    
    GetWeeksClose(barIndex, weeksRange);
    GetCloseStateMatrix();
    
    double upTotal = closeStateMatrix[0][0] + closeStateMatrix[0][1] + closeStateMatrix[0][2];
    double zeroPlusTotal = closeStateMatrix[1][0] + closeStateMatrix[1][1] + closeStateMatrix[1][2];
    double downTotal = closeStateMatrix[2][0] + closeStateMatrix[2][1] + closeStateMatrix[2][2];
    
    ArrayResize(transitionMatrix, 3);
    for(int i = 0; i < 3; i++)
    {
        if(upTotal == 0) transitionMatrix[0][i] = 0;
        else transitionMatrix[0][i] = closeStateMatrix[0][i] / upTotal;
        
        if(zeroPlusTotal == 0) transitionMatrix[1][i] = 0;
        else transitionMatrix[1][i] = closeStateMatrix[1][i] / zeroPlusTotal;
        
        if(downTotal == 0) transitionMatrix[2][i] = 0;
        else transitionMatrix[2][i] = closeStateMatrix[2][i] / downTotal;
    }
}