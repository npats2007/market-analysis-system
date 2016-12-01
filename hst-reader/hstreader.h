#ifndef HSTREADER_H
#define HSTREADER_H

#include <QObject>
#include <QVector>

typedef struct HeaderBytes     // Total 148 bytes
{
    qint32  Version;        // database version - 400 or 401 = 4 bytes
    QChar Copyright[64];    // copyright info = 64 bytes
    QChar Symbol[12];       // symbol name = 12 bytes
    qint32 Period;          // symbol timeframe	= 4 bytes
    qint32 Digits;          // the amount of digits after decimal point	= 4 bytes
    qint32 TimeSign;        // timesign of the database creation = 4 bytes
    qint32 LastSync;        // the last synchronization time = 4 bytes
    QChar  Unused[52];      // to be used in future	= 52 bytes
} HeaderBytes;
typedef struct HistoryBytes    // Total 60 bytes (version 401)
{
    qint64 Time;            // bar start time = 8 bytes
    double Open;            // open price = 8 bytes
    double High;            // highest price = 8 bytes
    double Low;             // lowest price = 8 bytes
    double Close;           // close price = 8 bytes
    qint64 Volume;          // tick count = 8 bytes
    qint32 Spread;          // spread = 4 bytes
    qint64 RealVolume;      // real volume = 8 bytes
} HistoryBytes;
typedef struct HistoryBytes400  // Total 44 bytes (version 400)
{
    qint32 Time;            // bar start time = 4 bytes
    double Open;            // open price = 8 bytes
    double Low;             // lowest price = 8 bytes
    double High;            // highest price = 8 bytes
    double Close;           // close price = 8 bytes
    double Volume;          // tick count = 8 bytes
} HistoryBytes400;

class HstReader : public QObject
{
    Q_OBJECT
public:
    explicit HstReader(QObject *parent = 0);
    HstReader(QString fName);
    ~HstReader();

private:
    HeaderBytes header;
    std::vector<HistoryBytes*> historyVector;
    std::vector<HistoryBytes400*> historyVector400;

    uint historySize;
    int historyVersion;

    QString fileName;
    bool fileExists;

public slots:
    void setFileName(QString fName);
    QString getFileName() const;
    uint getHistorySize() const;
    int getHistoryVersion() const;

    bool readFromFile();
    //bool readFromFile(QString fName);
    //bool readFromFile(uint histSize);
    //bool readFromFile(uint startPosition, uint stopPosition);

    //bool readHeader();
    //bool readHistory(uint *pos);
    HeaderBytes *getHeaderStruct();
    QString getHeaderString() const;

    std::vector<HistoryBytes*> *getHistoryVector();
    QString getHistoryString(uint numberPosition) const;
};

#endif // HSTREADER_H