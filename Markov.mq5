#include <MarkovTrend.mqh>
#include <CSVFile.mqh>

void OnStart()
{
    CMarkovTrend Chain;
    
    int numBars = Bars(NULL, PERIOD_D1);
    if(numBars <= 0) Print("Error");
    else if(numBars > 252) numBars = 252;
    
    string fileName = "usdjpy20d.csv";
    string columnNames[10] = {"Date",
                "UpUp", "UpZeroplus", "UpDown",
                "ZeroplusUp", "ZeroplusZeroplus", "ZeroplusDown",
                "DownUp", "DownZeroplus", "DownDown"};
    
    CCSVFile File(fileName, columnNames);
    
    for(int barIndex = 0; barIndex < numBars; barIndex++)
    {
        double transitionMatrix[][3];
        Chain.GetTransitionMatrix(barIndex, 4, transitionMatrix);
        if(!FileIsExist(fileName))
        {
            File.Create();
        }
        
        File.WriteArr(transitionMatrix);
    }
}