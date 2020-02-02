

void OnStart()
{
    int numBars = Bars(NULL, PERIOD_D1);
    if(numBars <= 0) Print("Error");
    else if(numBars > 252) numBars = 252;
    
    for(int barIndex = 0; barIndex < numBars; barIndex++)
    {
        
        double close[];
        int barsCopied = CopyClose(NULL, PERIOD_D1, barIndex, 20, close);
        if(barsCopied <= 0) Print("Error");
        
        
        double closeDifference[19];
        
        int closeState[19];
        int closeStateMatrix[3][3];
        ArrayInitialize(closeState, 0);
        ArrayInitialize(closeStateMatrix, 0);
        
        
        for(int i = 0; i < 19; i++)
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
        Print("Here");
        ArrayPrint(closeDifference);
        ArrayPrint(closeState);
        double upTotal = closeStateMatrix[0][0] + closeStateMatrix[0][1] + closeStateMatrix[0][2];
        double zeroPlusTotal = closeStateMatrix[1][0] + closeStateMatrix[1][1] + closeStateMatrix[1][2];
        double downTotal = closeStateMatrix[2][0] + closeStateMatrix[2][1] + closeStateMatrix[2][2];
        
        double transitionMatrix[3][3];
        for(int i = 0; i < 3; i++)
        {
            if(upTotal == 0) transitionMatrix[0][i] = 0;
            else transitionMatrix[0][i] = closeStateMatrix[0][i] / upTotal;
            
            if(zeroPlusTotal == 0) transitionMatrix[1][i] = 0;
            else transitionMatrix[1][i] = closeStateMatrix[1][i] / zeroPlusTotal;
            
            if(downTotal == 0) transitionMatrix[2][i] = 0;
            else transitionMatrix[2][i] = closeStateMatrix[2][i] / downTotal;
        }
        
        string fileName = Symbol() + IntegerToString(20) + "d123.csv";
        if(!FileIsExist(fileName))
        {
            
            
            int fileHandle = FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV);
            FileSeek(fileHandle, 0, SEEK_END);
            
            FileWrite(fileHandle, "Date",
                "UpUp", "UpZeroplus", "UpDown",
                "ZeroplusUp", "ZeroplusZeroplus", "ZeroplusDown",
                "DownUp", "DownZeroplus", "DownDown");
            
            FileClose(fileHandle);
        }
        
        int fileHandle = FileOpen(fileName, FILE_READ|FILE_WRITE|FILE_CSV);
        FileSeek(fileHandle, 0, SEEK_END);
        
        FileWrite(fileHandle, iTime(NULL, PERIOD_D1, barIndex),
            transitionMatrix[0][0], transitionMatrix[0][1], transitionMatrix[0][2],
            transitionMatrix[1][0], transitionMatrix[1][1], transitionMatrix[1][2],
            transitionMatrix[2][0], transitionMatrix[2][1], transitionMatrix[2][2],
            "",
            closeStateMatrix[0][0], closeStateMatrix[0][1], closeStateMatrix[0][2],
            closeStateMatrix[1][0], closeStateMatrix[1][1], closeStateMatrix[1][2],
            closeStateMatrix[2][0], closeStateMatrix[2][1], closeStateMatrix[2][2],
            upTotal + zeroPlusTotal + downTotal);
        
        FileClose(fileHandle);
    }    
}