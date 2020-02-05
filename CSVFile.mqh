class CCSVFile
{
    public:
        void CCSVFile(string fileName, string &colNames[]);
        void Create();
        void WriteArr(double &arr[][3]);
    
    private:
        string name;
        int handle;
        string columnNames[];
};

void CCSVFile::CCSVFile(string fileName, string &colNames[])
{
    name = fileName;
    ArrayCopy(columnNames, colNames, 0, 0, WHOLE_ARRAY);
}

void CCSVFile::Create()
{
    handle = FileOpen(name, FILE_READ|FILE_WRITE|FILE_CSV);
    
    int numCols = ArraySize(columnNames);
    string names = columnNames[0];
    for(int c = 1; c < numCols; c++) names += "\t" + columnNames[c];
    
    FileWrite(handle, names);
    FileClose(handle);
}

void CCSVFile::WriteArr(double &arr[][3])
{
    handle = FileOpen(name, FILE_READ|FILE_WRITE|FILE_CSV);
    FileSeek(handle, 0, SEEK_END);
    
    string msg = (string)arr[0][0];
    for(int r = 0; r < 3; r++)
    {
        if(r == 0)
        {
            for(int c = 1; c < 3; c++) msg += "\t" + (string)arr[r][c];
        }
        else
        {
            for(int c = 0; c < 3; c++) msg += "\t" + (string)arr[r][c];;
        }
    }
    
    FileWrite(handle, msg);
    FileClose(handle);
}