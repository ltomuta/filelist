/**
 * Copyright (c) 2011-2012 Nokia Corporation.
 */

#ifndef FILEHELPER_H
#define FILEHELPER_H

// Qt includes
#include <QObject>
#include <QUrl>


class FileHelper : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString phoneMemoryImagesPath READ phoneMemoryImagesPath NOTIFY phoneMemoryImagesPathChanged)
    Q_PROPERTY(QString phoneMemorySoundsPath READ phoneMemorySoundsPath NOTIFY phoneMemorySoundsPathhanged)
    Q_PROPERTY(QString phoneMemoryVideosPath READ phoneMemoryVideosPath NOTIFY phoneMemoryVideosPathChanged)
    Q_PROPERTY(QString memoryCardImagesPath READ memoryCardImagesPath NOTIFY memoryCardImagesPathChanged)
    Q_PROPERTY(QString memoryCardSoundsPath READ memoryCardSoundsPath NOTIFY memoryCardSoundsPathChanged)
    Q_PROPERTY(QString memoryCardVideosPath READ memoryCardVideosPath NOTIFY memoryCardVideosPathChanged)

    Q_PROPERTY(bool memoryCardPresent READ memoryCardPresent NOTIFY memoryCardPresentChanged)

public: // Construction and destruction
    explicit FileHelper(QObject *parent = 0);
    virtual ~FileHelper();

public: // Property accessors
    QString phoneMemoryImagesPath() const;
    QString phoneMemorySoundsPath() const;
    QString phoneMemoryVideosPath() const;
    QString memoryCardImagesPath() const;
    QString memoryCardSoundsPath() const;
    QString memoryCardVideosPath() const;

    bool memoryCardPresent();

public:
    Q_INVOKABLE QUrl pathUrl(const QString &path) const;
    Q_INVOKABLE QString size(const QUrl &filePath) const;
    Q_INVOKABLE QString created(const QUrl &filePath) const;
    Q_INVOKABLE QString phoneMemoryFreeAndTotalSpace() const;
    Q_INVOKABLE QString memoryCardFreeAndTotalSpace() const;
    Q_INVOKABLE QString urlToLocalFile(const QUrl &url) const;
    Q_INVOKABLE bool isDirEmpty(const QUrl &url) const;

public slots:
    bool openUrl(const QUrl &url) const;

protected:
    QString formattedSize(qint64 bytes) const;
    bool getFreeSpaceAndTotalSpace(qint64 &free,
                                   qint64 &total,
                                   bool phoneMemory) const;

protected slots:
    void resolvePaths();

#ifdef Q_OS_SYMBIAN
private:
    QString descriptorToString(const TDesC &desc) const;
    TInt driveEnum(const QString &drive) const;
#endif

signals:
    void phoneMemoryImagesPathChanged(QString path);
    void phoneMemorySoundsPathhanged(QString path);
    void phoneMemoryVideosPathChanged(QString path);
    void memoryCardImagesPathChanged(QString path);
    void memoryCardSoundsPathChanged(QString path);
    void memoryCardVideosPathChanged(QString path);

    void memoryCardPresentChanged(bool present);

protected: // Data
    QString m_phoneMemoryImagesPath;
    QString m_phoneMemorySoundsPath;
    QString m_phoneMemoryVideosPath;
    QString m_memoryCardImagesPath;
    QString m_memoryCardSoundsPath;
    QString m_memoryCardVideosPath;
};

#endif // FILEHELPER_H

// End of file.
